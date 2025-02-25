#include <drivers/uart.h>
#include <drivers/bcm_aux.h>
#include <drivers/gpio.h>
#include <circularBuffer.h>
#include <interrupt_controller.h>

#include <stdstring.h>

CUART sUART0(sAUX);
#pragma pack(push,1)


union AUX_MU_IIR_REG_Flags {
  struct {
    uint8_t interrupt_pending : 1;
    uint8_t interrupt_identify : 2;
    uint8_t unused_0 : 1; 
    uint8_t unused_1_1 : 2;
    uint8_t fifo_enables : 2;
    uint32_t unused_2 : 24;
 } reg;
 uint32_t direct;
};

#pragma pack(pop)
#pragma pack(push,1)

struct AUX_MU_IER_REG_Flags
{
    uint8_t interrupt_receive_enable : 1;
    uint8_t interrupt_transmit_enable : 1;
    uint32_t unused_0 : 30; //Mozna tady bude treba nejak dodelat cteni/zapis na dva bity - https://elinux.org/BCM2835_datasheet_errata#p12
};
#pragma pack(pop)

CUART::CUART(CAUX& aux)
    : mAUX(aux), mOpened(false)
{
	spinlock_init(&mLock);
}


/**
 * Tries to read input from the UART. Read can be blocking if it is set to blocking via IOCTL.
 * 
 * If no data are available and read is non blocking, then char value of 255 is returned.
 */
char CUART::Read() {
    uint32_t c = 255;   

    if (isReadBlocking) {
        while (!(mAUX.Get_Register(hal::AUX_Reg::MU_LSR) & 0x01))
        ;
    }

    if (mAUX.Get_Register(hal::AUX_Reg::MU_LSR) & 0x01) { /* Read only if there are data waiting. In non blocking scenario we just want to skip the read if nothing is available. */
        c = mAUX.Get_Register(hal::AUX_Reg::MU_IO);
    }
    
    return (char) c; 
}


void CUART::Enable_Event_Detect(NUART_Interrupt_Type evtype)
{
    AUX_MU_IER_REG_Flags ier = *reinterpret_cast<AUX_MU_IER_REG_Flags*>(mAUX.Get_Register(hal::AUX_Reg::MU_IER));

    switch (evtype) {
        case NUART_Interrupt_Type::RX:
            //Only read the value from register, enable correct interrupt and put it back.
            ier.interrupt_receive_enable = 1;
            break;

        case NUART_Interrupt_Type::TX:
            ier.interrupt_transmit_enable = 1;
            break;
    }

    mAUX.Set_Register(hal::AUX_Reg::MU_IER, *reinterpret_cast<unsigned int*>(&ier));
    
	sInterruptCtl.Enable_IRQ(hal::IRQ_Source::UART);
    sInterruptCtl.Enable_IRQ(hal::IRQ_Source::AUX);
}

void CUART::Disable_Event_Detect(NUART_Interrupt_Type evtype)
{
    AUX_MU_IER_REG_Flags ier = *reinterpret_cast<AUX_MU_IER_REG_Flags*>(mAUX.Get_Register(hal::AUX_Reg::MU_IER));

    switch (evtype) {
        case NUART_Interrupt_Type::RX:
            ier.interrupt_receive_enable = 0;
            break;

        case NUART_Interrupt_Type::TX:
            ier.interrupt_transmit_enable = 0;
            break;
    }

    mAUX.Set_Register(hal::AUX_Reg::MU_IER, *reinterpret_cast<unsigned int*>(&ier));

}

bool CUART::Open()
{
    // TODO: zamek, aby se neco neseslo

    if (mOpened)
        return false;

    // rezervujeme si TX a RX piny, exkluzivne pro nas (R i W, ackoliv je jeden jen vstupni a jeden jen vystupni)
    if (!sGPIO.Reserve_Pin(14, true, true))
        return false;

    if (!sGPIO.Reserve_Pin(15, true, true))
    {
        sGPIO.Free_Pin(14, true, true);
        return false;
    }

    mAUX.Enable(hal::AUX_Peripherals::MiniUART);
    mAUX.Set_Register(hal::AUX_Reg::MU_IIR, 0);
    mAUX.Set_Register(hal::AUX_Reg::MU_IER, 0);
    mAUX.Set_Register(hal::AUX_Reg::MU_MCR, 0);
    mAUX.Set_Register(hal::AUX_Reg::MU_CNTL, 3); // RX and TX enabled

    // nastavime GPIO 14 a 15 na jejich alt funkci 5, coz je UART kanal 1
    sGPIO.Set_GPIO_Function(14, NGPIO_Function::Alt_5);
    sGPIO.Set_GPIO_Function(15, NGPIO_Function::Alt_5);

    mOpened = true;

    // nastavime vychozi rychlost a velikost znaku
    Set_Char_Length(NUART_Char_Length::Char_8);
    Set_Baud_Rate(NUART_Baud_Rate::BR_9600);

    return true;
}

void CUART::Close()
{
    if (!mOpened)
        return;

    // zakazeme AUX periferii
    mAUX.Disable(hal::AUX_Peripherals::MiniUART);

    // piny 14 a 15 prepneme na Input (tak zerou nejmin proudu)
    sGPIO.Set_GPIO_Function(14, NGPIO_Function::Input);
    sGPIO.Set_GPIO_Function(15, NGPIO_Function::Input);

    // uvolnime piny
    sGPIO.Free_Pin(14, true, true);
    sGPIO.Free_Pin(15, true, true);

    mOpened = false;
}

bool CUART::Is_Opened() const
{
    return mOpened;
}

NUART_Char_Length CUART::Get_Char_Length()
{
    if (!mOpened)
        return NUART_Char_Length::Char_8;

    return static_cast<NUART_Char_Length>(mAUX.Get_Register(hal::AUX_Reg::MU_LCR) & 0x1);
}

void CUART::Set_Char_Length(NUART_Char_Length len)
{
    if (!mOpened)
        return;

    mAUX.Set_Register(hal::AUX_Reg::MU_LCR, (mAUX.Get_Register(hal::AUX_Reg::MU_LCR) & 0xFFFFFFFE) | static_cast<unsigned int>(len));
}

NUART_Read_Blocking CUART::Get_Read_Blocking() {
    if (isReadBlocking) {
        return NUART_Read_Blocking::Blocking;
    }

    return NUART_Read_Blocking::NonBlocking;
}

void CUART::Set_Read_Blocking(NUART_Read_Blocking blocking) {
    if (blocking == NUART_Read_Blocking::Blocking) {
        isReadBlocking = true;
    } else {
        isReadBlocking = false;
    }
}

NUART_Baud_Rate CUART::Get_Baud_Rate()
{
    if (!mOpened)
        return NUART_Baud_Rate::BR_1200;

    return mBaud_Rate;
}

void CUART::Set_Baud_Rate(NUART_Baud_Rate rate)
{
    if (!mOpened)
        return;

    mBaud_Rate = rate;

    const unsigned int val = ((hal::Default_Clock_Rate / static_cast<unsigned int>(rate)) / 8) - 1;

    mAUX.Set_Register(hal::AUX_Reg::MU_CNTL, 0);

    mAUX.Set_Register(hal::AUX_Reg::MU_BAUD, val);

    mAUX.Set_Register(hal::AUX_Reg::MU_CNTL, 3);
}

//C3 counter only
bool CUART::Is_IRQ_Pending()
{
    if (!mOpened)
        return false;

    //If 1 is present in the register, then the interrupt is pending
    AUX_MU_IIR_REG_Flags iir;
    iir.direct = mAUX.Get_Register(hal::AUX_Reg::MU_IIR);

    return !iir.reg.interrupt_pending;
}

void CUART::Write(char c)
{
    if (!mOpened)
        return;

    // dokud ma status registr priznak "vystupni fronta plna", nelze prenaset dalsi bit
    while (!(mAUX.Get_Register(hal::AUX_Reg::MU_LSR) & (1 << 5)))
        ;

    mAUX.Set_Register(hal::AUX_Reg::MU_IO, c);
}

void CUART::Write(const char* str)
{
    if (!mOpened)
        return;

    int i;

    for (i = 0; str[i] != '\0'; i++)
        Write(str[i]);
}

void CUART::Write(const char* str, unsigned int len)
{
    if (!mOpened)
        return;

    unsigned int i;

    for (i = 0; i < len; i++)
        Write(str[i]);
}

void CUART::Write(unsigned int num)
{
    if (!mOpened)
        return;

    static char buf[16];

    itoa(num, buf, 10);
    Write(buf);
}

void CUART::Write_Hex(unsigned int num)
{
    if (!mOpened)
        return;

    static char buf[16];

    itoa(num, buf, 16);
    Write(buf);
}

void CUART::Wait_For_Event(IFile* file) {
    spinlock_lock(&mLock);
    UARTWaiting_File* wf = new UARTWaiting_File;
    wf->file = file;
    wf->prev = nullptr;
    wf->next = uWaiting_Files;

    uWaiting_Files = wf;

    spinlock_unlock(&mLock);
}

void CUART::Handle_IRQ(){
	char c = sUART0.Read();
    
    if (c == 255) { //Read failed.
        return;
    }

    uartBuffer.write(c);
    sUART0.Write(c);
    

    UARTWaiting_File* wf, *tmpwf;

    spinlock_lock(&mLock);

	// is there waiting process here
	wf = uWaiting_Files;
	while (wf != nullptr)
	{

		// wake process
		wf->file->Notify(NotifyAll);

		// link list linking

		if (wf->prev)
			wf->prev->next = wf->next;
		if (wf->next)
			wf->next->prev = wf->prev;

		tmpwf = wf;

		if (uWaiting_Files == wf)
			uWaiting_Files = wf->next;

		wf = wf->next;

		delete tmpwf;
		
	}

	spinlock_unlock(&mLock);
	
	// clear event -> dont get stuck on loop
    
    AUX_MU_IIR_REG_Flags iir;
    iir.reg.interrupt_pending = 1;

    mAUX.Set_Register(hal::AUX_Reg::MU_IIR, iir.direct);
}