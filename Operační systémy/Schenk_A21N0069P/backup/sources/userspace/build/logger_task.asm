
./logger_task:     file format elf32-littlearm


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
    8068:	00008f84 	andeq	r8, r0, r4, lsl #31
    806c:	00008f94 	muleq	r0, r4, pc	; <UNPREDICTABLE>

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
    808c:	eb000078 	bl	8274 <main>
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
    81d8:	00008f81 	andeq	r8, r0, r1, lsl #31
    81dc:	00008f81 	andeq	r8, r0, r1, lsl #31

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
    8230:	00008f81 	andeq	r8, r0, r1, lsl #31
    8234:	00008f81 	andeq	r8, r0, r1, lsl #31

00008238 <_ZL5fputsjPKc>:
_ZL5fputsjPKc():
/home/schenkj/os2022/sp/sources/userspace/logger_task/main.cpp:14
 * 
 * Prijima vsechny udalosti od ostatnich tasku a oznamuje je skrz UART hostiteli
 **/

static void fputs(uint32_t file, const char* string)
{
    8238:	e92d4800 	push	{fp, lr}
    823c:	e28db004 	add	fp, sp, #4
    8240:	e24dd008 	sub	sp, sp, #8
    8244:	e50b0008 	str	r0, [fp, #-8]
    8248:	e50b100c 	str	r1, [fp, #-12]
/home/schenkj/os2022/sp/sources/userspace/logger_task/main.cpp:15
	write(file, string, strlen(string));
    824c:	e51b000c 	ldr	r0, [fp, #-12]
    8250:	eb00024e 	bl	8b90 <_Z6strlenPKc>
    8254:	e1a03000 	mov	r3, r0
    8258:	e1a02003 	mov	r2, r3
    825c:	e51b100c 	ldr	r1, [fp, #-12]
    8260:	e51b0008 	ldr	r0, [fp, #-8]
    8264:	eb000095 	bl	84c0 <_Z5writejPKcj>
/home/schenkj/os2022/sp/sources/userspace/logger_task/main.cpp:16
}
    8268:	e320f000 	nop	{0}
    826c:	e24bd004 	sub	sp, fp, #4
    8270:	e8bd8800 	pop	{fp, pc}

00008274 <main>:
main():
/home/schenkj/os2022/sp/sources/userspace/logger_task/main.cpp:19

int main(int argc, char** argv)
{
    8274:	e92d4800 	push	{fp, lr}
    8278:	e28db004 	add	fp, sp, #4
    827c:	e24dd048 	sub	sp, sp, #72	; 0x48
    8280:	e50b0048 	str	r0, [fp, #-72]	; 0xffffffb8
    8284:	e50b104c 	str	r1, [fp, #-76]	; 0xffffffb4
/home/schenkj/os2022/sp/sources/userspace/logger_task/main.cpp:20
	uint32_t uart_file = open("DEV:uart/0", NFile_Open_Mode::Write_Only);
    8288:	e3a01001 	mov	r1, #1
    828c:	e59f010c 	ldr	r0, [pc, #268]	; 83a0 <main+0x12c>
    8290:	eb000065 	bl	842c <_Z4openPKc15NFile_Open_Mode>
    8294:	e50b0008 	str	r0, [fp, #-8]
/home/schenkj/os2022/sp/sources/userspace/logger_task/main.cpp:23

	TUART_IOCtl_Params params;
	params.baud_rate = NUART_Baud_Rate::BR_115200;
    8298:	e59f3104 	ldr	r3, [pc, #260]	; 83a4 <main+0x130>
    829c:	e50b301c 	str	r3, [fp, #-28]	; 0xffffffe4
/home/schenkj/os2022/sp/sources/userspace/logger_task/main.cpp:24
	params.char_length = NUART_Char_Length::Char_8;
    82a0:	e3a03001 	mov	r3, #1
    82a4:	e50b3020 	str	r3, [fp, #-32]	; 0xffffffe0
/home/schenkj/os2022/sp/sources/userspace/logger_task/main.cpp:25
	ioctl(uart_file, NIOCtl_Operation::Set_Params, &params);
    82a8:	e24b3020 	sub	r3, fp, #32
    82ac:	e1a02003 	mov	r2, r3
    82b0:	e3a01001 	mov	r1, #1
    82b4:	e51b0008 	ldr	r0, [fp, #-8]
    82b8:	eb00009f 	bl	853c <_Z5ioctlj16NIOCtl_OperationPv>
/home/schenkj/os2022/sp/sources/userspace/logger_task/main.cpp:27

	fputs(uart_file, "UART task starting!");
    82bc:	e59f10e4 	ldr	r1, [pc, #228]	; 83a8 <main+0x134>
    82c0:	e51b0008 	ldr	r0, [fp, #-8]
    82c4:	ebffffdb 	bl	8238 <_ZL5fputsjPKc>
/home/schenkj/os2022/sp/sources/userspace/logger_task/main.cpp:31

	char buf[16];
	char tickbuf[16];
	bzero(buf, 16);
    82c8:	e24b3030 	sub	r3, fp, #48	; 0x30
    82cc:	e3a01010 	mov	r1, #16
    82d0:	e1a00003 	mov	r0, r3
    82d4:	eb000242 	bl	8be4 <_Z5bzeroPvi>
/home/schenkj/os2022/sp/sources/userspace/logger_task/main.cpp:32
	bzero(tickbuf, 16);
    82d8:	e24b3040 	sub	r3, fp, #64	; 0x40
    82dc:	e3a01010 	mov	r1, #16
    82e0:	e1a00003 	mov	r0, r3
    82e4:	eb00023e 	bl	8be4 <_Z5bzeroPvi>
/home/schenkj/os2022/sp/sources/userspace/logger_task/main.cpp:34

	uint32_t last_tick = 0;
    82e8:	e3a03000 	mov	r3, #0
    82ec:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/userspace/logger_task/main.cpp:36

	uint32_t logpipe = pipe("log", 32);
    82f0:	e3a01020 	mov	r1, #32
    82f4:	e59f00b0 	ldr	r0, [pc, #176]	; 83ac <main+0x138>
    82f8:	eb000119 	bl	8764 <_Z4pipePKcj>
    82fc:	e50b0010 	str	r0, [fp, #-16]
/home/schenkj/os2022/sp/sources/userspace/logger_task/main.cpp:40

	while (true)
	{
		wait(logpipe, 1, 0x1000);
    8300:	e3a02a01 	mov	r2, #4096	; 0x1000
    8304:	e3a01001 	mov	r1, #1
    8308:	e51b0010 	ldr	r0, [fp, #-16]
    830c:	eb0000af 	bl	85d0 <_Z4waitjjj>
/home/schenkj/os2022/sp/sources/userspace/logger_task/main.cpp:42

		uint32_t v = read(logpipe, buf, 15);
    8310:	e24b3030 	sub	r3, fp, #48	; 0x30
    8314:	e3a0200f 	mov	r2, #15
    8318:	e1a01003 	mov	r1, r3
    831c:	e51b0010 	ldr	r0, [fp, #-16]
    8320:	eb000052 	bl	8470 <_Z4readjPcj>
    8324:	e50b0014 	str	r0, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/userspace/logger_task/main.cpp:43
		if (v > 0)
    8328:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    832c:	e3530000 	cmp	r3, #0
    8330:	0afffff2 	beq	8300 <main+0x8c>
/home/schenkj/os2022/sp/sources/userspace/logger_task/main.cpp:45
		{
			buf[v] = '\0';
    8334:	e24b2030 	sub	r2, fp, #48	; 0x30
    8338:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    833c:	e0823003 	add	r3, r2, r3
    8340:	e3a02000 	mov	r2, #0
    8344:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/userspace/logger_task/main.cpp:46
			fputs(uart_file, "\r\n[ ");
    8348:	e59f1060 	ldr	r1, [pc, #96]	; 83b0 <main+0x13c>
    834c:	e51b0008 	ldr	r0, [fp, #-8]
    8350:	ebffffb8 	bl	8238 <_ZL5fputsjPKc>
/home/schenkj/os2022/sp/sources/userspace/logger_task/main.cpp:47
			uint32_t tick = get_tick_count();
    8354:	eb0000d5 	bl	86b0 <_Z14get_tick_countv>
    8358:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/userspace/logger_task/main.cpp:48
			itoa(tick, tickbuf, 16);
    835c:	e24b3040 	sub	r3, fp, #64	; 0x40
    8360:	e3a02010 	mov	r2, #16
    8364:	e1a01003 	mov	r1, r3
    8368:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    836c:	eb000128 	bl	8814 <_Z4itoajPcj>
/home/schenkj/os2022/sp/sources/userspace/logger_task/main.cpp:49
			fputs(uart_file, tickbuf);
    8370:	e24b3040 	sub	r3, fp, #64	; 0x40
    8374:	e1a01003 	mov	r1, r3
    8378:	e51b0008 	ldr	r0, [fp, #-8]
    837c:	ebffffad 	bl	8238 <_ZL5fputsjPKc>
/home/schenkj/os2022/sp/sources/userspace/logger_task/main.cpp:50
			fputs(uart_file, "]: ");
    8380:	e59f102c 	ldr	r1, [pc, #44]	; 83b4 <main+0x140>
    8384:	e51b0008 	ldr	r0, [fp, #-8]
    8388:	ebffffaa 	bl	8238 <_ZL5fputsjPKc>
/home/schenkj/os2022/sp/sources/userspace/logger_task/main.cpp:51
			fputs(uart_file, buf);
    838c:	e24b3030 	sub	r3, fp, #48	; 0x30
    8390:	e1a01003 	mov	r1, r3
    8394:	e51b0008 	ldr	r0, [fp, #-8]
    8398:	ebffffa6 	bl	8238 <_ZL5fputsjPKc>
/home/schenkj/os2022/sp/sources/userspace/logger_task/main.cpp:53
		}
	}
    839c:	eaffffd7 	b	8300 <main+0x8c>
    83a0:	00008f08 	andeq	r8, r0, r8, lsl #30
    83a4:	0001c200 	andeq	ip, r1, r0, lsl #4
    83a8:	00008f14 	andeq	r8, r0, r4, lsl pc
    83ac:	00008f28 	andeq	r8, r0, r8, lsr #30
    83b0:	00008f2c 	andeq	r8, r0, ip, lsr #30
    83b4:	00008f34 	andeq	r8, r0, r4, lsr pc

000083b8 <_Z6getpidv>:
_Z6getpidv():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:5
#include <stdfile.h>
#include <stdstring.h>

uint32_t getpid()
{
    83b8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83bc:	e28db000 	add	fp, sp, #0
    83c0:	e24dd00c 	sub	sp, sp, #12
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:8
    uint32_t pid;

    asm volatile("swi 0");
    83c4:	ef000000 	svc	0x00000000
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:9
    asm volatile("mov %0, r0" : "=r" (pid));
    83c8:	e1a03000 	mov	r3, r0
    83cc:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:11

    return pid;
    83d0:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:12
}
    83d4:	e1a00003 	mov	r0, r3
    83d8:	e28bd000 	add	sp, fp, #0
    83dc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83e0:	e12fff1e 	bx	lr

000083e4 <_Z9terminatei>:
_Z9terminatei():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:15

void terminate(int exitcode)
{
    83e4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83e8:	e28db000 	add	fp, sp, #0
    83ec:	e24dd00c 	sub	sp, sp, #12
    83f0:	e50b0008 	str	r0, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:16
    asm volatile("mov r0, %0" : : "r" (exitcode));
    83f4:	e51b3008 	ldr	r3, [fp, #-8]
    83f8:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:17
    asm volatile("swi 1");
    83fc:	ef000001 	svc	0x00000001
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:18
}
    8400:	e320f000 	nop	{0}
    8404:	e28bd000 	add	sp, fp, #0
    8408:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    840c:	e12fff1e 	bx	lr

00008410 <_Z11sched_yieldv>:
_Z11sched_yieldv():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:21

void sched_yield()
{
    8410:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8414:	e28db000 	add	fp, sp, #0
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:22
    asm volatile("swi 2");
    8418:	ef000002 	svc	0x00000002
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:23
}
    841c:	e320f000 	nop	{0}
    8420:	e28bd000 	add	sp, fp, #0
    8424:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8428:	e12fff1e 	bx	lr

0000842c <_Z4openPKc15NFile_Open_Mode>:
_Z4openPKc15NFile_Open_Mode():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:26

uint32_t open(const char* filename, NFile_Open_Mode mode)
{
    842c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8430:	e28db000 	add	fp, sp, #0
    8434:	e24dd014 	sub	sp, sp, #20
    8438:	e50b0010 	str	r0, [fp, #-16]
    843c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:29
    uint32_t file;

    asm volatile("mov r0, %0" : : "r" (filename));
    8440:	e51b3010 	ldr	r3, [fp, #-16]
    8444:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:30
    asm volatile("mov r1, %0" : : "r" (mode));
    8448:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    844c:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:31
    asm volatile("swi 64");
    8450:	ef000040 	svc	0x00000040
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:32
    asm volatile("mov %0, r0" : "=r" (file));
    8454:	e1a03000 	mov	r3, r0
    8458:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:34

    return file;
    845c:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:35
}
    8460:	e1a00003 	mov	r0, r3
    8464:	e28bd000 	add	sp, fp, #0
    8468:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    846c:	e12fff1e 	bx	lr

00008470 <_Z4readjPcj>:
_Z4readjPcj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:38

uint32_t read(uint32_t file, char* const buffer, uint32_t size)
{
    8470:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8474:	e28db000 	add	fp, sp, #0
    8478:	e24dd01c 	sub	sp, sp, #28
    847c:	e50b0010 	str	r0, [fp, #-16]
    8480:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8484:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:41
    uint32_t rdnum;

    asm volatile("mov r0, %0" : : "r" (file));
    8488:	e51b3010 	ldr	r3, [fp, #-16]
    848c:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:42
    asm volatile("mov r1, %0" : : "r" (buffer));
    8490:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8494:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:43
    asm volatile("mov r2, %0" : : "r" (size));
    8498:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    849c:	e1a02003 	mov	r2, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:44
    asm volatile("swi 65");
    84a0:	ef000041 	svc	0x00000041
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:45
    asm volatile("mov %0, r0" : "=r" (rdnum));
    84a4:	e1a03000 	mov	r3, r0
    84a8:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:47

    return rdnum;
    84ac:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:48
}
    84b0:	e1a00003 	mov	r0, r3
    84b4:	e28bd000 	add	sp, fp, #0
    84b8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    84bc:	e12fff1e 	bx	lr

000084c0 <_Z5writejPKcj>:
_Z5writejPKcj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:51

uint32_t write(uint32_t file, const char* buffer, uint32_t size)
{
    84c0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    84c4:	e28db000 	add	fp, sp, #0
    84c8:	e24dd01c 	sub	sp, sp, #28
    84cc:	e50b0010 	str	r0, [fp, #-16]
    84d0:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    84d4:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:54
    uint32_t wrnum;

    asm volatile("mov r0, %0" : : "r" (file));
    84d8:	e51b3010 	ldr	r3, [fp, #-16]
    84dc:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:55
    asm volatile("mov r1, %0" : : "r" (buffer));
    84e0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84e4:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:56
    asm volatile("mov r2, %0" : : "r" (size));
    84e8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    84ec:	e1a02003 	mov	r2, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:57
    asm volatile("swi 66");
    84f0:	ef000042 	svc	0x00000042
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:58
    asm volatile("mov %0, r0" : "=r" (wrnum));
    84f4:	e1a03000 	mov	r3, r0
    84f8:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:60

    return wrnum;
    84fc:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:61
}
    8500:	e1a00003 	mov	r0, r3
    8504:	e28bd000 	add	sp, fp, #0
    8508:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    850c:	e12fff1e 	bx	lr

00008510 <_Z5closej>:
_Z5closej():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:64

void close(uint32_t file)
{
    8510:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8514:	e28db000 	add	fp, sp, #0
    8518:	e24dd00c 	sub	sp, sp, #12
    851c:	e50b0008 	str	r0, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:65
    asm volatile("mov r0, %0" : : "r" (file));
    8520:	e51b3008 	ldr	r3, [fp, #-8]
    8524:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:66
    asm volatile("swi 67");
    8528:	ef000043 	svc	0x00000043
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:67
}
    852c:	e320f000 	nop	{0}
    8530:	e28bd000 	add	sp, fp, #0
    8534:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8538:	e12fff1e 	bx	lr

0000853c <_Z5ioctlj16NIOCtl_OperationPv>:
_Z5ioctlj16NIOCtl_OperationPv():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:70

uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param)
{
    853c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8540:	e28db000 	add	fp, sp, #0
    8544:	e24dd01c 	sub	sp, sp, #28
    8548:	e50b0010 	str	r0, [fp, #-16]
    854c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8550:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:73
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    8554:	e51b3010 	ldr	r3, [fp, #-16]
    8558:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:74
    asm volatile("mov r1, %0" : : "r" (operation));
    855c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8560:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:75
    asm volatile("mov r2, %0" : : "r" (param));
    8564:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8568:	e1a02003 	mov	r2, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:76
    asm volatile("swi 68");
    856c:	ef000044 	svc	0x00000044
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:77
    asm volatile("mov %0, r0" : "=r" (retcode));
    8570:	e1a03000 	mov	r3, r0
    8574:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:79

    return retcode;
    8578:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:80
}
    857c:	e1a00003 	mov	r0, r3
    8580:	e28bd000 	add	sp, fp, #0
    8584:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8588:	e12fff1e 	bx	lr

0000858c <_Z6notifyjj>:
_Z6notifyjj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:83

uint32_t notify(uint32_t file, uint32_t count)
{
    858c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8590:	e28db000 	add	fp, sp, #0
    8594:	e24dd014 	sub	sp, sp, #20
    8598:	e50b0010 	str	r0, [fp, #-16]
    859c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:86
    uint32_t retcnt;

    asm volatile("mov r0, %0" : : "r" (file));
    85a0:	e51b3010 	ldr	r3, [fp, #-16]
    85a4:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:87
    asm volatile("mov r1, %0" : : "r" (count));
    85a8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    85ac:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:88
    asm volatile("swi 69");
    85b0:	ef000045 	svc	0x00000045
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:89
    asm volatile("mov %0, r0" : "=r" (retcnt));
    85b4:	e1a03000 	mov	r3, r0
    85b8:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:91

    return retcnt;
    85bc:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:92
}
    85c0:	e1a00003 	mov	r0, r3
    85c4:	e28bd000 	add	sp, fp, #0
    85c8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85cc:	e12fff1e 	bx	lr

000085d0 <_Z4waitjjj>:
_Z4waitjjj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:95

NSWI_Result_Code wait(uint32_t file, uint32_t count, uint32_t notified_deadline)
{
    85d0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85d4:	e28db000 	add	fp, sp, #0
    85d8:	e24dd01c 	sub	sp, sp, #28
    85dc:	e50b0010 	str	r0, [fp, #-16]
    85e0:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    85e4:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:98
    NSWI_Result_Code retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    85e8:	e51b3010 	ldr	r3, [fp, #-16]
    85ec:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:99
    asm volatile("mov r1, %0" : : "r" (count));
    85f0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    85f4:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:100
    asm volatile("mov r2, %0" : : "r" (notified_deadline));
    85f8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    85fc:	e1a02003 	mov	r2, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:101
    asm volatile("swi 70");
    8600:	ef000046 	svc	0x00000046
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:102
    asm volatile("mov %0, r0" : "=r" (retcode));
    8604:	e1a03000 	mov	r3, r0
    8608:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:104

    return retcode;
    860c:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:105
}
    8610:	e1a00003 	mov	r0, r3
    8614:	e28bd000 	add	sp, fp, #0
    8618:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    861c:	e12fff1e 	bx	lr

00008620 <_Z5sleepjj>:
_Z5sleepjj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:108

bool sleep(uint32_t ticks, uint32_t notified_deadline)
{
    8620:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8624:	e28db000 	add	fp, sp, #0
    8628:	e24dd014 	sub	sp, sp, #20
    862c:	e50b0010 	str	r0, [fp, #-16]
    8630:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:111
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (ticks));
    8634:	e51b3010 	ldr	r3, [fp, #-16]
    8638:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:112
    asm volatile("mov r1, %0" : : "r" (notified_deadline));
    863c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8640:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:113
    asm volatile("swi 3");
    8644:	ef000003 	svc	0x00000003
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:114
    asm volatile("mov %0, r0" : "=r" (retcode));
    8648:	e1a03000 	mov	r3, r0
    864c:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:116

    return retcode;
    8650:	e51b3008 	ldr	r3, [fp, #-8]
    8654:	e3530000 	cmp	r3, #0
    8658:	13a03001 	movne	r3, #1
    865c:	03a03000 	moveq	r3, #0
    8660:	e6ef3073 	uxtb	r3, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:117
}
    8664:	e1a00003 	mov	r0, r3
    8668:	e28bd000 	add	sp, fp, #0
    866c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8670:	e12fff1e 	bx	lr

00008674 <_Z24get_active_process_countv>:
_Z24get_active_process_countv():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:120

uint32_t get_active_process_count()
{
    8674:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8678:	e28db000 	add	fp, sp, #0
    867c:	e24dd00c 	sub	sp, sp, #12
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:121
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Active_Process_Count;
    8680:	e3a03000 	mov	r3, #0
    8684:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:124
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    8688:	e3a03000 	mov	r3, #0
    868c:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:125
    asm volatile("mov r1, %0" : : "r" (&retval));
    8690:	e24b300c 	sub	r3, fp, #12
    8694:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:126
    asm volatile("swi 4");
    8698:	ef000004 	svc	0x00000004
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:128

    return retval;
    869c:	e51b300c 	ldr	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:129
}
    86a0:	e1a00003 	mov	r0, r3
    86a4:	e28bd000 	add	sp, fp, #0
    86a8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86ac:	e12fff1e 	bx	lr

000086b0 <_Z14get_tick_countv>:
_Z14get_tick_countv():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:132

uint32_t get_tick_count()
{
    86b0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    86b4:	e28db000 	add	fp, sp, #0
    86b8:	e24dd00c 	sub	sp, sp, #12
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:133
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Tick_Count;
    86bc:	e3a03001 	mov	r3, #1
    86c0:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:136
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    86c4:	e3a03001 	mov	r3, #1
    86c8:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:137
    asm volatile("mov r1, %0" : : "r" (&retval));
    86cc:	e24b300c 	sub	r3, fp, #12
    86d0:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:138
    asm volatile("swi 4");
    86d4:	ef000004 	svc	0x00000004
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:140

    return retval;
    86d8:	e51b300c 	ldr	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:141
}
    86dc:	e1a00003 	mov	r0, r3
    86e0:	e28bd000 	add	sp, fp, #0
    86e4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86e8:	e12fff1e 	bx	lr

000086ec <_Z17set_task_deadlinej>:
_Z17set_task_deadlinej():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:144

void set_task_deadline(uint32_t tick_count_required)
{
    86ec:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    86f0:	e28db000 	add	fp, sp, #0
    86f4:	e24dd014 	sub	sp, sp, #20
    86f8:	e50b0010 	str	r0, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:145
    const NDeadline_Subservice req = NDeadline_Subservice::Set_Relative;
    86fc:	e3a03000 	mov	r3, #0
    8700:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:147

    asm volatile("mov r0, %0" : : "r" (req));
    8704:	e3a03000 	mov	r3, #0
    8708:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:148
    asm volatile("mov r1, %0" : : "r" (&tick_count_required));
    870c:	e24b3010 	sub	r3, fp, #16
    8710:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:149
    asm volatile("swi 5");
    8714:	ef000005 	svc	0x00000005
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:150
}
    8718:	e320f000 	nop	{0}
    871c:	e28bd000 	add	sp, fp, #0
    8720:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8724:	e12fff1e 	bx	lr

00008728 <_Z26get_task_ticks_to_deadlinev>:
_Z26get_task_ticks_to_deadlinev():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:153

uint32_t get_task_ticks_to_deadline()
{
    8728:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    872c:	e28db000 	add	fp, sp, #0
    8730:	e24dd00c 	sub	sp, sp, #12
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:154
    const NDeadline_Subservice req = NDeadline_Subservice::Get_Remaining;
    8734:	e3a03001 	mov	r3, #1
    8738:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:157
    uint32_t ticks;

    asm volatile("mov r0, %0" : : "r" (req));
    873c:	e3a03001 	mov	r3, #1
    8740:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:158
    asm volatile("mov r1, %0" : : "r" (&ticks));
    8744:	e24b300c 	sub	r3, fp, #12
    8748:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:159
    asm volatile("swi 5");
    874c:	ef000005 	svc	0x00000005
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:161

    return ticks;
    8750:	e51b300c 	ldr	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:162
}
    8754:	e1a00003 	mov	r0, r3
    8758:	e28bd000 	add	sp, fp, #0
    875c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8760:	e12fff1e 	bx	lr

00008764 <_Z4pipePKcj>:
_Z4pipePKcj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:167

const char Pipe_File_Prefix[] = "SYS:pipe/";

uint32_t pipe(const char* name, uint32_t buf_size)
{
    8764:	e92d4800 	push	{fp, lr}
    8768:	e28db004 	add	fp, sp, #4
    876c:	e24dd050 	sub	sp, sp, #80	; 0x50
    8770:	e50b0050 	str	r0, [fp, #-80]	; 0xffffffb0
    8774:	e50b1054 	str	r1, [fp, #-84]	; 0xffffffac
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:169
    char fname[64];
    strncpy(fname, Pipe_File_Prefix, sizeof(Pipe_File_Prefix));
    8778:	e24b3048 	sub	r3, fp, #72	; 0x48
    877c:	e3a0200a 	mov	r2, #10
    8780:	e59f1088 	ldr	r1, [pc, #136]	; 8810 <_Z4pipePKcj+0xac>
    8784:	e1a00003 	mov	r0, r3
    8788:	eb0000a5 	bl	8a24 <_Z7strncpyPcPKci>
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:170
    strncpy(fname + sizeof(Pipe_File_Prefix), name, sizeof(fname) - sizeof(Pipe_File_Prefix) - 1);
    878c:	e24b3048 	sub	r3, fp, #72	; 0x48
    8790:	e283300a 	add	r3, r3, #10
    8794:	e3a02035 	mov	r2, #53	; 0x35
    8798:	e51b1050 	ldr	r1, [fp, #-80]	; 0xffffffb0
    879c:	e1a00003 	mov	r0, r3
    87a0:	eb00009f 	bl	8a24 <_Z7strncpyPcPKci>
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:172

    int ncur = sizeof(Pipe_File_Prefix) + strlen(name);
    87a4:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    87a8:	eb0000f8 	bl	8b90 <_Z6strlenPKc>
    87ac:	e1a03000 	mov	r3, r0
    87b0:	e283300a 	add	r3, r3, #10
    87b4:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:174

    fname[ncur++] = '#';
    87b8:	e51b3008 	ldr	r3, [fp, #-8]
    87bc:	e2832001 	add	r2, r3, #1
    87c0:	e50b2008 	str	r2, [fp, #-8]
    87c4:	e24b2004 	sub	r2, fp, #4
    87c8:	e0823003 	add	r3, r2, r3
    87cc:	e3a02023 	mov	r2, #35	; 0x23
    87d0:	e5432044 	strb	r2, [r3, #-68]	; 0xffffffbc
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:176

    itoa(buf_size, &fname[ncur], 10);
    87d4:	e24b2048 	sub	r2, fp, #72	; 0x48
    87d8:	e51b3008 	ldr	r3, [fp, #-8]
    87dc:	e0823003 	add	r3, r2, r3
    87e0:	e3a0200a 	mov	r2, #10
    87e4:	e1a01003 	mov	r1, r3
    87e8:	e51b0054 	ldr	r0, [fp, #-84]	; 0xffffffac
    87ec:	eb000008 	bl	8814 <_Z4itoajPcj>
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:178

    return open(fname, NFile_Open_Mode::Read_Write);
    87f0:	e24b3048 	sub	r3, fp, #72	; 0x48
    87f4:	e3a01002 	mov	r1, #2
    87f8:	e1a00003 	mov	r0, r3
    87fc:	ebffff0a 	bl	842c <_Z4openPKc15NFile_Open_Mode>
    8800:	e1a03000 	mov	r3, r0
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:179
}
    8804:	e1a00003 	mov	r0, r3
    8808:	e24bd004 	sub	sp, fp, #4
    880c:	e8bd8800 	pop	{fp, pc}
    8810:	00008f64 	andeq	r8, r0, r4, ror #30

00008814 <_Z4itoajPcj>:
_Z4itoajPcj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:9
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(unsigned int input, char* output, unsigned int base)
{
    8814:	e92d4800 	push	{fp, lr}
    8818:	e28db004 	add	fp, sp, #4
    881c:	e24dd020 	sub	sp, sp, #32
    8820:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8824:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8828:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:10
	int i = 0;
    882c:	e3a03000 	mov	r3, #0
    8830:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:12

	while (input > 0)
    8834:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8838:	e3530000 	cmp	r3, #0
    883c:	0a000014 	beq	8894 <_Z4itoajPcj+0x80>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:14
	{
		output[i] = CharConvArr[input % base];
    8840:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8844:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    8848:	e1a00003 	mov	r0, r3
    884c:	eb000199 	bl	8eb8 <__aeabi_uidivmod>
    8850:	e1a03001 	mov	r3, r1
    8854:	e1a01003 	mov	r1, r3
    8858:	e51b3008 	ldr	r3, [fp, #-8]
    885c:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8860:	e0823003 	add	r3, r2, r3
    8864:	e59f2118 	ldr	r2, [pc, #280]	; 8984 <_Z4itoajPcj+0x170>
    8868:	e7d22001 	ldrb	r2, [r2, r1]
    886c:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:15
		input /= base;
    8870:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    8874:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8878:	eb000113 	bl	8ccc <__udivsi3>
    887c:	e1a03000 	mov	r3, r0
    8880:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:16
		i++;
    8884:	e51b3008 	ldr	r3, [fp, #-8]
    8888:	e2833001 	add	r3, r3, #1
    888c:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:12
	while (input > 0)
    8890:	eaffffe7 	b	8834 <_Z4itoajPcj+0x20>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:19
	}

    if (i == 0)
    8894:	e51b3008 	ldr	r3, [fp, #-8]
    8898:	e3530000 	cmp	r3, #0
    889c:	1a000007 	bne	88c0 <_Z4itoajPcj+0xac>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:21
    {
        output[i] = CharConvArr[0];
    88a0:	e51b3008 	ldr	r3, [fp, #-8]
    88a4:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    88a8:	e0823003 	add	r3, r2, r3
    88ac:	e3a02030 	mov	r2, #48	; 0x30
    88b0:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:22
        i++;
    88b4:	e51b3008 	ldr	r3, [fp, #-8]
    88b8:	e2833001 	add	r3, r3, #1
    88bc:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:25
    }

	output[i] = '\0';
    88c0:	e51b3008 	ldr	r3, [fp, #-8]
    88c4:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    88c8:	e0823003 	add	r3, r2, r3
    88cc:	e3a02000 	mov	r2, #0
    88d0:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:26
	i--;
    88d4:	e51b3008 	ldr	r3, [fp, #-8]
    88d8:	e2433001 	sub	r3, r3, #1
    88dc:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:28

	for (int j = 0; j <= i/2; j++)
    88e0:	e3a03000 	mov	r3, #0
    88e4:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:28 (discriminator 3)
    88e8:	e51b3008 	ldr	r3, [fp, #-8]
    88ec:	e1a02fa3 	lsr	r2, r3, #31
    88f0:	e0823003 	add	r3, r2, r3
    88f4:	e1a030c3 	asr	r3, r3, #1
    88f8:	e1a02003 	mov	r2, r3
    88fc:	e51b300c 	ldr	r3, [fp, #-12]
    8900:	e1530002 	cmp	r3, r2
    8904:	ca00001b 	bgt	8978 <_Z4itoajPcj+0x164>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:30 (discriminator 2)
	{
		char c = output[i - j];
    8908:	e51b2008 	ldr	r2, [fp, #-8]
    890c:	e51b300c 	ldr	r3, [fp, #-12]
    8910:	e0423003 	sub	r3, r2, r3
    8914:	e1a02003 	mov	r2, r3
    8918:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    891c:	e0833002 	add	r3, r3, r2
    8920:	e5d33000 	ldrb	r3, [r3]
    8924:	e54b300d 	strb	r3, [fp, #-13]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:31 (discriminator 2)
		output[i - j] = output[j];
    8928:	e51b300c 	ldr	r3, [fp, #-12]
    892c:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8930:	e0822003 	add	r2, r2, r3
    8934:	e51b1008 	ldr	r1, [fp, #-8]
    8938:	e51b300c 	ldr	r3, [fp, #-12]
    893c:	e0413003 	sub	r3, r1, r3
    8940:	e1a01003 	mov	r1, r3
    8944:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8948:	e0833001 	add	r3, r3, r1
    894c:	e5d22000 	ldrb	r2, [r2]
    8950:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:32 (discriminator 2)
		output[j] = c;
    8954:	e51b300c 	ldr	r3, [fp, #-12]
    8958:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    895c:	e0823003 	add	r3, r2, r3
    8960:	e55b200d 	ldrb	r2, [fp, #-13]
    8964:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:28 (discriminator 2)
	for (int j = 0; j <= i/2; j++)
    8968:	e51b300c 	ldr	r3, [fp, #-12]
    896c:	e2833001 	add	r3, r3, #1
    8970:	e50b300c 	str	r3, [fp, #-12]
    8974:	eaffffdb 	b	88e8 <_Z4itoajPcj+0xd4>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:34
	}
}
    8978:	e320f000 	nop	{0}
    897c:	e24bd004 	sub	sp, fp, #4
    8980:	e8bd8800 	pop	{fp, pc}
    8984:	00008f70 	andeq	r8, r0, r0, ror pc

00008988 <_Z4atoiPKc>:
_Z4atoiPKc():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:37

int atoi(const char* input)
{
    8988:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    898c:	e28db000 	add	fp, sp, #0
    8990:	e24dd014 	sub	sp, sp, #20
    8994:	e50b0010 	str	r0, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:38
	int output = 0;
    8998:	e3a03000 	mov	r3, #0
    899c:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:40

	while (*input != '\0')
    89a0:	e51b3010 	ldr	r3, [fp, #-16]
    89a4:	e5d33000 	ldrb	r3, [r3]
    89a8:	e3530000 	cmp	r3, #0
    89ac:	0a000017 	beq	8a10 <_Z4atoiPKc+0x88>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:42
	{
		output *= 10;
    89b0:	e51b2008 	ldr	r2, [fp, #-8]
    89b4:	e1a03002 	mov	r3, r2
    89b8:	e1a03103 	lsl	r3, r3, #2
    89bc:	e0833002 	add	r3, r3, r2
    89c0:	e1a03083 	lsl	r3, r3, #1
    89c4:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:43
		if (*input > '9' || *input < '0')
    89c8:	e51b3010 	ldr	r3, [fp, #-16]
    89cc:	e5d33000 	ldrb	r3, [r3]
    89d0:	e3530039 	cmp	r3, #57	; 0x39
    89d4:	8a00000d 	bhi	8a10 <_Z4atoiPKc+0x88>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:43 (discriminator 1)
    89d8:	e51b3010 	ldr	r3, [fp, #-16]
    89dc:	e5d33000 	ldrb	r3, [r3]
    89e0:	e353002f 	cmp	r3, #47	; 0x2f
    89e4:	9a000009 	bls	8a10 <_Z4atoiPKc+0x88>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:46
			break;

		output += *input - '0';
    89e8:	e51b3010 	ldr	r3, [fp, #-16]
    89ec:	e5d33000 	ldrb	r3, [r3]
    89f0:	e2433030 	sub	r3, r3, #48	; 0x30
    89f4:	e51b2008 	ldr	r2, [fp, #-8]
    89f8:	e0823003 	add	r3, r2, r3
    89fc:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:48

		input++;
    8a00:	e51b3010 	ldr	r3, [fp, #-16]
    8a04:	e2833001 	add	r3, r3, #1
    8a08:	e50b3010 	str	r3, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:40
	while (*input != '\0')
    8a0c:	eaffffe3 	b	89a0 <_Z4atoiPKc+0x18>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:51
	}

	return output;
    8a10:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:52
}
    8a14:	e1a00003 	mov	r0, r3
    8a18:	e28bd000 	add	sp, fp, #0
    8a1c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8a20:	e12fff1e 	bx	lr

00008a24 <_Z7strncpyPcPKci>:
_Z7strncpyPcPKci():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:55

char* strncpy(char* dest, const char *src, int num)
{
    8a24:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8a28:	e28db000 	add	fp, sp, #0
    8a2c:	e24dd01c 	sub	sp, sp, #28
    8a30:	e50b0010 	str	r0, [fp, #-16]
    8a34:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8a38:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:58
	int i;

	for (i = 0; i < num && src[i] != '\0'; i++)
    8a3c:	e3a03000 	mov	r3, #0
    8a40:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:58 (discriminator 4)
    8a44:	e51b2008 	ldr	r2, [fp, #-8]
    8a48:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8a4c:	e1520003 	cmp	r2, r3
    8a50:	aa000011 	bge	8a9c <_Z7strncpyPcPKci+0x78>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:58 (discriminator 2)
    8a54:	e51b3008 	ldr	r3, [fp, #-8]
    8a58:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8a5c:	e0823003 	add	r3, r2, r3
    8a60:	e5d33000 	ldrb	r3, [r3]
    8a64:	e3530000 	cmp	r3, #0
    8a68:	0a00000b 	beq	8a9c <_Z7strncpyPcPKci+0x78>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:59 (discriminator 3)
		dest[i] = src[i];
    8a6c:	e51b3008 	ldr	r3, [fp, #-8]
    8a70:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8a74:	e0822003 	add	r2, r2, r3
    8a78:	e51b3008 	ldr	r3, [fp, #-8]
    8a7c:	e51b1010 	ldr	r1, [fp, #-16]
    8a80:	e0813003 	add	r3, r1, r3
    8a84:	e5d22000 	ldrb	r2, [r2]
    8a88:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:58 (discriminator 3)
	for (i = 0; i < num && src[i] != '\0'; i++)
    8a8c:	e51b3008 	ldr	r3, [fp, #-8]
    8a90:	e2833001 	add	r3, r3, #1
    8a94:	e50b3008 	str	r3, [fp, #-8]
    8a98:	eaffffe9 	b	8a44 <_Z7strncpyPcPKci+0x20>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:60 (discriminator 2)
	for (; i < num; i++)
    8a9c:	e51b2008 	ldr	r2, [fp, #-8]
    8aa0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8aa4:	e1520003 	cmp	r2, r3
    8aa8:	aa000008 	bge	8ad0 <_Z7strncpyPcPKci+0xac>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:61 (discriminator 1)
		dest[i] = '\0';
    8aac:	e51b3008 	ldr	r3, [fp, #-8]
    8ab0:	e51b2010 	ldr	r2, [fp, #-16]
    8ab4:	e0823003 	add	r3, r2, r3
    8ab8:	e3a02000 	mov	r2, #0
    8abc:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:60 (discriminator 1)
	for (; i < num; i++)
    8ac0:	e51b3008 	ldr	r3, [fp, #-8]
    8ac4:	e2833001 	add	r3, r3, #1
    8ac8:	e50b3008 	str	r3, [fp, #-8]
    8acc:	eafffff2 	b	8a9c <_Z7strncpyPcPKci+0x78>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:63

   return dest;
    8ad0:	e51b3010 	ldr	r3, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:64
}
    8ad4:	e1a00003 	mov	r0, r3
    8ad8:	e28bd000 	add	sp, fp, #0
    8adc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8ae0:	e12fff1e 	bx	lr

00008ae4 <_Z7strncmpPKcS0_i>:
_Z7strncmpPKcS0_i():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:67

int strncmp(const char *s1, const char *s2, int num)
{
    8ae4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8ae8:	e28db000 	add	fp, sp, #0
    8aec:	e24dd01c 	sub	sp, sp, #28
    8af0:	e50b0010 	str	r0, [fp, #-16]
    8af4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8af8:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:69
	unsigned char u1, u2;
  	while (num-- > 0)
    8afc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8b00:	e2432001 	sub	r2, r3, #1
    8b04:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    8b08:	e3530000 	cmp	r3, #0
    8b0c:	c3a03001 	movgt	r3, #1
    8b10:	d3a03000 	movle	r3, #0
    8b14:	e6ef3073 	uxtb	r3, r3
    8b18:	e3530000 	cmp	r3, #0
    8b1c:	0a000016 	beq	8b7c <_Z7strncmpPKcS0_i+0x98>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:71
    {
      	u1 = (unsigned char) *s1++;
    8b20:	e51b3010 	ldr	r3, [fp, #-16]
    8b24:	e2832001 	add	r2, r3, #1
    8b28:	e50b2010 	str	r2, [fp, #-16]
    8b2c:	e5d33000 	ldrb	r3, [r3]
    8b30:	e54b3005 	strb	r3, [fp, #-5]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:72
     	u2 = (unsigned char) *s2++;
    8b34:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8b38:	e2832001 	add	r2, r3, #1
    8b3c:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    8b40:	e5d33000 	ldrb	r3, [r3]
    8b44:	e54b3006 	strb	r3, [fp, #-6]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:73
      	if (u1 != u2)
    8b48:	e55b2005 	ldrb	r2, [fp, #-5]
    8b4c:	e55b3006 	ldrb	r3, [fp, #-6]
    8b50:	e1520003 	cmp	r2, r3
    8b54:	0a000003 	beq	8b68 <_Z7strncmpPKcS0_i+0x84>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:74
        	return u1 - u2;
    8b58:	e55b2005 	ldrb	r2, [fp, #-5]
    8b5c:	e55b3006 	ldrb	r3, [fp, #-6]
    8b60:	e0423003 	sub	r3, r2, r3
    8b64:	ea000005 	b	8b80 <_Z7strncmpPKcS0_i+0x9c>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:75
      	if (u1 == '\0')
    8b68:	e55b3005 	ldrb	r3, [fp, #-5]
    8b6c:	e3530000 	cmp	r3, #0
    8b70:	1affffe1 	bne	8afc <_Z7strncmpPKcS0_i+0x18>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:76
        	return 0;
    8b74:	e3a03000 	mov	r3, #0
    8b78:	ea000000 	b	8b80 <_Z7strncmpPKcS0_i+0x9c>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:79
    }

  	return 0;
    8b7c:	e3a03000 	mov	r3, #0
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:80
}
    8b80:	e1a00003 	mov	r0, r3
    8b84:	e28bd000 	add	sp, fp, #0
    8b88:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8b8c:	e12fff1e 	bx	lr

00008b90 <_Z6strlenPKc>:
_Z6strlenPKc():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:83

int strlen(const char* s)
{
    8b90:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8b94:	e28db000 	add	fp, sp, #0
    8b98:	e24dd014 	sub	sp, sp, #20
    8b9c:	e50b0010 	str	r0, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:84
	int i = 0;
    8ba0:	e3a03000 	mov	r3, #0
    8ba4:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:86

	while (s[i] != '\0')
    8ba8:	e51b3008 	ldr	r3, [fp, #-8]
    8bac:	e51b2010 	ldr	r2, [fp, #-16]
    8bb0:	e0823003 	add	r3, r2, r3
    8bb4:	e5d33000 	ldrb	r3, [r3]
    8bb8:	e3530000 	cmp	r3, #0
    8bbc:	0a000003 	beq	8bd0 <_Z6strlenPKc+0x40>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:87
		i++;
    8bc0:	e51b3008 	ldr	r3, [fp, #-8]
    8bc4:	e2833001 	add	r3, r3, #1
    8bc8:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:86
	while (s[i] != '\0')
    8bcc:	eafffff5 	b	8ba8 <_Z6strlenPKc+0x18>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:89

	return i;
    8bd0:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:90
}
    8bd4:	e1a00003 	mov	r0, r3
    8bd8:	e28bd000 	add	sp, fp, #0
    8bdc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8be0:	e12fff1e 	bx	lr

00008be4 <_Z5bzeroPvi>:
_Z5bzeroPvi():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:93

void bzero(void* memory, int length)
{
    8be4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8be8:	e28db000 	add	fp, sp, #0
    8bec:	e24dd014 	sub	sp, sp, #20
    8bf0:	e50b0010 	str	r0, [fp, #-16]
    8bf4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:94
	char* mem = reinterpret_cast<char*>(memory);
    8bf8:	e51b3010 	ldr	r3, [fp, #-16]
    8bfc:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:96

	for (int i = 0; i < length; i++)
    8c00:	e3a03000 	mov	r3, #0
    8c04:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:96 (discriminator 3)
    8c08:	e51b2008 	ldr	r2, [fp, #-8]
    8c0c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8c10:	e1520003 	cmp	r2, r3
    8c14:	aa000008 	bge	8c3c <_Z5bzeroPvi+0x58>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:97 (discriminator 2)
		mem[i] = 0;
    8c18:	e51b3008 	ldr	r3, [fp, #-8]
    8c1c:	e51b200c 	ldr	r2, [fp, #-12]
    8c20:	e0823003 	add	r3, r2, r3
    8c24:	e3a02000 	mov	r2, #0
    8c28:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:96 (discriminator 2)
	for (int i = 0; i < length; i++)
    8c2c:	e51b3008 	ldr	r3, [fp, #-8]
    8c30:	e2833001 	add	r3, r3, #1
    8c34:	e50b3008 	str	r3, [fp, #-8]
    8c38:	eafffff2 	b	8c08 <_Z5bzeroPvi+0x24>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:98
}
    8c3c:	e320f000 	nop	{0}
    8c40:	e28bd000 	add	sp, fp, #0
    8c44:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8c48:	e12fff1e 	bx	lr

00008c4c <_Z6memcpyPKvPvi>:
_Z6memcpyPKvPvi():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:101

void memcpy(const void* src, void* dst, int num)
{
    8c4c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8c50:	e28db000 	add	fp, sp, #0
    8c54:	e24dd024 	sub	sp, sp, #36	; 0x24
    8c58:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8c5c:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8c60:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:102
	const char* memsrc = reinterpret_cast<const char*>(src);
    8c64:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8c68:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:103
	char* memdst = reinterpret_cast<char*>(dst);
    8c6c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8c70:	e50b3010 	str	r3, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:105

	for (int i = 0; i < num; i++)
    8c74:	e3a03000 	mov	r3, #0
    8c78:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:105 (discriminator 3)
    8c7c:	e51b2008 	ldr	r2, [fp, #-8]
    8c80:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8c84:	e1520003 	cmp	r2, r3
    8c88:	aa00000b 	bge	8cbc <_Z6memcpyPKvPvi+0x70>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:106 (discriminator 2)
		memdst[i] = memsrc[i];
    8c8c:	e51b3008 	ldr	r3, [fp, #-8]
    8c90:	e51b200c 	ldr	r2, [fp, #-12]
    8c94:	e0822003 	add	r2, r2, r3
    8c98:	e51b3008 	ldr	r3, [fp, #-8]
    8c9c:	e51b1010 	ldr	r1, [fp, #-16]
    8ca0:	e0813003 	add	r3, r1, r3
    8ca4:	e5d22000 	ldrb	r2, [r2]
    8ca8:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:105 (discriminator 2)
	for (int i = 0; i < num; i++)
    8cac:	e51b3008 	ldr	r3, [fp, #-8]
    8cb0:	e2833001 	add	r3, r3, #1
    8cb4:	e50b3008 	str	r3, [fp, #-8]
    8cb8:	eaffffef 	b	8c7c <_Z6memcpyPKvPvi+0x30>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:107
}
    8cbc:	e320f000 	nop	{0}
    8cc0:	e28bd000 	add	sp, fp, #0
    8cc4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8cc8:	e12fff1e 	bx	lr

00008ccc <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1099
    8ccc:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1101
    8cd0:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1102
    8cd4:	3a000074 	bcc	8eac <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1103
    8cd8:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1104
    8cdc:	9a00006b 	bls	8e90 <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1105
    8ce0:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1106
    8ce4:	0a00006c 	beq	8e9c <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1108
    8ce8:	e16f3f10 	clz	r3, r0
    8cec:	e16f2f11 	clz	r2, r1
    8cf0:	e0423003 	sub	r3, r2, r3
    8cf4:	e273301f 	rsbs	r3, r3, #31
    8cf8:	10833083 	addne	r3, r3, r3, lsl #1
    8cfc:	e3a02000 	mov	r2, #0
    8d00:	108ff103 	addne	pc, pc, r3, lsl #2
    8d04:	e1a00000 	nop			; (mov r0, r0)
    8d08:	e1500f81 	cmp	r0, r1, lsl #31
    8d0c:	e0a22002 	adc	r2, r2, r2
    8d10:	20400f81 	subcs	r0, r0, r1, lsl #31
    8d14:	e1500f01 	cmp	r0, r1, lsl #30
    8d18:	e0a22002 	adc	r2, r2, r2
    8d1c:	20400f01 	subcs	r0, r0, r1, lsl #30
    8d20:	e1500e81 	cmp	r0, r1, lsl #29
    8d24:	e0a22002 	adc	r2, r2, r2
    8d28:	20400e81 	subcs	r0, r0, r1, lsl #29
    8d2c:	e1500e01 	cmp	r0, r1, lsl #28
    8d30:	e0a22002 	adc	r2, r2, r2
    8d34:	20400e01 	subcs	r0, r0, r1, lsl #28
    8d38:	e1500d81 	cmp	r0, r1, lsl #27
    8d3c:	e0a22002 	adc	r2, r2, r2
    8d40:	20400d81 	subcs	r0, r0, r1, lsl #27
    8d44:	e1500d01 	cmp	r0, r1, lsl #26
    8d48:	e0a22002 	adc	r2, r2, r2
    8d4c:	20400d01 	subcs	r0, r0, r1, lsl #26
    8d50:	e1500c81 	cmp	r0, r1, lsl #25
    8d54:	e0a22002 	adc	r2, r2, r2
    8d58:	20400c81 	subcs	r0, r0, r1, lsl #25
    8d5c:	e1500c01 	cmp	r0, r1, lsl #24
    8d60:	e0a22002 	adc	r2, r2, r2
    8d64:	20400c01 	subcs	r0, r0, r1, lsl #24
    8d68:	e1500b81 	cmp	r0, r1, lsl #23
    8d6c:	e0a22002 	adc	r2, r2, r2
    8d70:	20400b81 	subcs	r0, r0, r1, lsl #23
    8d74:	e1500b01 	cmp	r0, r1, lsl #22
    8d78:	e0a22002 	adc	r2, r2, r2
    8d7c:	20400b01 	subcs	r0, r0, r1, lsl #22
    8d80:	e1500a81 	cmp	r0, r1, lsl #21
    8d84:	e0a22002 	adc	r2, r2, r2
    8d88:	20400a81 	subcs	r0, r0, r1, lsl #21
    8d8c:	e1500a01 	cmp	r0, r1, lsl #20
    8d90:	e0a22002 	adc	r2, r2, r2
    8d94:	20400a01 	subcs	r0, r0, r1, lsl #20
    8d98:	e1500981 	cmp	r0, r1, lsl #19
    8d9c:	e0a22002 	adc	r2, r2, r2
    8da0:	20400981 	subcs	r0, r0, r1, lsl #19
    8da4:	e1500901 	cmp	r0, r1, lsl #18
    8da8:	e0a22002 	adc	r2, r2, r2
    8dac:	20400901 	subcs	r0, r0, r1, lsl #18
    8db0:	e1500881 	cmp	r0, r1, lsl #17
    8db4:	e0a22002 	adc	r2, r2, r2
    8db8:	20400881 	subcs	r0, r0, r1, lsl #17
    8dbc:	e1500801 	cmp	r0, r1, lsl #16
    8dc0:	e0a22002 	adc	r2, r2, r2
    8dc4:	20400801 	subcs	r0, r0, r1, lsl #16
    8dc8:	e1500781 	cmp	r0, r1, lsl #15
    8dcc:	e0a22002 	adc	r2, r2, r2
    8dd0:	20400781 	subcs	r0, r0, r1, lsl #15
    8dd4:	e1500701 	cmp	r0, r1, lsl #14
    8dd8:	e0a22002 	adc	r2, r2, r2
    8ddc:	20400701 	subcs	r0, r0, r1, lsl #14
    8de0:	e1500681 	cmp	r0, r1, lsl #13
    8de4:	e0a22002 	adc	r2, r2, r2
    8de8:	20400681 	subcs	r0, r0, r1, lsl #13
    8dec:	e1500601 	cmp	r0, r1, lsl #12
    8df0:	e0a22002 	adc	r2, r2, r2
    8df4:	20400601 	subcs	r0, r0, r1, lsl #12
    8df8:	e1500581 	cmp	r0, r1, lsl #11
    8dfc:	e0a22002 	adc	r2, r2, r2
    8e00:	20400581 	subcs	r0, r0, r1, lsl #11
    8e04:	e1500501 	cmp	r0, r1, lsl #10
    8e08:	e0a22002 	adc	r2, r2, r2
    8e0c:	20400501 	subcs	r0, r0, r1, lsl #10
    8e10:	e1500481 	cmp	r0, r1, lsl #9
    8e14:	e0a22002 	adc	r2, r2, r2
    8e18:	20400481 	subcs	r0, r0, r1, lsl #9
    8e1c:	e1500401 	cmp	r0, r1, lsl #8
    8e20:	e0a22002 	adc	r2, r2, r2
    8e24:	20400401 	subcs	r0, r0, r1, lsl #8
    8e28:	e1500381 	cmp	r0, r1, lsl #7
    8e2c:	e0a22002 	adc	r2, r2, r2
    8e30:	20400381 	subcs	r0, r0, r1, lsl #7
    8e34:	e1500301 	cmp	r0, r1, lsl #6
    8e38:	e0a22002 	adc	r2, r2, r2
    8e3c:	20400301 	subcs	r0, r0, r1, lsl #6
    8e40:	e1500281 	cmp	r0, r1, lsl #5
    8e44:	e0a22002 	adc	r2, r2, r2
    8e48:	20400281 	subcs	r0, r0, r1, lsl #5
    8e4c:	e1500201 	cmp	r0, r1, lsl #4
    8e50:	e0a22002 	adc	r2, r2, r2
    8e54:	20400201 	subcs	r0, r0, r1, lsl #4
    8e58:	e1500181 	cmp	r0, r1, lsl #3
    8e5c:	e0a22002 	adc	r2, r2, r2
    8e60:	20400181 	subcs	r0, r0, r1, lsl #3
    8e64:	e1500101 	cmp	r0, r1, lsl #2
    8e68:	e0a22002 	adc	r2, r2, r2
    8e6c:	20400101 	subcs	r0, r0, r1, lsl #2
    8e70:	e1500081 	cmp	r0, r1, lsl #1
    8e74:	e0a22002 	adc	r2, r2, r2
    8e78:	20400081 	subcs	r0, r0, r1, lsl #1
    8e7c:	e1500001 	cmp	r0, r1
    8e80:	e0a22002 	adc	r2, r2, r2
    8e84:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1110
    8e88:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1111
    8e8c:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1114
    8e90:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1115
    8e94:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1116
    8e98:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1118
    8e9c:	e16f2f11 	clz	r2, r1
    8ea0:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1120
    8ea4:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1121
    8ea8:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1125
    8eac:	e3500000 	cmp	r0, #0
    8eb0:	13e00000 	mvnne	r0, #0
    8eb4:	ea000007 	b	8ed8 <__aeabi_idiv0>

00008eb8 <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1156
    8eb8:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1157
    8ebc:	0afffffa 	beq	8eac <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1158
    8ec0:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1159
    8ec4:	ebffff80 	bl	8ccc <__udivsi3>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1160
    8ec8:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    8ecc:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    8ed0:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1163
    8ed4:	e12fff1e 	bx	lr

00008ed8 <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1461
    8ed8:	e12fff1e 	bx	lr

Disassembly of section .rodata:

00008edc <_ZL13Lock_Unlocked>:
    8edc:	00000000 	andeq	r0, r0, r0

00008ee0 <_ZL11Lock_Locked>:
    8ee0:	00000001 	andeq	r0, r0, r1

00008ee4 <_ZL21MaxFSDriverNameLength>:
    8ee4:	00000010 	andeq	r0, r0, r0, lsl r0

00008ee8 <_ZL17MaxFilenameLength>:
    8ee8:	00000010 	andeq	r0, r0, r0, lsl r0

00008eec <_ZL13MaxPathLength>:
    8eec:	00000080 	andeq	r0, r0, r0, lsl #1

00008ef0 <_ZL18NoFilesystemDriver>:
    8ef0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008ef4 <_ZL9NotifyAll>:
    8ef4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008ef8 <_ZL24Max_Process_Opened_Files>:
    8ef8:	00000010 	andeq	r0, r0, r0, lsl r0

00008efc <_ZL10Indefinite>:
    8efc:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f00 <_ZL18Deadline_Unchanged>:
    8f00:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00008f04 <_ZL14Invalid_Handle>:
    8f04:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
    8f08:	3a564544 	bcc	159a420 <__bss_end+0x159148c>
    8f0c:	74726175 	ldrbtvc	r6, [r2], #-373	; 0xfffffe8b
    8f10:	0000302f 	andeq	r3, r0, pc, lsr #32
    8f14:	54524155 	ldrbpl	r4, [r2], #-341	; 0xfffffeab
    8f18:	73617420 	cmnvc	r1, #32, 8	; 0x20000000
    8f1c:	7473206b 	ldrbtvc	r2, [r3], #-107	; 0xffffff95
    8f20:	69747261 	ldmdbvs	r4!, {r0, r5, r6, r9, ip, sp, lr}^
    8f24:	0021676e 	eoreq	r6, r1, lr, ror #14
    8f28:	00676f6c 	rsbeq	r6, r7, ip, ror #30
    8f2c:	205b0a0d 	subscs	r0, fp, sp, lsl #20
    8f30:	00000000 	andeq	r0, r0, r0
    8f34:	00203a5d 	eoreq	r3, r0, sp, asr sl

00008f38 <_ZL13Lock_Unlocked>:
    8f38:	00000000 	andeq	r0, r0, r0

00008f3c <_ZL11Lock_Locked>:
    8f3c:	00000001 	andeq	r0, r0, r1

00008f40 <_ZL21MaxFSDriverNameLength>:
    8f40:	00000010 	andeq	r0, r0, r0, lsl r0

00008f44 <_ZL17MaxFilenameLength>:
    8f44:	00000010 	andeq	r0, r0, r0, lsl r0

00008f48 <_ZL13MaxPathLength>:
    8f48:	00000080 	andeq	r0, r0, r0, lsl #1

00008f4c <_ZL18NoFilesystemDriver>:
    8f4c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f50 <_ZL9NotifyAll>:
    8f50:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f54 <_ZL24Max_Process_Opened_Files>:
    8f54:	00000010 	andeq	r0, r0, r0, lsl r0

00008f58 <_ZL10Indefinite>:
    8f58:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f5c <_ZL18Deadline_Unchanged>:
    8f5c:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00008f60 <_ZL14Invalid_Handle>:
    8f60:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f64 <_ZL16Pipe_File_Prefix>:
    8f64:	3a535953 	bcc	14df4b8 <__bss_end+0x14d6524>
    8f68:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    8f6c:	0000002f 	andeq	r0, r0, pc, lsr #32

00008f70 <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    8f70:	33323130 	teqcc	r2, #48, 2
    8f74:	37363534 			; <UNDEFINED> instruction: 0x37363534
    8f78:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    8f7c:	46454443 	strbmi	r4, [r5], -r3, asr #8
	...

Disassembly of section .bss:

00008f84 <__bss_start>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x1684898>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x39490>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3d0a4>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c7d90>
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
  24:	6a6b6e65 	bvs	1adb9c0 <__bss_end+0x1ad2a2c>
  28:	32736f2f 	rsbscc	r6, r3, #47, 30	; 0xbc
  2c:	2f323230 	svccs	0x00323230
  30:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
  34:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
  38:	752f7365 	strvc	r7, [pc, #-869]!	; fffffcdb <__bss_end+0xffff6d47>
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
  7c:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffffc8 <__bss_end+0xffff7034>
  80:	63732f65 	cmnvs	r3, #404	; 0x194
  84:	6b6e6568 	blvs	1b9962c <__bss_end+0x1b90698>
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
  bc:	1b050109 	blne	1404e8 <__bss_end+0x137554>
  c0:	4a130567 	bmi	4c1664 <__bss_end+0x4b86d0>
  c4:	052f0505 	streq	r0, [pc, #-1285]!	; fffffbc7 <__bss_end+0xffff6c33>
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
 104:	fb010200 	blx	4090e <__bss_end+0x3797a>
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
 168:	0b05010a 	bleq	140598 <__bss_end+0x137604>
 16c:	4a0a0583 	bmi	281780 <__bss_end+0x2787ec>
 170:	85830205 	strhi	r0, [r3, #517]	; 0x205
 174:	05830e05 	streq	r0, [r3, #3589]	; 0xe05
 178:	84856702 	strhi	r6, [r5], #1794	; 0x702
 17c:	4c860105 	stfmis	f0, [r6], {5}
 180:	4c854c85 	stcmi	12, cr4, [r5], {133}	; 0x85
 184:	00020585 	andeq	r0, r2, r5, lsl #11
 188:	4b010402 	blmi	41198 <__bss_end+0x38204>
 18c:	12030105 	andne	r0, r3, #1073741825	; 0x40000001
 190:	6b0d052e 	blvs	341650 <__bss_end+0x3386bc>
 194:	02002405 	andeq	r2, r0, #83886080	; 0x5000000
 198:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 19c:	04020004 	streq	r0, [r2], #-4
 1a0:	0b058302 	bleq	160db0 <__bss_end+0x157e1c>
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
 1e0:	00022601 	andeq	r2, r2, r1, lsl #12
 1e4:	d3000300 	movwle	r0, #768	; 0x300
 1e8:	02000001 	andeq	r0, r0, #1
 1ec:	0d0efb01 	vstreq	d15, [lr, #-4]
 1f0:	01010100 	mrseq	r0, (UNDEF: 17)
 1f4:	00000001 	andeq	r0, r0, r1
 1f8:	01000001 	tsteq	r0, r1
 1fc:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 148 <shift+0x148>
 200:	63732f65 	cmnvs	r3, #404	; 0x194
 204:	6b6e6568 	blvs	1b997ac <__bss_end+0x1b90818>
 208:	736f2f6a 	cmnvc	pc, #424	; 0x1a8
 20c:	32323032 	eorscc	r3, r2, #50	; 0x32
 210:	2f70732f 	svccs	0x0070732f
 214:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 218:	2f736563 	svccs	0x00736563
 21c:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 220:	63617073 	cmnvs	r1, #115	; 0x73
 224:	6f6c2f65 	svcvs	0x006c2f65
 228:	72656767 	rsbvc	r6, r5, #27000832	; 0x19c0000
 22c:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
 230:	682f006b 	stmdavs	pc!, {r0, r1, r3, r5, r6}	; <UNPREDICTABLE>
 234:	2f656d6f 	svccs	0x00656d6f
 238:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
 23c:	2f6a6b6e 	svccs	0x006a6b6e
 240:	3032736f 	eorscc	r7, r2, pc, ror #6
 244:	732f3232 			; <UNDEFINED> instruction: 0x732f3232
 248:	6f732f70 	svcvs	0x00732f70
 24c:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 250:	73752f73 	cmnvc	r5, #460	; 0x1cc
 254:	70737265 	rsbsvc	r7, r3, r5, ror #4
 258:	2f656361 	svccs	0x00656361
 25c:	6b2f2e2e 	blvs	bcbb1c <__bss_end+0xbc2b88>
 260:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 264:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 268:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 26c:	72702f65 	rsbsvc	r2, r0, #404	; 0x194
 270:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
 274:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
 278:	2f656d6f 	svccs	0x00656d6f
 27c:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
 280:	2f6a6b6e 	svccs	0x006a6b6e
 284:	3032736f 	eorscc	r7, r2, pc, ror #6
 288:	732f3232 			; <UNDEFINED> instruction: 0x732f3232
 28c:	6f732f70 	svcvs	0x00732f70
 290:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 294:	73752f73 	cmnvc	r5, #460	; 0x1cc
 298:	70737265 	rsbsvc	r7, r3, r5, ror #4
 29c:	2f656361 	svccs	0x00656361
 2a0:	6b2f2e2e 	blvs	bcbb60 <__bss_end+0xbc2bcc>
 2a4:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 2a8:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 2ac:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 2b0:	73662f65 	cmnvc	r6, #404	; 0x194
 2b4:	6f682f00 	svcvs	0x00682f00
 2b8:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
 2bc:	6e656863 	cdpvs	8, 6, cr6, cr5, cr3, {3}
 2c0:	6f2f6a6b 	svcvs	0x002f6a6b
 2c4:	32303273 	eorscc	r3, r0, #805306375	; 0x30000007
 2c8:	70732f32 	rsbsvc	r2, r3, r2, lsr pc
 2cc:	756f732f 	strbvc	r7, [pc, #-815]!	; ffffffa5 <__bss_end+0xffff7011>
 2d0:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 2d4:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
 2d8:	61707372 	cmnvs	r0, r2, ror r3
 2dc:	2e2f6563 	cfsh64cs	mvdx6, mvdx15, #51
 2e0:	656b2f2e 	strbvs	r2, [fp, #-3886]!	; 0xfffff0d2
 2e4:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 2e8:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 2ec:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 2f0:	6972642f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, sl, sp, lr}^
 2f4:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
 2f8:	6972622f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, r9, sp, lr}^
 2fc:	73656764 	cmnvc	r5, #100, 14	; 0x1900000
 300:	6f682f00 	svcvs	0x00682f00
 304:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
 308:	6e656863 	cdpvs	8, 6, cr6, cr5, cr3, {3}
 30c:	6f2f6a6b 	svcvs	0x002f6a6b
 310:	32303273 	eorscc	r3, r0, #805306375	; 0x30000007
 314:	70732f32 	rsbsvc	r2, r3, r2, lsr pc
 318:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffff1 <__bss_end+0xffff705d>
 31c:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 320:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
 324:	61707372 	cmnvs	r0, r2, ror r3
 328:	2e2f6563 	cfsh64cs	mvdx6, mvdx15, #51
 32c:	656b2f2e 	strbvs	r2, [fp, #-3886]!	; 0xfffff0d2
 330:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 334:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 338:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 33c:	616f622f 	cmnvs	pc, pc, lsr #4
 340:	722f6472 	eorvc	r6, pc, #1912602624	; 0x72000000
 344:	2f306970 	svccs	0x00306970
 348:	006c6168 	rsbeq	r6, ip, r8, ror #2
 34c:	69616d00 	stmdbvs	r1!, {r8, sl, fp, sp, lr}^
 350:	70632e6e 	rsbvc	r2, r3, lr, ror #28
 354:	00010070 	andeq	r0, r1, r0, ror r0
 358:	69777300 	ldmdbvs	r7!, {r8, r9, ip, sp, lr}^
 35c:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 360:	70730000 	rsbsvc	r0, r3, r0
 364:	6f6c6e69 	svcvs	0x006c6e69
 368:	682e6b63 	stmdavs	lr!, {r0, r1, r5, r6, r8, r9, fp, sp, lr}
 36c:	00000200 	andeq	r0, r0, r0, lsl #4
 370:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
 374:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
 378:	682e6d65 	stmdavs	lr!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}
 37c:	00000300 	andeq	r0, r0, r0, lsl #6
 380:	636f7270 	cmnvs	pc, #112, 4
 384:	2e737365 	cdpcs	3, 7, cr7, cr3, cr5, {3}
 388:	00020068 	andeq	r0, r2, r8, rrx
 38c:	6f727000 	svcvs	0x00727000
 390:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 394:	6e616d5f 	mcrvs	13, 3, r6, cr1, cr15, {2}
 398:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
 39c:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 3a0:	61750000 	cmnvs	r5, r0
 3a4:	645f7472 	ldrbvs	r7, [pc], #-1138	; 3ac <shift+0x3ac>
 3a8:	2e736665 	cdpcs	6, 7, cr6, cr3, cr5, {3}
 3ac:	00040068 	andeq	r0, r4, r8, rrx
 3b0:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
 3b4:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
 3b8:	00050068 	andeq	r0, r5, r8, rrx
 3bc:	01050000 	mrseq	r0, (UNDEF: 5)
 3c0:	38020500 	stmdacc	r2, {r8, sl}
 3c4:	03000082 	movweq	r0, #130	; 0x82
 3c8:	1c05010d 	stfnes	f0, [r5], {13}
 3cc:	6607059f 			; <UNDEFINED> instruction: 0x6607059f
 3d0:	69830105 	stmibvs	r3, {r0, r2, r8}
 3d4:	059f1b05 	ldreq	r1, [pc, #2821]	; ee1 <shift+0xee1>
 3d8:	15058513 	strne	r8, [r5, #-1299]	; 0xfffffaed
 3dc:	4b07054b 	blmi	1c1910 <__bss_end+0x1b897c>
 3e0:	05836aa0 	streq	r6, [r3, #2720]	; 0xaa0
 3e4:	1905840b 	stmdbne	r5, {r0, r1, r3, sl, pc}
 3e8:	8607054c 	strhi	r0, [r7], -ip, asr #10
 3ec:	05841405 	streq	r1, [r4, #1029]	; 0x405
 3f0:	0b05bb03 	bleq	16f004 <__bss_end+0x166070>
 3f4:	9f090568 	svcls	0x00090568
 3f8:	05672205 	strbeq	r2, [r7, #-517]!	; 0xfffffdfb
 3fc:	09054b08 	stmdbeq	r5, {r3, r8, r9, fp, lr}
 400:	0567839f 	strbeq	r8, [r7, #-927]!	; 0xfffffc61
 404:	0e028402 	cdpeq	4, 0, cr8, cr2, cr2, {0}
 408:	7c010100 	stfvcs	f0, [r1], {-0}
 40c:	03000002 	movweq	r0, #2
 410:	00014900 	andeq	r4, r1, r0, lsl #18
 414:	fb010200 	blx	40c1e <__bss_end+0x37c8a>
 418:	01000d0e 	tsteq	r0, lr, lsl #26
 41c:	00010101 	andeq	r0, r1, r1, lsl #2
 420:	00010000 	andeq	r0, r1, r0
 424:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
 428:	2f656d6f 	svccs	0x00656d6f
 42c:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
 430:	2f6a6b6e 	svccs	0x006a6b6e
 434:	3032736f 	eorscc	r7, r2, pc, ror #6
 438:	732f3232 			; <UNDEFINED> instruction: 0x732f3232
 43c:	6f732f70 	svcvs	0x00732f70
 440:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 444:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
 448:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
 44c:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
 450:	6f682f00 	svcvs	0x00682f00
 454:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
 458:	6e656863 	cdpvs	8, 6, cr6, cr5, cr3, {3}
 45c:	6f2f6a6b 	svcvs	0x002f6a6b
 460:	32303273 	eorscc	r3, r0, #805306375	; 0x30000007
 464:	70732f32 	rsbsvc	r2, r3, r2, lsr pc
 468:	756f732f 	strbvc	r7, [pc, #-815]!	; 141 <shift+0x141>
 46c:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 470:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 474:	2f6c656e 	svccs	0x006c656e
 478:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 47c:	2f656475 	svccs	0x00656475
 480:	636f7270 	cmnvs	pc, #112, 4
 484:	00737365 	rsbseq	r7, r3, r5, ror #6
 488:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 3d4 <shift+0x3d4>
 48c:	63732f65 	cmnvs	r3, #404	; 0x194
 490:	6b6e6568 	blvs	1b99a38 <__bss_end+0x1b90aa4>
 494:	736f2f6a 	cmnvc	pc, #424	; 0x1a8
 498:	32323032 	eorscc	r3, r2, #50	; 0x32
 49c:	2f70732f 	svccs	0x0070732f
 4a0:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 4a4:	2f736563 	svccs	0x00736563
 4a8:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 4ac:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 4b0:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 4b4:	662f6564 	strtvs	r6, [pc], -r4, ror #10
 4b8:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
 4bc:	2f656d6f 	svccs	0x00656d6f
 4c0:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
 4c4:	2f6a6b6e 	svccs	0x006a6b6e
 4c8:	3032736f 	eorscc	r7, r2, pc, ror #6
 4cc:	732f3232 			; <UNDEFINED> instruction: 0x732f3232
 4d0:	6f732f70 	svcvs	0x00732f70
 4d4:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 4d8:	656b2f73 	strbvs	r2, [fp, #-3955]!	; 0xfffff08d
 4dc:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 4e0:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 4e4:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 4e8:	616f622f 	cmnvs	pc, pc, lsr #4
 4ec:	722f6472 	eorvc	r6, pc, #1912602624	; 0x72000000
 4f0:	2f306970 	svccs	0x00306970
 4f4:	006c6168 	rsbeq	r6, ip, r8, ror #2
 4f8:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
 4fc:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
 500:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 504:	00000100 	andeq	r0, r0, r0, lsl #2
 508:	2e697773 	mcrcs	7, 3, r7, cr9, cr3, {3}
 50c:	00020068 	andeq	r0, r2, r8, rrx
 510:	69707300 	ldmdbvs	r0!, {r8, r9, ip, sp, lr}^
 514:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
 518:	00682e6b 	rsbeq	r2, r8, fp, ror #28
 51c:	66000002 	strvs	r0, [r0], -r2
 520:	73656c69 	cmnvc	r5, #26880	; 0x6900
 524:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
 528:	00682e6d 	rsbeq	r2, r8, sp, ror #28
 52c:	70000003 	andvc	r0, r0, r3
 530:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 534:	682e7373 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, r9, ip, sp, lr}
 538:	00000200 	andeq	r0, r0, r0, lsl #4
 53c:	636f7270 	cmnvs	pc, #112, 4
 540:	5f737365 	svcpl	0x00737365
 544:	616e616d 	cmnvs	lr, sp, ror #2
 548:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
 54c:	00020068 	andeq	r0, r2, r8, rrx
 550:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
 554:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
 558:	00040068 	andeq	r0, r4, r8, rrx
 55c:	01050000 	mrseq	r0, (UNDEF: 5)
 560:	b8020500 	stmdalt	r2, {r8, sl}
 564:	16000083 	strne	r0, [r0], -r3, lsl #1
 568:	05691a05 	strbeq	r1, [r9, #-2565]!	; 0xfffff5fb
 56c:	0c052f2c 	stceq	15, cr2, [r5], {44}	; 0x2c
 570:	2f01054c 	svccs	0x0001054c
 574:	83320585 	teqhi	r2, #557842432	; 0x21400000
 578:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
 57c:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 580:	01054b1a 	tsteq	r5, sl, lsl fp
 584:	3205852f 	andcc	r8, r5, #197132288	; 0xbc00000
 588:	4b2e05a1 	blmi	b81c14 <__bss_end+0xb78c80>
 58c:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
 590:	0c052f2d 	stceq	15, cr2, [r5], {45}	; 0x2d
 594:	2f01054c 	svccs	0x0001054c
 598:	bd2e0585 	cfstr32lt	mvfx0, [lr, #-532]!	; 0xfffffdec
 59c:	054b3005 	strbeq	r3, [fp, #-5]
 5a0:	1b054b2e 	blne	153260 <__bss_end+0x14a2cc>
 5a4:	2f2e054b 	svccs	0x002e054b
 5a8:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 5ac:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 5b0:	3005bd2e 	andcc	fp, r5, lr, lsr #26
 5b4:	4b2e054b 	blmi	b81ae8 <__bss_end+0xb78b54>
 5b8:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
 5bc:	0c052f2e 	stceq	15, cr2, [r5], {46}	; 0x2e
 5c0:	2f01054c 	svccs	0x0001054c
 5c4:	832e0585 			; <UNDEFINED> instruction: 0x832e0585
 5c8:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
 5cc:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 5d0:	3305bd2e 	movwcc	fp, #23854	; 0x5d2e
 5d4:	4b2f054b 	blmi	bc1b08 <__bss_end+0xbb8b74>
 5d8:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
 5dc:	0c052f30 	stceq	15, cr2, [r5], {48}	; 0x30
 5e0:	2f01054c 	svccs	0x0001054c
 5e4:	a12e0585 	smlawbge	lr, r5, r5, r0
 5e8:	054b2f05 	strbeq	r2, [fp, #-3845]	; 0xfffff0fb
 5ec:	2f054b1b 	svccs	0x00054b1b
 5f0:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 5f4:	852f0105 	strhi	r0, [pc, #-261]!	; 4f7 <shift+0x4f7>
 5f8:	05bd2e05 	ldreq	r2, [sp, #3589]!	; 0xe05
 5fc:	3b054b2f 	blcc	1532c0 <__bss_end+0x14a32c>
 600:	4b1b054b 	blmi	6c1b34 <__bss_end+0x6b8ba0>
 604:	052f3005 	streq	r3, [pc, #-5]!	; 607 <shift+0x607>
 608:	01054c0c 	tsteq	r5, ip, lsl #24
 60c:	2f05852f 	svccs	0x0005852f
 610:	4b3b05a1 	blmi	ec1c9c <__bss_end+0xeb8d08>
 614:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
 618:	0c052f30 	stceq	15, cr2, [r5], {48}	; 0x30
 61c:	9f01054c 	svcls	0x0001054c
 620:	67200585 	strvs	r0, [r0, -r5, lsl #11]!
 624:	054d2d05 	strbeq	r2, [sp, #-3333]	; 0xfffff2fb
 628:	1a054b31 	bne	1532f4 <__bss_end+0x14a360>
 62c:	300c054b 	andcc	r0, ip, fp, asr #10
 630:	852f0105 	strhi	r0, [pc, #-261]!	; 533 <shift+0x533>
 634:	05672005 	strbeq	r2, [r7, #-5]!
 638:	31054d2d 	tstcc	r5, sp, lsr #26
 63c:	4b1a054b 	blmi	681b70 <__bss_end+0x678bdc>
 640:	05300c05 	ldreq	r0, [r0, #-3077]!	; 0xfffff3fb
 644:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 648:	2d058320 	stccs	3, cr8, [r5, #-128]	; 0xffffff80
 64c:	4b3e054c 	blmi	f81b84 <__bss_end+0xf78bf0>
 650:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
 654:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 658:	2d056720 	stccs	7, cr6, [r5, #-128]	; 0xffffff80
 65c:	4b30054d 	blmi	c01b98 <__bss_end+0xbf8c04>
 660:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
 664:	0105300c 	tsteq	r5, ip
 668:	0c05872f 	stceq	7, cr8, [r5], {47}	; 0x2f
 66c:	31059fa0 	smlatbcc	r5, r0, pc, r9	; <UNPREDICTABLE>
 670:	662905bc 			; <UNDEFINED> instruction: 0x662905bc
 674:	052e3605 	streq	r3, [lr, #-1541]!	; 0xfffff9fb
 678:	1305300f 	movwne	r3, #20495	; 0x500f
 67c:	84090566 	strhi	r0, [r9], #-1382	; 0xfffffa9a
 680:	05d81005 	ldrbeq	r1, [r8, #5]
 684:	08029f01 	stmdaeq	r2, {r0, r8, r9, sl, fp, ip, pc}
 688:	76010100 	strvc	r0, [r1], -r0, lsl #2
 68c:	03000002 	movweq	r0, #2
 690:	00004f00 	andeq	r4, r0, r0, lsl #30
 694:	fb010200 	blx	40e9e <__bss_end+0x37f0a>
 698:	01000d0e 	tsteq	r0, lr, lsl #26
 69c:	00010101 	andeq	r0, r1, r1, lsl #2
 6a0:	00010000 	andeq	r0, r1, r0
 6a4:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
 6a8:	2f656d6f 	svccs	0x00656d6f
 6ac:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
 6b0:	2f6a6b6e 	svccs	0x006a6b6e
 6b4:	3032736f 	eorscc	r7, r2, pc, ror #6
 6b8:	732f3232 			; <UNDEFINED> instruction: 0x732f3232
 6bc:	6f732f70 	svcvs	0x00732f70
 6c0:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 6c4:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
 6c8:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
 6cc:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
 6d0:	74730000 	ldrbtvc	r0, [r3], #-0
 6d4:	72747364 	rsbsvc	r7, r4, #100, 6	; 0x90000001
 6d8:	2e676e69 	cdpcs	14, 6, cr6, cr7, cr9, {3}
 6dc:	00707063 	rsbseq	r7, r0, r3, rrx
 6e0:	00000001 	andeq	r0, r0, r1
 6e4:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
 6e8:	00881402 	addeq	r1, r8, r2, lsl #8
 6ec:	06051a00 	streq	r1, [r5], -r0, lsl #20
 6f0:	4c0f05bb 	cfstr32mi	mvfx0, [pc], {187}	; 0xbb
 6f4:	05682105 	strbeq	r2, [r8, #-261]!	; 0xfffffefb
 6f8:	0b05ba0a 	bleq	16ef28 <__bss_end+0x165f94>
 6fc:	4a27052e 	bmi	9c1bbc <__bss_end+0x9b8c28>
 700:	054a0d05 	strbeq	r0, [sl, #-3333]	; 0xfffff2fb
 704:	04052f09 	streq	r2, [r5], #-3849	; 0xfffff0f7
 708:	6202059f 	andvs	r0, r2, #666894336	; 0x27c00000
 70c:	05350505 	ldreq	r0, [r5, #-1285]!	; 0xfffffafb
 710:	11056810 	tstne	r5, r0, lsl r8
 714:	4a22052e 	bmi	881bd4 <__bss_end+0x878c40>
 718:	052e1305 	streq	r1, [lr, #-773]!	; 0xfffffcfb
 71c:	09052f0a 	stmdbeq	r5, {r1, r3, r8, r9, sl, fp, sp}
 720:	2e0a0569 	cfsh32cs	mvfx0, mvfx10, #57
 724:	054a0c05 	strbeq	r0, [sl, #-3077]	; 0xfffff3fb
 728:	0b054b03 	bleq	15333c <__bss_end+0x14a3a8>
 72c:	00180568 	andseq	r0, r8, r8, ror #10
 730:	4a030402 	bmi	c1740 <__bss_end+0xb87ac>
 734:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
 738:	059e0304 	ldreq	r0, [lr, #772]	; 0x304
 73c:	04020015 	streq	r0, [r2], #-21	; 0xffffffeb
 740:	18056802 	stmdane	r5, {r1, fp, sp, lr}
 744:	02040200 	andeq	r0, r4, #0, 4
 748:	00080582 	andeq	r0, r8, r2, lsl #11
 74c:	4a020402 	bmi	8175c <__bss_end+0x787c8>
 750:	02001a05 	andeq	r1, r0, #20480	; 0x5000
 754:	054b0204 	strbeq	r0, [fp, #-516]	; 0xfffffdfc
 758:	0402001b 	streq	r0, [r2], #-27	; 0xffffffe5
 75c:	0c052e02 	stceq	14, cr2, [r5], {2}
 760:	02040200 	andeq	r0, r4, #0, 4
 764:	000f054a 	andeq	r0, pc, sl, asr #10
 768:	82020402 	andhi	r0, r2, #33554432	; 0x2000000
 76c:	02001b05 	andeq	r1, r0, #5120	; 0x1400
 770:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 774:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
 778:	0a052e02 	beq	14bf88 <__bss_end+0x142ff4>
 77c:	02040200 	andeq	r0, r4, #0, 4
 780:	000b052f 	andeq	r0, fp, pc, lsr #10
 784:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 788:	02000d05 	andeq	r0, r0, #320	; 0x140
 78c:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 790:	04020002 	streq	r0, [r2], #-2
 794:	01054602 	tsteq	r5, r2, lsl #12
 798:	06058588 	streq	r8, [r5], -r8, lsl #11
 79c:	4c090583 	cfstr32mi	mvfx0, [r9], {131}	; 0x83
 7a0:	054a1005 	strbeq	r1, [sl, #-5]
 7a4:	07054c0a 	streq	r4, [r5, -sl, lsl #24]
 7a8:	4a0305bb 	bmi	c1e9c <__bss_end+0xb8f08>
 7ac:	02001705 	andeq	r1, r0, #1310720	; 0x140000
 7b0:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
 7b4:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
 7b8:	0d054a01 	vstreq	s8, [r5, #-4]
 7bc:	4a14054d 	bmi	501cf8 <__bss_end+0x4f8d64>
 7c0:	052e0a05 	streq	r0, [lr, #-2565]!	; 0xfffff5fb
 7c4:	02056808 	andeq	r6, r5, #8, 16	; 0x80000
 7c8:	05667803 	strbeq	r7, [r6, #-2051]!	; 0xfffff7fd
 7cc:	2e0b0309 	cdpcs	3, 0, cr0, cr11, cr9, {0}
 7d0:	852f0105 	strhi	r0, [pc, #-261]!	; 6d3 <shift+0x6d3>
 7d4:	05bd0905 	ldreq	r0, [sp, #2309]!	; 0x905
 7d8:	04020016 	streq	r0, [r2], #-22	; 0xffffffea
 7dc:	1d054a04 	vstrne	s8, [r5, #-16]
 7e0:	02040200 	andeq	r0, r4, #0, 4
 7e4:	001e0582 	andseq	r0, lr, r2, lsl #11
 7e8:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 7ec:	02001605 	andeq	r1, r0, #5242880	; 0x500000
 7f0:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
 7f4:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
 7f8:	12054b03 	andne	r4, r5, #3072	; 0xc00
 7fc:	03040200 	movweq	r0, #16896	; 0x4200
 800:	0008052e 	andeq	r0, r8, lr, lsr #10
 804:	4a030402 	bmi	c1814 <__bss_end+0xb8880>
 808:	02000905 	andeq	r0, r0, #81920	; 0x14000
 80c:	052e0304 	streq	r0, [lr, #-772]!	; 0xfffffcfc
 810:	04020012 	streq	r0, [r2], #-18	; 0xffffffee
 814:	0b054a03 	bleq	153028 <__bss_end+0x14a094>
 818:	03040200 	movweq	r0, #16896	; 0x4200
 81c:	0002052e 	andeq	r0, r2, lr, lsr #10
 820:	2d030402 	cfstrscs	mvf0, [r3, #-8]
 824:	02000b05 	andeq	r0, r0, #5120	; 0x1400
 828:	05840204 	streq	r0, [r4, #516]	; 0x204
 82c:	04020008 	streq	r0, [r2], #-8
 830:	09058301 	stmdbeq	r5, {r0, r8, r9, pc}
 834:	01040200 	mrseq	r0, R12_usr
 838:	000b052e 	andeq	r0, fp, lr, lsr #10
 83c:	4a010402 	bmi	4184c <__bss_end+0x388b8>
 840:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 844:	05490104 	strbeq	r0, [r9, #-260]	; 0xfffffefc
 848:	0105850b 	tsteq	r5, fp, lsl #10
 84c:	0e05852f 	cfsh32eq	mvfx8, mvfx5, #31
 850:	661105bc 			; <UNDEFINED> instruction: 0x661105bc
 854:	05bc2005 	ldreq	r2, [ip, #5]!
 858:	1f05660b 	svcne	0x0005660b
 85c:	660a054b 	strvs	r0, [sl], -fp, asr #10
 860:	054b0805 	strbeq	r0, [fp, #-2053]	; 0xfffff7fb
 864:	16058311 			; <UNDEFINED> instruction: 0x16058311
 868:	6708052e 	strvs	r0, [r8, -lr, lsr #10]
 86c:	05671105 	strbeq	r1, [r7, #-261]!	; 0xfffffefb
 870:	01054d0b 	tsteq	r5, fp, lsl #26
 874:	0605852f 	streq	r8, [r5], -pc, lsr #10
 878:	4c0b0583 	cfstr32mi	mvfx0, [fp], {131}	; 0x83
 87c:	052e0c05 	streq	r0, [lr, #-3077]!	; 0xfffff3fb
 880:	0405660e 	streq	r6, [r5], #-1550	; 0xfffff9f2
 884:	6502054b 	strvs	r0, [r2, #-1355]	; 0xfffffab5
 888:	05310905 	ldreq	r0, [r1, #-2309]!	; 0xfffff6fb
 88c:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 890:	0b059f08 	bleq	1684b8 <__bss_end+0x15f524>
 894:	0014054c 	andseq	r0, r4, ip, asr #10
 898:	4a030402 	bmi	c18a8 <__bss_end+0xb8914>
 89c:	02000705 	andeq	r0, r0, #1310720	; 0x140000
 8a0:	05830204 	streq	r0, [r3, #516]	; 0x204
 8a4:	04020008 	streq	r0, [r2], #-8
 8a8:	0a052e02 	beq	14c0b8 <__bss_end+0x143124>
 8ac:	02040200 	andeq	r0, r4, #0, 4
 8b0:	0002054a 	andeq	r0, r2, sl, asr #10
 8b4:	49020402 	stmdbmi	r2, {r1, sl}
 8b8:	85840105 	strhi	r0, [r4, #261]	; 0x105
 8bc:	05bb0e05 	ldreq	r0, [fp, #3589]!	; 0xe05
 8c0:	0b054b08 	bleq	1534e8 <__bss_end+0x14a554>
 8c4:	0014054c 	andseq	r0, r4, ip, asr #10
 8c8:	4a030402 	bmi	c18d8 <__bss_end+0xb8944>
 8cc:	02001605 	andeq	r1, r0, #5242880	; 0x500000
 8d0:	05830204 	streq	r0, [r3, #516]	; 0x204
 8d4:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
 8d8:	0a052e02 	beq	14c0e8 <__bss_end+0x143154>
 8dc:	02040200 	andeq	r0, r4, #0, 4
 8e0:	000b054a 	andeq	r0, fp, sl, asr #10
 8e4:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 8e8:	02001705 	andeq	r1, r0, #1310720	; 0x140000
 8ec:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 8f0:	0402000d 	streq	r0, [r2], #-13
 8f4:	02052e02 	andeq	r2, r5, #2, 28
 8f8:	02040200 	andeq	r0, r4, #0, 4
 8fc:	8401052d 	strhi	r0, [r1], #-1325	; 0xfffffad3
 900:	01000802 	tsteq	r0, r2, lsl #16
 904:	00007901 	andeq	r7, r0, r1, lsl #18
 908:	46000300 	strmi	r0, [r0], -r0, lsl #6
 90c:	02000000 	andeq	r0, r0, #0
 910:	0d0efb01 	vstreq	d15, [lr, #-4]
 914:	01010100 	mrseq	r0, (UNDEF: 17)
 918:	00000001 	andeq	r0, r0, r1
 91c:	01000001 	tsteq	r0, r1
 920:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 924:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 928:	2f2e2e2f 	svccs	0x002e2e2f
 92c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 930:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
 934:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 938:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
 93c:	2f676966 	svccs	0x00676966
 940:	006d7261 	rsbeq	r7, sp, r1, ror #4
 944:	62696c00 	rsbvs	r6, r9, #0, 24
 948:	6e756631 	mrcvs	6, 3, r6, cr5, cr1, {1}
 94c:	532e7363 			; <UNDEFINED> instruction: 0x532e7363
 950:	00000100 	andeq	r0, r0, r0, lsl #2
 954:	02050000 	andeq	r0, r5, #0
 958:	00008ccc 	andeq	r8, r0, ip, asr #25
 95c:	0108ca03 	tsteq	r8, r3, lsl #20
 960:	2f2f2f30 	svccs	0x002f2f30
 964:	02302f2f 	eorseq	r2, r0, #47, 30	; 0xbc
 968:	2f1401d0 	svccs	0x001401d0
 96c:	302f2f31 	eorcc	r2, pc, r1, lsr pc	; <UNPREDICTABLE>
 970:	03322f4c 	teqeq	r2, #76, 30	; 0x130
 974:	2f2f661f 	svccs	0x002f661f
 978:	2f2f2f2f 	svccs	0x002f2f2f
 97c:	0002022f 	andeq	r0, r2, pc, lsr #4
 980:	005c0101 	subseq	r0, ip, r1, lsl #2
 984:	00030000 	andeq	r0, r3, r0
 988:	00000046 	andeq	r0, r0, r6, asr #32
 98c:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 990:	0101000d 	tsteq	r1, sp
 994:	00000101 	andeq	r0, r0, r1, lsl #2
 998:	00000100 	andeq	r0, r0, r0, lsl #2
 99c:	2f2e2e01 	svccs	0x002e2e01
 9a0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 9a4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 9a8:	2f2e2e2f 	svccs	0x002e2e2f
 9ac:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 8fc <shift+0x8fc>
 9b0:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 9b4:	6f632f63 	svcvs	0x00632f63
 9b8:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
 9bc:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
 9c0:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
 9c4:	75663162 	strbvc	r3, [r6, #-354]!	; 0xfffffe9e
 9c8:	2e73636e 	cdpcs	3, 7, cr6, cr3, cr14, {3}
 9cc:	00010053 	andeq	r0, r1, r3, asr r0
 9d0:	05000000 	streq	r0, [r0, #-0]
 9d4:	008ed802 	addeq	sp, lr, r2, lsl #16
 9d8:	0bb40300 	bleq	fed015e0 <__bss_end+0xfecf864c>
 9dc:	00020201 	andeq	r0, r2, r1, lsl #4
 9e0:	01030101 	tsteq	r3, r1, lsl #2
 9e4:	00030000 	andeq	r0, r3, r0
 9e8:	000000fd 	strdeq	r0, [r0], -sp
 9ec:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 9f0:	0101000d 	tsteq	r1, sp
 9f4:	00000101 	andeq	r0, r0, r1, lsl #2
 9f8:	00000100 	andeq	r0, r0, r0, lsl #2
 9fc:	2f2e2e01 	svccs	0x002e2e01
 a00:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 a04:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 a08:	2f2e2e2f 	svccs	0x002e2e2f
 a0c:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 95c <shift+0x95c>
 a10:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 a14:	2e2e2f63 	cdpcs	15, 2, cr2, cr14, cr3, {3}
 a18:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 a1c:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 a20:	2f2e2e00 	svccs	0x002e2e00
 a24:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 a28:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 a2c:	2f2e2e2f 	svccs	0x002e2e2f
 a30:	63672f2e 	cmnvs	r7, #46, 30	; 0xb8
 a34:	2e2e0063 	cdpcs	0, 2, cr0, cr14, cr3, {3}
 a38:	2f2e2e2f 	svccs	0x002e2e2f
 a3c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 a40:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 a44:	2f2e2e2f 	svccs	0x002e2e2f
 a48:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 a4c:	2e2f6363 	cdpcs	3, 2, cr6, cr15, cr3, {3}
 a50:	63672f2e 	cmnvs	r7, #46, 30	; 0xb8
 a54:	6f632f63 	svcvs	0x00632f63
 a58:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
 a5c:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
 a60:	2f2e2e00 	svccs	0x002e2e00
 a64:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 a68:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 a6c:	2f2e2e2f 	svccs	0x002e2e2f
 a70:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 9c0 <shift+0x9c0>
 a74:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 a78:	68000063 	stmdavs	r0, {r0, r1, r5, r6}
 a7c:	74687361 	strbtvc	r7, [r8], #-865	; 0xfffffc9f
 a80:	682e6261 	stmdavs	lr!, {r0, r5, r6, r9, sp, lr}
 a84:	00000100 	andeq	r0, r0, r0, lsl #2
 a88:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
 a8c:	2e617369 	cdpcs	3, 6, cr7, cr1, cr9, {3}
 a90:	00020068 	andeq	r0, r2, r8, rrx
 a94:	6d726100 	ldfvse	f6, [r2, #-0]
 a98:	7570632d 	ldrbvc	r6, [r0, #-813]!	; 0xfffffcd3
 a9c:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 aa0:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
 aa4:	632d6e73 			; <UNDEFINED> instruction: 0x632d6e73
 aa8:	74736e6f 	ldrbtvc	r6, [r3], #-3695	; 0xfffff191
 aac:	73746e61 	cmnvc	r4, #1552	; 0x610
 ab0:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 ab4:	72610000 	rsbvc	r0, r1, #0
 ab8:	00682e6d 	rsbeq	r2, r8, sp, ror #28
 abc:	6c000003 	stcvs	0, cr0, [r0], {3}
 ac0:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 ac4:	682e3263 	stmdavs	lr!, {r0, r1, r5, r6, r9, ip, sp}
 ac8:	00000400 	andeq	r0, r0, r0, lsl #8
 acc:	2d6c6267 	sfmcs	f6, 2, [ip, #-412]!	; 0xfffffe64
 ad0:	726f7463 	rsbvc	r7, pc, #1660944384	; 0x63000000
 ad4:	00682e73 	rsbeq	r2, r8, r3, ror lr
 ad8:	6c000004 	stcvs	0, cr0, [r0], {4}
 adc:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 ae0:	632e3263 			; <UNDEFINED> instruction: 0x632e3263
 ae4:	00000400 	andeq	r0, r0, r0, lsl #8
	...

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
      58:	17530704 	ldrbne	r0, [r3, -r4, lsl #14]
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
      b0:	0b010000 	bleq	400b8 <__bss_end+0x37124>
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
     11c:	17530704 	ldrbne	r0, [r3, -r4, lsl #14]
     120:	72080000 	andvc	r0, r8, #0
     124:	01000003 	tsteq	r0, r3
     128:	00441533 	subeq	r1, r4, r3, lsr r5
     12c:	4a080000 	bmi	200134 <__bss_end+0x1f71a0>
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
     15c:	3a010000 	bcc	40164 <__bss_end+0x371d0>
     160:	00007615 	andeq	r7, r0, r5, lsl r6
     164:	01af0900 			; <UNDEFINED> instruction: 0x01af0900
     168:	48010000 	stmdami	r1, {}	; <UNPREDICTABLE>
     16c:	0000cb10 	andeq	ip, r0, r0, lsl fp
     170:	0081e000 	addeq	lr, r1, r0
     174:	00005800 	andeq	r5, r0, r0, lsl #16
     178:	cb9c0100 	blgt	fe700580 <__bss_end+0xfe6f75ec>
     17c:	0a000000 	beq	184 <shift+0x184>
     180:	000001bd 			; <UNDEFINED> instruction: 0x000001bd
     184:	d20c4a01 	andle	r4, ip, #4096	; 0x1000
     188:	02000000 	andeq	r0, r0, #0
     18c:	0b007491 	bleq	1d3d8 <__bss_end+0x14444>
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
     200:	2a0c9c01 	bcs	32720c <__bss_end+0x31e278>
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
     254:	cb110a01 	blgt	442a60 <__bss_end+0x439acc>
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
     2bc:	0a010067 	beq	40460 <__bss_end+0x374cc>
     2c0:	00019e2f 	andeq	r9, r1, pc, lsr #28
     2c4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     2c8:	09b30000 	ldmibeq	r3!, {}	; <UNPREDICTABLE>
     2cc:	00040000 	andeq	r0, r4, r0
     2d0:	000001c6 	andeq	r0, r0, r6, asr #3
     2d4:	02450104 	subeq	r0, r5, #4, 2
     2d8:	43040000 	movwmi	r0, #16384	; 0x4000
     2dc:	31000005 	tstcc	r0, r5
     2e0:	38000000 	stmdacc	r0, {}	; <UNPREDICTABLE>
     2e4:	80000082 	andhi	r0, r0, r2, lsl #1
     2e8:	e1000001 	tst	r0, r1
     2ec:	02000001 	andeq	r0, r0, #1
     2f0:	09e90801 	stmibeq	r9!, {r0, fp}^
     2f4:	25030000 	strcs	r0, [r3, #-0]
     2f8:	02000000 	andeq	r0, r0, #0
     2fc:	0a200502 	beq	80170c <__bss_end+0x7f8778>
     300:	04040000 	streq	r0, [r4], #-0
     304:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
     308:	08010200 	stmdaeq	r1, {r9}
     30c:	000009e0 	andeq	r0, r0, r0, ror #19
     310:	cc070202 	sfmgt	f0, 4, [r7], {2}
     314:	05000007 	streq	r0, [r0, #-7]
     318:	00000a65 	andeq	r0, r0, r5, ror #20
     31c:	5e070908 	vmlapl.f16	s0, s14, s16	; <UNPREDICTABLE>
     320:	03000000 	movweq	r0, #0
     324:	0000004d 	andeq	r0, r0, sp, asr #32
     328:	53070402 	movwpl	r0, #29698	; 0x7402
     32c:	06000017 			; <UNDEFINED> instruction: 0x06000017
     330:	00000668 	andeq	r0, r0, r8, ror #12
     334:	08060208 	stmdaeq	r6, {r3, r9}
     338:	0000008b 	andeq	r0, r0, fp, lsl #1
     33c:	00307207 	eorseq	r7, r0, r7, lsl #4
     340:	4d0e0802 	stcmi	8, cr0, [lr, #-8]
     344:	00000000 	andeq	r0, r0, r0
     348:	00317207 	eorseq	r7, r1, r7, lsl #4
     34c:	4d0e0902 	vstrmi.16	s0, [lr, #-4]	; <UNPREDICTABLE>
     350:	04000000 	streq	r0, [r0], #-0
     354:	04ec0800 	strbteq	r0, [ip], #2048	; 0x800
     358:	04050000 	streq	r0, [r5], #-0
     35c:	00000038 	andeq	r0, r0, r8, lsr r0
     360:	c20c1e02 	andgt	r1, ip, #2, 28
     364:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     368:	000006cf 	andeq	r0, r0, pc, asr #13
     36c:	0d4a0900 	vstreq.16	s1, [sl, #-0]	; <UNPREDICTABLE>
     370:	09010000 	stmdbeq	r1, {}	; <UNPREDICTABLE>
     374:	00000d14 	andeq	r0, r0, r4, lsl sp
     378:	08360902 	ldmdaeq	r6!, {r1, r8, fp}
     37c:	09030000 	stmdbeq	r3, {}	; <UNPREDICTABLE>
     380:	0000095b 	andeq	r0, r0, fp, asr r9
     384:	06980904 	ldreq	r0, [r8], r4, lsl #18
     388:	00050000 	andeq	r0, r5, r0
     38c:	000c8408 	andeq	r8, ip, r8, lsl #8
     390:	38040500 	stmdacc	r4, {r8, sl}
     394:	02000000 	andeq	r0, r0, #0
     398:	00ff0c3f 	rscseq	r0, pc, pc, lsr ip	; <UNPREDICTABLE>
     39c:	bc090000 	stclt	0, cr0, [r9], {-0}
     3a0:	00000003 	andeq	r0, r0, r3
     3a4:	00050109 	andeq	r0, r5, r9, lsl #2
     3a8:	4e090100 	adfmie	f0, f1, f0
     3ac:	02000009 	andeq	r0, r0, #9
     3b0:	000cdf09 	andeq	sp, ip, r9, lsl #30
     3b4:	54090300 	strpl	r0, [r9], #-768	; 0xfffffd00
     3b8:	0400000d 	streq	r0, [r0], #-13
     3bc:	00090f09 	andeq	r0, r9, r9, lsl #30
     3c0:	ec090500 	cfstr32	mvfx0, [r9], {-0}
     3c4:	06000007 	streq	r0, [r0], -r7
     3c8:	0c3e0800 	ldceq	8, cr0, [lr], #-0
     3cc:	04050000 	streq	r0, [r5], #-0
     3d0:	00000038 	andeq	r0, r0, r8, lsr r0
     3d4:	2a0c6602 	bcs	319be4 <__bss_end+0x310c50>
     3d8:	09000001 	stmdbeq	r0, {r0}
     3dc:	000009be 			; <UNDEFINED> instruction: 0x000009be
     3e0:	07ae0900 	streq	r0, [lr, r0, lsl #18]!
     3e4:	09010000 	stmdbeq	r1, {}	; <UNPREDICTABLE>
     3e8:	00000a34 	andeq	r0, r0, r4, lsr sl
     3ec:	07f10902 	ldrbeq	r0, [r1, r2, lsl #18]!
     3f0:	00030000 	andeq	r0, r3, r0
     3f4:	0009160a 	andeq	r1, r9, sl, lsl #12
     3f8:	14050300 	strne	r0, [r5], #-768	; 0xfffffd00
     3fc:	00000059 	andeq	r0, r0, r9, asr r0
     400:	8edc0305 	cdphi	3, 13, cr0, cr12, cr5, {0}
     404:	2a0a0000 	bcs	28040c <__bss_end+0x277478>
     408:	03000009 	movweq	r0, #9
     40c:	00591406 	subseq	r1, r9, r6, lsl #8
     410:	03050000 	movweq	r0, #20480	; 0x5000
     414:	00008ee0 	andeq	r8, r0, r0, ror #29
     418:	0008f90a 	andeq	pc, r8, sl, lsl #18
     41c:	1a070400 	bne	1c1424 <__bss_end+0x1b8490>
     420:	00000059 	andeq	r0, r0, r9, asr r0
     424:	8ee40305 	cdphi	3, 14, cr0, cr4, cr5, {0}
     428:	310a0000 	mrscc	r0, (UNDEF: 10)
     42c:	04000005 	streq	r0, [r0], #-5
     430:	00591a09 	subseq	r1, r9, r9, lsl #20
     434:	03050000 	movweq	r0, #20480	; 0x5000
     438:	00008ee8 	andeq	r8, r0, r8, ror #29
     43c:	0009d20a 	andeq	sp, r9, sl, lsl #4
     440:	1a0b0400 	bne	2c1448 <__bss_end+0x2b84b4>
     444:	00000059 	andeq	r0, r0, r9, asr r0
     448:	8eec0305 	cdphi	3, 14, cr0, cr12, cr5, {0}
     44c:	9b0a0000 	blls	280454 <__bss_end+0x2774c0>
     450:	04000007 	streq	r0, [r0], #-7
     454:	00591a0d 	subseq	r1, r9, sp, lsl #20
     458:	03050000 	movweq	r0, #20480	; 0x5000
     45c:	00008ef0 	strdeq	r8, [r0], -r0
     460:	0006810a 	andeq	r8, r6, sl, lsl #2
     464:	1a0f0400 	bne	3c146c <__bss_end+0x3b84d8>
     468:	00000059 	andeq	r0, r0, r9, asr r0
     46c:	8ef40305 	cdphi	3, 15, cr0, cr4, cr5, {0}
     470:	a4080000 	strge	r0, [r8], #-0
     474:	0500000a 	streq	r0, [r0, #-10]
     478:	00003804 	andeq	r3, r0, r4, lsl #16
     47c:	0c1b0400 	cfldrseq	mvf0, [fp], {-0}
     480:	000001cd 	andeq	r0, r0, sp, asr #3
     484:	000ad209 	andeq	sp, sl, r9, lsl #4
     488:	04090000 	streq	r0, [r9], #-0
     48c:	0100000d 	tsteq	r0, sp
     490:	00094909 	andeq	r4, r9, r9, lsl #18
     494:	0b000200 	bleq	c9c <shift+0xc9c>
     498:	000009b8 			; <UNDEFINED> instruction: 0x000009b8
     49c:	000a140c 	andeq	r1, sl, ip, lsl #8
     4a0:	63049000 	movwvs	r9, #16384	; 0x4000
     4a4:	00034007 	andeq	r4, r3, r7
     4a8:	0cb30600 	ldceq	6, cr0, [r3]
     4ac:	04240000 	strteq	r0, [r4], #-0
     4b0:	025a1067 	subseq	r1, sl, #103	; 0x67
     4b4:	c30d0000 	movwgt	r0, #53248	; 0xd000
     4b8:	0400001a 	streq	r0, [r0], #-26	; 0xffffffe6
     4bc:	03401269 	movteq	r1, #617	; 0x269
     4c0:	0d000000 	stceq	0, cr0, [r0, #-0]
     4c4:	000004e0 	andeq	r0, r0, r0, ror #9
     4c8:	50126b04 	andspl	r6, r2, r4, lsl #22
     4cc:	10000003 	andne	r0, r0, r3
     4d0:	000ac70d 	andeq	ip, sl, sp, lsl #14
     4d4:	166d0400 	strbtne	r0, [sp], -r0, lsl #8
     4d8:	0000004d 	andeq	r0, r0, sp, asr #32
     4dc:	052a0d14 	streq	r0, [sl, #-3348]!	; 0xfffff2ec
     4e0:	70040000 	andvc	r0, r4, r0
     4e4:	0003571c 	andeq	r5, r3, ip, lsl r7
     4e8:	c90d1800 	stmdbgt	sp, {fp, ip}
     4ec:	04000009 	streq	r0, [r0], #-9
     4f0:	03571c72 	cmpeq	r7, #29184	; 0x7200
     4f4:	0d1c0000 	ldceq	0, cr0, [ip, #-0]
     4f8:	000004b3 			; <UNDEFINED> instruction: 0x000004b3
     4fc:	571c7504 	ldrpl	r7, [ip, -r4, lsl #10]
     500:	20000003 	andcs	r0, r0, r3
     504:	0006d70e 	andeq	sp, r6, lr, lsl #14
     508:	1c770400 	cfldrdne	mvd0, [r7], #-0
     50c:	0000041d 	andeq	r0, r0, sp, lsl r4
     510:	00000357 	andeq	r0, r0, r7, asr r3
     514:	0000024e 	andeq	r0, r0, lr, asr #4
     518:	0003570f 	andeq	r5, r3, pc, lsl #14
     51c:	035d1000 	cmpeq	sp, #0
     520:	00000000 	andeq	r0, r0, r0
     524:	0005ce06 	andeq	ip, r5, r6, lsl #28
     528:	7b041800 	blvc	106530 <__bss_end+0xfd59c>
     52c:	00028f10 	andeq	r8, r2, r0, lsl pc
     530:	1ac30d00 	bne	ff0c3938 <__bss_end+0xff0ba9a4>
     534:	7e040000 	cdpvc	0, 0, cr0, cr4, cr0, {0}
     538:	00034012 	andeq	r4, r3, r2, lsl r0
     53c:	cb0d0000 	blgt	340544 <__bss_end+0x3375b0>
     540:	04000004 	streq	r0, [r0], #-4
     544:	035d1980 	cmpeq	sp, #128, 18	; 0x200000
     548:	0d100000 	ldceq	0, cr0, [r0, #-0]
     54c:	00000ce5 	andeq	r0, r0, r5, ror #25
     550:	68218204 	stmdavs	r1!, {r2, r9, pc}
     554:	14000003 	strne	r0, [r0], #-3
     558:	025a0300 	subseq	r0, sl, #0, 6
     55c:	bf110000 	svclt	0x00110000
     560:	04000008 	streq	r0, [r0], #-8
     564:	036e2186 	cmneq	lr, #-2147483615	; 0x80000021
     568:	57110000 	ldrpl	r0, [r1, -r0]
     56c:	04000007 	streq	r0, [r0], #-7
     570:	00591f88 	subseq	r1, r9, r8, lsl #31
     574:	4b0d0000 	blmi	34057c <__bss_end+0x3375e8>
     578:	0400000a 	streq	r0, [r0], #-10
     57c:	01df178b 	bicseq	r1, pc, fp, lsl #15
     580:	0d000000 	stceq	0, cr0, [r0, #-0]
     584:	0000083c 	andeq	r0, r0, ip, lsr r8
     588:	df178e04 	svcle	0x00178e04
     58c:	24000001 	strcs	r0, [r0], #-1
     590:	0007690d 	andeq	r6, r7, sp, lsl #18
     594:	178f0400 	strne	r0, [pc, r0, lsl #8]
     598:	000001df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     59c:	0d340d48 	ldceq	13, cr0, [r4, #-288]!	; 0xfffffee0
     5a0:	90040000 	andls	r0, r4, r0
     5a4:	0001df17 	andeq	sp, r1, r7, lsl pc
     5a8:	14126c00 	ldrne	r6, [r2], #-3072	; 0xfffff400
     5ac:	0400000a 	streq	r0, [r0], #-10
     5b0:	05b90993 	ldreq	r0, [r9, #2451]!	; 0x993
     5b4:	03790000 	cmneq	r9, #0
     5b8:	f9010000 			; <UNDEFINED> instruction: 0xf9010000
     5bc:	ff000002 			; <UNDEFINED> instruction: 0xff000002
     5c0:	0f000002 	svceq	0x00000002
     5c4:	00000379 	andeq	r0, r0, r9, ror r3
     5c8:	08b41300 	ldmeq	r4!, {r8, r9, ip}
     5cc:	96040000 	strls	r0, [r4], -r0
     5d0:	0008090e 	andeq	r0, r8, lr, lsl #18
     5d4:	03140100 	tsteq	r4, #0, 2
     5d8:	031a0000 	tsteq	sl, #0
     5dc:	790f0000 	stmdbvc	pc, {}	; <UNPREDICTABLE>
     5e0:	00000003 	andeq	r0, r0, r3
     5e4:	0003bc14 	andeq	fp, r3, r4, lsl ip
     5e8:	10990400 	addsne	r0, r9, r0, lsl #8
     5ec:	00000a89 	andeq	r0, r0, r9, lsl #21
     5f0:	0000037f 	andeq	r0, r0, pc, ror r3
     5f4:	00032f01 	andeq	r2, r3, r1, lsl #30
     5f8:	03790f00 	cmneq	r9, #0, 30
     5fc:	5d100000 	ldcpl	0, cr0, [r0, #-0]
     600:	10000003 	andne	r0, r0, r3
     604:	000001a8 	andeq	r0, r0, r8, lsr #3
     608:	25150000 	ldrcs	r0, [r5, #-0]
     60c:	50000000 	andpl	r0, r0, r0
     610:	16000003 	strne	r0, [r0], -r3
     614:	0000005e 	andeq	r0, r0, lr, asr r0
     618:	0102000f 	tsteq	r2, pc
     61c:	00084602 	andeq	r4, r8, r2, lsl #12
     620:	df041700 	svcle	0x00041700
     624:	17000001 	strne	r0, [r0, -r1]
     628:	00002c04 	andeq	r2, r0, r4, lsl #24
     62c:	0cf10b00 	vldmiaeq	r1!, {d16-d15}
     630:	04170000 	ldreq	r0, [r7], #-0
     634:	00000363 	andeq	r0, r0, r3, ror #6
     638:	00028f15 	andeq	r8, r2, r5, lsl pc
     63c:	00037900 	andeq	r7, r3, r0, lsl #18
     640:	17001800 	strne	r1, [r0, -r0, lsl #16]
     644:	0001d204 	andeq	sp, r1, r4, lsl #4
     648:	cd041700 	stcgt	7, cr1, [r4, #-0]
     64c:	19000001 	stmdbne	r0, {r0}
     650:	00000a51 	andeq	r0, r0, r1, asr sl
     654:	d2149c04 	andsle	r9, r4, #4, 24	; 0x400
     658:	0a000001 	beq	664 <shift+0x664>
     65c:	00000712 	andeq	r0, r0, r2, lsl r7
     660:	59140405 	ldmdbpl	r4, {r0, r2, sl}
     664:	05000000 	streq	r0, [r0, #-0]
     668:	008ef803 	addeq	pc, lr, r3, lsl #16
     66c:	03b10a00 			; <UNDEFINED> instruction: 0x03b10a00
     670:	07050000 	streq	r0, [r5, -r0]
     674:	00005914 	andeq	r5, r0, r4, lsl r9
     678:	fc030500 	stc2	5, cr0, [r3], {-0}
     67c:	0a00008e 	beq	8bc <shift+0x8bc>
     680:	00000595 	muleq	r0, r5, r5
     684:	59140a05 	ldmdbpl	r4, {r0, r2, r9, fp}
     688:	05000000 	streq	r0, [r0, #-0]
     68c:	008f0003 	addeq	r0, pc, r3
     690:	087b0800 	ldmdaeq	fp!, {fp}^
     694:	04050000 	streq	r0, [r5], #-0
     698:	00000038 	andeq	r0, r0, r8, lsr r0
     69c:	fe0c0d05 	vdot.bf16	d0, d12, d5[0]
     6a0:	1a000003 	bne	6b4 <shift+0x6b4>
     6a4:	0077654e 	rsbseq	r6, r7, lr, asr #10
     6a8:	08720900 	ldmdaeq	r2!, {r8, fp}^
     6ac:	09010000 	stmdbeq	r1, {}	; <UNPREDICTABLE>
     6b0:	00000a5d 	andeq	r0, r0, sp, asr sl
     6b4:	08550902 	ldmdaeq	r5, {r1, r8, fp}^
     6b8:	09030000 	stmdbeq	r3, {}	; <UNPREDICTABLE>
     6bc:	00000828 	andeq	r0, r0, r8, lsr #16
     6c0:	09540904 	ldmdbeq	r4, {r2, r8, fp}^
     6c4:	00050000 	andeq	r0, r5, r0
     6c8:	00068b06 	andeq	r8, r6, r6, lsl #22
     6cc:	1b051000 	blne	1446d4 <__bss_end+0x13b740>
     6d0:	00043d08 	andeq	r3, r4, r8, lsl #26
     6d4:	726c0700 	rsbvc	r0, ip, #0, 14
     6d8:	131d0500 	tstne	sp, #0, 10
     6dc:	0000043d 	andeq	r0, r0, sp, lsr r4
     6e0:	70730700 	rsbsvc	r0, r3, r0, lsl #14
     6e4:	131e0500 	tstne	lr, #0, 10
     6e8:	0000043d 	andeq	r0, r0, sp, lsr r4
     6ec:	63700704 	cmnvs	r0, #4, 14	; 0x100000
     6f0:	131f0500 	tstne	pc, #0, 10
     6f4:	0000043d 	andeq	r0, r0, sp, lsr r4
     6f8:	06a10d08 	strteq	r0, [r1], r8, lsl #26
     6fc:	20050000 	andcs	r0, r5, r0
     700:	00043d13 	andeq	r3, r4, r3, lsl sp
     704:	02000c00 	andeq	r0, r0, #0, 24
     708:	174e0704 	strbne	r0, [lr, -r4, lsl #14]
     70c:	10060000 	andne	r0, r6, r0
     710:	70000004 	andvc	r0, r0, r4
     714:	d4082805 	strle	r2, [r8], #-2053	; 0xfffff7fb
     718:	0d000004 	stceq	0, cr0, [r0, #-16]
     71c:	00000d3e 	andeq	r0, r0, lr, lsr sp
     720:	fe122a05 	vselvs.f32	s4, s4, s10
     724:	00000003 	andeq	r0, r0, r3
     728:	64697007 	strbtvs	r7, [r9], #-7
     72c:	122b0500 	eorne	r0, fp, #0, 10
     730:	0000005e 	andeq	r0, r0, lr, asr r0
     734:	149f0d10 	ldrne	r0, [pc], #3344	; 73c <shift+0x73c>
     738:	2c050000 	stccs	0, cr0, [r5], {-0}
     73c:	0003c711 	andeq	ip, r3, r1, lsl r7
     740:	900d1400 	andls	r1, sp, r0, lsl #8
     744:	05000008 	streq	r0, [r0, #-8]
     748:	005e122d 	subseq	r1, lr, sp, lsr #4
     74c:	0d180000 	ldceq	0, cr0, [r8, #-0]
     750:	0000089e 	muleq	r0, lr, r8
     754:	5e122e05 	cdppl	14, 1, cr2, cr2, cr5, {0}
     758:	1c000000 	stcne	0, cr0, [r0], {-0}
     75c:	0006740d 	andeq	r7, r6, sp, lsl #8
     760:	0c2f0500 	cfstr32eq	mvfx0, [pc], #-0	; 768 <shift+0x768>
     764:	000004d4 	ldrdeq	r0, [r0], -r4
     768:	08cb0d20 	stmiaeq	fp, {r5, r8, sl, fp}^
     76c:	30050000 	andcc	r0, r5, r0
     770:	00003809 	andeq	r3, r0, r9, lsl #16
     774:	dc0d6000 	stcle	0, cr6, [sp], {-0}
     778:	0500000a 	streq	r0, [r0, #-10]
     77c:	004d0e31 	subeq	r0, sp, r1, lsr lr
     780:	0d640000 	stcleq	0, cr0, [r4, #-0]
     784:	000006eb 	andeq	r0, r0, fp, ror #13
     788:	4d0e3305 	stcmi	3, cr3, [lr, #-20]	; 0xffffffec
     78c:	68000000 	stmdavs	r0, {}	; <UNPREDICTABLE>
     790:	0006e20d 	andeq	lr, r6, sp, lsl #4
     794:	0e340500 	cfabs32eq	mvfx0, mvfx4
     798:	0000004d 	andeq	r0, r0, sp, asr #32
     79c:	7f15006c 	svcvc	0x0015006c
     7a0:	e4000003 	str	r0, [r0], #-3
     7a4:	16000004 	strne	r0, [r0], -r4
     7a8:	0000005e 	andeq	r0, r0, lr, asr r0
     7ac:	a40a000f 	strge	r0, [sl], #-15
     7b0:	0600000c 	streq	r0, [r0], -ip
     7b4:	0059140a 	subseq	r1, r9, sl, lsl #8
     7b8:	03050000 	movweq	r0, #20480	; 0x5000
     7bc:	00008f04 	andeq	r8, r0, r4, lsl #30
     7c0:	00085d08 	andeq	r5, r8, r8, lsl #26
     7c4:	38040500 	stmdacc	r4, {r8, sl}
     7c8:	06000000 	streq	r0, [r0], -r0
     7cc:	05150c0d 	ldreq	r0, [r5, #-3085]	; 0xfffff3f3
     7d0:	06090000 	streq	r0, [r9], -r0
     7d4:	00000005 	andeq	r0, r0, r5
     7d8:	0003a609 	andeq	sl, r3, r9, lsl #12
     7dc:	06000100 	streq	r0, [r0], -r0, lsl #2
     7e0:	00000bc8 	andeq	r0, r0, r8, asr #23
     7e4:	081b060c 	ldmdaeq	fp, {r2, r3, r9, sl}
     7e8:	0000054a 	andeq	r0, r0, sl, asr #10
     7ec:	0003e20d 	andeq	lr, r3, sp, lsl #4
     7f0:	191d0600 	ldmdbne	sp, {r9, sl}
     7f4:	0000054a 	andeq	r0, r0, sl, asr #10
     7f8:	04b30d00 	ldrteq	r0, [r3], #3328	; 0xd00
     7fc:	1e060000 	cdpne	0, 0, cr0, cr6, cr0, {0}
     800:	00054a19 	andeq	r4, r5, r9, lsl sl
     804:	500d0400 	andpl	r0, sp, r0, lsl #8
     808:	0600000b 	streq	r0, [r0], -fp
     80c:	0550131f 	ldrbeq	r1, [r0, #-799]	; 0xfffffce1
     810:	00080000 	andeq	r0, r8, r0
     814:	05150417 	ldreq	r0, [r5, #-1047]	; 0xfffffbe9
     818:	04170000 	ldreq	r0, [r7], #-0
     81c:	00000444 	andeq	r0, r0, r4, asr #8
     820:	0005a80c 	andeq	sl, r5, ip, lsl #16
     824:	22061400 	andcs	r1, r6, #0, 8
     828:	0007d807 	andeq	sp, r7, r7, lsl #16
     82c:	084b0d00 	stmdaeq	fp, {r8, sl, fp}^
     830:	26060000 	strcs	r0, [r6], -r0
     834:	00004d12 	andeq	r4, r0, r2, lsl sp
     838:	600d0000 	andvs	r0, sp, r0
     83c:	06000004 	streq	r0, [r0], -r4
     840:	054a1d29 	strbeq	r1, [sl, #-3369]	; 0xfffff2d7
     844:	0d040000 	stceq	0, cr0, [r4, #-0]
     848:	00000a76 	andeq	r0, r0, r6, ror sl
     84c:	4a1d2c06 	bmi	74b86c <__bss_end+0x7428d8>
     850:	08000005 	stmdaeq	r0, {r0, r2}
     854:	000c7a1b 	andeq	r7, ip, fp, lsl sl
     858:	0e2f0600 	cfmadda32eq	mvax0, mvax0, mvfx15, mvfx0
     85c:	00000ba5 	andeq	r0, r0, r5, lsr #23
     860:	0000059e 	muleq	r0, lr, r5
     864:	000005a9 	andeq	r0, r0, r9, lsr #11
     868:	0007dd0f 	andeq	sp, r7, pc, lsl #26
     86c:	054a1000 	strbeq	r1, [sl, #-0]
     870:	1c000000 	stcne	0, cr0, [r0], {-0}
     874:	00000b5e 	andeq	r0, r0, lr, asr fp
     878:	e70e3106 	str	r3, [lr, -r6, lsl #2]
     87c:	50000003 	andpl	r0, r0, r3
     880:	c1000003 	tstgt	r0, r3
     884:	cc000005 	stcgt	0, cr0, [r0], {5}
     888:	0f000005 	svceq	0x00000005
     88c:	000007dd 	ldrdeq	r0, [r0], -sp
     890:	00055010 	andeq	r5, r5, r0, lsl r0
     894:	db120000 	blle	48089c <__bss_end+0x477908>
     898:	0600000b 	streq	r0, [r0], -fp
     89c:	0b2b1d35 	bleq	ac7d78 <__bss_end+0xabede4>
     8a0:	054a0000 	strbeq	r0, [sl, #-0]
     8a4:	e5020000 	str	r0, [r2, #-0]
     8a8:	eb000005 	bl	8c4 <shift+0x8c4>
     8ac:	0f000005 	svceq	0x00000005
     8b0:	000007dd 	ldrdeq	r0, [r0], -sp
     8b4:	07df1200 	ldrbeq	r1, [pc, r0, lsl #4]
     8b8:	37060000 	strcc	r0, [r6, -r0]
     8bc:	0009ee1d 	andeq	lr, r9, sp, lsl lr
     8c0:	00054a00 	andeq	r4, r5, r0, lsl #20
     8c4:	06040200 	streq	r0, [r4], -r0, lsl #4
     8c8:	060a0000 	streq	r0, [sl], -r0
     8cc:	dd0f0000 	stcle	0, cr0, [pc, #-0]	; 8d4 <shift+0x8d4>
     8d0:	00000007 	andeq	r0, r0, r7
     8d4:	0008df1d 	andeq	sp, r8, sp, lsl pc
     8d8:	31390600 	teqcc	r9, r0, lsl #12
     8dc:	000007f6 	strdeq	r0, [r0], -r6
     8e0:	a812020c 	ldmdage	r2, {r2, r3, r9}
     8e4:	06000005 	streq	r0, [r0], -r5
     8e8:	0d1a093c 	vldreq.16	s0, [sl, #-120]	; 0xffffff88	; <UNPREDICTABLE>
     8ec:	07dd0000 	ldrbeq	r0, [sp, r0]
     8f0:	31010000 	mrscc	r0, (UNDEF: 1)
     8f4:	37000006 	strcc	r0, [r0, -r6]
     8f8:	0f000006 	svceq	0x00000006
     8fc:	000007dd 	ldrdeq	r0, [r0], -sp
     900:	051b1200 	ldreq	r1, [fp, #-512]	; 0xfffffe00
     904:	3f060000 	svccc	0x00060000
     908:	000c4f12 	andeq	r4, ip, r2, lsl pc
     90c:	00004d00 	andeq	r4, r0, r0, lsl #26
     910:	06500100 	ldrbeq	r0, [r0], -r0, lsl #2
     914:	06650000 	strbteq	r0, [r5], -r0
     918:	dd0f0000 	stcle	0, cr0, [pc, #-0]	; 920 <shift+0x920>
     91c:	10000007 	andne	r0, r0, r7
     920:	000007ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     924:	00005e10 	andeq	r5, r0, r0, lsl lr
     928:	03501000 	cmpeq	r0, #0
     92c:	13000000 	movwne	r0, #0
     930:	00000b6d 	andeq	r0, r0, sp, ror #22
     934:	6a0e4206 	bvs	391154 <__bss_end+0x3881c0>
     938:	01000009 	tsteq	r0, r9
     93c:	0000067a 	andeq	r0, r0, sl, ror r6
     940:	00000680 	andeq	r0, r0, r0, lsl #13
     944:	0007dd0f 	andeq	sp, r7, pc, lsl #26
     948:	73120000 	tstvc	r2, #0
     94c:	06000007 	streq	r0, [r0], -r7
     950:	047d1745 	ldrbteq	r1, [sp], #-1861	; 0xfffff8bb
     954:	05500000 	ldrbeq	r0, [r0, #-0]
     958:	99010000 	stmdbls	r1, {}	; <UNPREDICTABLE>
     95c:	9f000006 	svcls	0x00000006
     960:	0f000006 	svceq	0x00000006
     964:	00000805 	andeq	r0, r0, r5, lsl #16
     968:	04b81200 	ldrteq	r1, [r8], #512	; 0x200
     96c:	48060000 	stmdami	r6, {}	; <UNPREDICTABLE>
     970:	000ae817 	andeq	lr, sl, r7, lsl r8
     974:	00055000 	andeq	r5, r5, r0
     978:	06b80100 	ldrteq	r0, [r8], r0, lsl #2
     97c:	06c30000 	strbeq	r0, [r3], r0
     980:	050f0000 	streq	r0, [pc, #-0]	; 988 <shift+0x988>
     984:	10000008 	andne	r0, r0, r8
     988:	0000004d 	andeq	r0, r0, sp, asr #32
     98c:	0cc11300 	stcleq	3, cr1, [r1], {0}
     990:	4b060000 	blmi	180998 <__bss_end+0x177a04>
     994:	000b760e 	andeq	r7, fp, lr, lsl #12
     998:	06d80100 	ldrbeq	r0, [r8], r0, lsl #2
     99c:	06de0000 	ldrbeq	r0, [lr], r0
     9a0:	dd0f0000 	stcle	0, cr0, [pc, #-0]	; 9a8 <shift+0x9a8>
     9a4:	00000007 	andeq	r0, r0, r7
     9a8:	000b5e12 	andeq	r5, fp, r2, lsl lr
     9ac:	0e4d0600 	cdpeq	6, 4, cr0, cr13, cr0, {0}
     9b0:	000006a7 	andeq	r0, r0, r7, lsr #13
     9b4:	00000350 	andeq	r0, r0, r0, asr r3
     9b8:	0006f701 	andeq	pc, r6, r1, lsl #14
     9bc:	00070200 	andeq	r0, r7, r0, lsl #4
     9c0:	07dd0f00 	ldrbeq	r0, [sp, r0, lsl #30]
     9c4:	4d100000 	ldcmi	0, cr0, [r0, #-0]
     9c8:	00000000 	andeq	r0, r0, r0
     9cc:	00078712 	andeq	r8, r7, r2, lsl r7
     9d0:	12500600 	subsne	r0, r0, #0, 12
     9d4:	0000098b 	andeq	r0, r0, fp, lsl #19
     9d8:	0000004d 	andeq	r0, r0, sp, asr #32
     9dc:	00071b01 	andeq	r1, r7, r1, lsl #22
     9e0:	00072600 	andeq	r2, r7, r0, lsl #12
     9e4:	07dd0f00 	ldrbeq	r0, [sp, r0, lsl #30]
     9e8:	7f100000 	svcvc	0x00100000
     9ec:	00000003 	andeq	r0, r0, r3
     9f0:	00044d12 	andeq	r4, r4, r2, lsl sp
     9f4:	0e530600 	cdpeq	6, 5, cr0, cr3, cr0, {0}
     9f8:	0000072b 	andeq	r0, r0, fp, lsr #14
     9fc:	00000350 	andeq	r0, r0, r0, asr r3
     a00:	00073f01 	andeq	r3, r7, r1, lsl #30
     a04:	00074a00 	andeq	r4, r7, r0, lsl #20
     a08:	07dd0f00 	ldrbeq	r0, [sp, r0, lsl #30]
     a0c:	4d100000 	ldcmi	0, cr0, [r0, #-0]
     a10:	00000000 	andeq	r0, r0, r0
     a14:	0007b913 	andeq	fp, r7, r3, lsl r9
     a18:	0e560600 	cdpeq	6, 5, cr0, cr6, cr0, {0}
     a1c:	00000be7 	andeq	r0, r0, r7, ror #23
     a20:	00075f01 	andeq	r5, r7, r1, lsl #30
     a24:	00077e00 	andeq	r7, r7, r0, lsl #28
     a28:	07dd0f00 	ldrbeq	r0, [sp, r0, lsl #30]
     a2c:	8b100000 	blhi	400a34 <__bss_end+0x3f7aa0>
     a30:	10000000 	andne	r0, r0, r0
     a34:	0000004d 	andeq	r0, r0, sp, asr #32
     a38:	00004d10 	andeq	r4, r0, r0, lsl sp
     a3c:	004d1000 	subeq	r1, sp, r0
     a40:	0b100000 	bleq	400a48 <__bss_end+0x3f7ab4>
     a44:	00000008 	andeq	r0, r0, r8
     a48:	000b1513 	andeq	r1, fp, r3, lsl r5
     a4c:	0e580600 	cdpeq	6, 5, cr0, cr8, cr0, {0}
     a50:	0000061c 	andeq	r0, r0, ip, lsl r6
     a54:	00079301 	andeq	r9, r7, r1, lsl #6
     a58:	0007b200 	andeq	fp, r7, r0, lsl #4
     a5c:	07dd0f00 	ldrbeq	r0, [sp, r0, lsl #30]
     a60:	c2100000 	andsgt	r0, r0, #0
     a64:	10000000 	andne	r0, r0, r0
     a68:	0000004d 	andeq	r0, r0, sp, asr #32
     a6c:	00004d10 	andeq	r4, r0, r0, lsl sp
     a70:	004d1000 	subeq	r1, sp, r0
     a74:	0b100000 	bleq	400a7c <__bss_end+0x3f7ae8>
     a78:	00000008 	andeq	r0, r0, r8
     a7c:	00058214 	andeq	r8, r5, r4, lsl r2
     a80:	0e5b0600 	cdpeq	6, 5, cr0, cr11, cr0, {0}
     a84:	000005d9 	ldrdeq	r0, [r0], -r9
     a88:	00000350 	andeq	r0, r0, r0, asr r3
     a8c:	0007c701 	andeq	ip, r7, r1, lsl #14
     a90:	07dd0f00 	ldrbeq	r0, [sp, r0, lsl #30]
     a94:	f6100000 			; <UNDEFINED> instruction: 0xf6100000
     a98:	10000004 	andne	r0, r0, r4
     a9c:	00000811 	andeq	r0, r0, r1, lsl r8
     aa0:	56030000 	strpl	r0, [r3], -r0
     aa4:	17000005 	strne	r0, [r0, -r5]
     aa8:	00055604 	andeq	r5, r5, r4, lsl #12
     aac:	054a1e00 	strbeq	r1, [sl, #-3584]	; 0xfffff200
     ab0:	07f00000 	ldrbeq	r0, [r0, r0]!
     ab4:	07f60000 	ldrbeq	r0, [r6, r0]!
     ab8:	dd0f0000 	stcle	0, cr0, [pc, #-0]	; ac0 <shift+0xac0>
     abc:	00000007 	andeq	r0, r0, r7
     ac0:	0005561f 	andeq	r5, r5, pc, lsl r6
     ac4:	0007e300 	andeq	lr, r7, r0, lsl #6
     ac8:	3f041700 	svccc	0x00041700
     acc:	17000000 	strne	r0, [r0, -r0]
     ad0:	0007d804 	andeq	sp, r7, r4, lsl #16
     ad4:	65042000 	strvs	r2, [r4, #-0]
     ad8:	21000000 	mrscs	r0, (UNDEF: 0)
     adc:	08ed1904 	stmiaeq	sp!, {r2, r8, fp, ip}^
     ae0:	5e060000 	cdppl	0, 0, cr0, cr6, cr0, {0}
     ae4:	00055619 	andeq	r5, r5, r9, lsl r6
     ae8:	03c10800 	biceq	r0, r1, #0, 16
     aec:	04050000 	streq	r0, [r5], #-0
     af0:	00000038 	andeq	r0, r0, r8, lsr r0
     af4:	3e0c0307 	cdpcc	3, 0, cr0, cr12, cr7, {0}
     af8:	09000008 	stmdbeq	r0, {r3}
     afc:	00000704 	andeq	r0, r0, r4, lsl #14
     b00:	070b0900 	streq	r0, [fp, -r0, lsl #18]
     b04:	00010000 	andeq	r0, r1, r0
     b08:	0006f408 	andeq	pc, r6, r8, lsl #8
     b0c:	38040500 	stmdacc	r4, {r8, sl}
     b10:	07000000 	streq	r0, [r0, -r0]
     b14:	088b0c09 	stmeq	fp, {r0, r3, sl, fp}
     b18:	9c220000 	stcls	0, cr0, [r2], #-0
     b1c:	b000000c 	andlt	r0, r0, ip
     b20:	03da2204 	bicseq	r2, sl, #4, 4	; 0x40000000
     b24:	09600000 	stmdbeq	r0!, {}^	; <UNPREDICTABLE>
     b28:	0004ab22 	andeq	sl, r4, r2, lsr #22
     b2c:	2212c000 	andscs	ip, r2, #0
     b30:	00000cd7 	ldrdeq	r0, [r0], -r7
     b34:	55222580 	strpl	r2, [r2, #-1408]!	; 0xfffffa80
     b38:	0000000b 	andeq	r0, r0, fp
     b3c:	0887224b 	stmeq	r7, {r0, r1, r3, r6, r9, sp}
     b40:	96000000 	strls	r0, [r0], -r0
     b44:	00039d22 	andeq	r9, r3, r2, lsr #26
     b48:	23e10000 	mvncs	r0, #0
     b4c:	000008d5 	ldrdeq	r0, [r0], -r5
     b50:	0001c200 	andeq	ip, r1, r0, lsl #4
     b54:	09360600 	ldmdbeq	r6!, {r9, sl}
     b58:	07080000 	streq	r0, [r8, -r0]
     b5c:	08b30816 	ldmeq	r3!, {r1, r2, r4, fp}
     b60:	b40d0000 	strlt	r0, [sp], #-0
     b64:	0700000a 	streq	r0, [r0, -sl]
     b68:	081f1718 	ldmdaeq	pc, {r3, r4, r8, r9, sl, ip}	; <UNPREDICTABLE>
     b6c:	0d000000 	stceq	0, cr0, [r0, #-0]
     b70:	00000473 	andeq	r0, r0, r3, ror r4
     b74:	3e151907 	vnmlscc.f16	s2, s10, s14	; <UNPREDICTABLE>
     b78:	04000008 	streq	r0, [r0], #-8
     b7c:	0d0f2400 	cfstrseq	mvf2, [pc, #-0]	; b84 <shift+0xb84>
     b80:	12010000 	andne	r0, r1, #0
     b84:	00003805 	andeq	r3, r0, r5, lsl #16
     b88:	00827400 	addeq	r7, r2, r0, lsl #8
     b8c:	00014400 	andeq	r4, r1, r0, lsl #8
     b90:	799c0100 	ldmibvc	ip, {r8}
     b94:	25000009 	strcs	r0, [r0, #-9]
     b98:	00000cec 	andeq	r0, r0, ip, ror #25
     b9c:	380e1201 	stmdacc	lr, {r0, r9, ip}
     ba0:	03000000 	movweq	r0, #0
     ba4:	257fb491 	ldrbcs	fp, [pc, #-1169]!	; 71b <shift+0x71b>
     ba8:	00000c39 	andeq	r0, r0, r9, lsr ip
     bac:	791b1201 	ldmdbvc	fp, {r0, r9, ip}
     bb0:	03000009 	movweq	r0, #9
     bb4:	267fb091 			; <UNDEFINED> instruction: 0x267fb091
     bb8:	00000a2a 	andeq	r0, r0, sl, lsr #20
     bbc:	4d0b1401 	cfstrsmi	mvf1, [fp, #-4]
     bc0:	02000000 	andeq	r0, r0, #0
     bc4:	c0267491 	mlagt	r6, r1, r4, r7
     bc8:	0100000a 	tsteq	r0, sl
     bcc:	088b1516 	stmeq	fp, {r1, r2, r4, r8, sl, ip}
     bd0:	91020000 	mrsls	r0, (UNDEF: 2)
     bd4:	7562275c 	strbvc	r2, [r2, #-1884]!	; 0xfffff8a4
     bd8:	1d010066 	stcne	0, cr0, [r1, #-408]	; 0xfffffe68
     bdc:	00034007 	andeq	r4, r3, r7
     be0:	4c910200 	lfmmi	f0, 4, [r1], {0}
     be4:	000a6e26 	andeq	r6, sl, r6, lsr #28
     be8:	071e0100 	ldreq	r0, [lr, -r0, lsl #2]
     bec:	00000340 	andeq	r0, r0, r0, asr #6
     bf0:	7fbc9103 	svcvc	0x00bc9103
     bf4:	0004d626 	andeq	sp, r4, r6, lsr #12
     bf8:	0b220100 	bleq	881000 <__bss_end+0x87806c>
     bfc:	0000004d 	andeq	r0, r0, sp, asr #32
     c00:	26709102 	ldrbtcs	r9, [r0], -r2, lsl #2
     c04:	00000d5a 	andeq	r0, r0, sl, asr sp
     c08:	4d0b2401 	cfstrsmi	mvf2, [fp, #-4]
     c0c:	02000000 	andeq	r0, r0, #0
     c10:	00286c91 	mlaeq	r8, r1, ip, r6
     c14:	9c000083 	stcls	0, cr0, [r0], {131}	; 0x83
     c18:	27000000 	strcs	r0, [r0, -r0]
     c1c:	2a010076 	bcs	40dfc <__bss_end+0x37e68>
     c20:	00004d0c 	andeq	r4, r0, ip, lsl #26
     c24:	68910200 	ldmvs	r1, {r9}
     c28:	00833428 	addeq	r3, r3, r8, lsr #8
     c2c:	00006800 	andeq	r6, r0, r0, lsl #16
     c30:	04db2600 	ldrbeq	r2, [fp], #1536	; 0x600
     c34:	2f010000 	svccs	0x00010000
     c38:	00004d0d 	andeq	r4, r0, sp, lsl #26
     c3c:	64910200 	ldrvs	r0, [r1], #512	; 0x200
     c40:	17000000 	strne	r0, [r0, -r0]
     c44:	00097f04 	andeq	r7, r9, r4, lsl #30
     c48:	25041700 	strcs	r1, [r4, #-1792]	; 0xfffff900
     c4c:	29000000 	stmdbcs	r0, {}	; <UNPREDICTABLE>
     c50:	00000924 	andeq	r0, r0, r4, lsr #18
     c54:	380d0d01 	stmdacc	sp, {r0, r8, sl, fp}
     c58:	3c000082 	stccc	0, cr0, [r0], {130}	; 0x82
     c5c:	01000000 	mrseq	r0, (UNDEF: 0)
     c60:	0a2f259c 	beq	bca2d8 <__bss_end+0xbc1344>
     c64:	0d010000 	stceq	0, cr0, [r1, #-0]
     c68:	00004d1c 	andeq	r4, r0, ip, lsl sp
     c6c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     c70:	0003d325 	andeq	sp, r3, r5, lsr #6
     c74:	2e0d0100 	adfcse	f0, f5, f0
     c78:	0000035d 	andeq	r0, r0, sp, asr r3
     c7c:	00709102 	rsbseq	r9, r0, r2, lsl #2
     c80:	000cd700 	andeq	sp, ip, r0, lsl #14
     c84:	30000400 	andcc	r0, r0, r0, lsl #8
     c88:	04000004 	streq	r0, [r0], #-4
     c8c:	00105301 	andseq	r5, r0, r1, lsl #6
     c90:	0dce0400 	cfstrdeq	mvd0, [lr]
     c94:	0e7c0000 	cdpeq	0, 7, cr0, cr12, cr0, {0}
     c98:	83b80000 			; <UNDEFINED> instruction: 0x83b80000
     c9c:	045c0000 	ldrbeq	r0, [ip], #-0
     ca0:	040b0000 	streq	r0, [fp], #-0
     ca4:	01020000 	mrseq	r0, (UNDEF: 2)
     ca8:	0009e908 	andeq	lr, r9, r8, lsl #18
     cac:	00250300 	eoreq	r0, r5, r0, lsl #6
     cb0:	02020000 	andeq	r0, r2, #0
     cb4:	000a2005 	andeq	r2, sl, r5
     cb8:	05040400 	streq	r0, [r4, #-1024]	; 0xfffffc00
     cbc:	00746e69 	rsbseq	r6, r4, r9, ror #28
     cc0:	e0080102 	and	r0, r8, r2, lsl #2
     cc4:	02000009 	andeq	r0, r0, #9
     cc8:	07cc0702 	strbeq	r0, [ip, r2, lsl #14]
     ccc:	65050000 	strvs	r0, [r5, #-0]
     cd0:	0700000a 	streq	r0, [r0, -sl]
     cd4:	005e0709 	subseq	r0, lr, r9, lsl #14
     cd8:	4d030000 	stcmi	0, cr0, [r3, #-0]
     cdc:	02000000 	andeq	r0, r0, #0
     ce0:	17530704 	ldrbne	r0, [r3, -r4, lsl #14]
     ce4:	68060000 	stmdavs	r6, {}	; <UNPREDICTABLE>
     ce8:	08000006 	stmdaeq	r0, {r1, r2}
     cec:	8b080602 	blhi	2024fc <__bss_end+0x1f9568>
     cf0:	07000000 	streq	r0, [r0, -r0]
     cf4:	02003072 	andeq	r3, r0, #114	; 0x72
     cf8:	004d0e08 	subeq	r0, sp, r8, lsl #28
     cfc:	07000000 	streq	r0, [r0, -r0]
     d00:	02003172 	andeq	r3, r0, #-2147483620	; 0x8000001c
     d04:	004d0e09 	subeq	r0, sp, r9, lsl #28
     d08:	00040000 	andeq	r0, r4, r0
     d0c:	000f9208 	andeq	r9, pc, r8, lsl #4
     d10:	38040500 	stmdacc	r4, {r8, sl}
     d14:	02000000 	andeq	r0, r0, #0
     d18:	00a90c0d 	adceq	r0, r9, sp, lsl #24
     d1c:	4f090000 	svcmi	0x00090000
     d20:	0a00004b 	beq	e54 <shift+0xe54>
     d24:	00000e05 	andeq	r0, r0, r5, lsl #28
     d28:	ec080001 	stc	0, cr0, [r8], {1}
     d2c:	05000004 	streq	r0, [r0, #-4]
     d30:	00003804 	andeq	r3, r0, r4, lsl #16
     d34:	0c1e0200 	lfmeq	f0, 4, [lr], {-0}
     d38:	000000e0 	andeq	r0, r0, r0, ror #1
     d3c:	0006cf0a 	andeq	ip, r6, sl, lsl #30
     d40:	4a0a0000 	bmi	280d48 <__bss_end+0x277db4>
     d44:	0100000d 	tsteq	r0, sp
     d48:	000d140a 	andeq	r1, sp, sl, lsl #8
     d4c:	360a0200 	strcc	r0, [sl], -r0, lsl #4
     d50:	03000008 	movweq	r0, #8
     d54:	00095b0a 	andeq	r5, r9, sl, lsl #22
     d58:	980a0400 	stmdals	sl, {sl}
     d5c:	05000006 	streq	r0, [r0, #-6]
     d60:	0c840800 	stceq	8, cr0, [r4], {0}
     d64:	04050000 	streq	r0, [r5], #-0
     d68:	00000038 	andeq	r0, r0, r8, lsr r0
     d6c:	1d0c3f02 	stcne	15, cr3, [ip, #-8]
     d70:	0a000001 	beq	d7c <shift+0xd7c>
     d74:	000003bc 			; <UNDEFINED> instruction: 0x000003bc
     d78:	05010a00 	streq	r0, [r1, #-2560]	; 0xfffff600
     d7c:	0a010000 	beq	40d84 <__bss_end+0x37df0>
     d80:	0000094e 	andeq	r0, r0, lr, asr #18
     d84:	0cdf0a02 	vldmiaeq	pc, {s1-s2}
     d88:	0a030000 	beq	c0d90 <__bss_end+0xb7dfc>
     d8c:	00000d54 	andeq	r0, r0, r4, asr sp
     d90:	090f0a04 	stmdbeq	pc, {r2, r9, fp}	; <UNPREDICTABLE>
     d94:	0a050000 	beq	140d9c <__bss_end+0x137e08>
     d98:	000007ec 	andeq	r0, r0, ip, ror #15
     d9c:	3e080006 	cdpcc	0, 0, cr0, cr8, cr6, {0}
     da0:	0500000c 	streq	r0, [r0, #-12]
     da4:	00003804 	andeq	r3, r0, r4, lsl #16
     da8:	0c660200 	sfmeq	f0, 2, [r6], #-0
     dac:	00000148 	andeq	r0, r0, r8, asr #2
     db0:	0009be0a 	andeq	fp, r9, sl, lsl #28
     db4:	ae0a0000 	cdpge	0, 0, cr0, cr10, cr0, {0}
     db8:	01000007 	tsteq	r0, r7
     dbc:	000a340a 	andeq	r3, sl, sl, lsl #8
     dc0:	f10a0200 			; <UNDEFINED> instruction: 0xf10a0200
     dc4:	03000007 	movweq	r0, #7
     dc8:	09160b00 	ldmdbeq	r6, {r8, r9, fp}
     dcc:	05030000 	streq	r0, [r3, #-0]
     dd0:	00005914 	andeq	r5, r0, r4, lsl r9
     dd4:	38030500 	stmdacc	r3, {r8, sl}
     dd8:	0b00008f 	bleq	101c <shift+0x101c>
     ddc:	0000092a 	andeq	r0, r0, sl, lsr #18
     de0:	59140603 	ldmdbpl	r4, {r0, r1, r9, sl}
     de4:	05000000 	streq	r0, [r0, #-0]
     de8:	008f3c03 	addeq	r3, pc, r3, lsl #24
     dec:	08f90b00 	ldmeq	r9!, {r8, r9, fp}^
     df0:	07040000 	streq	r0, [r4, -r0]
     df4:	0000591a 	andeq	r5, r0, sl, lsl r9
     df8:	40030500 	andmi	r0, r3, r0, lsl #10
     dfc:	0b00008f 	bleq	1040 <shift+0x1040>
     e00:	00000531 	andeq	r0, r0, r1, lsr r5
     e04:	591a0904 	ldmdbpl	sl, {r2, r8, fp}
     e08:	05000000 	streq	r0, [r0, #-0]
     e0c:	008f4403 	addeq	r4, pc, r3, lsl #8
     e10:	09d20b00 	ldmibeq	r2, {r8, r9, fp}^
     e14:	0b040000 	bleq	100e1c <__bss_end+0xf7e88>
     e18:	0000591a 	andeq	r5, r0, sl, lsl r9
     e1c:	48030500 	stmdami	r3, {r8, sl}
     e20:	0b00008f 	bleq	1064 <shift+0x1064>
     e24:	0000079b 	muleq	r0, fp, r7
     e28:	591a0d04 	ldmdbpl	sl, {r2, r8, sl, fp}
     e2c:	05000000 	streq	r0, [r0, #-0]
     e30:	008f4c03 	addeq	r4, pc, r3, lsl #24
     e34:	06810b00 	streq	r0, [r1], r0, lsl #22
     e38:	0f040000 	svceq	0x00040000
     e3c:	0000591a 	andeq	r5, r0, sl, lsl r9
     e40:	50030500 	andpl	r0, r3, r0, lsl #10
     e44:	0800008f 	stmdaeq	r0, {r0, r1, r2, r3, r7}
     e48:	00000aa4 	andeq	r0, r0, r4, lsr #21
     e4c:	00380405 	eorseq	r0, r8, r5, lsl #8
     e50:	1b040000 	blne	100e58 <__bss_end+0xf7ec4>
     e54:	0001eb0c 	andeq	lr, r1, ip, lsl #22
     e58:	0ad20a00 	beq	ff483660 <__bss_end+0xff47a6cc>
     e5c:	0a000000 	beq	e64 <shift+0xe64>
     e60:	00000d04 	andeq	r0, r0, r4, lsl #26
     e64:	09490a01 	stmdbeq	r9, {r0, r9, fp}^
     e68:	00020000 	andeq	r0, r2, r0
     e6c:	0009b80c 	andeq	fp, r9, ip, lsl #16
     e70:	0a140d00 	beq	504278 <__bss_end+0x4fb2e4>
     e74:	04900000 	ldreq	r0, [r0], #0
     e78:	035e0763 	cmpeq	lr, #25952256	; 0x18c0000
     e7c:	b3060000 	movwlt	r0, #24576	; 0x6000
     e80:	2400000c 	strcs	r0, [r0], #-12
     e84:	78106704 	ldmdavc	r0, {r2, r8, r9, sl, sp, lr}
     e88:	0e000002 	cdpeq	0, 0, cr0, cr0, cr2, {0}
     e8c:	00001ac3 	andeq	r1, r0, r3, asr #21
     e90:	5e126904 	vnmlspl.f16	s12, s4, s8	; <UNPREDICTABLE>
     e94:	00000003 	andeq	r0, r0, r3
     e98:	0004e00e 	andeq	lr, r4, lr
     e9c:	126b0400 	rsbne	r0, fp, #0, 8
     ea0:	0000036e 	andeq	r0, r0, lr, ror #6
     ea4:	0ac70e10 	beq	ff1c46ec <__bss_end+0xff1bb758>
     ea8:	6d040000 	stcvs	0, cr0, [r4, #-0]
     eac:	00004d16 	andeq	r4, r0, r6, lsl sp
     eb0:	2a0e1400 	bcs	385eb8 <__bss_end+0x37cf24>
     eb4:	04000005 	streq	r0, [r0], #-5
     eb8:	03751c70 	cmneq	r5, #112, 24	; 0x7000
     ebc:	0e180000 	cdpeq	0, 1, cr0, cr8, cr0, {0}
     ec0:	000009c9 	andeq	r0, r0, r9, asr #19
     ec4:	751c7204 	ldrvc	r7, [ip, #-516]	; 0xfffffdfc
     ec8:	1c000003 	stcne	0, cr0, [r0], {3}
     ecc:	0004b30e 	andeq	fp, r4, lr, lsl #6
     ed0:	1c750400 	cfldrdne	mvd0, [r5], #-0
     ed4:	00000375 	andeq	r0, r0, r5, ror r3
     ed8:	06d70f20 	ldrbeq	r0, [r7], r0, lsr #30
     edc:	77040000 	strvc	r0, [r4, -r0]
     ee0:	00041d1c 	andeq	r1, r4, ip, lsl sp
     ee4:	00037500 	andeq	r7, r3, r0, lsl #10
     ee8:	00026c00 	andeq	r6, r2, r0, lsl #24
     eec:	03751000 	cmneq	r5, #0
     ef0:	7b110000 	blvc	440ef8 <__bss_end+0x437f64>
     ef4:	00000003 	andeq	r0, r0, r3
     ef8:	05ce0600 	strbeq	r0, [lr, #1536]	; 0x600
     efc:	04180000 	ldreq	r0, [r8], #-0
     f00:	02ad107b 	adceq	r1, sp, #123	; 0x7b
     f04:	c30e0000 	movwgt	r0, #57344	; 0xe000
     f08:	0400001a 	streq	r0, [r0], #-26	; 0xffffffe6
     f0c:	035e127e 	cmpeq	lr, #-536870905	; 0xe0000007
     f10:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     f14:	000004cb 	andeq	r0, r0, fp, asr #9
     f18:	7b198004 	blvc	660f30 <__bss_end+0x657f9c>
     f1c:	10000003 	andne	r0, r0, r3
     f20:	000ce50e 	andeq	lr, ip, lr, lsl #10
     f24:	21820400 	orrcs	r0, r2, r0, lsl #8
     f28:	00000386 	andeq	r0, r0, r6, lsl #7
     f2c:	78030014 	stmdavc	r3, {r2, r4}
     f30:	12000002 	andne	r0, r0, #2
     f34:	000008bf 			; <UNDEFINED> instruction: 0x000008bf
     f38:	8c218604 	stchi	6, cr8, [r1], #-16
     f3c:	12000003 	andne	r0, r0, #3
     f40:	00000757 	andeq	r0, r0, r7, asr r7
     f44:	591f8804 	ldmdbpl	pc, {r2, fp, pc}	; <UNPREDICTABLE>
     f48:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     f4c:	00000a4b 	andeq	r0, r0, fp, asr #20
     f50:	fd178b04 	ldc2	11, cr8, [r7, #-16]	; <UNPREDICTABLE>
     f54:	00000001 	andeq	r0, r0, r1
     f58:	00083c0e 	andeq	r3, r8, lr, lsl #24
     f5c:	178e0400 	strne	r0, [lr, r0, lsl #8]
     f60:	000001fd 	strdeq	r0, [r0], -sp
     f64:	07690e24 	strbeq	r0, [r9, -r4, lsr #28]!
     f68:	8f040000 	svchi	0x00040000
     f6c:	0001fd17 	andeq	pc, r1, r7, lsl sp	; <UNPREDICTABLE>
     f70:	340e4800 	strcc	r4, [lr], #-2048	; 0xfffff800
     f74:	0400000d 	streq	r0, [r0], #-13
     f78:	01fd1790 			; <UNDEFINED> instruction: 0x01fd1790
     f7c:	136c0000 	cmnne	ip, #0
     f80:	00000a14 	andeq	r0, r0, r4, lsl sl
     f84:	b9099304 	stmdblt	r9, {r2, r8, r9, ip, pc}
     f88:	97000005 	strls	r0, [r0, -r5]
     f8c:	01000003 	tsteq	r0, r3
     f90:	00000317 	andeq	r0, r0, r7, lsl r3
     f94:	0000031d 	andeq	r0, r0, sp, lsl r3
     f98:	00039710 	andeq	r9, r3, r0, lsl r7
     f9c:	b4140000 	ldrlt	r0, [r4], #-0
     fa0:	04000008 	streq	r0, [r0], #-8
     fa4:	08090e96 	stmdaeq	r9, {r1, r2, r4, r7, r9, sl, fp}
     fa8:	32010000 	andcc	r0, r1, #0
     fac:	38000003 	stmdacc	r0, {r0, r1}
     fb0:	10000003 	andne	r0, r0, r3
     fb4:	00000397 	muleq	r0, r7, r3
     fb8:	03bc1500 			; <UNDEFINED> instruction: 0x03bc1500
     fbc:	99040000 	stmdbls	r4, {}	; <UNPREDICTABLE>
     fc0:	000a8910 	andeq	r8, sl, r0, lsl r9
     fc4:	00039d00 	andeq	r9, r3, r0, lsl #26
     fc8:	034d0100 	movteq	r0, #53504	; 0xd100
     fcc:	97100000 	ldrls	r0, [r0, -r0]
     fd0:	11000003 	tstne	r0, r3
     fd4:	0000037b 	andeq	r0, r0, fp, ror r3
     fd8:	0001c611 	andeq	ip, r1, r1, lsl r6
     fdc:	16000000 	strne	r0, [r0], -r0
     fe0:	00000025 	andeq	r0, r0, r5, lsr #32
     fe4:	0000036e 	andeq	r0, r0, lr, ror #6
     fe8:	00005e17 	andeq	r5, r0, r7, lsl lr
     fec:	02000f00 	andeq	r0, r0, #0, 30
     ff0:	08460201 	stmdaeq	r6, {r0, r9}^
     ff4:	04180000 	ldreq	r0, [r8], #-0
     ff8:	000001fd 	strdeq	r0, [r0], -sp
     ffc:	002c0418 	eoreq	r0, ip, r8, lsl r4
    1000:	f10c0000 	cpsid	
    1004:	1800000c 	stmdane	r0, {r2, r3}
    1008:	00038104 	andeq	r8, r3, r4, lsl #2
    100c:	02ad1600 	adceq	r1, sp, #0, 12
    1010:	03970000 	orrseq	r0, r7, #0
    1014:	00190000 	andseq	r0, r9, r0
    1018:	01f00418 	mvnseq	r0, r8, lsl r4
    101c:	04180000 	ldreq	r0, [r8], #-0
    1020:	000001eb 	andeq	r0, r0, fp, ror #3
    1024:	000a511a 	andeq	r5, sl, sl, lsl r1
    1028:	149c0400 	ldrne	r0, [ip], #1024	; 0x400
    102c:	000001f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    1030:	0007120b 	andeq	r1, r7, fp, lsl #4
    1034:	14040500 	strne	r0, [r4], #-1280	; 0xfffffb00
    1038:	00000059 	andeq	r0, r0, r9, asr r0
    103c:	8f540305 	svchi	0x00540305
    1040:	b10b0000 	mrslt	r0, (UNDEF: 11)
    1044:	05000003 	streq	r0, [r0, #-3]
    1048:	00591407 	subseq	r1, r9, r7, lsl #8
    104c:	03050000 	movweq	r0, #20480	; 0x5000
    1050:	00008f58 	andeq	r8, r0, r8, asr pc
    1054:	0005950b 	andeq	r9, r5, fp, lsl #10
    1058:	140a0500 	strne	r0, [sl], #-1280	; 0xfffffb00
    105c:	00000059 	andeq	r0, r0, r9, asr r0
    1060:	8f5c0305 	svchi	0x005c0305
    1064:	7b080000 	blvc	20106c <__bss_end+0x1f80d8>
    1068:	05000008 	streq	r0, [r0, #-8]
    106c:	00003804 	andeq	r3, r0, r4, lsl #16
    1070:	0c0d0500 	cfstr32eq	mvfx0, [sp], {-0}
    1074:	0000041c 	andeq	r0, r0, ip, lsl r4
    1078:	77654e09 	strbvc	r4, [r5, -r9, lsl #28]!
    107c:	720a0000 	andvc	r0, sl, #0
    1080:	01000008 	tsteq	r0, r8
    1084:	000a5d0a 	andeq	r5, sl, sl, lsl #26
    1088:	550a0200 	strpl	r0, [sl, #-512]	; 0xfffffe00
    108c:	03000008 	movweq	r0, #8
    1090:	0008280a 	andeq	r2, r8, sl, lsl #16
    1094:	540a0400 	strpl	r0, [sl], #-1024	; 0xfffffc00
    1098:	05000009 	streq	r0, [r0, #-9]
    109c:	068b0600 	streq	r0, [fp], r0, lsl #12
    10a0:	05100000 	ldreq	r0, [r0, #-0]
    10a4:	045b081b 	ldrbeq	r0, [fp], #-2075	; 0xfffff7e5
    10a8:	6c070000 	stcvs	0, cr0, [r7], {-0}
    10ac:	1d050072 	stcne	0, cr0, [r5, #-456]	; 0xfffffe38
    10b0:	00045b13 	andeq	r5, r4, r3, lsl fp
    10b4:	73070000 	movwvc	r0, #28672	; 0x7000
    10b8:	1e050070 	mcrne	0, 0, r0, cr5, cr0, {3}
    10bc:	00045b13 	andeq	r5, r4, r3, lsl fp
    10c0:	70070400 	andvc	r0, r7, r0, lsl #8
    10c4:	1f050063 	svcne	0x00050063
    10c8:	00045b13 	andeq	r5, r4, r3, lsl fp
    10cc:	a10e0800 	tstge	lr, r0, lsl #16
    10d0:	05000006 	streq	r0, [r0, #-6]
    10d4:	045b1320 	ldrbeq	r1, [fp], #-800	; 0xfffffce0
    10d8:	000c0000 	andeq	r0, ip, r0
    10dc:	4e070402 	cdpmi	4, 0, cr0, cr7, cr2, {0}
    10e0:	06000017 			; <UNDEFINED> instruction: 0x06000017
    10e4:	00000410 	andeq	r0, r0, r0, lsl r4
    10e8:	08280570 	stmdaeq	r8!, {r4, r5, r6, r8, sl}
    10ec:	000004f2 	strdeq	r0, [r0], -r2
    10f0:	000d3e0e 	andeq	r3, sp, lr, lsl #28
    10f4:	122a0500 	eorne	r0, sl, #0, 10
    10f8:	0000041c 	andeq	r0, r0, ip, lsl r4
    10fc:	69700700 	ldmdbvs	r0!, {r8, r9, sl}^
    1100:	2b050064 	blcs	141298 <__bss_end+0x138304>
    1104:	00005e12 	andeq	r5, r0, r2, lsl lr
    1108:	9f0e1000 	svcls	0x000e1000
    110c:	05000014 	streq	r0, [r0, #-20]	; 0xffffffec
    1110:	03e5112c 	mvneq	r1, #44, 2
    1114:	0e140000 	cdpeq	0, 1, cr0, cr4, cr0, {0}
    1118:	00000890 	muleq	r0, r0, r8
    111c:	5e122d05 	cdppl	13, 1, cr2, cr2, cr5, {0}
    1120:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
    1124:	00089e0e 	andeq	r9, r8, lr, lsl #28
    1128:	122e0500 	eorne	r0, lr, #0, 10
    112c:	0000005e 	andeq	r0, r0, lr, asr r0
    1130:	06740e1c 			; <UNDEFINED> instruction: 0x06740e1c
    1134:	2f050000 	svccs	0x00050000
    1138:	0004f20c 	andeq	pc, r4, ip, lsl #4
    113c:	cb0e2000 	blgt	389144 <__bss_end+0x3801b0>
    1140:	05000008 	streq	r0, [r0, #-8]
    1144:	00380930 	eorseq	r0, r8, r0, lsr r9
    1148:	0e600000 	cdpeq	0, 6, cr0, cr0, cr0, {0}
    114c:	00000adc 	ldrdeq	r0, [r0], -ip
    1150:	4d0e3105 	stfmis	f3, [lr, #-20]	; 0xffffffec
    1154:	64000000 	strvs	r0, [r0], #-0
    1158:	0006eb0e 	andeq	lr, r6, lr, lsl #22
    115c:	0e330500 	cfabs32eq	mvfx0, mvfx3
    1160:	0000004d 	andeq	r0, r0, sp, asr #32
    1164:	06e20e68 	strbteq	r0, [r2], r8, ror #28
    1168:	34050000 	strcc	r0, [r5], #-0
    116c:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1170:	16006c00 	strne	r6, [r0], -r0, lsl #24
    1174:	0000039d 	muleq	r0, sp, r3
    1178:	00000502 	andeq	r0, r0, r2, lsl #10
    117c:	00005e17 	andeq	r5, r0, r7, lsl lr
    1180:	0b000f00 	bleq	4d88 <shift+0x4d88>
    1184:	00000ca4 	andeq	r0, r0, r4, lsr #25
    1188:	59140a06 	ldmdbpl	r4, {r1, r2, r9, fp}
    118c:	05000000 	streq	r0, [r0, #-0]
    1190:	008f6003 	addeq	r6, pc, r3
    1194:	085d0800 	ldmdaeq	sp, {fp}^
    1198:	04050000 	streq	r0, [r5], #-0
    119c:	00000038 	andeq	r0, r0, r8, lsr r0
    11a0:	330c0d06 	movwcc	r0, #52486	; 0xcd06
    11a4:	0a000005 	beq	11c0 <shift+0x11c0>
    11a8:	00000506 	andeq	r0, r0, r6, lsl #10
    11ac:	03a60a00 			; <UNDEFINED> instruction: 0x03a60a00
    11b0:	00010000 	andeq	r0, r1, r0
    11b4:	00051403 	andeq	r1, r5, r3, lsl #8
    11b8:	0ee50800 	cdpeq	8, 14, cr0, cr5, cr0, {0}
    11bc:	04050000 	streq	r0, [r5], #-0
    11c0:	00000038 	andeq	r0, r0, r8, lsr r0
    11c4:	570c1406 	strpl	r1, [ip, -r6, lsl #8]
    11c8:	0a000005 	beq	11e4 <shift+0x11e4>
    11cc:	00000d68 	andeq	r0, r0, r8, ror #26
    11d0:	0f640a00 	svceq	0x00640a00
    11d4:	00010000 	andeq	r0, r1, r0
    11d8:	00053803 	andeq	r3, r5, r3, lsl #16
    11dc:	0bc80600 	bleq	ff2029e4 <__bss_end+0xff1f9a50>
    11e0:	060c0000 	streq	r0, [ip], -r0
    11e4:	0591081b 	ldreq	r0, [r1, #2075]	; 0x81b
    11e8:	e20e0000 	and	r0, lr, #0
    11ec:	06000003 	streq	r0, [r0], -r3
    11f0:	0591191d 	ldreq	r1, [r1, #2333]	; 0x91d
    11f4:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    11f8:	000004b3 			; <UNDEFINED> instruction: 0x000004b3
    11fc:	91191e06 	tstls	r9, r6, lsl #28
    1200:	04000005 	streq	r0, [r0], #-5
    1204:	000b500e 	andeq	r5, fp, lr
    1208:	131f0600 	tstne	pc, #0, 12
    120c:	00000597 	muleq	r0, r7, r5
    1210:	04180008 	ldreq	r0, [r8], #-8
    1214:	0000055c 	andeq	r0, r0, ip, asr r5
    1218:	04620418 	strbteq	r0, [r2], #-1048	; 0xfffffbe8
    121c:	a80d0000 	stmdage	sp, {}	; <UNPREDICTABLE>
    1220:	14000005 	strne	r0, [r0], #-5
    1224:	1f072206 	svcne	0x00072206
    1228:	0e000008 	cdpeq	0, 0, cr0, cr0, cr8, {0}
    122c:	0000084b 	andeq	r0, r0, fp, asr #16
    1230:	4d122606 	ldcmi	6, cr2, [r2, #-24]	; 0xffffffe8
    1234:	00000000 	andeq	r0, r0, r0
    1238:	0004600e 	andeq	r6, r4, lr
    123c:	1d290600 	stcne	6, cr0, [r9, #-0]
    1240:	00000591 	muleq	r0, r1, r5
    1244:	0a760e04 	beq	1d84a5c <__bss_end+0x1d7bac8>
    1248:	2c060000 	stccs	0, cr0, [r6], {-0}
    124c:	0005911d 	andeq	r9, r5, sp, lsl r1
    1250:	7a1b0800 	bvc	6c3258 <__bss_end+0x6ba2c4>
    1254:	0600000c 	streq	r0, [r0], -ip
    1258:	0ba50e2f 	bleq	fe944b1c <__bss_end+0xfe93bb88>
    125c:	05e50000 	strbeq	r0, [r5, #0]!
    1260:	05f00000 	ldrbeq	r0, [r0, #0]!
    1264:	24100000 	ldrcs	r0, [r0], #-0
    1268:	11000008 	tstne	r0, r8
    126c:	00000591 	muleq	r0, r1, r5
    1270:	0b5e1c00 	bleq	1788278 <__bss_end+0x177f2e4>
    1274:	31060000 	mrscc	r0, (UNDEF: 6)
    1278:	0003e70e 	andeq	lr, r3, lr, lsl #14
    127c:	00036e00 	andeq	r6, r3, r0, lsl #28
    1280:	00060800 	andeq	r0, r6, r0, lsl #16
    1284:	00061300 	andeq	r1, r6, r0, lsl #6
    1288:	08241000 	stmdaeq	r4!, {ip}
    128c:	97110000 	ldrls	r0, [r1, -r0]
    1290:	00000005 	andeq	r0, r0, r5
    1294:	000bdb13 	andeq	sp, fp, r3, lsl fp
    1298:	1d350600 	ldcne	6, cr0, [r5, #-0]
    129c:	00000b2b 	andeq	r0, r0, fp, lsr #22
    12a0:	00000591 	muleq	r0, r1, r5
    12a4:	00062c02 	andeq	r2, r6, r2, lsl #24
    12a8:	00063200 	andeq	r3, r6, r0, lsl #4
    12ac:	08241000 	stmdaeq	r4!, {ip}
    12b0:	13000000 	movwne	r0, #0
    12b4:	000007df 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    12b8:	ee1d3706 	cdp	7, 1, cr3, cr13, cr6, {0}
    12bc:	91000009 	tstls	r0, r9
    12c0:	02000005 	andeq	r0, r0, #5
    12c4:	0000064b 	andeq	r0, r0, fp, asr #12
    12c8:	00000651 	andeq	r0, r0, r1, asr r6
    12cc:	00082410 	andeq	r2, r8, r0, lsl r4
    12d0:	df1d0000 	svcle	0x001d0000
    12d4:	06000008 	streq	r0, [r0], -r8
    12d8:	083d3139 	ldmdaeq	sp!, {r0, r3, r4, r5, r8, ip, sp}
    12dc:	020c0000 	andeq	r0, ip, #0
    12e0:	0005a813 	andeq	sl, r5, r3, lsl r8
    12e4:	093c0600 	ldmdbeq	ip!, {r9, sl}
    12e8:	00000d1a 	andeq	r0, r0, sl, lsl sp
    12ec:	00000824 	andeq	r0, r0, r4, lsr #16
    12f0:	00067801 	andeq	r7, r6, r1, lsl #16
    12f4:	00067e00 	andeq	r7, r6, r0, lsl #28
    12f8:	08241000 	stmdaeq	r4!, {ip}
    12fc:	13000000 	movwne	r0, #0
    1300:	0000051b 	andeq	r0, r0, fp, lsl r5
    1304:	4f123f06 	svcmi	0x00123f06
    1308:	4d00000c 	stcmi	0, cr0, [r0, #-48]	; 0xffffffd0
    130c:	01000000 	mrseq	r0, (UNDEF: 0)
    1310:	00000697 	muleq	r0, r7, r6
    1314:	000006ac 	andeq	r0, r0, ip, lsr #13
    1318:	00082410 	andeq	r2, r8, r0, lsl r4
    131c:	08461100 	stmdaeq	r6, {r8, ip}^
    1320:	5e110000 	cdppl	0, 1, cr0, cr1, cr0, {0}
    1324:	11000000 	mrsne	r0, (UNDEF: 0)
    1328:	0000036e 	andeq	r0, r0, lr, ror #6
    132c:	0b6d1400 	bleq	1b46334 <__bss_end+0x1b3d3a0>
    1330:	42060000 	andmi	r0, r6, #0
    1334:	00096a0e 	andeq	r6, r9, lr, lsl #20
    1338:	06c10100 	strbeq	r0, [r1], r0, lsl #2
    133c:	06c70000 	strbeq	r0, [r7], r0
    1340:	24100000 	ldrcs	r0, [r0], #-0
    1344:	00000008 	andeq	r0, r0, r8
    1348:	00077313 	andeq	r7, r7, r3, lsl r3
    134c:	17450600 	strbne	r0, [r5, -r0, lsl #12]
    1350:	0000047d 	andeq	r0, r0, sp, ror r4
    1354:	00000597 	muleq	r0, r7, r5
    1358:	0006e001 	andeq	lr, r6, r1
    135c:	0006e600 	andeq	lr, r6, r0, lsl #12
    1360:	084c1000 	stmdaeq	ip, {ip}^
    1364:	13000000 	movwne	r0, #0
    1368:	000004b8 			; <UNDEFINED> instruction: 0x000004b8
    136c:	e8174806 	ldmda	r7, {r1, r2, fp, lr}
    1370:	9700000a 	strls	r0, [r0, -sl]
    1374:	01000005 	tsteq	r0, r5
    1378:	000006ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    137c:	0000070a 	andeq	r0, r0, sl, lsl #14
    1380:	00084c10 	andeq	r4, r8, r0, lsl ip
    1384:	004d1100 	subeq	r1, sp, r0, lsl #2
    1388:	14000000 	strne	r0, [r0], #-0
    138c:	00000cc1 	andeq	r0, r0, r1, asr #25
    1390:	760e4b06 	strvc	r4, [lr], -r6, lsl #22
    1394:	0100000b 	tsteq	r0, fp
    1398:	0000071f 	andeq	r0, r0, pc, lsl r7
    139c:	00000725 	andeq	r0, r0, r5, lsr #14
    13a0:	00082410 	andeq	r2, r8, r0, lsl r4
    13a4:	5e130000 	cdppl	0, 1, cr0, cr3, cr0, {0}
    13a8:	0600000b 	streq	r0, [r0], -fp
    13ac:	06a70e4d 	strteq	r0, [r7], sp, asr #28
    13b0:	036e0000 	cmneq	lr, #0
    13b4:	3e010000 	cdpcc	0, 0, cr0, cr1, cr0, {0}
    13b8:	49000007 	stmdbmi	r0, {r0, r1, r2}
    13bc:	10000007 	andne	r0, r0, r7
    13c0:	00000824 	andeq	r0, r0, r4, lsr #16
    13c4:	00004d11 	andeq	r4, r0, r1, lsl sp
    13c8:	87130000 	ldrhi	r0, [r3, -r0]
    13cc:	06000007 	streq	r0, [r0], -r7
    13d0:	098b1250 	stmibeq	fp, {r4, r6, r9, ip}
    13d4:	004d0000 	subeq	r0, sp, r0
    13d8:	62010000 	andvs	r0, r1, #0
    13dc:	6d000007 	stcvs	0, cr0, [r0, #-28]	; 0xffffffe4
    13e0:	10000007 	andne	r0, r0, r7
    13e4:	00000824 	andeq	r0, r0, r4, lsr #16
    13e8:	00039d11 	andeq	r9, r3, r1, lsl sp
    13ec:	4d130000 	ldcmi	0, cr0, [r3, #-0]
    13f0:	06000004 	streq	r0, [r0], -r4
    13f4:	072b0e53 			; <UNDEFINED> instruction: 0x072b0e53
    13f8:	036e0000 	cmneq	lr, #0
    13fc:	86010000 	strhi	r0, [r1], -r0
    1400:	91000007 	tstls	r0, r7
    1404:	10000007 	andne	r0, r0, r7
    1408:	00000824 	andeq	r0, r0, r4, lsr #16
    140c:	00004d11 	andeq	r4, r0, r1, lsl sp
    1410:	b9140000 	ldmdblt	r4, {}	; <UNPREDICTABLE>
    1414:	06000007 	streq	r0, [r0], -r7
    1418:	0be70e56 	bleq	ff9c4d78 <__bss_end+0xff9bbde4>
    141c:	a6010000 	strge	r0, [r1], -r0
    1420:	c5000007 	strgt	r0, [r0, #-7]
    1424:	10000007 	andne	r0, r0, r7
    1428:	00000824 	andeq	r0, r0, r4, lsr #16
    142c:	0000a911 	andeq	sl, r0, r1, lsl r9
    1430:	004d1100 	subeq	r1, sp, r0, lsl #2
    1434:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    1438:	11000000 	mrsne	r0, (UNDEF: 0)
    143c:	0000004d 	andeq	r0, r0, sp, asr #32
    1440:	00085211 	andeq	r5, r8, r1, lsl r2
    1444:	15140000 	ldrne	r0, [r4, #-0]
    1448:	0600000b 	streq	r0, [r0], -fp
    144c:	061c0e58 			; <UNDEFINED> instruction: 0x061c0e58
    1450:	da010000 	ble	41458 <__bss_end+0x384c4>
    1454:	f9000007 			; <UNDEFINED> instruction: 0xf9000007
    1458:	10000007 	andne	r0, r0, r7
    145c:	00000824 	andeq	r0, r0, r4, lsr #16
    1460:	0000e011 	andeq	lr, r0, r1, lsl r0
    1464:	004d1100 	subeq	r1, sp, r0, lsl #2
    1468:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    146c:	11000000 	mrsne	r0, (UNDEF: 0)
    1470:	0000004d 	andeq	r0, r0, sp, asr #32
    1474:	00085211 	andeq	r5, r8, r1, lsl r2
    1478:	82150000 	andshi	r0, r5, #0
    147c:	06000005 	streq	r0, [r0], -r5
    1480:	05d90e5b 	ldrbeq	r0, [r9, #3675]	; 0xe5b
    1484:	036e0000 	cmneq	lr, #0
    1488:	0e010000 	cdpeq	0, 0, cr0, cr1, cr0, {0}
    148c:	10000008 	andne	r0, r0, r8
    1490:	00000824 	andeq	r0, r0, r4, lsr #16
    1494:	00051411 	andeq	r1, r5, r1, lsl r4
    1498:	08581100 	ldmdaeq	r8, {r8, ip}^
    149c:	00000000 	andeq	r0, r0, r0
    14a0:	00059d03 	andeq	r9, r5, r3, lsl #26
    14a4:	9d041800 	stcls	8, cr1, [r4, #-0]
    14a8:	1e000005 	cdpne	0, 0, cr0, cr0, cr5, {0}
    14ac:	00000591 	muleq	r0, r1, r5
    14b0:	00000837 	andeq	r0, r0, r7, lsr r8
    14b4:	0000083d 	andeq	r0, r0, sp, lsr r8
    14b8:	00082410 	andeq	r2, r8, r0, lsl r4
    14bc:	9d1f0000 	ldcls	0, cr0, [pc, #-0]	; 14c4 <shift+0x14c4>
    14c0:	2a000005 	bcs	14dc <shift+0x14dc>
    14c4:	18000008 	stmdane	r0, {r3}
    14c8:	00003f04 	andeq	r3, r0, r4, lsl #30
    14cc:	1f041800 	svcne	0x00041800
    14d0:	20000008 	andcs	r0, r0, r8
    14d4:	00006504 	andeq	r6, r0, r4, lsl #10
    14d8:	1a042100 	bne	1098e0 <__bss_end+0x10094c>
    14dc:	000008ed 	andeq	r0, r0, sp, ror #17
    14e0:	9d195e06 	ldcls	14, cr5, [r9, #-24]	; 0xffffffe8
    14e4:	16000005 	strne	r0, [r0], -r5
    14e8:	0000002c 	andeq	r0, r0, ip, lsr #32
    14ec:	00000876 	andeq	r0, r0, r6, ror r8
    14f0:	00005e17 	andeq	r5, r0, r7, lsl lr
    14f4:	03000900 	movweq	r0, #2304	; 0x900
    14f8:	00000866 	andeq	r0, r0, r6, ror #16
    14fc:	000e5122 	andeq	r5, lr, r2, lsr #2
    1500:	0ca40100 	stfeqs	f0, [r4]
    1504:	00000876 	andeq	r0, r0, r6, ror r8
    1508:	8f640305 	svchi	0x00640305
    150c:	5d230000 	stcpl	0, cr0, [r3, #-0]
    1510:	0100000d 	tsteq	r0, sp
    1514:	0ed90aa6 	vfnmseq.f32	s1, s19, s13
    1518:	004d0000 	subeq	r0, sp, r0
    151c:	87640000 	strbhi	r0, [r4, -r0]!
    1520:	00b00000 	adcseq	r0, r0, r0
    1524:	9c010000 	stcls	0, cr0, [r1], {-0}
    1528:	000008eb 	andeq	r0, r0, fp, ror #17
    152c:	001ac324 	andseq	ip, sl, r4, lsr #6
    1530:	1ba60100 	blne	fe981938 <__bss_end+0xfe9789a4>
    1534:	0000037b 	andeq	r0, r0, fp, ror r3
    1538:	7fac9103 	svcvc	0x00ac9103
    153c:	000f3824 	andeq	r3, pc, r4, lsr #16
    1540:	2aa60100 	bcs	fe981948 <__bss_end+0xfe9789b4>
    1544:	0000004d 	andeq	r0, r0, sp, asr #32
    1548:	7fa89103 	svcvc	0x00a89103
    154c:	000ec122 	andeq	ip, lr, r2, lsr #2
    1550:	0aa80100 	beq	fea01958 <__bss_end+0xfe9f89c4>
    1554:	000008eb 	andeq	r0, r0, fp, ror #17
    1558:	7fb49103 	svcvc	0x00b49103
    155c:	000d7c22 	andeq	r7, sp, r2, lsr #24
    1560:	09ac0100 	stmibeq	ip!, {r8}
    1564:	00000038 	andeq	r0, r0, r8, lsr r0
    1568:	00749102 	rsbseq	r9, r4, r2, lsl #2
    156c:	00002516 	andeq	r2, r0, r6, lsl r5
    1570:	0008fb00 	andeq	pc, r8, r0, lsl #22
    1574:	005e1700 	subseq	r1, lr, r0, lsl #14
    1578:	003f0000 	eorseq	r0, pc, r0
    157c:	000f1d25 	andeq	r1, pc, r5, lsr #26
    1580:	0a980100 	beq	fe601988 <__bss_end+0xfe5f89f4>
    1584:	00000f72 	andeq	r0, r0, r2, ror pc
    1588:	0000004d 	andeq	r0, r0, sp, asr #32
    158c:	00008728 	andeq	r8, r0, r8, lsr #14
    1590:	0000003c 	andeq	r0, r0, ip, lsr r0
    1594:	09389c01 	ldmdbeq	r8!, {r0, sl, fp, ip, pc}
    1598:	72260000 	eorvc	r0, r6, #0
    159c:	01007165 	tsteq	r0, r5, ror #2
    15a0:	0557209a 	ldrbeq	r2, [r7, #-154]	; 0xffffff66
    15a4:	91020000 	mrsls	r0, (UNDEF: 2)
    15a8:	0ece2274 	mcreq	2, 6, r2, cr14, cr4, {3}
    15ac:	9b010000 	blls	415b4 <__bss_end+0x38620>
    15b0:	00004d0e 	andeq	r4, r0, lr, lsl #26
    15b4:	70910200 	addsvc	r0, r1, r0, lsl #4
    15b8:	0f472700 	svceq	0x00472700
    15bc:	8f010000 	svchi	0x00010000
    15c0:	000d9806 	andeq	r9, sp, r6, lsl #16
    15c4:	0086ec00 	addeq	lr, r6, r0, lsl #24
    15c8:	00003c00 	andeq	r3, r0, r0, lsl #24
    15cc:	719c0100 	orrsvc	r0, ip, r0, lsl #2
    15d0:	24000009 	strcs	r0, [r0], #-9
    15d4:	00000e3d 	andeq	r0, r0, sp, lsr lr
    15d8:	4d218f01 	stcmi	15, cr8, [r1, #-4]!
    15dc:	02000000 	andeq	r0, r0, #0
    15e0:	72266c91 	eorvc	r6, r6, #37120	; 0x9100
    15e4:	01007165 	tsteq	r0, r5, ror #2
    15e8:	05572091 	ldrbeq	r2, [r7, #-145]	; 0xffffff6f
    15ec:	91020000 	mrsls	r0, (UNDEF: 2)
    15f0:	fa250074 	blx	9417c8 <__bss_end+0x938834>
    15f4:	0100000e 	tsteq	r0, lr
    15f8:	0e620a83 	vmuleq.f32	s1, s5, s6
    15fc:	004d0000 	subeq	r0, sp, r0
    1600:	86b00000 	ldrthi	r0, [r0], r0
    1604:	003c0000 	eorseq	r0, ip, r0
    1608:	9c010000 	stcls	0, cr0, [r1], {-0}
    160c:	000009ae 	andeq	r0, r0, lr, lsr #19
    1610:	71657226 	cmnvc	r5, r6, lsr #4
    1614:	20850100 	addcs	r0, r5, r0, lsl #2
    1618:	00000533 	andeq	r0, r0, r3, lsr r5
    161c:	22749102 	rsbscs	r9, r4, #-2147483648	; 0x80000000
    1620:	00000d75 	andeq	r0, r0, r5, ror sp
    1624:	4d0e8601 	stcmi	6, cr8, [lr, #-4]
    1628:	02000000 	andeq	r0, r0, #0
    162c:	25007091 	strcs	r7, [r0, #-145]	; 0xffffff6f
    1630:	00001009 	andeq	r1, r0, r9
    1634:	130a7701 	movwne	r7, #42753	; 0xa701
    1638:	4d00000e 	stcmi	0, cr0, [r0, #-56]	; 0xffffffc8
    163c:	74000000 	strvc	r0, [r0], #-0
    1640:	3c000086 	stccc	0, cr0, [r0], {134}	; 0x86
    1644:	01000000 	mrseq	r0, (UNDEF: 0)
    1648:	0009eb9c 	muleq	r9, ip, fp
    164c:	65722600 	ldrbvs	r2, [r2, #-1536]!	; 0xfffffa00
    1650:	79010071 	stmdbvc	r1, {r0, r4, r5, r6}
    1654:	00053320 	andeq	r3, r5, r0, lsr #6
    1658:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    165c:	000d7522 	andeq	r7, sp, r2, lsr #10
    1660:	0e7a0100 	rpweqe	f0, f2, f0
    1664:	0000004d 	andeq	r0, r0, sp, asr #32
    1668:	00709102 	rsbseq	r9, r0, r2, lsl #2
    166c:	000e7625 	andeq	r7, lr, r5, lsr #12
    1670:	066b0100 	strbteq	r0, [fp], -r0, lsl #2
    1674:	00000f59 	andeq	r0, r0, r9, asr pc
    1678:	0000036e 	andeq	r0, r0, lr, ror #6
    167c:	00008620 	andeq	r8, r0, r0, lsr #12
    1680:	00000054 	andeq	r0, r0, r4, asr r0
    1684:	0a379c01 	beq	de8690 <__bss_end+0xddf6fc>
    1688:	ce240000 	cdpgt	0, 2, cr0, cr4, cr0, {0}
    168c:	0100000e 	tsteq	r0, lr
    1690:	004d156b 	subeq	r1, sp, fp, ror #10
    1694:	91020000 	mrsls	r0, (UNDEF: 2)
    1698:	06e2246c 	strbteq	r2, [r2], ip, ror #8
    169c:	6b010000 	blvs	416a4 <__bss_end+0x38710>
    16a0:	00004d25 	andeq	r4, r0, r5, lsr #26
    16a4:	68910200 	ldmvs	r1, {r9}
    16a8:	00100122 	andseq	r0, r0, r2, lsr #2
    16ac:	0e6d0100 	poweqe	f0, f5, f0
    16b0:	0000004d 	andeq	r0, r0, sp, asr #32
    16b4:	00749102 	rsbseq	r9, r4, r2, lsl #2
    16b8:	000daf25 	andeq	sl, sp, r5, lsr #30
    16bc:	125e0100 	subsne	r0, lr, #0, 2
    16c0:	00000fa9 	andeq	r0, r0, r9, lsr #31
    16c4:	0000008b 	andeq	r0, r0, fp, lsl #1
    16c8:	000085d0 	ldrdeq	r8, [r0], -r0
    16cc:	00000050 	andeq	r0, r0, r0, asr r0
    16d0:	0a929c01 	beq	fe4a86dc <__bss_end+0xfe49f748>
    16d4:	2f240000 	svccs	0x00240000
    16d8:	0100000a 	tsteq	r0, sl
    16dc:	004d205e 	subeq	r2, sp, lr, asr r0
    16e0:	91020000 	mrsls	r0, (UNDEF: 2)
    16e4:	0f03246c 	svceq	0x0003246c
    16e8:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
    16ec:	00004d2f 	andeq	r4, r0, pc, lsr #26
    16f0:	68910200 	ldmvs	r1, {r9}
    16f4:	0006e224 	andeq	lr, r6, r4, lsr #4
    16f8:	3f5e0100 	svccc	0x005e0100
    16fc:	0000004d 	andeq	r0, r0, sp, asr #32
    1700:	22649102 	rsbcs	r9, r4, #-2147483648	; 0x80000000
    1704:	00001001 	andeq	r1, r0, r1
    1708:	8b166001 	blhi	599714 <__bss_end+0x590780>
    170c:	02000000 	andeq	r0, r0, #0
    1710:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    1714:	00000ec7 	andeq	r0, r0, r7, asr #29
    1718:	b40a5201 	strlt	r5, [sl], #-513	; 0xfffffdff
    171c:	4d00000d 	stcmi	0, cr0, [r0, #-52]	; 0xffffffcc
    1720:	8c000000 	stchi	0, cr0, [r0], {-0}
    1724:	44000085 	strmi	r0, [r0], #-133	; 0xffffff7b
    1728:	01000000 	mrseq	r0, (UNDEF: 0)
    172c:	000ade9c 	muleq	sl, ip, lr
    1730:	0a2f2400 	beq	bca738 <__bss_end+0xbc17a4>
    1734:	52010000 	andpl	r0, r1, #0
    1738:	00004d1a 	andeq	r4, r0, sl, lsl sp
    173c:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1740:	000f0324 	andeq	r0, pc, r4, lsr #6
    1744:	29520100 	ldmdbcs	r2, {r8}^
    1748:	0000004d 	andeq	r0, r0, sp, asr #32
    174c:	22689102 	rsbcs	r9, r8, #-2147483648	; 0x80000000
    1750:	00000fd8 	ldrdeq	r0, [r0], -r8
    1754:	4d0e5401 	cfstrsmi	mvf5, [lr, #-4]
    1758:	02000000 	andeq	r0, r0, #0
    175c:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    1760:	00000fd2 	ldrdeq	r0, [r0], -r2
    1764:	b40a4501 	strlt	r4, [sl], #-1281	; 0xfffffaff
    1768:	4d00000f 	stcmi	0, cr0, [r0, #-60]	; 0xffffffc4
    176c:	3c000000 	stccc	0, cr0, [r0], {-0}
    1770:	50000085 	andpl	r0, r0, r5, lsl #1
    1774:	01000000 	mrseq	r0, (UNDEF: 0)
    1778:	000b399c 	muleq	fp, ip, r9
    177c:	0a2f2400 	beq	bca784 <__bss_end+0xbc17f0>
    1780:	45010000 	strmi	r0, [r1, #-0]
    1784:	00004d19 	andeq	r4, r0, r9, lsl sp
    1788:	6c910200 	lfmvs	f0, 4, [r1], {0}
    178c:	000ea224 	andeq	sl, lr, r4, lsr #4
    1790:	30450100 	subcc	r0, r5, r0, lsl #2
    1794:	0000011d 	andeq	r0, r0, sp, lsl r1
    1798:	24689102 	strbtcs	r9, [r8], #-258	; 0xfffffefe
    179c:	00000f09 	andeq	r0, r0, r9, lsl #30
    17a0:	58414501 	stmdapl	r1, {r0, r8, sl, lr}^
    17a4:	02000008 	andeq	r0, r0, #8
    17a8:	01226491 			; <UNDEFINED> instruction: 0x01226491
    17ac:	01000010 	tsteq	r0, r0, lsl r0
    17b0:	004d0e47 	subeq	r0, sp, r7, asr #28
    17b4:	91020000 	mrsls	r0, (UNDEF: 2)
    17b8:	62270074 	eorvs	r0, r7, #116	; 0x74
    17bc:	0100000d 	tsteq	r0, sp
    17c0:	0eac063f 	mcreq	6, 5, r0, cr12, cr15, {1}
    17c4:	85100000 	ldrhi	r0, [r0, #-0]
    17c8:	002c0000 	eoreq	r0, ip, r0
    17cc:	9c010000 	stcls	0, cr0, [r1], {-0}
    17d0:	00000b63 	andeq	r0, r0, r3, ror #22
    17d4:	000a2f24 	andeq	r2, sl, r4, lsr #30
    17d8:	153f0100 	ldrne	r0, [pc, #-256]!	; 16e0 <shift+0x16e0>
    17dc:	0000004d 	andeq	r0, r0, sp, asr #32
    17e0:	00749102 	rsbseq	r9, r4, r2, lsl #2
    17e4:	000f4125 	andeq	r4, pc, r5, lsr #2
    17e8:	0a320100 	beq	c81bf0 <__bss_end+0xc78c5c>
    17ec:	00000f0f 	andeq	r0, r0, pc, lsl #30
    17f0:	0000004d 	andeq	r0, r0, sp, asr #32
    17f4:	000084c0 	andeq	r8, r0, r0, asr #9
    17f8:	00000050 	andeq	r0, r0, r0, asr r0
    17fc:	0bbe9c01 	bleq	fefa8808 <__bss_end+0xfef9f874>
    1800:	2f240000 	svccs	0x00240000
    1804:	0100000a 	tsteq	r0, sl
    1808:	004d1932 	subeq	r1, sp, r2, lsr r9
    180c:	91020000 	mrsls	r0, (UNDEF: 2)
    1810:	0fee246c 	svceq	0x00ee246c
    1814:	32010000 	andcc	r0, r1, #0
    1818:	00037b2b 	andeq	r7, r3, fp, lsr #22
    181c:	68910200 	ldmvs	r1, {r9}
    1820:	000f3c24 	andeq	r3, pc, r4, lsr #24
    1824:	3c320100 	ldfccs	f0, [r2], #-0
    1828:	0000004d 	andeq	r0, r0, sp, asr #32
    182c:	22649102 	rsbcs	r9, r4, #-2147483648	; 0x80000000
    1830:	00000fa3 	andeq	r0, r0, r3, lsr #31
    1834:	4d0e3401 	cfstrsmi	mvf3, [lr, #-4]
    1838:	02000000 	andeq	r0, r0, #0
    183c:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    1840:	0000102b 	andeq	r1, r0, fp, lsr #32
    1844:	f50a2501 			; <UNDEFINED> instruction: 0xf50a2501
    1848:	4d00000f 	stcmi	0, cr0, [r0, #-60]	; 0xffffffc4
    184c:	70000000 	andvc	r0, r0, r0
    1850:	50000084 	andpl	r0, r0, r4, lsl #1
    1854:	01000000 	mrseq	r0, (UNDEF: 0)
    1858:	000c199c 	muleq	ip, ip, r9
    185c:	0a2f2400 	beq	bca864 <__bss_end+0xbc18d0>
    1860:	25010000 	strcs	r0, [r1, #-0]
    1864:	00004d18 	andeq	r4, r0, r8, lsl sp
    1868:	6c910200 	lfmvs	f0, 4, [r1], {0}
    186c:	000fee24 	andeq	lr, pc, r4, lsr #28
    1870:	2a250100 	bcs	941c78 <__bss_end+0x938ce4>
    1874:	00000c1f 	andeq	r0, r0, pc, lsl ip
    1878:	24689102 	strbtcs	r9, [r8], #-258	; 0xfffffefe
    187c:	00000f3c 	andeq	r0, r0, ip, lsr pc
    1880:	4d3b2501 	cfldr32mi	mvfx2, [fp, #-4]!
    1884:	02000000 	andeq	r0, r0, #0
    1888:	81226491 			; <UNDEFINED> instruction: 0x81226491
    188c:	0100000d 	tsteq	r0, sp
    1890:	004d0e27 	subeq	r0, sp, r7, lsr #28
    1894:	91020000 	mrsls	r0, (UNDEF: 2)
    1898:	04180074 	ldreq	r0, [r8], #-116	; 0xffffff8c
    189c:	00000025 	andeq	r0, r0, r5, lsr #32
    18a0:	000c1903 	andeq	r1, ip, r3, lsl #18
    18a4:	0ed42500 	cdpeq	5, 13, cr2, cr4, cr0, {0}
    18a8:	19010000 	stmdbne	r1, {}	; <UNPREDICTABLE>
    18ac:	0010370a 	andseq	r3, r0, sl, lsl #14
    18b0:	00004d00 	andeq	r4, r0, r0, lsl #26
    18b4:	00842c00 	addeq	r2, r4, r0, lsl #24
    18b8:	00004400 	andeq	r4, r0, r0, lsl #8
    18bc:	709c0100 	addsvc	r0, ip, r0, lsl #2
    18c0:	2400000c 	strcs	r0, [r0], #-12
    18c4:	00001022 	andeq	r1, r0, r2, lsr #32
    18c8:	7b1b1901 	blvc	6c7cd4 <__bss_end+0x6bed40>
    18cc:	02000003 	andeq	r0, r0, #3
    18d0:	e9246c91 	stmdb	r4!, {r0, r4, r7, sl, fp, sp, lr}
    18d4:	0100000f 	tsteq	r0, pc
    18d8:	01c63519 	biceq	r3, r6, r9, lsl r5
    18dc:	91020000 	mrsls	r0, (UNDEF: 2)
    18e0:	0a2f2268 	beq	bca288 <__bss_end+0xbc12f4>
    18e4:	1b010000 	blne	418ec <__bss_end+0x38958>
    18e8:	00004d0e 	andeq	r4, r0, lr, lsl #26
    18ec:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    18f0:	0e312800 	cdpeq	8, 3, cr2, cr1, cr0, {0}
    18f4:	14010000 	strne	r0, [r1], #-0
    18f8:	000d8706 	andeq	r8, sp, r6, lsl #14
    18fc:	00841000 	addeq	r1, r4, r0
    1900:	00001c00 	andeq	r1, r0, r0, lsl #24
    1904:	279c0100 	ldrcs	r0, [ip, r0, lsl #2]
    1908:	00000fdf 	ldrdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    190c:	c0060e01 	andgt	r0, r6, r1, lsl #28
    1910:	e400000d 	str	r0, [r0], #-13
    1914:	2c000083 	stccs	0, cr0, [r0], {131}	; 0x83
    1918:	01000000 	mrseq	r0, (UNDEF: 0)
    191c:	000cb09c 	muleq	ip, ip, r0
    1920:	0e0a2400 	cfcpyseq	mvf2, mvf10
    1924:	0e010000 	cdpeq	0, 0, cr0, cr1, cr0, {0}
    1928:	00003814 	andeq	r3, r0, r4, lsl r8
    192c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1930:	10302900 	eorsne	r2, r0, r0, lsl #18
    1934:	04010000 	streq	r0, [r1], #-0
    1938:	000eb60a 	andeq	fp, lr, sl, lsl #12
    193c:	00004d00 	andeq	r4, r0, r0, lsl #26
    1940:	0083b800 	addeq	fp, r3, r0, lsl #16
    1944:	00002c00 	andeq	r2, r0, r0, lsl #24
    1948:	269c0100 	ldrcs	r0, [ip], r0, lsl #2
    194c:	00646970 	rsbeq	r6, r4, r0, ror r9
    1950:	4d0e0601 	stcmi	6, cr0, [lr, #-4]
    1954:	02000000 	andeq	r0, r0, #0
    1958:	00007491 	muleq	r0, r1, r4
    195c:	0000032e 	andeq	r0, r0, lr, lsr #6
    1960:	06db0004 	ldrbeq	r0, [fp], r4
    1964:	01040000 	mrseq	r0, (UNDEF: 4)
    1968:	00001053 	andeq	r1, r0, r3, asr r0
    196c:	00114e04 	andseq	r4, r1, r4, lsl #28
    1970:	000e7c00 	andeq	r7, lr, r0, lsl #24
    1974:	00881400 	addeq	r1, r8, r0, lsl #8
    1978:	0004b800 	andeq	fp, r4, r0, lsl #16
    197c:	00068b00 	andeq	r8, r6, r0, lsl #22
    1980:	00490200 	subeq	r0, r9, r0, lsl #4
    1984:	87030000 	strhi	r0, [r3, -r0]
    1988:	01000011 	tsteq	r0, r1, lsl r0
    198c:	00611005 	rsbeq	r1, r1, r5
    1990:	30110000 	andscc	r0, r1, r0
    1994:	34333231 	ldrtcc	r3, [r3], #-561	; 0xfffffdcf
    1998:	38373635 	ldmdacc	r7!, {r0, r2, r4, r5, r9, sl, ip, sp}
    199c:	43424139 	movtmi	r4, #8505	; 0x2139
    19a0:	00464544 	subeq	r4, r6, r4, asr #10
    19a4:	03010400 	movweq	r0, #5120	; 0x1400
    19a8:	00002501 	andeq	r2, r0, r1, lsl #10
    19ac:	00740500 	rsbseq	r0, r4, r0, lsl #10
    19b0:	00610000 	rsbeq	r0, r1, r0
    19b4:	66060000 	strvs	r0, [r6], -r0
    19b8:	10000000 	andne	r0, r0, r0
    19bc:	00510700 	subseq	r0, r1, r0, lsl #14
    19c0:	04080000 	streq	r0, [r8], #-0
    19c4:	00175307 	andseq	r5, r7, r7, lsl #6
    19c8:	08010800 	stmdaeq	r1, {fp}
    19cc:	000009e9 	andeq	r0, r0, r9, ror #19
    19d0:	00006d07 	andeq	r6, r0, r7, lsl #26
    19d4:	002a0900 	eoreq	r0, sl, r0, lsl #18
    19d8:	b60a0000 	strlt	r0, [sl], -r0
    19dc:	01000011 	tsteq	r0, r1, lsl r0
    19e0:	11a10664 			; <UNDEFINED> instruction: 0x11a10664
    19e4:	8c4c0000 	marhi	acc0, r0, ip
    19e8:	00800000 	addeq	r0, r0, r0
    19ec:	9c010000 	stcls	0, cr0, [r1], {-0}
    19f0:	000000fb 	strdeq	r0, [r0], -fp
    19f4:	6372730b 	cmnvs	r2, #738197504	; 0x2c000000
    19f8:	19640100 	stmdbne	r4!, {r8}^
    19fc:	000000fb 	strdeq	r0, [r0], -fp
    1a00:	0b649102 	bleq	1925e10 <__bss_end+0x191ce7c>
    1a04:	00747364 	rsbseq	r7, r4, r4, ror #6
    1a08:	02246401 	eoreq	r6, r4, #16777216	; 0x1000000
    1a0c:	02000001 	andeq	r0, r0, #1
    1a10:	6e0b6091 	mcrvs	0, 0, r6, cr11, cr1, {4}
    1a14:	01006d75 	tsteq	r0, r5, ror sp
    1a18:	01042d64 	tsteq	r4, r4, ror #26
    1a1c:	91020000 	mrsls	r0, (UNDEF: 2)
    1a20:	12100c5c 	andsne	r0, r0, #92, 24	; 0x5c00
    1a24:	66010000 	strvs	r0, [r1], -r0
    1a28:	00010b0e 	andeq	r0, r1, lr, lsl #22
    1a2c:	70910200 	addsvc	r0, r1, r0, lsl #4
    1a30:	0011930c 	andseq	r9, r1, ip, lsl #6
    1a34:	08670100 	stmdaeq	r7!, {r8}^
    1a38:	00000111 	andeq	r0, r0, r1, lsl r1
    1a3c:	0d6c9102 	stfeqp	f1, [ip, #-8]!
    1a40:	00008c74 	andeq	r8, r0, r4, ror ip
    1a44:	00000048 	andeq	r0, r0, r8, asr #32
    1a48:	0100690e 	tsteq	r0, lr, lsl #18
    1a4c:	01040b69 	tsteq	r4, r9, ror #22
    1a50:	91020000 	mrsls	r0, (UNDEF: 2)
    1a54:	0f000074 	svceq	0x00000074
    1a58:	00010104 	andeq	r0, r1, r4, lsl #2
    1a5c:	04111000 	ldreq	r1, [r1], #-0
    1a60:	69050412 	stmdbvs	r5, {r1, r4, sl}
    1a64:	0f00746e 	svceq	0x0000746e
    1a68:	00007404 	andeq	r7, r0, r4, lsl #8
    1a6c:	6d040f00 	stcvs	15, cr0, [r4, #-0]
    1a70:	0a000000 	beq	1a78 <shift+0x1a78>
    1a74:	00001131 	andeq	r1, r0, r1, lsr r1
    1a78:	37065c01 	strcc	r5, [r6, -r1, lsl #24]
    1a7c:	e4000011 	str	r0, [r0], #-17	; 0xffffffef
    1a80:	6800008b 	stmdavs	r0, {r0, r1, r3, r7}
    1a84:	01000000 	mrseq	r0, (UNDEF: 0)
    1a88:	0001769c 	muleq	r1, ip, r6
    1a8c:	12091300 	andne	r1, r9, #0, 6
    1a90:	5c010000 	stcpl	0, cr0, [r1], {-0}
    1a94:	00010212 	andeq	r0, r1, r2, lsl r2
    1a98:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1a9c:	000ab913 	andeq	fp, sl, r3, lsl r9
    1aa0:	1e5c0100 	rdfnee	f0, f4, f0
    1aa4:	00000104 	andeq	r0, r0, r4, lsl #2
    1aa8:	0e689102 	lgneqe	f1, f2
    1aac:	006d656d 	rsbeq	r6, sp, sp, ror #10
    1ab0:	11085e01 	tstne	r8, r1, lsl #28
    1ab4:	02000001 	andeq	r0, r0, #1
    1ab8:	000d7091 	muleq	sp, r1, r0
    1abc:	3c00008c 	stccc	0, cr0, [r0], {140}	; 0x8c
    1ac0:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    1ac4:	60010069 	andvs	r0, r1, r9, rrx
    1ac8:	0001040b 	andeq	r0, r1, fp, lsl #8
    1acc:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1ad0:	bd140000 	ldclt	0, cr0, [r4, #-0]
    1ad4:	01000011 	tsteq	r0, r1, lsl r0
    1ad8:	11d60552 	bicsne	r0, r6, r2, asr r5
    1adc:	01040000 	mrseq	r0, (UNDEF: 4)
    1ae0:	8b900000 	blhi	fe401ae8 <__bss_end+0xfe3f8b54>
    1ae4:	00540000 	subseq	r0, r4, r0
    1ae8:	9c010000 	stcls	0, cr0, [r1], {-0}
    1aec:	000001af 	andeq	r0, r0, pc, lsr #3
    1af0:	0100730b 	tsteq	r0, fp, lsl #6
    1af4:	010b1852 	tsteq	fp, r2, asr r8
    1af8:	91020000 	mrsls	r0, (UNDEF: 2)
    1afc:	00690e6c 	rsbeq	r0, r9, ip, ror #28
    1b00:	04065401 	streq	r5, [r6], #-1025	; 0xfffffbff
    1b04:	02000001 	andeq	r0, r0, #1
    1b08:	14007491 	strne	r7, [r0], #-1169	; 0xfffffb6f
    1b0c:	000011f9 	strdeq	r1, [r0], -r9
    1b10:	c4054201 	strgt	r4, [r5], #-513	; 0xfffffdff
    1b14:	04000011 	streq	r0, [r0], #-17	; 0xffffffef
    1b18:	e4000001 	str	r0, [r0], #-1
    1b1c:	ac00008a 	stcge	0, cr0, [r0], {138}	; 0x8a
    1b20:	01000000 	mrseq	r0, (UNDEF: 0)
    1b24:	0002159c 	muleq	r2, ip, r5
    1b28:	31730b00 	cmncc	r3, r0, lsl #22
    1b2c:	19420100 	stmdbne	r2, {r8}^
    1b30:	0000010b 	andeq	r0, r0, fp, lsl #2
    1b34:	0b6c9102 	bleq	1b25f44 <__bss_end+0x1b1cfb0>
    1b38:	01003273 	tsteq	r0, r3, ror r2
    1b3c:	010b2942 	tsteq	fp, r2, asr #18
    1b40:	91020000 	mrsls	r0, (UNDEF: 2)
    1b44:	756e0b68 	strbvc	r0, [lr, #-2920]!	; 0xfffff498
    1b48:	4201006d 	andmi	r0, r1, #109	; 0x6d
    1b4c:	00010431 	andeq	r0, r1, r1, lsr r4
    1b50:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1b54:	0031750e 	eorseq	r7, r1, lr, lsl #10
    1b58:	15104401 	ldrne	r4, [r0, #-1025]	; 0xfffffbff
    1b5c:	02000002 	andeq	r0, r0, #2
    1b60:	750e7791 	strvc	r7, [lr, #-1937]	; 0xfffff86f
    1b64:	44010032 	strmi	r0, [r1], #-50	; 0xffffffce
    1b68:	00021514 	andeq	r1, r2, r4, lsl r5
    1b6c:	76910200 	ldrvc	r0, [r1], r0, lsl #4
    1b70:	08010800 	stmdaeq	r1, {fp}
    1b74:	000009e0 	andeq	r0, r0, r0, ror #19
    1b78:	00120114 	andseq	r0, r2, r4, lsl r1
    1b7c:	07360100 	ldreq	r0, [r6, -r0, lsl #2]!
    1b80:	000011e8 	andeq	r1, r0, r8, ror #3
    1b84:	00000111 	andeq	r0, r0, r1, lsl r1
    1b88:	00008a24 	andeq	r8, r0, r4, lsr #20
    1b8c:	000000c0 	andeq	r0, r0, r0, asr #1
    1b90:	02759c01 	rsbseq	r9, r5, #256	; 0x100
    1b94:	2c130000 	ldccs	0, cr0, [r3], {-0}
    1b98:	01000011 	tsteq	r0, r1, lsl r0
    1b9c:	01111536 	tsteq	r1, r6, lsr r5
    1ba0:	91020000 	mrsls	r0, (UNDEF: 2)
    1ba4:	72730b6c 	rsbsvc	r0, r3, #108, 22	; 0x1b000
    1ba8:	36010063 	strcc	r0, [r1], -r3, rrx
    1bac:	00010b27 	andeq	r0, r1, r7, lsr #22
    1bb0:	68910200 	ldmvs	r1, {r9}
    1bb4:	6d756e0b 	ldclvs	14, cr6, [r5, #-44]!	; 0xffffffd4
    1bb8:	30360100 	eorscc	r0, r6, r0, lsl #2
    1bbc:	00000104 	andeq	r0, r0, r4, lsl #2
    1bc0:	0e649102 	lgneqs	f1, f2
    1bc4:	38010069 	stmdacc	r1, {r0, r3, r5, r6}
    1bc8:	00010406 	andeq	r0, r1, r6, lsl #8
    1bcc:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1bd0:	11e31400 	mvnne	r1, r0, lsl #8
    1bd4:	24010000 	strcs	r0, [r1], #-0
    1bd8:	00114305 	andseq	r4, r1, r5, lsl #6
    1bdc:	00010400 	andeq	r0, r1, r0, lsl #8
    1be0:	00898800 	addeq	r8, r9, r0, lsl #16
    1be4:	00009c00 	andeq	r9, r0, r0, lsl #24
    1be8:	b29c0100 	addslt	r0, ip, #0, 2
    1bec:	13000002 	movwne	r0, #2
    1bf0:	00001126 	andeq	r1, r0, r6, lsr #2
    1bf4:	0b162401 	bleq	58ac00 <__bss_end+0x581c6c>
    1bf8:	02000001 	andeq	r0, r0, #1
    1bfc:	9a0c6c91 	bls	31ce48 <__bss_end+0x313eb4>
    1c00:	01000011 	tsteq	r0, r1, lsl r0
    1c04:	01040626 	tsteq	r4, r6, lsr #12
    1c08:	91020000 	mrsls	r0, (UNDEF: 2)
    1c0c:	17150074 			; <UNDEFINED> instruction: 0x17150074
    1c10:	01000012 	tsteq	r0, r2, lsl r0
    1c14:	121c0608 	andsne	r0, ip, #8, 12	; 0x800000
    1c18:	88140000 	ldmdahi	r4, {}	; <UNPREDICTABLE>
    1c1c:	01740000 	cmneq	r4, r0
    1c20:	9c010000 	stcls	0, cr0, [r1], {-0}
    1c24:	00112613 	andseq	r2, r1, r3, lsl r6
    1c28:	18080100 	stmdane	r8, {r8}
    1c2c:	00000066 	andeq	r0, r0, r6, rrx
    1c30:	13649102 	cmnne	r4, #-2147483648	; 0x80000000
    1c34:	0000119a 	muleq	r0, sl, r1
    1c38:	11250801 			; <UNDEFINED> instruction: 0x11250801
    1c3c:	02000001 	andeq	r0, r0, #1
    1c40:	b1136091 			; <UNDEFINED> instruction: 0xb1136091
    1c44:	01000011 	tsteq	r0, r1, lsl r0
    1c48:	00663a08 	rsbeq	r3, r6, r8, lsl #20
    1c4c:	91020000 	mrsls	r0, (UNDEF: 2)
    1c50:	00690e5c 	rsbeq	r0, r9, ip, asr lr
    1c54:	04060a01 	streq	r0, [r6], #-2561	; 0xfffff5ff
    1c58:	02000001 	andeq	r0, r0, #1
    1c5c:	e00d7491 	mul	sp, r1, r4
    1c60:	98000088 	stmdals	r0, {r3, r7}
    1c64:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    1c68:	1c01006a 	stcne	0, cr0, [r1], {106}	; 0x6a
    1c6c:	0001040b 	andeq	r0, r1, fp, lsl #8
    1c70:	70910200 	addsvc	r0, r1, r0, lsl #4
    1c74:	0089080d 	addeq	r0, r9, sp, lsl #16
    1c78:	00006000 	andeq	r6, r0, r0
    1c7c:	00630e00 	rsbeq	r0, r3, r0, lsl #28
    1c80:	6d081e01 	stcvs	14, cr1, [r8, #-4]
    1c84:	02000000 	andeq	r0, r0, #0
    1c88:	00006f91 	muleq	r0, r1, pc	; <UNPREDICTABLE>
    1c8c:	00220000 	eoreq	r0, r2, r0
    1c90:	00020000 	andeq	r0, r2, r0
    1c94:	00000802 	andeq	r0, r0, r2, lsl #16
    1c98:	09050104 	stmdbeq	r5, {r2, r8}
    1c9c:	8ccc0000 	stclhi	0, cr0, [ip], {0}
    1ca0:	8ed80000 	cdphi	0, 13, cr0, cr8, cr0, {0}
    1ca4:	12280000 	eorne	r0, r8, #0
    1ca8:	12580000 	subsne	r0, r8, #0
    1cac:	00610000 	rsbeq	r0, r1, r0
    1cb0:	80010000 	andhi	r0, r1, r0
    1cb4:	00000022 	andeq	r0, r0, r2, lsr #32
    1cb8:	08160002 	ldmdaeq	r6, {r1}
    1cbc:	01040000 	mrseq	r0, (UNDEF: 4)
    1cc0:	00000982 	andeq	r0, r0, r2, lsl #19
    1cc4:	00008ed8 	ldrdeq	r8, [r0], -r8	; <UNPREDICTABLE>
    1cc8:	00008edc 	ldrdeq	r8, [r0], -ip
    1ccc:	00001228 	andeq	r1, r0, r8, lsr #4
    1cd0:	00001258 	andeq	r1, r0, r8, asr r2
    1cd4:	00000061 	andeq	r0, r0, r1, rrx
    1cd8:	09328001 	ldmdbeq	r2!, {r0, pc}
    1cdc:	00040000 	andeq	r0, r4, r0
    1ce0:	0000082a 	andeq	r0, r0, sl, lsr #16
    1ce4:	16260104 	strtne	r0, [r6], -r4, lsl #2
    1ce8:	7d0c0000 	stcvc	0, cr0, [ip, #-0]
    1cec:	58000015 	stmdapl	r0, {r0, r2, r4}
    1cf0:	e2000012 	and	r0, r0, #18
    1cf4:	02000009 	andeq	r0, r0, #9
    1cf8:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    1cfc:	04030074 	streq	r0, [r3], #-116	; 0xffffff8c
    1d00:	00175307 	andseq	r5, r7, r7, lsl #6
    1d04:	05080300 	streq	r0, [r8, #-768]	; 0xfffffd00
    1d08:	00000357 	andeq	r0, r0, r7, asr r3
    1d0c:	25040803 	strcs	r0, [r4, #-2051]	; 0xfffff7fd
    1d10:	0400001e 	streq	r0, [r0], #-30	; 0xffffffe2
    1d14:	000015d8 	ldrdeq	r1, [r0], -r8
    1d18:	24162a01 	ldrcs	r2, [r6], #-2561	; 0xfffff5ff
    1d1c:	04000000 	streq	r0, [r0], #-0
    1d20:	00001a47 	andeq	r1, r0, r7, asr #20
    1d24:	51152f01 	tstpl	r5, r1, lsl #30
    1d28:	05000000 	streq	r0, [r0, #-0]
    1d2c:	00005704 	andeq	r5, r0, r4, lsl #14
    1d30:	00390600 	eorseq	r0, r9, r0, lsl #12
    1d34:	00660000 	rsbeq	r0, r6, r0
    1d38:	66070000 	strvs	r0, [r7], -r0
    1d3c:	00000000 	andeq	r0, r0, r0
    1d40:	006c0405 	rsbeq	r0, ip, r5, lsl #8
    1d44:	04080000 	streq	r0, [r8], #-0
    1d48:	00002179 	andeq	r2, r0, r9, ror r1
    1d4c:	790f3601 	stmdbvc	pc, {r0, r9, sl, ip, sp}	; <UNPREDICTABLE>
    1d50:	05000000 	streq	r0, [r0, #-0]
    1d54:	00007f04 	andeq	r7, r0, r4, lsl #30
    1d58:	001d0600 	andseq	r0, sp, r0, lsl #12
    1d5c:	00930000 	addseq	r0, r3, r0
    1d60:	66070000 	strvs	r0, [r7], -r0
    1d64:	07000000 	streq	r0, [r0, -r0]
    1d68:	00000066 	andeq	r0, r0, r6, rrx
    1d6c:	08010300 	stmdaeq	r1, {r8, r9}
    1d70:	000009e0 	andeq	r0, r0, r0, ror #19
    1d74:	001c7f09 	andseq	r7, ip, r9, lsl #30
    1d78:	12bb0100 	adcsne	r0, fp, #0, 2
    1d7c:	00000045 	andeq	r0, r0, r5, asr #32
    1d80:	0021a709 	eoreq	sl, r1, r9, lsl #14
    1d84:	10be0100 	adcsne	r0, lr, r0, lsl #2
    1d88:	0000006d 	andeq	r0, r0, sp, rrx
    1d8c:	e2060103 	and	r0, r6, #-1073741824	; 0xc0000000
    1d90:	0a000009 	beq	1dbc <shift+0x1dbc>
    1d94:	00001967 	andeq	r1, r0, r7, ror #18
    1d98:	00930107 	addseq	r0, r3, r7, lsl #2
    1d9c:	17020000 	strne	r0, [r2, -r0]
    1da0:	0001e606 	andeq	lr, r1, r6, lsl #12
    1da4:	14360b00 	ldrtne	r0, [r6], #-2816	; 0xfffff500
    1da8:	0b000000 	bleq	1db0 <shift+0x1db0>
    1dac:	00001884 	andeq	r1, r0, r4, lsl #17
    1db0:	1d4a0b01 	vstrne	d16, [sl, #-4]
    1db4:	0b020000 	bleq	81dbc <__bss_end+0x78e28>
    1db8:	000020bb 	strheq	r2, [r0], -fp
    1dbc:	1cee0b03 	fstmiaxne	lr!, {d16}	;@ Deprecated
    1dc0:	0b040000 	bleq	101dc8 <__bss_end+0xf8e34>
    1dc4:	00001fc4 	andeq	r1, r0, r4, asr #31
    1dc8:	1f280b05 	svcne	0x00280b05
    1dcc:	0b060000 	bleq	181dd4 <__bss_end+0x178e40>
    1dd0:	00001457 	andeq	r1, r0, r7, asr r4
    1dd4:	1fd90b07 	svcne	0x00d90b07
    1dd8:	0b080000 	bleq	201de0 <__bss_end+0x1f8e4c>
    1ddc:	00001fe7 	andeq	r1, r0, r7, ror #31
    1de0:	20ae0b09 	adccs	r0, lr, r9, lsl #22
    1de4:	0b0a0000 	bleq	281dec <__bss_end+0x278e58>
    1de8:	00001c45 	andeq	r1, r0, r5, asr #24
    1dec:	16190b0b 	ldrne	r0, [r9], -fp, lsl #22
    1df0:	0b0c0000 	bleq	301df8 <__bss_end+0x2f8e64>
    1df4:	000016f6 	strdeq	r1, [r0], -r6
    1df8:	19ab0b0d 	stmibne	fp!, {r0, r2, r3, r8, r9, fp}
    1dfc:	0b0e0000 	bleq	381e04 <__bss_end+0x378e70>
    1e00:	000019c1 	andeq	r1, r0, r1, asr #19
    1e04:	18be0b0f 	ldmne	lr!, {r0, r1, r2, r3, r8, r9, fp}
    1e08:	0b100000 	bleq	401e10 <__bss_end+0x3f8e7c>
    1e0c:	00001cd2 	ldrdeq	r1, [r0], -r2
    1e10:	192a0b11 	stmdbne	sl!, {r0, r4, r8, r9, fp}
    1e14:	0b120000 	bleq	481e1c <__bss_end+0x478e88>
    1e18:	00002340 	andeq	r2, r0, r0, asr #6
    1e1c:	14c00b13 	strbne	r0, [r0], #2835	; 0xb13
    1e20:	0b140000 	bleq	501e28 <__bss_end+0x4f8e94>
    1e24:	0000194e 	andeq	r1, r0, lr, asr #18
    1e28:	13fd0b15 	mvnsne	r0, #21504	; 0x5400
    1e2c:	0b160000 	bleq	581e34 <__bss_end+0x578ea0>
    1e30:	000020de 	ldrdeq	r2, [r0], -lr
    1e34:	22000b17 	andcs	r0, r0, #23552	; 0x5c00
    1e38:	0b180000 	bleq	601e40 <__bss_end+0x5f8eac>
    1e3c:	00001973 	andeq	r1, r0, r3, ror r9
    1e40:	1dbc0b19 			; <UNDEFINED> instruction: 0x1dbc0b19
    1e44:	0b1a0000 	bleq	681e4c <__bss_end+0x678eb8>
    1e48:	000020ec 	andeq	r2, r0, ip, ror #1
    1e4c:	132c0b1b 			; <UNDEFINED> instruction: 0x132c0b1b
    1e50:	0b1c0000 	bleq	701e58 <__bss_end+0x6f8ec4>
    1e54:	000020fa 	strdeq	r2, [r0], -sl
    1e58:	21080b1d 	tstcs	r8, sp, lsl fp
    1e5c:	0b1e0000 	bleq	781e64 <__bss_end+0x778ed0>
    1e60:	000012da 	ldrdeq	r1, [r0], -sl
    1e64:	21320b1f 	teqcs	r2, pc, lsl fp
    1e68:	0b200000 	bleq	801e70 <__bss_end+0x7f8edc>
    1e6c:	00001e69 	andeq	r1, r0, r9, ror #28
    1e70:	1ca40b21 	fstmiaxne	r4!, {d0-d15}	;@ Deprecated
    1e74:	0b220000 	bleq	881e7c <__bss_end+0x878ee8>
    1e78:	000020d1 	ldrdeq	r2, [r0], -r1
    1e7c:	1ba80b23 	blne	fea04b10 <__bss_end+0xfe9fbb7c>
    1e80:	0b240000 	bleq	901e88 <__bss_end+0x8f8ef4>
    1e84:	00001aaa 	andeq	r1, r0, sl, lsr #21
    1e88:	17c40b25 	strbne	r0, [r4, r5, lsr #22]
    1e8c:	0b260000 	bleq	981e94 <__bss_end+0x978f00>
    1e90:	00001ac8 	andeq	r1, r0, r8, asr #21
    1e94:	18600b27 	stmdane	r0!, {r0, r1, r2, r5, r8, r9, fp}^
    1e98:	0b280000 	bleq	a01ea0 <__bss_end+0x9f8f0c>
    1e9c:	00001ad8 	ldrdeq	r1, [r0], -r8
    1ea0:	1ae80b29 	bne	ffa04b4c <__bss_end+0xff9fbbb8>
    1ea4:	0b2a0000 	bleq	a81eac <__bss_end+0xa78f18>
    1ea8:	00001c2b 	andeq	r1, r0, fp, lsr #24
    1eac:	1a510b2b 	bne	1444b60 <__bss_end+0x143bbcc>
    1eb0:	0b2c0000 	bleq	b01eb8 <__bss_end+0xaf8f24>
    1eb4:	00001e76 	andeq	r1, r0, r6, ror lr
    1eb8:	18050b2d 	stmdane	r5, {r0, r2, r3, r5, r8, r9, fp}
    1ebc:	002e0000 	eoreq	r0, lr, r0
    1ec0:	0019e30a 	andseq	lr, r9, sl, lsl #6
    1ec4:	93010700 	movwls	r0, #5888	; 0x1700
    1ec8:	03000000 	movweq	r0, #0
    1ecc:	03c70617 	biceq	r0, r7, #24117248	; 0x1700000
    1ed0:	180b0000 	stmdane	fp, {}	; <UNPREDICTABLE>
    1ed4:	00000017 	andeq	r0, r0, r7, lsl r0
    1ed8:	00136a0b 	andseq	r6, r3, fp, lsl #20
    1edc:	ee0b0100 	adfe	f0, f3, f0
    1ee0:	02000022 	andeq	r0, r0, #34	; 0x22
    1ee4:	0021810b 	eoreq	r8, r1, fp, lsl #2
    1ee8:	380b0300 	stmdacc	fp, {r8, r9}
    1eec:	04000017 	streq	r0, [r0], #-23	; 0xffffffe9
    1ef0:	0014220b 	andseq	r2, r4, fp, lsl #4
    1ef4:	e10b0500 	tst	fp, r0, lsl #10
    1ef8:	06000017 			; <UNDEFINED> instruction: 0x06000017
    1efc:	0017280b 	andseq	r2, r7, fp, lsl #16
    1f00:	150b0700 	strne	r0, [fp, #-1792]	; 0xfffff900
    1f04:	08000020 	stmdaeq	r0, {r5}
    1f08:	0021660b 	eoreq	r6, r1, fp, lsl #12
    1f0c:	4c0b0900 			; <UNDEFINED> instruction: 0x4c0b0900
    1f10:	0a00001f 	beq	1f94 <shift+0x1f94>
    1f14:	0014750b 	andseq	r7, r4, fp, lsl #10
    1f18:	820b0b00 	andhi	r0, fp, #0, 22
    1f1c:	0c000017 	stceq	0, cr0, [r0], {23}
    1f20:	0013eb0b 	andseq	lr, r3, fp, lsl #22
    1f24:	230b0d00 	movwcs	r0, #48384	; 0xbd00
    1f28:	0e000023 	cdpeq	0, 0, cr0, cr0, cr3, {1}
    1f2c:	001c180b 	andseq	r1, ip, fp, lsl #16
    1f30:	f50b0f00 			; <UNDEFINED> instruction: 0xf50b0f00
    1f34:	10000018 	andne	r0, r0, r8, lsl r0
    1f38:	001c550b 	andseq	r5, ip, fp, lsl #10
    1f3c:	420b1100 	andmi	r1, fp, #0, 2
    1f40:	12000022 	andne	r0, r0, #34	; 0x22
    1f44:	0015380b 	andseq	r3, r5, fp, lsl #16
    1f48:	080b1300 	stmdaeq	fp, {r8, r9, ip}
    1f4c:	14000019 	strne	r0, [r0], #-25	; 0xffffffe7
    1f50:	001b6b0b 	andseq	r6, fp, fp, lsl #22
    1f54:	030b1500 	movweq	r1, #46336	; 0xb500
    1f58:	16000017 			; <UNDEFINED> instruction: 0x16000017
    1f5c:	001bb70b 	andseq	fp, fp, fp, lsl #14
    1f60:	cd0b1700 	stcgt	7, cr1, [fp, #-0]
    1f64:	18000019 	stmdane	r0, {r0, r3, r4}
    1f68:	0014400b 	andseq	r4, r4, fp
    1f6c:	e90b1900 	stmdb	fp, {r8, fp, ip}
    1f70:	1a000021 	bne	1ffc <shift+0x1ffc>
    1f74:	001b370b 	andseq	r3, fp, fp, lsl #14
    1f78:	df0b1b00 	svcle	0x000b1b00
    1f7c:	1c000018 	stcne	0, cr0, [r0], {24}
    1f80:	0013150b 	andseq	r1, r3, fp, lsl #10
    1f84:	820b1d00 	andhi	r1, fp, #0, 26
    1f88:	1e00001a 	mcrne	0, 0, r0, cr0, cr10, {0}
    1f8c:	001a6e0b 	andseq	r6, sl, fp, lsl #28
    1f90:	090b1f00 	stmdbeq	fp, {r8, r9, sl, fp, ip}
    1f94:	2000001f 	andcs	r0, r0, pc, lsl r0
    1f98:	001f940b 	andseq	r9, pc, fp, lsl #8
    1f9c:	c80b2100 	stmdagt	fp, {r8, sp}
    1fa0:	22000021 	andcs	r0, r0, #33	; 0x21
    1fa4:	0018120b 	andseq	r1, r8, fp, lsl #4
    1fa8:	6c0b2300 	stcvs	3, cr2, [fp], {-0}
    1fac:	2400001d 	strcs	r0, [r0], #-29	; 0xffffffe3
    1fb0:	001f610b 	andseq	r6, pc, fp, lsl #2
    1fb4:	850b2500 	strhi	r2, [fp, #-1280]	; 0xfffffb00
    1fb8:	2600001e 			; <UNDEFINED> instruction: 0x2600001e
    1fbc:	001e990b 	andseq	r9, lr, fp, lsl #18
    1fc0:	ad0b2700 	stcge	7, cr2, [fp, #-0]
    1fc4:	2800001e 	stmdacs	r0, {r1, r2, r3, r4}
    1fc8:	0015c30b 	andseq	ip, r5, fp, lsl #6
    1fcc:	230b2900 	movwcs	r2, #47360	; 0xb900
    1fd0:	2a000015 	bcs	202c <shift+0x202c>
    1fd4:	00154b0b 	andseq	r4, r5, fp, lsl #22
    1fd8:	5e0b2b00 	vmlapl.f64	d2, d11, d0
    1fdc:	2c000020 	stccs	0, cr0, [r0], {32}
    1fe0:	0015a00b 	andseq	sl, r5, fp
    1fe4:	720b2d00 	andvc	r2, fp, #0, 26
    1fe8:	2e000020 	cdpcs	0, 0, cr0, cr0, cr0, {1}
    1fec:	0020860b 	eoreq	r8, r0, fp, lsl #12
    1ff0:	9a0b2f00 	bls	2cdbf8 <__bss_end+0x2c4c64>
    1ff4:	30000020 	andcc	r0, r0, r0, lsr #32
    1ff8:	0017940b 	andseq	r9, r7, fp, lsl #8
    1ffc:	6e0b3100 	adfvse	f3, f3, f0
    2000:	32000017 	andcc	r0, r0, #23
    2004:	001a960b 	andseq	r9, sl, fp, lsl #12
    2008:	680b3300 	stmdavs	fp, {r8, r9, ip, sp}
    200c:	3400001c 	strcc	r0, [r0], #-28	; 0xffffffe4
    2010:	0022770b 	eoreq	r7, r2, fp, lsl #14
    2014:	bd0b3500 	cfstr32lt	mvfx3, [fp, #-0]
    2018:	36000012 			; <UNDEFINED> instruction: 0x36000012
    201c:	0018940b 	andseq	r9, r8, fp, lsl #8
    2020:	a90b3700 	stmdbge	fp, {r8, r9, sl, ip, sp}
    2024:	38000018 	stmdacc	r0, {r3, r4}
    2028:	001af80b 	andseq	pc, sl, fp, lsl #16
    202c:	220b3900 	andcs	r3, fp, #0, 18
    2030:	3a00001b 	bcc	20a4 <shift+0x20a4>
    2034:	0022a00b 	eoreq	sl, r2, fp
    2038:	570b3b00 	strpl	r3, [fp, -r0, lsl #22]
    203c:	3c00001d 	stccc	0, cr0, [r0], {29}
    2040:	0018370b 	andseq	r3, r8, fp, lsl #14
    2044:	7c0b3d00 	stcvc	13, cr3, [fp], {-0}
    2048:	3e000013 	mcrcc	0, 0, r0, cr0, cr3, {0}
    204c:	00133a0b 	andseq	r3, r3, fp, lsl #20
    2050:	b40b3f00 	strlt	r3, [fp], #-3840	; 0xfffff100
    2054:	4000001c 	andmi	r0, r0, ip, lsl r0
    2058:	001dd80b 	andseq	sp, sp, fp, lsl #16
    205c:	eb0b4100 	bl	2d2464 <__bss_end+0x2c94d0>
    2060:	4200001e 	andmi	r0, r0, #30
    2064:	001b0d0b 	andseq	r0, fp, fp, lsl #26
    2068:	d90b4300 	stmdble	fp, {r8, r9, lr}
    206c:	44000022 	strmi	r0, [r0], #-34	; 0xffffffde
    2070:	001d820b 	andseq	r8, sp, fp, lsl #4
    2074:	670b4500 	strvs	r4, [fp, -r0, lsl #10]
    2078:	46000015 			; <UNDEFINED> instruction: 0x46000015
    207c:	001be80b 	andseq	lr, fp, fp, lsl #16
    2080:	1b0b4700 	blne	2d3c88 <__bss_end+0x2cacf4>
    2084:	4800001a 	stmdami	r0, {r1, r3, r4}
    2088:	0012f90b 	andseq	pc, r2, fp, lsl #18
    208c:	0d0b4900 	vstreq.16	s8, [fp, #-0]	; <UNPREDICTABLE>
    2090:	4a000014 	bmi	20e8 <shift+0x20e8>
    2094:	00184b0b 	andseq	r4, r8, fp, lsl #22
    2098:	490b4b00 	stmdbmi	fp, {r8, r9, fp, lr}
    209c:	4c00001b 	stcmi	0, cr0, [r0], {27}
    20a0:	07020300 	streq	r0, [r2, -r0, lsl #6]
    20a4:	000007cc 	andeq	r0, r0, ip, asr #15
    20a8:	0003e40c 	andeq	lr, r3, ip, lsl #8
    20ac:	0003d900 	andeq	sp, r3, r0, lsl #18
    20b0:	0e000d00 	cdpeq	13, 0, cr0, cr0, cr0, {0}
    20b4:	000003ce 	andeq	r0, r0, lr, asr #7
    20b8:	03f00405 	mvnseq	r0, #83886080	; 0x5000000
    20bc:	de0e0000 	cdple	0, 0, cr0, cr14, cr0, {0}
    20c0:	03000003 	movweq	r0, #3
    20c4:	09e90801 	stmibeq	r9!, {r0, fp}^
    20c8:	e90e0000 	stmdb	lr, {}	; <UNPREDICTABLE>
    20cc:	0f000003 	svceq	0x00000003
    20d0:	000014b1 			; <UNDEFINED> instruction: 0x000014b1
    20d4:	1a014c04 	bne	550ec <__bss_end+0x4c158>
    20d8:	000003d9 	ldrdeq	r0, [r0], -r9
    20dc:	0018cf0f 	andseq	ip, r8, pc, lsl #30
    20e0:	01820400 	orreq	r0, r2, r0, lsl #8
    20e4:	0003d91a 	andeq	sp, r3, sl, lsl r9
    20e8:	03e90c00 	mvneq	r0, #0, 24
    20ec:	041a0000 	ldreq	r0, [sl], #-0
    20f0:	000d0000 	andeq	r0, sp, r0
    20f4:	001aba09 	andseq	fp, sl, r9, lsl #20
    20f8:	0d2d0500 	cfstr32eq	mvfx0, [sp, #-0]
    20fc:	0000040f 	andeq	r0, r0, pc, lsl #8
    2100:	00214209 	eoreq	r4, r1, r9, lsl #4
    2104:	1c380500 	cfldr32ne	mvfx0, [r8], #-0
    2108:	000001e6 	andeq	r0, r0, r6, ror #3
    210c:	0017a80a 	andseq	sl, r7, sl, lsl #16
    2110:	93010700 	movwls	r0, #5888	; 0x1700
    2114:	05000000 	streq	r0, [r0, #-0]
    2118:	04a50e3a 	strteq	r0, [r5], #3642	; 0xe3a
    211c:	0e0b0000 	cdpeq	0, 0, cr0, cr11, cr0, {0}
    2120:	00000013 	andeq	r0, r0, r3, lsl r0
    2124:	0019ba0b 	andseq	fp, r9, fp, lsl #20
    2128:	540b0100 	strpl	r0, [fp], #-256	; 0xffffff00
    212c:	02000022 	andeq	r0, r0, #34	; 0x22
    2130:	0022170b 	eoreq	r1, r2, fp, lsl #14
    2134:	110b0300 	mrsne	r0, (UNDEF: 59)
    2138:	0400001d 	streq	r0, [r0], #-29	; 0xffffffe3
    213c:	001fd20b 	andseq	sp, pc, fp, lsl #4
    2140:	f40b0500 	vst3.8	{d0,d2,d4}, [fp], r0
    2144:	06000014 			; <UNDEFINED> instruction: 0x06000014
    2148:	0014d60b 	andseq	sp, r4, fp, lsl #12
    214c:	ef0b0700 	svc	0x000b0700
    2150:	08000016 	stmdaeq	r0, {r1, r2, r4}
    2154:	001bcd0b 	andseq	ip, fp, fp, lsl #26
    2158:	fb0b0900 	blx	2c4562 <__bss_end+0x2bb5ce>
    215c:	0a000014 	beq	21b4 <shift+0x21b4>
    2160:	001bd40b 	andseq	sp, fp, fp, lsl #8
    2164:	600b0b00 	andvs	r0, fp, r0, lsl #22
    2168:	0c000015 	stceq	0, cr0, [r0], {21}
    216c:	0014ed0b 	andseq	lr, r4, fp, lsl #26
    2170:	290b0d00 	stmdbcs	fp, {r8, sl, fp}
    2174:	0e000020 	cdpeq	0, 0, cr0, cr0, cr0, {1}
    2178:	001df60b 	andseq	pc, sp, fp, lsl #12
    217c:	04000f00 	streq	r0, [r0], #-3840	; 0xfffff100
    2180:	00001f21 	andeq	r1, r0, r1, lsr #30
    2184:	32013f05 	andcc	r3, r1, #5, 30
    2188:	09000004 	stmdbeq	r0, {r2}
    218c:	00001fb5 			; <UNDEFINED> instruction: 0x00001fb5
    2190:	a50f4105 	strge	r4, [pc, #-261]	; 2093 <shift+0x2093>
    2194:	09000004 	stmdbeq	r0, {r2}
    2198:	0000203d 	andeq	r2, r0, sp, lsr r0
    219c:	1d0c4a05 	vstrne	s8, [ip, #-20]	; 0xffffffec
    21a0:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    21a4:	00001495 	muleq	r0, r5, r4
    21a8:	1d0c4b05 	vstrne	d4, [ip, #-20]	; 0xffffffec
    21ac:	10000000 	andne	r0, r0, r0
    21b0:	00002116 	andeq	r2, r0, r6, lsl r1
    21b4:	00204e09 	eoreq	r4, r0, r9, lsl #28
    21b8:	144c0500 	strbne	r0, [ip], #-1280	; 0xfffffb00
    21bc:	000004e6 	andeq	r0, r0, r6, ror #9
    21c0:	04d50405 	ldrbeq	r0, [r5], #1029	; 0x405
    21c4:	09110000 	ldmdbeq	r1, {}	; <UNPREDICTABLE>
    21c8:	00001984 	andeq	r1, r0, r4, lsl #19
    21cc:	f90f4e05 			; <UNDEFINED> instruction: 0xf90f4e05
    21d0:	05000004 	streq	r0, [r0, #-4]
    21d4:	0004ec04 	andeq	lr, r4, r4, lsl #24
    21d8:	1f371200 	svcne	0x00371200
    21dc:	fe090000 	cdp2	0, 0, cr0, cr9, cr0, {0}
    21e0:	0500001c 	streq	r0, [r0, #-28]	; 0xffffffe4
    21e4:	05100d52 	ldreq	r0, [r0, #-3410]	; 0xfffff2ae
    21e8:	04050000 	streq	r0, [r5], #-0
    21ec:	000004ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    21f0:	00160c13 	andseq	r0, r6, r3, lsl ip
    21f4:	67053400 	strvs	r3, [r5, -r0, lsl #8]
    21f8:	05411501 	strbeq	r1, [r1, #-1281]	; 0xfffffaff
    21fc:	c3140000 	tstgt	r4, #0
    2200:	0500001a 	streq	r0, [r0, #-26]	; 0xffffffe6
    2204:	de0f0169 	adfleez	f0, f7, #1.0
    2208:	00000003 	andeq	r0, r0, r3
    220c:	0015f014 	andseq	pc, r5, r4, lsl r0	; <UNPREDICTABLE>
    2210:	016a0500 	cmneq	sl, r0, lsl #10
    2214:	00054614 	andeq	r4, r5, r4, lsl r6
    2218:	0e000400 	cfcpyseq	mvf0, mvf0
    221c:	00000516 	andeq	r0, r0, r6, lsl r5
    2220:	0000b90c 	andeq	fp, r0, ip, lsl #18
    2224:	00055600 	andeq	r5, r5, r0, lsl #12
    2228:	00241500 	eoreq	r1, r4, r0, lsl #10
    222c:	002d0000 	eoreq	r0, sp, r0
    2230:	0005410c 	andeq	r4, r5, ip, lsl #2
    2234:	00056100 	andeq	r6, r5, r0, lsl #2
    2238:	0e000d00 	cdpeq	13, 0, cr0, cr0, cr0, {0}
    223c:	00000556 	andeq	r0, r0, r6, asr r5
    2240:	0019f20f 	andseq	pc, r9, pc, lsl #4
    2244:	016b0500 	cmneq	fp, r0, lsl #10
    2248:	00056103 	andeq	r6, r5, r3, lsl #2
    224c:	1c380f00 	ldcne	15, cr0, [r8], #-0
    2250:	6e050000 	cdpvs	0, 0, cr0, cr5, cr0, {0}
    2254:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2258:	75160000 	ldrvc	r0, [r6, #-0]
    225c:	0700001f 	smladeq	r0, pc, r0, r0	; <UNPREDICTABLE>
    2260:	00009301 	andeq	r9, r0, r1, lsl #6
    2264:	01810500 	orreq	r0, r1, r0, lsl #10
    2268:	00062a06 	andeq	r2, r6, r6, lsl #20
    226c:	13a30b00 			; <UNDEFINED> instruction: 0x13a30b00
    2270:	0b000000 	bleq	2278 <shift+0x2278>
    2274:	000013af 	andeq	r1, r0, pc, lsr #7
    2278:	13bb0b02 			; <UNDEFINED> instruction: 0x13bb0b02
    227c:	0b030000 	bleq	c2284 <__bss_end+0xb92f0>
    2280:	000017d4 	ldrdeq	r1, [r0], -r4
    2284:	13c70b03 	bicne	r0, r7, #3072	; 0xc00
    2288:	0b040000 	bleq	102290 <__bss_end+0xf92fc>
    228c:	0000191d 	andeq	r1, r0, sp, lsl r9
    2290:	1a030b04 	bne	c4ea8 <__bss_end+0xbbf14>
    2294:	0b050000 	bleq	14229c <__bss_end+0x139308>
    2298:	00001959 	andeq	r1, r0, r9, asr r9
    229c:	14860b05 	strne	r0, [r6], #2821	; 0xb05
    22a0:	0b050000 	bleq	1422a8 <__bss_end+0x139314>
    22a4:	000013d3 	ldrdeq	r1, [r0], -r3
    22a8:	1b810b06 	blne	fe044ec8 <__bss_end+0xfe03bf34>
    22ac:	0b060000 	bleq	1822b4 <__bss_end+0x179320>
    22b0:	000015e2 	andeq	r1, r0, r2, ror #11
    22b4:	1b8e0b06 	blne	fe384ed4 <__bss_end+0xfe37bf40>
    22b8:	0b060000 	bleq	1822c0 <__bss_end+0x17932c>
    22bc:	00001ff5 	strdeq	r1, [r0], -r5
    22c0:	1b9b0b06 	blne	fe6c4ee0 <__bss_end+0xfe6bbf4c>
    22c4:	0b060000 	bleq	1822cc <__bss_end+0x179338>
    22c8:	00001bdb 	ldrdeq	r1, [r0], -fp
    22cc:	13df0b06 	bicsne	r0, pc, #6144	; 0x1800
    22d0:	0b070000 	bleq	1c22d8 <__bss_end+0x1b9344>
    22d4:	00001ce1 	andeq	r1, r0, r1, ror #25
    22d8:	1d2e0b07 	fstmdbxne	lr!, {d0-d2}	;@ Deprecated
    22dc:	0b070000 	bleq	1c22e4 <__bss_end+0x1b9350>
    22e0:	00002030 	andeq	r2, r0, r0, lsr r0
    22e4:	15b50b07 	ldrne	r0, [r5, #2823]!	; 0xb07
    22e8:	0b070000 	bleq	1c22f0 <__bss_end+0x1b935c>
    22ec:	00001daf 	andeq	r1, r0, pc, lsr #27
    22f0:	13580b08 	cmpne	r8, #8, 22	; 0x2000
    22f4:	0b080000 	bleq	2022fc <__bss_end+0x1f9368>
    22f8:	00002003 	andeq	r2, r0, r3
    22fc:	1dcb0b08 	vstrne	d16, [fp, #32]
    2300:	00080000 	andeq	r0, r8, r0
    2304:	0022690f 	eoreq	r6, r2, pc, lsl #18
    2308:	019f0500 	orrseq	r0, pc, r0, lsl #10
    230c:	0005801f 	andeq	r8, r5, pc, lsl r0
    2310:	1dfd0f00 	ldclne	15, cr0, [sp]
    2314:	a2050000 	andge	r0, r5, #0
    2318:	001d0c01 	andseq	r0, sp, r1, lsl #24
    231c:	100f0000 	andne	r0, pc, r0
    2320:	0500001a 	streq	r0, [r0, #-26]	; 0xffffffe6
    2324:	1d0c01a5 	stfnes	f0, [ip, #-660]	; 0xfffffd6c
    2328:	0f000000 	svceq	0x00000000
    232c:	00002335 	andeq	r2, r0, r5, lsr r3
    2330:	0c01a805 	stceq	8, cr10, [r1], {5}
    2334:	0000001d 	andeq	r0, r0, sp, lsl r0
    2338:	0014a50f 	andseq	sl, r4, pc, lsl #10
    233c:	01ab0500 			; <UNDEFINED> instruction: 0x01ab0500
    2340:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2344:	1e070f00 	cdpne	15, 0, cr0, cr7, cr0, {0}
    2348:	ae050000 	cdpge	0, 0, cr0, cr5, cr0, {0}
    234c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2350:	180f0000 	stmdane	pc, {}	; <UNPREDICTABLE>
    2354:	0500001d 	streq	r0, [r0, #-29]	; 0xffffffe3
    2358:	1d0c01b1 	stfnes	f0, [ip, #-708]	; 0xfffffd3c
    235c:	0f000000 	svceq	0x00000000
    2360:	00001d23 	andeq	r1, r0, r3, lsr #26
    2364:	0c01b405 	cfstrseq	mvf11, [r1], {5}
    2368:	0000001d 	andeq	r0, r0, sp, lsl r0
    236c:	001e110f 	andseq	r1, lr, pc, lsl #2
    2370:	01b70500 			; <UNDEFINED> instruction: 0x01b70500
    2374:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2378:	1b5d0f00 	blne	1745f80 <__bss_end+0x173cfec>
    237c:	ba050000 	blt	142384 <__bss_end+0x1393f0>
    2380:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2384:	940f0000 	strls	r0, [pc], #-0	; 238c <shift+0x238c>
    2388:	05000022 	streq	r0, [r0, #-34]	; 0xffffffde
    238c:	1d0c01bd 	stfnes	f0, [ip, #-756]	; 0xfffffd0c
    2390:	0f000000 	svceq	0x00000000
    2394:	00001e1b 	andeq	r1, r0, fp, lsl lr
    2398:	0c01c005 	stceq	0, cr12, [r1], {5}
    239c:	0000001d 	andeq	r0, r0, sp, lsl r0
    23a0:	0023580f 	eoreq	r5, r3, pc, lsl #16
    23a4:	01c30500 	biceq	r0, r3, r0, lsl #10
    23a8:	00001d0c 	andeq	r1, r0, ip, lsl #26
    23ac:	221e0f00 	andscs	r0, lr, #0, 30
    23b0:	c6050000 	strgt	r0, [r5], -r0
    23b4:	001d0c01 	andseq	r0, sp, r1, lsl #24
    23b8:	2a0f0000 	bcs	3c23c0 <__bss_end+0x3b942c>
    23bc:	05000022 	streq	r0, [r0, #-34]	; 0xffffffde
    23c0:	1d0c01c9 	stfnes	f0, [ip, #-804]	; 0xfffffcdc
    23c4:	0f000000 	svceq	0x00000000
    23c8:	00002236 	andeq	r2, r0, r6, lsr r2
    23cc:	0c01cc05 	stceq	12, cr12, [r1], {5}
    23d0:	0000001d 	andeq	r0, r0, sp, lsl r0
    23d4:	00225b0f 	eoreq	r5, r2, pc, lsl #22
    23d8:	01d00500 	bicseq	r0, r0, r0, lsl #10
    23dc:	00001d0c 	andeq	r1, r0, ip, lsl #26
    23e0:	234b0f00 	movtcs	r0, #48896	; 0xbf00
    23e4:	d3050000 	movwle	r0, #20480	; 0x5000
    23e8:	001d0c01 	andseq	r0, sp, r1, lsl #24
    23ec:	020f0000 	andeq	r0, pc, #0
    23f0:	05000015 	streq	r0, [r0, #-21]	; 0xffffffeb
    23f4:	1d0c01d6 	stfnes	f0, [ip, #-856]	; 0xfffffca8
    23f8:	0f000000 	svceq	0x00000000
    23fc:	000012e9 	andeq	r1, r0, r9, ror #5
    2400:	0c01d905 			; <UNDEFINED> instruction: 0x0c01d905
    2404:	0000001d 	andeq	r0, r0, sp, lsl r0
    2408:	0017f40f 	andseq	pc, r7, pc, lsl #8
    240c:	01dc0500 	bicseq	r0, ip, r0, lsl #10
    2410:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2414:	14dd0f00 	ldrbne	r0, [sp], #3840	; 0xf00
    2418:	df050000 	svcle	0x00050000
    241c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2420:	310f0000 	mrscc	r0, CPSR
    2424:	0500001e 	streq	r0, [r0, #-30]	; 0xffffffe2
    2428:	1d0c01e2 	stfnes	f0, [ip, #-904]	; 0xfffffc78
    242c:	0f000000 	svceq	0x00000000
    2430:	00001a39 	andeq	r1, r0, r9, lsr sl
    2434:	0c01e505 	cfstr32eq	mvfx14, [r1], {5}
    2438:	0000001d 	andeq	r0, r0, sp, lsl r0
    243c:	001c910f 	andseq	r9, ip, pc, lsl #2
    2440:	01e80500 	mvneq	r0, r0, lsl #10
    2444:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2448:	214b0f00 	cmpcs	fp, r0, lsl #30
    244c:	ef050000 	svc	0x00050000
    2450:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2454:	030f0000 	movweq	r0, #61440	; 0xf000
    2458:	05000023 	streq	r0, [r0, #-35]	; 0xffffffdd
    245c:	1d0c01f2 	stfnes	f0, [ip, #-968]	; 0xfffffc38
    2460:	0f000000 	svceq	0x00000000
    2464:	00002313 	andeq	r2, r0, r3, lsl r3
    2468:	0c01f505 	cfstr32eq	mvfx15, [r1], {5}
    246c:	0000001d 	andeq	r0, r0, sp, lsl r0
    2470:	0015f90f 	andseq	pc, r5, pc, lsl #18
    2474:	01f80500 	mvnseq	r0, r0, lsl #10
    2478:	00001d0c 	andeq	r1, r0, ip, lsl #26
    247c:	21920f00 	orrscs	r0, r2, r0, lsl #30
    2480:	fb050000 	blx	14248a <__bss_end+0x1394f6>
    2484:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2488:	970f0000 	strls	r0, [pc, -r0]
    248c:	0500001d 	streq	r0, [r0, #-29]	; 0xffffffe3
    2490:	1d0c01fe 	stfnes	f0, [ip, #-1016]	; 0xfffffc08
    2494:	0f000000 	svceq	0x00000000
    2498:	0000186d 	andeq	r1, r0, sp, ror #16
    249c:	0c020205 	sfmeq	f0, 4, [r2], {5}
    24a0:	0000001d 	andeq	r0, r0, sp, lsl r0
    24a4:	001f870f 	andseq	r8, pc, pc, lsl #14
    24a8:	020a0500 	andeq	r0, sl, #0, 10
    24ac:	00001d0c 	andeq	r1, r0, ip, lsl #26
    24b0:	17600f00 	strbne	r0, [r0, -r0, lsl #30]!
    24b4:	0d050000 	stceq	0, cr0, [r5, #-0]
    24b8:	001d0c02 	andseq	r0, sp, r2, lsl #24
    24bc:	1d0c0000 	stcne	0, cr0, [ip, #-0]
    24c0:	ef000000 	svc	0x00000000
    24c4:	0d000007 	stceq	0, cr0, [r0, #-28]	; 0xffffffe4
    24c8:	19390f00 	ldmdbne	r9!, {r8, r9, sl, fp}
    24cc:	fb050000 	blx	1424d6 <__bss_end+0x139542>
    24d0:	07e40c03 	strbeq	r0, [r4, r3, lsl #24]!
    24d4:	e60c0000 	str	r0, [ip], -r0
    24d8:	0c000004 	stceq	0, cr0, [r0], {4}
    24dc:	15000008 	strne	r0, [r0, #-8]
    24e0:	00000024 	andeq	r0, r0, r4, lsr #32
    24e4:	540f000d 	strpl	r0, [pc], #-13	; 24ec <shift+0x24ec>
    24e8:	0500001e 	streq	r0, [r0, #-30]	; 0xffffffe2
    24ec:	fc140584 	ldc2	5, cr0, [r4], {132}	; 0x84
    24f0:	16000007 	strne	r0, [r0], -r7
    24f4:	000019fb 	strdeq	r1, [r0], -fp
    24f8:	00930107 	addseq	r0, r3, r7, lsl #2
    24fc:	8b050000 	blhi	142504 <__bss_end+0x139570>
    2500:	08570605 	ldmdaeq	r7, {r0, r2, r9, sl}^
    2504:	b60b0000 	strlt	r0, [fp], -r0
    2508:	00000017 	andeq	r0, r0, r7, lsl r0
    250c:	001c060b 	andseq	r0, ip, fp, lsl #12
    2510:	8e0b0100 	adfhie	f0, f3, f0
    2514:	02000013 	andeq	r0, r0, #19
    2518:	0022c50b 	eoreq	ip, r2, fp, lsl #10
    251c:	ce0b0300 	cdpgt	3, 0, cr0, cr11, cr0, {0}
    2520:	0400001e 	streq	r0, [r0], #-30	; 0xffffffe2
    2524:	001ec10b 	andseq	ip, lr, fp, lsl #2
    2528:	650b0500 	strvs	r0, [fp, #-1280]	; 0xfffffb00
    252c:	06000014 			; <UNDEFINED> instruction: 0x06000014
    2530:	22b50f00 	adcscs	r0, r5, #0, 30
    2534:	98050000 	stmdals	r5, {}	; <UNPREDICTABLE>
    2538:	08191505 	ldmdaeq	r9, {r0, r2, r8, sl, ip}
    253c:	b70f0000 	strlt	r0, [pc, -r0]
    2540:	05000021 	streq	r0, [r0, #-33]	; 0xffffffdf
    2544:	24110799 	ldrcs	r0, [r1], #-1945	; 0xfffff867
    2548:	0f000000 	svceq	0x00000000
    254c:	00001e41 	andeq	r1, r0, r1, asr #28
    2550:	0c07ae05 	stceq	14, cr10, [r7], {5}
    2554:	0000001d 	andeq	r0, r0, sp, lsl r0
    2558:	00212a04 	eoreq	r2, r1, r4, lsl #20
    255c:	167b0600 	ldrbtne	r0, [fp], -r0, lsl #12
    2560:	00000093 	muleq	r0, r3, r0
    2564:	00087e0e 	andeq	r7, r8, lr, lsl #28
    2568:	05020300 	streq	r0, [r2, #-768]	; 0xfffffd00
    256c:	00000a20 	andeq	r0, r0, r0, lsr #20
    2570:	49070803 	stmdbmi	r7, {r0, r1, fp}
    2574:	03000017 	movweq	r0, #23
    2578:	151d0404 	ldrne	r0, [sp, #-1028]	; 0xfffffbfc
    257c:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    2580:	00151503 	andseq	r1, r5, r3, lsl #10
    2584:	04080300 	streq	r0, [r8], #-768	; 0xfffffd00
    2588:	00001e2a 	andeq	r1, r0, sl, lsr #28
    258c:	dc031003 	stcle	0, cr1, [r3], {3}
    2590:	0c00001e 	stceq	0, cr0, [r0], {30}
    2594:	0000088a 	andeq	r0, r0, sl, lsl #17
    2598:	000008c9 	andeq	r0, r0, r9, asr #17
    259c:	00002415 	andeq	r2, r0, r5, lsl r4
    25a0:	0e00ff00 	cdpeq	15, 0, cr15, cr0, cr0, {0}
    25a4:	000008b9 			; <UNDEFINED> instruction: 0x000008b9
    25a8:	001d3b0f 	andseq	r3, sp, pc, lsl #22
    25ac:	01fc0600 	mvnseq	r0, r0, lsl #12
    25b0:	0008c916 	andeq	ip, r8, r6, lsl r9
    25b4:	14cc0f00 	strbne	r0, [ip], #3840	; 0xf00
    25b8:	02060000 	andeq	r0, r6, #0
    25bc:	08c91602 	stmiaeq	r9, {r1, r9, sl, ip}^
    25c0:	5d040000 	stcpl	0, cr0, [r4, #-0]
    25c4:	07000021 	streq	r0, [r0, -r1, lsr #32]
    25c8:	04f9102a 	ldrbteq	r1, [r9], #42	; 0x2a
    25cc:	e80c0000 	stmda	ip, {}	; <UNPREDICTABLE>
    25d0:	ff000008 			; <UNDEFINED> instruction: 0xff000008
    25d4:	0d000008 	stceq	0, cr0, [r0, #-32]	; 0xffffffe0
    25d8:	03720900 	cmneq	r2, #0, 18
    25dc:	2f070000 	svccs	0x00070000
    25e0:	0008f411 	andeq	pc, r8, r1, lsl r4	; <UNPREDICTABLE>
    25e4:	02370900 	eorseq	r0, r7, #0, 18
    25e8:	30070000 	andcc	r0, r7, r0
    25ec:	0008f411 	andeq	pc, r8, r1, lsl r4	; <UNPREDICTABLE>
    25f0:	08ff1700 	ldmeq	pc!, {r8, r9, sl, ip}^	; <UNPREDICTABLE>
    25f4:	33080000 	movwcc	r0, #32768	; 0x8000
    25f8:	03050a09 	movweq	r0, #23049	; 0x5a09
    25fc:	00008f81 	andeq	r8, r0, r1, lsl #31
    2600:	00090b17 	andeq	r0, r9, r7, lsl fp
    2604:	09340800 	ldmdbeq	r4!, {fp}
    2608:	8103050a 	tsthi	r3, sl, lsl #10
    260c:	0000008f 	andeq	r0, r0, pc, lsl #1

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	10001101 	andne	r1, r0, r1, lsl #2
   4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
   8:	1b0e0301 	blne	380c14 <__bss_end+0x377c80>
   c:	130e250e 	movwne	r2, #58638	; 0xe50e
  10:	00000005 	andeq	r0, r0, r5
  14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
  18:	030b130e 	movweq	r1, #45838	; 0xb30e
  1c:	110e1b0e 	tstne	lr, lr, lsl #22
  20:	10061201 	andne	r1, r6, r1, lsl #4
  24:	02000017 	andeq	r0, r0, #23
  28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeb9d88>
  30:	13490b39 	movtne	r0, #39737	; 0x9b39
  34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
  38:	24030000 	strcs	r0, [r3], #-0
  3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  40:	000e030b 	andeq	r0, lr, fp, lsl #6
  44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
  48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeb9da8>
  50:	01110b39 	tsteq	r1, r9, lsr fp
  54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
  58:	01194296 			; <UNDEFINED> instruction: 0x01194296
  5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeb9dc0>
  68:	13490b39 	movtne	r0, #39737	; 0x9b39
  6c:	00001802 	andeq	r1, r0, r2, lsl #16
  70:	0b002406 	bleq	9090 <__bss_end+0xfc>
  74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  78:	07000008 	streq	r0, [r0, -r8]
  7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe7a900>
  84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe39de4>
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
  b4:	3a0e0300 	bcc	380cbc <__bss_end+0x377d28>
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
  e4:	0b3e0b0b 	bleq	f82d18 <__bss_end+0xf79d84>
  e8:	00000e03 	andeq	r0, r0, r3, lsl #28
  ec:	03003408 	movweq	r3, #1032	; 0x408
  f0:	3b0b3a0e 	blcc	2ce930 <__bss_end+0x2c599c>
  f4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
  f8:	3c193f13 	ldccc	15, cr3, [r9], {19}
  fc:	09000019 	stmdbeq	r0, {r0, r3, r4}
 100:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 104:	0b3a0e03 	bleq	e83918 <__bss_end+0xe7a984>
 108:	0b390b3b 	bleq	e42dfc <__bss_end+0xe39e68>
 10c:	01111349 	tsteq	r1, r9, asr #6
 110:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 114:	01194296 			; <UNDEFINED> instruction: 0x01194296
 118:	0a000013 	beq	16c <shift+0x16c>
 11c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeb9e7c>
 124:	13490b39 	movtne	r0, #39737	; 0x9b39
 128:	00001802 	andeq	r1, r0, r2, lsl #16
 12c:	0b00240b 	bleq	9160 <__bss_end+0x1cc>
 130:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 134:	0c000008 	stceq	0, cr0, [r0], {8}
 138:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
 13c:	0b3a0e03 	bleq	e83950 <__bss_end+0xe7a9bc>
 140:	0b390b3b 	bleq	e42e34 <__bss_end+0xe39ea0>
 144:	06120111 			; <UNDEFINED> instruction: 0x06120111
 148:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 14c:	0d000019 	stceq	0, cr0, [r0, #-100]	; 0xffffff9c
 150:	0e030139 	mcreq	1, 0, r0, cr3, cr9, {1}
 154:	0b3b0b3a 	bleq	ec2e44 <__bss_end+0xeb9eb0>
 158:	00001301 	andeq	r1, r0, r1, lsl #6
 15c:	3f012e0e 	svccc	0x00012e0e
 160:	3a0e0319 	bcc	380dcc <__bss_end+0x377e38>
 164:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 168:	01193c0b 	tsteq	r9, fp, lsl #24
 16c:	0f000013 	svceq	0x00000013
 170:	13490005 	movtne	r0, #36869	; 0x9005
 174:	2e100000 	cdpcs	0, 1, cr0, cr0, cr0, {0}
 178:	03193f01 	tsteq	r9, #1, 30
 17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c5a28>
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
 1a8:	3b0b3a08 	blcc	2ce9d0 <__bss_end+0x2c5a3c>
 1ac:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 1b0:	00180213 	andseq	r0, r8, r3, lsl r2
 1b4:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 1b8:	01111347 	tsteq	r1, r7, asr #6
 1bc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 1c0:	00194297 	mulseq	r9, r7, r2
 1c4:	11010000 	mrsne	r0, (UNDEF: 1)
 1c8:	130e2501 	movwne	r2, #58625	; 0xe501
 1cc:	1b0e030b 	blne	380e00 <__bss_end+0x377e6c>
 1d0:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 1d4:	00171006 	andseq	r1, r7, r6
 1d8:	00240200 	eoreq	r0, r4, r0, lsl #4
 1dc:	0b3e0b0b 	bleq	f82e10 <__bss_end+0xf79e7c>
 1e0:	00000e03 	andeq	r0, r0, r3, lsl #28
 1e4:	49002603 	stmdbmi	r0, {r0, r1, r9, sl, sp}
 1e8:	04000013 	streq	r0, [r0], #-19	; 0xffffffed
 1ec:	0b0b0024 	bleq	2c0284 <__bss_end+0x2b72f0>
 1f0:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 1f4:	16050000 	strne	r0, [r5], -r0
 1f8:	3a0e0300 	bcc	380e00 <__bss_end+0x377e6c>
 1fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 200:	0013490b 	andseq	r4, r3, fp, lsl #18
 204:	01130600 	tsteq	r3, r0, lsl #12
 208:	0b0b0e03 	bleq	2c3a1c <__bss_end+0x2baa88>
 20c:	0b3b0b3a 	bleq	ec2efc <__bss_end+0xeb9f68>
 210:	13010b39 	movwne	r0, #6969	; 0x1b39
 214:	0d070000 	stceq	0, cr0, [r7, #-0]
 218:	3a080300 	bcc	200e20 <__bss_end+0x1f7e8c>
 21c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 220:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 224:	0800000b 	stmdaeq	r0, {r0, r1, r3}
 228:	0e030104 	adfeqs	f0, f3, f4
 22c:	0b3e196d 	bleq	f867e8 <__bss_end+0xf7d854>
 230:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 234:	0b3b0b3a 	bleq	ec2f24 <__bss_end+0xeb9f90>
 238:	13010b39 	movwne	r0, #6969	; 0x1b39
 23c:	28090000 	stmdacs	r9, {}	; <UNPREDICTABLE>
 240:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 244:	0a00000b 	beq	278 <shift+0x278>
 248:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 24c:	0b3b0b3a 	bleq	ec2f3c <__bss_end+0xeb9fa8>
 250:	13490b39 	movtne	r0, #39737	; 0x9b39
 254:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
 258:	020b0000 	andeq	r0, fp, #0
 25c:	3c0e0300 	stccc	3, cr0, [lr], {-0}
 260:	0c000019 	stceq	0, cr0, [r0], {25}
 264:	0e030102 	adfeqs	f0, f3, f2
 268:	0b3a0b0b 	bleq	e82e9c <__bss_end+0xe79f08>
 26c:	0b390b3b 	bleq	e42f60 <__bss_end+0xe39fcc>
 270:	00001301 	andeq	r1, r0, r1, lsl #6
 274:	03000d0d 	movweq	r0, #3341	; 0xd0d
 278:	3b0b3a0e 	blcc	2ceab8 <__bss_end+0x2c5b24>
 27c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 280:	000b3813 	andeq	r3, fp, r3, lsl r8
 284:	012e0e00 			; <UNDEFINED> instruction: 0x012e0e00
 288:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 28c:	0b3b0b3a 	bleq	ec2f7c <__bss_end+0xeb9fe8>
 290:	0e6e0b39 	vmoveq.8	d14[5], r0
 294:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 298:	00001364 	andeq	r1, r0, r4, ror #6
 29c:	4900050f 	stmdbmi	r0, {r0, r1, r2, r3, r8, sl}
 2a0:	00193413 	andseq	r3, r9, r3, lsl r4
 2a4:	00051000 	andeq	r1, r5, r0
 2a8:	00001349 	andeq	r1, r0, r9, asr #6
 2ac:	03000d11 	movweq	r0, #3345	; 0xd11
 2b0:	3b0b3a0e 	blcc	2ceaf0 <__bss_end+0x2c5b5c>
 2b4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 2b8:	3c193f13 	ldccc	15, cr3, [r9], {19}
 2bc:	12000019 	andne	r0, r0, #25
 2c0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 2c4:	0b3a0e03 	bleq	e83ad8 <__bss_end+0xe7ab44>
 2c8:	0b390b3b 	bleq	e42fbc <__bss_end+0xe3a028>
 2cc:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 2d0:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 2d4:	13011364 	movwne	r1, #4964	; 0x1364
 2d8:	2e130000 	cdpcs	0, 1, cr0, cr3, cr0, {0}
 2dc:	03193f01 	tsteq	r9, #1, 30
 2e0:	3b0b3a0e 	blcc	2ceb20 <__bss_end+0x2c5b8c>
 2e4:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 2e8:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
 2ec:	01136419 	tsteq	r3, r9, lsl r4
 2f0:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
 2f4:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 2f8:	0b3a0e03 	bleq	e83b0c <__bss_end+0xe7ab78>
 2fc:	0b390b3b 	bleq	e42ff0 <__bss_end+0xe3a05c>
 300:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 304:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 308:	00001364 	andeq	r1, r0, r4, ror #6
 30c:	49010115 	stmdbmi	r1, {r0, r2, r4, r8}
 310:	00130113 	andseq	r0, r3, r3, lsl r1
 314:	00211600 	eoreq	r1, r1, r0, lsl #12
 318:	0b2f1349 	bleq	bc5044 <__bss_end+0xbbc0b0>
 31c:	0f170000 	svceq	0x00170000
 320:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 324:	18000013 	stmdane	r0, {r0, r1, r4}
 328:	00000021 	andeq	r0, r0, r1, lsr #32
 32c:	03003419 	movweq	r3, #1049	; 0x419
 330:	3b0b3a0e 	blcc	2ceb70 <__bss_end+0x2c5bdc>
 334:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 338:	3c193f13 	ldccc	15, cr3, [r9], {19}
 33c:	1a000019 	bne	3a8 <shift+0x3a8>
 340:	08030028 	stmdaeq	r3, {r3, r5}
 344:	00000b1c 	andeq	r0, r0, ip, lsl fp
 348:	3f012e1b 	svccc	0x00012e1b
 34c:	3a0e0319 	bcc	380fb8 <__bss_end+0x378024>
 350:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 354:	3c0e6e0b 	stccc	14, cr6, [lr], {11}
 358:	01136419 	tsteq	r3, r9, lsl r4
 35c:	1c000013 	stcne	0, cr0, [r0], {19}
 360:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 364:	0b3a0e03 	bleq	e83b78 <__bss_end+0xe7abe4>
 368:	0b390b3b 	bleq	e4305c <__bss_end+0xe3a0c8>
 36c:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 370:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 374:	00001301 	andeq	r1, r0, r1, lsl #6
 378:	03000d1d 	movweq	r0, #3357	; 0xd1d
 37c:	3b0b3a0e 	blcc	2cebbc <__bss_end+0x2c5c28>
 380:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 384:	320b3813 	andcc	r3, fp, #1245184	; 0x130000
 388:	1e00000b 	cdpne	0, 0, cr0, cr0, cr11, {0}
 38c:	13490115 	movtne	r0, #37141	; 0x9115
 390:	13011364 	movwne	r1, #4964	; 0x1364
 394:	1f1f0000 	svcne	0x001f0000
 398:	49131d00 	ldmdbmi	r3, {r8, sl, fp, ip}
 39c:	20000013 	andcs	r0, r0, r3, lsl r0
 3a0:	0b0b0010 	bleq	2c03e8 <__bss_end+0x2b7454>
 3a4:	00001349 	andeq	r1, r0, r9, asr #6
 3a8:	0b000f21 	bleq	4034 <shift+0x4034>
 3ac:	2200000b 	andcs	r0, r0, #11
 3b0:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 3b4:	0000051c 	andeq	r0, r0, ip, lsl r5
 3b8:	03002823 	movweq	r2, #2083	; 0x823
 3bc:	00061c0e 	andeq	r1, r6, lr, lsl #24
 3c0:	012e2400 			; <UNDEFINED> instruction: 0x012e2400
 3c4:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 3c8:	0b3b0b3a 	bleq	ec30b8 <__bss_end+0xeba124>
 3cc:	13490b39 	movtne	r0, #39737	; 0x9b39
 3d0:	06120111 			; <UNDEFINED> instruction: 0x06120111
 3d4:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 3d8:	00130119 	andseq	r0, r3, r9, lsl r1
 3dc:	00052500 	andeq	r2, r5, r0, lsl #10
 3e0:	0b3a0e03 	bleq	e83bf4 <__bss_end+0xe7ac60>
 3e4:	0b390b3b 	bleq	e430d8 <__bss_end+0xe3a144>
 3e8:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 3ec:	34260000 	strtcc	r0, [r6], #-0
 3f0:	3a0e0300 	bcc	380ff8 <__bss_end+0x378064>
 3f4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 3f8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 3fc:	27000018 	smladcs	r0, r8, r0, r0
 400:	08030034 	stmdaeq	r3, {r2, r4, r5}
 404:	0b3b0b3a 	bleq	ec30f4 <__bss_end+0xeba160>
 408:	13490b39 	movtne	r0, #39737	; 0x9b39
 40c:	00001802 	andeq	r1, r0, r2, lsl #16
 410:	11010b28 	tstne	r1, r8, lsr #22
 414:	00061201 	andeq	r1, r6, r1, lsl #4
 418:	012e2900 			; <UNDEFINED> instruction: 0x012e2900
 41c:	0b3a0e03 	bleq	e83c30 <__bss_end+0xe7ac9c>
 420:	0b390b3b 	bleq	e43114 <__bss_end+0xe3a180>
 424:	06120111 			; <UNDEFINED> instruction: 0x06120111
 428:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 42c:	00000019 	andeq	r0, r0, r9, lsl r0
 430:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 434:	030b130e 	movweq	r1, #45838	; 0xb30e
 438:	110e1b0e 	tstne	lr, lr, lsl #22
 43c:	10061201 	andne	r1, r6, r1, lsl #4
 440:	02000017 	andeq	r0, r0, #23
 444:	0b0b0024 	bleq	2c04dc <__bss_end+0x2b7548>
 448:	0e030b3e 	vmoveq.16	d3[0], r0
 44c:	26030000 	strcs	r0, [r3], -r0
 450:	00134900 	andseq	r4, r3, r0, lsl #18
 454:	00240400 	eoreq	r0, r4, r0, lsl #8
 458:	0b3e0b0b 	bleq	f8308c <__bss_end+0xf7a0f8>
 45c:	00000803 	andeq	r0, r0, r3, lsl #16
 460:	03001605 	movweq	r1, #1541	; 0x605
 464:	3b0b3a0e 	blcc	2ceca4 <__bss_end+0x2c5d10>
 468:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 46c:	06000013 			; <UNDEFINED> instruction: 0x06000013
 470:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
 474:	0b3a0b0b 	bleq	e830a8 <__bss_end+0xe7a114>
 478:	0b390b3b 	bleq	e4316c <__bss_end+0xe3a1d8>
 47c:	00001301 	andeq	r1, r0, r1, lsl #6
 480:	03000d07 	movweq	r0, #3335	; 0xd07
 484:	3b0b3a08 	blcc	2cecac <__bss_end+0x2c5d18>
 488:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 48c:	000b3813 	andeq	r3, fp, r3, lsl r8
 490:	01040800 	tsteq	r4, r0, lsl #16
 494:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
 498:	0b0b0b3e 	bleq	2c3198 <__bss_end+0x2ba204>
 49c:	0b3a1349 	bleq	e851c8 <__bss_end+0xe7c234>
 4a0:	0b390b3b 	bleq	e43194 <__bss_end+0xe3a200>
 4a4:	00001301 	andeq	r1, r0, r1, lsl #6
 4a8:	03002809 	movweq	r2, #2057	; 0x809
 4ac:	000b1c08 	andeq	r1, fp, r8, lsl #24
 4b0:	00280a00 	eoreq	r0, r8, r0, lsl #20
 4b4:	0b1c0e03 	bleq	703cc8 <__bss_end+0x6fad34>
 4b8:	340b0000 	strcc	r0, [fp], #-0
 4bc:	3a0e0300 	bcc	3810c4 <__bss_end+0x378130>
 4c0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4c4:	6c13490b 			; <UNDEFINED> instruction: 0x6c13490b
 4c8:	00180219 	andseq	r0, r8, r9, lsl r2
 4cc:	00020c00 	andeq	r0, r2, r0, lsl #24
 4d0:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
 4d4:	020d0000 	andeq	r0, sp, #0
 4d8:	0b0e0301 	bleq	3810e4 <__bss_end+0x378150>
 4dc:	3b0b3a0b 	blcc	2ced10 <__bss_end+0x2c5d7c>
 4e0:	010b390b 	tsteq	fp, fp, lsl #18
 4e4:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
 4e8:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 4ec:	0b3b0b3a 	bleq	ec31dc <__bss_end+0xeba248>
 4f0:	13490b39 	movtne	r0, #39737	; 0x9b39
 4f4:	00000b38 	andeq	r0, r0, r8, lsr fp
 4f8:	3f012e0f 	svccc	0x00012e0f
 4fc:	3a0e0319 	bcc	381168 <__bss_end+0x3781d4>
 500:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 504:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 508:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
 50c:	10000013 	andne	r0, r0, r3, lsl r0
 510:	13490005 	movtne	r0, #36869	; 0x9005
 514:	00001934 	andeq	r1, r0, r4, lsr r9
 518:	49000511 	stmdbmi	r0, {r0, r4, r8, sl}
 51c:	12000013 	andne	r0, r0, #19
 520:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 524:	0b3b0b3a 	bleq	ec3214 <__bss_end+0xeba280>
 528:	13490b39 	movtne	r0, #39737	; 0x9b39
 52c:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 530:	2e130000 	cdpcs	0, 1, cr0, cr3, cr0, {0}
 534:	03193f01 	tsteq	r9, #1, 30
 538:	3b0b3a0e 	blcc	2ced78 <__bss_end+0x2c5de4>
 53c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 540:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 544:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 548:	00130113 	andseq	r0, r3, r3, lsl r1
 54c:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 550:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 554:	0b3b0b3a 	bleq	ec3244 <__bss_end+0xeba2b0>
 558:	0e6e0b39 	vmoveq.8	d14[5], r0
 55c:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 560:	13011364 	movwne	r1, #4964	; 0x1364
 564:	2e150000 	cdpcs	0, 1, cr0, cr5, cr0, {0}
 568:	03193f01 	tsteq	r9, #1, 30
 56c:	3b0b3a0e 	blcc	2cedac <__bss_end+0x2c5e18>
 570:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 574:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 578:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 57c:	16000013 			; <UNDEFINED> instruction: 0x16000013
 580:	13490101 	movtne	r0, #37121	; 0x9101
 584:	00001301 	andeq	r1, r0, r1, lsl #6
 588:	49002117 	stmdbmi	r0, {r0, r1, r2, r4, r8, sp}
 58c:	000b2f13 	andeq	r2, fp, r3, lsl pc
 590:	000f1800 	andeq	r1, pc, r0, lsl #16
 594:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 598:	21190000 	tstcs	r9, r0
 59c:	1a000000 	bne	5a4 <shift+0x5a4>
 5a0:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 5a4:	0b3b0b3a 	bleq	ec3294 <__bss_end+0xeba300>
 5a8:	13490b39 	movtne	r0, #39737	; 0x9b39
 5ac:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 5b0:	2e1b0000 	cdpcs	0, 1, cr0, cr11, cr0, {0}
 5b4:	03193f01 	tsteq	r9, #1, 30
 5b8:	3b0b3a0e 	blcc	2cedf8 <__bss_end+0x2c5e64>
 5bc:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 5c0:	64193c0e 	ldrvs	r3, [r9], #-3086	; 0xfffff3f2
 5c4:	00130113 	andseq	r0, r3, r3, lsl r1
 5c8:	012e1c00 			; <UNDEFINED> instruction: 0x012e1c00
 5cc:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 5d0:	0b3b0b3a 	bleq	ec32c0 <__bss_end+0xeba32c>
 5d4:	0e6e0b39 	vmoveq.8	d14[5], r0
 5d8:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 5dc:	13011364 	movwne	r1, #4964	; 0x1364
 5e0:	0d1d0000 	ldceq	0, cr0, [sp, #-0]
 5e4:	3a0e0300 	bcc	3811ec <__bss_end+0x378258>
 5e8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 5ec:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 5f0:	000b320b 	andeq	r3, fp, fp, lsl #4
 5f4:	01151e00 	tsteq	r5, r0, lsl #28
 5f8:	13641349 	cmnne	r4, #603979777	; 0x24000001
 5fc:	00001301 	andeq	r1, r0, r1, lsl #6
 600:	1d001f1f 	stcne	15, cr1, [r0, #-124]	; 0xffffff84
 604:	00134913 	andseq	r4, r3, r3, lsl r9
 608:	00102000 	andseq	r2, r0, r0
 60c:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 610:	0f210000 	svceq	0x00210000
 614:	000b0b00 	andeq	r0, fp, r0, lsl #22
 618:	00342200 	eorseq	r2, r4, r0, lsl #4
 61c:	0b3a0e03 	bleq	e83e30 <__bss_end+0xe7ae9c>
 620:	0b390b3b 	bleq	e43314 <__bss_end+0xe3a380>
 624:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 628:	2e230000 	cdpcs	0, 2, cr0, cr3, cr0, {0}
 62c:	03193f01 	tsteq	r9, #1, 30
 630:	3b0b3a0e 	blcc	2cee70 <__bss_end+0x2c5edc>
 634:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 638:	1113490e 	tstne	r3, lr, lsl #18
 63c:	40061201 	andmi	r1, r6, r1, lsl #4
 640:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 644:	00001301 	andeq	r1, r0, r1, lsl #6
 648:	03000524 	movweq	r0, #1316	; 0x524
 64c:	3b0b3a0e 	blcc	2cee8c <__bss_end+0x2c5ef8>
 650:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 654:	00180213 	andseq	r0, r8, r3, lsl r2
 658:	012e2500 			; <UNDEFINED> instruction: 0x012e2500
 65c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 660:	0b3b0b3a 	bleq	ec3350 <__bss_end+0xeba3bc>
 664:	0e6e0b39 	vmoveq.8	d14[5], r0
 668:	01111349 	tsteq	r1, r9, asr #6
 66c:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 670:	01194297 			; <UNDEFINED> instruction: 0x01194297
 674:	26000013 			; <UNDEFINED> instruction: 0x26000013
 678:	08030034 	stmdaeq	r3, {r2, r4, r5}
 67c:	0b3b0b3a 	bleq	ec336c <__bss_end+0xeba3d8>
 680:	13490b39 	movtne	r0, #39737	; 0x9b39
 684:	00001802 	andeq	r1, r0, r2, lsl #16
 688:	3f012e27 	svccc	0x00012e27
 68c:	3a0e0319 	bcc	3812f8 <__bss_end+0x378364>
 690:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 694:	110e6e0b 	tstne	lr, fp, lsl #28
 698:	40061201 	andmi	r1, r6, r1, lsl #4
 69c:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 6a0:	00001301 	andeq	r1, r0, r1, lsl #6
 6a4:	3f002e28 	svccc	0x00002e28
 6a8:	3a0e0319 	bcc	381314 <__bss_end+0x378380>
 6ac:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 6b0:	110e6e0b 	tstne	lr, fp, lsl #28
 6b4:	40061201 	andmi	r1, r6, r1, lsl #4
 6b8:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 6bc:	2e290000 	cdpcs	0, 2, cr0, cr9, cr0, {0}
 6c0:	03193f01 	tsteq	r9, #1, 30
 6c4:	3b0b3a0e 	blcc	2cef04 <__bss_end+0x2c5f70>
 6c8:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 6cc:	1113490e 	tstne	r3, lr, lsl #18
 6d0:	40061201 	andmi	r1, r6, r1, lsl #4
 6d4:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 6d8:	01000000 	mrseq	r0, (UNDEF: 0)
 6dc:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 6e0:	0e030b13 	vmoveq.32	d3[0], r0
 6e4:	01110e1b 	tsteq	r1, fp, lsl lr
 6e8:	17100612 			; <UNDEFINED> instruction: 0x17100612
 6ec:	39020000 	stmdbcc	r2, {}	; <UNPREDICTABLE>
 6f0:	00130101 	andseq	r0, r3, r1, lsl #2
 6f4:	00340300 	eorseq	r0, r4, r0, lsl #6
 6f8:	0b3a0e03 	bleq	e83f0c <__bss_end+0xe7af78>
 6fc:	0b390b3b 	bleq	e433f0 <__bss_end+0xe3a45c>
 700:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 704:	00000a1c 	andeq	r0, r0, ip, lsl sl
 708:	3a003a04 	bcc	ef20 <__bss_end+0x5f8c>
 70c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 710:	0013180b 	andseq	r1, r3, fp, lsl #16
 714:	01010500 	tsteq	r1, r0, lsl #10
 718:	13011349 	movwne	r1, #4937	; 0x1349
 71c:	21060000 	mrscs	r0, (UNDEF: 6)
 720:	2f134900 	svccs	0x00134900
 724:	0700000b 	streq	r0, [r0, -fp]
 728:	13490026 	movtne	r0, #36902	; 0x9026
 72c:	24080000 	strcs	r0, [r8], #-0
 730:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 734:	000e030b 	andeq	r0, lr, fp, lsl #6
 738:	00340900 	eorseq	r0, r4, r0, lsl #18
 73c:	00001347 	andeq	r1, r0, r7, asr #6
 740:	3f012e0a 	svccc	0x00012e0a
 744:	3a0e0319 	bcc	3813b0 <__bss_end+0x37841c>
 748:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 74c:	110e6e0b 	tstne	lr, fp, lsl #28
 750:	40061201 	andmi	r1, r6, r1, lsl #4
 754:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 758:	00001301 	andeq	r1, r0, r1, lsl #6
 75c:	0300050b 	movweq	r0, #1291	; 0x50b
 760:	3b0b3a08 	blcc	2cef88 <__bss_end+0x2c5ff4>
 764:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 768:	00180213 	andseq	r0, r8, r3, lsl r2
 76c:	00340c00 	eorseq	r0, r4, r0, lsl #24
 770:	0b3a0e03 	bleq	e83f84 <__bss_end+0xe7aff0>
 774:	0b390b3b 	bleq	e43468 <__bss_end+0xe3a4d4>
 778:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 77c:	0b0d0000 	bleq	340784 <__bss_end+0x3377f0>
 780:	12011101 	andne	r1, r1, #1073741824	; 0x40000000
 784:	0e000006 	cdpeq	0, 0, cr0, cr0, cr6, {0}
 788:	08030034 	stmdaeq	r3, {r2, r4, r5}
 78c:	0b3b0b3a 	bleq	ec347c <__bss_end+0xeba4e8>
 790:	13490b39 	movtne	r0, #39737	; 0x9b39
 794:	00001802 	andeq	r1, r0, r2, lsl #16
 798:	0b000f0f 	bleq	43dc <shift+0x43dc>
 79c:	0013490b 	andseq	r4, r3, fp, lsl #18
 7a0:	00261000 	eoreq	r1, r6, r0
 7a4:	0f110000 	svceq	0x00110000
 7a8:	000b0b00 	andeq	r0, fp, r0, lsl #22
 7ac:	00241200 	eoreq	r1, r4, r0, lsl #4
 7b0:	0b3e0b0b 	bleq	f833e4 <__bss_end+0xf7a450>
 7b4:	00000803 	andeq	r0, r0, r3, lsl #16
 7b8:	03000513 	movweq	r0, #1299	; 0x513
 7bc:	3b0b3a0e 	blcc	2ceffc <__bss_end+0x2c6068>
 7c0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 7c4:	00180213 	andseq	r0, r8, r3, lsl r2
 7c8:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 7cc:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 7d0:	0b3b0b3a 	bleq	ec34c0 <__bss_end+0xeba52c>
 7d4:	0e6e0b39 	vmoveq.8	d14[5], r0
 7d8:	01111349 	tsteq	r1, r9, asr #6
 7dc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 7e0:	01194297 			; <UNDEFINED> instruction: 0x01194297
 7e4:	15000013 	strne	r0, [r0, #-19]	; 0xffffffed
 7e8:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 7ec:	0b3a0e03 	bleq	e84000 <__bss_end+0xe7b06c>
 7f0:	0b390b3b 	bleq	e434e4 <__bss_end+0xe3a550>
 7f4:	01110e6e 	tsteq	r1, lr, ror #28
 7f8:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 7fc:	00194296 	mulseq	r9, r6, r2
 800:	11010000 	mrsne	r0, (UNDEF: 1)
 804:	11061000 	mrsne	r1, (UNDEF: 6)
 808:	03011201 	movweq	r1, #4609	; 0x1201
 80c:	250e1b0e 	strcs	r1, [lr, #-2830]	; 0xfffff4f2
 810:	0005130e 	andeq	r1, r5, lr, lsl #6
 814:	11010000 	mrsne	r0, (UNDEF: 1)
 818:	11061000 	mrsne	r1, (UNDEF: 6)
 81c:	03011201 	movweq	r1, #4609	; 0x1201
 820:	250e1b0e 	strcs	r1, [lr, #-2830]	; 0xfffff4f2
 824:	0005130e 	andeq	r1, r5, lr, lsl #6
 828:	11010000 	mrsne	r0, (UNDEF: 1)
 82c:	130e2501 	movwne	r2, #58625	; 0xe501
 830:	1b0e030b 	blne	381464 <__bss_end+0x3784d0>
 834:	0017100e 	andseq	r1, r7, lr
 838:	00240200 	eoreq	r0, r4, r0, lsl #4
 83c:	0b3e0b0b 	bleq	f83470 <__bss_end+0xf7a4dc>
 840:	00000803 	andeq	r0, r0, r3, lsl #16
 844:	0b002403 	bleq	9858 <__bss_end+0x8c4>
 848:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 84c:	0400000e 	streq	r0, [r0], #-14
 850:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 854:	0b3b0b3a 	bleq	ec3544 <__bss_end+0xeba5b0>
 858:	13490b39 	movtne	r0, #39737	; 0x9b39
 85c:	0f050000 	svceq	0x00050000
 860:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 864:	06000013 			; <UNDEFINED> instruction: 0x06000013
 868:	19270115 	stmdbne	r7!, {r0, r2, r4, r8}
 86c:	13011349 	movwne	r1, #4937	; 0x1349
 870:	05070000 	streq	r0, [r7, #-0]
 874:	00134900 	andseq	r4, r3, r0, lsl #18
 878:	00260800 	eoreq	r0, r6, r0, lsl #16
 87c:	34090000 	strcc	r0, [r9], #-0
 880:	3a0e0300 	bcc	381488 <__bss_end+0x3784f4>
 884:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 888:	3f13490b 	svccc	0x0013490b
 88c:	00193c19 	andseq	r3, r9, r9, lsl ip
 890:	01040a00 	tsteq	r4, r0, lsl #20
 894:	0b3e0e03 	bleq	f840a8 <__bss_end+0xf7b114>
 898:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 89c:	0b3b0b3a 	bleq	ec358c <__bss_end+0xeba5f8>
 8a0:	13010b39 	movwne	r0, #6969	; 0x1b39
 8a4:	280b0000 	stmdacs	fp, {}	; <UNPREDICTABLE>
 8a8:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 8ac:	0c00000b 	stceq	0, cr0, [r0], {11}
 8b0:	13490101 	movtne	r0, #37121	; 0x9101
 8b4:	00001301 	andeq	r1, r0, r1, lsl #6
 8b8:	0000210d 	andeq	r2, r0, sp, lsl #2
 8bc:	00260e00 	eoreq	r0, r6, r0, lsl #28
 8c0:	00001349 	andeq	r1, r0, r9, asr #6
 8c4:	0300340f 	movweq	r3, #1039	; 0x40f
 8c8:	3b0b3a0e 	blcc	2cf108 <__bss_end+0x2c6174>
 8cc:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 8d0:	3c193f13 	ldccc	15, cr3, [r9], {19}
 8d4:	10000019 	andne	r0, r0, r9, lsl r0
 8d8:	0e030013 	mcreq	0, 0, r0, cr3, cr3, {0}
 8dc:	0000193c 	andeq	r1, r0, ip, lsr r9
 8e0:	27001511 	smladcs	r0, r1, r5, r1
 8e4:	12000019 	andne	r0, r0, #25
 8e8:	0e030017 	mcreq	0, 0, r0, cr3, cr7, {0}
 8ec:	0000193c 	andeq	r1, r0, ip, lsr r9
 8f0:	03011313 	movweq	r1, #4883	; 0x1313
 8f4:	3a0b0b0e 	bcc	2c3534 <__bss_end+0x2ba5a0>
 8f8:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 8fc:	0013010b 	andseq	r0, r3, fp, lsl #2
 900:	000d1400 	andeq	r1, sp, r0, lsl #8
 904:	0b3a0e03 	bleq	e84118 <__bss_end+0xe7b184>
 908:	0b39053b 	bleq	e41dfc <__bss_end+0xe38e68>
 90c:	0b381349 	bleq	e05638 <__bss_end+0xdfc6a4>
 910:	21150000 	tstcs	r5, r0
 914:	2f134900 	svccs	0x00134900
 918:	1600000b 	strne	r0, [r0], -fp
 91c:	0e030104 	adfeqs	f0, f3, f4
 920:	0b0b0b3e 	bleq	2c3620 <__bss_end+0x2ba68c>
 924:	0b3a1349 	bleq	e85650 <__bss_end+0xe7c6bc>
 928:	0b39053b 	bleq	e41e1c <__bss_end+0xe38e88>
 92c:	00001301 	andeq	r1, r0, r1, lsl #6
 930:	47003417 	smladmi	r0, r7, r4, r3
 934:	3b0b3a13 	blcc	2cf188 <__bss_end+0x2c61f4>
 938:	020b3905 	andeq	r3, fp, #81920	; 0x14000
 93c:	00000018 	andeq	r0, r0, r8, lsl r0

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
  74:	00000180 	andeq	r0, r0, r0, lsl #3
	...
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	0c810002 	stceq	0, cr0, [r1], {2}
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	000083b8 			; <UNDEFINED> instruction: 0x000083b8
  94:	0000045c 	andeq	r0, r0, ip, asr r4
	...
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	195c0002 	ldmdbne	ip, {r1}^
  a8:	00040000 	andeq	r0, r4, r0
  ac:	00000000 	andeq	r0, r0, r0
  b0:	00008814 	andeq	r8, r0, r4, lsl r8
  b4:	000004b8 			; <UNDEFINED> instruction: 0x000004b8
	...
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	1c8e0002 	stcne	0, cr0, [lr], {2}
  c8:	00040000 	andeq	r0, r4, r0
  cc:	00000000 	andeq	r0, r0, r0
  d0:	00008ccc 	andeq	r8, r0, ip, asr #25
  d4:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	1cb40002 	ldcne	0, cr0, [r4], #8
  e8:	00040000 	andeq	r0, r4, r0
  ec:	00000000 	andeq	r0, r0, r0
  f0:	00008ed8 	ldrdeq	r8, [r0], -r8	; <UNPREDICTABLE>
  f4:	00000004 	andeq	r0, r0, r4
	...
 100:	00000014 	andeq	r0, r0, r4, lsl r0
 104:	1cda0002 	ldclne	0, cr0, [sl], {2}
 108:	00040000 	andeq	r0, r4, r0
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffff4c <__bss_end+0xffff6fb8>
       4:	63732f65 	cmnvs	r3, #404	; 0x194
       8:	6b6e6568 	blvs	1b995b0 <__bss_end+0x1b9061c>
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
      48:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffd21 <__bss_end+0xffff6d8d>
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
      84:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffd5d <__bss_end+0xffff6dc9>
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
     20c:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffee5 <__bss_end+0xffff6f51>
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
     248:	2b2b4320 	blcs	ad0ed0 <__bss_end+0xac7f3c>
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
     2cc:	6a363731 	bvs	d8df98 <__bss_end+0xd85004>
     2d0:	732d667a 			; <UNDEFINED> instruction: 0x732d667a
     2d4:	616d2d20 	cmnvs	sp, r0, lsr #26
     2d8:	2d206d72 	stccs	13, cr6, [r0, #-456]!	; 0xfffffe38
     2dc:	6372616d 	cmnvs	r2, #1073741851	; 0x4000001b
     2e0:	72613d68 	rsbvc	r3, r1, #104, 26	; 0x1a00
     2e4:	7a36766d 	bvc	d9dca0 <__bss_end+0xd94d0c>
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
     39c:	5f524200 	svcpl	0x00524200
     3a0:	30363735 	eorscc	r3, r6, r5, lsr r7
     3a4:	69540030 	ldmdbvs	r4, {r4, r5}^
     3a8:	435f6b63 	cmpmi	pc, #101376	; 0x18c00
     3ac:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     3b0:	646e4900 	strbtvs	r4, [lr], #-2304	; 0xfffff700
     3b4:	6e696665 	cdpvs	6, 6, cr6, cr9, cr5, {3}
     3b8:	00657469 	rsbeq	r7, r5, r9, ror #8
     3bc:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
     3c0:	41554e00 	cmpmi	r5, r0, lsl #28
     3c4:	435f5452 	cmpmi	pc, #1375731712	; 0x52000000
     3c8:	5f726168 	svcpl	0x00726168
     3cc:	676e654c 	strbvs	r6, [lr, -ip, asr #10]!
     3d0:	73006874 	movwvc	r6, #2164	; 0x874
     3d4:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
     3d8:	52420067 	subpl	r0, r2, #103	; 0x67
     3dc:	3034325f 	eorscc	r3, r4, pc, asr r2
     3e0:	72700030 	rsbsvc	r0, r0, #48	; 0x30
     3e4:	5f007665 	svcpl	0x00007665
     3e8:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     3ec:	6f725043 	svcvs	0x00725043
     3f0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     3f4:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     3f8:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     3fc:	6f4e3431 	svcvs	0x004e3431
     400:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     404:	6f72505f 	svcvs	0x0072505f
     408:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     40c:	32315045 	eorscc	r5, r1, #69	; 0x45
     410:	73615454 	cmnvc	r1, #84, 8	; 0x54000000
     414:	74535f6b 	ldrbvc	r5, [r3], #-3947	; 0xfffff095
     418:	74637572 	strbtvc	r7, [r3], #-1394	; 0xfffffa8e
     41c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     420:	46433131 			; <UNDEFINED> instruction: 0x46433131
     424:	73656c69 	cmnvc	r5, #26880	; 0x6900
     428:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     42c:	5433316d 	ldrtpl	r3, [r3], #-365	; 0xfffffe93
     430:	545f5346 	ldrbpl	r5, [pc], #-838	; 438 <shift+0x438>
     434:	5f656572 	svcpl	0x00656572
     438:	65646f4e 	strbvs	r6, [r4, #-3918]!	; 0xfffff0b2
     43c:	69463031 	stmdbvs	r6, {r0, r4, r5, ip, sp}^
     440:	435f646e 	cmpmi	pc, #1845493760	; 0x6e000000
     444:	646c6968 	strbtvs	r6, [ip], #-2408	; 0xfffff698
     448:	634b5045 	movtvs	r5, #45125	; 0xb045
     44c:	6d6e5500 	cfstr64vs	mvdx5, [lr, #-0]
     450:	465f7061 	ldrbmi	r7, [pc], -r1, rrx
     454:	5f656c69 	svcpl	0x00656c69
     458:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     45c:	00746e65 	rsbseq	r6, r4, r5, ror #28
     460:	6f72506d 	svcvs	0x0072506d
     464:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     468:	73694c5f 	cmnvc	r9, #24320	; 0x5f00
     46c:	65485f74 	strbvs	r5, [r8, #-3956]	; 0xfffff08c
     470:	62006461 	andvs	r6, r0, #1627389952	; 0x61000000
     474:	5f647561 	svcpl	0x00647561
     478:	65746172 	ldrbvs	r6, [r4, #-370]!	; 0xfffffe8e
     47c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     480:	4336314b 	teqmi	r6, #-1073741806	; 0xc0000012
     484:	636f7250 	cmnvs	pc, #80, 4
     488:	5f737365 	svcpl	0x00737365
     48c:	616e614d 	cmnvs	lr, sp, asr #2
     490:	31726567 	cmncc	r2, r7, ror #10
     494:	74654739 	strbtvc	r4, [r5], #-1849	; 0xfffff8c7
     498:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     49c:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     4a0:	6f72505f 	svcvs	0x0072505f
     4a4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     4a8:	42007645 	andmi	r7, r0, #72351744	; 0x4500000
     4ac:	38345f52 	ldmdacc	r4!, {r1, r4, r6, r8, r9, sl, fp, ip, lr}
     4b0:	6e003030 	mcrvs	0, 0, r3, cr0, cr0, {1}
     4b4:	00747865 	rsbseq	r7, r4, r5, ror #16
     4b8:	5f746547 	svcpl	0x00746547
     4bc:	636f7250 	cmnvs	pc, #80, 4
     4c0:	5f737365 	svcpl	0x00737365
     4c4:	505f7942 	subspl	r7, pc, r2, asr #18
     4c8:	6d004449 	cfstrsvs	mvf4, [r0, #-292]	; 0xfffffedc
     4cc:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     4d0:	6e696f50 	mcrvs	15, 3, r6, cr9, cr0, {2}
     4d4:	616c0074 	smcvs	49156	; 0xc004
     4d8:	745f7473 	ldrbvc	r7, [pc], #-1139	; 4e0 <shift+0x4e0>
     4dc:	006b6369 	rsbeq	r6, fp, r9, ror #6
     4e0:	69447369 	stmdbvs	r4, {r0, r3, r5, r6, r8, r9, ip, sp, lr}^
     4e4:	74636572 	strbtvc	r6, [r3], #-1394	; 0xfffffa8e
     4e8:	0079726f 	rsbseq	r7, r9, pc, ror #4
     4ec:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
     4f0:	6f72505f 	svcvs	0x0072505f
     4f4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     4f8:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
     4fc:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     500:	61655200 	cmnvs	r5, r0, lsl #4
     504:	63410064 	movtvs	r0, #4196	; 0x1064
     508:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
     50c:	6f72505f 	svcvs	0x0072505f
     510:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     514:	756f435f 	strbvc	r4, [pc, #-863]!	; 1bd <shift+0x1bd>
     518:	4300746e 	movwmi	r7, #1134	; 0x46e
     51c:	74616572 	strbtvc	r6, [r1], #-1394	; 0xfffffa8e
     520:	72505f65 	subsvc	r5, r0, #404	; 0x194
     524:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     528:	61700073 	cmnvs	r0, r3, ror r0
     52c:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     530:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     534:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     538:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
     53c:	676e654c 	strbvs	r6, [lr, -ip, asr #10]!
     540:	2f006874 	svccs	0x00006874
     544:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     548:	6863732f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, sp, lr}^
     54c:	6a6b6e65 	bvs	1adbee8 <__bss_end+0x1ad2f54>
     550:	32736f2f 	rsbscc	r6, r3, #47, 30	; 0xbc
     554:	2f323230 	svccs	0x00323230
     558:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
     55c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     560:	752f7365 	strvc	r7, [pc, #-869]!	; 203 <shift+0x203>
     564:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     568:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     56c:	676f6c2f 	strbvs	r6, [pc, -pc, lsr #24]!
     570:	5f726567 	svcpl	0x00726567
     574:	6b736174 	blvs	1cd8b4c <__bss_end+0x1ccfbb8>
     578:	69616d2f 	stmdbvs	r1!, {r0, r1, r2, r3, r5, r8, sl, fp, sp, lr}^
     57c:	70632e6e 	rsbvc	r2, r3, lr, ror #28
     580:	65470070 	strbvs	r0, [r7, #-112]	; 0xffffff90
     584:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     588:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     58c:	5f72656c 	svcpl	0x0072656c
     590:	6f666e49 	svcvs	0x00666e49
     594:	61654400 	cmnvs	r5, r0, lsl #8
     598:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     59c:	6e555f65 	cdpvs	15, 5, cr5, cr5, cr5, {3}
     5a0:	6e616863 	cdpvs	8, 6, cr6, cr1, cr3, {3}
     5a4:	00646567 	rsbeq	r6, r4, r7, ror #10
     5a8:	6f725043 	svcvs	0x00725043
     5ac:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     5b0:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     5b4:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     5b8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     5bc:	46433131 			; <UNDEFINED> instruction: 0x46433131
     5c0:	73656c69 	cmnvc	r5, #26880	; 0x6900
     5c4:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     5c8:	4534436d 	ldrmi	r4, [r4, #-877]!	; 0xfffffc93
     5cc:	46540076 			; <UNDEFINED> instruction: 0x46540076
     5d0:	72445f53 	subvc	r5, r4, #332	; 0x14c
     5d4:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     5d8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     5dc:	50433631 	subpl	r3, r3, r1, lsr r6
     5e0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     5e4:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 420 <shift+0x420>
     5e8:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     5ec:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     5f0:	5f746547 	svcpl	0x00746547
     5f4:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     5f8:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     5fc:	6e495f72 	mcrvs	15, 2, r5, cr9, cr2, {3}
     600:	32456f66 	subcc	r6, r5, #408	; 0x198
     604:	65474e30 	strbvs	r4, [r7, #-3632]	; 0xfffff1d0
     608:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     60c:	5f646568 	svcpl	0x00646568
     610:	6f666e49 	svcvs	0x00666e49
     614:	7079545f 	rsbsvc	r5, r9, pc, asr r4
     618:	00765065 	rsbseq	r5, r6, r5, rrx
     61c:	314e5a5f 	cmpcc	lr, pc, asr sl
     620:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     624:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     628:	614d5f73 	hvcvs	54771	; 0xd5f3
     62c:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     630:	48313272 	ldmdami	r1!, {r1, r4, r5, r6, r9, ip, sp}
     634:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     638:	69465f65 	stmdbvs	r6, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     63c:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     640:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     644:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     648:	4e333245 	cdpmi	2, 3, cr3, cr3, cr5, {2}
     64c:	5f495753 	svcpl	0x00495753
     650:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     654:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     658:	535f6d65 	cmppl	pc, #6464	; 0x1940
     65c:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     660:	6a6a6563 	bvs	1a99bf4 <__bss_end+0x1a90c60>
     664:	3131526a 	teqcc	r1, sl, ror #4
     668:	49575354 	ldmdbmi	r7, {r2, r4, r6, r8, r9, ip, lr}^
     66c:	7365525f 	cmnvc	r5, #-268435451	; 0xf0000005
     670:	00746c75 	rsbseq	r6, r4, r5, ror ip
     674:	6e65706f 	cdpvs	0, 6, cr7, cr5, cr15, {3}
     678:	665f6465 	ldrbvs	r6, [pc], -r5, ror #8
     67c:	73656c69 	cmnvc	r5, #26880	; 0x6900
     680:	746f4e00 	strbtvc	r4, [pc], #-3584	; 688 <shift+0x688>
     684:	41796669 	cmnmi	r9, r9, ror #12
     688:	54006c6c 	strpl	r6, [r0], #-3180	; 0xfffff394
     68c:	5f555043 	svcpl	0x00555043
     690:	746e6f43 	strbtvc	r6, [lr], #-3907	; 0xfffff0bd
     694:	00747865 	rsbseq	r7, r4, r5, ror #16
     698:	64616544 	strbtvs	r6, [r1], #-1348	; 0xfffffabc
     69c:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     6a0:	62747400 	rsbsvs	r7, r4, #0, 8
     6a4:	5f003072 	svcpl	0x00003072
     6a8:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     6ac:	6f725043 	svcvs	0x00725043
     6b0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     6b4:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     6b8:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     6bc:	6f4e3431 	svcvs	0x004e3431
     6c0:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     6c4:	6f72505f 	svcvs	0x0072505f
     6c8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     6cc:	47006a45 	strmi	r6, [r0, -r5, asr #20]
     6d0:	505f7465 	subspl	r7, pc, r5, ror #8
     6d4:	46004449 	strmi	r4, [r0], -r9, asr #8
     6d8:	5f646e69 	svcpl	0x00646e69
     6dc:	6c696843 	stclvs	8, cr6, [r9], #-268	; 0xfffffef4
     6e0:	6f6e0064 	svcvs	0x006e0064
     6e4:	69666974 	stmdbvs	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     6e8:	645f6465 	ldrbvs	r6, [pc], #-1125	; 6f0 <shift+0x6f0>
     6ec:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     6f0:	00656e69 	rsbeq	r6, r5, r9, ror #28
     6f4:	5241554e 	subpl	r5, r1, #327155712	; 0x13800000
     6f8:	61425f54 	cmpvs	r2, r4, asr pc
     6fc:	525f6475 	subspl	r6, pc, #1962934272	; 0x75000000
     700:	00657461 	rsbeq	r7, r5, r1, ror #8
     704:	72616843 	rsbvc	r6, r1, #4390912	; 0x430000
     708:	4300375f 	movwmi	r3, #1887	; 0x75f
     70c:	5f726168 	svcpl	0x00726168
     710:	614d0038 	cmpvs	sp, r8, lsr r0
     714:	72505f78 	subsvc	r5, r0, #120, 30	; 0x1e0
     718:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     71c:	704f5f73 	subvc	r5, pc, r3, ror pc	; <UNPREDICTABLE>
     720:	64656e65 	strbtvs	r6, [r5], #-3685	; 0xfffff19b
     724:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     728:	5f007365 	svcpl	0x00007365
     72c:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     730:	6f725043 	svcvs	0x00725043
     734:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     738:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     73c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     740:	6e553831 	mrcvs	8, 2, r3, cr5, cr1, {1}
     744:	5f70616d 	svcpl	0x0070616d
     748:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     74c:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     750:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     754:	67006a45 	strvs	r6, [r0, -r5, asr #20]
     758:	445f5346 	ldrbmi	r5, [pc], #-838	; 760 <shift+0x760>
     75c:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     760:	435f7372 	cmpmi	pc, #-939524095	; 0xc8000001
     764:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     768:	6f526d00 	svcvs	0x00526d00
     76c:	535f746f 	cmppl	pc, #1862270976	; 0x6f000000
     770:	47007379 	smlsdxmi	r0, r9, r3, r7
     774:	435f7465 	cmpmi	pc, #1694498816	; 0x65000000
     778:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     77c:	505f746e 	subspl	r7, pc, lr, ror #8
     780:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     784:	4d007373 	stcmi	3, cr7, [r0, #-460]	; 0xfffffe34
     788:	465f7061 	ldrbmi	r7, [pc], -r1, rrx
     78c:	5f656c69 	svcpl	0x00656c69
     790:	435f6f54 	cmpmi	pc, #84, 30	; 0x150
     794:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     798:	4e00746e 	cdpmi	4, 0, cr7, cr0, cr14, {3}
     79c:	6c69466f 	stclvs	6, cr4, [r9], #-444	; 0xfffffe44
     7a0:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     7a4:	446d6574 	strbtmi	r6, [sp], #-1396	; 0xfffffa8c
     7a8:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     7ac:	65530072 	ldrbvs	r0, [r3, #-114]	; 0xffffff8e
     7b0:	61505f74 	cmpvs	r0, r4, ror pc
     7b4:	736d6172 	cmnvc	sp, #-2147483620	; 0x8000001c
     7b8:	6e614800 	cdpvs	8, 6, cr4, cr1, cr0, {0}
     7bc:	5f656c64 	svcpl	0x00656c64
     7c0:	636f7250 	cmnvs	pc, #80, 4
     7c4:	5f737365 	svcpl	0x00737365
     7c8:	00495753 	subeq	r5, r9, r3, asr r7
     7cc:	726f6873 	rsbvc	r6, pc, #7536640	; 0x730000
     7d0:	6e752074 	mrcvs	0, 3, r2, cr5, cr4, {3}
     7d4:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
     7d8:	69206465 	stmdbvs	r0!, {r0, r2, r5, r6, sl, sp, lr}
     7dc:	5300746e 	movwpl	r7, #1134	; 0x46e
     7e0:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     7e4:	5f656c75 	svcpl	0x00656c75
     7e8:	00464445 	subeq	r4, r6, r5, asr #8
     7ec:	74696157 	strbtvc	r6, [r9], #-343	; 0xfffffea9
     7f0:	73694400 	cmnvc	r9, #0, 8
     7f4:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     7f8:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     7fc:	445f746e 	ldrbmi	r7, [pc], #-1134	; 804 <shift+0x804>
     800:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     804:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     808:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     80c:	46433131 			; <UNDEFINED> instruction: 0x46433131
     810:	73656c69 	cmnvc	r5, #26880	; 0x6900
     814:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     818:	4930316d 	ldmdbmi	r0!, {r0, r2, r3, r5, r6, r8, ip, sp}
     81c:	6974696e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, fp, sp, lr}^
     820:	7a696c61 	bvc	1a5b9ac <__bss_end+0x1a52a18>
     824:	00764565 	rsbseq	r4, r6, r5, ror #10
     828:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     82c:	70757272 	rsbsvc	r7, r5, r2, ror r2
     830:	6c626174 	stfvse	f6, [r2], #-464	; 0xfffffe30
     834:	6c535f65 	mrrcvs	15, 6, r5, r3, cr5
     838:	00706565 	rsbseq	r6, r0, r5, ror #10
     83c:	6f6f526d 	svcvs	0x006f526d
     840:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     844:	6f620076 	svcvs	0x00620076
     848:	6d006c6f 	stcvs	12, cr6, [r0, #-444]	; 0xfffffe44
     84c:	7473614c 	ldrbtvc	r6, [r3], #-332	; 0xfffffeb4
     850:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
     854:	6f6c4200 	svcvs	0x006c4200
     858:	64656b63 	strbtvs	r6, [r5], #-2915	; 0xfffff49d
     85c:	65474e00 	strbvs	r4, [r7, #-3584]	; 0xfffff200
     860:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     864:	5f646568 	svcpl	0x00646568
     868:	6f666e49 	svcvs	0x00666e49
     86c:	7079545f 	rsbsvc	r5, r9, pc, asr r4
     870:	75520065 	ldrbvc	r0, [r2, #-101]	; 0xffffff9b
     874:	62616e6e 	rsbvs	r6, r1, #1760	; 0x6e0
     878:	4e00656c 	cfsh32mi	mvfx6, mvfx0, #60
     87c:	6b736154 	blvs	1cd8dd4 <__bss_end+0x1ccfe40>
     880:	6174535f 	cmnvs	r4, pc, asr r3
     884:	42006574 	andmi	r6, r0, #116, 10	; 0x1d000000
     888:	38335f52 	ldmdacc	r3!, {r1, r4, r6, r8, r9, sl, fp, ip, lr}
     88c:	00303034 	eorseq	r3, r0, r4, lsr r0
     890:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
     894:	6f635f64 	svcvs	0x00635f64
     898:	65746e75 	ldrbvs	r6, [r4, #-3701]!	; 0xfffff18b
     89c:	63730072 	cmnvs	r3, #114	; 0x72
     8a0:	5f646568 	svcpl	0x00646568
     8a4:	74617473 	strbtvc	r7, [r1], #-1139	; 0xfffffb8d
     8a8:	705f6369 	subsvc	r6, pc, r9, ror #6
     8ac:	726f6972 	rsbvc	r6, pc, #1867776	; 0x1c8000
     8b0:	00797469 	rsbseq	r7, r9, r9, ror #8
     8b4:	74696e49 	strbtvc	r6, [r9], #-3657	; 0xfffff1b7
     8b8:	696c6169 	stmdbvs	ip!, {r0, r3, r5, r6, r8, sp, lr}^
     8bc:	6700657a 	smlsdxvs	r0, sl, r5, r6
     8c0:	445f5346 	ldrbmi	r5, [pc], #-838	; 8c8 <shift+0x8c8>
     8c4:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     8c8:	65007372 	strvs	r7, [r0, #-882]	; 0xfffffc8e
     8cc:	5f746978 	svcpl	0x00746978
     8d0:	65646f63 	strbvs	r6, [r4, #-3939]!	; 0xfffff09d
     8d4:	5f524200 	svcpl	0x00524200
     8d8:	32353131 	eorscc	r3, r5, #1073741836	; 0x4000000c
     8dc:	6d003030 	stcvs	0, cr3, [r0, #-192]	; 0xffffff40
     8e0:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     8e4:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     8e8:	636e465f 	cmnvs	lr, #99614720	; 0x5f00000
     8ec:	72507300 	subsvc	r7, r0, #0, 6
     8f0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     8f4:	72674d73 	rsbvc	r4, r7, #7360	; 0x1cc0
     8f8:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     8fc:	72445346 	subvc	r5, r4, #402653185	; 0x18000001
     900:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     904:	656d614e 	strbvs	r6, [sp, #-334]!	; 0xfffffeb2
     908:	676e654c 	strbvs	r6, [lr, -ip, asr #10]!
     90c:	4e006874 	mcrmi	8, 0, r6, cr0, cr4, {3}
     910:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     914:	6f4c0079 	svcvs	0x004c0079
     918:	555f6b63 	ldrbpl	r6, [pc, #-2915]	; fffffdbd <__bss_end+0xffff6e29>
     91c:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
     920:	0064656b 	rsbeq	r6, r4, fp, ror #10
     924:	74757066 	ldrbtvc	r7, [r5], #-102	; 0xffffff9a
     928:	6f4c0073 	svcvs	0x004c0073
     92c:	4c5f6b63 	mrrcmi	11, 6, r6, pc, cr3	; <UNPREDICTABLE>
     930:	656b636f 	strbvs	r6, [fp, #-879]!	; 0xfffffc91
     934:	55540064 	ldrbpl	r0, [r4, #-100]	; 0xffffff9c
     938:	5f545241 	svcpl	0x00545241
     93c:	74434f49 	strbvc	r4, [r3], #-3913	; 0xfffff0b7
     940:	61505f6c 	cmpvs	r0, ip, ror #30
     944:	736d6172 	cmnvc	sp, #-2147483620	; 0x8000001c
     948:	61655200 	cmnvs	r5, r0, lsl #4
     94c:	72575f64 	subsvc	r5, r7, #100, 30	; 0x190
     950:	00657469 	rsbeq	r7, r5, r9, ror #8
     954:	626d6f5a 	rsbvs	r6, sp, #360	; 0x168
     958:	47006569 	strmi	r6, [r0, -r9, ror #10]
     95c:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     960:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     964:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     968:	5a5f006f 	bpl	17c0b2c <__bss_end+0x17b7b98>
     96c:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     970:	636f7250 	cmnvs	pc, #80, 4
     974:	5f737365 	svcpl	0x00737365
     978:	616e614d 	cmnvs	lr, sp, asr #2
     97c:	38726567 	ldmdacc	r2!, {r0, r1, r2, r5, r6, r8, sl, sp, lr}^
     980:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     984:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     988:	5f007645 	svcpl	0x00007645
     98c:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     990:	6f725043 	svcvs	0x00725043
     994:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     998:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     99c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     9a0:	614d3931 	cmpvs	sp, r1, lsr r9
     9a4:	69465f70 	stmdbvs	r6, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     9a8:	545f656c 	ldrbpl	r6, [pc], #-1388	; 9b0 <shift+0x9b0>
     9ac:	75435f6f 	strbvc	r5, [r3, #-3951]	; 0xfffff091
     9b0:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     9b4:	35504574 	ldrbcc	r4, [r0, #-1396]	; 0xfffffa8c
     9b8:	6c694649 	stclvs	6, cr4, [r9], #-292	; 0xfffffedc
     9bc:	65470065 	strbvs	r0, [r7, #-101]	; 0xffffff9b
     9c0:	61505f74 	cmpvs	r0, r4, ror pc
     9c4:	736d6172 	cmnvc	sp, #-2147483620	; 0x8000001c
     9c8:	69686300 	stmdbvs	r8!, {r8, r9, sp, lr}^
     9cc:	6572646c 	ldrbvs	r6, [r2, #-1132]!	; 0xfffffb94
     9d0:	614d006e 	cmpvs	sp, lr, rrx
     9d4:	74615078 	strbtvc	r5, [r1], #-120	; 0xffffff88
     9d8:	6e654c68 	cdpvs	12, 6, cr4, cr5, cr8, {3}
     9dc:	00687467 	rsbeq	r7, r8, r7, ror #8
     9e0:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
     9e4:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
     9e8:	61686320 	cmnvs	r8, r0, lsr #6
     9ec:	5a5f0072 	bpl	17c0bbc <__bss_end+0x17b7c28>
     9f0:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     9f4:	636f7250 	cmnvs	pc, #80, 4
     9f8:	5f737365 	svcpl	0x00737365
     9fc:	616e614d 	cmnvs	lr, sp, asr #2
     a00:	31726567 	cmncc	r2, r7, ror #10
     a04:	68635332 	stmdavs	r3!, {r1, r4, r5, r8, r9, ip, lr}^
     a08:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     a0c:	44455f65 	strbmi	r5, [r5], #-3941	; 0xfffff09b
     a10:	00764546 	rsbseq	r4, r6, r6, asr #10
     a14:	6c694643 	stclvs	6, cr4, [r9], #-268	; 0xfffffef4
     a18:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     a1c:	006d6574 	rsbeq	r6, sp, r4, ror r5
     a20:	726f6873 	rsbvc	r6, pc, #7536640	; 0x730000
     a24:	6e692074 	mcrvs	0, 3, r2, cr9, cr4, {3}
     a28:	61750074 	cmnvs	r5, r4, ror r0
     a2c:	665f7472 			; <UNDEFINED> instruction: 0x665f7472
     a30:	00656c69 	rsbeq	r6, r5, r9, ror #24
     a34:	62616e45 	rsbvs	r6, r1, #1104	; 0x450
     a38:	455f656c 	ldrbmi	r6, [pc, #-1388]	; 4d4 <shift+0x4d4>
     a3c:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     a40:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     a44:	69746365 	ldmdbvs	r4!, {r0, r2, r5, r6, r8, r9, sp, lr}^
     a48:	6d006e6f 	stcvs	14, cr6, [r0, #-444]	; 0xfffffe44
     a4c:	746f6f52 	strbtvc	r6, [pc], #-3922	; a54 <shift+0xa54>
     a50:	69467300 	stmdbvs	r6, {r8, r9, ip, sp, lr}^
     a54:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     a58:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     a5c:	6e755200 	cdpvs	2, 7, cr5, cr5, cr0, {0}
     a60:	676e696e 	strbvs	r6, [lr, -lr, ror #18]!
     a64:	6e697500 	cdpvs	5, 6, cr7, cr9, cr0, {0}
     a68:	5f323374 	svcpl	0x00323374
     a6c:	69740074 	ldmdbvs	r4!, {r2, r4, r5, r6}^
     a70:	75626b63 	strbvc	r6, [r2, #-2915]!	; 0xfffff49d
     a74:	436d0066 	cmnmi	sp, #102	; 0x66
     a78:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     a7c:	545f746e 	ldrbpl	r7, [pc], #-1134	; a84 <shift+0xa84>
     a80:	5f6b7361 	svcpl	0x006b7361
     a84:	65646f4e 	strbvs	r6, [r4, #-3918]!	; 0xfffff0b2
     a88:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     a8c:	46433131 			; <UNDEFINED> instruction: 0x46433131
     a90:	73656c69 	cmnvc	r5, #26880	; 0x6900
     a94:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     a98:	704f346d 	subvc	r3, pc, sp, ror #8
     a9c:	50456e65 	subpl	r6, r5, r5, ror #28
     aa0:	3531634b 	ldrcc	r6, [r1, #-843]!	; 0xfffffcb5
     aa4:	6c69464e 	stclvs	6, cr4, [r9], #-312	; 0xfffffec8
     aa8:	704f5f65 	subvc	r5, pc, r5, ror #30
     aac:	4d5f6e65 	ldclmi	14, cr6, [pc, #-404]	; 920 <shift+0x920>
     ab0:	0065646f 	rsbeq	r6, r5, pc, ror #8
     ab4:	72616863 	rsbvc	r6, r1, #6488064	; 0x630000
     ab8:	6e656c5f 	mcrvs	12, 3, r6, cr5, cr15, {2}
     abc:	00687467 	rsbeq	r7, r8, r7, ror #8
     ac0:	61726170 	cmnvs	r2, r0, ror r1
     ac4:	6400736d 	strvs	r7, [r0], #-877	; 0xfffffc93
     ac8:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     acc:	64695f72 	strbtvs	r5, [r9], #-3954	; 0xfffff08e
     ad0:	65520078 	ldrbvs	r0, [r2, #-120]	; 0xffffff88
     ad4:	4f5f6461 	svcmi	0x005f6461
     ad8:	00796c6e 	rsbseq	r6, r9, lr, ror #24
     adc:	65656c73 	strbvs	r6, [r5, #-3187]!	; 0xfffff38d
     ae0:	69745f70 	ldmdbvs	r4!, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     ae4:	0072656d 	rsbseq	r6, r2, sp, ror #10
     ae8:	4b4e5a5f 	blmi	139746c <__bss_end+0x138e4d8>
     aec:	50433631 	subpl	r3, r3, r1, lsr r6
     af0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     af4:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 930 <shift+0x930>
     af8:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     afc:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     b00:	5f746547 	svcpl	0x00746547
     b04:	636f7250 	cmnvs	pc, #80, 4
     b08:	5f737365 	svcpl	0x00737365
     b0c:	505f7942 	subspl	r7, pc, r2, asr #18
     b10:	6a454449 	bvs	1151c3c <__bss_end+0x1148ca8>
     b14:	6e614800 	cdpvs	8, 6, cr4, cr1, cr0, {0}
     b18:	5f656c64 	svcpl	0x00656c64
     b1c:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     b20:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     b24:	535f6d65 	cmppl	pc, #6464	; 0x1940
     b28:	5f004957 	svcpl	0x00004957
     b2c:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     b30:	6f725043 	svcvs	0x00725043
     b34:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     b38:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     b3c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     b40:	63533131 	cmpvs	r3, #1073741836	; 0x4000000c
     b44:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     b48:	525f656c 	subspl	r6, pc, #108, 10	; 0x1b000000
     b4c:	00764552 	rsbseq	r4, r6, r2, asr r5
     b50:	6b736174 	blvs	1cd9128 <__bss_end+0x1cd0194>
     b54:	5f524200 	svcpl	0x00524200
     b58:	30323931 	eorscc	r3, r2, r1, lsr r9
     b5c:	6f4e0030 	svcvs	0x004e0030
     b60:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     b64:	6f72505f 	svcvs	0x0072505f
     b68:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     b6c:	68635300 	stmdavs	r3!, {r8, r9, ip, lr}^
     b70:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     b74:	5a5f0065 	bpl	17c0d10 <__bss_end+0x17b7d7c>
     b78:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     b7c:	636f7250 	cmnvs	pc, #80, 4
     b80:	5f737365 	svcpl	0x00737365
     b84:	616e614d 	cmnvs	lr, sp, asr #2
     b88:	32726567 	rsbscc	r6, r2, #432013312	; 0x19c00000
     b8c:	6f6c4231 	svcvs	0x006c4231
     b90:	435f6b63 	cmpmi	pc, #101376	; 0x18c00
     b94:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     b98:	505f746e 	subspl	r7, pc, lr, ror #8
     b9c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     ba0:	76457373 			; <UNDEFINED> instruction: 0x76457373
     ba4:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     ba8:	50433631 	subpl	r3, r3, r1, lsr r6
     bac:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     bb0:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 9ec <shift+0x9ec>
     bb4:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     bb8:	53397265 	teqpl	r9, #1342177286	; 0x50000006
     bbc:	63746977 	cmnvs	r4, #1949696	; 0x1dc000
     bc0:	6f545f68 	svcvs	0x00545f68
     bc4:	38315045 	ldmdacc	r1!, {r0, r2, r6, ip, lr}
     bc8:	6f725043 	svcvs	0x00725043
     bcc:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     bd0:	73694c5f 	cmnvc	r9, #24320	; 0x5f00
     bd4:	6f4e5f74 	svcvs	0x004e5f74
     bd8:	53006564 	movwpl	r6, #1380	; 0x564
     bdc:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     be0:	5f656c75 	svcpl	0x00656c75
     be4:	5f005252 	svcpl	0x00005252
     be8:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     bec:	6f725043 	svcvs	0x00725043
     bf0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     bf4:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     bf8:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     bfc:	61483831 	cmpvs	r8, r1, lsr r8
     c00:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     c04:	6f72505f 	svcvs	0x0072505f
     c08:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     c0c:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     c10:	4e303245 	cdpmi	2, 3, cr3, cr0, cr5, {2}
     c14:	5f495753 	svcpl	0x00495753
     c18:	636f7250 	cmnvs	pc, #80, 4
     c1c:	5f737365 	svcpl	0x00737365
     c20:	76726553 			; <UNDEFINED> instruction: 0x76726553
     c24:	6a656369 	bvs	19599d0 <__bss_end+0x1950a3c>
     c28:	31526a6a 	cmpcc	r2, sl, ror #20
     c2c:	57535431 	smmlarpl	r3, r1, r4, r5
     c30:	65525f49 	ldrbvs	r5, [r2, #-3913]	; 0xfffff0b7
     c34:	746c7573 	strbtvc	r7, [ip], #-1395	; 0xfffffa8d
     c38:	67726100 	ldrbvs	r6, [r2, -r0, lsl #2]!
     c3c:	494e0076 	stmdbmi	lr, {r1, r2, r4, r5, r6}^
     c40:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
     c44:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
     c48:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
     c4c:	5f006e6f 	svcpl	0x00006e6f
     c50:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     c54:	6f725043 	svcvs	0x00725043
     c58:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     c5c:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     c60:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     c64:	72433431 	subvc	r3, r3, #822083584	; 0x31000000
     c68:	65746165 	ldrbvs	r6, [r4, #-357]!	; 0xfffffe9b
     c6c:	6f72505f 	svcvs	0x0072505f
     c70:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     c74:	6a685045 	bvs	1a14d90 <__bss_end+0x1a0bdfc>
     c78:	77530062 	ldrbvc	r0, [r3, -r2, rrx]
     c7c:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
     c80:	006f545f 	rsbeq	r5, pc, pc, asr r4	; <UNPREDICTABLE>
     c84:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
     c88:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     c8c:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     c90:	5f6d6574 	svcpl	0x006d6574
     c94:	76726553 			; <UNDEFINED> instruction: 0x76726553
     c98:	00656369 	rsbeq	r6, r5, r9, ror #6
     c9c:	315f5242 	cmpcc	pc, r2, asr #4
     ca0:	00303032 	eorseq	r3, r0, r2, lsr r0
     ca4:	61766e49 	cmnvs	r6, r9, asr #28
     ca8:	5f64696c 	svcpl	0x0064696c
     cac:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     cb0:	5400656c 	strpl	r6, [r0], #-1388	; 0xfffffa94
     cb4:	545f5346 	ldrbpl	r5, [pc], #-838	; cbc <shift+0xcbc>
     cb8:	5f656572 	svcpl	0x00656572
     cbc:	65646f4e 	strbvs	r6, [r4, #-3918]!	; 0xfffff0b2
     cc0:	6f6c4200 	svcvs	0x006c4200
     cc4:	435f6b63 	cmpmi	pc, #101376	; 0x18c00
     cc8:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     ccc:	505f746e 	subspl	r7, pc, lr, ror #8
     cd0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     cd4:	42007373 	andmi	r7, r0, #-872415231	; 0xcc000001
     cd8:	36395f52 	shsaxcc	r5, r9, r2
     cdc:	43003030 	movwmi	r3, #48	; 0x30
     ce0:	65736f6c 	ldrbvs	r6, [r3, #-3948]!	; 0xfffff094
     ce4:	69726400 	ldmdbvs	r2!, {sl, sp, lr}^
     ce8:	00726576 	rsbseq	r6, r2, r6, ror r5
     cec:	63677261 	cmnvs	r7, #268435462	; 0x10000006
     cf0:	69464900 	stmdbvs	r6, {r8, fp, lr}^
     cf4:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     cf8:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     cfc:	6972445f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, sl, lr}^
     d00:	00726576 	rsbseq	r6, r2, r6, ror r5
     d04:	74697257 	strbtvc	r7, [r9], #-599	; 0xfffffda9
     d08:	6e4f5f65 	cdpvs	15, 4, cr5, cr15, cr5, {3}
     d0c:	6d00796c 	vstrvs.16	s14, [r0, #-216]	; 0xffffff28	; <UNPREDICTABLE>
     d10:	006e6961 	rsbeq	r6, lr, r1, ror #18
     d14:	6c656959 			; <UNDEFINED> instruction: 0x6c656959
     d18:	5a5f0064 	bpl	17c0eb0 <__bss_end+0x17b7f1c>
     d1c:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     d20:	636f7250 	cmnvs	pc, #80, 4
     d24:	5f737365 	svcpl	0x00737365
     d28:	616e614d 	cmnvs	lr, sp, asr #2
     d2c:	43726567 	cmnmi	r2, #432013312	; 0x19c00000
     d30:	00764534 	rsbseq	r4, r6, r4, lsr r5
     d34:	6f6f526d 	svcvs	0x006f526d
     d38:	6e4d5f74 	mcrvs	15, 2, r5, cr13, cr4, {3}
     d3c:	70630074 	rsbvc	r0, r3, r4, ror r0
     d40:	6f635f75 	svcvs	0x00635f75
     d44:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
     d48:	65540074 	ldrbvs	r0, [r4, #-116]	; 0xffffff8c
     d4c:	6e696d72 	mcrvs	13, 3, r6, cr9, cr2, {3}
     d50:	00657461 	rsbeq	r7, r5, r1, ror #8
     d54:	74434f49 	strbvc	r4, [r3], #-3913	; 0xfffff0b7
     d58:	6f6c006c 	svcvs	0x006c006c
     d5c:	70697067 	rsbvc	r7, r9, r7, rrx
     d60:	6c630065 	stclvs	0, cr0, [r3], #-404	; 0xfffffe6c
     d64:	0065736f 	rsbeq	r7, r5, pc, ror #6
     d68:	5f746553 	svcpl	0x00746553
     d6c:	616c6552 	cmnvs	ip, r2, asr r5
     d70:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
     d74:	74657200 	strbtvc	r7, [r5], #-512	; 0xfffffe00
     d78:	006c6176 	rsbeq	r6, ip, r6, ror r1
     d7c:	7275636e 	rsbsvc	r6, r5, #-1207959551	; 0xb8000001
     d80:	6e647200 	cdpvs	2, 6, cr7, cr4, cr0, {0}
     d84:	5f006d75 	svcpl	0x00006d75
     d88:	7331315a 	teqvc	r1, #-2147483626	; 0x80000016
     d8c:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     d90:	6569795f 	strbvs	r7, [r9, #-2399]!	; 0xfffff6a1
     d94:	0076646c 	rsbseq	r6, r6, ip, ror #8
     d98:	37315a5f 			; <UNDEFINED> instruction: 0x37315a5f
     d9c:	5f746573 	svcpl	0x00746573
     da0:	6b736174 	blvs	1cd9378 <__bss_end+0x1cd03e4>
     da4:	6165645f 	cmnvs	r5, pc, asr r4
     da8:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     dac:	77006a65 	strvc	r6, [r0, -r5, ror #20]
     db0:	00746961 	rsbseq	r6, r4, r1, ror #18
     db4:	6e365a5f 			; <UNDEFINED> instruction: 0x6e365a5f
     db8:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     dbc:	006a6a79 	rsbeq	r6, sl, r9, ror sl
     dc0:	74395a5f 	ldrtvc	r5, [r9], #-2655	; 0xfffff5a1
     dc4:	696d7265 	stmdbvs	sp!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     dc8:	6574616e 	ldrbvs	r6, [r4, #-366]!	; 0xfffffe92
     dcc:	682f0069 	stmdavs	pc!, {r0, r3, r5, r6}	; <UNPREDICTABLE>
     dd0:	2f656d6f 	svccs	0x00656d6f
     dd4:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
     dd8:	2f6a6b6e 	svccs	0x006a6b6e
     ddc:	3032736f 	eorscc	r7, r2, pc, ror #6
     de0:	732f3232 			; <UNDEFINED> instruction: 0x732f3232
     de4:	6f732f70 	svcvs	0x00732f70
     de8:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     dec:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
     df0:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
     df4:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     df8:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
     dfc:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     e00:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     e04:	69614600 	stmdbvs	r1!, {r9, sl, lr}^
     e08:	7865006c 	stmdavc	r5!, {r2, r3, r5, r6}^
     e0c:	6f637469 	svcvs	0x00637469
     e10:	5f006564 	svcpl	0x00006564
     e14:	6734325a 			; <UNDEFINED> instruction: 0x6734325a
     e18:	615f7465 	cmpvs	pc, r5, ror #8
     e1c:	76697463 	strbtvc	r7, [r9], -r3, ror #8
     e20:	72705f65 	rsbsvc	r5, r0, #404	; 0x194
     e24:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     e28:	6f635f73 	svcvs	0x00635f73
     e2c:	76746e75 			; <UNDEFINED> instruction: 0x76746e75
     e30:	68637300 	stmdavs	r3!, {r8, r9, ip, sp, lr}^
     e34:	795f6465 	ldmdbvc	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     e38:	646c6569 	strbtvs	r6, [ip], #-1385	; 0xfffffa97
     e3c:	63697400 	cmnvs	r9, #0, 8
     e40:	6f635f6b 	svcvs	0x00635f6b
     e44:	5f746e75 	svcpl	0x00746e75
     e48:	75716572 	ldrbvc	r6, [r1, #-1394]!	; 0xfffffa8e
     e4c:	64657269 	strbtvs	r7, [r5], #-617	; 0xfffffd97
     e50:	70695000 	rsbvc	r5, r9, r0
     e54:	69465f65 	stmdbvs	r6, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     e58:	505f656c 	subspl	r6, pc, ip, ror #10
     e5c:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     e60:	5a5f0078 	bpl	17c1048 <__bss_end+0x17b80b4>
     e64:	65673431 	strbvs	r3, [r7, #-1073]!	; 0xfffffbcf
     e68:	69745f74 	ldmdbvs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     e6c:	635f6b63 	cmpvs	pc, #101376	; 0x18c00
     e70:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     e74:	6c730076 	ldclvs	0, cr0, [r3], #-472	; 0xfffffe28
     e78:	00706565 	rsbseq	r6, r0, r5, ror #10
     e7c:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; dc8 <shift+0xdc8>
     e80:	63732f65 	cmnvs	r3, #404	; 0x194
     e84:	6b6e6568 	blvs	1b9a42c <__bss_end+0x1b91498>
     e88:	736f2f6a 	cmnvc	pc, #424	; 0x1a8
     e8c:	32323032 	eorscc	r3, r2, #50	; 0x32
     e90:	2f70732f 	svccs	0x0070732f
     e94:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     e98:	2f736563 	svccs	0x00736563
     e9c:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
     ea0:	706f0064 	rsbvc	r0, pc, r4, rrx
     ea4:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
     ea8:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     eac:	63355a5f 	teqvs	r5, #389120	; 0x5f000
     eb0:	65736f6c 	ldrbvs	r6, [r3, #-3948]!	; 0xfffff094
     eb4:	5a5f006a 	bpl	17c1064 <__bss_end+0x17b80d0>
     eb8:	74656736 	strbtvc	r6, [r5], #-1846	; 0xfffff8ca
     ebc:	76646970 			; <UNDEFINED> instruction: 0x76646970
     ec0:	616e6600 	cmnvs	lr, r0, lsl #12
     ec4:	6e00656d 	cfsh32vs	mvfx6, mvfx0, #61
     ec8:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     ecc:	69740079 	ldmdbvs	r4!, {r0, r3, r4, r5, r6}^
     ed0:	00736b63 	rsbseq	r6, r3, r3, ror #22
     ed4:	6e65706f 	cdpvs	0, 6, cr7, cr5, cr15, {3}
     ed8:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
     edc:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
     ee0:	6a634b50 	bvs	18d3c28 <__bss_end+0x18cac94>
     ee4:	65444e00 	strbvs	r4, [r4, #-3584]	; 0xfffff200
     ee8:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     eec:	535f656e 	cmppl	pc, #461373440	; 0x1b800000
     ef0:	65736275 	ldrbvs	r6, [r3, #-629]!	; 0xfffffd8b
     ef4:	63697672 	cmnvs	r9, #119537664	; 0x7200000
     ef8:	65670065 	strbvs	r0, [r7, #-101]!	; 0xffffff9b
     efc:	69745f74 	ldmdbvs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     f00:	635f6b63 	cmpvs	pc, #101376	; 0x18c00
     f04:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     f08:	72617000 	rsbvc	r7, r1, #0
     f0c:	5f006d61 	svcpl	0x00006d61
     f10:	7277355a 	rsbsvc	r3, r7, #377487360	; 0x16800000
     f14:	6a657469 	bvs	195e0c0 <__bss_end+0x195512c>
     f18:	6a634b50 	bvs	18d3c60 <__bss_end+0x18caccc>
     f1c:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
     f20:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
     f24:	69745f6b 	ldmdbvs	r4!, {r0, r1, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     f28:	5f736b63 	svcpl	0x00736b63
     f2c:	645f6f74 	ldrbvs	r6, [pc], #-3956	; f34 <shift+0xf34>
     f30:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     f34:	00656e69 	rsbeq	r6, r5, r9, ror #28
     f38:	5f667562 	svcpl	0x00667562
     f3c:	657a6973 	ldrbvs	r6, [sl, #-2419]!	; 0xfffff68d
     f40:	69727700 	ldmdbvs	r2!, {r8, r9, sl, ip, sp, lr}^
     f44:	73006574 	movwvc	r6, #1396	; 0x574
     f48:	745f7465 	ldrbvc	r7, [pc], #-1125	; f50 <shift+0xf50>
     f4c:	5f6b7361 	svcpl	0x006b7361
     f50:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
     f54:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     f58:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
     f5c:	65656c73 	strbvs	r6, [r5, #-3187]!	; 0xfffff38d
     f60:	006a6a70 	rsbeq	r6, sl, r0, ror sl
     f64:	5f746547 	svcpl	0x00746547
     f68:	616d6552 	cmnvs	sp, r2, asr r5
     f6c:	6e696e69 	cdpvs	14, 6, cr6, cr9, cr9, {3}
     f70:	5a5f0067 	bpl	17c1114 <__bss_end+0x17b8180>
     f74:	65673632 	strbvs	r3, [r7, #-1586]!	; 0xfffff9ce
     f78:	61745f74 	cmnvs	r4, r4, ror pc
     f7c:	745f6b73 	ldrbvc	r6, [pc], #-2931	; f84 <shift+0xf84>
     f80:	736b6369 	cmnvc	fp, #-1543503871	; 0xa4000001
     f84:	5f6f745f 	svcpl	0x006f745f
     f88:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
     f8c:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     f90:	534e0076 	movtpl	r0, #57462	; 0xe076
     f94:	525f4957 	subspl	r4, pc, #1425408	; 0x15c000
     f98:	6c757365 	ldclvs	3, cr7, [r5], #-404	; 0xfffffe6c
     f9c:	6f435f74 	svcvs	0x00435f74
     fa0:	77006564 	strvc	r6, [r0, -r4, ror #10]
     fa4:	6d756e72 	ldclvs	14, cr6, [r5, #-456]!	; 0xfffffe38
     fa8:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
     fac:	74696177 	strbtvc	r6, [r9], #-375	; 0xfffffe89
     fb0:	006a6a6a 	rsbeq	r6, sl, sl, ror #20
     fb4:	69355a5f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}
     fb8:	6c74636f 	ldclvs	3, cr6, [r4], #-444	; 0xfffffe44
     fbc:	4e36316a 	rsfmisz	f3, f6, #2.0
     fc0:	74434f49 	strbvc	r4, [r3], #-3913	; 0xfffff0b7
     fc4:	704f5f6c 	subvc	r5, pc, ip, ror #30
     fc8:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
     fcc:	506e6f69 	rsbpl	r6, lr, r9, ror #30
     fd0:	6f690076 	svcvs	0x00690076
     fd4:	006c7463 	rsbeq	r7, ip, r3, ror #8
     fd8:	63746572 	cmnvs	r4, #478150656	; 0x1c800000
     fdc:	7400746e 	strvc	r7, [r0], #-1134	; 0xfffffb92
     fe0:	696d7265 	stmdbvs	sp!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     fe4:	6574616e 	ldrbvs	r6, [r4, #-366]!	; 0xfffffe92
     fe8:	646f6d00 	strbtvs	r6, [pc], #-3328	; ff0 <shift+0xff0>
     fec:	75620065 	strbvc	r0, [r2, #-101]!	; 0xffffff9b
     ff0:	72656666 	rsbvc	r6, r5, #106954752	; 0x6600000
     ff4:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
     ff8:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
     ffc:	6a63506a 	bvs	18d51ac <__bss_end+0x18cc218>
    1000:	74657200 	strbtvc	r7, [r5], #-512	; 0xfffffe00
    1004:	65646f63 	strbvs	r6, [r4, #-3939]!	; 0xfffff09d
    1008:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
    100c:	7463615f 	strbtvc	r6, [r3], #-351	; 0xfffffea1
    1010:	5f657669 	svcpl	0x00657669
    1014:	636f7270 	cmnvs	pc, #112, 4
    1018:	5f737365 	svcpl	0x00737365
    101c:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
    1020:	69660074 	stmdbvs	r6!, {r2, r4, r5, r6}^
    1024:	616e656c 	cmnvs	lr, ip, ror #10
    1028:	7200656d 	andvc	r6, r0, #457179136	; 0x1b400000
    102c:	00646165 	rsbeq	r6, r4, r5, ror #2
    1030:	70746567 	rsbsvc	r6, r4, r7, ror #10
    1034:	5f006469 	svcpl	0x00006469
    1038:	706f345a 	rsbvc	r3, pc, sl, asr r4	; <UNPREDICTABLE>
    103c:	4b506e65 	blmi	141c9d8 <__bss_end+0x1413a44>
    1040:	4e353163 	rsfmisz	f3, f5, f3
    1044:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    1048:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
    104c:	6f4d5f6e 	svcvs	0x004d5f6e
    1050:	47006564 	strmi	r6, [r0, -r4, ror #10]
    1054:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
    1058:	34312b2b 	ldrtcc	r2, [r1], #-2859	; 0xfffff4d5
    105c:	322e3920 	eorcc	r3, lr, #32, 18	; 0x80000
    1060:	3220312e 	eorcc	r3, r0, #-2147483637	; 0x8000000b
    1064:	31393130 	teqcc	r9, r0, lsr r1
    1068:	20353230 	eorscs	r3, r5, r0, lsr r2
    106c:	6c657228 	sfmvs	f7, 2, [r5], #-160	; 0xffffff60
    1070:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
    1074:	415b2029 	cmpmi	fp, r9, lsr #32
    1078:	612f4d52 			; <UNDEFINED> instruction: 0x612f4d52
    107c:	392d6d72 	pushcc	{r1, r4, r5, r6, r8, sl, fp, sp, lr}
    1080:	6172622d 	cmnvs	r2, sp, lsr #4
    1084:	2068636e 	rsbcs	r6, r8, lr, ror #6
    1088:	69766572 	ldmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    108c:	6e6f6973 			; <UNDEFINED> instruction: 0x6e6f6973
    1090:	37373220 	ldrcc	r3, [r7, -r0, lsr #4]!
    1094:	5d393935 			; <UNDEFINED> instruction: 0x5d393935
    1098:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    109c:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    10a0:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
    10a4:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
    10a8:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
    10ac:	3d757066 	ldclcc	0, cr7, [r5, #-408]!	; 0xfffffe68
    10b0:	20706676 	rsbscs	r6, r0, r6, ror r6
    10b4:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
    10b8:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
    10bc:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
    10c0:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    10c4:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    10c8:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
    10cc:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    10d0:	6e75746d 	cdpvs	4, 7, cr7, cr5, cr13, {3}
    10d4:	72613d65 	rsbvc	r3, r1, #6464	; 0x1940
    10d8:	3731316d 	ldrcc	r3, [r1, -sp, ror #2]!
    10dc:	667a6a36 			; <UNDEFINED> instruction: 0x667a6a36
    10e0:	2d20732d 	stccs	3, cr7, [r0, #-180]!	; 0xffffff4c
    10e4:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
    10e8:	616d2d20 	cmnvs	sp, r0, lsr #26
    10ec:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
    10f0:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    10f4:	2b6b7a36 	blcs	1adf9d4 <__bss_end+0x1ad6a40>
    10f8:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    10fc:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    1100:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    1104:	20304f2d 	eorscs	r4, r0, sp, lsr #30
    1108:	20304f2d 	eorscs	r4, r0, sp, lsr #30
    110c:	6f6e662d 	svcvs	0x006e662d
    1110:	6378652d 	cmnvs	r8, #188743680	; 0xb400000
    1114:	69747065 	ldmdbvs	r4!, {r0, r2, r5, r6, ip, sp, lr}^
    1118:	20736e6f 	rsbscs	r6, r3, pc, ror #28
    111c:	6f6e662d 	svcvs	0x006e662d
    1120:	7474722d 	ldrbtvc	r7, [r4], #-557	; 0xfffffdd3
    1124:	6e690069 	cdpvs	0, 6, cr0, cr9, cr9, {3}
    1128:	00747570 	rsbseq	r7, r4, r0, ror r5
    112c:	74736564 	ldrbtvc	r6, [r3], #-1380	; 0xfffffa9c
    1130:	657a6200 	ldrbvs	r6, [sl, #-512]!	; 0xfffffe00
    1134:	5f006f72 	svcpl	0x00006f72
    1138:	7a62355a 	bvc	188e6a8 <__bss_end+0x1885714>
    113c:	506f7265 	rsbpl	r7, pc, r5, ror #4
    1140:	5f006976 	svcpl	0x00006976
    1144:	7461345a 	strbtvc	r3, [r1], #-1114	; 0xfffffba6
    1148:	4b50696f 	blmi	141b70c <__bss_end+0x1412778>
    114c:	682f0063 	stmdavs	pc!, {r0, r1, r5, r6}	; <UNPREDICTABLE>
    1150:	2f656d6f 	svccs	0x00656d6f
    1154:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
    1158:	2f6a6b6e 	svccs	0x006a6b6e
    115c:	3032736f 	eorscc	r7, r2, pc, ror #6
    1160:	732f3232 			; <UNDEFINED> instruction: 0x732f3232
    1164:	6f732f70 	svcvs	0x00732f70
    1168:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    116c:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
    1170:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
    1174:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
    1178:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    117c:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    1180:	632e676e 			; <UNDEFINED> instruction: 0x632e676e
    1184:	43007070 	movwmi	r7, #112	; 0x70
    1188:	43726168 	cmnmi	r2, #104, 2
    118c:	41766e6f 	cmnmi	r6, pc, ror #28
    1190:	6d007272 	sfmvs	f7, 4, [r0, #-456]	; 0xfffffe38
    1194:	73646d65 	cmnvc	r4, #6464	; 0x1940
    1198:	756f0074 	strbvc	r0, [pc, #-116]!	; 112c <shift+0x112c>
    119c:	74757074 	ldrbtvc	r7, [r5], #-116	; 0xffffff8c
    11a0:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
    11a4:	636d656d 	cmnvs	sp, #457179136	; 0x1b400000
    11a8:	4b507970 	blmi	141f770 <__bss_end+0x14167dc>
    11ac:	69765076 	ldmdbvs	r6!, {r1, r2, r4, r5, r6, ip, lr}^
    11b0:	73616200 	cmnvc	r1, #0, 4
    11b4:	656d0065 	strbvs	r0, [sp, #-101]!	; 0xffffff9b
    11b8:	7970636d 	ldmdbvc	r0!, {r0, r2, r3, r5, r6, r8, r9, sp, lr}^
    11bc:	72747300 	rsbsvc	r7, r4, #0, 6
    11c0:	006e656c 	rsbeq	r6, lr, ip, ror #10
    11c4:	73375a5f 	teqvc	r7, #389120	; 0x5f000
    11c8:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    11cc:	4b50706d 	blmi	141d388 <__bss_end+0x14143f4>
    11d0:	5f305363 	svcpl	0x00305363
    11d4:	5a5f0069 	bpl	17c1380 <__bss_end+0x17b83ec>
    11d8:	72747336 	rsbsvc	r7, r4, #-671088640	; 0xd8000000
    11dc:	506e656c 	rsbpl	r6, lr, ip, ror #10
    11e0:	6100634b 	tstvs	r0, fp, asr #6
    11e4:	00696f74 	rsbeq	r6, r9, r4, ror pc
    11e8:	73375a5f 	teqvc	r7, #389120	; 0x5f000
    11ec:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    11f0:	63507970 	cmpvs	r0, #112, 18	; 0x1c0000
    11f4:	69634b50 	stmdbvs	r3!, {r4, r6, r8, r9, fp, lr}^
    11f8:	72747300 	rsbsvc	r7, r4, #0, 6
    11fc:	706d636e 	rsbvc	r6, sp, lr, ror #6
    1200:	72747300 	rsbsvc	r7, r4, #0, 6
    1204:	7970636e 	ldmdbvc	r0!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
    1208:	6d656d00 	stclvs	13, cr6, [r5, #-0]
    120c:	0079726f 	rsbseq	r7, r9, pc, ror #4
    1210:	736d656d 	cmnvc	sp, #457179136	; 0x1b400000
    1214:	69006372 	stmdbvs	r0, {r1, r4, r5, r6, r8, r9, sp, lr}
    1218:	00616f74 	rsbeq	r6, r1, r4, ror pc
    121c:	69345a5f 	ldmdbvs	r4!, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}
    1220:	6a616f74 	bvs	185cff8 <__bss_end+0x1854064>
    1224:	006a6350 	rsbeq	r6, sl, r0, asr r3
    1228:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    122c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1230:	2f2e2e2f 	svccs	0x002e2e2f
    1234:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1238:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    123c:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1240:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
    1244:	2f676966 	svccs	0x00676966
    1248:	2f6d7261 	svccs	0x006d7261
    124c:	3162696c 	cmncc	r2, ip, ror #18
    1250:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
    1254:	00532e73 	subseq	r2, r3, r3, ror lr
    1258:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
    125c:	672f646c 	strvs	r6, [pc, -ip, ror #8]!
    1260:	612d6363 			; <UNDEFINED> instruction: 0x612d6363
    1264:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
    1268:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
    126c:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    1270:	396c472d 	stmdbcc	ip!, {r0, r2, r3, r5, r8, r9, sl, lr}^
    1274:	2f39546b 	svccs	0x0039546b
    1278:	2d636367 	stclcs	3, cr6, [r3, #-412]!	; 0xfffffe64
    127c:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    1280:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    1284:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    1288:	2d392d69 	ldccs	13, cr2, [r9, #-420]!	; 0xfffffe5c
    128c:	39313032 	ldmdbcc	r1!, {r1, r4, r5, ip, sp}
    1290:	2f34712d 	svccs	0x0034712d
    1294:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    1298:	72612f64 	rsbvc	r2, r1, #100, 30	; 0x190
    129c:	6f6e2d6d 	svcvs	0x006e2d6d
    12a0:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
    12a4:	2f696261 	svccs	0x00696261
    12a8:	2f6d7261 	svccs	0x006d7261
    12ac:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
    12b0:	7261682f 	rsbvc	r6, r1, #3080192	; 0x2f0000
    12b4:	696c2f64 	stmdbvs	ip!, {r2, r5, r6, r8, r9, sl, fp, sp}^
    12b8:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    12bc:	52415400 	subpl	r5, r1, #0, 8
    12c0:	5f544547 	svcpl	0x00544547
    12c4:	5f555043 	svcpl	0x00555043
    12c8:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    12cc:	31617865 	cmncc	r1, r5, ror #16
    12d0:	726f6337 	rsbvc	r6, pc, #-603979776	; 0xdc000000
    12d4:	61786574 	cmnvs	r8, r4, ror r5
    12d8:	73690037 	cmnvc	r9, #55	; 0x37
    12dc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    12e0:	70665f74 	rsbvc	r5, r6, r4, ror pc
    12e4:	6c62645f 	cfstrdvs	mvd6, [r2], #-380	; 0xfffffe84
    12e8:	6d726100 	ldfvse	f6, [r2, #-0]
    12ec:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    12f0:	77695f68 	strbvc	r5, [r9, -r8, ror #30]!
    12f4:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    12f8:	52415400 	subpl	r5, r1, #0, 8
    12fc:	5f544547 	svcpl	0x00544547
    1300:	5f555043 	svcpl	0x00555043
    1304:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1308:	326d7865 	rsbcc	r7, sp, #6619136	; 0x650000
    130c:	52410033 	subpl	r0, r1, #51	; 0x33
    1310:	51455f4d 	cmppl	r5, sp, asr #30
    1314:	52415400 	subpl	r5, r1, #0, 8
    1318:	5f544547 	svcpl	0x00544547
    131c:	5f555043 	svcpl	0x00555043
    1320:	316d7261 	cmncc	sp, r1, ror #4
    1324:	74363531 	ldrtvc	r3, [r6], #-1329	; 0xfffffacf
    1328:	00736632 	rsbseq	r6, r3, r2, lsr r6
    132c:	5f617369 	svcpl	0x00617369
    1330:	5f746962 	svcpl	0x00746962
    1334:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    1338:	41540062 	cmpmi	r4, r2, rrx
    133c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1340:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1344:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1348:	61786574 	cmnvs	r8, r4, ror r5
    134c:	6f633735 	svcvs	0x00633735
    1350:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1354:	00333561 	eorseq	r3, r3, r1, ror #10
    1358:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    135c:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1360:	4d385f48 	ldcmi	15, cr5, [r8, #-288]!	; 0xfffffee0
    1364:	5341425f 	movtpl	r4, #4703	; 0x125f
    1368:	41540045 	cmpmi	r4, r5, asr #32
    136c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1370:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1374:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1378:	00303138 	eorseq	r3, r0, r8, lsr r1
    137c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1380:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1384:	785f5550 	ldmdavc	pc, {r4, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
    1388:	656e6567 	strbvs	r6, [lr, #-1383]!	; 0xfffffa99
    138c:	52410031 	subpl	r0, r1, #49	; 0x31
    1390:	43505f4d 	cmpmi	r0, #308	; 0x134
    1394:	41415f53 	cmpmi	r1, r3, asr pc
    1398:	5f534350 	svcpl	0x00534350
    139c:	4d4d5749 	stclmi	7, cr5, [sp, #-292]	; 0xfffffedc
    13a0:	42005458 	andmi	r5, r0, #88, 8	; 0x58000000
    13a4:	5f455341 	svcpl	0x00455341
    13a8:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    13ac:	4200305f 	andmi	r3, r0, #95	; 0x5f
    13b0:	5f455341 	svcpl	0x00455341
    13b4:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    13b8:	4200325f 	andmi	r3, r0, #-268435451	; 0xf0000005
    13bc:	5f455341 	svcpl	0x00455341
    13c0:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    13c4:	4200335f 	andmi	r3, r0, #2080374785	; 0x7c000001
    13c8:	5f455341 	svcpl	0x00455341
    13cc:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    13d0:	4200345f 	andmi	r3, r0, #1593835520	; 0x5f000000
    13d4:	5f455341 	svcpl	0x00455341
    13d8:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    13dc:	4200365f 	andmi	r3, r0, #99614720	; 0x5f00000
    13e0:	5f455341 	svcpl	0x00455341
    13e4:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    13e8:	5400375f 	strpl	r3, [r0], #-1887	; 0xfffff8a1
    13ec:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    13f0:	50435f54 	subpl	r5, r3, r4, asr pc
    13f4:	73785f55 	cmnvc	r8, #340	; 0x154
    13f8:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    13fc:	61736900 	cmnvs	r3, r0, lsl #18
    1400:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1404:	6572705f 	ldrbvs	r7, [r2, #-95]!	; 0xffffffa1
    1408:	73657264 	cmnvc	r5, #100, 4	; 0x40000006
    140c:	52415400 	subpl	r5, r1, #0, 8
    1410:	5f544547 	svcpl	0x00544547
    1414:	5f555043 	svcpl	0x00555043
    1418:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    141c:	336d7865 	cmncc	sp, #6619136	; 0x650000
    1420:	41540033 	cmpmi	r4, r3, lsr r0
    1424:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1428:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    142c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1430:	6d647437 	cfstrdvs	mvd7, [r4, #-220]!	; 0xffffff24
    1434:	73690069 	cmnvc	r9, #105	; 0x69
    1438:	6f6e5f61 	svcvs	0x006e5f61
    143c:	00746962 	rsbseq	r6, r4, r2, ror #18
    1440:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1444:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1448:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    144c:	31316d72 	teqcc	r1, r2, ror sp
    1450:	7a6a3637 	bvc	1a8ed34 <__bss_end+0x1a85da0>
    1454:	69007366 	stmdbvs	r0, {r1, r2, r5, r6, r8, r9, ip, sp, lr}
    1458:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    145c:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    1460:	32767066 	rsbscc	r7, r6, #102	; 0x66
    1464:	4d524100 	ldfmie	f4, [r2, #-0]
    1468:	5343505f 	movtpl	r5, #12383	; 0x305f
    146c:	4b4e555f 	blmi	13969f0 <__bss_end+0x138da5c>
    1470:	4e574f4e 	cdpmi	15, 5, cr4, cr7, cr14, {2}
    1474:	52415400 	subpl	r5, r1, #0, 8
    1478:	5f544547 	svcpl	0x00544547
    147c:	5f555043 	svcpl	0x00555043
    1480:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    1484:	41420065 	cmpmi	r2, r5, rrx
    1488:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    148c:	5f484352 	svcpl	0x00484352
    1490:	4a455435 	bmi	115656c <__bss_end+0x114d5d8>
    1494:	6d726100 	ldfvse	f6, [r2, #-0]
    1498:	6663635f 			; <UNDEFINED> instruction: 0x6663635f
    149c:	735f6d73 	cmpvc	pc, #7360	; 0x1cc0
    14a0:	65746174 	ldrbvs	r6, [r4, #-372]!	; 0xfffffe8c
    14a4:	6d726100 	ldfvse	f6, [r2, #-0]
    14a8:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    14ac:	65743568 	ldrbvs	r3, [r4, #-1384]!	; 0xfffffa98
    14b0:	736e7500 	cmnvc	lr, #0, 10
    14b4:	5f636570 	svcpl	0x00636570
    14b8:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    14bc:	0073676e 	rsbseq	r6, r3, lr, ror #14
    14c0:	5f617369 	svcpl	0x00617369
    14c4:	5f746962 	svcpl	0x00746962
    14c8:	00636573 	rsbeq	r6, r3, r3, ror r5
    14cc:	6c635f5f 	stclvs	15, cr5, [r3], #-380	; 0xfffffe84
    14d0:	61745f7a 	cmnvs	r4, sl, ror pc
    14d4:	52410062 	subpl	r0, r1, #98	; 0x62
    14d8:	43565f4d 	cmpmi	r6, #308	; 0x134
    14dc:	6d726100 	ldfvse	f6, [r2, #-0]
    14e0:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    14e4:	73785f68 	cmnvc	r8, #104, 30	; 0x1a0
    14e8:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    14ec:	4d524100 	ldfmie	f4, [r2, #-0]
    14f0:	00454c5f 	subeq	r4, r5, pc, asr ip
    14f4:	5f4d5241 	svcpl	0x004d5241
    14f8:	41005356 	tstmi	r0, r6, asr r3
    14fc:	475f4d52 			; <UNDEFINED> instruction: 0x475f4d52
    1500:	72610045 	rsbvc	r0, r1, #69	; 0x45
    1504:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    1508:	735f656e 	cmpvc	pc, #461373440	; 0x1b800000
    150c:	6e6f7274 	mcrvs	2, 3, r7, cr15, cr4, {3}
    1510:	6d726167 	ldfvse	f6, [r2, #-412]!	; 0xfffffe64
    1514:	6d6f6300 	stclvs	3, cr6, [pc, #-0]	; 151c <shift+0x151c>
    1518:	78656c70 	stmdavc	r5!, {r4, r5, r6, sl, fp, sp, lr}^
    151c:	6f6c6620 	svcvs	0x006c6620
    1520:	54007461 	strpl	r7, [r0], #-1121	; 0xfffffb9f
    1524:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1528:	50435f54 	subpl	r5, r3, r4, asr pc
    152c:	6f635f55 	svcvs	0x00635f55
    1530:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1534:	00353161 	eorseq	r3, r5, r1, ror #2
    1538:	47524154 			; <UNDEFINED> instruction: 0x47524154
    153c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1540:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    1544:	36323761 	ldrtcc	r3, [r2], -r1, ror #14
    1548:	54006574 	strpl	r6, [r0], #-1396	; 0xfffffa8c
    154c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1550:	50435f54 	subpl	r5, r3, r4, asr pc
    1554:	6f635f55 	svcvs	0x00635f55
    1558:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    155c:	00373161 	eorseq	r3, r7, r1, ror #2
    1560:	5f4d5241 	svcpl	0x004d5241
    1564:	54005447 	strpl	r5, [r0], #-1095	; 0xfffffbb9
    1568:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    156c:	50435f54 	subpl	r5, r3, r4, asr pc
    1570:	656e5f55 	strbvs	r5, [lr, #-3925]!	; 0xfffff0ab
    1574:	7265766f 	rsbvc	r7, r5, #116391936	; 0x6f00000
    1578:	316e6573 	smccc	58963	; 0xe653
    157c:	2f2e2e00 	svccs	0x002e2e00
    1580:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1584:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1588:	2f2e2e2f 	svccs	0x002e2e2f
    158c:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 14dc <shift+0x14dc>
    1590:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1594:	696c2f63 	stmdbvs	ip!, {r0, r1, r5, r6, r8, r9, sl, fp, sp}^
    1598:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    159c:	00632e32 	rsbeq	r2, r3, r2, lsr lr
    15a0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    15a4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    15a8:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    15ac:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    15b0:	66347278 			; <UNDEFINED> instruction: 0x66347278
    15b4:	53414200 	movtpl	r4, #4608	; 0x1200
    15b8:	52415f45 	subpl	r5, r1, #276	; 0x114
    15bc:	375f4843 	ldrbcc	r4, [pc, -r3, asr #16]
    15c0:	54004d45 	strpl	r4, [r0], #-3397	; 0xfffff2bb
    15c4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    15c8:	50435f54 	subpl	r5, r3, r4, asr pc
    15cc:	6f635f55 	svcvs	0x00635f55
    15d0:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    15d4:	00323161 	eorseq	r3, r2, r1, ror #2
    15d8:	68736168 	ldmdavs	r3!, {r3, r5, r6, r8, sp, lr}^
    15dc:	5f6c6176 	svcpl	0x006c6176
    15e0:	41420074 	hvcmi	8196	; 0x2004
    15e4:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    15e8:	5f484352 	svcpl	0x00484352
    15ec:	005a4b36 	subseq	r4, sl, r6, lsr fp
    15f0:	5f617369 	svcpl	0x00617369
    15f4:	73746962 	cmnvc	r4, #1605632	; 0x188000
    15f8:	6d726100 	ldfvse	f6, [r2, #-0]
    15fc:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1600:	72615f68 	rsbvc	r5, r1, #104, 30	; 0x1a0
    1604:	77685f6d 	strbvc	r5, [r8, -sp, ror #30]!
    1608:	00766964 	rsbseq	r6, r6, r4, ror #18
    160c:	5f6d7261 	svcpl	0x006d7261
    1610:	5f757066 	svcpl	0x00757066
    1614:	63736564 	cmnvs	r3, #100, 10	; 0x19000000
    1618:	61736900 	cmnvs	r3, r0, lsl #18
    161c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1620:	3170665f 	cmncc	r0, pc, asr r6
    1624:	4e470036 	mcrmi	0, 2, r0, cr7, cr6, {1}
    1628:	31432055 	qdaddcc	r2, r5, r3
    162c:	2e392037 	mrccs	0, 1, r2, cr9, cr7, {1}
    1630:	20312e32 	eorscs	r2, r1, r2, lsr lr
    1634:	39313032 	ldmdbcc	r1!, {r1, r4, r5, ip, sp}
    1638:	35323031 	ldrcc	r3, [r2, #-49]!	; 0xffffffcf
    163c:	65722820 	ldrbvs	r2, [r2, #-2080]!	; 0xfffff7e0
    1640:	7361656c 	cmnvc	r1, #108, 10	; 0x1b000000
    1644:	5b202965 	blpl	80bbe0 <__bss_end+0x802c4c>
    1648:	2f4d5241 	svccs	0x004d5241
    164c:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    1650:	72622d39 	rsbvc	r2, r2, #3648	; 0xe40
    1654:	68636e61 	stmdavs	r3!, {r0, r5, r6, r9, sl, fp, sp, lr}^
    1658:	76657220 	strbtvc	r7, [r5], -r0, lsr #4
    165c:	6f697369 	svcvs	0x00697369
    1660:	3732206e 	ldrcc	r2, [r2, -lr, rrx]!
    1664:	39393537 	ldmdbcc	r9!, {r0, r1, r2, r4, r5, r8, sl, ip, sp}
    1668:	6d2d205d 	stcvs	0, cr2, [sp, #-372]!	; 0xfffffe8c
    166c:	206d7261 	rsbcs	r7, sp, r1, ror #4
    1670:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
    1674:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
    1678:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
    167c:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    1680:	616d2d20 	cmnvs	sp, r0, lsr #26
    1684:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
    1688:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    168c:	2b657435 	blcs	195e768 <__bss_end+0x19557d4>
    1690:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    1694:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    1698:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    169c:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    16a0:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    16a4:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    16a8:	7562662d 	strbvc	r6, [r2, #-1581]!	; 0xfffff9d3
    16ac:	69646c69 	stmdbvs	r4!, {r0, r3, r5, r6, sl, fp, sp, lr}^
    16b0:	6c2d676e 	stcvs	7, cr6, [sp], #-440	; 0xfffffe48
    16b4:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    16b8:	662d2063 	strtvs	r2, [sp], -r3, rrx
    16bc:	732d6f6e 			; <UNDEFINED> instruction: 0x732d6f6e
    16c0:	6b636174 	blvs	18d9c98 <__bss_end+0x18d0d04>
    16c4:	6f72702d 	svcvs	0x0072702d
    16c8:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
    16cc:	2d20726f 	sfmcs	f7, 4, [r0, #-444]!	; 0xfffffe44
    16d0:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 1540 <shift+0x1540>
    16d4:	696c6e69 	stmdbvs	ip!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
    16d8:	2d20656e 	cfstr32cs	mvfx6, [r0, #-440]!	; 0xfffffe48
    16dc:	73697666 	cmnvc	r9, #106954752	; 0x6600000
    16e0:	6c696269 	sfmvs	f6, 2, [r9], #-420	; 0xfffffe5c
    16e4:	3d797469 	cfldrdcc	mvd7, [r9, #-420]!	; 0xfffffe5c
    16e8:	64646968 	strbtvs	r6, [r4], #-2408	; 0xfffff698
    16ec:	41006e65 	tstmi	r0, r5, ror #28
    16f0:	485f4d52 	ldmdami	pc, {r1, r4, r6, r8, sl, fp, lr}^	; <UNPREDICTABLE>
    16f4:	73690049 	cmnvc	r9, #73	; 0x49
    16f8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    16fc:	64615f74 	strbtvs	r5, [r1], #-3956	; 0xfffff08c
    1700:	54007669 	strpl	r7, [r0], #-1641	; 0xfffff997
    1704:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1708:	50435f54 	subpl	r5, r3, r4, asr pc
    170c:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1710:	3331316d 	teqcc	r1, #1073741851	; 0x4000001b
    1714:	00736a36 	rsbseq	r6, r3, r6, lsr sl
    1718:	47524154 			; <UNDEFINED> instruction: 0x47524154
    171c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1720:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1724:	00386d72 	eorseq	r6, r8, r2, ror sp
    1728:	47524154 			; <UNDEFINED> instruction: 0x47524154
    172c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1730:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1734:	00396d72 	eorseq	r6, r9, r2, ror sp
    1738:	47524154 			; <UNDEFINED> instruction: 0x47524154
    173c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1740:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    1744:	36323661 	ldrtcc	r3, [r2], -r1, ror #12
    1748:	6e6f6c00 	cdpvs	12, 6, cr6, cr15, cr0, {0}
    174c:	6f6c2067 	svcvs	0x006c2067
    1750:	7520676e 	strvc	r6, [r0, #-1902]!	; 0xfffff892
    1754:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
    1758:	2064656e 	rsbcs	r6, r4, lr, ror #10
    175c:	00746e69 	rsbseq	r6, r4, r9, ror #28
    1760:	5f6d7261 	svcpl	0x006d7261
    1764:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1768:	736d635f 	cmnvc	sp, #2080374785	; 0x7c000001
    176c:	41540065 	cmpmi	r4, r5, rrx
    1770:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1774:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1778:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    177c:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1780:	41540034 	cmpmi	r4, r4, lsr r0
    1784:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1788:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    178c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1790:	00653031 	rsbeq	r3, r5, r1, lsr r0
    1794:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1798:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    179c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    17a0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    17a4:	00376d78 	eorseq	r6, r7, r8, ror sp
    17a8:	5f6d7261 	svcpl	0x006d7261
    17ac:	646e6f63 	strbtvs	r6, [lr], #-3939	; 0xfffff09d
    17b0:	646f635f 	strbtvs	r6, [pc], #-863	; 17b8 <shift+0x17b8>
    17b4:	52410065 	subpl	r0, r1, #101	; 0x65
    17b8:	43505f4d 	cmpmi	r0, #308	; 0x134
    17bc:	41415f53 	cmpmi	r1, r3, asr pc
    17c0:	00534350 	subseq	r4, r3, r0, asr r3
    17c4:	5f617369 	svcpl	0x00617369
    17c8:	5f746962 	svcpl	0x00746962
    17cc:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    17d0:	00325f38 	eorseq	r5, r2, r8, lsr pc
    17d4:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    17d8:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    17dc:	4d335f48 	ldcmi	15, cr5, [r3, #-288]!	; 0xfffffee0
    17e0:	52415400 	subpl	r5, r1, #0, 8
    17e4:	5f544547 	svcpl	0x00544547
    17e8:	5f555043 	svcpl	0x00555043
    17ec:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    17f0:	00743031 	rsbseq	r3, r4, r1, lsr r0
    17f4:	5f6d7261 	svcpl	0x006d7261
    17f8:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    17fc:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    1800:	3274786d 	rsbscc	r7, r4, #7143424	; 0x6d0000
    1804:	61736900 	cmnvs	r3, r0, lsl #18
    1808:	6d756e5f 	ldclvs	14, cr6, [r5, #-380]!	; 0xfffffe84
    180c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1810:	41540073 	cmpmi	r4, r3, ror r0
    1814:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1818:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    181c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1820:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1824:	756c7030 	strbvc	r7, [ip, #-48]!	; 0xffffffd0
    1828:	616d7373 	smcvs	55091	; 0xd733
    182c:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    1830:	7069746c 	rsbvc	r7, r9, ip, ror #8
    1834:	5400796c 	strpl	r7, [r0], #-2412	; 0xfffff694
    1838:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    183c:	50435f54 	subpl	r5, r3, r4, asr pc
    1840:	78655f55 	stmdavc	r5!, {r0, r2, r4, r6, r8, r9, sl, fp, ip, lr}^
    1844:	736f6e79 	cmnvc	pc, #1936	; 0x790
    1848:	5400316d 	strpl	r3, [r0], #-365	; 0xfffffe93
    184c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1850:	50435f54 	subpl	r5, r3, r4, asr pc
    1854:	6f635f55 	svcvs	0x00635f55
    1858:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    185c:	00323572 	eorseq	r3, r2, r2, ror r5
    1860:	5f617369 	svcpl	0x00617369
    1864:	5f746962 	svcpl	0x00746962
    1868:	76696474 			; <UNDEFINED> instruction: 0x76696474
    186c:	65727000 	ldrbvs	r7, [r2, #-0]!
    1870:	5f726566 	svcpl	0x00726566
    1874:	6e6f656e 	cdpvs	5, 6, cr6, cr15, cr14, {3}
    1878:	726f665f 	rsbvc	r6, pc, #99614720	; 0x5f00000
    187c:	6234365f 	eorsvs	r3, r4, #99614720	; 0x5f00000
    1880:	00737469 	rsbseq	r7, r3, r9, ror #8
    1884:	5f617369 	svcpl	0x00617369
    1888:	5f746962 	svcpl	0x00746962
    188c:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    1890:	006c6d66 	rsbeq	r6, ip, r6, ror #26
    1894:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1898:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    189c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    18a0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    18a4:	32336178 	eorscc	r6, r3, #120, 2
    18a8:	52415400 	subpl	r5, r1, #0, 8
    18ac:	5f544547 	svcpl	0x00544547
    18b0:	5f555043 	svcpl	0x00555043
    18b4:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    18b8:	33617865 	cmncc	r1, #6619136	; 0x650000
    18bc:	73690035 	cmnvc	r9, #53	; 0x35
    18c0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    18c4:	70665f74 	rsbvc	r5, r6, r4, ror pc
    18c8:	6f633631 	svcvs	0x00633631
    18cc:	7500766e 	strvc	r7, [r0, #-1646]	; 0xfffff992
    18d0:	6570736e 	ldrbvs	r7, [r0, #-878]!	; 0xfffffc92
    18d4:	735f7663 	cmpvc	pc, #103809024	; 0x6300000
    18d8:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
    18dc:	54007367 	strpl	r7, [r0], #-871	; 0xfffffc99
    18e0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    18e4:	50435f54 	subpl	r5, r3, r4, asr pc
    18e8:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    18ec:	3531316d 	ldrcc	r3, [r1, #-365]!	; 0xfffffe93
    18f0:	73327436 	teqvc	r2, #905969664	; 0x36000000
    18f4:	52415400 	subpl	r5, r1, #0, 8
    18f8:	5f544547 	svcpl	0x00544547
    18fc:	5f555043 	svcpl	0x00555043
    1900:	30366166 	eorscc	r6, r6, r6, ror #2
    1904:	00657436 	rsbeq	r7, r5, r6, lsr r4
    1908:	47524154 			; <UNDEFINED> instruction: 0x47524154
    190c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1910:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1914:	32396d72 	eorscc	r6, r9, #7296	; 0x1c80
    1918:	736a6536 	cmnvc	sl, #226492416	; 0xd800000
    191c:	53414200 	movtpl	r4, #4608	; 0x1200
    1920:	52415f45 	subpl	r5, r1, #276	; 0x114
    1924:	345f4843 	ldrbcc	r4, [pc], #-2115	; 192c <shift+0x192c>
    1928:	73690054 	cmnvc	r9, #84	; 0x54
    192c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1930:	72635f74 	rsbvc	r5, r3, #116, 30	; 0x1d0
    1934:	6f747079 	svcvs	0x00747079
    1938:	6d726100 	ldfvse	f6, [r2, #-0]
    193c:	6765725f 			; <UNDEFINED> instruction: 0x6765725f
    1940:	6e695f73 	mcrvs	15, 3, r5, cr9, cr3, {3}
    1944:	7165735f 	cmnvc	r5, pc, asr r3
    1948:	636e6575 	cmnvs	lr, #490733568	; 0x1d400000
    194c:	73690065 	cmnvc	r9, #101	; 0x65
    1950:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1954:	62735f74 	rsbsvs	r5, r3, #116, 30	; 0x1d0
    1958:	53414200 	movtpl	r4, #4608	; 0x1200
    195c:	52415f45 	subpl	r5, r1, #276	; 0x114
    1960:	355f4843 	ldrbcc	r4, [pc, #-2115]	; 1125 <shift+0x1125>
    1964:	69004554 	stmdbvs	r0, {r2, r4, r6, r8, sl, lr}
    1968:	665f6173 			; <UNDEFINED> instruction: 0x665f6173
    196c:	75746165 	ldrbvc	r6, [r4, #-357]!	; 0xfffffe9b
    1970:	69006572 	stmdbvs	r0, {r1, r4, r5, r6, r8, sl, sp, lr}
    1974:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1978:	735f7469 	cmpvc	pc, #1761607680	; 0x69000000
    197c:	6c6c616d 	stfvse	f6, [ip], #-436	; 0xfffffe4c
    1980:	006c756d 	rsbeq	r7, ip, sp, ror #10
    1984:	5f6d7261 	svcpl	0x006d7261
    1988:	676e616c 	strbvs	r6, [lr, -ip, ror #2]!
    198c:	74756f5f 	ldrbtvc	r6, [r5], #-3935	; 0xfffff0a1
    1990:	5f747570 	svcpl	0x00747570
    1994:	656a626f 	strbvs	r6, [sl, #-623]!	; 0xfffffd91
    1998:	615f7463 	cmpvs	pc, r3, ror #8
    199c:	69727474 	ldmdbvs	r2!, {r2, r4, r5, r6, sl, ip, sp, lr}^
    19a0:	65747562 	ldrbvs	r7, [r4, #-1378]!	; 0xfffffa9e
    19a4:	6f685f73 	svcvs	0x00685f73
    19a8:	69006b6f 	stmdbvs	r0, {r0, r1, r2, r3, r5, r6, r8, r9, fp, sp, lr}
    19ac:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    19b0:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    19b4:	33645f70 	cmncc	r4, #112, 30	; 0x1c0
    19b8:	52410032 	subpl	r0, r1, #50	; 0x32
    19bc:	454e5f4d 	strbmi	r5, [lr, #-3917]	; 0xfffff0b3
    19c0:	61736900 	cmnvs	r3, r0, lsl #18
    19c4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    19c8:	3865625f 	stmdacc	r5!, {r0, r1, r2, r3, r4, r6, r9, sp, lr}^
    19cc:	52415400 	subpl	r5, r1, #0, 8
    19d0:	5f544547 	svcpl	0x00544547
    19d4:	5f555043 	svcpl	0x00555043
    19d8:	316d7261 	cmncc	sp, r1, ror #4
    19dc:	6a363731 	bvs	d8f6a8 <__bss_end+0xd86714>
    19e0:	7000737a 	andvc	r7, r0, sl, ror r3
    19e4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    19e8:	726f7373 	rsbvc	r7, pc, #-872415231	; 0xcc000001
    19ec:	7079745f 	rsbsvc	r7, r9, pc, asr r4
    19f0:	6c610065 	stclvs	0, cr0, [r1], #-404	; 0xfffffe6c
    19f4:	70665f6c 	rsbvc	r5, r6, ip, ror #30
    19f8:	61007375 	tstvs	r0, r5, ror r3
    19fc:	705f6d72 	subsvc	r6, pc, r2, ror sp	; <UNPREDICTABLE>
    1a00:	42007363 	andmi	r7, r0, #-1946157055	; 0x8c000001
    1a04:	5f455341 	svcpl	0x00455341
    1a08:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1a0c:	0054355f 	subseq	r3, r4, pc, asr r5
    1a10:	5f6d7261 	svcpl	0x006d7261
    1a14:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1a18:	54007434 	strpl	r7, [r0], #-1076	; 0xfffffbcc
    1a1c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1a20:	50435f54 	subpl	r5, r3, r4, asr pc
    1a24:	6f635f55 	svcvs	0x00635f55
    1a28:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1a2c:	63363761 	teqvs	r6, #25427968	; 0x1840000
    1a30:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1a34:	35356178 	ldrcc	r6, [r5, #-376]!	; 0xfffffe88
    1a38:	6d726100 	ldfvse	f6, [r2, #-0]
    1a3c:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    1a40:	62775f65 	rsbsvs	r5, r7, #404	; 0x194
    1a44:	68006675 	stmdavs	r0, {r0, r2, r4, r5, r6, r9, sl, sp, lr}
    1a48:	5f626174 	svcpl	0x00626174
    1a4c:	68736168 	ldmdavs	r3!, {r3, r5, r6, r8, sp, lr}^
    1a50:	61736900 	cmnvs	r3, r0, lsl #18
    1a54:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1a58:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    1a5c:	6e5f6b72 	vmovvs.s8	r6, d15[3]
    1a60:	6f765f6f 	svcvs	0x00765f6f
    1a64:	6974616c 	ldmdbvs	r4!, {r2, r3, r5, r6, r8, sp, lr}^
    1a68:	635f656c 	cmpvs	pc, #108, 10	; 0x1b000000
    1a6c:	41540065 	cmpmi	r4, r5, rrx
    1a70:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1a74:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1a78:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1a7c:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1a80:	41540030 	cmpmi	r4, r0, lsr r0
    1a84:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1a88:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1a8c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1a90:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1a94:	41540031 	cmpmi	r4, r1, lsr r0
    1a98:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1a9c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1aa0:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1aa4:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1aa8:	73690033 	cmnvc	r9, #51	; 0x33
    1aac:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1ab0:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1ab4:	5f38766d 	svcpl	0x0038766d
    1ab8:	72610031 	rsbvc	r0, r1, #49	; 0x31
    1abc:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1ac0:	6e5f6863 	cdpvs	8, 5, cr6, cr15, cr3, {3}
    1ac4:	00656d61 	rsbeq	r6, r5, r1, ror #26
    1ac8:	5f617369 	svcpl	0x00617369
    1acc:	5f746962 	svcpl	0x00746962
    1ad0:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1ad4:	00335f38 	eorseq	r5, r3, r8, lsr pc
    1ad8:	5f617369 	svcpl	0x00617369
    1adc:	5f746962 	svcpl	0x00746962
    1ae0:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1ae4:	00345f38 	eorseq	r5, r4, r8, lsr pc
    1ae8:	5f617369 	svcpl	0x00617369
    1aec:	5f746962 	svcpl	0x00746962
    1af0:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1af4:	00355f38 	eorseq	r5, r5, r8, lsr pc
    1af8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1afc:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1b00:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1b04:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1b08:	33356178 	teqcc	r5, #120, 2
    1b0c:	52415400 	subpl	r5, r1, #0, 8
    1b10:	5f544547 	svcpl	0x00544547
    1b14:	5f555043 	svcpl	0x00555043
    1b18:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1b1c:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    1b20:	41540035 	cmpmi	r4, r5, lsr r0
    1b24:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1b28:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1b2c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1b30:	61786574 	cmnvs	r8, r4, ror r5
    1b34:	54003735 	strpl	r3, [r0], #-1845	; 0xfffff8cb
    1b38:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1b3c:	50435f54 	subpl	r5, r3, r4, asr pc
    1b40:	706d5f55 	rsbvc	r5, sp, r5, asr pc
    1b44:	65726f63 	ldrbvs	r6, [r2, #-3939]!	; 0xfffff09d
    1b48:	52415400 	subpl	r5, r1, #0, 8
    1b4c:	5f544547 	svcpl	0x00544547
    1b50:	5f555043 	svcpl	0x00555043
    1b54:	5f6d7261 	svcpl	0x006d7261
    1b58:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    1b5c:	6d726100 	ldfvse	f6, [r2, #-0]
    1b60:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1b64:	6f6e5f68 	svcvs	0x006e5f68
    1b68:	54006d74 	strpl	r6, [r0], #-3444	; 0xfffff28c
    1b6c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1b70:	50435f54 	subpl	r5, r3, r4, asr pc
    1b74:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1b78:	3230316d 	eorscc	r3, r0, #1073741851	; 0x4000001b
    1b7c:	736a6536 	cmnvc	sl, #226492416	; 0xd800000
    1b80:	53414200 	movtpl	r4, #4608	; 0x1200
    1b84:	52415f45 	subpl	r5, r1, #276	; 0x114
    1b88:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    1b8c:	4142004a 	cmpmi	r2, sl, asr #32
    1b90:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1b94:	5f484352 	svcpl	0x00484352
    1b98:	42004b36 	andmi	r4, r0, #55296	; 0xd800
    1b9c:	5f455341 	svcpl	0x00455341
    1ba0:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1ba4:	004d365f 	subeq	r3, sp, pc, asr r6
    1ba8:	5f617369 	svcpl	0x00617369
    1bac:	5f746962 	svcpl	0x00746962
    1bb0:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    1bb4:	54007478 	strpl	r7, [r0], #-1144	; 0xfffffb88
    1bb8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1bbc:	50435f54 	subpl	r5, r3, r4, asr pc
    1bc0:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1bc4:	3331316d 	teqcc	r1, #1073741851	; 0x4000001b
    1bc8:	73666a36 	cmnvc	r6, #221184	; 0x36000
    1bcc:	4d524100 	ldfmie	f4, [r2, #-0]
    1bd0:	00534c5f 	subseq	r4, r3, pc, asr ip
    1bd4:	5f4d5241 	svcpl	0x004d5241
    1bd8:	4200544c 	andmi	r5, r0, #76, 8	; 0x4c000000
    1bdc:	5f455341 	svcpl	0x00455341
    1be0:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1be4:	005a365f 	subseq	r3, sl, pc, asr r6
    1be8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1bec:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1bf0:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1bf4:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1bf8:	35376178 	ldrcc	r6, [r7, #-376]!	; 0xfffffe88
    1bfc:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1c00:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    1c04:	52410035 	subpl	r0, r1, #53	; 0x35
    1c08:	43505f4d 	cmpmi	r0, #308	; 0x134
    1c0c:	41415f53 	cmpmi	r1, r3, asr pc
    1c10:	5f534350 	svcpl	0x00534350
    1c14:	00504656 	subseq	r4, r0, r6, asr r6
    1c18:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1c1c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1c20:	695f5550 	ldmdbvs	pc, {r4, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
    1c24:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    1c28:	69003274 	stmdbvs	r0, {r2, r4, r5, r6, r9, ip, sp}
    1c2c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1c30:	6e5f7469 	cdpvs	4, 5, cr7, cr15, cr9, {3}
    1c34:	006e6f65 	rsbeq	r6, lr, r5, ror #30
    1c38:	5f6d7261 	svcpl	0x006d7261
    1c3c:	5f757066 	svcpl	0x00757066
    1c40:	72747461 	rsbsvc	r7, r4, #1627389952	; 0x61000000
    1c44:	61736900 	cmnvs	r3, r0, lsl #18
    1c48:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1c4c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1c50:	6d653776 	stclvs	7, cr3, [r5, #-472]!	; 0xfffffe28
    1c54:	52415400 	subpl	r5, r1, #0, 8
    1c58:	5f544547 	svcpl	0x00544547
    1c5c:	5f555043 	svcpl	0x00555043
    1c60:	32366166 	eorscc	r6, r6, #-2147483623	; 0x80000019
    1c64:	00657436 	rsbeq	r7, r5, r6, lsr r4
    1c68:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1c6c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1c70:	6d5f5550 	cfldr64vs	mvdx5, [pc, #-320]	; 1b38 <shift+0x1b38>
    1c74:	65767261 	ldrbvs	r7, [r6, #-609]!	; 0xfffffd9f
    1c78:	705f6c6c 	subsvc	r6, pc, ip, ror #24
    1c7c:	6800346a 	stmdavs	r0, {r1, r3, r5, r6, sl, ip, sp}
    1c80:	5f626174 	svcpl	0x00626174
    1c84:	68736168 	ldmdavs	r3!, {r3, r5, r6, r8, sp, lr}^
    1c88:	696f705f 	stmdbvs	pc!, {r0, r1, r2, r3, r4, r6, ip, sp, lr}^	; <UNPREDICTABLE>
    1c8c:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    1c90:	6d726100 	ldfvse	f6, [r2, #-0]
    1c94:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    1c98:	6f635f65 	svcvs	0x00635f65
    1c9c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1ca0:	0039615f 	eorseq	r6, r9, pc, asr r1
    1ca4:	5f617369 	svcpl	0x00617369
    1ca8:	5f746962 	svcpl	0x00746962
    1cac:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    1cb0:	00327478 	eorseq	r7, r2, r8, ror r4
    1cb4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1cb8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1cbc:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1cc0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1cc4:	32376178 	eorscc	r6, r7, #120, 2
    1cc8:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1ccc:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    1cd0:	73690033 	cmnvc	r9, #51	; 0x33
    1cd4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1cd8:	68745f74 	ldmdavs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1cdc:	32626d75 	rsbcc	r6, r2, #7488	; 0x1d40
    1ce0:	53414200 	movtpl	r4, #4608	; 0x1200
    1ce4:	52415f45 	subpl	r5, r1, #276	; 0x114
    1ce8:	375f4843 	ldrbcc	r4, [pc, -r3, asr #16]
    1cec:	73690041 	cmnvc	r9, #65	; 0x41
    1cf0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1cf4:	6f645f74 	svcvs	0x00645f74
    1cf8:	6f727074 	svcvs	0x00727074
    1cfc:	72610064 	rsbvc	r0, r1, #100	; 0x64
    1d00:	70665f6d 	rsbvc	r5, r6, sp, ror #30
    1d04:	745f3631 	ldrbvc	r3, [pc], #-1585	; 1d0c <shift+0x1d0c>
    1d08:	5f657079 	svcpl	0x00657079
    1d0c:	65646f6e 	strbvs	r6, [r4, #-3950]!	; 0xfffff092
    1d10:	4d524100 	ldfmie	f4, [r2, #-0]
    1d14:	00494d5f 	subeq	r4, r9, pc, asr sp
    1d18:	5f6d7261 	svcpl	0x006d7261
    1d1c:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1d20:	61006b36 	tstvs	r0, r6, lsr fp
    1d24:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1d28:	36686372 			; <UNDEFINED> instruction: 0x36686372
    1d2c:	4142006d 	cmpmi	r2, sp, rrx
    1d30:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1d34:	5f484352 	svcpl	0x00484352
    1d38:	5f005237 	svcpl	0x00005237
    1d3c:	706f705f 	rsbvc	r7, pc, pc, asr r0	; <UNPREDICTABLE>
    1d40:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
    1d44:	61745f74 	cmnvs	r4, r4, ror pc
    1d48:	73690062 	cmnvc	r9, #98	; 0x62
    1d4c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1d50:	6d635f74 	stclvs	15, cr5, [r3, #-464]!	; 0xfffffe30
    1d54:	54006573 	strpl	r6, [r0], #-1395	; 0xfffffa8d
    1d58:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1d5c:	50435f54 	subpl	r5, r3, r4, asr pc
    1d60:	6f635f55 	svcvs	0x00635f55
    1d64:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1d68:	00333761 	eorseq	r3, r3, r1, ror #14
    1d6c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1d70:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1d74:	675f5550 			; <UNDEFINED> instruction: 0x675f5550
    1d78:	72656e65 	rsbvc	r6, r5, #1616	; 0x650
    1d7c:	37766369 	ldrbcc	r6, [r6, -r9, ror #6]!
    1d80:	41540061 	cmpmi	r4, r1, rrx
    1d84:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1d88:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1d8c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1d90:	61786574 	cmnvs	r8, r4, ror r5
    1d94:	61003637 	tstvs	r0, r7, lsr r6
    1d98:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1d9c:	5f686372 	svcpl	0x00686372
    1da0:	765f6f6e 	ldrbvc	r6, [pc], -lr, ror #30
    1da4:	74616c6f 	strbtvc	r6, [r1], #-3183	; 0xfffff391
    1da8:	5f656c69 	svcpl	0x00656c69
    1dac:	42006563 	andmi	r6, r0, #415236096	; 0x18c00000
    1db0:	5f455341 	svcpl	0x00455341
    1db4:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1db8:	0041385f 	subeq	r3, r1, pc, asr r8
    1dbc:	5f617369 	svcpl	0x00617369
    1dc0:	5f746962 	svcpl	0x00746962
    1dc4:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1dc8:	42007435 	andmi	r7, r0, #889192448	; 0x35000000
    1dcc:	5f455341 	svcpl	0x00455341
    1dd0:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1dd4:	0052385f 	subseq	r3, r2, pc, asr r8
    1dd8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1ddc:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1de0:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1de4:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1de8:	33376178 	teqcc	r7, #120, 2
    1dec:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1df0:	33617865 	cmncc	r1, #6619136	; 0x650000
    1df4:	52410035 	subpl	r0, r1, #53	; 0x35
    1df8:	564e5f4d 	strbpl	r5, [lr], -sp, asr #30
    1dfc:	6d726100 	ldfvse	f6, [r2, #-0]
    1e00:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1e04:	61003468 	tstvs	r0, r8, ror #8
    1e08:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1e0c:	36686372 			; <UNDEFINED> instruction: 0x36686372
    1e10:	6d726100 	ldfvse	f6, [r2, #-0]
    1e14:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1e18:	61003768 	tstvs	r0, r8, ror #14
    1e1c:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1e20:	38686372 	stmdacc	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    1e24:	6e6f6c00 	cdpvs	12, 6, cr6, cr15, cr0, {0}
    1e28:	6f642067 	svcvs	0x00642067
    1e2c:	656c6275 	strbvs	r6, [ip, #-629]!	; 0xfffffd8b
    1e30:	6d726100 	ldfvse	f6, [r2, #-0]
    1e34:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    1e38:	73785f65 	cmnvc	r8, #404	; 0x194
    1e3c:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    1e40:	6b616d00 	blvs	185d248 <__bss_end+0x18542b4>
    1e44:	5f676e69 	svcpl	0x00676e69
    1e48:	736e6f63 	cmnvc	lr, #396	; 0x18c
    1e4c:	61745f74 	cmnvs	r4, r4, ror pc
    1e50:	00656c62 	rsbeq	r6, r5, r2, ror #24
    1e54:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    1e58:	61635f62 	cmnvs	r3, r2, ror #30
    1e5c:	765f6c6c 	ldrbvc	r6, [pc], -ip, ror #24
    1e60:	6c5f6169 	ldfvse	f6, [pc], {105}	; 0x69
    1e64:	6c656261 	sfmvs	f6, 2, [r5], #-388	; 0xfffffe7c
    1e68:	61736900 	cmnvs	r3, r0, lsl #18
    1e6c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1e70:	7670665f 			; <UNDEFINED> instruction: 0x7670665f
    1e74:	73690035 	cmnvc	r9, #53	; 0x35
    1e78:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1e7c:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1e80:	6b36766d 	blvs	d9f83c <__bss_end+0xd968a8>
    1e84:	52415400 	subpl	r5, r1, #0, 8
    1e88:	5f544547 	svcpl	0x00544547
    1e8c:	5f555043 	svcpl	0x00555043
    1e90:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1e94:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    1e98:	52415400 	subpl	r5, r1, #0, 8
    1e9c:	5f544547 	svcpl	0x00544547
    1ea0:	5f555043 	svcpl	0x00555043
    1ea4:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1ea8:	38617865 	stmdacc	r1!, {r0, r2, r5, r6, fp, ip, sp, lr}^
    1eac:	52415400 	subpl	r5, r1, #0, 8
    1eb0:	5f544547 	svcpl	0x00544547
    1eb4:	5f555043 	svcpl	0x00555043
    1eb8:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1ebc:	39617865 	stmdbcc	r1!, {r0, r2, r5, r6, fp, ip, sp, lr}^
    1ec0:	4d524100 	ldfmie	f4, [r2, #-0]
    1ec4:	5343505f 	movtpl	r5, #12383	; 0x305f
    1ec8:	4350415f 	cmpmi	r0, #-1073741801	; 0xc0000017
    1ecc:	52410053 	subpl	r0, r1, #83	; 0x53
    1ed0:	43505f4d 	cmpmi	r0, #308	; 0x134
    1ed4:	54415f53 	strbpl	r5, [r1], #-3923	; 0xfffff0ad
    1ed8:	00534350 	subseq	r4, r3, r0, asr r3
    1edc:	706d6f63 	rsbvc	r6, sp, r3, ror #30
    1ee0:	2078656c 	rsbscs	r6, r8, ip, ror #10
    1ee4:	62756f64 	rsbsvs	r6, r5, #100, 30	; 0x190
    1ee8:	5400656c 	strpl	r6, [r0], #-1388	; 0xfffffa94
    1eec:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1ef0:	50435f54 	subpl	r5, r3, r4, asr pc
    1ef4:	6f635f55 	svcvs	0x00635f55
    1ef8:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1efc:	63333761 	teqvs	r3, #25427968	; 0x1840000
    1f00:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1f04:	33356178 	teqcc	r5, #120, 2
    1f08:	52415400 	subpl	r5, r1, #0, 8
    1f0c:	5f544547 	svcpl	0x00544547
    1f10:	5f555043 	svcpl	0x00555043
    1f14:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1f18:	306d7865 	rsbcc	r7, sp, r5, ror #16
    1f1c:	73756c70 	cmnvc	r5, #112, 24	; 0x7000
    1f20:	6d726100 	ldfvse	f6, [r2, #-0]
    1f24:	0063635f 	rsbeq	r6, r3, pc, asr r3
    1f28:	5f617369 	svcpl	0x00617369
    1f2c:	5f746962 	svcpl	0x00746962
    1f30:	61637378 	smcvs	14136	; 0x3738
    1f34:	5f00656c 	svcpl	0x0000656c
    1f38:	746e6f64 	strbtvc	r6, [lr], #-3940	; 0xfffff09c
    1f3c:	6573755f 	ldrbvs	r7, [r3, #-1375]!	; 0xfffffaa1
    1f40:	6572745f 	ldrbvs	r7, [r2, #-1119]!	; 0xfffffba1
    1f44:	65685f65 	strbvs	r5, [r8, #-3941]!	; 0xfffff09b
    1f48:	005f6572 	subseq	r6, pc, r2, ror r5	; <UNPREDICTABLE>
    1f4c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1f50:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1f54:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1f58:	30316d72 	eorscc	r6, r1, r2, ror sp
    1f5c:	696d6474 	stmdbvs	sp!, {r2, r4, r5, r6, sl, sp, lr}^
    1f60:	52415400 	subpl	r5, r1, #0, 8
    1f64:	5f544547 	svcpl	0x00544547
    1f68:	5f555043 	svcpl	0x00555043
    1f6c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1f70:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    1f74:	73616200 	cmnvc	r1, #0, 4
    1f78:	72615f65 	rsbvc	r5, r1, #404	; 0x194
    1f7c:	74696863 	strbtvc	r6, [r9], #-2147	; 0xfffff79d
    1f80:	75746365 	ldrbvc	r6, [r4, #-869]!	; 0xfffffc9b
    1f84:	61006572 	tstvs	r0, r2, ror r5
    1f88:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1f8c:	5f686372 	svcpl	0x00686372
    1f90:	00637263 	rsbeq	r7, r3, r3, ror #4
    1f94:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1f98:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1f9c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1fa0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1fa4:	73316d78 	teqvc	r1, #120, 26	; 0x1e00
    1fa8:	6c6c616d 	stfvse	f6, [ip], #-436	; 0xfffffe4c
    1fac:	746c756d 	strbtvc	r7, [ip], #-1389	; 0xfffffa93
    1fb0:	796c7069 	stmdbvc	ip!, {r0, r3, r5, r6, ip, sp, lr}^
    1fb4:	6d726100 	ldfvse	f6, [r2, #-0]
    1fb8:	7275635f 	rsbsvc	r6, r5, #2080374785	; 0x7c000001
    1fbc:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
    1fc0:	0063635f 	rsbeq	r6, r3, pc, asr r3
    1fc4:	5f617369 	svcpl	0x00617369
    1fc8:	5f746962 	svcpl	0x00746962
    1fcc:	33637263 	cmncc	r3, #805306374	; 0x30000006
    1fd0:	52410032 	subpl	r0, r1, #50	; 0x32
    1fd4:	4c505f4d 	mrrcmi	15, 4, r5, r0, cr13
    1fd8:	61736900 	cmnvs	r3, r0, lsl #18
    1fdc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1fe0:	7066765f 	rsbvc	r7, r6, pc, asr r6
    1fe4:	69003376 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, r9, ip, sp}
    1fe8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1fec:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    1ff0:	34767066 	ldrbtcc	r7, [r6], #-102	; 0xffffff9a
    1ff4:	53414200 	movtpl	r4, #4608	; 0x1200
    1ff8:	52415f45 	subpl	r5, r1, #276	; 0x114
    1ffc:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    2000:	42003254 	andmi	r3, r0, #84, 4	; 0x40000005
    2004:	5f455341 	svcpl	0x00455341
    2008:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    200c:	5f4d385f 	svcpl	0x004d385f
    2010:	4e49414d 	dvfmiem	f4, f1, #5.0
    2014:	52415400 	subpl	r5, r1, #0, 8
    2018:	5f544547 	svcpl	0x00544547
    201c:	5f555043 	svcpl	0x00555043
    2020:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    2024:	696d6474 	stmdbvs	sp!, {r2, r4, r5, r6, sl, sp, lr}^
    2028:	4d524100 	ldfmie	f4, [r2, #-0]
    202c:	004c415f 	subeq	r4, ip, pc, asr r1
    2030:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    2034:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    2038:	4d375f48 	ldcmi	15, cr5, [r7, #-288]!	; 0xfffffee0
    203c:	6d726100 	ldfvse	f6, [r2, #-0]
    2040:	7261745f 	rsbvc	r7, r1, #1593835520	; 0x5f000000
    2044:	5f746567 	svcpl	0x00746567
    2048:	6562616c 	strbvs	r6, [r2, #-364]!	; 0xfffffe94
    204c:	7261006c 	rsbvc	r0, r1, #108	; 0x6c
    2050:	61745f6d 	cmnvs	r4, sp, ror #30
    2054:	74656772 	strbtvc	r6, [r5], #-1906	; 0xfffff88e
    2058:	736e695f 	cmnvc	lr, #1556480	; 0x17c000
    205c:	4154006e 	cmpmi	r4, lr, rrx
    2060:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2064:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2068:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    206c:	72786574 	rsbsvc	r6, r8, #116, 10	; 0x1d000000
    2070:	41540034 	cmpmi	r4, r4, lsr r0
    2074:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2078:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    207c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2080:	72786574 	rsbsvc	r6, r8, #116, 10	; 0x1d000000
    2084:	41540035 	cmpmi	r4, r5, lsr r0
    2088:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    208c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2090:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2094:	72786574 	rsbsvc	r6, r8, #116, 10	; 0x1d000000
    2098:	41540037 	cmpmi	r4, r7, lsr r0
    209c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    20a0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    20a4:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    20a8:	72786574 	rsbsvc	r6, r8, #116, 10	; 0x1d000000
    20ac:	73690038 	cmnvc	r9, #56	; 0x38
    20b0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    20b4:	706c5f74 	rsbvc	r5, ip, r4, ror pc
    20b8:	69006561 	stmdbvs	r0, {r0, r5, r6, r8, sl, sp, lr}
    20bc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    20c0:	715f7469 	cmpvc	pc, r9, ror #8
    20c4:	6b726975 	blvs	1c9c6a0 <__bss_end+0x1c9370c>
    20c8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    20cc:	7a6b3676 	bvc	1acfaac <__bss_end+0x1ac6b18>
    20d0:	61736900 	cmnvs	r3, r0, lsl #18
    20d4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    20d8:	746f6e5f 	strbtvc	r6, [pc], #-3679	; 20e0 <shift+0x20e0>
    20dc:	7369006d 	cmnvc	r9, #109	; 0x6d
    20e0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    20e4:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    20e8:	0034766d 	eorseq	r7, r4, sp, ror #12
    20ec:	5f617369 	svcpl	0x00617369
    20f0:	5f746962 	svcpl	0x00746962
    20f4:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    20f8:	73690036 	cmnvc	r9, #54	; 0x36
    20fc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2100:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    2104:	0037766d 	eorseq	r7, r7, sp, ror #12
    2108:	5f617369 	svcpl	0x00617369
    210c:	5f746962 	svcpl	0x00746962
    2110:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2114:	645f0038 	ldrbvs	r0, [pc], #-56	; 211c <shift+0x211c>
    2118:	5f746e6f 	svcpl	0x00746e6f
    211c:	5f657375 	svcpl	0x00657375
    2120:	5f787472 	svcpl	0x00787472
    2124:	65726568 	ldrbvs	r6, [r2, #-1384]!	; 0xfffffa98
    2128:	5155005f 	cmppl	r5, pc, asr r0
    212c:	70797449 	rsbsvc	r7, r9, r9, asr #8
    2130:	73690065 	cmnvc	r9, #101	; 0x65
    2134:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2138:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    213c:	7435766d 	ldrtvc	r7, [r5], #-1645	; 0xfffff993
    2140:	72610065 	rsbvc	r0, r1, #101	; 0x65
    2144:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    2148:	6100656e 	tstvs	r0, lr, ror #10
    214c:	635f6d72 	cmpvs	pc, #7296	; 0x1c80
    2150:	695f7070 	ldmdbvs	pc, {r4, r5, r6, ip, sp, lr}^	; <UNPREDICTABLE>
    2154:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    2158:	6b726f77 	blvs	1c9df3c <__bss_end+0x1c94fa8>
    215c:	6e756600 	cdpvs	6, 7, cr6, cr5, cr0, {0}
    2160:	74705f63 	ldrbtvc	r5, [r0], #-3939	; 0xfffff09d
    2164:	41540072 	cmpmi	r4, r2, ror r0
    2168:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    216c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2170:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2174:	74303239 	ldrtvc	r3, [r0], #-569	; 0xfffffdc7
    2178:	61746800 	cmnvs	r4, r0, lsl #16
    217c:	71655f62 	cmnvc	r5, r2, ror #30
    2180:	52415400 	subpl	r5, r1, #0, 8
    2184:	5f544547 	svcpl	0x00544547
    2188:	5f555043 	svcpl	0x00555043
    218c:	32356166 	eorscc	r6, r5, #-2147483623	; 0x80000019
    2190:	72610036 	rsbvc	r0, r1, #54	; 0x36
    2194:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2198:	745f6863 	ldrbvc	r6, [pc], #-2147	; 21a0 <shift+0x21a0>
    219c:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    21a0:	6477685f 	ldrbtvs	r6, [r7], #-2143	; 0xfffff7a1
    21a4:	68007669 	stmdavs	r0, {r0, r3, r5, r6, r9, sl, ip, sp, lr}
    21a8:	5f626174 	svcpl	0x00626174
    21ac:	705f7165 	subsvc	r7, pc, r5, ror #2
    21b0:	746e696f 	strbtvc	r6, [lr], #-2415	; 0xfffff691
    21b4:	61007265 	tstvs	r0, r5, ror #4
    21b8:	705f6d72 	subsvc	r6, pc, r2, ror sp	; <UNPREDICTABLE>
    21bc:	725f6369 	subsvc	r6, pc, #-1543503871	; 0xa4000001
    21c0:	73696765 	cmnvc	r9, #26476544	; 0x1940000
    21c4:	00726574 	rsbseq	r6, r2, r4, ror r5
    21c8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    21cc:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    21d0:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    21d4:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    21d8:	73306d78 	teqvc	r0, #120, 26	; 0x1e00
    21dc:	6c6c616d 	stfvse	f6, [ip], #-436	; 0xfffffe4c
    21e0:	746c756d 	strbtvc	r7, [ip], #-1389	; 0xfffffa93
    21e4:	796c7069 	stmdbvc	ip!, {r0, r3, r5, r6, ip, sp, lr}^
    21e8:	52415400 	subpl	r5, r1, #0, 8
    21ec:	5f544547 	svcpl	0x00544547
    21f0:	5f555043 	svcpl	0x00555043
    21f4:	6f63706d 	svcvs	0x0063706d
    21f8:	6f6e6572 	svcvs	0x006e6572
    21fc:	00706676 	rsbseq	r6, r0, r6, ror r6
    2200:	5f617369 	svcpl	0x00617369
    2204:	5f746962 	svcpl	0x00746962
    2208:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    220c:	6d635f6b 	stclvs	15, cr5, [r3, #-428]!	; 0xfffffe54
    2210:	646c5f33 	strbtvs	r5, [ip], #-3891	; 0xfffff0cd
    2214:	41006472 	tstmi	r0, r2, ror r4
    2218:	435f4d52 	cmpmi	pc, #5248	; 0x1480
    221c:	72610043 	rsbvc	r0, r1, #67	; 0x43
    2220:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2224:	5f386863 	svcpl	0x00386863
    2228:	72610032 	rsbvc	r0, r1, #50	; 0x32
    222c:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2230:	5f386863 	svcpl	0x00386863
    2234:	72610033 	rsbvc	r0, r1, #51	; 0x33
    2238:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    223c:	5f386863 	svcpl	0x00386863
    2240:	41540034 	cmpmi	r4, r4, lsr r0
    2244:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2248:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    224c:	706d665f 	rsbvc	r6, sp, pc, asr r6
    2250:	00363236 	eorseq	r3, r6, r6, lsr r2
    2254:	5f4d5241 	svcpl	0x004d5241
    2258:	61005343 	tstvs	r0, r3, asr #6
    225c:	665f6d72 			; <UNDEFINED> instruction: 0x665f6d72
    2260:	5f363170 	svcpl	0x00363170
    2264:	74736e69 	ldrbtvc	r6, [r3], #-3689	; 0xfffff197
    2268:	6d726100 	ldfvse	f6, [r2, #-0]
    226c:	7361625f 	cmnvc	r1, #-268435451	; 0xf0000005
    2270:	72615f65 	rsbvc	r5, r1, #404	; 0x194
    2274:	54006863 	strpl	r6, [r0], #-2147	; 0xfffff79d
    2278:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    227c:	50435f54 	subpl	r5, r3, r4, asr pc
    2280:	6f635f55 	svcvs	0x00635f55
    2284:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2288:	63353161 	teqvs	r5, #1073741848	; 0x40000018
    228c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2290:	00376178 	eorseq	r6, r7, r8, ror r1
    2294:	5f6d7261 	svcpl	0x006d7261
    2298:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    229c:	006d6537 	rsbeq	r6, sp, r7, lsr r5
    22a0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    22a4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    22a8:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    22ac:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    22b0:	32376178 	eorscc	r6, r7, #120, 2
    22b4:	6d726100 	ldfvse	f6, [r2, #-0]
    22b8:	7363705f 	cmnvc	r3, #95	; 0x5f
    22bc:	6665645f 			; <UNDEFINED> instruction: 0x6665645f
    22c0:	746c7561 	strbtvc	r7, [ip], #-1377	; 0xfffffa9f
    22c4:	4d524100 	ldfmie	f4, [r2, #-0]
    22c8:	5343505f 	movtpl	r5, #12383	; 0x305f
    22cc:	5041415f 	subpl	r4, r1, pc, asr r1
    22d0:	4c5f5343 	mrrcmi	3, 4, r5, pc, cr3	; <UNPREDICTABLE>
    22d4:	4c41434f 	mcrrmi	3, 4, r4, r1, cr15
    22d8:	52415400 	subpl	r5, r1, #0, 8
    22dc:	5f544547 	svcpl	0x00544547
    22e0:	5f555043 	svcpl	0x00555043
    22e4:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    22e8:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    22ec:	41540035 	cmpmi	r4, r5, lsr r0
    22f0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    22f4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    22f8:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
    22fc:	61676e6f 	cmnvs	r7, pc, ror #28
    2300:	61006d72 	tstvs	r0, r2, ror sp
    2304:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2308:	5f686372 	svcpl	0x00686372
    230c:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    2310:	61003162 	tstvs	r0, r2, ror #2
    2314:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2318:	5f686372 	svcpl	0x00686372
    231c:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    2320:	54003262 	strpl	r3, [r0], #-610	; 0xfffffd9e
    2324:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2328:	50435f54 	subpl	r5, r3, r4, asr pc
    232c:	77695f55 			; <UNDEFINED> instruction: 0x77695f55
    2330:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    2334:	6d726100 	ldfvse	f6, [r2, #-0]
    2338:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    233c:	00743568 	rsbseq	r3, r4, r8, ror #10
    2340:	5f617369 	svcpl	0x00617369
    2344:	5f746962 	svcpl	0x00746962
    2348:	6100706d 	tstvs	r0, sp, rrx
    234c:	6c5f6d72 	mrrcvs	13, 7, r6, pc, cr2	; <UNPREDICTABLE>
    2350:	63735f64 	cmnvs	r3, #100, 30	; 0x190
    2354:	00646568 	rsbeq	r6, r4, r8, ror #10
    2358:	5f6d7261 	svcpl	0x006d7261
    235c:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2360:	00315f38 	eorseq	r5, r1, r8, lsr pc

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
  20:	8b040e42 	blhi	103930 <__bss_end+0xfa99c>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x34789c>
  28:	420d0d68 	andmi	r0, sp, #104, 26	; 0x1a00
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008070 	andeq	r8, r0, r0, ror r0
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1fa9bc>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xf9cec>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080b0 	strheq	r8, [r0], -r0
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xfa9ec>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x3478ec>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080e8 	andeq	r8, r0, r8, ror #1
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xfaa0c>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x34790c>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008114 	andeq	r8, r0, r4, lsl r1
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xfaa2c>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x34792c>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008134 	andeq	r8, r0, r4, lsr r1
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xfaa4c>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x34794c>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	0000814c 	andeq	r8, r0, ip, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xfaa6c>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x34796c>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008164 	andeq	r8, r0, r4, ror #2
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xfaa8c>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x34798c>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	0000817c 	andeq	r8, r0, ip, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xfaaac>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x3479ac>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	00008188 	andeq	r8, r0, r8, lsl #3
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1faac4>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081e0 	andeq	r8, r0, r0, ror #3
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1faae4>
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
 194:	0000003c 	andeq	r0, r0, ip, lsr r0
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1fab14>
 19c:	42018e02 	andmi	r8, r1, #2, 28
 1a0:	58040b0c 	stmdapl	r4, {r2, r3, r8, r9, fp}
 1a4:	00080d0c 	andeq	r0, r8, ip, lsl #26
 1a8:	00000018 	andeq	r0, r0, r8, lsl r0
 1ac:	00000178 	andeq	r0, r0, r8, ror r1
 1b0:	00008274 	andeq	r8, r0, r4, ror r2
 1b4:	00000144 	andeq	r0, r0, r4, asr #2
 1b8:	8b080e42 	blhi	203ac8 <__bss_end+0x1fab34>
 1bc:	42018e02 	andmi	r8, r1, #2, 28
 1c0:	00040b0c 	andeq	r0, r4, ip, lsl #22
 1c4:	0000000c 	andeq	r0, r0, ip
 1c8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 1cc:	7c020001 	stcvc	0, cr0, [r2], {1}
 1d0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 1d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1d8:	000001c4 	andeq	r0, r0, r4, asr #3
 1dc:	000083b8 			; <UNDEFINED> instruction: 0x000083b8
 1e0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1e4:	8b040e42 	blhi	103af4 <__bss_end+0xfab60>
 1e8:	0b0d4201 	bleq	3509f4 <__bss_end+0x347a60>
 1ec:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1f8:	000001c4 	andeq	r0, r0, r4, asr #3
 1fc:	000083e4 	andeq	r8, r0, r4, ror #7
 200:	0000002c 	andeq	r0, r0, ip, lsr #32
 204:	8b040e42 	blhi	103b14 <__bss_end+0xfab80>
 208:	0b0d4201 	bleq	350a14 <__bss_end+0x347a80>
 20c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 210:	00000ecb 	andeq	r0, r0, fp, asr #29
 214:	0000001c 	andeq	r0, r0, ip, lsl r0
 218:	000001c4 	andeq	r0, r0, r4, asr #3
 21c:	00008410 	andeq	r8, r0, r0, lsl r4
 220:	0000001c 	andeq	r0, r0, ip, lsl r0
 224:	8b040e42 	blhi	103b34 <__bss_end+0xfaba0>
 228:	0b0d4201 	bleq	350a34 <__bss_end+0x347aa0>
 22c:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 230:	00000ecb 	andeq	r0, r0, fp, asr #29
 234:	0000001c 	andeq	r0, r0, ip, lsl r0
 238:	000001c4 	andeq	r0, r0, r4, asr #3
 23c:	0000842c 	andeq	r8, r0, ip, lsr #8
 240:	00000044 	andeq	r0, r0, r4, asr #32
 244:	8b040e42 	blhi	103b54 <__bss_end+0xfabc0>
 248:	0b0d4201 	bleq	350a54 <__bss_end+0x347ac0>
 24c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 250:	00000ecb 	andeq	r0, r0, fp, asr #29
 254:	0000001c 	andeq	r0, r0, ip, lsl r0
 258:	000001c4 	andeq	r0, r0, r4, asr #3
 25c:	00008470 	andeq	r8, r0, r0, ror r4
 260:	00000050 	andeq	r0, r0, r0, asr r0
 264:	8b040e42 	blhi	103b74 <__bss_end+0xfabe0>
 268:	0b0d4201 	bleq	350a74 <__bss_end+0x347ae0>
 26c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 270:	00000ecb 	andeq	r0, r0, fp, asr #29
 274:	0000001c 	andeq	r0, r0, ip, lsl r0
 278:	000001c4 	andeq	r0, r0, r4, asr #3
 27c:	000084c0 	andeq	r8, r0, r0, asr #9
 280:	00000050 	andeq	r0, r0, r0, asr r0
 284:	8b040e42 	blhi	103b94 <__bss_end+0xfac00>
 288:	0b0d4201 	bleq	350a94 <__bss_end+0x347b00>
 28c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 290:	00000ecb 	andeq	r0, r0, fp, asr #29
 294:	0000001c 	andeq	r0, r0, ip, lsl r0
 298:	000001c4 	andeq	r0, r0, r4, asr #3
 29c:	00008510 	andeq	r8, r0, r0, lsl r5
 2a0:	0000002c 	andeq	r0, r0, ip, lsr #32
 2a4:	8b040e42 	blhi	103bb4 <__bss_end+0xfac20>
 2a8:	0b0d4201 	bleq	350ab4 <__bss_end+0x347b20>
 2ac:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 2b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2b8:	000001c4 	andeq	r0, r0, r4, asr #3
 2bc:	0000853c 	andeq	r8, r0, ip, lsr r5
 2c0:	00000050 	andeq	r0, r0, r0, asr r0
 2c4:	8b040e42 	blhi	103bd4 <__bss_end+0xfac40>
 2c8:	0b0d4201 	bleq	350ad4 <__bss_end+0x347b40>
 2cc:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2d8:	000001c4 	andeq	r0, r0, r4, asr #3
 2dc:	0000858c 	andeq	r8, r0, ip, lsl #11
 2e0:	00000044 	andeq	r0, r0, r4, asr #32
 2e4:	8b040e42 	blhi	103bf4 <__bss_end+0xfac60>
 2e8:	0b0d4201 	bleq	350af4 <__bss_end+0x347b60>
 2ec:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 2f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2f8:	000001c4 	andeq	r0, r0, r4, asr #3
 2fc:	000085d0 	ldrdeq	r8, [r0], -r0
 300:	00000050 	andeq	r0, r0, r0, asr r0
 304:	8b040e42 	blhi	103c14 <__bss_end+0xfac80>
 308:	0b0d4201 	bleq	350b14 <__bss_end+0x347b80>
 30c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 310:	00000ecb 	andeq	r0, r0, fp, asr #29
 314:	0000001c 	andeq	r0, r0, ip, lsl r0
 318:	000001c4 	andeq	r0, r0, r4, asr #3
 31c:	00008620 	andeq	r8, r0, r0, lsr #12
 320:	00000054 	andeq	r0, r0, r4, asr r0
 324:	8b040e42 	blhi	103c34 <__bss_end+0xfaca0>
 328:	0b0d4201 	bleq	350b34 <__bss_end+0x347ba0>
 32c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 330:	00000ecb 	andeq	r0, r0, fp, asr #29
 334:	0000001c 	andeq	r0, r0, ip, lsl r0
 338:	000001c4 	andeq	r0, r0, r4, asr #3
 33c:	00008674 	andeq	r8, r0, r4, ror r6
 340:	0000003c 	andeq	r0, r0, ip, lsr r0
 344:	8b040e42 	blhi	103c54 <__bss_end+0xfacc0>
 348:	0b0d4201 	bleq	350b54 <__bss_end+0x347bc0>
 34c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 350:	00000ecb 	andeq	r0, r0, fp, asr #29
 354:	0000001c 	andeq	r0, r0, ip, lsl r0
 358:	000001c4 	andeq	r0, r0, r4, asr #3
 35c:	000086b0 			; <UNDEFINED> instruction: 0x000086b0
 360:	0000003c 	andeq	r0, r0, ip, lsr r0
 364:	8b040e42 	blhi	103c74 <__bss_end+0xface0>
 368:	0b0d4201 	bleq	350b74 <__bss_end+0x347be0>
 36c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 370:	00000ecb 	andeq	r0, r0, fp, asr #29
 374:	0000001c 	andeq	r0, r0, ip, lsl r0
 378:	000001c4 	andeq	r0, r0, r4, asr #3
 37c:	000086ec 	andeq	r8, r0, ip, ror #13
 380:	0000003c 	andeq	r0, r0, ip, lsr r0
 384:	8b040e42 	blhi	103c94 <__bss_end+0xfad00>
 388:	0b0d4201 	bleq	350b94 <__bss_end+0x347c00>
 38c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 390:	00000ecb 	andeq	r0, r0, fp, asr #29
 394:	0000001c 	andeq	r0, r0, ip, lsl r0
 398:	000001c4 	andeq	r0, r0, r4, asr #3
 39c:	00008728 	andeq	r8, r0, r8, lsr #14
 3a0:	0000003c 	andeq	r0, r0, ip, lsr r0
 3a4:	8b040e42 	blhi	103cb4 <__bss_end+0xfad20>
 3a8:	0b0d4201 	bleq	350bb4 <__bss_end+0x347c20>
 3ac:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 3b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 3b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3b8:	000001c4 	andeq	r0, r0, r4, asr #3
 3bc:	00008764 	andeq	r8, r0, r4, ror #14
 3c0:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 3c4:	8b080e42 	blhi	203cd4 <__bss_end+0x1fad40>
 3c8:	42018e02 	andmi	r8, r1, #2, 28
 3cc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3d0:	080d0c50 	stmdaeq	sp, {r4, r6, sl, fp}
 3d4:	0000000c 	andeq	r0, r0, ip
 3d8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 3dc:	7c020001 	stcvc	0, cr0, [r2], {1}
 3e0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 3e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3e8:	000003d4 	ldrdeq	r0, [r0], -r4
 3ec:	00008814 	andeq	r8, r0, r4, lsl r8
 3f0:	00000174 	andeq	r0, r0, r4, ror r1
 3f4:	8b080e42 	blhi	203d04 <__bss_end+0x1fad70>
 3f8:	42018e02 	andmi	r8, r1, #2, 28
 3fc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 400:	080d0cb2 	stmdaeq	sp, {r1, r4, r5, r7, sl, fp}
 404:	0000001c 	andeq	r0, r0, ip, lsl r0
 408:	000003d4 	ldrdeq	r0, [r0], -r4
 40c:	00008988 	andeq	r8, r0, r8, lsl #19
 410:	0000009c 	muleq	r0, ip, r0
 414:	8b040e42 	blhi	103d24 <__bss_end+0xfad90>
 418:	0b0d4201 	bleq	350c24 <__bss_end+0x347c90>
 41c:	0d0d4602 	stceq	6, cr4, [sp, #-8]
 420:	000ecb42 	andeq	ip, lr, r2, asr #22
 424:	0000001c 	andeq	r0, r0, ip, lsl r0
 428:	000003d4 	ldrdeq	r0, [r0], -r4
 42c:	00008a24 	andeq	r8, r0, r4, lsr #20
 430:	000000c0 	andeq	r0, r0, r0, asr #1
 434:	8b040e42 	blhi	103d44 <__bss_end+0xfadb0>
 438:	0b0d4201 	bleq	350c44 <__bss_end+0x347cb0>
 43c:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 440:	000ecb42 	andeq	ip, lr, r2, asr #22
 444:	0000001c 	andeq	r0, r0, ip, lsl r0
 448:	000003d4 	ldrdeq	r0, [r0], -r4
 44c:	00008ae4 	andeq	r8, r0, r4, ror #21
 450:	000000ac 	andeq	r0, r0, ip, lsr #1
 454:	8b040e42 	blhi	103d64 <__bss_end+0xfadd0>
 458:	0b0d4201 	bleq	350c64 <__bss_end+0x347cd0>
 45c:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 460:	000ecb42 	andeq	ip, lr, r2, asr #22
 464:	0000001c 	andeq	r0, r0, ip, lsl r0
 468:	000003d4 	ldrdeq	r0, [r0], -r4
 46c:	00008b90 	muleq	r0, r0, fp
 470:	00000054 	andeq	r0, r0, r4, asr r0
 474:	8b040e42 	blhi	103d84 <__bss_end+0xfadf0>
 478:	0b0d4201 	bleq	350c84 <__bss_end+0x347cf0>
 47c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 480:	00000ecb 	andeq	r0, r0, fp, asr #29
 484:	0000001c 	andeq	r0, r0, ip, lsl r0
 488:	000003d4 	ldrdeq	r0, [r0], -r4
 48c:	00008be4 	andeq	r8, r0, r4, ror #23
 490:	00000068 	andeq	r0, r0, r8, rrx
 494:	8b040e42 	blhi	103da4 <__bss_end+0xfae10>
 498:	0b0d4201 	bleq	350ca4 <__bss_end+0x347d10>
 49c:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 4a0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4a8:	000003d4 	ldrdeq	r0, [r0], -r4
 4ac:	00008c4c 	andeq	r8, r0, ip, asr #24
 4b0:	00000080 	andeq	r0, r0, r0, lsl #1
 4b4:	8b040e42 	blhi	103dc4 <__bss_end+0xfae30>
 4b8:	0b0d4201 	bleq	350cc4 <__bss_end+0x347d30>
 4bc:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 4c0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4c4:	0000000c 	andeq	r0, r0, ip
 4c8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 4cc:	7c010001 	stcvc	0, cr0, [r1], {1}
 4d0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 4d4:	0000000c 	andeq	r0, r0, ip
 4d8:	000004c4 	andeq	r0, r0, r4, asr #9
 4dc:	00008ccc 	andeq	r8, r0, ip, asr #25
 4e0:	000001ec 	andeq	r0, r0, ip, ror #3
