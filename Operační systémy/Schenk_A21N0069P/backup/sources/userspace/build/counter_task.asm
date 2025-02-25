
./counter_task:     file format elf32-littlearm


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
    8068:	00008fbc 			; <UNDEFINED> instruction: 0x00008fbc
    806c:	00008fcc 	andeq	r8, r0, ip, asr #31

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
    81d8:	00008fb9 			; <UNDEFINED> instruction: 0x00008fb9
    81dc:	00008fb9 			; <UNDEFINED> instruction: 0x00008fb9

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
    8230:	00008fb9 			; <UNDEFINED> instruction: 0x00008fb9
    8234:	00008fb9 			; <UNDEFINED> instruction: 0x00008fb9

00008238 <main>:
main():
/home/schenkj/os2022/sp/sources/userspace/counter_task/main.cpp:17
 *  - vzestupne pokud je prepinac 1 v poloze "zapnuto", jinak sestupne
 *  - rychle pokud je prepinac 2 v poloze "zapnuto", jinak pomalu
 **/

int main(int argc, char** argv)
{
    8238:	e92d4800 	push	{fp, lr}
    823c:	e28db004 	add	fp, sp, #4
    8240:	e24dd020 	sub	sp, sp, #32
    8244:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
    8248:	e50b1024 	str	r1, [fp, #-36]	; 0xffffffdc
/home/schenkj/os2022/sp/sources/userspace/counter_task/main.cpp:18
	uint32_t display_file = open("DEV:segd", NFile_Open_Mode::Write_Only);
    824c:	e3a01001 	mov	r1, #1
    8250:	e59f0164 	ldr	r0, [pc, #356]	; 83bc <main+0x184>
    8254:	eb000079 	bl	8440 <_Z4openPKc15NFile_Open_Mode>
    8258:	e50b000c 	str	r0, [fp, #-12]
/home/schenkj/os2022/sp/sources/userspace/counter_task/main.cpp:19
	uint32_t switch1_file = open("DEV:gpio/4", NFile_Open_Mode::Read_Only);
    825c:	e3a01000 	mov	r1, #0
    8260:	e59f0158 	ldr	r0, [pc, #344]	; 83c0 <main+0x188>
    8264:	eb000075 	bl	8440 <_Z4openPKc15NFile_Open_Mode>
    8268:	e50b0010 	str	r0, [fp, #-16]
/home/schenkj/os2022/sp/sources/userspace/counter_task/main.cpp:20
	uint32_t switch2_file = open("DEV:gpio/17", NFile_Open_Mode::Read_Only);
    826c:	e3a01000 	mov	r1, #0
    8270:	e59f014c 	ldr	r0, [pc, #332]	; 83c4 <main+0x18c>
    8274:	eb000071 	bl	8440 <_Z4openPKc15NFile_Open_Mode>
    8278:	e50b0014 	str	r0, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/userspace/counter_task/main.cpp:22

	unsigned int counter = 0;
    827c:	e3a03000 	mov	r3, #0
    8280:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/userspace/counter_task/main.cpp:23
	bool fast = false;
    8284:	e3a03000 	mov	r3, #0
    8288:	e54b3015 	strb	r3, [fp, #-21]	; 0xffffffeb
/home/schenkj/os2022/sp/sources/userspace/counter_task/main.cpp:24
	bool ascending = true;
    828c:	e3a03001 	mov	r3, #1
    8290:	e54b3016 	strb	r3, [fp, #-22]	; 0xffffffea
/home/schenkj/os2022/sp/sources/userspace/counter_task/main.cpp:26

	set_task_deadline(fast ? 0x1000 : 0x2800);
    8294:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    8298:	e3530000 	cmp	r3, #0
    829c:	0a000001 	beq	82a8 <main+0x70>
/home/schenkj/os2022/sp/sources/userspace/counter_task/main.cpp:26 (discriminator 1)
    82a0:	e3a03a01 	mov	r3, #4096	; 0x1000
    82a4:	ea000000 	b	82ac <main+0x74>
/home/schenkj/os2022/sp/sources/userspace/counter_task/main.cpp:26 (discriminator 2)
    82a8:	e3a03b0a 	mov	r3, #10240	; 0x2800
/home/schenkj/os2022/sp/sources/userspace/counter_task/main.cpp:26 (discriminator 4)
    82ac:	e1a00003 	mov	r0, r3
    82b0:	eb000112 	bl	8700 <_Z17set_task_deadlinej>
/home/schenkj/os2022/sp/sources/userspace/counter_task/main.cpp:30

	while (true)
	{
		char tmp = '0';
    82b4:	e3a03030 	mov	r3, #48	; 0x30
    82b8:	e54b3017 	strb	r3, [fp, #-23]	; 0xffffffe9
/home/schenkj/os2022/sp/sources/userspace/counter_task/main.cpp:32

		read(switch1_file, &tmp, 1);
    82bc:	e24b3017 	sub	r3, fp, #23
    82c0:	e3a02001 	mov	r2, #1
    82c4:	e1a01003 	mov	r1, r3
    82c8:	e51b0010 	ldr	r0, [fp, #-16]
    82cc:	eb00006c 	bl	8484 <_Z4readjPcj>
/home/schenkj/os2022/sp/sources/userspace/counter_task/main.cpp:33
		ascending = (tmp == '1');
    82d0:	e55b3017 	ldrb	r3, [fp, #-23]	; 0xffffffe9
    82d4:	e3530031 	cmp	r3, #49	; 0x31
    82d8:	03a03001 	moveq	r3, #1
    82dc:	13a03000 	movne	r3, #0
    82e0:	e54b3016 	strb	r3, [fp, #-22]	; 0xffffffea
/home/schenkj/os2022/sp/sources/userspace/counter_task/main.cpp:35

		read(switch2_file, &tmp, 1);
    82e4:	e24b3017 	sub	r3, fp, #23
    82e8:	e3a02001 	mov	r2, #1
    82ec:	e1a01003 	mov	r1, r3
    82f0:	e51b0014 	ldr	r0, [fp, #-20]	; 0xffffffec
    82f4:	eb000062 	bl	8484 <_Z4readjPcj>
/home/schenkj/os2022/sp/sources/userspace/counter_task/main.cpp:36
		fast = (tmp == '1');
    82f8:	e55b3017 	ldrb	r3, [fp, #-23]	; 0xffffffe9
    82fc:	e3530031 	cmp	r3, #49	; 0x31
    8300:	03a03001 	moveq	r3, #1
    8304:	13a03000 	movne	r3, #0
    8308:	e54b3015 	strb	r3, [fp, #-21]	; 0xffffffeb
/home/schenkj/os2022/sp/sources/userspace/counter_task/main.cpp:38

		if (ascending)
    830c:	e55b3016 	ldrb	r3, [fp, #-22]	; 0xffffffea
    8310:	e3530000 	cmp	r3, #0
    8314:	0a000003 	beq	8328 <main+0xf0>
/home/schenkj/os2022/sp/sources/userspace/counter_task/main.cpp:39
			counter++;
    8318:	e51b3008 	ldr	r3, [fp, #-8]
    831c:	e2833001 	add	r3, r3, #1
    8320:	e50b3008 	str	r3, [fp, #-8]
    8324:	ea000002 	b	8334 <main+0xfc>
/home/schenkj/os2022/sp/sources/userspace/counter_task/main.cpp:41
		else
			counter--;
    8328:	e51b3008 	ldr	r3, [fp, #-8]
    832c:	e2433001 	sub	r3, r3, #1
    8330:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/userspace/counter_task/main.cpp:43

		tmp = '0' + (counter % 10);
    8334:	e51b1008 	ldr	r1, [fp, #-8]
    8338:	e59f3088 	ldr	r3, [pc, #136]	; 83c8 <main+0x190>
    833c:	e0832193 	umull	r2, r3, r3, r1
    8340:	e1a021a3 	lsr	r2, r3, #3
    8344:	e1a03002 	mov	r3, r2
    8348:	e1a03103 	lsl	r3, r3, #2
    834c:	e0833002 	add	r3, r3, r2
    8350:	e1a03083 	lsl	r3, r3, #1
    8354:	e0412003 	sub	r2, r1, r3
    8358:	e6ef3072 	uxtb	r3, r2
    835c:	e2833030 	add	r3, r3, #48	; 0x30
    8360:	e6ef3073 	uxtb	r3, r3
    8364:	e54b3017 	strb	r3, [fp, #-23]	; 0xffffffe9
/home/schenkj/os2022/sp/sources/userspace/counter_task/main.cpp:44
		write(display_file, &tmp, 1);
    8368:	e24b3017 	sub	r3, fp, #23
    836c:	e3a02001 	mov	r2, #1
    8370:	e1a01003 	mov	r1, r3
    8374:	e51b000c 	ldr	r0, [fp, #-12]
    8378:	eb000055 	bl	84d4 <_Z5writejPKcj>
/home/schenkj/os2022/sp/sources/userspace/counter_task/main.cpp:46

		sleep(fast ? 0x400 : 0x600, fast ? 0x1000 : 0x2800);
    837c:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    8380:	e3530000 	cmp	r3, #0
    8384:	0a000001 	beq	8390 <main+0x158>
/home/schenkj/os2022/sp/sources/userspace/counter_task/main.cpp:46 (discriminator 1)
    8388:	e3a02b01 	mov	r2, #1024	; 0x400
    838c:	ea000000 	b	8394 <main+0x15c>
/home/schenkj/os2022/sp/sources/userspace/counter_task/main.cpp:46 (discriminator 2)
    8390:	e3a02c06 	mov	r2, #1536	; 0x600
/home/schenkj/os2022/sp/sources/userspace/counter_task/main.cpp:46 (discriminator 4)
    8394:	e55b3015 	ldrb	r3, [fp, #-21]	; 0xffffffeb
    8398:	e3530000 	cmp	r3, #0
    839c:	0a000001 	beq	83a8 <main+0x170>
/home/schenkj/os2022/sp/sources/userspace/counter_task/main.cpp:46 (discriminator 5)
    83a0:	e3a03a01 	mov	r3, #4096	; 0x1000
    83a4:	ea000000 	b	83ac <main+0x174>
/home/schenkj/os2022/sp/sources/userspace/counter_task/main.cpp:46 (discriminator 6)
    83a8:	e3a03b0a 	mov	r3, #10240	; 0x2800
/home/schenkj/os2022/sp/sources/userspace/counter_task/main.cpp:46 (discriminator 8)
    83ac:	e1a01003 	mov	r1, r3
    83b0:	e1a00002 	mov	r0, r2
    83b4:	eb00009e 	bl	8634 <_Z5sleepjj>
/home/schenkj/os2022/sp/sources/userspace/counter_task/main.cpp:47 (discriminator 8)
	}
    83b8:	eaffffbd 	b	82b4 <main+0x7c>
    83bc:	00008f4c 	andeq	r8, r0, ip, asr #30
    83c0:	00008f58 	andeq	r8, r0, r8, asr pc
    83c4:	00008f64 	andeq	r8, r0, r4, ror #30
    83c8:	cccccccd 	stclgt	12, cr12, [ip], {205}	; 0xcd

000083cc <_Z6getpidv>:
_Z6getpidv():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:5
#include <stdfile.h>
#include <stdstring.h>

uint32_t getpid()
{
    83cc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83d0:	e28db000 	add	fp, sp, #0
    83d4:	e24dd00c 	sub	sp, sp, #12
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:8
    uint32_t pid;

    asm volatile("swi 0");
    83d8:	ef000000 	svc	0x00000000
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:9
    asm volatile("mov %0, r0" : "=r" (pid));
    83dc:	e1a03000 	mov	r3, r0
    83e0:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:11

    return pid;
    83e4:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:12
}
    83e8:	e1a00003 	mov	r0, r3
    83ec:	e28bd000 	add	sp, fp, #0
    83f0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83f4:	e12fff1e 	bx	lr

000083f8 <_Z9terminatei>:
_Z9terminatei():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:15

void terminate(int exitcode)
{
    83f8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83fc:	e28db000 	add	fp, sp, #0
    8400:	e24dd00c 	sub	sp, sp, #12
    8404:	e50b0008 	str	r0, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:16
    asm volatile("mov r0, %0" : : "r" (exitcode));
    8408:	e51b3008 	ldr	r3, [fp, #-8]
    840c:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:17
    asm volatile("swi 1");
    8410:	ef000001 	svc	0x00000001
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:18
}
    8414:	e320f000 	nop	{0}
    8418:	e28bd000 	add	sp, fp, #0
    841c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8420:	e12fff1e 	bx	lr

00008424 <_Z11sched_yieldv>:
_Z11sched_yieldv():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:21

void sched_yield()
{
    8424:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8428:	e28db000 	add	fp, sp, #0
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:22
    asm volatile("swi 2");
    842c:	ef000002 	svc	0x00000002
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:23
}
    8430:	e320f000 	nop	{0}
    8434:	e28bd000 	add	sp, fp, #0
    8438:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    843c:	e12fff1e 	bx	lr

00008440 <_Z4openPKc15NFile_Open_Mode>:
_Z4openPKc15NFile_Open_Mode():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:26

uint32_t open(const char* filename, NFile_Open_Mode mode)
{
    8440:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8444:	e28db000 	add	fp, sp, #0
    8448:	e24dd014 	sub	sp, sp, #20
    844c:	e50b0010 	str	r0, [fp, #-16]
    8450:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:29
    uint32_t file;

    asm volatile("mov r0, %0" : : "r" (filename));
    8454:	e51b3010 	ldr	r3, [fp, #-16]
    8458:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:30
    asm volatile("mov r1, %0" : : "r" (mode));
    845c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8460:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:31
    asm volatile("swi 64");
    8464:	ef000040 	svc	0x00000040
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:32
    asm volatile("mov %0, r0" : "=r" (file));
    8468:	e1a03000 	mov	r3, r0
    846c:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:34

    return file;
    8470:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:35
}
    8474:	e1a00003 	mov	r0, r3
    8478:	e28bd000 	add	sp, fp, #0
    847c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8480:	e12fff1e 	bx	lr

00008484 <_Z4readjPcj>:
_Z4readjPcj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:38

uint32_t read(uint32_t file, char* const buffer, uint32_t size)
{
    8484:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8488:	e28db000 	add	fp, sp, #0
    848c:	e24dd01c 	sub	sp, sp, #28
    8490:	e50b0010 	str	r0, [fp, #-16]
    8494:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8498:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:41
    uint32_t rdnum;

    asm volatile("mov r0, %0" : : "r" (file));
    849c:	e51b3010 	ldr	r3, [fp, #-16]
    84a0:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:42
    asm volatile("mov r1, %0" : : "r" (buffer));
    84a4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84a8:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:43
    asm volatile("mov r2, %0" : : "r" (size));
    84ac:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    84b0:	e1a02003 	mov	r2, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:44
    asm volatile("swi 65");
    84b4:	ef000041 	svc	0x00000041
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:45
    asm volatile("mov %0, r0" : "=r" (rdnum));
    84b8:	e1a03000 	mov	r3, r0
    84bc:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:47

    return rdnum;
    84c0:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:48
}
    84c4:	e1a00003 	mov	r0, r3
    84c8:	e28bd000 	add	sp, fp, #0
    84cc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    84d0:	e12fff1e 	bx	lr

000084d4 <_Z5writejPKcj>:
_Z5writejPKcj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:51

uint32_t write(uint32_t file, const char* buffer, uint32_t size)
{
    84d4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    84d8:	e28db000 	add	fp, sp, #0
    84dc:	e24dd01c 	sub	sp, sp, #28
    84e0:	e50b0010 	str	r0, [fp, #-16]
    84e4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    84e8:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:54
    uint32_t wrnum;

    asm volatile("mov r0, %0" : : "r" (file));
    84ec:	e51b3010 	ldr	r3, [fp, #-16]
    84f0:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:55
    asm volatile("mov r1, %0" : : "r" (buffer));
    84f4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84f8:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:56
    asm volatile("mov r2, %0" : : "r" (size));
    84fc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8500:	e1a02003 	mov	r2, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:57
    asm volatile("swi 66");
    8504:	ef000042 	svc	0x00000042
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:58
    asm volatile("mov %0, r0" : "=r" (wrnum));
    8508:	e1a03000 	mov	r3, r0
    850c:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:60

    return wrnum;
    8510:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:61
}
    8514:	e1a00003 	mov	r0, r3
    8518:	e28bd000 	add	sp, fp, #0
    851c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8520:	e12fff1e 	bx	lr

00008524 <_Z5closej>:
_Z5closej():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:64

void close(uint32_t file)
{
    8524:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8528:	e28db000 	add	fp, sp, #0
    852c:	e24dd00c 	sub	sp, sp, #12
    8530:	e50b0008 	str	r0, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:65
    asm volatile("mov r0, %0" : : "r" (file));
    8534:	e51b3008 	ldr	r3, [fp, #-8]
    8538:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:66
    asm volatile("swi 67");
    853c:	ef000043 	svc	0x00000043
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:67
}
    8540:	e320f000 	nop	{0}
    8544:	e28bd000 	add	sp, fp, #0
    8548:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    854c:	e12fff1e 	bx	lr

00008550 <_Z5ioctlj16NIOCtl_OperationPv>:
_Z5ioctlj16NIOCtl_OperationPv():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:70

uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param)
{
    8550:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8554:	e28db000 	add	fp, sp, #0
    8558:	e24dd01c 	sub	sp, sp, #28
    855c:	e50b0010 	str	r0, [fp, #-16]
    8560:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8564:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:73
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    8568:	e51b3010 	ldr	r3, [fp, #-16]
    856c:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:74
    asm volatile("mov r1, %0" : : "r" (operation));
    8570:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8574:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:75
    asm volatile("mov r2, %0" : : "r" (param));
    8578:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    857c:	e1a02003 	mov	r2, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:76
    asm volatile("swi 68");
    8580:	ef000044 	svc	0x00000044
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:77
    asm volatile("mov %0, r0" : "=r" (retcode));
    8584:	e1a03000 	mov	r3, r0
    8588:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:79

    return retcode;
    858c:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:80
}
    8590:	e1a00003 	mov	r0, r3
    8594:	e28bd000 	add	sp, fp, #0
    8598:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    859c:	e12fff1e 	bx	lr

000085a0 <_Z6notifyjj>:
_Z6notifyjj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:83

uint32_t notify(uint32_t file, uint32_t count)
{
    85a0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85a4:	e28db000 	add	fp, sp, #0
    85a8:	e24dd014 	sub	sp, sp, #20
    85ac:	e50b0010 	str	r0, [fp, #-16]
    85b0:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:86
    uint32_t retcnt;

    asm volatile("mov r0, %0" : : "r" (file));
    85b4:	e51b3010 	ldr	r3, [fp, #-16]
    85b8:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:87
    asm volatile("mov r1, %0" : : "r" (count));
    85bc:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    85c0:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:88
    asm volatile("swi 69");
    85c4:	ef000045 	svc	0x00000045
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:89
    asm volatile("mov %0, r0" : "=r" (retcnt));
    85c8:	e1a03000 	mov	r3, r0
    85cc:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:91

    return retcnt;
    85d0:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:92
}
    85d4:	e1a00003 	mov	r0, r3
    85d8:	e28bd000 	add	sp, fp, #0
    85dc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85e0:	e12fff1e 	bx	lr

000085e4 <_Z4waitjjj>:
_Z4waitjjj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:95

NSWI_Result_Code wait(uint32_t file, uint32_t count, uint32_t notified_deadline)
{
    85e4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85e8:	e28db000 	add	fp, sp, #0
    85ec:	e24dd01c 	sub	sp, sp, #28
    85f0:	e50b0010 	str	r0, [fp, #-16]
    85f4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    85f8:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:98
    NSWI_Result_Code retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    85fc:	e51b3010 	ldr	r3, [fp, #-16]
    8600:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:99
    asm volatile("mov r1, %0" : : "r" (count));
    8604:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8608:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:100
    asm volatile("mov r2, %0" : : "r" (notified_deadline));
    860c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8610:	e1a02003 	mov	r2, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:101
    asm volatile("swi 70");
    8614:	ef000046 	svc	0x00000046
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:102
    asm volatile("mov %0, r0" : "=r" (retcode));
    8618:	e1a03000 	mov	r3, r0
    861c:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:104

    return retcode;
    8620:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:105
}
    8624:	e1a00003 	mov	r0, r3
    8628:	e28bd000 	add	sp, fp, #0
    862c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8630:	e12fff1e 	bx	lr

00008634 <_Z5sleepjj>:
_Z5sleepjj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:108

bool sleep(uint32_t ticks, uint32_t notified_deadline)
{
    8634:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8638:	e28db000 	add	fp, sp, #0
    863c:	e24dd014 	sub	sp, sp, #20
    8640:	e50b0010 	str	r0, [fp, #-16]
    8644:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:111
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (ticks));
    8648:	e51b3010 	ldr	r3, [fp, #-16]
    864c:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:112
    asm volatile("mov r1, %0" : : "r" (notified_deadline));
    8650:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8654:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:113
    asm volatile("swi 3");
    8658:	ef000003 	svc	0x00000003
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:114
    asm volatile("mov %0, r0" : "=r" (retcode));
    865c:	e1a03000 	mov	r3, r0
    8660:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:116

    return retcode;
    8664:	e51b3008 	ldr	r3, [fp, #-8]
    8668:	e3530000 	cmp	r3, #0
    866c:	13a03001 	movne	r3, #1
    8670:	03a03000 	moveq	r3, #0
    8674:	e6ef3073 	uxtb	r3, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:117
}
    8678:	e1a00003 	mov	r0, r3
    867c:	e28bd000 	add	sp, fp, #0
    8680:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8684:	e12fff1e 	bx	lr

00008688 <_Z24get_active_process_countv>:
_Z24get_active_process_countv():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:120

uint32_t get_active_process_count()
{
    8688:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    868c:	e28db000 	add	fp, sp, #0
    8690:	e24dd00c 	sub	sp, sp, #12
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:121
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Active_Process_Count;
    8694:	e3a03000 	mov	r3, #0
    8698:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:124
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    869c:	e3a03000 	mov	r3, #0
    86a0:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:125
    asm volatile("mov r1, %0" : : "r" (&retval));
    86a4:	e24b300c 	sub	r3, fp, #12
    86a8:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:126
    asm volatile("swi 4");
    86ac:	ef000004 	svc	0x00000004
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:128

    return retval;
    86b0:	e51b300c 	ldr	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:129
}
    86b4:	e1a00003 	mov	r0, r3
    86b8:	e28bd000 	add	sp, fp, #0
    86bc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86c0:	e12fff1e 	bx	lr

000086c4 <_Z14get_tick_countv>:
_Z14get_tick_countv():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:132

uint32_t get_tick_count()
{
    86c4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    86c8:	e28db000 	add	fp, sp, #0
    86cc:	e24dd00c 	sub	sp, sp, #12
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:133
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Tick_Count;
    86d0:	e3a03001 	mov	r3, #1
    86d4:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:136
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    86d8:	e3a03001 	mov	r3, #1
    86dc:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:137
    asm volatile("mov r1, %0" : : "r" (&retval));
    86e0:	e24b300c 	sub	r3, fp, #12
    86e4:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:138
    asm volatile("swi 4");
    86e8:	ef000004 	svc	0x00000004
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:140

    return retval;
    86ec:	e51b300c 	ldr	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:141
}
    86f0:	e1a00003 	mov	r0, r3
    86f4:	e28bd000 	add	sp, fp, #0
    86f8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    86fc:	e12fff1e 	bx	lr

00008700 <_Z17set_task_deadlinej>:
_Z17set_task_deadlinej():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:144

void set_task_deadline(uint32_t tick_count_required)
{
    8700:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8704:	e28db000 	add	fp, sp, #0
    8708:	e24dd014 	sub	sp, sp, #20
    870c:	e50b0010 	str	r0, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:145
    const NDeadline_Subservice req = NDeadline_Subservice::Set_Relative;
    8710:	e3a03000 	mov	r3, #0
    8714:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:147

    asm volatile("mov r0, %0" : : "r" (req));
    8718:	e3a03000 	mov	r3, #0
    871c:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:148
    asm volatile("mov r1, %0" : : "r" (&tick_count_required));
    8720:	e24b3010 	sub	r3, fp, #16
    8724:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:149
    asm volatile("swi 5");
    8728:	ef000005 	svc	0x00000005
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:150
}
    872c:	e320f000 	nop	{0}
    8730:	e28bd000 	add	sp, fp, #0
    8734:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8738:	e12fff1e 	bx	lr

0000873c <_Z26get_task_ticks_to_deadlinev>:
_Z26get_task_ticks_to_deadlinev():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:153

uint32_t get_task_ticks_to_deadline()
{
    873c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8740:	e28db000 	add	fp, sp, #0
    8744:	e24dd00c 	sub	sp, sp, #12
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:154
    const NDeadline_Subservice req = NDeadline_Subservice::Get_Remaining;
    8748:	e3a03001 	mov	r3, #1
    874c:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:157
    uint32_t ticks;

    asm volatile("mov r0, %0" : : "r" (req));
    8750:	e3a03001 	mov	r3, #1
    8754:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:158
    asm volatile("mov r1, %0" : : "r" (&ticks));
    8758:	e24b300c 	sub	r3, fp, #12
    875c:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:159
    asm volatile("swi 5");
    8760:	ef000005 	svc	0x00000005
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:161

    return ticks;
    8764:	e51b300c 	ldr	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:162
}
    8768:	e1a00003 	mov	r0, r3
    876c:	e28bd000 	add	sp, fp, #0
    8770:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8774:	e12fff1e 	bx	lr

00008778 <_Z4pipePKcj>:
_Z4pipePKcj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:167

const char Pipe_File_Prefix[] = "SYS:pipe/";

uint32_t pipe(const char* name, uint32_t buf_size)
{
    8778:	e92d4800 	push	{fp, lr}
    877c:	e28db004 	add	fp, sp, #4
    8780:	e24dd050 	sub	sp, sp, #80	; 0x50
    8784:	e50b0050 	str	r0, [fp, #-80]	; 0xffffffb0
    8788:	e50b1054 	str	r1, [fp, #-84]	; 0xffffffac
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:169
    char fname[64];
    strncpy(fname, Pipe_File_Prefix, sizeof(Pipe_File_Prefix));
    878c:	e24b3048 	sub	r3, fp, #72	; 0x48
    8790:	e3a0200a 	mov	r2, #10
    8794:	e59f1088 	ldr	r1, [pc, #136]	; 8824 <_Z4pipePKcj+0xac>
    8798:	e1a00003 	mov	r0, r3
    879c:	eb0000a5 	bl	8a38 <_Z7strncpyPcPKci>
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:170
    strncpy(fname + sizeof(Pipe_File_Prefix), name, sizeof(fname) - sizeof(Pipe_File_Prefix) - 1);
    87a0:	e24b3048 	sub	r3, fp, #72	; 0x48
    87a4:	e283300a 	add	r3, r3, #10
    87a8:	e3a02035 	mov	r2, #53	; 0x35
    87ac:	e51b1050 	ldr	r1, [fp, #-80]	; 0xffffffb0
    87b0:	e1a00003 	mov	r0, r3
    87b4:	eb00009f 	bl	8a38 <_Z7strncpyPcPKci>
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:172

    int ncur = sizeof(Pipe_File_Prefix) + strlen(name);
    87b8:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    87bc:	eb0000f8 	bl	8ba4 <_Z6strlenPKc>
    87c0:	e1a03000 	mov	r3, r0
    87c4:	e283300a 	add	r3, r3, #10
    87c8:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:174

    fname[ncur++] = '#';
    87cc:	e51b3008 	ldr	r3, [fp, #-8]
    87d0:	e2832001 	add	r2, r3, #1
    87d4:	e50b2008 	str	r2, [fp, #-8]
    87d8:	e24b2004 	sub	r2, fp, #4
    87dc:	e0823003 	add	r3, r2, r3
    87e0:	e3a02023 	mov	r2, #35	; 0x23
    87e4:	e5432044 	strb	r2, [r3, #-68]	; 0xffffffbc
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:176

    itoa(buf_size, &fname[ncur], 10);
    87e8:	e24b2048 	sub	r2, fp, #72	; 0x48
    87ec:	e51b3008 	ldr	r3, [fp, #-8]
    87f0:	e0823003 	add	r3, r2, r3
    87f4:	e3a0200a 	mov	r2, #10
    87f8:	e1a01003 	mov	r1, r3
    87fc:	e51b0054 	ldr	r0, [fp, #-84]	; 0xffffffac
    8800:	eb000008 	bl	8828 <_Z4itoajPcj>
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:178

    return open(fname, NFile_Open_Mode::Read_Write);
    8804:	e24b3048 	sub	r3, fp, #72	; 0x48
    8808:	e3a01002 	mov	r1, #2
    880c:	e1a00003 	mov	r0, r3
    8810:	ebffff0a 	bl	8440 <_Z4openPKc15NFile_Open_Mode>
    8814:	e1a03000 	mov	r3, r0
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:179
}
    8818:	e1a00003 	mov	r0, r3
    881c:	e24bd004 	sub	sp, fp, #4
    8820:	e8bd8800 	pop	{fp, pc}
    8824:	00008f9c 	muleq	r0, ip, pc	; <UNPREDICTABLE>

00008828 <_Z4itoajPcj>:
_Z4itoajPcj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:9
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(unsigned int input, char* output, unsigned int base)
{
    8828:	e92d4800 	push	{fp, lr}
    882c:	e28db004 	add	fp, sp, #4
    8830:	e24dd020 	sub	sp, sp, #32
    8834:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8838:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    883c:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:10
	int i = 0;
    8840:	e3a03000 	mov	r3, #0
    8844:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:12

	while (input > 0)
    8848:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    884c:	e3530000 	cmp	r3, #0
    8850:	0a000014 	beq	88a8 <_Z4itoajPcj+0x80>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:14
	{
		output[i] = CharConvArr[input % base];
    8854:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8858:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    885c:	e1a00003 	mov	r0, r3
    8860:	eb000199 	bl	8ecc <__aeabi_uidivmod>
    8864:	e1a03001 	mov	r3, r1
    8868:	e1a01003 	mov	r1, r3
    886c:	e51b3008 	ldr	r3, [fp, #-8]
    8870:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8874:	e0823003 	add	r3, r2, r3
    8878:	e59f2118 	ldr	r2, [pc, #280]	; 8998 <_Z4itoajPcj+0x170>
    887c:	e7d22001 	ldrb	r2, [r2, r1]
    8880:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:15
		input /= base;
    8884:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    8888:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    888c:	eb000113 	bl	8ce0 <__udivsi3>
    8890:	e1a03000 	mov	r3, r0
    8894:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:16
		i++;
    8898:	e51b3008 	ldr	r3, [fp, #-8]
    889c:	e2833001 	add	r3, r3, #1
    88a0:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:12
	while (input > 0)
    88a4:	eaffffe7 	b	8848 <_Z4itoajPcj+0x20>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:19
	}

    if (i == 0)
    88a8:	e51b3008 	ldr	r3, [fp, #-8]
    88ac:	e3530000 	cmp	r3, #0
    88b0:	1a000007 	bne	88d4 <_Z4itoajPcj+0xac>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:21
    {
        output[i] = CharConvArr[0];
    88b4:	e51b3008 	ldr	r3, [fp, #-8]
    88b8:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    88bc:	e0823003 	add	r3, r2, r3
    88c0:	e3a02030 	mov	r2, #48	; 0x30
    88c4:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:22
        i++;
    88c8:	e51b3008 	ldr	r3, [fp, #-8]
    88cc:	e2833001 	add	r3, r3, #1
    88d0:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:25
    }

	output[i] = '\0';
    88d4:	e51b3008 	ldr	r3, [fp, #-8]
    88d8:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    88dc:	e0823003 	add	r3, r2, r3
    88e0:	e3a02000 	mov	r2, #0
    88e4:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:26
	i--;
    88e8:	e51b3008 	ldr	r3, [fp, #-8]
    88ec:	e2433001 	sub	r3, r3, #1
    88f0:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:28

	for (int j = 0; j <= i/2; j++)
    88f4:	e3a03000 	mov	r3, #0
    88f8:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:28 (discriminator 3)
    88fc:	e51b3008 	ldr	r3, [fp, #-8]
    8900:	e1a02fa3 	lsr	r2, r3, #31
    8904:	e0823003 	add	r3, r2, r3
    8908:	e1a030c3 	asr	r3, r3, #1
    890c:	e1a02003 	mov	r2, r3
    8910:	e51b300c 	ldr	r3, [fp, #-12]
    8914:	e1530002 	cmp	r3, r2
    8918:	ca00001b 	bgt	898c <_Z4itoajPcj+0x164>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:30 (discriminator 2)
	{
		char c = output[i - j];
    891c:	e51b2008 	ldr	r2, [fp, #-8]
    8920:	e51b300c 	ldr	r3, [fp, #-12]
    8924:	e0423003 	sub	r3, r2, r3
    8928:	e1a02003 	mov	r2, r3
    892c:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8930:	e0833002 	add	r3, r3, r2
    8934:	e5d33000 	ldrb	r3, [r3]
    8938:	e54b300d 	strb	r3, [fp, #-13]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:31 (discriminator 2)
		output[i - j] = output[j];
    893c:	e51b300c 	ldr	r3, [fp, #-12]
    8940:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8944:	e0822003 	add	r2, r2, r3
    8948:	e51b1008 	ldr	r1, [fp, #-8]
    894c:	e51b300c 	ldr	r3, [fp, #-12]
    8950:	e0413003 	sub	r3, r1, r3
    8954:	e1a01003 	mov	r1, r3
    8958:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    895c:	e0833001 	add	r3, r3, r1
    8960:	e5d22000 	ldrb	r2, [r2]
    8964:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:32 (discriminator 2)
		output[j] = c;
    8968:	e51b300c 	ldr	r3, [fp, #-12]
    896c:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8970:	e0823003 	add	r3, r2, r3
    8974:	e55b200d 	ldrb	r2, [fp, #-13]
    8978:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:28 (discriminator 2)
	for (int j = 0; j <= i/2; j++)
    897c:	e51b300c 	ldr	r3, [fp, #-12]
    8980:	e2833001 	add	r3, r3, #1
    8984:	e50b300c 	str	r3, [fp, #-12]
    8988:	eaffffdb 	b	88fc <_Z4itoajPcj+0xd4>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:34
	}
}
    898c:	e320f000 	nop	{0}
    8990:	e24bd004 	sub	sp, fp, #4
    8994:	e8bd8800 	pop	{fp, pc}
    8998:	00008fa8 	andeq	r8, r0, r8, lsr #31

0000899c <_Z4atoiPKc>:
_Z4atoiPKc():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:37

int atoi(const char* input)
{
    899c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    89a0:	e28db000 	add	fp, sp, #0
    89a4:	e24dd014 	sub	sp, sp, #20
    89a8:	e50b0010 	str	r0, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:38
	int output = 0;
    89ac:	e3a03000 	mov	r3, #0
    89b0:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:40

	while (*input != '\0')
    89b4:	e51b3010 	ldr	r3, [fp, #-16]
    89b8:	e5d33000 	ldrb	r3, [r3]
    89bc:	e3530000 	cmp	r3, #0
    89c0:	0a000017 	beq	8a24 <_Z4atoiPKc+0x88>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:42
	{
		output *= 10;
    89c4:	e51b2008 	ldr	r2, [fp, #-8]
    89c8:	e1a03002 	mov	r3, r2
    89cc:	e1a03103 	lsl	r3, r3, #2
    89d0:	e0833002 	add	r3, r3, r2
    89d4:	e1a03083 	lsl	r3, r3, #1
    89d8:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:43
		if (*input > '9' || *input < '0')
    89dc:	e51b3010 	ldr	r3, [fp, #-16]
    89e0:	e5d33000 	ldrb	r3, [r3]
    89e4:	e3530039 	cmp	r3, #57	; 0x39
    89e8:	8a00000d 	bhi	8a24 <_Z4atoiPKc+0x88>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:43 (discriminator 1)
    89ec:	e51b3010 	ldr	r3, [fp, #-16]
    89f0:	e5d33000 	ldrb	r3, [r3]
    89f4:	e353002f 	cmp	r3, #47	; 0x2f
    89f8:	9a000009 	bls	8a24 <_Z4atoiPKc+0x88>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:46
			break;

		output += *input - '0';
    89fc:	e51b3010 	ldr	r3, [fp, #-16]
    8a00:	e5d33000 	ldrb	r3, [r3]
    8a04:	e2433030 	sub	r3, r3, #48	; 0x30
    8a08:	e51b2008 	ldr	r2, [fp, #-8]
    8a0c:	e0823003 	add	r3, r2, r3
    8a10:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:48

		input++;
    8a14:	e51b3010 	ldr	r3, [fp, #-16]
    8a18:	e2833001 	add	r3, r3, #1
    8a1c:	e50b3010 	str	r3, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:40
	while (*input != '\0')
    8a20:	eaffffe3 	b	89b4 <_Z4atoiPKc+0x18>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:51
	}

	return output;
    8a24:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:52
}
    8a28:	e1a00003 	mov	r0, r3
    8a2c:	e28bd000 	add	sp, fp, #0
    8a30:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8a34:	e12fff1e 	bx	lr

00008a38 <_Z7strncpyPcPKci>:
_Z7strncpyPcPKci():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:55

char* strncpy(char* dest, const char *src, int num)
{
    8a38:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8a3c:	e28db000 	add	fp, sp, #0
    8a40:	e24dd01c 	sub	sp, sp, #28
    8a44:	e50b0010 	str	r0, [fp, #-16]
    8a48:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8a4c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:58
	int i;

	for (i = 0; i < num && src[i] != '\0'; i++)
    8a50:	e3a03000 	mov	r3, #0
    8a54:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:58 (discriminator 4)
    8a58:	e51b2008 	ldr	r2, [fp, #-8]
    8a5c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8a60:	e1520003 	cmp	r2, r3
    8a64:	aa000011 	bge	8ab0 <_Z7strncpyPcPKci+0x78>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:58 (discriminator 2)
    8a68:	e51b3008 	ldr	r3, [fp, #-8]
    8a6c:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8a70:	e0823003 	add	r3, r2, r3
    8a74:	e5d33000 	ldrb	r3, [r3]
    8a78:	e3530000 	cmp	r3, #0
    8a7c:	0a00000b 	beq	8ab0 <_Z7strncpyPcPKci+0x78>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:59 (discriminator 3)
		dest[i] = src[i];
    8a80:	e51b3008 	ldr	r3, [fp, #-8]
    8a84:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8a88:	e0822003 	add	r2, r2, r3
    8a8c:	e51b3008 	ldr	r3, [fp, #-8]
    8a90:	e51b1010 	ldr	r1, [fp, #-16]
    8a94:	e0813003 	add	r3, r1, r3
    8a98:	e5d22000 	ldrb	r2, [r2]
    8a9c:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:58 (discriminator 3)
	for (i = 0; i < num && src[i] != '\0'; i++)
    8aa0:	e51b3008 	ldr	r3, [fp, #-8]
    8aa4:	e2833001 	add	r3, r3, #1
    8aa8:	e50b3008 	str	r3, [fp, #-8]
    8aac:	eaffffe9 	b	8a58 <_Z7strncpyPcPKci+0x20>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:60 (discriminator 2)
	for (; i < num; i++)
    8ab0:	e51b2008 	ldr	r2, [fp, #-8]
    8ab4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8ab8:	e1520003 	cmp	r2, r3
    8abc:	aa000008 	bge	8ae4 <_Z7strncpyPcPKci+0xac>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:61 (discriminator 1)
		dest[i] = '\0';
    8ac0:	e51b3008 	ldr	r3, [fp, #-8]
    8ac4:	e51b2010 	ldr	r2, [fp, #-16]
    8ac8:	e0823003 	add	r3, r2, r3
    8acc:	e3a02000 	mov	r2, #0
    8ad0:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:60 (discriminator 1)
	for (; i < num; i++)
    8ad4:	e51b3008 	ldr	r3, [fp, #-8]
    8ad8:	e2833001 	add	r3, r3, #1
    8adc:	e50b3008 	str	r3, [fp, #-8]
    8ae0:	eafffff2 	b	8ab0 <_Z7strncpyPcPKci+0x78>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:63

   return dest;
    8ae4:	e51b3010 	ldr	r3, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:64
}
    8ae8:	e1a00003 	mov	r0, r3
    8aec:	e28bd000 	add	sp, fp, #0
    8af0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8af4:	e12fff1e 	bx	lr

00008af8 <_Z7strncmpPKcS0_i>:
_Z7strncmpPKcS0_i():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:67

int strncmp(const char *s1, const char *s2, int num)
{
    8af8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8afc:	e28db000 	add	fp, sp, #0
    8b00:	e24dd01c 	sub	sp, sp, #28
    8b04:	e50b0010 	str	r0, [fp, #-16]
    8b08:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8b0c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:69
	unsigned char u1, u2;
  	while (num-- > 0)
    8b10:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8b14:	e2432001 	sub	r2, r3, #1
    8b18:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    8b1c:	e3530000 	cmp	r3, #0
    8b20:	c3a03001 	movgt	r3, #1
    8b24:	d3a03000 	movle	r3, #0
    8b28:	e6ef3073 	uxtb	r3, r3
    8b2c:	e3530000 	cmp	r3, #0
    8b30:	0a000016 	beq	8b90 <_Z7strncmpPKcS0_i+0x98>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:71
    {
      	u1 = (unsigned char) *s1++;
    8b34:	e51b3010 	ldr	r3, [fp, #-16]
    8b38:	e2832001 	add	r2, r3, #1
    8b3c:	e50b2010 	str	r2, [fp, #-16]
    8b40:	e5d33000 	ldrb	r3, [r3]
    8b44:	e54b3005 	strb	r3, [fp, #-5]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:72
     	u2 = (unsigned char) *s2++;
    8b48:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8b4c:	e2832001 	add	r2, r3, #1
    8b50:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    8b54:	e5d33000 	ldrb	r3, [r3]
    8b58:	e54b3006 	strb	r3, [fp, #-6]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:73
      	if (u1 != u2)
    8b5c:	e55b2005 	ldrb	r2, [fp, #-5]
    8b60:	e55b3006 	ldrb	r3, [fp, #-6]
    8b64:	e1520003 	cmp	r2, r3
    8b68:	0a000003 	beq	8b7c <_Z7strncmpPKcS0_i+0x84>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:74
        	return u1 - u2;
    8b6c:	e55b2005 	ldrb	r2, [fp, #-5]
    8b70:	e55b3006 	ldrb	r3, [fp, #-6]
    8b74:	e0423003 	sub	r3, r2, r3
    8b78:	ea000005 	b	8b94 <_Z7strncmpPKcS0_i+0x9c>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:75
      	if (u1 == '\0')
    8b7c:	e55b3005 	ldrb	r3, [fp, #-5]
    8b80:	e3530000 	cmp	r3, #0
    8b84:	1affffe1 	bne	8b10 <_Z7strncmpPKcS0_i+0x18>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:76
        	return 0;
    8b88:	e3a03000 	mov	r3, #0
    8b8c:	ea000000 	b	8b94 <_Z7strncmpPKcS0_i+0x9c>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:79
    }

  	return 0;
    8b90:	e3a03000 	mov	r3, #0
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:80
}
    8b94:	e1a00003 	mov	r0, r3
    8b98:	e28bd000 	add	sp, fp, #0
    8b9c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8ba0:	e12fff1e 	bx	lr

00008ba4 <_Z6strlenPKc>:
_Z6strlenPKc():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:83

int strlen(const char* s)
{
    8ba4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8ba8:	e28db000 	add	fp, sp, #0
    8bac:	e24dd014 	sub	sp, sp, #20
    8bb0:	e50b0010 	str	r0, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:84
	int i = 0;
    8bb4:	e3a03000 	mov	r3, #0
    8bb8:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:86

	while (s[i] != '\0')
    8bbc:	e51b3008 	ldr	r3, [fp, #-8]
    8bc0:	e51b2010 	ldr	r2, [fp, #-16]
    8bc4:	e0823003 	add	r3, r2, r3
    8bc8:	e5d33000 	ldrb	r3, [r3]
    8bcc:	e3530000 	cmp	r3, #0
    8bd0:	0a000003 	beq	8be4 <_Z6strlenPKc+0x40>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:87
		i++;
    8bd4:	e51b3008 	ldr	r3, [fp, #-8]
    8bd8:	e2833001 	add	r3, r3, #1
    8bdc:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:86
	while (s[i] != '\0')
    8be0:	eafffff5 	b	8bbc <_Z6strlenPKc+0x18>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:89

	return i;
    8be4:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:90
}
    8be8:	e1a00003 	mov	r0, r3
    8bec:	e28bd000 	add	sp, fp, #0
    8bf0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8bf4:	e12fff1e 	bx	lr

00008bf8 <_Z5bzeroPvi>:
_Z5bzeroPvi():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:93

void bzero(void* memory, int length)
{
    8bf8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8bfc:	e28db000 	add	fp, sp, #0
    8c00:	e24dd014 	sub	sp, sp, #20
    8c04:	e50b0010 	str	r0, [fp, #-16]
    8c08:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:94
	char* mem = reinterpret_cast<char*>(memory);
    8c0c:	e51b3010 	ldr	r3, [fp, #-16]
    8c10:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:96

	for (int i = 0; i < length; i++)
    8c14:	e3a03000 	mov	r3, #0
    8c18:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:96 (discriminator 3)
    8c1c:	e51b2008 	ldr	r2, [fp, #-8]
    8c20:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8c24:	e1520003 	cmp	r2, r3
    8c28:	aa000008 	bge	8c50 <_Z5bzeroPvi+0x58>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:97 (discriminator 2)
		mem[i] = 0;
    8c2c:	e51b3008 	ldr	r3, [fp, #-8]
    8c30:	e51b200c 	ldr	r2, [fp, #-12]
    8c34:	e0823003 	add	r3, r2, r3
    8c38:	e3a02000 	mov	r2, #0
    8c3c:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:96 (discriminator 2)
	for (int i = 0; i < length; i++)
    8c40:	e51b3008 	ldr	r3, [fp, #-8]
    8c44:	e2833001 	add	r3, r3, #1
    8c48:	e50b3008 	str	r3, [fp, #-8]
    8c4c:	eafffff2 	b	8c1c <_Z5bzeroPvi+0x24>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:98
}
    8c50:	e320f000 	nop	{0}
    8c54:	e28bd000 	add	sp, fp, #0
    8c58:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8c5c:	e12fff1e 	bx	lr

00008c60 <_Z6memcpyPKvPvi>:
_Z6memcpyPKvPvi():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:101

void memcpy(const void* src, void* dst, int num)
{
    8c60:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8c64:	e28db000 	add	fp, sp, #0
    8c68:	e24dd024 	sub	sp, sp, #36	; 0x24
    8c6c:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    8c70:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    8c74:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:102
	const char* memsrc = reinterpret_cast<const char*>(src);
    8c78:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8c7c:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:103
	char* memdst = reinterpret_cast<char*>(dst);
    8c80:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8c84:	e50b3010 	str	r3, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:105

	for (int i = 0; i < num; i++)
    8c88:	e3a03000 	mov	r3, #0
    8c8c:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:105 (discriminator 3)
    8c90:	e51b2008 	ldr	r2, [fp, #-8]
    8c94:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8c98:	e1520003 	cmp	r2, r3
    8c9c:	aa00000b 	bge	8cd0 <_Z6memcpyPKvPvi+0x70>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:106 (discriminator 2)
		memdst[i] = memsrc[i];
    8ca0:	e51b3008 	ldr	r3, [fp, #-8]
    8ca4:	e51b200c 	ldr	r2, [fp, #-12]
    8ca8:	e0822003 	add	r2, r2, r3
    8cac:	e51b3008 	ldr	r3, [fp, #-8]
    8cb0:	e51b1010 	ldr	r1, [fp, #-16]
    8cb4:	e0813003 	add	r3, r1, r3
    8cb8:	e5d22000 	ldrb	r2, [r2]
    8cbc:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:105 (discriminator 2)
	for (int i = 0; i < num; i++)
    8cc0:	e51b3008 	ldr	r3, [fp, #-8]
    8cc4:	e2833001 	add	r3, r3, #1
    8cc8:	e50b3008 	str	r3, [fp, #-8]
    8ccc:	eaffffef 	b	8c90 <_Z6memcpyPKvPvi+0x30>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:107
}
    8cd0:	e320f000 	nop	{0}
    8cd4:	e28bd000 	add	sp, fp, #0
    8cd8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8cdc:	e12fff1e 	bx	lr

00008ce0 <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1099
    8ce0:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1101
    8ce4:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1102
    8ce8:	3a000074 	bcc	8ec0 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1103
    8cec:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1104
    8cf0:	9a00006b 	bls	8ea4 <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1105
    8cf4:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1106
    8cf8:	0a00006c 	beq	8eb0 <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1108
    8cfc:	e16f3f10 	clz	r3, r0
    8d00:	e16f2f11 	clz	r2, r1
    8d04:	e0423003 	sub	r3, r2, r3
    8d08:	e273301f 	rsbs	r3, r3, #31
    8d0c:	10833083 	addne	r3, r3, r3, lsl #1
    8d10:	e3a02000 	mov	r2, #0
    8d14:	108ff103 	addne	pc, pc, r3, lsl #2
    8d18:	e1a00000 	nop			; (mov r0, r0)
    8d1c:	e1500f81 	cmp	r0, r1, lsl #31
    8d20:	e0a22002 	adc	r2, r2, r2
    8d24:	20400f81 	subcs	r0, r0, r1, lsl #31
    8d28:	e1500f01 	cmp	r0, r1, lsl #30
    8d2c:	e0a22002 	adc	r2, r2, r2
    8d30:	20400f01 	subcs	r0, r0, r1, lsl #30
    8d34:	e1500e81 	cmp	r0, r1, lsl #29
    8d38:	e0a22002 	adc	r2, r2, r2
    8d3c:	20400e81 	subcs	r0, r0, r1, lsl #29
    8d40:	e1500e01 	cmp	r0, r1, lsl #28
    8d44:	e0a22002 	adc	r2, r2, r2
    8d48:	20400e01 	subcs	r0, r0, r1, lsl #28
    8d4c:	e1500d81 	cmp	r0, r1, lsl #27
    8d50:	e0a22002 	adc	r2, r2, r2
    8d54:	20400d81 	subcs	r0, r0, r1, lsl #27
    8d58:	e1500d01 	cmp	r0, r1, lsl #26
    8d5c:	e0a22002 	adc	r2, r2, r2
    8d60:	20400d01 	subcs	r0, r0, r1, lsl #26
    8d64:	e1500c81 	cmp	r0, r1, lsl #25
    8d68:	e0a22002 	adc	r2, r2, r2
    8d6c:	20400c81 	subcs	r0, r0, r1, lsl #25
    8d70:	e1500c01 	cmp	r0, r1, lsl #24
    8d74:	e0a22002 	adc	r2, r2, r2
    8d78:	20400c01 	subcs	r0, r0, r1, lsl #24
    8d7c:	e1500b81 	cmp	r0, r1, lsl #23
    8d80:	e0a22002 	adc	r2, r2, r2
    8d84:	20400b81 	subcs	r0, r0, r1, lsl #23
    8d88:	e1500b01 	cmp	r0, r1, lsl #22
    8d8c:	e0a22002 	adc	r2, r2, r2
    8d90:	20400b01 	subcs	r0, r0, r1, lsl #22
    8d94:	e1500a81 	cmp	r0, r1, lsl #21
    8d98:	e0a22002 	adc	r2, r2, r2
    8d9c:	20400a81 	subcs	r0, r0, r1, lsl #21
    8da0:	e1500a01 	cmp	r0, r1, lsl #20
    8da4:	e0a22002 	adc	r2, r2, r2
    8da8:	20400a01 	subcs	r0, r0, r1, lsl #20
    8dac:	e1500981 	cmp	r0, r1, lsl #19
    8db0:	e0a22002 	adc	r2, r2, r2
    8db4:	20400981 	subcs	r0, r0, r1, lsl #19
    8db8:	e1500901 	cmp	r0, r1, lsl #18
    8dbc:	e0a22002 	adc	r2, r2, r2
    8dc0:	20400901 	subcs	r0, r0, r1, lsl #18
    8dc4:	e1500881 	cmp	r0, r1, lsl #17
    8dc8:	e0a22002 	adc	r2, r2, r2
    8dcc:	20400881 	subcs	r0, r0, r1, lsl #17
    8dd0:	e1500801 	cmp	r0, r1, lsl #16
    8dd4:	e0a22002 	adc	r2, r2, r2
    8dd8:	20400801 	subcs	r0, r0, r1, lsl #16
    8ddc:	e1500781 	cmp	r0, r1, lsl #15
    8de0:	e0a22002 	adc	r2, r2, r2
    8de4:	20400781 	subcs	r0, r0, r1, lsl #15
    8de8:	e1500701 	cmp	r0, r1, lsl #14
    8dec:	e0a22002 	adc	r2, r2, r2
    8df0:	20400701 	subcs	r0, r0, r1, lsl #14
    8df4:	e1500681 	cmp	r0, r1, lsl #13
    8df8:	e0a22002 	adc	r2, r2, r2
    8dfc:	20400681 	subcs	r0, r0, r1, lsl #13
    8e00:	e1500601 	cmp	r0, r1, lsl #12
    8e04:	e0a22002 	adc	r2, r2, r2
    8e08:	20400601 	subcs	r0, r0, r1, lsl #12
    8e0c:	e1500581 	cmp	r0, r1, lsl #11
    8e10:	e0a22002 	adc	r2, r2, r2
    8e14:	20400581 	subcs	r0, r0, r1, lsl #11
    8e18:	e1500501 	cmp	r0, r1, lsl #10
    8e1c:	e0a22002 	adc	r2, r2, r2
    8e20:	20400501 	subcs	r0, r0, r1, lsl #10
    8e24:	e1500481 	cmp	r0, r1, lsl #9
    8e28:	e0a22002 	adc	r2, r2, r2
    8e2c:	20400481 	subcs	r0, r0, r1, lsl #9
    8e30:	e1500401 	cmp	r0, r1, lsl #8
    8e34:	e0a22002 	adc	r2, r2, r2
    8e38:	20400401 	subcs	r0, r0, r1, lsl #8
    8e3c:	e1500381 	cmp	r0, r1, lsl #7
    8e40:	e0a22002 	adc	r2, r2, r2
    8e44:	20400381 	subcs	r0, r0, r1, lsl #7
    8e48:	e1500301 	cmp	r0, r1, lsl #6
    8e4c:	e0a22002 	adc	r2, r2, r2
    8e50:	20400301 	subcs	r0, r0, r1, lsl #6
    8e54:	e1500281 	cmp	r0, r1, lsl #5
    8e58:	e0a22002 	adc	r2, r2, r2
    8e5c:	20400281 	subcs	r0, r0, r1, lsl #5
    8e60:	e1500201 	cmp	r0, r1, lsl #4
    8e64:	e0a22002 	adc	r2, r2, r2
    8e68:	20400201 	subcs	r0, r0, r1, lsl #4
    8e6c:	e1500181 	cmp	r0, r1, lsl #3
    8e70:	e0a22002 	adc	r2, r2, r2
    8e74:	20400181 	subcs	r0, r0, r1, lsl #3
    8e78:	e1500101 	cmp	r0, r1, lsl #2
    8e7c:	e0a22002 	adc	r2, r2, r2
    8e80:	20400101 	subcs	r0, r0, r1, lsl #2
    8e84:	e1500081 	cmp	r0, r1, lsl #1
    8e88:	e0a22002 	adc	r2, r2, r2
    8e8c:	20400081 	subcs	r0, r0, r1, lsl #1
    8e90:	e1500001 	cmp	r0, r1
    8e94:	e0a22002 	adc	r2, r2, r2
    8e98:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1110
    8e9c:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1111
    8ea0:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1114
    8ea4:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1115
    8ea8:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1116
    8eac:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1118
    8eb0:	e16f2f11 	clz	r2, r1
    8eb4:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1120
    8eb8:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1121
    8ebc:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1125
    8ec0:	e3500000 	cmp	r0, #0
    8ec4:	13e00000 	mvnne	r0, #0
    8ec8:	ea000007 	b	8eec <__aeabi_idiv0>

00008ecc <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1156
    8ecc:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1157
    8ed0:	0afffffa 	beq	8ec0 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1158
    8ed4:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1159
    8ed8:	ebffff80 	bl	8ce0 <__udivsi3>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1160
    8edc:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    8ee0:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    8ee4:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1163
    8ee8:	e12fff1e 	bx	lr

00008eec <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1461
    8eec:	e12fff1e 	bx	lr

Disassembly of section .rodata:

00008ef0 <_ZL13Lock_Unlocked>:
    8ef0:	00000000 	andeq	r0, r0, r0

00008ef4 <_ZL11Lock_Locked>:
    8ef4:	00000001 	andeq	r0, r0, r1

00008ef8 <_ZL21MaxFSDriverNameLength>:
    8ef8:	00000010 	andeq	r0, r0, r0, lsl r0

00008efc <_ZL17MaxFilenameLength>:
    8efc:	00000010 	andeq	r0, r0, r0, lsl r0

00008f00 <_ZL13MaxPathLength>:
    8f00:	00000080 	andeq	r0, r0, r0, lsl #1

00008f04 <_ZL18NoFilesystemDriver>:
    8f04:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f08 <_ZL9NotifyAll>:
    8f08:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f0c <_ZL24Max_Process_Opened_Files>:
    8f0c:	00000010 	andeq	r0, r0, r0, lsl r0

00008f10 <_ZL10Indefinite>:
    8f10:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f14 <_ZL18Deadline_Unchanged>:
    8f14:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00008f18 <_ZL14Invalid_Handle>:
    8f18:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f1c <_ZN3halL18Default_Clock_RateE>:
    8f1c:	0ee6b280 	cdpeq	2, 14, cr11, cr6, cr0, {4}

00008f20 <_ZN3halL15Peripheral_BaseE>:
    8f20:	20000000 	andcs	r0, r0, r0

00008f24 <_ZN3halL9GPIO_BaseE>:
    8f24:	20200000 	eorcs	r0, r0, r0

00008f28 <_ZN3halL14GPIO_Pin_CountE>:
    8f28:	00000036 	andeq	r0, r0, r6, lsr r0

00008f2c <_ZN3halL8AUX_BaseE>:
    8f2c:	20215000 	eorcs	r5, r1, r0

00008f30 <_ZN3halL25Interrupt_Controller_BaseE>:
    8f30:	2000b200 	andcs	fp, r0, r0, lsl #4

00008f34 <_ZN3halL10Timer_BaseE>:
    8f34:	2000b400 	andcs	fp, r0, r0, lsl #8

00008f38 <_ZN3halL9TRNG_BaseE>:
    8f38:	20104000 	andscs	r4, r0, r0

00008f3c <_ZN3halL9BSC0_BaseE>:
    8f3c:	20205000 	eorcs	r5, r0, r0

00008f40 <_ZN3halL9BSC1_BaseE>:
    8f40:	20804000 	addcs	r4, r0, r0

00008f44 <_ZN3halL9BSC2_BaseE>:
    8f44:	20805000 	addcs	r5, r0, r0

00008f48 <_ZL11Invalid_Pin>:
    8f48:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
    8f4c:	3a564544 	bcc	159a464 <__bss_end+0x1591498>
    8f50:	64676573 	strbtvs	r6, [r7], #-1395	; 0xfffffa8d
    8f54:	00000000 	andeq	r0, r0, r0
    8f58:	3a564544 	bcc	159a470 <__bss_end+0x15914a4>
    8f5c:	6f697067 	svcvs	0x00697067
    8f60:	0000342f 	andeq	r3, r0, pc, lsr #8
    8f64:	3a564544 	bcc	159a47c <__bss_end+0x15914b0>
    8f68:	6f697067 	svcvs	0x00697067
    8f6c:	0037312f 	eorseq	r3, r7, pc, lsr #2

00008f70 <_ZL13Lock_Unlocked>:
    8f70:	00000000 	andeq	r0, r0, r0

00008f74 <_ZL11Lock_Locked>:
    8f74:	00000001 	andeq	r0, r0, r1

00008f78 <_ZL21MaxFSDriverNameLength>:
    8f78:	00000010 	andeq	r0, r0, r0, lsl r0

00008f7c <_ZL17MaxFilenameLength>:
    8f7c:	00000010 	andeq	r0, r0, r0, lsl r0

00008f80 <_ZL13MaxPathLength>:
    8f80:	00000080 	andeq	r0, r0, r0, lsl #1

00008f84 <_ZL18NoFilesystemDriver>:
    8f84:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f88 <_ZL9NotifyAll>:
    8f88:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f8c <_ZL24Max_Process_Opened_Files>:
    8f8c:	00000010 	andeq	r0, r0, r0, lsl r0

00008f90 <_ZL10Indefinite>:
    8f90:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f94 <_ZL18Deadline_Unchanged>:
    8f94:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00008f98 <_ZL14Invalid_Handle>:
    8f98:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00008f9c <_ZL16Pipe_File_Prefix>:
    8f9c:	3a535953 	bcc	14df4f0 <__bss_end+0x14d6524>
    8fa0:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    8fa4:	0000002f 	andeq	r0, r0, pc, lsr #32

00008fa8 <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    8fa8:	33323130 	teqcc	r2, #48, 2
    8fac:	37363534 			; <UNDEFINED> instruction: 0x37363534
    8fb0:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    8fb4:	46454443 	strbmi	r4, [r5], -r3, asr #8
	...

Disassembly of section .bss:

00008fbc <__bss_start>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x1684860>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x39458>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3d06c>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c7d58>
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
  24:	6a6b6e65 	bvs	1adb9c0 <__bss_end+0x1ad29f4>
  28:	32736f2f 	rsbscc	r6, r3, #47, 30	; 0xbc
  2c:	2f323230 	svccs	0x00323230
  30:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
  34:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
  38:	752f7365 	strvc	r7, [pc, #-869]!	; fffffcdb <__bss_end+0xffff6d0f>
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
  7c:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffffc8 <__bss_end+0xffff6ffc>
  80:	63732f65 	cmnvs	r3, #404	; 0x194
  84:	6b6e6568 	blvs	1b9962c <__bss_end+0x1b90660>
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
  bc:	1b050109 	blne	1404e8 <__bss_end+0x13751c>
  c0:	4a130567 	bmi	4c1664 <__bss_end+0x4b8698>
  c4:	052f0505 	streq	r0, [pc, #-1285]!	; fffffbc7 <__bss_end+0xffff6bfb>
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
 104:	fb010200 	blx	4090e <__bss_end+0x37942>
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
 168:	0b05010a 	bleq	140598 <__bss_end+0x1375cc>
 16c:	4a0a0583 	bmi	281780 <__bss_end+0x2787b4>
 170:	85830205 	strhi	r0, [r3, #517]	; 0x205
 174:	05830e05 	streq	r0, [r3, #3589]	; 0xe05
 178:	84856702 	strhi	r6, [r5], #1794	; 0x702
 17c:	4c860105 	stfmis	f0, [r6], {5}
 180:	4c854c85 	stcmi	12, cr4, [r5], {133}	; 0x85
 184:	00020585 	andeq	r0, r2, r5, lsl #11
 188:	4b010402 	blmi	41198 <__bss_end+0x381cc>
 18c:	12030105 	andne	r0, r3, #1073741825	; 0x40000001
 190:	6b0d052e 	blvs	341650 <__bss_end+0x338684>
 194:	02002405 	andeq	r2, r0, #83886080	; 0x5000000
 198:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 19c:	04020004 	streq	r0, [r2], #-4
 1a0:	0b058302 	bleq	160db0 <__bss_end+0x157de4>
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
 1e0:	00026001 	andeq	r6, r2, r1
 1e4:	d8000300 	stmdale	r0, {r8, r9}
 1e8:	02000001 	andeq	r0, r0, #1
 1ec:	0d0efb01 	vstreq	d15, [lr, #-4]
 1f0:	01010100 	mrseq	r0, (UNDEF: 17)
 1f4:	00000001 	andeq	r0, r0, r1
 1f8:	01000001 	tsteq	r0, r1
 1fc:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 148 <shift+0x148>
 200:	63732f65 	cmnvs	r3, #404	; 0x194
 204:	6b6e6568 	blvs	1b997ac <__bss_end+0x1b907e0>
 208:	736f2f6a 	cmnvc	pc, #424	; 0x1a8
 20c:	32323032 	eorscc	r3, r2, #50	; 0x32
 210:	2f70732f 	svccs	0x0070732f
 214:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 218:	2f736563 	svccs	0x00736563
 21c:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
 220:	63617073 	cmnvs	r1, #115	; 0x73
 224:	6f632f65 	svcvs	0x00632f65
 228:	65746e75 	ldrbvs	r6, [r4, #-3701]!	; 0xfffff18b
 22c:	61745f72 	cmnvs	r4, r2, ror pc
 230:	2f006b73 	svccs	0x00006b73
 234:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 238:	6863732f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, sp, lr}^
 23c:	6a6b6e65 	bvs	1adbbd8 <__bss_end+0x1ad2c0c>
 240:	32736f2f 	rsbscc	r6, r3, #47, 30	; 0xbc
 244:	2f323230 	svccs	0x00323230
 248:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
 24c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 250:	752f7365 	strvc	r7, [pc, #-869]!	; fffffef3 <__bss_end+0xffff6f27>
 254:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 258:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 25c:	2f2e2e2f 	svccs	0x002e2e2f
 260:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 264:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 268:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 26c:	702f6564 	eorvc	r6, pc, r4, ror #10
 270:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 274:	2f007373 	svccs	0x00007373
 278:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 27c:	6863732f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, sp, lr}^
 280:	6a6b6e65 	bvs	1adbc1c <__bss_end+0x1ad2c50>
 284:	32736f2f 	rsbscc	r6, r3, #47, 30	; 0xbc
 288:	2f323230 	svccs	0x00323230
 28c:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
 290:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 294:	752f7365 	strvc	r7, [pc, #-869]!	; ffffff37 <__bss_end+0xffff6f6b>
 298:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
 29c:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
 2a0:	2f2e2e2f 	svccs	0x002e2e2f
 2a4:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 2a8:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 2ac:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 2b0:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
 2b4:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
 2b8:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
 2bc:	61682f30 	cmnvs	r8, r0, lsr pc
 2c0:	682f006c 	stmdavs	pc!, {r2, r3, r5, r6}	; <UNPREDICTABLE>
 2c4:	2f656d6f 	svccs	0x00656d6f
 2c8:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
 2cc:	2f6a6b6e 	svccs	0x006a6b6e
 2d0:	3032736f 	eorscc	r7, r2, pc, ror #6
 2d4:	732f3232 			; <UNDEFINED> instruction: 0x732f3232
 2d8:	6f732f70 	svcvs	0x00732f70
 2dc:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 2e0:	73752f73 	cmnvc	r5, #460	; 0x1cc
 2e4:	70737265 	rsbsvc	r7, r3, r5, ror #4
 2e8:	2f656361 	svccs	0x00656361
 2ec:	6b2f2e2e 	blvs	bcbbac <__bss_end+0xbc2be0>
 2f0:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 2f4:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 2f8:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 2fc:	73662f65 	cmnvc	r6, #404	; 0x194
 300:	6f682f00 	svcvs	0x00682f00
 304:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
 308:	6e656863 	cdpvs	8, 6, cr6, cr5, cr3, {3}
 30c:	6f2f6a6b 	svcvs	0x002f6a6b
 310:	32303273 	eorscc	r3, r0, #805306375	; 0x30000007
 314:	70732f32 	rsbsvc	r2, r3, r2, lsr pc
 318:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffff1 <__bss_end+0xffff7025>
 31c:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 320:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
 324:	61707372 	cmnvs	r0, r2, ror r3
 328:	2e2f6563 	cfsh64cs	mvdx6, mvdx15, #51
 32c:	656b2f2e 	strbvs	r2, [fp, #-3886]!	; 0xfffff0d2
 330:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 334:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 338:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 33c:	6972642f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, sl, sp, lr}^
 340:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
 344:	616d0000 	cmnvs	sp, r0
 348:	632e6e69 			; <UNDEFINED> instruction: 0x632e6e69
 34c:	01007070 	tsteq	r0, r0, ror r0
 350:	77730000 	ldrbvc	r0, [r3, -r0]!
 354:	00682e69 	rsbeq	r2, r8, r9, ror #28
 358:	69000002 	stmdbvs	r0, {r1}
 35c:	6564746e 	strbvs	r7, [r4, #-1134]!	; 0xfffffb92
 360:	00682e66 	rsbeq	r2, r8, r6, ror #28
 364:	73000003 	movwvc	r0, #3
 368:	6c6e6970 			; <UNDEFINED> instruction: 0x6c6e6970
 36c:	2e6b636f 	cdpcs	3, 6, cr6, cr11, cr15, {3}
 370:	00020068 	andeq	r0, r2, r8, rrx
 374:	6c696600 	stclvs	6, cr6, [r9], #-0
 378:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
 37c:	2e6d6574 	mcrcs	5, 3, r6, cr13, cr4, {3}
 380:	00040068 	andeq	r0, r4, r8, rrx
 384:	6f727000 	svcvs	0x00727000
 388:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 38c:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 390:	72700000 	rsbsvc	r0, r0, #0
 394:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
 398:	616d5f73 	smcvs	54771	; 0xd5f3
 39c:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
 3a0:	00682e72 	rsbeq	r2, r8, r2, ror lr
 3a4:	70000002 	andvc	r0, r0, r2
 3a8:	70697265 	rsbvc	r7, r9, r5, ror #4
 3ac:	61726568 	cmnvs	r2, r8, ror #10
 3b0:	682e736c 	stmdavs	lr!, {r2, r3, r5, r6, r8, r9, ip, sp, lr}
 3b4:	00000300 	andeq	r0, r0, r0, lsl #6
 3b8:	6f697067 	svcvs	0x00697067
 3bc:	0500682e 	streq	r6, [r0, #-2094]	; 0xfffff7d2
 3c0:	05000000 	streq	r0, [r0, #-0]
 3c4:	02050001 	andeq	r0, r5, #1
 3c8:	00008238 	andeq	r8, r0, r8, lsr r2
 3cc:	05011003 	streq	r1, [r1, #-3]
 3d0:	83839f1e 	orrhi	r9, r3, #30, 30	; 0x78
 3d4:	05840f05 	streq	r0, [r4, #3845]	; 0xf05
 3d8:	054b4b07 	strbeq	r4, [fp, #-2823]	; 0xfffff4f9
 3dc:	02004c13 	andeq	r4, r0, #4864	; 0x1300
 3e0:	66060104 	strvs	r0, [r6], -r4, lsl #2
 3e4:	02040200 	andeq	r0, r4, #0, 4
 3e8:	0402004a 	streq	r0, [r2], #-74	; 0xffffffb6
 3ec:	08052e04 	stmdaeq	r5, {r2, r9, sl, fp, sp}
 3f0:	07054e06 	streq	r4, [r5, -r6, lsl #28]
 3f4:	9f14054c 	svcls	0x0014054c
 3f8:	052e0d05 	streq	r0, [lr, #-3333]!	; 0xfffff2fb
 3fc:	0f058407 	svceq	0x00058407
 400:	2e08059f 	mcrcs	5, 0, r0, cr8, cr15, {4}
 404:	05840305 	streq	r0, [r4, #773]	; 0x305
 408:	0584670b 	streq	r6, [r4, #1803]	; 0x70b
 40c:	0d056818 	stceq	8, cr6, [r5, #-96]	; 0xffffffa0
 410:	07052008 	streq	r2, [r5, -r8]
 414:	2f080566 	svccs	0x00080566
 418:	040200a0 	streq	r0, [r2], #-160	; 0xffffff60
 41c:	00660601 	rsbeq	r0, r6, r1, lsl #12
 420:	4a020402 	bmi	81430 <__bss_end+0x78464>
 424:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
 428:	0402002e 	streq	r0, [r2], #-46	; 0xffffffd2
 42c:	02006605 	andeq	r6, r0, #5242880	; 0x500000
 430:	004a0604 	subeq	r0, sl, r4, lsl #12
 434:	2e080402 	cdpcs	4, 0, cr0, cr8, cr2, {0}
 438:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 43c:	67060804 	strvs	r0, [r6, -r4, lsl #16]
 440:	01000a02 	tsteq	r0, r2, lsl #20
 444:	00027c01 	andeq	r7, r2, r1, lsl #24
 448:	49000300 	stmdbmi	r0, {r8, r9}
 44c:	02000001 	andeq	r0, r0, #1
 450:	0d0efb01 	vstreq	d15, [lr, #-4]
 454:	01010100 	mrseq	r0, (UNDEF: 17)
 458:	00000001 	andeq	r0, r0, r1
 45c:	01000001 	tsteq	r0, r1
 460:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 3ac <shift+0x3ac>
 464:	63732f65 	cmnvs	r3, #404	; 0x194
 468:	6b6e6568 	blvs	1b99a10 <__bss_end+0x1b90a44>
 46c:	736f2f6a 	cmnvc	pc, #424	; 0x1a8
 470:	32323032 	eorscc	r3, r2, #50	; 0x32
 474:	2f70732f 	svccs	0x0070732f
 478:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 47c:	2f736563 	svccs	0x00736563
 480:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
 484:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
 488:	2f006372 	svccs	0x00006372
 48c:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
 490:	6863732f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, sp, lr}^
 494:	6a6b6e65 	bvs	1adbe30 <__bss_end+0x1ad2e64>
 498:	32736f2f 	rsbscc	r6, r3, #47, 30	; 0xbc
 49c:	2f323230 	svccs	0x00323230
 4a0:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
 4a4:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
 4a8:	6b2f7365 	blvs	bdd244 <__bss_end+0xbd4278>
 4ac:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 4b0:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 4b4:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 4b8:	72702f65 	rsbsvc	r2, r0, #404	; 0x194
 4bc:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
 4c0:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
 4c4:	2f656d6f 	svccs	0x00656d6f
 4c8:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
 4cc:	2f6a6b6e 	svccs	0x006a6b6e
 4d0:	3032736f 	eorscc	r7, r2, pc, ror #6
 4d4:	732f3232 			; <UNDEFINED> instruction: 0x732f3232
 4d8:	6f732f70 	svcvs	0x00732f70
 4dc:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 4e0:	656b2f73 	strbvs	r2, [fp, #-3955]!	; 0xfffff08d
 4e4:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 4e8:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 4ec:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 4f0:	0073662f 	rsbseq	r6, r3, pc, lsr #12
 4f4:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 440 <shift+0x440>
 4f8:	63732f65 	cmnvs	r3, #404	; 0x194
 4fc:	6b6e6568 	blvs	1b99aa4 <__bss_end+0x1b90ad8>
 500:	736f2f6a 	cmnvc	pc, #424	; 0x1a8
 504:	32323032 	eorscc	r3, r2, #50	; 0x32
 508:	2f70732f 	svccs	0x0070732f
 50c:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 510:	2f736563 	svccs	0x00736563
 514:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 518:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 51c:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 520:	622f6564 	eorvs	r6, pc, #100, 10	; 0x19000000
 524:	6472616f 	ldrbtvs	r6, [r2], #-367	; 0xfffffe91
 528:	6970722f 	ldmdbvs	r0!, {r0, r1, r2, r3, r5, r9, ip, sp, lr}^
 52c:	61682f30 	cmnvs	r8, r0, lsr pc
 530:	7300006c 	movwvc	r0, #108	; 0x6c
 534:	69666474 	stmdbvs	r6!, {r2, r4, r5, r6, sl, sp, lr}^
 538:	632e656c 			; <UNDEFINED> instruction: 0x632e656c
 53c:	01007070 	tsteq	r0, r0, ror r0
 540:	77730000 	ldrbvc	r0, [r3, -r0]!
 544:	00682e69 	rsbeq	r2, r8, r9, ror #28
 548:	73000002 	movwvc	r0, #2
 54c:	6c6e6970 			; <UNDEFINED> instruction: 0x6c6e6970
 550:	2e6b636f 	cdpcs	3, 6, cr6, cr11, cr15, {3}
 554:	00020068 	andeq	r0, r2, r8, rrx
 558:	6c696600 	stclvs	6, cr6, [r9], #-0
 55c:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
 560:	2e6d6574 	mcrcs	5, 3, r6, cr13, cr4, {3}
 564:	00030068 	andeq	r0, r3, r8, rrx
 568:	6f727000 	svcvs	0x00727000
 56c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 570:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 574:	72700000 	rsbsvc	r0, r0, #0
 578:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
 57c:	616d5f73 	smcvs	54771	; 0xd5f3
 580:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
 584:	00682e72 	rsbeq	r2, r8, r2, ror lr
 588:	69000002 	stmdbvs	r0, {r1}
 58c:	6564746e 	strbvs	r7, [r4, #-1134]!	; 0xfffffb92
 590:	00682e66 	rsbeq	r2, r8, r6, ror #28
 594:	00000004 	andeq	r0, r0, r4
 598:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
 59c:	0083cc02 	addeq	ip, r3, r2, lsl #24
 5a0:	1a051600 	bne	145da8 <__bss_end+0x13cddc>
 5a4:	2f2c0569 	svccs	0x002c0569
 5a8:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 5ac:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 5b0:	1a058332 	bne	161280 <__bss_end+0x1582b4>
 5b4:	2f01054b 	svccs	0x0001054b
 5b8:	4b1a0585 	blmi	681bd4 <__bss_end+0x678c08>
 5bc:	852f0105 	strhi	r0, [pc, #-261]!	; 4bf <shift+0x4bf>
 5c0:	05a13205 	streq	r3, [r1, #517]!	; 0x205
 5c4:	1b054b2e 	blne	153284 <__bss_end+0x14a2b8>
 5c8:	2f2d054b 	svccs	0x002d054b
 5cc:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 5d0:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 5d4:	3005bd2e 	andcc	fp, r5, lr, lsr #26
 5d8:	4b2e054b 	blmi	b81b0c <__bss_end+0xb78b40>
 5dc:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
 5e0:	0c052f2e 	stceq	15, cr2, [r5], {46}	; 0x2e
 5e4:	2f01054c 	svccs	0x0001054c
 5e8:	bd2e0585 	cfstr32lt	mvfx0, [lr, #-532]!	; 0xfffffdec
 5ec:	054b3005 	strbeq	r3, [fp, #-5]
 5f0:	1b054b2e 	blne	1532b0 <__bss_end+0x14a2e4>
 5f4:	2f2e054b 	svccs	0x002e054b
 5f8:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 5fc:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 600:	1b05832e 	blne	1612c0 <__bss_end+0x1582f4>
 604:	2f01054b 	svccs	0x0001054b
 608:	bd2e0585 	cfstr32lt	mvfx0, [lr, #-532]!	; 0xfffffdec
 60c:	054b3305 	strbeq	r3, [fp, #-773]	; 0xfffffcfb
 610:	1b054b2f 	blne	1532d4 <__bss_end+0x14a308>
 614:	2f30054b 	svccs	0x0030054b
 618:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 61c:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 620:	2f05a12e 	svccs	0x0005a12e
 624:	4b1b054b 	blmi	6c1b58 <__bss_end+0x6b8b8c>
 628:	052f2f05 	streq	r2, [pc, #-3845]!	; fffff72b <__bss_end+0xffff675f>
 62c:	01054c0c 	tsteq	r5, ip, lsl #24
 630:	2e05852f 	cfsh32cs	mvfx8, mvfx5, #31
 634:	4b2f05bd 	blmi	bc1d30 <__bss_end+0xbb8d64>
 638:	054b3b05 	strbeq	r3, [fp, #-2821]	; 0xfffff4fb
 63c:	30054b1b 	andcc	r4, r5, fp, lsl fp
 640:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 644:	852f0105 	strhi	r0, [pc, #-261]!	; 547 <shift+0x547>
 648:	05a12f05 	streq	r2, [r1, #3845]!	; 0xf05
 64c:	1a054b3b 	bne	153340 <__bss_end+0x14a374>
 650:	2f30054b 	svccs	0x0030054b
 654:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 658:	05859f01 	streq	r9, [r5, #3841]	; 0xf01
 65c:	2d056720 	stccs	7, cr6, [r5, #-128]	; 0xffffff80
 660:	4b31054d 	blmi	c41b9c <__bss_end+0xc38bd0>
 664:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
 668:	0105300c 	tsteq	r5, ip
 66c:	2005852f 	andcs	r8, r5, pc, lsr #10
 670:	4d2d0567 	cfstr32mi	mvfx0, [sp, #-412]!	; 0xfffffe64
 674:	054b3105 	strbeq	r3, [fp, #-261]	; 0xfffffefb
 678:	0c054b1a 			; <UNDEFINED> instruction: 0x0c054b1a
 67c:	2f010530 	svccs	0x00010530
 680:	83200585 			; <UNDEFINED> instruction: 0x83200585
 684:	054c2d05 	strbeq	r2, [ip, #-3333]	; 0xfffff2fb
 688:	1a054b3e 	bne	153388 <__bss_end+0x14a3bc>
 68c:	2f01054b 	svccs	0x0001054b
 690:	67200585 	strvs	r0, [r0, -r5, lsl #11]!
 694:	054d2d05 	strbeq	r2, [sp, #-3333]	; 0xfffff2fb
 698:	1a054b30 	bne	153360 <__bss_end+0x14a394>
 69c:	300c054b 	andcc	r0, ip, fp, asr #10
 6a0:	872f0105 	strhi	r0, [pc, -r5, lsl #2]!
 6a4:	9fa00c05 	svcls	0x00a00c05
 6a8:	05bc3105 	ldreq	r3, [ip, #261]!	; 0x105
 6ac:	36056629 	strcc	r6, [r5], -r9, lsr #12
 6b0:	300f052e 	andcc	r0, pc, lr, lsr #10
 6b4:	05661305 	strbeq	r1, [r6, #-773]!	; 0xfffffcfb
 6b8:	10058409 	andne	r8, r5, r9, lsl #8
 6bc:	9f0105d8 	svcls	0x000105d8
 6c0:	01000802 	tsteq	r0, r2, lsl #16
 6c4:	00027601 	andeq	r7, r2, r1, lsl #12
 6c8:	4f000300 	svcmi	0x00000300
 6cc:	02000000 	andeq	r0, r0, #0
 6d0:	0d0efb01 	vstreq	d15, [lr, #-4]
 6d4:	01010100 	mrseq	r0, (UNDEF: 17)
 6d8:	00000001 	andeq	r0, r0, r1
 6dc:	01000001 	tsteq	r0, r1
 6e0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 62c <shift+0x62c>
 6e4:	63732f65 	cmnvs	r3, #404	; 0x194
 6e8:	6b6e6568 	blvs	1b99c90 <__bss_end+0x1b90cc4>
 6ec:	736f2f6a 	cmnvc	pc, #424	; 0x1a8
 6f0:	32323032 	eorscc	r3, r2, #50	; 0x32
 6f4:	2f70732f 	svccs	0x0070732f
 6f8:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 6fc:	2f736563 	svccs	0x00736563
 700:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
 704:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
 708:	00006372 	andeq	r6, r0, r2, ror r3
 70c:	73647473 	cmnvc	r4, #1929379840	; 0x73000000
 710:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
 714:	70632e67 	rsbvc	r2, r3, r7, ror #28
 718:	00010070 	andeq	r0, r1, r0, ror r0
 71c:	01050000 	mrseq	r0, (UNDEF: 5)
 720:	28020500 	stmdacs	r2, {r8, sl}
 724:	1a000088 	bne	94c <shift+0x94c>
 728:	05bb0605 	ldreq	r0, [fp, #1541]!	; 0x605
 72c:	21054c0f 	tstcs	r5, pc, lsl #24
 730:	ba0a0568 	blt	281cd8 <__bss_end+0x278d0c>
 734:	052e0b05 	streq	r0, [lr, #-2821]!	; 0xfffff4fb
 738:	0d054a27 	vstreq	s8, [r5, #-156]	; 0xffffff64
 73c:	2f09054a 	svccs	0x0009054a
 740:	059f0405 	ldreq	r0, [pc, #1029]	; b4d <shift+0xb4d>
 744:	05056202 	streq	r6, [r5, #-514]	; 0xfffffdfe
 748:	68100535 	ldmdavs	r0, {r0, r2, r4, r5, r8, sl}
 74c:	052e1105 	streq	r1, [lr, #-261]!	; 0xfffffefb
 750:	13054a22 	movwne	r4, #23074	; 0x5a22
 754:	2f0a052e 	svccs	0x000a052e
 758:	05690905 	strbeq	r0, [r9, #-2309]!	; 0xfffff6fb
 75c:	0c052e0a 	stceq	14, cr2, [r5], {10}
 760:	4b03054a 	blmi	c1c90 <__bss_end+0xb8cc4>
 764:	05680b05 	strbeq	r0, [r8, #-2821]!	; 0xfffff4fb
 768:	04020018 	streq	r0, [r2], #-24	; 0xffffffe8
 76c:	14054a03 	strne	r4, [r5], #-2563	; 0xfffff5fd
 770:	03040200 	movweq	r0, #16896	; 0x4200
 774:	0015059e 	mulseq	r5, lr, r5
 778:	68020402 	stmdavs	r2, {r1, sl}
 77c:	02001805 	andeq	r1, r0, #327680	; 0x50000
 780:	05820204 	streq	r0, [r2, #516]	; 0x204
 784:	04020008 	streq	r0, [r2], #-8
 788:	1a054a02 	bne	152f98 <__bss_end+0x149fcc>
 78c:	02040200 	andeq	r0, r4, #0, 4
 790:	001b054b 	andseq	r0, fp, fp, asr #10
 794:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 798:	02000c05 	andeq	r0, r0, #1280	; 0x500
 79c:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 7a0:	0402000f 	streq	r0, [r2], #-15
 7a4:	1b058202 	blne	160fb4 <__bss_end+0x157fe8>
 7a8:	02040200 	andeq	r0, r4, #0, 4
 7ac:	0011054a 	andseq	r0, r1, sl, asr #10
 7b0:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 7b4:	02000a05 	andeq	r0, r0, #20480	; 0x5000
 7b8:	052f0204 	streq	r0, [pc, #-516]!	; 5bc <shift+0x5bc>
 7bc:	0402000b 	streq	r0, [r2], #-11
 7c0:	0d052e02 	stceq	14, cr2, [r5, #-8]
 7c4:	02040200 	andeq	r0, r4, #0, 4
 7c8:	0002054a 	andeq	r0, r2, sl, asr #10
 7cc:	46020402 	strmi	r0, [r2], -r2, lsl #8
 7d0:	85880105 	strhi	r0, [r8, #261]	; 0x105
 7d4:	05830605 	streq	r0, [r3, #1541]	; 0x605
 7d8:	10054c09 	andne	r4, r5, r9, lsl #24
 7dc:	4c0a054a 	cfstr32mi	mvfx0, [sl], {74}	; 0x4a
 7e0:	05bb0705 	ldreq	r0, [fp, #1797]!	; 0x705
 7e4:	17054a03 	strne	r4, [r5, -r3, lsl #20]
 7e8:	01040200 	mrseq	r0, R12_usr
 7ec:	0014054a 	andseq	r0, r4, sl, asr #10
 7f0:	4a010402 	bmi	41800 <__bss_end+0x38834>
 7f4:	054d0d05 	strbeq	r0, [sp, #-3333]	; 0xfffff2fb
 7f8:	0a054a14 	beq	153050 <__bss_end+0x14a084>
 7fc:	6808052e 	stmdavs	r8, {r1, r2, r3, r5, r8, sl}
 800:	78030205 	stmdavc	r3, {r0, r2, r9}
 804:	03090566 	movweq	r0, #38246	; 0x9566
 808:	01052e0b 	tsteq	r5, fp, lsl #28
 80c:	0905852f 	stmdbeq	r5, {r0, r1, r2, r3, r5, r8, sl, pc}
 810:	001605bd 			; <UNDEFINED> instruction: 0x001605bd
 814:	4a040402 	bmi	101824 <__bss_end+0xf8858>
 818:	02001d05 	andeq	r1, r0, #320	; 0x140
 81c:	05820204 	streq	r0, [r2, #516]	; 0x204
 820:	0402001e 	streq	r0, [r2], #-30	; 0xffffffe2
 824:	16052e02 	strne	r2, [r5], -r2, lsl #28
 828:	02040200 	andeq	r0, r4, #0, 4
 82c:	00110566 	andseq	r0, r1, r6, ror #10
 830:	4b030402 	blmi	c1840 <__bss_end+0xb8874>
 834:	02001205 	andeq	r1, r0, #1342177280	; 0x50000000
 838:	052e0304 	streq	r0, [lr, #-772]!	; 0xfffffcfc
 83c:	04020008 	streq	r0, [r2], #-8
 840:	09054a03 	stmdbeq	r5, {r0, r1, r9, fp, lr}
 844:	03040200 	movweq	r0, #16896	; 0x4200
 848:	0012052e 	andseq	r0, r2, lr, lsr #10
 84c:	4a030402 	bmi	c185c <__bss_end+0xb8890>
 850:	02000b05 	andeq	r0, r0, #5120	; 0x1400
 854:	052e0304 	streq	r0, [lr, #-772]!	; 0xfffffcfc
 858:	04020002 	streq	r0, [r2], #-2
 85c:	0b052d03 	bleq	14bc70 <__bss_end+0x142ca4>
 860:	02040200 	andeq	r0, r4, #0, 4
 864:	00080584 	andeq	r0, r8, r4, lsl #11
 868:	83010402 	movwhi	r0, #5122	; 0x1402
 86c:	02000905 	andeq	r0, r0, #81920	; 0x14000
 870:	052e0104 	streq	r0, [lr, #-260]!	; 0xfffffefc
 874:	0402000b 	streq	r0, [r2], #-11
 878:	02054a01 	andeq	r4, r5, #4096	; 0x1000
 87c:	01040200 	mrseq	r0, R12_usr
 880:	850b0549 	strhi	r0, [fp, #-1353]	; 0xfffffab7
 884:	852f0105 	strhi	r0, [pc, #-261]!	; 787 <shift+0x787>
 888:	05bc0e05 	ldreq	r0, [ip, #3589]!	; 0xe05
 88c:	20056611 	andcs	r6, r5, r1, lsl r6
 890:	660b05bc 			; <UNDEFINED> instruction: 0x660b05bc
 894:	054b1f05 	strbeq	r1, [fp, #-3845]	; 0xfffff0fb
 898:	0805660a 	stmdaeq	r5, {r1, r3, r9, sl, sp, lr}
 89c:	8311054b 	tsthi	r1, #314572800	; 0x12c00000
 8a0:	052e1605 	streq	r1, [lr, #-1541]!	; 0xfffff9fb
 8a4:	11056708 	tstne	r5, r8, lsl #14
 8a8:	4d0b0567 	cfstr32mi	mvfx0, [fp, #-412]	; 0xfffffe64
 8ac:	852f0105 	strhi	r0, [pc, #-261]!	; 7af <shift+0x7af>
 8b0:	05830605 	streq	r0, [r3, #1541]	; 0x605
 8b4:	0c054c0b 	stceq	12, cr4, [r5], {11}
 8b8:	660e052e 	strvs	r0, [lr], -lr, lsr #10
 8bc:	054b0405 	strbeq	r0, [fp, #-1029]	; 0xfffffbfb
 8c0:	09056502 	stmdbeq	r5, {r1, r8, sl, sp, lr}
 8c4:	2f010531 	svccs	0x00010531
 8c8:	9f080585 	svcls	0x00080585
 8cc:	054c0b05 	strbeq	r0, [ip, #-2821]	; 0xfffff4fb
 8d0:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
 8d4:	07054a03 	streq	r4, [r5, -r3, lsl #20]
 8d8:	02040200 	andeq	r0, r4, #0, 4
 8dc:	00080583 	andeq	r0, r8, r3, lsl #11
 8e0:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 8e4:	02000a05 	andeq	r0, r0, #20480	; 0x5000
 8e8:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 8ec:	04020002 	streq	r0, [r2], #-2
 8f0:	01054902 	tsteq	r5, r2, lsl #18
 8f4:	0e058584 	cfsh32eq	mvfx8, mvfx5, #-60
 8f8:	4b0805bb 	blmi	201fec <__bss_end+0x1f9020>
 8fc:	054c0b05 	strbeq	r0, [ip, #-2821]	; 0xfffff4fb
 900:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
 904:	16054a03 	strne	r4, [r5], -r3, lsl #20
 908:	02040200 	andeq	r0, r4, #0, 4
 90c:	00170583 	andseq	r0, r7, r3, lsl #11
 910:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 914:	02000a05 	andeq	r0, r0, #20480	; 0x5000
 918:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 91c:	0402000b 	streq	r0, [r2], #-11
 920:	17052e02 	strne	r2, [r5, -r2, lsl #28]
 924:	02040200 	andeq	r0, r4, #0, 4
 928:	000d054a 	andeq	r0, sp, sl, asr #10
 92c:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 930:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
 934:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
 938:	08028401 	stmdaeq	r2, {r0, sl, pc}
 93c:	79010100 	stmdbvc	r1, {r8}
 940:	03000000 	movweq	r0, #0
 944:	00004600 	andeq	r4, r0, r0, lsl #12
 948:	fb010200 	blx	41152 <__bss_end+0x38186>
 94c:	01000d0e 	tsteq	r0, lr, lsl #26
 950:	00010101 	andeq	r0, r1, r1, lsl #2
 954:	00010000 	andeq	r0, r1, r0
 958:	2e2e0100 	sufcse	f0, f6, f0
 95c:	2f2e2e2f 	svccs	0x002e2e2f
 960:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 964:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 968:	2f2e2e2f 	svccs	0x002e2e2f
 96c:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 970:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
 974:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
 978:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
 97c:	6c00006d 	stcvs	0, cr0, [r0], {109}	; 0x6d
 980:	66316269 	ldrtvs	r6, [r1], -r9, ror #4
 984:	73636e75 	cmnvc	r3, #1872	; 0x750
 988:	0100532e 	tsteq	r0, lr, lsr #6
 98c:	00000000 	andeq	r0, r0, r0
 990:	8ce00205 	sfmhi	f0, 2, [r0], #20
 994:	ca030000 	bgt	c099c <__bss_end+0xb79d0>
 998:	2f300108 	svccs	0x00300108
 99c:	2f2f2f2f 	svccs	0x002f2f2f
 9a0:	01d00230 	bicseq	r0, r0, r0, lsr r2
 9a4:	2f312f14 	svccs	0x00312f14
 9a8:	2f4c302f 	svccs	0x004c302f
 9ac:	661f0332 			; <UNDEFINED> instruction: 0x661f0332
 9b0:	2f2f2f2f 	svccs	0x002f2f2f
 9b4:	022f2f2f 	eoreq	r2, pc, #47, 30	; 0xbc
 9b8:	01010002 	tsteq	r1, r2
 9bc:	0000005c 	andeq	r0, r0, ip, asr r0
 9c0:	00460003 	subeq	r0, r6, r3
 9c4:	01020000 	mrseq	r0, (UNDEF: 2)
 9c8:	000d0efb 	strdeq	r0, [sp], -fp
 9cc:	01010101 	tsteq	r1, r1, lsl #2
 9d0:	01000000 	mrseq	r0, (UNDEF: 0)
 9d4:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
 9d8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 9dc:	2f2e2e2f 	svccs	0x002e2e2f
 9e0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 9e4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 9e8:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
 9ec:	2f636367 	svccs	0x00636367
 9f0:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
 9f4:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
 9f8:	00006d72 	andeq	r6, r0, r2, ror sp
 9fc:	3162696c 	cmncc	r2, ip, ror #18
 a00:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
 a04:	00532e73 	subseq	r2, r3, r3, ror lr
 a08:	00000001 	andeq	r0, r0, r1
 a0c:	ec020500 	cfstr32	mvfx0, [r2], {-0}
 a10:	0300008e 	movweq	r0, #142	; 0x8e
 a14:	02010bb4 	andeq	r0, r1, #180, 22	; 0x2d000
 a18:	01010002 	tsteq	r1, r2
 a1c:	00000103 	andeq	r0, r0, r3, lsl #2
 a20:	00fd0003 	rscseq	r0, sp, r3
 a24:	01020000 	mrseq	r0, (UNDEF: 2)
 a28:	000d0efb 	strdeq	r0, [sp], -fp
 a2c:	01010101 	tsteq	r1, r1, lsl #2
 a30:	01000000 	mrseq	r0, (UNDEF: 0)
 a34:	2e010000 	cdpcs	0, 0, cr0, cr1, cr0, {0}
 a38:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 a3c:	2f2e2e2f 	svccs	0x002e2e2f
 a40:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 a44:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 a48:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
 a4c:	2f636367 	svccs	0x00636367
 a50:	692f2e2e 	stmdbvs	pc!, {r1, r2, r3, r5, r9, sl, fp, sp}	; <UNPREDICTABLE>
 a54:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 a58:	2e006564 	cfsh32cs	mvfx6, mvfx0, #52
 a5c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 a60:	2f2e2e2f 	svccs	0x002e2e2f
 a64:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 a68:	2f2e2f2e 	svccs	0x002e2f2e
 a6c:	00636367 	rsbeq	r6, r3, r7, ror #6
 a70:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 a74:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 a78:	2f2e2e2f 	svccs	0x002e2e2f
 a7c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 a80:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
 a84:	63636762 	cmnvs	r3, #25690112	; 0x1880000
 a88:	2f2e2e2f 	svccs	0x002e2e2f
 a8c:	2f636367 	svccs	0x00636367
 a90:	666e6f63 	strbtvs	r6, [lr], -r3, ror #30
 a94:	612f6769 			; <UNDEFINED> instruction: 0x612f6769
 a98:	2e006d72 	mcrcs	13, 0, r6, cr0, cr2, {3}
 a9c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 aa0:	2f2e2e2f 	svccs	0x002e2e2f
 aa4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 aa8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 aac:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
 ab0:	00636367 	rsbeq	r6, r3, r7, ror #6
 ab4:	73616800 	cmnvc	r1, #0, 16
 ab8:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
 abc:	0100682e 	tsteq	r0, lr, lsr #16
 ac0:	72610000 	rsbvc	r0, r1, #0
 ac4:	73692d6d 	cmnvc	r9, #6976	; 0x1b40
 ac8:	00682e61 	rsbeq	r2, r8, r1, ror #28
 acc:	61000002 	tstvs	r0, r2
 ad0:	632d6d72 			; <UNDEFINED> instruction: 0x632d6d72
 ad4:	682e7570 	stmdavs	lr!, {r4, r5, r6, r8, sl, ip, sp, lr}
 ad8:	00000200 	andeq	r0, r0, r0, lsl #4
 adc:	6e736e69 	cdpvs	14, 7, cr6, cr3, cr9, {3}
 ae0:	6e6f632d 	cdpvs	3, 6, cr6, cr15, cr13, {1}
 ae4:	6e617473 	mcrvs	4, 3, r7, cr1, cr3, {3}
 ae8:	682e7374 	stmdavs	lr!, {r2, r4, r5, r6, r8, r9, ip, sp, lr}
 aec:	00000200 	andeq	r0, r0, r0, lsl #4
 af0:	2e6d7261 	cdpcs	2, 6, cr7, cr13, cr1, {3}
 af4:	00030068 	andeq	r0, r3, r8, rrx
 af8:	62696c00 	rsbvs	r6, r9, #0, 24
 afc:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
 b00:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
 b04:	62670000 	rsbvs	r0, r7, #0
 b08:	74632d6c 	strbtvc	r2, [r3], #-3436	; 0xfffff294
 b0c:	2e73726f 	cdpcs	2, 7, cr7, cr3, cr15, {3}
 b10:	00040068 	andeq	r0, r4, r8, rrx
 b14:	62696c00 	rsbvs	r6, r9, #0, 24
 b18:	32636367 	rsbcc	r6, r3, #-1677721599	; 0x9c000001
 b1c:	0400632e 	streq	r6, [r0], #-814	; 0xfffffcd2
 b20:	Address 0x0000000000000b20 is out of bounds.


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
      58:	1cbb0704 	ldcne	7, cr0, [fp], #16
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
      b0:	0b010000 	bleq	400b8 <__bss_end+0x370ec>
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
     11c:	1cbb0704 	ldcne	7, cr0, [fp], #16
     120:	72080000 	andvc	r0, r8, #0
     124:	01000003 	tsteq	r0, r3
     128:	00441533 	subeq	r1, r4, r3, lsr r5
     12c:	4a080000 	bmi	200134 <__bss_end+0x1f7168>
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
     15c:	3a010000 	bcc	40164 <__bss_end+0x37198>
     160:	00007615 	andeq	r7, r0, r5, lsl r6
     164:	01af0900 			; <UNDEFINED> instruction: 0x01af0900
     168:	48010000 	stmdami	r1, {}	; <UNPREDICTABLE>
     16c:	0000cb10 	andeq	ip, r0, r0, lsl fp
     170:	0081e000 	addeq	lr, r1, r0
     174:	00005800 	andeq	r5, r0, r0, lsl #16
     178:	cb9c0100 	blgt	fe700580 <__bss_end+0xfe6f75b4>
     17c:	0a000000 	beq	184 <shift+0x184>
     180:	000001bd 			; <UNDEFINED> instruction: 0x000001bd
     184:	d20c4a01 	andle	r4, ip, #4096	; 0x1000
     188:	02000000 	andeq	r0, r0, #0
     18c:	0b007491 	bleq	1d3d8 <__bss_end+0x1440c>
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
     200:	2a0c9c01 	bcs	32720c <__bss_end+0x31e240>
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
     254:	cb110a01 	blgt	442a60 <__bss_end+0x439a94>
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
     2bc:	0a010067 	beq	40460 <__bss_end+0x37494>
     2c0:	00019e2f 	andeq	r9, r1, pc, lsr #28
     2c4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     2c8:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     2cc:	00040000 	andeq	r0, r4, r0
     2d0:	000001c6 	andeq	r0, r0, r6, asr #3
     2d4:	02450104 	subeq	r0, r5, #4, 2
     2d8:	ec040000 	stc	0, cr0, [r4], {-0}
     2dc:	31000005 	tstcc	r0, r5
     2e0:	38000000 	stmdacc	r0, {}	; <UNPREDICTABLE>
     2e4:	94000082 	strls	r0, [r0], #-130	; 0xffffff7e
     2e8:	e1000001 	tst	r0, r1
     2ec:	02000001 	andeq	r0, r0, #1
     2f0:	0d460801 	stcleq	8, cr0, [r6, #-4]
     2f4:	25030000 	strcs	r0, [r3, #-0]
     2f8:	02000000 	andeq	r0, r0, #0
     2fc:	0dba0502 	cfldr32eq	mvfx0, [sl, #8]!
     300:	04040000 	streq	r0, [r4], #-0
     304:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
     308:	08010200 	stmdaeq	r1, {r9}
     30c:	00000d3d 	andeq	r0, r0, sp, lsr sp
     310:	cc070202 	sfmgt	f0, 4, [r7], {2}
     314:	05000009 	streq	r0, [r0, #-9]
     318:	00000e42 	andeq	r0, r0, r2, asr #28
     31c:	5e070903 	vmlapl.f16	s0, s14, s6	; <UNPREDICTABLE>
     320:	03000000 	movweq	r0, #0
     324:	0000004d 	andeq	r0, r0, sp, asr #32
     328:	bb070402 	bllt	1c1338 <__bss_end+0x1b836c>
     32c:	0300001c 	movweq	r0, #28
     330:	0000005e 	andeq	r0, r0, lr, asr r0
     334:	00005e06 	andeq	r5, r0, r6, lsl #28
     338:	07500700 	ldrbeq	r0, [r0, -r0, lsl #14]
     33c:	02080000 	andeq	r0, r8, #0
     340:	00950806 	addseq	r0, r5, r6, lsl #16
     344:	72080000 	andvc	r0, r8, #0
     348:	08020030 	stmdaeq	r2, {r4, r5}
     34c:	00004d0e 	andeq	r4, r0, lr, lsl #26
     350:	72080000 	andvc	r0, r8, #0
     354:	09020031 	stmdbeq	r2, {r0, r4, r5}
     358:	00004d0e 	andeq	r4, r0, lr, lsl #26
     35c:	09000400 	stmdbeq	r0, {sl}
     360:	0000056f 	andeq	r0, r0, pc, ror #10
     364:	00380405 	eorseq	r0, r8, r5, lsl #8
     368:	1e020000 	cdpne	0, 0, cr0, cr2, cr0, {0}
     36c:	0000cc0c 	andeq	ip, r0, ip, lsl #24
     370:	08050a00 	stmdaeq	r5, {r9, fp}
     374:	0a000000 	beq	37c <shift+0x37c>
     378:	0000124d 	andeq	r1, r0, sp, asr #4
     37c:	12170a01 	andsne	r0, r7, #4096	; 0x1000
     380:	0a020000 	beq	80388 <__bss_end+0x773bc>
     384:	00000a56 	andeq	r0, r0, r6, asr sl
     388:	0cae0a03 	vstmiaeq	lr!, {s0-s2}
     38c:	0a040000 	beq	100394 <__bss_end+0xf73c8>
     390:	000007ce 	andeq	r0, r0, lr, asr #15
     394:	f2090005 	vhadd.s8	d0, d9, d5
     398:	05000010 	streq	r0, [r0, #-16]
     39c:	00003804 	andeq	r3, r0, r4, lsl #16
     3a0:	0c3f0200 	lfmeq	f0, 4, [pc], #-0	; 3a8 <shift+0x3a8>
     3a4:	00000109 	andeq	r0, r0, r9, lsl #2
     3a8:	00041d0a 	andeq	r1, r4, sl, lsl #26
     3ac:	ab0a0000 	blge	2803b4 <__bss_end+0x2773e8>
     3b0:	01000005 	tsteq	r0, r5
     3b4:	000c690a 	andeq	r6, ip, sl, lsl #18
     3b8:	bb0a0200 	bllt	280bc0 <__bss_end+0x277bf4>
     3bc:	03000011 	movweq	r0, #17
     3c0:	0012570a 	andseq	r5, r2, sl, lsl #14
     3c4:	830a0400 	movwhi	r0, #41984	; 0xa400
     3c8:	0500000b 	streq	r0, [r0, #-11]
     3cc:	0009ec0a 	andeq	lr, r9, sl, lsl #24
     3d0:	05000600 	streq	r0, [r0, #-1536]	; 0xfffffa00
     3d4:	00000648 	andeq	r0, r0, r8, asr #12
     3d8:	38070304 	stmdacc	r7, {r2, r8, r9}
     3dc:	0b000000 	bleq	3e4 <shift+0x3e4>
     3e0:	00000bdb 	ldrdeq	r0, [r0], -fp
     3e4:	59140504 	ldmdbpl	r4, {r2, r8, sl}
     3e8:	05000000 	streq	r0, [r0, #-0]
     3ec:	008ef003 	addeq	pc, lr, r3
     3f0:	0c210b00 			; <UNDEFINED> instruction: 0x0c210b00
     3f4:	06040000 	streq	r0, [r4], -r0
     3f8:	00005914 	andeq	r5, r0, r4, lsl r9
     3fc:	f4030500 	vst3.8	{d0,d2,d4}, [r3], r0
     400:	0b00008e 	bleq	640 <shift+0x640>
     404:	00000b6d 	andeq	r0, r0, sp, ror #22
     408:	591a0705 	ldmdbpl	sl, {r0, r2, r8, r9, sl}
     40c:	05000000 	streq	r0, [r0, #-0]
     410:	008ef803 	addeq	pc, lr, r3, lsl #16
     414:	05da0b00 	ldrbeq	r0, [sl, #2816]	; 0xb00
     418:	09050000 	stmdbeq	r5, {}	; <UNPREDICTABLE>
     41c:	0000591a 	andeq	r5, r0, sl, lsl r9
     420:	fc030500 	stc2	5, cr0, [r3], {-0}
     424:	0b00008e 	bleq	664 <shift+0x664>
     428:	00000d2f 	andeq	r0, r0, pc, lsr #26
     42c:	591a0b05 	ldmdbpl	sl, {r0, r2, r8, r9, fp}
     430:	05000000 	streq	r0, [r0, #-0]
     434:	008f0003 	addeq	r0, pc, r3
     438:	09a60b00 	stmibeq	r6!, {r8, r9, fp}
     43c:	0d050000 	stceq	0, cr0, [r5, #-0]
     440:	0000591a 	andeq	r5, r0, sl, lsl r9
     444:	04030500 	streq	r0, [r3], #-1280	; 0xfffffb00
     448:	0b00008f 	bleq	68c <shift+0x68c>
     44c:	00000776 	andeq	r0, r0, r6, ror r7
     450:	591a0f05 	ldmdbpl	sl, {r0, r2, r8, r9, sl, fp}
     454:	05000000 	streq	r0, [r0, #-0]
     458:	008f0803 	addeq	r0, pc, r3, lsl #16
     45c:	0ea20900 	vfmaeq.f16	s0, s4, s0	; <UNPREDICTABLE>
     460:	04050000 	streq	r0, [r5], #-0
     464:	00000038 	andeq	r0, r0, r8, lsr r0
     468:	b80c1b05 	stmdalt	ip, {r0, r2, r8, r9, fp, ip}
     46c:	0a000001 	beq	478 <shift+0x478>
     470:	00000f0e 	andeq	r0, r0, lr, lsl #30
     474:	12070a00 	andne	r0, r7, #0, 20
     478:	0a010000 	beq	40480 <__bss_end+0x374b4>
     47c:	00000c64 	andeq	r0, r0, r4, ror #24
     480:	0b0c0002 	bleq	300490 <__bss_end+0x2f74c4>
     484:	0d00000d 	stceq	0, cr0, [r0, #-52]	; 0xffffffcc
     488:	00000d9f 	muleq	r0, pc, sp	; <UNPREDICTABLE>
     48c:	07630590 			; <UNDEFINED> instruction: 0x07630590
     490:	0000032b 	andeq	r0, r0, fp, lsr #6
     494:	00115d07 	andseq	r5, r1, r7, lsl #26
     498:	67052400 	strvs	r2, [r5, -r0, lsl #8]
     49c:	00024510 	andeq	r4, r2, r0, lsl r5
     4a0:	202b0e00 	eorcs	r0, fp, r0, lsl #28
     4a4:	69050000 	stmdbvs	r5, {}	; <UNPREDICTABLE>
     4a8:	00032b12 	andeq	r2, r3, r2, lsl fp
     4ac:	630e0000 	movwvs	r0, #57344	; 0xe000
     4b0:	05000005 	streq	r0, [r0, #-5]
     4b4:	033b126b 	teqeq	fp, #-1342177274	; 0xb0000006
     4b8:	0e100000 	cdpeq	0, 1, cr0, cr0, cr0, {0}
     4bc:	00000f03 	andeq	r0, r0, r3, lsl #30
     4c0:	4d166d05 	ldcmi	13, cr6, [r6, #-20]	; 0xffffffec
     4c4:	14000000 	strne	r0, [r0], #-0
     4c8:	0005d30e 	andeq	sp, r5, lr, lsl #6
     4cc:	1c700500 	cfldr64ne	mvdx0, [r0], #-0
     4d0:	00000342 	andeq	r0, r0, r2, asr #6
     4d4:	0d260e18 	stceq	14, cr0, [r6, #-96]!	; 0xffffffa0
     4d8:	72050000 	andvc	r0, r5, #0
     4dc:	0003421c 	andeq	r4, r3, ip, lsl r2
     4e0:	400e1c00 	andmi	r1, lr, r0, lsl #24
     4e4:	05000005 	streq	r0, [r0, #-5]
     4e8:	03421c75 	movteq	r1, #11381	; 0x2c75
     4ec:	0f200000 	svceq	0x00200000
     4f0:	00000817 	andeq	r0, r0, r7, lsl r8
     4f4:	691c7705 	ldmdbvs	ip, {r0, r2, r8, r9, sl, ip, sp, lr}
     4f8:	42000004 	andmi	r0, r0, #4
     4fc:	39000003 	stmdbcc	r0, {r0, r1}
     500:	10000002 	andne	r0, r0, r2
     504:	00000342 	andeq	r0, r0, r2, asr #6
     508:	00034811 	andeq	r4, r3, r1, lsl r8
     50c:	07000000 	streq	r0, [r0, -r0]
     510:	00000dc4 	andeq	r0, r0, r4, asr #27
     514:	107b0518 	rsbsne	r0, fp, r8, lsl r5
     518:	0000027a 	andeq	r0, r0, sl, ror r2
     51c:	00202b0e 	eoreq	r2, r0, lr, lsl #22
     520:	127e0500 	rsbsne	r0, lr, #0, 10
     524:	0000032b 	andeq	r0, r0, fp, lsr #6
     528:	05580e00 	ldrbeq	r0, [r8, #-3584]	; 0xfffff200
     52c:	80050000 	andhi	r0, r5, r0
     530:	00034819 	andeq	r4, r3, r9, lsl r8
     534:	c10e1000 	mrsgt	r1, (UNDEF: 14)
     538:	05000011 	streq	r0, [r0, #-17]	; 0xffffffef
     53c:	03532182 	cmpeq	r3, #-2147483616	; 0x80000020
     540:	00140000 	andseq	r0, r4, r0
     544:	00024503 	andeq	r4, r2, r3, lsl #10
     548:	0b171200 	bleq	5c4d50 <__bss_end+0x5bbd84>
     54c:	86050000 	strhi	r0, [r5], -r0
     550:	00035921 	andeq	r5, r3, r1, lsr #18
     554:	08cc1200 	stmiaeq	ip, {r9, ip}^
     558:	88050000 	stmdahi	r5, {}	; <UNPREDICTABLE>
     55c:	0000591f 	andeq	r5, r0, pc, lsl r9
     560:	0df60e00 	ldcleq	14, cr0, [r6]
     564:	8b050000 	blhi	14056c <__bss_end+0x1375a0>
     568:	0001ca17 	andeq	ip, r1, r7, lsl sl
     56c:	5c0e0000 	stcpl	0, cr0, [lr], {-0}
     570:	0500000a 	streq	r0, [r0, #-10]
     574:	01ca178e 	biceq	r1, sl, lr, lsl #15
     578:	0e240000 	cdpeq	0, 2, cr0, cr4, cr0, {0}
     57c:	00000937 	andeq	r0, r0, r7, lsr r9
     580:	ca178f05 	bgt	5e419c <__bss_end+0x5db1d0>
     584:	48000001 	stmdami	r0, {r0}
     588:	0012370e 	andseq	r3, r2, lr, lsl #14
     58c:	17900500 	ldrne	r0, [r0, r0, lsl #10]
     590:	000001ca 	andeq	r0, r0, sl, asr #3
     594:	0d9f136c 	ldceq	3, cr1, [pc, #432]	; 74c <shift+0x74c>
     598:	93050000 	movwls	r0, #20480	; 0x5000
     59c:	00068109 	andeq	r8, r6, r9, lsl #2
     5a0:	00036400 	andeq	r6, r3, r0, lsl #8
     5a4:	02e40100 	rsceq	r0, r4, #0, 2
     5a8:	02ea0000 	rsceq	r0, sl, #0
     5ac:	64100000 	ldrvs	r0, [r0], #-0
     5b0:	00000003 	andeq	r0, r0, r3
     5b4:	000b0c14 	andeq	r0, fp, r4, lsl ip
     5b8:	0e960500 	cdpeq	5, 9, cr0, cr6, cr0, {0}
     5bc:	00000a12 	andeq	r0, r0, r2, lsl sl
     5c0:	0002ff01 	andeq	pc, r2, r1, lsl #30
     5c4:	00030500 	andeq	r0, r3, r0, lsl #10
     5c8:	03641000 	cmneq	r4, #0
     5cc:	15000000 	strne	r0, [r0, #-0]
     5d0:	0000041d 	andeq	r0, r0, sp, lsl r4
     5d4:	87109905 	ldrhi	r9, [r0, -r5, lsl #18]
     5d8:	6a00000e 	bvs	618 <shift+0x618>
     5dc:	01000003 	tsteq	r0, r3
     5e0:	0000031a 	andeq	r0, r0, sl, lsl r3
     5e4:	00036410 	andeq	r6, r3, r0, lsl r4
     5e8:	03481100 	movteq	r1, #33024	; 0x8100
     5ec:	93110000 	tstls	r1, #0
     5f0:	00000001 	andeq	r0, r0, r1
     5f4:	00251600 	eoreq	r1, r5, r0, lsl #12
     5f8:	033b0000 	teqeq	fp, #0
     5fc:	5e170000 	cdppl	0, 1, cr0, cr7, cr0, {0}
     600:	0f000000 	svceq	0x00000000
     604:	02010200 	andeq	r0, r1, #0, 4
     608:	00000a73 	andeq	r0, r0, r3, ror sl
     60c:	01ca0418 	biceq	r0, sl, r8, lsl r4
     610:	04180000 	ldreq	r0, [r8], #-0
     614:	0000002c 	andeq	r0, r0, ip, lsr #32
     618:	0011cd0c 	andseq	ip, r1, ip, lsl #26
     61c:	4e041800 	cdpmi	8, 0, cr1, cr4, cr0, {0}
     620:	16000003 	strne	r0, [r0], -r3
     624:	0000027a 	andeq	r0, r0, sl, ror r2
     628:	00000364 	andeq	r0, r0, r4, ror #6
     62c:	04180019 	ldreq	r0, [r8], #-25	; 0xffffffe7
     630:	000001bd 			; <UNDEFINED> instruction: 0x000001bd
     634:	01b80418 			; <UNDEFINED> instruction: 0x01b80418
     638:	fc1a0000 	ldc2	0, cr0, [sl], {-0}
     63c:	0500000d 	streq	r0, [r0, #-13]
     640:	01bd149c 			; <UNDEFINED> instruction: 0x01bd149c
     644:	780b0000 	stmdavc	fp, {}	; <UNPREDICTABLE>
     648:	06000008 	streq	r0, [r0], -r8
     64c:	00591404 	subseq	r1, r9, r4, lsl #8
     650:	03050000 	movweq	r0, #20480	; 0x5000
     654:	00008f0c 	andeq	r8, r0, ip, lsl #30
     658:	0003a80b 	andeq	sl, r3, fp, lsl #16
     65c:	14070600 	strne	r0, [r7], #-1536	; 0xfffffa00
     660:	00000059 	andeq	r0, r0, r9, asr r0
     664:	8f100305 	svchi	0x00100305
     668:	5d0b0000 	stcpl	0, cr0, [fp, #-0]
     66c:	06000006 	streq	r0, [r0], -r6
     670:	0059140a 	subseq	r1, r9, sl, lsl #8
     674:	03050000 	movweq	r0, #20480	; 0x5000
     678:	00008f14 	andeq	r8, r0, r4, lsl pc
     67c:	000adc09 	andeq	sp, sl, r9, lsl #24
     680:	38040500 	stmdacc	r4, {r8, sl}
     684:	06000000 	streq	r0, [r0], -r0
     688:	03e90c0d 	mvneq	r0, #3328	; 0xd00
     68c:	4e1b0000 	cdpmi	0, 1, cr0, cr11, cr0, {0}
     690:	00007765 	andeq	r7, r0, r5, ror #14
     694:	000ad30a 	andeq	sp, sl, sl, lsl #6
     698:	0e0a0100 	adfeqe	f0, f2, f0
     69c:	0200000e 	andeq	r0, r0, #14
     6a0:	000a8e0a 	andeq	r8, sl, sl, lsl #28
     6a4:	480a0300 	stmdami	sl, {r8, r9}
     6a8:	0400000a 	streq	r0, [r0], #-10
     6ac:	000c6f0a 	andeq	r6, ip, sl, lsl #30
     6b0:	07000500 	streq	r0, [r0, -r0, lsl #10]
     6b4:	000007c1 	andeq	r0, r0, r1, asr #15
     6b8:	081b0610 	ldmdaeq	fp, {r4, r9, sl}
     6bc:	00000428 	andeq	r0, r0, r8, lsr #8
     6c0:	00726c08 	rsbseq	r6, r2, r8, lsl #24
     6c4:	28131d06 	ldmdacs	r3, {r1, r2, r8, sl, fp, ip}
     6c8:	00000004 	andeq	r0, r0, r4
     6cc:	00707308 	rsbseq	r7, r0, r8, lsl #6
     6d0:	28131e06 	ldmdacs	r3, {r1, r2, r9, sl, fp, ip}
     6d4:	04000004 	streq	r0, [r0], #-4
     6d8:	00637008 	rsbeq	r7, r3, r8
     6dc:	28131f06 	ldmdacs	r3, {r1, r2, r8, r9, sl, fp, ip}
     6e0:	08000004 	stmdaeq	r0, {r2}
     6e4:	0007d70e 	andeq	sp, r7, lr, lsl #14
     6e8:	13200600 	nopne	{0}	; <UNPREDICTABLE>
     6ec:	00000428 	andeq	r0, r0, r8, lsr #8
     6f0:	0402000c 	streq	r0, [r2], #-12
     6f4:	001cb607 	andseq	fp, ip, r7, lsl #12
     6f8:	04280300 	strteq	r0, [r8], #-768	; 0xfffffd00
     6fc:	5c070000 	stcpl	0, cr0, [r7], {-0}
     700:	70000004 	andvc	r0, r0, r4
     704:	c4082806 	strgt	r2, [r8], #-2054	; 0xfffff7fa
     708:	0e000004 	cdpeq	0, 0, cr0, cr0, cr4, {0}
     70c:	00001241 	andeq	r1, r0, r1, asr #4
     710:	e9122a06 	ldmdb	r2, {r1, r2, r9, fp, sp}
     714:	00000003 	andeq	r0, r0, r3
     718:	64697008 	strbtvs	r7, [r9], #-8
     71c:	122b0600 	eorne	r0, fp, #0, 12
     720:	0000005e 	andeq	r0, r0, lr, asr r0
     724:	1a070e10 	bne	1c3f6c <__bss_end+0x1bafa0>
     728:	2c060000 	stccs	0, cr0, [r6], {-0}
     72c:	0003b211 	andeq	fp, r3, r1, lsl r2
     730:	e80e1400 	stmda	lr, {sl, ip}
     734:	0600000a 	streq	r0, [r0], -sl
     738:	005e122d 	subseq	r1, lr, sp, lsr #4
     73c:	0e180000 	cdpeq	0, 1, cr0, cr8, cr0, {0}
     740:	00000af6 	strdeq	r0, [r0], -r6
     744:	5e122e06 	cdppl	14, 1, cr2, cr2, cr6, {0}
     748:	1c000000 	stcne	0, cr0, [r0], {-0}
     74c:	0007690e 	andeq	r6, r7, lr, lsl #18
     750:	0c2f0600 	stceq	6, cr0, [pc], #-0	; 758 <shift+0x758>
     754:	000004c4 	andeq	r0, r0, r4, asr #9
     758:	0b230e20 	bleq	8c3fe0 <__bss_end+0x8bb014>
     75c:	30060000 	andcc	r0, r6, r0
     760:	00003809 	andeq	r3, r0, r9, lsl #16
     764:	180e6000 	stmdane	lr, {sp, lr}
     768:	0600000f 	streq	r0, [r0], -pc
     76c:	004d0e31 	subeq	r0, sp, r1, lsr lr
     770:	0e640000 	cdpeq	0, 6, cr0, cr4, cr0, {0}
     774:	0000082b 	andeq	r0, r0, fp, lsr #16
     778:	4d0e3306 	stcmi	3, cr3, [lr, #-24]	; 0xffffffe8
     77c:	68000000 	stmdavs	r0, {}	; <UNPREDICTABLE>
     780:	0008220e 	andeq	r2, r8, lr, lsl #4
     784:	0e340600 	cfmsuba32eq	mvax0, mvax0, mvfx4, mvfx0
     788:	0000004d 	andeq	r0, r0, sp, asr #32
     78c:	6a16006c 	bvs	580944 <__bss_end+0x577978>
     790:	d4000003 	strle	r0, [r0], #-3
     794:	17000004 	strne	r0, [r0, -r4]
     798:	0000005e 	andeq	r0, r0, lr, asr r0
     79c:	4e0b000f 	cdpmi	0, 0, cr0, cr11, cr15, {0}
     7a0:	07000011 	smladeq	r0, r1, r0, r0
     7a4:	0059140a 	subseq	r1, r9, sl, lsl #8
     7a8:	03050000 	movweq	r0, #20480	; 0x5000
     7ac:	00008f18 	andeq	r8, r0, r8, lsl pc
     7b0:	000a9609 	andeq	r9, sl, r9, lsl #12
     7b4:	38040500 	stmdacc	r4, {r8, sl}
     7b8:	07000000 	streq	r0, [r0, -r0]
     7bc:	05050c0d 	streq	r0, [r5, #-3085]	; 0xfffff3f3
     7c0:	840a0000 	strhi	r0, [sl], #-0
     7c4:	00000005 	andeq	r0, r0, r5
     7c8:	00039d0a 	andeq	r9, r3, sl, lsl #26
     7cc:	07000100 	streq	r0, [r0, -r0, lsl #2]
     7d0:	00001005 	andeq	r1, r0, r5
     7d4:	081b070c 	ldmdaeq	fp, {r2, r3, r8, r9, sl}
     7d8:	0000053a 	andeq	r0, r0, sl, lsr r5
     7dc:	00042e0e 	andeq	r2, r4, lr, lsl #28
     7e0:	191d0700 	ldmdbne	sp, {r8, r9, sl}
     7e4:	0000053a 	andeq	r0, r0, sl, lsr r5
     7e8:	05400e00 	strbeq	r0, [r0, #-3584]	; 0xfffff200
     7ec:	1e070000 	cdpne	0, 0, cr0, cr7, cr0, {0}
     7f0:	00053a19 	andeq	r3, r5, r9, lsl sl
     7f4:	8c0e0400 	cfstrshi	mvf0, [lr], {-0}
     7f8:	0700000f 	streq	r0, [r0, -pc]
     7fc:	0540131f 	strbeq	r1, [r0, #-799]	; 0xfffffce1
     800:	00080000 	andeq	r0, r8, r0
     804:	05050418 	streq	r0, [r5, #-1048]	; 0xfffffbe8
     808:	04180000 	ldreq	r0, [r8], #-0
     80c:	00000434 	andeq	r0, r0, r4, lsr r4
     810:	0006700d 	andeq	r7, r6, sp
     814:	22071400 	andcs	r1, r7, #0, 8
     818:	0007c807 	andeq	ip, r7, r7, lsl #16
     81c:	0a840e00 	beq	fe104024 <__bss_end+0xfe0fb058>
     820:	26070000 	strcs	r0, [r7], -r0
     824:	00004d12 	andeq	r4, r0, r2, lsl sp
     828:	da0e0000 	ble	380830 <__bss_end+0x377864>
     82c:	07000004 	streq	r0, [r0, -r4]
     830:	053a1d29 	ldreq	r1, [sl, #-3369]!	; 0xfffff2d7
     834:	0e040000 	cdpeq	0, 0, cr0, cr4, cr0, {0}
     838:	00000e74 	andeq	r0, r0, r4, ror lr
     83c:	3a1d2c07 	bcc	74b860 <__bss_end+0x742894>
     840:	08000005 	stmdaeq	r0, {r0, r2}
     844:	0010e81c 	andseq	lr, r0, ip, lsl r8
     848:	0e2f0700 	cdpeq	7, 2, cr0, cr15, cr0, {0}
     84c:	00000fe2 	andeq	r0, r0, r2, ror #31
     850:	0000058e 	andeq	r0, r0, lr, lsl #11
     854:	00000599 	muleq	r0, r9, r5
     858:	0007cd10 	andeq	ip, r7, r0, lsl sp
     85c:	053a1100 	ldreq	r1, [sl, #-256]!	; 0xffffff00
     860:	1d000000 	stcne	0, cr0, [r0, #-0]
     864:	00000f9b 	muleq	r0, fp, pc	; <UNPREDICTABLE>
     868:	330e3107 	movwcc	r3, #57607	; 0xe107
     86c:	3b000004 	blcc	884 <shift+0x884>
     870:	b1000003 	tstlt	r0, r3
     874:	bc000005 	stclt	0, cr0, [r0], {5}
     878:	10000005 	andne	r0, r0, r5
     87c:	000007cd 	andeq	r0, r0, sp, asr #15
     880:	00054011 	andeq	r4, r5, r1, lsl r0
     884:	47130000 	ldrmi	r0, [r3, -r0]
     888:	07000010 	smladeq	r0, r0, r0, r0
     88c:	0f671d35 	svceq	0x00671d35
     890:	053a0000 	ldreq	r0, [sl, #-0]!
     894:	d5020000 	strle	r0, [r2, #-0]
     898:	db000005 	blle	8b4 <shift+0x8b4>
     89c:	10000005 	andne	r0, r0, r5
     8a0:	000007cd 	andeq	r0, r0, sp, asr #15
     8a4:	09df1300 	ldmibeq	pc, {r8, r9, ip}^	; <UNPREDICTABLE>
     8a8:	37070000 	strcc	r0, [r7, -r0]
     8ac:	000d791d 	andeq	r7, sp, sp, lsl r9
     8b0:	00053a00 	andeq	r3, r5, r0, lsl #20
     8b4:	05f40200 	ldrbeq	r0, [r4, #512]!	; 0x200
     8b8:	05fa0000 	ldrbeq	r0, [sl, #0]!
     8bc:	cd100000 	ldcgt	0, cr0, [r0, #-0]
     8c0:	00000007 	andeq	r0, r0, r7
     8c4:	000b531e 	andeq	r5, fp, lr, lsl r3
     8c8:	31390700 	teqcc	r9, r0, lsl #14
     8cc:	000007e6 	andeq	r0, r0, r6, ror #15
     8d0:	7013020c 	andsvc	r0, r3, ip, lsl #4
     8d4:	07000006 	streq	r0, [r0, -r6]
     8d8:	121d093c 	andsne	r0, sp, #60, 18	; 0xf0000
     8dc:	07cd0000 	strbeq	r0, [sp, r0]
     8e0:	21010000 	mrscs	r0, (UNDEF: 1)
     8e4:	27000006 	strcs	r0, [r0, -r6]
     8e8:	10000006 	andne	r0, r0, r6
     8ec:	000007cd 	andeq	r0, r0, sp, asr #15
     8f0:	05be1300 	ldreq	r1, [lr, #768]!	; 0x300
     8f4:	3f070000 	svccc	0x00070000
     8f8:	0010bd12 	andseq	fp, r0, r2, lsl sp
     8fc:	00004d00 	andeq	r4, r0, r0, lsl #26
     900:	06400100 	strbeq	r0, [r0], -r0, lsl #2
     904:	06550000 	ldrbeq	r0, [r5], -r0
     908:	cd100000 	ldcgt	0, cr0, [r0, #-0]
     90c:	11000007 	tstne	r0, r7
     910:	000007ef 	andeq	r0, r0, pc, ror #15
     914:	00005e11 	andeq	r5, r0, r1, lsl lr
     918:	033b1100 	teqeq	fp, #0, 2
     91c:	14000000 	strne	r0, [r0], #-0
     920:	00000faa 	andeq	r0, r0, sl, lsr #31
     924:	bd0e4207 	sfmlt	f4, 4, [lr, #-28]	; 0xffffffe4
     928:	0100000c 	tsteq	r0, ip
     92c:	0000066a 	andeq	r0, r0, sl, ror #12
     930:	00000670 	andeq	r0, r0, r0, ror r6
     934:	0007cd10 	andeq	ip, r7, r0, lsl sp
     938:	41130000 	tstmi	r3, r0
     93c:	07000009 	streq	r0, [r0, -r9]
     940:	04ff1745 	ldrbteq	r1, [pc], #1861	; 948 <shift+0x948>
     944:	05400000 	strbeq	r0, [r0, #-0]
     948:	89010000 	stmdbhi	r1, {}	; <UNPREDICTABLE>
     94c:	8f000006 	svchi	0x00000006
     950:	10000006 	andne	r0, r0, r6
     954:	000007f5 	strdeq	r0, [r0], -r5
     958:	05451300 	strbeq	r1, [r5, #-768]	; 0xfffffd00
     95c:	48070000 	stmdami	r7, {}	; <UNPREDICTABLE>
     960:	000f2417 	andeq	r2, pc, r7, lsl r4	; <UNPREDICTABLE>
     964:	00054000 	andeq	r4, r5, r0
     968:	06a80100 	strteq	r0, [r8], r0, lsl #2
     96c:	06b30000 	ldrteq	r0, [r3], r0
     970:	f5100000 			; <UNDEFINED> instruction: 0xf5100000
     974:	11000007 	tstne	r0, r7
     978:	0000004d 	andeq	r0, r0, sp, asr #32
     97c:	116b1400 	cmnne	fp, r0, lsl #8
     980:	4b070000 	blmi	1c0988 <__bss_end+0x1b79bc>
     984:	000fb30e 	andeq	fp, pc, lr, lsl #6
     988:	06c80100 	strbeq	r0, [r8], r0, lsl #2
     98c:	06ce0000 	strbeq	r0, [lr], r0
     990:	cd100000 	ldcgt	0, cr0, [r0, #-0]
     994:	00000007 	andeq	r0, r0, r7
     998:	000f9b13 	andeq	r9, pc, r3, lsl fp	; <UNPREDICTABLE>
     99c:	0e4d0700 	cdpeq	7, 4, cr0, cr13, cr0, {0}
     9a0:	000007dd 	ldrdeq	r0, [r0], -sp
     9a4:	0000033b 	andeq	r0, r0, fp, lsr r3
     9a8:	0006e701 	andeq	lr, r6, r1, lsl #14
     9ac:	0006f200 	andeq	pc, r6, r0, lsl #4
     9b0:	07cd1000 	strbeq	r1, [sp, r0]
     9b4:	4d110000 	ldcmi	0, cr0, [r1, #-0]
     9b8:	00000000 	andeq	r0, r0, r0
     9bc:	00095513 	andeq	r5, r9, r3, lsl r5
     9c0:	12500700 	subsne	r0, r0, #0, 14
     9c4:	00000cde 	ldrdeq	r0, [r0], -lr
     9c8:	0000004d 	andeq	r0, r0, sp, asr #32
     9cc:	00070b01 	andeq	r0, r7, r1, lsl #22
     9d0:	00071600 	andeq	r1, r7, r0, lsl #12
     9d4:	07cd1000 	strbeq	r1, [sp, r0]
     9d8:	6a110000 	bvs	4409e0 <__bss_end+0x437a14>
     9dc:	00000003 	andeq	r0, r0, r3
     9e0:	00049e13 	andeq	r9, r4, r3, lsl lr
     9e4:	0e530700 	cdpeq	7, 5, cr0, cr3, cr0, {0}
     9e8:	00000891 	muleq	r0, r1, r8
     9ec:	0000033b 	andeq	r0, r0, fp, lsr r3
     9f0:	00072f01 	andeq	r2, r7, r1, lsl #30
     9f4:	00073a00 	andeq	r3, r7, r0, lsl #20
     9f8:	07cd1000 	strbeq	r1, [sp, r0]
     9fc:	4d110000 	ldcmi	0, cr0, [r1, #-0]
     a00:	00000000 	andeq	r0, r0, r0
     a04:	0009b914 	andeq	fp, r9, r4, lsl r9
     a08:	0e560700 	cdpeq	7, 5, cr0, cr6, cr0, {0}
     a0c:	00001066 	andeq	r1, r0, r6, rrx
     a10:	00074f01 	andeq	r4, r7, r1, lsl #30
     a14:	00076e00 	andeq	r6, r7, r0, lsl #28
     a18:	07cd1000 	strbeq	r1, [sp, r0]
     a1c:	95110000 	ldrls	r0, [r1, #-0]
     a20:	11000000 	mrsne	r0, (UNDEF: 0)
     a24:	0000004d 	andeq	r0, r0, sp, asr #32
     a28:	00004d11 	andeq	r4, r0, r1, lsl sp
     a2c:	004d1100 	subeq	r1, sp, r0, lsl #2
     a30:	fb110000 	blx	440a3a <__bss_end+0x437a6e>
     a34:	00000007 	andeq	r0, r0, r7
     a38:	000f5114 	andeq	r5, pc, r4, lsl r1	; <UNPREDICTABLE>
     a3c:	0e580700 	cdpeq	7, 5, cr0, cr8, cr0, {0}
     a40:	00000704 	andeq	r0, r0, r4, lsl #14
     a44:	00078301 	andeq	r8, r7, r1, lsl #6
     a48:	0007a200 	andeq	sl, r7, r0, lsl #4
     a4c:	07cd1000 	strbeq	r1, [sp, r0]
     a50:	cc110000 	ldcgt	0, cr0, [r1], {-0}
     a54:	11000000 	mrsne	r0, (UNDEF: 0)
     a58:	0000004d 	andeq	r0, r0, sp, asr #32
     a5c:	00004d11 	andeq	r4, r0, r1, lsl sp
     a60:	004d1100 	subeq	r1, sp, r0, lsl #2
     a64:	fb110000 	blx	440a6e <__bss_end+0x437aa2>
     a68:	00000007 	andeq	r0, r0, r7
     a6c:	00063515 	andeq	r3, r6, r5, lsl r5
     a70:	0e5b0700 	cdpeq	7, 5, cr0, cr11, cr0, {0}
     a74:	00000696 	muleq	r0, r6, r6
     a78:	0000033b 	andeq	r0, r0, fp, lsr r3
     a7c:	0007b701 	andeq	fp, r7, r1, lsl #14
     a80:	07cd1000 	strbeq	r1, [sp, r0]
     a84:	e6110000 	ldr	r0, [r1], -r0
     a88:	11000004 	tstne	r0, r4
     a8c:	00000801 	andeq	r0, r0, r1, lsl #16
     a90:	46030000 	strmi	r0, [r3], -r0
     a94:	18000005 	stmdane	r0, {r0, r2}
     a98:	00054604 	andeq	r4, r5, r4, lsl #12
     a9c:	053a1f00 	ldreq	r1, [sl, #-3840]!	; 0xfffff100
     aa0:	07e00000 	strbeq	r0, [r0, r0]!
     aa4:	07e60000 	strbeq	r0, [r6, r0]!
     aa8:	cd100000 	ldcgt	0, cr0, [r0, #-0]
     aac:	00000007 	andeq	r0, r0, r7
     ab0:	00054620 	andeq	r4, r5, r0, lsr #12
     ab4:	0007d300 	andeq	sp, r7, r0, lsl #6
     ab8:	3f041800 	svccc	0x00041800
     abc:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
     ac0:	0007c804 	andeq	ip, r7, r4, lsl #16
     ac4:	6f042100 	svcvs	0x00042100
     ac8:	22000000 	andcs	r0, r0, #0
     acc:	0b611a04 	bleq	18472e4 <__bss_end+0x183e318>
     ad0:	5e070000 	cdppl	0, 0, cr0, cr7, cr0, {0}
     ad4:	00054619 	andeq	r4, r5, r9, lsl r6
     ad8:	61682300 	cmnvs	r8, r0, lsl #6
     adc:	0508006c 	streq	r0, [r8, #-108]	; 0xffffff94
     ae0:	0008c90b 	andeq	ip, r8, fp, lsl #18
     ae4:	0b8a2400 	bleq	fe289aec <__bss_end+0xfe280b20>
     ae8:	07080000 	streq	r0, [r8, -r0]
     aec:	00006519 	andeq	r6, r0, r9, lsl r5
     af0:	e6b28000 	ldrt	r8, [r2], r0
     af4:	0de6240e 	cfstrdeq	mvd2, [r6, #56]!	; 0x38
     af8:	0a080000 	beq	200b00 <__bss_end+0x1f7b34>
     afc:	00042f1a 	andeq	r2, r4, sl, lsl pc
     b00:	00000000 	andeq	r0, r0, r0
     b04:	0be92420 	bleq	ffa49b8c <__bss_end+0xffa40bc0>
     b08:	0d080000 	stceq	0, cr0, [r8, #-0]
     b0c:	00042f1a 	andeq	r2, r4, sl, lsl pc
     b10:	20000000 	andcs	r0, r0, r0
     b14:	0dab2520 	cfstr32eq	mvfx2, [fp, #128]!	; 0x80
     b18:	10080000 	andne	r0, r8, r0
     b1c:	00005915 	andeq	r5, r0, r5, lsl r9
     b20:	2c243600 	stccs	6, cr3, [r4], #-0
     b24:	08000006 	stmdaeq	r0, {r1, r2}
     b28:	042f1a42 	strteq	r1, [pc], #-2626	; b30 <shift+0xb30>
     b2c:	50000000 	andpl	r0, r0, r0
     b30:	34242021 	strtcc	r2, [r4], #-33	; 0xffffffdf
     b34:	08000008 	stmdaeq	r0, {r3}
     b38:	042f1a71 	strteq	r1, [pc], #-2673	; b40 <shift+0xb40>
     b3c:	b2000000 	andlt	r0, r0, #0
     b40:	69242000 	stmdbvs	r4!, {sp}
     b44:	0800000e 	stmdaeq	r0, {r1, r2, r3}
     b48:	042f1aa4 	strteq	r1, [pc], #-2724	; b50 <shift+0xb50>
     b4c:	b4000000 	strlt	r0, [r0], #-0
     b50:	bd242000 	stclt	0, cr2, [r4, #-0]
     b54:	08000008 	stmdaeq	r0, {r3}
     b58:	042f1ab3 	strteq	r1, [pc], #-2739	; b60 <shift+0xb60>
     b5c:	40000000 	andmi	r0, r0, r0
     b60:	0d242010 	stceq	0, cr2, [r4, #-64]!	; 0xffffffc0
     b64:	08000008 	stmdaeq	r0, {r3}
     b68:	042f1abe 	strteq	r1, [pc], #-2750	; b70 <shift+0xb70>
     b6c:	50000000 	andpl	r0, r0, r0
     b70:	6e242020 	cdpvs	0, 2, cr2, cr4, cr0, {1}
     b74:	08000008 	stmdaeq	r0, {r3}
     b78:	042f1abf 	strteq	r1, [pc], #-2751	; b80 <shift+0xb80>
     b7c:	40000000 	andmi	r0, r0, r0
     b80:	d0242080 	eorle	r2, r4, r0, lsl #1
     b84:	08000004 	stmdaeq	r0, {r2}
     b88:	042f1ac0 	strteq	r1, [pc], #-2752	; b90 <shift+0xb90>
     b8c:	50000000 	andpl	r0, r0, r0
     b90:	26002080 	strcs	r2, [r0], -r0, lsl #1
     b94:	0000081b 	andeq	r0, r0, fp, lsl r8
     b98:	00082b26 	andeq	r2, r8, r6, lsr #22
     b9c:	083b2600 	ldmdaeq	fp!, {r9, sl, sp}
     ba0:	4b260000 	blmi	980ba8 <__bss_end+0x977bdc>
     ba4:	26000008 	strcs	r0, [r0], -r8
     ba8:	00000858 	andeq	r0, r0, r8, asr r8
     bac:	00086826 	andeq	r6, r8, r6, lsr #16
     bb0:	08782600 	ldmdaeq	r8!, {r9, sl, sp}^
     bb4:	88260000 	stmdahi	r6!, {}	; <UNPREDICTABLE>
     bb8:	26000008 	strcs	r0, [r0], -r8
     bbc:	00000898 	muleq	r0, r8, r8
     bc0:	0008a826 	andeq	sl, r8, r6, lsr #16
     bc4:	08b82600 	ldmeq	r8!, {r9, sl, sp}
     bc8:	2d0b0000 	stccs	0, cr0, [fp, #-0]
     bcc:	0900000b 	stmdbeq	r0, {r0, r1, r3}
     bd0:	00591408 	subseq	r1, r9, r8, lsl #8
     bd4:	03050000 	movweq	r0, #20480	; 0x5000
     bd8:	00008f48 	andeq	r8, r0, r8, asr #30
     bdc:	000c9f09 	andeq	r9, ip, r9, lsl #30
     be0:	5e040700 	cdppl	7, 0, cr0, cr4, cr0, {0}
     be4:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     be8:	095b0c0b 	ldmdbeq	fp, {r0, r1, r3, sl, fp}^
     bec:	950a0000 	strls	r0, [sl, #-0]
     bf0:	0000000f 	andeq	r0, r0, pc
     bf4:	000c5d0a 	andeq	r5, ip, sl, lsl #26
     bf8:	ab0a0100 	blge	281000 <__bss_end+0x278034>
     bfc:	0200000a 	andeq	r0, r0, #10
     c00:	0004280a 	andeq	r2, r4, sl, lsl #16
     c04:	170a0300 	strne	r0, [sl, -r0, lsl #6]
     c08:	04000004 	streq	r0, [r0], #-4
     c0c:	000a780a 	andeq	r7, sl, sl, lsl #16
     c10:	7e0a0500 	cfsh32vc	mvfx0, mvfx10, #0
     c14:	0600000a 	streq	r0, [r0], -sl
     c18:	0004220a 	andeq	r2, r4, sl, lsl #4
     c1c:	fb0a0700 	blx	282826 <__bss_end+0x27985a>
     c20:	08000011 	stmdaeq	r0, {r0, r4}
     c24:	03de0900 	bicseq	r0, lr, #0, 18
     c28:	04050000 	streq	r0, [r5], #-0
     c2c:	00000038 	andeq	r0, r0, r8, lsr r0
     c30:	860c1d09 	strhi	r1, [ip], -r9, lsl #26
     c34:	0a000009 	beq	c60 <shift+0xc60>
     c38:	0000092b 	andeq	r0, r0, fp, lsr #18
     c3c:	075c0a00 	ldrbeq	r0, [ip, -r0, lsl #20]
     c40:	0a010000 	beq	40c48 <__bss_end+0x37c7c>
     c44:	000008c7 	andeq	r0, r0, r7, asr #17
     c48:	6f4c1b02 	svcvs	0x004c1b02
     c4c:	00030077 	andeq	r0, r3, r7, ror r0
     c50:	0011ed0d 	andseq	lr, r1, sp, lsl #26
     c54:	28091c00 	stmdacs	r9, {sl, fp, ip}
     c58:	000d0707 	andeq	r0, sp, r7, lsl #14
     c5c:	05b00700 	ldreq	r0, [r0, #1792]!	; 0x700
     c60:	09100000 	ldmdbeq	r0, {}	; <UNPREDICTABLE>
     c64:	09d50a33 	ldmibeq	r5, {r0, r1, r4, r5, r9, fp}^
     c68:	e80e0000 	stmda	lr, {}	; <UNPREDICTABLE>
     c6c:	09000011 	stmdbeq	r0, {r0, r4}
     c70:	036a0b35 	cmneq	sl, #54272	; 0xd400
     c74:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     c78:	00001181 	andeq	r1, r0, r1, lsl #3
     c7c:	4d0d3609 	stcmi	6, cr3, [sp, #-36]	; 0xffffffdc
     c80:	04000000 	streq	r0, [r0], #-0
     c84:	00042e0e 	andeq	r2, r4, lr, lsl #28
     c88:	13370900 	teqne	r7, #0, 18
     c8c:	00000d0c 	andeq	r0, r0, ip, lsl #26
     c90:	05400e08 	strbeq	r0, [r0, #-3592]	; 0xfffff1f8
     c94:	38090000 	stmdacc	r9, {}	; <UNPREDICTABLE>
     c98:	000d0c13 	andeq	r0, sp, r3, lsl ip
     c9c:	0e000c00 	cdpeq	12, 0, cr0, cr0, cr0, {0}
     ca0:	000005cd 	andeq	r0, r0, sp, asr #11
     ca4:	18202c09 	stmdane	r0!, {r0, r3, sl, fp, sp}
     ca8:	0000000d 	andeq	r0, r0, sp
     cac:	0005990e 	andeq	r9, r5, lr, lsl #18
     cb0:	0c2f0900 			; <UNDEFINED> instruction: 0x0c2f0900
     cb4:	00000d1d 	andeq	r0, r0, sp, lsl sp
     cb8:	0c2d0e04 	stceq	14, cr0, [sp], #-16
     cbc:	31090000 	mrscc	r0, (UNDEF: 9)
     cc0:	000d1d0c 	andeq	r1, sp, ip, lsl #26
     cc4:	f40e0c00 			; <UNDEFINED> instruction: 0xf40e0c00
     cc8:	0900000e 	stmdbeq	r0, {r1, r2, r3}
     ccc:	0d0c123b 	sfmeq	f1, 4, [ip, #-236]	; 0xffffff14
     cd0:	0e140000 	cdpeq	0, 1, cr0, cr4, cr0, {0}
     cd4:	00000e08 	andeq	r0, r0, r8, lsl #28
     cd8:	090e3d09 	stmdbeq	lr, {r0, r3, r8, sl, fp, ip, sp}
     cdc:	18000001 	stmdane	r0, {r0}
     ce0:	000c4513 	andeq	r4, ip, r3, lsl r5
     ce4:	08410900 	stmdaeq	r1, {r8, fp}^
     ce8:	00000969 	andeq	r0, r0, r9, ror #18
     cec:	0000033b 	andeq	r0, r0, fp, lsr r3
     cf0:	000a2f02 	andeq	r2, sl, r2, lsl #30
     cf4:	000a4400 	andeq	r4, sl, r0, lsl #8
     cf8:	0d2d1000 	stceq	0, cr1, [sp, #-0]
     cfc:	4d110000 	ldcmi	0, cr0, [r1, #-0]
     d00:	11000000 	mrsne	r0, (UNDEF: 0)
     d04:	00000d33 	andeq	r0, r0, r3, lsr sp
     d08:	000d3311 	andeq	r3, sp, r1, lsl r3
     d0c:	0e130000 	cdpeq	0, 1, cr0, cr3, cr0, {0}
     d10:	0900000c 	stmdbeq	r0, {r2, r3}
     d14:	0bac0843 	bleq	feb02e28 <__bss_end+0xfeaf9e5c>
     d18:	033b0000 	teqeq	fp, #0
     d1c:	5d020000 	stcpl	0, cr0, [r2, #-0]
     d20:	7200000a 	andvc	r0, r0, #10
     d24:	1000000a 	andne	r0, r0, sl
     d28:	00000d2d 	andeq	r0, r0, sp, lsr #26
     d2c:	00004d11 	andeq	r4, r0, r1, lsl sp
     d30:	0d331100 	ldfeqs	f1, [r3, #-0]
     d34:	33110000 	tstcc	r1, #0
     d38:	0000000d 	andeq	r0, r0, sp
     d3c:	000eb213 	andeq	fp, lr, r3, lsl r2
     d40:	08450900 	stmdaeq	r5, {r8, fp}^
     d44:	0000110a 	andeq	r1, r0, sl, lsl #2
     d48:	0000033b 	andeq	r0, r0, fp, lsr r3
     d4c:	000a8b02 	andeq	r8, sl, r2, lsl #22
     d50:	000aa000 	andeq	sl, sl, r0
     d54:	0d2d1000 	stceq	0, cr1, [sp, #-0]
     d58:	4d110000 	ldcmi	0, cr0, [r1, #-0]
     d5c:	11000000 	mrsne	r0, (UNDEF: 0)
     d60:	00000d33 	andeq	r0, r0, r3, lsr sp
     d64:	000d3311 	andeq	r3, sp, r1, lsl r3
     d68:	53130000 	tstpl	r3, #0
     d6c:	09000010 	stmdbeq	r0, {r4}
     d70:	0ec50847 	cdpeq	8, 12, cr0, cr5, cr7, {2}
     d74:	033b0000 	teqeq	fp, #0
     d78:	b9020000 	stmdblt	r2, {}	; <UNPREDICTABLE>
     d7c:	ce00000a 	cdpgt	0, 0, cr0, cr0, cr10, {0}
     d80:	1000000a 	andne	r0, r0, sl
     d84:	00000d2d 	andeq	r0, r0, sp, lsr #26
     d88:	00004d11 	andeq	r4, r0, r1, lsl sp
     d8c:	0d331100 	ldfeqs	f1, [r3, #-0]
     d90:	33110000 	tstcc	r1, #0
     d94:	0000000d 	andeq	r0, r0, sp
     d98:	00052d13 	andeq	r2, r5, r3, lsl sp
     d9c:	08490900 	stmdaeq	r9, {r8, fp}^
     da0:	00001018 	andeq	r1, r0, r8, lsl r0
     da4:	0000033b 	andeq	r0, r0, fp, lsr r3
     da8:	000ae702 	andeq	lr, sl, r2, lsl #14
     dac:	000afc00 	andeq	pc, sl, r0, lsl #24
     db0:	0d2d1000 	stceq	0, cr1, [sp, #-0]
     db4:	4d110000 	ldcmi	0, cr0, [r1, #-0]
     db8:	11000000 	mrsne	r0, (UNDEF: 0)
     dbc:	00000d33 	andeq	r0, r0, r3, lsr sp
     dc0:	000d3311 	andeq	r3, sp, r1, lsl r3
     dc4:	f3130000 	vhadd.u16	d0, d3, d0
     dc8:	0900000b 	stmdbeq	r0, {r0, r1, r3}
     dcc:	08de084b 	ldmeq	lr, {r0, r1, r3, r6, fp}^
     dd0:	033b0000 	teqeq	fp, #0
     dd4:	15020000 	strne	r0, [r2, #-0]
     dd8:	2f00000b 	svccs	0x0000000b
     ddc:	1000000b 	andne	r0, r0, fp
     de0:	00000d2d 	andeq	r0, r0, sp, lsr #26
     de4:	00004d11 	andeq	r4, r0, r1, lsl sp
     de8:	095b1100 	ldmdbeq	fp, {r8, ip}^
     dec:	33110000 	tstcc	r1, #0
     df0:	1100000d 	tstne	r0, sp
     df4:	00000d33 	andeq	r0, r0, r3, lsr sp
     df8:	0a311300 	beq	c45a00 <__bss_end+0xc3ca34>
     dfc:	4f090000 	svcmi	0x00090000
     e00:	000d4b0c 	andeq	r4, sp, ip, lsl #22
     e04:	00004d00 	andeq	r4, r0, r0, lsl #26
     e08:	0b480200 	bleq	1201610 <__bss_end+0x11f8644>
     e0c:	0b4e0000 	bleq	1380e14 <__bss_end+0x1377e48>
     e10:	2d100000 	ldccs	0, cr0, [r0, #-0]
     e14:	0000000d 	andeq	r0, r0, sp
     e18:	00113914 	andseq	r3, r1, r4, lsl r9
     e1c:	08510900 	ldmdaeq	r1, {r8, fp}^
     e20:	000006d9 	ldrdeq	r0, [r0], -r9
     e24:	000b6302 	andeq	r6, fp, r2, lsl #6
     e28:	000b6e00 	andeq	r6, fp, r0, lsl #28
     e2c:	0d391000 	ldceq	0, cr1, [r9, #-0]
     e30:	4d110000 	ldcmi	0, cr0, [r1, #-0]
     e34:	00000000 	andeq	r0, r0, r0
     e38:	0011ed13 	andseq	lr, r1, r3, lsl sp
     e3c:	03540900 	cmpeq	r4, #0, 18
     e40:	00000dcf 	andeq	r0, r0, pc, asr #27
     e44:	00000d39 	andeq	r0, r0, r9, lsr sp
     e48:	000b8701 	andeq	r8, fp, r1, lsl #14
     e4c:	000b9200 	andeq	r9, fp, r0, lsl #4
     e50:	0d391000 	ldceq	0, cr1, [r9, #-0]
     e54:	5e110000 	cdppl	0, 1, cr0, cr1, cr0, {0}
     e58:	00000000 	andeq	r0, r0, r0
     e5c:	0004ed14 	andeq	lr, r4, r4, lsl sp
     e60:	08570900 	ldmdaeq	r7, {r8, fp}^
     e64:	00000c76 	andeq	r0, r0, r6, ror ip
     e68:	000ba701 	andeq	sl, fp, r1, lsl #14
     e6c:	000bb700 	andeq	fp, fp, r0, lsl #14
     e70:	0d391000 	ldceq	0, cr1, [r9, #-0]
     e74:	4d110000 	ldcmi	0, cr0, [r1, #-0]
     e78:	11000000 	mrsne	r0, (UNDEF: 0)
     e7c:	00000912 	andeq	r0, r0, r2, lsl r9
     e80:	0e571300 	cdpeq	3, 5, cr1, cr7, cr0, {0}
     e84:	59090000 	stmdbpl	r9, {}	; <UNPREDICTABLE>
     e88:	00119212 	andseq	r9, r1, r2, lsl r2
     e8c:	00091200 	andeq	r1, r9, r0, lsl #4
     e90:	0bd00100 	bleq	ff401298 <__bss_end+0xff3f82cc>
     e94:	0bdb0000 	bleq	ff6c0e9c <__bss_end+0xff6b7ed0>
     e98:	2d100000 	ldccs	0, cr0, [r0, #-0]
     e9c:	1100000d 	tstne	r0, sp
     ea0:	0000004d 	andeq	r0, r0, sp, asr #32
     ea4:	0c591400 	cfldrdeq	mvd1, [r9], {-0}
     ea8:	5c090000 	stcpl	0, cr0, [r9], {-0}
     eac:	000ab108 	andeq	fp, sl, r8, lsl #2
     eb0:	0bf00100 	bleq	ffc012b8 <__bss_end+0xffbf82ec>
     eb4:	0c000000 	stceq	0, cr0, [r0], {-0}
     eb8:	39100000 	ldmdbcc	r0, {}	; <UNPREDICTABLE>
     ebc:	1100000d 	tstne	r0, sp
     ec0:	0000004d 	andeq	r0, r0, sp, asr #32
     ec4:	00033b11 	andeq	r3, r3, r1, lsl fp
     ec8:	91130000 	tstls	r3, r0
     ecc:	0900000f 	stmdbeq	r0, {r0, r1, r2, r3}
     ed0:	04b1085f 	ldrteq	r0, [r1], #2143	; 0x85f
     ed4:	033b0000 	teqeq	fp, #0
     ed8:	19010000 	stmdbne	r1, {}	; <UNPREDICTABLE>
     edc:	2400000c 	strcs	r0, [r0], #-12
     ee0:	1000000c 	andne	r0, r0, ip
     ee4:	00000d39 	andeq	r0, r0, r9, lsr sp
     ee8:	00004d11 	andeq	r4, r0, r1, lsl sp
     eec:	4b130000 	blmi	4c0ef4 <__bss_end+0x4b7f28>
     ef0:	0900000e 	stmdbeq	r0, {r1, r2, r3}
     ef4:	03f30862 	mvnseq	r0, #6422528	; 0x620000
     ef8:	033b0000 	teqeq	fp, #0
     efc:	3d010000 	stccc	0, cr0, [r1, #-0]
     f00:	5200000c 	andpl	r0, r0, #12
     f04:	1000000c 	andne	r0, r0, ip
     f08:	00000d39 	andeq	r0, r0, r9, lsr sp
     f0c:	00004d11 	andeq	r4, r0, r1, lsl sp
     f10:	033b1100 	teqeq	fp, #0, 2
     f14:	3b110000 	blcc	440f1c <__bss_end+0x437f50>
     f18:	00000003 	andeq	r0, r0, r3
     f1c:	00118913 	andseq	r8, r1, r3, lsl r9
     f20:	08640900 	stmdaeq	r4!, {r8, fp}^
     f24:	0000084e 	andeq	r0, r0, lr, asr #16
     f28:	0000033b 	andeq	r0, r0, fp, lsr r3
     f2c:	000c6b01 	andeq	r6, ip, r1, lsl #22
     f30:	000c8000 	andeq	r8, ip, r0
     f34:	0d391000 	ldceq	0, cr1, [r9, #-0]
     f38:	4d110000 	ldcmi	0, cr0, [r1, #-0]
     f3c:	11000000 	mrsne	r0, (UNDEF: 0)
     f40:	0000033b 	andeq	r0, r0, fp, lsr r3
     f44:	00033b11 	andeq	r3, r3, r1, lsl fp
     f48:	39140000 	ldmdbcc	r4, {}	; <UNPREDICTABLE>
     f4c:	0900000b 	stmdbeq	r0, {r0, r1, r3}
     f50:	03b30867 			; <UNDEFINED> instruction: 0x03b30867
     f54:	95010000 	strls	r0, [r1, #-0]
     f58:	a500000c 	strge	r0, [r0, #-12]
     f5c:	1000000c 	andne	r0, r0, ip
     f60:	00000d39 	andeq	r0, r0, r9, lsr sp
     f64:	00004d11 	andeq	r4, r0, r1, lsl sp
     f68:	095b1100 	ldmdbeq	fp, {r8, ip}^
     f6c:	14000000 	strne	r0, [r0], #-0
     f70:	00000d11 	andeq	r0, r0, r1, lsl sp
     f74:	80086909 	andhi	r6, r8, r9, lsl #18
     f78:	01000007 	tsteq	r0, r7
     f7c:	00000cba 			; <UNDEFINED> instruction: 0x00000cba
     f80:	00000cca 	andeq	r0, r0, sl, asr #25
     f84:	000d3910 	andeq	r3, sp, r0, lsl r9
     f88:	004d1100 	subeq	r1, sp, r0, lsl #2
     f8c:	5b110000 	blpl	440f94 <__bss_end+0x437fc8>
     f90:	00000009 	andeq	r0, r0, r9
     f94:	00125d14 	andseq	r5, r2, r4, lsl sp
     f98:	086c0900 	stmdaeq	ip!, {r8, fp}^
     f9c:	000009f1 	strdeq	r0, [r0], -r1
     fa0:	000cdf01 	andeq	sp, ip, r1, lsl #30
     fa4:	000ce500 	andeq	lr, ip, r0, lsl #10
     fa8:	0d391000 	ldceq	0, cr1, [r9, #-0]
     fac:	27000000 	strcs	r0, [r0, -r0]
     fb0:	00000b9d 	muleq	r0, sp, fp
     fb4:	16086f09 	strne	r6, [r8], -r9, lsl #30
     fb8:	0100000e 	tsteq	r0, lr
     fbc:	00000cf6 	strdeq	r0, [r0], -r6
     fc0:	000d3910 	andeq	r3, sp, r0, lsl r9
     fc4:	036a1100 	cmneq	sl, #0, 2
     fc8:	4d110000 	ldcmi	0, cr0, [r1, #-0]
     fcc:	00000000 	andeq	r0, r0, r0
     fd0:	09860300 	stmibeq	r6, {r8, r9}
     fd4:	04180000 	ldreq	r0, [r8], #-0
     fd8:	00000993 	muleq	r0, r3, r9
     fdc:	006a0418 	rsbeq	r0, sl, r8, lsl r4
     fe0:	12030000 	andne	r0, r3, #0
     fe4:	1600000d 	strne	r0, [r0], -sp
     fe8:	0000004d 	andeq	r0, r0, sp, asr #32
     fec:	00000d2d 	andeq	r0, r0, sp, lsr #26
     ff0:	00005e17 	andeq	r5, r0, r7, lsl lr
     ff4:	18000100 	stmdane	r0, {r8}
     ff8:	000d0704 	andeq	r0, sp, r4, lsl #14
     ffc:	4d042100 	stfmis	f2, [r4, #-0]
    1000:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
    1004:	00098604 	andeq	r8, r9, r4, lsl #12
    1008:	0b4d1a00 	bleq	1347810 <__bss_end+0x133e844>
    100c:	73090000 	movwvc	r0, #36864	; 0x9000
    1010:	00098616 	andeq	r8, r9, r6, lsl r6
    1014:	12122800 	andsne	r2, r2, #0, 16
    1018:	10010000 	andne	r0, r1, r0
    101c:	00003805 	andeq	r3, r0, r5, lsl #16
    1020:	00823800 	addeq	r3, r2, r0, lsl #16
    1024:	00019400 	andeq	r9, r1, r0, lsl #8
    1028:	f79c0100 			; <UNDEFINED> instruction: 0xf79c0100
    102c:	2900000d 	stmdbcs	r0, {r0, r2, r3}
    1030:	000011c8 	andeq	r1, r0, r8, asr #3
    1034:	380e1001 	stmdacc	lr, {r0, ip}
    1038:	02000000 	andeq	r0, r0, #0
    103c:	b8295c91 	stmdalt	r9!, {r0, r4, r7, sl, fp, ip, lr}
    1040:	01000010 	tsteq	r0, r0, lsl r0
    1044:	0df71b10 			; <UNDEFINED> instruction: 0x0df71b10
    1048:	91020000 	mrsls	r0, (UNDEF: 2)
    104c:	0a662a58 	beq	198b9b4 <__bss_end+0x19829e8>
    1050:	12010000 	andne	r0, r1, #0
    1054:	00004d0b 	andeq	r4, r0, fp, lsl #26
    1058:	70910200 	addsvc	r0, r1, r0, lsl #4
    105c:	0011e02a 	andseq	lr, r1, sl, lsr #32
    1060:	0b130100 	bleq	4c1468 <__bss_end+0x4b849c>
    1064:	0000004d 	andeq	r0, r0, sp, asr #32
    1068:	2a6c9102 	bcs	1b25478 <__bss_end+0x1b1c4ac>
    106c:	00000999 	muleq	r0, r9, r9
    1070:	4d0b1401 	cfstrsmi	mvf1, [fp, #-4]
    1074:	02000000 	andeq	r0, r0, #0
    1078:	ee2a6891 	mcr	8, 1, r6, cr10, cr1, {4}
    107c:	0100000a 	tsteq	r0, sl
    1080:	005e0f16 	subseq	r0, lr, r6, lsl pc
    1084:	91020000 	mrsls	r0, (UNDEF: 2)
    1088:	04992a74 	ldreq	r2, [r9], #2676	; 0xa74
    108c:	17010000 	strne	r0, [r1, -r0]
    1090:	00033b07 	andeq	r3, r3, r7, lsl #22
    1094:	67910200 	ldrvs	r0, [r1, r0, lsl #4]
    1098:	0006532a 	andeq	r5, r6, sl, lsr #6
    109c:	07180100 	ldreq	r0, [r8, -r0, lsl #2]
    10a0:	0000033b 	andeq	r0, r0, fp, lsr r3
    10a4:	2b669102 	blcs	19a54b4 <__bss_end+0x199c4e8>
    10a8:	000082b4 			; <UNDEFINED> instruction: 0x000082b4
    10ac:	00000104 	andeq	r0, r0, r4, lsl #2
    10b0:	706d742c 	rsbvc	r7, sp, ip, lsr #8
    10b4:	081e0100 	ldmdaeq	lr, {r8}
    10b8:	00000025 	andeq	r0, r0, r5, lsr #32
    10bc:	00659102 	rsbeq	r9, r5, r2, lsl #2
    10c0:	fd041800 	stc2	8, cr1, [r4, #-0]
    10c4:	1800000d 	stmdane	r0, {r0, r2, r3}
    10c8:	00002504 	andeq	r2, r0, r4, lsl #10
    10cc:	0cd70000 	ldcleq	0, cr0, [r7], {0}
    10d0:	00040000 	andeq	r0, r4, r0
    10d4:	00000466 	andeq	r0, r0, r6, ror #8
    10d8:	15b40104 	ldrne	r0, [r4, #260]!	; 0x104
    10dc:	d9040000 	stmdble	r4, {}	; <UNPREDICTABLE>
    10e0:	aa000012 	bge	1130 <shift+0x1130>
    10e4:	cc000013 	stcgt	0, cr0, [r0], {19}
    10e8:	5c000083 	stcpl	0, cr0, [r0], {131}	; 0x83
    10ec:	45000004 	strmi	r0, [r0, #-4]
    10f0:	02000004 	andeq	r0, r0, #4
    10f4:	0d460801 	stcleq	8, cr0, [r6, #-4]
    10f8:	25030000 	strcs	r0, [r3, #-0]
    10fc:	02000000 	andeq	r0, r0, #0
    1100:	0dba0502 	cfldr32eq	mvfx0, [sl, #8]!
    1104:	04040000 	streq	r0, [r4], #-0
    1108:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    110c:	08010200 	stmdaeq	r1, {r9}
    1110:	00000d3d 	andeq	r0, r0, sp, lsr sp
    1114:	cc070202 	sfmgt	f0, 4, [r7], {2}
    1118:	05000009 	streq	r0, [r0, #-9]
    111c:	00000e42 	andeq	r0, r0, r2, asr #28
    1120:	5e070907 	vmlapl.f16	s0, s14, s14	; <UNPREDICTABLE>
    1124:	03000000 	movweq	r0, #0
    1128:	0000004d 	andeq	r0, r0, sp, asr #32
    112c:	bb070402 	bllt	1c213c <__bss_end+0x1b9170>
    1130:	0600001c 			; <UNDEFINED> instruction: 0x0600001c
    1134:	00000750 	andeq	r0, r0, r0, asr r7
    1138:	08060208 	stmdaeq	r6, {r3, r9}
    113c:	0000008b 	andeq	r0, r0, fp, lsl #1
    1140:	00307207 	eorseq	r7, r0, r7, lsl #4
    1144:	4d0e0802 	stcmi	8, cr0, [lr, #-8]
    1148:	00000000 	andeq	r0, r0, r0
    114c:	00317207 	eorseq	r7, r1, r7, lsl #4
    1150:	4d0e0902 	vstrmi.16	s0, [lr, #-4]	; <UNPREDICTABLE>
    1154:	04000000 	streq	r0, [r0], #-0
    1158:	14e20800 	strbtne	r0, [r2], #2048	; 0x800
    115c:	04050000 	streq	r0, [r5], #-0
    1160:	00000038 	andeq	r0, r0, r8, lsr r0
    1164:	a90c0d02 	stmdbge	ip, {r1, r8, sl, fp}
    1168:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    116c:	00004b4f 	andeq	r4, r0, pc, asr #22
    1170:	0013100a 	andseq	r1, r3, sl
    1174:	08000100 	stmdaeq	r0, {r8}
    1178:	0000056f 	andeq	r0, r0, pc, ror #10
    117c:	00380405 	eorseq	r0, r8, r5, lsl #8
    1180:	1e020000 	cdpne	0, 0, cr0, cr2, cr0, {0}
    1184:	0000e00c 	andeq	lr, r0, ip
    1188:	08050a00 	stmdaeq	r5, {r9, fp}
    118c:	0a000000 	beq	1194 <shift+0x1194>
    1190:	0000124d 	andeq	r1, r0, sp, asr #4
    1194:	12170a01 	andsne	r0, r7, #4096	; 0x1000
    1198:	0a020000 	beq	811a0 <__bss_end+0x781d4>
    119c:	00000a56 	andeq	r0, r0, r6, asr sl
    11a0:	0cae0a03 	vstmiaeq	lr!, {s0-s2}
    11a4:	0a040000 	beq	1011ac <__bss_end+0xf81e0>
    11a8:	000007ce 	andeq	r0, r0, lr, asr #15
    11ac:	f2080005 	vhadd.s8	d0, d8, d5
    11b0:	05000010 	streq	r0, [r0, #-16]
    11b4:	00003804 	andeq	r3, r0, r4, lsl #16
    11b8:	0c3f0200 	lfmeq	f0, 4, [pc], #-0	; 11c0 <shift+0x11c0>
    11bc:	0000011d 	andeq	r0, r0, sp, lsl r1
    11c0:	00041d0a 	andeq	r1, r4, sl, lsl #26
    11c4:	ab0a0000 	blge	2811cc <__bss_end+0x278200>
    11c8:	01000005 	tsteq	r0, r5
    11cc:	000c690a 	andeq	r6, ip, sl, lsl #18
    11d0:	bb0a0200 	bllt	2819d8 <__bss_end+0x278a0c>
    11d4:	03000011 	movweq	r0, #17
    11d8:	0012570a 	andseq	r5, r2, sl, lsl #14
    11dc:	830a0400 	movwhi	r0, #41984	; 0xa400
    11e0:	0500000b 	streq	r0, [r0, #-11]
    11e4:	0009ec0a 	andeq	lr, r9, sl, lsl #24
    11e8:	08000600 	stmdaeq	r0, {r9, sl}
    11ec:	00001551 	andeq	r1, r0, r1, asr r5
    11f0:	00380405 	eorseq	r0, r8, r5, lsl #8
    11f4:	66020000 	strvs	r0, [r2], -r0
    11f8:	0001480c 	andeq	r4, r1, ip, lsl #16
    11fc:	14870a00 	strne	r0, [r7], #2560	; 0xa00
    1200:	0a000000 	beq	1208 <shift+0x1208>
    1204:	0000136d 	andeq	r1, r0, sp, ror #6
    1208:	14ab0a01 	strtne	r0, [fp], #2561	; 0xa01
    120c:	0a020000 	beq	81214 <__bss_end+0x78248>
    1210:	00001392 	muleq	r0, r2, r3
    1214:	db0b0003 	blle	2c1228 <__bss_end+0x2b825c>
    1218:	0300000b 	movweq	r0, #11
    121c:	00591405 	subseq	r1, r9, r5, lsl #8
    1220:	03050000 	movweq	r0, #20480	; 0x5000
    1224:	00008f70 	andeq	r8, r0, r0, ror pc
    1228:	000c210b 	andeq	r2, ip, fp, lsl #2
    122c:	14060300 	strne	r0, [r6], #-768	; 0xfffffd00
    1230:	00000059 	andeq	r0, r0, r9, asr r0
    1234:	8f740305 	svchi	0x00740305
    1238:	6d0b0000 	stcvs	0, cr0, [fp, #-0]
    123c:	0400000b 	streq	r0, [r0], #-11
    1240:	00591a07 	subseq	r1, r9, r7, lsl #20
    1244:	03050000 	movweq	r0, #20480	; 0x5000
    1248:	00008f78 	andeq	r8, r0, r8, ror pc
    124c:	0005da0b 	andeq	sp, r5, fp, lsl #20
    1250:	1a090400 	bne	242258 <__bss_end+0x23928c>
    1254:	00000059 	andeq	r0, r0, r9, asr r0
    1258:	8f7c0305 	svchi	0x007c0305
    125c:	2f0b0000 	svccs	0x000b0000
    1260:	0400000d 	streq	r0, [r0], #-13
    1264:	00591a0b 	subseq	r1, r9, fp, lsl #20
    1268:	03050000 	movweq	r0, #20480	; 0x5000
    126c:	00008f80 	andeq	r8, r0, r0, lsl #31
    1270:	0009a60b 	andeq	sl, r9, fp, lsl #12
    1274:	1a0d0400 	bne	34227c <__bss_end+0x3392b0>
    1278:	00000059 	andeq	r0, r0, r9, asr r0
    127c:	8f840305 	svchi	0x00840305
    1280:	760b0000 	strvc	r0, [fp], -r0
    1284:	04000007 	streq	r0, [r0], #-7
    1288:	00591a0f 	subseq	r1, r9, pc, lsl #20
    128c:	03050000 	movweq	r0, #20480	; 0x5000
    1290:	00008f88 	andeq	r8, r0, r8, lsl #31
    1294:	000ea208 	andeq	sl, lr, r8, lsl #4
    1298:	38040500 	stmdacc	r4, {r8, sl}
    129c:	04000000 	streq	r0, [r0], #-0
    12a0:	01eb0c1b 	mvneq	r0, fp, lsl ip
    12a4:	0e0a0000 	cdpeq	0, 0, cr0, cr10, cr0, {0}
    12a8:	0000000f 	andeq	r0, r0, pc
    12ac:	0012070a 	andseq	r0, r2, sl, lsl #14
    12b0:	640a0100 	strvs	r0, [sl], #-256	; 0xffffff00
    12b4:	0200000c 	andeq	r0, r0, #12
    12b8:	0d0b0c00 	stceq	12, cr0, [fp, #-0]
    12bc:	9f0d0000 	svcls	0x000d0000
    12c0:	9000000d 	andls	r0, r0, sp
    12c4:	5e076304 	cdppl	3, 0, cr6, cr7, cr4, {0}
    12c8:	06000003 	streq	r0, [r0], -r3
    12cc:	0000115d 	andeq	r1, r0, sp, asr r1
    12d0:	10670424 	rsbne	r0, r7, r4, lsr #8
    12d4:	00000278 	andeq	r0, r0, r8, ror r2
    12d8:	00202b0e 	eoreq	r2, r0, lr, lsl #22
    12dc:	12690400 	rsbne	r0, r9, #0, 8
    12e0:	0000035e 	andeq	r0, r0, lr, asr r3
    12e4:	05630e00 	strbeq	r0, [r3, #-3584]!	; 0xfffff200
    12e8:	6b040000 	blvs	1012f0 <__bss_end+0xf8324>
    12ec:	00036e12 	andeq	r6, r3, r2, lsl lr
    12f0:	030e1000 	movweq	r1, #57344	; 0xe000
    12f4:	0400000f 	streq	r0, [r0], #-15
    12f8:	004d166d 	subeq	r1, sp, sp, ror #12
    12fc:	0e140000 	cdpeq	0, 1, cr0, cr4, cr0, {0}
    1300:	000005d3 	ldrdeq	r0, [r0], -r3
    1304:	751c7004 	ldrvc	r7, [ip, #-4]
    1308:	18000003 	stmdane	r0, {r0, r1}
    130c:	000d260e 	andeq	r2, sp, lr, lsl #12
    1310:	1c720400 	cfldrdne	mvd0, [r2], #-0
    1314:	00000375 	andeq	r0, r0, r5, ror r3
    1318:	05400e1c 	strbeq	r0, [r0, #-3612]	; 0xfffff1e4
    131c:	75040000 	strvc	r0, [r4, #-0]
    1320:	0003751c 	andeq	r7, r3, ip, lsl r5
    1324:	170f2000 	strne	r2, [pc, -r0]
    1328:	04000008 	streq	r0, [r0], #-8
    132c:	04691c77 	strbteq	r1, [r9], #-3191	; 0xfffff389
    1330:	03750000 	cmneq	r5, #0
    1334:	026c0000 	rsbeq	r0, ip, #0
    1338:	75100000 	ldrvc	r0, [r0, #-0]
    133c:	11000003 	tstne	r0, r3
    1340:	0000037b 	andeq	r0, r0, fp, ror r3
    1344:	c4060000 	strgt	r0, [r6], #-0
    1348:	1800000d 	stmdane	r0, {r0, r2, r3}
    134c:	ad107b04 	vldrge	d7, [r0, #-16]
    1350:	0e000002 	cdpeq	0, 0, cr0, cr0, cr2, {0}
    1354:	0000202b 	andeq	r2, r0, fp, lsr #32
    1358:	5e127e04 	cdppl	14, 1, cr7, cr2, cr4, {0}
    135c:	00000003 	andeq	r0, r0, r3
    1360:	0005580e 	andeq	r5, r5, lr, lsl #16
    1364:	19800400 	stmibne	r0, {sl}
    1368:	0000037b 	andeq	r0, r0, fp, ror r3
    136c:	11c10e10 	bicne	r0, r1, r0, lsl lr
    1370:	82040000 	andhi	r0, r4, #0
    1374:	00038621 	andeq	r8, r3, r1, lsr #12
    1378:	03001400 	movweq	r1, #1024	; 0x400
    137c:	00000278 	andeq	r0, r0, r8, ror r2
    1380:	000b1712 	andeq	r1, fp, r2, lsl r7
    1384:	21860400 	orrcs	r0, r6, r0, lsl #8
    1388:	0000038c 	andeq	r0, r0, ip, lsl #7
    138c:	0008cc12 	andeq	ip, r8, r2, lsl ip
    1390:	1f880400 	svcne	0x00880400
    1394:	00000059 	andeq	r0, r0, r9, asr r0
    1398:	000df60e 	andeq	pc, sp, lr, lsl #12
    139c:	178b0400 	strne	r0, [fp, r0, lsl #8]
    13a0:	000001fd 	strdeq	r0, [r0], -sp
    13a4:	0a5c0e00 	beq	1704bac <__bss_end+0x16fbbe0>
    13a8:	8e040000 	cdphi	0, 0, cr0, cr4, cr0, {0}
    13ac:	0001fd17 	andeq	pc, r1, r7, lsl sp	; <UNPREDICTABLE>
    13b0:	370e2400 	strcc	r2, [lr, -r0, lsl #8]
    13b4:	04000009 	streq	r0, [r0], #-9
    13b8:	01fd178f 	mvnseq	r1, pc, lsl #15
    13bc:	0e480000 	cdpeq	0, 4, cr0, cr8, cr0, {0}
    13c0:	00001237 	andeq	r1, r0, r7, lsr r2
    13c4:	fd179004 	ldc2	0, cr9, [r7, #-16]
    13c8:	6c000001 	stcvs	0, cr0, [r0], {1}
    13cc:	000d9f13 	andeq	r9, sp, r3, lsl pc
    13d0:	09930400 	ldmibeq	r3, {sl}
    13d4:	00000681 	andeq	r0, r0, r1, lsl #13
    13d8:	00000397 	muleq	r0, r7, r3
    13dc:	00031701 	andeq	r1, r3, r1, lsl #14
    13e0:	00031d00 	andeq	r1, r3, r0, lsl #26
    13e4:	03971000 	orrseq	r1, r7, #0
    13e8:	14000000 	strne	r0, [r0], #-0
    13ec:	00000b0c 	andeq	r0, r0, ip, lsl #22
    13f0:	120e9604 	andne	r9, lr, #4, 12	; 0x400000
    13f4:	0100000a 	tsteq	r0, sl
    13f8:	00000332 	andeq	r0, r0, r2, lsr r3
    13fc:	00000338 	andeq	r0, r0, r8, lsr r3
    1400:	00039710 	andeq	r9, r3, r0, lsl r7
    1404:	1d150000 	ldcne	0, cr0, [r5, #-0]
    1408:	04000004 	streq	r0, [r0], #-4
    140c:	0e871099 	mcreq	0, 4, r1, cr7, cr9, {4}
    1410:	039d0000 	orrseq	r0, sp, #0
    1414:	4d010000 	stcmi	0, cr0, [r1, #-0]
    1418:	10000003 	andne	r0, r0, r3
    141c:	00000397 	muleq	r0, r7, r3
    1420:	00037b11 	andeq	r7, r3, r1, lsl fp
    1424:	01c61100 	biceq	r1, r6, r0, lsl #2
    1428:	00000000 	andeq	r0, r0, r0
    142c:	00002516 	andeq	r2, r0, r6, lsl r5
    1430:	00036e00 	andeq	r6, r3, r0, lsl #28
    1434:	005e1700 	subseq	r1, lr, r0, lsl #14
    1438:	000f0000 	andeq	r0, pc, r0
    143c:	73020102 	movwvc	r0, #8450	; 0x2102
    1440:	1800000a 	stmdane	r0, {r1, r3}
    1444:	0001fd04 	andeq	pc, r1, r4, lsl #26
    1448:	2c041800 	stccs	8, cr1, [r4], {-0}
    144c:	0c000000 	stceq	0, cr0, [r0], {-0}
    1450:	000011cd 	andeq	r1, r0, sp, asr #3
    1454:	03810418 	orreq	r0, r1, #24, 8	; 0x18000000
    1458:	ad160000 	ldcge	0, cr0, [r6, #-0]
    145c:	97000002 	strls	r0, [r0, -r2]
    1460:	19000003 	stmdbne	r0, {r0, r1}
    1464:	f0041800 			; <UNDEFINED> instruction: 0xf0041800
    1468:	18000001 	stmdane	r0, {r0}
    146c:	0001eb04 	andeq	lr, r1, r4, lsl #22
    1470:	0dfc1a00 			; <UNDEFINED> instruction: 0x0dfc1a00
    1474:	9c040000 	stcls	0, cr0, [r4], {-0}
    1478:	0001f014 	andeq	pc, r1, r4, lsl r0	; <UNPREDICTABLE>
    147c:	08780b00 	ldmdaeq	r8!, {r8, r9, fp}^
    1480:	04050000 	streq	r0, [r5], #-0
    1484:	00005914 	andeq	r5, r0, r4, lsl r9
    1488:	8c030500 	cfstr32hi	mvfx0, [r3], {-0}
    148c:	0b00008f 	bleq	16d0 <shift+0x16d0>
    1490:	000003a8 	andeq	r0, r0, r8, lsr #7
    1494:	59140705 	ldmdbpl	r4, {r0, r2, r8, r9, sl}
    1498:	05000000 	streq	r0, [r0, #-0]
    149c:	008f9003 	addeq	r9, pc, r3
    14a0:	065d0b00 	ldrbeq	r0, [sp], -r0, lsl #22
    14a4:	0a050000 	beq	1414ac <__bss_end+0x1384e0>
    14a8:	00005914 	andeq	r5, r0, r4, lsl r9
    14ac:	94030500 	strls	r0, [r3], #-1280	; 0xfffffb00
    14b0:	0800008f 	stmdaeq	r0, {r0, r1, r2, r3, r7}
    14b4:	00000adc 	ldrdeq	r0, [r0], -ip
    14b8:	00380405 	eorseq	r0, r8, r5, lsl #8
    14bc:	0d050000 	stceq	0, cr0, [r5, #-0]
    14c0:	00041c0c 	andeq	r1, r4, ip, lsl #24
    14c4:	654e0900 	strbvs	r0, [lr, #-2304]	; 0xfffff700
    14c8:	0a000077 	beq	16ac <shift+0x16ac>
    14cc:	00000ad3 	ldrdeq	r0, [r0], -r3
    14d0:	0e0e0a01 	vmlaeq.f32	s0, s28, s2
    14d4:	0a020000 	beq	814dc <__bss_end+0x78510>
    14d8:	00000a8e 	andeq	r0, r0, lr, lsl #21
    14dc:	0a480a03 	beq	1203cf0 <__bss_end+0x11fad24>
    14e0:	0a040000 	beq	1014e8 <__bss_end+0xf851c>
    14e4:	00000c6f 	andeq	r0, r0, pc, ror #24
    14e8:	c1060005 	tstgt	r6, r5
    14ec:	10000007 	andne	r0, r0, r7
    14f0:	5b081b05 	blpl	20810c <__bss_end+0x1ff140>
    14f4:	07000004 	streq	r0, [r0, -r4]
    14f8:	0500726c 	streq	r7, [r0, #-620]	; 0xfffffd94
    14fc:	045b131d 	ldrbeq	r1, [fp], #-797	; 0xfffffce3
    1500:	07000000 	streq	r0, [r0, -r0]
    1504:	05007073 	streq	r7, [r0, #-115]	; 0xffffff8d
    1508:	045b131e 	ldrbeq	r1, [fp], #-798	; 0xfffffce2
    150c:	07040000 	streq	r0, [r4, -r0]
    1510:	05006370 	streq	r6, [r0, #-880]	; 0xfffffc90
    1514:	045b131f 	ldrbeq	r1, [fp], #-799	; 0xfffffce1
    1518:	0e080000 	cdpeq	0, 0, cr0, cr8, cr0, {0}
    151c:	000007d7 	ldrdeq	r0, [r0], -r7
    1520:	5b132005 	blpl	4c953c <__bss_end+0x4c0570>
    1524:	0c000004 	stceq	0, cr0, [r0], {4}
    1528:	07040200 	streq	r0, [r4, -r0, lsl #4]
    152c:	00001cb6 			; <UNDEFINED> instruction: 0x00001cb6
    1530:	00045c06 	andeq	r5, r4, r6, lsl #24
    1534:	28057000 	stmdacs	r5, {ip, sp, lr}
    1538:	0004f208 	andeq	pc, r4, r8, lsl #4
    153c:	12410e00 	subne	r0, r1, #0, 28
    1540:	2a050000 	bcs	141548 <__bss_end+0x13857c>
    1544:	00041c12 	andeq	r1, r4, r2, lsl ip
    1548:	70070000 	andvc	r0, r7, r0
    154c:	05006469 	streq	r6, [r0, #-1129]	; 0xfffffb97
    1550:	005e122b 	subseq	r1, lr, fp, lsr #4
    1554:	0e100000 	cdpeq	0, 1, cr0, cr0, cr0, {0}
    1558:	00001a07 	andeq	r1, r0, r7, lsl #20
    155c:	e5112c05 	ldr	r2, [r1, #-3077]	; 0xfffff3fb
    1560:	14000003 	strne	r0, [r0], #-3
    1564:	000ae80e 	andeq	lr, sl, lr, lsl #16
    1568:	122d0500 	eorne	r0, sp, #0, 10
    156c:	0000005e 	andeq	r0, r0, lr, asr r0
    1570:	0af60e18 	beq	ffd84dd8 <__bss_end+0xffd7be0c>
    1574:	2e050000 	cdpcs	0, 0, cr0, cr5, cr0, {0}
    1578:	00005e12 	andeq	r5, r0, r2, lsl lr
    157c:	690e1c00 	stmdbvs	lr, {sl, fp, ip}
    1580:	05000007 	streq	r0, [r0, #-7]
    1584:	04f20c2f 	ldrbteq	r0, [r2], #3119	; 0xc2f
    1588:	0e200000 	cdpeq	0, 2, cr0, cr0, cr0, {0}
    158c:	00000b23 	andeq	r0, r0, r3, lsr #22
    1590:	38093005 	stmdacc	r9, {r0, r2, ip, sp}
    1594:	60000000 	andvs	r0, r0, r0
    1598:	000f180e 	andeq	r1, pc, lr, lsl #16
    159c:	0e310500 	cfabs32eq	mvfx0, mvfx1
    15a0:	0000004d 	andeq	r0, r0, sp, asr #32
    15a4:	082b0e64 	stmdaeq	fp!, {r2, r5, r6, r9, sl, fp}
    15a8:	33050000 	movwcc	r0, #20480	; 0x5000
    15ac:	00004d0e 	andeq	r4, r0, lr, lsl #26
    15b0:	220e6800 	andcs	r6, lr, #0, 16
    15b4:	05000008 	streq	r0, [r0, #-8]
    15b8:	004d0e34 	subeq	r0, sp, r4, lsr lr
    15bc:	006c0000 	rsbeq	r0, ip, r0
    15c0:	00039d16 	andeq	r9, r3, r6, lsl sp
    15c4:	00050200 	andeq	r0, r5, r0, lsl #4
    15c8:	005e1700 	subseq	r1, lr, r0, lsl #14
    15cc:	000f0000 	andeq	r0, pc, r0
    15d0:	00114e0b 	andseq	r4, r1, fp, lsl #28
    15d4:	140a0600 	strne	r0, [sl], #-1536	; 0xfffffa00
    15d8:	00000059 	andeq	r0, r0, r9, asr r0
    15dc:	8f980305 	svchi	0x00980305
    15e0:	96080000 	strls	r0, [r8], -r0
    15e4:	0500000a 	streq	r0, [r0, #-10]
    15e8:	00003804 	andeq	r3, r0, r4, lsl #16
    15ec:	0c0d0600 	stceq	6, cr0, [sp], {-0}
    15f0:	00000533 	andeq	r0, r0, r3, lsr r5
    15f4:	0005840a 	andeq	r8, r5, sl, lsl #8
    15f8:	9d0a0000 	stcls	0, cr0, [sl, #-0]
    15fc:	01000003 	tsteq	r0, r3
    1600:	05140300 	ldreq	r0, [r4, #-768]	; 0xfffffd00
    1604:	13080000 	movwne	r0, #32768	; 0x8000
    1608:	05000014 	streq	r0, [r0, #-20]	; 0xffffffec
    160c:	00003804 	andeq	r3, r0, r4, lsl #16
    1610:	0c140600 	ldceq	6, cr0, [r4], {-0}
    1614:	00000557 	andeq	r0, r0, r7, asr r5
    1618:	00126e0a 	andseq	r6, r2, sl, lsl #28
    161c:	9d0a0000 	stcls	0, cr0, [sl, #-0]
    1620:	01000014 	tsteq	r0, r4, lsl r0
    1624:	05380300 	ldreq	r0, [r8, #-768]!	; 0xfffffd00
    1628:	05060000 	streq	r0, [r6, #-0]
    162c:	0c000010 	stceq	0, cr0, [r0], {16}
    1630:	91081b06 	tstls	r8, r6, lsl #22
    1634:	0e000005 	cdpeq	0, 0, cr0, cr0, cr5, {0}
    1638:	0000042e 	andeq	r0, r0, lr, lsr #8
    163c:	91191d06 	tstls	r9, r6, lsl #26
    1640:	00000005 	andeq	r0, r0, r5
    1644:	0005400e 	andeq	r4, r5, lr
    1648:	191e0600 	ldmdbne	lr, {r9, sl}
    164c:	00000591 	muleq	r0, r1, r5
    1650:	0f8c0e04 	svceq	0x008c0e04
    1654:	1f060000 	svcne	0x00060000
    1658:	00059713 	andeq	r9, r5, r3, lsl r7
    165c:	18000800 	stmdane	r0, {fp}
    1660:	00055c04 	andeq	r5, r5, r4, lsl #24
    1664:	62041800 	andvs	r1, r4, #0, 16
    1668:	0d000004 	stceq	0, cr0, [r0, #-16]
    166c:	00000670 	andeq	r0, r0, r0, ror r6
    1670:	07220614 			; <UNDEFINED> instruction: 0x07220614
    1674:	0000081f 	andeq	r0, r0, pc, lsl r8
    1678:	000a840e 	andeq	r8, sl, lr, lsl #8
    167c:	12260600 	eorne	r0, r6, #0, 12
    1680:	0000004d 	andeq	r0, r0, sp, asr #32
    1684:	04da0e00 	ldrbeq	r0, [sl], #3584	; 0xe00
    1688:	29060000 	stmdbcs	r6, {}	; <UNPREDICTABLE>
    168c:	0005911d 	andeq	r9, r5, sp, lsl r1
    1690:	740e0400 	strvc	r0, [lr], #-1024	; 0xfffffc00
    1694:	0600000e 	streq	r0, [r0], -lr
    1698:	05911d2c 	ldreq	r1, [r1, #3372]	; 0xd2c
    169c:	1b080000 	blne	2016a4 <__bss_end+0x1f86d8>
    16a0:	000010e8 	andeq	r1, r0, r8, ror #1
    16a4:	e20e2f06 	and	r2, lr, #6, 30
    16a8:	e500000f 	str	r0, [r0, #-15]
    16ac:	f0000005 			; <UNDEFINED> instruction: 0xf0000005
    16b0:	10000005 	andne	r0, r0, r5
    16b4:	00000824 	andeq	r0, r0, r4, lsr #16
    16b8:	00059111 	andeq	r9, r5, r1, lsl r1
    16bc:	9b1c0000 	blls	7016c4 <__bss_end+0x6f86f8>
    16c0:	0600000f 	streq	r0, [r0], -pc
    16c4:	04330e31 	ldrteq	r0, [r3], #-3633	; 0xfffff1cf
    16c8:	036e0000 	cmneq	lr, #0
    16cc:	06080000 	streq	r0, [r8], -r0
    16d0:	06130000 	ldreq	r0, [r3], -r0
    16d4:	24100000 	ldrcs	r0, [r0], #-0
    16d8:	11000008 	tstne	r0, r8
    16dc:	00000597 	muleq	r0, r7, r5
    16e0:	10471300 	subne	r1, r7, r0, lsl #6
    16e4:	35060000 	strcc	r0, [r6, #-0]
    16e8:	000f671d 	andeq	r6, pc, sp, lsl r7	; <UNPREDICTABLE>
    16ec:	00059100 	andeq	r9, r5, r0, lsl #2
    16f0:	062c0200 	strteq	r0, [ip], -r0, lsl #4
    16f4:	06320000 	ldrteq	r0, [r2], -r0
    16f8:	24100000 	ldrcs	r0, [r0], #-0
    16fc:	00000008 	andeq	r0, r0, r8
    1700:	0009df13 	andeq	sp, r9, r3, lsl pc
    1704:	1d370600 	ldcne	6, cr0, [r7, #-0]
    1708:	00000d79 	andeq	r0, r0, r9, ror sp
    170c:	00000591 	muleq	r0, r1, r5
    1710:	00064b02 	andeq	r4, r6, r2, lsl #22
    1714:	00065100 	andeq	r5, r6, r0, lsl #2
    1718:	08241000 	stmdaeq	r4!, {ip}
    171c:	1d000000 	stcne	0, cr0, [r0, #-0]
    1720:	00000b53 	andeq	r0, r0, r3, asr fp
    1724:	3d313906 			; <UNDEFINED> instruction: 0x3d313906
    1728:	0c000008 	stceq	0, cr0, [r0], {8}
    172c:	06701302 	ldrbteq	r1, [r0], -r2, lsl #6
    1730:	3c060000 	stccc	0, cr0, [r6], {-0}
    1734:	00121d09 	andseq	r1, r2, r9, lsl #26
    1738:	00082400 	andeq	r2, r8, r0, lsl #8
    173c:	06780100 	ldrbteq	r0, [r8], -r0, lsl #2
    1740:	067e0000 	ldrbteq	r0, [lr], -r0
    1744:	24100000 	ldrcs	r0, [r0], #-0
    1748:	00000008 	andeq	r0, r0, r8
    174c:	0005be13 	andeq	fp, r5, r3, lsl lr
    1750:	123f0600 	eorsne	r0, pc, #0, 12
    1754:	000010bd 	strheq	r1, [r0], -sp
    1758:	0000004d 	andeq	r0, r0, sp, asr #32
    175c:	00069701 	andeq	r9, r6, r1, lsl #14
    1760:	0006ac00 	andeq	sl, r6, r0, lsl #24
    1764:	08241000 	stmdaeq	r4!, {ip}
    1768:	46110000 	ldrmi	r0, [r1], -r0
    176c:	11000008 	tstne	r0, r8
    1770:	0000005e 	andeq	r0, r0, lr, asr r0
    1774:	00036e11 	andeq	r6, r3, r1, lsl lr
    1778:	aa140000 	bge	501780 <__bss_end+0x4f87b4>
    177c:	0600000f 	streq	r0, [r0], -pc
    1780:	0cbd0e42 	ldceq	14, cr0, [sp], #264	; 0x108
    1784:	c1010000 	mrsgt	r0, (UNDEF: 1)
    1788:	c7000006 	strgt	r0, [r0, -r6]
    178c:	10000006 	andne	r0, r0, r6
    1790:	00000824 	andeq	r0, r0, r4, lsr #16
    1794:	09411300 	stmdbeq	r1, {r8, r9, ip}^
    1798:	45060000 	strmi	r0, [r6, #-0]
    179c:	0004ff17 	andeq	pc, r4, r7, lsl pc	; <UNPREDICTABLE>
    17a0:	00059700 	andeq	r9, r5, r0, lsl #14
    17a4:	06e00100 	strbteq	r0, [r0], r0, lsl #2
    17a8:	06e60000 	strbteq	r0, [r6], r0
    17ac:	4c100000 	ldcmi	0, cr0, [r0], {-0}
    17b0:	00000008 	andeq	r0, r0, r8
    17b4:	00054513 	andeq	r4, r5, r3, lsl r5
    17b8:	17480600 	strbne	r0, [r8, -r0, lsl #12]
    17bc:	00000f24 	andeq	r0, r0, r4, lsr #30
    17c0:	00000597 	muleq	r0, r7, r5
    17c4:	0006ff01 	andeq	pc, r6, r1, lsl #30
    17c8:	00070a00 	andeq	r0, r7, r0, lsl #20
    17cc:	084c1000 	stmdaeq	ip, {ip}^
    17d0:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    17d4:	00000000 	andeq	r0, r0, r0
    17d8:	00116b14 	andseq	r6, r1, r4, lsl fp
    17dc:	0e4b0600 	cdpeq	6, 4, cr0, cr11, cr0, {0}
    17e0:	00000fb3 			; <UNDEFINED> instruction: 0x00000fb3
    17e4:	00071f01 	andeq	r1, r7, r1, lsl #30
    17e8:	00072500 	andeq	r2, r7, r0, lsl #10
    17ec:	08241000 	stmdaeq	r4!, {ip}
    17f0:	13000000 	movwne	r0, #0
    17f4:	00000f9b 	muleq	r0, fp, pc	; <UNPREDICTABLE>
    17f8:	dd0e4d06 	stcle	13, cr4, [lr, #-24]	; 0xffffffe8
    17fc:	6e000007 	cdpvs	0, 0, cr0, cr0, cr7, {0}
    1800:	01000003 	tsteq	r0, r3
    1804:	0000073e 	andeq	r0, r0, lr, lsr r7
    1808:	00000749 	andeq	r0, r0, r9, asr #14
    180c:	00082410 	andeq	r2, r8, r0, lsl r4
    1810:	004d1100 	subeq	r1, sp, r0, lsl #2
    1814:	13000000 	movwne	r0, #0
    1818:	00000955 	andeq	r0, r0, r5, asr r9
    181c:	de125006 	cdple	0, 1, cr5, cr2, cr6, {0}
    1820:	4d00000c 	stcmi	0, cr0, [r0, #-48]	; 0xffffffd0
    1824:	01000000 	mrseq	r0, (UNDEF: 0)
    1828:	00000762 	andeq	r0, r0, r2, ror #14
    182c:	0000076d 	andeq	r0, r0, sp, ror #14
    1830:	00082410 	andeq	r2, r8, r0, lsl r4
    1834:	039d1100 	orrseq	r1, sp, #0, 2
    1838:	13000000 	movwne	r0, #0
    183c:	0000049e 	muleq	r0, lr, r4
    1840:	910e5306 	tstls	lr, r6, lsl #6
    1844:	6e000008 	cdpvs	0, 0, cr0, cr0, cr8, {0}
    1848:	01000003 	tsteq	r0, r3
    184c:	00000786 	andeq	r0, r0, r6, lsl #15
    1850:	00000791 	muleq	r0, r1, r7
    1854:	00082410 	andeq	r2, r8, r0, lsl r4
    1858:	004d1100 	subeq	r1, sp, r0, lsl #2
    185c:	14000000 	strne	r0, [r0], #-0
    1860:	000009b9 			; <UNDEFINED> instruction: 0x000009b9
    1864:	660e5606 	strvs	r5, [lr], -r6, lsl #12
    1868:	01000010 	tsteq	r0, r0, lsl r0
    186c:	000007a6 	andeq	r0, r0, r6, lsr #15
    1870:	000007c5 	andeq	r0, r0, r5, asr #15
    1874:	00082410 	andeq	r2, r8, r0, lsl r4
    1878:	00a91100 	adceq	r1, r9, r0, lsl #2
    187c:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    1880:	11000000 	mrsne	r0, (UNDEF: 0)
    1884:	0000004d 	andeq	r0, r0, sp, asr #32
    1888:	00004d11 	andeq	r4, r0, r1, lsl sp
    188c:	08521100 	ldmdaeq	r2, {r8, ip}^
    1890:	14000000 	strne	r0, [r0], #-0
    1894:	00000f51 	andeq	r0, r0, r1, asr pc
    1898:	040e5806 	streq	r5, [lr], #-2054	; 0xfffff7fa
    189c:	01000007 	tsteq	r0, r7
    18a0:	000007da 	ldrdeq	r0, [r0], -sl
    18a4:	000007f9 	strdeq	r0, [r0], -r9
    18a8:	00082410 	andeq	r2, r8, r0, lsl r4
    18ac:	00e01100 	rsceq	r1, r0, r0, lsl #2
    18b0:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    18b4:	11000000 	mrsne	r0, (UNDEF: 0)
    18b8:	0000004d 	andeq	r0, r0, sp, asr #32
    18bc:	00004d11 	andeq	r4, r0, r1, lsl sp
    18c0:	08521100 	ldmdaeq	r2, {r8, ip}^
    18c4:	15000000 	strne	r0, [r0, #-0]
    18c8:	00000635 	andeq	r0, r0, r5, lsr r6
    18cc:	960e5b06 	strls	r5, [lr], -r6, lsl #22
    18d0:	6e000006 	cdpvs	0, 0, cr0, cr0, cr6, {0}
    18d4:	01000003 	tsteq	r0, r3
    18d8:	0000080e 	andeq	r0, r0, lr, lsl #16
    18dc:	00082410 	andeq	r2, r8, r0, lsl r4
    18e0:	05141100 	ldreq	r1, [r4, #-256]	; 0xffffff00
    18e4:	58110000 	ldmdapl	r1, {}	; <UNPREDICTABLE>
    18e8:	00000008 	andeq	r0, r0, r8
    18ec:	059d0300 	ldreq	r0, [sp, #768]	; 0x300
    18f0:	04180000 	ldreq	r0, [r8], #-0
    18f4:	0000059d 	muleq	r0, sp, r5
    18f8:	0005911e 	andeq	r9, r5, lr, lsl r1
    18fc:	00083700 	andeq	r3, r8, r0, lsl #14
    1900:	00083d00 	andeq	r3, r8, r0, lsl #26
    1904:	08241000 	stmdaeq	r4!, {ip}
    1908:	1f000000 	svcne	0x00000000
    190c:	0000059d 	muleq	r0, sp, r5
    1910:	0000082a 	andeq	r0, r0, sl, lsr #16
    1914:	003f0418 	eorseq	r0, pc, r8, lsl r4	; <UNPREDICTABLE>
    1918:	04180000 	ldreq	r0, [r8], #-0
    191c:	0000081f 	andeq	r0, r0, pc, lsl r8
    1920:	00650420 	rsbeq	r0, r5, r0, lsr #8
    1924:	04210000 	strteq	r0, [r1], #-0
    1928:	000b611a 	andeq	r6, fp, sl, lsl r1
    192c:	195e0600 	ldmdbne	lr, {r9, sl}^
    1930:	0000059d 	muleq	r0, sp, r5
    1934:	00002c16 	andeq	r2, r0, r6, lsl ip
    1938:	00087600 	andeq	r7, r8, r0, lsl #12
    193c:	005e1700 	subseq	r1, lr, r0, lsl #14
    1940:	00090000 	andeq	r0, r9, r0
    1944:	00086603 	andeq	r6, r8, r3, lsl #12
    1948:	135c2200 	cmpne	ip, #0, 4
    194c:	a4010000 	strge	r0, [r1], #-0
    1950:	0008760c 	andeq	r7, r8, ip, lsl #12
    1954:	9c030500 	cfstr32ls	mvfx0, [r3], {-0}
    1958:	2300008f 	movwcs	r0, #143	; 0x8f
    195c:	00001287 	andeq	r1, r0, r7, lsl #5
    1960:	070aa601 	streq	sl, [sl, -r1, lsl #12]
    1964:	4d000014 	stcmi	0, cr0, [r0, #-80]	; 0xffffffb0
    1968:	78000000 	stmdavc	r0, {}	; <UNPREDICTABLE>
    196c:	b0000087 	andlt	r0, r0, r7, lsl #1
    1970:	01000000 	mrseq	r0, (UNDEF: 0)
    1974:	0008eb9c 	muleq	r8, ip, fp
    1978:	202b2400 	eorcs	r2, fp, r0, lsl #8
    197c:	a6010000 	strge	r0, [r1], -r0
    1980:	00037b1b 	andeq	r7, r3, fp, lsl fp
    1984:	ac910300 	ldcge	3, cr0, [r1], {0}
    1988:	1466247f 	strbtne	r2, [r6], #-1151	; 0xfffffb81
    198c:	a6010000 	strge	r0, [r1], -r0
    1990:	00004d2a 	andeq	r4, r0, sl, lsr #26
    1994:	a8910300 	ldmge	r1, {r8, r9}
    1998:	13ef227f 	mvnne	r2, #-268435449	; 0xf0000007
    199c:	a8010000 	stmdage	r1, {}	; <UNPREDICTABLE>
    19a0:	0008eb0a 	andeq	lr, r8, sl, lsl #22
    19a4:	b4910300 	ldrlt	r0, [r1], #768	; 0x300
    19a8:	1282227f 	addne	r2, r2, #-268435449	; 0xf0000007
    19ac:	ac010000 	stcge	0, cr0, [r1], {-0}
    19b0:	00003809 	andeq	r3, r0, r9, lsl #16
    19b4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    19b8:	00251600 	eoreq	r1, r5, r0, lsl #12
    19bc:	08fb0000 	ldmeq	fp!, {}^	; <UNPREDICTABLE>
    19c0:	5e170000 	cdppl	0, 1, cr0, cr7, cr0, {0}
    19c4:	3f000000 	svccc	0x00000000
    19c8:	144b2500 	strbne	r2, [fp], #-1280	; 0xfffffb00
    19cc:	98010000 	stmdals	r1, {}	; <UNPREDICTABLE>
    19d0:	0014c20a 	andseq	ip, r4, sl, lsl #4
    19d4:	00004d00 	andeq	r4, r0, r0, lsl #26
    19d8:	00873c00 	addeq	r3, r7, r0, lsl #24
    19dc:	00003c00 	andeq	r3, r0, r0, lsl #24
    19e0:	389c0100 	ldmcc	ip, {r8}
    19e4:	26000009 	strcs	r0, [r0], -r9
    19e8:	00716572 	rsbseq	r6, r1, r2, ror r5
    19ec:	57209a01 	strpl	r9, [r0, -r1, lsl #20]!
    19f0:	02000005 	andeq	r0, r0, #5
    19f4:	fc227491 	stc2	4, cr7, [r2], #-580	; 0xfffffdbc
    19f8:	01000013 	tsteq	r0, r3, lsl r0
    19fc:	004d0e9b 	umaaleq	r0, sp, fp, lr
    1a00:	91020000 	mrsls	r0, (UNDEF: 2)
    1a04:	75270070 	strvc	r0, [r7, #-112]!	; 0xffffff90
    1a08:	01000014 	tsteq	r0, r4, lsl r0
    1a0c:	12a3068f 	adcne	r0, r3, #149946368	; 0x8f00000
    1a10:	87000000 	strhi	r0, [r0, -r0]
    1a14:	003c0000 	eorseq	r0, ip, r0
    1a18:	9c010000 	stcls	0, cr0, [r1], {-0}
    1a1c:	00000971 	andeq	r0, r0, r1, ror r9
    1a20:	00134824 	andseq	r4, r3, r4, lsr #16
    1a24:	218f0100 	orrcs	r0, pc, r0, lsl #2
    1a28:	0000004d 	andeq	r0, r0, sp, asr #32
    1a2c:	266c9102 	strbtcs	r9, [ip], -r2, lsl #2
    1a30:	00716572 	rsbseq	r6, r1, r2, ror r5
    1a34:	57209101 	strpl	r9, [r0, -r1, lsl #2]!
    1a38:	02000005 	andeq	r0, r0, #5
    1a3c:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    1a40:	00001428 	andeq	r1, r0, r8, lsr #8
    1a44:	780a8301 	stmdavc	sl, {r0, r8, r9, pc}
    1a48:	4d000013 	stcmi	0, cr0, [r0, #-76]	; 0xffffffb4
    1a4c:	c4000000 	strgt	r0, [r0], #-0
    1a50:	3c000086 	stccc	0, cr0, [r0], {134}	; 0x86
    1a54:	01000000 	mrseq	r0, (UNDEF: 0)
    1a58:	0009ae9c 	muleq	r9, ip, lr
    1a5c:	65722600 	ldrbvs	r2, [r2, #-1536]!	; 0xfffffa00
    1a60:	85010071 	strhi	r0, [r1, #-113]	; 0xffffff8f
    1a64:	00053320 	andeq	r3, r5, r0, lsr #6
    1a68:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1a6c:	00127b22 	andseq	r7, r2, r2, lsr #22
    1a70:	0e860100 	rmfeqs	f0, f6, f0
    1a74:	0000004d 	andeq	r0, r0, sp, asr #32
    1a78:	00709102 	rsbseq	r9, r0, r2, lsl #2
    1a7c:	00156a25 	andseq	r6, r5, r5, lsr #20
    1a80:	0a770100 	beq	1dc1e88 <__bss_end+0x1db8ebc>
    1a84:	0000131e 	andeq	r1, r0, lr, lsl r3
    1a88:	0000004d 	andeq	r0, r0, sp, asr #32
    1a8c:	00008688 	andeq	r8, r0, r8, lsl #13
    1a90:	0000003c 	andeq	r0, r0, ip, lsr r0
    1a94:	09eb9c01 	stmibeq	fp!, {r0, sl, fp, ip, pc}^
    1a98:	72260000 	eorvc	r0, r6, #0
    1a9c:	01007165 	tsteq	r0, r5, ror #2
    1aa0:	05332079 	ldreq	r2, [r3, #-121]!	; 0xffffff87
    1aa4:	91020000 	mrsls	r0, (UNDEF: 2)
    1aa8:	127b2274 	rsbsne	r2, fp, #116, 4	; 0x40000007
    1aac:	7a010000 	bvc	41ab4 <__bss_end+0x38ae8>
    1ab0:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1ab4:	70910200 	addsvc	r0, r1, r0, lsl #4
    1ab8:	138c2500 	orrne	r2, ip, #0, 10
    1abc:	6b010000 	blvs	41ac4 <__bss_end+0x38af8>
    1ac0:	00149206 	andseq	r9, r4, r6, lsl #4
    1ac4:	00036e00 	andeq	r6, r3, r0, lsl #28
    1ac8:	00863400 	addeq	r3, r6, r0, lsl #8
    1acc:	00005400 	andeq	r5, r0, r0, lsl #8
    1ad0:	379c0100 	ldrcc	r0, [ip, r0, lsl #2]
    1ad4:	2400000a 	strcs	r0, [r0], #-10
    1ad8:	000013fc 	strdeq	r1, [r0], -ip
    1adc:	4d156b01 	vldrmi	d6, [r5, #-4]
    1ae0:	02000000 	andeq	r0, r0, #0
    1ae4:	22246c91 	eorcs	r6, r4, #37120	; 0x9100
    1ae8:	01000008 	tsteq	r0, r8
    1aec:	004d256b 	subeq	r2, sp, fp, ror #10
    1af0:	91020000 	mrsls	r0, (UNDEF: 2)
    1af4:	15622268 	strbne	r2, [r2, #-616]!	; 0xfffffd98
    1af8:	6d010000 	stcvs	0, cr0, [r1, #-0]
    1afc:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1b00:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1b04:	12ba2500 	adcsne	r2, sl, #0, 10
    1b08:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
    1b0c:	0014f912 	andseq	pc, r4, r2, lsl r9	; <UNPREDICTABLE>
    1b10:	00008b00 	andeq	r8, r0, r0, lsl #22
    1b14:	0085e400 	addeq	lr, r5, r0, lsl #8
    1b18:	00005000 	andeq	r5, r0, r0
    1b1c:	929c0100 	addsls	r0, ip, #0, 2
    1b20:	2400000a 	strcs	r0, [r0], #-10
    1b24:	000011e8 	andeq	r1, r0, r8, ror #3
    1b28:	4d205e01 	stcmi	14, cr5, [r0, #-4]!
    1b2c:	02000000 	andeq	r0, r0, #0
    1b30:	31246c91 			; <UNDEFINED> instruction: 0x31246c91
    1b34:	01000014 	tsteq	r0, r4, lsl r0
    1b38:	004d2f5e 	subeq	r2, sp, lr, asr pc
    1b3c:	91020000 	mrsls	r0, (UNDEF: 2)
    1b40:	08222468 	stmdaeq	r2!, {r3, r5, r6, sl, sp}
    1b44:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
    1b48:	00004d3f 	andeq	r4, r0, pc, lsr sp
    1b4c:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1b50:	00156222 	andseq	r6, r5, r2, lsr #4
    1b54:	16600100 	strbtne	r0, [r0], -r0, lsl #2
    1b58:	0000008b 	andeq	r0, r0, fp, lsl #1
    1b5c:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1b60:	0013f525 	andseq	pc, r3, r5, lsr #10
    1b64:	0a520100 	beq	1481f6c <__bss_end+0x1478fa0>
    1b68:	000012bf 			; <UNDEFINED> instruction: 0x000012bf
    1b6c:	0000004d 	andeq	r0, r0, sp, asr #32
    1b70:	000085a0 	andeq	r8, r0, r0, lsr #11
    1b74:	00000044 	andeq	r0, r0, r4, asr #32
    1b78:	0ade9c01 	beq	ff7a8b84 <__bss_end+0xff79fbb8>
    1b7c:	e8240000 	stmda	r4!, {}	; <UNPREDICTABLE>
    1b80:	01000011 	tsteq	r0, r1, lsl r0
    1b84:	004d1a52 	subeq	r1, sp, r2, asr sl
    1b88:	91020000 	mrsls	r0, (UNDEF: 2)
    1b8c:	1431246c 	ldrtne	r2, [r1], #-1132	; 0xfffffb94
    1b90:	52010000 	andpl	r0, r1, #0
    1b94:	00004d29 	andeq	r4, r0, r9, lsr #26
    1b98:	68910200 	ldmvs	r1, {r9}
    1b9c:	00152822 	andseq	r2, r5, r2, lsr #16
    1ba0:	0e540100 	rdfeqs	f0, f4, f0
    1ba4:	0000004d 	andeq	r0, r0, sp, asr #32
    1ba8:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1bac:	00152225 	andseq	r2, r5, r5, lsr #4
    1bb0:	0a450100 	beq	1141fb8 <__bss_end+0x1138fec>
    1bb4:	00001504 	andeq	r1, r0, r4, lsl #10
    1bb8:	0000004d 	andeq	r0, r0, sp, asr #32
    1bbc:	00008550 	andeq	r8, r0, r0, asr r5
    1bc0:	00000050 	andeq	r0, r0, r0, asr r0
    1bc4:	0b399c01 	bleq	e68bd0 <__bss_end+0xe5fc04>
    1bc8:	e8240000 	stmda	r4!, {}	; <UNPREDICTABLE>
    1bcc:	01000011 	tsteq	r0, r1, lsl r0
    1bd0:	004d1945 	subeq	r1, sp, r5, asr #18
    1bd4:	91020000 	mrsls	r0, (UNDEF: 2)
    1bd8:	13d0246c 	bicsne	r2, r0, #108, 8	; 0x6c000000
    1bdc:	45010000 	strmi	r0, [r1, #-0]
    1be0:	00011d30 	andeq	r1, r1, r0, lsr sp
    1be4:	68910200 	ldmvs	r1, {r9}
    1be8:	00143724 	andseq	r3, r4, r4, lsr #14
    1bec:	41450100 	mrsmi	r0, (UNDEF: 85)
    1bf0:	00000858 	andeq	r0, r0, r8, asr r8
    1bf4:	22649102 	rsbcs	r9, r4, #-2147483648	; 0x80000000
    1bf8:	00001562 	andeq	r1, r0, r2, ror #10
    1bfc:	4d0e4701 	stcmi	7, cr4, [lr, #-4]
    1c00:	02000000 	andeq	r0, r0, #0
    1c04:	27007491 			; <UNDEFINED> instruction: 0x27007491
    1c08:	00001268 	andeq	r1, r0, r8, ror #4
    1c0c:	da063f01 	ble	191818 <__bss_end+0x18884c>
    1c10:	24000013 	strcs	r0, [r0], #-19	; 0xffffffed
    1c14:	2c000085 	stccs	0, cr0, [r0], {133}	; 0x85
    1c18:	01000000 	mrseq	r0, (UNDEF: 0)
    1c1c:	000b639c 	muleq	fp, ip, r3
    1c20:	11e82400 	mvnne	r2, r0, lsl #8
    1c24:	3f010000 	svccc	0x00010000
    1c28:	00004d15 	andeq	r4, r0, r5, lsl sp
    1c2c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1c30:	146f2500 	strbtne	r2, [pc], #-1280	; 1c38 <shift+0x1c38>
    1c34:	32010000 	andcc	r0, r1, #0
    1c38:	00143d0a 	andseq	r3, r4, sl, lsl #26
    1c3c:	00004d00 	andeq	r4, r0, r0, lsl #26
    1c40:	0084d400 	addeq	sp, r4, r0, lsl #8
    1c44:	00005000 	andeq	r5, r0, r0
    1c48:	be9c0100 	fmllte	f0, f4, f0
    1c4c:	2400000b 	strcs	r0, [r0], #-11
    1c50:	000011e8 	andeq	r1, r0, r8, ror #3
    1c54:	4d193201 	lfmmi	f3, 4, [r9, #-4]
    1c58:	02000000 	andeq	r0, r0, #0
    1c5c:	3e246c91 	mcrcc	12, 1, r6, cr4, cr1, {4}
    1c60:	01000015 	tsteq	r0, r5, lsl r0
    1c64:	037b2b32 	cmneq	fp, #51200	; 0xc800
    1c68:	91020000 	mrsls	r0, (UNDEF: 2)
    1c6c:	146a2468 	strbtne	r2, [sl], #-1128	; 0xfffffb98
    1c70:	32010000 	andcc	r0, r1, #0
    1c74:	00004d3c 	andeq	r4, r0, ip, lsr sp
    1c78:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1c7c:	0014f322 	andseq	pc, r4, r2, lsr #6
    1c80:	0e340100 	rsfeqs	f0, f4, f0
    1c84:	0000004d 	andeq	r0, r0, sp, asr #32
    1c88:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1c8c:	00158c25 	andseq	r8, r5, r5, lsr #24
    1c90:	0a250100 	beq	942098 <__bss_end+0x9390cc>
    1c94:	00001545 	andeq	r1, r0, r5, asr #10
    1c98:	0000004d 	andeq	r0, r0, sp, asr #32
    1c9c:	00008484 	andeq	r8, r0, r4, lsl #9
    1ca0:	00000050 	andeq	r0, r0, r0, asr r0
    1ca4:	0c199c01 	ldceq	12, cr9, [r9], {1}
    1ca8:	e8240000 	stmda	r4!, {}	; <UNPREDICTABLE>
    1cac:	01000011 	tsteq	r0, r1, lsl r0
    1cb0:	004d1825 	subeq	r1, sp, r5, lsr #16
    1cb4:	91020000 	mrsls	r0, (UNDEF: 2)
    1cb8:	153e246c 	ldrne	r2, [lr, #-1132]!	; 0xfffffb94
    1cbc:	25010000 	strcs	r0, [r1, #-0]
    1cc0:	000c1f2a 	andeq	r1, ip, sl, lsr #30
    1cc4:	68910200 	ldmvs	r1, {r9}
    1cc8:	00146a24 	andseq	r6, r4, r4, lsr #20
    1ccc:	3b250100 	blcc	9420d4 <__bss_end+0x939108>
    1cd0:	0000004d 	andeq	r0, r0, sp, asr #32
    1cd4:	22649102 	rsbcs	r9, r4, #-2147483648	; 0x80000000
    1cd8:	0000128c 	andeq	r1, r0, ip, lsl #5
    1cdc:	4d0e2701 	stcmi	7, cr2, [lr, #-4]
    1ce0:	02000000 	andeq	r0, r0, #0
    1ce4:	18007491 	stmdane	r0, {r0, r4, r7, sl, ip, sp, lr}
    1ce8:	00002504 	andeq	r2, r0, r4, lsl #10
    1cec:	0c190300 	ldceq	3, cr0, [r9], {-0}
    1cf0:	02250000 	eoreq	r0, r5, #0
    1cf4:	01000014 	tsteq	r0, r4, lsl r0
    1cf8:	15980a19 	ldrne	r0, [r8, #2585]	; 0xa19
    1cfc:	004d0000 	subeq	r0, sp, r0
    1d00:	84400000 	strbhi	r0, [r0], #-0
    1d04:	00440000 	subeq	r0, r4, r0
    1d08:	9c010000 	stcls	0, cr0, [r1], {-0}
    1d0c:	00000c70 	andeq	r0, r0, r0, ror ip
    1d10:	00158324 	andseq	r8, r5, r4, lsr #6
    1d14:	1b190100 	blne	64211c <__bss_end+0x639150>
    1d18:	0000037b 	andeq	r0, r0, fp, ror r3
    1d1c:	246c9102 	strbtcs	r9, [ip], #-258	; 0xfffffefe
    1d20:	00001539 	andeq	r1, r0, r9, lsr r5
    1d24:	c6351901 	ldrtgt	r1, [r5], -r1, lsl #18
    1d28:	02000001 	andeq	r0, r0, #1
    1d2c:	e8226891 	stmda	r2!, {r0, r4, r7, fp, sp, lr}
    1d30:	01000011 	tsteq	r0, r1, lsl r0
    1d34:	004d0e1b 	subeq	r0, sp, fp, lsl lr
    1d38:	91020000 	mrsls	r0, (UNDEF: 2)
    1d3c:	3c280074 	stccc	0, cr0, [r8], #-464	; 0xfffffe30
    1d40:	01000013 	tsteq	r0, r3, lsl r0
    1d44:	12920614 	addsne	r0, r2, #20, 12	; 0x1400000
    1d48:	84240000 	strthi	r0, [r4], #-0
    1d4c:	001c0000 	andseq	r0, ip, r0
    1d50:	9c010000 	stcls	0, cr0, [r1], {-0}
    1d54:	00152f27 	andseq	r2, r5, r7, lsr #30
    1d58:	060e0100 	streq	r0, [lr], -r0, lsl #2
    1d5c:	000012cb 	andeq	r1, r0, fp, asr #5
    1d60:	000083f8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
    1d64:	0000002c 	andeq	r0, r0, ip, lsr #32
    1d68:	0cb09c01 	ldceq	12, cr9, [r0], #4
    1d6c:	15240000 	strne	r0, [r4, #-0]!
    1d70:	01000013 	tsteq	r0, r3, lsl r0
    1d74:	0038140e 	eorseq	r1, r8, lr, lsl #8
    1d78:	91020000 	mrsls	r0, (UNDEF: 2)
    1d7c:	91290074 			; <UNDEFINED> instruction: 0x91290074
    1d80:	01000015 	tsteq	r0, r5, lsl r0
    1d84:	13e40a04 	mvnne	r0, #4, 20	; 0x4000
    1d88:	004d0000 	subeq	r0, sp, r0
    1d8c:	83cc0000 	bichi	r0, ip, #0
    1d90:	002c0000 	eoreq	r0, ip, r0
    1d94:	9c010000 	stcls	0, cr0, [r1], {-0}
    1d98:	64697026 	strbtvs	r7, [r9], #-38	; 0xffffffda
    1d9c:	0e060100 	adfeqs	f0, f6, f0
    1da0:	0000004d 	andeq	r0, r0, sp, asr #32
    1da4:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1da8:	00032e00 	andeq	r2, r3, r0, lsl #28
    1dac:	11000400 	tstne	r0, r0, lsl #8
    1db0:	04000007 	streq	r0, [r0], #-7
    1db4:	0015b401 	andseq	fp, r5, r1, lsl #8
    1db8:	16b60400 	ldrtne	r0, [r6], r0, lsl #8
    1dbc:	13aa0000 			; <UNDEFINED> instruction: 0x13aa0000
    1dc0:	88280000 	stmdahi	r8!, {}	; <UNPREDICTABLE>
    1dc4:	04b80000 	ldrteq	r0, [r8], #0
    1dc8:	06c50000 	strbeq	r0, [r5], r0
    1dcc:	49020000 	stmdbmi	r2, {}	; <UNPREDICTABLE>
    1dd0:	03000000 	movweq	r0, #0
    1dd4:	000016ef 	andeq	r1, r0, pc, ror #13
    1dd8:	61100501 	tstvs	r0, r1, lsl #10
    1ddc:	11000000 	mrsne	r0, (UNDEF: 0)
    1de0:	33323130 	teqcc	r2, #48, 2
    1de4:	37363534 			; <UNDEFINED> instruction: 0x37363534
    1de8:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    1dec:	46454443 	strbmi	r4, [r5], -r3, asr #8
    1df0:	01040000 	mrseq	r0, (UNDEF: 4)
    1df4:	00250103 	eoreq	r0, r5, r3, lsl #2
    1df8:	74050000 	strvc	r0, [r5], #-0
    1dfc:	61000000 	mrsvs	r0, (UNDEF: 0)
    1e00:	06000000 	streq	r0, [r0], -r0
    1e04:	00000066 	andeq	r0, r0, r6, rrx
    1e08:	51070010 	tstpl	r7, r0, lsl r0
    1e0c:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    1e10:	1cbb0704 	ldcne	7, cr0, [fp], #16
    1e14:	01080000 	mrseq	r0, (UNDEF: 8)
    1e18:	000d4608 	andeq	r4, sp, r8, lsl #12
    1e1c:	006d0700 	rsbeq	r0, sp, r0, lsl #14
    1e20:	2a090000 	bcs	241e28 <__bss_end+0x238e5c>
    1e24:	0a000000 	beq	1e2c <shift+0x1e2c>
    1e28:	0000171e 	andeq	r1, r0, lr, lsl r7
    1e2c:	09066401 	stmdbeq	r6, {r0, sl, sp, lr}
    1e30:	60000017 	andvs	r0, r0, r7, lsl r0
    1e34:	8000008c 	andhi	r0, r0, ip, lsl #1
    1e38:	01000000 	mrseq	r0, (UNDEF: 0)
    1e3c:	0000fb9c 	muleq	r0, ip, fp
    1e40:	72730b00 	rsbsvc	r0, r3, #0, 22
    1e44:	64010063 	strvs	r0, [r1], #-99	; 0xffffff9d
    1e48:	0000fb19 	andeq	pc, r0, r9, lsl fp	; <UNPREDICTABLE>
    1e4c:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1e50:	7473640b 	ldrbtvc	r6, [r3], #-1035	; 0xfffffbf5
    1e54:	24640100 	strbtcs	r0, [r4], #-256	; 0xffffff00
    1e58:	00000102 	andeq	r0, r0, r2, lsl #2
    1e5c:	0b609102 	bleq	182626c <__bss_end+0x181d2a0>
    1e60:	006d756e 	rsbeq	r7, sp, lr, ror #10
    1e64:	042d6401 	strteq	r6, [sp], #-1025	; 0xfffffbff
    1e68:	02000001 	andeq	r0, r0, #1
    1e6c:	780c5c91 	stmdavc	ip, {r0, r4, r7, sl, fp, ip, lr}
    1e70:	01000017 	tsteq	r0, r7, lsl r0
    1e74:	010b0e66 	tsteq	fp, r6, ror #28
    1e78:	91020000 	mrsls	r0, (UNDEF: 2)
    1e7c:	16fb0c70 	uxtahne	r0, fp, r0, ror #24
    1e80:	67010000 	strvs	r0, [r1, -r0]
    1e84:	00011108 	andeq	r1, r1, r8, lsl #2
    1e88:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1e8c:	008c880d 	addeq	r8, ip, sp, lsl #16
    1e90:	00004800 	andeq	r4, r0, r0, lsl #16
    1e94:	00690e00 	rsbeq	r0, r9, r0, lsl #28
    1e98:	040b6901 	streq	r6, [fp], #-2305	; 0xfffff6ff
    1e9c:	02000001 	andeq	r0, r0, #1
    1ea0:	00007491 	muleq	r0, r1, r4
    1ea4:	0101040f 	tsteq	r1, pc, lsl #8
    1ea8:	11100000 	tstne	r0, r0
    1eac:	05041204 	streq	r1, [r4, #-516]	; 0xfffffdfc
    1eb0:	00746e69 	rsbseq	r6, r4, r9, ror #28
    1eb4:	0074040f 	rsbseq	r0, r4, pc, lsl #8
    1eb8:	040f0000 	streq	r0, [pc], #-0	; 1ec0 <shift+0x1ec0>
    1ebc:	0000006d 	andeq	r0, r0, sp, rrx
    1ec0:	0016920a 	andseq	r9, r6, sl, lsl #4
    1ec4:	065c0100 	ldrbeq	r0, [ip], -r0, lsl #2
    1ec8:	0000169f 	muleq	r0, pc, r6	; <UNPREDICTABLE>
    1ecc:	00008bf8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
    1ed0:	00000068 	andeq	r0, r0, r8, rrx
    1ed4:	01769c01 	cmneq	r6, r1, lsl #24
    1ed8:	71130000 	tstvc	r3, r0
    1edc:	01000017 	tsteq	r0, r7, lsl r0
    1ee0:	0102125c 	tsteq	r2, ip, asr r2
    1ee4:	91020000 	mrsls	r0, (UNDEF: 2)
    1ee8:	1698136c 	ldrne	r1, [r8], ip, ror #6
    1eec:	5c010000 	stcpl	0, cr0, [r1], {-0}
    1ef0:	0001041e 	andeq	r0, r1, lr, lsl r4
    1ef4:	68910200 	ldmvs	r1, {r9}
    1ef8:	6d656d0e 	stclvs	13, cr6, [r5, #-56]!	; 0xffffffc8
    1efc:	085e0100 	ldmdaeq	lr, {r8}^
    1f00:	00000111 	andeq	r0, r0, r1, lsl r1
    1f04:	0d709102 	ldfeqp	f1, [r0, #-8]!
    1f08:	00008c14 	andeq	r8, r0, r4, lsl ip
    1f0c:	0000003c 	andeq	r0, r0, ip, lsr r0
    1f10:	0100690e 	tsteq	r0, lr, lsl #18
    1f14:	01040b60 	tsteq	r4, r0, ror #22
    1f18:	91020000 	mrsls	r0, (UNDEF: 2)
    1f1c:	14000074 	strne	r0, [r0], #-116	; 0xffffff8c
    1f20:	00001725 	andeq	r1, r0, r5, lsr #14
    1f24:	3e055201 	cdpcc	2, 0, cr5, cr5, cr1, {0}
    1f28:	04000017 	streq	r0, [r0], #-23	; 0xffffffe9
    1f2c:	a4000001 	strge	r0, [r0], #-1
    1f30:	5400008b 	strpl	r0, [r0], #-139	; 0xffffff75
    1f34:	01000000 	mrseq	r0, (UNDEF: 0)
    1f38:	0001af9c 	muleq	r1, ip, pc	; <UNPREDICTABLE>
    1f3c:	00730b00 	rsbseq	r0, r3, r0, lsl #22
    1f40:	0b185201 	bleq	61674c <__bss_end+0x60d780>
    1f44:	02000001 	andeq	r0, r0, #1
    1f48:	690e6c91 	stmdbvs	lr, {r0, r4, r7, sl, fp, sp, lr}
    1f4c:	06540100 	ldrbeq	r0, [r4], -r0, lsl #2
    1f50:	00000104 	andeq	r0, r0, r4, lsl #2
    1f54:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1f58:	00176114 	andseq	r6, r7, r4, lsl r1
    1f5c:	05420100 	strbeq	r0, [r2, #-256]	; 0xffffff00
    1f60:	0000172c 	andeq	r1, r0, ip, lsr #14
    1f64:	00000104 	andeq	r0, r0, r4, lsl #2
    1f68:	00008af8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
    1f6c:	000000ac 	andeq	r0, r0, ip, lsr #1
    1f70:	02159c01 	andseq	r9, r5, #256	; 0x100
    1f74:	730b0000 	movwvc	r0, #45056	; 0xb000
    1f78:	42010031 	andmi	r0, r1, #49	; 0x31
    1f7c:	00010b19 	andeq	r0, r1, r9, lsl fp
    1f80:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1f84:	0032730b 	eorseq	r7, r2, fp, lsl #6
    1f88:	0b294201 	bleq	a52794 <__bss_end+0xa497c8>
    1f8c:	02000001 	andeq	r0, r0, #1
    1f90:	6e0b6891 	mcrvs	8, 0, r6, cr11, cr1, {4}
    1f94:	01006d75 	tsteq	r0, r5, ror sp
    1f98:	01043142 	tsteq	r4, r2, asr #2
    1f9c:	91020000 	mrsls	r0, (UNDEF: 2)
    1fa0:	31750e64 	cmncc	r5, r4, ror #28
    1fa4:	10440100 	subne	r0, r4, r0, lsl #2
    1fa8:	00000215 	andeq	r0, r0, r5, lsl r2
    1fac:	0e779102 	expeqs	f1, f2
    1fb0:	01003275 	tsteq	r0, r5, ror r2
    1fb4:	02151444 	andseq	r1, r5, #68, 8	; 0x44000000
    1fb8:	91020000 	mrsls	r0, (UNDEF: 2)
    1fbc:	01080076 	tsteq	r8, r6, ror r0
    1fc0:	000d3d08 	andeq	r3, sp, r8, lsl #26
    1fc4:	17691400 	strbne	r1, [r9, -r0, lsl #8]!
    1fc8:	36010000 	strcc	r0, [r1], -r0
    1fcc:	00175007 	andseq	r5, r7, r7
    1fd0:	00011100 	andeq	r1, r1, r0, lsl #2
    1fd4:	008a3800 	addeq	r3, sl, r0, lsl #16
    1fd8:	0000c000 	andeq	ip, r0, r0
    1fdc:	759c0100 	ldrvc	r0, [ip, #256]	; 0x100
    1fe0:	13000002 	movwne	r0, #2
    1fe4:	0000168d 	andeq	r1, r0, sp, lsl #13
    1fe8:	11153601 	tstne	r5, r1, lsl #12
    1fec:	02000001 	andeq	r0, r0, #1
    1ff0:	730b6c91 	movwvc	r6, #48273	; 0xbc91
    1ff4:	01006372 	tsteq	r0, r2, ror r3
    1ff8:	010b2736 	tsteq	fp, r6, lsr r7
    1ffc:	91020000 	mrsls	r0, (UNDEF: 2)
    2000:	756e0b68 	strbvc	r0, [lr, #-2920]!	; 0xfffff498
    2004:	3601006d 	strcc	r0, [r1], -sp, rrx
    2008:	00010430 	andeq	r0, r1, r0, lsr r4
    200c:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    2010:	0100690e 	tsteq	r0, lr, lsl #18
    2014:	01040638 	tsteq	r4, r8, lsr r6
    2018:	91020000 	mrsls	r0, (UNDEF: 2)
    201c:	4b140074 	blmi	5021f4 <__bss_end+0x4f9228>
    2020:	01000017 	tsteq	r0, r7, lsl r0
    2024:	16ab0524 	strtne	r0, [fp], r4, lsr #10
    2028:	01040000 	mrseq	r0, (UNDEF: 4)
    202c:	899c0000 	ldmibhi	ip, {}	; <UNPREDICTABLE>
    2030:	009c0000 	addseq	r0, ip, r0
    2034:	9c010000 	stcls	0, cr0, [r1], {-0}
    2038:	000002b2 			; <UNDEFINED> instruction: 0x000002b2
    203c:	00168713 	andseq	r8, r6, r3, lsl r7
    2040:	16240100 	strtne	r0, [r4], -r0, lsl #2
    2044:	0000010b 	andeq	r0, r0, fp, lsl #2
    2048:	0c6c9102 	stfeqp	f1, [ip], #-8
    204c:	00001702 	andeq	r1, r0, r2, lsl #14
    2050:	04062601 	streq	r2, [r6], #-1537	; 0xfffff9ff
    2054:	02000001 	andeq	r0, r0, #1
    2058:	15007491 	strne	r7, [r0, #-1169]	; 0xfffffb6f
    205c:	0000177f 	andeq	r1, r0, pc, ror r7
    2060:	84060801 	strhi	r0, [r6], #-2049	; 0xfffff7ff
    2064:	28000017 	stmdacs	r0, {r0, r1, r2, r4}
    2068:	74000088 	strvc	r0, [r0], #-136	; 0xffffff78
    206c:	01000001 	tsteq	r0, r1
    2070:	1687139c 	pkhbtne	r1, r7, ip, lsl #7
    2074:	08010000 	stmdaeq	r1, {}	; <UNPREDICTABLE>
    2078:	00006618 	andeq	r6, r0, r8, lsl r6
    207c:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    2080:	00170213 	andseq	r0, r7, r3, lsl r2
    2084:	25080100 	strcs	r0, [r8, #-256]	; 0xffffff00
    2088:	00000111 	andeq	r0, r0, r1, lsl r1
    208c:	13609102 	cmnne	r0, #-2147483648	; 0x80000000
    2090:	00001719 	andeq	r1, r0, r9, lsl r7
    2094:	663a0801 	ldrtvs	r0, [sl], -r1, lsl #16
    2098:	02000000 	andeq	r0, r0, #0
    209c:	690e5c91 	stmdbvs	lr, {r0, r4, r7, sl, fp, ip, lr}
    20a0:	060a0100 	streq	r0, [sl], -r0, lsl #2
    20a4:	00000104 	andeq	r0, r0, r4, lsl #2
    20a8:	0d749102 	ldfeqp	f1, [r4, #-8]!
    20ac:	000088f4 	strdeq	r8, [r0], -r4
    20b0:	00000098 	muleq	r0, r8, r0
    20b4:	01006a0e 	tsteq	r0, lr, lsl #20
    20b8:	01040b1c 	tsteq	r4, ip, lsl fp
    20bc:	91020000 	mrsls	r0, (UNDEF: 2)
    20c0:	891c0d70 	ldmdbhi	ip, {r4, r5, r6, r8, sl, fp}
    20c4:	00600000 	rsbeq	r0, r0, r0
    20c8:	630e0000 	movwvs	r0, #57344	; 0xe000
    20cc:	081e0100 	ldmdaeq	lr, {r8}
    20d0:	0000006d 	andeq	r0, r0, sp, rrx
    20d4:	006f9102 	rsbeq	r9, pc, r2, lsl #2
    20d8:	22000000 	andcs	r0, r0, #0
    20dc:	02000000 	andeq	r0, r0, #0
    20e0:	00083800 	andeq	r3, r8, r0, lsl #16
    20e4:	3f010400 	svccc	0x00010400
    20e8:	e0000009 	and	r0, r0, r9
    20ec:	ec00008c 	stc	0, cr0, [r0], {140}	; 0x8c
    20f0:	9000008e 	andls	r0, r0, lr, lsl #1
    20f4:	c0000017 	andgt	r0, r0, r7, lsl r0
    20f8:	61000017 	tstvs	r0, r7, lsl r0
    20fc:	01000000 	mrseq	r0, (UNDEF: 0)
    2100:	00002280 	andeq	r2, r0, r0, lsl #5
    2104:	4c000200 	sfmmi	f0, 4, [r0], {-0}
    2108:	04000008 	streq	r0, [r0], #-8
    210c:	0009bc01 	andeq	fp, r9, r1, lsl #24
    2110:	008eec00 	addeq	lr, lr, r0, lsl #24
    2114:	008ef000 	addeq	pc, lr, r0
    2118:	00179000 	andseq	r9, r7, r0
    211c:	0017c000 	andseq	ip, r7, r0
    2120:	00006100 	andeq	r6, r0, r0, lsl #2
    2124:	32800100 	addcc	r0, r0, #0, 2
    2128:	04000009 	streq	r0, [r0], #-9
    212c:	00086000 	andeq	r6, r8, r0
    2130:	8e010400 	cfcpyshi	mvf0, mvf1
    2134:	0c00001b 	stceq	0, cr0, [r0], {27}
    2138:	00001ae5 	andeq	r1, r0, r5, ror #21
    213c:	000017c0 	andeq	r1, r0, r0, asr #15
    2140:	00000a1c 	andeq	r0, r0, ip, lsl sl
    2144:	69050402 	stmdbvs	r5, {r1, sl}
    2148:	0300746e 	movweq	r7, #1134	; 0x46e
    214c:	1cbb0704 	ldcne	7, cr0, [fp], #16
    2150:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    2154:	00035705 	andeq	r5, r3, r5, lsl #14
    2158:	04080300 	streq	r0, [r8], #-768	; 0xfffffd00
    215c:	0000238d 	andeq	r2, r0, sp, lsl #7
    2160:	001b4004 	andseq	r4, fp, r4
    2164:	162a0100 	strtne	r0, [sl], -r0, lsl #2
    2168:	00000024 	andeq	r0, r0, r4, lsr #32
    216c:	001faf04 	andseq	sl, pc, r4, lsl #30
    2170:	152f0100 	strne	r0, [pc, #-256]!	; 2078 <shift+0x2078>
    2174:	00000051 	andeq	r0, r0, r1, asr r0
    2178:	00570405 	subseq	r0, r7, r5, lsl #8
    217c:	39060000 	stmdbcc	r6, {}	; <UNPREDICTABLE>
    2180:	66000000 	strvs	r0, [r0], -r0
    2184:	07000000 	streq	r0, [r0, -r0]
    2188:	00000066 	andeq	r0, r0, r6, rrx
    218c:	6c040500 	cfstr32vs	mvfx0, [r4], {-0}
    2190:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    2194:	0026e104 	eoreq	lr, r6, r4, lsl #2
    2198:	0f360100 	svceq	0x00360100
    219c:	00000079 	andeq	r0, r0, r9, ror r0
    21a0:	007f0405 	rsbseq	r0, pc, r5, lsl #8
    21a4:	1d060000 	stcne	0, cr0, [r6, #-0]
    21a8:	93000000 	movwls	r0, #0
    21ac:	07000000 	streq	r0, [r0, -r0]
    21b0:	00000066 	andeq	r0, r0, r6, rrx
    21b4:	00006607 	andeq	r6, r0, r7, lsl #12
    21b8:	01030000 	mrseq	r0, (UNDEF: 3)
    21bc:	000d3d08 	andeq	r3, sp, r8, lsl #26
    21c0:	21e70900 	mvncs	r0, r0, lsl #18
    21c4:	bb010000 	bllt	421cc <__bss_end+0x39200>
    21c8:	00004512 	andeq	r4, r0, r2, lsl r5
    21cc:	270f0900 	strcs	r0, [pc, -r0, lsl #18]
    21d0:	be010000 	cdplt	0, 0, cr0, cr1, cr0, {0}
    21d4:	00006d10 	andeq	r6, r0, r0, lsl sp
    21d8:	06010300 	streq	r0, [r1], -r0, lsl #6
    21dc:	00000d3f 	andeq	r0, r0, pc, lsr sp
    21e0:	001ecf0a 	andseq	ip, lr, sl, lsl #30
    21e4:	93010700 	movwls	r0, #5888	; 0x1700
    21e8:	02000000 	andeq	r0, r0, #0
    21ec:	01e60617 	mvneq	r0, r7, lsl r6
    21f0:	9e0b0000 	cdpls	0, 0, cr0, cr11, cr0, {0}
    21f4:	00000019 	andeq	r0, r0, r9, lsl r0
    21f8:	001dec0b 	andseq	lr, sp, fp, lsl #24
    21fc:	b20b0100 	andlt	r0, fp, #0, 2
    2200:	02000022 	andeq	r0, r0, #34	; 0x22
    2204:	0026230b 	eoreq	r2, r6, fp, lsl #6
    2208:	560b0300 	strpl	r0, [fp], -r0, lsl #6
    220c:	04000022 	streq	r0, [r0], #-34	; 0xffffffde
    2210:	00252c0b 	eoreq	r2, r5, fp, lsl #24
    2214:	900b0500 	andls	r0, fp, r0, lsl #10
    2218:	06000024 	streq	r0, [r0], -r4, lsr #32
    221c:	0019bf0b 	andseq	fp, r9, fp, lsl #30
    2220:	410b0700 	tstmi	fp, r0, lsl #14
    2224:	08000025 	stmdaeq	r0, {r0, r2, r5}
    2228:	00254f0b 	eoreq	r4, r5, fp, lsl #30
    222c:	160b0900 	strne	r0, [fp], -r0, lsl #18
    2230:	0a000026 	beq	22d0 <shift+0x22d0>
    2234:	0021ad0b 	eoreq	sl, r1, fp, lsl #26
    2238:	810b0b00 	tsthi	fp, r0, lsl #22
    223c:	0c00001b 	stceq	0, cr0, [r0], {27}
    2240:	001c5e0b 	andseq	r5, ip, fp, lsl #28
    2244:	130b0d00 	movwne	r0, #48384	; 0xbd00
    2248:	0e00001f 	mcreq	0, 0, r0, cr0, cr15, {0}
    224c:	001f290b 	andseq	r2, pc, fp, lsl #18
    2250:	260b0f00 	strcs	r0, [fp], -r0, lsl #30
    2254:	1000001e 	andne	r0, r0, lr, lsl r0
    2258:	00223a0b 	eoreq	r3, r2, fp, lsl #20
    225c:	920b1100 	andls	r1, fp, #0, 2
    2260:	1200001e 	andne	r0, r0, #30
    2264:	0028a80b 	eoreq	sl, r8, fp, lsl #16
    2268:	280b1300 	stmdacs	fp, {r8, r9, ip}
    226c:	1400001a 	strne	r0, [r0], #-26	; 0xffffffe6
    2270:	001eb60b 	andseq	fp, lr, fp, lsl #12
    2274:	650b1500 	strvs	r1, [fp, #-1280]	; 0xfffffb00
    2278:	16000019 			; <UNDEFINED> instruction: 0x16000019
    227c:	0026460b 	eoreq	r4, r6, fp, lsl #12
    2280:	680b1700 	stmdavs	fp, {r8, r9, sl, ip}
    2284:	18000027 	stmdane	r0, {r0, r1, r2, r5}
    2288:	001edb0b 	andseq	sp, lr, fp, lsl #22
    228c:	240b1900 	strcs	r1, [fp], #-2304	; 0xfffff700
    2290:	1a000023 	bne	2324 <shift+0x2324>
    2294:	0026540b 	eoreq	r5, r6, fp, lsl #8
    2298:	940b1b00 	strls	r1, [fp], #-2816	; 0xfffff500
    229c:	1c000018 	stcne	0, cr0, [r0], {24}
    22a0:	0026620b 	eoreq	r6, r6, fp, lsl #4
    22a4:	700b1d00 	andvc	r1, fp, r0, lsl #26
    22a8:	1e000026 	cdpne	0, 0, cr0, cr0, cr6, {1}
    22ac:	0018420b 	andseq	r4, r8, fp, lsl #4
    22b0:	9a0b1f00 	bls	2c9eb8 <__bss_end+0x2c0eec>
    22b4:	20000026 	andcs	r0, r0, r6, lsr #32
    22b8:	0023d10b 	eoreq	sp, r3, fp, lsl #2
    22bc:	0c0b2100 	stfeqs	f2, [fp], {-0}
    22c0:	22000022 	andcs	r0, r0, #34	; 0x22
    22c4:	0026390b 	eoreq	r3, r6, fp, lsl #18
    22c8:	100b2300 	andne	r2, fp, r0, lsl #6
    22cc:	24000021 	strcs	r0, [r0], #-33	; 0xffffffdf
    22d0:	0020120b 	eoreq	r1, r0, fp, lsl #4
    22d4:	2c0b2500 	cfstr32cs	mvfx2, [fp], {-0}
    22d8:	2600001d 			; <UNDEFINED> instruction: 0x2600001d
    22dc:	0020300b 	eoreq	r3, r0, fp
    22e0:	c80b2700 	stmdagt	fp, {r8, r9, sl, sp}
    22e4:	2800001d 	stmdacs	r0, {r0, r2, r3, r4}
    22e8:	0020400b 	eoreq	r4, r0, fp
    22ec:	500b2900 	andpl	r2, fp, r0, lsl #18
    22f0:	2a000020 	bcs	2378 <shift+0x2378>
    22f4:	0021930b 	eoreq	r9, r1, fp, lsl #6
    22f8:	b90b2b00 	stmdblt	fp, {r8, r9, fp, sp}
    22fc:	2c00001f 	stccs	0, cr0, [r0], {31}
    2300:	0023de0b 	eoreq	sp, r3, fp, lsl #28
    2304:	6d0b2d00 	stcvs	13, cr2, [fp, #-0]
    2308:	2e00001d 	mcrcs	0, 0, r0, cr0, cr13, {0}
    230c:	1f4b0a00 	svcne	0x004b0a00
    2310:	01070000 	mrseq	r0, (UNDEF: 7)
    2314:	00000093 	muleq	r0, r3, r0
    2318:	c7061703 	strgt	r1, [r6, -r3, lsl #14]
    231c:	0b000003 	bleq	2330 <shift+0x2330>
    2320:	00001c80 	andeq	r1, r0, r0, lsl #25
    2324:	18d20b00 	ldmne	r2, {r8, r9, fp}^
    2328:	0b010000 	bleq	42330 <__bss_end+0x39364>
    232c:	00002856 	andeq	r2, r0, r6, asr r8
    2330:	26e90b02 	strbtcs	r0, [r9], r2, lsl #22
    2334:	0b030000 	bleq	c233c <__bss_end+0xb9370>
    2338:	00001ca0 	andeq	r1, r0, r0, lsr #25
    233c:	198a0b04 	stmibne	sl, {r2, r8, r9, fp}
    2340:	0b050000 	bleq	142348 <__bss_end+0x13937c>
    2344:	00001d49 	andeq	r1, r0, r9, asr #26
    2348:	1c900b06 	vldmiane	r0, {d0-d2}
    234c:	0b070000 	bleq	1c2354 <__bss_end+0x1b9388>
    2350:	0000257d 	andeq	r2, r0, sp, ror r5
    2354:	26ce0b08 	strbcs	r0, [lr], r8, lsl #22
    2358:	0b090000 	bleq	242360 <__bss_end+0x239394>
    235c:	000024b4 			; <UNDEFINED> instruction: 0x000024b4
    2360:	19dd0b0a 	ldmibne	sp, {r1, r3, r8, r9, fp}^
    2364:	0b0b0000 	bleq	2c236c <__bss_end+0x2b93a0>
    2368:	00001cea 	andeq	r1, r0, sl, ror #25
    236c:	19530b0c 	ldmdbne	r3, {r2, r3, r8, r9, fp}^
    2370:	0b0d0000 	bleq	342378 <__bss_end+0x3393ac>
    2374:	0000288b 	andeq	r2, r0, fp, lsl #17
    2378:	21800b0e 	orrcs	r0, r0, lr, lsl #22
    237c:	0b0f0000 	bleq	3c2384 <__bss_end+0x3b93b8>
    2380:	00001e5d 	andeq	r1, r0, sp, asr lr
    2384:	21bd0b10 			; <UNDEFINED> instruction: 0x21bd0b10
    2388:	0b110000 	bleq	442390 <__bss_end+0x4393c4>
    238c:	000027aa 	andeq	r2, r0, sl, lsr #15
    2390:	1aa00b12 	bne	fe804fe0 <__bss_end+0xfe7fc014>
    2394:	0b130000 	bleq	4c239c <__bss_end+0x4b93d0>
    2398:	00001e70 	andeq	r1, r0, r0, ror lr
    239c:	20d30b14 	sbcscs	r0, r3, r4, lsl fp
    23a0:	0b150000 	bleq	5423a8 <__bss_end+0x5393dc>
    23a4:	00001c6b 	andeq	r1, r0, fp, ror #24
    23a8:	211f0b16 	tstcs	pc, r6, lsl fp	; <UNPREDICTABLE>
    23ac:	0b170000 	bleq	5c23b4 <__bss_end+0x5b93e8>
    23b0:	00001f35 	andeq	r1, r0, r5, lsr pc
    23b4:	19a80b18 	stmibne	r8!, {r3, r4, r8, r9, fp}
    23b8:	0b190000 	bleq	6423c0 <__bss_end+0x6393f4>
    23bc:	00002751 	andeq	r2, r0, r1, asr r7
    23c0:	209f0b1a 	addscs	r0, pc, sl, lsl fp	; <UNPREDICTABLE>
    23c4:	0b1b0000 	bleq	6c23cc <__bss_end+0x6b9400>
    23c8:	00001e47 	andeq	r1, r0, r7, asr #28
    23cc:	187d0b1c 	ldmdane	sp!, {r2, r3, r4, r8, r9, fp}^
    23d0:	0b1d0000 	bleq	7423d8 <__bss_end+0x73940c>
    23d4:	00001fea 	andeq	r1, r0, sl, ror #31
    23d8:	1fd60b1e 	svcne	0x00d60b1e
    23dc:	0b1f0000 	bleq	7c23e4 <__bss_end+0x7b9418>
    23e0:	00002471 	andeq	r2, r0, r1, ror r4
    23e4:	24fc0b20 	ldrbtcs	r0, [ip], #2848	; 0xb20
    23e8:	0b210000 	bleq	8423f0 <__bss_end+0x839424>
    23ec:	00002730 	andeq	r2, r0, r0, lsr r7
    23f0:	1d7a0b22 	vldmdbne	sl!, {d16-<overflow reg d32>}
    23f4:	0b230000 	bleq	8c23fc <__bss_end+0x8b9430>
    23f8:	000022d4 	ldrdeq	r2, [r0], -r4
    23fc:	24c90b24 	strbcs	r0, [r9], #2852	; 0xb24
    2400:	0b250000 	bleq	942408 <__bss_end+0x93943c>
    2404:	000023ed 	andeq	r2, r0, sp, ror #7
    2408:	24010b26 	strcs	r0, [r1], #-2854	; 0xfffff4da
    240c:	0b270000 	bleq	9c2414 <__bss_end+0x9b9448>
    2410:	00002415 	andeq	r2, r0, r5, lsl r4
    2414:	1b2b0b28 	blne	ac50bc <__bss_end+0xabc0f0>
    2418:	0b290000 	bleq	a42420 <__bss_end+0xa39454>
    241c:	00001a8b 	andeq	r1, r0, fp, lsl #21
    2420:	1ab30b2a 	bne	fecc50d0 <__bss_end+0xfecbc104>
    2424:	0b2b0000 	bleq	ac242c <__bss_end+0xab9460>
    2428:	000025c6 	andeq	r2, r0, r6, asr #11
    242c:	1b080b2c 	blne	2050e4 <__bss_end+0x1fc118>
    2430:	0b2d0000 	bleq	b42438 <__bss_end+0xb3946c>
    2434:	000025da 	ldrdeq	r2, [r0], -sl
    2438:	25ee0b2e 	strbcs	r0, [lr, #2862]!	; 0xb2e
    243c:	0b2f0000 	bleq	bc2444 <__bss_end+0xbb9478>
    2440:	00002602 	andeq	r2, r0, r2, lsl #12
    2444:	1cfc0b30 	vldmiane	ip!, {d16-<overflow reg d39>}
    2448:	0b310000 	bleq	c42450 <__bss_end+0xc39484>
    244c:	00001cd6 	ldrdeq	r1, [r0], -r6
    2450:	1ffe0b32 	svcne	0x00fe0b32
    2454:	0b330000 	bleq	cc245c <__bss_end+0xcb9490>
    2458:	000021d0 	ldrdeq	r2, [r0], -r0
    245c:	27df0b34 			; <UNDEFINED> instruction: 0x27df0b34
    2460:	0b350000 	bleq	d42468 <__bss_end+0xd3949c>
    2464:	00001825 	andeq	r1, r0, r5, lsr #16
    2468:	1dfc0b36 			; <UNDEFINED> instruction: 0x1dfc0b36
    246c:	0b370000 	bleq	dc2474 <__bss_end+0xdb94a8>
    2470:	00001e11 	andeq	r1, r0, r1, lsl lr
    2474:	20600b38 	rsbcs	r0, r0, r8, lsr fp
    2478:	0b390000 	bleq	e42480 <__bss_end+0xe394b4>
    247c:	0000208a 	andeq	r2, r0, sl, lsl #1
    2480:	28080b3a 	stmdacs	r8, {r1, r3, r4, r5, r8, r9, fp}
    2484:	0b3b0000 	bleq	ec248c <__bss_end+0xeb94c0>
    2488:	000022bf 			; <UNDEFINED> instruction: 0x000022bf
    248c:	1d9f0b3c 	vldrne	d0, [pc, #240]	; 2584 <shift+0x2584>
    2490:	0b3d0000 	bleq	f42498 <__bss_end+0xf394cc>
    2494:	000018e4 	andeq	r1, r0, r4, ror #17
    2498:	18a20b3e 	stmiane	r2!, {r1, r2, r3, r4, r5, r8, r9, fp}
    249c:	0b3f0000 	bleq	fc24a4 <__bss_end+0xfb94d8>
    24a0:	0000221c 	andeq	r2, r0, ip, lsl r2
    24a4:	23400b40 	movtcs	r0, #2880	; 0xb40
    24a8:	0b410000 	bleq	10424b0 <__bss_end+0x10394e4>
    24ac:	00002453 	andeq	r2, r0, r3, asr r4
    24b0:	20750b42 	rsbscs	r0, r5, r2, asr #22
    24b4:	0b430000 	bleq	10c24bc <__bss_end+0x10b94f0>
    24b8:	00002841 	andeq	r2, r0, r1, asr #16
    24bc:	22ea0b44 	rsccs	r0, sl, #68, 22	; 0x11000
    24c0:	0b450000 	bleq	11424c8 <__bss_end+0x11394fc>
    24c4:	00001acf 	andeq	r1, r0, pc, asr #21
    24c8:	21500b46 	cmpcs	r0, r6, asr #22
    24cc:	0b470000 	bleq	11c24d4 <__bss_end+0x11b9508>
    24d0:	00001f83 	andeq	r1, r0, r3, lsl #31
    24d4:	18610b48 	stmdane	r1!, {r3, r6, r8, r9, fp}^
    24d8:	0b490000 	bleq	12424e0 <__bss_end+0x1239514>
    24dc:	00001975 	andeq	r1, r0, r5, ror r9
    24e0:	1db30b4a 			; <UNDEFINED> instruction: 0x1db30b4a
    24e4:	0b4b0000 	bleq	12c24ec <__bss_end+0x12b9520>
    24e8:	000020b1 	strheq	r2, [r0], -r1
    24ec:	0203004c 	andeq	r0, r3, #76	; 0x4c
    24f0:	0009cc07 	andeq	ip, r9, r7, lsl #24
    24f4:	03e40c00 	mvneq	r0, #0, 24
    24f8:	03d90000 	bicseq	r0, r9, #0
    24fc:	000d0000 	andeq	r0, sp, r0
    2500:	0003ce0e 	andeq	ip, r3, lr, lsl #28
    2504:	f0040500 			; <UNDEFINED> instruction: 0xf0040500
    2508:	0e000003 	cdpeq	0, 0, cr0, cr0, cr3, {0}
    250c:	000003de 	ldrdeq	r0, [r0], -lr
    2510:	46080103 	strmi	r0, [r8], -r3, lsl #2
    2514:	0e00000d 	cdpeq	0, 0, cr0, cr0, cr13, {0}
    2518:	000003e9 	andeq	r0, r0, r9, ror #7
    251c:	001a190f 	andseq	r1, sl, pc, lsl #18
    2520:	014c0400 	cmpeq	ip, r0, lsl #8
    2524:	0003d91a 	andeq	sp, r3, sl, lsl r9
    2528:	1e370f00 	cdpne	15, 3, cr0, cr7, cr0, {0}
    252c:	82040000 	andhi	r0, r4, #0
    2530:	03d91a01 	bicseq	r1, r9, #4096	; 0x1000
    2534:	e90c0000 	stmdb	ip, {}	; <UNPREDICTABLE>
    2538:	1a000003 	bne	254c <shift+0x254c>
    253c:	0d000004 	stceq	0, cr0, [r0, #-16]
    2540:	20220900 	eorcs	r0, r2, r0, lsl #18
    2544:	2d050000 	stccs	0, cr0, [r5, #-0]
    2548:	00040f0d 	andeq	r0, r4, sp, lsl #30
    254c:	26aa0900 	strtcs	r0, [sl], r0, lsl #18
    2550:	38050000 	stmdacc	r5, {}	; <UNPREDICTABLE>
    2554:	0001e61c 	andeq	lr, r1, ip, lsl r6
    2558:	1d100a00 	vldrne	s0, [r0, #-0]
    255c:	01070000 	mrseq	r0, (UNDEF: 7)
    2560:	00000093 	muleq	r0, r3, r0
    2564:	a50e3a05 	strge	r3, [lr, #-2565]	; 0xfffff5fb
    2568:	0b000004 	bleq	2580 <shift+0x2580>
    256c:	00001876 	andeq	r1, r0, r6, ror r8
    2570:	1f220b00 	svcne	0x00220b00
    2574:	0b010000 	bleq	4257c <__bss_end+0x395b0>
    2578:	000027bc 			; <UNDEFINED> instruction: 0x000027bc
    257c:	277f0b02 	ldrbcs	r0, [pc, -r2, lsl #22]!
    2580:	0b030000 	bleq	c2588 <__bss_end+0xb95bc>
    2584:	00002279 	andeq	r2, r0, r9, ror r2
    2588:	253a0b04 	ldrcs	r0, [sl, #-2820]!	; 0xfffff4fc
    258c:	0b050000 	bleq	142594 <__bss_end+0x1395c8>
    2590:	00001a5c 	andeq	r1, r0, ip, asr sl
    2594:	1a3e0b06 	bne	f851b4 <__bss_end+0xf7c1e8>
    2598:	0b070000 	bleq	1c25a0 <__bss_end+0x1b95d4>
    259c:	00001c57 	andeq	r1, r0, r7, asr ip
    25a0:	21350b08 	teqcs	r5, r8, lsl #22
    25a4:	0b090000 	bleq	2425ac <__bss_end+0x2395e0>
    25a8:	00001a63 	andeq	r1, r0, r3, ror #20
    25ac:	213c0b0a 	teqcs	ip, sl, lsl #22
    25b0:	0b0b0000 	bleq	2c25b8 <__bss_end+0x2b95ec>
    25b4:	00001ac8 	andeq	r1, r0, r8, asr #21
    25b8:	1a550b0c 	bne	15451f0 <__bss_end+0x153c224>
    25bc:	0b0d0000 	bleq	3425c4 <__bss_end+0x3395f8>
    25c0:	00002591 	muleq	r0, r1, r5
    25c4:	235e0b0e 	cmpcs	lr, #14336	; 0x3800
    25c8:	000f0000 	andeq	r0, pc, r0
    25cc:	00248904 	eoreq	r8, r4, r4, lsl #18
    25d0:	013f0500 	teqeq	pc, r0, lsl #10
    25d4:	00000432 	andeq	r0, r0, r2, lsr r4
    25d8:	00251d09 	eoreq	r1, r5, r9, lsl #26
    25dc:	0f410500 	svceq	0x00410500
    25e0:	000004a5 	andeq	r0, r0, r5, lsr #9
    25e4:	0025a509 	eoreq	sl, r5, r9, lsl #10
    25e8:	0c4a0500 	cfstr64eq	mvdx0, [sl], {-0}
    25ec:	0000001d 	andeq	r0, r0, sp, lsl r0
    25f0:	0019fd09 	andseq	pc, r9, r9, lsl #26
    25f4:	0c4b0500 	cfstr64eq	mvdx0, [fp], {-0}
    25f8:	0000001d 	andeq	r0, r0, sp, lsl r0
    25fc:	00267e10 	eoreq	r7, r6, r0, lsl lr
    2600:	25b60900 	ldrcs	r0, [r6, #2304]!	; 0x900
    2604:	4c050000 	stcmi	0, cr0, [r5], {-0}
    2608:	0004e614 	andeq	lr, r4, r4, lsl r6
    260c:	d5040500 	strle	r0, [r4, #-1280]	; 0xfffffb00
    2610:	11000004 	tstne	r0, r4
    2614:	001eec09 	andseq	lr, lr, r9, lsl #24
    2618:	0f4e0500 	svceq	0x004e0500
    261c:	000004f9 	strdeq	r0, [r0], -r9
    2620:	04ec0405 	strbteq	r0, [ip], #1029	; 0x405
    2624:	9f120000 	svcls	0x00120000
    2628:	09000024 	stmdbeq	r0, {r2, r5}
    262c:	00002266 	andeq	r2, r0, r6, ror #4
    2630:	100d5205 	andne	r5, sp, r5, lsl #4
    2634:	05000005 	streq	r0, [r0, #-5]
    2638:	0004ff04 	andeq	pc, r4, r4, lsl #30
    263c:	1b741300 	blne	1d07244 <__bss_end+0x1cfe278>
    2640:	05340000 	ldreq	r0, [r4, #-0]!
    2644:	41150167 	tstmi	r5, r7, ror #2
    2648:	14000005 	strne	r0, [r0], #-5
    264c:	0000202b 	andeq	r2, r0, fp, lsr #32
    2650:	0f016905 	svceq	0x00016905
    2654:	000003de 	ldrdeq	r0, [r0], -lr
    2658:	1b581400 	blne	1607660 <__bss_end+0x15fe694>
    265c:	6a050000 	bvs	142664 <__bss_end+0x139698>
    2660:	05461401 	strbeq	r1, [r6, #-1025]	; 0xfffffbff
    2664:	00040000 	andeq	r0, r4, r0
    2668:	0005160e 	andeq	r1, r5, lr, lsl #12
    266c:	00b90c00 	adcseq	r0, r9, r0, lsl #24
    2670:	05560000 	ldrbeq	r0, [r6, #-0]
    2674:	24150000 	ldrcs	r0, [r5], #-0
    2678:	2d000000 	stccs	0, cr0, [r0, #-0]
    267c:	05410c00 	strbeq	r0, [r1, #-3072]	; 0xfffff400
    2680:	05610000 	strbeq	r0, [r1, #-0]!
    2684:	000d0000 	andeq	r0, sp, r0
    2688:	0005560e 	andeq	r5, r5, lr, lsl #12
    268c:	1f5a0f00 	svcne	0x005a0f00
    2690:	6b050000 	blvs	142698 <__bss_end+0x1396cc>
    2694:	05610301 	strbeq	r0, [r1, #-769]!	; 0xfffffcff
    2698:	a00f0000 	andge	r0, pc, r0
    269c:	05000021 	streq	r0, [r0, #-33]	; 0xffffffdf
    26a0:	1d0c016e 	stfnes	f0, [ip, #-440]	; 0xfffffe48
    26a4:	16000000 	strne	r0, [r0], -r0
    26a8:	000024dd 	ldrdeq	r2, [r0], -sp
    26ac:	00930107 	addseq	r0, r3, r7, lsl #2
    26b0:	81050000 	mrshi	r0, (UNDEF: 5)
    26b4:	062a0601 	strteq	r0, [sl], -r1, lsl #12
    26b8:	0b0b0000 	bleq	2c26c0 <__bss_end+0x2b96f4>
    26bc:	00000019 	andeq	r0, r0, r9, lsl r0
    26c0:	0019170b 	andseq	r1, r9, fp, lsl #14
    26c4:	230b0200 	movwcs	r0, #45568	; 0xb200
    26c8:	03000019 	movweq	r0, #25
    26cc:	001d3c0b 	andseq	r3, sp, fp, lsl #24
    26d0:	2f0b0300 	svccs	0x000b0300
    26d4:	04000019 	streq	r0, [r0], #-25	; 0xffffffe7
    26d8:	001e850b 	andseq	r8, lr, fp, lsl #10
    26dc:	6b0b0400 	blvs	2c36e4 <__bss_end+0x2ba718>
    26e0:	0500001f 	streq	r0, [r0, #-31]	; 0xffffffe1
    26e4:	001ec10b 	andseq	ip, lr, fp, lsl #2
    26e8:	ee0b0500 	cfsh32	mvfx0, mvfx11, #0
    26ec:	05000019 	streq	r0, [r0, #-25]	; 0xffffffe7
    26f0:	00193b0b 	andseq	r3, r9, fp, lsl #22
    26f4:	e90b0600 	stmdb	fp, {r9, sl}
    26f8:	06000020 	streq	r0, [r0], -r0, lsr #32
    26fc:	001b4a0b 	andseq	r4, fp, fp, lsl #20
    2700:	f60b0600 			; <UNDEFINED> instruction: 0xf60b0600
    2704:	06000020 	streq	r0, [r0], -r0, lsr #32
    2708:	00255d0b 	eoreq	r5, r5, fp, lsl #26
    270c:	030b0600 	movweq	r0, #46592	; 0xb600
    2710:	06000021 	streq	r0, [r0], -r1, lsr #32
    2714:	0021430b 	eoreq	r4, r1, fp, lsl #6
    2718:	470b0600 	strmi	r0, [fp, -r0, lsl #12]
    271c:	07000019 	smladeq	r0, r9, r0, r0
    2720:	0022490b 	eoreq	r4, r2, fp, lsl #18
    2724:	960b0700 	strls	r0, [fp], -r0, lsl #14
    2728:	07000022 	streq	r0, [r0, -r2, lsr #32]
    272c:	0025980b 	eoreq	r9, r5, fp, lsl #16
    2730:	1d0b0700 	stcne	7, cr0, [fp, #-0]
    2734:	0700001b 	smladeq	r0, fp, r0, r0
    2738:	0023170b 	eoreq	r1, r3, fp, lsl #14
    273c:	c00b0800 	andgt	r0, fp, r0, lsl #16
    2740:	08000018 	stmdaeq	r0, {r3, r4}
    2744:	00256b0b 	eoreq	r6, r5, fp, lsl #22
    2748:	330b0800 	movwcc	r0, #47104	; 0xb800
    274c:	08000023 	stmdaeq	r0, {r0, r1, r5}
    2750:	27d10f00 	ldrbcs	r0, [r1, r0, lsl #30]
    2754:	9f050000 	svcls	0x00050000
    2758:	05801f01 	streq	r1, [r0, #3841]	; 0xf01
    275c:	650f0000 	strvs	r0, [pc, #-0]	; 2764 <shift+0x2764>
    2760:	05000023 	streq	r0, [r0, #-35]	; 0xffffffdd
    2764:	1d0c01a2 	stfnes	f0, [ip, #-648]	; 0xfffffd78
    2768:	0f000000 	svceq	0x00000000
    276c:	00001f78 	andeq	r1, r0, r8, ror pc
    2770:	0c01a505 	cfstr32eq	mvfx10, [r1], {5}
    2774:	0000001d 	andeq	r0, r0, sp, lsl r0
    2778:	00289d0f 	eoreq	r9, r8, pc, lsl #26
    277c:	01a80500 			; <UNDEFINED> instruction: 0x01a80500
    2780:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2784:	1a0d0f00 	bne	34638c <__bss_end+0x33d3c0>
    2788:	ab050000 	blge	142790 <__bss_end+0x1397c4>
    278c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2790:	6f0f0000 	svcvs	0x000f0000
    2794:	05000023 	streq	r0, [r0, #-35]	; 0xffffffdd
    2798:	1d0c01ae 	stfnes	f0, [ip, #-696]	; 0xfffffd48
    279c:	0f000000 	svceq	0x00000000
    27a0:	00002280 	andeq	r2, r0, r0, lsl #5
    27a4:	0c01b105 	stfeqd	f3, [r1], {5}
    27a8:	0000001d 	andeq	r0, r0, sp, lsl r0
    27ac:	00228b0f 	eoreq	r8, r2, pc, lsl #22
    27b0:	01b40500 			; <UNDEFINED> instruction: 0x01b40500
    27b4:	00001d0c 	andeq	r1, r0, ip, lsl #26
    27b8:	23790f00 	cmncs	r9, #0, 30
    27bc:	b7050000 	strlt	r0, [r5, -r0]
    27c0:	001d0c01 	andseq	r0, sp, r1, lsl #24
    27c4:	c50f0000 	strgt	r0, [pc, #-0]	; 27cc <shift+0x27cc>
    27c8:	05000020 	streq	r0, [r0, #-32]	; 0xffffffe0
    27cc:	1d0c01ba 	stfnes	f0, [ip, #-744]	; 0xfffffd18
    27d0:	0f000000 	svceq	0x00000000
    27d4:	000027fc 	strdeq	r2, [r0], -ip
    27d8:	0c01bd05 	stceq	13, cr11, [r1], {5}
    27dc:	0000001d 	andeq	r0, r0, sp, lsl r0
    27e0:	0023830f 	eoreq	r8, r3, pc, lsl #6
    27e4:	01c00500 	biceq	r0, r0, r0, lsl #10
    27e8:	00001d0c 	andeq	r1, r0, ip, lsl #26
    27ec:	28c00f00 	stmiacs	r0, {r8, r9, sl, fp}^
    27f0:	c3050000 	movwgt	r0, #20480	; 0x5000
    27f4:	001d0c01 	andseq	r0, sp, r1, lsl #24
    27f8:	860f0000 	strhi	r0, [pc], -r0
    27fc:	05000027 	streq	r0, [r0, #-39]	; 0xffffffd9
    2800:	1d0c01c6 	stfnes	f0, [ip, #-792]	; 0xfffffce8
    2804:	0f000000 	svceq	0x00000000
    2808:	00002792 	muleq	r0, r2, r7
    280c:	0c01c905 			; <UNDEFINED> instruction: 0x0c01c905
    2810:	0000001d 	andeq	r0, r0, sp, lsl r0
    2814:	00279e0f 	eoreq	r9, r7, pc, lsl #28
    2818:	01cc0500 	biceq	r0, ip, r0, lsl #10
    281c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2820:	27c30f00 	strbcs	r0, [r3, r0, lsl #30]
    2824:	d0050000 	andle	r0, r5, r0
    2828:	001d0c01 	andseq	r0, sp, r1, lsl #24
    282c:	b30f0000 	movwlt	r0, #61440	; 0xf000
    2830:	05000028 	streq	r0, [r0, #-40]	; 0xffffffd8
    2834:	1d0c01d3 	stfnes	f0, [ip, #-844]	; 0xfffffcb4
    2838:	0f000000 	svceq	0x00000000
    283c:	00001a6a 	andeq	r1, r0, sl, ror #20
    2840:	0c01d605 	stceq	6, cr13, [r1], {5}
    2844:	0000001d 	andeq	r0, r0, sp, lsl r0
    2848:	0018510f 	andseq	r5, r8, pc, lsl #2
    284c:	01d90500 	bicseq	r0, r9, r0, lsl #10
    2850:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2854:	1d5c0f00 	ldclne	15, cr0, [ip, #-0]
    2858:	dc050000 	stcle	0, cr0, [r5], {-0}
    285c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2860:	450f0000 	strmi	r0, [pc, #-0]	; 2868 <shift+0x2868>
    2864:	0500001a 	streq	r0, [r0, #-26]	; 0xffffffe6
    2868:	1d0c01df 	stfnes	f0, [ip, #-892]	; 0xfffffc84
    286c:	0f000000 	svceq	0x00000000
    2870:	00002399 	muleq	r0, r9, r3
    2874:	0c01e205 	sfmeq	f6, 1, [r1], {5}
    2878:	0000001d 	andeq	r0, r0, sp, lsl r0
    287c:	001fa10f 	andseq	sl, pc, pc, lsl #2
    2880:	01e50500 	mvneq	r0, r0, lsl #10
    2884:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2888:	21f90f00 	mvnscs	r0, r0, lsl #30
    288c:	e8050000 	stmda	r5, {}	; <UNPREDICTABLE>
    2890:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2894:	b30f0000 	movwlt	r0, #61440	; 0xf000
    2898:	05000026 	streq	r0, [r0, #-38]	; 0xffffffda
    289c:	1d0c01ef 	stfnes	f0, [ip, #-956]	; 0xfffffc44
    28a0:	0f000000 	svceq	0x00000000
    28a4:	0000286b 	andeq	r2, r0, fp, ror #16
    28a8:	0c01f205 	sfmeq	f7, 1, [r1], {5}
    28ac:	0000001d 	andeq	r0, r0, sp, lsl r0
    28b0:	00287b0f 	eoreq	r7, r8, pc, lsl #22
    28b4:	01f50500 	mvnseq	r0, r0, lsl #10
    28b8:	00001d0c 	andeq	r1, r0, ip, lsl #26
    28bc:	1b610f00 	blne	18464c4 <__bss_end+0x183d4f8>
    28c0:	f8050000 			; <UNDEFINED> instruction: 0xf8050000
    28c4:	001d0c01 	andseq	r0, sp, r1, lsl #24
    28c8:	fa0f0000 	blx	3c28d0 <__bss_end+0x3b9904>
    28cc:	05000026 	streq	r0, [r0, #-38]	; 0xffffffda
    28d0:	1d0c01fb 	stfnes	f0, [ip, #-1004]	; 0xfffffc14
    28d4:	0f000000 	svceq	0x00000000
    28d8:	000022ff 	strdeq	r2, [r0], -pc	; <UNPREDICTABLE>
    28dc:	0c01fe05 	stceq	14, cr15, [r1], {5}
    28e0:	0000001d 	andeq	r0, r0, sp, lsl r0
    28e4:	001dd50f 	andseq	sp, sp, pc, lsl #10
    28e8:	02020500 	andeq	r0, r2, #0, 10
    28ec:	00001d0c 	andeq	r1, r0, ip, lsl #26
    28f0:	24ef0f00 	strbtcs	r0, [pc], #3840	; 28f8 <shift+0x28f8>
    28f4:	0a050000 	beq	1428fc <__bss_end+0x139930>
    28f8:	001d0c02 	andseq	r0, sp, r2, lsl #24
    28fc:	c80f0000 	stmdagt	pc, {}	; <UNPREDICTABLE>
    2900:	0500001c 	streq	r0, [r0, #-28]	; 0xffffffe4
    2904:	1d0c020d 	sfmne	f0, 4, [ip, #-52]	; 0xffffffcc
    2908:	0c000000 	stceq	0, cr0, [r0], {-0}
    290c:	0000001d 	andeq	r0, r0, sp, lsl r0
    2910:	000007ef 	andeq	r0, r0, pc, ror #15
    2914:	a10f000d 	tstge	pc, sp
    2918:	0500001e 	streq	r0, [r0, #-30]	; 0xffffffe2
    291c:	e40c03fb 	str	r0, [ip], #-1019	; 0xfffffc05
    2920:	0c000007 	stceq	0, cr0, [r0], {7}
    2924:	000004e6 	andeq	r0, r0, r6, ror #9
    2928:	0000080c 	andeq	r0, r0, ip, lsl #16
    292c:	00002415 	andeq	r2, r0, r5, lsl r4
    2930:	0f000d00 	svceq	0x00000d00
    2934:	000023bc 			; <UNDEFINED> instruction: 0x000023bc
    2938:	14058405 	strne	r8, [r5], #-1029	; 0xfffffbfb
    293c:	000007fc 	strdeq	r0, [r0], -ip
    2940:	001f6316 	andseq	r6, pc, r6, lsl r3	; <UNPREDICTABLE>
    2944:	93010700 	movwls	r0, #5888	; 0x1700
    2948:	05000000 	streq	r0, [r0, #-0]
    294c:	5706058b 	strpl	r0, [r6, -fp, lsl #11]
    2950:	0b000008 	bleq	2978 <shift+0x2978>
    2954:	00001d1e 	andeq	r1, r0, lr, lsl sp
    2958:	216e0b00 	cmncs	lr, r0, lsl #22
    295c:	0b010000 	bleq	42964 <__bss_end+0x39998>
    2960:	000018f6 	strdeq	r1, [r0], -r6
    2964:	282d0b02 	stmdacs	sp!, {r1, r8, r9, fp}
    2968:	0b030000 	bleq	c2970 <__bss_end+0xb99a4>
    296c:	00002436 	andeq	r2, r0, r6, lsr r4
    2970:	24290b04 	strtcs	r0, [r9], #-2820	; 0xfffff4fc
    2974:	0b050000 	bleq	14297c <__bss_end+0x1399b0>
    2978:	000019cd 	andeq	r1, r0, sp, asr #19
    297c:	1d0f0006 	stcne	0, cr0, [pc, #-24]	; 296c <shift+0x296c>
    2980:	05000028 	streq	r0, [r0, #-40]	; 0xffffffd8
    2984:	19150598 	ldmdbne	r5, {r3, r4, r7, r8, sl}
    2988:	0f000008 	svceq	0x00000008
    298c:	0000271f 	andeq	r2, r0, pc, lsl r7
    2990:	11079905 	tstne	r7, r5, lsl #18
    2994:	00000024 	andeq	r0, r0, r4, lsr #32
    2998:	0023a90f 	eoreq	sl, r3, pc, lsl #18
    299c:	07ae0500 	streq	r0, [lr, r0, lsl #10]!
    29a0:	00001d0c 	andeq	r1, r0, ip, lsl #26
    29a4:	26920400 	ldrcs	r0, [r2], r0, lsl #8
    29a8:	7b060000 	blvc	1829b0 <__bss_end+0x1799e4>
    29ac:	00009316 	andeq	r9, r0, r6, lsl r3
    29b0:	087e0e00 	ldmdaeq	lr!, {r9, sl, fp}^
    29b4:	02030000 	andeq	r0, r3, #0
    29b8:	000dba05 	andeq	fp, sp, r5, lsl #20
    29bc:	07080300 	streq	r0, [r8, -r0, lsl #6]
    29c0:	00001cb1 			; <UNDEFINED> instruction: 0x00001cb1
    29c4:	85040403 	strhi	r0, [r4, #-1027]	; 0xfffffbfd
    29c8:	0300001a 	movweq	r0, #26
    29cc:	1a7d0308 	bne	1f435f4 <__bss_end+0x1f3a628>
    29d0:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    29d4:	00239204 	eoreq	r9, r3, r4, lsl #4
    29d8:	03100300 	tsteq	r0, #0, 6
    29dc:	00002444 	andeq	r2, r0, r4, asr #8
    29e0:	00088a0c 	andeq	r8, r8, ip, lsl #20
    29e4:	0008c900 	andeq	ip, r8, r0, lsl #18
    29e8:	00241500 	eoreq	r1, r4, r0, lsl #10
    29ec:	00ff0000 	rscseq	r0, pc, r0
    29f0:	0008b90e 	andeq	fp, r8, lr, lsl #18
    29f4:	22a30f00 	adccs	r0, r3, #0, 30
    29f8:	fc060000 	stc2	0, cr0, [r6], {-0}
    29fc:	08c91601 	stmiaeq	r9, {r0, r9, sl, ip}^
    2a00:	340f0000 	strcc	r0, [pc], #-0	; 2a08 <shift+0x2a08>
    2a04:	0600001a 			; <UNDEFINED> instruction: 0x0600001a
    2a08:	c9160202 	ldmdbgt	r6, {r1, r9}
    2a0c:	04000008 	streq	r0, [r0], #-8
    2a10:	000026c5 	andeq	r2, r0, r5, asr #13
    2a14:	f9102a07 			; <UNDEFINED> instruction: 0xf9102a07
    2a18:	0c000004 	stceq	0, cr0, [r0], {4}
    2a1c:	000008e8 	andeq	r0, r0, r8, ror #17
    2a20:	000008ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    2a24:	7209000d 	andvc	r0, r9, #13
    2a28:	07000003 	streq	r0, [r0, -r3]
    2a2c:	08f4112f 	ldmeq	r4!, {r0, r1, r2, r3, r5, r8, ip}^
    2a30:	37090000 	strcc	r0, [r9, -r0]
    2a34:	07000002 	streq	r0, [r0, -r2]
    2a38:	08f41130 	ldmeq	r4!, {r4, r5, r8, ip}^
    2a3c:	ff170000 			; <UNDEFINED> instruction: 0xff170000
    2a40:	08000008 	stmdaeq	r0, {r3}
    2a44:	050a0933 	streq	r0, [sl, #-2355]	; 0xfffff6cd
    2a48:	008fb903 	addeq	fp, pc, r3, lsl #18
    2a4c:	090b1700 	stmdbeq	fp, {r8, r9, sl, ip}
    2a50:	34080000 	strcc	r0, [r8], #-0
    2a54:	03050a09 	movweq	r0, #23049	; 0x5a09
    2a58:	00008fb9 			; <UNDEFINED> instruction: 0x00008fb9
	...

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	10001101 	andne	r1, r0, r1, lsl #2
   4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
   8:	1b0e0301 	blne	380c14 <__bss_end+0x377c48>
   c:	130e250e 	movwne	r2, #58638	; 0xe50e
  10:	00000005 	andeq	r0, r0, r5
  14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
  18:	030b130e 	movweq	r1, #45838	; 0xb30e
  1c:	110e1b0e 	tstne	lr, lr, lsl #22
  20:	10061201 	andne	r1, r6, r1, lsl #4
  24:	02000017 	andeq	r0, r0, #23
  28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeb9d50>
  30:	13490b39 	movtne	r0, #39737	; 0x9b39
  34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
  38:	24030000 	strcs	r0, [r3], #-0
  3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  40:	000e030b 	andeq	r0, lr, fp, lsl #6
  44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
  48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeb9d70>
  50:	01110b39 	tsteq	r1, r9, lsr fp
  54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
  58:	01194296 			; <UNDEFINED> instruction: 0x01194296
  5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeb9d88>
  68:	13490b39 	movtne	r0, #39737	; 0x9b39
  6c:	00001802 	andeq	r1, r0, r2, lsl #16
  70:	0b002406 	bleq	9090 <__bss_end+0xc4>
  74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  78:	07000008 	streq	r0, [r0, -r8]
  7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe7a8c8>
  84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe39dac>
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
  b4:	3a0e0300 	bcc	380cbc <__bss_end+0x377cf0>
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
  e4:	0b3e0b0b 	bleq	f82d18 <__bss_end+0xf79d4c>
  e8:	00000e03 	andeq	r0, r0, r3, lsl #28
  ec:	03003408 	movweq	r3, #1032	; 0x408
  f0:	3b0b3a0e 	blcc	2ce930 <__bss_end+0x2c5964>
  f4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
  f8:	3c193f13 	ldccc	15, cr3, [r9], {19}
  fc:	09000019 	stmdbeq	r0, {r0, r3, r4}
 100:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 104:	0b3a0e03 	bleq	e83918 <__bss_end+0xe7a94c>
 108:	0b390b3b 	bleq	e42dfc <__bss_end+0xe39e30>
 10c:	01111349 	tsteq	r1, r9, asr #6
 110:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 114:	01194296 			; <UNDEFINED> instruction: 0x01194296
 118:	0a000013 	beq	16c <shift+0x16c>
 11c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeb9e44>
 124:	13490b39 	movtne	r0, #39737	; 0x9b39
 128:	00001802 	andeq	r1, r0, r2, lsl #16
 12c:	0b00240b 	bleq	9160 <__bss_end+0x194>
 130:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 134:	0c000008 	stceq	0, cr0, [r0], {8}
 138:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
 13c:	0b3a0e03 	bleq	e83950 <__bss_end+0xe7a984>
 140:	0b390b3b 	bleq	e42e34 <__bss_end+0xe39e68>
 144:	06120111 			; <UNDEFINED> instruction: 0x06120111
 148:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 14c:	0d000019 	stceq	0, cr0, [r0, #-100]	; 0xffffff9c
 150:	0e030139 	mcreq	1, 0, r0, cr3, cr9, {1}
 154:	0b3b0b3a 	bleq	ec2e44 <__bss_end+0xeb9e78>
 158:	00001301 	andeq	r1, r0, r1, lsl #6
 15c:	3f012e0e 	svccc	0x00012e0e
 160:	3a0e0319 	bcc	380dcc <__bss_end+0x377e00>
 164:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 168:	01193c0b 	tsteq	r9, fp, lsl #24
 16c:	0f000013 	svceq	0x00000013
 170:	13490005 	movtne	r0, #36869	; 0x9005
 174:	2e100000 	cdpcs	0, 1, cr0, cr0, cr0, {0}
 178:	03193f01 	tsteq	r9, #1, 30
 17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c59f0>
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
 1a8:	3b0b3a08 	blcc	2ce9d0 <__bss_end+0x2c5a04>
 1ac:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 1b0:	00180213 	andseq	r0, r8, r3, lsl r2
 1b4:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 1b8:	01111347 	tsteq	r1, r7, asr #6
 1bc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 1c0:	00194297 	mulseq	r9, r7, r2
 1c4:	11010000 	mrsne	r0, (UNDEF: 1)
 1c8:	130e2501 	movwne	r2, #58625	; 0xe501
 1cc:	1b0e030b 	blne	380e00 <__bss_end+0x377e34>
 1d0:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 1d4:	00171006 	andseq	r1, r7, r6
 1d8:	00240200 	eoreq	r0, r4, r0, lsl #4
 1dc:	0b3e0b0b 	bleq	f82e10 <__bss_end+0xf79e44>
 1e0:	00000e03 	andeq	r0, r0, r3, lsl #28
 1e4:	49002603 	stmdbmi	r0, {r0, r1, r9, sl, sp}
 1e8:	04000013 	streq	r0, [r0], #-19	; 0xffffffed
 1ec:	0b0b0024 	bleq	2c0284 <__bss_end+0x2b72b8>
 1f0:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 1f4:	16050000 	strne	r0, [r5], -r0
 1f8:	3a0e0300 	bcc	380e00 <__bss_end+0x377e34>
 1fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 200:	0013490b 	andseq	r4, r3, fp, lsl #18
 204:	00350600 	eorseq	r0, r5, r0, lsl #12
 208:	00001349 	andeq	r1, r0, r9, asr #6
 20c:	03011307 	movweq	r1, #4871	; 0x1307
 210:	3a0b0b0e 	bcc	2c2e50 <__bss_end+0x2b9e84>
 214:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 218:	0013010b 	andseq	r0, r3, fp, lsl #2
 21c:	000d0800 	andeq	r0, sp, r0, lsl #16
 220:	0b3a0803 	bleq	e82234 <__bss_end+0xe79268>
 224:	0b390b3b 	bleq	e42f18 <__bss_end+0xe39f4c>
 228:	0b381349 	bleq	e04f54 <__bss_end+0xdfbf88>
 22c:	04090000 	streq	r0, [r9], #-0
 230:	6d0e0301 	stcvs	3, cr0, [lr, #-4]
 234:	0b0b3e19 	bleq	2cfaa0 <__bss_end+0x2c6ad4>
 238:	3a13490b 	bcc	4d266c <__bss_end+0x4c96a0>
 23c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 240:	0013010b 	andseq	r0, r3, fp, lsl #2
 244:	00280a00 	eoreq	r0, r8, r0, lsl #20
 248:	0b1c0e03 	bleq	703a5c <__bss_end+0x6faa90>
 24c:	340b0000 	strcc	r0, [fp], #-0
 250:	3a0e0300 	bcc	380e58 <__bss_end+0x377e8c>
 254:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 258:	6c13490b 			; <UNDEFINED> instruction: 0x6c13490b
 25c:	00180219 	andseq	r0, r8, r9, lsl r2
 260:	00020c00 	andeq	r0, r2, r0, lsl #24
 264:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
 268:	020d0000 	andeq	r0, sp, #0
 26c:	0b0e0301 	bleq	380e78 <__bss_end+0x377eac>
 270:	3b0b3a0b 	blcc	2ceaa4 <__bss_end+0x2c5ad8>
 274:	010b390b 	tsteq	fp, fp, lsl #18
 278:	0e000013 	mcreq	0, 0, r0, cr0, cr3, {0}
 27c:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 280:	0b3b0b3a 	bleq	ec2f70 <__bss_end+0xeb9fa4>
 284:	13490b39 	movtne	r0, #39737	; 0x9b39
 288:	00000b38 	andeq	r0, r0, r8, lsr fp
 28c:	3f012e0f 	svccc	0x00012e0f
 290:	3a0e0319 	bcc	380efc <__bss_end+0x377f30>
 294:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 298:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 29c:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
 2a0:	10000013 	andne	r0, r0, r3, lsl r0
 2a4:	13490005 	movtne	r0, #36869	; 0x9005
 2a8:	00001934 	andeq	r1, r0, r4, lsr r9
 2ac:	49000511 	stmdbmi	r0, {r0, r4, r8, sl}
 2b0:	12000013 	andne	r0, r0, #19
 2b4:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 2b8:	0b3b0b3a 	bleq	ec2fa8 <__bss_end+0xeb9fdc>
 2bc:	13490b39 	movtne	r0, #39737	; 0x9b39
 2c0:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 2c4:	2e130000 	cdpcs	0, 1, cr0, cr3, cr0, {0}
 2c8:	03193f01 	tsteq	r9, #1, 30
 2cc:	3b0b3a0e 	blcc	2ceb0c <__bss_end+0x2c5b40>
 2d0:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 2d4:	3213490e 	andscc	r4, r3, #229376	; 0x38000
 2d8:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 2dc:	00130113 	andseq	r0, r3, r3, lsl r1
 2e0:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 2e4:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 2e8:	0b3b0b3a 	bleq	ec2fd8 <__bss_end+0xeba00c>
 2ec:	0e6e0b39 	vmoveq.8	d14[5], r0
 2f0:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 2f4:	13011364 	movwne	r1, #4964	; 0x1364
 2f8:	2e150000 	cdpcs	0, 1, cr0, cr5, cr0, {0}
 2fc:	03193f01 	tsteq	r9, #1, 30
 300:	3b0b3a0e 	blcc	2ceb40 <__bss_end+0x2c5b74>
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
 338:	0b3b0b3a 	bleq	ec3028 <__bss_end+0xeba05c>
 33c:	13490b39 	movtne	r0, #39737	; 0x9b39
 340:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 344:	281b0000 	ldmdacs	fp, {}	; <UNPREDICTABLE>
 348:	1c080300 	stcne	3, cr0, [r8], {-0}
 34c:	1c00000b 	stcne	0, cr0, [r0], {11}
 350:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 354:	0b3a0e03 	bleq	e83b68 <__bss_end+0xe7ab9c>
 358:	0b390b3b 	bleq	e4304c <__bss_end+0xe3a080>
 35c:	193c0e6e 	ldmdbne	ip!, {r1, r2, r3, r5, r6, r9, sl, fp}
 360:	13011364 	movwne	r1, #4964	; 0x1364
 364:	2e1d0000 	cdpcs	0, 1, cr0, cr13, cr0, {0}
 368:	03193f01 	tsteq	r9, #1, 30
 36c:	3b0b3a0e 	blcc	2cebac <__bss_end+0x2c5be0>
 370:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 374:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
 378:	01136419 	tsteq	r3, r9, lsl r4
 37c:	1e000013 	mcrne	0, 0, r0, cr0, cr3, {0}
 380:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 384:	0b3b0b3a 	bleq	ec3074 <__bss_end+0xeba0a8>
 388:	13490b39 	movtne	r0, #39737	; 0x9b39
 38c:	0b320b38 	bleq	c83074 <__bss_end+0xc7a0a8>
 390:	151f0000 	ldrne	r0, [pc, #-0]	; 398 <shift+0x398>
 394:	64134901 	ldrvs	r4, [r3], #-2305	; 0xfffff6ff
 398:	00130113 	andseq	r0, r3, r3, lsl r1
 39c:	001f2000 	andseq	r2, pc, r0
 3a0:	1349131d 	movtne	r1, #37661	; 0x931d
 3a4:	10210000 	eorne	r0, r1, r0
 3a8:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 3ac:	22000013 	andcs	r0, r0, #19
 3b0:	0b0b000f 	bleq	2c03f4 <__bss_end+0x2b7428>
 3b4:	39230000 	stmdbcc	r3!, {}	; <UNPREDICTABLE>
 3b8:	3a080301 	bcc	200fc4 <__bss_end+0x1f7ff8>
 3bc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 3c0:	0013010b 	andseq	r0, r3, fp, lsl #2
 3c4:	00342400 	eorseq	r2, r4, r0, lsl #8
 3c8:	0b3a0e03 	bleq	e83bdc <__bss_end+0xe7ac10>
 3cc:	0b390b3b 	bleq	e430c0 <__bss_end+0xe3a0f4>
 3d0:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 3d4:	196c061c 	stmdbne	ip!, {r2, r3, r4, r9, sl}^
 3d8:	34250000 	strtcc	r0, [r5], #-0
 3dc:	3a0e0300 	bcc	380fe4 <__bss_end+0x378018>
 3e0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 3e4:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 3e8:	6c0b1c19 	stcvs	12, cr1, [fp], {25}
 3ec:	26000019 			; <UNDEFINED> instruction: 0x26000019
 3f0:	13470034 	movtne	r0, #28724	; 0x7034
 3f4:	2e270000 	cdpcs	0, 2, cr0, cr7, cr0, {0}
 3f8:	03193f01 	tsteq	r9, #1, 30
 3fc:	3b0b3a0e 	blcc	2cec3c <__bss_end+0x2c5c70>
 400:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 404:	3c0b320e 	sfmcc	f3, 4, [fp], {14}
 408:	00136419 	andseq	r6, r3, r9, lsl r4
 40c:	012e2800 			; <UNDEFINED> instruction: 0x012e2800
 410:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 414:	0b3b0b3a 	bleq	ec3104 <__bss_end+0xeba138>
 418:	13490b39 	movtne	r0, #39737	; 0x9b39
 41c:	06120111 			; <UNDEFINED> instruction: 0x06120111
 420:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 424:	00130119 	andseq	r0, r3, r9, lsl r1
 428:	00052900 	andeq	r2, r5, r0, lsl #18
 42c:	0b3a0e03 	bleq	e83c40 <__bss_end+0xe7ac74>
 430:	0b390b3b 	bleq	e43124 <__bss_end+0xe3a158>
 434:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 438:	342a0000 	strtcc	r0, [sl], #-0
 43c:	3a0e0300 	bcc	381044 <__bss_end+0x378078>
 440:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 444:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 448:	2b000018 	blcs	4b0 <shift+0x4b0>
 44c:	0111010b 	tsteq	r1, fp, lsl #2
 450:	00000612 	andeq	r0, r0, r2, lsl r6
 454:	0300342c 	movweq	r3, #1068	; 0x42c
 458:	3b0b3a08 	blcc	2cec80 <__bss_end+0x2c5cb4>
 45c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 460:	00180213 	andseq	r0, r8, r3, lsl r2
 464:	11010000 	mrsne	r0, (UNDEF: 1)
 468:	130e2501 	movwne	r2, #58625	; 0xe501
 46c:	1b0e030b 	blne	3810a0 <__bss_end+0x3780d4>
 470:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 474:	00171006 	andseq	r1, r7, r6
 478:	00240200 	eoreq	r0, r4, r0, lsl #4
 47c:	0b3e0b0b 	bleq	f830b0 <__bss_end+0xf7a0e4>
 480:	00000e03 	andeq	r0, r0, r3, lsl #28
 484:	49002603 	stmdbmi	r0, {r0, r1, r9, sl, sp}
 488:	04000013 	streq	r0, [r0], #-19	; 0xffffffed
 48c:	0b0b0024 	bleq	2c0524 <__bss_end+0x2b7558>
 490:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 494:	16050000 	strne	r0, [r5], -r0
 498:	3a0e0300 	bcc	3810a0 <__bss_end+0x3780d4>
 49c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4a0:	0013490b 	andseq	r4, r3, fp, lsl #18
 4a4:	01130600 	tsteq	r3, r0, lsl #12
 4a8:	0b0b0e03 	bleq	2c3cbc <__bss_end+0x2bacf0>
 4ac:	0b3b0b3a 	bleq	ec319c <__bss_end+0xeba1d0>
 4b0:	13010b39 	movwne	r0, #6969	; 0x1b39
 4b4:	0d070000 	stceq	0, cr0, [r7, #-0]
 4b8:	3a080300 	bcc	2010c0 <__bss_end+0x1f80f4>
 4bc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4c0:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 4c4:	0800000b 	stmdaeq	r0, {r0, r1, r3}
 4c8:	0e030104 	adfeqs	f0, f3, f4
 4cc:	0b3e196d 	bleq	f86a88 <__bss_end+0xf7dabc>
 4d0:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 4d4:	0b3b0b3a 	bleq	ec31c4 <__bss_end+0xeba1f8>
 4d8:	13010b39 	movwne	r0, #6969	; 0x1b39
 4dc:	28090000 	stmdacs	r9, {}	; <UNPREDICTABLE>
 4e0:	1c080300 	stcne	3, cr0, [r8], {-0}
 4e4:	0a00000b 	beq	518 <shift+0x518>
 4e8:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 4ec:	00000b1c 	andeq	r0, r0, ip, lsl fp
 4f0:	0300340b 	movweq	r3, #1035	; 0x40b
 4f4:	3b0b3a0e 	blcc	2ced34 <__bss_end+0x2c5d68>
 4f8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 4fc:	02196c13 	andseq	r6, r9, #4864	; 0x1300
 500:	0c000018 	stceq	0, cr0, [r0], {24}
 504:	0e030002 	cdpeq	0, 0, cr0, cr3, cr2, {0}
 508:	0000193c 	andeq	r1, r0, ip, lsr r9
 50c:	0301020d 	movweq	r0, #4621	; 0x120d
 510:	3a0b0b0e 	bcc	2c3150 <__bss_end+0x2ba184>
 514:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 518:	0013010b 	andseq	r0, r3, fp, lsl #2
 51c:	000d0e00 	andeq	r0, sp, r0, lsl #28
 520:	0b3a0e03 	bleq	e83d34 <__bss_end+0xe7ad68>
 524:	0b390b3b 	bleq	e43218 <__bss_end+0xe3a24c>
 528:	0b381349 	bleq	e05254 <__bss_end+0xdfc288>
 52c:	2e0f0000 	cdpcs	0, 0, cr0, cr15, cr0, {0}
 530:	03193f01 	tsteq	r9, #1, 30
 534:	3b0b3a0e 	blcc	2ced74 <__bss_end+0x2c5da8>
 538:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 53c:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
 540:	00136419 	andseq	r6, r3, r9, lsl r4
 544:	00051000 	andeq	r1, r5, r0
 548:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
 54c:	05110000 	ldreq	r0, [r1, #-0]
 550:	00134900 	andseq	r4, r3, r0, lsl #18
 554:	000d1200 	andeq	r1, sp, r0, lsl #4
 558:	0b3a0e03 	bleq	e83d6c <__bss_end+0xe7ada0>
 55c:	0b390b3b 	bleq	e43250 <__bss_end+0xe3a284>
 560:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 564:	0000193c 	andeq	r1, r0, ip, lsr r9
 568:	3f012e13 	svccc	0x00012e13
 56c:	3a0e0319 	bcc	3811d8 <__bss_end+0x37820c>
 570:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 574:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 578:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 57c:	01136419 	tsteq	r3, r9, lsl r4
 580:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
 584:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 588:	0b3a0e03 	bleq	e83d9c <__bss_end+0xe7add0>
 58c:	0b390b3b 	bleq	e43280 <__bss_end+0xe3a2b4>
 590:	0b320e6e 	bleq	c83f50 <__bss_end+0xc7af84>
 594:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 598:	00001301 	andeq	r1, r0, r1, lsl #6
 59c:	3f012e15 	svccc	0x00012e15
 5a0:	3a0e0319 	bcc	38120c <__bss_end+0x378240>
 5a4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 5a8:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 5ac:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 5b0:	00136419 	andseq	r6, r3, r9, lsl r4
 5b4:	01011600 	tsteq	r1, r0, lsl #12
 5b8:	13011349 	movwne	r1, #4937	; 0x1349
 5bc:	21170000 	tstcs	r7, r0
 5c0:	2f134900 	svccs	0x00134900
 5c4:	1800000b 	stmdane	r0, {r0, r1, r3}
 5c8:	0b0b000f 	bleq	2c060c <__bss_end+0x2b7640>
 5cc:	00001349 	andeq	r1, r0, r9, asr #6
 5d0:	00002119 	andeq	r2, r0, r9, lsl r1
 5d4:	00341a00 	eorseq	r1, r4, r0, lsl #20
 5d8:	0b3a0e03 	bleq	e83dec <__bss_end+0xe7ae20>
 5dc:	0b390b3b 	bleq	e432d0 <__bss_end+0xe3a304>
 5e0:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 5e4:	0000193c 	andeq	r1, r0, ip, lsr r9
 5e8:	3f012e1b 	svccc	0x00012e1b
 5ec:	3a0e0319 	bcc	381258 <__bss_end+0x37828c>
 5f0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 5f4:	3c0e6e0b 	stccc	14, cr6, [lr], {11}
 5f8:	01136419 	tsteq	r3, r9, lsl r4
 5fc:	1c000013 	stcne	0, cr0, [r0], {19}
 600:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 604:	0b3a0e03 	bleq	e83e18 <__bss_end+0xe7ae4c>
 608:	0b390b3b 	bleq	e432fc <__bss_end+0xe3a330>
 60c:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 610:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 614:	00001301 	andeq	r1, r0, r1, lsl #6
 618:	03000d1d 	movweq	r0, #3357	; 0xd1d
 61c:	3b0b3a0e 	blcc	2cee5c <__bss_end+0x2c5e90>
 620:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 624:	320b3813 	andcc	r3, fp, #1245184	; 0x130000
 628:	1e00000b 	cdpne	0, 0, cr0, cr0, cr11, {0}
 62c:	13490115 	movtne	r0, #37141	; 0x9115
 630:	13011364 	movwne	r1, #4964	; 0x1364
 634:	1f1f0000 	svcne	0x001f0000
 638:	49131d00 	ldmdbmi	r3, {r8, sl, fp, ip}
 63c:	20000013 	andcs	r0, r0, r3, lsl r0
 640:	0b0b0010 	bleq	2c0688 <__bss_end+0x2b76bc>
 644:	00001349 	andeq	r1, r0, r9, asr #6
 648:	0b000f21 	bleq	42d4 <shift+0x42d4>
 64c:	2200000b 	andcs	r0, r0, #11
 650:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 654:	0b3b0b3a 	bleq	ec3344 <__bss_end+0xeba378>
 658:	13490b39 	movtne	r0, #39737	; 0x9b39
 65c:	00001802 	andeq	r1, r0, r2, lsl #16
 660:	3f012e23 	svccc	0x00012e23
 664:	3a0e0319 	bcc	3812d0 <__bss_end+0x378304>
 668:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 66c:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 670:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 674:	96184006 	ldrls	r4, [r8], -r6
 678:	13011942 	movwne	r1, #6466	; 0x1942
 67c:	05240000 	streq	r0, [r4, #-0]!
 680:	3a0e0300 	bcc	381288 <__bss_end+0x3782bc>
 684:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 688:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 68c:	25000018 	strcs	r0, [r0, #-24]	; 0xffffffe8
 690:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 694:	0b3a0e03 	bleq	e83ea8 <__bss_end+0xe7aedc>
 698:	0b390b3b 	bleq	e4338c <__bss_end+0xe3a3c0>
 69c:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 6a0:	06120111 			; <UNDEFINED> instruction: 0x06120111
 6a4:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 6a8:	00130119 	andseq	r0, r3, r9, lsl r1
 6ac:	00342600 	eorseq	r2, r4, r0, lsl #12
 6b0:	0b3a0803 	bleq	e826c4 <__bss_end+0xe796f8>
 6b4:	0b390b3b 	bleq	e433a8 <__bss_end+0xe3a3dc>
 6b8:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 6bc:	2e270000 	cdpcs	0, 2, cr0, cr7, cr0, {0}
 6c0:	03193f01 	tsteq	r9, #1, 30
 6c4:	3b0b3a0e 	blcc	2cef04 <__bss_end+0x2c5f38>
 6c8:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 6cc:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 6d0:	97184006 	ldrls	r4, [r8, -r6]
 6d4:	13011942 	movwne	r1, #6466	; 0x1942
 6d8:	2e280000 	cdpcs	0, 2, cr0, cr8, cr0, {0}
 6dc:	03193f00 	tsteq	r9, #0, 30
 6e0:	3b0b3a0e 	blcc	2cef20 <__bss_end+0x2c5f54>
 6e4:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 6e8:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 6ec:	97184006 	ldrls	r4, [r8, -r6]
 6f0:	00001942 	andeq	r1, r0, r2, asr #18
 6f4:	3f012e29 	svccc	0x00012e29
 6f8:	3a0e0319 	bcc	381364 <__bss_end+0x378398>
 6fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 700:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 704:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 708:	97184006 	ldrls	r4, [r8, -r6]
 70c:	00001942 	andeq	r1, r0, r2, asr #18
 710:	01110100 	tsteq	r1, r0, lsl #2
 714:	0b130e25 	bleq	4c3fb0 <__bss_end+0x4bafe4>
 718:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 71c:	06120111 			; <UNDEFINED> instruction: 0x06120111
 720:	00001710 	andeq	r1, r0, r0, lsl r7
 724:	01013902 	tsteq	r1, r2, lsl #18
 728:	03000013 	movweq	r0, #19
 72c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 730:	0b3b0b3a 	bleq	ec3420 <__bss_end+0xeba454>
 734:	13490b39 	movtne	r0, #39737	; 0x9b39
 738:	0a1c193c 	beq	706c30 <__bss_end+0x6fdc64>
 73c:	3a040000 	bcc	100744 <__bss_end+0xf7778>
 740:	3b0b3a00 	blcc	2cef48 <__bss_end+0x2c5f7c>
 744:	180b390b 	stmdane	fp, {r0, r1, r3, r8, fp, ip, sp}
 748:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
 74c:	13490101 	movtne	r0, #37121	; 0x9101
 750:	00001301 	andeq	r1, r0, r1, lsl #6
 754:	49002106 	stmdbmi	r0, {r1, r2, r8, sp}
 758:	000b2f13 	andeq	r2, fp, r3, lsl pc
 75c:	00260700 	eoreq	r0, r6, r0, lsl #14
 760:	00001349 	andeq	r1, r0, r9, asr #6
 764:	0b002408 	bleq	978c <__bss_end+0x7c0>
 768:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 76c:	0900000e 	stmdbeq	r0, {r1, r2, r3}
 770:	13470034 	movtne	r0, #28724	; 0x7034
 774:	2e0a0000 	cdpcs	0, 0, cr0, cr10, cr0, {0}
 778:	03193f01 	tsteq	r9, #1, 30
 77c:	3b0b3a0e 	blcc	2cefbc <__bss_end+0x2c5ff0>
 780:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 784:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 788:	97184006 	ldrls	r4, [r8, -r6]
 78c:	13011942 	movwne	r1, #6466	; 0x1942
 790:	050b0000 	streq	r0, [fp, #-0]
 794:	3a080300 	bcc	20139c <__bss_end+0x1f83d0>
 798:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 79c:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 7a0:	0c000018 	stceq	0, cr0, [r0], {24}
 7a4:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 7a8:	0b3b0b3a 	bleq	ec3498 <__bss_end+0xeba4cc>
 7ac:	13490b39 	movtne	r0, #39737	; 0x9b39
 7b0:	00001802 	andeq	r1, r0, r2, lsl #16
 7b4:	11010b0d 	tstne	r1, sp, lsl #22
 7b8:	00061201 	andeq	r1, r6, r1, lsl #4
 7bc:	00340e00 	eorseq	r0, r4, r0, lsl #28
 7c0:	0b3a0803 	bleq	e827d4 <__bss_end+0xe79808>
 7c4:	0b390b3b 	bleq	e434b8 <__bss_end+0xe3a4ec>
 7c8:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 7cc:	0f0f0000 	svceq	0x000f0000
 7d0:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 7d4:	10000013 	andne	r0, r0, r3, lsl r0
 7d8:	00000026 	andeq	r0, r0, r6, lsr #32
 7dc:	0b000f11 	bleq	4428 <shift+0x4428>
 7e0:	1200000b 	andne	r0, r0, #11
 7e4:	0b0b0024 	bleq	2c087c <__bss_end+0x2b78b0>
 7e8:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 7ec:	05130000 	ldreq	r0, [r3, #-0]
 7f0:	3a0e0300 	bcc	3813f8 <__bss_end+0x37842c>
 7f4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 7f8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 7fc:	14000018 	strne	r0, [r0], #-24	; 0xffffffe8
 800:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 804:	0b3a0e03 	bleq	e84018 <__bss_end+0xe7b04c>
 808:	0b390b3b 	bleq	e434fc <__bss_end+0xe3a530>
 80c:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 810:	06120111 			; <UNDEFINED> instruction: 0x06120111
 814:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 818:	00130119 	andseq	r0, r3, r9, lsl r1
 81c:	012e1500 			; <UNDEFINED> instruction: 0x012e1500
 820:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 824:	0b3b0b3a 	bleq	ec3514 <__bss_end+0xeba548>
 828:	0e6e0b39 	vmoveq.8	d14[5], r0
 82c:	06120111 			; <UNDEFINED> instruction: 0x06120111
 830:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 834:	00000019 	andeq	r0, r0, r9, lsl r0
 838:	10001101 	andne	r1, r0, r1, lsl #2
 83c:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
 840:	1b0e0301 	blne	38144c <__bss_end+0x378480>
 844:	130e250e 	movwne	r2, #58638	; 0xe50e
 848:	00000005 	andeq	r0, r0, r5
 84c:	10001101 	andne	r1, r0, r1, lsl #2
 850:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
 854:	1b0e0301 	blne	381460 <__bss_end+0x378494>
 858:	130e250e 	movwne	r2, #58638	; 0xe50e
 85c:	00000005 	andeq	r0, r0, r5
 860:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 864:	030b130e 	movweq	r1, #45838	; 0xb30e
 868:	100e1b0e 	andne	r1, lr, lr, lsl #22
 86c:	02000017 	andeq	r0, r0, #23
 870:	0b0b0024 	bleq	2c0908 <__bss_end+0x2b793c>
 874:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 878:	24030000 	strcs	r0, [r3], #-0
 87c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 880:	000e030b 	andeq	r0, lr, fp, lsl #6
 884:	00160400 	andseq	r0, r6, r0, lsl #8
 888:	0b3a0e03 	bleq	e8409c <__bss_end+0xe7b0d0>
 88c:	0b390b3b 	bleq	e43580 <__bss_end+0xe3a5b4>
 890:	00001349 	andeq	r1, r0, r9, asr #6
 894:	0b000f05 	bleq	44b0 <shift+0x44b0>
 898:	0013490b 	andseq	r4, r3, fp, lsl #18
 89c:	01150600 	tsteq	r5, r0, lsl #12
 8a0:	13491927 	movtne	r1, #39207	; 0x9927
 8a4:	00001301 	andeq	r1, r0, r1, lsl #6
 8a8:	49000507 	stmdbmi	r0, {r0, r1, r2, r8, sl}
 8ac:	08000013 	stmdaeq	r0, {r0, r1, r4}
 8b0:	00000026 	andeq	r0, r0, r6, lsr #32
 8b4:	03003409 	movweq	r3, #1033	; 0x409
 8b8:	3b0b3a0e 	blcc	2cf0f8 <__bss_end+0x2c612c>
 8bc:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 8c0:	3c193f13 	ldccc	15, cr3, [r9], {19}
 8c4:	0a000019 	beq	930 <shift+0x930>
 8c8:	0e030104 	adfeqs	f0, f3, f4
 8cc:	0b0b0b3e 	bleq	2c35cc <__bss_end+0x2ba600>
 8d0:	0b3a1349 	bleq	e855fc <__bss_end+0xe7c630>
 8d4:	0b390b3b 	bleq	e435c8 <__bss_end+0xe3a5fc>
 8d8:	00001301 	andeq	r1, r0, r1, lsl #6
 8dc:	0300280b 	movweq	r2, #2059	; 0x80b
 8e0:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 8e4:	01010c00 	tsteq	r1, r0, lsl #24
 8e8:	13011349 	movwne	r1, #4937	; 0x1349
 8ec:	210d0000 	mrscs	r0, (UNDEF: 13)
 8f0:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
 8f4:	13490026 	movtne	r0, #36902	; 0x9026
 8f8:	340f0000 	strcc	r0, [pc], #-0	; 900 <shift+0x900>
 8fc:	3a0e0300 	bcc	381504 <__bss_end+0x378538>
 900:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 904:	3f13490b 	svccc	0x0013490b
 908:	00193c19 	andseq	r3, r9, r9, lsl ip
 90c:	00131000 	andseq	r1, r3, r0
 910:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
 914:	15110000 	ldrne	r0, [r1, #-0]
 918:	00192700 	andseq	r2, r9, r0, lsl #14
 91c:	00171200 	andseq	r1, r7, r0, lsl #4
 920:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
 924:	13130000 	tstne	r3, #0
 928:	0b0e0301 	bleq	381534 <__bss_end+0x378568>
 92c:	3b0b3a0b 	blcc	2cf160 <__bss_end+0x2c6194>
 930:	010b3905 	tsteq	fp, r5, lsl #18
 934:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
 938:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 93c:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 940:	13490b39 	movtne	r0, #39737	; 0x9b39
 944:	00000b38 	andeq	r0, r0, r8, lsr fp
 948:	49002115 	stmdbmi	r0, {r0, r2, r4, r8, sp}
 94c:	000b2f13 	andeq	r2, fp, r3, lsl pc
 950:	01041600 	tsteq	r4, r0, lsl #12
 954:	0b3e0e03 	bleq	f84168 <__bss_end+0xf7b19c>
 958:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 95c:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 960:	13010b39 	movwne	r0, #6969	; 0x1b39
 964:	34170000 	ldrcc	r0, [r7], #-0
 968:	3a134700 	bcc	4d2570 <__bss_end+0x4c95a4>
 96c:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 970:	0018020b 	andseq	r0, r8, fp, lsl #4
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
  74:	00000194 	muleq	r0, r4, r1
	...
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	10ce0002 	sbcne	r0, lr, r2
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	000083cc 	andeq	r8, r0, ip, asr #7
  94:	0000045c 	andeq	r0, r0, ip, asr r4
	...
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	1da90002 	stcne	0, cr0, [r9, #8]!
  a8:	00040000 	andeq	r0, r4, r0
  ac:	00000000 	andeq	r0, r0, r0
  b0:	00008828 	andeq	r8, r0, r8, lsr #16
  b4:	000004b8 			; <UNDEFINED> instruction: 0x000004b8
	...
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	20db0002 	sbcscs	r0, fp, r2
  c8:	00040000 	andeq	r0, r4, r0
  cc:	00000000 	andeq	r0, r0, r0
  d0:	00008ce0 	andeq	r8, r0, r0, ror #25
  d4:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	21010002 	tstcs	r1, r2
  e8:	00040000 	andeq	r0, r4, r0
  ec:	00000000 	andeq	r0, r0, r0
  f0:	00008eec 	andeq	r8, r0, ip, ror #29
  f4:	00000004 	andeq	r0, r0, r4
	...
 100:	00000014 	andeq	r0, r0, r4, lsl r0
 104:	21270002 			; <UNDEFINED> instruction: 0x21270002
 108:	00040000 	andeq	r0, r4, r0
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffff4c <__bss_end+0xffff6f80>
       4:	63732f65 	cmnvs	r3, #404	; 0x194
       8:	6b6e6568 	blvs	1b995b0 <__bss_end+0x1b905e4>
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
      48:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffd21 <__bss_end+0xffff6d55>
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
      84:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffd5d <__bss_end+0xffff6d91>
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
     20c:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffee5 <__bss_end+0xffff6f19>
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
     248:	2b2b4320 	blcs	ad0ed0 <__bss_end+0xac7f04>
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
     2cc:	6a363731 	bvs	d8df98 <__bss_end+0xd84fcc>
     2d0:	732d667a 			; <UNDEFINED> instruction: 0x732d667a
     2d4:	616d2d20 	cmnvs	sp, r0, lsr #26
     2d8:	2d206d72 	stccs	13, cr6, [r0, #-456]!	; 0xfffffe38
     2dc:	6372616d 	cmnvs	r2, #1073741851	; 0x4000001b
     2e0:	72613d68 	rsbvc	r3, r1, #104, 26	; 0x1a00
     2e4:	7a36766d 	bvc	d9dca0 <__bss_end+0xd94cd4>
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
     3d8:	6a457463 	bvs	115d56c <__bss_end+0x11545a0>
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
     410:	6a456e69 	bvs	115bdbc <__bss_end+0x1152df0>
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
     498:	73616600 	cmnvc	r1, #0, 12
     49c:	6e550074 	mrcvs	0, 2, r0, cr5, cr4, {3}
     4a0:	5f70616d 	svcpl	0x0070616d
     4a4:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     4a8:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     4ac:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     4b0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     4b4:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     4b8:	5f4f4950 	svcpl	0x004f4950
     4bc:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     4c0:	3972656c 	ldmdbcc	r2!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     4c4:	5f746547 	svcpl	0x00746547
     4c8:	75706e49 	ldrbvc	r6, [r0, #-3657]!	; 0xfffff1b7
     4cc:	006a4574 	rsbeq	r4, sl, r4, ror r5
     4d0:	32435342 	subcc	r5, r3, #134217729	; 0x8000001
     4d4:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     4d8:	506d0065 	rsbpl	r0, sp, r5, rrx
     4dc:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     4e0:	4c5f7373 	mrrcmi	3, 7, r7, pc, cr3	; <UNPREDICTABLE>
     4e4:	5f747369 	svcpl	0x00747369
     4e8:	64616548 	strbtvs	r6, [r1], #-1352	; 0xfffffab8
     4ec:	74655300 	strbtvc	r5, [r5], #-768	; 0xfffffd00
     4f0:	4950475f 	ldmdbmi	r0, {r0, r1, r2, r3, r4, r6, r8, r9, sl, lr}^
     4f4:	75465f4f 	strbvc	r5, [r6, #-3919]	; 0xfffff0b1
     4f8:	6974636e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
     4fc:	5f006e6f 	svcpl	0x00006e6f
     500:	314b4e5a 	cmpcc	fp, sl, asr lr
     504:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     508:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     50c:	614d5f73 	hvcvs	54771	; 0xd5f3
     510:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     514:	47393172 			; <UNDEFINED> instruction: 0x47393172
     518:	435f7465 	cmpmi	pc, #1694498816	; 0x65000000
     51c:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     520:	505f746e 	subspl	r7, pc, lr, ror #8
     524:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     528:	76457373 			; <UNDEFINED> instruction: 0x76457373
     52c:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     530:	4550475f 	ldrbmi	r4, [r0, #-1887]	; 0xfffff8a1
     534:	4c5f5344 	mrrcmi	3, 4, r5, pc, cr4	; <UNPREDICTABLE>
     538:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     53c:	006e6f69 	rsbeq	r6, lr, r9, ror #30
     540:	7478656e 	ldrbtvc	r6, [r8], #-1390	; 0xfffffa92
     544:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     548:	6f72505f 	svcvs	0x0072505f
     54c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     550:	5f79425f 	svcpl	0x0079425f
     554:	00444950 	subeq	r4, r4, r0, asr r9
     558:	6e756f6d 	cdpvs	15, 7, cr6, cr5, cr13, {3}
     55c:	696f5074 	stmdbvs	pc!, {r2, r4, r5, r6, ip, lr}^	; <UNPREDICTABLE>
     560:	6900746e 	stmdbvs	r0, {r1, r2, r3, r5, r6, sl, ip, sp, lr}
     564:	72694473 	rsbvc	r4, r9, #1929379840	; 0x73000000
     568:	6f746365 	svcvs	0x00746365
     56c:	4e007972 			; <UNDEFINED> instruction: 0x4e007972
     570:	5f495753 	svcpl	0x00495753
     574:	636f7250 	cmnvs	pc, #80, 4
     578:	5f737365 	svcpl	0x00737365
     57c:	76726553 			; <UNDEFINED> instruction: 0x76726553
     580:	00656369 	rsbeq	r6, r5, r9, ror #6
     584:	69746341 	ldmdbvs	r4!, {r0, r6, r8, r9, sp, lr}^
     588:	505f6576 	subspl	r6, pc, r6, ror r5	; <UNPREDICTABLE>
     58c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     590:	435f7373 	cmpmi	pc, #-872415231	; 0xcc000001
     594:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     598:	69506d00 	ldmdbvs	r0, {r8, sl, fp, sp, lr}^
     59c:	65525f6e 	ldrbvs	r5, [r2, #-3950]	; 0xfffff092
     5a0:	76726573 			; <UNDEFINED> instruction: 0x76726573
     5a4:	6f697461 	svcvs	0x00697461
     5a8:	525f736e 	subspl	r7, pc, #-1207959551	; 0xb8000001
     5ac:	00646165 	rsbeq	r6, r4, r5, ror #2
     5b0:	69615754 	stmdbvs	r1!, {r2, r4, r6, r8, r9, sl, ip, lr}^
     5b4:	676e6974 			; <UNDEFINED> instruction: 0x676e6974
     5b8:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     5bc:	72430065 	subvc	r0, r3, #101	; 0x65
     5c0:	65746165 	ldrbvs	r6, [r4, #-357]!	; 0xfffffe9b
     5c4:	6f72505f 	svcvs	0x0072505f
     5c8:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     5cc:	50476d00 	subpl	r6, r7, r0, lsl #26
     5d0:	70004f49 	andvc	r4, r0, r9, asr #30
     5d4:	6e657261 	cdpvs	2, 6, cr7, cr5, cr1, {3}
     5d8:	614d0074 	hvcvs	53252	; 0xd004
     5dc:	6c694678 	stclvs	6, cr4, [r9], #-480	; 0xfffffe20
     5e0:	6d616e65 	stclvs	14, cr6, [r1, #-404]!	; 0xfffffe6c
     5e4:	6e654c65 	cdpvs	12, 6, cr4, cr5, cr5, {3}
     5e8:	00687467 	rsbeq	r7, r8, r7, ror #8
     5ec:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 538 <shift+0x538>
     5f0:	63732f65 	cmnvs	r3, #404	; 0x194
     5f4:	6b6e6568 	blvs	1b99b9c <__bss_end+0x1b90bd0>
     5f8:	736f2f6a 	cmnvc	pc, #424	; 0x1a8
     5fc:	32323032 	eorscc	r3, r2, #50	; 0x32
     600:	2f70732f 	svccs	0x0070732f
     604:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     608:	2f736563 	svccs	0x00736563
     60c:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     610:	63617073 	cmnvs	r1, #115	; 0x73
     614:	6f632f65 	svcvs	0x00632f65
     618:	65746e75 	ldrbvs	r6, [r4, #-3701]!	; 0xfffff18b
     61c:	61745f72 	cmnvs	r4, r2, ror pc
     620:	6d2f6b73 	fstmdbxvs	pc!, {d6-d62}	;@ Deprecated
     624:	2e6e6961 	vnmulcs.f16	s13, s28, s3	; <UNPREDICTABLE>
     628:	00707063 	rsbseq	r7, r0, r3, rrx
     62c:	5f585541 	svcpl	0x00585541
     630:	65736142 	ldrbvs	r6, [r3, #-322]!	; 0xfffffebe
     634:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     638:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     63c:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     640:	495f7265 	ldmdbmi	pc, {r0, r2, r5, r6, r9, ip, sp, lr}^	; <UNPREDICTABLE>
     644:	006f666e 	rsbeq	r6, pc, lr, ror #12
     648:	6e697073 	mcrvs	0, 3, r7, cr9, cr3, {3}
     64c:	6b636f6c 	blvs	18dc404 <__bss_end+0x18d3438>
     650:	6100745f 	tstvs	r0, pc, asr r4
     654:	6e656373 	mcrvs	3, 3, r6, cr5, cr3, {3}
     658:	676e6964 	strbvs	r6, [lr, -r4, ror #18]!
     65c:	61654400 	cmnvs	r5, r0, lsl #8
     660:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     664:	6e555f65 	cdpvs	15, 5, cr5, cr5, cr5, {3}
     668:	6e616863 	cdpvs	8, 6, cr6, cr1, cr3, {3}
     66c:	00646567 	rsbeq	r6, r4, r7, ror #10
     670:	6f725043 	svcvs	0x00725043
     674:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     678:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     67c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     680:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     684:	46433131 			; <UNDEFINED> instruction: 0x46433131
     688:	73656c69 	cmnvc	r5, #26880	; 0x6900
     68c:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     690:	4534436d 	ldrmi	r4, [r4, #-877]!	; 0xfffffc93
     694:	5a5f0076 	bpl	17c0874 <__bss_end+0x17b78a8>
     698:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     69c:	636f7250 	cmnvs	pc, #80, 4
     6a0:	5f737365 	svcpl	0x00737365
     6a4:	616e614d 	cmnvs	lr, sp, asr #2
     6a8:	31726567 	cmncc	r2, r7, ror #10
     6ac:	74654738 	strbtvc	r4, [r5], #-1848	; 0xfffff8c8
     6b0:	6863535f 	stmdavs	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     6b4:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     6b8:	495f7265 	ldmdbmi	pc, {r0, r2, r5, r6, r9, ip, sp, lr}^	; <UNPREDICTABLE>
     6bc:	456f666e 	strbmi	r6, [pc, #-1646]!	; 56 <shift+0x56>
     6c0:	474e3032 	smlaldxmi	r3, lr, r2, r0
     6c4:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     6c8:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     6cc:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     6d0:	79545f6f 	ldmdbvc	r4, {r0, r1, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     6d4:	76506570 			; <UNDEFINED> instruction: 0x76506570
     6d8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     6dc:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     6e0:	5f4f4950 	svcpl	0x004f4950
     6e4:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     6e8:	3272656c 	rsbscc	r6, r2, #108, 10	; 0x1b000000
     6ec:	656c4330 	strbvs	r4, [ip, #-816]!	; 0xfffffcd0
     6f0:	445f7261 	ldrbmi	r7, [pc], #-609	; 6f8 <shift+0x6f8>
     6f4:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     6f8:	5f646574 	svcpl	0x00646574
     6fc:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     700:	006a4574 	rsbeq	r4, sl, r4, ror r5
     704:	314e5a5f 	cmpcc	lr, pc, asr sl
     708:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     70c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     710:	614d5f73 	hvcvs	54771	; 0xd5f3
     714:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     718:	48313272 	ldmdami	r1!, {r1, r4, r5, r6, r9, ip, sp}
     71c:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     720:	69465f65 	stmdbvs	r6, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     724:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     728:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     72c:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     730:	4e333245 	cdpmi	2, 3, cr3, cr3, cr5, {2}
     734:	5f495753 	svcpl	0x00495753
     738:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     73c:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     740:	535f6d65 	cmppl	pc, #6464	; 0x1940
     744:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     748:	6a6a6563 	bvs	1a99cdc <__bss_end+0x1a90d10>
     74c:	3131526a 	teqcc	r1, sl, ror #4
     750:	49575354 	ldmdbmi	r7, {r2, r4, r6, r8, r9, ip, lr}^
     754:	7365525f 	cmnvc	r5, #-268435451	; 0xf0000005
     758:	00746c75 	rsbseq	r6, r4, r5, ror ip
     75c:	6c6c6146 	stfvse	f6, [ip], #-280	; 0xfffffee8
     760:	5f676e69 	svcpl	0x00676e69
     764:	65676445 	strbvs	r6, [r7, #-1093]!	; 0xfffffbbb
     768:	65706f00 	ldrbvs	r6, [r0, #-3840]!	; 0xfffff100
     76c:	5f64656e 	svcpl	0x0064656e
     770:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     774:	6f4e0073 	svcvs	0x004e0073
     778:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     77c:	006c6c41 	rsbeq	r6, ip, r1, asr #24
     780:	314e5a5f 	cmpcc	lr, pc, asr sl
     784:	50474333 	subpl	r4, r7, r3, lsr r3
     788:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     78c:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     790:	30327265 	eorscc	r7, r2, r5, ror #4
     794:	61736944 	cmnvs	r3, r4, asr #18
     798:	5f656c62 	svcpl	0x00656c62
     79c:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     7a0:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     7a4:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     7a8:	30326a45 	eorscc	r6, r2, r5, asr #20
     7ac:	4950474e 	ldmdbmi	r0, {r1, r2, r3, r6, r8, r9, sl, lr}^
     7b0:	6e495f4f 	cdpvs	15, 4, cr5, cr9, cr15, {2}
     7b4:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     7b8:	5f747075 	svcpl	0x00747075
     7bc:	65707954 	ldrbvs	r7, [r0, #-2388]!	; 0xfffff6ac
     7c0:	50435400 	subpl	r5, r3, r0, lsl #8
     7c4:	6f435f55 	svcvs	0x00435f55
     7c8:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
     7cc:	65440074 	strbvs	r0, [r4, #-116]	; 0xffffff8c
     7d0:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     7d4:	7400656e 	strvc	r6, [r0], #-1390	; 0xfffffa92
     7d8:	30726274 	rsbscc	r6, r2, r4, ror r2
     7dc:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     7e0:	50433631 	subpl	r3, r3, r1, lsr r6
     7e4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     7e8:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 624 <shift+0x624>
     7ec:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     7f0:	34317265 	ldrtcc	r7, [r1], #-613	; 0xfffffd9b
     7f4:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     7f8:	505f7966 	subspl	r7, pc, r6, ror #18
     7fc:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     800:	6a457373 	bvs	115d5d4 <__bss_end+0x1154608>
     804:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     808:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
     80c:	43534200 	cmpmi	r3, #0, 4
     810:	61425f30 	cmpvs	r2, r0, lsr pc
     814:	46006573 			; <UNDEFINED> instruction: 0x46006573
     818:	5f646e69 	svcpl	0x00646e69
     81c:	6c696843 	stclvs	8, cr6, [r9], #-268	; 0xfffffef4
     820:	6f6e0064 	svcvs	0x006e0064
     824:	69666974 	stmdbvs	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     828:	645f6465 	ldrbvs	r6, [pc], #-1125	; 830 <shift+0x830>
     82c:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     830:	00656e69 	rsbeq	r6, r5, r9, ror #28
     834:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     838:	70757272 	rsbsvc	r7, r5, r2, ror r2
     83c:	6f435f74 	svcvs	0x00435f74
     840:	6f72746e 	svcvs	0x0072746e
     844:	72656c6c 	rsbvc	r6, r5, #108, 24	; 0x6c00
     848:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     84c:	5a5f0065 	bpl	17c09e8 <__bss_end+0x17b7a1c>
     850:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     854:	4f495047 	svcmi	0x00495047
     858:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     85c:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     860:	65724638 	ldrbvs	r4, [r2, #-1592]!	; 0xfffff9c8
     864:	69505f65 	ldmdbvs	r0, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     868:	626a456e 	rsbvs	r4, sl, #461373440	; 0x1b800000
     86c:	53420062 	movtpl	r0, #8290	; 0x2062
     870:	425f3143 	subsmi	r3, pc, #-1073741808	; 0xc0000010
     874:	00657361 	rsbeq	r7, r5, r1, ror #6
     878:	5f78614d 	svcpl	0x0078614d
     87c:	636f7250 	cmnvs	pc, #80, 4
     880:	5f737365 	svcpl	0x00737365
     884:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
     888:	465f6465 	ldrbmi	r6, [pc], -r5, ror #8
     88c:	73656c69 	cmnvc	r5, #26880	; 0x6900
     890:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     894:	50433631 	subpl	r3, r3, r1, lsr r6
     898:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     89c:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 6d8 <shift+0x6d8>
     8a0:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     8a4:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     8a8:	616d6e55 	cmnvs	sp, r5, asr lr
     8ac:	69465f70 	stmdbvs	r6, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     8b0:	435f656c 	cmpmi	pc, #108, 10	; 0x1b000000
     8b4:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     8b8:	6a45746e 	bvs	115da78 <__bss_end+0x1154aac>
     8bc:	4e525400 	cdpmi	4, 5, cr5, cr2, cr0, {0}
     8c0:	61425f47 	cmpvs	r2, r7, asr #30
     8c4:	48006573 	stmdami	r0, {r0, r1, r4, r5, r6, r8, sl, sp, lr}
     8c8:	00686769 	rsbeq	r6, r8, r9, ror #14
     8cc:	5f534667 	svcpl	0x00534667
     8d0:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     8d4:	5f737265 	svcpl	0x00737265
     8d8:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
     8dc:	5a5f0074 	bpl	17c0ab4 <__bss_end+0x17b7ae8>
     8e0:	33314b4e 	teqcc	r1, #79872	; 0x13800
     8e4:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     8e8:	61485f4f 	cmpvs	r8, pc, asr #30
     8ec:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     8f0:	47363272 			; <UNDEFINED> instruction: 0x47363272
     8f4:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     8f8:	52495f50 	subpl	r5, r9, #80, 30	; 0x140
     8fc:	65445f51 	strbvs	r5, [r4, #-3921]	; 0xfffff0af
     900:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     904:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     908:	6f697461 	svcvs	0x00697461
     90c:	326a456e 	rsbcc	r4, sl, #461373440	; 0x1b800000
     910:	50474e30 	subpl	r4, r7, r0, lsr lr
     914:	495f4f49 	ldmdbmi	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     918:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     91c:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     920:	7079545f 	rsbsvc	r5, r9, pc, asr r4
     924:	536a5265 	cmnpl	sl, #1342177286	; 0x50000006
     928:	52005f31 	andpl	r5, r0, #49, 30	; 0xc4
     92c:	6e697369 	cdpvs	3, 6, cr7, cr9, cr9, {3}
     930:	64455f67 	strbvs	r5, [r5], #-3943	; 0xfffff099
     934:	6d006567 	cfstr32vs	mvfx6, [r0, #-412]	; 0xfffffe64
     938:	746f6f52 	strbtvc	r6, [pc], #-3922	; 940 <shift+0x940>
     93c:	7379535f 	cmnvc	r9, #2080374785	; 0x7c000001
     940:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     944:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     948:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     94c:	6f72505f 	svcvs	0x0072505f
     950:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     954:	70614d00 	rsbvc	r4, r1, r0, lsl #26
     958:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     95c:	6f545f65 	svcvs	0x00545f65
     960:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     964:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     968:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     96c:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
     970:	4f495047 	svcmi	0x00495047
     974:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     978:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     97c:	65473931 	strbvs	r3, [r7, #-2353]	; 0xfffff6cf
     980:	50475f74 	subpl	r5, r7, r4, ror pc
     984:	4c455346 	mcrrmi	3, 4, r5, r5, cr6
     988:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     98c:	6f697461 	svcvs	0x00697461
     990:	526a456e 	rsbpl	r4, sl, #461373440	; 0x1b800000
     994:	5f30536a 	svcpl	0x0030536a
     998:	69777300 	ldmdbvs	r7!, {r8, r9, ip, sp, lr}^
     99c:	32686374 	rsbcc	r6, r8, #116, 6	; 0xd0000001
     9a0:	6c69665f 	stclvs	6, cr6, [r9], #-380	; 0xfffffe84
     9a4:	6f4e0065 	svcvs	0x004e0065
     9a8:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     9ac:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     9b0:	72446d65 	subvc	r6, r4, #6464	; 0x1940
     9b4:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
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
     9f0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     9f4:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     9f8:	5f4f4950 	svcpl	0x004f4950
     9fc:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     a00:	3172656c 	cmncc	r2, ip, ror #10
     a04:	6e614830 	mcrvs	8, 3, r4, cr1, cr0, {1}
     a08:	5f656c64 	svcpl	0x00656c64
     a0c:	45515249 	ldrbmi	r5, [r1, #-585]	; 0xfffffdb7
     a10:	5a5f0076 	bpl	17c0bf0 <__bss_end+0x17b7c24>
     a14:	4331314e 	teqmi	r1, #-2147483629	; 0x80000013
     a18:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     a1c:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     a20:	30316d65 	eorscc	r6, r1, r5, ror #26
     a24:	74696e49 	strbtvc	r6, [r9], #-3657	; 0xfffff1b7
     a28:	696c6169 	stmdbvs	ip!, {r0, r3, r5, r6, r8, sp, lr}^
     a2c:	7645657a 			; <UNDEFINED> instruction: 0x7645657a
     a30:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     a34:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     a38:	65746365 	ldrbvs	r6, [r4, #-869]!	; 0xfffffc9b
     a3c:	76455f64 	strbvc	r5, [r5], -r4, ror #30
     a40:	5f746e65 	svcpl	0x00746e65
     a44:	006e6950 	rsbeq	r6, lr, r0, asr r9
     a48:	65746e49 	ldrbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     a4c:	70757272 	rsbsvc	r7, r5, r2, ror r2
     a50:	6c626174 	stfvse	f6, [r2], #-464	; 0xfffffe30
     a54:	6c535f65 	mrrcvs	15, 6, r5, r3, cr5
     a58:	00706565 	rsbseq	r6, r0, r5, ror #10
     a5c:	6f6f526d 	svcvs	0x006f526d
     a60:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     a64:	69640076 	stmdbvs	r4!, {r1, r2, r4, r5, r6}^
     a68:	616c7073 	smcvs	50947	; 0xc703
     a6c:	69665f79 	stmdbvs	r6!, {r0, r3, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     a70:	6200656c 	andvs	r6, r0, #108, 10	; 0x1b000000
     a74:	006c6f6f 	rsbeq	r6, ip, pc, ror #30
     a78:	5f746c41 	svcpl	0x00746c41
     a7c:	6c410031 	mcrrvs	0, 3, r0, r1, cr1
     a80:	00325f74 	eorseq	r5, r2, r4, ror pc
     a84:	73614c6d 	cmnvc	r1, #27904	; 0x6d00
     a88:	49505f74 	ldmdbmi	r0, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     a8c:	6c420044 	mcrrvs	0, 4, r0, r2, cr4
     a90:	656b636f 	strbvs	r6, [fp, #-879]!	; 0xfffffc91
     a94:	474e0064 	strbmi	r0, [lr, -r4, rrx]
     a98:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     a9c:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     aa0:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     aa4:	79545f6f 	ldmdbvc	r4, {r0, r1, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     aa8:	41006570 	tstmi	r0, r0, ror r5
     aac:	355f746c 	ldrbcc	r7, [pc, #-1132]	; 648 <shift+0x648>
     ab0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     ab4:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     ab8:	5f4f4950 	svcpl	0x004f4950
     abc:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     ac0:	3172656c 	cmncc	r2, ip, ror #10
     ac4:	74655330 	strbtvc	r5, [r5], #-816	; 0xfffffcd0
     ac8:	74754f5f 	ldrbtvc	r4, [r5], #-3935	; 0xfffff0a1
     acc:	45747570 	ldrbmi	r7, [r4, #-1392]!	; 0xfffffa90
     ad0:	5200626a 	andpl	r6, r0, #-1610612730	; 0xa0000006
     ad4:	616e6e75 	smcvs	59109	; 0xe6e5
     ad8:	00656c62 	rsbeq	r6, r5, r2, ror #24
     adc:	7361544e 	cmnvc	r1, #1308622848	; 0x4e000000
     ae0:	74535f6b 	ldrbvc	r5, [r3], #-3947	; 0xfffff095
     ae4:	00657461 	rsbeq	r7, r5, r1, ror #8
     ae8:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
     aec:	6f635f64 	svcvs	0x00635f64
     af0:	65746e75 	ldrbvs	r6, [r4, #-3701]!	; 0xfffff18b
     af4:	63730072 	cmnvs	r3, #114	; 0x72
     af8:	5f646568 	svcpl	0x00646568
     afc:	74617473 	strbtvc	r7, [r1], #-1139	; 0xfffffb8d
     b00:	705f6369 	subsvc	r6, pc, r9, ror #6
     b04:	726f6972 	rsbvc	r6, pc, #1867776	; 0x1c8000
     b08:	00797469 	rsbseq	r7, r9, r9, ror #8
     b0c:	74696e49 	strbtvc	r6, [r9], #-3657	; 0xfffff1b7
     b10:	696c6169 	stmdbvs	ip!, {r0, r3, r5, r6, r8, sp, lr}^
     b14:	6700657a 	smlsdxvs	r0, sl, r5, r6
     b18:	445f5346 	ldrbmi	r5, [pc], #-838	; b20 <shift+0xb20>
     b1c:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     b20:	65007372 	strvs	r7, [r0, #-882]	; 0xfffffc8e
     b24:	5f746978 	svcpl	0x00746978
     b28:	65646f63 	strbvs	r6, [r4, #-3939]!	; 0xfffff09d
     b2c:	766e4900 	strbtvc	r4, [lr], -r0, lsl #18
     b30:	64696c61 	strbtvs	r6, [r9], #-3169	; 0xfffff39f
     b34:	6e69505f 	mcrvs	0, 3, r5, cr9, cr15, {2}
     b38:	616e4500 	cmnvs	lr, r0, lsl #10
     b3c:	5f656c62 	svcpl	0x00656c62
     b40:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
     b44:	65445f74 	strbvs	r5, [r4, #-3956]	; 0xfffff08c
     b48:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     b4c:	50477300 	subpl	r7, r7, r0, lsl #6
     b50:	6d004f49 	stcvs	15, cr4, [r0, #-292]	; 0xfffffedc
     b54:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     b58:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     b5c:	636e465f 	cmnvs	lr, #99614720	; 0x5f00000
     b60:	72507300 	subsvc	r7, r0, #0, 6
     b64:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     b68:	72674d73 	rsbvc	r4, r7, #7360	; 0x1cc0
     b6c:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     b70:	72445346 	subvc	r5, r4, #402653185	; 0x18000001
     b74:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     b78:	656d614e 	strbvs	r6, [sp, #-334]!	; 0xfffffeb2
     b7c:	676e654c 	strbvs	r6, [lr, -ip, asr #10]!
     b80:	4e006874 	mcrmi	8, 0, r6, cr0, cr4, {3}
     b84:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     b88:	65440079 	strbvs	r0, [r4, #-121]	; 0xffffff87
     b8c:	6c756166 	ldfvse	f6, [r5], #-408	; 0xfffffe68
     b90:	6c435f74 	mcrrvs	15, 7, r5, r3, cr4
     b94:	5f6b636f 	svcpl	0x006b636f
     b98:	65746152 	ldrbvs	r6, [r4, #-338]!	; 0xfffffeae
     b9c:	69615700 	stmdbvs	r1!, {r8, r9, sl, ip, lr}^
     ba0:	6f465f74 	svcvs	0x00465f74
     ba4:	76455f72 			; <UNDEFINED> instruction: 0x76455f72
     ba8:	00746e65 	rsbseq	r6, r4, r5, ror #28
     bac:	4b4e5a5f 	blmi	1397530 <__bss_end+0x138e564>
     bb0:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
     bb4:	5f4f4950 	svcpl	0x004f4950
     bb8:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     bbc:	3172656c 	cmncc	r2, ip, ror #10
     bc0:	74654738 	strbtvc	r4, [r5], #-1848	; 0xfffff8c8
     bc4:	4350475f 	cmpmi	r0, #24903680	; 0x17c0000
     bc8:	4c5f524c 	lfmmi	f5, 2, [pc], {76}	; 0x4c
     bcc:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
     bd0:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
     bd4:	536a526a 	cmnpl	sl, #-1610612730	; 0xa0000006
     bd8:	4c005f30 	stcmi	15, cr5, [r0], {48}	; 0x30
     bdc:	5f6b636f 	svcpl	0x006b636f
     be0:	6f6c6e55 	svcvs	0x006c6e55
     be4:	64656b63 	strbtvs	r6, [r5], #-2915	; 0xfffff49d
     be8:	49504700 	ldmdbmi	r0, {r8, r9, sl, lr}^
     bec:	61425f4f 	cmpvs	r2, pc, asr #30
     bf0:	47006573 	smlsdxmi	r0, r3, r5, r6
     bf4:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     bf8:	52495f50 	subpl	r5, r9, #80, 30	; 0x140
     bfc:	65445f51 	strbvs	r5, [r4, #-3921]	; 0xfffff0af
     c00:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
     c04:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
     c08:	6f697461 	svcvs	0x00697461
     c0c:	6547006e 	strbvs	r0, [r7, #-110]	; 0xffffff92
     c10:	50475f74 	subpl	r5, r7, r4, ror pc
     c14:	5f524c43 	svcpl	0x00524c43
     c18:	61636f4c 	cmnvs	r3, ip, asr #30
     c1c:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     c20:	636f4c00 	cmnvs	pc, #0, 24
     c24:	6f4c5f6b 	svcvs	0x004c5f6b
     c28:	64656b63 	strbtvs	r6, [r5], #-2915	; 0xfffff49d
     c2c:	69506d00 	ldmdbvs	r0, {r8, sl, fp, sp, lr}^
     c30:	65525f6e 	ldrbvs	r5, [r2, #-3950]	; 0xfffff092
     c34:	76726573 			; <UNDEFINED> instruction: 0x76726573
     c38:	6f697461 	svcvs	0x00697461
     c3c:	575f736e 	ldrbpl	r7, [pc, -lr, ror #6]
     c40:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
     c44:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     c48:	4650475f 			; <UNDEFINED> instruction: 0x4650475f
     c4c:	5f4c4553 	svcpl	0x004c4553
     c50:	61636f4c 	cmnvs	r3, ip, asr #30
     c54:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     c58:	74655300 	strbtvc	r5, [r5], #-768	; 0xfffffd00
     c5c:	74754f5f 	ldrbtvc	r4, [r5], #-3935	; 0xfffff0a1
     c60:	00747570 	rsbseq	r7, r4, r0, ror r5
     c64:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
     c68:	6972575f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, ip, lr}^
     c6c:	5a006574 	bpl	1a244 <__bss_end+0x11278>
     c70:	69626d6f 	stmdbvs	r2!, {r0, r1, r2, r3, r5, r6, r8, sl, fp, sp, lr}^
     c74:	5a5f0065 	bpl	17c0e10 <__bss_end+0x17b7e44>
     c78:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     c7c:	4f495047 	svcmi	0x00495047
     c80:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     c84:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     c88:	65533731 	ldrbvs	r3, [r3, #-1841]	; 0xfffff8cf
     c8c:	50475f74 	subpl	r5, r7, r4, ror pc
     c90:	465f4f49 	ldrbmi	r4, [pc], -r9, asr #30
     c94:	74636e75 	strbtvc	r6, [r3], #-3701	; 0xfffff18b
     c98:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
     c9c:	4e34316a 	rsfmisz	f3, f4, #2.0
     ca0:	4f495047 	svcmi	0x00495047
     ca4:	6e75465f 	mrcvs	6, 3, r4, cr5, cr15, {2}
     ca8:	6f697463 	svcvs	0x00697463
     cac:	6547006e 	strbvs	r0, [r7, #-110]	; 0xffffff92
     cb0:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     cb4:	5f646568 	svcpl	0x00646568
     cb8:	6f666e49 	svcvs	0x00666e49
     cbc:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     cc0:	50433631 	subpl	r3, r3, r1, lsr r6
     cc4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     cc8:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; b04 <shift+0xb04>
     ccc:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     cd0:	53387265 	teqpl	r8, #1342177286	; 0x50000006
     cd4:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     cd8:	45656c75 	strbmi	r6, [r5, #-3189]!	; 0xfffff38b
     cdc:	5a5f0076 	bpl	17c0ebc <__bss_end+0x17b7ef0>
     ce0:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     ce4:	636f7250 	cmnvs	pc, #80, 4
     ce8:	5f737365 	svcpl	0x00737365
     cec:	616e614d 	cmnvs	lr, sp, asr #2
     cf0:	31726567 	cmncc	r2, r7, ror #10
     cf4:	70614d39 	rsbvc	r4, r1, r9, lsr sp
     cf8:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     cfc:	6f545f65 	svcvs	0x00545f65
     d00:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     d04:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     d08:	49355045 	ldmdbmi	r5!, {r0, r2, r6, ip, lr}
     d0c:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     d10:	73694400 	cmnvc	r9, #0, 8
     d14:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     d18:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     d1c:	445f746e 	ldrbmi	r7, [pc], #-1134	; d24 <shift+0xd24>
     d20:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     d24:	68630074 	stmdavs	r3!, {r2, r4, r5, r6}^
     d28:	72646c69 	rsbvc	r6, r4, #26880	; 0x6900
     d2c:	4d006e65 	stcmi	14, cr6, [r0, #-404]	; 0xfffffe6c
     d30:	61507861 	cmpvs	r0, r1, ror #16
     d34:	654c6874 	strbvs	r6, [ip, #-2164]	; 0xfffff78c
     d38:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
     d3c:	736e7500 	cmnvc	lr, #0, 10
     d40:	656e6769 	strbvs	r6, [lr, #-1897]!	; 0xfffff897
     d44:	68632064 	stmdavs	r3!, {r2, r5, r6, sp}^
     d48:	5f007261 	svcpl	0x00007261
     d4c:	314b4e5a 	cmpcc	fp, sl, asr lr
     d50:	50474333 	subpl	r4, r7, r3, lsr r3
     d54:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
     d58:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     d5c:	32327265 	eorscc	r7, r2, #1342177286	; 0x50000006
     d60:	5f746547 	svcpl	0x00746547
     d64:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     d68:	64657463 	strbtvs	r7, [r5], #-1123	; 0xfffffb9d
     d6c:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     d70:	505f746e 	subspl	r7, pc, lr, ror #8
     d74:	76456e69 	strbvc	r6, [r5], -r9, ror #28
     d78:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     d7c:	50433631 	subpl	r3, r3, r1, lsr r6
     d80:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     d84:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; bc0 <shift+0xbc0>
     d88:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     d8c:	32317265 	eorscc	r7, r1, #1342177286	; 0x50000006
     d90:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     d94:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     d98:	4644455f 			; <UNDEFINED> instruction: 0x4644455f
     d9c:	43007645 	movwmi	r7, #1605	; 0x645
     da0:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     da4:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     da8:	47006d65 	strmi	r6, [r0, -r5, ror #26]
     dac:	5f4f4950 	svcpl	0x004f4950
     db0:	5f6e6950 	svcpl	0x006e6950
     db4:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
     db8:	68730074 	ldmdavs	r3!, {r2, r4, r5, r6}^
     dbc:	2074726f 	rsbscs	r7, r4, pc, ror #4
     dc0:	00746e69 	rsbseq	r6, r4, r9, ror #28
     dc4:	5f534654 	svcpl	0x00534654
     dc8:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     dcc:	5f007265 	svcpl	0x00007265
     dd0:	33314e5a 	teqcc	r1, #1440	; 0x5a0
     dd4:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
     dd8:	61485f4f 	cmpvs	r8, pc, asr #30
     ddc:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     de0:	45344372 	ldrmi	r4, [r4, #-882]!	; 0xfffffc8e
     de4:	6550006a 	ldrbvs	r0, [r0, #-106]	; 0xffffff96
     de8:	68706972 	ldmdavs	r0!, {r1, r4, r5, r6, r8, fp, sp, lr}^
     dec:	6c617265 	sfmvs	f7, 2, [r1], #-404	; 0xfffffe6c
     df0:	7361425f 	cmnvc	r1, #-268435451	; 0xf0000005
     df4:	526d0065 	rsbpl	r0, sp, #101	; 0x65
     df8:	00746f6f 	rsbseq	r6, r4, pc, ror #30
     dfc:	6c694673 	stclvs	6, cr4, [r9], #-460	; 0xfffffe34
     e00:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     e04:	006d6574 	rsbeq	r6, sp, r4, ror r5
     e08:	636f4c6d 	cmnvs	pc, #27904	; 0x6d00
     e0c:	7552006b 	ldrbvc	r0, [r2, #-107]	; 0xffffff95
     e10:	6e696e6e 	cdpvs	14, 6, cr6, cr9, cr14, {3}
     e14:	5a5f0067 	bpl	17c0fb8 <__bss_end+0x17b7fec>
     e18:	4333314e 	teqmi	r3, #-2147483629	; 0x80000013
     e1c:	4f495047 	svcmi	0x00495047
     e20:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     e24:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     e28:	61573431 	cmpvs	r7, r1, lsr r4
     e2c:	465f7469 	ldrbmi	r7, [pc], -r9, ror #8
     e30:	455f726f 	ldrbmi	r7, [pc, #-623]	; bc9 <shift+0xbc9>
     e34:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     e38:	49355045 	ldmdbmi	r5!, {r0, r2, r6, ip, lr}
     e3c:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     e40:	6975006a 	ldmdbvs	r5!, {r1, r3, r5, r6}^
     e44:	3233746e 	eorscc	r7, r3, #1845493760	; 0x6e000000
     e48:	5200745f 	andpl	r7, r0, #1593835520	; 0x5f000000
     e4c:	72657365 	rsbvc	r7, r5, #-1811939327	; 0x94000001
     e50:	505f6576 	subspl	r6, pc, r6, ror r5	; <UNPREDICTABLE>
     e54:	47006e69 	strmi	r6, [r0, -r9, ror #28]
     e58:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
     e5c:	5f4f4950 	svcpl	0x004f4950
     e60:	636e7546 	cmnvs	lr, #293601280	; 0x11800000
     e64:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     e68:	6d695400 	cfstrdvs	mvd5, [r9, #-0]
     e6c:	425f7265 	subsmi	r7, pc, #1342177286	; 0x50000006
     e70:	00657361 	rsbeq	r7, r5, r1, ror #6
     e74:	7275436d 	rsbsvc	r4, r5, #-1275068415	; 0xb4000001
     e78:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     e7c:	7361545f 	cmnvc	r1, #1593835520	; 0x5f000000
     e80:	6f4e5f6b 	svcvs	0x004e5f6b
     e84:	5f006564 	svcpl	0x00006564
     e88:	31314e5a 	teqcc	r1, sl, asr lr
     e8c:	6c694643 	stclvs	6, cr4, [r9], #-268	; 0xfffffef4
     e90:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     e94:	346d6574 	strbtcc	r6, [sp], #-1396	; 0xfffffa8c
     e98:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
     e9c:	634b5045 	movtvs	r5, #45125	; 0xb045
     ea0:	464e3531 			; <UNDEFINED> instruction: 0x464e3531
     ea4:	5f656c69 	svcpl	0x00656c69
     ea8:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
     eac:	646f4d5f 	strbtvs	r4, [pc], #-3423	; eb4 <shift+0xeb4>
     eb0:	65470065 	strbvs	r0, [r7, #-101]	; 0xffffff9b
     eb4:	50475f74 	subpl	r5, r7, r4, ror pc
     eb8:	5f544553 	svcpl	0x00544553
     ebc:	61636f4c 	cmnvs	r3, ip, asr #30
     ec0:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     ec4:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     ec8:	4333314b 	teqmi	r3, #-1073741806	; 0xc0000012
     ecc:	4f495047 	svcmi	0x00495047
     ed0:	6e61485f 	mcrvs	8, 3, r4, cr1, cr15, {2}
     ed4:	72656c64 	rsbvc	r6, r5, #100, 24	; 0x6400
     ed8:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
     edc:	50475f74 	subpl	r5, r7, r4, ror pc
     ee0:	5f56454c 	svcpl	0x0056454c
     ee4:	61636f4c 	cmnvs	r3, ip, asr #30
     ee8:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     eec:	6a526a45 	bvs	149b808 <__bss_end+0x149283c>
     ef0:	005f3053 	subseq	r3, pc, r3, asr r0	; <UNPREDICTABLE>
     ef4:	6961576d 	stmdbvs	r1!, {r0, r2, r3, r5, r6, r8, r9, sl, ip, lr}^
     ef8:	676e6974 			; <UNDEFINED> instruction: 0x676e6974
     efc:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     f00:	64007365 	strvs	r7, [r0], #-869	; 0xfffffc9b
     f04:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     f08:	64695f72 	strbtvs	r5, [r9], #-3954	; 0xfffff08e
     f0c:	65520078 	ldrbvs	r0, [r2, #-120]	; 0xffffff88
     f10:	4f5f6461 	svcmi	0x005f6461
     f14:	00796c6e 	rsbseq	r6, r9, lr, ror #24
     f18:	65656c73 	strbvs	r6, [r5, #-3187]!	; 0xfffff38d
     f1c:	69745f70 	ldmdbvs	r4!, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     f20:	0072656d 	rsbseq	r6, r2, sp, ror #10
     f24:	4b4e5a5f 	blmi	13978a8 <__bss_end+0x138e8dc>
     f28:	50433631 	subpl	r3, r3, r1, lsr r6
     f2c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     f30:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; d6c <shift+0xd6c>
     f34:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     f38:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     f3c:	5f746547 	svcpl	0x00746547
     f40:	636f7250 	cmnvs	pc, #80, 4
     f44:	5f737365 	svcpl	0x00737365
     f48:	505f7942 	subspl	r7, pc, r2, asr #18
     f4c:	6a454449 	bvs	1152078 <__bss_end+0x11490ac>
     f50:	6e614800 	cdpvs	8, 6, cr4, cr1, cr0, {0}
     f54:	5f656c64 	svcpl	0x00656c64
     f58:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     f5c:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     f60:	535f6d65 	cmppl	pc, #6464	; 0x1940
     f64:	5f004957 	svcpl	0x00004957
     f68:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     f6c:	6f725043 	svcvs	0x00725043
     f70:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     f74:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     f78:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     f7c:	63533131 	cmpvs	r3, #1073741836	; 0x4000000c
     f80:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     f84:	525f656c 	subspl	r6, pc, #108, 10	; 0x1b000000
     f88:	00764552 	rsbseq	r4, r6, r2, asr r5
     f8c:	6b736174 	blvs	1cd9564 <__bss_end+0x1cd0598>
     f90:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     f94:	706e495f 	rsbvc	r4, lr, pc, asr r9
     f98:	4e007475 	mcrmi	4, 0, r7, cr0, cr5, {3}
     f9c:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     fa0:	72505f79 	subsvc	r5, r0, #484	; 0x1e4
     fa4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     fa8:	63530073 	cmpvs	r3, #115	; 0x73
     fac:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     fb0:	5f00656c 	svcpl	0x0000656c
     fb4:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     fb8:	6f725043 	svcvs	0x00725043
     fbc:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     fc0:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     fc4:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     fc8:	6c423132 	stfvse	f3, [r2], {50}	; 0x32
     fcc:	5f6b636f 	svcpl	0x006b636f
     fd0:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     fd4:	5f746e65 	svcpl	0x00746e65
     fd8:	636f7250 	cmnvs	pc, #80, 4
     fdc:	45737365 	ldrbmi	r7, [r3, #-869]!	; 0xfffffc9b
     fe0:	5a5f0076 	bpl	17c11c0 <__bss_end+0x17b81f4>
     fe4:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     fe8:	636f7250 	cmnvs	pc, #80, 4
     fec:	5f737365 	svcpl	0x00737365
     ff0:	616e614d 	cmnvs	lr, sp, asr #2
     ff4:	39726567 	ldmdbcc	r2!, {r0, r1, r2, r5, r6, r8, sl, sp, lr}^
     ff8:	74697753 	strbtvc	r7, [r9], #-1875	; 0xfffff8ad
     ffc:	545f6863 	ldrbpl	r6, [pc], #-2147	; 1004 <shift+0x1004>
    1000:	3150456f 	cmpcc	r0, pc, ror #10
    1004:	72504338 	subsvc	r4, r0, #56, 6	; 0xe0000000
    1008:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
    100c:	694c5f73 	stmdbvs	ip, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1010:	4e5f7473 	mrcmi	4, 2, r7, cr15, cr3, {3}
    1014:	0065646f 	rsbeq	r6, r5, pc, ror #8
    1018:	4b4e5a5f 	blmi	139799c <__bss_end+0x138e9d0>
    101c:	47433331 	smlaldxmi	r3, r3, r1, r3	; <UNPREDICTABLE>
    1020:	5f4f4950 	svcpl	0x004f4950
    1024:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
    1028:	3172656c 	cmncc	r2, ip, ror #10
    102c:	74654738 	strbtvc	r4, [r5], #-1848	; 0xfffff8c8
    1030:	4550475f 	ldrbmi	r4, [r0, #-1887]	; 0xfffff8a1
    1034:	4c5f5344 	mrrcmi	3, 4, r5, pc, cr4	; <UNPREDICTABLE>
    1038:	7461636f 	strbtvc	r6, [r1], #-879	; 0xfffffc91
    103c:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
    1040:	536a526a 	cmnpl	sl, #-1610612730	; 0xa0000006
    1044:	53005f30 	movwpl	r5, #3888	; 0xf30
    1048:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    104c:	5f656c75 	svcpl	0x00656c75
    1050:	47005252 	smlsdmi	r0, r2, r2, r5
    1054:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
    1058:	56454c50 			; <UNDEFINED> instruction: 0x56454c50
    105c:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
    1060:	6f697461 	svcvs	0x00697461
    1064:	5a5f006e 	bpl	17c1224 <__bss_end+0x17b8258>
    1068:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
    106c:	636f7250 	cmnvs	pc, #80, 4
    1070:	5f737365 	svcpl	0x00737365
    1074:	616e614d 	cmnvs	lr, sp, asr #2
    1078:	31726567 	cmncc	r2, r7, ror #10
    107c:	6e614838 	mcrvs	8, 3, r4, cr1, cr8, {1}
    1080:	5f656c64 	svcpl	0x00656c64
    1084:	636f7250 	cmnvs	pc, #80, 4
    1088:	5f737365 	svcpl	0x00737365
    108c:	45495753 	strbmi	r5, [r9, #-1875]	; 0xfffff8ad
    1090:	534e3032 	movtpl	r3, #57394	; 0xe032
    1094:	505f4957 	subspl	r4, pc, r7, asr r9	; <UNPREDICTABLE>
    1098:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    109c:	535f7373 	cmppl	pc, #-872415231	; 0xcc000001
    10a0:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
    10a4:	6a6a6563 	bvs	1a9a638 <__bss_end+0x1a9166c>
    10a8:	3131526a 	teqcc	r1, sl, ror #4
    10ac:	49575354 	ldmdbmi	r7, {r2, r4, r6, r8, r9, ip, lr}^
    10b0:	7365525f 	cmnvc	r5, #-268435451	; 0xf0000005
    10b4:	00746c75 	rsbseq	r6, r4, r5, ror ip
    10b8:	76677261 	strbtvc	r7, [r7], -r1, ror #4
    10bc:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    10c0:	50433631 	subpl	r3, r3, r1, lsr r6
    10c4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    10c8:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; f04 <shift+0xf04>
    10cc:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    10d0:	34317265 	ldrtcc	r7, [r1], #-613	; 0xfffffd9b
    10d4:	61657243 	cmnvs	r5, r3, asr #4
    10d8:	505f6574 	subspl	r6, pc, r4, ror r5	; <UNPREDICTABLE>
    10dc:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    10e0:	50457373 	subpl	r7, r5, r3, ror r3
    10e4:	00626a68 	rsbeq	r6, r2, r8, ror #20
    10e8:	74697753 	strbtvc	r7, [r9], #-1875	; 0xfffff8ad
    10ec:	545f6863 	ldrbpl	r6, [pc], #-2147	; 10f4 <shift+0x10f4>
    10f0:	534e006f 	movtpl	r0, #57455	; 0xe06f
    10f4:	465f4957 			; <UNDEFINED> instruction: 0x465f4957
    10f8:	73656c69 	cmnvc	r5, #26880	; 0x6900
    10fc:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
    1100:	65535f6d 	ldrbvs	r5, [r3, #-3949]	; 0xfffff093
    1104:	63697672 	cmnvs	r9, #119537664	; 0x7200000
    1108:	5a5f0065 	bpl	17c12a4 <__bss_end+0x17b82d8>
    110c:	33314b4e 	teqcc	r1, #79872	; 0x13800
    1110:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
    1114:	61485f4f 	cmpvs	r8, pc, asr #30
    1118:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
    111c:	47383172 			; <UNDEFINED> instruction: 0x47383172
    1120:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
    1124:	54455350 	strbpl	r5, [r5], #-848	; 0xfffffcb0
    1128:	636f4c5f 	cmnvs	pc, #24320	; 0x5f00
    112c:	6f697461 	svcvs	0x00697461
    1130:	526a456e 	rsbpl	r4, sl, #461373440	; 0x1b800000
    1134:	5f30536a 	svcpl	0x0030536a
    1138:	656c4300 	strbvs	r4, [ip, #-768]!	; 0xfffffd00
    113c:	445f7261 	ldrbmi	r7, [pc], #-609	; 1144 <shift+0x1144>
    1140:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
    1144:	5f646574 	svcpl	0x00646574
    1148:	6e657645 	cdpvs	6, 6, cr7, cr5, cr5, {2}
    114c:	6e490074 	mcrvs	0, 2, r0, cr9, cr4, {3}
    1150:	696c6176 	stmdbvs	ip!, {r1, r2, r4, r5, r6, r8, sp, lr}^
    1154:	61485f64 	cmpvs	r8, r4, ror #30
    1158:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
    115c:	53465400 	movtpl	r5, #25600	; 0x6400
    1160:	6572545f 	ldrbvs	r5, [r2, #-1119]!	; 0xfffffba1
    1164:	6f4e5f65 	svcvs	0x004e5f65
    1168:	42006564 	andmi	r6, r0, #100, 10	; 0x19000000
    116c:	6b636f6c 	blvs	18dcf24 <__bss_end+0x18d3f58>
    1170:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
    1174:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
    1178:	6f72505f 	svcvs	0x0072505f
    117c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1180:	6e697000 	cdpvs	0, 6, cr7, cr9, cr0, {0}
    1184:	7864695f 	stmdavc	r4!, {r0, r1, r2, r3, r4, r6, r8, fp, sp, lr}^
    1188:	65724600 	ldrbvs	r4, [r2, #-1536]!	; 0xfffffa00
    118c:	69505f65 	ldmdbvs	r0, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
    1190:	5a5f006e 	bpl	17c1350 <__bss_end+0x17b8384>
    1194:	33314b4e 	teqcc	r1, #79872	; 0x13800
    1198:	49504743 	ldmdbmi	r0, {r0, r1, r6, r8, r9, sl, lr}^
    119c:	61485f4f 	cmpvs	r8, pc, asr #30
    11a0:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
    11a4:	47373172 			; <UNDEFINED> instruction: 0x47373172
    11a8:	475f7465 	ldrbmi	r7, [pc, -r5, ror #8]
    11ac:	5f4f4950 	svcpl	0x004f4950
    11b0:	636e7546 	cmnvs	lr, #293601280	; 0x11800000
    11b4:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    11b8:	43006a45 	movwmi	r6, #2629	; 0xa45
    11bc:	65736f6c 	ldrbvs	r6, [r3, #-3948]!	; 0xfffff094
    11c0:	69726400 	ldmdbvs	r2!, {sl, sp, lr}^
    11c4:	00726576 	rsbseq	r6, r2, r6, ror r5
    11c8:	63677261 	cmnvs	r7, #268435462	; 0x10000006
    11cc:	69464900 	stmdbvs	r6, {r8, fp, lr}^
    11d0:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
    11d4:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
    11d8:	6972445f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, sl, lr}^
    11dc:	00726576 	rsbseq	r6, r2, r6, ror r5
    11e0:	74697773 	strbtvc	r7, [r9], #-1907	; 0xfffff88d
    11e4:	5f316863 	svcpl	0x00316863
    11e8:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
    11ec:	50474300 	subpl	r4, r7, r0, lsl #6
    11f0:	485f4f49 	ldmdami	pc, {r0, r3, r6, r8, r9, sl, fp, lr}^	; <UNPREDICTABLE>
    11f4:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
    11f8:	55007265 	strpl	r7, [r0, #-613]	; 0xfffffd9b
    11fc:	6570736e 	ldrbvs	r7, [r0, #-878]!	; 0xfffffc92
    1200:	69666963 	stmdbvs	r6!, {r0, r1, r5, r6, r8, fp, sp, lr}^
    1204:	57006465 	strpl	r6, [r0, -r5, ror #8]
    1208:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
    120c:	6c6e4f5f 	stclvs	15, cr4, [lr], #-380	; 0xfffffe84
    1210:	616d0079 	smcvs	53257	; 0xd009
    1214:	59006e69 	stmdbpl	r0, {r0, r3, r5, r6, r9, sl, fp, sp, lr}
    1218:	646c6569 	strbtvs	r6, [ip], #-1385	; 0xfffffa97
    121c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    1220:	50433631 	subpl	r3, r3, r1, lsr r6
    1224:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1228:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 1064 <shift+0x1064>
    122c:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    1230:	34437265 	strbcc	r7, [r3], #-613	; 0xfffffd9b
    1234:	6d007645 	stcvs	6, cr7, [r0, #-276]	; 0xfffffeec
    1238:	746f6f52 	strbtvc	r6, [pc], #-3922	; 1240 <shift+0x1240>
    123c:	746e4d5f 	strbtvc	r4, [lr], #-3423	; 0xfffff2a1
    1240:	75706300 	ldrbvc	r6, [r0, #-768]!	; 0xfffffd00
    1244:	6e6f635f 	mcrvs	3, 3, r6, cr15, cr15, {2}
    1248:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
    124c:	72655400 	rsbvc	r5, r5, #0, 8
    1250:	616e696d 	cmnvs	lr, sp, ror #18
    1254:	49006574 	stmdbmi	r0, {r2, r4, r5, r6, r8, sl, sp, lr}
    1258:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
    125c:	6e614800 	cdpvs	8, 6, cr4, cr1, cr0, {0}
    1260:	5f656c64 	svcpl	0x00656c64
    1264:	00515249 	subseq	r5, r1, r9, asr #4
    1268:	736f6c63 	cmnvc	pc, #25344	; 0x6300
    126c:	65530065 	ldrbvs	r0, [r3, #-101]	; 0xffffff9b
    1270:	65525f74 	ldrbvs	r5, [r2, #-3956]	; 0xfffff08c
    1274:	6974616c 	ldmdbvs	r4!, {r2, r3, r5, r6, r8, sp, lr}^
    1278:	72006576 	andvc	r6, r0, #494927872	; 0x1d800000
    127c:	61767465 	cmnvs	r6, r5, ror #8
    1280:	636e006c 	cmnvs	lr, #108	; 0x6c
    1284:	70007275 	andvc	r7, r0, r5, ror r2
    1288:	00657069 	rsbeq	r7, r5, r9, rrx
    128c:	756e6472 	strbvc	r6, [lr, #-1138]!	; 0xfffffb8e
    1290:	5a5f006d 	bpl	17c144c <__bss_end+0x17b8480>
    1294:	63733131 	cmnvs	r3, #1073741836	; 0x4000000c
    1298:	5f646568 	svcpl	0x00646568
    129c:	6c656979 			; <UNDEFINED> instruction: 0x6c656979
    12a0:	5f007664 	svcpl	0x00007664
    12a4:	7337315a 	teqvc	r7, #-2147483626	; 0x80000016
    12a8:	745f7465 	ldrbvc	r7, [pc], #-1125	; 12b0 <shift+0x12b0>
    12ac:	5f6b7361 	svcpl	0x006b7361
    12b0:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
    12b4:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
    12b8:	6177006a 	cmnvs	r7, sl, rrx
    12bc:	5f007469 	svcpl	0x00007469
    12c0:	6f6e365a 	svcvs	0x006e365a
    12c4:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
    12c8:	5f006a6a 	svcpl	0x00006a6a
    12cc:	6574395a 	ldrbvs	r3, [r4, #-2394]!	; 0xfffff6a6
    12d0:	6e696d72 	mcrvs	13, 3, r6, cr9, cr2, {3}
    12d4:	69657461 	stmdbvs	r5!, {r0, r5, r6, sl, ip, sp, lr}^
    12d8:	6f682f00 	svcvs	0x00682f00
    12dc:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
    12e0:	6e656863 	cdpvs	8, 6, cr6, cr5, cr3, {3}
    12e4:	6f2f6a6b 	svcvs	0x002f6a6b
    12e8:	32303273 	eorscc	r3, r0, #805306375	; 0x30000007
    12ec:	70732f32 	rsbsvc	r2, r3, r2, lsr pc
    12f0:	756f732f 	strbvc	r7, [pc, #-815]!	; fc9 <shift+0xfc9>
    12f4:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
    12f8:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    12fc:	2f62696c 	svccs	0x0062696c
    1300:	2f637273 	svccs	0x00637273
    1304:	66647473 			; <UNDEFINED> instruction: 0x66647473
    1308:	2e656c69 	cdpcs	12, 6, cr6, cr5, cr9, {3}
    130c:	00707063 	rsbseq	r7, r0, r3, rrx
    1310:	6c696146 	stfvse	f6, [r9], #-280	; 0xfffffee8
    1314:	69786500 	ldmdbvs	r8!, {r8, sl, sp, lr}^
    1318:	646f6374 	strbtvs	r6, [pc], #-884	; 1320 <shift+0x1320>
    131c:	5a5f0065 	bpl	17c14b8 <__bss_end+0x17b84ec>
    1320:	65673432 	strbvs	r3, [r7, #-1074]!	; 0xfffffbce
    1324:	63615f74 	cmnvs	r1, #116, 30	; 0x1d0
    1328:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
    132c:	6f72705f 	svcvs	0x0072705f
    1330:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1334:	756f635f 	strbvc	r6, [pc, #-863]!	; fdd <shift+0xfdd>
    1338:	0076746e 	rsbseq	r7, r6, lr, ror #8
    133c:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
    1340:	69795f64 	ldmdbvs	r9!, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
    1344:	00646c65 	rsbeq	r6, r4, r5, ror #24
    1348:	6b636974 	blvs	18db920 <__bss_end+0x18d2954>
    134c:	756f635f 	strbvc	r6, [pc, #-863]!	; ff5 <shift+0xff5>
    1350:	725f746e 	subsvc	r7, pc, #1845493760	; 0x6e000000
    1354:	69757165 	ldmdbvs	r5!, {r0, r2, r5, r6, r8, ip, sp, lr}^
    1358:	00646572 	rsbeq	r6, r4, r2, ror r5
    135c:	65706950 	ldrbvs	r6, [r0, #-2384]!	; 0xfffff6b0
    1360:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
    1364:	72505f65 	subsvc	r5, r0, #404	; 0x194
    1368:	78696665 	stmdavc	r9!, {r0, r2, r5, r6, r9, sl, sp, lr}^
    136c:	74655300 	strbtvc	r5, [r5], #-768	; 0xfffffd00
    1370:	7261505f 	rsbvc	r5, r1, #95	; 0x5f
    1374:	00736d61 	rsbseq	r6, r3, r1, ror #26
    1378:	34315a5f 	ldrtcc	r5, [r1], #-2655	; 0xfffff5a1
    137c:	5f746567 	svcpl	0x00746567
    1380:	6b636974 	blvs	18db958 <__bss_end+0x18d298c>
    1384:	756f635f 	strbvc	r6, [pc, #-863]!	; 102d <shift+0x102d>
    1388:	0076746e 	rsbseq	r7, r6, lr, ror #8
    138c:	65656c73 	strbvs	r6, [r5, #-3187]!	; 0xfffff38d
    1390:	69440070 	stmdbvs	r4, {r4, r5, r6}^
    1394:	6c626173 	stfvse	f6, [r2], #-460	; 0xfffffe34
    1398:	76455f65 	strbvc	r5, [r5], -r5, ror #30
    139c:	5f746e65 	svcpl	0x00746e65
    13a0:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
    13a4:	6f697463 	svcvs	0x00697463
    13a8:	682f006e 	stmdavs	pc!, {r1, r2, r3, r5, r6}	; <UNPREDICTABLE>
    13ac:	2f656d6f 	svccs	0x00656d6f
    13b0:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
    13b4:	2f6a6b6e 	svccs	0x006a6b6e
    13b8:	3032736f 	eorscc	r7, r2, pc, ror #6
    13bc:	732f3232 			; <UNDEFINED> instruction: 0x732f3232
    13c0:	6f732f70 	svcvs	0x00732f70
    13c4:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    13c8:	75622f73 	strbvc	r2, [r2, #-3955]!	; 0xfffff08d
    13cc:	00646c69 	rsbeq	r6, r4, r9, ror #24
    13d0:	7265706f 	rsbvc	r7, r5, #111	; 0x6f
    13d4:	6f697461 	svcvs	0x00697461
    13d8:	5a5f006e 	bpl	17c1598 <__bss_end+0x17b85cc>
    13dc:	6f6c6335 	svcvs	0x006c6335
    13e0:	006a6573 	rsbeq	r6, sl, r3, ror r5
    13e4:	67365a5f 			; <UNDEFINED> instruction: 0x67365a5f
    13e8:	69707465 	ldmdbvs	r0!, {r0, r2, r5, r6, sl, ip, sp, lr}^
    13ec:	66007664 	strvs	r7, [r0], -r4, ror #12
    13f0:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
    13f4:	746f6e00 	strbtvc	r6, [pc], #-3584	; 13fc <shift+0x13fc>
    13f8:	00796669 	rsbseq	r6, r9, r9, ror #12
    13fc:	6b636974 	blvs	18db9d4 <__bss_end+0x18d2a08>
    1400:	706f0073 	rsbvc	r0, pc, r3, ror r0	; <UNPREDICTABLE>
    1404:	5f006e65 	svcpl	0x00006e65
    1408:	6970345a 	ldmdbvs	r0!, {r1, r3, r4, r6, sl, ip, sp}^
    140c:	4b506570 	blmi	141a9d4 <__bss_end+0x1411a08>
    1410:	4e006a63 	vmlsmi.f32	s12, s0, s7
    1414:	64616544 	strbtvs	r6, [r1], #-1348	; 0xfffffabc
    1418:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
    141c:	6275535f 	rsbsvs	r5, r5, #2080374785	; 0x7c000001
    1420:	76726573 			; <UNDEFINED> instruction: 0x76726573
    1424:	00656369 	rsbeq	r6, r5, r9, ror #6
    1428:	5f746567 	svcpl	0x00746567
    142c:	6b636974 	blvs	18dba04 <__bss_end+0x18d2a38>
    1430:	756f635f 	strbvc	r6, [pc, #-863]!	; 10d9 <shift+0x10d9>
    1434:	7000746e 	andvc	r7, r0, lr, ror #8
    1438:	6d617261 	sfmvs	f7, 2, [r1, #-388]!	; 0xfffffe7c
    143c:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    1440:	74697277 	strbtvc	r7, [r9], #-631	; 0xfffffd89
    1444:	4b506a65 	blmi	141bde0 <__bss_end+0x1412e14>
    1448:	67006a63 	strvs	r6, [r0, -r3, ror #20]
    144c:	745f7465 	ldrbvc	r7, [pc], #-1125	; 1454 <shift+0x1454>
    1450:	5f6b7361 	svcpl	0x006b7361
    1454:	6b636974 	blvs	18dba2c <__bss_end+0x18d2a60>
    1458:	6f745f73 	svcvs	0x00745f73
    145c:	6165645f 	cmnvs	r5, pc, asr r4
    1460:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
    1464:	75620065 	strbvc	r0, [r2, #-101]!	; 0xffffff9b
    1468:	69735f66 	ldmdbvs	r3!, {r1, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
    146c:	7700657a 	smlsdxvc	r0, sl, r5, r6
    1470:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
    1474:	74657300 	strbtvc	r7, [r5], #-768	; 0xfffffd00
    1478:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
    147c:	65645f6b 	strbvs	r5, [r4, #-3947]!	; 0xfffff095
    1480:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
    1484:	4700656e 	strmi	r6, [r0, -lr, ror #10]
    1488:	505f7465 	subspl	r7, pc, r5, ror #8
    148c:	6d617261 	sfmvs	f7, 2, [r1, #-388]!	; 0xfffffe7c
    1490:	5a5f0073 	bpl	17c1664 <__bss_end+0x17b8698>
    1494:	656c7335 	strbvs	r7, [ip, #-821]!	; 0xfffffccb
    1498:	6a6a7065 	bvs	1a9d634 <__bss_end+0x1a94668>
    149c:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
    14a0:	6d65525f 	sfmvs	f5, 2, [r5, #-380]!	; 0xfffffe84
    14a4:	696e6961 	stmdbvs	lr!, {r0, r5, r6, r8, fp, sp, lr}^
    14a8:	4500676e 	strmi	r6, [r0, #-1902]	; 0xfffff892
    14ac:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
    14b0:	76455f65 	strbvc	r5, [r5], -r5, ror #30
    14b4:	5f746e65 	svcpl	0x00746e65
    14b8:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
    14bc:	6f697463 	svcvs	0x00697463
    14c0:	5a5f006e 	bpl	17c1680 <__bss_end+0x17b86b4>
    14c4:	65673632 	strbvs	r3, [r7, #-1586]!	; 0xfffff9ce
    14c8:	61745f74 	cmnvs	r4, r4, ror pc
    14cc:	745f6b73 	ldrbvc	r6, [pc], #-2931	; 14d4 <shift+0x14d4>
    14d0:	736b6369 	cmnvc	fp, #-1543503871	; 0xa4000001
    14d4:	5f6f745f 	svcpl	0x006f745f
    14d8:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
    14dc:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
    14e0:	534e0076 	movtpl	r0, #57462	; 0xe076
    14e4:	525f4957 	subspl	r4, pc, #1425408	; 0x15c000
    14e8:	6c757365 	ldclvs	3, cr7, [r5], #-404	; 0xfffffe6c
    14ec:	6f435f74 	svcvs	0x00435f74
    14f0:	77006564 	strvc	r6, [r0, -r4, ror #10]
    14f4:	6d756e72 	ldclvs	14, cr6, [r5, #-456]!	; 0xfffffe38
    14f8:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    14fc:	74696177 	strbtvc	r6, [r9], #-375	; 0xfffffe89
    1500:	006a6a6a 	rsbeq	r6, sl, sl, ror #20
    1504:	69355a5f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}
    1508:	6c74636f 	ldclvs	3, cr6, [r4], #-444	; 0xfffffe44
    150c:	4e36316a 	rsfmisz	f3, f6, #2.0
    1510:	74434f49 	strbvc	r4, [r3], #-3913	; 0xfffff0b7
    1514:	704f5f6c 	subvc	r5, pc, ip, ror #30
    1518:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
    151c:	506e6f69 	rsbpl	r6, lr, r9, ror #30
    1520:	6f690076 	svcvs	0x00690076
    1524:	006c7463 	rsbeq	r7, ip, r3, ror #8
    1528:	63746572 	cmnvs	r4, #478150656	; 0x1c800000
    152c:	7400746e 	strvc	r7, [r0], #-1134	; 0xfffffb92
    1530:	696d7265 	stmdbvs	sp!, {r0, r2, r5, r6, r9, ip, sp, lr}^
    1534:	6574616e 	ldrbvs	r6, [r4, #-366]!	; 0xfffffe92
    1538:	646f6d00 	strbtvs	r6, [pc], #-3328	; 1540 <shift+0x1540>
    153c:	75620065 	strbvc	r0, [r2, #-101]!	; 0xffffff9b
    1540:	72656666 	rsbvc	r6, r5, #106954752	; 0x6600000
    1544:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    1548:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
    154c:	6a63506a 	bvs	18d56fc <__bss_end+0x18cc730>
    1550:	4f494e00 	svcmi	0x00494e00
    1554:	5f6c7443 	svcpl	0x006c7443
    1558:	7265704f 	rsbvc	r7, r5, #79	; 0x4f
    155c:	6f697461 	svcvs	0x00697461
    1560:	6572006e 	ldrbvs	r0, [r2, #-110]!	; 0xffffff92
    1564:	646f6374 	strbtvs	r6, [pc], #-884	; 156c <shift+0x156c>
    1568:	65670065 	strbvs	r0, [r7, #-101]!	; 0xffffff9b
    156c:	63615f74 	cmnvs	r1, #116, 30	; 0x1d0
    1570:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
    1574:	6f72705f 	svcvs	0x0072705f
    1578:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    157c:	756f635f 	strbvc	r6, [pc, #-863]!	; 1225 <shift+0x1225>
    1580:	6600746e 	strvs	r7, [r0], -lr, ror #8
    1584:	6e656c69 	cdpvs	12, 6, cr6, cr5, cr9, {3}
    1588:	00656d61 	rsbeq	r6, r5, r1, ror #26
    158c:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
    1590:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
    1594:	00646970 	rsbeq	r6, r4, r0, ror r9
    1598:	6f345a5f 	svcvs	0x00345a5f
    159c:	506e6570 	rsbpl	r6, lr, r0, ror r5
    15a0:	3531634b 	ldrcc	r6, [r1, #-843]!	; 0xfffffcb5
    15a4:	6c69464e 	stclvs	6, cr4, [r9], #-312	; 0xfffffec8
    15a8:	704f5f65 	subvc	r5, pc, r5, ror #30
    15ac:	4d5f6e65 	ldclmi	14, cr6, [pc, #-404]	; 1420 <shift+0x1420>
    15b0:	0065646f 	rsbeq	r6, r5, pc, ror #8
    15b4:	20554e47 	subscs	r4, r5, r7, asr #28
    15b8:	312b2b43 			; <UNDEFINED> instruction: 0x312b2b43
    15bc:	2e392034 	mrccs	0, 1, r2, cr9, cr4, {1}
    15c0:	20312e32 	eorscs	r2, r1, r2, lsr lr
    15c4:	39313032 	ldmdbcc	r1!, {r1, r4, r5, ip, sp}
    15c8:	35323031 	ldrcc	r3, [r2, #-49]!	; 0xffffffcf
    15cc:	65722820 	ldrbvs	r2, [r2, #-2080]!	; 0xfffff7e0
    15d0:	7361656c 	cmnvc	r1, #108, 10	; 0x1b000000
    15d4:	5b202965 	blpl	80bb70 <__bss_end+0x802ba4>
    15d8:	2f4d5241 	svccs	0x004d5241
    15dc:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    15e0:	72622d39 	rsbvc	r2, r2, #3648	; 0xe40
    15e4:	68636e61 	stmdavs	r3!, {r0, r5, r6, r9, sl, fp, sp, lr}^
    15e8:	76657220 	strbtvc	r7, [r5], -r0, lsr #4
    15ec:	6f697369 	svcvs	0x00697369
    15f0:	3732206e 	ldrcc	r2, [r2, -lr, rrx]!
    15f4:	39393537 	ldmdbcc	r9!, {r0, r1, r2, r4, r5, r8, sl, ip, sp}
    15f8:	6d2d205d 	stcvs	0, cr2, [sp, #-372]!	; 0xfffffe8c
    15fc:	616f6c66 	cmnvs	pc, r6, ror #24
    1600:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
    1604:	61683d69 	cmnvs	r8, r9, ror #26
    1608:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
    160c:	7570666d 	ldrbvc	r6, [r0, #-1645]!	; 0xfffff993
    1610:	7066763d 	rsbvc	r7, r6, sp, lsr r6
    1614:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    1618:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    161c:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
    1620:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
    1624:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
    1628:	3d757066 	ldclcc	0, cr7, [r5, #-408]!	; 0xfffffe68
    162c:	20706676 	rsbscs	r6, r0, r6, ror r6
    1630:	75746d2d 	ldrbvc	r6, [r4, #-3373]!	; 0xfffff2d3
    1634:	613d656e 	teqvs	sp, lr, ror #10
    1638:	31316d72 	teqcc	r1, r2, ror sp
    163c:	7a6a3637 	bvc	1a8ef20 <__bss_end+0x1a85f54>
    1640:	20732d66 	rsbscs	r2, r3, r6, ror #26
    1644:	72616d2d 	rsbvc	r6, r1, #2880	; 0xb40
    1648:	6d2d206d 	stcvs	0, cr2, [sp, #-436]!	; 0xfffffe4c
    164c:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1650:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
    1654:	6b7a3676 	blvs	1e8f034 <__bss_end+0x1e86068>
    1658:	2070662b 	rsbscs	r6, r0, fp, lsr #12
    165c:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    1660:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    1664:	304f2d20 	subcc	r2, pc, r0, lsr #26
    1668:	304f2d20 	subcc	r2, pc, r0, lsr #26
    166c:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
    1670:	78652d6f 	stmdavc	r5!, {r0, r1, r2, r3, r5, r6, r8, sl, fp, sp}^
    1674:	74706563 	ldrbtvc	r6, [r0], #-1379	; 0xfffffa9d
    1678:	736e6f69 	cmnvc	lr, #420	; 0x1a4
    167c:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
    1680:	74722d6f 	ldrbtvc	r2, [r2], #-3439	; 0xfffff291
    1684:	69006974 	stmdbvs	r0, {r2, r4, r5, r6, r8, fp, sp, lr}
    1688:	7475706e 	ldrbtvc	r7, [r5], #-110	; 0xffffff92
    168c:	73656400 	cmnvc	r5, #0, 8
    1690:	7a620074 	bvc	1881868 <__bss_end+0x187889c>
    1694:	006f7265 	rsbeq	r7, pc, r5, ror #4
    1698:	676e656c 	strbvs	r6, [lr, -ip, ror #10]!
    169c:	5f006874 	svcpl	0x00006874
    16a0:	7a62355a 	bvc	188ec10 <__bss_end+0x1885c44>
    16a4:	506f7265 	rsbpl	r7, pc, r5, ror #4
    16a8:	5f006976 	svcpl	0x00006976
    16ac:	7461345a 	strbtvc	r3, [r1], #-1114	; 0xfffffba6
    16b0:	4b50696f 	blmi	141bc74 <__bss_end+0x1412ca8>
    16b4:	682f0063 	stmdavs	pc!, {r0, r1, r5, r6}	; <UNPREDICTABLE>
    16b8:	2f656d6f 	svccs	0x00656d6f
    16bc:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
    16c0:	2f6a6b6e 	svccs	0x006a6b6e
    16c4:	3032736f 	eorscc	r7, r2, pc, ror #6
    16c8:	732f3232 			; <UNDEFINED> instruction: 0x732f3232
    16cc:	6f732f70 	svcvs	0x00732f70
    16d0:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    16d4:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
    16d8:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
    16dc:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
    16e0:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    16e4:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    16e8:	632e676e 			; <UNDEFINED> instruction: 0x632e676e
    16ec:	43007070 	movwmi	r7, #112	; 0x70
    16f0:	43726168 	cmnmi	r2, #104, 2
    16f4:	41766e6f 	cmnmi	r6, pc, ror #28
    16f8:	6d007272 	sfmvs	f7, 4, [r0, #-456]	; 0xfffffe38
    16fc:	73646d65 	cmnvc	r4, #6464	; 0x1940
    1700:	756f0074 	strbvc	r0, [pc, #-116]!	; 1694 <shift+0x1694>
    1704:	74757074 	ldrbtvc	r7, [r5], #-116	; 0xffffff8c
    1708:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
    170c:	636d656d 	cmnvs	sp, #457179136	; 0x1b400000
    1710:	4b507970 	blmi	141fcd8 <__bss_end+0x1416d0c>
    1714:	69765076 	ldmdbvs	r6!, {r1, r2, r4, r5, r6, ip, lr}^
    1718:	73616200 	cmnvc	r1, #0, 4
    171c:	656d0065 	strbvs	r0, [sp, #-101]!	; 0xffffff9b
    1720:	7970636d 	ldmdbvc	r0!, {r0, r2, r3, r5, r6, r8, r9, sp, lr}^
    1724:	72747300 	rsbsvc	r7, r4, #0, 6
    1728:	006e656c 	rsbeq	r6, lr, ip, ror #10
    172c:	73375a5f 	teqvc	r7, #389120	; 0x5f000
    1730:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    1734:	4b50706d 	blmi	141d8f0 <__bss_end+0x1414924>
    1738:	5f305363 	svcpl	0x00305363
    173c:	5a5f0069 	bpl	17c18e8 <__bss_end+0x17b891c>
    1740:	72747336 	rsbsvc	r7, r4, #-671088640	; 0xd8000000
    1744:	506e656c 	rsbpl	r6, lr, ip, ror #10
    1748:	6100634b 	tstvs	r0, fp, asr #6
    174c:	00696f74 	rsbeq	r6, r9, r4, ror pc
    1750:	73375a5f 	teqvc	r7, #389120	; 0x5f000
    1754:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    1758:	63507970 	cmpvs	r0, #112, 18	; 0x1c0000
    175c:	69634b50 	stmdbvs	r3!, {r4, r6, r8, r9, fp, lr}^
    1760:	72747300 	rsbsvc	r7, r4, #0, 6
    1764:	706d636e 	rsbvc	r6, sp, lr, ror #6
    1768:	72747300 	rsbsvc	r7, r4, #0, 6
    176c:	7970636e 	ldmdbvc	r0!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
    1770:	6d656d00 	stclvs	13, cr6, [r5, #-0]
    1774:	0079726f 	rsbseq	r7, r9, pc, ror #4
    1778:	736d656d 	cmnvc	sp, #457179136	; 0x1b400000
    177c:	69006372 	stmdbvs	r0, {r1, r4, r5, r6, r8, r9, sp, lr}
    1780:	00616f74 	rsbeq	r6, r1, r4, ror pc
    1784:	69345a5f 	ldmdbvs	r4!, {r0, r1, r2, r3, r4, r6, r9, fp, ip, lr}
    1788:	6a616f74 	bvs	185d560 <__bss_end+0x1854594>
    178c:	006a6350 	rsbeq	r6, sl, r0, asr r3
    1790:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1794:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1798:	2f2e2e2f 	svccs	0x002e2e2f
    179c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    17a0:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    17a4:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    17a8:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
    17ac:	2f676966 	svccs	0x00676966
    17b0:	2f6d7261 	svccs	0x006d7261
    17b4:	3162696c 	cmncc	r2, ip, ror #18
    17b8:	636e7566 	cmnvs	lr, #427819008	; 0x19800000
    17bc:	00532e73 	subseq	r2, r3, r3, ror lr
    17c0:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
    17c4:	672f646c 	strvs	r6, [pc, -ip, ror #8]!
    17c8:	612d6363 			; <UNDEFINED> instruction: 0x612d6363
    17cc:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
    17d0:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
    17d4:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    17d8:	396c472d 	stmdbcc	ip!, {r0, r2, r3, r5, r8, r9, sl, lr}^
    17dc:	2f39546b 	svccs	0x0039546b
    17e0:	2d636367 	stclcs	3, cr6, [r3, #-412]!	; 0xfffffe64
    17e4:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    17e8:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    17ec:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    17f0:	2d392d69 	ldccs	13, cr2, [r9, #-420]!	; 0xfffffe5c
    17f4:	39313032 	ldmdbcc	r1!, {r1, r4, r5, ip, sp}
    17f8:	2f34712d 	svccs	0x0034712d
    17fc:	6c697562 	cfstr64vs	mvdx7, [r9], #-392	; 0xfffffe78
    1800:	72612f64 	rsbvc	r2, r1, #100, 30	; 0x190
    1804:	6f6e2d6d 	svcvs	0x006e2d6d
    1808:	652d656e 	strvs	r6, [sp, #-1390]!	; 0xfffffa92
    180c:	2f696261 	svccs	0x00696261
    1810:	2f6d7261 	svccs	0x006d7261
    1814:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
    1818:	7261682f 	rsbvc	r6, r1, #3080192	; 0x2f0000
    181c:	696c2f64 	stmdbvs	ip!, {r2, r5, r6, r8, r9, sl, fp, sp}^
    1820:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1824:	52415400 	subpl	r5, r1, #0, 8
    1828:	5f544547 	svcpl	0x00544547
    182c:	5f555043 	svcpl	0x00555043
    1830:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1834:	31617865 	cmncc	r1, r5, ror #16
    1838:	726f6337 	rsbvc	r6, pc, #-603979776	; 0xdc000000
    183c:	61786574 	cmnvs	r8, r4, ror r5
    1840:	73690037 	cmnvc	r9, #55	; 0x37
    1844:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1848:	70665f74 	rsbvc	r5, r6, r4, ror pc
    184c:	6c62645f 	cfstrdvs	mvd6, [r2], #-380	; 0xfffffe84
    1850:	6d726100 	ldfvse	f6, [r2, #-0]
    1854:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1858:	77695f68 	strbvc	r5, [r9, -r8, ror #30]!
    185c:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    1860:	52415400 	subpl	r5, r1, #0, 8
    1864:	5f544547 	svcpl	0x00544547
    1868:	5f555043 	svcpl	0x00555043
    186c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1870:	326d7865 	rsbcc	r7, sp, #6619136	; 0x650000
    1874:	52410033 	subpl	r0, r1, #51	; 0x33
    1878:	51455f4d 	cmppl	r5, sp, asr #30
    187c:	52415400 	subpl	r5, r1, #0, 8
    1880:	5f544547 	svcpl	0x00544547
    1884:	5f555043 	svcpl	0x00555043
    1888:	316d7261 	cmncc	sp, r1, ror #4
    188c:	74363531 	ldrtvc	r3, [r6], #-1329	; 0xfffffacf
    1890:	00736632 	rsbseq	r6, r3, r2, lsr r6
    1894:	5f617369 	svcpl	0x00617369
    1898:	5f746962 	svcpl	0x00746962
    189c:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    18a0:	41540062 	cmpmi	r4, r2, rrx
    18a4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    18a8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    18ac:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    18b0:	61786574 	cmnvs	r8, r4, ror r5
    18b4:	6f633735 	svcvs	0x00633735
    18b8:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    18bc:	00333561 	eorseq	r3, r3, r1, ror #10
    18c0:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    18c4:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    18c8:	4d385f48 	ldcmi	15, cr5, [r8, #-288]!	; 0xfffffee0
    18cc:	5341425f 	movtpl	r4, #4703	; 0x125f
    18d0:	41540045 	cmpmi	r4, r5, asr #32
    18d4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    18d8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    18dc:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    18e0:	00303138 	eorseq	r3, r0, r8, lsr r1
    18e4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    18e8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    18ec:	785f5550 	ldmdavc	pc, {r4, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
    18f0:	656e6567 	strbvs	r6, [lr, #-1383]!	; 0xfffffa99
    18f4:	52410031 	subpl	r0, r1, #49	; 0x31
    18f8:	43505f4d 	cmpmi	r0, #308	; 0x134
    18fc:	41415f53 	cmpmi	r1, r3, asr pc
    1900:	5f534350 	svcpl	0x00534350
    1904:	4d4d5749 	stclmi	7, cr5, [sp, #-292]	; 0xfffffedc
    1908:	42005458 	andmi	r5, r0, #88, 8	; 0x58000000
    190c:	5f455341 	svcpl	0x00455341
    1910:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1914:	4200305f 	andmi	r3, r0, #95	; 0x5f
    1918:	5f455341 	svcpl	0x00455341
    191c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1920:	4200325f 	andmi	r3, r0, #-268435451	; 0xf0000005
    1924:	5f455341 	svcpl	0x00455341
    1928:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    192c:	4200335f 	andmi	r3, r0, #2080374785	; 0x7c000001
    1930:	5f455341 	svcpl	0x00455341
    1934:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1938:	4200345f 	andmi	r3, r0, #1593835520	; 0x5f000000
    193c:	5f455341 	svcpl	0x00455341
    1940:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1944:	4200365f 	andmi	r3, r0, #99614720	; 0x5f00000
    1948:	5f455341 	svcpl	0x00455341
    194c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1950:	5400375f 	strpl	r3, [r0], #-1887	; 0xfffff8a1
    1954:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1958:	50435f54 	subpl	r5, r3, r4, asr pc
    195c:	73785f55 	cmnvc	r8, #340	; 0x154
    1960:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    1964:	61736900 	cmnvs	r3, r0, lsl #18
    1968:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    196c:	6572705f 	ldrbvs	r7, [r2, #-95]!	; 0xffffffa1
    1970:	73657264 	cmnvc	r5, #100, 4	; 0x40000006
    1974:	52415400 	subpl	r5, r1, #0, 8
    1978:	5f544547 	svcpl	0x00544547
    197c:	5f555043 	svcpl	0x00555043
    1980:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1984:	336d7865 	cmncc	sp, #6619136	; 0x650000
    1988:	41540033 	cmpmi	r4, r3, lsr r0
    198c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1990:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1994:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1998:	6d647437 	cfstrdvs	mvd7, [r4, #-220]!	; 0xffffff24
    199c:	73690069 	cmnvc	r9, #105	; 0x69
    19a0:	6f6e5f61 	svcvs	0x006e5f61
    19a4:	00746962 	rsbseq	r6, r4, r2, ror #18
    19a8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    19ac:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    19b0:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    19b4:	31316d72 	teqcc	r1, r2, ror sp
    19b8:	7a6a3637 	bvc	1a8f29c <__bss_end+0x1a862d0>
    19bc:	69007366 	stmdbvs	r0, {r1, r2, r5, r6, r8, r9, ip, sp, lr}
    19c0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    19c4:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    19c8:	32767066 	rsbscc	r7, r6, #102	; 0x66
    19cc:	4d524100 	ldfmie	f4, [r2, #-0]
    19d0:	5343505f 	movtpl	r5, #12383	; 0x305f
    19d4:	4b4e555f 	blmi	1396f58 <__bss_end+0x138df8c>
    19d8:	4e574f4e 	cdpmi	15, 5, cr4, cr7, cr14, {2}
    19dc:	52415400 	subpl	r5, r1, #0, 8
    19e0:	5f544547 	svcpl	0x00544547
    19e4:	5f555043 	svcpl	0x00555043
    19e8:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    19ec:	41420065 	cmpmi	r2, r5, rrx
    19f0:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    19f4:	5f484352 	svcpl	0x00484352
    19f8:	4a455435 	bmi	1156ad4 <__bss_end+0x114db08>
    19fc:	6d726100 	ldfvse	f6, [r2, #-0]
    1a00:	6663635f 			; <UNDEFINED> instruction: 0x6663635f
    1a04:	735f6d73 	cmpvc	pc, #7360	; 0x1cc0
    1a08:	65746174 	ldrbvs	r6, [r4, #-372]!	; 0xfffffe8c
    1a0c:	6d726100 	ldfvse	f6, [r2, #-0]
    1a10:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1a14:	65743568 	ldrbvs	r3, [r4, #-1384]!	; 0xfffffa98
    1a18:	736e7500 	cmnvc	lr, #0, 10
    1a1c:	5f636570 	svcpl	0x00636570
    1a20:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    1a24:	0073676e 	rsbseq	r6, r3, lr, ror #14
    1a28:	5f617369 	svcpl	0x00617369
    1a2c:	5f746962 	svcpl	0x00746962
    1a30:	00636573 	rsbeq	r6, r3, r3, ror r5
    1a34:	6c635f5f 	stclvs	15, cr5, [r3], #-380	; 0xfffffe84
    1a38:	61745f7a 	cmnvs	r4, sl, ror pc
    1a3c:	52410062 	subpl	r0, r1, #98	; 0x62
    1a40:	43565f4d 	cmpmi	r6, #308	; 0x134
    1a44:	6d726100 	ldfvse	f6, [r2, #-0]
    1a48:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1a4c:	73785f68 	cmnvc	r8, #104, 30	; 0x1a0
    1a50:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    1a54:	4d524100 	ldfmie	f4, [r2, #-0]
    1a58:	00454c5f 	subeq	r4, r5, pc, asr ip
    1a5c:	5f4d5241 	svcpl	0x004d5241
    1a60:	41005356 	tstmi	r0, r6, asr r3
    1a64:	475f4d52 			; <UNDEFINED> instruction: 0x475f4d52
    1a68:	72610045 	rsbvc	r0, r1, #69	; 0x45
    1a6c:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    1a70:	735f656e 	cmpvc	pc, #461373440	; 0x1b800000
    1a74:	6e6f7274 	mcrvs	2, 3, r7, cr15, cr4, {3}
    1a78:	6d726167 	ldfvse	f6, [r2, #-412]!	; 0xfffffe64
    1a7c:	6d6f6300 	stclvs	3, cr6, [pc, #-0]	; 1a84 <shift+0x1a84>
    1a80:	78656c70 	stmdavc	r5!, {r4, r5, r6, sl, fp, sp, lr}^
    1a84:	6f6c6620 	svcvs	0x006c6620
    1a88:	54007461 	strpl	r7, [r0], #-1121	; 0xfffffb9f
    1a8c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1a90:	50435f54 	subpl	r5, r3, r4, asr pc
    1a94:	6f635f55 	svcvs	0x00635f55
    1a98:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1a9c:	00353161 	eorseq	r3, r5, r1, ror #2
    1aa0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1aa4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1aa8:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    1aac:	36323761 	ldrtcc	r3, [r2], -r1, ror #14
    1ab0:	54006574 	strpl	r6, [r0], #-1396	; 0xfffffa8c
    1ab4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1ab8:	50435f54 	subpl	r5, r3, r4, asr pc
    1abc:	6f635f55 	svcvs	0x00635f55
    1ac0:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1ac4:	00373161 	eorseq	r3, r7, r1, ror #2
    1ac8:	5f4d5241 	svcpl	0x004d5241
    1acc:	54005447 	strpl	r5, [r0], #-1095	; 0xfffffbb9
    1ad0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1ad4:	50435f54 	subpl	r5, r3, r4, asr pc
    1ad8:	656e5f55 	strbvs	r5, [lr, #-3925]!	; 0xfffff0ab
    1adc:	7265766f 	rsbvc	r7, r5, #116391936	; 0x6f00000
    1ae0:	316e6573 	smccc	58963	; 0xe653
    1ae4:	2f2e2e00 	svccs	0x002e2e00
    1ae8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1aec:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1af0:	2f2e2e2f 	svccs	0x002e2e2f
    1af4:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 1a44 <shift+0x1a44>
    1af8:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1afc:	696c2f63 	stmdbvs	ip!, {r0, r1, r5, r6, r8, r9, sl, fp, sp}^
    1b00:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1b04:	00632e32 	rsbeq	r2, r3, r2, lsr lr
    1b08:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1b0c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1b10:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1b14:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1b18:	66347278 			; <UNDEFINED> instruction: 0x66347278
    1b1c:	53414200 	movtpl	r4, #4608	; 0x1200
    1b20:	52415f45 	subpl	r5, r1, #276	; 0x114
    1b24:	375f4843 	ldrbcc	r4, [pc, -r3, asr #16]
    1b28:	54004d45 	strpl	r4, [r0], #-3397	; 0xfffff2bb
    1b2c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1b30:	50435f54 	subpl	r5, r3, r4, asr pc
    1b34:	6f635f55 	svcvs	0x00635f55
    1b38:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1b3c:	00323161 	eorseq	r3, r2, r1, ror #2
    1b40:	68736168 	ldmdavs	r3!, {r3, r5, r6, r8, sp, lr}^
    1b44:	5f6c6176 	svcpl	0x006c6176
    1b48:	41420074 	hvcmi	8196	; 0x2004
    1b4c:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1b50:	5f484352 	svcpl	0x00484352
    1b54:	005a4b36 	subseq	r4, sl, r6, lsr fp
    1b58:	5f617369 	svcpl	0x00617369
    1b5c:	73746962 	cmnvc	r4, #1605632	; 0x188000
    1b60:	6d726100 	ldfvse	f6, [r2, #-0]
    1b64:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1b68:	72615f68 	rsbvc	r5, r1, #104, 30	; 0x1a0
    1b6c:	77685f6d 	strbvc	r5, [r8, -sp, ror #30]!
    1b70:	00766964 	rsbseq	r6, r6, r4, ror #18
    1b74:	5f6d7261 	svcpl	0x006d7261
    1b78:	5f757066 	svcpl	0x00757066
    1b7c:	63736564 	cmnvs	r3, #100, 10	; 0x19000000
    1b80:	61736900 	cmnvs	r3, r0, lsl #18
    1b84:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1b88:	3170665f 	cmncc	r0, pc, asr r6
    1b8c:	4e470036 	mcrmi	0, 2, r0, cr7, cr6, {1}
    1b90:	31432055 	qdaddcc	r2, r5, r3
    1b94:	2e392037 	mrccs	0, 1, r2, cr9, cr7, {1}
    1b98:	20312e32 	eorscs	r2, r1, r2, lsr lr
    1b9c:	39313032 	ldmdbcc	r1!, {r1, r4, r5, ip, sp}
    1ba0:	35323031 	ldrcc	r3, [r2, #-49]!	; 0xffffffcf
    1ba4:	65722820 	ldrbvs	r2, [r2, #-2080]!	; 0xfffff7e0
    1ba8:	7361656c 	cmnvc	r1, #108, 10	; 0x1b000000
    1bac:	5b202965 	blpl	80c148 <__bss_end+0x80317c>
    1bb0:	2f4d5241 	svccs	0x004d5241
    1bb4:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    1bb8:	72622d39 	rsbvc	r2, r2, #3648	; 0xe40
    1bbc:	68636e61 	stmdavs	r3!, {r0, r5, r6, r9, sl, fp, sp, lr}^
    1bc0:	76657220 	strbtvc	r7, [r5], -r0, lsr #4
    1bc4:	6f697369 	svcvs	0x00697369
    1bc8:	3732206e 	ldrcc	r2, [r2, -lr, rrx]!
    1bcc:	39393537 	ldmdbcc	r9!, {r0, r1, r2, r4, r5, r8, sl, ip, sp}
    1bd0:	6d2d205d 	stcvs	0, cr2, [sp, #-372]!	; 0xfffffe8c
    1bd4:	206d7261 	rsbcs	r7, sp, r1, ror #4
    1bd8:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
    1bdc:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
    1be0:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
    1be4:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    1be8:	616d2d20 	cmnvs	sp, r0, lsr #26
    1bec:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
    1bf0:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1bf4:	2b657435 	blcs	195ecd0 <__bss_end+0x1955d04>
    1bf8:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    1bfc:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    1c00:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    1c04:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    1c08:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    1c0c:	20324f2d 	eorscs	r4, r2, sp, lsr #30
    1c10:	7562662d 	strbvc	r6, [r2, #-1581]!	; 0xfffff9d3
    1c14:	69646c69 	stmdbvs	r4!, {r0, r3, r5, r6, sl, fp, sp, lr}^
    1c18:	6c2d676e 	stcvs	7, cr6, [sp], #-440	; 0xfffffe48
    1c1c:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1c20:	662d2063 	strtvs	r2, [sp], -r3, rrx
    1c24:	732d6f6e 			; <UNDEFINED> instruction: 0x732d6f6e
    1c28:	6b636174 	blvs	18da200 <__bss_end+0x18d1234>
    1c2c:	6f72702d 	svcvs	0x0072702d
    1c30:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
    1c34:	2d20726f 	sfmcs	f7, 4, [r0, #-444]!	; 0xfffffe44
    1c38:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 1aa8 <shift+0x1aa8>
    1c3c:	696c6e69 	stmdbvs	ip!, {r0, r3, r5, r6, r9, sl, fp, sp, lr}^
    1c40:	2d20656e 	cfstr32cs	mvfx6, [r0, #-440]!	; 0xfffffe48
    1c44:	73697666 	cmnvc	r9, #106954752	; 0x6600000
    1c48:	6c696269 	sfmvs	f6, 2, [r9], #-420	; 0xfffffe5c
    1c4c:	3d797469 	cfldrdcc	mvd7, [r9, #-420]!	; 0xfffffe5c
    1c50:	64646968 	strbtvs	r6, [r4], #-2408	; 0xfffff698
    1c54:	41006e65 	tstmi	r0, r5, ror #28
    1c58:	485f4d52 	ldmdami	pc, {r1, r4, r6, r8, sl, fp, lr}^	; <UNPREDICTABLE>
    1c5c:	73690049 	cmnvc	r9, #73	; 0x49
    1c60:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1c64:	64615f74 	strbtvs	r5, [r1], #-3956	; 0xfffff08c
    1c68:	54007669 	strpl	r7, [r0], #-1641	; 0xfffff997
    1c6c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1c70:	50435f54 	subpl	r5, r3, r4, asr pc
    1c74:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1c78:	3331316d 	teqcc	r1, #1073741851	; 0x4000001b
    1c7c:	00736a36 	rsbseq	r6, r3, r6, lsr sl
    1c80:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1c84:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1c88:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1c8c:	00386d72 	eorseq	r6, r8, r2, ror sp
    1c90:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1c94:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1c98:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1c9c:	00396d72 	eorseq	r6, r9, r2, ror sp
    1ca0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1ca4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1ca8:	665f5550 			; <UNDEFINED> instruction: 0x665f5550
    1cac:	36323661 	ldrtcc	r3, [r2], -r1, ror #12
    1cb0:	6e6f6c00 	cdpvs	12, 6, cr6, cr15, cr0, {0}
    1cb4:	6f6c2067 	svcvs	0x006c2067
    1cb8:	7520676e 	strvc	r6, [r0, #-1902]!	; 0xfffff892
    1cbc:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
    1cc0:	2064656e 	rsbcs	r6, r4, lr, ror #10
    1cc4:	00746e69 	rsbseq	r6, r4, r9, ror #28
    1cc8:	5f6d7261 	svcpl	0x006d7261
    1ccc:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1cd0:	736d635f 	cmnvc	sp, #2080374785	; 0x7c000001
    1cd4:	41540065 	cmpmi	r4, r5, rrx
    1cd8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1cdc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1ce0:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1ce4:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1ce8:	41540034 	cmpmi	r4, r4, lsr r0
    1cec:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1cf0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1cf4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1cf8:	00653031 	rsbeq	r3, r5, r1, lsr r0
    1cfc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1d00:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1d04:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1d08:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1d0c:	00376d78 	eorseq	r6, r7, r8, ror sp
    1d10:	5f6d7261 	svcpl	0x006d7261
    1d14:	646e6f63 	strbtvs	r6, [lr], #-3939	; 0xfffff09d
    1d18:	646f635f 	strbtvs	r6, [pc], #-863	; 1d20 <shift+0x1d20>
    1d1c:	52410065 	subpl	r0, r1, #101	; 0x65
    1d20:	43505f4d 	cmpmi	r0, #308	; 0x134
    1d24:	41415f53 	cmpmi	r1, r3, asr pc
    1d28:	00534350 	subseq	r4, r3, r0, asr r3
    1d2c:	5f617369 	svcpl	0x00617369
    1d30:	5f746962 	svcpl	0x00746962
    1d34:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    1d38:	00325f38 	eorseq	r5, r2, r8, lsr pc
    1d3c:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1d40:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1d44:	4d335f48 	ldcmi	15, cr5, [r3, #-288]!	; 0xfffffee0
    1d48:	52415400 	subpl	r5, r1, #0, 8
    1d4c:	5f544547 	svcpl	0x00544547
    1d50:	5f555043 	svcpl	0x00555043
    1d54:	376d7261 	strbcc	r7, [sp, -r1, ror #4]!
    1d58:	00743031 	rsbseq	r3, r4, r1, lsr r0
    1d5c:	5f6d7261 	svcpl	0x006d7261
    1d60:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1d64:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    1d68:	3274786d 	rsbscc	r7, r4, #7143424	; 0x6d0000
    1d6c:	61736900 	cmnvs	r3, r0, lsl #18
    1d70:	6d756e5f 	ldclvs	14, cr6, [r5, #-380]!	; 0xfffffe84
    1d74:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1d78:	41540073 	cmpmi	r4, r3, ror r0
    1d7c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1d80:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1d84:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1d88:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1d8c:	756c7030 	strbvc	r7, [ip, #-48]!	; 0xffffffd0
    1d90:	616d7373 	smcvs	55091	; 0xd733
    1d94:	756d6c6c 	strbvc	r6, [sp, #-3180]!	; 0xfffff394
    1d98:	7069746c 	rsbvc	r7, r9, ip, ror #8
    1d9c:	5400796c 	strpl	r7, [r0], #-2412	; 0xfffff694
    1da0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1da4:	50435f54 	subpl	r5, r3, r4, asr pc
    1da8:	78655f55 	stmdavc	r5!, {r0, r2, r4, r6, r8, r9, sl, fp, ip, lr}^
    1dac:	736f6e79 	cmnvc	pc, #1936	; 0x790
    1db0:	5400316d 	strpl	r3, [r0], #-365	; 0xfffffe93
    1db4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1db8:	50435f54 	subpl	r5, r3, r4, asr pc
    1dbc:	6f635f55 	svcvs	0x00635f55
    1dc0:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1dc4:	00323572 	eorseq	r3, r2, r2, ror r5
    1dc8:	5f617369 	svcpl	0x00617369
    1dcc:	5f746962 	svcpl	0x00746962
    1dd0:	76696474 			; <UNDEFINED> instruction: 0x76696474
    1dd4:	65727000 	ldrbvs	r7, [r2, #-0]!
    1dd8:	5f726566 	svcpl	0x00726566
    1ddc:	6e6f656e 	cdpvs	5, 6, cr6, cr15, cr14, {3}
    1de0:	726f665f 	rsbvc	r6, pc, #99614720	; 0x5f00000
    1de4:	6234365f 	eorsvs	r3, r4, #99614720	; 0x5f00000
    1de8:	00737469 	rsbseq	r7, r3, r9, ror #8
    1dec:	5f617369 	svcpl	0x00617369
    1df0:	5f746962 	svcpl	0x00746962
    1df4:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    1df8:	006c6d66 	rsbeq	r6, ip, r6, ror #26
    1dfc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1e00:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1e04:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1e08:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1e0c:	32336178 	eorscc	r6, r3, #120, 2
    1e10:	52415400 	subpl	r5, r1, #0, 8
    1e14:	5f544547 	svcpl	0x00544547
    1e18:	5f555043 	svcpl	0x00555043
    1e1c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1e20:	33617865 	cmncc	r1, #6619136	; 0x650000
    1e24:	73690035 	cmnvc	r9, #53	; 0x35
    1e28:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1e2c:	70665f74 	rsbvc	r5, r6, r4, ror pc
    1e30:	6f633631 	svcvs	0x00633631
    1e34:	7500766e 	strvc	r7, [r0, #-1646]	; 0xfffff992
    1e38:	6570736e 	ldrbvs	r7, [r0, #-878]!	; 0xfffffc92
    1e3c:	735f7663 	cmpvc	pc, #103809024	; 0x6300000
    1e40:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
    1e44:	54007367 	strpl	r7, [r0], #-871	; 0xfffffc99
    1e48:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1e4c:	50435f54 	subpl	r5, r3, r4, asr pc
    1e50:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1e54:	3531316d 	ldrcc	r3, [r1, #-365]!	; 0xfffffe93
    1e58:	73327436 	teqvc	r2, #905969664	; 0x36000000
    1e5c:	52415400 	subpl	r5, r1, #0, 8
    1e60:	5f544547 	svcpl	0x00544547
    1e64:	5f555043 	svcpl	0x00555043
    1e68:	30366166 	eorscc	r6, r6, r6, ror #2
    1e6c:	00657436 	rsbeq	r7, r5, r6, lsr r4
    1e70:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1e74:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1e78:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1e7c:	32396d72 	eorscc	r6, r9, #7296	; 0x1c80
    1e80:	736a6536 	cmnvc	sl, #226492416	; 0xd800000
    1e84:	53414200 	movtpl	r4, #4608	; 0x1200
    1e88:	52415f45 	subpl	r5, r1, #276	; 0x114
    1e8c:	345f4843 	ldrbcc	r4, [pc], #-2115	; 1e94 <shift+0x1e94>
    1e90:	73690054 	cmnvc	r9, #84	; 0x54
    1e94:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1e98:	72635f74 	rsbvc	r5, r3, #116, 30	; 0x1d0
    1e9c:	6f747079 	svcvs	0x00747079
    1ea0:	6d726100 	ldfvse	f6, [r2, #-0]
    1ea4:	6765725f 			; <UNDEFINED> instruction: 0x6765725f
    1ea8:	6e695f73 	mcrvs	15, 3, r5, cr9, cr3, {3}
    1eac:	7165735f 	cmnvc	r5, pc, asr r3
    1eb0:	636e6575 	cmnvs	lr, #490733568	; 0x1d400000
    1eb4:	73690065 	cmnvc	r9, #101	; 0x65
    1eb8:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1ebc:	62735f74 	rsbsvs	r5, r3, #116, 30	; 0x1d0
    1ec0:	53414200 	movtpl	r4, #4608	; 0x1200
    1ec4:	52415f45 	subpl	r5, r1, #276	; 0x114
    1ec8:	355f4843 	ldrbcc	r4, [pc, #-2115]	; 168d <shift+0x168d>
    1ecc:	69004554 	stmdbvs	r0, {r2, r4, r6, r8, sl, lr}
    1ed0:	665f6173 			; <UNDEFINED> instruction: 0x665f6173
    1ed4:	75746165 	ldrbvc	r6, [r4, #-357]!	; 0xfffffe9b
    1ed8:	69006572 	stmdbvs	r0, {r1, r4, r5, r6, r8, sl, sp, lr}
    1edc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1ee0:	735f7469 	cmpvc	pc, #1761607680	; 0x69000000
    1ee4:	6c6c616d 	stfvse	f6, [ip], #-436	; 0xfffffe4c
    1ee8:	006c756d 	rsbeq	r7, ip, sp, ror #10
    1eec:	5f6d7261 	svcpl	0x006d7261
    1ef0:	676e616c 	strbvs	r6, [lr, -ip, ror #2]!
    1ef4:	74756f5f 	ldrbtvc	r6, [r5], #-3935	; 0xfffff0a1
    1ef8:	5f747570 	svcpl	0x00747570
    1efc:	656a626f 	strbvs	r6, [sl, #-623]!	; 0xfffffd91
    1f00:	615f7463 	cmpvs	pc, r3, ror #8
    1f04:	69727474 	ldmdbvs	r2!, {r2, r4, r5, r6, sl, ip, sp, lr}^
    1f08:	65747562 	ldrbvs	r7, [r4, #-1378]!	; 0xfffffa9e
    1f0c:	6f685f73 	svcvs	0x00685f73
    1f10:	69006b6f 	stmdbvs	r0, {r0, r1, r2, r3, r5, r6, r8, r9, fp, sp, lr}
    1f14:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1f18:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1f1c:	33645f70 	cmncc	r4, #112, 30	; 0x1c0
    1f20:	52410032 	subpl	r0, r1, #50	; 0x32
    1f24:	454e5f4d 	strbmi	r5, [lr, #-3917]	; 0xfffff0b3
    1f28:	61736900 	cmnvs	r3, r0, lsl #18
    1f2c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1f30:	3865625f 	stmdacc	r5!, {r0, r1, r2, r3, r4, r6, r9, sp, lr}^
    1f34:	52415400 	subpl	r5, r1, #0, 8
    1f38:	5f544547 	svcpl	0x00544547
    1f3c:	5f555043 	svcpl	0x00555043
    1f40:	316d7261 	cmncc	sp, r1, ror #4
    1f44:	6a363731 	bvs	d8fc10 <__bss_end+0xd86c44>
    1f48:	7000737a 	andvc	r7, r0, sl, ror r3
    1f4c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1f50:	726f7373 	rsbvc	r7, pc, #-872415231	; 0xcc000001
    1f54:	7079745f 	rsbsvc	r7, r9, pc, asr r4
    1f58:	6c610065 	stclvs	0, cr0, [r1], #-404	; 0xfffffe6c
    1f5c:	70665f6c 	rsbvc	r5, r6, ip, ror #30
    1f60:	61007375 	tstvs	r0, r5, ror r3
    1f64:	705f6d72 	subsvc	r6, pc, r2, ror sp	; <UNPREDICTABLE>
    1f68:	42007363 	andmi	r7, r0, #-1946157055	; 0x8c000001
    1f6c:	5f455341 	svcpl	0x00455341
    1f70:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1f74:	0054355f 	subseq	r3, r4, pc, asr r5
    1f78:	5f6d7261 	svcpl	0x006d7261
    1f7c:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1f80:	54007434 	strpl	r7, [r0], #-1076	; 0xfffffbcc
    1f84:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1f88:	50435f54 	subpl	r5, r3, r4, asr pc
    1f8c:	6f635f55 	svcvs	0x00635f55
    1f90:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1f94:	63363761 	teqvs	r6, #25427968	; 0x1840000
    1f98:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1f9c:	35356178 	ldrcc	r6, [r5, #-376]!	; 0xfffffe88
    1fa0:	6d726100 	ldfvse	f6, [r2, #-0]
    1fa4:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    1fa8:	62775f65 	rsbsvs	r5, r7, #404	; 0x194
    1fac:	68006675 	stmdavs	r0, {r0, r2, r4, r5, r6, r9, sl, sp, lr}
    1fb0:	5f626174 	svcpl	0x00626174
    1fb4:	68736168 	ldmdavs	r3!, {r3, r5, r6, r8, sp, lr}^
    1fb8:	61736900 	cmnvs	r3, r0, lsl #18
    1fbc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1fc0:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    1fc4:	6e5f6b72 	vmovvs.s8	r6, d15[3]
    1fc8:	6f765f6f 	svcvs	0x00765f6f
    1fcc:	6974616c 	ldmdbvs	r4!, {r2, r3, r5, r6, r8, sp, lr}^
    1fd0:	635f656c 	cmpvs	pc, #108, 10	; 0x1b000000
    1fd4:	41540065 	cmpmi	r4, r5, rrx
    1fd8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1fdc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1fe0:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1fe4:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1fe8:	41540030 	cmpmi	r4, r0, lsr r0
    1fec:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1ff0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1ff4:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1ff8:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1ffc:	41540031 	cmpmi	r4, r1, lsr r0
    2000:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2004:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2008:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    200c:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    2010:	73690033 	cmnvc	r9, #51	; 0x33
    2014:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2018:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    201c:	5f38766d 	svcpl	0x0038766d
    2020:	72610031 	rsbvc	r0, r1, #49	; 0x31
    2024:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2028:	6e5f6863 	cdpvs	8, 5, cr6, cr15, cr3, {3}
    202c:	00656d61 	rsbeq	r6, r5, r1, ror #26
    2030:	5f617369 	svcpl	0x00617369
    2034:	5f746962 	svcpl	0x00746962
    2038:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    203c:	00335f38 	eorseq	r5, r3, r8, lsr pc
    2040:	5f617369 	svcpl	0x00617369
    2044:	5f746962 	svcpl	0x00746962
    2048:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    204c:	00345f38 	eorseq	r5, r4, r8, lsr pc
    2050:	5f617369 	svcpl	0x00617369
    2054:	5f746962 	svcpl	0x00746962
    2058:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    205c:	00355f38 	eorseq	r5, r5, r8, lsr pc
    2060:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2064:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2068:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    206c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2070:	33356178 	teqcc	r5, #120, 2
    2074:	52415400 	subpl	r5, r1, #0, 8
    2078:	5f544547 	svcpl	0x00544547
    207c:	5f555043 	svcpl	0x00555043
    2080:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2084:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    2088:	41540035 	cmpmi	r4, r5, lsr r0
    208c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2090:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2094:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2098:	61786574 	cmnvs	r8, r4, ror r5
    209c:	54003735 	strpl	r3, [r0], #-1845	; 0xfffff8cb
    20a0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    20a4:	50435f54 	subpl	r5, r3, r4, asr pc
    20a8:	706d5f55 	rsbvc	r5, sp, r5, asr pc
    20ac:	65726f63 	ldrbvs	r6, [r2, #-3939]!	; 0xfffff09d
    20b0:	52415400 	subpl	r5, r1, #0, 8
    20b4:	5f544547 	svcpl	0x00544547
    20b8:	5f555043 	svcpl	0x00555043
    20bc:	5f6d7261 	svcpl	0x006d7261
    20c0:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    20c4:	6d726100 	ldfvse	f6, [r2, #-0]
    20c8:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    20cc:	6f6e5f68 	svcvs	0x006e5f68
    20d0:	54006d74 	strpl	r6, [r0], #-3444	; 0xfffff28c
    20d4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    20d8:	50435f54 	subpl	r5, r3, r4, asr pc
    20dc:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    20e0:	3230316d 	eorscc	r3, r0, #1073741851	; 0x4000001b
    20e4:	736a6536 	cmnvc	sl, #226492416	; 0xd800000
    20e8:	53414200 	movtpl	r4, #4608	; 0x1200
    20ec:	52415f45 	subpl	r5, r1, #276	; 0x114
    20f0:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    20f4:	4142004a 	cmpmi	r2, sl, asr #32
    20f8:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    20fc:	5f484352 	svcpl	0x00484352
    2100:	42004b36 	andmi	r4, r0, #55296	; 0xd800
    2104:	5f455341 	svcpl	0x00455341
    2108:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    210c:	004d365f 	subeq	r3, sp, pc, asr r6
    2110:	5f617369 	svcpl	0x00617369
    2114:	5f746962 	svcpl	0x00746962
    2118:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    211c:	54007478 	strpl	r7, [r0], #-1144	; 0xfffffb88
    2120:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2124:	50435f54 	subpl	r5, r3, r4, asr pc
    2128:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    212c:	3331316d 	teqcc	r1, #1073741851	; 0x4000001b
    2130:	73666a36 	cmnvc	r6, #221184	; 0x36000
    2134:	4d524100 	ldfmie	f4, [r2, #-0]
    2138:	00534c5f 	subseq	r4, r3, pc, asr ip
    213c:	5f4d5241 	svcpl	0x004d5241
    2140:	4200544c 	andmi	r5, r0, #76, 8	; 0x4c000000
    2144:	5f455341 	svcpl	0x00455341
    2148:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    214c:	005a365f 	subseq	r3, sl, pc, asr r6
    2150:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2154:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2158:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    215c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2160:	35376178 	ldrcc	r6, [r7, #-376]!	; 0xfffffe88
    2164:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2168:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    216c:	52410035 	subpl	r0, r1, #53	; 0x35
    2170:	43505f4d 	cmpmi	r0, #308	; 0x134
    2174:	41415f53 	cmpmi	r1, r3, asr pc
    2178:	5f534350 	svcpl	0x00534350
    217c:	00504656 	subseq	r4, r0, r6, asr r6
    2180:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2184:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2188:	695f5550 	ldmdbvs	pc, {r4, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
    218c:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    2190:	69003274 	stmdbvs	r0, {r2, r4, r5, r6, r9, ip, sp}
    2194:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2198:	6e5f7469 	cdpvs	4, 5, cr7, cr15, cr9, {3}
    219c:	006e6f65 	rsbeq	r6, lr, r5, ror #30
    21a0:	5f6d7261 	svcpl	0x006d7261
    21a4:	5f757066 	svcpl	0x00757066
    21a8:	72747461 	rsbsvc	r7, r4, #1627389952	; 0x61000000
    21ac:	61736900 	cmnvs	r3, r0, lsl #18
    21b0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    21b4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    21b8:	6d653776 	stclvs	7, cr3, [r5, #-472]!	; 0xfffffe28
    21bc:	52415400 	subpl	r5, r1, #0, 8
    21c0:	5f544547 	svcpl	0x00544547
    21c4:	5f555043 	svcpl	0x00555043
    21c8:	32366166 	eorscc	r6, r6, #-2147483623	; 0x80000019
    21cc:	00657436 	rsbeq	r7, r5, r6, lsr r4
    21d0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    21d4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    21d8:	6d5f5550 	cfldr64vs	mvdx5, [pc, #-320]	; 20a0 <shift+0x20a0>
    21dc:	65767261 	ldrbvs	r7, [r6, #-609]!	; 0xfffffd9f
    21e0:	705f6c6c 	subsvc	r6, pc, ip, ror #24
    21e4:	6800346a 	stmdavs	r0, {r1, r3, r5, r6, sl, ip, sp}
    21e8:	5f626174 	svcpl	0x00626174
    21ec:	68736168 	ldmdavs	r3!, {r3, r5, r6, r8, sp, lr}^
    21f0:	696f705f 	stmdbvs	pc!, {r0, r1, r2, r3, r4, r6, ip, sp, lr}^	; <UNPREDICTABLE>
    21f4:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    21f8:	6d726100 	ldfvse	f6, [r2, #-0]
    21fc:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    2200:	6f635f65 	svcvs	0x00635f65
    2204:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2208:	0039615f 	eorseq	r6, r9, pc, asr r1
    220c:	5f617369 	svcpl	0x00617369
    2210:	5f746962 	svcpl	0x00746962
    2214:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    2218:	00327478 	eorseq	r7, r2, r8, ror r4
    221c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2220:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2224:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2228:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    222c:	32376178 	eorscc	r6, r7, #120, 2
    2230:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2234:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    2238:	73690033 	cmnvc	r9, #51	; 0x33
    223c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2240:	68745f74 	ldmdavs	r4!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    2244:	32626d75 	rsbcc	r6, r2, #7488	; 0x1d40
    2248:	53414200 	movtpl	r4, #4608	; 0x1200
    224c:	52415f45 	subpl	r5, r1, #276	; 0x114
    2250:	375f4843 	ldrbcc	r4, [pc, -r3, asr #16]
    2254:	73690041 	cmnvc	r9, #65	; 0x41
    2258:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    225c:	6f645f74 	svcvs	0x00645f74
    2260:	6f727074 	svcvs	0x00727074
    2264:	72610064 	rsbvc	r0, r1, #100	; 0x64
    2268:	70665f6d 	rsbvc	r5, r6, sp, ror #30
    226c:	745f3631 	ldrbvc	r3, [pc], #-1585	; 2274 <shift+0x2274>
    2270:	5f657079 	svcpl	0x00657079
    2274:	65646f6e 	strbvs	r6, [r4, #-3950]!	; 0xfffff092
    2278:	4d524100 	ldfmie	f4, [r2, #-0]
    227c:	00494d5f 	subeq	r4, r9, pc, asr sp
    2280:	5f6d7261 	svcpl	0x006d7261
    2284:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2288:	61006b36 	tstvs	r0, r6, lsr fp
    228c:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2290:	36686372 			; <UNDEFINED> instruction: 0x36686372
    2294:	4142006d 	cmpmi	r2, sp, rrx
    2298:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    229c:	5f484352 	svcpl	0x00484352
    22a0:	5f005237 	svcpl	0x00005237
    22a4:	706f705f 	rsbvc	r7, pc, pc, asr r0	; <UNPREDICTABLE>
    22a8:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
    22ac:	61745f74 	cmnvs	r4, r4, ror pc
    22b0:	73690062 	cmnvc	r9, #98	; 0x62
    22b4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    22b8:	6d635f74 	stclvs	15, cr5, [r3, #-464]!	; 0xfffffe30
    22bc:	54006573 	strpl	r6, [r0], #-1395	; 0xfffffa8d
    22c0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    22c4:	50435f54 	subpl	r5, r3, r4, asr pc
    22c8:	6f635f55 	svcvs	0x00635f55
    22cc:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    22d0:	00333761 	eorseq	r3, r3, r1, ror #14
    22d4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    22d8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    22dc:	675f5550 			; <UNDEFINED> instruction: 0x675f5550
    22e0:	72656e65 	rsbvc	r6, r5, #1616	; 0x650
    22e4:	37766369 	ldrbcc	r6, [r6, -r9, ror #6]!
    22e8:	41540061 	cmpmi	r4, r1, rrx
    22ec:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    22f0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    22f4:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    22f8:	61786574 	cmnvs	r8, r4, ror r5
    22fc:	61003637 	tstvs	r0, r7, lsr r6
    2300:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2304:	5f686372 	svcpl	0x00686372
    2308:	765f6f6e 	ldrbvc	r6, [pc], -lr, ror #30
    230c:	74616c6f 	strbtvc	r6, [r1], #-3183	; 0xfffff391
    2310:	5f656c69 	svcpl	0x00656c69
    2314:	42006563 	andmi	r6, r0, #415236096	; 0x18c00000
    2318:	5f455341 	svcpl	0x00455341
    231c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    2320:	0041385f 	subeq	r3, r1, pc, asr r8
    2324:	5f617369 	svcpl	0x00617369
    2328:	5f746962 	svcpl	0x00746962
    232c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2330:	42007435 	andmi	r7, r0, #889192448	; 0x35000000
    2334:	5f455341 	svcpl	0x00455341
    2338:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    233c:	0052385f 	subseq	r3, r2, pc, asr r8
    2340:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2344:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2348:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    234c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2350:	33376178 	teqcc	r7, #120, 2
    2354:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2358:	33617865 	cmncc	r1, #6619136	; 0x650000
    235c:	52410035 	subpl	r0, r1, #53	; 0x35
    2360:	564e5f4d 	strbpl	r5, [lr], -sp, asr #30
    2364:	6d726100 	ldfvse	f6, [r2, #-0]
    2368:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    236c:	61003468 	tstvs	r0, r8, ror #8
    2370:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2374:	36686372 			; <UNDEFINED> instruction: 0x36686372
    2378:	6d726100 	ldfvse	f6, [r2, #-0]
    237c:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2380:	61003768 	tstvs	r0, r8, ror #14
    2384:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2388:	38686372 	stmdacc	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    238c:	6e6f6c00 	cdpvs	12, 6, cr6, cr15, cr0, {0}
    2390:	6f642067 	svcvs	0x00642067
    2394:	656c6275 	strbvs	r6, [ip, #-629]!	; 0xfffffd8b
    2398:	6d726100 	ldfvse	f6, [r2, #-0]
    239c:	6e75745f 	mrcvs	4, 3, r7, cr5, cr15, {2}
    23a0:	73785f65 	cmnvc	r8, #404	; 0x194
    23a4:	656c6163 	strbvs	r6, [ip, #-355]!	; 0xfffffe9d
    23a8:	6b616d00 	blvs	185d7b0 <__bss_end+0x18547e4>
    23ac:	5f676e69 	svcpl	0x00676e69
    23b0:	736e6f63 	cmnvc	lr, #396	; 0x18c
    23b4:	61745f74 	cmnvs	r4, r4, ror pc
    23b8:	00656c62 	rsbeq	r6, r5, r2, ror #24
    23bc:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    23c0:	61635f62 	cmnvs	r3, r2, ror #30
    23c4:	765f6c6c 	ldrbvc	r6, [pc], -ip, ror #24
    23c8:	6c5f6169 	ldfvse	f6, [pc], {105}	; 0x69
    23cc:	6c656261 	sfmvs	f6, 2, [r5], #-388	; 0xfffffe7c
    23d0:	61736900 	cmnvs	r3, r0, lsl #18
    23d4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    23d8:	7670665f 			; <UNDEFINED> instruction: 0x7670665f
    23dc:	73690035 	cmnvc	r9, #53	; 0x35
    23e0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    23e4:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    23e8:	6b36766d 	blvs	d9fda4 <__bss_end+0xd96dd8>
    23ec:	52415400 	subpl	r5, r1, #0, 8
    23f0:	5f544547 	svcpl	0x00544547
    23f4:	5f555043 	svcpl	0x00555043
    23f8:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    23fc:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    2400:	52415400 	subpl	r5, r1, #0, 8
    2404:	5f544547 	svcpl	0x00544547
    2408:	5f555043 	svcpl	0x00555043
    240c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2410:	38617865 	stmdacc	r1!, {r0, r2, r5, r6, fp, ip, sp, lr}^
    2414:	52415400 	subpl	r5, r1, #0, 8
    2418:	5f544547 	svcpl	0x00544547
    241c:	5f555043 	svcpl	0x00555043
    2420:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2424:	39617865 	stmdbcc	r1!, {r0, r2, r5, r6, fp, ip, sp, lr}^
    2428:	4d524100 	ldfmie	f4, [r2, #-0]
    242c:	5343505f 	movtpl	r5, #12383	; 0x305f
    2430:	4350415f 	cmpmi	r0, #-1073741801	; 0xc0000017
    2434:	52410053 	subpl	r0, r1, #83	; 0x53
    2438:	43505f4d 	cmpmi	r0, #308	; 0x134
    243c:	54415f53 	strbpl	r5, [r1], #-3923	; 0xfffff0ad
    2440:	00534350 	subseq	r4, r3, r0, asr r3
    2444:	706d6f63 	rsbvc	r6, sp, r3, ror #30
    2448:	2078656c 	rsbscs	r6, r8, ip, ror #10
    244c:	62756f64 	rsbsvs	r6, r5, #100, 30	; 0x190
    2450:	5400656c 	strpl	r6, [r0], #-1388	; 0xfffffa94
    2454:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2458:	50435f54 	subpl	r5, r3, r4, asr pc
    245c:	6f635f55 	svcvs	0x00635f55
    2460:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2464:	63333761 	teqvs	r3, #25427968	; 0x1840000
    2468:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    246c:	33356178 	teqcc	r5, #120, 2
    2470:	52415400 	subpl	r5, r1, #0, 8
    2474:	5f544547 	svcpl	0x00544547
    2478:	5f555043 	svcpl	0x00555043
    247c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2480:	306d7865 	rsbcc	r7, sp, r5, ror #16
    2484:	73756c70 	cmnvc	r5, #112, 24	; 0x7000
    2488:	6d726100 	ldfvse	f6, [r2, #-0]
    248c:	0063635f 	rsbeq	r6, r3, pc, asr r3
    2490:	5f617369 	svcpl	0x00617369
    2494:	5f746962 	svcpl	0x00746962
    2498:	61637378 	smcvs	14136	; 0x3738
    249c:	5f00656c 	svcpl	0x0000656c
    24a0:	746e6f64 	strbtvc	r6, [lr], #-3940	; 0xfffff09c
    24a4:	6573755f 	ldrbvs	r7, [r3, #-1375]!	; 0xfffffaa1
    24a8:	6572745f 	ldrbvs	r7, [r2, #-1119]!	; 0xfffffba1
    24ac:	65685f65 	strbvs	r5, [r8, #-3941]!	; 0xfffff09b
    24b0:	005f6572 	subseq	r6, pc, r2, ror r5	; <UNPREDICTABLE>
    24b4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    24b8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    24bc:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    24c0:	30316d72 	eorscc	r6, r1, r2, ror sp
    24c4:	696d6474 	stmdbvs	sp!, {r2, r4, r5, r6, sl, sp, lr}^
    24c8:	52415400 	subpl	r5, r1, #0, 8
    24cc:	5f544547 	svcpl	0x00544547
    24d0:	5f555043 	svcpl	0x00555043
    24d4:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    24d8:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    24dc:	73616200 	cmnvc	r1, #0, 4
    24e0:	72615f65 	rsbvc	r5, r1, #404	; 0x194
    24e4:	74696863 	strbtvc	r6, [r9], #-2147	; 0xfffff79d
    24e8:	75746365 	ldrbvc	r6, [r4, #-869]!	; 0xfffffc9b
    24ec:	61006572 	tstvs	r0, r2, ror r5
    24f0:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    24f4:	5f686372 	svcpl	0x00686372
    24f8:	00637263 	rsbeq	r7, r3, r3, ror #4
    24fc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2500:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2504:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2508:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    250c:	73316d78 	teqvc	r1, #120, 26	; 0x1e00
    2510:	6c6c616d 	stfvse	f6, [ip], #-436	; 0xfffffe4c
    2514:	746c756d 	strbtvc	r7, [ip], #-1389	; 0xfffffa93
    2518:	796c7069 	stmdbvc	ip!, {r0, r3, r5, r6, ip, sp, lr}^
    251c:	6d726100 	ldfvse	f6, [r2, #-0]
    2520:	7275635f 	rsbsvc	r6, r5, #2080374785	; 0x7c000001
    2524:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
    2528:	0063635f 	rsbeq	r6, r3, pc, asr r3
    252c:	5f617369 	svcpl	0x00617369
    2530:	5f746962 	svcpl	0x00746962
    2534:	33637263 	cmncc	r3, #805306374	; 0x30000006
    2538:	52410032 	subpl	r0, r1, #50	; 0x32
    253c:	4c505f4d 	mrrcmi	15, 4, r5, r0, cr13
    2540:	61736900 	cmnvs	r3, r0, lsl #18
    2544:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2548:	7066765f 	rsbvc	r7, r6, pc, asr r6
    254c:	69003376 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, r9, ip, sp}
    2550:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2554:	765f7469 	ldrbvc	r7, [pc], -r9, ror #8
    2558:	34767066 	ldrbtcc	r7, [r6], #-102	; 0xffffff9a
    255c:	53414200 	movtpl	r4, #4608	; 0x1200
    2560:	52415f45 	subpl	r5, r1, #276	; 0x114
    2564:	365f4843 	ldrbcc	r4, [pc], -r3, asr #16
    2568:	42003254 	andmi	r3, r0, #84, 4	; 0x40000005
    256c:	5f455341 	svcpl	0x00455341
    2570:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    2574:	5f4d385f 	svcpl	0x004d385f
    2578:	4e49414d 	dvfmiem	f4, f1, #5.0
    257c:	52415400 	subpl	r5, r1, #0, 8
    2580:	5f544547 	svcpl	0x00544547
    2584:	5f555043 	svcpl	0x00555043
    2588:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    258c:	696d6474 	stmdbvs	sp!, {r2, r4, r5, r6, sl, sp, lr}^
    2590:	4d524100 	ldfmie	f4, [r2, #-0]
    2594:	004c415f 	subeq	r4, ip, pc, asr r1
    2598:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    259c:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    25a0:	4d375f48 	ldcmi	15, cr5, [r7, #-288]!	; 0xfffffee0
    25a4:	6d726100 	ldfvse	f6, [r2, #-0]
    25a8:	7261745f 	rsbvc	r7, r1, #1593835520	; 0x5f000000
    25ac:	5f746567 	svcpl	0x00746567
    25b0:	6562616c 	strbvs	r6, [r2, #-364]!	; 0xfffffe94
    25b4:	7261006c 	rsbvc	r0, r1, #108	; 0x6c
    25b8:	61745f6d 	cmnvs	r4, sp, ror #30
    25bc:	74656772 	strbtvc	r6, [r5], #-1906	; 0xfffff88e
    25c0:	736e695f 	cmnvc	lr, #1556480	; 0x17c000
    25c4:	4154006e 	cmpmi	r4, lr, rrx
    25c8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    25cc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    25d0:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    25d4:	72786574 	rsbsvc	r6, r8, #116, 10	; 0x1d000000
    25d8:	41540034 	cmpmi	r4, r4, lsr r0
    25dc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    25e0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    25e4:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    25e8:	72786574 	rsbsvc	r6, r8, #116, 10	; 0x1d000000
    25ec:	41540035 	cmpmi	r4, r5, lsr r0
    25f0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    25f4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    25f8:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    25fc:	72786574 	rsbsvc	r6, r8, #116, 10	; 0x1d000000
    2600:	41540037 	cmpmi	r4, r7, lsr r0
    2604:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2608:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    260c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2610:	72786574 	rsbsvc	r6, r8, #116, 10	; 0x1d000000
    2614:	73690038 	cmnvc	r9, #56	; 0x38
    2618:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    261c:	706c5f74 	rsbvc	r5, ip, r4, ror pc
    2620:	69006561 	stmdbvs	r0, {r0, r5, r6, r8, sl, sp, lr}
    2624:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2628:	715f7469 	cmpvc	pc, r9, ror #8
    262c:	6b726975 	blvs	1c9cc08 <__bss_end+0x1c93c3c>
    2630:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2634:	7a6b3676 	bvc	1ad0014 <__bss_end+0x1ac7048>
    2638:	61736900 	cmnvs	r3, r0, lsl #18
    263c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2640:	746f6e5f 	strbtvc	r6, [pc], #-3679	; 2648 <shift+0x2648>
    2644:	7369006d 	cmnvc	r9, #109	; 0x6d
    2648:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    264c:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    2650:	0034766d 	eorseq	r7, r4, sp, ror #12
    2654:	5f617369 	svcpl	0x00617369
    2658:	5f746962 	svcpl	0x00746962
    265c:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    2660:	73690036 	cmnvc	r9, #54	; 0x36
    2664:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2668:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    266c:	0037766d 	eorseq	r7, r7, sp, ror #12
    2670:	5f617369 	svcpl	0x00617369
    2674:	5f746962 	svcpl	0x00746962
    2678:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    267c:	645f0038 	ldrbvs	r0, [pc], #-56	; 2684 <shift+0x2684>
    2680:	5f746e6f 	svcpl	0x00746e6f
    2684:	5f657375 	svcpl	0x00657375
    2688:	5f787472 	svcpl	0x00787472
    268c:	65726568 	ldrbvs	r6, [r2, #-1384]!	; 0xfffffa98
    2690:	5155005f 	cmppl	r5, pc, asr r0
    2694:	70797449 	rsbsvc	r7, r9, r9, asr #8
    2698:	73690065 	cmnvc	r9, #101	; 0x65
    269c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    26a0:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    26a4:	7435766d 	ldrtvc	r7, [r5], #-1645	; 0xfffff993
    26a8:	72610065 	rsbvc	r0, r1, #101	; 0x65
    26ac:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    26b0:	6100656e 	tstvs	r0, lr, ror #10
    26b4:	635f6d72 	cmpvs	pc, #7296	; 0x1c80
    26b8:	695f7070 	ldmdbvs	pc, {r4, r5, r6, ip, sp, lr}^	; <UNPREDICTABLE>
    26bc:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
    26c0:	6b726f77 	blvs	1c9e4a4 <__bss_end+0x1c954d8>
    26c4:	6e756600 	cdpvs	6, 7, cr6, cr5, cr0, {0}
    26c8:	74705f63 	ldrbtvc	r5, [r0], #-3939	; 0xfffff09d
    26cc:	41540072 	cmpmi	r4, r2, ror r0
    26d0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    26d4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    26d8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    26dc:	74303239 	ldrtvc	r3, [r0], #-569	; 0xfffffdc7
    26e0:	61746800 	cmnvs	r4, r0, lsl #16
    26e4:	71655f62 	cmnvc	r5, r2, ror #30
    26e8:	52415400 	subpl	r5, r1, #0, 8
    26ec:	5f544547 	svcpl	0x00544547
    26f0:	5f555043 	svcpl	0x00555043
    26f4:	32356166 	eorscc	r6, r5, #-2147483623	; 0x80000019
    26f8:	72610036 	rsbvc	r0, r1, #54	; 0x36
    26fc:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2700:	745f6863 	ldrbvc	r6, [pc], #-2147	; 2708 <shift+0x2708>
    2704:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    2708:	6477685f 	ldrbtvs	r6, [r7], #-2143	; 0xfffff7a1
    270c:	68007669 	stmdavs	r0, {r0, r3, r5, r6, r9, sl, ip, sp, lr}
    2710:	5f626174 	svcpl	0x00626174
    2714:	705f7165 	subsvc	r7, pc, r5, ror #2
    2718:	746e696f 	strbtvc	r6, [lr], #-2415	; 0xfffff691
    271c:	61007265 	tstvs	r0, r5, ror #4
    2720:	705f6d72 	subsvc	r6, pc, r2, ror sp	; <UNPREDICTABLE>
    2724:	725f6369 	subsvc	r6, pc, #-1543503871	; 0xa4000001
    2728:	73696765 	cmnvc	r9, #26476544	; 0x1940000
    272c:	00726574 	rsbseq	r6, r2, r4, ror r5
    2730:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2734:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2738:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    273c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2740:	73306d78 	teqvc	r0, #120, 26	; 0x1e00
    2744:	6c6c616d 	stfvse	f6, [ip], #-436	; 0xfffffe4c
    2748:	746c756d 	strbtvc	r7, [ip], #-1389	; 0xfffffa93
    274c:	796c7069 	stmdbvc	ip!, {r0, r3, r5, r6, ip, sp, lr}^
    2750:	52415400 	subpl	r5, r1, #0, 8
    2754:	5f544547 	svcpl	0x00544547
    2758:	5f555043 	svcpl	0x00555043
    275c:	6f63706d 	svcvs	0x0063706d
    2760:	6f6e6572 	svcvs	0x006e6572
    2764:	00706676 	rsbseq	r6, r0, r6, ror r6
    2768:	5f617369 	svcpl	0x00617369
    276c:	5f746962 	svcpl	0x00746962
    2770:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    2774:	6d635f6b 	stclvs	15, cr5, [r3, #-428]!	; 0xfffffe54
    2778:	646c5f33 	strbtvs	r5, [ip], #-3891	; 0xfffff0cd
    277c:	41006472 	tstmi	r0, r2, ror r4
    2780:	435f4d52 	cmpmi	pc, #5248	; 0x1480
    2784:	72610043 	rsbvc	r0, r1, #67	; 0x43
    2788:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    278c:	5f386863 	svcpl	0x00386863
    2790:	72610032 	rsbvc	r0, r1, #50	; 0x32
    2794:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2798:	5f386863 	svcpl	0x00386863
    279c:	72610033 	rsbvc	r0, r1, #51	; 0x33
    27a0:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    27a4:	5f386863 	svcpl	0x00386863
    27a8:	41540034 	cmpmi	r4, r4, lsr r0
    27ac:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    27b0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    27b4:	706d665f 	rsbvc	r6, sp, pc, asr r6
    27b8:	00363236 	eorseq	r3, r6, r6, lsr r2
    27bc:	5f4d5241 	svcpl	0x004d5241
    27c0:	61005343 	tstvs	r0, r3, asr #6
    27c4:	665f6d72 			; <UNDEFINED> instruction: 0x665f6d72
    27c8:	5f363170 	svcpl	0x00363170
    27cc:	74736e69 	ldrbtvc	r6, [r3], #-3689	; 0xfffff197
    27d0:	6d726100 	ldfvse	f6, [r2, #-0]
    27d4:	7361625f 	cmnvc	r1, #-268435451	; 0xf0000005
    27d8:	72615f65 	rsbvc	r5, r1, #404	; 0x194
    27dc:	54006863 	strpl	r6, [r0], #-2147	; 0xfffff79d
    27e0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    27e4:	50435f54 	subpl	r5, r3, r4, asr pc
    27e8:	6f635f55 	svcvs	0x00635f55
    27ec:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    27f0:	63353161 	teqvs	r5, #1073741848	; 0x40000018
    27f4:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    27f8:	00376178 	eorseq	r6, r7, r8, ror r1
    27fc:	5f6d7261 	svcpl	0x006d7261
    2800:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2804:	006d6537 	rsbeq	r6, sp, r7, lsr r5
    2808:	47524154 			; <UNDEFINED> instruction: 0x47524154
    280c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2810:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2814:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2818:	32376178 	eorscc	r6, r7, #120, 2
    281c:	6d726100 	ldfvse	f6, [r2, #-0]
    2820:	7363705f 	cmnvc	r3, #95	; 0x5f
    2824:	6665645f 			; <UNDEFINED> instruction: 0x6665645f
    2828:	746c7561 	strbtvc	r7, [ip], #-1377	; 0xfffffa9f
    282c:	4d524100 	ldfmie	f4, [r2, #-0]
    2830:	5343505f 	movtpl	r5, #12383	; 0x305f
    2834:	5041415f 	subpl	r4, r1, pc, asr r1
    2838:	4c5f5343 	mrrcmi	3, 4, r5, pc, cr3	; <UNPREDICTABLE>
    283c:	4c41434f 	mcrrmi	3, 4, r4, r1, cr15
    2840:	52415400 	subpl	r5, r1, #0, 8
    2844:	5f544547 	svcpl	0x00544547
    2848:	5f555043 	svcpl	0x00555043
    284c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2850:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    2854:	41540035 	cmpmi	r4, r5, lsr r0
    2858:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    285c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2860:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
    2864:	61676e6f 	cmnvs	r7, pc, ror #28
    2868:	61006d72 	tstvs	r0, r2, ror sp
    286c:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2870:	5f686372 	svcpl	0x00686372
    2874:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    2878:	61003162 	tstvs	r0, r2, ror #2
    287c:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2880:	5f686372 	svcpl	0x00686372
    2884:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    2888:	54003262 	strpl	r3, [r0], #-610	; 0xfffffd9e
    288c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2890:	50435f54 	subpl	r5, r3, r4, asr pc
    2894:	77695f55 			; <UNDEFINED> instruction: 0x77695f55
    2898:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    289c:	6d726100 	ldfvse	f6, [r2, #-0]
    28a0:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    28a4:	00743568 	rsbseq	r3, r4, r8, ror #10
    28a8:	5f617369 	svcpl	0x00617369
    28ac:	5f746962 	svcpl	0x00746962
    28b0:	6100706d 	tstvs	r0, sp, rrx
    28b4:	6c5f6d72 	mrrcvs	13, 7, r6, pc, cr2	; <UNPREDICTABLE>
    28b8:	63735f64 	cmnvs	r3, #100, 30	; 0x190
    28bc:	00646568 	rsbeq	r6, r4, r8, ror #10
    28c0:	5f6d7261 	svcpl	0x006d7261
    28c4:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    28c8:	00315f38 	eorseq	r5, r1, r8, lsr pc

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
  20:	8b040e42 	blhi	103930 <__bss_end+0xfa964>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x347864>
  28:	420d0d68 	andmi	r0, sp, #104, 26	; 0x1a00
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008070 	andeq	r8, r0, r0, ror r0
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1fa984>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xf9cb4>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080b0 	strheq	r8, [r0], -r0
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xfa9b4>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x3478b4>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080e8 	andeq	r8, r0, r8, ror #1
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xfa9d4>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x3478d4>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008114 	andeq	r8, r0, r4, lsl r1
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xfa9f4>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x3478f4>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008134 	andeq	r8, r0, r4, lsr r1
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xfaa14>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x347914>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	0000814c 	andeq	r8, r0, ip, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xfaa34>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x347934>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008164 	andeq	r8, r0, r4, ror #2
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xfaa54>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x347954>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	0000817c 	andeq	r8, r0, ip, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xfaa74>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x347974>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	00008188 	andeq	r8, r0, r8, lsl #3
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1faa8c>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081e0 	andeq	r8, r0, r0, ror #3
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1faaac>
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
 194:	00000194 	muleq	r0, r4, r1
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1faadc>
 19c:	42018e02 	andmi	r8, r1, #2, 28
 1a0:	00040b0c 	andeq	r0, r4, ip, lsl #22
 1a4:	0000000c 	andeq	r0, r0, ip
 1a8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 1ac:	7c020001 	stcvc	0, cr0, [r2], {1}
 1b0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 1b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1bc:	000083cc 	andeq	r8, r0, ip, asr #7
 1c0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1c4:	8b040e42 	blhi	103ad4 <__bss_end+0xfab08>
 1c8:	0b0d4201 	bleq	3509d4 <__bss_end+0x347a08>
 1cc:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1dc:	000083f8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 1e0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1e4:	8b040e42 	blhi	103af4 <__bss_end+0xfab28>
 1e8:	0b0d4201 	bleq	3509f4 <__bss_end+0x347a28>
 1ec:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1fc:	00008424 	andeq	r8, r0, r4, lsr #8
 200:	0000001c 	andeq	r0, r0, ip, lsl r0
 204:	8b040e42 	blhi	103b14 <__bss_end+0xfab48>
 208:	0b0d4201 	bleq	350a14 <__bss_end+0x347a48>
 20c:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 210:	00000ecb 	andeq	r0, r0, fp, asr #29
 214:	0000001c 	andeq	r0, r0, ip, lsl r0
 218:	000001a4 	andeq	r0, r0, r4, lsr #3
 21c:	00008440 	andeq	r8, r0, r0, asr #8
 220:	00000044 	andeq	r0, r0, r4, asr #32
 224:	8b040e42 	blhi	103b34 <__bss_end+0xfab68>
 228:	0b0d4201 	bleq	350a34 <__bss_end+0x347a68>
 22c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 230:	00000ecb 	andeq	r0, r0, fp, asr #29
 234:	0000001c 	andeq	r0, r0, ip, lsl r0
 238:	000001a4 	andeq	r0, r0, r4, lsr #3
 23c:	00008484 	andeq	r8, r0, r4, lsl #9
 240:	00000050 	andeq	r0, r0, r0, asr r0
 244:	8b040e42 	blhi	103b54 <__bss_end+0xfab88>
 248:	0b0d4201 	bleq	350a54 <__bss_end+0x347a88>
 24c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 250:	00000ecb 	andeq	r0, r0, fp, asr #29
 254:	0000001c 	andeq	r0, r0, ip, lsl r0
 258:	000001a4 	andeq	r0, r0, r4, lsr #3
 25c:	000084d4 	ldrdeq	r8, [r0], -r4
 260:	00000050 	andeq	r0, r0, r0, asr r0
 264:	8b040e42 	blhi	103b74 <__bss_end+0xfaba8>
 268:	0b0d4201 	bleq	350a74 <__bss_end+0x347aa8>
 26c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 270:	00000ecb 	andeq	r0, r0, fp, asr #29
 274:	0000001c 	andeq	r0, r0, ip, lsl r0
 278:	000001a4 	andeq	r0, r0, r4, lsr #3
 27c:	00008524 	andeq	r8, r0, r4, lsr #10
 280:	0000002c 	andeq	r0, r0, ip, lsr #32
 284:	8b040e42 	blhi	103b94 <__bss_end+0xfabc8>
 288:	0b0d4201 	bleq	350a94 <__bss_end+0x347ac8>
 28c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 290:	00000ecb 	andeq	r0, r0, fp, asr #29
 294:	0000001c 	andeq	r0, r0, ip, lsl r0
 298:	000001a4 	andeq	r0, r0, r4, lsr #3
 29c:	00008550 	andeq	r8, r0, r0, asr r5
 2a0:	00000050 	andeq	r0, r0, r0, asr r0
 2a4:	8b040e42 	blhi	103bb4 <__bss_end+0xfabe8>
 2a8:	0b0d4201 	bleq	350ab4 <__bss_end+0x347ae8>
 2ac:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2bc:	000085a0 	andeq	r8, r0, r0, lsr #11
 2c0:	00000044 	andeq	r0, r0, r4, asr #32
 2c4:	8b040e42 	blhi	103bd4 <__bss_end+0xfac08>
 2c8:	0b0d4201 	bleq	350ad4 <__bss_end+0x347b08>
 2cc:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 2d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2dc:	000085e4 	andeq	r8, r0, r4, ror #11
 2e0:	00000050 	andeq	r0, r0, r0, asr r0
 2e4:	8b040e42 	blhi	103bf4 <__bss_end+0xfac28>
 2e8:	0b0d4201 	bleq	350af4 <__bss_end+0x347b28>
 2ec:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2fc:	00008634 	andeq	r8, r0, r4, lsr r6
 300:	00000054 	andeq	r0, r0, r4, asr r0
 304:	8b040e42 	blhi	103c14 <__bss_end+0xfac48>
 308:	0b0d4201 	bleq	350b14 <__bss_end+0x347b48>
 30c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 310:	00000ecb 	andeq	r0, r0, fp, asr #29
 314:	0000001c 	andeq	r0, r0, ip, lsl r0
 318:	000001a4 	andeq	r0, r0, r4, lsr #3
 31c:	00008688 	andeq	r8, r0, r8, lsl #13
 320:	0000003c 	andeq	r0, r0, ip, lsr r0
 324:	8b040e42 	blhi	103c34 <__bss_end+0xfac68>
 328:	0b0d4201 	bleq	350b34 <__bss_end+0x347b68>
 32c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 330:	00000ecb 	andeq	r0, r0, fp, asr #29
 334:	0000001c 	andeq	r0, r0, ip, lsl r0
 338:	000001a4 	andeq	r0, r0, r4, lsr #3
 33c:	000086c4 	andeq	r8, r0, r4, asr #13
 340:	0000003c 	andeq	r0, r0, ip, lsr r0
 344:	8b040e42 	blhi	103c54 <__bss_end+0xfac88>
 348:	0b0d4201 	bleq	350b54 <__bss_end+0x347b88>
 34c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 350:	00000ecb 	andeq	r0, r0, fp, asr #29
 354:	0000001c 	andeq	r0, r0, ip, lsl r0
 358:	000001a4 	andeq	r0, r0, r4, lsr #3
 35c:	00008700 	andeq	r8, r0, r0, lsl #14
 360:	0000003c 	andeq	r0, r0, ip, lsr r0
 364:	8b040e42 	blhi	103c74 <__bss_end+0xfaca8>
 368:	0b0d4201 	bleq	350b74 <__bss_end+0x347ba8>
 36c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 370:	00000ecb 	andeq	r0, r0, fp, asr #29
 374:	0000001c 	andeq	r0, r0, ip, lsl r0
 378:	000001a4 	andeq	r0, r0, r4, lsr #3
 37c:	0000873c 	andeq	r8, r0, ip, lsr r7
 380:	0000003c 	andeq	r0, r0, ip, lsr r0
 384:	8b040e42 	blhi	103c94 <__bss_end+0xfacc8>
 388:	0b0d4201 	bleq	350b94 <__bss_end+0x347bc8>
 38c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 390:	00000ecb 	andeq	r0, r0, fp, asr #29
 394:	0000001c 	andeq	r0, r0, ip, lsl r0
 398:	000001a4 	andeq	r0, r0, r4, lsr #3
 39c:	00008778 	andeq	r8, r0, r8, ror r7
 3a0:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 3a4:	8b080e42 	blhi	203cb4 <__bss_end+0x1face8>
 3a8:	42018e02 	andmi	r8, r1, #2, 28
 3ac:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3b0:	080d0c50 	stmdaeq	sp, {r4, r6, sl, fp}
 3b4:	0000000c 	andeq	r0, r0, ip
 3b8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 3bc:	7c020001 	stcvc	0, cr0, [r2], {1}
 3c0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 3c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3c8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3cc:	00008828 	andeq	r8, r0, r8, lsr #16
 3d0:	00000174 	andeq	r0, r0, r4, ror r1
 3d4:	8b080e42 	blhi	203ce4 <__bss_end+0x1fad18>
 3d8:	42018e02 	andmi	r8, r1, #2, 28
 3dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3e0:	080d0cb2 	stmdaeq	sp, {r1, r4, r5, r7, sl, fp}
 3e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3e8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3ec:	0000899c 	muleq	r0, ip, r9
 3f0:	0000009c 	muleq	r0, ip, r0
 3f4:	8b040e42 	blhi	103d04 <__bss_end+0xfad38>
 3f8:	0b0d4201 	bleq	350c04 <__bss_end+0x347c38>
 3fc:	0d0d4602 	stceq	6, cr4, [sp, #-8]
 400:	000ecb42 	andeq	ip, lr, r2, asr #22
 404:	0000001c 	andeq	r0, r0, ip, lsl r0
 408:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 40c:	00008a38 	andeq	r8, r0, r8, lsr sl
 410:	000000c0 	andeq	r0, r0, r0, asr #1
 414:	8b040e42 	blhi	103d24 <__bss_end+0xfad58>
 418:	0b0d4201 	bleq	350c24 <__bss_end+0x347c58>
 41c:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 420:	000ecb42 	andeq	ip, lr, r2, asr #22
 424:	0000001c 	andeq	r0, r0, ip, lsl r0
 428:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 42c:	00008af8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 430:	000000ac 	andeq	r0, r0, ip, lsr #1
 434:	8b040e42 	blhi	103d44 <__bss_end+0xfad78>
 438:	0b0d4201 	bleq	350c44 <__bss_end+0x347c78>
 43c:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 440:	000ecb42 	andeq	ip, lr, r2, asr #22
 444:	0000001c 	andeq	r0, r0, ip, lsl r0
 448:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 44c:	00008ba4 	andeq	r8, r0, r4, lsr #23
 450:	00000054 	andeq	r0, r0, r4, asr r0
 454:	8b040e42 	blhi	103d64 <__bss_end+0xfad98>
 458:	0b0d4201 	bleq	350c64 <__bss_end+0x347c98>
 45c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 460:	00000ecb 	andeq	r0, r0, fp, asr #29
 464:	0000001c 	andeq	r0, r0, ip, lsl r0
 468:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 46c:	00008bf8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 470:	00000068 	andeq	r0, r0, r8, rrx
 474:	8b040e42 	blhi	103d84 <__bss_end+0xfadb8>
 478:	0b0d4201 	bleq	350c84 <__bss_end+0x347cb8>
 47c:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 480:	00000ecb 	andeq	r0, r0, fp, asr #29
 484:	0000001c 	andeq	r0, r0, ip, lsl r0
 488:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 48c:	00008c60 	andeq	r8, r0, r0, ror #24
 490:	00000080 	andeq	r0, r0, r0, lsl #1
 494:	8b040e42 	blhi	103da4 <__bss_end+0xfadd8>
 498:	0b0d4201 	bleq	350ca4 <__bss_end+0x347cd8>
 49c:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 4a0:	00000ecb 	andeq	r0, r0, fp, asr #29
 4a4:	0000000c 	andeq	r0, r0, ip
 4a8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 4ac:	7c010001 	stcvc	0, cr0, [r1], {1}
 4b0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 4b4:	0000000c 	andeq	r0, r0, ip
 4b8:	000004a4 	andeq	r0, r0, r4, lsr #9
 4bc:	00008ce0 	andeq	r8, r0, r0, ror #25
 4c0:	000001ec 	andeq	r0, r0, ip, ror #3
