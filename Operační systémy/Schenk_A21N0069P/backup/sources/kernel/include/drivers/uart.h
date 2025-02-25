#pragma once

#include <hal/peripherals.h>
#include <fs/filesystem.h>
#include <drivers/bcm_aux.h>
#include <drivers/bridges/uart_defs.h>
#include <process/spinlock.h>
#include <circularBuffer.h>

class CUART
{
    private:
        // odkaz na AUX driver
        CAUX& mAUX;

        // byl UART kanal otevreny?
        bool mOpened;

        // nastavena baud rate, ukladame ji proto, ze do registru se uklada (potencialne ztratovy) prepocet
        NUART_Baud_Rate mBaud_Rate;

        struct UARTWaiting_File {
            IFile* file;
            UARTWaiting_File* prev;
            UARTWaiting_File* next;
        };

        UARTWaiting_File* uWaiting_Files;
        spinlock_t mLock;
		
		bool isReadBlocking = true;




    public:
        CUART(CAUX& aux);

        Circular_Buffer uartBuffer;

		
        NUART_Read_Blocking Get_Read_Blocking();
        void Set_Read_Blocking(NUART_Read_Blocking blocking);
        // otevre UART kanal, exkluzivne
        bool Open();
        // uzavre UART kanal, uvolni ho pro ostatni
        void Close();
        // je UART kanal momentalne otevreny?
        bool Is_Opened() const;

        NUART_Char_Length Get_Char_Length();
        void Set_Char_Length(NUART_Char_Length len);

        NUART_Baud_Rate Get_Baud_Rate();
        void Set_Baud_Rate(NUART_Baud_Rate rate);

        // miniUART na RPi0 nepodporuje nic moc jineho uzitecneho, napr. paritni bity, vice stop-bitu nez 1, atd.		
		void Write(char c);
        void Write(const char* str);
        void Write(const char* str, unsigned int len);
        void Write(unsigned int num);
        void Write_Hex(unsigned int num);

        char Read();

        //IRQ Handling
        void Enable_Event_Detect(NUART_Interrupt_Type evtype);
        void Disable_Event_Detect(NUART_Interrupt_Type evtype);
		bool Is_IRQ_Pending();
        void Wait_For_Event(IFile* file);
        void Handle_IRQ();

};

extern CUART sUART0;
