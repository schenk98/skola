
./sos_task:     file format elf32-littlearm


Disassembly of section .text:

00008000 <_start>:
_start():
/home/schenkj/os2022/sp/sources/userspace/crt0.s:10
;@ startovaci symbol - vstupni bod z jadra OS do uzivatelskeho programu
;@ v podstate jen ihned zavola nejakou C funkci, nepotrebujeme nic tak kritickeho, abychom to vsechno museli psal v ASM
;@ jen _start vlastne ani neni funkce, takze by tento vstupni bod mel byt psany takto; rovnez je treba se ujistit, ze
;@ je tento symbol relokovany spravne na 0x8000 (tam OS ocekava, ze se nachazi vstupni bod)
_start:
    bl __crt0_run
    8000:	eb00001a 	bl	8070 <__crt0_run>

00008004 <_hang>:
_hang():
/home/schenkj/os2022/sp/sources/userspace/crt0.s:13
    ;@ z funkce __crt0_run by se nemel proces uz vratit, ale kdyby neco, tak se zacyklime
_hang:
    b _hang
    8004:	eafffffe 	b	8004 <_hang>

00008008 <__crt0_init_bss>:
__crt0_init_bss():
/home/schenkj/os2022/sp/sources/userspace/crt0.c:10

extern unsigned int __bss_start;
extern unsigned int __bss_end;

void __crt0_init_bss()
{
    8008:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    800c:	e28db000 	add	fp, sp, #0
    8010:	e24dd00c 	sub	sp, sp, #12
/home/schenkj/os2022/sp/sources/userspace/crt0.c:11
    unsigned int* begin = (unsigned int*)__bss_start;
    8014:	e59f304c 	ldr	r3, [pc, #76]	; 8068 <__crt0_init_bss+0x60>
    8018:	e5933000 	ldr	r3, [r3]
    801c:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/userspace/crt0.c:12
    for (; begin < (unsigned int*)__bss_end; begin++)
    8020:	ea000005 	b	803c <__crt0_init_bss+0x34>
/home/schenkj/os2022/sp/sources/userspace/crt0.c:13 (discriminator 2)
        *begin = 0;
    8024:	e51b3008 	ldr	r3, [fp, #-8]
    8028:	e3a02000 	mov	r2, #0
    802c:	e5832000 	str	r2, [r3]
/home/schenkj/os2022/sp/sources/userspace/crt0.c:12 (discriminator 2)
    for (; begin < (unsigned int*)__bss_end; begin++)
    8030:	e51b3008 	ldr	r3, [fp, #-8]
    8034:	e2833004 	add	r3, r3, #4
    8038:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/userspace/crt0.c:12 (discriminator 1)
    803c:	e59f3028 	ldr	r3, [pc, #40]	; 806c <__crt0_init_bss+0x64>
    8040:	e5933000 	ldr	r3, [r3]
    8044:	e1a02003 	mov	r2, r3
    8048:	e51b3008 	ldr	r3, [fp, #-8]
    804c:	e1530002 	cmp	r3, r2
    8050:	3afffff3 	bcc	8024 <__crt0_init_bss+0x1c>
/home/schenkj/os2022/sp/sources/userspace/crt0.c:14
}
    8054:	e320f000 	nop	{0}
    8058:	e320f000 	nop	{0}
    805c:	e28bd000 	add	sp, fp, #0
    8060:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8064:	e12fff1e 	bx	lr
    8068:	00009024 	andeq	r9, r0, r4, lsr #32
    806c:	0000903c 	andeq	r9, r0, ip, lsr r0

00008070 <__crt0_run>:
__crt0_run():
/home/schenkj/os2022/sp/sources/userspace/crt0.c:17

void __crt0_run()
{
    8070:	e92d4800 	push	{fp, lr}
    8074:	e28db004 	add	fp, sp, #4
    8078:	e24dd008 	sub	sp, sp, #8
/home/schenkj/os2022/sp/sources/userspace/crt0.c:19
    // inicializace .bss sekce (vynulovani)
    __crt0_init_bss();
    807c:	ebffffe1 	bl	8008 <__crt0_init_bss>
/home/schenkj/os2022/sp/sources/userspace/crt0.c:22

    // volani konstruktoru globalnich trid (C++)
    _cpp_startup();
    8080:	eb000040 	bl	8188 <_cpp_startup>
/home/schenkj/os2022/sp/sources/userspace/crt0.c:27

    // volani funkce main
    // nebudeme se zde zabyvat predavanim parametru do funkce main
    // jinak by se mohly predavat napr. namapovane do virtualniho adr. prostoru a odkazem pres zasobnik (kam nam muze OS pushnout co chce)
    int result = main(0, 0);
    8084:	e3a01000 	mov	r1, #0
    8088:	e3a00000 	mov	r0, #0
    808c:	eb000089 	bl	82b8 <main>
    8090:	e50b0008 	str	r0, [fp, #-8]
/home/schenkj/os2022/sp/sources/userspace/crt0.c:30

    // volani destruktoru globalnich trid (C++)
    _cpp_shutdown();
    8094:	eb000051 	bl	81e0 <_cpp_shutdown>
/home/schenkj/os2022/sp/sources/userspace/crt0.c:33

    // volani terminate() syscallu s navratovym kodem funkce main
    asm volatile("mov r0, %0" : : "r" (result));
    8098:	e51b3008 	ldr	r3, [fp, #-8]
    809c:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/userspace/crt0.c:34
    asm volatile("svc #1");
    80a0:	ef000001 	svc	0x00000001
/home/schenkj/os2022/sp/sources/userspace/crt0.c:35
}
    80a4:	e320f000 	nop	{0}
    80a8:	e24bd004 	sub	sp, fp, #4
    80ac:	e8bd8800 	pop	{fp, pc}

000080b0 <__cxa_guard_acquire>:
__cxa_guard_acquire():
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:11
	extern "C" int __cxa_guard_acquire (__guard *);
	extern "C" void __cxa_guard_release (__guard *);
	extern "C" void __cxa_guard_abort (__guard *);

	extern "C" int __cxa_guard_acquire (__guard *g)
	{
    80b0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80b4:	e28db000 	add	fp, sp, #0
    80b8:	e24dd00c 	sub	sp, sp, #12
    80bc:	e50b0008 	str	r0, [fp, #-8]
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:12
		return !*(char *)(g);
    80c0:	e51b3008 	ldr	r3, [fp, #-8]
    80c4:	e5d33000 	ldrb	r3, [r3]
    80c8:	e3530000 	cmp	r3, #0
    80cc:	03a03001 	moveq	r3, #1
    80d0:	13a03000 	movne	r3, #0
    80d4:	e6ef3073 	uxtb	r3, r3
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:13
	}
    80d8:	e1a00003 	mov	r0, r3
    80dc:	e28bd000 	add	sp, fp, #0
    80e0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    80e4:	e12fff1e 	bx	lr

000080e8 <__cxa_guard_release>:
__cxa_guard_release():
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:16

	extern "C" void __cxa_guard_release (__guard *g)
	{
    80e8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80ec:	e28db000 	add	fp, sp, #0
    80f0:	e24dd00c 	sub	sp, sp, #12
    80f4:	e50b0008 	str	r0, [fp, #-8]
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:17
		*(char *)g = 1;
    80f8:	e51b3008 	ldr	r3, [fp, #-8]
    80fc:	e3a02001 	mov	r2, #1
    8100:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:18
	}
    8104:	e320f000 	nop	{0}
    8108:	e28bd000 	add	sp, fp, #0
    810c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8110:	e12fff1e 	bx	lr

00008114 <__cxa_guard_abort>:
__cxa_guard_abort():
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:21

	extern "C" void __cxa_guard_abort (__guard *)
	{
    8114:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8118:	e28db000 	add	fp, sp, #0
    811c:	e24dd00c 	sub	sp, sp, #12
    8120:	e50b0008 	str	r0, [fp, #-8]
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:23

	}
    8124:	e320f000 	nop	{0}
    8128:	e28bd000 	add	sp, fp, #0
    812c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8130:	e12fff1e 	bx	lr

00008134 <__dso_handle>:
__dso_handle():
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:27
}

extern "C" void __dso_handle()
{
    8134:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8138:	e28db000 	add	fp, sp, #0
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:29
    // ignore dtors for now
}
    813c:	e320f000 	nop	{0}
    8140:	e28bd000 	add	sp, fp, #0
    8144:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8148:	e12fff1e 	bx	lr

0000814c <__cxa_atexit>:
__cxa_atexit():
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:32

extern "C" void __cxa_atexit()
{
    814c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8150:	e28db000 	add	fp, sp, #0
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:34
    // ignore dtors for now
}
    8154:	e320f000 	nop	{0}
    8158:	e28bd000 	add	sp, fp, #0
    815c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8160:	e12fff1e 	bx	lr

00008164 <__cxa_pure_virtual>:
__cxa_pure_virtual():
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:37

extern "C" void __cxa_pure_virtual()
{
    8164:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8168:	e28db000 	add	fp, sp, #0
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:39
    // pure virtual method called
}
    816c:	e320f000 	nop	{0}
    8170:	e28bd000 	add	sp, fp, #0
    8174:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8178:	e12fff1e 	bx	lr

0000817c <__aeabi_unwind_cpp_pr1>:
__aeabi_unwind_cpp_pr1():
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:42

extern "C" void __aeabi_unwind_cpp_pr1()
{
    817c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8180:	e28db000 	add	fp, sp, #0
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:43 (discriminator 1)
	while (true)
    8184:	eafffffe 	b	8184 <__aeabi_unwind_cpp_pr1+0x8>

00008188 <_cpp_startup>:
_cpp_startup():
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:61
extern "C" dtor_ptr __DTOR_LIST__[0];
// konec pole destruktoru
extern "C" dtor_ptr __DTOR_END__[0];

extern "C" int _cpp_startup(void)
{
    8188:	e92d4800 	push	{fp, lr}
    818c:	e28db004 	add	fp, sp, #4
    8190:	e24dd008 	sub	sp, sp, #8
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:66
	ctor_ptr* fnptr;
	
	// zavolame konstruktory globalnich C++ trid
	// v poli __CTOR_LIST__ jsou ukazatele na vygenerovane stuby volani konstruktoru
	for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    8194:	e59f303c 	ldr	r3, [pc, #60]	; 81d8 <_cpp_startup+0x50>
    8198:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:66 (discriminator 3)
    819c:	e51b3008 	ldr	r3, [fp, #-8]
    81a0:	e59f2034 	ldr	r2, [pc, #52]	; 81dc <_cpp_startup+0x54>
    81a4:	e1530002 	cmp	r3, r2
    81a8:	2a000006 	bcs	81c8 <_cpp_startup+0x40>
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:67 (discriminator 2)
		(*fnptr)();
    81ac:	e51b3008 	ldr	r3, [fp, #-8]
    81b0:	e5933000 	ldr	r3, [r3]
    81b4:	e12fff33 	blx	r3
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:66 (discriminator 2)
	for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    81b8:	e51b3008 	ldr	r3, [fp, #-8]
    81bc:	e2833004 	add	r3, r3, #4
    81c0:	e50b3008 	str	r3, [fp, #-8]
    81c4:	eafffff4 	b	819c <_cpp_startup+0x14>
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:69
	
	return 0;
    81c8:	e3a03000 	mov	r3, #0
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:70
}
    81cc:	e1a00003 	mov	r0, r3
    81d0:	e24bd004 	sub	sp, fp, #4
    81d4:	e8bd8800 	pop	{fp, pc}
    81d8:	00009021 	andeq	r9, r0, r1, lsr #32
    81dc:	00009021 	andeq	r9, r0, r1, lsr #32

000081e0 <_cpp_shutdown>:
_cpp_shutdown():
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:73

extern "C" int _cpp_shutdown(void)
{
    81e0:	e92d4800 	push	{fp, lr}
    81e4:	e28db004 	add	fp, sp, #4
    81e8:	e24dd008 	sub	sp, sp, #8
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:77
	dtor_ptr* fnptr;
	
	// zavolame destruktory globalnich C++ trid
	for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    81ec:	e59f303c 	ldr	r3, [pc, #60]	; 8230 <_cpp_shutdown+0x50>
    81f0:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:77 (discriminator 3)
    81f4:	e51b3008 	ldr	r3, [fp, #-8]
    81f8:	e59f2034 	ldr	r2, [pc, #52]	; 8234 <_cpp_shutdown+0x54>
    81fc:	e1530002 	cmp	r3, r2
    8200:	2a000006 	bcs	8220 <_cpp_shutdown+0x40>
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:78 (discriminator 2)
		(*fnptr)();
    8204:	e51b3008 	ldr	r3, [fp, #-8]
    8208:	e5933000 	ldr	r3, [r3]
    820c:	e12fff33 	blx	r3
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:77 (discriminator 2)
	for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    8210:	e51b3008 	ldr	r3, [fp, #-8]
    8214:	e2833004 	add	r3, r3, #4
    8218:	e50b3008 	str	r3, [fp, #-8]
    821c:	eafffff4 	b	81f4 <_cpp_shutdown+0x14>
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:80
	
	return 0;
    8220:	e3a03000 	mov	r3, #0
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:81
}
    8224:	e1a00003 	mov	r0, r3
    8228:	e24bd004 	sub	sp, fp, #4
    822c:	e8bd8800 	pop	{fp, pc}
    8230:	00009021 	andeq	r9, r0, r1, lsr #32
    8234:	00009021 	andeq	r9, r0, r1, lsr #32

00008238 <_Z5blinkb>:
_Z5blinkb():
/home/schenkj/os2022/sp/sources/userspace/sos_task/main.cpp:23

uint32_t sos_led;
uint32_t button;

void blink(bool short_blink)
{
    8238:	e92d4800 	push	{fp, lr}
    823c:	e28db004 	add	fp, sp, #4
    8240:	e24dd008 	sub	sp, sp, #8
    8244:	e1a03000 	mov	r3, r0
    8248:	e54b3005 	strb	r3, [fp, #-5]
/home/schenkj/os2022/sp/sources/userspace/sos_task/main.cpp:24
	write(sos_led, "1", 1);
    824c:	e59f3058 	ldr	r3, [pc, #88]	; 82ac <_Z5blinkb+0x74>
    8250:	e5933000 	ldr	r3, [r3]
    8254:	e3a02001 	mov	r2, #1
    8258:	e59f1050 	ldr	r1, [pc, #80]	; 82b0 <_Z5blinkb+0x78>
    825c:	e1a00003 	mov	r0, r3
    8260:	eb0000b1 	bl	852c <_Z5writejPKcj>
/home/schenkj/os2022/sp/sources/userspace/sos_task/main.cpp:25
	sleep(short_blink ? 0x800 : 0x1000);
    8264:	e55b3005 	ldrb	r3, [fp, #-5]
    8268:	e3530000 	cmp	r3, #0
    826c:	0a000001 	beq	8278 <_Z5blinkb+0x40>
/home/schenkj/os2022/sp/sources/userspace/sos_task/main.cpp:25 (discriminator 1)
    8270:	e3a03b02 	mov	r3, #2048	; 0x800
    8274:	ea000000 	b	827c <_Z5blinkb+0x44>
/home/schenkj/os2022/sp/sources/userspace/sos_task/main.cpp:25 (discriminator 2)
    8278:	e3a03a01 	mov	r3, #4096	; 0x1000
/home/schenkj/os2022/sp/sources/userspace/sos_task/main.cpp:25 (discriminator 4)
    827c:	e3e01001 	mvn	r1, #1
    8280:	e1a00003 	mov	r0, r3
    8284:	eb000100 	bl	868c <_Z5sleepjj>
/home/schenkj/os2022/sp/sources/userspace/sos_task/main.cpp:26 (discriminator 4)
	write(sos_led, "0", 1);
    8288:	e59f301c 	ldr	r3, [pc, #28]	; 82ac <_Z5blinkb+0x74>
    828c:	e5933000 	ldr	r3, [r3]
    8290:	e3a02001 	mov	r2, #1
    8294:	e59f1018 	ldr	r1, [pc, #24]	; 82b4 <_Z5blinkb+0x7c>
    8298:	e1a00003 	mov	r0, r3
    829c:	eb0000a2 	bl	852c <_Z5writejPKcj>
/home/schenkj/os2022/sp/sources/userspace/sos_task/main.cpp:27 (discriminator 4)
}
    82a0:	e320f000 	nop	{0}
    82a4:	e24bd004 	sub	sp, fp, #4
    82a8:	e8bd8800 	pop	{fp, pc}
    82ac:	00009024 	andeq	r9, r0, r4, lsr #32
    82b0:	00008fac 	andeq	r8, r0, ip, lsr #31
    82b4:	00008fb0 			; <UNDEFINED> instruction: 0x00008fb0

000082b8 <main>:
main():
/home/schenkj/os2022/sp/sources/userspace/sos_task/main.cpp:30

int main(int argc, char** argv)
{
    82b8:	e92d4800 	push	{fp, lr}
    82bc:	e28db004 	add	fp, sp, #4
    82c0:	e24dd010 	sub	sp, sp, #16
    82c4:	e50b0010 	str	r0, [fp, #-16]
    82c8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/userspace/sos_task/main.cpp:31
	sos_led = open("DEV:gpio/18", NFile_Open_Mode::Write_Only);
    82cc:	e3a01001 	mov	r1, #1
    82d0:	e59f0134 	ldr	r0, [pc, #308]	; 840c <main+0x154>
    82d4:	eb00006f 	bl	8498 <_Z4openPKc15NFile_Open_Mode>
    82d8:	e1a03000 	mov	r3, r0
    82dc:	e59f212c 	ldr	r2, [pc, #300]	; 8410 <main+0x158>
    82e0:	e5823000 	str	r3, [r2]
/home/schenkj/os2022/sp/sources/userspace/sos_task/main.cpp:32
	button = open("DEV:gpio/16", NFile_Open_Mode::Read_Only);
    82e4:	e3a01000 	mov	r1, #0
    82e8:	e59f0124 	ldr	r0, [pc, #292]	; 8414 <main+0x15c>
    82ec:	eb000069 	bl	8498 <_Z4openPKc15NFile_Open_Mode>
    82f0:	e1a03000 	mov	r3, r0
    82f4:	e59f211c 	ldr	r2, [pc, #284]	; 8418 <main+0x160>
    82f8:	e5823000 	str	r3, [r2]
/home/schenkj/os2022/sp/sources/userspace/sos_task/main.cpp:34

	NGPIO_Interrupt_Type irtype = NGPIO_Interrupt_Type::Rising_Edge;
    82fc:	e3a03000 	mov	r3, #0
    8300:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/userspace/sos_task/main.cpp:35
	ioctl(button, NIOCtl_Operation::Enable_Event_Detection, &irtype);
    8304:	e59f310c 	ldr	r3, [pc, #268]	; 8418 <main+0x160>
    8308:	e5933000 	ldr	r3, [r3]
    830c:	e24b200c 	sub	r2, fp, #12
    8310:	e3a01002 	mov	r1, #2
    8314:	e1a00003 	mov	r0, r3
    8318:	eb0000a2 	bl	85a8 <_Z5ioctlj16NIOCtl_OperationPv>
/home/schenkj/os2022/sp/sources/userspace/sos_task/main.cpp:37

	uint32_t logpipe = pipe("log", 32);
    831c:	e3a01020 	mov	r1, #32
    8320:	e59f00f4 	ldr	r0, [pc, #244]	; 841c <main+0x164>
    8324:	eb000129 	bl	87d0 <_Z4pipePKcj>
    8328:	e50b0008 	str	r0, [fp, #-8]
/home/schenkj/os2022/sp/sources/userspace/sos_task/main.cpp:42 (discriminator 1)

	while (true)
	{
		// pockame na stisk klavesy
		wait(button, 1, 0x300);
    832c:	e59f30e4 	ldr	r3, [pc, #228]	; 8418 <main+0x160>
    8330:	e5933000 	ldr	r3, [r3]
    8334:	e3a02c03 	mov	r2, #768	; 0x300
    8338:	e3a01001 	mov	r1, #1
    833c:	e1a00003 	mov	r0, r3
    8340:	eb0000bd 	bl	863c <_Z4waitjjj>
/home/schenkj/os2022/sp/sources/userspace/sos_task/main.cpp:51 (discriminator 1)
		// 2) my mame deadline 0x300
		// 3) log task ma deadline 0x1000
		// 4) jiny task ma deadline 0x500
		// jiny task dostane prednost pred log taskem, a pokud nesplni v kratkem case svou ulohu, tento task prekroci deadline
		// TODO: inverzi priorit bychom docasne zvysili prioritu (zkratili deadline) log tasku, aby vyprazdnil pipe a my se mohli odblokovat co nejdrive
		write(logpipe, "SOS!", 5);
    8344:	e3a02005 	mov	r2, #5
    8348:	e59f10d0 	ldr	r1, [pc, #208]	; 8420 <main+0x168>
    834c:	e51b0008 	ldr	r0, [fp, #-8]
    8350:	eb000075 	bl	852c <_Z5writejPKcj>
/home/schenkj/os2022/sp/sources/userspace/sos_task/main.cpp:53 (discriminator 1)

		blink(true);
    8354:	e3a00001 	mov	r0, #1
    8358:	ebffffb6 	bl	8238 <_Z5blinkb>
/home/schenkj/os2022/sp/sources/userspace/sos_task/main.cpp:54 (discriminator 1)
		sleep(symbol_tick_delay);
    835c:	e3e01001 	mvn	r1, #1
    8360:	e3a00b01 	mov	r0, #1024	; 0x400
    8364:	eb0000c8 	bl	868c <_Z5sleepjj>
/home/schenkj/os2022/sp/sources/userspace/sos_task/main.cpp:55 (discriminator 1)
		blink(true);
    8368:	e3a00001 	mov	r0, #1
    836c:	ebffffb1 	bl	8238 <_Z5blinkb>
/home/schenkj/os2022/sp/sources/userspace/sos_task/main.cpp:56 (discriminator 1)
		sleep(symbol_tick_delay);
    8370:	e3e01001 	mvn	r1, #1
    8374:	e3a00b01 	mov	r0, #1024	; 0x400
    8378:	eb0000c3 	bl	868c <_Z5sleepjj>
/home/schenkj/os2022/sp/sources/userspace/sos_task/main.cpp:57 (discriminator 1)
		blink(true);
    837c:	e3a00001 	mov	r0, #1
    8380:	ebffffac 	bl	8238 <_Z5blinkb>
/home/schenkj/os2022/sp/sources/userspace/sos_task/main.cpp:59 (discriminator 1)

		sleep(char_tick_delay);
    8384:	e3e01001 	mvn	r1, #1
    8388:	e3a00a01 	mov	r0, #4096	; 0x1000
    838c:	eb0000be 	bl	868c <_Z5sleepjj>
/home/schenkj/os2022/sp/sources/userspace/sos_task/main.cpp:61 (discriminator 1)

		blink(false);
    8390:	e3a00000 	mov	r0, #0
    8394:	ebffffa7 	bl	8238 <_Z5blinkb>
/home/schenkj/os2022/sp/sources/userspace/sos_task/main.cpp:62 (discriminator 1)
		sleep(symbol_tick_delay);
    8398:	e3e01001 	mvn	r1, #1
    839c:	e3a00b01 	mov	r0, #1024	; 0x400
    83a0:	eb0000b9 	bl	868c <_Z5sleepjj>
/home/schenkj/os2022/sp/sources/userspace/sos_task/main.cpp:63 (discriminator 1)
		blink(false);
    83a4:	e3a00000 	mov	r0, #0
    83a8:	ebffffa2 	bl	8238 <_Z5blinkb>
/home/schenkj/os2022/sp/sources/userspace/sos_task/main.cpp:64 (discriminator 1)
		sleep(symbol_tick_delay);
    83ac:	e3e01001 	mvn	r1, #1
    83b0:	e3a00b01 	mov	r0, #1024	; 0x400
    83b4:	eb0000b4 	bl	868c <_Z5sleepjj>
/home/schenkj/os2022/sp/sources/userspace/sos_task/main.cpp:65 (discriminator 1)
		blink(false);
    83b8:	e3a00000 	mov	r0, #0
    83bc:	ebffff9d 	bl	8238 <_Z5blinkb>
/home/schenkj/os2022/sp/sources/userspace/sos_task/main.cpp:66 (discriminator 1)
		sleep(symbol_tick_delay);
    83c0:	e3e01001 	mvn	r1, #1
    83c4:	e3a00b01 	mov	r0, #1024	; 0x400
    83c8:	eb0000af 	bl	868c <_Z5sleepjj>
/home/schenkj/os2022/sp/sources/userspace/sos_task/main.cpp:68 (discriminator 1)

		sleep(char_tick_delay);
    83cc:	e3e01001 	mvn	r1, #1
    83d0:	e3a00a01 	mov	r0, #4096	; 0x1000
    83d4:	eb0000ac 	bl	868c <_Z5sleepjj>
/home/schenkj/os2022/sp/sources/userspace/sos_task/main.cpp:70 (discriminator 1)

		blink(true);
    83d8:	e3a00001 	mov	r0, #1
    83dc:	ebffff95 	bl	8238 <_Z5blinkb>
/home/schenkj/os2022/sp/sources/userspace/sos_task/main.cpp:71 (discriminator 1)
		sleep(symbol_tick_delay);
    83e0:	e3e01001 	mvn	r1, #1
    83e4:	e3a00b01 	mov	r0, #1024	; 0x400
    83e8:	eb0000a7 	bl	868c <_Z5sleepjj>
/home/schenkj/os2022/sp/sources/userspace/sos_task/main.cpp:72 (discriminator 1)
		blink(true);
    83ec:	e3a00001 	mov	r0, #1
    83f0:	ebffff90 	bl	8238 <_Z5blinkb>
/home/schenkj/os2022/sp/sources/userspace/sos_task/main.cpp:73 (discriminator 1)
		sleep(symbol_tick_delay);
    83f4:	e3e01001 	mvn	r1, #1
    83f8:	e3a00b01 	mov	r0, #1024	; 0x400
    83fc:	eb0000a2 	bl	868c <_Z5sleepjj>
/home/schenkj/os2022/sp/sources/userspace/sos_task/main.cpp:74 (discriminator 1)
		blink(true);
    8400:	e3a00001 	mov	r0, #1
    8404:	ebffff8b 	bl	8238 <_Z5blinkb>
/home/schenkj/os2022/sp/sources/userspace/sos_task/main.cpp:42 (discriminator 1)
		wait(button, 1, 0x300);
    8408:	eaffffc7 	b	832c <main+0x74>
    840c:	00008fb4 			; <UNDEFINED> instruction: 0x00008fb4
    8410:	00009024 	andeq	r9, r0, r4, lsr #32
    8414:	00008fc0 	andeq	r8, r0, r0, asr #31
    8418:	00009028 	andeq	r9, r0, r8, lsr #32
    841c:	00008fcc 	andeq	r8, r0, ip, asr #31
    8420:	00008fd0 	ldrdeq	r8, [r0], -r0

00008424 <_Z6getpidv>:
_Z6getpidv():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:5
#include <stdfile.h>
#include <stdstring.h>

uint32_t getpid()
{
    8424:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8428:	e28db000 	add	fp, sp, #0
    842c:	e24dd00c 	sub	sp, sp, #12
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:8
    uint32_t pid;

    asm volatile("swi 0");
    8430:	ef000000 	svc	0x00000000
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:9
    asm volatile("mov %0, r0" : "=r" (pid));
    8434:	e1a03000 	mov	r3, r0
    8438:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:11

    return pid;
    843c:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:12
}
    8440:	e1a00003 	mov	r0, r3
    8444:	e28bd000 	add	sp, fp, #0
    8448:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    844c:	e12fff1e 	bx	lr

00008450 <_Z9terminatei>:
_Z9terminatei():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:15

void terminate(int exitcode)
{
    8450:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8454:	e28db000 	add	fp, sp, #0
    8458:	e24dd00c 	sub	sp, sp, #12
    845c:	e50b0008 	str	r0, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:16
    asm volatile("mov r0, %0" : : "r" (exitcode));
    8460:	e51b3008 	ldr	r3, [fp, #-8]
    8464:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:17
    asm volatile("swi 1");
    8468:	ef000001 	svc	0x00000001
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:18
}
    846c:	e320f000 	nop	{0}
    8470:	e28bd000 	add	sp, fp, #0
    8474:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8478:	e12fff1e 	bx	lr

0000847c <_Z11sched_yieldv>:
_Z11sched_yieldv():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:21

void sched_yield()
{
    847c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8480:	e28db000 	add	fp, sp, #0
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:22
    asm volatile("swi 2");
    8484:	ef000002 	svc	0x00000002
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:23
}
    8488:	e320f000 	nop	{0}
    848c:	e28bd000 	add	sp, fp, #0
    8490:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8494:	e12fff1e 	bx	lr

00008498 <_Z4openPKc15NFile_Open_Mode>:
_Z4openPKc15NFile_Open_Mode():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:26

uint32_t open(const char* filename, NFile_Open_Mode mode)
{
    8498:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    849c:	e28db000 	add	fp, sp, #0
    84a0:	e24dd014 	sub	sp, sp, #20
    84a4:	e50b0010 	str	r0, [fp, #-16]
    84a8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:29
    uint32_t file;

    asm volatile("mov r0, %0" : : "r" (filename));
    84ac:	e51b3010 	ldr	r3, [fp, #-16]
    84b0:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:30
    asm volatile("mov r1, %0" : : "r" (mode));
    84b4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84b8:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:31
    asm volatile("swi 64");
    84bc:	ef000040 	svc	0x00000040
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:32
    asm volatile("mov %0, r0" : "=r" (file));
    84c0:	e1a03000 	mov	r3, r0
    84c4:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:34

    return file;
    84c8:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:35
}
    84cc:	e1a00003 	mov	r0, r3
    84d0:	e28bd000 	add	sp, fp, #0
    84d4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    84d8:	e12fff1e 	bx	lr

000084dc <_Z4readjPcj>:
_Z4readjPcj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:38

uint32_t read(uint32_t file, char* const buffer, uint32_t size)
{
    84dc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    84e0:	e28db000 	add	fp, sp, #0
    84e4:	e24dd01c 	sub	sp, sp, #28
    84e8:	e50b0010 	str	r0, [fp, #-16]
    84ec:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    84f0:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:41
    uint32_t rdnum;

    asm volatile("mov r0, %0" : : "r" (file));
    84f4:	e51b3010 	ldr	r3, [fp, #-16]
    84f8:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:42
    asm volatile("mov r1, %0" : : "r" (buffer));
    84fc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8500:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:43
    asm volatile("mov r2, %0" : : "r" (size));
    8504:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8508:	e1a02003 	mov	r2, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:44
    asm volatile("swi 65");
    850c:	ef000041 	svc	0x00000041
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:45
    asm volatile("mov %0, r0" : "=r" (rdnum));
    8510:	e1a03000 	mov	r3, r0
    8514:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:47

    return rdnum;
    8518:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:48
}
    851c:	e1a00003 	mov	r0, r3
    8520:	e28bd000 	add	sp, fp, #0
    8524:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8528:	e12fff1e 	bx	lr

0000852c <_Z5writejPKcj>:
_Z5writejPKcj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:51

uint32_t write(uint32_t file, const char* buffer, uint32_t size)
{
    852c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8530:	e28db000 	add	fp, sp, #0
    8534:	e24dd01c 	sub	sp, sp, #28
    8538:	e50b0010 	str	r0, [fp, #-16]
    853c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8540:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:54
    uint32_t wrnum;

    asm volatile("mov r0, %0" : : "r" (file));
    8544:	e51b3010 	ldr	r3, [fp, #-16]
    8548:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:55
    asm volatile("mov r1, %0" : : "r" (buffer));
    854c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8550:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:56
    asm volatile("mov r2, %0" : : "r" (size));
    8554:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8558:	e1a02003 	mov	r2, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:57
    asm volatile("swi 66");
    855c:	ef000042 	svc	0x00000042
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:58
    asm volatile("mov %0, r0" : "=r" (wrnum));
    8560:	e1a03000 	mov	r3, r0
    8564:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:60

    return wrnum;
    8568:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:61
}
    856c:	e1a00003 	mov	r0, r3
    8570:	e28bd000 	add	sp, fp, #0
    8574:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8578:	e12fff1e 	bx	lr

0000857c <_Z5closej>:
_Z5closej():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:64

void close(uint32_t file)
{
    857c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8580:	e28db000 	add	fp, sp, #0
    8584:	e24dd00c 	sub	sp, sp, #12
    8588:	e50b0008 	str	r0, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:65
    asm volatile("mov r0, %0" : : "r" (file));
    858c:	e51b3008 	ldr	r3, [fp, #-8]
    8590:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:66
    asm volatile("swi 67");
    8594:	ef000043 	svc	0x00000043
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:67
}
    8598:	e320f000 	nop	{0}
    859c:	e28bd000 	add	sp, fp, #0
    85a0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85a4:	e12fff1e 	bx	lr

000085a8 <_Z5ioctlj16NIOCtl_OperationPv>:
_Z5ioctlj16NIOCtl_OperationPv():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:70

uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param)
{
    85a8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85ac:	e28db000 	add	fp, sp, #0
    85b0:	e24dd01c 	sub	sp, sp, #28
    85b4:	e50b0010 	str	r0, [fp, #-16]
    85b8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    85bc:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:73
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    85c0:	e51b3010 	ldr	r3, [fp, #-16]
    85c4:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:74
    asm volatile("mov r1, %0" : : "r" (operation));
    85c8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    85cc:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:75
    asm volatile("mov r2, %0" : : "r" (param));
    85d0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    85d4:	e1a02003 	mov	r2, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:76
    asm volatile("swi 68");
    85d8:	ef000044 	svc	0x00000044
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:77
    asm volatile("mov %0, r0" : "=r" (retcode));
    85dc:	e1a03000 	mov	r3, r0
    85e0:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:79

    return retcode;
    85e4:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:80
}
    85e8:	e1a00003 	mov	r0, r3
    85ec:	e28bd000 	add	sp, fp, #0
    85f0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85f4:	e12fff1e 	bx	lr

000085f8 <_Z6notifyjj>:
_Z6notifyjj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:83

uint32_t notify(uint32_t file, uint32_t count)
{
    85f8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85fc:	e28db000 	add	fp, sp, #0
    8600:	e24dd014 	sub	sp, sp, #20
    8604:	e50b0010 	str	r0, [fp, #-16]
    8608:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:86
    uint32_t retcnt;

    asm volatile("mov r0, %0" : : "r" (file));
    860c:	e51b3010 	ldr	r3, [fp, #-16]
    8610:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:87
    asm volatile("mov r1, %0" : : "r" (count));
    8614:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8618:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:88
    asm volatile("swi 69");
    861c:	ef000045 	svc	0x00000045
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:89
    asm volatile("mov %0, r0" : "=r" (retcnt));
    8620:	e1a03000 	mov	r3, r0
    8624:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:91

    return retcnt;
    8628:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:92
}
    862c:	e1a00003 	mov	r0, r3
    8630:	e28bd000 	add	sp, fp, #0
    8634:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8638:	e12fff1e 	bx	lr

0000863c <_Z4waitjjj>:
_Z4waitjjj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:95

NSWI_Result_Code wait(uint32_t file, uint32_t count, uint32_t notified_deadline)
{
    863c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8640:	e28db000 	add	fp, sp, #0
    8644:	e24dd01c 	sub	sp, sp, #28
    8648:	e50b0010 	str	r0, [fp, #-16]
    864c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8650:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:98
    NSWI_Result_Code retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    8654:	e51b3010 	ldr	r3, [fp, #-16]
    8658:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:99
    asm volatile("mov r1, %0" : : "r" (count));
    865c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8660:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:100
    asm volatile("mov r2, %0" : : "r" (notified_deadline));
    8664:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8668:	e1a02003 	mov	r2, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:101
    asm volatile("swi 70");
    866c:	ef000046 	svc	0x00000046
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:102
    asm volatile("mov %0, r0" : "=r" (retcode));
    8670:	e1a03000 	mov	r3, r0
    8674:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:104

    return retcode;
    8678:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:105
}
    867c:	e1a00003 	mov	r0, r3
    8680:	e28bd000 	add	sp, fp, #0
    8684:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8688:	e12fff1e 	bx	lr

0000868c <_Z5sleepjj>:
_Z5sleepjj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:108

bool sleep(uint32_t ticks, uint32_t notified_deadline)
{
    868c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8690:	e28db000 	add	fp, sp, #0
    8694:	e24dd014 	sub	sp, sp, #20
    8698:	e50b0010 	str	r0, [fp, #-16]
    869c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:111
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (ticks));
    86a0:	e51b3010 	ldr	r3, [fp, #-16]
    86a4:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:112
    asm volatile("mov r1, %0" : : "r" (notified_deadline));
    86a8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    86ac:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:113
    asm volatile("swi 3");
    86b0:	ef000003 	svc	0x00000003
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:114
    asm volatile("mov %0, r0" : "=r" (retcode));
    86b4:	e1a03000 	mov	r3, r0
    86b8:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:116

    return retcode;
    86bc:	e51b3008 	ldr	r3, [fp, #-8]
    86c0:	e3530000 	cmp	r3, #0
    86c4:	13a03001 	movne	r3, #1
    86c8:	03a03000 	moveq	r3, #0
    86cc:	e6ef3073 	uxtb	r3, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:117
}
    86d0:	e1a00003 	mov	r0, r3
    86d4:	e28bd000 	add	sp, fp, #0
    86d8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86dc:	e12fff1e 	bx	lr

000086e0 <_Z24get_active_process_countv>:
_Z24get_active_process_countv():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:120

uint32_t get_active_process_count()
{
    86e0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    86e4:	e28db000 	add	fp, sp, #0
    86e8:	e24dd00c 	sub	sp, sp, #12
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:121
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Active_Process_Count;
    86ec:	e3a03000 	mov	r3, #0
    86f0:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:124
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    86f4:	e3a03000 	mov	r3, #0
    86f8:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:125
    asm volatile("mov r1, %0" : : "r" (&retval));
    86fc:	e24b300c 	sub	r3, fp, #12
    8700:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:126
    asm volatile("swi 4");
    8704:	ef000004 	svc	0x00000004
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:128

    return retval;
    8708:	e51b300c 	ldr	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:129
}
    870c:	e1a00003 	mov	r0, r3
    8710:	e28bd000 	add	sp, fp, #0
    8714:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8718:	e12fff1e 	bx	lr

0000871c <_Z14get_tick_countv>:
_Z14get_tick_countv():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:132

uint32_t get_tick_count()
{
    871c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8720:	e28db000 	add	fp, sp, #0
    8724:	e24dd00c 	sub	sp, sp, #12
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:133
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Tick_Count;
    8728:	e3a03001 	mov	r3, #1
    872c:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:136
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    8730:	e3a03001 	mov	r3, #1
    8734:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:137
    asm volatile("mov r1, %0" : : "r" (&retval));
    8738:	e24b300c 	sub	r3, fp, #12
    873c:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:138
    asm volatile("swi 4");
    8740:	ef000004 	svc	0x00000004
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:140

    return retval;
    8744:	e51b300c 	ldr	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:141
}
    8748:	e1a00003 	mov	r0, r3
    874c:	e28bd000 	add	sp, fp, #0
    8750:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8754:	e12fff1e 	bx	lr

00008758 <_Z17set_task_deadlinej>:
_Z17set_task_deadlinej():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:144

void set_task_deadline(uint32_t tick_count_required)
{
    8758:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    875c:	e28db000 	add	fp, sp, #0
    8760:	e24dd014 	sub	sp, sp, #20
    8764:	e50b0010 	str	r0, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:145
    const NDeadline_Subservice req = NDeadline_Subservice::Set_Relative;
    8768:	e3a03000 	mov	r3, #0
    876c:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:147

    asm volatile("mov r0, %0" : : "r" (req));
    8770:	e3a03000 	mov	r3, #0
    8774:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:148
    asm volatile("mov r1, %0" : : "r" (&tick_count_required));
    8778:	e24b3010 	sub	r3, fp, #16
    877c:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:149
    asm volatile("swi 5");
    8780:	ef000005 	svc	0x00000005
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:150
}
    8784:	e320f000 	nop	{0}
    8788:	e28bd000 	add	sp, fp, #0
    878c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8790:	e12fff1e 	bx	lr

00008794 <_Z26get_task_ticks_to_deadlinev>:
_Z26get_task_ticks_to_deadlinev():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:153

uint32_t get_task_ticks_to_deadline()
{
    8794:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8798:	e28db000 	add	fp, sp, #0
    879c:	e24dd00c 	sub	sp, sp, #12
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:154
    const NDeadline_Subservice req = NDeadline_Subservice::Get_Remaining;
    87a0:	e3a03001 	mov	r3, #1
    87a4:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:157
    uint32_t ticks;

    asm volatile("mov r0, %0" : : "r" (req));
    87a8:	e3a03001 	mov	r3, #1
    87ac:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:158
    asm volatile("mov r1, %0" : : "r" (&ticks));
    87b0:	e24b300c 	sub	r3, fp, #12
    87b4:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:159
    asm volatile("swi 5");
    87b8:	ef000005 	svc	0x00000005
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:161

    return ticks;
    87bc:	e51b300c 	ldr	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:162
}
    87c0:	e1a00003 	mov	r0, r3
    87c4:	e28bd000 	add	sp, fp, #0
    87c8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    87cc:	e12fff1e 	bx	lr

000087d0 <_Z4pipePKcj>:
_Z4pipePKcj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:167

const char Pipe_File_Prefix[] = "SYS:pipe/";

uint32_t pipe(const char* name, uint32_t buf_size)
{
    87d0:	e92d4800 	push	{fp, lr}
    87d4:	e28db004 	add	fp, sp, #4
    87d8:	e24dd050 	sub	sp, sp, #80	; 0x50
    87dc:	e50b0050 	str	r0, [fp, #-80]	; 0xffffffb0
    87e0:	e50b1054 	str	r1, [fp, #-84]	; 0xffffffac
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:169
    char fname[64];
    strncpy(fname, Pipe_File_Prefix, sizeof(Pipe_File_Prefix));
    87e4:	e24b3048 	sub	r3, fp, #72	; 0x48
    87e8:	e3a0200a 	mov	r2, #10
    87ec:	e59f1088 	ldr	r1, [pc, #136]	; 887c <_Z4pipePKcj+0xac>
    87f0:	e1a00003 	mov	r0, r3
    87f4:	eb0000a5 	bl	8a90 <_Z7strncpyPcPKci>
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:170
    strncpy(fname + sizeof(Pipe_File_Prefix), name, sizeof(fname) - sizeof(Pipe_File_Prefix) - 1);
    87f8:	e24b3048 	sub	r3, fp, #72	; 0x48
    87fc:	e283300a 	add	r3, r3, #10
    8800:	e3a02035 	mov	r2, #53	; 0x35
    8804:	e51b1050 	ldr	r1, [fp, #-80]	; 0xffffffb0
    8808:	e1a00003 	mov	r0, r3
    880c:	eb00009f 	bl	8a90 <_Z7strncpyPcPKci>
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:172

    int ncur = sizeof(Pipe_File_Prefix) + strlen(name);
    8810:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    8814:	eb0000f8 	bl	8bfc <_Z6strlenPKc>
    8818:	e1a03000 	mov	r3, r0
    881c:	e283300a 	add	r3, r3, #10
    8820:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:174

    fname[ncur++] = '#';
    8824:	e51b3008 	ldr	r3, [fp, #-8]
    8828:	e2832001 	add	r2, r3, #1
    882c:	e50b2008 	str	r2, [fp, #-8]
    8830:	e24b2004 	sub	r2, fp, #4
    8834:	e0823003 	add	r3, r2, r3
    8838:	e3a02023 	mov	r2, #35	; 0x23
    883c:	e5432044 	strb	r2, [r3, #-68]	; 0xffffffbc
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:176

    itoa(buf_size, &fname[ncur], 10);
    8840:	e24b2048 	sub	r2, fp, #72	; 0x48
    8844:	e51b3008 	ldr	r3, [fp, #-8]
    8848:	e0823003 	add	r3, r2, r3
    884c:	e3a0200a 	mov	r2, #10
    8850:	e1a01003 	mov	r1, r3
    8854:	e51b0054 	ldr	r0, [fp, #-84]	; 0xffffffac
    8858:	eb000008 	bl	8880 <_Z4itoajPcj>
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:178

    return open(fname, NFile_Open_Mode::Read_Write);
    885c:	e24b3048 	sub	r3, fp, #72	; 0x48
    8860:	e3a01002 	mov	r1, #2
    8864:	e1a00003 	mov	r0, r3
    8868:	ebffff0a 	bl	8498 <_Z4openPKc15NFile_Open_Mode>
    886c:	e1a03000 	mov	r3, r0
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:179
}
    8870:	e1a00003 	mov	r0, r3
    8874:	e24bd004 	sub	sp, fp, #4
    8878:	e8bd8800 	pop	{fp, pc}
    887c:	00009004 	andeq	r9, r0, r4

00008880 <_Z4itoajPcj>:
_Z4itoajPcj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:9
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(unsigned int input, char* output, unsigned int base)
{
    8880:	e92d4800 	push	{fp, lr}
    8884:	e28db004 	add	fp, sp, #4
    8888:	e24dd020 	sub	sp, sp, #32
    888c:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8890:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8894:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:10
	int i = 0;
    8898:	e3a03000 	mov	r3, #0
    889c:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:12

	while (input > 0)
    88a0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    88a4:	e3530000 	cmp	r3, #0
    88a8:	0a000014 	beq	8900 <_Z4itoajPcj+0x80>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:14
	{
		output[i] = CharConvArr[input % base];
    88ac:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    88b0:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    88b4:	e1a00003 	mov	r0, r3
    88b8:	eb000199 	bl	8f24 <__aeabi_uidivmod>
    88bc:	e1a03001 	mov	r3, r1
    88c0:	e1a01003 	mov	r1, r3
    88c4:	e51b3008 	ldr	r3, [fp, #-8]
    88c8:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    88cc:	e0823003 	add	r3, r2, r3
    88d0:	e59f2118 	ldr	r2, [pc, #280]	; 89f0 <_Z4itoajPcj+0x170>
    88d4:	e7d22001 	ldrb	r2, [r2, r1]
    88d8:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:15
		input /= base;
    88dc:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    88e0:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    88e4:	eb000113 	bl	8d38 <__udivsi3>
    88e8:	e1a03000 	mov	r3, r0
    88ec:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:16
		i++;
    88f0:	e51b3008 	ldr	r3, [fp, #-8]
    88f4:	e2833001 	add	r3, r3, #1
    88f8:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:12
	while (input > 0)
    88fc:	eaffffe7 	b	88a0 <_Z4itoajPcj+0x20>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:19
	}

    if (i == 0)
    8900:	e51b3008 	ldr	r3, [fp, #-8]
    8904:	e3530000 	cmp	r3, #0
    8908:	1a000007 	bne	892c <_Z4itoajPcj+0xac>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:21
    {
        output[i] = CharConvArr[0];
    890c:	e51b3008 	ldr	r3, [fp, #-8]
    8910:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8914:	e0823003 	add	r3, r2, r3
    8918:	e3a02030 	mov	r2, #48	; 0x30
    891c:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:22
        i++;
    8920:	e51b3008 	ldr	r3, [fp, #-8]
    8924:	e2833001 	add	r3, r3, #1
    8928:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:25
    }

	output[i] = '\0';
    892c:	e51b3008 	ldr	r3, [fp, #-8]
    8930:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8934:	e0823003 	add	r3, r2, r3
    8938:	e3a02000 	mov	r2, #0
    893c:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:26
	i--;
    8940:	e51b3008 	ldr	r3, [fp, #-8]
    8944:	e2433001 	sub	r3, r3, #1
    8948:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:28

	for (int j = 0; j <= i/2; j++)
    894c:	e3a03000 	mov	r3, #0
    8950:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:28 (discriminator 3)
    8954:	e51b3008 	ldr	r3, [fp, #-8]
    8958:	e1a02fa3 	lsr	r2, r3, #31
    895c:	e0823003 	add	r3, r2, r3
    8960:	e1a030c3 	asr	r3, r3, #1
    8964:	e1a02003 	mov	r2, r3
    8968:	e51b300c 	ldr	r3, [fp, #-12]
    896c:	e1530002 	cmp	r3, r2
    8970:	ca00001b 	bgt	89e4 <_Z4itoajPcj+0x164>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:30 (discriminator 2)
	{
		char c = output[i - j];
    8974:	e51b2008 	ldr	r2, [fp, #-8]
    8978:	e51b300c 	ldr	r3, [fp, #-12]
    897c:	e0423003 	sub	r3, r2, r3
    8980:	e1a02003 	mov	r2, r3
    8984:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8988:	e0833002 	add	r3, r3, r2
    898c:	e5d33000 	ldrb	r3, [r3]
    8990:	e54b300d 	strb	r3, [fp, #-13]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:31 (discriminator 2)
		output[i - j] = output[j];
    8994:	e51b300c 	ldr	r3, [fp, #-12]
    8998:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    899c:	e0822003 	add	r2, r2, r3
    89a0:	e51b1008 	ldr	r1, [fp, #-8]
    89a4:	e51b300c 	ldr	r3, [fp, #-12]
    89a8:	e0413003 	sub	r3, r1, r3
    89ac:	e1a01003 	mov	r1, r3
    89b0:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    89b4:	e0833001 	add	r3, r3, r1
    89b8:	e5d22000 	ldrb	r2, [r2]
    89bc:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:32 (discriminator 2)
		output[j] = c;
    89c0:	e51b300c 	ldr	r3, [fp, #-12]
    89c4:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    89c8:	e0823003 	add	r3, r2, r3
    89cc:	e55b200d 	ldrb	r2, [fp, #-13]
    89d0:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:28 (discriminator 2)
	for (int j = 0; j <= i/2; j++)
    89d4:	e51b300c 	ldr	r3, [fp, #-12]
    89d8:	e2833001 	add	r3, r3, #1
    89dc:	e50b300c 	str	r3, [fp, #-12]
    89e0:	eaffffdb 	b	8954 <_Z4itoajPcj+0xd4>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:34
	}
}
    89e4:	e320f000 	nop	{0}
    89e8:	e24bd004 	sub	sp, fp, #4
    89ec:	e8bd8800 	pop	{fp, pc}
    89f0:	00009010 	andeq	r9, r0, r0, lsl r0

000089f4 <_Z4atoiPKc>:
_Z4atoiPKc():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:37

int atoi(const char* input)
{
    89f4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    89f8:	e28db000 	add	fp, sp, #0
    89fc:	e24dd014 	sub	sp, sp, #20
    8a00:	e50b0010 	str	r0, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:38
	int output = 0;
    8a04:	e3a03000 	mov	r3, #0
    8a08:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:40

	while (*input != '\0')
    8a0c:	e51b3010 	ldr	r3, [fp, #-16]
    8a10:	e5d33000 	ldrb	r3, [r3]
    8a14:	e3530000 	cmp	r3, #0
    8a18:	0a000017 	beq	8a7c <_Z4atoiPKc+0x88>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:42
	{
		output *= 10;
    8a1c:	e51b2008 	ldr	r2, [fp, #-8]
    8a20:	e1a03002 	mov	r3, r2
    8a24:	e1a03103 	lsl	r3, r3, #2
    8a28:	e0833002 	add	r3, r3, r2
    8a2c:	e1a03083 	lsl	r3, r3, #1
    8a30:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:43
		if (*input > '9' || *input < '0')
    8a34:	e51b3010 	ldr	r3, [fp, #-16]
    8a38:	e5d33000 	ldrb	r3, [r3]
    8a3c:	e3530039 	cmp	r3, #57	; 0x39
    8a40:	8a00000d 	bhi	8a7c <_Z4atoiPKc+0x88>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:43 (discriminator 1)
    8a44:	e51b3010 	ldr	r3, [fp, #-16]
    8a48:	e5d33000 	ldrb	r3, [r3]
    8a4c:	e353002f 	cmp	r3, #47	; 0x2f
    8a50:	9a000009 	bls	8a7c <_Z4atoiPKc+0x88>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:46
			break;

		output += *input - '0';
    8a54:	e51b3010 	ldr	r3, [fp, #-16]
    8a58:	e5d33000 	ldrb	r3, [r3]
    8a5c:	e2433030 	sub	r3, r3, #48	; 0x30
    8a60:	e51b2008 	ldr	r2, [fp, #-8]
    8a64:	e0823003 	add	r3, r2, r3
    8a68:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:48

		input++;
    8a6c:	e51b3010 	ldr	r3, [fp, #-16]
    8a70:	e2833001 	add	r3, r3, #1
    8a74:	e50b3010 	str	r3, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:40
	while (*input != '\0')
    8a78:	eaffffe3 	b	8a0c <_Z4atoiPKc+0x18>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:51
	}

	return output;
    8a7c:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:52
}
    8a80:	e1a00003 	mov	r0, r3
    8a84:	e28bd000 	add	sp, fp, #0
    8a88:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8a8c:	e12fff1e 	bx	lr

00008a90 <_Z7strncpyPcPKci>:
_Z7strncpyPcPKci():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:55

char* strncpy(char* dest, const char *src, int num)
{
    8a90:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8a94:	e28db000 	add	fp, sp, #0
    8a98:	e24dd01c 	sub	sp, sp, #28
    8a9c:	e50b0010 	str	r0, [fp, #-16]
    8aa0:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8aa4:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:58
	int i;

	for (i = 0; i < num && src[i] != '\0'; i++)
    8aa8:	e3a03000 	mov	r3, #0
    8aac:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:58 (discriminator 4)
    8ab0:	e51b2008 	ldr	r2, [fp, #-8]
    8ab4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8ab8:	e1520003 	cmp	r2, r3
    8abc:	aa000011 	bge	8b08 <_Z7strncpyPcPKci+0x78>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:58 (discriminator 2)
    8ac0:	e51b3008 	ldr	r3, [fp, #-8]
    8ac4:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8ac8:	e0823003 	add	r3, r2, r3
    8acc:	e5d33000 	ldrb	r3, [r3]
    8ad0:	e3530000 	cmp	r3, #0
    8ad4:	0a00000b 	beq	8b08 <_Z7strncpyPcPKci+0x78>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:59 (discriminator 3)
		dest[i] = src[i];
    8ad8:	e51b3008 	ldr	r3, [fp, #-8]
    8adc:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8ae0:	e0822003 	add	r2, r2, r3
    8ae4:	e51b3008 	ldr	r3, [fp, #-8]
    8ae8:	e51b1010 	ldr	r1, [fp, #-16]
    8aec:	e0813003 	add	r3, r1, r3
    8af0:	e5d22000 	ldrb	r2, [r2]
    8af4:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:58 (discriminator 3)
	for (i = 0; i < num && src[i] != '\0'; i++)
    8af8:	e51b3008 	ldr	r3, [fp, #-8]
    8afc:	e2833001 	add	r3, r3, #1
    8b00:	e50b3008 	str	r3, [fp, #-8]
    8b04:	eaffffe9 	b	8ab0 <_Z7strncpyPcPKci+0x20>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:60 (discriminator 2)
	for (; i < num; i++)
    8b08:	e51b2008 	ldr	r2, [fp, #-8]
    8b0c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8b10:	e1520003 	cmp	r2, r3
    8b14:	aa000008 	bge	8b3c <_Z7strncpyPcPKci+0xac>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:61 (discriminator 1)
		dest[i] = '\0';
    8b18:	e51b3008 	ldr	r3, [fp, #-8]
    8b1c:	e51b2010 	ldr	r2, [fp, #-16]
    8b20:	e0823003 	add	r3, r2, r3
    8b24:	e3a02000 	mov	r2, #0
    8b28:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:60 (discriminator 1)
	for (; i < num; i++)
    8b2c:	e51b3008 	ldr	r3, [fp, #-8]
    8b30:	e2833001 	add	r3, r3, #1
    8b34:	e50b3008 	str	r3, [fp, #-8]
    8b38:	eafffff2 	b	8b08 <_Z7strncpyPcPKci+0x78>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:63

   return dest;
    8b3c:	e51b3010 	ldr	r3, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:64
}
    8b40:	e1a00003 	mov	r0, r3
    8b44:	e28bd000 	add	sp, fp, #0
    8b48:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8b4c:	e12fff1e 	bx	lr

00008b50 <_Z7strncmpPKcS0_i>:
_Z7strncmpPKcS0_i():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:67

int strncmp(const char *s1, const char *s2, int num)
{
    8b50:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8b54:	e28db000 	add	fp, sp, #0
    8b58:	e24dd01c 	sub	sp, sp, #28
    8b5c:	e50b0010 	str	r0, [fp, #-16]
    8b60:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8b64:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:69
	unsigned char u1, u2;
  	while (num-- > 0)
    8b68:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8b6c:	e2432001 	sub	r2, r3, #1
    8b70:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    8b74:	e3530000 	cmp	r3, #0
    8b78:	c3a03001 	movgt	r3, #1
    8b7c:	d3a03000 	movle	r3, #0
    8b80:	e6ef3073 	uxtb	r3, r3
    8b84:	e3530000 	cmp	r3, #0
    8b88:	0a000016 	beq	8be8 <_Z7strncmpPKcS0_i+0x98>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:71
    {
      	u1 = (unsigned char) *s1++;
    8b8c:	e51b3010 	ldr	r3, [fp, #-16]
    8b90:	e2832001 	add	r2, r3, #1
    8b94:	e50b2010 	str	r2, [fp, #-16]
    8b98:	e5d33000 	ldrb	r3, [r3]
    8b9c:	e54b3005 	strb	r3, [fp, #-5]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:72
     	u2 = (unsigned char) *s2++;
    8ba0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8ba4:	e2832001 	add	r2, r3, #1
    8ba8:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    8bac:	e5d33000 	ldrb	r3, [r3]
    8bb0:	e54b3006 	strb	r3, [fp, #-6]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:73
      	if (u1 != u2)
    8bb4:	e55b2005 	ldrb	r2, [fp, #-5]
    8bb8:	e55b3006 	ldrb	r3, [fp, #-6]
    8bbc:	e1520003 	cmp	r2, r3
    8bc0:	0a000003 	beq	8bd4 <_Z7strncmpPKcS0_i+0x84>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:74
        	return u1 - u2;
    8bc4:	e55b2005 	ldrb	r2, [fp, #-5]
    8bc8:	e55b3006 	ldrb	r3, [fp, #-6]
    8bcc:	e0423003 	sub	r3, r2, r3
    8bd0:	ea000005 	b	8bec <_Z7strncmpPKcS0_i+0x9c>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:75
      	if (u1 == '\0')
    8bd4:	e55b3005 	ldrb	r3, [fp, #-5]
    8bd8:	e3530000 	cmp	r3, #0
    8bdc:	1affffe1 	bne	8b68 <_Z7strncmpPKcS0_i+0x18>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:76
        	return 0;
    8be0:	e3a03000 	mov	r3, #0
    8be4:	ea000000 	b	8bec <_Z7strncmpPKcS0_i+0x9c>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:79
    }

  	return 0;
    8be8:	e3a03000 	mov	r3, #0
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:80
}
    8bec:	e1a00003 	mov	r0, r3
    8bf0:	e28bd000 	add	sp, fp, #0
    8bf4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8bf8:	e12fff1e 	bx	lr

00008bfc <_Z6strlenPKc>:
_Z6strlenPKc():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:83

int strlen(const char* s)
{
    8bfc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8c00:	e28db000 	add	fp, sp, #0
    8c04:	e24dd014 	sub	sp, sp, #20
    8c08:	e50b0010 	str	r0, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:84
	int i = 0;
    8c0c:	e3a03000 	mov	r3, #0
    8c10:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:86

	while (s[i] != '\0')
    8c14:	e51b3008 	ldr	r3, [fp, #-8]
    8c18:	e51b2010 	ldr	r2, [fp, #-16]
    8c1c:	e0823003 	add	r3, r2, r3
    8c20:	e5d33000 	ldrb	r3, [r3]
    8c24:	e3530000 	cmp	r3, #0
    8c28:	0a000003 	beq	8c3c <_Z6strlenPKc+0x40>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:87
		i++;
    8c2c:	e51b3008 	ldr	r3, [fp, #-8]
    8c30:	e2833001 	add	r3, r3, #1
    8c34:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:86
	while (s[i] != '\0')
    8c38:	eafffff5 	b	8c14 <_Z6strlenPKc+0x18>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:89

	return i;
    8c3c:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:90
}
    8c40:	e1a00003 	mov	r0, r3
    8c44:	e28bd000 	add	sp, fp, #0
    8c48:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8c4c:	e12fff1e 	bx	lr

00008c50 <_Z5bzeroPvi>:
_Z5bzeroPvi():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:93

void bzero(void* memory, int length)
{
    8c50:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8c54:	e28db000 	add	fp, sp, #0
    8c58:	e24dd014 	sub	sp, sp, #20
    8c5c:	e50b0010 	str	r0, [fp, #-16]
    8c60:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:94
	char* mem = reinterpret_cast<char*>(memory);
    8c64:	e51b3010 	ldr	r3, [fp, #-16]
    8c68:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:96

	for (int i = 0; i < length; i++)
    8c6c:	e3a03000 	mov	r3, #0
    8c70:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:96 (discriminator 3)
    8c74:	e51b2008 	ldr	r2, [fp, #-8]
    8c78:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8c7c:	e1520003 	cmp	r2, r3
    8c80:	aa000008 	bge	8ca8 <_Z5bzeroPvi+0x58>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:97 (discriminator 2)
		mem[i] = 0;
    8c84:	e51b3008 	ldr	r3, [fp, #-8]
    8c88:	e51b200c 	ldr	r2, [fp, #-12]
    8c8c:	e0823003 	add	r3, r2, r3
    8c90:	e3a02000 	mov	r2, #0
    8c94:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:96 (discriminator 2)
	for (int i = 0; i < length; i++)
    8c98:	e51b3008 	ldr	r3, [fp, #-8]
    8c9c:	e2833001 	add	r3, r3, #1
    8ca0:	e50b3008 	str	r3, [fp, #-8]
    8ca4:	eafffff2 	b	8c74 <_Z5bzeroPvi+0x24>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:98
}
    8ca8:	e320f000 	nop	{0}
    8cac:	e28bd000 	add	sp, fp, #0
    8cb0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8cb4:	e12fff1e 	bx	lr

00008cb8 <_Z6memcpyPKvPvi>:
_Z6memcpyPKvPvi():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:101

void memcpy(const void* src, void* dst, int num)
{
    8cb8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8cbc:	e28db000 	add	fp, sp, #0
    8cc0:	e24dd024 	sub	sp, sp, #36	; 0x24
    8cc4:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8cc8:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8ccc:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:102
	const char* memsrc = reinterpret_cast<const char*>(src);
    8cd0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8cd4:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:103
	char* memdst = reinterpret_cast<char*>(dst);
    8cd8:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8cdc:	e50b3010 	str	r3, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:105

	for (int i = 0; i < num; i++)
    8ce0:	e3a03000 	mov	r3, #0
    8ce4:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:105 (discriminator 3)
    8ce8:	e51b2008 	ldr	r2, [fp, #-8]
    8cec:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8cf0:	e1520003 	cmp	r2, r3
    8cf4:	aa00000b 	bge	8d28 <_Z6memcpyPKvPvi+0x70>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:106 (discriminator 2)
		memdst[i] = memsrc[i];
    8cf8:	e51b3008 	ldr	r3, [fp, #-8]
    8cfc:	e51b200c 	ldr	r2, [fp, #-12]
    8d00:	e0822003 	add	r2, r2, r3
    8d04:	e51b3008 	ldr	r3, [fp, #-8]
    8d08:	e51b1010 	ldr	r1, [fp, #-16]
    8d0c:	e0813003 	add	r3, r1, r3
    8d10:	e5d22000 	ldrb	r2, [r2]
    8d14:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:105 (discriminator 2)
	for (int i = 0; i < num; i++)
    8d18:	e51b3008 	ldr	r3, [fp, #-8]
    8d1c:	e2833001 	add	r3, r3, #1
    8d20:	e50b3008 	str	r3, [fp, #-8]
    8d24:	eaffffef 	b	8ce8 <_Z6memcpyPKvPvi+0x30>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:107
}
    8d28:	e320f000 	nop	{0}
    8d2c:	e28bd000 	add	sp, fp, #0
    8d30:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8d34:	e12fff1e 	bx	lr

00008d38 <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1099
    8d38:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1101
    8d3c:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1102
    8d40:	3a000074 	bcc	8f18 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1103
    8d44:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1104
    8d48:	9a00006b 	bls	8efc <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1105
    8d4c:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1106
    8d50:	0a00006c 	beq	8f08 <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1108
    8d54:	e16f3f10 	clz	r3, r0
    8d58:	e16f2f11 	clz	r2, r1
    8d5c:	e0423003 	sub	r3, r2, r3
    8d60:	e273301f 	rsbs	r3, r3, #31
    8d64:	10833083 	addne	r3, r3, r3, lsl #1
    8d68:	e3a02000 	mov	r2, #0
    8d6c:	108ff103 	addne	pc, pc, r3, lsl #2
    8d70:	e1a00000 	nop			; (mov r0, r0)
    8d74:	e1500f81 	cmp	r0, r1, lsl #31
    8d78:	e0a22002 	adc	r2, r2, r2
    8d7c:	20400f81 	subcs	r0, r0, r1, lsl #31
    8d80:	e1500f01 	cmp	r0, r1, lsl #30
    8d84:	e0a22002 	adc	r2, r2, r2
    8d88:	20400f01 	subcs	r0, r0, r1, lsl #30
    8d8c:	e1500e81 	cmp	r0, r1, lsl #29
    8d90:	e0a22002 	adc	r2, r2, r2
    8d94:	20400e81 	subcs	r0, r0, r1, lsl #29
    8d98:	e1500e01 	cmp	r0, r1, lsl #28
    8d9c:	e0a22002 	adc	r2, r2, r2
    8da0:	20400e01 	subcs	r0, r0, r1, lsl #28
    8da4:	e1500d81 	cmp	r0, r1, lsl #27
    8da8:	e0a22002 	adc	r2, r2, r2
    8dac:	20400d81 	subcs	r0, r0, r1, lsl #27
    8db0:	e1500d01 	cmp	r0, r1, lsl #26
    8db4:	e0a22002 	adc	r2, r2, r2
    8db8:	20400d01 	subcs	r0, r0, r1, lsl #26
    8dbc:	e1500c81 	cmp	r0, r1, lsl #25
    8dc0:	e0a22002 	adc	r2, r2, r2
    8dc4:	20400c81 	subcs	r0, r0, r1, lsl #25
    8dc8:	e1500c01 	cmp	r0, r1, lsl #24
    8dcc:	e0a22002 	adc	r2, r2, r2
    8dd0:	20400c01 	subcs	r0, r0, r1, lsl #24
    8dd4:	e1500b81 	cmp	r0, r1, lsl #23
    8dd8:	e0a22002 	adc	r2, r2, r2
    8ddc:	20400b81 	subcs	r0, r0, r1, lsl #23
    8de0:	e1500b01 	cmp	r0, r1, lsl #22
    8de4:	e0a22002 	adc	r2, r2, r2
    8de8:	20400b01 	subcs	r0, r0, r1, lsl #22
    8dec:	e1500a81 	cmp	r0, r1, lsl #21
    8df0:	e0a22002 	adc	r2, r2, r2
    8df4:	20400a81 	subcs	r0, r0, r1, lsl #21
    8df8:	e1500a01 	cmp	r0, r1, lsl #20
    8dfc:	e0a22002 	adc	r2, r2, r2
    8e00:	20400a01 	subcs	r0, r0, r1, lsl #20
    8e04:	e1500981 	cmp	r0, r1, lsl #19
    8e08:	e0a22002 	adc	r2, r2, r2
    8e0c:	20400981 	subcs	r0, r0, r1, lsl #19
    8e10:	e1500901 	cmp	r0, r1, lsl #18
    8e14:	e0a22002 	adc	r2, r2, r2
    8e18:	20400901 	subcs	r0, r0, r1, lsl #18
    8e1c:	e1500881 	cmp	r0, r1, lsl #17
    8e20:	e0a22002 	adc	r2, r2, r2
    8e24:	20400881 	subcs	r0, r0, r1, lsl #17
    8e28:	e1500801 	cmp	r0, r1, lsl #16
    8e2c:	e0a22002 	adc	r2, r2, r2
    8e30:	20400801 	subcs	r0, r0, r1, lsl #16
    8e34:	e1500781 	cmp	r0, r1, lsl #15
    8e38:	e0a22002 	adc	r2, r2, r2
    8e3c:	20400781 	subcs	r0, r0, r1, lsl #15
    8e40:	e1500701 	cmp	r0, r1, lsl #14
    8e44:	e0a22002 	adc	r2, r2, r2
    8e48:	20400701 	subcs	r0, r0, r1, lsl #14
    8e4c:	e1500681 	cmp	r0, r1, lsl #13
    8e50:	e0a22002 	adc	r2, r2, r2
    8e54:	20400681 	subcs	r0, r0, r1, lsl #13
    8e58:	e1500601 	cmp	r0, r1, lsl #12
    8e5c:	e0a22002 	adc	r2, r2, r2
    8e60:	20400601 	subcs	r0, r0, r1, lsl #12
    8e64:	e1500581 	cmp	r0, r1, lsl #11
    8e68:	e0a22002 	adc	r2, r2, r2
    8e6c:	20400581 	subcs	r0, r0, r1, lsl #11
    8e70:	e1500501 	cmp	r0, r1, lsl #10
    8e74:	e0a22002 	adc	r2, r2, r2
    8e78:	20400501 	subcs	r0, r0, r1, lsl #10
    8e7c:	e1500481 	cmp	r0, r1, lsl #9
    8e80:	e0a22002 	adc	r2, r2, r2
    8e84:	20400481 	subcs	r0, r0, r1, lsl #9
    8e88:	e1500401 	cmp	r0, r1, lsl #8
    8e8c:	e0a22002 	adc	r2, r2, r2
    8e90:	20400401 	subcs	r0, r0, r1, lsl #8
    8e94:	e1500381 	cmp	r0, r1, lsl #7
    8e98:	e0a22002 	adc	r2, r2, r2
    8e9c:	20400381 	subcs	r0, r0, r1, lsl #7
    8ea0:	e1500301 	cmp	r0, r1, lsl #6
    8ea4:	e0a22002 	adc	r2, r2, r2
    8ea8:	20400301 	subcs	r0, r0, r1, lsl #6
    8eac:	e1500281 	cmp	r0, r1, lsl #5
    8eb0:	e0a22002 	adc	r2, r2, r2
    8eb4:	20400281 	subcs	r0, r0, r1, lsl #5
    8eb8:	e1500201 	cmp	r0, r1, lsl #4
    8ebc:	e0a22002 	adc	r2, r2, r2
    8ec0:	20400201 	subcs	r0, r0, r1, lsl #4
    8ec4:	e1500181 	cmp	r0, r1, lsl #3
    8ec8:	e0a22002 	adc	r2, r2, r2
    8ecc:	20400181 	subcs	r0, r0, r1, lsl #3
    8ed0:	e1500101 	cmp	r0, r1, lsl #2
    8ed4:	e0a22002 	adc	r2, r2, r2
    8ed8:	20400101 	subcs	r0, r0, r1, lsl #2
    8edc:	e1500081 	cmp	r0, r1, lsl #1
    8ee0:	e0a22002 	adc	r2, r2, r2
    8ee4:	20400081 	subcs	r0, r0, r1, lsl #1
    8ee8:	e1500001 	cmp	r0, r1
    8eec:	e0a22002 	adc	r2, r2, r2
    8ef0:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1110
    8ef4:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1111
    8ef8:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1114
    8efc:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1115
    8f00:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1116
    8f04:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1118
    8f08:	e16f2f11 	clz	r2, r1
    8f0c:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1120
    8f10:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1121
    8f14:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1125
    8f18:	e3500000 	cmp	r0, #0
    8f1c:	13e00000 	mvnne	r0, #0
    8f20:	ea000007 	b	8f44 <__aeabi_idiv0>

00008f24 <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1156
    8f24:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1157
    8f28:	0afffffa 	beq	8f18 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1158
    8f2c:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1159
    8f30:	ebffff80 	bl	8d38 <__udivsi3>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1160
    8f34:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    8f38:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    8f3c:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1163
    8f40:	e12fff1e 	bx	lr

00008f44 <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1461
    8f44:	e12fff1e 	bx	lr

Disassembly of section .rodata:

00008f48 <_ZL13Lock_Unlocked>:
    8f48:	00000000 	andeq	r0, r0, r0

00008f4c <_ZL11Lock_Locked>:
    8f4c:	00000001 	andeq	r0, r0, r1

00008f50 <_ZL21MaxFSDriverNameLength>:
    8f50:	00000010 	andeq	r0, r0, r0, lsl r0

00008f54 <_ZL17MaxFilenameLength>:
    8f54:	00000010 	andeq	r0, r0, r0, lsl r0

00008f58 <_ZL13MaxPathLength>:
    8f58:	00000080 	andeq	r0, r0, r0, lsl #1

00008f5c <_ZL18NoFilesystemDriver>:
    8f5c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f60 <_ZL9NotifyAll>:
    8f60:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f64 <_ZL24Max_Process_Opened_Files>:
    8f64:	00000010 	andeq	r0, r0, r0, lsl r0

00008f68 <_ZL10Indefinite>:
    8f68:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f6c <_ZL18Deadline_Unchanged>:
    8f6c:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00008f70 <_ZL14Invalid_Handle>:
    8f70:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f74 <_ZN3halL18Default_Clock_RateE>:
    8f74:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

00008f78 <_ZN3halL15Peripheral_BaseE>:
    8f78:	20000000 	andcs	r0, r0, r0

00008f7c <_ZN3halL9GPIO_BaseE>:
    8f7c:	20200000 	eorcs	r0, r0, r0

00008f80 <_ZN3halL14GPIO_Pin_CountE>:
    8f80:	00000036 	andeq	r0, r0, r6, lsr r0

00008f84 <_ZN3halL8AUX_BaseE>:
    8f84:	20215000 	eorcs	r5, r1, r0

00008f88 <_ZN3halL25Interrupt_Controller_BaseE>:
    8f88:	2000b200 	andcs	fp, r0, r0, lsl #4

00008f8c <_ZN3halL10Timer_BaseE>:
    8f8c:	2000b400 	andcs	fp, r0, r0, lsl #8

00008f90 <_ZN3halL9TRNG_BaseE>:
    8f90:	20104000 	andscs	r4, r0, r0

00008f94 <_ZN3halL9BSC0_BaseE>:
    8f94:	20205000 	eorcs	r5, r0, r0

00008f98 <_ZN3halL9BSC1_BaseE>:
    8f98:	20804000 	addcs	r4, r0, r0

00008f9c <_ZN3halL9BSC2_BaseE>:
    8f9c:	20805000 	addcs	r5, r0, r0

00008fa0 <_ZL11Invalid_Pin>:
    8fa0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008fa4 <_ZL17symbol_tick_delay>:
    8fa4:	00000400 	andeq	r0, r0, r0, lsl #8

00008fa8 <_ZL15char_tick_delay>:
    8fa8:	00001000 	andeq	r1, r0, r0
    8fac:	00000031 	andeq	r0, r0, r1, lsr r0
    8fb0:	00000030 	andeq	r0, r0, r0, lsr r0
    8fb4:	3a564544 	bcc	159a4cc <__bss_end+0x1591490>
    8fb8:	6f697067 	svcvs	0x00697067
    8fbc:	0038312f 	eorseq	r3, r8, pc, lsr #2
    8fc0:	3a564544 	bcc	159a4d8 <__bss_end+0x159149c>
    8fc4:	6f697067 	svcvs	0x00697067
    8fc8:	0036312f 	eorseq	r3, r6, pc, lsr #2
    8fcc:	00676f6c 	rsbeq	r6, r7, ip, ror #30
    8fd0:	21534f53 	cmpcs	r3, r3, asr pc
    8fd4:	00000000 	andeq	r0, r0, r0

00008fd8 <_ZL13Lock_Unlocked>:
    8fd8:	00000000 	andeq	r0, r0, r0

00008fdc <_ZL11Lock_Locked>:
    8fdc:	00000001 	andeq	r0, r0, r1

00008fe0 <_ZL21MaxFSDriverNameLength>:
    8fe0:	00000010 	andeq	r0, r0, r0, lsl r0

00008fe4 <_ZL17MaxFilenameLength>:
    8fe4:	00000010 	andeq	r0, r0, r0, lsl r0

00008fe8 <_ZL13MaxPathLength>:
    8fe8:	00000080 	andeq	r0, r0, r0, lsl #1

00008fec <_ZL18NoFilesystemDriver>:
    8fec:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008ff0 <_ZL9NotifyAll>:
    8ff0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008ff4 <_ZL24Max_Process_Opened_Files>:
    8ff4:	00000010 	andeq	r0, r0, r0, lsl r0

00008ff8 <_ZL10Indefinite>:
    8ff8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008ffc <_ZL18Deadline_Unchanged>:
    8ffc:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009000 <_ZL14Invalid_Handle>:
    9000:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009004 <_ZL16Pipe_File_Prefix>:
    9004:	3a535953 	bcc	14df558 <__bss_end+0x14d651c>
    9008:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    900c:	0000002f 	andeq	r0, r0, pc, lsr #32

00009010 <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    9010:	33323130 	teqcc	r2, #48, 2
    9014:	37363534 			; <UNDEFINED> instruction: 0x37363534
    9018:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    901c:	46454443 	strbmi	r4, [r5], -r3, asr #8
	...

Disassembly of section .bss:

00009024 <sos_led>:
__bss_start():
    9024:	00000000 	andeq	r0, r0, r0

00009028 <button>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x16847f0>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x393e8>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3cffc>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c7ce8>
   4:	35312820 	ldrcc	r2, [r1, #-2080]!	; 0xfffff7e0
   8:	322d393a 	eorcc	r3, sp, #950272	; 0xe8000
   c:	2d393130 	ldfcss	f3, [r9, #-192]!	; 0xffffff40
  10:	302d3471 	eorcc	r3, sp, r1, ror r4
  14:	6e756275 	mrcvs	2, 3, r6, cr5, cr5, {3}
  18:	29317574 	ldmdbcs	r1!, {r2, r4, r5, r6, r8, sl, ip, sp, lr}
  1c:	322e3920 	eorcc	r3, lr, #32, 18	; 0x80000
  20:	3220312e 	eorcc	r3, r0, #-2147483637	; 0x8000000b
  24:	31393130 	teqcc	r9, r0, lsr r1
  28:	20353230 	eorscs	r3, r5, r0, lsr r2
  2c:	6c657228 	sfmvs	f7, 2, [r5], #-160	; 0xffffff60
  30:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
  34:	415b2029 	cmpmi	fp, r9, lsr #32
  38:	612f4d52 			; <UNDEFINED> instruction: 0x612f4d52
  3c:	392d6d72 	pushcc	{r1, r4, r5, r6, r8, sl, fp, sp, lr}
  40:	6172622d 	cmnvs	r2, sp, lsr #4
  44:	2068636e 	rsbcs	r6, r8, lr, ror #6
  48:	69766572 	ldmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
  4c:	6e6f6973 			; <UNDEFINED> instruction: 0x6e6f6973
  50:	37373220 	ldrcc	r3, [r7, -r0, lsr #4]!
  54:	5d393935 			; <UNDEFINED> instruction: 0x5d393935
	...

Disassembly of section .debug_line:

00000000 <.debug_line>:
   0:	0000005d 	andeq	r0, r0, sp, asr r0
   4:	00470003 	subeq	r0, r7, r3
   8:	01020000 	mrseq	r0, (UNDEF: 2)
   c:	000d0efb 	strdeq	r0, [sp], -fp
  10:	01010101 	tsteq	r1, r1, lsl #2
  14:	01000000 	mrseq	r0, (UNDEF: 0)
  18:	2f010000 	svccs	0x00010000
  1c:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
  20:	6863732f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, sp, lr}^
  24:	6a6b6e65 	bvs	1adb9c0 <__bss_end+0x1ad2984>
  28:	32736f2f 	rsbscc	r6, r3, #47, 30	; 0xbc
  2c:	2f323230 	svccs	0x00323230
  30:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
  34:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
  38:	752f7365 	strvc	r7, [pc, #-869]!	; fffffcdb <__bss_end+0xffff6c9f>
  3c:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
  40:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
  44:	72630000 	rsbvc	r0, r3, #0
  48:	732e3074 			; <UNDEFINED> instruction: 0x732e3074
  4c:	00000100 	andeq	r0, r0, r0, lsl #2
  50:	02050000 	andeq	r0, r5, #0
  54:	00008000 	andeq	r8, r0, r0
  58:	31010903 	tstcc	r1, r3, lsl #18
  5c:	01000202 	tsteq	r0, r2, lsl #4
  60:	00009601 	andeq	r9, r0, r1, lsl #12
  64:	47000300 	strmi	r0, [r0, -r0, lsl #6]
  68:	02000000 	andeq	r0, r0, #0
  6c:	0d0efb01 	vstreq	d15, [lr, #-4]
  70:	01010100 	mrseq	r0, (UNDEF: 17)
  74:	00000001 	andeq	r0, r0, r1
  78:	01000001 	tsteq	r0, r1
  7c:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffffc8 <__bss_end+0xffff6f8c>
  80:	63732f65 	cmnvs	r3, #404	; 0x194
  84:	6b6e6568 	blvs	1b9962c <__bss_end+0x1b905f0>
  88:	736f2f6a 	cmnvc	pc, #424	; 0x1a8
  8c:	32323032 	eorscc	r3, r2, #50	; 0x32
  90:	2f70732f 	svccs	0x0070732f
  94:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
  98:	2f736563 	svccs	0x00736563
  9c:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
  a0:	63617073 	cmnvs	r1, #115	; 0x73
  a4:	63000065 	movwvs	r0, #101	; 0x65
  a8:	2e307472 	mrccs	4, 1, r7, cr0, cr2, {3}
  ac:	00010063 	andeq	r0, r1, r3, rrx
  b0:	01050000 	mrseq	r0, (UNDEF: 5)
  b4:	08020500 	stmdaeq	r2, {r8, sl}
  b8:	03000080 	movweq	r0, #128	; 0x80
  bc:	1b050109 	blne	1404e8 <__bss_end+0x1374ac>
  c0:	4a130567 	bmi	4c1664 <__bss_end+0x4b8628>
  c4:	052f0505 	streq	r0, [pc, #-1285]!	; fffffbc7 <__bss_end+0xffff6b8b>
  c8:	04020010 	streq	r0, [r2], #-16
  cc:	33052f02 	movwcc	r2, #24322	; 0x5f02
  d0:	02040200 	andeq	r0, r4, #0, 4
  d4:	00140565 	andseq	r0, r4, r5, ror #10
  d8:	66010402 	strvs	r0, [r1], -r2, lsl #8
  dc:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
  e0:	05660104 	strbeq	r0, [r6, #-260]!	; 0xfffffefc
  e4:	05d96801 	ldrbeq	r6, [r9, #2049]	; 0x801
  e8:	05316805 	ldreq	r6, [r1, #-2053]!	; 0xfffff7fb
  ec:	05053312 	streq	r3, [r5, #-786]	; 0xfffffcee
  f0:	054b3185 	strbeq	r3, [fp, #-389]	; 0xfffffe7b
  f4:	06022f01 	streq	r2, [r2], -r1, lsl #30
  f8:	e2010100 	and	r0, r1, #0, 2
  fc:	03000000 	movweq	r0, #0
 100:	00005900 	andeq	r5, r0, r0, lsl #18
 104:	fb010200 	blx	4090e <__bss_end+0x378d2>
 108:	01000d0e 	tsteq	r0, lr, lsl #26
 10c:	00010101 	andeq	r0, r1, r1, lsl #2
 110:	00010000 	andeq	r0, r1, r0
 114:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
 118:	2f656d6f 	svccs	0x00656d6f
 11c:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
 120:	2f6a6b6e 	svccs	0x006a6b6e
 124:	3032736f 	eorscc	r7, r2, pc, ror #6
 128:	732f3232 			; <UNDEFINED> instruction: 0x732f3232
 12c:	6f732f70 	svcvs	0x00732f70
 130:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 134:	73752f73 	cmnvc	r5, #460	; 0x1cc
 138:	70737265 	rsbsvc	r7, r3, r5, ror #4
 13c:	00656361 	rsbeq	r6, r5, r1, ror #6
 140:	78786300 	ldmdavc	r8!, {r8, r9, sp, lr}^
 144:	2e696261 	cdpcs	2, 6, cr6, cr9, cr1, {3}
 148:	00707063 	rsbseq	r7, r0, r3, rrx
 14c:	3c000001 	stccc	0, cr0, [r0], {1}
 150:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
 154:	6e692d74 	mcrvs	13, 3, r2, cr9, cr4, {3}
 158:	0000003e 	andeq	r0, r0, lr, lsr r0
 15c:	02050000 	andeq	r0, r5, #0
 160:	b0020500 	andlt	r0, r2, r0, lsl #10
 164:	03000080 	movweq	r0, #128	; 0x80
 168:	0b05010a 	bleq	140598 <__bss_end+0x13755c>
 16c:	4a0a0583 	bmi	281780 <__bss_end+0x278744>
 170:	85830205 	strhi	r0, [r3, #517]	; 0x205
 174:	05830e05 	streq	r0, [r3, #3589]	; 0xe05
 178:	84856702 	strhi	r6, [r5], #1794	; 0x702
 17c:	4c860105 	stfmis	f0, [r6], {5}
 180:	4c854c85 	stcmi	12, cr4, [r5], {133}	; 0x85
 184:	00020585 	andeq	r0, r2, r5, lsl #11
 188:	4b010402 	blmi	41198 <__bss_end+0x3815c>
 18c:	12030105 	andne	r0, r3, #1073741825	; 0x40000001
 190:	6b0d052e 	blvs	341650 <__bss_end+0x338614>
 194:	02002405 	andeq	r2, r0, #83886080	; 0x5000000
 198:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 19c:	04020004 	streq	r0, [r2], #-4
 1a0:	0b058302 	bleq	160db0 <__bss_end+0x157d74>
 1a4:	02040200 	andeq	r0, r4, #0, 4
 1a8:	0002054a 	andeq	r0, r2, sl, asr #10
 1ac:	2d020402 	cfstrscs	mvf0, [r2, #-8]
 1b0:	05850905 	streq	r0, [r5, #2309]	; 0x905
 1b4:	05a12f01 	streq	r2, [r1, #3841]!	; 0xf01
 1b8:	24056a0d 	strcs	r6, [r5], #-2573	; 0xfffff5f3
 1bc:	03040200 	movweq	r0, #16896	; 0x4200
 1c0:	0004054a 	andeq	r0, r4, sl, asr #10
 1c4:	83020402 	movwhi	r0, #9218	; 0x2402
 1c8:	02000b05 	andeq	r0, r0, #5120	; 0x1400
 1cc:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 1d0:	04020002 	streq	r0, [r2], #-2
 1d4:	09052d02 	stmdbeq	r5, {r1, r8, sl, fp, sp}
 1d8:	2f010585 	svccs	0x00010585
 1dc:	01000a02 	tsteq	r0, r2, lsl #20
 1e0:	00029501 	andeq	r9, r2, r1, lsl #10
 1e4:	d4000300 	strle	r0, [r0], #-768	; 0xfffffd00
 1e8:	02000001 	andeq	r0, r0, #1
 1ec:	0d0efb01 	vstreq	d15, [lr, #-4]
 1f0:	01010100 	mrseq	r0, (UNDEF: 17)
 1f4:	00000001 	andeq	r0, r0, r1
 1f8:	01000001 	tsteq	r0, r1
 1fc:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 148 <shift+0x148>
 200:	63732f65 	cmnvs	r3, #404	; 0x194
 204:	6b6e6568 	blvs	1b997ac <__bss_end+0x1b90770>
 208:	736f2f6a 	cmnvc	pc, #424	; 0x1a8
 20c:	32323032 	eorscc	r3, r2, #50	; 0x32
 210:	2f70732f 	svccs	0x0070732f
 214:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 218:	2f736563 	svccs	0x00736563
 21c:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 220:	63617073 	cmnvs	r1, #115	; 0x73
 224:	6f732f65 	svcvs	0x00732f65
 228:	61745f73 	cmnvs	r4, r3, ror pc
 22c:	2f006b73 	svccs	0x00006b73
 230:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 234:	6863732f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, sp, lr}^
 238:	6a6b6e65 	bvs	1adbbd4 <__bss_end+0x1ad2b98>
 23c:	32736f2f 	rsbscc	r6, r3, #47, 30	; 0xbc
 240:	2f323230 	svccs	0x00323230
 244:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
 248:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 24c:	752f7365 	strvc	r7, [pc, #-869]!	; fffffeef <__bss_end+0xffff6eb3>
 250:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 254:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 258:	2f2e2e2f 	svccs	0x002e2e2f
 25c:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 260:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 264:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 268:	702f6564 	eorvc	r6, pc, r4, ror #10
 26c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 270:	2f007373 	svccs	0x00007373
 274:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 278:	6863732f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, sp, lr}^
 27c:	6a6b6e65 	bvs	1adbc18 <__bss_end+0x1ad2bdc>
 280:	32736f2f 	rsbscc	r6, r3, #47, 30	; 0xbc
 284:	2f323230 	svccs	0x00323230
 288:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
 28c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 290:	752f7365 	strvc	r7, [pc, #-869]!	; ffffff33 <__bss_end+0xffff6ef7>
 294:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 298:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 29c:	2f2e2e2f 	svccs	0x002e2e2f
 2a0:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 2a4:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 2a8:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 2ac:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
 2b0:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
 2b4:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
 2b8:	61682f30 	cmnvs	r8, r0, lsr pc
 2bc:	682f006c 	stmdavs	pc!, {r2, r3, r5, r6}	; <UNPREDICTABLE>
 2c0:	2f656d6f 	svccs	0x00656d6f
 2c4:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
 2c8:	2f6a6b6e 	svccs	0x006a6b6e
 2cc:	3032736f 	eorscc	r7, r2, pc, ror #6
 2d0:	732f3232 			; <UNDEFINED> instruction: 0x732f3232
 2d4:	6f732f70 	svcvs	0x00732f70
 2d8:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 2dc:	73752f73 	cmnvc	r5, #460	; 0x1cc
 2e0:	70737265 	rsbsvc	r7, r3, r5, ror #4
 2e4:	2f656361 	svccs	0x00656361
 2e8:	6b2f2e2e 	blvs	bcbba8 <__bss_end+0xbc2b6c>
 2ec:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 2f0:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 2f4:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 2f8:	73662f65 	cmnvc	r6, #404	; 0x194
 2fc:	6f682f00 	svcvs	0x00682f00
 300:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
 304:	6e656863 	cdpvs	8, 6, cr6, cr5, cr3, {3}
 308:	6f2f6a6b 	svcvs	0x002f6a6b
 30c:	32303273 	eorscc	r3, r0, #805306375	; 0x30000007
 310:	70732f32 	rsbsvc	r2, r3, r2, lsr pc
 314:	756f732f 	strbvc	r7, [pc, #-815]!	; ffffffed <__bss_end+0xffff6fb1>
 318:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 31c:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
 320:	61707372 	cmnvs	r0, r2, ror r3
 324:	2e2f6563 	cfsh64cs	mvdx6, mvdx15, #51
 328:	656b2f2e 	strbvs	r2, [fp, #-3886]!	; 0xfffff0d2
 32c:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 330:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 334:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 338:	6972642f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, sl, sp, lr}^
 33c:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
 340:	616d0000 	cmnvs	sp, r0
 344:	632e6e69 			; <UNDEFINED> instruction: 0x632e6e69
 348:	01007070 	tsteq	r0, r0, ror r0
 34c:	77730000 	ldrbvc	r0, [r3, -r0]!
 350:	00682e69 	rsbeq	r2, r8, r9, ror #28
 354:	69000002 	stmdbvs	r0, {r1}
 358:	6564746e 	strbvs	r7, [r4, #-1134]!	; 0xfffffb92
 35c:	00682e66 	rsbeq	r2, r8, r6, ror #28
 360:	73000003 	movwvc	r0, #3
 364:	6c6e6970 			; <UNDEFINED> instruction: 0x6c6e6970
 368:	2e6b636f 	cdpcs	3, 6, cr6, cr11, cr15, {3}
 36c:	00020068 	andeq	r0, r2, r8, rrx
 370:	6c696600 	stclvs	6, cr6, [r9], #-0
 374:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
 378:	2e6d6574 	mcrcs	5, 3, r6, cr13, cr4, {3}
 37c:	00040068 	andeq	r0, r4, r8, rrx
 380:	6f727000 	svcvs	0x00727000
 384:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 388:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 38c:	72700000 	rsbsvc	r0, r0, #0
 390:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
 394:	616d5f73 	smcvs	54771	; 0xd5f3
 398:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
 39c:	00682e72 	rsbeq	r2, r8, r2, ror lr
 3a0:	70000002 	andvc	r0, r0, r2
 3a4:	70697265 	rsbvc	r7, r9, r5, ror #4
 3a8:	61726568 	cmnvs	r2, r8, ror #10
 3ac:	682e736c 	stmdavs	lr!, {r2, r3, r5, r6, r8, r9, ip, sp, lr}
 3b0:	00000300 	andeq	r0, r0, r0, lsl #6
 3b4:	6f697067 	svcvs	0x00697067
 3b8:	0500682e 	streq	r6, [r0, #-2094]	; 0xfffff7d2
 3bc:	05000000 	streq	r0, [r0, #-0]
 3c0:	02050001 	andeq	r0, r5, #1
 3c4:	00008238 	andeq	r8, r0, r8, lsr r2
 3c8:	05011603 	streq	r1, [r1, #-1539]	; 0xfffff9fd
 3cc:	00bb9f07 	adcseq	r9, fp, r7, lsl #30
 3d0:	06010402 	streq	r0, [r1], -r2, lsl #8
 3d4:	04020066 	streq	r0, [r2], #-102	; 0xffffff9a
 3d8:	02004a02 	andeq	r4, r0, #8192	; 0x2000
 3dc:	002e0404 	eoreq	r0, lr, r4, lsl #8
 3e0:	06040402 	streq	r0, [r4], -r2, lsl #8
 3e4:	00010567 	andeq	r0, r1, r7, ror #10
 3e8:	bb040402 	bllt	1013f8 <__bss_end+0xf83bc>
 3ec:	9f1005bd 	svcls	0x001005bd
 3f0:	05820a05 	streq	r0, [r2, #2565]	; 0xa05
 3f4:	09054b0f 	stmdbeq	r5, {r0, r1, r2, r3, r8, r9, fp, lr}
 3f8:	4c170582 	cfldr32mi	mvfx0, [r7], {130}	; 0x82
 3fc:	054b0705 	strbeq	r0, [fp, #-1797]	; 0xfffff8fb
 400:	0705bc19 	smladeq	r5, r9, ip, fp
 404:	01040200 	mrseq	r0, R12_usr
 408:	00080587 	andeq	r0, r8, r7, lsl #11
 40c:	03010402 	movweq	r0, #5122	; 0x1402
 410:	0200ba09 	andeq	fp, r0, #36864	; 0x9000
 414:	00840104 	addeq	r0, r4, r4, lsl #2
 418:	4b010402 	blmi	41428 <__bss_end+0x383ec>
 41c:	01040200 	mrseq	r0, R12_usr
 420:	04020067 	streq	r0, [r2], #-103	; 0xffffff99
 424:	02004b01 	andeq	r4, r0, #1024	; 0x400
 428:	00670104 	rsbeq	r0, r7, r4, lsl #2
 42c:	4c010402 	cfstrsmi	mvf0, [r1], {2}
 430:	01040200 	mrseq	r0, R12_usr
 434:	04020068 	streq	r0, [r2], #-104	; 0xffffff98
 438:	02004b01 	andeq	r4, r0, #1024	; 0x400
 43c:	00670104 	rsbeq	r0, r7, r4, lsl #2
 440:	4b010402 	blmi	41450 <__bss_end+0x38414>
 444:	01040200 	mrseq	r0, R12_usr
 448:	04020067 	streq	r0, [r2], #-103	; 0xffffff99
 44c:	02004b01 	andeq	r4, r0, #1024	; 0x400
 450:	00680104 	rsbeq	r0, r8, r4, lsl #2
 454:	68010402 	stmdavs	r1, {r1, sl}
 458:	01040200 	mrseq	r0, R12_usr
 45c:	0402004b 	streq	r0, [r2], #-75	; 0xffffffb5
 460:	02006701 	andeq	r6, r0, #262144	; 0x40000
 464:	004b0104 	subeq	r0, fp, r4, lsl #2
 468:	67010402 	strvs	r0, [r1, -r2, lsl #8]
 46c:	02000705 	andeq	r0, r0, #1310720	; 0x140000
 470:	60030104 	andvs	r0, r3, r4, lsl #2
 474:	000e024a 	andeq	r0, lr, sl, asr #4
 478:	027c0101 	rsbseq	r0, ip, #1073741824	; 0x40000000
 47c:	00030000 	andeq	r0, r3, r0
 480:	00000149 	andeq	r0, r0, r9, asr #2
 484:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 488:	0101000d 	tsteq	r1, sp
 48c:	00000101 	andeq	r0, r0, r1, lsl #2
 490:	00000100 	andeq	r0, r0, r0, lsl #2
 494:	6f682f01 	svcvs	0x00682f01
 498:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
 49c:	6e656863 	cdpvs	8, 6, cr6, cr5, cr3, {3}
 4a0:	6f2f6a6b 	svcvs	0x002f6a6b
 4a4:	32303273 	eorscc	r3, r0, #805306375	; 0x30000007
 4a8:	70732f32 	rsbsvc	r2, r3, r2, lsr pc
 4ac:	756f732f 	strbvc	r7, [pc, #-815]!	; 185 <shift+0x185>
 4b0:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 4b4:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
 4b8:	2f62696c 	svccs	0x0062696c
 4bc:	00637273 	rsbeq	r7, r3, r3, ror r2
 4c0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 40c <shift+0x40c>
 4c4:	63732f65 	cmnvs	r3, #404	; 0x194
 4c8:	6b6e6568 	blvs	1b99a70 <__bss_end+0x1b90a34>
 4cc:	736f2f6a 	cmnvc	pc, #424	; 0x1a8
 4d0:	32323032 	eorscc	r3, r2, #50	; 0x32
 4d4:	2f70732f 	svccs	0x0070732f
 4d8:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 4dc:	2f736563 	svccs	0x00736563
 4e0:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 4e4:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 4e8:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 4ec:	702f6564 	eorvc	r6, pc, r4, ror #10
 4f0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 4f4:	2f007373 	svccs	0x00007373
 4f8:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 4fc:	6863732f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, sp, lr}^
 500:	6a6b6e65 	bvs	1adbe9c <__bss_end+0x1ad2e60>
 504:	32736f2f 	rsbscc	r6, r3, #47, 30	; 0xbc
 508:	2f323230 	svccs	0x00323230
 50c:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
 510:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 514:	6b2f7365 	blvs	bdd2b0 <__bss_end+0xbd4274>
 518:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 51c:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 520:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 524:	73662f65 	cmnvc	r6, #404	; 0x194
 528:	6f682f00 	svcvs	0x00682f00
 52c:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
 530:	6e656863 	cdpvs	8, 6, cr6, cr5, cr3, {3}
 534:	6f2f6a6b 	svcvs	0x002f6a6b
 538:	32303273 	eorscc	r3, r0, #805306375	; 0x30000007
 53c:	70732f32 	rsbsvc	r2, r3, r2, lsr pc
 540:	756f732f 	strbvc	r7, [pc, #-815]!	; 219 <shift+0x219>
 544:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 548:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 54c:	2f6c656e 	svccs	0x006c656e
 550:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 554:	2f656475 	svccs	0x00656475
 558:	72616f62 	rsbvc	r6, r1, #392	; 0x188
 55c:	70722f64 	rsbsvc	r2, r2, r4, ror #30
 560:	682f3069 	stmdavs	pc!, {r0, r3, r5, r6, ip, sp}	; <UNPREDICTABLE>
 564:	00006c61 	andeq	r6, r0, r1, ror #24
 568:	66647473 			; <UNDEFINED> instruction: 0x66647473
 56c:	2e656c69 	cdpcs	12, 6, cr6, cr5, cr9, {3}
 570:	00707063 	rsbseq	r7, r0, r3, rrx
 574:	73000001 	movwvc	r0, #1
 578:	682e6977 	stmdavs	lr!, {r0, r1, r2, r4, r5, r6, r8, fp, sp, lr}
 57c:	00000200 	andeq	r0, r0, r0, lsl #4
 580:	6e697073 	mcrvs	0, 3, r7, cr9, cr3, {3}
 584:	6b636f6c 	blvs	18dc33c <__bss_end+0x18d3300>
 588:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 58c:	69660000 	stmdbvs	r6!, {}^	; <UNPREDICTABLE>
 590:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
 594:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
 598:	0300682e 	movweq	r6, #2094	; 0x82e
 59c:	72700000 	rsbsvc	r0, r0, #0
 5a0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
 5a4:	00682e73 	rsbeq	r2, r8, r3, ror lr
 5a8:	70000002 	andvc	r0, r0, r2
 5ac:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 5b0:	6d5f7373 	ldclvs	3, cr7, [pc, #-460]	; 3ec <shift+0x3ec>
 5b4:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
 5b8:	682e7265 	stmdavs	lr!, {r0, r2, r5, r6, r9, ip, sp, lr}
 5bc:	00000200 	andeq	r0, r0, r0, lsl #4
 5c0:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
 5c4:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
 5c8:	00000400 	andeq	r0, r0, r0, lsl #8
 5cc:	00010500 	andeq	r0, r1, r0, lsl #10
 5d0:	84240205 	strthi	r0, [r4], #-517	; 0xfffffdfb
 5d4:	05160000 	ldreq	r0, [r6, #-0]
 5d8:	2c05691a 			; <UNDEFINED> instruction: 0x2c05691a
 5dc:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 5e0:	852f0105 	strhi	r0, [pc, #-261]!	; 4e3 <shift+0x4e3>
 5e4:	05833205 	streq	r3, [r3, #517]	; 0x205
 5e8:	01054b1a 	tsteq	r5, sl, lsl fp
 5ec:	1a05852f 	bne	161ab0 <__bss_end+0x158a74>
 5f0:	2f01054b 	svccs	0x0001054b
 5f4:	a1320585 	teqge	r2, r5, lsl #11
 5f8:	054b2e05 	strbeq	r2, [fp, #-3589]	; 0xfffff1fb
 5fc:	2d054b1b 	vstrcs	d4, [r5, #-108]	; 0xffffff94
 600:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 604:	852f0105 	strhi	r0, [pc, #-261]!	; 507 <shift+0x507>
 608:	05bd2e05 	ldreq	r2, [sp, #3589]!	; 0xe05
 60c:	2e054b30 	vmovcs.16	d5[0], r4
 610:	4b1b054b 	blmi	6c1b44 <__bss_end+0x6b8b08>
 614:	052f2e05 	streq	r2, [pc, #-3589]!	; fffff817 <__bss_end+0xffff67db>
 618:	01054c0c 	tsteq	r5, ip, lsl #24
 61c:	2e05852f 	cfsh32cs	mvfx8, mvfx5, #31
 620:	4b3005bd 	blmi	c01d1c <__bss_end+0xbf8ce0>
 624:	054b2e05 	strbeq	r2, [fp, #-3589]	; 0xfffff1fb
 628:	2e054b1b 	vmovcs.32	d5[0], r4
 62c:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 630:	852f0105 	strhi	r0, [pc, #-261]!	; 533 <shift+0x533>
 634:	05832e05 	streq	r2, [r3, #3589]	; 0xe05
 638:	01054b1b 	tsteq	r5, fp, lsl fp
 63c:	2e05852f 	cfsh32cs	mvfx8, mvfx5, #31
 640:	4b3305bd 	blmi	cc1d3c <__bss_end+0xcb8d00>
 644:	054b2f05 	strbeq	r2, [fp, #-3845]	; 0xfffff0fb
 648:	30054b1b 	andcc	r4, r5, fp, lsl fp
 64c:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 650:	852f0105 	strhi	r0, [pc, #-261]!	; 553 <shift+0x553>
 654:	05a12e05 	streq	r2, [r1, #3589]!	; 0xe05
 658:	1b054b2f 	blne	15331c <__bss_end+0x14a2e0>
 65c:	2f2f054b 	svccs	0x002f054b
 660:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 664:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 668:	2f05bd2e 	svccs	0x0005bd2e
 66c:	4b3b054b 	blmi	ec1ba0 <__bss_end+0xeb8b64>
 670:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
 674:	0c052f30 	stceq	15, cr2, [r5], {48}	; 0x30
 678:	2f01054c 	svccs	0x0001054c
 67c:	a12f0585 	smlawbge	pc, r5, r5, r0	; <UNPREDICTABLE>
 680:	054b3b05 	strbeq	r3, [fp, #-2821]	; 0xfffff4fb
 684:	30054b1a 	andcc	r4, r5, sl, lsl fp
 688:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 68c:	859f0105 	ldrhi	r0, [pc, #261]	; 799 <shift+0x799>
 690:	05672005 	strbeq	r2, [r7, #-5]!
 694:	31054d2d 	tstcc	r5, sp, lsr #26
 698:	4b1a054b 	blmi	681bcc <__bss_end+0x678b90>
 69c:	05300c05 	ldreq	r0, [r0, #-3077]!	; 0xfffff3fb
 6a0:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 6a4:	2d056720 	stccs	7, cr6, [r5, #-128]	; 0xffffff80
 6a8:	4b31054d 	blmi	c41be4 <__bss_end+0xc38ba8>
 6ac:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
 6b0:	0105300c 	tsteq	r5, ip
 6b4:	2005852f 	andcs	r8, r5, pc, lsr #10
 6b8:	4c2d0583 	cfstr32mi	mvfx0, [sp], #-524	; 0xfffffdf4
 6bc:	054b3e05 	strbeq	r3, [fp, #-3589]	; 0xfffff1fb
 6c0:	01054b1a 	tsteq	r5, sl, lsl fp
 6c4:	2005852f 	andcs	r8, r5, pc, lsr #10
 6c8:	4d2d0567 	cfstr32mi	mvfx0, [sp, #-412]!	; 0xfffffe64
 6cc:	054b3005 	strbeq	r3, [fp, #-5]
 6d0:	0c054b1a 			; <UNDEFINED> instruction: 0x0c054b1a
 6d4:	2f010530 	svccs	0x00010530
 6d8:	a00c0587 	andge	r0, ip, r7, lsl #11
 6dc:	bc31059f 	cfldr32lt	mvfx0, [r1], #-636	; 0xfffffd84
 6e0:	05662905 	strbeq	r2, [r6, #-2309]!	; 0xfffff6fb
 6e4:	0f052e36 	svceq	0x00052e36
 6e8:	66130530 			; <UNDEFINED> instruction: 0x66130530
 6ec:	05840905 	streq	r0, [r4, #2309]	; 0x905
 6f0:	0105d810 	tsteq	r5, r0, lsl r8
 6f4:	0008029f 	muleq	r8, pc, r2	; <UNPREDICTABLE>
 6f8:	02760101 	rsbseq	r0, r6, #1073741824	; 0x40000000
 6fc:	00030000 	andeq	r0, r3, r0
 700:	0000004f 	andeq	r0, r0, pc, asr #32
 704:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 708:	0101000d 	tsteq	r1, sp
 70c:	00000101 	andeq	r0, r0, r1, lsl #2
 710:	00000100 	andeq	r0, r0, r0, lsl #2
 714:	6f682f01 	svcvs	0x00682f01
 718:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
 71c:	6e656863 	cdpvs	8, 6, cr6, cr5, cr3, {3}
 720:	6f2f6a6b 	svcvs	0x002f6a6b
 724:	32303273 	eorscc	r3, r0, #805306375	; 0x30000007
 728:	70732f32 	rsbsvc	r2, r3, r2, lsr pc
 72c:	756f732f 	strbvc	r7, [pc, #-815]!	; 405 <shift+0x405>
 730:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 734:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
 738:	2f62696c 	svccs	0x0062696c
 73c:	00637273 	rsbeq	r7, r3, r3, ror r2
 740:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
 744:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
 748:	632e676e 			; <UNDEFINED> instruction: 0x632e676e
 74c:	01007070 	tsteq	r0, r0, ror r0
 750:	05000000 	streq	r0, [r0, #-0]
 754:	02050001 	andeq	r0, r5, #1
 758:	00008880 	andeq	r8, r0, r0, lsl #17
 75c:	bb06051a 	bllt	181bcc <__bss_end+0x178b90>
 760:	054c0f05 	strbeq	r0, [ip, #-3845]	; 0xfffff0fb
 764:	0a056821 	beq	15a7f0 <__bss_end+0x1517b4>
 768:	2e0b05ba 	mcrcs	5, 0, r0, cr11, cr10, {5}
 76c:	054a2705 	strbeq	r2, [sl, #-1797]	; 0xfffff8fb
 770:	09054a0d 	stmdbeq	r5, {r0, r2, r3, r9, fp, lr}
 774:	9f04052f 	svcls	0x0004052f
 778:	05620205 	strbeq	r0, [r2, #-517]!	; 0xfffffdfb
 77c:	10053505 	andne	r3, r5, r5, lsl #10
 780:	2e110568 	cfmsc32cs	mvfx0, mvfx1, mvfx8
 784:	054a2205 	strbeq	r2, [sl, #-517]	; 0xfffffdfb
 788:	0a052e13 	beq	14bfdc <__bss_end+0x142fa0>
 78c:	6909052f 	stmdbvs	r9, {r0, r1, r2, r3, r5, r8, sl}
 790:	052e0a05 	streq	r0, [lr, #-2565]!	; 0xfffff5fb
 794:	03054a0c 	movweq	r4, #23052	; 0x5a0c
 798:	680b054b 	stmdavs	fp, {r0, r1, r3, r6, r8, sl}
 79c:	02001805 	andeq	r1, r0, #327680	; 0x50000
 7a0:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 7a4:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
 7a8:	15059e03 	strne	r9, [r5, #-3587]	; 0xfffff1fd
 7ac:	02040200 	andeq	r0, r4, #0, 4
 7b0:	00180568 	andseq	r0, r8, r8, ror #10
 7b4:	82020402 	andhi	r0, r2, #33554432	; 0x2000000
 7b8:	02000805 	andeq	r0, r0, #327680	; 0x50000
 7bc:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 7c0:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
 7c4:	1b054b02 	blne	1533d4 <__bss_end+0x14a398>
 7c8:	02040200 	andeq	r0, r4, #0, 4
 7cc:	000c052e 	andeq	r0, ip, lr, lsr #10
 7d0:	4a020402 	bmi	817e0 <__bss_end+0x787a4>
 7d4:	02000f05 	andeq	r0, r0, #5, 30
 7d8:	05820204 	streq	r0, [r2, #516]	; 0x204
 7dc:	0402001b 	streq	r0, [r2], #-27	; 0xffffffe5
 7e0:	11054a02 	tstne	r5, r2, lsl #20
 7e4:	02040200 	andeq	r0, r4, #0, 4
 7e8:	000a052e 	andeq	r0, sl, lr, lsr #10
 7ec:	2f020402 	svccs	0x00020402
 7f0:	02000b05 	andeq	r0, r0, #5120	; 0x1400
 7f4:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 7f8:	0402000d 	streq	r0, [r2], #-13
 7fc:	02054a02 	andeq	r4, r5, #8192	; 0x2000
 800:	02040200 	andeq	r0, r4, #0, 4
 804:	88010546 	stmdahi	r1, {r1, r2, r6, r8, sl}
 808:	83060585 	movwhi	r0, #25989	; 0x6585
 80c:	054c0905 	strbeq	r0, [ip, #-2309]	; 0xfffff6fb
 810:	0a054a10 	beq	153058 <__bss_end+0x14a01c>
 814:	bb07054c 	bllt	1c1d4c <__bss_end+0x1b8d10>
 818:	054a0305 	strbeq	r0, [sl, #-773]	; 0xfffffcfb
 81c:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
 820:	14054a01 	strne	r4, [r5], #-2561	; 0xfffff5ff
 824:	01040200 	mrseq	r0, R12_usr
 828:	4d0d054a 	cfstr32mi	mvfx0, [sp, #-296]	; 0xfffffed8
 82c:	054a1405 	strbeq	r1, [sl, #-1029]	; 0xfffffbfb
 830:	08052e0a 	stmdaeq	r5, {r1, r3, r9, sl, fp, sp}
 834:	03020568 	movweq	r0, #9576	; 0x2568
 838:	09056678 	stmdbeq	r5, {r3, r4, r5, r6, r9, sl, sp, lr}
 83c:	052e0b03 	streq	r0, [lr, #-2819]!	; 0xfffff4fd
 840:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 844:	1605bd09 	strne	fp, [r5], -r9, lsl #26
 848:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 84c:	001d054a 	andseq	r0, sp, sl, asr #10
 850:	82020402 	andhi	r0, r2, #33554432	; 0x2000000
 854:	02001e05 	andeq	r1, r0, #5, 28	; 0x50
 858:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 85c:	04020016 	streq	r0, [r2], #-22	; 0xffffffea
 860:	11056602 	tstne	r5, r2, lsl #12
 864:	03040200 	movweq	r0, #16896	; 0x4200
 868:	0012054b 	andseq	r0, r2, fp, asr #10
 86c:	2e030402 	cdpcs	4, 0, cr0, cr3, cr2, {0}
 870:	02000805 	andeq	r0, r0, #327680	; 0x50000
 874:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 878:	04020009 	streq	r0, [r2], #-9
 87c:	12052e03 	andne	r2, r5, #3, 28	; 0x30
 880:	03040200 	movweq	r0, #16896	; 0x4200
 884:	000b054a 	andeq	r0, fp, sl, asr #10
 888:	2e030402 	cdpcs	4, 0, cr0, cr3, cr2, {0}
 88c:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 890:	052d0304 	streq	r0, [sp, #-772]!	; 0xfffffcfc
 894:	0402000b 	streq	r0, [r2], #-11
 898:	08058402 	stmdaeq	r5, {r1, sl, pc}
 89c:	01040200 	mrseq	r0, R12_usr
 8a0:	00090583 	andeq	r0, r9, r3, lsl #11
 8a4:	2e010402 	cdpcs	4, 0, cr0, cr1, cr2, {0}
 8a8:	02000b05 	andeq	r0, r0, #5120	; 0x1400
 8ac:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
 8b0:	04020002 	streq	r0, [r2], #-2
 8b4:	0b054901 	bleq	152cc0 <__bss_end+0x149c84>
 8b8:	2f010585 	svccs	0x00010585
 8bc:	bc0e0585 	cfstr32lt	mvfx0, [lr], {133}	; 0x85
 8c0:	05661105 	strbeq	r1, [r6, #-261]!	; 0xfffffefb
 8c4:	0b05bc20 	bleq	16f94c <__bss_end+0x166910>
 8c8:	4b1f0566 	blmi	7c1e68 <__bss_end+0x7b8e2c>
 8cc:	05660a05 	strbeq	r0, [r6, #-2565]!	; 0xfffff5fb
 8d0:	11054b08 	tstne	r5, r8, lsl #22
 8d4:	2e160583 	cdpcs	5, 1, cr0, cr6, cr3, {4}
 8d8:	05670805 	strbeq	r0, [r7, #-2053]!	; 0xfffff7fb
 8dc:	0b056711 	bleq	15a528 <__bss_end+0x1514ec>
 8e0:	2f01054d 	svccs	0x0001054d
 8e4:	83060585 	movwhi	r0, #25989	; 0x6585
 8e8:	054c0b05 	strbeq	r0, [ip, #-2821]	; 0xfffff4fb
 8ec:	0e052e0c 	cdpeq	14, 0, cr2, cr5, cr12, {0}
 8f0:	4b040566 	blmi	101e90 <__bss_end+0xf8e54>
 8f4:	05650205 	strbeq	r0, [r5, #-517]!	; 0xfffffdfb
 8f8:	01053109 	tsteq	r5, r9, lsl #2
 8fc:	0805852f 	stmdaeq	r5, {r0, r1, r2, r3, r5, r8, sl, pc}
 900:	4c0b059f 	cfstr32mi	mvfx0, [fp], {159}	; 0x9f
 904:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
 908:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 90c:	04020007 	streq	r0, [r2], #-7
 910:	08058302 	stmdaeq	r5, {r1, r8, r9, pc}
 914:	02040200 	andeq	r0, r4, #0, 4
 918:	000a052e 	andeq	r0, sl, lr, lsr #10
 91c:	4a020402 	bmi	8192c <__bss_end+0x788f0>
 920:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 924:	05490204 	strbeq	r0, [r9, #-516]	; 0xfffffdfc
 928:	05858401 	streq	r8, [r5, #1025]	; 0x401
 92c:	0805bb0e 	stmdaeq	r5, {r1, r2, r3, r8, r9, fp, ip, sp, pc}
 930:	4c0b054b 	cfstr32mi	mvfx0, [fp], {75}	; 0x4b
 934:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
 938:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 93c:	04020016 	streq	r0, [r2], #-22	; 0xffffffea
 940:	17058302 	strne	r8, [r5, -r2, lsl #6]
 944:	02040200 	andeq	r0, r4, #0, 4
 948:	000a052e 	andeq	r0, sl, lr, lsr #10
 94c:	4a020402 	bmi	8195c <__bss_end+0x78920>
 950:	02000b05 	andeq	r0, r0, #5120	; 0x1400
 954:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 958:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
 95c:	0d054a02 	vstreq	s8, [r5, #-8]
 960:	02040200 	andeq	r0, r4, #0, 4
 964:	0002052e 	andeq	r0, r2, lr, lsr #10
 968:	2d020402 	cfstrscs	mvf0, [r2, #-8]
 96c:	02840105 	addeq	r0, r4, #1073741825	; 0x40000001
 970:	01010008 	tsteq	r1, r8
 974:	00000079 	andeq	r0, r0, r9, ror r0
 978:	00460003 	subeq	r0, r6, r3
 97c:	01020000 	mrseq	r0, (UNDEF: 2)
 980:	000d0efb 	strdeq	r0, [sp], -fp
 984:	01010101 	tsteq	r1, r1, lsl #2
 988:	01000000 	mrseq	r0, (UNDEF: 0)
 98c:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
 990:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 994:	2f2e2e2f 	svccs	0x002e2e2f
 998:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 99c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 9a0:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
 9a4:	2f636367 	svccs	0x00636367
 9a8:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
 9ac:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
 9b0:	00006d72 	andeq	r6, r0, r2, ror sp
 9b4:	3162696c 	cmncc	r2, ip, ror #18
 9b8:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
 9bc:	00532e73 	subseq	r2, r3, r3, ror lr
 9c0:	00000001 	andeq	r0, r0, r1
 9c4:	38020500 	stmdacc	r2, {r8, sl}
 9c8:	0300008d 	movweq	r0, #141	; 0x8d
 9cc:	300108ca 	andcc	r0, r1, sl, asr #17
 9d0:	2f2f2f2f 	svccs	0x002f2f2f
 9d4:	d002302f 	andle	r3, r2, pc, lsr #32
 9d8:	312f1401 			; <UNDEFINED> instruction: 0x312f1401
 9dc:	4c302f2f 	ldcmi	15, cr2, [r0], #-188	; 0xffffff44
 9e0:	1f03322f 	svcne	0x0003322f
 9e4:	2f2f2f66 	svccs	0x002f2f66
 9e8:	2f2f2f2f 	svccs	0x002f2f2f
 9ec:	01000202 	tsteq	r0, r2, lsl #4
 9f0:	00005c01 	andeq	r5, r0, r1, lsl #24
 9f4:	46000300 	strmi	r0, [r0], -r0, lsl #6
 9f8:	02000000 	andeq	r0, r0, #0
 9fc:	0d0efb01 	vstreq	d15, [lr, #-4]
 a00:	01010100 	mrseq	r0, (UNDEF: 17)
 a04:	00000001 	andeq	r0, r0, r1
 a08:	01000001 	tsteq	r0, r1
 a0c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 a10:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 a14:	2f2e2e2f 	svccs	0x002e2e2f
 a18:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 a1c:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
 a20:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 a24:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
 a28:	2f676966 	svccs	0x00676966
 a2c:	006d7261 	rsbeq	r7, sp, r1, ror #4
 a30:	62696c00 	rsbvs	r6, r9, #0, 24
 a34:	6e756631 	mrcvs	6, 3, r6, cr5, cr1, {1}
 a38:	532e7363 			; <UNDEFINED> instruction: 0x532e7363
 a3c:	00000100 	andeq	r0, r0, r0, lsl #2
 a40:	02050000 	andeq	r0, r5, #0
 a44:	00008f44 	andeq	r8, r0, r4, asr #30
 a48:	010bb403 	tsteq	fp, r3, lsl #8
 a4c:	01000202 	tsteq	r0, r2, lsl #4
 a50:	00010301 	andeq	r0, r1, r1, lsl #6
 a54:	fd000300 	stc2	3, cr0, [r0, #-0]
 a58:	02000000 	andeq	r0, r0, #0
 a5c:	0d0efb01 	vstreq	d15, [lr, #-4]
 a60:	01010100 	mrseq	r0, (UNDEF: 17)
 a64:	00000001 	andeq	r0, r0, r1
 a68:	01000001 	tsteq	r0, r1
 a6c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 a70:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 a74:	2f2e2e2f 	svccs	0x002e2e2f
 a78:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 a7c:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
 a80:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 a84:	2f2e2e2f 	svccs	0x002e2e2f
 a88:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 a8c:	00656475 	rsbeq	r6, r5, r5, ror r4
 a90:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 a94:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 a98:	2f2e2e2f 	svccs	0x002e2e2f
 a9c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 aa0:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
 aa4:	2f2e2e00 	svccs	0x002e2e00
 aa8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 aac:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 ab0:	2f2e2e2f 	svccs	0x002e2e2f
 ab4:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; a04 <shift+0xa04>
 ab8:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 abc:	2e2e2f63 	cdpcs	15, 2, cr2, cr14, cr3, {3}
 ac0:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
 ac4:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
 ac8:	2f676966 	svccs	0x00676966
 acc:	006d7261 	rsbeq	r7, sp, r1, ror #4
 ad0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 ad4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 ad8:	2f2e2e2f 	svccs	0x002e2e2f
 adc:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 ae0:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
 ae4:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 ae8:	61680000 	cmnvs	r8, r0
 aec:	61746873 	cmnvs	r4, r3, ror r8
 af0:	00682e62 	rsbeq	r2, r8, r2, ror #28
 af4:	61000001 	tstvs	r0, r1
 af8:	692d6d72 	pushvs	{r1, r4, r5, r6, r8, sl, fp, sp, lr}
 afc:	682e6173 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, sp, lr}
 b00:	00000200 	andeq	r0, r0, r0, lsl #4
 b04:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
 b08:	2e757063 	cdpcs	0, 7, cr7, cr5, cr3, {3}
 b0c:	00020068 	andeq	r0, r2, r8, rrx
 b10:	736e6900 	cmnvc	lr, #0, 18
 b14:	6f632d6e 	svcvs	0x00632d6e
 b18:	6174736e 	cmnvs	r4, lr, ror #6
 b1c:	2e73746e 	cdpcs	4, 7, cr7, cr3, cr14, {3}
 b20:	00020068 	andeq	r0, r2, r8, rrx
 b24:	6d726100 	ldfvse	f6, [r2, #-0]
 b28:	0300682e 	movweq	r6, #2094	; 0x82e
 b2c:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
 b30:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 b34:	00682e32 	rsbeq	r2, r8, r2, lsr lr
 b38:	67000004 	strvs	r0, [r0, -r4]
 b3c:	632d6c62 			; <UNDEFINED> instruction: 0x632d6c62
 b40:	73726f74 	cmnvc	r2, #116, 30	; 0x1d0
 b44:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
 b48:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
 b4c:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 b50:	00632e32 	rsbeq	r2, r3, r2, lsr lr
 b54:	00000004 	andeq	r0, r0, r4

Disassembly of section .debug_info:

00000000 <.debug_info>:
       0:	00000022 	andeq	r0, r0, r2, lsr #32
       4:	00000002 	andeq	r0, r0, r2
       8:	01040000 	mrseq	r0, (UNDEF: 4)
       c:	00000000 	andeq	r0, r0, r0
      10:	00008000 	andeq	r8, r0, r0
      14:	00008008 	andeq	r8, r0, r8
      18:	00000000 	andeq	r0, r0, r0
      1c:	00000031 	andeq	r0, r0, r1, lsr r0
      20:	00000061 	andeq	r0, r0, r1, rrx
      24:	009a8001 	addseq	r8, sl, r1
      28:	00040000 	andeq	r0, r4, r0
      2c:	00000014 	andeq	r0, r0, r4, lsl r0
      30:	00b80104 	adcseq	r0, r8, r4, lsl #2
      34:	6d0c0000 	stcvs	0, cr0, [ip, #-0]
      38:	31000000 	mrscc	r0, (UNDEF: 0)
      3c:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
      40:	a8000080 	stmdage	r0, {r7}
      44:	61000000 	mrsvs	r0, (UNDEF: 0)
      48:	02000000 	andeq	r0, r0, #0
      4c:	00000173 	andeq	r0, r0, r3, ror r1
      50:	31150601 	tstcc	r5, r1, lsl #12
      54:	03000000 	movweq	r0, #0
      58:	1cd70704 	ldclne	7, cr0, [r7], {4}
      5c:	ae020000 	cdpge	0, 0, cr0, cr2, cr0, {0}
      60:	01000000 	mrseq	r0, (UNDEF: 0)
      64:	00311507 	eorseq	r1, r1, r7, lsl #10
      68:	85040000 	strhi	r0, [r4, #-0]
      6c:	01000001 	tsteq	r0, r1
      70:	80700610 	rsbshi	r0, r0, r0, lsl r6
      74:	00400000 	subeq	r0, r0, r0
      78:	9c010000 	stcls	0, cr0, [r1], {-0}
      7c:	0000006a 	andeq	r0, r0, sl, rrx
      80:	00016c05 	andeq	r6, r1, r5, lsl #24
      84:	091b0100 	ldmdbeq	fp, {r8}
      88:	0000006a 	andeq	r0, r0, sl, rrx
      8c:	00749102 	rsbseq	r9, r4, r2, lsl #2
      90:	69050406 	stmdbvs	r5, {r1, r2, sl}
      94:	0700746e 	streq	r7, [r0, -lr, ror #8]
      98:	0000009e 	muleq	r0, lr, r0
      9c:	08060901 	stmdaeq	r6, {r0, r8, fp}
      a0:	68000080 	stmdavs	r0, {r7}
      a4:	01000000 	mrseq	r0, (UNDEF: 0)
      a8:	0000979c 	muleq	r0, ip, r7
      ac:	017f0500 	cmneq	pc, r0, lsl #10
      b0:	0b010000 	bleq	400b8 <__bss_end+0x3707c>
      b4:	00009713 	andeq	r9, r0, r3, lsl r7
      b8:	74910200 	ldrvc	r0, [r1], #512	; 0x200
      bc:	31040800 	tstcc	r4, r0, lsl #16
      c0:	00000000 	andeq	r0, r0, r0
      c4:	00000202 	andeq	r0, r0, r2, lsl #4
      c8:	009f0004 	addseq	r0, pc, r4
      cc:	01040000 	mrseq	r0, (UNDEF: 4)
      d0:	00000245 	andeq	r0, r0, r5, asr #4
      d4:	0001f504 	andeq	pc, r1, r4, lsl #10
      d8:	00003100 	andeq	r3, r0, r0, lsl #2
      dc:	0080b000 	addeq	fp, r0, r0
      e0:	00018800 	andeq	r8, r1, r0, lsl #16
      e4:	0000fb00 	andeq	pc, r0, r0, lsl #22
      e8:	03800200 	orreq	r0, r0, #0, 4
      ec:	2f010000 	svccs	0x00010000
      f0:	00003107 	andeq	r3, r0, r7, lsl #2
      f4:	37040300 	strcc	r0, [r4, -r0, lsl #6]
      f8:	04000000 	streq	r0, [r0], #-0
      fc:	00032702 	andeq	r2, r3, r2, lsl #14
     100:	07300100 	ldreq	r0, [r0, -r0, lsl #2]!
     104:	00000031 	andeq	r0, r0, r1, lsr r0
     108:	00002505 	andeq	r2, r0, r5, lsl #10
     10c:	00005700 	andeq	r5, r0, r0, lsl #14
     110:	00570600 	subseq	r0, r7, r0, lsl #12
     114:	ffff0000 			; <UNDEFINED> instruction: 0xffff0000
     118:	0700ffff 			; <UNDEFINED> instruction: 0x0700ffff
     11c:	1cd70704 	ldclne	7, cr0, [r7], {4}
     120:	72080000 	andvc	r0, r8, #0
     124:	01000003 	tsteq	r0, r3
     128:	00441533 	subeq	r1, r4, r3, lsr r5
     12c:	4a080000 	bmi	200134 <__bss_end+0x1f70f8>
     130:	01000003 	tsteq	r0, r3
     134:	00441535 	subeq	r1, r4, r5, lsr r5
     138:	38050000 	stmdacc	r5, {}	; <UNPREDICTABLE>
     13c:	89000000 	stmdbhi	r0, {}	; <UNPREDICTABLE>
     140:	06000000 	streq	r0, [r0], -r0
     144:	00000057 	andeq	r0, r0, r7, asr r0
     148:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
     14c:	02370800 	eorseq	r0, r7, #0, 16
     150:	38010000 	stmdacc	r1, {}	; <UNPREDICTABLE>
     154:	00007615 	andeq	r7, r0, r5, lsl r6
     158:	03300800 	teqeq	r0, #0, 16
     15c:	3a010000 	bcc	40164 <__bss_end+0x37128>
     160:	00007615 	andeq	r7, r0, r5, lsl r6
     164:	01af0900 			; <UNDEFINED> instruction: 0x01af0900
     168:	48010000 	stmdami	r1, {}	; <UNPREDICTABLE>
     16c:	0000cb10 	andeq	ip, r0, r0, lsl fp
     170:	0081e000 	addeq	lr, r1, r0
     174:	00005800 	andeq	r5, r0, r0, lsl #16
     178:	cb9c0100 	blgt	fe700580 <__bss_end+0xfe6f7544>
     17c:	0a000000 	beq	184 <shift+0x184>
     180:	000001bd 			; <UNDEFINED> instruction: 0x000001bd
     184:	d20c4a01 	andle	r4, ip, #4096	; 0x1000
     188:	02000000 	andeq	r0, r0, #0
     18c:	0b007491 	bleq	1d3d8 <__bss_end+0x1439c>
     190:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
     194:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
     198:	00000038 	andeq	r0, r0, r8, lsr r0
     19c:	00036509 	andeq	r6, r3, r9, lsl #10
     1a0:	103c0100 	eorsne	r0, ip, r0, lsl #2
     1a4:	000000cb 	andeq	r0, r0, fp, asr #1
     1a8:	00008188 	andeq	r8, r0, r8, lsl #3
     1ac:	00000058 	andeq	r0, r0, r8, asr r0
     1b0:	01029c01 	tsteq	r2, r1, lsl #24
     1b4:	bd0a0000 	stclt	0, cr0, [sl, #-0]
     1b8:	01000001 	tsteq	r0, r1
     1bc:	01020c3e 	tsteq	r2, lr, lsr ip
     1c0:	91020000 	mrsls	r0, (UNDEF: 2)
     1c4:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
     1c8:	00000025 	andeq	r0, r0, r5, lsr #32
     1cc:	0001980c 	andeq	r9, r1, ip, lsl #16
     1d0:	11290100 			; <UNDEFINED> instruction: 0x11290100
     1d4:	0000817c 	andeq	r8, r0, ip, ror r1
     1d8:	0000000c 	andeq	r0, r0, ip
     1dc:	ce0c9c01 	cdpgt	12, 0, cr9, cr12, cr1, {0}
     1e0:	01000001 	tsteq	r0, r1
     1e4:	81641124 	cmnhi	r4, r4, lsr #2
     1e8:	00180000 	andseq	r0, r8, r0
     1ec:	9c010000 	stcls	0, cr0, [r1], {-0}
     1f0:	00033d0c 	andeq	r3, r3, ip, lsl #26
     1f4:	111f0100 	tstne	pc, r0, lsl #2
     1f8:	0000814c 	andeq	r8, r0, ip, asr #2
     1fc:	00000018 	andeq	r0, r0, r8, lsl r0
     200:	2a0c9c01 	bcs	32720c <__bss_end+0x31e1d0>
     204:	01000002 	tsteq	r0, r2
     208:	8134111a 	teqhi	r4, sl, lsl r1
     20c:	00180000 	andseq	r0, r8, r0
     210:	9c010000 	stcls	0, cr0, [r1], {-0}
     214:	0001c30d 	andeq	ip, r1, sp, lsl #6
     218:	9e000200 	cdpls	2, 0, cr0, cr0, cr0, {0}
     21c:	0e000001 	cdpeq	0, 0, cr0, cr0, cr1, {0}
     220:	00000315 	andeq	r0, r0, r5, lsl r3
     224:	6d121401 	cfldrsvs	mvf1, [r2, #-4]
     228:	0f000001 	svceq	0x00000001
     22c:	0000019e 	muleq	r0, lr, r1
     230:	01900200 	orrseq	r0, r0, r0, lsl #4
     234:	04010000 	streq	r0, [r1], #-0
     238:	0001a41c 	andeq	sl, r1, ip, lsl r4
     23c:	01e10e00 	mvneq	r0, r0, lsl #28
     240:	0f010000 	svceq	0x00010000
     244:	00018b12 	andeq	r8, r1, r2, lsl fp
     248:	019e0f00 	orrseq	r0, lr, r0, lsl #30
     24c:	10000000 	andne	r0, r0, r0
     250:	00000389 	andeq	r0, r0, r9, lsl #7
     254:	cb110a01 	blgt	442a60 <__bss_end+0x439a24>
     258:	0f000000 	svceq	0x00000000
     25c:	0000019e 	muleq	r0, lr, r1
     260:	04030000 	streq	r0, [r3], #-0
     264:	0000016d 	andeq	r0, r0, sp, ror #2
     268:	57050807 	strpl	r0, [r5, -r7, lsl #16]
     26c:	11000003 	tstne	r0, r3
     270:	0000015b 	andeq	r0, r0, fp, asr r1
     274:	00008114 	andeq	r8, r0, r4, lsl r1
     278:	00000020 	andeq	r0, r0, r0, lsr #32
     27c:	01c79c01 	biceq	r9, r7, r1, lsl #24
     280:	9e120000 	cdpls	0, 1, cr0, cr2, cr0, {0}
     284:	02000001 	andeq	r0, r0, #1
     288:	11007491 			; <UNDEFINED> instruction: 0x11007491
     28c:	00000179 	andeq	r0, r0, r9, ror r1
     290:	000080e8 	andeq	r8, r0, r8, ror #1
     294:	0000002c 	andeq	r0, r0, ip, lsr #32
     298:	01e89c01 	mvneq	r9, r1, lsl #24
     29c:	67130000 	ldrvs	r0, [r3, -r0]
     2a0:	300f0100 	andcc	r0, pc, r0, lsl #2
     2a4:	0000019e 	muleq	r0, lr, r1
     2a8:	00749102 	rsbseq	r9, r4, r2, lsl #2
     2ac:	00018b14 	andeq	r8, r1, r4, lsl fp
     2b0:	0080b000 	addeq	fp, r0, r0
     2b4:	00003800 	andeq	r3, r0, r0, lsl #16
     2b8:	139c0100 	orrsne	r0, ip, #0, 2
     2bc:	0a010067 	beq	40460 <__bss_end+0x37424>
     2c0:	00019e2f 	andeq	r9, r1, pc, lsr #28
     2c4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     2c8:	0e440000 	cdpeq	0, 4, cr0, cr4, cr0, {0}
     2cc:	00040000 	andeq	r0, r4, r0
     2d0:	000001c6 	andeq	r0, r0, r6, asr #3
     2d4:	02450104 	subeq	r0, r5, #4, 2
     2d8:	d8040000 	stmdale	r4, {}	; <UNPREDICTABLE>
     2dc:	3100000d 	tstcc	r0, sp
     2e0:	38000000 	stmdacc	r0, {}	; <UNPREDICTABLE>
     2e4:	ec000082 	stc	0, cr0, [r0], {130}	; 0x82
     2e8:	e1000001 	tst	r0, r1
     2ec:	02000001 	andeq	r0, r0, #1
     2f0:	10350801 	eorsne	r0, r5, r1, lsl #16
     2f4:	25030000 	strcs	r0, [r3, #-0]
     2f8:	02000000 	andeq	r0, r0, #0
     2fc:	0d890502 	cfstr32eq	mvfx0, [r9, #8]
     300:	04040000 	streq	r0, [r4], #-0
     304:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
     308:	08010200 	stmdaeq	r1, {r9}
     30c:	0000102c 	andeq	r1, r0, ip, lsr #32
     310:	c6070202 	strgt	r0, [r7], -r2, lsl #4
     314:	05000011 	streq	r0, [r0, #-17]	; 0xffffffef
     318:	000006c8 	andeq	r0, r0, r8, asr #13
     31c:	5e070903 	vmlapl.f16	s0, s14, s6	; <UNPREDICTABLE>
     320:	03000000 	movweq	r0, #0
     324:	0000004d 	andeq	r0, r0, sp, asr #32
     328:	d7070402 	strle	r0, [r7, -r2, lsl #8]
     32c:	0300001c 	movweq	r0, #28
     330:	0000005e 	andeq	r0, r0, lr, asr r0
     334:	00005e06 	andeq	r5, r0, r6, lsl #28
     338:	12bf0700 	adcsne	r0, pc, #0, 14
     33c:	02080000 	andeq	r0, r8, #0
     340:	00950806 	addseq	r0, r5, r6, lsl #16
     344:	72080000 	andvc	r0, r8, #0
     348:	08020030 	stmdaeq	r2, {r4, r5}
     34c:	00004d0e 	andeq	r4, r0, lr, lsl #26
     350:	72080000 	andvc	r0, r8, #0
     354:	09020031 	stmdbeq	r2, {r0, r4, r5}
     358:	00004d0e 	andeq	r4, r0, lr, lsl #26
     35c:	09000400 	stmdbeq	r0, {sl}
     360:	00000e7c 	andeq	r0, r0, ip, ror lr
     364:	00380405 	eorseq	r0, r8, r5, lsl #8
     368:	1e020000 	cdpne	0, 0, cr0, cr2, cr0, {0}
     36c:	0000cc0c 	andeq	ip, r0, ip, lsl #24
     370:	06c00a00 	strbeq	r0, [r0], r0, lsl #20
     374:	0a000000 	beq	37c <shift+0x37c>
     378:	000008e9 	andeq	r0, r0, r9, ror #17
     37c:	0e9e0a01 	vfnmseq.f32	s0, s28, s2
     380:	0a020000 	beq	80388 <__bss_end+0x7734c>
     384:	00001048 	andeq	r1, r0, r8, asr #32
     388:	08d40a03 	ldmeq	r4, {r0, r1, r9, fp}^
     38c:	0a040000 	beq	100394 <__bss_end+0xf7358>
     390:	00000d61 	andeq	r0, r0, r1, ror #26
     394:	5c090005 	stcpl	0, cr0, [r9], {5}
     398:	0500000e 	streq	r0, [r0, #-14]
     39c:	00003804 	andeq	r3, r0, r4, lsl #16
     3a0:	0c3f0200 	lfmeq	f0, 4, [pc], #-0	; 3a8 <shift+0x3a8>
     3a4:	00000109 	andeq	r0, r0, r9, lsl #2
     3a8:	00082b0a 	andeq	r2, r8, sl, lsl #22
     3ac:	850a0000 	strhi	r0, [sl, #-0]
     3b0:	0100000f 	tsteq	r0, pc
     3b4:	0012460a 	andseq	r4, r2, sl, lsl #12
     3b8:	600a0200 	andvs	r0, sl, r0, lsl #4
     3bc:	0300000c 	movweq	r0, #12
     3c0:	0008e30a 	andeq	lr, r8, sl, lsl #6
     3c4:	d20a0400 	andle	r0, sl, #0, 8
     3c8:	05000009 	streq	r0, [r0, #-9]
     3cc:	00072d0a 	andeq	r2, r7, sl, lsl #26
     3d0:	09000600 	stmdbeq	r0, {r9, sl}
     3d4:	00000712 	andeq	r0, r0, r2, lsl r7
     3d8:	00380405 	eorseq	r0, r8, r5, lsl #8
     3dc:	66020000 	strvs	r0, [r2], -r0
     3e0:	0001340c 	andeq	r3, r1, ip, lsl #8
     3e4:	10210a00 	eorne	r0, r1, r0, lsl #20
     3e8:	0a000000 	beq	3f0 <shift+0x3f0>
     3ec:	00000594 	muleq	r0, r4, r5
     3f0:	0ec20a01 	vdiveq.f32	s1, s4, s2
     3f4:	0a020000 	beq	803fc <__bss_end+0x773c0>
     3f8:	00000d71 	andeq	r0, r0, r1, ror sp
     3fc:	3f050003 	svccc	0x00050003
     400:	0400000d 	streq	r0, [r0], #-13
     404:	00380703 	eorseq	r0, r8, r3, lsl #14
     408:	c70b0000 	strgt	r0, [fp, -r0]
     40c:	0400000b 	streq	r0, [r0], #-11
     410:	00591405 	subseq	r1, r9, r5, lsl #8
     414:	03050000 	movweq	r0, #20480	; 0x5000
     418:	00008f48 	andeq	r8, r0, r8, asr #30
     41c:	000f8a0b 	andeq	r8, pc, fp, lsl #20
     420:	14060400 	strne	r0, [r6], #-1024	; 0xfffffc00
     424:	00000059 	andeq	r0, r0, r9, asr r0
     428:	8f4c0305 	svchi	0x004c0305
     42c:	3d0b0000 	stccc	0, cr0, [fp, #-0]
     430:	0500000a 	streq	r0, [r0, #-10]
     434:	00591a07 	subseq	r1, r9, r7, lsl #20
     438:	03050000 	movweq	r0, #20480	; 0x5000
     43c:	00008f50 	andeq	r8, r0, r0, asr pc
     440:	000d9a0b 	andeq	r9, sp, fp, lsl #20
     444:	1a090500 	bne	24184c <__bss_end+0x238810>
     448:	00000059 	andeq	r0, r0, r9, asr r0
     44c:	8f540305 	svchi	0x00540305
     450:	000b0000 	andeq	r0, fp, r0
     454:	0500000a 	streq	r0, [r0, #-10]
     458:	00591a0b 	subseq	r1, r9, fp, lsl #20
     45c:	03050000 	movweq	r0, #20480	; 0x5000
     460:	00008f58 	andeq	r8, r0, r8, asr pc
     464:	000d2c0b 	andeq	r2, sp, fp, lsl #24
     468:	1a0d0500 	bne	341870 <__bss_end+0x338834>
     46c:	00000059 	andeq	r0, r0, r9, asr r0
     470:	8f5c0305 	svchi	0x005c0305
     474:	a00b0000 	andge	r0, fp, r0
     478:	05000006 	streq	r0, [r0, #-6]
     47c:	00591a0f 	subseq	r1, r9, pc, lsl #20
     480:	03050000 	movweq	r0, #20480	; 0x5000
     484:	00008f60 	andeq	r8, r0, r0, ror #30
     488:	000c4609 	andeq	r4, ip, r9, lsl #12
     48c:	38040500 	stmdacc	r4, {r8, sl}
     490:	05000000 	streq	r0, [r0, #-0]
     494:	01e30c1b 	mvneq	r0, fp, lsl ip
     498:	430a0000 	movwmi	r0, #40960	; 0xa000
     49c:	00000006 	andeq	r0, r0, r6
     4a0:	0010b40a 	andseq	fp, r0, sl, lsl #8
     4a4:	410a0100 	mrsmi	r0, (UNDEF: 26)
     4a8:	02000012 	andeq	r0, r0, #18
     4ac:	041b0c00 	ldreq	r0, [fp], #-3072	; 0xfffff400
     4b0:	e30d0000 	movw	r0, #53248	; 0xd000
     4b4:	90000004 	andls	r0, r0, r4
     4b8:	56076305 	strpl	r6, [r7], -r5, lsl #6
     4bc:	07000003 	streq	r0, [r0, -r3]
     4c0:	0000061f 	andeq	r0, r0, pc, lsl r6
     4c4:	10670524 	rsbne	r0, r7, r4, lsr #10
     4c8:	00000270 	andeq	r0, r0, r0, ror r2
     4cc:	0020470e 	eoreq	r4, r0, lr, lsl #14
     4d0:	12690500 	rsbne	r0, r9, #0, 10
     4d4:	00000356 	andeq	r0, r0, r6, asr r3
     4d8:	08300e00 	ldmdaeq	r0!, {r9, sl, fp}
     4dc:	6b050000 	blvs	1404e4 <__bss_end+0x1374a8>
     4e0:	00036612 	andeq	r6, r3, r2, lsl r6
     4e4:	380e1000 	stmdacc	lr, {ip}
     4e8:	05000006 	streq	r0, [r0, #-6]
     4ec:	004d166d 	subeq	r1, sp, sp, ror #12
     4f0:	0e140000 	cdpeq	0, 1, cr0, cr4, cr0, {0}
     4f4:	00000d6a 	andeq	r0, r0, sl, ror #26
     4f8:	6d1c7005 	ldcvs	0, cr7, [ip, #-20]	; 0xffffffec
     4fc:	18000003 	stmdane	r0, {r0, r1}
     500:	0011fe0e 	andseq	pc, r1, lr, lsl #28
     504:	1c720500 	cfldr64ne	mvdx0, [r2], #-0
     508:	0000036d 	andeq	r0, r0, sp, ror #6
     50c:	04de0e1c 	ldrbeq	r0, [lr], #3612	; 0xe1c
     510:	75050000 	strvc	r0, [r5, #-0]
     514:	00036d1c 	andeq	r6, r3, ip, lsl sp
     518:	4b0f2000 	blmi	3c8520 <__bss_end+0x3bf4e4>
     51c:	0500000e 	streq	r0, [r0, #-14]
     520:	11511c77 	cmpne	r1, r7, ror ip
     524:	036d0000 	cmneq	sp, #0
     528:	02640000 	rsbeq	r0, r4, #0
     52c:	6d100000 	ldcvs	0, cr0, [r0, #-0]
     530:	11000003 	tstne	r0, r3
     534:	00000373 	andeq	r0, r0, r3, ror r3
     538:	36070000 	strcc	r0, [r7], -r0
     53c:	18000012 	stmdane	r0, {r1, r4}
     540:	a5107b05 	ldrge	r7, [r0, #-2821]	; 0xfffff4fb
     544:	0e000002 	cdpeq	0, 0, cr0, cr0, cr2, {0}
     548:	00002047 	andeq	r2, r0, r7, asr #32
     54c:	56127e05 	ldrpl	r7, [r2], -r5, lsl #28
     550:	00000003 	andeq	r0, r0, r3
     554:	0005400e 	andeq	r4, r5, lr
     558:	19800500 	stmibne	r0, {r8, sl}
     55c:	00000373 	andeq	r0, r0, r3, ror r3
     560:	09d90e10 	ldmibeq	r9, {r4, r9, sl, fp}^
     564:	82050000 	andhi	r0, r5, #0
     568:	00037e21 	andeq	r7, r3, r1, lsr #28
     56c:	03001400 	movweq	r1, #1024	; 0x400
     570:	00000270 	andeq	r0, r0, r0, ror r2
     574:	00049112 	andeq	r9, r4, r2, lsl r1
     578:	21860500 	orrcs	r0, r6, r0, lsl #10
     57c:	00000384 	andeq	r0, r0, r4, lsl #7
     580:	00085a12 	andeq	r5, r8, r2, lsl sl
     584:	1f880500 	svcne	0x00880500
     588:	00000059 	andeq	r0, r0, r9, asr r0
     58c:	000dac0e 	andeq	sl, sp, lr, lsl #24
     590:	178b0500 	strne	r0, [fp, r0, lsl #10]
     594:	000001f5 	strdeq	r0, [r0], -r5
     598:	07920e00 	ldreq	r0, [r2, r0, lsl #28]
     59c:	8e050000 	cdphi	0, 0, cr0, cr5, cr0, {0}
     5a0:	0001f517 	andeq	pc, r1, r7, lsl r5	; <UNPREDICTABLE>
     5a4:	4b0e2400 	blmi	3895ac <__bss_end+0x380570>
     5a8:	0500000b 	streq	r0, [r0, #-11]
     5ac:	01f5178f 	mvnseq	r1, pc, lsl #15
     5b0:	0e480000 	cdpeq	0, 4, cr0, cr8, cr0, {0}
     5b4:	0000095a 	andeq	r0, r0, sl, asr r9
     5b8:	f5179005 			; <UNDEFINED> instruction: 0xf5179005
     5bc:	6c000001 	stcvs	0, cr0, [r0], {1}
     5c0:	0004e313 	andeq	lr, r4, r3, lsl r3
     5c4:	09930500 	ldmibeq	r3, {r8, sl}
     5c8:	00000cef 	andeq	r0, r0, pc, ror #25
     5cc:	0000038f 	andeq	r0, r0, pc, lsl #7
     5d0:	00030f01 	andeq	r0, r3, r1, lsl #30
     5d4:	00031500 	andeq	r1, r3, r0, lsl #10
     5d8:	038f1000 	orreq	r1, pc, #0
     5dc:	14000000 	strne	r0, [r0], #-0
     5e0:	00000e40 	andeq	r0, r0, r0, asr #28
     5e4:	210e9605 	tstcs	lr, r5, lsl #12
     5e8:	01000005 	tsteq	r0, r5
     5ec:	0000032a 	andeq	r0, r0, sl, lsr #6
     5f0:	00000330 	andeq	r0, r0, r0, lsr r3
     5f4:	00038f10 	andeq	r8, r3, r0, lsl pc
     5f8:	2b150000 	blcs	540600 <__bss_end+0x5375c4>
     5fc:	05000008 	streq	r0, [r0, #-8]
     600:	0c2b1099 	stceq	0, cr1, [fp], #-612	; 0xfffffd9c
     604:	03950000 	orrseq	r0, r5, #0
     608:	45010000 	strmi	r0, [r1, #-0]
     60c:	10000003 	andne	r0, r0, r3
     610:	0000038f 	andeq	r0, r0, pc, lsl #7
     614:	00037311 	andeq	r7, r3, r1, lsl r3
     618:	01be1100 			; <UNDEFINED> instruction: 0x01be1100
     61c:	00000000 	andeq	r0, r0, r0
     620:	00002516 	andeq	r2, r0, r6, lsl r5
     624:	00036600 	andeq	r6, r3, r0, lsl #12
     628:	005e1700 	subseq	r1, lr, r0, lsl #14
     62c:	000f0000 	andeq	r0, pc, r0
     630:	e6020102 	str	r0, [r2], -r2, lsl #2
     634:	1800000a 	stmdane	r0, {r1, r3}
     638:	0001f504 	andeq	pc, r1, r4, lsl #10
     63c:	2c041800 	stccs	8, cr1, [r4], {-0}
     640:	0c000000 	stceq	0, cr0, [r0], {-0}
     644:	00001126 	andeq	r1, r0, r6, lsr #2
     648:	03790418 	cmneq	r9, #24, 8	; 0x18000000
     64c:	a5160000 	ldrge	r0, [r6, #-0]
     650:	8f000002 	svchi	0x00000002
     654:	19000003 	stmdbne	r0, {r0, r1}
     658:	e8041800 	stmda	r4, {fp, ip}
     65c:	18000001 	stmdane	r0, {r0}
     660:	0001e304 	andeq	lr, r1, r4, lsl #6
     664:	0e341a00 	vaddeq.f32	s2, s8, s0
     668:	9c050000 	stcls	0, cr0, [r5], {-0}
     66c:	0001e814 	andeq	lr, r1, r4, lsl r8
     670:	06590b00 	ldrbeq	r0, [r9], -r0, lsl #22
     674:	04060000 	streq	r0, [r6], #-0
     678:	00005914 	andeq	r5, r0, r4, lsl r9
     67c:	64030500 	strvs	r0, [r3], #-1280	; 0xfffffb00
     680:	0b00008f 	bleq	8c4 <shift+0x8c4>
     684:	00000ea4 	andeq	r0, r0, r4, lsr #29
     688:	59140706 	ldmdbpl	r4, {r1, r2, r8, r9, sl}
     68c:	05000000 	streq	r0, [r0, #-0]
     690:	008f6803 	addeq	r6, pc, r3, lsl #16
     694:	050e0b00 	streq	r0, [lr, #-2816]	; 0xfffff500
     698:	0a060000 	beq	1806a0 <__bss_end+0x177664>
     69c:	00005914 	andeq	r5, r0, r4, lsl r9
     6a0:	6c030500 	cfstr32vs	mvfx0, [r3], {-0}
     6a4:	0900008f 	stmdbeq	r0, {r0, r1, r2, r3, r7}
     6a8:	00000732 	andeq	r0, r0, r2, lsr r7
     6ac:	00380405 	eorseq	r0, r8, r5, lsl #8
     6b0:	0d060000 	stceq	0, cr0, [r6, #-0]
     6b4:	0004140c 	andeq	r1, r4, ip, lsl #8
     6b8:	654e1b00 	strbvs	r1, [lr, #-2816]	; 0xfffff500
     6bc:	0a000077 	beq	8a0 <shift+0x8a0>
     6c0:	000008f3 	strdeq	r0, [r0], -r3
     6c4:	05060a01 	streq	r0, [r6, #-2561]	; 0xfffff5ff
     6c8:	0a020000 	beq	806d0 <__bss_end+0x77694>
     6cc:	00000750 	andeq	r0, r0, r0, asr r7
     6d0:	103a0a03 	eorsne	r0, sl, r3, lsl #20
     6d4:	0a040000 	beq	1006dc <__bss_end+0xf76a0>
     6d8:	000004d7 	ldrdeq	r0, [r0], -r7
     6dc:	72070005 	andvc	r0, r7, #5
     6e0:	10000006 	andne	r0, r0, r6
     6e4:	53081b06 	movwpl	r1, #35590	; 0x8b06
     6e8:	08000004 	stmdaeq	r0, {r2}
     6ec:	0600726c 	streq	r7, [r0], -ip, ror #4
     6f0:	0453131d 	ldrbeq	r1, [r3], #-797	; 0xfffffce3
     6f4:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
     6f8:	06007073 			; <UNDEFINED> instruction: 0x06007073
     6fc:	0453131e 	ldrbeq	r1, [r3], #-798	; 0xfffffce2
     700:	08040000 	stmdaeq	r4, {}	; <UNPREDICTABLE>
     704:	06006370 			; <UNDEFINED> instruction: 0x06006370
     708:	0453131f 	ldrbeq	r1, [r3], #-799	; 0xfffffce1
     70c:	0e080000 	cdpeq	0, 0, cr0, cr8, cr0, {0}
     710:	00000e56 	andeq	r0, r0, r6, asr lr
     714:	53132006 	tstpl	r3, #6
     718:	0c000004 	stceq	0, cr0, [r0], {4}
     71c:	07040200 	streq	r0, [r4, -r0, lsl #4]
     720:	00001cd2 	ldrdeq	r1, [r0], -r2
     724:	00045303 	andeq	r5, r4, r3, lsl #6
     728:	08c70700 	stmiaeq	r7, {r8, r9, sl}^
     72c:	06700000 	ldrbteq	r0, [r0], -r0
     730:	04ef0828 	strbteq	r0, [pc], #2088	; 738 <shift+0x738>
     734:	da0e0000 	ble	38073c <__bss_end+0x377700>
     738:	06000007 	streq	r0, [r0], -r7
     73c:	0414122a 	ldreq	r1, [r4], #-554	; 0xfffffdd6
     740:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
     744:	00646970 	rsbeq	r6, r4, r0, ror r9
     748:	5e122b06 	vnmlspl.f64	d2, d2, d6
     74c:	10000000 	andne	r0, r0, r0
     750:	001a230e 	andseq	r2, sl, lr, lsl #6
     754:	112c0600 			; <UNDEFINED> instruction: 0x112c0600
     758:	000003dd 	ldrdeq	r0, [r0], -sp
     75c:	10130e14 	andsne	r0, r3, r4, lsl lr
     760:	2d060000 	stccs	0, cr0, [r6, #-0]
     764:	00005e12 	andeq	r5, r0, r2, lsl lr
     768:	ab0e1800 	blge	386770 <__bss_end+0x37d734>
     76c:	06000003 	streq	r0, [r0], -r3
     770:	005e122e 	subseq	r1, lr, lr, lsr #4
     774:	0e1c0000 	cdpeq	0, 1, cr0, cr12, cr0, {0}
     778:	00000e91 	muleq	r0, r1, lr
     77c:	ef0c2f06 	svc	0x000c2f06
     780:	20000004 	andcs	r0, r0, r4
     784:	0004870e 	andeq	r8, r4, lr, lsl #14
     788:	09300600 	ldmdbeq	r0!, {r9, sl}
     78c:	00000038 	andeq	r0, r0, r8, lsr r0
     790:	0aa50e60 	beq	fe944118 <__bss_end+0xfe93b0dc>
     794:	31060000 	mrscc	r0, (UNDEF: 6)
     798:	00004d0e 	andeq	r4, r0, lr, lsl #26
     79c:	d40e6400 	strle	r6, [lr], #-1024	; 0xfffffc00
     7a0:	0600000c 	streq	r0, [r0], -ip
     7a4:	004d0e33 	subeq	r0, sp, r3, lsr lr
     7a8:	0e680000 	cdpeq	0, 6, cr0, cr8, cr0, {0}
     7ac:	00000ccb 	andeq	r0, r0, fp, asr #25
     7b0:	4d0e3406 	cfstrsmi	mvf3, [lr, #-24]	; 0xffffffe8
     7b4:	6c000000 	stcvs	0, cr0, [r0], {-0}
     7b8:	03951600 	orrseq	r1, r5, #0, 12
     7bc:	04ff0000 	ldrbteq	r0, [pc], #0	; 7c4 <shift+0x7c4>
     7c0:	5e170000 	cdppl	0, 1, cr0, cr7, cr0, {0}
     7c4:	0f000000 	svceq	0x00000000
     7c8:	04f70b00 	ldrbteq	r0, [r7], #2816	; 0xb00
     7cc:	0a070000 	beq	1c07d4 <__bss_end+0x1b7798>
     7d0:	00005914 	andeq	r5, r0, r4, lsl r9
     7d4:	70030500 	andvc	r0, r3, r0, lsl #10
     7d8:	0900008f 	stmdbeq	r0, {r0, r1, r2, r3, r7}
     7dc:	00000a90 	muleq	r0, r0, sl
     7e0:	00380405 	eorseq	r0, r8, r5, lsl #8
     7e4:	0d070000 	stceq	0, cr0, [r7, #-0]
     7e8:	0005300c 	andeq	r3, r5, ip
     7ec:	124c0a00 	subne	r0, ip, #0, 20
     7f0:	0a000000 	beq	7f8 <shift+0x7f8>
     7f4:	000010e9 	andeq	r1, r0, r9, ror #1
     7f8:	bf070001 	svclt	0x00070001
     7fc:	0c000007 	stceq	0, cr0, [r0], {7}
     800:	65081b07 	strvs	r1, [r8, #-2823]	; 0xfffff4f9
     804:	0e000005 	cdpeq	0, 0, cr0, cr0, cr5, {0}
     808:	0000059f 	muleq	r0, pc, r5	; <UNPREDICTABLE>
     80c:	65191d07 	ldrvs	r1, [r9, #-3335]	; 0xfffff2f9
     810:	00000005 	andeq	r0, r0, r5
     814:	0004de0e 	andeq	sp, r4, lr, lsl #28
     818:	191e0700 	ldmdbne	lr, {r8, r9, sl}
     81c:	00000565 	andeq	r0, r0, r5, ror #10
     820:	0ac00e04 	beq	ff004038 <__bss_end+0xfeffaffc>
     824:	1f070000 	svcne	0x00070000
     828:	00056b13 	andeq	r6, r5, r3, lsl fp
     82c:	18000800 	stmdane	r0, {fp}
     830:	00053004 	andeq	r3, r5, r4
     834:	5f041800 	svcpl	0x00041800
     838:	0d000004 	stceq	0, cr0, [r0, #-16]
     83c:	00000dbb 			; <UNDEFINED> instruction: 0x00000dbb
     840:	07220714 			; <UNDEFINED> instruction: 0x07220714
     844:	000007f3 	strdeq	r0, [r0], -r3
     848:	000bd50e 	andeq	sp, fp, lr, lsl #10
     84c:	12260700 	eorne	r0, r6, #0, 14
     850:	0000004d 	andeq	r0, r0, sp, asr #32
     854:	0b680e00 	bleq	1a0405c <__bss_end+0x19fb020>
     858:	29070000 	stmdbcs	r7, {}	; <UNPREDICTABLE>
     85c:	0005651d 	andeq	r6, r5, sp, lsl r5
     860:	580e0400 	stmdapl	lr, {sl}
     864:	07000007 	streq	r0, [r0, -r7]
     868:	05651d2c 	strbeq	r1, [r5, #-3372]!	; 0xfffff2d4
     86c:	1c080000 	stcne	0, cr0, [r8], {-0}
     870:	00000c56 	andeq	r0, r0, r6, asr ip
     874:	9c0e2f07 	stcls	15, cr2, [lr], {7}
     878:	b9000007 	stmdblt	r0, {r0, r1, r2}
     87c:	c4000005 	strgt	r0, [r0], #-5
     880:	10000005 	andne	r0, r0, r5
     884:	000007f8 	strdeq	r0, [r0], -r8
     888:	00056511 	andeq	r6, r5, r1, lsl r5
     88c:	fc1d0000 	ldc2	0, cr0, [sp], {-0}
     890:	07000008 	streq	r0, [r0, -r8]
     894:	089e0e31 	ldmeq	lr, {r0, r4, r5, r9, sl, fp}
     898:	03660000 	cmneq	r6, #0
     89c:	05dc0000 	ldrbeq	r0, [ip]
     8a0:	05e70000 	strbeq	r0, [r7, #0]!
     8a4:	f8100000 			; <UNDEFINED> instruction: 0xf8100000
     8a8:	11000007 	tstne	r0, r7
     8ac:	0000056b 	andeq	r0, r0, fp, ror #10
     8b0:	10951300 	addsne	r1, r5, r0, lsl #6
     8b4:	35070000 	strcc	r0, [r7, #-0]
     8b8:	000a6b1d 	andeq	r6, sl, sp, lsl fp
     8bc:	00056500 	andeq	r6, r5, r0, lsl #10
     8c0:	06000200 	streq	r0, [r0], -r0, lsl #4
     8c4:	06060000 	streq	r0, [r6], -r0
     8c8:	f8100000 			; <UNDEFINED> instruction: 0xf8100000
     8cc:	00000007 	andeq	r0, r0, r7
     8d0:	00074313 	andeq	r4, r7, r3, lsl r3
     8d4:	1d370700 	ldcne	7, cr0, [r7, #-0]
     8d8:	00000c66 	andeq	r0, r0, r6, ror #24
     8dc:	00000565 	andeq	r0, r0, r5, ror #10
     8e0:	00061f02 	andeq	r1, r6, r2, lsl #30
     8e4:	00062500 	andeq	r2, r6, r0, lsl #10
     8e8:	07f81000 	ldrbeq	r1, [r8, r0]!
     8ec:	1e000000 	cdpne	0, 0, cr0, cr0, cr0, {0}
     8f0:	00000b7b 	andeq	r0, r0, fp, ror fp
     8f4:	11313907 	teqne	r1, r7, lsl #18
     8f8:	0c000008 	stceq	0, cr0, [r0], {8}
     8fc:	0dbb1302 	ldceq	3, cr1, [fp, #8]!
     900:	3c070000 	stccc	0, cr0, [r7], {-0}
     904:	00090b09 	andeq	r0, r9, r9, lsl #22
     908:	0007f800 	andeq	pc, r7, r0, lsl #16
     90c:	064c0100 	strbeq	r0, [ip], -r0, lsl #2
     910:	06520000 	ldrbeq	r0, [r2], -r0
     914:	f8100000 			; <UNDEFINED> instruction: 0xf8100000
     918:	00000007 	andeq	r0, r0, r7
     91c:	0007ec13 	andeq	lr, r7, r3, lsl ip
     920:	123f0700 	eorsne	r0, pc, #0, 14
     924:	00000569 	andeq	r0, r0, r9, ror #10
     928:	0000004d 	andeq	r0, r0, sp, asr #32
     92c:	00066b01 	andeq	r6, r6, r1, lsl #22
     930:	00068000 	andeq	r8, r6, r0
     934:	07f81000 	ldrbeq	r1, [r8, r0]!
     938:	1a110000 	bne	440940 <__bss_end+0x437904>
     93c:	11000008 	tstne	r0, r8
     940:	0000005e 	andeq	r0, r0, lr, asr r0
     944:	00036611 	andeq	r6, r3, r1, lsl r6
     948:	bf140000 	svclt	0x00140000
     94c:	07000010 	smladeq	r0, r0, r0, r0
     950:	067f0e42 	ldrbteq	r0, [pc], -r2, asr #28
     954:	95010000 	strls	r0, [r1, #-0]
     958:	9b000006 	blls	978 <shift+0x978>
     95c:	10000006 	andne	r0, r0, r6
     960:	000007f8 	strdeq	r0, [r0], -r8
     964:	054b1300 	strbeq	r1, [fp, #-768]	; 0xfffffd00
     968:	45070000 	strmi	r0, [r7, #-0]
     96c:	0005f117 	andeq	pc, r5, r7, lsl r1	; <UNPREDICTABLE>
     970:	00056b00 	andeq	r6, r5, r0, lsl #22
     974:	06b40100 	ldrteq	r0, [r4], r0, lsl #2
     978:	06ba0000 	ldrteq	r0, [sl], r0
     97c:	20100000 	andscs	r0, r0, r0
     980:	00000008 	andeq	r0, r0, r8
     984:	000eaf13 	andeq	sl, lr, r3, lsl pc
     988:	17480700 	strbne	r0, [r8, -r0, lsl #14]
     98c:	000003c1 	andeq	r0, r0, r1, asr #7
     990:	0000056b 	andeq	r0, r0, fp, ror #10
     994:	0006d301 	andeq	sp, r6, r1, lsl #6
     998:	0006de00 	andeq	sp, r6, r0, lsl #28
     99c:	08201000 	stmdaeq	r0!, {ip}
     9a0:	4d110000 	ldcmi	0, cr0, [r1, #-0]
     9a4:	00000000 	andeq	r0, r0, r0
     9a8:	0006aa14 	andeq	sl, r6, r4, lsl sl
     9ac:	0e4b0700 	cdpeq	7, 4, cr0, cr11, cr0, {0}
     9b0:	00000b89 	andeq	r0, r0, r9, lsl #23
     9b4:	0006f301 	andeq	pc, r6, r1, lsl #6
     9b8:	0006f900 	andeq	pc, r6, r0, lsl #18
     9bc:	07f81000 	ldrbeq	r1, [r8, r0]!
     9c0:	13000000 	movwne	r0, #0
     9c4:	000008fc 	strdeq	r0, [r0], -ip
     9c8:	040e4d07 	streq	r4, [lr], #-3335	; 0xfffff2f9
     9cc:	6600000d 	strvs	r0, [r0], -sp
     9d0:	01000003 	tsteq	r0, r3
     9d4:	00000712 	andeq	r0, r0, r2, lsl r7
     9d8:	0000071d 	andeq	r0, r0, sp, lsl r7
     9dc:	0007f810 	andeq	pc, r7, r0, lsl r8	; <UNPREDICTABLE>
     9e0:	004d1100 	subeq	r1, sp, r0, lsl #2
     9e4:	13000000 	movwne	r0, #0
     9e8:	000004c3 	andeq	r0, r0, r3, asr #9
     9ec:	ee125007 	cdp	0, 1, cr5, cr2, cr7, {0}
     9f0:	4d000003 	stcmi	0, cr0, [r0, #-12]
     9f4:	01000000 	mrseq	r0, (UNDEF: 0)
     9f8:	00000736 	andeq	r0, r0, r6, lsr r7
     9fc:	00000741 	andeq	r0, r0, r1, asr #14
     a00:	0007f810 	andeq	pc, r7, r0, lsl r8	; <UNPREDICTABLE>
     a04:	03951100 	orrseq	r1, r5, #0, 2
     a08:	13000000 	movwne	r0, #0
     a0c:	00000421 	andeq	r0, r0, r1, lsr #8
     a10:	f40e5307 	vst2.8	{d5-d8}, [lr], r7
     a14:	66000010 			; <UNDEFINED> instruction: 0x66000010
     a18:	01000003 	tsteq	r0, r3
     a1c:	0000075a 	andeq	r0, r0, sl, asr r7
     a20:	00000765 	andeq	r0, r0, r5, ror #14
     a24:	0007f810 	andeq	pc, r7, r0, lsl r8	; <UNPREDICTABLE>
     a28:	004d1100 	subeq	r1, sp, r0, lsl #2
     a2c:	14000000 	strne	r0, [r0], #-0
     a30:	0000049d 	muleq	r0, sp, r4
     a34:	960e5607 	strls	r5, [lr], -r7, lsl #12
     a38:	0100000f 	tsteq	r0, pc
     a3c:	0000077a 	andeq	r0, r0, sl, ror r7
     a40:	00000799 	muleq	r0, r9, r7
     a44:	0007f810 	andeq	pc, r7, r0, lsl r8	; <UNPREDICTABLE>
     a48:	00951100 	addseq	r1, r5, r0, lsl #2
     a4c:	4d110000 	ldcmi	0, cr0, [r1, #-0]
     a50:	11000000 	mrsne	r0, (UNDEF: 0)
     a54:	0000004d 	andeq	r0, r0, sp, asr #32
     a58:	00004d11 	andeq	r4, r0, r1, lsl sp
     a5c:	08261100 	stmdaeq	r6!, {r8, ip}
     a60:	14000000 	strne	r0, [r0], #-0
     a64:	00001181 	andeq	r1, r0, r1, lsl #3
     a68:	730e5807 	movwvc	r5, #59399	; 0xe807
     a6c:	01000012 	tsteq	r0, r2, lsl r0
     a70:	000007ae 	andeq	r0, r0, lr, lsr #15
     a74:	000007cd 	andeq	r0, r0, sp, asr #15
     a78:	0007f810 	andeq	pc, r7, r0, lsl r8	; <UNPREDICTABLE>
     a7c:	00cc1100 	sbceq	r1, ip, r0, lsl #2
     a80:	4d110000 	ldcmi	0, cr0, [r1, #-0]
     a84:	11000000 	mrsne	r0, (UNDEF: 0)
     a88:	0000004d 	andeq	r0, r0, sp, asr #32
     a8c:	00004d11 	andeq	r4, r0, r1, lsl sp
     a90:	08261100 	stmdaeq	r6!, {r8, ip}
     a94:	15000000 	strne	r0, [r0, #-0]
     a98:	000004b0 			; <UNDEFINED> instruction: 0x000004b0
     a9c:	eb0e5b07 	bl	3976c0 <__bss_end+0x38e684>
     aa0:	6600000a 	strvs	r0, [r0], -sl
     aa4:	01000003 	tsteq	r0, r3
     aa8:	000007e2 	andeq	r0, r0, r2, ror #15
     aac:	0007f810 	andeq	pc, r7, r0, lsl r8	; <UNPREDICTABLE>
     ab0:	05111100 	ldreq	r1, [r1, #-256]	; 0xffffff00
     ab4:	2c110000 	ldccs	0, cr0, [r1], {-0}
     ab8:	00000008 	andeq	r0, r0, r8
     abc:	05710300 	ldrbeq	r0, [r1, #-768]!	; 0xfffffd00
     ac0:	04180000 	ldreq	r0, [r8], #-0
     ac4:	00000571 	andeq	r0, r0, r1, ror r5
     ac8:	0005651f 	andeq	r6, r5, pc, lsl r5
     acc:	00080b00 	andeq	r0, r8, r0, lsl #22
     ad0:	00081100 	andeq	r1, r8, r0, lsl #2
     ad4:	07f81000 	ldrbeq	r1, [r8, r0]!
     ad8:	20000000 	andcs	r0, r0, r0
     adc:	00000571 	andeq	r0, r0, r1, ror r5
     ae0:	000007fe 	strdeq	r0, [r0], -lr
     ae4:	003f0418 	eorseq	r0, pc, r8, lsl r4	; <UNPREDICTABLE>
     ae8:	04180000 	ldreq	r0, [r8], #-0
     aec:	000007f3 	strdeq	r0, [r0], -r3
     af0:	006f0421 	rsbeq	r0, pc, r1, lsr #8
     af4:	04220000 	strteq	r0, [r2], #-0
     af8:	0011de1a 	andseq	sp, r1, sl, lsl lr
     afc:	195e0700 	ldmdbne	lr, {r8, r9, sl}^
     b00:	00000571 	andeq	r0, r0, r1, ror r5
     b04:	6c616823 	stclvs	8, cr6, [r1], #-140	; 0xffffff74
     b08:	0b050800 	bleq	142b10 <__bss_end+0x139ad4>
     b0c:	000008f4 	strdeq	r0, [r0], -r4
     b10:	000b3824 	andeq	r3, fp, r4, lsr #16
     b14:	19070800 	stmdbne	r7, {fp}
     b18:	00000065 	andeq	r0, r0, r5, rrx
     b1c:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}
     b20:	000ed924 	andeq	sp, lr, r4, lsr #18
     b24:	1a0a0800 	bne	282b2c <__bss_end+0x279af0>
     b28:	0000045a 	andeq	r0, r0, sl, asr r4
     b2c:	20000000 	andcs	r0, r0, r0
     b30:	00055f24 	andeq	r5, r5, r4, lsr #30
     b34:	1a0d0800 	bne	342b3c <__bss_end+0x339b00>
     b38:	0000045a 	andeq	r0, r0, sl, asr r4
     b3c:	20200000 	eorcs	r0, r0, r0
     b40:	000ab125 	andeq	fp, sl, r5, lsr #2
     b44:	15100800 	ldrne	r0, [r0, #-2048]	; 0xfffff800
     b48:	00000059 	andeq	r0, r0, r9, asr r0
     b4c:	10a12436 	adcne	r2, r1, r6, lsr r4
     b50:	42080000 	andmi	r0, r8, #0
     b54:	00045a1a 	andeq	r5, r4, sl, lsl sl
     b58:	21500000 	cmpcs	r0, r0
     b5c:	121c2420 	andsne	r2, ip, #32, 8	; 0x20000000
     b60:	71080000 	mrsvc	r0, (UNDEF: 8)
     b64:	00045a1a 	andeq	r5, r4, sl, lsl sl
     b68:	00b20000 	adcseq	r0, r2, r0
     b6c:	084f2420 	stmdaeq	pc, {r5, sl, sp}^	; <UNPREDICTABLE>
     b70:	a4080000 	strge	r0, [r8], #-0
     b74:	00045a1a 	andeq	r5, r4, sl, lsl sl
     b78:	00b40000 	adcseq	r0, r4, r0
     b7c:	0b2e2420 	bleq	b89c04 <__bss_end+0xb80bc8>
     b80:	b3080000 	movwlt	r0, #32768	; 0x8000
     b84:	00045a1a 	andeq	r5, r4, sl, lsl sl
     b88:	10400000 	subne	r0, r0, r0
     b8c:	0c9f2420 	cfldrseq	mvf2, [pc], {32}
     b90:	be080000 	cdplt	0, 0, cr0, cr8, cr0, {0}
     b94:	00045a1a 	andeq	r5, r4, sl, lsl sl
     b98:	20500000 	subscs	r0, r0, r0
     b9c:	07232420 	streq	r2, [r3, -r0, lsr #8]!
     ba0:	bf080000 	svclt	0x00080000
     ba4:	00045a1a 	andeq	r5, r4, sl, lsl sl
     ba8:	80400000 	subhi	r0, r0, r0
     bac:	10aa2420 	adcne	r2, sl, r0, lsr #8
     bb0:	c0080000 	andgt	r0, r8, r0
     bb4:	00045a1a 	andeq	r5, r4, sl, lsl sl
     bb8:	80500000 	subshi	r0, r0, r0
     bbc:	46260020 	strtmi	r0, [r6], -r0, lsr #32
     bc0:	26000008 	strcs	r0, [r0], -r8
     bc4:	00000856 	andeq	r0, r0, r6, asr r8
     bc8:	00086626 	andeq	r6, r8, r6, lsr #12
     bcc:	08762600 	ldmdaeq	r6!, {r9, sl, sp}^
     bd0:	83260000 			; <UNDEFINED> instruction: 0x83260000
     bd4:	26000008 	strcs	r0, [r0], -r8
     bd8:	00000893 	muleq	r0, r3, r8
     bdc:	0008a326 	andeq	sl, r8, r6, lsr #6
     be0:	08b32600 	ldmeq	r3!, {r9, sl, sp}
     be4:	c3260000 			; <UNDEFINED> instruction: 0xc3260000
     be8:	26000008 	strcs	r0, [r0], -r8
     bec:	000008d3 	ldrdeq	r0, [r0], -r3
     bf0:	0008e326 	andeq	lr, r8, r6, lsr #6
     bf4:	0f260b00 	svceq	0x00260b00
     bf8:	08090000 	stmdaeq	r9, {}	; <UNPREDICTABLE>
     bfc:	00005914 	andeq	r5, r0, r4, lsl r9
     c00:	a0030500 	andge	r0, r3, r0, lsl #10
     c04:	0900008f 	stmdbeq	r0, {r0, r1, r2, r3, r7}
     c08:	00000c08 	andeq	r0, r0, r8, lsl #24
     c0c:	005e0407 	subseq	r0, lr, r7, lsl #8
     c10:	0b090000 	bleq	240c18 <__bss_end+0x237bdc>
     c14:	0009860c 	andeq	r8, r9, ip, lsl #12
     c18:	0c1b0a00 			; <UNDEFINED> instruction: 0x0c1b0a00
     c1c:	0a000000 	beq	c24 <shift+0xc24>
     c20:	00000631 	andeq	r0, r0, r1, lsr r6
     c24:	114b0a01 	cmpne	fp, r1, lsl #20
     c28:	0a020000 	beq	80c30 <__bss_end+0x77bf4>
     c2c:	00001145 	andeq	r1, r0, r5, asr #2
     c30:	11200a03 			; <UNDEFINED> instruction: 0x11200a03
     c34:	0a040000 	beq	100c3c <__bss_end+0xf7c00>
     c38:	000011f8 	strdeq	r1, [r0], -r8
     c3c:	11390a05 	teqne	r9, r5, lsl #20
     c40:	0a060000 	beq	180c48 <__bss_end+0x177c0c>
     c44:	0000113f 	andeq	r1, r0, pc, lsr r1
     c48:	0dcc0a07 	vstreq	s1, [ip, #28]
     c4c:	00080000 	andeq	r0, r8, r0
     c50:	0009bd09 	andeq	fp, r9, r9, lsl #26
     c54:	38040500 	stmdacc	r4, {r8, sl}
     c58:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     c5c:	09b10c1d 	ldmibeq	r1!, {r0, r2, r3, r4, sl, fp}
     c60:	a90a0000 	stmdbge	sl, {}	; <UNPREDICTABLE>
     c64:	0000000c 	andeq	r0, r0, ip
     c68:	000ce20a 	andeq	lr, ip, sl, lsl #4
     c6c:	c60a0100 	strgt	r0, [sl], -r0, lsl #2
     c70:	0200000c 	andeq	r0, r0, #12
     c74:	776f4c1b 			; <UNDEFINED> instruction: 0x776f4c1b
     c78:	0d000300 	stceq	3, cr0, [r0, #-0]
     c7c:	000011ea 	andeq	r1, r0, sl, ror #3
     c80:	0728091c 			; <UNDEFINED> instruction: 0x0728091c
     c84:	00000d32 	andeq	r0, r0, r2, lsr sp
     c88:	00039d07 	andeq	r9, r3, r7, lsl #26
     c8c:	33091000 	movwcc	r1, #36864	; 0x9000
     c90:	000a000a 	andeq	r0, sl, sl
     c94:	073e0e00 	ldreq	r0, [lr, -r0, lsl #28]!
     c98:	35090000 	strcc	r0, [r9, #-0]
     c9c:	0003950b 	andeq	r9, r3, fp, lsl #10
     ca0:	d20e0000 	andle	r0, lr, #0
     ca4:	09000007 	stmdbeq	r0, {r0, r1, r2}
     ca8:	004d0d36 	subeq	r0, sp, r6, lsr sp
     cac:	0e040000 	cdpeq	0, 0, cr0, cr4, cr0, {0}
     cb0:	0000059f 	muleq	r0, pc, r5	; <UNPREDICTABLE>
     cb4:	37133709 	ldrcc	r3, [r3, -r9, lsl #14]
     cb8:	0800000d 	stmdaeq	r0, {r0, r2, r3}
     cbc:	0004de0e 	andeq	sp, r4, lr, lsl #28
     cc0:	13380900 	teqne	r8, #0, 18
     cc4:	00000d37 	andeq	r0, r0, r7, lsr sp
     cc8:	e60e000c 	str	r0, [lr], -ip
     ccc:	09000007 	stmdbeq	r0, {r0, r1, r2}
     cd0:	0d43202c 	stcleq	0, cr2, [r3, #-176]	; 0xffffff50
     cd4:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     cd8:	00000f73 	andeq	r0, r0, r3, ror pc
     cdc:	480c2f09 	stmdami	ip, {r0, r3, r8, r9, sl, fp, sp}
     ce0:	0400000d 	streq	r0, [r0], #-13
     ce4:	000a530e 	andeq	r5, sl, lr, lsl #6
     ce8:	0c310900 			; <UNDEFINED> instruction: 0x0c310900
     cec:	00000d48 	andeq	r0, r0, r8, asr #26
     cf0:	0bb80e0c 	bleq	fee04528 <__bss_end+0xfedfb4ec>
     cf4:	3b090000 	blcc	240cfc <__bss_end+0x237cc0>
     cf8:	000d3712 	andeq	r3, sp, r2, lsl r7
     cfc:	540e1400 	strpl	r1, [lr], #-1024	; 0xfffffc00
     d00:	09000009 	stmdbeq	r0, {r0, r3}
     d04:	01340e3d 	teqeq	r4, sp, lsr lr
     d08:	13180000 	tstne	r8, #0
     d0c:	00000ee9 	andeq	r0, r0, r9, ror #29
     d10:	fb084109 	blx	21113e <__bss_end+0x208102>
     d14:	66000007 	strvs	r0, [r0], -r7
     d18:	02000003 	andeq	r0, r0, #3
     d1c:	00000a5a 	andeq	r0, r0, sl, asr sl
     d20:	00000a6f 	andeq	r0, r0, pc, ror #20
     d24:	000d5810 	andeq	r5, sp, r0, lsl r8
     d28:	004d1100 	subeq	r1, sp, r0, lsl #2
     d2c:	5e110000 	cdppl	0, 1, cr0, cr1, cr0, {0}
     d30:	1100000d 	tstne	r0, sp
     d34:	00000d5e 	andeq	r0, r0, lr, asr sp
     d38:	083c1300 	ldmdaeq	ip!, {r8, r9, ip}
     d3c:	43090000 	movwmi	r0, #36864	; 0x9000
     d40:	00119708 	andseq	r9, r1, r8, lsl #14
     d44:	00036600 	andeq	r6, r3, r0, lsl #12
     d48:	0a880200 	beq	fe201550 <__bss_end+0xfe1f8514>
     d4c:	0a9d0000 	beq	fe740d54 <__bss_end+0xfe737d18>
     d50:	58100000 	ldmdapl	r0, {}	; <UNPREDICTABLE>
     d54:	1100000d 	tstne	r0, sp
     d58:	0000004d 	andeq	r0, r0, sp, asr #32
     d5c:	000d5e11 	andeq	r5, sp, r1, lsl lr
     d60:	0d5e1100 	ldfeqe	f1, [lr, #-0]
     d64:	13000000 	movwne	r0, #0
     d68:	00000b55 	andeq	r0, r0, r5, asr fp
     d6c:	25084509 	strcs	r4, [r8, #-1289]	; 0xfffffaf7
     d70:	66000009 	strvs	r0, [r0], -r9
     d74:	02000003 	andeq	r0, r0, #3
     d78:	00000ab6 			; <UNDEFINED> instruction: 0x00000ab6
     d7c:	00000acb 	andeq	r0, r0, fp, asr #21
     d80:	000d5810 	andeq	r5, sp, r0, lsl r8
     d84:	004d1100 	subeq	r1, sp, r0, lsl #2
     d88:	5e110000 	cdppl	0, 1, cr0, cr1, cr0, {0}
     d8c:	1100000d 	tstne	r0, sp
     d90:	00000d5e 	andeq	r0, r0, lr, asr sp
     d94:	0c8c1300 	stceq	3, cr1, [ip], {0}
     d98:	47090000 	strmi	r0, [r9, -r0]
     d9c:	00043408 	andeq	r3, r4, r8, lsl #8
     da0:	00036600 	andeq	r6, r3, r0, lsl #12
     da4:	0ae40200 	beq	ff9015ac <__bss_end+0xff8f8570>
     da8:	0af90000 	beq	ffe40db0 <__bss_end+0xffe37d74>
     dac:	58100000 	ldmdapl	r0, {}	; <UNPREDICTABLE>
     db0:	1100000d 	tstne	r0, sp
     db4:	0000004d 	andeq	r0, r0, sp, asr #32
     db8:	000d5e11 	andeq	r5, sp, r1, lsl lr
     dbc:	0d5e1100 	ldfeqe	f1, [lr, #-0]
     dc0:	13000000 	movwne	r0, #0
     dc4:	00000872 	andeq	r0, r0, r2, ror r8
     dc8:	0e084909 	vmlaeq.f16	s8, s16, s18	; <UNPREDICTABLE>
     dcc:	6600000a 	strvs	r0, [r0], -sl
     dd0:	02000003 	andeq	r0, r0, #3
     dd4:	00000b12 	andeq	r0, r0, r2, lsl fp
     dd8:	00000b27 	andeq	r0, r0, r7, lsr #22
     ddc:	000d5810 	andeq	r5, sp, r0, lsl r8
     de0:	004d1100 	subeq	r1, sp, r0, lsl #2
     de4:	5e110000 	cdppl	0, 1, cr0, cr1, cr0, {0}
     de8:	1100000d 	tstne	r0, sp
     dec:	00000d5e 	andeq	r0, r0, lr, asr sp
     df0:	104e1300 	subne	r1, lr, r0, lsl #6
     df4:	4b090000 	blmi	240dfc <__bss_end+0x237dc0>
     df8:	0005a408 	andeq	sl, r5, r8, lsl #8
     dfc:	00036600 	andeq	r6, r3, r0, lsl #12
     e00:	0b400200 	bleq	1001608 <__bss_end+0xff85cc>
     e04:	0b5a0000 	bleq	1680e0c <__bss_end+0x1677dd0>
     e08:	58100000 	ldmdapl	r0, {}	; <UNPREDICTABLE>
     e0c:	1100000d 	tstne	r0, sp
     e10:	0000004d 	andeq	r0, r0, sp, asr #32
     e14:	00098611 	andeq	r8, r9, r1, lsl r6
     e18:	0d5e1100 	ldfeqe	f1, [lr, #-0]
     e1c:	5e110000 	cdppl	0, 1, cr0, cr1, cr0, {0}
     e20:	0000000d 	andeq	r0, r0, sp
     e24:	000d4a13 	andeq	r4, sp, r3, lsl sl
     e28:	0c4f0900 	mcrreq	9, 0, r0, pc, cr0	; <UNPREDICTABLE>
     e2c:	00000964 	andeq	r0, r0, r4, ror #18
     e30:	0000004d 	andeq	r0, r0, sp, asr #32
     e34:	000b7302 	andeq	r7, fp, r2, lsl #6
     e38:	000b7900 	andeq	r7, fp, r0, lsl #18
     e3c:	0d581000 	ldcleq	0, cr1, [r8, #-0]
     e40:	14000000 	strne	r0, [r0], #-0
     e44:	000009e0 	andeq	r0, r0, r0, ror #19
     e48:	e8085109 	stmda	r8, {r0, r3, r8, ip, lr}
     e4c:	0200000f 	andeq	r0, r0, #15
     e50:	00000b8e 	andeq	r0, r0, lr, lsl #23
     e54:	00000b99 	muleq	r0, r9, fp
     e58:	000d6410 	andeq	r6, sp, r0, lsl r4
     e5c:	004d1100 	subeq	r1, sp, r0, lsl #2
     e60:	13000000 	movwne	r0, #0
     e64:	000011ea 	andeq	r1, r0, sl, ror #3
     e68:	6b035409 	blvs	d5e94 <__bss_end+0xcce58>
     e6c:	64000007 	strvs	r0, [r0], #-7
     e70:	0100000d 	tsteq	r0, sp
     e74:	00000bb2 			; <UNDEFINED> instruction: 0x00000bb2
     e78:	00000bbd 			; <UNDEFINED> instruction: 0x00000bbd
     e7c:	000d6410 	andeq	r6, sp, r0, lsl r4
     e80:	005e1100 	subseq	r1, lr, r0, lsl #2
     e84:	14000000 	strne	r0, [r0], #-0
     e88:	0000088c 	andeq	r0, r0, ip, lsl #17
     e8c:	df085709 	svcle	0x00085709
     e90:	0100000b 	tsteq	r0, fp
     e94:	00000bd2 	ldrdeq	r0, [r0], -r2
     e98:	00000be2 	andeq	r0, r0, r2, ror #23
     e9c:	000d6410 	andeq	r6, sp, r0, lsl r4
     ea0:	004d1100 	subeq	r1, sp, r0, lsl #2
     ea4:	3d110000 	ldccc	0, cr0, [r1, #-0]
     ea8:	00000009 	andeq	r0, r0, r9
     eac:	000ad413 	andeq	sp, sl, r3, lsl r4
     eb0:	12590900 	subsne	r0, r9, #0, 18
     eb4:	00000efd 	strdeq	r0, [r0], -sp
     eb8:	0000093d 	andeq	r0, r0, sp, lsr r9
     ebc:	000bfb01 	andeq	pc, fp, r1, lsl #22
     ec0:	000c0600 	andeq	r0, ip, r0, lsl #12
     ec4:	0d581000 	ldcleq	0, cr1, [r8, #-0]
     ec8:	4d110000 	ldcmi	0, cr0, [r1, #-0]
     ecc:	00000000 	andeq	r0, r0, r0
     ed0:	00062d14 	andeq	r2, r6, r4, lsl sp
     ed4:	085c0900 	ldmdaeq	ip, {r8, fp}^
     ed8:	000006f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     edc:	000c1b01 	andeq	r1, ip, r1, lsl #22
     ee0:	000c2b00 	andeq	r2, ip, r0, lsl #22
     ee4:	0d641000 	stcleq	0, cr1, [r4, #-0]
     ee8:	4d110000 	ldcmi	0, cr0, [r1, #-0]
     eec:	11000000 	mrsne	r0, (UNDEF: 0)
     ef0:	00000366 	andeq	r0, r0, r6, ror #6
     ef4:	0c171300 	ldceq	3, cr1, [r7], {-0}
     ef8:	5f090000 	svcpl	0x00090000
     efc:	0006d108 	andeq	sp, r6, r8, lsl #2
     f00:	00036600 	andeq	r6, r3, r0, lsl #12
     f04:	0c440100 	stfeqe	f0, [r4], {-0}
     f08:	0c4f0000 	mareq	acc0, r0, pc
     f0c:	64100000 	ldrvs	r0, [r0], #-0
     f10:	1100000d 	tstne	r0, sp
     f14:	0000004d 	andeq	r0, r0, sp, asr #32
     f18:	0cba1300 	ldceq	3, cr1, [sl]
     f1c:	62090000 	andvs	r0, r9, #0
     f20:	00046308 	andeq	r6, r4, r8, lsl #6
     f24:	00036600 	andeq	r6, r3, r0, lsl #12
     f28:	0c680100 	stfeqe	f0, [r8], #-0
     f2c:	0c7d0000 	ldcleq	0, cr0, [sp], #-0
     f30:	64100000 	ldrvs	r0, [r0], #-0
     f34:	1100000d 	tstne	r0, sp
     f38:	0000004d 	andeq	r0, r0, sp, asr #32
     f3c:	00036611 	andeq	r6, r3, r1, lsl r6
     f40:	03661100 	cmneq	r6, #0, 2
     f44:	13000000 	movwne	r0, #0
     f48:	00000db2 			; <UNDEFINED> instruction: 0x00000db2
     f4c:	14086409 	strne	r6, [r8], #-1033	; 0xfffffbf7
     f50:	6600000e 	strvs	r0, [r0], -lr
     f54:	01000003 	tsteq	r0, r3
     f58:	00000c96 	muleq	r0, r6, ip
     f5c:	00000cab 	andeq	r0, r0, fp, lsr #25
     f60:	000d6410 	andeq	r6, sp, r0, lsl r4
     f64:	004d1100 	subeq	r1, sp, r0, lsl #2
     f68:	66110000 	ldrvs	r0, [r1], -r0
     f6c:	11000003 	tstne	r0, r3
     f70:	00000366 	andeq	r0, r0, r6, ror #6
     f74:	12cb1400 	sbcne	r1, fp, #0, 8
     f78:	67090000 	strvs	r0, [r9, -r0]
     f7c:	00099208 	andeq	r9, r9, r8, lsl #4
     f80:	0cc00100 	stfeqe	f0, [r0], {0}
     f84:	0cd00000 	ldcleq	0, cr0, [r0], {0}
     f88:	64100000 	ldrvs	r0, [r0], #-0
     f8c:	1100000d 	tstne	r0, sp
     f90:	0000004d 	andeq	r0, r0, sp, asr #32
     f94:	00098611 	andeq	r8, r9, r1, lsl r6
     f98:	07140000 	ldreq	r0, [r4, -r0]
     f9c:	09000012 	stmdbeq	r0, {r1, r4}
     fa0:	0f320869 	svceq	0x00320869
     fa4:	e5010000 	str	r0, [r1, #-0]
     fa8:	f500000c 			; <UNDEFINED> instruction: 0xf500000c
     fac:	1000000c 	andne	r0, r0, ip
     fb0:	00000d64 	andeq	r0, r0, r4, ror #26
     fb4:	00004d11 	andeq	r4, r0, r1, lsl sp
     fb8:	09861100 	stmibeq	r6, {r8, ip}
     fbc:	14000000 	strne	r0, [r0], #-0
     fc0:	000009f5 	strdeq	r0, [r0], -r5
     fc4:	c8086c09 	stmdagt	r8, {r0, r3, sl, fp, sp, lr}
     fc8:	01000010 	tsteq	r0, r0, lsl r0
     fcc:	00000d0a 	andeq	r0, r0, sl, lsl #26
     fd0:	00000d10 	andeq	r0, r0, r0, lsl sp
     fd4:	000d6410 	andeq	r6, sp, r0, lsl r4
     fd8:	c5270000 	strgt	r0, [r7, #-0]!
     fdc:	0900000a 	stmdbeq	r0, {r1, r3}
     fe0:	1069086f 	rsbne	r0, r9, pc, ror #16
     fe4:	21010000 	mrscs	r0, (UNDEF: 1)
     fe8:	1000000d 	andne	r0, r0, sp
     fec:	00000d64 	andeq	r0, r0, r4, ror #26
     ff0:	00039511 	andeq	r9, r3, r1, lsl r5
     ff4:	004d1100 	subeq	r1, sp, r0, lsl #2
     ff8:	00000000 	andeq	r0, r0, r0
     ffc:	0009b103 	andeq	fp, r9, r3, lsl #2
    1000:	be041800 	cdplt	8, 0, cr1, cr4, cr0, {0}
    1004:	18000009 	stmdane	r0, {r0, r3}
    1008:	00006a04 	andeq	r6, r0, r4, lsl #20
    100c:	0d3d0300 	ldceq	3, cr0, [sp, #-0]
    1010:	4d160000 	ldcmi	0, cr0, [r6, #-0]
    1014:	58000000 	stmdapl	r0, {}	; <UNPREDICTABLE>
    1018:	1700000d 	strne	r0, [r0, -sp]
    101c:	0000005e 	andeq	r0, r0, lr, asr r0
    1020:	04180001 	ldreq	r0, [r8], #-1
    1024:	00000d32 	andeq	r0, r0, r2, lsr sp
    1028:	004d0421 	subeq	r0, sp, r1, lsr #8
    102c:	04180000 	ldreq	r0, [r8], #-0
    1030:	000009b1 			; <UNDEFINED> instruction: 0x000009b1
    1034:	00086c1a 	andeq	r6, r8, sl, lsl ip
    1038:	16730900 	ldrbtne	r0, [r3], -r0, lsl #18
    103c:	000009b1 			; <UNDEFINED> instruction: 0x000009b1
    1040:	0012610b 	andseq	r6, r2, fp, lsl #2
    1044:	14100100 	ldrne	r0, [r0], #-256	; 0xffffff00
    1048:	00000059 	andeq	r0, r0, r9, asr r0
    104c:	8fa40305 	svchi	0x00a40305
    1050:	820b0000 	andhi	r0, fp, #0
    1054:	01000007 	tsteq	r0, r7
    1058:	00591411 	subseq	r1, r9, r1, lsl r4
    105c:	03050000 	movweq	r0, #20480	; 0x5000
    1060:	00008fa8 	andeq	r8, r0, r8, lsr #31
    1064:	0004ef28 	andeq	lr, r4, r8, lsr #30
    1068:	0a130100 	beq	4c1470 <__bss_end+0x4b8434>
    106c:	0000004d 	andeq	r0, r0, sp, asr #32
    1070:	90240305 	eorls	r0, r4, r5, lsl #6
    1074:	85280000 	strhi	r0, [r8, #-0]!
    1078:	01000008 	tsteq	r0, r8
    107c:	004d0a14 	subeq	r0, sp, r4, lsl sl
    1080:	03050000 	movweq	r0, #20480	; 0x5000
    1084:	00009028 	andeq	r9, r0, r8, lsr #32
    1088:	0011d929 	andseq	sp, r1, r9, lsr #18
    108c:	051d0100 	ldreq	r0, [sp, #-256]	; 0xffffff00
    1090:	00000038 	andeq	r0, r0, r8, lsr r0
    1094:	000082b8 			; <UNDEFINED> instruction: 0x000082b8
    1098:	0000016c 	andeq	r0, r0, ip, ror #2
    109c:	0e159c01 	cdpeq	12, 1, cr9, cr5, cr1, {0}
    10a0:	b52a0000 	strlt	r0, [sl, #-0]!
    10a4:	0100000c 	tsteq	r0, ip
    10a8:	00380e1d 	eorseq	r0, r8, sp, lsl lr
    10ac:	91020000 	mrsls	r0, (UNDEF: 2)
    10b0:	0cdd2a6c 	vldmiaeq	sp, {s5-s112}
    10b4:	1d010000 	stcne	0, cr0, [r1, #-0]
    10b8:	000e151b 	andeq	r1, lr, fp, lsl r5
    10bc:	68910200 	ldmvs	r1, {r9}
    10c0:	000d932b 	andeq	r9, sp, fp, lsr #6
    10c4:	17220100 	strne	r0, [r2, -r0, lsl #2]!
    10c8:	00000986 	andeq	r0, r0, r6, lsl #19
    10cc:	2b709102 	blcs	1c254dc <__bss_end+0x1c1c4a0>
    10d0:	00000e74 	andeq	r0, r0, r4, ror lr
    10d4:	4d0b2501 	cfstr32mi	mvfx2, [fp, #-4]
    10d8:	02000000 	andeq	r0, r0, #0
    10dc:	18007491 	stmdane	r0, {r0, r4, r7, sl, ip, sp, lr}
    10e0:	000e1b04 	andeq	r1, lr, r4, lsl #22
    10e4:	25041800 	strcs	r1, [r4, #-2048]	; 0xfffff800
    10e8:	2c000000 	stccs	0, cr0, [r0], {-0}
    10ec:	00000653 	andeq	r0, r0, r3, asr r6
    10f0:	21061601 	tstcs	r6, r1, lsl #12
    10f4:	3800000c 	stmdacc	r0, {r2, r3}
    10f8:	80000082 	andhi	r0, r0, r2, lsl #1
    10fc:	01000000 	mrseq	r0, (UNDEF: 0)
    1100:	064d2a9c 			; <UNDEFINED> instruction: 0x064d2a9c
    1104:	16010000 	strne	r0, [r1], -r0
    1108:	00036611 	andeq	r6, r3, r1, lsl r6
    110c:	77910200 	ldrvc	r0, [r1, r0, lsl #4]
    1110:	0cd70000 	ldcleq	0, cr0, [r7], {0}
    1114:	00040000 	andeq	r0, r4, r0
    1118:	00000479 	andeq	r0, r0, r9, ror r4
    111c:	15d00104 	ldrbne	r0, [r0, #260]	; 0x104
    1120:	4b040000 	blmi	101128 <__bss_end+0xf80ec>
    1124:	f9000013 			; <UNDEFINED> instruction: 0xf9000013
    1128:	24000013 	strcs	r0, [r0], #-19	; 0xffffffed
    112c:	5c000084 	stcpl	0, cr0, [r0], {132}	; 0x84
    1130:	7a000004 	bvc	1148 <shift+0x1148>
    1134:	02000004 	andeq	r0, r0, #4
    1138:	10350801 	eorsne	r0, r5, r1, lsl #16
    113c:	25030000 	strcs	r0, [r3, #-0]
    1140:	02000000 	andeq	r0, r0, #0
    1144:	0d890502 	cfstr32eq	mvfx0, [r9, #8]
    1148:	04040000 	streq	r0, [r4], #-0
    114c:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    1150:	08010200 	stmdaeq	r1, {r9}
    1154:	0000102c 	andeq	r1, r0, ip, lsr #32
    1158:	c6070202 	strgt	r0, [r7], -r2, lsl #4
    115c:	05000011 	streq	r0, [r0, #-17]	; 0xffffffef
    1160:	000006c8 	andeq	r0, r0, r8, asr #13
    1164:	5e070907 	vmlapl.f16	s0, s14, s14	; <UNPREDICTABLE>
    1168:	03000000 	movweq	r0, #0
    116c:	0000004d 	andeq	r0, r0, sp, asr #32
    1170:	d7070402 	strle	r0, [r7, -r2, lsl #8]
    1174:	0600001c 			; <UNDEFINED> instruction: 0x0600001c
    1178:	000012bf 			; <UNDEFINED> instruction: 0x000012bf
    117c:	08060208 	stmdaeq	r6, {r3, r9}
    1180:	0000008b 	andeq	r0, r0, fp, lsl #1
    1184:	00307207 	eorseq	r7, r0, r7, lsl #4
    1188:	4d0e0802 	stcmi	8, cr0, [lr, #-8]
    118c:	00000000 	andeq	r0, r0, r0
    1190:	00317207 	eorseq	r7, r1, r7, lsl #4
    1194:	4d0e0902 	vstrmi.16	s0, [lr, #-4]	; <UNPREDICTABLE>
    1198:	04000000 	streq	r0, [r0], #-0
    119c:	150f0800 	strne	r0, [pc, #-2048]	; 9a4 <shift+0x9a4>
    11a0:	04050000 	streq	r0, [r5], #-0
    11a4:	00000038 	andeq	r0, r0, r8, lsr r0
    11a8:	a90c0d02 	stmdbge	ip, {r1, r8, sl, fp}
    11ac:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    11b0:	00004b4f 	andeq	r4, r0, pc, asr #22
    11b4:	0013820a 	andseq	r8, r3, sl, lsl #4
    11b8:	08000100 	stmdaeq	r0, {r8}
    11bc:	00000e7c 	andeq	r0, r0, ip, ror lr
    11c0:	00380405 	eorseq	r0, r8, r5, lsl #8
    11c4:	1e020000 	cdpne	0, 0, cr0, cr2, cr0, {0}
    11c8:	0000e00c 	andeq	lr, r0, ip
    11cc:	06c00a00 	strbeq	r0, [r0], r0, lsl #20
    11d0:	0a000000 	beq	11d8 <shift+0x11d8>
    11d4:	000008e9 	andeq	r0, r0, r9, ror #17
    11d8:	0e9e0a01 	vfnmseq.f32	s0, s28, s2
    11dc:	0a020000 	beq	811e4 <__bss_end+0x781a8>
    11e0:	00001048 	andeq	r1, r0, r8, asr #32
    11e4:	08d40a03 	ldmeq	r4, {r0, r1, r9, fp}^
    11e8:	0a040000 	beq	1011f0 <__bss_end+0xf81b4>
    11ec:	00000d61 	andeq	r0, r0, r1, ror #26
    11f0:	5c080005 	stcpl	0, cr0, [r8], {5}
    11f4:	0500000e 	streq	r0, [r0, #-14]
    11f8:	00003804 	andeq	r3, r0, r4, lsl #16
    11fc:	0c3f0200 	lfmeq	f0, 4, [pc], #-0	; 1204 <shift+0x1204>
    1200:	0000011d 	andeq	r0, r0, sp, lsl r1
    1204:	00082b0a 	andeq	r2, r8, sl, lsl #22
    1208:	850a0000 	strhi	r0, [sl, #-0]
    120c:	0100000f 	tsteq	r0, pc
    1210:	0012460a 	andseq	r4, r2, sl, lsl #12
    1214:	600a0200 	andvs	r0, sl, r0, lsl #4
    1218:	0300000c 	movweq	r0, #12
    121c:	0008e30a 	andeq	lr, r8, sl, lsl #6
    1220:	d20a0400 	andle	r0, sl, #0, 8
    1224:	05000009 	streq	r0, [r0, #-9]
    1228:	00072d0a 	andeq	r2, r7, sl, lsl #26
    122c:	08000600 	stmdaeq	r0, {r9, sl}
    1230:	00000712 	andeq	r0, r0, r2, lsl r7
    1234:	00380405 	eorseq	r0, r8, r5, lsl #8
    1238:	66020000 	strvs	r0, [r2], -r0
    123c:	0001480c 	andeq	r4, r1, ip, lsl #16
    1240:	10210a00 	eorne	r0, r1, r0, lsl #20
    1244:	0a000000 	beq	124c <shift+0x124c>
    1248:	00000594 	muleq	r0, r4, r5
    124c:	0ec20a01 	vdiveq.f32	s1, s4, s2
    1250:	0a020000 	beq	81258 <__bss_end+0x7821c>
    1254:	00000d71 	andeq	r0, r0, r1, ror sp
    1258:	c70b0003 	strgt	r0, [fp, -r3]
    125c:	0300000b 	movweq	r0, #11
    1260:	00591405 	subseq	r1, r9, r5, lsl #8
    1264:	03050000 	movweq	r0, #20480	; 0x5000
    1268:	00008fd8 	ldrdeq	r8, [r0], -r8	; <UNPREDICTABLE>
    126c:	000f8a0b 	andeq	r8, pc, fp, lsl #20
    1270:	14060300 	strne	r0, [r6], #-768	; 0xfffffd00
    1274:	00000059 	andeq	r0, r0, r9, asr r0
    1278:	8fdc0305 	svchi	0x00dc0305
    127c:	3d0b0000 	stccc	0, cr0, [fp, #-0]
    1280:	0400000a 	streq	r0, [r0], #-10
    1284:	00591a07 	subseq	r1, r9, r7, lsl #20
    1288:	03050000 	movweq	r0, #20480	; 0x5000
    128c:	00008fe0 	andeq	r8, r0, r0, ror #31
    1290:	000d9a0b 	andeq	r9, sp, fp, lsl #20
    1294:	1a090400 	bne	24229c <__bss_end+0x239260>
    1298:	00000059 	andeq	r0, r0, r9, asr r0
    129c:	8fe40305 	svchi	0x00e40305
    12a0:	000b0000 	andeq	r0, fp, r0
    12a4:	0400000a 	streq	r0, [r0], #-10
    12a8:	00591a0b 	subseq	r1, r9, fp, lsl #20
    12ac:	03050000 	movweq	r0, #20480	; 0x5000
    12b0:	00008fe8 	andeq	r8, r0, r8, ror #31
    12b4:	000d2c0b 	andeq	r2, sp, fp, lsl #24
    12b8:	1a0d0400 	bne	3422c0 <__bss_end+0x339284>
    12bc:	00000059 	andeq	r0, r0, r9, asr r0
    12c0:	8fec0305 	svchi	0x00ec0305
    12c4:	a00b0000 	andge	r0, fp, r0
    12c8:	04000006 	streq	r0, [r0], #-6
    12cc:	00591a0f 	subseq	r1, r9, pc, lsl #20
    12d0:	03050000 	movweq	r0, #20480	; 0x5000
    12d4:	00008ff0 	strdeq	r8, [r0], -r0
    12d8:	000c4608 	andeq	r4, ip, r8, lsl #12
    12dc:	38040500 	stmdacc	r4, {r8, sl}
    12e0:	04000000 	streq	r0, [r0], #-0
    12e4:	01eb0c1b 	mvneq	r0, fp, lsl ip
    12e8:	430a0000 	movwmi	r0, #40960	; 0xa000
    12ec:	00000006 	andeq	r0, r0, r6
    12f0:	0010b40a 	andseq	fp, r0, sl, lsl #8
    12f4:	410a0100 	mrsmi	r0, (UNDEF: 26)
    12f8:	02000012 	andeq	r0, r0, #18
    12fc:	041b0c00 	ldreq	r0, [fp], #-3072	; 0xfffff400
    1300:	e30d0000 	movw	r0, #53248	; 0xd000
    1304:	90000004 	andls	r0, r0, r4
    1308:	5e076304 	cdppl	3, 0, cr6, cr7, cr4, {0}
    130c:	06000003 	streq	r0, [r0], -r3
    1310:	0000061f 	andeq	r0, r0, pc, lsl r6
    1314:	10670424 	rsbne	r0, r7, r4, lsr #8
    1318:	00000278 	andeq	r0, r0, r8, ror r2
    131c:	0020470e 	eoreq	r4, r0, lr, lsl #14
    1320:	12690400 	rsbne	r0, r9, #0, 8
    1324:	0000035e 	andeq	r0, r0, lr, asr r3
    1328:	08300e00 	ldmdaeq	r0!, {r9, sl, fp}
    132c:	6b040000 	blvs	101334 <__bss_end+0xf82f8>
    1330:	00036e12 	andeq	r6, r3, r2, lsl lr
    1334:	380e1000 	stmdacc	lr, {ip}
    1338:	04000006 	streq	r0, [r0], #-6
    133c:	004d166d 	subeq	r1, sp, sp, ror #12
    1340:	0e140000 	cdpeq	0, 1, cr0, cr4, cr0, {0}
    1344:	00000d6a 	andeq	r0, r0, sl, ror #26
    1348:	751c7004 	ldrvc	r7, [ip, #-4]
    134c:	18000003 	stmdane	r0, {r0, r1}
    1350:	0011fe0e 	andseq	pc, r1, lr, lsl #28
    1354:	1c720400 	cfldrdne	mvd0, [r2], #-0
    1358:	00000375 	andeq	r0, r0, r5, ror r3
    135c:	04de0e1c 	ldrbeq	r0, [lr], #3612	; 0xe1c
    1360:	75040000 	strvc	r0, [r4, #-0]
    1364:	0003751c 	andeq	r7, r3, ip, lsl r5
    1368:	4b0f2000 	blmi	3c9370 <__bss_end+0x3c0334>
    136c:	0400000e 	streq	r0, [r0], #-14
    1370:	11511c77 	cmpne	r1, r7, ror ip
    1374:	03750000 	cmneq	r5, #0
    1378:	026c0000 	rsbeq	r0, ip, #0
    137c:	75100000 	ldrvc	r0, [r0, #-0]
    1380:	11000003 	tstne	r0, r3
    1384:	0000037b 	andeq	r0, r0, fp, ror r3
    1388:	36060000 	strcc	r0, [r6], -r0
    138c:	18000012 	stmdane	r0, {r1, r4}
    1390:	ad107b04 	vldrge	d7, [r0, #-16]
    1394:	0e000002 	cdpeq	0, 0, cr0, cr0, cr2, {0}
    1398:	00002047 	andeq	r2, r0, r7, asr #32
    139c:	5e127e04 	cdppl	14, 1, cr7, cr2, cr4, {0}
    13a0:	00000003 	andeq	r0, r0, r3
    13a4:	0005400e 	andeq	r4, r5, lr
    13a8:	19800400 	stmibne	r0, {sl}
    13ac:	0000037b 	andeq	r0, r0, fp, ror r3
    13b0:	09d90e10 	ldmibeq	r9, {r4, r9, sl, fp}^
    13b4:	82040000 	andhi	r0, r4, #0
    13b8:	00038621 	andeq	r8, r3, r1, lsr #12
    13bc:	03001400 	movweq	r1, #1024	; 0x400
    13c0:	00000278 	andeq	r0, r0, r8, ror r2
    13c4:	00049112 	andeq	r9, r4, r2, lsl r1
    13c8:	21860400 	orrcs	r0, r6, r0, lsl #8
    13cc:	0000038c 	andeq	r0, r0, ip, lsl #7
    13d0:	00085a12 	andeq	r5, r8, r2, lsl sl
    13d4:	1f880400 	svcne	0x00880400
    13d8:	00000059 	andeq	r0, r0, r9, asr r0
    13dc:	000dac0e 	andeq	sl, sp, lr, lsl #24
    13e0:	178b0400 	strne	r0, [fp, r0, lsl #8]
    13e4:	000001fd 	strdeq	r0, [r0], -sp
    13e8:	07920e00 	ldreq	r0, [r2, r0, lsl #28]
    13ec:	8e040000 	cdphi	0, 0, cr0, cr4, cr0, {0}
    13f0:	0001fd17 	andeq	pc, r1, r7, lsl sp	; <UNPREDICTABLE>
    13f4:	4b0e2400 	blmi	38a3fc <__bss_end+0x3813c0>
    13f8:	0400000b 	streq	r0, [r0], #-11
    13fc:	01fd178f 	mvnseq	r1, pc, lsl #15
    1400:	0e480000 	cdpeq	0, 4, cr0, cr8, cr0, {0}
    1404:	0000095a 	andeq	r0, r0, sl, asr r9
    1408:	fd179004 	ldc2	0, cr9, [r7, #-16]
    140c:	6c000001 	stcvs	0, cr0, [r0], {1}
    1410:	0004e313 	andeq	lr, r4, r3, lsl r3
    1414:	09930400 	ldmibeq	r3, {sl}
    1418:	00000cef 	andeq	r0, r0, pc, ror #25
    141c:	00000397 	muleq	r0, r7, r3
    1420:	00031701 	andeq	r1, r3, r1, lsl #14
    1424:	00031d00 	andeq	r1, r3, r0, lsl #26
    1428:	03971000 	orrseq	r1, r7, #0
    142c:	14000000 	strne	r0, [r0], #-0
    1430:	00000e40 	andeq	r0, r0, r0, asr #28
    1434:	210e9604 	tstcs	lr, r4, lsl #12
    1438:	01000005 	tsteq	r0, r5
    143c:	00000332 	andeq	r0, r0, r2, lsr r3
    1440:	00000338 	andeq	r0, r0, r8, lsr r3
    1444:	00039710 	andeq	r9, r3, r0, lsl r7
    1448:	2b150000 	blcs	541450 <__bss_end+0x538414>
    144c:	04000008 	streq	r0, [r0], #-8
    1450:	0c2b1099 	stceq	0, cr1, [fp], #-612	; 0xfffffd9c
    1454:	039d0000 	orrseq	r0, sp, #0
    1458:	4d010000 	stcmi	0, cr0, [r1, #-0]
    145c:	10000003 	andne	r0, r0, r3
    1460:	00000397 	muleq	r0, r7, r3
    1464:	00037b11 	andeq	r7, r3, r1, lsl fp
    1468:	01c61100 	biceq	r1, r6, r0, lsl #2
    146c:	00000000 	andeq	r0, r0, r0
    1470:	00002516 	andeq	r2, r0, r6, lsl r5
    1474:	00036e00 	andeq	r6, r3, r0, lsl #28
    1478:	005e1700 	subseq	r1, lr, r0, lsl #14
    147c:	000f0000 	andeq	r0, pc, r0
    1480:	e6020102 	str	r0, [r2], -r2, lsl #2
    1484:	1800000a 	stmdane	r0, {r1, r3}
    1488:	0001fd04 	andeq	pc, r1, r4, lsl #26
    148c:	2c041800 	stccs	8, cr1, [r4], {-0}
    1490:	0c000000 	stceq	0, cr0, [r0], {-0}
    1494:	00001126 	andeq	r1, r0, r6, lsr #2
    1498:	03810418 	orreq	r0, r1, #24, 8	; 0x18000000
    149c:	ad160000 	ldcge	0, cr0, [r6, #-0]
    14a0:	97000002 	strls	r0, [r0, -r2]
    14a4:	19000003 	stmdbne	r0, {r0, r1}
    14a8:	f0041800 			; <UNDEFINED> instruction: 0xf0041800
    14ac:	18000001 	stmdane	r0, {r0}
    14b0:	0001eb04 	andeq	lr, r1, r4, lsl #22
    14b4:	0e341a00 	vaddeq.f32	s2, s8, s0
    14b8:	9c040000 	stcls	0, cr0, [r4], {-0}
    14bc:	0001f014 	andeq	pc, r1, r4, lsl r0	; <UNPREDICTABLE>
    14c0:	06590b00 	ldrbeq	r0, [r9], -r0, lsl #22
    14c4:	04050000 	streq	r0, [r5], #-0
    14c8:	00005914 	andeq	r5, r0, r4, lsl r9
    14cc:	f4030500 	vst3.8	{d0,d2,d4}, [r3], r0
    14d0:	0b00008f 	bleq	1714 <shift+0x1714>
    14d4:	00000ea4 	andeq	r0, r0, r4, lsr #29
    14d8:	59140705 	ldmdbpl	r4, {r0, r2, r8, r9, sl}
    14dc:	05000000 	streq	r0, [r0, #-0]
    14e0:	008ff803 	addeq	pc, pc, r3, lsl #16
    14e4:	050e0b00 	streq	r0, [lr, #-2816]	; 0xfffff500
    14e8:	0a050000 	beq	1414f0 <__bss_end+0x1384b4>
    14ec:	00005914 	andeq	r5, r0, r4, lsl r9
    14f0:	fc030500 	stc2	5, cr0, [r3], {-0}
    14f4:	0800008f 	stmdaeq	r0, {r0, r1, r2, r3, r7}
    14f8:	00000732 	andeq	r0, r0, r2, lsr r7
    14fc:	00380405 	eorseq	r0, r8, r5, lsl #8
    1500:	0d050000 	stceq	0, cr0, [r5, #-0]
    1504:	00041c0c 	andeq	r1, r4, ip, lsl #24
    1508:	654e0900 	strbvs	r0, [lr, #-2304]	; 0xfffff700
    150c:	0a000077 	beq	16f0 <shift+0x16f0>
    1510:	000008f3 	strdeq	r0, [r0], -r3
    1514:	05060a01 	streq	r0, [r6, #-2561]	; 0xfffff5ff
    1518:	0a020000 	beq	81520 <__bss_end+0x784e4>
    151c:	00000750 	andeq	r0, r0, r0, asr r7
    1520:	103a0a03 	eorsne	r0, sl, r3, lsl #20
    1524:	0a040000 	beq	10152c <__bss_end+0xf84f0>
    1528:	000004d7 	ldrdeq	r0, [r0], -r7
    152c:	72060005 	andvc	r0, r6, #5
    1530:	10000006 	andne	r0, r0, r6
    1534:	5b081b05 	blpl	208150 <__bss_end+0x1ff114>
    1538:	07000004 	streq	r0, [r0, -r4]
    153c:	0500726c 	streq	r7, [r0, #-620]	; 0xfffffd94
    1540:	045b131d 	ldrbeq	r1, [fp], #-797	; 0xfffffce3
    1544:	07000000 	streq	r0, [r0, -r0]
    1548:	05007073 	streq	r7, [r0, #-115]	; 0xffffff8d
    154c:	045b131e 	ldrbeq	r1, [fp], #-798	; 0xfffffce2
    1550:	07040000 	streq	r0, [r4, -r0]
    1554:	05006370 	streq	r6, [r0, #-880]	; 0xfffffc90
    1558:	045b131f 	ldrbeq	r1, [fp], #-799	; 0xfffffce1
    155c:	0e080000 	cdpeq	0, 0, cr0, cr8, cr0, {0}
    1560:	00000e56 	andeq	r0, r0, r6, asr lr
    1564:	5b132005 	blpl	4c9580 <__bss_end+0x4c0544>
    1568:	0c000004 	stceq	0, cr0, [r0], {4}
    156c:	07040200 	streq	r0, [r4, -r0, lsl #4]
    1570:	00001cd2 	ldrdeq	r1, [r0], -r2
    1574:	0008c706 	andeq	ip, r8, r6, lsl #14
    1578:	28057000 	stmdacs	r5, {ip, sp, lr}
    157c:	0004f208 	andeq	pc, r4, r8, lsl #4
    1580:	07da0e00 	ldrbeq	r0, [sl, r0, lsl #28]
    1584:	2a050000 	bcs	14158c <__bss_end+0x138550>
    1588:	00041c12 	andeq	r1, r4, r2, lsl ip
    158c:	70070000 	andvc	r0, r7, r0
    1590:	05006469 	streq	r6, [r0, #-1129]	; 0xfffffb97
    1594:	005e122b 	subseq	r1, lr, fp, lsr #4
    1598:	0e100000 	cdpeq	0, 1, cr0, cr0, cr0, {0}
    159c:	00001a23 	andeq	r1, r0, r3, lsr #20
    15a0:	e5112c05 	ldr	r2, [r1, #-3077]	; 0xfffff3fb
    15a4:	14000003 	strne	r0, [r0], #-3
    15a8:	0010130e 	andseq	r1, r0, lr, lsl #6
    15ac:	122d0500 	eorne	r0, sp, #0, 10
    15b0:	0000005e 	andeq	r0, r0, lr, asr r0
    15b4:	03ab0e18 			; <UNDEFINED> instruction: 0x03ab0e18
    15b8:	2e050000 	cdpcs	0, 0, cr0, cr5, cr0, {0}
    15bc:	00005e12 	andeq	r5, r0, r2, lsl lr
    15c0:	910e1c00 	tstls	lr, r0, lsl #24
    15c4:	0500000e 	streq	r0, [r0, #-14]
    15c8:	04f20c2f 	ldrbteq	r0, [r2], #3119	; 0xc2f
    15cc:	0e200000 	cdpeq	0, 2, cr0, cr0, cr0, {0}
    15d0:	00000487 	andeq	r0, r0, r7, lsl #9
    15d4:	38093005 	stmdacc	r9, {r0, r2, ip, sp}
    15d8:	60000000 	andvs	r0, r0, r0
    15dc:	000aa50e 	andeq	sl, sl, lr, lsl #10
    15e0:	0e310500 	cfabs32eq	mvfx0, mvfx1
    15e4:	0000004d 	andeq	r0, r0, sp, asr #32
    15e8:	0cd40e64 	ldcleq	14, cr0, [r4], {100}	; 0x64
    15ec:	33050000 	movwcc	r0, #20480	; 0x5000
    15f0:	00004d0e 	andeq	r4, r0, lr, lsl #26
    15f4:	cb0e6800 	blgt	39b5fc <__bss_end+0x3925c0>
    15f8:	0500000c 	streq	r0, [r0, #-12]
    15fc:	004d0e34 	subeq	r0, sp, r4, lsr lr
    1600:	006c0000 	rsbeq	r0, ip, r0
    1604:	00039d16 	andeq	r9, r3, r6, lsl sp
    1608:	00050200 	andeq	r0, r5, r0, lsl #4
    160c:	005e1700 	subseq	r1, lr, r0, lsl #14
    1610:	000f0000 	andeq	r0, pc, r0
    1614:	0004f70b 	andeq	pc, r4, fp, lsl #14
    1618:	140a0600 	strne	r0, [sl], #-1536	; 0xfffffa00
    161c:	00000059 	andeq	r0, r0, r9, asr r0
    1620:	90000305 	andls	r0, r0, r5, lsl #6
    1624:	90080000 	andls	r0, r8, r0
    1628:	0500000a 	streq	r0, [r0, #-10]
    162c:	00003804 	andeq	r3, r0, r4, lsl #16
    1630:	0c0d0600 	stceq	6, cr0, [sp], {-0}
    1634:	00000533 	andeq	r0, r0, r3, lsr r5
    1638:	00124c0a 	andseq	r4, r2, sl, lsl #24
    163c:	e90a0000 	stmdb	sl, {}	; <UNPREDICTABLE>
    1640:	01000010 	tsteq	r0, r0, lsl r0
    1644:	05140300 	ldreq	r0, [r4, #-768]	; 0xfffffd00
    1648:	62080000 	andvs	r0, r8, #0
    164c:	05000014 	streq	r0, [r0, #-20]	; 0xffffffec
    1650:	00003804 	andeq	r3, r0, r4, lsl #16
    1654:	0c140600 	ldceq	6, cr0, [r4], {-0}
    1658:	00000557 	andeq	r0, r0, r7, asr r5
    165c:	0012e50a 	andseq	lr, r2, sl, lsl #10
    1660:	e10a0000 	mrs	r0, (UNDEF: 10)
    1664:	01000014 	tsteq	r0, r4, lsl r0
    1668:	05380300 	ldreq	r0, [r8, #-768]!	; 0xfffffd00
    166c:	bf060000 	svclt	0x00060000
    1670:	0c000007 	stceq	0, cr0, [r0], {7}
    1674:	91081b06 	tstls	r8, r6, lsl #22
    1678:	0e000005 	cdpeq	0, 0, cr0, cr0, cr5, {0}
    167c:	0000059f 	muleq	r0, pc, r5	; <UNPREDICTABLE>
    1680:	91191d06 	tstls	r9, r6, lsl #26
    1684:	00000005 	andeq	r0, r0, r5
    1688:	0004de0e 	andeq	sp, r4, lr, lsl #28
    168c:	191e0600 	ldmdbne	lr, {r9, sl}
    1690:	00000591 	muleq	r0, r1, r5
    1694:	0ac00e04 	beq	ff004eac <__bss_end+0xfeffbe70>
    1698:	1f060000 	svcne	0x00060000
    169c:	00059713 	andeq	r9, r5, r3, lsl r7
    16a0:	18000800 	stmdane	r0, {fp}
    16a4:	00055c04 	andeq	r5, r5, r4, lsl #24
    16a8:	62041800 	andvs	r1, r4, #0, 16
    16ac:	0d000004 	stceq	0, cr0, [r0, #-16]
    16b0:	00000dbb 			; <UNDEFINED> instruction: 0x00000dbb
    16b4:	07220614 			; <UNDEFINED> instruction: 0x07220614
    16b8:	0000081f 	andeq	r0, r0, pc, lsl r8
    16bc:	000bd50e 	andeq	sp, fp, lr, lsl #10
    16c0:	12260600 	eorne	r0, r6, #0, 12
    16c4:	0000004d 	andeq	r0, r0, sp, asr #32
    16c8:	0b680e00 	bleq	1a04ed0 <__bss_end+0x19fbe94>
    16cc:	29060000 	stmdbcs	r6, {}	; <UNPREDICTABLE>
    16d0:	0005911d 	andeq	r9, r5, sp, lsl r1
    16d4:	580e0400 	stmdapl	lr, {sl}
    16d8:	06000007 	streq	r0, [r0], -r7
    16dc:	05911d2c 	ldreq	r1, [r1, #3372]	; 0xd2c
    16e0:	1b080000 	blne	2016e8 <__bss_end+0x1f86ac>
    16e4:	00000c56 	andeq	r0, r0, r6, asr ip
    16e8:	9c0e2f06 	stcls	15, cr2, [lr], {6}
    16ec:	e5000007 	str	r0, [r0, #-7]
    16f0:	f0000005 			; <UNDEFINED> instruction: 0xf0000005
    16f4:	10000005 	andne	r0, r0, r5
    16f8:	00000824 	andeq	r0, r0, r4, lsr #16
    16fc:	00059111 	andeq	r9, r5, r1, lsl r1
    1700:	fc1c0000 	ldc2	0, cr0, [ip], {-0}
    1704:	06000008 	streq	r0, [r0], -r8
    1708:	089e0e31 	ldmeq	lr, {r0, r4, r5, r9, sl, fp}
    170c:	036e0000 	cmneq	lr, #0
    1710:	06080000 	streq	r0, [r8], -r0
    1714:	06130000 	ldreq	r0, [r3], -r0
    1718:	24100000 	ldrcs	r0, [r0], #-0
    171c:	11000008 	tstne	r0, r8
    1720:	00000597 	muleq	r0, r7, r5
    1724:	10951300 	addsne	r1, r5, r0, lsl #6
    1728:	35060000 	strcc	r0, [r6, #-0]
    172c:	000a6b1d 	andeq	r6, sl, sp, lsl fp
    1730:	00059100 	andeq	r9, r5, r0, lsl #2
    1734:	062c0200 	strteq	r0, [ip], -r0, lsl #4
    1738:	06320000 	ldrteq	r0, [r2], -r0
    173c:	24100000 	ldrcs	r0, [r0], #-0
    1740:	00000008 	andeq	r0, r0, r8
    1744:	00074313 	andeq	r4, r7, r3, lsl r3
    1748:	1d370600 	ldcne	6, cr0, [r7, #-0]
    174c:	00000c66 	andeq	r0, r0, r6, ror #24
    1750:	00000591 	muleq	r0, r1, r5
    1754:	00064b02 	andeq	r4, r6, r2, lsl #22
    1758:	00065100 	andeq	r5, r6, r0, lsl #2
    175c:	08241000 	stmdaeq	r4!, {ip}
    1760:	1d000000 	stcne	0, cr0, [r0, #-0]
    1764:	00000b7b 	andeq	r0, r0, fp, ror fp
    1768:	3d313906 			; <UNDEFINED> instruction: 0x3d313906
    176c:	0c000008 	stceq	0, cr0, [r0], {8}
    1770:	0dbb1302 	ldceq	3, cr1, [fp, #8]!
    1774:	3c060000 	stccc	0, cr0, [r6], {-0}
    1778:	00090b09 	andeq	r0, r9, r9, lsl #22
    177c:	00082400 	andeq	r2, r8, r0, lsl #8
    1780:	06780100 	ldrbteq	r0, [r8], -r0, lsl #2
    1784:	067e0000 	ldrbteq	r0, [lr], -r0
    1788:	24100000 	ldrcs	r0, [r0], #-0
    178c:	00000008 	andeq	r0, r0, r8
    1790:	0007ec13 	andeq	lr, r7, r3, lsl ip
    1794:	123f0600 	eorsne	r0, pc, #0, 12
    1798:	00000569 	andeq	r0, r0, r9, ror #10
    179c:	0000004d 	andeq	r0, r0, sp, asr #32
    17a0:	00069701 	andeq	r9, r6, r1, lsl #14
    17a4:	0006ac00 	andeq	sl, r6, r0, lsl #24
    17a8:	08241000 	stmdaeq	r4!, {ip}
    17ac:	46110000 	ldrmi	r0, [r1], -r0
    17b0:	11000008 	tstne	r0, r8
    17b4:	0000005e 	andeq	r0, r0, lr, asr r0
    17b8:	00036e11 	andeq	r6, r3, r1, lsl lr
    17bc:	bf140000 	svclt	0x00140000
    17c0:	06000010 			; <UNDEFINED> instruction: 0x06000010
    17c4:	067f0e42 	ldrbteq	r0, [pc], -r2, asr #28
    17c8:	c1010000 	mrsgt	r0, (UNDEF: 1)
    17cc:	c7000006 	strgt	r0, [r0, -r6]
    17d0:	10000006 	andne	r0, r0, r6
    17d4:	00000824 	andeq	r0, r0, r4, lsr #16
    17d8:	054b1300 	strbeq	r1, [fp, #-768]	; 0xfffffd00
    17dc:	45060000 	strmi	r0, [r6, #-0]
    17e0:	0005f117 	andeq	pc, r5, r7, lsl r1	; <UNPREDICTABLE>
    17e4:	00059700 	andeq	r9, r5, r0, lsl #14
    17e8:	06e00100 	strbteq	r0, [r0], r0, lsl #2
    17ec:	06e60000 	strbteq	r0, [r6], r0
    17f0:	4c100000 	ldcmi	0, cr0, [r0], {-0}
    17f4:	00000008 	andeq	r0, r0, r8
    17f8:	000eaf13 	andeq	sl, lr, r3, lsl pc
    17fc:	17480600 	strbne	r0, [r8, -r0, lsl #12]
    1800:	000003c1 	andeq	r0, r0, r1, asr #7
    1804:	00000597 	muleq	r0, r7, r5
    1808:	0006ff01 	andeq	pc, r6, r1, lsl #30
    180c:	00070a00 	andeq	r0, r7, r0, lsl #20
    1810:	084c1000 	stmdaeq	ip, {ip}^
    1814:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    1818:	00000000 	andeq	r0, r0, r0
    181c:	0006aa14 	andeq	sl, r6, r4, lsl sl
    1820:	0e4b0600 	cdpeq	6, 4, cr0, cr11, cr0, {0}
    1824:	00000b89 	andeq	r0, r0, r9, lsl #23
    1828:	00071f01 	andeq	r1, r7, r1, lsl #30
    182c:	00072500 	andeq	r2, r7, r0, lsl #10
    1830:	08241000 	stmdaeq	r4!, {ip}
    1834:	13000000 	movwne	r0, #0
    1838:	000008fc 	strdeq	r0, [r0], -ip
    183c:	040e4d06 	streq	r4, [lr], #-3334	; 0xfffff2fa
    1840:	6e00000d 	cdpvs	0, 0, cr0, cr0, cr13, {0}
    1844:	01000003 	tsteq	r0, r3
    1848:	0000073e 	andeq	r0, r0, lr, lsr r7
    184c:	00000749 	andeq	r0, r0, r9, asr #14
    1850:	00082410 	andeq	r2, r8, r0, lsl r4
    1854:	004d1100 	subeq	r1, sp, r0, lsl #2
    1858:	13000000 	movwne	r0, #0
    185c:	000004c3 	andeq	r0, r0, r3, asr #9
    1860:	ee125006 	cdp	0, 1, cr5, cr2, cr6, {0}
    1864:	4d000003 	stcmi	0, cr0, [r0, #-12]
    1868:	01000000 	mrseq	r0, (UNDEF: 0)
    186c:	00000762 	andeq	r0, r0, r2, ror #14
    1870:	0000076d 	andeq	r0, r0, sp, ror #14
    1874:	00082410 	andeq	r2, r8, r0, lsl r4
    1878:	039d1100 	orrseq	r1, sp, #0, 2
    187c:	13000000 	movwne	r0, #0
    1880:	00000421 	andeq	r0, r0, r1, lsr #8
    1884:	f40e5306 	vst2.8	{d5-d8}, [lr], r6
    1888:	6e000010 	mcrvs	0, 0, r0, cr0, cr0, {0}
    188c:	01000003 	tsteq	r0, r3
    1890:	00000786 	andeq	r0, r0, r6, lsl #15
    1894:	00000791 	muleq	r0, r1, r7
    1898:	00082410 	andeq	r2, r8, r0, lsl r4
    189c:	004d1100 	subeq	r1, sp, r0, lsl #2
    18a0:	14000000 	strne	r0, [r0], #-0
    18a4:	0000049d 	muleq	r0, sp, r4
    18a8:	960e5606 	strls	r5, [lr], -r6, lsl #12
    18ac:	0100000f 	tsteq	r0, pc
    18b0:	000007a6 	andeq	r0, r0, r6, lsr #15
    18b4:	000007c5 	andeq	r0, r0, r5, asr #15
    18b8:	00082410 	andeq	r2, r8, r0, lsl r4
    18bc:	00a91100 	adceq	r1, r9, r0, lsl #2
    18c0:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    18c4:	11000000 	mrsne	r0, (UNDEF: 0)
    18c8:	0000004d 	andeq	r0, r0, sp, asr #32
    18cc:	00004d11 	andeq	r4, r0, r1, lsl sp
    18d0:	08521100 	ldmdaeq	r2, {r8, ip}^
    18d4:	14000000 	strne	r0, [r0], #-0
    18d8:	00001181 	andeq	r1, r0, r1, lsl #3
    18dc:	730e5806 	movwvc	r5, #59398	; 0xe806
    18e0:	01000012 	tsteq	r0, r2, lsl r0
    18e4:	000007da 	ldrdeq	r0, [r0], -sl
    18e8:	000007f9 	strdeq	r0, [r0], -r9
    18ec:	00082410 	andeq	r2, r8, r0, lsl r4
    18f0:	00e01100 	rsceq	r1, r0, r0, lsl #2
    18f4:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    18f8:	11000000 	mrsne	r0, (UNDEF: 0)
    18fc:	0000004d 	andeq	r0, r0, sp, asr #32
    1900:	00004d11 	andeq	r4, r0, r1, lsl sp
    1904:	08521100 	ldmdaeq	r2, {r8, ip}^
    1908:	15000000 	strne	r0, [r0, #-0]
    190c:	000004b0 			; <UNDEFINED> instruction: 0x000004b0
    1910:	eb0e5b06 	bl	398530 <__bss_end+0x38f4f4>
    1914:	6e00000a 	cdpvs	0, 0, cr0, cr0, cr10, {0}
    1918:	01000003 	tsteq	r0, r3
    191c:	0000080e 	andeq	r0, r0, lr, lsl #16
    1920:	00082410 	andeq	r2, r8, r0, lsl r4
    1924:	05141100 	ldreq	r1, [r4, #-256]	; 0xffffff00
    1928:	58110000 	ldmdapl	r1, {}	; <UNPREDICTABLE>
    192c:	00000008 	andeq	r0, r0, r8
    1930:	059d0300 	ldreq	r0, [sp, #768]	; 0x300
    1934:	04180000 	ldreq	r0, [r8], #-0
    1938:	0000059d 	muleq	r0, sp, r5
    193c:	0005911e 	andeq	r9, r5, lr, lsl r1
    1940:	00083700 	andeq	r3, r8, r0, lsl #14
    1944:	00083d00 	andeq	r3, r8, r0, lsl #26
    1948:	08241000 	stmdaeq	r4!, {ip}
    194c:	1f000000 	svcne	0x00000000
    1950:	0000059d 	muleq	r0, sp, r5
    1954:	0000082a 	andeq	r0, r0, sl, lsr #16
    1958:	003f0418 	eorseq	r0, pc, r8, lsl r4	; <UNPREDICTABLE>
    195c:	04180000 	ldreq	r0, [r8], #-0
    1960:	0000081f 	andeq	r0, r0, pc, lsl r8
    1964:	00650420 	rsbeq	r0, r5, r0, lsr #8
    1968:	04210000 	strteq	r0, [r1], #-0
    196c:	0011de1a 	andseq	sp, r1, sl, lsl lr
    1970:	195e0600 	ldmdbne	lr, {r9, sl}^
    1974:	0000059d 	muleq	r0, sp, r5
    1978:	00002c16 	andeq	r2, r0, r6, lsl ip
    197c:	00087600 	andeq	r7, r8, r0, lsl #12
    1980:	005e1700 	subseq	r1, lr, r0, lsl #14
    1984:	00090000 	andeq	r0, r9, r0
    1988:	00086603 	andeq	r6, r8, r3, lsl #12
    198c:	13ce2200 	bicne	r2, lr, #0, 4
    1990:	a4010000 	strge	r0, [r1], #-0
    1994:	0008760c 	andeq	r7, r8, ip, lsl #12
    1998:	04030500 	streq	r0, [r3], #-1280	; 0xfffffb00
    199c:	23000090 	movwcs	r0, #144	; 0x90
    19a0:	00000e77 	andeq	r0, r0, r7, ror lr
    19a4:	560aa601 	strpl	sl, [sl], -r1, lsl #12
    19a8:	4d000014 	stcmi	0, cr0, [r0, #-80]	; 0xffffffb0
    19ac:	d0000000 	andle	r0, r0, r0
    19b0:	b0000087 	andlt	r0, r0, r7, lsl #1
    19b4:	01000000 	mrseq	r0, (UNDEF: 0)
    19b8:	0008eb9c 	muleq	r8, ip, fp
    19bc:	20472400 	subcs	r2, r7, r0, lsl #8
    19c0:	a6010000 	strge	r0, [r1], -r0
    19c4:	00037b1b 	andeq	r7, r3, fp, lsl fp
    19c8:	ac910300 	ldcge	3, cr0, [r1], {0}
    19cc:	14b5247f 	ldrtne	r2, [r5], #1151	; 0x47f
    19d0:	a6010000 	strge	r0, [r1], -r0
    19d4:	00004d2a 	andeq	r4, r0, sl, lsr #26
    19d8:	a8910300 	ldmge	r1, {r8, r9}
    19dc:	143e227f 	ldrtne	r2, [lr], #-639	; 0xfffffd81
    19e0:	a8010000 	stmdage	r1, {}	; <UNPREDICTABLE>
    19e4:	0008eb0a 	andeq	lr, r8, sl, lsl #22
    19e8:	b4910300 	ldrlt	r0, [r1], #768	; 0x300
    19ec:	12f9227f 	rscsne	r2, r9, #-268435449	; 0xf0000007
    19f0:	ac010000 	stcge	0, cr0, [r1], {-0}
    19f4:	00003809 	andeq	r3, r0, r9, lsl #16
    19f8:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    19fc:	00251600 	eoreq	r1, r5, r0, lsl #12
    1a00:	08fb0000 	ldmeq	fp!, {}^	; <UNPREDICTABLE>
    1a04:	5e170000 	cdppl	0, 1, cr0, cr7, cr0, {0}
    1a08:	3f000000 	svccc	0x00000000
    1a0c:	149a2500 	ldrne	r2, [sl], #1280	; 0x500
    1a10:	98010000 	stmdals	r1, {}	; <UNPREDICTABLE>
    1a14:	0014ef0a 	andseq	lr, r4, sl, lsl #30
    1a18:	00004d00 	andeq	r4, r0, r0, lsl #26
    1a1c:	00879400 	addeq	r9, r7, r0, lsl #8
    1a20:	00003c00 	andeq	r3, r0, r0, lsl #24
    1a24:	389c0100 	ldmcc	ip, {r8}
    1a28:	26000009 	strcs	r0, [r0], -r9
    1a2c:	00716572 	rsbseq	r6, r1, r2, ror r5
    1a30:	57209a01 	strpl	r9, [r0, -r1, lsl #20]!
    1a34:	02000005 	andeq	r0, r0, #5
    1a38:	4b227491 	blmi	89ec84 <__bss_end+0x895c48>
    1a3c:	01000014 	tsteq	r0, r4, lsl r0
    1a40:	004d0e9b 	umaaleq	r0, sp, fp, lr
    1a44:	91020000 	mrsls	r0, (UNDEF: 2)
    1a48:	c4270070 	strtgt	r0, [r7], #-112	; 0xffffff90
    1a4c:	01000014 	tsteq	r0, r4, lsl r0
    1a50:	1315068f 	tstne	r5, #149946368	; 0x8f00000
    1a54:	87580000 	ldrbhi	r0, [r8, -r0]
    1a58:	003c0000 	eorseq	r0, ip, r0
    1a5c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1a60:	00000971 	andeq	r0, r0, r1, ror r9
    1a64:	0013ba24 	andseq	fp, r3, r4, lsr #20
    1a68:	218f0100 	orrcs	r0, pc, r0, lsl #2
    1a6c:	0000004d 	andeq	r0, r0, sp, asr #32
    1a70:	266c9102 	strbtcs	r9, [ip], -r2, lsl #2
    1a74:	00716572 	rsbseq	r6, r1, r2, ror r5
    1a78:	57209101 	strpl	r9, [r0, -r1, lsl #2]!
    1a7c:	02000005 	andeq	r0, r0, #5
    1a80:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    1a84:	00001477 	andeq	r1, r0, r7, ror r4
    1a88:	df0a8301 	svcle	0x000a8301
    1a8c:	4d000013 	stcmi	0, cr0, [r0, #-76]	; 0xffffffb4
    1a90:	1c000000 	stcne	0, cr0, [r0], {-0}
    1a94:	3c000087 	stccc	0, cr0, [r0], {135}	; 0x87
    1a98:	01000000 	mrseq	r0, (UNDEF: 0)
    1a9c:	0009ae9c 	muleq	r9, ip, lr
    1aa0:	65722600 	ldrbvs	r2, [r2, #-1536]!	; 0xfffffa00
    1aa4:	85010071 	strhi	r0, [r1, #-113]	; 0xffffff8f
    1aa8:	00053320 	andeq	r3, r5, r0, lsr #6
    1aac:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1ab0:	0012f222 	andseq	pc, r2, r2, lsr #4
    1ab4:	0e860100 	rmfeqs	f0, f6, f0
    1ab8:	0000004d 	andeq	r0, r0, sp, asr #32
    1abc:	00709102 	rsbseq	r9, r0, r2, lsl #2
    1ac0:	00158625 	andseq	r8, r5, r5, lsr #12
    1ac4:	0a770100 	beq	1dc1ecc <__bss_end+0x1db8e90>
    1ac8:	00001390 	muleq	r0, r0, r3
    1acc:	0000004d 	andeq	r0, r0, sp, asr #32
    1ad0:	000086e0 	andeq	r8, r0, r0, ror #13
    1ad4:	0000003c 	andeq	r0, r0, ip, lsr r0
    1ad8:	09eb9c01 	stmibeq	fp!, {r0, sl, fp, ip, pc}^
    1adc:	72260000 	eorvc	r0, r6, #0
    1ae0:	01007165 	tsteq	r0, r5, ror #2
    1ae4:	05332079 	ldreq	r2, [r3, #-121]!	; 0xffffff87
    1ae8:	91020000 	mrsls	r0, (UNDEF: 2)
    1aec:	12f22274 	rscsne	r2, r2, #116, 4	; 0x40000007
    1af0:	7a010000 	bvc	41af8 <__bss_end+0x38abc>
    1af4:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1af8:	70910200 	addsvc	r0, r1, r0, lsl #4
    1afc:	13f32500 	mvnsne	r2, #0, 10
    1b00:	6b010000 	blvs	41b08 <__bss_end+0x38acc>
    1b04:	0014d606 	andseq	sp, r4, r6, lsl #12
    1b08:	00036e00 	andeq	r6, r3, r0, lsl #28
    1b0c:	00868c00 	addeq	r8, r6, r0, lsl #24
    1b10:	00005400 	andeq	r5, r0, r0, lsl #8
    1b14:	379c0100 	ldrcc	r0, [ip, r0, lsl #2]
    1b18:	2400000a 	strcs	r0, [r0], #-10
    1b1c:	0000144b 	andeq	r1, r0, fp, asr #8
    1b20:	4d156b01 	vldrmi	d6, [r5, #-4]
    1b24:	02000000 	andeq	r0, r0, #0
    1b28:	cb246c91 	blgt	91cd74 <__bss_end+0x913d38>
    1b2c:	0100000c 	tsteq	r0, ip
    1b30:	004d256b 	subeq	r2, sp, fp, ror #10
    1b34:	91020000 	mrsls	r0, (UNDEF: 2)
    1b38:	157e2268 	ldrbne	r2, [lr, #-616]!	; 0xfffffd98
    1b3c:	6d010000 	stcvs	0, cr0, [r1, #-0]
    1b40:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1b44:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1b48:	132c2500 			; <UNDEFINED> instruction: 0x132c2500
    1b4c:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
    1b50:	00152612 	andseq	r2, r5, r2, lsl r6
    1b54:	00008b00 	andeq	r8, r0, r0, lsl #22
    1b58:	00863c00 	addeq	r3, r6, r0, lsl #24
    1b5c:	00005000 	andeq	r5, r0, r0
    1b60:	929c0100 	addsls	r0, ip, #0, 2
    1b64:	2400000a 	strcs	r0, [r0], #-10
    1b68:	0000073e 	andeq	r0, r0, lr, lsr r7
    1b6c:	4d205e01 	stcmi	14, cr5, [r0, #-4]!
    1b70:	02000000 	andeq	r0, r0, #0
    1b74:	80246c91 	mlahi	r4, r1, ip, r6
    1b78:	01000014 	tsteq	r0, r4, lsl r0
    1b7c:	004d2f5e 	subeq	r2, sp, lr, asr pc
    1b80:	91020000 	mrsls	r0, (UNDEF: 2)
    1b84:	0ccb2468 	cfstrdeq	mvd2, [fp], {104}	; 0x68
    1b88:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
    1b8c:	00004d3f 	andeq	r4, r0, pc, lsr sp
    1b90:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1b94:	00157e22 	andseq	r7, r5, r2, lsr #28
    1b98:	16600100 	strbtne	r0, [r0], -r0, lsl #2
    1b9c:	0000008b 	andeq	r0, r0, fp, lsl #1
    1ba0:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1ba4:	00144425 	andseq	r4, r4, r5, lsr #8
    1ba8:	0a520100 	beq	1481fb0 <__bss_end+0x1478f74>
    1bac:	00001331 	andeq	r1, r0, r1, lsr r3
    1bb0:	0000004d 	andeq	r0, r0, sp, asr #32
    1bb4:	000085f8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
    1bb8:	00000044 	andeq	r0, r0, r4, asr #32
    1bbc:	0ade9c01 	beq	ff7a8bc8 <__bss_end+0xff79fb8c>
    1bc0:	3e240000 	cdpcc	0, 2, cr0, cr4, cr0, {0}
    1bc4:	01000007 	tsteq	r0, r7
    1bc8:	004d1a52 	subeq	r1, sp, r2, asr sl
    1bcc:	91020000 	mrsls	r0, (UNDEF: 2)
    1bd0:	1480246c 	strne	r2, [r0], #1132	; 0x46c
    1bd4:	52010000 	andpl	r0, r1, #0
    1bd8:	00004d29 	andeq	r4, r0, r9, lsr #26
    1bdc:	68910200 	ldmvs	r1, {r9}
    1be0:	00155522 	andseq	r5, r5, r2, lsr #10
    1be4:	0e540100 	rdfeqs	f0, f4, f0
    1be8:	0000004d 	andeq	r0, r0, sp, asr #32
    1bec:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1bf0:	00154f25 	andseq	r4, r5, r5, lsr #30
    1bf4:	0a450100 	beq	1141ffc <__bss_end+0x1138fc0>
    1bf8:	00001531 	andeq	r1, r0, r1, lsr r5
    1bfc:	0000004d 	andeq	r0, r0, sp, asr #32
    1c00:	000085a8 	andeq	r8, r0, r8, lsr #11
    1c04:	00000050 	andeq	r0, r0, r0, asr r0
    1c08:	0b399c01 	bleq	e68c14 <__bss_end+0xe5fbd8>
    1c0c:	3e240000 	cdpcc	0, 2, cr0, cr4, cr0, {0}
    1c10:	01000007 	tsteq	r0, r7
    1c14:	004d1945 	subeq	r1, sp, r5, asr #18
    1c18:	91020000 	mrsls	r0, (UNDEF: 2)
    1c1c:	141f246c 	ldrne	r2, [pc], #-1132	; 1c24 <shift+0x1c24>
    1c20:	45010000 	strmi	r0, [r1, #-0]
    1c24:	00011d30 	andeq	r1, r1, r0, lsr sp
    1c28:	68910200 	ldmvs	r1, {r9}
    1c2c:	00148624 	andseq	r8, r4, r4, lsr #12
    1c30:	41450100 	mrsmi	r0, (UNDEF: 85)
    1c34:	00000858 	andeq	r0, r0, r8, asr r8
    1c38:	22649102 	rsbcs	r9, r4, #-2147483648	; 0x80000000
    1c3c:	0000157e 	andeq	r1, r0, lr, ror r5
    1c40:	4d0e4701 	stcmi	7, cr4, [lr, #-4]
    1c44:	02000000 	andeq	r0, r0, #0
    1c48:	27007491 			; <UNDEFINED> instruction: 0x27007491
    1c4c:	000012df 	ldrdeq	r1, [r0], -pc	; <UNPREDICTABLE>
    1c50:	29063f01 	stmdbcs	r6, {r0, r8, r9, sl, fp, ip, sp}
    1c54:	7c000014 	stcvc	0, cr0, [r0], {20}
    1c58:	2c000085 	stccs	0, cr0, [r0], {133}	; 0x85
    1c5c:	01000000 	mrseq	r0, (UNDEF: 0)
    1c60:	000b639c 	muleq	fp, ip, r3
    1c64:	073e2400 	ldreq	r2, [lr, -r0, lsl #8]!
    1c68:	3f010000 	svccc	0x00010000
    1c6c:	00004d15 	andeq	r4, r0, r5, lsl sp
    1c70:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1c74:	14be2500 	ldrtne	r2, [lr], #1280	; 0x500
    1c78:	32010000 	andcc	r0, r1, #0
    1c7c:	00148c0a 	andseq	r8, r4, sl, lsl #24
    1c80:	00004d00 	andeq	r4, r0, r0, lsl #26
    1c84:	00852c00 	addeq	r2, r5, r0, lsl #24
    1c88:	00005000 	andeq	r5, r0, r0
    1c8c:	be9c0100 	fmllte	f0, f4, f0
    1c90:	2400000b 	strcs	r0, [r0], #-11
    1c94:	0000073e 	andeq	r0, r0, lr, lsr r7
    1c98:	4d193201 	lfmmi	f3, 4, [r9, #-4]
    1c9c:	02000000 	andeq	r0, r0, #0
    1ca0:	6b246c91 	blvs	91ceec <__bss_end+0x913eb0>
    1ca4:	01000015 	tsteq	r0, r5, lsl r0
    1ca8:	037b2b32 	cmneq	fp, #51200	; 0xc800
    1cac:	91020000 	mrsls	r0, (UNDEF: 2)
    1cb0:	14b92468 	ldrtne	r2, [r9], #1128	; 0x468
    1cb4:	32010000 	andcc	r0, r1, #0
    1cb8:	00004d3c 	andeq	r4, r0, ip, lsr sp
    1cbc:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1cc0:	00152022 	andseq	r2, r5, r2, lsr #32
    1cc4:	0e340100 	rsfeqs	f0, f4, f0
    1cc8:	0000004d 	andeq	r0, r0, sp, asr #32
    1ccc:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1cd0:	0015a825 	andseq	sl, r5, r5, lsr #16
    1cd4:	0a250100 	beq	9420dc <__bss_end+0x9390a0>
    1cd8:	00001572 	andeq	r1, r0, r2, ror r5
    1cdc:	0000004d 	andeq	r0, r0, sp, asr #32
    1ce0:	000084dc 	ldrdeq	r8, [r0], -ip
    1ce4:	00000050 	andeq	r0, r0, r0, asr r0
    1ce8:	0c199c01 	ldceq	12, cr9, [r9], {1}
    1cec:	3e240000 	cdpcc	0, 2, cr0, cr4, cr0, {0}
    1cf0:	01000007 	tsteq	r0, r7
    1cf4:	004d1825 	subeq	r1, sp, r5, lsr #16
    1cf8:	91020000 	mrsls	r0, (UNDEF: 2)
    1cfc:	156b246c 	strbne	r2, [fp, #-1132]!	; 0xfffffb94
    1d00:	25010000 	strcs	r0, [r1, #-0]
    1d04:	000c1f2a 	andeq	r1, ip, sl, lsr #30
    1d08:	68910200 	ldmvs	r1, {r9}
    1d0c:	0014b924 	andseq	fp, r4, r4, lsr #18
    1d10:	3b250100 	blcc	942118 <__bss_end+0x9390dc>
    1d14:	0000004d 	andeq	r0, r0, sp, asr #32
    1d18:	22649102 	rsbcs	r9, r4, #-2147483648	; 0x80000000
    1d1c:	000012fe 	strdeq	r1, [r0], -lr
    1d20:	4d0e2701 	stcmi	7, cr2, [lr, #-4]
    1d24:	02000000 	andeq	r0, r0, #0
    1d28:	18007491 	stmdane	r0, {r0, r4, r7, sl, ip, sp, lr}
    1d2c:	00002504 	andeq	r2, r0, r4, lsl #10
    1d30:	0c190300 	ldceq	3, cr0, [r9], {-0}
    1d34:	51250000 			; <UNDEFINED> instruction: 0x51250000
    1d38:	01000014 	tsteq	r0, r4, lsl r0
    1d3c:	15b40a19 	ldrne	r0, [r4, #2585]!	; 0xa19
    1d40:	004d0000 	subeq	r0, sp, r0
    1d44:	84980000 	ldrhi	r0, [r8], #0
    1d48:	00440000 	subeq	r0, r4, r0
    1d4c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1d50:	00000c70 	andeq	r0, r0, r0, ror ip
    1d54:	00159f24 	andseq	r9, r5, r4, lsr #30
    1d58:	1b190100 	blne	642160 <__bss_end+0x639124>
    1d5c:	0000037b 	andeq	r0, r0, fp, ror r3
    1d60:	246c9102 	strbtcs	r9, [ip], #-258	; 0xfffffefe
    1d64:	00001566 	andeq	r1, r0, r6, ror #10
    1d68:	c6351901 	ldrtgt	r1, [r5], -r1, lsl #18
    1d6c:	02000001 	andeq	r0, r0, #1
    1d70:	3e226891 	mcrcc	8, 1, r6, cr2, cr1, {4}
    1d74:	01000007 	tsteq	r0, r7
    1d78:	004d0e1b 	subeq	r0, sp, fp, lsl lr
    1d7c:	91020000 	mrsls	r0, (UNDEF: 2)
    1d80:	ae280074 	mcrge	0, 1, r0, cr8, cr4, {3}
    1d84:	01000013 	tsteq	r0, r3, lsl r0
    1d88:	13040614 	movwne	r0, #17940	; 0x4614
    1d8c:	847c0000 	ldrbthi	r0, [ip], #-0
    1d90:	001c0000 	andseq	r0, ip, r0
    1d94:	9c010000 	stcls	0, cr0, [r1], {-0}
    1d98:	00155c27 	andseq	r5, r5, r7, lsr #24
    1d9c:	060e0100 	streq	r0, [lr], -r0, lsl #2
    1da0:	0000133d 	andeq	r1, r0, sp, lsr r3
    1da4:	00008450 	andeq	r8, r0, r0, asr r4
    1da8:	0000002c 	andeq	r0, r0, ip, lsr #32
    1dac:	0cb09c01 	ldceq	12, cr9, [r0], #4
    1db0:	87240000 	strhi	r0, [r4, -r0]!
    1db4:	01000013 	tsteq	r0, r3, lsl r0
    1db8:	0038140e 	eorseq	r1, r8, lr, lsl #8
    1dbc:	91020000 	mrsls	r0, (UNDEF: 2)
    1dc0:	ad290074 	stcge	0, cr0, [r9, #-464]!	; 0xfffffe30
    1dc4:	01000015 	tsteq	r0, r5, lsl r0
    1dc8:	14330a04 	ldrtne	r0, [r3], #-2564	; 0xfffff5fc
    1dcc:	004d0000 	subeq	r0, sp, r0
    1dd0:	84240000 	strthi	r0, [r4], #-0
    1dd4:	002c0000 	eoreq	r0, ip, r0
    1dd8:	9c010000 	stcls	0, cr0, [r1], {-0}
    1ddc:	64697026 	strbtvs	r7, [r9], #-38	; 0xffffffda
    1de0:	0e060100 	adfeqs	f0, f6, f0
    1de4:	0000004d 	andeq	r0, r0, sp, asr #32
    1de8:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1dec:	00032e00 	andeq	r2, r3, r0, lsl #28
    1df0:	24000400 	strcs	r0, [r0], #-1024	; 0xfffffc00
    1df4:	04000007 	streq	r0, [r0], #-7
    1df8:	0015d001 	andseq	sp, r5, r1
    1dfc:	16d20400 	ldrbne	r0, [r2], r0, lsl #8
    1e00:	13f90000 	mvnsne	r0, #0
    1e04:	88800000 	stmhi	r0, {}	; <UNPREDICTABLE>
    1e08:	04b80000 	ldrteq	r0, [r8], #0
    1e0c:	06fa0000 	ldrbteq	r0, [sl], r0
    1e10:	49020000 	stmdbmi	r2, {}	; <UNPREDICTABLE>
    1e14:	03000000 	movweq	r0, #0
    1e18:	0000170b 	andeq	r1, r0, fp, lsl #14
    1e1c:	61100501 	tstvs	r0, r1, lsl #10
    1e20:	11000000 	mrsne	r0, (UNDEF: 0)
    1e24:	33323130 	teqcc	r2, #48, 2
    1e28:	37363534 			; <UNDEFINED> instruction: 0x37363534
    1e2c:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    1e30:	46454443 	strbmi	r4, [r5], -r3, asr #8
    1e34:	01040000 	mrseq	r0, (UNDEF: 4)
    1e38:	00250103 	eoreq	r0, r5, r3, lsl #2
    1e3c:	74050000 	strvc	r0, [r5], #-0
    1e40:	61000000 	mrsvs	r0, (UNDEF: 0)
    1e44:	06000000 	streq	r0, [r0], -r0
    1e48:	00000066 	andeq	r0, r0, r6, rrx
    1e4c:	51070010 	tstpl	r7, r0, lsl r0
    1e50:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    1e54:	1cd70704 	ldclne	7, cr0, [r7], {4}
    1e58:	01080000 	mrseq	r0, (UNDEF: 8)
    1e5c:	00103508 	andseq	r3, r0, r8, lsl #10
    1e60:	006d0700 	rsbeq	r0, sp, r0, lsl #14
    1e64:	2a090000 	bcs	241e6c <__bss_end+0x238e30>
    1e68:	0a000000 	beq	1e70 <shift+0x1e70>
    1e6c:	0000173a 	andeq	r1, r0, sl, lsr r7
    1e70:	25066401 	strcs	r6, [r6, #-1025]	; 0xfffffbff
    1e74:	b8000017 	stmdalt	r0, {r0, r1, r2, r4}
    1e78:	8000008c 	andhi	r0, r0, ip, lsl #1
    1e7c:	01000000 	mrseq	r0, (UNDEF: 0)
    1e80:	0000fb9c 	muleq	r0, ip, fp
    1e84:	72730b00 	rsbsvc	r0, r3, #0, 22
    1e88:	64010063 	strvs	r0, [r1], #-99	; 0xffffff9d
    1e8c:	0000fb19 	andeq	pc, r0, r9, lsl fp	; <UNPREDICTABLE>
    1e90:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1e94:	7473640b 	ldrbtvc	r6, [r3], #-1035	; 0xfffffbf5
    1e98:	24640100 	strbtcs	r0, [r4], #-256	; 0xffffff00
    1e9c:	00000102 	andeq	r0, r0, r2, lsl #2
    1ea0:	0b609102 	bleq	18262b0 <__bss_end+0x181d274>
    1ea4:	006d756e 	rsbeq	r7, sp, lr, ror #10
    1ea8:	042d6401 	strteq	r6, [sp], #-1025	; 0xfffffbff
    1eac:	02000001 	andeq	r0, r0, #1
    1eb0:	940c5c91 	strls	r5, [ip], #-3217	; 0xfffff36f
    1eb4:	01000017 	tsteq	r0, r7, lsl r0
    1eb8:	010b0e66 	tsteq	fp, r6, ror #28
    1ebc:	91020000 	mrsls	r0, (UNDEF: 2)
    1ec0:	17170c70 			; <UNDEFINED> instruction: 0x17170c70
    1ec4:	67010000 	strvs	r0, [r1, -r0]
    1ec8:	00011108 	andeq	r1, r1, r8, lsl #2
    1ecc:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1ed0:	008ce00d 	addeq	lr, ip, sp
    1ed4:	00004800 	andeq	r4, r0, r0, lsl #16
    1ed8:	00690e00 	rsbeq	r0, r9, r0, lsl #28
    1edc:	040b6901 	streq	r6, [fp], #-2305	; 0xfffff6ff
    1ee0:	02000001 	andeq	r0, r0, #1
    1ee4:	00007491 	muleq	r0, r1, r4
    1ee8:	0101040f 	tsteq	r1, pc, lsl #8
    1eec:	11100000 	tstne	r0, r0
    1ef0:	05041204 	streq	r1, [r4, #-516]	; 0xfffffdfc
    1ef4:	00746e69 	rsbseq	r6, r4, r9, ror #28
    1ef8:	0074040f 	rsbseq	r0, r4, pc, lsl #8
    1efc:	040f0000 	streq	r0, [pc], #-0	; 1f04 <shift+0x1f04>
    1f00:	0000006d 	andeq	r0, r0, sp, rrx
    1f04:	0016ae0a 	andseq	sl, r6, sl, lsl #28
    1f08:	065c0100 	ldrbeq	r0, [ip], -r0, lsl #2
    1f0c:	000016bb 			; <UNDEFINED> instruction: 0x000016bb
    1f10:	00008c50 	andeq	r8, r0, r0, asr ip
    1f14:	00000068 	andeq	r0, r0, r8, rrx
    1f18:	01769c01 	cmneq	r6, r1, lsl #24
    1f1c:	8d130000 	ldchi	0, cr0, [r3, #-0]
    1f20:	01000017 	tsteq	r0, r7, lsl r0
    1f24:	0102125c 	tsteq	r2, ip, asr r2
    1f28:	91020000 	mrsls	r0, (UNDEF: 2)
    1f2c:	16b4136c 	ldrtne	r1, [r4], ip, ror #6
    1f30:	5c010000 	stcpl	0, cr0, [r1], {-0}
    1f34:	0001041e 	andeq	r0, r1, lr, lsl r4
    1f38:	68910200 	ldmvs	r1, {r9}
    1f3c:	6d656d0e 	stclvs	13, cr6, [r5, #-56]!	; 0xffffffc8
    1f40:	085e0100 	ldmdaeq	lr, {r8}^
    1f44:	00000111 	andeq	r0, r0, r1, lsl r1
    1f48:	0d709102 	ldfeqp	f1, [r0, #-8]!
    1f4c:	00008c6c 	andeq	r8, r0, ip, ror #24
    1f50:	0000003c 	andeq	r0, r0, ip, lsr r0
    1f54:	0100690e 	tsteq	r0, lr, lsl #18
    1f58:	01040b60 	tsteq	r4, r0, ror #22
    1f5c:	91020000 	mrsls	r0, (UNDEF: 2)
    1f60:	14000074 	strne	r0, [r0], #-116	; 0xffffff8c
    1f64:	00001741 	andeq	r1, r0, r1, asr #14
    1f68:	5a055201 	bpl	156774 <__bss_end+0x14d738>
    1f6c:	04000017 	streq	r0, [r0], #-23	; 0xffffffe9
    1f70:	fc000001 	stc2	0, cr0, [r0], {1}
    1f74:	5400008b 	strpl	r0, [r0], #-139	; 0xffffff75
    1f78:	01000000 	mrseq	r0, (UNDEF: 0)
    1f7c:	0001af9c 	muleq	r1, ip, pc	; <UNPREDICTABLE>
    1f80:	00730b00 	rsbseq	r0, r3, r0, lsl #22
    1f84:	0b185201 	bleq	616790 <__bss_end+0x60d754>
    1f88:	02000001 	andeq	r0, r0, #1
    1f8c:	690e6c91 	stmdbvs	lr, {r0, r4, r7, sl, fp, sp, lr}
    1f90:	06540100 	ldrbeq	r0, [r4], -r0, lsl #2
    1f94:	00000104 	andeq	r0, r0, r4, lsl #2
    1f98:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1f9c:	00177d14 	andseq	r7, r7, r4, lsl sp
    1fa0:	05420100 	strbeq	r0, [r2, #-256]	; 0xffffff00
    1fa4:	00001748 	andeq	r1, r0, r8, asr #14
    1fa8:	00000104 	andeq	r0, r0, r4, lsl #2
    1fac:	00008b50 	andeq	r8, r0, r0, asr fp
    1fb0:	000000ac 	andeq	r0, r0, ip, lsr #1
    1fb4:	02159c01 	andseq	r9, r5, #256	; 0x100
    1fb8:	730b0000 	movwvc	r0, #45056	; 0xb000
    1fbc:	42010031 	andmi	r0, r1, #49	; 0x31
    1fc0:	00010b19 	andeq	r0, r1, r9, lsl fp
    1fc4:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1fc8:	0032730b 	eorseq	r7, r2, fp, lsl #6
    1fcc:	0b294201 	bleq	a527d8 <__bss_end+0xa4979c>
    1fd0:	02000001 	andeq	r0, r0, #1
    1fd4:	6e0b6891 	mcrvs	8, 0, r6, cr11, cr1, {4}
    1fd8:	01006d75 	tsteq	r0, r5, ror sp
    1fdc:	01043142 	tsteq	r4, r2, asr #2
    1fe0:	91020000 	mrsls	r0, (UNDEF: 2)
    1fe4:	31750e64 	cmncc	r5, r4, ror #28
    1fe8:	10440100 	subne	r0, r4, r0, lsl #2
    1fec:	00000215 	andeq	r0, r0, r5, lsl r2
    1ff0:	0e779102 	expeqs	f1, f2
    1ff4:	01003275 	tsteq	r0, r5, ror r2
    1ff8:	02151444 	andseq	r1, r5, #68, 8	; 0x44000000
    1ffc:	91020000 	mrsls	r0, (UNDEF: 2)
    2000:	01080076 	tsteq	r8, r6, ror r0
    2004:	00102c08 	andseq	r2, r0, r8, lsl #24
    2008:	17851400 	strne	r1, [r5, r0, lsl #8]
    200c:	36010000 	strcc	r0, [r1], -r0
    2010:	00176c07 	andseq	r6, r7, r7, lsl #24
    2014:	00011100 	andeq	r1, r1, r0, lsl #2
    2018:	008a9000 	addeq	r9, sl, r0
    201c:	0000c000 	andeq	ip, r0, r0
    2020:	759c0100 	ldrvc	r0, [ip, #256]	; 0x100
    2024:	13000002 	movwne	r0, #2
    2028:	000016a9 	andeq	r1, r0, r9, lsr #13
    202c:	11153601 	tstne	r5, r1, lsl #12
    2030:	02000001 	andeq	r0, r0, #1
    2034:	730b6c91 	movwvc	r6, #48273	; 0xbc91
    2038:	01006372 	tsteq	r0, r2, ror r3
    203c:	010b2736 	tsteq	fp, r6, lsr r7
    2040:	91020000 	mrsls	r0, (UNDEF: 2)
    2044:	756e0b68 	strbvc	r0, [lr, #-2920]!	; 0xfffff498
    2048:	3601006d 	strcc	r0, [r1], -sp, rrx
    204c:	00010430 	andeq	r0, r1, r0, lsr r4
    2050:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    2054:	0100690e 	tsteq	r0, lr, lsl #18
    2058:	01040638 	tsteq	r4, r8, lsr r6
    205c:	91020000 	mrsls	r0, (UNDEF: 2)
    2060:	67140074 			; <UNDEFINED> instruction: 0x67140074
    2064:	01000017 	tsteq	r0, r7, lsl r0
    2068:	16c70524 	strbne	r0, [r7], r4, lsr #10
    206c:	01040000 	mrseq	r0, (UNDEF: 4)
    2070:	89f40000 	ldmibhi	r4!, {}^	; <UNPREDICTABLE>
    2074:	009c0000 	addseq	r0, ip, r0
    2078:	9c010000 	stcls	0, cr0, [r1], {-0}
    207c:	000002b2 			; <UNDEFINED> instruction: 0x000002b2
    2080:	0016a313 	andseq	sl, r6, r3, lsl r3
    2084:	16240100 	strtne	r0, [r4], -r0, lsl #2
    2088:	0000010b 	andeq	r0, r0, fp, lsl #2
    208c:	0c6c9102 	stfeqp	f1, [ip], #-8
    2090:	0000171e 	andeq	r1, r0, lr, lsl r7
    2094:	04062601 	streq	r2, [r6], #-1537	; 0xfffff9ff
    2098:	02000001 	andeq	r0, r0, #1
    209c:	15007491 	strne	r7, [r0, #-1169]	; 0xfffffb6f
    20a0:	0000179b 	muleq	r0, fp, r7
    20a4:	a0060801 	andge	r0, r6, r1, lsl #16
    20a8:	80000017 	andhi	r0, r0, r7, lsl r0
    20ac:	74000088 	strvc	r0, [r0], #-136	; 0xffffff78
    20b0:	01000001 	tsteq	r0, r1
    20b4:	16a3139c 	ssatne	r1, #4, ip, lsl #7
    20b8:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    20bc:	00006618 	andeq	r6, r0, r8, lsl r6
    20c0:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    20c4:	00171e13 	andseq	r1, r7, r3, lsl lr
    20c8:	25080100 	strcs	r0, [r8, #-256]	; 0xffffff00
    20cc:	00000111 	andeq	r0, r0, r1, lsl r1
    20d0:	13609102 	cmnne	r0, #-2147483648	; 0x80000000
    20d4:	00001735 	andeq	r1, r0, r5, lsr r7
    20d8:	663a0801 	ldrtvs	r0, [sl], -r1, lsl #16
    20dc:	02000000 	andeq	r0, r0, #0
    20e0:	690e5c91 	stmdbvs	lr, {r0, r4, r7, sl, fp, ip, lr}
    20e4:	060a0100 	streq	r0, [sl], -r0, lsl #2
    20e8:	00000104 	andeq	r0, r0, r4, lsl #2
    20ec:	0d749102 	ldfeqp	f1, [r4, #-8]!
    20f0:	0000894c 	andeq	r8, r0, ip, asr #18
    20f4:	00000098 	muleq	r0, r8, r0
    20f8:	01006a0e 	tsteq	r0, lr, lsl #20
    20fc:	01040b1c 	tsteq	r4, ip, lsl fp
    2100:	91020000 	mrsls	r0, (UNDEF: 2)
    2104:	89740d70 	ldmdbhi	r4!, {r4, r5, r6, r8, sl, fp}^
    2108:	00600000 	rsbeq	r0, r0, r0
    210c:	630e0000 	movwvs	r0, #57344	; 0xe000
    2110:	081e0100 	ldmdaeq	lr, {r8}
    2114:	0000006d 	andeq	r0, r0, sp, rrx
    2118:	006f9102 	rsbeq	r9, pc, r2, lsl #2
    211c:	22000000 	andcs	r0, r0, #0
    2120:	02000000 	andeq	r0, r0, #0
    2124:	00084b00 	andeq	r4, r8, r0, lsl #22
    2128:	74010400 	strvc	r0, [r1], #-1024	; 0xfffffc00
    212c:	38000009 	stmdacc	r0, {r0, r3}
    2130:	4400008d 	strmi	r0, [r0], #-141	; 0xffffff73
    2134:	ac00008f 	stcge	0, cr0, [r0], {143}	; 0x8f
    2138:	dc000017 	stcle	0, cr0, [r0], {23}
    213c:	61000017 	tstvs	r0, r7, lsl r0
    2140:	01000000 	mrseq	r0, (UNDEF: 0)
    2144:	00002280 	andeq	r2, r0, r0, lsl #5
    2148:	5f000200 	svcpl	0x00000200
    214c:	04000008 	streq	r0, [r0], #-8
    2150:	0009f101 	andeq	pc, r9, r1, lsl #2
    2154:	008f4400 	addeq	r4, pc, r0, lsl #8
    2158:	008f4800 	addeq	r4, pc, r0, lsl #16
    215c:	0017ac00 	andseq	sl, r7, r0, lsl #24
    2160:	0017dc00 	andseq	sp, r7, r0, lsl #24
    2164:	00006100 	andeq	r6, r0, r0, lsl #2
    2168:	32800100 	addcc	r0, r0, #0, 2
    216c:	04000009 	streq	r0, [r0], #-9
    2170:	00087300 	andeq	r7, r8, r0, lsl #6
    2174:	aa010400 	bge	4317c <__bss_end+0x3a140>
    2178:	0c00001b 	stceq	0, cr0, [r0], {27}
    217c:	00001b01 	andeq	r1, r0, r1, lsl #22
    2180:	000017dc 	ldrdeq	r1, [r0], -ip
    2184:	00000a51 	andeq	r0, r0, r1, asr sl
    2188:	69050402 	stmdbvs	r5, {r1, sl}
    218c:	0300746e 	movweq	r7, #1134	; 0x46e
    2190:	1cd70704 	ldclne	7, cr0, [r7], {4}
    2194:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    2198:	00035705 	andeq	r5, r3, r5, lsl #14
    219c:	04080300 	streq	r0, [r8], #-768	; 0xfffffd00
    21a0:	000023a9 	andeq	r2, r0, r9, lsr #7
    21a4:	001b5c04 	andseq	r5, fp, r4, lsl #24
    21a8:	162a0100 	strtne	r0, [sl], -r0, lsl #2
    21ac:	00000024 	andeq	r0, r0, r4, lsr #32
    21b0:	001fcb04 	andseq	ip, pc, r4, lsl #22
    21b4:	152f0100 	strne	r0, [pc, #-256]!	; 20bc <shift+0x20bc>
    21b8:	00000051 	andeq	r0, r0, r1, asr r0
    21bc:	00570405 	subseq	r0, r7, r5, lsl #8
    21c0:	39060000 	stmdbcc	r6, {}	; <UNPREDICTABLE>
    21c4:	66000000 	strvs	r0, [r0], -r0
    21c8:	07000000 	streq	r0, [r0, -r0]
    21cc:	00000066 	andeq	r0, r0, r6, rrx
    21d0:	6c040500 	cfstr32vs	mvfx0, [r4], {-0}
    21d4:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    21d8:	0026fd04 	eoreq	pc, r6, r4, lsl #26
    21dc:	0f360100 	svceq	0x00360100
    21e0:	00000079 	andeq	r0, r0, r9, ror r0
    21e4:	007f0405 	rsbseq	r0, pc, r5, lsl #8
    21e8:	1d060000 	stcne	0, cr0, [r6, #-0]
    21ec:	93000000 	movwls	r0, #0
    21f0:	07000000 	streq	r0, [r0, -r0]
    21f4:	00000066 	andeq	r0, r0, r6, rrx
    21f8:	00006607 	andeq	r6, r0, r7, lsl #12
    21fc:	01030000 	mrseq	r0, (UNDEF: 3)
    2200:	00102c08 	andseq	r2, r0, r8, lsl #24
    2204:	22030900 	andcs	r0, r3, #0, 18
    2208:	bb010000 	bllt	42210 <__bss_end+0x391d4>
    220c:	00004512 	andeq	r4, r0, r2, lsl r5
    2210:	272b0900 	strcs	r0, [fp, -r0, lsl #18]!
    2214:	be010000 	cdplt	0, 0, cr0, cr1, cr0, {0}
    2218:	00006d10 	andeq	r6, r0, r0, lsl sp
    221c:	06010300 	streq	r0, [r1], -r0, lsl #6
    2220:	0000102e 	andeq	r1, r0, lr, lsr #32
    2224:	001eeb0a 	andseq	lr, lr, sl, lsl #22
    2228:	93010700 	movwls	r0, #5888	; 0x1700
    222c:	02000000 	andeq	r0, r0, #0
    2230:	01e60617 	mvneq	r0, r7, lsl r6
    2234:	ba0b0000 	blt	2c223c <__bss_end+0x2b9200>
    2238:	00000019 	andeq	r0, r0, r9, lsl r0
    223c:	001e080b 	andseq	r0, lr, fp, lsl #16
    2240:	ce0b0100 	adfgte	f0, f3, f0
    2244:	02000022 	andeq	r0, r0, #34	; 0x22
    2248:	00263f0b 	eoreq	r3, r6, fp, lsl #30
    224c:	720b0300 	andvc	r0, fp, #0, 6
    2250:	04000022 	streq	r0, [r0], #-34	; 0xffffffde
    2254:	0025480b 	eoreq	r4, r5, fp, lsl #16
    2258:	ac0b0500 	cfstr32ge	mvfx0, [fp], {-0}
    225c:	06000024 	streq	r0, [r0], -r4, lsr #32
    2260:	0019db0b 	andseq	sp, r9, fp, lsl #22
    2264:	5d0b0700 	stcpl	7, cr0, [fp, #-0]
    2268:	08000025 	stmdaeq	r0, {r0, r2, r5}
    226c:	00256b0b 	eoreq	r6, r5, fp, lsl #22
    2270:	320b0900 	andcc	r0, fp, #0, 18
    2274:	0a000026 	beq	2314 <shift+0x2314>
    2278:	0021c90b 	eoreq	ip, r1, fp, lsl #18
    227c:	9d0b0b00 	vstrls	d0, [fp, #-0]
    2280:	0c00001b 	stceq	0, cr0, [r0], {27}
    2284:	001c7a0b 	andseq	r7, ip, fp, lsl #20
    2288:	2f0b0d00 	svccs	0x000b0d00
    228c:	0e00001f 	mcreq	0, 0, r0, cr0, cr15, {0}
    2290:	001f450b 	andseq	r4, pc, fp, lsl #10
    2294:	420b0f00 	andmi	r0, fp, #0, 30
    2298:	1000001e 	andne	r0, r0, lr, lsl r0
    229c:	0022560b 	eoreq	r5, r2, fp, lsl #12
    22a0:	ae0b1100 	adfgee	f1, f3, f0
    22a4:	1200001e 	andne	r0, r0, #30
    22a8:	0028c40b 	eoreq	ip, r8, fp, lsl #8
    22ac:	440b1300 	strmi	r1, [fp], #-768	; 0xfffffd00
    22b0:	1400001a 	strne	r0, [r0], #-26	; 0xffffffe6
    22b4:	001ed20b 	andseq	sp, lr, fp, lsl #4
    22b8:	810b1500 	tsthi	fp, r0, lsl #10
    22bc:	16000019 			; <UNDEFINED> instruction: 0x16000019
    22c0:	0026620b 	eoreq	r6, r6, fp, lsl #4
    22c4:	840b1700 	strhi	r1, [fp], #-1792	; 0xfffff900
    22c8:	18000027 	stmdane	r0, {r0, r1, r2, r5}
    22cc:	001ef70b 	andseq	pc, lr, fp, lsl #14
    22d0:	400b1900 	andmi	r1, fp, r0, lsl #18
    22d4:	1a000023 	bne	2368 <shift+0x2368>
    22d8:	0026700b 	eoreq	r7, r6, fp
    22dc:	b00b1b00 	andlt	r1, fp, r0, lsl #22
    22e0:	1c000018 	stcne	0, cr0, [r0], {24}
    22e4:	00267e0b 	eoreq	r7, r6, fp, lsl #28
    22e8:	8c0b1d00 	stchi	13, cr1, [fp], {-0}
    22ec:	1e000026 	cdpne	0, 0, cr0, cr0, cr6, {1}
    22f0:	00185e0b 	andseq	r5, r8, fp, lsl #28
    22f4:	b60b1f00 	strlt	r1, [fp], -r0, lsl #30
    22f8:	20000026 	andcs	r0, r0, r6, lsr #32
    22fc:	0023ed0b 	eoreq	lr, r3, fp, lsl #26
    2300:	280b2100 	stmdacs	fp, {r8, sp}
    2304:	22000022 	andcs	r0, r0, #34	; 0x22
    2308:	0026550b 	eoreq	r5, r6, fp, lsl #10
    230c:	2c0b2300 	stccs	3, cr2, [fp], {-0}
    2310:	24000021 	strcs	r0, [r0], #-33	; 0xffffffdf
    2314:	00202e0b 	eoreq	r2, r0, fp, lsl #28
    2318:	480b2500 	stmdami	fp, {r8, sl, sp}
    231c:	2600001d 			; <UNDEFINED> instruction: 0x2600001d
    2320:	00204c0b 	eoreq	r4, r0, fp, lsl #24
    2324:	e40b2700 	str	r2, [fp], #-1792	; 0xfffff900
    2328:	2800001d 	stmdacs	r0, {r0, r2, r3, r4}
    232c:	00205c0b 	eoreq	r5, r0, fp, lsl #24
    2330:	6c0b2900 			; <UNDEFINED> instruction: 0x6c0b2900
    2334:	2a000020 	bcs	23bc <shift+0x23bc>
    2338:	0021af0b 	eoreq	sl, r1, fp, lsl #30
    233c:	d50b2b00 	strle	r2, [fp, #-2816]	; 0xfffff500
    2340:	2c00001f 	stccs	0, cr0, [r0], {31}
    2344:	0023fa0b 	eoreq	pc, r3, fp, lsl #20
    2348:	890b2d00 	stmdbhi	fp, {r8, sl, fp, sp}
    234c:	2e00001d 	mcrcs	0, 0, r0, cr0, cr13, {0}
    2350:	1f670a00 	svcne	0x00670a00
    2354:	01070000 	mrseq	r0, (UNDEF: 7)
    2358:	00000093 	muleq	r0, r3, r0
    235c:	c7061703 	strgt	r1, [r6, -r3, lsl #14]
    2360:	0b000003 	bleq	2374 <shift+0x2374>
    2364:	00001c9c 	muleq	r0, ip, ip
    2368:	18ee0b00 	stmiane	lr!, {r8, r9, fp}^
    236c:	0b010000 	bleq	42374 <__bss_end+0x39338>
    2370:	00002872 	andeq	r2, r0, r2, ror r8
    2374:	27050b02 	strcs	r0, [r5, -r2, lsl #22]
    2378:	0b030000 	bleq	c2380 <__bss_end+0xb9344>
    237c:	00001cbc 			; <UNDEFINED> instruction: 0x00001cbc
    2380:	19a60b04 	stmibne	r6!, {r2, r8, r9, fp}
    2384:	0b050000 	bleq	14238c <__bss_end+0x139350>
    2388:	00001d65 	andeq	r1, r0, r5, ror #26
    238c:	1cac0b06 	vstmiane	ip!, {d0-d2}
    2390:	0b070000 	bleq	1c2398 <__bss_end+0x1b935c>
    2394:	00002599 	muleq	r0, r9, r5
    2398:	26ea0b08 	strbtcs	r0, [sl], r8, lsl #22
    239c:	0b090000 	bleq	2423a4 <__bss_end+0x239368>
    23a0:	000024d0 	ldrdeq	r2, [r0], -r0
    23a4:	19f90b0a 	ldmibne	r9!, {r1, r3, r8, r9, fp}^
    23a8:	0b0b0000 	bleq	2c23b0 <__bss_end+0x2b9374>
    23ac:	00001d06 	andeq	r1, r0, r6, lsl #26
    23b0:	196f0b0c 	stmdbne	pc!, {r2, r3, r8, r9, fp}^	; <UNPREDICTABLE>
    23b4:	0b0d0000 	bleq	3423bc <__bss_end+0x339380>
    23b8:	000028a7 	andeq	r2, r0, r7, lsr #17
    23bc:	219c0b0e 	orrscs	r0, ip, lr, lsl #22
    23c0:	0b0f0000 	bleq	3c23c8 <__bss_end+0x3b938c>
    23c4:	00001e79 	andeq	r1, r0, r9, ror lr
    23c8:	21d90b10 	bicscs	r0, r9, r0, lsl fp
    23cc:	0b110000 	bleq	4423d4 <__bss_end+0x439398>
    23d0:	000027c6 	andeq	r2, r0, r6, asr #15
    23d4:	1abc0b12 	bne	fef05024 <__bss_end+0xfeefbfe8>
    23d8:	0b130000 	bleq	4c23e0 <__bss_end+0x4b93a4>
    23dc:	00001e8c 	andeq	r1, r0, ip, lsl #29
    23e0:	20ef0b14 	rsccs	r0, pc, r4, lsl fp	; <UNPREDICTABLE>
    23e4:	0b150000 	bleq	5423ec <__bss_end+0x5393b0>
    23e8:	00001c87 	andeq	r1, r0, r7, lsl #25
    23ec:	213b0b16 	teqcs	fp, r6, lsl fp
    23f0:	0b170000 	bleq	5c23f8 <__bss_end+0x5b93bc>
    23f4:	00001f51 	andeq	r1, r0, r1, asr pc
    23f8:	19c40b18 	stmibne	r4, {r3, r4, r8, r9, fp}^
    23fc:	0b190000 	bleq	642404 <__bss_end+0x6393c8>
    2400:	0000276d 	andeq	r2, r0, sp, ror #14
    2404:	20bb0b1a 	adcscs	r0, fp, sl, lsl fp
    2408:	0b1b0000 	bleq	6c2410 <__bss_end+0x6b93d4>
    240c:	00001e63 	andeq	r1, r0, r3, ror #28
    2410:	18990b1c 	ldmne	r9, {r2, r3, r4, r8, r9, fp}
    2414:	0b1d0000 	bleq	74241c <__bss_end+0x7393e0>
    2418:	00002006 	andeq	r2, r0, r6
    241c:	1ff20b1e 	svcne	0x00f20b1e
    2420:	0b1f0000 	bleq	7c2428 <__bss_end+0x7b93ec>
    2424:	0000248d 	andeq	r2, r0, sp, lsl #9
    2428:	25180b20 	ldrcs	r0, [r8, #-2848]	; 0xfffff4e0
    242c:	0b210000 	bleq	842434 <__bss_end+0x8393f8>
    2430:	0000274c 	andeq	r2, r0, ip, asr #14
    2434:	1d960b22 	vldrne	d0, [r6, #136]	; 0x88
    2438:	0b230000 	bleq	8c2440 <__bss_end+0x8b9404>
    243c:	000022f0 	strdeq	r2, [r0], -r0
    2440:	24e50b24 	strbtcs	r0, [r5], #2852	; 0xb24
    2444:	0b250000 	bleq	94244c <__bss_end+0x939410>
    2448:	00002409 	andeq	r2, r0, r9, lsl #8
    244c:	241d0b26 	ldrcs	r0, [sp], #-2854	; 0xfffff4da
    2450:	0b270000 	bleq	9c2458 <__bss_end+0x9b941c>
    2454:	00002431 	andeq	r2, r0, r1, lsr r4
    2458:	1b470b28 	blne	11c5100 <__bss_end+0x11bc0c4>
    245c:	0b290000 	bleq	a42464 <__bss_end+0xa39428>
    2460:	00001aa7 	andeq	r1, r0, r7, lsr #21
    2464:	1acf0b2a 	bne	ff3c5114 <__bss_end+0xff3bc0d8>
    2468:	0b2b0000 	bleq	ac2470 <__bss_end+0xab9434>
    246c:	000025e2 	andeq	r2, r0, r2, ror #11
    2470:	1b240b2c 	blne	905128 <__bss_end+0x8fc0ec>
    2474:	0b2d0000 	bleq	b4247c <__bss_end+0xb39440>
    2478:	000025f6 	strdeq	r2, [r0], -r6
    247c:	260a0b2e 	strcs	r0, [sl], -lr, lsr #22
    2480:	0b2f0000 	bleq	bc2488 <__bss_end+0xbb944c>
    2484:	0000261e 	andeq	r2, r0, lr, lsl r6
    2488:	1d180b30 	vldrne	d0, [r8, #-192]	; 0xffffff40
    248c:	0b310000 	bleq	c42494 <__bss_end+0xc39458>
    2490:	00001cf2 	strdeq	r1, [r0], -r2
    2494:	201a0b32 	andscs	r0, sl, r2, lsr fp
    2498:	0b330000 	bleq	cc24a0 <__bss_end+0xcb9464>
    249c:	000021ec 	andeq	r2, r0, ip, ror #3
    24a0:	27fb0b34 			; <UNDEFINED> instruction: 0x27fb0b34
    24a4:	0b350000 	bleq	d424ac <__bss_end+0xd39470>
    24a8:	00001841 	andeq	r1, r0, r1, asr #16
    24ac:	1e180b36 	vmovne.s16	r0, d8[0]
    24b0:	0b370000 	bleq	dc24b8 <__bss_end+0xdb947c>
    24b4:	00001e2d 	andeq	r1, r0, sp, lsr #28
    24b8:	207c0b38 	rsbscs	r0, ip, r8, lsr fp
    24bc:	0b390000 	bleq	e424c4 <__bss_end+0xe39488>
    24c0:	000020a6 	andeq	r2, r0, r6, lsr #1
    24c4:	28240b3a 	stmdacs	r4!, {r1, r3, r4, r5, r8, r9, fp}
    24c8:	0b3b0000 	bleq	ec24d0 <__bss_end+0xeb9494>
    24cc:	000022db 	ldrdeq	r2, [r0], -fp
    24d0:	1dbb0b3c 			; <UNDEFINED> instruction: 0x1dbb0b3c
    24d4:	0b3d0000 	bleq	f424dc <__bss_end+0xf394a0>
    24d8:	00001900 	andeq	r1, r0, r0, lsl #18
    24dc:	18be0b3e 	ldmne	lr!, {r1, r2, r3, r4, r5, r8, r9, fp}
    24e0:	0b3f0000 	bleq	fc24e8 <__bss_end+0xfb94ac>
    24e4:	00002238 	andeq	r2, r0, r8, lsr r2
    24e8:	235c0b40 	cmpcs	ip, #64, 22	; 0x10000
    24ec:	0b410000 	bleq	10424f4 <__bss_end+0x10394b8>
    24f0:	0000246f 	andeq	r2, r0, pc, ror #8
    24f4:	20910b42 	addscs	r0, r1, r2, asr #22
    24f8:	0b430000 	bleq	10c2500 <__bss_end+0x10b94c4>
    24fc:	0000285d 	andeq	r2, r0, sp, asr r8
    2500:	23060b44 	movwcs	r0, #27460	; 0x6b44
    2504:	0b450000 	bleq	114250c <__bss_end+0x11394d0>
    2508:	00001aeb 	andeq	r1, r0, fp, ror #21
    250c:	216c0b46 	cmncs	ip, r6, asr #22
    2510:	0b470000 	bleq	11c2518 <__bss_end+0x11b94dc>
    2514:	00001f9f 	muleq	r0, pc, pc	; <UNPREDICTABLE>
    2518:	187d0b48 	ldmdane	sp!, {r3, r6, r8, r9, fp}^
    251c:	0b490000 	bleq	1242524 <__bss_end+0x12394e8>
    2520:	00001991 	muleq	r0, r1, r9
    2524:	1dcf0b4a 	vstrne	d16, [pc, #296]	; 2654 <shift+0x2654>
    2528:	0b4b0000 	bleq	12c2530 <__bss_end+0x12b94f4>
    252c:	000020cd 	andeq	r2, r0, sp, asr #1
    2530:	0203004c 	andeq	r0, r3, #76	; 0x4c
    2534:	0011c607 	andseq	ip, r1, r7, lsl #12
    2538:	03e40c00 	mvneq	r0, #0, 24
    253c:	03d90000 	bicseq	r0, r9, #0
    2540:	000d0000 	andeq	r0, sp, r0
    2544:	0003ce0e 	andeq	ip, r3, lr, lsl #28
    2548:	f0040500 			; <UNDEFINED> instruction: 0xf0040500
    254c:	0e000003 	cdpeq	0, 0, cr0, cr0, cr3, {0}
    2550:	000003de 	ldrdeq	r0, [r0], -lr
    2554:	35080103 	strcc	r0, [r8, #-259]	; 0xfffffefd
    2558:	0e000010 	mcreq	0, 0, r0, cr0, cr0, {0}
    255c:	000003e9 	andeq	r0, r0, r9, ror #7
    2560:	001a350f 	andseq	r3, sl, pc, lsl #10
    2564:	014c0400 	cmpeq	ip, r0, lsl #8
    2568:	0003d91a 	andeq	sp, r3, sl, lsl r9
    256c:	1e530f00 	cdpne	15, 5, cr0, cr3, cr0, {0}
    2570:	82040000 	andhi	r0, r4, #0
    2574:	03d91a01 	bicseq	r1, r9, #4096	; 0x1000
    2578:	e90c0000 	stmdb	ip, {}	; <UNPREDICTABLE>
    257c:	1a000003 	bne	2590 <shift+0x2590>
    2580:	0d000004 	stceq	0, cr0, [r0, #-16]
    2584:	203e0900 	eorscs	r0, lr, r0, lsl #18
    2588:	2d050000 	stccs	0, cr0, [r5, #-0]
    258c:	00040f0d 	andeq	r0, r4, sp, lsl #30
    2590:	26c60900 	strbcs	r0, [r6], r0, lsl #18
    2594:	38050000 	stmdacc	r5, {}	; <UNPREDICTABLE>
    2598:	0001e61c 	andeq	lr, r1, ip, lsl r6
    259c:	1d2c0a00 	vstmdbne	ip!, {s0-s-1}
    25a0:	01070000 	mrseq	r0, (UNDEF: 7)
    25a4:	00000093 	muleq	r0, r3, r0
    25a8:	a50e3a05 	strge	r3, [lr, #-2565]	; 0xfffff5fb
    25ac:	0b000004 	bleq	25c4 <shift+0x25c4>
    25b0:	00001892 	muleq	r0, r2, r8
    25b4:	1f3e0b00 	svcne	0x003e0b00
    25b8:	0b010000 	bleq	425c0 <__bss_end+0x39584>
    25bc:	000027d8 	ldrdeq	r2, [r0], -r8
    25c0:	279b0b02 	ldrcs	r0, [fp, r2, lsl #22]
    25c4:	0b030000 	bleq	c25cc <__bss_end+0xb9590>
    25c8:	00002295 	muleq	r0, r5, r2
    25cc:	25560b04 	ldrbcs	r0, [r6, #-2820]	; 0xfffff4fc
    25d0:	0b050000 	bleq	1425d8 <__bss_end+0x13959c>
    25d4:	00001a78 	andeq	r1, r0, r8, ror sl
    25d8:	1a5a0b06 	bne	16851f8 <__bss_end+0x167c1bc>
    25dc:	0b070000 	bleq	1c25e4 <__bss_end+0x1b95a8>
    25e0:	00001c73 	andeq	r1, r0, r3, ror ip
    25e4:	21510b08 	cmpcs	r1, r8, lsl #22
    25e8:	0b090000 	bleq	2425f0 <__bss_end+0x2395b4>
    25ec:	00001a7f 	andeq	r1, r0, pc, ror sl
    25f0:	21580b0a 	cmpcs	r8, sl, lsl #22
    25f4:	0b0b0000 	bleq	2c25fc <__bss_end+0x2b95c0>
    25f8:	00001ae4 	andeq	r1, r0, r4, ror #21
    25fc:	1a710b0c 	bne	1c45234 <__bss_end+0x1c3c1f8>
    2600:	0b0d0000 	bleq	342608 <__bss_end+0x3395cc>
    2604:	000025ad 	andeq	r2, r0, sp, lsr #11
    2608:	237a0b0e 	cmncs	sl, #14336	; 0x3800
    260c:	000f0000 	andeq	r0, pc, r0
    2610:	0024a504 	eoreq	sl, r4, r4, lsl #10
    2614:	013f0500 	teqeq	pc, r0, lsl #10
    2618:	00000432 	andeq	r0, r0, r2, lsr r4
    261c:	00253909 	eoreq	r3, r5, r9, lsl #18
    2620:	0f410500 	svceq	0x00410500
    2624:	000004a5 	andeq	r0, r0, r5, lsr #9
    2628:	0025c109 	eoreq	ip, r5, r9, lsl #2
    262c:	0c4a0500 	cfstr64eq	mvdx0, [sl], {-0}
    2630:	0000001d 	andeq	r0, r0, sp, lsl r0
    2634:	001a1909 	andseq	r1, sl, r9, lsl #18
    2638:	0c4b0500 	cfstr64eq	mvdx0, [fp], {-0}
    263c:	0000001d 	andeq	r0, r0, sp, lsl r0
    2640:	00269a10 	eoreq	r9, r6, r0, lsl sl
    2644:	25d20900 	ldrbcs	r0, [r2, #2304]	; 0x900
    2648:	4c050000 	stcmi	0, cr0, [r5], {-0}
    264c:	0004e614 	andeq	lr, r4, r4, lsl r6
    2650:	d5040500 	strle	r0, [r4, #-1280]	; 0xfffffb00
    2654:	11000004 	tstne	r0, r4
    2658:	001f0809 	andseq	r0, pc, r9, lsl #16
    265c:	0f4e0500 	svceq	0x004e0500
    2660:	000004f9 	strdeq	r0, [r0], -r9
    2664:	04ec0405 	strbteq	r0, [ip], #1029	; 0x405
    2668:	bb120000 	bllt	482670 <__bss_end+0x479634>
    266c:	09000024 	stmdbeq	r0, {r2, r5}
    2670:	00002282 	andeq	r2, r0, r2, lsl #5
    2674:	100d5205 	andne	r5, sp, r5, lsl #4
    2678:	05000005 	streq	r0, [r0, #-5]
    267c:	0004ff04 	andeq	pc, r4, r4, lsl #30
    2680:	1b901300 	blne	fe407288 <__bss_end+0xfe3fe24c>
    2684:	05340000 	ldreq	r0, [r4, #-0]!
    2688:	41150167 	tstmi	r5, r7, ror #2
    268c:	14000005 	strne	r0, [r0], #-5
    2690:	00002047 	andeq	r2, r0, r7, asr #32
    2694:	0f016905 	svceq	0x00016905
    2698:	000003de 	ldrdeq	r0, [r0], -lr
    269c:	1b741400 	blne	1d076a4 <__bss_end+0x1cfe668>
    26a0:	6a050000 	bvs	1426a8 <__bss_end+0x13966c>
    26a4:	05461401 	strbeq	r1, [r6, #-1025]	; 0xfffffbff
    26a8:	00040000 	andeq	r0, r4, r0
    26ac:	0005160e 	andeq	r1, r5, lr, lsl #12
    26b0:	00b90c00 	adcseq	r0, r9, r0, lsl #24
    26b4:	05560000 	ldrbeq	r0, [r6, #-0]
    26b8:	24150000 	ldrcs	r0, [r5], #-0
    26bc:	2d000000 	stccs	0, cr0, [r0, #-0]
    26c0:	05410c00 	strbeq	r0, [r1, #-3072]	; 0xfffff400
    26c4:	05610000 	strbeq	r0, [r1, #-0]!
    26c8:	000d0000 	andeq	r0, sp, r0
    26cc:	0005560e 	andeq	r5, r5, lr, lsl #12
    26d0:	1f760f00 	svcne	0x00760f00
    26d4:	6b050000 	blvs	1426dc <__bss_end+0x1396a0>
    26d8:	05610301 	strbeq	r0, [r1, #-769]!	; 0xfffffcff
    26dc:	bc0f0000 	stclt	0, cr0, [pc], {-0}
    26e0:	05000021 	streq	r0, [r0, #-33]	; 0xffffffdf
    26e4:	1d0c016e 	stfnes	f0, [ip, #-440]	; 0xfffffe48
    26e8:	16000000 	strne	r0, [r0], -r0
    26ec:	000024f9 	strdeq	r2, [r0], -r9
    26f0:	00930107 	addseq	r0, r3, r7, lsl #2
    26f4:	81050000 	mrshi	r0, (UNDEF: 5)
    26f8:	062a0601 	strteq	r0, [sl], -r1, lsl #12
    26fc:	270b0000 	strcs	r0, [fp, -r0]
    2700:	00000019 	andeq	r0, r0, r9, lsl r0
    2704:	0019330b 	andseq	r3, r9, fp, lsl #6
    2708:	3f0b0200 	svccc	0x000b0200
    270c:	03000019 	movweq	r0, #25
    2710:	001d580b 	andseq	r5, sp, fp, lsl #16
    2714:	4b0b0300 	blmi	2c331c <__bss_end+0x2ba2e0>
    2718:	04000019 	streq	r0, [r0], #-25	; 0xffffffe7
    271c:	001ea10b 	andseq	sl, lr, fp, lsl #2
    2720:	870b0400 	strhi	r0, [fp, -r0, lsl #8]
    2724:	0500001f 	streq	r0, [r0, #-31]	; 0xffffffe1
    2728:	001edd0b 	andseq	sp, lr, fp, lsl #26
    272c:	0a0b0500 	beq	2c3b34 <__bss_end+0x2baaf8>
    2730:	0500001a 	streq	r0, [r0, #-26]	; 0xffffffe6
    2734:	0019570b 	andseq	r5, r9, fp, lsl #14
    2738:	050b0600 	streq	r0, [fp, #-1536]	; 0xfffffa00
    273c:	06000021 	streq	r0, [r0], -r1, lsr #32
    2740:	001b660b 	andseq	r6, fp, fp, lsl #12
    2744:	120b0600 	andne	r0, fp, #0, 12
    2748:	06000021 	streq	r0, [r0], -r1, lsr #32
    274c:	0025790b 	eoreq	r7, r5, fp, lsl #18
    2750:	1f0b0600 	svcne	0x000b0600
    2754:	06000021 	streq	r0, [r0], -r1, lsr #32
    2758:	00215f0b 	eoreq	r5, r1, fp, lsl #30
    275c:	630b0600 	movwvs	r0, #46592	; 0xb600
    2760:	07000019 	smladeq	r0, r9, r0, r0
    2764:	0022650b 	eoreq	r6, r2, fp, lsl #10
    2768:	b20b0700 	andlt	r0, fp, #0, 14
    276c:	07000022 	streq	r0, [r0, -r2, lsr #32]
    2770:	0025b40b 	eoreq	fp, r5, fp, lsl #8
    2774:	390b0700 	stmdbcc	fp, {r8, r9, sl}
    2778:	0700001b 	smladeq	r0, fp, r0, r0
    277c:	0023330b 	eoreq	r3, r3, fp, lsl #6
    2780:	dc0b0800 	stcle	8, cr0, [fp], {-0}
    2784:	08000018 	stmdaeq	r0, {r3, r4}
    2788:	0025870b 	eoreq	r8, r5, fp, lsl #14
    278c:	4f0b0800 	svcmi	0x000b0800
    2790:	08000023 	stmdaeq	r0, {r0, r1, r5}
    2794:	27ed0f00 	strbcs	r0, [sp, r0, lsl #30]!
    2798:	9f050000 	svcls	0x00050000
    279c:	05801f01 	streq	r1, [r0, #3841]	; 0xf01
    27a0:	810f0000 	mrshi	r0, CPSR
    27a4:	05000023 	streq	r0, [r0, #-35]	; 0xffffffdd
    27a8:	1d0c01a2 	stfnes	f0, [ip, #-648]	; 0xfffffd78
    27ac:	0f000000 	svceq	0x00000000
    27b0:	00001f94 	muleq	r0, r4, pc	; <UNPREDICTABLE>
    27b4:	0c01a505 	cfstr32eq	mvfx10, [r1], {5}
    27b8:	0000001d 	andeq	r0, r0, sp, lsl r0
    27bc:	0028b90f 	eoreq	fp, r8, pc, lsl #18
    27c0:	01a80500 			; <UNDEFINED> instruction: 0x01a80500
    27c4:	00001d0c 	andeq	r1, r0, ip, lsl #26
    27c8:	1a290f00 	bne	a463d0 <__bss_end+0xa3d394>
    27cc:	ab050000 	blge	1427d4 <__bss_end+0x139798>
    27d0:	001d0c01 	andseq	r0, sp, r1, lsl #24
    27d4:	8b0f0000 	blhi	3c27dc <__bss_end+0x3b97a0>
    27d8:	05000023 	streq	r0, [r0, #-35]	; 0xffffffdd
    27dc:	1d0c01ae 	stfnes	f0, [ip, #-696]	; 0xfffffd48
    27e0:	0f000000 	svceq	0x00000000
    27e4:	0000229c 	muleq	r0, ip, r2
    27e8:	0c01b105 	stfeqd	f3, [r1], {5}
    27ec:	0000001d 	andeq	r0, r0, sp, lsl r0
    27f0:	0022a70f 	eoreq	sl, r2, pc, lsl #14
    27f4:	01b40500 			; <UNDEFINED> instruction: 0x01b40500
    27f8:	00001d0c 	andeq	r1, r0, ip, lsl #26
    27fc:	23950f00 	orrscs	r0, r5, #0, 30
    2800:	b7050000 	strlt	r0, [r5, -r0]
    2804:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2808:	e10f0000 	mrs	r0, CPSR
    280c:	05000020 	streq	r0, [r0, #-32]	; 0xffffffe0
    2810:	1d0c01ba 	stfnes	f0, [ip, #-744]	; 0xfffffd18
    2814:	0f000000 	svceq	0x00000000
    2818:	00002818 	andeq	r2, r0, r8, lsl r8
    281c:	0c01bd05 	stceq	13, cr11, [r1], {5}
    2820:	0000001d 	andeq	r0, r0, sp, lsl r0
    2824:	00239f0f 	eoreq	r9, r3, pc, lsl #30
    2828:	01c00500 	biceq	r0, r0, r0, lsl #10
    282c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2830:	28dc0f00 	ldmcs	ip, {r8, r9, sl, fp}^
    2834:	c3050000 	movwgt	r0, #20480	; 0x5000
    2838:	001d0c01 	andseq	r0, sp, r1, lsl #24
    283c:	a20f0000 	andge	r0, pc, #0
    2840:	05000027 	streq	r0, [r0, #-39]	; 0xffffffd9
    2844:	1d0c01c6 	stfnes	f0, [ip, #-792]	; 0xfffffce8
    2848:	0f000000 	svceq	0x00000000
    284c:	000027ae 	andeq	r2, r0, lr, lsr #15
    2850:	0c01c905 			; <UNDEFINED> instruction: 0x0c01c905
    2854:	0000001d 	andeq	r0, r0, sp, lsl r0
    2858:	0027ba0f 	eoreq	fp, r7, pc, lsl #20
    285c:	01cc0500 	biceq	r0, ip, r0, lsl #10
    2860:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2864:	27df0f00 	ldrbcs	r0, [pc, r0, lsl #30]
    2868:	d0050000 	andle	r0, r5, r0
    286c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2870:	cf0f0000 	svcgt	0x000f0000
    2874:	05000028 	streq	r0, [r0, #-40]	; 0xffffffd8
    2878:	1d0c01d3 	stfnes	f0, [ip, #-844]	; 0xfffffcb4
    287c:	0f000000 	svceq	0x00000000
    2880:	00001a86 	andeq	r1, r0, r6, lsl #21
    2884:	0c01d605 	stceq	6, cr13, [r1], {5}
    2888:	0000001d 	andeq	r0, r0, sp, lsl r0
    288c:	00186d0f 	andseq	r6, r8, pc, lsl #26
    2890:	01d90500 	bicseq	r0, r9, r0, lsl #10
    2894:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2898:	1d780f00 	ldclne	15, cr0, [r8, #-0]
    289c:	dc050000 	stcle	0, cr0, [r5], {-0}
    28a0:	001d0c01 	andseq	r0, sp, r1, lsl #24
    28a4:	610f0000 	mrsvs	r0, CPSR
    28a8:	0500001a 	streq	r0, [r0, #-26]	; 0xffffffe6
    28ac:	1d0c01df 	stfnes	f0, [ip, #-892]	; 0xfffffc84
    28b0:	0f000000 	svceq	0x00000000
    28b4:	000023b5 			; <UNDEFINED> instruction: 0x000023b5
    28b8:	0c01e205 	sfmeq	f6, 1, [r1], {5}
    28bc:	0000001d 	andeq	r0, r0, sp, lsl r0
    28c0:	001fbd0f 	andseq	fp, pc, pc, lsl #26
    28c4:	01e50500 	mvneq	r0, r0, lsl #10
    28c8:	00001d0c 	andeq	r1, r0, ip, lsl #26
    28cc:	22150f00 	andscs	r0, r5, #0, 30
    28d0:	e8050000 	stmda	r5, {}	; <UNPREDICTABLE>
    28d4:	001d0c01 	andseq	r0, sp, r1, lsl #24
    28d8:	cf0f0000 	svcgt	0x000f0000
    28dc:	05000026 	streq	r0, [r0, #-38]	; 0xffffffda
    28e0:	1d0c01ef 	stfnes	f0, [ip, #-956]	; 0xfffffc44
    28e4:	0f000000 	svceq	0x00000000
    28e8:	00002887 	andeq	r2, r0, r7, lsl #17
    28ec:	0c01f205 	sfmeq	f7, 1, [r1], {5}
    28f0:	0000001d 	andeq	r0, r0, sp, lsl r0
    28f4:	0028970f 	eoreq	r9, r8, pc, lsl #14
    28f8:	01f50500 	mvnseq	r0, r0, lsl #10
    28fc:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2900:	1b7d0f00 	blne	1f46508 <__bss_end+0x1f3d4cc>
    2904:	f8050000 			; <UNDEFINED> instruction: 0xf8050000
    2908:	001d0c01 	andseq	r0, sp, r1, lsl #24
    290c:	160f0000 	strne	r0, [pc], -r0
    2910:	05000027 	streq	r0, [r0, #-39]	; 0xffffffd9
    2914:	1d0c01fb 	stfnes	f0, [ip, #-1004]	; 0xfffffc14
    2918:	0f000000 	svceq	0x00000000
    291c:	0000231b 	andeq	r2, r0, fp, lsl r3
    2920:	0c01fe05 	stceq	14, cr15, [r1], {5}
    2924:	0000001d 	andeq	r0, r0, sp, lsl r0
    2928:	001df10f 	andseq	pc, sp, pc, lsl #2
    292c:	02020500 	andeq	r0, r2, #0, 10
    2930:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2934:	250b0f00 	strcs	r0, [fp, #-3840]	; 0xfffff100
    2938:	0a050000 	beq	142940 <__bss_end+0x139904>
    293c:	001d0c02 	andseq	r0, sp, r2, lsl #24
    2940:	e40f0000 	str	r0, [pc], #-0	; 2948 <shift+0x2948>
    2944:	0500001c 	streq	r0, [r0, #-28]	; 0xffffffe4
    2948:	1d0c020d 	sfmne	f0, 4, [ip, #-52]	; 0xffffffcc
    294c:	0c000000 	stceq	0, cr0, [r0], {-0}
    2950:	0000001d 	andeq	r0, r0, sp, lsl r0
    2954:	000007ef 	andeq	r0, r0, pc, ror #15
    2958:	bd0f000d 	stclt	0, cr0, [pc, #-52]	; 292c <shift+0x292c>
    295c:	0500001e 	streq	r0, [r0, #-30]	; 0xffffffe2
    2960:	e40c03fb 	str	r0, [ip], #-1019	; 0xfffffc05
    2964:	0c000007 	stceq	0, cr0, [r0], {7}
    2968:	000004e6 	andeq	r0, r0, r6, ror #9
    296c:	0000080c 	andeq	r0, r0, ip, lsl #16
    2970:	00002415 	andeq	r2, r0, r5, lsl r4
    2974:	0f000d00 	svceq	0x00000d00
    2978:	000023d8 	ldrdeq	r2, [r0], -r8
    297c:	14058405 	strne	r8, [r5], #-1029	; 0xfffffbfb
    2980:	000007fc 	strdeq	r0, [r0], -ip
    2984:	001f7f16 	andseq	r7, pc, r6, lsl pc	; <UNPREDICTABLE>
    2988:	93010700 	movwls	r0, #5888	; 0x1700
    298c:	05000000 	streq	r0, [r0, #-0]
    2990:	5706058b 	strpl	r0, [r6, -fp, lsl #11]
    2994:	0b000008 	bleq	29bc <shift+0x29bc>
    2998:	00001d3a 	andeq	r1, r0, sl, lsr sp
    299c:	218a0b00 	orrcs	r0, sl, r0, lsl #22
    29a0:	0b010000 	bleq	429a8 <__bss_end+0x3996c>
    29a4:	00001912 	andeq	r1, r0, r2, lsl r9
    29a8:	28490b02 	stmdacs	r9, {r1, r8, r9, fp}^
    29ac:	0b030000 	bleq	c29b4 <__bss_end+0xb9978>
    29b0:	00002452 	andeq	r2, r0, r2, asr r4
    29b4:	24450b04 	strbcs	r0, [r5], #-2820	; 0xfffff4fc
    29b8:	0b050000 	bleq	1429c0 <__bss_end+0x139984>
    29bc:	000019e9 	andeq	r1, r0, r9, ror #19
    29c0:	390f0006 	stmdbcc	pc, {r1, r2}	; <UNPREDICTABLE>
    29c4:	05000028 	streq	r0, [r0, #-40]	; 0xffffffd8
    29c8:	19150598 	ldmdbne	r5, {r3, r4, r7, r8, sl}
    29cc:	0f000008 	svceq	0x00000008
    29d0:	0000273b 	andeq	r2, r0, fp, lsr r7
    29d4:	11079905 	tstne	r7, r5, lsl #18
    29d8:	00000024 	andeq	r0, r0, r4, lsr #32
    29dc:	0023c50f 	eoreq	ip, r3, pc, lsl #10
    29e0:	07ae0500 	streq	r0, [lr, r0, lsl #10]!
    29e4:	00001d0c 	andeq	r1, r0, ip, lsl #26
    29e8:	26ae0400 	strtcs	r0, [lr], r0, lsl #8
    29ec:	7b060000 	blvc	1829f4 <__bss_end+0x1799b8>
    29f0:	00009316 	andeq	r9, r0, r6, lsl r3
    29f4:	087e0e00 	ldmdaeq	lr!, {r9, sl, fp}^
    29f8:	02030000 	andeq	r0, r3, #0
    29fc:	000d8905 	andeq	r8, sp, r5, lsl #18
    2a00:	07080300 	streq	r0, [r8, -r0, lsl #6]
    2a04:	00001ccd 	andeq	r1, r0, sp, asr #25
    2a08:	a1040403 	tstge	r4, r3, lsl #8
    2a0c:	0300001a 	movweq	r0, #26
    2a10:	1a990308 	bne	fe643638 <__bss_end+0xfe63a5fc>
    2a14:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    2a18:	0023ae04 	eoreq	sl, r3, r4, lsl #28
    2a1c:	03100300 	tsteq	r0, #0, 6
    2a20:	00002460 	andeq	r2, r0, r0, ror #8
    2a24:	00088a0c 	andeq	r8, r8, ip, lsl #20
    2a28:	0008c900 	andeq	ip, r8, r0, lsl #18
    2a2c:	00241500 	eoreq	r1, r4, r0, lsl #10
    2a30:	00ff0000 	rscseq	r0, pc, r0
    2a34:	0008b90e 	andeq	fp, r8, lr, lsl #18
    2a38:	22bf0f00 	adcscs	r0, pc, #0, 30
    2a3c:	fc060000 	stc2	0, cr0, [r6], {-0}
    2a40:	08c91601 	stmiaeq	r9, {r0, r9, sl, ip}^
    2a44:	500f0000 	andpl	r0, pc, r0
    2a48:	0600001a 			; <UNDEFINED> instruction: 0x0600001a
    2a4c:	c9160202 	ldmdbgt	r6, {r1, r9}
    2a50:	04000008 	streq	r0, [r0], #-8
    2a54:	000026e1 	andeq	r2, r0, r1, ror #13
    2a58:	f9102a07 			; <UNDEFINED> instruction: 0xf9102a07
    2a5c:	0c000004 	stceq	0, cr0, [r0], {4}
    2a60:	000008e8 	andeq	r0, r0, r8, ror #17
    2a64:	000008ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    2a68:	7209000d 	andvc	r0, r9, #13
    2a6c:	07000003 	streq	r0, [r0, -r3]
    2a70:	08f4112f 	ldmeq	r4!, {r0, r1, r2, r3, r5, r8, ip}^
    2a74:	37090000 	strcc	r0, [r9, -r0]
    2a78:	07000002 	streq	r0, [r0, -r2]
    2a7c:	08f41130 	ldmeq	r4!, {r4, r5, r8, ip}^
    2a80:	ff170000 			; <UNDEFINED> instruction: 0xff170000
    2a84:	08000008 	stmdaeq	r0, {r3}
    2a88:	050a0933 	streq	r0, [sl, #-2355]	; 0xfffff6cd
    2a8c:	00902103 	addseq	r2, r0, r3, lsl #2
    2a90:	090b1700 	stmdbeq	fp, {r8, r9, sl, ip}
    2a94:	34080000 	strcc	r0, [r8], #-0
    2a98:	03050a09 	movweq	r0, #23049	; 0x5a09
    2a9c:	00009021 	andeq	r9, r0, r1, lsr #32
	...

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	10001101 	andne	r1, r0, r1, lsl #2
   4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
   8:	1b0e0301 	blne	380c14 <__bss_end+0x377bd8>
   c:	130e250e 	movwne	r2, #58638	; 0xe50e
  10:	00000005 	andeq	r0, r0, r5
  14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
  18:	030b130e 	movweq	r1, #45838	; 0xb30e
  1c:	110e1b0e 	tstne	lr, lr, lsl #22
  20:	10061201 	andne	r1, r6, r1, lsl #4
  24:	02000017 	andeq	r0, r0, #23
  28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeb9ce0>
  30:	13490b39 	movtne	r0, #39737	; 0x9b39
  34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
  38:	24030000 	strcs	r0, [r3], #-0
  3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  40:	000e030b 	andeq	r0, lr, fp, lsl #6
  44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
  48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeb9d00>
  50:	01110b39 	tsteq	r1, r9, lsr fp
  54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
  58:	01194296 			; <UNDEFINED> instruction: 0x01194296
  5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeb9d18>
  68:	13490b39 	movtne	r0, #39737	; 0x9b39
  6c:	00001802 	andeq	r1, r0, r2, lsl #16
  70:	0b002406 	bleq	9090 <__bss_end+0x54>
  74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  78:	07000008 	streq	r0, [r0, -r8]
  7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe7a858>
  84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe39d3c>
  88:	06120111 			; <UNDEFINED> instruction: 0x06120111
  8c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
  90:	00130119 	andseq	r0, r3, r9, lsl r1
  94:	000f0800 	andeq	r0, pc, r0, lsl #16
  98:	13490b0b 	movtne	r0, #39691	; 0x9b0b
  9c:	01000000 	mrseq	r0, (UNDEF: 0)
  a0:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
  a4:	0e030b13 	vmoveq.32	d3[0], r0
  a8:	01110e1b 	tsteq	r1, fp, lsl lr
  ac:	17100612 			; <UNDEFINED> instruction: 0x17100612
  b0:	16020000 	strne	r0, [r2], -r0
  b4:	3a0e0300 	bcc	380cbc <__bss_end+0x377c80>
  b8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  bc:	0013490b 	andseq	r4, r3, fp, lsl #18
  c0:	000f0300 	andeq	r0, pc, r0, lsl #6
  c4:	13490b0b 	movtne	r0, #39691	; 0x9b0b
  c8:	15040000 	strne	r0, [r4, #-0]
  cc:	05000000 	streq	r0, [r0, #-0]
  d0:	13490101 	movtne	r0, #37121	; 0x9101
  d4:	00001301 	andeq	r1, r0, r1, lsl #6
  d8:	49002106 	stmdbmi	r0, {r1, r2, r8, sp}
  dc:	00062f13 	andeq	r2, r6, r3, lsl pc
  e0:	00240700 	eoreq	r0, r4, r0, lsl #14
  e4:	0b3e0b0b 	bleq	f82d18 <__bss_end+0xf79cdc>
  e8:	00000e03 	andeq	r0, r0, r3, lsl #28
  ec:	03003408 	movweq	r3, #1032	; 0x408
  f0:	3b0b3a0e 	blcc	2ce930 <__bss_end+0x2c58f4>
  f4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
  f8:	3c193f13 	ldccc	15, cr3, [r9], {19}
  fc:	09000019 	stmdbeq	r0, {r0, r3, r4}
 100:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 104:	0b3a0e03 	bleq	e83918 <__bss_end+0xe7a8dc>
 108:	0b390b3b 	bleq	e42dfc <__bss_end+0xe39dc0>
 10c:	01111349 	tsteq	r1, r9, asr #6
 110:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 114:	01194296 			; <UNDEFINED> instruction: 0x01194296
 118:	0a000013 	beq	16c <shift+0x16c>
 11c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeb9dd4>
 124:	13490b39 	movtne	r0, #39737	; 0x9b39
 128:	00001802 	andeq	r1, r0, r2, lsl #16
 12c:	0b00240b 	bleq	9160 <__bss_end+0x124>
 130:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 134:	0c000008 	stceq	0, cr0, [r0], {8}
 138:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
 13c:	0b3a0e03 	bleq	e83950 <__bss_end+0xe7a914>
 140:	0b390b3b 	bleq	e42e34 <__bss_end+0xe39df8>
 144:	06120111 			; <UNDEFINED> instruction: 0x06120111
 148:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 14c:	0d000019 	stceq	0, cr0, [r0, #-100]	; 0xffffff9c
 150:	0e030139 	mcreq	1, 0, r0, cr3, cr9, {1}
 154:	0b3b0b3a 	bleq	ec2e44 <__bss_end+0xeb9e08>
 158:	00001301 	andeq	r1, r0, r1, lsl #6
 15c:	3f012e0e 	svccc	0x00012e0e
 160:	3a0e0319 	bcc	380dcc <__bss_end+0x377d90>
 164:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 168:	01193c0b 	tsteq	r9, fp, lsl #24
 16c:	0f000013 	svceq	0x00000013
 170:	13490005 	movtne	r0, #36869	; 0x9005
 174:	2e100000 	cdpcs	0, 1, cr0, cr0, cr0, {0}
 178:	03193f01 	tsteq	r9, #1, 30
 17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c5980>
 180:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 184:	00193c13 	andseq	r3, r9, r3, lsl ip
 188:	012e1100 			; <UNDEFINED> instruction: 0x012e1100
 18c:	01111347 	tsteq	r1, r7, asr #6
 190:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 194:	01194297 			; <UNDEFINED> instruction: 0x01194297
 198:	12000013 	andne	r0, r0, #19
 19c:	13490005 	movtne	r0, #36869	; 0x9005
 1a0:	00001802 	andeq	r1, r0, r2, lsl #16
 1a4:	03000513 	movweq	r0, #1299	; 0x513
 1a8:	3b0b3a08 	blcc	2ce9d0 <__bss_end+0x2c5994>
 1ac:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 1b0:	00180213 	andseq	r0, r8, r3, lsl r2
 1b4:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 1b8:	01111347 	tsteq	r1, r7, asr #6
 1bc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 1c0:	00194297 	mulseq	r9, r7, r2
 1c4:	11010000 	mrsne	r0, (UNDEF: 1)
 1c8:	130e2501 	movwne	r2, #58625	; 0xe501
 1cc:	1b0e030b 	blne	380e00 <__bss_end+0x377dc4>
 1d0:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 1d4:	00171006 	andseq	r1, r7, r6
 1d8:	00240200 	eoreq	r0, r4, r0, lsl #4
 1dc:	0b3e0b0b 	bleq	f82e10 <__bss_end+0xf79dd4>
 1e0:	00000e03 	andeq	r0, r0, r3, lsl #28
 1e4:	49002603 	stmdbmi	r0, {r0, r1, r9, sl, sp}
 1e8:	04000013 	streq	r0, [r0], #-19	; 0xffffffed
 1ec:	0b0b0024 	bleq	2c0284 <__bss_end+0x2b7248>
 1f0:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 1f4:	16050000 	strne	r0, [r5], -r0
 1f8:	3a0e0300 	bcc	380e00 <__bss_end+0x377dc4>
 1fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 200:	0013490b 	andseq	r4, r3, fp, lsl #18
 204:	00350600 	eorseq	r0, r5, r0, lsl #12
 208:	00001349 	andeq	r1, r0, r9, asr #6
 20c:	03011307 	movweq	r1, #4871	; 0x1307
 210:	3a0b0b0e 	bcc	2c2e50 <__bss_end+0x2b9e14>
 214:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 218:	0013010b 	andseq	r0, r3, fp, lsl #2
 21c:	000d0800 	andeq	r0, sp, r0, lsl #16
 220:	0b3a0803 	bleq	e82234 <__bss_end+0xe791f8>
 224:	0b390b3b 	bleq	e42f18 <__bss_end+0xe39edc>
 228:	0b381349 	bleq	e04f54 <__bss_end+0xdfbf18>
 22c:	04090000 	streq	r0, [r9], #-0
 230:	6d0e0301 	stcvs	3, cr0, [lr, #-4]
 234:	0b0b3e19 	bleq	2cfaa0 <__bss_end+0x2c6a64>
 238:	3a13490b 	bcc	4d266c <__bss_end+0x4c9630>
 23c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 240:	0013010b 	andseq	r0, r3, fp, lsl #2
 244:	00280a00 	eoreq	r0, r8, r0, lsl #20
 248:	0b1c0e03 	bleq	703a5c <__bss_end+0x6faa20>
 24c:	340b0000 	strcc	r0, [fp], #-0
 250:	3a0e0300 	bcc	380e58 <__bss_end+0x377e1c>
 254:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 258:	6c13490b 			; <UNDEFINED> instruction: 0x6c13490b
 25c:	00180219 	andseq	r0, r8, r9, lsl r2
 260:	00020c00 	andeq	r0, r2, r0, lsl #24
 264:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
 268:	020d0000 	andeq	r0, sp, #0
 26c:	0b0e0301 	bleq	380e78 <__bss_end+0x377e3c>
 270:	3b0b3a0b 	blcc	2ceaa4 <__bss_end+0x2c5a68>
 274:	010b390b 	tsteq	fp, fp, lsl #18
 278:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
 27c:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 280:	0b3b0b3a 	bleq	ec2f70 <__bss_end+0xeb9f34>
 284:	13490b39 	movtne	r0, #39737	; 0x9b39
 288:	00000b38 	andeq	r0, r0, r8, lsr fp
 28c:	3f012e0f 	svccc	0x00012e0f
 290:	3a0e0319 	bcc	380efc <__bss_end+0x377ec0>
 294:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 298:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 29c:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
 2a0:	10000013 	andne	r0, r0, r3, lsl r0
 2a4:	13490005 	movtne	r0, #36869	; 0x9005
 2a8:	00001934 	andeq	r1, r0, r4, lsr r9
 2ac:	49000511 	stmdbmi	r0, {r0, r4, r8, sl}
 2b0:	12000013 	andne	r0, r0, #19
 2b4:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 2b8:	0b3b0b3a 	bleq	ec2fa8 <__bss_end+0xeb9f6c>
 2bc:	13490b39 	movtne	r0, #39737	; 0x9b39
 2c0:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 2c4:	2e130000 	cdpcs	0, 1, cr0, cr3, cr0, {0}
 2c8:	03193f01 	tsteq	r9, #1, 30
 2cc:	3b0b3a0e 	blcc	2ceb0c <__bss_end+0x2c5ad0>
 2d0:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 2d4:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 2d8:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 2dc:	00130113 	andseq	r0, r3, r3, lsl r1
 2e0:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 2e4:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 2e8:	0b3b0b3a 	bleq	ec2fd8 <__bss_end+0xeb9f9c>
 2ec:	0e6e0b39 	vmoveq.8	d14[5], r0
 2f0:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 2f4:	13011364 	movwne	r1, #4964	; 0x1364
 2f8:	2e150000 	cdpcs	0, 1, cr0, cr5, cr0, {0}
 2fc:	03193f01 	tsteq	r9, #1, 30
 300:	3b0b3a0e 	blcc	2ceb40 <__bss_end+0x2c5b04>
 304:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 308:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 30c:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 310:	16000013 			; <UNDEFINED> instruction: 0x16000013
 314:	13490101 	movtne	r0, #37121	; 0x9101
 318:	00001301 	andeq	r1, r0, r1, lsl #6
 31c:	49002117 	stmdbmi	r0, {r0, r1, r2, r4, r8, sp}
 320:	000b2f13 	andeq	r2, fp, r3, lsl pc
 324:	000f1800 	andeq	r1, pc, r0, lsl #16
 328:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 32c:	21190000 	tstcs	r9, r0
 330:	1a000000 	bne	338 <shift+0x338>
 334:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 338:	0b3b0b3a 	bleq	ec3028 <__bss_end+0xeb9fec>
 33c:	13490b39 	movtne	r0, #39737	; 0x9b39
 340:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 344:	281b0000 	ldmdacs	fp, {}	; <UNPREDICTABLE>
 348:	1c080300 	stcne	3, cr0, [r8], {-0}
 34c:	1c00000b 	stcne	0, cr0, [r0], {11}
 350:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 354:	0b3a0e03 	bleq	e83b68 <__bss_end+0xe7ab2c>
 358:	0b390b3b 	bleq	e4304c <__bss_end+0xe3a010>
 35c:	193c0e6e 	ldmdbne	ip!, {r1, r2, r3, r5, r6, r9, sl, fp}
 360:	13011364 	movwne	r1, #4964	; 0x1364
 364:	2e1d0000 	cdpcs	0, 1, cr0, cr13, cr0, {0}
 368:	03193f01 	tsteq	r9, #1, 30
 36c:	3b0b3a0e 	blcc	2cebac <__bss_end+0x2c5b70>
 370:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 374:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
 378:	01136419 	tsteq	r3, r9, lsl r4
 37c:	1e000013 	mcrne	0, 0, r0, cr0, cr3, {0}
 380:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 384:	0b3b0b3a 	bleq	ec3074 <__bss_end+0xeba038>
 388:	13490b39 	movtne	r0, #39737	; 0x9b39
 38c:	0b320b38 	bleq	c83074 <__bss_end+0xc7a038>
 390:	151f0000 	ldrne	r0, [pc, #-0]	; 398 <shift+0x398>
 394:	64134901 	ldrvs	r4, [r3], #-2305	; 0xfffff6ff
 398:	00130113 	andseq	r0, r3, r3, lsl r1
 39c:	001f2000 	andseq	r2, pc, r0
 3a0:	1349131d 	movtne	r1, #37661	; 0x931d
 3a4:	10210000 	eorne	r0, r1, r0
 3a8:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 3ac:	22000013 	andcs	r0, r0, #19
 3b0:	0b0b000f 	bleq	2c03f4 <__bss_end+0x2b73b8>
 3b4:	39230000 	stmdbcc	r3!, {}	; <UNPREDICTABLE>
 3b8:	3a080301 	bcc	200fc4 <__bss_end+0x1f7f88>
 3bc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 3c0:	0013010b 	andseq	r0, r3, fp, lsl #2
 3c4:	00342400 	eorseq	r2, r4, r0, lsl #8
 3c8:	0b3a0e03 	bleq	e83bdc <__bss_end+0xe7aba0>
 3cc:	0b390b3b 	bleq	e430c0 <__bss_end+0xe3a084>
 3d0:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 3d4:	196c061c 	stmdbne	ip!, {r2, r3, r4, r9, sl}^
 3d8:	34250000 	strtcc	r0, [r5], #-0
 3dc:	3a0e0300 	bcc	380fe4 <__bss_end+0x377fa8>
 3e0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 3e4:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 3e8:	6c0b1c19 	stcvs	12, cr1, [fp], {25}
 3ec:	26000019 			; <UNDEFINED> instruction: 0x26000019
 3f0:	13470034 	movtne	r0, #28724	; 0x7034
 3f4:	2e270000 	cdpcs	0, 2, cr0, cr7, cr0, {0}
 3f8:	03193f01 	tsteq	r9, #1, 30
 3fc:	3b0b3a0e 	blcc	2cec3c <__bss_end+0x2c5c00>
 400:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 404:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
 408:	00136419 	andseq	r6, r3, r9, lsl r4
 40c:	00342800 	eorseq	r2, r4, r0, lsl #16
 410:	0b3a0e03 	bleq	e83c24 <__bss_end+0xe7abe8>
 414:	0b390b3b 	bleq	e43108 <__bss_end+0xe3a0cc>
 418:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 41c:	00001802 	andeq	r1, r0, r2, lsl #16
 420:	3f012e29 	svccc	0x00012e29
 424:	3a0e0319 	bcc	381090 <__bss_end+0x378054>
 428:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 42c:	1113490b 	tstne	r3, fp, lsl #18
 430:	40061201 	andmi	r1, r6, r1, lsl #4
 434:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 438:	00001301 	andeq	r1, r0, r1, lsl #6
 43c:	0300052a 	movweq	r0, #1322	; 0x52a
 440:	3b0b3a0e 	blcc	2cec80 <__bss_end+0x2c5c44>
 444:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 448:	00180213 	andseq	r0, r8, r3, lsl r2
 44c:	00342b00 	eorseq	r2, r4, r0, lsl #22
 450:	0b3a0e03 	bleq	e83c64 <__bss_end+0xe7ac28>
 454:	0b390b3b 	bleq	e43148 <__bss_end+0xe3a10c>
 458:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 45c:	2e2c0000 	cdpcs	0, 2, cr0, cr12, cr0, {0}
 460:	03193f01 	tsteq	r9, #1, 30
 464:	3b0b3a0e 	blcc	2ceca4 <__bss_end+0x2c5c68>
 468:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 46c:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 470:	96184006 	ldrls	r4, [r8], -r6
 474:	00001942 	andeq	r1, r0, r2, asr #18
 478:	01110100 	tsteq	r1, r0, lsl #2
 47c:	0b130e25 	bleq	4c3d18 <__bss_end+0x4bacdc>
 480:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 484:	06120111 			; <UNDEFINED> instruction: 0x06120111
 488:	00001710 	andeq	r1, r0, r0, lsl r7
 48c:	0b002402 	bleq	949c <__bss_end+0x460>
 490:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 494:	0300000e 	movweq	r0, #14
 498:	13490026 	movtne	r0, #36902	; 0x9026
 49c:	24040000 	strcs	r0, [r4], #-0
 4a0:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 4a4:	0008030b 	andeq	r0, r8, fp, lsl #6
 4a8:	00160500 	andseq	r0, r6, r0, lsl #10
 4ac:	0b3a0e03 	bleq	e83cc0 <__bss_end+0xe7ac84>
 4b0:	0b390b3b 	bleq	e431a4 <__bss_end+0xe3a168>
 4b4:	00001349 	andeq	r1, r0, r9, asr #6
 4b8:	03011306 	movweq	r1, #4870	; 0x1306
 4bc:	3a0b0b0e 	bcc	2c30fc <__bss_end+0x2ba0c0>
 4c0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4c4:	0013010b 	andseq	r0, r3, fp, lsl #2
 4c8:	000d0700 	andeq	r0, sp, r0, lsl #14
 4cc:	0b3a0803 	bleq	e824e0 <__bss_end+0xe794a4>
 4d0:	0b390b3b 	bleq	e431c4 <__bss_end+0xe3a188>
 4d4:	0b381349 	bleq	e05200 <__bss_end+0xdfc1c4>
 4d8:	04080000 	streq	r0, [r8], #-0
 4dc:	6d0e0301 	stcvs	3, cr0, [lr, #-4]
 4e0:	0b0b3e19 	bleq	2cfd4c <__bss_end+0x2c6d10>
 4e4:	3a13490b 	bcc	4d2918 <__bss_end+0x4c98dc>
 4e8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4ec:	0013010b 	andseq	r0, r3, fp, lsl #2
 4f0:	00280900 	eoreq	r0, r8, r0, lsl #18
 4f4:	0b1c0803 	bleq	702508 <__bss_end+0x6f94cc>
 4f8:	280a0000 	stmdacs	sl, {}	; <UNPREDICTABLE>
 4fc:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 500:	0b00000b 	bleq	534 <shift+0x534>
 504:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 508:	0b3b0b3a 	bleq	ec31f8 <__bss_end+0xeba1bc>
 50c:	13490b39 	movtne	r0, #39737	; 0x9b39
 510:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
 514:	020c0000 	andeq	r0, ip, #0
 518:	3c0e0300 	stccc	3, cr0, [lr], {-0}
 51c:	0d000019 	stceq	0, cr0, [r0, #-100]	; 0xffffff9c
 520:	0e030102 	adfeqs	f0, f3, f2
 524:	0b3a0b0b 	bleq	e83158 <__bss_end+0xe7a11c>
 528:	0b390b3b 	bleq	e4321c <__bss_end+0xe3a1e0>
 52c:	00001301 	andeq	r1, r0, r1, lsl #6
 530:	03000d0e 	movweq	r0, #3342	; 0xd0e
 534:	3b0b3a0e 	blcc	2ced74 <__bss_end+0x2c5d38>
 538:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 53c:	000b3813 	andeq	r3, fp, r3, lsl r8
 540:	012e0f00 			; <UNDEFINED> instruction: 0x012e0f00
 544:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 548:	0b3b0b3a 	bleq	ec3238 <__bss_end+0xeba1fc>
 54c:	0e6e0b39 	vmoveq.8	d14[5], r0
 550:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 554:	00001364 	andeq	r1, r0, r4, ror #6
 558:	49000510 	stmdbmi	r0, {r4, r8, sl}
 55c:	00193413 	andseq	r3, r9, r3, lsl r4
 560:	00051100 	andeq	r1, r5, r0, lsl #2
 564:	00001349 	andeq	r1, r0, r9, asr #6
 568:	03000d12 	movweq	r0, #3346	; 0xd12
 56c:	3b0b3a0e 	blcc	2cedac <__bss_end+0x2c5d70>
 570:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 574:	3c193f13 	ldccc	15, cr3, [r9], {19}
 578:	13000019 	movwne	r0, #25
 57c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 580:	0b3a0e03 	bleq	e83d94 <__bss_end+0xe7ad58>
 584:	0b390b3b 	bleq	e43278 <__bss_end+0xe3a23c>
 588:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 58c:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 590:	13011364 	movwne	r1, #4964	; 0x1364
 594:	2e140000 	cdpcs	0, 1, cr0, cr4, cr0, {0}
 598:	03193f01 	tsteq	r9, #1, 30
 59c:	3b0b3a0e 	blcc	2ceddc <__bss_end+0x2c5da0>
 5a0:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 5a4:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
 5a8:	01136419 	tsteq	r3, r9, lsl r4
 5ac:	15000013 	strne	r0, [r0, #-19]	; 0xffffffed
 5b0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 5b4:	0b3a0e03 	bleq	e83dc8 <__bss_end+0xe7ad8c>
 5b8:	0b390b3b 	bleq	e432ac <__bss_end+0xe3a270>
 5bc:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 5c0:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 5c4:	00001364 	andeq	r1, r0, r4, ror #6
 5c8:	49010116 	stmdbmi	r1, {r1, r2, r4, r8}
 5cc:	00130113 	andseq	r0, r3, r3, lsl r1
 5d0:	00211700 	eoreq	r1, r1, r0, lsl #14
 5d4:	0b2f1349 	bleq	bc5300 <__bss_end+0xbbc2c4>
 5d8:	0f180000 	svceq	0x00180000
 5dc:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 5e0:	19000013 	stmdbne	r0, {r0, r1, r4}
 5e4:	00000021 	andeq	r0, r0, r1, lsr #32
 5e8:	0300341a 	movweq	r3, #1050	; 0x41a
 5ec:	3b0b3a0e 	blcc	2cee2c <__bss_end+0x2c5df0>
 5f0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 5f4:	3c193f13 	ldccc	15, cr3, [r9], {19}
 5f8:	1b000019 	blne	664 <shift+0x664>
 5fc:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 600:	0b3a0e03 	bleq	e83e14 <__bss_end+0xe7add8>
 604:	0b390b3b 	bleq	e432f8 <__bss_end+0xe3a2bc>
 608:	193c0e6e 	ldmdbne	ip!, {r1, r2, r3, r5, r6, r9, sl, fp}
 60c:	13011364 	movwne	r1, #4964	; 0x1364
 610:	2e1c0000 	cdpcs	0, 1, cr0, cr12, cr0, {0}
 614:	03193f01 	tsteq	r9, #1, 30
 618:	3b0b3a0e 	blcc	2cee58 <__bss_end+0x2c5e1c>
 61c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 620:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
 624:	01136419 	tsteq	r3, r9, lsl r4
 628:	1d000013 	stcne	0, cr0, [r0, #-76]	; 0xffffffb4
 62c:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 630:	0b3b0b3a 	bleq	ec3320 <__bss_end+0xeba2e4>
 634:	13490b39 	movtne	r0, #39737	; 0x9b39
 638:	0b320b38 	bleq	c83320 <__bss_end+0xc7a2e4>
 63c:	151e0000 	ldrne	r0, [lr, #-0]
 640:	64134901 	ldrvs	r4, [r3], #-2305	; 0xfffff6ff
 644:	00130113 	andseq	r0, r3, r3, lsl r1
 648:	001f1f00 	andseq	r1, pc, r0, lsl #30
 64c:	1349131d 	movtne	r1, #37661	; 0x931d
 650:	10200000 	eorne	r0, r0, r0
 654:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 658:	21000013 	tstcs	r0, r3, lsl r0
 65c:	0b0b000f 	bleq	2c06a0 <__bss_end+0x2b7664>
 660:	34220000 	strtcc	r0, [r2], #-0
 664:	3a0e0300 	bcc	38126c <__bss_end+0x378230>
 668:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 66c:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 670:	23000018 	movwcs	r0, #24
 674:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 678:	0b3a0e03 	bleq	e83e8c <__bss_end+0xe7ae50>
 67c:	0b390b3b 	bleq	e43370 <__bss_end+0xe3a334>
 680:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 684:	06120111 			; <UNDEFINED> instruction: 0x06120111
 688:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 68c:	00130119 	andseq	r0, r3, r9, lsl r1
 690:	00052400 	andeq	r2, r5, r0, lsl #8
 694:	0b3a0e03 	bleq	e83ea8 <__bss_end+0xe7ae6c>
 698:	0b390b3b 	bleq	e4338c <__bss_end+0xe3a350>
 69c:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 6a0:	2e250000 	cdpcs	0, 2, cr0, cr5, cr0, {0}
 6a4:	03193f01 	tsteq	r9, #1, 30
 6a8:	3b0b3a0e 	blcc	2ceee8 <__bss_end+0x2c5eac>
 6ac:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 6b0:	1113490e 	tstne	r3, lr, lsl #18
 6b4:	40061201 	andmi	r1, r6, r1, lsl #4
 6b8:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 6bc:	00001301 	andeq	r1, r0, r1, lsl #6
 6c0:	03003426 	movweq	r3, #1062	; 0x426
 6c4:	3b0b3a08 	blcc	2ceeec <__bss_end+0x2c5eb0>
 6c8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 6cc:	00180213 	andseq	r0, r8, r3, lsl r2
 6d0:	012e2700 			; <UNDEFINED> instruction: 0x012e2700
 6d4:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 6d8:	0b3b0b3a 	bleq	ec33c8 <__bss_end+0xeba38c>
 6dc:	0e6e0b39 	vmoveq.8	d14[5], r0
 6e0:	06120111 			; <UNDEFINED> instruction: 0x06120111
 6e4:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 6e8:	00130119 	andseq	r0, r3, r9, lsl r1
 6ec:	002e2800 	eoreq	r2, lr, r0, lsl #16
 6f0:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 6f4:	0b3b0b3a 	bleq	ec33e4 <__bss_end+0xeba3a8>
 6f8:	0e6e0b39 	vmoveq.8	d14[5], r0
 6fc:	06120111 			; <UNDEFINED> instruction: 0x06120111
 700:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 704:	29000019 	stmdbcs	r0, {r0, r3, r4}
 708:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 70c:	0b3a0e03 	bleq	e83f20 <__bss_end+0xe7aee4>
 710:	0b390b3b 	bleq	e43404 <__bss_end+0xe3a3c8>
 714:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 718:	06120111 			; <UNDEFINED> instruction: 0x06120111
 71c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 720:	00000019 	andeq	r0, r0, r9, lsl r0
 724:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 728:	030b130e 	movweq	r1, #45838	; 0xb30e
 72c:	110e1b0e 	tstne	lr, lr, lsl #22
 730:	10061201 	andne	r1, r6, r1, lsl #4
 734:	02000017 	andeq	r0, r0, #23
 738:	13010139 	movwne	r0, #4409	; 0x1139
 73c:	34030000 	strcc	r0, [r3], #-0
 740:	3a0e0300 	bcc	381348 <__bss_end+0x37830c>
 744:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 748:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 74c:	000a1c19 	andeq	r1, sl, r9, lsl ip
 750:	003a0400 	eorseq	r0, sl, r0, lsl #8
 754:	0b3b0b3a 	bleq	ec3444 <__bss_end+0xeba408>
 758:	13180b39 	tstne	r8, #58368	; 0xe400
 75c:	01050000 	mrseq	r0, (UNDEF: 5)
 760:	01134901 	tsteq	r3, r1, lsl #18
 764:	06000013 			; <UNDEFINED> instruction: 0x06000013
 768:	13490021 	movtne	r0, #36897	; 0x9021
 76c:	00000b2f 	andeq	r0, r0, pc, lsr #22
 770:	49002607 	stmdbmi	r0, {r0, r1, r2, r9, sl, sp}
 774:	08000013 	stmdaeq	r0, {r0, r1, r4}
 778:	0b0b0024 	bleq	2c0810 <__bss_end+0x2b77d4>
 77c:	0e030b3e 	vmoveq.16	d3[0], r0
 780:	34090000 	strcc	r0, [r9], #-0
 784:	00134700 	andseq	r4, r3, r0, lsl #14
 788:	012e0a00 			; <UNDEFINED> instruction: 0x012e0a00
 78c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 790:	0b3b0b3a 	bleq	ec3480 <__bss_end+0xeba444>
 794:	0e6e0b39 	vmoveq.8	d14[5], r0
 798:	06120111 			; <UNDEFINED> instruction: 0x06120111
 79c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 7a0:	00130119 	andseq	r0, r3, r9, lsl r1
 7a4:	00050b00 	andeq	r0, r5, r0, lsl #22
 7a8:	0b3a0803 	bleq	e827bc <__bss_end+0xe79780>
 7ac:	0b390b3b 	bleq	e434a0 <__bss_end+0xe3a464>
 7b0:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 7b4:	340c0000 	strcc	r0, [ip], #-0
 7b8:	3a0e0300 	bcc	3813c0 <__bss_end+0x378384>
 7bc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 7c0:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 7c4:	0d000018 	stceq	0, cr0, [r0, #-96]	; 0xffffffa0
 7c8:	0111010b 	tsteq	r1, fp, lsl #2
 7cc:	00000612 	andeq	r0, r0, r2, lsl r6
 7d0:	0300340e 	movweq	r3, #1038	; 0x40e
 7d4:	3b0b3a08 	blcc	2ceffc <__bss_end+0x2c5fc0>
 7d8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 7dc:	00180213 	andseq	r0, r8, r3, lsl r2
 7e0:	000f0f00 	andeq	r0, pc, r0, lsl #30
 7e4:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 7e8:	26100000 	ldrcs	r0, [r0], -r0
 7ec:	11000000 	mrsne	r0, (UNDEF: 0)
 7f0:	0b0b000f 	bleq	2c0834 <__bss_end+0x2b77f8>
 7f4:	24120000 	ldrcs	r0, [r2], #-0
 7f8:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 7fc:	0008030b 	andeq	r0, r8, fp, lsl #6
 800:	00051300 	andeq	r1, r5, r0, lsl #6
 804:	0b3a0e03 	bleq	e84018 <__bss_end+0xe7afdc>
 808:	0b390b3b 	bleq	e434fc <__bss_end+0xe3a4c0>
 80c:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 810:	2e140000 	cdpcs	0, 1, cr0, cr4, cr0, {0}
 814:	03193f01 	tsteq	r9, #1, 30
 818:	3b0b3a0e 	blcc	2cf058 <__bss_end+0x2c601c>
 81c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 820:	1113490e 	tstne	r3, lr, lsl #18
 824:	40061201 	andmi	r1, r6, r1, lsl #4
 828:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 82c:	00001301 	andeq	r1, r0, r1, lsl #6
 830:	3f012e15 	svccc	0x00012e15
 834:	3a0e0319 	bcc	3814a0 <__bss_end+0x378464>
 838:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 83c:	110e6e0b 	tstne	lr, fp, lsl #28
 840:	40061201 	andmi	r1, r6, r1, lsl #4
 844:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 848:	01000000 	mrseq	r0, (UNDEF: 0)
 84c:	06100011 			; <UNDEFINED> instruction: 0x06100011
 850:	01120111 	tsteq	r2, r1, lsl r1
 854:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 858:	05130e25 	ldreq	r0, [r3, #-3621]	; 0xfffff1db
 85c:	01000000 	mrseq	r0, (UNDEF: 0)
 860:	06100011 			; <UNDEFINED> instruction: 0x06100011
 864:	01120111 	tsteq	r2, r1, lsl r1
 868:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 86c:	05130e25 	ldreq	r0, [r3, #-3621]	; 0xfffff1db
 870:	01000000 	mrseq	r0, (UNDEF: 0)
 874:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 878:	0e030b13 	vmoveq.32	d3[0], r0
 87c:	17100e1b 			; <UNDEFINED> instruction: 0x17100e1b
 880:	24020000 	strcs	r0, [r2], #-0
 884:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 888:	0008030b 	andeq	r0, r8, fp, lsl #6
 88c:	00240300 	eoreq	r0, r4, r0, lsl #6
 890:	0b3e0b0b 	bleq	f834c4 <__bss_end+0xf7a488>
 894:	00000e03 	andeq	r0, r0, r3, lsl #28
 898:	03001604 	movweq	r1, #1540	; 0x604
 89c:	3b0b3a0e 	blcc	2cf0dc <__bss_end+0x2c60a0>
 8a0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 8a4:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
 8a8:	0b0b000f 	bleq	2c08ec <__bss_end+0x2b78b0>
 8ac:	00001349 	andeq	r1, r0, r9, asr #6
 8b0:	27011506 	strcs	r1, [r1, -r6, lsl #10]
 8b4:	01134919 	tsteq	r3, r9, lsl r9
 8b8:	07000013 	smladeq	r0, r3, r0, r0
 8bc:	13490005 	movtne	r0, #36869	; 0x9005
 8c0:	26080000 	strcs	r0, [r8], -r0
 8c4:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
 8c8:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 8cc:	0b3b0b3a 	bleq	ec35bc <__bss_end+0xeba580>
 8d0:	13490b39 	movtne	r0, #39737	; 0x9b39
 8d4:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 8d8:	040a0000 	streq	r0, [sl], #-0
 8dc:	3e0e0301 	cdpcc	3, 0, cr0, cr14, cr1, {0}
 8e0:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 8e4:	3b0b3a13 	blcc	2cf138 <__bss_end+0x2c60fc>
 8e8:	010b390b 	tsteq	fp, fp, lsl #18
 8ec:	0b000013 	bleq	940 <shift+0x940>
 8f0:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 8f4:	00000b1c 	andeq	r0, r0, ip, lsl fp
 8f8:	4901010c 	stmdbmi	r1, {r2, r3, r8}
 8fc:	00130113 	andseq	r0, r3, r3, lsl r1
 900:	00210d00 	eoreq	r0, r1, r0, lsl #26
 904:	260e0000 	strcs	r0, [lr], -r0
 908:	00134900 	andseq	r4, r3, r0, lsl #18
 90c:	00340f00 	eorseq	r0, r4, r0, lsl #30
 910:	0b3a0e03 	bleq	e84124 <__bss_end+0xe7b0e8>
 914:	0b39053b 	bleq	e41e08 <__bss_end+0xe38dcc>
 918:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 91c:	0000193c 	andeq	r1, r0, ip, lsr r9
 920:	03001310 	movweq	r1, #784	; 0x310
 924:	00193c0e 	andseq	r3, r9, lr, lsl #24
 928:	00151100 	andseq	r1, r5, r0, lsl #2
 92c:	00001927 	andeq	r1, r0, r7, lsr #18
 930:	03001712 	movweq	r1, #1810	; 0x712
 934:	00193c0e 	andseq	r3, r9, lr, lsl #24
 938:	01131300 	tsteq	r3, r0, lsl #6
 93c:	0b0b0e03 	bleq	2c4150 <__bss_end+0x2bb114>
 940:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 944:	13010b39 	movwne	r0, #6969	; 0x1b39
 948:	0d140000 	ldceq	0, cr0, [r4, #-0]
 94c:	3a0e0300 	bcc	381554 <__bss_end+0x378518>
 950:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 954:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 958:	1500000b 	strne	r0, [r0, #-11]
 95c:	13490021 	movtne	r0, #36897	; 0x9021
 960:	00000b2f 	andeq	r0, r0, pc, lsr #22
 964:	03010416 	movweq	r0, #5142	; 0x1416
 968:	0b0b3e0e 	bleq	2d01a8 <__bss_end+0x2c716c>
 96c:	3a13490b 	bcc	4d2da0 <__bss_end+0x4c9d64>
 970:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 974:	0013010b 	andseq	r0, r3, fp, lsl #2
 978:	00341700 	eorseq	r1, r4, r0, lsl #14
 97c:	0b3a1347 	bleq	e856a0 <__bss_end+0xe7c664>
 980:	0b39053b 	bleq	e41e74 <__bss_end+0xe38e38>
 984:	00001802 	andeq	r1, r0, r2, lsl #16
	...

Disassembly of section .debug_aranges:

00000000 <.debug_aranges>:
   0:	0000001c 	andeq	r0, r0, ip, lsl r0
   4:	00000002 	andeq	r0, r0, r2
   8:	00040000 	andeq	r0, r4, r0
   c:	00000000 	andeq	r0, r0, r0
  10:	00008000 	andeq	r8, r0, r0
  14:	00000008 	andeq	r0, r0, r8
	...
  20:	0000001c 	andeq	r0, r0, ip, lsl r0
  24:	00260002 	eoreq	r0, r6, r2
  28:	00040000 	andeq	r0, r4, r0
  2c:	00000000 	andeq	r0, r0, r0
  30:	00008008 	andeq	r8, r0, r8
  34:	000000a8 	andeq	r0, r0, r8, lsr #1
	...
  40:	0000001c 	andeq	r0, r0, ip, lsl r0
  44:	00c40002 	sbceq	r0, r4, r2
  48:	00040000 	andeq	r0, r4, r0
  4c:	00000000 	andeq	r0, r0, r0
  50:	000080b0 	strheq	r8, [r0], -r0
  54:	00000188 	andeq	r0, r0, r8, lsl #3
	...
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	02ca0002 	sbceq	r0, sl, #2
  68:	00040000 	andeq	r0, r4, r0
  6c:	00000000 	andeq	r0, r0, r0
  70:	00008238 	andeq	r8, r0, r8, lsr r2
  74:	000001ec 	andeq	r0, r0, ip, ror #3
	...
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	11120002 	tstne	r2, r2
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	00008424 	andeq	r8, r0, r4, lsr #8
  94:	0000045c 	andeq	r0, r0, ip, asr r4
	...
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	1ded0002 	stclne	0, cr0, [sp, #8]!
  a8:	00040000 	andeq	r0, r4, r0
  ac:	00000000 	andeq	r0, r0, r0
  b0:	00008880 	andeq	r8, r0, r0, lsl #17
  b4:	000004b8 			; <UNDEFINED> instruction: 0x000004b8
	...
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	211f0002 	tstcs	pc, r2
  c8:	00040000 	andeq	r0, r4, r0
  cc:	00000000 	andeq	r0, r0, r0
  d0:	00008d38 	andeq	r8, r0, r8, lsr sp
  d4:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	21450002 	cmpcs	r5, r2
  e8:	00040000 	andeq	r0, r4, r0
  ec:	00000000 	andeq	r0, r0, r0
  f0:	00008f44 	andeq	r8, r0, r4, asr #30
  f4:	00000004 	andeq	r0, r0, r4
	...
 100:	00000014 	andeq	r0, r0, r4, lsl r0
 104:	216b0002 	cmncs	fp, r2
 108:	00040000 	andeq	r0, r4, r0
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffff4c <__bss_end+0xffff6f10>
       4:	63732f65 	cmnvs	r3, #404	; 0x194
       8:	6b6e6568 	blvs	1b995b0 <__bss_end+0x1b90574>
       c:	736f2f6a 	cmnvc	pc, #424	; 0x1a8
      10:	32323032 	eorscc	r3, r2, #50	; 0x32
      14:	2f70732f 	svccs	0x0070732f
      18:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
      1c:	2f736563 	svccs	0x00736563
      20:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
      24:	63617073 	cmnvs	r1, #115	; 0x73
      28:	72632f65 	rsbvc	r2, r3, #404	; 0x194
      2c:	732e3074 			; <UNDEFINED> instruction: 0x732e3074
      30:	6f682f00 	svcvs	0x00682f00
      34:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
      38:	6e656863 	cdpvs	8, 6, cr6, cr5, cr3, {3}
      3c:	6f2f6a6b 	svcvs	0x002f6a6b
      40:	32303273 	eorscc	r3, r0, #805306375	; 0x30000007
      44:	70732f32 	rsbsvc	r2, r3, r2, lsr pc
      48:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffd21 <__bss_end+0xffff6ce5>
      4c:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
      50:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
      54:	61707372 	cmnvs	r0, r2, ror r3
      58:	622f6563 	eorvs	r6, pc, #415236096	; 0x18c00000
      5c:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
      60:	554e4700 	strbpl	r4, [lr, #-1792]	; 0xfffff900
      64:	20534120 	subscs	r4, r3, r0, lsr #2
      68:	34332e32 	ldrtcc	r2, [r3], #-3634	; 0xfffff1ce
      6c:	6f682f00 	svcvs	0x00682f00
      70:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
      74:	6e656863 	cdpvs	8, 6, cr6, cr5, cr3, {3}
      78:	6f2f6a6b 	svcvs	0x002f6a6b
      7c:	32303273 	eorscc	r3, r0, #805306375	; 0x30000007
      80:	70732f32 	rsbsvc	r2, r3, r2, lsr pc
      84:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffd5d <__bss_end+0xffff6d21>
      88:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
      8c:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
      90:	61707372 	cmnvs	r0, r2, ror r3
      94:	632f6563 			; <UNDEFINED> instruction: 0x632f6563
      98:	2e307472 	mrccs	4, 1, r7, cr0, cr2, {3}
      9c:	5f5f0063 	svcpl	0x005f0063
      a0:	30747263 	rsbscc	r7, r4, r3, ror #4
      a4:	696e695f 	stmdbvs	lr!, {r0, r1, r2, r3, r4, r6, r8, fp, sp, lr}^
      a8:	73625f74 	cmnvc	r2, #116, 30	; 0x1d0
      ac:	5f5f0073 	svcpl	0x005f0073
      b0:	5f737362 	svcpl	0x00737362
      b4:	00646e65 	rsbeq	r6, r4, r5, ror #28
      b8:	20554e47 	subscs	r4, r5, r7, asr #28
      bc:	20373143 	eorscs	r3, r7, r3, asr #2
      c0:	2e322e39 	mrccs	14, 1, r2, cr2, cr9, {1}
      c4:	30322031 	eorscc	r2, r2, r1, lsr r0
      c8:	30313931 	eorscc	r3, r1, r1, lsr r9
      cc:	28203532 	stmdacs	r0!, {r1, r4, r5, r8, sl, ip, sp}
      d0:	656c6572 	strbvs	r6, [ip, #-1394]!	; 0xfffffa8e
      d4:	29657361 	stmdbcs	r5!, {r0, r5, r6, r8, r9, ip, sp, lr}^
      d8:	52415b20 	subpl	r5, r1, #32, 22	; 0x8000
      dc:	72612f4d 	rsbvc	r2, r1, #308	; 0x134
      e0:	2d392d6d 	ldccs	13, cr2, [r9, #-436]!	; 0xfffffe4c
      e4:	6e617262 	cdpvs	2, 6, cr7, cr1, cr2, {3}
      e8:	72206863 	eorvc	r6, r0, #6488064	; 0x630000
      ec:	73697665 	cmnvc	r9, #105906176	; 0x6500000
      f0:	206e6f69 	rsbcs	r6, lr, r9, ror #30
      f4:	35373732 	ldrcc	r3, [r7, #-1842]!	; 0xfffff8ce
      f8:	205d3939 	subscs	r3, sp, r9, lsr r9
      fc:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
     100:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
     104:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
     108:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
     10c:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
     110:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
     114:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
     118:	6f6c666d 	svcvs	0x006c666d
     11c:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
     120:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
     124:	20647261 	rsbcs	r7, r4, r1, ror #4
     128:	70666d2d 	rsbvc	r6, r6, sp, lsr #26
     12c:	66763d75 			; <UNDEFINED> instruction: 0x66763d75
     130:	6d2d2070 	stcvs	0, cr2, [sp, #-448]!	; 0xfffffe40
     134:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
     138:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
     13c:	36373131 			; <UNDEFINED> instruction: 0x36373131
     140:	2d667a6a 	vstmdbcs	r6!, {s15-s120}
     144:	6d2d2073 	stcvs	0, cr2, [sp, #-460]!	; 0xfffffe34
     148:	206d7261 	rsbcs	r7, sp, r1, ror #4
     14c:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
     150:	613d6863 	teqvs	sp, r3, ror #16
     154:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
     158:	662b6b7a 			; <UNDEFINED> instruction: 0x662b6b7a
     15c:	672d2070 			; <UNDEFINED> instruction: 0x672d2070
     160:	20672d20 	rsbcs	r2, r7, r0, lsr #26
     164:	20304f2d 	eorscs	r4, r0, sp, lsr #30
     168:	00304f2d 	eorseq	r4, r0, sp, lsr #30
     16c:	75736572 	ldrbvc	r6, [r3, #-1394]!	; 0xfffffa8e
     170:	5f00746c 	svcpl	0x0000746c
     174:	7373625f 	cmnvc	r3, #-268435451	; 0xf0000005
     178:	6174735f 	cmnvs	r4, pc, asr r3
     17c:	62007472 	andvs	r7, r0, #1912602624	; 0x72000000
     180:	6e696765 	cdpvs	7, 6, cr6, cr9, cr5, {3}
     184:	635f5f00 	cmpvs	pc, #0, 30
     188:	5f307472 	svcpl	0x00307472
     18c:	006e7572 	rsbeq	r7, lr, r2, ror r5
     190:	75675f5f 	strbvc	r5, [r7, #-3935]!	; 0xfffff0a1
     194:	00647261 	rsbeq	r7, r4, r1, ror #4
     198:	65615f5f 	strbvs	r5, [r1, #-3935]!	; 0xfffff0a1
     19c:	5f696261 	svcpl	0x00696261
     1a0:	69776e75 	ldmdbvs	r7!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
     1a4:	635f646e 	cmpvs	pc, #1845493760	; 0x6e000000
     1a8:	705f7070 	subsvc	r7, pc, r0, ror r0	; <UNPREDICTABLE>
     1ac:	5f003172 	svcpl	0x00003172
     1b0:	5f707063 	svcpl	0x00707063
     1b4:	74756873 	ldrbtvc	r6, [r5], #-2163	; 0xfffff78d
     1b8:	6e776f64 	cdpvs	15, 7, cr6, cr7, cr4, {3}
     1bc:	706e6600 	rsbvc	r6, lr, r0, lsl #12
     1c0:	5f007274 	svcpl	0x00007274
     1c4:	7878635f 	ldmdavc	r8!, {r0, r1, r2, r3, r4, r6, r8, r9, sp, lr}^
     1c8:	76696261 	strbtvc	r6, [r9], -r1, ror #4
     1cc:	5f5f0031 	svcpl	0x005f0031
     1d0:	5f617863 	svcpl	0x00617863
     1d4:	65727570 	ldrbvs	r7, [r2, #-1392]!	; 0xfffffa90
     1d8:	7269765f 	rsbvc	r7, r9, #99614720	; 0x5f00000
     1dc:	6c617574 	cfstr64vs	mvdx7, [r1], #-464	; 0xfffffe30
     1e0:	635f5f00 	cmpvs	pc, #0, 30
     1e4:	675f6178 			; <UNDEFINED> instruction: 0x675f6178
     1e8:	64726175 	ldrbtvs	r6, [r2], #-373	; 0xfffffe8b
     1ec:	6c65725f 	sfmvs	f7, 2, [r5], #-380	; 0xfffffe84
     1f0:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
     1f4:	6f682f00 	svcvs	0x00682f00
     1f8:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
     1fc:	6e656863 	cdpvs	8, 6, cr6, cr5, cr3, {3}
     200:	6f2f6a6b 	svcvs	0x002f6a6b
     204:	32303273 	eorscc	r3, r0, #805306375	; 0x30000007
     208:	70732f32 	rsbsvc	r2, r3, r2, lsr pc
     20c:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffee5 <__bss_end+0xffff6ea9>
     210:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     214:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
     218:	61707372 	cmnvs	r0, r2, ror r3
     21c:	632f6563 			; <UNDEFINED> instruction: 0x632f6563
     220:	62617878 	rsbvs	r7, r1, #120, 16	; 0x780000
     224:	70632e69 	rsbvc	r2, r3, r9, ror #28
     228:	5f5f0070 	svcpl	0x005f0070
     22c:	5f6f7364 	svcpl	0x006f7364
     230:	646e6168 	strbtvs	r6, [lr], #-360	; 0xfffffe98
     234:	5f00656c 	svcpl	0x0000656c
     238:	4f54445f 	svcmi	0x0054445f
     23c:	494c5f52 	stmdbmi	ip, {r1, r4, r6, r8, r9, sl, fp, ip, lr}^
     240:	5f5f5453 	svcpl	0x005f5453
     244:	554e4700 	strbpl	r4, [lr, #-1792]	; 0xfffff900
     248:	2b2b4320 	blcs	ad0ed0 <__bss_end+0xac7e94>
     24c:	39203431 	stmdbcc	r0!, {r0, r4, r5, sl, ip, sp}
     250:	312e322e 			; <UNDEFINED> instruction: 0x312e322e
     254:	31303220 	teqcc	r0, r0, lsr #4
     258:	32303139 	eorscc	r3, r0, #1073741838	; 0x4000000e
     25c:	72282035 	eorvc	r2, r8, #53	; 0x35
     260:	61656c65 	cmnvs	r5, r5, ror #24
     264:	20296573 	eorcs	r6, r9, r3, ror r5
     268:	4d52415b 	ldfmie	f4, [r2, #-364]	; 0xfffffe94
     26c:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
     270:	622d392d 	eorvs	r3, sp, #737280	; 0xb4000
     274:	636e6172 	cmnvs	lr, #-2147483620	; 0x8000001c
     278:	65722068 	ldrbvs	r2, [r2, #-104]!	; 0xffffff98
     27c:	69736976 	ldmdbvs	r3!, {r1, r2, r4, r5, r6, r8, fp, sp, lr}^
     280:	32206e6f 	eorcc	r6, r0, #1776	; 0x6f0
     284:	39353737 	ldmdbcc	r5!, {r0, r1, r2, r4, r5, r8, r9, sl, ip, sp}
     288:	2d205d39 	stccs	13, cr5, [r0, #-228]!	; 0xffffff1c
     28c:	6f6c666d 	svcvs	0x006c666d
     290:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
     294:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
     298:	20647261 	rsbcs	r7, r4, r1, ror #4
     29c:	70666d2d 	rsbvc	r6, r6, sp, lsr #26
     2a0:	66763d75 			; <UNDEFINED> instruction: 0x66763d75
     2a4:	6d2d2070 	stcvs	0, cr2, [sp, #-448]!	; 0xfffffe40
     2a8:	616f6c66 	cmnvs	pc, r6, ror #24
     2ac:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
     2b0:	61683d69 	cmnvs	r8, r9, ror #26
     2b4:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
     2b8:	7570666d 	ldrbvc	r6, [r0, #-1645]!	; 0xfffff993
     2bc:	7066763d 	rsbvc	r7, r6, sp, lsr r6
     2c0:	746d2d20 	strbtvc	r2, [sp], #-3360	; 0xfffff2e0
     2c4:	3d656e75 	stclcc	14, cr6, [r5, #-468]!	; 0xfffffe2c
     2c8:	316d7261 	cmncc	sp, r1, ror #4
     2cc:	6a363731 	bvs	d8df98 <__bss_end+0xd84f5c>
     2d0:	732d667a 			; <UNDEFINED> instruction: 0x732d667a
     2d4:	616d2d20 	cmnvs	sp, r0, lsr #26
     2d8:	2d206d72 	stccs	13, cr6, [r0, #-456]!	; 0xfffffe38
     2dc:	6372616d 	cmnvs	r2, #1073741851	; 0x4000001b
     2e0:	72613d68 	rsbvc	r3, r1, #104, 26	; 0x1a00
     2e4:	7a36766d 	bvc	d9dca0 <__bss_end+0xd94c64>
     2e8:	70662b6b 	rsbvc	r2, r6, fp, ror #22
     2ec:	20672d20 	rsbcs	r2, r7, r0, lsr #26
     2f0:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
     2f4:	2d20304f 	stccs	0, cr3, [r0, #-316]!	; 0xfffffec4
     2f8:	2d20304f 	stccs	0, cr3, [r0, #-316]!	; 0xfffffec4
     2fc:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 16c <shift+0x16c>
     300:	65637865 	strbvs	r7, [r3, #-2149]!	; 0xfffff79b
     304:	6f697470 	svcvs	0x00697470
     308:	2d20736e 	stccs	3, cr7, [r0, #-440]!	; 0xfffffe48
     30c:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 17c <shift+0x17c>
     310:	69747472 	ldmdbvs	r4!, {r1, r4, r5, r6, sl, ip, sp, lr}^
     314:	635f5f00 	cmpvs	pc, #0, 30
     318:	675f6178 			; <UNDEFINED> instruction: 0x675f6178
     31c:	64726175 	ldrbtvs	r6, [r2], #-373	; 0xfffffe8b
     320:	6f62615f 	svcvs	0x0062615f
     324:	64007472 	strvs	r7, [r0], #-1138	; 0xfffffb8e
     328:	5f726f74 	svcpl	0x00726f74
     32c:	00727470 	rsbseq	r7, r2, r0, ror r4
     330:	54445f5f 	strbpl	r5, [r4], #-3935	; 0xfffff0a1
     334:	455f524f 	ldrbmi	r5, [pc, #-591]	; ed <shift+0xed>
     338:	5f5f444e 	svcpl	0x005f444e
     33c:	635f5f00 	cmpvs	pc, #0, 30
     340:	615f6178 	cmpvs	pc, r8, ror r1	; <UNPREDICTABLE>
     344:	69786574 	ldmdbvs	r8!, {r2, r4, r5, r6, r8, sl, sp, lr}^
     348:	5f5f0074 	svcpl	0x005f0074
     34c:	524f5443 	subpl	r5, pc, #1124073472	; 0x43000000
     350:	444e455f 	strbmi	r4, [lr], #-1375	; 0xfffffaa1
     354:	6c005f5f 	stcvs	15, cr5, [r0], {95}	; 0x5f
     358:	20676e6f 	rsbcs	r6, r7, pc, ror #28
     35c:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
     360:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
     364:	70635f00 	rsbvc	r5, r3, r0, lsl #30
     368:	74735f70 	ldrbtvc	r5, [r3], #-3952	; 0xfffff090
     36c:	75747261 	ldrbvc	r7, [r4, #-609]!	; 0xfffffd9f
     370:	5f5f0070 	svcpl	0x005f0070
     374:	524f5443 	subpl	r5, pc, #1124073472	; 0x43000000
     378:	53494c5f 	movtpl	r4, #40031	; 0x9c5f
     37c:	005f5f54 	subseq	r5, pc, r4, asr pc	; <UNPREDICTABLE>
     380:	726f7463 	rsbvc	r7, pc, #1660944384	; 0x63000000
     384:	7274705f 	rsbsvc	r7, r4, #95	; 0x5f
     388:	635f5f00 	cmpvs	pc, #0, 30
     38c:	675f6178 			; <UNDEFINED> instruction: 0x675f6178
     390:	64726175 	ldrbtvs	r6, [r2], #-373	; 0xfffffe8b
     394:	7163615f 	cmnvc	r3, pc, asr r1
     398:	65726975 	ldrbvs	r6, [r2, #-2421]!	; 0xfffff68b
     39c:	61575400 	cmpvs	r7, r0, lsl #8
     3a0:	6e697469 	cdpvs	4, 6, cr7, cr9, cr9, {3}
     3a4:	69465f67 	stmdbvs	r6, {r0, r1, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     3a8:	7300656c 	movwvc	r6, #1388	; 0x56c
     3ac:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     3b0:	6174735f 	cmnvs	r4, pc, asr r3
     3b4:	5f636974 	svcpl	0x00636974
     3b8:	6f697270 	svcvs	0x00697270
     3bc:	79746972 	ldmdbvc	r4!, {r1, r4, r5, r6, r8, fp, sp, lr}^
     3c0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     3c4:	4336314b 	teqmi	r6, #-1073741806	; 0xc0000012
     3c8:	636f7250 	cmnvs	pc, #80, 4
     3cc:	5f737365 	svcpl	0x00737365
     3d0:	616e614d 	cmnvs	lr, sp, asr #2
     3d4:	31726567 	cmncc	r2, r7, ror #10
     3d8:	74654738 	strbtvc	r4, [r5], #-1848	; 0xfffff8c8
     3dc:	6f72505f 	svcvs	0x0072505f
     3e0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     3e4:	5f79425f 	svcpl	0x0079425f
     3e8:	45444950 	strbmi	r4, [r4, #-2384]	; 0xfffff6b0
     3ec:	5a5f006a 	bpl	17c059c <__bss_end+0x17b7560>
     3f0:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     3f4:	636f7250 	cmnvs	pc, #80, 4
     3f8:	5f737365 	svcpl	0x00737365
     3fc:	616e614d 	cmnvs	lr, sp, asr #2
     400:	31726567 	cmncc	r2, r7, ror #10
     404:	70614d39 	rsbvc	r4, r1, r9, lsr sp
     408:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     40c:	6f545f65 	svcvs	0x00545f65
     410:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     414:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     418:	49355045 	ldmdbmi	r5!, {r0, r2, r6, ip, lr}
     41c:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     420:	6d6e5500 	cfstr64vs	mvdx5, [lr, #-0]
     424:	465f7061 	ldrbmi	r7, [pc], -r1, rrx
     428:	5f656c69 	svcpl	0x00656c69
     42c:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     430:	00746e65 	rsbseq	r6, r4, r5, ror #28
     434:	4b4e5a5f 	blmi	1396db8 <__bss_end+0x138dd7c>
     438:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     43c:	5f4f4950 	svcpl	0x004f4950
     440:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     444:	3172656c 	cmncc	r2, ip, ror #10
     448:	74654738 	strbtvc	r4, [r5], #-1848	; 0xfffff8c8
     44c:	4c50475f 	mrrcmi	7, 5, r4, r0, cr15
     450:	4c5f5645 	mrrcmi	6, 4, r5, pc, cr5	; <UNPREDICTABLE>
     454:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     458:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
     45c:	536a526a 	cmnpl	sl, #-1610612730	; 0xa0000006
     460:	5f005f30 	svcpl	0x00005f30
     464:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     468:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     46c:	61485f4f 	cmpvs	r8, pc, asr #30
     470:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     474:	52313172 	eorspl	r3, r1, #-2147483620	; 0x8000001c
     478:	72657365 	rsbvc	r7, r5, #-1811939327	; 0x94000001
     47c:	505f6576 	subspl	r6, pc, r6, ror r5	; <UNPREDICTABLE>
     480:	6a456e69 	bvs	115be2c <__bss_end+0x1152df0>
     484:	65006262 	strvs	r6, [r0, #-610]	; 0xfffffd9e
     488:	5f746978 	svcpl	0x00746978
     48c:	65646f63 	strbvs	r6, [r4, #-3939]!	; 0xfffff09d
     490:	53466700 	movtpl	r6, #26368	; 0x6700
     494:	6972445f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, sl, lr}^
     498:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
     49c:	6e614800 	cdpvs	8, 6, cr4, cr1, cr0, {0}
     4a0:	5f656c64 	svcpl	0x00656c64
     4a4:	636f7250 	cmnvs	pc, #80, 4
     4a8:	5f737365 	svcpl	0x00737365
     4ac:	00495753 	subeq	r5, r9, r3, asr r7
     4b0:	5f746547 	svcpl	0x00746547
     4b4:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     4b8:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     4bc:	6e495f72 	mcrvs	15, 2, r5, cr9, cr2, {3}
     4c0:	4d006f66 	stcmi	15, cr6, [r0, #-408]	; 0xfffffe68
     4c4:	465f7061 	ldrbmi	r7, [pc], -r1, rrx
     4c8:	5f656c69 	svcpl	0x00656c69
     4cc:	435f6f54 	cmpmi	pc, #84, 30	; 0x150
     4d0:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     4d4:	5a00746e 	bpl	1d694 <__bss_end+0x14658>
     4d8:	69626d6f 	stmdbvs	r2!, {r0, r1, r2, r3, r5, r6, r8, sl, fp, sp, lr}^
     4dc:	656e0065 	strbvs	r0, [lr, #-101]!	; 0xffffff9b
     4e0:	43007478 	movwmi	r7, #1144	; 0x478
     4e4:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     4e8:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     4ec:	73006d65 	movwvc	r6, #3429	; 0xd65
     4f0:	6c5f736f 	mrrcvs	3, 6, r7, pc, cr15	; <UNPREDICTABLE>
     4f4:	49006465 	stmdbmi	r0, {r0, r2, r5, r6, sl, sp, lr}
     4f8:	6c61766e 	stclvs	6, cr7, [r1], #-440	; 0xfffffe48
     4fc:	485f6469 	ldmdami	pc, {r0, r3, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     500:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     504:	75520065 	ldrbvc	r0, [r2, #-101]	; 0xffffff9b
     508:	6e696e6e 	cdpvs	14, 6, cr6, cr9, cr14, {3}
     50c:	65440067 	strbvs	r0, [r4, #-103]	; 0xffffff99
     510:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     514:	555f656e 	ldrbpl	r6, [pc, #-1390]	; ffffffae <__bss_end+0xffff6f72>
     518:	6168636e 	cmnvs	r8, lr, ror #6
     51c:	6465676e 	strbtvs	r6, [r5], #-1902	; 0xfffff892
     520:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     524:	46433131 			; <UNDEFINED> instruction: 0x46433131
     528:	73656c69 	cmnvc	r5, #26880	; 0x6900
     52c:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     530:	4930316d 	ldmdbmi	r0!, {r0, r2, r3, r5, r6, r8, ip, sp}
     534:	6974696e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, fp, sp, lr}^
     538:	7a696c61 	bvc	1a5b6c4 <__bss_end+0x1a52688>
     53c:	00764565 	rsbseq	r4, r6, r5, ror #10
     540:	6e756f6d 	cdpvs	15, 7, cr6, cr5, cr13, {3}
     544:	696f5074 	stmdbvs	pc!, {r2, r4, r5, r6, ip, lr}^	; <UNPREDICTABLE>
     548:	4700746e 	strmi	r7, [r0, -lr, ror #8]
     54c:	435f7465 	cmpmi	pc, #1694498816	; 0x65000000
     550:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     554:	505f746e 	subspl	r7, pc, lr, ror #8
     558:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     55c:	47007373 	smlsdxmi	r0, r3, r3, r7
     560:	5f4f4950 	svcpl	0x004f4950
     564:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     568:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     56c:	50433631 	subpl	r3, r3, r1, lsr r6
     570:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     574:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 3b0 <shift+0x3b0>
     578:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     57c:	34317265 	ldrtcc	r7, [r1], #-613	; 0xfffffd9b
     580:	61657243 	cmnvs	r5, r3, asr #4
     584:	505f6574 	subspl	r6, pc, r4, ror r5	; <UNPREDICTABLE>
     588:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     58c:	50457373 	subpl	r7, r5, r3, ror r3
     590:	00626a68 	rsbeq	r6, r2, r8, ror #20
     594:	5f746553 	svcpl	0x00746553
     598:	61726150 	cmnvs	r2, r0, asr r1
     59c:	7000736d 	andvc	r7, r0, sp, ror #6
     5a0:	00766572 	rsbseq	r6, r6, r2, ror r5
     5a4:	4b4e5a5f 	blmi	1396f28 <__bss_end+0x138deec>
     5a8:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     5ac:	5f4f4950 	svcpl	0x004f4950
     5b0:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     5b4:	3272656c 	rsbscc	r6, r2, #108, 10	; 0x1b000000
     5b8:	74654736 	strbtvc	r4, [r5], #-1846	; 0xfffff8ca
     5bc:	5f50475f 	svcpl	0x0050475f
     5c0:	5f515249 	svcpl	0x00515249
     5c4:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     5c8:	4c5f7463 	cfldrdmi	mvd7, [pc], {99}	; 0x63
     5cc:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     5d0:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
     5d4:	4e30326a 	cdpmi	2, 3, cr3, cr0, cr10, {3}
     5d8:	4f495047 	svcmi	0x00495047
     5dc:	746e495f 	strbtvc	r4, [lr], #-2399	; 0xfffff6a1
     5e0:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     5e4:	545f7470 	ldrbpl	r7, [pc], #-1136	; 5ec <shift+0x5ec>
     5e8:	52657079 	rsbpl	r7, r5, #121	; 0x79
     5ec:	5f31536a 	svcpl	0x0031536a
     5f0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     5f4:	4336314b 	teqmi	r6, #-1073741806	; 0xc0000012
     5f8:	636f7250 	cmnvs	pc, #80, 4
     5fc:	5f737365 	svcpl	0x00737365
     600:	616e614d 	cmnvs	lr, sp, asr #2
     604:	31726567 	cmncc	r2, r7, ror #10
     608:	74654739 	strbtvc	r4, [r5], #-1849	; 0xfffff8c7
     60c:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     610:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     614:	6f72505f 	svcvs	0x0072505f
     618:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     61c:	54007645 	strpl	r7, [r0], #-1605	; 0xfffff9bb
     620:	545f5346 	ldrbpl	r5, [pc], #-838	; 628 <shift+0x628>
     624:	5f656572 	svcpl	0x00656572
     628:	65646f4e 	strbvs	r6, [r4, #-3918]!	; 0xfffff0b2
     62c:	74655300 	strbtvc	r5, [r5], #-768	; 0xfffffd00
     630:	74754f5f 	ldrbtvc	r4, [r5], #-3935	; 0xfffff0a1
     634:	00747570 	rsbseq	r7, r4, r0, ror r5
     638:	76697264 	strbtvc	r7, [r9], -r4, ror #4
     63c:	695f7265 	ldmdbvs	pc, {r0, r2, r5, r6, r9, ip, sp, lr}^	; <UNPREDICTABLE>
     640:	52007864 	andpl	r7, r0, #100, 16	; 0x640000
     644:	5f646165 	svcpl	0x00646165
     648:	796c6e4f 	stmdbvc	ip!, {r0, r1, r2, r3, r6, r9, sl, fp, sp, lr}^
     64c:	6f687300 	svcvs	0x00687300
     650:	625f7472 	subsvs	r7, pc, #1912602624	; 0x72000000
     654:	6b6e696c 	blvs	1b9ac0c <__bss_end+0x1b91bd0>
     658:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     65c:	6f72505f 	svcvs	0x0072505f
     660:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     664:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
     668:	5f64656e 	svcpl	0x0064656e
     66c:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     670:	43540073 	cmpmi	r4, #115	; 0x73
     674:	435f5550 	cmpmi	pc, #80, 10	; 0x14000000
     678:	65746e6f 	ldrbvs	r6, [r4, #-3695]!	; 0xfffff191
     67c:	5f007478 	svcpl	0x00007478
     680:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     684:	6f725043 	svcvs	0x00725043
     688:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     68c:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     690:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     694:	68635338 	stmdavs	r3!, {r3, r4, r5, r8, r9, ip, lr}^
     698:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     69c:	00764565 	rsbseq	r4, r6, r5, ror #10
     6a0:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     6a4:	6c417966 	mcrrvs	9, 6, r7, r1, cr6	; <UNPREDICTABLE>
     6a8:	6c42006c 	mcrrvs	0, 6, r0, r2, cr12
     6ac:	5f6b636f 	svcpl	0x006b636f
     6b0:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     6b4:	5f746e65 	svcpl	0x00746e65
     6b8:	636f7250 	cmnvs	pc, #80, 4
     6bc:	00737365 	rsbseq	r7, r3, r5, ror #6
     6c0:	5f746547 	svcpl	0x00746547
     6c4:	00444950 	subeq	r4, r4, r0, asr r9
     6c8:	746e6975 	strbtvc	r6, [lr], #-2421	; 0xfffff68b
     6cc:	745f3233 	ldrbvc	r3, [pc], #-563	; 6d4 <shift+0x6d4>
     6d0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     6d4:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     6d8:	5f4f4950 	svcpl	0x004f4950
     6dc:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     6e0:	3972656c 	ldmdbcc	r2!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     6e4:	5f746547 	svcpl	0x00746547
     6e8:	75706e49 	ldrbvc	r6, [r0, #-3657]!	; 0xfffff1b7
     6ec:	006a4574 	rsbeq	r4, sl, r4, ror r5
     6f0:	314e5a5f 	cmpcc	lr, pc, asr sl
     6f4:	50474333 	subpl	r4, r7, r3, lsr r3
     6f8:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     6fc:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     700:	30317265 	eorscc	r7, r1, r5, ror #4
     704:	5f746553 	svcpl	0x00746553
     708:	7074754f 	rsbsvc	r7, r4, pc, asr #10
     70c:	6a457475 	bvs	115d8e8 <__bss_end+0x11548ac>
     710:	494e0062 	stmdbmi	lr, {r1, r5, r6}^
     714:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
     718:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
     71c:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
     720:	42006e6f 	andmi	r6, r0, #1776	; 0x6f0
     724:	5f314353 	svcpl	0x00314353
     728:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     72c:	69615700 	stmdbvs	r1!, {r8, r9, sl, ip, lr}^
     730:	544e0074 	strbpl	r0, [lr], #-116	; 0xffffff8c
     734:	5f6b7361 	svcpl	0x006b7361
     738:	74617453 	strbtvc	r7, [r1], #-1107	; 0xfffffbad
     73c:	69660065 	stmdbvs	r6!, {r0, r2, r5, r6}^
     740:	5300656c 	movwpl	r6, #1388	; 0x56c
     744:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     748:	5f656c75 	svcpl	0x00656c75
     74c:	00464445 	subeq	r4, r6, r5, asr #8
     750:	636f6c42 	cmnvs	pc, #16896	; 0x4200
     754:	0064656b 	rsbeq	r6, r4, fp, ror #10
     758:	7275436d 	rsbsvc	r4, r5, #-1275068415	; 0xb4000001
     75c:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     760:	7361545f 	cmnvc	r1, #1593835520	; 0x5f000000
     764:	6f4e5f6b 	svcvs	0x004e5f6b
     768:	5f006564 	svcpl	0x00006564
     76c:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     770:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     774:	61485f4f 	cmpvs	r8, pc, asr #30
     778:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     77c:	45344372 	ldrmi	r4, [r4, #-882]!	; 0xfffffc8e
     780:	6863006a 	stmdavs	r3!, {r1, r3, r5, r6}^
     784:	745f7261 	ldrbvc	r7, [pc], #-609	; 78c <shift+0x78c>
     788:	5f6b6369 	svcpl	0x006b6369
     78c:	616c6564 	cmnvs	ip, r4, ror #10
     790:	526d0079 	rsbpl	r0, sp, #121	; 0x79
     794:	5f746f6f 	svcpl	0x00746f6f
     798:	00766544 	rsbseq	r6, r6, r4, asr #10
     79c:	314e5a5f 	cmpcc	lr, pc, asr sl
     7a0:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     7a4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     7a8:	614d5f73 	hvcvs	54771	; 0xd5f3
     7ac:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     7b0:	77533972 			; <UNDEFINED> instruction: 0x77533972
     7b4:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
     7b8:	456f545f 	strbmi	r5, [pc, #-1119]!	; 361 <shift+0x361>
     7bc:	43383150 	teqmi	r8, #80, 2
     7c0:	636f7250 	cmnvs	pc, #80, 4
     7c4:	5f737365 	svcpl	0x00737365
     7c8:	7473694c 	ldrbtvc	r6, [r3], #-2380	; 0xfffff6b4
     7cc:	646f4e5f 	strbtvs	r4, [pc], #-3679	; 7d4 <shift+0x7d4>
     7d0:	69700065 	ldmdbvs	r0!, {r0, r2, r5, r6}^
     7d4:	64695f6e 	strbtvs	r5, [r9], #-3950	; 0xfffff092
     7d8:	70630078 	rsbvc	r0, r3, r8, ror r0
     7dc:	6f635f75 	svcvs	0x00635f75
     7e0:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
     7e4:	476d0074 			; <UNDEFINED> instruction: 0x476d0074
     7e8:	004f4950 	subeq	r4, pc, r0, asr r9	; <UNPREDICTABLE>
     7ec:	61657243 	cmnvs	r5, r3, asr #4
     7f0:	505f6574 	subspl	r6, pc, r4, ror r5	; <UNPREDICTABLE>
     7f4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     7f8:	5f007373 	svcpl	0x00007373
     7fc:	314b4e5a 	cmpcc	fp, sl, asr lr
     800:	50474333 	subpl	r4, r7, r3, lsr r3
     804:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     808:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     80c:	39317265 	ldmdbcc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     810:	5f746547 	svcpl	0x00746547
     814:	53465047 	movtpl	r5, #24647	; 0x6047
     818:	4c5f4c45 	mrrcmi	12, 4, r4, pc, cr5	; <UNPREDICTABLE>
     81c:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     820:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
     824:	536a526a 	cmnpl	sl, #-1610612730	; 0xa0000006
     828:	4f005f30 	svcmi	0x00005f30
     82c:	006e6570 	rsbeq	r6, lr, r0, ror r5
     830:	69447369 	stmdbvs	r4, {r0, r3, r5, r6, r8, r9, ip, sp, lr}^
     834:	74636572 	strbtvc	r6, [r3], #-1394	; 0xfffffa8e
     838:	0079726f 	rsbseq	r7, r9, pc, ror #4
     83c:	5f746547 	svcpl	0x00746547
     840:	4c435047 	mcrrmi	0, 4, r5, r3, cr7
     844:	6f4c5f52 	svcvs	0x004c5f52
     848:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     84c:	54006e6f 	strpl	r6, [r0], #-3695	; 0xfffff191
     850:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     854:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     858:	46670065 	strbtmi	r0, [r7], -r5, rrx
     85c:	72445f53 	subvc	r5, r4, #332	; 0x14c
     860:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     864:	6f435f73 	svcvs	0x00435f73
     868:	00746e75 	rsbseq	r6, r4, r5, ror lr
     86c:	49504773 	ldmdbmi	r0, {r0, r1, r4, r5, r6, r8, r9, sl, lr}^
     870:	6547004f 	strbvs	r0, [r7, #-79]	; 0xffffffb1
     874:	50475f74 	subpl	r5, r7, r4, ror pc
     878:	5f534445 	svcpl	0x00534445
     87c:	61636f4c 	cmnvs	r3, ip, asr #30
     880:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     884:	74756200 	ldrbtvc	r6, [r5], #-512	; 0xfffffe00
     888:	006e6f74 	rsbeq	r6, lr, r4, ror pc
     88c:	5f746553 	svcpl	0x00746553
     890:	4f495047 	svcmi	0x00495047
     894:	6e75465f 	mrcvs	6, 3, r4, cr5, cr15, {2}
     898:	6f697463 	svcvs	0x00697463
     89c:	5a5f006e 	bpl	17c0a5c <__bss_end+0x17b7a20>
     8a0:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     8a4:	636f7250 	cmnvs	pc, #80, 4
     8a8:	5f737365 	svcpl	0x00737365
     8ac:	616e614d 	cmnvs	lr, sp, asr #2
     8b0:	31726567 	cmncc	r2, r7, ror #10
     8b4:	746f4e34 	strbtvc	r4, [pc], #-3636	; 8bc <shift+0x8bc>
     8b8:	5f796669 	svcpl	0x00796669
     8bc:	636f7250 	cmnvs	pc, #80, 4
     8c0:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
     8c4:	54323150 	ldrtpl	r3, [r2], #-336	; 0xfffffeb0
     8c8:	6b736154 	blvs	1cd8e20 <__bss_end+0x1ccfde4>
     8cc:	7274535f 	rsbsvc	r5, r4, #2080374785	; 0x7c000001
     8d0:	00746375 	rsbseq	r6, r4, r5, ror r3
     8d4:	5f746547 	svcpl	0x00746547
     8d8:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     8dc:	6e495f64 	cdpvs	15, 4, cr5, cr9, cr4, {3}
     8e0:	49006f66 	stmdbmi	r0, {r1, r2, r5, r6, r8, r9, sl, fp, sp, lr}
     8e4:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
     8e8:	72655400 	rsbvc	r5, r5, #0, 8
     8ec:	616e696d 	cmnvs	lr, sp, ror #18
     8f0:	52006574 	andpl	r6, r0, #116, 10	; 0x1d000000
     8f4:	616e6e75 	smcvs	59109	; 0xe6e5
     8f8:	00656c62 	rsbeq	r6, r5, r2, ror #24
     8fc:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     900:	505f7966 	subspl	r7, pc, r6, ror #18
     904:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     908:	5f007373 	svcpl	0x00007373
     90c:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     910:	6f725043 	svcvs	0x00725043
     914:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     918:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     91c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     920:	76453443 	strbvc	r3, [r5], -r3, asr #8
     924:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     928:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
     92c:	4f495047 	svcmi	0x00495047
     930:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     934:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     938:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
     93c:	50475f74 	subpl	r5, r7, r4, ror pc
     940:	5f544553 	svcpl	0x00544553
     944:	61636f4c 	cmnvs	r3, ip, asr #30
     948:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     94c:	6a526a45 	bvs	149b268 <__bss_end+0x149222c>
     950:	005f3053 	subseq	r3, pc, r3, asr r0	; <UNPREDICTABLE>
     954:	636f4c6d 	cmnvs	pc, #27904	; 0x6d00
     958:	526d006b 	rsbpl	r0, sp, #107	; 0x6b
     95c:	5f746f6f 	svcpl	0x00746f6f
     960:	00746e4d 	rsbseq	r6, r4, sp, asr #28
     964:	4b4e5a5f 	blmi	13972e8 <__bss_end+0x138e2ac>
     968:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     96c:	5f4f4950 	svcpl	0x004f4950
     970:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     974:	3272656c 	rsbscc	r6, r2, #108, 10	; 0x1b000000
     978:	74654732 	strbtvc	r4, [r5], #-1842	; 0xfffff8ce
     97c:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     980:	65746365 	ldrbvs	r6, [r4, #-869]!	; 0xfffffc9b
     984:	76455f64 	strbvc	r5, [r5], -r4, ror #30
     988:	5f746e65 	svcpl	0x00746e65
     98c:	456e6950 	strbmi	r6, [lr, #-2384]!	; 0xfffff6b0
     990:	5a5f0076 	bpl	17c0b70 <__bss_end+0x17b7b34>
     994:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     998:	4f495047 	svcmi	0x00495047
     99c:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     9a0:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     9a4:	6e453931 			; <UNDEFINED> instruction: 0x6e453931
     9a8:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     9ac:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     9b0:	445f746e 	ldrbmi	r7, [pc], #-1134	; 9b8 <shift+0x9b8>
     9b4:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     9b8:	326a4574 	rsbcc	r4, sl, #116, 10	; 0x1d000000
     9bc:	50474e30 	subpl	r4, r7, r0, lsr lr
     9c0:	495f4f49 	ldmdbmi	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     9c4:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     9c8:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     9cc:	7079545f 	rsbsvc	r5, r9, pc, asr r4
     9d0:	6f4e0065 	svcvs	0x004e0065
     9d4:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     9d8:	69726400 	ldmdbvs	r2!, {sl, sp, lr}^
     9dc:	00726576 	rsbseq	r6, r2, r6, ror r5
     9e0:	61656c43 	cmnvs	r5, r3, asr #24
     9e4:	65445f72 	strbvs	r5, [r4, #-3954]	; 0xfffff08e
     9e8:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     9ec:	455f6465 	ldrbmi	r6, [pc, #-1125]	; 58f <shift+0x58f>
     9f0:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     9f4:	6e614800 	cdpvs	8, 6, cr4, cr1, cr0, {0}
     9f8:	5f656c64 	svcpl	0x00656c64
     9fc:	00515249 	subseq	r5, r1, r9, asr #4
     a00:	5078614d 	rsbspl	r6, r8, sp, asr #2
     a04:	4c687461 	cfstrdmi	mvd7, [r8], #-388	; 0xfffffe7c
     a08:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
     a0c:	5a5f0068 	bpl	17c0bb4 <__bss_end+0x17b7b78>
     a10:	33314b4e 	teqcc	r1, #79872	; 0x13800
     a14:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     a18:	61485f4f 	cmpvs	r8, pc, asr #30
     a1c:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     a20:	47383172 			; <UNDEFINED> instruction: 0x47383172
     a24:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     a28:	53444550 	movtpl	r4, #17744	; 0x4550
     a2c:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     a30:	6f697461 	svcvs	0x00697461
     a34:	526a456e 	rsbpl	r4, sl, #461373440	; 0x1b800000
     a38:	5f30536a 	svcpl	0x0030536a
     a3c:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     a40:	72445346 	subvc	r5, r4, #402653185	; 0x18000001
     a44:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     a48:	656d614e 	strbvs	r6, [sp, #-334]!	; 0xfffffeb2
     a4c:	676e654c 	strbvs	r6, [lr, -ip, asr #10]!
     a50:	6d006874 	stcvs	8, cr6, [r0, #-464]	; 0xfffffe30
     a54:	5f6e6950 	svcpl	0x006e6950
     a58:	65736552 	ldrbvs	r6, [r3, #-1362]!	; 0xfffffaae
     a5c:	74617672 	strbtvc	r7, [r1], #-1650	; 0xfffff98e
     a60:	736e6f69 	cmnvc	lr, #420	; 0x1a4
     a64:	6972575f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, ip, lr}^
     a68:	5f006574 	svcpl	0x00006574
     a6c:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     a70:	6f725043 	svcvs	0x00725043
     a74:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     a78:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     a7c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     a80:	63533131 	cmpvs	r3, #1073741836	; 0x4000000c
     a84:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     a88:	525f656c 	subspl	r6, pc, #108, 10	; 0x1b000000
     a8c:	00764552 	rsbseq	r4, r6, r2, asr r5
     a90:	7465474e 	strbtvc	r4, [r5], #-1870	; 0xfffff8b2
     a94:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     a98:	495f6465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     a9c:	5f6f666e 	svcpl	0x006f666e
     aa0:	65707954 	ldrbvs	r7, [r0, #-2388]!	; 0xfffff6ac
     aa4:	656c7300 	strbvs	r7, [ip, #-768]!	; 0xfffffd00
     aa8:	745f7065 	ldrbvc	r7, [pc], #-101	; ab0 <shift+0xab0>
     aac:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     ab0:	49504700 	ldmdbmi	r0, {r8, r9, sl, lr}^
     ab4:	69505f4f 	ldmdbvs	r0, {r0, r1, r2, r3, r6, r8, r9, sl, fp, ip, lr}^
     ab8:	6f435f6e 	svcvs	0x00435f6e
     abc:	00746e75 	rsbseq	r6, r4, r5, ror lr
     ac0:	6b736174 	blvs	1cd9098 <__bss_end+0x1cd005c>
     ac4:	69615700 	stmdbvs	r1!, {r8, r9, sl, ip, lr}^
     ac8:	6f465f74 	svcvs	0x00465f74
     acc:	76455f72 			; <UNDEFINED> instruction: 0x76455f72
     ad0:	00746e65 	rsbseq	r6, r4, r5, ror #28
     ad4:	5f746547 	svcpl	0x00746547
     ad8:	4f495047 	svcmi	0x00495047
     adc:	6e75465f 	mrcvs	6, 3, r4, cr5, cr15, {2}
     ae0:	6f697463 	svcvs	0x00697463
     ae4:	6f62006e 	svcvs	0x0062006e
     ae8:	5f006c6f 	svcpl	0x00006c6f
     aec:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     af0:	6f725043 	svcvs	0x00725043
     af4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     af8:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     afc:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     b00:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
     b04:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     b08:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     b0c:	5f72656c 	svcpl	0x0072656c
     b10:	6f666e49 	svcvs	0x00666e49
     b14:	4e303245 	cdpmi	2, 3, cr3, cr0, cr5, {2}
     b18:	5f746547 	svcpl	0x00746547
     b1c:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     b20:	6e495f64 	cdpvs	15, 4, cr5, cr9, cr4, {3}
     b24:	545f6f66 	ldrbpl	r6, [pc], #-3942	; b2c <shift+0xb2c>
     b28:	50657079 	rsbpl	r7, r5, r9, ror r0
     b2c:	52540076 	subspl	r0, r4, #118	; 0x76
     b30:	425f474e 	subsmi	r4, pc, #20447232	; 0x1380000
     b34:	00657361 	rsbeq	r7, r5, r1, ror #6
     b38:	61666544 	cmnvs	r6, r4, asr #10
     b3c:	5f746c75 	svcpl	0x00746c75
     b40:	636f6c43 	cmnvs	pc, #17152	; 0x4300
     b44:	61525f6b 	cmpvs	r2, fp, ror #30
     b48:	6d006574 	cfstr32vs	mvfx6, [r0, #-464]	; 0xfffffe30
     b4c:	746f6f52 	strbtvc	r6, [pc], #-3922	; b54 <shift+0xb54>
     b50:	7379535f 	cmnvc	r9, #2080374785	; 0x7c000001
     b54:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     b58:	5350475f 	cmppl	r0, #24903680	; 0x17c0000
     b5c:	4c5f5445 	cfldrdmi	mvd5, [pc], {69}	; 0x45
     b60:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     b64:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     b68:	6f72506d 	svcvs	0x0072506d
     b6c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     b70:	73694c5f 	cmnvc	r9, #24320	; 0x5f00
     b74:	65485f74 	strbvs	r5, [r8, #-3956]	; 0xfffff08c
     b78:	6d006461 	cfstrsvs	mvf6, [r0, #-388]	; 0xfffffe7c
     b7c:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     b80:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     b84:	636e465f 	cmnvs	lr, #99614720	; 0x5f00000
     b88:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     b8c:	50433631 	subpl	r3, r3, r1, lsr r6
     b90:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     b94:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 9d0 <shift+0x9d0>
     b98:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     b9c:	31327265 	teqcc	r2, r5, ror #4
     ba0:	636f6c42 	cmnvs	pc, #16896	; 0x4200
     ba4:	75435f6b 	strbvc	r5, [r3, #-3947]	; 0xfffff095
     ba8:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     bac:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     bb0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     bb4:	00764573 	rsbseq	r4, r6, r3, ror r5
     bb8:	6961576d 	stmdbvs	r1!, {r0, r2, r3, r5, r6, r8, r9, sl, ip, lr}^
     bbc:	676e6974 			; <UNDEFINED> instruction: 0x676e6974
     bc0:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     bc4:	4c007365 	stcmi	3, cr7, [r0], {101}	; 0x65
     bc8:	5f6b636f 	svcpl	0x006b636f
     bcc:	6f6c6e55 	svcvs	0x006c6e55
     bd0:	64656b63 	strbtvs	r6, [r5], #-2915	; 0xfffff49d
     bd4:	614c6d00 	cmpvs	ip, r0, lsl #26
     bd8:	505f7473 	subspl	r7, pc, r3, ror r4	; <UNPREDICTABLE>
     bdc:	5f004449 	svcpl	0x00004449
     be0:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     be4:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     be8:	61485f4f 	cmpvs	r8, pc, asr #30
     bec:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     bf0:	53373172 	teqpl	r7, #-2147483620	; 0x8000001c
     bf4:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     bf8:	5f4f4950 	svcpl	0x004f4950
     bfc:	636e7546 	cmnvs	lr, #293601280	; 0x11800000
     c00:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     c04:	34316a45 	ldrtcc	r6, [r1], #-2629	; 0xfffff5bb
     c08:	4950474e 	ldmdbmi	r0, {r1, r2, r3, r6, r8, r9, sl, lr}^
     c0c:	75465f4f 	strbvc	r5, [r6, #-3919]	; 0xfffff0b1
     c10:	6974636e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
     c14:	47006e6f 	strmi	r6, [r0, -pc, ror #28]
     c18:	495f7465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
     c1c:	7475706e 	ldrbtvc	r7, [r5], #-110	; 0xffffff92
     c20:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
     c24:	6e696c62 	cdpvs	12, 6, cr6, cr9, cr2, {3}
     c28:	5f00626b 	svcpl	0x0000626b
     c2c:	31314e5a 	teqcc	r1, sl, asr lr
     c30:	6c694643 	stclvs	6, cr4, [r9], #-268	; 0xfffffef4
     c34:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     c38:	346d6574 	strbtcc	r6, [sp], #-1396	; 0xfffffa8c
     c3c:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
     c40:	634b5045 	movtvs	r5, #45125	; 0xb045
     c44:	464e3531 			; <UNDEFINED> instruction: 0x464e3531
     c48:	5f656c69 	svcpl	0x00656c69
     c4c:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
     c50:	646f4d5f 	strbtvs	r4, [pc], #-3423	; c58 <shift+0xc58>
     c54:	77530065 	ldrbvc	r0, [r3, -r5, rrx]
     c58:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
     c5c:	006f545f 	rsbeq	r5, pc, pc, asr r4	; <UNPREDICTABLE>
     c60:	736f6c43 	cmnvc	pc, #17152	; 0x4300
     c64:	5a5f0065 	bpl	17c0e00 <__bss_end+0x17b7dc4>
     c68:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     c6c:	636f7250 	cmnvs	pc, #80, 4
     c70:	5f737365 	svcpl	0x00737365
     c74:	616e614d 	cmnvs	lr, sp, asr #2
     c78:	31726567 	cmncc	r2, r7, ror #10
     c7c:	68635332 	stmdavs	r3!, {r1, r4, r5, r8, r9, ip, lr}^
     c80:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     c84:	44455f65 	strbmi	r5, [r5], #-3941	; 0xfffff09b
     c88:	00764546 	rsbseq	r4, r6, r6, asr #10
     c8c:	5f746547 	svcpl	0x00746547
     c90:	454c5047 	strbmi	r5, [ip, #-71]	; 0xffffffb9
     c94:	6f4c5f56 	svcvs	0x004c5f56
     c98:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     c9c:	42006e6f 	andmi	r6, r0, #1776	; 0x6f0
     ca0:	5f304353 	svcpl	0x00304353
     ca4:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     ca8:	73695200 	cmnvc	r9, #0, 4
     cac:	5f676e69 	svcpl	0x00676e69
     cb0:	65676445 	strbvs	r6, [r7, #-1093]!	; 0xfffffbbb
     cb4:	67726100 	ldrbvs	r6, [r2, -r0, lsl #2]!
     cb8:	65520063 	ldrbvs	r0, [r2, #-99]	; 0xffffff9d
     cbc:	76726573 			; <UNDEFINED> instruction: 0x76726573
     cc0:	69505f65 	ldmdbvs	r0, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     cc4:	6948006e 	stmdbvs	r8, {r1, r2, r3, r5, r6}^
     cc8:	6e006867 	cdpvs	8, 0, cr6, cr0, cr7, {3}
     ccc:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     cd0:	5f646569 	svcpl	0x00646569
     cd4:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
     cd8:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     cdc:	67726100 	ldrbvs	r6, [r2, -r0, lsl #2]!
     ce0:	61460076 	hvcvs	24582	; 0x6006
     ce4:	6e696c6c 	cdpvs	12, 6, cr6, cr9, cr12, {3}
     ce8:	64455f67 	strbvs	r5, [r5], #-3943	; 0xfffff099
     cec:	5f006567 	svcpl	0x00006567
     cf0:	31314e5a 	teqcc	r1, sl, asr lr
     cf4:	6c694643 	stclvs	6, cr4, [r9], #-268	; 0xfffffef4
     cf8:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     cfc:	436d6574 	cmnmi	sp, #116, 10	; 0x1d000000
     d00:	00764534 	rsbseq	r4, r6, r4, lsr r5
     d04:	314e5a5f 	cmpcc	lr, pc, asr sl
     d08:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     d0c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     d10:	614d5f73 	hvcvs	54771	; 0xd5f3
     d14:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     d18:	4e343172 	mrcmi	1, 1, r3, cr4, cr2, {3}
     d1c:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     d20:	72505f79 	subsvc	r5, r0, #484	; 0x1e4
     d24:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     d28:	006a4573 	rsbeq	r4, sl, r3, ror r5
     d2c:	69466f4e 	stmdbvs	r6, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     d30:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     d34:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     d38:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     d3c:	73007265 	movwvc	r7, #613	; 0x265
     d40:	6c6e6970 			; <UNDEFINED> instruction: 0x6c6e6970
     d44:	5f6b636f 	svcpl	0x006b636f
     d48:	65470074 	strbvs	r0, [r7, #-116]	; 0xffffff8c
     d4c:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     d50:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     d54:	455f6465 	ldrbmi	r6, [pc, #-1125]	; 8f7 <shift+0x8f7>
     d58:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     d5c:	6e69505f 	mcrvs	0, 3, r5, cr9, cr15, {2}
     d60:	61654400 	cmnvs	r5, r0, lsl #8
     d64:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     d68:	61700065 	cmnvs	r0, r5, rrx
     d6c:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     d70:	73694400 	cmnvc	r9, #0, 8
     d74:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     d78:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     d7c:	445f746e 	ldrbmi	r7, [pc], #-1134	; d84 <shift+0xd84>
     d80:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     d84:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     d88:	6f687300 	svcvs	0x00687300
     d8c:	69207472 	stmdbvs	r0!, {r1, r4, r5, r6, sl, ip, sp, lr}
     d90:	6900746e 	stmdbvs	r0, {r1, r2, r3, r5, r6, sl, ip, sp, lr}
     d94:	70797472 	rsbsvc	r7, r9, r2, ror r4
     d98:	614d0065 	cmpvs	sp, r5, rrx
     d9c:	6c694678 	stclvs	6, cr4, [r9], #-480	; 0xfffffe20
     da0:	6d616e65 	stclvs	14, cr6, [r1, #-404]!	; 0xfffffe6c
     da4:	6e654c65 	cdpvs	12, 6, cr4, cr5, cr5, {3}
     da8:	00687467 	rsbeq	r7, r8, r7, ror #8
     dac:	6f6f526d 	svcvs	0x006f526d
     db0:	72460074 	subvc	r0, r6, #116	; 0x74
     db4:	505f6565 	subspl	r6, pc, r5, ror #10
     db8:	43006e69 	movwmi	r6, #3689	; 0xe69
     dbc:	636f7250 	cmnvs	pc, #80, 4
     dc0:	5f737365 	svcpl	0x00737365
     dc4:	616e614d 	cmnvs	lr, sp, asr #2
     dc8:	00726567 	rsbseq	r6, r2, r7, ror #10
     dcc:	70736e55 	rsbsvc	r6, r3, r5, asr lr
     dd0:	66696365 	strbtvs	r6, [r9], -r5, ror #6
     dd4:	00646569 	rsbeq	r6, r4, r9, ror #10
     dd8:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; d24 <shift+0xd24>
     ddc:	63732f65 	cmnvs	r3, #404	; 0x194
     de0:	6b6e6568 	blvs	1b9a388 <__bss_end+0x1b9134c>
     de4:	736f2f6a 	cmnvc	pc, #424	; 0x1a8
     de8:	32323032 	eorscc	r3, r2, #50	; 0x32
     dec:	2f70732f 	svccs	0x0070732f
     df0:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     df4:	2f736563 	svccs	0x00736563
     df8:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     dfc:	63617073 	cmnvs	r1, #115	; 0x73
     e00:	6f732f65 	svcvs	0x00732f65
     e04:	61745f73 	cmnvs	r4, r3, ror pc
     e08:	6d2f6b73 	fstmdbxvs	pc!, {d6-d62}	;@ Deprecated
     e0c:	2e6e6961 	vnmulcs.f16	s13, s28, s3	; <UNPREDICTABLE>
     e10:	00707063 	rsbseq	r7, r0, r3, rrx
     e14:	314e5a5f 	cmpcc	lr, pc, asr sl
     e18:	50474333 	subpl	r4, r7, r3, lsr r3
     e1c:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     e20:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     e24:	46387265 	ldrtmi	r7, [r8], -r5, ror #4
     e28:	5f656572 	svcpl	0x00656572
     e2c:	456e6950 	strbmi	r6, [lr, #-2384]!	; 0xfffff6b0
     e30:	0062626a 	rsbeq	r6, r2, sl, ror #4
     e34:	6c694673 	stclvs	6, cr4, [r9], #-460	; 0xfffffe34
     e38:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     e3c:	006d6574 	rsbeq	r6, sp, r4, ror r5
     e40:	74696e49 	strbtvc	r6, [r9], #-3657	; 0xfffff1b7
     e44:	696c6169 	stmdbvs	ip!, {r0, r3, r5, r6, r8, sp, lr}^
     e48:	4600657a 			; <UNDEFINED> instruction: 0x4600657a
     e4c:	5f646e69 	svcpl	0x00646e69
     e50:	6c696843 	stclvs	8, cr6, [r9], #-268	; 0xfffffef4
     e54:	74740064 	ldrbtvc	r0, [r4], #-100	; 0xffffff9c
     e58:	00307262 	eorseq	r7, r0, r2, ror #4
     e5c:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
     e60:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     e64:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     e68:	5f6d6574 	svcpl	0x006d6574
     e6c:	76726553 			; <UNDEFINED> instruction: 0x76726553
     e70:	00656369 	rsbeq	r6, r5, r9, ror #6
     e74:	70676f6c 	rsbvc	r6, r7, ip, ror #30
     e78:	00657069 	rsbeq	r7, r5, r9, rrx
     e7c:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
     e80:	6f72505f 	svcvs	0x0072505f
     e84:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     e88:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
     e8c:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     e90:	65706f00 	ldrbvs	r6, [r0, #-3840]!	; 0xfffff100
     e94:	5f64656e 	svcpl	0x0064656e
     e98:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     e9c:	69590073 	ldmdbvs	r9, {r0, r1, r4, r5, r6}^
     ea0:	00646c65 	rsbeq	r6, r4, r5, ror #24
     ea4:	65646e49 	strbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     ea8:	696e6966 	stmdbvs	lr!, {r1, r2, r5, r6, r8, fp, sp, lr}^
     eac:	47006574 	smlsdxmi	r0, r4, r5, r6
     eb0:	505f7465 	subspl	r7, pc, r5, ror #8
     eb4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     eb8:	425f7373 	subsmi	r7, pc, #-872415231	; 0xcc000001
     ebc:	49505f79 	ldmdbmi	r0, {r0, r3, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     ec0:	6e450044 	cdpvs	0, 4, cr0, cr5, cr4, {2}
     ec4:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     ec8:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     ecc:	445f746e 	ldrbmi	r7, [pc], #-1134	; ed4 <shift+0xed4>
     ed0:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     ed4:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     ed8:	72655000 	rsbvc	r5, r5, #0
     edc:	65687069 	strbvs	r7, [r8, #-105]!	; 0xffffff97
     ee0:	5f6c6172 	svcpl	0x006c6172
     ee4:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     ee8:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     eec:	4650475f 			; <UNDEFINED> instruction: 0x4650475f
     ef0:	5f4c4553 	svcpl	0x004c4553
     ef4:	61636f4c 	cmnvs	r3, ip, asr #30
     ef8:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     efc:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     f00:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
     f04:	4f495047 	svcmi	0x00495047
     f08:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     f0c:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     f10:	65473731 	strbvs	r3, [r7, #-1841]	; 0xfffff8cf
     f14:	50475f74 	subpl	r5, r7, r4, ror pc
     f18:	465f4f49 	ldrbmi	r4, [pc], -r9, asr #30
     f1c:	74636e75 	strbtvc	r6, [r3], #-3701	; 0xfffff18b
     f20:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
     f24:	6e49006a 	cdpvs	0, 4, cr0, cr9, cr10, {3}
     f28:	696c6176 	stmdbvs	ip!, {r1, r2, r4, r5, r6, r8, sp, lr}^
     f2c:	69505f64 	ldmdbvs	r0, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     f30:	5a5f006e 	bpl	17c10f0 <__bss_end+0x17b80b4>
     f34:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     f38:	4f495047 	svcmi	0x00495047
     f3c:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     f40:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     f44:	69443032 	stmdbvs	r4, {r1, r4, r5, ip, sp}^
     f48:	6c626173 	stfvse	f6, [r2], #-460	; 0xfffffe34
     f4c:	76455f65 	strbvc	r5, [r5], -r5, ror #30
     f50:	5f746e65 	svcpl	0x00746e65
     f54:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     f58:	6a457463 	bvs	115e0ec <__bss_end+0x11550b0>
     f5c:	474e3032 	smlaldxmi	r3, lr, r2, r0
     f60:	5f4f4950 	svcpl	0x004f4950
     f64:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     f68:	70757272 	rsbsvc	r7, r5, r2, ror r2
     f6c:	79545f74 	ldmdbvc	r4, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     f70:	6d006570 	cfstr32vs	mvfx6, [r0, #-448]	; 0xfffffe40
     f74:	5f6e6950 	svcpl	0x006e6950
     f78:	65736552 	ldrbvs	r6, [r3, #-1362]!	; 0xfffffaae
     f7c:	74617672 	strbtvc	r7, [r1], #-1650	; 0xfffff98e
     f80:	736e6f69 	cmnvc	lr, #420	; 0x1a4
     f84:	6165525f 	cmnvs	r5, pc, asr r2
     f88:	6f4c0064 	svcvs	0x004c0064
     f8c:	4c5f6b63 	mrrcmi	11, 6, r6, pc, cr3	; <UNPREDICTABLE>
     f90:	656b636f 	strbvs	r6, [fp, #-879]!	; 0xfffffc91
     f94:	5a5f0064 	bpl	17c112c <__bss_end+0x17b80f0>
     f98:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     f9c:	636f7250 	cmnvs	pc, #80, 4
     fa0:	5f737365 	svcpl	0x00737365
     fa4:	616e614d 	cmnvs	lr, sp, asr #2
     fa8:	31726567 	cmncc	r2, r7, ror #10
     fac:	6e614838 	mcrvs	8, 3, r4, cr1, cr8, {1}
     fb0:	5f656c64 	svcpl	0x00656c64
     fb4:	636f7250 	cmnvs	pc, #80, 4
     fb8:	5f737365 	svcpl	0x00737365
     fbc:	45495753 	strbmi	r5, [r9, #-1875]	; 0xfffff8ad
     fc0:	534e3032 	movtpl	r3, #57394	; 0xe032
     fc4:	505f4957 	subspl	r4, pc, r7, asr r9	; <UNPREDICTABLE>
     fc8:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     fcc:	535f7373 	cmppl	pc, #-872415231	; 0xcc000001
     fd0:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     fd4:	6a6a6563 	bvs	1a9a568 <__bss_end+0x1a9152c>
     fd8:	3131526a 	teqcc	r1, sl, ror #4
     fdc:	49575354 	ldmdbmi	r7, {r2, r4, r6, r8, r9, ip, lr}^
     fe0:	7365525f 	cmnvc	r5, #-268435451	; 0xf0000005
     fe4:	00746c75 	rsbseq	r6, r4, r5, ror ip
     fe8:	314e5a5f 	cmpcc	lr, pc, asr sl
     fec:	50474333 	subpl	r4, r7, r3, lsr r3
     ff0:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     ff4:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     ff8:	30327265 	eorscc	r7, r2, r5, ror #4
     ffc:	61656c43 	cmnvs	r5, r3, asr #24
    1000:	65445f72 	strbvs	r5, [r4, #-3954]	; 0xfffff08e
    1004:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
    1008:	455f6465 	ldrbmi	r6, [pc, #-1125]	; bab <shift+0xbab>
    100c:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
    1010:	73006a45 	movwvc	r6, #2629	; 0xa45
    1014:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    1018:	756f635f 	strbvc	r6, [pc, #-863]!	; cc1 <shift+0xcc1>
    101c:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    1020:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
    1024:	7261505f 	rsbvc	r5, r1, #95	; 0x5f
    1028:	00736d61 	rsbseq	r6, r3, r1, ror #26
    102c:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
    1030:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
    1034:	61686320 	cmnvs	r8, r0, lsr #6
    1038:	6e490072 	mcrvs	0, 2, r0, cr9, cr2, {3}
    103c:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
    1040:	61747075 	cmnvs	r4, r5, ror r0
    1044:	5f656c62 	svcpl	0x00656c62
    1048:	65656c53 	strbvs	r6, [r5, #-3155]!	; 0xfffff3ad
    104c:	65470070 	strbvs	r0, [r7, #-112]	; 0xffffff90
    1050:	50475f74 	subpl	r5, r7, r4, ror pc
    1054:	5152495f 	cmppl	r2, pc, asr r9
    1058:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
    105c:	5f746365 	svcpl	0x00746365
    1060:	61636f4c 	cmnvs	r3, ip, asr #30
    1064:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    1068:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    106c:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
    1070:	5f4f4950 	svcpl	0x004f4950
    1074:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
    1078:	3172656c 	cmncc	r2, ip, ror #10
    107c:	69615734 	stmdbvs	r1!, {r2, r4, r5, r8, r9, sl, ip, lr}^
    1080:	6f465f74 	svcvs	0x00465f74
    1084:	76455f72 			; <UNDEFINED> instruction: 0x76455f72
    1088:	45746e65 	ldrbmi	r6, [r4, #-3685]!	; 0xfffff19b
    108c:	46493550 			; <UNDEFINED> instruction: 0x46493550
    1090:	6a656c69 	bvs	195c23c <__bss_end+0x1953200>
    1094:	68635300 	stmdavs	r3!, {r8, r9, ip, lr}^
    1098:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
    109c:	52525f65 	subspl	r5, r2, #404	; 0x194
    10a0:	58554100 	ldmdapl	r5, {r8, lr}^
    10a4:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
    10a8:	53420065 	movtpl	r0, #8293	; 0x2065
    10ac:	425f3243 	subsmi	r3, pc, #805306372	; 0x30000004
    10b0:	00657361 	rsbeq	r7, r5, r1, ror #6
    10b4:	74697257 	strbtvc	r7, [r9], #-599	; 0xfffffda9
    10b8:	6e4f5f65 	cdpvs	15, 4, cr5, cr15, cr5, {3}
    10bc:	5300796c 	movwpl	r7, #2412	; 0x96c
    10c0:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    10c4:	00656c75 	rsbeq	r6, r5, r5, ror ip
    10c8:	314e5a5f 	cmpcc	lr, pc, asr sl
    10cc:	50474333 	subpl	r4, r7, r3, lsr r3
    10d0:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
    10d4:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
    10d8:	30317265 	eorscc	r7, r1, r5, ror #4
    10dc:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
    10e0:	495f656c 	ldmdbmi	pc, {r2, r3, r5, r6, r8, sl, sp, lr}^	; <UNPREDICTABLE>
    10e4:	76455152 			; <UNDEFINED> instruction: 0x76455152
    10e8:	63695400 	cmnvs	r9, #0, 8
    10ec:	6f435f6b 	svcvs	0x00435f6b
    10f0:	00746e75 	rsbseq	r6, r4, r5, ror lr
    10f4:	314e5a5f 	cmpcc	lr, pc, asr sl
    10f8:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
    10fc:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1100:	614d5f73 	hvcvs	54771	; 0xd5f3
    1104:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
    1108:	55383172 	ldrpl	r3, [r8, #-370]!	; 0xfffffe8e
    110c:	70616d6e 	rsbvc	r6, r1, lr, ror #26
    1110:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
    1114:	75435f65 	strbvc	r5, [r3, #-3941]	; 0xfffff09b
    1118:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
    111c:	006a4574 	rsbeq	r4, sl, r4, ror r5
    1120:	5f746c41 	svcpl	0x00746c41
    1124:	46490030 			; <UNDEFINED> instruction: 0x46490030
    1128:	73656c69 	cmnvc	r5, #26880	; 0x6900
    112c:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
    1130:	72445f6d 	subvc	r5, r4, #436	; 0x1b4
    1134:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
    1138:	746c4100 	strbtvc	r4, [ip], #-256	; 0xffffff00
    113c:	4100325f 	tstmi	r0, pc, asr r2
    1140:	335f746c 	cmpcc	pc, #108, 8	; 0x6c000000
    1144:	746c4100 	strbtvc	r4, [ip], #-256	; 0xffffff00
    1148:	4100345f 	tstmi	r0, pc, asr r4
    114c:	355f746c 	ldrbcc	r7, [pc, #-1132]	; ce8 <shift+0xce8>
    1150:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    1154:	46433131 			; <UNDEFINED> instruction: 0x46433131
    1158:	73656c69 	cmnvc	r5, #26880	; 0x6900
    115c:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
    1160:	5433316d 	ldrtpl	r3, [r3], #-365	; 0xfffffe93
    1164:	545f5346 	ldrbpl	r5, [pc], #-838	; 116c <shift+0x116c>
    1168:	5f656572 	svcpl	0x00656572
    116c:	65646f4e 	strbvs	r6, [r4, #-3918]!	; 0xfffff0b2
    1170:	69463031 	stmdbvs	r6, {r0, r4, r5, ip, sp}^
    1174:	435f646e 	cmpmi	pc, #1845493760	; 0x6e000000
    1178:	646c6968 	strbtvs	r6, [ip], #-2408	; 0xfffff698
    117c:	634b5045 	movtvs	r5, #45125	; 0xb045
    1180:	6e614800 	cdpvs	8, 6, cr4, cr1, cr0, {0}
    1184:	5f656c64 	svcpl	0x00656c64
    1188:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    118c:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
    1190:	535f6d65 	cmppl	pc, #6464	; 0x1940
    1194:	5f004957 	svcpl	0x00004957
    1198:	314b4e5a 	cmpcc	fp, sl, asr lr
    119c:	50474333 	subpl	r4, r7, r3, lsr r3
    11a0:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
    11a4:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
    11a8:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
    11ac:	5f746547 	svcpl	0x00746547
    11b0:	4c435047 	mcrrmi	0, 4, r5, r3, cr7
    11b4:	6f4c5f52 	svcvs	0x004c5f52
    11b8:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
    11bc:	6a456e6f 	bvs	115cb80 <__bss_end+0x1153b44>
    11c0:	30536a52 	subscc	r6, r3, r2, asr sl
    11c4:	6873005f 	ldmdavs	r3!, {r0, r1, r2, r3, r4, r6}^
    11c8:	2074726f 	rsbscs	r7, r4, pc, ror #4
    11cc:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
    11d0:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
    11d4:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
    11d8:	69616d00 	stmdbvs	r1!, {r8, sl, fp, sp, lr}^
    11dc:	5073006e 	rsbspl	r0, r3, lr, rrx
    11e0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    11e4:	674d7373 	smlsldxvs	r7, sp, r3, r3
    11e8:	47430072 	smlsldxmi	r0, r3, r2, r0
    11ec:	5f4f4950 	svcpl	0x004f4950
    11f0:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
    11f4:	0072656c 	rsbseq	r6, r2, ip, ror #10
    11f8:	5f746c41 	svcpl	0x00746c41
    11fc:	68630031 	stmdavs	r3!, {r0, r4, r5}^
    1200:	72646c69 	rsbvc	r6, r4, #26880	; 0x6900
    1204:	44006e65 	strmi	r6, [r0], #-3685	; 0xfffff19b
    1208:	62617369 	rsbvs	r7, r1, #-1543503871	; 0xa4000001
    120c:	455f656c 	ldrbmi	r6, [pc, #-1388]	; ca8 <shift+0xca8>
    1210:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
    1214:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
    1218:	00746365 	rsbseq	r6, r4, r5, ror #6
    121c:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
    1220:	70757272 	rsbsvc	r7, r5, r2, ror r2
    1224:	6f435f74 	svcvs	0x00435f74
    1228:	6f72746e 	svcvs	0x0072746e
    122c:	72656c6c 	rsbvc	r6, r5, #108, 24	; 0x6c00
    1230:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
    1234:	46540065 	ldrbmi	r0, [r4], -r5, rrx
    1238:	72445f53 	subvc	r5, r4, #332	; 0x14c
    123c:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
    1240:	61655200 	cmnvs	r5, r0, lsl #4
    1244:	72575f64 	subsvc	r5, r7, #100, 30	; 0x190
    1248:	00657469 	rsbeq	r7, r5, r9, ror #8
    124c:	69746341 	ldmdbvs	r4!, {r0, r6, r8, r9, sp, lr}^
    1250:	505f6576 	subspl	r6, pc, r6, ror r5	; <UNPREDICTABLE>
    1254:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1258:	435f7373 	cmpmi	pc, #-872415231	; 0xcc000001
    125c:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
    1260:	6d797300 	ldclvs	3, cr7, [r9, #-0]
    1264:	5f6c6f62 	svcpl	0x006c6f62
    1268:	6b636974 	blvs	18db840 <__bss_end+0x18d2804>
    126c:	6c65645f 	cfstrdvs	mvd6, [r5], #-380	; 0xfffffe84
    1270:	5f007961 	svcpl	0x00007961
    1274:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
    1278:	6f725043 	svcvs	0x00725043
    127c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1280:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    1284:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    1288:	61483132 	cmpvs	r8, r2, lsr r1
    128c:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
    1290:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
    1294:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
    1298:	5f6d6574 	svcpl	0x006d6574
    129c:	45495753 	strbmi	r5, [r9, #-1875]	; 0xfffff8ad
    12a0:	534e3332 	movtpl	r3, #58162	; 0xe332
    12a4:	465f4957 			; <UNDEFINED> instruction: 0x465f4957
    12a8:	73656c69 	cmnvc	r5, #26880	; 0x6900
    12ac:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
    12b0:	65535f6d 	ldrbvs	r5, [r3, #-3949]	; 0xfffff093
    12b4:	63697672 	cmnvs	r9, #119537664	; 0x7200000
    12b8:	6a6a6a65 	bvs	1a9bc54 <__bss_end+0x1a92c18>
    12bc:	54313152 	ldrtpl	r3, [r1], #-338	; 0xfffffeae
    12c0:	5f495753 	svcpl	0x00495753
    12c4:	75736552 	ldrbvc	r6, [r3, #-1362]!	; 0xfffffaae
    12c8:	4500746c 	strmi	r7, [r0, #-1132]	; 0xfffffb94
    12cc:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
    12d0:	76455f65 	strbvc	r5, [r5], -r5, ror #30
    12d4:	5f746e65 	svcpl	0x00746e65
    12d8:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
    12dc:	63007463 	movwvs	r7, #1123	; 0x463
    12e0:	65736f6c 	ldrbvs	r6, [r3, #-3948]!	; 0xfffff094
    12e4:	74655300 	strbtvc	r5, [r5], #-768	; 0xfffffd00
    12e8:	6c65525f 	sfmvs	f5, 2, [r5], #-380	; 0xfffffe84
    12ec:	76697461 	strbtvc	r7, [r9], -r1, ror #8
    12f0:	65720065 	ldrbvs	r0, [r2, #-101]!	; 0xffffff9b
    12f4:	6c617674 	stclvs	6, cr7, [r1], #-464	; 0xfffffe30
    12f8:	75636e00 	strbvc	r6, [r3, #-3584]!	; 0xfffff200
    12fc:	64720072 	ldrbtvs	r0, [r2], #-114	; 0xffffff8e
    1300:	006d756e 	rsbeq	r7, sp, lr, ror #10
    1304:	31315a5f 	teqcc	r1, pc, asr sl
    1308:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
    130c:	69795f64 	ldmdbvs	r9!, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
    1310:	76646c65 	strbtvc	r6, [r4], -r5, ror #24
    1314:	315a5f00 	cmpcc	sl, r0, lsl #30
    1318:	74657337 	strbtvc	r7, [r5], #-823	; 0xfffffcc9
    131c:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
    1320:	65645f6b 	strbvs	r5, [r4, #-3947]!	; 0xfffff095
    1324:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
    1328:	006a656e 	rsbeq	r6, sl, lr, ror #10
    132c:	74696177 	strbtvc	r6, [r9], #-375	; 0xfffffe89
    1330:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
    1334:	69746f6e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    1338:	6a6a7966 	bvs	1a9f8d8 <__bss_end+0x1a9689c>
    133c:	395a5f00 	ldmdbcc	sl, {r8, r9, sl, fp, ip, lr}^
    1340:	6d726574 	cfldr64vs	mvdx6, [r2, #-464]!	; 0xfffffe30
    1344:	74616e69 	strbtvc	r6, [r1], #-3689	; 0xfffff197
    1348:	2f006965 	svccs	0x00006965
    134c:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    1350:	6863732f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, sp, lr}^
    1354:	6a6b6e65 	bvs	1adccf0 <__bss_end+0x1ad3cb4>
    1358:	32736f2f 	rsbscc	r6, r3, #47, 30	; 0xbc
    135c:	2f323230 	svccs	0x00323230
    1360:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
    1364:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    1368:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
    136c:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
    1370:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
    1374:	74732f63 	ldrbtvc	r2, [r3], #-3939	; 0xfffff09d
    1378:	6c696664 	stclvs	6, cr6, [r9], #-400	; 0xfffffe70
    137c:	70632e65 	rsbvc	r2, r3, r5, ror #28
    1380:	61460070 	hvcvs	24576	; 0x6000
    1384:	65006c69 	strvs	r6, [r0, #-3177]	; 0xfffff397
    1388:	63746978 	cmnvs	r4, #120, 18	; 0x1e0000
    138c:	0065646f 	rsbeq	r6, r5, pc, ror #8
    1390:	34325a5f 	ldrtcc	r5, [r2], #-2655	; 0xfffff5a1
    1394:	5f746567 	svcpl	0x00746567
    1398:	69746361 	ldmdbvs	r4!, {r0, r5, r6, r8, r9, sp, lr}^
    139c:	705f6576 	subsvc	r6, pc, r6, ror r5	; <UNPREDICTABLE>
    13a0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    13a4:	635f7373 	cmpvs	pc, #-872415231	; 0xcc000001
    13a8:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
    13ac:	63730076 	cmnvs	r3, #118	; 0x76
    13b0:	5f646568 	svcpl	0x00646568
    13b4:	6c656979 			; <UNDEFINED> instruction: 0x6c656979
    13b8:	69740064 	ldmdbvs	r4!, {r2, r5, r6}^
    13bc:	635f6b63 	cmpvs	pc, #101376	; 0x18c00
    13c0:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
    13c4:	7165725f 	cmnvc	r5, pc, asr r2
    13c8:	65726975 	ldrbvs	r6, [r2, #-2421]!	; 0xfffff68b
    13cc:	69500064 	ldmdbvs	r0, {r2, r5, r6}^
    13d0:	465f6570 			; <UNDEFINED> instruction: 0x465f6570
    13d4:	5f656c69 	svcpl	0x00656c69
    13d8:	66657250 			; <UNDEFINED> instruction: 0x66657250
    13dc:	5f007869 	svcpl	0x00007869
    13e0:	6734315a 			; <UNDEFINED> instruction: 0x6734315a
    13e4:	745f7465 	ldrbvc	r7, [pc], #-1125	; 13ec <shift+0x13ec>
    13e8:	5f6b6369 	svcpl	0x006b6369
    13ec:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
    13f0:	73007674 	movwvc	r7, #1652	; 0x674
    13f4:	7065656c 	rsbvc	r6, r5, ip, ror #10
    13f8:	6f682f00 	svcvs	0x00682f00
    13fc:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
    1400:	6e656863 	cdpvs	8, 6, cr6, cr5, cr3, {3}
    1404:	6f2f6a6b 	svcvs	0x002f6a6b
    1408:	32303273 	eorscc	r3, r0, #805306375	; 0x30000007
    140c:	70732f32 	rsbsvc	r2, r3, r2, lsr pc
    1410:	756f732f 	strbvc	r7, [pc, #-815]!	; 10e9 <shift+0x10e9>
    1414:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
    1418:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
    141c:	6f00646c 	svcvs	0x0000646c
    1420:	61726570 	cmnvs	r2, r0, ror r5
    1424:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    1428:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    142c:	736f6c63 	cmnvc	pc, #25344	; 0x6300
    1430:	5f006a65 	svcpl	0x00006a65
    1434:	6567365a 	strbvs	r3, [r7, #-1626]!	; 0xfffff9a6
    1438:	64697074 	strbtvs	r7, [r9], #-116	; 0xffffff8c
    143c:	6e660076 	mcrvs	0, 3, r0, cr6, cr6, {3}
    1440:	00656d61 	rsbeq	r6, r5, r1, ror #26
    1444:	69746f6e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    1448:	74007966 	strvc	r7, [r0], #-2406	; 0xfffff69a
    144c:	736b6369 	cmnvc	fp, #-1543503871	; 0xa4000001
    1450:	65706f00 	ldrbvs	r6, [r0, #-3840]!	; 0xfffff100
    1454:	5a5f006e 	bpl	17c1614 <__bss_end+0x17b85d8>
    1458:	70697034 	rsbvc	r7, r9, r4, lsr r0
    145c:	634b5065 	movtvs	r5, #45157	; 0xb065
    1460:	444e006a 	strbmi	r0, [lr], #-106	; 0xffffff96
    1464:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
    1468:	5f656e69 	svcpl	0x00656e69
    146c:	73627553 	cmnvc	r2, #348127232	; 0x14c00000
    1470:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
    1474:	67006563 	strvs	r6, [r0, -r3, ror #10]
    1478:	745f7465 	ldrbvc	r7, [pc], #-1125	; 1480 <shift+0x1480>
    147c:	5f6b6369 	svcpl	0x006b6369
    1480:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
    1484:	61700074 	cmnvs	r0, r4, ror r0
    1488:	006d6172 	rsbeq	r6, sp, r2, ror r1
    148c:	77355a5f 			; <UNDEFINED> instruction: 0x77355a5f
    1490:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
    1494:	634b506a 	movtvs	r5, #45162	; 0xb06a
    1498:	6567006a 	strbvs	r0, [r7, #-106]!	; 0xffffff96
    149c:	61745f74 	cmnvs	r4, r4, ror pc
    14a0:	745f6b73 	ldrbvc	r6, [pc], #-2931	; 14a8 <shift+0x14a8>
    14a4:	736b6369 	cmnvc	fp, #-1543503871	; 0xa4000001
    14a8:	5f6f745f 	svcpl	0x006f745f
    14ac:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
    14b0:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
    14b4:	66756200 	ldrbtvs	r6, [r5], -r0, lsl #4
    14b8:	7a69735f 	bvc	1a5e23c <__bss_end+0x1a55200>
    14bc:	72770065 	rsbsvc	r0, r7, #101	; 0x65
    14c0:	00657469 	rsbeq	r7, r5, r9, ror #8
    14c4:	5f746573 	svcpl	0x00746573
    14c8:	6b736174 	blvs	1cd9aa0 <__bss_end+0x1cd0a64>
    14cc:	6165645f 	cmnvs	r5, pc, asr r4
    14d0:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
    14d4:	5a5f0065 	bpl	17c1670 <__bss_end+0x17b8634>
    14d8:	656c7335 	strbvs	r7, [ip, #-821]!	; 0xfffffccb
    14dc:	6a6a7065 	bvs	1a9d678 <__bss_end+0x1a9463c>
    14e0:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
    14e4:	6d65525f 	sfmvs	f5, 2, [r5, #-380]!	; 0xfffffe84
    14e8:	696e6961 	stmdbvs	lr!, {r0, r5, r6, r8, fp, sp, lr}^
    14ec:	5f00676e 	svcpl	0x0000676e
    14f0:	6736325a 			; <UNDEFINED> instruction: 0x6736325a
    14f4:	745f7465 	ldrbvc	r7, [pc], #-1125	; 14fc <shift+0x14fc>
    14f8:	5f6b7361 	svcpl	0x006b7361
    14fc:	6b636974 	blvs	18dbad4 <__bss_end+0x18d2a98>
    1500:	6f745f73 	svcvs	0x00745f73
    1504:	6165645f 	cmnvs	r5, pc, asr r4
    1508:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
    150c:	4e007665 	cfmadd32mi	mvax3, mvfx7, mvfx0, mvfx5
    1510:	5f495753 	svcpl	0x00495753
    1514:	75736552 	ldrbvc	r6, [r3, #-1362]!	; 0xfffffaae
    1518:	435f746c 	cmpmi	pc, #108, 8	; 0x6c000000
    151c:	0065646f 	rsbeq	r6, r5, pc, ror #8
    1520:	756e7277 	strbvc	r7, [lr, #-631]!	; 0xfffffd89
    1524:	5a5f006d 	bpl	17c16e0 <__bss_end+0x17b86a4>
    1528:	69617734 	stmdbvs	r1!, {r2, r4, r5, r8, r9, sl, ip, sp, lr}^
    152c:	6a6a6a74 	bvs	1a9bf04 <__bss_end+0x1a92ec8>
    1530:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    1534:	74636f69 	strbtvc	r6, [r3], #-3945	; 0xfffff097
    1538:	36316a6c 	ldrtcc	r6, [r1], -ip, ror #20
    153c:	434f494e 	movtmi	r4, #63822	; 0xf94e
    1540:	4f5f6c74 	svcmi	0x005f6c74
    1544:	61726570 	cmnvs	r2, r0, ror r5
    1548:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    154c:	69007650 	stmdbvs	r0, {r4, r6, r9, sl, ip, sp, lr}
    1550:	6c74636f 	ldclvs	3, cr6, [r4], #-444	; 0xfffffe44
    1554:	74657200 	strbtvc	r7, [r5], #-512	; 0xfffffe00
    1558:	00746e63 	rsbseq	r6, r4, r3, ror #28
    155c:	6d726574 	cfldr64vs	mvdx6, [r2, #-464]!	; 0xfffffe30
    1560:	74616e69 	strbtvc	r6, [r1], #-3689	; 0xfffff197
    1564:	6f6d0065 	svcvs	0x006d0065
    1568:	62006564 	andvs	r6, r0, #100, 10	; 0x19000000
    156c:	65666675 	strbvs	r6, [r6, #-1653]!	; 0xfffff98b
    1570:	5a5f0072 	bpl	17c1740 <__bss_end+0x17b8704>
    1574:	61657234 	cmnvs	r5, r4, lsr r2
    1578:	63506a64 	cmpvs	r0, #100, 20	; 0x64000
    157c:	6572006a 	ldrbvs	r0, [r2, #-106]!	; 0xffffff96
    1580:	646f6374 	strbtvs	r6, [pc], #-884	; 1588 <shift+0x1588>
    1584:	65670065 	strbvs	r0, [r7, #-101]!	; 0xffffff9b
    1588:	63615f74 	cmnvs	r1, #116, 30	; 0x1d0
    158c:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
    1590:	6f72705f 	svcvs	0x0072705f
    1594:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1598:	756f635f 	strbvc	r6, [pc, #-863]!	; 1241 <shift+0x1241>
    159c:	6600746e 	strvs	r7, [r0], -lr, ror #8
    15a0:	6e656c69 	cdpvs	12, 6, cr6, cr5, cr9, {3}
    15a4:	00656d61 	rsbeq	r6, r5, r1, ror #26
    15a8:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
    15ac:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
    15b0:	00646970 	rsbeq	r6, r4, r0, ror r9
    15b4:	6f345a5f 	svcvs	0x00345a5f
    15b8:	506e6570 	rsbpl	r6, lr, r0, ror r5
    15bc:	3531634b 	ldrcc	r6, [r1, #-843]!	; 0xfffffcb5
    15c0:	6c69464e 	stclvs	6, cr4, [r9], #-312	; 0xfffffec8
    15c4:	704f5f65 	subvc	r5, pc, r5, ror #30
    15c8:	4d5f6e65 	ldclmi	14, cr6, [pc, #-404]	; 143c <shift+0x143c>
    15cc:	0065646f 	rsbeq	r6, r5, pc, ror #8
    15d0:	20554e47 	subscs	r4, r5, r7, asr #28
    15d4:	312b2b43 			; <UNDEFINED> instruction: 0x312b2b43
    15d8:	2e392034 	mrccs	0, 1, r2, cr9, cr4, {1}
    15dc:	20312e32 	eorscs	r2, r1, r2, lsr lr
    15e0:	39313032 	ldmdbcc	r1!, {r1, r4, r5, ip, sp}
    15e4:	35323031 	ldrcc	r3, [r2, #-49]!	; 0xffffffcf
    15e8:	65722820 	ldrbvs	r2, [r2, #-2080]!	; 0xfffff7e0
    15ec:	7361656c 	cmnvc	r1, #108, 10	; 0x1b000000
    15f0:	5b202965 	blpl	80bb8c <__bss_end+0x802b50>
    15f4:	2f4d5241 	svccs	0x004d5241
    15f8:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    15fc:	72622d39 	rsbvc	r2, r2, #3648	; 0xe40
    1600:	68636e61 	stmdavs	r3!, {r0, r5, r6, r9, sl, fp, sp, lr}^
    1604:	76657220 	strbtvc	r7, [r5], -r0, lsr #4
    1608:	6f697369 	svcvs	0x00697369
    160c:	3732206e 	ldrcc	r2, [r2, -lr, rrx]!
    1610:	39393537 	ldmdbcc	r9!, {r0, r1, r2, r4, r5, r8, sl, ip, sp}
    1614:	6d2d205d 	stcvs	0, cr2, [sp, #-372]!	; 0xfffffe8c
    1618:	616f6c66 	cmnvs	pc, r6, ror #24
    161c:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
    1620:	61683d69 	cmnvs	r8, r9, ror #26
    1624:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
    1628:	7570666d 	ldrbvc	r6, [r0, #-1645]!	; 0xfffff993
    162c:	7066763d 	rsbvc	r7, r6, sp, lsr r6
    1630:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    1634:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    1638:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
    163c:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
    1640:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
    1644:	3d757066 	ldclcc	0, cr7, [r5, #-408]!	; 0xfffffe68
    1648:	20706676 	rsbscs	r6, r0, r6, ror r6
    164c:	75746d2d 	ldrbvc	r6, [r4, #-3373]!	; 0xfffff2d3
    1650:	613d656e 	teqvs	sp, lr, ror #10
    1654:	31316d72 	teqcc	r1, r2, ror sp
    1658:	7a6a3637 	bvc	1a8ef3c <__bss_end+0x1a85f00>
    165c:	20732d66 	rsbscs	r2, r3, r6, ror #26
    1660:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
    1664:	6d2d206d 	stcvs	0, cr2, [sp, #-436]!	; 0xfffffe4c
    1668:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    166c:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
    1670:	6b7a3676 	blvs	1e8f050 <__bss_end+0x1e86014>
    1674:	2070662b 	rsbscs	r6, r0, fp, lsr #12
    1678:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    167c:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    1680:	304f2d20 	subcc	r2, pc, r0, lsr #26
    1684:	304f2d20 	subcc	r2, pc, r0, lsr #26
    1688:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
    168c:	78652d6f 	stmdavc	r5!, {r0, r1, r2, r3, r5, r6, r8, sl, fp, sp}^
    1690:	74706563 	ldrbtvc	r6, [r0], #-1379	; 0xfffffa9d
    1694:	736e6f69 	cmnvc	lr, #420	; 0x1a4
    1698:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
    169c:	74722d6f 	ldrbtvc	r2, [r2], #-3439	; 0xfffff291
    16a0:	69006974 	stmdbvs	r0, {r2, r4, r5, r6, r8, fp, sp, lr}
    16a4:	7475706e 	ldrbtvc	r7, [r5], #-110	; 0xffffff92
    16a8:	73656400 	cmnvc	r5, #0, 8
    16ac:	7a620074 	bvc	1881884 <__bss_end+0x1878848>
    16b0:	006f7265 	rsbeq	r7, pc, r5, ror #4
    16b4:	676e656c 	strbvs	r6, [lr, -ip, ror #10]!
    16b8:	5f006874 	svcpl	0x00006874
    16bc:	7a62355a 	bvc	188ec2c <__bss_end+0x1885bf0>
    16c0:	506f7265 	rsbpl	r7, pc, r5, ror #4
    16c4:	5f006976 	svcpl	0x00006976
    16c8:	7461345a 	strbtvc	r3, [r1], #-1114	; 0xfffffba6
    16cc:	4b50696f 	blmi	141bc90 <__bss_end+0x1412c54>
    16d0:	682f0063 	stmdavs	pc!, {r0, r1, r5, r6}	; <UNPREDICTABLE>
    16d4:	2f656d6f 	svccs	0x00656d6f
    16d8:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
    16dc:	2f6a6b6e 	svccs	0x006a6b6e
    16e0:	3032736f 	eorscc	r7, r2, pc, ror #6
    16e4:	732f3232 			; <UNDEFINED> instruction: 0x732f3232
    16e8:	6f732f70 	svcvs	0x00732f70
    16ec:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    16f0:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
    16f4:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
    16f8:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
    16fc:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    1700:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    1704:	632e676e 			; <UNDEFINED> instruction: 0x632e676e
    1708:	43007070 	movwmi	r7, #112	; 0x70
    170c:	43726168 	cmnmi	r2, #104, 2
    1710:	41766e6f 	cmnmi	r6, pc, ror #28
    1714:	6d007272 	sfmvs	f7, 4, [r0, #-456]	; 0xfffffe38
    1718:	73646d65 	cmnvc	r4, #6464	; 0x1940
    171c:	756f0074 	strbvc	r0, [pc, #-116]!	; 16b0 <shift+0x16b0>
    1720:	74757074 	ldrbtvc	r7, [r5], #-116	; 0xffffff8c
    1724:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
    1728:	636d656d 	cmnvs	sp, #457179136	; 0x1b400000
    172c:	4b507970 	blmi	141fcf4 <__bss_end+0x1416cb8>
    1730:	69765076 	ldmdbvs	r6!, {r1, r2, r4, r5, r6, ip, lr}^
    1734:	73616200 	cmnvc	r1, #0, 4
    1738:	656d0065 	strbvs	r0, [sp, #-101]!	; 0xffffff9b
    173c:	7970636d 	ldmdbvc	r0!, {r0, r2, r3, r5, r6, r8, r9, sp, lr}^
    1740:	72747300 	rsbsvc	r7, r4, #0, 6
    1744:	006e656c 	rsbeq	r6, lr, ip, ror #10
    1748:	73375a5f 	teqvc	r7, #389120	; 0x5f000
    174c:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    1750:	4b50706d 	blmi	141d90c <__bss_end+0x14148d0>
    1754:	5f305363 	svcpl	0x00305363
    1758:	5a5f0069 	bpl	17c1904 <__bss_end+0x17b88c8>
    175c:	72747336 	rsbsvc	r7, r4, #-671088640	; 0xd8000000
    1760:	506e656c 	rsbpl	r6, lr, ip, ror #10
    1764:	6100634b 	tstvs	r0, fp, asr #6
    1768:	00696f74 	rsbeq	r6, r9, r4, ror pc
    176c:	73375a5f 	teqvc	r7, #389120	; 0x5f000
    1770:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    1774:	63507970 	cmpvs	r0, #112, 18	; 0x1c0000
    1778:	69634b50 	stmdbvs	r3!, {r4, r6, r8, r9, fp, lr}^
    177c:	72747300 	rsbsvc	r7, r4, #0, 6
    1780:	706d636e 	rsbvc	r6, sp, lr, ror #6
    1784:	72747300 	rsbsvc	r7, r4, #0, 6
    1788:	7970636e 	ldmdbvc	r0!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
    178c:	6d656d00 	stclvs	13, cr6, [r5, #-0]
    1790:	0079726f 	rsbseq	r7, r9, pc, ror #4
    1794:	736d656d 	cmnvc	sp, #457179136	; 0x1b400000
    1798:	69006372 	stmdbvs	r0, {r1, r4, r5, r6, r8, r9, sp, lr}
    179c:	00616f74 	rsbeq	r6, r1, r4, ror pc
    17a0:	69345a5f 	ldmdbvs	r4!, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}
    17a4:	6a616f74 	bvs	185d57c <__bss_end+0x1854540>
    17a8:	006a6350 	rsbeq	r6, sl, r0, asr r3
    17ac:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    17b0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    17b4:	2f2e2e2f 	svccs	0x002e2e2f
    17b8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    17bc:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    17c0:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    17c4:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
    17c8:	2f676966 	svccs	0x00676966
    17cc:	2f6d7261 	svccs	0x006d7261
    17d0:	3162696c 	cmncc	r2, ip, ror #18
    17d4:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
    17d8:	00532e73 	subseq	r2, r3, r3, ror lr
    17dc:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
    17e0:	672f646c 	strvs	r6, [pc, -ip, ror #8]!
    17e4:	612d6363 			; <UNDEFINED> instruction: 0x612d6363
    17e8:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
    17ec:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
    17f0:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    17f4:	396c472d 	stmdbcc	ip!, {r0, r2, r3, r5, r8, r9, sl, lr}^
    17f8:	2f39546b 	svccs	0x0039546b
    17fc:	2d636367 	stclcs	3, cr6, [r3, #-412]!	; 0xfffffe64
    1800:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    1804:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    1808:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    180c:	2d392d69 	ldccs	13, cr2, [r9, #-420]!	; 0xfffffe5c
    1810:	39313032 	ldmdbcc	r1!, {r1, r4, r5, ip, sp}
    1814:	2f34712d 	svccs	0x0034712d
    1818:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    181c:	72612f64 	rsbvc	r2, r1, #100, 30	; 0x190
    1820:	6f6e2d6d 	svcvs	0x006e2d6d
    1824:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
    1828:	2f696261 	svccs	0x00696261
    182c:	2f6d7261 	svccs	0x006d7261
    1830:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
    1834:	7261682f 	rsbvc	r6, r1, #3080192	; 0x2f0000
    1838:	696c2f64 	stmdbvs	ip!, {r2, r5, r6, r8, r9, sl, fp, sp}^
    183c:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1840:	52415400 	subpl	r5, r1, #0, 8
    1844:	5f544547 	svcpl	0x00544547
    1848:	5f555043 	svcpl	0x00555043
    184c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1850:	31617865 	cmncc	r1, r5, ror #16
    1854:	726f6337 	rsbvc	r6, pc, #-603979776	; 0xdc000000
    1858:	61786574 	cmnvs	r8, r4, ror r5
    185c:	73690037 	cmnvc	r9, #55	; 0x37
    1860:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1864:	70665f74 	rsbvc	r5, r6, r4, ror pc
    1868:	6c62645f 	cfstrdvs	mvd6, [r2], #-380	; 0xfffffe84
    186c:	6d726100 	ldfvse	f6, [r2, #-0]
    1870:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1874:	77695f68 	strbvc	r5, [r9, -r8, ror #30]!
    1878:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    187c:	52415400 	subpl	r5, r1, #0, 8
    1880:	5f544547 	svcpl	0x00544547
    1884:	5f555043 	svcpl	0x00555043
    1888:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    188c:	326d7865 	rsbcc	r7, sp, #6619136	; 0x650000
    1890:	52410033 	subpl	r0, r1, #51	; 0x33
    1894:	51455f4d 	cmppl	r5, sp, asr #30
    1898:	52415400 	subpl	r5, r1, #0, 8
    189c:	5f544547 	svcpl	0x00544547
    18a0:	5f555043 	svcpl	0x00555043
    18a4:	316d7261 	cmncc	sp, r1, ror #4
    18a8:	74363531 	ldrtvc	r3, [r6], #-1329	; 0xfffffacf
    18ac:	00736632 	rsbseq	r6, r3, r2, lsr r6
    18b0:	5f617369 	svcpl	0x00617369
    18b4:	5f746962 	svcpl	0x00746962
    18b8:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    18bc:	41540062 	cmpmi	r4, r2, rrx
    18c0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    18c4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    18c8:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    18cc:	61786574 	cmnvs	r8, r4, ror r5
    18d0:	6f633735 	svcvs	0x00633735
    18d4:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    18d8:	00333561 	eorseq	r3, r3, r1, ror #10
    18dc:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    18e0:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    18e4:	4d385f48 	ldcmi	15, cr5, [r8, #-288]!	; 0xfffffee0
    18e8:	5341425f 	movtpl	r4, #4703	; 0x125f
    18ec:	41540045 	cmpmi	r4, r5, asr #32
    18f0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    18f4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    18f8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    18fc:	00303138 	eorseq	r3, r0, r8, lsr r1
    1900:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1904:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1908:	785f5550 	ldmdavc	pc, {r4, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
    190c:	656e6567 	strbvs	r6, [lr, #-1383]!	; 0xfffffa99
    1910:	52410031 	subpl	r0, r1, #49	; 0x31
    1914:	43505f4d 	cmpmi	r0, #308	; 0x134
    1918:	41415f53 	cmpmi	r1, r3, asr pc
    191c:	5f534350 	svcpl	0x00534350
    1920:	4d4d5749 	stclmi	7, cr5, [sp, #-292]	; 0xfffffedc
    1924:	42005458 	andmi	r5, r0, #88, 8	; 0x58000000
    1928:	5f455341 	svcpl	0x00455341
    192c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1930:	4200305f 	andmi	r3, r0, #95	; 0x5f
    1934:	5f455341 	svcpl	0x00455341
    1938:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    193c:	4200325f 	andmi	r3, r0, #-268435451	; 0xf0000005
    1940:	5f455341 	svcpl	0x00455341
    1944:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1948:	4200335f 	andmi	r3, r0, #2080374785	; 0x7c000001
    194c:	5f455341 	svcpl	0x00455341
    1950:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1954:	4200345f 	andmi	r3, r0, #1593835520	; 0x5f000000
    1958:	5f455341 	svcpl	0x00455341
    195c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1960:	4200365f 	andmi	r3, r0, #99614720	; 0x5f00000
    1964:	5f455341 	svcpl	0x00455341
    1968:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    196c:	5400375f 	strpl	r3, [r0], #-1887	; 0xfffff8a1
    1970:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1974:	50435f54 	subpl	r5, r3, r4, asr pc
    1978:	73785f55 	cmnvc	r8, #340	; 0x154
    197c:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    1980:	61736900 	cmnvs	r3, r0, lsl #18
    1984:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1988:	6572705f 	ldrbvs	r7, [r2, #-95]!	; 0xffffffa1
    198c:	73657264 	cmnvc	r5, #100, 4	; 0x40000006
    1990:	52415400 	subpl	r5, r1, #0, 8
    1994:	5f544547 	svcpl	0x00544547
    1998:	5f555043 	svcpl	0x00555043
    199c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    19a0:	336d7865 	cmncc	sp, #6619136	; 0x650000
    19a4:	41540033 	cmpmi	r4, r3, lsr r0
    19a8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    19ac:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    19b0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    19b4:	6d647437 	cfstrdvs	mvd7, [r4, #-220]!	; 0xffffff24
    19b8:	73690069 	cmnvc	r9, #105	; 0x69
    19bc:	6f6e5f61 	svcvs	0x006e5f61
    19c0:	00746962 	rsbseq	r6, r4, r2, ror #18
    19c4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    19c8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    19cc:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    19d0:	31316d72 	teqcc	r1, r2, ror sp
    19d4:	7a6a3637 	bvc	1a8f2b8 <__bss_end+0x1a8627c>
    19d8:	69007366 	stmdbvs	r0, {r1, r2, r5, r6, r8, r9, ip, sp, lr}
    19dc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    19e0:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    19e4:	32767066 	rsbscc	r7, r6, #102	; 0x66
    19e8:	4d524100 	ldfmie	f4, [r2, #-0]
    19ec:	5343505f 	movtpl	r5, #12383	; 0x305f
    19f0:	4b4e555f 	blmi	1396f74 <__bss_end+0x138df38>
    19f4:	4e574f4e 	cdpmi	15, 5, cr4, cr7, cr14, {2}
    19f8:	52415400 	subpl	r5, r1, #0, 8
    19fc:	5f544547 	svcpl	0x00544547
    1a00:	5f555043 	svcpl	0x00555043
    1a04:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    1a08:	41420065 	cmpmi	r2, r5, rrx
    1a0c:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1a10:	5f484352 	svcpl	0x00484352
    1a14:	4a455435 	bmi	1156af0 <__bss_end+0x114dab4>
    1a18:	6d726100 	ldfvse	f6, [r2, #-0]
    1a1c:	6663635f 			; <UNDEFINED> instruction: 0x6663635f
    1a20:	735f6d73 	cmpvc	pc, #7360	; 0x1cc0
    1a24:	65746174 	ldrbvs	r6, [r4, #-372]!	; 0xfffffe8c
    1a28:	6d726100 	ldfvse	f6, [r2, #-0]
    1a2c:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1a30:	65743568 	ldrbvs	r3, [r4, #-1384]!	; 0xfffffa98
    1a34:	736e7500 	cmnvc	lr, #0, 10
    1a38:	5f636570 	svcpl	0x00636570
    1a3c:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    1a40:	0073676e 	rsbseq	r6, r3, lr, ror #14
    1a44:	5f617369 	svcpl	0x00617369
    1a48:	5f746962 	svcpl	0x00746962
    1a4c:	00636573 	rsbeq	r6, r3, r3, ror r5
    1a50:	6c635f5f 	stclvs	15, cr5, [r3], #-380	; 0xfffffe84
    1a54:	61745f7a 	cmnvs	r4, sl, ror pc
    1a58:	52410062 	subpl	r0, r1, #98	; 0x62
    1a5c:	43565f4d 	cmpmi	r6, #308	; 0x134
    1a60:	6d726100 	ldfvse	f6, [r2, #-0]
    1a64:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1a68:	73785f68 	cmnvc	r8, #104, 30	; 0x1a0
    1a6c:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    1a70:	4d524100 	ldfmie	f4, [r2, #-0]
    1a74:	00454c5f 	subeq	r4, r5, pc, asr ip
    1a78:	5f4d5241 	svcpl	0x004d5241
    1a7c:	41005356 	tstmi	r0, r6, asr r3
    1a80:	475f4d52 			; <UNDEFINED> instruction: 0x475f4d52
    1a84:	72610045 	rsbvc	r0, r1, #69	; 0x45
    1a88:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    1a8c:	735f656e 	cmpvc	pc, #461373440	; 0x1b800000
    1a90:	6e6f7274 	mcrvs	2, 3, r7, cr15, cr4, {3}
    1a94:	6d726167 	ldfvse	f6, [r2, #-412]!	; 0xfffffe64
    1a98:	6d6f6300 	stclvs	3, cr6, [pc, #-0]	; 1aa0 <shift+0x1aa0>
    1a9c:	78656c70 	stmdavc	r5!, {r4, r5, r6, sl, fp, sp, lr}^
    1aa0:	6f6c6620 	svcvs	0x006c6620
    1aa4:	54007461 	strpl	r7, [r0], #-1121	; 0xfffffb9f
    1aa8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1aac:	50435f54 	subpl	r5, r3, r4, asr pc
    1ab0:	6f635f55 	svcvs	0x00635f55
    1ab4:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1ab8:	00353161 	eorseq	r3, r5, r1, ror #2
    1abc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1ac0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1ac4:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    1ac8:	36323761 	ldrtcc	r3, [r2], -r1, ror #14
    1acc:	54006574 	strpl	r6, [r0], #-1396	; 0xfffffa8c
    1ad0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1ad4:	50435f54 	subpl	r5, r3, r4, asr pc
    1ad8:	6f635f55 	svcvs	0x00635f55
    1adc:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1ae0:	00373161 	eorseq	r3, r7, r1, ror #2
    1ae4:	5f4d5241 	svcpl	0x004d5241
    1ae8:	54005447 	strpl	r5, [r0], #-1095	; 0xfffffbb9
    1aec:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1af0:	50435f54 	subpl	r5, r3, r4, asr pc
    1af4:	656e5f55 	strbvs	r5, [lr, #-3925]!	; 0xfffff0ab
    1af8:	7265766f 	rsbvc	r7, r5, #116391936	; 0x6f00000
    1afc:	316e6573 	smccc	58963	; 0xe653
    1b00:	2f2e2e00 	svccs	0x002e2e00
    1b04:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1b08:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1b0c:	2f2e2e2f 	svccs	0x002e2e2f
    1b10:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 1a60 <shift+0x1a60>
    1b14:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1b18:	696c2f63 	stmdbvs	ip!, {r0, r1, r5, r6, r8, r9, sl, fp, sp}^
    1b1c:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1b20:	00632e32 	rsbeq	r2, r3, r2, lsr lr
    1b24:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1b28:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1b2c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1b30:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1b34:	66347278 			; <UNDEFINED> instruction: 0x66347278
    1b38:	53414200 	movtpl	r4, #4608	; 0x1200
    1b3c:	52415f45 	subpl	r5, r1, #276	; 0x114
    1b40:	375f4843 	ldrbcc	r4, [pc, -r3, asr #16]
    1b44:	54004d45 	strpl	r4, [r0], #-3397	; 0xfffff2bb
    1b48:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1b4c:	50435f54 	subpl	r5, r3, r4, asr pc
    1b50:	6f635f55 	svcvs	0x00635f55
    1b54:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1b58:	00323161 	eorseq	r3, r2, r1, ror #2
    1b5c:	68736168 	ldmdavs	r3!, {r3, r5, r6, r8, sp, lr}^
    1b60:	5f6c6176 	svcpl	0x006c6176
    1b64:	41420074 	hvcmi	8196	; 0x2004
    1b68:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1b6c:	5f484352 	svcpl	0x00484352
    1b70:	005a4b36 	subseq	r4, sl, r6, lsr fp
    1b74:	5f617369 	svcpl	0x00617369
    1b78:	73746962 	cmnvc	r4, #1605632	; 0x188000
    1b7c:	6d726100 	ldfvse	f6, [r2, #-0]
    1b80:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1b84:	72615f68 	rsbvc	r5, r1, #104, 30	; 0x1a0
    1b88:	77685f6d 	strbvc	r5, [r8, -sp, ror #30]!
    1b8c:	00766964 	rsbseq	r6, r6, r4, ror #18
    1b90:	5f6d7261 	svcpl	0x006d7261
    1b94:	5f757066 	svcpl	0x00757066
    1b98:	63736564 	cmnvs	r3, #100, 10	; 0x19000000
    1b9c:	61736900 	cmnvs	r3, r0, lsl #18
    1ba0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1ba4:	3170665f 	cmncc	r0, pc, asr r6
    1ba8:	4e470036 	mcrmi	0, 2, r0, cr7, cr6, {1}
    1bac:	31432055 	qdaddcc	r2, r5, r3
    1bb0:	2e392037 	mrccs	0, 1, r2, cr9, cr7, {1}
    1bb4:	20312e32 	eorscs	r2, r1, r2, lsr lr
    1bb8:	39313032 	ldmdbcc	r1!, {r1, r4, r5, ip, sp}
    1bbc:	35323031 	ldrcc	r3, [r2, #-49]!	; 0xffffffcf
    1bc0:	65722820 	ldrbvs	r2, [r2, #-2080]!	; 0xfffff7e0
    1bc4:	7361656c 	cmnvc	r1, #108, 10	; 0x1b000000
    1bc8:	5b202965 	blpl	80c164 <__bss_end+0x803128>
    1bcc:	2f4d5241 	svccs	0x004d5241
    1bd0:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    1bd4:	72622d39 	rsbvc	r2, r2, #3648	; 0xe40
    1bd8:	68636e61 	stmdavs	r3!, {r0, r5, r6, r9, sl, fp, sp, lr}^
    1bdc:	76657220 	strbtvc	r7, [r5], -r0, lsr #4
    1be0:	6f697369 	svcvs	0x00697369
    1be4:	3732206e 	ldrcc	r2, [r2, -lr, rrx]!
    1be8:	39393537 	ldmdbcc	r9!, {r0, r1, r2, r4, r5, r8, sl, ip, sp}
    1bec:	6d2d205d 	stcvs	0, cr2, [sp, #-372]!	; 0xfffffe8c
    1bf0:	206d7261 	rsbcs	r7, sp, r1, ror #4
    1bf4:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
    1bf8:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
    1bfc:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
    1c00:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    1c04:	616d2d20 	cmnvs	sp, r0, lsr #26
    1c08:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
    1c0c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1c10:	2b657435 	blcs	195ecec <__bss_end+0x1955cb0>
    1c14:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    1c18:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    1c1c:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    1c20:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    1c24:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    1c28:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    1c2c:	7562662d 	strbvc	r6, [r2, #-1581]!	; 0xfffff9d3
    1c30:	69646c69 	stmdbvs	r4!, {r0, r3, r5, r6, sl, fp, sp, lr}^
    1c34:	6c2d676e 	stcvs	7, cr6, [sp], #-440	; 0xfffffe48
    1c38:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1c3c:	662d2063 	strtvs	r2, [sp], -r3, rrx
    1c40:	732d6f6e 			; <UNDEFINED> instruction: 0x732d6f6e
    1c44:	6b636174 	blvs	18da21c <__bss_end+0x18d11e0>
    1c48:	6f72702d 	svcvs	0x0072702d
    1c4c:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
    1c50:	2d20726f 	sfmcs	f7, 4, [r0, #-444]!	; 0xfffffe44
    1c54:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 1ac4 <shift+0x1ac4>
    1c58:	696c6e69 	stmdbvs	ip!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
    1c5c:	2d20656e 	cfstr32cs	mvfx6, [r0, #-440]!	; 0xfffffe48
    1c60:	73697666 	cmnvc	r9, #106954752	; 0x6600000
    1c64:	6c696269 	sfmvs	f6, 2, [r9], #-420	; 0xfffffe5c
    1c68:	3d797469 	cfldrdcc	mvd7, [r9, #-420]!	; 0xfffffe5c
    1c6c:	64646968 	strbtvs	r6, [r4], #-2408	; 0xfffff698
    1c70:	41006e65 	tstmi	r0, r5, ror #28
    1c74:	485f4d52 	ldmdami	pc, {r1, r4, r6, r8, sl, fp, lr}^	; <UNPREDICTABLE>
    1c78:	73690049 	cmnvc	r9, #73	; 0x49
    1c7c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1c80:	64615f74 	strbtvs	r5, [r1], #-3956	; 0xfffff08c
    1c84:	54007669 	strpl	r7, [r0], #-1641	; 0xfffff997
    1c88:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1c8c:	50435f54 	subpl	r5, r3, r4, asr pc
    1c90:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1c94:	3331316d 	teqcc	r1, #1073741851	; 0x4000001b
    1c98:	00736a36 	rsbseq	r6, r3, r6, lsr sl
    1c9c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1ca0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1ca4:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1ca8:	00386d72 	eorseq	r6, r8, r2, ror sp
    1cac:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1cb0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1cb4:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1cb8:	00396d72 	eorseq	r6, r9, r2, ror sp
    1cbc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1cc0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1cc4:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    1cc8:	36323661 	ldrtcc	r3, [r2], -r1, ror #12
    1ccc:	6e6f6c00 	cdpvs	12, 6, cr6, cr15, cr0, {0}
    1cd0:	6f6c2067 	svcvs	0x006c2067
    1cd4:	7520676e 	strvc	r6, [r0, #-1902]!	; 0xfffff892
    1cd8:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
    1cdc:	2064656e 	rsbcs	r6, r4, lr, ror #10
    1ce0:	00746e69 	rsbseq	r6, r4, r9, ror #28
    1ce4:	5f6d7261 	svcpl	0x006d7261
    1ce8:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1cec:	736d635f 	cmnvc	sp, #2080374785	; 0x7c000001
    1cf0:	41540065 	cmpmi	r4, r5, rrx
    1cf4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1cf8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1cfc:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1d00:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1d04:	41540034 	cmpmi	r4, r4, lsr r0
    1d08:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1d0c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1d10:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1d14:	00653031 	rsbeq	r3, r5, r1, lsr r0
    1d18:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1d1c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1d20:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1d24:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1d28:	00376d78 	eorseq	r6, r7, r8, ror sp
    1d2c:	5f6d7261 	svcpl	0x006d7261
    1d30:	646e6f63 	strbtvs	r6, [lr], #-3939	; 0xfffff09d
    1d34:	646f635f 	strbtvs	r6, [pc], #-863	; 1d3c <shift+0x1d3c>
    1d38:	52410065 	subpl	r0, r1, #101	; 0x65
    1d3c:	43505f4d 	cmpmi	r0, #308	; 0x134
    1d40:	41415f53 	cmpmi	r1, r3, asr pc
    1d44:	00534350 	subseq	r4, r3, r0, asr r3
    1d48:	5f617369 	svcpl	0x00617369
    1d4c:	5f746962 	svcpl	0x00746962
    1d50:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1d54:	00325f38 	eorseq	r5, r2, r8, lsr pc
    1d58:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1d5c:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1d60:	4d335f48 	ldcmi	15, cr5, [r3, #-288]!	; 0xfffffee0
    1d64:	52415400 	subpl	r5, r1, #0, 8
    1d68:	5f544547 	svcpl	0x00544547
    1d6c:	5f555043 	svcpl	0x00555043
    1d70:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    1d74:	00743031 	rsbseq	r3, r4, r1, lsr r0
    1d78:	5f6d7261 	svcpl	0x006d7261
    1d7c:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1d80:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    1d84:	3274786d 	rsbscc	r7, r4, #7143424	; 0x6d0000
    1d88:	61736900 	cmnvs	r3, r0, lsl #18
    1d8c:	6d756e5f 	ldclvs	14, cr6, [r5, #-380]!	; 0xfffffe84
    1d90:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1d94:	41540073 	cmpmi	r4, r3, ror r0
    1d98:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1d9c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1da0:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1da4:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1da8:	756c7030 	strbvc	r7, [ip, #-48]!	; 0xffffffd0
    1dac:	616d7373 	smcvs	55091	; 0xd733
    1db0:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    1db4:	7069746c 	rsbvc	r7, r9, ip, ror #8
    1db8:	5400796c 	strpl	r7, [r0], #-2412	; 0xfffff694
    1dbc:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1dc0:	50435f54 	subpl	r5, r3, r4, asr pc
    1dc4:	78655f55 	stmdavc	r5!, {r0, r2, r4, r6, r8, r9, sl, fp, ip, lr}^
    1dc8:	736f6e79 	cmnvc	pc, #1936	; 0x790
    1dcc:	5400316d 	strpl	r3, [r0], #-365	; 0xfffffe93
    1dd0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1dd4:	50435f54 	subpl	r5, r3, r4, asr pc
    1dd8:	6f635f55 	svcvs	0x00635f55
    1ddc:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1de0:	00323572 	eorseq	r3, r2, r2, ror r5
    1de4:	5f617369 	svcpl	0x00617369
    1de8:	5f746962 	svcpl	0x00746962
    1dec:	76696474 			; <UNDEFINED> instruction: 0x76696474
    1df0:	65727000 	ldrbvs	r7, [r2, #-0]!
    1df4:	5f726566 	svcpl	0x00726566
    1df8:	6e6f656e 	cdpvs	5, 6, cr6, cr15, cr14, {3}
    1dfc:	726f665f 	rsbvc	r6, pc, #99614720	; 0x5f00000
    1e00:	6234365f 	eorsvs	r3, r4, #99614720	; 0x5f00000
    1e04:	00737469 	rsbseq	r7, r3, r9, ror #8
    1e08:	5f617369 	svcpl	0x00617369
    1e0c:	5f746962 	svcpl	0x00746962
    1e10:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    1e14:	006c6d66 	rsbeq	r6, ip, r6, ror #26
    1e18:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1e1c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1e20:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1e24:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1e28:	32336178 	eorscc	r6, r3, #120, 2
    1e2c:	52415400 	subpl	r5, r1, #0, 8
    1e30:	5f544547 	svcpl	0x00544547
    1e34:	5f555043 	svcpl	0x00555043
    1e38:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1e3c:	33617865 	cmncc	r1, #6619136	; 0x650000
    1e40:	73690035 	cmnvc	r9, #53	; 0x35
    1e44:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1e48:	70665f74 	rsbvc	r5, r6, r4, ror pc
    1e4c:	6f633631 	svcvs	0x00633631
    1e50:	7500766e 	strvc	r7, [r0, #-1646]	; 0xfffff992
    1e54:	6570736e 	ldrbvs	r7, [r0, #-878]!	; 0xfffffc92
    1e58:	735f7663 	cmpvc	pc, #103809024	; 0x6300000
    1e5c:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
    1e60:	54007367 	strpl	r7, [r0], #-871	; 0xfffffc99
    1e64:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1e68:	50435f54 	subpl	r5, r3, r4, asr pc
    1e6c:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1e70:	3531316d 	ldrcc	r3, [r1, #-365]!	; 0xfffffe93
    1e74:	73327436 	teqvc	r2, #905969664	; 0x36000000
    1e78:	52415400 	subpl	r5, r1, #0, 8
    1e7c:	5f544547 	svcpl	0x00544547
    1e80:	5f555043 	svcpl	0x00555043
    1e84:	30366166 	eorscc	r6, r6, r6, ror #2
    1e88:	00657436 	rsbeq	r7, r5, r6, lsr r4
    1e8c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1e90:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1e94:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1e98:	32396d72 	eorscc	r6, r9, #7296	; 0x1c80
    1e9c:	736a6536 	cmnvc	sl, #226492416	; 0xd800000
    1ea0:	53414200 	movtpl	r4, #4608	; 0x1200
    1ea4:	52415f45 	subpl	r5, r1, #276	; 0x114
    1ea8:	345f4843 	ldrbcc	r4, [pc], #-2115	; 1eb0 <shift+0x1eb0>
    1eac:	73690054 	cmnvc	r9, #84	; 0x54
    1eb0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1eb4:	72635f74 	rsbvc	r5, r3, #116, 30	; 0x1d0
    1eb8:	6f747079 	svcvs	0x00747079
    1ebc:	6d726100 	ldfvse	f6, [r2, #-0]
    1ec0:	6765725f 			; <UNDEFINED> instruction: 0x6765725f
    1ec4:	6e695f73 	mcrvs	15, 3, r5, cr9, cr3, {3}
    1ec8:	7165735f 	cmnvc	r5, pc, asr r3
    1ecc:	636e6575 	cmnvs	lr, #490733568	; 0x1d400000
    1ed0:	73690065 	cmnvc	r9, #101	; 0x65
    1ed4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1ed8:	62735f74 	rsbsvs	r5, r3, #116, 30	; 0x1d0
    1edc:	53414200 	movtpl	r4, #4608	; 0x1200
    1ee0:	52415f45 	subpl	r5, r1, #276	; 0x114
    1ee4:	355f4843 	ldrbcc	r4, [pc, #-2115]	; 16a9 <shift+0x16a9>
    1ee8:	69004554 	stmdbvs	r0, {r2, r4, r6, r8, sl, lr}
    1eec:	665f6173 			; <UNDEFINED> instruction: 0x665f6173
    1ef0:	75746165 	ldrbvc	r6, [r4, #-357]!	; 0xfffffe9b
    1ef4:	69006572 	stmdbvs	r0, {r1, r4, r5, r6, r8, sl, sp, lr}
    1ef8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1efc:	735f7469 	cmpvc	pc, #1761607680	; 0x69000000
    1f00:	6c6c616d 	stfvse	f6, [ip], #-436	; 0xfffffe4c
    1f04:	006c756d 	rsbeq	r7, ip, sp, ror #10
    1f08:	5f6d7261 	svcpl	0x006d7261
    1f0c:	676e616c 	strbvs	r6, [lr, -ip, ror #2]!
    1f10:	74756f5f 	ldrbtvc	r6, [r5], #-3935	; 0xfffff0a1
    1f14:	5f747570 	svcpl	0x00747570
    1f18:	656a626f 	strbvs	r6, [sl, #-623]!	; 0xfffffd91
    1f1c:	615f7463 	cmpvs	pc, r3, ror #8
    1f20:	69727474 	ldmdbvs	r2!, {r2, r4, r5, r6, sl, ip, sp, lr}^
    1f24:	65747562 	ldrbvs	r7, [r4, #-1378]!	; 0xfffffa9e
    1f28:	6f685f73 	svcvs	0x00685f73
    1f2c:	69006b6f 	stmdbvs	r0, {r0, r1, r2, r3, r5, r6, r8, r9, fp, sp, lr}
    1f30:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1f34:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1f38:	33645f70 	cmncc	r4, #112, 30	; 0x1c0
    1f3c:	52410032 	subpl	r0, r1, #50	; 0x32
    1f40:	454e5f4d 	strbmi	r5, [lr, #-3917]	; 0xfffff0b3
    1f44:	61736900 	cmnvs	r3, r0, lsl #18
    1f48:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1f4c:	3865625f 	stmdacc	r5!, {r0, r1, r2, r3, r4, r6, r9, sp, lr}^
    1f50:	52415400 	subpl	r5, r1, #0, 8
    1f54:	5f544547 	svcpl	0x00544547
    1f58:	5f555043 	svcpl	0x00555043
    1f5c:	316d7261 	cmncc	sp, r1, ror #4
    1f60:	6a363731 	bvs	d8fc2c <__bss_end+0xd86bf0>
    1f64:	7000737a 	andvc	r7, r0, sl, ror r3
    1f68:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1f6c:	726f7373 	rsbvc	r7, pc, #-872415231	; 0xcc000001
    1f70:	7079745f 	rsbsvc	r7, r9, pc, asr r4
    1f74:	6c610065 	stclvs	0, cr0, [r1], #-404	; 0xfffffe6c
    1f78:	70665f6c 	rsbvc	r5, r6, ip, ror #30
    1f7c:	61007375 	tstvs	r0, r5, ror r3
    1f80:	705f6d72 	subsvc	r6, pc, r2, ror sp	; <UNPREDICTABLE>
    1f84:	42007363 	andmi	r7, r0, #-1946157055	; 0x8c000001
    1f88:	5f455341 	svcpl	0x00455341
    1f8c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1f90:	0054355f 	subseq	r3, r4, pc, asr r5
    1f94:	5f6d7261 	svcpl	0x006d7261
    1f98:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1f9c:	54007434 	strpl	r7, [r0], #-1076	; 0xfffffbcc
    1fa0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1fa4:	50435f54 	subpl	r5, r3, r4, asr pc
    1fa8:	6f635f55 	svcvs	0x00635f55
    1fac:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1fb0:	63363761 	teqvs	r6, #25427968	; 0x1840000
    1fb4:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1fb8:	35356178 	ldrcc	r6, [r5, #-376]!	; 0xfffffe88
    1fbc:	6d726100 	ldfvse	f6, [r2, #-0]
    1fc0:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    1fc4:	62775f65 	rsbsvs	r5, r7, #404	; 0x194
    1fc8:	68006675 	stmdavs	r0, {r0, r2, r4, r5, r6, r9, sl, sp, lr}
    1fcc:	5f626174 	svcpl	0x00626174
    1fd0:	68736168 	ldmdavs	r3!, {r3, r5, r6, r8, sp, lr}^
    1fd4:	61736900 	cmnvs	r3, r0, lsl #18
    1fd8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1fdc:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    1fe0:	6e5f6b72 	vmovvs.s8	r6, d15[3]
    1fe4:	6f765f6f 	svcvs	0x00765f6f
    1fe8:	6974616c 	ldmdbvs	r4!, {r2, r3, r5, r6, r8, sp, lr}^
    1fec:	635f656c 	cmpvs	pc, #108, 10	; 0x1b000000
    1ff0:	41540065 	cmpmi	r4, r5, rrx
    1ff4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1ff8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1ffc:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2000:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    2004:	41540030 	cmpmi	r4, r0, lsr r0
    2008:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    200c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2010:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2014:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    2018:	41540031 	cmpmi	r4, r1, lsr r0
    201c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2020:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2024:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2028:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    202c:	73690033 	cmnvc	r9, #51	; 0x33
    2030:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2034:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    2038:	5f38766d 	svcpl	0x0038766d
    203c:	72610031 	rsbvc	r0, r1, #49	; 0x31
    2040:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2044:	6e5f6863 	cdpvs	8, 5, cr6, cr15, cr3, {3}
    2048:	00656d61 	rsbeq	r6, r5, r1, ror #26
    204c:	5f617369 	svcpl	0x00617369
    2050:	5f746962 	svcpl	0x00746962
    2054:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2058:	00335f38 	eorseq	r5, r3, r8, lsr pc
    205c:	5f617369 	svcpl	0x00617369
    2060:	5f746962 	svcpl	0x00746962
    2064:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2068:	00345f38 	eorseq	r5, r4, r8, lsr pc
    206c:	5f617369 	svcpl	0x00617369
    2070:	5f746962 	svcpl	0x00746962
    2074:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2078:	00355f38 	eorseq	r5, r5, r8, lsr pc
    207c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2080:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2084:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2088:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    208c:	33356178 	teqcc	r5, #120, 2
    2090:	52415400 	subpl	r5, r1, #0, 8
    2094:	5f544547 	svcpl	0x00544547
    2098:	5f555043 	svcpl	0x00555043
    209c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    20a0:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    20a4:	41540035 	cmpmi	r4, r5, lsr r0
    20a8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    20ac:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    20b0:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    20b4:	61786574 	cmnvs	r8, r4, ror r5
    20b8:	54003735 	strpl	r3, [r0], #-1845	; 0xfffff8cb
    20bc:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    20c0:	50435f54 	subpl	r5, r3, r4, asr pc
    20c4:	706d5f55 	rsbvc	r5, sp, r5, asr pc
    20c8:	65726f63 	ldrbvs	r6, [r2, #-3939]!	; 0xfffff09d
    20cc:	52415400 	subpl	r5, r1, #0, 8
    20d0:	5f544547 	svcpl	0x00544547
    20d4:	5f555043 	svcpl	0x00555043
    20d8:	5f6d7261 	svcpl	0x006d7261
    20dc:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    20e0:	6d726100 	ldfvse	f6, [r2, #-0]
    20e4:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    20e8:	6f6e5f68 	svcvs	0x006e5f68
    20ec:	54006d74 	strpl	r6, [r0], #-3444	; 0xfffff28c
    20f0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    20f4:	50435f54 	subpl	r5, r3, r4, asr pc
    20f8:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    20fc:	3230316d 	eorscc	r3, r0, #1073741851	; 0x4000001b
    2100:	736a6536 	cmnvc	sl, #226492416	; 0xd800000
    2104:	53414200 	movtpl	r4, #4608	; 0x1200
    2108:	52415f45 	subpl	r5, r1, #276	; 0x114
    210c:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    2110:	4142004a 	cmpmi	r2, sl, asr #32
    2114:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    2118:	5f484352 	svcpl	0x00484352
    211c:	42004b36 	andmi	r4, r0, #55296	; 0xd800
    2120:	5f455341 	svcpl	0x00455341
    2124:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    2128:	004d365f 	subeq	r3, sp, pc, asr r6
    212c:	5f617369 	svcpl	0x00617369
    2130:	5f746962 	svcpl	0x00746962
    2134:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    2138:	54007478 	strpl	r7, [r0], #-1144	; 0xfffffb88
    213c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2140:	50435f54 	subpl	r5, r3, r4, asr pc
    2144:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    2148:	3331316d 	teqcc	r1, #1073741851	; 0x4000001b
    214c:	73666a36 	cmnvc	r6, #221184	; 0x36000
    2150:	4d524100 	ldfmie	f4, [r2, #-0]
    2154:	00534c5f 	subseq	r4, r3, pc, asr ip
    2158:	5f4d5241 	svcpl	0x004d5241
    215c:	4200544c 	andmi	r5, r0, #76, 8	; 0x4c000000
    2160:	5f455341 	svcpl	0x00455341
    2164:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    2168:	005a365f 	subseq	r3, sl, pc, asr r6
    216c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2170:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2174:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2178:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    217c:	35376178 	ldrcc	r6, [r7, #-376]!	; 0xfffffe88
    2180:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2184:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    2188:	52410035 	subpl	r0, r1, #53	; 0x35
    218c:	43505f4d 	cmpmi	r0, #308	; 0x134
    2190:	41415f53 	cmpmi	r1, r3, asr pc
    2194:	5f534350 	svcpl	0x00534350
    2198:	00504656 	subseq	r4, r0, r6, asr r6
    219c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    21a0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    21a4:	695f5550 	ldmdbvs	pc, {r4, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
    21a8:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    21ac:	69003274 	stmdbvs	r0, {r2, r4, r5, r6, r9, ip, sp}
    21b0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    21b4:	6e5f7469 	cdpvs	4, 5, cr7, cr15, cr9, {3}
    21b8:	006e6f65 	rsbeq	r6, lr, r5, ror #30
    21bc:	5f6d7261 	svcpl	0x006d7261
    21c0:	5f757066 	svcpl	0x00757066
    21c4:	72747461 	rsbsvc	r7, r4, #1627389952	; 0x61000000
    21c8:	61736900 	cmnvs	r3, r0, lsl #18
    21cc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    21d0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    21d4:	6d653776 	stclvs	7, cr3, [r5, #-472]!	; 0xfffffe28
    21d8:	52415400 	subpl	r5, r1, #0, 8
    21dc:	5f544547 	svcpl	0x00544547
    21e0:	5f555043 	svcpl	0x00555043
    21e4:	32366166 	eorscc	r6, r6, #-2147483623	; 0x80000019
    21e8:	00657436 	rsbeq	r7, r5, r6, lsr r4
    21ec:	47524154 			; <UNDEFINED> instruction: 0x47524154
    21f0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    21f4:	6d5f5550 	cfldr64vs	mvdx5, [pc, #-320]	; 20bc <shift+0x20bc>
    21f8:	65767261 	ldrbvs	r7, [r6, #-609]!	; 0xfffffd9f
    21fc:	705f6c6c 	subsvc	r6, pc, ip, ror #24
    2200:	6800346a 	stmdavs	r0, {r1, r3, r5, r6, sl, ip, sp}
    2204:	5f626174 	svcpl	0x00626174
    2208:	68736168 	ldmdavs	r3!, {r3, r5, r6, r8, sp, lr}^
    220c:	696f705f 	stmdbvs	pc!, {r0, r1, r2, r3, r4, r6, ip, sp, lr}^	; <UNPREDICTABLE>
    2210:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    2214:	6d726100 	ldfvse	f6, [r2, #-0]
    2218:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    221c:	6f635f65 	svcvs	0x00635f65
    2220:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2224:	0039615f 	eorseq	r6, r9, pc, asr r1
    2228:	5f617369 	svcpl	0x00617369
    222c:	5f746962 	svcpl	0x00746962
    2230:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    2234:	00327478 	eorseq	r7, r2, r8, ror r4
    2238:	47524154 			; <UNDEFINED> instruction: 0x47524154
    223c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2240:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2244:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2248:	32376178 	eorscc	r6, r7, #120, 2
    224c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2250:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    2254:	73690033 	cmnvc	r9, #51	; 0x33
    2258:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    225c:	68745f74 	ldmdavs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    2260:	32626d75 	rsbcc	r6, r2, #7488	; 0x1d40
    2264:	53414200 	movtpl	r4, #4608	; 0x1200
    2268:	52415f45 	subpl	r5, r1, #276	; 0x114
    226c:	375f4843 	ldrbcc	r4, [pc, -r3, asr #16]
    2270:	73690041 	cmnvc	r9, #65	; 0x41
    2274:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2278:	6f645f74 	svcvs	0x00645f74
    227c:	6f727074 	svcvs	0x00727074
    2280:	72610064 	rsbvc	r0, r1, #100	; 0x64
    2284:	70665f6d 	rsbvc	r5, r6, sp, ror #30
    2288:	745f3631 	ldrbvc	r3, [pc], #-1585	; 2290 <shift+0x2290>
    228c:	5f657079 	svcpl	0x00657079
    2290:	65646f6e 	strbvs	r6, [r4, #-3950]!	; 0xfffff092
    2294:	4d524100 	ldfmie	f4, [r2, #-0]
    2298:	00494d5f 	subeq	r4, r9, pc, asr sp
    229c:	5f6d7261 	svcpl	0x006d7261
    22a0:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    22a4:	61006b36 	tstvs	r0, r6, lsr fp
    22a8:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    22ac:	36686372 			; <UNDEFINED> instruction: 0x36686372
    22b0:	4142006d 	cmpmi	r2, sp, rrx
    22b4:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    22b8:	5f484352 	svcpl	0x00484352
    22bc:	5f005237 	svcpl	0x00005237
    22c0:	706f705f 	rsbvc	r7, pc, pc, asr r0	; <UNPREDICTABLE>
    22c4:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
    22c8:	61745f74 	cmnvs	r4, r4, ror pc
    22cc:	73690062 	cmnvc	r9, #98	; 0x62
    22d0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    22d4:	6d635f74 	stclvs	15, cr5, [r3, #-464]!	; 0xfffffe30
    22d8:	54006573 	strpl	r6, [r0], #-1395	; 0xfffffa8d
    22dc:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    22e0:	50435f54 	subpl	r5, r3, r4, asr pc
    22e4:	6f635f55 	svcvs	0x00635f55
    22e8:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    22ec:	00333761 	eorseq	r3, r3, r1, ror #14
    22f0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    22f4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    22f8:	675f5550 			; <UNDEFINED> instruction: 0x675f5550
    22fc:	72656e65 	rsbvc	r6, r5, #1616	; 0x650
    2300:	37766369 	ldrbcc	r6, [r6, -r9, ror #6]!
    2304:	41540061 	cmpmi	r4, r1, rrx
    2308:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    230c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2310:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2314:	61786574 	cmnvs	r8, r4, ror r5
    2318:	61003637 	tstvs	r0, r7, lsr r6
    231c:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2320:	5f686372 	svcpl	0x00686372
    2324:	765f6f6e 	ldrbvc	r6, [pc], -lr, ror #30
    2328:	74616c6f 	strbtvc	r6, [r1], #-3183	; 0xfffff391
    232c:	5f656c69 	svcpl	0x00656c69
    2330:	42006563 	andmi	r6, r0, #415236096	; 0x18c00000
    2334:	5f455341 	svcpl	0x00455341
    2338:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    233c:	0041385f 	subeq	r3, r1, pc, asr r8
    2340:	5f617369 	svcpl	0x00617369
    2344:	5f746962 	svcpl	0x00746962
    2348:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    234c:	42007435 	andmi	r7, r0, #889192448	; 0x35000000
    2350:	5f455341 	svcpl	0x00455341
    2354:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    2358:	0052385f 	subseq	r3, r2, pc, asr r8
    235c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2360:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2364:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2368:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    236c:	33376178 	teqcc	r7, #120, 2
    2370:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2374:	33617865 	cmncc	r1, #6619136	; 0x650000
    2378:	52410035 	subpl	r0, r1, #53	; 0x35
    237c:	564e5f4d 	strbpl	r5, [lr], -sp, asr #30
    2380:	6d726100 	ldfvse	f6, [r2, #-0]
    2384:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2388:	61003468 	tstvs	r0, r8, ror #8
    238c:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2390:	36686372 			; <UNDEFINED> instruction: 0x36686372
    2394:	6d726100 	ldfvse	f6, [r2, #-0]
    2398:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    239c:	61003768 	tstvs	r0, r8, ror #14
    23a0:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    23a4:	38686372 	stmdacc	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    23a8:	6e6f6c00 	cdpvs	12, 6, cr6, cr15, cr0, {0}
    23ac:	6f642067 	svcvs	0x00642067
    23b0:	656c6275 	strbvs	r6, [ip, #-629]!	; 0xfffffd8b
    23b4:	6d726100 	ldfvse	f6, [r2, #-0]
    23b8:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    23bc:	73785f65 	cmnvc	r8, #404	; 0x194
    23c0:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    23c4:	6b616d00 	blvs	185d7cc <__bss_end+0x1854790>
    23c8:	5f676e69 	svcpl	0x00676e69
    23cc:	736e6f63 	cmnvc	lr, #396	; 0x18c
    23d0:	61745f74 	cmnvs	r4, r4, ror pc
    23d4:	00656c62 	rsbeq	r6, r5, r2, ror #24
    23d8:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    23dc:	61635f62 	cmnvs	r3, r2, ror #30
    23e0:	765f6c6c 	ldrbvc	r6, [pc], -ip, ror #24
    23e4:	6c5f6169 	ldfvse	f6, [pc], {105}	; 0x69
    23e8:	6c656261 	sfmvs	f6, 2, [r5], #-388	; 0xfffffe7c
    23ec:	61736900 	cmnvs	r3, r0, lsl #18
    23f0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    23f4:	7670665f 			; <UNDEFINED> instruction: 0x7670665f
    23f8:	73690035 	cmnvc	r9, #53	; 0x35
    23fc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2400:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    2404:	6b36766d 	blvs	d9fdc0 <__bss_end+0xd96d84>
    2408:	52415400 	subpl	r5, r1, #0, 8
    240c:	5f544547 	svcpl	0x00544547
    2410:	5f555043 	svcpl	0x00555043
    2414:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2418:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    241c:	52415400 	subpl	r5, r1, #0, 8
    2420:	5f544547 	svcpl	0x00544547
    2424:	5f555043 	svcpl	0x00555043
    2428:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    242c:	38617865 	stmdacc	r1!, {r0, r2, r5, r6, fp, ip, sp, lr}^
    2430:	52415400 	subpl	r5, r1, #0, 8
    2434:	5f544547 	svcpl	0x00544547
    2438:	5f555043 	svcpl	0x00555043
    243c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2440:	39617865 	stmdbcc	r1!, {r0, r2, r5, r6, fp, ip, sp, lr}^
    2444:	4d524100 	ldfmie	f4, [r2, #-0]
    2448:	5343505f 	movtpl	r5, #12383	; 0x305f
    244c:	4350415f 	cmpmi	r0, #-1073741801	; 0xc0000017
    2450:	52410053 	subpl	r0, r1, #83	; 0x53
    2454:	43505f4d 	cmpmi	r0, #308	; 0x134
    2458:	54415f53 	strbpl	r5, [r1], #-3923	; 0xfffff0ad
    245c:	00534350 	subseq	r4, r3, r0, asr r3
    2460:	706d6f63 	rsbvc	r6, sp, r3, ror #30
    2464:	2078656c 	rsbscs	r6, r8, ip, ror #10
    2468:	62756f64 	rsbsvs	r6, r5, #100, 30	; 0x190
    246c:	5400656c 	strpl	r6, [r0], #-1388	; 0xfffffa94
    2470:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2474:	50435f54 	subpl	r5, r3, r4, asr pc
    2478:	6f635f55 	svcvs	0x00635f55
    247c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2480:	63333761 	teqvs	r3, #25427968	; 0x1840000
    2484:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2488:	33356178 	teqcc	r5, #120, 2
    248c:	52415400 	subpl	r5, r1, #0, 8
    2490:	5f544547 	svcpl	0x00544547
    2494:	5f555043 	svcpl	0x00555043
    2498:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    249c:	306d7865 	rsbcc	r7, sp, r5, ror #16
    24a0:	73756c70 	cmnvc	r5, #112, 24	; 0x7000
    24a4:	6d726100 	ldfvse	f6, [r2, #-0]
    24a8:	0063635f 	rsbeq	r6, r3, pc, asr r3
    24ac:	5f617369 	svcpl	0x00617369
    24b0:	5f746962 	svcpl	0x00746962
    24b4:	61637378 	smcvs	14136	; 0x3738
    24b8:	5f00656c 	svcpl	0x0000656c
    24bc:	746e6f64 	strbtvc	r6, [lr], #-3940	; 0xfffff09c
    24c0:	6573755f 	ldrbvs	r7, [r3, #-1375]!	; 0xfffffaa1
    24c4:	6572745f 	ldrbvs	r7, [r2, #-1119]!	; 0xfffffba1
    24c8:	65685f65 	strbvs	r5, [r8, #-3941]!	; 0xfffff09b
    24cc:	005f6572 	subseq	r6, pc, r2, ror r5	; <UNPREDICTABLE>
    24d0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    24d4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    24d8:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    24dc:	30316d72 	eorscc	r6, r1, r2, ror sp
    24e0:	696d6474 	stmdbvs	sp!, {r2, r4, r5, r6, sl, sp, lr}^
    24e4:	52415400 	subpl	r5, r1, #0, 8
    24e8:	5f544547 	svcpl	0x00544547
    24ec:	5f555043 	svcpl	0x00555043
    24f0:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    24f4:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    24f8:	73616200 	cmnvc	r1, #0, 4
    24fc:	72615f65 	rsbvc	r5, r1, #404	; 0x194
    2500:	74696863 	strbtvc	r6, [r9], #-2147	; 0xfffff79d
    2504:	75746365 	ldrbvc	r6, [r4, #-869]!	; 0xfffffc9b
    2508:	61006572 	tstvs	r0, r2, ror r5
    250c:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2510:	5f686372 	svcpl	0x00686372
    2514:	00637263 	rsbeq	r7, r3, r3, ror #4
    2518:	47524154 			; <UNDEFINED> instruction: 0x47524154
    251c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2520:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2524:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2528:	73316d78 	teqvc	r1, #120, 26	; 0x1e00
    252c:	6c6c616d 	stfvse	f6, [ip], #-436	; 0xfffffe4c
    2530:	746c756d 	strbtvc	r7, [ip], #-1389	; 0xfffffa93
    2534:	796c7069 	stmdbvc	ip!, {r0, r3, r5, r6, ip, sp, lr}^
    2538:	6d726100 	ldfvse	f6, [r2, #-0]
    253c:	7275635f 	rsbsvc	r6, r5, #2080374785	; 0x7c000001
    2540:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
    2544:	0063635f 	rsbeq	r6, r3, pc, asr r3
    2548:	5f617369 	svcpl	0x00617369
    254c:	5f746962 	svcpl	0x00746962
    2550:	33637263 	cmncc	r3, #805306374	; 0x30000006
    2554:	52410032 	subpl	r0, r1, #50	; 0x32
    2558:	4c505f4d 	mrrcmi	15, 4, r5, r0, cr13
    255c:	61736900 	cmnvs	r3, r0, lsl #18
    2560:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2564:	7066765f 	rsbvc	r7, r6, pc, asr r6
    2568:	69003376 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, r9, ip, sp}
    256c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2570:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    2574:	34767066 	ldrbtcc	r7, [r6], #-102	; 0xffffff9a
    2578:	53414200 	movtpl	r4, #4608	; 0x1200
    257c:	52415f45 	subpl	r5, r1, #276	; 0x114
    2580:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    2584:	42003254 	andmi	r3, r0, #84, 4	; 0x40000005
    2588:	5f455341 	svcpl	0x00455341
    258c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    2590:	5f4d385f 	svcpl	0x004d385f
    2594:	4e49414d 	dvfmiem	f4, f1, #5.0
    2598:	52415400 	subpl	r5, r1, #0, 8
    259c:	5f544547 	svcpl	0x00544547
    25a0:	5f555043 	svcpl	0x00555043
    25a4:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    25a8:	696d6474 	stmdbvs	sp!, {r2, r4, r5, r6, sl, sp, lr}^
    25ac:	4d524100 	ldfmie	f4, [r2, #-0]
    25b0:	004c415f 	subeq	r4, ip, pc, asr r1
    25b4:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    25b8:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    25bc:	4d375f48 	ldcmi	15, cr5, [r7, #-288]!	; 0xfffffee0
    25c0:	6d726100 	ldfvse	f6, [r2, #-0]
    25c4:	7261745f 	rsbvc	r7, r1, #1593835520	; 0x5f000000
    25c8:	5f746567 	svcpl	0x00746567
    25cc:	6562616c 	strbvs	r6, [r2, #-364]!	; 0xfffffe94
    25d0:	7261006c 	rsbvc	r0, r1, #108	; 0x6c
    25d4:	61745f6d 	cmnvs	r4, sp, ror #30
    25d8:	74656772 	strbtvc	r6, [r5], #-1906	; 0xfffff88e
    25dc:	736e695f 	cmnvc	lr, #1556480	; 0x17c000
    25e0:	4154006e 	cmpmi	r4, lr, rrx
    25e4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    25e8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    25ec:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    25f0:	72786574 	rsbsvc	r6, r8, #116, 10	; 0x1d000000
    25f4:	41540034 	cmpmi	r4, r4, lsr r0
    25f8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    25fc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2600:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2604:	72786574 	rsbsvc	r6, r8, #116, 10	; 0x1d000000
    2608:	41540035 	cmpmi	r4, r5, lsr r0
    260c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2610:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2614:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2618:	72786574 	rsbsvc	r6, r8, #116, 10	; 0x1d000000
    261c:	41540037 	cmpmi	r4, r7, lsr r0
    2620:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2624:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2628:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    262c:	72786574 	rsbsvc	r6, r8, #116, 10	; 0x1d000000
    2630:	73690038 	cmnvc	r9, #56	; 0x38
    2634:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2638:	706c5f74 	rsbvc	r5, ip, r4, ror pc
    263c:	69006561 	stmdbvs	r0, {r0, r5, r6, r8, sl, sp, lr}
    2640:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2644:	715f7469 	cmpvc	pc, r9, ror #8
    2648:	6b726975 	blvs	1c9cc24 <__bss_end+0x1c93be8>
    264c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2650:	7a6b3676 	bvc	1ad0030 <__bss_end+0x1ac6ff4>
    2654:	61736900 	cmnvs	r3, r0, lsl #18
    2658:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    265c:	746f6e5f 	strbtvc	r6, [pc], #-3679	; 2664 <shift+0x2664>
    2660:	7369006d 	cmnvc	r9, #109	; 0x6d
    2664:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2668:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    266c:	0034766d 	eorseq	r7, r4, sp, ror #12
    2670:	5f617369 	svcpl	0x00617369
    2674:	5f746962 	svcpl	0x00746962
    2678:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    267c:	73690036 	cmnvc	r9, #54	; 0x36
    2680:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2684:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    2688:	0037766d 	eorseq	r7, r7, sp, ror #12
    268c:	5f617369 	svcpl	0x00617369
    2690:	5f746962 	svcpl	0x00746962
    2694:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2698:	645f0038 	ldrbvs	r0, [pc], #-56	; 26a0 <shift+0x26a0>
    269c:	5f746e6f 	svcpl	0x00746e6f
    26a0:	5f657375 	svcpl	0x00657375
    26a4:	5f787472 	svcpl	0x00787472
    26a8:	65726568 	ldrbvs	r6, [r2, #-1384]!	; 0xfffffa98
    26ac:	5155005f 	cmppl	r5, pc, asr r0
    26b0:	70797449 	rsbsvc	r7, r9, r9, asr #8
    26b4:	73690065 	cmnvc	r9, #101	; 0x65
    26b8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    26bc:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    26c0:	7435766d 	ldrtvc	r7, [r5], #-1645	; 0xfffff993
    26c4:	72610065 	rsbvc	r0, r1, #101	; 0x65
    26c8:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    26cc:	6100656e 	tstvs	r0, lr, ror #10
    26d0:	635f6d72 	cmpvs	pc, #7296	; 0x1c80
    26d4:	695f7070 	ldmdbvs	pc, {r4, r5, r6, ip, sp, lr}^	; <UNPREDICTABLE>
    26d8:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    26dc:	6b726f77 	blvs	1c9e4c0 <__bss_end+0x1c95484>
    26e0:	6e756600 	cdpvs	6, 7, cr6, cr5, cr0, {0}
    26e4:	74705f63 	ldrbtvc	r5, [r0], #-3939	; 0xfffff09d
    26e8:	41540072 	cmpmi	r4, r2, ror r0
    26ec:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    26f0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    26f4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    26f8:	74303239 	ldrtvc	r3, [r0], #-569	; 0xfffffdc7
    26fc:	61746800 	cmnvs	r4, r0, lsl #16
    2700:	71655f62 	cmnvc	r5, r2, ror #30
    2704:	52415400 	subpl	r5, r1, #0, 8
    2708:	5f544547 	svcpl	0x00544547
    270c:	5f555043 	svcpl	0x00555043
    2710:	32356166 	eorscc	r6, r5, #-2147483623	; 0x80000019
    2714:	72610036 	rsbvc	r0, r1, #54	; 0x36
    2718:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    271c:	745f6863 	ldrbvc	r6, [pc], #-2147	; 2724 <shift+0x2724>
    2720:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    2724:	6477685f 	ldrbtvs	r6, [r7], #-2143	; 0xfffff7a1
    2728:	68007669 	stmdavs	r0, {r0, r3, r5, r6, r9, sl, ip, sp, lr}
    272c:	5f626174 	svcpl	0x00626174
    2730:	705f7165 	subsvc	r7, pc, r5, ror #2
    2734:	746e696f 	strbtvc	r6, [lr], #-2415	; 0xfffff691
    2738:	61007265 	tstvs	r0, r5, ror #4
    273c:	705f6d72 	subsvc	r6, pc, r2, ror sp	; <UNPREDICTABLE>
    2740:	725f6369 	subsvc	r6, pc, #-1543503871	; 0xa4000001
    2744:	73696765 	cmnvc	r9, #26476544	; 0x1940000
    2748:	00726574 	rsbseq	r6, r2, r4, ror r5
    274c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2750:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2754:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2758:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    275c:	73306d78 	teqvc	r0, #120, 26	; 0x1e00
    2760:	6c6c616d 	stfvse	f6, [ip], #-436	; 0xfffffe4c
    2764:	746c756d 	strbtvc	r7, [ip], #-1389	; 0xfffffa93
    2768:	796c7069 	stmdbvc	ip!, {r0, r3, r5, r6, ip, sp, lr}^
    276c:	52415400 	subpl	r5, r1, #0, 8
    2770:	5f544547 	svcpl	0x00544547
    2774:	5f555043 	svcpl	0x00555043
    2778:	6f63706d 	svcvs	0x0063706d
    277c:	6f6e6572 	svcvs	0x006e6572
    2780:	00706676 	rsbseq	r6, r0, r6, ror r6
    2784:	5f617369 	svcpl	0x00617369
    2788:	5f746962 	svcpl	0x00746962
    278c:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    2790:	6d635f6b 	stclvs	15, cr5, [r3, #-428]!	; 0xfffffe54
    2794:	646c5f33 	strbtvs	r5, [ip], #-3891	; 0xfffff0cd
    2798:	41006472 	tstmi	r0, r2, ror r4
    279c:	435f4d52 	cmpmi	pc, #5248	; 0x1480
    27a0:	72610043 	rsbvc	r0, r1, #67	; 0x43
    27a4:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    27a8:	5f386863 	svcpl	0x00386863
    27ac:	72610032 	rsbvc	r0, r1, #50	; 0x32
    27b0:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    27b4:	5f386863 	svcpl	0x00386863
    27b8:	72610033 	rsbvc	r0, r1, #51	; 0x33
    27bc:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    27c0:	5f386863 	svcpl	0x00386863
    27c4:	41540034 	cmpmi	r4, r4, lsr r0
    27c8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    27cc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    27d0:	706d665f 	rsbvc	r6, sp, pc, asr r6
    27d4:	00363236 	eorseq	r3, r6, r6, lsr r2
    27d8:	5f4d5241 	svcpl	0x004d5241
    27dc:	61005343 	tstvs	r0, r3, asr #6
    27e0:	665f6d72 			; <UNDEFINED> instruction: 0x665f6d72
    27e4:	5f363170 	svcpl	0x00363170
    27e8:	74736e69 	ldrbtvc	r6, [r3], #-3689	; 0xfffff197
    27ec:	6d726100 	ldfvse	f6, [r2, #-0]
    27f0:	7361625f 	cmnvc	r1, #-268435451	; 0xf0000005
    27f4:	72615f65 	rsbvc	r5, r1, #404	; 0x194
    27f8:	54006863 	strpl	r6, [r0], #-2147	; 0xfffff79d
    27fc:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2800:	50435f54 	subpl	r5, r3, r4, asr pc
    2804:	6f635f55 	svcvs	0x00635f55
    2808:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    280c:	63353161 	teqvs	r5, #1073741848	; 0x40000018
    2810:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2814:	00376178 	eorseq	r6, r7, r8, ror r1
    2818:	5f6d7261 	svcpl	0x006d7261
    281c:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2820:	006d6537 	rsbeq	r6, sp, r7, lsr r5
    2824:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2828:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    282c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2830:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2834:	32376178 	eorscc	r6, r7, #120, 2
    2838:	6d726100 	ldfvse	f6, [r2, #-0]
    283c:	7363705f 	cmnvc	r3, #95	; 0x5f
    2840:	6665645f 			; <UNDEFINED> instruction: 0x6665645f
    2844:	746c7561 	strbtvc	r7, [ip], #-1377	; 0xfffffa9f
    2848:	4d524100 	ldfmie	f4, [r2, #-0]
    284c:	5343505f 	movtpl	r5, #12383	; 0x305f
    2850:	5041415f 	subpl	r4, r1, pc, asr r1
    2854:	4c5f5343 	mrrcmi	3, 4, r5, pc, cr3	; <UNPREDICTABLE>
    2858:	4c41434f 	mcrrmi	3, 4, r4, r1, cr15
    285c:	52415400 	subpl	r5, r1, #0, 8
    2860:	5f544547 	svcpl	0x00544547
    2864:	5f555043 	svcpl	0x00555043
    2868:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    286c:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    2870:	41540035 	cmpmi	r4, r5, lsr r0
    2874:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2878:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    287c:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
    2880:	61676e6f 	cmnvs	r7, pc, ror #28
    2884:	61006d72 	tstvs	r0, r2, ror sp
    2888:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    288c:	5f686372 	svcpl	0x00686372
    2890:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    2894:	61003162 	tstvs	r0, r2, ror #2
    2898:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    289c:	5f686372 	svcpl	0x00686372
    28a0:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    28a4:	54003262 	strpl	r3, [r0], #-610	; 0xfffffd9e
    28a8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    28ac:	50435f54 	subpl	r5, r3, r4, asr pc
    28b0:	77695f55 			; <UNDEFINED> instruction: 0x77695f55
    28b4:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    28b8:	6d726100 	ldfvse	f6, [r2, #-0]
    28bc:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    28c0:	00743568 	rsbseq	r3, r4, r8, ror #10
    28c4:	5f617369 	svcpl	0x00617369
    28c8:	5f746962 	svcpl	0x00746962
    28cc:	6100706d 	tstvs	r0, sp, rrx
    28d0:	6c5f6d72 	mrrcvs	13, 7, r6, pc, cr2	; <UNPREDICTABLE>
    28d4:	63735f64 	cmnvs	r3, #100, 30	; 0x190
    28d8:	00646568 	rsbeq	r6, r4, r8, ror #10
    28dc:	5f6d7261 	svcpl	0x006d7261
    28e0:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    28e4:	00315f38 	eorseq	r5, r1, r8, lsr pc

Disassembly of section .debug_frame:

00000000 <.debug_frame>:
   0:	0000000c 	andeq	r0, r0, ip
   4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
   8:	7c020001 	stcvc	0, cr0, [r2], {1}
   c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  10:	0000001c 	andeq	r0, r0, ip, lsl r0
  14:	00000000 	andeq	r0, r0, r0
  18:	00008008 	andeq	r8, r0, r8
  1c:	00000068 	andeq	r0, r0, r8, rrx
  20:	8b040e42 	blhi	103930 <__bss_end+0xfa8f4>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x3477f4>
  28:	420d0d68 	andmi	r0, sp, #104, 26	; 0x1a00
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008070 	andeq	r8, r0, r0, ror r0
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1fa914>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xf9c44>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080b0 	strheq	r8, [r0], -r0
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xfa944>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x347844>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080e8 	andeq	r8, r0, r8, ror #1
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xfa964>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x347864>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008114 	andeq	r8, r0, r4, lsl r1
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xfa984>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x347884>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008134 	andeq	r8, r0, r4, lsr r1
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xfa9a4>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x3478a4>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	0000814c 	andeq	r8, r0, ip, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xfa9c4>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x3478c4>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008164 	andeq	r8, r0, r4, ror #2
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xfa9e4>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x3478e4>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	0000817c 	andeq	r8, r0, ip, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xfaa04>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x347904>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	00008188 	andeq	r8, r0, r8, lsl #3
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1faa1c>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081e0 	andeq	r8, r0, r0, ror #3
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1faa3c>
 16c:	42018e02 	andmi	r8, r1, #2, 28
 170:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 174:	00080d0c 	andeq	r0, r8, ip, lsl #26
 178:	0000000c 	andeq	r0, r0, ip
 17c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 180:	7c020001 	stcvc	0, cr0, [r2], {1}
 184:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 188:	0000001c 	andeq	r0, r0, ip, lsl r0
 18c:	00000178 	andeq	r0, r0, r8, ror r1
 190:	00008238 	andeq	r8, r0, r8, lsr r2
 194:	00000080 	andeq	r0, r0, r0, lsl #1
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1faa6c>
 19c:	42018e02 	andmi	r8, r1, #2, 28
 1a0:	74040b0c 	strvc	r0, [r4], #-2828	; 0xfffff4f4
 1a4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 1a8:	00000018 	andeq	r0, r0, r8, lsl r0
 1ac:	00000178 	andeq	r0, r0, r8, ror r1
 1b0:	000082b8 			; <UNDEFINED> instruction: 0x000082b8
 1b4:	0000016c 	andeq	r0, r0, ip, ror #2
 1b8:	8b080e42 	blhi	203ac8 <__bss_end+0x1faa8c>
 1bc:	42018e02 	andmi	r8, r1, #2, 28
 1c0:	00040b0c 	andeq	r0, r4, ip, lsl #22
 1c4:	0000000c 	andeq	r0, r0, ip
 1c8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 1cc:	7c020001 	stcvc	0, cr0, [r2], {1}
 1d0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 1d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1d8:	000001c4 	andeq	r0, r0, r4, asr #3
 1dc:	00008424 	andeq	r8, r0, r4, lsr #8
 1e0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1e4:	8b040e42 	blhi	103af4 <__bss_end+0xfaab8>
 1e8:	0b0d4201 	bleq	3509f4 <__bss_end+0x3479b8>
 1ec:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1f8:	000001c4 	andeq	r0, r0, r4, asr #3
 1fc:	00008450 	andeq	r8, r0, r0, asr r4
 200:	0000002c 	andeq	r0, r0, ip, lsr #32
 204:	8b040e42 	blhi	103b14 <__bss_end+0xfaad8>
 208:	0b0d4201 	bleq	350a14 <__bss_end+0x3479d8>
 20c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 210:	00000ecb 	andeq	r0, r0, fp, asr #29
 214:	0000001c 	andeq	r0, r0, ip, lsl r0
 218:	000001c4 	andeq	r0, r0, r4, asr #3
 21c:	0000847c 	andeq	r8, r0, ip, ror r4
 220:	0000001c 	andeq	r0, r0, ip, lsl r0
 224:	8b040e42 	blhi	103b34 <__bss_end+0xfaaf8>
 228:	0b0d4201 	bleq	350a34 <__bss_end+0x3479f8>
 22c:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 230:	00000ecb 	andeq	r0, r0, fp, asr #29
 234:	0000001c 	andeq	r0, r0, ip, lsl r0
 238:	000001c4 	andeq	r0, r0, r4, asr #3
 23c:	00008498 	muleq	r0, r8, r4
 240:	00000044 	andeq	r0, r0, r4, asr #32
 244:	8b040e42 	blhi	103b54 <__bss_end+0xfab18>
 248:	0b0d4201 	bleq	350a54 <__bss_end+0x347a18>
 24c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 250:	00000ecb 	andeq	r0, r0, fp, asr #29
 254:	0000001c 	andeq	r0, r0, ip, lsl r0
 258:	000001c4 	andeq	r0, r0, r4, asr #3
 25c:	000084dc 	ldrdeq	r8, [r0], -ip
 260:	00000050 	andeq	r0, r0, r0, asr r0
 264:	8b040e42 	blhi	103b74 <__bss_end+0xfab38>
 268:	0b0d4201 	bleq	350a74 <__bss_end+0x347a38>
 26c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 270:	00000ecb 	andeq	r0, r0, fp, asr #29
 274:	0000001c 	andeq	r0, r0, ip, lsl r0
 278:	000001c4 	andeq	r0, r0, r4, asr #3
 27c:	0000852c 	andeq	r8, r0, ip, lsr #10
 280:	00000050 	andeq	r0, r0, r0, asr r0
 284:	8b040e42 	blhi	103b94 <__bss_end+0xfab58>
 288:	0b0d4201 	bleq	350a94 <__bss_end+0x347a58>
 28c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 290:	00000ecb 	andeq	r0, r0, fp, asr #29
 294:	0000001c 	andeq	r0, r0, ip, lsl r0
 298:	000001c4 	andeq	r0, r0, r4, asr #3
 29c:	0000857c 	andeq	r8, r0, ip, ror r5
 2a0:	0000002c 	andeq	r0, r0, ip, lsr #32
 2a4:	8b040e42 	blhi	103bb4 <__bss_end+0xfab78>
 2a8:	0b0d4201 	bleq	350ab4 <__bss_end+0x347a78>
 2ac:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 2b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2b8:	000001c4 	andeq	r0, r0, r4, asr #3
 2bc:	000085a8 	andeq	r8, r0, r8, lsr #11
 2c0:	00000050 	andeq	r0, r0, r0, asr r0
 2c4:	8b040e42 	blhi	103bd4 <__bss_end+0xfab98>
 2c8:	0b0d4201 	bleq	350ad4 <__bss_end+0x347a98>
 2cc:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2d8:	000001c4 	andeq	r0, r0, r4, asr #3
 2dc:	000085f8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 2e0:	00000044 	andeq	r0, r0, r4, asr #32
 2e4:	8b040e42 	blhi	103bf4 <__bss_end+0xfabb8>
 2e8:	0b0d4201 	bleq	350af4 <__bss_end+0x347ab8>
 2ec:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 2f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2f8:	000001c4 	andeq	r0, r0, r4, asr #3
 2fc:	0000863c 	andeq	r8, r0, ip, lsr r6
 300:	00000050 	andeq	r0, r0, r0, asr r0
 304:	8b040e42 	blhi	103c14 <__bss_end+0xfabd8>
 308:	0b0d4201 	bleq	350b14 <__bss_end+0x347ad8>
 30c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 310:	00000ecb 	andeq	r0, r0, fp, asr #29
 314:	0000001c 	andeq	r0, r0, ip, lsl r0
 318:	000001c4 	andeq	r0, r0, r4, asr #3
 31c:	0000868c 	andeq	r8, r0, ip, lsl #13
 320:	00000054 	andeq	r0, r0, r4, asr r0
 324:	8b040e42 	blhi	103c34 <__bss_end+0xfabf8>
 328:	0b0d4201 	bleq	350b34 <__bss_end+0x347af8>
 32c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 330:	00000ecb 	andeq	r0, r0, fp, asr #29
 334:	0000001c 	andeq	r0, r0, ip, lsl r0
 338:	000001c4 	andeq	r0, r0, r4, asr #3
 33c:	000086e0 	andeq	r8, r0, r0, ror #13
 340:	0000003c 	andeq	r0, r0, ip, lsr r0
 344:	8b040e42 	blhi	103c54 <__bss_end+0xfac18>
 348:	0b0d4201 	bleq	350b54 <__bss_end+0x347b18>
 34c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 350:	00000ecb 	andeq	r0, r0, fp, asr #29
 354:	0000001c 	andeq	r0, r0, ip, lsl r0
 358:	000001c4 	andeq	r0, r0, r4, asr #3
 35c:	0000871c 	andeq	r8, r0, ip, lsl r7
 360:	0000003c 	andeq	r0, r0, ip, lsr r0
 364:	8b040e42 	blhi	103c74 <__bss_end+0xfac38>
 368:	0b0d4201 	bleq	350b74 <__bss_end+0x347b38>
 36c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 370:	00000ecb 	andeq	r0, r0, fp, asr #29
 374:	0000001c 	andeq	r0, r0, ip, lsl r0
 378:	000001c4 	andeq	r0, r0, r4, asr #3
 37c:	00008758 	andeq	r8, r0, r8, asr r7
 380:	0000003c 	andeq	r0, r0, ip, lsr r0
 384:	8b040e42 	blhi	103c94 <__bss_end+0xfac58>
 388:	0b0d4201 	bleq	350b94 <__bss_end+0x347b58>
 38c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 390:	00000ecb 	andeq	r0, r0, fp, asr #29
 394:	0000001c 	andeq	r0, r0, ip, lsl r0
 398:	000001c4 	andeq	r0, r0, r4, asr #3
 39c:	00008794 	muleq	r0, r4, r7
 3a0:	0000003c 	andeq	r0, r0, ip, lsr r0
 3a4:	8b040e42 	blhi	103cb4 <__bss_end+0xfac78>
 3a8:	0b0d4201 	bleq	350bb4 <__bss_end+0x347b78>
 3ac:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 3b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 3b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3b8:	000001c4 	andeq	r0, r0, r4, asr #3
 3bc:	000087d0 	ldrdeq	r8, [r0], -r0
 3c0:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 3c4:	8b080e42 	blhi	203cd4 <__bss_end+0x1fac98>
 3c8:	42018e02 	andmi	r8, r1, #2, 28
 3cc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3d0:	080d0c50 	stmdaeq	sp, {r4, r6, sl, fp}
 3d4:	0000000c 	andeq	r0, r0, ip
 3d8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 3dc:	7c020001 	stcvc	0, cr0, [r2], {1}
 3e0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 3e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3e8:	000003d4 	ldrdeq	r0, [r0], -r4
 3ec:	00008880 	andeq	r8, r0, r0, lsl #17
 3f0:	00000174 	andeq	r0, r0, r4, ror r1
 3f4:	8b080e42 	blhi	203d04 <__bss_end+0x1facc8>
 3f8:	42018e02 	andmi	r8, r1, #2, 28
 3fc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 400:	080d0cb2 	stmdaeq	sp, {r1, r4, r5, r7, sl, fp}
 404:	0000001c 	andeq	r0, r0, ip, lsl r0
 408:	000003d4 	ldrdeq	r0, [r0], -r4
 40c:	000089f4 	strdeq	r8, [r0], -r4
 410:	0000009c 	muleq	r0, ip, r0
 414:	8b040e42 	blhi	103d24 <__bss_end+0xface8>
 418:	0b0d4201 	bleq	350c24 <__bss_end+0x347be8>
 41c:	0d0d4602 	stceq	6, cr4, [sp, #-8]
 420:	000ecb42 	andeq	ip, lr, r2, asr #22
 424:	0000001c 	andeq	r0, r0, ip, lsl r0
 428:	000003d4 	ldrdeq	r0, [r0], -r4
 42c:	00008a90 	muleq	r0, r0, sl
 430:	000000c0 	andeq	r0, r0, r0, asr #1
 434:	8b040e42 	blhi	103d44 <__bss_end+0xfad08>
 438:	0b0d4201 	bleq	350c44 <__bss_end+0x347c08>
 43c:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 440:	000ecb42 	andeq	ip, lr, r2, asr #22
 444:	0000001c 	andeq	r0, r0, ip, lsl r0
 448:	000003d4 	ldrdeq	r0, [r0], -r4
 44c:	00008b50 	andeq	r8, r0, r0, asr fp
 450:	000000ac 	andeq	r0, r0, ip, lsr #1
 454:	8b040e42 	blhi	103d64 <__bss_end+0xfad28>
 458:	0b0d4201 	bleq	350c64 <__bss_end+0x347c28>
 45c:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 460:	000ecb42 	andeq	ip, lr, r2, asr #22
 464:	0000001c 	andeq	r0, r0, ip, lsl r0
 468:	000003d4 	ldrdeq	r0, [r0], -r4
 46c:	00008bfc 	strdeq	r8, [r0], -ip
 470:	00000054 	andeq	r0, r0, r4, asr r0
 474:	8b040e42 	blhi	103d84 <__bss_end+0xfad48>
 478:	0b0d4201 	bleq	350c84 <__bss_end+0x347c48>
 47c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 480:	00000ecb 	andeq	r0, r0, fp, asr #29
 484:	0000001c 	andeq	r0, r0, ip, lsl r0
 488:	000003d4 	ldrdeq	r0, [r0], -r4
 48c:	00008c50 	andeq	r8, r0, r0, asr ip
 490:	00000068 	andeq	r0, r0, r8, rrx
 494:	8b040e42 	blhi	103da4 <__bss_end+0xfad68>
 498:	0b0d4201 	bleq	350ca4 <__bss_end+0x347c68>
 49c:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 4a0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4a8:	000003d4 	ldrdeq	r0, [r0], -r4
 4ac:	00008cb8 			; <UNDEFINED> instruction: 0x00008cb8
 4b0:	00000080 	andeq	r0, r0, r0, lsl #1
 4b4:	8b040e42 	blhi	103dc4 <__bss_end+0xfad88>
 4b8:	0b0d4201 	bleq	350cc4 <__bss_end+0x347c88>
 4bc:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 4c0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4c4:	0000000c 	andeq	r0, r0, ip
 4c8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 4cc:	7c010001 	stcvc	0, cr0, [r1], {1}
 4d0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 4d4:	0000000c 	andeq	r0, r0, ip
 4d8:	000004c4 	andeq	r0, r0, r4, asr #9
 4dc:	00008d38 	andeq	r8, r0, r8, lsr sp
 4e0:	000001ec 	andeq	r0, r0, ip, ror #3
