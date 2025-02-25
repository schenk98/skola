
./tilt_task:     file format elf32-littlearm


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
    8068:	00008f04 	andeq	r8, r0, r4, lsl #30
    806c:	00008f14 	andeq	r8, r0, r4, lsl pc

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
    808c:	eb000069 	bl	8238 <main>
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
    81d8:	00008f01 	andeq	r8, r0, r1, lsl #30
    81dc:	00008f01 	andeq	r8, r0, r1, lsl #30

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
    8230:	00008f01 	andeq	r8, r0, r1, lsl #30
    8234:	00008f01 	andeq	r8, r0, r1, lsl #30

00008238 <main>:
main():
/home/schenkj/os2022/sp/sources/userspace/tilt_task/main.cpp:15
 * 
 * Ceka na vstup ze senzoru naklonu, a prehraje neco na buzzeru (PWM) dle naklonu
 **/

int main(int argc, char** argv)
{
    8238:	e92d4800 	push	{fp, lr}
    823c:	e28db004 	add	fp, sp, #4
    8240:	e24dd020 	sub	sp, sp, #32
    8244:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
    8248:	e50b1024 	str	r1, [fp, #-36]	; 0xffffffdc
/home/schenkj/os2022/sp/sources/userspace/tilt_task/main.cpp:16
	char state = '0';
    824c:	e3a03030 	mov	r3, #48	; 0x30
    8250:	e54b3011 	strb	r3, [fp, #-17]	; 0xffffffef
/home/schenkj/os2022/sp/sources/userspace/tilt_task/main.cpp:17
	char oldstate = '0';
    8254:	e3a03030 	mov	r3, #48	; 0x30
    8258:	e54b3005 	strb	r3, [fp, #-5]
/home/schenkj/os2022/sp/sources/userspace/tilt_task/main.cpp:19

	uint32_t tiltsensor_file = open("DEV:gpio/23", NFile_Open_Mode::Read_Only);
    825c:	e3a01000 	mov	r1, #0
    8260:	e59f009c 	ldr	r0, [pc, #156]	; 8304 <main+0xcc>
    8264:	eb000047 	bl	8388 <_Z4openPKc15NFile_Open_Mode>
    8268:	e50b000c 	str	r0, [fp, #-12]
/home/schenkj/os2022/sp/sources/userspace/tilt_task/main.cpp:27
	NGPIO_Interrupt_Type irtype;
	
	//irtype = NGPIO_Interrupt_Type::Rising_Edge;
	//ioctl(tiltsensor_file, NIOCtl_Operation::Enable_Event_Detection, &irtype);

	irtype = NGPIO_Interrupt_Type::Falling_Edge;
    826c:	e3a03001 	mov	r3, #1
    8270:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/userspace/tilt_task/main.cpp:28
	ioctl(tiltsensor_file, NIOCtl_Operation::Enable_Event_Detection, &irtype);
    8274:	e24b3018 	sub	r3, fp, #24
    8278:	e1a02003 	mov	r2, r3
    827c:	e3a01002 	mov	r1, #2
    8280:	e51b000c 	ldr	r0, [fp, #-12]
    8284:	eb000083 	bl	8498 <_Z5ioctlj16NIOCtl_OperationPv>
/home/schenkj/os2022/sp/sources/userspace/tilt_task/main.cpp:30

	uint32_t logpipe = pipe("log", 32);
    8288:	e3a01020 	mov	r1, #32
    828c:	e59f0074 	ldr	r0, [pc, #116]	; 8308 <main+0xd0>
    8290:	eb00010a 	bl	86c0 <_Z4pipePKcj>
    8294:	e50b0010 	str	r0, [fp, #-16]
/home/schenkj/os2022/sp/sources/userspace/tilt_task/main.cpp:34

	while (true)
	{
		wait(tiltsensor_file, 0x800);
    8298:	e3e02001 	mvn	r2, #1
    829c:	e3a01b02 	mov	r1, #2048	; 0x800
    82a0:	e51b000c 	ldr	r0, [fp, #-12]
    82a4:	eb0000a0 	bl	852c <_Z4waitjjj>
/home/schenkj/os2022/sp/sources/userspace/tilt_task/main.cpp:39

		// "debounce" - tilt senzor bude chvili flappovat mezi vysokou a nizkou urovni
		//sleep(0x100, Deadline_Unchanged);

		read(tiltsensor_file, &state, 1);
    82a8:	e24b3011 	sub	r3, fp, #17
    82ac:	e3a02001 	mov	r2, #1
    82b0:	e1a01003 	mov	r1, r3
    82b4:	e51b000c 	ldr	r0, [fp, #-12]
    82b8:	eb000043 	bl	83cc <_Z4readjPcj>
/home/schenkj/os2022/sp/sources/userspace/tilt_task/main.cpp:43

		//if (state != oldstate)
		{
			if (state == '0')
    82bc:	e55b3011 	ldrb	r3, [fp, #-17]	; 0xffffffef
    82c0:	e3530030 	cmp	r3, #48	; 0x30
    82c4:	1a000004 	bne	82dc <main+0xa4>
/home/schenkj/os2022/sp/sources/userspace/tilt_task/main.cpp:45
			{
				write(logpipe, "Tilt UP", 7);
    82c8:	e3a02007 	mov	r2, #7
    82cc:	e59f1038 	ldr	r1, [pc, #56]	; 830c <main+0xd4>
    82d0:	e51b0010 	ldr	r0, [fp, #-16]
    82d4:	eb000050 	bl	841c <_Z5writejPKcj>
    82d8:	ea000003 	b	82ec <main+0xb4>
/home/schenkj/os2022/sp/sources/userspace/tilt_task/main.cpp:49
			}
			else
			{
				write(logpipe, "Tilt DOWN", 10);
    82dc:	e3a0200a 	mov	r2, #10
    82e0:	e59f1028 	ldr	r1, [pc, #40]	; 8310 <main+0xd8>
    82e4:	e51b0010 	ldr	r0, [fp, #-16]
    82e8:	eb00004b 	bl	841c <_Z5writejPKcj>
/home/schenkj/os2022/sp/sources/userspace/tilt_task/main.cpp:51
			}
			oldstate = state;
    82ec:	e55b3011 	ldrb	r3, [fp, #-17]	; 0xffffffef
    82f0:	e54b3005 	strb	r3, [fp, #-5]
/home/schenkj/os2022/sp/sources/userspace/tilt_task/main.cpp:54
		}

		sleep(0x1000, Indefinite/*0x100*/);
    82f4:	e3e01000 	mvn	r1, #0
    82f8:	e3a00a01 	mov	r0, #4096	; 0x1000
    82fc:	eb00009e 	bl	857c <_Z5sleepjj>
/home/schenkj/os2022/sp/sources/userspace/tilt_task/main.cpp:34
		wait(tiltsensor_file, 0x800);
    8300:	eaffffe4 	b	8298 <main+0x60>
    8304:	00008e94 	muleq	r0, r4, lr
    8308:	00008ea0 	andeq	r8, r0, r0, lsr #29
    830c:	00008ea4 	andeq	r8, r0, r4, lsr #29
    8310:	00008eac 	andeq	r8, r0, ip, lsr #29

00008314 <_Z6getpidv>:
_Z6getpidv():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:5
#include <stdfile.h>
#include <stdstring.h>

uint32_t getpid()
{
    8314:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8318:	e28db000 	add	fp, sp, #0
    831c:	e24dd00c 	sub	sp, sp, #12
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:8
    uint32_t pid;

    asm volatile("swi 0");
    8320:	ef000000 	svc	0x00000000
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:9
    asm volatile("mov %0, r0" : "=r" (pid));
    8324:	e1a03000 	mov	r3, r0
    8328:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:11

    return pid;
    832c:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:12
}
    8330:	e1a00003 	mov	r0, r3
    8334:	e28bd000 	add	sp, fp, #0
    8338:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    833c:	e12fff1e 	bx	lr

00008340 <_Z9terminatei>:
_Z9terminatei():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:15

void terminate(int exitcode)
{
    8340:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8344:	e28db000 	add	fp, sp, #0
    8348:	e24dd00c 	sub	sp, sp, #12
    834c:	e50b0008 	str	r0, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:16
    asm volatile("mov r0, %0" : : "r" (exitcode));
    8350:	e51b3008 	ldr	r3, [fp, #-8]
    8354:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:17
    asm volatile("swi 1");
    8358:	ef000001 	svc	0x00000001
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:18
}
    835c:	e320f000 	nop	{0}
    8360:	e28bd000 	add	sp, fp, #0
    8364:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8368:	e12fff1e 	bx	lr

0000836c <_Z11sched_yieldv>:
_Z11sched_yieldv():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:21

void sched_yield()
{
    836c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8370:	e28db000 	add	fp, sp, #0
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:22
    asm volatile("swi 2");
    8374:	ef000002 	svc	0x00000002
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:23
}
    8378:	e320f000 	nop	{0}
    837c:	e28bd000 	add	sp, fp, #0
    8380:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8384:	e12fff1e 	bx	lr

00008388 <_Z4openPKc15NFile_Open_Mode>:
_Z4openPKc15NFile_Open_Mode():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:26

uint32_t open(const char* filename, NFile_Open_Mode mode)
{
    8388:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    838c:	e28db000 	add	fp, sp, #0
    8390:	e24dd014 	sub	sp, sp, #20
    8394:	e50b0010 	str	r0, [fp, #-16]
    8398:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:29
    uint32_t file;

    asm volatile("mov r0, %0" : : "r" (filename));
    839c:	e51b3010 	ldr	r3, [fp, #-16]
    83a0:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:30
    asm volatile("mov r1, %0" : : "r" (mode));
    83a4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    83a8:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:31
    asm volatile("swi 64");
    83ac:	ef000040 	svc	0x00000040
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:32
    asm volatile("mov %0, r0" : "=r" (file));
    83b0:	e1a03000 	mov	r3, r0
    83b4:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:34

    return file;
    83b8:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:35
}
    83bc:	e1a00003 	mov	r0, r3
    83c0:	e28bd000 	add	sp, fp, #0
    83c4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83c8:	e12fff1e 	bx	lr

000083cc <_Z4readjPcj>:
_Z4readjPcj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:38

uint32_t read(uint32_t file, char* const buffer, uint32_t size)
{
    83cc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83d0:	e28db000 	add	fp, sp, #0
    83d4:	e24dd01c 	sub	sp, sp, #28
    83d8:	e50b0010 	str	r0, [fp, #-16]
    83dc:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    83e0:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:41
    uint32_t rdnum;

    asm volatile("mov r0, %0" : : "r" (file));
    83e4:	e51b3010 	ldr	r3, [fp, #-16]
    83e8:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:42
    asm volatile("mov r1, %0" : : "r" (buffer));
    83ec:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    83f0:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:43
    asm volatile("mov r2, %0" : : "r" (size));
    83f4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    83f8:	e1a02003 	mov	r2, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:44
    asm volatile("swi 65");
    83fc:	ef000041 	svc	0x00000041
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:45
    asm volatile("mov %0, r0" : "=r" (rdnum));
    8400:	e1a03000 	mov	r3, r0
    8404:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:47

    return rdnum;
    8408:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:48
}
    840c:	e1a00003 	mov	r0, r3
    8410:	e28bd000 	add	sp, fp, #0
    8414:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8418:	e12fff1e 	bx	lr

0000841c <_Z5writejPKcj>:
_Z5writejPKcj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:51

uint32_t write(uint32_t file, const char* buffer, uint32_t size)
{
    841c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8420:	e28db000 	add	fp, sp, #0
    8424:	e24dd01c 	sub	sp, sp, #28
    8428:	e50b0010 	str	r0, [fp, #-16]
    842c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8430:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:54
    uint32_t wrnum;

    asm volatile("mov r0, %0" : : "r" (file));
    8434:	e51b3010 	ldr	r3, [fp, #-16]
    8438:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:55
    asm volatile("mov r1, %0" : : "r" (buffer));
    843c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8440:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:56
    asm volatile("mov r2, %0" : : "r" (size));
    8444:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8448:	e1a02003 	mov	r2, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:57
    asm volatile("swi 66");
    844c:	ef000042 	svc	0x00000042
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:58
    asm volatile("mov %0, r0" : "=r" (wrnum));
    8450:	e1a03000 	mov	r3, r0
    8454:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:60

    return wrnum;
    8458:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:61
}
    845c:	e1a00003 	mov	r0, r3
    8460:	e28bd000 	add	sp, fp, #0
    8464:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8468:	e12fff1e 	bx	lr

0000846c <_Z5closej>:
_Z5closej():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:64

void close(uint32_t file)
{
    846c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8470:	e28db000 	add	fp, sp, #0
    8474:	e24dd00c 	sub	sp, sp, #12
    8478:	e50b0008 	str	r0, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:65
    asm volatile("mov r0, %0" : : "r" (file));
    847c:	e51b3008 	ldr	r3, [fp, #-8]
    8480:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:66
    asm volatile("swi 67");
    8484:	ef000043 	svc	0x00000043
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:67
}
    8488:	e320f000 	nop	{0}
    848c:	e28bd000 	add	sp, fp, #0
    8490:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8494:	e12fff1e 	bx	lr

00008498 <_Z5ioctlj16NIOCtl_OperationPv>:
_Z5ioctlj16NIOCtl_OperationPv():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:70

uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param)
{
    8498:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    849c:	e28db000 	add	fp, sp, #0
    84a0:	e24dd01c 	sub	sp, sp, #28
    84a4:	e50b0010 	str	r0, [fp, #-16]
    84a8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    84ac:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:73
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    84b0:	e51b3010 	ldr	r3, [fp, #-16]
    84b4:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:74
    asm volatile("mov r1, %0" : : "r" (operation));
    84b8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84bc:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:75
    asm volatile("mov r2, %0" : : "r" (param));
    84c0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    84c4:	e1a02003 	mov	r2, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:76
    asm volatile("swi 68");
    84c8:	ef000044 	svc	0x00000044
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:77
    asm volatile("mov %0, r0" : "=r" (retcode));
    84cc:	e1a03000 	mov	r3, r0
    84d0:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:79

    return retcode;
    84d4:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:80
}
    84d8:	e1a00003 	mov	r0, r3
    84dc:	e28bd000 	add	sp, fp, #0
    84e0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    84e4:	e12fff1e 	bx	lr

000084e8 <_Z6notifyjj>:
_Z6notifyjj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:83

uint32_t notify(uint32_t file, uint32_t count)
{
    84e8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    84ec:	e28db000 	add	fp, sp, #0
    84f0:	e24dd014 	sub	sp, sp, #20
    84f4:	e50b0010 	str	r0, [fp, #-16]
    84f8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:86
    uint32_t retcnt;

    asm volatile("mov r0, %0" : : "r" (file));
    84fc:	e51b3010 	ldr	r3, [fp, #-16]
    8500:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:87
    asm volatile("mov r1, %0" : : "r" (count));
    8504:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8508:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:88
    asm volatile("swi 69");
    850c:	ef000045 	svc	0x00000045
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:89
    asm volatile("mov %0, r0" : "=r" (retcnt));
    8510:	e1a03000 	mov	r3, r0
    8514:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:91

    return retcnt;
    8518:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:92
}
    851c:	e1a00003 	mov	r0, r3
    8520:	e28bd000 	add	sp, fp, #0
    8524:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8528:	e12fff1e 	bx	lr

0000852c <_Z4waitjjj>:
_Z4waitjjj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:95

NSWI_Result_Code wait(uint32_t file, uint32_t count, uint32_t notified_deadline)
{
    852c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8530:	e28db000 	add	fp, sp, #0
    8534:	e24dd01c 	sub	sp, sp, #28
    8538:	e50b0010 	str	r0, [fp, #-16]
    853c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8540:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:98
    NSWI_Result_Code retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    8544:	e51b3010 	ldr	r3, [fp, #-16]
    8548:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:99
    asm volatile("mov r1, %0" : : "r" (count));
    854c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8550:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:100
    asm volatile("mov r2, %0" : : "r" (notified_deadline));
    8554:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8558:	e1a02003 	mov	r2, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:101
    asm volatile("swi 70");
    855c:	ef000046 	svc	0x00000046
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:102
    asm volatile("mov %0, r0" : "=r" (retcode));
    8560:	e1a03000 	mov	r3, r0
    8564:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:104

    return retcode;
    8568:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:105
}
    856c:	e1a00003 	mov	r0, r3
    8570:	e28bd000 	add	sp, fp, #0
    8574:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8578:	e12fff1e 	bx	lr

0000857c <_Z5sleepjj>:
_Z5sleepjj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:108

bool sleep(uint32_t ticks, uint32_t notified_deadline)
{
    857c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8580:	e28db000 	add	fp, sp, #0
    8584:	e24dd014 	sub	sp, sp, #20
    8588:	e50b0010 	str	r0, [fp, #-16]
    858c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:111
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (ticks));
    8590:	e51b3010 	ldr	r3, [fp, #-16]
    8594:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:112
    asm volatile("mov r1, %0" : : "r" (notified_deadline));
    8598:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    859c:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:113
    asm volatile("swi 3");
    85a0:	ef000003 	svc	0x00000003
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:114
    asm volatile("mov %0, r0" : "=r" (retcode));
    85a4:	e1a03000 	mov	r3, r0
    85a8:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:116

    return retcode;
    85ac:	e51b3008 	ldr	r3, [fp, #-8]
    85b0:	e3530000 	cmp	r3, #0
    85b4:	13a03001 	movne	r3, #1
    85b8:	03a03000 	moveq	r3, #0
    85bc:	e6ef3073 	uxtb	r3, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:117
}
    85c0:	e1a00003 	mov	r0, r3
    85c4:	e28bd000 	add	sp, fp, #0
    85c8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85cc:	e12fff1e 	bx	lr

000085d0 <_Z24get_active_process_countv>:
_Z24get_active_process_countv():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:120

uint32_t get_active_process_count()
{
    85d0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85d4:	e28db000 	add	fp, sp, #0
    85d8:	e24dd00c 	sub	sp, sp, #12
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:121
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Active_Process_Count;
    85dc:	e3a03000 	mov	r3, #0
    85e0:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:124
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    85e4:	e3a03000 	mov	r3, #0
    85e8:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:125
    asm volatile("mov r1, %0" : : "r" (&retval));
    85ec:	e24b300c 	sub	r3, fp, #12
    85f0:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:126
    asm volatile("swi 4");
    85f4:	ef000004 	svc	0x00000004
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:128

    return retval;
    85f8:	e51b300c 	ldr	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:129
}
    85fc:	e1a00003 	mov	r0, r3
    8600:	e28bd000 	add	sp, fp, #0
    8604:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8608:	e12fff1e 	bx	lr

0000860c <_Z14get_tick_countv>:
_Z14get_tick_countv():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:132

uint32_t get_tick_count()
{
    860c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8610:	e28db000 	add	fp, sp, #0
    8614:	e24dd00c 	sub	sp, sp, #12
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:133
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Tick_Count;
    8618:	e3a03001 	mov	r3, #1
    861c:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:136
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    8620:	e3a03001 	mov	r3, #1
    8624:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:137
    asm volatile("mov r1, %0" : : "r" (&retval));
    8628:	e24b300c 	sub	r3, fp, #12
    862c:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:138
    asm volatile("swi 4");
    8630:	ef000004 	svc	0x00000004
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:140

    return retval;
    8634:	e51b300c 	ldr	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:141
}
    8638:	e1a00003 	mov	r0, r3
    863c:	e28bd000 	add	sp, fp, #0
    8640:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8644:	e12fff1e 	bx	lr

00008648 <_Z17set_task_deadlinej>:
_Z17set_task_deadlinej():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:144

void set_task_deadline(uint32_t tick_count_required)
{
    8648:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    864c:	e28db000 	add	fp, sp, #0
    8650:	e24dd014 	sub	sp, sp, #20
    8654:	e50b0010 	str	r0, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:145
    const NDeadline_Subservice req = NDeadline_Subservice::Set_Relative;
    8658:	e3a03000 	mov	r3, #0
    865c:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:147

    asm volatile("mov r0, %0" : : "r" (req));
    8660:	e3a03000 	mov	r3, #0
    8664:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:148
    asm volatile("mov r1, %0" : : "r" (&tick_count_required));
    8668:	e24b3010 	sub	r3, fp, #16
    866c:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:149
    asm volatile("swi 5");
    8670:	ef000005 	svc	0x00000005
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:150
}
    8674:	e320f000 	nop	{0}
    8678:	e28bd000 	add	sp, fp, #0
    867c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8680:	e12fff1e 	bx	lr

00008684 <_Z26get_task_ticks_to_deadlinev>:
_Z26get_task_ticks_to_deadlinev():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:153

uint32_t get_task_ticks_to_deadline()
{
    8684:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8688:	e28db000 	add	fp, sp, #0
    868c:	e24dd00c 	sub	sp, sp, #12
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:154
    const NDeadline_Subservice req = NDeadline_Subservice::Get_Remaining;
    8690:	e3a03001 	mov	r3, #1
    8694:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:157
    uint32_t ticks;

    asm volatile("mov r0, %0" : : "r" (req));
    8698:	e3a03001 	mov	r3, #1
    869c:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:158
    asm volatile("mov r1, %0" : : "r" (&ticks));
    86a0:	e24b300c 	sub	r3, fp, #12
    86a4:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:159
    asm volatile("swi 5");
    86a8:	ef000005 	svc	0x00000005
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:161

    return ticks;
    86ac:	e51b300c 	ldr	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:162
}
    86b0:	e1a00003 	mov	r0, r3
    86b4:	e28bd000 	add	sp, fp, #0
    86b8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86bc:	e12fff1e 	bx	lr

000086c0 <_Z4pipePKcj>:
_Z4pipePKcj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:167

const char Pipe_File_Prefix[] = "SYS:pipe/";

uint32_t pipe(const char* name, uint32_t buf_size)
{
    86c0:	e92d4800 	push	{fp, lr}
    86c4:	e28db004 	add	fp, sp, #4
    86c8:	e24dd050 	sub	sp, sp, #80	; 0x50
    86cc:	e50b0050 	str	r0, [fp, #-80]	; 0xffffffb0
    86d0:	e50b1054 	str	r1, [fp, #-84]	; 0xffffffac
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:169
    char fname[64];
    strncpy(fname, Pipe_File_Prefix, sizeof(Pipe_File_Prefix));
    86d4:	e24b3048 	sub	r3, fp, #72	; 0x48
    86d8:	e3a0200a 	mov	r2, #10
    86dc:	e59f1088 	ldr	r1, [pc, #136]	; 876c <_Z4pipePKcj+0xac>
    86e0:	e1a00003 	mov	r0, r3
    86e4:	eb0000a5 	bl	8980 <_Z7strncpyPcPKci>
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:170
    strncpy(fname + sizeof(Pipe_File_Prefix), name, sizeof(fname) - sizeof(Pipe_File_Prefix) - 1);
    86e8:	e24b3048 	sub	r3, fp, #72	; 0x48
    86ec:	e283300a 	add	r3, r3, #10
    86f0:	e3a02035 	mov	r2, #53	; 0x35
    86f4:	e51b1050 	ldr	r1, [fp, #-80]	; 0xffffffb0
    86f8:	e1a00003 	mov	r0, r3
    86fc:	eb00009f 	bl	8980 <_Z7strncpyPcPKci>
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:172

    int ncur = sizeof(Pipe_File_Prefix) + strlen(name);
    8700:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    8704:	eb0000f8 	bl	8aec <_Z6strlenPKc>
    8708:	e1a03000 	mov	r3, r0
    870c:	e283300a 	add	r3, r3, #10
    8710:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:174

    fname[ncur++] = '#';
    8714:	e51b3008 	ldr	r3, [fp, #-8]
    8718:	e2832001 	add	r2, r3, #1
    871c:	e50b2008 	str	r2, [fp, #-8]
    8720:	e24b2004 	sub	r2, fp, #4
    8724:	e0823003 	add	r3, r2, r3
    8728:	e3a02023 	mov	r2, #35	; 0x23
    872c:	e5432044 	strb	r2, [r3, #-68]	; 0xffffffbc
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:176

    itoa(buf_size, &fname[ncur], 10);
    8730:	e24b2048 	sub	r2, fp, #72	; 0x48
    8734:	e51b3008 	ldr	r3, [fp, #-8]
    8738:	e0823003 	add	r3, r2, r3
    873c:	e3a0200a 	mov	r2, #10
    8740:	e1a01003 	mov	r1, r3
    8744:	e51b0054 	ldr	r0, [fp, #-84]	; 0xffffffac
    8748:	eb000008 	bl	8770 <_Z4itoajPcj>
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:178

    return open(fname, NFile_Open_Mode::Read_Write);
    874c:	e24b3048 	sub	r3, fp, #72	; 0x48
    8750:	e3a01002 	mov	r1, #2
    8754:	e1a00003 	mov	r0, r3
    8758:	ebffff0a 	bl	8388 <_Z4openPKc15NFile_Open_Mode>
    875c:	e1a03000 	mov	r3, r0
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:179
}
    8760:	e1a00003 	mov	r0, r3
    8764:	e24bd004 	sub	sp, fp, #4
    8768:	e8bd8800 	pop	{fp, pc}
    876c:	00008ee4 	andeq	r8, r0, r4, ror #29

00008770 <_Z4itoajPcj>:
_Z4itoajPcj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:9
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(unsigned int input, char* output, unsigned int base)
{
    8770:	e92d4800 	push	{fp, lr}
    8774:	e28db004 	add	fp, sp, #4
    8778:	e24dd020 	sub	sp, sp, #32
    877c:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8780:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8784:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:10
	int i = 0;
    8788:	e3a03000 	mov	r3, #0
    878c:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:12

	while (input > 0)
    8790:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8794:	e3530000 	cmp	r3, #0
    8798:	0a000014 	beq	87f0 <_Z4itoajPcj+0x80>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:14
	{
		output[i] = CharConvArr[input % base];
    879c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    87a0:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    87a4:	e1a00003 	mov	r0, r3
    87a8:	eb000199 	bl	8e14 <__aeabi_uidivmod>
    87ac:	e1a03001 	mov	r3, r1
    87b0:	e1a01003 	mov	r1, r3
    87b4:	e51b3008 	ldr	r3, [fp, #-8]
    87b8:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    87bc:	e0823003 	add	r3, r2, r3
    87c0:	e59f2118 	ldr	r2, [pc, #280]	; 88e0 <_Z4itoajPcj+0x170>
    87c4:	e7d22001 	ldrb	r2, [r2, r1]
    87c8:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:15
		input /= base;
    87cc:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    87d0:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    87d4:	eb000113 	bl	8c28 <__udivsi3>
    87d8:	e1a03000 	mov	r3, r0
    87dc:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:16
		i++;
    87e0:	e51b3008 	ldr	r3, [fp, #-8]
    87e4:	e2833001 	add	r3, r3, #1
    87e8:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:12
	while (input > 0)
    87ec:	eaffffe7 	b	8790 <_Z4itoajPcj+0x20>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:19
	}

    if (i == 0)
    87f0:	e51b3008 	ldr	r3, [fp, #-8]
    87f4:	e3530000 	cmp	r3, #0
    87f8:	1a000007 	bne	881c <_Z4itoajPcj+0xac>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:21
    {
        output[i] = CharConvArr[0];
    87fc:	e51b3008 	ldr	r3, [fp, #-8]
    8800:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8804:	e0823003 	add	r3, r2, r3
    8808:	e3a02030 	mov	r2, #48	; 0x30
    880c:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:22
        i++;
    8810:	e51b3008 	ldr	r3, [fp, #-8]
    8814:	e2833001 	add	r3, r3, #1
    8818:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:25
    }

	output[i] = '\0';
    881c:	e51b3008 	ldr	r3, [fp, #-8]
    8820:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8824:	e0823003 	add	r3, r2, r3
    8828:	e3a02000 	mov	r2, #0
    882c:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:26
	i--;
    8830:	e51b3008 	ldr	r3, [fp, #-8]
    8834:	e2433001 	sub	r3, r3, #1
    8838:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:28

	for (int j = 0; j <= i/2; j++)
    883c:	e3a03000 	mov	r3, #0
    8840:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:28 (discriminator 3)
    8844:	e51b3008 	ldr	r3, [fp, #-8]
    8848:	e1a02fa3 	lsr	r2, r3, #31
    884c:	e0823003 	add	r3, r2, r3
    8850:	e1a030c3 	asr	r3, r3, #1
    8854:	e1a02003 	mov	r2, r3
    8858:	e51b300c 	ldr	r3, [fp, #-12]
    885c:	e1530002 	cmp	r3, r2
    8860:	ca00001b 	bgt	88d4 <_Z4itoajPcj+0x164>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:30 (discriminator 2)
	{
		char c = output[i - j];
    8864:	e51b2008 	ldr	r2, [fp, #-8]
    8868:	e51b300c 	ldr	r3, [fp, #-12]
    886c:	e0423003 	sub	r3, r2, r3
    8870:	e1a02003 	mov	r2, r3
    8874:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8878:	e0833002 	add	r3, r3, r2
    887c:	e5d33000 	ldrb	r3, [r3]
    8880:	e54b300d 	strb	r3, [fp, #-13]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:31 (discriminator 2)
		output[i - j] = output[j];
    8884:	e51b300c 	ldr	r3, [fp, #-12]
    8888:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    888c:	e0822003 	add	r2, r2, r3
    8890:	e51b1008 	ldr	r1, [fp, #-8]
    8894:	e51b300c 	ldr	r3, [fp, #-12]
    8898:	e0413003 	sub	r3, r1, r3
    889c:	e1a01003 	mov	r1, r3
    88a0:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    88a4:	e0833001 	add	r3, r3, r1
    88a8:	e5d22000 	ldrb	r2, [r2]
    88ac:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:32 (discriminator 2)
		output[j] = c;
    88b0:	e51b300c 	ldr	r3, [fp, #-12]
    88b4:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    88b8:	e0823003 	add	r3, r2, r3
    88bc:	e55b200d 	ldrb	r2, [fp, #-13]
    88c0:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:28 (discriminator 2)
	for (int j = 0; j <= i/2; j++)
    88c4:	e51b300c 	ldr	r3, [fp, #-12]
    88c8:	e2833001 	add	r3, r3, #1
    88cc:	e50b300c 	str	r3, [fp, #-12]
    88d0:	eaffffdb 	b	8844 <_Z4itoajPcj+0xd4>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:34
	}
}
    88d4:	e320f000 	nop	{0}
    88d8:	e24bd004 	sub	sp, fp, #4
    88dc:	e8bd8800 	pop	{fp, pc}
    88e0:	00008ef0 	strdeq	r8, [r0], -r0

000088e4 <_Z4atoiPKc>:
_Z4atoiPKc():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:37

int atoi(const char* input)
{
    88e4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    88e8:	e28db000 	add	fp, sp, #0
    88ec:	e24dd014 	sub	sp, sp, #20
    88f0:	e50b0010 	str	r0, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:38
	int output = 0;
    88f4:	e3a03000 	mov	r3, #0
    88f8:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:40

	while (*input != '\0')
    88fc:	e51b3010 	ldr	r3, [fp, #-16]
    8900:	e5d33000 	ldrb	r3, [r3]
    8904:	e3530000 	cmp	r3, #0
    8908:	0a000017 	beq	896c <_Z4atoiPKc+0x88>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:42
	{
		output *= 10;
    890c:	e51b2008 	ldr	r2, [fp, #-8]
    8910:	e1a03002 	mov	r3, r2
    8914:	e1a03103 	lsl	r3, r3, #2
    8918:	e0833002 	add	r3, r3, r2
    891c:	e1a03083 	lsl	r3, r3, #1
    8920:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:43
		if (*input > '9' || *input < '0')
    8924:	e51b3010 	ldr	r3, [fp, #-16]
    8928:	e5d33000 	ldrb	r3, [r3]
    892c:	e3530039 	cmp	r3, #57	; 0x39
    8930:	8a00000d 	bhi	896c <_Z4atoiPKc+0x88>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:43 (discriminator 1)
    8934:	e51b3010 	ldr	r3, [fp, #-16]
    8938:	e5d33000 	ldrb	r3, [r3]
    893c:	e353002f 	cmp	r3, #47	; 0x2f
    8940:	9a000009 	bls	896c <_Z4atoiPKc+0x88>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:46
			break;

		output += *input - '0';
    8944:	e51b3010 	ldr	r3, [fp, #-16]
    8948:	e5d33000 	ldrb	r3, [r3]
    894c:	e2433030 	sub	r3, r3, #48	; 0x30
    8950:	e51b2008 	ldr	r2, [fp, #-8]
    8954:	e0823003 	add	r3, r2, r3
    8958:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:48

		input++;
    895c:	e51b3010 	ldr	r3, [fp, #-16]
    8960:	e2833001 	add	r3, r3, #1
    8964:	e50b3010 	str	r3, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:40
	while (*input != '\0')
    8968:	eaffffe3 	b	88fc <_Z4atoiPKc+0x18>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:51
	}

	return output;
    896c:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:52
}
    8970:	e1a00003 	mov	r0, r3
    8974:	e28bd000 	add	sp, fp, #0
    8978:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    897c:	e12fff1e 	bx	lr

00008980 <_Z7strncpyPcPKci>:
_Z7strncpyPcPKci():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:55

char* strncpy(char* dest, const char *src, int num)
{
    8980:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8984:	e28db000 	add	fp, sp, #0
    8988:	e24dd01c 	sub	sp, sp, #28
    898c:	e50b0010 	str	r0, [fp, #-16]
    8990:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8994:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:58
	int i;

	for (i = 0; i < num && src[i] != '\0'; i++)
    8998:	e3a03000 	mov	r3, #0
    899c:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:58 (discriminator 4)
    89a0:	e51b2008 	ldr	r2, [fp, #-8]
    89a4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    89a8:	e1520003 	cmp	r2, r3
    89ac:	aa000011 	bge	89f8 <_Z7strncpyPcPKci+0x78>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:58 (discriminator 2)
    89b0:	e51b3008 	ldr	r3, [fp, #-8]
    89b4:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    89b8:	e0823003 	add	r3, r2, r3
    89bc:	e5d33000 	ldrb	r3, [r3]
    89c0:	e3530000 	cmp	r3, #0
    89c4:	0a00000b 	beq	89f8 <_Z7strncpyPcPKci+0x78>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:59 (discriminator 3)
		dest[i] = src[i];
    89c8:	e51b3008 	ldr	r3, [fp, #-8]
    89cc:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    89d0:	e0822003 	add	r2, r2, r3
    89d4:	e51b3008 	ldr	r3, [fp, #-8]
    89d8:	e51b1010 	ldr	r1, [fp, #-16]
    89dc:	e0813003 	add	r3, r1, r3
    89e0:	e5d22000 	ldrb	r2, [r2]
    89e4:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:58 (discriminator 3)
	for (i = 0; i < num && src[i] != '\0'; i++)
    89e8:	e51b3008 	ldr	r3, [fp, #-8]
    89ec:	e2833001 	add	r3, r3, #1
    89f0:	e50b3008 	str	r3, [fp, #-8]
    89f4:	eaffffe9 	b	89a0 <_Z7strncpyPcPKci+0x20>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:60 (discriminator 2)
	for (; i < num; i++)
    89f8:	e51b2008 	ldr	r2, [fp, #-8]
    89fc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8a00:	e1520003 	cmp	r2, r3
    8a04:	aa000008 	bge	8a2c <_Z7strncpyPcPKci+0xac>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:61 (discriminator 1)
		dest[i] = '\0';
    8a08:	e51b3008 	ldr	r3, [fp, #-8]
    8a0c:	e51b2010 	ldr	r2, [fp, #-16]
    8a10:	e0823003 	add	r3, r2, r3
    8a14:	e3a02000 	mov	r2, #0
    8a18:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:60 (discriminator 1)
	for (; i < num; i++)
    8a1c:	e51b3008 	ldr	r3, [fp, #-8]
    8a20:	e2833001 	add	r3, r3, #1
    8a24:	e50b3008 	str	r3, [fp, #-8]
    8a28:	eafffff2 	b	89f8 <_Z7strncpyPcPKci+0x78>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:63

   return dest;
    8a2c:	e51b3010 	ldr	r3, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:64
}
    8a30:	e1a00003 	mov	r0, r3
    8a34:	e28bd000 	add	sp, fp, #0
    8a38:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8a3c:	e12fff1e 	bx	lr

00008a40 <_Z7strncmpPKcS0_i>:
_Z7strncmpPKcS0_i():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:67

int strncmp(const char *s1, const char *s2, int num)
{
    8a40:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8a44:	e28db000 	add	fp, sp, #0
    8a48:	e24dd01c 	sub	sp, sp, #28
    8a4c:	e50b0010 	str	r0, [fp, #-16]
    8a50:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8a54:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:69
	unsigned char u1, u2;
  	while (num-- > 0)
    8a58:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8a5c:	e2432001 	sub	r2, r3, #1
    8a60:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    8a64:	e3530000 	cmp	r3, #0
    8a68:	c3a03001 	movgt	r3, #1
    8a6c:	d3a03000 	movle	r3, #0
    8a70:	e6ef3073 	uxtb	r3, r3
    8a74:	e3530000 	cmp	r3, #0
    8a78:	0a000016 	beq	8ad8 <_Z7strncmpPKcS0_i+0x98>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:71
    {
      	u1 = (unsigned char) *s1++;
    8a7c:	e51b3010 	ldr	r3, [fp, #-16]
    8a80:	e2832001 	add	r2, r3, #1
    8a84:	e50b2010 	str	r2, [fp, #-16]
    8a88:	e5d33000 	ldrb	r3, [r3]
    8a8c:	e54b3005 	strb	r3, [fp, #-5]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:72
     	u2 = (unsigned char) *s2++;
    8a90:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8a94:	e2832001 	add	r2, r3, #1
    8a98:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    8a9c:	e5d33000 	ldrb	r3, [r3]
    8aa0:	e54b3006 	strb	r3, [fp, #-6]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:73
      	if (u1 != u2)
    8aa4:	e55b2005 	ldrb	r2, [fp, #-5]
    8aa8:	e55b3006 	ldrb	r3, [fp, #-6]
    8aac:	e1520003 	cmp	r2, r3
    8ab0:	0a000003 	beq	8ac4 <_Z7strncmpPKcS0_i+0x84>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:74
        	return u1 - u2;
    8ab4:	e55b2005 	ldrb	r2, [fp, #-5]
    8ab8:	e55b3006 	ldrb	r3, [fp, #-6]
    8abc:	e0423003 	sub	r3, r2, r3
    8ac0:	ea000005 	b	8adc <_Z7strncmpPKcS0_i+0x9c>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:75
      	if (u1 == '\0')
    8ac4:	e55b3005 	ldrb	r3, [fp, #-5]
    8ac8:	e3530000 	cmp	r3, #0
    8acc:	1affffe1 	bne	8a58 <_Z7strncmpPKcS0_i+0x18>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:76
        	return 0;
    8ad0:	e3a03000 	mov	r3, #0
    8ad4:	ea000000 	b	8adc <_Z7strncmpPKcS0_i+0x9c>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:79
    }

  	return 0;
    8ad8:	e3a03000 	mov	r3, #0
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:80
}
    8adc:	e1a00003 	mov	r0, r3
    8ae0:	e28bd000 	add	sp, fp, #0
    8ae4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8ae8:	e12fff1e 	bx	lr

00008aec <_Z6strlenPKc>:
_Z6strlenPKc():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:83

int strlen(const char* s)
{
    8aec:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8af0:	e28db000 	add	fp, sp, #0
    8af4:	e24dd014 	sub	sp, sp, #20
    8af8:	e50b0010 	str	r0, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:84
	int i = 0;
    8afc:	e3a03000 	mov	r3, #0
    8b00:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:86

	while (s[i] != '\0')
    8b04:	e51b3008 	ldr	r3, [fp, #-8]
    8b08:	e51b2010 	ldr	r2, [fp, #-16]
    8b0c:	e0823003 	add	r3, r2, r3
    8b10:	e5d33000 	ldrb	r3, [r3]
    8b14:	e3530000 	cmp	r3, #0
    8b18:	0a000003 	beq	8b2c <_Z6strlenPKc+0x40>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:87
		i++;
    8b1c:	e51b3008 	ldr	r3, [fp, #-8]
    8b20:	e2833001 	add	r3, r3, #1
    8b24:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:86
	while (s[i] != '\0')
    8b28:	eafffff5 	b	8b04 <_Z6strlenPKc+0x18>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:89

	return i;
    8b2c:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:90
}
    8b30:	e1a00003 	mov	r0, r3
    8b34:	e28bd000 	add	sp, fp, #0
    8b38:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8b3c:	e12fff1e 	bx	lr

00008b40 <_Z5bzeroPvi>:
_Z5bzeroPvi():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:93

void bzero(void* memory, int length)
{
    8b40:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8b44:	e28db000 	add	fp, sp, #0
    8b48:	e24dd014 	sub	sp, sp, #20
    8b4c:	e50b0010 	str	r0, [fp, #-16]
    8b50:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:94
	char* mem = reinterpret_cast<char*>(memory);
    8b54:	e51b3010 	ldr	r3, [fp, #-16]
    8b58:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:96

	for (int i = 0; i < length; i++)
    8b5c:	e3a03000 	mov	r3, #0
    8b60:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:96 (discriminator 3)
    8b64:	e51b2008 	ldr	r2, [fp, #-8]
    8b68:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8b6c:	e1520003 	cmp	r2, r3
    8b70:	aa000008 	bge	8b98 <_Z5bzeroPvi+0x58>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:97 (discriminator 2)
		mem[i] = 0;
    8b74:	e51b3008 	ldr	r3, [fp, #-8]
    8b78:	e51b200c 	ldr	r2, [fp, #-12]
    8b7c:	e0823003 	add	r3, r2, r3
    8b80:	e3a02000 	mov	r2, #0
    8b84:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:96 (discriminator 2)
	for (int i = 0; i < length; i++)
    8b88:	e51b3008 	ldr	r3, [fp, #-8]
    8b8c:	e2833001 	add	r3, r3, #1
    8b90:	e50b3008 	str	r3, [fp, #-8]
    8b94:	eafffff2 	b	8b64 <_Z5bzeroPvi+0x24>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:98
}
    8b98:	e320f000 	nop	{0}
    8b9c:	e28bd000 	add	sp, fp, #0
    8ba0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8ba4:	e12fff1e 	bx	lr

00008ba8 <_Z6memcpyPKvPvi>:
_Z6memcpyPKvPvi():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:101

void memcpy(const void* src, void* dst, int num)
{
    8ba8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8bac:	e28db000 	add	fp, sp, #0
    8bb0:	e24dd024 	sub	sp, sp, #36	; 0x24
    8bb4:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8bb8:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8bbc:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:102
	const char* memsrc = reinterpret_cast<const char*>(src);
    8bc0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8bc4:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:103
	char* memdst = reinterpret_cast<char*>(dst);
    8bc8:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8bcc:	e50b3010 	str	r3, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:105

	for (int i = 0; i < num; i++)
    8bd0:	e3a03000 	mov	r3, #0
    8bd4:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:105 (discriminator 3)
    8bd8:	e51b2008 	ldr	r2, [fp, #-8]
    8bdc:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8be0:	e1520003 	cmp	r2, r3
    8be4:	aa00000b 	bge	8c18 <_Z6memcpyPKvPvi+0x70>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:106 (discriminator 2)
		memdst[i] = memsrc[i];
    8be8:	e51b3008 	ldr	r3, [fp, #-8]
    8bec:	e51b200c 	ldr	r2, [fp, #-12]
    8bf0:	e0822003 	add	r2, r2, r3
    8bf4:	e51b3008 	ldr	r3, [fp, #-8]
    8bf8:	e51b1010 	ldr	r1, [fp, #-16]
    8bfc:	e0813003 	add	r3, r1, r3
    8c00:	e5d22000 	ldrb	r2, [r2]
    8c04:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:105 (discriminator 2)
	for (int i = 0; i < num; i++)
    8c08:	e51b3008 	ldr	r3, [fp, #-8]
    8c0c:	e2833001 	add	r3, r3, #1
    8c10:	e50b3008 	str	r3, [fp, #-8]
    8c14:	eaffffef 	b	8bd8 <_Z6memcpyPKvPvi+0x30>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:107
}
    8c18:	e320f000 	nop	{0}
    8c1c:	e28bd000 	add	sp, fp, #0
    8c20:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8c24:	e12fff1e 	bx	lr

00008c28 <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1099
    8c28:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1101
    8c2c:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1102
    8c30:	3a000074 	bcc	8e08 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1103
    8c34:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1104
    8c38:	9a00006b 	bls	8dec <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1105
    8c3c:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1106
    8c40:	0a00006c 	beq	8df8 <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1108
    8c44:	e16f3f10 	clz	r3, r0
    8c48:	e16f2f11 	clz	r2, r1
    8c4c:	e0423003 	sub	r3, r2, r3
    8c50:	e273301f 	rsbs	r3, r3, #31
    8c54:	10833083 	addne	r3, r3, r3, lsl #1
    8c58:	e3a02000 	mov	r2, #0
    8c5c:	108ff103 	addne	pc, pc, r3, lsl #2
    8c60:	e1a00000 	nop			; (mov r0, r0)
    8c64:	e1500f81 	cmp	r0, r1, lsl #31
    8c68:	e0a22002 	adc	r2, r2, r2
    8c6c:	20400f81 	subcs	r0, r0, r1, lsl #31
    8c70:	e1500f01 	cmp	r0, r1, lsl #30
    8c74:	e0a22002 	adc	r2, r2, r2
    8c78:	20400f01 	subcs	r0, r0, r1, lsl #30
    8c7c:	e1500e81 	cmp	r0, r1, lsl #29
    8c80:	e0a22002 	adc	r2, r2, r2
    8c84:	20400e81 	subcs	r0, r0, r1, lsl #29
    8c88:	e1500e01 	cmp	r0, r1, lsl #28
    8c8c:	e0a22002 	adc	r2, r2, r2
    8c90:	20400e01 	subcs	r0, r0, r1, lsl #28
    8c94:	e1500d81 	cmp	r0, r1, lsl #27
    8c98:	e0a22002 	adc	r2, r2, r2
    8c9c:	20400d81 	subcs	r0, r0, r1, lsl #27
    8ca0:	e1500d01 	cmp	r0, r1, lsl #26
    8ca4:	e0a22002 	adc	r2, r2, r2
    8ca8:	20400d01 	subcs	r0, r0, r1, lsl #26
    8cac:	e1500c81 	cmp	r0, r1, lsl #25
    8cb0:	e0a22002 	adc	r2, r2, r2
    8cb4:	20400c81 	subcs	r0, r0, r1, lsl #25
    8cb8:	e1500c01 	cmp	r0, r1, lsl #24
    8cbc:	e0a22002 	adc	r2, r2, r2
    8cc0:	20400c01 	subcs	r0, r0, r1, lsl #24
    8cc4:	e1500b81 	cmp	r0, r1, lsl #23
    8cc8:	e0a22002 	adc	r2, r2, r2
    8ccc:	20400b81 	subcs	r0, r0, r1, lsl #23
    8cd0:	e1500b01 	cmp	r0, r1, lsl #22
    8cd4:	e0a22002 	adc	r2, r2, r2
    8cd8:	20400b01 	subcs	r0, r0, r1, lsl #22
    8cdc:	e1500a81 	cmp	r0, r1, lsl #21
    8ce0:	e0a22002 	adc	r2, r2, r2
    8ce4:	20400a81 	subcs	r0, r0, r1, lsl #21
    8ce8:	e1500a01 	cmp	r0, r1, lsl #20
    8cec:	e0a22002 	adc	r2, r2, r2
    8cf0:	20400a01 	subcs	r0, r0, r1, lsl #20
    8cf4:	e1500981 	cmp	r0, r1, lsl #19
    8cf8:	e0a22002 	adc	r2, r2, r2
    8cfc:	20400981 	subcs	r0, r0, r1, lsl #19
    8d00:	e1500901 	cmp	r0, r1, lsl #18
    8d04:	e0a22002 	adc	r2, r2, r2
    8d08:	20400901 	subcs	r0, r0, r1, lsl #18
    8d0c:	e1500881 	cmp	r0, r1, lsl #17
    8d10:	e0a22002 	adc	r2, r2, r2
    8d14:	20400881 	subcs	r0, r0, r1, lsl #17
    8d18:	e1500801 	cmp	r0, r1, lsl #16
    8d1c:	e0a22002 	adc	r2, r2, r2
    8d20:	20400801 	subcs	r0, r0, r1, lsl #16
    8d24:	e1500781 	cmp	r0, r1, lsl #15
    8d28:	e0a22002 	adc	r2, r2, r2
    8d2c:	20400781 	subcs	r0, r0, r1, lsl #15
    8d30:	e1500701 	cmp	r0, r1, lsl #14
    8d34:	e0a22002 	adc	r2, r2, r2
    8d38:	20400701 	subcs	r0, r0, r1, lsl #14
    8d3c:	e1500681 	cmp	r0, r1, lsl #13
    8d40:	e0a22002 	adc	r2, r2, r2
    8d44:	20400681 	subcs	r0, r0, r1, lsl #13
    8d48:	e1500601 	cmp	r0, r1, lsl #12
    8d4c:	e0a22002 	adc	r2, r2, r2
    8d50:	20400601 	subcs	r0, r0, r1, lsl #12
    8d54:	e1500581 	cmp	r0, r1, lsl #11
    8d58:	e0a22002 	adc	r2, r2, r2
    8d5c:	20400581 	subcs	r0, r0, r1, lsl #11
    8d60:	e1500501 	cmp	r0, r1, lsl #10
    8d64:	e0a22002 	adc	r2, r2, r2
    8d68:	20400501 	subcs	r0, r0, r1, lsl #10
    8d6c:	e1500481 	cmp	r0, r1, lsl #9
    8d70:	e0a22002 	adc	r2, r2, r2
    8d74:	20400481 	subcs	r0, r0, r1, lsl #9
    8d78:	e1500401 	cmp	r0, r1, lsl #8
    8d7c:	e0a22002 	adc	r2, r2, r2
    8d80:	20400401 	subcs	r0, r0, r1, lsl #8
    8d84:	e1500381 	cmp	r0, r1, lsl #7
    8d88:	e0a22002 	adc	r2, r2, r2
    8d8c:	20400381 	subcs	r0, r0, r1, lsl #7
    8d90:	e1500301 	cmp	r0, r1, lsl #6
    8d94:	e0a22002 	adc	r2, r2, r2
    8d98:	20400301 	subcs	r0, r0, r1, lsl #6
    8d9c:	e1500281 	cmp	r0, r1, lsl #5
    8da0:	e0a22002 	adc	r2, r2, r2
    8da4:	20400281 	subcs	r0, r0, r1, lsl #5
    8da8:	e1500201 	cmp	r0, r1, lsl #4
    8dac:	e0a22002 	adc	r2, r2, r2
    8db0:	20400201 	subcs	r0, r0, r1, lsl #4
    8db4:	e1500181 	cmp	r0, r1, lsl #3
    8db8:	e0a22002 	adc	r2, r2, r2
    8dbc:	20400181 	subcs	r0, r0, r1, lsl #3
    8dc0:	e1500101 	cmp	r0, r1, lsl #2
    8dc4:	e0a22002 	adc	r2, r2, r2
    8dc8:	20400101 	subcs	r0, r0, r1, lsl #2
    8dcc:	e1500081 	cmp	r0, r1, lsl #1
    8dd0:	e0a22002 	adc	r2, r2, r2
    8dd4:	20400081 	subcs	r0, r0, r1, lsl #1
    8dd8:	e1500001 	cmp	r0, r1
    8ddc:	e0a22002 	adc	r2, r2, r2
    8de0:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1110
    8de4:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1111
    8de8:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1114
    8dec:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1115
    8df0:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1116
    8df4:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1118
    8df8:	e16f2f11 	clz	r2, r1
    8dfc:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1120
    8e00:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1121
    8e04:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1125
    8e08:	e3500000 	cmp	r0, #0
    8e0c:	13e00000 	mvnne	r0, #0
    8e10:	ea000007 	b	8e34 <__aeabi_idiv0>

00008e14 <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1156
    8e14:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1157
    8e18:	0afffffa 	beq	8e08 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1158
    8e1c:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1159
    8e20:	ebffff80 	bl	8c28 <__udivsi3>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1160
    8e24:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    8e28:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    8e2c:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1163
    8e30:	e12fff1e 	bx	lr

00008e34 <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1461
    8e34:	e12fff1e 	bx	lr

Disassembly of section .rodata:

00008e38 <_ZL13Lock_Unlocked>:
    8e38:	00000000 	andeq	r0, r0, r0

00008e3c <_ZL11Lock_Locked>:
    8e3c:	00000001 	andeq	r0, r0, r1

00008e40 <_ZL21MaxFSDriverNameLength>:
    8e40:	00000010 	andeq	r0, r0, r0, lsl r0

00008e44 <_ZL17MaxFilenameLength>:
    8e44:	00000010 	andeq	r0, r0, r0, lsl r0

00008e48 <_ZL13MaxPathLength>:
    8e48:	00000080 	andeq	r0, r0, r0, lsl #1

00008e4c <_ZL18NoFilesystemDriver>:
    8e4c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008e50 <_ZL9NotifyAll>:
    8e50:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008e54 <_ZL24Max_Process_Opened_Files>:
    8e54:	00000010 	andeq	r0, r0, r0, lsl r0

00008e58 <_ZL10Indefinite>:
    8e58:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008e5c <_ZL18Deadline_Unchanged>:
    8e5c:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00008e60 <_ZL14Invalid_Handle>:
    8e60:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008e64 <_ZN3halL18Default_Clock_RateE>:
    8e64:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

00008e68 <_ZN3halL15Peripheral_BaseE>:
    8e68:	20000000 	andcs	r0, r0, r0

00008e6c <_ZN3halL9GPIO_BaseE>:
    8e6c:	20200000 	eorcs	r0, r0, r0

00008e70 <_ZN3halL14GPIO_Pin_CountE>:
    8e70:	00000036 	andeq	r0, r0, r6, lsr r0

00008e74 <_ZN3halL8AUX_BaseE>:
    8e74:	20215000 	eorcs	r5, r1, r0

00008e78 <_ZN3halL25Interrupt_Controller_BaseE>:
    8e78:	2000b200 	andcs	fp, r0, r0, lsl #4

00008e7c <_ZN3halL10Timer_BaseE>:
    8e7c:	2000b400 	andcs	fp, r0, r0, lsl #8

00008e80 <_ZN3halL9TRNG_BaseE>:
    8e80:	20104000 	andscs	r4, r0, r0

00008e84 <_ZN3halL9BSC0_BaseE>:
    8e84:	20205000 	eorcs	r5, r0, r0

00008e88 <_ZN3halL9BSC1_BaseE>:
    8e88:	20804000 	addcs	r4, r0, r0

00008e8c <_ZN3halL9BSC2_BaseE>:
    8e8c:	20805000 	addcs	r5, r0, r0

00008e90 <_ZL11Invalid_Pin>:
    8e90:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
    8e94:	3a564544 	bcc	159a3ac <__bss_end+0x1591498>
    8e98:	6f697067 	svcvs	0x00697067
    8e9c:	0033322f 	eorseq	r3, r3, pc, lsr #4
    8ea0:	00676f6c 	rsbeq	r6, r7, ip, ror #30
    8ea4:	746c6954 	strbtvc	r6, [ip], #-2388	; 0xfffff6ac
    8ea8:	00505520 	subseq	r5, r0, r0, lsr #10
    8eac:	746c6954 	strbtvc	r6, [ip], #-2388	; 0xfffff6ac
    8eb0:	574f4420 	strbpl	r4, [pc, -r0, lsr #8]
    8eb4:	0000004e 	andeq	r0, r0, lr, asr #32

00008eb8 <_ZL13Lock_Unlocked>:
    8eb8:	00000000 	andeq	r0, r0, r0

00008ebc <_ZL11Lock_Locked>:
    8ebc:	00000001 	andeq	r0, r0, r1

00008ec0 <_ZL21MaxFSDriverNameLength>:
    8ec0:	00000010 	andeq	r0, r0, r0, lsl r0

00008ec4 <_ZL17MaxFilenameLength>:
    8ec4:	00000010 	andeq	r0, r0, r0, lsl r0

00008ec8 <_ZL13MaxPathLength>:
    8ec8:	00000080 	andeq	r0, r0, r0, lsl #1

00008ecc <_ZL18NoFilesystemDriver>:
    8ecc:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008ed0 <_ZL9NotifyAll>:
    8ed0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008ed4 <_ZL24Max_Process_Opened_Files>:
    8ed4:	00000010 	andeq	r0, r0, r0, lsl r0

00008ed8 <_ZL10Indefinite>:
    8ed8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008edc <_ZL18Deadline_Unchanged>:
    8edc:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00008ee0 <_ZL14Invalid_Handle>:
    8ee0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008ee4 <_ZL16Pipe_File_Prefix>:
    8ee4:	3a535953 	bcc	14df438 <__bss_end+0x14d6524>
    8ee8:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    8eec:	0000002f 	andeq	r0, r0, pc, lsr #32

00008ef0 <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    8ef0:	33323130 	teqcc	r2, #48, 2
    8ef4:	37363534 			; <UNDEFINED> instruction: 0x37363534
    8ef8:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    8efc:	46454443 	strbmi	r4, [r5], -r3, asr #8
	...

Disassembly of section .bss:

00008f04 <__bss_start>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x1684918>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x39510>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3d124>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c7e10>
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
  24:	6a6b6e65 	bvs	1adb9c0 <__bss_end+0x1ad2aac>
  28:	32736f2f 	rsbscc	r6, r3, #47, 30	; 0xbc
  2c:	2f323230 	svccs	0x00323230
  30:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
  34:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
  38:	752f7365 	strvc	r7, [pc, #-869]!	; fffffcdb <__bss_end+0xffff6dc7>
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
  7c:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffffc8 <__bss_end+0xffff70b4>
  80:	63732f65 	cmnvs	r3, #404	; 0x194
  84:	6b6e6568 	blvs	1b9962c <__bss_end+0x1b90718>
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
  bc:	1b050109 	blne	1404e8 <__bss_end+0x1375d4>
  c0:	4a130567 	bmi	4c1664 <__bss_end+0x4b8750>
  c4:	052f0505 	streq	r0, [pc, #-1285]!	; fffffbc7 <__bss_end+0xffff6cb3>
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
 104:	fb010200 	blx	4090e <__bss_end+0x379fa>
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
 168:	0b05010a 	bleq	140598 <__bss_end+0x137684>
 16c:	4a0a0583 	bmi	281780 <__bss_end+0x27886c>
 170:	85830205 	strhi	r0, [r3, #517]	; 0x205
 174:	05830e05 	streq	r0, [r3, #3589]	; 0xe05
 178:	84856702 	strhi	r6, [r5], #1794	; 0x702
 17c:	4c860105 	stfmis	f0, [r6], {5}
 180:	4c854c85 	stcmi	12, cr4, [r5], {133}	; 0x85
 184:	00020585 	andeq	r0, r2, r5, lsl #11
 188:	4b010402 	blmi	41198 <__bss_end+0x38284>
 18c:	12030105 	andne	r0, r3, #1073741825	; 0x40000001
 190:	6b0d052e 	blvs	341650 <__bss_end+0x33873c>
 194:	02002405 	andeq	r2, r0, #83886080	; 0x5000000
 198:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 19c:	04020004 	streq	r0, [r2], #-4
 1a0:	0b058302 	bleq	160db0 <__bss_end+0x157e9c>
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
 1e0:	00021501 	andeq	r1, r2, r1, lsl #10
 1e4:	d5000300 	strle	r0, [r0, #-768]	; 0xfffffd00
 1e8:	02000001 	andeq	r0, r0, #1
 1ec:	0d0efb01 	vstreq	d15, [lr, #-4]
 1f0:	01010100 	mrseq	r0, (UNDEF: 17)
 1f4:	00000001 	andeq	r0, r0, r1
 1f8:	01000001 	tsteq	r0, r1
 1fc:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 148 <shift+0x148>
 200:	63732f65 	cmnvs	r3, #404	; 0x194
 204:	6b6e6568 	blvs	1b997ac <__bss_end+0x1b90898>
 208:	736f2f6a 	cmnvc	pc, #424	; 0x1a8
 20c:	32323032 	eorscc	r3, r2, #50	; 0x32
 210:	2f70732f 	svccs	0x0070732f
 214:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 218:	2f736563 	svccs	0x00736563
 21c:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 220:	63617073 	cmnvs	r1, #115	; 0x73
 224:	69742f65 	ldmdbvs	r4!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
 228:	745f746c 	ldrbvc	r7, [pc], #-1132	; 230 <shift+0x230>
 22c:	006b7361 	rsbeq	r7, fp, r1, ror #6
 230:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 17c <shift+0x17c>
 234:	63732f65 	cmnvs	r3, #404	; 0x194
 238:	6b6e6568 	blvs	1b997e0 <__bss_end+0x1b908cc>
 23c:	736f2f6a 	cmnvc	pc, #424	; 0x1a8
 240:	32323032 	eorscc	r3, r2, #50	; 0x32
 244:	2f70732f 	svccs	0x0070732f
 248:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 24c:	2f736563 	svccs	0x00736563
 250:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 254:	63617073 	cmnvs	r1, #115	; 0x73
 258:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
 25c:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 260:	2f6c656e 	svccs	0x006c656e
 264:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 268:	2f656475 	svccs	0x00656475
 26c:	636f7270 	cmnvs	pc, #112, 4
 270:	00737365 	rsbseq	r7, r3, r5, ror #6
 274:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 1c0 <shift+0x1c0>
 278:	63732f65 	cmnvs	r3, #404	; 0x194
 27c:	6b6e6568 	blvs	1b99824 <__bss_end+0x1b90910>
 280:	736f2f6a 	cmnvc	pc, #424	; 0x1a8
 284:	32323032 	eorscc	r3, r2, #50	; 0x32
 288:	2f70732f 	svccs	0x0070732f
 28c:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 290:	2f736563 	svccs	0x00736563
 294:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 298:	63617073 	cmnvs	r1, #115	; 0x73
 29c:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
 2a0:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 2a4:	2f6c656e 	svccs	0x006c656e
 2a8:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 2ac:	2f656475 	svccs	0x00656475
 2b0:	72616f62 	rsbvc	r6, r1, #392	; 0x188
 2b4:	70722f64 	rsbsvc	r2, r2, r4, ror #30
 2b8:	682f3069 	stmdavs	pc!, {r0, r3, r5, r6, ip, sp}	; <UNPREDICTABLE>
 2bc:	2f006c61 	svccs	0x00006c61
 2c0:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 2c4:	6863732f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, sp, lr}^
 2c8:	6a6b6e65 	bvs	1adbc64 <__bss_end+0x1ad2d50>
 2cc:	32736f2f 	rsbscc	r6, r3, #47, 30	; 0xbc
 2d0:	2f323230 	svccs	0x00323230
 2d4:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
 2d8:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 2dc:	752f7365 	strvc	r7, [pc, #-869]!	; ffffff7f <__bss_end+0xffff706b>
 2e0:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 2e4:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 2e8:	2f2e2e2f 	svccs	0x002e2e2f
 2ec:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 2f0:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 2f4:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 2f8:	662f6564 	strtvs	r6, [pc], -r4, ror #10
 2fc:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
 300:	2f656d6f 	svccs	0x00656d6f
 304:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
 308:	2f6a6b6e 	svccs	0x006a6b6e
 30c:	3032736f 	eorscc	r7, r2, pc, ror #6
 310:	732f3232 			; <UNDEFINED> instruction: 0x732f3232
 314:	6f732f70 	svcvs	0x00732f70
 318:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 31c:	73752f73 	cmnvc	r5, #460	; 0x1cc
 320:	70737265 	rsbsvc	r7, r3, r5, ror #4
 324:	2f656361 	svccs	0x00656361
 328:	6b2f2e2e 	blvs	bcbbe8 <__bss_end+0xbc2cd4>
 32c:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 330:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 334:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 338:	72642f65 	rsbvc	r2, r4, #404	; 0x194
 33c:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
 340:	6d000073 	stcvs	0, cr0, [r0, #-460]	; 0xfffffe34
 344:	2e6e6961 	vnmulcs.f16	s13, s28, s3	; <UNPREDICTABLE>
 348:	00707063 	rsbseq	r7, r0, r3, rrx
 34c:	73000001 	movwvc	r0, #1
 350:	682e6977 	stmdavs	lr!, {r0, r1, r2, r4, r5, r6, r8, fp, sp, lr}
 354:	00000200 	andeq	r0, r0, r0, lsl #4
 358:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
 35c:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
 360:	00000300 	andeq	r0, r0, r0, lsl #6
 364:	6e697073 	mcrvs	0, 3, r7, cr9, cr3, {3}
 368:	6b636f6c 	blvs	18dc120 <__bss_end+0x18d320c>
 36c:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 370:	69660000 	stmdbvs	r6!, {}^	; <UNPREDICTABLE>
 374:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
 378:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
 37c:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
 380:	72700000 	rsbsvc	r0, r0, #0
 384:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
 388:	00682e73 	rsbeq	r2, r8, r3, ror lr
 38c:	70000002 	andvc	r0, r0, r2
 390:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 394:	6d5f7373 	ldclvs	3, cr7, [pc, #-460]	; 1d0 <shift+0x1d0>
 398:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
 39c:	682e7265 	stmdavs	lr!, {r0, r2, r5, r6, r9, ip, sp, lr}
 3a0:	00000200 	andeq	r0, r0, r0, lsl #4
 3a4:	69726570 	ldmdbvs	r2!, {r4, r5, r6, r8, sl, sp, lr}^
 3a8:	72656870 	rsbvc	r6, r5, #112, 16	; 0x700000
 3ac:	2e736c61 	cdpcs	12, 7, cr6, cr3, cr1, {3}
 3b0:	00030068 	andeq	r0, r3, r8, rrx
 3b4:	69706700 	ldmdbvs	r0!, {r8, r9, sl, sp, lr}^
 3b8:	00682e6f 	rsbeq	r2, r8, pc, ror #28
 3bc:	00000005 	andeq	r0, r0, r5
 3c0:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
 3c4:	00823802 	addeq	r3, r2, r2, lsl #16
 3c8:	010e0300 	mrseq	r0, ELR_hyp
 3cc:	4b9f0705 	blmi	fe7c1fe8 <__bss_end+0xfe7b90d4>
 3d0:	054c2105 	strbeq	r2, [ip, #-261]	; 0xfffffefb
 3d4:	07058a09 	streq	r8, [r5, -r9, lsl #20]
 3d8:	a019054b 	andsge	r0, r9, fp, asr #10
 3dc:	87860705 	strhi	r0, [r6, r5, lsl #14]
 3e0:	05a20e05 	streq	r0, [r2, #3589]!	; 0xe05
 3e4:	0a052e04 	beq	14bbfc <__bss_end+0x142ce8>
 3e8:	0d05a24c 	sfmeq	f2, 1, [r5, #-304]	; 0xfffffed0
 3ec:	4d080584 	cfstr32mi	mvfx0, [r8, #-528]	; 0xfffffdf0
 3f0:	6c030705 	stcvs	7, cr0, [r3], {5}
 3f4:	000a0266 	andeq	r0, sl, r6, ror #4
 3f8:	027c0101 	rsbseq	r0, ip, #1073741824	; 0x40000000
 3fc:	00030000 	andeq	r0, r3, r0
 400:	00000149 	andeq	r0, r0, r9, asr #2
 404:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 408:	0101000d 	tsteq	r1, sp
 40c:	00000101 	andeq	r0, r0, r1, lsl #2
 410:	00000100 	andeq	r0, r0, r0, lsl #2
 414:	6f682f01 	svcvs	0x00682f01
 418:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
 41c:	6e656863 	cdpvs	8, 6, cr6, cr5, cr3, {3}
 420:	6f2f6a6b 	svcvs	0x002f6a6b
 424:	32303273 	eorscc	r3, r0, #805306375	; 0x30000007
 428:	70732f32 	rsbsvc	r2, r3, r2, lsr pc
 42c:	756f732f 	strbvc	r7, [pc, #-815]!	; 105 <shift+0x105>
 430:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 434:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
 438:	2f62696c 	svccs	0x0062696c
 43c:	00637273 	rsbeq	r7, r3, r3, ror r2
 440:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 38c <shift+0x38c>
 444:	63732f65 	cmnvs	r3, #404	; 0x194
 448:	6b6e6568 	blvs	1b999f0 <__bss_end+0x1b90adc>
 44c:	736f2f6a 	cmnvc	pc, #424	; 0x1a8
 450:	32323032 	eorscc	r3, r2, #50	; 0x32
 454:	2f70732f 	svccs	0x0070732f
 458:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 45c:	2f736563 	svccs	0x00736563
 460:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 464:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 468:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 46c:	702f6564 	eorvc	r6, pc, r4, ror #10
 470:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 474:	2f007373 	svccs	0x00007373
 478:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 47c:	6863732f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, sp, lr}^
 480:	6a6b6e65 	bvs	1adbe1c <__bss_end+0x1ad2f08>
 484:	32736f2f 	rsbscc	r6, r3, #47, 30	; 0xbc
 488:	2f323230 	svccs	0x00323230
 48c:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
 490:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 494:	6b2f7365 	blvs	bdd230 <__bss_end+0xbd431c>
 498:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 49c:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 4a0:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 4a4:	73662f65 	cmnvc	r6, #404	; 0x194
 4a8:	6f682f00 	svcvs	0x00682f00
 4ac:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
 4b0:	6e656863 	cdpvs	8, 6, cr6, cr5, cr3, {3}
 4b4:	6f2f6a6b 	svcvs	0x002f6a6b
 4b8:	32303273 	eorscc	r3, r0, #805306375	; 0x30000007
 4bc:	70732f32 	rsbsvc	r2, r3, r2, lsr pc
 4c0:	756f732f 	strbvc	r7, [pc, #-815]!	; 199 <shift+0x199>
 4c4:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 4c8:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 4cc:	2f6c656e 	svccs	0x006c656e
 4d0:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 4d4:	2f656475 	svccs	0x00656475
 4d8:	72616f62 	rsbvc	r6, r1, #392	; 0x188
 4dc:	70722f64 	rsbsvc	r2, r2, r4, ror #30
 4e0:	682f3069 	stmdavs	pc!, {r0, r3, r5, r6, ip, sp}	; <UNPREDICTABLE>
 4e4:	00006c61 	andeq	r6, r0, r1, ror #24
 4e8:	66647473 			; <UNDEFINED> instruction: 0x66647473
 4ec:	2e656c69 	cdpcs	12, 6, cr6, cr5, cr9, {3}
 4f0:	00707063 	rsbseq	r7, r0, r3, rrx
 4f4:	73000001 	movwvc	r0, #1
 4f8:	682e6977 	stmdavs	lr!, {r0, r1, r2, r4, r5, r6, r8, fp, sp, lr}
 4fc:	00000200 	andeq	r0, r0, r0, lsl #4
 500:	6e697073 	mcrvs	0, 3, r7, cr9, cr3, {3}
 504:	6b636f6c 	blvs	18dc2bc <__bss_end+0x18d33a8>
 508:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 50c:	69660000 	stmdbvs	r6!, {}^	; <UNPREDICTABLE>
 510:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
 514:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
 518:	0300682e 	movweq	r6, #2094	; 0x82e
 51c:	72700000 	rsbsvc	r0, r0, #0
 520:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
 524:	00682e73 	rsbeq	r2, r8, r3, ror lr
 528:	70000002 	andvc	r0, r0, r2
 52c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 530:	6d5f7373 	ldclvs	3, cr7, [pc, #-460]	; 36c <shift+0x36c>
 534:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
 538:	682e7265 	stmdavs	lr!, {r0, r2, r5, r6, r9, ip, sp, lr}
 53c:	00000200 	andeq	r0, r0, r0, lsl #4
 540:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
 544:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
 548:	00000400 	andeq	r0, r0, r0, lsl #8
 54c:	00010500 	andeq	r0, r1, r0, lsl #10
 550:	83140205 	tsthi	r4, #1342177280	; 0x50000000
 554:	05160000 	ldreq	r0, [r6, #-0]
 558:	2c05691a 			; <UNDEFINED> instruction: 0x2c05691a
 55c:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 560:	852f0105 	strhi	r0, [pc, #-261]!	; 463 <shift+0x463>
 564:	05833205 	streq	r3, [r3, #517]	; 0x205
 568:	01054b1a 	tsteq	r5, sl, lsl fp
 56c:	1a05852f 	bne	161a30 <__bss_end+0x158b1c>
 570:	2f01054b 	svccs	0x0001054b
 574:	a1320585 	teqge	r2, r5, lsl #11
 578:	054b2e05 	strbeq	r2, [fp, #-3589]	; 0xfffff1fb
 57c:	2d054b1b 	vstrcs	d4, [r5, #-108]	; 0xffffff94
 580:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 584:	852f0105 	strhi	r0, [pc, #-261]!	; 487 <shift+0x487>
 588:	05bd2e05 	ldreq	r2, [sp, #3589]!	; 0xe05
 58c:	2e054b30 	vmovcs.16	d5[0], r4
 590:	4b1b054b 	blmi	6c1ac4 <__bss_end+0x6b8bb0>
 594:	052f2e05 	streq	r2, [pc, #-3589]!	; fffff797 <__bss_end+0xffff6883>
 598:	01054c0c 	tsteq	r5, ip, lsl #24
 59c:	2e05852f 	cfsh32cs	mvfx8, mvfx5, #31
 5a0:	4b3005bd 	blmi	c01c9c <__bss_end+0xbf8d88>
 5a4:	054b2e05 	strbeq	r2, [fp, #-3589]	; 0xfffff1fb
 5a8:	2e054b1b 	vmovcs.32	d5[0], r4
 5ac:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 5b0:	852f0105 	strhi	r0, [pc, #-261]!	; 4b3 <shift+0x4b3>
 5b4:	05832e05 	streq	r2, [r3, #3589]	; 0xe05
 5b8:	01054b1b 	tsteq	r5, fp, lsl fp
 5bc:	2e05852f 	cfsh32cs	mvfx8, mvfx5, #31
 5c0:	4b3305bd 	blmi	cc1cbc <__bss_end+0xcb8da8>
 5c4:	054b2f05 	strbeq	r2, [fp, #-3845]	; 0xfffff0fb
 5c8:	30054b1b 	andcc	r4, r5, fp, lsl fp
 5cc:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 5d0:	852f0105 	strhi	r0, [pc, #-261]!	; 4d3 <shift+0x4d3>
 5d4:	05a12e05 	streq	r2, [r1, #3589]!	; 0xe05
 5d8:	1b054b2f 	blne	15329c <__bss_end+0x14a388>
 5dc:	2f2f054b 	svccs	0x002f054b
 5e0:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 5e4:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 5e8:	2f05bd2e 	svccs	0x0005bd2e
 5ec:	4b3b054b 	blmi	ec1b20 <__bss_end+0xeb8c0c>
 5f0:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
 5f4:	0c052f30 	stceq	15, cr2, [r5], {48}	; 0x30
 5f8:	2f01054c 	svccs	0x0001054c
 5fc:	a12f0585 	smlawbge	pc, r5, r5, r0	; <UNPREDICTABLE>
 600:	054b3b05 	strbeq	r3, [fp, #-2821]	; 0xfffff4fb
 604:	30054b1a 	andcc	r4, r5, sl, lsl fp
 608:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 60c:	859f0105 	ldrhi	r0, [pc, #261]	; 719 <shift+0x719>
 610:	05672005 	strbeq	r2, [r7, #-5]!
 614:	31054d2d 	tstcc	r5, sp, lsr #26
 618:	4b1a054b 	blmi	681b4c <__bss_end+0x678c38>
 61c:	05300c05 	ldreq	r0, [r0, #-3077]!	; 0xfffff3fb
 620:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 624:	2d056720 	stccs	7, cr6, [r5, #-128]	; 0xffffff80
 628:	4b31054d 	blmi	c41b64 <__bss_end+0xc38c50>
 62c:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
 630:	0105300c 	tsteq	r5, ip
 634:	2005852f 	andcs	r8, r5, pc, lsr #10
 638:	4c2d0583 	cfstr32mi	mvfx0, [sp], #-524	; 0xfffffdf4
 63c:	054b3e05 	strbeq	r3, [fp, #-3589]	; 0xfffff1fb
 640:	01054b1a 	tsteq	r5, sl, lsl fp
 644:	2005852f 	andcs	r8, r5, pc, lsr #10
 648:	4d2d0567 	cfstr32mi	mvfx0, [sp, #-412]!	; 0xfffffe64
 64c:	054b3005 	strbeq	r3, [fp, #-5]
 650:	0c054b1a 			; <UNDEFINED> instruction: 0x0c054b1a
 654:	2f010530 	svccs	0x00010530
 658:	a00c0587 	andge	r0, ip, r7, lsl #11
 65c:	bc31059f 	cfldr32lt	mvfx0, [r1], #-636	; 0xfffffd84
 660:	05662905 	strbeq	r2, [r6, #-2309]!	; 0xfffff6fb
 664:	0f052e36 	svceq	0x00052e36
 668:	66130530 			; <UNDEFINED> instruction: 0x66130530
 66c:	05840905 	streq	r0, [r4, #2309]	; 0x905
 670:	0105d810 	tsteq	r5, r0, lsl r8
 674:	0008029f 	muleq	r8, pc, r2	; <UNPREDICTABLE>
 678:	02760101 	rsbseq	r0, r6, #1073741824	; 0x40000000
 67c:	00030000 	andeq	r0, r3, r0
 680:	0000004f 	andeq	r0, r0, pc, asr #32
 684:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 688:	0101000d 	tsteq	r1, sp
 68c:	00000101 	andeq	r0, r0, r1, lsl #2
 690:	00000100 	andeq	r0, r0, r0, lsl #2
 694:	6f682f01 	svcvs	0x00682f01
 698:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
 69c:	6e656863 	cdpvs	8, 6, cr6, cr5, cr3, {3}
 6a0:	6f2f6a6b 	svcvs	0x002f6a6b
 6a4:	32303273 	eorscc	r3, r0, #805306375	; 0x30000007
 6a8:	70732f32 	rsbsvc	r2, r3, r2, lsr pc
 6ac:	756f732f 	strbvc	r7, [pc, #-815]!	; 385 <shift+0x385>
 6b0:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 6b4:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
 6b8:	2f62696c 	svccs	0x0062696c
 6bc:	00637273 	rsbeq	r7, r3, r3, ror r2
 6c0:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
 6c4:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
 6c8:	632e676e 			; <UNDEFINED> instruction: 0x632e676e
 6cc:	01007070 	tsteq	r0, r0, ror r0
 6d0:	05000000 	streq	r0, [r0, #-0]
 6d4:	02050001 	andeq	r0, r5, #1
 6d8:	00008770 	andeq	r8, r0, r0, ror r7
 6dc:	bb06051a 	bllt	181b4c <__bss_end+0x178c38>
 6e0:	054c0f05 	strbeq	r0, [ip, #-3845]	; 0xfffff0fb
 6e4:	0a056821 	beq	15a770 <__bss_end+0x15185c>
 6e8:	2e0b05ba 	mcrcs	5, 0, r0, cr11, cr10, {5}
 6ec:	054a2705 	strbeq	r2, [sl, #-1797]	; 0xfffff8fb
 6f0:	09054a0d 	stmdbeq	r5, {r0, r2, r3, r9, fp, lr}
 6f4:	9f04052f 	svcls	0x0004052f
 6f8:	05620205 	strbeq	r0, [r2, #-517]!	; 0xfffffdfb
 6fc:	10053505 	andne	r3, r5, r5, lsl #10
 700:	2e110568 	cfmsc32cs	mvfx0, mvfx1, mvfx8
 704:	054a2205 	strbeq	r2, [sl, #-517]	; 0xfffffdfb
 708:	0a052e13 	beq	14bf5c <__bss_end+0x143048>
 70c:	6909052f 	stmdbvs	r9, {r0, r1, r2, r3, r5, r8, sl}
 710:	052e0a05 	streq	r0, [lr, #-2565]!	; 0xfffff5fb
 714:	03054a0c 	movweq	r4, #23052	; 0x5a0c
 718:	680b054b 	stmdavs	fp, {r0, r1, r3, r6, r8, sl}
 71c:	02001805 	andeq	r1, r0, #327680	; 0x50000
 720:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 724:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
 728:	15059e03 	strne	r9, [r5, #-3587]	; 0xfffff1fd
 72c:	02040200 	andeq	r0, r4, #0, 4
 730:	00180568 	andseq	r0, r8, r8, ror #10
 734:	82020402 	andhi	r0, r2, #33554432	; 0x2000000
 738:	02000805 	andeq	r0, r0, #327680	; 0x50000
 73c:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 740:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
 744:	1b054b02 	blne	153354 <__bss_end+0x14a440>
 748:	02040200 	andeq	r0, r4, #0, 4
 74c:	000c052e 	andeq	r0, ip, lr, lsr #10
 750:	4a020402 	bmi	81760 <__bss_end+0x7884c>
 754:	02000f05 	andeq	r0, r0, #5, 30
 758:	05820204 	streq	r0, [r2, #516]	; 0x204
 75c:	0402001b 	streq	r0, [r2], #-27	; 0xffffffe5
 760:	11054a02 	tstne	r5, r2, lsl #20
 764:	02040200 	andeq	r0, r4, #0, 4
 768:	000a052e 	andeq	r0, sl, lr, lsr #10
 76c:	2f020402 	svccs	0x00020402
 770:	02000b05 	andeq	r0, r0, #5120	; 0x1400
 774:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 778:	0402000d 	streq	r0, [r2], #-13
 77c:	02054a02 	andeq	r4, r5, #8192	; 0x2000
 780:	02040200 	andeq	r0, r4, #0, 4
 784:	88010546 	stmdahi	r1, {r1, r2, r6, r8, sl}
 788:	83060585 	movwhi	r0, #25989	; 0x6585
 78c:	054c0905 	strbeq	r0, [ip, #-2309]	; 0xfffff6fb
 790:	0a054a10 	beq	152fd8 <__bss_end+0x14a0c4>
 794:	bb07054c 	bllt	1c1ccc <__bss_end+0x1b8db8>
 798:	054a0305 	strbeq	r0, [sl, #-773]	; 0xfffffcfb
 79c:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
 7a0:	14054a01 	strne	r4, [r5], #-2561	; 0xfffff5ff
 7a4:	01040200 	mrseq	r0, R12_usr
 7a8:	4d0d054a 	cfstr32mi	mvfx0, [sp, #-296]	; 0xfffffed8
 7ac:	054a1405 	strbeq	r1, [sl, #-1029]	; 0xfffffbfb
 7b0:	08052e0a 	stmdaeq	r5, {r1, r3, r9, sl, fp, sp}
 7b4:	03020568 	movweq	r0, #9576	; 0x2568
 7b8:	09056678 	stmdbeq	r5, {r3, r4, r5, r6, r9, sl, sp, lr}
 7bc:	052e0b03 	streq	r0, [lr, #-2819]!	; 0xfffff4fd
 7c0:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 7c4:	1605bd09 	strne	fp, [r5], -r9, lsl #26
 7c8:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 7cc:	001d054a 	andseq	r0, sp, sl, asr #10
 7d0:	82020402 	andhi	r0, r2, #33554432	; 0x2000000
 7d4:	02001e05 	andeq	r1, r0, #5, 28	; 0x50
 7d8:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 7dc:	04020016 	streq	r0, [r2], #-22	; 0xffffffea
 7e0:	11056602 	tstne	r5, r2, lsl #12
 7e4:	03040200 	movweq	r0, #16896	; 0x4200
 7e8:	0012054b 	andseq	r0, r2, fp, asr #10
 7ec:	2e030402 	cdpcs	4, 0, cr0, cr3, cr2, {0}
 7f0:	02000805 	andeq	r0, r0, #327680	; 0x50000
 7f4:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 7f8:	04020009 	streq	r0, [r2], #-9
 7fc:	12052e03 	andne	r2, r5, #3, 28	; 0x30
 800:	03040200 	movweq	r0, #16896	; 0x4200
 804:	000b054a 	andeq	r0, fp, sl, asr #10
 808:	2e030402 	cdpcs	4, 0, cr0, cr3, cr2, {0}
 80c:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 810:	052d0304 	streq	r0, [sp, #-772]!	; 0xfffffcfc
 814:	0402000b 	streq	r0, [r2], #-11
 818:	08058402 	stmdaeq	r5, {r1, sl, pc}
 81c:	01040200 	mrseq	r0, R12_usr
 820:	00090583 	andeq	r0, r9, r3, lsl #11
 824:	2e010402 	cdpcs	4, 0, cr0, cr1, cr2, {0}
 828:	02000b05 	andeq	r0, r0, #5120	; 0x1400
 82c:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
 830:	04020002 	streq	r0, [r2], #-2
 834:	0b054901 	bleq	152c40 <__bss_end+0x149d2c>
 838:	2f010585 	svccs	0x00010585
 83c:	bc0e0585 	cfstr32lt	mvfx0, [lr], {133}	; 0x85
 840:	05661105 	strbeq	r1, [r6, #-261]!	; 0xfffffefb
 844:	0b05bc20 	bleq	16f8cc <__bss_end+0x1669b8>
 848:	4b1f0566 	blmi	7c1de8 <__bss_end+0x7b8ed4>
 84c:	05660a05 	strbeq	r0, [r6, #-2565]!	; 0xfffff5fb
 850:	11054b08 	tstne	r5, r8, lsl #22
 854:	2e160583 	cdpcs	5, 1, cr0, cr6, cr3, {4}
 858:	05670805 	strbeq	r0, [r7, #-2053]!	; 0xfffff7fb
 85c:	0b056711 	bleq	15a4a8 <__bss_end+0x151594>
 860:	2f01054d 	svccs	0x0001054d
 864:	83060585 	movwhi	r0, #25989	; 0x6585
 868:	054c0b05 	strbeq	r0, [ip, #-2821]	; 0xfffff4fb
 86c:	0e052e0c 	cdpeq	14, 0, cr2, cr5, cr12, {0}
 870:	4b040566 	blmi	101e10 <__bss_end+0xf8efc>
 874:	05650205 	strbeq	r0, [r5, #-517]!	; 0xfffffdfb
 878:	01053109 	tsteq	r5, r9, lsl #2
 87c:	0805852f 	stmdaeq	r5, {r0, r1, r2, r3, r5, r8, sl, pc}
 880:	4c0b059f 	cfstr32mi	mvfx0, [fp], {159}	; 0x9f
 884:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
 888:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 88c:	04020007 	streq	r0, [r2], #-7
 890:	08058302 	stmdaeq	r5, {r1, r8, r9, pc}
 894:	02040200 	andeq	r0, r4, #0, 4
 898:	000a052e 	andeq	r0, sl, lr, lsr #10
 89c:	4a020402 	bmi	818ac <__bss_end+0x78998>
 8a0:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 8a4:	05490204 	strbeq	r0, [r9, #-516]	; 0xfffffdfc
 8a8:	05858401 	streq	r8, [r5, #1025]	; 0x401
 8ac:	0805bb0e 	stmdaeq	r5, {r1, r2, r3, r8, r9, fp, ip, sp, pc}
 8b0:	4c0b054b 	cfstr32mi	mvfx0, [fp], {75}	; 0x4b
 8b4:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
 8b8:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 8bc:	04020016 	streq	r0, [r2], #-22	; 0xffffffea
 8c0:	17058302 	strne	r8, [r5, -r2, lsl #6]
 8c4:	02040200 	andeq	r0, r4, #0, 4
 8c8:	000a052e 	andeq	r0, sl, lr, lsr #10
 8cc:	4a020402 	bmi	818dc <__bss_end+0x789c8>
 8d0:	02000b05 	andeq	r0, r0, #5120	; 0x1400
 8d4:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 8d8:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
 8dc:	0d054a02 	vstreq	s8, [r5, #-8]
 8e0:	02040200 	andeq	r0, r4, #0, 4
 8e4:	0002052e 	andeq	r0, r2, lr, lsr #10
 8e8:	2d020402 	cfstrscs	mvf0, [r2, #-8]
 8ec:	02840105 	addeq	r0, r4, #1073741825	; 0x40000001
 8f0:	01010008 	tsteq	r1, r8
 8f4:	00000079 	andeq	r0, r0, r9, ror r0
 8f8:	00460003 	subeq	r0, r6, r3
 8fc:	01020000 	mrseq	r0, (UNDEF: 2)
 900:	000d0efb 	strdeq	r0, [sp], -fp
 904:	01010101 	tsteq	r1, r1, lsl #2
 908:	01000000 	mrseq	r0, (UNDEF: 0)
 90c:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
 910:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 914:	2f2e2e2f 	svccs	0x002e2e2f
 918:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 91c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 920:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
 924:	2f636367 	svccs	0x00636367
 928:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
 92c:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
 930:	00006d72 	andeq	r6, r0, r2, ror sp
 934:	3162696c 	cmncc	r2, ip, ror #18
 938:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
 93c:	00532e73 	subseq	r2, r3, r3, ror lr
 940:	00000001 	andeq	r0, r0, r1
 944:	28020500 	stmdacs	r2, {r8, sl}
 948:	0300008c 	movweq	r0, #140	; 0x8c
 94c:	300108ca 	andcc	r0, r1, sl, asr #17
 950:	2f2f2f2f 	svccs	0x002f2f2f
 954:	d002302f 	andle	r3, r2, pc, lsr #32
 958:	312f1401 			; <UNDEFINED> instruction: 0x312f1401
 95c:	4c302f2f 	ldcmi	15, cr2, [r0], #-188	; 0xffffff44
 960:	1f03322f 	svcne	0x0003322f
 964:	2f2f2f66 	svccs	0x002f2f66
 968:	2f2f2f2f 	svccs	0x002f2f2f
 96c:	01000202 	tsteq	r0, r2, lsl #4
 970:	00005c01 	andeq	r5, r0, r1, lsl #24
 974:	46000300 	strmi	r0, [r0], -r0, lsl #6
 978:	02000000 	andeq	r0, r0, #0
 97c:	0d0efb01 	vstreq	d15, [lr, #-4]
 980:	01010100 	mrseq	r0, (UNDEF: 17)
 984:	00000001 	andeq	r0, r0, r1
 988:	01000001 	tsteq	r0, r1
 98c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 990:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 994:	2f2e2e2f 	svccs	0x002e2e2f
 998:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 99c:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
 9a0:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 9a4:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
 9a8:	2f676966 	svccs	0x00676966
 9ac:	006d7261 	rsbeq	r7, sp, r1, ror #4
 9b0:	62696c00 	rsbvs	r6, r9, #0, 24
 9b4:	6e756631 	mrcvs	6, 3, r6, cr5, cr1, {1}
 9b8:	532e7363 			; <UNDEFINED> instruction: 0x532e7363
 9bc:	00000100 	andeq	r0, r0, r0, lsl #2
 9c0:	02050000 	andeq	r0, r5, #0
 9c4:	00008e34 	andeq	r8, r0, r4, lsr lr
 9c8:	010bb403 	tsteq	fp, r3, lsl #8
 9cc:	01000202 	tsteq	r0, r2, lsl #4
 9d0:	00010301 	andeq	r0, r1, r1, lsl #6
 9d4:	fd000300 	stc2	3, cr0, [r0, #-0]
 9d8:	02000000 	andeq	r0, r0, #0
 9dc:	0d0efb01 	vstreq	d15, [lr, #-4]
 9e0:	01010100 	mrseq	r0, (UNDEF: 17)
 9e4:	00000001 	andeq	r0, r0, r1
 9e8:	01000001 	tsteq	r0, r1
 9ec:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 9f0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 9f4:	2f2e2e2f 	svccs	0x002e2e2f
 9f8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 9fc:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
 a00:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 a04:	2f2e2e2f 	svccs	0x002e2e2f
 a08:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 a0c:	00656475 	rsbeq	r6, r5, r5, ror r4
 a10:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 a14:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 a18:	2f2e2e2f 	svccs	0x002e2e2f
 a1c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 a20:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
 a24:	2f2e2e00 	svccs	0x002e2e00
 a28:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 a2c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 a30:	2f2e2e2f 	svccs	0x002e2e2f
 a34:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 984 <shift+0x984>
 a38:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 a3c:	2e2e2f63 	cdpcs	15, 2, cr2, cr14, cr3, {3}
 a40:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
 a44:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
 a48:	2f676966 	svccs	0x00676966
 a4c:	006d7261 	rsbeq	r7, sp, r1, ror #4
 a50:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 a54:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 a58:	2f2e2e2f 	svccs	0x002e2e2f
 a5c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 a60:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
 a64:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 a68:	61680000 	cmnvs	r8, r0
 a6c:	61746873 	cmnvs	r4, r3, ror r8
 a70:	00682e62 	rsbeq	r2, r8, r2, ror #28
 a74:	61000001 	tstvs	r0, r1
 a78:	692d6d72 	pushvs	{r1, r4, r5, r6, r8, sl, fp, sp, lr}
 a7c:	682e6173 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, sp, lr}
 a80:	00000200 	andeq	r0, r0, r0, lsl #4
 a84:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
 a88:	2e757063 	cdpcs	0, 7, cr7, cr5, cr3, {3}
 a8c:	00020068 	andeq	r0, r2, r8, rrx
 a90:	736e6900 	cmnvc	lr, #0, 18
 a94:	6f632d6e 	svcvs	0x00632d6e
 a98:	6174736e 	cmnvs	r4, lr, ror #6
 a9c:	2e73746e 	cdpcs	4, 7, cr7, cr3, cr14, {3}
 aa0:	00020068 	andeq	r0, r2, r8, rrx
 aa4:	6d726100 	ldfvse	f6, [r2, #-0]
 aa8:	0300682e 	movweq	r6, #2094	; 0x82e
 aac:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
 ab0:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 ab4:	00682e32 	rsbeq	r2, r8, r2, lsr lr
 ab8:	67000004 	strvs	r0, [r0, -r4]
 abc:	632d6c62 			; <UNDEFINED> instruction: 0x632d6c62
 ac0:	73726f74 	cmnvc	r2, #116, 30	; 0x1d0
 ac4:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
 ac8:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
 acc:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 ad0:	00632e32 	rsbeq	r2, r3, r2, lsr lr
 ad4:	00000004 	andeq	r0, r0, r4

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
      58:	1ca50704 	stcne	7, cr0, [r5], #16
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
      b0:	0b010000 	bleq	400b8 <__bss_end+0x371a4>
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
     11c:	1ca50704 	stcne	7, cr0, [r5], #16
     120:	72080000 	andvc	r0, r8, #0
     124:	01000003 	tsteq	r0, r3
     128:	00441533 	subeq	r1, r4, r3, lsr r5
     12c:	4a080000 	bmi	200134 <__bss_end+0x1f7220>
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
     15c:	3a010000 	bcc	40164 <__bss_end+0x37250>
     160:	00007615 	andeq	r7, r0, r5, lsl r6
     164:	01af0900 			; <UNDEFINED> instruction: 0x01af0900
     168:	48010000 	stmdami	r1, {}	; <UNPREDICTABLE>
     16c:	0000cb10 	andeq	ip, r0, r0, lsl fp
     170:	0081e000 	addeq	lr, r1, r0
     174:	00005800 	andeq	r5, r0, r0, lsl #16
     178:	cb9c0100 	blgt	fe700580 <__bss_end+0xfe6f766c>
     17c:	0a000000 	beq	184 <shift+0x184>
     180:	000001bd 			; <UNDEFINED> instruction: 0x000001bd
     184:	d20c4a01 	andle	r4, ip, #4096	; 0x1000
     188:	02000000 	andeq	r0, r0, #0
     18c:	0b007491 	bleq	1d3d8 <__bss_end+0x144c4>
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
     200:	2a0c9c01 	bcs	32720c <__bss_end+0x31e2f8>
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
     254:	cb110a01 	blgt	442a60 <__bss_end+0x439b4c>
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
     2bc:	0a010067 	beq	40460 <__bss_end+0x3754c>
     2c0:	00019e2f 	andeq	r9, r1, pc, lsr #28
     2c4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     2c8:	0e030000 	cdpeq	0, 0, cr0, cr3, cr0, {0}
     2cc:	00040000 	andeq	r0, r4, r0
     2d0:	000001c6 	andeq	r0, r0, r6, asr #3
     2d4:	02450104 	subeq	r0, r5, #4, 2
     2d8:	f0040000 			; <UNDEFINED> instruction: 0xf0040000
     2dc:	31000005 	tstcc	r0, r5
     2e0:	38000000 	stmdacc	r0, {}	; <UNPREDICTABLE>
     2e4:	dc000082 	stcle	0, cr0, [r0], {130}	; 0x82
     2e8:	e1000000 	mrs	r0, (UNDEF: 0)
     2ec:	02000001 	andeq	r0, r0, #1
     2f0:	0d5c0801 	ldcleq	8, cr0, [ip, #-4]
     2f4:	25030000 	strcs	r0, [r3, #-0]
     2f8:	02000000 	andeq	r0, r0, #0
     2fc:	0dd00502 	cfldr64eq	mvdx0, [r0, #8]
     300:	04040000 	streq	r0, [r4], #-0
     304:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
     308:	08010200 	stmdaeq	r1, {r9}
     30c:	00000d53 	andeq	r0, r0, r3, asr sp
     310:	cc070202 	sfmgt	f0, 4, [r7], {2}
     314:	05000009 	streq	r0, [r0, #-9]
     318:	00000e74 	andeq	r0, r0, r4, ror lr
     31c:	5e070903 	vmlapl.f16	s0, s14, s6	; <UNPREDICTABLE>
     320:	03000000 	movweq	r0, #0
     324:	0000004d 	andeq	r0, r0, sp, asr #32
     328:	a5070402 	strge	r0, [r7, #-1026]	; 0xfffffbfe
     32c:	0300001c 	movweq	r0, #28
     330:	0000005e 	andeq	r0, r0, lr, asr r0
     334:	00005e06 	andeq	r5, r0, r6, lsl #28
     338:	07520700 	ldrbeq	r0, [r2, -r0, lsl #14]
     33c:	02080000 	andeq	r0, r8, #0
     340:	00950806 	addseq	r0, r5, r6, lsl #16
     344:	72080000 	andvc	r0, r8, #0
     348:	08020030 	stmdaeq	r2, {r4, r5}
     34c:	00004d0e 	andeq	r4, r0, lr, lsl #26
     350:	72080000 	andvc	r0, r8, #0
     354:	09020031 	stmdbeq	r2, {r0, r4, r5}
     358:	00004d0e 	andeq	r4, r0, lr, lsl #26
     35c:	09000400 	stmdbeq	r0, {sl}
     360:	00000585 	andeq	r0, r0, r5, lsl #11
     364:	00380405 	eorseq	r0, r8, r5, lsl #8
     368:	1e020000 	cdpne	0, 0, cr0, cr2, cr0, {0}
     36c:	0000cc0c 	andeq	ip, r0, ip, lsl #24
     370:	08070a00 	stmdaeq	r7, {r9, fp}
     374:	0a000000 	beq	37c <shift+0x37c>
     378:	0000128a 	andeq	r1, r0, sl, lsl #5
     37c:	12540a01 	subsne	r0, r4, #4096	; 0x1000
     380:	0a020000 	beq	80388 <__bss_end+0x77474>
     384:	00000a6e 	andeq	r0, r0, lr, ror #20
     388:	0cb90a03 	vldmiaeq	r9!, {s0-s2}
     38c:	0a040000 	beq	100394 <__bss_end+0xf7480>
     390:	000007d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     394:	3c090005 	stccc	0, cr0, [r9], {5}
     398:	05000011 	streq	r0, [r0, #-17]	; 0xffffffef
     39c:	00003804 	andeq	r3, r0, r4, lsl #16
     3a0:	0c3f0200 	lfmeq	f0, 4, [pc], #-0	; 3a8 <shift+0x3a8>
     3a4:	00000109 	andeq	r0, r0, r9, lsl #2
     3a8:	00041d0a 	andeq	r1, r4, sl, lsl #26
     3ac:	c10a0000 	mrsgt	r0, (UNDEF: 10)
     3b0:	01000005 	tsteq	r0, r5
     3b4:	000c740a 	andeq	r7, ip, sl, lsl #8
     3b8:	050a0200 	streq	r0, [sl, #-512]	; 0xfffffe00
     3bc:	03000012 	movweq	r0, #18
     3c0:	0012940a 	andseq	r9, r2, sl, lsl #8
     3c4:	8e0a0400 	cfcpyshi	mvf0, mvf10
     3c8:	0500000b 	streq	r0, [r0, #-11]
     3cc:	0009ec0a 	andeq	lr, r9, sl, lsl #24
     3d0:	09000600 	stmdbeq	r0, {r9, sl}
     3d4:	000010f6 	strdeq	r1, [r0], -r6
     3d8:	00380405 	eorseq	r0, r8, r5, lsl #8
     3dc:	66020000 	strvs	r0, [r2], -r0
     3e0:	0001340c 	andeq	r3, r1, ip, lsl #8
     3e4:	0d310a00 	vldmdbeq	r1!, {s0-s-1}
     3e8:	0a000000 	beq	3f0 <shift+0x3f0>
     3ec:	000009ae 	andeq	r0, r0, lr, lsr #19
     3f0:	0dda0a01 	vldreq	s1, [sl, #4]
     3f4:	0a020000 	beq	803fc <__bss_end+0x774e8>
     3f8:	000009f1 	strdeq	r0, [r0], -r1
     3fc:	49050003 	stmdbmi	r5, {r0, r1}
     400:	04000006 	streq	r0, [r0], #-6
     404:	00380703 	eorseq	r0, r8, r3, lsl #14
     408:	e60b0000 	str	r0, [fp], -r0
     40c:	0400000b 	streq	r0, [r0], #-11
     410:	00591405 	subseq	r1, r9, r5, lsl #8
     414:	03050000 	movweq	r0, #20480	; 0x5000
     418:	00008e38 	andeq	r8, r0, r8, lsr lr
     41c:	000c2c0b 	andeq	r2, ip, fp, lsl #24
     420:	14060400 	strne	r0, [r6], #-1024	; 0xfffffc00
     424:	00000059 	andeq	r0, r0, r9, asr r0
     428:	8e3c0305 	cdphi	3, 3, cr0, cr12, cr5, {0}
     42c:	780b0000 	stmdavc	fp, {}	; <UNPREDICTABLE>
     430:	0500000b 	streq	r0, [r0, #-11]
     434:	00591a07 	subseq	r1, r9, r7, lsl #20
     438:	03050000 	movweq	r0, #20480	; 0x5000
     43c:	00008e40 	andeq	r8, r0, r0, asr #28
     440:	0004d50b 	andeq	sp, r4, fp, lsl #10
     444:	1a090500 	bne	24184c <__bss_end+0x238938>
     448:	00000059 	andeq	r0, r0, r9, asr r0
     44c:	8e440305 	cdphi	3, 4, cr0, cr4, cr5, {0}
     450:	450b0000 	strmi	r0, [fp, #-0]
     454:	0500000d 	streq	r0, [r0, #-13]
     458:	00591a0b 	subseq	r1, r9, fp, lsl #20
     45c:	03050000 	movweq	r0, #20480	; 0x5000
     460:	00008e48 	andeq	r8, r0, r8, asr #28
     464:	00099b0b 	andeq	r9, r9, fp, lsl #22
     468:	1a0d0500 	bne	341870 <__bss_end+0x33895c>
     46c:	00000059 	andeq	r0, r0, r9, asr r0
     470:	8e4c0305 	cdphi	3, 4, cr0, cr12, cr5, {0}
     474:	780b0000 	stmdavc	fp, {}	; <UNPREDICTABLE>
     478:	05000007 	streq	r0, [r0, #-7]
     47c:	00591a0f 	subseq	r1, r9, pc, lsl #20
     480:	03050000 	movweq	r0, #20480	; 0x5000
     484:	00008e50 	andeq	r8, r0, r0, asr lr
     488:	000ed409 	andeq	sp, lr, r9, lsl #8
     48c:	38040500 	stmdacc	r4, {r8, sl}
     490:	05000000 	streq	r0, [r0, #-0]
     494:	01e30c1b 	mvneq	r0, fp, lsl ip
     498:	400a0000 	andmi	r0, sl, r0
     49c:	0000000f 	andeq	r0, r0, pc
     4a0:	0012440a 	andseq	r4, r2, sl, lsl #8
     4a4:	6f0a0100 	svcvs	0x000a0100
     4a8:	0200000c 	andeq	r0, r0, #12
     4ac:	0d160c00 	ldceq	12, cr0, [r6, #-0]
     4b0:	b50d0000 	strlt	r0, [sp, #-0]
     4b4:	9000000d 	andls	r0, r0, sp
     4b8:	56076305 	strpl	r6, [r7], -r5, lsl #6
     4bc:	07000003 	streq	r0, [r0, -r3]
     4c0:	000011a7 	andeq	r1, r0, r7, lsr #3
     4c4:	10670524 	rsbne	r0, r7, r4, lsr #10
     4c8:	00000270 	andeq	r0, r0, r0, ror r2
     4cc:	0020150e 	eoreq	r1, r0, lr, lsl #10
     4d0:	12690500 	rsbne	r0, r9, #0, 10
     4d4:	00000356 	andeq	r0, r0, r6, asr r3
     4d8:	05790e00 	ldrbeq	r0, [r9, #-3584]!	; 0xfffff200
     4dc:	6b050000 	blvs	1404e4 <__bss_end+0x1375d0>
     4e0:	00036612 	andeq	r6, r3, r2, lsl r6
     4e4:	350e1000 	strcc	r1, [lr, #-0]
     4e8:	0500000f 	streq	r0, [r0, #-15]
     4ec:	004d166d 	subeq	r1, sp, sp, ror #12
     4f0:	0e140000 	cdpeq	0, 1, cr0, cr4, cr0, {0}
     4f4:	000005e9 	andeq	r0, r0, r9, ror #11
     4f8:	6d1c7005 	ldcvs	0, cr7, [ip, #-20]	; 0xffffffec
     4fc:	18000003 	stmdane	r0, {r0, r1}
     500:	000d3c0e 	andeq	r3, sp, lr, lsl #24
     504:	1c720500 	cfldr64ne	mvdx0, [r2], #-0
     508:	0000036d 	andeq	r0, r0, sp, ror #6
     50c:	054d0e1c 	strbeq	r0, [sp, #-3612]	; 0xfffff1e4
     510:	75050000 	strvc	r0, [r5, #-0]
     514:	00036d1c 	andeq	r6, r3, ip, lsl sp
     518:	190f2000 	stmdbne	pc, {sp}	; <UNPREDICTABLE>
     51c:	05000008 	streq	r0, [r0, #-8]
     520:	04691c77 	strbteq	r1, [r9], #-3191	; 0xfffff389
     524:	036d0000 	cmneq	sp, #0
     528:	02640000 	rsbeq	r0, r4, #0
     52c:	6d100000 	ldcvs	0, cr0, [r0, #-0]
     530:	11000003 	tstne	r0, r3
     534:	00000373 	andeq	r0, r0, r3, ror r3
     538:	8d070000 	stchi	0, cr0, [r7, #-0]
     53c:	18000006 	stmdane	r0, {r1, r2}
     540:	a5107b05 	ldrge	r7, [r0, #-2821]	; 0xfffff4fb
     544:	0e000002 	cdpeq	0, 0, cr0, cr0, cr2, {0}
     548:	00002015 	andeq	r2, r0, r5, lsl r0
     54c:	56127e05 	ldrpl	r7, [r2], -r5, lsl #28
     550:	00000003 	andeq	r0, r0, r3
     554:	00056e0e 	andeq	r6, r5, lr, lsl #28
     558:	19800500 	stmibne	r0, {r8, sl}
     55c:	00000373 	andeq	r0, r0, r3, ror r3
     560:	120b0e10 	andne	r0, fp, #16, 28	; 0x100
     564:	82050000 	andhi	r0, r5, #0
     568:	00037e21 	andeq	r7, r3, r1, lsr #28
     56c:	03001400 	movweq	r1, #1024	; 0x400
     570:	00000270 	andeq	r0, r0, r0, ror r2
     574:	000b2212 	andeq	r2, fp, r2, lsl r2
     578:	21860500 	orrcs	r0, r6, r0, lsl #10
     57c:	00000384 	andeq	r0, r0, r4, lsl #7
     580:	0008ce12 	andeq	ip, r8, r2, lsl lr
     584:	1f880500 	svcne	0x00880500
     588:	00000059 	andeq	r0, r0, r9, asr r0
     58c:	000e180e 	andeq	r1, lr, lr, lsl #16
     590:	178b0500 	strne	r0, [fp, r0, lsl #10]
     594:	000001f5 	strdeq	r0, [r0], -r5
     598:	0a740e00 	beq	1d03da0 <__bss_end+0x1cfae8c>
     59c:	8e050000 	cdphi	0, 0, cr0, cr5, cr0, {0}
     5a0:	0001f517 	andeq	pc, r1, r7, lsl r5	; <UNPREDICTABLE>
     5a4:	390e2400 	stmdbcc	lr, {sl, sp}
     5a8:	05000009 	streq	r0, [r0, #-9]
     5ac:	01f5178f 	mvnseq	r1, pc, lsl #15
     5b0:	0e480000 	cdpeq	0, 4, cr0, cr8, cr0, {0}
     5b4:	00001274 	andeq	r1, r0, r4, ror r2
     5b8:	f5179005 			; <UNDEFINED> instruction: 0xf5179005
     5bc:	6c000001 	stcvs	0, cr0, [r0], {1}
     5c0:	000db513 	andeq	fp, sp, r3, lsl r5
     5c4:	09930500 	ldmibeq	r3, {r8, sl}
     5c8:	00000678 	andeq	r0, r0, r8, ror r6
     5cc:	0000038f 	andeq	r0, r0, pc, lsl #7
     5d0:	00030f01 	andeq	r0, r3, r1, lsl #30
     5d4:	00031500 	andeq	r1, r3, r0, lsl #10
     5d8:	038f1000 	orreq	r1, pc, #0
     5dc:	14000000 	strne	r0, [r0], #-0
     5e0:	00000b17 	andeq	r0, r0, r7, lsl fp
     5e4:	2a0e9605 	bcs	3a5e00 <__bss_end+0x39ceec>
     5e8:	0100000a 	tsteq	r0, sl
     5ec:	0000032a 	andeq	r0, r0, sl, lsr #6
     5f0:	00000330 	andeq	r0, r0, r0, lsr r3
     5f4:	00038f10 	andeq	r8, r3, r0, lsl pc
     5f8:	1d150000 	ldcne	0, cr0, [r5, #-0]
     5fc:	05000004 	streq	r0, [r0, #-4]
     600:	0eb91099 	mrceq	0, 5, r1, cr9, cr9, {4}
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
     630:	7e020102 	adfvcs	f0, f2, f2
     634:	1800000a 	stmdane	r0, {r1, r3}
     638:	0001f504 	andeq	pc, r1, r4, lsl #10
     63c:	2c041800 	stccs	8, cr1, [r4], {-0}
     640:	0c000000 	stceq	0, cr0, [r0], {-0}
     644:	00001217 	andeq	r1, r0, r7, lsl r2
     648:	03790418 	cmneq	r9, #24, 8	; 0x18000000
     64c:	a5160000 	ldrge	r0, [r6, #-0]
     650:	8f000002 	svchi	0x00000002
     654:	19000003 	stmdbne	r0, {r0, r1}
     658:	e8041800 	stmda	r4, {fp, ip}
     65c:	18000001 	stmdane	r0, {r0}
     660:	0001e304 	andeq	lr, r1, r4, lsl #6
     664:	0e1e1a00 	vnmlseq.f32	s2, s28, s0
     668:	9c050000 	stcls	0, cr0, [r5], {-0}
     66c:	0001e814 	andeq	lr, r1, r4, lsl r8
     670:	087a0b00 	ldmdaeq	sl!, {r8, r9, fp}^
     674:	04060000 	streq	r0, [r6], #-0
     678:	00005914 	andeq	r5, r0, r4, lsl r9
     67c:	54030500 	strpl	r0, [r3], #-1280	; 0xfffffb00
     680:	0b00008e 	bleq	8c0 <shift+0x8c0>
     684:	000003a8 	andeq	r0, r0, r8, lsr #7
     688:	59140706 	ldmdbpl	r4, {r1, r2, r8, r9, sl}
     68c:	05000000 	streq	r0, [r0, #-0]
     690:	008e5803 	addeq	r5, lr, r3, lsl #16
     694:	06540b00 	ldrbeq	r0, [r4], -r0, lsl #22
     698:	0a060000 	beq	1806a0 <__bss_end+0x17778c>
     69c:	00005914 	andeq	r5, r0, r4, lsl r9
     6a0:	5c030500 	cfstr32pl	mvfx0, [r3], {-0}
     6a4:	0900008e 	stmdbeq	r0, {r1, r2, r3, r7}
     6a8:	00000ae7 	andeq	r0, r0, r7, ror #21
     6ac:	00380405 	eorseq	r0, r8, r5, lsl #8
     6b0:	0d060000 	stceq	0, cr0, [r6, #-0]
     6b4:	0004140c 	andeq	r1, r4, ip, lsl #8
     6b8:	654e1b00 	strbvs	r1, [lr, #-2816]	; 0xfffff500
     6bc:	0a000077 	beq	8a0 <shift+0x8a0>
     6c0:	00000ade 	ldrdeq	r0, [r0], -lr
     6c4:	0e300a01 	vaddeq.f32	s0, s0, s2
     6c8:	0a020000 	beq	806d0 <__bss_end+0x777bc>
     6cc:	00000a99 	muleq	r0, r9, sl
     6d0:	0a600a03 	beq	1802ee4 <__bss_end+0x17f9fd0>
     6d4:	0a040000 	beq	1006dc <__bss_end+0xf77c8>
     6d8:	00000c7a 	andeq	r0, r0, sl, ror ip
     6dc:	c3070005 	movwgt	r0, #28677	; 0x7005
     6e0:	10000007 	andne	r0, r0, r7
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
     710:	000007d9 	ldrdeq	r0, [r0], -r9
     714:	53132006 	tstpl	r3, #6
     718:	0c000004 	stceq	0, cr0, [r0], {4}
     71c:	07040200 	streq	r0, [r4, -r0, lsl #4]
     720:	00001ca0 	andeq	r1, r0, r0, lsr #25
     724:	00045303 	andeq	r5, r4, r3, lsl #6
     728:	045c0700 	ldrbeq	r0, [ip], #-1792	; 0xfffff900
     72c:	06700000 	ldrbteq	r0, [r0], -r0
     730:	04ef0828 	strbteq	r0, [pc], #2088	; 738 <shift+0x738>
     734:	7e0e0000 	cdpvc	0, 0, cr0, cr14, cr0, {0}
     738:	06000012 			; <UNDEFINED> instruction: 0x06000012
     73c:	0414122a 	ldreq	r1, [r4], #-554	; 0xfffffdd6
     740:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
     744:	00646970 	rsbeq	r6, r4, r0, ror r9
     748:	5e122b06 	vnmlspl.f64	d2, d2, d6
     74c:	10000000 	andne	r0, r0, r0
     750:	0019f10e 	andseq	pc, r9, lr, lsl #2
     754:	112c0600 			; <UNDEFINED> instruction: 0x112c0600
     758:	000003dd 	ldrdeq	r0, [r0], -sp
     75c:	0af30e14 	beq	ffcc3fb4 <__bss_end+0xffcbb0a0>
     760:	2d060000 	stccs	0, cr0, [r6, #-0]
     764:	00005e12 	andeq	r5, r0, r2, lsl lr
     768:	010e1800 	tsteq	lr, r0, lsl #16
     76c:	0600000b 	streq	r0, [r0], -fp
     770:	005e122e 	subseq	r1, lr, lr, lsr #4
     774:	0e1c0000 	cdpeq	0, 1, cr0, cr12, cr0, {0}
     778:	0000076b 	andeq	r0, r0, fp, ror #14
     77c:	ef0c2f06 	svc	0x000c2f06
     780:	20000004 	andcs	r0, r0, r4
     784:	000b2e0e 	andeq	r2, fp, lr, lsl #28
     788:	09300600 	ldmdbeq	r0!, {r9, sl}
     78c:	00000038 	andeq	r0, r0, r8, lsr r0
     790:	0f4a0e60 	svceq	0x004a0e60
     794:	31060000 	mrscc	r0, (UNDEF: 6)
     798:	00004d0e 	andeq	r4, r0, lr, lsl #26
     79c:	2d0e6400 	cfstrscs	mvf6, [lr, #-0]
     7a0:	06000008 	streq	r0, [r0], -r8
     7a4:	004d0e33 	subeq	r0, sp, r3, lsr lr
     7a8:	0e680000 	cdpeq	0, 6, cr0, cr8, cr0, {0}
     7ac:	00000824 	andeq	r0, r0, r4, lsr #16
     7b0:	4d0e3406 	cfstrsmi	mvf3, [lr, #-24]	; 0xffffffe8
     7b4:	6c000000 	stcvs	0, cr0, [r0], {-0}
     7b8:	03951600 	orrseq	r1, r5, #0, 12
     7bc:	04ff0000 	ldrbteq	r0, [pc], #0	; 7c4 <shift+0x7c4>
     7c0:	5e170000 	cdppl	0, 1, cr0, cr7, cr0, {0}
     7c4:	0f000000 	svceq	0x00000000
     7c8:	11980b00 	orrsne	r0, r8, r0, lsl #22
     7cc:	0a070000 	beq	1c07d4 <__bss_end+0x1b78c0>
     7d0:	00005914 	andeq	r5, r0, r4, lsl r9
     7d4:	60030500 	andvs	r0, r3, r0, lsl #10
     7d8:	0900008e 	stmdbeq	r0, {r1, r2, r3, r7}
     7dc:	00000aa1 	andeq	r0, r0, r1, lsr #21
     7e0:	00380405 	eorseq	r0, r8, r5, lsl #8
     7e4:	0d070000 	stceq	0, cr0, [r7, #-0]
     7e8:	0005300c 	andeq	r3, r5, ip
     7ec:	059a0a00 	ldreq	r0, [sl, #2560]	; 0xa00
     7f0:	0a000000 	beq	7f8 <shift+0x7f8>
     7f4:	0000039d 	muleq	r0, sp, r3
     7f8:	3e070001 	cdpcc	0, 0, cr0, cr7, cr1, {0}
     7fc:	0c000010 	stceq	0, cr0, [r0], {16}
     800:	65081b07 	strvs	r1, [r8, #-2823]	; 0xfffff4f9
     804:	0e000005 	cdpeq	0, 0, cr0, cr0, cr5, {0}
     808:	0000042e 	andeq	r0, r0, lr, lsr #8
     80c:	65191d07 	ldrvs	r1, [r9, #-3335]	; 0xfffff2f9
     810:	00000005 	andeq	r0, r0, r5
     814:	00054d0e 	andeq	r4, r5, lr, lsl #26
     818:	191e0700 	ldmdbne	lr, {r8, r9, sl}
     81c:	00000565 	andeq	r0, r0, r5, ror #10
     820:	0fbe0e04 	svceq	0x00be0e04
     824:	1f070000 	svcne	0x00070000
     828:	00056b13 	andeq	r6, r5, r3, lsl fp
     82c:	18000800 	stmdane	r0, {fp}
     830:	00053004 	andeq	r3, r5, r4
     834:	5f041800 	svcpl	0x00041800
     838:	0d000004 	stceq	0, cr0, [r0, #-16]
     83c:	00000667 	andeq	r0, r0, r7, ror #12
     840:	07220714 			; <UNDEFINED> instruction: 0x07220714
     844:	000007f3 	strdeq	r0, [r0], -r3
     848:	000a8f0e 	andeq	r8, sl, lr, lsl #30
     84c:	12260700 	eorne	r0, r6, #0, 14
     850:	0000004d 	andeq	r0, r0, sp, asr #32
     854:	04e70e00 	strbteq	r0, [r7], #3584	; 0xe00
     858:	29070000 	stmdbcs	r7, {}	; <UNPREDICTABLE>
     85c:	0005651d 	andeq	r6, r5, sp, lsl r5
     860:	a60e0400 	strge	r0, [lr], -r0, lsl #8
     864:	0700000e 	streq	r0, [r0, -lr]
     868:	05651d2c 	strbeq	r1, [r5, #-3372]!	; 0xfffff2d4
     86c:	1c080000 	stcne	0, cr0, [r8], {-0}
     870:	00001132 	andeq	r1, r0, r2, lsr r1
     874:	1b0e2f07 	blne	38c498 <__bss_end+0x383584>
     878:	b9000010 	stmdblt	r0, {r4}
     87c:	c4000005 	strgt	r0, [r0], #-5
     880:	10000005 	andne	r0, r0, r5
     884:	000007f8 	strdeq	r0, [r0], -r8
     888:	00056511 	andeq	r6, r5, r1, lsl r5
     88c:	d41d0000 	ldrle	r0, [sp], #-0
     890:	0700000f 	streq	r0, [r0, -pc]
     894:	04330e31 	ldrteq	r0, [r3], #-3633	; 0xfffff1cf
     898:	03660000 	cmneq	r6, #0
     89c:	05dc0000 	ldrbeq	r0, [ip]
     8a0:	05e70000 	strbeq	r0, [r7, #0]!
     8a4:	f8100000 			; <UNDEFINED> instruction: 0xf8100000
     8a8:	11000007 	tstne	r0, r7
     8ac:	0000056b 	andeq	r0, r0, fp, ror #10
     8b0:	10801300 	addne	r1, r0, r0, lsl #6
     8b4:	35070000 	strcc	r0, [r7, #-0]
     8b8:	000f991d 	andeq	r9, pc, sp, lsl r9	; <UNPREDICTABLE>
     8bc:	00056500 	andeq	r6, r5, r0, lsl #10
     8c0:	06000200 	streq	r0, [r0], -r0, lsl #4
     8c4:	06060000 	streq	r0, [r6], -r0
     8c8:	f8100000 			; <UNDEFINED> instruction: 0xf8100000
     8cc:	00000007 	andeq	r0, r0, r7
     8d0:	0009df13 	andeq	sp, r9, r3, lsl pc
     8d4:	1d370700 	ldcne	7, cr0, [r7, #-0]
     8d8:	00000d8f 	andeq	r0, r0, pc, lsl #27
     8dc:	00000565 	andeq	r0, r0, r5, ror #10
     8e0:	00061f02 	andeq	r1, r6, r2, lsl #30
     8e4:	00062500 	andeq	r2, r6, r0, lsl #10
     8e8:	07f81000 	ldrbeq	r1, [r8, r0]!
     8ec:	1e000000 	cdpne	0, 0, cr0, cr0, cr0, {0}
     8f0:	00000b5e 	andeq	r0, r0, lr, asr fp
     8f4:	11313907 	teqne	r1, r7, lsl #18
     8f8:	0c000008 	stceq	0, cr0, [r0], {8}
     8fc:	06671302 	strbteq	r1, [r7], -r2, lsl #6
     900:	3c070000 	stccc	0, cr0, [r7], {-0}
     904:	00125a09 	andseq	r5, r2, r9, lsl #20
     908:	0007f800 	andeq	pc, r7, r0, lsl #16
     90c:	064c0100 	strbeq	r0, [ip], -r0, lsl #2
     910:	06520000 	ldrbeq	r0, [r2], -r0
     914:	f8100000 			; <UNDEFINED> instruction: 0xf8100000
     918:	00000007 	andeq	r0, r0, r7
     91c:	0005d413 	andeq	sp, r5, r3, lsl r4
     920:	123f0700 	eorsne	r0, pc, #0, 14
     924:	00001107 	andeq	r1, r0, r7, lsl #2
     928:	0000004d 	andeq	r0, r0, sp, asr #32
     92c:	00066b01 	andeq	r6, r6, r1, lsl #22
     930:	00068000 	andeq	r8, r6, r0
     934:	07f81000 	ldrbeq	r1, [r8, r0]!
     938:	1a110000 	bne	440940 <__bss_end+0x437a2c>
     93c:	11000008 	tstne	r0, r8
     940:	0000005e 	andeq	r0, r0, lr, asr r0
     944:	00036611 	andeq	r6, r3, r1, lsl r6
     948:	e3140000 	tst	r4, #0
     94c:	0700000f 	streq	r0, [r0, -pc]
     950:	0cc80e42 	stcleq	14, cr0, [r8], {66}	; 0x42
     954:	95010000 	strls	r0, [r1, #-0]
     958:	9b000006 	blls	978 <shift+0x978>
     95c:	10000006 	andne	r0, r0, r6
     960:	000007f8 	strdeq	r0, [r0], -r8
     964:	09431300 	stmdbeq	r3, {r8, r9, ip}^
     968:	45070000 	strmi	r0, [r7, #-0]
     96c:	00050c17 	andeq	r0, r5, r7, lsl ip
     970:	00056b00 	andeq	r6, r5, r0, lsl #22
     974:	06b40100 	ldrteq	r0, [r4], r0, lsl #2
     978:	06ba0000 	ldrteq	r0, [sl], r0
     97c:	20100000 	andscs	r0, r0, r0
     980:	00000008 	andeq	r0, r0, r8
     984:	00055b13 	andeq	r5, r5, r3, lsl fp
     988:	17480700 	strbne	r0, [r8, -r0, lsl #14]
     98c:	00000f56 	andeq	r0, r0, r6, asr pc
     990:	0000056b 	andeq	r0, r0, fp, ror #10
     994:	0006d301 	andeq	sp, r6, r1, lsl #6
     998:	0006de00 	andeq	sp, r6, r0, lsl #28
     99c:	08201000 	stmdaeq	r0!, {ip}
     9a0:	4d110000 	ldcmi	0, cr0, [r1, #-0]
     9a4:	00000000 	andeq	r0, r0, r0
     9a8:	0011b514 	andseq	fp, r1, r4, lsl r5
     9ac:	0e4b0700 	cdpeq	7, 4, cr0, cr11, cr0, {0}
     9b0:	00000fec 	andeq	r0, r0, ip, ror #31
     9b4:	0006f301 	andeq	pc, r6, r1, lsl #6
     9b8:	0006f900 	andeq	pc, r6, r0, lsl #18
     9bc:	07f81000 	ldrbeq	r1, [r8, r0]!
     9c0:	13000000 	movwne	r0, #0
     9c4:	00000fd4 	ldrdeq	r0, [r0], -r4
     9c8:	df0e4d07 	svcle	0x000e4d07
     9cc:	66000007 	strvs	r0, [r0], -r7
     9d0:	01000003 	tsteq	r0, r3
     9d4:	00000712 	andeq	r0, r0, r2, lsl r7
     9d8:	0000071d 	andeq	r0, r0, sp, lsl r7
     9dc:	0007f810 	andeq	pc, r7, r0, lsl r8	; <UNPREDICTABLE>
     9e0:	004d1100 	subeq	r1, sp, r0, lsl #2
     9e4:	13000000 	movwne	r0, #0
     9e8:	00000957 	andeq	r0, r0, r7, asr r9
     9ec:	e9125007 	ldmdb	r2, {r0, r1, r2, ip, lr}
     9f0:	4d00000c 	stcmi	0, cr0, [r0, #-48]	; 0xffffffd0
     9f4:	01000000 	mrseq	r0, (UNDEF: 0)
     9f8:	00000736 	andeq	r0, r0, r6, lsr r7
     9fc:	00000741 	andeq	r0, r0, r1, asr #14
     a00:	0007f810 	andeq	pc, r7, r0, lsl r8	; <UNPREDICTABLE>
     a04:	03951100 	orrseq	r1, r5, #0, 2
     a08:	13000000 	movwne	r0, #0
     a0c:	00000499 	muleq	r0, r9, r4
     a10:	930e5307 	movwls	r5, #58119	; 0xe307
     a14:	66000008 	strvs	r0, [r0], -r8
     a18:	01000003 	tsteq	r0, r3
     a1c:	0000075a 	andeq	r0, r0, sl, asr r7
     a20:	00000765 	andeq	r0, r0, r5, ror #14
     a24:	0007f810 	andeq	pc, r7, r0, lsl r8	; <UNPREDICTABLE>
     a28:	004d1100 	subeq	r1, sp, r0, lsl #2
     a2c:	14000000 	strne	r0, [r0], #-0
     a30:	000009b9 			; <UNDEFINED> instruction: 0x000009b9
     a34:	9f0e5607 	svcls	0x000e5607
     a38:	01000010 	tsteq	r0, r0, lsl r0
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
     a64:	00000f83 	andeq	r0, r0, r3, lsl #31
     a68:	060e5807 	streq	r5, [lr], -r7, lsl #16
     a6c:	01000007 	tsteq	r0, r7
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
     a98:	00000636 	andeq	r0, r0, r6, lsr r6
     a9c:	980e5b07 	stmdals	lr, {r0, r1, r2, r8, r9, fp, ip, lr}
     aa0:	66000006 	strvs	r0, [r0], -r6
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
     af8:	000b6c1a 	andeq	r6, fp, sl, lsl ip
     afc:	195e0700 	ldmdbne	lr, {r8, r9, sl}^
     b00:	00000571 	andeq	r0, r0, r1, ror r5
     b04:	6c616823 	stclvs	8, cr6, [r1], #-140	; 0xffffff74
     b08:	0b050800 	bleq	142b10 <__bss_end+0x139bfc>
     b0c:	000008f4 	strdeq	r0, [r0], -r4
     b10:	000b9524 	andeq	r9, fp, r4, lsr #10
     b14:	19070800 	stmdbne	r7, {fp}
     b18:	00000065 	andeq	r0, r0, r5, rrx
     b1c:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}
     b20:	000e0824 	andeq	r0, lr, r4, lsr #16
     b24:	1a0a0800 	bne	282b2c <__bss_end+0x279c18>
     b28:	0000045a 	andeq	r0, r0, sl, asr r4
     b2c:	20000000 	andcs	r0, r0, r0
     b30:	000bf424 	andeq	pc, fp, r4, lsr #8
     b34:	1a0d0800 	bne	342b3c <__bss_end+0x339c28>
     b38:	0000045a 	andeq	r0, r0, sl, asr r4
     b3c:	20200000 	eorcs	r0, r0, r0
     b40:	000dc125 	andeq	ip, sp, r5, lsr #2
     b44:	15100800 	ldrne	r0, [r0, #-2048]	; 0xfffff800
     b48:	00000059 	andeq	r0, r0, r9, asr r0
     b4c:	062d2436 			; <UNDEFINED> instruction: 0x062d2436
     b50:	42080000 	andmi	r0, r8, #0
     b54:	00045a1a 	andeq	r5, r4, sl, lsl sl
     b58:	21500000 	cmpcs	r0, r0
     b5c:	08362420 	ldmdaeq	r6!, {r5, sl, sp}
     b60:	71080000 	mrsvc	r0, (UNDEF: 8)
     b64:	00045a1a 	andeq	r5, r4, sl, lsl sl
     b68:	00b20000 	adcseq	r0, r2, r0
     b6c:	0e9b2420 	cdpeq	4, 9, cr2, cr11, cr0, {1}
     b70:	a4080000 	strge	r0, [r8], #-0
     b74:	00045a1a 	andeq	r5, r4, sl, lsl sl
     b78:	00b40000 	adcseq	r0, r4, r0
     b7c:	08bf2420 	ldmeq	pc!, {r5, sl, sp}	; <UNPREDICTABLE>
     b80:	b3080000 	movwlt	r0, #32768	; 0x8000
     b84:	00045a1a 	andeq	r5, r4, sl, lsl sl
     b88:	10400000 	subne	r0, r0, r0
     b8c:	080f2420 	stmdaeq	pc, {r5, sl, sp}	; <UNPREDICTABLE>
     b90:	be080000 	cdplt	0, 0, cr0, cr8, cr0, {0}
     b94:	00045a1a 	andeq	r5, r4, sl, lsl sl
     b98:	20500000 	subscs	r0, r0, r0
     b9c:	08702420 	ldmdaeq	r0!, {r5, sl, sp}^
     ba0:	bf080000 	svclt	0x00080000
     ba4:	00045a1a 	andeq	r5, r4, sl, lsl sl
     ba8:	80400000 	subhi	r0, r0, r0
     bac:	04cb2420 	strbeq	r2, [fp], #1056	; 0x420
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
     bf4:	0b380b00 	bleq	e037fc <__bss_end+0xdfa8e8>
     bf8:	08090000 	stmdaeq	r9, {}	; <UNPREDICTABLE>
     bfc:	00005914 	andeq	r5, r0, r4, lsl r9
     c00:	90030500 	andls	r0, r3, r0, lsl #10
     c04:	0900008e 	stmdbeq	r0, {r1, r2, r3, r7}
     c08:	00000caa 	andeq	r0, r0, sl, lsr #25
     c0c:	005e0407 	subseq	r0, lr, r7, lsl #8
     c10:	0b090000 	bleq	240c18 <__bss_end+0x237d04>
     c14:	0009860c 	andeq	r8, r9, ip, lsl #12
     c18:	0fce0a00 	svceq	0x00ce0a00
     c1c:	0a000000 	beq	c24 <shift+0xc24>
     c20:	00000c68 	andeq	r0, r0, r8, ror #24
     c24:	0ab60a01 	beq	fed83430 <__bss_end+0xfed7a51c>
     c28:	0a020000 	beq	80c30 <__bss_end+0x77d1c>
     c2c:	00000428 	andeq	r0, r0, r8, lsr #8
     c30:	04170a03 	ldreq	r0, [r7], #-2563	; 0xfffff5fd
     c34:	0a040000 	beq	100c3c <__bss_end+0xf7d28>
     c38:	00000a83 	andeq	r0, r0, r3, lsl #21
     c3c:	0a890a05 	beq	fe243458 <__bss_end+0xfe23a544>
     c40:	0a060000 	beq	180c48 <__bss_end+0x177d34>
     c44:	00000422 	andeq	r0, r0, r2, lsr #8
     c48:	12380a07 	eorsne	r0, r8, #28672	; 0x7000
     c4c:	00080000 	andeq	r0, r8, r0
     c50:	0003de09 	andeq	sp, r3, r9, lsl #28
     c54:	38040500 	stmdacc	r4, {r8, sl}
     c58:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     c5c:	09b10c1d 	ldmibeq	r1!, {r0, r2, r3, r4, sl, fp}
     c60:	2d0a0000 	stccs	0, cr0, [sl, #-0]
     c64:	00000009 	andeq	r0, r0, r9
     c68:	00075e0a 	andeq	r5, r7, sl, lsl #28
     c6c:	c90a0100 	stmdbgt	sl, {r8}
     c70:	02000008 	andeq	r0, r0, #8
     c74:	776f4c1b 			; <UNDEFINED> instruction: 0x776f4c1b
     c78:	0d000300 	stceq	3, cr0, [r0, #-0]
     c7c:	0000122a 	andeq	r1, r0, sl, lsr #4
     c80:	0728091c 			; <UNDEFINED> instruction: 0x0728091c
     c84:	00000d32 	andeq	r0, r0, r2, lsr sp
     c88:	0005c607 	andeq	ip, r5, r7, lsl #12
     c8c:	33091000 	movwcc	r1, #36864	; 0x9000
     c90:	000a000a 	andeq	r0, sl, sl
     c94:	0e6f0e00 	cdpeq	14, 6, cr0, cr15, cr0, {0}
     c98:	35090000 	strcc	r0, [r9, #-0]
     c9c:	0003950b 	andeq	r9, r3, fp, lsl #10
     ca0:	cb0e0000 	blgt	380ca8 <__bss_end+0x377d94>
     ca4:	09000011 	stmdbeq	r0, {r0, r4}
     ca8:	004d0d36 	subeq	r0, sp, r6, lsr sp
     cac:	0e040000 	cdpeq	0, 0, cr0, cr4, cr0, {0}
     cb0:	0000042e 	andeq	r0, r0, lr, lsr #8
     cb4:	37133709 	ldrcc	r3, [r3, -r9, lsl #14]
     cb8:	0800000d 	stmdaeq	r0, {r0, r2, r3}
     cbc:	00054d0e 	andeq	r4, r5, lr, lsl #26
     cc0:	13380900 	teqne	r8, #0, 18
     cc4:	00000d37 	andeq	r0, r0, r7, lsr sp
     cc8:	e30e000c 	movw	r0, #57356	; 0xe00c
     ccc:	09000005 	stmdbeq	r0, {r0, r2}
     cd0:	0d43202c 	stcleq	0, cr2, [r3, #-176]	; 0xffffff50
     cd4:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     cd8:	000005af 	andeq	r0, r0, pc, lsr #11
     cdc:	480c2f09 	stmdami	ip, {r0, r3, r8, r9, sl, fp, sp}
     ce0:	0400000d 	streq	r0, [r0], #-13
     ce4:	000c380e 	andeq	r3, ip, lr, lsl #16
     ce8:	0c310900 			; <UNDEFINED> instruction: 0x0c310900
     cec:	00000d48 	andeq	r0, r0, r8, asr #26
     cf0:	0f260e0c 	svceq	0x00260e0c
     cf4:	3b090000 	blcc	240cfc <__bss_end+0x237de8>
     cf8:	000d3712 	andeq	r3, sp, r2, lsl r7
     cfc:	2a0e1400 	bcs	385d04 <__bss_end+0x37cdf0>
     d00:	0900000e 	stmdbeq	r0, {r1, r2, r3}
     d04:	01340e3d 	teqeq	r4, sp, lsr lr
     d08:	13180000 	tstne	r8, #0
     d0c:	00000c50 	andeq	r0, r0, r0, asr ip
     d10:	6b084109 	blvs	21113c <__bss_end+0x208228>
     d14:	66000009 	strvs	r0, [r0], -r9
     d18:	02000003 	andeq	r0, r0, #3
     d1c:	00000a5a 	andeq	r0, r0, sl, asr sl
     d20:	00000a6f 	andeq	r0, r0, pc, ror #20
     d24:	000d5810 	andeq	r5, sp, r0, lsl r8
     d28:	004d1100 	subeq	r1, sp, r0, lsl #2
     d2c:	5e110000 	cdppl	0, 1, cr0, cr1, cr0, {0}
     d30:	1100000d 	tstne	r0, sp
     d34:	00000d5e 	andeq	r0, r0, lr, asr sp
     d38:	0c191300 	ldceq	3, cr1, [r9], {-0}
     d3c:	43090000 	movwmi	r0, #36864	; 0x9000
     d40:	000bb708 	andeq	fp, fp, r8, lsl #14
     d44:	00036600 	andeq	r6, r3, r0, lsl #12
     d48:	0a880200 	beq	fe201550 <__bss_end+0xfe1f863c>
     d4c:	0a9d0000 	beq	fe740d54 <__bss_end+0xfe737e40>
     d50:	58100000 	ldmdapl	r0, {}	; <UNPREDICTABLE>
     d54:	1100000d 	tstne	r0, sp
     d58:	0000004d 	andeq	r0, r0, sp, asr #32
     d5c:	000d5e11 	andeq	r5, sp, r1, lsl lr
     d60:	0d5e1100 	ldfeqe	f1, [lr, #-0]
     d64:	13000000 	movwne	r0, #0
     d68:	00000ee4 	andeq	r0, r0, r4, ror #29
     d6c:	54084509 	strpl	r4, [r8], #-1289	; 0xfffffaf7
     d70:	66000011 			; <UNDEFINED> instruction: 0x66000011
     d74:	02000003 	andeq	r0, r0, #3
     d78:	00000ab6 			; <UNDEFINED> instruction: 0x00000ab6
     d7c:	00000acb 	andeq	r0, r0, fp, asr #21
     d80:	000d5810 	andeq	r5, sp, r0, lsl r8
     d84:	004d1100 	subeq	r1, sp, r0, lsl #2
     d88:	5e110000 	cdppl	0, 1, cr0, cr1, cr0, {0}
     d8c:	1100000d 	tstne	r0, sp
     d90:	00000d5e 	andeq	r0, r0, lr, asr sp
     d94:	108c1300 	addne	r1, ip, r0, lsl #6
     d98:	47090000 	strmi	r0, [r9, -r0]
     d9c:	000ef708 	andeq	pc, lr, r8, lsl #14
     da0:	00036600 	andeq	r6, r3, r0, lsl #12
     da4:	0ae40200 	beq	ff9015ac <__bss_end+0xff8f8698>
     da8:	0af90000 	beq	ffe40db0 <__bss_end+0xffe37e9c>
     dac:	58100000 	ldmdapl	r0, {}	; <UNPREDICTABLE>
     db0:	1100000d 	tstne	r0, sp
     db4:	0000004d 	andeq	r0, r0, sp, asr #32
     db8:	000d5e11 	andeq	r5, sp, r1, lsl lr
     dbc:	0d5e1100 	ldfeqe	f1, [lr, #-0]
     dc0:	13000000 	movwne	r0, #0
     dc4:	0000053a 	andeq	r0, r0, sl, lsr r5
     dc8:	51084909 	tstpl	r8, r9, lsl #18
     dcc:	66000010 			; <UNDEFINED> instruction: 0x66000010
     dd0:	02000003 	andeq	r0, r0, #3
     dd4:	00000b12 	andeq	r0, r0, r2, lsl fp
     dd8:	00000b27 	andeq	r0, r0, r7, lsr #22
     ddc:	000d5810 	andeq	r5, sp, r0, lsl r8
     de0:	004d1100 	subeq	r1, sp, r0, lsl #2
     de4:	5e110000 	cdppl	0, 1, cr0, cr1, cr0, {0}
     de8:	1100000d 	tstne	r0, sp
     dec:	00000d5e 	andeq	r0, r0, lr, asr sp
     df0:	0bfe1300 	bleq	fff859f8 <__bss_end+0xfff7cae4>
     df4:	4b090000 	blmi	240dfc <__bss_end+0x237ee8>
     df8:	0008e008 	andeq	lr, r8, r8
     dfc:	00036600 	andeq	r6, r3, r0, lsl #12
     e00:	0b400200 	bleq	1001608 <__bss_end+0xff86f4>
     e04:	0b5a0000 	bleq	1680e0c <__bss_end+0x1677ef8>
     e08:	58100000 	ldmdapl	r0, {}	; <UNPREDICTABLE>
     e0c:	1100000d 	tstne	r0, sp
     e10:	0000004d 	andeq	r0, r0, sp, asr #32
     e14:	00098611 	andeq	r8, r9, r1, lsl r6
     e18:	0d5e1100 	ldfeqe	f1, [lr, #-0]
     e1c:	5e110000 	cdppl	0, 1, cr0, cr1, cr0, {0}
     e20:	0000000d 	andeq	r0, r0, sp
     e24:	000a4913 	andeq	r4, sl, r3, lsl r9
     e28:	0c4f0900 	mcrreq	9, 0, r0, pc, cr0	; <UNPREDICTABLE>
     e2c:	00000d61 	andeq	r0, r0, r1, ror #26
     e30:	0000004d 	andeq	r0, r0, sp, asr #32
     e34:	000b7302 	andeq	r7, fp, r2, lsl #6
     e38:	000b7900 	andeq	r7, fp, r0, lsl #18
     e3c:	0d581000 	ldcleq	0, cr1, [r8, #-0]
     e40:	14000000 	strne	r0, [r0], #-0
     e44:	00001183 	andeq	r1, r0, r3, lsl #3
     e48:	db085109 	blle	215274 <__bss_end+0x20c360>
     e4c:	02000006 	andeq	r0, r0, #6
     e50:	00000b8e 	andeq	r0, r0, lr, lsl #23
     e54:	00000b99 	muleq	r0, r9, fp
     e58:	000d6410 	andeq	r6, sp, r0, lsl r4
     e5c:	004d1100 	subeq	r1, sp, r0, lsl #2
     e60:	13000000 	movwne	r0, #0
     e64:	0000122a 	andeq	r1, r0, sl, lsr #4
     e68:	f1035409 			; <UNDEFINED> instruction: 0xf1035409
     e6c:	6400000d 	strvs	r0, [r0], #-13
     e70:	0100000d 	tsteq	r0, sp
     e74:	00000bb2 			; <UNDEFINED> instruction: 0x00000bb2
     e78:	00000bbd 			; <UNDEFINED> instruction: 0x00000bbd
     e7c:	000d6410 	andeq	r6, sp, r0, lsl r4
     e80:	005e1100 	subseq	r1, lr, r0, lsl #2
     e84:	14000000 	strne	r0, [r0], #-0
     e88:	000004fa 	strdeq	r0, [r0], -sl
     e8c:	81085709 	tsthi	r8, r9, lsl #14
     e90:	0100000c 	tsteq	r0, ip
     e94:	00000bd2 	ldrdeq	r0, [r0], -r2
     e98:	00000be2 	andeq	r0, r0, r2, ror #23
     e9c:	000d6410 	andeq	r6, sp, r0, lsl r4
     ea0:	004d1100 	subeq	r1, sp, r0, lsl #2
     ea4:	3d110000 	ldccc	0, cr0, [r1, #-0]
     ea8:	00000009 	andeq	r0, r0, r9
     eac:	000e8913 	andeq	r8, lr, r3, lsl r9
     eb0:	12590900 	subsne	r0, r9, #0, 18
     eb4:	000011dc 	ldrdeq	r1, [r0], -ip
     eb8:	0000093d 	andeq	r0, r0, sp, lsr r9
     ebc:	000bfb01 	andeq	pc, fp, r1, lsl #22
     ec0:	000c0600 	andeq	r0, ip, r0, lsl #12
     ec4:	0d581000 	ldcleq	0, cr1, [r8, #-0]
     ec8:	4d110000 	ldcmi	0, cr0, [r1, #-0]
     ecc:	00000000 	andeq	r0, r0, r0
     ed0:	000c6414 	andeq	r6, ip, r4, lsl r4
     ed4:	085c0900 	ldmdaeq	ip, {r8, fp}^
     ed8:	00000abc 			; <UNDEFINED> instruction: 0x00000abc
     edc:	000c1b01 	andeq	r1, ip, r1, lsl #22
     ee0:	000c2b00 	andeq	r2, ip, r0, lsl #22
     ee4:	0d641000 	stcleq	0, cr1, [r4, #-0]
     ee8:	4d110000 	ldcmi	0, cr0, [r1, #-0]
     eec:	11000000 	mrsne	r0, (UNDEF: 0)
     ef0:	00000366 	andeq	r0, r0, r6, ror #6
     ef4:	0fca1300 	svceq	0x00ca1300
     ef8:	5f090000 	svcpl	0x00090000
     efc:	0004ac08 	andeq	sl, r4, r8, lsl #24
     f00:	00036600 	andeq	r6, r3, r0, lsl #12
     f04:	0c440100 	stfeqe	f0, [r4], {-0}
     f08:	0c4f0000 	mareq	acc0, r0, pc
     f0c:	64100000 	ldrvs	r0, [r0], #-0
     f10:	1100000d 	tstne	r0, sp
     f14:	0000004d 	andeq	r0, r0, sp, asr #32
     f18:	0e7d1300 	cdpeq	3, 7, cr1, cr13, cr0, {0}
     f1c:	62090000 	andvs	r0, r9, #0
     f20:	0003f308 	andeq	pc, r3, r8, lsl #6
     f24:	00036600 	andeq	r6, r3, r0, lsl #12
     f28:	0c680100 	stfeqe	f0, [r8], #-0
     f2c:	0c7d0000 	ldcleq	0, cr0, [sp], #-0
     f30:	64100000 	ldrvs	r0, [r0], #-0
     f34:	1100000d 	tstne	r0, sp
     f38:	0000004d 	andeq	r0, r0, sp, asr #32
     f3c:	00036611 	andeq	r6, r3, r1, lsl r6
     f40:	03661100 	cmneq	r6, #0, 2
     f44:	13000000 	movwne	r0, #0
     f48:	000011d3 	ldrdeq	r1, [r0], -r3
     f4c:	50086409 	andpl	r6, r8, r9, lsl #8
     f50:	66000008 	strvs	r0, [r0], -r8
     f54:	01000003 	tsteq	r0, r3
     f58:	00000c96 	muleq	r0, r6, ip
     f5c:	00000cab 	andeq	r0, r0, fp, lsr #25
     f60:	000d6410 	andeq	r6, sp, r0, lsl r4
     f64:	004d1100 	subeq	r1, sp, r0, lsl #2
     f68:	66110000 	ldrvs	r0, [r1], -r0
     f6c:	11000003 	tstne	r0, r3
     f70:	00000366 	andeq	r0, r0, r6, ror #6
     f74:	0b441400 	bleq	1105f7c <__bss_end+0x10fd068>
     f78:	67090000 	strvs	r0, [r9, -r0]
     f7c:	0003b308 	andeq	fp, r3, r8, lsl #6
     f80:	0cc00100 	stfeqe	f0, [r0], {0}
     f84:	0cd00000 	ldcleq	0, cr0, [r0], {0}
     f88:	64100000 	ldrvs	r0, [r0], #-0
     f8c:	1100000d 	tstne	r0, sp
     f90:	0000004d 	andeq	r0, r0, sp, asr #32
     f94:	00098611 	andeq	r8, r9, r1, lsl r6
     f98:	1c140000 	ldcne	0, cr0, [r4], {-0}
     f9c:	0900000d 	stmdbeq	r0, {r0, r2, r3}
     fa0:	07820869 	streq	r0, [r2, r9, ror #16]
     fa4:	e5010000 	str	r0, [r1, #-0]
     fa8:	f500000c 			; <UNDEFINED> instruction: 0xf500000c
     fac:	1000000c 	andne	r0, r0, ip
     fb0:	00000d64 	andeq	r0, r0, r4, ror #26
     fb4:	00004d11 	andeq	r4, r0, r1, lsl sp
     fb8:	09861100 	stmibeq	r6, {r8, ip}
     fbc:	14000000 	strne	r0, [r0], #-0
     fc0:	0000129a 	muleq	r0, sl, r2
     fc4:	09086c09 	stmdbeq	r8, {r0, r3, sl, fp, sp, lr}
     fc8:	0100000a 	tsteq	r0, sl
     fcc:	00000d0a 	andeq	r0, r0, sl, lsl #26
     fd0:	00000d10 	andeq	r0, r0, r0, lsl sp
     fd4:	000d6410 	andeq	r6, sp, r0, lsl r4
     fd8:	a8270000 	stmdage	r7!, {}	; <UNPREDICTABLE>
     fdc:	0900000b 	stmdbeq	r0, {r0, r1, r3}
     fe0:	0e38086f 	cdpeq	8, 3, cr0, cr8, cr15, {3}
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
    1034:	000b581a 	andeq	r5, fp, sl, lsl r8
    1038:	16730900 	ldrbtne	r0, [r3], -r0, lsl #18
    103c:	000009b1 			; <UNDEFINED> instruction: 0x000009b1
    1040:	00124f28 	andseq	r4, r2, r8, lsr #30
    1044:	050e0100 	streq	r0, [lr, #-256]	; 0xffffff00
    1048:	00000038 	andeq	r0, r0, r8, lsr r0
    104c:	00008238 	andeq	r8, r0, r8, lsr r2
    1050:	000000dc 	ldrdeq	r0, [r0], -ip
    1054:	0dfa9c01 	ldcleq	12, cr9, [sl, #4]!
    1058:	12290000 	eorne	r0, r9, #0
    105c:	01000012 	tsteq	r0, r2, lsl r0
    1060:	00380e0e 	eorseq	r0, r8, lr, lsl #28
    1064:	91020000 	mrsls	r0, (UNDEF: 2)
    1068:	10f1295c 	rscsne	r2, r1, ip, asr r9
    106c:	0e010000 	cdpeq	0, 0, cr0, cr1, cr0, {0}
    1070:	000dfa1b 	andeq	pc, sp, fp, lsl sl	; <UNPREDICTABLE>
    1074:	58910200 	ldmpl	r1, {r9}
    1078:	0019f12a 	andseq	pc, r9, sl, lsr #2
    107c:	07100100 	ldreq	r0, [r0, -r0, lsl #2]
    1080:	00000025 	andeq	r0, r0, r5, lsr #32
    1084:	2a6b9102 	bcs	1ae5494 <__bss_end+0x1adc580>
    1088:	00000552 	andeq	r0, r0, r2, asr r5
    108c:	25071101 	strcs	r1, [r7, #-257]	; 0xfffffeff
    1090:	02000000 	andeq	r0, r0, #0
    1094:	642a7791 	strtvs	r7, [sl], #-1937	; 0xfffff86f
    1098:	0100000e 	tsteq	r0, lr
    109c:	004d0b13 	subeq	r0, sp, r3, lsl fp
    10a0:	91020000 	mrsls	r0, (UNDEF: 2)
    10a4:	0fc32a70 	svceq	0x00c32a70
    10a8:	16010000 	strne	r0, [r1], -r0
    10ac:	00098617 	andeq	r8, r9, r7, lsl r6
    10b0:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    10b4:	0012a52a 	andseq	sl, r2, sl, lsr #10
    10b8:	0b1e0100 	bleq	7814c0 <__bss_end+0x7785ac>
    10bc:	0000004d 	andeq	r0, r0, sp, asr #32
    10c0:	006c9102 	rsbeq	r9, ip, r2, lsl #2
    10c4:	0e000418 	cfmvdlreq	mvd0, r0
    10c8:	04180000 	ldreq	r0, [r8], #-0
    10cc:	00000025 	andeq	r0, r0, r5, lsr #32
    10d0:	000cd700 	andeq	sp, ip, r0, lsl #14
    10d4:	4c000400 	cfstrsmi	mvf0, [r0], {-0}
    10d8:	04000004 	streq	r0, [r0], #-4
    10dc:	00159e01 	andseq	r9, r5, r1, lsl #28
    10e0:	13190400 	tstne	r9, #0, 8
    10e4:	13c70000 	bicne	r0, r7, #0
    10e8:	83140000 	tsthi	r4, #0
    10ec:	045c0000 	ldrbeq	r0, [ip], #-0
    10f0:	03fa0000 	mvnseq	r0, #0
    10f4:	01020000 	mrseq	r0, (UNDEF: 2)
    10f8:	000d5c08 	andeq	r5, sp, r8, lsl #24
    10fc:	00250300 	eoreq	r0, r5, r0, lsl #6
    1100:	02020000 	andeq	r0, r2, #0
    1104:	000dd005 	andeq	sp, sp, r5
    1108:	05040400 	streq	r0, [r4, #-1024]	; 0xfffffc00
    110c:	00746e69 	rsbseq	r6, r4, r9, ror #28
    1110:	53080102 	movwpl	r0, #33026	; 0x8102
    1114:	0200000d 	andeq	r0, r0, #13
    1118:	09cc0702 	stmibeq	ip, {r1, r8, r9, sl}^
    111c:	74050000 	strvc	r0, [r5], #-0
    1120:	0700000e 	streq	r0, [r0, -lr]
    1124:	005e0709 	subseq	r0, lr, r9, lsl #14
    1128:	4d030000 	stcmi	0, cr0, [r3, #-0]
    112c:	02000000 	andeq	r0, r0, #0
    1130:	1ca50704 	stcne	7, cr0, [r5], #16
    1134:	52060000 	andpl	r0, r6, #0
    1138:	08000007 	stmdaeq	r0, {r0, r1, r2}
    113c:	8b080602 	blhi	20294c <__bss_end+0x1f9a38>
    1140:	07000000 	streq	r0, [r0, -r0]
    1144:	02003072 	andeq	r3, r0, #114	; 0x72
    1148:	004d0e08 	subeq	r0, sp, r8, lsl #28
    114c:	07000000 	streq	r0, [r0, -r0]
    1150:	02003172 	andeq	r3, r0, #-2147483620	; 0x8000001c
    1154:	004d0e09 	subeq	r0, sp, r9, lsl #28
    1158:	00040000 	andeq	r0, r4, r0
    115c:	0014dd08 	andseq	sp, r4, r8, lsl #26
    1160:	38040500 	stmdacc	r4, {r8, sl}
    1164:	02000000 	andeq	r0, r0, #0
    1168:	00a90c0d 	adceq	r0, r9, sp, lsl #24
    116c:	4f090000 	svcmi	0x00090000
    1170:	0a00004b 	beq	12a4 <shift+0x12a4>
    1174:	00001350 	andeq	r1, r0, r0, asr r3
    1178:	85080001 	strhi	r0, [r8, #-1]
    117c:	05000005 	streq	r0, [r0, #-5]
    1180:	00003804 	andeq	r3, r0, r4, lsl #16
    1184:	0c1e0200 	lfmeq	f0, 4, [lr], {-0}
    1188:	000000e0 	andeq	r0, r0, r0, ror #1
    118c:	0008070a 	andeq	r0, r8, sl, lsl #14
    1190:	8a0a0000 	bhi	281198 <__bss_end+0x278284>
    1194:	01000012 	tsteq	r0, r2, lsl r0
    1198:	0012540a 	andseq	r5, r2, sl, lsl #8
    119c:	6e0a0200 	cdpvs	2, 0, cr0, cr10, cr0, {0}
    11a0:	0300000a 	movweq	r0, #10
    11a4:	000cb90a 	andeq	fp, ip, sl, lsl #18
    11a8:	d00a0400 	andle	r0, sl, r0, lsl #8
    11ac:	05000007 	streq	r0, [r0, #-7]
    11b0:	113c0800 	teqne	ip, r0, lsl #16
    11b4:	04050000 	streq	r0, [r5], #-0
    11b8:	00000038 	andeq	r0, r0, r8, lsr r0
    11bc:	1d0c3f02 	stcne	15, cr3, [ip, #-8]
    11c0:	0a000001 	beq	11cc <shift+0x11cc>
    11c4:	0000041d 	andeq	r0, r0, sp, lsl r4
    11c8:	05c10a00 	strbeq	r0, [r1, #2560]	; 0xa00
    11cc:	0a010000 	beq	411d4 <__bss_end+0x382c0>
    11d0:	00000c74 	andeq	r0, r0, r4, ror ip
    11d4:	12050a02 	andne	r0, r5, #8192	; 0x2000
    11d8:	0a030000 	beq	c11e0 <__bss_end+0xb82cc>
    11dc:	00001294 	muleq	r0, r4, r2
    11e0:	0b8e0a04 	bleq	fe3839f8 <__bss_end+0xfe37aae4>
    11e4:	0a050000 	beq	1411ec <__bss_end+0x1382d8>
    11e8:	000009ec 	andeq	r0, r0, ip, ror #19
    11ec:	f6080006 			; <UNDEFINED> instruction: 0xf6080006
    11f0:	05000010 	streq	r0, [r0, #-16]
    11f4:	00003804 	andeq	r3, r0, r4, lsl #16
    11f8:	0c660200 	sfmeq	f0, 2, [r6], #-0
    11fc:	00000148 	andeq	r0, r0, r8, asr #2
    1200:	000d310a 	andeq	r3, sp, sl, lsl #2
    1204:	ae0a0000 	cdpge	0, 0, cr0, cr10, cr0, {0}
    1208:	01000009 	tsteq	r0, r9
    120c:	000dda0a 	andeq	sp, sp, sl, lsl #20
    1210:	f10a0200 			; <UNDEFINED> instruction: 0xf10a0200
    1214:	03000009 	movweq	r0, #9
    1218:	0be60b00 	bleq	ff983e20 <__bss_end+0xff97af0c>
    121c:	05030000 	streq	r0, [r3, #-0]
    1220:	00005914 	andeq	r5, r0, r4, lsl r9
    1224:	b8030500 	stmdalt	r3, {r8, sl}
    1228:	0b00008e 	bleq	1468 <shift+0x1468>
    122c:	00000c2c 	andeq	r0, r0, ip, lsr #24
    1230:	59140603 	ldmdbpl	r4, {r0, r1, r9, sl}
    1234:	05000000 	streq	r0, [r0, #-0]
    1238:	008ebc03 	addeq	fp, lr, r3, lsl #24
    123c:	0b780b00 	bleq	1e03e44 <__bss_end+0x1dfaf30>
    1240:	07040000 	streq	r0, [r4, -r0]
    1244:	0000591a 	andeq	r5, r0, sl, lsl r9
    1248:	c0030500 	andgt	r0, r3, r0, lsl #10
    124c:	0b00008e 	bleq	148c <shift+0x148c>
    1250:	000004d5 	ldrdeq	r0, [r0], -r5
    1254:	591a0904 	ldmdbpl	sl, {r2, r8, fp}
    1258:	05000000 	streq	r0, [r0, #-0]
    125c:	008ec403 	addeq	ip, lr, r3, lsl #8
    1260:	0d450b00 	vstreq	d16, [r5, #-0]
    1264:	0b040000 	bleq	10126c <__bss_end+0xf8358>
    1268:	0000591a 	andeq	r5, r0, sl, lsl r9
    126c:	c8030500 	stmdagt	r3, {r8, sl}
    1270:	0b00008e 	bleq	14b0 <shift+0x14b0>
    1274:	0000099b 	muleq	r0, fp, r9
    1278:	591a0d04 	ldmdbpl	sl, {r2, r8, sl, fp}
    127c:	05000000 	streq	r0, [r0, #-0]
    1280:	008ecc03 	addeq	ip, lr, r3, lsl #24
    1284:	07780b00 	ldrbeq	r0, [r8, -r0, lsl #22]!
    1288:	0f040000 	svceq	0x00040000
    128c:	0000591a 	andeq	r5, r0, sl, lsl r9
    1290:	d0030500 	andle	r0, r3, r0, lsl #10
    1294:	0800008e 	stmdaeq	r0, {r1, r2, r3, r7}
    1298:	00000ed4 	ldrdeq	r0, [r0], -r4
    129c:	00380405 	eorseq	r0, r8, r5, lsl #8
    12a0:	1b040000 	blne	1012a8 <__bss_end+0xf8394>
    12a4:	0001eb0c 	andeq	lr, r1, ip, lsl #22
    12a8:	0f400a00 	svceq	0x00400a00
    12ac:	0a000000 	beq	12b4 <shift+0x12b4>
    12b0:	00001244 	andeq	r1, r0, r4, asr #4
    12b4:	0c6f0a01 			; <UNDEFINED> instruction: 0x0c6f0a01
    12b8:	00020000 	andeq	r0, r2, r0
    12bc:	000d160c 	andeq	r1, sp, ip, lsl #12
    12c0:	0db50d00 	ldceq	13, cr0, [r5]
    12c4:	04900000 	ldreq	r0, [r0], #0
    12c8:	035e0763 	cmpeq	lr, #25952256	; 0x18c0000
    12cc:	a7060000 	strge	r0, [r6, -r0]
    12d0:	24000011 	strcs	r0, [r0], #-17	; 0xffffffef
    12d4:	78106704 	ldmdavc	r0, {r2, r8, r9, sl, sp, lr}
    12d8:	0e000002 	cdpeq	0, 0, cr0, cr0, cr2, {0}
    12dc:	00002015 	andeq	r2, r0, r5, lsl r0
    12e0:	5e126904 	vnmlspl.f16	s12, s4, s8	; <UNPREDICTABLE>
    12e4:	00000003 	andeq	r0, r0, r3
    12e8:	0005790e 	andeq	r7, r5, lr, lsl #18
    12ec:	126b0400 	rsbne	r0, fp, #0, 8
    12f0:	0000036e 	andeq	r0, r0, lr, ror #6
    12f4:	0f350e10 	svceq	0x00350e10
    12f8:	6d040000 	stcvs	0, cr0, [r4, #-0]
    12fc:	00004d16 	andeq	r4, r0, r6, lsl sp
    1300:	e90e1400 	stmdb	lr, {sl, ip}
    1304:	04000005 	streq	r0, [r0], #-5
    1308:	03751c70 	cmneq	r5, #112, 24	; 0x7000
    130c:	0e180000 	cdpeq	0, 1, cr0, cr8, cr0, {0}
    1310:	00000d3c 	andeq	r0, r0, ip, lsr sp
    1314:	751c7204 	ldrvc	r7, [ip, #-516]	; 0xfffffdfc
    1318:	1c000003 	stcne	0, cr0, [r0], {3}
    131c:	00054d0e 	andeq	r4, r5, lr, lsl #26
    1320:	1c750400 	cfldrdne	mvd0, [r5], #-0
    1324:	00000375 	andeq	r0, r0, r5, ror r3
    1328:	08190f20 	ldmdaeq	r9, {r5, r8, r9, sl, fp}
    132c:	77040000 	strvc	r0, [r4, -r0]
    1330:	0004691c 	andeq	r6, r4, ip, lsl r9
    1334:	00037500 	andeq	r7, r3, r0, lsl #10
    1338:	00026c00 	andeq	r6, r2, r0, lsl #24
    133c:	03751000 	cmneq	r5, #0
    1340:	7b110000 	blvc	441348 <__bss_end+0x438434>
    1344:	00000003 	andeq	r0, r0, r3
    1348:	068d0600 	streq	r0, [sp], r0, lsl #12
    134c:	04180000 	ldreq	r0, [r8], #-0
    1350:	02ad107b 	adceq	r1, sp, #123	; 0x7b
    1354:	150e0000 	strne	r0, [lr, #-0]
    1358:	04000020 	streq	r0, [r0], #-32	; 0xffffffe0
    135c:	035e127e 	cmpeq	lr, #-536870905	; 0xe0000007
    1360:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    1364:	0000056e 	andeq	r0, r0, lr, ror #10
    1368:	7b198004 	blvc	661380 <__bss_end+0x65846c>
    136c:	10000003 	andne	r0, r0, r3
    1370:	00120b0e 	andseq	r0, r2, lr, lsl #22
    1374:	21820400 	orrcs	r0, r2, r0, lsl #8
    1378:	00000386 	andeq	r0, r0, r6, lsl #7
    137c:	78030014 	stmdavc	r3, {r2, r4}
    1380:	12000002 	andne	r0, r0, #2
    1384:	00000b22 	andeq	r0, r0, r2, lsr #22
    1388:	8c218604 	stchi	6, cr8, [r1], #-16
    138c:	12000003 	andne	r0, r0, #3
    1390:	000008ce 	andeq	r0, r0, lr, asr #17
    1394:	591f8804 	ldmdbpl	pc, {r2, fp, pc}	; <UNPREDICTABLE>
    1398:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    139c:	00000e18 	andeq	r0, r0, r8, lsl lr
    13a0:	fd178b04 	ldc2	11, cr8, [r7, #-16]	; <UNPREDICTABLE>
    13a4:	00000001 	andeq	r0, r0, r1
    13a8:	000a740e 	andeq	r7, sl, lr, lsl #8
    13ac:	178e0400 	strne	r0, [lr, r0, lsl #8]
    13b0:	000001fd 	strdeq	r0, [r0], -sp
    13b4:	09390e24 	ldmdbeq	r9!, {r2, r5, r9, sl, fp}
    13b8:	8f040000 	svchi	0x00040000
    13bc:	0001fd17 	andeq	pc, r1, r7, lsl sp	; <UNPREDICTABLE>
    13c0:	740e4800 	strvc	r4, [lr], #-2048	; 0xfffff800
    13c4:	04000012 	streq	r0, [r0], #-18	; 0xffffffee
    13c8:	01fd1790 			; <UNDEFINED> instruction: 0x01fd1790
    13cc:	136c0000 	cmnne	ip, #0
    13d0:	00000db5 			; <UNDEFINED> instruction: 0x00000db5
    13d4:	78099304 	stmdavc	r9, {r2, r8, r9, ip, pc}
    13d8:	97000006 	strls	r0, [r0, -r6]
    13dc:	01000003 	tsteq	r0, r3
    13e0:	00000317 	andeq	r0, r0, r7, lsl r3
    13e4:	0000031d 	andeq	r0, r0, sp, lsl r3
    13e8:	00039710 	andeq	r9, r3, r0, lsl r7
    13ec:	17140000 	ldrne	r0, [r4, -r0]
    13f0:	0400000b 	streq	r0, [r0], #-11
    13f4:	0a2a0e96 	beq	a84e54 <__bss_end+0xa7bf40>
    13f8:	32010000 	andcc	r0, r1, #0
    13fc:	38000003 	stmdacc	r0, {r0, r1}
    1400:	10000003 	andne	r0, r0, r3
    1404:	00000397 	muleq	r0, r7, r3
    1408:	041d1500 	ldreq	r1, [sp], #-1280	; 0xfffffb00
    140c:	99040000 	stmdbls	r4, {}	; <UNPREDICTABLE>
    1410:	000eb910 	andeq	fp, lr, r0, lsl r9
    1414:	00039d00 	andeq	r9, r3, r0, lsl #26
    1418:	034d0100 	movteq	r0, #53504	; 0xd100
    141c:	97100000 	ldrls	r0, [r0, -r0]
    1420:	11000003 	tstne	r0, r3
    1424:	0000037b 	andeq	r0, r0, fp, ror r3
    1428:	0001c611 	andeq	ip, r1, r1, lsl r6
    142c:	16000000 	strne	r0, [r0], -r0
    1430:	00000025 	andeq	r0, r0, r5, lsr #32
    1434:	0000036e 	andeq	r0, r0, lr, ror #6
    1438:	00005e17 	andeq	r5, r0, r7, lsl lr
    143c:	02000f00 	andeq	r0, r0, #0, 30
    1440:	0a7e0201 	beq	1f81c4c <__bss_end+0x1f78d38>
    1444:	04180000 	ldreq	r0, [r8], #-0
    1448:	000001fd 	strdeq	r0, [r0], -sp
    144c:	002c0418 	eoreq	r0, ip, r8, lsl r4
    1450:	170c0000 	strne	r0, [ip, -r0]
    1454:	18000012 	stmdane	r0, {r1, r4}
    1458:	00038104 	andeq	r8, r3, r4, lsl #2
    145c:	02ad1600 	adceq	r1, sp, #0, 12
    1460:	03970000 	orrseq	r0, r7, #0
    1464:	00190000 	andseq	r0, r9, r0
    1468:	01f00418 	mvnseq	r0, r8, lsl r4
    146c:	04180000 	ldreq	r0, [r8], #-0
    1470:	000001eb 	andeq	r0, r0, fp, ror #3
    1474:	000e1e1a 	andeq	r1, lr, sl, lsl lr
    1478:	149c0400 	ldrne	r0, [ip], #1024	; 0x400
    147c:	000001f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    1480:	00087a0b 	andeq	r7, r8, fp, lsl #20
    1484:	14040500 	strne	r0, [r4], #-1280	; 0xfffffb00
    1488:	00000059 	andeq	r0, r0, r9, asr r0
    148c:	8ed40305 	cdphi	3, 13, cr0, cr4, cr5, {0}
    1490:	a80b0000 	stmdage	fp, {}	; <UNPREDICTABLE>
    1494:	05000003 	streq	r0, [r0, #-3]
    1498:	00591407 	subseq	r1, r9, r7, lsl #8
    149c:	03050000 	movweq	r0, #20480	; 0x5000
    14a0:	00008ed8 	ldrdeq	r8, [r0], -r8	; <UNPREDICTABLE>
    14a4:	0006540b 	andeq	r5, r6, fp, lsl #8
    14a8:	140a0500 	strne	r0, [sl], #-1280	; 0xfffffb00
    14ac:	00000059 	andeq	r0, r0, r9, asr r0
    14b0:	8edc0305 	cdphi	3, 13, cr0, cr12, cr5, {0}
    14b4:	e7080000 	str	r0, [r8, -r0]
    14b8:	0500000a 	streq	r0, [r0, #-10]
    14bc:	00003804 	andeq	r3, r0, r4, lsl #16
    14c0:	0c0d0500 	cfstr32eq	mvfx0, [sp], {-0}
    14c4:	0000041c 	andeq	r0, r0, ip, lsl r4
    14c8:	77654e09 	strbvc	r4, [r5, -r9, lsl #28]!
    14cc:	de0a0000 	cdple	0, 0, cr0, cr10, cr0, {0}
    14d0:	0100000a 	tsteq	r0, sl
    14d4:	000e300a 	andeq	r3, lr, sl
    14d8:	990a0200 	stmdbls	sl, {r9}
    14dc:	0300000a 	movweq	r0, #10
    14e0:	000a600a 	andeq	r6, sl, sl
    14e4:	7a0a0400 	bvc	2824ec <__bss_end+0x2795d8>
    14e8:	0500000c 	streq	r0, [r0, #-12]
    14ec:	07c30600 	strbeq	r0, [r3, r0, lsl #12]
    14f0:	05100000 	ldreq	r0, [r0, #-0]
    14f4:	045b081b 	ldrbeq	r0, [fp], #-2075	; 0xfffff7e5
    14f8:	6c070000 	stcvs	0, cr0, [r7], {-0}
    14fc:	1d050072 	stcne	0, cr0, [r5, #-456]	; 0xfffffe38
    1500:	00045b13 	andeq	r5, r4, r3, lsl fp
    1504:	73070000 	movwvc	r0, #28672	; 0x7000
    1508:	1e050070 	mcrne	0, 0, r0, cr5, cr0, {3}
    150c:	00045b13 	andeq	r5, r4, r3, lsl fp
    1510:	70070400 	andvc	r0, r7, r0, lsl #8
    1514:	1f050063 	svcne	0x00050063
    1518:	00045b13 	andeq	r5, r4, r3, lsl fp
    151c:	d90e0800 	stmdble	lr, {fp}
    1520:	05000007 	streq	r0, [r0, #-7]
    1524:	045b1320 	ldrbeq	r1, [fp], #-800	; 0xfffffce0
    1528:	000c0000 	andeq	r0, ip, r0
    152c:	a0070402 	andge	r0, r7, r2, lsl #8
    1530:	0600001c 			; <UNDEFINED> instruction: 0x0600001c
    1534:	0000045c 	andeq	r0, r0, ip, asr r4
    1538:	08280570 	stmdaeq	r8!, {r4, r5, r6, r8, sl}
    153c:	000004f2 	strdeq	r0, [r0], -r2
    1540:	00127e0e 	andseq	r7, r2, lr, lsl #28
    1544:	122a0500 	eorne	r0, sl, #0, 10
    1548:	0000041c 	andeq	r0, r0, ip, lsl r4
    154c:	69700700 	ldmdbvs	r0!, {r8, r9, sl}^
    1550:	2b050064 	blcs	1416e8 <__bss_end+0x1387d4>
    1554:	00005e12 	andeq	r5, r0, r2, lsl lr
    1558:	f10e1000 			; <UNDEFINED> instruction: 0xf10e1000
    155c:	05000019 	streq	r0, [r0, #-25]	; 0xffffffe7
    1560:	03e5112c 	mvneq	r1, #44, 2
    1564:	0e140000 	cdpeq	0, 1, cr0, cr4, cr0, {0}
    1568:	00000af3 	strdeq	r0, [r0], -r3
    156c:	5e122d05 	cdppl	13, 1, cr2, cr2, cr5, {0}
    1570:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
    1574:	000b010e 	andeq	r0, fp, lr, lsl #2
    1578:	122e0500 	eorne	r0, lr, #0, 10
    157c:	0000005e 	andeq	r0, r0, lr, asr r0
    1580:	076b0e1c 			; <UNDEFINED> instruction: 0x076b0e1c
    1584:	2f050000 	svccs	0x00050000
    1588:	0004f20c 	andeq	pc, r4, ip, lsl #4
    158c:	2e0e2000 	cdpcs	0, 0, cr2, cr14, cr0, {0}
    1590:	0500000b 	streq	r0, [r0, #-11]
    1594:	00380930 	eorseq	r0, r8, r0, lsr r9
    1598:	0e600000 	cdpeq	0, 6, cr0, cr0, cr0, {0}
    159c:	00000f4a 	andeq	r0, r0, sl, asr #30
    15a0:	4d0e3105 	stfmis	f3, [lr, #-20]	; 0xffffffec
    15a4:	64000000 	strvs	r0, [r0], #-0
    15a8:	00082d0e 	andeq	r2, r8, lr, lsl #26
    15ac:	0e330500 	cfabs32eq	mvfx0, mvfx3
    15b0:	0000004d 	andeq	r0, r0, sp, asr #32
    15b4:	08240e68 	stmdaeq	r4!, {r3, r5, r6, r9, sl, fp}
    15b8:	34050000 	strcc	r0, [r5], #-0
    15bc:	00004d0e 	andeq	r4, r0, lr, lsl #26
    15c0:	16006c00 	strne	r6, [r0], -r0, lsl #24
    15c4:	0000039d 	muleq	r0, sp, r3
    15c8:	00000502 	andeq	r0, r0, r2, lsl #10
    15cc:	00005e17 	andeq	r5, r0, r7, lsl lr
    15d0:	0b000f00 	bleq	51d8 <shift+0x51d8>
    15d4:	00001198 	muleq	r0, r8, r1
    15d8:	59140a06 	ldmdbpl	r4, {r1, r2, r9, fp}
    15dc:	05000000 	streq	r0, [r0, #-0]
    15e0:	008ee003 	addeq	lr, lr, r3
    15e4:	0aa10800 	beq	fe8435ec <__bss_end+0xfe83a6d8>
    15e8:	04050000 	streq	r0, [r5], #-0
    15ec:	00000038 	andeq	r0, r0, r8, lsr r0
    15f0:	330c0d06 	movwcc	r0, #52486	; 0xcd06
    15f4:	0a000005 	beq	1610 <shift+0x1610>
    15f8:	0000059a 	muleq	r0, sl, r5
    15fc:	039d0a00 	orrseq	r0, sp, #0, 20
    1600:	00010000 	andeq	r0, r1, r0
    1604:	00051403 	andeq	r1, r5, r3, lsl #8
    1608:	14300800 	ldrtne	r0, [r0], #-2048	; 0xfffff800
    160c:	04050000 	streq	r0, [r5], #-0
    1610:	00000038 	andeq	r0, r0, r8, lsr r0
    1614:	570c1406 	strpl	r1, [ip, -r6, lsl #8]
    1618:	0a000005 	beq	1634 <shift+0x1634>
    161c:	000012b3 			; <UNDEFINED> instruction: 0x000012b3
    1620:	14af0a00 	strtne	r0, [pc], #2560	; 1628 <shift+0x1628>
    1624:	00010000 	andeq	r0, r1, r0
    1628:	00053803 	andeq	r3, r5, r3, lsl #16
    162c:	103e0600 	eorsne	r0, lr, r0, lsl #12
    1630:	060c0000 	streq	r0, [ip], -r0
    1634:	0591081b 	ldreq	r0, [r1, #2075]	; 0x81b
    1638:	2e0e0000 	cdpcs	0, 0, cr0, cr14, cr0, {0}
    163c:	06000004 	streq	r0, [r0], -r4
    1640:	0591191d 	ldreq	r1, [r1, #2333]	; 0x91d
    1644:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    1648:	0000054d 	andeq	r0, r0, sp, asr #10
    164c:	91191e06 	tstls	r9, r6, lsl #28
    1650:	04000005 	streq	r0, [r0], #-5
    1654:	000fbe0e 	andeq	fp, pc, lr, lsl #28
    1658:	131f0600 	tstne	pc, #0, 12
    165c:	00000597 	muleq	r0, r7, r5
    1660:	04180008 	ldreq	r0, [r8], #-8
    1664:	0000055c 	andeq	r0, r0, ip, asr r5
    1668:	04620418 	strbteq	r0, [r2], #-1048	; 0xfffffbe8
    166c:	670d0000 	strvs	r0, [sp, -r0]
    1670:	14000006 	strne	r0, [r0], #-6
    1674:	1f072206 	svcne	0x00072206
    1678:	0e000008 	cdpeq	0, 0, cr0, cr0, cr8, {0}
    167c:	00000a8f 	andeq	r0, r0, pc, lsl #21
    1680:	4d122606 	ldcmi	6, cr2, [r2, #-24]	; 0xffffffe8
    1684:	00000000 	andeq	r0, r0, r0
    1688:	0004e70e 	andeq	lr, r4, lr, lsl #14
    168c:	1d290600 	stcne	6, cr0, [r9, #-0]
    1690:	00000591 	muleq	r0, r1, r5
    1694:	0ea60e04 	cdpeq	14, 10, cr0, cr6, cr4, {0}
    1698:	2c060000 	stccs	0, cr0, [r6], {-0}
    169c:	0005911d 	andeq	r9, r5, sp, lsl r1
    16a0:	321b0800 	andscc	r0, fp, #0, 16
    16a4:	06000011 			; <UNDEFINED> instruction: 0x06000011
    16a8:	101b0e2f 	andsne	r0, fp, pc, lsr #28
    16ac:	05e50000 	strbeq	r0, [r5, #0]!
    16b0:	05f00000 	ldrbeq	r0, [r0, #0]!
    16b4:	24100000 	ldrcs	r0, [r0], #-0
    16b8:	11000008 	tstne	r0, r8
    16bc:	00000591 	muleq	r0, r1, r5
    16c0:	0fd41c00 	svceq	0x00d41c00
    16c4:	31060000 	mrscc	r0, (UNDEF: 6)
    16c8:	0004330e 	andeq	r3, r4, lr, lsl #6
    16cc:	00036e00 	andeq	r6, r3, r0, lsl #28
    16d0:	00060800 	andeq	r0, r6, r0, lsl #16
    16d4:	00061300 	andeq	r1, r6, r0, lsl #6
    16d8:	08241000 	stmdaeq	r4!, {ip}
    16dc:	97110000 	ldrls	r0, [r1, -r0]
    16e0:	00000005 	andeq	r0, r0, r5
    16e4:	00108013 	andseq	r8, r0, r3, lsl r0
    16e8:	1d350600 	ldcne	6, cr0, [r5, #-0]
    16ec:	00000f99 	muleq	r0, r9, pc	; <UNPREDICTABLE>
    16f0:	00000591 	muleq	r0, r1, r5
    16f4:	00062c02 	andeq	r2, r6, r2, lsl #24
    16f8:	00063200 	andeq	r3, r6, r0, lsl #4
    16fc:	08241000 	stmdaeq	r4!, {ip}
    1700:	13000000 	movwne	r0, #0
    1704:	000009df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    1708:	8f1d3706 	svchi	0x001d3706
    170c:	9100000d 	tstls	r0, sp
    1710:	02000005 	andeq	r0, r0, #5
    1714:	0000064b 	andeq	r0, r0, fp, asr #12
    1718:	00000651 	andeq	r0, r0, r1, asr r6
    171c:	00082410 	andeq	r2, r8, r0, lsl r4
    1720:	5e1d0000 	cdppl	0, 1, cr0, cr13, cr0, {0}
    1724:	0600000b 	streq	r0, [r0], -fp
    1728:	083d3139 	ldmdaeq	sp!, {r0, r3, r4, r5, r8, ip, sp}
    172c:	020c0000 	andeq	r0, ip, #0
    1730:	00066713 	andeq	r6, r6, r3, lsl r7
    1734:	093c0600 	ldmdbeq	ip!, {r9, sl}
    1738:	0000125a 	andeq	r1, r0, sl, asr r2
    173c:	00000824 	andeq	r0, r0, r4, lsr #16
    1740:	00067801 	andeq	r7, r6, r1, lsl #16
    1744:	00067e00 	andeq	r7, r6, r0, lsl #28
    1748:	08241000 	stmdaeq	r4!, {ip}
    174c:	13000000 	movwne	r0, #0
    1750:	000005d4 	ldrdeq	r0, [r0], -r4
    1754:	07123f06 	ldreq	r3, [r2, -r6, lsl #30]
    1758:	4d000011 	stcmi	0, cr0, [r0, #-68]	; 0xffffffbc
    175c:	01000000 	mrseq	r0, (UNDEF: 0)
    1760:	00000697 	muleq	r0, r7, r6
    1764:	000006ac 	andeq	r0, r0, ip, lsr #13
    1768:	00082410 	andeq	r2, r8, r0, lsl r4
    176c:	08461100 	stmdaeq	r6, {r8, ip}^
    1770:	5e110000 	cdppl	0, 1, cr0, cr1, cr0, {0}
    1774:	11000000 	mrsne	r0, (UNDEF: 0)
    1778:	0000036e 	andeq	r0, r0, lr, ror #6
    177c:	0fe31400 	svceq	0x00e31400
    1780:	42060000 	andmi	r0, r6, #0
    1784:	000cc80e 	andeq	ip, ip, lr, lsl #16
    1788:	06c10100 	strbeq	r0, [r1], r0, lsl #2
    178c:	06c70000 	strbeq	r0, [r7], r0
    1790:	24100000 	ldrcs	r0, [r0], #-0
    1794:	00000008 	andeq	r0, r0, r8
    1798:	00094313 	andeq	r4, r9, r3, lsl r3
    179c:	17450600 	strbne	r0, [r5, -r0, lsl #12]
    17a0:	0000050c 	andeq	r0, r0, ip, lsl #10
    17a4:	00000597 	muleq	r0, r7, r5
    17a8:	0006e001 	andeq	lr, r6, r1
    17ac:	0006e600 	andeq	lr, r6, r0, lsl #12
    17b0:	084c1000 	stmdaeq	ip, {ip}^
    17b4:	13000000 	movwne	r0, #0
    17b8:	0000055b 	andeq	r0, r0, fp, asr r5
    17bc:	56174806 	ldrpl	r4, [r7], -r6, lsl #16
    17c0:	9700000f 	strls	r0, [r0, -pc]
    17c4:	01000005 	tsteq	r0, r5
    17c8:	000006ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    17cc:	0000070a 	andeq	r0, r0, sl, lsl #14
    17d0:	00084c10 	andeq	r4, r8, r0, lsl ip
    17d4:	004d1100 	subeq	r1, sp, r0, lsl #2
    17d8:	14000000 	strne	r0, [r0], #-0
    17dc:	000011b5 			; <UNDEFINED> instruction: 0x000011b5
    17e0:	ec0e4b06 			; <UNDEFINED> instruction: 0xec0e4b06
    17e4:	0100000f 	tsteq	r0, pc
    17e8:	0000071f 	andeq	r0, r0, pc, lsl r7
    17ec:	00000725 	andeq	r0, r0, r5, lsr #14
    17f0:	00082410 	andeq	r2, r8, r0, lsl r4
    17f4:	d4130000 	ldrle	r0, [r3], #-0
    17f8:	0600000f 	streq	r0, [r0], -pc
    17fc:	07df0e4d 	ldrbeq	r0, [pc, sp, asr #28]
    1800:	036e0000 	cmneq	lr, #0
    1804:	3e010000 	cdpcc	0, 0, cr0, cr1, cr0, {0}
    1808:	49000007 	stmdbmi	r0, {r0, r1, r2}
    180c:	10000007 	andne	r0, r0, r7
    1810:	00000824 	andeq	r0, r0, r4, lsr #16
    1814:	00004d11 	andeq	r4, r0, r1, lsl sp
    1818:	57130000 	ldrpl	r0, [r3, -r0]
    181c:	06000009 	streq	r0, [r0], -r9
    1820:	0ce91250 	sfmeq	f1, 2, [r9], #320	; 0x140
    1824:	004d0000 	subeq	r0, sp, r0
    1828:	62010000 	andvs	r0, r1, #0
    182c:	6d000007 	stcvs	0, cr0, [r0, #-28]	; 0xffffffe4
    1830:	10000007 	andne	r0, r0, r7
    1834:	00000824 	andeq	r0, r0, r4, lsr #16
    1838:	00039d11 	andeq	r9, r3, r1, lsl sp
    183c:	99130000 	ldmdbls	r3, {}	; <UNPREDICTABLE>
    1840:	06000004 	streq	r0, [r0], -r4
    1844:	08930e53 	ldmeq	r3, {r0, r1, r4, r6, r9, sl, fp}
    1848:	036e0000 	cmneq	lr, #0
    184c:	86010000 	strhi	r0, [r1], -r0
    1850:	91000007 	tstls	r0, r7
    1854:	10000007 	andne	r0, r0, r7
    1858:	00000824 	andeq	r0, r0, r4, lsr #16
    185c:	00004d11 	andeq	r4, r0, r1, lsl sp
    1860:	b9140000 	ldmdblt	r4, {}	; <UNPREDICTABLE>
    1864:	06000009 	streq	r0, [r0], -r9
    1868:	109f0e56 	addsne	r0, pc, r6, asr lr	; <UNPREDICTABLE>
    186c:	a6010000 	strge	r0, [r1], -r0
    1870:	c5000007 	strgt	r0, [r0, #-7]
    1874:	10000007 	andne	r0, r0, r7
    1878:	00000824 	andeq	r0, r0, r4, lsr #16
    187c:	0000a911 	andeq	sl, r0, r1, lsl r9
    1880:	004d1100 	subeq	r1, sp, r0, lsl #2
    1884:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    1888:	11000000 	mrsne	r0, (UNDEF: 0)
    188c:	0000004d 	andeq	r0, r0, sp, asr #32
    1890:	00085211 	andeq	r5, r8, r1, lsl r2
    1894:	83140000 	tsthi	r4, #0
    1898:	0600000f 	streq	r0, [r0], -pc
    189c:	07060e58 	smlsdeq	r6, r8, lr, r0
    18a0:	da010000 	ble	418a8 <__bss_end+0x38994>
    18a4:	f9000007 			; <UNDEFINED> instruction: 0xf9000007
    18a8:	10000007 	andne	r0, r0, r7
    18ac:	00000824 	andeq	r0, r0, r4, lsr #16
    18b0:	0000e011 	andeq	lr, r0, r1, lsl r0
    18b4:	004d1100 	subeq	r1, sp, r0, lsl #2
    18b8:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    18bc:	11000000 	mrsne	r0, (UNDEF: 0)
    18c0:	0000004d 	andeq	r0, r0, sp, asr #32
    18c4:	00085211 	andeq	r5, r8, r1, lsl r2
    18c8:	36150000 	ldrcc	r0, [r5], -r0
    18cc:	06000006 	streq	r0, [r0], -r6
    18d0:	06980e5b 			; <UNDEFINED> instruction: 0x06980e5b
    18d4:	036e0000 	cmneq	lr, #0
    18d8:	0e010000 	cdpeq	0, 0, cr0, cr1, cr0, {0}
    18dc:	10000008 	andne	r0, r0, r8
    18e0:	00000824 	andeq	r0, r0, r4, lsr #16
    18e4:	00051411 	andeq	r1, r5, r1, lsl r4
    18e8:	08581100 	ldmdaeq	r8, {r8, ip}^
    18ec:	00000000 	andeq	r0, r0, r0
    18f0:	00059d03 	andeq	r9, r5, r3, lsl #26
    18f4:	9d041800 	stcls	8, cr1, [r4, #-0]
    18f8:	1e000005 	cdpne	0, 0, cr0, cr0, cr5, {0}
    18fc:	00000591 	muleq	r0, r1, r5
    1900:	00000837 	andeq	r0, r0, r7, lsr r8
    1904:	0000083d 	andeq	r0, r0, sp, lsr r8
    1908:	00082410 	andeq	r2, r8, r0, lsl r4
    190c:	9d1f0000 	ldcls	0, cr0, [pc, #-0]	; 1914 <shift+0x1914>
    1910:	2a000005 	bcs	192c <shift+0x192c>
    1914:	18000008 	stmdane	r0, {r3}
    1918:	00003f04 	andeq	r3, r0, r4, lsl #30
    191c:	1f041800 	svcne	0x00041800
    1920:	20000008 	andcs	r0, r0, r8
    1924:	00006504 	andeq	r6, r0, r4, lsl #10
    1928:	1a042100 	bne	109d30 <__bss_end+0x100e1c>
    192c:	00000b6c 	andeq	r0, r0, ip, ror #22
    1930:	9d195e06 	ldcls	14, cr5, [r9, #-24]	; 0xffffffe8
    1934:	16000005 	strne	r0, [r0], -r5
    1938:	0000002c 	andeq	r0, r0, ip, lsr #32
    193c:	00000876 	andeq	r0, r0, r6, ror r8
    1940:	00005e17 	andeq	r5, r0, r7, lsl lr
    1944:	03000900 	movweq	r0, #2304	; 0x900
    1948:	00000866 	andeq	r0, r0, r6, ror #16
    194c:	00139c22 	andseq	r9, r3, r2, lsr #24
    1950:	0ca40100 	stfeqs	f0, [r4]
    1954:	00000876 	andeq	r0, r0, r6, ror r8
    1958:	8ee40305 	cdphi	3, 14, cr0, cr4, cr5, {0}
    195c:	a8230000 	stmdage	r3!, {}	; <UNPREDICTABLE>
    1960:	01000012 	tsteq	r0, r2, lsl r0
    1964:	14240aa6 	strtne	r0, [r4], #-2726	; 0xfffff55a
    1968:	004d0000 	subeq	r0, sp, r0
    196c:	86c00000 	strbhi	r0, [r0], r0
    1970:	00b00000 	adcseq	r0, r0, r0
    1974:	9c010000 	stcls	0, cr0, [r1], {-0}
    1978:	000008eb 	andeq	r0, r0, fp, ror #17
    197c:	00201524 	eoreq	r1, r0, r4, lsr #10
    1980:	1ba60100 	blne	fe981d88 <__bss_end+0xfe978e74>
    1984:	0000037b 	andeq	r0, r0, fp, ror r3
    1988:	7fac9103 	svcvc	0x00ac9103
    198c:	00148324 	andseq	r8, r4, r4, lsr #6
    1990:	2aa60100 	bcs	fe981d98 <__bss_end+0xfe978e84>
    1994:	0000004d 	andeq	r0, r0, sp, asr #32
    1998:	7fa89103 	svcvc	0x00a89103
    199c:	00140c22 	andseq	r0, r4, r2, lsr #24
    19a0:	0aa80100 	beq	fea01da8 <__bss_end+0xfe9f8e94>
    19a4:	000008eb 	andeq	r0, r0, fp, ror #17
    19a8:	7fb49103 	svcvc	0x00b49103
    19ac:	0012c722 	andseq	ip, r2, r2, lsr #14
    19b0:	09ac0100 	stmibeq	ip!, {r8}
    19b4:	00000038 	andeq	r0, r0, r8, lsr r0
    19b8:	00749102 	rsbseq	r9, r4, r2, lsl #2
    19bc:	00002516 	andeq	r2, r0, r6, lsl r5
    19c0:	0008fb00 	andeq	pc, r8, r0, lsl #22
    19c4:	005e1700 	subseq	r1, lr, r0, lsl #14
    19c8:	003f0000 	eorseq	r0, pc, r0
    19cc:	00146825 	andseq	r6, r4, r5, lsr #16
    19d0:	0a980100 	beq	fe601dd8 <__bss_end+0xfe5f8ec4>
    19d4:	000014bd 			; <UNDEFINED> instruction: 0x000014bd
    19d8:	0000004d 	andeq	r0, r0, sp, asr #32
    19dc:	00008684 	andeq	r8, r0, r4, lsl #13
    19e0:	0000003c 	andeq	r0, r0, ip, lsr r0
    19e4:	09389c01 	ldmdbeq	r8!, {r0, sl, fp, ip, pc}
    19e8:	72260000 	eorvc	r0, r6, #0
    19ec:	01007165 	tsteq	r0, r5, ror #2
    19f0:	0557209a 	ldrbeq	r2, [r7, #-154]	; 0xffffff66
    19f4:	91020000 	mrsls	r0, (UNDEF: 2)
    19f8:	14192274 	ldrne	r2, [r9], #-628	; 0xfffffd8c
    19fc:	9b010000 	blls	41a04 <__bss_end+0x38af0>
    1a00:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1a04:	70910200 	addsvc	r0, r1, r0, lsl #4
    1a08:	14922700 	ldrne	r2, [r2], #1792	; 0x700
    1a0c:	8f010000 	svchi	0x00010000
    1a10:	0012e306 	andseq	lr, r2, r6, lsl #6
    1a14:	00864800 	addeq	r4, r6, r0, lsl #16
    1a18:	00003c00 	andeq	r3, r0, r0, lsl #24
    1a1c:	719c0100 	orrsvc	r0, ip, r0, lsl #2
    1a20:	24000009 	strcs	r0, [r0], #-9
    1a24:	00001388 	andeq	r1, r0, r8, lsl #7
    1a28:	4d218f01 	stcmi	15, cr8, [r1, #-4]!
    1a2c:	02000000 	andeq	r0, r0, #0
    1a30:	72266c91 	eorvc	r6, r6, #37120	; 0x9100
    1a34:	01007165 	tsteq	r0, r5, ror #2
    1a38:	05572091 	ldrbeq	r2, [r7, #-145]	; 0xffffff6f
    1a3c:	91020000 	mrsls	r0, (UNDEF: 2)
    1a40:	45250074 	strmi	r0, [r5, #-116]!	; 0xffffff8c
    1a44:	01000014 	tsteq	r0, r4, lsl r0
    1a48:	13ad0a83 			; <UNDEFINED> instruction: 0x13ad0a83
    1a4c:	004d0000 	subeq	r0, sp, r0
    1a50:	860c0000 	strhi	r0, [ip], -r0
    1a54:	003c0000 	eorseq	r0, ip, r0
    1a58:	9c010000 	stcls	0, cr0, [r1], {-0}
    1a5c:	000009ae 	andeq	r0, r0, lr, lsr #19
    1a60:	71657226 	cmnvc	r5, r6, lsr #4
    1a64:	20850100 	addcs	r0, r5, r0, lsl #2
    1a68:	00000533 	andeq	r0, r0, r3, lsr r5
    1a6c:	22749102 	rsbscs	r9, r4, #-2147483648	; 0x80000000
    1a70:	000012c0 	andeq	r1, r0, r0, asr #5
    1a74:	4d0e8601 	stcmi	6, cr8, [lr, #-4]
    1a78:	02000000 	andeq	r0, r0, #0
    1a7c:	25007091 	strcs	r7, [r0, #-145]	; 0xffffff6f
    1a80:	00001554 	andeq	r1, r0, r4, asr r5
    1a84:	5e0a7701 	cdppl	7, 0, cr7, cr10, cr1, {0}
    1a88:	4d000013 	stcmi	0, cr0, [r0, #-76]	; 0xffffffb4
    1a8c:	d0000000 	andle	r0, r0, r0
    1a90:	3c000085 	stccc	0, cr0, [r0], {133}	; 0x85
    1a94:	01000000 	mrseq	r0, (UNDEF: 0)
    1a98:	0009eb9c 	muleq	r9, ip, fp
    1a9c:	65722600 	ldrbvs	r2, [r2, #-1536]!	; 0xfffffa00
    1aa0:	79010071 	stmdbvc	r1, {r0, r4, r5, r6}
    1aa4:	00053320 	andeq	r3, r5, r0, lsr #6
    1aa8:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1aac:	0012c022 	andseq	ip, r2, r2, lsr #32
    1ab0:	0e7a0100 	rpweqe	f0, f2, f0
    1ab4:	0000004d 	andeq	r0, r0, sp, asr #32
    1ab8:	00709102 	rsbseq	r9, r0, r2, lsl #2
    1abc:	0013c125 	andseq	ip, r3, r5, lsr #2
    1ac0:	066b0100 	strbteq	r0, [fp], -r0, lsl #2
    1ac4:	000014a4 	andeq	r1, r0, r4, lsr #9
    1ac8:	0000036e 	andeq	r0, r0, lr, ror #6
    1acc:	0000857c 	andeq	r8, r0, ip, ror r5
    1ad0:	00000054 	andeq	r0, r0, r4, asr r0
    1ad4:	0a379c01 	beq	de8ae0 <__bss_end+0xddfbcc>
    1ad8:	19240000 	stmdbne	r4!, {}	; <UNPREDICTABLE>
    1adc:	01000014 	tsteq	r0, r4, lsl r0
    1ae0:	004d156b 	subeq	r1, sp, fp, ror #10
    1ae4:	91020000 	mrsls	r0, (UNDEF: 2)
    1ae8:	0824246c 	stmdaeq	r4!, {r2, r3, r5, r6, sl, sp}
    1aec:	6b010000 	blvs	41af4 <__bss_end+0x38be0>
    1af0:	00004d25 	andeq	r4, r0, r5, lsr #26
    1af4:	68910200 	ldmvs	r1, {r9}
    1af8:	00154c22 	andseq	r4, r5, r2, lsr #24
    1afc:	0e6d0100 	poweqe	f0, f5, f0
    1b00:	0000004d 	andeq	r0, r0, sp, asr #32
    1b04:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1b08:	0012fa25 	andseq	pc, r2, r5, lsr #20
    1b0c:	125e0100 	subsne	r0, lr, #0, 2
    1b10:	000014f4 	strdeq	r1, [r0], -r4
    1b14:	0000008b 	andeq	r0, r0, fp, lsl #1
    1b18:	0000852c 	andeq	r8, r0, ip, lsr #10
    1b1c:	00000050 	andeq	r0, r0, r0, asr r0
    1b20:	0a929c01 	beq	fe4a8b2c <__bss_end+0xfe49fc18>
    1b24:	6f240000 	svcvs	0x00240000
    1b28:	0100000e 	tsteq	r0, lr
    1b2c:	004d205e 	subeq	r2, sp, lr, asr r0
    1b30:	91020000 	mrsls	r0, (UNDEF: 2)
    1b34:	144e246c 	strbne	r2, [lr], #-1132	; 0xfffffb94
    1b38:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
    1b3c:	00004d2f 	andeq	r4, r0, pc, lsr #26
    1b40:	68910200 	ldmvs	r1, {r9}
    1b44:	00082424 	andeq	r2, r8, r4, lsr #8
    1b48:	3f5e0100 	svccc	0x005e0100
    1b4c:	0000004d 	andeq	r0, r0, sp, asr #32
    1b50:	22649102 	rsbcs	r9, r4, #-2147483648	; 0x80000000
    1b54:	0000154c 	andeq	r1, r0, ip, asr #10
    1b58:	8b166001 	blhi	599b64 <__bss_end+0x590c50>
    1b5c:	02000000 	andeq	r0, r0, #0
    1b60:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    1b64:	00001412 	andeq	r1, r0, r2, lsl r4
    1b68:	ff0a5201 			; <UNDEFINED> instruction: 0xff0a5201
    1b6c:	4d000012 	stcmi	0, cr0, [r0, #-72]	; 0xffffffb8
    1b70:	e8000000 	stmda	r0, {}	; <UNPREDICTABLE>
    1b74:	44000084 	strmi	r0, [r0], #-132	; 0xffffff7c
    1b78:	01000000 	mrseq	r0, (UNDEF: 0)
    1b7c:	000ade9c 	muleq	sl, ip, lr
    1b80:	0e6f2400 	cdpeq	4, 6, cr2, cr15, cr0, {0}
    1b84:	52010000 	andpl	r0, r1, #0
    1b88:	00004d1a 	andeq	r4, r0, sl, lsl sp
    1b8c:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1b90:	00144e24 	andseq	r4, r4, r4, lsr #28
    1b94:	29520100 	ldmdbcs	r2, {r8}^
    1b98:	0000004d 	andeq	r0, r0, sp, asr #32
    1b9c:	22689102 	rsbcs	r9, r8, #-2147483648	; 0x80000000
    1ba0:	00001523 	andeq	r1, r0, r3, lsr #10
    1ba4:	4d0e5401 	cfstrsmi	mvf5, [lr, #-4]
    1ba8:	02000000 	andeq	r0, r0, #0
    1bac:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    1bb0:	0000151d 	andeq	r1, r0, sp, lsl r5
    1bb4:	ff0a4501 			; <UNDEFINED> instruction: 0xff0a4501
    1bb8:	4d000014 	stcmi	0, cr0, [r0, #-80]	; 0xffffffb0
    1bbc:	98000000 	stmdals	r0, {}	; <UNPREDICTABLE>
    1bc0:	50000084 	andpl	r0, r0, r4, lsl #1
    1bc4:	01000000 	mrseq	r0, (UNDEF: 0)
    1bc8:	000b399c 	muleq	fp, ip, r9
    1bcc:	0e6f2400 	cdpeq	4, 6, cr2, cr15, cr0, {0}
    1bd0:	45010000 	strmi	r0, [r1, #-0]
    1bd4:	00004d19 	andeq	r4, r0, r9, lsl sp
    1bd8:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1bdc:	0013ed24 	andseq	lr, r3, r4, lsr #26
    1be0:	30450100 	subcc	r0, r5, r0, lsl #2
    1be4:	0000011d 	andeq	r0, r0, sp, lsl r1
    1be8:	24689102 	strbtcs	r9, [r8], #-258	; 0xfffffefe
    1bec:	00001454 	andeq	r1, r0, r4, asr r4
    1bf0:	58414501 	stmdapl	r1, {r0, r8, sl, lr}^
    1bf4:	02000008 	andeq	r0, r0, #8
    1bf8:	4c226491 	cfstrsmi	mvf6, [r2], #-580	; 0xfffffdbc
    1bfc:	01000015 	tsteq	r0, r5, lsl r0
    1c00:	004d0e47 	subeq	r0, sp, r7, asr #28
    1c04:	91020000 	mrsls	r0, (UNDEF: 2)
    1c08:	ad270074 	stcge	0, cr0, [r7, #-464]!	; 0xfffffe30
    1c0c:	01000012 	tsteq	r0, r2, lsl r0
    1c10:	13f7063f 	mvnsne	r0, #66060288	; 0x3f00000
    1c14:	846c0000 	strbthi	r0, [ip], #-0
    1c18:	002c0000 	eoreq	r0, ip, r0
    1c1c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1c20:	00000b63 	andeq	r0, r0, r3, ror #22
    1c24:	000e6f24 	andeq	r6, lr, r4, lsr #30
    1c28:	153f0100 	ldrne	r0, [pc, #-256]!	; 1b30 <shift+0x1b30>
    1c2c:	0000004d 	andeq	r0, r0, sp, asr #32
    1c30:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1c34:	00148c25 	andseq	r8, r4, r5, lsr #24
    1c38:	0a320100 	beq	c82040 <__bss_end+0xc7912c>
    1c3c:	0000145a 	andeq	r1, r0, sl, asr r4
    1c40:	0000004d 	andeq	r0, r0, sp, asr #32
    1c44:	0000841c 	andeq	r8, r0, ip, lsl r4
    1c48:	00000050 	andeq	r0, r0, r0, asr r0
    1c4c:	0bbe9c01 	bleq	fefa8c58 <__bss_end+0xfef9fd44>
    1c50:	6f240000 	svcvs	0x00240000
    1c54:	0100000e 	tsteq	r0, lr
    1c58:	004d1932 	subeq	r1, sp, r2, lsr r9
    1c5c:	91020000 	mrsls	r0, (UNDEF: 2)
    1c60:	1539246c 	ldrne	r2, [r9, #-1132]!	; 0xfffffb94
    1c64:	32010000 	andcc	r0, r1, #0
    1c68:	00037b2b 	andeq	r7, r3, fp, lsr #22
    1c6c:	68910200 	ldmvs	r1, {r9}
    1c70:	00148724 	andseq	r8, r4, r4, lsr #14
    1c74:	3c320100 	ldfccs	f0, [r2], #-0
    1c78:	0000004d 	andeq	r0, r0, sp, asr #32
    1c7c:	22649102 	rsbcs	r9, r4, #-2147483648	; 0x80000000
    1c80:	000014ee 	andeq	r1, r0, lr, ror #9
    1c84:	4d0e3401 	cfstrsmi	mvf3, [lr, #-4]
    1c88:	02000000 	andeq	r0, r0, #0
    1c8c:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    1c90:	00001576 	andeq	r1, r0, r6, ror r5
    1c94:	400a2501 	andmi	r2, sl, r1, lsl #10
    1c98:	4d000015 	stcmi	0, cr0, [r0, #-84]	; 0xffffffac
    1c9c:	cc000000 	stcgt	0, cr0, [r0], {-0}
    1ca0:	50000083 	andpl	r0, r0, r3, lsl #1
    1ca4:	01000000 	mrseq	r0, (UNDEF: 0)
    1ca8:	000c199c 	muleq	ip, ip, r9
    1cac:	0e6f2400 	cdpeq	4, 6, cr2, cr15, cr0, {0}
    1cb0:	25010000 	strcs	r0, [r1, #-0]
    1cb4:	00004d18 	andeq	r4, r0, r8, lsl sp
    1cb8:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1cbc:	00153924 	andseq	r3, r5, r4, lsr #18
    1cc0:	2a250100 	bcs	9420c8 <__bss_end+0x9391b4>
    1cc4:	00000c1f 	andeq	r0, r0, pc, lsl ip
    1cc8:	24689102 	strbtcs	r9, [r8], #-258	; 0xfffffefe
    1ccc:	00001487 	andeq	r1, r0, r7, lsl #9
    1cd0:	4d3b2501 	cfldr32mi	mvfx2, [fp, #-4]!
    1cd4:	02000000 	andeq	r0, r0, #0
    1cd8:	cc226491 	cfstrsgt	mvf6, [r2], #-580	; 0xfffffdbc
    1cdc:	01000012 	tsteq	r0, r2, lsl r0
    1ce0:	004d0e27 	subeq	r0, sp, r7, lsr #28
    1ce4:	91020000 	mrsls	r0, (UNDEF: 2)
    1ce8:	04180074 	ldreq	r0, [r8], #-116	; 0xffffff8c
    1cec:	00000025 	andeq	r0, r0, r5, lsr #32
    1cf0:	000c1903 	andeq	r1, ip, r3, lsl #18
    1cf4:	141f2500 	ldrne	r2, [pc], #-1280	; 1cfc <shift+0x1cfc>
    1cf8:	19010000 	stmdbne	r1, {}	; <UNPREDICTABLE>
    1cfc:	0015820a 	andseq	r8, r5, sl, lsl #4
    1d00:	00004d00 	andeq	r4, r0, r0, lsl #26
    1d04:	00838800 	addeq	r8, r3, r0, lsl #16
    1d08:	00004400 	andeq	r4, r0, r0, lsl #8
    1d0c:	709c0100 	addsvc	r0, ip, r0, lsl #2
    1d10:	2400000c 	strcs	r0, [r0], #-12
    1d14:	0000156d 	andeq	r1, r0, sp, ror #10
    1d18:	7b1b1901 	blvc	6c8124 <__bss_end+0x6bf210>
    1d1c:	02000003 	andeq	r0, r0, #3
    1d20:	34246c91 	strtcc	r6, [r4], #-3217	; 0xfffff36f
    1d24:	01000015 	tsteq	r0, r5, lsl r0
    1d28:	01c63519 	biceq	r3, r6, r9, lsl r5
    1d2c:	91020000 	mrsls	r0, (UNDEF: 2)
    1d30:	0e6f2268 	cdpeq	2, 6, cr2, cr15, cr8, {3}
    1d34:	1b010000 	blne	41d3c <__bss_end+0x38e28>
    1d38:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1d3c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1d40:	137c2800 	cmnne	ip, #0, 16
    1d44:	14010000 	strne	r0, [r1], #-0
    1d48:	0012d206 	andseq	sp, r2, r6, lsl #4
    1d4c:	00836c00 	addeq	r6, r3, r0, lsl #24
    1d50:	00001c00 	andeq	r1, r0, r0, lsl #24
    1d54:	279c0100 	ldrcs	r0, [ip, r0, lsl #2]
    1d58:	0000152a 	andeq	r1, r0, sl, lsr #10
    1d5c:	0b060e01 	bleq	185568 <__bss_end+0x17c654>
    1d60:	40000013 	andmi	r0, r0, r3, lsl r0
    1d64:	2c000083 	stccs	0, cr0, [r0], {131}	; 0x83
    1d68:	01000000 	mrseq	r0, (UNDEF: 0)
    1d6c:	000cb09c 	muleq	ip, ip, r0
    1d70:	13552400 	cmpne	r5, #0, 8
    1d74:	0e010000 	cdpeq	0, 0, cr0, cr1, cr0, {0}
    1d78:	00003814 	andeq	r3, r0, r4, lsl r8
    1d7c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1d80:	157b2900 	ldrbne	r2, [fp, #-2304]!	; 0xfffff700
    1d84:	04010000 	streq	r0, [r1], #-0
    1d88:	0014010a 	andseq	r0, r4, sl, lsl #2
    1d8c:	00004d00 	andeq	r4, r0, r0, lsl #26
    1d90:	00831400 	addeq	r1, r3, r0, lsl #8
    1d94:	00002c00 	andeq	r2, r0, r0, lsl #24
    1d98:	269c0100 	ldrcs	r0, [ip], r0, lsl #2
    1d9c:	00646970 	rsbeq	r6, r4, r0, ror r9
    1da0:	4d0e0601 	stcmi	6, cr0, [lr, #-4]
    1da4:	02000000 	andeq	r0, r0, #0
    1da8:	00007491 	muleq	r0, r1, r4
    1dac:	0000032e 	andeq	r0, r0, lr, lsr #6
    1db0:	06f70004 	ldrbteq	r0, [r7], r4
    1db4:	01040000 	mrseq	r0, (UNDEF: 4)
    1db8:	0000159e 	muleq	r0, lr, r5
    1dbc:	0016a004 	andseq	sl, r6, r4
    1dc0:	0013c700 	andseq	ip, r3, r0, lsl #14
    1dc4:	00877000 	addeq	r7, r7, r0
    1dc8:	0004b800 	andeq	fp, r4, r0, lsl #16
    1dcc:	00067a00 	andeq	r7, r6, r0, lsl #20
    1dd0:	00490200 	subeq	r0, r9, r0, lsl #4
    1dd4:	d9030000 	stmdble	r3, {}	; <UNPREDICTABLE>
    1dd8:	01000016 	tsteq	r0, r6, lsl r0
    1ddc:	00611005 	rsbeq	r1, r1, r5
    1de0:	30110000 	andscc	r0, r1, r0
    1de4:	34333231 	ldrtcc	r3, [r3], #-561	; 0xfffffdcf
    1de8:	38373635 	ldmdacc	r7!, {r0, r2, r4, r5, r9, sl, ip, sp}
    1dec:	43424139 	movtmi	r4, #8505	; 0x2139
    1df0:	00464544 	subeq	r4, r6, r4, asr #10
    1df4:	03010400 	movweq	r0, #5120	; 0x1400
    1df8:	00002501 	andeq	r2, r0, r1, lsl #10
    1dfc:	00740500 	rsbseq	r0, r4, r0, lsl #10
    1e00:	00610000 	rsbeq	r0, r1, r0
    1e04:	66060000 	strvs	r0, [r6], -r0
    1e08:	10000000 	andne	r0, r0, r0
    1e0c:	00510700 	subseq	r0, r1, r0, lsl #14
    1e10:	04080000 	streq	r0, [r8], #-0
    1e14:	001ca507 	andseq	sl, ip, r7, lsl #10
    1e18:	08010800 	stmdaeq	r1, {fp}
    1e1c:	00000d5c 	andeq	r0, r0, ip, asr sp
    1e20:	00006d07 	andeq	r6, r0, r7, lsl #26
    1e24:	002a0900 	eoreq	r0, sl, r0, lsl #18
    1e28:	080a0000 	stmdaeq	sl, {}	; <UNPREDICTABLE>
    1e2c:	01000017 	tsteq	r0, r7, lsl r0
    1e30:	16f30664 	ldrbtne	r0, [r3], r4, ror #12
    1e34:	8ba80000 	blhi	fea01e3c <__bss_end+0xfe9f8f28>
    1e38:	00800000 	addeq	r0, r0, r0
    1e3c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1e40:	000000fb 	strdeq	r0, [r0], -fp
    1e44:	6372730b 	cmnvs	r2, #738197504	; 0x2c000000
    1e48:	19640100 	stmdbne	r4!, {r8}^
    1e4c:	000000fb 	strdeq	r0, [r0], -fp
    1e50:	0b649102 	bleq	1926260 <__bss_end+0x191d34c>
    1e54:	00747364 	rsbseq	r7, r4, r4, ror #6
    1e58:	02246401 	eoreq	r6, r4, #16777216	; 0x1000000
    1e5c:	02000001 	andeq	r0, r0, #1
    1e60:	6e0b6091 	mcrvs	0, 0, r6, cr11, cr1, {4}
    1e64:	01006d75 	tsteq	r0, r5, ror sp
    1e68:	01042d64 	tsteq	r4, r4, ror #26
    1e6c:	91020000 	mrsls	r0, (UNDEF: 2)
    1e70:	17620c5c 			; <UNDEFINED> instruction: 0x17620c5c
    1e74:	66010000 	strvs	r0, [r1], -r0
    1e78:	00010b0e 	andeq	r0, r1, lr, lsl #22
    1e7c:	70910200 	addsvc	r0, r1, r0, lsl #4
    1e80:	0016e50c 	andseq	lr, r6, ip, lsl #10
    1e84:	08670100 	stmdaeq	r7!, {r8}^
    1e88:	00000111 	andeq	r0, r0, r1, lsl r1
    1e8c:	0d6c9102 	stfeqp	f1, [ip, #-8]!
    1e90:	00008bd0 	ldrdeq	r8, [r0], -r0
    1e94:	00000048 	andeq	r0, r0, r8, asr #32
    1e98:	0100690e 	tsteq	r0, lr, lsl #18
    1e9c:	01040b69 	tsteq	r4, r9, ror #22
    1ea0:	91020000 	mrsls	r0, (UNDEF: 2)
    1ea4:	0f000074 	svceq	0x00000074
    1ea8:	00010104 	andeq	r0, r1, r4, lsl #2
    1eac:	04111000 	ldreq	r1, [r1], #-0
    1eb0:	69050412 	stmdbvs	r5, {r1, r4, sl}
    1eb4:	0f00746e 	svceq	0x0000746e
    1eb8:	00007404 	andeq	r7, r0, r4, lsl #8
    1ebc:	6d040f00 	stcvs	15, cr0, [r4, #-0]
    1ec0:	0a000000 	beq	1ec8 <shift+0x1ec8>
    1ec4:	0000167c 	andeq	r1, r0, ip, ror r6
    1ec8:	89065c01 	stmdbhi	r6, {r0, sl, fp, ip, lr}
    1ecc:	40000016 	andmi	r0, r0, r6, lsl r0
    1ed0:	6800008b 	stmdavs	r0, {r0, r1, r3, r7}
    1ed4:	01000000 	mrseq	r0, (UNDEF: 0)
    1ed8:	0001769c 	muleq	r1, ip, r6
    1edc:	175b1300 	ldrbne	r1, [fp, -r0, lsl #6]
    1ee0:	5c010000 	stcpl	0, cr0, [r1], {-0}
    1ee4:	00010212 	andeq	r0, r1, r2, lsl r2
    1ee8:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1eec:	00168213 	andseq	r8, r6, r3, lsl r2
    1ef0:	1e5c0100 	rdfnee	f0, f4, f0
    1ef4:	00000104 	andeq	r0, r0, r4, lsl #2
    1ef8:	0e689102 	lgneqe	f1, f2
    1efc:	006d656d 	rsbeq	r6, sp, sp, ror #10
    1f00:	11085e01 	tstne	r8, r1, lsl #28
    1f04:	02000001 	andeq	r0, r0, #1
    1f08:	5c0d7091 	stcpl	0, cr7, [sp], {145}	; 0x91
    1f0c:	3c00008b 	stccc	0, cr0, [r0], {139}	; 0x8b
    1f10:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    1f14:	60010069 	andvs	r0, r1, r9, rrx
    1f18:	0001040b 	andeq	r0, r1, fp, lsl #8
    1f1c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1f20:	0f140000 	svceq	0x00140000
    1f24:	01000017 	tsteq	r0, r7, lsl r0
    1f28:	17280552 			; <UNDEFINED> instruction: 0x17280552
    1f2c:	01040000 	mrseq	r0, (UNDEF: 4)
    1f30:	8aec0000 	bhi	ffb01f38 <__bss_end+0xffaf9024>
    1f34:	00540000 	subseq	r0, r4, r0
    1f38:	9c010000 	stcls	0, cr0, [r1], {-0}
    1f3c:	000001af 	andeq	r0, r0, pc, lsr #3
    1f40:	0100730b 	tsteq	r0, fp, lsl #6
    1f44:	010b1852 	tsteq	fp, r2, asr r8
    1f48:	91020000 	mrsls	r0, (UNDEF: 2)
    1f4c:	00690e6c 	rsbeq	r0, r9, ip, ror #28
    1f50:	04065401 	streq	r5, [r6], #-1025	; 0xfffffbff
    1f54:	02000001 	andeq	r0, r0, #1
    1f58:	14007491 	strne	r7, [r0], #-1169	; 0xfffffb6f
    1f5c:	0000174b 	andeq	r1, r0, fp, asr #14
    1f60:	16054201 	strne	r4, [r5], -r1, lsl #4
    1f64:	04000017 	streq	r0, [r0], #-23	; 0xffffffe9
    1f68:	40000001 	andmi	r0, r0, r1
    1f6c:	ac00008a 	stcge	0, cr0, [r0], {138}	; 0x8a
    1f70:	01000000 	mrseq	r0, (UNDEF: 0)
    1f74:	0002159c 	muleq	r2, ip, r5
    1f78:	31730b00 	cmncc	r3, r0, lsl #22
    1f7c:	19420100 	stmdbne	r2, {r8}^
    1f80:	0000010b 	andeq	r0, r0, fp, lsl #2
    1f84:	0b6c9102 	bleq	1b26394 <__bss_end+0x1b1d480>
    1f88:	01003273 	tsteq	r0, r3, ror r2
    1f8c:	010b2942 	tsteq	fp, r2, asr #18
    1f90:	91020000 	mrsls	r0, (UNDEF: 2)
    1f94:	756e0b68 	strbvc	r0, [lr, #-2920]!	; 0xfffff498
    1f98:	4201006d 	andmi	r0, r1, #109	; 0x6d
    1f9c:	00010431 	andeq	r0, r1, r1, lsr r4
    1fa0:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1fa4:	0031750e 	eorseq	r7, r1, lr, lsl #10
    1fa8:	15104401 	ldrne	r4, [r0, #-1025]	; 0xfffffbff
    1fac:	02000002 	andeq	r0, r0, #2
    1fb0:	750e7791 	strvc	r7, [lr, #-1937]	; 0xfffff86f
    1fb4:	44010032 	strmi	r0, [r1], #-50	; 0xffffffce
    1fb8:	00021514 	andeq	r1, r2, r4, lsl r5
    1fbc:	76910200 	ldrvc	r0, [r1], r0, lsl #4
    1fc0:	08010800 	stmdaeq	r1, {fp}
    1fc4:	00000d53 	andeq	r0, r0, r3, asr sp
    1fc8:	00175314 	andseq	r5, r7, r4, lsl r3
    1fcc:	07360100 	ldreq	r0, [r6, -r0, lsl #2]!
    1fd0:	0000173a 	andeq	r1, r0, sl, lsr r7
    1fd4:	00000111 	andeq	r0, r0, r1, lsl r1
    1fd8:	00008980 	andeq	r8, r0, r0, lsl #19
    1fdc:	000000c0 	andeq	r0, r0, r0, asr #1
    1fe0:	02759c01 	rsbseq	r9, r5, #256	; 0x100
    1fe4:	77130000 	ldrvc	r0, [r3, -r0]
    1fe8:	01000016 	tsteq	r0, r6, lsl r0
    1fec:	01111536 	tsteq	r1, r6, lsr r5
    1ff0:	91020000 	mrsls	r0, (UNDEF: 2)
    1ff4:	72730b6c 	rsbsvc	r0, r3, #108, 22	; 0x1b000
    1ff8:	36010063 	strcc	r0, [r1], -r3, rrx
    1ffc:	00010b27 	andeq	r0, r1, r7, lsr #22
    2000:	68910200 	ldmvs	r1, {r9}
    2004:	6d756e0b 	ldclvs	14, cr6, [r5, #-44]!	; 0xffffffd4
    2008:	30360100 	eorscc	r0, r6, r0, lsl #2
    200c:	00000104 	andeq	r0, r0, r4, lsl #2
    2010:	0e649102 	lgneqs	f1, f2
    2014:	38010069 	stmdacc	r1, {r0, r3, r5, r6}
    2018:	00010406 	andeq	r0, r1, r6, lsl #8
    201c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2020:	17351400 	ldrne	r1, [r5, -r0, lsl #8]!
    2024:	24010000 	strcs	r0, [r1], #-0
    2028:	00169505 	andseq	r9, r6, r5, lsl #10
    202c:	00010400 	andeq	r0, r1, r0, lsl #8
    2030:	0088e400 	addeq	lr, r8, r0, lsl #8
    2034:	00009c00 	andeq	r9, r0, r0, lsl #24
    2038:	b29c0100 	addslt	r0, ip, #0, 2
    203c:	13000002 	movwne	r0, #2
    2040:	00001671 	andeq	r1, r0, r1, ror r6
    2044:	0b162401 	bleq	58b050 <__bss_end+0x58213c>
    2048:	02000001 	andeq	r0, r0, #1
    204c:	ec0c6c91 	stc	12, cr6, [ip], {145}	; 0x91
    2050:	01000016 	tsteq	r0, r6, lsl r0
    2054:	01040626 	tsteq	r4, r6, lsr #12
    2058:	91020000 	mrsls	r0, (UNDEF: 2)
    205c:	69150074 	ldmdbvs	r5, {r2, r4, r5, r6}
    2060:	01000017 	tsteq	r0, r7, lsl r0
    2064:	176e0608 	strbne	r0, [lr, -r8, lsl #12]!
    2068:	87700000 	ldrbhi	r0, [r0, -r0]!
    206c:	01740000 	cmneq	r4, r0
    2070:	9c010000 	stcls	0, cr0, [r1], {-0}
    2074:	00167113 	andseq	r7, r6, r3, lsl r1
    2078:	18080100 	stmdane	r8, {r8}
    207c:	00000066 	andeq	r0, r0, r6, rrx
    2080:	13649102 	cmnne	r4, #-2147483648	; 0x80000000
    2084:	000016ec 	andeq	r1, r0, ip, ror #13
    2088:	11250801 			; <UNDEFINED> instruction: 0x11250801
    208c:	02000001 	andeq	r0, r0, #1
    2090:	03136091 	tsteq	r3, #145	; 0x91
    2094:	01000017 	tsteq	r0, r7, lsl r0
    2098:	00663a08 	rsbeq	r3, r6, r8, lsl #20
    209c:	91020000 	mrsls	r0, (UNDEF: 2)
    20a0:	00690e5c 	rsbeq	r0, r9, ip, asr lr
    20a4:	04060a01 	streq	r0, [r6], #-2561	; 0xfffff5ff
    20a8:	02000001 	andeq	r0, r0, #1
    20ac:	3c0d7491 	cfstrscc	mvf7, [sp], {145}	; 0x91
    20b0:	98000088 	stmdals	r0, {r3, r7}
    20b4:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    20b8:	1c01006a 	stcne	0, cr0, [r1], {106}	; 0x6a
    20bc:	0001040b 	andeq	r0, r1, fp, lsl #8
    20c0:	70910200 	addsvc	r0, r1, r0, lsl #4
    20c4:	0088640d 	addeq	r6, r8, sp, lsl #8
    20c8:	00006000 	andeq	r6, r0, r0
    20cc:	00630e00 	rsbeq	r0, r3, r0, lsl #28
    20d0:	6d081e01 	stcvs	14, cr1, [r8, #-4]
    20d4:	02000000 	andeq	r0, r0, #0
    20d8:	00006f91 	muleq	r0, r1, pc	; <UNPREDICTABLE>
    20dc:	00220000 	eoreq	r0, r2, r0
    20e0:	00020000 	andeq	r0, r2, r0
    20e4:	0000081e 	andeq	r0, r0, lr, lsl r8
    20e8:	08f40104 	ldmeq	r4!, {r2, r8}^
    20ec:	8c280000 	stchi	0, cr0, [r8], #-0
    20f0:	8e340000 	cdphi	0, 3, cr0, cr4, cr0, {0}
    20f4:	177a0000 	ldrbne	r0, [sl, -r0]!
    20f8:	17aa0000 	strne	r0, [sl, r0]!
    20fc:	00610000 	rsbeq	r0, r1, r0
    2100:	80010000 	andhi	r0, r1, r0
    2104:	00000022 	andeq	r0, r0, r2, lsr #32
    2108:	08320002 	ldmdaeq	r2!, {r1}
    210c:	01040000 	mrseq	r0, (UNDEF: 4)
    2110:	00000971 	andeq	r0, r0, r1, ror r9
    2114:	00008e34 	andeq	r8, r0, r4, lsr lr
    2118:	00008e38 	andeq	r8, r0, r8, lsr lr
    211c:	0000177a 	andeq	r1, r0, sl, ror r7
    2120:	000017aa 	andeq	r1, r0, sl, lsr #15
    2124:	00000061 	andeq	r0, r0, r1, rrx
    2128:	09328001 	ldmdbeq	r2!, {r0, pc}
    212c:	00040000 	andeq	r0, r4, r0
    2130:	00000846 	andeq	r0, r0, r6, asr #16
    2134:	1b780104 	blne	1e0254c <__bss_end+0x1df9638>
    2138:	cf0c0000 	svcgt	0x000c0000
    213c:	aa00001a 	bge	21ac <shift+0x21ac>
    2140:	d1000017 	tstle	r0, r7, lsl r0
    2144:	02000009 	andeq	r0, r0, #9
    2148:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    214c:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
    2150:	001ca507 	andseq	sl, ip, r7, lsl #10
    2154:	05080300 	streq	r0, [r8, #-768]	; 0xfffffd00
    2158:	00000357 	andeq	r0, r0, r7, asr r3
    215c:	77040803 	strvc	r0, [r4, -r3, lsl #16]
    2160:	04000023 	streq	r0, [r0], #-35	; 0xffffffdd
    2164:	00001b2a 	andeq	r1, r0, sl, lsr #22
    2168:	24162a01 	ldrcs	r2, [r6], #-2561	; 0xfffff5ff
    216c:	04000000 	streq	r0, [r0], #-0
    2170:	00001f99 	muleq	r0, r9, pc	; <UNPREDICTABLE>
    2174:	51152f01 	tstpl	r5, r1, lsl #30
    2178:	05000000 	streq	r0, [r0, #-0]
    217c:	00005704 	andeq	r5, r0, r4, lsl #14
    2180:	00390600 	eorseq	r0, r9, r0, lsl #12
    2184:	00660000 	rsbeq	r0, r6, r0
    2188:	66070000 	strvs	r0, [r7], -r0
    218c:	00000000 	andeq	r0, r0, r0
    2190:	006c0405 	rsbeq	r0, ip, r5, lsl #8
    2194:	04080000 	streq	r0, [r8], #-0
    2198:	000026cb 	andeq	r2, r0, fp, asr #13
    219c:	790f3601 	stmdbvc	pc, {r0, r9, sl, ip, sp}	; <UNPREDICTABLE>
    21a0:	05000000 	streq	r0, [r0, #-0]
    21a4:	00007f04 	andeq	r7, r0, r4, lsl #30
    21a8:	001d0600 	andseq	r0, sp, r0, lsl #12
    21ac:	00930000 	addseq	r0, r3, r0
    21b0:	66070000 	strvs	r0, [r7], -r0
    21b4:	07000000 	streq	r0, [r0, -r0]
    21b8:	00000066 	andeq	r0, r0, r6, rrx
    21bc:	08010300 	stmdaeq	r1, {r8, r9}
    21c0:	00000d53 	andeq	r0, r0, r3, asr sp
    21c4:	0021d109 	eoreq	sp, r1, r9, lsl #2
    21c8:	12bb0100 	adcsne	r0, fp, #0, 2
    21cc:	00000045 	andeq	r0, r0, r5, asr #32
    21d0:	0026f909 	eoreq	pc, r6, r9, lsl #18
    21d4:	10be0100 	adcsne	r0, lr, r0, lsl #2
    21d8:	0000006d 	andeq	r0, r0, sp, rrx
    21dc:	55060103 	strpl	r0, [r6, #-259]	; 0xfffffefd
    21e0:	0a00000d 	beq	221c <shift+0x221c>
    21e4:	00001eb9 			; <UNDEFINED> instruction: 0x00001eb9
    21e8:	00930107 	addseq	r0, r3, r7, lsl #2
    21ec:	17020000 	strne	r0, [r2, -r0]
    21f0:	0001e606 	andeq	lr, r1, r6, lsl #12
    21f4:	19880b00 	stmibne	r8, {r8, r9, fp}
    21f8:	0b000000 	bleq	2200 <shift+0x2200>
    21fc:	00001dd6 	ldrdeq	r1, [r0], -r6
    2200:	229c0b01 	addscs	r0, ip, #1024	; 0x400
    2204:	0b020000 	bleq	8220c <__bss_end+0x792f8>
    2208:	0000260d 	andeq	r2, r0, sp, lsl #12
    220c:	22400b03 	subcs	r0, r0, #3072	; 0xc00
    2210:	0b040000 	bleq	102218 <__bss_end+0xf9304>
    2214:	00002516 	andeq	r2, r0, r6, lsl r5
    2218:	247a0b05 	ldrbtcs	r0, [sl], #-2821	; 0xfffff4fb
    221c:	0b060000 	bleq	182224 <__bss_end+0x179310>
    2220:	000019a9 	andeq	r1, r0, r9, lsr #19
    2224:	252b0b07 	strcs	r0, [fp, #-2823]!	; 0xfffff4f9
    2228:	0b080000 	bleq	202230 <__bss_end+0x1f931c>
    222c:	00002539 	andeq	r2, r0, r9, lsr r5
    2230:	26000b09 	strcs	r0, [r0], -r9, lsl #22
    2234:	0b0a0000 	bleq	28223c <__bss_end+0x279328>
    2238:	00002197 	muleq	r0, r7, r1
    223c:	1b6b0b0b 	blne	1ac4e70 <__bss_end+0x1abbf5c>
    2240:	0b0c0000 	bleq	302248 <__bss_end+0x2f9334>
    2244:	00001c48 	andeq	r1, r0, r8, asr #24
    2248:	1efd0b0d 	vmovne.f64	d16, #221	; 0xbee80000 -0.4531250
    224c:	0b0e0000 	bleq	382254 <__bss_end+0x379340>
    2250:	00001f13 	andeq	r1, r0, r3, lsl pc
    2254:	1e100b0f 	vnmlsne.f64	d0, d0, d15
    2258:	0b100000 	bleq	402260 <__bss_end+0x3f934c>
    225c:	00002224 	andeq	r2, r0, r4, lsr #4
    2260:	1e7c0b11 	vmovne.s8	r0, d12[4]
    2264:	0b120000 	bleq	48226c <__bss_end+0x479358>
    2268:	00002892 	muleq	r0, r2, r8
    226c:	1a120b13 	bne	484ec0 <__bss_end+0x47bfac>
    2270:	0b140000 	bleq	502278 <__bss_end+0x4f9364>
    2274:	00001ea0 	andeq	r1, r0, r0, lsr #29
    2278:	194f0b15 	stmdbne	pc, {r0, r2, r4, r8, r9, fp}^	; <UNPREDICTABLE>
    227c:	0b160000 	bleq	582284 <__bss_end+0x579370>
    2280:	00002630 	andeq	r2, r0, r0, lsr r6
    2284:	27520b17 	smmlacs	r2, r7, fp, r0
    2288:	0b180000 	bleq	602290 <__bss_end+0x5f937c>
    228c:	00001ec5 	andeq	r1, r0, r5, asr #29
    2290:	230e0b19 	movwcs	r0, #60185	; 0xeb19
    2294:	0b1a0000 	bleq	68229c <__bss_end+0x679388>
    2298:	0000263e 	andeq	r2, r0, lr, lsr r6
    229c:	187e0b1b 	ldmdane	lr!, {r0, r1, r3, r4, r8, r9, fp}^
    22a0:	0b1c0000 	bleq	7022a8 <__bss_end+0x6f9394>
    22a4:	0000264c 	andeq	r2, r0, ip, asr #12
    22a8:	265a0b1d 			; <UNDEFINED> instruction: 0x265a0b1d
    22ac:	0b1e0000 	bleq	7822b4 <__bss_end+0x7793a0>
    22b0:	0000182c 	andeq	r1, r0, ip, lsr #16
    22b4:	26840b1f 	pkhbtcs	r0, r4, pc, lsl #22	; <UNPREDICTABLE>
    22b8:	0b200000 	bleq	8022c0 <__bss_end+0x7f93ac>
    22bc:	000023bb 			; <UNDEFINED> instruction: 0x000023bb
    22c0:	21f60b21 	mvnscs	r0, r1, lsr #22
    22c4:	0b220000 	bleq	8822cc <__bss_end+0x8793b8>
    22c8:	00002623 	andeq	r2, r0, r3, lsr #12
    22cc:	20fa0b23 	rscscs	r0, sl, r3, lsr #22
    22d0:	0b240000 	bleq	9022d8 <__bss_end+0x8f93c4>
    22d4:	00001ffc 	strdeq	r1, [r0], -ip
    22d8:	1d160b25 	vldrne	d0, [r6, #-148]	; 0xffffff6c
    22dc:	0b260000 	bleq	9822e4 <__bss_end+0x9793d0>
    22e0:	0000201a 	andeq	r2, r0, sl, lsl r0
    22e4:	1db20b27 			; <UNDEFINED> instruction: 0x1db20b27
    22e8:	0b280000 	bleq	a022f0 <__bss_end+0x9f93dc>
    22ec:	0000202a 	andeq	r2, r0, sl, lsr #32
    22f0:	203a0b29 	eorscs	r0, sl, r9, lsr #22
    22f4:	0b2a0000 	bleq	a822fc <__bss_end+0xa793e8>
    22f8:	0000217d 	andeq	r2, r0, sp, ror r1
    22fc:	1fa30b2b 	svcne	0x00a30b2b
    2300:	0b2c0000 	bleq	b02308 <__bss_end+0xaf93f4>
    2304:	000023c8 	andeq	r2, r0, r8, asr #7
    2308:	1d570b2d 	vldrne	d16, [r7, #-180]	; 0xffffff4c
    230c:	002e0000 	eoreq	r0, lr, r0
    2310:	001f350a 	andseq	r3, pc, sl, lsl #10
    2314:	93010700 	movwls	r0, #5888	; 0x1700
    2318:	03000000 	movweq	r0, #0
    231c:	03c70617 	biceq	r0, r7, #24117248	; 0x1700000
    2320:	6a0b0000 	bvs	2c2328 <__bss_end+0x2b9414>
    2324:	0000001c 	andeq	r0, r0, ip, lsl r0
    2328:	0018bc0b 	andseq	fp, r8, fp, lsl #24
    232c:	400b0100 	andmi	r0, fp, r0, lsl #2
    2330:	02000028 	andeq	r0, r0, #40	; 0x28
    2334:	0026d30b 	eoreq	sp, r6, fp, lsl #6
    2338:	8a0b0300 	bhi	2c2f40 <__bss_end+0x2ba02c>
    233c:	0400001c 	streq	r0, [r0], #-28	; 0xffffffe4
    2340:	0019740b 	andseq	r7, r9, fp, lsl #8
    2344:	330b0500 	movwcc	r0, #46336	; 0xb500
    2348:	0600001d 			; <UNDEFINED> instruction: 0x0600001d
    234c:	001c7a0b 	andseq	r7, ip, fp, lsl #20
    2350:	670b0700 	strvs	r0, [fp, -r0, lsl #14]
    2354:	08000025 	stmdaeq	r0, {r0, r2, r5}
    2358:	0026b80b 	eoreq	fp, r6, fp, lsl #16
    235c:	9e0b0900 	vmlals.f16	s0, s22, s0	; <UNPREDICTABLE>
    2360:	0a000024 	beq	23f8 <shift+0x23f8>
    2364:	0019c70b 	andseq	ip, r9, fp, lsl #14
    2368:	d40b0b00 	strle	r0, [fp], #-2816	; 0xfffff500
    236c:	0c00001c 	stceq	0, cr0, [r0], {28}
    2370:	00193d0b 	andseq	r3, r9, fp, lsl #26
    2374:	750b0d00 	strvc	r0, [fp, #-3328]	; 0xfffff300
    2378:	0e000028 	cdpeq	0, 0, cr0, cr0, cr8, {1}
    237c:	00216a0b 	eoreq	r6, r1, fp, lsl #20
    2380:	470b0f00 	strmi	r0, [fp, -r0, lsl #30]
    2384:	1000001e 	andne	r0, r0, lr, lsl r0
    2388:	0021a70b 	eoreq	sl, r1, fp, lsl #14
    238c:	940b1100 	strls	r1, [fp], #-256	; 0xffffff00
    2390:	12000027 	andne	r0, r0, #39	; 0x27
    2394:	001a8a0b 	andseq	r8, sl, fp, lsl #20
    2398:	5a0b1300 	bpl	2c6fa0 <__bss_end+0x2be08c>
    239c:	1400001e 	strne	r0, [r0], #-30	; 0xffffffe2
    23a0:	0020bd0b 	eoreq	fp, r0, fp, lsl #26
    23a4:	550b1500 	strpl	r1, [fp, #-1280]	; 0xfffffb00
    23a8:	1600001c 			; <UNDEFINED> instruction: 0x1600001c
    23ac:	0021090b 	eoreq	r0, r1, fp, lsl #18
    23b0:	1f0b1700 	svcne	0x000b1700
    23b4:	1800001f 	stmdane	r0, {r0, r1, r2, r3, r4}
    23b8:	0019920b 	andseq	r9, r9, fp, lsl #4
    23bc:	3b0b1900 	blcc	2c87c4 <__bss_end+0x2bf8b0>
    23c0:	1a000027 	bne	2464 <shift+0x2464>
    23c4:	0020890b 	eoreq	r8, r0, fp, lsl #18
    23c8:	310b1b00 	tstcc	fp, r0, lsl #22
    23cc:	1c00001e 	stcne	0, cr0, [r0], {30}
    23d0:	0018670b 	andseq	r6, r8, fp, lsl #14
    23d4:	d40b1d00 	strle	r1, [fp], #-3328	; 0xfffff300
    23d8:	1e00001f 	mcrne	0, 0, r0, cr0, cr15, {0}
    23dc:	001fc00b 	andseq	ip, pc, fp
    23e0:	5b0b1f00 	blpl	2c9fe8 <__bss_end+0x2c10d4>
    23e4:	20000024 	andcs	r0, r0, r4, lsr #32
    23e8:	0024e60b 	eoreq	lr, r4, fp, lsl #12
    23ec:	1a0b2100 	bne	2ca7f4 <__bss_end+0x2c18e0>
    23f0:	22000027 	andcs	r0, r0, #39	; 0x27
    23f4:	001d640b 	andseq	r6, sp, fp, lsl #8
    23f8:	be0b2300 	cdplt	3, 0, cr2, cr11, cr0, {0}
    23fc:	24000022 	strcs	r0, [r0], #-34	; 0xffffffde
    2400:	0024b30b 	eoreq	fp, r4, fp, lsl #6
    2404:	d70b2500 	strle	r2, [fp, -r0, lsl #10]
    2408:	26000023 	strcs	r0, [r0], -r3, lsr #32
    240c:	0023eb0b 	eoreq	lr, r3, fp, lsl #22
    2410:	ff0b2700 			; <UNDEFINED> instruction: 0xff0b2700
    2414:	28000023 	stmdacs	r0, {r0, r1, r5}
    2418:	001b150b 	andseq	r1, fp, fp, lsl #10
    241c:	750b2900 	strvc	r2, [fp, #-2304]	; 0xfffff700
    2420:	2a00001a 	bcs	2490 <shift+0x2490>
    2424:	001a9d0b 	andseq	r9, sl, fp, lsl #26
    2428:	b00b2b00 	andlt	r2, fp, r0, lsl #22
    242c:	2c000025 	stccs	0, cr0, [r0], {37}	; 0x25
    2430:	001af20b 	andseq	pc, sl, fp, lsl #4
    2434:	c40b2d00 	strgt	r2, [fp], #-3328	; 0xfffff300
    2438:	2e000025 	cdpcs	0, 0, cr0, cr0, cr5, {1}
    243c:	0025d80b 	eoreq	sp, r5, fp, lsl #16
    2440:	ec0b2f00 	stc	15, cr2, [fp], {-0}
    2444:	30000025 	andcc	r0, r0, r5, lsr #32
    2448:	001ce60b 	andseq	lr, ip, fp, lsl #12
    244c:	c00b3100 	andgt	r3, fp, r0, lsl #2
    2450:	3200001c 	andcc	r0, r0, #28
    2454:	001fe80b 	andseq	lr, pc, fp, lsl #16
    2458:	ba0b3300 	blt	2cf060 <__bss_end+0x2c614c>
    245c:	34000021 	strcc	r0, [r0], #-33	; 0xffffffdf
    2460:	0027c90b 	eoreq	ip, r7, fp, lsl #18
    2464:	0f0b3500 	svceq	0x000b3500
    2468:	36000018 			; <UNDEFINED> instruction: 0x36000018
    246c:	001de60b 	andseq	lr, sp, fp, lsl #12
    2470:	fb0b3700 	blx	2d007a <__bss_end+0x2c7166>
    2474:	3800001d 	stmdacc	r0, {r0, r2, r3, r4}
    2478:	00204a0b 	eoreq	r4, r0, fp, lsl #20
    247c:	740b3900 	strvc	r3, [fp], #-2304	; 0xfffff700
    2480:	3a000020 	bcc	2508 <shift+0x2508>
    2484:	0027f20b 	eoreq	pc, r7, fp, lsl #4
    2488:	a90b3b00 	stmdbge	fp, {r8, r9, fp, ip, sp}
    248c:	3c000022 	stccc	0, cr0, [r0], {34}	; 0x22
    2490:	001d890b 	andseq	r8, sp, fp, lsl #18
    2494:	ce0b3d00 	cdpgt	13, 0, cr3, cr11, cr0, {0}
    2498:	3e000018 	mcrcc	0, 0, r0, cr0, cr8, {0}
    249c:	00188c0b 	andseq	r8, r8, fp, lsl #24
    24a0:	060b3f00 	streq	r3, [fp], -r0, lsl #30
    24a4:	40000022 	andmi	r0, r0, r2, lsr #32
    24a8:	00232a0b 	eoreq	r2, r3, fp, lsl #20
    24ac:	3d0b4100 	stfccs	f4, [fp, #-0]
    24b0:	42000024 	andmi	r0, r0, #36	; 0x24
    24b4:	00205f0b 	eoreq	r5, r0, fp, lsl #30
    24b8:	2b0b4300 	blcs	2d30c0 <__bss_end+0x2ca1ac>
    24bc:	44000028 	strmi	r0, [r0], #-40	; 0xffffffd8
    24c0:	0022d40b 	eoreq	sp, r2, fp, lsl #8
    24c4:	b90b4500 	stmdblt	fp, {r8, sl, lr}
    24c8:	4600001a 			; <UNDEFINED> instruction: 0x4600001a
    24cc:	00213a0b 	eoreq	r3, r1, fp, lsl #20
    24d0:	6d0b4700 	stcvs	7, cr4, [fp, #-0]
    24d4:	4800001f 	stmdami	r0, {r0, r1, r2, r3, r4}
    24d8:	00184b0b 	andseq	r4, r8, fp, lsl #22
    24dc:	5f0b4900 	svcpl	0x000b4900
    24e0:	4a000019 	bmi	254c <shift+0x254c>
    24e4:	001d9d0b 	andseq	r9, sp, fp, lsl #26
    24e8:	9b0b4b00 	blls	2d50f0 <__bss_end+0x2cc1dc>
    24ec:	4c000020 	stcmi	0, cr0, [r0], {32}
    24f0:	07020300 	streq	r0, [r2, -r0, lsl #6]
    24f4:	000009cc 	andeq	r0, r0, ip, asr #19
    24f8:	0003e40c 	andeq	lr, r3, ip, lsl #8
    24fc:	0003d900 	andeq	sp, r3, r0, lsl #18
    2500:	0e000d00 	cdpeq	13, 0, cr0, cr0, cr0, {0}
    2504:	000003ce 	andeq	r0, r0, lr, asr #7
    2508:	03f00405 	mvnseq	r0, #83886080	; 0x5000000
    250c:	de0e0000 	cdple	0, 0, cr0, cr14, cr0, {0}
    2510:	03000003 	movweq	r0, #3
    2514:	0d5c0801 	ldcleq	8, cr0, [ip, #-4]
    2518:	e90e0000 	stmdb	lr, {}	; <UNPREDICTABLE>
    251c:	0f000003 	svceq	0x00000003
    2520:	00001a03 	andeq	r1, r0, r3, lsl #20
    2524:	1a014c04 	bne	5553c <__bss_end+0x4c628>
    2528:	000003d9 	ldrdeq	r0, [r0], -r9
    252c:	001e210f 	andseq	r2, lr, pc, lsl #2
    2530:	01820400 	orreq	r0, r2, r0, lsl #8
    2534:	0003d91a 	andeq	sp, r3, sl, lsl r9
    2538:	03e90c00 	mvneq	r0, #0, 24
    253c:	041a0000 	ldreq	r0, [sl], #-0
    2540:	000d0000 	andeq	r0, sp, r0
    2544:	00200c09 	eoreq	r0, r0, r9, lsl #24
    2548:	0d2d0500 	cfstr32eq	mvfx0, [sp, #-0]
    254c:	0000040f 	andeq	r0, r0, pc, lsl #8
    2550:	00269409 	eoreq	r9, r6, r9, lsl #8
    2554:	1c380500 	cfldr32ne	mvfx0, [r8], #-0
    2558:	000001e6 	andeq	r0, r0, r6, ror #3
    255c:	001cfa0a 	andseq	pc, ip, sl, lsl #20
    2560:	93010700 	movwls	r0, #5888	; 0x1700
    2564:	05000000 	streq	r0, [r0, #-0]
    2568:	04a50e3a 	strteq	r0, [r5], #3642	; 0xe3a
    256c:	600b0000 	andvs	r0, fp, r0
    2570:	00000018 	andeq	r0, r0, r8, lsl r0
    2574:	001f0c0b 	andseq	r0, pc, fp, lsl #24
    2578:	a60b0100 	strge	r0, [fp], -r0, lsl #2
    257c:	02000027 	andeq	r0, r0, #39	; 0x27
    2580:	0027690b 	eoreq	r6, r7, fp, lsl #18
    2584:	630b0300 	movwvs	r0, #45824	; 0xb300
    2588:	04000022 	streq	r0, [r0], #-34	; 0xffffffde
    258c:	0025240b 	eoreq	r2, r5, fp, lsl #8
    2590:	460b0500 	strmi	r0, [fp], -r0, lsl #10
    2594:	0600001a 			; <UNDEFINED> instruction: 0x0600001a
    2598:	001a280b 	andseq	r2, sl, fp, lsl #16
    259c:	410b0700 	tstmi	fp, r0, lsl #14
    25a0:	0800001c 	stmdaeq	r0, {r2, r3, r4}
    25a4:	00211f0b 	eoreq	r1, r1, fp, lsl #30
    25a8:	4d0b0900 	vstrmi.16	s0, [fp, #-0]	; <UNPREDICTABLE>
    25ac:	0a00001a 	beq	261c <shift+0x261c>
    25b0:	0021260b 	eoreq	r2, r1, fp, lsl #12
    25b4:	b20b0b00 	andlt	r0, fp, #0, 22
    25b8:	0c00001a 	stceq	0, cr0, [r0], {26}
    25bc:	001a3f0b 	andseq	r3, sl, fp, lsl #30
    25c0:	7b0b0d00 	blvc	2c59c8 <__bss_end+0x2bcab4>
    25c4:	0e000025 	cdpeq	0, 0, cr0, cr0, cr5, {1}
    25c8:	0023480b 	eoreq	r4, r3, fp, lsl #16
    25cc:	04000f00 	streq	r0, [r0], #-3840	; 0xfffff100
    25d0:	00002473 	andeq	r2, r0, r3, ror r4
    25d4:	32013f05 	andcc	r3, r1, #5, 30
    25d8:	09000004 	stmdbeq	r0, {r2}
    25dc:	00002507 	andeq	r2, r0, r7, lsl #10
    25e0:	a50f4105 	strge	r4, [pc, #-261]	; 24e3 <shift+0x24e3>
    25e4:	09000004 	stmdbeq	r0, {r2}
    25e8:	0000258f 	andeq	r2, r0, pc, lsl #11
    25ec:	1d0c4a05 	vstrne	s8, [ip, #-20]	; 0xffffffec
    25f0:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    25f4:	000019e7 	andeq	r1, r0, r7, ror #19
    25f8:	1d0c4b05 	vstrne	d4, [ip, #-20]	; 0xffffffec
    25fc:	10000000 	andne	r0, r0, r0
    2600:	00002668 	andeq	r2, r0, r8, ror #12
    2604:	0025a009 	eoreq	sl, r5, r9
    2608:	144c0500 	strbne	r0, [ip], #-1280	; 0xfffffb00
    260c:	000004e6 	andeq	r0, r0, r6, ror #9
    2610:	04d50405 	ldrbeq	r0, [r5], #1029	; 0x405
    2614:	09110000 	ldmdbeq	r1, {}	; <UNPREDICTABLE>
    2618:	00001ed6 	ldrdeq	r1, [r0], -r6
    261c:	f90f4e05 			; <UNDEFINED> instruction: 0xf90f4e05
    2620:	05000004 	streq	r0, [r0, #-4]
    2624:	0004ec04 	andeq	lr, r4, r4, lsl #24
    2628:	24891200 	strcs	r1, [r9], #512	; 0x200
    262c:	50090000 	andpl	r0, r9, r0
    2630:	05000022 	streq	r0, [r0, #-34]	; 0xffffffde
    2634:	05100d52 	ldreq	r0, [r0, #-3410]	; 0xfffff2ae
    2638:	04050000 	streq	r0, [r5], #-0
    263c:	000004ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    2640:	001b5e13 	andseq	r5, fp, r3, lsl lr
    2644:	67053400 	strvs	r3, [r5, -r0, lsl #8]
    2648:	05411501 	strbeq	r1, [r1, #-1281]	; 0xfffffaff
    264c:	15140000 	ldrne	r0, [r4, #-0]
    2650:	05000020 	streq	r0, [r0, #-32]	; 0xffffffe0
    2654:	de0f0169 	adfleez	f0, f7, #1.0
    2658:	00000003 	andeq	r0, r0, r3
    265c:	001b4214 	andseq	r4, fp, r4, lsl r2
    2660:	016a0500 	cmneq	sl, r0, lsl #10
    2664:	00054614 	andeq	r4, r5, r4, lsl r6
    2668:	0e000400 	cfcpyseq	mvf0, mvf0
    266c:	00000516 	andeq	r0, r0, r6, lsl r5
    2670:	0000b90c 	andeq	fp, r0, ip, lsl #18
    2674:	00055600 	andeq	r5, r5, r0, lsl #12
    2678:	00241500 	eoreq	r1, r4, r0, lsl #10
    267c:	002d0000 	eoreq	r0, sp, r0
    2680:	0005410c 	andeq	r4, r5, ip, lsl #2
    2684:	00056100 	andeq	r6, r5, r0, lsl #2
    2688:	0e000d00 	cdpeq	13, 0, cr0, cr0, cr0, {0}
    268c:	00000556 	andeq	r0, r0, r6, asr r5
    2690:	001f440f 	andseq	r4, pc, pc, lsl #8
    2694:	016b0500 	cmneq	fp, r0, lsl #10
    2698:	00056103 	andeq	r6, r5, r3, lsl #2
    269c:	218a0f00 	orrcs	r0, sl, r0, lsl #30
    26a0:	6e050000 	cdpvs	0, 0, cr0, cr5, cr0, {0}
    26a4:	001d0c01 	andseq	r0, sp, r1, lsl #24
    26a8:	c7160000 	ldrgt	r0, [r6, -r0]
    26ac:	07000024 	streq	r0, [r0, -r4, lsr #32]
    26b0:	00009301 	andeq	r9, r0, r1, lsl #6
    26b4:	01810500 	orreq	r0, r1, r0, lsl #10
    26b8:	00062a06 	andeq	r2, r6, r6, lsl #20
    26bc:	18f50b00 	ldmne	r5!, {r8, r9, fp}^
    26c0:	0b000000 	bleq	26c8 <shift+0x26c8>
    26c4:	00001901 	andeq	r1, r0, r1, lsl #18
    26c8:	190d0b02 	stmdbne	sp, {r1, r8, r9, fp}
    26cc:	0b030000 	bleq	c26d4 <__bss_end+0xb97c0>
    26d0:	00001d26 	andeq	r1, r0, r6, lsr #26
    26d4:	19190b03 	ldmdbne	r9, {r0, r1, r8, r9, fp}
    26d8:	0b040000 	bleq	1026e0 <__bss_end+0xf97cc>
    26dc:	00001e6f 	andeq	r1, r0, pc, ror #28
    26e0:	1f550b04 	svcne	0x00550b04
    26e4:	0b050000 	bleq	1426ec <__bss_end+0x1397d8>
    26e8:	00001eab 	andeq	r1, r0, fp, lsr #29
    26ec:	19d80b05 	ldmibne	r8, {r0, r2, r8, r9, fp}^
    26f0:	0b050000 	bleq	1426f8 <__bss_end+0x1397e4>
    26f4:	00001925 	andeq	r1, r0, r5, lsr #18
    26f8:	20d30b06 	sbcscs	r0, r3, r6, lsl #22
    26fc:	0b060000 	bleq	182704 <__bss_end+0x1797f0>
    2700:	00001b34 	andeq	r1, r0, r4, lsr fp
    2704:	20e00b06 	rsccs	r0, r0, r6, lsl #22
    2708:	0b060000 	bleq	182710 <__bss_end+0x1797fc>
    270c:	00002547 	andeq	r2, r0, r7, asr #10
    2710:	20ed0b06 	rsccs	r0, sp, r6, lsl #22
    2714:	0b060000 	bleq	18271c <__bss_end+0x179808>
    2718:	0000212d 	andeq	r2, r0, sp, lsr #2
    271c:	19310b06 	ldmdbne	r1!, {r1, r2, r8, r9, fp}
    2720:	0b070000 	bleq	1c2728 <__bss_end+0x1b9814>
    2724:	00002233 	andeq	r2, r0, r3, lsr r2
    2728:	22800b07 	addcs	r0, r0, #7168	; 0x1c00
    272c:	0b070000 	bleq	1c2734 <__bss_end+0x1b9820>
    2730:	00002582 	andeq	r2, r0, r2, lsl #11
    2734:	1b070b07 	blne	1c5358 <__bss_end+0x1bc444>
    2738:	0b070000 	bleq	1c2740 <__bss_end+0x1b982c>
    273c:	00002301 	andeq	r2, r0, r1, lsl #6
    2740:	18aa0b08 	stmiane	sl!, {r3, r8, r9, fp}
    2744:	0b080000 	bleq	20274c <__bss_end+0x1f9838>
    2748:	00002555 	andeq	r2, r0, r5, asr r5
    274c:	231d0b08 	tstcs	sp, #8, 22	; 0x2000
    2750:	00080000 	andeq	r0, r8, r0
    2754:	0027bb0f 	eoreq	fp, r7, pc, lsl #22
    2758:	019f0500 	orrseq	r0, pc, r0, lsl #10
    275c:	0005801f 	andeq	r8, r5, pc, lsl r0
    2760:	234f0f00 	movtcs	r0, #65280	; 0xff00
    2764:	a2050000 	andge	r0, r5, #0
    2768:	001d0c01 	andseq	r0, sp, r1, lsl #24
    276c:	620f0000 	andvs	r0, pc, #0
    2770:	0500001f 	streq	r0, [r0, #-31]	; 0xffffffe1
    2774:	1d0c01a5 	stfnes	f0, [ip, #-660]	; 0xfffffd6c
    2778:	0f000000 	svceq	0x00000000
    277c:	00002887 	andeq	r2, r0, r7, lsl #17
    2780:	0c01a805 	stceq	8, cr10, [r1], {5}
    2784:	0000001d 	andeq	r0, r0, sp, lsl r0
    2788:	0019f70f 	andseq	pc, r9, pc, lsl #14
    278c:	01ab0500 			; <UNDEFINED> instruction: 0x01ab0500
    2790:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2794:	23590f00 	cmpcs	r9, #0, 30
    2798:	ae050000 	cdpge	0, 0, cr0, cr5, cr0, {0}
    279c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    27a0:	6a0f0000 	bvs	3c27a8 <__bss_end+0x3b9894>
    27a4:	05000022 	streq	r0, [r0, #-34]	; 0xffffffde
    27a8:	1d0c01b1 	stfnes	f0, [ip, #-708]	; 0xfffffd3c
    27ac:	0f000000 	svceq	0x00000000
    27b0:	00002275 	andeq	r2, r0, r5, ror r2
    27b4:	0c01b405 	cfstrseq	mvf11, [r1], {5}
    27b8:	0000001d 	andeq	r0, r0, sp, lsl r0
    27bc:	0023630f 	eoreq	r6, r3, pc, lsl #6
    27c0:	01b70500 			; <UNDEFINED> instruction: 0x01b70500
    27c4:	00001d0c 	andeq	r1, r0, ip, lsl #26
    27c8:	20af0f00 	adccs	r0, pc, r0, lsl #30
    27cc:	ba050000 	blt	1427d4 <__bss_end+0x1398c0>
    27d0:	001d0c01 	andseq	r0, sp, r1, lsl #24
    27d4:	e60f0000 	str	r0, [pc], -r0
    27d8:	05000027 	streq	r0, [r0, #-39]	; 0xffffffd9
    27dc:	1d0c01bd 	stfnes	f0, [ip, #-756]	; 0xfffffd0c
    27e0:	0f000000 	svceq	0x00000000
    27e4:	0000236d 	andeq	r2, r0, sp, ror #6
    27e8:	0c01c005 	stceq	0, cr12, [r1], {5}
    27ec:	0000001d 	andeq	r0, r0, sp, lsl r0
    27f0:	0028aa0f 	eoreq	sl, r8, pc, lsl #20
    27f4:	01c30500 	biceq	r0, r3, r0, lsl #10
    27f8:	00001d0c 	andeq	r1, r0, ip, lsl #26
    27fc:	27700f00 	ldrbcs	r0, [r0, -r0, lsl #30]!
    2800:	c6050000 	strgt	r0, [r5], -r0
    2804:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2808:	7c0f0000 	stcvc	0, cr0, [pc], {-0}
    280c:	05000027 	streq	r0, [r0, #-39]	; 0xffffffd9
    2810:	1d0c01c9 	stfnes	f0, [ip, #-804]	; 0xfffffcdc
    2814:	0f000000 	svceq	0x00000000
    2818:	00002788 	andeq	r2, r0, r8, lsl #15
    281c:	0c01cc05 	stceq	12, cr12, [r1], {5}
    2820:	0000001d 	andeq	r0, r0, sp, lsl r0
    2824:	0027ad0f 	eoreq	sl, r7, pc, lsl #26
    2828:	01d00500 	bicseq	r0, r0, r0, lsl #10
    282c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2830:	289d0f00 	ldmcs	sp, {r8, r9, sl, fp}
    2834:	d3050000 	movwle	r0, #20480	; 0x5000
    2838:	001d0c01 	andseq	r0, sp, r1, lsl #24
    283c:	540f0000 	strpl	r0, [pc], #-0	; 2844 <shift+0x2844>
    2840:	0500001a 	streq	r0, [r0, #-26]	; 0xffffffe6
    2844:	1d0c01d6 	stfnes	f0, [ip, #-856]	; 0xfffffca8
    2848:	0f000000 	svceq	0x00000000
    284c:	0000183b 	andeq	r1, r0, fp, lsr r8
    2850:	0c01d905 			; <UNDEFINED> instruction: 0x0c01d905
    2854:	0000001d 	andeq	r0, r0, sp, lsl r0
    2858:	001d460f 	andseq	r4, sp, pc, lsl #12
    285c:	01dc0500 	bicseq	r0, ip, r0, lsl #10
    2860:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2864:	1a2f0f00 	bne	bc646c <__bss_end+0xbbd558>
    2868:	df050000 	svcle	0x00050000
    286c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2870:	830f0000 	movwhi	r0, #61440	; 0xf000
    2874:	05000023 	streq	r0, [r0, #-35]	; 0xffffffdd
    2878:	1d0c01e2 	stfnes	f0, [ip, #-904]	; 0xfffffc78
    287c:	0f000000 	svceq	0x00000000
    2880:	00001f8b 	andeq	r1, r0, fp, lsl #31
    2884:	0c01e505 	cfstr32eq	mvfx14, [r1], {5}
    2888:	0000001d 	andeq	r0, r0, sp, lsl r0
    288c:	0021e30f 	eoreq	lr, r1, pc, lsl #6
    2890:	01e80500 	mvneq	r0, r0, lsl #10
    2894:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2898:	269d0f00 	ldrcs	r0, [sp], r0, lsl #30
    289c:	ef050000 	svc	0x00050000
    28a0:	001d0c01 	andseq	r0, sp, r1, lsl #24
    28a4:	550f0000 	strpl	r0, [pc, #-0]	; 28ac <shift+0x28ac>
    28a8:	05000028 	streq	r0, [r0, #-40]	; 0xffffffd8
    28ac:	1d0c01f2 	stfnes	f0, [ip, #-968]	; 0xfffffc38
    28b0:	0f000000 	svceq	0x00000000
    28b4:	00002865 	andeq	r2, r0, r5, ror #16
    28b8:	0c01f505 	cfstr32eq	mvfx15, [r1], {5}
    28bc:	0000001d 	andeq	r0, r0, sp, lsl r0
    28c0:	001b4b0f 	andseq	r4, fp, pc, lsl #22
    28c4:	01f80500 	mvnseq	r0, r0, lsl #10
    28c8:	00001d0c 	andeq	r1, r0, ip, lsl #26
    28cc:	26e40f00 	strbtcs	r0, [r4], r0, lsl #30
    28d0:	fb050000 	blx	1428da <__bss_end+0x1399c6>
    28d4:	001d0c01 	andseq	r0, sp, r1, lsl #24
    28d8:	e90f0000 	stmdb	pc, {}	; <UNPREDICTABLE>
    28dc:	05000022 	streq	r0, [r0, #-34]	; 0xffffffde
    28e0:	1d0c01fe 	stfnes	f0, [ip, #-1016]	; 0xfffffc08
    28e4:	0f000000 	svceq	0x00000000
    28e8:	00001dbf 			; <UNDEFINED> instruction: 0x00001dbf
    28ec:	0c020205 	sfmeq	f0, 4, [r2], {5}
    28f0:	0000001d 	andeq	r0, r0, sp, lsl r0
    28f4:	0024d90f 	eoreq	sp, r4, pc, lsl #18
    28f8:	020a0500 	andeq	r0, sl, #0, 10
    28fc:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2900:	1cb20f00 	ldcne	15, cr0, [r2]
    2904:	0d050000 	stceq	0, cr0, [r5, #-0]
    2908:	001d0c02 	andseq	r0, sp, r2, lsl #24
    290c:	1d0c0000 	stcne	0, cr0, [ip, #-0]
    2910:	ef000000 	svc	0x00000000
    2914:	0d000007 	stceq	0, cr0, [r0, #-28]	; 0xffffffe4
    2918:	1e8b0f00 	cdpne	15, 8, cr0, cr11, cr0, {0}
    291c:	fb050000 	blx	142926 <__bss_end+0x139a12>
    2920:	07e40c03 	strbeq	r0, [r4, r3, lsl #24]!
    2924:	e60c0000 	str	r0, [ip], -r0
    2928:	0c000004 	stceq	0, cr0, [r0], {4}
    292c:	15000008 	strne	r0, [r0, #-8]
    2930:	00000024 	andeq	r0, r0, r4, lsr #32
    2934:	a60f000d 	strge	r0, [pc], -sp
    2938:	05000023 	streq	r0, [r0, #-35]	; 0xffffffdd
    293c:	fc140584 	ldc2	5, cr0, [r4], {132}	; 0x84
    2940:	16000007 	strne	r0, [r0], -r7
    2944:	00001f4d 	andeq	r1, r0, sp, asr #30
    2948:	00930107 	addseq	r0, r3, r7, lsl #2
    294c:	8b050000 	blhi	142954 <__bss_end+0x139a40>
    2950:	08570605 	ldmdaeq	r7, {r0, r2, r9, sl}^
    2954:	080b0000 	stmdaeq	fp, {}	; <UNPREDICTABLE>
    2958:	0000001d 	andeq	r0, r0, sp, lsl r0
    295c:	0021580b 	eoreq	r5, r1, fp, lsl #16
    2960:	e00b0100 	and	r0, fp, r0, lsl #2
    2964:	02000018 	andeq	r0, r0, #24
    2968:	0028170b 	eoreq	r1, r8, fp, lsl #14
    296c:	200b0300 	andcs	r0, fp, r0, lsl #6
    2970:	04000024 	streq	r0, [r0], #-36	; 0xffffffdc
    2974:	0024130b 	eoreq	r1, r4, fp, lsl #6
    2978:	b70b0500 	strlt	r0, [fp, -r0, lsl #10]
    297c:	06000019 			; <UNDEFINED> instruction: 0x06000019
    2980:	28070f00 	stmdacs	r7, {r8, r9, sl, fp}
    2984:	98050000 	stmdals	r5, {}	; <UNPREDICTABLE>
    2988:	08191505 	ldmdaeq	r9, {r0, r2, r8, sl, ip}
    298c:	090f0000 	stmdbeq	pc, {}	; <UNPREDICTABLE>
    2990:	05000027 	streq	r0, [r0, #-39]	; 0xffffffd9
    2994:	24110799 	ldrcs	r0, [r1], #-1945	; 0xfffff867
    2998:	0f000000 	svceq	0x00000000
    299c:	00002393 	muleq	r0, r3, r3
    29a0:	0c07ae05 	stceq	14, cr10, [r7], {5}
    29a4:	0000001d 	andeq	r0, r0, sp, lsl r0
    29a8:	00267c04 	eoreq	r7, r6, r4, lsl #24
    29ac:	167b0600 	ldrbtne	r0, [fp], -r0, lsl #12
    29b0:	00000093 	muleq	r0, r3, r0
    29b4:	00087e0e 	andeq	r7, r8, lr, lsl #28
    29b8:	05020300 	streq	r0, [r2, #-768]	; 0xfffffd00
    29bc:	00000dd0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    29c0:	9b070803 	blls	1c49d4 <__bss_end+0x1bbac0>
    29c4:	0300001c 	movweq	r0, #28
    29c8:	1a6f0404 	bne	1bc39e0 <__bss_end+0x1bbaacc>
    29cc:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    29d0:	001a6703 	andseq	r6, sl, r3, lsl #14
    29d4:	04080300 	streq	r0, [r8], #-768	; 0xfffffd00
    29d8:	0000237c 	andeq	r2, r0, ip, ror r3
    29dc:	2e031003 	cdpcs	0, 0, cr1, cr3, cr3, {0}
    29e0:	0c000024 	stceq	0, cr0, [r0], {36}	; 0x24
    29e4:	0000088a 	andeq	r0, r0, sl, lsl #17
    29e8:	000008c9 	andeq	r0, r0, r9, asr #17
    29ec:	00002415 	andeq	r2, r0, r5, lsl r4
    29f0:	0e00ff00 	cdpeq	15, 0, cr15, cr0, cr0, {0}
    29f4:	000008b9 			; <UNDEFINED> instruction: 0x000008b9
    29f8:	00228d0f 	eoreq	r8, r2, pc, lsl #26
    29fc:	01fc0600 	mvnseq	r0, r0, lsl #12
    2a00:	0008c916 	andeq	ip, r8, r6, lsl r9
    2a04:	1a1e0f00 	bne	78660c <__bss_end+0x77d6f8>
    2a08:	02060000 	andeq	r0, r6, #0
    2a0c:	08c91602 	stmiaeq	r9, {r1, r9, sl, ip}^
    2a10:	af040000 	svcge	0x00040000
    2a14:	07000026 	streq	r0, [r0, -r6, lsr #32]
    2a18:	04f9102a 	ldrbteq	r1, [r9], #42	; 0x2a
    2a1c:	e80c0000 	stmda	ip, {}	; <UNPREDICTABLE>
    2a20:	ff000008 			; <UNDEFINED> instruction: 0xff000008
    2a24:	0d000008 	stceq	0, cr0, [r0, #-32]	; 0xffffffe0
    2a28:	03720900 	cmneq	r2, #0, 18
    2a2c:	2f070000 	svccs	0x00070000
    2a30:	0008f411 	andeq	pc, r8, r1, lsl r4	; <UNPREDICTABLE>
    2a34:	02370900 	eorseq	r0, r7, #0, 18
    2a38:	30070000 	andcc	r0, r7, r0
    2a3c:	0008f411 	andeq	pc, r8, r1, lsl r4	; <UNPREDICTABLE>
    2a40:	08ff1700 	ldmeq	pc!, {r8, r9, sl, ip}^	; <UNPREDICTABLE>
    2a44:	33080000 	movwcc	r0, #32768	; 0x8000
    2a48:	03050a09 	movweq	r0, #23049	; 0x5a09
    2a4c:	00008f01 	andeq	r8, r0, r1, lsl #30
    2a50:	00090b17 	andeq	r0, r9, r7, lsl fp
    2a54:	09340800 	ldmdbeq	r4!, {fp}
    2a58:	0103050a 	tsteq	r3, sl, lsl #10
    2a5c:	0000008f 	andeq	r0, r0, pc, lsl #1

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	10001101 	andne	r1, r0, r1, lsl #2
   4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
   8:	1b0e0301 	blne	380c14 <__bss_end+0x377d00>
   c:	130e250e 	movwne	r2, #58638	; 0xe50e
  10:	00000005 	andeq	r0, r0, r5
  14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
  18:	030b130e 	movweq	r1, #45838	; 0xb30e
  1c:	110e1b0e 	tstne	lr, lr, lsl #22
  20:	10061201 	andne	r1, r6, r1, lsl #4
  24:	02000017 	andeq	r0, r0, #23
  28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeb9e08>
  30:	13490b39 	movtne	r0, #39737	; 0x9b39
  34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
  38:	24030000 	strcs	r0, [r3], #-0
  3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  40:	000e030b 	andeq	r0, lr, fp, lsl #6
  44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
  48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeb9e28>
  50:	01110b39 	tsteq	r1, r9, lsr fp
  54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
  58:	01194296 			; <UNDEFINED> instruction: 0x01194296
  5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeb9e40>
  68:	13490b39 	movtne	r0, #39737	; 0x9b39
  6c:	00001802 	andeq	r1, r0, r2, lsl #16
  70:	0b002406 	bleq	9090 <__bss_end+0x17c>
  74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  78:	07000008 	streq	r0, [r0, -r8]
  7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe7a980>
  84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe39e64>
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
  b4:	3a0e0300 	bcc	380cbc <__bss_end+0x377da8>
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
  e4:	0b3e0b0b 	bleq	f82d18 <__bss_end+0xf79e04>
  e8:	00000e03 	andeq	r0, r0, r3, lsl #28
  ec:	03003408 	movweq	r3, #1032	; 0x408
  f0:	3b0b3a0e 	blcc	2ce930 <__bss_end+0x2c5a1c>
  f4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
  f8:	3c193f13 	ldccc	15, cr3, [r9], {19}
  fc:	09000019 	stmdbeq	r0, {r0, r3, r4}
 100:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 104:	0b3a0e03 	bleq	e83918 <__bss_end+0xe7aa04>
 108:	0b390b3b 	bleq	e42dfc <__bss_end+0xe39ee8>
 10c:	01111349 	tsteq	r1, r9, asr #6
 110:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 114:	01194296 			; <UNDEFINED> instruction: 0x01194296
 118:	0a000013 	beq	16c <shift+0x16c>
 11c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeb9efc>
 124:	13490b39 	movtne	r0, #39737	; 0x9b39
 128:	00001802 	andeq	r1, r0, r2, lsl #16
 12c:	0b00240b 	bleq	9160 <__bss_end+0x24c>
 130:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 134:	0c000008 	stceq	0, cr0, [r0], {8}
 138:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
 13c:	0b3a0e03 	bleq	e83950 <__bss_end+0xe7aa3c>
 140:	0b390b3b 	bleq	e42e34 <__bss_end+0xe39f20>
 144:	06120111 			; <UNDEFINED> instruction: 0x06120111
 148:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 14c:	0d000019 	stceq	0, cr0, [r0, #-100]	; 0xffffff9c
 150:	0e030139 	mcreq	1, 0, r0, cr3, cr9, {1}
 154:	0b3b0b3a 	bleq	ec2e44 <__bss_end+0xeb9f30>
 158:	00001301 	andeq	r1, r0, r1, lsl #6
 15c:	3f012e0e 	svccc	0x00012e0e
 160:	3a0e0319 	bcc	380dcc <__bss_end+0x377eb8>
 164:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 168:	01193c0b 	tsteq	r9, fp, lsl #24
 16c:	0f000013 	svceq	0x00000013
 170:	13490005 	movtne	r0, #36869	; 0x9005
 174:	2e100000 	cdpcs	0, 1, cr0, cr0, cr0, {0}
 178:	03193f01 	tsteq	r9, #1, 30
 17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c5aa8>
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
 1a8:	3b0b3a08 	blcc	2ce9d0 <__bss_end+0x2c5abc>
 1ac:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 1b0:	00180213 	andseq	r0, r8, r3, lsl r2
 1b4:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 1b8:	01111347 	tsteq	r1, r7, asr #6
 1bc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 1c0:	00194297 	mulseq	r9, r7, r2
 1c4:	11010000 	mrsne	r0, (UNDEF: 1)
 1c8:	130e2501 	movwne	r2, #58625	; 0xe501
 1cc:	1b0e030b 	blne	380e00 <__bss_end+0x377eec>
 1d0:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 1d4:	00171006 	andseq	r1, r7, r6
 1d8:	00240200 	eoreq	r0, r4, r0, lsl #4
 1dc:	0b3e0b0b 	bleq	f82e10 <__bss_end+0xf79efc>
 1e0:	00000e03 	andeq	r0, r0, r3, lsl #28
 1e4:	49002603 	stmdbmi	r0, {r0, r1, r9, sl, sp}
 1e8:	04000013 	streq	r0, [r0], #-19	; 0xffffffed
 1ec:	0b0b0024 	bleq	2c0284 <__bss_end+0x2b7370>
 1f0:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 1f4:	16050000 	strne	r0, [r5], -r0
 1f8:	3a0e0300 	bcc	380e00 <__bss_end+0x377eec>
 1fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 200:	0013490b 	andseq	r4, r3, fp, lsl #18
 204:	00350600 	eorseq	r0, r5, r0, lsl #12
 208:	00001349 	andeq	r1, r0, r9, asr #6
 20c:	03011307 	movweq	r1, #4871	; 0x1307
 210:	3a0b0b0e 	bcc	2c2e50 <__bss_end+0x2b9f3c>
 214:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 218:	0013010b 	andseq	r0, r3, fp, lsl #2
 21c:	000d0800 	andeq	r0, sp, r0, lsl #16
 220:	0b3a0803 	bleq	e82234 <__bss_end+0xe79320>
 224:	0b390b3b 	bleq	e42f18 <__bss_end+0xe3a004>
 228:	0b381349 	bleq	e04f54 <__bss_end+0xdfc040>
 22c:	04090000 	streq	r0, [r9], #-0
 230:	6d0e0301 	stcvs	3, cr0, [lr, #-4]
 234:	0b0b3e19 	bleq	2cfaa0 <__bss_end+0x2c6b8c>
 238:	3a13490b 	bcc	4d266c <__bss_end+0x4c9758>
 23c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 240:	0013010b 	andseq	r0, r3, fp, lsl #2
 244:	00280a00 	eoreq	r0, r8, r0, lsl #20
 248:	0b1c0e03 	bleq	703a5c <__bss_end+0x6fab48>
 24c:	340b0000 	strcc	r0, [fp], #-0
 250:	3a0e0300 	bcc	380e58 <__bss_end+0x377f44>
 254:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 258:	6c13490b 			; <UNDEFINED> instruction: 0x6c13490b
 25c:	00180219 	andseq	r0, r8, r9, lsl r2
 260:	00020c00 	andeq	r0, r2, r0, lsl #24
 264:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
 268:	020d0000 	andeq	r0, sp, #0
 26c:	0b0e0301 	bleq	380e78 <__bss_end+0x377f64>
 270:	3b0b3a0b 	blcc	2ceaa4 <__bss_end+0x2c5b90>
 274:	010b390b 	tsteq	fp, fp, lsl #18
 278:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
 27c:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 280:	0b3b0b3a 	bleq	ec2f70 <__bss_end+0xeba05c>
 284:	13490b39 	movtne	r0, #39737	; 0x9b39
 288:	00000b38 	andeq	r0, r0, r8, lsr fp
 28c:	3f012e0f 	svccc	0x00012e0f
 290:	3a0e0319 	bcc	380efc <__bss_end+0x377fe8>
 294:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 298:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 29c:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
 2a0:	10000013 	andne	r0, r0, r3, lsl r0
 2a4:	13490005 	movtne	r0, #36869	; 0x9005
 2a8:	00001934 	andeq	r1, r0, r4, lsr r9
 2ac:	49000511 	stmdbmi	r0, {r0, r4, r8, sl}
 2b0:	12000013 	andne	r0, r0, #19
 2b4:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 2b8:	0b3b0b3a 	bleq	ec2fa8 <__bss_end+0xeba094>
 2bc:	13490b39 	movtne	r0, #39737	; 0x9b39
 2c0:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 2c4:	2e130000 	cdpcs	0, 1, cr0, cr3, cr0, {0}
 2c8:	03193f01 	tsteq	r9, #1, 30
 2cc:	3b0b3a0e 	blcc	2ceb0c <__bss_end+0x2c5bf8>
 2d0:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 2d4:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 2d8:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 2dc:	00130113 	andseq	r0, r3, r3, lsl r1
 2e0:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 2e4:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 2e8:	0b3b0b3a 	bleq	ec2fd8 <__bss_end+0xeba0c4>
 2ec:	0e6e0b39 	vmoveq.8	d14[5], r0
 2f0:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 2f4:	13011364 	movwne	r1, #4964	; 0x1364
 2f8:	2e150000 	cdpcs	0, 1, cr0, cr5, cr0, {0}
 2fc:	03193f01 	tsteq	r9, #1, 30
 300:	3b0b3a0e 	blcc	2ceb40 <__bss_end+0x2c5c2c>
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
 338:	0b3b0b3a 	bleq	ec3028 <__bss_end+0xeba114>
 33c:	13490b39 	movtne	r0, #39737	; 0x9b39
 340:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 344:	281b0000 	ldmdacs	fp, {}	; <UNPREDICTABLE>
 348:	1c080300 	stcne	3, cr0, [r8], {-0}
 34c:	1c00000b 	stcne	0, cr0, [r0], {11}
 350:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 354:	0b3a0e03 	bleq	e83b68 <__bss_end+0xe7ac54>
 358:	0b390b3b 	bleq	e4304c <__bss_end+0xe3a138>
 35c:	193c0e6e 	ldmdbne	ip!, {r1, r2, r3, r5, r6, r9, sl, fp}
 360:	13011364 	movwne	r1, #4964	; 0x1364
 364:	2e1d0000 	cdpcs	0, 1, cr0, cr13, cr0, {0}
 368:	03193f01 	tsteq	r9, #1, 30
 36c:	3b0b3a0e 	blcc	2cebac <__bss_end+0x2c5c98>
 370:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 374:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
 378:	01136419 	tsteq	r3, r9, lsl r4
 37c:	1e000013 	mcrne	0, 0, r0, cr0, cr3, {0}
 380:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 384:	0b3b0b3a 	bleq	ec3074 <__bss_end+0xeba160>
 388:	13490b39 	movtne	r0, #39737	; 0x9b39
 38c:	0b320b38 	bleq	c83074 <__bss_end+0xc7a160>
 390:	151f0000 	ldrne	r0, [pc, #-0]	; 398 <shift+0x398>
 394:	64134901 	ldrvs	r4, [r3], #-2305	; 0xfffff6ff
 398:	00130113 	andseq	r0, r3, r3, lsl r1
 39c:	001f2000 	andseq	r2, pc, r0
 3a0:	1349131d 	movtne	r1, #37661	; 0x931d
 3a4:	10210000 	eorne	r0, r1, r0
 3a8:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 3ac:	22000013 	andcs	r0, r0, #19
 3b0:	0b0b000f 	bleq	2c03f4 <__bss_end+0x2b74e0>
 3b4:	39230000 	stmdbcc	r3!, {}	; <UNPREDICTABLE>
 3b8:	3a080301 	bcc	200fc4 <__bss_end+0x1f80b0>
 3bc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 3c0:	0013010b 	andseq	r0, r3, fp, lsl #2
 3c4:	00342400 	eorseq	r2, r4, r0, lsl #8
 3c8:	0b3a0e03 	bleq	e83bdc <__bss_end+0xe7acc8>
 3cc:	0b390b3b 	bleq	e430c0 <__bss_end+0xe3a1ac>
 3d0:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 3d4:	196c061c 	stmdbne	ip!, {r2, r3, r4, r9, sl}^
 3d8:	34250000 	strtcc	r0, [r5], #-0
 3dc:	3a0e0300 	bcc	380fe4 <__bss_end+0x3780d0>
 3e0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 3e4:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 3e8:	6c0b1c19 	stcvs	12, cr1, [fp], {25}
 3ec:	26000019 			; <UNDEFINED> instruction: 0x26000019
 3f0:	13470034 	movtne	r0, #28724	; 0x7034
 3f4:	2e270000 	cdpcs	0, 2, cr0, cr7, cr0, {0}
 3f8:	03193f01 	tsteq	r9, #1, 30
 3fc:	3b0b3a0e 	blcc	2cec3c <__bss_end+0x2c5d28>
 400:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 404:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
 408:	00136419 	andseq	r6, r3, r9, lsl r4
 40c:	012e2800 			; <UNDEFINED> instruction: 0x012e2800
 410:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 414:	0b3b0b3a 	bleq	ec3104 <__bss_end+0xeba1f0>
 418:	13490b39 	movtne	r0, #39737	; 0x9b39
 41c:	06120111 			; <UNDEFINED> instruction: 0x06120111
 420:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 424:	00130119 	andseq	r0, r3, r9, lsl r1
 428:	00052900 	andeq	r2, r5, r0, lsl #18
 42c:	0b3a0e03 	bleq	e83c40 <__bss_end+0xe7ad2c>
 430:	0b390b3b 	bleq	e43124 <__bss_end+0xe3a210>
 434:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 438:	342a0000 	strtcc	r0, [sl], #-0
 43c:	3a0e0300 	bcc	381044 <__bss_end+0x378130>
 440:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 444:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 448:	00000018 	andeq	r0, r0, r8, lsl r0
 44c:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 450:	030b130e 	movweq	r1, #45838	; 0xb30e
 454:	110e1b0e 	tstne	lr, lr, lsl #22
 458:	10061201 	andne	r1, r6, r1, lsl #4
 45c:	02000017 	andeq	r0, r0, #23
 460:	0b0b0024 	bleq	2c04f8 <__bss_end+0x2b75e4>
 464:	0e030b3e 	vmoveq.16	d3[0], r0
 468:	26030000 	strcs	r0, [r3], -r0
 46c:	00134900 	andseq	r4, r3, r0, lsl #18
 470:	00240400 	eoreq	r0, r4, r0, lsl #8
 474:	0b3e0b0b 	bleq	f830a8 <__bss_end+0xf7a194>
 478:	00000803 	andeq	r0, r0, r3, lsl #16
 47c:	03001605 	movweq	r1, #1541	; 0x605
 480:	3b0b3a0e 	blcc	2cecc0 <__bss_end+0x2c5dac>
 484:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 488:	06000013 			; <UNDEFINED> instruction: 0x06000013
 48c:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
 490:	0b3a0b0b 	bleq	e830c4 <__bss_end+0xe7a1b0>
 494:	0b390b3b 	bleq	e43188 <__bss_end+0xe3a274>
 498:	00001301 	andeq	r1, r0, r1, lsl #6
 49c:	03000d07 	movweq	r0, #3335	; 0xd07
 4a0:	3b0b3a08 	blcc	2cecc8 <__bss_end+0x2c5db4>
 4a4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 4a8:	000b3813 	andeq	r3, fp, r3, lsl r8
 4ac:	01040800 	tsteq	r4, r0, lsl #16
 4b0:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
 4b4:	0b0b0b3e 	bleq	2c31b4 <__bss_end+0x2ba2a0>
 4b8:	0b3a1349 	bleq	e851e4 <__bss_end+0xe7c2d0>
 4bc:	0b390b3b 	bleq	e431b0 <__bss_end+0xe3a29c>
 4c0:	00001301 	andeq	r1, r0, r1, lsl #6
 4c4:	03002809 	movweq	r2, #2057	; 0x809
 4c8:	000b1c08 	andeq	r1, fp, r8, lsl #24
 4cc:	00280a00 	eoreq	r0, r8, r0, lsl #20
 4d0:	0b1c0e03 	bleq	703ce4 <__bss_end+0x6fadd0>
 4d4:	340b0000 	strcc	r0, [fp], #-0
 4d8:	3a0e0300 	bcc	3810e0 <__bss_end+0x3781cc>
 4dc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4e0:	6c13490b 			; <UNDEFINED> instruction: 0x6c13490b
 4e4:	00180219 	andseq	r0, r8, r9, lsl r2
 4e8:	00020c00 	andeq	r0, r2, r0, lsl #24
 4ec:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
 4f0:	020d0000 	andeq	r0, sp, #0
 4f4:	0b0e0301 	bleq	381100 <__bss_end+0x3781ec>
 4f8:	3b0b3a0b 	blcc	2ced2c <__bss_end+0x2c5e18>
 4fc:	010b390b 	tsteq	fp, fp, lsl #18
 500:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
 504:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 508:	0b3b0b3a 	bleq	ec31f8 <__bss_end+0xeba2e4>
 50c:	13490b39 	movtne	r0, #39737	; 0x9b39
 510:	00000b38 	andeq	r0, r0, r8, lsr fp
 514:	3f012e0f 	svccc	0x00012e0f
 518:	3a0e0319 	bcc	381184 <__bss_end+0x378270>
 51c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 520:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 524:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
 528:	10000013 	andne	r0, r0, r3, lsl r0
 52c:	13490005 	movtne	r0, #36869	; 0x9005
 530:	00001934 	andeq	r1, r0, r4, lsr r9
 534:	49000511 	stmdbmi	r0, {r0, r4, r8, sl}
 538:	12000013 	andne	r0, r0, #19
 53c:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 540:	0b3b0b3a 	bleq	ec3230 <__bss_end+0xeba31c>
 544:	13490b39 	movtne	r0, #39737	; 0x9b39
 548:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 54c:	2e130000 	cdpcs	0, 1, cr0, cr3, cr0, {0}
 550:	03193f01 	tsteq	r9, #1, 30
 554:	3b0b3a0e 	blcc	2ced94 <__bss_end+0x2c5e80>
 558:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 55c:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 560:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 564:	00130113 	andseq	r0, r3, r3, lsl r1
 568:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 56c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 570:	0b3b0b3a 	bleq	ec3260 <__bss_end+0xeba34c>
 574:	0e6e0b39 	vmoveq.8	d14[5], r0
 578:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 57c:	13011364 	movwne	r1, #4964	; 0x1364
 580:	2e150000 	cdpcs	0, 1, cr0, cr5, cr0, {0}
 584:	03193f01 	tsteq	r9, #1, 30
 588:	3b0b3a0e 	blcc	2cedc8 <__bss_end+0x2c5eb4>
 58c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 590:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 594:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 598:	16000013 			; <UNDEFINED> instruction: 0x16000013
 59c:	13490101 	movtne	r0, #37121	; 0x9101
 5a0:	00001301 	andeq	r1, r0, r1, lsl #6
 5a4:	49002117 	stmdbmi	r0, {r0, r1, r2, r4, r8, sp}
 5a8:	000b2f13 	andeq	r2, fp, r3, lsl pc
 5ac:	000f1800 	andeq	r1, pc, r0, lsl #16
 5b0:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 5b4:	21190000 	tstcs	r9, r0
 5b8:	1a000000 	bne	5c0 <shift+0x5c0>
 5bc:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 5c0:	0b3b0b3a 	bleq	ec32b0 <__bss_end+0xeba39c>
 5c4:	13490b39 	movtne	r0, #39737	; 0x9b39
 5c8:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 5cc:	2e1b0000 	cdpcs	0, 1, cr0, cr11, cr0, {0}
 5d0:	03193f01 	tsteq	r9, #1, 30
 5d4:	3b0b3a0e 	blcc	2cee14 <__bss_end+0x2c5f00>
 5d8:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 5dc:	64193c0e 	ldrvs	r3, [r9], #-3086	; 0xfffff3f2
 5e0:	00130113 	andseq	r0, r3, r3, lsl r1
 5e4:	012e1c00 			; <UNDEFINED> instruction: 0x012e1c00
 5e8:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 5ec:	0b3b0b3a 	bleq	ec32dc <__bss_end+0xeba3c8>
 5f0:	0e6e0b39 	vmoveq.8	d14[5], r0
 5f4:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 5f8:	13011364 	movwne	r1, #4964	; 0x1364
 5fc:	0d1d0000 	ldceq	0, cr0, [sp, #-0]
 600:	3a0e0300 	bcc	381208 <__bss_end+0x3782f4>
 604:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 608:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 60c:	000b320b 	andeq	r3, fp, fp, lsl #4
 610:	01151e00 	tsteq	r5, r0, lsl #28
 614:	13641349 	cmnne	r4, #603979777	; 0x24000001
 618:	00001301 	andeq	r1, r0, r1, lsl #6
 61c:	1d001f1f 	stcne	15, cr1, [r0, #-124]	; 0xffffff84
 620:	00134913 	andseq	r4, r3, r3, lsl r9
 624:	00102000 	andseq	r2, r0, r0
 628:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 62c:	0f210000 	svceq	0x00210000
 630:	000b0b00 	andeq	r0, fp, r0, lsl #22
 634:	00342200 	eorseq	r2, r4, r0, lsl #4
 638:	0b3a0e03 	bleq	e83e4c <__bss_end+0xe7af38>
 63c:	0b390b3b 	bleq	e43330 <__bss_end+0xe3a41c>
 640:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 644:	2e230000 	cdpcs	0, 2, cr0, cr3, cr0, {0}
 648:	03193f01 	tsteq	r9, #1, 30
 64c:	3b0b3a0e 	blcc	2cee8c <__bss_end+0x2c5f78>
 650:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 654:	1113490e 	tstne	r3, lr, lsl #18
 658:	40061201 	andmi	r1, r6, r1, lsl #4
 65c:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 660:	00001301 	andeq	r1, r0, r1, lsl #6
 664:	03000524 	movweq	r0, #1316	; 0x524
 668:	3b0b3a0e 	blcc	2ceea8 <__bss_end+0x2c5f94>
 66c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 670:	00180213 	andseq	r0, r8, r3, lsl r2
 674:	012e2500 			; <UNDEFINED> instruction: 0x012e2500
 678:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 67c:	0b3b0b3a 	bleq	ec336c <__bss_end+0xeba458>
 680:	0e6e0b39 	vmoveq.8	d14[5], r0
 684:	01111349 	tsteq	r1, r9, asr #6
 688:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 68c:	01194297 			; <UNDEFINED> instruction: 0x01194297
 690:	26000013 			; <UNDEFINED> instruction: 0x26000013
 694:	08030034 	stmdaeq	r3, {r2, r4, r5}
 698:	0b3b0b3a 	bleq	ec3388 <__bss_end+0xeba474>
 69c:	13490b39 	movtne	r0, #39737	; 0x9b39
 6a0:	00001802 	andeq	r1, r0, r2, lsl #16
 6a4:	3f012e27 	svccc	0x00012e27
 6a8:	3a0e0319 	bcc	381314 <__bss_end+0x378400>
 6ac:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 6b0:	110e6e0b 	tstne	lr, fp, lsl #28
 6b4:	40061201 	andmi	r1, r6, r1, lsl #4
 6b8:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 6bc:	00001301 	andeq	r1, r0, r1, lsl #6
 6c0:	3f002e28 	svccc	0x00002e28
 6c4:	3a0e0319 	bcc	381330 <__bss_end+0x37841c>
 6c8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 6cc:	110e6e0b 	tstne	lr, fp, lsl #28
 6d0:	40061201 	andmi	r1, r6, r1, lsl #4
 6d4:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 6d8:	2e290000 	cdpcs	0, 2, cr0, cr9, cr0, {0}
 6dc:	03193f01 	tsteq	r9, #1, 30
 6e0:	3b0b3a0e 	blcc	2cef20 <__bss_end+0x2c600c>
 6e4:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 6e8:	1113490e 	tstne	r3, lr, lsl #18
 6ec:	40061201 	andmi	r1, r6, r1, lsl #4
 6f0:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 6f4:	01000000 	mrseq	r0, (UNDEF: 0)
 6f8:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 6fc:	0e030b13 	vmoveq.32	d3[0], r0
 700:	01110e1b 	tsteq	r1, fp, lsl lr
 704:	17100612 			; <UNDEFINED> instruction: 0x17100612
 708:	39020000 	stmdbcc	r2, {}	; <UNPREDICTABLE>
 70c:	00130101 	andseq	r0, r3, r1, lsl #2
 710:	00340300 	eorseq	r0, r4, r0, lsl #6
 714:	0b3a0e03 	bleq	e83f28 <__bss_end+0xe7b014>
 718:	0b390b3b 	bleq	e4340c <__bss_end+0xe3a4f8>
 71c:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 720:	00000a1c 	andeq	r0, r0, ip, lsl sl
 724:	3a003a04 	bcc	ef3c <__bss_end+0x6028>
 728:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 72c:	0013180b 	andseq	r1, r3, fp, lsl #16
 730:	01010500 	tsteq	r1, r0, lsl #10
 734:	13011349 	movwne	r1, #4937	; 0x1349
 738:	21060000 	mrscs	r0, (UNDEF: 6)
 73c:	2f134900 	svccs	0x00134900
 740:	0700000b 	streq	r0, [r0, -fp]
 744:	13490026 	movtne	r0, #36902	; 0x9026
 748:	24080000 	strcs	r0, [r8], #-0
 74c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 750:	000e030b 	andeq	r0, lr, fp, lsl #6
 754:	00340900 	eorseq	r0, r4, r0, lsl #18
 758:	00001347 	andeq	r1, r0, r7, asr #6
 75c:	3f012e0a 	svccc	0x00012e0a
 760:	3a0e0319 	bcc	3813cc <__bss_end+0x3784b8>
 764:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 768:	110e6e0b 	tstne	lr, fp, lsl #28
 76c:	40061201 	andmi	r1, r6, r1, lsl #4
 770:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 774:	00001301 	andeq	r1, r0, r1, lsl #6
 778:	0300050b 	movweq	r0, #1291	; 0x50b
 77c:	3b0b3a08 	blcc	2cefa4 <__bss_end+0x2c6090>
 780:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 784:	00180213 	andseq	r0, r8, r3, lsl r2
 788:	00340c00 	eorseq	r0, r4, r0, lsl #24
 78c:	0b3a0e03 	bleq	e83fa0 <__bss_end+0xe7b08c>
 790:	0b390b3b 	bleq	e43484 <__bss_end+0xe3a570>
 794:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 798:	0b0d0000 	bleq	3407a0 <__bss_end+0x33788c>
 79c:	12011101 	andne	r1, r1, #1073741824	; 0x40000000
 7a0:	0e000006 	cdpeq	0, 0, cr0, cr0, cr6, {0}
 7a4:	08030034 	stmdaeq	r3, {r2, r4, r5}
 7a8:	0b3b0b3a 	bleq	ec3498 <__bss_end+0xeba584>
 7ac:	13490b39 	movtne	r0, #39737	; 0x9b39
 7b0:	00001802 	andeq	r1, r0, r2, lsl #16
 7b4:	0b000f0f 	bleq	43f8 <shift+0x43f8>
 7b8:	0013490b 	andseq	r4, r3, fp, lsl #18
 7bc:	00261000 	eoreq	r1, r6, r0
 7c0:	0f110000 	svceq	0x00110000
 7c4:	000b0b00 	andeq	r0, fp, r0, lsl #22
 7c8:	00241200 	eoreq	r1, r4, r0, lsl #4
 7cc:	0b3e0b0b 	bleq	f83400 <__bss_end+0xf7a4ec>
 7d0:	00000803 	andeq	r0, r0, r3, lsl #16
 7d4:	03000513 	movweq	r0, #1299	; 0x513
 7d8:	3b0b3a0e 	blcc	2cf018 <__bss_end+0x2c6104>
 7dc:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 7e0:	00180213 	andseq	r0, r8, r3, lsl r2
 7e4:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 7e8:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 7ec:	0b3b0b3a 	bleq	ec34dc <__bss_end+0xeba5c8>
 7f0:	0e6e0b39 	vmoveq.8	d14[5], r0
 7f4:	01111349 	tsteq	r1, r9, asr #6
 7f8:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 7fc:	01194297 			; <UNDEFINED> instruction: 0x01194297
 800:	15000013 	strne	r0, [r0, #-19]	; 0xffffffed
 804:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 808:	0b3a0e03 	bleq	e8401c <__bss_end+0xe7b108>
 80c:	0b390b3b 	bleq	e43500 <__bss_end+0xe3a5ec>
 810:	01110e6e 	tsteq	r1, lr, ror #28
 814:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 818:	00194296 	mulseq	r9, r6, r2
 81c:	11010000 	mrsne	r0, (UNDEF: 1)
 820:	11061000 	mrsne	r1, (UNDEF: 6)
 824:	03011201 	movweq	r1, #4609	; 0x1201
 828:	250e1b0e 	strcs	r1, [lr, #-2830]	; 0xfffff4f2
 82c:	0005130e 	andeq	r1, r5, lr, lsl #6
 830:	11010000 	mrsne	r0, (UNDEF: 1)
 834:	11061000 	mrsne	r1, (UNDEF: 6)
 838:	03011201 	movweq	r1, #4609	; 0x1201
 83c:	250e1b0e 	strcs	r1, [lr, #-2830]	; 0xfffff4f2
 840:	0005130e 	andeq	r1, r5, lr, lsl #6
 844:	11010000 	mrsne	r0, (UNDEF: 1)
 848:	130e2501 	movwne	r2, #58625	; 0xe501
 84c:	1b0e030b 	blne	381480 <__bss_end+0x37856c>
 850:	0017100e 	andseq	r1, r7, lr
 854:	00240200 	eoreq	r0, r4, r0, lsl #4
 858:	0b3e0b0b 	bleq	f8348c <__bss_end+0xf7a578>
 85c:	00000803 	andeq	r0, r0, r3, lsl #16
 860:	0b002403 	bleq	9874 <__bss_end+0x960>
 864:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 868:	0400000e 	streq	r0, [r0], #-14
 86c:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 870:	0b3b0b3a 	bleq	ec3560 <__bss_end+0xeba64c>
 874:	13490b39 	movtne	r0, #39737	; 0x9b39
 878:	0f050000 	svceq	0x00050000
 87c:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 880:	06000013 			; <UNDEFINED> instruction: 0x06000013
 884:	19270115 	stmdbne	r7!, {r0, r2, r4, r8}
 888:	13011349 	movwne	r1, #4937	; 0x1349
 88c:	05070000 	streq	r0, [r7, #-0]
 890:	00134900 	andseq	r4, r3, r0, lsl #18
 894:	00260800 	eoreq	r0, r6, r0, lsl #16
 898:	34090000 	strcc	r0, [r9], #-0
 89c:	3a0e0300 	bcc	3814a4 <__bss_end+0x378590>
 8a0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 8a4:	3f13490b 	svccc	0x0013490b
 8a8:	00193c19 	andseq	r3, r9, r9, lsl ip
 8ac:	01040a00 	tsteq	r4, r0, lsl #20
 8b0:	0b3e0e03 	bleq	f840c4 <__bss_end+0xf7b1b0>
 8b4:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 8b8:	0b3b0b3a 	bleq	ec35a8 <__bss_end+0xeba694>
 8bc:	13010b39 	movwne	r0, #6969	; 0x1b39
 8c0:	280b0000 	stmdacs	fp, {}	; <UNPREDICTABLE>
 8c4:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 8c8:	0c00000b 	stceq	0, cr0, [r0], {11}
 8cc:	13490101 	movtne	r0, #37121	; 0x9101
 8d0:	00001301 	andeq	r1, r0, r1, lsl #6
 8d4:	0000210d 	andeq	r2, r0, sp, lsl #2
 8d8:	00260e00 	eoreq	r0, r6, r0, lsl #28
 8dc:	00001349 	andeq	r1, r0, r9, asr #6
 8e0:	0300340f 	movweq	r3, #1039	; 0x40f
 8e4:	3b0b3a0e 	blcc	2cf124 <__bss_end+0x2c6210>
 8e8:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 8ec:	3c193f13 	ldccc	15, cr3, [r9], {19}
 8f0:	10000019 	andne	r0, r0, r9, lsl r0
 8f4:	0e030013 	mcreq	0, 0, r0, cr3, cr3, {0}
 8f8:	0000193c 	andeq	r1, r0, ip, lsr r9
 8fc:	27001511 	smladcs	r0, r1, r5, r1
 900:	12000019 	andne	r0, r0, #25
 904:	0e030017 	mcreq	0, 0, r0, cr3, cr7, {0}
 908:	0000193c 	andeq	r1, r0, ip, lsr r9
 90c:	03011313 	movweq	r1, #4883	; 0x1313
 910:	3a0b0b0e 	bcc	2c3550 <__bss_end+0x2ba63c>
 914:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 918:	0013010b 	andseq	r0, r3, fp, lsl #2
 91c:	000d1400 	andeq	r1, sp, r0, lsl #8
 920:	0b3a0e03 	bleq	e84134 <__bss_end+0xe7b220>
 924:	0b39053b 	bleq	e41e18 <__bss_end+0xe38f04>
 928:	0b381349 	bleq	e05654 <__bss_end+0xdfc740>
 92c:	21150000 	tstcs	r5, r0
 930:	2f134900 	svccs	0x00134900
 934:	1600000b 	strne	r0, [r0], -fp
 938:	0e030104 	adfeqs	f0, f3, f4
 93c:	0b0b0b3e 	bleq	2c363c <__bss_end+0x2ba728>
 940:	0b3a1349 	bleq	e8566c <__bss_end+0xe7c758>
 944:	0b39053b 	bleq	e41e38 <__bss_end+0xe38f24>
 948:	00001301 	andeq	r1, r0, r1, lsl #6
 94c:	47003417 	smladmi	r0, r7, r4, r3
 950:	3b0b3a13 	blcc	2cf1a4 <__bss_end+0x2c6290>
 954:	020b3905 	andeq	r3, fp, #81920	; 0x14000
 958:	00000018 	andeq	r0, r0, r8, lsl r0

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
  74:	000000dc 	ldrdeq	r0, [r0], -ip
	...
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	10d10002 	sbcsne	r0, r1, r2
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	00008314 	andeq	r8, r0, r4, lsl r3
  94:	0000045c 	andeq	r0, r0, ip, asr r4
	...
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	1dac0002 	stcne	0, cr0, [ip, #8]!
  a8:	00040000 	andeq	r0, r4, r0
  ac:	00000000 	andeq	r0, r0, r0
  b0:	00008770 	andeq	r8, r0, r0, ror r7
  b4:	000004b8 			; <UNDEFINED> instruction: 0x000004b8
	...
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	20de0002 	sbcscs	r0, lr, r2
  c8:	00040000 	andeq	r0, r4, r0
  cc:	00000000 	andeq	r0, r0, r0
  d0:	00008c28 	andeq	r8, r0, r8, lsr #24
  d4:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	21040002 	tstcs	r4, r2
  e8:	00040000 	andeq	r0, r4, r0
  ec:	00000000 	andeq	r0, r0, r0
  f0:	00008e34 	andeq	r8, r0, r4, lsr lr
  f4:	00000004 	andeq	r0, r0, r4
	...
 100:	00000014 	andeq	r0, r0, r4, lsl r0
 104:	212a0002 			; <UNDEFINED> instruction: 0x212a0002
 108:	00040000 	andeq	r0, r4, r0
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffff4c <__bss_end+0xffff7038>
       4:	63732f65 	cmnvs	r3, #404	; 0x194
       8:	6b6e6568 	blvs	1b995b0 <__bss_end+0x1b9069c>
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
      48:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffd21 <__bss_end+0xffff6e0d>
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
      84:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffd5d <__bss_end+0xffff6e49>
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
     20c:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffee5 <__bss_end+0xffff6fd1>
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
     248:	2b2b4320 	blcs	ad0ed0 <__bss_end+0xac7fbc>
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
     2cc:	6a363731 	bvs	d8df98 <__bss_end+0xd85084>
     2d0:	732d667a 			; <UNDEFINED> instruction: 0x732d667a
     2d4:	616d2d20 	cmnvs	sp, r0, lsr #26
     2d8:	2d206d72 	stccs	13, cr6, [r0, #-456]!	; 0xfffffe38
     2dc:	6372616d 	cmnvs	r2, #1073741851	; 0x4000001b
     2e0:	72613d68 	rsbvc	r3, r1, #104, 26	; 0x1a00
     2e4:	7a36766d 	bvc	d9dca0 <__bss_end+0xd94d8c>
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
     39c:	63695400 	cmnvs	r9, #0, 8
     3a0:	6f435f6b 	svcvs	0x00435f6b
     3a4:	00746e75 	rsbseq	r6, r4, r5, ror lr
     3a8:	65646e49 	strbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     3ac:	696e6966 	stmdbvs	lr!, {r1, r2, r5, r6, r8, fp, sp, lr}^
     3b0:	5f006574 	svcpl	0x00006574
     3b4:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     3b8:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     3bc:	61485f4f 	cmpvs	r8, pc, asr #30
     3c0:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     3c4:	45393172 	ldrmi	r3, [r9, #-370]!	; 0xfffffe8e
     3c8:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
     3cc:	76455f65 	strbvc	r5, [r5], -r5, ror #30
     3d0:	5f746e65 	svcpl	0x00746e65
     3d4:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     3d8:	6a457463 	bvs	115d56c <__bss_end+0x1154658>
     3dc:	474e3032 	smlaldxmi	r3, lr, r2, r0
     3e0:	5f4f4950 	svcpl	0x004f4950
     3e4:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     3e8:	70757272 	rsbsvc	r7, r5, r2, ror r2
     3ec:	79545f74 	ldmdbvc	r4, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     3f0:	5f006570 	svcpl	0x00006570
     3f4:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     3f8:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     3fc:	61485f4f 	cmpvs	r8, pc, asr #30
     400:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     404:	52313172 	eorspl	r3, r1, #-2147483620	; 0x8000001c
     408:	72657365 	rsbvc	r7, r5, #-1811939327	; 0x94000001
     40c:	505f6576 	subspl	r6, pc, r6, ror r5	; <UNPREDICTABLE>
     410:	6a456e69 	bvs	115bdbc <__bss_end+0x1152ea8>
     414:	41006262 	tstmi	r0, r2, ror #4
     418:	305f746c 	subscc	r7, pc, ip, ror #8
     41c:	65704f00 	ldrbvs	r4, [r0, #-3840]!	; 0xfffff100
     420:	6c41006e 	mcrrvs	0, 6, r0, r1, cr14
     424:	00335f74 	eorseq	r5, r3, r4, ror pc
     428:	5f746c41 	svcpl	0x00746c41
     42c:	72700034 	rsbsvc	r0, r0, #52	; 0x34
     430:	5f007665 	svcpl	0x00007665
     434:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     438:	6f725043 	svcvs	0x00725043
     43c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     440:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     444:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     448:	6f4e3431 	svcvs	0x004e3431
     44c:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     450:	6f72505f 	svcvs	0x0072505f
     454:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     458:	32315045 	eorscc	r5, r1, #69	; 0x45
     45c:	73615454 	cmnvc	r1, #84, 8	; 0x54000000
     460:	74535f6b 	ldrbvc	r5, [r3], #-3947	; 0xfffff095
     464:	74637572 	strbtvc	r7, [r3], #-1394	; 0xfffffa8e
     468:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     46c:	46433131 			; <UNDEFINED> instruction: 0x46433131
     470:	73656c69 	cmnvc	r5, #26880	; 0x6900
     474:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     478:	5433316d 	ldrtpl	r3, [r3], #-365	; 0xfffffe93
     47c:	545f5346 	ldrbpl	r5, [pc], #-838	; 484 <shift+0x484>
     480:	5f656572 	svcpl	0x00656572
     484:	65646f4e 	strbvs	r6, [r4, #-3918]!	; 0xfffff0b2
     488:	69463031 	stmdbvs	r6, {r0, r4, r5, ip, sp}^
     48c:	435f646e 	cmpmi	pc, #1845493760	; 0x6e000000
     490:	646c6968 	strbtvs	r6, [ip], #-2408	; 0xfffff698
     494:	634b5045 	movtvs	r5, #45125	; 0xb045
     498:	6d6e5500 	cfstr64vs	mvdx5, [lr, #-0]
     49c:	465f7061 	ldrbmi	r7, [pc], -r1, rrx
     4a0:	5f656c69 	svcpl	0x00656c69
     4a4:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     4a8:	00746e65 	rsbseq	r6, r4, r5, ror #28
     4ac:	314e5a5f 	cmpcc	lr, pc, asr sl
     4b0:	50474333 	subpl	r4, r7, r3, lsr r3
     4b4:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     4b8:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     4bc:	47397265 	ldrmi	r7, [r9, -r5, ror #4]!
     4c0:	495f7465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
     4c4:	7475706e 	ldrbtvc	r7, [r5], #-110	; 0xffffff92
     4c8:	42006a45 	andmi	r6, r0, #282624	; 0x45000
     4cc:	5f324353 	svcpl	0x00324353
     4d0:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     4d4:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     4d8:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     4dc:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
     4e0:	676e654c 	strbvs	r6, [lr, -ip, asr #10]!
     4e4:	6d006874 	stcvs	8, cr6, [r0, #-464]	; 0xfffffe30
     4e8:	636f7250 	cmnvs	pc, #80, 4
     4ec:	5f737365 	svcpl	0x00737365
     4f0:	7473694c 	ldrbtvc	r6, [r3], #-2380	; 0xfffff6b4
     4f4:	6165485f 	cmnvs	r5, pc, asr r8
     4f8:	65530064 	ldrbvs	r0, [r3, #-100]	; 0xffffff9c
     4fc:	50475f74 	subpl	r5, r7, r4, ror pc
     500:	465f4f49 	ldrbmi	r4, [pc], -r9, asr #30
     504:	74636e75 	strbtvc	r6, [r3], #-3701	; 0xfffff18b
     508:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     50c:	4b4e5a5f 	blmi	1396e90 <__bss_end+0x138df7c>
     510:	50433631 	subpl	r3, r3, r1, lsr r6
     514:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     518:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 354 <shift+0x354>
     51c:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     520:	39317265 	ldmdbcc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     524:	5f746547 	svcpl	0x00746547
     528:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     52c:	5f746e65 	svcpl	0x00746e65
     530:	636f7250 	cmnvs	pc, #80, 4
     534:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
     538:	65470076 	strbvs	r0, [r7, #-118]	; 0xffffff8a
     53c:	50475f74 	subpl	r5, r7, r4, ror pc
     540:	5f534445 	svcpl	0x00534445
     544:	61636f4c 	cmnvs	r3, ip, asr #30
     548:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     54c:	78656e00 	stmdavc	r5!, {r9, sl, fp, sp, lr}^
     550:	6c6f0074 	stclvs	0, cr0, [pc], #-464	; 388 <shift+0x388>
     554:	61747364 	cmnvs	r4, r4, ror #6
     558:	47006574 	smlsdxmi	r0, r4, r5, r6
     55c:	505f7465 	subspl	r7, pc, r5, ror #8
     560:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     564:	425f7373 	subsmi	r7, pc, #-872415231	; 0xcc000001
     568:	49505f79 	ldmdbmi	r0, {r0, r3, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     56c:	6f6d0044 	svcvs	0x006d0044
     570:	50746e75 	rsbspl	r6, r4, r5, ror lr
     574:	746e696f 	strbtvc	r6, [lr], #-2415	; 0xfffff691
     578:	44736900 	ldrbtmi	r6, [r3], #-2304	; 0xfffff700
     57c:	63657269 	cmnvs	r5, #-1879048186	; 0x90000006
     580:	79726f74 	ldmdbvc	r2!, {r2, r4, r5, r6, r8, r9, sl, fp, sp, lr}^
     584:	57534e00 	ldrbpl	r4, [r3, -r0, lsl #28]
     588:	72505f49 	subsvc	r5, r0, #292	; 0x124
     58c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     590:	65535f73 	ldrbvs	r5, [r3, #-3955]	; 0xfffff08d
     594:	63697672 	cmnvs	r9, #119537664	; 0x7200000
     598:	63410065 	movtvs	r0, #4197	; 0x1065
     59c:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
     5a0:	6f72505f 	svcvs	0x0072505f
     5a4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     5a8:	756f435f 	strbvc	r4, [pc, #-863]!	; 251 <shift+0x251>
     5ac:	6d00746e 	cfstrsvs	mvf7, [r0, #-440]	; 0xfffffe48
     5b0:	5f6e6950 	svcpl	0x006e6950
     5b4:	65736552 	ldrbvs	r6, [r3, #-1362]!	; 0xfffffaae
     5b8:	74617672 	strbtvc	r7, [r1], #-1650	; 0xfffff98e
     5bc:	736e6f69 	cmnvc	lr, #420	; 0x1a4
     5c0:	6165525f 	cmnvs	r5, pc, asr r2
     5c4:	57540064 	ldrbpl	r0, [r4, -r4, rrx]
     5c8:	69746961 	ldmdbvs	r4!, {r0, r5, r6, r8, fp, sp, lr}^
     5cc:	465f676e 	ldrbmi	r6, [pc], -lr, ror #14
     5d0:	00656c69 	rsbeq	r6, r5, r9, ror #24
     5d4:	61657243 	cmnvs	r5, r3, asr #4
     5d8:	505f6574 	subspl	r6, pc, r4, ror r5	; <UNPREDICTABLE>
     5dc:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     5e0:	6d007373 	stcvs	3, cr7, [r0, #-460]	; 0xfffffe34
     5e4:	4f495047 	svcmi	0x00495047
     5e8:	72617000 	rsbvc	r7, r1, #0
     5ec:	00746e65 	rsbseq	r6, r4, r5, ror #28
     5f0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 53c <shift+0x53c>
     5f4:	63732f65 	cmnvs	r3, #404	; 0x194
     5f8:	6b6e6568 	blvs	1b99ba0 <__bss_end+0x1b90c8c>
     5fc:	736f2f6a 	cmnvc	pc, #424	; 0x1a8
     600:	32323032 	eorscc	r3, r2, #50	; 0x32
     604:	2f70732f 	svccs	0x0070732f
     608:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     60c:	2f736563 	svccs	0x00736563
     610:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     614:	63617073 	cmnvs	r1, #115	; 0x73
     618:	69742f65 	ldmdbvs	r4!, {r0, r2, r5, r6, r8, r9, sl, fp, sp}^
     61c:	745f746c 	ldrbvc	r7, [pc], #-1132	; 624 <shift+0x624>
     620:	2f6b7361 	svccs	0x006b7361
     624:	6e69616d 	powvsez	f6, f1, #5.0
     628:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     62c:	58554100 	ldmdapl	r5, {r8, lr}^
     630:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     634:	65470065 	strbvs	r0, [r7, #-101]	; 0xffffff9b
     638:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     63c:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     640:	5f72656c 	svcpl	0x0072656c
     644:	6f666e49 	svcvs	0x00666e49
     648:	69707300 	ldmdbvs	r0!, {r8, r9, ip, sp, lr}^
     64c:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
     650:	00745f6b 	rsbseq	r5, r4, fp, ror #30
     654:	64616544 	strbtvs	r6, [r1], #-1348	; 0xfffffabc
     658:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     65c:	636e555f 	cmnvs	lr, #398458880	; 0x17c00000
     660:	676e6168 	strbvs	r6, [lr, -r8, ror #2]!
     664:	43006465 	movwmi	r6, #1125	; 0x465
     668:	636f7250 	cmnvs	pc, #80, 4
     66c:	5f737365 	svcpl	0x00737365
     670:	616e614d 	cmnvs	lr, sp, asr #2
     674:	00726567 	rsbseq	r6, r2, r7, ror #10
     678:	314e5a5f 	cmpcc	lr, pc, asr sl
     67c:	69464331 	stmdbvs	r6, {r0, r4, r5, r8, r9, lr}^
     680:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     684:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     688:	76453443 	strbvc	r3, [r5], -r3, asr #8
     68c:	53465400 	movtpl	r5, #25600	; 0x6400
     690:	6972445f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, sl, lr}^
     694:	00726576 	rsbseq	r6, r2, r6, ror r5
     698:	314e5a5f 	cmpcc	lr, pc, asr sl
     69c:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     6a0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     6a4:	614d5f73 	hvcvs	54771	; 0xd5f3
     6a8:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     6ac:	47383172 			; <UNDEFINED> instruction: 0x47383172
     6b0:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     6b4:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     6b8:	72656c75 	rsbvc	r6, r5, #29952	; 0x7500
     6bc:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     6c0:	3032456f 	eorscc	r4, r2, pc, ror #10
     6c4:	7465474e 	strbtvc	r4, [r5], #-1870	; 0xfffff8b2
     6c8:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     6cc:	495f6465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     6d0:	5f6f666e 	svcpl	0x006f666e
     6d4:	65707954 	ldrbvs	r7, [r0, #-2388]!	; 0xfffff6ac
     6d8:	5f007650 	svcpl	0x00007650
     6dc:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     6e0:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     6e4:	61485f4f 	cmpvs	r8, pc, asr #30
     6e8:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     6ec:	43303272 	teqmi	r0, #536870919	; 0x20000007
     6f0:	7261656c 	rsbvc	r6, r1, #108, 10	; 0x1b000000
     6f4:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     6f8:	65746365 	ldrbvs	r6, [r4, #-869]!	; 0xfffffc9b
     6fc:	76455f64 	strbvc	r5, [r5], -r4, ror #30
     700:	45746e65 	ldrbmi	r6, [r4, #-3685]!	; 0xfffff19b
     704:	5a5f006a 	bpl	17c08b4 <__bss_end+0x17b79a0>
     708:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     70c:	636f7250 	cmnvs	pc, #80, 4
     710:	5f737365 	svcpl	0x00737365
     714:	616e614d 	cmnvs	lr, sp, asr #2
     718:	32726567 	rsbscc	r6, r2, #432013312	; 0x19c00000
     71c:	6e614831 	mcrvs	8, 3, r4, cr1, cr1, {1}
     720:	5f656c64 	svcpl	0x00656c64
     724:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     728:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     72c:	535f6d65 	cmppl	pc, #6464	; 0x1940
     730:	32454957 	subcc	r4, r5, #1425408	; 0x15c000
     734:	57534e33 	smmlarpl	r3, r3, lr, r4
     738:	69465f49 	stmdbvs	r6, {r0, r3, r6, r8, r9, sl, fp, ip, lr}^
     73c:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     740:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     744:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
     748:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     74c:	526a6a6a 	rsbpl	r6, sl, #434176	; 0x6a000
     750:	53543131 	cmppl	r4, #1073741836	; 0x4000000c
     754:	525f4957 	subspl	r4, pc, #1425408	; 0x15c000
     758:	6c757365 	ldclvs	3, cr7, [r5], #-404	; 0xfffffe6c
     75c:	61460074 	hvcvs	24580	; 0x6004
     760:	6e696c6c 	cdpvs	12, 6, cr6, cr9, cr12, {3}
     764:	64455f67 	strbvs	r5, [r5], #-3943	; 0xfffff099
     768:	6f006567 	svcvs	0x00006567
     76c:	656e6570 	strbvs	r6, [lr, #-1392]!	; 0xfffffa90
     770:	69665f64 	stmdbvs	r6!, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     774:	0073656c 	rsbseq	r6, r3, ip, ror #10
     778:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     77c:	6c417966 	mcrrvs	9, 6, r7, r1, cr6	; <UNPREDICTABLE>
     780:	5a5f006c 	bpl	17c0938 <__bss_end+0x17b7a24>
     784:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     788:	4f495047 	svcmi	0x00495047
     78c:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     790:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     794:	69443032 	stmdbvs	r4, {r1, r4, r5, ip, sp}^
     798:	6c626173 	stfvse	f6, [r2], #-460	; 0xfffffe34
     79c:	76455f65 	strbvc	r5, [r5], -r5, ror #30
     7a0:	5f746e65 	svcpl	0x00746e65
     7a4:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     7a8:	6a457463 	bvs	115d93c <__bss_end+0x1154a28>
     7ac:	474e3032 	smlaldxmi	r3, lr, r2, r0
     7b0:	5f4f4950 	svcpl	0x004f4950
     7b4:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     7b8:	70757272 	rsbsvc	r7, r5, r2, ror r2
     7bc:	79545f74 	ldmdbvc	r4, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     7c0:	54006570 	strpl	r6, [r0], #-1392	; 0xfffffa90
     7c4:	5f555043 	svcpl	0x00555043
     7c8:	746e6f43 	strbtvc	r6, [lr], #-3907	; 0xfffff0bd
     7cc:	00747865 	rsbseq	r7, r4, r5, ror #16
     7d0:	64616544 	strbtvs	r6, [r1], #-1348	; 0xfffffabc
     7d4:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     7d8:	62747400 	rsbsvs	r7, r4, #0, 8
     7dc:	5f003072 	svcpl	0x00003072
     7e0:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     7e4:	6f725043 	svcvs	0x00725043
     7e8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     7ec:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     7f0:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     7f4:	6f4e3431 	svcvs	0x004e3431
     7f8:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     7fc:	6f72505f 	svcvs	0x0072505f
     800:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     804:	47006a45 	strmi	r6, [r0, -r5, asr #20]
     808:	505f7465 	subspl	r7, pc, r5, ror #8
     80c:	42004449 	andmi	r4, r0, #1224736768	; 0x49000000
     810:	5f304353 	svcpl	0x00304353
     814:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     818:	6e694600 	cdpvs	6, 6, cr4, cr9, cr0, {0}
     81c:	68435f64 	stmdavs	r3, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     820:	00646c69 	rsbeq	r6, r4, r9, ror #24
     824:	69746f6e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     828:	64656966 	strbtvs	r6, [r5], #-2406	; 0xfffff69a
     82c:	6165645f 	cmnvs	r5, pc, asr r4
     830:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     834:	6e490065 	cdpvs	0, 4, cr0, cr9, cr5, {3}
     838:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     83c:	5f747075 	svcpl	0x00747075
     840:	746e6f43 	strbtvc	r6, [lr], #-3907	; 0xfffff0bd
     844:	6c6c6f72 	stclvs	15, cr6, [ip], #-456	; 0xfffffe38
     848:	425f7265 	subsmi	r7, pc, #1342177286	; 0x50000006
     84c:	00657361 	rsbeq	r7, r5, r1, ror #6
     850:	314e5a5f 	cmpcc	lr, pc, asr sl
     854:	50474333 	subpl	r4, r7, r3, lsr r3
     858:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     85c:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     860:	46387265 	ldrtmi	r7, [r8], -r5, ror #4
     864:	5f656572 	svcpl	0x00656572
     868:	456e6950 	strbmi	r6, [lr, #-2384]!	; 0xfffff6b0
     86c:	0062626a 	rsbeq	r6, r2, sl, ror #4
     870:	31435342 	cmpcc	r3, r2, asr #6
     874:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     878:	614d0065 	cmpvs	sp, r5, rrx
     87c:	72505f78 	subsvc	r5, r0, #120, 30	; 0x1e0
     880:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     884:	704f5f73 	subvc	r5, pc, r3, ror pc	; <UNPREDICTABLE>
     888:	64656e65 	strbtvs	r6, [r5], #-3685	; 0xfffff19b
     88c:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     890:	5f007365 	svcpl	0x00007365
     894:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     898:	6f725043 	svcvs	0x00725043
     89c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     8a0:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     8a4:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     8a8:	6e553831 	mrcvs	8, 2, r3, cr5, cr1, {1}
     8ac:	5f70616d 	svcpl	0x0070616d
     8b0:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     8b4:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     8b8:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     8bc:	54006a45 	strpl	r6, [r0], #-2629	; 0xfffff5bb
     8c0:	5f474e52 	svcpl	0x00474e52
     8c4:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     8c8:	67694800 	strbvs	r4, [r9, -r0, lsl #16]!
     8cc:	46670068 	strbtmi	r0, [r7], -r8, rrx
     8d0:	72445f53 	subvc	r5, r4, #332	; 0x14c
     8d4:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     8d8:	6f435f73 	svcvs	0x00435f73
     8dc:	00746e75 	rsbseq	r6, r4, r5, ror lr
     8e0:	4b4e5a5f 	blmi	1397264 <__bss_end+0x138e350>
     8e4:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     8e8:	5f4f4950 	svcpl	0x004f4950
     8ec:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     8f0:	3272656c 	rsbscc	r6, r2, #108, 10	; 0x1b000000
     8f4:	74654736 	strbtvc	r4, [r5], #-1846	; 0xfffff8ca
     8f8:	5f50475f 	svcpl	0x0050475f
     8fc:	5f515249 	svcpl	0x00515249
     900:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     904:	4c5f7463 	cfldrdmi	mvd7, [pc], {99}	; 0x63
     908:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     90c:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
     910:	4e30326a 	cdpmi	2, 3, cr3, cr0, cr10, {3}
     914:	4f495047 	svcmi	0x00495047
     918:	746e495f 	strbtvc	r4, [lr], #-2399	; 0xfffff6a1
     91c:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     920:	545f7470 	ldrbpl	r7, [pc], #-1136	; 928 <shift+0x928>
     924:	52657079 	rsbpl	r7, r5, #121	; 0x79
     928:	5f31536a 	svcpl	0x0031536a
     92c:	73695200 	cmnvc	r9, #0, 4
     930:	5f676e69 	svcpl	0x00676e69
     934:	65676445 	strbvs	r6, [r7, #-1093]!	; 0xfffffbbb
     938:	6f526d00 	svcvs	0x00526d00
     93c:	535f746f 	cmppl	pc, #1862270976	; 0x6f000000
     940:	47007379 	smlsdxmi	r0, r9, r3, r7
     944:	435f7465 	cmpmi	pc, #1694498816	; 0x65000000
     948:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     94c:	505f746e 	subspl	r7, pc, lr, ror #8
     950:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     954:	4d007373 	stcmi	3, cr7, [r0, #-460]	; 0xfffffe34
     958:	465f7061 	ldrbmi	r7, [pc], -r1, rrx
     95c:	5f656c69 	svcpl	0x00656c69
     960:	435f6f54 	cmpmi	pc, #84, 30	; 0x150
     964:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     968:	5f00746e 	svcpl	0x0000746e
     96c:	314b4e5a 	cmpcc	fp, sl, asr lr
     970:	50474333 	subpl	r4, r7, r3, lsr r3
     974:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     978:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     97c:	39317265 	ldmdbcc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     980:	5f746547 	svcpl	0x00746547
     984:	53465047 	movtpl	r5, #24647	; 0x6047
     988:	4c5f4c45 	mrrcmi	12, 4, r4, pc, cr5	; <UNPREDICTABLE>
     98c:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     990:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
     994:	536a526a 	cmnpl	sl, #-1610612730	; 0xa0000006
     998:	4e005f30 	mcrmi	15, 0, r5, cr0, cr0, {1}
     99c:	6c69466f 	stclvs	6, cr4, [r9], #-444	; 0xfffffe44
     9a0:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     9a4:	446d6574 	strbtmi	r6, [sp], #-1396	; 0xfffffa8c
     9a8:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     9ac:	65530072 	ldrbvs	r0, [r3, #-114]	; 0xffffff8e
     9b0:	61505f74 	cmpvs	r0, r4, ror pc
     9b4:	736d6172 	cmnvc	sp, #-2147483620	; 0x8000001c
     9b8:	6e614800 	cdpvs	8, 6, cr4, cr1, cr0, {0}
     9bc:	5f656c64 	svcpl	0x00656c64
     9c0:	636f7250 	cmnvs	pc, #80, 4
     9c4:	5f737365 	svcpl	0x00737365
     9c8:	00495753 	subeq	r5, r9, r3, asr r7
     9cc:	726f6873 	rsbvc	r6, pc, #7536640	; 0x730000
     9d0:	6e752074 	mrcvs	0, 3, r2, cr5, cr4, {3}
     9d4:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
     9d8:	69206465 	stmdbvs	r0!, {r0, r2, r5, r6, sl, sp, lr}
     9dc:	5300746e 	movwpl	r7, #1134	; 0x46e
     9e0:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     9e4:	5f656c75 	svcpl	0x00656c75
     9e8:	00464445 	subeq	r4, r6, r5, asr #8
     9ec:	74696157 	strbtvc	r6, [r9], #-343	; 0xfffffea9
     9f0:	73694400 	cmnvc	r9, #0, 8
     9f4:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     9f8:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     9fc:	445f746e 	ldrbmi	r7, [pc], #-1134	; a04 <shift+0xa04>
     a00:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     a04:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     a08:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     a0c:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     a10:	5f4f4950 	svcpl	0x004f4950
     a14:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     a18:	3172656c 	cmncc	r2, ip, ror #10
     a1c:	6e614830 	mcrvs	8, 3, r4, cr1, cr0, {1}
     a20:	5f656c64 	svcpl	0x00656c64
     a24:	45515249 	ldrbmi	r5, [r1, #-585]	; 0xfffffdb7
     a28:	5a5f0076 	bpl	17c0c08 <__bss_end+0x17b7cf4>
     a2c:	4331314e 	teqmi	r1, #-2147483629	; 0x80000013
     a30:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     a34:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     a38:	30316d65 	eorscc	r6, r1, r5, ror #26
     a3c:	74696e49 	strbtvc	r6, [r9], #-3657	; 0xfffff1b7
     a40:	696c6169 	stmdbvs	ip!, {r0, r3, r5, r6, r8, sp, lr}^
     a44:	7645657a 			; <UNDEFINED> instruction: 0x7645657a
     a48:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     a4c:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     a50:	65746365 	ldrbvs	r6, [r4, #-869]!	; 0xfffffc9b
     a54:	76455f64 	strbvc	r5, [r5], -r4, ror #30
     a58:	5f746e65 	svcpl	0x00746e65
     a5c:	006e6950 	rsbeq	r6, lr, r0, asr r9
     a60:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     a64:	70757272 	rsbsvc	r7, r5, r2, ror r2
     a68:	6c626174 	stfvse	f6, [r2], #-464	; 0xfffffe30
     a6c:	6c535f65 	mrrcvs	15, 6, r5, r3, cr5
     a70:	00706565 	rsbseq	r6, r0, r5, ror #10
     a74:	6f6f526d 	svcvs	0x006f526d
     a78:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     a7c:	6f620076 	svcvs	0x00620076
     a80:	41006c6f 	tstmi	r0, pc, ror #24
     a84:	315f746c 	cmpcc	pc, ip, ror #8
     a88:	746c4100 	strbtvc	r4, [ip], #-256	; 0xffffff00
     a8c:	6d00325f 	sfmvs	f3, 4, [r0, #-380]	; 0xfffffe84
     a90:	7473614c 	ldrbtvc	r6, [r3], #-332	; 0xfffffeb4
     a94:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
     a98:	6f6c4200 	svcvs	0x006c4200
     a9c:	64656b63 	strbtvs	r6, [r5], #-2915	; 0xfffff49d
     aa0:	65474e00 	strbvs	r4, [r7, #-3584]	; 0xfffff200
     aa4:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     aa8:	5f646568 	svcpl	0x00646568
     aac:	6f666e49 	svcvs	0x00666e49
     ab0:	7079545f 	rsbsvc	r5, r9, pc, asr r4
     ab4:	6c410065 	mcrrvs	0, 6, r0, r1, cr5
     ab8:	00355f74 	eorseq	r5, r5, r4, ror pc
     abc:	314e5a5f 	cmpcc	lr, pc, asr sl
     ac0:	50474333 	subpl	r4, r7, r3, lsr r3
     ac4:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     ac8:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     acc:	30317265 	eorscc	r7, r1, r5, ror #4
     ad0:	5f746553 	svcpl	0x00746553
     ad4:	7074754f 	rsbsvc	r7, r4, pc, asr #10
     ad8:	6a457475 	bvs	115dcb4 <__bss_end+0x1154da0>
     adc:	75520062 	ldrbvc	r0, [r2, #-98]	; 0xffffff9e
     ae0:	62616e6e 	rsbvs	r6, r1, #1760	; 0x6e0
     ae4:	4e00656c 	cfsh32mi	mvfx6, mvfx0, #60
     ae8:	6b736154 	blvs	1cd9040 <__bss_end+0x1cd012c>
     aec:	6174535f 	cmnvs	r4, pc, asr r3
     af0:	73006574 	movwvc	r6, #1396	; 0x574
     af4:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     af8:	756f635f 	strbvc	r6, [pc, #-863]!	; 7a1 <shift+0x7a1>
     afc:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     b00:	68637300 	stmdavs	r3!, {r8, r9, ip, sp, lr}^
     b04:	735f6465 	cmpvc	pc, #1694498816	; 0x65000000
     b08:	69746174 	ldmdbvs	r4!, {r2, r4, r5, r6, r8, sp, lr}^
     b0c:	72705f63 	rsbsvc	r5, r0, #396	; 0x18c
     b10:	69726f69 	ldmdbvs	r2!, {r0, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     b14:	49007974 	stmdbmi	r0, {r2, r4, r5, r6, r8, fp, ip, sp, lr}
     b18:	6974696e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, fp, sp, lr}^
     b1c:	7a696c61 	bvc	1a5bca8 <__bss_end+0x1a52d94>
     b20:	46670065 	strbtmi	r0, [r7], -r5, rrx
     b24:	72445f53 	subvc	r5, r4, #332	; 0x14c
     b28:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     b2c:	78650073 	stmdavc	r5!, {r0, r1, r4, r5, r6}^
     b30:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
     b34:	0065646f 	rsbeq	r6, r5, pc, ror #8
     b38:	61766e49 	cmnvs	r6, r9, asr #28
     b3c:	5f64696c 	svcpl	0x0064696c
     b40:	006e6950 	rsbeq	r6, lr, r0, asr r9
     b44:	62616e45 	rsbvs	r6, r1, #1104	; 0x450
     b48:	455f656c 	ldrbmi	r6, [pc, #-1388]	; 5e4 <shift+0x5e4>
     b4c:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     b50:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     b54:	00746365 	rsbseq	r6, r4, r5, ror #6
     b58:	49504773 	ldmdbmi	r0, {r0, r1, r4, r5, r6, r8, r9, sl, lr}^
     b5c:	536d004f 	cmnpl	sp, #79	; 0x4f
     b60:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     b64:	5f656c75 	svcpl	0x00656c75
     b68:	00636e46 	rsbeq	r6, r3, r6, asr #28
     b6c:	6f725073 	svcvs	0x00725073
     b70:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     b74:	0072674d 	rsbseq	r6, r2, sp, asr #14
     b78:	4678614d 	ldrbtmi	r6, [r8], -sp, asr #2
     b7c:	69724453 	ldmdbvs	r2!, {r0, r1, r4, r6, sl, lr}^
     b80:	4e726576 	mrcmi	5, 3, r6, cr2, cr6, {3}
     b84:	4c656d61 	stclmi	13, cr6, [r5], #-388	; 0xfffffe7c
     b88:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
     b8c:	6f4e0068 	svcvs	0x004e0068
     b90:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     b94:	66654400 	strbtvs	r4, [r5], -r0, lsl #8
     b98:	746c7561 	strbtvc	r7, [ip], #-1377	; 0xfffffa9f
     b9c:	6f6c435f 	svcvs	0x006c435f
     ba0:	525f6b63 	subspl	r6, pc, #101376	; 0x18c00
     ba4:	00657461 	rsbeq	r7, r5, r1, ror #8
     ba8:	74696157 	strbtvc	r6, [r9], #-343	; 0xfffffea9
     bac:	726f465f 	rsbvc	r4, pc, #99614720	; 0x5f00000
     bb0:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     bb4:	5f00746e 	svcpl	0x0000746e
     bb8:	314b4e5a 	cmpcc	fp, sl, asr lr
     bbc:	50474333 	subpl	r4, r7, r3, lsr r3
     bc0:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     bc4:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     bc8:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     bcc:	5f746547 	svcpl	0x00746547
     bd0:	4c435047 	mcrrmi	0, 4, r5, r3, cr7
     bd4:	6f4c5f52 	svcvs	0x004c5f52
     bd8:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     bdc:	6a456e6f 	bvs	115c5a0 <__bss_end+0x115368c>
     be0:	30536a52 	subscc	r6, r3, r2, asr sl
     be4:	6f4c005f 	svcvs	0x004c005f
     be8:	555f6b63 	ldrbpl	r6, [pc, #-2915]	; 8d <shift+0x8d>
     bec:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
     bf0:	0064656b 	rsbeq	r6, r4, fp, ror #10
     bf4:	4f495047 	svcmi	0x00495047
     bf8:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     bfc:	65470065 	strbvs	r0, [r7, #-101]	; 0xffffff9b
     c00:	50475f74 	subpl	r5, r7, r4, ror pc
     c04:	5152495f 	cmppl	r2, pc, asr r9
     c08:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     c0c:	5f746365 	svcpl	0x00746365
     c10:	61636f4c 	cmnvs	r3, ip, asr #30
     c14:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     c18:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     c1c:	4350475f 	cmpmi	r0, #24903680	; 0x17c0000
     c20:	4c5f524c 	lfmmi	f5, 2, [pc], {76}	; 0x4c
     c24:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     c28:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     c2c:	6b636f4c 	blvs	18dc964 <__bss_end+0x18d3a50>
     c30:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     c34:	0064656b 	rsbeq	r6, r4, fp, ror #10
     c38:	6e69506d 	cdpvs	0, 6, cr5, cr9, cr13, {3}
     c3c:	7365525f 	cmnvc	r5, #-268435451	; 0xf0000005
     c40:	61767265 	cmnvs	r6, r5, ror #4
     c44:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     c48:	72575f73 	subsvc	r5, r7, #460	; 0x1cc
     c4c:	00657469 	rsbeq	r7, r5, r9, ror #8
     c50:	5f746547 	svcpl	0x00746547
     c54:	53465047 	movtpl	r5, #24647	; 0x6047
     c58:	4c5f4c45 	mrrcmi	12, 4, r4, pc, cr5	; <UNPREDICTABLE>
     c5c:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     c60:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     c64:	5f746553 	svcpl	0x00746553
     c68:	7074754f 	rsbsvc	r7, r4, pc, asr #10
     c6c:	52007475 	andpl	r7, r0, #1962934272	; 0x75000000
     c70:	5f646165 	svcpl	0x00646165
     c74:	74697257 	strbtvc	r7, [r9], #-599	; 0xfffffda9
     c78:	6f5a0065 	svcvs	0x005a0065
     c7c:	6569626d 	strbvs	r6, [r9, #-621]!	; 0xfffffd93
     c80:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     c84:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     c88:	5f4f4950 	svcpl	0x004f4950
     c8c:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     c90:	3172656c 	cmncc	r2, ip, ror #10
     c94:	74655337 	strbtvc	r5, [r5], #-823	; 0xfffffcc9
     c98:	4950475f 	ldmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, r9, sl, lr}^
     c9c:	75465f4f 	strbvc	r5, [r6, #-3919]	; 0xfffff0b1
     ca0:	6974636e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
     ca4:	6a456e6f 	bvs	115c668 <__bss_end+0x1153754>
     ca8:	474e3431 	smlaldxmi	r3, lr, r1, r4
     cac:	5f4f4950 	svcpl	0x004f4950
     cb0:	636e7546 	cmnvs	lr, #293601280	; 0x11800000
     cb4:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     cb8:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     cbc:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     cc0:	495f6465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     cc4:	006f666e 	rsbeq	r6, pc, lr, ror #12
     cc8:	314e5a5f 	cmpcc	lr, pc, asr sl
     ccc:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     cd0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     cd4:	614d5f73 	hvcvs	54771	; 0xd5f3
     cd8:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     cdc:	63533872 	cmpvs	r3, #7471104	; 0x720000
     ce0:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     ce4:	7645656c 	strbvc	r6, [r5], -ip, ror #10
     ce8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     cec:	50433631 	subpl	r3, r3, r1, lsr r6
     cf0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     cf4:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; b30 <shift+0xb30>
     cf8:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     cfc:	39317265 	ldmdbcc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     d00:	5f70614d 	svcpl	0x0070614d
     d04:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     d08:	5f6f545f 	svcpl	0x006f545f
     d0c:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     d10:	45746e65 	ldrbmi	r6, [r4, #-3685]!	; 0xfffff19b
     d14:	46493550 			; <UNDEFINED> instruction: 0x46493550
     d18:	00656c69 	rsbeq	r6, r5, r9, ror #24
     d1c:	61736944 	cmnvs	r3, r4, asr #18
     d20:	5f656c62 	svcpl	0x00656c62
     d24:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     d28:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     d2c:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     d30:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     d34:	7261505f 	rsbvc	r5, r1, #95	; 0x5f
     d38:	00736d61 	rsbseq	r6, r3, r1, ror #26
     d3c:	6c696863 	stclvs	8, cr6, [r9], #-396	; 0xfffffe74
     d40:	6e657264 	cdpvs	2, 6, cr7, cr5, cr4, {3}
     d44:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     d48:	68746150 	ldmdavs	r4!, {r4, r6, r8, sp, lr}^
     d4c:	676e654c 	strbvs	r6, [lr, -ip, asr #10]!
     d50:	75006874 	strvc	r6, [r0, #-2164]	; 0xfffff78c
     d54:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
     d58:	2064656e 	rsbcs	r6, r4, lr, ror #10
     d5c:	72616863 	rsbvc	r6, r1, #6488064	; 0x630000
     d60:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     d64:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
     d68:	4f495047 	svcmi	0x00495047
     d6c:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     d70:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     d74:	65473232 	strbvs	r3, [r7, #-562]	; 0xfffffdce
     d78:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     d7c:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     d80:	455f6465 	ldrbmi	r6, [pc, #-1125]	; 923 <shift+0x923>
     d84:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     d88:	6e69505f 	mcrvs	0, 3, r5, cr9, cr15, {2}
     d8c:	5f007645 	svcpl	0x00007645
     d90:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     d94:	6f725043 	svcvs	0x00725043
     d98:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     d9c:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     da0:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     da4:	63533231 	cmpvs	r3, #268435459	; 0x10000003
     da8:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     dac:	455f656c 	ldrbmi	r6, [pc, #-1388]	; 848 <shift+0x848>
     db0:	76454644 	strbvc	r4, [r5], -r4, asr #12
     db4:	69464300 	stmdbvs	r6, {r8, r9, lr}^
     db8:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     dbc:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     dc0:	49504700 	ldmdbmi	r0, {r8, r9, sl, lr}^
     dc4:	69505f4f 	ldmdbvs	r0, {r0, r1, r2, r3, r6, r8, r9, sl, fp, ip, lr}^
     dc8:	6f435f6e 	svcvs	0x00435f6e
     dcc:	00746e75 	rsbseq	r6, r4, r5, ror lr
     dd0:	726f6873 	rsbvc	r6, pc, #7536640	; 0x730000
     dd4:	6e692074 	mcrvs	0, 3, r2, cr9, cr4, {3}
     dd8:	6e450074 	mcrvs	0, 2, r0, cr5, cr4, {3}
     ddc:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     de0:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     de4:	445f746e 	ldrbmi	r7, [pc], #-1134	; dec <shift+0xdec>
     de8:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     dec:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     df0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     df4:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     df8:	5f4f4950 	svcpl	0x004f4950
     dfc:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     e00:	4372656c 	cmnmi	r2, #108, 10	; 0x1b000000
     e04:	006a4534 	rsbeq	r4, sl, r4, lsr r5
     e08:	69726550 	ldmdbvs	r2!, {r4, r6, r8, sl, sp, lr}^
     e0c:	72656870 	rsbvc	r6, r5, #112, 16	; 0x700000
     e10:	425f6c61 	subsmi	r6, pc, #24832	; 0x6100
     e14:	00657361 	rsbeq	r7, r5, r1, ror #6
     e18:	6f6f526d 	svcvs	0x006f526d
     e1c:	46730074 			; <UNDEFINED> instruction: 0x46730074
     e20:	73656c69 	cmnvc	r5, #26880	; 0x6900
     e24:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     e28:	4c6d006d 	stclmi	0, cr0, [sp], #-436	; 0xfffffe4c
     e2c:	006b636f 	rsbeq	r6, fp, pc, ror #6
     e30:	6e6e7552 	mcrvs	5, 3, r7, cr14, cr2, {2}
     e34:	00676e69 	rsbeq	r6, r7, r9, ror #28
     e38:	314e5a5f 	cmpcc	lr, pc, asr sl
     e3c:	50474333 	subpl	r4, r7, r3, lsr r3
     e40:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     e44:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     e48:	34317265 	ldrtcc	r7, [r1], #-613	; 0xfffffd9b
     e4c:	74696157 	strbtvc	r6, [r9], #-343	; 0xfffffea9
     e50:	726f465f 	rsbvc	r4, pc, #99614720	; 0x5f00000
     e54:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     e58:	5045746e 	subpl	r7, r5, lr, ror #8
     e5c:	69464935 	stmdbvs	r6, {r0, r2, r4, r5, r8, fp, lr}^
     e60:	006a656c 	rsbeq	r6, sl, ip, ror #10
     e64:	746c6974 	strbtvc	r6, [ip], #-2420	; 0xfffff68c
     e68:	736e6573 	cmnvc	lr, #482344960	; 0x1cc00000
     e6c:	665f726f 	ldrbvs	r7, [pc], -pc, ror #4
     e70:	00656c69 	rsbeq	r6, r5, r9, ror #24
     e74:	746e6975 	strbtvc	r6, [lr], #-2421	; 0xfffff68b
     e78:	745f3233 	ldrbvc	r3, [pc], #-563	; e80 <shift+0xe80>
     e7c:	73655200 	cmnvc	r5, #0, 4
     e80:	65767265 	ldrbvs	r7, [r6, #-613]!	; 0xfffffd9b
     e84:	6e69505f 	mcrvs	0, 3, r5, cr9, cr15, {2}
     e88:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     e8c:	4950475f 	ldmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, r9, sl, lr}^
     e90:	75465f4f 	strbvc	r5, [r6, #-3919]	; 0xfffff0b1
     e94:	6974636e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
     e98:	54006e6f 	strpl	r6, [r0], #-3695	; 0xfffff191
     e9c:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     ea0:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     ea4:	436d0065 	cmnmi	sp, #101	; 0x65
     ea8:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     eac:	545f746e 	ldrbpl	r7, [pc], #-1134	; eb4 <shift+0xeb4>
     eb0:	5f6b7361 	svcpl	0x006b7361
     eb4:	65646f4e 	strbvs	r6, [r4, #-3918]!	; 0xfffff0b2
     eb8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     ebc:	46433131 			; <UNDEFINED> instruction: 0x46433131
     ec0:	73656c69 	cmnvc	r5, #26880	; 0x6900
     ec4:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     ec8:	704f346d 	subvc	r3, pc, sp, ror #8
     ecc:	50456e65 	subpl	r6, r5, r5, ror #28
     ed0:	3531634b 	ldrcc	r6, [r1, #-843]!	; 0xfffffcb5
     ed4:	6c69464e 	stclvs	6, cr4, [r9], #-312	; 0xfffffec8
     ed8:	704f5f65 	subvc	r5, pc, r5, ror #30
     edc:	4d5f6e65 	ldclmi	14, cr6, [pc, #-404]	; d50 <shift+0xd50>
     ee0:	0065646f 	rsbeq	r6, r5, pc, ror #8
     ee4:	5f746547 	svcpl	0x00746547
     ee8:	45535047 	ldrbmi	r5, [r3, #-71]	; 0xffffffb9
     eec:	6f4c5f54 	svcvs	0x004c5f54
     ef0:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     ef4:	5f006e6f 	svcpl	0x00006e6f
     ef8:	314b4e5a 	cmpcc	fp, sl, asr lr
     efc:	50474333 	subpl	r4, r7, r3, lsr r3
     f00:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     f04:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     f08:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     f0c:	5f746547 	svcpl	0x00746547
     f10:	454c5047 	strbmi	r5, [ip, #-71]	; 0xffffffb9
     f14:	6f4c5f56 	svcvs	0x004c5f56
     f18:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     f1c:	6a456e6f 	bvs	115c8e0 <__bss_end+0x11539cc>
     f20:	30536a52 	subscc	r6, r3, r2, asr sl
     f24:	576d005f 			; <UNDEFINED> instruction: 0x576d005f
     f28:	69746961 	ldmdbvs	r4!, {r0, r5, r6, r8, fp, sp, lr}^
     f2c:	465f676e 	ldrbmi	r6, [pc], -lr, ror #14
     f30:	73656c69 	cmnvc	r5, #26880	; 0x6900
     f34:	69726400 	ldmdbvs	r2!, {sl, sp, lr}^
     f38:	5f726576 	svcpl	0x00726576
     f3c:	00786469 	rsbseq	r6, r8, r9, ror #8
     f40:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
     f44:	6c6e4f5f 	stclvs	15, cr4, [lr], #-380	; 0xfffffe84
     f48:	6c730079 	ldclvs	0, cr0, [r3], #-484	; 0xfffffe1c
     f4c:	5f706565 	svcpl	0x00706565
     f50:	656d6974 	strbvs	r6, [sp, #-2420]!	; 0xfffff68c
     f54:	5a5f0072 	bpl	17c1124 <__bss_end+0x17b8210>
     f58:	36314b4e 	ldrtcc	r4, [r1], -lr, asr #22
     f5c:	6f725043 	svcvs	0x00725043
     f60:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     f64:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     f68:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     f6c:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
     f70:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     f74:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     f78:	79425f73 	stmdbvc	r2, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     f7c:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
     f80:	48006a45 	stmdami	r0, {r0, r2, r6, r9, fp, sp, lr}
     f84:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     f88:	69465f65 	stmdbvs	r6, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     f8c:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     f90:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     f94:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     f98:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     f9c:	50433631 	subpl	r3, r3, r1, lsr r6
     fa0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     fa4:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; de0 <shift+0xde0>
     fa8:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     fac:	31317265 	teqcc	r1, r5, ror #4
     fb0:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     fb4:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     fb8:	4552525f 	ldrbmi	r5, [r2, #-607]	; 0xfffffda1
     fbc:	61740076 	cmnvs	r4, r6, ror r0
     fc0:	69006b73 	stmdbvs	r0, {r0, r1, r4, r5, r6, r8, r9, fp, sp, lr}
     fc4:	70797472 	rsbsvc	r7, r9, r2, ror r4
     fc8:	65470065 	strbvs	r0, [r7, #-101]	; 0xffffff9b
     fcc:	6e495f74 	mcrvs	15, 2, r5, cr9, cr4, {3}
     fd0:	00747570 	rsbseq	r7, r4, r0, ror r5
     fd4:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     fd8:	505f7966 	subspl	r7, pc, r6, ror #18
     fdc:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     fe0:	53007373 	movwpl	r7, #883	; 0x373
     fe4:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     fe8:	00656c75 	rsbeq	r6, r5, r5, ror ip
     fec:	314e5a5f 	cmpcc	lr, pc, asr sl
     ff0:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     ff4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     ff8:	614d5f73 	hvcvs	54771	; 0xd5f3
     ffc:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
    1000:	42313272 	eorsmi	r3, r1, #536870919	; 0x20000007
    1004:	6b636f6c 	blvs	18dcdbc <__bss_end+0x18d3ea8>
    1008:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
    100c:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
    1010:	6f72505f 	svcvs	0x0072505f
    1014:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1018:	5f007645 	svcpl	0x00007645
    101c:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
    1020:	6f725043 	svcvs	0x00725043
    1024:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1028:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    102c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    1030:	69775339 	ldmdbvs	r7!, {r0, r3, r4, r5, r8, r9, ip, lr}^
    1034:	5f686374 	svcpl	0x00686374
    1038:	50456f54 	subpl	r6, r5, r4, asr pc
    103c:	50433831 	subpl	r3, r3, r1, lsr r8
    1040:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1044:	4c5f7373 	mrrcmi	3, 7, r7, pc, cr3	; <UNPREDICTABLE>
    1048:	5f747369 	svcpl	0x00747369
    104c:	65646f4e 	strbvs	r6, [r4, #-3918]!	; 0xfffff0b2
    1050:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    1054:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
    1058:	4f495047 	svcmi	0x00495047
    105c:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
    1060:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
    1064:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
    1068:	50475f74 	subpl	r5, r7, r4, ror pc
    106c:	5f534445 	svcpl	0x00534445
    1070:	61636f4c 	cmnvs	r3, ip, asr #30
    1074:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    1078:	6a526a45 	bvs	149b994 <__bss_end+0x1492a80>
    107c:	005f3053 	subseq	r3, pc, r3, asr r0	; <UNPREDICTABLE>
    1080:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
    1084:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
    1088:	0052525f 	subseq	r5, r2, pc, asr r2
    108c:	5f746547 	svcpl	0x00746547
    1090:	454c5047 	strbmi	r5, [ip, #-71]	; 0xffffffb9
    1094:	6f4c5f56 	svcvs	0x004c5f56
    1098:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
    109c:	5f006e6f 	svcpl	0x00006e6f
    10a0:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
    10a4:	6f725043 	svcvs	0x00725043
    10a8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    10ac:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    10b0:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    10b4:	61483831 	cmpvs	r8, r1, lsr r8
    10b8:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
    10bc:	6f72505f 	svcvs	0x0072505f
    10c0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    10c4:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
    10c8:	4e303245 	cdpmi	2, 3, cr3, cr0, cr5, {2}
    10cc:	5f495753 	svcpl	0x00495753
    10d0:	636f7250 	cmnvs	pc, #80, 4
    10d4:	5f737365 	svcpl	0x00737365
    10d8:	76726553 			; <UNDEFINED> instruction: 0x76726553
    10dc:	6a656369 	bvs	1959e88 <__bss_end+0x1950f74>
    10e0:	31526a6a 	cmpcc	r2, sl, ror #20
    10e4:	57535431 	smmlarpl	r3, r1, r4, r5
    10e8:	65525f49 	ldrbvs	r5, [r2, #-3913]	; 0xfffff0b7
    10ec:	746c7573 	strbtvc	r7, [ip], #-1395	; 0xfffffa8d
    10f0:	67726100 	ldrbvs	r6, [r2, -r0, lsl #2]!
    10f4:	494e0076 	stmdbmi	lr, {r1, r2, r4, r5, r6}^
    10f8:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
    10fc:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
    1100:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
    1104:	5f006e6f 	svcpl	0x00006e6f
    1108:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
    110c:	6f725043 	svcvs	0x00725043
    1110:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1114:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    1118:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    111c:	72433431 	subvc	r3, r3, #822083584	; 0x31000000
    1120:	65746165 	ldrbvs	r6, [r4, #-357]!	; 0xfffffe9b
    1124:	6f72505f 	svcvs	0x0072505f
    1128:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    112c:	6a685045 	bvs	1a15248 <__bss_end+0x1a0c334>
    1130:	77530062 	ldrbvc	r0, [r3, -r2, rrx]
    1134:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
    1138:	006f545f 	rsbeq	r5, pc, pc, asr r4	; <UNPREDICTABLE>
    113c:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
    1140:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
    1144:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
    1148:	5f6d6574 	svcpl	0x006d6574
    114c:	76726553 			; <UNDEFINED> instruction: 0x76726553
    1150:	00656369 	rsbeq	r6, r5, r9, ror #6
    1154:	4b4e5a5f 	blmi	1397ad8 <__bss_end+0x138ebc4>
    1158:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
    115c:	5f4f4950 	svcpl	0x004f4950
    1160:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
    1164:	3172656c 	cmncc	r2, ip, ror #10
    1168:	74654738 	strbtvc	r4, [r5], #-1848	; 0xfffff8c8
    116c:	5350475f 	cmppl	r0, #24903680	; 0x17c0000
    1170:	4c5f5445 	cfldrdmi	mvd5, [pc], {69}	; 0x45
    1174:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
    1178:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
    117c:	536a526a 	cmnpl	sl, #-1610612730	; 0xa0000006
    1180:	43005f30 	movwmi	r5, #3888	; 0xf30
    1184:	7261656c 	rsbvc	r6, r1, #108, 10	; 0x1b000000
    1188:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
    118c:	65746365 	ldrbvs	r6, [r4, #-869]!	; 0xfffffc9b
    1190:	76455f64 	strbvc	r5, [r5], -r4, ror #30
    1194:	00746e65 	rsbseq	r6, r4, r5, ror #28
    1198:	61766e49 	cmnvs	r6, r9, asr #28
    119c:	5f64696c 	svcpl	0x0064696c
    11a0:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
    11a4:	5400656c 	strpl	r6, [r0], #-1388	; 0xfffffa94
    11a8:	545f5346 	ldrbpl	r5, [pc], #-838	; 11b0 <shift+0x11b0>
    11ac:	5f656572 	svcpl	0x00656572
    11b0:	65646f4e 	strbvs	r6, [r4, #-3918]!	; 0xfffff0b2
    11b4:	6f6c4200 	svcvs	0x006c4200
    11b8:	435f6b63 	cmpmi	pc, #101376	; 0x18c00
    11bc:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
    11c0:	505f746e 	subspl	r7, pc, lr, ror #8
    11c4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    11c8:	70007373 	andvc	r7, r0, r3, ror r3
    11cc:	695f6e69 	ldmdbvs	pc, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^	; <UNPREDICTABLE>
    11d0:	46007864 	strmi	r7, [r0], -r4, ror #16
    11d4:	5f656572 	svcpl	0x00656572
    11d8:	006e6950 	rsbeq	r6, lr, r0, asr r9
    11dc:	4b4e5a5f 	blmi	1397b60 <__bss_end+0x138ec4c>
    11e0:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
    11e4:	5f4f4950 	svcpl	0x004f4950
    11e8:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
    11ec:	3172656c 	cmncc	r2, ip, ror #10
    11f0:	74654737 	strbtvc	r4, [r5], #-1847	; 0xfffff8c9
    11f4:	4950475f 	ldmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, r9, sl, lr}^
    11f8:	75465f4f 	strbvc	r5, [r6, #-3919]	; 0xfffff0b1
    11fc:	6974636e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
    1200:	6a456e6f 	bvs	115cbc4 <__bss_end+0x1153cb0>
    1204:	6f6c4300 	svcvs	0x006c4300
    1208:	64006573 	strvs	r6, [r0], #-1395	; 0xfffffa8d
    120c:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
    1210:	72610072 	rsbvc	r0, r1, #114	; 0x72
    1214:	49006367 	stmdbmi	r0, {r0, r1, r2, r5, r6, r8, r9, sp, lr}
    1218:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    121c:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
    1220:	445f6d65 	ldrbmi	r6, [pc], #-3429	; 1228 <shift+0x1228>
    1224:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
    1228:	47430072 	smlsldxmi	r0, r3, r2, r0
    122c:	5f4f4950 	svcpl	0x004f4950
    1230:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
    1234:	0072656c 	rsbseq	r6, r2, ip, ror #10
    1238:	70736e55 	rsbsvc	r6, r3, r5, asr lr
    123c:	66696365 	strbtvs	r6, [r9], -r5, ror #6
    1240:	00646569 	rsbeq	r6, r4, r9, ror #10
    1244:	74697257 	strbtvc	r7, [r9], #-599	; 0xfffffda9
    1248:	6e4f5f65 	cdpvs	15, 4, cr5, cr15, cr5, {3}
    124c:	6d00796c 	vstrvs.16	s14, [r0, #-216]	; 0xffffff28	; <UNPREDICTABLE>
    1250:	006e6961 	rsbeq	r6, lr, r1, ror #18
    1254:	6c656959 			; <UNDEFINED> instruction: 0x6c656959
    1258:	5a5f0064 	bpl	17c13f0 <__bss_end+0x17b84dc>
    125c:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
    1260:	636f7250 	cmnvs	pc, #80, 4
    1264:	5f737365 	svcpl	0x00737365
    1268:	616e614d 	cmnvs	lr, sp, asr #2
    126c:	43726567 	cmnmi	r2, #432013312	; 0x19c00000
    1270:	00764534 	rsbseq	r4, r6, r4, lsr r5
    1274:	6f6f526d 	svcvs	0x006f526d
    1278:	6e4d5f74 	mcrvs	15, 2, r5, cr13, cr4, {3}
    127c:	70630074 	rsbvc	r0, r3, r4, ror r0
    1280:	6f635f75 	svcvs	0x00635f75
    1284:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
    1288:	65540074 	ldrbvs	r0, [r4, #-116]	; 0xffffff8c
    128c:	6e696d72 	mcrvs	13, 3, r6, cr9, cr2, {3}
    1290:	00657461 	rsbeq	r7, r5, r1, ror #8
    1294:	74434f49 	strbvc	r4, [r3], #-3913	; 0xfffff0b7
    1298:	6148006c 	cmpvs	r8, ip, rrx
    129c:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
    12a0:	5152495f 	cmppl	r2, pc, asr r9
    12a4:	676f6c00 	strbvs	r6, [pc, -r0, lsl #24]!
    12a8:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    12ac:	6f6c6300 	svcvs	0x006c6300
    12b0:	53006573 	movwpl	r6, #1395	; 0x573
    12b4:	525f7465 	subspl	r7, pc, #1694498816	; 0x65000000
    12b8:	74616c65 	strbtvc	r6, [r1], #-3173	; 0xfffff39b
    12bc:	00657669 	rsbeq	r7, r5, r9, ror #12
    12c0:	76746572 			; <UNDEFINED> instruction: 0x76746572
    12c4:	6e006c61 	cdpvs	12, 0, cr6, cr0, cr1, {3}
    12c8:	00727563 	rsbseq	r7, r2, r3, ror #10
    12cc:	756e6472 	strbvc	r6, [lr, #-1138]!	; 0xfffffb8e
    12d0:	5a5f006d 	bpl	17c148c <__bss_end+0x17b8578>
    12d4:	63733131 	cmnvs	r3, #1073741836	; 0x4000000c
    12d8:	5f646568 	svcpl	0x00646568
    12dc:	6c656979 			; <UNDEFINED> instruction: 0x6c656979
    12e0:	5f007664 	svcpl	0x00007664
    12e4:	7337315a 	teqvc	r7, #-2147483626	; 0x80000016
    12e8:	745f7465 	ldrbvc	r7, [pc], #-1125	; 12f0 <shift+0x12f0>
    12ec:	5f6b7361 	svcpl	0x006b7361
    12f0:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
    12f4:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
    12f8:	6177006a 	cmnvs	r7, sl, rrx
    12fc:	5f007469 	svcpl	0x00007469
    1300:	6f6e365a 	svcvs	0x006e365a
    1304:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
    1308:	5f006a6a 	svcpl	0x00006a6a
    130c:	6574395a 	ldrbvs	r3, [r4, #-2394]!	; 0xfffff6a6
    1310:	6e696d72 	mcrvs	13, 3, r6, cr9, cr2, {3}
    1314:	69657461 	stmdbvs	r5!, {r0, r5, r6, sl, ip, sp, lr}^
    1318:	6f682f00 	svcvs	0x00682f00
    131c:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
    1320:	6e656863 	cdpvs	8, 6, cr6, cr5, cr3, {3}
    1324:	6f2f6a6b 	svcvs	0x002f6a6b
    1328:	32303273 	eorscc	r3, r0, #805306375	; 0x30000007
    132c:	70732f32 	rsbsvc	r2, r3, r2, lsr pc
    1330:	756f732f 	strbvc	r7, [pc, #-815]!	; 1009 <shift+0x1009>
    1334:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
    1338:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    133c:	2f62696c 	svccs	0x0062696c
    1340:	2f637273 	svccs	0x00637273
    1344:	66647473 			; <UNDEFINED> instruction: 0x66647473
    1348:	2e656c69 	cdpcs	12, 6, cr6, cr5, cr9, {3}
    134c:	00707063 	rsbseq	r7, r0, r3, rrx
    1350:	6c696146 	stfvse	f6, [r9], #-280	; 0xfffffee8
    1354:	69786500 	ldmdbvs	r8!, {r8, sl, sp, lr}^
    1358:	646f6374 	strbtvs	r6, [pc], #-884	; 1360 <shift+0x1360>
    135c:	5a5f0065 	bpl	17c14f8 <__bss_end+0x17b85e4>
    1360:	65673432 	strbvs	r3, [r7, #-1074]!	; 0xfffffbce
    1364:	63615f74 	cmnvs	r1, #116, 30	; 0x1d0
    1368:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
    136c:	6f72705f 	svcvs	0x0072705f
    1370:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1374:	756f635f 	strbvc	r6, [pc, #-863]!	; 101d <shift+0x101d>
    1378:	0076746e 	rsbseq	r7, r6, lr, ror #8
    137c:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
    1380:	69795f64 	ldmdbvs	r9!, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
    1384:	00646c65 	rsbeq	r6, r4, r5, ror #24
    1388:	6b636974 	blvs	18db960 <__bss_end+0x18d2a4c>
    138c:	756f635f 	strbvc	r6, [pc, #-863]!	; 1035 <shift+0x1035>
    1390:	725f746e 	subsvc	r7, pc, #1845493760	; 0x6e000000
    1394:	69757165 	ldmdbvs	r5!, {r0, r2, r5, r6, r8, ip, sp, lr}^
    1398:	00646572 	rsbeq	r6, r4, r2, ror r5
    139c:	65706950 	ldrbvs	r6, [r0, #-2384]!	; 0xfffff6b0
    13a0:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
    13a4:	72505f65 	subsvc	r5, r0, #404	; 0x194
    13a8:	78696665 	stmdavc	r9!, {r0, r2, r5, r6, r9, sl, sp, lr}^
    13ac:	315a5f00 	cmpcc	sl, r0, lsl #30
    13b0:	74656734 	strbtvc	r6, [r5], #-1844	; 0xfffff8cc
    13b4:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
    13b8:	6f635f6b 	svcvs	0x00635f6b
    13bc:	76746e75 			; <UNDEFINED> instruction: 0x76746e75
    13c0:	656c7300 	strbvs	r7, [ip, #-768]!	; 0xfffffd00
    13c4:	2f007065 	svccs	0x00007065
    13c8:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    13cc:	6863732f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, sp, lr}^
    13d0:	6a6b6e65 	bvs	1adcd6c <__bss_end+0x1ad3e58>
    13d4:	32736f2f 	rsbscc	r6, r3, #47, 30	; 0xbc
    13d8:	2f323230 	svccs	0x00323230
    13dc:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
    13e0:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    13e4:	622f7365 	eorvs	r7, pc, #-1811939327	; 0x94000001
    13e8:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    13ec:	65706f00 	ldrbvs	r6, [r0, #-3840]!	; 0xfffff100
    13f0:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
    13f4:	5f006e6f 	svcpl	0x00006e6f
    13f8:	6c63355a 	cfstr64vs	mvdx3, [r3], #-360	; 0xfffffe98
    13fc:	6a65736f 	bvs	195e1c0 <__bss_end+0x19552ac>
    1400:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
    1404:	70746567 	rsbsvc	r6, r4, r7, ror #10
    1408:	00766469 	rsbseq	r6, r6, r9, ror #8
    140c:	6d616e66 	stclvs	14, cr6, [r1, #-408]!	; 0xfffffe68
    1410:	6f6e0065 	svcvs	0x006e0065
    1414:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
    1418:	63697400 	cmnvs	r9, #0, 8
    141c:	6f00736b 	svcvs	0x0000736b
    1420:	006e6570 	rsbeq	r6, lr, r0, ror r5
    1424:	70345a5f 	eorsvc	r5, r4, pc, asr sl
    1428:	50657069 	rsbpl	r7, r5, r9, rrx
    142c:	006a634b 	rsbeq	r6, sl, fp, asr #6
    1430:	6165444e 	cmnvs	r5, lr, asr #8
    1434:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
    1438:	75535f65 	ldrbvc	r5, [r3, #-3941]	; 0xfffff09b
    143c:	72657362 	rsbvc	r7, r5, #-2013265919	; 0x88000001
    1440:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
    1444:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
    1448:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
    144c:	6f635f6b 	svcvs	0x00635f6b
    1450:	00746e75 	rsbseq	r6, r4, r5, ror lr
    1454:	61726170 	cmnvs	r2, r0, ror r1
    1458:	5a5f006d 	bpl	17c1614 <__bss_end+0x17b8700>
    145c:	69727735 	ldmdbvs	r2!, {r0, r2, r4, r5, r8, r9, sl, ip, sp, lr}^
    1460:	506a6574 	rsbpl	r6, sl, r4, ror r5
    1464:	006a634b 	rsbeq	r6, sl, fp, asr #6
    1468:	5f746567 	svcpl	0x00746567
    146c:	6b736174 	blvs	1cd9a44 <__bss_end+0x1cd0b30>
    1470:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
    1474:	745f736b 	ldrbvc	r7, [pc], #-875	; 147c <shift+0x147c>
    1478:	65645f6f 	strbvs	r5, [r4, #-3951]!	; 0xfffff091
    147c:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
    1480:	6200656e 	andvs	r6, r0, #461373440	; 0x1b800000
    1484:	735f6675 	cmpvc	pc, #122683392	; 0x7500000
    1488:	00657a69 	rsbeq	r7, r5, r9, ror #20
    148c:	74697277 	strbtvc	r7, [r9], #-631	; 0xfffffd89
    1490:	65730065 	ldrbvs	r0, [r3, #-101]!	; 0xffffff9b
    1494:	61745f74 	cmnvs	r4, r4, ror pc
    1498:	645f6b73 	ldrbvs	r6, [pc], #-2931	; 14a0 <shift+0x14a0>
    149c:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
    14a0:	00656e69 	rsbeq	r6, r5, r9, ror #28
    14a4:	73355a5f 	teqvc	r5, #389120	; 0x5f000
    14a8:	7065656c 	rsbvc	r6, r5, ip, ror #10
    14ac:	47006a6a 	strmi	r6, [r0, -sl, ror #20]
    14b0:	525f7465 	subspl	r7, pc, #1694498816	; 0x65000000
    14b4:	69616d65 	stmdbvs	r1!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}^
    14b8:	676e696e 	strbvs	r6, [lr, -lr, ror #18]!
    14bc:	325a5f00 	subscc	r5, sl, #0, 30
    14c0:	74656736 	strbtvc	r6, [r5], #-1846	; 0xfffff8ca
    14c4:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
    14c8:	69745f6b 	ldmdbvs	r4!, {r0, r1, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    14cc:	5f736b63 	svcpl	0x00736b63
    14d0:	645f6f74 	ldrbvs	r6, [pc], #-3956	; 14d8 <shift+0x14d8>
    14d4:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
    14d8:	76656e69 	strbtvc	r6, [r5], -r9, ror #28
    14dc:	57534e00 	ldrbpl	r4, [r3, -r0, lsl #28]
    14e0:	65525f49 	ldrbvs	r5, [r2, #-3913]	; 0xfffff0b7
    14e4:	746c7573 	strbtvc	r7, [ip], #-1395	; 0xfffffa8d
    14e8:	646f435f 	strbtvs	r4, [pc], #-863	; 14f0 <shift+0x14f0>
    14ec:	72770065 	rsbsvc	r0, r7, #101	; 0x65
    14f0:	006d756e 	rsbeq	r7, sp, lr, ror #10
    14f4:	77345a5f 			; <UNDEFINED> instruction: 0x77345a5f
    14f8:	6a746961 	bvs	1d1ba84 <__bss_end+0x1d12b70>
    14fc:	5f006a6a 	svcpl	0x00006a6a
    1500:	6f69355a 	svcvs	0x0069355a
    1504:	6a6c7463 	bvs	1b1e698 <__bss_end+0x1b15784>
    1508:	494e3631 	stmdbmi	lr, {r0, r4, r5, r9, sl, ip, sp}^
    150c:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
    1510:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
    1514:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
    1518:	76506e6f 	ldrbvc	r6, [r0], -pc, ror #28
    151c:	636f6900 	cmnvs	pc, #0, 18
    1520:	72006c74 	andvc	r6, r0, #116, 24	; 0x7400
    1524:	6e637465 	cdpvs	4, 6, cr7, cr3, cr5, {3}
    1528:	65740074 	ldrbvs	r0, [r4, #-116]!	; 0xffffff8c
    152c:	6e696d72 	mcrvs	13, 3, r6, cr9, cr2, {3}
    1530:	00657461 	rsbeq	r7, r5, r1, ror #8
    1534:	65646f6d 	strbvs	r6, [r4, #-3949]!	; 0xfffff093
    1538:	66756200 	ldrbtvs	r6, [r5], -r0, lsl #4
    153c:	00726566 	rsbseq	r6, r2, r6, ror #10
    1540:	72345a5f 	eorsvc	r5, r4, #389120	; 0x5f000
    1544:	6a646165 	bvs	1919ae0 <__bss_end+0x1910bcc>
    1548:	006a6350 	rsbeq	r6, sl, r0, asr r3
    154c:	63746572 	cmnvs	r4, #478150656	; 0x1c800000
    1550:	0065646f 	rsbeq	r6, r5, pc, ror #8
    1554:	5f746567 	svcpl	0x00746567
    1558:	69746361 	ldmdbvs	r4!, {r0, r5, r6, r8, r9, sp, lr}^
    155c:	705f6576 	subsvc	r6, pc, r6, ror r5	; <UNPREDICTABLE>
    1560:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1564:	635f7373 	cmpvs	pc, #-872415231	; 0xcc000001
    1568:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
    156c:	6c696600 	stclvs	6, cr6, [r9], #-0
    1570:	6d616e65 	stclvs	14, cr6, [r1, #-404]!	; 0xfffffe6c
    1574:	65720065 	ldrbvs	r0, [r2, #-101]!	; 0xffffff9b
    1578:	67006461 	strvs	r6, [r0, -r1, ror #8]
    157c:	69707465 	ldmdbvs	r0!, {r0, r2, r5, r6, sl, ip, sp, lr}^
    1580:	5a5f0064 	bpl	17c1718 <__bss_end+0x17b8804>
    1584:	65706f34 	ldrbvs	r6, [r0, #-3892]!	; 0xfffff0cc
    1588:	634b506e 	movtvs	r5, #45166	; 0xb06e
    158c:	464e3531 			; <UNDEFINED> instruction: 0x464e3531
    1590:	5f656c69 	svcpl	0x00656c69
    1594:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
    1598:	646f4d5f 	strbtvs	r4, [pc], #-3423	; 15a0 <shift+0x15a0>
    159c:	4e470065 	cdpmi	0, 4, cr0, cr7, cr5, {3}
    15a0:	2b432055 	blcs	10c96fc <__bss_end+0x10c07e8>
    15a4:	2034312b 	eorscs	r3, r4, fp, lsr #2
    15a8:	2e322e39 	mrccs	14, 1, r2, cr2, cr9, {1}
    15ac:	30322031 	eorscc	r2, r2, r1, lsr r0
    15b0:	30313931 	eorscc	r3, r1, r1, lsr r9
    15b4:	28203532 	stmdacs	r0!, {r1, r4, r5, r8, sl, ip, sp}
    15b8:	656c6572 	strbvs	r6, [ip, #-1394]!	; 0xfffffa8e
    15bc:	29657361 	stmdbcs	r5!, {r0, r5, r6, r8, r9, ip, sp, lr}^
    15c0:	52415b20 	subpl	r5, r1, #32, 22	; 0x8000
    15c4:	72612f4d 	rsbvc	r2, r1, #308	; 0x134
    15c8:	2d392d6d 	ldccs	13, cr2, [r9, #-436]!	; 0xfffffe4c
    15cc:	6e617262 	cdpvs	2, 6, cr7, cr1, cr2, {3}
    15d0:	72206863 	eorvc	r6, r0, #6488064	; 0x630000
    15d4:	73697665 	cmnvc	r9, #105906176	; 0x6500000
    15d8:	206e6f69 	rsbcs	r6, lr, r9, ror #30
    15dc:	35373732 	ldrcc	r3, [r7, #-1842]!	; 0xfffff8ce
    15e0:	205d3939 	subscs	r3, sp, r9, lsr r9
    15e4:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
    15e8:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
    15ec:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
    15f0:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    15f4:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    15f8:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
    15fc:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    1600:	6f6c666d 	svcvs	0x006c666d
    1604:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
    1608:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
    160c:	20647261 	rsbcs	r7, r4, r1, ror #4
    1610:	70666d2d 	rsbvc	r6, r6, sp, lsr #26
    1614:	66763d75 			; <UNDEFINED> instruction: 0x66763d75
    1618:	6d2d2070 	stcvs	0, cr2, [sp, #-448]!	; 0xfffffe40
    161c:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
    1620:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
    1624:	36373131 			; <UNDEFINED> instruction: 0x36373131
    1628:	2d667a6a 	vstmdbcs	r6!, {s15-s120}
    162c:	6d2d2073 	stcvs	0, cr2, [sp, #-460]!	; 0xfffffe34
    1630:	206d7261 	rsbcs	r7, sp, r1, ror #4
    1634:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
    1638:	613d6863 	teqvs	sp, r3, ror #16
    163c:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    1640:	662b6b7a 			; <UNDEFINED> instruction: 0x662b6b7a
    1644:	672d2070 			; <UNDEFINED> instruction: 0x672d2070
    1648:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    164c:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    1650:	2d20304f 	stccs	0, cr3, [r0, #-316]!	; 0xfffffec4
    1654:	2d20304f 	stccs	0, cr3, [r0, #-316]!	; 0xfffffec4
    1658:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 14c8 <shift+0x14c8>
    165c:	65637865 	strbvs	r7, [r3, #-2149]!	; 0xfffff79b
    1660:	6f697470 	svcvs	0x00697470
    1664:	2d20736e 	stccs	3, cr7, [r0, #-440]!	; 0xfffffe48
    1668:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 14d8 <shift+0x14d8>
    166c:	69747472 	ldmdbvs	r4!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1670:	706e6900 	rsbvc	r6, lr, r0, lsl #18
    1674:	64007475 	strvs	r7, [r0], #-1141	; 0xfffffb8b
    1678:	00747365 	rsbseq	r7, r4, r5, ror #6
    167c:	72657a62 	rsbvc	r7, r5, #401408	; 0x62000
    1680:	656c006f 	strbvs	r0, [ip, #-111]!	; 0xffffff91
    1684:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
    1688:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    168c:	72657a62 	rsbvc	r7, r5, #401408	; 0x62000
    1690:	6976506f 	ldmdbvs	r6!, {r0, r1, r2, r3, r5, r6, ip, lr}^
    1694:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    1698:	696f7461 	stmdbvs	pc!, {r0, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    169c:	00634b50 	rsbeq	r4, r3, r0, asr fp
    16a0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 15ec <shift+0x15ec>
    16a4:	63732f65 	cmnvs	r3, #404	; 0x194
    16a8:	6b6e6568 	blvs	1b9ac50 <__bss_end+0x1b91d3c>
    16ac:	736f2f6a 	cmnvc	pc, #424	; 0x1a8
    16b0:	32323032 	eorscc	r3, r2, #50	; 0x32
    16b4:	2f70732f 	svccs	0x0070732f
    16b8:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
    16bc:	2f736563 	svccs	0x00736563
    16c0:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
    16c4:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
    16c8:	732f6372 			; <UNDEFINED> instruction: 0x732f6372
    16cc:	74736474 	ldrbtvc	r6, [r3], #-1140	; 0xfffffb8c
    16d0:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
    16d4:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
    16d8:	61684300 	cmnvs	r8, r0, lsl #6
    16dc:	6e6f4372 	mcrvs	3, 3, r4, cr15, cr2, {3}
    16e0:	72724176 	rsbsvc	r4, r2, #-2147483619	; 0x8000001d
    16e4:	6d656d00 	stclvs	13, cr6, [r5, #-0]
    16e8:	00747364 	rsbseq	r7, r4, r4, ror #6
    16ec:	7074756f 	rsbsvc	r7, r4, pc, ror #10
    16f0:	5f007475 	svcpl	0x00007475
    16f4:	656d365a 	strbvs	r3, [sp, #-1626]!	; 0xfffff9a6
    16f8:	7970636d 	ldmdbvc	r0!, {r0, r2, r3, r5, r6, r8, r9, sp, lr}^
    16fc:	50764b50 	rsbspl	r4, r6, r0, asr fp
    1700:	62006976 	andvs	r6, r0, #1933312	; 0x1d8000
    1704:	00657361 	rsbeq	r7, r5, r1, ror #6
    1708:	636d656d 	cmnvs	sp, #457179136	; 0x1b400000
    170c:	73007970 	movwvc	r7, #2416	; 0x970
    1710:	656c7274 	strbvs	r7, [ip, #-628]!	; 0xfffffd8c
    1714:	5a5f006e 	bpl	17c18d4 <__bss_end+0x17b89c0>
    1718:	72747337 	rsbsvc	r7, r4, #-603979776	; 0xdc000000
    171c:	706d636e 	rsbvc	r6, sp, lr, ror #6
    1720:	53634b50 	cmnpl	r3, #80, 22	; 0x14000
    1724:	00695f30 	rsbeq	r5, r9, r0, lsr pc
    1728:	73365a5f 	teqvc	r6, #389120	; 0x5f000
    172c:	656c7274 	strbvs	r7, [ip, #-628]!	; 0xfffffd8c
    1730:	634b506e 	movtvs	r5, #45166	; 0xb06e
    1734:	6f746100 	svcvs	0x00746100
    1738:	5a5f0069 	bpl	17c18e4 <__bss_end+0x17b89d0>
    173c:	72747337 	rsbsvc	r7, r4, #-603979776	; 0xdc000000
    1740:	7970636e 	ldmdbvc	r0!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
    1744:	4b506350 	blmi	141a48c <__bss_end+0x1411578>
    1748:	73006963 	movwvc	r6, #2403	; 0x963
    174c:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    1750:	7300706d 	movwvc	r7, #109	; 0x6d
    1754:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    1758:	6d007970 	vstrvs.16	s14, [r0, #-224]	; 0xffffff20	; <UNPREDICTABLE>
    175c:	726f6d65 	rsbvc	r6, pc, #6464	; 0x1940
    1760:	656d0079 	strbvs	r0, [sp, #-121]!	; 0xffffff87
    1764:	6372736d 	cmnvs	r2, #-1275068415	; 0xb4000001
    1768:	6f746900 	svcvs	0x00746900
    176c:	5a5f0061 	bpl	17c18f8 <__bss_end+0x17b89e4>
    1770:	6f746934 	svcvs	0x00746934
    1774:	63506a61 	cmpvs	r0, #397312	; 0x61000
    1778:	2e2e006a 	cdpcs	0, 2, cr0, cr14, cr10, {3}
    177c:	2f2e2e2f 	svccs	0x002e2e2f
    1780:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1784:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1788:	2f2e2e2f 	svccs	0x002e2e2f
    178c:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1790:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
    1794:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
    1798:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
    179c:	696c2f6d 	stmdbvs	ip!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp}^
    17a0:	75663162 	strbvc	r3, [r6, #-354]!	; 0xfffffe9e
    17a4:	2e73636e 	cdpcs	3, 7, cr6, cr3, cr14, {3}
    17a8:	622f0053 	eorvs	r0, pc, #83	; 0x53
    17ac:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    17b0:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
    17b4:	6d72612d 	ldfvse	f6, [r2, #-180]!	; 0xffffff4c
    17b8:	6e6f6e2d 	cdpvs	14, 6, cr6, cr15, cr13, {1}
    17bc:	61652d65 	cmnvs	r5, r5, ror #26
    17c0:	472d6962 	strmi	r6, [sp, -r2, ror #18]!
    17c4:	546b396c 	strbtpl	r3, [fp], #-2412	; 0xfffff694
    17c8:	63672f39 	cmnvs	r7, #57, 30	; 0xe4
    17cc:	72612d63 	rsbvc	r2, r1, #6336	; 0x18c0
    17d0:	6f6e2d6d 	svcvs	0x006e2d6d
    17d4:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
    17d8:	2d696261 	sfmcs	f6, 2, [r9, #-388]!	; 0xfffffe7c
    17dc:	30322d39 	eorscc	r2, r2, r9, lsr sp
    17e0:	712d3931 			; <UNDEFINED> instruction: 0x712d3931
    17e4:	75622f34 	strbvc	r2, [r2, #-3892]!	; 0xfffff0cc
    17e8:	2f646c69 	svccs	0x00646c69
    17ec:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    17f0:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    17f4:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    17f8:	72612f69 	rsbvc	r2, r1, #420	; 0x1a4
    17fc:	35762f6d 	ldrbcc	r2, [r6, #-3949]!	; 0xfffff093
    1800:	682f6574 	stmdavs	pc!, {r2, r4, r5, r6, r8, sl, sp, lr}	; <UNPREDICTABLE>
    1804:	2f647261 	svccs	0x00647261
    1808:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    180c:	54006363 	strpl	r6, [r0], #-867	; 0xfffffc9d
    1810:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1814:	50435f54 	subpl	r5, r3, r4, asr pc
    1818:	6f635f55 	svcvs	0x00635f55
    181c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1820:	63373161 	teqvs	r7, #1073741848	; 0x40000018
    1824:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1828:	00376178 	eorseq	r6, r7, r8, ror r1
    182c:	5f617369 	svcpl	0x00617369
    1830:	5f746962 	svcpl	0x00746962
    1834:	645f7066 	ldrbvs	r7, [pc], #-102	; 183c <shift+0x183c>
    1838:	61006c62 	tstvs	r0, r2, ror #24
    183c:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1840:	5f686372 	svcpl	0x00686372
    1844:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    1848:	54007478 	strpl	r7, [r0], #-1144	; 0xfffffb88
    184c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1850:	50435f54 	subpl	r5, r3, r4, asr pc
    1854:	6f635f55 	svcvs	0x00635f55
    1858:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    185c:	0033326d 	eorseq	r3, r3, sp, ror #4
    1860:	5f4d5241 	svcpl	0x004d5241
    1864:	54005145 	strpl	r5, [r0], #-325	; 0xfffffebb
    1868:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    186c:	50435f54 	subpl	r5, r3, r4, asr pc
    1870:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1874:	3531316d 	ldrcc	r3, [r1, #-365]!	; 0xfffffe93
    1878:	66327436 			; <UNDEFINED> instruction: 0x66327436
    187c:	73690073 	cmnvc	r9, #115	; 0x73
    1880:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1884:	68745f74 	ldmdavs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1888:	00626d75 	rsbeq	r6, r2, r5, ror sp
    188c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1890:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1894:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1898:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    189c:	37356178 			; <UNDEFINED> instruction: 0x37356178
    18a0:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    18a4:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    18a8:	41420033 	cmpmi	r2, r3, lsr r0
    18ac:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    18b0:	5f484352 	svcpl	0x00484352
    18b4:	425f4d38 	subsmi	r4, pc, #56, 26	; 0xe00
    18b8:	00455341 	subeq	r5, r5, r1, asr #6
    18bc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    18c0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    18c4:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    18c8:	31386d72 	teqcc	r8, r2, ror sp
    18cc:	41540030 	cmpmi	r4, r0, lsr r0
    18d0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    18d4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    18d8:	6567785f 	strbvs	r7, [r7, #-2143]!	; 0xfffff7a1
    18dc:	0031656e 	eorseq	r6, r1, lr, ror #10
    18e0:	5f4d5241 	svcpl	0x004d5241
    18e4:	5f534350 	svcpl	0x00534350
    18e8:	43504141 	cmpmi	r0, #1073741840	; 0x40000010
    18ec:	57495f53 	smlsldpl	r5, r9, r3, pc	; <UNPREDICTABLE>
    18f0:	54584d4d 	ldrbpl	r4, [r8], #-3405	; 0xfffff2b3
    18f4:	53414200 	movtpl	r4, #4608	; 0x1200
    18f8:	52415f45 	subpl	r5, r1, #276	; 0x114
    18fc:	305f4843 	subscc	r4, pc, r3, asr #16
    1900:	53414200 	movtpl	r4, #4608	; 0x1200
    1904:	52415f45 	subpl	r5, r1, #276	; 0x114
    1908:	325f4843 	subscc	r4, pc, #4390912	; 0x430000
    190c:	53414200 	movtpl	r4, #4608	; 0x1200
    1910:	52415f45 	subpl	r5, r1, #276	; 0x114
    1914:	335f4843 	cmpcc	pc, #4390912	; 0x430000
    1918:	53414200 	movtpl	r4, #4608	; 0x1200
    191c:	52415f45 	subpl	r5, r1, #276	; 0x114
    1920:	345f4843 	ldrbcc	r4, [pc], #-2115	; 1928 <shift+0x1928>
    1924:	53414200 	movtpl	r4, #4608	; 0x1200
    1928:	52415f45 	subpl	r5, r1, #276	; 0x114
    192c:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    1930:	53414200 	movtpl	r4, #4608	; 0x1200
    1934:	52415f45 	subpl	r5, r1, #276	; 0x114
    1938:	375f4843 	ldrbcc	r4, [pc, -r3, asr #16]
    193c:	52415400 	subpl	r5, r1, #0, 8
    1940:	5f544547 	svcpl	0x00544547
    1944:	5f555043 	svcpl	0x00555043
    1948:	61637378 	smcvs	14136	; 0x3738
    194c:	6900656c 	stmdbvs	r0, {r2, r3, r5, r6, r8, sl, sp, lr}
    1950:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1954:	705f7469 	subsvc	r7, pc, r9, ror #8
    1958:	72646572 	rsbvc	r6, r4, #478150656	; 0x1c800000
    195c:	54007365 	strpl	r7, [r0], #-869	; 0xfffffc9b
    1960:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1964:	50435f54 	subpl	r5, r3, r4, asr pc
    1968:	6f635f55 	svcvs	0x00635f55
    196c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1970:	0033336d 	eorseq	r3, r3, sp, ror #6
    1974:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1978:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    197c:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1980:	74376d72 	ldrtvc	r6, [r7], #-3442	; 0xfffff28e
    1984:	00696d64 	rsbeq	r6, r9, r4, ror #26
    1988:	5f617369 	svcpl	0x00617369
    198c:	69626f6e 	stmdbvs	r2!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    1990:	41540074 	cmpmi	r4, r4, ror r0
    1994:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1998:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    199c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    19a0:	36373131 			; <UNDEFINED> instruction: 0x36373131
    19a4:	73667a6a 	cmnvc	r6, #434176	; 0x6a000
    19a8:	61736900 	cmnvs	r3, r0, lsl #18
    19ac:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    19b0:	7066765f 	rsbvc	r7, r6, pc, asr r6
    19b4:	41003276 	tstmi	r0, r6, ror r2
    19b8:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    19bc:	555f5343 	ldrbpl	r5, [pc, #-835]	; 1681 <shift+0x1681>
    19c0:	4f4e4b4e 	svcmi	0x004e4b4e
    19c4:	54004e57 	strpl	r4, [r0], #-3671	; 0xfffff1a9
    19c8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    19cc:	50435f54 	subpl	r5, r3, r4, asr pc
    19d0:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    19d4:	0065396d 	rsbeq	r3, r5, sp, ror #18
    19d8:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    19dc:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    19e0:	54355f48 	ldrtpl	r5, [r5], #-3912	; 0xfffff0b8
    19e4:	61004a45 	tstvs	r0, r5, asr #20
    19e8:	635f6d72 	cmpvs	pc, #7296	; 0x1c80
    19ec:	6d736663 	ldclvs	6, cr6, [r3, #-396]!	; 0xfffffe74
    19f0:	6174735f 	cmnvs	r4, pc, asr r3
    19f4:	61006574 	tstvs	r0, r4, ror r5
    19f8:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    19fc:	35686372 	strbcc	r6, [r8, #-882]!	; 0xfffffc8e
    1a00:	75006574 	strvc	r6, [r0, #-1396]	; 0xfffffa8c
    1a04:	6570736e 	ldrbvs	r7, [r0, #-878]!	; 0xfffffc92
    1a08:	74735f63 	ldrbtvc	r5, [r3], #-3939	; 0xfffff09d
    1a0c:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
    1a10:	73690073 	cmnvc	r9, #115	; 0x73
    1a14:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1a18:	65735f74 	ldrbvs	r5, [r3, #-3956]!	; 0xfffff08c
    1a1c:	5f5f0063 	svcpl	0x005f0063
    1a20:	5f7a6c63 	svcpl	0x007a6c63
    1a24:	00626174 	rsbeq	r6, r2, r4, ror r1
    1a28:	5f4d5241 	svcpl	0x004d5241
    1a2c:	61004356 	tstvs	r0, r6, asr r3
    1a30:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1a34:	5f686372 	svcpl	0x00686372
    1a38:	61637378 	smcvs	14136	; 0x3738
    1a3c:	4100656c 	tstmi	r0, ip, ror #10
    1a40:	4c5f4d52 	mrrcmi	13, 5, r4, pc, cr2	; <UNPREDICTABLE>
    1a44:	52410045 	subpl	r0, r1, #69	; 0x45
    1a48:	53565f4d 	cmppl	r6, #308	; 0x134
    1a4c:	4d524100 	ldfmie	f4, [r2, #-0]
    1a50:	0045475f 	subeq	r4, r5, pc, asr r7
    1a54:	5f6d7261 	svcpl	0x006d7261
    1a58:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
    1a5c:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
    1a60:	61676e6f 	cmnvs	r7, pc, ror #28
    1a64:	63006d72 	movwvs	r6, #3442	; 0xd72
    1a68:	6c706d6f 	ldclvs	13, cr6, [r0], #-444	; 0xfffffe44
    1a6c:	66207865 	strtvs	r7, [r0], -r5, ror #16
    1a70:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    1a74:	52415400 	subpl	r5, r1, #0, 8
    1a78:	5f544547 	svcpl	0x00544547
    1a7c:	5f555043 	svcpl	0x00555043
    1a80:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1a84:	31617865 	cmncc	r1, r5, ror #16
    1a88:	41540035 	cmpmi	r4, r5, lsr r0
    1a8c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1a90:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1a94:	3761665f 			; <UNDEFINED> instruction: 0x3761665f
    1a98:	65743632 	ldrbvs	r3, [r4, #-1586]!	; 0xfffff9ce
    1a9c:	52415400 	subpl	r5, r1, #0, 8
    1aa0:	5f544547 	svcpl	0x00544547
    1aa4:	5f555043 	svcpl	0x00555043
    1aa8:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1aac:	31617865 	cmncc	r1, r5, ror #16
    1ab0:	52410037 	subpl	r0, r1, #55	; 0x37
    1ab4:	54475f4d 	strbpl	r5, [r7], #-3917	; 0xfffff0b3
    1ab8:	52415400 	subpl	r5, r1, #0, 8
    1abc:	5f544547 	svcpl	0x00544547
    1ac0:	5f555043 	svcpl	0x00555043
    1ac4:	766f656e 	strbtvc	r6, [pc], -lr, ror #10
    1ac8:	65737265 	ldrbvs	r7, [r3, #-613]!	; 0xfffffd9b
    1acc:	2e00316e 	adfcssz	f3, f0, #0.5
    1ad0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1ad4:	2f2e2e2f 	svccs	0x002e2e2f
    1ad8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1adc:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1ae0:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1ae4:	2f636367 	svccs	0x00636367
    1ae8:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1aec:	2e326363 	cdpcs	3, 3, cr6, cr2, cr3, {3}
    1af0:	41540063 	cmpmi	r4, r3, rrx
    1af4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1af8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1afc:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1b00:	72786574 	rsbsvc	r6, r8, #116, 10	; 0x1d000000
    1b04:	42006634 	andmi	r6, r0, #52, 12	; 0x3400000
    1b08:	5f455341 	svcpl	0x00455341
    1b0c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1b10:	4d45375f 	stclmi	7, cr3, [r5, #-380]	; 0xfffffe84
    1b14:	52415400 	subpl	r5, r1, #0, 8
    1b18:	5f544547 	svcpl	0x00544547
    1b1c:	5f555043 	svcpl	0x00555043
    1b20:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1b24:	31617865 	cmncc	r1, r5, ror #16
    1b28:	61680032 	cmnvs	r8, r2, lsr r0
    1b2c:	61766873 	cmnvs	r6, r3, ror r8
    1b30:	00745f6c 	rsbseq	r5, r4, ip, ror #30
    1b34:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1b38:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1b3c:	4b365f48 	blmi	d99864 <__bss_end+0xd90950>
    1b40:	7369005a 	cmnvc	r9, #90	; 0x5a
    1b44:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1b48:	61007374 	tstvs	r0, r4, ror r3
    1b4c:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1b50:	5f686372 	svcpl	0x00686372
    1b54:	5f6d7261 	svcpl	0x006d7261
    1b58:	69647768 	stmdbvs	r4!, {r3, r5, r6, r8, r9, sl, ip, sp, lr}^
    1b5c:	72610076 	rsbvc	r0, r1, #118	; 0x76
    1b60:	70665f6d 	rsbvc	r5, r6, sp, ror #30
    1b64:	65645f75 	strbvs	r5, [r4, #-3957]!	; 0xfffff08b
    1b68:	69006373 	stmdbvs	r0, {r0, r1, r4, r5, r6, r8, r9, sp, lr}
    1b6c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1b70:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1b74:	00363170 	eorseq	r3, r6, r0, ror r1
    1b78:	20554e47 	subscs	r4, r5, r7, asr #28
    1b7c:	20373143 	eorscs	r3, r7, r3, asr #2
    1b80:	2e322e39 	mrccs	14, 1, r2, cr2, cr9, {1}
    1b84:	30322031 	eorscc	r2, r2, r1, lsr r0
    1b88:	30313931 	eorscc	r3, r1, r1, lsr r9
    1b8c:	28203532 	stmdacs	r0!, {r1, r4, r5, r8, sl, ip, sp}
    1b90:	656c6572 	strbvs	r6, [ip, #-1394]!	; 0xfffffa8e
    1b94:	29657361 	stmdbcs	r5!, {r0, r5, r6, r8, r9, ip, sp, lr}^
    1b98:	52415b20 	subpl	r5, r1, #32, 22	; 0x8000
    1b9c:	72612f4d 	rsbvc	r2, r1, #308	; 0x134
    1ba0:	2d392d6d 	ldccs	13, cr2, [r9, #-436]!	; 0xfffffe4c
    1ba4:	6e617262 	cdpvs	2, 6, cr7, cr1, cr2, {3}
    1ba8:	72206863 	eorvc	r6, r0, #6488064	; 0x630000
    1bac:	73697665 	cmnvc	r9, #105906176	; 0x6500000
    1bb0:	206e6f69 	rsbcs	r6, lr, r9, ror #30
    1bb4:	35373732 	ldrcc	r3, [r7, #-1842]!	; 0xfffff8ce
    1bb8:	205d3939 	subscs	r3, sp, r9, lsr r9
    1bbc:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
    1bc0:	6d2d206d 	stcvs	0, cr2, [sp, #-436]!	; 0xfffffe4c
    1bc4:	616f6c66 	cmnvs	pc, r6, ror #24
    1bc8:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
    1bcc:	61683d69 	cmnvs	r8, r9, ror #26
    1bd0:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
    1bd4:	6372616d 	cmnvs	r2, #1073741851	; 0x4000001b
    1bd8:	72613d68 	rsbvc	r3, r1, #104, 26	; 0x1a00
    1bdc:	7435766d 	ldrtvc	r7, [r5], #-1645	; 0xfffff993
    1be0:	70662b65 	rsbvc	r2, r6, r5, ror #22
    1be4:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    1be8:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    1bec:	4f2d2067 	svcmi	0x002d2067
    1bf0:	4f2d2032 	svcmi	0x002d2032
    1bf4:	4f2d2032 	svcmi	0x002d2032
    1bf8:	662d2032 			; <UNDEFINED> instruction: 0x662d2032
    1bfc:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    1c00:	676e6964 	strbvs	r6, [lr, -r4, ror #18]!
    1c04:	62696c2d 	rsbvs	r6, r9, #11520	; 0x2d00
    1c08:	20636367 	rsbcs	r6, r3, r7, ror #6
    1c0c:	6f6e662d 	svcvs	0x006e662d
    1c10:	6174732d 	cmnvs	r4, sp, lsr #6
    1c14:	702d6b63 	eorvc	r6, sp, r3, ror #22
    1c18:	65746f72 	ldrbvs	r6, [r4, #-3954]!	; 0xfffff08e
    1c1c:	726f7463 	rsbvc	r7, pc, #1660944384	; 0x63000000
    1c20:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
    1c24:	6e692d6f 	cdpvs	13, 6, cr2, cr9, cr15, {3}
    1c28:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
    1c2c:	76662d20 	strbtvc	r2, [r6], -r0, lsr #26
    1c30:	62697369 	rsbvs	r7, r9, #-1543503871	; 0xa4000001
    1c34:	74696c69 	strbtvc	r6, [r9], #-3177	; 0xfffff397
    1c38:	69683d79 	stmdbvs	r8!, {r0, r3, r4, r5, r6, r8, sl, fp, ip, sp}^
    1c3c:	6e656464 	cdpvs	4, 6, cr6, cr5, cr4, {3}
    1c40:	4d524100 	ldfmie	f4, [r2, #-0]
    1c44:	0049485f 	subeq	r4, r9, pc, asr r8
    1c48:	5f617369 	svcpl	0x00617369
    1c4c:	5f746962 	svcpl	0x00746962
    1c50:	76696461 	strbtvc	r6, [r9], -r1, ror #8
    1c54:	52415400 	subpl	r5, r1, #0, 8
    1c58:	5f544547 	svcpl	0x00544547
    1c5c:	5f555043 	svcpl	0x00555043
    1c60:	316d7261 	cmncc	sp, r1, ror #4
    1c64:	6a363331 	bvs	d8e930 <__bss_end+0xd85a1c>
    1c68:	41540073 	cmpmi	r4, r3, ror r0
    1c6c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1c70:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1c74:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1c78:	41540038 	cmpmi	r4, r8, lsr r0
    1c7c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1c80:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1c84:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1c88:	41540039 	cmpmi	r4, r9, lsr r0
    1c8c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1c90:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1c94:	3661665f 			; <UNDEFINED> instruction: 0x3661665f
    1c98:	6c003632 	stcvs	6, cr3, [r0], {50}	; 0x32
    1c9c:	20676e6f 	rsbcs	r6, r7, pc, ror #28
    1ca0:	676e6f6c 	strbvs	r6, [lr, -ip, ror #30]!
    1ca4:	736e7520 	cmnvc	lr, #32, 10	; 0x8000000
    1ca8:	656e6769 	strbvs	r6, [lr, #-1897]!	; 0xfffff897
    1cac:	6e692064 	cdpvs	0, 6, cr2, cr9, cr4, {3}
    1cb0:	72610074 	rsbvc	r0, r1, #116	; 0x74
    1cb4:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1cb8:	635f6863 	cmpvs	pc, #6488064	; 0x630000
    1cbc:	0065736d 	rsbeq	r7, r5, sp, ror #6
    1cc0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1cc4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1cc8:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1ccc:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1cd0:	00346d78 	eorseq	r6, r4, r8, ror sp
    1cd4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1cd8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1cdc:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1ce0:	30316d72 	eorscc	r6, r1, r2, ror sp
    1ce4:	41540065 	cmpmi	r4, r5, rrx
    1ce8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1cec:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1cf0:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1cf4:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1cf8:	72610037 	rsbvc	r0, r1, #55	; 0x37
    1cfc:	6f635f6d 	svcvs	0x00635f6d
    1d00:	635f646e 	cmpvs	pc, #1845493760	; 0x6e000000
    1d04:	0065646f 	rsbeq	r6, r5, pc, ror #8
    1d08:	5f4d5241 	svcpl	0x004d5241
    1d0c:	5f534350 	svcpl	0x00534350
    1d10:	43504141 	cmpmi	r0, #1073741840	; 0x40000010
    1d14:	73690053 	cmnvc	r9, #83	; 0x53
    1d18:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1d1c:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1d20:	5f38766d 	svcpl	0x0038766d
    1d24:	41420032 	cmpmi	r2, r2, lsr r0
    1d28:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1d2c:	5f484352 	svcpl	0x00484352
    1d30:	54004d33 	strpl	r4, [r0], #-3379	; 0xfffff2cd
    1d34:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1d38:	50435f54 	subpl	r5, r3, r4, asr pc
    1d3c:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1d40:	3031376d 	eorscc	r3, r1, sp, ror #14
    1d44:	72610074 	rsbvc	r0, r1, #116	; 0x74
    1d48:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1d4c:	695f6863 	ldmdbvs	pc, {r0, r1, r5, r6, fp, sp, lr}^	; <UNPREDICTABLE>
    1d50:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    1d54:	69003274 	stmdbvs	r0, {r2, r4, r5, r6, r9, ip, sp}
    1d58:	6e5f6173 	mrcvs	1, 2, r6, cr15, cr3, {3}
    1d5c:	625f6d75 	subsvs	r6, pc, #7488	; 0x1d40
    1d60:	00737469 	rsbseq	r7, r3, r9, ror #8
    1d64:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1d68:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1d6c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1d70:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1d74:	70306d78 	eorsvc	r6, r0, r8, ror sp
    1d78:	7373756c 	cmnvc	r3, #108, 10	; 0x1b000000
    1d7c:	6c6c616d 	stfvse	f6, [ip], #-436	; 0xfffffe4c
    1d80:	746c756d 	strbtvc	r7, [ip], #-1389	; 0xfffffa93
    1d84:	796c7069 	stmdbvc	ip!, {r0, r3, r5, r6, ip, sp, lr}^
    1d88:	52415400 	subpl	r5, r1, #0, 8
    1d8c:	5f544547 	svcpl	0x00544547
    1d90:	5f555043 	svcpl	0x00555043
    1d94:	6e797865 	cdpvs	8, 7, cr7, cr9, cr5, {3}
    1d98:	316d736f 	cmncc	sp, pc, ror #6
    1d9c:	52415400 	subpl	r5, r1, #0, 8
    1da0:	5f544547 	svcpl	0x00544547
    1da4:	5f555043 	svcpl	0x00555043
    1da8:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1dac:	35727865 	ldrbcc	r7, [r2, #-2149]!	; 0xfffff79b
    1db0:	73690032 	cmnvc	r9, #50	; 0x32
    1db4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1db8:	64745f74 	ldrbtvs	r5, [r4], #-3956	; 0xfffff08c
    1dbc:	70007669 	andvc	r7, r0, r9, ror #12
    1dc0:	65666572 	strbvs	r6, [r6, #-1394]!	; 0xfffffa8e
    1dc4:	656e5f72 	strbvs	r5, [lr, #-3954]!	; 0xfffff08e
    1dc8:	665f6e6f 	ldrbvs	r6, [pc], -pc, ror #28
    1dcc:	365f726f 	ldrbcc	r7, [pc], -pc, ror #4
    1dd0:	74696234 	strbtvc	r6, [r9], #-564	; 0xfffffdcc
    1dd4:	73690073 	cmnvc	r9, #115	; 0x73
    1dd8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1ddc:	70665f74 	rsbvc	r5, r6, r4, ror pc
    1de0:	6d663631 	stclvs	6, cr3, [r6, #-196]!	; 0xffffff3c
    1de4:	4154006c 	cmpmi	r4, ip, rrx
    1de8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1dec:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1df0:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1df4:	61786574 	cmnvs	r8, r4, ror r5
    1df8:	54003233 	strpl	r3, [r0], #-563	; 0xfffffdcd
    1dfc:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1e00:	50435f54 	subpl	r5, r3, r4, asr pc
    1e04:	6f635f55 	svcvs	0x00635f55
    1e08:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1e0c:	00353361 	eorseq	r3, r5, r1, ror #6
    1e10:	5f617369 	svcpl	0x00617369
    1e14:	5f746962 	svcpl	0x00746962
    1e18:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    1e1c:	766e6f63 	strbtvc	r6, [lr], -r3, ror #30
    1e20:	736e7500 	cmnvc	lr, #0, 10
    1e24:	76636570 			; <UNDEFINED> instruction: 0x76636570
    1e28:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
    1e2c:	73676e69 	cmnvc	r7, #1680	; 0x690
    1e30:	52415400 	subpl	r5, r1, #0, 8
    1e34:	5f544547 	svcpl	0x00544547
    1e38:	5f555043 	svcpl	0x00555043
    1e3c:	316d7261 	cmncc	sp, r1, ror #4
    1e40:	74363531 	ldrtvc	r3, [r6], #-1329	; 0xfffffacf
    1e44:	54007332 	strpl	r7, [r0], #-818	; 0xfffffcce
    1e48:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1e4c:	50435f54 	subpl	r5, r3, r4, asr pc
    1e50:	61665f55 	cmnvs	r6, r5, asr pc
    1e54:	74363036 	ldrtvc	r3, [r6], #-54	; 0xffffffca
    1e58:	41540065 	cmpmi	r4, r5, rrx
    1e5c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1e60:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1e64:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1e68:	65363239 	ldrvs	r3, [r6, #-569]!	; 0xfffffdc7
    1e6c:	4200736a 	andmi	r7, r0, #-1476395007	; 0xa8000001
    1e70:	5f455341 	svcpl	0x00455341
    1e74:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1e78:	0054345f 	subseq	r3, r4, pc, asr r4
    1e7c:	5f617369 	svcpl	0x00617369
    1e80:	5f746962 	svcpl	0x00746962
    1e84:	70797263 	rsbsvc	r7, r9, r3, ror #4
    1e88:	61006f74 	tstvs	r0, r4, ror pc
    1e8c:	725f6d72 	subsvc	r6, pc, #7296	; 0x1c80
    1e90:	5f736765 	svcpl	0x00736765
    1e94:	735f6e69 	cmpvc	pc, #1680	; 0x690
    1e98:	65757165 	ldrbvs	r7, [r5, #-357]!	; 0xfffffe9b
    1e9c:	0065636e 	rsbeq	r6, r5, lr, ror #6
    1ea0:	5f617369 	svcpl	0x00617369
    1ea4:	5f746962 	svcpl	0x00746962
    1ea8:	42006273 	andmi	r6, r0, #805306375	; 0x30000007
    1eac:	5f455341 	svcpl	0x00455341
    1eb0:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1eb4:	4554355f 	ldrbmi	r3, [r4, #-1375]	; 0xfffffaa1
    1eb8:	61736900 	cmnvs	r3, r0, lsl #18
    1ebc:	6165665f 	cmnvs	r5, pc, asr r6
    1ec0:	65727574 	ldrbvs	r7, [r2, #-1396]!	; 0xfffffa8c
    1ec4:	61736900 	cmnvs	r3, r0, lsl #18
    1ec8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1ecc:	616d735f 	cmnvs	sp, pc, asr r3
    1ed0:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    1ed4:	7261006c 	rsbvc	r0, r1, #108	; 0x6c
    1ed8:	616c5f6d 	cmnvs	ip, sp, ror #30
    1edc:	6f5f676e 	svcvs	0x005f676e
    1ee0:	75707475 	ldrbvc	r7, [r0, #-1141]!	; 0xfffffb8b
    1ee4:	626f5f74 	rsbvs	r5, pc, #116, 30	; 0x1d0
    1ee8:	7463656a 	strbtvc	r6, [r3], #-1386	; 0xfffffa96
    1eec:	7474615f 	ldrbtvc	r6, [r4], #-351	; 0xfffffea1
    1ef0:	75626972 	strbvc	r6, [r2, #-2418]!	; 0xfffff68e
    1ef4:	5f736574 	svcpl	0x00736574
    1ef8:	6b6f6f68 	blvs	1bddca0 <__bss_end+0x1bd4d8c>
    1efc:	61736900 	cmnvs	r3, r0, lsl #18
    1f00:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1f04:	5f70665f 	svcpl	0x0070665f
    1f08:	00323364 	eorseq	r3, r2, r4, ror #6
    1f0c:	5f4d5241 	svcpl	0x004d5241
    1f10:	6900454e 	stmdbvs	r0, {r1, r2, r3, r6, r8, sl, lr}
    1f14:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1f18:	625f7469 	subsvs	r7, pc, #1761607680	; 0x69000000
    1f1c:	54003865 	strpl	r3, [r0], #-2149	; 0xfffff79b
    1f20:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1f24:	50435f54 	subpl	r5, r3, r4, asr pc
    1f28:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1f2c:	3731316d 	ldrcc	r3, [r1, -sp, ror #2]!
    1f30:	737a6a36 	cmnvc	sl, #221184	; 0x36000
    1f34:	6f727000 	svcvs	0x00727000
    1f38:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1f3c:	745f726f 	ldrbvc	r7, [pc], #-623	; 1f44 <shift+0x1f44>
    1f40:	00657079 	rsbeq	r7, r5, r9, ror r0
    1f44:	5f6c6c61 	svcpl	0x006c6c61
    1f48:	73757066 	cmnvc	r5, #102	; 0x66
    1f4c:	6d726100 	ldfvse	f6, [r2, #-0]
    1f50:	7363705f 	cmnvc	r3, #95	; 0x5f
    1f54:	53414200 	movtpl	r4, #4608	; 0x1200
    1f58:	52415f45 	subpl	r5, r1, #276	; 0x114
    1f5c:	355f4843 	ldrbcc	r4, [pc, #-2115]	; 1721 <shift+0x1721>
    1f60:	72610054 	rsbvc	r0, r1, #84	; 0x54
    1f64:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1f68:	74346863 	ldrtvc	r6, [r4], #-2147	; 0xfffff79d
    1f6c:	52415400 	subpl	r5, r1, #0, 8
    1f70:	5f544547 	svcpl	0x00544547
    1f74:	5f555043 	svcpl	0x00555043
    1f78:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1f7c:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    1f80:	726f6336 	rsbvc	r6, pc, #-671088640	; 0xd8000000
    1f84:	61786574 	cmnvs	r8, r4, ror r5
    1f88:	61003535 	tstvs	r0, r5, lsr r5
    1f8c:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 1f94 <shift+0x1f94>
    1f90:	5f656e75 	svcpl	0x00656e75
    1f94:	66756277 			; <UNDEFINED> instruction: 0x66756277
    1f98:	61746800 	cmnvs	r4, r0, lsl #16
    1f9c:	61685f62 	cmnvs	r8, r2, ror #30
    1fa0:	69006873 	stmdbvs	r0, {r0, r1, r4, r5, r6, fp, sp, lr}
    1fa4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1fa8:	715f7469 	cmpvc	pc, r9, ror #8
    1fac:	6b726975 	blvs	1c9c588 <__bss_end+0x1c93674>
    1fb0:	5f6f6e5f 	svcpl	0x006f6e5f
    1fb4:	616c6f76 	smcvs	50934	; 0xc6f6
    1fb8:	656c6974 	strbvs	r6, [ip, #-2420]!	; 0xfffff68c
    1fbc:	0065635f 	rsbeq	r6, r5, pc, asr r3
    1fc0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1fc4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1fc8:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1fcc:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1fd0:	00306d78 	eorseq	r6, r0, r8, ror sp
    1fd4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1fd8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1fdc:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1fe0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1fe4:	00316d78 	eorseq	r6, r1, r8, ror sp
    1fe8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1fec:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1ff0:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1ff4:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1ff8:	00336d78 	eorseq	r6, r3, r8, ror sp
    1ffc:	5f617369 	svcpl	0x00617369
    2000:	5f746962 	svcpl	0x00746962
    2004:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2008:	00315f38 	eorseq	r5, r1, r8, lsr pc
    200c:	5f6d7261 	svcpl	0x006d7261
    2010:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2014:	6d616e5f 	stclvs	14, cr6, [r1, #-380]!	; 0xfffffe84
    2018:	73690065 	cmnvc	r9, #101	; 0x65
    201c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2020:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    2024:	5f38766d 	svcpl	0x0038766d
    2028:	73690033 	cmnvc	r9, #51	; 0x33
    202c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2030:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    2034:	5f38766d 	svcpl	0x0038766d
    2038:	73690034 	cmnvc	r9, #52	; 0x34
    203c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2040:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    2044:	5f38766d 	svcpl	0x0038766d
    2048:	41540035 	cmpmi	r4, r5, lsr r0
    204c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2050:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2054:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2058:	61786574 	cmnvs	r8, r4, ror r5
    205c:	54003335 	strpl	r3, [r0], #-821	; 0xfffffccb
    2060:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2064:	50435f54 	subpl	r5, r3, r4, asr pc
    2068:	6f635f55 	svcvs	0x00635f55
    206c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2070:	00353561 	eorseq	r3, r5, r1, ror #10
    2074:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2078:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    207c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2080:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2084:	37356178 			; <UNDEFINED> instruction: 0x37356178
    2088:	52415400 	subpl	r5, r1, #0, 8
    208c:	5f544547 	svcpl	0x00544547
    2090:	5f555043 	svcpl	0x00555043
    2094:	6f63706d 	svcvs	0x0063706d
    2098:	54006572 	strpl	r6, [r0], #-1394	; 0xfffffa8e
    209c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    20a0:	50435f54 	subpl	r5, r3, r4, asr pc
    20a4:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    20a8:	6f6e5f6d 	svcvs	0x006e5f6d
    20ac:	6100656e 	tstvs	r0, lr, ror #10
    20b0:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    20b4:	5f686372 	svcpl	0x00686372
    20b8:	6d746f6e 	ldclvs	15, cr6, [r4, #-440]!	; 0xfffffe48
    20bc:	52415400 	subpl	r5, r1, #0, 8
    20c0:	5f544547 	svcpl	0x00544547
    20c4:	5f555043 	svcpl	0x00555043
    20c8:	316d7261 	cmncc	sp, r1, ror #4
    20cc:	65363230 	ldrvs	r3, [r6, #-560]!	; 0xfffffdd0
    20d0:	4200736a 	andmi	r7, r0, #-1476395007	; 0xa8000001
    20d4:	5f455341 	svcpl	0x00455341
    20d8:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    20dc:	004a365f 	subeq	r3, sl, pc, asr r6
    20e0:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    20e4:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    20e8:	4b365f48 	blmi	d99e10 <__bss_end+0xd90efc>
    20ec:	53414200 	movtpl	r4, #4608	; 0x1200
    20f0:	52415f45 	subpl	r5, r1, #276	; 0x114
    20f4:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    20f8:	7369004d 	cmnvc	r9, #77	; 0x4d
    20fc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2100:	77695f74 			; <UNDEFINED> instruction: 0x77695f74
    2104:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    2108:	52415400 	subpl	r5, r1, #0, 8
    210c:	5f544547 	svcpl	0x00544547
    2110:	5f555043 	svcpl	0x00555043
    2114:	316d7261 	cmncc	sp, r1, ror #4
    2118:	6a363331 	bvs	d8ede4 <__bss_end+0xd85ed0>
    211c:	41007366 	tstmi	r0, r6, ror #6
    2120:	4c5f4d52 	mrrcmi	13, 5, r4, pc, cr2	; <UNPREDICTABLE>
    2124:	52410053 	subpl	r0, r1, #83	; 0x53
    2128:	544c5f4d 	strbpl	r5, [ip], #-3917	; 0xfffff0b3
    212c:	53414200 	movtpl	r4, #4608	; 0x1200
    2130:	52415f45 	subpl	r5, r1, #276	; 0x114
    2134:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    2138:	4154005a 	cmpmi	r4, sl, asr r0
    213c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2140:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2144:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2148:	61786574 	cmnvs	r8, r4, ror r5
    214c:	6f633537 	svcvs	0x00633537
    2150:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2154:	00353561 	eorseq	r3, r5, r1, ror #10
    2158:	5f4d5241 	svcpl	0x004d5241
    215c:	5f534350 	svcpl	0x00534350
    2160:	43504141 	cmpmi	r0, #1073741840	; 0x40000010
    2164:	46565f53 	usaxmi	r5, r6, r3
    2168:	41540050 	cmpmi	r4, r0, asr r0
    216c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2170:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2174:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    2178:	3274786d 	rsbscc	r7, r4, #7143424	; 0x6d0000
    217c:	61736900 	cmnvs	r3, r0, lsl #18
    2180:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2184:	6f656e5f 	svcvs	0x00656e5f
    2188:	7261006e 	rsbvc	r0, r1, #110	; 0x6e
    218c:	70665f6d 	rsbvc	r5, r6, sp, ror #30
    2190:	74615f75 	strbtvc	r5, [r1], #-3957	; 0xfffff08b
    2194:	69007274 	stmdbvs	r0, {r2, r4, r5, r6, r9, ip, sp, lr}
    2198:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    219c:	615f7469 	cmpvs	pc, r9, ror #8
    21a0:	37766d72 			; <UNDEFINED> instruction: 0x37766d72
    21a4:	54006d65 	strpl	r6, [r0], #-3429	; 0xfffff29b
    21a8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    21ac:	50435f54 	subpl	r5, r3, r4, asr pc
    21b0:	61665f55 	cmnvs	r6, r5, asr pc
    21b4:	74363236 	ldrtvc	r3, [r6], #-566	; 0xfffffdca
    21b8:	41540065 	cmpmi	r4, r5, rrx
    21bc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    21c0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    21c4:	72616d5f 	rsbvc	r6, r1, #6080	; 0x17c0
    21c8:	6c6c6576 	cfstr64vs	mvdx6, [ip], #-472	; 0xfffffe28
    21cc:	346a705f 	strbtcc	r7, [sl], #-95	; 0xffffffa1
    21d0:	61746800 	cmnvs	r4, r0, lsl #16
    21d4:	61685f62 	cmnvs	r8, r2, ror #30
    21d8:	705f6873 	subsvc	r6, pc, r3, ror r8	; <UNPREDICTABLE>
    21dc:	746e696f 	strbtvc	r6, [lr], #-2415	; 0xfffff691
    21e0:	61007265 	tstvs	r0, r5, ror #4
    21e4:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 21ec <shift+0x21ec>
    21e8:	5f656e75 	svcpl	0x00656e75
    21ec:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    21f0:	615f7865 	cmpvs	pc, r5, ror #16
    21f4:	73690039 	cmnvc	r9, #57	; 0x39
    21f8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    21fc:	77695f74 			; <UNDEFINED> instruction: 0x77695f74
    2200:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    2204:	41540032 	cmpmi	r4, r2, lsr r0
    2208:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    220c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2210:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2214:	61786574 	cmnvs	r8, r4, ror r5
    2218:	6f633237 	svcvs	0x00633237
    221c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2220:	00333561 	eorseq	r3, r3, r1, ror #10
    2224:	5f617369 	svcpl	0x00617369
    2228:	5f746962 	svcpl	0x00746962
    222c:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    2230:	42003262 	andmi	r3, r0, #536870918	; 0x20000006
    2234:	5f455341 	svcpl	0x00455341
    2238:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    223c:	0041375f 	subeq	r3, r1, pc, asr r7
    2240:	5f617369 	svcpl	0x00617369
    2244:	5f746962 	svcpl	0x00746962
    2248:	70746f64 	rsbsvc	r6, r4, r4, ror #30
    224c:	00646f72 	rsbeq	r6, r4, r2, ror pc
    2250:	5f6d7261 	svcpl	0x006d7261
    2254:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    2258:	7079745f 	rsbsvc	r7, r9, pc, asr r4
    225c:	6f6e5f65 	svcvs	0x006e5f65
    2260:	41006564 	tstmi	r0, r4, ror #10
    2264:	4d5f4d52 	ldclmi	13, cr4, [pc, #-328]	; 2124 <shift+0x2124>
    2268:	72610049 	rsbvc	r0, r1, #73	; 0x49
    226c:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2270:	6b366863 	blvs	d9c404 <__bss_end+0xd934f0>
    2274:	6d726100 	ldfvse	f6, [r2, #-0]
    2278:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    227c:	006d3668 	rsbeq	r3, sp, r8, ror #12
    2280:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    2284:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    2288:	52375f48 	eorspl	r5, r7, #72, 30	; 0x120
    228c:	705f5f00 	subsvc	r5, pc, r0, lsl #30
    2290:	6f63706f 	svcvs	0x0063706f
    2294:	5f746e75 	svcpl	0x00746e75
    2298:	00626174 	rsbeq	r6, r2, r4, ror r1
    229c:	5f617369 	svcpl	0x00617369
    22a0:	5f746962 	svcpl	0x00746962
    22a4:	65736d63 	ldrbvs	r6, [r3, #-3427]!	; 0xfffff29d
    22a8:	52415400 	subpl	r5, r1, #0, 8
    22ac:	5f544547 	svcpl	0x00544547
    22b0:	5f555043 	svcpl	0x00555043
    22b4:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    22b8:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    22bc:	41540033 	cmpmi	r4, r3, lsr r0
    22c0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    22c4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    22c8:	6e65675f 	mcrvs	7, 3, r6, cr5, cr15, {2}
    22cc:	63697265 	cmnvs	r9, #1342177286	; 0x50000006
    22d0:	00613776 	rsbeq	r3, r1, r6, ror r7
    22d4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    22d8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    22dc:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    22e0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    22e4:	36376178 			; <UNDEFINED> instruction: 0x36376178
    22e8:	6d726100 	ldfvse	f6, [r2, #-0]
    22ec:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    22f0:	6f6e5f68 	svcvs	0x006e5f68
    22f4:	6c6f765f 	stclvs	6, cr7, [pc], #-380	; 2180 <shift+0x2180>
    22f8:	6c697461 	cfstrdvs	mvd7, [r9], #-388	; 0xfffffe7c
    22fc:	65635f65 	strbvs	r5, [r3, #-3941]!	; 0xfffff09b
    2300:	53414200 	movtpl	r4, #4608	; 0x1200
    2304:	52415f45 	subpl	r5, r1, #276	; 0x114
    2308:	385f4843 	ldmdacc	pc, {r0, r1, r6, fp, lr}^	; <UNPREDICTABLE>
    230c:	73690041 	cmnvc	r9, #65	; 0x41
    2310:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2314:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    2318:	7435766d 	ldrtvc	r7, [r5], #-1645	; 0xfffff993
    231c:	53414200 	movtpl	r4, #4608	; 0x1200
    2320:	52415f45 	subpl	r5, r1, #276	; 0x114
    2324:	385f4843 	ldmdacc	pc, {r0, r1, r6, fp, lr}^	; <UNPREDICTABLE>
    2328:	41540052 	cmpmi	r4, r2, asr r0
    232c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2330:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2334:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2338:	61786574 	cmnvs	r8, r4, ror r5
    233c:	6f633337 	svcvs	0x00633337
    2340:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2344:	00353361 	eorseq	r3, r5, r1, ror #6
    2348:	5f4d5241 	svcpl	0x004d5241
    234c:	6100564e 	tstvs	r0, lr, asr #12
    2350:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2354:	34686372 	strbtcc	r6, [r8], #-882	; 0xfffffc8e
    2358:	6d726100 	ldfvse	f6, [r2, #-0]
    235c:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2360:	61003668 	tstvs	r0, r8, ror #12
    2364:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2368:	37686372 			; <UNDEFINED> instruction: 0x37686372
    236c:	6d726100 	ldfvse	f6, [r2, #-0]
    2370:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2374:	6c003868 	stcvs	8, cr3, [r0], {104}	; 0x68
    2378:	20676e6f 	rsbcs	r6, r7, pc, ror #28
    237c:	62756f64 	rsbsvs	r6, r5, #100, 30	; 0x190
    2380:	6100656c 	tstvs	r0, ip, ror #10
    2384:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 238c <shift+0x238c>
    2388:	5f656e75 	svcpl	0x00656e75
    238c:	61637378 	smcvs	14136	; 0x3738
    2390:	6d00656c 	cfstr32vs	mvfx6, [r0, #-432]	; 0xfffffe50
    2394:	6e696b61 	vnmulvs.f64	d22, d9, d17
    2398:	6f635f67 	svcvs	0x00635f67
    239c:	5f74736e 	svcpl	0x0074736e
    23a0:	6c626174 	stfvse	f6, [r2], #-464	; 0xfffffe30
    23a4:	68740065 	ldmdavs	r4!, {r0, r2, r5, r6}^
    23a8:	5f626d75 	svcpl	0x00626d75
    23ac:	6c6c6163 	stfvse	f6, [ip], #-396	; 0xfffffe74
    23b0:	6169765f 	cmnvs	r9, pc, asr r6
    23b4:	62616c5f 	rsbvs	r6, r1, #24320	; 0x5f00
    23b8:	69006c65 	stmdbvs	r0, {r0, r2, r5, r6, sl, fp, sp, lr}
    23bc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    23c0:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    23c4:	00357670 	eorseq	r7, r5, r0, ror r6
    23c8:	5f617369 	svcpl	0x00617369
    23cc:	5f746962 	svcpl	0x00746962
    23d0:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    23d4:	54006b36 	strpl	r6, [r0], #-2870	; 0xfffff4ca
    23d8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    23dc:	50435f54 	subpl	r5, r3, r4, asr pc
    23e0:	6f635f55 	svcvs	0x00635f55
    23e4:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    23e8:	54003761 	strpl	r3, [r0], #-1889	; 0xfffff89f
    23ec:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    23f0:	50435f54 	subpl	r5, r3, r4, asr pc
    23f4:	6f635f55 	svcvs	0x00635f55
    23f8:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    23fc:	54003861 	strpl	r3, [r0], #-2145	; 0xfffff79f
    2400:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2404:	50435f54 	subpl	r5, r3, r4, asr pc
    2408:	6f635f55 	svcvs	0x00635f55
    240c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2410:	41003961 	tstmi	r0, r1, ror #18
    2414:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    2418:	415f5343 	cmpmi	pc, r3, asr #6
    241c:	00534350 	subseq	r4, r3, r0, asr r3
    2420:	5f4d5241 	svcpl	0x004d5241
    2424:	5f534350 	svcpl	0x00534350
    2428:	43505441 	cmpmi	r0, #1090519040	; 0x41000000
    242c:	6f630053 	svcvs	0x00630053
    2430:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    2434:	6f642078 	svcvs	0x00642078
    2438:	656c6275 	strbvs	r6, [ip, #-629]!	; 0xfffffd8b
    243c:	52415400 	subpl	r5, r1, #0, 8
    2440:	5f544547 	svcpl	0x00544547
    2444:	5f555043 	svcpl	0x00555043
    2448:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    244c:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    2450:	726f6333 	rsbvc	r6, pc, #-872415232	; 0xcc000000
    2454:	61786574 	cmnvs	r8, r4, ror r5
    2458:	54003335 	strpl	r3, [r0], #-821	; 0xfffffccb
    245c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2460:	50435f54 	subpl	r5, r3, r4, asr pc
    2464:	6f635f55 	svcvs	0x00635f55
    2468:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    246c:	6c70306d 	ldclvs	0, cr3, [r0], #-436	; 0xfffffe4c
    2470:	61007375 	tstvs	r0, r5, ror r3
    2474:	635f6d72 	cmpvs	pc, #7296	; 0x1c80
    2478:	73690063 	cmnvc	r9, #99	; 0x63
    247c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2480:	73785f74 	cmnvc	r8, #116, 30	; 0x1d0
    2484:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    2488:	6f645f00 	svcvs	0x00645f00
    248c:	755f746e 	ldrbvc	r7, [pc, #-1134]	; 2026 <shift+0x2026>
    2490:	745f6573 	ldrbvc	r6, [pc], #-1395	; 2498 <shift+0x2498>
    2494:	5f656572 	svcpl	0x00656572
    2498:	65726568 	ldrbvs	r6, [r2, #-1384]!	; 0xfffffa98
    249c:	4154005f 	cmpmi	r4, pc, asr r0
    24a0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    24a4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    24a8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    24ac:	64743031 	ldrbtvs	r3, [r4], #-49	; 0xffffffcf
    24b0:	5400696d 	strpl	r6, [r0], #-2413	; 0xfffff693
    24b4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    24b8:	50435f54 	subpl	r5, r3, r4, asr pc
    24bc:	6f635f55 	svcvs	0x00635f55
    24c0:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    24c4:	62003561 	andvs	r3, r0, #406847488	; 0x18400000
    24c8:	5f657361 	svcpl	0x00657361
    24cc:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    24d0:	63657469 	cmnvs	r5, #1761607680	; 0x69000000
    24d4:	65727574 	ldrbvs	r7, [r2, #-1396]!	; 0xfffffa8c
    24d8:	6d726100 	ldfvse	f6, [r2, #-0]
    24dc:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    24e0:	72635f68 	rsbvc	r5, r3, #104, 30	; 0x1a0
    24e4:	41540063 	cmpmi	r4, r3, rrx
    24e8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    24ec:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    24f0:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    24f4:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    24f8:	616d7331 	cmnvs	sp, r1, lsr r3
    24fc:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    2500:	7069746c 	rsbvc	r7, r9, ip, ror #8
    2504:	6100796c 	tstvs	r0, ip, ror #18
    2508:	635f6d72 	cmpvs	pc, #7296	; 0x1c80
    250c:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
    2510:	635f746e 	cmpvs	pc, #1845493760	; 0x6e000000
    2514:	73690063 	cmnvc	r9, #99	; 0x63
    2518:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    251c:	72635f74 	rsbvc	r5, r3, #116, 30	; 0x1d0
    2520:	00323363 	eorseq	r3, r2, r3, ror #6
    2524:	5f4d5241 	svcpl	0x004d5241
    2528:	69004c50 	stmdbvs	r0, {r4, r6, sl, fp, lr}
    252c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2530:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    2534:	33767066 	cmncc	r6, #102	; 0x66
    2538:	61736900 	cmnvs	r3, r0, lsl #18
    253c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2540:	7066765f 	rsbvc	r7, r6, pc, asr r6
    2544:	42003476 	andmi	r3, r0, #1979711488	; 0x76000000
    2548:	5f455341 	svcpl	0x00455341
    254c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    2550:	3254365f 	subscc	r3, r4, #99614720	; 0x5f00000
    2554:	53414200 	movtpl	r4, #4608	; 0x1200
    2558:	52415f45 	subpl	r5, r1, #276	; 0x114
    255c:	385f4843 	ldmdacc	pc, {r0, r1, r6, fp, lr}^	; <UNPREDICTABLE>
    2560:	414d5f4d 	cmpmi	sp, sp, asr #30
    2564:	54004e49 	strpl	r4, [r0], #-3657	; 0xfffff1b7
    2568:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    256c:	50435f54 	subpl	r5, r3, r4, asr pc
    2570:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    2574:	6474396d 	ldrbtvs	r3, [r4], #-2413	; 0xfffff693
    2578:	4100696d 	tstmi	r0, sp, ror #18
    257c:	415f4d52 	cmpmi	pc, r2, asr sp	; <UNPREDICTABLE>
    2580:	4142004c 	cmpmi	r2, ip, asr #32
    2584:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    2588:	5f484352 	svcpl	0x00484352
    258c:	61004d37 	tstvs	r0, r7, lsr sp
    2590:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 2598 <shift+0x2598>
    2594:	65677261 	strbvs	r7, [r7, #-609]!	; 0xfffffd9f
    2598:	616c5f74 	smcvs	50676	; 0xc5f4
    259c:	006c6562 	rsbeq	r6, ip, r2, ror #10
    25a0:	5f6d7261 	svcpl	0x006d7261
    25a4:	67726174 			; <UNDEFINED> instruction: 0x67726174
    25a8:	695f7465 	ldmdbvs	pc, {r0, r2, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    25ac:	006e736e 	rsbeq	r7, lr, lr, ror #6
    25b0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    25b4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    25b8:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    25bc:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    25c0:	00347278 	eorseq	r7, r4, r8, ror r2
    25c4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    25c8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    25cc:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    25d0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    25d4:	00357278 	eorseq	r7, r5, r8, ror r2
    25d8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    25dc:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    25e0:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    25e4:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    25e8:	00377278 	eorseq	r7, r7, r8, ror r2
    25ec:	47524154 			; <UNDEFINED> instruction: 0x47524154
    25f0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    25f4:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    25f8:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    25fc:	00387278 	eorseq	r7, r8, r8, ror r2
    2600:	5f617369 	svcpl	0x00617369
    2604:	5f746962 	svcpl	0x00746962
    2608:	6561706c 	strbvs	r7, [r1, #-108]!	; 0xffffff94
    260c:	61736900 	cmnvs	r3, r0, lsl #18
    2610:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2614:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    2618:	615f6b72 	cmpvs	pc, r2, ror fp	; <UNPREDICTABLE>
    261c:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    2620:	69007a6b 	stmdbvs	r0, {r0, r1, r3, r5, r6, r9, fp, ip, sp, lr}
    2624:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2628:	6e5f7469 	cdpvs	4, 5, cr7, cr15, cr9, {3}
    262c:	006d746f 	rsbeq	r7, sp, pc, ror #8
    2630:	5f617369 	svcpl	0x00617369
    2634:	5f746962 	svcpl	0x00746962
    2638:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    263c:	73690034 	cmnvc	r9, #52	; 0x34
    2640:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2644:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    2648:	0036766d 	eorseq	r7, r6, sp, ror #12
    264c:	5f617369 	svcpl	0x00617369
    2650:	5f746962 	svcpl	0x00746962
    2654:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2658:	73690037 	cmnvc	r9, #55	; 0x37
    265c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2660:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    2664:	0038766d 	eorseq	r7, r8, sp, ror #12
    2668:	6e6f645f 	mcrvs	4, 3, r6, cr15, cr15, {2}
    266c:	73755f74 	cmnvc	r5, #116, 30	; 0x1d0
    2670:	74725f65 	ldrbtvc	r5, [r2], #-3941	; 0xfffff09b
    2674:	65685f78 	strbvs	r5, [r8, #-3960]!	; 0xfffff088
    2678:	005f6572 	subseq	r6, pc, r2, ror r5	; <UNPREDICTABLE>
    267c:	74495155 	strbvc	r5, [r9], #-341	; 0xfffffeab
    2680:	00657079 	rsbeq	r7, r5, r9, ror r0
    2684:	5f617369 	svcpl	0x00617369
    2688:	5f746962 	svcpl	0x00746962
    268c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2690:	00657435 	rsbeq	r7, r5, r5, lsr r4
    2694:	5f6d7261 	svcpl	0x006d7261
    2698:	656e7574 	strbvs	r7, [lr, #-1396]!	; 0xfffffa8c
    269c:	6d726100 	ldfvse	f6, [r2, #-0]
    26a0:	7070635f 	rsbsvc	r6, r0, pc, asr r3
    26a4:	746e695f 	strbtvc	r6, [lr], #-2399	; 0xfffff6a1
    26a8:	6f777265 	svcvs	0x00777265
    26ac:	66006b72 			; <UNDEFINED> instruction: 0x66006b72
    26b0:	5f636e75 	svcpl	0x00636e75
    26b4:	00727470 	rsbseq	r7, r2, r0, ror r4
    26b8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    26bc:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    26c0:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    26c4:	32396d72 	eorscc	r6, r9, #7296	; 0x1c80
    26c8:	68007430 	stmdavs	r0, {r4, r5, sl, ip, sp, lr}
    26cc:	5f626174 	svcpl	0x00626174
    26d0:	54007165 	strpl	r7, [r0], #-357	; 0xfffffe9b
    26d4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    26d8:	50435f54 	subpl	r5, r3, r4, asr pc
    26dc:	61665f55 	cmnvs	r6, r5, asr pc
    26e0:	00363235 	eorseq	r3, r6, r5, lsr r2
    26e4:	5f6d7261 	svcpl	0x006d7261
    26e8:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    26ec:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    26f0:	685f626d 	ldmdavs	pc, {r0, r2, r3, r5, r6, r9, sp, lr}^	; <UNPREDICTABLE>
    26f4:	76696477 			; <UNDEFINED> instruction: 0x76696477
    26f8:	61746800 	cmnvs	r4, r0, lsl #16
    26fc:	71655f62 	cmnvc	r5, r2, ror #30
    2700:	696f705f 	stmdbvs	pc!, {r0, r1, r2, r3, r4, r6, ip, sp, lr}^	; <UNPREDICTABLE>
    2704:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    2708:	6d726100 	ldfvse	f6, [r2, #-0]
    270c:	6369705f 	cmnvs	r9, #95	; 0x5f
    2710:	6765725f 			; <UNDEFINED> instruction: 0x6765725f
    2714:	65747369 	ldrbvs	r7, [r4, #-873]!	; 0xfffffc97
    2718:	41540072 	cmpmi	r4, r2, ror r0
    271c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2720:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2724:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2728:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    272c:	616d7330 	cmnvs	sp, r0, lsr r3
    2730:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    2734:	7069746c 	rsbvc	r7, r9, ip, ror #8
    2738:	5400796c 	strpl	r7, [r0], #-2412	; 0xfffff694
    273c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2740:	50435f54 	subpl	r5, r3, r4, asr pc
    2744:	706d5f55 	rsbvc	r5, sp, r5, asr pc
    2748:	65726f63 	ldrbvs	r6, [r2, #-3939]!	; 0xfffff09d
    274c:	66766f6e 	ldrbtvs	r6, [r6], -lr, ror #30
    2750:	73690070 	cmnvc	r9, #112	; 0x70
    2754:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2758:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    275c:	5f6b7269 	svcpl	0x006b7269
    2760:	5f336d63 	svcpl	0x00336d63
    2764:	6472646c 	ldrbtvs	r6, [r2], #-1132	; 0xfffffb94
    2768:	4d524100 	ldfmie	f4, [r2, #-0]
    276c:	0043435f 	subeq	r4, r3, pc, asr r3
    2770:	5f6d7261 	svcpl	0x006d7261
    2774:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2778:	00325f38 	eorseq	r5, r2, r8, lsr pc
    277c:	5f6d7261 	svcpl	0x006d7261
    2780:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2784:	00335f38 	eorseq	r5, r3, r8, lsr pc
    2788:	5f6d7261 	svcpl	0x006d7261
    278c:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2790:	00345f38 	eorseq	r5, r4, r8, lsr pc
    2794:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2798:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    279c:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    27a0:	3236706d 	eorscc	r7, r6, #109	; 0x6d
    27a4:	52410036 	subpl	r0, r1, #54	; 0x36
    27a8:	53435f4d 	movtpl	r5, #16205	; 0x3f4d
    27ac:	6d726100 	ldfvse	f6, [r2, #-0]
    27b0:	3170665f 	cmncc	r0, pc, asr r6
    27b4:	6e695f36 	mcrvs	15, 3, r5, cr9, cr6, {1}
    27b8:	61007473 	tstvs	r0, r3, ror r4
    27bc:	625f6d72 	subsvs	r6, pc, #7296	; 0x1c80
    27c0:	5f657361 	svcpl	0x00657361
    27c4:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    27c8:	52415400 	subpl	r5, r1, #0, 8
    27cc:	5f544547 	svcpl	0x00544547
    27d0:	5f555043 	svcpl	0x00555043
    27d4:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    27d8:	31617865 	cmncc	r1, r5, ror #16
    27dc:	726f6335 	rsbvc	r6, pc, #-738197504	; 0xd4000000
    27e0:	61786574 	cmnvs	r8, r4, ror r5
    27e4:	72610037 	rsbvc	r0, r1, #55	; 0x37
    27e8:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    27ec:	65376863 	ldrvs	r6, [r7, #-2147]!	; 0xfffff79d
    27f0:	4154006d 	cmpmi	r4, sp, rrx
    27f4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    27f8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    27fc:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2800:	61786574 	cmnvs	r8, r4, ror r5
    2804:	61003237 	tstvs	r0, r7, lsr r2
    2808:	705f6d72 	subsvc	r6, pc, r2, ror sp	; <UNPREDICTABLE>
    280c:	645f7363 	ldrbvs	r7, [pc], #-867	; 2814 <shift+0x2814>
    2810:	75616665 	strbvc	r6, [r1, #-1637]!	; 0xfffff99b
    2814:	4100746c 	tstmi	r0, ip, ror #8
    2818:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    281c:	415f5343 	cmpmi	pc, r3, asr #6
    2820:	53435041 	movtpl	r5, #12353	; 0x3041
    2824:	434f4c5f 	movtmi	r4, #64607	; 0xfc5f
    2828:	54004c41 	strpl	r4, [r0], #-3137	; 0xfffff3bf
    282c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2830:	50435f54 	subpl	r5, r3, r4, asr pc
    2834:	6f635f55 	svcvs	0x00635f55
    2838:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    283c:	00353761 	eorseq	r3, r5, r1, ror #14
    2840:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2844:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2848:	735f5550 	cmpvc	pc, #80, 10	; 0x14000000
    284c:	6e6f7274 	mcrvs	2, 3, r7, cr15, cr4, {3}
    2850:	6d726167 	ldfvse	f6, [r2, #-412]!	; 0xfffffe64
    2854:	6d726100 	ldfvse	f6, [r2, #-0]
    2858:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    285c:	68745f68 	ldmdavs	r4!, {r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    2860:	31626d75 	smccc	9941	; 0x26d5
    2864:	6d726100 	ldfvse	f6, [r2, #-0]
    2868:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    286c:	68745f68 	ldmdavs	r4!, {r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    2870:	32626d75 	rsbcc	r6, r2, #7488	; 0x1d40
    2874:	52415400 	subpl	r5, r1, #0, 8
    2878:	5f544547 	svcpl	0x00544547
    287c:	5f555043 	svcpl	0x00555043
    2880:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    2884:	61007478 	tstvs	r0, r8, ror r4
    2888:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    288c:	35686372 	strbcc	r6, [r8, #-882]!	; 0xfffffc8e
    2890:	73690074 	cmnvc	r9, #116	; 0x74
    2894:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2898:	706d5f74 	rsbvc	r5, sp, r4, ror pc
    289c:	6d726100 	ldfvse	f6, [r2, #-0]
    28a0:	5f646c5f 	svcpl	0x00646c5f
    28a4:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
    28a8:	72610064 	rsbvc	r0, r1, #100	; 0x64
    28ac:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    28b0:	5f386863 	svcpl	0x00386863
    28b4:	Address 0x00000000000028b4 is out of bounds.


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
  20:	8b040e42 	blhi	103930 <__bss_end+0xfaa1c>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x34791c>
  28:	420d0d68 	andmi	r0, sp, #104, 26	; 0x1a00
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008070 	andeq	r8, r0, r0, ror r0
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1faa3c>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xf9d6c>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080b0 	strheq	r8, [r0], -r0
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xfaa6c>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x34796c>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080e8 	andeq	r8, r0, r8, ror #1
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xfaa8c>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x34798c>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008114 	andeq	r8, r0, r4, lsl r1
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xfaaac>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x3479ac>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008134 	andeq	r8, r0, r4, lsr r1
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xfaacc>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x3479cc>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	0000814c 	andeq	r8, r0, ip, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xfaaec>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x3479ec>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008164 	andeq	r8, r0, r4, ror #2
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xfab0c>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x347a0c>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	0000817c 	andeq	r8, r0, ip, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xfab2c>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x347a2c>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	00008188 	andeq	r8, r0, r8, lsl #3
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1fab44>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081e0 	andeq	r8, r0, r0, ror #3
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1fab64>
 16c:	42018e02 	andmi	r8, r1, #2, 28
 170:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 174:	00080d0c 	andeq	r0, r8, ip, lsl #26
 178:	0000000c 	andeq	r0, r0, ip
 17c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 180:	7c020001 	stcvc	0, cr0, [r2], {1}
 184:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 188:	00000018 	andeq	r0, r0, r8, lsl r0
 18c:	00000178 	andeq	r0, r0, r8, ror r1
 190:	00008238 	andeq	r8, r0, r8, lsr r2
 194:	000000dc 	ldrdeq	r0, [r0], -ip
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1fab94>
 19c:	42018e02 	andmi	r8, r1, #2, 28
 1a0:	00040b0c 	andeq	r0, r4, ip, lsl #22
 1a4:	0000000c 	andeq	r0, r0, ip
 1a8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 1ac:	7c020001 	stcvc	0, cr0, [r2], {1}
 1b0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 1b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1bc:	00008314 	andeq	r8, r0, r4, lsl r3
 1c0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1c4:	8b040e42 	blhi	103ad4 <__bss_end+0xfabc0>
 1c8:	0b0d4201 	bleq	3509d4 <__bss_end+0x347ac0>
 1cc:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1dc:	00008340 	andeq	r8, r0, r0, asr #6
 1e0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1e4:	8b040e42 	blhi	103af4 <__bss_end+0xfabe0>
 1e8:	0b0d4201 	bleq	3509f4 <__bss_end+0x347ae0>
 1ec:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1fc:	0000836c 	andeq	r8, r0, ip, ror #6
 200:	0000001c 	andeq	r0, r0, ip, lsl r0
 204:	8b040e42 	blhi	103b14 <__bss_end+0xfac00>
 208:	0b0d4201 	bleq	350a14 <__bss_end+0x347b00>
 20c:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 210:	00000ecb 	andeq	r0, r0, fp, asr #29
 214:	0000001c 	andeq	r0, r0, ip, lsl r0
 218:	000001a4 	andeq	r0, r0, r4, lsr #3
 21c:	00008388 	andeq	r8, r0, r8, lsl #7
 220:	00000044 	andeq	r0, r0, r4, asr #32
 224:	8b040e42 	blhi	103b34 <__bss_end+0xfac20>
 228:	0b0d4201 	bleq	350a34 <__bss_end+0x347b20>
 22c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 230:	00000ecb 	andeq	r0, r0, fp, asr #29
 234:	0000001c 	andeq	r0, r0, ip, lsl r0
 238:	000001a4 	andeq	r0, r0, r4, lsr #3
 23c:	000083cc 	andeq	r8, r0, ip, asr #7
 240:	00000050 	andeq	r0, r0, r0, asr r0
 244:	8b040e42 	blhi	103b54 <__bss_end+0xfac40>
 248:	0b0d4201 	bleq	350a54 <__bss_end+0x347b40>
 24c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 250:	00000ecb 	andeq	r0, r0, fp, asr #29
 254:	0000001c 	andeq	r0, r0, ip, lsl r0
 258:	000001a4 	andeq	r0, r0, r4, lsr #3
 25c:	0000841c 	andeq	r8, r0, ip, lsl r4
 260:	00000050 	andeq	r0, r0, r0, asr r0
 264:	8b040e42 	blhi	103b74 <__bss_end+0xfac60>
 268:	0b0d4201 	bleq	350a74 <__bss_end+0x347b60>
 26c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 270:	00000ecb 	andeq	r0, r0, fp, asr #29
 274:	0000001c 	andeq	r0, r0, ip, lsl r0
 278:	000001a4 	andeq	r0, r0, r4, lsr #3
 27c:	0000846c 	andeq	r8, r0, ip, ror #8
 280:	0000002c 	andeq	r0, r0, ip, lsr #32
 284:	8b040e42 	blhi	103b94 <__bss_end+0xfac80>
 288:	0b0d4201 	bleq	350a94 <__bss_end+0x347b80>
 28c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 290:	00000ecb 	andeq	r0, r0, fp, asr #29
 294:	0000001c 	andeq	r0, r0, ip, lsl r0
 298:	000001a4 	andeq	r0, r0, r4, lsr #3
 29c:	00008498 	muleq	r0, r8, r4
 2a0:	00000050 	andeq	r0, r0, r0, asr r0
 2a4:	8b040e42 	blhi	103bb4 <__bss_end+0xfaca0>
 2a8:	0b0d4201 	bleq	350ab4 <__bss_end+0x347ba0>
 2ac:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2bc:	000084e8 	andeq	r8, r0, r8, ror #9
 2c0:	00000044 	andeq	r0, r0, r4, asr #32
 2c4:	8b040e42 	blhi	103bd4 <__bss_end+0xfacc0>
 2c8:	0b0d4201 	bleq	350ad4 <__bss_end+0x347bc0>
 2cc:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 2d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2dc:	0000852c 	andeq	r8, r0, ip, lsr #10
 2e0:	00000050 	andeq	r0, r0, r0, asr r0
 2e4:	8b040e42 	blhi	103bf4 <__bss_end+0xface0>
 2e8:	0b0d4201 	bleq	350af4 <__bss_end+0x347be0>
 2ec:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2fc:	0000857c 	andeq	r8, r0, ip, ror r5
 300:	00000054 	andeq	r0, r0, r4, asr r0
 304:	8b040e42 	blhi	103c14 <__bss_end+0xfad00>
 308:	0b0d4201 	bleq	350b14 <__bss_end+0x347c00>
 30c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 310:	00000ecb 	andeq	r0, r0, fp, asr #29
 314:	0000001c 	andeq	r0, r0, ip, lsl r0
 318:	000001a4 	andeq	r0, r0, r4, lsr #3
 31c:	000085d0 	ldrdeq	r8, [r0], -r0
 320:	0000003c 	andeq	r0, r0, ip, lsr r0
 324:	8b040e42 	blhi	103c34 <__bss_end+0xfad20>
 328:	0b0d4201 	bleq	350b34 <__bss_end+0x347c20>
 32c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 330:	00000ecb 	andeq	r0, r0, fp, asr #29
 334:	0000001c 	andeq	r0, r0, ip, lsl r0
 338:	000001a4 	andeq	r0, r0, r4, lsr #3
 33c:	0000860c 	andeq	r8, r0, ip, lsl #12
 340:	0000003c 	andeq	r0, r0, ip, lsr r0
 344:	8b040e42 	blhi	103c54 <__bss_end+0xfad40>
 348:	0b0d4201 	bleq	350b54 <__bss_end+0x347c40>
 34c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 350:	00000ecb 	andeq	r0, r0, fp, asr #29
 354:	0000001c 	andeq	r0, r0, ip, lsl r0
 358:	000001a4 	andeq	r0, r0, r4, lsr #3
 35c:	00008648 	andeq	r8, r0, r8, asr #12
 360:	0000003c 	andeq	r0, r0, ip, lsr r0
 364:	8b040e42 	blhi	103c74 <__bss_end+0xfad60>
 368:	0b0d4201 	bleq	350b74 <__bss_end+0x347c60>
 36c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 370:	00000ecb 	andeq	r0, r0, fp, asr #29
 374:	0000001c 	andeq	r0, r0, ip, lsl r0
 378:	000001a4 	andeq	r0, r0, r4, lsr #3
 37c:	00008684 	andeq	r8, r0, r4, lsl #13
 380:	0000003c 	andeq	r0, r0, ip, lsr r0
 384:	8b040e42 	blhi	103c94 <__bss_end+0xfad80>
 388:	0b0d4201 	bleq	350b94 <__bss_end+0x347c80>
 38c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 390:	00000ecb 	andeq	r0, r0, fp, asr #29
 394:	0000001c 	andeq	r0, r0, ip, lsl r0
 398:	000001a4 	andeq	r0, r0, r4, lsr #3
 39c:	000086c0 	andeq	r8, r0, r0, asr #13
 3a0:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 3a4:	8b080e42 	blhi	203cb4 <__bss_end+0x1fada0>
 3a8:	42018e02 	andmi	r8, r1, #2, 28
 3ac:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3b0:	080d0c50 	stmdaeq	sp, {r4, r6, sl, fp}
 3b4:	0000000c 	andeq	r0, r0, ip
 3b8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 3bc:	7c020001 	stcvc	0, cr0, [r2], {1}
 3c0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 3c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3c8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3cc:	00008770 	andeq	r8, r0, r0, ror r7
 3d0:	00000174 	andeq	r0, r0, r4, ror r1
 3d4:	8b080e42 	blhi	203ce4 <__bss_end+0x1fadd0>
 3d8:	42018e02 	andmi	r8, r1, #2, 28
 3dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3e0:	080d0cb2 	stmdaeq	sp, {r1, r4, r5, r7, sl, fp}
 3e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3e8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3ec:	000088e4 	andeq	r8, r0, r4, ror #17
 3f0:	0000009c 	muleq	r0, ip, r0
 3f4:	8b040e42 	blhi	103d04 <__bss_end+0xfadf0>
 3f8:	0b0d4201 	bleq	350c04 <__bss_end+0x347cf0>
 3fc:	0d0d4602 	stceq	6, cr4, [sp, #-8]
 400:	000ecb42 	andeq	ip, lr, r2, asr #22
 404:	0000001c 	andeq	r0, r0, ip, lsl r0
 408:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 40c:	00008980 	andeq	r8, r0, r0, lsl #19
 410:	000000c0 	andeq	r0, r0, r0, asr #1
 414:	8b040e42 	blhi	103d24 <__bss_end+0xfae10>
 418:	0b0d4201 	bleq	350c24 <__bss_end+0x347d10>
 41c:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 420:	000ecb42 	andeq	ip, lr, r2, asr #22
 424:	0000001c 	andeq	r0, r0, ip, lsl r0
 428:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 42c:	00008a40 	andeq	r8, r0, r0, asr #20
 430:	000000ac 	andeq	r0, r0, ip, lsr #1
 434:	8b040e42 	blhi	103d44 <__bss_end+0xfae30>
 438:	0b0d4201 	bleq	350c44 <__bss_end+0x347d30>
 43c:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 440:	000ecb42 	andeq	ip, lr, r2, asr #22
 444:	0000001c 	andeq	r0, r0, ip, lsl r0
 448:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 44c:	00008aec 	andeq	r8, r0, ip, ror #21
 450:	00000054 	andeq	r0, r0, r4, asr r0
 454:	8b040e42 	blhi	103d64 <__bss_end+0xfae50>
 458:	0b0d4201 	bleq	350c64 <__bss_end+0x347d50>
 45c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 460:	00000ecb 	andeq	r0, r0, fp, asr #29
 464:	0000001c 	andeq	r0, r0, ip, lsl r0
 468:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 46c:	00008b40 	andeq	r8, r0, r0, asr #22
 470:	00000068 	andeq	r0, r0, r8, rrx
 474:	8b040e42 	blhi	103d84 <__bss_end+0xfae70>
 478:	0b0d4201 	bleq	350c84 <__bss_end+0x347d70>
 47c:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 480:	00000ecb 	andeq	r0, r0, fp, asr #29
 484:	0000001c 	andeq	r0, r0, ip, lsl r0
 488:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 48c:	00008ba8 	andeq	r8, r0, r8, lsr #23
 490:	00000080 	andeq	r0, r0, r0, lsl #1
 494:	8b040e42 	blhi	103da4 <__bss_end+0xfae90>
 498:	0b0d4201 	bleq	350ca4 <__bss_end+0x347d90>
 49c:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 4a0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4a4:	0000000c 	andeq	r0, r0, ip
 4a8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 4ac:	7c010001 	stcvc	0, cr0, [r1], {1}
 4b0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 4b4:	0000000c 	andeq	r0, r0, ip
 4b8:	000004a4 	andeq	r0, r0, r4, lsr #9
 4bc:	00008c28 	andeq	r8, r0, r8, lsr #24
 4c0:	000001ec 	andeq	r0, r0, ip, ror #3
