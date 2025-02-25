
./oled_task:     file format elf32-littlearm


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
    8068:	00009734 	andeq	r9, r0, r4, lsr r7
    806c:	00009744 	andeq	r9, r0, r4, asr #14

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
    81d8:	00009720 	andeq	r9, r0, r0, lsr #14
    81dc:	00009720 	andeq	r9, r0, r0, lsr #14

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
    8230:	00009720 	andeq	r9, r0, r0, lsr #14
    8234:	00009720 	andeq	r9, r0, r0, lsr #14

00008238 <main>:
main():
/home/schenkj/os2022/sp/sources/userspace/oled_task/main.cpp:27
	"My favourite sport is ARM wrestling",
	"Old MacDonald had a farm, EIGRP",
};

int main(int argc, char** argv)
{
    8238:	e92d4800 	push	{fp, lr}
    823c:	e28db004 	add	fp, sp, #4
    8240:	e24dd020 	sub	sp, sp, #32
    8244:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
    8248:	e50b1024 	str	r1, [fp, #-36]	; 0xffffffdc
/home/schenkj/os2022/sp/sources/userspace/oled_task/main.cpp:28
	COLED_Display disp("DEV:oled");
    824c:	e24b3014 	sub	r3, fp, #20
    8250:	e59f10d8 	ldr	r1, [pc, #216]	; 8330 <main+0xf8>
    8254:	e1a00003 	mov	r0, r3
    8258:	eb00027e 	bl	8c58 <_ZN13COLED_DisplayC1EPKc>
/home/schenkj/os2022/sp/sources/userspace/oled_task/main.cpp:29
	disp.Clear(false);
    825c:	e24b3014 	sub	r3, fp, #20
    8260:	e3a01000 	mov	r1, #0
    8264:	e1a00003 	mov	r0, r3
    8268:	eb0002b1 	bl	8d34 <_ZN13COLED_Display5ClearEb>
/home/schenkj/os2022/sp/sources/userspace/oled_task/main.cpp:30
	disp.Put_String(10, 10, "KIV-RTOS init...");
    826c:	e24b0014 	sub	r0, fp, #20
    8270:	e59f30bc 	ldr	r3, [pc, #188]	; 8334 <main+0xfc>
    8274:	e3a0200a 	mov	r2, #10
    8278:	e3a0100a 	mov	r1, #10
    827c:	eb000376 	bl	905c <_ZN13COLED_Display10Put_StringEttPKc>
/home/schenkj/os2022/sp/sources/userspace/oled_task/main.cpp:31
	disp.Flip();
    8280:	e24b3014 	sub	r3, fp, #20
    8284:	e1a00003 	mov	r0, r3
    8288:	eb00035d 	bl	9004 <_ZN13COLED_Display4FlipEv>
/home/schenkj/os2022/sp/sources/userspace/oled_task/main.cpp:33

	uint32_t trng_file = open("DEV:trng", NFile_Open_Mode::Read_Only);
    828c:	e3a01000 	mov	r1, #0
    8290:	e59f00a0 	ldr	r0, [pc, #160]	; 8338 <main+0x100>
    8294:	eb000047 	bl	83b8 <_Z4openPKc15NFile_Open_Mode>
    8298:	e50b0008 	str	r0, [fp, #-8]
/home/schenkj/os2022/sp/sources/userspace/oled_task/main.cpp:34
	uint32_t num = 0;
    829c:	e3a03000 	mov	r3, #0
    82a0:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/userspace/oled_task/main.cpp:36

	sleep(0x800, 0x800);
    82a4:	e3a01b02 	mov	r1, #2048	; 0x800
    82a8:	e3a00b02 	mov	r0, #2048	; 0x800
    82ac:	eb0000be 	bl	85ac <_Z5sleepjj>
/home/schenkj/os2022/sp/sources/userspace/oled_task/main.cpp:41 (discriminator 1)

	while (true)
	{
		// ziskame si nahodne cislo a vybereme podle toho zpravu
		read(trng_file, reinterpret_cast<char*>(&num), sizeof(num));
    82b0:	e24b3018 	sub	r3, fp, #24
    82b4:	e3a02004 	mov	r2, #4
    82b8:	e1a01003 	mov	r1, r3
    82bc:	e51b0008 	ldr	r0, [fp, #-8]
    82c0:	eb00004d 	bl	83fc <_Z4readjPcj>
/home/schenkj/os2022/sp/sources/userspace/oled_task/main.cpp:42 (discriminator 1)
		const char* msg = messages[num % (sizeof(messages) / sizeof(const char*))];
    82c4:	e51b1018 	ldr	r1, [fp, #-24]	; 0xffffffe8
    82c8:	e59f306c 	ldr	r3, [pc, #108]	; 833c <main+0x104>
    82cc:	e0832193 	umull	r2, r3, r3, r1
    82d0:	e1a02123 	lsr	r2, r3, #2
    82d4:	e1a03002 	mov	r3, r2
    82d8:	e1a03103 	lsl	r3, r3, #2
    82dc:	e0833002 	add	r3, r3, r2
    82e0:	e0412003 	sub	r2, r1, r3
    82e4:	e59f3054 	ldr	r3, [pc, #84]	; 8340 <main+0x108>
    82e8:	e7933102 	ldr	r3, [r3, r2, lsl #2]
    82ec:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/userspace/oled_task/main.cpp:44 (discriminator 1)

		disp.Clear(false);
    82f0:	e24b3014 	sub	r3, fp, #20
    82f4:	e3a01000 	mov	r1, #0
    82f8:	e1a00003 	mov	r0, r3
    82fc:	eb00028c 	bl	8d34 <_ZN13COLED_Display5ClearEb>
/home/schenkj/os2022/sp/sources/userspace/oled_task/main.cpp:45 (discriminator 1)
		disp.Put_String(0, 0, msg);
    8300:	e24b0014 	sub	r0, fp, #20
    8304:	e51b300c 	ldr	r3, [fp, #-12]
    8308:	e3a02000 	mov	r2, #0
    830c:	e3a01000 	mov	r1, #0
    8310:	eb000351 	bl	905c <_ZN13COLED_Display10Put_StringEttPKc>
/home/schenkj/os2022/sp/sources/userspace/oled_task/main.cpp:46 (discriminator 1)
		disp.Flip();
    8314:	e24b3014 	sub	r3, fp, #20
    8318:	e1a00003 	mov	r0, r3
    831c:	eb000338 	bl	9004 <_ZN13COLED_Display4FlipEv>
/home/schenkj/os2022/sp/sources/userspace/oled_task/main.cpp:48 (discriminator 1)

		sleep(0x4000, 0x800); // TODO: z tohohle bude casem cekani na podminkove promenne (na eventu) s timeoutem
    8320:	e3a01b02 	mov	r1, #2048	; 0x800
    8324:	e3a00901 	mov	r0, #16384	; 0x4000
    8328:	eb00009f 	bl	85ac <_Z5sleepjj>
/home/schenkj/os2022/sp/sources/userspace/oled_task/main.cpp:49 (discriminator 1)
	}
    832c:	eaffffdf 	b	82b0 <main+0x78>
    8330:	00009404 	andeq	r9, r0, r4, lsl #8
    8334:	00009410 	andeq	r9, r0, r0, lsl r4
    8338:	00009424 	andeq	r9, r0, r4, lsr #8
    833c:	cccccccd 	stclgt	12, cr12, [ip], {205}	; 0xcd
    8340:	00009720 	andeq	r9, r0, r0, lsr #14

00008344 <_Z6getpidv>:
_Z6getpidv():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:5
#include <stdfile.h>
#include <stdstring.h>

uint32_t getpid()
{
    8344:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8348:	e28db000 	add	fp, sp, #0
    834c:	e24dd00c 	sub	sp, sp, #12
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:8
    uint32_t pid;

    asm volatile("swi 0");
    8350:	ef000000 	svc	0x00000000
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:9
    asm volatile("mov %0, r0" : "=r" (pid));
    8354:	e1a03000 	mov	r3, r0
    8358:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:11

    return pid;
    835c:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:12
}
    8360:	e1a00003 	mov	r0, r3
    8364:	e28bd000 	add	sp, fp, #0
    8368:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    836c:	e12fff1e 	bx	lr

00008370 <_Z9terminatei>:
_Z9terminatei():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:15

void terminate(int exitcode)
{
    8370:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8374:	e28db000 	add	fp, sp, #0
    8378:	e24dd00c 	sub	sp, sp, #12
    837c:	e50b0008 	str	r0, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:16
    asm volatile("mov r0, %0" : : "r" (exitcode));
    8380:	e51b3008 	ldr	r3, [fp, #-8]
    8384:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:17
    asm volatile("swi 1");
    8388:	ef000001 	svc	0x00000001
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:18
}
    838c:	e320f000 	nop	{0}
    8390:	e28bd000 	add	sp, fp, #0
    8394:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8398:	e12fff1e 	bx	lr

0000839c <_Z11sched_yieldv>:
_Z11sched_yieldv():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:21

void sched_yield()
{
    839c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83a0:	e28db000 	add	fp, sp, #0
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:22
    asm volatile("swi 2");
    83a4:	ef000002 	svc	0x00000002
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:23
}
    83a8:	e320f000 	nop	{0}
    83ac:	e28bd000 	add	sp, fp, #0
    83b0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83b4:	e12fff1e 	bx	lr

000083b8 <_Z4openPKc15NFile_Open_Mode>:
_Z4openPKc15NFile_Open_Mode():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:26

uint32_t open(const char* filename, NFile_Open_Mode mode)
{
    83b8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83bc:	e28db000 	add	fp, sp, #0
    83c0:	e24dd014 	sub	sp, sp, #20
    83c4:	e50b0010 	str	r0, [fp, #-16]
    83c8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:29
    uint32_t file;

    asm volatile("mov r0, %0" : : "r" (filename));
    83cc:	e51b3010 	ldr	r3, [fp, #-16]
    83d0:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:30
    asm volatile("mov r1, %0" : : "r" (mode));
    83d4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    83d8:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:31
    asm volatile("swi 64");
    83dc:	ef000040 	svc	0x00000040
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:32
    asm volatile("mov %0, r0" : "=r" (file));
    83e0:	e1a03000 	mov	r3, r0
    83e4:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:34

    return file;
    83e8:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:35
}
    83ec:	e1a00003 	mov	r0, r3
    83f0:	e28bd000 	add	sp, fp, #0
    83f4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83f8:	e12fff1e 	bx	lr

000083fc <_Z4readjPcj>:
_Z4readjPcj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:38

uint32_t read(uint32_t file, char* const buffer, uint32_t size)
{
    83fc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8400:	e28db000 	add	fp, sp, #0
    8404:	e24dd01c 	sub	sp, sp, #28
    8408:	e50b0010 	str	r0, [fp, #-16]
    840c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8410:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:41
    uint32_t rdnum;

    asm volatile("mov r0, %0" : : "r" (file));
    8414:	e51b3010 	ldr	r3, [fp, #-16]
    8418:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:42
    asm volatile("mov r1, %0" : : "r" (buffer));
    841c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8420:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:43
    asm volatile("mov r2, %0" : : "r" (size));
    8424:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8428:	e1a02003 	mov	r2, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:44
    asm volatile("swi 65");
    842c:	ef000041 	svc	0x00000041
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:45
    asm volatile("mov %0, r0" : "=r" (rdnum));
    8430:	e1a03000 	mov	r3, r0
    8434:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:47

    return rdnum;
    8438:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:48
}
    843c:	e1a00003 	mov	r0, r3
    8440:	e28bd000 	add	sp, fp, #0
    8444:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8448:	e12fff1e 	bx	lr

0000844c <_Z5writejPKcj>:
_Z5writejPKcj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:51

uint32_t write(uint32_t file, const char* buffer, uint32_t size)
{
    844c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8450:	e28db000 	add	fp, sp, #0
    8454:	e24dd01c 	sub	sp, sp, #28
    8458:	e50b0010 	str	r0, [fp, #-16]
    845c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8460:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:54
    uint32_t wrnum;

    asm volatile("mov r0, %0" : : "r" (file));
    8464:	e51b3010 	ldr	r3, [fp, #-16]
    8468:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:55
    asm volatile("mov r1, %0" : : "r" (buffer));
    846c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8470:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:56
    asm volatile("mov r2, %0" : : "r" (size));
    8474:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8478:	e1a02003 	mov	r2, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:57
    asm volatile("swi 66");
    847c:	ef000042 	svc	0x00000042
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:58
    asm volatile("mov %0, r0" : "=r" (wrnum));
    8480:	e1a03000 	mov	r3, r0
    8484:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:60

    return wrnum;
    8488:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:61
}
    848c:	e1a00003 	mov	r0, r3
    8490:	e28bd000 	add	sp, fp, #0
    8494:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8498:	e12fff1e 	bx	lr

0000849c <_Z5closej>:
_Z5closej():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:64

void close(uint32_t file)
{
    849c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    84a0:	e28db000 	add	fp, sp, #0
    84a4:	e24dd00c 	sub	sp, sp, #12
    84a8:	e50b0008 	str	r0, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:65
    asm volatile("mov r0, %0" : : "r" (file));
    84ac:	e51b3008 	ldr	r3, [fp, #-8]
    84b0:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:66
    asm volatile("swi 67");
    84b4:	ef000043 	svc	0x00000043
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:67
}
    84b8:	e320f000 	nop	{0}
    84bc:	e28bd000 	add	sp, fp, #0
    84c0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    84c4:	e12fff1e 	bx	lr

000084c8 <_Z5ioctlj16NIOCtl_OperationPv>:
_Z5ioctlj16NIOCtl_OperationPv():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:70

uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param)
{
    84c8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    84cc:	e28db000 	add	fp, sp, #0
    84d0:	e24dd01c 	sub	sp, sp, #28
    84d4:	e50b0010 	str	r0, [fp, #-16]
    84d8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    84dc:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:73
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    84e0:	e51b3010 	ldr	r3, [fp, #-16]
    84e4:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:74
    asm volatile("mov r1, %0" : : "r" (operation));
    84e8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84ec:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:75
    asm volatile("mov r2, %0" : : "r" (param));
    84f0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    84f4:	e1a02003 	mov	r2, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:76
    asm volatile("swi 68");
    84f8:	ef000044 	svc	0x00000044
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:77
    asm volatile("mov %0, r0" : "=r" (retcode));
    84fc:	e1a03000 	mov	r3, r0
    8500:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:79

    return retcode;
    8504:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:80
}
    8508:	e1a00003 	mov	r0, r3
    850c:	e28bd000 	add	sp, fp, #0
    8510:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8514:	e12fff1e 	bx	lr

00008518 <_Z6notifyjj>:
_Z6notifyjj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:83

uint32_t notify(uint32_t file, uint32_t count)
{
    8518:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    851c:	e28db000 	add	fp, sp, #0
    8520:	e24dd014 	sub	sp, sp, #20
    8524:	e50b0010 	str	r0, [fp, #-16]
    8528:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:86
    uint32_t retcnt;

    asm volatile("mov r0, %0" : : "r" (file));
    852c:	e51b3010 	ldr	r3, [fp, #-16]
    8530:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:87
    asm volatile("mov r1, %0" : : "r" (count));
    8534:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8538:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:88
    asm volatile("swi 69");
    853c:	ef000045 	svc	0x00000045
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:89
    asm volatile("mov %0, r0" : "=r" (retcnt));
    8540:	e1a03000 	mov	r3, r0
    8544:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:91

    return retcnt;
    8548:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:92
}
    854c:	e1a00003 	mov	r0, r3
    8550:	e28bd000 	add	sp, fp, #0
    8554:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8558:	e12fff1e 	bx	lr

0000855c <_Z4waitjjj>:
_Z4waitjjj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:95

NSWI_Result_Code wait(uint32_t file, uint32_t count, uint32_t notified_deadline)
{
    855c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8560:	e28db000 	add	fp, sp, #0
    8564:	e24dd01c 	sub	sp, sp, #28
    8568:	e50b0010 	str	r0, [fp, #-16]
    856c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8570:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:98
    NSWI_Result_Code retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    8574:	e51b3010 	ldr	r3, [fp, #-16]
    8578:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:99
    asm volatile("mov r1, %0" : : "r" (count));
    857c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8580:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:100
    asm volatile("mov r2, %0" : : "r" (notified_deadline));
    8584:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8588:	e1a02003 	mov	r2, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:101
    asm volatile("swi 70");
    858c:	ef000046 	svc	0x00000046
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:102
    asm volatile("mov %0, r0" : "=r" (retcode));
    8590:	e1a03000 	mov	r3, r0
    8594:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:104

    return retcode;
    8598:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:105
}
    859c:	e1a00003 	mov	r0, r3
    85a0:	e28bd000 	add	sp, fp, #0
    85a4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85a8:	e12fff1e 	bx	lr

000085ac <_Z5sleepjj>:
_Z5sleepjj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:108

bool sleep(uint32_t ticks, uint32_t notified_deadline)
{
    85ac:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85b0:	e28db000 	add	fp, sp, #0
    85b4:	e24dd014 	sub	sp, sp, #20
    85b8:	e50b0010 	str	r0, [fp, #-16]
    85bc:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:111
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (ticks));
    85c0:	e51b3010 	ldr	r3, [fp, #-16]
    85c4:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:112
    asm volatile("mov r1, %0" : : "r" (notified_deadline));
    85c8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    85cc:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:113
    asm volatile("swi 3");
    85d0:	ef000003 	svc	0x00000003
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:114
    asm volatile("mov %0, r0" : "=r" (retcode));
    85d4:	e1a03000 	mov	r3, r0
    85d8:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:116

    return retcode;
    85dc:	e51b3008 	ldr	r3, [fp, #-8]
    85e0:	e3530000 	cmp	r3, #0
    85e4:	13a03001 	movne	r3, #1
    85e8:	03a03000 	moveq	r3, #0
    85ec:	e6ef3073 	uxtb	r3, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:117
}
    85f0:	e1a00003 	mov	r0, r3
    85f4:	e28bd000 	add	sp, fp, #0
    85f8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85fc:	e12fff1e 	bx	lr

00008600 <_Z24get_active_process_countv>:
_Z24get_active_process_countv():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:120

uint32_t get_active_process_count()
{
    8600:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8604:	e28db000 	add	fp, sp, #0
    8608:	e24dd00c 	sub	sp, sp, #12
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:121
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Active_Process_Count;
    860c:	e3a03000 	mov	r3, #0
    8610:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:124
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    8614:	e3a03000 	mov	r3, #0
    8618:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:125
    asm volatile("mov r1, %0" : : "r" (&retval));
    861c:	e24b300c 	sub	r3, fp, #12
    8620:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:126
    asm volatile("swi 4");
    8624:	ef000004 	svc	0x00000004
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:128

    return retval;
    8628:	e51b300c 	ldr	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:129
}
    862c:	e1a00003 	mov	r0, r3
    8630:	e28bd000 	add	sp, fp, #0
    8634:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8638:	e12fff1e 	bx	lr

0000863c <_Z14get_tick_countv>:
_Z14get_tick_countv():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:132

uint32_t get_tick_count()
{
    863c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8640:	e28db000 	add	fp, sp, #0
    8644:	e24dd00c 	sub	sp, sp, #12
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:133
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Tick_Count;
    8648:	e3a03001 	mov	r3, #1
    864c:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:136
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    8650:	e3a03001 	mov	r3, #1
    8654:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:137
    asm volatile("mov r1, %0" : : "r" (&retval));
    8658:	e24b300c 	sub	r3, fp, #12
    865c:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:138
    asm volatile("swi 4");
    8660:	ef000004 	svc	0x00000004
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:140

    return retval;
    8664:	e51b300c 	ldr	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:141
}
    8668:	e1a00003 	mov	r0, r3
    866c:	e28bd000 	add	sp, fp, #0
    8670:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8674:	e12fff1e 	bx	lr

00008678 <_Z17set_task_deadlinej>:
_Z17set_task_deadlinej():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:144

void set_task_deadline(uint32_t tick_count_required)
{
    8678:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    867c:	e28db000 	add	fp, sp, #0
    8680:	e24dd014 	sub	sp, sp, #20
    8684:	e50b0010 	str	r0, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:145
    const NDeadline_Subservice req = NDeadline_Subservice::Set_Relative;
    8688:	e3a03000 	mov	r3, #0
    868c:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:147

    asm volatile("mov r0, %0" : : "r" (req));
    8690:	e3a03000 	mov	r3, #0
    8694:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:148
    asm volatile("mov r1, %0" : : "r" (&tick_count_required));
    8698:	e24b3010 	sub	r3, fp, #16
    869c:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:149
    asm volatile("swi 5");
    86a0:	ef000005 	svc	0x00000005
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:150
}
    86a4:	e320f000 	nop	{0}
    86a8:	e28bd000 	add	sp, fp, #0
    86ac:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86b0:	e12fff1e 	bx	lr

000086b4 <_Z26get_task_ticks_to_deadlinev>:
_Z26get_task_ticks_to_deadlinev():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:153

uint32_t get_task_ticks_to_deadline()
{
    86b4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    86b8:	e28db000 	add	fp, sp, #0
    86bc:	e24dd00c 	sub	sp, sp, #12
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:154
    const NDeadline_Subservice req = NDeadline_Subservice::Get_Remaining;
    86c0:	e3a03001 	mov	r3, #1
    86c4:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:157
    uint32_t ticks;

    asm volatile("mov r0, %0" : : "r" (req));
    86c8:	e3a03001 	mov	r3, #1
    86cc:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:158
    asm volatile("mov r1, %0" : : "r" (&ticks));
    86d0:	e24b300c 	sub	r3, fp, #12
    86d4:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:159
    asm volatile("swi 5");
    86d8:	ef000005 	svc	0x00000005
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:161

    return ticks;
    86dc:	e51b300c 	ldr	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:162
}
    86e0:	e1a00003 	mov	r0, r3
    86e4:	e28bd000 	add	sp, fp, #0
    86e8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86ec:	e12fff1e 	bx	lr

000086f0 <_Z4pipePKcj>:
_Z4pipePKcj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:167

const char Pipe_File_Prefix[] = "SYS:pipe/";

uint32_t pipe(const char* name, uint32_t buf_size)
{
    86f0:	e92d4800 	push	{fp, lr}
    86f4:	e28db004 	add	fp, sp, #4
    86f8:	e24dd050 	sub	sp, sp, #80	; 0x50
    86fc:	e50b0050 	str	r0, [fp, #-80]	; 0xffffffb0
    8700:	e50b1054 	str	r1, [fp, #-84]	; 0xffffffac
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:169
    char fname[64];
    strncpy(fname, Pipe_File_Prefix, sizeof(Pipe_File_Prefix));
    8704:	e24b3048 	sub	r3, fp, #72	; 0x48
    8708:	e3a0200a 	mov	r2, #10
    870c:	e59f1088 	ldr	r1, [pc, #136]	; 879c <_Z4pipePKcj+0xac>
    8710:	e1a00003 	mov	r0, r3
    8714:	eb0000a5 	bl	89b0 <_Z7strncpyPcPKci>
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:170
    strncpy(fname + sizeof(Pipe_File_Prefix), name, sizeof(fname) - sizeof(Pipe_File_Prefix) - 1);
    8718:	e24b3048 	sub	r3, fp, #72	; 0x48
    871c:	e283300a 	add	r3, r3, #10
    8720:	e3a02035 	mov	r2, #53	; 0x35
    8724:	e51b1050 	ldr	r1, [fp, #-80]	; 0xffffffb0
    8728:	e1a00003 	mov	r0, r3
    872c:	eb00009f 	bl	89b0 <_Z7strncpyPcPKci>
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:172

    int ncur = sizeof(Pipe_File_Prefix) + strlen(name);
    8730:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    8734:	eb0000f8 	bl	8b1c <_Z6strlenPKc>
    8738:	e1a03000 	mov	r3, r0
    873c:	e283300a 	add	r3, r3, #10
    8740:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:174

    fname[ncur++] = '#';
    8744:	e51b3008 	ldr	r3, [fp, #-8]
    8748:	e2832001 	add	r2, r3, #1
    874c:	e50b2008 	str	r2, [fp, #-8]
    8750:	e24b2004 	sub	r2, fp, #4
    8754:	e0823003 	add	r3, r2, r3
    8758:	e3a02023 	mov	r2, #35	; 0x23
    875c:	e5432044 	strb	r2, [r3, #-68]	; 0xffffffbc
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:176

    itoa(buf_size, &fname[ncur], 10);
    8760:	e24b2048 	sub	r2, fp, #72	; 0x48
    8764:	e51b3008 	ldr	r3, [fp, #-8]
    8768:	e0823003 	add	r3, r2, r3
    876c:	e3a0200a 	mov	r2, #10
    8770:	e1a01003 	mov	r1, r3
    8774:	e51b0054 	ldr	r0, [fp, #-84]	; 0xffffffac
    8778:	eb000008 	bl	87a0 <_Z4itoajPcj>
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:178

    return open(fname, NFile_Open_Mode::Read_Write);
    877c:	e24b3048 	sub	r3, fp, #72	; 0x48
    8780:	e3a01002 	mov	r1, #2
    8784:	e1a00003 	mov	r0, r3
    8788:	ebffff0a 	bl	83b8 <_Z4openPKc15NFile_Open_Mode>
    878c:	e1a03000 	mov	r3, r0
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:179
}
    8790:	e1a00003 	mov	r0, r3
    8794:	e24bd004 	sub	sp, fp, #4
    8798:	e8bd8800 	pop	{fp, pc}
    879c:	0000945c 	andeq	r9, r0, ip, asr r4

000087a0 <_Z4itoajPcj>:
_Z4itoajPcj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:9
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(unsigned int input, char* output, unsigned int base)
{
    87a0:	e92d4800 	push	{fp, lr}
    87a4:	e28db004 	add	fp, sp, #4
    87a8:	e24dd020 	sub	sp, sp, #32
    87ac:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    87b0:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    87b4:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:10
	int i = 0;
    87b8:	e3a03000 	mov	r3, #0
    87bc:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:12

	while (input > 0)
    87c0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    87c4:	e3530000 	cmp	r3, #0
    87c8:	0a000014 	beq	8820 <_Z4itoajPcj+0x80>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:14
	{
		output[i] = CharConvArr[input % base];
    87cc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    87d0:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    87d4:	e1a00003 	mov	r0, r3
    87d8:	eb0002c6 	bl	92f8 <__aeabi_uidivmod>
    87dc:	e1a03001 	mov	r3, r1
    87e0:	e1a01003 	mov	r1, r3
    87e4:	e51b3008 	ldr	r3, [fp, #-8]
    87e8:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    87ec:	e0823003 	add	r3, r2, r3
    87f0:	e59f2118 	ldr	r2, [pc, #280]	; 8910 <_Z4itoajPcj+0x170>
    87f4:	e7d22001 	ldrb	r2, [r2, r1]
    87f8:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:15
		input /= base;
    87fc:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    8800:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8804:	eb000240 	bl	910c <__udivsi3>
    8808:	e1a03000 	mov	r3, r0
    880c:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:16
		i++;
    8810:	e51b3008 	ldr	r3, [fp, #-8]
    8814:	e2833001 	add	r3, r3, #1
    8818:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:12
	while (input > 0)
    881c:	eaffffe7 	b	87c0 <_Z4itoajPcj+0x20>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:19
	}

    if (i == 0)
    8820:	e51b3008 	ldr	r3, [fp, #-8]
    8824:	e3530000 	cmp	r3, #0
    8828:	1a000007 	bne	884c <_Z4itoajPcj+0xac>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:21
    {
        output[i] = CharConvArr[0];
    882c:	e51b3008 	ldr	r3, [fp, #-8]
    8830:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8834:	e0823003 	add	r3, r2, r3
    8838:	e3a02030 	mov	r2, #48	; 0x30
    883c:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:22
        i++;
    8840:	e51b3008 	ldr	r3, [fp, #-8]
    8844:	e2833001 	add	r3, r3, #1
    8848:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:25
    }

	output[i] = '\0';
    884c:	e51b3008 	ldr	r3, [fp, #-8]
    8850:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8854:	e0823003 	add	r3, r2, r3
    8858:	e3a02000 	mov	r2, #0
    885c:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:26
	i--;
    8860:	e51b3008 	ldr	r3, [fp, #-8]
    8864:	e2433001 	sub	r3, r3, #1
    8868:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:28

	for (int j = 0; j <= i/2; j++)
    886c:	e3a03000 	mov	r3, #0
    8870:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:28 (discriminator 3)
    8874:	e51b3008 	ldr	r3, [fp, #-8]
    8878:	e1a02fa3 	lsr	r2, r3, #31
    887c:	e0823003 	add	r3, r2, r3
    8880:	e1a030c3 	asr	r3, r3, #1
    8884:	e1a02003 	mov	r2, r3
    8888:	e51b300c 	ldr	r3, [fp, #-12]
    888c:	e1530002 	cmp	r3, r2
    8890:	ca00001b 	bgt	8904 <_Z4itoajPcj+0x164>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:30 (discriminator 2)
	{
		char c = output[i - j];
    8894:	e51b2008 	ldr	r2, [fp, #-8]
    8898:	e51b300c 	ldr	r3, [fp, #-12]
    889c:	e0423003 	sub	r3, r2, r3
    88a0:	e1a02003 	mov	r2, r3
    88a4:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    88a8:	e0833002 	add	r3, r3, r2
    88ac:	e5d33000 	ldrb	r3, [r3]
    88b0:	e54b300d 	strb	r3, [fp, #-13]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:31 (discriminator 2)
		output[i - j] = output[j];
    88b4:	e51b300c 	ldr	r3, [fp, #-12]
    88b8:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    88bc:	e0822003 	add	r2, r2, r3
    88c0:	e51b1008 	ldr	r1, [fp, #-8]
    88c4:	e51b300c 	ldr	r3, [fp, #-12]
    88c8:	e0413003 	sub	r3, r1, r3
    88cc:	e1a01003 	mov	r1, r3
    88d0:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    88d4:	e0833001 	add	r3, r3, r1
    88d8:	e5d22000 	ldrb	r2, [r2]
    88dc:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:32 (discriminator 2)
		output[j] = c;
    88e0:	e51b300c 	ldr	r3, [fp, #-12]
    88e4:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    88e8:	e0823003 	add	r3, r2, r3
    88ec:	e55b200d 	ldrb	r2, [fp, #-13]
    88f0:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:28 (discriminator 2)
	for (int j = 0; j <= i/2; j++)
    88f4:	e51b300c 	ldr	r3, [fp, #-12]
    88f8:	e2833001 	add	r3, r3, #1
    88fc:	e50b300c 	str	r3, [fp, #-12]
    8900:	eaffffdb 	b	8874 <_Z4itoajPcj+0xd4>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:34
	}
}
    8904:	e320f000 	nop	{0}
    8908:	e24bd004 	sub	sp, fp, #4
    890c:	e8bd8800 	pop	{fp, pc}
    8910:	00009468 	andeq	r9, r0, r8, ror #8

00008914 <_Z4atoiPKc>:
_Z4atoiPKc():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:37

int atoi(const char* input)
{
    8914:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8918:	e28db000 	add	fp, sp, #0
    891c:	e24dd014 	sub	sp, sp, #20
    8920:	e50b0010 	str	r0, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:38
	int output = 0;
    8924:	e3a03000 	mov	r3, #0
    8928:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:40

	while (*input != '\0')
    892c:	e51b3010 	ldr	r3, [fp, #-16]
    8930:	e5d33000 	ldrb	r3, [r3]
    8934:	e3530000 	cmp	r3, #0
    8938:	0a000017 	beq	899c <_Z4atoiPKc+0x88>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:42
	{
		output *= 10;
    893c:	e51b2008 	ldr	r2, [fp, #-8]
    8940:	e1a03002 	mov	r3, r2
    8944:	e1a03103 	lsl	r3, r3, #2
    8948:	e0833002 	add	r3, r3, r2
    894c:	e1a03083 	lsl	r3, r3, #1
    8950:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:43
		if (*input > '9' || *input < '0')
    8954:	e51b3010 	ldr	r3, [fp, #-16]
    8958:	e5d33000 	ldrb	r3, [r3]
    895c:	e3530039 	cmp	r3, #57	; 0x39
    8960:	8a00000d 	bhi	899c <_Z4atoiPKc+0x88>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:43 (discriminator 1)
    8964:	e51b3010 	ldr	r3, [fp, #-16]
    8968:	e5d33000 	ldrb	r3, [r3]
    896c:	e353002f 	cmp	r3, #47	; 0x2f
    8970:	9a000009 	bls	899c <_Z4atoiPKc+0x88>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:46
			break;

		output += *input - '0';
    8974:	e51b3010 	ldr	r3, [fp, #-16]
    8978:	e5d33000 	ldrb	r3, [r3]
    897c:	e2433030 	sub	r3, r3, #48	; 0x30
    8980:	e51b2008 	ldr	r2, [fp, #-8]
    8984:	e0823003 	add	r3, r2, r3
    8988:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:48

		input++;
    898c:	e51b3010 	ldr	r3, [fp, #-16]
    8990:	e2833001 	add	r3, r3, #1
    8994:	e50b3010 	str	r3, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:40
	while (*input != '\0')
    8998:	eaffffe3 	b	892c <_Z4atoiPKc+0x18>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:51
	}

	return output;
    899c:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:52
}
    89a0:	e1a00003 	mov	r0, r3
    89a4:	e28bd000 	add	sp, fp, #0
    89a8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    89ac:	e12fff1e 	bx	lr

000089b0 <_Z7strncpyPcPKci>:
_Z7strncpyPcPKci():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:55

char* strncpy(char* dest, const char *src, int num)
{
    89b0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    89b4:	e28db000 	add	fp, sp, #0
    89b8:	e24dd01c 	sub	sp, sp, #28
    89bc:	e50b0010 	str	r0, [fp, #-16]
    89c0:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    89c4:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:58
	int i;

	for (i = 0; i < num && src[i] != '\0'; i++)
    89c8:	e3a03000 	mov	r3, #0
    89cc:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:58 (discriminator 4)
    89d0:	e51b2008 	ldr	r2, [fp, #-8]
    89d4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    89d8:	e1520003 	cmp	r2, r3
    89dc:	aa000011 	bge	8a28 <_Z7strncpyPcPKci+0x78>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:58 (discriminator 2)
    89e0:	e51b3008 	ldr	r3, [fp, #-8]
    89e4:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    89e8:	e0823003 	add	r3, r2, r3
    89ec:	e5d33000 	ldrb	r3, [r3]
    89f0:	e3530000 	cmp	r3, #0
    89f4:	0a00000b 	beq	8a28 <_Z7strncpyPcPKci+0x78>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:59 (discriminator 3)
		dest[i] = src[i];
    89f8:	e51b3008 	ldr	r3, [fp, #-8]
    89fc:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8a00:	e0822003 	add	r2, r2, r3
    8a04:	e51b3008 	ldr	r3, [fp, #-8]
    8a08:	e51b1010 	ldr	r1, [fp, #-16]
    8a0c:	e0813003 	add	r3, r1, r3
    8a10:	e5d22000 	ldrb	r2, [r2]
    8a14:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:58 (discriminator 3)
	for (i = 0; i < num && src[i] != '\0'; i++)
    8a18:	e51b3008 	ldr	r3, [fp, #-8]
    8a1c:	e2833001 	add	r3, r3, #1
    8a20:	e50b3008 	str	r3, [fp, #-8]
    8a24:	eaffffe9 	b	89d0 <_Z7strncpyPcPKci+0x20>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:60 (discriminator 2)
	for (; i < num; i++)
    8a28:	e51b2008 	ldr	r2, [fp, #-8]
    8a2c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8a30:	e1520003 	cmp	r2, r3
    8a34:	aa000008 	bge	8a5c <_Z7strncpyPcPKci+0xac>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:61 (discriminator 1)
		dest[i] = '\0';
    8a38:	e51b3008 	ldr	r3, [fp, #-8]
    8a3c:	e51b2010 	ldr	r2, [fp, #-16]
    8a40:	e0823003 	add	r3, r2, r3
    8a44:	e3a02000 	mov	r2, #0
    8a48:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:60 (discriminator 1)
	for (; i < num; i++)
    8a4c:	e51b3008 	ldr	r3, [fp, #-8]
    8a50:	e2833001 	add	r3, r3, #1
    8a54:	e50b3008 	str	r3, [fp, #-8]
    8a58:	eafffff2 	b	8a28 <_Z7strncpyPcPKci+0x78>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:63

   return dest;
    8a5c:	e51b3010 	ldr	r3, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:64
}
    8a60:	e1a00003 	mov	r0, r3
    8a64:	e28bd000 	add	sp, fp, #0
    8a68:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8a6c:	e12fff1e 	bx	lr

00008a70 <_Z7strncmpPKcS0_i>:
_Z7strncmpPKcS0_i():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:67

int strncmp(const char *s1, const char *s2, int num)
{
    8a70:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8a74:	e28db000 	add	fp, sp, #0
    8a78:	e24dd01c 	sub	sp, sp, #28
    8a7c:	e50b0010 	str	r0, [fp, #-16]
    8a80:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8a84:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:69
	unsigned char u1, u2;
  	while (num-- > 0)
    8a88:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8a8c:	e2432001 	sub	r2, r3, #1
    8a90:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    8a94:	e3530000 	cmp	r3, #0
    8a98:	c3a03001 	movgt	r3, #1
    8a9c:	d3a03000 	movle	r3, #0
    8aa0:	e6ef3073 	uxtb	r3, r3
    8aa4:	e3530000 	cmp	r3, #0
    8aa8:	0a000016 	beq	8b08 <_Z7strncmpPKcS0_i+0x98>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:71
    {
      	u1 = (unsigned char) *s1++;
    8aac:	e51b3010 	ldr	r3, [fp, #-16]
    8ab0:	e2832001 	add	r2, r3, #1
    8ab4:	e50b2010 	str	r2, [fp, #-16]
    8ab8:	e5d33000 	ldrb	r3, [r3]
    8abc:	e54b3005 	strb	r3, [fp, #-5]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:72
     	u2 = (unsigned char) *s2++;
    8ac0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8ac4:	e2832001 	add	r2, r3, #1
    8ac8:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    8acc:	e5d33000 	ldrb	r3, [r3]
    8ad0:	e54b3006 	strb	r3, [fp, #-6]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:73
      	if (u1 != u2)
    8ad4:	e55b2005 	ldrb	r2, [fp, #-5]
    8ad8:	e55b3006 	ldrb	r3, [fp, #-6]
    8adc:	e1520003 	cmp	r2, r3
    8ae0:	0a000003 	beq	8af4 <_Z7strncmpPKcS0_i+0x84>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:74
        	return u1 - u2;
    8ae4:	e55b2005 	ldrb	r2, [fp, #-5]
    8ae8:	e55b3006 	ldrb	r3, [fp, #-6]
    8aec:	e0423003 	sub	r3, r2, r3
    8af0:	ea000005 	b	8b0c <_Z7strncmpPKcS0_i+0x9c>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:75
      	if (u1 == '\0')
    8af4:	e55b3005 	ldrb	r3, [fp, #-5]
    8af8:	e3530000 	cmp	r3, #0
    8afc:	1affffe1 	bne	8a88 <_Z7strncmpPKcS0_i+0x18>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:76
        	return 0;
    8b00:	e3a03000 	mov	r3, #0
    8b04:	ea000000 	b	8b0c <_Z7strncmpPKcS0_i+0x9c>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:79
    }

  	return 0;
    8b08:	e3a03000 	mov	r3, #0
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:80
}
    8b0c:	e1a00003 	mov	r0, r3
    8b10:	e28bd000 	add	sp, fp, #0
    8b14:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8b18:	e12fff1e 	bx	lr

00008b1c <_Z6strlenPKc>:
_Z6strlenPKc():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:83

int strlen(const char* s)
{
    8b1c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8b20:	e28db000 	add	fp, sp, #0
    8b24:	e24dd014 	sub	sp, sp, #20
    8b28:	e50b0010 	str	r0, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:84
	int i = 0;
    8b2c:	e3a03000 	mov	r3, #0
    8b30:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:86

	while (s[i] != '\0')
    8b34:	e51b3008 	ldr	r3, [fp, #-8]
    8b38:	e51b2010 	ldr	r2, [fp, #-16]
    8b3c:	e0823003 	add	r3, r2, r3
    8b40:	e5d33000 	ldrb	r3, [r3]
    8b44:	e3530000 	cmp	r3, #0
    8b48:	0a000003 	beq	8b5c <_Z6strlenPKc+0x40>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:87
		i++;
    8b4c:	e51b3008 	ldr	r3, [fp, #-8]
    8b50:	e2833001 	add	r3, r3, #1
    8b54:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:86
	while (s[i] != '\0')
    8b58:	eafffff5 	b	8b34 <_Z6strlenPKc+0x18>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:89

	return i;
    8b5c:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:90
}
    8b60:	e1a00003 	mov	r0, r3
    8b64:	e28bd000 	add	sp, fp, #0
    8b68:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8b6c:	e12fff1e 	bx	lr

00008b70 <_Z5bzeroPvi>:
_Z5bzeroPvi():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:93

void bzero(void* memory, int length)
{
    8b70:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8b74:	e28db000 	add	fp, sp, #0
    8b78:	e24dd014 	sub	sp, sp, #20
    8b7c:	e50b0010 	str	r0, [fp, #-16]
    8b80:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:94
	char* mem = reinterpret_cast<char*>(memory);
    8b84:	e51b3010 	ldr	r3, [fp, #-16]
    8b88:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:96

	for (int i = 0; i < length; i++)
    8b8c:	e3a03000 	mov	r3, #0
    8b90:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:96 (discriminator 3)
    8b94:	e51b2008 	ldr	r2, [fp, #-8]
    8b98:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8b9c:	e1520003 	cmp	r2, r3
    8ba0:	aa000008 	bge	8bc8 <_Z5bzeroPvi+0x58>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:97 (discriminator 2)
		mem[i] = 0;
    8ba4:	e51b3008 	ldr	r3, [fp, #-8]
    8ba8:	e51b200c 	ldr	r2, [fp, #-12]
    8bac:	e0823003 	add	r3, r2, r3
    8bb0:	e3a02000 	mov	r2, #0
    8bb4:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:96 (discriminator 2)
	for (int i = 0; i < length; i++)
    8bb8:	e51b3008 	ldr	r3, [fp, #-8]
    8bbc:	e2833001 	add	r3, r3, #1
    8bc0:	e50b3008 	str	r3, [fp, #-8]
    8bc4:	eafffff2 	b	8b94 <_Z5bzeroPvi+0x24>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:98
}
    8bc8:	e320f000 	nop	{0}
    8bcc:	e28bd000 	add	sp, fp, #0
    8bd0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8bd4:	e12fff1e 	bx	lr

00008bd8 <_Z6memcpyPKvPvi>:
_Z6memcpyPKvPvi():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:101

void memcpy(const void* src, void* dst, int num)
{
    8bd8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8bdc:	e28db000 	add	fp, sp, #0
    8be0:	e24dd024 	sub	sp, sp, #36	; 0x24
    8be4:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8be8:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8bec:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:102
	const char* memsrc = reinterpret_cast<const char*>(src);
    8bf0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8bf4:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:103
	char* memdst = reinterpret_cast<char*>(dst);
    8bf8:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8bfc:	e50b3010 	str	r3, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:105

	for (int i = 0; i < num; i++)
    8c00:	e3a03000 	mov	r3, #0
    8c04:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:105 (discriminator 3)
    8c08:	e51b2008 	ldr	r2, [fp, #-8]
    8c0c:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8c10:	e1520003 	cmp	r2, r3
    8c14:	aa00000b 	bge	8c48 <_Z6memcpyPKvPvi+0x70>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:106 (discriminator 2)
		memdst[i] = memsrc[i];
    8c18:	e51b3008 	ldr	r3, [fp, #-8]
    8c1c:	e51b200c 	ldr	r2, [fp, #-12]
    8c20:	e0822003 	add	r2, r2, r3
    8c24:	e51b3008 	ldr	r3, [fp, #-8]
    8c28:	e51b1010 	ldr	r1, [fp, #-16]
    8c2c:	e0813003 	add	r3, r1, r3
    8c30:	e5d22000 	ldrb	r2, [r2]
    8c34:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:105 (discriminator 2)
	for (int i = 0; i < num; i++)
    8c38:	e51b3008 	ldr	r3, [fp, #-8]
    8c3c:	e2833001 	add	r3, r3, #1
    8c40:	e50b3008 	str	r3, [fp, #-8]
    8c44:	eaffffef 	b	8c08 <_Z6memcpyPKvPvi+0x30>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:107
}
    8c48:	e320f000 	nop	{0}
    8c4c:	e28bd000 	add	sp, fp, #0
    8c50:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8c54:	e12fff1e 	bx	lr

00008c58 <_ZN13COLED_DisplayC1EPKc>:
_ZN13COLED_DisplayC2EPKc():
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:10
#include <drivers/bridges/display_protocol.h>

// tento soubor includujeme jen odtud
#include "oled_font.h"

COLED_Display::COLED_Display(const char* path)
    8c58:	e92d4800 	push	{fp, lr}
    8c5c:	e28db004 	add	fp, sp, #4
    8c60:	e24dd008 	sub	sp, sp, #8
    8c64:	e50b0008 	str	r0, [fp, #-8]
    8c68:	e50b100c 	str	r1, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:11
    : mHandle{ open(path, NFile_Open_Mode::Write_Only) }, mOpened(false)
    8c6c:	e3a01001 	mov	r1, #1
    8c70:	e51b000c 	ldr	r0, [fp, #-12]
    8c74:	ebfffdcf 	bl	83b8 <_Z4openPKc15NFile_Open_Mode>
    8c78:	e1a02000 	mov	r2, r0
    8c7c:	e51b3008 	ldr	r3, [fp, #-8]
    8c80:	e5832000 	str	r2, [r3]
    8c84:	e51b3008 	ldr	r3, [fp, #-8]
    8c88:	e3a02000 	mov	r2, #0
    8c8c:	e5c32004 	strb	r2, [r3, #4]
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:14
{
    // nastavime priznak dle toho, co vrati open
    mOpened = (mHandle != static_cast<uint32_t>(-1));
    8c90:	e51b3008 	ldr	r3, [fp, #-8]
    8c94:	e5933000 	ldr	r3, [r3]
    8c98:	e3730001 	cmn	r3, #1
    8c9c:	13a03001 	movne	r3, #1
    8ca0:	03a03000 	moveq	r3, #0
    8ca4:	e6ef2073 	uxtb	r2, r3
    8ca8:	e51b3008 	ldr	r3, [fp, #-8]
    8cac:	e5c32004 	strb	r2, [r3, #4]
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:15
}
    8cb0:	e51b3008 	ldr	r3, [fp, #-8]
    8cb4:	e1a00003 	mov	r0, r3
    8cb8:	e24bd004 	sub	sp, fp, #4
    8cbc:	e8bd8800 	pop	{fp, pc}

00008cc0 <_ZN13COLED_DisplayD1Ev>:
_ZN13COLED_DisplayD2Ev():
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:17

COLED_Display::~COLED_Display()
    8cc0:	e92d4800 	push	{fp, lr}
    8cc4:	e28db004 	add	fp, sp, #4
    8cc8:	e24dd008 	sub	sp, sp, #8
    8ccc:	e50b0008 	str	r0, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:20
{
    // pokud byl displej otevreny, zavreme
    if (mOpened)
    8cd0:	e51b3008 	ldr	r3, [fp, #-8]
    8cd4:	e5d33004 	ldrb	r3, [r3, #4]
    8cd8:	e3530000 	cmp	r3, #0
    8cdc:	0a000006 	beq	8cfc <_ZN13COLED_DisplayD1Ev+0x3c>
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:22
    {
        mOpened = false;
    8ce0:	e51b3008 	ldr	r3, [fp, #-8]
    8ce4:	e3a02000 	mov	r2, #0
    8ce8:	e5c32004 	strb	r2, [r3, #4]
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:23
        close(mHandle);
    8cec:	e51b3008 	ldr	r3, [fp, #-8]
    8cf0:	e5933000 	ldr	r3, [r3]
    8cf4:	e1a00003 	mov	r0, r3
    8cf8:	ebfffde7 	bl	849c <_Z5closej>
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:25
    }
}
    8cfc:	e51b3008 	ldr	r3, [fp, #-8]
    8d00:	e1a00003 	mov	r0, r3
    8d04:	e24bd004 	sub	sp, fp, #4
    8d08:	e8bd8800 	pop	{fp, pc}

00008d0c <_ZNK13COLED_Display9Is_OpenedEv>:
_ZNK13COLED_Display9Is_OpenedEv():
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:28

bool COLED_Display::Is_Opened() const
{
    8d0c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8d10:	e28db000 	add	fp, sp, #0
    8d14:	e24dd00c 	sub	sp, sp, #12
    8d18:	e50b0008 	str	r0, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:29
    return mOpened;
    8d1c:	e51b3008 	ldr	r3, [fp, #-8]
    8d20:	e5d33004 	ldrb	r3, [r3, #4]
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:30
}
    8d24:	e1a00003 	mov	r0, r3
    8d28:	e28bd000 	add	sp, fp, #0
    8d2c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8d30:	e12fff1e 	bx	lr

00008d34 <_ZN13COLED_Display5ClearEb>:
_ZN13COLED_Display5ClearEb():
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:33

void COLED_Display::Clear(bool clearSet)
{
    8d34:	e92d4800 	push	{fp, lr}
    8d38:	e28db004 	add	fp, sp, #4
    8d3c:	e24dd010 	sub	sp, sp, #16
    8d40:	e50b0010 	str	r0, [fp, #-16]
    8d44:	e1a03001 	mov	r3, r1
    8d48:	e54b3011 	strb	r3, [fp, #-17]	; 0xffffffef
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:34
    if (!mOpened)
    8d4c:	e51b3010 	ldr	r3, [fp, #-16]
    8d50:	e5d33004 	ldrb	r3, [r3, #4]
    8d54:	e2233001 	eor	r3, r3, #1
    8d58:	e6ef3073 	uxtb	r3, r3
    8d5c:	e3530000 	cmp	r3, #0
    8d60:	1a00000f 	bne	8da4 <_ZN13COLED_Display5ClearEb+0x70>
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:38
        return;

    TDisplay_Clear_Packet pkt;
	pkt.header.cmd = NDisplay_Command::Clear;
    8d64:	e3a03002 	mov	r3, #2
    8d68:	e54b3008 	strb	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:39
	pkt.clearSet = clearSet ? 1 : 0;
    8d6c:	e55b3011 	ldrb	r3, [fp, #-17]	; 0xffffffef
    8d70:	e3530000 	cmp	r3, #0
    8d74:	0a000001 	beq	8d80 <_ZN13COLED_Display5ClearEb+0x4c>
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:39 (discriminator 1)
    8d78:	e3a03001 	mov	r3, #1
    8d7c:	ea000000 	b	8d84 <_ZN13COLED_Display5ClearEb+0x50>
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:39 (discriminator 2)
    8d80:	e3a03000 	mov	r3, #0
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:39 (discriminator 4)
    8d84:	e54b3007 	strb	r3, [fp, #-7]
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:40 (discriminator 4)
	write(mHandle, reinterpret_cast<char*>(&pkt), sizeof(pkt));
    8d88:	e51b3010 	ldr	r3, [fp, #-16]
    8d8c:	e5933000 	ldr	r3, [r3]
    8d90:	e24b1008 	sub	r1, fp, #8
    8d94:	e3a02002 	mov	r2, #2
    8d98:	e1a00003 	mov	r0, r3
    8d9c:	ebfffdaa 	bl	844c <_Z5writejPKcj>
    8da0:	ea000000 	b	8da8 <_ZN13COLED_Display5ClearEb+0x74>
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:35
        return;
    8da4:	e320f000 	nop	{0}
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:41
}
    8da8:	e24bd004 	sub	sp, fp, #4
    8dac:	e8bd8800 	pop	{fp, pc}

00008db0 <_ZN13COLED_Display9Set_PixelEttb>:
_ZN13COLED_Display9Set_PixelEttb():
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:44

void COLED_Display::Set_Pixel(uint16_t x, uint16_t y, bool set)
{
    8db0:	e92d4800 	push	{fp, lr}
    8db4:	e28db004 	add	fp, sp, #4
    8db8:	e24dd018 	sub	sp, sp, #24
    8dbc:	e50b0010 	str	r0, [fp, #-16]
    8dc0:	e1a00001 	mov	r0, r1
    8dc4:	e1a01002 	mov	r1, r2
    8dc8:	e1a02003 	mov	r2, r3
    8dcc:	e1a03000 	mov	r3, r0
    8dd0:	e14b31b2 	strh	r3, [fp, #-18]	; 0xffffffee
    8dd4:	e1a03001 	mov	r3, r1
    8dd8:	e14b31b4 	strh	r3, [fp, #-20]	; 0xffffffec
    8ddc:	e1a03002 	mov	r3, r2
    8de0:	e54b3015 	strb	r3, [fp, #-21]	; 0xffffffeb
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:45
    if (!mOpened)
    8de4:	e51b3010 	ldr	r3, [fp, #-16]
    8de8:	e5d33004 	ldrb	r3, [r3, #4]
    8dec:	e2233001 	eor	r3, r3, #1
    8df0:	e6ef3073 	uxtb	r3, r3
    8df4:	e3530000 	cmp	r3, #0
    8df8:	1a000024 	bne	8e90 <_ZN13COLED_Display9Set_PixelEttb+0xe0>
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:50
        return;

    // nehospodarny zpusob, jak nastavit pixely, ale pro ted staci
    TDisplay_Draw_Pixel_Array_Packet pkt;
    pkt.header.cmd = NDisplay_Command::Draw_Pixel_Array;
    8dfc:	e3a03003 	mov	r3, #3
    8e00:	e54b300c 	strb	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:51
    pkt.count = 1;
    8e04:	e3a03000 	mov	r3, #0
    8e08:	e3833001 	orr	r3, r3, #1
    8e0c:	e54b300b 	strb	r3, [fp, #-11]
    8e10:	e3a03000 	mov	r3, #0
    8e14:	e54b300a 	strb	r3, [fp, #-10]
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:52
    pkt.first.x = x;
    8e18:	e55b3012 	ldrb	r3, [fp, #-18]	; 0xffffffee
    8e1c:	e3a02000 	mov	r2, #0
    8e20:	e1823003 	orr	r3, r2, r3
    8e24:	e54b3009 	strb	r3, [fp, #-9]
    8e28:	e55b3011 	ldrb	r3, [fp, #-17]	; 0xffffffef
    8e2c:	e3a02000 	mov	r2, #0
    8e30:	e1823003 	orr	r3, r2, r3
    8e34:	e54b3008 	strb	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:53
    pkt.first.y = y;
    8e38:	e55b3014 	ldrb	r3, [fp, #-20]	; 0xffffffec
    8e3c:	e3a02000 	mov	r2, #0
    8e40:	e1823003 	orr	r3, r2, r3
    8e44:	e54b3007 	strb	r3, [fp, #-7]
    8e48:	e55b3013 	ldrb	r3, [fp, #-19]	; 0xffffffed
    8e4c:	e3a02000 	mov	r2, #0
    8e50:	e1823003 	orr	r3, r2, r3
    8e54:	e54b3006 	strb	r3, [fp, #-6]
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:54
    pkt.first.set = set ? 1 : 0;
    8e58:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    8e5c:	e3530000 	cmp	r3, #0
    8e60:	0a000001 	beq	8e6c <_ZN13COLED_Display9Set_PixelEttb+0xbc>
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:54 (discriminator 1)
    8e64:	e3a03001 	mov	r3, #1
    8e68:	ea000000 	b	8e70 <_ZN13COLED_Display9Set_PixelEttb+0xc0>
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:54 (discriminator 2)
    8e6c:	e3a03000 	mov	r3, #0
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:54 (discriminator 4)
    8e70:	e54b3005 	strb	r3, [fp, #-5]
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:55 (discriminator 4)
    write(mHandle, reinterpret_cast<char*>(&pkt), sizeof(pkt));
    8e74:	e51b3010 	ldr	r3, [fp, #-16]
    8e78:	e5933000 	ldr	r3, [r3]
    8e7c:	e24b100c 	sub	r1, fp, #12
    8e80:	e3a02008 	mov	r2, #8
    8e84:	e1a00003 	mov	r0, r3
    8e88:	ebfffd6f 	bl	844c <_Z5writejPKcj>
    8e8c:	ea000000 	b	8e94 <_ZN13COLED_Display9Set_PixelEttb+0xe4>
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:46
        return;
    8e90:	e320f000 	nop	{0}
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:56
}
    8e94:	e24bd004 	sub	sp, fp, #4
    8e98:	e8bd8800 	pop	{fp, pc}

00008e9c <_ZN13COLED_Display8Put_CharEttc>:
_ZN13COLED_Display8Put_CharEttc():
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:59

void COLED_Display::Put_Char(uint16_t x, uint16_t y, char c)
{
    8e9c:	e92d4800 	push	{fp, lr}
    8ea0:	e28db004 	add	fp, sp, #4
    8ea4:	e24dd028 	sub	sp, sp, #40	; 0x28
    8ea8:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
    8eac:	e1a00001 	mov	r0, r1
    8eb0:	e1a01002 	mov	r1, r2
    8eb4:	e1a02003 	mov	r2, r3
    8eb8:	e1a03000 	mov	r3, r0
    8ebc:	e14b32b2 	strh	r3, [fp, #-34]	; 0xffffffde
    8ec0:	e1a03001 	mov	r3, r1
    8ec4:	e14b32b4 	strh	r3, [fp, #-36]	; 0xffffffdc
    8ec8:	e1a03002 	mov	r3, r2
    8ecc:	e54b3025 	strb	r3, [fp, #-37]	; 0xffffffdb
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:60
    if (!mOpened)
    8ed0:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8ed4:	e5d33004 	ldrb	r3, [r3, #4]
    8ed8:	e2233001 	eor	r3, r3, #1
    8edc:	e6ef3073 	uxtb	r3, r3
    8ee0:	e3530000 	cmp	r3, #0
    8ee4:	1a000040 	bne	8fec <_ZN13COLED_Display8Put_CharEttc+0x150>
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:64
        return;

    // umime jen nektere znaky
    if (c < OLED_Font::Char_Begin || c >= OLED_Font::Char_End)
    8ee8:	e55b3025 	ldrb	r3, [fp, #-37]	; 0xffffffdb
    8eec:	e353001f 	cmp	r3, #31
    8ef0:	9a00003f 	bls	8ff4 <_ZN13COLED_Display8Put_CharEttc+0x158>
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:64 (discriminator 1)
    8ef4:	e15b32d5 	ldrsb	r3, [fp, #-37]	; 0xffffffdb
    8ef8:	e3530000 	cmp	r3, #0
    8efc:	ba00003c 	blt	8ff4 <_ZN13COLED_Display8Put_CharEttc+0x158>
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:69
        return;

    char buf[sizeof(TDisplay_Pixels_To_Rect) + OLED_Font::Char_Width];

    TDisplay_Pixels_To_Rect* ptr = reinterpret_cast<TDisplay_Pixels_To_Rect*>(buf);
    8f00:	e24b301c 	sub	r3, fp, #28
    8f04:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:70
    ptr->header.cmd = NDisplay_Command::Draw_Pixel_Array_To_Rect;
    8f08:	e51b3008 	ldr	r3, [fp, #-8]
    8f0c:	e3a02004 	mov	r2, #4
    8f10:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:71
    ptr->w = OLED_Font::Char_Width;
    8f14:	e51b3008 	ldr	r3, [fp, #-8]
    8f18:	e3a02000 	mov	r2, #0
    8f1c:	e3822006 	orr	r2, r2, #6
    8f20:	e5c32005 	strb	r2, [r3, #5]
    8f24:	e3a02000 	mov	r2, #0
    8f28:	e5c32006 	strb	r2, [r3, #6]
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:72
    ptr->h = OLED_Font::Char_Height;
    8f2c:	e51b3008 	ldr	r3, [fp, #-8]
    8f30:	e3a02000 	mov	r2, #0
    8f34:	e3822008 	orr	r2, r2, #8
    8f38:	e5c32007 	strb	r2, [r3, #7]
    8f3c:	e3a02000 	mov	r2, #0
    8f40:	e5c32008 	strb	r2, [r3, #8]
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:73
    ptr->x1 = x;
    8f44:	e51b3008 	ldr	r3, [fp, #-8]
    8f48:	e55b2022 	ldrb	r2, [fp, #-34]	; 0xffffffde
    8f4c:	e3a01000 	mov	r1, #0
    8f50:	e1812002 	orr	r2, r1, r2
    8f54:	e5c32001 	strb	r2, [r3, #1]
    8f58:	e55b2021 	ldrb	r2, [fp, #-33]	; 0xffffffdf
    8f5c:	e3a01000 	mov	r1, #0
    8f60:	e1812002 	orr	r2, r1, r2
    8f64:	e5c32002 	strb	r2, [r3, #2]
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:74
    ptr->y1 = y;
    8f68:	e51b3008 	ldr	r3, [fp, #-8]
    8f6c:	e55b2024 	ldrb	r2, [fp, #-36]	; 0xffffffdc
    8f70:	e3a01000 	mov	r1, #0
    8f74:	e1812002 	orr	r2, r1, r2
    8f78:	e5c32003 	strb	r2, [r3, #3]
    8f7c:	e55b2023 	ldrb	r2, [fp, #-35]	; 0xffffffdd
    8f80:	e3a01000 	mov	r1, #0
    8f84:	e1812002 	orr	r2, r1, r2
    8f88:	e5c32004 	strb	r2, [r3, #4]
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:75
    ptr->vflip = OLED_Font::Flip_Chars ? 1 : 0;
    8f8c:	e51b3008 	ldr	r3, [fp, #-8]
    8f90:	e3a02001 	mov	r2, #1
    8f94:	e5c32009 	strb	r2, [r3, #9]
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:77
    
    memcpy(&OLED_Font::OLED_Font_Default[OLED_Font::Char_Width * (((uint16_t)c) - OLED_Font::Char_Begin)], &ptr->first, OLED_Font::Char_Width);
    8f98:	e55b3025 	ldrb	r3, [fp, #-37]	; 0xffffffdb
    8f9c:	e2432020 	sub	r2, r3, #32
    8fa0:	e1a03002 	mov	r3, r2
    8fa4:	e1a03083 	lsl	r3, r3, #1
    8fa8:	e0833002 	add	r3, r3, r2
    8fac:	e1a03083 	lsl	r3, r3, #1
    8fb0:	e1a02003 	mov	r2, r3
    8fb4:	e59f3044 	ldr	r3, [pc, #68]	; 9000 <_ZN13COLED_Display8Put_CharEttc+0x164>
    8fb8:	e0820003 	add	r0, r2, r3
    8fbc:	e51b3008 	ldr	r3, [fp, #-8]
    8fc0:	e283300a 	add	r3, r3, #10
    8fc4:	e3a02006 	mov	r2, #6
    8fc8:	e1a01003 	mov	r1, r3
    8fcc:	ebffff01 	bl	8bd8 <_Z6memcpyPKvPvi>
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:79

    write(mHandle, buf, sizeof(buf));
    8fd0:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8fd4:	e5933000 	ldr	r3, [r3]
    8fd8:	e24b101c 	sub	r1, fp, #28
    8fdc:	e3a02011 	mov	r2, #17
    8fe0:	e1a00003 	mov	r0, r3
    8fe4:	ebfffd18 	bl	844c <_Z5writejPKcj>
    8fe8:	ea000002 	b	8ff8 <_ZN13COLED_Display8Put_CharEttc+0x15c>
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:61
        return;
    8fec:	e320f000 	nop	{0}
    8ff0:	ea000000 	b	8ff8 <_ZN13COLED_Display8Put_CharEttc+0x15c>
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:65
        return;
    8ff4:	e320f000 	nop	{0}
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:80
}
    8ff8:	e24bd004 	sub	sp, fp, #4
    8ffc:	e8bd8800 	pop	{fp, pc}
    9000:	000094e0 	andeq	r9, r0, r0, ror #9

00009004 <_ZN13COLED_Display4FlipEv>:
_ZN13COLED_Display4FlipEv():
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:83

void COLED_Display::Flip()
{
    9004:	e92d4800 	push	{fp, lr}
    9008:	e28db004 	add	fp, sp, #4
    900c:	e24dd010 	sub	sp, sp, #16
    9010:	e50b0010 	str	r0, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:84
    if (!mOpened)
    9014:	e51b3010 	ldr	r3, [fp, #-16]
    9018:	e5d33004 	ldrb	r3, [r3, #4]
    901c:	e2233001 	eor	r3, r3, #1
    9020:	e6ef3073 	uxtb	r3, r3
    9024:	e3530000 	cmp	r3, #0
    9028:	1a000008 	bne	9050 <_ZN13COLED_Display4FlipEv+0x4c>
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:88
        return;

    TDisplay_NonParametric_Packet pkt;
    pkt.header.cmd = NDisplay_Command::Flip;
    902c:	e3a03001 	mov	r3, #1
    9030:	e54b3008 	strb	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:90

    write(mHandle, reinterpret_cast<char*>(&pkt), sizeof(pkt));
    9034:	e51b3010 	ldr	r3, [fp, #-16]
    9038:	e5933000 	ldr	r3, [r3]
    903c:	e24b1008 	sub	r1, fp, #8
    9040:	e3a02001 	mov	r2, #1
    9044:	e1a00003 	mov	r0, r3
    9048:	ebfffcff 	bl	844c <_Z5writejPKcj>
    904c:	ea000000 	b	9054 <_ZN13COLED_Display4FlipEv+0x50>
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:85
        return;
    9050:	e320f000 	nop	{0}
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:91
}
    9054:	e24bd004 	sub	sp, fp, #4
    9058:	e8bd8800 	pop	{fp, pc}

0000905c <_ZN13COLED_Display10Put_StringEttPKc>:
_ZN13COLED_Display10Put_StringEttPKc():
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:94

void COLED_Display::Put_String(uint16_t x, uint16_t y, const char* str)
{
    905c:	e92d4800 	push	{fp, lr}
    9060:	e28db004 	add	fp, sp, #4
    9064:	e24dd018 	sub	sp, sp, #24
    9068:	e50b0010 	str	r0, [fp, #-16]
    906c:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
    9070:	e1a03001 	mov	r3, r1
    9074:	e14b31b2 	strh	r3, [fp, #-18]	; 0xffffffee
    9078:	e1a03002 	mov	r3, r2
    907c:	e14b31b4 	strh	r3, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:95
    if (!mOpened)
    9080:	e51b3010 	ldr	r3, [fp, #-16]
    9084:	e5d33004 	ldrb	r3, [r3, #4]
    9088:	e2233001 	eor	r3, r3, #1
    908c:	e6ef3073 	uxtb	r3, r3
    9090:	e3530000 	cmp	r3, #0
    9094:	1a000019 	bne	9100 <_ZN13COLED_Display10Put_StringEttPKc+0xa4>
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:98
        return;

    uint16_t xi = x;
    9098:	e15b31b2 	ldrh	r3, [fp, #-18]	; 0xffffffee
    909c:	e14b30b6 	strh	r3, [fp, #-6]
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:99
    const char* ptr = str;
    90a0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    90a4:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:101
    // dokud nedojdeme na konec retezce nebo dokud nejsme 64 znaku daleko (limit, kdyby nahodou se neco pokazilo)
    while (*ptr != '\0' && ptr - str < 64)
    90a8:	e51b300c 	ldr	r3, [fp, #-12]
    90ac:	e5d33000 	ldrb	r3, [r3]
    90b0:	e3530000 	cmp	r3, #0
    90b4:	0a000012 	beq	9104 <_ZN13COLED_Display10Put_StringEttPKc+0xa8>
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:101 (discriminator 1)
    90b8:	e51b200c 	ldr	r2, [fp, #-12]
    90bc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    90c0:	e0423003 	sub	r3, r2, r3
    90c4:	e353003f 	cmp	r3, #63	; 0x3f
    90c8:	ca00000d 	bgt	9104 <_ZN13COLED_Display10Put_StringEttPKc+0xa8>
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:103
    {
        Put_Char(xi, y, *ptr);
    90cc:	e51b300c 	ldr	r3, [fp, #-12]
    90d0:	e5d33000 	ldrb	r3, [r3]
    90d4:	e15b21b4 	ldrh	r2, [fp, #-20]	; 0xffffffec
    90d8:	e15b10b6 	ldrh	r1, [fp, #-6]
    90dc:	e51b0010 	ldr	r0, [fp, #-16]
    90e0:	ebffff6d 	bl	8e9c <_ZN13COLED_Display8Put_CharEttc>
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:104
        xi += OLED_Font::Char_Width;
    90e4:	e15b30b6 	ldrh	r3, [fp, #-6]
    90e8:	e2833006 	add	r3, r3, #6
    90ec:	e14b30b6 	strh	r3, [fp, #-6]
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:105
        ptr++;
    90f0:	e51b300c 	ldr	r3, [fp, #-12]
    90f4:	e2833001 	add	r3, r3, #1
    90f8:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:101
    while (*ptr != '\0' && ptr - str < 64)
    90fc:	eaffffe9 	b	90a8 <_ZN13COLED_Display10Put_StringEttPKc+0x4c>
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:96
        return;
    9100:	e320f000 	nop	{0}
/home/schenkj/os2022/sp/sources/stdutils/src/oled.cpp:107
    }
}
    9104:	e24bd004 	sub	sp, fp, #4
    9108:	e8bd8800 	pop	{fp, pc}

0000910c <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1099
    910c:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1101
    9110:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1102
    9114:	3a000074 	bcc	92ec <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1103
    9118:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1104
    911c:	9a00006b 	bls	92d0 <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1105
    9120:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1106
    9124:	0a00006c 	beq	92dc <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1108
    9128:	e16f3f10 	clz	r3, r0
    912c:	e16f2f11 	clz	r2, r1
    9130:	e0423003 	sub	r3, r2, r3
    9134:	e273301f 	rsbs	r3, r3, #31
    9138:	10833083 	addne	r3, r3, r3, lsl #1
    913c:	e3a02000 	mov	r2, #0
    9140:	108ff103 	addne	pc, pc, r3, lsl #2
    9144:	e1a00000 	nop			; (mov r0, r0)
    9148:	e1500f81 	cmp	r0, r1, lsl #31
    914c:	e0a22002 	adc	r2, r2, r2
    9150:	20400f81 	subcs	r0, r0, r1, lsl #31
    9154:	e1500f01 	cmp	r0, r1, lsl #30
    9158:	e0a22002 	adc	r2, r2, r2
    915c:	20400f01 	subcs	r0, r0, r1, lsl #30
    9160:	e1500e81 	cmp	r0, r1, lsl #29
    9164:	e0a22002 	adc	r2, r2, r2
    9168:	20400e81 	subcs	r0, r0, r1, lsl #29
    916c:	e1500e01 	cmp	r0, r1, lsl #28
    9170:	e0a22002 	adc	r2, r2, r2
    9174:	20400e01 	subcs	r0, r0, r1, lsl #28
    9178:	e1500d81 	cmp	r0, r1, lsl #27
    917c:	e0a22002 	adc	r2, r2, r2
    9180:	20400d81 	subcs	r0, r0, r1, lsl #27
    9184:	e1500d01 	cmp	r0, r1, lsl #26
    9188:	e0a22002 	adc	r2, r2, r2
    918c:	20400d01 	subcs	r0, r0, r1, lsl #26
    9190:	e1500c81 	cmp	r0, r1, lsl #25
    9194:	e0a22002 	adc	r2, r2, r2
    9198:	20400c81 	subcs	r0, r0, r1, lsl #25
    919c:	e1500c01 	cmp	r0, r1, lsl #24
    91a0:	e0a22002 	adc	r2, r2, r2
    91a4:	20400c01 	subcs	r0, r0, r1, lsl #24
    91a8:	e1500b81 	cmp	r0, r1, lsl #23
    91ac:	e0a22002 	adc	r2, r2, r2
    91b0:	20400b81 	subcs	r0, r0, r1, lsl #23
    91b4:	e1500b01 	cmp	r0, r1, lsl #22
    91b8:	e0a22002 	adc	r2, r2, r2
    91bc:	20400b01 	subcs	r0, r0, r1, lsl #22
    91c0:	e1500a81 	cmp	r0, r1, lsl #21
    91c4:	e0a22002 	adc	r2, r2, r2
    91c8:	20400a81 	subcs	r0, r0, r1, lsl #21
    91cc:	e1500a01 	cmp	r0, r1, lsl #20
    91d0:	e0a22002 	adc	r2, r2, r2
    91d4:	20400a01 	subcs	r0, r0, r1, lsl #20
    91d8:	e1500981 	cmp	r0, r1, lsl #19
    91dc:	e0a22002 	adc	r2, r2, r2
    91e0:	20400981 	subcs	r0, r0, r1, lsl #19
    91e4:	e1500901 	cmp	r0, r1, lsl #18
    91e8:	e0a22002 	adc	r2, r2, r2
    91ec:	20400901 	subcs	r0, r0, r1, lsl #18
    91f0:	e1500881 	cmp	r0, r1, lsl #17
    91f4:	e0a22002 	adc	r2, r2, r2
    91f8:	20400881 	subcs	r0, r0, r1, lsl #17
    91fc:	e1500801 	cmp	r0, r1, lsl #16
    9200:	e0a22002 	adc	r2, r2, r2
    9204:	20400801 	subcs	r0, r0, r1, lsl #16
    9208:	e1500781 	cmp	r0, r1, lsl #15
    920c:	e0a22002 	adc	r2, r2, r2
    9210:	20400781 	subcs	r0, r0, r1, lsl #15
    9214:	e1500701 	cmp	r0, r1, lsl #14
    9218:	e0a22002 	adc	r2, r2, r2
    921c:	20400701 	subcs	r0, r0, r1, lsl #14
    9220:	e1500681 	cmp	r0, r1, lsl #13
    9224:	e0a22002 	adc	r2, r2, r2
    9228:	20400681 	subcs	r0, r0, r1, lsl #13
    922c:	e1500601 	cmp	r0, r1, lsl #12
    9230:	e0a22002 	adc	r2, r2, r2
    9234:	20400601 	subcs	r0, r0, r1, lsl #12
    9238:	e1500581 	cmp	r0, r1, lsl #11
    923c:	e0a22002 	adc	r2, r2, r2
    9240:	20400581 	subcs	r0, r0, r1, lsl #11
    9244:	e1500501 	cmp	r0, r1, lsl #10
    9248:	e0a22002 	adc	r2, r2, r2
    924c:	20400501 	subcs	r0, r0, r1, lsl #10
    9250:	e1500481 	cmp	r0, r1, lsl #9
    9254:	e0a22002 	adc	r2, r2, r2
    9258:	20400481 	subcs	r0, r0, r1, lsl #9
    925c:	e1500401 	cmp	r0, r1, lsl #8
    9260:	e0a22002 	adc	r2, r2, r2
    9264:	20400401 	subcs	r0, r0, r1, lsl #8
    9268:	e1500381 	cmp	r0, r1, lsl #7
    926c:	e0a22002 	adc	r2, r2, r2
    9270:	20400381 	subcs	r0, r0, r1, lsl #7
    9274:	e1500301 	cmp	r0, r1, lsl #6
    9278:	e0a22002 	adc	r2, r2, r2
    927c:	20400301 	subcs	r0, r0, r1, lsl #6
    9280:	e1500281 	cmp	r0, r1, lsl #5
    9284:	e0a22002 	adc	r2, r2, r2
    9288:	20400281 	subcs	r0, r0, r1, lsl #5
    928c:	e1500201 	cmp	r0, r1, lsl #4
    9290:	e0a22002 	adc	r2, r2, r2
    9294:	20400201 	subcs	r0, r0, r1, lsl #4
    9298:	e1500181 	cmp	r0, r1, lsl #3
    929c:	e0a22002 	adc	r2, r2, r2
    92a0:	20400181 	subcs	r0, r0, r1, lsl #3
    92a4:	e1500101 	cmp	r0, r1, lsl #2
    92a8:	e0a22002 	adc	r2, r2, r2
    92ac:	20400101 	subcs	r0, r0, r1, lsl #2
    92b0:	e1500081 	cmp	r0, r1, lsl #1
    92b4:	e0a22002 	adc	r2, r2, r2
    92b8:	20400081 	subcs	r0, r0, r1, lsl #1
    92bc:	e1500001 	cmp	r0, r1
    92c0:	e0a22002 	adc	r2, r2, r2
    92c4:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1110
    92c8:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1111
    92cc:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1114
    92d0:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1115
    92d4:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1116
    92d8:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1118
    92dc:	e16f2f11 	clz	r2, r1
    92e0:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1120
    92e4:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1121
    92e8:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1125
    92ec:	e3500000 	cmp	r0, #0
    92f0:	13e00000 	mvnne	r0, #0
    92f4:	ea000007 	b	9318 <__aeabi_idiv0>

000092f8 <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1156
    92f8:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1157
    92fc:	0afffffa 	beq	92ec <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1158
    9300:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1159
    9304:	ebffff80 	bl	910c <__udivsi3>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1160
    9308:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    930c:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    9310:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1163
    9314:	e12fff1e 	bx	lr

00009318 <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1461
    9318:	e12fff1e 	bx	lr

Disassembly of section .rodata:

0000931c <_ZL13Lock_Unlocked>:
    931c:	00000000 	andeq	r0, r0, r0

00009320 <_ZL11Lock_Locked>:
    9320:	00000001 	andeq	r0, r0, r1

00009324 <_ZL21MaxFSDriverNameLength>:
    9324:	00000010 	andeq	r0, r0, r0, lsl r0

00009328 <_ZL17MaxFilenameLength>:
    9328:	00000010 	andeq	r0, r0, r0, lsl r0

0000932c <_ZL13MaxPathLength>:
    932c:	00000080 	andeq	r0, r0, r0, lsl #1

00009330 <_ZL18NoFilesystemDriver>:
    9330:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009334 <_ZL9NotifyAll>:
    9334:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009338 <_ZL24Max_Process_Opened_Files>:
    9338:	00000010 	andeq	r0, r0, r0, lsl r0

0000933c <_ZL10Indefinite>:
    933c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009340 <_ZL18Deadline_Unchanged>:
    9340:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009344 <_ZL14Invalid_Handle>:
    9344:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009348 <_ZN3halL18Default_Clock_RateE>:
    9348:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

0000934c <_ZN3halL15Peripheral_BaseE>:
    934c:	20000000 	andcs	r0, r0, r0

00009350 <_ZN3halL9GPIO_BaseE>:
    9350:	20200000 	eorcs	r0, r0, r0

00009354 <_ZN3halL14GPIO_Pin_CountE>:
    9354:	00000036 	andeq	r0, r0, r6, lsr r0

00009358 <_ZN3halL8AUX_BaseE>:
    9358:	20215000 	eorcs	r5, r1, r0

0000935c <_ZN3halL25Interrupt_Controller_BaseE>:
    935c:	2000b200 	andcs	fp, r0, r0, lsl #4

00009360 <_ZN3halL10Timer_BaseE>:
    9360:	2000b400 	andcs	fp, r0, r0, lsl #8

00009364 <_ZN3halL9TRNG_BaseE>:
    9364:	20104000 	andscs	r4, r0, r0

00009368 <_ZN3halL9BSC0_BaseE>:
    9368:	20205000 	eorcs	r5, r0, r0

0000936c <_ZN3halL9BSC1_BaseE>:
    936c:	20804000 	addcs	r4, r0, r0

00009370 <_ZN3halL9BSC2_BaseE>:
    9370:	20805000 	addcs	r5, r0, r0

00009374 <_ZL11Invalid_Pin>:
    9374:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
    9378:	6c622049 	stclvs	0, cr2, [r2], #-292	; 0xfffffedc
    937c:	2c6b6e69 	stclcs	14, cr6, [fp], #-420	; 0xfffffe5c
    9380:	65687420 	strbvs	r7, [r8, #-1056]!	; 0xfffffbe0
    9384:	6f666572 	svcvs	0x00666572
    9388:	49206572 	stmdbmi	r0!, {r1, r4, r5, r6, r8, sl, sp, lr}
    938c:	2e6d6120 	powcsep	f6, f5, f0
    9390:	00000000 	andeq	r0, r0, r0
    9394:	65732049 	ldrbvs	r2, [r3, #-73]!	; 0xffffffb7
    9398:	65642065 	strbvs	r2, [r4, #-101]!	; 0xffffff9b
    939c:	70206461 	eorvc	r6, r0, r1, ror #8
    93a0:	6c657869 	stclvs	8, cr7, [r5], #-420	; 0xfffffe5c
    93a4:	00002e73 	andeq	r2, r0, r3, ror lr
    93a8:	20656e4f 	rsbcs	r6, r5, pc, asr #28
    93ac:	20555043 	subscs	r5, r5, r3, asr #32
    93b0:	656c7572 	strbvs	r7, [ip, #-1394]!	; 0xfffffa8e
    93b4:	68742073 	ldmdavs	r4!, {r0, r1, r4, r5, r6, sp}^
    93b8:	61206d65 			; <UNDEFINED> instruction: 0x61206d65
    93bc:	002e6c6c 	eoreq	r6, lr, ip, ror #24
    93c0:	6620794d 	strtvs	r7, [r0], -sp, asr #18
    93c4:	756f7661 	strbvc	r7, [pc, #-1633]!	; 8d6b <_ZN13COLED_Display5ClearEb+0x37>
    93c8:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
    93cc:	6f707320 	svcvs	0x00707320
    93d0:	69207472 	stmdbvs	r0!, {r1, r4, r5, r6, sl, ip, sp, lr}
    93d4:	52412073 	subpl	r2, r1, #115	; 0x73
    93d8:	7277204d 	rsbsvc	r2, r7, #77	; 0x4d
    93dc:	6c747365 	ldclvs	3, cr7, [r4], #-404	; 0xfffffe6c
    93e0:	00676e69 	rsbeq	r6, r7, r9, ror #28
    93e4:	20646c4f 	rsbcs	r6, r4, pc, asr #24
    93e8:	4463614d 	strbtmi	r6, [r3], #-333	; 0xfffffeb3
    93ec:	6c616e6f 	stclvs	14, cr6, [r1], #-444	; 0xfffffe44
    93f0:	61682064 	cmnvs	r8, r4, rrx
    93f4:	20612064 	rsbcs	r2, r1, r4, rrx
    93f8:	6d726166 	ldfvse	f6, [r2, #-408]!	; 0xfffffe68
    93fc:	4945202c 	stmdbmi	r5, {r2, r3, r5, sp}^
    9400:	00505247 	subseq	r5, r0, r7, asr #4
    9404:	3a564544 	bcc	159a91c <__bss_end+0x15911d8>
    9408:	64656c6f 	strbtvs	r6, [r5], #-3183	; 0xfffff391
    940c:	00000000 	andeq	r0, r0, r0
    9410:	2d56494b 	vldrcs.16	s9, [r6, #-150]	; 0xffffff6a	; <UNPREDICTABLE>
    9414:	534f5452 	movtpl	r5, #62546	; 0xf452
    9418:	696e6920 	stmdbvs	lr!, {r5, r8, fp, sp, lr}^
    941c:	2e2e2e74 	mcrcs	14, 1, r2, cr14, cr4, {3}
    9420:	00000000 	andeq	r0, r0, r0
    9424:	3a564544 	bcc	159a93c <__bss_end+0x15911f8>
    9428:	676e7274 			; <UNDEFINED> instruction: 0x676e7274
    942c:	00000000 	andeq	r0, r0, r0

00009430 <_ZL13Lock_Unlocked>:
    9430:	00000000 	andeq	r0, r0, r0

00009434 <_ZL11Lock_Locked>:
    9434:	00000001 	andeq	r0, r0, r1

00009438 <_ZL21MaxFSDriverNameLength>:
    9438:	00000010 	andeq	r0, r0, r0, lsl r0

0000943c <_ZL17MaxFilenameLength>:
    943c:	00000010 	andeq	r0, r0, r0, lsl r0

00009440 <_ZL13MaxPathLength>:
    9440:	00000080 	andeq	r0, r0, r0, lsl #1

00009444 <_ZL18NoFilesystemDriver>:
    9444:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009448 <_ZL9NotifyAll>:
    9448:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000944c <_ZL24Max_Process_Opened_Files>:
    944c:	00000010 	andeq	r0, r0, r0, lsl r0

00009450 <_ZL10Indefinite>:
    9450:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009454 <_ZL18Deadline_Unchanged>:
    9454:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009458 <_ZL14Invalid_Handle>:
    9458:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000945c <_ZL16Pipe_File_Prefix>:
    945c:	3a535953 	bcc	14df9b0 <__bss_end+0x14d626c>
    9460:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    9464:	0000002f 	andeq	r0, r0, pc, lsr #32

00009468 <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    9468:	33323130 	teqcc	r2, #48, 2
    946c:	37363534 			; <UNDEFINED> instruction: 0x37363534
    9470:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    9474:	46454443 	strbmi	r4, [r5], -r3, asr #8
    9478:	00000000 	andeq	r0, r0, r0

0000947c <_ZL13Lock_Unlocked>:
    947c:	00000000 	andeq	r0, r0, r0

00009480 <_ZL11Lock_Locked>:
    9480:	00000001 	andeq	r0, r0, r1

00009484 <_ZL21MaxFSDriverNameLength>:
    9484:	00000010 	andeq	r0, r0, r0, lsl r0

00009488 <_ZL17MaxFilenameLength>:
    9488:	00000010 	andeq	r0, r0, r0, lsl r0

0000948c <_ZL13MaxPathLength>:
    948c:	00000080 	andeq	r0, r0, r0, lsl #1

00009490 <_ZL18NoFilesystemDriver>:
    9490:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009494 <_ZL9NotifyAll>:
    9494:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009498 <_ZL24Max_Process_Opened_Files>:
    9498:	00000010 	andeq	r0, r0, r0, lsl r0

0000949c <_ZL10Indefinite>:
    949c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

000094a0 <_ZL18Deadline_Unchanged>:
    94a0:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

000094a4 <_ZL14Invalid_Handle>:
    94a4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

000094a8 <_ZN3halL18Default_Clock_RateE>:
    94a8:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

000094ac <_ZN3halL15Peripheral_BaseE>:
    94ac:	20000000 	andcs	r0, r0, r0

000094b0 <_ZN3halL9GPIO_BaseE>:
    94b0:	20200000 	eorcs	r0, r0, r0

000094b4 <_ZN3halL14GPIO_Pin_CountE>:
    94b4:	00000036 	andeq	r0, r0, r6, lsr r0

000094b8 <_ZN3halL8AUX_BaseE>:
    94b8:	20215000 	eorcs	r5, r1, r0

000094bc <_ZN3halL25Interrupt_Controller_BaseE>:
    94bc:	2000b200 	andcs	fp, r0, r0, lsl #4

000094c0 <_ZN3halL10Timer_BaseE>:
    94c0:	2000b400 	andcs	fp, r0, r0, lsl #8

000094c4 <_ZN3halL9TRNG_BaseE>:
    94c4:	20104000 	andscs	r4, r0, r0

000094c8 <_ZN3halL9BSC0_BaseE>:
    94c8:	20205000 	eorcs	r5, r0, r0

000094cc <_ZN3halL9BSC1_BaseE>:
    94cc:	20804000 	addcs	r4, r0, r0

000094d0 <_ZN3halL9BSC2_BaseE>:
    94d0:	20805000 	addcs	r5, r0, r0

000094d4 <_ZN9OLED_FontL10Char_WidthE>:
    94d4:	 	andeq	r0, r8, r6

000094d6 <_ZN9OLED_FontL11Char_HeightE>:
    94d6:	 	eoreq	r0, r0, r8

000094d8 <_ZN9OLED_FontL10Char_BeginE>:
    94d8:	 	addeq	r0, r0, r0, lsr #32

000094da <_ZN9OLED_FontL8Char_EndE>:
    94da:	 	andeq	r0, r1, r0, lsl #1

000094dc <_ZN9OLED_FontL10Flip_CharsE>:
    94dc:	00000001 	andeq	r0, r0, r1

000094e0 <_ZN9OLED_FontL17OLED_Font_DefaultE>:
	...
    94e8:	00002f00 	andeq	r2, r0, r0, lsl #30
    94ec:	00070000 	andeq	r0, r7, r0
    94f0:	14000007 	strne	r0, [r0], #-7
    94f4:	147f147f 	ldrbtne	r1, [pc], #-1151	; 94fc <_ZN9OLED_FontL17OLED_Font_DefaultE+0x1c>
    94f8:	7f2a2400 	svcvc	0x002a2400
    94fc:	2300122a 	movwcs	r1, #554	; 0x22a
    9500:	62640813 	rsbvs	r0, r4, #1245184	; 0x130000
    9504:	55493600 	strbpl	r3, [r9, #-1536]	; 0xfffffa00
    9508:	00005022 	andeq	r5, r0, r2, lsr #32
    950c:	00000305 	andeq	r0, r0, r5, lsl #6
    9510:	221c0000 	andscs	r0, ip, #0
    9514:	00000041 	andeq	r0, r0, r1, asr #32
    9518:	001c2241 	andseq	r2, ip, r1, asr #4
    951c:	3e081400 	cfcpyscc	mvf1, mvf8
    9520:	08001408 	stmdaeq	r0, {r3, sl, ip}
    9524:	08083e08 	stmdaeq	r8, {r3, r9, sl, fp, ip, sp}
    9528:	a0000000 	andge	r0, r0, r0
    952c:	08000060 	stmdaeq	r0, {r5, r6}
    9530:	08080808 	stmdaeq	r8, {r3, fp}
    9534:	60600000 	rsbvs	r0, r0, r0
    9538:	20000000 	andcs	r0, r0, r0
    953c:	02040810 	andeq	r0, r4, #16, 16	; 0x100000
    9540:	49513e00 	ldmdbmi	r1, {r9, sl, fp, ip, sp}^
    9544:	00003e45 	andeq	r3, r0, r5, asr #28
    9548:	00407f42 	subeq	r7, r0, r2, asr #30
    954c:	51614200 	cmnpl	r1, r0, lsl #4
    9550:	21004649 	tstcs	r0, r9, asr #12
    9554:	314b4541 	cmpcc	fp, r1, asr #10
    9558:	12141800 	andsne	r1, r4, #0, 16
    955c:	2700107f 	smlsdxcs	r0, pc, r0, r1	; <UNPREDICTABLE>
    9560:	39454545 	stmdbcc	r5, {r0, r2, r6, r8, sl, lr}^
    9564:	494a3c00 	stmdbmi	sl, {sl, fp, ip, sp}^
    9568:	01003049 	tsteq	r0, r9, asr #32
    956c:	03050971 	movweq	r0, #22897	; 0x5971
    9570:	49493600 	stmdbmi	r9, {r9, sl, ip, sp}^
    9574:	06003649 	streq	r3, [r0], -r9, asr #12
    9578:	1e294949 	vnmulne.f16	s8, s18, s18	; <UNPREDICTABLE>
    957c:	36360000 	ldrtcc	r0, [r6], -r0
    9580:	00000000 	andeq	r0, r0, r0
    9584:	00003656 	andeq	r3, r0, r6, asr r6
    9588:	22140800 	andscs	r0, r4, #0, 16
    958c:	14000041 	strne	r0, [r0], #-65	; 0xffffffbf
    9590:	14141414 	ldrne	r1, [r4], #-1044	; 0xfffffbec
    9594:	22410000 	subcs	r0, r1, #0
    9598:	02000814 	andeq	r0, r0, #20, 16	; 0x140000
    959c:	06095101 	streq	r5, [r9], -r1, lsl #2
    95a0:	59493200 	stmdbpl	r9, {r9, ip, sp}^
    95a4:	7c003e51 	stcvc	14, cr3, [r0], {81}	; 0x51
    95a8:	7c121112 	ldfvcs	f1, [r2], {18}
    95ac:	49497f00 	stmdbmi	r9, {r8, r9, sl, fp, ip, sp, lr}^
    95b0:	3e003649 	cfmadd32cc	mvax2, mvfx3, mvfx0, mvfx9
    95b4:	22414141 	subcs	r4, r1, #1073741840	; 0x40000010
    95b8:	41417f00 	cmpmi	r1, r0, lsl #30
    95bc:	7f001c22 	svcvc	0x00001c22
    95c0:	41494949 	cmpmi	r9, r9, asr #18
    95c4:	09097f00 	stmdbeq	r9, {r8, r9, sl, fp, ip, sp, lr}
    95c8:	3e000109 	adfccs	f0, f0, #1.0
    95cc:	7a494941 	bvc	125bad8 <__bss_end+0x1252394>
    95d0:	08087f00 	stmdaeq	r8, {r8, r9, sl, fp, ip, sp, lr}
    95d4:	00007f08 	andeq	r7, r0, r8, lsl #30
    95d8:	00417f41 	subeq	r7, r1, r1, asr #30
    95dc:	41402000 	mrsmi	r2, (UNDEF: 64)
    95e0:	7f00013f 	svcvc	0x0000013f
    95e4:	41221408 			; <UNDEFINED> instruction: 0x41221408
    95e8:	40407f00 	submi	r7, r0, r0, lsl #30
    95ec:	7f004040 	svcvc	0x00004040
    95f0:	7f020c02 	svcvc	0x00020c02
    95f4:	08047f00 	stmdaeq	r4, {r8, r9, sl, fp, ip, sp, lr}
    95f8:	3e007f10 	mcrcc	15, 0, r7, cr0, cr0, {0}
    95fc:	3e414141 	dvfccsm	f4, f1, f1
    9600:	09097f00 	stmdbeq	r9, {r8, r9, sl, fp, ip, sp, lr}
    9604:	3e000609 	cfmadd32cc	mvax0, mvfx0, mvfx0, mvfx9
    9608:	5e215141 	sufplsm	f5, f1, f1
    960c:	19097f00 	stmdbne	r9, {r8, r9, sl, fp, ip, sp, lr}
    9610:	46004629 	strmi	r4, [r0], -r9, lsr #12
    9614:	31494949 	cmpcc	r9, r9, asr #18
    9618:	7f010100 	svcvc	0x00010100
    961c:	3f000101 	svccc	0x00000101
    9620:	3f404040 	svccc	0x00404040
    9624:	40201f00 	eormi	r1, r0, r0, lsl #30
    9628:	3f001f20 	svccc	0x00001f20
    962c:	3f403840 	svccc	0x00403840
    9630:	08146300 	ldmdaeq	r4, {r8, r9, sp, lr}
    9634:	07006314 	smladeq	r0, r4, r3, r6
    9638:	07087008 	streq	r7, [r8, -r8]
    963c:	49516100 	ldmdbmi	r1, {r8, sp, lr}^
    9640:	00004345 	andeq	r4, r0, r5, asr #6
    9644:	0041417f 	subeq	r4, r1, pc, ror r1
    9648:	552a5500 	strpl	r5, [sl, #-1280]!	; 0xfffffb00
    964c:	0000552a 	andeq	r5, r0, sl, lsr #10
    9650:	007f4141 	rsbseq	r4, pc, r1, asr #2
    9654:	01020400 	tsteq	r2, r0, lsl #8
    9658:	40000402 	andmi	r0, r0, r2, lsl #8
    965c:	40404040 	submi	r4, r0, r0, asr #32
    9660:	02010000 	andeq	r0, r1, #0
    9664:	20000004 	andcs	r0, r0, r4
    9668:	78545454 	ldmdavc	r4, {r2, r4, r6, sl, ip, lr}^
    966c:	44487f00 	strbmi	r7, [r8], #-3840	; 0xfffff100
    9670:	38003844 	stmdacc	r0, {r2, r6, fp, ip, sp}
    9674:	20444444 	subcs	r4, r4, r4, asr #8
    9678:	44443800 	strbmi	r3, [r4], #-2048	; 0xfffff800
    967c:	38007f48 	stmdacc	r0, {r3, r6, r8, r9, sl, fp, ip, sp, lr}
    9680:	18545454 	ldmdane	r4, {r2, r4, r6, sl, ip, lr}^
    9684:	097e0800 	ldmdbeq	lr!, {fp}^
    9688:	18000201 	stmdane	r0, {r0, r9}
    968c:	7ca4a4a4 	cfstrsvc	mvf10, [r4], #656	; 0x290
    9690:	04087f00 	streq	r7, [r8], #-3840	; 0xfffff100
    9694:	00007804 	andeq	r7, r0, r4, lsl #16
    9698:	00407d44 	subeq	r7, r0, r4, asr #26
    969c:	84804000 	strhi	r4, [r0], #0
    96a0:	7f00007d 	svcvc	0x0000007d
    96a4:	00442810 	subeq	r2, r4, r0, lsl r8
    96a8:	7f410000 	svcvc	0x00410000
    96ac:	7c000040 	stcvc	0, cr0, [r0], {64}	; 0x40
    96b0:	78041804 	stmdavc	r4, {r2, fp, ip}
    96b4:	04087c00 	streq	r7, [r8], #-3072	; 0xfffff400
    96b8:	38007804 	stmdacc	r0, {r2, fp, ip, sp, lr}
    96bc:	38444444 	stmdacc	r4, {r2, r6, sl, lr}^
    96c0:	2424fc00 	strtcs	pc, [r4], #-3072	; 0xfffff400
    96c4:	18001824 	stmdane	r0, {r2, r5, fp, ip}
    96c8:	fc182424 	ldc2	4, cr2, [r8], {36}	; 0x24
    96cc:	04087c00 	streq	r7, [r8], #-3072	; 0xfffff400
    96d0:	48000804 	stmdami	r0, {r2, fp}
    96d4:	20545454 	subscs	r5, r4, r4, asr r4
    96d8:	443f0400 	ldrtmi	r0, [pc], #-1024	; 96e0 <_ZN9OLED_FontL17OLED_Font_DefaultE+0x200>
    96dc:	3c002040 	stccc	0, cr2, [r0], {64}	; 0x40
    96e0:	7c204040 	stcvc	0, cr4, [r0], #-256	; 0xffffff00
    96e4:	40201c00 	eormi	r1, r0, r0, lsl #24
    96e8:	3c001c20 	stccc	12, cr1, [r0], {32}
    96ec:	3c403040 	mcrrcc	0, 4, r3, r0, cr0
    96f0:	10284400 	eorne	r4, r8, r0, lsl #8
    96f4:	1c004428 	cfstrsne	mvf4, [r0], {40}	; 0x28
    96f8:	7ca0a0a0 	stcvc	0, cr10, [r0], #640	; 0x280
    96fc:	54644400 	strbtpl	r4, [r4], #-1024	; 0xfffffc00
    9700:	0000444c 	andeq	r4, r0, ip, asr #8
    9704:	00007708 	andeq	r7, r0, r8, lsl #14
    9708:	7f000000 	svcvc	0x00000000
    970c:	00000000 	andeq	r0, r0, r0
    9710:	00000877 	andeq	r0, r0, r7, ror r8
    9714:	10081000 	andne	r1, r8, r0
    9718:	00000008 	andeq	r0, r0, r8
    971c:	00000000 	andeq	r0, r0, r0

Disassembly of section .data:

00009720 <messages>:
__DTOR_END__():
    9720:	00009378 	andeq	r9, r0, r8, ror r3
    9724:	00009394 	muleq	r0, r4, r3
    9728:	000093a8 	andeq	r9, r0, r8, lsr #7
    972c:	000093c0 	andeq	r9, r0, r0, asr #7
    9730:	000093e4 	andeq	r9, r0, r4, ror #7

Disassembly of section .bss:

00009734 <__bss_start>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x16840e8>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x38ce0>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3c8f4>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c75e0>
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
  24:	6a6b6e65 	bvs	1adb9c0 <__bss_end+0x1ad227c>
  28:	32736f2f 	rsbscc	r6, r3, #47, 30	; 0xbc
  2c:	2f323230 	svccs	0x00323230
  30:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
  34:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
  38:	752f7365 	strvc	r7, [pc, #-869]!	; fffffcdb <__bss_end+0xffff6597>
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
  7c:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffffc8 <__bss_end+0xffff6884>
  80:	63732f65 	cmnvs	r3, #404	; 0x194
  84:	6b6e6568 	blvs	1b9962c <__bss_end+0x1b8fee8>
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
  bc:	1b050109 	blne	1404e8 <__bss_end+0x136da4>
  c0:	4a130567 	bmi	4c1664 <__bss_end+0x4b7f20>
  c4:	052f0505 	streq	r0, [pc, #-1285]!	; fffffbc7 <__bss_end+0xffff6483>
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
 104:	fb010200 	blx	4090e <__bss_end+0x371ca>
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
 168:	0b05010a 	bleq	140598 <__bss_end+0x136e54>
 16c:	4a0a0583 	bmi	281780 <__bss_end+0x27803c>
 170:	85830205 	strhi	r0, [r3, #517]	; 0x205
 174:	05830e05 	streq	r0, [r3, #3589]	; 0xe05
 178:	84856702 	strhi	r6, [r5], #1794	; 0x702
 17c:	4c860105 	stfmis	f0, [r6], {5}
 180:	4c854c85 	stcmi	12, cr4, [r5], {133}	; 0x85
 184:	00020585 	andeq	r0, r2, r5, lsl #11
 188:	4b010402 	blmi	41198 <__bss_end+0x37a54>
 18c:	12030105 	andne	r0, r3, #1073741825	; 0x40000001
 190:	6b0d052e 	blvs	341650 <__bss_end+0x337f0c>
 194:	02002405 	andeq	r2, r0, #83886080	; 0x5000000
 198:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 19c:	04020004 	streq	r0, [r2], #-4
 1a0:	0b058302 	bleq	160db0 <__bss_end+0x15766c>
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
 1e0:	00027f01 	andeq	r7, r2, r1, lsl #30
 1e4:	1d000300 	stcne	3, cr0, [r0, #-0]
 1e8:	02000002 	andeq	r0, r0, #2
 1ec:	0d0efb01 	vstreq	d15, [lr, #-4]
 1f0:	01010100 	mrseq	r0, (UNDEF: 17)
 1f4:	00000001 	andeq	r0, r0, r1
 1f8:	01000001 	tsteq	r0, r1
 1fc:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 148 <shift+0x148>
 200:	63732f65 	cmnvs	r3, #404	; 0x194
 204:	6b6e6568 	blvs	1b997ac <__bss_end+0x1b90068>
 208:	736f2f6a 	cmnvc	pc, #424	; 0x1a8
 20c:	32323032 	eorscc	r3, r2, #50	; 0x32
 210:	2f70732f 	svccs	0x0070732f
 214:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 218:	2f736563 	svccs	0x00736563
 21c:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 220:	63617073 	cmnvs	r1, #115	; 0x73
 224:	6c6f2f65 	stclvs	15, cr2, [pc], #-404	; 98 <shift+0x98>
 228:	745f6465 	ldrbvc	r6, [pc], #-1125	; 230 <shift+0x230>
 22c:	006b7361 	rsbeq	r7, fp, r1, ror #6
 230:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 17c <shift+0x17c>
 234:	63732f65 	cmnvs	r3, #404	; 0x194
 238:	6b6e6568 	blvs	1b997e0 <__bss_end+0x1b9009c>
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
 26c:	72616f62 	rsbvc	r6, r1, #392	; 0x188
 270:	70722f64 	rsbsvc	r2, r2, r4, ror #30
 274:	682f3069 	stmdavs	pc!, {r0, r3, r5, r6, ip, sp}	; <UNPREDICTABLE>
 278:	2f006c61 	svccs	0x00006c61
 27c:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 280:	6863732f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, sp, lr}^
 284:	6a6b6e65 	bvs	1adbc20 <__bss_end+0x1ad24dc>
 288:	32736f2f 	rsbscc	r6, r3, #47, 30	; 0xbc
 28c:	2f323230 	svccs	0x00323230
 290:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
 294:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 298:	752f7365 	strvc	r7, [pc, #-869]!	; ffffff3b <__bss_end+0xffff67f7>
 29c:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 2a0:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 2a4:	2f2e2e2f 	svccs	0x002e2e2f
 2a8:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 2ac:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 2b0:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 2b4:	702f6564 	eorvc	r6, pc, r4, ror #10
 2b8:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 2bc:	2f007373 	svccs	0x00007373
 2c0:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 2c4:	6863732f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, sp, lr}^
 2c8:	6a6b6e65 	bvs	1adbc64 <__bss_end+0x1ad2520>
 2cc:	32736f2f 	rsbscc	r6, r3, #47, 30	; 0xbc
 2d0:	2f323230 	svccs	0x00323230
 2d4:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
 2d8:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 2dc:	752f7365 	strvc	r7, [pc, #-869]!	; ffffff7f <__bss_end+0xffff683b>
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
 328:	732f2e2e 			; <UNDEFINED> instruction: 0x732f2e2e
 32c:	74756474 	ldrbtvc	r6, [r5], #-1140	; 0xfffffb8c
 330:	2f736c69 	svccs	0x00736c69
 334:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 338:	00656475 	rsbeq	r6, r5, r5, ror r4
 33c:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 288 <shift+0x288>
 340:	63732f65 	cmnvs	r3, #404	; 0x194
 344:	6b6e6568 	blvs	1b998ec <__bss_end+0x1b901a8>
 348:	736f2f6a 	cmnvc	pc, #424	; 0x1a8
 34c:	32323032 	eorscc	r3, r2, #50	; 0x32
 350:	2f70732f 	svccs	0x0070732f
 354:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 358:	2f736563 	svccs	0x00736563
 35c:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 360:	63617073 	cmnvs	r1, #115	; 0x73
 364:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
 368:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 36c:	2f6c656e 	svccs	0x006c656e
 370:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 374:	2f656475 	svccs	0x00656475
 378:	76697264 	strbtvc	r7, [r9], -r4, ror #4
 37c:	00737265 	rsbseq	r7, r3, r5, ror #4
 380:	69616d00 	stmdbvs	r1!, {r8, sl, fp, sp, lr}^
 384:	70632e6e 	rsbvc	r2, r3, lr, ror #28
 388:	00010070 	andeq	r0, r1, r0, ror r0
 38c:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
 390:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
 394:	00020068 	andeq	r0, r2, r8, rrx
 398:	69777300 	ldmdbvs	r7!, {r8, r9, ip, sp, lr}^
 39c:	0300682e 	movweq	r6, #2094	; 0x82e
 3a0:	70730000 	rsbsvc	r0, r3, r0
 3a4:	6f6c6e69 	svcvs	0x006c6e69
 3a8:	682e6b63 	stmdavs	lr!, {r0, r1, r5, r6, r8, r9, fp, sp, lr}
 3ac:	00000300 	andeq	r0, r0, r0, lsl #6
 3b0:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
 3b4:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
 3b8:	682e6d65 	stmdavs	lr!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}
 3bc:	00000400 	andeq	r0, r0, r0, lsl #8
 3c0:	636f7270 	cmnvs	pc, #112, 4
 3c4:	2e737365 	cdpcs	3, 7, cr7, cr3, cr5, {3}
 3c8:	00030068 	andeq	r0, r3, r8, rrx
 3cc:	6f727000 	svcvs	0x00727000
 3d0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 3d4:	6e616d5f 	mcrvs	13, 3, r6, cr1, cr15, {2}
 3d8:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
 3dc:	0300682e 	movweq	r6, #2094	; 0x82e
 3e0:	6c6f0000 	stclvs	0, cr0, [pc], #-0	; 3e8 <shift+0x3e8>
 3e4:	682e6465 	stmdavs	lr!, {r0, r2, r5, r6, sl, sp, lr}
 3e8:	00000500 	andeq	r0, r0, r0, lsl #10
 3ec:	69726570 	ldmdbvs	r2!, {r4, r5, r6, r8, sl, sp, lr}^
 3f0:	72656870 	rsbvc	r6, r5, #112, 16	; 0x700000
 3f4:	2e736c61 	cdpcs	12, 7, cr6, cr3, cr1, {3}
 3f8:	00020068 	andeq	r0, r2, r8, rrx
 3fc:	69706700 	ldmdbvs	r0!, {r8, r9, sl, sp, lr}^
 400:	00682e6f 	rsbeq	r2, r8, pc, ror #28
 404:	00000006 	andeq	r0, r0, r6
 408:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
 40c:	00823802 	addeq	r3, r2, r2, lsl #16
 410:	011a0300 	tsteq	sl, r0, lsl #6
 414:	059f1f05 	ldreq	r1, [pc, #3845]	; 1321 <shift+0x1321>
 418:	1105830c 	tstne	r5, ip, lsl #6
 41c:	9f0b0583 	svcls	0x000b0583
 420:	05681b05 	strbeq	r1, [r8, #-2821]!	; 0xfffff4fb
 424:	0705830b 	streq	r8, [r5, -fp, lsl #6]
 428:	0402004c 	streq	r0, [r2], #-76	; 0xffffffb4
 42c:	22056b01 	andcs	r6, r5, #1024	; 0x400
 430:	01040200 	mrseq	r0, R12_usr
 434:	000f059f 	muleq	pc, pc, r5	; <UNPREDICTABLE>
 438:	f2010402 	vshl.s8	d0, d2, d1
 43c:	02000d05 	andeq	r0, r0, #320	; 0x140
 440:	05680104 	strbeq	r0, [r8, #-260]!	; 0xfffffefc
 444:	04020012 	streq	r0, [r2], #-18	; 0xffffffee
 448:	0c058301 	stceq	3, cr8, [r5], {1}
 44c:	01040200 	mrseq	r0, R12_usr
 450:	0008059f 	muleq	r8, pc, r5	; <UNPREDICTABLE>
 454:	68010402 	stmdavs	r1, {r1, sl}
 458:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 45c:	02670104 	rsbeq	r0, r7, #4, 2
 460:	0101000c 	tsteq	r1, ip
 464:	0000027c 	andeq	r0, r0, ip, ror r2
 468:	01490003 	cmpeq	r9, r3
 46c:	01020000 	mrseq	r0, (UNDEF: 2)
 470:	000d0efb 	strdeq	r0, [sp], -fp
 474:	01010101 	tsteq	r1, r1, lsl #2
 478:	01000000 	mrseq	r0, (UNDEF: 0)
 47c:	2f010000 	svccs	0x00010000
 480:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 484:	6863732f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, sp, lr}^
 488:	6a6b6e65 	bvs	1adbe24 <__bss_end+0x1ad26e0>
 48c:	32736f2f 	rsbscc	r6, r3, #47, 30	; 0xbc
 490:	2f323230 	svccs	0x00323230
 494:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
 498:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 49c:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
 4a0:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
 4a4:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
 4a8:	682f0063 	stmdavs	pc!, {r0, r1, r5, r6}	; <UNPREDICTABLE>
 4ac:	2f656d6f 	svccs	0x00656d6f
 4b0:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
 4b4:	2f6a6b6e 	svccs	0x006a6b6e
 4b8:	3032736f 	eorscc	r7, r2, pc, ror #6
 4bc:	732f3232 			; <UNDEFINED> instruction: 0x732f3232
 4c0:	6f732f70 	svcvs	0x00732f70
 4c4:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 4c8:	656b2f73 	strbvs	r2, [fp, #-3955]!	; 0xfffff08d
 4cc:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 4d0:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 4d4:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 4d8:	6f72702f 	svcvs	0x0072702f
 4dc:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 4e0:	6f682f00 	svcvs	0x00682f00
 4e4:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
 4e8:	6e656863 	cdpvs	8, 6, cr6, cr5, cr3, {3}
 4ec:	6f2f6a6b 	svcvs	0x002f6a6b
 4f0:	32303273 	eorscc	r3, r0, #805306375	; 0x30000007
 4f4:	70732f32 	rsbsvc	r2, r3, r2, lsr pc
 4f8:	756f732f 	strbvc	r7, [pc, #-815]!	; 1d1 <shift+0x1d1>
 4fc:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 500:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 504:	2f6c656e 	svccs	0x006c656e
 508:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 50c:	2f656475 	svccs	0x00656475
 510:	2f007366 	svccs	0x00007366
 514:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 518:	6863732f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, sp, lr}^
 51c:	6a6b6e65 	bvs	1adbeb8 <__bss_end+0x1ad2774>
 520:	32736f2f 	rsbscc	r6, r3, #47, 30	; 0xbc
 524:	2f323230 	svccs	0x00323230
 528:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
 52c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 530:	6b2f7365 	blvs	bdd2cc <__bss_end+0xbd3b88>
 534:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 538:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 53c:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 540:	6f622f65 	svcvs	0x00622f65
 544:	2f647261 	svccs	0x00647261
 548:	30697072 	rsbcc	r7, r9, r2, ror r0
 54c:	6c61682f 	stclvs	8, cr6, [r1], #-188	; 0xffffff44
 550:	74730000 	ldrbtvc	r0, [r3], #-0
 554:	6c696664 	stclvs	6, cr6, [r9], #-400	; 0xfffffe70
 558:	70632e65 	rsbvc	r2, r3, r5, ror #28
 55c:	00010070 	andeq	r0, r1, r0, ror r0
 560:	69777300 	ldmdbvs	r7!, {r8, r9, ip, sp, lr}^
 564:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 568:	70730000 	rsbsvc	r0, r3, r0
 56c:	6f6c6e69 	svcvs	0x006c6e69
 570:	682e6b63 	stmdavs	lr!, {r0, r1, r5, r6, r8, r9, fp, sp, lr}
 574:	00000200 	andeq	r0, r0, r0, lsl #4
 578:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
 57c:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
 580:	682e6d65 	stmdavs	lr!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}
 584:	00000300 	andeq	r0, r0, r0, lsl #6
 588:	636f7270 	cmnvs	pc, #112, 4
 58c:	2e737365 	cdpcs	3, 7, cr7, cr3, cr5, {3}
 590:	00020068 	andeq	r0, r2, r8, rrx
 594:	6f727000 	svcvs	0x00727000
 598:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 59c:	6e616d5f 	mcrvs	13, 3, r6, cr1, cr15, {2}
 5a0:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
 5a4:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 5a8:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
 5ac:	66656474 			; <UNDEFINED> instruction: 0x66656474
 5b0:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
 5b4:	05000000 	streq	r0, [r0, #-0]
 5b8:	02050001 	andeq	r0, r5, #1
 5bc:	00008344 	andeq	r8, r0, r4, asr #6
 5c0:	691a0516 	ldmdbvs	sl, {r1, r2, r4, r8, sl}
 5c4:	052f2c05 	streq	r2, [pc, #-3077]!	; fffff9c7 <__bss_end+0xffff6283>
 5c8:	01054c0c 	tsteq	r5, ip, lsl #24
 5cc:	3205852f 	andcc	r8, r5, #197132288	; 0xbc00000
 5d0:	4b1a0583 	blmi	681be4 <__bss_end+0x6784a0>
 5d4:	852f0105 	strhi	r0, [pc, #-261]!	; 4d7 <shift+0x4d7>
 5d8:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
 5dc:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 5e0:	2e05a132 	mcrcs	1, 0, sl, cr5, cr2, {1}
 5e4:	4b1b054b 	blmi	6c1b18 <__bss_end+0x6b83d4>
 5e8:	052f2d05 	streq	r2, [pc, #-3333]!	; fffff8eb <__bss_end+0xffff61a7>
 5ec:	01054c0c 	tsteq	r5, ip, lsl #24
 5f0:	2e05852f 	cfsh32cs	mvfx8, mvfx5, #31
 5f4:	4b3005bd 	blmi	c01cf0 <__bss_end+0xbf85ac>
 5f8:	054b2e05 	strbeq	r2, [fp, #-3589]	; 0xfffff1fb
 5fc:	2e054b1b 	vmovcs.32	d5[0], r4
 600:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 604:	852f0105 	strhi	r0, [pc, #-261]!	; 507 <shift+0x507>
 608:	05bd2e05 	ldreq	r2, [sp, #3589]!	; 0xe05
 60c:	2e054b30 	vmovcs.16	d5[0], r4
 610:	4b1b054b 	blmi	6c1b44 <__bss_end+0x6b8400>
 614:	052f2e05 	streq	r2, [pc, #-3589]!	; fffff817 <__bss_end+0xffff60d3>
 618:	01054c0c 	tsteq	r5, ip, lsl #24
 61c:	2e05852f 	cfsh32cs	mvfx8, mvfx5, #31
 620:	4b1b0583 	blmi	6c1c34 <__bss_end+0x6b84f0>
 624:	852f0105 	strhi	r0, [pc, #-261]!	; 527 <shift+0x527>
 628:	05bd2e05 	ldreq	r2, [sp, #3589]!	; 0xe05
 62c:	2f054b33 	svccs	0x00054b33
 630:	4b1b054b 	blmi	6c1b64 <__bss_end+0x6b8420>
 634:	052f3005 	streq	r3, [pc, #-5]!	; 637 <shift+0x637>
 638:	01054c0c 	tsteq	r5, ip, lsl #24
 63c:	2e05852f 	cfsh32cs	mvfx8, mvfx5, #31
 640:	4b2f05a1 	blmi	bc1ccc <__bss_end+0xbb8588>
 644:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
 648:	0c052f2f 	stceq	15, cr2, [r5], {47}	; 0x2f
 64c:	2f01054c 	svccs	0x0001054c
 650:	bd2e0585 	cfstr32lt	mvfx0, [lr, #-532]!	; 0xfffffdec
 654:	054b2f05 	strbeq	r2, [fp, #-3845]	; 0xfffff0fb
 658:	1b054b3b 	blne	15334c <__bss_end+0x149c08>
 65c:	2f30054b 	svccs	0x0030054b
 660:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 664:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 668:	3b05a12f 	blcc	168b2c <__bss_end+0x15f3e8>
 66c:	4b1a054b 	blmi	681ba0 <__bss_end+0x67845c>
 670:	052f3005 	streq	r3, [pc, #-5]!	; 673 <shift+0x673>
 674:	01054c0c 	tsteq	r5, ip, lsl #24
 678:	2005859f 	mulcs	r5, pc, r5	; <UNPREDICTABLE>
 67c:	4d2d0567 	cfstr32mi	mvfx0, [sp, #-412]!	; 0xfffffe64
 680:	054b3105 	strbeq	r3, [fp, #-261]	; 0xfffffefb
 684:	0c054b1a 			; <UNDEFINED> instruction: 0x0c054b1a
 688:	2f010530 	svccs	0x00010530
 68c:	67200585 	strvs	r0, [r0, -r5, lsl #11]!
 690:	054d2d05 	strbeq	r2, [sp, #-3333]	; 0xfffff2fb
 694:	1a054b31 	bne	153360 <__bss_end+0x149c1c>
 698:	300c054b 	andcc	r0, ip, fp, asr #10
 69c:	852f0105 	strhi	r0, [pc, #-261]!	; 59f <shift+0x59f>
 6a0:	05832005 	streq	r2, [r3, #5]
 6a4:	3e054c2d 	cdpcc	12, 0, cr4, cr5, cr13, {1}
 6a8:	4b1a054b 	blmi	681bdc <__bss_end+0x678498>
 6ac:	852f0105 	strhi	r0, [pc, #-261]!	; 5af <shift+0x5af>
 6b0:	05672005 	strbeq	r2, [r7, #-5]!
 6b4:	30054d2d 	andcc	r4, r5, sp, lsr #26
 6b8:	4b1a054b 	blmi	681bec <__bss_end+0x6784a8>
 6bc:	05300c05 	ldreq	r0, [r0, #-3077]!	; 0xfffff3fb
 6c0:	05872f01 	streq	r2, [r7, #3841]	; 0xf01
 6c4:	059fa00c 	ldreq	sl, [pc, #12]	; 6d8 <shift+0x6d8>
 6c8:	2905bc31 	stmdbcs	r5, {r0, r4, r5, sl, fp, ip, sp, pc}
 6cc:	2e360566 	cdpcs	5, 3, cr0, cr6, cr6, {3}
 6d0:	05300f05 	ldreq	r0, [r0, #-3845]!	; 0xfffff0fb
 6d4:	09056613 	stmdbeq	r5, {r0, r1, r4, r9, sl, sp, lr}
 6d8:	d8100584 	ldmdale	r0, {r2, r7, r8, sl}
 6dc:	029f0105 	addseq	r0, pc, #1073741825	; 0x40000001
 6e0:	01010008 	tsteq	r1, r8
 6e4:	00000276 	andeq	r0, r0, r6, ror r2
 6e8:	004f0003 	subeq	r0, pc, r3
 6ec:	01020000 	mrseq	r0, (UNDEF: 2)
 6f0:	000d0efb 	strdeq	r0, [sp], -fp
 6f4:	01010101 	tsteq	r1, r1, lsl #2
 6f8:	01000000 	mrseq	r0, (UNDEF: 0)
 6fc:	2f010000 	svccs	0x00010000
 700:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 704:	6863732f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, sp, lr}^
 708:	6a6b6e65 	bvs	1adc0a4 <__bss_end+0x1ad2960>
 70c:	32736f2f 	rsbscc	r6, r3, #47, 30	; 0xbc
 710:	2f323230 	svccs	0x00323230
 714:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
 718:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 71c:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
 720:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
 724:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
 728:	73000063 	movwvc	r0, #99	; 0x63
 72c:	74736474 	ldrbtvc	r6, [r3], #-1140	; 0xfffffb8c
 730:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
 734:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 738:	00000100 	andeq	r0, r0, r0, lsl #2
 73c:	00010500 	andeq	r0, r1, r0, lsl #10
 740:	87a00205 	strhi	r0, [r0, r5, lsl #4]!
 744:	051a0000 	ldreq	r0, [sl, #-0]
 748:	0f05bb06 	svceq	0x0005bb06
 74c:	6821054c 	stmdavs	r1!, {r2, r3, r6, r8, sl}
 750:	05ba0a05 	ldreq	r0, [sl, #2565]!	; 0xa05
 754:	27052e0b 	strcs	r2, [r5, -fp, lsl #28]
 758:	4a0d054a 	bmi	341c88 <__bss_end+0x338544>
 75c:	052f0905 	streq	r0, [pc, #-2309]!	; fffffe5f <__bss_end+0xffff671b>
 760:	02059f04 	andeq	r9, r5, #4, 30
 764:	35050562 	strcc	r0, [r5, #-1378]	; 0xfffffa9e
 768:	05681005 	strbeq	r1, [r8, #-5]!
 76c:	22052e11 	andcs	r2, r5, #272	; 0x110
 770:	2e13054a 	cfmac32cs	mvfx0, mvfx3, mvfx10
 774:	052f0a05 	streq	r0, [pc, #-2565]!	; fffffd77 <__bss_end+0xffff6633>
 778:	0a056909 	beq	15aba4 <__bss_end+0x151460>
 77c:	4a0c052e 	bmi	301c3c <__bss_end+0x2f84f8>
 780:	054b0305 	strbeq	r0, [fp, #-773]	; 0xfffffcfb
 784:	1805680b 	stmdane	r5, {r0, r1, r3, fp, sp, lr}
 788:	03040200 	movweq	r0, #16896	; 0x4200
 78c:	0014054a 	andseq	r0, r4, sl, asr #10
 790:	9e030402 	cdpls	4, 0, cr0, cr3, cr2, {0}
 794:	02001505 	andeq	r1, r0, #20971520	; 0x1400000
 798:	05680204 	strbeq	r0, [r8, #-516]!	; 0xfffffdfc
 79c:	04020018 	streq	r0, [r2], #-24	; 0xffffffe8
 7a0:	08058202 	stmdaeq	r5, {r1, r9, pc}
 7a4:	02040200 	andeq	r0, r4, #0, 4
 7a8:	001a054a 	andseq	r0, sl, sl, asr #10
 7ac:	4b020402 	blmi	817bc <__bss_end+0x78078>
 7b0:	02001b05 	andeq	r1, r0, #5120	; 0x1400
 7b4:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 7b8:	0402000c 	streq	r0, [r2], #-12
 7bc:	0f054a02 	svceq	0x00054a02
 7c0:	02040200 	andeq	r0, r4, #0, 4
 7c4:	001b0582 	andseq	r0, fp, r2, lsl #11
 7c8:	4a020402 	bmi	817d8 <__bss_end+0x78094>
 7cc:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
 7d0:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 7d4:	0402000a 	streq	r0, [r2], #-10
 7d8:	0b052f02 	bleq	14c3e8 <__bss_end+0x142ca4>
 7dc:	02040200 	andeq	r0, r4, #0, 4
 7e0:	000d052e 	andeq	r0, sp, lr, lsr #10
 7e4:	4a020402 	bmi	817f4 <__bss_end+0x780b0>
 7e8:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 7ec:	05460204 	strbeq	r0, [r6, #-516]	; 0xfffffdfc
 7f0:	05858801 	streq	r8, [r5, #2049]	; 0x801
 7f4:	09058306 	stmdbeq	r5, {r1, r2, r8, r9, pc}
 7f8:	4a10054c 	bmi	401d30 <__bss_end+0x3f85ec>
 7fc:	054c0a05 	strbeq	r0, [ip, #-2565]	; 0xfffff5fb
 800:	0305bb07 	movweq	fp, #23303	; 0x5b07
 804:	0017054a 	andseq	r0, r7, sl, asr #10
 808:	4a010402 	bmi	41818 <__bss_end+0x380d4>
 80c:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
 810:	054a0104 	strbeq	r0, [sl, #-260]	; 0xfffffefc
 814:	14054d0d 	strne	r4, [r5], #-3341	; 0xfffff2f3
 818:	2e0a054a 	cfsh32cs	mvfx0, mvfx10, #42
 81c:	05680805 	strbeq	r0, [r8, #-2053]!	; 0xfffff7fb
 820:	66780302 	ldrbtvs	r0, [r8], -r2, lsl #6
 824:	0b030905 	bleq	c2c40 <__bss_end+0xb94fc>
 828:	2f01052e 	svccs	0x0001052e
 82c:	bd090585 	cfstr32lt	mvfx0, [r9, #-532]	; 0xfffffdec
 830:	02001605 	andeq	r1, r0, #5242880	; 0x500000
 834:	054a0404 	strbeq	r0, [sl, #-1028]	; 0xfffffbfc
 838:	0402001d 	streq	r0, [r2], #-29	; 0xffffffe3
 83c:	1e058202 	cdpne	2, 0, cr8, cr5, cr2, {0}
 840:	02040200 	andeq	r0, r4, #0, 4
 844:	0016052e 	andseq	r0, r6, lr, lsr #10
 848:	66020402 	strvs	r0, [r2], -r2, lsl #8
 84c:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
 850:	054b0304 	strbeq	r0, [fp, #-772]	; 0xfffffcfc
 854:	04020012 	streq	r0, [r2], #-18	; 0xffffffee
 858:	08052e03 	stmdaeq	r5, {r0, r1, r9, sl, fp, sp}
 85c:	03040200 	movweq	r0, #16896	; 0x4200
 860:	0009054a 	andeq	r0, r9, sl, asr #10
 864:	2e030402 	cdpcs	4, 0, cr0, cr3, cr2, {0}
 868:	02001205 	andeq	r1, r0, #1342177280	; 0x50000000
 86c:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 870:	0402000b 	streq	r0, [r2], #-11
 874:	02052e03 	andeq	r2, r5, #3, 28	; 0x30
 878:	03040200 	movweq	r0, #16896	; 0x4200
 87c:	000b052d 	andeq	r0, fp, sp, lsr #10
 880:	84020402 	strhi	r0, [r2], #-1026	; 0xfffffbfe
 884:	02000805 	andeq	r0, r0, #327680	; 0x50000
 888:	05830104 	streq	r0, [r3, #260]	; 0x104
 88c:	04020009 	streq	r0, [r2], #-9
 890:	0b052e01 	bleq	14c09c <__bss_end+0x142958>
 894:	01040200 	mrseq	r0, R12_usr
 898:	0002054a 	andeq	r0, r2, sl, asr #10
 89c:	49010402 	stmdbmi	r1, {r1, sl}
 8a0:	05850b05 	streq	r0, [r5, #2821]	; 0xb05
 8a4:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 8a8:	1105bc0e 	tstne	r5, lr, lsl #24
 8ac:	bc200566 	cfstr32lt	mvfx0, [r0], #-408	; 0xfffffe68
 8b0:	05660b05 	strbeq	r0, [r6, #-2821]!	; 0xfffff4fb
 8b4:	0a054b1f 	beq	153538 <__bss_end+0x149df4>
 8b8:	4b080566 	blmi	201e58 <__bss_end+0x1f8714>
 8bc:	05831105 	streq	r1, [r3, #261]	; 0x105
 8c0:	08052e16 	stmdaeq	r5, {r1, r2, r4, r9, sl, fp, sp}
 8c4:	67110567 	ldrvs	r0, [r1, -r7, ror #10]
 8c8:	054d0b05 	strbeq	r0, [sp, #-2821]	; 0xfffff4fb
 8cc:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 8d0:	0b058306 	bleq	1614f0 <__bss_end+0x157dac>
 8d4:	2e0c054c 	cfsh32cs	mvfx0, mvfx12, #44
 8d8:	05660e05 	strbeq	r0, [r6, #-3589]!	; 0xfffff1fb
 8dc:	02054b04 	andeq	r4, r5, #4, 22	; 0x1000
 8e0:	31090565 	tstcc	r9, r5, ror #10
 8e4:	852f0105 	strhi	r0, [pc, #-261]!	; 7e7 <shift+0x7e7>
 8e8:	059f0805 	ldreq	r0, [pc, #2053]	; 10f5 <shift+0x10f5>
 8ec:	14054c0b 	strne	r4, [r5], #-3083	; 0xfffff3f5
 8f0:	03040200 	movweq	r0, #16896	; 0x4200
 8f4:	0007054a 	andeq	r0, r7, sl, asr #10
 8f8:	83020402 	movwhi	r0, #9218	; 0x2402
 8fc:	02000805 	andeq	r0, r0, #327680	; 0x50000
 900:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 904:	0402000a 	streq	r0, [r2], #-10
 908:	02054a02 	andeq	r4, r5, #8192	; 0x2000
 90c:	02040200 	andeq	r0, r4, #0, 4
 910:	84010549 	strhi	r0, [r1], #-1353	; 0xfffffab7
 914:	bb0e0585 	bllt	381f30 <__bss_end+0x3787ec>
 918:	054b0805 	strbeq	r0, [fp, #-2053]	; 0xfffff7fb
 91c:	14054c0b 	strne	r4, [r5], #-3083	; 0xfffff3f5
 920:	03040200 	movweq	r0, #16896	; 0x4200
 924:	0016054a 	andseq	r0, r6, sl, asr #10
 928:	83020402 	movwhi	r0, #9218	; 0x2402
 92c:	02001705 	andeq	r1, r0, #1310720	; 0x140000
 930:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 934:	0402000a 	streq	r0, [r2], #-10
 938:	0b054a02 	bleq	153148 <__bss_end+0x149a04>
 93c:	02040200 	andeq	r0, r4, #0, 4
 940:	0017052e 	andseq	r0, r7, lr, lsr #10
 944:	4a020402 	bmi	81954 <__bss_end+0x78210>
 948:	02000d05 	andeq	r0, r0, #320	; 0x140
 94c:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 950:	04020002 	streq	r0, [r2], #-2
 954:	01052d02 	tsteq	r5, r2, lsl #26
 958:	00080284 	andeq	r0, r8, r4, lsl #5
 95c:	033a0101 	teqeq	sl, #1073741824	; 0x40000000
 960:	00030000 	andeq	r0, r3, r0
 964:	000001f8 	strdeq	r0, [r0], -r8
 968:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 96c:	0101000d 	tsteq	r1, sp
 970:	00000101 	andeq	r0, r0, r1, lsl #2
 974:	00000100 	andeq	r0, r0, r0, lsl #2
 978:	6f682f01 	svcvs	0x00682f01
 97c:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
 980:	6e656863 	cdpvs	8, 6, cr6, cr5, cr3, {3}
 984:	6f2f6a6b 	svcvs	0x002f6a6b
 988:	32303273 	eorscc	r3, r0, #805306375	; 0x30000007
 98c:	70732f32 	rsbsvc	r2, r3, r2, lsr pc
 990:	756f732f 	strbvc	r7, [pc, #-815]!	; 669 <shift+0x669>
 994:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 998:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
 99c:	6c697475 	cfstrdvs	mvd7, [r9], #-468	; 0xfffffe2c
 9a0:	72732f73 	rsbsvc	r2, r3, #460	; 0x1cc
 9a4:	682f0063 	stmdavs	pc!, {r0, r1, r5, r6}	; <UNPREDICTABLE>
 9a8:	2f656d6f 	svccs	0x00656d6f
 9ac:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
 9b0:	2f6a6b6e 	svccs	0x006a6b6e
 9b4:	3032736f 	eorscc	r7, r2, pc, ror #6
 9b8:	732f3232 			; <UNDEFINED> instruction: 0x732f3232
 9bc:	6f732f70 	svcvs	0x00732f70
 9c0:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 9c4:	656b2f73 	strbvs	r2, [fp, #-3955]!	; 0xfffff08d
 9c8:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 9cc:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 9d0:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 9d4:	616f622f 	cmnvs	pc, pc, lsr #4
 9d8:	722f6472 	eorvc	r6, pc, #1912602624	; 0x72000000
 9dc:	2f306970 	svccs	0x00306970
 9e0:	006c6168 	rsbeq	r6, ip, r8, ror #2
 9e4:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 930 <shift+0x930>
 9e8:	63732f65 	cmnvs	r3, #404	; 0x194
 9ec:	6b6e6568 	blvs	1b99f94 <__bss_end+0x1b90850>
 9f0:	736f2f6a 	cmnvc	pc, #424	; 0x1a8
 9f4:	32323032 	eorscc	r3, r2, #50	; 0x32
 9f8:	2f70732f 	svccs	0x0070732f
 9fc:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 a00:	2f736563 	svccs	0x00736563
 a04:	75647473 	strbvc	r7, [r4, #-1139]!	; 0xfffffb8d
 a08:	736c6974 	cmnvc	ip, #116, 18	; 0x1d0000
 a0c:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 a10:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 a14:	6f682f00 	svcvs	0x00682f00
 a18:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
 a1c:	6e656863 	cdpvs	8, 6, cr6, cr5, cr3, {3}
 a20:	6f2f6a6b 	svcvs	0x002f6a6b
 a24:	32303273 	eorscc	r3, r0, #805306375	; 0x30000007
 a28:	70732f32 	rsbsvc	r2, r3, r2, lsr pc
 a2c:	756f732f 	strbvc	r7, [pc, #-815]!	; 705 <shift+0x705>
 a30:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 a34:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 a38:	2f6c656e 	svccs	0x006c656e
 a3c:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 a40:	2f656475 	svccs	0x00656475
 a44:	636f7270 	cmnvs	pc, #112, 4
 a48:	00737365 	rsbseq	r7, r3, r5, ror #6
 a4c:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 998 <shift+0x998>
 a50:	63732f65 	cmnvs	r3, #404	; 0x194
 a54:	6b6e6568 	blvs	1b99ffc <__bss_end+0x1b908b8>
 a58:	736f2f6a 	cmnvc	pc, #424	; 0x1a8
 a5c:	32323032 	eorscc	r3, r2, #50	; 0x32
 a60:	2f70732f 	svccs	0x0070732f
 a64:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 a68:	2f736563 	svccs	0x00736563
 a6c:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 a70:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 a74:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 a78:	662f6564 	strtvs	r6, [pc], -r4, ror #10
 a7c:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
 a80:	2f656d6f 	svccs	0x00656d6f
 a84:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
 a88:	2f6a6b6e 	svccs	0x006a6b6e
 a8c:	3032736f 	eorscc	r7, r2, pc, ror #6
 a90:	732f3232 			; <UNDEFINED> instruction: 0x732f3232
 a94:	6f732f70 	svcvs	0x00732f70
 a98:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 a9c:	656b2f73 	strbvs	r2, [fp, #-3955]!	; 0xfffff08d
 aa0:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 aa4:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 aa8:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 aac:	6972642f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, sl, sp, lr}^
 ab0:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
 ab4:	6972622f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, r9, sp, lr}^
 ab8:	73656764 	cmnvc	r5, #100, 14	; 0x1900000
 abc:	6c6f0000 	stclvs	0, cr0, [pc], #-0	; ac4 <shift+0xac4>
 ac0:	632e6465 			; <UNDEFINED> instruction: 0x632e6465
 ac4:	01007070 	tsteq	r0, r0, ror r0
 ac8:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
 acc:	66656474 			; <UNDEFINED> instruction: 0x66656474
 ad0:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 ad4:	6c6f0000 	stclvs	0, cr0, [pc], #-0	; adc <shift+0xadc>
 ad8:	682e6465 	stmdavs	lr!, {r0, r2, r5, r6, sl, sp, lr}
 adc:	00000300 	andeq	r0, r0, r0, lsl #6
 ae0:	2e697773 	mcrcs	7, 3, r7, cr9, cr3, {3}
 ae4:	00040068 	andeq	r0, r4, r8, rrx
 ae8:	69707300 	ldmdbvs	r0!, {r8, r9, ip, sp, lr}^
 aec:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
 af0:	00682e6b 	rsbeq	r2, r8, fp, ror #28
 af4:	66000004 	strvs	r0, [r0], -r4
 af8:	73656c69 	cmnvc	r5, #26880	; 0x6900
 afc:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
 b00:	00682e6d 	rsbeq	r2, r8, sp, ror #28
 b04:	70000005 	andvc	r0, r0, r5
 b08:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 b0c:	682e7373 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, r9, ip, sp, lr}
 b10:	00000400 	andeq	r0, r0, r0, lsl #8
 b14:	636f7270 	cmnvs	pc, #112, 4
 b18:	5f737365 	svcpl	0x00737365
 b1c:	616e616d 	cmnvs	lr, sp, ror #2
 b20:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
 b24:	00040068 	andeq	r0, r4, r8, rrx
 b28:	73696400 	cmnvc	r9, #0, 8
 b2c:	79616c70 	stmdbvc	r1!, {r4, r5, r6, sl, fp, sp, lr}^
 b30:	6f72705f 	svcvs	0x0072705f
 b34:	6f636f74 	svcvs	0x00636f74
 b38:	00682e6c 	rsbeq	r2, r8, ip, ror #28
 b3c:	70000006 	andvc	r0, r0, r6
 b40:	70697265 	rsbvc	r7, r9, r5, ror #4
 b44:	61726568 	cmnvs	r2, r8, ror #10
 b48:	682e736c 	stmdavs	lr!, {r2, r3, r5, r6, r8, r9, ip, sp, lr}
 b4c:	00000200 	andeq	r0, r0, r0, lsl #4
 b50:	64656c6f 	strbtvs	r6, [r5], #-3183	; 0xfffff391
 b54:	6e6f665f 	mcrvs	6, 3, r6, cr15, cr15, {2}
 b58:	00682e74 	rsbeq	r2, r8, r4, ror lr
 b5c:	00000001 	andeq	r0, r0, r1
 b60:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
 b64:	008c5802 	addeq	r5, ip, r2, lsl #16
 b68:	01090300 	mrseq	r0, (UNDEF: 57)
 b6c:	059f1405 	ldreq	r1, [pc, #1029]	; f79 <shift+0xf79>
 b70:	10058248 	andne	r8, r5, r8, asr #4
 b74:	4a1805a1 	bmi	602200 <__bss_end+0x5f8abc>
 b78:	05820d05 	streq	r0, [r2, #3333]	; 0xd05
 b7c:	05844b01 	streq	r4, [r4, #2817]	; 0xb01
 b80:	05058509 	streq	r8, [r5, #-1289]	; 0xfffffaf7
 b84:	4c11054a 	cfldr32mi	mvfx0, [r1], {74}	; 0x4a
 b88:	05670e05 	strbeq	r0, [r7, #-3589]!	; 0xfffff1fb
 b8c:	05858401 	streq	r8, [r5, #1025]	; 0x401
 b90:	0105830c 	tsteq	r5, ip, lsl #6
 b94:	0a05854b 	beq	1620c8 <__bss_end+0x158984>
 b98:	4a0905bb 	bmi	24228c <__bss_end+0x238b48>
 b9c:	054a0505 	strbeq	r0, [sl, #-1285]	; 0xfffffafb
 ba0:	0f054e11 	svceq	0x00054e11
 ba4:	0402004b 	streq	r0, [r2], #-75	; 0xffffffb5
 ba8:	00660601 	rsbeq	r0, r6, r1, lsl #12
 bac:	4a020402 	bmi	81bbc <__bss_end+0x78478>
 bb0:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 bb4:	0007052e 	andeq	r0, r7, lr, lsr #10
 bb8:	06040402 	streq	r0, [r4], -r2, lsl #8
 bbc:	d109052f 	tstle	r9, pc, lsr #10
 bc0:	4d340105 	ldfmis	f0, [r4, #-20]!	; 0xffffffec
 bc4:	91080a05 	tstls	r8, r5, lsl #20
 bc8:	054a0905 	strbeq	r0, [sl, #-2309]	; 0xfffff6fb
 bcc:	14054a05 	strne	r4, [r5], #-2565	; 0xfffff5fb
 bd0:	4b0f054f 	blmi	3c2114 <__bss_end+0x3b89d0>
 bd4:	f39f1105 	vaddw.u16	<illegal reg q0.5>, <illegal reg q7.5>, d5
 bd8:	00f31305 	rscseq	r1, r3, r5, lsl #6
 bdc:	06010402 	streq	r0, [r1], -r2, lsl #8
 be0:	04020066 	streq	r0, [r2], #-102	; 0xffffff9a
 be4:	02004a02 	andeq	r4, r0, #8192	; 0x2000
 be8:	052e0404 	streq	r0, [lr, #-1028]!	; 0xfffffbfc
 bec:	0402000a 	streq	r0, [r2], #-10
 bf0:	052f0604 	streq	r0, [pc, #-1540]!	; 5f4 <shift+0x5f4>
 bf4:	d6770309 	ldrbtle	r0, [r7], -r9, lsl #6
 bf8:	0a030105 	beq	c1014 <__bss_end+0xb78d0>
 bfc:	0a054d2e 	beq	1540bc <__bss_end+0x14a978>
 c00:	09059108 	stmdbeq	r5, {r3, r8, ip, pc}
 c04:	4a05054a 	bmi	142134 <__bss_end+0x1389f0>
 c08:	0028054e 	eoreq	r0, r8, lr, asr #10
 c0c:	66010402 	strvs	r0, [r1], -r2, lsl #8
 c10:	02002305 	andeq	r2, r0, #335544320	; 0x14000000
 c14:	052e0104 	streq	r0, [lr, #-260]!	; 0xfffffefc
 c18:	15054f1e 	strne	r4, [r5, #-3870]	; 0xfffff0e2
 c1c:	670c054b 	strvs	r0, [ip, -fp, asr #10]
 c20:	bb0d05bb 	bllt	342314 <__bss_end+0x338bd0>
 c24:	10052108 	andne	r2, r5, r8, lsl #2
 c28:	44052108 	strmi	r2, [r5], #-264	; 0xfffffef8
 c2c:	2e510568 	cdpcs	5, 5, cr0, cr1, cr8, {3}
 c30:	052e4005 	streq	r4, [lr, #-5]!
 c34:	6c059e0c 	stcvs	14, cr9, [r5], {12}
 c38:	4a0b054a 	bmi	2c2168 <__bss_end+0x2b8a24>
 c3c:	05680a05 	strbeq	r0, [r8, #-2565]!	; 0xfffff5fb
 c40:	d66e0309 	strbtle	r0, [lr], -r9, lsl #6
 c44:	0301054e 	movweq	r0, #5454	; 0x154e
 c48:	05692e0f 	strbeq	r2, [r9, #-3599]!	; 0xfffff1f1
 c4c:	0905830a 	stmdbeq	r5, {r1, r3, r8, r9, pc}
 c50:	4a05054a 	bmi	142180 <__bss_end+0x138a3c>
 c54:	054e1405 	strbeq	r1, [lr, #-1029]	; 0xfffffbfb
 c58:	09054c0a 	stmdbeq	r5, {r1, r3, sl, fp, lr}
 c5c:	340105d1 	strcc	r0, [r1], #-1489	; 0xfffffa2f
 c60:	080a054d 	stmdaeq	sl, {r0, r2, r3, r6, r8, sl}
 c64:	4a090521 	bmi	2420f0 <__bss_end+0x2389ac>
 c68:	054a0505 	strbeq	r0, [sl, #-1285]	; 0xfffffafb
 c6c:	11054d0e 	tstne	r5, lr, lsl #26
 c70:	4c0c054b 	cfstr32mi	mvfx0, [ip], {75}	; 0x4b
 c74:	054a1905 	strbeq	r1, [sl, #-2309]	; 0xfffff6fb
 c78:	04020020 	streq	r0, [r2], #-32	; 0xffffffe0
 c7c:	19054a01 	stmdbne	r5, {r0, r9, fp, lr}
 c80:	01040200 	mrseq	r0, R12_usr
 c84:	4c110566 	cfldr32mi	mvfx0, [r1], {102}	; 0x66
 c88:	67bb0c05 	ldrvs	r0, [fp, r5, lsl #24]!
 c8c:	05620505 	strbeq	r0, [r2, #-1285]!	; 0xfffffafb
 c90:	01052909 	tsteq	r5, r9, lsl #18
 c94:	022e0b03 	eoreq	r0, lr, #3072	; 0xc00
 c98:	01010004 	tsteq	r1, r4
 c9c:	00000079 	andeq	r0, r0, r9, ror r0
 ca0:	00460003 	subeq	r0, r6, r3
 ca4:	01020000 	mrseq	r0, (UNDEF: 2)
 ca8:	000d0efb 	strdeq	r0, [sp], -fp
 cac:	01010101 	tsteq	r1, r1, lsl #2
 cb0:	01000000 	mrseq	r0, (UNDEF: 0)
 cb4:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
 cb8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 cbc:	2f2e2e2f 	svccs	0x002e2e2f
 cc0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 cc4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 cc8:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
 ccc:	2f636367 	svccs	0x00636367
 cd0:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
 cd4:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
 cd8:	00006d72 	andeq	r6, r0, r2, ror sp
 cdc:	3162696c 	cmncc	r2, ip, ror #18
 ce0:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
 ce4:	00532e73 	subseq	r2, r3, r3, ror lr
 ce8:	00000001 	andeq	r0, r0, r1
 cec:	0c020500 	cfstr32eq	mvfx0, [r2], {-0}
 cf0:	03000091 	movweq	r0, #145	; 0x91
 cf4:	300108ca 	andcc	r0, r1, sl, asr #17
 cf8:	2f2f2f2f 	svccs	0x002f2f2f
 cfc:	d002302f 	andle	r3, r2, pc, lsr #32
 d00:	312f1401 			; <UNDEFINED> instruction: 0x312f1401
 d04:	4c302f2f 	ldcmi	15, cr2, [r0], #-188	; 0xffffff44
 d08:	1f03322f 	svcne	0x0003322f
 d0c:	2f2f2f66 	svccs	0x002f2f66
 d10:	2f2f2f2f 	svccs	0x002f2f2f
 d14:	01000202 	tsteq	r0, r2, lsl #4
 d18:	00005c01 	andeq	r5, r0, r1, lsl #24
 d1c:	46000300 	strmi	r0, [r0], -r0, lsl #6
 d20:	02000000 	andeq	r0, r0, #0
 d24:	0d0efb01 	vstreq	d15, [lr, #-4]
 d28:	01010100 	mrseq	r0, (UNDEF: 17)
 d2c:	00000001 	andeq	r0, r0, r1
 d30:	01000001 	tsteq	r0, r1
 d34:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 d38:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 d3c:	2f2e2e2f 	svccs	0x002e2e2f
 d40:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 d44:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
 d48:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 d4c:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
 d50:	2f676966 	svccs	0x00676966
 d54:	006d7261 	rsbeq	r7, sp, r1, ror #4
 d58:	62696c00 	rsbvs	r6, r9, #0, 24
 d5c:	6e756631 	mrcvs	6, 3, r6, cr5, cr1, {1}
 d60:	532e7363 			; <UNDEFINED> instruction: 0x532e7363
 d64:	00000100 	andeq	r0, r0, r0, lsl #2
 d68:	02050000 	andeq	r0, r5, #0
 d6c:	00009318 	andeq	r9, r0, r8, lsl r3
 d70:	010bb403 	tsteq	fp, r3, lsl #8
 d74:	01000202 	tsteq	r0, r2, lsl #4
 d78:	00010301 	andeq	r0, r1, r1, lsl #6
 d7c:	fd000300 	stc2	3, cr0, [r0, #-0]
 d80:	02000000 	andeq	r0, r0, #0
 d84:	0d0efb01 	vstreq	d15, [lr, #-4]
 d88:	01010100 	mrseq	r0, (UNDEF: 17)
 d8c:	00000001 	andeq	r0, r0, r1
 d90:	01000001 	tsteq	r0, r1
 d94:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 d98:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 d9c:	2f2e2e2f 	svccs	0x002e2e2f
 da0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 da4:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
 da8:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 dac:	2f2e2e2f 	svccs	0x002e2e2f
 db0:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 db4:	00656475 	rsbeq	r6, r5, r5, ror r4
 db8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 dbc:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 dc0:	2f2e2e2f 	svccs	0x002e2e2f
 dc4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 dc8:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
 dcc:	2f2e2e00 	svccs	0x002e2e00
 dd0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 dd4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 dd8:	2f2e2e2f 	svccs	0x002e2e2f
 ddc:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; d2c <shift+0xd2c>
 de0:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 de4:	2e2e2f63 	cdpcs	15, 2, cr2, cr14, cr3, {3}
 de8:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
 dec:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
 df0:	2f676966 	svccs	0x00676966
 df4:	006d7261 	rsbeq	r7, sp, r1, ror #4
 df8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 dfc:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 e00:	2f2e2e2f 	svccs	0x002e2e2f
 e04:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 e08:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
 e0c:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 e10:	61680000 	cmnvs	r8, r0
 e14:	61746873 	cmnvs	r4, r3, ror r8
 e18:	00682e62 	rsbeq	r2, r8, r2, ror #28
 e1c:	61000001 	tstvs	r0, r1
 e20:	692d6d72 	pushvs	{r1, r4, r5, r6, r8, sl, fp, sp, lr}
 e24:	682e6173 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, sp, lr}
 e28:	00000200 	andeq	r0, r0, r0, lsl #4
 e2c:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
 e30:	2e757063 	cdpcs	0, 7, cr7, cr5, cr3, {3}
 e34:	00020068 	andeq	r0, r2, r8, rrx
 e38:	736e6900 	cmnvc	lr, #0, 18
 e3c:	6f632d6e 	svcvs	0x00632d6e
 e40:	6174736e 	cmnvs	r4, lr, ror #6
 e44:	2e73746e 	cdpcs	4, 7, cr7, cr3, cr14, {3}
 e48:	00020068 	andeq	r0, r2, r8, rrx
 e4c:	6d726100 	ldfvse	f6, [r2, #-0]
 e50:	0300682e 	movweq	r6, #2094	; 0x82e
 e54:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
 e58:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 e5c:	00682e32 	rsbeq	r2, r8, r2, lsr lr
 e60:	67000004 	strvs	r0, [r0, -r4]
 e64:	632d6c62 			; <UNDEFINED> instruction: 0x632d6c62
 e68:	73726f74 	cmnvc	r2, #116, 30	; 0x1d0
 e6c:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
 e70:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
 e74:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 e78:	00632e32 	rsbeq	r2, r3, r2, lsr lr
 e7c:	00000004 	andeq	r0, r0, r4

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
      58:	1fa30704 	svcne	0x00a30704
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
      b0:	0b010000 	bleq	400b8 <__bss_end+0x36974>
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
     11c:	1fa30704 	svcne	0x00a30704
     120:	72080000 	andvc	r0, r8, #0
     124:	01000003 	tsteq	r0, r3
     128:	00441533 	subeq	r1, r4, r3, lsr r5
     12c:	4a080000 	bmi	200134 <__bss_end+0x1f69f0>
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
     15c:	3a010000 	bcc	40164 <__bss_end+0x36a20>
     160:	00007615 	andeq	r7, r0, r5, lsl r6
     164:	01af0900 			; <UNDEFINED> instruction: 0x01af0900
     168:	48010000 	stmdami	r1, {}	; <UNPREDICTABLE>
     16c:	0000cb10 	andeq	ip, r0, r0, lsl fp
     170:	0081e000 	addeq	lr, r1, r0
     174:	00005800 	andeq	r5, r0, r0, lsl #16
     178:	cb9c0100 	blgt	fe700580 <__bss_end+0xfe6f6e3c>
     17c:	0a000000 	beq	184 <shift+0x184>
     180:	000001bd 			; <UNDEFINED> instruction: 0x000001bd
     184:	d20c4a01 	andle	r4, ip, #4096	; 0x1000
     188:	02000000 	andeq	r0, r0, #0
     18c:	0b007491 	bleq	1d3d8 <__bss_end+0x13c94>
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
     200:	2a0c9c01 	bcs	32720c <__bss_end+0x31dac8>
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
     254:	cb110a01 	blgt	442a60 <__bss_end+0x43931c>
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
     2bc:	0a010067 	beq	40460 <__bss_end+0x36d1c>
     2c0:	00019e2f 	andeq	r9, r1, pc, lsr #28
     2c4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     2c8:	0f560000 	svceq	0x00560000
     2cc:	00040000 	andeq	r0, r4, r0
     2d0:	000001c6 	andeq	r0, r0, r6, asr #3
     2d4:	02450104 	subeq	r0, r5, #4, 2
     2d8:	91040000 	mrsls	r0, (UNDEF: 4)
     2dc:	31000009 	tstcc	r0, r9
     2e0:	38000000 	stmdacc	r0, {}	; <UNPREDICTABLE>
     2e4:	0c000082 	stceq	0, cr0, [r0], {130}	; 0x82
     2e8:	e1000001 	tst	r0, r1
     2ec:	02000001 	andeq	r0, r0, #1
     2f0:	10ba0801 	adcsne	r0, sl, r1, lsl #16
     2f4:	25030000 	strcs	r0, [r3, #-0]
     2f8:	02000000 	andeq	r0, r0, #0
     2fc:	0e380502 	cdpeq	5, 3, cr0, cr8, cr2, {0}
     300:	04040000 	streq	r0, [r4], #-0
     304:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
     308:	08010200 	stmdaeq	r1, {r9}
     30c:	000010b1 	strheq	r1, [r0], -r1	; <UNPREDICTABLE>
     310:	000d8105 	andeq	r8, sp, r5, lsl #2
     314:	07080200 	streq	r0, [r8, -r0, lsl #4]
     318:	00000052 	andeq	r0, r0, r2, asr r0
     31c:	6c070202 	sfmvs	f0, 4, [r7], {2}
     320:	05000012 	streq	r0, [r0, #-18]	; 0xffffffee
     324:	000006ec 	andeq	r0, r0, ip, ror #13
     328:	6a070902 	bvs	1c2738 <__bss_end+0x1b8ff4>
     32c:	03000000 	movweq	r0, #0
     330:	00000059 	andeq	r0, r0, r9, asr r0
     334:	a3070402 	movwge	r0, #29698	; 0x7402
     338:	0300001f 	movweq	r0, #31
     33c:	0000006a 	andeq	r0, r0, sl, rrx
     340:	00006a06 	andeq	r6, r0, r6, lsl #20
     344:	13630700 	cmnne	r3, #0, 14
     348:	03080000 	movweq	r0, #32768	; 0x8000
     34c:	00a10806 	adceq	r0, r1, r6, lsl #16
     350:	72080000 	andvc	r0, r8, #0
     354:	08030030 	stmdaeq	r3, {r4, r5}
     358:	0000590e 	andeq	r5, r0, lr, lsl #18
     35c:	72080000 	andvc	r0, r8, #0
     360:	09030031 	stmdbeq	r3, {r0, r4, r5}
     364:	0000590e 	andeq	r5, r0, lr, lsl #18
     368:	09000400 	stmdbeq	r0, {sl}
     36c:	00000eef 	andeq	r0, r0, pc, ror #29
     370:	00380405 	eorseq	r0, r8, r5, lsl #8
     374:	1e030000 	cdpne	0, 0, cr0, cr3, cr0, {0}
     378:	0000d80c 	andeq	sp, r0, ip, lsl #16
     37c:	06e40a00 	strbteq	r0, [r4], r0, lsl #20
     380:	0a000000 	beq	388 <shift+0x388>
     384:	00000926 	andeq	r0, r0, r6, lsr #18
     388:	0f110a01 	svceq	0x00110a01
     38c:	0a020000 	beq	80394 <__bss_end+0x76c50>
     390:	000010cd 	andeq	r1, r0, sp, asr #1
     394:	09090a03 	stmdbeq	r9, {r0, r1, r9, fp}
     398:	0a040000 	beq	1003a0 <__bss_end+0xf6c5c>
     39c:	00000e28 	andeq	r0, r0, r8, lsr #28
     3a0:	d7090005 	strle	r0, [r9, -r5]
     3a4:	0500000e 	streq	r0, [r0, #-14]
     3a8:	00003804 	andeq	r3, r0, r4, lsl #16
     3ac:	0c3f0300 	ldceq	3, cr0, [pc], #-0	; 3b4 <shift+0x3b4>
     3b0:	00000115 	andeq	r0, r0, r5, lsl r1
     3b4:	00084d0a 	andeq	r4, r8, sl, lsl #26
     3b8:	0b0a0000 	bleq	2803c0 <__bss_end+0x276c7c>
     3bc:	01000010 	tsteq	r0, r0, lsl r0
     3c0:	0012fc0a 	andseq	pc, r2, sl, lsl #24
     3c4:	ff0a0200 			; <UNDEFINED> instruction: 0xff0a0200
     3c8:	0300000c 	movweq	r0, #12
     3cc:	0009180a 	andeq	r1, r9, sl, lsl #16
     3d0:	7b0a0400 	blvc	2813d8 <__bss_end+0x277c94>
     3d4:	0500000a 	streq	r0, [r0, #-10]
     3d8:	0007640a 	andeq	r6, r7, sl, lsl #8
     3dc:	05000600 	streq	r0, [r0, #-1536]	; 0xfffffa00
     3e0:	00000def 	andeq	r0, r0, pc, ror #27
     3e4:	38070304 	stmdacc	r7, {r2, r8, r9}
     3e8:	0b000000 	bleq	3f0 <shift+0x3f0>
     3ec:	00000c70 	andeq	r0, r0, r0, ror ip
     3f0:	65140504 	ldrvs	r0, [r4, #-1284]	; 0xfffffafc
     3f4:	05000000 	streq	r0, [r0, #-0]
     3f8:	00931c03 	addseq	r1, r3, r3, lsl #24
     3fc:	10100b00 	andsne	r0, r0, r0, lsl #22
     400:	06040000 	streq	r0, [r4], -r0
     404:	00006514 	andeq	r6, r0, r4, lsl r5
     408:	20030500 	andcs	r0, r3, r0, lsl #10
     40c:	0b000093 	bleq	660 <shift+0x660>
     410:	00000ae6 	andeq	r0, r0, r6, ror #21
     414:	651a0705 	ldrvs	r0, [sl, #-1797]	; 0xfffff8fb
     418:	05000000 	streq	r0, [r0, #-0]
     41c:	00932403 	addseq	r2, r3, r3, lsl #8
     420:	0e510b00 	vnmlseq.f64	d16, d1, d0
     424:	09050000 	stmdbeq	r5, {}	; <UNPREDICTABLE>
     428:	0000651a 	andeq	r6, r0, sl, lsl r5
     42c:	28030500 	stmdacs	r3, {r8, sl}
     430:	0b000093 	bleq	684 <shift+0x684>
     434:	00000aa9 	andeq	r0, r0, r9, lsr #21
     438:	651a0b05 	ldrvs	r0, [sl, #-2821]	; 0xfffff4fb
     43c:	05000000 	streq	r0, [r0, #-0]
     440:	00932c03 	addseq	r2, r3, r3, lsl #24
     444:	0ddc0b00 	vldreq	d16, [ip]
     448:	0d050000 	stceq	0, cr0, [r5, #-0]
     44c:	0000651a 	andeq	r6, r0, sl, lsl r5
     450:	30030500 	andcc	r0, r3, r0, lsl #10
     454:	0b000093 	bleq	6a8 <shift+0x6a8>
     458:	000006c4 	andeq	r0, r0, r4, asr #13
     45c:	651a0f05 	ldrvs	r0, [sl, #-3845]	; 0xfffff0fb
     460:	05000000 	streq	r0, [r0, #-0]
     464:	00933403 	addseq	r3, r3, r3, lsl #8
     468:	0ce50900 			; <UNDEFINED> instruction: 0x0ce50900
     46c:	04050000 	streq	r0, [r5], #-0
     470:	00000038 	andeq	r0, r0, r8, lsr r0
     474:	c40c1b05 	strgt	r1, [ip], #-2821	; 0xfffff4fb
     478:	0a000001 	beq	484 <shift+0x484>
     47c:	00000650 	andeq	r0, r0, r0, asr r6
     480:	11390a00 	teqne	r9, r0, lsl #20
     484:	0a010000 	beq	4048c <__bss_end+0x36d48>
     488:	000012f7 	strdeq	r1, [r0], -r7
     48c:	1b0c0002 	blne	30049c <__bss_end+0x2f6d58>
     490:	0d000004 	stceq	0, cr0, [r0, #-16]
     494:	000004e3 	andeq	r0, r0, r3, ror #9
     498:	07630590 			; <UNDEFINED> instruction: 0x07630590
     49c:	00000337 	andeq	r0, r0, r7, lsr r3
     4a0:	00062c07 	andeq	r2, r6, r7, lsl #24
     4a4:	67052400 	strvs	r2, [r5, -r0, lsl #8]
     4a8:	00025110 	andeq	r5, r2, r0, lsl r1
     4ac:	23130e00 	tstcs	r3, #0, 28
     4b0:	69050000 	stmdbvs	r5, {}	; <UNPREDICTABLE>
     4b4:	00033712 	andeq	r3, r3, r2, lsl r7
     4b8:	520e0000 	andpl	r0, lr, #0
     4bc:	05000008 	streq	r0, [r0, #-8]
     4c0:	0347126b 	movteq	r1, #29291	; 0x726b
     4c4:	0e100000 	cdpeq	0, 1, cr0, cr0, cr0, {0}
     4c8:	00000645 	andeq	r0, r0, r5, asr #12
     4cc:	59166d05 	ldmdbpl	r6, {r0, r2, r8, sl, fp, sp, lr}
     4d0:	14000000 	strne	r0, [r0], #-0
     4d4:	000e310e 	andeq	r3, lr, lr, lsl #2
     4d8:	1c700500 	cfldr64ne	mvdx0, [r0], #-0
     4dc:	0000034e 	andeq	r0, r0, lr, asr #6
     4e0:	12b40e18 	adcsne	r0, r4, #24, 28	; 0x180
     4e4:	72050000 	andvc	r0, r5, #0
     4e8:	00034e1c 	andeq	r4, r3, ip, lsl lr
     4ec:	de0e1c00 	cdple	12, 0, cr1, cr14, cr0, {0}
     4f0:	05000004 	streq	r0, [r0, #-4]
     4f4:	034e1c75 	movteq	r1, #60533	; 0xec75
     4f8:	0f200000 	svceq	0x00200000
     4fc:	00000ec6 	andeq	r0, r0, r6, asr #29
     500:	f71c7705 			; <UNDEFINED> instruction: 0xf71c7705
     504:	4e000011 	mcrmi	0, 0, r0, cr0, cr1, {0}
     508:	45000003 	strmi	r0, [r0, #-3]
     50c:	10000002 	andne	r0, r0, r2
     510:	0000034e 	andeq	r0, r0, lr, asr #6
     514:	00035411 	andeq	r5, r3, r1, lsl r4
     518:	07000000 	streq	r0, [r0, -r0]
     51c:	000012ec 	andeq	r1, r0, ip, ror #5
     520:	107b0518 	rsbsne	r0, fp, r8, lsl r5
     524:	00000286 	andeq	r0, r0, r6, lsl #5
     528:	0023130e 	eoreq	r1, r3, lr, lsl #6
     52c:	127e0500 	rsbsne	r0, lr, #0, 10
     530:	00000337 	andeq	r0, r0, r7, lsr r3
     534:	05380e00 	ldreq	r0, [r8, #-3584]!	; 0xfffff200
     538:	80050000 	andhi	r0, r5, r0
     53c:	00035419 	andeq	r5, r3, r9, lsl r4
     540:	820e1000 	andhi	r1, lr, #0
     544:	0500000a 	streq	r0, [r0, #-10]
     548:	035f2182 	cmpeq	pc, #-2147483616	; 0x80000020
     54c:	00140000 	andseq	r0, r4, r0
     550:	00025103 	andeq	r5, r2, r3, lsl #2
     554:	04911200 	ldreq	r1, [r1], #512	; 0x200
     558:	86050000 	strhi	r0, [r5], -r0
     55c:	00036521 	andeq	r6, r3, r1, lsr #10
     560:	087c1200 	ldmdaeq	ip!, {r9, ip}^
     564:	88050000 	stmdahi	r5, {}	; <UNPREDICTABLE>
     568:	0000651f 	andeq	r6, r0, pc, lsl r5
     56c:	0e630e00 	cdpeq	14, 6, cr0, cr3, cr0, {0}
     570:	8b050000 	blhi	140578 <__bss_end+0x136e34>
     574:	0001d617 	andeq	sp, r1, r7, lsl r6
     578:	b40e0000 	strlt	r0, [lr], #-0
     57c:	05000007 	streq	r0, [r0, #-7]
     580:	01d6178e 	bicseq	r1, r6, lr, lsl #15
     584:	0e240000 	cdpeq	0, 2, cr0, cr4, cr0, {0}
     588:	00000bf4 	strdeq	r0, [r0], -r4
     58c:	d6178f05 	ldrle	r8, [r7], -r5, lsl #30
     590:	48000001 	stmdami	r0, {r0}
     594:	0009dd0e 	andeq	sp, r9, lr, lsl #26
     598:	17900500 	ldrne	r0, [r0, r0, lsl #10]
     59c:	000001d6 	ldrdeq	r0, [r0], -r6
     5a0:	04e3136c 	strbteq	r1, [r3], #876	; 0x36c
     5a4:	93050000 	movwls	r0, #20480	; 0x5000
     5a8:	000d9f09 	andeq	r9, sp, r9, lsl #30
     5ac:	00037000 	andeq	r7, r3, r0
     5b0:	02f00100 	rscseq	r0, r0, #0, 2
     5b4:	02f60000 	rscseq	r0, r6, #0
     5b8:	70100000 	andsvc	r0, r0, r0
     5bc:	00000003 	andeq	r0, r0, r3
     5c0:	000ebb14 	andeq	fp, lr, r4, lsl fp
     5c4:	0e960500 	cdpeq	5, 9, cr0, cr6, cr0, {0}
     5c8:	00000519 	andeq	r0, r0, r9, lsl r5
     5cc:	00030b01 	andeq	r0, r3, r1, lsl #22
     5d0:	00031100 	andeq	r1, r3, r0, lsl #2
     5d4:	03701000 	cmneq	r0, #0
     5d8:	15000000 	strne	r0, [r0, #-0]
     5dc:	0000084d 	andeq	r0, r0, sp, asr #16
     5e0:	ca109905 	bgt	4269fc <__bss_end+0x41d2b8>
     5e4:	7600000c 	strvc	r0, [r0], -ip
     5e8:	01000003 	tsteq	r0, r3
     5ec:	00000326 	andeq	r0, r0, r6, lsr #6
     5f0:	00037010 	andeq	r7, r3, r0, lsl r0
     5f4:	03541100 	cmpeq	r4, #0, 2
     5f8:	9f110000 	svcls	0x00110000
     5fc:	00000001 	andeq	r0, r0, r1
     600:	00251600 	eoreq	r1, r5, r0, lsl #12
     604:	03470000 	movteq	r0, #28672	; 0x7000
     608:	6a170000 	bvs	5c0610 <__bss_end+0x5b6ecc>
     60c:	0f000000 	svceq	0x00000000
     610:	02010200 	andeq	r0, r1, #0, 4
     614:	00000b8f 	andeq	r0, r0, pc, lsl #23
     618:	01d60418 	bicseq	r0, r6, r8, lsl r4
     61c:	04180000 	ldreq	r0, [r8], #-0
     620:	0000002c 	andeq	r0, r0, ip, lsr #32
     624:	0011cc0c 	andseq	ip, r1, ip, lsl #24
     628:	5a041800 	bpl	106630 <__bss_end+0xfceec>
     62c:	16000003 	strne	r0, [r0], -r3
     630:	00000286 	andeq	r0, r0, r6, lsl #5
     634:	00000370 	andeq	r0, r0, r0, ror r3
     638:	04180019 	ldreq	r0, [r8], #-25	; 0xffffffe7
     63c:	000001c9 	andeq	r0, r0, r9, asr #3
     640:	01c40418 	biceq	r0, r4, r8, lsl r4
     644:	af1a0000 	svcge	0x001a0000
     648:	0500000e 	streq	r0, [r0, #-14]
     64c:	01c9149c 			; <UNDEFINED> instruction: 0x01c9149c
     650:	5a0b0000 	bpl	2c0658 <__bss_end+0x2b6f14>
     654:	06000006 	streq	r0, [r0], -r6
     658:	00651404 	rsbeq	r1, r5, r4, lsl #8
     65c:	03050000 	movweq	r0, #20480	; 0x5000
     660:	00009338 	andeq	r9, r0, r8, lsr r3
     664:	000f170b 	andeq	r1, pc, fp, lsl #14
     668:	14070600 	strne	r0, [r7], #-1536	; 0xfffffa00
     66c:	00000065 	andeq	r0, r0, r5, rrx
     670:	933c0305 	teqls	ip, #335544320	; 0x14000000
     674:	060b0000 	streq	r0, [fp], -r0
     678:	06000005 	streq	r0, [r0], -r5
     67c:	0065140a 	rsbeq	r1, r5, sl, lsl #8
     680:	03050000 	movweq	r0, #20480	; 0x5000
     684:	00009340 	andeq	r9, r0, r0, asr #6
     688:	00076909 	andeq	r6, r7, r9, lsl #18
     68c:	38040500 	stmdacc	r4, {r8, sl}
     690:	06000000 	streq	r0, [r0], -r0
     694:	03f50c0d 	mvnseq	r0, #3328	; 0xd00
     698:	4e1b0000 	cdpmi	0, 1, cr0, cr11, cr0, {0}
     69c:	00007765 	andeq	r7, r0, r5, ror #14
     6a0:	0009300a 	andeq	r3, r9, sl
     6a4:	fe0a0100 	cdp2	1, 0, cr0, cr10, cr0, {0}
     6a8:	02000004 	andeq	r0, r0, #4
     6ac:	0007820a 	andeq	r8, r7, sl, lsl #4
     6b0:	bf0a0300 	svclt	0x000a0300
     6b4:	04000010 	streq	r0, [r0], #-16
     6b8:	0004d70a 	andeq	sp, r4, sl, lsl #14
     6bc:	07000500 	streq	r0, [r0, -r0, lsl #10]
     6c0:	00000673 	andeq	r0, r0, r3, ror r6
     6c4:	081b0610 	ldmdaeq	fp, {r4, r9, sl}
     6c8:	00000434 	andeq	r0, r0, r4, lsr r4
     6cc:	00726c08 	rsbseq	r6, r2, r8, lsl #24
     6d0:	34131d06 	ldrcc	r1, [r3], #-3334	; 0xfffff2fa
     6d4:	00000004 	andeq	r0, r0, r4
     6d8:	00707308 	rsbseq	r7, r0, r8, lsl #6
     6dc:	34131e06 	ldrcc	r1, [r3], #-3590	; 0xfffff1fa
     6e0:	04000004 	streq	r0, [r0], #-4
     6e4:	00637008 	rsbeq	r7, r3, r8
     6e8:	34131f06 	ldrcc	r1, [r3], #-3846	; 0xfffff0fa
     6ec:	08000004 	stmdaeq	r0, {r2}
     6f0:	000ed10e 	andeq	sp, lr, lr, lsl #2
     6f4:	13200600 	nopne	{0}	; <UNPREDICTABLE>
     6f8:	00000434 	andeq	r0, r0, r4, lsr r4
     6fc:	0402000c 	streq	r0, [r2], #-12
     700:	001f9e07 	andseq	r9, pc, r7, lsl #28
     704:	04340300 	ldrteq	r0, [r4], #-768	; 0xfffffd00
     708:	fc070000 	stc2	0, cr0, [r7], {-0}
     70c:	70000008 	andvc	r0, r0, r8
     710:	d0082806 	andle	r2, r8, r6, lsl #16
     714:	0e000004 	cdpeq	0, 0, cr0, cr0, cr4, {0}
     718:	000007fc 	strdeq	r0, [r0], -ip
     71c:	f5122a06 			; <UNDEFINED> instruction: 0xf5122a06
     720:	00000003 	andeq	r0, r0, r3
     724:	64697008 	strbtvs	r7, [r9], #-8
     728:	122b0600 	eorne	r0, fp, #0, 12
     72c:	0000006a 	andeq	r0, r0, sl, rrx
     730:	1cef0e10 	stclne	14, cr0, [pc], #64	; 778 <shift+0x778>
     734:	2c060000 	stccs	0, cr0, [r6], {-0}
     738:	0003be11 	andeq	fp, r3, r1, lsl lr
     73c:	a30e1400 	movwge	r1, #58368	; 0xe400
     740:	06000010 			; <UNDEFINED> instruction: 0x06000010
     744:	006a122d 	rsbeq	r1, sl, sp, lsr #4
     748:	0e180000 	cdpeq	0, 1, cr0, cr8, cr0, {0}
     74c:	000003ab 	andeq	r0, r0, fp, lsr #7
     750:	6a122e06 	bvs	48bf70 <__bss_end+0x48282c>
     754:	1c000000 	stcne	0, cr0, [r0], {-0}
     758:	000f040e 	andeq	r0, pc, lr, lsl #8
     75c:	0c2f0600 	stceq	6, cr0, [pc], #-0	; 764 <shift+0x764>
     760:	000004d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     764:	04870e20 	streq	r0, [r7], #3616	; 0xe20
     768:	30060000 	andcc	r0, r6, r0
     76c:	00003809 	andeq	r3, r0, r9, lsl #16
     770:	4e0e6000 	cdpmi	0, 0, cr6, cr14, cr0, {0}
     774:	0600000b 	streq	r0, [r0], -fp
     778:	00590e31 	subseq	r0, r9, r1, lsr lr
     77c:	0e640000 	cdpeq	0, 6, cr0, cr4, cr0, {0}
     780:	00000d73 	andeq	r0, r0, r3, ror sp
     784:	590e3306 	stmdbpl	lr, {r1, r2, r8, r9, ip, sp}
     788:	68000000 	stmdavs	r0, {}	; <UNPREDICTABLE>
     78c:	000d6a0e 	andeq	r6, sp, lr, lsl #20
     790:	0e340600 	cfmsuba32eq	mvax0, mvax0, mvfx4, mvfx0
     794:	00000059 	andeq	r0, r0, r9, asr r0
     798:	7616006c 	ldrvc	r0, [r6], -ip, rrx
     79c:	e0000003 	and	r0, r0, r3
     7a0:	17000004 	strne	r0, [r0, -r4]
     7a4:	0000006a 	andeq	r0, r0, sl, rrx
     7a8:	ef0b000f 	svc	0x000b000f
     7ac:	07000004 	streq	r0, [r0, -r4]
     7b0:	0065140a 	rsbeq	r1, r5, sl, lsl #8
     7b4:	03050000 	movweq	r0, #20480	; 0x5000
     7b8:	00009344 	andeq	r9, r0, r4, asr #6
     7bc:	000b3909 	andeq	r3, fp, r9, lsl #18
     7c0:	38040500 	stmdacc	r4, {r8, sl}
     7c4:	07000000 	streq	r0, [r0, -r0]
     7c8:	05110c0d 	ldreq	r0, [r1, #-3085]	; 0xfffff3f3
     7cc:	020a0000 	andeq	r0, sl, #0
     7d0:	00000013 	andeq	r0, r0, r3, lsl r0
     7d4:	00116e0a 	andseq	r6, r1, sl, lsl #28
     7d8:	07000100 	streq	r0, [r0, -r0, lsl #2]
     7dc:	000007e1 	andeq	r0, r0, r1, ror #15
     7e0:	081b070c 	ldmdaeq	fp, {r2, r3, r8, r9, sl}
     7e4:	00000546 	andeq	r0, r0, r6, asr #10
     7e8:	00058c0e 	andeq	r8, r5, lr, lsl #24
     7ec:	191d0700 	ldmdbne	sp, {r8, r9, sl}
     7f0:	00000546 	andeq	r0, r0, r6, asr #10
     7f4:	04de0e00 	ldrbeq	r0, [lr], #3584	; 0xe00
     7f8:	1e070000 	cdpne	0, 0, cr0, cr7, cr0, {0}
     7fc:	00054619 	andeq	r4, r5, r9, lsl r6
     800:	690e0400 	stmdbvs	lr, {sl}
     804:	0700000b 	streq	r0, [r0, -fp]
     808:	054c131f 	strbeq	r1, [ip, #-799]	; 0xfffffce1
     80c:	00080000 	andeq	r0, r8, r0
     810:	05110418 	ldreq	r0, [r1, #-1048]	; 0xfffffbe8
     814:	04180000 	ldreq	r0, [r8], #-0
     818:	00000440 	andeq	r0, r0, r0, asr #8
     81c:	000e720d 	andeq	r7, lr, sp, lsl #4
     820:	22071400 	andcs	r1, r7, #0, 8
     824:	0007d407 	andeq	sp, r7, r7, lsl #8
     828:	0c7e0e00 	ldcleq	14, cr0, [lr], #-0
     82c:	26070000 	strcs	r0, [r7], -r0
     830:	00005912 	andeq	r5, r0, r2, lsl r9
     834:	110e0000 	mrsne	r0, (UNDEF: 14)
     838:	0700000c 	streq	r0, [r0, -ip]
     83c:	05461d29 	strbeq	r1, [r6, #-3369]	; 0xfffff2d7
     840:	0e040000 	cdpeq	0, 0, cr0, cr4, cr0, {0}
     844:	0000078a 	andeq	r0, r0, sl, lsl #15
     848:	461d2c07 	ldrmi	r2, [sp], -r7, lsl #24
     84c:	08000005 	stmdaeq	r0, {r0, r2}
     850:	000cf51c 	andeq	pc, ip, ip, lsl r5	; <UNPREDICTABLE>
     854:	0e2f0700 	cdpeq	7, 2, cr0, cr15, cr0, {0}
     858:	000007be 			; <UNDEFINED> instruction: 0x000007be
     85c:	0000059a 	muleq	r0, sl, r5
     860:	000005a5 	andeq	r0, r0, r5, lsr #11
     864:	0007d910 	andeq	sp, r7, r0, lsl r9
     868:	05461100 	strbeq	r1, [r6, #-256]	; 0xffffff00
     86c:	1d000000 	stcne	0, cr0, [r0, #-0]
     870:	00000939 	andeq	r0, r0, r9, lsr r9
     874:	d30e3107 	movwle	r3, #57607	; 0xe107
     878:	47000008 	strmi	r0, [r0, -r8]
     87c:	bd000003 	stclt	0, cr0, [r0, #-12]
     880:	c8000005 	stmdagt	r0, {r0, r2}
     884:	10000005 	andne	r0, r0, r5
     888:	000007d9 	ldrdeq	r0, [r0], -r9
     88c:	00054c11 	andeq	r4, r5, r1, lsl ip
     890:	1a130000 	bne	4c0898 <__bss_end+0x4b7154>
     894:	07000011 	smladeq	r0, r1, r0, r0
     898:	0b141d35 	bleq	507d74 <__bss_end+0x4fe630>
     89c:	05460000 	strbeq	r0, [r6, #-0]
     8a0:	e1020000 	mrs	r0, (UNDEF: 2)
     8a4:	e7000005 	str	r0, [r0, -r5]
     8a8:	10000005 	andne	r0, r0, r5
     8ac:	000007d9 	ldrdeq	r0, [r0], -r9
     8b0:	07751300 	ldrbeq	r1, [r5, -r0, lsl #6]!
     8b4:	37070000 	strcc	r0, [r7, -r0]
     8b8:	000d051d 	andeq	r0, sp, sp, lsl r5
     8bc:	00054600 	andeq	r4, r5, r0, lsl #12
     8c0:	06000200 	streq	r0, [r0], -r0, lsl #4
     8c4:	06060000 	streq	r0, [r6], -r0
     8c8:	d9100000 	ldmdble	r0, {}	; <UNPREDICTABLE>
     8cc:	00000007 	andeq	r0, r0, r7
     8d0:	000c241e 	andeq	r2, ip, lr, lsl r4
     8d4:	31390700 	teqcc	r9, r0, lsl #14
     8d8:	000007f2 	strdeq	r0, [r0], -r2
     8dc:	7213020c 	andsvc	r0, r3, #12, 4	; 0xc0000000
     8e0:	0700000e 	streq	r0, [r0, -lr]
     8e4:	0948093c 	stmdbeq	r8, {r2, r3, r4, r5, r8, fp}^
     8e8:	07d90000 	ldrbeq	r0, [r9, r0]
     8ec:	2d010000 	stccs	0, cr0, [r1, #-0]
     8f0:	33000006 	movwcc	r0, #6
     8f4:	10000006 	andne	r0, r0, r6
     8f8:	000007d9 	ldrdeq	r0, [r0], -r9
     8fc:	080e1300 	stmdaeq	lr, {r8, r9, ip}
     900:	3f070000 	svccc	0x00070000
     904:	00056112 	andeq	r6, r5, r2, lsl r1
     908:	00005900 	andeq	r5, r0, r0, lsl #18
     90c:	064c0100 	strbeq	r0, [ip], -r0, lsl #2
     910:	06610000 	strbteq	r0, [r1], -r0
     914:	d9100000 	ldmdble	r0, {}	; <UNPREDICTABLE>
     918:	11000007 	tstne	r0, r7
     91c:	000007fb 	strdeq	r0, [r0], -fp
     920:	00006a11 	andeq	r6, r0, r1, lsl sl
     924:	03471100 	movteq	r1, #28928	; 0x7100
     928:	14000000 	strne	r0, [r0], #-0
     92c:	00001144 	andeq	r1, r0, r4, asr #2
     930:	800e4207 	andhi	r4, lr, r7, lsl #4
     934:	01000006 	tsteq	r0, r6
     938:	00000676 	andeq	r0, r0, r6, ror r6
     93c:	0000067c 	andeq	r0, r0, ip, ror r6
     940:	0007d910 	andeq	sp, r7, r0, lsl r9
     944:	43130000 	tstmi	r3, #0
     948:	07000005 	streq	r0, [r0, -r5]
     94c:	05fe1745 	ldrbeq	r1, [lr, #1861]!	; 0x745
     950:	054c0000 	strbeq	r0, [ip, #-0]
     954:	95010000 	strls	r0, [r1, #-0]
     958:	9b000006 	blls	978 <shift+0x978>
     95c:	10000006 	andne	r0, r0, r6
     960:	00000801 	andeq	r0, r0, r1, lsl #16
     964:	0f221300 	svceq	0x00221300
     968:	48070000 	stmdami	r7, {}	; <UNPREDICTABLE>
     96c:	0003c117 	andeq	ip, r3, r7, lsl r1
     970:	00054c00 	andeq	r4, r5, r0, lsl #24
     974:	06b40100 	ldrteq	r0, [r4], r0, lsl #2
     978:	06bf0000 	ldrteq	r0, [pc], r0
     97c:	01100000 	tsteq	r0, r0
     980:	11000008 	tstne	r0, r8
     984:	00000059 	andeq	r0, r0, r9, asr r0
     988:	06ce1400 	strbeq	r1, [lr], r0, lsl #8
     98c:	4b070000 	blmi	1c0994 <__bss_end+0x1b7250>
     990:	000c320e 	andeq	r3, ip, lr, lsl #4
     994:	06d40100 	ldrbeq	r0, [r4], r0, lsl #2
     998:	06da0000 	ldrbeq	r0, [sl], r0
     99c:	d9100000 	ldmdble	r0, {}	; <UNPREDICTABLE>
     9a0:	00000007 	andeq	r0, r0, r7
     9a4:	00093913 	andeq	r3, r9, r3, lsl r9
     9a8:	0e4d0700 	cdpeq	7, 4, cr0, cr13, cr0, {0}
     9ac:	00000db4 			; <UNDEFINED> instruction: 0x00000db4
     9b0:	00000347 	andeq	r0, r0, r7, asr #6
     9b4:	0006f301 	andeq	pc, r6, r1, lsl #6
     9b8:	0006fe00 	andeq	pc, r6, r0, lsl #28
     9bc:	07d91000 	ldrbeq	r1, [r9, r0]
     9c0:	59110000 	ldmdbpl	r1, {}	; <UNPREDICTABLE>
     9c4:	00000000 	andeq	r0, r0, r0
     9c8:	0004c313 	andeq	ip, r4, r3, lsl r3
     9cc:	12500700 	subsne	r0, r0, #0, 14
     9d0:	000003ee 	andeq	r0, r0, lr, ror #7
     9d4:	00000059 	andeq	r0, r0, r9, asr r0
     9d8:	00071701 	andeq	r1, r7, r1, lsl #14
     9dc:	00072200 	andeq	r2, r7, r0, lsl #4
     9e0:	07d91000 	ldrbeq	r1, [r9, r0]
     9e4:	76110000 	ldrvc	r0, [r1], -r0
     9e8:	00000003 	andeq	r0, r0, r3
     9ec:	00042113 	andeq	r2, r4, r3, lsl r1
     9f0:	0e530700 	cdpeq	7, 5, cr0, cr3, cr0, {0}
     9f4:	0000119a 	muleq	r0, sl, r1
     9f8:	00000347 	andeq	r0, r0, r7, asr #6
     9fc:	00073b01 	andeq	r3, r7, r1, lsl #22
     a00:	00074600 	andeq	r4, r7, r0, lsl #12
     a04:	07d91000 	ldrbeq	r1, [r9, r0]
     a08:	59110000 	ldmdbpl	r1, {}	; <UNPREDICTABLE>
     a0c:	00000000 	andeq	r0, r0, r0
     a10:	00049d14 	andeq	r9, r4, r4, lsl sp
     a14:	0e560700 	cdpeq	7, 5, cr0, cr6, cr0, {0}
     a18:	0000101c 	andeq	r1, r0, ip, lsl r0
     a1c:	00075b01 	andeq	r5, r7, r1, lsl #22
     a20:	00077a00 	andeq	r7, r7, r0, lsl #20
     a24:	07d91000 	ldrbeq	r1, [r9, r0]
     a28:	a1110000 	tstge	r1, r0
     a2c:	11000000 	mrsne	r0, (UNDEF: 0)
     a30:	00000059 	andeq	r0, r0, r9, asr r0
     a34:	00005911 	andeq	r5, r0, r1, lsl r9
     a38:	00591100 	subseq	r1, r9, r0, lsl #2
     a3c:	07110000 	ldreq	r0, [r1, -r0]
     a40:	00000008 	andeq	r0, r0, r8
     a44:	00122714 	andseq	r2, r2, r4, lsl r7
     a48:	0e580700 	cdpeq	7, 5, cr0, cr8, cr0, {0}
     a4c:	00001317 	andeq	r1, r0, r7, lsl r3
     a50:	00078f01 	andeq	r8, r7, r1, lsl #30
     a54:	0007ae00 	andeq	sl, r7, r0, lsl #28
     a58:	07d91000 	ldrbeq	r1, [r9, r0]
     a5c:	d8110000 	ldmdale	r1, {}	; <UNPREDICTABLE>
     a60:	11000000 	mrsne	r0, (UNDEF: 0)
     a64:	00000059 	andeq	r0, r0, r9, asr r0
     a68:	00005911 	andeq	r5, r0, r1, lsl r9
     a6c:	00591100 	subseq	r1, r9, r0, lsl #2
     a70:	07110000 	ldreq	r0, [r1, -r0]
     a74:	00000008 	andeq	r0, r0, r8
     a78:	0004b015 	andeq	fp, r4, r5, lsl r0
     a7c:	0e5b0700 	cdpeq	7, 5, cr0, cr11, cr0, {0}
     a80:	00000b94 	muleq	r0, r4, fp
     a84:	00000347 	andeq	r0, r0, r7, asr #6
     a88:	0007c301 	andeq	ip, r7, r1, lsl #6
     a8c:	07d91000 	ldrbeq	r1, [r9, r0]
     a90:	f2110000 	vhadd.s16	d0, d1, d0
     a94:	11000004 	tstne	r0, r4
     a98:	0000080d 	andeq	r0, r0, sp, lsl #16
     a9c:	52030000 	andpl	r0, r3, #0
     aa0:	18000005 	stmdane	r0, {r0, r2}
     aa4:	00055204 	andeq	r5, r5, r4, lsl #4
     aa8:	05461f00 	strbeq	r1, [r6, #-3840]	; 0xfffff100
     aac:	07ec0000 	strbeq	r0, [ip, r0]!
     ab0:	07f20000 	ldrbeq	r0, [r2, r0]!
     ab4:	d9100000 	ldmdble	r0, {}	; <UNPREDICTABLE>
     ab8:	00000007 	andeq	r0, r0, r7
     abc:	00055220 	andeq	r5, r5, r0, lsr #4
     ac0:	0007df00 	andeq	sp, r7, r0, lsl #30
     ac4:	3f041800 	svccc	0x00041800
     ac8:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
     acc:	0007d404 	andeq	sp, r7, r4, lsl #8
     ad0:	7b042100 	blvc	108ed8 <__bss_end+0xff794>
     ad4:	22000000 	andcs	r0, r0, #0
     ad8:	12891a04 	addne	r1, r9, #4, 20	; 0x4000
     adc:	5e070000 	cdppl	0, 0, cr0, cr7, cr0, {0}
     ae0:	00055219 	andeq	r5, r5, r9, lsl r2
     ae4:	0e430d00 	cdpeq	13, 4, cr0, cr3, cr0, {0}
     ae8:	08080000 	stmdaeq	r8, {}	; <UNPREDICTABLE>
     aec:	095f0706 	ldmdbeq	pc, {r1, r2, r8, r9, sl}^	; <UNPREDICTABLE>
     af0:	1e0e0000 	cdpne	0, 0, cr0, cr14, cr0, {0}
     af4:	08000009 	stmdaeq	r0, {r0, r3}
     af8:	0059120a 	subseq	r1, r9, sl, lsl #4
     afc:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     b00:	00000d97 	muleq	r0, r7, sp
     b04:	470e0c08 	strmi	r0, [lr, -r8, lsl #24]
     b08:	04000003 	streq	r0, [r0], #-3
     b0c:	000e4313 	andeq	r4, lr, r3, lsl r3
     b10:	09100800 	ldmdbeq	r0, {fp}
     b14:	000006a1 	andeq	r0, r0, r1, lsr #13
     b18:	00000964 	andeq	r0, r0, r4, ror #18
     b1c:	00085b01 	andeq	r5, r8, r1, lsl #22
     b20:	00086600 	andeq	r6, r8, r0, lsl #12
     b24:	09641000 	stmdbeq	r4!, {ip}^
     b28:	54110000 	ldrpl	r0, [r1], #-0
     b2c:	00000003 	andeq	r0, r0, r3
     b30:	000e4213 	andeq	r4, lr, r3, lsl r2
     b34:	15120800 	ldrne	r0, [r2, #-2048]	; 0xfffff800
     b38:	00000dfa 	strdeq	r0, [r0], -sl
     b3c:	0000080d 	andeq	r0, r0, sp, lsl #16
     b40:	00087f01 	andeq	r7, r8, r1, lsl #30
     b44:	00088a00 	andeq	r8, r8, r0, lsl #20
     b48:	09641000 	stmdbeq	r4!, {ip}^
     b4c:	38100000 	ldmdacc	r0, {}	; <UNPREDICTABLE>
     b50:	00000000 	andeq	r0, r0, r0
     b54:	0006ba13 	andeq	fp, r6, r3, lsl sl
     b58:	0e150800 	cdpeq	8, 1, cr0, cr5, cr0, {0}
     b5c:	00000a1b 	andeq	r0, r0, fp, lsl sl
     b60:	00000347 	andeq	r0, r0, r7, asr #6
     b64:	0008a301 	andeq	sl, r8, r1, lsl #6
     b68:	0008a900 	andeq	sl, r8, r0, lsl #18
     b6c:	096a1000 	stmdbeq	sl!, {ip}^
     b70:	14000000 	strne	r0, [r0], #-0
     b74:	00000fa7 	andeq	r0, r0, r7, lsr #31
     b78:	b90e1808 	stmdblt	lr, {r3, fp, ip}
     b7c:	01000008 	tsteq	r0, r8
     b80:	000008be 			; <UNDEFINED> instruction: 0x000008be
     b84:	000008c4 	andeq	r0, r0, r4, asr #17
     b88:	00096410 	andeq	r6, r9, r0, lsl r4
     b8c:	15140000 	ldrne	r0, [r4, #-0]
     b90:	0800000a 	stmdaeq	r0, {r1, r3}
     b94:	07360e1b 			; <UNDEFINED> instruction: 0x07360e1b
     b98:	d9010000 	stmdble	r1, {}	; <UNPREDICTABLE>
     b9c:	e4000008 	str	r0, [r0], #-8
     ba0:	10000008 	andne	r0, r0, r8
     ba4:	00000964 	andeq	r0, r0, r4, ror #18
     ba8:	00034711 	andeq	r4, r3, r1, lsl r7
     bac:	99140000 	ldmdbls	r4, {}	; <UNPREDICTABLE>
     bb0:	08000010 	stmdaeq	r0, {r4}
     bb4:	11790e1d 	cmnne	r9, sp, lsl lr
     bb8:	f9010000 			; <UNDEFINED> instruction: 0xf9010000
     bbc:	0e000008 	cdpeq	0, 0, cr0, cr0, cr8, {0}
     bc0:	10000009 	andne	r0, r0, r9
     bc4:	00000964 	andeq	r0, r0, r4, ror #18
     bc8:	00004611 	andeq	r4, r0, r1, lsl r6
     bcc:	00461100 	subeq	r1, r6, r0, lsl #2
     bd0:	47110000 	ldrmi	r0, [r1, -r0]
     bd4:	00000003 	andeq	r0, r0, r3
     bd8:	00075b14 	andeq	r5, r7, r4, lsl fp
     bdc:	0e1f0800 	cdpeq	8, 1, cr0, cr15, cr0, {0}
     be0:	00000591 	muleq	r0, r1, r5
     be4:	00092301 	andeq	r2, r9, r1, lsl #6
     be8:	00093800 	andeq	r3, r9, r0, lsl #16
     bec:	09641000 	stmdbeq	r4!, {ip}^
     bf0:	46110000 	ldrmi	r0, [r1], -r0
     bf4:	11000000 	mrsne	r0, (UNDEF: 0)
     bf8:	00000046 	andeq	r0, r0, r6, asr #32
     bfc:	00002511 	andeq	r2, r0, r1, lsl r5
     c00:	95230000 	strls	r0, [r3, #-0]!
     c04:	08000012 	stmdaeq	r0, {r1, r4}
     c08:	0f590e21 	svceq	0x00590e21
     c0c:	49010000 	stmdbmi	r1, {}	; <UNPREDICTABLE>
     c10:	10000009 	andne	r0, r0, r9
     c14:	00000964 	andeq	r0, r0, r4, ror #18
     c18:	00004611 	andeq	r4, r0, r1, lsl r6
     c1c:	00461100 	subeq	r1, r6, r0, lsl #2
     c20:	54110000 	ldrpl	r0, [r1], #-0
     c24:	00000003 	andeq	r0, r0, r3
     c28:	081b0300 	ldmdaeq	fp, {r8, r9}
     c2c:	04180000 	ldreq	r0, [r8], #-0
     c30:	0000081b 	andeq	r0, r0, fp, lsl r8
     c34:	095f0418 	ldmdbeq	pc, {r3, r4, sl}^	; <UNPREDICTABLE>
     c38:	68240000 	stmdavs	r4!, {}	; <UNPREDICTABLE>
     c3c:	09006c61 	stmdbeq	r0, {r0, r5, r6, sl, fp, sp, lr}
     c40:	0a2a0b05 	beq	a8385c <__bss_end+0xa7a118>
     c44:	e1250000 			; <UNDEFINED> instruction: 0xe1250000
     c48:	0900000b 	stmdbeq	r0, {r0, r1, r3}
     c4c:	00711907 	rsbseq	r1, r1, r7, lsl #18
     c50:	b2800000 	addlt	r0, r0, #0
     c54:	35250ee6 	strcc	r0, [r5, #-3814]!	; 0xfffff11a
     c58:	0900000f 	stmdbeq	r0, {r0, r1, r2, r3}
     c5c:	043b1a0a 	ldrteq	r1, [fp], #-2570	; 0xfffff5f6
     c60:	00000000 	andeq	r0, r0, r0
     c64:	57252000 	strpl	r2, [r5, -r0]!
     c68:	09000005 	stmdbeq	r0, {r0, r2}
     c6c:	043b1a0d 	ldrteq	r1, [fp], #-2573	; 0xfffff5f3
     c70:	00000000 	andeq	r0, r0, r0
     c74:	5a262020 	bpl	988cfc <__bss_end+0x97f5b8>
     c78:	0900000b 	stmdbeq	r0, {r0, r1, r3}
     c7c:	00651510 	rsbeq	r1, r5, r0, lsl r5
     c80:	25360000 	ldrcs	r0, [r6, #-0]!
     c84:	00001126 	andeq	r1, r0, r6, lsr #2
     c88:	3b1a4209 	blcc	6914b4 <__bss_end+0x687d70>
     c8c:	00000004 	andeq	r0, r0, r4
     c90:	25202150 	strcs	r2, [r0, #-336]!	; 0xfffffeb0
     c94:	000012d2 	ldrdeq	r1, [r0], -r2
     c98:	3b1a7109 	blcc	69d0c4 <__bss_end+0x693980>
     c9c:	00000004 	andeq	r0, r0, r4
     ca0:	252000b2 	strcs	r0, [r0, #-178]!	; 0xffffff4e
     ca4:	00000871 	andeq	r0, r0, r1, ror r8
     ca8:	3b1aa409 	blcc	6a9cd4 <__bss_end+0x6a0590>
     cac:	00000004 	andeq	r0, r0, r4
     cb0:	252000b4 	strcs	r0, [r0, #-180]!	; 0xffffff4c
     cb4:	00000bd7 	ldrdeq	r0, [r0], -r7
     cb8:	3b1ab309 	blcc	6ad8e4 <__bss_end+0x6a41a0>
     cbc:	00000004 	andeq	r0, r0, r4
     cc0:	25201040 	strcs	r1, [r0, #-64]!	; 0xffffffc0
     cc4:	00000d3e 	andeq	r0, r0, lr, lsr sp
     cc8:	3b1abe09 	blcc	6b04f4 <__bss_end+0x6a6db0>
     ccc:	00000004 	andeq	r0, r0, r4
     cd0:	25202050 	strcs	r2, [r0, #-80]!	; 0xffffffb0
     cd4:	00000751 	andeq	r0, r0, r1, asr r7
     cd8:	3b1abf09 	blcc	6b0904 <__bss_end+0x6a71c0>
     cdc:	00000004 	andeq	r0, r0, r4
     ce0:	25208040 	strcs	r8, [r0, #-64]!	; 0xffffffc0
     ce4:	0000112f 	andeq	r1, r0, pc, lsr #2
     ce8:	3b1ac009 	blcc	6b0d14 <__bss_end+0x6a75d0>
     cec:	00000004 	andeq	r0, r0, r4
     cf0:	00208050 	eoreq	r8, r0, r0, asr r0
     cf4:	00097c27 	andeq	r7, r9, r7, lsr #24
     cf8:	098c2700 	stmibeq	ip, {r8, r9, sl, sp}
     cfc:	9c270000 	stcls	0, cr0, [r7], #-0
     d00:	27000009 	strcs	r0, [r0, -r9]
     d04:	000009ac 	andeq	r0, r0, ip, lsr #19
     d08:	0009b927 	andeq	fp, r9, r7, lsr #18
     d0c:	09c92700 	stmibeq	r9, {r8, r9, sl, sp}^
     d10:	d9270000 	stmdble	r7!, {}	; <UNPREDICTABLE>
     d14:	27000009 	strcs	r0, [r0, -r9]
     d18:	000009e9 	andeq	r0, r0, r9, ror #19
     d1c:	0009f927 	andeq	pc, r9, r7, lsr #18
     d20:	0a092700 	beq	24a928 <__bss_end+0x2411e4>
     d24:	19270000 	stmdbne	r7!, {}	; <UNPREDICTABLE>
     d28:	0b00000a 	bleq	d58 <shift+0xd58>
     d2c:	00000fac 	andeq	r0, r0, ip, lsr #31
     d30:	6514080a 	ldrvs	r0, [r4, #-2058]	; 0xfffff7f6
     d34:	05000000 	streq	r0, [r0, #-0]
     d38:	00937403 	addseq	r7, r3, r3, lsl #8
     d3c:	0cb10900 			; <UNDEFINED> instruction: 0x0cb10900
     d40:	04070000 	streq	r0, [r7], #-0
     d44:	0000006a 	andeq	r0, r0, sl, rrx
     d48:	bc0c0b0a 			; <UNDEFINED> instruction: 0xbc0c0b0a
     d4c:	0a00000a 	beq	d7c <shift+0xd7c>
     d50:	00000cc4 	andeq	r0, r0, r4, asr #25
     d54:	063e0a00 	ldrteq	r0, [lr], -r0, lsl #20
     d58:	0a010000 	beq	40d60 <__bss_end+0x3761c>
     d5c:	000011f1 	strdeq	r1, [r0], -r1	; <UNPREDICTABLE>
     d60:	11eb0a02 	mvnne	r0, r2, lsl #20
     d64:	0a030000 	beq	c0d6c <__bss_end+0xb7628>
     d68:	000011c6 	andeq	r1, r0, r6, asr #3
     d6c:	12ae0a04 	adcne	r0, lr, #4, 20	; 0x4000
     d70:	0a050000 	beq	140d78 <__bss_end+0x137634>
     d74:	000011df 	ldrdeq	r1, [r0], -pc	; <UNPREDICTABLE>
     d78:	11e50a06 	mvnne	r0, r6, lsl #20
     d7c:	0a070000 	beq	1c0d84 <__bss_end+0x1b7640>
     d80:	00000e83 	andeq	r0, r0, r3, lsl #29
     d84:	66090008 	strvs	r0, [r9], -r8
     d88:	0500000a 	streq	r0, [r0, #-10]
     d8c:	00003804 	andeq	r3, r0, r4, lsl #16
     d90:	0c1d0a00 			; <UNDEFINED> instruction: 0x0c1d0a00
     d94:	00000ae7 	andeq	r0, r0, r7, ror #21
     d98:	000d480a 	andeq	r4, sp, sl, lsl #16
     d9c:	8a0a0000 	bhi	280da4 <__bss_end+0x277660>
     da0:	0100000d 	tsteq	r0, sp
     da4:	000d650a 	andeq	r6, sp, sl, lsl #10
     da8:	4c1b0200 	lfmmi	f0, 4, [fp], {-0}
     dac:	0300776f 	movweq	r7, #1903	; 0x76f
     db0:	12a00d00 	adcne	r0, r0, #0, 26
     db4:	0a1c0000 	beq	700dbc <__bss_end+0x6f7678>
     db8:	0e680728 	cdpeq	7, 6, cr0, cr8, cr8, {1}
     dbc:	9d070000 	stcls	0, cr0, [r7, #-0]
     dc0:	10000003 	andne	r0, r0, r3
     dc4:	360a330a 	strcc	r3, [sl], -sl, lsl #6
     dc8:	0e00000b 	cdpeq	0, 0, cr0, cr0, cr11, {0}
     dcc:	00001388 	andeq	r1, r0, r8, lsl #7
     dd0:	760b350a 	strvc	r3, [fp], -sl, lsl #10
     dd4:	00000003 	andeq	r0, r0, r3
     dd8:	0007f40e 	andeq	pc, r7, lr, lsl #8
     ddc:	0d360a00 	vldmdbeq	r6!, {s0-s-1}
     de0:	00000059 	andeq	r0, r0, r9, asr r0
     de4:	058c0e04 	streq	r0, [ip, #3588]	; 0xe04
     de8:	370a0000 	strcc	r0, [sl, -r0]
     dec:	000e6d13 	andeq	r6, lr, r3, lsl sp
     df0:	de0e0800 	cdple	8, 0, cr0, cr14, cr0, {0}
     df4:	0a000004 	beq	e0c <shift+0xe0c>
     df8:	0e6d1338 	mcreq	3, 3, r1, cr13, cr8, {1}
     dfc:	000c0000 	andeq	r0, ip, r0
     e00:	0008080e 	andeq	r0, r8, lr, lsl #16
     e04:	202c0a00 	eorcs	r0, ip, r0, lsl #20
     e08:	00000e79 	andeq	r0, r0, r9, ror lr
     e0c:	0ff90e00 	svceq	0x00f90e00
     e10:	2f0a0000 	svccs	0x000a0000
     e14:	000e7e0c 	andeq	r7, lr, ip, lsl #28
     e18:	fc0e0400 	stc2	4, cr0, [lr], {-0}
     e1c:	0a00000a 	beq	e4c <shift+0xe4c>
     e20:	0e7e0c31 	mrceq	12, 3, r0, cr14, cr1, {1}
     e24:	0e0c0000 	cdpeq	0, 0, cr0, cr12, cr0, {0}
     e28:	00000c61 	andeq	r0, r0, r1, ror #24
     e2c:	6d123b0a 	vldrvs	d3, [r2, #-40]	; 0xffffffd8
     e30:	1400000e 	strne	r0, [r0], #-14
     e34:	0009d70e 	andeq	sp, r9, lr, lsl #14
     e38:	0e3d0a00 	vaddeq.f32	s0, s26, s0
     e3c:	00000115 	andeq	r0, r0, r5, lsl r1
     e40:	0f451318 	svceq	0x00451318
     e44:	410a0000 	mrsmi	r0, (UNDEF: 10)
     e48:	00081d08 	andeq	r1, r8, r8, lsl #26
     e4c:	00034700 	andeq	r4, r3, r0, lsl #14
     e50:	0b900200 	bleq	fe401658 <__bss_end+0xfe3f7f14>
     e54:	0ba50000 	bleq	fe940e5c <__bss_end+0xfe937718>
     e58:	8e100000 	cdphi	0, 1, cr0, cr0, cr0, {0}
     e5c:	1100000e 	tstne	r0, lr
     e60:	00000059 	andeq	r0, r0, r9, asr r0
     e64:	000e9411 	andeq	r9, lr, r1, lsl r4
     e68:	0e941100 	fmleqs	f1, f4, f0
     e6c:	13000000 	movwne	r0, #0
     e70:	0000085e 	andeq	r0, r0, lr, asr r8
     e74:	3d08430a 	stccc	3, cr4, [r8, #-40]	; 0xffffffd8
     e78:	47000012 	smladmi	r0, r2, r0, r0
     e7c:	02000003 	andeq	r0, r0, #3
     e80:	00000bbe 			; <UNDEFINED> instruction: 0x00000bbe
     e84:	00000bd3 	ldrdeq	r0, [r0], -r3
     e88:	000e8e10 	andeq	r8, lr, r0, lsl lr
     e8c:	00591100 	subseq	r1, r9, r0, lsl #2
     e90:	94110000 	ldrls	r0, [r1], #-0
     e94:	1100000e 	tstne	r0, lr
     e98:	00000e94 	muleq	r0, r4, lr
     e9c:	0bfe1300 	bleq	fff85aa4 <__bss_end+0xfff7c360>
     ea0:	450a0000 	strmi	r0, [sl, #-0]
     ea4:	00096208 	andeq	r6, r9, r8, lsl #4
     ea8:	00034700 	andeq	r4, r3, r0, lsl #14
     eac:	0bec0200 	bleq	ffb016b4 <__bss_end+0xffaf7f70>
     eb0:	0c010000 	stceq	0, cr0, [r1], {-0}
     eb4:	8e100000 	cdphi	0, 1, cr0, cr0, cr0, {0}
     eb8:	1100000e 	tstne	r0, lr
     ebc:	00000059 	andeq	r0, r0, r9, asr r0
     ec0:	000e9411 	andeq	r9, lr, r1, lsl r4
     ec4:	0e941100 	fmleqs	f1, f4, f0
     ec8:	13000000 	movwne	r0, #0
     ecc:	00000d2b 	andeq	r0, r0, fp, lsr #26
     ed0:	3408470a 	strcc	r4, [r8], #-1802	; 0xfffff8f6
     ed4:	47000004 	strmi	r0, [r0, -r4]
     ed8:	02000003 	andeq	r0, r0, #3
     edc:	00000c1a 	andeq	r0, r0, sl, lsl ip
     ee0:	00000c2f 	andeq	r0, r0, pc, lsr #24
     ee4:	000e8e10 	andeq	r8, lr, r0, lsl lr
     ee8:	00591100 	subseq	r1, r9, r0, lsl #2
     eec:	94110000 	ldrls	r0, [r1], #-0
     ef0:	1100000e 	tstne	r0, lr
     ef4:	00000e94 	muleq	r0, r4, lr
     ef8:	08941300 	ldmeq	r4, {r8, r9, ip}
     efc:	490a0000 	stmdbmi	sl, {}	; <UNPREDICTABLE>
     f00:	000ab708 	andeq	fp, sl, r8, lsl #14
     f04:	00034700 	andeq	r4, r3, r0, lsl #14
     f08:	0c480200 	sfmeq	f0, 2, [r8], {-0}
     f0c:	0c5d0000 	mraeq	r0, sp, acc0
     f10:	8e100000 	cdphi	0, 1, cr0, cr0, cr0, {0}
     f14:	1100000e 	tstne	r0, lr
     f18:	00000059 	andeq	r0, r0, r9, asr r0
     f1c:	000e9411 	andeq	r9, lr, r1, lsl r4
     f20:	0e941100 	fmleqs	f1, f4, f0
     f24:	13000000 	movwne	r0, #0
     f28:	000010d3 	ldrdeq	r1, [r0], -r3
     f2c:	b1084b0a 	tstlt	r8, sl, lsl #22
     f30:	47000005 	strmi	r0, [r0, -r5]
     f34:	02000003 	andeq	r0, r0, #3
     f38:	00000c76 	andeq	r0, r0, r6, ror ip
     f3c:	00000c90 	muleq	r0, r0, ip
     f40:	000e8e10 	andeq	r8, lr, r0, lsl lr
     f44:	00591100 	subseq	r1, r9, r0, lsl #2
     f48:	bc110000 	ldclt	0, cr0, [r1], {-0}
     f4c:	1100000a 	tstne	r0, sl
     f50:	00000e94 	muleq	r0, r4, lr
     f54:	000e9411 	andeq	r9, lr, r1, lsl r4
     f58:	11130000 	tstne	r3, r0
     f5c:	0a00000e 	beq	f9c <shift+0xf9c>
     f60:	09e70c4f 	stmibeq	r7!, {r0, r1, r2, r3, r6, sl, fp}^
     f64:	00590000 	subseq	r0, r9, r0
     f68:	a9020000 	stmdbge	r2, {}	; <UNPREDICTABLE>
     f6c:	af00000c 	svcge	0x0000000c
     f70:	1000000c 	andne	r0, r0, ip
     f74:	00000e8e 	andeq	r0, r0, lr, lsl #29
     f78:	0a891400 	beq	fe245f80 <__bss_end+0xfe23c83c>
     f7c:	510a0000 	mrspl	r0, (UNDEF: 10)
     f80:	00106e08 	andseq	r6, r0, r8, lsl #28
     f84:	0cc40200 	sfmeq	f0, 2, [r4], {0}
     f88:	0ccf0000 	stcleq	0, cr0, [pc], {0}
     f8c:	9a100000 	bls	400f94 <__bss_end+0x3f7850>
     f90:	1100000e 	tstne	r0, lr
     f94:	00000059 	andeq	r0, r0, r9, asr r0
     f98:	12a01300 	adcne	r1, r0, #0, 6
     f9c:	540a0000 	strpl	r0, [sl], #-0
     fa0:	00079d03 	andeq	r9, r7, r3, lsl #26
     fa4:	000e9a00 	andeq	r9, lr, r0, lsl #20
     fa8:	0ce80100 	stfeqe	f0, [r8]
     fac:	0cf30000 	ldcleq	0, cr0, [r3]
     fb0:	9a100000 	bls	400fb8 <__bss_end+0x3f7874>
     fb4:	1100000e 	tstne	r0, lr
     fb8:	0000006a 	andeq	r0, r0, sl, rrx
     fbc:	08a71400 	stmiaeq	r7!, {sl, ip}
     fc0:	570a0000 	strpl	r0, [sl, -r0]
     fc4:	000c8808 	andeq	r8, ip, r8, lsl #16
     fc8:	0d080100 	stfeqs	f0, [r8, #-0]
     fcc:	0d180000 	ldceq	0, cr0, [r8, #-0]
     fd0:	9a100000 	bls	400fd8 <__bss_end+0x3f7894>
     fd4:	1100000e 	tstne	r0, lr
     fd8:	00000059 	andeq	r0, r0, r9, asr r0
     fdc:	000a7311 	andeq	r7, sl, r1, lsl r3
     fe0:	7d130000 	ldcvc	0, cr0, [r3, #-0]
     fe4:	0a00000b 	beq	1018 <shift+0x1018>
     fe8:	0f7e1259 	svceq	0x007e1259
     fec:	0a730000 	beq	1cc0ff4 <__bss_end+0x1cb78b0>
     ff0:	31010000 	mrscc	r0, (UNDEF: 1)
     ff4:	3c00000d 	stccc	0, cr0, [r0], {13}
     ff8:	1000000d 	andne	r0, r0, sp
     ffc:	00000e8e 	andeq	r0, r0, lr, lsl #29
    1000:	00005911 	andeq	r5, r0, r1, lsl r9
    1004:	3a140000 	bcc	50100c <__bss_end+0x4f78c8>
    1008:	0a000006 	beq	1028 <shift+0x1028>
    100c:	0714085c 			; <UNDEFINED> instruction: 0x0714085c
    1010:	51010000 	mrspl	r0, (UNDEF: 1)
    1014:	6100000d 	tstvs	r0, sp
    1018:	1000000d 	andne	r0, r0, sp
    101c:	00000e9a 	muleq	r0, sl, lr
    1020:	00005911 	andeq	r5, r0, r1, lsl r9
    1024:	03471100 	movteq	r1, #28928	; 0x7100
    1028:	13000000 	movwne	r0, #0
    102c:	00000cc0 	andeq	r0, r0, r0, asr #25
    1030:	f5085f0a 			; <UNDEFINED> instruction: 0xf5085f0a
    1034:	47000006 	strmi	r0, [r0, -r6]
    1038:	01000003 	tsteq	r0, r3
    103c:	00000d7a 	andeq	r0, r0, sl, ror sp
    1040:	00000d85 	andeq	r0, r0, r5, lsl #27
    1044:	000e9a10 	andeq	r9, lr, r0, lsl sl
    1048:	00591100 	subseq	r1, r9, r0, lsl #2
    104c:	13000000 	movwne	r0, #0
    1050:	00000d59 	andeq	r0, r0, r9, asr sp
    1054:	6308620a 	movwvs	r6, #33290	; 0x820a
    1058:	47000004 	strmi	r0, [r0, -r4]
    105c:	01000003 	tsteq	r0, r3
    1060:	00000d9e 	muleq	r0, lr, sp
    1064:	00000db3 			; <UNDEFINED> instruction: 0x00000db3
    1068:	000e9a10 	andeq	r9, lr, r0, lsl sl
    106c:	00591100 	subseq	r1, r9, r0, lsl #2
    1070:	47110000 	ldrmi	r0, [r1, -r0]
    1074:	11000003 	tstne	r0, r3
    1078:	00000347 	andeq	r0, r0, r7, asr #6
    107c:	0e691300 	cdpeq	3, 6, cr1, cr9, cr0, {0}
    1080:	640a0000 	strvs	r0, [sl], #-0
    1084:	000e8f08 	andeq	r8, lr, r8, lsl #30
    1088:	00034700 	andeq	r4, r3, r0, lsl #14
    108c:	0dcc0100 	stfeqe	f0, [ip]
    1090:	0de10000 	stcleq	0, cr0, [r1]
    1094:	9a100000 	bls	40109c <__bss_end+0x3f7958>
    1098:	1100000e 	tstne	r0, lr
    109c:	00000059 	andeq	r0, r0, r9, asr r0
    10a0:	00034711 	andeq	r4, r3, r1, lsl r7
    10a4:	03471100 	movteq	r1, #28928	; 0x7100
    10a8:	14000000 	strne	r0, [r0], #-0
    10ac:	0000136f 	andeq	r1, r0, pc, ror #6
    10b0:	3b08670a 	blcc	21ace0 <__bss_end+0x21159c>
    10b4:	0100000a 	tsteq	r0, sl
    10b8:	00000df6 	strdeq	r0, [r0], -r6
    10bc:	00000e06 	andeq	r0, r0, r6, lsl #28
    10c0:	000e9a10 	andeq	r9, lr, r0, lsl sl
    10c4:	00591100 	subseq	r1, r9, r0, lsl #2
    10c8:	bc110000 	ldclt	0, cr0, [r1], {-0}
    10cc:	0000000a 	andeq	r0, r0, sl
    10d0:	0012bd14 	andseq	fp, r2, r4, lsl sp
    10d4:	08690a00 	stmdaeq	r9!, {r9, fp}^
    10d8:	00000fb8 			; <UNDEFINED> instruction: 0x00000fb8
    10dc:	000e1b01 	andeq	r1, lr, r1, lsl #22
    10e0:	000e2b00 	andeq	r2, lr, r0, lsl #22
    10e4:	0e9a1000 	cdpeq	0, 9, cr1, cr10, cr0, {0}
    10e8:	59110000 	ldmdbpl	r1, {}	; <UNPREDICTABLE>
    10ec:	11000000 	mrsne	r0, (UNDEF: 0)
    10f0:	00000abc 			; <UNDEFINED> instruction: 0x00000abc
    10f4:	0a9e1400 	beq	fe7860fc <__bss_end+0xfe77c9b8>
    10f8:	6c0a0000 	stcvs	0, cr0, [sl], {-0}
    10fc:	00114d08 	andseq	r4, r1, r8, lsl #26
    1100:	0e400100 	dvfeqs	f0, f0, f0
    1104:	0e460000 	cdpeq	0, 4, cr0, cr6, cr0, {0}
    1108:	9a100000 	bls	401110 <__bss_end+0x3f79cc>
    110c:	0000000e 	andeq	r0, r0, lr
    1110:	000b6e23 	andeq	r6, fp, r3, lsr #28
    1114:	086f0a00 	stmdaeq	pc!, {r9, fp}^	; <UNPREDICTABLE>
    1118:	000010ee 	andeq	r1, r0, lr, ror #1
    111c:	000e5701 	andeq	r5, lr, r1, lsl #14
    1120:	0e9a1000 	cdpeq	0, 9, cr1, cr10, cr0, {0}
    1124:	76110000 	ldrvc	r0, [r1], -r0
    1128:	11000003 	tstne	r0, r3
    112c:	00000059 	andeq	r0, r0, r9, asr r0
    1130:	e7030000 	str	r0, [r3, -r0]
    1134:	1800000a 	stmdane	r0, {r1, r3}
    1138:	000af404 	andeq	pc, sl, r4, lsl #8
    113c:	76041800 	strvc	r1, [r4], -r0, lsl #16
    1140:	03000000 	movweq	r0, #0
    1144:	00000e73 	andeq	r0, r0, r3, ror lr
    1148:	00005916 	andeq	r5, r0, r6, lsl r9
    114c:	000e8e00 	andeq	r8, lr, r0, lsl #28
    1150:	006a1700 	rsbeq	r1, sl, r0, lsl #14
    1154:	00010000 	andeq	r0, r1, r0
    1158:	0e680418 	mcreq	4, 3, r0, cr8, cr8, {0}
    115c:	04210000 	strteq	r0, [r1], #-0
    1160:	00000059 	andeq	r0, r0, r9, asr r0
    1164:	0ae70418 	beq	ff9c21cc <__bss_end+0xff9b8a88>
    1168:	8e1a0000 	cdphi	0, 1, cr0, cr10, cr0, {0}
    116c:	0a000008 	beq	1194 <shift+0x1194>
    1170:	0ae71673 	beq	ff9c6b44 <__bss_end+0xff9bd400>
    1174:	54160000 	ldrpl	r0, [r6], #-0
    1178:	bc000003 	stclt	0, cr0, [r0], {3}
    117c:	1700000e 	strne	r0, [r0, -lr]
    1180:	0000006a 	andeq	r0, r0, sl, rrx
    1184:	ce280004 	cdpgt	0, 2, cr0, cr8, cr4, {0}
    1188:	01000009 	tsteq	r0, r9
    118c:	0eac0d12 	mcreq	13, 5, r0, cr12, cr2, {0}
    1190:	03050000 	movweq	r0, #20480	; 0x5000
    1194:	00009720 	andeq	r9, r0, r0, lsr #14
    1198:	00127f29 	andseq	r7, r2, r9, lsr #30
    119c:	051a0100 	ldreq	r0, [sl, #-256]	; 0xffffff00
    11a0:	00000038 	andeq	r0, r0, r8, lsr r0
    11a4:	00008238 	andeq	r8, r0, r8, lsr r2
    11a8:	0000010c 	andeq	r0, r0, ip, lsl #2
    11ac:	0f4d9c01 	svceq	0x004d9c01
    11b0:	542a0000 	strtpl	r0, [sl], #-0
    11b4:	0100000d 	tsteq	r0, sp
    11b8:	00380e1a 	eorseq	r0, r8, sl, lsl lr
    11bc:	91020000 	mrsls	r0, (UNDEF: 2)
    11c0:	0d7c2a5c 	vldmdbeq	ip!, {s5-s96}
    11c4:	1a010000 	bne	411cc <__bss_end+0x37a88>
    11c8:	000f4d1b 	andeq	r4, pc, fp, lsl sp	; <UNPREDICTABLE>
    11cc:	58910200 	ldmpl	r1, {r9}
    11d0:	0012842b 	andseq	r8, r2, fp, lsr #8
    11d4:	101c0100 	andsne	r0, ip, r0, lsl #2
    11d8:	0000081b 	andeq	r0, r0, fp, lsl r8
    11dc:	2b689102 	blcs	1a255ec <__bss_end+0x1a1bea8>
    11e0:	00001383 	andeq	r1, r0, r3, lsl #7
    11e4:	590b2101 	stmdbpl	fp, {r0, r8, sp}
    11e8:	02000000 	andeq	r0, r0, #0
    11ec:	6e2c7491 	mcrvs	4, 1, r7, cr12, cr1, {4}
    11f0:	01006d75 	tsteq	r0, r5, ror sp
    11f4:	00590b22 	subseq	r0, r9, r2, lsr #22
    11f8:	91020000 	mrsls	r0, (UNDEF: 2)
    11fc:	82b02d64 	adcshi	r2, r0, #100, 26	; 0x1900
    1200:	007c0000 	rsbseq	r0, ip, r0
    1204:	6d2c0000 	stcvs	0, cr0, [ip, #-0]
    1208:	01006773 	tsteq	r0, r3, ror r7
    120c:	03540f2a 	cmpeq	r4, #42, 30	; 0xa8
    1210:	91020000 	mrsls	r0, (UNDEF: 2)
    1214:	18000070 	stmdane	r0, {r4, r5, r6}
    1218:	000f5304 	andeq	r5, pc, r4, lsl #6
    121c:	25041800 	strcs	r1, [r4, #-2048]	; 0xfffff800
    1220:	00000000 	andeq	r0, r0, r0
    1224:	00000cd7 	ldrdeq	r0, [r0], -r7
    1228:	04790004 	ldrbteq	r0, [r9], #-4
    122c:	01040000 	mrseq	r0, (UNDEF: 4)
    1230:	000016d9 	ldrdeq	r1, [r0], -r9
    1234:	0013fe04 	andseq	pc, r3, r4, lsl #28
    1238:	0014cf00 	andseq	ip, r4, r0, lsl #30
    123c:	00834400 	addeq	r4, r3, r0, lsl #8
    1240:	00045c00 	andeq	r5, r4, r0, lsl #24
    1244:	00046400 	andeq	r6, r4, r0, lsl #8
    1248:	08010200 	stmdaeq	r1, {r9}
    124c:	000010ba 	strheq	r1, [r0], -sl
    1250:	00002503 	andeq	r2, r0, r3, lsl #10
    1254:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
    1258:	00000e38 	andeq	r0, r0, r8, lsr lr
    125c:	69050404 	stmdbvs	r5, {r2, sl}
    1260:	0200746e 	andeq	r7, r0, #1845493760	; 0x6e000000
    1264:	10b10801 	adcsne	r0, r1, r1, lsl #16
    1268:	02020000 	andeq	r0, r2, #0
    126c:	00126c07 	andseq	r6, r2, r7, lsl #24
    1270:	06ec0500 	strbteq	r0, [ip], r0, lsl #10
    1274:	09070000 	stmdbeq	r7, {}	; <UNPREDICTABLE>
    1278:	00005e07 	andeq	r5, r0, r7, lsl #28
    127c:	004d0300 	subeq	r0, sp, r0, lsl #6
    1280:	04020000 	streq	r0, [r2], #-0
    1284:	001fa307 	andseq	sl, pc, r7, lsl #6
    1288:	13630600 	cmnne	r3, #0, 12
    128c:	02080000 	andeq	r0, r8, #0
    1290:	008b0806 	addeq	r0, fp, r6, lsl #16
    1294:	72070000 	andvc	r0, r7, #0
    1298:	08020030 	stmdaeq	r2, {r4, r5}
    129c:	00004d0e 	andeq	r4, r0, lr, lsl #26
    12a0:	72070000 	andvc	r0, r7, #0
    12a4:	09020031 	stmdbeq	r2, {r0, r4, r5}
    12a8:	00004d0e 	andeq	r4, r0, lr, lsl #26
    12ac:	08000400 	stmdaeq	r0, {sl}
    12b0:	00001607 	andeq	r1, r0, r7, lsl #12
    12b4:	00380405 	eorseq	r0, r8, r5, lsl #8
    12b8:	0d020000 	stceq	0, cr0, [r2, #-0]
    12bc:	0000a90c 	andeq	sl, r0, ip, lsl #18
    12c0:	4b4f0900 	blmi	13c36c8 <__bss_end+0x13b9f84>
    12c4:	350a0000 	strcc	r0, [sl, #-0]
    12c8:	01000014 	tsteq	r0, r4, lsl r0
    12cc:	0eef0800 	cdpeq	8, 14, cr0, cr15, cr0, {0}
    12d0:	04050000 	streq	r0, [r5], #-0
    12d4:	00000038 	andeq	r0, r0, r8, lsr r0
    12d8:	e00c1e02 	and	r1, ip, r2, lsl #28
    12dc:	0a000000 	beq	12e4 <shift+0x12e4>
    12e0:	000006e4 	andeq	r0, r0, r4, ror #13
    12e4:	09260a00 	stmdbeq	r6!, {r9, fp}
    12e8:	0a010000 	beq	412f0 <__bss_end+0x37bac>
    12ec:	00000f11 	andeq	r0, r0, r1, lsl pc
    12f0:	10cd0a02 	sbcne	r0, sp, r2, lsl #20
    12f4:	0a030000 	beq	c12fc <__bss_end+0xb7bb8>
    12f8:	00000909 	andeq	r0, r0, r9, lsl #18
    12fc:	0e280a04 	vmuleq.f32	s0, s16, s8
    1300:	00050000 	andeq	r0, r5, r0
    1304:	000ed708 	andeq	sp, lr, r8, lsl #14
    1308:	38040500 	stmdacc	r4, {r8, sl}
    130c:	02000000 	andeq	r0, r0, #0
    1310:	011d0c3f 	tsteq	sp, pc, lsr ip
    1314:	4d0a0000 	stcmi	0, cr0, [sl, #-0]
    1318:	00000008 	andeq	r0, r0, r8
    131c:	00100b0a 	andseq	r0, r0, sl, lsl #22
    1320:	fc0a0100 	stc2	1, cr0, [sl], {-0}
    1324:	02000012 	andeq	r0, r0, #18
    1328:	000cff0a 	andeq	pc, ip, sl, lsl #30
    132c:	180a0300 	stmdane	sl, {r8, r9}
    1330:	04000009 	streq	r0, [r0], #-9
    1334:	000a7b0a 	andeq	r7, sl, sl, lsl #22
    1338:	640a0500 	strvs	r0, [sl], #-1280	; 0xfffffb00
    133c:	06000007 	streq	r0, [r0], -r7
    1340:	16760800 	ldrbtne	r0, [r6], -r0, lsl #16
    1344:	04050000 	streq	r0, [r5], #-0
    1348:	00000038 	andeq	r0, r0, r8, lsr r0
    134c:	480c6602 	stmdami	ip, {r1, r9, sl, sp, lr}
    1350:	0a000001 	beq	135c <shift+0x135c>
    1354:	000015ac 	andeq	r1, r0, ip, lsr #11
    1358:	14920a00 	ldrne	r0, [r2], #2560	; 0xa00
    135c:	0a010000 	beq	41364 <__bss_end+0x37c20>
    1360:	000015d0 	ldrdeq	r1, [r0], -r0
    1364:	14b70a02 	ldrtne	r0, [r7], #2562	; 0xa02
    1368:	00030000 	andeq	r0, r3, r0
    136c:	000c700b 	andeq	r7, ip, fp
    1370:	14050300 	strne	r0, [r5], #-768	; 0xfffffd00
    1374:	00000059 	andeq	r0, r0, r9, asr r0
    1378:	94300305 	ldrtls	r0, [r0], #-773	; 0xfffffcfb
    137c:	100b0000 	andne	r0, fp, r0
    1380:	03000010 	movweq	r0, #16
    1384:	00591406 	subseq	r1, r9, r6, lsl #8
    1388:	03050000 	movweq	r0, #20480	; 0x5000
    138c:	00009434 	andeq	r9, r0, r4, lsr r4
    1390:	000ae60b 	andeq	lr, sl, fp, lsl #12
    1394:	1a070400 	bne	1c239c <__bss_end+0x1b8c58>
    1398:	00000059 	andeq	r0, r0, r9, asr r0
    139c:	94380305 	ldrtls	r0, [r8], #-773	; 0xfffffcfb
    13a0:	510b0000 	mrspl	r0, (UNDEF: 11)
    13a4:	0400000e 	streq	r0, [r0], #-14
    13a8:	00591a09 	subseq	r1, r9, r9, lsl #20
    13ac:	03050000 	movweq	r0, #20480	; 0x5000
    13b0:	0000943c 	andeq	r9, r0, ip, lsr r4
    13b4:	000aa90b 	andeq	sl, sl, fp, lsl #18
    13b8:	1a0b0400 	bne	2c23c0 <__bss_end+0x2b8c7c>
    13bc:	00000059 	andeq	r0, r0, r9, asr r0
    13c0:	94400305 	strbls	r0, [r0], #-773	; 0xfffffcfb
    13c4:	dc0b0000 	stcle	0, cr0, [fp], {-0}
    13c8:	0400000d 	streq	r0, [r0], #-13
    13cc:	00591a0d 	subseq	r1, r9, sp, lsl #20
    13d0:	03050000 	movweq	r0, #20480	; 0x5000
    13d4:	00009444 	andeq	r9, r0, r4, asr #8
    13d8:	0006c40b 	andeq	ip, r6, fp, lsl #8
    13dc:	1a0f0400 	bne	3c23e4 <__bss_end+0x3b8ca0>
    13e0:	00000059 	andeq	r0, r0, r9, asr r0
    13e4:	94480305 	strbls	r0, [r8], #-773	; 0xfffffcfb
    13e8:	e5080000 	str	r0, [r8, #-0]
    13ec:	0500000c 	streq	r0, [r0, #-12]
    13f0:	00003804 	andeq	r3, r0, r4, lsl #16
    13f4:	0c1b0400 	cfldrseq	mvf0, [fp], {-0}
    13f8:	000001eb 	andeq	r0, r0, fp, ror #3
    13fc:	0006500a 	andeq	r5, r6, sl
    1400:	390a0000 	stmdbcc	sl, {}	; <UNPREDICTABLE>
    1404:	01000011 	tsteq	r0, r1, lsl r0
    1408:	0012f70a 	andseq	pc, r2, sl, lsl #14
    140c:	0c000200 	sfmeq	f0, 4, [r0], {-0}
    1410:	0000041b 	andeq	r0, r0, fp, lsl r4
    1414:	0004e30d 	andeq	lr, r4, sp, lsl #6
    1418:	63049000 	movwvs	r9, #16384	; 0x4000
    141c:	00035e07 	andeq	r5, r3, r7, lsl #28
    1420:	062c0600 	strteq	r0, [ip], -r0, lsl #12
    1424:	04240000 	strteq	r0, [r4], #-0
    1428:	02781067 	rsbseq	r1, r8, #103	; 0x67
    142c:	130e0000 	movwne	r0, #57344	; 0xe000
    1430:	04000023 	streq	r0, [r0], #-35	; 0xffffffdd
    1434:	035e1269 	cmpeq	lr, #-1879048186	; 0x90000006
    1438:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    143c:	00000852 	andeq	r0, r0, r2, asr r8
    1440:	6e126b04 	vnmlsvs.f64	d6, d2, d4
    1444:	10000003 	andne	r0, r0, r3
    1448:	0006450e 	andeq	r4, r6, lr, lsl #10
    144c:	166d0400 	strbtne	r0, [sp], -r0, lsl #8
    1450:	0000004d 	andeq	r0, r0, sp, asr #32
    1454:	0e310e14 	mrceq	14, 1, r0, cr1, cr4, {0}
    1458:	70040000 	andvc	r0, r4, r0
    145c:	0003751c 	andeq	r7, r3, ip, lsl r5
    1460:	b40e1800 	strlt	r1, [lr], #-2048	; 0xfffff800
    1464:	04000012 	streq	r0, [r0], #-18	; 0xffffffee
    1468:	03751c72 	cmneq	r5, #29184	; 0x7200
    146c:	0e1c0000 	cdpeq	0, 1, cr0, cr12, cr0, {0}
    1470:	000004de 	ldrdeq	r0, [r0], -lr
    1474:	751c7504 	ldrvc	r7, [ip, #-1284]	; 0xfffffafc
    1478:	20000003 	andcs	r0, r0, r3
    147c:	000ec60f 	andeq	ip, lr, pc, lsl #12
    1480:	1c770400 	cfldrdne	mvd0, [r7], #-0
    1484:	000011f7 	strdeq	r1, [r0], -r7
    1488:	00000375 	andeq	r0, r0, r5, ror r3
    148c:	0000026c 	andeq	r0, r0, ip, ror #4
    1490:	00037510 	andeq	r7, r3, r0, lsl r5
    1494:	037b1100 	cmneq	fp, #0, 2
    1498:	00000000 	andeq	r0, r0, r0
    149c:	0012ec06 	andseq	lr, r2, r6, lsl #24
    14a0:	7b041800 	blvc	1074a8 <__bss_end+0xfdd64>
    14a4:	0002ad10 	andeq	sl, r2, r0, lsl sp
    14a8:	23130e00 	tstcs	r3, #0, 28
    14ac:	7e040000 	cdpvc	0, 0, cr0, cr4, cr0, {0}
    14b0:	00035e12 	andeq	r5, r3, r2, lsl lr
    14b4:	380e0000 	stmdacc	lr, {}	; <UNPREDICTABLE>
    14b8:	04000005 	streq	r0, [r0], #-5
    14bc:	037b1980 	cmneq	fp, #128, 18	; 0x200000
    14c0:	0e100000 	cdpeq	0, 1, cr0, cr0, cr0, {0}
    14c4:	00000a82 	andeq	r0, r0, r2, lsl #21
    14c8:	86218204 	strthi	r8, [r1], -r4, lsl #4
    14cc:	14000003 	strne	r0, [r0], #-3
    14d0:	02780300 	rsbseq	r0, r8, #0, 6
    14d4:	91120000 	tstls	r2, r0
    14d8:	04000004 	streq	r0, [r0], #-4
    14dc:	038c2186 	orreq	r2, ip, #-2147483615	; 0x80000021
    14e0:	7c120000 	ldcvc	0, cr0, [r2], {-0}
    14e4:	04000008 	streq	r0, [r0], #-8
    14e8:	00591f88 	subseq	r1, r9, r8, lsl #31
    14ec:	630e0000 	movwvs	r0, #57344	; 0xe000
    14f0:	0400000e 	streq	r0, [r0], #-14
    14f4:	01fd178b 	mvnseq	r1, fp, lsl #15
    14f8:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    14fc:	000007b4 			; <UNDEFINED> instruction: 0x000007b4
    1500:	fd178e04 	ldc2	14, cr8, [r7, #-16]
    1504:	24000001 	strcs	r0, [r0], #-1
    1508:	000bf40e 	andeq	pc, fp, lr, lsl #8
    150c:	178f0400 	strne	r0, [pc, r0, lsl #8]
    1510:	000001fd 	strdeq	r0, [r0], -sp
    1514:	09dd0e48 	ldmibeq	sp, {r3, r6, r9, sl, fp}^
    1518:	90040000 	andls	r0, r4, r0
    151c:	0001fd17 	andeq	pc, r1, r7, lsl sp	; <UNPREDICTABLE>
    1520:	e3136c00 	tst	r3, #0, 24
    1524:	04000004 	streq	r0, [r0], #-4
    1528:	0d9f0993 	vldreq.16	s0, [pc, #294]	; 1656 <shift+0x1656>	; <UNPREDICTABLE>
    152c:	03970000 	orrseq	r0, r7, #0
    1530:	17010000 	strne	r0, [r1, -r0]
    1534:	1d000003 	stcne	0, cr0, [r0, #-12]
    1538:	10000003 	andne	r0, r0, r3
    153c:	00000397 	muleq	r0, r7, r3
    1540:	0ebb1400 	cdpeq	4, 11, cr1, cr11, cr0, {0}
    1544:	96040000 	strls	r0, [r4], -r0
    1548:	0005190e 	andeq	r1, r5, lr, lsl #18
    154c:	03320100 	teqeq	r2, #0, 2
    1550:	03380000 	teqeq	r8, #0
    1554:	97100000 	ldrls	r0, [r0, -r0]
    1558:	00000003 	andeq	r0, r0, r3
    155c:	00084d15 	andeq	r4, r8, r5, lsl sp
    1560:	10990400 	addsne	r0, r9, r0, lsl #8
    1564:	00000cca 	andeq	r0, r0, sl, asr #25
    1568:	0000039d 	muleq	r0, sp, r3
    156c:	00034d01 	andeq	r4, r3, r1, lsl #26
    1570:	03971000 	orrseq	r1, r7, #0
    1574:	7b110000 	blvc	44157c <__bss_end+0x437e38>
    1578:	11000003 	tstne	r0, r3
    157c:	000001c6 	andeq	r0, r0, r6, asr #3
    1580:	25160000 	ldrcs	r0, [r6, #-0]
    1584:	6e000000 	cdpvs	0, 0, cr0, cr0, cr0, {0}
    1588:	17000003 	strne	r0, [r0, -r3]
    158c:	0000005e 	andeq	r0, r0, lr, asr r0
    1590:	0102000f 	tsteq	r2, pc
    1594:	000b8f02 	andeq	r8, fp, r2, lsl #30
    1598:	fd041800 	stc2	8, cr1, [r4, #-0]
    159c:	18000001 	stmdane	r0, {r0}
    15a0:	00002c04 	andeq	r2, r0, r4, lsl #24
    15a4:	11cc0c00 	bicne	r0, ip, r0, lsl #24
    15a8:	04180000 	ldreq	r0, [r8], #-0
    15ac:	00000381 	andeq	r0, r0, r1, lsl #7
    15b0:	0002ad16 	andeq	sl, r2, r6, lsl sp
    15b4:	00039700 	andeq	r9, r3, r0, lsl #14
    15b8:	18001900 	stmdane	r0, {r8, fp, ip}
    15bc:	0001f004 	andeq	pc, r1, r4
    15c0:	eb041800 	bl	1075c8 <__bss_end+0xfde84>
    15c4:	1a000001 	bne	15d0 <shift+0x15d0>
    15c8:	00000eaf 	andeq	r0, r0, pc, lsr #29
    15cc:	f0149c04 			; <UNDEFINED> instruction: 0xf0149c04
    15d0:	0b000001 	bleq	15dc <shift+0x15dc>
    15d4:	0000065a 	andeq	r0, r0, sl, asr r6
    15d8:	59140405 	ldmdbpl	r4, {r0, r2, sl}
    15dc:	05000000 	streq	r0, [r0, #-0]
    15e0:	00944c03 	addseq	r4, r4, r3, lsl #24
    15e4:	0f170b00 	svceq	0x00170b00
    15e8:	07050000 	streq	r0, [r5, -r0]
    15ec:	00005914 	andeq	r5, r0, r4, lsl r9
    15f0:	50030500 	andpl	r0, r3, r0, lsl #10
    15f4:	0b000094 	bleq	184c <shift+0x184c>
    15f8:	00000506 	andeq	r0, r0, r6, lsl #10
    15fc:	59140a05 	ldmdbpl	r4, {r0, r2, r9, fp}
    1600:	05000000 	streq	r0, [r0, #-0]
    1604:	00945403 	addseq	r5, r4, r3, lsl #8
    1608:	07690800 	strbeq	r0, [r9, -r0, lsl #16]!
    160c:	04050000 	streq	r0, [r5], #-0
    1610:	00000038 	andeq	r0, r0, r8, lsr r0
    1614:	1c0c0d05 	stcne	13, cr0, [ip], {5}
    1618:	09000004 	stmdbeq	r0, {r2}
    161c:	0077654e 	rsbseq	r6, r7, lr, asr #10
    1620:	09300a00 	ldmdbeq	r0!, {r9, fp}
    1624:	0a010000 	beq	4162c <__bss_end+0x37ee8>
    1628:	000004fe 	strdeq	r0, [r0], -lr
    162c:	07820a02 	streq	r0, [r2, r2, lsl #20]
    1630:	0a030000 	beq	c1638 <__bss_end+0xb7ef4>
    1634:	000010bf 	strheq	r1, [r0], -pc	; <UNPREDICTABLE>
    1638:	04d70a04 	ldrbeq	r0, [r7], #2564	; 0xa04
    163c:	00050000 	andeq	r0, r5, r0
    1640:	00067306 	andeq	r7, r6, r6, lsl #6
    1644:	1b051000 	blne	14564c <__bss_end+0x13bf08>
    1648:	00045b08 	andeq	r5, r4, r8, lsl #22
    164c:	726c0700 	rsbvc	r0, ip, #0, 14
    1650:	131d0500 	tstne	sp, #0, 10
    1654:	0000045b 	andeq	r0, r0, fp, asr r4
    1658:	70730700 	rsbsvc	r0, r3, r0, lsl #14
    165c:	131e0500 	tstne	lr, #0, 10
    1660:	0000045b 	andeq	r0, r0, fp, asr r4
    1664:	63700704 	cmnvs	r0, #4, 14	; 0x100000
    1668:	131f0500 	tstne	pc, #0, 10
    166c:	0000045b 	andeq	r0, r0, fp, asr r4
    1670:	0ed10e08 	cdpeq	14, 13, cr0, cr1, cr8, {0}
    1674:	20050000 	andcs	r0, r5, r0
    1678:	00045b13 	andeq	r5, r4, r3, lsl fp
    167c:	02000c00 	andeq	r0, r0, #0, 24
    1680:	1f9e0704 	svcne	0x009e0704
    1684:	fc060000 	stc2	0, cr0, [r6], {-0}
    1688:	70000008 	andvc	r0, r0, r8
    168c:	f2082805 	vadd.i8	d2, d8, d5
    1690:	0e000004 	cdpeq	0, 0, cr0, cr0, cr4, {0}
    1694:	000007fc 	strdeq	r0, [r0], -ip
    1698:	1c122a05 			; <UNDEFINED> instruction: 0x1c122a05
    169c:	00000004 	andeq	r0, r0, r4
    16a0:	64697007 	strbtvs	r7, [r9], #-7
    16a4:	122b0500 	eorne	r0, fp, #0, 10
    16a8:	0000005e 	andeq	r0, r0, lr, asr r0
    16ac:	1cef0e10 	stclne	14, cr0, [pc], #64	; 16f4 <shift+0x16f4>
    16b0:	2c050000 	stccs	0, cr0, [r5], {-0}
    16b4:	0003e511 	andeq	lr, r3, r1, lsl r5
    16b8:	a30e1400 	movwge	r1, #58368	; 0xe400
    16bc:	05000010 	streq	r0, [r0, #-16]
    16c0:	005e122d 	subseq	r1, lr, sp, lsr #4
    16c4:	0e180000 	cdpeq	0, 1, cr0, cr8, cr0, {0}
    16c8:	000003ab 	andeq	r0, r0, fp, lsr #7
    16cc:	5e122e05 	cdppl	14, 1, cr2, cr2, cr5, {0}
    16d0:	1c000000 	stcne	0, cr0, [r0], {-0}
    16d4:	000f040e 	andeq	r0, pc, lr, lsl #8
    16d8:	0c2f0500 	cfstr32eq	mvfx0, [pc], #-0	; 16e0 <shift+0x16e0>
    16dc:	000004f2 	strdeq	r0, [r0], -r2
    16e0:	04870e20 	streq	r0, [r7], #3616	; 0xe20
    16e4:	30050000 	andcc	r0, r5, r0
    16e8:	00003809 	andeq	r3, r0, r9, lsl #16
    16ec:	4e0e6000 	cdpmi	0, 0, cr6, cr14, cr0, {0}
    16f0:	0500000b 	streq	r0, [r0, #-11]
    16f4:	004d0e31 	subeq	r0, sp, r1, lsr lr
    16f8:	0e640000 	cdpeq	0, 6, cr0, cr4, cr0, {0}
    16fc:	00000d73 	andeq	r0, r0, r3, ror sp
    1700:	4d0e3305 	stcmi	3, cr3, [lr, #-20]	; 0xffffffec
    1704:	68000000 	stmdavs	r0, {}	; <UNPREDICTABLE>
    1708:	000d6a0e 	andeq	r6, sp, lr, lsl #20
    170c:	0e340500 	cfabs32eq	mvfx0, mvfx4
    1710:	0000004d 	andeq	r0, r0, sp, asr #32
    1714:	9d16006c 	ldcls	0, cr0, [r6, #-432]	; 0xfffffe50
    1718:	02000003 	andeq	r0, r0, #3
    171c:	17000005 	strne	r0, [r0, -r5]
    1720:	0000005e 	andeq	r0, r0, lr, asr r0
    1724:	ef0b000f 	svc	0x000b000f
    1728:	06000004 	streq	r0, [r0], -r4
    172c:	0059140a 	subseq	r1, r9, sl, lsl #8
    1730:	03050000 	movweq	r0, #20480	; 0x5000
    1734:	00009458 	andeq	r9, r0, r8, asr r4
    1738:	000b3908 	andeq	r3, fp, r8, lsl #18
    173c:	38040500 	stmdacc	r4, {r8, sl}
    1740:	06000000 	streq	r0, [r0], -r0
    1744:	05330c0d 	ldreq	r0, [r3, #-3085]!	; 0xfffff3f3
    1748:	020a0000 	andeq	r0, sl, #0
    174c:	00000013 	andeq	r0, r0, r3, lsl r0
    1750:	00116e0a 	andseq	r6, r1, sl, lsl #28
    1754:	03000100 	movweq	r0, #256	; 0x100
    1758:	00000514 	andeq	r0, r0, r4, lsl r5
    175c:	00153808 	andseq	r3, r5, r8, lsl #16
    1760:	38040500 	stmdacc	r4, {r8, sl}
    1764:	06000000 	streq	r0, [r0], -r0
    1768:	05570c14 	ldrbeq	r0, [r7, #-3092]	; 0xfffff3ec
    176c:	930a0000 	movwls	r0, #40960	; 0xa000
    1770:	00000013 	andeq	r0, r0, r3, lsl r0
    1774:	0015c20a 	andseq	ip, r5, sl, lsl #4
    1778:	03000100 	movweq	r0, #256	; 0x100
    177c:	00000538 	andeq	r0, r0, r8, lsr r5
    1780:	0007e106 	andeq	lr, r7, r6, lsl #2
    1784:	1b060c00 	blne	18478c <__bss_end+0x17b048>
    1788:	00059108 	andeq	r9, r5, r8, lsl #2
    178c:	058c0e00 	streq	r0, [ip, #3584]	; 0xe00
    1790:	1d060000 	stcne	0, cr0, [r6, #-0]
    1794:	00059119 	andeq	r9, r5, r9, lsl r1
    1798:	de0e0000 	cdple	0, 0, cr0, cr14, cr0, {0}
    179c:	06000004 	streq	r0, [r0], -r4
    17a0:	0591191e 	ldreq	r1, [r1, #2334]	; 0x91e
    17a4:	0e040000 	cdpeq	0, 0, cr0, cr4, cr0, {0}
    17a8:	00000b69 	andeq	r0, r0, r9, ror #22
    17ac:	97131f06 	ldrls	r1, [r3, -r6, lsl #30]
    17b0:	08000005 	stmdaeq	r0, {r0, r2}
    17b4:	5c041800 	stcpl	8, cr1, [r4], {-0}
    17b8:	18000005 	stmdane	r0, {r0, r2}
    17bc:	00046204 	andeq	r6, r4, r4, lsl #4
    17c0:	0e720d00 	cdpeq	13, 7, cr0, cr2, cr0, {0}
    17c4:	06140000 	ldreq	r0, [r4], -r0
    17c8:	081f0722 	ldmdaeq	pc, {r1, r5, r8, r9, sl}	; <UNPREDICTABLE>
    17cc:	7e0e0000 	cdpvc	0, 0, cr0, cr14, cr0, {0}
    17d0:	0600000c 	streq	r0, [r0], -ip
    17d4:	004d1226 	subeq	r1, sp, r6, lsr #4
    17d8:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    17dc:	00000c11 	andeq	r0, r0, r1, lsl ip
    17e0:	911d2906 	tstls	sp, r6, lsl #18
    17e4:	04000005 	streq	r0, [r0], #-5
    17e8:	00078a0e 	andeq	r8, r7, lr, lsl #20
    17ec:	1d2c0600 	stcne	6, cr0, [ip, #-0]
    17f0:	00000591 	muleq	r0, r1, r5
    17f4:	0cf51b08 	vldmiaeq	r5!, {d17-d20}
    17f8:	2f060000 	svccs	0x00060000
    17fc:	0007be0e 	andeq	fp, r7, lr, lsl #28
    1800:	0005e500 	andeq	lr, r5, r0, lsl #10
    1804:	0005f000 	andeq	pc, r5, r0
    1808:	08241000 	stmdaeq	r4!, {ip}
    180c:	91110000 	tstls	r1, r0
    1810:	00000005 	andeq	r0, r0, r5
    1814:	0009391c 	andeq	r3, r9, ip, lsl r9
    1818:	0e310600 	cfmsuba32eq	mvax0, mvax0, mvfx1, mvfx0
    181c:	000008d3 	ldrdeq	r0, [r0], -r3
    1820:	0000036e 	andeq	r0, r0, lr, ror #6
    1824:	00000608 	andeq	r0, r0, r8, lsl #12
    1828:	00000613 	andeq	r0, r0, r3, lsl r6
    182c:	00082410 	andeq	r2, r8, r0, lsl r4
    1830:	05971100 	ldreq	r1, [r7, #256]	; 0x100
    1834:	13000000 	movwne	r0, #0
    1838:	0000111a 	andeq	r1, r0, sl, lsl r1
    183c:	141d3506 	ldrne	r3, [sp], #-1286	; 0xfffffafa
    1840:	9100000b 	tstls	r0, fp
    1844:	02000005 	andeq	r0, r0, #5
    1848:	0000062c 	andeq	r0, r0, ip, lsr #12
    184c:	00000632 	andeq	r0, r0, r2, lsr r6
    1850:	00082410 	andeq	r2, r8, r0, lsl r4
    1854:	75130000 	ldrvc	r0, [r3, #-0]
    1858:	06000007 	streq	r0, [r0], -r7
    185c:	0d051d37 	stceq	13, cr1, [r5, #-220]	; 0xffffff24
    1860:	05910000 	ldreq	r0, [r1]
    1864:	4b020000 	blmi	8186c <__bss_end+0x78128>
    1868:	51000006 	tstpl	r0, r6
    186c:	10000006 	andne	r0, r0, r6
    1870:	00000824 	andeq	r0, r0, r4, lsr #16
    1874:	0c241d00 	stceq	13, cr1, [r4], #-0
    1878:	39060000 	stmdbcc	r6, {}	; <UNPREDICTABLE>
    187c:	00083d31 	andeq	r3, r8, r1, lsr sp
    1880:	13020c00 	movwne	r0, #11264	; 0x2c00
    1884:	00000e72 	andeq	r0, r0, r2, ror lr
    1888:	48093c06 	stmdami	r9, {r1, r2, sl, fp, ip, sp}
    188c:	24000009 	strcs	r0, [r0], #-9
    1890:	01000008 	tsteq	r0, r8
    1894:	00000678 	andeq	r0, r0, r8, ror r6
    1898:	0000067e 	andeq	r0, r0, lr, ror r6
    189c:	00082410 	andeq	r2, r8, r0, lsl r4
    18a0:	0e130000 	cdpeq	0, 1, cr0, cr3, cr0, {0}
    18a4:	06000008 	streq	r0, [r0], -r8
    18a8:	0561123f 	strbeq	r1, [r1, #-575]!	; 0xfffffdc1
    18ac:	004d0000 	subeq	r0, sp, r0
    18b0:	97010000 	strls	r0, [r1, -r0]
    18b4:	ac000006 	stcge	0, cr0, [r0], {6}
    18b8:	10000006 	andne	r0, r0, r6
    18bc:	00000824 	andeq	r0, r0, r4, lsr #16
    18c0:	00084611 	andeq	r4, r8, r1, lsl r6
    18c4:	005e1100 	subseq	r1, lr, r0, lsl #2
    18c8:	6e110000 	cdpvs	0, 1, cr0, cr1, cr0, {0}
    18cc:	00000003 	andeq	r0, r0, r3
    18d0:	00114414 	andseq	r4, r1, r4, lsl r4
    18d4:	0e420600 	cdpeq	6, 4, cr0, cr2, cr0, {0}
    18d8:	00000680 	andeq	r0, r0, r0, lsl #13
    18dc:	0006c101 	andeq	ip, r6, r1, lsl #2
    18e0:	0006c700 	andeq	ip, r6, r0, lsl #14
    18e4:	08241000 	stmdaeq	r4!, {ip}
    18e8:	13000000 	movwne	r0, #0
    18ec:	00000543 	andeq	r0, r0, r3, asr #10
    18f0:	fe174506 	cdp2	5, 1, cr4, cr7, cr6, {0}
    18f4:	97000005 	strls	r0, [r0, -r5]
    18f8:	01000005 	tsteq	r0, r5
    18fc:	000006e0 	andeq	r0, r0, r0, ror #13
    1900:	000006e6 	andeq	r0, r0, r6, ror #13
    1904:	00084c10 	andeq	r4, r8, r0, lsl ip
    1908:	22130000 	andscs	r0, r3, #0
    190c:	0600000f 	streq	r0, [r0], -pc
    1910:	03c11748 	biceq	r1, r1, #72, 14	; 0x1200000
    1914:	05970000 	ldreq	r0, [r7]
    1918:	ff010000 			; <UNDEFINED> instruction: 0xff010000
    191c:	0a000006 	beq	193c <shift+0x193c>
    1920:	10000007 	andne	r0, r0, r7
    1924:	0000084c 	andeq	r0, r0, ip, asr #16
    1928:	00004d11 	andeq	r4, r0, r1, lsl sp
    192c:	ce140000 	cdpgt	0, 1, cr0, cr4, cr0, {0}
    1930:	06000006 	streq	r0, [r0], -r6
    1934:	0c320e4b 	ldceq	14, cr0, [r2], #-300	; 0xfffffed4
    1938:	1f010000 	svcne	0x00010000
    193c:	25000007 	strcs	r0, [r0, #-7]
    1940:	10000007 	andne	r0, r0, r7
    1944:	00000824 	andeq	r0, r0, r4, lsr #16
    1948:	09391300 	ldmdbeq	r9!, {r8, r9, ip}
    194c:	4d060000 	stcmi	0, cr0, [r6, #-0]
    1950:	000db40e 	andeq	fp, sp, lr, lsl #8
    1954:	00036e00 	andeq	r6, r3, r0, lsl #28
    1958:	073e0100 	ldreq	r0, [lr, -r0, lsl #2]!
    195c:	07490000 	strbeq	r0, [r9, -r0]
    1960:	24100000 	ldrcs	r0, [r0], #-0
    1964:	11000008 	tstne	r0, r8
    1968:	0000004d 	andeq	r0, r0, sp, asr #32
    196c:	04c31300 	strbeq	r1, [r3], #768	; 0x300
    1970:	50060000 	andpl	r0, r6, r0
    1974:	0003ee12 	andeq	lr, r3, r2, lsl lr
    1978:	00004d00 	andeq	r4, r0, r0, lsl #26
    197c:	07620100 	strbeq	r0, [r2, -r0, lsl #2]!
    1980:	076d0000 	strbeq	r0, [sp, -r0]!
    1984:	24100000 	ldrcs	r0, [r0], #-0
    1988:	11000008 	tstne	r0, r8
    198c:	0000039d 	muleq	r0, sp, r3
    1990:	04211300 	strteq	r1, [r1], #-768	; 0xfffffd00
    1994:	53060000 	movwpl	r0, #24576	; 0x6000
    1998:	00119a0e 	andseq	r9, r1, lr, lsl #20
    199c:	00036e00 	andeq	r6, r3, r0, lsl #28
    19a0:	07860100 	streq	r0, [r6, r0, lsl #2]
    19a4:	07910000 	ldreq	r0, [r1, r0]
    19a8:	24100000 	ldrcs	r0, [r0], #-0
    19ac:	11000008 	tstne	r0, r8
    19b0:	0000004d 	andeq	r0, r0, sp, asr #32
    19b4:	049d1400 	ldreq	r1, [sp], #1024	; 0x400
    19b8:	56060000 	strpl	r0, [r6], -r0
    19bc:	00101c0e 	andseq	r1, r0, lr, lsl #24
    19c0:	07a60100 	streq	r0, [r6, r0, lsl #2]!
    19c4:	07c50000 	strbeq	r0, [r5, r0]
    19c8:	24100000 	ldrcs	r0, [r0], #-0
    19cc:	11000008 	tstne	r0, r8
    19d0:	000000a9 	andeq	r0, r0, r9, lsr #1
    19d4:	00004d11 	andeq	r4, r0, r1, lsl sp
    19d8:	004d1100 	subeq	r1, sp, r0, lsl #2
    19dc:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    19e0:	11000000 	mrsne	r0, (UNDEF: 0)
    19e4:	00000852 	andeq	r0, r0, r2, asr r8
    19e8:	12271400 	eorne	r1, r7, #0, 8
    19ec:	58060000 	stmdapl	r6, {}	; <UNPREDICTABLE>
    19f0:	0013170e 	andseq	r1, r3, lr, lsl #14
    19f4:	07da0100 	ldrbeq	r0, [sl, r0, lsl #2]
    19f8:	07f90000 	ldrbeq	r0, [r9, r0]!
    19fc:	24100000 	ldrcs	r0, [r0], #-0
    1a00:	11000008 	tstne	r0, r8
    1a04:	000000e0 	andeq	r0, r0, r0, ror #1
    1a08:	00004d11 	andeq	r4, r0, r1, lsl sp
    1a0c:	004d1100 	subeq	r1, sp, r0, lsl #2
    1a10:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    1a14:	11000000 	mrsne	r0, (UNDEF: 0)
    1a18:	00000852 	andeq	r0, r0, r2, asr r8
    1a1c:	04b01500 	ldrteq	r1, [r0], #1280	; 0x500
    1a20:	5b060000 	blpl	181a28 <__bss_end+0x1782e4>
    1a24:	000b940e 	andeq	r9, fp, lr, lsl #8
    1a28:	00036e00 	andeq	r6, r3, r0, lsl #28
    1a2c:	080e0100 	stmdaeq	lr, {r8}
    1a30:	24100000 	ldrcs	r0, [r0], #-0
    1a34:	11000008 	tstne	r0, r8
    1a38:	00000514 	andeq	r0, r0, r4, lsl r5
    1a3c:	00085811 	andeq	r5, r8, r1, lsl r8
    1a40:	03000000 	movweq	r0, #0
    1a44:	0000059d 	muleq	r0, sp, r5
    1a48:	059d0418 	ldreq	r0, [sp, #1048]	; 0x418
    1a4c:	911e0000 	tstls	lr, r0
    1a50:	37000005 	strcc	r0, [r0, -r5]
    1a54:	3d000008 	stccc	0, cr0, [r0, #-32]	; 0xffffffe0
    1a58:	10000008 	andne	r0, r0, r8
    1a5c:	00000824 	andeq	r0, r0, r4, lsr #16
    1a60:	059d1f00 	ldreq	r1, [sp, #3840]	; 0xf00
    1a64:	082a0000 	stmdaeq	sl!, {}	; <UNPREDICTABLE>
    1a68:	04180000 	ldreq	r0, [r8], #-0
    1a6c:	0000003f 	andeq	r0, r0, pc, lsr r0
    1a70:	081f0418 	ldmdaeq	pc, {r3, r4, sl}	; <UNPREDICTABLE>
    1a74:	04200000 	strteq	r0, [r0], #-0
    1a78:	00000065 	andeq	r0, r0, r5, rrx
    1a7c:	891a0421 	ldmdbhi	sl, {r0, r5, sl}
    1a80:	06000012 			; <UNDEFINED> instruction: 0x06000012
    1a84:	059d195e 	ldreq	r1, [sp, #2398]	; 0x95e
    1a88:	2c160000 	ldccs	0, cr0, [r6], {-0}
    1a8c:	76000000 	strvc	r0, [r0], -r0
    1a90:	17000008 	strne	r0, [r0, -r8]
    1a94:	0000005e 	andeq	r0, r0, lr, asr r0
    1a98:	66030009 	strvs	r0, [r3], -r9
    1a9c:	22000008 	andcs	r0, r0, #8
    1aa0:	00001481 	andeq	r1, r0, r1, lsl #9
    1aa4:	760ca401 	strvc	sl, [ip], -r1, lsl #8
    1aa8:	05000008 	streq	r0, [r0, #-8]
    1aac:	00945c03 	addseq	r5, r4, r3, lsl #24
    1ab0:	13ac2300 			; <UNDEFINED> instruction: 0x13ac2300
    1ab4:	a6010000 	strge	r0, [r1], -r0
    1ab8:	00152c0a 	andseq	r2, r5, sl, lsl #24
    1abc:	00004d00 	andeq	r4, r0, r0, lsl #26
    1ac0:	0086f000 	addeq	pc, r6, r0
    1ac4:	0000b000 	andeq	fp, r0, r0
    1ac8:	eb9c0100 	bl	fe701ed0 <__bss_end+0xfe6f878c>
    1acc:	24000008 	strcs	r0, [r0], #-8
    1ad0:	00002313 	andeq	r2, r0, r3, lsl r3
    1ad4:	7b1ba601 	blvc	6eb2e0 <__bss_end+0x6e1b9c>
    1ad8:	03000003 	movweq	r0, #3
    1adc:	247fac91 	ldrbtcs	sl, [pc], #-3217	; 1ae4 <shift+0x1ae4>
    1ae0:	0000158b 	andeq	r1, r0, fp, lsl #11
    1ae4:	4d2aa601 	stcmi	6, cr10, [sl, #-4]!
    1ae8:	03000000 	movweq	r0, #0
    1aec:	227fa891 	rsbscs	sl, pc, #9502720	; 0x910000
    1af0:	00001514 	andeq	r1, r0, r4, lsl r5
    1af4:	eb0aa801 	bl	2abb00 <__bss_end+0x2a23bc>
    1af8:	03000008 	movweq	r0, #8
    1afc:	227fb491 	rsbscs	fp, pc, #-1862270976	; 0x91000000
    1b00:	000013a7 	andeq	r1, r0, r7, lsr #7
    1b04:	3809ac01 	stmdacc	r9, {r0, sl, fp, sp, pc}
    1b08:	02000000 	andeq	r0, r0, #0
    1b0c:	16007491 			; <UNDEFINED> instruction: 0x16007491
    1b10:	00000025 	andeq	r0, r0, r5, lsr #32
    1b14:	000008fb 	strdeq	r0, [r0], -fp
    1b18:	00005e17 	andeq	r5, r0, r7, lsl lr
    1b1c:	25003f00 	strcs	r3, [r0, #-3840]	; 0xfffff100
    1b20:	00001570 	andeq	r1, r0, r0, ror r5
    1b24:	e70a9801 	str	r9, [sl, -r1, lsl #16]
    1b28:	4d000015 	stcmi	0, cr0, [r0, #-84]	; 0xffffffac
    1b2c:	b4000000 	strlt	r0, [r0], #-0
    1b30:	3c000086 	stccc	0, cr0, [r0], {134}	; 0x86
    1b34:	01000000 	mrseq	r0, (UNDEF: 0)
    1b38:	0009389c 	muleq	r9, ip, r8
    1b3c:	65722600 	ldrbvs	r2, [r2, #-1536]!	; 0xfffffa00
    1b40:	9a010071 	bls	41d0c <__bss_end+0x385c8>
    1b44:	00055720 	andeq	r5, r5, r0, lsr #14
    1b48:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1b4c:	00152122 	andseq	r2, r5, r2, lsr #2
    1b50:	0e9b0100 	fmleqe	f0, f3, f0
    1b54:	0000004d 	andeq	r0, r0, sp, asr #32
    1b58:	00709102 	rsbseq	r9, r0, r2, lsl #2
    1b5c:	00159a27 	andseq	r9, r5, r7, lsr #20
    1b60:	068f0100 	streq	r0, [pc], r0, lsl #2
    1b64:	000013c8 	andeq	r1, r0, r8, asr #7
    1b68:	00008678 	andeq	r8, r0, r8, ror r6
    1b6c:	0000003c 	andeq	r0, r0, ip, lsr r0
    1b70:	09719c01 	ldmdbeq	r1!, {r0, sl, fp, ip, pc}^
    1b74:	6d240000 	stcvs	0, cr0, [r4, #-0]
    1b78:	01000014 	tsteq	r0, r4, lsl r0
    1b7c:	004d218f 	subeq	r2, sp, pc, lsl #3
    1b80:	91020000 	mrsls	r0, (UNDEF: 2)
    1b84:	6572266c 	ldrbvs	r2, [r2, #-1644]!	; 0xfffff994
    1b88:	91010071 	tstls	r1, r1, ror r0
    1b8c:	00055720 	andeq	r5, r5, r0, lsr #14
    1b90:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1b94:	154d2500 	strbne	r2, [sp, #-1280]	; 0xfffffb00
    1b98:	83010000 	movwhi	r0, #4096	; 0x1000
    1b9c:	00149d0a 	andseq	r9, r4, sl, lsl #26
    1ba0:	00004d00 	andeq	r4, r0, r0, lsl #26
    1ba4:	00863c00 	addeq	r3, r6, r0, lsl #24
    1ba8:	00003c00 	andeq	r3, r0, r0, lsl #24
    1bac:	ae9c0100 	fmlgee	f0, f4, f0
    1bb0:	26000009 	strcs	r0, [r0], -r9
    1bb4:	00716572 	rsbseq	r6, r1, r2, ror r5
    1bb8:	33208501 			; <UNDEFINED> instruction: 0x33208501
    1bbc:	02000005 	andeq	r0, r0, #5
    1bc0:	a0227491 	mlage	r2, r1, r4, r7
    1bc4:	01000013 	tsteq	r0, r3, lsl r0
    1bc8:	004d0e86 	subeq	r0, sp, r6, lsl #29
    1bcc:	91020000 	mrsls	r0, (UNDEF: 2)
    1bd0:	8f250070 	svchi	0x00250070
    1bd4:	01000016 	tsteq	r0, r6, lsl r0
    1bd8:	14430a77 	strbne	r0, [r3], #-2679	; 0xfffff589
    1bdc:	004d0000 	subeq	r0, sp, r0
    1be0:	86000000 	strhi	r0, [r0], -r0
    1be4:	003c0000 	eorseq	r0, ip, r0
    1be8:	9c010000 	stcls	0, cr0, [r1], {-0}
    1bec:	000009eb 	andeq	r0, r0, fp, ror #19
    1bf0:	71657226 	cmnvc	r5, r6, lsr #4
    1bf4:	20790100 	rsbscs	r0, r9, r0, lsl #2
    1bf8:	00000533 	andeq	r0, r0, r3, lsr r5
    1bfc:	22749102 	rsbscs	r9, r4, #-2147483648	; 0x80000000
    1c00:	000013a0 	andeq	r1, r0, r0, lsr #7
    1c04:	4d0e7a01 	vstrmi	s14, [lr, #-4]
    1c08:	02000000 	andeq	r0, r0, #0
    1c0c:	25007091 	strcs	r7, [r0, #-145]	; 0xffffff6f
    1c10:	000014b1 			; <UNDEFINED> instruction: 0x000014b1
    1c14:	b7066b01 	strlt	r6, [r6, -r1, lsl #22]
    1c18:	6e000015 	mcrvs	0, 0, r0, cr0, cr5, {0}
    1c1c:	ac000003 	stcge	0, cr0, [r0], {3}
    1c20:	54000085 	strpl	r0, [r0], #-133	; 0xffffff7b
    1c24:	01000000 	mrseq	r0, (UNDEF: 0)
    1c28:	000a379c 	muleq	sl, ip, r7
    1c2c:	15212400 	strne	r2, [r1, #-1024]!	; 0xfffffc00
    1c30:	6b010000 	blvs	41c38 <__bss_end+0x384f4>
    1c34:	00004d15 	andeq	r4, r0, r5, lsl sp
    1c38:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1c3c:	000d6a24 	andeq	r6, sp, r4, lsr #20
    1c40:	256b0100 	strbcs	r0, [fp, #-256]!	; 0xffffff00
    1c44:	0000004d 	andeq	r0, r0, sp, asr #32
    1c48:	22689102 	rsbcs	r9, r8, #-2147483648	; 0x80000000
    1c4c:	00001687 	andeq	r1, r0, r7, lsl #13
    1c50:	4d0e6d01 	stcmi	13, cr6, [lr, #-4]
    1c54:	02000000 	andeq	r0, r0, #0
    1c58:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    1c5c:	000013df 	ldrdeq	r1, [r0], -pc	; <UNPREDICTABLE>
    1c60:	1e125e01 	cdpne	14, 1, cr5, cr2, cr1, {0}
    1c64:	8b000016 	blhi	1cc4 <shift+0x1cc4>
    1c68:	5c000000 	stcpl	0, cr0, [r0], {-0}
    1c6c:	50000085 	andpl	r0, r0, r5, lsl #1
    1c70:	01000000 	mrseq	r0, (UNDEF: 0)
    1c74:	000a929c 	muleq	sl, ip, r2
    1c78:	13882400 	orrne	r2, r8, #0, 8
    1c7c:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
    1c80:	00004d20 	andeq	r4, r0, r0, lsr #26
    1c84:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1c88:	00155624 	andseq	r5, r5, r4, lsr #12
    1c8c:	2f5e0100 	svccs	0x005e0100
    1c90:	0000004d 	andeq	r0, r0, sp, asr #32
    1c94:	24689102 	strbtcs	r9, [r8], #-258	; 0xfffffefe
    1c98:	00000d6a 	andeq	r0, r0, sl, ror #26
    1c9c:	4d3f5e01 	ldcmi	14, cr5, [pc, #-4]!	; 1ca0 <shift+0x1ca0>
    1ca0:	02000000 	andeq	r0, r0, #0
    1ca4:	87226491 			; <UNDEFINED> instruction: 0x87226491
    1ca8:	01000016 	tsteq	r0, r6, lsl r0
    1cac:	008b1660 	addeq	r1, fp, r0, ror #12
    1cb0:	91020000 	mrsls	r0, (UNDEF: 2)
    1cb4:	1a250074 	bne	941e8c <__bss_end+0x938748>
    1cb8:	01000015 	tsteq	r0, r5, lsl r0
    1cbc:	13e40a52 	mvnne	r0, #335872	; 0x52000
    1cc0:	004d0000 	subeq	r0, sp, r0
    1cc4:	85180000 	ldrhi	r0, [r8, #-0]
    1cc8:	00440000 	subeq	r0, r4, r0
    1ccc:	9c010000 	stcls	0, cr0, [r1], {-0}
    1cd0:	00000ade 	ldrdeq	r0, [r0], -lr
    1cd4:	00138824 	andseq	r8, r3, r4, lsr #16
    1cd8:	1a520100 	bne	14820e0 <__bss_end+0x147899c>
    1cdc:	0000004d 	andeq	r0, r0, sp, asr #32
    1ce0:	246c9102 	strbtcs	r9, [ip], #-258	; 0xfffffefe
    1ce4:	00001556 	andeq	r1, r0, r6, asr r5
    1ce8:	4d295201 	sfmmi	f5, 4, [r9, #-4]!
    1cec:	02000000 	andeq	r0, r0, #0
    1cf0:	4d226891 	stcmi	8, cr6, [r2, #-580]!	; 0xfffffdbc
    1cf4:	01000016 	tsteq	r0, r6, lsl r0
    1cf8:	004d0e54 	subeq	r0, sp, r4, asr lr
    1cfc:	91020000 	mrsls	r0, (UNDEF: 2)
    1d00:	47250074 			; <UNDEFINED> instruction: 0x47250074
    1d04:	01000016 	tsteq	r0, r6, lsl r0
    1d08:	16290a45 	strtne	r0, [r9], -r5, asr #20
    1d0c:	004d0000 	subeq	r0, sp, r0
    1d10:	84c80000 	strbhi	r0, [r8], #0
    1d14:	00500000 	subseq	r0, r0, r0
    1d18:	9c010000 	stcls	0, cr0, [r1], {-0}
    1d1c:	00000b39 	andeq	r0, r0, r9, lsr fp
    1d20:	00138824 	andseq	r8, r3, r4, lsr #16
    1d24:	19450100 	stmdbne	r5, {r8}^
    1d28:	0000004d 	andeq	r0, r0, sp, asr #32
    1d2c:	246c9102 	strbtcs	r9, [ip], #-258	; 0xfffffefe
    1d30:	000014f5 	strdeq	r1, [r0], -r5
    1d34:	1d304501 	cfldr32ne	mvfx4, [r0, #-4]!
    1d38:	02000001 	andeq	r0, r0, #1
    1d3c:	5c246891 	stcpl	8, cr6, [r4], #-580	; 0xfffffdbc
    1d40:	01000015 	tsteq	r0, r5, lsl r0
    1d44:	08584145 	ldmdaeq	r8, {r0, r2, r6, r8, lr}^
    1d48:	91020000 	mrsls	r0, (UNDEF: 2)
    1d4c:	16872264 	strne	r2, [r7], r4, ror #4
    1d50:	47010000 	strmi	r0, [r1, -r0]
    1d54:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1d58:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1d5c:	138d2700 	orrne	r2, sp, #0, 14
    1d60:	3f010000 	svccc	0x00010000
    1d64:	0014ff06 	andseq	pc, r4, r6, lsl #30
    1d68:	00849c00 	addeq	r9, r4, r0, lsl #24
    1d6c:	00002c00 	andeq	r2, r0, r0, lsl #24
    1d70:	639c0100 	orrsvs	r0, ip, #0, 2
    1d74:	2400000b 	strcs	r0, [r0], #-11
    1d78:	00001388 	andeq	r1, r0, r8, lsl #7
    1d7c:	4d153f01 	ldcmi	15, cr3, [r5, #-4]
    1d80:	02000000 	andeq	r0, r0, #0
    1d84:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    1d88:	00001594 	muleq	r0, r4, r5
    1d8c:	620a3201 	andvs	r3, sl, #268435456	; 0x10000000
    1d90:	4d000015 	stcmi	0, cr0, [r0, #-84]	; 0xffffffac
    1d94:	4c000000 	stcmi	0, cr0, [r0], {-0}
    1d98:	50000084 	andpl	r0, r0, r4, lsl #1
    1d9c:	01000000 	mrseq	r0, (UNDEF: 0)
    1da0:	000bbe9c 	muleq	fp, ip, lr
    1da4:	13882400 	orrne	r2, r8, #0, 8
    1da8:	32010000 	andcc	r0, r1, #0
    1dac:	00004d19 	andeq	r4, r0, r9, lsl sp
    1db0:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1db4:	00166324 	andseq	r6, r6, r4, lsr #6
    1db8:	2b320100 	blcs	c821c0 <__bss_end+0xc78a7c>
    1dbc:	0000037b 	andeq	r0, r0, fp, ror r3
    1dc0:	24689102 	strbtcs	r9, [r8], #-258	; 0xfffffefe
    1dc4:	0000158f 	andeq	r1, r0, pc, lsl #11
    1dc8:	4d3c3201 	lfmmi	f3, 4, [ip, #-4]!
    1dcc:	02000000 	andeq	r0, r0, #0
    1dd0:	18226491 	stmdane	r2!, {r0, r4, r7, sl, sp, lr}
    1dd4:	01000016 	tsteq	r0, r6, lsl r0
    1dd8:	004d0e34 	subeq	r0, sp, r4, lsr lr
    1ddc:	91020000 	mrsls	r0, (UNDEF: 2)
    1de0:	b1250074 			; <UNDEFINED> instruction: 0xb1250074
    1de4:	01000016 	tsteq	r0, r6, lsl r0
    1de8:	166a0a25 	strbtne	r0, [sl], -r5, lsr #20
    1dec:	004d0000 	subeq	r0, sp, r0
    1df0:	83fc0000 	mvnshi	r0, #0
    1df4:	00500000 	subseq	r0, r0, r0
    1df8:	9c010000 	stcls	0, cr0, [r1], {-0}
    1dfc:	00000c19 	andeq	r0, r0, r9, lsl ip
    1e00:	00138824 	andseq	r8, r3, r4, lsr #16
    1e04:	18250100 	stmdane	r5!, {r8}
    1e08:	0000004d 	andeq	r0, r0, sp, asr #32
    1e0c:	246c9102 	strbtcs	r9, [ip], #-258	; 0xfffffefe
    1e10:	00001663 	andeq	r1, r0, r3, ror #12
    1e14:	1f2a2501 	svcne	0x002a2501
    1e18:	0200000c 	andeq	r0, r0, #12
    1e1c:	8f246891 	svchi	0x00246891
    1e20:	01000015 	tsteq	r0, r5, lsl r0
    1e24:	004d3b25 	subeq	r3, sp, r5, lsr #22
    1e28:	91020000 	mrsls	r0, (UNDEF: 2)
    1e2c:	13b12264 			; <UNDEFINED> instruction: 0x13b12264
    1e30:	27010000 	strcs	r0, [r1, -r0]
    1e34:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1e38:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1e3c:	25041800 	strcs	r1, [r4, #-2048]	; 0xfffff800
    1e40:	03000000 	movweq	r0, #0
    1e44:	00000c19 	andeq	r0, r0, r9, lsl ip
    1e48:	00152725 	andseq	r2, r5, r5, lsr #14
    1e4c:	0a190100 	beq	642254 <__bss_end+0x638b10>
    1e50:	000016bd 			; <UNDEFINED> instruction: 0x000016bd
    1e54:	0000004d 	andeq	r0, r0, sp, asr #32
    1e58:	000083b8 			; <UNDEFINED> instruction: 0x000083b8
    1e5c:	00000044 	andeq	r0, r0, r4, asr #32
    1e60:	0c709c01 	ldcleq	12, cr9, [r0], #-4
    1e64:	a8240000 	stmdage	r4!, {}	; <UNPREDICTABLE>
    1e68:	01000016 	tsteq	r0, r6, lsl r0
    1e6c:	037b1b19 	cmneq	fp, #25600	; 0x6400
    1e70:	91020000 	mrsls	r0, (UNDEF: 2)
    1e74:	165e246c 	ldrbne	r2, [lr], -ip, ror #8
    1e78:	19010000 	stmdbne	r1, {}	; <UNPREDICTABLE>
    1e7c:	0001c635 	andeq	ip, r1, r5, lsr r6
    1e80:	68910200 	ldmvs	r1, {r9}
    1e84:	00138822 	andseq	r8, r3, r2, lsr #16
    1e88:	0e1b0100 	mufeqe	f0, f3, f0
    1e8c:	0000004d 	andeq	r0, r0, sp, asr #32
    1e90:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1e94:	00146128 	andseq	r6, r4, r8, lsr #2
    1e98:	06140100 	ldreq	r0, [r4], -r0, lsl #2
    1e9c:	000013b7 			; <UNDEFINED> instruction: 0x000013b7
    1ea0:	0000839c 	muleq	r0, ip, r3
    1ea4:	0000001c 	andeq	r0, r0, ip, lsl r0
    1ea8:	54279c01 	strtpl	r9, [r7], #-3073	; 0xfffff3ff
    1eac:	01000016 	tsteq	r0, r6, lsl r0
    1eb0:	13f0060e 	mvnsne	r0, #14680064	; 0xe00000
    1eb4:	83700000 	cmnhi	r0, #0
    1eb8:	002c0000 	eoreq	r0, ip, r0
    1ebc:	9c010000 	stcls	0, cr0, [r1], {-0}
    1ec0:	00000cb0 			; <UNDEFINED> instruction: 0x00000cb0
    1ec4:	00143a24 	andseq	r3, r4, r4, lsr #20
    1ec8:	140e0100 	strne	r0, [lr], #-256	; 0xffffff00
    1ecc:	00000038 	andeq	r0, r0, r8, lsr r0
    1ed0:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1ed4:	0016b629 	andseq	fp, r6, r9, lsr #12
    1ed8:	0a040100 	beq	1022e0 <__bss_end+0xf8b9c>
    1edc:	00001509 	andeq	r1, r0, r9, lsl #10
    1ee0:	0000004d 	andeq	r0, r0, sp, asr #32
    1ee4:	00008344 	andeq	r8, r0, r4, asr #6
    1ee8:	0000002c 	andeq	r0, r0, ip, lsr #32
    1eec:	70269c01 	eorvc	r9, r6, r1, lsl #24
    1ef0:	01006469 	tsteq	r0, r9, ror #8
    1ef4:	004d0e06 	subeq	r0, sp, r6, lsl #28
    1ef8:	91020000 	mrsls	r0, (UNDEF: 2)
    1efc:	2e000074 	mcrcs	0, 0, r0, cr0, cr4, {3}
    1f00:	04000003 	streq	r0, [r0], #-3
    1f04:	00072400 	andeq	r2, r7, r0, lsl #8
    1f08:	d9010400 	stmdble	r1, {sl}
    1f0c:	04000016 	streq	r0, [r0], #-22	; 0xffffffea
    1f10:	000017db 	ldrdeq	r1, [r0], -fp
    1f14:	000014cf 	andeq	r1, r0, pc, asr #9
    1f18:	000087a0 	andeq	r8, r0, r0, lsr #15
    1f1c:	000004b8 			; <UNDEFINED> instruction: 0x000004b8
    1f20:	000006e4 	andeq	r0, r0, r4, ror #13
    1f24:	00004902 	andeq	r4, r0, r2, lsl #18
    1f28:	18140300 	ldmdane	r4, {r8, r9}
    1f2c:	05010000 	streq	r0, [r1, #-0]
    1f30:	00006110 	andeq	r6, r0, r0, lsl r1
    1f34:	31301100 	teqcc	r0, r0, lsl #2
    1f38:	35343332 	ldrcc	r3, [r4, #-818]!	; 0xfffffcce
    1f3c:	39383736 	ldmdbcc	r8!, {r1, r2, r4, r5, r8, r9, sl, ip, sp}
    1f40:	44434241 	strbmi	r4, [r3], #-577	; 0xfffffdbf
    1f44:	00004645 	andeq	r4, r0, r5, asr #12
    1f48:	01030104 	tsteq	r3, r4, lsl #2
    1f4c:	00000025 	andeq	r0, r0, r5, lsr #32
    1f50:	00007405 	andeq	r7, r0, r5, lsl #8
    1f54:	00006100 	andeq	r6, r0, r0, lsl #2
    1f58:	00660600 	rsbeq	r0, r6, r0, lsl #12
    1f5c:	00100000 	andseq	r0, r0, r0
    1f60:	00005107 	andeq	r5, r0, r7, lsl #2
    1f64:	07040800 	streq	r0, [r4, -r0, lsl #16]
    1f68:	00001fa3 	andeq	r1, r0, r3, lsr #31
    1f6c:	ba080108 	blt	202394 <__bss_end+0x1f8c50>
    1f70:	07000010 	smladeq	r0, r0, r0, r0
    1f74:	0000006d 	andeq	r0, r0, sp, rrx
    1f78:	00002a09 	andeq	r2, r0, r9, lsl #20
    1f7c:	18430a00 	stmdane	r3, {r9, fp}^
    1f80:	64010000 	strvs	r0, [r1], #-0
    1f84:	00182e06 	andseq	r2, r8, r6, lsl #28
    1f88:	008bd800 	addeq	sp, fp, r0, lsl #16
    1f8c:	00008000 	andeq	r8, r0, r0
    1f90:	fb9c0100 	blx	fe70239a <__bss_end+0xfe6f8c56>
    1f94:	0b000000 	bleq	1f9c <shift+0x1f9c>
    1f98:	00637273 	rsbeq	r7, r3, r3, ror r2
    1f9c:	fb196401 	blx	65afaa <__bss_end+0x651866>
    1fa0:	02000000 	andeq	r0, r0, #0
    1fa4:	640b6491 	strvs	r6, [fp], #-1169	; 0xfffffb6f
    1fa8:	01007473 	tsteq	r0, r3, ror r4
    1fac:	01022464 	tsteq	r2, r4, ror #8
    1fb0:	91020000 	mrsls	r0, (UNDEF: 2)
    1fb4:	756e0b60 	strbvc	r0, [lr, #-2912]!	; 0xfffff4a0
    1fb8:	6401006d 	strvs	r0, [r1], #-109	; 0xffffff93
    1fbc:	0001042d 	andeq	r0, r1, sp, lsr #8
    1fc0:	5c910200 	lfmpl	f0, 4, [r1], {0}
    1fc4:	00189d0c 	andseq	r9, r8, ip, lsl #26
    1fc8:	0e660100 	poweqs	f0, f6, f0
    1fcc:	0000010b 	andeq	r0, r0, fp, lsl #2
    1fd0:	0c709102 	ldfeqp	f1, [r0], #-8
    1fd4:	00001820 	andeq	r1, r0, r0, lsr #16
    1fd8:	11086701 	tstne	r8, r1, lsl #14
    1fdc:	02000001 	andeq	r0, r0, #1
    1fe0:	000d6c91 	muleq	sp, r1, ip
    1fe4:	4800008c 	stmdami	r0, {r2, r3, r7}
    1fe8:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    1fec:	69010069 	stmdbvs	r1, {r0, r3, r5, r6}
    1ff0:	0001040b 	andeq	r0, r1, fp, lsl #8
    1ff4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1ff8:	040f0000 	streq	r0, [pc], #-0	; 2000 <shift+0x2000>
    1ffc:	00000101 	andeq	r0, r0, r1, lsl #2
    2000:	12041110 	andne	r1, r4, #16, 2
    2004:	6e690504 	cdpvs	5, 6, cr0, cr9, cr4, {0}
    2008:	040f0074 	streq	r0, [pc], #-116	; 2010 <shift+0x2010>
    200c:	00000074 	andeq	r0, r0, r4, ror r0
    2010:	006d040f 	rsbeq	r0, sp, pc, lsl #8
    2014:	b70a0000 	strlt	r0, [sl, -r0]
    2018:	01000017 	tsteq	r0, r7, lsl r0
    201c:	17c4065c 			; <UNDEFINED> instruction: 0x17c4065c
    2020:	8b700000 	blhi	1c02028 <__bss_end+0x1bf88e4>
    2024:	00680000 	rsbeq	r0, r8, r0
    2028:	9c010000 	stcls	0, cr0, [r1], {-0}
    202c:	00000176 	andeq	r0, r0, r6, ror r1
    2030:	00189613 	andseq	r9, r8, r3, lsl r6
    2034:	125c0100 	subsne	r0, ip, #0, 2
    2038:	00000102 	andeq	r0, r0, r2, lsl #2
    203c:	136c9102 	cmnne	ip, #-2147483648	; 0x80000000
    2040:	000017bd 			; <UNDEFINED> instruction: 0x000017bd
    2044:	041e5c01 	ldreq	r5, [lr], #-3073	; 0xfffff3ff
    2048:	02000001 	andeq	r0, r0, #1
    204c:	6d0e6891 	stcvs	8, cr6, [lr, #-580]	; 0xfffffdbc
    2050:	01006d65 	tsteq	r0, r5, ror #26
    2054:	0111085e 	tsteq	r1, lr, asr r8
    2058:	91020000 	mrsls	r0, (UNDEF: 2)
    205c:	8b8c0d70 	blhi	fe305624 <__bss_end+0xfe2fbee0>
    2060:	003c0000 	eorseq	r0, ip, r0
    2064:	690e0000 	stmdbvs	lr, {}	; <UNPREDICTABLE>
    2068:	0b600100 	bleq	1802470 <__bss_end+0x17f8d2c>
    206c:	00000104 	andeq	r0, r0, r4, lsl #2
    2070:	00749102 	rsbseq	r9, r4, r2, lsl #2
    2074:	184a1400 	stmdane	sl, {sl, ip}^
    2078:	52010000 	andpl	r0, r1, #0
    207c:	00186305 	andseq	r6, r8, r5, lsl #6
    2080:	00010400 	andeq	r0, r1, r0, lsl #8
    2084:	008b1c00 	addeq	r1, fp, r0, lsl #24
    2088:	00005400 	andeq	r5, r0, r0, lsl #8
    208c:	af9c0100 	svcge	0x009c0100
    2090:	0b000001 	bleq	209c <shift+0x209c>
    2094:	52010073 	andpl	r0, r1, #115	; 0x73
    2098:	00010b18 	andeq	r0, r1, r8, lsl fp
    209c:	6c910200 	lfmvs	f0, 4, [r1], {0}
    20a0:	0100690e 	tsteq	r0, lr, lsl #18
    20a4:	01040654 	tsteq	r4, r4, asr r6
    20a8:	91020000 	mrsls	r0, (UNDEF: 2)
    20ac:	86140074 			; <UNDEFINED> instruction: 0x86140074
    20b0:	01000018 	tsteq	r0, r8, lsl r0
    20b4:	18510542 	ldmdane	r1, {r1, r6, r8, sl}^
    20b8:	01040000 	mrseq	r0, (UNDEF: 4)
    20bc:	8a700000 	bhi	1c020c4 <__bss_end+0x1bf8980>
    20c0:	00ac0000 	adceq	r0, ip, r0
    20c4:	9c010000 	stcls	0, cr0, [r1], {-0}
    20c8:	00000215 	andeq	r0, r0, r5, lsl r2
    20cc:	0031730b 	eorseq	r7, r1, fp, lsl #6
    20d0:	0b194201 	bleq	6528dc <__bss_end+0x649198>
    20d4:	02000001 	andeq	r0, r0, #1
    20d8:	730b6c91 	movwvc	r6, #48273	; 0xbc91
    20dc:	42010032 	andmi	r0, r1, #50	; 0x32
    20e0:	00010b29 	andeq	r0, r1, r9, lsr #22
    20e4:	68910200 	ldmvs	r1, {r9}
    20e8:	6d756e0b 	ldclvs	14, cr6, [r5, #-44]!	; 0xffffffd4
    20ec:	31420100 	mrscc	r0, (UNDEF: 82)
    20f0:	00000104 	andeq	r0, r0, r4, lsl #2
    20f4:	0e649102 	lgneqs	f1, f2
    20f8:	01003175 	tsteq	r0, r5, ror r1
    20fc:	02151044 	andseq	r1, r5, #68	; 0x44
    2100:	91020000 	mrsls	r0, (UNDEF: 2)
    2104:	32750e77 	rsbscc	r0, r5, #1904	; 0x770
    2108:	14440100 	strbne	r0, [r4], #-256	; 0xffffff00
    210c:	00000215 	andeq	r0, r0, r5, lsl r2
    2110:	00769102 	rsbseq	r9, r6, r2, lsl #2
    2114:	b1080108 	tstlt	r8, r8, lsl #2
    2118:	14000010 	strne	r0, [r0], #-16
    211c:	0000188e 	andeq	r1, r0, lr, lsl #17
    2120:	75073601 	strvc	r3, [r7, #-1537]	; 0xfffff9ff
    2124:	11000018 	tstne	r0, r8, lsl r0
    2128:	b0000001 	andlt	r0, r0, r1
    212c:	c0000089 	andgt	r0, r0, r9, lsl #1
    2130:	01000000 	mrseq	r0, (UNDEF: 0)
    2134:	0002759c 	muleq	r2, ip, r5
    2138:	17b21300 	ldrne	r1, [r2, r0, lsl #6]!
    213c:	36010000 	strcc	r0, [r1], -r0
    2140:	00011115 	andeq	r1, r1, r5, lsl r1
    2144:	6c910200 	lfmvs	f0, 4, [r1], {0}
    2148:	6372730b 	cmnvs	r2, #738197504	; 0x2c000000
    214c:	27360100 	ldrcs	r0, [r6, -r0, lsl #2]!
    2150:	0000010b 	andeq	r0, r0, fp, lsl #2
    2154:	0b689102 	bleq	1a26564 <__bss_end+0x1a1ce20>
    2158:	006d756e 	rsbeq	r7, sp, lr, ror #10
    215c:	04303601 	ldrteq	r3, [r0], #-1537	; 0xfffff9ff
    2160:	02000001 	andeq	r0, r0, #1
    2164:	690e6491 	stmdbvs	lr, {r0, r4, r7, sl, sp, lr}
    2168:	06380100 	ldrteq	r0, [r8], -r0, lsl #2
    216c:	00000104 	andeq	r0, r0, r4, lsl #2
    2170:	00749102 	rsbseq	r9, r4, r2, lsl #2
    2174:	00187014 	andseq	r7, r8, r4, lsl r0
    2178:	05240100 	streq	r0, [r4, #-256]!	; 0xffffff00
    217c:	000017d0 	ldrdeq	r1, [r0], -r0
    2180:	00000104 	andeq	r0, r0, r4, lsl #2
    2184:	00008914 	andeq	r8, r0, r4, lsl r9
    2188:	0000009c 	muleq	r0, ip, r0
    218c:	02b29c01 	adcseq	r9, r2, #256	; 0x100
    2190:	ac130000 	ldcge	0, cr0, [r3], {-0}
    2194:	01000017 	tsteq	r0, r7, lsl r0
    2198:	010b1624 	tsteq	fp, r4, lsr #12
    219c:	91020000 	mrsls	r0, (UNDEF: 2)
    21a0:	18270c6c 	stmdane	r7!, {r2, r3, r5, r6, sl, fp}
    21a4:	26010000 	strcs	r0, [r1], -r0
    21a8:	00010406 	andeq	r0, r1, r6, lsl #8
    21ac:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    21b0:	18a41500 	stmiane	r4!, {r8, sl, ip}
    21b4:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    21b8:	0018a906 	andseq	sl, r8, r6, lsl #18
    21bc:	0087a000 	addeq	sl, r7, r0
    21c0:	00017400 	andeq	r7, r1, r0, lsl #8
    21c4:	139c0100 	orrsne	r0, ip, #0, 2
    21c8:	000017ac 	andeq	r1, r0, ip, lsr #15
    21cc:	66180801 	ldrvs	r0, [r8], -r1, lsl #16
    21d0:	02000000 	andeq	r0, r0, #0
    21d4:	27136491 			; <UNDEFINED> instruction: 0x27136491
    21d8:	01000018 	tsteq	r0, r8, lsl r0
    21dc:	01112508 	tsteq	r1, r8, lsl #10
    21e0:	91020000 	mrsls	r0, (UNDEF: 2)
    21e4:	183e1360 	ldmdane	lr!, {r5, r6, r8, r9, ip}
    21e8:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    21ec:	0000663a 	andeq	r6, r0, sl, lsr r6
    21f0:	5c910200 	lfmpl	f0, 4, [r1], {0}
    21f4:	0100690e 	tsteq	r0, lr, lsl #18
    21f8:	0104060a 	tsteq	r4, sl, lsl #12
    21fc:	91020000 	mrsls	r0, (UNDEF: 2)
    2200:	886c0d74 	stmdahi	ip!, {r2, r4, r5, r6, r8, sl, fp}^
    2204:	00980000 	addseq	r0, r8, r0
    2208:	6a0e0000 	bvs	382210 <__bss_end+0x378acc>
    220c:	0b1c0100 	bleq	702614 <__bss_end+0x6f8ed0>
    2210:	00000104 	andeq	r0, r0, r4, lsl #2
    2214:	0d709102 	ldfeqp	f1, [r0, #-8]!
    2218:	00008894 	muleq	r0, r4, r8
    221c:	00000060 	andeq	r0, r0, r0, rrx
    2220:	0100630e 	tsteq	r0, lr, lsl #6
    2224:	006d081e 	rsbeq	r0, sp, lr, lsl r8
    2228:	91020000 	mrsls	r0, (UNDEF: 2)
    222c:	0000006f 	andeq	r0, r0, pc, rrx
    2230:	00112600 	andseq	r2, r1, r0, lsl #12
    2234:	4b000400 	blmi	323c <shift+0x323c>
    2238:	04000008 	streq	r0, [r0], #-8
    223c:	0016d901 	andseq	sp, r6, r1, lsl #18
    2240:	18b50400 	ldmne	r5!, {sl}
    2244:	14cf0000 	strbne	r0, [pc], #0	; 224c <shift+0x224c>
    2248:	8c580000 	mrahi	r0, r8, acc0
    224c:	04b40000 	ldrteq	r0, [r4], #0
    2250:	095e0000 	ldmdbeq	lr, {}^	; <UNPREDICTABLE>
    2254:	01020000 	mrseq	r0, (UNDEF: 2)
    2258:	0010ba08 	andseq	fp, r0, r8, lsl #20
    225c:	00250300 	eoreq	r0, r5, r0, lsl #6
    2260:	02020000 	andeq	r0, r2, #0
    2264:	000e3805 	andeq	r3, lr, r5, lsl #16
    2268:	05040400 	streq	r0, [r4, #-1024]	; 0xfffffc00
    226c:	00746e69 	rsbseq	r6, r4, r9, ror #28
    2270:	00003803 	andeq	r3, r0, r3, lsl #16
    2274:	1a3b0500 	bne	ec367c <__bss_end+0xeb9f38>
    2278:	07020000 	streq	r0, [r2, -r0]
    227c:	00005507 	andeq	r5, r0, r7, lsl #10
    2280:	00440300 	subeq	r0, r4, r0, lsl #6
    2284:	01020000 	mrseq	r0, (UNDEF: 2)
    2288:	0010b108 	andseq	fp, r0, r8, lsl #2
    228c:	0d810500 	cfstr32eq	mvfx0, [r1]
    2290:	08020000 	stmdaeq	r2, {}	; <UNPREDICTABLE>
    2294:	00006d07 	andeq	r6, r0, r7, lsl #26
    2298:	005c0300 	subseq	r0, ip, r0, lsl #6
    229c:	02020000 	andeq	r0, r2, #0
    22a0:	00126c07 	andseq	r6, r2, r7, lsl #24
    22a4:	06ec0500 	strbteq	r0, [ip], r0, lsl #10
    22a8:	09020000 	stmdbeq	r2, {}	; <UNPREDICTABLE>
    22ac:	00008507 	andeq	r8, r0, r7, lsl #10
    22b0:	00740300 	rsbseq	r0, r4, r0, lsl #6
    22b4:	04020000 	streq	r0, [r2], #-0
    22b8:	001fa307 	andseq	sl, pc, r7, lsl #6
    22bc:	00850300 	addeq	r0, r5, r0, lsl #6
    22c0:	43060000 	movwmi	r0, #24576	; 0x6000
    22c4:	0800000e 	stmdaeq	r0, {r1, r2, r3}
    22c8:	d5070603 	strle	r0, [r7, #-1539]	; 0xfffff9fd
    22cc:	07000001 	streq	r0, [r0, -r1]
    22d0:	0000091e 	andeq	r0, r0, lr, lsl r9
    22d4:	74120a03 	ldrvc	r0, [r2], #-2563	; 0xfffff5fd
    22d8:	00000000 	andeq	r0, r0, r0
    22dc:	000d9707 	andeq	r9, sp, r7, lsl #14
    22e0:	0e0c0300 	cdpeq	3, 0, cr0, cr12, cr0, {0}
    22e4:	000001da 	ldrdeq	r0, [r0], -sl
    22e8:	0e430804 	cdpeq	8, 4, cr0, cr3, cr4, {0}
    22ec:	10030000 	andne	r0, r3, r0
    22f0:	0006a109 	andeq	sl, r6, r9, lsl #2
    22f4:	0001e600 	andeq	lr, r1, r0, lsl #12
    22f8:	00d10100 	sbcseq	r0, r1, r0, lsl #2
    22fc:	00dc0000 	sbcseq	r0, ip, r0
    2300:	e6090000 	str	r0, [r9], -r0
    2304:	0a000001 	beq	2310 <shift+0x2310>
    2308:	000001f1 	strdeq	r0, [r0], -r1
    230c:	0e420800 	cdpeq	8, 4, cr0, cr2, cr0, {0}
    2310:	12030000 	andne	r0, r3, #0
    2314:	000dfa15 	andeq	pc, sp, r5, lsl sl	; <UNPREDICTABLE>
    2318:	0001f700 	andeq	pc, r1, r0, lsl #14
    231c:	00f50100 	rscseq	r0, r5, r0, lsl #2
    2320:	01000000 	mrseq	r0, (UNDEF: 0)
    2324:	e6090000 	str	r0, [r9], -r0
    2328:	09000001 	stmdbeq	r0, {r0}
    232c:	00000038 	andeq	r0, r0, r8, lsr r0
    2330:	06ba0800 	ldrteq	r0, [sl], r0, lsl #16
    2334:	15030000 	strne	r0, [r3, #-0]
    2338:	000a1b0e 	andeq	r1, sl, lr, lsl #22
    233c:	0001da00 	andeq	sp, r1, r0, lsl #20
    2340:	01190100 	tsteq	r9, r0, lsl #2
    2344:	011f0000 	tsteq	pc, r0
    2348:	f9090000 			; <UNDEFINED> instruction: 0xf9090000
    234c:	00000001 	andeq	r0, r0, r1
    2350:	000fa70b 	andeq	sl, pc, fp, lsl #14
    2354:	0e180300 	cdpeq	3, 1, cr0, cr8, cr0, {0}
    2358:	000008b9 			; <UNDEFINED> instruction: 0x000008b9
    235c:	00013401 	andeq	r3, r1, r1, lsl #8
    2360:	00013a00 	andeq	r3, r1, r0, lsl #20
    2364:	01e60900 	mvneq	r0, r0, lsl #18
    2368:	0b000000 	bleq	2370 <shift+0x2370>
    236c:	00000a15 	andeq	r0, r0, r5, lsl sl
    2370:	360e1b03 	strcc	r1, [lr], -r3, lsl #22
    2374:	01000007 	tsteq	r0, r7
    2378:	0000014f 	andeq	r0, r0, pc, asr #2
    237c:	0000015a 	andeq	r0, r0, sl, asr r1
    2380:	0001e609 	andeq	lr, r1, r9, lsl #12
    2384:	01da0a00 	bicseq	r0, sl, r0, lsl #20
    2388:	0b000000 	bleq	2390 <shift+0x2390>
    238c:	00001099 	muleq	r0, r9, r0
    2390:	790e1d03 	stmdbvc	lr, {r0, r1, r8, sl, fp, ip}
    2394:	01000011 	tsteq	r0, r1, lsl r0
    2398:	0000016f 	andeq	r0, r0, pc, ror #2
    239c:	00000184 	andeq	r0, r0, r4, lsl #3
    23a0:	0001e609 	andeq	lr, r1, r9, lsl #12
    23a4:	005c0a00 	subseq	r0, ip, r0, lsl #20
    23a8:	5c0a0000 	stcpl	0, cr0, [sl], {-0}
    23ac:	0a000000 	beq	23b4 <shift+0x23b4>
    23b0:	000001da 	ldrdeq	r0, [r0], -sl
    23b4:	075b0b00 	ldrbeq	r0, [fp, -r0, lsl #22]
    23b8:	1f030000 	svcne	0x00030000
    23bc:	0005910e 	andeq	r9, r5, lr, lsl #2
    23c0:	01990100 	orrseq	r0, r9, r0, lsl #2
    23c4:	01ae0000 			; <UNDEFINED> instruction: 0x01ae0000
    23c8:	e6090000 	str	r0, [r9], -r0
    23cc:	0a000001 	beq	23d8 <shift+0x23d8>
    23d0:	0000005c 	andeq	r0, r0, ip, asr r0
    23d4:	00005c0a 	andeq	r5, r0, sl, lsl #24
    23d8:	00250a00 	eoreq	r0, r5, r0, lsl #20
    23dc:	0c000000 	stceq	0, cr0, [r0], {-0}
    23e0:	00001295 	muleq	r0, r5, r2
    23e4:	590e2103 	stmdbpl	lr, {r0, r1, r8, sp}
    23e8:	0100000f 	tsteq	r0, pc
    23ec:	000001bf 			; <UNDEFINED> instruction: 0x000001bf
    23f0:	0001e609 	andeq	lr, r1, r9, lsl #12
    23f4:	005c0a00 	subseq	r0, ip, r0, lsl #20
    23f8:	5c0a0000 	stcpl	0, cr0, [sl], {-0}
    23fc:	0a000000 	beq	2404 <shift+0x2404>
    2400:	000001f1 	strdeq	r0, [r0], -r1
    2404:	91030000 	mrsls	r0, (UNDEF: 3)
    2408:	02000000 	andeq	r0, r0, #0
    240c:	0b8f0201 	bleq	fe3c2c18 <__bss_end+0xfe3b94d4>
    2410:	da030000 	ble	c2418 <__bss_end+0xb8cd4>
    2414:	0d000001 	stceq	0, cr0, [r0, #-4]
    2418:	00009104 	andeq	r9, r0, r4, lsl #2
    241c:	01e60300 	mvneq	r0, r0, lsl #6
    2420:	040d0000 	streq	r0, [sp], #-0
    2424:	0000002c 	andeq	r0, r0, ip, lsr #32
    2428:	040d040e 	streq	r0, [sp], #-1038	; 0xfffffbf2
    242c:	000001d5 	ldrdeq	r0, [r0], -r5
    2430:	0001f903 	andeq	pc, r1, r3, lsl #18
    2434:	13630f00 	cmnne	r3, #0, 30
    2438:	04080000 	streq	r0, [r8], #-0
    243c:	022a0806 	eoreq	r0, sl, #393216	; 0x60000
    2440:	72100000 	andsvc	r0, r0, #0
    2444:	08040030 	stmdaeq	r4, {r4, r5}
    2448:	0000740e 	andeq	r7, r0, lr, lsl #8
    244c:	72100000 	andsvc	r0, r0, #0
    2450:	09040031 	stmdbeq	r4, {r0, r4, r5}
    2454:	0000740e 	andeq	r7, r0, lr, lsl #8
    2458:	11000400 	tstne	r0, r0, lsl #8
    245c:	00000eef 	andeq	r0, r0, pc, ror #29
    2460:	00380405 	eorseq	r0, r8, r5, lsl #8
    2464:	1e040000 	cdpne	0, 0, cr0, cr4, cr0, {0}
    2468:	0002610c 	andeq	r6, r2, ip, lsl #2
    246c:	06e41200 	strbteq	r1, [r4], r0, lsl #4
    2470:	12000000 	andne	r0, r0, #0
    2474:	00000926 	andeq	r0, r0, r6, lsr #18
    2478:	0f111201 	svceq	0x00111201
    247c:	12020000 	andne	r0, r2, #0
    2480:	000010cd 	andeq	r1, r0, sp, asr #1
    2484:	09091203 	stmdbeq	r9, {r0, r1, r9, ip}
    2488:	12040000 	andne	r0, r4, #0
    248c:	00000e28 	andeq	r0, r0, r8, lsr #28
    2490:	d7110005 	ldrle	r0, [r1, -r5]
    2494:	0500000e 	streq	r0, [r0, #-14]
    2498:	00003804 	andeq	r3, r0, r4, lsl #16
    249c:	0c3f0400 	cfldrseq	mvf0, [pc], #-0	; 24a4 <shift+0x24a4>
    24a0:	0000029e 	muleq	r0, lr, r2
    24a4:	00084d12 	andeq	r4, r8, r2, lsl sp
    24a8:	0b120000 	bleq	4824b0 <__bss_end+0x478d6c>
    24ac:	01000010 	tsteq	r0, r0, lsl r0
    24b0:	0012fc12 	andseq	pc, r2, r2, lsl ip	; <UNPREDICTABLE>
    24b4:	ff120200 			; <UNDEFINED> instruction: 0xff120200
    24b8:	0300000c 	movweq	r0, #12
    24bc:	00091812 	andeq	r1, r9, r2, lsl r8
    24c0:	7b120400 	blvc	4834c8 <__bss_end+0x479d84>
    24c4:	0500000a 	streq	r0, [r0, #-10]
    24c8:	00076412 	andeq	r6, r7, r2, lsl r4
    24cc:	13000600 	movwne	r0, #1536	; 0x600
    24d0:	00000c70 	andeq	r0, r0, r0, ror ip
    24d4:	80140505 	andshi	r0, r4, r5, lsl #10
    24d8:	05000000 	streq	r0, [r0, #-0]
    24dc:	00947c03 	addseq	r7, r4, r3, lsl #24
    24e0:	10101300 	andsne	r1, r0, r0, lsl #6
    24e4:	06050000 	streq	r0, [r5], -r0
    24e8:	00008014 	andeq	r8, r0, r4, lsl r0
    24ec:	80030500 	andhi	r0, r3, r0, lsl #10
    24f0:	13000094 	movwne	r0, #148	; 0x94
    24f4:	00000ae6 	andeq	r0, r0, r6, ror #21
    24f8:	801a0706 	andshi	r0, sl, r6, lsl #14
    24fc:	05000000 	streq	r0, [r0, #-0]
    2500:	00948403 	addseq	r8, r4, r3, lsl #8
    2504:	0e511300 	cdpeq	3, 5, cr1, cr1, cr0, {0}
    2508:	09060000 	stmdbeq	r6, {}	; <UNPREDICTABLE>
    250c:	0000801a 	andeq	r8, r0, sl, lsl r0
    2510:	88030500 	stmdahi	r3, {r8, sl}
    2514:	13000094 	movwne	r0, #148	; 0x94
    2518:	00000aa9 	andeq	r0, r0, r9, lsr #21
    251c:	801a0b06 	andshi	r0, sl, r6, lsl #22
    2520:	05000000 	streq	r0, [r0, #-0]
    2524:	00948c03 	addseq	r8, r4, r3, lsl #24
    2528:	0ddc1300 	ldcleq	3, cr1, [ip]
    252c:	0d060000 	stceq	0, cr0, [r6, #-0]
    2530:	0000801a 	andeq	r8, r0, sl, lsl r0
    2534:	90030500 	andls	r0, r3, r0, lsl #10
    2538:	13000094 	movwne	r0, #148	; 0x94
    253c:	000006c4 	andeq	r0, r0, r4, asr #13
    2540:	801a0f06 	andshi	r0, sl, r6, lsl #30
    2544:	05000000 	streq	r0, [r0, #-0]
    2548:	00949403 	addseq	r9, r4, r3, lsl #8
    254c:	0ce51100 	stfeqe	f1, [r5]
    2550:	04050000 	streq	r0, [r5], #-0
    2554:	00000038 	andeq	r0, r0, r8, lsr r0
    2558:	410c1b06 	tstmi	ip, r6, lsl #22
    255c:	12000003 	andne	r0, r0, #3
    2560:	00000650 	andeq	r0, r0, r0, asr r6
    2564:	11391200 	teqne	r9, r0, lsl #4
    2568:	12010000 	andne	r0, r1, #0
    256c:	000012f7 	strdeq	r1, [r0], -r7
    2570:	1b140002 	blne	502580 <__bss_end+0x4f8e3c>
    2574:	06000004 	streq	r0, [r0], -r4
    2578:	000004e3 	andeq	r0, r0, r3, ror #9
    257c:	07630690 			; <UNDEFINED> instruction: 0x07630690
    2580:	000004b4 			; <UNDEFINED> instruction: 0x000004b4
    2584:	00062c0f 	andeq	r2, r6, pc, lsl #24
    2588:	67062400 	strvs	r2, [r6, -r0, lsl #8]
    258c:	0003ce10 	andeq	ip, r3, r0, lsl lr
    2590:	23130700 	tstcs	r3, #0, 14
    2594:	69060000 	stmdbvs	r6, {}	; <UNPREDICTABLE>
    2598:	0004b412 	andeq	fp, r4, r2, lsl r4
    259c:	52070000 	andpl	r0, r7, #0
    25a0:	06000008 	streq	r0, [r0], -r8
    25a4:	01da126b 	bicseq	r1, sl, fp, ror #4
    25a8:	07100000 	ldreq	r0, [r0, -r0]
    25ac:	00000645 	andeq	r0, r0, r5, asr #12
    25b0:	74166d06 	ldrvc	r6, [r6], #-3334	; 0xfffff2fa
    25b4:	14000000 	strne	r0, [r0], #-0
    25b8:	000e3107 	andeq	r3, lr, r7, lsl #2
    25bc:	1c700600 	ldclne	6, cr0, [r0], #-0
    25c0:	000004c4 	andeq	r0, r0, r4, asr #9
    25c4:	12b40718 	adcsne	r0, r4, #24, 14	; 0x600000
    25c8:	72060000 	andvc	r0, r6, #0
    25cc:	0004c41c 	andeq	ip, r4, ip, lsl r4
    25d0:	de071c00 	cdple	12, 0, cr1, cr7, cr0, {0}
    25d4:	06000004 	streq	r0, [r0], -r4
    25d8:	04c41c75 	strbeq	r1, [r4], #3189	; 0xc75
    25dc:	15200000 	strne	r0, [r0, #-0]!
    25e0:	00000ec6 	andeq	r0, r0, r6, asr #29
    25e4:	f71c7706 			; <UNDEFINED> instruction: 0xf71c7706
    25e8:	c4000011 	strgt	r0, [r0], #-17	; 0xffffffef
    25ec:	c2000004 	andgt	r0, r0, #4
    25f0:	09000003 	stmdbeq	r0, {r0, r1}
    25f4:	000004c4 	andeq	r0, r0, r4, asr #9
    25f8:	0001f10a 	andeq	pc, r1, sl, lsl #2
    25fc:	0f000000 	svceq	0x00000000
    2600:	000012ec 	andeq	r1, r0, ip, ror #5
    2604:	107b0618 	rsbsne	r0, fp, r8, lsl r6
    2608:	00000403 	andeq	r0, r0, r3, lsl #8
    260c:	00231307 	eoreq	r1, r3, r7, lsl #6
    2610:	127e0600 	rsbsne	r0, lr, #0, 12
    2614:	000004b4 			; <UNDEFINED> instruction: 0x000004b4
    2618:	05380700 	ldreq	r0, [r8, #-1792]!	; 0xfffff900
    261c:	80060000 	andhi	r0, r6, r0
    2620:	0001f119 	andeq	pc, r1, r9, lsl r1	; <UNPREDICTABLE>
    2624:	82071000 	andhi	r1, r7, #0
    2628:	0600000a 	streq	r0, [r0], -sl
    262c:	04cf2182 	strbeq	r2, [pc], #386	; 2634 <shift+0x2634>
    2630:	00140000 	andseq	r0, r4, r0
    2634:	0003ce03 	andeq	ip, r3, r3, lsl #28
    2638:	04911600 	ldreq	r1, [r1], #1536	; 0x600
    263c:	86060000 	strhi	r0, [r6], -r0
    2640:	0004d521 	andeq	sp, r4, r1, lsr #10
    2644:	087c1600 	ldmdaeq	ip!, {r9, sl, ip}^
    2648:	88060000 	stmdahi	r6, {}	; <UNPREDICTABLE>
    264c:	0000801f 	andeq	r8, r0, pc, lsl r0
    2650:	0e630700 	cdpeq	7, 6, cr0, cr3, cr0, {0}
    2654:	8b060000 	blhi	18265c <__bss_end+0x178f18>
    2658:	00035317 	andeq	r5, r3, r7, lsl r3
    265c:	b4070000 	strlt	r0, [r7], #-0
    2660:	06000007 	streq	r0, [r0], -r7
    2664:	0353178e 	cmpeq	r3, #37224448	; 0x2380000
    2668:	07240000 	streq	r0, [r4, -r0]!
    266c:	00000bf4 	strdeq	r0, [r0], -r4
    2670:	53178f06 	tstpl	r7, #6, 30
    2674:	48000003 	stmdami	r0, {r0, r1}
    2678:	0009dd07 	andeq	sp, r9, r7, lsl #26
    267c:	17900600 	ldrne	r0, [r0, r0, lsl #12]
    2680:	00000353 	andeq	r0, r0, r3, asr r3
    2684:	04e3086c 	strbteq	r0, [r3], #2156	; 0x86c
    2688:	93060000 	movwls	r0, #24576	; 0x6000
    268c:	000d9f09 	andeq	r9, sp, r9, lsl #30
    2690:	0004e000 	andeq	lr, r4, r0
    2694:	046d0100 	strbteq	r0, [sp], #-256	; 0xffffff00
    2698:	04730000 	ldrbteq	r0, [r3], #-0
    269c:	e0090000 	and	r0, r9, r0
    26a0:	00000004 	andeq	r0, r0, r4
    26a4:	000ebb0b 	andeq	fp, lr, fp, lsl #22
    26a8:	0e960600 	cdpeq	6, 9, cr0, cr6, cr0, {0}
    26ac:	00000519 	andeq	r0, r0, r9, lsl r5
    26b0:	00048801 	andeq	r8, r4, r1, lsl #16
    26b4:	00048e00 	andeq	r8, r4, r0, lsl #28
    26b8:	04e00900 	strbteq	r0, [r0], #2304	; 0x900
    26bc:	17000000 	strne	r0, [r0, -r0]
    26c0:	0000084d 	andeq	r0, r0, sp, asr #16
    26c4:	ca109906 	bgt	428ae4 <__bss_end+0x41f3a0>
    26c8:	e600000c 	str	r0, [r0], -ip
    26cc:	01000004 	tsteq	r0, r4
    26d0:	000004a3 	andeq	r0, r0, r3, lsr #9
    26d4:	0004e009 	andeq	lr, r4, r9
    26d8:	01f10a00 	mvnseq	r0, r0, lsl #20
    26dc:	1c0a0000 	stcne	0, cr0, [sl], {-0}
    26e0:	00000003 	andeq	r0, r0, r3
    26e4:	00251800 	eoreq	r1, r5, r0, lsl #16
    26e8:	04c40000 	strbeq	r0, [r4], #0
    26ec:	85190000 	ldrhi	r0, [r9, #-0]
    26f0:	0f000000 	svceq	0x00000000
    26f4:	53040d00 	movwpl	r0, #19712	; 0x4d00
    26f8:	14000003 	strne	r0, [r0], #-3
    26fc:	000011cc 	andeq	r1, r0, ip, asr #3
    2700:	04ca040d 	strbeq	r0, [sl], #1037	; 0x40d
    2704:	03180000 	tsteq	r8, #0
    2708:	e0000004 	and	r0, r0, r4
    270c:	1a000004 	bne	2724 <shift+0x2724>
    2710:	46040d00 	strmi	r0, [r4], -r0, lsl #26
    2714:	0d000003 	stceq	0, cr0, [r0, #-12]
    2718:	00034104 	andeq	r4, r3, r4, lsl #2
    271c:	0eaf1b00 	vfmaeq.f64	d1, d15, d0
    2720:	9c060000 	stcls	0, cr0, [r6], {-0}
    2724:	00034614 	andeq	r4, r3, r4, lsl r6
    2728:	065a1300 	ldrbeq	r1, [sl], -r0, lsl #6
    272c:	04070000 	streq	r0, [r7], #-0
    2730:	00008014 	andeq	r8, r0, r4, lsl r0
    2734:	98030500 	stmdals	r3, {r8, sl}
    2738:	13000094 	movwne	r0, #148	; 0x94
    273c:	00000f17 	andeq	r0, r0, r7, lsl pc
    2740:	80140707 	andshi	r0, r4, r7, lsl #14
    2744:	05000000 	streq	r0, [r0, #-0]
    2748:	00949c03 	addseq	r9, r4, r3, lsl #24
    274c:	05061300 	streq	r1, [r6, #-768]	; 0xfffffd00
    2750:	0a070000 	beq	1c2758 <__bss_end+0x1b9014>
    2754:	00008014 	andeq	r8, r0, r4, lsl r0
    2758:	a0030500 	andge	r0, r3, r0, lsl #10
    275c:	11000094 	swpne	r0, r4, [r0]	; <UNPREDICTABLE>
    2760:	00000769 	andeq	r0, r0, r9, ror #14
    2764:	00380405 	eorseq	r0, r8, r5, lsl #8
    2768:	0d070000 	stceq	0, cr0, [r7, #-0]
    276c:	0005650c 	andeq	r6, r5, ip, lsl #10
    2770:	654e1c00 	strbvs	r1, [lr, #-3072]	; 0xfffff400
    2774:	12000077 	andne	r0, r0, #119	; 0x77
    2778:	00000930 	andeq	r0, r0, r0, lsr r9
    277c:	04fe1201 	ldrbteq	r1, [lr], #513	; 0x201
    2780:	12020000 	andne	r0, r2, #0
    2784:	00000782 	andeq	r0, r0, r2, lsl #15
    2788:	10bf1203 	adcsne	r1, pc, r3, lsl #4
    278c:	12040000 	andne	r0, r4, #0
    2790:	000004d7 	ldrdeq	r0, [r0], -r7
    2794:	730f0005 	movwvc	r0, #61445	; 0xf005
    2798:	10000006 	andne	r0, r0, r6
    279c:	a4081b07 	strge	r1, [r8], #-2823	; 0xfffff4f9
    27a0:	10000005 	andne	r0, r0, r5
    27a4:	0700726c 	streq	r7, [r0, -ip, ror #4]
    27a8:	05a4131d 	streq	r1, [r4, #797]!	; 0x31d
    27ac:	10000000 	andne	r0, r0, r0
    27b0:	07007073 	smlsdxeq	r0, r3, r0, r7
    27b4:	05a4131e 	streq	r1, [r4, #798]!	; 0x31e
    27b8:	10040000 	andne	r0, r4, r0
    27bc:	07006370 	smlsdxeq	r0, r0, r3, r6
    27c0:	05a4131f 	streq	r1, [r4, #799]!	; 0x31f
    27c4:	07080000 	streq	r0, [r8, -r0]
    27c8:	00000ed1 	ldrdeq	r0, [r0], -r1
    27cc:	a4132007 	ldrge	r2, [r3], #-7
    27d0:	0c000005 	stceq	0, cr0, [r0], {5}
    27d4:	07040200 	streq	r0, [r4, -r0, lsl #4]
    27d8:	00001f9e 	muleq	r0, lr, pc	; <UNPREDICTABLE>
    27dc:	0005a403 	andeq	sl, r5, r3, lsl #8
    27e0:	08fc0f00 	ldmeq	ip!, {r8, r9, sl, fp}^
    27e4:	07700000 	ldrbeq	r0, [r0, -r0]!
    27e8:	06400828 	strbeq	r0, [r0], -r8, lsr #16
    27ec:	fc070000 	stc2	0, cr0, [r7], {-0}
    27f0:	07000007 	streq	r0, [r0, -r7]
    27f4:	0565122a 	strbeq	r1, [r5, #-554]!	; 0xfffffdd6
    27f8:	10000000 	andne	r0, r0, r0
    27fc:	00646970 	rsbeq	r6, r4, r0, ror r9
    2800:	85122b07 	ldrhi	r2, [r2, #-2823]	; 0xfffff4f9
    2804:	10000000 	andne	r0, r0, r0
    2808:	001cef07 	andseq	lr, ip, r7, lsl #30
    280c:	112c0700 			; <UNDEFINED> instruction: 0x112c0700
    2810:	0000052e 	andeq	r0, r0, lr, lsr #10
    2814:	10a30714 	adcne	r0, r3, r4, lsl r7
    2818:	2d070000 	stccs	0, cr0, [r7, #-0]
    281c:	00008512 	andeq	r8, r0, r2, lsl r5
    2820:	ab071800 	blge	1c8828 <__bss_end+0x1bf0e4>
    2824:	07000003 	streq	r0, [r0, -r3]
    2828:	0085122e 	addeq	r1, r5, lr, lsr #4
    282c:	071c0000 	ldreq	r0, [ip, -r0]
    2830:	00000f04 	andeq	r0, r0, r4, lsl #30
    2834:	400c2f07 	andmi	r2, ip, r7, lsl #30
    2838:	20000006 	andcs	r0, r0, r6
    283c:	00048707 	andeq	r8, r4, r7, lsl #14
    2840:	09300700 	ldmdbeq	r0!, {r8, r9, sl}
    2844:	00000038 	andeq	r0, r0, r8, lsr r0
    2848:	0b4e0760 	bleq	13845d0 <__bss_end+0x137ae8c>
    284c:	31070000 	mrscc	r0, (UNDEF: 7)
    2850:	0000740e 	andeq	r7, r0, lr, lsl #8
    2854:	73076400 	movwvc	r6, #29696	; 0x7400
    2858:	0700000d 	streq	r0, [r0, -sp]
    285c:	00740e33 	rsbseq	r0, r4, r3, lsr lr
    2860:	07680000 	strbeq	r0, [r8, -r0]!
    2864:	00000d6a 	andeq	r0, r0, sl, ror #26
    2868:	740e3407 	strvc	r3, [lr], #-1031	; 0xfffffbf9
    286c:	6c000000 	stcvs	0, cr0, [r0], {-0}
    2870:	04e61800 	strbteq	r1, [r6], #2048	; 0x800
    2874:	06500000 	ldrbeq	r0, [r0], -r0
    2878:	85190000 	ldrhi	r0, [r9, #-0]
    287c:	0f000000 	svceq	0x00000000
    2880:	04ef1300 	strbteq	r1, [pc], #768	; 2888 <shift+0x2888>
    2884:	0a080000 	beq	20288c <__bss_end+0x1f9148>
    2888:	00008014 	andeq	r8, r0, r4, lsl r0
    288c:	a4030500 	strge	r0, [r3], #-1280	; 0xfffffb00
    2890:	11000094 	swpne	r0, r4, [r0]	; <UNPREDICTABLE>
    2894:	00000b39 	andeq	r0, r0, r9, lsr fp
    2898:	00380405 	eorseq	r0, r8, r5, lsl #8
    289c:	0d080000 	stceq	0, cr0, [r8, #-0]
    28a0:	0006810c 	andeq	r8, r6, ip, lsl #2
    28a4:	13021200 	movwne	r1, #8704	; 0x2200
    28a8:	12000000 	andne	r0, r0, #0
    28ac:	0000116e 	andeq	r1, r0, lr, ror #2
    28b0:	e10f0001 	tst	pc, r1
    28b4:	0c000007 	stceq	0, cr0, [r0], {7}
    28b8:	b6081b08 	strlt	r1, [r8], -r8, lsl #22
    28bc:	07000006 	streq	r0, [r0, -r6]
    28c0:	0000058c 	andeq	r0, r0, ip, lsl #11
    28c4:	b6191d08 	ldrlt	r1, [r9], -r8, lsl #26
    28c8:	00000006 	andeq	r0, r0, r6
    28cc:	0004de07 	andeq	sp, r4, r7, lsl #28
    28d0:	191e0800 	ldmdbne	lr, {fp}
    28d4:	000006b6 			; <UNDEFINED> instruction: 0x000006b6
    28d8:	0b690704 	bleq	1a444f0 <__bss_end+0x1a3adac>
    28dc:	1f080000 	svcne	0x00080000
    28e0:	0006bc13 	andeq	fp, r6, r3, lsl ip
    28e4:	0d000800 	stceq	8, cr0, [r0, #-0]
    28e8:	00068104 	andeq	r8, r6, r4, lsl #2
    28ec:	b0040d00 	andlt	r0, r4, r0, lsl #26
    28f0:	06000005 	streq	r0, [r0], -r5
    28f4:	00000e72 	andeq	r0, r0, r2, ror lr
    28f8:	07220814 			; <UNDEFINED> instruction: 0x07220814
    28fc:	00000944 	andeq	r0, r0, r4, asr #18
    2900:	000c7e07 	andeq	r7, ip, r7, lsl #28
    2904:	12260800 	eorne	r0, r6, #0, 16
    2908:	00000074 	andeq	r0, r0, r4, ror r0
    290c:	0c110700 	ldceq	7, cr0, [r1], {-0}
    2910:	29080000 	stmdbcs	r8, {}	; <UNPREDICTABLE>
    2914:	0006b61d 	andeq	fp, r6, sp, lsl r6
    2918:	8a070400 	bhi	1c3920 <__bss_end+0x1ba1dc>
    291c:	08000007 	stmdaeq	r0, {r0, r1, r2}
    2920:	06b61d2c 	ldrteq	r1, [r6], ip, lsr #26
    2924:	1d080000 	stcne	0, cr0, [r8, #-0]
    2928:	00000cf5 	strdeq	r0, [r0], -r5
    292c:	be0e2f08 	cdplt	15, 0, cr2, cr14, cr8, {0}
    2930:	0a000007 	beq	2954 <shift+0x2954>
    2934:	15000007 	strne	r0, [r0, #-7]
    2938:	09000007 	stmdbeq	r0, {r0, r1, r2}
    293c:	00000949 	andeq	r0, r0, r9, asr #18
    2940:	0006b60a 	andeq	fp, r6, sl, lsl #12
    2944:	391e0000 	ldmdbcc	lr, {}	; <UNPREDICTABLE>
    2948:	08000009 	stmdaeq	r0, {r0, r3}
    294c:	08d30e31 	ldmeq	r3, {r0, r4, r5, r9, sl, fp}^
    2950:	01da0000 	bicseq	r0, sl, r0
    2954:	072d0000 	streq	r0, [sp, -r0]!
    2958:	07380000 	ldreq	r0, [r8, -r0]!
    295c:	49090000 	stmdbmi	r9, {}	; <UNPREDICTABLE>
    2960:	0a000009 	beq	298c <shift+0x298c>
    2964:	000006bc 			; <UNDEFINED> instruction: 0x000006bc
    2968:	111a0800 	tstne	sl, r0, lsl #16
    296c:	35080000 	strcc	r0, [r8, #-0]
    2970:	000b141d 	andeq	r1, fp, sp, lsl r4
    2974:	0006b600 	andeq	fp, r6, r0, lsl #12
    2978:	07510200 	ldrbeq	r0, [r1, -r0, lsl #4]
    297c:	07570000 	ldrbeq	r0, [r7, -r0]
    2980:	49090000 	stmdbmi	r9, {}	; <UNPREDICTABLE>
    2984:	00000009 	andeq	r0, r0, r9
    2988:	00077508 	andeq	r7, r7, r8, lsl #10
    298c:	1d370800 	ldcne	8, cr0, [r7, #-0]
    2990:	00000d05 	andeq	r0, r0, r5, lsl #26
    2994:	000006b6 			; <UNDEFINED> instruction: 0x000006b6
    2998:	00077002 	andeq	r7, r7, r2
    299c:	00077600 	andeq	r7, r7, r0, lsl #12
    29a0:	09490900 	stmdbeq	r9, {r8, fp}^
    29a4:	1f000000 	svcne	0x00000000
    29a8:	00000c24 	andeq	r0, r0, r4, lsr #24
    29ac:	62313908 	eorsvs	r3, r1, #8, 18	; 0x20000
    29b0:	0c000009 	stceq	0, cr0, [r0], {9}
    29b4:	0e720802 	cdpeq	8, 7, cr0, cr2, cr2, {0}
    29b8:	3c080000 	stccc	0, cr0, [r8], {-0}
    29bc:	00094809 	andeq	r4, r9, r9, lsl #16
    29c0:	00094900 	andeq	r4, r9, r0, lsl #18
    29c4:	079d0100 	ldreq	r0, [sp, r0, lsl #2]
    29c8:	07a30000 	streq	r0, [r3, r0]!
    29cc:	49090000 	stmdbmi	r9, {}	; <UNPREDICTABLE>
    29d0:	00000009 	andeq	r0, r0, r9
    29d4:	00080e08 	andeq	r0, r8, r8, lsl #28
    29d8:	123f0800 	eorsne	r0, pc, #0, 16
    29dc:	00000561 	andeq	r0, r0, r1, ror #10
    29e0:	00000074 	andeq	r0, r0, r4, ror r0
    29e4:	0007bc01 	andeq	fp, r7, r1, lsl #24
    29e8:	0007d100 	andeq	sp, r7, r0, lsl #2
    29ec:	09490900 	stmdbeq	r9, {r8, fp}^
    29f0:	6b0a0000 	blvs	2829f8 <__bss_end+0x2792b4>
    29f4:	0a000009 	beq	2a20 <shift+0x2a20>
    29f8:	00000085 	andeq	r0, r0, r5, lsl #1
    29fc:	0001da0a 	andeq	sp, r1, sl, lsl #20
    2a00:	440b0000 	strmi	r0, [fp], #-0
    2a04:	08000011 	stmdaeq	r0, {r0, r4}
    2a08:	06800e42 	streq	r0, [r0], r2, asr #28
    2a0c:	e6010000 	str	r0, [r1], -r0
    2a10:	ec000007 	stc	0, cr0, [r0], {7}
    2a14:	09000007 	stmdbeq	r0, {r0, r1, r2}
    2a18:	00000949 	andeq	r0, r0, r9, asr #18
    2a1c:	05430800 	strbeq	r0, [r3, #-2048]	; 0xfffff800
    2a20:	45080000 	strmi	r0, [r8, #-0]
    2a24:	0005fe17 	andeq	pc, r5, r7, lsl lr	; <UNPREDICTABLE>
    2a28:	0006bc00 	andeq	fp, r6, r0, lsl #24
    2a2c:	08050100 	stmdaeq	r5, {r8}
    2a30:	080b0000 	stmdaeq	fp, {}	; <UNPREDICTABLE>
    2a34:	71090000 	mrsvc	r0, (UNDEF: 9)
    2a38:	00000009 	andeq	r0, r0, r9
    2a3c:	000f2208 	andeq	r2, pc, r8, lsl #4
    2a40:	17480800 	strbne	r0, [r8, -r0, lsl #16]
    2a44:	000003c1 	andeq	r0, r0, r1, asr #7
    2a48:	000006bc 			; <UNDEFINED> instruction: 0x000006bc
    2a4c:	00082401 	andeq	r2, r8, r1, lsl #8
    2a50:	00082f00 	andeq	r2, r8, r0, lsl #30
    2a54:	09710900 	ldmdbeq	r1!, {r8, fp}^
    2a58:	740a0000 	strvc	r0, [sl], #-0
    2a5c:	00000000 	andeq	r0, r0, r0
    2a60:	0006ce0b 	andeq	ip, r6, fp, lsl #28
    2a64:	0e4b0800 	cdpeq	8, 4, cr0, cr11, cr0, {0}
    2a68:	00000c32 	andeq	r0, r0, r2, lsr ip
    2a6c:	00084401 	andeq	r4, r8, r1, lsl #8
    2a70:	00084a00 	andeq	r4, r8, r0, lsl #20
    2a74:	09490900 	stmdbeq	r9, {r8, fp}^
    2a78:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    2a7c:	00000939 	andeq	r0, r0, r9, lsr r9
    2a80:	b40e4d08 	strlt	r4, [lr], #-3336	; 0xfffff2f8
    2a84:	da00000d 	ble	2ac0 <shift+0x2ac0>
    2a88:	01000001 	tsteq	r0, r1
    2a8c:	00000863 	andeq	r0, r0, r3, ror #16
    2a90:	0000086e 	andeq	r0, r0, lr, ror #16
    2a94:	00094909 	andeq	r4, r9, r9, lsl #18
    2a98:	00740a00 	rsbseq	r0, r4, r0, lsl #20
    2a9c:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    2aa0:	000004c3 	andeq	r0, r0, r3, asr #9
    2aa4:	ee125008 	cdp	0, 1, cr5, cr2, cr8, {0}
    2aa8:	74000003 	strvc	r0, [r0], #-3
    2aac:	01000000 	mrseq	r0, (UNDEF: 0)
    2ab0:	00000887 	andeq	r0, r0, r7, lsl #17
    2ab4:	00000892 	muleq	r0, r2, r8
    2ab8:	00094909 	andeq	r4, r9, r9, lsl #18
    2abc:	04e60a00 	strbteq	r0, [r6], #2560	; 0xa00
    2ac0:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    2ac4:	00000421 	andeq	r0, r0, r1, lsr #8
    2ac8:	9a0e5308 	bls	3976f0 <__bss_end+0x38dfac>
    2acc:	da000011 	ble	2b18 <shift+0x2b18>
    2ad0:	01000001 	tsteq	r0, r1
    2ad4:	000008ab 	andeq	r0, r0, fp, lsr #17
    2ad8:	000008b6 			; <UNDEFINED> instruction: 0x000008b6
    2adc:	00094909 	andeq	r4, r9, r9, lsl #18
    2ae0:	00740a00 	rsbseq	r0, r4, r0, lsl #20
    2ae4:	0b000000 	bleq	2aec <shift+0x2aec>
    2ae8:	0000049d 	muleq	r0, sp, r4
    2aec:	1c0e5608 	stcne	6, cr5, [lr], {8}
    2af0:	01000010 	tsteq	r0, r0, lsl r0
    2af4:	000008cb 	andeq	r0, r0, fp, asr #17
    2af8:	000008ea 	andeq	r0, r0, sl, ror #17
    2afc:	00094909 	andeq	r4, r9, r9, lsl #18
    2b00:	022a0a00 	eoreq	r0, sl, #0, 20
    2b04:	740a0000 	strvc	r0, [sl], #-0
    2b08:	0a000000 	beq	2b10 <shift+0x2b10>
    2b0c:	00000074 	andeq	r0, r0, r4, ror r0
    2b10:	0000740a 	andeq	r7, r0, sl, lsl #8
    2b14:	09770a00 	ldmdbeq	r7!, {r9, fp}^
    2b18:	0b000000 	bleq	2b20 <shift+0x2b20>
    2b1c:	00001227 	andeq	r1, r0, r7, lsr #4
    2b20:	170e5808 	strne	r5, [lr, -r8, lsl #16]
    2b24:	01000013 	tsteq	r0, r3, lsl r0
    2b28:	000008ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    2b2c:	0000091e 	andeq	r0, r0, lr, lsl r9
    2b30:	00094909 	andeq	r4, r9, r9, lsl #18
    2b34:	02610a00 	rsbeq	r0, r1, #0, 20
    2b38:	740a0000 	strvc	r0, [sl], #-0
    2b3c:	0a000000 	beq	2b44 <shift+0x2b44>
    2b40:	00000074 	andeq	r0, r0, r4, ror r0
    2b44:	0000740a 	andeq	r7, r0, sl, lsl #8
    2b48:	09770a00 	ldmdbeq	r7!, {r9, fp}^
    2b4c:	17000000 	strne	r0, [r0, -r0]
    2b50:	000004b0 			; <UNDEFINED> instruction: 0x000004b0
    2b54:	940e5b08 	strls	r5, [lr], #-2824	; 0xfffff4f8
    2b58:	da00000b 	ble	2b8c <shift+0x2b8c>
    2b5c:	01000001 	tsteq	r0, r1
    2b60:	00000933 	andeq	r0, r0, r3, lsr r9
    2b64:	00094909 	andeq	r4, r9, r9, lsl #18
    2b68:	06620a00 	strbteq	r0, [r2], -r0, lsl #20
    2b6c:	f70a0000 			; <UNDEFINED> instruction: 0xf70a0000
    2b70:	00000001 	andeq	r0, r0, r1
    2b74:	06c20300 	strbeq	r0, [r2], r0, lsl #6
    2b78:	040d0000 	streq	r0, [sp], #-0
    2b7c:	000006c2 	andeq	r0, r0, r2, asr #13
    2b80:	0006b620 	andeq	fp, r6, r0, lsr #12
    2b84:	00095c00 	andeq	r5, r9, r0, lsl #24
    2b88:	00096200 	andeq	r6, r9, r0, lsl #4
    2b8c:	09490900 	stmdbeq	r9, {r8, fp}^
    2b90:	21000000 	mrscs	r0, (UNDEF: 0)
    2b94:	000006c2 	andeq	r0, r0, r2, asr #13
    2b98:	0000094f 	andeq	r0, r0, pc, asr #18
    2b9c:	0055040d 	subseq	r0, r5, sp, lsl #8
    2ba0:	040d0000 	streq	r0, [sp], #-0
    2ba4:	00000944 	andeq	r0, r0, r4, asr #18
    2ba8:	02040422 	andeq	r0, r4, #570425344	; 0x22000000
    2bac:	891b0000 	ldmdbhi	fp, {}	; <UNPREDICTABLE>
    2bb0:	08000012 	stmdaeq	r0, {r1, r4}
    2bb4:	06c2195e 			; <UNDEFINED> instruction: 0x06c2195e
    2bb8:	f1110000 			; <UNDEFINED> instruction: 0xf1110000
    2bbc:	07000019 	smladeq	r0, r9, r0, r0
    2bc0:	00004401 	andeq	r4, r0, r1, lsl #8
    2bc4:	0c060900 			; <UNDEFINED> instruction: 0x0c060900
    2bc8:	000009ba 			; <UNDEFINED> instruction: 0x000009ba
    2bcc:	706f4e1c 	rsbvc	r4, pc, ip, lsl lr	; <UNPREDICTABLE>
    2bd0:	a7120000 	ldrge	r0, [r2, -r0]
    2bd4:	0100000f 	tsteq	r0, pc
    2bd8:	000a1512 	andeq	r1, sl, r2, lsl r5
    2bdc:	08120200 	ldmdaeq	r2, {r9}
    2be0:	0300001a 	movweq	r0, #26
    2be4:	00196812 	andseq	r6, r9, r2, lsl r8
    2be8:	0f000400 	svceq	0x00000400
    2bec:	00001981 	andeq	r1, r0, r1, lsl #19
    2bf0:	08220905 	stmdaeq	r2!, {r0, r2, r8, fp}
    2bf4:	000009eb 	andeq	r0, r0, fp, ror #19
    2bf8:	09007810 	stmdbeq	r0, {r4, fp, ip, sp, lr}
    2bfc:	005c0e24 	subseq	r0, ip, r4, lsr #28
    2c00:	10000000 	andne	r0, r0, r0
    2c04:	25090079 	strcs	r0, [r9, #-121]	; 0xffffff87
    2c08:	00005c0e 	andeq	r5, r0, lr, lsl #24
    2c0c:	73100200 	tstvc	r0, #0, 4
    2c10:	09007465 	stmdbeq	r0, {r0, r2, r5, r6, sl, ip, sp, lr}
    2c14:	00440d26 	subeq	r0, r4, r6, lsr #26
    2c18:	00040000 	andeq	r0, r4, r0
    2c1c:	0018f50f 	andseq	pc, r8, pc, lsl #10
    2c20:	2a090100 	bcs	243028 <__bss_end+0x2398e4>
    2c24:	000a0608 	andeq	r0, sl, r8, lsl #12
    2c28:	6d631000 	stclvs	0, cr1, [r3, #-0]
    2c2c:	2c090064 	stccs	0, cr0, [r9], {100}	; 0x64
    2c30:	00098916 	andeq	r8, r9, r6, lsl r9
    2c34:	0f000000 	svceq	0x00000000
    2c38:	0000190c 	andeq	r1, r0, ip, lsl #18
    2c3c:	08300901 	ldmdaeq	r0!, {r0, r8, fp}
    2c40:	00000a21 	andeq	r0, r0, r1, lsr #20
    2c44:	001a4f07 	andseq	r4, sl, r7, lsl #30
    2c48:	1c320900 			; <UNDEFINED> instruction: 0x1c320900
    2c4c:	000009eb 	andeq	r0, r0, fp, ror #19
    2c50:	c60f0000 	strgt	r0, [pc], -r0
    2c54:	02000019 	andeq	r0, r0, #25
    2c58:	49083609 	stmdbmi	r8, {r0, r3, r9, sl, ip, sp}
    2c5c:	0700000a 	streq	r0, [r0, -sl]
    2c60:	00001a4f 	andeq	r1, r0, pc, asr #20
    2c64:	eb1c3809 	bl	710c90 <__bss_end+0x70754c>
    2c68:	00000009 	andeq	r0, r0, r9
    2c6c:	001a1907 	andseq	r1, sl, r7, lsl #18
    2c70:	0d390900 			; <UNDEFINED> instruction: 0x0d390900
    2c74:	00000044 	andeq	r0, r0, r4, asr #32
    2c78:	470f0001 	strmi	r0, [pc, -r1]
    2c7c:	08000019 	stmdaeq	r0, {r0, r3, r4}
    2c80:	7e083d09 	cdpvc	13, 0, cr3, cr8, cr9, {0}
    2c84:	0700000a 	streq	r0, [r0, -sl]
    2c88:	00001a4f 	andeq	r1, r0, pc, asr #20
    2c8c:	eb1c3f09 	bl	7128b8 <__bss_end+0x709174>
    2c90:	00000009 	andeq	r0, r0, r9
    2c94:	00155607 	andseq	r5, r5, r7, lsl #12
    2c98:	0e400900 	vmlaeq.f16	s1, s0, s0	; <UNPREDICTABLE>
    2c9c:	0000005c 	andeq	r0, r0, ip, asr r0
    2ca0:	1a020701 	bne	848ac <__bss_end+0x7b168>
    2ca4:	42090000 	andmi	r0, r9, #0
    2ca8:	0009ba19 	andeq	fp, r9, r9, lsl sl
    2cac:	0f000300 	svceq	0x00000300
    2cb0:	0000199a 	muleq	r0, sl, r9
    2cb4:	0846090b 	stmdaeq	r6, {r0, r1, r3, r8, fp}^
    2cb8:	00000ae1 	andeq	r0, r0, r1, ror #21
    2cbc:	001a4f07 	andseq	r4, sl, r7, lsl #30
    2cc0:	1c480900 	mcrrne	9, 0, r0, r8, cr0	; <UNPREDICTABLE>
    2cc4:	000009eb 	andeq	r0, r0, fp, ror #19
    2cc8:	31781000 	cmncc	r8, r0
    2ccc:	0e490900 	vmlaeq.f16	s1, s18, s0	; <UNPREDICTABLE>
    2cd0:	0000005c 	andeq	r0, r0, ip, asr r0
    2cd4:	31791001 	cmncc	r9, r1
    2cd8:	12490900 	subne	r0, r9, #0, 18
    2cdc:	0000005c 	andeq	r0, r0, ip, asr r0
    2ce0:	00771003 	rsbseq	r1, r7, r3
    2ce4:	5c0e4a09 			; <UNDEFINED> instruction: 0x5c0e4a09
    2ce8:	05000000 	streq	r0, [r0, #-0]
    2cec:	09006810 	stmdbeq	r0, {r4, fp, sp, lr}
    2cf0:	005c114a 	subseq	r1, ip, sl, asr #2
    2cf4:	07070000 	streq	r0, [r7, -r0]
    2cf8:	00001941 	andeq	r1, r0, r1, asr #18
    2cfc:	440d4b09 	strmi	r4, [sp], #-2825	; 0xfffff4f7
    2d00:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    2d04:	001a0207 	andseq	r0, sl, r7, lsl #4
    2d08:	0d4d0900 	vstreq.16	s1, [sp, #-0]	; <UNPREDICTABLE>
    2d0c:	00000044 	andeq	r0, r0, r4, asr #32
    2d10:	6823000a 	stmdavs	r3!, {r1, r3}
    2d14:	0a006c61 	beq	1dea0 <__bss_end+0x1475c>
    2d18:	0b9b0b05 	bleq	fe6c5934 <__bss_end+0xfe6bc1f0>
    2d1c:	e1240000 			; <UNDEFINED> instruction: 0xe1240000
    2d20:	0a00000b 	beq	2d54 <shift+0x2d54>
    2d24:	008c1907 	addeq	r1, ip, r7, lsl #18
    2d28:	b2800000 	addlt	r0, r0, #0
    2d2c:	35240ee6 	strcc	r0, [r4, #-3814]!	; 0xfffff11a
    2d30:	0a00000f 	beq	2d74 <shift+0x2d74>
    2d34:	05ab1a0a 	streq	r1, [fp, #2570]!	; 0xa0a
    2d38:	00000000 	andeq	r0, r0, r0
    2d3c:	57242000 	strpl	r2, [r4, -r0]!
    2d40:	0a000005 	beq	2d5c <shift+0x2d5c>
    2d44:	05ab1a0d 	streq	r1, [fp, #2573]!	; 0xa0d
    2d48:	00000000 	andeq	r0, r0, r0
    2d4c:	5a252020 	bpl	94add4 <__bss_end+0x941690>
    2d50:	0a00000b 	beq	2d84 <shift+0x2d84>
    2d54:	00801510 	addeq	r1, r0, r0, lsl r5
    2d58:	24360000 	ldrtcs	r0, [r6], #-0
    2d5c:	00001126 	andeq	r1, r0, r6, lsr #2
    2d60:	ab1a420a 	blge	693590 <__bss_end+0x689e4c>
    2d64:	00000005 	andeq	r0, r0, r5
    2d68:	24202150 	strtcs	r2, [r0], #-336	; 0xfffffeb0
    2d6c:	000012d2 	ldrdeq	r1, [r0], -r2
    2d70:	ab1a710a 	blge	69f1a0 <__bss_end+0x695a5c>
    2d74:	00000005 	andeq	r0, r0, r5
    2d78:	242000b2 	strtcs	r0, [r0], #-178	; 0xffffff4e
    2d7c:	00000871 	andeq	r0, r0, r1, ror r8
    2d80:	ab1aa40a 	blge	6abdb0 <__bss_end+0x6a266c>
    2d84:	00000005 	andeq	r0, r0, r5
    2d88:	242000b4 	strtcs	r0, [r0], #-180	; 0xffffff4c
    2d8c:	00000bd7 	ldrdeq	r0, [r0], -r7
    2d90:	ab1ab30a 	blge	6af9c0 <__bss_end+0x6a627c>
    2d94:	00000005 	andeq	r0, r0, r5
    2d98:	24201040 	strtcs	r1, [r0], #-64	; 0xffffffc0
    2d9c:	00000d3e 	andeq	r0, r0, lr, lsr sp
    2da0:	ab1abe0a 	blge	6b25d0 <__bss_end+0x6a8e8c>
    2da4:	00000005 	andeq	r0, r0, r5
    2da8:	24202050 	strtcs	r2, [r0], #-80	; 0xffffffb0
    2dac:	00000751 	andeq	r0, r0, r1, asr r7
    2db0:	ab1abf0a 	blge	6b29e0 <__bss_end+0x6a929c>
    2db4:	00000005 	andeq	r0, r0, r5
    2db8:	24208040 	strtcs	r8, [r0], #-64	; 0xffffffc0
    2dbc:	0000112f 	andeq	r1, r0, pc, lsr #2
    2dc0:	ab1ac00a 	blge	6b2df0 <__bss_end+0x6a96ac>
    2dc4:	00000005 	andeq	r0, r0, r5
    2dc8:	00208050 	eoreq	r8, r0, r0, asr r0
    2dcc:	000aed26 	andeq	lr, sl, r6, lsr #26
    2dd0:	0afd2600 	beq	fff4c5d8 <__bss_end+0xfff42e94>
    2dd4:	0d260000 	stceq	0, cr0, [r6, #-0]
    2dd8:	2600000b 	strcs	r0, [r0], -fp
    2ddc:	00000b1d 	andeq	r0, r0, sp, lsl fp
    2de0:	000b2a26 	andeq	r2, fp, r6, lsr #20
    2de4:	0b3a2600 	bleq	e8c5ec <__bss_end+0xe82ea8>
    2de8:	4a260000 	bmi	982df0 <__bss_end+0x9796ac>
    2dec:	2600000b 	strcs	r0, [r0], -fp
    2df0:	00000b5a 	andeq	r0, r0, sl, asr fp
    2df4:	000b6a26 	andeq	r6, fp, r6, lsr #20
    2df8:	0b7a2600 	bleq	1e8c600 <__bss_end+0x1e82ebc>
    2dfc:	8a260000 	bhi	982e04 <__bss_end+0x9796c0>
    2e00:	2700000b 	strcs	r0, [r0, -fp]
    2e04:	000019e7 	andeq	r1, r0, r7, ror #19
    2e08:	6e0b040b 	cdpvs	4, 0, cr0, cr11, cr11, {0}
    2e0c:	2500000e 	strcs	r0, [r0, #-14]
    2e10:	000019dc 	ldrdeq	r1, [r0], -ip
    2e14:	6818070b 	ldmdavs	r8, {r0, r1, r3, r8, r9, sl}
    2e18:	06000000 	streq	r0, [r0], -r0
    2e1c:	001a4325 	andseq	r4, sl, r5, lsr #6
    2e20:	18090b00 	stmdane	r9, {r8, r9, fp}
    2e24:	00000068 	andeq	r0, r0, r8, rrx
    2e28:	1a562508 	bne	158c250 <__bss_end+0x1582b0c>
    2e2c:	0c0b0000 	stceq	0, cr0, [fp], {-0}
    2e30:	00006818 	andeq	r6, r0, r8, lsl r8
    2e34:	b2252000 	eorlt	r2, r5, #0
    2e38:	0b000019 	bleq	2ea4 <shift+0x2ea4>
    2e3c:	0068180e 	rsbeq	r1, r8, lr, lsl #16
    2e40:	25800000 	strcs	r0, [r0]
    2e44:	000019bb 			; <UNDEFINED> instruction: 0x000019bb
    2e48:	e114110b 	tst	r4, fp, lsl #2
    2e4c:	01000001 	tsteq	r0, r1
    2e50:	00192f28 	andseq	r2, r9, r8, lsr #30
    2e54:	13140b00 	tstne	r4, #0, 22
    2e58:	00000e98 	muleq	r0, r8, lr
    2e5c:	00000240 	andeq	r0, r0, r0, asr #4
    2e60:	00000000 	andeq	r0, r0, r0
    2e64:	2f000000 	svccs	0x00000000
    2e68:	00000000 	andeq	r0, r0, r0
    2e6c:	00070007 	andeq	r0, r7, r7
    2e70:	147f1400 	ldrbtne	r1, [pc], #-1024	; 2e78 <shift+0x2e78>
    2e74:	2400147f 	strcs	r1, [r0], #-1151	; 0xfffffb81
    2e78:	122a7f2a 	eorne	r7, sl, #42, 30	; 0xa8
    2e7c:	08132300 	ldmdaeq	r3, {r8, r9, sp}
    2e80:	36006264 	strcc	r6, [r0], -r4, ror #4
    2e84:	50225549 	eorpl	r5, r2, r9, asr #10
    2e88:	03050000 	movweq	r0, #20480	; 0x5000
    2e8c:	00000000 	andeq	r0, r0, r0
    2e90:	0041221c 	subeq	r2, r1, ip, lsl r2
    2e94:	22410000 	subcs	r0, r1, #0
    2e98:	1400001c 	strne	r0, [r0], #-28	; 0xffffffe4
    2e9c:	14083e08 	strne	r3, [r8], #-3592	; 0xfffff1f8
    2ea0:	3e080800 	cdpcc	8, 0, cr0, cr8, cr0, {0}
    2ea4:	00000808 	andeq	r0, r0, r8, lsl #16
    2ea8:	0060a000 	rsbeq	sl, r0, r0
    2eac:	08080800 	stmdaeq	r8, {fp}
    2eb0:	00000808 	andeq	r0, r0, r8, lsl #16
    2eb4:	00006060 	andeq	r6, r0, r0, rrx
    2eb8:	08102000 	ldmdaeq	r0, {sp}
    2ebc:	3e000204 	cdpcc	2, 0, cr0, cr0, cr4, {0}
    2ec0:	3e454951 			; <UNDEFINED> instruction: 0x3e454951
    2ec4:	7f420000 	svcvc	0x00420000
    2ec8:	42000040 	andmi	r0, r0, #64	; 0x40
    2ecc:	46495161 	strbmi	r5, [r9], -r1, ror #2
    2ed0:	45412100 	strbmi	r2, [r1, #-256]	; 0xffffff00
    2ed4:	1800314b 	stmdane	r0, {r0, r1, r3, r6, r8, ip, sp}
    2ed8:	107f1214 	rsbsne	r1, pc, r4, lsl r2	; <UNPREDICTABLE>
    2edc:	45452700 	strbmi	r2, [r5, #-1792]	; 0xfffff900
    2ee0:	3c003945 			; <UNDEFINED> instruction: 0x3c003945
    2ee4:	3049494a 	subcc	r4, r9, sl, asr #18
    2ee8:	09710100 	ldmdbeq	r1!, {r8}^
    2eec:	36000305 	strcc	r0, [r0], -r5, lsl #6
    2ef0:	36494949 	strbcc	r4, [r9], -r9, asr #18
    2ef4:	49490600 	stmdbmi	r9, {r9, sl}^
    2ef8:	00001e29 	andeq	r1, r0, r9, lsr #28
    2efc:	00003636 	andeq	r3, r0, r6, lsr r6
    2f00:	36560000 	ldrbcc	r0, [r6], -r0
    2f04:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    2f08:	00412214 	subeq	r2, r1, r4, lsl r2
    2f0c:	14141400 	ldrne	r1, [r4], #-1024	; 0xfffffc00
    2f10:	00001414 	andeq	r1, r0, r4, lsl r4
    2f14:	08142241 	ldmdaeq	r4, {r0, r6, r9, sp}
    2f18:	51010200 	mrspl	r0, R9_usr
    2f1c:	32000609 	andcc	r0, r0, #9437184	; 0x900000
    2f20:	3e515949 	vnmlacc.f16	s11, s2, s18	; <UNPREDICTABLE>
    2f24:	11127c00 	tstne	r2, r0, lsl #24
    2f28:	7f007c12 	svcvc	0x00007c12
    2f2c:	36494949 	strbcc	r4, [r9], -r9, asr #18
    2f30:	41413e00 	cmpmi	r1, r0, lsl #28
    2f34:	7f002241 	svcvc	0x00002241
    2f38:	1c224141 	stfnes	f4, [r2], #-260	; 0xfffffefc
    2f3c:	49497f00 	stmdbmi	r9, {r8, r9, sl, fp, ip, sp, lr}^
    2f40:	7f004149 	svcvc	0x00004149
    2f44:	01090909 	tsteq	r9, r9, lsl #18
    2f48:	49413e00 	stmdbmi	r1, {r9, sl, fp, ip, sp}^
    2f4c:	7f007a49 	svcvc	0x00007a49
    2f50:	7f080808 	svcvc	0x00080808
    2f54:	7f410000 	svcvc	0x00410000
    2f58:	20000041 	andcs	r0, r0, r1, asr #32
    2f5c:	013f4140 	teqeq	pc, r0, asr #2
    2f60:	14087f00 	strne	r7, [r8], #-3840	; 0xfffff100
    2f64:	7f004122 	svcvc	0x00004122
    2f68:	40404040 	submi	r4, r0, r0, asr #32
    2f6c:	0c027f00 	stceq	15, cr7, [r2], {-0}
    2f70:	7f007f02 	svcvc	0x00007f02
    2f74:	7f100804 	svcvc	0x00100804
    2f78:	41413e00 	cmpmi	r1, r0, lsl #28
    2f7c:	7f003e41 	svcvc	0x00003e41
    2f80:	06090909 	streq	r0, [r9], -r9, lsl #18
    2f84:	51413e00 	cmppl	r1, r0, lsl #28
    2f88:	7f005e21 	svcvc	0x00005e21
    2f8c:	46291909 	strtmi	r1, [r9], -r9, lsl #18
    2f90:	49494600 	stmdbmi	r9, {r9, sl, lr}^
    2f94:	01003149 	tsteq	r0, r9, asr #2
    2f98:	01017f01 	tsteq	r1, r1, lsl #30
    2f9c:	40403f00 	submi	r3, r0, r0, lsl #30
    2fa0:	1f003f40 	svcne	0x00003f40
    2fa4:	1f204020 	svcne	0x00204020
    2fa8:	38403f00 	stmdacc	r0, {r8, r9, sl, fp, ip, sp}^
    2fac:	63003f40 	movwvs	r3, #3904	; 0xf40
    2fb0:	63140814 	tstvs	r4, #20, 16	; 0x140000
    2fb4:	70080700 	andvc	r0, r8, r0, lsl #14
    2fb8:	61000708 	tstvs	r0, r8, lsl #14
    2fbc:	43454951 	movtmi	r4, #22865	; 0x5951
    2fc0:	417f0000 	cmnmi	pc, r0
    2fc4:	55000041 	strpl	r0, [r0, #-65]	; 0xffffffbf
    2fc8:	552a552a 	strpl	r5, [sl, #-1322]!	; 0xfffffad6
    2fcc:	41410000 	mrsmi	r0, (UNDEF: 65)
    2fd0:	0400007f 	streq	r0, [r0], #-127	; 0xffffff81
    2fd4:	04020102 	streq	r0, [r2], #-258	; 0xfffffefe
    2fd8:	40404000 	submi	r4, r0, r0
    2fdc:	00004040 	andeq	r4, r0, r0, asr #32
    2fe0:	00040201 	andeq	r0, r4, r1, lsl #4
    2fe4:	54542000 	ldrbpl	r2, [r4], #-0
    2fe8:	7f007854 	svcvc	0x00007854
    2fec:	38444448 	stmdacc	r4, {r3, r6, sl, lr}^
    2ff0:	44443800 	strbmi	r3, [r4], #-2048	; 0xfffff800
    2ff4:	38002044 	stmdacc	r0, {r2, r6, sp}
    2ff8:	7f484444 	svcvc	0x00484444
    2ffc:	54543800 	ldrbpl	r3, [r4], #-2048	; 0xfffff800
    3000:	08001854 	stmdaeq	r0, {r2, r4, r6, fp, ip}
    3004:	0201097e 	andeq	r0, r1, #2064384	; 0x1f8000
    3008:	a4a41800 	strtge	r1, [r4], #2048	; 0x800
    300c:	7f007ca4 	svcvc	0x00007ca4
    3010:	78040408 	stmdavc	r4, {r3, sl}
    3014:	7d440000 	stclvc	0, cr0, [r4, #-0]
    3018:	40000040 	andmi	r0, r0, r0, asr #32
    301c:	007d8480 	rsbseq	r8, sp, r0, lsl #9
    3020:	28107f00 	ldmdacs	r0, {r8, r9, sl, fp, ip, sp, lr}
    3024:	00000044 	andeq	r0, r0, r4, asr #32
    3028:	00407f41 	subeq	r7, r0, r1, asr #30
    302c:	18047c00 	stmdane	r4, {sl, fp, ip, sp, lr}
    3030:	7c007804 	stcvc	8, cr7, [r0], {4}
    3034:	78040408 	stmdavc	r4, {r3, sl}
    3038:	44443800 	strbmi	r3, [r4], #-2048	; 0xfffff800
    303c:	fc003844 	stc2	8, cr3, [r0], {68}	; 0x44
    3040:	18242424 	stmdane	r4!, {r2, r5, sl, sp}
    3044:	24241800 	strtcs	r1, [r4], #-2048	; 0xfffff800
    3048:	7c00fc18 	stcvc	12, cr15, [r0], {24}
    304c:	08040408 	stmdaeq	r4, {r3, sl}
    3050:	54544800 	ldrbpl	r4, [r4], #-2048	; 0xfffff800
    3054:	04002054 	streq	r2, [r0], #-84	; 0xffffffac
    3058:	2040443f 	subcs	r4, r0, pc, lsr r4
    305c:	40403c00 	submi	r3, r0, r0, lsl #24
    3060:	1c007c20 	stcne	12, cr7, [r0], {32}
    3064:	1c204020 	stcne	0, cr4, [r0], #-128	; 0xffffff80
    3068:	30403c00 	subcc	r3, r0, r0, lsl #24
    306c:	44003c40 	strmi	r3, [r0], #-3136	; 0xfffff3c0
    3070:	44281028 	strtmi	r1, [r8], #-40	; 0xffffffd8
    3074:	a0a01c00 	adcge	r1, r0, r0, lsl #24
    3078:	44007ca0 	strmi	r7, [r0], #-3232	; 0xfffff360
    307c:	444c5464 	strbmi	r5, [ip], #-1124	; 0xfffffb9c
    3080:	77080000 	strvc	r0, [r8, -r0]
    3084:	00000000 	andeq	r0, r0, r0
    3088:	00007f00 	andeq	r7, r0, r0, lsl #30
    308c:	08770000 	ldmdaeq	r7!, {}^	; <UNPREDICTABLE>
    3090:	10000000 	andne	r0, r0, r0
    3094:	00081008 	andeq	r1, r8, r8
    3098:	00000000 	andeq	r0, r0, r0
    309c:	26000000 	strcs	r0, [r0], -r0
    30a0:	00000bde 	ldrdeq	r0, [r0], -lr
    30a4:	000beb26 	andeq	lr, fp, r6, lsr #22
    30a8:	0bf82600 	bleq	ffe0c8b0 <__bss_end+0xffe0316c>
    30ac:	05260000 	streq	r0, [r6, #-0]!
    30b0:	2600000c 	strcs	r0, [r0], -ip
    30b4:	00000c12 	andeq	r0, r0, r2, lsl ip
    30b8:	00005018 	andeq	r5, r0, r8, lsl r0
    30bc:	000e9800 	andeq	r9, lr, r0, lsl #16
    30c0:	00852900 	addeq	r2, r5, r0, lsl #18
    30c4:	023f0000 	eorseq	r0, pc, #0
    30c8:	0e870300 	cdpeq	3, 8, cr0, cr7, cr0, {0}
    30cc:	1f260000 	svcne	0x00260000
    30d0:	2a00000c 	bcs	3108 <shift+0x3108>
    30d4:	000001ae 	andeq	r0, r0, lr, lsr #3
    30d8:	bc065d01 	stclt	13, cr5, [r6], {1}
    30dc:	5c00000e 	stcpl	0, cr0, [r0], {14}
    30e0:	b0000090 	mullt	r0, r0, r0
    30e4:	01000000 	mrseq	r0, (UNDEF: 0)
    30e8:	000f0f9c 	muleq	pc, ip, pc	; <UNPREDICTABLE>
    30ec:	192a2b00 	stmdbne	sl!, {r8, r9, fp, sp}
    30f0:	01ec0000 	mvneq	r0, r0
    30f4:	91020000 	mrsls	r0, (UNDEF: 2)
    30f8:	00782c6c 	rsbseq	r2, r8, ip, ror #24
    30fc:	5c295d01 	stcpl	13, cr5, [r9], #-4
    3100:	02000000 	andeq	r0, r0, #0
    3104:	792c6a91 	stmdbvc	ip!, {r0, r4, r7, r9, fp, sp, lr}
    3108:	355d0100 	ldrbcc	r0, [sp, #-256]	; 0xffffff00
    310c:	0000005c 	andeq	r0, r0, ip, asr r0
    3110:	2c689102 	stfcsp	f1, [r8], #-8
    3114:	00727473 	rsbseq	r7, r2, r3, ror r4
    3118:	f1445d01 			; <UNDEFINED> instruction: 0xf1445d01
    311c:	02000001 	andeq	r0, r0, #1
    3120:	782d6491 	stmdavc	sp!, {r0, r4, r7, sl, sp, lr}
    3124:	62010069 	andvs	r0, r1, #105	; 0x69
    3128:	00005c0e 	andeq	r5, r0, lr, lsl #24
    312c:	76910200 	ldrvc	r0, [r1], r0, lsl #4
    3130:	7274702d 	rsbsvc	r7, r4, #45	; 0x2d
    3134:	11630100 	cmnne	r3, r0, lsl #2
    3138:	000001f1 	strdeq	r0, [r0], -r1
    313c:	00709102 	rsbseq	r9, r0, r2, lsl #2
    3140:	00011f2a 	andeq	r1, r1, sl, lsr #30
    3144:	06520100 	ldrbeq	r0, [r2], -r0, lsl #2
    3148:	00000f29 	andeq	r0, r0, r9, lsr #30
    314c:	00009004 	andeq	r9, r0, r4
    3150:	00000058 	andeq	r0, r0, r8, asr r0
    3154:	0f459c01 	svceq	0x00459c01
    3158:	2a2b0000 	bcs	ac3160 <__bss_end+0xab9a1c>
    315c:	ec000019 	stc	0, cr0, [r0], {25}
    3160:	02000001 	andeq	r0, r0, #1
    3164:	702d6c91 	mlavc	sp, r1, ip, r6
    3168:	0100746b 	tsteq	r0, fp, ror #8
    316c:	0a062357 	beq	18bed0 <__bss_end+0x18278c>
    3170:	91020000 	mrsls	r0, (UNDEF: 2)
    3174:	842a0074 	strthi	r0, [sl], #-116	; 0xffffff8c
    3178:	01000001 	tsteq	r0, r1
    317c:	0f5f063a 	svceq	0x005f063a
    3180:	8e9c0000 	cdphi	0, 9, cr0, cr12, cr0, {0}
    3184:	01680000 	cmneq	r8, r0
    3188:	9c010000 	stcls	0, cr0, [r1], {-0}
    318c:	00000fb1 			; <UNDEFINED> instruction: 0x00000fb1
    3190:	00192a2b 	andseq	r2, r9, fp, lsr #20
    3194:	0001ec00 	andeq	lr, r1, r0, lsl #24
    3198:	5c910200 	lfmpl	f0, 4, [r1], {0}
    319c:	0100782c 	tsteq	r0, ip, lsr #16
    31a0:	005c273a 	subseq	r2, ip, sl, lsr r7
    31a4:	91020000 	mrsls	r0, (UNDEF: 2)
    31a8:	00792c5a 	rsbseq	r2, r9, sl, asr ip
    31ac:	5c333a01 			; <UNDEFINED> instruction: 0x5c333a01
    31b0:	02000000 	andeq	r0, r0, #0
    31b4:	632c5891 			; <UNDEFINED> instruction: 0x632c5891
    31b8:	3b3a0100 	blcc	e835c0 <__bss_end+0xe79e7c>
    31bc:	00000025 	andeq	r0, r0, r5, lsr #32
    31c0:	2d579102 	ldfcsp	f1, [r7, #-8]
    31c4:	00667562 	rsbeq	r7, r6, r2, ror #10
    31c8:	b10a4301 	tstlt	sl, r1, lsl #6
    31cc:	0200000f 	andeq	r0, r0, #15
    31d0:	702d6091 	mlavc	sp, r1, r0, r6
    31d4:	01007274 	tsteq	r0, r4, ror r2
    31d8:	0fc11e45 	svceq	0x00c11e45
    31dc:	91020000 	mrsls	r0, (UNDEF: 2)
    31e0:	25180074 	ldrcs	r0, [r8, #-116]	; 0xffffff8c
    31e4:	c1000000 	mrsgt	r0, (UNDEF: 0)
    31e8:	1900000f 	stmdbne	r0, {r0, r1, r2, r3}
    31ec:	00000085 	andeq	r0, r0, r5, lsl #1
    31f0:	040d0010 	streq	r0, [sp], #-16
    31f4:	00000a7e 	andeq	r0, r0, lr, ror sl
    31f8:	00015a2a 	andeq	r5, r1, sl, lsr #20
    31fc:	062b0100 	strteq	r0, [fp], -r0, lsl #2
    3200:	00000fe1 	andeq	r0, r0, r1, ror #31
    3204:	00008db0 			; <UNDEFINED> instruction: 0x00008db0
    3208:	000000ec 	andeq	r0, r0, ip, ror #1
    320c:	10269c01 	eorne	r9, r6, r1, lsl #24
    3210:	2a2b0000 	bcs	ac3218 <__bss_end+0xab9ad4>
    3214:	ec000019 	stc	0, cr0, [r0], {25}
    3218:	02000001 	andeq	r0, r0, #1
    321c:	782c6c91 	stmdavc	ip!, {r0, r4, r7, sl, fp, sp, lr}
    3220:	282b0100 	stmdacs	fp!, {r8}
    3224:	0000005c 	andeq	r0, r0, ip, asr r0
    3228:	2c6a9102 	stfcsp	f1, [sl], #-8
    322c:	2b010079 	blcs	43418 <__bss_end+0x39cd4>
    3230:	00005c34 	andeq	r5, r0, r4, lsr ip
    3234:	68910200 	ldmvs	r1, {r9}
    3238:	7465732c 	strbtvc	r7, [r5], #-812	; 0xfffffcd4
    323c:	3c2b0100 	stfccs	f0, [fp], #-0
    3240:	000001da 	ldrdeq	r0, [r0], -sl
    3244:	2d679102 	stfcsp	f1, [r7, #-8]!
    3248:	00746b70 	rsbseq	r6, r4, r0, ror fp
    324c:	49263101 	stmdbmi	r6!, {r0, r8, ip, sp}
    3250:	0200000a 	andeq	r0, r0, #10
    3254:	2a007091 	bcs	1f4a0 <__bss_end+0x15d5c>
    3258:	0000013a 	andeq	r0, r0, sl, lsr r1
    325c:	40062001 	andmi	r2, r6, r1
    3260:	34000010 	strcc	r0, [r0], #-16
    3264:	7c00008d 	stcvc	0, cr0, [r0], {141}	; 0x8d
    3268:	01000000 	mrseq	r0, (UNDEF: 0)
    326c:	00106b9c 	mulseq	r0, ip, fp
    3270:	192a2b00 	stmdbne	sl!, {r8, r9, fp, sp}
    3274:	01ec0000 	mvneq	r0, r0
    3278:	91020000 	mrsls	r0, (UNDEF: 2)
    327c:	1a192e6c 	bne	64ec34 <__bss_end+0x6454f0>
    3280:	20010000 	andcs	r0, r1, r0
    3284:	0001da20 	andeq	sp, r1, r0, lsr #20
    3288:	6b910200 	blvs	fe443a90 <__bss_end+0xfe43a34c>
    328c:	746b702d 	strbtvc	r7, [fp], #-45	; 0xffffffd3
    3290:	1b250100 	blne	943698 <__bss_end+0x939f54>
    3294:	00000a21 	andeq	r0, r0, r1, lsr #20
    3298:	00749102 	rsbseq	r9, r4, r2, lsl #2
    329c:	0001002f 	andeq	r0, r1, pc, lsr #32
    32a0:	061b0100 	ldreq	r0, [fp], -r0, lsl #2
    32a4:	00001085 	andeq	r1, r0, r5, lsl #1
    32a8:	00008d0c 	andeq	r8, r0, ip, lsl #26
    32ac:	00000028 	andeq	r0, r0, r8, lsr #32
    32b0:	10929c01 	addsne	r9, r2, r1, lsl #24
    32b4:	2a2b0000 	bcs	ac32bc <__bss_end+0xab9b78>
    32b8:	ff000019 			; <UNDEFINED> instruction: 0xff000019
    32bc:	02000001 	andeq	r0, r0, #1
    32c0:	30007491 	mulcc	r0, r1, r4
    32c4:	000000dc 	ldrdeq	r0, [r0], -ip
    32c8:	a3011101 	movwge	r1, #4353	; 0x1101
    32cc:	00000010 	andeq	r0, r0, r0, lsl r0
    32d0:	000010b6 	strheq	r1, [r0], -r6
    32d4:	00192a31 	andseq	r2, r9, r1, lsr sl
    32d8:	0001ec00 	andeq	lr, r1, r0, lsl #24
    32dc:	18eb3100 	stmiane	fp!, {r8, ip, sp}^
    32e0:	003f0000 	eorseq	r0, pc, r0
    32e4:	32000000 	andcc	r0, r0, #0
    32e8:	00001092 	muleq	r0, r2, r0
    32ec:	00001a61 	andeq	r1, r0, r1, ror #20
    32f0:	000010d1 	ldrdeq	r1, [r0], -r1	; <UNPREDICTABLE>
    32f4:	00008cc0 	andeq	r8, r0, r0, asr #25
    32f8:	0000004c 	andeq	r0, r0, ip, asr #32
    32fc:	10da9c01 	sbcsne	r9, sl, r1, lsl #24
    3300:	a3330000 	teqge	r3, #0
    3304:	02000010 	andeq	r0, r0, #16
    3308:	30007491 	mulcc	r0, r1, r4
    330c:	000000b8 	strheq	r0, [r0], -r8
    3310:	eb010a01 	bl	45b1c <__bss_end+0x3c3d8>
    3314:	00000010 	andeq	r0, r0, r0, lsl r0
    3318:	00001101 	andeq	r1, r0, r1, lsl #2
    331c:	00192a31 	andseq	r2, r9, r1, lsr sl
    3320:	0001ec00 	andeq	lr, r1, r0, lsl #24
    3324:	19953400 	ldmibne	r5, {sl, ip, sp}
    3328:	0a010000 	beq	43330 <__bss_end+0x39bec>
    332c:	0001f12a 	andeq	pc, r1, sl, lsr #2
    3330:	da350000 	ble	d43338 <__bss_end+0xd39bf4>
    3334:	22000010 	andcs	r0, r0, #16
    3338:	1800001a 	stmdane	r0, {r1, r3, r4}
    333c:	58000011 	stmdapl	r0, {r0, r4}
    3340:	6800008c 	stmdavs	r0, {r2, r3, r7}
    3344:	01000000 	mrseq	r0, (UNDEF: 0)
    3348:	10eb339c 	smlalne	r3, fp, ip, r3
    334c:	91020000 	mrsls	r0, (UNDEF: 2)
    3350:	10f43374 	rscsne	r3, r4, r4, ror r3
    3354:	91020000 	mrsls	r0, (UNDEF: 2)
    3358:	22000070 	andcs	r0, r0, #112	; 0x70
    335c:	02000000 	andeq	r0, r0, #0
    3360:	000b8b00 	andeq	r8, fp, r0, lsl #22
    3364:	9c010400 	cfstrsls	mvf0, [r1], {-0}
    3368:	0c00000c 	stceq	0, cr0, [r0], {12}
    336c:	18000091 	stmdane	r0, {r0, r4, r7}
    3370:	78000093 	stmdavc	r0, {r0, r1, r4, r7}
    3374:	a800001a 	stmdage	r0, {r1, r3, r4}
    3378:	6100001a 	tstvs	r0, sl, lsl r0
    337c:	01000000 	mrseq	r0, (UNDEF: 0)
    3380:	00002280 	andeq	r2, r0, r0, lsl #5
    3384:	9f000200 	svcls	0x00000200
    3388:	0400000b 	streq	r0, [r0], #-11
    338c:	000d1901 	andeq	r1, sp, r1, lsl #18
    3390:	00931800 	addseq	r1, r3, r0, lsl #16
    3394:	00931c00 	addseq	r1, r3, r0, lsl #24
    3398:	001a7800 	andseq	r7, sl, r0, lsl #16
    339c:	001aa800 	andseq	sl, sl, r0, lsl #16
    33a0:	00006100 	andeq	r6, r0, r0, lsl #2
    33a4:	32800100 	addcc	r0, r0, #0, 2
    33a8:	04000009 	streq	r0, [r0], #-9
    33ac:	000bb300 	andeq	fp, fp, r0, lsl #6
    33b0:	76010400 	strvc	r0, [r1], -r0, lsl #8
    33b4:	0c00001e 	stceq	0, cr0, [r0], {30}
    33b8:	00001dcd 	andeq	r1, r0, sp, asr #27
    33bc:	00001aa8 	andeq	r1, r0, r8, lsr #21
    33c0:	00000d79 	andeq	r0, r0, r9, ror sp
    33c4:	69050402 	stmdbvs	r5, {r1, sl}
    33c8:	0300746e 	movweq	r7, #1134	; 0x46e
    33cc:	1fa30704 	svcne	0x00a30704
    33d0:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    33d4:	00035705 	andeq	r5, r3, r5, lsl #14
    33d8:	04080300 	streq	r0, [r8], #-768	; 0xfffffd00
    33dc:	00002675 	andeq	r2, r0, r5, ror r6
    33e0:	001e2804 	andseq	r2, lr, r4, lsl #16
    33e4:	162a0100 	strtne	r0, [sl], -r0, lsl #2
    33e8:	00000024 	andeq	r0, r0, r4, lsr #32
    33ec:	00229704 	eoreq	r9, r2, r4, lsl #14
    33f0:	152f0100 	strne	r0, [pc, #-256]!	; 32f8 <shift+0x32f8>
    33f4:	00000051 	andeq	r0, r0, r1, asr r0
    33f8:	00570405 	subseq	r0, r7, r5, lsl #8
    33fc:	39060000 	stmdbcc	r6, {}	; <UNPREDICTABLE>
    3400:	66000000 	strvs	r0, [r0], -r0
    3404:	07000000 	streq	r0, [r0, -r0]
    3408:	00000066 	andeq	r0, r0, r6, rrx
    340c:	6c040500 	cfstr32vs	mvfx0, [r4], {-0}
    3410:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    3414:	0029c904 	eoreq	ip, r9, r4, lsl #18
    3418:	0f360100 	svceq	0x00360100
    341c:	00000079 	andeq	r0, r0, r9, ror r0
    3420:	007f0405 	rsbseq	r0, pc, r5, lsl #8
    3424:	1d060000 	stcne	0, cr0, [r6, #-0]
    3428:	93000000 	movwls	r0, #0
    342c:	07000000 	streq	r0, [r0, -r0]
    3430:	00000066 	andeq	r0, r0, r6, rrx
    3434:	00006607 	andeq	r6, r0, r7, lsl #12
    3438:	01030000 	mrseq	r0, (UNDEF: 3)
    343c:	0010b108 	andseq	fp, r0, r8, lsl #2
    3440:	24cf0900 	strbcs	r0, [pc], #2304	; 3448 <shift+0x3448>
    3444:	bb010000 	bllt	4344c <__bss_end+0x39d08>
    3448:	00004512 	andeq	r4, r0, r2, lsl r5
    344c:	29f70900 	ldmibcs	r7!, {r8, fp}^
    3450:	be010000 	cdplt	0, 0, cr0, cr1, cr0, {0}
    3454:	00006d10 	andeq	r6, r0, r0, lsl sp
    3458:	06010300 	streq	r0, [r1], -r0, lsl #6
    345c:	000010b3 	strheq	r1, [r0], -r3
    3460:	0021b70a 	eoreq	fp, r1, sl, lsl #14
    3464:	93010700 	movwls	r0, #5888	; 0x1700
    3468:	02000000 	andeq	r0, r0, #0
    346c:	01e60617 	mvneq	r0, r7, lsl r6
    3470:	860b0000 	strhi	r0, [fp], -r0
    3474:	0000001c 	andeq	r0, r0, ip, lsl r0
    3478:	0020d40b 	eoreq	sp, r0, fp, lsl #8
    347c:	9a0b0100 	bls	2c3884 <__bss_end+0x2ba140>
    3480:	02000025 	andeq	r0, r0, #37	; 0x25
    3484:	00290b0b 	eoreq	r0, r9, fp, lsl #22
    3488:	3e0b0300 	cdpcc	3, 0, cr0, cr11, cr0, {0}
    348c:	04000025 	streq	r0, [r0], #-37	; 0xffffffdb
    3490:	0028140b 	eoreq	r1, r8, fp, lsl #8
    3494:	780b0500 	stmdavc	fp, {r8, sl}
    3498:	06000027 	streq	r0, [r0], -r7, lsr #32
    349c:	001ca70b 	andseq	sl, ip, fp, lsl #14
    34a0:	290b0700 	stmdbcs	fp, {r8, r9, sl}
    34a4:	08000028 	stmdaeq	r0, {r3, r5}
    34a8:	0028370b 	eoreq	r3, r8, fp, lsl #14
    34ac:	fe0b0900 	vseleq.f16	s0, s22, s0
    34b0:	0a000028 	beq	3558 <shift+0x3558>
    34b4:	0024950b 	eoreq	r9, r4, fp, lsl #10
    34b8:	690b0b00 	stmdbvs	fp, {r8, r9, fp}
    34bc:	0c00001e 	stceq	0, cr0, [r0], {30}
    34c0:	001f460b 	andseq	r4, pc, fp, lsl #12
    34c4:	fb0b0d00 	blx	2c68ce <__bss_end+0x2bd18a>
    34c8:	0e000021 	cdpeq	0, 0, cr0, cr0, cr1, {1}
    34cc:	0022110b 	eoreq	r1, r2, fp, lsl #2
    34d0:	0e0b0f00 	cdpeq	15, 0, cr0, cr11, cr0, {0}
    34d4:	10000021 	andne	r0, r0, r1, lsr #32
    34d8:	0025220b 	eoreq	r2, r5, fp, lsl #4
    34dc:	7a0b1100 	bvc	2c78e4 <__bss_end+0x2be1a0>
    34e0:	12000021 	andne	r0, r0, #33	; 0x21
    34e4:	002b900b 	eoreq	r9, fp, fp
    34e8:	100b1300 	andne	r1, fp, r0, lsl #6
    34ec:	1400001d 	strne	r0, [r0], #-29	; 0xffffffe3
    34f0:	00219e0b 	eoreq	r9, r1, fp, lsl #28
    34f4:	4d0b1500 	cfstr32mi	mvfx1, [fp, #-0]
    34f8:	1600001c 			; <UNDEFINED> instruction: 0x1600001c
    34fc:	00292e0b 	eoreq	r2, r9, fp, lsl #28
    3500:	500b1700 	andpl	r1, fp, r0, lsl #14
    3504:	1800002a 	stmdane	r0, {r1, r3, r5}
    3508:	0021c30b 	eoreq	ip, r1, fp, lsl #6
    350c:	0c0b1900 			; <UNDEFINED> instruction: 0x0c0b1900
    3510:	1a000026 	bne	35b0 <shift+0x35b0>
    3514:	00293c0b 	eoreq	r3, r9, fp, lsl #24
    3518:	7c0b1b00 			; <UNDEFINED> instruction: 0x7c0b1b00
    351c:	1c00001b 	stcne	0, cr0, [r0], {27}
    3520:	00294a0b 	eoreq	r4, r9, fp, lsl #20
    3524:	580b1d00 	stmdapl	fp, {r8, sl, fp, ip}
    3528:	1e000029 	cdpne	0, 0, cr0, cr0, cr9, {1}
    352c:	001b2a0b 	andseq	r2, fp, fp, lsl #20
    3530:	820b1f00 	andhi	r1, fp, #0, 30
    3534:	20000029 	andcs	r0, r0, r9, lsr #32
    3538:	0026b90b 	eoreq	fp, r6, fp, lsl #18
    353c:	f40b2100 	vst4.8	{d2,d4,d6,d8}, [fp], r0
    3540:	22000024 	andcs	r0, r0, #36	; 0x24
    3544:	0029210b 	eoreq	r2, r9, fp, lsl #2
    3548:	f80b2300 			; <UNDEFINED> instruction: 0xf80b2300
    354c:	24000023 	strcs	r0, [r0], #-35	; 0xffffffdd
    3550:	0022fa0b 	eoreq	pc, r2, fp, lsl #20
    3554:	140b2500 	strne	r2, [fp], #-1280	; 0xfffffb00
    3558:	26000020 	strcs	r0, [r0], -r0, lsr #32
    355c:	0023180b 	eoreq	r1, r3, fp, lsl #16
    3560:	b00b2700 	andlt	r2, fp, r0, lsl #14
    3564:	28000020 	stmdacs	r0, {r5}
    3568:	0023280b 	eoreq	r2, r3, fp, lsl #16
    356c:	380b2900 	stmdacc	fp, {r8, fp, sp}
    3570:	2a000023 	bcs	3604 <shift+0x3604>
    3574:	00247b0b 	eoreq	r7, r4, fp, lsl #22
    3578:	a10b2b00 	tstge	fp, r0, lsl #22
    357c:	2c000022 	stccs	0, cr0, [r0], {34}	; 0x22
    3580:	0026c60b 	eoreq	ip, r6, fp, lsl #12
    3584:	550b2d00 	strpl	r2, [fp, #-3328]	; 0xfffff300
    3588:	2e000020 	cdpcs	0, 0, cr0, cr0, cr0, {1}
    358c:	22330a00 	eorscs	r0, r3, #0, 20
    3590:	01070000 	mrseq	r0, (UNDEF: 7)
    3594:	00000093 	muleq	r0, r3, r0
    3598:	c7061703 	strgt	r1, [r6, -r3, lsl #14]
    359c:	0b000003 	bleq	35b0 <shift+0x35b0>
    35a0:	00001f68 	andeq	r1, r0, r8, ror #30
    35a4:	1bba0b00 	blne	fee861ac <__bss_end+0xfee7ca68>
    35a8:	0b010000 	bleq	435b0 <__bss_end+0x39e6c>
    35ac:	00002b3e 	andeq	r2, r0, lr, lsr fp
    35b0:	29d10b02 	ldmibcs	r1, {r1, r8, r9, fp}^
    35b4:	0b030000 	bleq	c35bc <__bss_end+0xb9e78>
    35b8:	00001f88 	andeq	r1, r0, r8, lsl #31
    35bc:	1c720b04 			; <UNDEFINED> instruction: 0x1c720b04
    35c0:	0b050000 	bleq	1435c8 <__bss_end+0x139e84>
    35c4:	00002031 	andeq	r2, r0, r1, lsr r0
    35c8:	1f780b06 	svcne	0x00780b06
    35cc:	0b070000 	bleq	1c35d4 <__bss_end+0x1b9e90>
    35d0:	00002865 	andeq	r2, r0, r5, ror #16
    35d4:	29b60b08 	ldmibcs	r6!, {r3, r8, r9, fp}
    35d8:	0b090000 	bleq	2435e0 <__bss_end+0x239e9c>
    35dc:	0000279c 	muleq	r0, ip, r7
    35e0:	1cc50b0a 	vstmiane	r5, {d16-d20}
    35e4:	0b0b0000 	bleq	2c35ec <__bss_end+0x2b9ea8>
    35e8:	00001fd2 	ldrdeq	r1, [r0], -r2
    35ec:	1c3b0b0c 			; <UNDEFINED> instruction: 0x1c3b0b0c
    35f0:	0b0d0000 	bleq	3435f8 <__bss_end+0x339eb4>
    35f4:	00002b73 	andeq	r2, r0, r3, ror fp
    35f8:	24680b0e 	strbtcs	r0, [r8], #-2830	; 0xfffff4f2
    35fc:	0b0f0000 	bleq	3c3604 <__bss_end+0x3b9ec0>
    3600:	00002145 	andeq	r2, r0, r5, asr #2
    3604:	24a50b10 	strtcs	r0, [r5], #2832	; 0xb10
    3608:	0b110000 	bleq	443610 <__bss_end+0x439ecc>
    360c:	00002a92 	muleq	r0, r2, sl
    3610:	1d880b12 	vstrne	d0, [r8, #72]	; 0x48
    3614:	0b130000 	bleq	4c361c <__bss_end+0x4b9ed8>
    3618:	00002158 	andeq	r2, r0, r8, asr r1
    361c:	23bb0b14 			; <UNDEFINED> instruction: 0x23bb0b14
    3620:	0b150000 	bleq	543628 <__bss_end+0x539ee4>
    3624:	00001f53 	andeq	r1, r0, r3, asr pc
    3628:	24070b16 	strcs	r0, [r7], #-2838	; 0xfffff4ea
    362c:	0b170000 	bleq	5c3634 <__bss_end+0x5b9ef0>
    3630:	0000221d 	andeq	r2, r0, sp, lsl r2
    3634:	1c900b18 	vldmiane	r0, {d0-d11}
    3638:	0b190000 	bleq	643640 <__bss_end+0x639efc>
    363c:	00002a39 	andeq	r2, r0, r9, lsr sl
    3640:	23870b1a 	orrcs	r0, r7, #26624	; 0x6800
    3644:	0b1b0000 	bleq	6c364c <__bss_end+0x6b9f08>
    3648:	0000212f 	andeq	r2, r0, pc, lsr #2
    364c:	1b650b1c 	blne	19462c4 <__bss_end+0x193cb80>
    3650:	0b1d0000 	bleq	743658 <__bss_end+0x739f14>
    3654:	000022d2 	ldrdeq	r2, [r0], -r2	; <UNPREDICTABLE>
    3658:	22be0b1e 	adcscs	r0, lr, #30720	; 0x7800
    365c:	0b1f0000 	bleq	7c3664 <__bss_end+0x7b9f20>
    3660:	00002759 	andeq	r2, r0, r9, asr r7
    3664:	27e40b20 	strbcs	r0, [r4, r0, lsr #22]!
    3668:	0b210000 	bleq	843670 <__bss_end+0x839f2c>
    366c:	00002a18 	andeq	r2, r0, r8, lsl sl
    3670:	20620b22 	rsbcs	r0, r2, r2, lsr #22
    3674:	0b230000 	bleq	8c367c <__bss_end+0x8b9f38>
    3678:	000025bc 			; <UNDEFINED> instruction: 0x000025bc
    367c:	27b10b24 	ldrcs	r0, [r1, r4, lsr #22]!
    3680:	0b250000 	bleq	943688 <__bss_end+0x939f44>
    3684:	000026d5 	ldrdeq	r2, [r0], -r5
    3688:	26e90b26 	strbtcs	r0, [r9], r6, lsr #22
    368c:	0b270000 	bleq	9c3694 <__bss_end+0x9b9f50>
    3690:	000026fd 	strdeq	r2, [r0], -sp
    3694:	1e130b28 	vnmlsne.f64	d0, d3, d24
    3698:	0b290000 	bleq	a436a0 <__bss_end+0xa39f5c>
    369c:	00001d73 	andeq	r1, r0, r3, ror sp
    36a0:	1d9b0b2a 	vldrne	d0, [fp, #168]	; 0xa8
    36a4:	0b2b0000 	bleq	ac36ac <__bss_end+0xab9f68>
    36a8:	000028ae 	andeq	r2, r0, lr, lsr #17
    36ac:	1df00b2c 			; <UNDEFINED> instruction: 0x1df00b2c
    36b0:	0b2d0000 	bleq	b436b8 <__bss_end+0xb39f74>
    36b4:	000028c2 	andeq	r2, r0, r2, asr #17
    36b8:	28d60b2e 	ldmcs	r6, {r1, r2, r3, r5, r8, r9, fp}^
    36bc:	0b2f0000 	bleq	bc36c4 <__bss_end+0xbb9f80>
    36c0:	000028ea 	andeq	r2, r0, sl, ror #17
    36c4:	1fe40b30 	svcne	0x00e40b30
    36c8:	0b310000 	bleq	c436d0 <__bss_end+0xc39f8c>
    36cc:	00001fbe 			; <UNDEFINED> instruction: 0x00001fbe
    36d0:	22e60b32 	rsccs	r0, r6, #51200	; 0xc800
    36d4:	0b330000 	bleq	cc36dc <__bss_end+0xcb9f98>
    36d8:	000024b8 			; <UNDEFINED> instruction: 0x000024b8
    36dc:	2ac70b34 	bcs	ff1c63b4 <__bss_end+0xff1bcc70>
    36e0:	0b350000 	bleq	d436e8 <__bss_end+0xd39fa4>
    36e4:	00001b0d 	andeq	r1, r0, sp, lsl #22
    36e8:	20e40b36 	rsccs	r0, r4, r6, lsr fp
    36ec:	0b370000 	bleq	dc36f4 <__bss_end+0xdb9fb0>
    36f0:	000020f9 	strdeq	r2, [r0], -r9
    36f4:	23480b38 	movtcs	r0, #35640	; 0x8b38
    36f8:	0b390000 	bleq	e43700 <__bss_end+0xe39fbc>
    36fc:	00002372 	andeq	r2, r0, r2, ror r3
    3700:	2af00b3a 	bcs	ffc063f0 <__bss_end+0xffbfccac>
    3704:	0b3b0000 	bleq	ec370c <__bss_end+0xeb9fc8>
    3708:	000025a7 	andeq	r2, r0, r7, lsr #11
    370c:	20870b3c 	addcs	r0, r7, ip, lsr fp
    3710:	0b3d0000 	bleq	f43718 <__bss_end+0xf39fd4>
    3714:	00001bcc 	andeq	r1, r0, ip, asr #23
    3718:	1b8a0b3e 	blne	fe286418 <__bss_end+0xfe27ccd4>
    371c:	0b3f0000 	bleq	fc3724 <__bss_end+0xfb9fe0>
    3720:	00002504 	andeq	r2, r0, r4, lsl #10
    3724:	26280b40 	strtcs	r0, [r8], -r0, asr #22
    3728:	0b410000 	bleq	1043730 <__bss_end+0x1039fec>
    372c:	0000273b 	andeq	r2, r0, fp, lsr r7
    3730:	235d0b42 	cmpcs	sp, #67584	; 0x10800
    3734:	0b430000 	bleq	10c373c <__bss_end+0x10b9ff8>
    3738:	00002b29 	andeq	r2, r0, r9, lsr #22
    373c:	25d20b44 	ldrbcs	r0, [r2, #2884]	; 0xb44
    3740:	0b450000 	bleq	1143748 <__bss_end+0x113a004>
    3744:	00001db7 			; <UNDEFINED> instruction: 0x00001db7
    3748:	24380b46 	ldrtcs	r0, [r8], #-2886	; 0xfffff4ba
    374c:	0b470000 	bleq	11c3754 <__bss_end+0x11ba010>
    3750:	0000226b 	andeq	r2, r0, fp, ror #4
    3754:	1b490b48 	blne	124647c <__bss_end+0x123cd38>
    3758:	0b490000 	bleq	1243760 <__bss_end+0x123a01c>
    375c:	00001c5d 	andeq	r1, r0, sp, asr ip
    3760:	209b0b4a 	addscs	r0, fp, sl, asr #22
    3764:	0b4b0000 	bleq	12c376c <__bss_end+0x12ba028>
    3768:	00002399 	muleq	r0, r9, r3
    376c:	0203004c 	andeq	r0, r3, #76	; 0x4c
    3770:	00126c07 	andseq	r6, r2, r7, lsl #24
    3774:	03e40c00 	mvneq	r0, #0, 24
    3778:	03d90000 	bicseq	r0, r9, #0
    377c:	000d0000 	andeq	r0, sp, r0
    3780:	0003ce0e 	andeq	ip, r3, lr, lsl #28
    3784:	f0040500 			; <UNDEFINED> instruction: 0xf0040500
    3788:	0e000003 	cdpeq	0, 0, cr0, cr0, cr3, {0}
    378c:	000003de 	ldrdeq	r0, [r0], -lr
    3790:	ba080103 	blt	203ba4 <__bss_end+0x1fa460>
    3794:	0e000010 	mcreq	0, 0, r0, cr0, cr0, {0}
    3798:	000003e9 	andeq	r0, r0, r9, ror #7
    379c:	001d010f 	andseq	r0, sp, pc, lsl #2
    37a0:	014c0400 	cmpeq	ip, r0, lsl #8
    37a4:	0003d91a 	andeq	sp, r3, sl, lsl r9
    37a8:	211f0f00 	tstcs	pc, r0, lsl #30
    37ac:	82040000 	andhi	r0, r4, #0
    37b0:	03d91a01 	bicseq	r1, r9, #4096	; 0x1000
    37b4:	e90c0000 	stmdb	ip, {}	; <UNPREDICTABLE>
    37b8:	1a000003 	bne	37cc <shift+0x37cc>
    37bc:	0d000004 	stceq	0, cr0, [r0, #-16]
    37c0:	230a0900 	movwcs	r0, #43264	; 0xa900
    37c4:	2d050000 	stccs	0, cr0, [r5, #-0]
    37c8:	00040f0d 	andeq	r0, r4, sp, lsl #30
    37cc:	29920900 	ldmibcs	r2, {r8, fp}
    37d0:	38050000 	stmdacc	r5, {}	; <UNPREDICTABLE>
    37d4:	0001e61c 	andeq	lr, r1, ip, lsl r6
    37d8:	1ff80a00 	svcne	0x00f80a00
    37dc:	01070000 	mrseq	r0, (UNDEF: 7)
    37e0:	00000093 	muleq	r0, r3, r0
    37e4:	a50e3a05 	strge	r3, [lr, #-2565]	; 0xfffff5fb
    37e8:	0b000004 	bleq	3800 <shift+0x3800>
    37ec:	00001b5e 	andeq	r1, r0, lr, asr fp
    37f0:	220a0b00 	andcs	r0, sl, #0, 22
    37f4:	0b010000 	bleq	437fc <__bss_end+0x3a0b8>
    37f8:	00002aa4 	andeq	r2, r0, r4, lsr #21
    37fc:	2a670b02 	bcs	19c640c <__bss_end+0x19bccc8>
    3800:	0b030000 	bleq	c3808 <__bss_end+0xba0c4>
    3804:	00002561 	andeq	r2, r0, r1, ror #10
    3808:	28220b04 	stmdacs	r2!, {r2, r8, r9, fp}
    380c:	0b050000 	bleq	143814 <__bss_end+0x13a0d0>
    3810:	00001d44 	andeq	r1, r0, r4, asr #26
    3814:	1d260b06 	vstmdbne	r6!, {d0-d2}
    3818:	0b070000 	bleq	1c3820 <__bss_end+0x1ba0dc>
    381c:	00001f3f 	andeq	r1, r0, pc, lsr pc
    3820:	241d0b08 	ldrcs	r0, [sp], #-2824	; 0xfffff4f8
    3824:	0b090000 	bleq	24382c <__bss_end+0x23a0e8>
    3828:	00001d4b 	andeq	r1, r0, fp, asr #26
    382c:	24240b0a 	strtcs	r0, [r4], #-2826	; 0xfffff4f6
    3830:	0b0b0000 	bleq	2c3838 <__bss_end+0x2ba0f4>
    3834:	00001db0 			; <UNDEFINED> instruction: 0x00001db0
    3838:	1d3d0b0c 	vldmdbne	sp!, {d0-d5}
    383c:	0b0d0000 	bleq	343844 <__bss_end+0x33a100>
    3840:	00002879 	andeq	r2, r0, r9, ror r8
    3844:	26460b0e 	strbcs	r0, [r6], -lr, lsl #22
    3848:	000f0000 	andeq	r0, pc, r0
    384c:	00277104 	eoreq	r7, r7, r4, lsl #2
    3850:	013f0500 	teqeq	pc, r0, lsl #10
    3854:	00000432 	andeq	r0, r0, r2, lsr r4
    3858:	00280509 	eoreq	r0, r8, r9, lsl #10
    385c:	0f410500 	svceq	0x00410500
    3860:	000004a5 	andeq	r0, r0, r5, lsr #9
    3864:	00288d09 	eoreq	r8, r8, r9, lsl #26
    3868:	0c4a0500 	cfstr64eq	mvdx0, [sl], {-0}
    386c:	0000001d 	andeq	r0, r0, sp, lsl r0
    3870:	001ce509 	andseq	lr, ip, r9, lsl #10
    3874:	0c4b0500 	cfstr64eq	mvdx0, [fp], {-0}
    3878:	0000001d 	andeq	r0, r0, sp, lsl r0
    387c:	00296610 	eoreq	r6, r9, r0, lsl r6
    3880:	289e0900 	ldmcs	lr, {r8, fp}
    3884:	4c050000 	stcmi	0, cr0, [r5], {-0}
    3888:	0004e614 	andeq	lr, r4, r4, lsl r6
    388c:	d5040500 	strle	r0, [r4, #-1280]	; 0xfffffb00
    3890:	11000004 	tstne	r0, r4
    3894:	0021d409 	eoreq	sp, r1, r9, lsl #8
    3898:	0f4e0500 	svceq	0x004e0500
    389c:	000004f9 	strdeq	r0, [r0], -r9
    38a0:	04ec0405 	strbteq	r0, [ip], #1029	; 0x405
    38a4:	87120000 	ldrhi	r0, [r2, -r0]
    38a8:	09000027 	stmdbeq	r0, {r0, r1, r2, r5}
    38ac:	0000254e 	andeq	r2, r0, lr, asr #10
    38b0:	100d5205 	andne	r5, sp, r5, lsl #4
    38b4:	05000005 	streq	r0, [r0, #-5]
    38b8:	0004ff04 	andeq	pc, r4, r4, lsl #30
    38bc:	1e5c1300 	cdpne	3, 5, cr1, cr12, cr0, {0}
    38c0:	05340000 	ldreq	r0, [r4, #-0]!
    38c4:	41150167 	tstmi	r5, r7, ror #2
    38c8:	14000005 	strne	r0, [r0], #-5
    38cc:	00002313 	andeq	r2, r0, r3, lsl r3
    38d0:	0f016905 	svceq	0x00016905
    38d4:	000003de 	ldrdeq	r0, [r0], -lr
    38d8:	1e401400 	cdpne	4, 4, cr1, cr0, cr0, {0}
    38dc:	6a050000 	bvs	1438e4 <__bss_end+0x13a1a0>
    38e0:	05461401 	strbeq	r1, [r6, #-1025]	; 0xfffffbff
    38e4:	00040000 	andeq	r0, r4, r0
    38e8:	0005160e 	andeq	r1, r5, lr, lsl #12
    38ec:	00b90c00 	adcseq	r0, r9, r0, lsl #24
    38f0:	05560000 	ldrbeq	r0, [r6, #-0]
    38f4:	24150000 	ldrcs	r0, [r5], #-0
    38f8:	2d000000 	stccs	0, cr0, [r0, #-0]
    38fc:	05410c00 	strbeq	r0, [r1, #-3072]	; 0xfffff400
    3900:	05610000 	strbeq	r0, [r1, #-0]!
    3904:	000d0000 	andeq	r0, sp, r0
    3908:	0005560e 	andeq	r5, r5, lr, lsl #12
    390c:	22420f00 	subcs	r0, r2, #0, 30
    3910:	6b050000 	blvs	143918 <__bss_end+0x13a1d4>
    3914:	05610301 	strbeq	r0, [r1, #-769]!	; 0xfffffcff
    3918:	880f0000 	stmdahi	pc, {}	; <UNPREDICTABLE>
    391c:	05000024 	streq	r0, [r0, #-36]	; 0xffffffdc
    3920:	1d0c016e 	stfnes	f0, [ip, #-440]	; 0xfffffe48
    3924:	16000000 	strne	r0, [r0], -r0
    3928:	000027c5 	andeq	r2, r0, r5, asr #15
    392c:	00930107 	addseq	r0, r3, r7, lsl #2
    3930:	81050000 	mrshi	r0, (UNDEF: 5)
    3934:	062a0601 	strteq	r0, [sl], -r1, lsl #12
    3938:	f30b0000 	vhadd.u8	d0, d11, d0
    393c:	0000001b 	andeq	r0, r0, fp, lsl r0
    3940:	001bff0b 	andseq	pc, fp, fp, lsl #30
    3944:	0b0b0200 	bleq	2c414c <__bss_end+0x2baa08>
    3948:	0300001c 	movweq	r0, #28
    394c:	0020240b 	eoreq	r2, r0, fp, lsl #8
    3950:	170b0300 	strne	r0, [fp, -r0, lsl #6]
    3954:	0400001c 	streq	r0, [r0], #-28	; 0xffffffe4
    3958:	00216d0b 	eoreq	r6, r1, fp, lsl #26
    395c:	530b0400 	movwpl	r0, #46080	; 0xb400
    3960:	05000022 	streq	r0, [r0, #-34]	; 0xffffffde
    3964:	0021a90b 	eoreq	sl, r1, fp, lsl #18
    3968:	d60b0500 	strle	r0, [fp], -r0, lsl #10
    396c:	0500001c 	streq	r0, [r0, #-28]	; 0xffffffe4
    3970:	001c230b 	andseq	r2, ip, fp, lsl #6
    3974:	d10b0600 	tstle	fp, r0, lsl #12
    3978:	06000023 	streq	r0, [r0], -r3, lsr #32
    397c:	001e320b 	andseq	r3, lr, fp, lsl #4
    3980:	de0b0600 	cfmadd32le	mvax0, mvfx0, mvfx11, mvfx0
    3984:	06000023 	streq	r0, [r0], -r3, lsr #32
    3988:	0028450b 	eoreq	r4, r8, fp, lsl #10
    398c:	eb0b0600 	bl	2c5194 <__bss_end+0x2bba50>
    3990:	06000023 	streq	r0, [r0], -r3, lsr #32
    3994:	00242b0b 	eoreq	r2, r4, fp, lsl #22
    3998:	2f0b0600 	svccs	0x000b0600
    399c:	0700001c 	smladeq	r0, ip, r0, r0
    39a0:	0025310b 	eoreq	r3, r5, fp, lsl #2
    39a4:	7e0b0700 	cdpvc	7, 0, cr0, cr11, cr0, {0}
    39a8:	07000025 	streq	r0, [r0, -r5, lsr #32]
    39ac:	0028800b 	eoreq	r8, r8, fp
    39b0:	050b0700 	streq	r0, [fp, #-1792]	; 0xfffff900
    39b4:	0700001e 	smladeq	r0, lr, r0, r0
    39b8:	0025ff0b 	eoreq	pc, r5, fp, lsl #30
    39bc:	a80b0800 	stmdage	fp, {fp}
    39c0:	0800001b 	stmdaeq	r0, {r0, r1, r3, r4}
    39c4:	0028530b 	eoreq	r5, r8, fp, lsl #6
    39c8:	1b0b0800 	blne	2c59d0 <__bss_end+0x2bc28c>
    39cc:	08000026 	stmdaeq	r0, {r1, r2, r5}
    39d0:	2ab90f00 	bcs	fee475d8 <__bss_end+0xfee3de94>
    39d4:	9f050000 	svcls	0x00050000
    39d8:	05801f01 	streq	r1, [r0, #3841]	; 0xf01
    39dc:	4d0f0000 	stcmi	0, cr0, [pc, #-0]	; 39e4 <shift+0x39e4>
    39e0:	05000026 	streq	r0, [r0, #-38]	; 0xffffffda
    39e4:	1d0c01a2 	stfnes	f0, [ip, #-648]	; 0xfffffd78
    39e8:	0f000000 	svceq	0x00000000
    39ec:	00002260 	andeq	r2, r0, r0, ror #4
    39f0:	0c01a505 	cfstr32eq	mvfx10, [r1], {5}
    39f4:	0000001d 	andeq	r0, r0, sp, lsl r0
    39f8:	002b850f 	eoreq	r8, fp, pc, lsl #10
    39fc:	01a80500 			; <UNDEFINED> instruction: 0x01a80500
    3a00:	00001d0c 	andeq	r1, r0, ip, lsl #26
    3a04:	1cf50f00 	ldclne	15, cr0, [r5]
    3a08:	ab050000 	blge	143a10 <__bss_end+0x13a2cc>
    3a0c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    3a10:	570f0000 	strpl	r0, [pc, -r0]
    3a14:	05000026 	streq	r0, [r0, #-38]	; 0xffffffda
    3a18:	1d0c01ae 	stfnes	f0, [ip, #-696]	; 0xfffffd48
    3a1c:	0f000000 	svceq	0x00000000
    3a20:	00002568 	andeq	r2, r0, r8, ror #10
    3a24:	0c01b105 	stfeqd	f3, [r1], {5}
    3a28:	0000001d 	andeq	r0, r0, sp, lsl r0
    3a2c:	0025730f 	eoreq	r7, r5, pc, lsl #6
    3a30:	01b40500 			; <UNDEFINED> instruction: 0x01b40500
    3a34:	00001d0c 	andeq	r1, r0, ip, lsl #26
    3a38:	26610f00 	strbtcs	r0, [r1], -r0, lsl #30
    3a3c:	b7050000 	strlt	r0, [r5, -r0]
    3a40:	001d0c01 	andseq	r0, sp, r1, lsl #24
    3a44:	ad0f0000 	stcge	0, cr0, [pc, #-0]	; 3a4c <shift+0x3a4c>
    3a48:	05000023 	streq	r0, [r0, #-35]	; 0xffffffdd
    3a4c:	1d0c01ba 	stfnes	f0, [ip, #-744]	; 0xfffffd18
    3a50:	0f000000 	svceq	0x00000000
    3a54:	00002ae4 	andeq	r2, r0, r4, ror #21
    3a58:	0c01bd05 	stceq	13, cr11, [r1], {5}
    3a5c:	0000001d 	andeq	r0, r0, sp, lsl r0
    3a60:	00266b0f 	eoreq	r6, r6, pc, lsl #22
    3a64:	01c00500 	biceq	r0, r0, r0, lsl #10
    3a68:	00001d0c 	andeq	r1, r0, ip, lsl #26
    3a6c:	2ba80f00 	blcs	fea07674 <__bss_end+0xfe9fdf30>
    3a70:	c3050000 	movwgt	r0, #20480	; 0x5000
    3a74:	001d0c01 	andseq	r0, sp, r1, lsl #24
    3a78:	6e0f0000 	cdpvs	0, 0, cr0, cr15, cr0, {0}
    3a7c:	0500002a 	streq	r0, [r0, #-42]	; 0xffffffd6
    3a80:	1d0c01c6 	stfnes	f0, [ip, #-792]	; 0xfffffce8
    3a84:	0f000000 	svceq	0x00000000
    3a88:	00002a7a 	andeq	r2, r0, sl, ror sl
    3a8c:	0c01c905 			; <UNDEFINED> instruction: 0x0c01c905
    3a90:	0000001d 	andeq	r0, r0, sp, lsl r0
    3a94:	002a860f 	eoreq	r8, sl, pc, lsl #12
    3a98:	01cc0500 	biceq	r0, ip, r0, lsl #10
    3a9c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    3aa0:	2aab0f00 	bcs	feac76a8 <__bss_end+0xfeabdf64>
    3aa4:	d0050000 	andle	r0, r5, r0
    3aa8:	001d0c01 	andseq	r0, sp, r1, lsl #24
    3aac:	9b0f0000 	blls	3c3ab4 <__bss_end+0x3ba370>
    3ab0:	0500002b 	streq	r0, [r0, #-43]	; 0xffffffd5
    3ab4:	1d0c01d3 	stfnes	f0, [ip, #-844]	; 0xfffffcb4
    3ab8:	0f000000 	svceq	0x00000000
    3abc:	00001d52 	andeq	r1, r0, r2, asr sp
    3ac0:	0c01d605 	stceq	6, cr13, [r1], {5}
    3ac4:	0000001d 	andeq	r0, r0, sp, lsl r0
    3ac8:	001b390f 	andseq	r3, fp, pc, lsl #18
    3acc:	01d90500 	bicseq	r0, r9, r0, lsl #10
    3ad0:	00001d0c 	andeq	r1, r0, ip, lsl #26
    3ad4:	20440f00 	subcs	r0, r4, r0, lsl #30
    3ad8:	dc050000 	stcle	0, cr0, [r5], {-0}
    3adc:	001d0c01 	andseq	r0, sp, r1, lsl #24
    3ae0:	2d0f0000 	stccs	0, cr0, [pc, #-0]	; 3ae8 <shift+0x3ae8>
    3ae4:	0500001d 	streq	r0, [r0, #-29]	; 0xffffffe3
    3ae8:	1d0c01df 	stfnes	f0, [ip, #-892]	; 0xfffffc84
    3aec:	0f000000 	svceq	0x00000000
    3af0:	00002681 	andeq	r2, r0, r1, lsl #13
    3af4:	0c01e205 	sfmeq	f6, 1, [r1], {5}
    3af8:	0000001d 	andeq	r0, r0, sp, lsl r0
    3afc:	0022890f 	eoreq	r8, r2, pc, lsl #18
    3b00:	01e50500 	mvneq	r0, r0, lsl #10
    3b04:	00001d0c 	andeq	r1, r0, ip, lsl #26
    3b08:	24e10f00 	strbtcs	r0, [r1], #3840	; 0xf00
    3b0c:	e8050000 	stmda	r5, {}	; <UNPREDICTABLE>
    3b10:	001d0c01 	andseq	r0, sp, r1, lsl #24
    3b14:	9b0f0000 	blls	3c3b1c <__bss_end+0x3ba3d8>
    3b18:	05000029 	streq	r0, [r0, #-41]	; 0xffffffd7
    3b1c:	1d0c01ef 	stfnes	f0, [ip, #-956]	; 0xfffffc44
    3b20:	0f000000 	svceq	0x00000000
    3b24:	00002b53 	andeq	r2, r0, r3, asr fp
    3b28:	0c01f205 	sfmeq	f7, 1, [r1], {5}
    3b2c:	0000001d 	andeq	r0, r0, sp, lsl r0
    3b30:	002b630f 	eoreq	r6, fp, pc, lsl #6
    3b34:	01f50500 	mvnseq	r0, r0, lsl #10
    3b38:	00001d0c 	andeq	r1, r0, ip, lsl #26
    3b3c:	1e490f00 	cdpne	15, 4, cr0, cr9, cr0, {0}
    3b40:	f8050000 			; <UNDEFINED> instruction: 0xf8050000
    3b44:	001d0c01 	andseq	r0, sp, r1, lsl #24
    3b48:	e20f0000 	and	r0, pc, #0
    3b4c:	05000029 	streq	r0, [r0, #-41]	; 0xffffffd7
    3b50:	1d0c01fb 	stfnes	f0, [ip, #-1004]	; 0xfffffc14
    3b54:	0f000000 	svceq	0x00000000
    3b58:	000025e7 	andeq	r2, r0, r7, ror #11
    3b5c:	0c01fe05 	stceq	14, cr15, [r1], {5}
    3b60:	0000001d 	andeq	r0, r0, sp, lsl r0
    3b64:	0020bd0f 	eoreq	fp, r0, pc, lsl #26
    3b68:	02020500 	andeq	r0, r2, #0, 10
    3b6c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    3b70:	27d70f00 	ldrbcs	r0, [r7, r0, lsl #30]
    3b74:	0a050000 	beq	143b7c <__bss_end+0x13a438>
    3b78:	001d0c02 	andseq	r0, sp, r2, lsl #24
    3b7c:	b00f0000 	andlt	r0, pc, r0
    3b80:	0500001f 	streq	r0, [r0, #-31]	; 0xffffffe1
    3b84:	1d0c020d 	sfmne	f0, 4, [ip, #-52]	; 0xffffffcc
    3b88:	0c000000 	stceq	0, cr0, [r0], {-0}
    3b8c:	0000001d 	andeq	r0, r0, sp, lsl r0
    3b90:	000007ef 	andeq	r0, r0, pc, ror #15
    3b94:	890f000d 	stmdbhi	pc, {r0, r2, r3}	; <UNPREDICTABLE>
    3b98:	05000021 	streq	r0, [r0, #-33]	; 0xffffffdf
    3b9c:	e40c03fb 	str	r0, [ip], #-1019	; 0xfffffc05
    3ba0:	0c000007 	stceq	0, cr0, [r0], {7}
    3ba4:	000004e6 	andeq	r0, r0, r6, ror #9
    3ba8:	0000080c 	andeq	r0, r0, ip, lsl #16
    3bac:	00002415 	andeq	r2, r0, r5, lsl r4
    3bb0:	0f000d00 	svceq	0x00000d00
    3bb4:	000026a4 	andeq	r2, r0, r4, lsr #13
    3bb8:	14058405 	strne	r8, [r5], #-1029	; 0xfffffbfb
    3bbc:	000007fc 	strdeq	r0, [r0], -ip
    3bc0:	00224b16 	eoreq	r4, r2, r6, lsl fp
    3bc4:	93010700 	movwls	r0, #5888	; 0x1700
    3bc8:	05000000 	streq	r0, [r0, #-0]
    3bcc:	5706058b 	strpl	r0, [r6, -fp, lsl #11]
    3bd0:	0b000008 	bleq	3bf8 <shift+0x3bf8>
    3bd4:	00002006 	andeq	r2, r0, r6
    3bd8:	24560b00 	ldrbcs	r0, [r6], #-2816	; 0xfffff500
    3bdc:	0b010000 	bleq	43be4 <__bss_end+0x3a4a0>
    3be0:	00001bde 	ldrdeq	r1, [r0], -lr
    3be4:	2b150b02 	blcs	5467f4 <__bss_end+0x53d0b0>
    3be8:	0b030000 	bleq	c3bf0 <__bss_end+0xba4ac>
    3bec:	0000271e 	andeq	r2, r0, lr, lsl r7
    3bf0:	27110b04 	ldrcs	r0, [r1, -r4, lsl #22]
    3bf4:	0b050000 	bleq	143bfc <__bss_end+0x13a4b8>
    3bf8:	00001cb5 			; <UNDEFINED> instruction: 0x00001cb5
    3bfc:	050f0006 	streq	r0, [pc, #-6]	; 3bfe <shift+0x3bfe>
    3c00:	0500002b 	streq	r0, [r0, #-43]	; 0xffffffd5
    3c04:	19150598 	ldmdbne	r5, {r3, r4, r7, r8, sl}
    3c08:	0f000008 	svceq	0x00000008
    3c0c:	00002a07 	andeq	r2, r0, r7, lsl #20
    3c10:	11079905 	tstne	r7, r5, lsl #18
    3c14:	00000024 	andeq	r0, r0, r4, lsr #32
    3c18:	0026910f 	eoreq	r9, r6, pc, lsl #2
    3c1c:	07ae0500 	streq	r0, [lr, r0, lsl #10]!
    3c20:	00001d0c 	andeq	r1, r0, ip, lsl #26
    3c24:	297a0400 	ldmdbcs	sl!, {sl}^
    3c28:	7b060000 	blvc	183c30 <__bss_end+0x17a4ec>
    3c2c:	00009316 	andeq	r9, r0, r6, lsl r3
    3c30:	087e0e00 	ldmdaeq	lr!, {r9, sl, fp}^
    3c34:	02030000 	andeq	r0, r3, #0
    3c38:	000e3805 	andeq	r3, lr, r5, lsl #16
    3c3c:	07080300 	streq	r0, [r8, -r0, lsl #6]
    3c40:	00001f99 	muleq	r0, r9, pc	; <UNPREDICTABLE>
    3c44:	6d040403 	cfstrsvs	mvf0, [r4, #-12]
    3c48:	0300001d 	movweq	r0, #29
    3c4c:	1d650308 	stclne	3, cr0, [r5, #-32]!	; 0xffffffe0
    3c50:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    3c54:	00267a04 	eoreq	r7, r6, r4, lsl #20
    3c58:	03100300 	tsteq	r0, #0, 6
    3c5c:	0000272c 	andeq	r2, r0, ip, lsr #14
    3c60:	00088a0c 	andeq	r8, r8, ip, lsl #20
    3c64:	0008c900 	andeq	ip, r8, r0, lsl #18
    3c68:	00241500 	eoreq	r1, r4, r0, lsl #10
    3c6c:	00ff0000 	rscseq	r0, pc, r0
    3c70:	0008b90e 	andeq	fp, r8, lr, lsl #18
    3c74:	258b0f00 	strcs	r0, [fp, #3840]	; 0xf00
    3c78:	fc060000 	stc2	0, cr0, [r6], {-0}
    3c7c:	08c91601 	stmiaeq	r9, {r0, r9, sl, ip}^
    3c80:	1c0f0000 	stcne	0, cr0, [pc], {-0}
    3c84:	0600001d 			; <UNDEFINED> instruction: 0x0600001d
    3c88:	c9160202 	ldmdbgt	r6, {r1, r9}
    3c8c:	04000008 	streq	r0, [r0], #-8
    3c90:	000029ad 	andeq	r2, r0, sp, lsr #19
    3c94:	f9102a07 			; <UNDEFINED> instruction: 0xf9102a07
    3c98:	0c000004 	stceq	0, cr0, [r0], {4}
    3c9c:	000008e8 	andeq	r0, r0, r8, ror #17
    3ca0:	000008ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    3ca4:	7209000d 	andvc	r0, r9, #13
    3ca8:	07000003 	streq	r0, [r0, -r3]
    3cac:	08f4112f 	ldmeq	r4!, {r0, r1, r2, r3, r5, r8, ip}^
    3cb0:	37090000 	strcc	r0, [r9, -r0]
    3cb4:	07000002 	streq	r0, [r0, -r2]
    3cb8:	08f41130 	ldmeq	r4!, {r4, r5, r8, ip}^
    3cbc:	ff170000 			; <UNDEFINED> instruction: 0xff170000
    3cc0:	08000008 	stmdaeq	r0, {r3}
    3cc4:	050a0933 	streq	r0, [sl, #-2355]	; 0xfffff6cd
    3cc8:	00972003 	addseq	r2, r7, r3
    3ccc:	090b1700 	stmdbeq	fp, {r8, r9, sl, ip}
    3cd0:	34080000 	strcc	r0, [r8], #-0
    3cd4:	03050a09 	movweq	r0, #23049	; 0x5a09
    3cd8:	00009720 	andeq	r9, r0, r0, lsr #14
	...

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	10001101 	andne	r1, r0, r1, lsl #2
   4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
   8:	1b0e0301 	blne	380c14 <__bss_end+0x3774d0>
   c:	130e250e 	movwne	r2, #58638	; 0xe50e
  10:	00000005 	andeq	r0, r0, r5
  14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
  18:	030b130e 	movweq	r1, #45838	; 0xb30e
  1c:	110e1b0e 	tstne	lr, lr, lsl #22
  20:	10061201 	andne	r1, r6, r1, lsl #4
  24:	02000017 	andeq	r0, r0, #23
  28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeb95d8>
  30:	13490b39 	movtne	r0, #39737	; 0x9b39
  34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
  38:	24030000 	strcs	r0, [r3], #-0
  3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  40:	000e030b 	andeq	r0, lr, fp, lsl #6
  44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
  48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeb95f8>
  50:	01110b39 	tsteq	r1, r9, lsr fp
  54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
  58:	01194296 			; <UNDEFINED> instruction: 0x01194296
  5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeb9610>
  68:	13490b39 	movtne	r0, #39737	; 0x9b39
  6c:	00001802 	andeq	r1, r0, r2, lsl #16
  70:	0b002406 	bleq	9090 <_ZN13COLED_Display10Put_StringEttPKc+0x34>
  74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  78:	07000008 	streq	r0, [r0, -r8]
  7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe7a150>
  84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe39634>
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
  b4:	3a0e0300 	bcc	380cbc <__bss_end+0x377578>
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
  e4:	0b3e0b0b 	bleq	f82d18 <__bss_end+0xf795d4>
  e8:	00000e03 	andeq	r0, r0, r3, lsl #28
  ec:	03003408 	movweq	r3, #1032	; 0x408
  f0:	3b0b3a0e 	blcc	2ce930 <__bss_end+0x2c51ec>
  f4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
  f8:	3c193f13 	ldccc	15, cr3, [r9], {19}
  fc:	09000019 	stmdbeq	r0, {r0, r3, r4}
 100:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 104:	0b3a0e03 	bleq	e83918 <__bss_end+0xe7a1d4>
 108:	0b390b3b 	bleq	e42dfc <__bss_end+0xe396b8>
 10c:	01111349 	tsteq	r1, r9, asr #6
 110:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 114:	01194296 			; <UNDEFINED> instruction: 0x01194296
 118:	0a000013 	beq	16c <shift+0x16c>
 11c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeb96cc>
 124:	13490b39 	movtne	r0, #39737	; 0x9b39
 128:	00001802 	andeq	r1, r0, r2, lsl #16
 12c:	0b00240b 	bleq	9160 <__udivsi3+0x54>
 130:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 134:	0c000008 	stceq	0, cr0, [r0], {8}
 138:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
 13c:	0b3a0e03 	bleq	e83950 <__bss_end+0xe7a20c>
 140:	0b390b3b 	bleq	e42e34 <__bss_end+0xe396f0>
 144:	06120111 			; <UNDEFINED> instruction: 0x06120111
 148:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 14c:	0d000019 	stceq	0, cr0, [r0, #-100]	; 0xffffff9c
 150:	0e030139 	mcreq	1, 0, r0, cr3, cr9, {1}
 154:	0b3b0b3a 	bleq	ec2e44 <__bss_end+0xeb9700>
 158:	00001301 	andeq	r1, r0, r1, lsl #6
 15c:	3f012e0e 	svccc	0x00012e0e
 160:	3a0e0319 	bcc	380dcc <__bss_end+0x377688>
 164:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 168:	01193c0b 	tsteq	r9, fp, lsl #24
 16c:	0f000013 	svceq	0x00000013
 170:	13490005 	movtne	r0, #36869	; 0x9005
 174:	2e100000 	cdpcs	0, 1, cr0, cr0, cr0, {0}
 178:	03193f01 	tsteq	r9, #1, 30
 17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c5278>
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
 1a8:	3b0b3a08 	blcc	2ce9d0 <__bss_end+0x2c528c>
 1ac:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 1b0:	00180213 	andseq	r0, r8, r3, lsl r2
 1b4:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 1b8:	01111347 	tsteq	r1, r7, asr #6
 1bc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 1c0:	00194297 	mulseq	r9, r7, r2
 1c4:	11010000 	mrsne	r0, (UNDEF: 1)
 1c8:	130e2501 	movwne	r2, #58625	; 0xe501
 1cc:	1b0e030b 	blne	380e00 <__bss_end+0x3776bc>
 1d0:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 1d4:	00171006 	andseq	r1, r7, r6
 1d8:	00240200 	eoreq	r0, r4, r0, lsl #4
 1dc:	0b3e0b0b 	bleq	f82e10 <__bss_end+0xf796cc>
 1e0:	00000e03 	andeq	r0, r0, r3, lsl #28
 1e4:	49002603 	stmdbmi	r0, {r0, r1, r9, sl, sp}
 1e8:	04000013 	streq	r0, [r0], #-19	; 0xffffffed
 1ec:	0b0b0024 	bleq	2c0284 <__bss_end+0x2b6b40>
 1f0:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 1f4:	16050000 	strne	r0, [r5], -r0
 1f8:	3a0e0300 	bcc	380e00 <__bss_end+0x3776bc>
 1fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 200:	0013490b 	andseq	r4, r3, fp, lsl #18
 204:	00350600 	eorseq	r0, r5, r0, lsl #12
 208:	00001349 	andeq	r1, r0, r9, asr #6
 20c:	03011307 	movweq	r1, #4871	; 0x1307
 210:	3a0b0b0e 	bcc	2c2e50 <__bss_end+0x2b970c>
 214:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 218:	0013010b 	andseq	r0, r3, fp, lsl #2
 21c:	000d0800 	andeq	r0, sp, r0, lsl #16
 220:	0b3a0803 	bleq	e82234 <__bss_end+0xe78af0>
 224:	0b390b3b 	bleq	e42f18 <__bss_end+0xe397d4>
 228:	0b381349 	bleq	e04f54 <__bss_end+0xdfb810>
 22c:	04090000 	streq	r0, [r9], #-0
 230:	6d0e0301 	stcvs	3, cr0, [lr, #-4]
 234:	0b0b3e19 	bleq	2cfaa0 <__bss_end+0x2c635c>
 238:	3a13490b 	bcc	4d266c <__bss_end+0x4c8f28>
 23c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 240:	0013010b 	andseq	r0, r3, fp, lsl #2
 244:	00280a00 	eoreq	r0, r8, r0, lsl #20
 248:	0b1c0e03 	bleq	703a5c <__bss_end+0x6fa318>
 24c:	340b0000 	strcc	r0, [fp], #-0
 250:	3a0e0300 	bcc	380e58 <__bss_end+0x377714>
 254:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 258:	6c13490b 			; <UNDEFINED> instruction: 0x6c13490b
 25c:	00180219 	andseq	r0, r8, r9, lsl r2
 260:	00020c00 	andeq	r0, r2, r0, lsl #24
 264:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
 268:	020d0000 	andeq	r0, sp, #0
 26c:	0b0e0301 	bleq	380e78 <__bss_end+0x377734>
 270:	3b0b3a0b 	blcc	2ceaa4 <__bss_end+0x2c5360>
 274:	010b390b 	tsteq	fp, fp, lsl #18
 278:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
 27c:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 280:	0b3b0b3a 	bleq	ec2f70 <__bss_end+0xeb982c>
 284:	13490b39 	movtne	r0, #39737	; 0x9b39
 288:	00000b38 	andeq	r0, r0, r8, lsr fp
 28c:	3f012e0f 	svccc	0x00012e0f
 290:	3a0e0319 	bcc	380efc <__bss_end+0x3777b8>
 294:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 298:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 29c:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
 2a0:	10000013 	andne	r0, r0, r3, lsl r0
 2a4:	13490005 	movtne	r0, #36869	; 0x9005
 2a8:	00001934 	andeq	r1, r0, r4, lsr r9
 2ac:	49000511 	stmdbmi	r0, {r0, r4, r8, sl}
 2b0:	12000013 	andne	r0, r0, #19
 2b4:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 2b8:	0b3b0b3a 	bleq	ec2fa8 <__bss_end+0xeb9864>
 2bc:	13490b39 	movtne	r0, #39737	; 0x9b39
 2c0:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 2c4:	2e130000 	cdpcs	0, 1, cr0, cr3, cr0, {0}
 2c8:	03193f01 	tsteq	r9, #1, 30
 2cc:	3b0b3a0e 	blcc	2ceb0c <__bss_end+0x2c53c8>
 2d0:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 2d4:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 2d8:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 2dc:	00130113 	andseq	r0, r3, r3, lsl r1
 2e0:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 2e4:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 2e8:	0b3b0b3a 	bleq	ec2fd8 <__bss_end+0xeb9894>
 2ec:	0e6e0b39 	vmoveq.8	d14[5], r0
 2f0:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 2f4:	13011364 	movwne	r1, #4964	; 0x1364
 2f8:	2e150000 	cdpcs	0, 1, cr0, cr5, cr0, {0}
 2fc:	03193f01 	tsteq	r9, #1, 30
 300:	3b0b3a0e 	blcc	2ceb40 <__bss_end+0x2c53fc>
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
 338:	0b3b0b3a 	bleq	ec3028 <__bss_end+0xeb98e4>
 33c:	13490b39 	movtne	r0, #39737	; 0x9b39
 340:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 344:	281b0000 	ldmdacs	fp, {}	; <UNPREDICTABLE>
 348:	1c080300 	stcne	3, cr0, [r8], {-0}
 34c:	1c00000b 	stcne	0, cr0, [r0], {11}
 350:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 354:	0b3a0e03 	bleq	e83b68 <__bss_end+0xe7a424>
 358:	0b390b3b 	bleq	e4304c <__bss_end+0xe39908>
 35c:	193c0e6e 	ldmdbne	ip!, {r1, r2, r3, r5, r6, r9, sl, fp}
 360:	13011364 	movwne	r1, #4964	; 0x1364
 364:	2e1d0000 	cdpcs	0, 1, cr0, cr13, cr0, {0}
 368:	03193f01 	tsteq	r9, #1, 30
 36c:	3b0b3a0e 	blcc	2cebac <__bss_end+0x2c5468>
 370:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 374:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
 378:	01136419 	tsteq	r3, r9, lsl r4
 37c:	1e000013 	mcrne	0, 0, r0, cr0, cr3, {0}
 380:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 384:	0b3b0b3a 	bleq	ec3074 <__bss_end+0xeb9930>
 388:	13490b39 	movtne	r0, #39737	; 0x9b39
 38c:	0b320b38 	bleq	c83074 <__bss_end+0xc79930>
 390:	151f0000 	ldrne	r0, [pc, #-0]	; 398 <shift+0x398>
 394:	64134901 	ldrvs	r4, [r3], #-2305	; 0xfffff6ff
 398:	00130113 	andseq	r0, r3, r3, lsl r1
 39c:	001f2000 	andseq	r2, pc, r0
 3a0:	1349131d 	movtne	r1, #37661	; 0x931d
 3a4:	10210000 	eorne	r0, r1, r0
 3a8:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 3ac:	22000013 	andcs	r0, r0, #19
 3b0:	0b0b000f 	bleq	2c03f4 <__bss_end+0x2b6cb0>
 3b4:	2e230000 	cdpcs	0, 2, cr0, cr3, cr0, {0}
 3b8:	03193f01 	tsteq	r9, #1, 30
 3bc:	3b0b3a0e 	blcc	2cebfc <__bss_end+0x2c54b8>
 3c0:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 3c4:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
 3c8:	00136419 	andseq	r6, r3, r9, lsl r4
 3cc:	01392400 	teqeq	r9, r0, lsl #8
 3d0:	0b3a0803 	bleq	e823e4 <__bss_end+0xe78ca0>
 3d4:	0b390b3b 	bleq	e430c8 <__bss_end+0xe39984>
 3d8:	00001301 	andeq	r1, r0, r1, lsl #6
 3dc:	03003425 	movweq	r3, #1061	; 0x425
 3e0:	3b0b3a0e 	blcc	2cec20 <__bss_end+0x2c54dc>
 3e4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 3e8:	1c193c13 	ldcne	12, cr3, [r9], {19}
 3ec:	00196c06 	andseq	r6, r9, r6, lsl #24
 3f0:	00342600 	eorseq	r2, r4, r0, lsl #12
 3f4:	0b3a0e03 	bleq	e83c08 <__bss_end+0xe7a4c4>
 3f8:	0b390b3b 	bleq	e430ec <__bss_end+0xe399a8>
 3fc:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 400:	196c0b1c 	stmdbne	ip!, {r2, r3, r4, r8, r9, fp}^
 404:	34270000 	strtcc	r0, [r7], #-0
 408:	00134700 	andseq	r4, r3, r0, lsl #14
 40c:	00342800 	eorseq	r2, r4, r0, lsl #16
 410:	0b3a0e03 	bleq	e83c24 <__bss_end+0xe7a4e0>
 414:	0b390b3b 	bleq	e43108 <__bss_end+0xe399c4>
 418:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 41c:	00001802 	andeq	r1, r0, r2, lsl #16
 420:	3f012e29 	svccc	0x00012e29
 424:	3a0e0319 	bcc	381090 <__bss_end+0x37794c>
 428:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 42c:	1113490b 	tstne	r3, fp, lsl #18
 430:	40061201 	andmi	r1, r6, r1, lsl #4
 434:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 438:	00001301 	andeq	r1, r0, r1, lsl #6
 43c:	0300052a 	movweq	r0, #1322	; 0x52a
 440:	3b0b3a0e 	blcc	2cec80 <__bss_end+0x2c553c>
 444:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 448:	00180213 	andseq	r0, r8, r3, lsl r2
 44c:	00342b00 	eorseq	r2, r4, r0, lsl #22
 450:	0b3a0e03 	bleq	e83c64 <__bss_end+0xe7a520>
 454:	0b390b3b 	bleq	e43148 <__bss_end+0xe39a04>
 458:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 45c:	342c0000 	strtcc	r0, [ip], #-0
 460:	3a080300 	bcc	201068 <__bss_end+0x1f7924>
 464:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 468:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 46c:	2d000018 	stccs	0, cr0, [r0, #-96]	; 0xffffffa0
 470:	0111010b 	tsteq	r1, fp, lsl #2
 474:	00000612 	andeq	r0, r0, r2, lsl r6
 478:	01110100 	tsteq	r1, r0, lsl #2
 47c:	0b130e25 	bleq	4c3d18 <__bss_end+0x4ba5d4>
 480:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 484:	06120111 			; <UNDEFINED> instruction: 0x06120111
 488:	00001710 	andeq	r1, r0, r0, lsl r7
 48c:	0b002402 	bleq	949c <_ZL10Indefinite>
 490:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 494:	0300000e 	movweq	r0, #14
 498:	13490026 	movtne	r0, #36902	; 0x9026
 49c:	24040000 	strcs	r0, [r4], #-0
 4a0:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 4a4:	0008030b 	andeq	r0, r8, fp, lsl #6
 4a8:	00160500 	andseq	r0, r6, r0, lsl #10
 4ac:	0b3a0e03 	bleq	e83cc0 <__bss_end+0xe7a57c>
 4b0:	0b390b3b 	bleq	e431a4 <__bss_end+0xe39a60>
 4b4:	00001349 	andeq	r1, r0, r9, asr #6
 4b8:	03011306 	movweq	r1, #4870	; 0x1306
 4bc:	3a0b0b0e 	bcc	2c30fc <__bss_end+0x2b99b8>
 4c0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4c4:	0013010b 	andseq	r0, r3, fp, lsl #2
 4c8:	000d0700 	andeq	r0, sp, r0, lsl #14
 4cc:	0b3a0803 	bleq	e824e0 <__bss_end+0xe78d9c>
 4d0:	0b390b3b 	bleq	e431c4 <__bss_end+0xe39a80>
 4d4:	0b381349 	bleq	e05200 <__bss_end+0xdfbabc>
 4d8:	04080000 	streq	r0, [r8], #-0
 4dc:	6d0e0301 	stcvs	3, cr0, [lr, #-4]
 4e0:	0b0b3e19 	bleq	2cfd4c <__bss_end+0x2c6608>
 4e4:	3a13490b 	bcc	4d2918 <__bss_end+0x4c91d4>
 4e8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4ec:	0013010b 	andseq	r0, r3, fp, lsl #2
 4f0:	00280900 	eoreq	r0, r8, r0, lsl #18
 4f4:	0b1c0803 	bleq	702508 <__bss_end+0x6f8dc4>
 4f8:	280a0000 	stmdacs	sl, {}	; <UNPREDICTABLE>
 4fc:	1c0e0300 	stcne	3, cr0, [lr], {-0}
 500:	0b00000b 	bleq	534 <shift+0x534>
 504:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 508:	0b3b0b3a 	bleq	ec31f8 <__bss_end+0xeb9ab4>
 50c:	13490b39 	movtne	r0, #39737	; 0x9b39
 510:	1802196c 	stmdane	r2, {r2, r3, r5, r6, r8, fp, ip}
 514:	020c0000 	andeq	r0, ip, #0
 518:	3c0e0300 	stccc	3, cr0, [lr], {-0}
 51c:	0d000019 	stceq	0, cr0, [r0, #-100]	; 0xffffff9c
 520:	0e030102 	adfeqs	f0, f3, f2
 524:	0b3a0b0b 	bleq	e83158 <__bss_end+0xe79a14>
 528:	0b390b3b 	bleq	e4321c <__bss_end+0xe39ad8>
 52c:	00001301 	andeq	r1, r0, r1, lsl #6
 530:	03000d0e 	movweq	r0, #3342	; 0xd0e
 534:	3b0b3a0e 	blcc	2ced74 <__bss_end+0x2c5630>
 538:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 53c:	000b3813 	andeq	r3, fp, r3, lsl r8
 540:	012e0f00 			; <UNDEFINED> instruction: 0x012e0f00
 544:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 548:	0b3b0b3a 	bleq	ec3238 <__bss_end+0xeb9af4>
 54c:	0e6e0b39 	vmoveq.8	d14[5], r0
 550:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 554:	00001364 	andeq	r1, r0, r4, ror #6
 558:	49000510 	stmdbmi	r0, {r4, r8, sl}
 55c:	00193413 	andseq	r3, r9, r3, lsl r4
 560:	00051100 	andeq	r1, r5, r0, lsl #2
 564:	00001349 	andeq	r1, r0, r9, asr #6
 568:	03000d12 	movweq	r0, #3346	; 0xd12
 56c:	3b0b3a0e 	blcc	2cedac <__bss_end+0x2c5668>
 570:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 574:	3c193f13 	ldccc	15, cr3, [r9], {19}
 578:	13000019 	movwne	r0, #25
 57c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 580:	0b3a0e03 	bleq	e83d94 <__bss_end+0xe7a650>
 584:	0b390b3b 	bleq	e43278 <__bss_end+0xe39b34>
 588:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 58c:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 590:	13011364 	movwne	r1, #4964	; 0x1364
 594:	2e140000 	cdpcs	0, 1, cr0, cr4, cr0, {0}
 598:	03193f01 	tsteq	r9, #1, 30
 59c:	3b0b3a0e 	blcc	2ceddc <__bss_end+0x2c5698>
 5a0:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 5a4:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
 5a8:	01136419 	tsteq	r3, r9, lsl r4
 5ac:	15000013 	strne	r0, [r0, #-19]	; 0xffffffed
 5b0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 5b4:	0b3a0e03 	bleq	e83dc8 <__bss_end+0xe7a684>
 5b8:	0b390b3b 	bleq	e432ac <__bss_end+0xe39b68>
 5bc:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 5c0:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 5c4:	00001364 	andeq	r1, r0, r4, ror #6
 5c8:	49010116 	stmdbmi	r1, {r1, r2, r4, r8}
 5cc:	00130113 	andseq	r0, r3, r3, lsl r1
 5d0:	00211700 	eoreq	r1, r1, r0, lsl #14
 5d4:	0b2f1349 	bleq	bc5300 <__bss_end+0xbbbbbc>
 5d8:	0f180000 	svceq	0x00180000
 5dc:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 5e0:	19000013 	stmdbne	r0, {r0, r1, r4}
 5e4:	00000021 	andeq	r0, r0, r1, lsr #32
 5e8:	0300341a 	movweq	r3, #1050	; 0x41a
 5ec:	3b0b3a0e 	blcc	2cee2c <__bss_end+0x2c56e8>
 5f0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 5f4:	3c193f13 	ldccc	15, cr3, [r9], {19}
 5f8:	1b000019 	blne	664 <shift+0x664>
 5fc:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 600:	0b3a0e03 	bleq	e83e14 <__bss_end+0xe7a6d0>
 604:	0b390b3b 	bleq	e432f8 <__bss_end+0xe39bb4>
 608:	193c0e6e 	ldmdbne	ip!, {r1, r2, r3, r5, r6, r9, sl, fp}
 60c:	13011364 	movwne	r1, #4964	; 0x1364
 610:	2e1c0000 	cdpcs	0, 1, cr0, cr12, cr0, {0}
 614:	03193f01 	tsteq	r9, #1, 30
 618:	3b0b3a0e 	blcc	2cee58 <__bss_end+0x2c5714>
 61c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 620:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
 624:	01136419 	tsteq	r3, r9, lsl r4
 628:	1d000013 	stcne	0, cr0, [r0, #-76]	; 0xffffffb4
 62c:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 630:	0b3b0b3a 	bleq	ec3320 <__bss_end+0xeb9bdc>
 634:	13490b39 	movtne	r0, #39737	; 0x9b39
 638:	0b320b38 	bleq	c83320 <__bss_end+0xc79bdc>
 63c:	151e0000 	ldrne	r0, [lr, #-0]
 640:	64134901 	ldrvs	r4, [r3], #-2305	; 0xfffff6ff
 644:	00130113 	andseq	r0, r3, r3, lsl r1
 648:	001f1f00 	andseq	r1, pc, r0, lsl #30
 64c:	1349131d 	movtne	r1, #37661	; 0x931d
 650:	10200000 	eorne	r0, r0, r0
 654:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 658:	21000013 	tstcs	r0, r3, lsl r0
 65c:	0b0b000f 	bleq	2c06a0 <__bss_end+0x2b6f5c>
 660:	34220000 	strtcc	r0, [r2], #-0
 664:	3a0e0300 	bcc	38126c <__bss_end+0x377b28>
 668:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 66c:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 670:	23000018 	movwcs	r0, #24
 674:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 678:	0b3a0e03 	bleq	e83e8c <__bss_end+0xe7a748>
 67c:	0b390b3b 	bleq	e43370 <__bss_end+0xe39c2c>
 680:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 684:	06120111 			; <UNDEFINED> instruction: 0x06120111
 688:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 68c:	00130119 	andseq	r0, r3, r9, lsl r1
 690:	00052400 	andeq	r2, r5, r0, lsl #8
 694:	0b3a0e03 	bleq	e83ea8 <__bss_end+0xe7a764>
 698:	0b390b3b 	bleq	e4338c <__bss_end+0xe39c48>
 69c:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 6a0:	2e250000 	cdpcs	0, 2, cr0, cr5, cr0, {0}
 6a4:	03193f01 	tsteq	r9, #1, 30
 6a8:	3b0b3a0e 	blcc	2ceee8 <__bss_end+0x2c57a4>
 6ac:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 6b0:	1113490e 	tstne	r3, lr, lsl #18
 6b4:	40061201 	andmi	r1, r6, r1, lsl #4
 6b8:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 6bc:	00001301 	andeq	r1, r0, r1, lsl #6
 6c0:	03003426 	movweq	r3, #1062	; 0x426
 6c4:	3b0b3a08 	blcc	2ceeec <__bss_end+0x2c57a8>
 6c8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 6cc:	00180213 	andseq	r0, r8, r3, lsl r2
 6d0:	012e2700 			; <UNDEFINED> instruction: 0x012e2700
 6d4:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 6d8:	0b3b0b3a 	bleq	ec33c8 <__bss_end+0xeb9c84>
 6dc:	0e6e0b39 	vmoveq.8	d14[5], r0
 6e0:	06120111 			; <UNDEFINED> instruction: 0x06120111
 6e4:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 6e8:	00130119 	andseq	r0, r3, r9, lsl r1
 6ec:	002e2800 	eoreq	r2, lr, r0, lsl #16
 6f0:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 6f4:	0b3b0b3a 	bleq	ec33e4 <__bss_end+0xeb9ca0>
 6f8:	0e6e0b39 	vmoveq.8	d14[5], r0
 6fc:	06120111 			; <UNDEFINED> instruction: 0x06120111
 700:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 704:	29000019 	stmdbcs	r0, {r0, r3, r4}
 708:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 70c:	0b3a0e03 	bleq	e83f20 <__bss_end+0xe7a7dc>
 710:	0b390b3b 	bleq	e43404 <__bss_end+0xe39cc0>
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
 740:	3a0e0300 	bcc	381348 <__bss_end+0x377c04>
 744:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 748:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 74c:	000a1c19 	andeq	r1, sl, r9, lsl ip
 750:	003a0400 	eorseq	r0, sl, r0, lsl #8
 754:	0b3b0b3a 	bleq	ec3444 <__bss_end+0xeb9d00>
 758:	13180b39 	tstne	r8, #58368	; 0xe400
 75c:	01050000 	mrseq	r0, (UNDEF: 5)
 760:	01134901 	tsteq	r3, r1, lsl #18
 764:	06000013 			; <UNDEFINED> instruction: 0x06000013
 768:	13490021 	movtne	r0, #36897	; 0x9021
 76c:	00000b2f 	andeq	r0, r0, pc, lsr #22
 770:	49002607 	stmdbmi	r0, {r0, r1, r2, r9, sl, sp}
 774:	08000013 	stmdaeq	r0, {r0, r1, r4}
 778:	0b0b0024 	bleq	2c0810 <__bss_end+0x2b70cc>
 77c:	0e030b3e 	vmoveq.16	d3[0], r0
 780:	34090000 	strcc	r0, [r9], #-0
 784:	00134700 	andseq	r4, r3, r0, lsl #14
 788:	012e0a00 			; <UNDEFINED> instruction: 0x012e0a00
 78c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 790:	0b3b0b3a 	bleq	ec3480 <__bss_end+0xeb9d3c>
 794:	0e6e0b39 	vmoveq.8	d14[5], r0
 798:	06120111 			; <UNDEFINED> instruction: 0x06120111
 79c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 7a0:	00130119 	andseq	r0, r3, r9, lsl r1
 7a4:	00050b00 	andeq	r0, r5, r0, lsl #22
 7a8:	0b3a0803 	bleq	e827bc <__bss_end+0xe79078>
 7ac:	0b390b3b 	bleq	e434a0 <__bss_end+0xe39d5c>
 7b0:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 7b4:	340c0000 	strcc	r0, [ip], #-0
 7b8:	3a0e0300 	bcc	3813c0 <__bss_end+0x377c7c>
 7bc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 7c0:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 7c4:	0d000018 	stceq	0, cr0, [r0, #-96]	; 0xffffffa0
 7c8:	0111010b 	tsteq	r1, fp, lsl #2
 7cc:	00000612 	andeq	r0, r0, r2, lsl r6
 7d0:	0300340e 	movweq	r3, #1038	; 0x40e
 7d4:	3b0b3a08 	blcc	2ceffc <__bss_end+0x2c58b8>
 7d8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 7dc:	00180213 	andseq	r0, r8, r3, lsl r2
 7e0:	000f0f00 	andeq	r0, pc, r0, lsl #30
 7e4:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 7e8:	26100000 	ldrcs	r0, [r0], -r0
 7ec:	11000000 	mrsne	r0, (UNDEF: 0)
 7f0:	0b0b000f 	bleq	2c0834 <__bss_end+0x2b70f0>
 7f4:	24120000 	ldrcs	r0, [r2], #-0
 7f8:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 7fc:	0008030b 	andeq	r0, r8, fp, lsl #6
 800:	00051300 	andeq	r1, r5, r0, lsl #6
 804:	0b3a0e03 	bleq	e84018 <__bss_end+0xe7a8d4>
 808:	0b390b3b 	bleq	e434fc <__bss_end+0xe39db8>
 80c:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 810:	2e140000 	cdpcs	0, 1, cr0, cr4, cr0, {0}
 814:	03193f01 	tsteq	r9, #1, 30
 818:	3b0b3a0e 	blcc	2cf058 <__bss_end+0x2c5914>
 81c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 820:	1113490e 	tstne	r3, lr, lsl #18
 824:	40061201 	andmi	r1, r6, r1, lsl #4
 828:	19429718 	stmdbne	r2, {r3, r4, r8, r9, sl, ip, pc}^
 82c:	00001301 	andeq	r1, r0, r1, lsl #6
 830:	3f012e15 	svccc	0x00012e15
 834:	3a0e0319 	bcc	3814a0 <__bss_end+0x377d5c>
 838:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 83c:	110e6e0b 	tstne	lr, fp, lsl #28
 840:	40061201 	andmi	r1, r6, r1, lsl #4
 844:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 848:	01000000 	mrseq	r0, (UNDEF: 0)
 84c:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 850:	0e030b13 	vmoveq.32	d3[0], r0
 854:	01110e1b 	tsteq	r1, fp, lsl lr
 858:	17100612 			; <UNDEFINED> instruction: 0x17100612
 85c:	24020000 	strcs	r0, [r2], #-0
 860:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 864:	000e030b 	andeq	r0, lr, fp, lsl #6
 868:	00260300 	eoreq	r0, r6, r0, lsl #6
 86c:	00001349 	andeq	r1, r0, r9, asr #6
 870:	0b002404 	bleq	9888 <__bss_end+0x144>
 874:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 878:	05000008 	streq	r0, [r0, #-8]
 87c:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 880:	0b3b0b3a 	bleq	ec3570 <__bss_end+0xeb9e2c>
 884:	13490b39 	movtne	r0, #39737	; 0x9b39
 888:	02060000 	andeq	r0, r6, #0
 88c:	0b0e0301 	bleq	381498 <__bss_end+0x377d54>
 890:	3b0b3a0b 	blcc	2cf0c4 <__bss_end+0x2c5980>
 894:	010b390b 	tsteq	fp, fp, lsl #18
 898:	07000013 	smladeq	r0, r3, r0, r0
 89c:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 8a0:	0b3b0b3a 	bleq	ec3590 <__bss_end+0xeb9e4c>
 8a4:	13490b39 	movtne	r0, #39737	; 0x9b39
 8a8:	00000b38 	andeq	r0, r0, r8, lsr fp
 8ac:	3f012e08 	svccc	0x00012e08
 8b0:	3a0e0319 	bcc	38151c <__bss_end+0x377dd8>
 8b4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 8b8:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 8bc:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 8c0:	01136419 	tsteq	r3, r9, lsl r4
 8c4:	09000013 	stmdbeq	r0, {r0, r1, r4}
 8c8:	13490005 	movtne	r0, #36869	; 0x9005
 8cc:	00001934 	andeq	r1, r0, r4, lsr r9
 8d0:	4900050a 	stmdbmi	r0, {r1, r3, r8, sl}
 8d4:	0b000013 	bleq	928 <shift+0x928>
 8d8:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 8dc:	0b3a0e03 	bleq	e840f0 <__bss_end+0xe7a9ac>
 8e0:	0b390b3b 	bleq	e435d4 <__bss_end+0xe39e90>
 8e4:	0b320e6e 	bleq	c842a4 <__bss_end+0xc7ab60>
 8e8:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 8ec:	00001301 	andeq	r1, r0, r1, lsl #6
 8f0:	3f012e0c 	svccc	0x00012e0c
 8f4:	3a0e0319 	bcc	381560 <__bss_end+0x377e1c>
 8f8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 8fc:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
 900:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 904:	0d000013 	stceq	0, cr0, [r0, #-76]	; 0xffffffb4
 908:	0b0b000f 	bleq	2c094c <__bss_end+0x2b7208>
 90c:	00001349 	andeq	r1, r0, r9, asr #6
 910:	0b000f0e 	bleq	4550 <shift+0x4550>
 914:	0f00000b 	svceq	0x0000000b
 918:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
 91c:	0b3a0b0b 	bleq	e83550 <__bss_end+0xe79e0c>
 920:	0b390b3b 	bleq	e43614 <__bss_end+0xe39ed0>
 924:	00001301 	andeq	r1, r0, r1, lsl #6
 928:	03000d10 	movweq	r0, #3344	; 0xd10
 92c:	3b0b3a08 	blcc	2cf154 <__bss_end+0x2c5a10>
 930:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 934:	000b3813 	andeq	r3, fp, r3, lsl r8
 938:	01041100 	mrseq	r1, (UNDEF: 20)
 93c:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
 940:	0b0b0b3e 	bleq	2c3640 <__bss_end+0x2b9efc>
 944:	0b3a1349 	bleq	e85670 <__bss_end+0xe7bf2c>
 948:	0b390b3b 	bleq	e4363c <__bss_end+0xe39ef8>
 94c:	00001301 	andeq	r1, r0, r1, lsl #6
 950:	03002812 	movweq	r2, #2066	; 0x812
 954:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 958:	00341300 	eorseq	r1, r4, r0, lsl #6
 95c:	0b3a0e03 	bleq	e84170 <__bss_end+0xe7aa2c>
 960:	0b390b3b 	bleq	e43654 <__bss_end+0xe39f10>
 964:	196c1349 	stmdbne	ip!, {r0, r3, r6, r8, r9, ip}^
 968:	00001802 	andeq	r1, r0, r2, lsl #16
 96c:	03000214 	movweq	r0, #532	; 0x214
 970:	00193c0e 	andseq	r3, r9, lr, lsl #24
 974:	012e1500 			; <UNDEFINED> instruction: 0x012e1500
 978:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 97c:	0b3b0b3a 	bleq	ec366c <__bss_end+0xeb9f28>
 980:	0e6e0b39 	vmoveq.8	d14[5], r0
 984:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 988:	00001364 	andeq	r1, r0, r4, ror #6
 98c:	03000d16 	movweq	r0, #3350	; 0xd16
 990:	3b0b3a0e 	blcc	2cf1d0 <__bss_end+0x2c5a8c>
 994:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 998:	3c193f13 	ldccc	15, cr3, [r9], {19}
 99c:	17000019 	smladne	r0, r9, r0, r0
 9a0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 9a4:	0b3a0e03 	bleq	e841b8 <__bss_end+0xe7aa74>
 9a8:	0b390b3b 	bleq	e4369c <__bss_end+0xe39f58>
 9ac:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 9b0:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 9b4:	00001364 	andeq	r1, r0, r4, ror #6
 9b8:	49010118 	stmdbmi	r1, {r3, r4, r8}
 9bc:	00130113 	andseq	r0, r3, r3, lsl r1
 9c0:	00211900 	eoreq	r1, r1, r0, lsl #18
 9c4:	0b2f1349 	bleq	bc56f0 <__bss_end+0xbbbfac>
 9c8:	211a0000 	tstcs	sl, r0
 9cc:	1b000000 	blne	9d4 <shift+0x9d4>
 9d0:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 9d4:	0b3b0b3a 	bleq	ec36c4 <__bss_end+0xeb9f80>
 9d8:	13490b39 	movtne	r0, #39737	; 0x9b39
 9dc:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 9e0:	281c0000 	ldmdacs	ip, {}	; <UNPREDICTABLE>
 9e4:	1c080300 	stcne	3, cr0, [r8], {-0}
 9e8:	1d00000b 	stcne	0, cr0, [r0, #-44]	; 0xffffffd4
 9ec:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 9f0:	0b3a0e03 	bleq	e84204 <__bss_end+0xe7aac0>
 9f4:	0b390b3b 	bleq	e436e8 <__bss_end+0xe39fa4>
 9f8:	193c0e6e 	ldmdbne	ip!, {r1, r2, r3, r5, r6, r9, sl, fp}
 9fc:	13011364 	movwne	r1, #4964	; 0x1364
 a00:	2e1e0000 	cdpcs	0, 1, cr0, cr14, cr0, {0}
 a04:	03193f01 	tsteq	r9, #1, 30
 a08:	3b0b3a0e 	blcc	2cf248 <__bss_end+0x2c5b04>
 a0c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 a10:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
 a14:	01136419 	tsteq	r3, r9, lsl r4
 a18:	1f000013 	svcne	0x00000013
 a1c:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 a20:	0b3b0b3a 	bleq	ec3710 <__bss_end+0xeb9fcc>
 a24:	13490b39 	movtne	r0, #39737	; 0x9b39
 a28:	0b320b38 	bleq	c83710 <__bss_end+0xc79fcc>
 a2c:	15200000 	strne	r0, [r0, #-0]!
 a30:	64134901 	ldrvs	r4, [r3], #-2305	; 0xfffff6ff
 a34:	00130113 	andseq	r0, r3, r3, lsl r1
 a38:	001f2100 	andseq	r2, pc, r0, lsl #2
 a3c:	1349131d 	movtne	r1, #37661	; 0x931d
 a40:	10220000 	eorne	r0, r2, r0
 a44:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 a48:	23000013 	movwcs	r0, #19
 a4c:	08030139 	stmdaeq	r3, {r0, r3, r4, r5, r8}
 a50:	0b3b0b3a 	bleq	ec3740 <__bss_end+0xeb9ffc>
 a54:	13010b39 	movwne	r0, #6969	; 0x1b39
 a58:	34240000 	strtcc	r0, [r4], #-0
 a5c:	3a0e0300 	bcc	381664 <__bss_end+0x377f20>
 a60:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 a64:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 a68:	6c061c19 	stcvs	12, cr1, [r6], {25}
 a6c:	25000019 	strcs	r0, [r0, #-25]	; 0xffffffe7
 a70:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 a74:	0b3b0b3a 	bleq	ec3764 <__bss_end+0xeba020>
 a78:	13490b39 	movtne	r0, #39737	; 0x9b39
 a7c:	0b1c193c 	bleq	706f74 <__bss_end+0x6fd830>
 a80:	0000196c 	andeq	r1, r0, ip, ror #18
 a84:	47003426 	strmi	r3, [r0, -r6, lsr #8]
 a88:	27000013 	smladcs	r0, r3, r0, r0
 a8c:	0e030139 	mcreq	1, 0, r0, cr3, cr9, {1}
 a90:	0b3b0b3a 	bleq	ec3780 <__bss_end+0xeba03c>
 a94:	13010b39 	movwne	r0, #6969	; 0x1b39
 a98:	34280000 	strtcc	r0, [r8], #-0
 a9c:	3a0e0300 	bcc	3816a4 <__bss_end+0x377f60>
 aa0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 aa4:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 aa8:	00031c19 	andeq	r1, r3, r9, lsl ip
 aac:	00212900 	eoreq	r2, r1, r0, lsl #18
 ab0:	052f1349 	streq	r1, [pc, #-841]!	; 76f <shift+0x76f>
 ab4:	2e2a0000 	cdpcs	0, 2, cr0, cr10, cr0, {0}
 ab8:	3a134701 	bcc	4d26c4 <__bss_end+0x4c8f80>
 abc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 ac0:	1113640b 	tstne	r3, fp, lsl #8
 ac4:	40061201 	andmi	r1, r6, r1, lsl #4
 ac8:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 acc:	00001301 	andeq	r1, r0, r1, lsl #6
 ad0:	0300052b 	movweq	r0, #1323	; 0x52b
 ad4:	3413490e 	ldrcc	r4, [r3], #-2318	; 0xfffff6f2
 ad8:	00180219 	andseq	r0, r8, r9, lsl r2
 adc:	00052c00 	andeq	r2, r5, r0, lsl #24
 ae0:	0b3a0803 	bleq	e82af4 <__bss_end+0xe793b0>
 ae4:	0b390b3b 	bleq	e437d8 <__bss_end+0xe3a094>
 ae8:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 aec:	342d0000 	strtcc	r0, [sp], #-0
 af0:	3a080300 	bcc	2016f8 <__bss_end+0x1f7fb4>
 af4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 af8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 afc:	2e000018 	mcrcs	0, 0, r0, cr0, cr8, {0}
 b00:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 b04:	0b3b0b3a 	bleq	ec37f4 <__bss_end+0xeba0b0>
 b08:	13490b39 	movtne	r0, #39737	; 0x9b39
 b0c:	00001802 	andeq	r1, r0, r2, lsl #16
 b10:	47012e2f 	strmi	r2, [r1, -pc, lsr #28]
 b14:	3b0b3a13 	blcc	2cf368 <__bss_end+0x2c5c24>
 b18:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
 b1c:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 b20:	97184006 	ldrls	r4, [r8, -r6]
 b24:	13011942 	movwne	r1, #6466	; 0x1942
 b28:	2e300000 	cdpcs	0, 3, cr0, cr0, cr0, {0}
 b2c:	3a134701 	bcc	4d2738 <__bss_end+0x4c8ff4>
 b30:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 b34:	2013640b 	andscs	r6, r3, fp, lsl #8
 b38:	0013010b 	andseq	r0, r3, fp, lsl #2
 b3c:	00053100 	andeq	r3, r5, r0, lsl #2
 b40:	13490e03 	movtne	r0, #40451	; 0x9e03
 b44:	00001934 	andeq	r1, r0, r4, lsr r9
 b48:	31012e32 	tstcc	r1, r2, lsr lr
 b4c:	640e6e13 	strvs	r6, [lr], #-3603	; 0xfffff1ed
 b50:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 b54:	96184006 	ldrls	r4, [r8], -r6
 b58:	13011942 	movwne	r1, #6466	; 0x1942
 b5c:	05330000 	ldreq	r0, [r3, #-0]!
 b60:	02133100 	andseq	r3, r3, #0, 2
 b64:	34000018 	strcc	r0, [r0], #-24	; 0xffffffe8
 b68:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 b6c:	0b3b0b3a 	bleq	ec385c <__bss_end+0xeba118>
 b70:	13490b39 	movtne	r0, #39737	; 0x9b39
 b74:	2e350000 	cdpcs	0, 3, cr0, cr5, cr0, {0}
 b78:	6e133101 	mufvss	f3, f3, f1
 b7c:	1113640e 	tstne	r3, lr, lsl #8
 b80:	40061201 	andmi	r1, r6, r1, lsl #4
 b84:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 b88:	01000000 	mrseq	r0, (UNDEF: 0)
 b8c:	06100011 			; <UNDEFINED> instruction: 0x06100011
 b90:	01120111 	tsteq	r2, r1, lsl r1
 b94:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 b98:	05130e25 	ldreq	r0, [r3, #-3621]	; 0xfffff1db
 b9c:	01000000 	mrseq	r0, (UNDEF: 0)
 ba0:	06100011 			; <UNDEFINED> instruction: 0x06100011
 ba4:	01120111 	tsteq	r2, r1, lsl r1
 ba8:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 bac:	05130e25 	ldreq	r0, [r3, #-3621]	; 0xfffff1db
 bb0:	01000000 	mrseq	r0, (UNDEF: 0)
 bb4:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 bb8:	0e030b13 	vmoveq.32	d3[0], r0
 bbc:	17100e1b 			; <UNDEFINED> instruction: 0x17100e1b
 bc0:	24020000 	strcs	r0, [r2], #-0
 bc4:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 bc8:	0008030b 	andeq	r0, r8, fp, lsl #6
 bcc:	00240300 	eoreq	r0, r4, r0, lsl #6
 bd0:	0b3e0b0b 	bleq	f83804 <__bss_end+0xf7a0c0>
 bd4:	00000e03 	andeq	r0, r0, r3, lsl #28
 bd8:	03001604 	movweq	r1, #1540	; 0x604
 bdc:	3b0b3a0e 	blcc	2cf41c <__bss_end+0x2c5cd8>
 be0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 be4:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
 be8:	0b0b000f 	bleq	2c0c2c <__bss_end+0x2b74e8>
 bec:	00001349 	andeq	r1, r0, r9, asr #6
 bf0:	27011506 	strcs	r1, [r1, -r6, lsl #10]
 bf4:	01134919 	tsteq	r3, r9, lsl r9
 bf8:	07000013 	smladeq	r0, r3, r0, r0
 bfc:	13490005 	movtne	r0, #36869	; 0x9005
 c00:	26080000 	strcs	r0, [r8], -r0
 c04:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
 c08:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 c0c:	0b3b0b3a 	bleq	ec38fc <__bss_end+0xeba1b8>
 c10:	13490b39 	movtne	r0, #39737	; 0x9b39
 c14:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 c18:	040a0000 	streq	r0, [sl], #-0
 c1c:	3e0e0301 	cdpcc	3, 0, cr0, cr14, cr1, {0}
 c20:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 c24:	3b0b3a13 	blcc	2cf478 <__bss_end+0x2c5d34>
 c28:	010b390b 	tsteq	fp, fp, lsl #18
 c2c:	0b000013 	bleq	c80 <shift+0xc80>
 c30:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 c34:	00000b1c 	andeq	r0, r0, ip, lsl fp
 c38:	4901010c 	stmdbmi	r1, {r2, r3, r8}
 c3c:	00130113 	andseq	r0, r3, r3, lsl r1
 c40:	00210d00 	eoreq	r0, r1, r0, lsl #26
 c44:	260e0000 	strcs	r0, [lr], -r0
 c48:	00134900 	andseq	r4, r3, r0, lsl #18
 c4c:	00340f00 	eorseq	r0, r4, r0, lsl #30
 c50:	0b3a0e03 	bleq	e84464 <__bss_end+0xe7ad20>
 c54:	0b39053b 	bleq	e42148 <__bss_end+0xe38a04>
 c58:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 c5c:	0000193c 	andeq	r1, r0, ip, lsr r9
 c60:	03001310 	movweq	r1, #784	; 0x310
 c64:	00193c0e 	andseq	r3, r9, lr, lsl #24
 c68:	00151100 	andseq	r1, r5, r0, lsl #2
 c6c:	00001927 	andeq	r1, r0, r7, lsr #18
 c70:	03001712 	movweq	r1, #1810	; 0x712
 c74:	00193c0e 	andseq	r3, r9, lr, lsl #24
 c78:	01131300 	tsteq	r3, r0, lsl #6
 c7c:	0b0b0e03 	bleq	2c4490 <__bss_end+0x2bad4c>
 c80:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 c84:	13010b39 	movwne	r0, #6969	; 0x1b39
 c88:	0d140000 	ldceq	0, cr0, [r4, #-0]
 c8c:	3a0e0300 	bcc	381894 <__bss_end+0x378150>
 c90:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 c94:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 c98:	1500000b 	strne	r0, [r0, #-11]
 c9c:	13490021 	movtne	r0, #36897	; 0x9021
 ca0:	00000b2f 	andeq	r0, r0, pc, lsr #22
 ca4:	03010416 	movweq	r0, #5142	; 0x1416
 ca8:	0b0b3e0e 	bleq	2d04e8 <__bss_end+0x2c6da4>
 cac:	3a13490b 	bcc	4d30e0 <__bss_end+0x4c999c>
 cb0:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 cb4:	0013010b 	andseq	r0, r3, fp, lsl #2
 cb8:	00341700 	eorseq	r1, r4, r0, lsl #14
 cbc:	0b3a1347 	bleq	e859e0 <__bss_end+0xe7c29c>
 cc0:	0b39053b 	bleq	e421b4 <__bss_end+0xe38a70>
 cc4:	00001802 	andeq	r1, r0, r2, lsl #16
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
  74:	0000010c 	andeq	r0, r0, ip, lsl #2
	...
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	12240002 	eorne	r0, r4, #2
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	00008344 	andeq	r8, r0, r4, asr #6
  94:	0000045c 	andeq	r0, r0, ip, asr r4
	...
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	1eff0002 	cdpne	0, 15, cr0, cr15, cr2, {0}
  a8:	00040000 	andeq	r0, r4, r0
  ac:	00000000 	andeq	r0, r0, r0
  b0:	000087a0 	andeq	r8, r0, r0, lsr #15
  b4:	000004b8 			; <UNDEFINED> instruction: 0x000004b8
	...
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	22310002 	eorscs	r0, r1, #2
  c8:	00040000 	andeq	r0, r4, r0
  cc:	00000000 	andeq	r0, r0, r0
  d0:	00008c58 	andeq	r8, r0, r8, asr ip
  d4:	000004b4 			; <UNDEFINED> instruction: 0x000004b4
	...
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	335b0002 	cmpcc	fp, #2
  e8:	00040000 	andeq	r0, r4, r0
  ec:	00000000 	andeq	r0, r0, r0
  f0:	0000910c 	andeq	r9, r0, ip, lsl #2
  f4:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	33810002 	orrcc	r0, r1, #2
 108:	00040000 	andeq	r0, r4, r0
 10c:	00000000 	andeq	r0, r0, r0
 110:	00009318 	andeq	r9, r0, r8, lsl r3
 114:	00000004 	andeq	r0, r0, r4
	...
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	33a70002 			; <UNDEFINED> instruction: 0x33a70002
 128:	00040000 	andeq	r0, r4, r0
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffff4c <__bss_end+0xffff6808>
       4:	63732f65 	cmnvs	r3, #404	; 0x194
       8:	6b6e6568 	blvs	1b995b0 <__bss_end+0x1b8fe6c>
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
      48:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffd21 <__bss_end+0xffff65dd>
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
      84:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffd5d <__bss_end+0xffff6619>
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
     20c:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffee5 <__bss_end+0xffff67a1>
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
     248:	2b2b4320 	blcs	ad0ed0 <__bss_end+0xac778c>
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
     2cc:	6a363731 	bvs	d8df98 <__bss_end+0xd84854>
     2d0:	732d667a 			; <UNDEFINED> instruction: 0x732d667a
     2d4:	616d2d20 	cmnvs	sp, r0, lsr #26
     2d8:	2d206d72 	stccs	13, cr6, [r0, #-456]!	; 0xfffffe38
     2dc:	6372616d 	cmnvs	r2, #1073741851	; 0x4000001b
     2e0:	72613d68 	rsbvc	r3, r1, #104, 26	; 0x1a00
     2e4:	7a36766d 	bvc	d9dca0 <__bss_end+0xd9455c>
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
     3ec:	5a5f006a 	bpl	17c059c <__bss_end+0x17b6e58>
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
     434:	4b4e5a5f 	blmi	1396db8 <__bss_end+0x138d674>
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
     480:	6a456e69 	bvs	115be2c <__bss_end+0x11526e8>
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
     4d4:	5a00746e 	bpl	1d694 <__bss_end+0x13f50>
     4d8:	69626d6f 	stmdbvs	r2!, {r0, r1, r2, r3, r5, r6, r8, sl, fp, sp, lr}^
     4dc:	656e0065 	strbvs	r0, [lr, #-101]!	; 0xffffff9b
     4e0:	43007478 	movwmi	r7, #1144	; 0x478
     4e4:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     4e8:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     4ec:	49006d65 	stmdbmi	r0, {r0, r2, r5, r6, r8, sl, fp, sp, lr}
     4f0:	6c61766e 	stclvs	6, cr7, [r1], #-440	; 0xfffffe48
     4f4:	485f6469 	ldmdami	pc, {r0, r3, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     4f8:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     4fc:	75520065 	ldrbvc	r0, [r2, #-101]	; 0xffffff9b
     500:	6e696e6e 	cdpvs	14, 6, cr6, cr9, cr14, {3}
     504:	65440067 	strbvs	r0, [r4, #-103]	; 0xffffff99
     508:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     50c:	555f656e 	ldrbpl	r6, [pc, #-1390]	; ffffffa6 <__bss_end+0xffff6862>
     510:	6168636e 	cmnvs	r8, lr, ror #6
     514:	6465676e 	strbtvs	r6, [r5], #-1902	; 0xfffff892
     518:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     51c:	46433131 			; <UNDEFINED> instruction: 0x46433131
     520:	73656c69 	cmnvc	r5, #26880	; 0x6900
     524:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     528:	4930316d 	ldmdbmi	r0!, {r0, r2, r3, r5, r6, r8, ip, sp}
     52c:	6974696e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, fp, sp, lr}^
     530:	7a696c61 	bvc	1a5b6bc <__bss_end+0x1a51f78>
     534:	00764565 	rsbseq	r4, r6, r5, ror #10
     538:	6e756f6d 	cdpvs	15, 7, cr6, cr5, cr13, {3}
     53c:	696f5074 	stmdbvs	pc!, {r2, r4, r5, r6, ip, lr}^	; <UNPREDICTABLE>
     540:	4700746e 	strmi	r7, [r0, -lr, ror #8]
     544:	435f7465 	cmpmi	pc, #1694498816	; 0x65000000
     548:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     54c:	505f746e 	subspl	r7, pc, lr, ror #8
     550:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     554:	47007373 	smlsdxmi	r0, r3, r3, r7
     558:	5f4f4950 	svcpl	0x004f4950
     55c:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     560:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     564:	50433631 	subpl	r3, r3, r1, lsr r6
     568:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     56c:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 3a8 <shift+0x3a8>
     570:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     574:	34317265 	ldrtcc	r7, [r1], #-613	; 0xfffffd9b
     578:	61657243 	cmnvs	r5, r3, asr #4
     57c:	505f6574 	subspl	r6, pc, r4, ror r5	; <UNPREDICTABLE>
     580:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     584:	50457373 	subpl	r7, r5, r3, ror r3
     588:	00626a68 	rsbeq	r6, r2, r8, ror #20
     58c:	76657270 			; <UNDEFINED> instruction: 0x76657270
     590:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     594:	4f433331 	svcmi	0x00433331
     598:	5f44454c 	svcpl	0x0044454c
     59c:	70736944 	rsbsvc	r6, r3, r4, asr #18
     5a0:	3879616c 	ldmdacc	r9!, {r2, r3, r5, r6, r8, sp, lr}^
     5a4:	5f747550 	svcpl	0x00747550
     5a8:	72616843 	rsbvc	r6, r1, #4390912	; 0x430000
     5ac:	63747445 	cmnvs	r4, #1157627904	; 0x45000000
     5b0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     5b4:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
     5b8:	4f495047 	svcmi	0x00495047
     5bc:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     5c0:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     5c4:	65473632 	strbvs	r3, [r7, #-1586]	; 0xfffff9ce
     5c8:	50475f74 	subpl	r5, r7, r4, ror pc
     5cc:	5152495f 	cmppl	r2, pc, asr r9
     5d0:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     5d4:	5f746365 	svcpl	0x00746365
     5d8:	61636f4c 	cmnvs	r3, ip, asr #30
     5dc:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     5e0:	30326a45 	eorscc	r6, r2, r5, asr #20
     5e4:	4950474e 	ldmdbmi	r0, {r1, r2, r3, r6, r8, r9, sl, lr}^
     5e8:	6e495f4f 	cdpvs	15, 4, cr5, cr9, cr15, {2}
     5ec:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     5f0:	5f747075 	svcpl	0x00747075
     5f4:	65707954 	ldrbvs	r7, [r0, #-2388]!	; 0xfffff6ac
     5f8:	31536a52 	cmpcc	r3, r2, asr sl
     5fc:	5a5f005f 	bpl	17c0780 <__bss_end+0x17b703c>
     600:	36314b4e 	ldrtcc	r4, [r1], -lr, asr #22
     604:	6f725043 	svcvs	0x00725043
     608:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     60c:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     610:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     614:	65473931 	strbvs	r3, [r7, #-2353]	; 0xfffff6cf
     618:	75435f74 	strbvc	r5, [r3, #-3956]	; 0xfffff08c
     61c:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     620:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     624:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     628:	00764573 	rsbseq	r4, r6, r3, ror r5
     62c:	5f534654 	svcpl	0x00534654
     630:	65657254 	strbvs	r7, [r5, #-596]!	; 0xfffffdac
     634:	646f4e5f 	strbtvs	r4, [pc], #-3679	; 63c <shift+0x63c>
     638:	65530065 	ldrbvs	r0, [r3, #-101]	; 0xffffff9b
     63c:	754f5f74 	strbvc	r5, [pc, #-3956]	; fffff6d0 <__bss_end+0xffff5f8c>
     640:	74757074 	ldrbtvc	r7, [r5], #-116	; 0xffffff8c
     644:	69726400 	ldmdbvs	r2!, {sl, sp, lr}^
     648:	5f726576 	svcpl	0x00726576
     64c:	00786469 	rsbseq	r6, r8, r9, ror #8
     650:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
     654:	6c6e4f5f 	stclvs	15, cr4, [lr], #-380	; 0xfffffe84
     658:	614d0079 	hvcvs	53257	; 0xd009
     65c:	72505f78 	subsvc	r5, r0, #120, 30	; 0x1e0
     660:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     664:	704f5f73 	subvc	r5, pc, r3, ror pc	; <UNPREDICTABLE>
     668:	64656e65 	strbtvs	r6, [r5], #-3685	; 0xfffff19b
     66c:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     670:	54007365 	strpl	r7, [r0], #-869	; 0xfffffc9b
     674:	5f555043 	svcpl	0x00555043
     678:	746e6f43 	strbtvc	r6, [lr], #-3907	; 0xfffff0bd
     67c:	00747865 	rsbseq	r7, r4, r5, ror #16
     680:	314e5a5f 	cmpcc	lr, pc, asr sl
     684:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     688:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     68c:	614d5f73 	hvcvs	54771	; 0xd5f3
     690:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     694:	63533872 	cmpvs	r3, #7471104	; 0x720000
     698:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     69c:	7645656c 	strbvc	r6, [r5], -ip, ror #10
     6a0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     6a4:	4f433331 	svcmi	0x00433331
     6a8:	5f44454c 	svcpl	0x0044454c
     6ac:	70736944 	rsbsvc	r6, r3, r4, asr #18
     6b0:	4379616c 	cmnmi	r9, #108, 2
     6b4:	4b504534 	blmi	1411b8c <__bss_end+0x1408448>
     6b8:	73490063 	movtvc	r0, #36963	; 0x9063
     6bc:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
     6c0:	0064656e 	rsbeq	r6, r4, lr, ror #10
     6c4:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     6c8:	6c417966 	mcrrvs	9, 6, r7, r1, cr6	; <UNPREDICTABLE>
     6cc:	6c42006c 	mcrrvs	0, 6, r0, r2, cr12
     6d0:	5f6b636f 	svcpl	0x006b636f
     6d4:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     6d8:	5f746e65 	svcpl	0x00746e65
     6dc:	636f7250 	cmnvs	pc, #80, 4
     6e0:	00737365 	rsbseq	r7, r3, r5, ror #6
     6e4:	5f746547 	svcpl	0x00746547
     6e8:	00444950 	subeq	r4, r4, r0, asr r9
     6ec:	746e6975 	strbtvc	r6, [lr], #-2421	; 0xfffff68b
     6f0:	745f3233 	ldrbvc	r3, [pc], #-563	; 6f8 <shift+0x6f8>
     6f4:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     6f8:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     6fc:	5f4f4950 	svcpl	0x004f4950
     700:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     704:	3972656c 	ldmdbcc	r2!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     708:	5f746547 	svcpl	0x00746547
     70c:	75706e49 	ldrbvc	r6, [r0, #-3657]!	; 0xfffff1b7
     710:	006a4574 	rsbeq	r4, sl, r4, ror r5
     714:	314e5a5f 	cmpcc	lr, pc, asr sl
     718:	50474333 	subpl	r4, r7, r3, lsr r3
     71c:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     720:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     724:	30317265 	eorscc	r7, r1, r5, ror #4
     728:	5f746553 	svcpl	0x00746553
     72c:	7074754f 	rsbsvc	r7, r4, pc, asr #10
     730:	6a457475 	bvs	115d90c <__bss_end+0x11541c8>
     734:	5a5f0062 	bpl	17c08c4 <__bss_end+0x17b7180>
     738:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     73c:	44454c4f 	strbmi	r4, [r5], #-3151	; 0xfffff3b1
     740:	7369445f 	cmnvc	r9, #1593835520	; 0x5f000000
     744:	79616c70 	stmdbvc	r1!, {r4, r5, r6, sl, fp, sp, lr}^
     748:	656c4335 	strbvs	r4, [ip, #-821]!	; 0xfffffccb
     74c:	62457261 	subvs	r7, r5, #268435462	; 0x10000006
     750:	43534200 	cmpmi	r3, #0, 4
     754:	61425f31 	cmpvs	r2, r1, lsr pc
     758:	50006573 	andpl	r6, r0, r3, ror r5
     75c:	435f7475 	cmpmi	pc, #1962934272	; 0x75000000
     760:	00726168 	rsbseq	r6, r2, r8, ror #2
     764:	74696157 	strbtvc	r6, [r9], #-343	; 0xfffffea9
     768:	61544e00 	cmpvs	r4, r0, lsl #28
     76c:	535f6b73 	cmppl	pc, #117760	; 0x1cc00
     770:	65746174 	ldrbvs	r6, [r4, #-372]!	; 0xfffffe8c
     774:	68635300 	stmdavs	r3!, {r8, r9, ip, lr}^
     778:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     77c:	44455f65 	strbmi	r5, [r5], #-3941	; 0xfffff09b
     780:	6c420046 	mcrrvs	0, 4, r0, r2, cr6
     784:	656b636f 	strbvs	r6, [fp, #-879]!	; 0xfffffc91
     788:	436d0064 	cmnmi	sp, #100	; 0x64
     78c:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     790:	545f746e 	ldrbpl	r7, [pc], #-1134	; 798 <shift+0x798>
     794:	5f6b7361 	svcpl	0x006b7361
     798:	65646f4e 	strbvs	r6, [r4, #-3918]!	; 0xfffff0b2
     79c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     7a0:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     7a4:	5f4f4950 	svcpl	0x004f4950
     7a8:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     7ac:	4372656c 	cmnmi	r2, #108, 10	; 0x1b000000
     7b0:	006a4534 	rsbeq	r4, sl, r4, lsr r5
     7b4:	6f6f526d 	svcvs	0x006f526d
     7b8:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     7bc:	5a5f0076 	bpl	17c099c <__bss_end+0x17b7258>
     7c0:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     7c4:	636f7250 	cmnvs	pc, #80, 4
     7c8:	5f737365 	svcpl	0x00737365
     7cc:	616e614d 	cmnvs	lr, sp, asr #2
     7d0:	39726567 	ldmdbcc	r2!, {r0, r1, r2, r5, r6, r8, sl, sp, lr}^
     7d4:	74697753 	strbtvc	r7, [r9], #-1875	; 0xfffff8ad
     7d8:	545f6863 	ldrbpl	r6, [pc], #-2147	; 7e0 <shift+0x7e0>
     7dc:	3150456f 	cmpcc	r0, pc, ror #10
     7e0:	72504338 	subsvc	r4, r0, #56, 6	; 0xe0000000
     7e4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     7e8:	694c5f73 	stmdbvs	ip, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     7ec:	4e5f7473 	mrcmi	4, 2, r7, cr15, cr3, {3}
     7f0:	0065646f 	rsbeq	r6, r5, pc, ror #8
     7f4:	5f6e6970 	svcpl	0x006e6970
     7f8:	00786469 	rsbseq	r6, r8, r9, ror #8
     7fc:	5f757063 	svcpl	0x00757063
     800:	746e6f63 	strbtvc	r6, [lr], #-3939	; 0xfffff09d
     804:	00747865 	rsbseq	r7, r4, r5, ror #16
     808:	4950476d 	ldmdbmi	r0, {r0, r2, r3, r5, r6, r8, r9, sl, lr}^
     80c:	7243004f 	subvc	r0, r3, #79	; 0x4f
     810:	65746165 	ldrbvs	r6, [r4, #-357]!	; 0xfffffe9b
     814:	6f72505f 	svcvs	0x0072505f
     818:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     81c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     820:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
     824:	4f495047 	svcmi	0x00495047
     828:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     82c:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     830:	65473931 	strbvs	r3, [r7, #-2353]	; 0xfffff6cf
     834:	50475f74 	subpl	r5, r7, r4, ror pc
     838:	4c455346 	mcrrmi	3, 4, r5, r5, cr6
     83c:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     840:	6f697461 	svcvs	0x00697461
     844:	526a456e 	rsbpl	r4, sl, #461373440	; 0x1b800000
     848:	5f30536a 	svcpl	0x0030536a
     84c:	65704f00 	ldrbvs	r4, [r0, #-3840]!	; 0xfffff100
     850:	7369006e 	cmnvc	r9, #110	; 0x6e
     854:	65726944 	ldrbvs	r6, [r2, #-2372]!	; 0xfffff6bc
     858:	726f7463 	rsbvc	r7, pc, #1660944384	; 0x63000000
     85c:	65470079 	strbvs	r0, [r7, #-121]	; 0xffffff87
     860:	50475f74 	subpl	r5, r7, r4, ror pc
     864:	5f524c43 	svcpl	0x00524c43
     868:	61636f4c 	cmnvs	r3, ip, asr #30
     86c:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     870:	6d695400 	cfstrdvs	mvd5, [r9, #-0]
     874:	425f7265 	subsmi	r7, pc, #1342177286	; 0x50000006
     878:	00657361 	rsbeq	r7, r5, r1, ror #6
     87c:	5f534667 	svcpl	0x00534667
     880:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     884:	5f737265 	svcpl	0x00737265
     888:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
     88c:	47730074 			; <UNDEFINED> instruction: 0x47730074
     890:	004f4950 	subeq	r4, pc, r0, asr r9	; <UNPREDICTABLE>
     894:	5f746547 	svcpl	0x00746547
     898:	44455047 	strbmi	r5, [r5], #-71	; 0xffffffb9
     89c:	6f4c5f53 	svcvs	0x004c5f53
     8a0:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     8a4:	53006e6f 	movwpl	r6, #3695	; 0xe6f
     8a8:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     8ac:	5f4f4950 	svcpl	0x004f4950
     8b0:	636e7546 	cmnvs	lr, #293601280	; 0x11800000
     8b4:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     8b8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     8bc:	4f433331 	svcmi	0x00433331
     8c0:	5f44454c 	svcpl	0x0044454c
     8c4:	70736944 	rsbsvc	r6, r3, r4, asr #18
     8c8:	3479616c 	ldrbtcc	r6, [r9], #-364	; 0xfffffe94
     8cc:	70696c46 	rsbvc	r6, r9, r6, asr #24
     8d0:	5f007645 	svcpl	0x00007645
     8d4:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     8d8:	6f725043 	svcvs	0x00725043
     8dc:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     8e0:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     8e4:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     8e8:	6f4e3431 	svcvs	0x004e3431
     8ec:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     8f0:	6f72505f 	svcvs	0x0072505f
     8f4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     8f8:	32315045 	eorscc	r5, r1, #69	; 0x45
     8fc:	73615454 	cmnvc	r1, #84, 8	; 0x54000000
     900:	74535f6b 	ldrbvc	r5, [r3], #-3947	; 0xfffff095
     904:	74637572 	strbtvc	r7, [r3], #-1394	; 0xfffffa8e
     908:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     90c:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     910:	495f6465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     914:	006f666e 	rsbeq	r6, pc, lr, ror #12
     918:	74434f49 	strbvc	r4, [r3], #-3913	; 0xfffff0b7
     91c:	486d006c 	stmdami	sp!, {r2, r3, r5, r6}^
     920:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     924:	65540065 	ldrbvs	r0, [r4, #-101]	; 0xffffff9b
     928:	6e696d72 	mcrvs	13, 3, r6, cr9, cr2, {3}
     92c:	00657461 	rsbeq	r7, r5, r1, ror #8
     930:	6e6e7552 	mcrvs	5, 3, r7, cr14, cr2, {2}
     934:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     938:	746f4e00 	strbtvc	r4, [pc], #-3584	; 940 <shift+0x940>
     93c:	5f796669 	svcpl	0x00796669
     940:	636f7250 	cmnvs	pc, #80, 4
     944:	00737365 	rsbseq	r7, r3, r5, ror #6
     948:	314e5a5f 	cmpcc	lr, pc, asr sl
     94c:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     950:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     954:	614d5f73 	hvcvs	54771	; 0xd5f3
     958:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     95c:	45344372 	ldrmi	r4, [r4, #-882]!	; 0xfffffc8e
     960:	5a5f0076 	bpl	17c0b40 <__bss_end+0x17b73fc>
     964:	33314b4e 	teqcc	r1, #79872	; 0x13800
     968:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     96c:	61485f4f 	cmpvs	r8, pc, asr #30
     970:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     974:	47383172 			; <UNDEFINED> instruction: 0x47383172
     978:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     97c:	54455350 	strbpl	r5, [r5], #-848	; 0xfffffcb0
     980:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     984:	6f697461 	svcvs	0x00697461
     988:	526a456e 	rsbpl	r4, sl, #461373440	; 0x1b800000
     98c:	5f30536a 	svcpl	0x0030536a
     990:	6f682f00 	svcvs	0x00682f00
     994:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
     998:	6e656863 	cdpvs	8, 6, cr6, cr5, cr3, {3}
     99c:	6f2f6a6b 	svcvs	0x002f6a6b
     9a0:	32303273 	eorscc	r3, r0, #805306375	; 0x30000007
     9a4:	70732f32 	rsbsvc	r2, r3, r2, lsr pc
     9a8:	756f732f 	strbvc	r7, [pc, #-815]!	; 681 <shift+0x681>
     9ac:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     9b0:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
     9b4:	61707372 	cmnvs	r0, r2, ror r3
     9b8:	6f2f6563 	svcvs	0x002f6563
     9bc:	5f64656c 	svcpl	0x0064656c
     9c0:	6b736174 	blvs	1cd8f98 <__bss_end+0x1ccf854>
     9c4:	69616d2f 	stmdbvs	r1!, {r0, r1, r2, r3, r5, r8, sl, fp, sp, lr}^
     9c8:	70632e6e 	rsbvc	r2, r3, lr, ror #28
     9cc:	656d0070 	strbvs	r0, [sp, #-112]!	; 0xffffff90
     9d0:	67617373 			; <UNDEFINED> instruction: 0x67617373
     9d4:	6d007365 	stcvs	3, cr7, [r0, #-404]	; 0xfffffe6c
     9d8:	6b636f4c 	blvs	18dc710 <__bss_end+0x18d2fcc>
     9dc:	6f526d00 	svcvs	0x00526d00
     9e0:	4d5f746f 	cfldrdmi	mvd7, [pc, #-444]	; 82c <shift+0x82c>
     9e4:	5f00746e 	svcpl	0x0000746e
     9e8:	314b4e5a 	cmpcc	fp, sl, asr lr
     9ec:	50474333 	subpl	r4, r7, r3, lsr r3
     9f0:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     9f4:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     9f8:	32327265 	eorscc	r7, r2, #1342177286	; 0x50000006
     9fc:	5f746547 	svcpl	0x00746547
     a00:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     a04:	64657463 	strbtvs	r7, [r5], #-1123	; 0xfffffb9d
     a08:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     a0c:	505f746e 	subspl	r7, pc, lr, ror #8
     a10:	76456e69 	strbvc	r6, [r5], -r9, ror #28
     a14:	656c4300 	strbvs	r4, [ip, #-768]!	; 0xfffffd00
     a18:	5f007261 	svcpl	0x00007261
     a1c:	314b4e5a 	cmpcc	fp, sl, asr lr
     a20:	4c4f4333 	mcrrmi	3, 3, r4, pc, cr3
     a24:	445f4445 	ldrbmi	r4, [pc], #-1093	; a2c <shift+0xa2c>
     a28:	6c707369 	ldclvs	3, cr7, [r0], #-420	; 0xfffffe5c
     a2c:	49397961 	ldmdbmi	r9!, {r0, r5, r6, r8, fp, ip, sp, lr}
     a30:	704f5f73 	subvc	r5, pc, r3, ror pc	; <UNPREDICTABLE>
     a34:	64656e65 	strbtvs	r6, [r5], #-3685	; 0xfffff19b
     a38:	5f007645 	svcpl	0x00007645
     a3c:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     a40:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     a44:	61485f4f 	cmpvs	r8, pc, asr #30
     a48:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     a4c:	45393172 	ldrmi	r3, [r9, #-370]!	; 0xfffffe8e
     a50:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
     a54:	76455f65 	strbvc	r5, [r5], -r5, ror #30
     a58:	5f746e65 	svcpl	0x00746e65
     a5c:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     a60:	6a457463 	bvs	115dbf4 <__bss_end+0x11544b0>
     a64:	474e3032 	smlaldxmi	r3, lr, r2, r0
     a68:	5f4f4950 	svcpl	0x004f4950
     a6c:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     a70:	70757272 	rsbsvc	r7, r5, r2, ror r2
     a74:	79545f74 	ldmdbvc	r4, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     a78:	4e006570 	cfrshl64mi	mvdx0, mvdx0, r6
     a7c:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     a80:	72640079 	rsbvc	r0, r4, #121	; 0x79
     a84:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     a88:	656c4300 	strbvs	r4, [ip, #-768]!	; 0xfffffd00
     a8c:	445f7261 	ldrbmi	r7, [pc], #-609	; a94 <shift+0xa94>
     a90:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     a94:	5f646574 	svcpl	0x00646574
     a98:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     a9c:	61480074 	hvcvs	32772	; 0x8004
     aa0:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     aa4:	5152495f 	cmppl	r2, pc, asr r9
     aa8:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     aac:	68746150 	ldmdavs	r4!, {r4, r6, r8, sp, lr}^
     ab0:	676e654c 	strbvs	r6, [lr, -ip, asr #10]!
     ab4:	5f006874 	svcpl	0x00006874
     ab8:	314b4e5a 	cmpcc	fp, sl, asr lr
     abc:	50474333 	subpl	r4, r7, r3, lsr r3
     ac0:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     ac4:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     ac8:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     acc:	5f746547 	svcpl	0x00746547
     ad0:	44455047 	strbmi	r5, [r5], #-71	; 0xffffffb9
     ad4:	6f4c5f53 	svcvs	0x004c5f53
     ad8:	69746163 	ldmdbvs	r4!, {r0, r1, r5, r6, r8, sp, lr}^
     adc:	6a456e6f 	bvs	115c4a0 <__bss_end+0x1152d5c>
     ae0:	30536a52 	subscc	r6, r3, r2, asr sl
     ae4:	614d005f 	qdaddvs	r0, pc, sp	; <UNPREDICTABLE>
     ae8:	44534678 	ldrbmi	r4, [r3], #-1656	; 0xfffff988
     aec:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     af0:	6d614e72 	stclvs	14, cr4, [r1, #-456]!	; 0xfffffe38
     af4:	6e654c65 	cdpvs	12, 6, cr4, cr5, cr5, {3}
     af8:	00687467 	rsbeq	r7, r8, r7, ror #8
     afc:	6e69506d 	cdpvs	0, 6, cr5, cr9, cr13, {3}
     b00:	7365525f 	cmnvc	r5, #-268435451	; 0xf0000005
     b04:	61767265 	cmnvs	r6, r5, ror #4
     b08:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     b0c:	72575f73 	subsvc	r5, r7, #460	; 0x1cc
     b10:	00657469 	rsbeq	r7, r5, r9, ror #8
     b14:	314e5a5f 	cmpcc	lr, pc, asr sl
     b18:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     b1c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     b20:	614d5f73 	hvcvs	54771	; 0xd5f3
     b24:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     b28:	53313172 	teqpl	r1, #-2147483620	; 0x8000001c
     b2c:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     b30:	5f656c75 	svcpl	0x00656c75
     b34:	76455252 			; <UNDEFINED> instruction: 0x76455252
     b38:	65474e00 	strbvs	r4, [r7, #-3584]	; 0xfffff200
     b3c:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     b40:	5f646568 	svcpl	0x00646568
     b44:	6f666e49 	svcvs	0x00666e49
     b48:	7079545f 	rsbsvc	r5, r9, pc, asr r4
     b4c:	6c730065 	ldclvs	0, cr0, [r3], #-404	; 0xfffffe6c
     b50:	5f706565 	svcpl	0x00706565
     b54:	656d6974 	strbvs	r6, [sp, #-2420]!	; 0xfffff68c
     b58:	50470072 	subpl	r0, r7, r2, ror r0
     b5c:	505f4f49 	subspl	r4, pc, r9, asr #30
     b60:	435f6e69 	cmpmi	pc, #1680	; 0x690
     b64:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     b68:	73617400 	cmnvc	r1, #0, 8
     b6c:	6157006b 	cmpvs	r7, fp, rrx
     b70:	465f7469 	ldrbmi	r7, [pc], -r9, ror #8
     b74:	455f726f 	ldrbmi	r7, [pc, #-623]	; 90d <shift+0x90d>
     b78:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     b7c:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     b80:	4950475f 	ldmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, r9, sl, lr}^
     b84:	75465f4f 	strbvc	r5, [r6, #-3919]	; 0xfffff0b1
     b88:	6974636e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
     b8c:	62006e6f 	andvs	r6, r0, #1776	; 0x6f0
     b90:	006c6f6f 	rsbeq	r6, ip, pc, ror #30
     b94:	314e5a5f 	cmpcc	lr, pc, asr sl
     b98:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     b9c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     ba0:	614d5f73 	hvcvs	54771	; 0xd5f3
     ba4:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     ba8:	47383172 			; <UNDEFINED> instruction: 0x47383172
     bac:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     bb0:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     bb4:	72656c75 	rsbvc	r6, r5, #29952	; 0x7500
     bb8:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     bbc:	3032456f 	eorscc	r4, r2, pc, ror #10
     bc0:	7465474e 	strbtvc	r4, [r5], #-1870	; 0xfffff8b2
     bc4:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     bc8:	495f6465 	ldmdbmi	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     bcc:	5f6f666e 	svcpl	0x006f666e
     bd0:	65707954 	ldrbvs	r7, [r0, #-2388]!	; 0xfffff6ac
     bd4:	54007650 	strpl	r7, [r0], #-1616	; 0xfffff9b0
     bd8:	5f474e52 	svcpl	0x00474e52
     bdc:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     be0:	66654400 	strbtvs	r4, [r5], -r0, lsl #8
     be4:	746c7561 	strbtvc	r7, [ip], #-1377	; 0xfffffa9f
     be8:	6f6c435f 	svcvs	0x006c435f
     bec:	525f6b63 	subspl	r6, pc, #101376	; 0x18c00
     bf0:	00657461 	rsbeq	r7, r5, r1, ror #8
     bf4:	6f6f526d 	svcvs	0x006f526d
     bf8:	79535f74 	ldmdbvc	r3, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     bfc:	65470073 	strbvs	r0, [r7, #-115]	; 0xffffff8d
     c00:	50475f74 	subpl	r5, r7, r4, ror pc
     c04:	5f544553 	svcpl	0x00544553
     c08:	61636f4c 	cmnvs	r3, ip, asr #30
     c0c:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     c10:	72506d00 	subsvc	r6, r0, #0, 26
     c14:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     c18:	694c5f73 	stmdbvs	ip, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     c1c:	485f7473 	ldmdami	pc, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
     c20:	00646165 	rsbeq	r6, r4, r5, ror #2
     c24:	6863536d 	stmdavs	r3!, {r0, r2, r3, r5, r6, r8, r9, ip, lr}^
     c28:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     c2c:	6e465f65 	cdpvs	15, 4, cr5, cr6, cr5, {3}
     c30:	5a5f0063 	bpl	17c0dc4 <__bss_end+0x17b7680>
     c34:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     c38:	636f7250 	cmnvs	pc, #80, 4
     c3c:	5f737365 	svcpl	0x00737365
     c40:	616e614d 	cmnvs	lr, sp, asr #2
     c44:	32726567 	rsbscc	r6, r2, #432013312	; 0x19c00000
     c48:	6f6c4231 	svcvs	0x006c4231
     c4c:	435f6b63 	cmpmi	pc, #101376	; 0x18c00
     c50:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     c54:	505f746e 	subspl	r7, pc, lr, ror #8
     c58:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     c5c:	76457373 			; <UNDEFINED> instruction: 0x76457373
     c60:	61576d00 	cmpvs	r7, r0, lsl #26
     c64:	6e697469 	cdpvs	4, 6, cr7, cr9, cr9, {3}
     c68:	69465f67 	stmdbvs	r6, {r0, r1, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     c6c:	0073656c 	rsbseq	r6, r3, ip, ror #10
     c70:	6b636f4c 	blvs	18dc9a8 <__bss_end+0x18d3264>
     c74:	6c6e555f 	cfstr64vs	mvdx5, [lr], #-380	; 0xfffffe84
     c78:	656b636f 	strbvs	r6, [fp, #-879]!	; 0xfffffc91
     c7c:	4c6d0064 	stclmi	0, cr0, [sp], #-400	; 0xfffffe70
     c80:	5f747361 	svcpl	0x00747361
     c84:	00444950 	subeq	r4, r4, r0, asr r9
     c88:	314e5a5f 	cmpcc	lr, pc, asr sl
     c8c:	50474333 	subpl	r4, r7, r3, lsr r3
     c90:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     c94:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     c98:	37317265 	ldrcc	r7, [r1, -r5, ror #4]!
     c9c:	5f746553 	svcpl	0x00746553
     ca0:	4f495047 	svcmi	0x00495047
     ca4:	6e75465f 	mrcvs	6, 3, r4, cr5, cr15, {2}
     ca8:	6f697463 	svcvs	0x00697463
     cac:	316a456e 	cmncc	sl, lr, ror #10
     cb0:	50474e34 	subpl	r4, r7, r4, lsr lr
     cb4:	465f4f49 	ldrbmi	r4, [pc], -r9, asr #30
     cb8:	74636e75 	strbtvc	r6, [r3], #-3701	; 0xfffff18b
     cbc:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     cc0:	5f746547 	svcpl	0x00746547
     cc4:	75706e49 	ldrbvc	r6, [r0, #-3657]!	; 0xfffff1b7
     cc8:	5a5f0074 	bpl	17c0ea0 <__bss_end+0x17b775c>
     ccc:	4331314e 	teqmi	r1, #-2147483629	; 0x80000013
     cd0:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     cd4:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     cd8:	4f346d65 	svcmi	0x00346d65
     cdc:	456e6570 	strbmi	r6, [lr, #-1392]!	; 0xfffffa90
     ce0:	31634b50 	cmncc	r3, r0, asr fp
     ce4:	69464e35 	stmdbvs	r6, {r0, r2, r4, r5, r9, sl, fp, lr}^
     ce8:	4f5f656c 	svcmi	0x005f656c
     cec:	5f6e6570 	svcpl	0x006e6570
     cf0:	65646f4d 	strbvs	r6, [r4, #-3917]!	; 0xfffff0b3
     cf4:	69775300 	ldmdbvs	r7!, {r8, r9, ip, lr}^
     cf8:	5f686374 	svcpl	0x00686374
     cfc:	43006f54 	movwmi	r6, #3924	; 0xf54
     d00:	65736f6c 	ldrbvs	r6, [r3, #-3948]!	; 0xfffff094
     d04:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     d08:	50433631 	subpl	r3, r3, r1, lsr r6
     d0c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     d10:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; b4c <shift+0xb4c>
     d14:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     d18:	32317265 	eorscc	r7, r1, #1342177286	; 0x50000006
     d1c:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     d20:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     d24:	4644455f 			; <UNDEFINED> instruction: 0x4644455f
     d28:	47007645 	strmi	r7, [r0, -r5, asr #12]
     d2c:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     d30:	56454c50 			; <UNDEFINED> instruction: 0x56454c50
     d34:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     d38:	6f697461 	svcvs	0x00697461
     d3c:	5342006e 	movtpl	r0, #8302	; 0x206e
     d40:	425f3043 	subsmi	r3, pc, #67	; 0x43
     d44:	00657361 	rsbeq	r7, r5, r1, ror #6
     d48:	69736952 	ldmdbvs	r3!, {r1, r4, r6, r8, fp, sp, lr}^
     d4c:	455f676e 	ldrbmi	r6, [pc, #-1902]	; 5e6 <shift+0x5e6>
     d50:	00656764 	rsbeq	r6, r5, r4, ror #14
     d54:	63677261 	cmnvs	r7, #268435462	; 0x10000006
     d58:	73655200 	cmnvc	r5, #0, 4
     d5c:	65767265 	ldrbvs	r7, [r6, #-613]!	; 0xfffffd9b
     d60:	6e69505f 	mcrvs	0, 3, r5, cr9, cr15, {2}
     d64:	67694800 	strbvs	r4, [r9, -r0, lsl #16]!
     d68:	6f6e0068 	svcvs	0x006e0068
     d6c:	69666974 	stmdbvs	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     d70:	645f6465 	ldrbvs	r6, [pc], #-1125	; d78 <shift+0xd78>
     d74:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     d78:	00656e69 	rsbeq	r6, r5, r9, ror #28
     d7c:	76677261 	strbtvc	r7, [r7], -r1, ror #4
     d80:	6e697500 	cdpvs	5, 6, cr7, cr9, cr0, {0}
     d84:	5f363174 	svcpl	0x00363174
     d88:	61460074 	hvcvs	24580	; 0x6004
     d8c:	6e696c6c 	cdpvs	12, 6, cr6, cr9, cr12, {3}
     d90:	64455f67 	strbvs	r5, [r5], #-3943	; 0xfffff099
     d94:	6d006567 	cfstr32vs	mvfx6, [r0, #-412]	; 0xfffffe64
     d98:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
     d9c:	5f006465 	svcpl	0x00006465
     da0:	31314e5a 	teqcc	r1, sl, asr lr
     da4:	6c694643 	stclvs	6, cr4, [r9], #-268	; 0xfffffef4
     da8:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     dac:	436d6574 	cmnmi	sp, #116, 10	; 0x1d000000
     db0:	00764534 	rsbseq	r4, r6, r4, lsr r5
     db4:	314e5a5f 	cmpcc	lr, pc, asr sl
     db8:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     dbc:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     dc0:	614d5f73 	hvcvs	54771	; 0xd5f3
     dc4:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     dc8:	4e343172 	mrcmi	1, 1, r3, cr4, cr2, {3}
     dcc:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     dd0:	72505f79 	subsvc	r5, r0, #484	; 0x1e4
     dd4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     dd8:	006a4573 	rsbeq	r4, sl, r3, ror r5
     ddc:	69466f4e 	stmdbvs	r6, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     de0:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     de4:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     de8:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     dec:	73007265 	movwvc	r7, #613	; 0x265
     df0:	6c6e6970 			; <UNDEFINED> instruction: 0x6c6e6970
     df4:	5f6b636f 	svcpl	0x006b636f
     df8:	5a5f0074 	bpl	17c0fd0 <__bss_end+0x17b788c>
     dfc:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     e00:	44454c4f 	strbmi	r4, [r5], #-3151	; 0xfffff3b1
     e04:	7369445f 	cmnvc	r9, #1593835520	; 0x5f000000
     e08:	79616c70 	stmdbvc	r1!, {r4, r5, r6, sl, fp, sp, lr}^
     e0c:	76453444 	strbvc	r3, [r5], -r4, asr #8
     e10:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     e14:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     e18:	65746365 	ldrbvs	r6, [r4, #-869]!	; 0xfffffc9b
     e1c:	76455f64 	strbvc	r5, [r5], -r4, ror #30
     e20:	5f746e65 	svcpl	0x00746e65
     e24:	006e6950 	rsbeq	r6, lr, r0, asr r9
     e28:	64616544 	strbtvs	r6, [r1], #-1348	; 0xfffffabc
     e2c:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     e30:	72617000 	rsbvc	r7, r1, #0
     e34:	00746e65 	rsbseq	r6, r4, r5, ror #28
     e38:	726f6873 	rsbvc	r6, pc, #7536640	; 0x730000
     e3c:	6e692074 	mcrvs	0, 3, r2, cr9, cr4, {3}
     e40:	437e0074 	cmnmi	lr, #116	; 0x74
     e44:	44454c4f 	strbmi	r4, [r5], #-3151	; 0xfffff3b1
     e48:	7369445f 	cmnvc	r9, #1593835520	; 0x5f000000
     e4c:	79616c70 	stmdbvc	r1!, {r4, r5, r6, sl, fp, sp, lr}^
     e50:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     e54:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     e58:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
     e5c:	676e654c 	strbvs	r6, [lr, -ip, asr #10]!
     e60:	6d006874 	stcvs	8, cr6, [r0, #-464]	; 0xfffffe30
     e64:	746f6f52 	strbtvc	r6, [pc], #-3922	; e6c <shift+0xe6c>
     e68:	65724600 	ldrbvs	r4, [r2, #-1536]!	; 0xfffffa00
     e6c:	69505f65 	ldmdbvs	r0, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     e70:	5043006e 	subpl	r0, r3, lr, rrx
     e74:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     e78:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; cb4 <shift+0xcb4>
     e7c:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     e80:	55007265 	strpl	r7, [r0, #-613]	; 0xfffffd9b
     e84:	6570736e 	ldrbvs	r7, [r0, #-878]!	; 0xfffffc92
     e88:	69666963 	stmdbvs	r6!, {r0, r1, r5, r6, r8, fp, sp, lr}^
     e8c:	5f006465 	svcpl	0x00006465
     e90:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     e94:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     e98:	61485f4f 	cmpvs	r8, pc, asr #30
     e9c:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     ea0:	72463872 	subvc	r3, r6, #7471104	; 0x720000
     ea4:	505f6565 	subspl	r6, pc, r5, ror #10
     ea8:	6a456e69 	bvs	115c854 <__bss_end+0x1153110>
     eac:	73006262 	movwvc	r6, #610	; 0x262
     eb0:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     eb4:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     eb8:	49006d65 	stmdbmi	r0, {r0, r2, r5, r6, r8, sl, fp, sp, lr}
     ebc:	6974696e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, fp, sp, lr}^
     ec0:	7a696c61 	bvc	1a5c04c <__bss_end+0x1a52908>
     ec4:	69460065 	stmdbvs	r6, {r0, r2, r5, r6}^
     ec8:	435f646e 	cmpmi	pc, #1845493760	; 0x6e000000
     ecc:	646c6968 	strbtvs	r6, [ip], #-2408	; 0xfffff698
     ed0:	62747400 	rsbsvs	r7, r4, #0, 8
     ed4:	4e003072 	mcrmi	0, 0, r3, cr0, cr2, {3}
     ed8:	5f495753 	svcpl	0x00495753
     edc:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     ee0:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     ee4:	535f6d65 	cmppl	pc, #6464	; 0x1940
     ee8:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     eec:	4e006563 	cfsh32mi	mvfx6, mvfx0, #51
     ef0:	5f495753 	svcpl	0x00495753
     ef4:	636f7250 	cmnvs	pc, #80, 4
     ef8:	5f737365 	svcpl	0x00737365
     efc:	76726553 			; <UNDEFINED> instruction: 0x76726553
     f00:	00656369 	rsbeq	r6, r5, r9, ror #6
     f04:	6e65706f 	cdpvs	0, 6, cr7, cr5, cr15, {3}
     f08:	665f6465 	ldrbvs	r6, [pc], -r5, ror #8
     f0c:	73656c69 	cmnvc	r5, #26880	; 0x6900
     f10:	65695900 	strbvs	r5, [r9, #-2304]!	; 0xfffff700
     f14:	4900646c 	stmdbmi	r0, {r2, r3, r5, r6, sl, sp, lr}
     f18:	6665646e 	strbtvs	r6, [r5], -lr, ror #8
     f1c:	74696e69 	strbtvc	r6, [r9], #-3689	; 0xfffff197
     f20:	65470065 	strbvs	r0, [r7, #-101]	; 0xffffff9b
     f24:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     f28:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     f2c:	79425f73 	stmdbvc	r2, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     f30:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
     f34:	72655000 	rsbvc	r5, r5, #0
     f38:	65687069 	strbvs	r7, [r8, #-105]!	; 0xffffff97
     f3c:	5f6c6172 	svcpl	0x006c6172
     f40:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     f44:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     f48:	4650475f 			; <UNDEFINED> instruction: 0x4650475f
     f4c:	5f4c4553 	svcpl	0x004c4553
     f50:	61636f4c 	cmnvs	r3, ip, asr #30
     f54:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     f58:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     f5c:	4f433331 	svcmi	0x00433331
     f60:	5f44454c 	svcpl	0x0044454c
     f64:	70736944 	rsbsvc	r6, r3, r4, asr #18
     f68:	3179616c 	cmncc	r9, ip, ror #2
     f6c:	74755030 	ldrbtvc	r5, [r5], #-48	; 0xffffffd0
     f70:	7274535f 	rsbsvc	r5, r4, #2080374785	; 0x7c000001
     f74:	45676e69 	strbmi	r6, [r7, #-3689]!	; 0xfffff197
     f78:	4b507474 	blmi	141e150 <__bss_end+0x1414a0c>
     f7c:	5a5f0063 	bpl	17c1110 <__bss_end+0x17b79cc>
     f80:	33314b4e 	teqcc	r1, #79872	; 0x13800
     f84:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     f88:	61485f4f 	cmpvs	r8, pc, asr #30
     f8c:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     f90:	47373172 			; <UNDEFINED> instruction: 0x47373172
     f94:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     f98:	5f4f4950 	svcpl	0x004f4950
     f9c:	636e7546 	cmnvs	lr, #293601280	; 0x11800000
     fa0:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     fa4:	46006a45 	strmi	r6, [r0], -r5, asr #20
     fa8:	0070696c 	rsbseq	r6, r0, ip, ror #18
     fac:	61766e49 	cmnvs	r6, r9, asr #28
     fb0:	5f64696c 	svcpl	0x0064696c
     fb4:	006e6950 	rsbeq	r6, lr, r0, asr r9
     fb8:	314e5a5f 	cmpcc	lr, pc, asr sl
     fbc:	50474333 	subpl	r4, r7, r3, lsr r3
     fc0:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     fc4:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     fc8:	30327265 	eorscc	r7, r2, r5, ror #4
     fcc:	61736944 	cmnvs	r3, r4, asr #18
     fd0:	5f656c62 	svcpl	0x00656c62
     fd4:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     fd8:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     fdc:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     fe0:	30326a45 	eorscc	r6, r2, r5, asr #20
     fe4:	4950474e 	ldmdbmi	r0, {r1, r2, r3, r6, r8, r9, sl, lr}^
     fe8:	6e495f4f 	cdpvs	15, 4, cr5, cr9, cr15, {2}
     fec:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     ff0:	5f747075 	svcpl	0x00747075
     ff4:	65707954 	ldrbvs	r7, [r0, #-2388]!	; 0xfffff6ac
     ff8:	69506d00 	ldmdbvs	r0, {r8, sl, fp, sp, lr}^
     ffc:	65525f6e 	ldrbvs	r5, [r2, #-3950]	; 0xfffff092
    1000:	76726573 			; <UNDEFINED> instruction: 0x76726573
    1004:	6f697461 	svcvs	0x00697461
    1008:	525f736e 	subspl	r7, pc, #-1207959551	; 0xb8000001
    100c:	00646165 	rsbeq	r6, r4, r5, ror #2
    1010:	6b636f4c 	blvs	18dcd48 <__bss_end+0x18d3604>
    1014:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
    1018:	0064656b 	rsbeq	r6, r4, fp, ror #10
    101c:	314e5a5f 	cmpcc	lr, pc, asr sl
    1020:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
    1024:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1028:	614d5f73 	hvcvs	54771	; 0xd5f3
    102c:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
    1030:	48383172 	ldmdami	r8!, {r1, r4, r5, r6, r8, ip, sp}
    1034:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
    1038:	72505f65 	subsvc	r5, r0, #404	; 0x194
    103c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1040:	57535f73 			; <UNDEFINED> instruction: 0x57535f73
    1044:	30324549 	eorscc	r4, r2, r9, asr #10
    1048:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
    104c:	6f72505f 	svcvs	0x0072505f
    1050:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1054:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
    1058:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
    105c:	526a6a6a 	rsbpl	r6, sl, #434176	; 0x6a000
    1060:	53543131 	cmppl	r4, #1073741836	; 0x4000000c
    1064:	525f4957 	subspl	r4, pc, #1425408	; 0x15c000
    1068:	6c757365 	ldclvs	3, cr7, [r5], #-404	; 0xfffffe6c
    106c:	5a5f0074 	bpl	17c1244 <__bss_end+0x17b7b00>
    1070:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
    1074:	4f495047 	svcmi	0x00495047
    1078:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
    107c:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
    1080:	6c433032 	mcrrvs	0, 3, r3, r3, cr2
    1084:	5f726165 	svcpl	0x00726165
    1088:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
    108c:	64657463 	strbtvs	r7, [r5], #-1123	; 0xfffffb9d
    1090:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
    1094:	6a45746e 	bvs	115e254 <__bss_end+0x1154b10>
    1098:	74655300 	strbtvc	r5, [r5], #-768	; 0xfffffd00
    109c:	7869505f 	stmdavc	r9!, {r0, r1, r2, r3, r4, r6, ip, lr}^
    10a0:	73006c65 	movwvc	r6, #3173	; 0xc65
    10a4:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    10a8:	756f635f 	strbvc	r6, [pc, #-863]!	; d51 <shift+0xd51>
    10ac:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    10b0:	736e7500 	cmnvc	lr, #0, 10
    10b4:	656e6769 	strbvs	r6, [lr, #-1897]!	; 0xfffff897
    10b8:	68632064 	stmdavs	r3!, {r2, r5, r6, sp}^
    10bc:	49007261 	stmdbmi	r0, {r0, r5, r6, r9, ip, sp, lr}
    10c0:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    10c4:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
    10c8:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
    10cc:	656c535f 	strbvs	r5, [ip, #-863]!	; 0xfffffca1
    10d0:	47007065 	strmi	r7, [r0, -r5, rrx]
    10d4:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
    10d8:	52495f50 	subpl	r5, r9, #80, 30	; 0x140
    10dc:	65445f51 	strbvs	r5, [r4, #-3921]	; 0xfffff0af
    10e0:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
    10e4:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
    10e8:	6f697461 	svcvs	0x00697461
    10ec:	5a5f006e 	bpl	17c12ac <__bss_end+0x17b7b68>
    10f0:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
    10f4:	4f495047 	svcmi	0x00495047
    10f8:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
    10fc:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
    1100:	61573431 	cmpvs	r7, r1, lsr r4
    1104:	465f7469 	ldrbmi	r7, [pc], -r9, ror #8
    1108:	455f726f 	ldrbmi	r7, [pc, #-623]	; ea1 <shift+0xea1>
    110c:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
    1110:	49355045 	ldmdbmi	r5!, {r0, r2, r6, ip, lr}
    1114:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    1118:	6353006a 	cmpvs	r3, #106	; 0x6a
    111c:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
    1120:	525f656c 	subspl	r6, pc, #108, 10	; 0x1b000000
    1124:	55410052 	strbpl	r0, [r1, #-82]	; 0xffffffae
    1128:	61425f58 	cmpvs	r2, r8, asr pc
    112c:	42006573 	andmi	r6, r0, #482344960	; 0x1cc00000
    1130:	5f324353 	svcpl	0x00324353
    1134:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
    1138:	69725700 	ldmdbvs	r2!, {r8, r9, sl, ip, lr}^
    113c:	4f5f6574 	svcmi	0x005f6574
    1140:	00796c6e 	rsbseq	r6, r9, lr, ror #24
    1144:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
    1148:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
    114c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    1150:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
    1154:	5f4f4950 	svcpl	0x004f4950
    1158:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
    115c:	3172656c 	cmncc	r2, ip, ror #10
    1160:	6e614830 	mcrvs	8, 3, r4, cr1, cr0, {1}
    1164:	5f656c64 	svcpl	0x00656c64
    1168:	45515249 	ldrbmi	r5, [r1, #-585]	; 0xfffffdb7
    116c:	69540076 	ldmdbvs	r4, {r1, r2, r4, r5, r6}^
    1170:	435f6b63 	cmpmi	pc, #101376	; 0x18c00
    1174:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
    1178:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    117c:	4f433331 	svcmi	0x00433331
    1180:	5f44454c 	svcpl	0x0044454c
    1184:	70736944 	rsbsvc	r6, r3, r4, asr #18
    1188:	3979616c 	ldmdbcc	r9!, {r2, r3, r5, r6, r8, sp, lr}^
    118c:	5f746553 	svcpl	0x00746553
    1190:	65786950 	ldrbvs	r6, [r8, #-2384]!	; 0xfffff6b0
    1194:	7474456c 	ldrbtvc	r4, [r4], #-1388	; 0xfffffa94
    1198:	5a5f0062 	bpl	17c1328 <__bss_end+0x17b7be4>
    119c:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
    11a0:	636f7250 	cmnvs	pc, #80, 4
    11a4:	5f737365 	svcpl	0x00737365
    11a8:	616e614d 	cmnvs	lr, sp, asr #2
    11ac:	31726567 	cmncc	r2, r7, ror #10
    11b0:	6d6e5538 	cfstr64vs	mvdx5, [lr, #-224]!	; 0xffffff20
    11b4:	465f7061 	ldrbmi	r7, [pc], -r1, rrx
    11b8:	5f656c69 	svcpl	0x00656c69
    11bc:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
    11c0:	45746e65 	ldrbmi	r6, [r4, #-3685]!	; 0xfffff19b
    11c4:	6c41006a 	mcrrvs	0, 6, r0, r1, cr10
    11c8:	00305f74 	eorseq	r5, r0, r4, ror pc
    11cc:	6c694649 	stclvs	6, cr4, [r9], #-292	; 0xfffffedc
    11d0:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
    11d4:	5f6d6574 	svcpl	0x006d6574
    11d8:	76697244 	strbtvc	r7, [r9], -r4, asr #4
    11dc:	41007265 	tstmi	r0, r5, ror #4
    11e0:	325f746c 	subscc	r7, pc, #108, 8	; 0x6c000000
    11e4:	746c4100 	strbtvc	r4, [ip], #-256	; 0xffffff00
    11e8:	4100335f 	tstmi	r0, pc, asr r3
    11ec:	345f746c 	ldrbcc	r7, [pc], #-1132	; 11f4 <shift+0x11f4>
    11f0:	746c4100 	strbtvc	r4, [ip], #-256	; 0xffffff00
    11f4:	5f00355f 	svcpl	0x0000355f
    11f8:	31314e5a 	teqcc	r1, sl, asr lr
    11fc:	6c694643 	stclvs	6, cr4, [r9], #-268	; 0xfffffef4
    1200:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
    1204:	316d6574 	smccc	54868	; 0xd654
    1208:	53465433 	movtpl	r5, #25651	; 0x6433
    120c:	6572545f 	ldrbvs	r5, [r2, #-1119]!	; 0xfffffba1
    1210:	6f4e5f65 	svcvs	0x004e5f65
    1214:	30316564 	eorscc	r6, r1, r4, ror #10
    1218:	646e6946 	strbtvs	r6, [lr], #-2374	; 0xfffff6ba
    121c:	6968435f 	stmdbvs	r8!, {r0, r1, r2, r3, r4, r6, r8, r9, lr}^
    1220:	5045646c 	subpl	r6, r5, ip, ror #8
    1224:	4800634b 	stmdami	r0, {r0, r1, r3, r6, r8, r9, sp, lr}
    1228:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
    122c:	69465f65 	stmdbvs	r6, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
    1230:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
    1234:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
    1238:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
    123c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    1240:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
    1244:	4f495047 	svcmi	0x00495047
    1248:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
    124c:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
    1250:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
    1254:	50475f74 	subpl	r5, r7, r4, ror pc
    1258:	5f524c43 	svcpl	0x00524c43
    125c:	61636f4c 	cmnvs	r3, ip, asr #30
    1260:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    1264:	6a526a45 	bvs	149bb80 <__bss_end+0x149243c>
    1268:	005f3053 	subseq	r3, pc, r3, asr r0	; <UNPREDICTABLE>
    126c:	726f6873 	rsbvc	r6, pc, #7536640	; 0x730000
    1270:	6e752074 	mrcvs	0, 3, r2, cr5, cr4, {3}
    1274:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
    1278:	69206465 	stmdbvs	r0!, {r0, r2, r5, r6, sl, sp, lr}
    127c:	6d00746e 	cfstrsvs	mvf7, [r0, #-440]	; 0xfffffe48
    1280:	006e6961 	rsbeq	r6, lr, r1, ror #18
    1284:	70736964 	rsbsvc	r6, r3, r4, ror #18
    1288:	72507300 	subsvc	r7, r0, #0, 6
    128c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1290:	72674d73 	rsbvc	r4, r7, #7360	; 0x1cc0
    1294:	74755000 	ldrbtvc	r5, [r5], #-0
    1298:	7274535f 	rsbsvc	r5, r4, #2080374785	; 0x7c000001
    129c:	00676e69 	rsbeq	r6, r7, r9, ror #28
    12a0:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
    12a4:	61485f4f 	cmpvs	r8, pc, asr #30
    12a8:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
    12ac:	6c410072 	mcrrvs	0, 7, r0, r1, cr2
    12b0:	00315f74 	eorseq	r5, r1, r4, ror pc
    12b4:	6c696863 	stclvs	8, cr6, [r9], #-396	; 0xfffffe74
    12b8:	6e657264 	cdpvs	2, 6, cr7, cr5, cr4, {3}
    12bc:	73694400 	cmnvc	r9, #0, 8
    12c0:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
    12c4:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
    12c8:	445f746e 	ldrbmi	r7, [pc], #-1134	; 12d0 <shift+0x12d0>
    12cc:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
    12d0:	6e490074 	mcrvs	0, 2, r0, cr9, cr4, {3}
    12d4:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
    12d8:	5f747075 	svcpl	0x00747075
    12dc:	746e6f43 	strbtvc	r6, [lr], #-3907	; 0xfffff0bd
    12e0:	6c6c6f72 	stclvs	15, cr6, [ip], #-456	; 0xfffffe38
    12e4:	425f7265 	subsmi	r7, pc, #1342177286	; 0x50000006
    12e8:	00657361 	rsbeq	r7, r5, r1, ror #6
    12ec:	5f534654 	svcpl	0x00534654
    12f0:	76697244 	strbtvc	r7, [r9], -r4, asr #4
    12f4:	52007265 	andpl	r7, r0, #1342177286	; 0x50000006
    12f8:	5f646165 	svcpl	0x00646165
    12fc:	74697257 	strbtvc	r7, [r9], #-599	; 0xfffffda9
    1300:	63410065 	movtvs	r0, #4197	; 0x1065
    1304:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
    1308:	6f72505f 	svcvs	0x0072505f
    130c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1310:	756f435f 	strbvc	r4, [pc, #-863]!	; fb9 <shift+0xfb9>
    1314:	5f00746e 	svcpl	0x0000746e
    1318:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
    131c:	6f725043 	svcvs	0x00725043
    1320:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1324:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    1328:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    132c:	61483132 	cmpvs	r8, r2, lsr r1
    1330:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
    1334:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
    1338:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
    133c:	5f6d6574 	svcpl	0x006d6574
    1340:	45495753 	strbmi	r5, [r9, #-1875]	; 0xfffff8ad
    1344:	534e3332 	movtpl	r3, #58162	; 0xe332
    1348:	465f4957 			; <UNDEFINED> instruction: 0x465f4957
    134c:	73656c69 	cmnvc	r5, #26880	; 0x6900
    1350:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
    1354:	65535f6d 	ldrbvs	r5, [r3, #-3949]	; 0xfffff093
    1358:	63697672 	cmnvs	r9, #119537664	; 0x7200000
    135c:	6a6a6a65 	bvs	1a9bcf8 <__bss_end+0x1a925b4>
    1360:	54313152 	ldrtpl	r3, [r1], #-338	; 0xfffffeae
    1364:	5f495753 	svcpl	0x00495753
    1368:	75736552 	ldrbvc	r6, [r3, #-1362]!	; 0xfffffaae
    136c:	4500746c 	strmi	r7, [r0, #-1132]	; 0xfffffb94
    1370:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
    1374:	76455f65 	strbvc	r5, [r5], -r5, ror #30
    1378:	5f746e65 	svcpl	0x00746e65
    137c:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
    1380:	74007463 	strvc	r7, [r0], #-1123	; 0xfffffb9d
    1384:	5f676e72 	svcpl	0x00676e72
    1388:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
    138c:	6f6c6300 	svcvs	0x006c6300
    1390:	53006573 	movwpl	r6, #1395	; 0x573
    1394:	525f7465 	subspl	r7, pc, #1694498816	; 0x65000000
    1398:	74616c65 	strbtvc	r6, [r1], #-3173	; 0xfffff39b
    139c:	00657669 	rsbeq	r7, r5, r9, ror #12
    13a0:	76746572 			; <UNDEFINED> instruction: 0x76746572
    13a4:	6e006c61 	cdpvs	12, 0, cr6, cr0, cr1, {3}
    13a8:	00727563 	rsbseq	r7, r2, r3, ror #10
    13ac:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    13b0:	6e647200 	cdpvs	2, 6, cr7, cr4, cr0, {0}
    13b4:	5f006d75 	svcpl	0x00006d75
    13b8:	7331315a 	teqvc	r1, #-2147483626	; 0x80000016
    13bc:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    13c0:	6569795f 	strbvs	r7, [r9, #-2399]!	; 0xfffff6a1
    13c4:	0076646c 	rsbseq	r6, r6, ip, ror #8
    13c8:	37315a5f 			; <UNDEFINED> instruction: 0x37315a5f
    13cc:	5f746573 	svcpl	0x00746573
    13d0:	6b736174 	blvs	1cd99a8 <__bss_end+0x1cd0264>
    13d4:	6165645f 	cmnvs	r5, pc, asr r4
    13d8:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
    13dc:	77006a65 	strvc	r6, [r0, -r5, ror #20]
    13e0:	00746961 	rsbseq	r6, r4, r1, ror #18
    13e4:	6e365a5f 			; <UNDEFINED> instruction: 0x6e365a5f
    13e8:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
    13ec:	006a6a79 	rsbeq	r6, sl, r9, ror sl
    13f0:	74395a5f 	ldrtvc	r5, [r9], #-2655	; 0xfffff5a1
    13f4:	696d7265 	stmdbvs	sp!, {r0, r2, r5, r6, r9, ip, sp, lr}^
    13f8:	6574616e 	ldrbvs	r6, [r4, #-366]!	; 0xfffffe92
    13fc:	682f0069 	stmdavs	pc!, {r0, r3, r5, r6}	; <UNPREDICTABLE>
    1400:	2f656d6f 	svccs	0x00656d6f
    1404:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
    1408:	2f6a6b6e 	svccs	0x006a6b6e
    140c:	3032736f 	eorscc	r7, r2, pc, ror #6
    1410:	732f3232 			; <UNDEFINED> instruction: 0x732f3232
    1414:	6f732f70 	svcvs	0x00732f70
    1418:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    141c:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
    1420:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
    1424:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
    1428:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    142c:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
    1430:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
    1434:	69614600 	stmdbvs	r1!, {r9, sl, lr}^
    1438:	7865006c 	stmdavc	r5!, {r2, r3, r5, r6}^
    143c:	6f637469 	svcvs	0x00637469
    1440:	5f006564 	svcpl	0x00006564
    1444:	6734325a 			; <UNDEFINED> instruction: 0x6734325a
    1448:	615f7465 	cmpvs	pc, r5, ror #8
    144c:	76697463 	strbtvc	r7, [r9], -r3, ror #8
    1450:	72705f65 	rsbsvc	r5, r0, #404	; 0x194
    1454:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    1458:	6f635f73 	svcvs	0x00635f73
    145c:	76746e75 			; <UNDEFINED> instruction: 0x76746e75
    1460:	68637300 	stmdavs	r3!, {r8, r9, ip, sp, lr}^
    1464:	795f6465 	ldmdbvc	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
    1468:	646c6569 	strbtvs	r6, [ip], #-1385	; 0xfffffa97
    146c:	63697400 	cmnvs	r9, #0, 8
    1470:	6f635f6b 	svcvs	0x00635f6b
    1474:	5f746e75 	svcpl	0x00746e75
    1478:	75716572 	ldrbvc	r6, [r1, #-1394]!	; 0xfffffa8e
    147c:	64657269 	strbtvs	r7, [r5], #-617	; 0xfffffd97
    1480:	70695000 	rsbvc	r5, r9, r0
    1484:	69465f65 	stmdbvs	r6, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
    1488:	505f656c 	subspl	r6, pc, ip, ror #10
    148c:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    1490:	65530078 	ldrbvs	r0, [r3, #-120]	; 0xffffff88
    1494:	61505f74 	cmpvs	r0, r4, ror pc
    1498:	736d6172 	cmnvc	sp, #-2147483620	; 0x8000001c
    149c:	315a5f00 	cmpcc	sl, r0, lsl #30
    14a0:	74656734 	strbtvc	r6, [r5], #-1844	; 0xfffff8cc
    14a4:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
    14a8:	6f635f6b 	svcvs	0x00635f6b
    14ac:	76746e75 			; <UNDEFINED> instruction: 0x76746e75
    14b0:	656c7300 	strbvs	r7, [ip, #-768]!	; 0xfffffd00
    14b4:	44007065 	strmi	r7, [r0], #-101	; 0xffffff9b
    14b8:	62617369 	rsbvs	r7, r1, #-1543503871	; 0xa4000001
    14bc:	455f656c 	ldrbmi	r6, [pc, #-1388]	; f58 <shift+0xf58>
    14c0:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
    14c4:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
    14c8:	69746365 	ldmdbvs	r4!, {r0, r2, r5, r6, r8, r9, sp, lr}^
    14cc:	2f006e6f 	svccs	0x00006e6f
    14d0:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    14d4:	6863732f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, sp, lr}^
    14d8:	6a6b6e65 	bvs	1adce74 <__bss_end+0x1ad3730>
    14dc:	32736f2f 	rsbscc	r6, r3, #47, 30	; 0xbc
    14e0:	2f323230 	svccs	0x00323230
    14e4:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
    14e8:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    14ec:	622f7365 	eorvs	r7, pc, #-1811939327	; 0x94000001
    14f0:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    14f4:	65706f00 	ldrbvs	r6, [r0, #-3840]!	; 0xfffff100
    14f8:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
    14fc:	5f006e6f 	svcpl	0x00006e6f
    1500:	6c63355a 	cfstr64vs	mvdx3, [r3], #-360	; 0xfffffe98
    1504:	6a65736f 	bvs	195e2c8 <__bss_end+0x1954b84>
    1508:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
    150c:	70746567 	rsbsvc	r6, r4, r7, ror #10
    1510:	00766469 	rsbseq	r6, r6, r9, ror #8
    1514:	6d616e66 	stclvs	14, cr6, [r1, #-408]!	; 0xfffffe68
    1518:	6f6e0065 	svcvs	0x006e0065
    151c:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
    1520:	63697400 	cmnvs	r9, #0, 8
    1524:	6f00736b 	svcvs	0x0000736b
    1528:	006e6570 	rsbeq	r6, lr, r0, ror r5
    152c:	70345a5f 	eorsvc	r5, r4, pc, asr sl
    1530:	50657069 	rsbpl	r7, r5, r9, rrx
    1534:	006a634b 	rsbeq	r6, sl, fp, asr #6
    1538:	6165444e 	cmnvs	r5, lr, asr #8
    153c:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
    1540:	75535f65 	ldrbvc	r5, [r3, #-3941]	; 0xfffff09b
    1544:	72657362 	rsbvc	r7, r5, #-2013265919	; 0x88000001
    1548:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
    154c:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
    1550:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
    1554:	6f635f6b 	svcvs	0x00635f6b
    1558:	00746e75 	rsbseq	r6, r4, r5, ror lr
    155c:	61726170 	cmnvs	r2, r0, ror r1
    1560:	5a5f006d 	bpl	17c171c <__bss_end+0x17b7fd8>
    1564:	69727735 	ldmdbvs	r2!, {r0, r2, r4, r5, r8, r9, sl, ip, sp, lr}^
    1568:	506a6574 	rsbpl	r6, sl, r4, ror r5
    156c:	006a634b 	rsbeq	r6, sl, fp, asr #6
    1570:	5f746567 	svcpl	0x00746567
    1574:	6b736174 	blvs	1cd9b4c <__bss_end+0x1cd0408>
    1578:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
    157c:	745f736b 	ldrbvc	r7, [pc], #-875	; 1584 <shift+0x1584>
    1580:	65645f6f 	strbvs	r5, [r4, #-3951]!	; 0xfffff091
    1584:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
    1588:	6200656e 	andvs	r6, r0, #461373440	; 0x1b800000
    158c:	735f6675 	cmpvc	pc, #122683392	; 0x7500000
    1590:	00657a69 	rsbeq	r7, r5, r9, ror #20
    1594:	74697277 	strbtvc	r7, [r9], #-631	; 0xfffffd89
    1598:	65730065 	ldrbvs	r0, [r3, #-101]!	; 0xffffff9b
    159c:	61745f74 	cmnvs	r4, r4, ror pc
    15a0:	645f6b73 	ldrbvs	r6, [pc], #-2931	; 15a8 <shift+0x15a8>
    15a4:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
    15a8:	00656e69 	rsbeq	r6, r5, r9, ror #28
    15ac:	5f746547 	svcpl	0x00746547
    15b0:	61726150 	cmnvs	r2, r0, asr r1
    15b4:	5f00736d 	svcpl	0x0000736d
    15b8:	6c73355a 	cfldr64vs	mvdx3, [r3], #-360	; 0xfffffe98
    15bc:	6a706565 	bvs	1c1ab58 <__bss_end+0x1c11414>
    15c0:	6547006a 	strbvs	r0, [r7, #-106]	; 0xffffff96
    15c4:	65525f74 	ldrbvs	r5, [r2, #-3956]	; 0xfffff08c
    15c8:	6e69616d 	powvsez	f6, f1, #5.0
    15cc:	00676e69 	rsbeq	r6, r7, r9, ror #28
    15d0:	62616e45 	rsbvs	r6, r1, #1104	; 0x450
    15d4:	455f656c 	ldrbmi	r6, [pc, #-1388]	; 1070 <shift+0x1070>
    15d8:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
    15dc:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
    15e0:	69746365 	ldmdbvs	r4!, {r0, r2, r5, r6, r8, r9, sp, lr}^
    15e4:	5f006e6f 	svcpl	0x00006e6f
    15e8:	6736325a 			; <UNDEFINED> instruction: 0x6736325a
    15ec:	745f7465 	ldrbvc	r7, [pc], #-1125	; 15f4 <shift+0x15f4>
    15f0:	5f6b7361 	svcpl	0x006b7361
    15f4:	6b636974 	blvs	18dbbcc <__bss_end+0x18d2488>
    15f8:	6f745f73 	svcvs	0x00745f73
    15fc:	6165645f 	cmnvs	r5, pc, asr r4
    1600:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
    1604:	4e007665 	cfmadd32mi	mvax3, mvfx7, mvfx0, mvfx5
    1608:	5f495753 	svcpl	0x00495753
    160c:	75736552 	ldrbvc	r6, [r3, #-1362]!	; 0xfffffaae
    1610:	435f746c 	cmpmi	pc, #108, 8	; 0x6c000000
    1614:	0065646f 	rsbeq	r6, r5, pc, ror #8
    1618:	756e7277 	strbvc	r7, [lr, #-631]!	; 0xfffffd89
    161c:	5a5f006d 	bpl	17c17d8 <__bss_end+0x17b8094>
    1620:	69617734 	stmdbvs	r1!, {r2, r4, r5, r8, r9, sl, ip, sp, lr}^
    1624:	6a6a6a74 	bvs	1a9bffc <__bss_end+0x1a928b8>
    1628:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    162c:	74636f69 	strbtvc	r6, [r3], #-3945	; 0xfffff097
    1630:	36316a6c 	ldrtcc	r6, [r1], -ip, ror #20
    1634:	434f494e 	movtmi	r4, #63822	; 0xf94e
    1638:	4f5f6c74 	svcmi	0x005f6c74
    163c:	61726570 	cmnvs	r2, r0, ror r5
    1640:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    1644:	69007650 	stmdbvs	r0, {r4, r6, r9, sl, ip, sp, lr}
    1648:	6c74636f 	ldclvs	3, cr6, [r4], #-444	; 0xfffffe44
    164c:	74657200 	strbtvc	r7, [r5], #-512	; 0xfffffe00
    1650:	00746e63 	rsbseq	r6, r4, r3, ror #28
    1654:	6d726574 	cfldr64vs	mvdx6, [r2, #-464]!	; 0xfffffe30
    1658:	74616e69 	strbtvc	r6, [r1], #-3689	; 0xfffff197
    165c:	6f6d0065 	svcvs	0x006d0065
    1660:	62006564 	andvs	r6, r0, #100, 10	; 0x19000000
    1664:	65666675 	strbvs	r6, [r6, #-1653]!	; 0xfffff98b
    1668:	5a5f0072 	bpl	17c1838 <__bss_end+0x17b80f4>
    166c:	61657234 	cmnvs	r5, r4, lsr r2
    1670:	63506a64 	cmpvs	r0, #100, 20	; 0x64000
    1674:	494e006a 	stmdbmi	lr, {r1, r3, r5, r6}^
    1678:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
    167c:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
    1680:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
    1684:	72006e6f 	andvc	r6, r0, #1776	; 0x6f0
    1688:	6f637465 	svcvs	0x00637465
    168c:	67006564 	strvs	r6, [r0, -r4, ror #10]
    1690:	615f7465 	cmpvs	pc, r5, ror #8
    1694:	76697463 	strbtvc	r7, [r9], -r3, ror #8
    1698:	72705f65 	rsbsvc	r5, r0, #404	; 0x194
    169c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    16a0:	6f635f73 	svcvs	0x00635f73
    16a4:	00746e75 	rsbseq	r6, r4, r5, ror lr
    16a8:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
    16ac:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
    16b0:	61657200 	cmnvs	r5, r0, lsl #4
    16b4:	65670064 	strbvs	r0, [r7, #-100]!	; 0xffffff9c
    16b8:	64697074 	strbtvs	r7, [r9], #-116	; 0xffffff8c
    16bc:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    16c0:	6e65706f 	cdpvs	0, 6, cr7, cr5, cr15, {3}
    16c4:	31634b50 	cmncc	r3, r0, asr fp
    16c8:	69464e35 	stmdbvs	r6, {r0, r2, r4, r5, r9, sl, fp, lr}^
    16cc:	4f5f656c 	svcmi	0x005f656c
    16d0:	5f6e6570 	svcpl	0x006e6570
    16d4:	65646f4d 	strbvs	r6, [r4, #-3917]!	; 0xfffff0b3
    16d8:	554e4700 	strbpl	r4, [lr, #-1792]	; 0xfffff900
    16dc:	2b2b4320 	blcs	ad2364 <__bss_end+0xac8c20>
    16e0:	39203431 	stmdbcc	r0!, {r0, r4, r5, sl, ip, sp}
    16e4:	312e322e 			; <UNDEFINED> instruction: 0x312e322e
    16e8:	31303220 	teqcc	r0, r0, lsr #4
    16ec:	32303139 	eorscc	r3, r0, #1073741838	; 0x4000000e
    16f0:	72282035 	eorvc	r2, r8, #53	; 0x35
    16f4:	61656c65 	cmnvs	r5, r5, ror #24
    16f8:	20296573 	eorcs	r6, r9, r3, ror r5
    16fc:	4d52415b 	ldfmie	f4, [r2, #-364]	; 0xfffffe94
    1700:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    1704:	622d392d 	eorvs	r3, sp, #737280	; 0xb4000
    1708:	636e6172 	cmnvs	lr, #-2147483620	; 0x8000001c
    170c:	65722068 	ldrbvs	r2, [r2, #-104]!	; 0xffffff98
    1710:	69736976 	ldmdbvs	r3!, {r1, r2, r4, r5, r6, r8, fp, sp, lr}^
    1714:	32206e6f 	eorcc	r6, r0, #1776	; 0x6f0
    1718:	39353737 	ldmdbcc	r5!, {r0, r1, r2, r4, r5, r8, r9, sl, ip, sp}
    171c:	2d205d39 	stccs	13, cr5, [r0, #-228]!	; 0xffffff1c
    1720:	6f6c666d 	svcvs	0x006c666d
    1724:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
    1728:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
    172c:	20647261 	rsbcs	r7, r4, r1, ror #4
    1730:	70666d2d 	rsbvc	r6, r6, sp, lsr #26
    1734:	66763d75 			; <UNDEFINED> instruction: 0x66763d75
    1738:	6d2d2070 	stcvs	0, cr2, [sp, #-448]!	; 0xfffffe40
    173c:	616f6c66 	cmnvs	pc, r6, ror #24
    1740:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
    1744:	61683d69 	cmnvs	r8, r9, ror #26
    1748:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
    174c:	7570666d 	ldrbvc	r6, [r0, #-1645]!	; 0xfffff993
    1750:	7066763d 	rsbvc	r7, r6, sp, lsr r6
    1754:	746d2d20 	strbtvc	r2, [sp], #-3360	; 0xfffff2e0
    1758:	3d656e75 	stclcc	14, cr6, [r5, #-468]!	; 0xfffffe2c
    175c:	316d7261 	cmncc	sp, r1, ror #4
    1760:	6a363731 	bvs	d8f42c <__bss_end+0xd85ce8>
    1764:	732d667a 			; <UNDEFINED> instruction: 0x732d667a
    1768:	616d2d20 	cmnvs	sp, r0, lsr #26
    176c:	2d206d72 	stccs	13, cr6, [r0, #-456]!	; 0xfffffe38
    1770:	6372616d 	cmnvs	r2, #1073741851	; 0x4000001b
    1774:	72613d68 	rsbvc	r3, r1, #104, 26	; 0x1a00
    1778:	7a36766d 	bvc	d9f134 <__bss_end+0xd959f0>
    177c:	70662b6b 	rsbvc	r2, r6, fp, ror #22
    1780:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    1784:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    1788:	4f2d2067 	svcmi	0x002d2067
    178c:	4f2d2030 	svcmi	0x002d2030
    1790:	662d2030 			; <UNDEFINED> instruction: 0x662d2030
    1794:	652d6f6e 	strvs	r6, [sp, #-3950]!	; 0xfffff092
    1798:	70656378 	rsbvc	r6, r5, r8, ror r3
    179c:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    17a0:	662d2073 			; <UNDEFINED> instruction: 0x662d2073
    17a4:	722d6f6e 	eorvc	r6, sp, #440	; 0x1b8
    17a8:	00697474 	rsbeq	r7, r9, r4, ror r4
    17ac:	75706e69 	ldrbvc	r6, [r0, #-3689]!	; 0xfffff197
    17b0:	65640074 	strbvs	r0, [r4, #-116]!	; 0xffffff8c
    17b4:	62007473 	andvs	r7, r0, #1929379840	; 0x73000000
    17b8:	6f72657a 	svcvs	0x0072657a
    17bc:	6e656c00 	cdpvs	12, 6, cr6, cr5, cr0, {0}
    17c0:	00687467 	rsbeq	r7, r8, r7, ror #8
    17c4:	62355a5f 	eorsvs	r5, r5, #389120	; 0x5f000
    17c8:	6f72657a 	svcvs	0x0072657a
    17cc:	00697650 	rsbeq	r7, r9, r0, asr r6
    17d0:	61345a5f 	teqvs	r4, pc, asr sl
    17d4:	50696f74 	rsbpl	r6, r9, r4, ror pc
    17d8:	2f00634b 	svccs	0x0000634b
    17dc:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    17e0:	6863732f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, sp, lr}^
    17e4:	6a6b6e65 	bvs	1add180 <__bss_end+0x1ad3a3c>
    17e8:	32736f2f 	rsbscc	r6, r3, #47, 30	; 0xbc
    17ec:	2f323230 	svccs	0x00323230
    17f0:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
    17f4:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    17f8:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
    17fc:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
    1800:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
    1804:	74732f63 	ldrbtvc	r2, [r3], #-3939	; 0xfffff09d
    1808:	72747364 	rsbsvc	r7, r4, #100, 6	; 0x90000001
    180c:	2e676e69 	cdpcs	14, 6, cr6, cr7, cr9, {3}
    1810:	00707063 	rsbseq	r7, r0, r3, rrx
    1814:	72616843 	rsbvc	r6, r1, #4390912	; 0x430000
    1818:	766e6f43 	strbtvc	r6, [lr], -r3, asr #30
    181c:	00727241 	rsbseq	r7, r2, r1, asr #4
    1820:	646d656d 	strbtvs	r6, [sp], #-1389	; 0xfffffa93
    1824:	6f007473 	svcvs	0x00007473
    1828:	75707475 	ldrbvc	r7, [r0, #-1141]!	; 0xfffffb8b
    182c:	5a5f0074 	bpl	17c1a04 <__bss_end+0x17b82c0>
    1830:	6d656d36 	stclvs	13, cr6, [r5, #-216]!	; 0xffffff28
    1834:	50797063 	rsbspl	r7, r9, r3, rrx
    1838:	7650764b 	ldrbvc	r7, [r0], -fp, asr #12
    183c:	61620069 	cmnvs	r2, r9, rrx
    1840:	6d006573 	cfstr32vs	mvfx6, [r0, #-460]	; 0xfffffe34
    1844:	70636d65 	rsbvc	r6, r3, r5, ror #26
    1848:	74730079 	ldrbtvc	r0, [r3], #-121	; 0xffffff87
    184c:	6e656c72 	mcrvs	12, 3, r6, cr5, cr2, {3}
    1850:	375a5f00 	ldrbcc	r5, [sl, -r0, lsl #30]
    1854:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
    1858:	50706d63 	rsbspl	r6, r0, r3, ror #26
    185c:	3053634b 	subscc	r6, r3, fp, asr #6
    1860:	5f00695f 	svcpl	0x0000695f
    1864:	7473365a 	ldrbtvc	r3, [r3], #-1626	; 0xfffff9a6
    1868:	6e656c72 	mcrvs	12, 3, r6, cr5, cr2, {3}
    186c:	00634b50 	rsbeq	r4, r3, r0, asr fp
    1870:	696f7461 	stmdbvs	pc!, {r0, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
    1874:	375a5f00 	ldrbcc	r5, [sl, -r0, lsl #30]
    1878:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
    187c:	50797063 	rsbspl	r7, r9, r3, rrx
    1880:	634b5063 	movtvs	r5, #45155	; 0xb063
    1884:	74730069 	ldrbtvc	r0, [r3], #-105	; 0xffffff97
    1888:	6d636e72 	stclvs	14, cr6, [r3, #-456]!	; 0xfffffe38
    188c:	74730070 	ldrbtvc	r0, [r3], #-112	; 0xffffff90
    1890:	70636e72 	rsbvc	r6, r3, r2, ror lr
    1894:	656d0079 	strbvs	r0, [sp, #-121]!	; 0xffffff87
    1898:	79726f6d 	ldmdbvc	r2!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    189c:	6d656d00 	stclvs	13, cr6, [r5, #-0]
    18a0:	00637273 	rsbeq	r7, r3, r3, ror r2
    18a4:	616f7469 	cmnvs	pc, r9, ror #8
    18a8:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    18ac:	616f7469 	cmnvs	pc, r9, ror #8
    18b0:	6a63506a 	bvs	18d5a60 <__bss_end+0x18cc31c>
    18b4:	6f682f00 	svcvs	0x00682f00
    18b8:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
    18bc:	6e656863 	cdpvs	8, 6, cr6, cr5, cr3, {3}
    18c0:	6f2f6a6b 	svcvs	0x002f6a6b
    18c4:	32303273 	eorscc	r3, r0, #805306375	; 0x30000007
    18c8:	70732f32 	rsbsvc	r2, r3, r2, lsr pc
    18cc:	756f732f 	strbvc	r7, [pc, #-815]!	; 15a5 <shift+0x15a5>
    18d0:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
    18d4:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    18d8:	6c697475 	cfstrdvs	mvd7, [r9], #-468	; 0xfffffe2c
    18dc:	72732f73 	rsbsvc	r2, r3, #460	; 0x1cc
    18e0:	6c6f2f63 	stclvs	15, cr2, [pc], #-396	; 175c <shift+0x175c>
    18e4:	632e6465 			; <UNDEFINED> instruction: 0x632e6465
    18e8:	5f007070 	svcpl	0x00007070
    18ec:	5f6e695f 	svcpl	0x006e695f
    18f0:	67726863 	ldrbvs	r6, [r2, -r3, ror #16]!
    18f4:	69445400 	stmdbvs	r4, {sl, ip, lr}^
    18f8:	616c7073 	smcvs	50947	; 0xc703
    18fc:	61505f79 	cmpvs	r0, r9, ror pc
    1900:	74656b63 	strbtvc	r6, [r5], #-2915	; 0xfffff49d
    1904:	6165485f 	cmnvs	r5, pc, asr r8
    1908:	00726564 	rsbseq	r6, r2, r4, ror #10
    190c:	73694454 	cmnvc	r9, #84, 8	; 0x54000000
    1910:	79616c70 	stmdbvc	r1!, {r4, r5, r6, sl, fp, sp, lr}^
    1914:	6e6f4e5f 	mcrvs	14, 3, r4, cr15, cr15, {2}
    1918:	61726150 	cmnvs	r2, r0, asr r1
    191c:	7274656d 	rsbsvc	r6, r4, #457179136	; 0x1b400000
    1920:	505f6369 	subspl	r6, pc, r9, ror #6
    1924:	656b6361 	strbvs	r6, [fp, #-865]!	; 0xfffffc9f
    1928:	68740074 	ldmdavs	r4!, {r2, r4, r5, r6}^
    192c:	4f007369 	svcmi	0x00007369
    1930:	5f44454c 	svcpl	0x0044454c
    1934:	746e6f46 	strbtvc	r6, [lr], #-3910	; 0xfffff0ba
    1938:	6665445f 			; <UNDEFINED> instruction: 0x6665445f
    193c:	746c7561 	strbtvc	r7, [ip], #-1377	; 0xfffffa9f
    1940:	6c667600 	stclvs	6, cr7, [r6], #-0
    1944:	54007069 	strpl	r7, [r0], #-105	; 0xffffff97
    1948:	70736944 	rsbsvc	r6, r3, r4, asr #18
    194c:	5f79616c 	svcpl	0x0079616c
    1950:	77617244 	strbvc	r7, [r1, -r4, asr #4]!
    1954:	7869505f 	stmdavc	r9!, {r0, r1, r2, r3, r4, r6, ip, lr}^
    1958:	415f6c65 	cmpmi	pc, r5, ror #24
    195c:	79617272 	stmdbvc	r1!, {r1, r4, r5, r6, r9, ip, sp, lr}^
    1960:	6361505f 	cmnvs	r1, #95	; 0x5f
    1964:	0074656b 	rsbseq	r6, r4, fp, ror #10
    1968:	77617244 	strbvc	r7, [r1, -r4, asr #4]!
    196c:	7869505f 	stmdavc	r9!, {r0, r1, r2, r3, r4, r6, ip, lr}^
    1970:	415f6c65 	cmpmi	pc, r5, ror #24
    1974:	79617272 	stmdbvc	r1!, {r1, r4, r5, r6, r9, ip, sp, lr}^
    1978:	5f6f545f 	svcpl	0x006f545f
    197c:	74636552 	strbtvc	r6, [r3], #-1362	; 0xfffffaae
    1980:	69445400 	stmdbvs	r4, {sl, ip, lr}^
    1984:	616c7073 	smcvs	50947	; 0xc703
    1988:	69505f79 	ldmdbvs	r0, {r0, r3, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    198c:	5f6c6578 	svcpl	0x006c6578
    1990:	63657053 	cmnvs	r5, #83	; 0x53
    1994:	74617000 	strbtvc	r7, [r1], #-0
    1998:	44540068 	ldrbmi	r0, [r4], #-104	; 0xffffff98
    199c:	6c707369 	ldclvs	3, cr7, [r0], #-420	; 0xfffffe5c
    19a0:	505f7961 	subspl	r7, pc, r1, ror #18
    19a4:	6c657869 	stclvs	8, cr7, [r5], #-420	; 0xfffffe5c
    19a8:	6f545f73 	svcvs	0x00545f73
    19ac:	6365525f 	cmnvs	r5, #-268435451	; 0xf0000005
    19b0:	68430074 	stmdavs	r3, {r2, r4, r5, r6}^
    19b4:	455f7261 	ldrbmi	r7, [pc, #-609]	; 175b <shift+0x175b>
    19b8:	4600646e 	strmi	r6, [r0], -lr, ror #8
    19bc:	5f70696c 	svcpl	0x0070696c
    19c0:	72616843 	rsbvc	r6, r1, #4390912	; 0x430000
    19c4:	44540073 	ldrbmi	r0, [r4], #-115	; 0xffffff8d
    19c8:	6c707369 	ldclvs	3, cr7, [r0], #-420	; 0xfffffe5c
    19cc:	435f7961 	cmpmi	pc, #1589248	; 0x184000
    19d0:	7261656c 	rsbvc	r6, r1, #108, 10	; 0x1b000000
    19d4:	6361505f 	cmnvs	r1, #95	; 0x5f
    19d8:	0074656b 	rsbseq	r6, r4, fp, ror #10
    19dc:	72616843 	rsbvc	r6, r1, #4390912	; 0x430000
    19e0:	6469575f 	strbtvs	r5, [r9], #-1887	; 0xfffff8a1
    19e4:	4f006874 	svcmi	0x00006874
    19e8:	5f44454c 	svcpl	0x0044454c
    19ec:	746e6f46 	strbtvc	r6, [lr], #-3910	; 0xfffff0ba
    19f0:	69444e00 	stmdbvs	r4, {r9, sl, fp, lr}^
    19f4:	616c7073 	smcvs	50947	; 0xc703
    19f8:	6f435f79 	svcvs	0x00435f79
    19fc:	6e616d6d 	cdpvs	13, 6, cr6, cr1, cr13, {3}
    1a00:	69660064 	stmdbvs	r6!, {r2, r5, r6}^
    1a04:	00747372 	rsbseq	r7, r4, r2, ror r3
    1a08:	77617244 	strbvc	r7, [r1, -r4, asr #4]!
    1a0c:	7869505f 	stmdavc	r9!, {r0, r1, r2, r3, r4, r6, ip, lr}^
    1a10:	415f6c65 	cmpmi	pc, r5, ror #24
    1a14:	79617272 	stmdbvc	r1!, {r1, r4, r5, r6, r9, ip, sp, lr}^
    1a18:	656c6300 	strbvs	r6, [ip, #-768]!	; 0xfffffd00
    1a1c:	65537261 	ldrbvs	r7, [r3, #-609]	; 0xfffffd9f
    1a20:	5a5f0074 	bpl	17c1bf8 <__bss_end+0x17b84b4>
    1a24:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
    1a28:	44454c4f 	strbmi	r4, [r5], #-3151	; 0xfffff3b1
    1a2c:	7369445f 	cmnvc	r9, #1593835520	; 0x5f000000
    1a30:	79616c70 	stmdbvc	r1!, {r4, r5, r6, sl, fp, sp, lr}^
    1a34:	50453243 	subpl	r3, r5, r3, asr #4
    1a38:	7500634b 	strvc	r6, [r0, #-843]	; 0xfffffcb5
    1a3c:	38746e69 	ldmdacc	r4!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
    1a40:	4300745f 	movwmi	r7, #1119	; 0x45f
    1a44:	5f726168 	svcpl	0x00726168
    1a48:	67696548 	strbvs	r6, [r9, -r8, asr #10]!
    1a4c:	68007468 	stmdavs	r0, {r3, r5, r6, sl, ip, sp, lr}
    1a50:	65646165 	strbvs	r6, [r4, #-357]!	; 0xfffffe9b
    1a54:	68430072 	stmdavs	r3, {r1, r4, r5, r6}^
    1a58:	425f7261 	subsmi	r7, pc, #268435462	; 0x10000006
    1a5c:	6e696765 	cdpvs	7, 6, cr6, cr9, cr5, {3}
    1a60:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    1a64:	4f433331 	svcmi	0x00433331
    1a68:	5f44454c 	svcpl	0x0044454c
    1a6c:	70736944 	rsbsvc	r6, r3, r4, asr #18
    1a70:	4479616c 	ldrbtmi	r6, [r9], #-364	; 0xfffffe94
    1a74:	00764532 	rsbseq	r4, r6, r2, lsr r5
    1a78:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1a7c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1a80:	2f2e2e2f 	svccs	0x002e2e2f
    1a84:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1a88:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    1a8c:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1a90:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
    1a94:	2f676966 	svccs	0x00676966
    1a98:	2f6d7261 	svccs	0x006d7261
    1a9c:	3162696c 	cmncc	r2, ip, ror #18
    1aa0:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
    1aa4:	00532e73 	subseq	r2, r3, r3, ror lr
    1aa8:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
    1aac:	672f646c 	strvs	r6, [pc, -ip, ror #8]!
    1ab0:	612d6363 			; <UNDEFINED> instruction: 0x612d6363
    1ab4:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
    1ab8:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
    1abc:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    1ac0:	396c472d 	stmdbcc	ip!, {r0, r2, r3, r5, r8, r9, sl, lr}^
    1ac4:	2f39546b 	svccs	0x0039546b
    1ac8:	2d636367 	stclcs	3, cr6, [r3, #-412]!	; 0xfffffe64
    1acc:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    1ad0:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    1ad4:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    1ad8:	2d392d69 	ldccs	13, cr2, [r9, #-420]!	; 0xfffffe5c
    1adc:	39313032 	ldmdbcc	r1!, {r1, r4, r5, ip, sp}
    1ae0:	2f34712d 	svccs	0x0034712d
    1ae4:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    1ae8:	72612f64 	rsbvc	r2, r1, #100, 30	; 0x190
    1aec:	6f6e2d6d 	svcvs	0x006e2d6d
    1af0:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
    1af4:	2f696261 	svccs	0x00696261
    1af8:	2f6d7261 	svccs	0x006d7261
    1afc:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
    1b00:	7261682f 	rsbvc	r6, r1, #3080192	; 0x2f0000
    1b04:	696c2f64 	stmdbvs	ip!, {r2, r5, r6, r8, r9, sl, fp, sp}^
    1b08:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1b0c:	52415400 	subpl	r5, r1, #0, 8
    1b10:	5f544547 	svcpl	0x00544547
    1b14:	5f555043 	svcpl	0x00555043
    1b18:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1b1c:	31617865 	cmncc	r1, r5, ror #16
    1b20:	726f6337 	rsbvc	r6, pc, #-603979776	; 0xdc000000
    1b24:	61786574 	cmnvs	r8, r4, ror r5
    1b28:	73690037 	cmnvc	r9, #55	; 0x37
    1b2c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1b30:	70665f74 	rsbvc	r5, r6, r4, ror pc
    1b34:	6c62645f 	cfstrdvs	mvd6, [r2], #-380	; 0xfffffe84
    1b38:	6d726100 	ldfvse	f6, [r2, #-0]
    1b3c:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1b40:	77695f68 	strbvc	r5, [r9, -r8, ror #30]!
    1b44:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    1b48:	52415400 	subpl	r5, r1, #0, 8
    1b4c:	5f544547 	svcpl	0x00544547
    1b50:	5f555043 	svcpl	0x00555043
    1b54:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1b58:	326d7865 	rsbcc	r7, sp, #6619136	; 0x650000
    1b5c:	52410033 	subpl	r0, r1, #51	; 0x33
    1b60:	51455f4d 	cmppl	r5, sp, asr #30
    1b64:	52415400 	subpl	r5, r1, #0, 8
    1b68:	5f544547 	svcpl	0x00544547
    1b6c:	5f555043 	svcpl	0x00555043
    1b70:	316d7261 	cmncc	sp, r1, ror #4
    1b74:	74363531 	ldrtvc	r3, [r6], #-1329	; 0xfffffacf
    1b78:	00736632 	rsbseq	r6, r3, r2, lsr r6
    1b7c:	5f617369 	svcpl	0x00617369
    1b80:	5f746962 	svcpl	0x00746962
    1b84:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    1b88:	41540062 	cmpmi	r4, r2, rrx
    1b8c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1b90:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1b94:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1b98:	61786574 	cmnvs	r8, r4, ror r5
    1b9c:	6f633735 	svcvs	0x00633735
    1ba0:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1ba4:	00333561 	eorseq	r3, r3, r1, ror #10
    1ba8:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1bac:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1bb0:	4d385f48 	ldcmi	15, cr5, [r8, #-288]!	; 0xfffffee0
    1bb4:	5341425f 	movtpl	r4, #4703	; 0x125f
    1bb8:	41540045 	cmpmi	r4, r5, asr #32
    1bbc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1bc0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1bc4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1bc8:	00303138 	eorseq	r3, r0, r8, lsr r1
    1bcc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1bd0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1bd4:	785f5550 	ldmdavc	pc, {r4, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
    1bd8:	656e6567 	strbvs	r6, [lr, #-1383]!	; 0xfffffa99
    1bdc:	52410031 	subpl	r0, r1, #49	; 0x31
    1be0:	43505f4d 	cmpmi	r0, #308	; 0x134
    1be4:	41415f53 	cmpmi	r1, r3, asr pc
    1be8:	5f534350 	svcpl	0x00534350
    1bec:	4d4d5749 	stclmi	7, cr5, [sp, #-292]	; 0xfffffedc
    1bf0:	42005458 	andmi	r5, r0, #88, 8	; 0x58000000
    1bf4:	5f455341 	svcpl	0x00455341
    1bf8:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1bfc:	4200305f 	andmi	r3, r0, #95	; 0x5f
    1c00:	5f455341 	svcpl	0x00455341
    1c04:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1c08:	4200325f 	andmi	r3, r0, #-268435451	; 0xf0000005
    1c0c:	5f455341 	svcpl	0x00455341
    1c10:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1c14:	4200335f 	andmi	r3, r0, #2080374785	; 0x7c000001
    1c18:	5f455341 	svcpl	0x00455341
    1c1c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1c20:	4200345f 	andmi	r3, r0, #1593835520	; 0x5f000000
    1c24:	5f455341 	svcpl	0x00455341
    1c28:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1c2c:	4200365f 	andmi	r3, r0, #99614720	; 0x5f00000
    1c30:	5f455341 	svcpl	0x00455341
    1c34:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1c38:	5400375f 	strpl	r3, [r0], #-1887	; 0xfffff8a1
    1c3c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1c40:	50435f54 	subpl	r5, r3, r4, asr pc
    1c44:	73785f55 	cmnvc	r8, #340	; 0x154
    1c48:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    1c4c:	61736900 	cmnvs	r3, r0, lsl #18
    1c50:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1c54:	6572705f 	ldrbvs	r7, [r2, #-95]!	; 0xffffffa1
    1c58:	73657264 	cmnvc	r5, #100, 4	; 0x40000006
    1c5c:	52415400 	subpl	r5, r1, #0, 8
    1c60:	5f544547 	svcpl	0x00544547
    1c64:	5f555043 	svcpl	0x00555043
    1c68:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1c6c:	336d7865 	cmncc	sp, #6619136	; 0x650000
    1c70:	41540033 	cmpmi	r4, r3, lsr r0
    1c74:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1c78:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1c7c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1c80:	6d647437 	cfstrdvs	mvd7, [r4, #-220]!	; 0xffffff24
    1c84:	73690069 	cmnvc	r9, #105	; 0x69
    1c88:	6f6e5f61 	svcvs	0x006e5f61
    1c8c:	00746962 	rsbseq	r6, r4, r2, ror #18
    1c90:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1c94:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1c98:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1c9c:	31316d72 	teqcc	r1, r2, ror sp
    1ca0:	7a6a3637 	bvc	1a8f584 <__bss_end+0x1a85e40>
    1ca4:	69007366 	stmdbvs	r0, {r1, r2, r5, r6, r8, r9, ip, sp, lr}
    1ca8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1cac:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    1cb0:	32767066 	rsbscc	r7, r6, #102	; 0x66
    1cb4:	4d524100 	ldfmie	f4, [r2, #-0]
    1cb8:	5343505f 	movtpl	r5, #12383	; 0x305f
    1cbc:	4b4e555f 	blmi	1397240 <__bss_end+0x138dafc>
    1cc0:	4e574f4e 	cdpmi	15, 5, cr4, cr7, cr14, {2}
    1cc4:	52415400 	subpl	r5, r1, #0, 8
    1cc8:	5f544547 	svcpl	0x00544547
    1ccc:	5f555043 	svcpl	0x00555043
    1cd0:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    1cd4:	41420065 	cmpmi	r2, r5, rrx
    1cd8:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1cdc:	5f484352 	svcpl	0x00484352
    1ce0:	4a455435 	bmi	1156dbc <__bss_end+0x114d678>
    1ce4:	6d726100 	ldfvse	f6, [r2, #-0]
    1ce8:	6663635f 			; <UNDEFINED> instruction: 0x6663635f
    1cec:	735f6d73 	cmpvc	pc, #7360	; 0x1cc0
    1cf0:	65746174 	ldrbvs	r6, [r4, #-372]!	; 0xfffffe8c
    1cf4:	6d726100 	ldfvse	f6, [r2, #-0]
    1cf8:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1cfc:	65743568 	ldrbvs	r3, [r4, #-1384]!	; 0xfffffa98
    1d00:	736e7500 	cmnvc	lr, #0, 10
    1d04:	5f636570 	svcpl	0x00636570
    1d08:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    1d0c:	0073676e 	rsbseq	r6, r3, lr, ror #14
    1d10:	5f617369 	svcpl	0x00617369
    1d14:	5f746962 	svcpl	0x00746962
    1d18:	00636573 	rsbeq	r6, r3, r3, ror r5
    1d1c:	6c635f5f 	stclvs	15, cr5, [r3], #-380	; 0xfffffe84
    1d20:	61745f7a 	cmnvs	r4, sl, ror pc
    1d24:	52410062 	subpl	r0, r1, #98	; 0x62
    1d28:	43565f4d 	cmpmi	r6, #308	; 0x134
    1d2c:	6d726100 	ldfvse	f6, [r2, #-0]
    1d30:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1d34:	73785f68 	cmnvc	r8, #104, 30	; 0x1a0
    1d38:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    1d3c:	4d524100 	ldfmie	f4, [r2, #-0]
    1d40:	00454c5f 	subeq	r4, r5, pc, asr ip
    1d44:	5f4d5241 	svcpl	0x004d5241
    1d48:	41005356 	tstmi	r0, r6, asr r3
    1d4c:	475f4d52 			; <UNDEFINED> instruction: 0x475f4d52
    1d50:	72610045 	rsbvc	r0, r1, #69	; 0x45
    1d54:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    1d58:	735f656e 	cmpvc	pc, #461373440	; 0x1b800000
    1d5c:	6e6f7274 	mcrvs	2, 3, r7, cr15, cr4, {3}
    1d60:	6d726167 	ldfvse	f6, [r2, #-412]!	; 0xfffffe64
    1d64:	6d6f6300 	stclvs	3, cr6, [pc, #-0]	; 1d6c <shift+0x1d6c>
    1d68:	78656c70 	stmdavc	r5!, {r4, r5, r6, sl, fp, sp, lr}^
    1d6c:	6f6c6620 	svcvs	0x006c6620
    1d70:	54007461 	strpl	r7, [r0], #-1121	; 0xfffffb9f
    1d74:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1d78:	50435f54 	subpl	r5, r3, r4, asr pc
    1d7c:	6f635f55 	svcvs	0x00635f55
    1d80:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1d84:	00353161 	eorseq	r3, r5, r1, ror #2
    1d88:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1d8c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1d90:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    1d94:	36323761 	ldrtcc	r3, [r2], -r1, ror #14
    1d98:	54006574 	strpl	r6, [r0], #-1396	; 0xfffffa8c
    1d9c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1da0:	50435f54 	subpl	r5, r3, r4, asr pc
    1da4:	6f635f55 	svcvs	0x00635f55
    1da8:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1dac:	00373161 	eorseq	r3, r7, r1, ror #2
    1db0:	5f4d5241 	svcpl	0x004d5241
    1db4:	54005447 	strpl	r5, [r0], #-1095	; 0xfffffbb9
    1db8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1dbc:	50435f54 	subpl	r5, r3, r4, asr pc
    1dc0:	656e5f55 	strbvs	r5, [lr, #-3925]!	; 0xfffff0ab
    1dc4:	7265766f 	rsbvc	r7, r5, #116391936	; 0x6f00000
    1dc8:	316e6573 	smccc	58963	; 0xe653
    1dcc:	2f2e2e00 	svccs	0x002e2e00
    1dd0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1dd4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1dd8:	2f2e2e2f 	svccs	0x002e2e2f
    1ddc:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 1d2c <shift+0x1d2c>
    1de0:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1de4:	696c2f63 	stmdbvs	ip!, {r0, r1, r5, r6, r8, r9, sl, fp, sp}^
    1de8:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1dec:	00632e32 	rsbeq	r2, r3, r2, lsr lr
    1df0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1df4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1df8:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1dfc:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1e00:	66347278 			; <UNDEFINED> instruction: 0x66347278
    1e04:	53414200 	movtpl	r4, #4608	; 0x1200
    1e08:	52415f45 	subpl	r5, r1, #276	; 0x114
    1e0c:	375f4843 	ldrbcc	r4, [pc, -r3, asr #16]
    1e10:	54004d45 	strpl	r4, [r0], #-3397	; 0xfffff2bb
    1e14:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1e18:	50435f54 	subpl	r5, r3, r4, asr pc
    1e1c:	6f635f55 	svcvs	0x00635f55
    1e20:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1e24:	00323161 	eorseq	r3, r2, r1, ror #2
    1e28:	68736168 	ldmdavs	r3!, {r3, r5, r6, r8, sp, lr}^
    1e2c:	5f6c6176 	svcpl	0x006c6176
    1e30:	41420074 	hvcmi	8196	; 0x2004
    1e34:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1e38:	5f484352 	svcpl	0x00484352
    1e3c:	005a4b36 	subseq	r4, sl, r6, lsr fp
    1e40:	5f617369 	svcpl	0x00617369
    1e44:	73746962 	cmnvc	r4, #1605632	; 0x188000
    1e48:	6d726100 	ldfvse	f6, [r2, #-0]
    1e4c:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1e50:	72615f68 	rsbvc	r5, r1, #104, 30	; 0x1a0
    1e54:	77685f6d 	strbvc	r5, [r8, -sp, ror #30]!
    1e58:	00766964 	rsbseq	r6, r6, r4, ror #18
    1e5c:	5f6d7261 	svcpl	0x006d7261
    1e60:	5f757066 	svcpl	0x00757066
    1e64:	63736564 	cmnvs	r3, #100, 10	; 0x19000000
    1e68:	61736900 	cmnvs	r3, r0, lsl #18
    1e6c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1e70:	3170665f 	cmncc	r0, pc, asr r6
    1e74:	4e470036 	mcrmi	0, 2, r0, cr7, cr6, {1}
    1e78:	31432055 	qdaddcc	r2, r5, r3
    1e7c:	2e392037 	mrccs	0, 1, r2, cr9, cr7, {1}
    1e80:	20312e32 	eorscs	r2, r1, r2, lsr lr
    1e84:	39313032 	ldmdbcc	r1!, {r1, r4, r5, ip, sp}
    1e88:	35323031 	ldrcc	r3, [r2, #-49]!	; 0xffffffcf
    1e8c:	65722820 	ldrbvs	r2, [r2, #-2080]!	; 0xfffff7e0
    1e90:	7361656c 	cmnvc	r1, #108, 10	; 0x1b000000
    1e94:	5b202965 	blpl	80c430 <__bss_end+0x802cec>
    1e98:	2f4d5241 	svccs	0x004d5241
    1e9c:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    1ea0:	72622d39 	rsbvc	r2, r2, #3648	; 0xe40
    1ea4:	68636e61 	stmdavs	r3!, {r0, r5, r6, r9, sl, fp, sp, lr}^
    1ea8:	76657220 	strbtvc	r7, [r5], -r0, lsr #4
    1eac:	6f697369 	svcvs	0x00697369
    1eb0:	3732206e 	ldrcc	r2, [r2, -lr, rrx]!
    1eb4:	39393537 	ldmdbcc	r9!, {r0, r1, r2, r4, r5, r8, sl, ip, sp}
    1eb8:	6d2d205d 	stcvs	0, cr2, [sp, #-372]!	; 0xfffffe8c
    1ebc:	206d7261 	rsbcs	r7, sp, r1, ror #4
    1ec0:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
    1ec4:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
    1ec8:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
    1ecc:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    1ed0:	616d2d20 	cmnvs	sp, r0, lsr #26
    1ed4:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
    1ed8:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1edc:	2b657435 	blcs	195efb8 <__bss_end+0x1955874>
    1ee0:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    1ee4:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    1ee8:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    1eec:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    1ef0:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    1ef4:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    1ef8:	7562662d 	strbvc	r6, [r2, #-1581]!	; 0xfffff9d3
    1efc:	69646c69 	stmdbvs	r4!, {r0, r3, r5, r6, sl, fp, sp, lr}^
    1f00:	6c2d676e 	stcvs	7, cr6, [sp], #-440	; 0xfffffe48
    1f04:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1f08:	662d2063 	strtvs	r2, [sp], -r3, rrx
    1f0c:	732d6f6e 			; <UNDEFINED> instruction: 0x732d6f6e
    1f10:	6b636174 	blvs	18da4e8 <__bss_end+0x18d0da4>
    1f14:	6f72702d 	svcvs	0x0072702d
    1f18:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
    1f1c:	2d20726f 	sfmcs	f7, 4, [r0, #-444]!	; 0xfffffe44
    1f20:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 1d90 <shift+0x1d90>
    1f24:	696c6e69 	stmdbvs	ip!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
    1f28:	2d20656e 	cfstr32cs	mvfx6, [r0, #-440]!	; 0xfffffe48
    1f2c:	73697666 	cmnvc	r9, #106954752	; 0x6600000
    1f30:	6c696269 	sfmvs	f6, 2, [r9], #-420	; 0xfffffe5c
    1f34:	3d797469 	cfldrdcc	mvd7, [r9, #-420]!	; 0xfffffe5c
    1f38:	64646968 	strbtvs	r6, [r4], #-2408	; 0xfffff698
    1f3c:	41006e65 	tstmi	r0, r5, ror #28
    1f40:	485f4d52 	ldmdami	pc, {r1, r4, r6, r8, sl, fp, lr}^	; <UNPREDICTABLE>
    1f44:	73690049 	cmnvc	r9, #73	; 0x49
    1f48:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1f4c:	64615f74 	strbtvs	r5, [r1], #-3956	; 0xfffff08c
    1f50:	54007669 	strpl	r7, [r0], #-1641	; 0xfffff997
    1f54:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1f58:	50435f54 	subpl	r5, r3, r4, asr pc
    1f5c:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1f60:	3331316d 	teqcc	r1, #1073741851	; 0x4000001b
    1f64:	00736a36 	rsbseq	r6, r3, r6, lsr sl
    1f68:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1f6c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1f70:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1f74:	00386d72 	eorseq	r6, r8, r2, ror sp
    1f78:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1f7c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1f80:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1f84:	00396d72 	eorseq	r6, r9, r2, ror sp
    1f88:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1f8c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1f90:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    1f94:	36323661 	ldrtcc	r3, [r2], -r1, ror #12
    1f98:	6e6f6c00 	cdpvs	12, 6, cr6, cr15, cr0, {0}
    1f9c:	6f6c2067 	svcvs	0x006c2067
    1fa0:	7520676e 	strvc	r6, [r0, #-1902]!	; 0xfffff892
    1fa4:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
    1fa8:	2064656e 	rsbcs	r6, r4, lr, ror #10
    1fac:	00746e69 	rsbseq	r6, r4, r9, ror #28
    1fb0:	5f6d7261 	svcpl	0x006d7261
    1fb4:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1fb8:	736d635f 	cmnvc	sp, #2080374785	; 0x7c000001
    1fbc:	41540065 	cmpmi	r4, r5, rrx
    1fc0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1fc4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1fc8:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1fcc:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1fd0:	41540034 	cmpmi	r4, r4, lsr r0
    1fd4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1fd8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1fdc:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1fe0:	00653031 	rsbeq	r3, r5, r1, lsr r0
    1fe4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1fe8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1fec:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1ff0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1ff4:	00376d78 	eorseq	r6, r7, r8, ror sp
    1ff8:	5f6d7261 	svcpl	0x006d7261
    1ffc:	646e6f63 	strbtvs	r6, [lr], #-3939	; 0xfffff09d
    2000:	646f635f 	strbtvs	r6, [pc], #-863	; 2008 <shift+0x2008>
    2004:	52410065 	subpl	r0, r1, #101	; 0x65
    2008:	43505f4d 	cmpmi	r0, #308	; 0x134
    200c:	41415f53 	cmpmi	r1, r3, asr pc
    2010:	00534350 	subseq	r4, r3, r0, asr r3
    2014:	5f617369 	svcpl	0x00617369
    2018:	5f746962 	svcpl	0x00746962
    201c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2020:	00325f38 	eorseq	r5, r2, r8, lsr pc
    2024:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    2028:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    202c:	4d335f48 	ldcmi	15, cr5, [r3, #-288]!	; 0xfffffee0
    2030:	52415400 	subpl	r5, r1, #0, 8
    2034:	5f544547 	svcpl	0x00544547
    2038:	5f555043 	svcpl	0x00555043
    203c:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    2040:	00743031 	rsbseq	r3, r4, r1, lsr r0
    2044:	5f6d7261 	svcpl	0x006d7261
    2048:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    204c:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    2050:	3274786d 	rsbscc	r7, r4, #7143424	; 0x6d0000
    2054:	61736900 	cmnvs	r3, r0, lsl #18
    2058:	6d756e5f 	ldclvs	14, cr6, [r5, #-380]!	; 0xfffffe84
    205c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2060:	41540073 	cmpmi	r4, r3, ror r0
    2064:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2068:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    206c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2070:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    2074:	756c7030 	strbvc	r7, [ip, #-48]!	; 0xffffffd0
    2078:	616d7373 	smcvs	55091	; 0xd733
    207c:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    2080:	7069746c 	rsbvc	r7, r9, ip, ror #8
    2084:	5400796c 	strpl	r7, [r0], #-2412	; 0xfffff694
    2088:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    208c:	50435f54 	subpl	r5, r3, r4, asr pc
    2090:	78655f55 	stmdavc	r5!, {r0, r2, r4, r6, r8, r9, sl, fp, ip, lr}^
    2094:	736f6e79 	cmnvc	pc, #1936	; 0x790
    2098:	5400316d 	strpl	r3, [r0], #-365	; 0xfffffe93
    209c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    20a0:	50435f54 	subpl	r5, r3, r4, asr pc
    20a4:	6f635f55 	svcvs	0x00635f55
    20a8:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    20ac:	00323572 	eorseq	r3, r2, r2, ror r5
    20b0:	5f617369 	svcpl	0x00617369
    20b4:	5f746962 	svcpl	0x00746962
    20b8:	76696474 			; <UNDEFINED> instruction: 0x76696474
    20bc:	65727000 	ldrbvs	r7, [r2, #-0]!
    20c0:	5f726566 	svcpl	0x00726566
    20c4:	6e6f656e 	cdpvs	5, 6, cr6, cr15, cr14, {3}
    20c8:	726f665f 	rsbvc	r6, pc, #99614720	; 0x5f00000
    20cc:	6234365f 	eorsvs	r3, r4, #99614720	; 0x5f00000
    20d0:	00737469 	rsbseq	r7, r3, r9, ror #8
    20d4:	5f617369 	svcpl	0x00617369
    20d8:	5f746962 	svcpl	0x00746962
    20dc:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    20e0:	006c6d66 	rsbeq	r6, ip, r6, ror #26
    20e4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    20e8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    20ec:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    20f0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    20f4:	32336178 	eorscc	r6, r3, #120, 2
    20f8:	52415400 	subpl	r5, r1, #0, 8
    20fc:	5f544547 	svcpl	0x00544547
    2100:	5f555043 	svcpl	0x00555043
    2104:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2108:	33617865 	cmncc	r1, #6619136	; 0x650000
    210c:	73690035 	cmnvc	r9, #53	; 0x35
    2110:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2114:	70665f74 	rsbvc	r5, r6, r4, ror pc
    2118:	6f633631 	svcvs	0x00633631
    211c:	7500766e 	strvc	r7, [r0, #-1646]	; 0xfffff992
    2120:	6570736e 	ldrbvs	r7, [r0, #-878]!	; 0xfffffc92
    2124:	735f7663 	cmpvc	pc, #103809024	; 0x6300000
    2128:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
    212c:	54007367 	strpl	r7, [r0], #-871	; 0xfffffc99
    2130:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2134:	50435f54 	subpl	r5, r3, r4, asr pc
    2138:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    213c:	3531316d 	ldrcc	r3, [r1, #-365]!	; 0xfffffe93
    2140:	73327436 	teqvc	r2, #905969664	; 0x36000000
    2144:	52415400 	subpl	r5, r1, #0, 8
    2148:	5f544547 	svcpl	0x00544547
    214c:	5f555043 	svcpl	0x00555043
    2150:	30366166 	eorscc	r6, r6, r6, ror #2
    2154:	00657436 	rsbeq	r7, r5, r6, lsr r4
    2158:	47524154 			; <UNDEFINED> instruction: 0x47524154
    215c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2160:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2164:	32396d72 	eorscc	r6, r9, #7296	; 0x1c80
    2168:	736a6536 	cmnvc	sl, #226492416	; 0xd800000
    216c:	53414200 	movtpl	r4, #4608	; 0x1200
    2170:	52415f45 	subpl	r5, r1, #276	; 0x114
    2174:	345f4843 	ldrbcc	r4, [pc], #-2115	; 217c <shift+0x217c>
    2178:	73690054 	cmnvc	r9, #84	; 0x54
    217c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2180:	72635f74 	rsbvc	r5, r3, #116, 30	; 0x1d0
    2184:	6f747079 	svcvs	0x00747079
    2188:	6d726100 	ldfvse	f6, [r2, #-0]
    218c:	6765725f 			; <UNDEFINED> instruction: 0x6765725f
    2190:	6e695f73 	mcrvs	15, 3, r5, cr9, cr3, {3}
    2194:	7165735f 	cmnvc	r5, pc, asr r3
    2198:	636e6575 	cmnvs	lr, #490733568	; 0x1d400000
    219c:	73690065 	cmnvc	r9, #101	; 0x65
    21a0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    21a4:	62735f74 	rsbsvs	r5, r3, #116, 30	; 0x1d0
    21a8:	53414200 	movtpl	r4, #4608	; 0x1200
    21ac:	52415f45 	subpl	r5, r1, #276	; 0x114
    21b0:	355f4843 	ldrbcc	r4, [pc, #-2115]	; 1975 <shift+0x1975>
    21b4:	69004554 	stmdbvs	r0, {r2, r4, r6, r8, sl, lr}
    21b8:	665f6173 			; <UNDEFINED> instruction: 0x665f6173
    21bc:	75746165 	ldrbvc	r6, [r4, #-357]!	; 0xfffffe9b
    21c0:	69006572 	stmdbvs	r0, {r1, r4, r5, r6, r8, sl, sp, lr}
    21c4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    21c8:	735f7469 	cmpvc	pc, #1761607680	; 0x69000000
    21cc:	6c6c616d 	stfvse	f6, [ip], #-436	; 0xfffffe4c
    21d0:	006c756d 	rsbeq	r7, ip, sp, ror #10
    21d4:	5f6d7261 	svcpl	0x006d7261
    21d8:	676e616c 	strbvs	r6, [lr, -ip, ror #2]!
    21dc:	74756f5f 	ldrbtvc	r6, [r5], #-3935	; 0xfffff0a1
    21e0:	5f747570 	svcpl	0x00747570
    21e4:	656a626f 	strbvs	r6, [sl, #-623]!	; 0xfffffd91
    21e8:	615f7463 	cmpvs	pc, r3, ror #8
    21ec:	69727474 	ldmdbvs	r2!, {r2, r4, r5, r6, sl, ip, sp, lr}^
    21f0:	65747562 	ldrbvs	r7, [r4, #-1378]!	; 0xfffffa9e
    21f4:	6f685f73 	svcvs	0x00685f73
    21f8:	69006b6f 	stmdbvs	r0, {r0, r1, r2, r3, r5, r6, r8, r9, fp, sp, lr}
    21fc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2200:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    2204:	33645f70 	cmncc	r4, #112, 30	; 0x1c0
    2208:	52410032 	subpl	r0, r1, #50	; 0x32
    220c:	454e5f4d 	strbmi	r5, [lr, #-3917]	; 0xfffff0b3
    2210:	61736900 	cmnvs	r3, r0, lsl #18
    2214:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2218:	3865625f 	stmdacc	r5!, {r0, r1, r2, r3, r4, r6, r9, sp, lr}^
    221c:	52415400 	subpl	r5, r1, #0, 8
    2220:	5f544547 	svcpl	0x00544547
    2224:	5f555043 	svcpl	0x00555043
    2228:	316d7261 	cmncc	sp, r1, ror #4
    222c:	6a363731 	bvs	d8fef8 <__bss_end+0xd867b4>
    2230:	7000737a 	andvc	r7, r0, sl, ror r3
    2234:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    2238:	726f7373 	rsbvc	r7, pc, #-872415231	; 0xcc000001
    223c:	7079745f 	rsbsvc	r7, r9, pc, asr r4
    2240:	6c610065 	stclvs	0, cr0, [r1], #-404	; 0xfffffe6c
    2244:	70665f6c 	rsbvc	r5, r6, ip, ror #30
    2248:	61007375 	tstvs	r0, r5, ror r3
    224c:	705f6d72 	subsvc	r6, pc, r2, ror sp	; <UNPREDICTABLE>
    2250:	42007363 	andmi	r7, r0, #-1946157055	; 0x8c000001
    2254:	5f455341 	svcpl	0x00455341
    2258:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    225c:	0054355f 	subseq	r3, r4, pc, asr r5
    2260:	5f6d7261 	svcpl	0x006d7261
    2264:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2268:	54007434 	strpl	r7, [r0], #-1076	; 0xfffffbcc
    226c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2270:	50435f54 	subpl	r5, r3, r4, asr pc
    2274:	6f635f55 	svcvs	0x00635f55
    2278:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    227c:	63363761 	teqvs	r6, #25427968	; 0x1840000
    2280:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2284:	35356178 	ldrcc	r6, [r5, #-376]!	; 0xfffffe88
    2288:	6d726100 	ldfvse	f6, [r2, #-0]
    228c:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    2290:	62775f65 	rsbsvs	r5, r7, #404	; 0x194
    2294:	68006675 	stmdavs	r0, {r0, r2, r4, r5, r6, r9, sl, sp, lr}
    2298:	5f626174 	svcpl	0x00626174
    229c:	68736168 	ldmdavs	r3!, {r3, r5, r6, r8, sp, lr}^
    22a0:	61736900 	cmnvs	r3, r0, lsl #18
    22a4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    22a8:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    22ac:	6e5f6b72 	vmovvs.s8	r6, d15[3]
    22b0:	6f765f6f 	svcvs	0x00765f6f
    22b4:	6974616c 	ldmdbvs	r4!, {r2, r3, r5, r6, r8, sp, lr}^
    22b8:	635f656c 	cmpvs	pc, #108, 10	; 0x1b000000
    22bc:	41540065 	cmpmi	r4, r5, rrx
    22c0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    22c4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    22c8:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    22cc:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    22d0:	41540030 	cmpmi	r4, r0, lsr r0
    22d4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    22d8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    22dc:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    22e0:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    22e4:	41540031 	cmpmi	r4, r1, lsr r0
    22e8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    22ec:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    22f0:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    22f4:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    22f8:	73690033 	cmnvc	r9, #51	; 0x33
    22fc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2300:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    2304:	5f38766d 	svcpl	0x0038766d
    2308:	72610031 	rsbvc	r0, r1, #49	; 0x31
    230c:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2310:	6e5f6863 	cdpvs	8, 5, cr6, cr15, cr3, {3}
    2314:	00656d61 	rsbeq	r6, r5, r1, ror #26
    2318:	5f617369 	svcpl	0x00617369
    231c:	5f746962 	svcpl	0x00746962
    2320:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2324:	00335f38 	eorseq	r5, r3, r8, lsr pc
    2328:	5f617369 	svcpl	0x00617369
    232c:	5f746962 	svcpl	0x00746962
    2330:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2334:	00345f38 	eorseq	r5, r4, r8, lsr pc
    2338:	5f617369 	svcpl	0x00617369
    233c:	5f746962 	svcpl	0x00746962
    2340:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2344:	00355f38 	eorseq	r5, r5, r8, lsr pc
    2348:	47524154 			; <UNDEFINED> instruction: 0x47524154
    234c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2350:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2354:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2358:	33356178 	teqcc	r5, #120, 2
    235c:	52415400 	subpl	r5, r1, #0, 8
    2360:	5f544547 	svcpl	0x00544547
    2364:	5f555043 	svcpl	0x00555043
    2368:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    236c:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    2370:	41540035 	cmpmi	r4, r5, lsr r0
    2374:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2378:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    237c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2380:	61786574 	cmnvs	r8, r4, ror r5
    2384:	54003735 	strpl	r3, [r0], #-1845	; 0xfffff8cb
    2388:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    238c:	50435f54 	subpl	r5, r3, r4, asr pc
    2390:	706d5f55 	rsbvc	r5, sp, r5, asr pc
    2394:	65726f63 	ldrbvs	r6, [r2, #-3939]!	; 0xfffff09d
    2398:	52415400 	subpl	r5, r1, #0, 8
    239c:	5f544547 	svcpl	0x00544547
    23a0:	5f555043 	svcpl	0x00555043
    23a4:	5f6d7261 	svcpl	0x006d7261
    23a8:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    23ac:	6d726100 	ldfvse	f6, [r2, #-0]
    23b0:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    23b4:	6f6e5f68 	svcvs	0x006e5f68
    23b8:	54006d74 	strpl	r6, [r0], #-3444	; 0xfffff28c
    23bc:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    23c0:	50435f54 	subpl	r5, r3, r4, asr pc
    23c4:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    23c8:	3230316d 	eorscc	r3, r0, #1073741851	; 0x4000001b
    23cc:	736a6536 	cmnvc	sl, #226492416	; 0xd800000
    23d0:	53414200 	movtpl	r4, #4608	; 0x1200
    23d4:	52415f45 	subpl	r5, r1, #276	; 0x114
    23d8:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    23dc:	4142004a 	cmpmi	r2, sl, asr #32
    23e0:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    23e4:	5f484352 	svcpl	0x00484352
    23e8:	42004b36 	andmi	r4, r0, #55296	; 0xd800
    23ec:	5f455341 	svcpl	0x00455341
    23f0:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    23f4:	004d365f 	subeq	r3, sp, pc, asr r6
    23f8:	5f617369 	svcpl	0x00617369
    23fc:	5f746962 	svcpl	0x00746962
    2400:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    2404:	54007478 	strpl	r7, [r0], #-1144	; 0xfffffb88
    2408:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    240c:	50435f54 	subpl	r5, r3, r4, asr pc
    2410:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    2414:	3331316d 	teqcc	r1, #1073741851	; 0x4000001b
    2418:	73666a36 	cmnvc	r6, #221184	; 0x36000
    241c:	4d524100 	ldfmie	f4, [r2, #-0]
    2420:	00534c5f 	subseq	r4, r3, pc, asr ip
    2424:	5f4d5241 	svcpl	0x004d5241
    2428:	4200544c 	andmi	r5, r0, #76, 8	; 0x4c000000
    242c:	5f455341 	svcpl	0x00455341
    2430:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    2434:	005a365f 	subseq	r3, sl, pc, asr r6
    2438:	47524154 			; <UNDEFINED> instruction: 0x47524154
    243c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2440:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2444:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2448:	35376178 	ldrcc	r6, [r7, #-376]!	; 0xfffffe88
    244c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2450:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    2454:	52410035 	subpl	r0, r1, #53	; 0x35
    2458:	43505f4d 	cmpmi	r0, #308	; 0x134
    245c:	41415f53 	cmpmi	r1, r3, asr pc
    2460:	5f534350 	svcpl	0x00534350
    2464:	00504656 	subseq	r4, r0, r6, asr r6
    2468:	47524154 			; <UNDEFINED> instruction: 0x47524154
    246c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2470:	695f5550 	ldmdbvs	pc, {r4, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
    2474:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    2478:	69003274 	stmdbvs	r0, {r2, r4, r5, r6, r9, ip, sp}
    247c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2480:	6e5f7469 	cdpvs	4, 5, cr7, cr15, cr9, {3}
    2484:	006e6f65 	rsbeq	r6, lr, r5, ror #30
    2488:	5f6d7261 	svcpl	0x006d7261
    248c:	5f757066 	svcpl	0x00757066
    2490:	72747461 	rsbsvc	r7, r4, #1627389952	; 0x61000000
    2494:	61736900 	cmnvs	r3, r0, lsl #18
    2498:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    249c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    24a0:	6d653776 	stclvs	7, cr3, [r5, #-472]!	; 0xfffffe28
    24a4:	52415400 	subpl	r5, r1, #0, 8
    24a8:	5f544547 	svcpl	0x00544547
    24ac:	5f555043 	svcpl	0x00555043
    24b0:	32366166 	eorscc	r6, r6, #-2147483623	; 0x80000019
    24b4:	00657436 	rsbeq	r7, r5, r6, lsr r4
    24b8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    24bc:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    24c0:	6d5f5550 	cfldr64vs	mvdx5, [pc, #-320]	; 2388 <shift+0x2388>
    24c4:	65767261 	ldrbvs	r7, [r6, #-609]!	; 0xfffffd9f
    24c8:	705f6c6c 	subsvc	r6, pc, ip, ror #24
    24cc:	6800346a 	stmdavs	r0, {r1, r3, r5, r6, sl, ip, sp}
    24d0:	5f626174 	svcpl	0x00626174
    24d4:	68736168 	ldmdavs	r3!, {r3, r5, r6, r8, sp, lr}^
    24d8:	696f705f 	stmdbvs	pc!, {r0, r1, r2, r3, r4, r6, ip, sp, lr}^	; <UNPREDICTABLE>
    24dc:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    24e0:	6d726100 	ldfvse	f6, [r2, #-0]
    24e4:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    24e8:	6f635f65 	svcvs	0x00635f65
    24ec:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    24f0:	0039615f 	eorseq	r6, r9, pc, asr r1
    24f4:	5f617369 	svcpl	0x00617369
    24f8:	5f746962 	svcpl	0x00746962
    24fc:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    2500:	00327478 	eorseq	r7, r2, r8, ror r4
    2504:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2508:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    250c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2510:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2514:	32376178 	eorscc	r6, r7, #120, 2
    2518:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    251c:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    2520:	73690033 	cmnvc	r9, #51	; 0x33
    2524:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2528:	68745f74 	ldmdavs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    252c:	32626d75 	rsbcc	r6, r2, #7488	; 0x1d40
    2530:	53414200 	movtpl	r4, #4608	; 0x1200
    2534:	52415f45 	subpl	r5, r1, #276	; 0x114
    2538:	375f4843 	ldrbcc	r4, [pc, -r3, asr #16]
    253c:	73690041 	cmnvc	r9, #65	; 0x41
    2540:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2544:	6f645f74 	svcvs	0x00645f74
    2548:	6f727074 	svcvs	0x00727074
    254c:	72610064 	rsbvc	r0, r1, #100	; 0x64
    2550:	70665f6d 	rsbvc	r5, r6, sp, ror #30
    2554:	745f3631 	ldrbvc	r3, [pc], #-1585	; 255c <shift+0x255c>
    2558:	5f657079 	svcpl	0x00657079
    255c:	65646f6e 	strbvs	r6, [r4, #-3950]!	; 0xfffff092
    2560:	4d524100 	ldfmie	f4, [r2, #-0]
    2564:	00494d5f 	subeq	r4, r9, pc, asr sp
    2568:	5f6d7261 	svcpl	0x006d7261
    256c:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2570:	61006b36 	tstvs	r0, r6, lsr fp
    2574:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2578:	36686372 			; <UNDEFINED> instruction: 0x36686372
    257c:	4142006d 	cmpmi	r2, sp, rrx
    2580:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    2584:	5f484352 	svcpl	0x00484352
    2588:	5f005237 	svcpl	0x00005237
    258c:	706f705f 	rsbvc	r7, pc, pc, asr r0	; <UNPREDICTABLE>
    2590:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
    2594:	61745f74 	cmnvs	r4, r4, ror pc
    2598:	73690062 	cmnvc	r9, #98	; 0x62
    259c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    25a0:	6d635f74 	stclvs	15, cr5, [r3, #-464]!	; 0xfffffe30
    25a4:	54006573 	strpl	r6, [r0], #-1395	; 0xfffffa8d
    25a8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    25ac:	50435f54 	subpl	r5, r3, r4, asr pc
    25b0:	6f635f55 	svcvs	0x00635f55
    25b4:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    25b8:	00333761 	eorseq	r3, r3, r1, ror #14
    25bc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    25c0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    25c4:	675f5550 			; <UNDEFINED> instruction: 0x675f5550
    25c8:	72656e65 	rsbvc	r6, r5, #1616	; 0x650
    25cc:	37766369 	ldrbcc	r6, [r6, -r9, ror #6]!
    25d0:	41540061 	cmpmi	r4, r1, rrx
    25d4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    25d8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    25dc:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    25e0:	61786574 	cmnvs	r8, r4, ror r5
    25e4:	61003637 	tstvs	r0, r7, lsr r6
    25e8:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    25ec:	5f686372 	svcpl	0x00686372
    25f0:	765f6f6e 	ldrbvc	r6, [pc], -lr, ror #30
    25f4:	74616c6f 	strbtvc	r6, [r1], #-3183	; 0xfffff391
    25f8:	5f656c69 	svcpl	0x00656c69
    25fc:	42006563 	andmi	r6, r0, #415236096	; 0x18c00000
    2600:	5f455341 	svcpl	0x00455341
    2604:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    2608:	0041385f 	subeq	r3, r1, pc, asr r8
    260c:	5f617369 	svcpl	0x00617369
    2610:	5f746962 	svcpl	0x00746962
    2614:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2618:	42007435 	andmi	r7, r0, #889192448	; 0x35000000
    261c:	5f455341 	svcpl	0x00455341
    2620:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    2624:	0052385f 	subseq	r3, r2, pc, asr r8
    2628:	47524154 			; <UNDEFINED> instruction: 0x47524154
    262c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2630:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2634:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2638:	33376178 	teqcc	r7, #120, 2
    263c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2640:	33617865 	cmncc	r1, #6619136	; 0x650000
    2644:	52410035 	subpl	r0, r1, #53	; 0x35
    2648:	564e5f4d 	strbpl	r5, [lr], -sp, asr #30
    264c:	6d726100 	ldfvse	f6, [r2, #-0]
    2650:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2654:	61003468 	tstvs	r0, r8, ror #8
    2658:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    265c:	36686372 			; <UNDEFINED> instruction: 0x36686372
    2660:	6d726100 	ldfvse	f6, [r2, #-0]
    2664:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2668:	61003768 	tstvs	r0, r8, ror #14
    266c:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2670:	38686372 	stmdacc	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    2674:	6e6f6c00 	cdpvs	12, 6, cr6, cr15, cr0, {0}
    2678:	6f642067 	svcvs	0x00642067
    267c:	656c6275 	strbvs	r6, [ip, #-629]!	; 0xfffffd8b
    2680:	6d726100 	ldfvse	f6, [r2, #-0]
    2684:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    2688:	73785f65 	cmnvc	r8, #404	; 0x194
    268c:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    2690:	6b616d00 	blvs	185da98 <__bss_end+0x1854354>
    2694:	5f676e69 	svcpl	0x00676e69
    2698:	736e6f63 	cmnvc	lr, #396	; 0x18c
    269c:	61745f74 	cmnvs	r4, r4, ror pc
    26a0:	00656c62 	rsbeq	r6, r5, r2, ror #24
    26a4:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    26a8:	61635f62 	cmnvs	r3, r2, ror #30
    26ac:	765f6c6c 	ldrbvc	r6, [pc], -ip, ror #24
    26b0:	6c5f6169 	ldfvse	f6, [pc], {105}	; 0x69
    26b4:	6c656261 	sfmvs	f6, 2, [r5], #-388	; 0xfffffe7c
    26b8:	61736900 	cmnvs	r3, r0, lsl #18
    26bc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    26c0:	7670665f 			; <UNDEFINED> instruction: 0x7670665f
    26c4:	73690035 	cmnvc	r9, #53	; 0x35
    26c8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    26cc:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    26d0:	6b36766d 	blvs	da008c <__bss_end+0xd96948>
    26d4:	52415400 	subpl	r5, r1, #0, 8
    26d8:	5f544547 	svcpl	0x00544547
    26dc:	5f555043 	svcpl	0x00555043
    26e0:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    26e4:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    26e8:	52415400 	subpl	r5, r1, #0, 8
    26ec:	5f544547 	svcpl	0x00544547
    26f0:	5f555043 	svcpl	0x00555043
    26f4:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    26f8:	38617865 	stmdacc	r1!, {r0, r2, r5, r6, fp, ip, sp, lr}^
    26fc:	52415400 	subpl	r5, r1, #0, 8
    2700:	5f544547 	svcpl	0x00544547
    2704:	5f555043 	svcpl	0x00555043
    2708:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    270c:	39617865 	stmdbcc	r1!, {r0, r2, r5, r6, fp, ip, sp, lr}^
    2710:	4d524100 	ldfmie	f4, [r2, #-0]
    2714:	5343505f 	movtpl	r5, #12383	; 0x305f
    2718:	4350415f 	cmpmi	r0, #-1073741801	; 0xc0000017
    271c:	52410053 	subpl	r0, r1, #83	; 0x53
    2720:	43505f4d 	cmpmi	r0, #308	; 0x134
    2724:	54415f53 	strbpl	r5, [r1], #-3923	; 0xfffff0ad
    2728:	00534350 	subseq	r4, r3, r0, asr r3
    272c:	706d6f63 	rsbvc	r6, sp, r3, ror #30
    2730:	2078656c 	rsbscs	r6, r8, ip, ror #10
    2734:	62756f64 	rsbsvs	r6, r5, #100, 30	; 0x190
    2738:	5400656c 	strpl	r6, [r0], #-1388	; 0xfffffa94
    273c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2740:	50435f54 	subpl	r5, r3, r4, asr pc
    2744:	6f635f55 	svcvs	0x00635f55
    2748:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    274c:	63333761 	teqvs	r3, #25427968	; 0x1840000
    2750:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2754:	33356178 	teqcc	r5, #120, 2
    2758:	52415400 	subpl	r5, r1, #0, 8
    275c:	5f544547 	svcpl	0x00544547
    2760:	5f555043 	svcpl	0x00555043
    2764:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2768:	306d7865 	rsbcc	r7, sp, r5, ror #16
    276c:	73756c70 	cmnvc	r5, #112, 24	; 0x7000
    2770:	6d726100 	ldfvse	f6, [r2, #-0]
    2774:	0063635f 	rsbeq	r6, r3, pc, asr r3
    2778:	5f617369 	svcpl	0x00617369
    277c:	5f746962 	svcpl	0x00746962
    2780:	61637378 	smcvs	14136	; 0x3738
    2784:	5f00656c 	svcpl	0x0000656c
    2788:	746e6f64 	strbtvc	r6, [lr], #-3940	; 0xfffff09c
    278c:	6573755f 	ldrbvs	r7, [r3, #-1375]!	; 0xfffffaa1
    2790:	6572745f 	ldrbvs	r7, [r2, #-1119]!	; 0xfffffba1
    2794:	65685f65 	strbvs	r5, [r8, #-3941]!	; 0xfffff09b
    2798:	005f6572 	subseq	r6, pc, r2, ror r5	; <UNPREDICTABLE>
    279c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    27a0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    27a4:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    27a8:	30316d72 	eorscc	r6, r1, r2, ror sp
    27ac:	696d6474 	stmdbvs	sp!, {r2, r4, r5, r6, sl, sp, lr}^
    27b0:	52415400 	subpl	r5, r1, #0, 8
    27b4:	5f544547 	svcpl	0x00544547
    27b8:	5f555043 	svcpl	0x00555043
    27bc:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    27c0:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    27c4:	73616200 	cmnvc	r1, #0, 4
    27c8:	72615f65 	rsbvc	r5, r1, #404	; 0x194
    27cc:	74696863 	strbtvc	r6, [r9], #-2147	; 0xfffff79d
    27d0:	75746365 	ldrbvc	r6, [r4, #-869]!	; 0xfffffc9b
    27d4:	61006572 	tstvs	r0, r2, ror r5
    27d8:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    27dc:	5f686372 	svcpl	0x00686372
    27e0:	00637263 	rsbeq	r7, r3, r3, ror #4
    27e4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    27e8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    27ec:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    27f0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    27f4:	73316d78 	teqvc	r1, #120, 26	; 0x1e00
    27f8:	6c6c616d 	stfvse	f6, [ip], #-436	; 0xfffffe4c
    27fc:	746c756d 	strbtvc	r7, [ip], #-1389	; 0xfffffa93
    2800:	796c7069 	stmdbvc	ip!, {r0, r3, r5, r6, ip, sp, lr}^
    2804:	6d726100 	ldfvse	f6, [r2, #-0]
    2808:	7275635f 	rsbsvc	r6, r5, #2080374785	; 0x7c000001
    280c:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
    2810:	0063635f 	rsbeq	r6, r3, pc, asr r3
    2814:	5f617369 	svcpl	0x00617369
    2818:	5f746962 	svcpl	0x00746962
    281c:	33637263 	cmncc	r3, #805306374	; 0x30000006
    2820:	52410032 	subpl	r0, r1, #50	; 0x32
    2824:	4c505f4d 	mrrcmi	15, 4, r5, r0, cr13
    2828:	61736900 	cmnvs	r3, r0, lsl #18
    282c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2830:	7066765f 	rsbvc	r7, r6, pc, asr r6
    2834:	69003376 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, r9, ip, sp}
    2838:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    283c:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    2840:	34767066 	ldrbtcc	r7, [r6], #-102	; 0xffffff9a
    2844:	53414200 	movtpl	r4, #4608	; 0x1200
    2848:	52415f45 	subpl	r5, r1, #276	; 0x114
    284c:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    2850:	42003254 	andmi	r3, r0, #84, 4	; 0x40000005
    2854:	5f455341 	svcpl	0x00455341
    2858:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    285c:	5f4d385f 	svcpl	0x004d385f
    2860:	4e49414d 	dvfmiem	f4, f1, #5.0
    2864:	52415400 	subpl	r5, r1, #0, 8
    2868:	5f544547 	svcpl	0x00544547
    286c:	5f555043 	svcpl	0x00555043
    2870:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    2874:	696d6474 	stmdbvs	sp!, {r2, r4, r5, r6, sl, sp, lr}^
    2878:	4d524100 	ldfmie	f4, [r2, #-0]
    287c:	004c415f 	subeq	r4, ip, pc, asr r1
    2880:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    2884:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    2888:	4d375f48 	ldcmi	15, cr5, [r7, #-288]!	; 0xfffffee0
    288c:	6d726100 	ldfvse	f6, [r2, #-0]
    2890:	7261745f 	rsbvc	r7, r1, #1593835520	; 0x5f000000
    2894:	5f746567 	svcpl	0x00746567
    2898:	6562616c 	strbvs	r6, [r2, #-364]!	; 0xfffffe94
    289c:	7261006c 	rsbvc	r0, r1, #108	; 0x6c
    28a0:	61745f6d 	cmnvs	r4, sp, ror #30
    28a4:	74656772 	strbtvc	r6, [r5], #-1906	; 0xfffff88e
    28a8:	736e695f 	cmnvc	lr, #1556480	; 0x17c000
    28ac:	4154006e 	cmpmi	r4, lr, rrx
    28b0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    28b4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    28b8:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    28bc:	72786574 	rsbsvc	r6, r8, #116, 10	; 0x1d000000
    28c0:	41540034 	cmpmi	r4, r4, lsr r0
    28c4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    28c8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    28cc:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    28d0:	72786574 	rsbsvc	r6, r8, #116, 10	; 0x1d000000
    28d4:	41540035 	cmpmi	r4, r5, lsr r0
    28d8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    28dc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    28e0:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    28e4:	72786574 	rsbsvc	r6, r8, #116, 10	; 0x1d000000
    28e8:	41540037 	cmpmi	r4, r7, lsr r0
    28ec:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    28f0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    28f4:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    28f8:	72786574 	rsbsvc	r6, r8, #116, 10	; 0x1d000000
    28fc:	73690038 	cmnvc	r9, #56	; 0x38
    2900:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2904:	706c5f74 	rsbvc	r5, ip, r4, ror pc
    2908:	69006561 	stmdbvs	r0, {r0, r5, r6, r8, sl, sp, lr}
    290c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2910:	715f7469 	cmpvc	pc, r9, ror #8
    2914:	6b726975 	blvs	1c9cef0 <__bss_end+0x1c937ac>
    2918:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    291c:	7a6b3676 	bvc	1ad02fc <__bss_end+0x1ac6bb8>
    2920:	61736900 	cmnvs	r3, r0, lsl #18
    2924:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2928:	746f6e5f 	strbtvc	r6, [pc], #-3679	; 2930 <shift+0x2930>
    292c:	7369006d 	cmnvc	r9, #109	; 0x6d
    2930:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2934:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    2938:	0034766d 	eorseq	r7, r4, sp, ror #12
    293c:	5f617369 	svcpl	0x00617369
    2940:	5f746962 	svcpl	0x00746962
    2944:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2948:	73690036 	cmnvc	r9, #54	; 0x36
    294c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2950:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    2954:	0037766d 	eorseq	r7, r7, sp, ror #12
    2958:	5f617369 	svcpl	0x00617369
    295c:	5f746962 	svcpl	0x00746962
    2960:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2964:	645f0038 	ldrbvs	r0, [pc], #-56	; 296c <shift+0x296c>
    2968:	5f746e6f 	svcpl	0x00746e6f
    296c:	5f657375 	svcpl	0x00657375
    2970:	5f787472 	svcpl	0x00787472
    2974:	65726568 	ldrbvs	r6, [r2, #-1384]!	; 0xfffffa98
    2978:	5155005f 	cmppl	r5, pc, asr r0
    297c:	70797449 	rsbsvc	r7, r9, r9, asr #8
    2980:	73690065 	cmnvc	r9, #101	; 0x65
    2984:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2988:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    298c:	7435766d 	ldrtvc	r7, [r5], #-1645	; 0xfffff993
    2990:	72610065 	rsbvc	r0, r1, #101	; 0x65
    2994:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    2998:	6100656e 	tstvs	r0, lr, ror #10
    299c:	635f6d72 	cmpvs	pc, #7296	; 0x1c80
    29a0:	695f7070 	ldmdbvs	pc, {r4, r5, r6, ip, sp, lr}^	; <UNPREDICTABLE>
    29a4:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    29a8:	6b726f77 	blvs	1c9e78c <__bss_end+0x1c95048>
    29ac:	6e756600 	cdpvs	6, 7, cr6, cr5, cr0, {0}
    29b0:	74705f63 	ldrbtvc	r5, [r0], #-3939	; 0xfffff09d
    29b4:	41540072 	cmpmi	r4, r2, ror r0
    29b8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    29bc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    29c0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    29c4:	74303239 	ldrtvc	r3, [r0], #-569	; 0xfffffdc7
    29c8:	61746800 	cmnvs	r4, r0, lsl #16
    29cc:	71655f62 	cmnvc	r5, r2, ror #30
    29d0:	52415400 	subpl	r5, r1, #0, 8
    29d4:	5f544547 	svcpl	0x00544547
    29d8:	5f555043 	svcpl	0x00555043
    29dc:	32356166 	eorscc	r6, r5, #-2147483623	; 0x80000019
    29e0:	72610036 	rsbvc	r0, r1, #54	; 0x36
    29e4:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    29e8:	745f6863 	ldrbvc	r6, [pc], #-2147	; 29f0 <shift+0x29f0>
    29ec:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    29f0:	6477685f 	ldrbtvs	r6, [r7], #-2143	; 0xfffff7a1
    29f4:	68007669 	stmdavs	r0, {r0, r3, r5, r6, r9, sl, ip, sp, lr}
    29f8:	5f626174 	svcpl	0x00626174
    29fc:	705f7165 	subsvc	r7, pc, r5, ror #2
    2a00:	746e696f 	strbtvc	r6, [lr], #-2415	; 0xfffff691
    2a04:	61007265 	tstvs	r0, r5, ror #4
    2a08:	705f6d72 	subsvc	r6, pc, r2, ror sp	; <UNPREDICTABLE>
    2a0c:	725f6369 	subsvc	r6, pc, #-1543503871	; 0xa4000001
    2a10:	73696765 	cmnvc	r9, #26476544	; 0x1940000
    2a14:	00726574 	rsbseq	r6, r2, r4, ror r5
    2a18:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2a1c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2a20:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2a24:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2a28:	73306d78 	teqvc	r0, #120, 26	; 0x1e00
    2a2c:	6c6c616d 	stfvse	f6, [ip], #-436	; 0xfffffe4c
    2a30:	746c756d 	strbtvc	r7, [ip], #-1389	; 0xfffffa93
    2a34:	796c7069 	stmdbvc	ip!, {r0, r3, r5, r6, ip, sp, lr}^
    2a38:	52415400 	subpl	r5, r1, #0, 8
    2a3c:	5f544547 	svcpl	0x00544547
    2a40:	5f555043 	svcpl	0x00555043
    2a44:	6f63706d 	svcvs	0x0063706d
    2a48:	6f6e6572 	svcvs	0x006e6572
    2a4c:	00706676 	rsbseq	r6, r0, r6, ror r6
    2a50:	5f617369 	svcpl	0x00617369
    2a54:	5f746962 	svcpl	0x00746962
    2a58:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    2a5c:	6d635f6b 	stclvs	15, cr5, [r3, #-428]!	; 0xfffffe54
    2a60:	646c5f33 	strbtvs	r5, [ip], #-3891	; 0xfffff0cd
    2a64:	41006472 	tstmi	r0, r2, ror r4
    2a68:	435f4d52 	cmpmi	pc, #5248	; 0x1480
    2a6c:	72610043 	rsbvc	r0, r1, #67	; 0x43
    2a70:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2a74:	5f386863 	svcpl	0x00386863
    2a78:	72610032 	rsbvc	r0, r1, #50	; 0x32
    2a7c:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2a80:	5f386863 	svcpl	0x00386863
    2a84:	72610033 	rsbvc	r0, r1, #51	; 0x33
    2a88:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2a8c:	5f386863 	svcpl	0x00386863
    2a90:	41540034 	cmpmi	r4, r4, lsr r0
    2a94:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2a98:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2a9c:	706d665f 	rsbvc	r6, sp, pc, asr r6
    2aa0:	00363236 	eorseq	r3, r6, r6, lsr r2
    2aa4:	5f4d5241 	svcpl	0x004d5241
    2aa8:	61005343 	tstvs	r0, r3, asr #6
    2aac:	665f6d72 			; <UNDEFINED> instruction: 0x665f6d72
    2ab0:	5f363170 	svcpl	0x00363170
    2ab4:	74736e69 	ldrbtvc	r6, [r3], #-3689	; 0xfffff197
    2ab8:	6d726100 	ldfvse	f6, [r2, #-0]
    2abc:	7361625f 	cmnvc	r1, #-268435451	; 0xf0000005
    2ac0:	72615f65 	rsbvc	r5, r1, #404	; 0x194
    2ac4:	54006863 	strpl	r6, [r0], #-2147	; 0xfffff79d
    2ac8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2acc:	50435f54 	subpl	r5, r3, r4, asr pc
    2ad0:	6f635f55 	svcvs	0x00635f55
    2ad4:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2ad8:	63353161 	teqvs	r5, #1073741848	; 0x40000018
    2adc:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2ae0:	00376178 	eorseq	r6, r7, r8, ror r1
    2ae4:	5f6d7261 	svcpl	0x006d7261
    2ae8:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2aec:	006d6537 	rsbeq	r6, sp, r7, lsr r5
    2af0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2af4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2af8:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2afc:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2b00:	32376178 	eorscc	r6, r7, #120, 2
    2b04:	6d726100 	ldfvse	f6, [r2, #-0]
    2b08:	7363705f 	cmnvc	r3, #95	; 0x5f
    2b0c:	6665645f 			; <UNDEFINED> instruction: 0x6665645f
    2b10:	746c7561 	strbtvc	r7, [ip], #-1377	; 0xfffffa9f
    2b14:	4d524100 	ldfmie	f4, [r2, #-0]
    2b18:	5343505f 	movtpl	r5, #12383	; 0x305f
    2b1c:	5041415f 	subpl	r4, r1, pc, asr r1
    2b20:	4c5f5343 	mrrcmi	3, 4, r5, pc, cr3	; <UNPREDICTABLE>
    2b24:	4c41434f 	mcrrmi	3, 4, r4, r1, cr15
    2b28:	52415400 	subpl	r5, r1, #0, 8
    2b2c:	5f544547 	svcpl	0x00544547
    2b30:	5f555043 	svcpl	0x00555043
    2b34:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2b38:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    2b3c:	41540035 	cmpmi	r4, r5, lsr r0
    2b40:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2b44:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2b48:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
    2b4c:	61676e6f 	cmnvs	r7, pc, ror #28
    2b50:	61006d72 	tstvs	r0, r2, ror sp
    2b54:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2b58:	5f686372 	svcpl	0x00686372
    2b5c:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    2b60:	61003162 	tstvs	r0, r2, ror #2
    2b64:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2b68:	5f686372 	svcpl	0x00686372
    2b6c:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    2b70:	54003262 	strpl	r3, [r0], #-610	; 0xfffffd9e
    2b74:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2b78:	50435f54 	subpl	r5, r3, r4, asr pc
    2b7c:	77695f55 			; <UNDEFINED> instruction: 0x77695f55
    2b80:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    2b84:	6d726100 	ldfvse	f6, [r2, #-0]
    2b88:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2b8c:	00743568 	rsbseq	r3, r4, r8, ror #10
    2b90:	5f617369 	svcpl	0x00617369
    2b94:	5f746962 	svcpl	0x00746962
    2b98:	6100706d 	tstvs	r0, sp, rrx
    2b9c:	6c5f6d72 	mrrcvs	13, 7, r6, pc, cr2	; <UNPREDICTABLE>
    2ba0:	63735f64 	cmnvs	r3, #100, 30	; 0x190
    2ba4:	00646568 	rsbeq	r6, r4, r8, ror #10
    2ba8:	5f6d7261 	svcpl	0x006d7261
    2bac:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2bb0:	00315f38 	eorseq	r5, r1, r8, lsr pc

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
  20:	8b040e42 	blhi	103930 <__bss_end+0xfa1ec>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x3470ec>
  28:	420d0d68 	andmi	r0, sp, #104, 26	; 0x1a00
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008070 	andeq	r8, r0, r0, ror r0
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1fa20c>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xf953c>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080b0 	strheq	r8, [r0], -r0
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xfa23c>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x34713c>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080e8 	andeq	r8, r0, r8, ror #1
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xfa25c>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x34715c>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008114 	andeq	r8, r0, r4, lsl r1
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xfa27c>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x34717c>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008134 	andeq	r8, r0, r4, lsr r1
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xfa29c>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x34719c>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	0000814c 	andeq	r8, r0, ip, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xfa2bc>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x3471bc>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008164 	andeq	r8, r0, r4, ror #2
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xfa2dc>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x3471dc>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	0000817c 	andeq	r8, r0, ip, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xfa2fc>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x3471fc>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	00008188 	andeq	r8, r0, r8, lsl #3
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1fa314>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081e0 	andeq	r8, r0, r0, ror #3
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1fa334>
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
 194:	0000010c 	andeq	r0, r0, ip, lsl #2
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1fa364>
 19c:	42018e02 	andmi	r8, r1, #2, 28
 1a0:	00040b0c 	andeq	r0, r4, ip, lsl #22
 1a4:	0000000c 	andeq	r0, r0, ip
 1a8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 1ac:	7c020001 	stcvc	0, cr0, [r2], {1}
 1b0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 1b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1bc:	00008344 	andeq	r8, r0, r4, asr #6
 1c0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1c4:	8b040e42 	blhi	103ad4 <__bss_end+0xfa390>
 1c8:	0b0d4201 	bleq	3509d4 <__bss_end+0x347290>
 1cc:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1dc:	00008370 	andeq	r8, r0, r0, ror r3
 1e0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1e4:	8b040e42 	blhi	103af4 <__bss_end+0xfa3b0>
 1e8:	0b0d4201 	bleq	3509f4 <__bss_end+0x3472b0>
 1ec:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1fc:	0000839c 	muleq	r0, ip, r3
 200:	0000001c 	andeq	r0, r0, ip, lsl r0
 204:	8b040e42 	blhi	103b14 <__bss_end+0xfa3d0>
 208:	0b0d4201 	bleq	350a14 <__bss_end+0x3472d0>
 20c:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 210:	00000ecb 	andeq	r0, r0, fp, asr #29
 214:	0000001c 	andeq	r0, r0, ip, lsl r0
 218:	000001a4 	andeq	r0, r0, r4, lsr #3
 21c:	000083b8 			; <UNDEFINED> instruction: 0x000083b8
 220:	00000044 	andeq	r0, r0, r4, asr #32
 224:	8b040e42 	blhi	103b34 <__bss_end+0xfa3f0>
 228:	0b0d4201 	bleq	350a34 <__bss_end+0x3472f0>
 22c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 230:	00000ecb 	andeq	r0, r0, fp, asr #29
 234:	0000001c 	andeq	r0, r0, ip, lsl r0
 238:	000001a4 	andeq	r0, r0, r4, lsr #3
 23c:	000083fc 	strdeq	r8, [r0], -ip
 240:	00000050 	andeq	r0, r0, r0, asr r0
 244:	8b040e42 	blhi	103b54 <__bss_end+0xfa410>
 248:	0b0d4201 	bleq	350a54 <__bss_end+0x347310>
 24c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 250:	00000ecb 	andeq	r0, r0, fp, asr #29
 254:	0000001c 	andeq	r0, r0, ip, lsl r0
 258:	000001a4 	andeq	r0, r0, r4, lsr #3
 25c:	0000844c 	andeq	r8, r0, ip, asr #8
 260:	00000050 	andeq	r0, r0, r0, asr r0
 264:	8b040e42 	blhi	103b74 <__bss_end+0xfa430>
 268:	0b0d4201 	bleq	350a74 <__bss_end+0x347330>
 26c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 270:	00000ecb 	andeq	r0, r0, fp, asr #29
 274:	0000001c 	andeq	r0, r0, ip, lsl r0
 278:	000001a4 	andeq	r0, r0, r4, lsr #3
 27c:	0000849c 	muleq	r0, ip, r4
 280:	0000002c 	andeq	r0, r0, ip, lsr #32
 284:	8b040e42 	blhi	103b94 <__bss_end+0xfa450>
 288:	0b0d4201 	bleq	350a94 <__bss_end+0x347350>
 28c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 290:	00000ecb 	andeq	r0, r0, fp, asr #29
 294:	0000001c 	andeq	r0, r0, ip, lsl r0
 298:	000001a4 	andeq	r0, r0, r4, lsr #3
 29c:	000084c8 	andeq	r8, r0, r8, asr #9
 2a0:	00000050 	andeq	r0, r0, r0, asr r0
 2a4:	8b040e42 	blhi	103bb4 <__bss_end+0xfa470>
 2a8:	0b0d4201 	bleq	350ab4 <__bss_end+0x347370>
 2ac:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2bc:	00008518 	andeq	r8, r0, r8, lsl r5
 2c0:	00000044 	andeq	r0, r0, r4, asr #32
 2c4:	8b040e42 	blhi	103bd4 <__bss_end+0xfa490>
 2c8:	0b0d4201 	bleq	350ad4 <__bss_end+0x347390>
 2cc:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 2d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2dc:	0000855c 	andeq	r8, r0, ip, asr r5
 2e0:	00000050 	andeq	r0, r0, r0, asr r0
 2e4:	8b040e42 	blhi	103bf4 <__bss_end+0xfa4b0>
 2e8:	0b0d4201 	bleq	350af4 <__bss_end+0x3473b0>
 2ec:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2fc:	000085ac 	andeq	r8, r0, ip, lsr #11
 300:	00000054 	andeq	r0, r0, r4, asr r0
 304:	8b040e42 	blhi	103c14 <__bss_end+0xfa4d0>
 308:	0b0d4201 	bleq	350b14 <__bss_end+0x3473d0>
 30c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 310:	00000ecb 	andeq	r0, r0, fp, asr #29
 314:	0000001c 	andeq	r0, r0, ip, lsl r0
 318:	000001a4 	andeq	r0, r0, r4, lsr #3
 31c:	00008600 	andeq	r8, r0, r0, lsl #12
 320:	0000003c 	andeq	r0, r0, ip, lsr r0
 324:	8b040e42 	blhi	103c34 <__bss_end+0xfa4f0>
 328:	0b0d4201 	bleq	350b34 <__bss_end+0x3473f0>
 32c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 330:	00000ecb 	andeq	r0, r0, fp, asr #29
 334:	0000001c 	andeq	r0, r0, ip, lsl r0
 338:	000001a4 	andeq	r0, r0, r4, lsr #3
 33c:	0000863c 	andeq	r8, r0, ip, lsr r6
 340:	0000003c 	andeq	r0, r0, ip, lsr r0
 344:	8b040e42 	blhi	103c54 <__bss_end+0xfa510>
 348:	0b0d4201 	bleq	350b54 <__bss_end+0x347410>
 34c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 350:	00000ecb 	andeq	r0, r0, fp, asr #29
 354:	0000001c 	andeq	r0, r0, ip, lsl r0
 358:	000001a4 	andeq	r0, r0, r4, lsr #3
 35c:	00008678 	andeq	r8, r0, r8, ror r6
 360:	0000003c 	andeq	r0, r0, ip, lsr r0
 364:	8b040e42 	blhi	103c74 <__bss_end+0xfa530>
 368:	0b0d4201 	bleq	350b74 <__bss_end+0x347430>
 36c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 370:	00000ecb 	andeq	r0, r0, fp, asr #29
 374:	0000001c 	andeq	r0, r0, ip, lsl r0
 378:	000001a4 	andeq	r0, r0, r4, lsr #3
 37c:	000086b4 			; <UNDEFINED> instruction: 0x000086b4
 380:	0000003c 	andeq	r0, r0, ip, lsr r0
 384:	8b040e42 	blhi	103c94 <__bss_end+0xfa550>
 388:	0b0d4201 	bleq	350b94 <__bss_end+0x347450>
 38c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 390:	00000ecb 	andeq	r0, r0, fp, asr #29
 394:	0000001c 	andeq	r0, r0, ip, lsl r0
 398:	000001a4 	andeq	r0, r0, r4, lsr #3
 39c:	000086f0 	strdeq	r8, [r0], -r0
 3a0:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 3a4:	8b080e42 	blhi	203cb4 <__bss_end+0x1fa570>
 3a8:	42018e02 	andmi	r8, r1, #2, 28
 3ac:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3b0:	080d0c50 	stmdaeq	sp, {r4, r6, sl, fp}
 3b4:	0000000c 	andeq	r0, r0, ip
 3b8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 3bc:	7c020001 	stcvc	0, cr0, [r2], {1}
 3c0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 3c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3c8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3cc:	000087a0 	andeq	r8, r0, r0, lsr #15
 3d0:	00000174 	andeq	r0, r0, r4, ror r1
 3d4:	8b080e42 	blhi	203ce4 <__bss_end+0x1fa5a0>
 3d8:	42018e02 	andmi	r8, r1, #2, 28
 3dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3e0:	080d0cb2 	stmdaeq	sp, {r1, r4, r5, r7, sl, fp}
 3e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3e8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3ec:	00008914 	andeq	r8, r0, r4, lsl r9
 3f0:	0000009c 	muleq	r0, ip, r0
 3f4:	8b040e42 	blhi	103d04 <__bss_end+0xfa5c0>
 3f8:	0b0d4201 	bleq	350c04 <__bss_end+0x3474c0>
 3fc:	0d0d4602 	stceq	6, cr4, [sp, #-8]
 400:	000ecb42 	andeq	ip, lr, r2, asr #22
 404:	0000001c 	andeq	r0, r0, ip, lsl r0
 408:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 40c:	000089b0 			; <UNDEFINED> instruction: 0x000089b0
 410:	000000c0 	andeq	r0, r0, r0, asr #1
 414:	8b040e42 	blhi	103d24 <__bss_end+0xfa5e0>
 418:	0b0d4201 	bleq	350c24 <__bss_end+0x3474e0>
 41c:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 420:	000ecb42 	andeq	ip, lr, r2, asr #22
 424:	0000001c 	andeq	r0, r0, ip, lsl r0
 428:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 42c:	00008a70 	andeq	r8, r0, r0, ror sl
 430:	000000ac 	andeq	r0, r0, ip, lsr #1
 434:	8b040e42 	blhi	103d44 <__bss_end+0xfa600>
 438:	0b0d4201 	bleq	350c44 <__bss_end+0x347500>
 43c:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 440:	000ecb42 	andeq	ip, lr, r2, asr #22
 444:	0000001c 	andeq	r0, r0, ip, lsl r0
 448:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 44c:	00008b1c 	andeq	r8, r0, ip, lsl fp
 450:	00000054 	andeq	r0, r0, r4, asr r0
 454:	8b040e42 	blhi	103d64 <__bss_end+0xfa620>
 458:	0b0d4201 	bleq	350c64 <__bss_end+0x347520>
 45c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 460:	00000ecb 	andeq	r0, r0, fp, asr #29
 464:	0000001c 	andeq	r0, r0, ip, lsl r0
 468:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 46c:	00008b70 	andeq	r8, r0, r0, ror fp
 470:	00000068 	andeq	r0, r0, r8, rrx
 474:	8b040e42 	blhi	103d84 <__bss_end+0xfa640>
 478:	0b0d4201 	bleq	350c84 <__bss_end+0x347540>
 47c:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 480:	00000ecb 	andeq	r0, r0, fp, asr #29
 484:	0000001c 	andeq	r0, r0, ip, lsl r0
 488:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 48c:	00008bd8 	ldrdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 490:	00000080 	andeq	r0, r0, r0, lsl #1
 494:	8b040e42 	blhi	103da4 <__bss_end+0xfa660>
 498:	0b0d4201 	bleq	350ca4 <__bss_end+0x347560>
 49c:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 4a0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4a4:	0000000c 	andeq	r0, r0, ip
 4a8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 4ac:	7c020001 	stcvc	0, cr0, [r2], {1}
 4b0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 4b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4b8:	000004a4 	andeq	r0, r0, r4, lsr #9
 4bc:	00008c58 	andeq	r8, r0, r8, asr ip
 4c0:	00000068 	andeq	r0, r0, r8, rrx
 4c4:	8b080e42 	blhi	203dd4 <__bss_end+0x1fa690>
 4c8:	42018e02 	andmi	r8, r1, #2, 28
 4cc:	6e040b0c 	vmlavs.f64	d0, d4, d12
 4d0:	00080d0c 	andeq	r0, r8, ip, lsl #26
 4d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4d8:	000004a4 	andeq	r0, r0, r4, lsr #9
 4dc:	00008cc0 	andeq	r8, r0, r0, asr #25
 4e0:	0000004c 	andeq	r0, r0, ip, asr #32
 4e4:	8b080e42 	blhi	203df4 <__bss_end+0x1fa6b0>
 4e8:	42018e02 	andmi	r8, r1, #2, 28
 4ec:	60040b0c 	andvs	r0, r4, ip, lsl #22
 4f0:	00080d0c 	andeq	r0, r8, ip, lsl #26
 4f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 4f8:	000004a4 	andeq	r0, r0, r4, lsr #9
 4fc:	00008d0c 	andeq	r8, r0, ip, lsl #26
 500:	00000028 	andeq	r0, r0, r8, lsr #32
 504:	8b040e42 	blhi	103e14 <__bss_end+0xfa6d0>
 508:	0b0d4201 	bleq	350d14 <__bss_end+0x3475d0>
 50c:	420d0d4c 	andmi	r0, sp, #76, 26	; 0x1300
 510:	00000ecb 	andeq	r0, r0, fp, asr #29
 514:	0000001c 	andeq	r0, r0, ip, lsl r0
 518:	000004a4 	andeq	r0, r0, r4, lsr #9
 51c:	00008d34 	andeq	r8, r0, r4, lsr sp
 520:	0000007c 	andeq	r0, r0, ip, ror r0
 524:	8b080e42 	blhi	203e34 <__bss_end+0x1fa6f0>
 528:	42018e02 	andmi	r8, r1, #2, 28
 52c:	78040b0c 	stmdavc	r4, {r2, r3, r8, r9, fp}
 530:	00080d0c 	andeq	r0, r8, ip, lsl #26
 534:	0000001c 	andeq	r0, r0, ip, lsl r0
 538:	000004a4 	andeq	r0, r0, r4, lsr #9
 53c:	00008db0 			; <UNDEFINED> instruction: 0x00008db0
 540:	000000ec 	andeq	r0, r0, ip, ror #1
 544:	8b080e42 	blhi	203e54 <__bss_end+0x1fa710>
 548:	42018e02 	andmi	r8, r1, #2, 28
 54c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 550:	080d0c70 	stmdaeq	sp, {r4, r5, r6, sl, fp}
 554:	0000001c 	andeq	r0, r0, ip, lsl r0
 558:	000004a4 	andeq	r0, r0, r4, lsr #9
 55c:	00008e9c 	muleq	r0, ip, lr
 560:	00000168 	andeq	r0, r0, r8, ror #2
 564:	8b080e42 	blhi	203e74 <__bss_end+0x1fa730>
 568:	42018e02 	andmi	r8, r1, #2, 28
 56c:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 570:	080d0cac 	stmdaeq	sp, {r2, r3, r5, r7, sl, fp}
 574:	0000001c 	andeq	r0, r0, ip, lsl r0
 578:	000004a4 	andeq	r0, r0, r4, lsr #9
 57c:	00009004 	andeq	r9, r0, r4
 580:	00000058 	andeq	r0, r0, r8, asr r0
 584:	8b080e42 	blhi	203e94 <__bss_end+0x1fa750>
 588:	42018e02 	andmi	r8, r1, #2, 28
 58c:	66040b0c 	strvs	r0, [r4], -ip, lsl #22
 590:	00080d0c 	andeq	r0, r8, ip, lsl #26
 594:	0000001c 	andeq	r0, r0, ip, lsl r0
 598:	000004a4 	andeq	r0, r0, r4, lsr #9
 59c:	0000905c 	andeq	r9, r0, ip, asr r0
 5a0:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 5a4:	8b080e42 	blhi	203eb4 <__bss_end+0x1fa770>
 5a8:	42018e02 	andmi	r8, r1, #2, 28
 5ac:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 5b0:	080d0c52 	stmdaeq	sp, {r1, r4, r6, sl, fp}
 5b4:	0000000c 	andeq	r0, r0, ip
 5b8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 5bc:	7c010001 	stcvc	0, cr0, [r1], {1}
 5c0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 5c4:	0000000c 	andeq	r0, r0, ip
 5c8:	000005b4 			; <UNDEFINED> instruction: 0x000005b4
 5cc:	0000910c 	andeq	r9, r0, ip, lsl #2
 5d0:	000001ec 	andeq	r0, r0, ip, ror #3
