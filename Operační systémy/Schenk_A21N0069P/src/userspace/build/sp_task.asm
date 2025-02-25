
./sp_task:     file format elf32-littlearm


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
    8000:	eb000017 	bl	8064 <__crt0_run>

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
    for (unsigned int* cur = &__bss_start; cur < &__bss_end; cur++)
    8014:	e59f3040 	ldr	r3, [pc, #64]	; 805c <__crt0_init_bss+0x54>
    8018:	e50b3008 	str	r3, [fp, #-8]
    801c:	ea000005 	b	8038 <__crt0_init_bss+0x30>
/home/schenkj/os2022/sp/sources/userspace/crt0.c:12 (discriminator 3)
        *cur = 0;
    8020:	e51b3008 	ldr	r3, [fp, #-8]
    8024:	e3a02000 	mov	r2, #0
    8028:	e5832000 	str	r2, [r3]
/home/schenkj/os2022/sp/sources/userspace/crt0.c:11 (discriminator 3)
    for (unsigned int* cur = &__bss_start; cur < &__bss_end; cur++)
    802c:	e51b3008 	ldr	r3, [fp, #-8]
    8030:	e2833004 	add	r3, r3, #4
    8034:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/userspace/crt0.c:11 (discriminator 1)
    8038:	e51b3008 	ldr	r3, [fp, #-8]
    803c:	e59f201c 	ldr	r2, [pc, #28]	; 8060 <__crt0_init_bss+0x58>
    8040:	e1530002 	cmp	r3, r2
    8044:	3afffff5 	bcc	8020 <__crt0_init_bss+0x18>
/home/schenkj/os2022/sp/sources/userspace/crt0.c:13
}
    8048:	e320f000 	nop	{0}
    804c:	e320f000 	nop	{0}
    8050:	e28bd000 	add	sp, fp, #0
    8054:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8058:	e12fff1e 	bx	lr
    805c:	0000b468 	andeq	fp, r0, r8, ror #8
    8060:	0000b938 	andeq	fp, r0, r8, lsr r9

00008064 <__crt0_run>:
__crt0_run():
/home/schenkj/os2022/sp/sources/userspace/crt0.c:16

void __crt0_run()
{
    8064:	e92d4800 	push	{fp, lr}
    8068:	e28db004 	add	fp, sp, #4
    806c:	e24dd008 	sub	sp, sp, #8
/home/schenkj/os2022/sp/sources/userspace/crt0.c:18
    // inicializace .bss sekce (vynulovani)
    __crt0_init_bss();
    8070:	ebffffe4 	bl	8008 <__crt0_init_bss>
/home/schenkj/os2022/sp/sources/userspace/crt0.c:21

    // volani konstruktoru globalnich trid (C++)
    _cpp_startup();
    8074:	eb000040 	bl	817c <_cpp_startup>
/home/schenkj/os2022/sp/sources/userspace/crt0.c:26

    // volani funkce main
    // nebudeme se zde zabyvat predavanim parametru do funkce main
    // jinak by se mohly predavat napr. namapovane do virtualniho adr. prostoru a odkazem pres zasobnik (kam nam muze OS pushnout co chce)
    int result = main(0, 0);
    8078:	e3a01000 	mov	r1, #0
    807c:	e3a00000 	mov	r0, #0
    8080:	eb000602 	bl	9890 <main>
    8084:	e50b0008 	str	r0, [fp, #-8]
/home/schenkj/os2022/sp/sources/userspace/crt0.c:29

    // volani destruktoru globalnich trid (C++)
    _cpp_shutdown();
    8088:	eb000051 	bl	81d4 <_cpp_shutdown>
/home/schenkj/os2022/sp/sources/userspace/crt0.c:32

    // volani terminate() syscallu s navratovym kodem funkce main
    asm volatile("mov r0, %0" : : "r" (result));
    808c:	e51b3008 	ldr	r3, [fp, #-8]
    8090:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/userspace/crt0.c:33
    asm volatile("svc #1");
    8094:	ef000001 	svc	0x00000001
/home/schenkj/os2022/sp/sources/userspace/crt0.c:34
}
    8098:	e320f000 	nop	{0}
    809c:	e24bd004 	sub	sp, fp, #4
    80a0:	e8bd8800 	pop	{fp, pc}

000080a4 <__cxa_guard_acquire>:
__cxa_guard_acquire():
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:11
	extern "C" int __cxa_guard_acquire (__guard *);
	extern "C" void __cxa_guard_release (__guard *);
	extern "C" void __cxa_guard_abort (__guard *);

	extern "C" int __cxa_guard_acquire (__guard *g)
	{
    80a4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80a8:	e28db000 	add	fp, sp, #0
    80ac:	e24dd00c 	sub	sp, sp, #12
    80b0:	e50b0008 	str	r0, [fp, #-8]
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:12
		return !*(char *)(g);
    80b4:	e51b3008 	ldr	r3, [fp, #-8]
    80b8:	e5d33000 	ldrb	r3, [r3]
    80bc:	e3530000 	cmp	r3, #0
    80c0:	03a03001 	moveq	r3, #1
    80c4:	13a03000 	movne	r3, #0
    80c8:	e6ef3073 	uxtb	r3, r3
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:13
	}
    80cc:	e1a00003 	mov	r0, r3
    80d0:	e28bd000 	add	sp, fp, #0
    80d4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    80d8:	e12fff1e 	bx	lr

000080dc <__cxa_guard_release>:
__cxa_guard_release():
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:16

	extern "C" void __cxa_guard_release (__guard *g)
	{
    80dc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    80e0:	e28db000 	add	fp, sp, #0
    80e4:	e24dd00c 	sub	sp, sp, #12
    80e8:	e50b0008 	str	r0, [fp, #-8]
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:17
		*(char *)g = 1;
    80ec:	e51b3008 	ldr	r3, [fp, #-8]
    80f0:	e3a02001 	mov	r2, #1
    80f4:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:18
	}
    80f8:	e320f000 	nop	{0}
    80fc:	e28bd000 	add	sp, fp, #0
    8100:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8104:	e12fff1e 	bx	lr

00008108 <__cxa_guard_abort>:
__cxa_guard_abort():
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:21

	extern "C" void __cxa_guard_abort (__guard *)
	{
    8108:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    810c:	e28db000 	add	fp, sp, #0
    8110:	e24dd00c 	sub	sp, sp, #12
    8114:	e50b0008 	str	r0, [fp, #-8]
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:23

	}
    8118:	e320f000 	nop	{0}
    811c:	e28bd000 	add	sp, fp, #0
    8120:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8124:	e12fff1e 	bx	lr

00008128 <__dso_handle>:
__dso_handle():
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:27
}

extern "C" void __dso_handle()
{
    8128:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    812c:	e28db000 	add	fp, sp, #0
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:29
    // ignore dtors for now
}
    8130:	e320f000 	nop	{0}
    8134:	e28bd000 	add	sp, fp, #0
    8138:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    813c:	e12fff1e 	bx	lr

00008140 <__cxa_atexit>:
__cxa_atexit():
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:32

extern "C" void __cxa_atexit()
{
    8140:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8144:	e28db000 	add	fp, sp, #0
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:34
    // ignore dtors for now
}
    8148:	e320f000 	nop	{0}
    814c:	e28bd000 	add	sp, fp, #0
    8150:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8154:	e12fff1e 	bx	lr

00008158 <__cxa_pure_virtual>:
__cxa_pure_virtual():
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:37

extern "C" void __cxa_pure_virtual()
{
    8158:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    815c:	e28db000 	add	fp, sp, #0
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:39
    // pure virtual method called
}
    8160:	e320f000 	nop	{0}
    8164:	e28bd000 	add	sp, fp, #0
    8168:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    816c:	e12fff1e 	bx	lr

00008170 <__aeabi_unwind_cpp_pr1>:
__aeabi_unwind_cpp_pr1():
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:42

extern "C" void __aeabi_unwind_cpp_pr1()
{
    8170:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8174:	e28db000 	add	fp, sp, #0
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:43 (discriminator 1)
	while (true)
    8178:	eafffffe 	b	8178 <__aeabi_unwind_cpp_pr1+0x8>

0000817c <_cpp_startup>:
_cpp_startup():
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:61
extern "C" dtor_ptr __DTOR_LIST__[0];
// konec pole destruktoru
extern "C" dtor_ptr __DTOR_END__[0];

extern "C" int _cpp_startup(void)
{
    817c:	e92d4800 	push	{fp, lr}
    8180:	e28db004 	add	fp, sp, #4
    8184:	e24dd008 	sub	sp, sp, #8
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:66
	ctor_ptr* fnptr;
	
	// zavolame konstruktory globalnich C++ trid
	// v poli __CTOR_LIST__ jsou ukazatele na vygenerovane stuby volani konstruktoru
	for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    8188:	e59f303c 	ldr	r3, [pc, #60]	; 81cc <_cpp_startup+0x50>
    818c:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:66 (discriminator 3)
    8190:	e51b3008 	ldr	r3, [fp, #-8]
    8194:	e59f2034 	ldr	r2, [pc, #52]	; 81d0 <_cpp_startup+0x54>
    8198:	e1530002 	cmp	r3, r2
    819c:	2a000006 	bcs	81bc <_cpp_startup+0x40>
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:67 (discriminator 2)
		(*fnptr)();
    81a0:	e51b3008 	ldr	r3, [fp, #-8]
    81a4:	e5933000 	ldr	r3, [r3]
    81a8:	e12fff33 	blx	r3
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:66 (discriminator 2)
	for (fnptr = __CTOR_LIST__; fnptr < __CTOR_END__; fnptr++)
    81ac:	e51b3008 	ldr	r3, [fp, #-8]
    81b0:	e2833004 	add	r3, r3, #4
    81b4:	e50b3008 	str	r3, [fp, #-8]
    81b8:	eafffff4 	b	8190 <_cpp_startup+0x14>
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:69
	
	return 0;
    81bc:	e3a03000 	mov	r3, #0
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:70
}
    81c0:	e1a00003 	mov	r0, r3
    81c4:	e24bd004 	sub	sp, fp, #4
    81c8:	e8bd8800 	pop	{fp, pc}
    81cc:	0000b460 	andeq	fp, r0, r0, ror #8
    81d0:	0000b464 	andeq	fp, r0, r4, ror #8

000081d4 <_cpp_shutdown>:
_cpp_shutdown():
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:73

extern "C" int _cpp_shutdown(void)
{
    81d4:	e92d4800 	push	{fp, lr}
    81d8:	e28db004 	add	fp, sp, #4
    81dc:	e24dd008 	sub	sp, sp, #8
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:77
	dtor_ptr* fnptr;
	
	// zavolame destruktory globalnich C++ trid
	for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    81e0:	e59f303c 	ldr	r3, [pc, #60]	; 8224 <_cpp_shutdown+0x50>
    81e4:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:77 (discriminator 3)
    81e8:	e51b3008 	ldr	r3, [fp, #-8]
    81ec:	e59f2034 	ldr	r2, [pc, #52]	; 8228 <_cpp_shutdown+0x54>
    81f0:	e1530002 	cmp	r3, r2
    81f4:	2a000006 	bcs	8214 <_cpp_shutdown+0x40>
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:78 (discriminator 2)
		(*fnptr)();
    81f8:	e51b3008 	ldr	r3, [fp, #-8]
    81fc:	e5933000 	ldr	r3, [r3]
    8200:	e12fff33 	blx	r3
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:77 (discriminator 2)
	for (fnptr = __DTOR_LIST__; fnptr < __DTOR_END__; fnptr++)
    8204:	e51b3008 	ldr	r3, [fp, #-8]
    8208:	e2833004 	add	r3, r3, #4
    820c:	e50b3008 	str	r3, [fp, #-8]
    8210:	eafffff4 	b	81e8 <_cpp_shutdown+0x14>
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:80
	
	return 0;
    8214:	e3a03000 	mov	r3, #0
/home/schenkj/os2022/sp/sources/userspace/cxxabi.cpp:81
}
    8218:	e1a00003 	mov	r0, r3
    821c:	e24bd004 	sub	sp, fp, #4
    8220:	e8bd8800 	pop	{fp, pc}
    8224:	0000b464 	andeq	fp, r0, r4, ror #8
    8228:	0000b464 	andeq	fp, r0, r4, ror #8
    822c:	00000000 	andeq	r0, r0, r0

00008230 <_Z3genii>:
_Z3genii():
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:54
//if there is generated new member of population etc. this defines range in which parameterrs are
const uint32_t RANDOM_RANGE = 50;


//get from two dimensional array gen(x,y) => generation[x,y];
float gen(int x, int y){
    8230:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8234:	e28db000 	add	fp, sp, #0
    8238:	e24dd00c 	sub	sp, sp, #12
    823c:	e50b0008 	str	r0, [fp, #-8]
    8240:	e50b100c 	str	r1, [fp, #-12]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:55
	if(y==0)return generationA[x];
    8244:	e51b300c 	ldr	r3, [fp, #-12]
    8248:	e3530000 	cmp	r3, #0
    824c:	1a000005 	bne	8268 <_Z3genii+0x38>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:55 (discriminator 1)
    8250:	e59f20b8 	ldr	r2, [pc, #184]	; 8310 <_Z3genii+0xe0>
    8254:	e51b3008 	ldr	r3, [fp, #-8]
    8258:	e1a03103 	lsl	r3, r3, #2
    825c:	e0823003 	add	r3, r2, r3
    8260:	e5933000 	ldr	r3, [r3]
    8264:	ea000024 	b	82fc <_Z3genii+0xcc>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:56
	else if(y==1)return generationB[x];
    8268:	e51b300c 	ldr	r3, [fp, #-12]
    826c:	e3530001 	cmp	r3, #1
    8270:	1a000005 	bne	828c <_Z3genii+0x5c>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:56 (discriminator 1)
    8274:	e59f2098 	ldr	r2, [pc, #152]	; 8314 <_Z3genii+0xe4>
    8278:	e51b3008 	ldr	r3, [fp, #-8]
    827c:	e1a03103 	lsl	r3, r3, #2
    8280:	e0823003 	add	r3, r2, r3
    8284:	e5933000 	ldr	r3, [r3]
    8288:	ea00001b 	b	82fc <_Z3genii+0xcc>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:57
	else if(y==2)return generationC[x];
    828c:	e51b300c 	ldr	r3, [fp, #-12]
    8290:	e3530002 	cmp	r3, #2
    8294:	1a000005 	bne	82b0 <_Z3genii+0x80>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:57 (discriminator 1)
    8298:	e59f2078 	ldr	r2, [pc, #120]	; 8318 <_Z3genii+0xe8>
    829c:	e51b3008 	ldr	r3, [fp, #-8]
    82a0:	e1a03103 	lsl	r3, r3, #2
    82a4:	e0823003 	add	r3, r2, r3
    82a8:	e5933000 	ldr	r3, [r3]
    82ac:	ea000012 	b	82fc <_Z3genii+0xcc>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:58
	else if(y==3)return generationD[x];
    82b0:	e51b300c 	ldr	r3, [fp, #-12]
    82b4:	e3530003 	cmp	r3, #3
    82b8:	1a000005 	bne	82d4 <_Z3genii+0xa4>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:58 (discriminator 1)
    82bc:	e59f2058 	ldr	r2, [pc, #88]	; 831c <_Z3genii+0xec>
    82c0:	e51b3008 	ldr	r3, [fp, #-8]
    82c4:	e1a03103 	lsl	r3, r3, #2
    82c8:	e0823003 	add	r3, r2, r3
    82cc:	e5933000 	ldr	r3, [r3]
    82d0:	ea000009 	b	82fc <_Z3genii+0xcc>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:59
	else if(y==4)return generationE[x];
    82d4:	e51b300c 	ldr	r3, [fp, #-12]
    82d8:	e3530004 	cmp	r3, #4
    82dc:	1a000005 	bne	82f8 <_Z3genii+0xc8>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:59 (discriminator 1)
    82e0:	e59f2038 	ldr	r2, [pc, #56]	; 8320 <_Z3genii+0xf0>
    82e4:	e51b3008 	ldr	r3, [fp, #-8]
    82e8:	e1a03103 	lsl	r3, r3, #2
    82ec:	e0823003 	add	r3, r2, r3
    82f0:	e5933000 	ldr	r3, [r3]
    82f4:	ea000000 	b	82fc <_Z3genii+0xcc>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:60
	else return 0;
    82f8:	e3a03000 	mov	r3, #0
    82fc:	ee073a90 	vmov	s15, r3
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:61
}
    8300:	eeb00a67 	vmov.f32	s0, s15
    8304:	e28bd000 	add	sp, fp, #0
    8308:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    830c:	e12fff1e 	bx	lr
    8310:	0000b47c 	andeq	fp, r0, ip, ror r4
    8314:	0000b544 	andeq	fp, r0, r4, asr #10
    8318:	0000b60c 	andeq	fp, r0, ip, lsl #12
    831c:	0000b6d4 	ldrdeq	fp, [r0], -r4
    8320:	0000b79c 	muleq	r0, ip, r7

00008324 <_Z5genIsiif>:
_Z5genIsiif():
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:63
//set for two dimensional array genIs(x,y,val) => generation[x,y]=val;
void genIs(int x, int y, float value){
    8324:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8328:	e28db000 	add	fp, sp, #0
    832c:	e24dd014 	sub	sp, sp, #20
    8330:	e50b0008 	str	r0, [fp, #-8]
    8334:	e50b100c 	str	r1, [fp, #-12]
    8338:	ed0b0a04 	vstr	s0, [fp, #-16]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:64
	if(y==0) generationA[x]=value;
    833c:	e51b300c 	ldr	r3, [fp, #-12]
    8340:	e3530000 	cmp	r3, #0
    8344:	1a000006 	bne	8364 <_Z5genIsiif+0x40>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:64 (discriminator 1)
    8348:	e59f20c4 	ldr	r2, [pc, #196]	; 8414 <_Z5genIsiif+0xf0>
    834c:	e51b3008 	ldr	r3, [fp, #-8]
    8350:	e1a03103 	lsl	r3, r3, #2
    8354:	e0823003 	add	r3, r2, r3
    8358:	e51b2010 	ldr	r2, [fp, #-16]
    835c:	e5832000 	str	r2, [r3]
    8360:	ea000028 	b	8408 <_Z5genIsiif+0xe4>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:65
	else if(y==1) generationB[x]=value;
    8364:	e51b300c 	ldr	r3, [fp, #-12]
    8368:	e3530001 	cmp	r3, #1
    836c:	1a000006 	bne	838c <_Z5genIsiif+0x68>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:65 (discriminator 1)
    8370:	e59f20a0 	ldr	r2, [pc, #160]	; 8418 <_Z5genIsiif+0xf4>
    8374:	e51b3008 	ldr	r3, [fp, #-8]
    8378:	e1a03103 	lsl	r3, r3, #2
    837c:	e0823003 	add	r3, r2, r3
    8380:	e51b2010 	ldr	r2, [fp, #-16]
    8384:	e5832000 	str	r2, [r3]
    8388:	ea00001e 	b	8408 <_Z5genIsiif+0xe4>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:66
	else if(y==2) generationC[x]=value;
    838c:	e51b300c 	ldr	r3, [fp, #-12]
    8390:	e3530002 	cmp	r3, #2
    8394:	1a000006 	bne	83b4 <_Z5genIsiif+0x90>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:66 (discriminator 1)
    8398:	e59f207c 	ldr	r2, [pc, #124]	; 841c <_Z5genIsiif+0xf8>
    839c:	e51b3008 	ldr	r3, [fp, #-8]
    83a0:	e1a03103 	lsl	r3, r3, #2
    83a4:	e0823003 	add	r3, r2, r3
    83a8:	e51b2010 	ldr	r2, [fp, #-16]
    83ac:	e5832000 	str	r2, [r3]
    83b0:	ea000014 	b	8408 <_Z5genIsiif+0xe4>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:67
	else if(y==3) generationD[x]=value;
    83b4:	e51b300c 	ldr	r3, [fp, #-12]
    83b8:	e3530003 	cmp	r3, #3
    83bc:	1a000006 	bne	83dc <_Z5genIsiif+0xb8>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:67 (discriminator 1)
    83c0:	e59f2058 	ldr	r2, [pc, #88]	; 8420 <_Z5genIsiif+0xfc>
    83c4:	e51b3008 	ldr	r3, [fp, #-8]
    83c8:	e1a03103 	lsl	r3, r3, #2
    83cc:	e0823003 	add	r3, r2, r3
    83d0:	e51b2010 	ldr	r2, [fp, #-16]
    83d4:	e5832000 	str	r2, [r3]
    83d8:	ea00000a 	b	8408 <_Z5genIsiif+0xe4>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:68
	else if(y==4) generationE[x]=value;
    83dc:	e51b300c 	ldr	r3, [fp, #-12]
    83e0:	e3530004 	cmp	r3, #4
    83e4:	1a000006 	bne	8404 <_Z5genIsiif+0xe0>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:68 (discriminator 1)
    83e8:	e59f2034 	ldr	r2, [pc, #52]	; 8424 <_Z5genIsiif+0x100>
    83ec:	e51b3008 	ldr	r3, [fp, #-8]
    83f0:	e1a03103 	lsl	r3, r3, #2
    83f4:	e0823003 	add	r3, r2, r3
    83f8:	e51b2010 	ldr	r2, [fp, #-16]
    83fc:	e5832000 	str	r2, [r3]
    8400:	ea000000 	b	8408 <_Z5genIsiif+0xe4>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:69
	else return;
    8404:	e320f000 	nop	{0}
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:70
}
    8408:	e28bd000 	add	sp, fp, #0
    840c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8410:	e12fff1e 	bx	lr
    8414:	0000b47c 	andeq	fp, r0, ip, ror r4
    8418:	0000b544 	andeq	fp, r0, r4, asr #10
    841c:	0000b60c 	andeq	fp, r0, ip, lsl #12
    8420:	0000b6d4 	ldrdeq	fp, [r0], -r4
    8424:	0000b79c 	muleq	r0, ip, r7

00008428 <_Z12checkForStopPcj>:
_Z12checkForStopPcj():
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:73

//check char* if there is stop in it
bool checkForStop(char* buffer, uint32_t size){
    8428:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    842c:	e28db000 	add	fp, sp, #0
    8430:	e24dd014 	sub	sp, sp, #20
    8434:	e50b0010 	str	r0, [fp, #-16]
    8438:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:74
	for(uint32_t j = 0; j < size-4; j++){
    843c:	e3a03000 	mov	r3, #0
    8440:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:74 (discriminator 1)
    8444:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8448:	e2433004 	sub	r3, r3, #4
    844c:	e51b2008 	ldr	r2, [fp, #-8]
    8450:	e1520003 	cmp	r2, r3
    8454:	2a000020 	bcs	84dc <_Z12checkForStopPcj+0xb4>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:75
		if(buffer[j] == 's' && buffer[j+1] == 't' && buffer[j+2] == 'o' && buffer[j+3] == 'p')
    8458:	e51b2010 	ldr	r2, [fp, #-16]
    845c:	e51b3008 	ldr	r3, [fp, #-8]
    8460:	e0823003 	add	r3, r2, r3
    8464:	e5d33000 	ldrb	r3, [r3]
    8468:	e3530073 	cmp	r3, #115	; 0x73
    846c:	1a000016 	bne	84cc <_Z12checkForStopPcj+0xa4>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:75 (discriminator 1)
    8470:	e51b3008 	ldr	r3, [fp, #-8]
    8474:	e2833001 	add	r3, r3, #1
    8478:	e51b2010 	ldr	r2, [fp, #-16]
    847c:	e0823003 	add	r3, r2, r3
    8480:	e5d33000 	ldrb	r3, [r3]
    8484:	e3530074 	cmp	r3, #116	; 0x74
    8488:	1a00000f 	bne	84cc <_Z12checkForStopPcj+0xa4>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:75 (discriminator 2)
    848c:	e51b3008 	ldr	r3, [fp, #-8]
    8490:	e2833002 	add	r3, r3, #2
    8494:	e51b2010 	ldr	r2, [fp, #-16]
    8498:	e0823003 	add	r3, r2, r3
    849c:	e5d33000 	ldrb	r3, [r3]
    84a0:	e353006f 	cmp	r3, #111	; 0x6f
    84a4:	1a000008 	bne	84cc <_Z12checkForStopPcj+0xa4>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:75 (discriminator 3)
    84a8:	e51b3008 	ldr	r3, [fp, #-8]
    84ac:	e2833003 	add	r3, r3, #3
    84b0:	e51b2010 	ldr	r2, [fp, #-16]
    84b4:	e0823003 	add	r3, r2, r3
    84b8:	e5d33000 	ldrb	r3, [r3]
    84bc:	e3530070 	cmp	r3, #112	; 0x70
    84c0:	1a000001 	bne	84cc <_Z12checkForStopPcj+0xa4>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:76
			return true;
    84c4:	e3a03001 	mov	r3, #1
    84c8:	ea000004 	b	84e0 <_Z12checkForStopPcj+0xb8>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:74 (discriminator 2)
	for(uint32_t j = 0; j < size-4; j++){
    84cc:	e51b3008 	ldr	r3, [fp, #-8]
    84d0:	e2833001 	add	r3, r3, #1
    84d4:	e50b3008 	str	r3, [fp, #-8]
    84d8:	eaffffd9 	b	8444 <_Z12checkForStopPcj+0x1c>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:78
	}
	return false;
    84dc:	e3a03000 	mov	r3, #0
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:79
}
    84e0:	e1a00003 	mov	r0, r3
    84e4:	e28bd000 	add	sp, fp, #0
    84e8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    84ec:	e12fff1e 	bx	lr

000084f0 <_Z10console_injb>:
_Z10console_injb():
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:82

//read line - with writing what was written back into console and check for stop
void console_in(uint32_t size = 32, bool block = true){
    84f0:	e92d4800 	push	{fp, lr}
    84f4:	e28db004 	add	fp, sp, #4
    84f8:	e24dd010 	sub	sp, sp, #16
    84fc:	e50b0010 	str	r0, [fp, #-16]
    8500:	e1a03001 	mov	r3, r1
    8504:	e54b3011 	strb	r3, [fp, #-17]	; 0xffffffef
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:84
	uint32_t len;
	bzero(readValue, 32);
    8508:	e3a01020 	mov	r1, #32
    850c:	e59f0088 	ldr	r0, [pc, #136]	; 859c <_Z10console_injb+0xac>
    8510:	eb000950 	bl	aa58 <_Z5bzeroPvi>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:86
    //read buffer
    len = reader.readLine(readValue, uartFile, block);
    8514:	e59f3084 	ldr	r3, [pc, #132]	; 85a0 <_Z10console_injb+0xb0>
    8518:	e5932000 	ldr	r2, [r3]
    851c:	e55b3011 	ldrb	r3, [fp, #-17]	; 0xffffffef
    8520:	e59f1074 	ldr	r1, [pc, #116]	; 859c <_Z10console_injb+0xac>
    8524:	e59f0078 	ldr	r0, [pc, #120]	; 85a4 <_Z10console_injb+0xb4>
    8528:	eb00098f 	bl	ab6c <_ZN10Read_Utils8readLineEPcjb>
    852c:	e50b0008 	str	r0, [fp, #-8]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:89
    //write what has been read
	//write(uartFile, "You wrote: ", 11);
	write(uartFile, readValue, len);
    8530:	e59f3068 	ldr	r3, [pc, #104]	; 85a0 <_Z10console_injb+0xb0>
    8534:	e5933000 	ldr	r3, [r3]
    8538:	e51b2008 	ldr	r2, [fp, #-8]
    853c:	e59f1058 	ldr	r1, [pc, #88]	; 859c <_Z10console_injb+0xac>
    8540:	e1a00003 	mov	r0, r3
    8544:	eb0005c7 	bl	9c68 <_Z5writejPKcj>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:90
	if(len>0){
    8548:	e51b3008 	ldr	r3, [fp, #-8]
    854c:	e3530000 	cmp	r3, #0
    8550:	0a000005 	beq	856c <_Z10console_injb+0x7c>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:92
        //if end line write new line
	    write(uartFile, "\n", 1);
    8554:	e59f3044 	ldr	r3, [pc, #68]	; 85a0 <_Z10console_injb+0xb0>
    8558:	e5933000 	ldr	r3, [r3]
    855c:	e3a02001 	mov	r2, #1
    8560:	e59f1040 	ldr	r1, [pc, #64]	; 85a8 <_Z10console_injb+0xb8>
    8564:	e1a00003 	mov	r0, r3
    8568:	eb0005be 	bl	9c68 <_Z5writejPKcj>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:94
	}
	if(checkForStop(readValue, 32))stop=true;
    856c:	e3a01020 	mov	r1, #32
    8570:	e59f0024 	ldr	r0, [pc, #36]	; 859c <_Z10console_injb+0xac>
    8574:	ebffffab 	bl	8428 <_Z12checkForStopPcj>
    8578:	e1a03000 	mov	r3, r0
    857c:	e3530000 	cmp	r3, #0
    8580:	0a000002 	beq	8590 <_Z10console_injb+0xa0>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:94 (discriminator 1)
    8584:	e59f3020 	ldr	r3, [pc, #32]	; 85ac <_Z10console_injb+0xbc>
    8588:	e3a02001 	mov	r2, #1
    858c:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:95
}
    8590:	e320f000 	nop	{0}
    8594:	e24bd004 	sub	sp, fp, #4
    8598:	e8bd8800 	pop	{fp, pc}
    859c:	0000b86c 	andeq	fp, r0, ip, ror #16
    85a0:	0000b914 	andeq	fp, r0, r4, lsl r9
    85a4:	0000b88c 	andeq	fp, r0, ip, lsl #17
    85a8:	0000b1e4 	andeq	fp, r0, r4, ror #3
    85ac:	0000b868 	andeq	fp, r0, r8, ror #16

000085b0 <_Z8get_sizePc>:
_Z8get_sizePc():
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:98

//get size of given char*
uint32_t get_size(char* s) {	//size of char*
    85b0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85b4:	e28db000 	add	fp, sp, #0
    85b8:	e24dd014 	sub	sp, sp, #20
    85bc:	e50b0010 	str	r0, [fp, #-16]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:100
	char* t;
	for (t = s; *t != '\0'; t++)
    85c0:	e51b3010 	ldr	r3, [fp, #-16]
    85c4:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:100 (discriminator 3)
    85c8:	e51b3008 	ldr	r3, [fp, #-8]
    85cc:	e5d33000 	ldrb	r3, [r3]
    85d0:	e3530000 	cmp	r3, #0
    85d4:	0a000003 	beq	85e8 <_Z8get_sizePc+0x38>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:100 (discriminator 2)
    85d8:	e51b3008 	ldr	r3, [fp, #-8]
    85dc:	e2833001 	add	r3, r3, #1
    85e0:	e50b3008 	str	r3, [fp, #-8]
    85e4:	eafffff7 	b	85c8 <_Z8get_sizePc+0x18>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:102
		;
	return t - s;
    85e8:	e51b2008 	ldr	r2, [fp, #-8]
    85ec:	e51b3010 	ldr	r3, [fp, #-16]
    85f0:	e0423003 	sub	r3, r2, r3
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:103
}
    85f4:	e1a00003 	mov	r0, r3
    85f8:	e28bd000 	add	sp, fp, #0
    85fc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8600:	e12fff1e 	bx	lr

00008604 <_Z11check_paramPc>:
_Z11check_paramPc():
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:106

//check if char* is float, int or string
uint32_t check_param(char* param) { //0=str, 1=int, 2=float
    8604:	e92d4800 	push	{fp, lr}
    8608:	e28db004 	add	fp, sp, #4
    860c:	e24dd018 	sub	sp, sp, #24
    8610:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:107
	int size = get_size(param);
    8614:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8618:	ebffffe4 	bl	85b0 <_Z8get_sizePc>
    861c:	e1a03000 	mov	r3, r0
    8620:	e50b3010 	str	r3, [fp, #-16]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:108
	bool whole = true;
    8624:	e3a03001 	mov	r3, #1
    8628:	e54b3005 	strb	r3, [fp, #-5]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:110
	char a;
	for (int i = 0; i < size; i++) {
    862c:	e3a03000 	mov	r3, #0
    8630:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:110 (discriminator 1)
    8634:	e51b200c 	ldr	r2, [fp, #-12]
    8638:	e51b3010 	ldr	r3, [fp, #-16]
    863c:	e1520003 	cmp	r2, r3
    8640:	aa000029 	bge	86ec <_Z11check_paramPc+0xe8>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:111
		a = param[i];
    8644:	e51b300c 	ldr	r3, [fp, #-12]
    8648:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    864c:	e0823003 	add	r3, r2, r3
    8650:	e5d33000 	ldrb	r3, [r3]
    8654:	e54b3011 	strb	r3, [fp, #-17]	; 0xffffffef
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:113
		//end of line means end of string
		if (a == '\n') {
    8658:	e55b3011 	ldrb	r3, [fp, #-17]	; 0xffffffef
    865c:	e353000a 	cmp	r3, #10
    8660:	0a000020 	beq	86e8 <_Z11check_paramPc+0xe4>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:117
			break;
		}
		//if there is . or , it is not a whole number, if it already wasnt I found 2nd . or , -> return not int nor float
		if (a == '.' || a == ',') {
    8664:	e55b3011 	ldrb	r3, [fp, #-17]	; 0xffffffef
    8668:	e353002e 	cmp	r3, #46	; 0x2e
    866c:	0a000002 	beq	867c <_Z11check_paramPc+0x78>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:117 (discriminator 1)
    8670:	e55b3011 	ldrb	r3, [fp, #-17]	; 0xffffffef
    8674:	e353002c 	cmp	r3, #44	; 0x2c
    8678:	1a000008 	bne	86a0 <_Z11check_paramPc+0x9c>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:118
			if (!whole)
    867c:	e55b3005 	ldrb	r3, [fp, #-5]
    8680:	e2233001 	eor	r3, r3, #1
    8684:	e6ef3073 	uxtb	r3, r3
    8688:	e3530000 	cmp	r3, #0
    868c:	0a000001 	beq	8698 <_Z11check_paramPc+0x94>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:119
				return 0;
    8690:	e3a03000 	mov	r3, #0
    8694:	ea00001a 	b	8704 <_Z11check_paramPc+0x100>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:120
			whole = false;
    8698:	e3a03000 	mov	r3, #0
    869c:	e54b3005 	strb	r3, [fp, #-5]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:123
		}
		//if character is in range of 0-9 or its . or , - it might be number
		if (!((a >= '0' && a <= '9') || a == '.' || a == ','))
    86a0:	e55b3011 	ldrb	r3, [fp, #-17]	; 0xffffffef
    86a4:	e353002f 	cmp	r3, #47	; 0x2f
    86a8:	9a000002 	bls	86b8 <_Z11check_paramPc+0xb4>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:123 (discriminator 2)
    86ac:	e55b3011 	ldrb	r3, [fp, #-17]	; 0xffffffef
    86b0:	e3530039 	cmp	r3, #57	; 0x39
    86b4:	9a000007 	bls	86d8 <_Z11check_paramPc+0xd4>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:123 (discriminator 3)
    86b8:	e55b3011 	ldrb	r3, [fp, #-17]	; 0xffffffef
    86bc:	e353002e 	cmp	r3, #46	; 0x2e
    86c0:	0a000004 	beq	86d8 <_Z11check_paramPc+0xd4>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:123 (discriminator 4)
    86c4:	e55b3011 	ldrb	r3, [fp, #-17]	; 0xffffffef
    86c8:	e353002c 	cmp	r3, #44	; 0x2c
    86cc:	0a000001 	beq	86d8 <_Z11check_paramPc+0xd4>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:124
			return 0;
    86d0:	e3a03000 	mov	r3, #0
    86d4:	ea00000a 	b	8704 <_Z11check_paramPc+0x100>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:110 (discriminator 2)
	for (int i = 0; i < size; i++) {
    86d8:	e51b300c 	ldr	r3, [fp, #-12]
    86dc:	e2833001 	add	r3, r3, #1
    86e0:	e50b300c 	str	r3, [fp, #-12]
    86e4:	eaffffd2 	b	8634 <_Z11check_paramPc+0x30>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:114
			break;
    86e8:	e320f000 	nop	{0}
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:126
	}
	if (whole)return 1;
    86ec:	e55b3005 	ldrb	r3, [fp, #-5]
    86f0:	e3530000 	cmp	r3, #0
    86f4:	0a000001 	beq	8700 <_Z11check_paramPc+0xfc>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:126 (discriminator 1)
    86f8:	e3a03001 	mov	r3, #1
    86fc:	ea000000 	b	8704 <_Z11check_paramPc+0x100>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:127
	else return 2;
    8700:	e3a03002 	mov	r3, #2
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:128
}
    8704:	e1a00003 	mov	r0, r3
    8708:	e24bd004 	sub	sp, fp, #4
    870c:	e8bd8800 	pop	{fp, pc}

00008710 <_Z10read_paramv>:
_Z10read_paramv():
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:132


//read first two parameters
void read_param() {
    8710:	e92d4800 	push	{fp, lr}
    8714:	e28db004 	add	fp, sp, #4
    8718:	e24dd020 	sub	sp, sp, #32
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:133
    char* param =  reinterpret_cast<char*>(malloc(32));
    871c:	e3a00020 	mov	r0, #32
    8720:	eb000625 	bl	9fbc <_Z6mallocj>
    8724:	e50b0008 	str	r0, [fp, #-8]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:136
	while (true) {
		//read first parameter - delta
		bzero(readValue, 32);
    8728:	e3a01020 	mov	r1, #32
    872c:	e59f0264 	ldr	r0, [pc, #612]	; 8998 <_Z10read_paramv+0x288>
    8730:	eb0008c8 	bl	aa58 <_Z5bzeroPvi>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:137
		console_in();
    8734:	e3a01001 	mov	r1, #1
    8738:	e3a00020 	mov	r0, #32
    873c:	ebffff6b 	bl	84f0 <_Z10console_injb>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:138
		uint32_t b = check_param(readValue);
    8740:	e59f0250 	ldr	r0, [pc, #592]	; 8998 <_Z10read_paramv+0x288>
    8744:	ebffffae 	bl	8604 <_Z11check_paramPc>
    8748:	e50b000c 	str	r0, [fp, #-12]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:141

		//check if it is number
		if (b == 1 || b == 2) {			
    874c:	e51b300c 	ldr	r3, [fp, #-12]
    8750:	e3530001 	cmp	r3, #1
    8754:	0a000002 	beq	8764 <_Z10read_paramv+0x54>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:141 (discriminator 1)
    8758:	e51b300c 	ldr	r3, [fp, #-12]
    875c:	e3530002 	cmp	r3, #2
    8760:	1a000036 	bne	8840 <_Z10read_paramv+0x130>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:142
			DELTA = atoi(readValue);
    8764:	e59f022c 	ldr	r0, [pc, #556]	; 8998 <_Z10read_paramv+0x288>
    8768:	eb000681 	bl	a174 <_Z4atoiPKc>
    876c:	e1a03000 	mov	r3, r0
    8770:	e1a02003 	mov	r2, r3
    8774:	e59f3220 	ldr	r3, [pc, #544]	; 899c <_Z10read_paramv+0x28c>
    8778:	e5832000 	str	r2, [r3]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:143
			if(b==2) DELTA = DELTA / 10;
    877c:	e51b300c 	ldr	r3, [fp, #-12]
    8780:	e3530002 	cmp	r3, #2
    8784:	1a000006 	bne	87a4 <_Z10read_paramv+0x94>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:143 (discriminator 1)
    8788:	e59f320c 	ldr	r3, [pc, #524]	; 899c <_Z10read_paramv+0x28c>
    878c:	e5933000 	ldr	r3, [r3]
    8790:	e59f2208 	ldr	r2, [pc, #520]	; 89a0 <_Z10read_paramv+0x290>
    8794:	e0832392 	umull	r2, r3, r2, r3
    8798:	e1a031a3 	lsr	r3, r3, #3
    879c:	e59f21f8 	ldr	r2, [pc, #504]	; 899c <_Z10read_paramv+0x28c>
    87a0:	e5823000 	str	r3, [r2]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:145
			//set DERIV_CONST so its not counted multiple times
			DERIV_CONST = ((DELTA * 60.0 * 1.0) / (24.0 * 60.0 * 60.0));
    87a4:	e59f31f0 	ldr	r3, [pc, #496]	; 899c <_Z10read_paramv+0x28c>
    87a8:	e5933000 	ldr	r3, [r3]
    87ac:	ee073a90 	vmov	s15, r3
    87b0:	eeb87b67 	vcvt.f64.u32	d7, s15
    87b4:	ed9f6b73 	vldr	d6, [pc, #460]	; 8988 <_Z10read_paramv+0x278>
    87b8:	ee276b06 	vmul.f64	d6, d7, d6
    87bc:	ed9f5b73 	vldr	d5, [pc, #460]	; 8990 <_Z10read_paramv+0x280>
    87c0:	ee867b05 	vdiv.f64	d7, d6, d5
    87c4:	eef77bc7 	vcvt.f32.f64	s15, d7
    87c8:	e59f31d4 	ldr	r3, [pc, #468]	; 89a4 <_Z10read_paramv+0x294>
    87cc:	edc37a00 	vstr	s15, [r3]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:148

			//print it out
			char* deltaChar =  reinterpret_cast<char*>(malloc(sizeof(uint32_t)));
    87d0:	e3a00004 	mov	r0, #4
    87d4:	eb0005f8 	bl	9fbc <_Z6mallocj>
    87d8:	e50b0014 	str	r0, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:149
			itoa(DELTA, deltaChar, 10);
    87dc:	e59f31b8 	ldr	r3, [pc, #440]	; 899c <_Z10read_paramv+0x28c>
    87e0:	e5933000 	ldr	r3, [r3]
    87e4:	e3a0200a 	mov	r2, #10
    87e8:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    87ec:	e1a00003 	mov	r0, r3
    87f0:	eb000602 	bl	a000 <_Z4itoajPcj>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:158
			strcat(print_out, reinterpret_cast<const char*>("OK, krokovani "));
			strcat(print_out, reinterpret_cast<const char*>(deltaChar));
			strcat(print_out, reinterpret_cast<const char*>(" min.\n"));
			write(uartFile, print_out, 22 + sizeof(uint32_t));*/

			write(uartFile, "OK, krokovani ", 14);
    87f4:	e59f31ac 	ldr	r3, [pc, #428]	; 89a8 <_Z10read_paramv+0x298>
    87f8:	e5933000 	ldr	r3, [r3]
    87fc:	e3a0200e 	mov	r2, #14
    8800:	e59f11a4 	ldr	r1, [pc, #420]	; 89ac <_Z10read_paramv+0x29c>
    8804:	e1a00003 	mov	r0, r3
    8808:	eb000516 	bl	9c68 <_Z5writejPKcj>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:159
			write(uartFile, deltaChar, 16);
    880c:	e59f3194 	ldr	r3, [pc, #404]	; 89a8 <_Z10read_paramv+0x298>
    8810:	e5933000 	ldr	r3, [r3]
    8814:	e3a02010 	mov	r2, #16
    8818:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    881c:	e1a00003 	mov	r0, r3
    8820:	eb000510 	bl	9c68 <_Z5writejPKcj>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:160
			write(uartFile, " min.\n", 6);
    8824:	e59f317c 	ldr	r3, [pc, #380]	; 89a8 <_Z10read_paramv+0x298>
    8828:	e5933000 	ldr	r3, [r3]
    882c:	e3a02006 	mov	r2, #6
    8830:	e59f1178 	ldr	r1, [pc, #376]	; 89b0 <_Z10read_paramv+0x2a0>
    8834:	e1a00003 	mov	r0, r3
    8838:	eb00050a 	bl	9c68 <_Z5writejPKcj>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:163

            
			break;
    883c:	ea000008 	b	8864 <_Z10read_paramv+0x154>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:167
		}
		else {
			//there was string instead of int or float
			const char* print_out = "Zadejte cele cislo prosim.\n";
    8840:	e59f316c 	ldr	r3, [pc, #364]	; 89b4 <_Z10read_paramv+0x2a4>
    8844:	e50b3010 	str	r3, [fp, #-16]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:168
            write(uartFile, print_out, 28);
    8848:	e59f3158 	ldr	r3, [pc, #344]	; 89a8 <_Z10read_paramv+0x298>
    884c:	e5933000 	ldr	r3, [r3]
    8850:	e3a0201c 	mov	r2, #28
    8854:	e51b1010 	ldr	r1, [fp, #-16]
    8858:	e1a00003 	mov	r0, r3
    885c:	eb000501 	bl	9c68 <_Z5writejPKcj>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:170
		}
	}
    8860:	eaffffb0 	b	8728 <_Z10read_paramv+0x18>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:173
	while (true) {
		//read second parameter - prediction
		bzero(readValue, 32);
    8864:	e3a01020 	mov	r1, #32
    8868:	e59f0128 	ldr	r0, [pc, #296]	; 8998 <_Z10read_paramv+0x288>
    886c:	eb000879 	bl	aa58 <_Z5bzeroPvi>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:174
		console_in();
    8870:	e3a01001 	mov	r1, #1
    8874:	e3a00020 	mov	r0, #32
    8878:	ebffff1c 	bl	84f0 <_Z10console_injb>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:175
		uint32_t b = check_param(readValue);		
    887c:	e59f0114 	ldr	r0, [pc, #276]	; 8998 <_Z10read_paramv+0x288>
    8880:	ebffff5f 	bl	8604 <_Z11check_paramPc>
    8884:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:178

		//check if it is number
		if (b == 1 || b == 2) {
    8888:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    888c:	e3530001 	cmp	r3, #1
    8890:	0a000002 	beq	88a0 <_Z10read_paramv+0x190>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:178 (discriminator 1)
    8894:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8898:	e3530002 	cmp	r3, #2
    889c:	1a00002e 	bne	895c <_Z10read_paramv+0x24c>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:179
			PRED = atoi(readValue);
    88a0:	e59f00f0 	ldr	r0, [pc, #240]	; 8998 <_Z10read_paramv+0x288>
    88a4:	eb000632 	bl	a174 <_Z4atoiPKc>
    88a8:	e1a03000 	mov	r3, r0
    88ac:	e1a02003 	mov	r2, r3
    88b0:	e59f3100 	ldr	r3, [pc, #256]	; 89b8 <_Z10read_paramv+0x2a8>
    88b4:	e5832000 	str	r2, [r3]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:180
			if(b == 2) PRED = PRED / 10;
    88b8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    88bc:	e3530002 	cmp	r3, #2
    88c0:	1a000006 	bne	88e0 <_Z10read_paramv+0x1d0>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:180 (discriminator 1)
    88c4:	e59f30ec 	ldr	r3, [pc, #236]	; 89b8 <_Z10read_paramv+0x2a8>
    88c8:	e5933000 	ldr	r3, [r3]
    88cc:	e59f20cc 	ldr	r2, [pc, #204]	; 89a0 <_Z10read_paramv+0x290>
    88d0:	e0832392 	umull	r2, r3, r2, r3
    88d4:	e1a031a3 	lsr	r3, r3, #3
    88d8:	e59f20d8 	ldr	r2, [pc, #216]	; 89b8 <_Z10read_paramv+0x2a8>
    88dc:	e5823000 	str	r3, [r2]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:182
			//write to console what came
			char* predChar = reinterpret_cast<char*>(malloc(sizeof(uint32_t)));
    88e0:	e3a00004 	mov	r0, #4
    88e4:	eb0005b4 	bl	9fbc <_Z6mallocj>
    88e8:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:183
			bzero(predChar, sizeof(uint32_t));
    88ec:	e3a01004 	mov	r1, #4
    88f0:	e51b0020 	ldr	r0, [fp, #-32]	; 0xffffffe0
    88f4:	eb000857 	bl	aa58 <_Z5bzeroPvi>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:184
			itoa(PRED, predChar, 10);
    88f8:	e59f30b8 	ldr	r3, [pc, #184]	; 89b8 <_Z10read_paramv+0x2a8>
    88fc:	e5933000 	ldr	r3, [r3]
    8900:	e3a0200a 	mov	r2, #10
    8904:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    8908:	e1a00003 	mov	r0, r3
    890c:	eb0005bb 	bl	a000 <_Z4itoajPcj>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:194
			strcat(print_out, reinterpret_cast<const char*>(predChar));
			strcat(print_out, reinterpret_cast<const char*>(" min.\n"));
            write(uartFile, print_out, 22 + sizeof(uint32_t));*/

			//write it out
			write(uartFile, "OK, predikce je ", 16);
    8910:	e59f3090 	ldr	r3, [pc, #144]	; 89a8 <_Z10read_paramv+0x298>
    8914:	e5933000 	ldr	r3, [r3]
    8918:	e3a02010 	mov	r2, #16
    891c:	e59f1098 	ldr	r1, [pc, #152]	; 89bc <_Z10read_paramv+0x2ac>
    8920:	e1a00003 	mov	r0, r3
    8924:	eb0004cf 	bl	9c68 <_Z5writejPKcj>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:195
			write(uartFile, predChar, 16);
    8928:	e59f3078 	ldr	r3, [pc, #120]	; 89a8 <_Z10read_paramv+0x298>
    892c:	e5933000 	ldr	r3, [r3]
    8930:	e3a02010 	mov	r2, #16
    8934:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    8938:	e1a00003 	mov	r0, r3
    893c:	eb0004c9 	bl	9c68 <_Z5writejPKcj>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:196
			write(uartFile, " min.\n", 6);
    8940:	e59f3060 	ldr	r3, [pc, #96]	; 89a8 <_Z10read_paramv+0x298>
    8944:	e5933000 	ldr	r3, [r3]
    8948:	e3a02006 	mov	r2, #6
    894c:	e59f105c 	ldr	r1, [pc, #92]	; 89b0 <_Z10read_paramv+0x2a0>
    8950:	e1a00003 	mov	r0, r3
    8954:	eb0004c3 	bl	9c68 <_Z5writejPKcj>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:198

			return;
    8958:	ea000008 	b	8980 <_Z10read_paramv+0x270>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:202
		}
		else {
			//there was no number on imput, repeat
			const char* print_out = "Zadejte cele cislo prosim.\n";
    895c:	e59f3050 	ldr	r3, [pc, #80]	; 89b4 <_Z10read_paramv+0x2a4>
    8960:	e50b301c 	str	r3, [fp, #-28]	; 0xffffffe4
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:203
            write(uartFile, print_out, 28);
    8964:	e59f303c 	ldr	r3, [pc, #60]	; 89a8 <_Z10read_paramv+0x298>
    8968:	e5933000 	ldr	r3, [r3]
    896c:	e3a0201c 	mov	r2, #28
    8970:	e51b101c 	ldr	r1, [fp, #-28]	; 0xffffffe4
    8974:	e1a00003 	mov	r0, r3
    8978:	eb0004ba 	bl	9c68 <_Z5writejPKcj>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:205
		}
	}
    897c:	eaffffb8 	b	8864 <_Z10read_paramv+0x154>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:206
}
    8980:	e24bd004 	sub	sp, fp, #4
    8984:	e8bd8800 	pop	{fp, pc}
    8988:	00000000 	andeq	r0, r0, r0
    898c:	404e0000 	submi	r0, lr, r0
    8990:	00000000 	andeq	r0, r0, r0
    8994:	40f51800 	rscsmi	r1, r5, r0, lsl #16
    8998:	0000b86c 	andeq	fp, r0, ip, ror #16
    899c:	0000b468 	andeq	fp, r0, r8, ror #8
    89a0:	cccccccd 	stclgt	12, cr12, [ip], {205}	; 0xcd
    89a4:	0000b470 	andeq	fp, r0, r0, ror r4
    89a8:	0000b914 	andeq	fp, r0, r4, lsl r9
    89ac:	0000b1e8 	andeq	fp, r0, r8, ror #3
    89b0:	0000b1f8 	strdeq	fp, [r0], -r8
    89b4:	0000b200 	andeq	fp, r0, r0, lsl #4
    89b8:	0000b46c 	andeq	fp, r0, ip, ror #8
    89bc:	0000b21c 	andeq	fp, r0, ip, lsl r2

000089c0 <_Z10read_inputv>:
_Z10read_inputv():
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:209

//read new float value
uint32_t read_input() {
    89c0:	e92d4800 	push	{fp, lr}
    89c4:	e28db004 	add	fp, sp, #4
    89c8:	e24dd010 	sub	sp, sp, #16
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:211
	float input;
	char* param = reinterpret_cast<char*>(malloc(32));
    89cc:	e3a00020 	mov	r0, #32
    89d0:	eb000579 	bl	9fbc <_Z6mallocj>
    89d4:	e50b000c 	str	r0, [fp, #-12]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:212
	bzero(readValue, 32);
    89d8:	e3a01020 	mov	r1, #32
    89dc:	e59f0184 	ldr	r0, [pc, #388]	; 8b68 <_Z10read_inputv+0x1a8>
    89e0:	eb00081c 	bl	aa58 <_Z5bzeroPvi>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:213
	console_in();
    89e4:	e3a01001 	mov	r1, #1
    89e8:	e3a00020 	mov	r0, #32
    89ec:	ebfffebf 	bl	84f0 <_Z10console_injb>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:215

	if (checkForStop(readValue, 32))
    89f0:	e3a01020 	mov	r1, #32
    89f4:	e59f016c 	ldr	r0, [pc, #364]	; 8b68 <_Z10read_inputv+0x1a8>
    89f8:	ebfffe8a 	bl	8428 <_Z12checkForStopPcj>
    89fc:	e1a03000 	mov	r3, r0
    8a00:	e3530000 	cmp	r3, #0
    8a04:	0a000001 	beq	8a10 <_Z10read_inputv+0x50>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:216
		return 1;
    8a08:	e3a03001 	mov	r3, #1
    8a0c:	ea000052 	b	8b5c <_Z10read_inputv+0x19c>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:217
	else if (readValue == "parameters")
    8a10:	e59f2150 	ldr	r2, [pc, #336]	; 8b68 <_Z10read_inputv+0x1a8>
    8a14:	e59f3150 	ldr	r3, [pc, #336]	; 8b6c <_Z10read_inputv+0x1ac>
    8a18:	e1520003 	cmp	r2, r3
    8a1c:	1a000001 	bne	8a28 <_Z10read_inputv+0x68>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:218
		return 2;
    8a20:	e3a03002 	mov	r3, #2
    8a24:	ea00004c 	b	8b5c <_Z10read_inputv+0x19c>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:219
	else if (check_param(readValue) == 0){
    8a28:	e59f0138 	ldr	r0, [pc, #312]	; 8b68 <_Z10read_inputv+0x1a8>
    8a2c:	ebfffef4 	bl	8604 <_Z11check_paramPc>
    8a30:	e1a03000 	mov	r3, r0
    8a34:	e3530000 	cmp	r3, #0
    8a38:	03a03001 	moveq	r3, #1
    8a3c:	13a03000 	movne	r3, #0
    8a40:	e6ef3073 	uxtb	r3, r3
    8a44:	e3530000 	cmp	r3, #0
    8a48:	0a000001 	beq	8a54 <_Z10read_inputv+0x94>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:220
		return 3;
    8a4c:	e3a03003 	mov	r3, #3
    8a50:	ea000041 	b	8b5c <_Z10read_inputv+0x19c>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:223
	}

	input = atof(readValue);
    8a54:	e59f010c 	ldr	r0, [pc, #268]	; 8b68 <_Z10read_inputv+0x1a8>
    8a58:	eb00061e 	bl	a2d8 <_Z4atofPKc>
    8a5c:	ed0b0a04 	vstr	s0, [fp, #-16]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:226

	//store new value
	values[val_counter] = input;
    8a60:	e59f3108 	ldr	r3, [pc, #264]	; 8b70 <_Z10read_inputv+0x1b0>
    8a64:	e5932000 	ldr	r2, [r3]
    8a68:	e59f3104 	ldr	r3, [pc, #260]	; 8b74 <_Z10read_inputv+0x1b4>
    8a6c:	e5933000 	ldr	r3, [r3]
    8a70:	e1a03103 	lsl	r3, r3, #2
    8a74:	e0823003 	add	r3, r2, r3
    8a78:	e51b2010 	ldr	r2, [fp, #-16]
    8a7c:	e5832000 	str	r2, [r3]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:227
	val_counter++;
    8a80:	e59f30ec 	ldr	r3, [pc, #236]	; 8b74 <_Z10read_inputv+0x1b4>
    8a84:	e5933000 	ldr	r3, [r3]
    8a88:	e2833001 	add	r3, r3, #1
    8a8c:	e59f20e0 	ldr	r2, [pc, #224]	; 8b74 <_Z10read_inputv+0x1b4>
    8a90:	e5823000 	str	r3, [r2]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:230

	//expand array for values if needed
	if (val_counter >= val_size) {
    8a94:	e59f30d8 	ldr	r3, [pc, #216]	; 8b74 <_Z10read_inputv+0x1b4>
    8a98:	e5932000 	ldr	r2, [r3]
    8a9c:	e59f30d4 	ldr	r3, [pc, #212]	; 8b78 <_Z10read_inputv+0x1b8>
    8aa0:	e5933000 	ldr	r3, [r3]
    8aa4:	e1520003 	cmp	r2, r3
    8aa8:	3a00002a 	bcc	8b58 <_Z10read_inputv+0x198>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:231
		val_size *= 2;
    8aac:	e59f30c4 	ldr	r3, [pc, #196]	; 8b78 <_Z10read_inputv+0x1b8>
    8ab0:	e5933000 	ldr	r3, [r3]
    8ab4:	e1a03083 	lsl	r3, r3, #1
    8ab8:	e59f20b8 	ldr	r2, [pc, #184]	; 8b78 <_Z10read_inputv+0x1b8>
    8abc:	e5823000 	str	r3, [r2]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:232
		float* newVal =  reinterpret_cast<float*>(malloc(val_size*sizeof(float)));
    8ac0:	e59f30b0 	ldr	r3, [pc, #176]	; 8b78 <_Z10read_inputv+0x1b8>
    8ac4:	e5933000 	ldr	r3, [r3]
    8ac8:	e1a03103 	lsl	r3, r3, #2
    8acc:	e1a00003 	mov	r0, r3
    8ad0:	eb000539 	bl	9fbc <_Z6mallocj>
    8ad4:	e50b0014 	str	r0, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:233
		bzero(newVal, val_size*sizeof(float));
    8ad8:	e59f3098 	ldr	r3, [pc, #152]	; 8b78 <_Z10read_inputv+0x1b8>
    8adc:	e5933000 	ldr	r3, [r3]
    8ae0:	e1a03103 	lsl	r3, r3, #2
    8ae4:	e1a01003 	mov	r1, r3
    8ae8:	e51b0014 	ldr	r0, [fp, #-20]	; 0xffffffec
    8aec:	eb0007d9 	bl	aa58 <_Z5bzeroPvi>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:234
		for (int i = 0; i < val_size / 2; i++) {
    8af0:	e3a03000 	mov	r3, #0
    8af4:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:234 (discriminator 3)
    8af8:	e59f3078 	ldr	r3, [pc, #120]	; 8b78 <_Z10read_inputv+0x1b8>
    8afc:	e5933000 	ldr	r3, [r3]
    8b00:	e1a020a3 	lsr	r2, r3, #1
    8b04:	e51b3008 	ldr	r3, [fp, #-8]
    8b08:	e1520003 	cmp	r2, r3
    8b0c:	9a00000e 	bls	8b4c <_Z10read_inputv+0x18c>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:235 (discriminator 2)
			newVal[i] = values[i];
    8b10:	e59f3058 	ldr	r3, [pc, #88]	; 8b70 <_Z10read_inputv+0x1b0>
    8b14:	e5932000 	ldr	r2, [r3]
    8b18:	e51b3008 	ldr	r3, [fp, #-8]
    8b1c:	e1a03103 	lsl	r3, r3, #2
    8b20:	e0822003 	add	r2, r2, r3
    8b24:	e51b3008 	ldr	r3, [fp, #-8]
    8b28:	e1a03103 	lsl	r3, r3, #2
    8b2c:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    8b30:	e0813003 	add	r3, r1, r3
    8b34:	e5922000 	ldr	r2, [r2]
    8b38:	e5832000 	str	r2, [r3]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:234 (discriminator 2)
		for (int i = 0; i < val_size / 2; i++) {
    8b3c:	e51b3008 	ldr	r3, [fp, #-8]
    8b40:	e2833001 	add	r3, r3, #1
    8b44:	e50b3008 	str	r3, [fp, #-8]
    8b48:	eaffffea 	b	8af8 <_Z10read_inputv+0x138>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:237
		}
		values = newVal;
    8b4c:	e59f201c 	ldr	r2, [pc, #28]	; 8b70 <_Z10read_inputv+0x1b0>
    8b50:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8b54:	e5823000 	str	r3, [r2]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:240
	}

	return 0;
    8b58:	e3a03000 	mov	r3, #0
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:241
}
    8b5c:	e1a00003 	mov	r0, r3
    8b60:	e24bd004 	sub	sp, fp, #4
    8b64:	e8bd8800 	pop	{fp, pc}
    8b68:	0000b86c 	andeq	fp, r0, ip, ror #16
    8b6c:	0000b230 	andeq	fp, r0, r0, lsr r2
    8b70:	0000b474 	andeq	fp, r0, r4, ror r4
    8b74:	0000b478 	andeq	fp, r0, r8, ror r4
    8b78:	0000b464 	andeq	fp, r0, r4, ror #8

00008b7c <_Z7count_bffff>:
_Z7count_bffff():
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:244

//just quick function from CW - return b(t)
float count_b(float d, float e, float y_new, float y_old) {	//b(t) = D/E * dy(t)/dt + 1/E * y(t)			"dy(t)/dt" = (values[i-1] - values[i]) / ((step * 60) / (24 * 60 * 60))
    8b7c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8b80:	e28db000 	add	fp, sp, #0
    8b84:	e24dd024 	sub	sp, sp, #36	; 0x24
    8b88:	ed0b0a06 	vstr	s0, [fp, #-24]	; 0xffffffe8
    8b8c:	ed4b0a07 	vstr	s1, [fp, #-28]	; 0xffffffe4
    8b90:	ed0b1a08 	vstr	s2, [fp, #-32]	; 0xffffffe0
    8b94:	ed4b1a09 	vstr	s3, [fp, #-36]	; 0xffffffdc
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:245
	float tmp1 = (d / e);
    8b98:	ed5b6a06 	vldr	s13, [fp, #-24]	; 0xffffffe8
    8b9c:	ed1b7a07 	vldr	s14, [fp, #-28]	; 0xffffffe4
    8ba0:	eec67a87 	vdiv.f32	s15, s13, s14
    8ba4:	ed4b7a02 	vstr	s15, [fp, #-8]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:246
	float tmp2 = DERIV_CONST;
    8ba8:	e59f3050 	ldr	r3, [pc, #80]	; 8c00 <_Z7count_bffff+0x84>
    8bac:	e5933000 	ldr	r3, [r3]
    8bb0:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:247
	float tmp3 = 1 / e;
    8bb4:	eddf6a10 	vldr	s13, [pc, #64]	; 8bfc <_Z7count_bffff+0x80>
    8bb8:	ed1b7a07 	vldr	s14, [fp, #-28]	; 0xffffffe4
    8bbc:	eec67a87 	vdiv.f32	s15, s13, s14
    8bc0:	ed4b7a04 	vstr	s15, [fp, #-16]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:248
	float tmp4 = tmp1 * tmp2 + (tmp3 * y_new);
    8bc4:	ed1b7a02 	vldr	s14, [fp, #-8]
    8bc8:	ed5b7a03 	vldr	s15, [fp, #-12]
    8bcc:	ee277a27 	vmul.f32	s14, s14, s15
    8bd0:	ed5b6a04 	vldr	s13, [fp, #-16]
    8bd4:	ed5b7a08 	vldr	s15, [fp, #-32]	; 0xffffffe0
    8bd8:	ee667aa7 	vmul.f32	s15, s13, s15
    8bdc:	ee777a27 	vadd.f32	s15, s14, s15
    8be0:	ed4b7a05 	vstr	s15, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:250

	return tmp4;
    8be4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8be8:	ee073a90 	vmov	s15, r3
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:251
}
    8bec:	eeb00a67 	vmov.f32	s0, s15
    8bf0:	e28bd000 	add	sp, fp, #0
    8bf4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8bf8:	e12fff1e 	bx	lr
    8bfc:	3f800000 	svccc	0x00800000
    8c00:	0000b470 	andeq	fp, r0, r0, ror r4

00008c04 <_Z5get_yffffffff>:
_Z5get_yffffffff():
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:254

//just quick function from CW - return y(t+tpred)
float get_y(float a, float b, float c, float d, float e, float x, float y_new, float y_old) {		//y(t + t_pred) = A * b(t) + B * b(t) * (b(t) - y(t)) + C
    8c04:	e92d4800 	push	{fp, lr}
    8c08:	e28db004 	add	fp, sp, #4
    8c0c:	e24dd028 	sub	sp, sp, #40	; 0x28
    8c10:	ed0b0a04 	vstr	s0, [fp, #-16]
    8c14:	ed4b0a05 	vstr	s1, [fp, #-20]	; 0xffffffec
    8c18:	ed0b1a06 	vstr	s2, [fp, #-24]	; 0xffffffe8
    8c1c:	ed4b1a07 	vstr	s3, [fp, #-28]	; 0xffffffe4
    8c20:	ed0b2a08 	vstr	s4, [fp, #-32]	; 0xffffffe0
    8c24:	ed4b2a09 	vstr	s5, [fp, #-36]	; 0xffffffdc
    8c28:	ed0b3a0a 	vstr	s6, [fp, #-40]	; 0xffffffd8
    8c2c:	ed4b3a0b 	vstr	s7, [fp, #-44]	; 0xffffffd4
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:255
	float bt = count_b(d, e, y_new, y_old);
    8c30:	ed5b1a0b 	vldr	s3, [fp, #-44]	; 0xffffffd4
    8c34:	ed1b1a0a 	vldr	s2, [fp, #-40]	; 0xffffffd8
    8c38:	ed5b0a08 	vldr	s1, [fp, #-32]	; 0xffffffe0
    8c3c:	ed1b0a07 	vldr	s0, [fp, #-28]	; 0xffffffe4
    8c40:	ebffffcd 	bl	8b7c <_Z7count_bffff>
    8c44:	ed0b0a02 	vstr	s0, [fp, #-8]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:256
	return (a * bt) + (b * bt * (bt - y_new)) + c;
    8c48:	ed1b7a04 	vldr	s14, [fp, #-16]
    8c4c:	ed5b7a02 	vldr	s15, [fp, #-8]
    8c50:	ee277a27 	vmul.f32	s14, s14, s15
    8c54:	ed5b6a05 	vldr	s13, [fp, #-20]	; 0xffffffec
    8c58:	ed5b7a02 	vldr	s15, [fp, #-8]
    8c5c:	ee666aa7 	vmul.f32	s13, s13, s15
    8c60:	ed1b6a02 	vldr	s12, [fp, #-8]
    8c64:	ed5b7a0a 	vldr	s15, [fp, #-40]	; 0xffffffd8
    8c68:	ee767a67 	vsub.f32	s15, s12, s15
    8c6c:	ee667aa7 	vmul.f32	s15, s13, s15
    8c70:	ee377a27 	vadd.f32	s14, s14, s15
    8c74:	ed5b7a06 	vldr	s15, [fp, #-24]	; 0xffffffe8
    8c78:	ee777a27 	vadd.f32	s15, s14, s15
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:257
}
    8c7c:	eeb00a67 	vmov.f32	s0, s15
    8c80:	e24bd004 	sub	sp, fp, #4
    8c84:	e8bd8800 	pop	{fp, pc}

00008c88 <_Z12pseudoRandomii>:
_Z12pseudoRandomii():
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:261


//get new random number
int pseudoRandom(int start, int end) {
    8c88:	e92d4800 	push	{fp, lr}
    8c8c:	e28db004 	add	fp, sp, #4
    8c90:	e24dd010 	sub	sp, sp, #16
    8c94:	e50b0010 	str	r0, [fp, #-16]
    8c98:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:262
	char* buf = reinterpret_cast<char*>(malloc(sizeof(uint32_t)));
    8c9c:	e3a00004 	mov	r0, #4
    8ca0:	eb0004c5 	bl	9fbc <_Z6mallocj>
    8ca4:	e50b0008 	str	r0, [fp, #-8]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:263
	bzero(buf, sizeof(uint32_t));
    8ca8:	e3a01004 	mov	r1, #4
    8cac:	e51b0008 	ldr	r0, [fp, #-8]
    8cb0:	eb000768 	bl	aa58 <_Z5bzeroPvi>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:265
    //get new random value
	read(rnd, buf, sizeof(uint32_t));
    8cb4:	e59f3068 	ldr	r3, [pc, #104]	; 8d24 <_Z12pseudoRandomii+0x9c>
    8cb8:	e5933000 	ldr	r3, [r3]
    8cbc:	e3a02004 	mov	r2, #4
    8cc0:	e51b1008 	ldr	r1, [fp, #-8]
    8cc4:	e1a00003 	mov	r0, r3
    8cc8:	eb0003d2 	bl	9c18 <_Z4readjPcj>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:267
    //make it into number
	rnd_value = reinterpret_cast<uint32_t*>(buf)[0];
    8ccc:	e51b3008 	ldr	r3, [fp, #-8]
    8cd0:	e5933000 	ldr	r3, [r3]
    8cd4:	e59f204c 	ldr	r2, [pc, #76]	; 8d28 <_Z12pseudoRandomii+0xa0>
    8cd8:	e5823000 	str	r3, [r2]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:269
    //get radnom value in range
	rnd_value = rnd_value % (end-start);
    8cdc:	e59f3044 	ldr	r3, [pc, #68]	; 8d28 <_Z12pseudoRandomii+0xa0>
    8ce0:	e5930000 	ldr	r0, [r3]
    8ce4:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8ce8:	e51b3010 	ldr	r3, [fp, #-16]
    8cec:	e0423003 	sub	r3, r2, r3
    8cf0:	e1a01003 	mov	r1, r3
    8cf4:	eb000922 	bl	b184 <__aeabi_uidivmod>
    8cf8:	e1a03001 	mov	r3, r1
    8cfc:	e1a02003 	mov	r2, r3
    8d00:	e59f3020 	ldr	r3, [pc, #32]	; 8d28 <_Z12pseudoRandomii+0xa0>
    8d04:	e5832000 	str	r2, [r3]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:271
	//return shifted
	return rnd_value + start;
    8d08:	e59f3018 	ldr	r3, [pc, #24]	; 8d28 <_Z12pseudoRandomii+0xa0>
    8d0c:	e5932000 	ldr	r2, [r3]
    8d10:	e51b3010 	ldr	r3, [fp, #-16]
    8d14:	e0823003 	add	r3, r2, r3
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:272
}
    8d18:	e1a00003 	mov	r0, r3
    8d1c:	e24bd004 	sub	sp, fp, #4
    8d20:	e8bd8800 	pop	{fp, pc}
    8d24:	0000b918 	andeq	fp, r0, r8, lsl r9
    8d28:	0000b91c 	andeq	fp, r0, ip, lsl r9

00008d2c <_Z12generate_newi>:
_Z12generate_newi():
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:275

//generate new member of generation
void generate_new(int index) {
    8d2c:	e92d4800 	push	{fp, lr}
    8d30:	e28db004 	add	fp, sp, #4
    8d34:	e24dd008 	sub	sp, sp, #8
    8d38:	e50b0008 	str	r0, [fp, #-8]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:276
	genIs(index, 0, pseudoRandom(0-RANDOM_RANGE, RANDOM_RANGE));
    8d3c:	e3a01032 	mov	r1, #50	; 0x32
    8d40:	e3e00031 	mvn	r0, #49	; 0x31
    8d44:	ebffffcf 	bl	8c88 <_Z12pseudoRandomii>
    8d48:	ee070a90 	vmov	s15, r0
    8d4c:	eef87ae7 	vcvt.f32.s32	s15, s15
    8d50:	eeb00a67 	vmov.f32	s0, s15
    8d54:	e3a01000 	mov	r1, #0
    8d58:	e51b0008 	ldr	r0, [fp, #-8]
    8d5c:	ebfffd70 	bl	8324 <_Z5genIsiif>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:277
	genIs(index, 1, pseudoRandom(0-RANDOM_RANGE, RANDOM_RANGE));
    8d60:	e3a01032 	mov	r1, #50	; 0x32
    8d64:	e3e00031 	mvn	r0, #49	; 0x31
    8d68:	ebffffc6 	bl	8c88 <_Z12pseudoRandomii>
    8d6c:	ee070a90 	vmov	s15, r0
    8d70:	eef87ae7 	vcvt.f32.s32	s15, s15
    8d74:	eeb00a67 	vmov.f32	s0, s15
    8d78:	e3a01001 	mov	r1, #1
    8d7c:	e51b0008 	ldr	r0, [fp, #-8]
    8d80:	ebfffd67 	bl	8324 <_Z5genIsiif>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:278
	genIs(index, 2, pseudoRandom(0-RANDOM_RANGE, RANDOM_RANGE));
    8d84:	e3a01032 	mov	r1, #50	; 0x32
    8d88:	e3e00031 	mvn	r0, #49	; 0x31
    8d8c:	ebffffbd 	bl	8c88 <_Z12pseudoRandomii>
    8d90:	ee070a90 	vmov	s15, r0
    8d94:	eef87ae7 	vcvt.f32.s32	s15, s15
    8d98:	eeb00a67 	vmov.f32	s0, s15
    8d9c:	e3a01002 	mov	r1, #2
    8da0:	e51b0008 	ldr	r0, [fp, #-8]
    8da4:	ebfffd5e 	bl	8324 <_Z5genIsiif>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:279
	genIs(index, 3, pseudoRandom(0-RANDOM_RANGE, RANDOM_RANGE));
    8da8:	e3a01032 	mov	r1, #50	; 0x32
    8dac:	e3e00031 	mvn	r0, #49	; 0x31
    8db0:	ebffffb4 	bl	8c88 <_Z12pseudoRandomii>
    8db4:	ee070a90 	vmov	s15, r0
    8db8:	eef87ae7 	vcvt.f32.s32	s15, s15
    8dbc:	eeb00a67 	vmov.f32	s0, s15
    8dc0:	e3a01003 	mov	r1, #3
    8dc4:	e51b0008 	ldr	r0, [fp, #-8]
    8dc8:	ebfffd55 	bl	8324 <_Z5genIsiif>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:280
	genIs(index, 4, pseudoRandom(0-RANDOM_RANGE, RANDOM_RANGE));
    8dcc:	e3a01032 	mov	r1, #50	; 0x32
    8dd0:	e3e00031 	mvn	r0, #49	; 0x31
    8dd4:	ebffffab 	bl	8c88 <_Z12pseudoRandomii>
    8dd8:	ee070a90 	vmov	s15, r0
    8ddc:	eef87ae7 	vcvt.f32.s32	s15, s15
    8de0:	eeb00a67 	vmov.f32	s0, s15
    8de4:	e3a01004 	mov	r1, #4
    8de8:	e51b0008 	ldr	r0, [fp, #-8]
    8dec:	ebfffd4c 	bl	8324 <_Z5genIsiif>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:281
}
    8df0:	e320f000 	nop	{0}
    8df4:	e24bd004 	sub	sp, fp, #4
    8df8:	e8bd8800 	pop	{fp, pc}

00008dfc <_Z4getYiffPf>:
_Z4getYiffPf():
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:284

//mostly for debugging and bcs I am lazy to turn it back
float getY(int x, float y, float oldY, float* params) {
    8dfc:	e92d4800 	push	{fp, lr}
    8e00:	e28db004 	add	fp, sp, #4
    8e04:	e24dd028 	sub	sp, sp, #40	; 0x28
    8e08:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
    8e0c:	ed0b0a09 	vstr	s0, [fp, #-36]	; 0xffffffdc
    8e10:	ed4b0a0a 	vstr	s1, [fp, #-40]	; 0xffffffd8
    8e14:	e50b102c 	str	r1, [fp, #-44]	; 0xffffffd4
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:285
	float a = params[0];
    8e18:	e51b302c 	ldr	r3, [fp, #-44]	; 0xffffffd4
    8e1c:	e5933000 	ldr	r3, [r3]
    8e20:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:286
	float b = params[1];
    8e24:	e51b302c 	ldr	r3, [fp, #-44]	; 0xffffffd4
    8e28:	e5933004 	ldr	r3, [r3, #4]
    8e2c:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:287
	float c = params[2];
    8e30:	e51b302c 	ldr	r3, [fp, #-44]	; 0xffffffd4
    8e34:	e5933008 	ldr	r3, [r3, #8]
    8e38:	e50b3010 	str	r3, [fp, #-16]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:288
	float d = params[3];
    8e3c:	e51b302c 	ldr	r3, [fp, #-44]	; 0xffffffd4
    8e40:	e593300c 	ldr	r3, [r3, #12]
    8e44:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:289
	float e = params[4];
    8e48:	e51b302c 	ldr	r3, [fp, #-44]	; 0xffffffd4
    8e4c:	e5933010 	ldr	r3, [r3, #16]
    8e50:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:290
	return get_y(a, b, c, d, e, x, y, oldY);
    8e54:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8e58:	ee073a90 	vmov	s15, r3
    8e5c:	eef87ae7 	vcvt.f32.s32	s15, s15
    8e60:	ed5b3a0a 	vldr	s7, [fp, #-40]	; 0xffffffd8
    8e64:	ed1b3a09 	vldr	s6, [fp, #-36]	; 0xffffffdc
    8e68:	eef02a67 	vmov.f32	s5, s15
    8e6c:	ed1b2a06 	vldr	s4, [fp, #-24]	; 0xffffffe8
    8e70:	ed5b1a05 	vldr	s3, [fp, #-20]	; 0xffffffec
    8e74:	ed1b1a04 	vldr	s2, [fp, #-16]
    8e78:	ed5b0a03 	vldr	s1, [fp, #-12]
    8e7c:	ed1b0a02 	vldr	s0, [fp, #-8]
    8e80:	ebffff5f 	bl	8c04 <_Z5get_yffffffff>
    8e84:	eef07a40 	vmov.f32	s15, s0
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:291
}
    8e88:	eeb00a67 	vmov.f32	s0, s15
    8e8c:	e24bd004 	sub	sp, fp, #4
    8e90:	e8bd8800 	pop	{fp, pc}

00008e94 <_Z11get_fitnessPf>:
_Z11get_fitnessPf():
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:294

//function to get fitness of member of generation
float get_fitness(float* params) {
    8e94:	e92d4870 	push	{r4, r5, r6, fp, lr}
    8e98:	ed2d8b02 	vpush	{d8}
    8e9c:	e28db018 	add	fp, sp, #24
    8ea0:	e24dd01c 	sub	sp, sp, #28
    8ea4:	e50b0030 	str	r0, [fp, #-48]	; 0xffffffd0
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:295
	float sum = 0;
    8ea8:	e3a03000 	mov	r3, #0
    8eac:	e50b3020 	str	r3, [fp, #-32]	; 0xffffffe0
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:298
	float predictedY, realYWas;
	//for each point I have possible prediction and real value
	for (int i = PRED / DELTA + 1; i < val_counter; i++) {
    8eb0:	e59f3148 	ldr	r3, [pc, #328]	; 9000 <_Z11get_fitnessPf+0x16c>
    8eb4:	e5933000 	ldr	r3, [r3]
    8eb8:	e59f2144 	ldr	r2, [pc, #324]	; 9004 <_Z11get_fitnessPf+0x170>
    8ebc:	e5922000 	ldr	r2, [r2]
    8ec0:	e1a01002 	mov	r1, r2
    8ec4:	e1a00003 	mov	r0, r3
    8ec8:	eb000832 	bl	af98 <__udivsi3>
    8ecc:	e1a03000 	mov	r3, r0
    8ed0:	e2833001 	add	r3, r3, #1
    8ed4:	e50b3024 	str	r3, [fp, #-36]	; 0xffffffdc
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:298 (discriminator 3)
    8ed8:	e51b2024 	ldr	r2, [fp, #-36]	; 0xffffffdc
    8edc:	e59f3124 	ldr	r3, [pc, #292]	; 9008 <_Z11get_fitnessPf+0x174>
    8ee0:	e5933000 	ldr	r3, [r3]
    8ee4:	e1520003 	cmp	r2, r3
    8ee8:	2a00003e 	bcs	8fe8 <_Z11get_fitnessPf+0x154>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:300 (discriminator 2)
		//predict point with old values and check with newly got value
		predictedY = getY(i * DELTA, values[i - (PRED / DELTA)], values[i - 1 - (PRED / DELTA)], params);
    8eec:	e51b3024 	ldr	r3, [fp, #-36]	; 0xffffffdc
    8ef0:	e59f210c 	ldr	r2, [pc, #268]	; 9004 <_Z11get_fitnessPf+0x170>
    8ef4:	e5922000 	ldr	r2, [r2]
    8ef8:	e0030392 	mul	r3, r2, r3
    8efc:	e1a06003 	mov	r6, r3
    8f00:	e59f3104 	ldr	r3, [pc, #260]	; 900c <_Z11get_fitnessPf+0x178>
    8f04:	e5934000 	ldr	r4, [r3]
    8f08:	e51b5024 	ldr	r5, [fp, #-36]	; 0xffffffdc
    8f0c:	e59f30ec 	ldr	r3, [pc, #236]	; 9000 <_Z11get_fitnessPf+0x16c>
    8f10:	e5933000 	ldr	r3, [r3]
    8f14:	e59f20e8 	ldr	r2, [pc, #232]	; 9004 <_Z11get_fitnessPf+0x170>
    8f18:	e5922000 	ldr	r2, [r2]
    8f1c:	e1a01002 	mov	r1, r2
    8f20:	e1a00003 	mov	r0, r3
    8f24:	eb00081b 	bl	af98 <__udivsi3>
    8f28:	e1a03000 	mov	r3, r0
    8f2c:	e0453003 	sub	r3, r5, r3
    8f30:	e1a03103 	lsl	r3, r3, #2
    8f34:	e0843003 	add	r3, r4, r3
    8f38:	ed938a00 	vldr	s16, [r3]
    8f3c:	e59f30c8 	ldr	r3, [pc, #200]	; 900c <_Z11get_fitnessPf+0x178>
    8f40:	e5934000 	ldr	r4, [r3]
    8f44:	e51b5024 	ldr	r5, [fp, #-36]	; 0xffffffdc
    8f48:	e59f30b0 	ldr	r3, [pc, #176]	; 9000 <_Z11get_fitnessPf+0x16c>
    8f4c:	e5933000 	ldr	r3, [r3]
    8f50:	e59f20ac 	ldr	r2, [pc, #172]	; 9004 <_Z11get_fitnessPf+0x170>
    8f54:	e5922000 	ldr	r2, [r2]
    8f58:	e1a01002 	mov	r1, r2
    8f5c:	e1a00003 	mov	r0, r3
    8f60:	eb00080c 	bl	af98 <__udivsi3>
    8f64:	e1a03000 	mov	r3, r0
    8f68:	e0453003 	sub	r3, r5, r3
    8f6c:	e2433001 	sub	r3, r3, #1
    8f70:	e1a03103 	lsl	r3, r3, #2
    8f74:	e0843003 	add	r3, r4, r3
    8f78:	edd37a00 	vldr	s15, [r3]
    8f7c:	e51b1030 	ldr	r1, [fp, #-48]	; 0xffffffd0
    8f80:	eef00a67 	vmov.f32	s1, s15
    8f84:	eeb00a48 	vmov.f32	s0, s16
    8f88:	e1a00006 	mov	r0, r6
    8f8c:	ebffff9a 	bl	8dfc <_Z4getYiffPf>
    8f90:	ed0b0a0a 	vstr	s0, [fp, #-40]	; 0xffffffd8
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:301 (discriminator 2)
		realYWas = values[i];
    8f94:	e59f3070 	ldr	r3, [pc, #112]	; 900c <_Z11get_fitnessPf+0x178>
    8f98:	e5932000 	ldr	r2, [r3]
    8f9c:	e51b3024 	ldr	r3, [fp, #-36]	; 0xffffffdc
    8fa0:	e1a03103 	lsl	r3, r3, #2
    8fa4:	e0823003 	add	r3, r2, r3
    8fa8:	e5933000 	ldr	r3, [r3]
    8fac:	e50b302c 	str	r3, [fp, #-44]	; 0xffffffd4
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:303 (discriminator 2)
		//add a*a for positive value
		sum += (realYWas - predictedY) * (realYWas - predictedY);
    8fb0:	ed1b7a0b 	vldr	s14, [fp, #-44]	; 0xffffffd4
    8fb4:	ed5b7a0a 	vldr	s15, [fp, #-40]	; 0xffffffd8
    8fb8:	ee377a67 	vsub.f32	s14, s14, s15
    8fbc:	ed5b6a0b 	vldr	s13, [fp, #-44]	; 0xffffffd4
    8fc0:	ed5b7a0a 	vldr	s15, [fp, #-40]	; 0xffffffd8
    8fc4:	ee767ae7 	vsub.f32	s15, s13, s15
    8fc8:	ee677a27 	vmul.f32	s15, s14, s15
    8fcc:	ed1b7a08 	vldr	s14, [fp, #-32]	; 0xffffffe0
    8fd0:	ee777a27 	vadd.f32	s15, s14, s15
    8fd4:	ed4b7a08 	vstr	s15, [fp, #-32]	; 0xffffffe0
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:298 (discriminator 2)
	for (int i = PRED / DELTA + 1; i < val_counter; i++) {
    8fd8:	e51b3024 	ldr	r3, [fp, #-36]	; 0xffffffdc
    8fdc:	e2833001 	add	r3, r3, #1
    8fe0:	e50b3024 	str	r3, [fp, #-36]	; 0xffffffdc
    8fe4:	eaffffbb 	b	8ed8 <_Z11get_fitnessPf+0x44>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:305
	}
	return sum;
    8fe8:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8fec:	ee073a90 	vmov	s15, r3
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:306
}
    8ff0:	eeb00a67 	vmov.f32	s0, s15
    8ff4:	e24bd018 	sub	sp, fp, #24
    8ff8:	ecbd8b02 	vpop	{d8}
    8ffc:	e8bd8870 	pop	{r4, r5, r6, fp, pc}
    9000:	0000b46c 	andeq	fp, r0, ip, ror #8
    9004:	0000b468 	andeq	fp, r0, r8, ror #8
    9008:	0000b478 	andeq	fp, r0, r8, ror r4
    900c:	0000b474 	andeq	fp, r0, r4, ror r4

00009010 <_Z5countv>:
_Z5countv():
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:309

//run evolution
float count() {
    9010:	e92d4810 	push	{r4, fp, lr}
    9014:	ed2d8b02 	vpush	{d8}
    9018:	e28db010 	add	fp, sp, #16
    901c:	e24dd07c 	sub	sp, sp, #124	; 0x7c
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:310
	old_best_params=best_params;
    9020:	e59f35f4 	ldr	r3, [pc, #1524]	; 961c <_Z5countv+0x60c>
    9024:	e5933000 	ldr	r3, [r3]
    9028:	e59f25f0 	ldr	r2, [pc, #1520]	; 9620 <_Z5countv+0x610>
    902c:	e5823000 	str	r3, [r2]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:314
	float treshold, fit, best, next_y;
	int bestIndex;
	//if I dont have enough data
	if (val_counter <= (PRED / DELTA) + 1) {
    9030:	e59f35ec 	ldr	r3, [pc, #1516]	; 9624 <_Z5countv+0x614>
    9034:	e5933000 	ldr	r3, [r3]
    9038:	e59f25e8 	ldr	r2, [pc, #1512]	; 9628 <_Z5countv+0x618>
    903c:	e5922000 	ldr	r2, [r2]
    9040:	e1a01002 	mov	r1, r2
    9044:	e1a00003 	mov	r0, r3
    9048:	eb0007d2 	bl	af98 <__udivsi3>
    904c:	e1a03000 	mov	r3, r0
    9050:	e2832001 	add	r2, r3, #1
    9054:	e59f35d0 	ldr	r3, [pc, #1488]	; 962c <_Z5countv+0x61c>
    9058:	e5933000 	ldr	r3, [r3]
    905c:	e1520003 	cmp	r2, r3
    9060:	3a000007 	bcc	9084 <_Z5countv+0x74>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:315
        write(uartFile, "Not enough values\n", 18);
    9064:	e59f35c4 	ldr	r3, [pc, #1476]	; 9630 <_Z5countv+0x620>
    9068:	e5933000 	ldr	r3, [r3]
    906c:	e3a02012 	mov	r2, #18
    9070:	e59f15bc 	ldr	r1, [pc, #1468]	; 9634 <_Z5countv+0x624>
    9074:	e1a00003 	mov	r0, r3
    9078:	eb0002fa 	bl	9c68 <_Z5writejPKcj>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:316
		return -1.0;
    907c:	e59f35b4 	ldr	r3, [pc, #1460]	; 9638 <_Z5countv+0x628>
    9080:	ea000160 	b	9608 <_Z5countv+0x5f8>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:320
	}
	
	//inicialization of population
	else if (val_counter - 1 == (PRED / DELTA) + 1) {
    9084:	e59f35a0 	ldr	r3, [pc, #1440]	; 962c <_Z5countv+0x61c>
    9088:	e5933000 	ldr	r3, [r3]
    908c:	e2434001 	sub	r4, r3, #1
    9090:	e59f358c 	ldr	r3, [pc, #1420]	; 9624 <_Z5countv+0x614>
    9094:	e5933000 	ldr	r3, [r3]
    9098:	e59f2588 	ldr	r2, [pc, #1416]	; 9628 <_Z5countv+0x618>
    909c:	e5922000 	ldr	r2, [r2]
    90a0:	e1a01002 	mov	r1, r2
    90a4:	e1a00003 	mov	r0, r3
    90a8:	eb0007ba 	bl	af98 <__udivsi3>
    90ac:	e1a03000 	mov	r3, r0
    90b0:	e2833001 	add	r3, r3, #1
    90b4:	e1540003 	cmp	r4, r3
    90b8:	1a00000a 	bne	90e8 <_Z5countv+0xd8>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:321
		for (int i = 0; i < POPULATION; i++) {
    90bc:	e3a03000 	mov	r3, #0
    90c0:	e50b3020 	str	r3, [fp, #-32]	; 0xffffffe0
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:321 (discriminator 3)
    90c4:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    90c8:	e3530031 	cmp	r3, #49	; 0x31
    90cc:	8a000005 	bhi	90e8 <_Z5countv+0xd8>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:322 (discriminator 2)
			generate_new(i);
    90d0:	e51b0020 	ldr	r0, [fp, #-32]	; 0xffffffe0
    90d4:	ebffff14 	bl	8d2c <_Z12generate_newi>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:321 (discriminator 2)
		for (int i = 0; i < POPULATION; i++) {
    90d8:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    90dc:	e2833001 	add	r3, r3, #1
    90e0:	e50b3020 	str	r3, [fp, #-32]	; 0xffffffe0
    90e4:	eafffff6 	b	90c4 <_Z5countv+0xb4>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:328
		}
	}

	//1st is best for now
	float tmp[5];
	tmp[0] = gen(0,0);
    90e8:	e3a01000 	mov	r1, #0
    90ec:	e3a00000 	mov	r0, #0
    90f0:	ebfffc4e 	bl	8230 <_Z3genii>
    90f4:	eef07a40 	vmov.f32	s15, s0
    90f8:	ed4b7a19 	vstr	s15, [fp, #-100]	; 0xffffff9c
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:329
	tmp[1] = gen(0,1);
    90fc:	e3a01001 	mov	r1, #1
    9100:	e3a00000 	mov	r0, #0
    9104:	ebfffc49 	bl	8230 <_Z3genii>
    9108:	eef07a40 	vmov.f32	s15, s0
    910c:	ed4b7a18 	vstr	s15, [fp, #-96]	; 0xffffffa0
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:330
	tmp[2] = gen(0,2);
    9110:	e3a01002 	mov	r1, #2
    9114:	e3a00000 	mov	r0, #0
    9118:	ebfffc44 	bl	8230 <_Z3genii>
    911c:	eef07a40 	vmov.f32	s15, s0
    9120:	ed4b7a17 	vstr	s15, [fp, #-92]	; 0xffffffa4
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:331
	tmp[3] = gen(0,3);
    9124:	e3a01003 	mov	r1, #3
    9128:	e3a00000 	mov	r0, #0
    912c:	ebfffc3f 	bl	8230 <_Z3genii>
    9130:	eef07a40 	vmov.f32	s15, s0
    9134:	ed4b7a16 	vstr	s15, [fp, #-88]	; 0xffffffa8
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:332
	tmp[4] = gen(0,4);
    9138:	e3a01004 	mov	r1, #4
    913c:	e3a00000 	mov	r0, #0
    9140:	ebfffc3a 	bl	8230 <_Z3genii>
    9144:	eef07a40 	vmov.f32	s15, s0
    9148:	ed4b7a15 	vstr	s15, [fp, #-84]	; 0xffffffac
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:333
	best = get_fitness(tmp);
    914c:	e24b3064 	sub	r3, fp, #100	; 0x64
    9150:	e1a00003 	mov	r0, r3
    9154:	ebffff4e 	bl	8e94 <_Z11get_fitnessPf>
    9158:	ed0b0a06 	vstr	s0, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:335
	//run for desired number of generations
	for (int i = 0; i < GEN_COUNT; i++) {
    915c:	e3a03000 	mov	r3, #0
    9160:	e50b3024 	str	r3, [fp, #-36]	; 0xffffffdc
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:335 (discriminator 1)
    9164:	e51b3024 	ldr	r3, [fp, #-36]	; 0xffffffdc
    9168:	e3530ffa 	cmp	r3, #1000	; 0x3e8
    916c:	2a00010c 	bcs	95a4 <_Z5countv+0x594>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:337
		//set threshold - wore part of population will be randomized, better will stay and wait for crossing
		int rndIndex = pseudoRandom(0, POPULATION);
    9170:	e3a01032 	mov	r1, #50	; 0x32
    9174:	e3a00000 	mov	r0, #0
    9178:	ebfffec2 	bl	8c88 <_Z12pseudoRandomii>
    917c:	e50b003c 	str	r0, [fp, #-60]	; 0xffffffc4
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:339
		float tmp2[5];
		tmp2[0] = gen(rndIndex,0);
    9180:	e3a01000 	mov	r1, #0
    9184:	e51b003c 	ldr	r0, [fp, #-60]	; 0xffffffc4
    9188:	ebfffc28 	bl	8230 <_Z3genii>
    918c:	eef07a40 	vmov.f32	s15, s0
    9190:	ed4b7a1e 	vstr	s15, [fp, #-120]	; 0xffffff88
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:340
		tmp2[1] = gen(rndIndex,1);
    9194:	e3a01001 	mov	r1, #1
    9198:	e51b003c 	ldr	r0, [fp, #-60]	; 0xffffffc4
    919c:	ebfffc23 	bl	8230 <_Z3genii>
    91a0:	eef07a40 	vmov.f32	s15, s0
    91a4:	ed4b7a1d 	vstr	s15, [fp, #-116]	; 0xffffff8c
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:341
		tmp2[2] = gen(rndIndex,2);
    91a8:	e3a01002 	mov	r1, #2
    91ac:	e51b003c 	ldr	r0, [fp, #-60]	; 0xffffffc4
    91b0:	ebfffc1e 	bl	8230 <_Z3genii>
    91b4:	eef07a40 	vmov.f32	s15, s0
    91b8:	ed4b7a1c 	vstr	s15, [fp, #-112]	; 0xffffff90
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:342
		tmp2[3] = gen(rndIndex,3);
    91bc:	e3a01003 	mov	r1, #3
    91c0:	e51b003c 	ldr	r0, [fp, #-60]	; 0xffffffc4
    91c4:	ebfffc19 	bl	8230 <_Z3genii>
    91c8:	eef07a40 	vmov.f32	s15, s0
    91cc:	ed4b7a1b 	vstr	s15, [fp, #-108]	; 0xffffff94
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:343
		tmp2[4] = gen(rndIndex,4);
    91d0:	e3a01004 	mov	r1, #4
    91d4:	e51b003c 	ldr	r0, [fp, #-60]	; 0xffffffc4
    91d8:	ebfffc14 	bl	8230 <_Z3genii>
    91dc:	eef07a40 	vmov.f32	s15, s0
    91e0:	ed4b7a1a 	vstr	s15, [fp, #-104]	; 0xffffff98
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:344
		treshold = get_fitness(tmp2);
    91e4:	e24b3078 	sub	r3, fp, #120	; 0x78
    91e8:	e1a00003 	mov	r0, r3
    91ec:	ebffff28 	bl	8e94 <_Z11get_fitnessPf>
    91f0:	ed0b0a10 	vstr	s0, [fp, #-64]	; 0xffffffc0
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:347

		//evaluation part
		for (int j = 1; j < POPULATION; j++) {
    91f4:	e3a03001 	mov	r3, #1
    91f8:	e50b3028 	str	r3, [fp, #-40]	; 0xffffffd8
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:347 (discriminator 2)
    91fc:	e51b3028 	ldr	r3, [fp, #-40]	; 0xffffffd8
    9200:	e3530031 	cmp	r3, #49	; 0x31
    9204:	8a000045 	bhi	9320 <_Z5countv+0x310>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:349
			float tmp1[5];
			tmp1[0] = gen(j,0);
    9208:	e3a01000 	mov	r1, #0
    920c:	e51b0028 	ldr	r0, [fp, #-40]	; 0xffffffd8
    9210:	ebfffc06 	bl	8230 <_Z3genii>
    9214:	eef07a40 	vmov.f32	s15, s0
    9218:	ed4b7a23 	vstr	s15, [fp, #-140]	; 0xffffff74
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:350
			tmp1[1] = gen(j,1);
    921c:	e3a01001 	mov	r1, #1
    9220:	e51b0028 	ldr	r0, [fp, #-40]	; 0xffffffd8
    9224:	ebfffc01 	bl	8230 <_Z3genii>
    9228:	eef07a40 	vmov.f32	s15, s0
    922c:	ed4b7a22 	vstr	s15, [fp, #-136]	; 0xffffff78
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:351
			tmp1[2] = gen(j,2);
    9230:	e3a01002 	mov	r1, #2
    9234:	e51b0028 	ldr	r0, [fp, #-40]	; 0xffffffd8
    9238:	ebfffbfc 	bl	8230 <_Z3genii>
    923c:	eef07a40 	vmov.f32	s15, s0
    9240:	ed4b7a21 	vstr	s15, [fp, #-132]	; 0xffffff7c
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:352
			tmp1[3] = gen(j,3);
    9244:	e3a01003 	mov	r1, #3
    9248:	e51b0028 	ldr	r0, [fp, #-40]	; 0xffffffd8
    924c:	ebfffbf7 	bl	8230 <_Z3genii>
    9250:	eef07a40 	vmov.f32	s15, s0
    9254:	ed4b7a20 	vstr	s15, [fp, #-128]	; 0xffffff80
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:353
			tmp1[4] = gen(j,4);
    9258:	e3a01004 	mov	r1, #4
    925c:	e51b0028 	ldr	r0, [fp, #-40]	; 0xffffffd8
    9260:	ebfffbf2 	bl	8230 <_Z3genii>
    9264:	eef07a40 	vmov.f32	s15, s0
    9268:	ed4b7a1f 	vstr	s15, [fp, #-124]	; 0xffffff84
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:355
			//get fit of this member
			fit = get_fitness(tmp1);
    926c:	e24b308c 	sub	r3, fp, #140	; 0x8c
    9270:	e1a00003 	mov	r0, r3
    9274:	ebffff06 	bl	8e94 <_Z11get_fitnessPf>
    9278:	ed0b0a11 	vstr	s0, [fp, #-68]	; 0xffffffbc
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:357
			//if its not good enough replace with new random member
			if (fit > treshold) {
    927c:	ed1b7a11 	vldr	s14, [fp, #-68]	; 0xffffffbc
    9280:	ed5b7a10 	vldr	s15, [fp, #-64]	; 0xffffffc0
    9284:	eeb47ae7 	vcmpe.f32	s14, s15
    9288:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    928c:	da000002 	ble	929c <_Z5countv+0x28c>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:358
				generate_new(j);
    9290:	e51b0028 	ldr	r0, [fp, #-40]	; 0xffffffd8
    9294:	ebfffea4 	bl	8d2c <_Z12generate_newi>
    9298:	ea00001c 	b	9310 <_Z5countv+0x300>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:361
			}
			//if its good, keep it and check for best
			else if (fit < best) {
    929c:	ed1b7a11 	vldr	s14, [fp, #-68]	; 0xffffffbc
    92a0:	ed5b7a06 	vldr	s15, [fp, #-24]	; 0xffffffe8
    92a4:	eeb47ae7 	vcmpe.f32	s14, s15
    92a8:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    92ac:	5a000017 	bpl	9310 <_Z5countv+0x300>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:362
				best = fit;
    92b0:	e51b3044 	ldr	r3, [fp, #-68]	; 0xffffffbc
    92b4:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:363
				best_index = j;
    92b8:	e51b3028 	ldr	r3, [fp, #-40]	; 0xffffffd8
    92bc:	e59f2378 	ldr	r2, [pc, #888]	; 963c <_Z5countv+0x62c>
    92c0:	e5823000 	str	r3, [r2]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:364
				for (int k = 0; k < 5; k++) {
    92c4:	e3a03000 	mov	r3, #0
    92c8:	e50b302c 	str	r3, [fp, #-44]	; 0xffffffd4
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:364 (discriminator 3)
    92cc:	e51b302c 	ldr	r3, [fp, #-44]	; 0xffffffd4
    92d0:	e3530004 	cmp	r3, #4
    92d4:	ca00000d 	bgt	9310 <_Z5countv+0x300>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:365 (discriminator 2)
					best_params[k] = gen(j,k);
    92d8:	e59f333c 	ldr	r3, [pc, #828]	; 961c <_Z5countv+0x60c>
    92dc:	e5932000 	ldr	r2, [r3]
    92e0:	e51b302c 	ldr	r3, [fp, #-44]	; 0xffffffd4
    92e4:	e1a03103 	lsl	r3, r3, #2
    92e8:	e0824003 	add	r4, r2, r3
    92ec:	e51b102c 	ldr	r1, [fp, #-44]	; 0xffffffd4
    92f0:	e51b0028 	ldr	r0, [fp, #-40]	; 0xffffffd8
    92f4:	ebfffbcd 	bl	8230 <_Z3genii>
    92f8:	eef07a40 	vmov.f32	s15, s0
    92fc:	edc47a00 	vstr	s15, [r4]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:364 (discriminator 2)
				for (int k = 0; k < 5; k++) {
    9300:	e51b302c 	ldr	r3, [fp, #-44]	; 0xffffffd4
    9304:	e2833001 	add	r3, r3, #1
    9308:	e50b302c 	str	r3, [fp, #-44]	; 0xffffffd4
    930c:	eaffffee 	b	92cc <_Z5countv+0x2bc>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:347 (discriminator 1)
		for (int j = 1; j < POPULATION; j++) {
    9310:	e51b3028 	ldr	r3, [fp, #-40]	; 0xffffffd8
    9314:	e2833001 	add	r3, r3, #1
    9318:	e50b3028 	str	r3, [fp, #-40]	; 0xffffffd8
    931c:	eaffffb6 	b	91fc <_Z5countv+0x1ec>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:371
				}
			}
		}
		
		//count new y
		next_y = getY(val_counter + 1, values[val_counter - 1], values[val_counter - 2], best_params);
    9320:	e59f3304 	ldr	r3, [pc, #772]	; 962c <_Z5countv+0x61c>
    9324:	e5933000 	ldr	r3, [r3]
    9328:	e2833001 	add	r3, r3, #1
    932c:	e1a00003 	mov	r0, r3
    9330:	e59f3308 	ldr	r3, [pc, #776]	; 9640 <_Z5countv+0x630>
    9334:	e5932000 	ldr	r2, [r3]
    9338:	e59f32ec 	ldr	r3, [pc, #748]	; 962c <_Z5countv+0x61c>
    933c:	e5933000 	ldr	r3, [r3]
    9340:	e2433107 	sub	r3, r3, #-1073741823	; 0xc0000001
    9344:	e1a03103 	lsl	r3, r3, #2
    9348:	e0823003 	add	r3, r2, r3
    934c:	edd37a00 	vldr	s15, [r3]
    9350:	e59f32e8 	ldr	r3, [pc, #744]	; 9640 <_Z5countv+0x630>
    9354:	e5932000 	ldr	r2, [r3]
    9358:	e59f32cc 	ldr	r3, [pc, #716]	; 962c <_Z5countv+0x61c>
    935c:	e5933000 	ldr	r3, [r3]
    9360:	e243310b 	sub	r3, r3, #-1073741822	; 0xc0000002
    9364:	e1a03103 	lsl	r3, r3, #2
    9368:	e0823003 	add	r3, r2, r3
    936c:	ed937a00 	vldr	s14, [r3]
    9370:	e59f32a4 	ldr	r3, [pc, #676]	; 961c <_Z5countv+0x60c>
    9374:	e5933000 	ldr	r3, [r3]
    9378:	e1a01003 	mov	r1, r3
    937c:	eef00a47 	vmov.f32	s1, s14
    9380:	eeb00a67 	vmov.f32	s0, s15
    9384:	ebfffe9c 	bl	8dfc <_Z4getYiffPf>
    9388:	ed0b0a07 	vstr	s0, [fp, #-28]	; 0xffffffe4
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:374
		
		//crossing
		for (int i = 0; i < POPULATION; i++) {
    938c:	e3a03000 	mov	r3, #0
    9390:	e50b3030 	str	r3, [fp, #-48]	; 0xffffffd0
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:374 (discriminator 1)
    9394:	e51b3030 	ldr	r3, [fp, #-48]	; 0xffffffd0
    9398:	e3530031 	cmp	r3, #49	; 0x31
    939c:	8a000024 	bhi	9434 <_Z5countv+0x424>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:377
			
			//0-5x cross
			for (int j = 0; j < pseudoRandom(0, 5); j++) {
    93a0:	e3a03000 	mov	r3, #0
    93a4:	e50b3034 	str	r3, [fp, #-52]	; 0xffffffcc
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:377 (discriminator 3)
    93a8:	e3a01005 	mov	r1, #5
    93ac:	e3a00000 	mov	r0, #0
    93b0:	ebfffe34 	bl	8c88 <_Z12pseudoRandomii>
    93b4:	e1a02000 	mov	r2, r0
    93b8:	e51b3034 	ldr	r3, [fp, #-52]	; 0xffffffcc
    93bc:	e1530002 	cmp	r3, r2
    93c0:	b3a03001 	movlt	r3, #1
    93c4:	a3a03000 	movge	r3, #0
    93c8:	e6ef3073 	uxtb	r3, r3
    93cc:	e3530000 	cmp	r3, #0
    93d0:	0a000013 	beq	9424 <_Z5countv+0x414>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:379 (discriminator 2)
				//random position
				int a = pseudoRandom(0, 4);		//with random member of population
    93d4:	e3a01004 	mov	r1, #4
    93d8:	e3a00000 	mov	r0, #0
    93dc:	ebfffe29 	bl	8c88 <_Z12pseudoRandomii>
    93e0:	e50b0048 	str	r0, [fp, #-72]	; 0xffffffb8
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:380 (discriminator 2)
				genIs(i, a, gen(pseudoRandom(0, POPULATION), a));
    93e4:	e3a01032 	mov	r1, #50	; 0x32
    93e8:	e3a00000 	mov	r0, #0
    93ec:	ebfffe25 	bl	8c88 <_Z12pseudoRandomii>
    93f0:	e1a03000 	mov	r3, r0
    93f4:	e51b1048 	ldr	r1, [fp, #-72]	; 0xffffffb8
    93f8:	e1a00003 	mov	r0, r3
    93fc:	ebfffb8b 	bl	8230 <_Z3genii>
    9400:	eef07a40 	vmov.f32	s15, s0
    9404:	eeb00a67 	vmov.f32	s0, s15
    9408:	e51b1048 	ldr	r1, [fp, #-72]	; 0xffffffb8
    940c:	e51b0030 	ldr	r0, [fp, #-48]	; 0xffffffd0
    9410:	ebfffbc3 	bl	8324 <_Z5genIsiif>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:377 (discriminator 2)
			for (int j = 0; j < pseudoRandom(0, 5); j++) {
    9414:	e51b3034 	ldr	r3, [fp, #-52]	; 0xffffffcc
    9418:	e2833001 	add	r3, r3, #1
    941c:	e50b3034 	str	r3, [fp, #-52]	; 0xffffffcc
    9420:	eaffffe0 	b	93a8 <_Z5countv+0x398>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:374 (discriminator 2)
		for (int i = 0; i < POPULATION; i++) {
    9424:	e51b3030 	ldr	r3, [fp, #-48]	; 0xffffffd0
    9428:	e2833001 	add	r3, r3, #1
    942c:	e50b3030 	str	r3, [fp, #-48]	; 0xffffffd0
    9430:	eaffffd7 	b	9394 <_Z5countv+0x384>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:385
			}
		}
		
		//mutaion - for each member of population
		for (int i = 0; i < POPULATION; i++) {
    9434:	e3a03000 	mov	r3, #0
    9438:	e50b3038 	str	r3, [fp, #-56]	; 0xffffffc8
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:385 (discriminator 1)
    943c:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    9440:	e3530031 	cmp	r3, #49	; 0x31
    9444:	8a000024 	bhi	94dc <_Z5countv+0x4cc>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:387
			//there is chance to mutate (chance is PROBABILITY_OF_MUTAION_PERCENT)
			if (pseudoRandom(0, 100) <= PROBABILITY_OF_MUTAION_PERCENT) {
    9448:	e3a01064 	mov	r1, #100	; 0x64
    944c:	e3a00000 	mov	r0, #0
    9450:	ebfffe0c 	bl	8c88 <_Z12pseudoRandomii>
    9454:	e1a03000 	mov	r3, r0
    9458:	e353000a 	cmp	r3, #10
    945c:	93a03001 	movls	r3, #1
    9460:	83a03000 	movhi	r3, #0
    9464:	e6ef3073 	uxtb	r3, r3
    9468:	e3530000 	cmp	r3, #0
    946c:	0a000016 	beq	94cc <_Z5countv+0x4bc>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:389
				//then one of its parameters mutates
				float tmpGen = gen(i,pseudoRandom(0, 4)) + pseudoRandom(0-RANDOM_RANGE/5, RANDOM_RANGE/5);
    9470:	e3a01004 	mov	r1, #4
    9474:	e3a00000 	mov	r0, #0
    9478:	ebfffe02 	bl	8c88 <_Z12pseudoRandomii>
    947c:	e1a03000 	mov	r3, r0
    9480:	e1a01003 	mov	r1, r3
    9484:	e51b0038 	ldr	r0, [fp, #-56]	; 0xffffffc8
    9488:	ebfffb68 	bl	8230 <_Z3genii>
    948c:	eeb08a40 	vmov.f32	s16, s0
    9490:	e3a0100a 	mov	r1, #10
    9494:	e3e00009 	mvn	r0, #9
    9498:	ebfffdfa 	bl	8c88 <_Z12pseudoRandomii>
    949c:	ee070a90 	vmov	s15, r0
    94a0:	eef87ae7 	vcvt.f32.s32	s15, s15
    94a4:	ee787a27 	vadd.f32	s15, s16, s15
    94a8:	ed4b7a13 	vstr	s15, [fp, #-76]	; 0xffffffb4
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:390
				genIs(i,pseudoRandom(0, 4), tmpGen);
    94ac:	e3a01004 	mov	r1, #4
    94b0:	e3a00000 	mov	r0, #0
    94b4:	ebfffdf3 	bl	8c88 <_Z12pseudoRandomii>
    94b8:	e1a03000 	mov	r3, r0
    94bc:	ed1b0a13 	vldr	s0, [fp, #-76]	; 0xffffffb4
    94c0:	e1a01003 	mov	r1, r3
    94c4:	e51b0038 	ldr	r0, [fp, #-56]	; 0xffffffc8
    94c8:	ebfffb95 	bl	8324 <_Z5genIsiif>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:385 (discriminator 2)
		for (int i = 0; i < POPULATION; i++) {
    94cc:	e51b3038 	ldr	r3, [fp, #-56]	; 0xffffffc8
    94d0:	e2833001 	add	r3, r3, #1
    94d4:	e50b3038 	str	r3, [fp, #-56]	; 0xffffffc8
    94d8:	eaffffd7 	b	943c <_Z5countv+0x42c>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:396
				
			}
		}
		
		//check if there is not stop in console
		console_in(32, false);
    94dc:	e3a01000 	mov	r1, #0
    94e0:	e3a00020 	mov	r0, #32
    94e4:	ebfffc01 	bl	84f0 <_Z10console_injb>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:397
		if(checkForStop(readValue, 32)){
    94e8:	e3a01020 	mov	r1, #32
    94ec:	e59f0150 	ldr	r0, [pc, #336]	; 9644 <_Z5countv+0x634>
    94f0:	ebfffbcc 	bl	8428 <_Z12checkForStopPcj>
    94f4:	e1a03000 	mov	r3, r0
    94f8:	e3530000 	cmp	r3, #0
    94fc:	0a000024 	beq	9594 <_Z5countv+0x584>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:398
			next_y = getY(val_counter + 1, values[val_counter - 1], values[val_counter - 2], old_best_params);
    9500:	e59f3124 	ldr	r3, [pc, #292]	; 962c <_Z5countv+0x61c>
    9504:	e5933000 	ldr	r3, [r3]
    9508:	e2833001 	add	r3, r3, #1
    950c:	e1a00003 	mov	r0, r3
    9510:	e59f3128 	ldr	r3, [pc, #296]	; 9640 <_Z5countv+0x630>
    9514:	e5932000 	ldr	r2, [r3]
    9518:	e59f310c 	ldr	r3, [pc, #268]	; 962c <_Z5countv+0x61c>
    951c:	e5933000 	ldr	r3, [r3]
    9520:	e2433107 	sub	r3, r3, #-1073741823	; 0xc0000001
    9524:	e1a03103 	lsl	r3, r3, #2
    9528:	e0823003 	add	r3, r2, r3
    952c:	edd37a00 	vldr	s15, [r3]
    9530:	e59f3108 	ldr	r3, [pc, #264]	; 9640 <_Z5countv+0x630>
    9534:	e5932000 	ldr	r2, [r3]
    9538:	e59f30ec 	ldr	r3, [pc, #236]	; 962c <_Z5countv+0x61c>
    953c:	e5933000 	ldr	r3, [r3]
    9540:	e243310b 	sub	r3, r3, #-1073741822	; 0xc0000002
    9544:	e1a03103 	lsl	r3, r3, #2
    9548:	e0823003 	add	r3, r2, r3
    954c:	ed937a00 	vldr	s14, [r3]
    9550:	e59f30c8 	ldr	r3, [pc, #200]	; 9620 <_Z5countv+0x610>
    9554:	e5933000 	ldr	r3, [r3]
    9558:	e1a01003 	mov	r1, r3
    955c:	eef00a47 	vmov.f32	s1, s14
    9560:	eeb00a67 	vmov.f32	s0, s15
    9564:	ebfffe24 	bl	8dfc <_Z4getYiffPf>
    9568:	ed0b0a07 	vstr	s0, [fp, #-28]	; 0xffffffe4
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:399
			best_params = old_best_params;
    956c:	e59f30ac 	ldr	r3, [pc, #172]	; 9620 <_Z5countv+0x610>
    9570:	e5933000 	ldr	r3, [r3]
    9574:	e59f20a0 	ldr	r2, [pc, #160]	; 961c <_Z5countv+0x60c>
    9578:	e5823000 	str	r3, [r2]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:400
			best = get_fitness(old_best_params);			
    957c:	e59f309c 	ldr	r3, [pc, #156]	; 9620 <_Z5countv+0x610>
    9580:	e5933000 	ldr	r3, [r3]
    9584:	e1a00003 	mov	r0, r3
    9588:	ebfffe41 	bl	8e94 <_Z11get_fitnessPf>
    958c:	ed0b0a06 	vstr	s0, [fp, #-24]	; 0xffffffe8
    9590:	ea000003 	b	95a4 <_Z5countv+0x594>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:335
	for (int i = 0; i < GEN_COUNT; i++) {
    9594:	e51b3024 	ldr	r3, [fp, #-36]	; 0xffffffdc
    9598:	e2833001 	add	r3, r3, #1
    959c:	e50b3024 	str	r3, [fp, #-36]	; 0xffffffdc
    95a0:	eafffeef 	b	9164 <_Z5countv+0x154>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:407
		}

	}

	//write out info from this run
	char* bestChar = reinterpret_cast<char*>(malloc(16));
    95a4:	e3a00010 	mov	r0, #16
    95a8:	eb000283 	bl	9fbc <_Z6mallocj>
    95ac:	e50b0050 	str	r0, [fp, #-80]	; 0xffffffb0
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:408
	ftoa(bestChar, best);	
    95b0:	ed1b0a06 	vldr	s0, [fp, #-24]	; 0xffffffe8
    95b4:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    95b8:	eb0003f3 	bl	a58c <_Z4ftoaPcf>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:409
	write(uartFile, "Best Fit: ", 10);
    95bc:	e59f306c 	ldr	r3, [pc, #108]	; 9630 <_Z5countv+0x620>
    95c0:	e5933000 	ldr	r3, [r3]
    95c4:	e3a0200a 	mov	r2, #10
    95c8:	e59f1078 	ldr	r1, [pc, #120]	; 9648 <_Z5countv+0x638>
    95cc:	e1a00003 	mov	r0, r3
    95d0:	eb0001a4 	bl	9c68 <_Z5writejPKcj>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:410
	write(uartFile, bestChar, 16);
    95d4:	e59f3054 	ldr	r3, [pc, #84]	; 9630 <_Z5countv+0x620>
    95d8:	e5933000 	ldr	r3, [r3]
    95dc:	e3a02010 	mov	r2, #16
    95e0:	e51b1050 	ldr	r1, [fp, #-80]	; 0xffffffb0
    95e4:	e1a00003 	mov	r0, r3
    95e8:	eb00019e 	bl	9c68 <_Z5writejPKcj>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:411
	write(uartFile, "\n", 1);
    95ec:	e59f303c 	ldr	r3, [pc, #60]	; 9630 <_Z5countv+0x620>
    95f0:	e5933000 	ldr	r3, [r3]
    95f4:	e3a02001 	mov	r2, #1
    95f8:	e59f104c 	ldr	r1, [pc, #76]	; 964c <_Z5countv+0x63c>
    95fc:	e1a00003 	mov	r0, r3
    9600:	eb000198 	bl	9c68 <_Z5writejPKcj>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:413
	
	return next_y;
    9604:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    9608:	ee073a90 	vmov	s15, r3
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:414 (discriminator 2)
}
    960c:	eeb00a67 	vmov.f32	s0, s15
    9610:	e24bd010 	sub	sp, fp, #16
    9614:	ecbd8b02 	vpop	{d8}
    9618:	e8bd8810 	pop	{r4, fp, pc}
    961c:	0000b920 	andeq	fp, r0, r0, lsr #18
    9620:	0000b924 	andeq	fp, r0, r4, lsr #18
    9624:	0000b46c 	andeq	fp, r0, ip, ror #8
    9628:	0000b468 	andeq	fp, r0, r8, ror #8
    962c:	0000b478 	andeq	fp, r0, r8, ror r4
    9630:	0000b914 	andeq	fp, r0, r4, lsl r9
    9634:	0000b23c 	andeq	fp, r0, ip, lsr r2
    9638:	bf800000 	svclt	0x00800000
    963c:	0000b864 	andeq	fp, r0, r4, ror #16
    9640:	0000b474 	andeq	fp, r0, r4, ror r4
    9644:	0000b86c 	andeq	fp, r0, ip, ror #16
    9648:	0000b250 	andeq	fp, r0, r0, asr r2
    964c:	0000b1e4 	andeq	fp, r0, r4, ror #3

00009650 <_Z10printParamv>:
_Z10printParamv():
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:417

//function to write parameters
void printParam(){
    9650:	e92d4800 	push	{fp, lr}
    9654:	e28db004 	add	fp, sp, #4
    9658:	e24dd018 	sub	sp, sp, #24
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:420

	//alloc space
	char* a =  reinterpret_cast<char*>(malloc(16));
    965c:	e3a00010 	mov	r0, #16
    9660:	eb000255 	bl	9fbc <_Z6mallocj>
    9664:	e50b0008 	str	r0, [fp, #-8]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:421
	char*  b =  reinterpret_cast<char*>(malloc(16));
    9668:	e3a00010 	mov	r0, #16
    966c:	eb000252 	bl	9fbc <_Z6mallocj>
    9670:	e50b000c 	str	r0, [fp, #-12]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:422
	char*  c =  reinterpret_cast<char*>(malloc(16));
    9674:	e3a00010 	mov	r0, #16
    9678:	eb00024f 	bl	9fbc <_Z6mallocj>
    967c:	e50b0010 	str	r0, [fp, #-16]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:423
	char*  d =  reinterpret_cast<char*>(malloc(16));
    9680:	e3a00010 	mov	r0, #16
    9684:	eb00024c 	bl	9fbc <_Z6mallocj>
    9688:	e50b0014 	str	r0, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:424
	char*  e =  reinterpret_cast<char*>(malloc(16));
    968c:	e3a00010 	mov	r0, #16
    9690:	eb000249 	bl	9fbc <_Z6mallocj>
    9694:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:426
	//clear
	bzero(a, 16);
    9698:	e3a01010 	mov	r1, #16
    969c:	e51b0008 	ldr	r0, [fp, #-8]
    96a0:	eb0004ec 	bl	aa58 <_Z5bzeroPvi>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:427
	bzero(b, 16);
    96a4:	e3a01010 	mov	r1, #16
    96a8:	e51b000c 	ldr	r0, [fp, #-12]
    96ac:	eb0004e9 	bl	aa58 <_Z5bzeroPvi>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:428
	bzero(c, 16);
    96b0:	e3a01010 	mov	r1, #16
    96b4:	e51b0010 	ldr	r0, [fp, #-16]
    96b8:	eb0004e6 	bl	aa58 <_Z5bzeroPvi>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:429
	bzero(d, 16);
    96bc:	e3a01010 	mov	r1, #16
    96c0:	e51b0014 	ldr	r0, [fp, #-20]	; 0xffffffec
    96c4:	eb0004e3 	bl	aa58 <_Z5bzeroPvi>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:430
	bzero(e, 16);
    96c8:	e3a01010 	mov	r1, #16
    96cc:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    96d0:	eb0004e0 	bl	aa58 <_Z5bzeroPvi>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:432
	//make strings from floats
	ftoa(a, best_params[0]);
    96d4:	e59f3194 	ldr	r3, [pc, #404]	; 9870 <_Z10printParamv+0x220>
    96d8:	e5933000 	ldr	r3, [r3]
    96dc:	edd37a00 	vldr	s15, [r3]
    96e0:	eeb00a67 	vmov.f32	s0, s15
    96e4:	e51b0008 	ldr	r0, [fp, #-8]
    96e8:	eb0003a7 	bl	a58c <_Z4ftoaPcf>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:433
	ftoa(b, best_params[1]);
    96ec:	e59f317c 	ldr	r3, [pc, #380]	; 9870 <_Z10printParamv+0x220>
    96f0:	e5933000 	ldr	r3, [r3]
    96f4:	e2833004 	add	r3, r3, #4
    96f8:	edd37a00 	vldr	s15, [r3]
    96fc:	eeb00a67 	vmov.f32	s0, s15
    9700:	e51b000c 	ldr	r0, [fp, #-12]
    9704:	eb0003a0 	bl	a58c <_Z4ftoaPcf>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:434
	ftoa(c, best_params[2]);
    9708:	e59f3160 	ldr	r3, [pc, #352]	; 9870 <_Z10printParamv+0x220>
    970c:	e5933000 	ldr	r3, [r3]
    9710:	e2833008 	add	r3, r3, #8
    9714:	edd37a00 	vldr	s15, [r3]
    9718:	eeb00a67 	vmov.f32	s0, s15
    971c:	e51b0010 	ldr	r0, [fp, #-16]
    9720:	eb000399 	bl	a58c <_Z4ftoaPcf>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:435
	ftoa(d, best_params[3]);
    9724:	e59f3144 	ldr	r3, [pc, #324]	; 9870 <_Z10printParamv+0x220>
    9728:	e5933000 	ldr	r3, [r3]
    972c:	e283300c 	add	r3, r3, #12
    9730:	edd37a00 	vldr	s15, [r3]
    9734:	eeb00a67 	vmov.f32	s0, s15
    9738:	e51b0014 	ldr	r0, [fp, #-20]	; 0xffffffec
    973c:	eb000392 	bl	a58c <_Z4ftoaPcf>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:436
	ftoa(e, best_params[4]);
    9740:	e59f3128 	ldr	r3, [pc, #296]	; 9870 <_Z10printParamv+0x220>
    9744:	e5933000 	ldr	r3, [r3]
    9748:	e2833010 	add	r3, r3, #16
    974c:	edd37a00 	vldr	s15, [r3]
    9750:	eeb00a67 	vmov.f32	s0, s15
    9754:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    9758:	eb00038b 	bl	a58c <_Z4ftoaPcf>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:438
	//write strings to console
	write(uartFile, "A = ", 4);
    975c:	e59f3110 	ldr	r3, [pc, #272]	; 9874 <_Z10printParamv+0x224>
    9760:	e5933000 	ldr	r3, [r3]
    9764:	e3a02004 	mov	r2, #4
    9768:	e59f1108 	ldr	r1, [pc, #264]	; 9878 <_Z10printParamv+0x228>
    976c:	e1a00003 	mov	r0, r3
    9770:	eb00013c 	bl	9c68 <_Z5writejPKcj>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:439
	write(uartFile, reinterpret_cast<const char*>(a), 16);
    9774:	e59f30f8 	ldr	r3, [pc, #248]	; 9874 <_Z10printParamv+0x224>
    9778:	e5933000 	ldr	r3, [r3]
    977c:	e3a02010 	mov	r2, #16
    9780:	e51b1008 	ldr	r1, [fp, #-8]
    9784:	e1a00003 	mov	r0, r3
    9788:	eb000136 	bl	9c68 <_Z5writejPKcj>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:440
	write(uartFile, ", B = ", 6);
    978c:	e59f30e0 	ldr	r3, [pc, #224]	; 9874 <_Z10printParamv+0x224>
    9790:	e5933000 	ldr	r3, [r3]
    9794:	e3a02006 	mov	r2, #6
    9798:	e59f10dc 	ldr	r1, [pc, #220]	; 987c <_Z10printParamv+0x22c>
    979c:	e1a00003 	mov	r0, r3
    97a0:	eb000130 	bl	9c68 <_Z5writejPKcj>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:441
	write(uartFile, reinterpret_cast<const char*>(b), 16);
    97a4:	e59f30c8 	ldr	r3, [pc, #200]	; 9874 <_Z10printParamv+0x224>
    97a8:	e5933000 	ldr	r3, [r3]
    97ac:	e3a02010 	mov	r2, #16
    97b0:	e51b100c 	ldr	r1, [fp, #-12]
    97b4:	e1a00003 	mov	r0, r3
    97b8:	eb00012a 	bl	9c68 <_Z5writejPKcj>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:442
	write(uartFile, ", C = ", 6);
    97bc:	e59f30b0 	ldr	r3, [pc, #176]	; 9874 <_Z10printParamv+0x224>
    97c0:	e5933000 	ldr	r3, [r3]
    97c4:	e3a02006 	mov	r2, #6
    97c8:	e59f10b0 	ldr	r1, [pc, #176]	; 9880 <_Z10printParamv+0x230>
    97cc:	e1a00003 	mov	r0, r3
    97d0:	eb000124 	bl	9c68 <_Z5writejPKcj>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:443
	write(uartFile, reinterpret_cast<const char*>(c), 16);
    97d4:	e59f3098 	ldr	r3, [pc, #152]	; 9874 <_Z10printParamv+0x224>
    97d8:	e5933000 	ldr	r3, [r3]
    97dc:	e3a02010 	mov	r2, #16
    97e0:	e51b1010 	ldr	r1, [fp, #-16]
    97e4:	e1a00003 	mov	r0, r3
    97e8:	eb00011e 	bl	9c68 <_Z5writejPKcj>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:444
	write(uartFile, ", D = ", 6);
    97ec:	e59f3080 	ldr	r3, [pc, #128]	; 9874 <_Z10printParamv+0x224>
    97f0:	e5933000 	ldr	r3, [r3]
    97f4:	e3a02006 	mov	r2, #6
    97f8:	e59f1084 	ldr	r1, [pc, #132]	; 9884 <_Z10printParamv+0x234>
    97fc:	e1a00003 	mov	r0, r3
    9800:	eb000118 	bl	9c68 <_Z5writejPKcj>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:445
	write(uartFile, reinterpret_cast<const char*>(d), 16);
    9804:	e59f3068 	ldr	r3, [pc, #104]	; 9874 <_Z10printParamv+0x224>
    9808:	e5933000 	ldr	r3, [r3]
    980c:	e3a02010 	mov	r2, #16
    9810:	e51b1014 	ldr	r1, [fp, #-20]	; 0xffffffec
    9814:	e1a00003 	mov	r0, r3
    9818:	eb000112 	bl	9c68 <_Z5writejPKcj>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:446
	write(uartFile, ", E = ", 6);
    981c:	e59f3050 	ldr	r3, [pc, #80]	; 9874 <_Z10printParamv+0x224>
    9820:	e5933000 	ldr	r3, [r3]
    9824:	e3a02006 	mov	r2, #6
    9828:	e59f1058 	ldr	r1, [pc, #88]	; 9888 <_Z10printParamv+0x238>
    982c:	e1a00003 	mov	r0, r3
    9830:	eb00010c 	bl	9c68 <_Z5writejPKcj>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:447
	write(uartFile, reinterpret_cast<const char*>(e), 16);
    9834:	e59f3038 	ldr	r3, [pc, #56]	; 9874 <_Z10printParamv+0x224>
    9838:	e5933000 	ldr	r3, [r3]
    983c:	e3a02010 	mov	r2, #16
    9840:	e51b1018 	ldr	r1, [fp, #-24]	; 0xffffffe8
    9844:	e1a00003 	mov	r0, r3
    9848:	eb000106 	bl	9c68 <_Z5writejPKcj>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:448
	write(uartFile, "\n", 1);
    984c:	e59f3020 	ldr	r3, [pc, #32]	; 9874 <_Z10printParamv+0x224>
    9850:	e5933000 	ldr	r3, [r3]
    9854:	e3a02001 	mov	r2, #1
    9858:	e59f102c 	ldr	r1, [pc, #44]	; 988c <_Z10printParamv+0x23c>
    985c:	e1a00003 	mov	r0, r3
    9860:	eb000100 	bl	9c68 <_Z5writejPKcj>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:449
}
    9864:	e320f000 	nop	{0}
    9868:	e24bd004 	sub	sp, fp, #4
    986c:	e8bd8800 	pop	{fp, pc}
    9870:	0000b920 	andeq	fp, r0, r0, lsr #18
    9874:	0000b914 	andeq	fp, r0, r4, lsl r9
    9878:	0000b25c 	andeq	fp, r0, ip, asr r2
    987c:	0000b264 	andeq	fp, r0, r4, ror #4
    9880:	0000b26c 	andeq	fp, r0, ip, ror #4
    9884:	0000b274 	andeq	fp, r0, r4, ror r2
    9888:	0000b27c 	andeq	fp, r0, ip, ror r2
    988c:	0000b1e4 	andeq	fp, r0, r4, ror #3

00009890 <main>:
main():
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:454


//main function - start of program
int main(int argc, char** argv)
{
    9890:	e92d4800 	push	{fp, lr}
    9894:	e28db004 	add	fp, sp, #4
    9898:	e24dd030 	sub	sp, sp, #48	; 0x30
    989c:	e50b0030 	str	r0, [fp, #-48]	; 0xffffffd0
    98a0:	e50b1034 	str	r1, [fp, #-52]	; 0xffffffcc
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:456
	//inicialization of necessary variables
	stop = false;
    98a4:	e59f31d0 	ldr	r3, [pc, #464]	; 9a7c <main+0x1ec>
    98a8:	e3a02000 	mov	r2, #0
    98ac:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:457
	bzero(best_params, 5*sizeof(float));
    98b0:	e59f31c8 	ldr	r3, [pc, #456]	; 9a80 <main+0x1f0>
    98b4:	e5933000 	ldr	r3, [r3]
    98b8:	e3a01014 	mov	r1, #20
    98bc:	e1a00003 	mov	r0, r3
    98c0:	eb000464 	bl	aa58 <_Z5bzeroPvi>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:460
    uint32_t len;
	//open console file
	uartFile = open("DEV:uart/0", NFile_Open_Mode::Read_Write);
    98c4:	e3a01002 	mov	r1, #2
    98c8:	e59f01b4 	ldr	r0, [pc, #436]	; 9a84 <main+0x1f4>
    98cc:	eb0000c0 	bl	9bd4 <_Z4openPKc15NFile_Open_Mode>
    98d0:	e1a03000 	mov	r3, r0
    98d4:	e59f21ac 	ldr	r2, [pc, #428]	; 9a88 <main+0x1f8>
    98d8:	e5823000 	str	r3, [r2]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:464
	
	//irq enable
	TUART_IOCtl_Params params;
    params.interruptType = NUART_Interrupt_Type::RX;
    98dc:	e3a03000 	mov	r3, #0
    98e0:	e50b3028 	str	r3, [fp, #-40]	; 0xffffffd8
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:465
    ioctl(uartFile, NIOCtl_Operation::Enable_Event_Detection, &params);
    98e4:	e59f319c 	ldr	r3, [pc, #412]	; 9a88 <main+0x1f8>
    98e8:	e5933000 	ldr	r3, [r3]
    98ec:	e24b2028 	sub	r2, fp, #40	; 0x28
    98f0:	e3a01002 	mov	r1, #2
    98f4:	e1a00003 	mov	r0, r3
    98f8:	eb0000f9 	bl	9ce4 <_Z5ioctlj16NIOCtl_OperationPv>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:468

	//open random file
	rnd = open("DEV:trng", NFile_Open_Mode::Read_Only);
    98fc:	e3a01000 	mov	r1, #0
    9900:	e59f0184 	ldr	r0, [pc, #388]	; 9a8c <main+0x1fc>
    9904:	eb0000b2 	bl	9bd4 <_Z4openPKc15NFile_Open_Mode>
    9908:	e1a03000 	mov	r3, r0
    990c:	e59f217c 	ldr	r2, [pc, #380]	; 9a90 <main+0x200>
    9910:	e5823000 	str	r3, [r2]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:469
	val_counter = 0;
    9914:	e59f3178 	ldr	r3, [pc, #376]	; 9a94 <main+0x204>
    9918:	e3a02000 	mov	r2, #0
    991c:	e5832000 	str	r2, [r3]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:472

	//write out start info
	const char* start_text = "CalcOS v1.1\nAutor: Jakub Schenk (A21N0069P)\nZadejte nejprve casovy rozestup a predikcni okenko v minutach\nDale podporovane prikazy: stop, parameters\n";
    9920:	e59f3170 	ldr	r3, [pc, #368]	; 9a98 <main+0x208>
    9924:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:473
	write(uartFile, start_text, 152);
    9928:	e59f3158 	ldr	r3, [pc, #344]	; 9a88 <main+0x1f8>
    992c:	e5933000 	ldr	r3, [r3]
    9930:	e3a02098 	mov	r2, #152	; 0x98
    9934:	e51b1008 	ldr	r1, [fp, #-8]
    9938:	e1a00003 	mov	r0, r3
    993c:	eb0000c9 	bl	9c68 <_Z5writejPKcj>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:477
    float next_y;

	//read first two params - delta and prediction
	read_param();
    9940:	ebfffb72 	bl	8710 <_Z10read_paramv>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:480

	//start 2nd part of program - counting based on incomming values
	const char* print_out = "Zadejte prosim \"stop\", \"parameters\" nebo desetinne cislo.\n";
    9944:	e59f3150 	ldr	r3, [pc, #336]	; 9a9c <main+0x20c>
    9948:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:481
    write(uartFile, print_out, 58);
    994c:	e59f3134 	ldr	r3, [pc, #308]	; 9a88 <main+0x1f8>
    9950:	e5933000 	ldr	r3, [r3]
    9954:	e3a0203a 	mov	r2, #58	; 0x3a
    9958:	e51b100c 	ldr	r1, [fp, #-12]
    995c:	e1a00003 	mov	r0, r3
    9960:	eb0000c0 	bl	9c68 <_Z5writejPKcj>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:485

	while (true) {
		//read new value
		uint32_t in = read_input();
    9964:	ebfffc15 	bl	89c0 <_Z10read_inputv>
    9968:	e50b0010 	str	r0, [fp, #-16]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:488
		//new value is in values[val_counter-1], in=was it success?

		if (in == 1)	//stop
    996c:	e51b3010 	ldr	r3, [fp, #-16]
    9970:	e3530001 	cmp	r3, #1
    9974:	0a00003b 	beq	9a68 <main+0x1d8>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:490
			break;
		else if (in == 2){	//parameters
    9978:	e51b3010 	ldr	r3, [fp, #-16]
    997c:	e3530002 	cmp	r3, #2
    9980:	1a000001 	bne	998c <main+0xfc>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:491
			printParam();		
    9984:	ebffff31 	bl	9650 <_Z10printParamv>
    9988:	ea000029 	b	9a34 <main+0x1a4>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:493
		}
		else if (in == 3) {	//unknown string
    998c:	e51b3010 	ldr	r3, [fp, #-16]
    9990:	e3530003 	cmp	r3, #3
    9994:	1a000008 	bne	99bc <main+0x12c>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:494
			const char* print_out = "Zadejte prosim \"stop\", \"parameters\" nebo desetinne cislo.\n";
    9998:	e59f30fc 	ldr	r3, [pc, #252]	; 9a9c <main+0x20c>
    999c:	e50b301c 	str	r3, [fp, #-28]	; 0xffffffe4
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:495
			write(uartFile, print_out, 58);
    99a0:	e59f30e0 	ldr	r3, [pc, #224]	; 9a88 <main+0x1f8>
    99a4:	e5933000 	ldr	r3, [r3]
    99a8:	e3a0203a 	mov	r2, #58	; 0x3a
    99ac:	e51b101c 	ldr	r1, [fp, #-28]	; 0xffffffe4
    99b0:	e1a00003 	mov	r0, r3
    99b4:	eb0000ab 	bl	9c68 <_Z5writejPKcj>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:496
			continue;
    99b8:	ea000029 	b	9a64 <main+0x1d4>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:499
		}
		else {	//number came -> we can try to count predicted y
			next_y = count();
    99bc:	ebfffd93 	bl	9010 <_Z5countv>
    99c0:	ed0b0a05 	vstr	s0, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:503
			
			//so that was counted -> next y (predicted)
			char* next_yChar;
			ftoa(next_yChar, next_y);
    99c4:	ed1b0a05 	vldr	s0, [fp, #-20]	; 0xffffffec
    99c8:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    99cc:	eb0002ee 	bl	a58c <_Z4ftoaPcf>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:506

			//write what was predicted
			write(uartFile, "Predicted Y in the future is: ", 30);
    99d0:	e59f30b0 	ldr	r3, [pc, #176]	; 9a88 <main+0x1f8>
    99d4:	e5933000 	ldr	r3, [r3]
    99d8:	e3a0201e 	mov	r2, #30
    99dc:	e59f10bc 	ldr	r1, [pc, #188]	; 9aa0 <main+0x210>
    99e0:	e1a00003 	mov	r0, r3
    99e4:	eb00009f 	bl	9c68 <_Z5writejPKcj>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:507
			write(uartFile, next_yChar, 8);
    99e8:	e59f3098 	ldr	r3, [pc, #152]	; 9a88 <main+0x1f8>
    99ec:	e5933000 	ldr	r3, [r3]
    99f0:	e3a02008 	mov	r2, #8
    99f4:	e51b1018 	ldr	r1, [fp, #-24]	; 0xffffffe8
    99f8:	e1a00003 	mov	r0, r3
    99fc:	eb000099 	bl	9c68 <_Z5writejPKcj>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:508
            write(uartFile, "\n", 1);
    9a00:	e59f3080 	ldr	r3, [pc, #128]	; 9a88 <main+0x1f8>
    9a04:	e5933000 	ldr	r3, [r3]
    9a08:	e3a02001 	mov	r2, #1
    9a0c:	e59f1090 	ldr	r1, [pc, #144]	; 9aa4 <main+0x214>
    9a10:	e1a00003 	mov	r0, r3
    9a14:	eb000093 	bl	9c68 <_Z5writejPKcj>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:511

			//print actual parameters
			printParam();
    9a18:	ebffff0c 	bl	9650 <_Z10printParamv>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:512
			write(uartFile, "-------------------------------\n", 32);			
    9a1c:	e59f3064 	ldr	r3, [pc, #100]	; 9a88 <main+0x1f8>
    9a20:	e5933000 	ldr	r3, [r3]
    9a24:	e3a02020 	mov	r2, #32
    9a28:	e59f1078 	ldr	r1, [pc, #120]	; 9aa8 <main+0x218>
    9a2c:	e1a00003 	mov	r0, r3
    9a30:	eb00008c 	bl	9c68 <_Z5writejPKcj>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:515
		}
		//if stop was called, exit program
		if(stop){
    9a34:	e59f3040 	ldr	r3, [pc, #64]	; 9a7c <main+0x1ec>
    9a38:	e5d33000 	ldrb	r3, [r3]
    9a3c:	e3530000 	cmp	r3, #0
    9a40:	0affffc7 	beq	9964 <main+0xd4>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:516
			write(uartFile, "Program exit with status 1 - stopped with \"stop\".\n", 50);
    9a44:	e59f303c 	ldr	r3, [pc, #60]	; 9a88 <main+0x1f8>
    9a48:	e5933000 	ldr	r3, [r3]
    9a4c:	e3a02032 	mov	r2, #50	; 0x32
    9a50:	e59f1054 	ldr	r1, [pc, #84]	; 9aac <main+0x21c>
    9a54:	e1a00003 	mov	r0, r3
    9a58:	eb000082 	bl	9c68 <_Z5writejPKcj>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:517
			return 1;
    9a5c:	e3a03001 	mov	r3, #1
    9a60:	ea000002 	b	9a70 <main+0x1e0>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:519
		}
	}
    9a64:	eaffffbe 	b	9964 <main+0xd4>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:489
			break;
    9a68:	e320f000 	nop	{0}
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:520
}	
    9a6c:	e3a03000 	mov	r3, #0
    9a70:	e1a00003 	mov	r0, r3
    9a74:	e24bd004 	sub	sp, fp, #4
    9a78:	e8bd8800 	pop	{fp, pc}
    9a7c:	0000b868 	andeq	fp, r0, r8, ror #16
    9a80:	0000b920 	andeq	fp, r0, r0, lsr #18
    9a84:	0000b284 	andeq	fp, r0, r4, lsl #5
    9a88:	0000b914 	andeq	fp, r0, r4, lsl r9
    9a8c:	0000b290 	muleq	r0, r0, r2
    9a90:	0000b918 	andeq	fp, r0, r8, lsl r9
    9a94:	0000b478 	andeq	fp, r0, r8, ror r4
    9a98:	0000b29c 	muleq	r0, ip, r2
    9a9c:	0000b334 	andeq	fp, r0, r4, lsr r3
    9aa0:	0000b370 	andeq	fp, r0, r0, ror r3
    9aa4:	0000b1e4 	andeq	fp, r0, r4, ror #3
    9aa8:	0000b390 	muleq	r0, r0, r3
    9aac:	0000b3b4 			; <UNDEFINED> instruction: 0x0000b3b4

00009ab0 <_Z41__static_initialization_and_destruction_0ii>:
_Z41__static_initialization_and_destruction_0ii():
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:520
    9ab0:	e92d4800 	push	{fp, lr}
    9ab4:	e28db004 	add	fp, sp, #4
    9ab8:	e24dd008 	sub	sp, sp, #8
    9abc:	e50b0008 	str	r0, [fp, #-8]
    9ac0:	e50b100c 	str	r1, [fp, #-12]
    9ac4:	e51b3008 	ldr	r3, [fp, #-8]
    9ac8:	e3530001 	cmp	r3, #1
    9acc:	1a000014 	bne	9b24 <_Z41__static_initialization_and_destruction_0ii+0x74>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:520 (discriminator 1)
    9ad0:	e51b300c 	ldr	r3, [fp, #-12]
    9ad4:	e59f2054 	ldr	r2, [pc, #84]	; 9b30 <_Z41__static_initialization_and_destruction_0ii+0x80>
    9ad8:	e1530002 	cmp	r3, r2
    9adc:	1a000010 	bne	9b24 <_Z41__static_initialization_and_destruction_0ii+0x74>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:14
float* values = reinterpret_cast<float*>(malloc(16*sizeof(float)));
    9ae0:	e3a00040 	mov	r0, #64	; 0x40
    9ae4:	eb000134 	bl	9fbc <_Z6mallocj>
    9ae8:	e1a03000 	mov	r3, r0
    9aec:	e59f2040 	ldr	r2, [pc, #64]	; 9b34 <_Z41__static_initialization_and_destruction_0ii+0x84>
    9af0:	e5823000 	str	r3, [r2]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:35
Read_Utils reader;
    9af4:	e59f003c 	ldr	r0, [pc, #60]	; 9b38 <_Z41__static_initialization_and_destruction_0ii+0x88>
    9af8:	eb000410 	bl	ab40 <_ZN10Read_UtilsC1Ev>
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:43
float* best_params = reinterpret_cast<float*>(malloc(5*sizeof(float)));
    9afc:	e3a00014 	mov	r0, #20
    9b00:	eb00012d 	bl	9fbc <_Z6mallocj>
    9b04:	e1a03000 	mov	r3, r0
    9b08:	e59f202c 	ldr	r2, [pc, #44]	; 9b3c <_Z41__static_initialization_and_destruction_0ii+0x8c>
    9b0c:	e5823000 	str	r3, [r2]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:45
float* old_best_params = reinterpret_cast<float*>(malloc(5*sizeof(float)));
    9b10:	e3a00014 	mov	r0, #20
    9b14:	eb000128 	bl	9fbc <_Z6mallocj>
    9b18:	e1a03000 	mov	r3, r0
    9b1c:	e59f201c 	ldr	r2, [pc, #28]	; 9b40 <_Z41__static_initialization_and_destruction_0ii+0x90>
    9b20:	e5823000 	str	r3, [r2]
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:520
}	
    9b24:	e320f000 	nop	{0}
    9b28:	e24bd004 	sub	sp, fp, #4
    9b2c:	e8bd8800 	pop	{fp, pc}
    9b30:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>
    9b34:	0000b474 	andeq	fp, r0, r4, ror r4
    9b38:	0000b88c 	andeq	fp, r0, ip, lsl #17
    9b3c:	0000b920 	andeq	fp, r0, r0, lsr #18
    9b40:	0000b924 	andeq	fp, r0, r4, lsr #18

00009b44 <_GLOBAL__sub_I_DELTA>:
_GLOBAL__sub_I_DELTA():
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:520
    9b44:	e92d4800 	push	{fp, lr}
    9b48:	e28db004 	add	fp, sp, #4
    9b4c:	e59f1008 	ldr	r1, [pc, #8]	; 9b5c <_GLOBAL__sub_I_DELTA+0x18>
    9b50:	e3a00001 	mov	r0, #1
    9b54:	ebffffd5 	bl	9ab0 <_Z41__static_initialization_and_destruction_0ii>
    9b58:	e8bd8800 	pop	{fp, pc}
    9b5c:	0000ffff 	strdeq	pc, [r0], -pc	; <UNPREDICTABLE>

00009b60 <_Z6getpidv>:
_Z6getpidv():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:5
#include <stdfile.h>
#include <stdstring.h>

uint32_t getpid()
{
    9b60:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9b64:	e28db000 	add	fp, sp, #0
    9b68:	e24dd00c 	sub	sp, sp, #12
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:8
    uint32_t pid;

    asm volatile("swi 0");
    9b6c:	ef000000 	svc	0x00000000
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:9
    asm volatile("mov %0, r0" : "=r" (pid));
    9b70:	e1a03000 	mov	r3, r0
    9b74:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:11

    return pid;
    9b78:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:12
}
    9b7c:	e1a00003 	mov	r0, r3
    9b80:	e28bd000 	add	sp, fp, #0
    9b84:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9b88:	e12fff1e 	bx	lr

00009b8c <_Z9terminatei>:
_Z9terminatei():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:15

void terminate(int exitcode)
{
    9b8c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9b90:	e28db000 	add	fp, sp, #0
    9b94:	e24dd00c 	sub	sp, sp, #12
    9b98:	e50b0008 	str	r0, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:16
    asm volatile("mov r0, %0" : : "r" (exitcode));
    9b9c:	e51b3008 	ldr	r3, [fp, #-8]
    9ba0:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:17
    asm volatile("swi 1");
    9ba4:	ef000001 	svc	0x00000001
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:18
}
    9ba8:	e320f000 	nop	{0}
    9bac:	e28bd000 	add	sp, fp, #0
    9bb0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9bb4:	e12fff1e 	bx	lr

00009bb8 <_Z11sched_yieldv>:
_Z11sched_yieldv():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:21

void sched_yield()
{
    9bb8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9bbc:	e28db000 	add	fp, sp, #0
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:22
    asm volatile("swi 2");
    9bc0:	ef000002 	svc	0x00000002
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:23
}
    9bc4:	e320f000 	nop	{0}
    9bc8:	e28bd000 	add	sp, fp, #0
    9bcc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9bd0:	e12fff1e 	bx	lr

00009bd4 <_Z4openPKc15NFile_Open_Mode>:
_Z4openPKc15NFile_Open_Mode():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:26

uint32_t open(const char* filename, NFile_Open_Mode mode)
{
    9bd4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9bd8:	e28db000 	add	fp, sp, #0
    9bdc:	e24dd014 	sub	sp, sp, #20
    9be0:	e50b0010 	str	r0, [fp, #-16]
    9be4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:29
    uint32_t file;

    asm volatile("mov r0, %0" : : "r" (filename));
    9be8:	e51b3010 	ldr	r3, [fp, #-16]
    9bec:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:30
    asm volatile("mov r1, %0" : : "r" (mode));
    9bf0:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9bf4:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:31
    asm volatile("swi 64");
    9bf8:	ef000040 	svc	0x00000040
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:32
    asm volatile("mov %0, r0" : "=r" (file));
    9bfc:	e1a03000 	mov	r3, r0
    9c00:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:34

    return file;
    9c04:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:35
}
    9c08:	e1a00003 	mov	r0, r3
    9c0c:	e28bd000 	add	sp, fp, #0
    9c10:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9c14:	e12fff1e 	bx	lr

00009c18 <_Z4readjPcj>:
_Z4readjPcj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:38

uint32_t read(uint32_t file, char* const buffer, uint32_t size)
{
    9c18:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9c1c:	e28db000 	add	fp, sp, #0
    9c20:	e24dd01c 	sub	sp, sp, #28
    9c24:	e50b0010 	str	r0, [fp, #-16]
    9c28:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    9c2c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:41
    uint32_t rdnum;

    asm volatile("mov r0, %0" : : "r" (file));
    9c30:	e51b3010 	ldr	r3, [fp, #-16]
    9c34:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:42
    asm volatile("mov r1, %0" : : "r" (buffer));
    9c38:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9c3c:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:43
    asm volatile("mov r2, %0" : : "r" (size));
    9c40:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9c44:	e1a02003 	mov	r2, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:44
    asm volatile("swi 65");
    9c48:	ef000041 	svc	0x00000041
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:45
    asm volatile("mov %0, r0" : "=r" (rdnum));
    9c4c:	e1a03000 	mov	r3, r0
    9c50:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:47

    return rdnum;
    9c54:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:48
}
    9c58:	e1a00003 	mov	r0, r3
    9c5c:	e28bd000 	add	sp, fp, #0
    9c60:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9c64:	e12fff1e 	bx	lr

00009c68 <_Z5writejPKcj>:
_Z5writejPKcj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:51

uint32_t write(uint32_t file, const char* buffer, uint32_t size)
{
    9c68:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9c6c:	e28db000 	add	fp, sp, #0
    9c70:	e24dd01c 	sub	sp, sp, #28
    9c74:	e50b0010 	str	r0, [fp, #-16]
    9c78:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    9c7c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:54
    uint32_t wrnum;

    asm volatile("mov r0, %0" : : "r" (file));
    9c80:	e51b3010 	ldr	r3, [fp, #-16]
    9c84:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:55
    asm volatile("mov r1, %0" : : "r" (buffer));
    9c88:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9c8c:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:56
    asm volatile("mov r2, %0" : : "r" (size));
    9c90:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9c94:	e1a02003 	mov	r2, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:57
    asm volatile("swi 66");
    9c98:	ef000042 	svc	0x00000042
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:58
    asm volatile("mov %0, r0" : "=r" (wrnum));
    9c9c:	e1a03000 	mov	r3, r0
    9ca0:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:60

    return wrnum;
    9ca4:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:61
}
    9ca8:	e1a00003 	mov	r0, r3
    9cac:	e28bd000 	add	sp, fp, #0
    9cb0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9cb4:	e12fff1e 	bx	lr

00009cb8 <_Z5closej>:
_Z5closej():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:64

void close(uint32_t file)
{
    9cb8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9cbc:	e28db000 	add	fp, sp, #0
    9cc0:	e24dd00c 	sub	sp, sp, #12
    9cc4:	e50b0008 	str	r0, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:65
    asm volatile("mov r0, %0" : : "r" (file));
    9cc8:	e51b3008 	ldr	r3, [fp, #-8]
    9ccc:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:66
    asm volatile("swi 67");
    9cd0:	ef000043 	svc	0x00000043
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:67
}
    9cd4:	e320f000 	nop	{0}
    9cd8:	e28bd000 	add	sp, fp, #0
    9cdc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9ce0:	e12fff1e 	bx	lr

00009ce4 <_Z5ioctlj16NIOCtl_OperationPv>:
_Z5ioctlj16NIOCtl_OperationPv():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:70

uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param)
{
    9ce4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9ce8:	e28db000 	add	fp, sp, #0
    9cec:	e24dd01c 	sub	sp, sp, #28
    9cf0:	e50b0010 	str	r0, [fp, #-16]
    9cf4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    9cf8:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:73
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    9cfc:	e51b3010 	ldr	r3, [fp, #-16]
    9d00:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:74
    asm volatile("mov r1, %0" : : "r" (operation));
    9d04:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9d08:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:75
    asm volatile("mov r2, %0" : : "r" (param));
    9d0c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9d10:	e1a02003 	mov	r2, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:76
    asm volatile("swi 68");
    9d14:	ef000044 	svc	0x00000044
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:77
    asm volatile("mov %0, r0" : "=r" (retcode));
    9d18:	e1a03000 	mov	r3, r0
    9d1c:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:79

    return retcode;
    9d20:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:80
}
    9d24:	e1a00003 	mov	r0, r3
    9d28:	e28bd000 	add	sp, fp, #0
    9d2c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9d30:	e12fff1e 	bx	lr

00009d34 <_Z6notifyjj>:
_Z6notifyjj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:83

uint32_t notify(uint32_t file, uint32_t count)
{
    9d34:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9d38:	e28db000 	add	fp, sp, #0
    9d3c:	e24dd014 	sub	sp, sp, #20
    9d40:	e50b0010 	str	r0, [fp, #-16]
    9d44:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:86
    uint32_t retcnt;

    asm volatile("mov r0, %0" : : "r" (file));
    9d48:	e51b3010 	ldr	r3, [fp, #-16]
    9d4c:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:87
    asm volatile("mov r1, %0" : : "r" (count));
    9d50:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9d54:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:88
    asm volatile("swi 69");
    9d58:	ef000045 	svc	0x00000045
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:89
    asm volatile("mov %0, r0" : "=r" (retcnt));
    9d5c:	e1a03000 	mov	r3, r0
    9d60:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:91

    return retcnt;
    9d64:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:92
}
    9d68:	e1a00003 	mov	r0, r3
    9d6c:	e28bd000 	add	sp, fp, #0
    9d70:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9d74:	e12fff1e 	bx	lr

00009d78 <_Z4waitjjj>:
_Z4waitjjj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:95

NSWI_Result_Code wait(uint32_t file, uint32_t count, uint32_t notified_deadline)
{
    9d78:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9d7c:	e28db000 	add	fp, sp, #0
    9d80:	e24dd01c 	sub	sp, sp, #28
    9d84:	e50b0010 	str	r0, [fp, #-16]
    9d88:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    9d8c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:98
    NSWI_Result_Code retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    9d90:	e51b3010 	ldr	r3, [fp, #-16]
    9d94:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:99
    asm volatile("mov r1, %0" : : "r" (count));
    9d98:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9d9c:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:100
    asm volatile("mov r2, %0" : : "r" (notified_deadline));
    9da0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9da4:	e1a02003 	mov	r2, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:101
    asm volatile("swi 70");
    9da8:	ef000046 	svc	0x00000046
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:102
    asm volatile("mov %0, r0" : "=r" (retcode));
    9dac:	e1a03000 	mov	r3, r0
    9db0:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:104

    return retcode;
    9db4:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:105
}
    9db8:	e1a00003 	mov	r0, r3
    9dbc:	e28bd000 	add	sp, fp, #0
    9dc0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9dc4:	e12fff1e 	bx	lr

00009dc8 <_Z5sleepjj>:
_Z5sleepjj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:108

bool sleep(uint32_t ticks, uint32_t notified_deadline)
{
    9dc8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9dcc:	e28db000 	add	fp, sp, #0
    9dd0:	e24dd014 	sub	sp, sp, #20
    9dd4:	e50b0010 	str	r0, [fp, #-16]
    9dd8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:111
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (ticks));
    9ddc:	e51b3010 	ldr	r3, [fp, #-16]
    9de0:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:112
    asm volatile("mov r1, %0" : : "r" (notified_deadline));
    9de4:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9de8:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:113
    asm volatile("swi 3");
    9dec:	ef000003 	svc	0x00000003
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:114
    asm volatile("mov %0, r0" : "=r" (retcode));
    9df0:	e1a03000 	mov	r3, r0
    9df4:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:116

    return retcode;
    9df8:	e51b3008 	ldr	r3, [fp, #-8]
    9dfc:	e3530000 	cmp	r3, #0
    9e00:	13a03001 	movne	r3, #1
    9e04:	03a03000 	moveq	r3, #0
    9e08:	e6ef3073 	uxtb	r3, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:117
}
    9e0c:	e1a00003 	mov	r0, r3
    9e10:	e28bd000 	add	sp, fp, #0
    9e14:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9e18:	e12fff1e 	bx	lr

00009e1c <_Z24get_active_process_countv>:
_Z24get_active_process_countv():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:120

uint32_t get_active_process_count()
{
    9e1c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9e20:	e28db000 	add	fp, sp, #0
    9e24:	e24dd00c 	sub	sp, sp, #12
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:121
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Active_Process_Count;
    9e28:	e3a03000 	mov	r3, #0
    9e2c:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:124
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    9e30:	e3a03000 	mov	r3, #0
    9e34:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:125
    asm volatile("mov r1, %0" : : "r" (&retval));
    9e38:	e24b300c 	sub	r3, fp, #12
    9e3c:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:126
    asm volatile("swi 4");
    9e40:	ef000004 	svc	0x00000004
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:128

    return retval;
    9e44:	e51b300c 	ldr	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:129
}
    9e48:	e1a00003 	mov	r0, r3
    9e4c:	e28bd000 	add	sp, fp, #0
    9e50:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9e54:	e12fff1e 	bx	lr

00009e58 <_Z14get_tick_countv>:
_Z14get_tick_countv():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:132

uint32_t get_tick_count()
{
    9e58:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9e5c:	e28db000 	add	fp, sp, #0
    9e60:	e24dd00c 	sub	sp, sp, #12
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:133
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Tick_Count;
    9e64:	e3a03001 	mov	r3, #1
    9e68:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:136
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    9e6c:	e3a03001 	mov	r3, #1
    9e70:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:137
    asm volatile("mov r1, %0" : : "r" (&retval));
    9e74:	e24b300c 	sub	r3, fp, #12
    9e78:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:138
    asm volatile("swi 4");
    9e7c:	ef000004 	svc	0x00000004
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:140

    return retval;
    9e80:	e51b300c 	ldr	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:141
}
    9e84:	e1a00003 	mov	r0, r3
    9e88:	e28bd000 	add	sp, fp, #0
    9e8c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9e90:	e12fff1e 	bx	lr

00009e94 <_Z17set_task_deadlinej>:
_Z17set_task_deadlinej():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:144

void set_task_deadline(uint32_t tick_count_required)
{
    9e94:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9e98:	e28db000 	add	fp, sp, #0
    9e9c:	e24dd014 	sub	sp, sp, #20
    9ea0:	e50b0010 	str	r0, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:145
    const NDeadline_Subservice req = NDeadline_Subservice::Set_Relative;
    9ea4:	e3a03000 	mov	r3, #0
    9ea8:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:147

    asm volatile("mov r0, %0" : : "r" (req));
    9eac:	e3a03000 	mov	r3, #0
    9eb0:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:148
    asm volatile("mov r1, %0" : : "r" (&tick_count_required));
    9eb4:	e24b3010 	sub	r3, fp, #16
    9eb8:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:149
    asm volatile("swi 5");
    9ebc:	ef000005 	svc	0x00000005
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:150
}
    9ec0:	e320f000 	nop	{0}
    9ec4:	e28bd000 	add	sp, fp, #0
    9ec8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9ecc:	e12fff1e 	bx	lr

00009ed0 <_Z26get_task_ticks_to_deadlinev>:
_Z26get_task_ticks_to_deadlinev():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:153

uint32_t get_task_ticks_to_deadline()
{
    9ed0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9ed4:	e28db000 	add	fp, sp, #0
    9ed8:	e24dd00c 	sub	sp, sp, #12
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:154
    const NDeadline_Subservice req = NDeadline_Subservice::Get_Remaining;
    9edc:	e3a03001 	mov	r3, #1
    9ee0:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:157
    uint32_t ticks;

    asm volatile("mov r0, %0" : : "r" (req));
    9ee4:	e3a03001 	mov	r3, #1
    9ee8:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:158
    asm volatile("mov r1, %0" : : "r" (&ticks));
    9eec:	e24b300c 	sub	r3, fp, #12
    9ef0:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:159
    asm volatile("swi 5");
    9ef4:	ef000005 	svc	0x00000005
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:161

    return ticks;
    9ef8:	e51b300c 	ldr	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:162
}
    9efc:	e1a00003 	mov	r0, r3
    9f00:	e28bd000 	add	sp, fp, #0
    9f04:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9f08:	e12fff1e 	bx	lr

00009f0c <_Z4pipePKcj>:
_Z4pipePKcj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:167

const char Pipe_File_Prefix[] = "SYS:pipe/";

uint32_t pipe(const char* name, uint32_t buf_size)
{
    9f0c:	e92d4800 	push	{fp, lr}
    9f10:	e28db004 	add	fp, sp, #4
    9f14:	e24dd050 	sub	sp, sp, #80	; 0x50
    9f18:	e50b0050 	str	r0, [fp, #-80]	; 0xffffffb0
    9f1c:	e50b1054 	str	r1, [fp, #-84]	; 0xffffffac
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:169
    char fname[64];
    strncpy(fname, Pipe_File_Prefix, sizeof(Pipe_File_Prefix));
    9f20:	e24b3048 	sub	r3, fp, #72	; 0x48
    9f24:	e3a0200a 	mov	r2, #10
    9f28:	e59f1088 	ldr	r1, [pc, #136]	; 9fb8 <_Z4pipePKcj+0xac>
    9f2c:	e1a00003 	mov	r0, r3
    9f30:	eb000223 	bl	a7c4 <_Z7strncpyPcPKci>
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:170
    strncpy(fname + sizeof(Pipe_File_Prefix), name, sizeof(fname) - sizeof(Pipe_File_Prefix) - 1);
    9f34:	e24b3048 	sub	r3, fp, #72	; 0x48
    9f38:	e283300a 	add	r3, r3, #10
    9f3c:	e3a02035 	mov	r2, #53	; 0x35
    9f40:	e51b1050 	ldr	r1, [fp, #-80]	; 0xffffffb0
    9f44:	e1a00003 	mov	r0, r3
    9f48:	eb00021d 	bl	a7c4 <_Z7strncpyPcPKci>
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:172

    int ncur = sizeof(Pipe_File_Prefix) + strlen(name);
    9f4c:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    9f50:	eb0002ab 	bl	aa04 <_Z6strlenPKc>
    9f54:	e1a03000 	mov	r3, r0
    9f58:	e283300a 	add	r3, r3, #10
    9f5c:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:174

    fname[ncur++] = '#';
    9f60:	e51b3008 	ldr	r3, [fp, #-8]
    9f64:	e2832001 	add	r2, r3, #1
    9f68:	e50b2008 	str	r2, [fp, #-8]
    9f6c:	e24b2004 	sub	r2, fp, #4
    9f70:	e0823003 	add	r3, r2, r3
    9f74:	e3a02023 	mov	r2, #35	; 0x23
    9f78:	e5432044 	strb	r2, [r3, #-68]	; 0xffffffbc
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:176

    itoa(buf_size, &fname[ncur], 10);
    9f7c:	e24b2048 	sub	r2, fp, #72	; 0x48
    9f80:	e51b3008 	ldr	r3, [fp, #-8]
    9f84:	e0823003 	add	r3, r2, r3
    9f88:	e3a0200a 	mov	r2, #10
    9f8c:	e1a01003 	mov	r1, r3
    9f90:	e51b0054 	ldr	r0, [fp, #-84]	; 0xffffffac
    9f94:	eb000019 	bl	a000 <_Z4itoajPcj>
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:178

    return open(fname, NFile_Open_Mode::Read_Write);
    9f98:	e24b3048 	sub	r3, fp, #72	; 0x48
    9f9c:	e3a01002 	mov	r1, #2
    9fa0:	e1a00003 	mov	r0, r3
    9fa4:	ebffff0a 	bl	9bd4 <_Z4openPKc15NFile_Open_Mode>
    9fa8:	e1a03000 	mov	r3, r0
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:179
}
    9fac:	e1a00003 	mov	r0, r3
    9fb0:	e24bd004 	sub	sp, fp, #4
    9fb4:	e8bd8800 	pop	{fp, pc}
    9fb8:	0000b414 	andeq	fp, r0, r4, lsl r4

00009fbc <_Z6mallocj>:
_Z6mallocj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdmem.cpp:7
/**
 * In this function we could have placed anorther second layer of memory assignment resulting in 
 * less often calls of software interrupt and memory allocation.
 */
void* malloc(uint32_t size)
{
    9fbc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9fc0:	e28db000 	add	fp, sp, #0
    9fc4:	e24dd014 	sub	sp, sp, #20
    9fc8:	e50b0010 	str	r0, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdmem.cpp:9
    uint32_t mem_add;
    asm volatile("mov r0, %0" : : "r" (size));
    9fcc:	e51b3010 	ldr	r3, [fp, #-16]
    9fd0:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdmem.cpp:10
    asm volatile("swi 128");
    9fd4:	ef000080 	svc	0x00000080
/home/schenkj/os2022/sp/sources/stdlib/src/stdmem.cpp:11
    asm volatile("mov %0, r0" : "=r" (mem_add));
    9fd8:	e1a03000 	mov	r3, r0
    9fdc:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdmem.cpp:12
	void* ret = reinterpret_cast<void*>(mem_add);
    9fe0:	e51b3008 	ldr	r3, [fp, #-8]
    9fe4:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdmem.cpp:13
    return ret;
    9fe8:	e51b300c 	ldr	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdmem.cpp:14
}
    9fec:	e1a00003 	mov	r0, r3
    9ff0:	e28bd000 	add	sp, fp, #0
    9ff4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9ff8:	e12fff1e 	bx	lr
    9ffc:	00000000 	andeq	r0, r0, r0

0000a000 <_Z4itoajPcj>:
_Z4itoajPcj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:11
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(unsigned int input, char* output, unsigned int base)
{
    a000:	e92d4800 	push	{fp, lr}
    a004:	e28db004 	add	fp, sp, #4
    a008:	e24dd020 	sub	sp, sp, #32
    a00c:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    a010:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    a014:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:12
	int i = 0;
    a018:	e3a03000 	mov	r3, #0
    a01c:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:14

	while (input > 0)
    a020:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a024:	e3530000 	cmp	r3, #0
    a028:	0a000014 	beq	a080 <_Z4itoajPcj+0x80>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:16
	{
		output[i] = CharConvArr[input % base];
    a02c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a030:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    a034:	e1a00003 	mov	r0, r3
    a038:	eb000451 	bl	b184 <__aeabi_uidivmod>
    a03c:	e1a03001 	mov	r3, r1
    a040:	e1a01003 	mov	r1, r3
    a044:	e51b3008 	ldr	r3, [fp, #-8]
    a048:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    a04c:	e0823003 	add	r3, r2, r3
    a050:	e59f2118 	ldr	r2, [pc, #280]	; a170 <_Z4itoajPcj+0x170>
    a054:	e7d22001 	ldrb	r2, [r2, r1]
    a058:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:17
		input /= base;
    a05c:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    a060:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    a064:	eb0003cb 	bl	af98 <__udivsi3>
    a068:	e1a03000 	mov	r3, r0
    a06c:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:18
		i++;
    a070:	e51b3008 	ldr	r3, [fp, #-8]
    a074:	e2833001 	add	r3, r3, #1
    a078:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:14
	while (input > 0)
    a07c:	eaffffe7 	b	a020 <_Z4itoajPcj+0x20>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:21
	}

    if (i == 0)
    a080:	e51b3008 	ldr	r3, [fp, #-8]
    a084:	e3530000 	cmp	r3, #0
    a088:	1a000007 	bne	a0ac <_Z4itoajPcj+0xac>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:23
    {
        output[i] = CharConvArr[0];
    a08c:	e51b3008 	ldr	r3, [fp, #-8]
    a090:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    a094:	e0823003 	add	r3, r2, r3
    a098:	e3a02030 	mov	r2, #48	; 0x30
    a09c:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:24
        i++;
    a0a0:	e51b3008 	ldr	r3, [fp, #-8]
    a0a4:	e2833001 	add	r3, r3, #1
    a0a8:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:27
    }

	output[i] = '\0';
    a0ac:	e51b3008 	ldr	r3, [fp, #-8]
    a0b0:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    a0b4:	e0823003 	add	r3, r2, r3
    a0b8:	e3a02000 	mov	r2, #0
    a0bc:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:28
	i--;
    a0c0:	e51b3008 	ldr	r3, [fp, #-8]
    a0c4:	e2433001 	sub	r3, r3, #1
    a0c8:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:30

	for (int j = 0; j <= i/2; j++)
    a0cc:	e3a03000 	mov	r3, #0
    a0d0:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:30 (discriminator 3)
    a0d4:	e51b3008 	ldr	r3, [fp, #-8]
    a0d8:	e1a02fa3 	lsr	r2, r3, #31
    a0dc:	e0823003 	add	r3, r2, r3
    a0e0:	e1a030c3 	asr	r3, r3, #1
    a0e4:	e1a02003 	mov	r2, r3
    a0e8:	e51b300c 	ldr	r3, [fp, #-12]
    a0ec:	e1530002 	cmp	r3, r2
    a0f0:	ca00001b 	bgt	a164 <_Z4itoajPcj+0x164>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:32 (discriminator 2)
	{
		char c = output[i - j];
    a0f4:	e51b2008 	ldr	r2, [fp, #-8]
    a0f8:	e51b300c 	ldr	r3, [fp, #-12]
    a0fc:	e0423003 	sub	r3, r2, r3
    a100:	e1a02003 	mov	r2, r3
    a104:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    a108:	e0833002 	add	r3, r3, r2
    a10c:	e5d33000 	ldrb	r3, [r3]
    a110:	e54b300d 	strb	r3, [fp, #-13]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:33 (discriminator 2)
		output[i - j] = output[j];
    a114:	e51b300c 	ldr	r3, [fp, #-12]
    a118:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    a11c:	e0822003 	add	r2, r2, r3
    a120:	e51b1008 	ldr	r1, [fp, #-8]
    a124:	e51b300c 	ldr	r3, [fp, #-12]
    a128:	e0413003 	sub	r3, r1, r3
    a12c:	e1a01003 	mov	r1, r3
    a130:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    a134:	e0833001 	add	r3, r3, r1
    a138:	e5d22000 	ldrb	r2, [r2]
    a13c:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:34 (discriminator 2)
		output[j] = c;
    a140:	e51b300c 	ldr	r3, [fp, #-12]
    a144:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    a148:	e0823003 	add	r3, r2, r3
    a14c:	e55b200d 	ldrb	r2, [fp, #-13]
    a150:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:30 (discriminator 2)
	for (int j = 0; j <= i/2; j++)
    a154:	e51b300c 	ldr	r3, [fp, #-12]
    a158:	e2833001 	add	r3, r3, #1
    a15c:	e50b300c 	str	r3, [fp, #-12]
    a160:	eaffffdb 	b	a0d4 <_Z4itoajPcj+0xd4>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:36
	}
}
    a164:	e320f000 	nop	{0}
    a168:	e24bd004 	sub	sp, fp, #4
    a16c:	e8bd8800 	pop	{fp, pc}
    a170:	0000b420 	andeq	fp, r0, r0, lsr #8

0000a174 <_Z4atoiPKc>:
_Z4atoiPKc():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:39

int atoi(const char* input)
{
    a174:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a178:	e28db000 	add	fp, sp, #0
    a17c:	e24dd014 	sub	sp, sp, #20
    a180:	e50b0010 	str	r0, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:40
	int output = 0;
    a184:	e3a03000 	mov	r3, #0
    a188:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:42

	while (*input != '\0')
    a18c:	e51b3010 	ldr	r3, [fp, #-16]
    a190:	e5d33000 	ldrb	r3, [r3]
    a194:	e3530000 	cmp	r3, #0
    a198:	0a000017 	beq	a1fc <_Z4atoiPKc+0x88>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:44
	{
		output *= 10;
    a19c:	e51b2008 	ldr	r2, [fp, #-8]
    a1a0:	e1a03002 	mov	r3, r2
    a1a4:	e1a03103 	lsl	r3, r3, #2
    a1a8:	e0833002 	add	r3, r3, r2
    a1ac:	e1a03083 	lsl	r3, r3, #1
    a1b0:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:45
		if (*input > '9' || *input < '0')
    a1b4:	e51b3010 	ldr	r3, [fp, #-16]
    a1b8:	e5d33000 	ldrb	r3, [r3]
    a1bc:	e3530039 	cmp	r3, #57	; 0x39
    a1c0:	8a00000d 	bhi	a1fc <_Z4atoiPKc+0x88>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:45 (discriminator 1)
    a1c4:	e51b3010 	ldr	r3, [fp, #-16]
    a1c8:	e5d33000 	ldrb	r3, [r3]
    a1cc:	e353002f 	cmp	r3, #47	; 0x2f
    a1d0:	9a000009 	bls	a1fc <_Z4atoiPKc+0x88>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:48
			break;

		output += *input - '0';
    a1d4:	e51b3010 	ldr	r3, [fp, #-16]
    a1d8:	e5d33000 	ldrb	r3, [r3]
    a1dc:	e2433030 	sub	r3, r3, #48	; 0x30
    a1e0:	e51b2008 	ldr	r2, [fp, #-8]
    a1e4:	e0823003 	add	r3, r2, r3
    a1e8:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:50

		input++;
    a1ec:	e51b3010 	ldr	r3, [fp, #-16]
    a1f0:	e2833001 	add	r3, r3, #1
    a1f4:	e50b3010 	str	r3, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:42
	while (*input != '\0')
    a1f8:	eaffffe3 	b	a18c <_Z4atoiPKc+0x18>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:53
	}

	return output;
    a1fc:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:54
}
    a200:	e1a00003 	mov	r0, r3
    a204:	e28bd000 	add	sp, fp, #0
    a208:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a20c:	e12fff1e 	bx	lr

0000a210 <_Z9normalizePf>:
_Z9normalizePf():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:57


int normalize(float *val) {
    a210:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a214:	e28db000 	add	fp, sp, #0
    a218:	e24dd014 	sub	sp, sp, #20
    a21c:	e50b0010 	str	r0, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:58
    int exponent = 0;
    a220:	e3a03000 	mov	r3, #0
    a224:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:59
    float value = *val;
    a228:	e51b3010 	ldr	r3, [fp, #-16]
    a22c:	e5933000 	ldr	r3, [r3]
    a230:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:61

    while (value >= 1.0) {
    a234:	ed5b7a03 	vldr	s15, [fp, #-12]
    a238:	ed9f7a24 	vldr	s14, [pc, #144]	; a2d0 <_Z9normalizePf+0xc0>
    a23c:	eef47ac7 	vcmpe.f32	s15, s14
    a240:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    a244:	aa000000 	bge	a24c <_Z9normalizePf+0x3c>
    a248:	ea000007 	b	a26c <_Z9normalizePf+0x5c>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:62
        value = value / 10.0;
    a24c:	ed1b7a03 	vldr	s14, [fp, #-12]
    a250:	eddf6a1f 	vldr	s13, [pc, #124]	; a2d4 <_Z9normalizePf+0xc4>
    a254:	eec77a26 	vdiv.f32	s15, s14, s13
    a258:	ed4b7a03 	vstr	s15, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:63
        ++exponent;
    a25c:	e51b3008 	ldr	r3, [fp, #-8]
    a260:	e2833001 	add	r3, r3, #1
    a264:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:61
    while (value >= 1.0) {
    a268:	eafffff1 	b	a234 <_Z9normalizePf+0x24>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:66
    }

    while (value < 0.1) {
    a26c:	ed5b7a03 	vldr	s15, [fp, #-12]
    a270:	eeb77ae7 	vcvt.f64.f32	d7, s15
    a274:	ed9f6b13 	vldr	d6, [pc, #76]	; a2c8 <_Z9normalizePf+0xb8>
    a278:	eeb47bc6 	vcmpe.f64	d7, d6
    a27c:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    a280:	5a000007 	bpl	a2a4 <_Z9normalizePf+0x94>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:67
        value = value * 10.0;
    a284:	ed5b7a03 	vldr	s15, [fp, #-12]
    a288:	ed9f7a11 	vldr	s14, [pc, #68]	; a2d4 <_Z9normalizePf+0xc4>
    a28c:	ee677a87 	vmul.f32	s15, s15, s14
    a290:	ed4b7a03 	vstr	s15, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:68
        --exponent;
    a294:	e51b3008 	ldr	r3, [fp, #-8]
    a298:	e2433001 	sub	r3, r3, #1
    a29c:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:66
    while (value < 0.1) {
    a2a0:	eafffff1 	b	a26c <_Z9normalizePf+0x5c>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:70
    }
    *val = value;
    a2a4:	e51b3010 	ldr	r3, [fp, #-16]
    a2a8:	e51b200c 	ldr	r2, [fp, #-12]
    a2ac:	e5832000 	str	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:71
    return exponent;
    a2b0:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:72
}
    a2b4:	e1a00003 	mov	r0, r3
    a2b8:	e28bd000 	add	sp, fp, #0
    a2bc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a2c0:	e12fff1e 	bx	lr
    a2c4:	e320f000 	nop	{0}
    a2c8:	9999999a 	ldmibls	r9, {r1, r3, r4, r7, r8, fp, ip, pc}
    a2cc:	3fb99999 	svccc	0x00b99999
    a2d0:	3f800000 	svccc	0x00800000
    a2d4:	41200000 			; <UNDEFINED> instruction: 0x41200000

0000a2d8 <_Z4atofPKc>:
_Z4atofPKc():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:75

float atof(const char *s)
{
    a2d8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a2dc:	e28db000 	add	fp, sp, #0
    a2e0:	e24dd024 	sub	sp, sp, #36	; 0x24
    a2e4:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:76
  float a = 0.0;
    a2e8:	e3a03000 	mov	r3, #0
    a2ec:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:77
  int e = 0;
    a2f0:	e3a03000 	mov	r3, #0
    a2f4:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:79
  int c;
  while ((c = *s++) != '\0' && digit_range(c)) {
    a2f8:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    a2fc:	e2832001 	add	r2, r3, #1
    a300:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    a304:	e5d33000 	ldrb	r3, [r3]
    a308:	e50b3010 	str	r3, [fp, #-16]
    a30c:	e51b3010 	ldr	r3, [fp, #-16]
    a310:	e3530000 	cmp	r3, #0
    a314:	0a000007 	beq	a338 <_Z4atofPKc+0x60>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:79 (discriminator 1)
    a318:	e51b3010 	ldr	r3, [fp, #-16]
    a31c:	e353002f 	cmp	r3, #47	; 0x2f
    a320:	da000004 	ble	a338 <_Z4atofPKc+0x60>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:79 (discriminator 3)
    a324:	e51b3010 	ldr	r3, [fp, #-16]
    a328:	e3530039 	cmp	r3, #57	; 0x39
    a32c:	ca000001 	bgt	a338 <_Z4atofPKc+0x60>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:79 (discriminator 5)
    a330:	e3a03001 	mov	r3, #1
    a334:	ea000000 	b	a33c <_Z4atofPKc+0x64>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:79 (discriminator 6)
    a338:	e3a03000 	mov	r3, #0
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:79 (discriminator 8)
    a33c:	e3530000 	cmp	r3, #0
    a340:	0a00000b 	beq	a374 <_Z4atofPKc+0x9c>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:80
    a = a*10.0 + (c - '0');
    a344:	ed5b7a02 	vldr	s15, [fp, #-8]
    a348:	eeb77ae7 	vcvt.f64.f32	d7, s15
    a34c:	ed9f6b89 	vldr	d6, [pc, #548]	; a578 <_Z4atofPKc+0x2a0>
    a350:	ee276b06 	vmul.f64	d6, d7, d6
    a354:	e51b3010 	ldr	r3, [fp, #-16]
    a358:	e2433030 	sub	r3, r3, #48	; 0x30
    a35c:	ee073a90 	vmov	s15, r3
    a360:	eeb87be7 	vcvt.f64.s32	d7, s15
    a364:	ee367b07 	vadd.f64	d7, d6, d7
    a368:	eef77bc7 	vcvt.f32.f64	s15, d7
    a36c:	ed4b7a02 	vstr	s15, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:79
  while ((c = *s++) != '\0' && digit_range(c)) {
    a370:	eaffffe0 	b	a2f8 <_Z4atofPKc+0x20>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:82
  }
  if (c == '.') {
    a374:	e51b3010 	ldr	r3, [fp, #-16]
    a378:	e353002e 	cmp	r3, #46	; 0x2e
    a37c:	1a000021 	bne	a408 <_Z4atofPKc+0x130>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:83
    while ((c = *s++) != '\0' && digit_range(c)) {
    a380:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    a384:	e2832001 	add	r2, r3, #1
    a388:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    a38c:	e5d33000 	ldrb	r3, [r3]
    a390:	e50b3010 	str	r3, [fp, #-16]
    a394:	e51b3010 	ldr	r3, [fp, #-16]
    a398:	e3530000 	cmp	r3, #0
    a39c:	0a000007 	beq	a3c0 <_Z4atofPKc+0xe8>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:83 (discriminator 1)
    a3a0:	e51b3010 	ldr	r3, [fp, #-16]
    a3a4:	e353002f 	cmp	r3, #47	; 0x2f
    a3a8:	da000004 	ble	a3c0 <_Z4atofPKc+0xe8>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:83 (discriminator 3)
    a3ac:	e51b3010 	ldr	r3, [fp, #-16]
    a3b0:	e3530039 	cmp	r3, #57	; 0x39
    a3b4:	ca000001 	bgt	a3c0 <_Z4atofPKc+0xe8>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:83 (discriminator 5)
    a3b8:	e3a03001 	mov	r3, #1
    a3bc:	ea000000 	b	a3c4 <_Z4atofPKc+0xec>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:83 (discriminator 6)
    a3c0:	e3a03000 	mov	r3, #0
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:83 (discriminator 8)
    a3c4:	e3530000 	cmp	r3, #0
    a3c8:	0a00000e 	beq	a408 <_Z4atofPKc+0x130>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:84
      a = a*10.0 + (c - '0');
    a3cc:	ed5b7a02 	vldr	s15, [fp, #-8]
    a3d0:	eeb77ae7 	vcvt.f64.f32	d7, s15
    a3d4:	ed9f6b67 	vldr	d6, [pc, #412]	; a578 <_Z4atofPKc+0x2a0>
    a3d8:	ee276b06 	vmul.f64	d6, d7, d6
    a3dc:	e51b3010 	ldr	r3, [fp, #-16]
    a3e0:	e2433030 	sub	r3, r3, #48	; 0x30
    a3e4:	ee073a90 	vmov	s15, r3
    a3e8:	eeb87be7 	vcvt.f64.s32	d7, s15
    a3ec:	ee367b07 	vadd.f64	d7, d6, d7
    a3f0:	eef77bc7 	vcvt.f32.f64	s15, d7
    a3f4:	ed4b7a02 	vstr	s15, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:85
      e = e-1;
    a3f8:	e51b300c 	ldr	r3, [fp, #-12]
    a3fc:	e2433001 	sub	r3, r3, #1
    a400:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:83
    while ((c = *s++) != '\0' && digit_range(c)) {
    a404:	eaffffdd 	b	a380 <_Z4atofPKc+0xa8>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:88
    }
  }
  if (c == 'e' || c == 'E') {
    a408:	e51b3010 	ldr	r3, [fp, #-16]
    a40c:	e3530065 	cmp	r3, #101	; 0x65
    a410:	0a000002 	beq	a420 <_Z4atofPKc+0x148>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:88 (discriminator 1)
    a414:	e51b3010 	ldr	r3, [fp, #-16]
    a418:	e3530045 	cmp	r3, #69	; 0x45
    a41c:	1a000037 	bne	a500 <_Z4atofPKc+0x228>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:89
    int sign = 1;
    a420:	e3a03001 	mov	r3, #1
    a424:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:90
    int i = 0;
    a428:	e3a03000 	mov	r3, #0
    a42c:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:91
    c = *s++;
    a430:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    a434:	e2832001 	add	r2, r3, #1
    a438:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    a43c:	e5d33000 	ldrb	r3, [r3]
    a440:	e50b3010 	str	r3, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:92
    if (c == '+')
    a444:	e51b3010 	ldr	r3, [fp, #-16]
    a448:	e353002b 	cmp	r3, #43	; 0x2b
    a44c:	1a000005 	bne	a468 <_Z4atofPKc+0x190>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:93
      c = *s++;
    a450:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    a454:	e2832001 	add	r2, r3, #1
    a458:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    a45c:	e5d33000 	ldrb	r3, [r3]
    a460:	e50b3010 	str	r3, [fp, #-16]
    a464:	ea000009 	b	a490 <_Z4atofPKc+0x1b8>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:94
    else if (c == '-') {
    a468:	e51b3010 	ldr	r3, [fp, #-16]
    a46c:	e353002d 	cmp	r3, #45	; 0x2d
    a470:	1a000006 	bne	a490 <_Z4atofPKc+0x1b8>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:95
      c = *s++;
    a474:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    a478:	e2832001 	add	r2, r3, #1
    a47c:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    a480:	e5d33000 	ldrb	r3, [r3]
    a484:	e50b3010 	str	r3, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:96
      sign = -1;
    a488:	e3e03000 	mvn	r3, #0
    a48c:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:98
    }
    while (digit_range(c)) {
    a490:	e51b3010 	ldr	r3, [fp, #-16]
    a494:	e353002f 	cmp	r3, #47	; 0x2f
    a498:	da000012 	ble	a4e8 <_Z4atofPKc+0x210>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:98 (discriminator 1)
    a49c:	e51b3010 	ldr	r3, [fp, #-16]
    a4a0:	e3530039 	cmp	r3, #57	; 0x39
    a4a4:	ca00000f 	bgt	a4e8 <_Z4atofPKc+0x210>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:99
      i = i*10 + (c - '0');
    a4a8:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    a4ac:	e1a03002 	mov	r3, r2
    a4b0:	e1a03103 	lsl	r3, r3, #2
    a4b4:	e0833002 	add	r3, r3, r2
    a4b8:	e1a03083 	lsl	r3, r3, #1
    a4bc:	e1a02003 	mov	r2, r3
    a4c0:	e51b3010 	ldr	r3, [fp, #-16]
    a4c4:	e2433030 	sub	r3, r3, #48	; 0x30
    a4c8:	e0823003 	add	r3, r2, r3
    a4cc:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:100
      c = *s++;
    a4d0:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    a4d4:	e2832001 	add	r2, r3, #1
    a4d8:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    a4dc:	e5d33000 	ldrb	r3, [r3]
    a4e0:	e50b3010 	str	r3, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:98
    while (digit_range(c)) {
    a4e4:	eaffffe9 	b	a490 <_Z4atofPKc+0x1b8>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:102
    }
    e += i*sign;
    a4e8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a4ec:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    a4f0:	e0030392 	mul	r3, r2, r3
    a4f4:	e51b200c 	ldr	r2, [fp, #-12]
    a4f8:	e0823003 	add	r3, r2, r3
    a4fc:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:104
  }
  while (e > 0) {
    a500:	e51b300c 	ldr	r3, [fp, #-12]
    a504:	e3530000 	cmp	r3, #0
    a508:	da000007 	ble	a52c <_Z4atofPKc+0x254>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:105
    a *= 10.0;
    a50c:	ed5b7a02 	vldr	s15, [fp, #-8]
    a510:	ed9f7a1c 	vldr	s14, [pc, #112]	; a588 <_Z4atofPKc+0x2b0>
    a514:	ee677a87 	vmul.f32	s15, s15, s14
    a518:	ed4b7a02 	vstr	s15, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:106
    e--;
    a51c:	e51b300c 	ldr	r3, [fp, #-12]
    a520:	e2433001 	sub	r3, r3, #1
    a524:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:104
  while (e > 0) {
    a528:	eafffff4 	b	a500 <_Z4atofPKc+0x228>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:108
  }
  while (e < 0) {
    a52c:	e51b300c 	ldr	r3, [fp, #-12]
    a530:	e3530000 	cmp	r3, #0
    a534:	aa000009 	bge	a560 <_Z4atofPKc+0x288>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:109
    a *= 0.1;
    a538:	ed5b7a02 	vldr	s15, [fp, #-8]
    a53c:	eeb77ae7 	vcvt.f64.f32	d7, s15
    a540:	ed9f6b0e 	vldr	d6, [pc, #56]	; a580 <_Z4atofPKc+0x2a8>
    a544:	ee277b06 	vmul.f64	d7, d7, d6
    a548:	eef77bc7 	vcvt.f32.f64	s15, d7
    a54c:	ed4b7a02 	vstr	s15, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:110
    e++;
    a550:	e51b300c 	ldr	r3, [fp, #-12]
    a554:	e2833001 	add	r3, r3, #1
    a558:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:108
  while (e < 0) {
    a55c:	eafffff2 	b	a52c <_Z4atofPKc+0x254>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:112
  }
  return a;
    a560:	e51b3008 	ldr	r3, [fp, #-8]
    a564:	ee073a90 	vmov	s15, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:113
}
    a568:	eeb00a67 	vmov.f32	s0, s15
    a56c:	e28bd000 	add	sp, fp, #0
    a570:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a574:	e12fff1e 	bx	lr
    a578:	00000000 	andeq	r0, r0, r0
    a57c:	40240000 	eormi	r0, r4, r0
    a580:	9999999a 	ldmibls	r9, {r1, r3, r4, r7, r8, fp, ip, pc}
    a584:	3fb99999 	svccc	0x00b99999
    a588:	41200000 			; <UNDEFINED> instruction: 0x41200000

0000a58c <_Z4ftoaPcf>:
_Z4ftoaPcf():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:115

void ftoa(char *buffer, float value) {  
    a58c:	e92d4800 	push	{fp, lr}
    a590:	e28db004 	add	fp, sp, #4
    a594:	e24dd020 	sub	sp, sp, #32
    a598:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
    a59c:	ed0b0a09 	vstr	s0, [fp, #-36]	; 0xffffffdc
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:116
    int exponent = 0;
    a5a0:	e3a03000 	mov	r3, #0
    a5a4:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:117
    int places = 0;
    a5a8:	e3a03000 	mov	r3, #0
    a5ac:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:118
    const int width = 6;
    a5b0:	e3a03006 	mov	r3, #6
    a5b4:	e50b3010 	str	r3, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:120

    if (value == 0.0) {
    a5b8:	ed5b7a09 	vldr	s15, [fp, #-36]	; 0xffffffdc
    a5bc:	eef57a40 	vcmp.f32	s15, #0.0
    a5c0:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    a5c4:	1a000007 	bne	a5e8 <_Z4ftoaPcf+0x5c>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:121
        buffer[0] = '0';
    a5c8:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    a5cc:	e3a02030 	mov	r2, #48	; 0x30
    a5d0:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:122
        buffer[1] = '\0';
    a5d4:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    a5d8:	e2833001 	add	r3, r3, #1
    a5dc:	e3a02000 	mov	r2, #0
    a5e0:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:123
        return;
    a5e4:	ea000071 	b	a7b0 <_Z4ftoaPcf+0x224>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:126
    } 

    if (value < 0.0) {
    a5e8:	ed5b7a09 	vldr	s15, [fp, #-36]	; 0xffffffdc
    a5ec:	eef57ac0 	vcmpe.f32	s15, #0.0
    a5f0:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    a5f4:	5a000007 	bpl	a618 <_Z4ftoaPcf+0x8c>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:127
        *buffer++ = '-';
    a5f8:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    a5fc:	e2832001 	add	r2, r3, #1
    a600:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    a604:	e3a0202d 	mov	r2, #45	; 0x2d
    a608:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:128
        value = -value;
    a60c:	ed5b7a09 	vldr	s15, [fp, #-36]	; 0xffffffdc
    a610:	eef17a67 	vneg.f32	s15, s15
    a614:	ed4b7a09 	vstr	s15, [fp, #-36]	; 0xffffffdc
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:131
    }

    exponent = normalize(&value);
    a618:	e24b3024 	sub	r3, fp, #36	; 0x24
    a61c:	e1a00003 	mov	r0, r3
    a620:	ebfffefa 	bl	a210 <_Z9normalizePf>
    a624:	e50b0008 	str	r0, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:133

    while (exponent > 0) {
    a628:	e51b3008 	ldr	r3, [fp, #-8]
    a62c:	e3530000 	cmp	r3, #0
    a630:	da00001c 	ble	a6a8 <_Z4ftoaPcf+0x11c>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:134
        int digit = value * 10;
    a634:	ed5b7a09 	vldr	s15, [fp, #-36]	; 0xffffffdc
    a638:	ed9f7a60 	vldr	s14, [pc, #384]	; a7c0 <_Z4ftoaPcf+0x234>
    a63c:	ee677a87 	vmul.f32	s15, s15, s14
    a640:	eefd7ae7 	vcvt.s32.f32	s15, s15
    a644:	ee173a90 	vmov	r3, s15
    a648:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:135
        *buffer++ = digit + '0';
    a64c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    a650:	e6ef2073 	uxtb	r2, r3
    a654:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    a658:	e2831001 	add	r1, r3, #1
    a65c:	e50b1020 	str	r1, [fp, #-32]	; 0xffffffe0
    a660:	e2822030 	add	r2, r2, #48	; 0x30
    a664:	e6ef2072 	uxtb	r2, r2
    a668:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:136
        value = value * 10 - digit;
    a66c:	ed5b7a09 	vldr	s15, [fp, #-36]	; 0xffffffdc
    a670:	ed9f7a52 	vldr	s14, [pc, #328]	; a7c0 <_Z4ftoaPcf+0x234>
    a674:	ee277a87 	vmul.f32	s14, s15, s14
    a678:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    a67c:	ee073a90 	vmov	s15, r3
    a680:	eef87ae7 	vcvt.f32.s32	s15, s15
    a684:	ee777a67 	vsub.f32	s15, s14, s15
    a688:	ed4b7a09 	vstr	s15, [fp, #-36]	; 0xffffffdc
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:137
        ++places;
    a68c:	e51b300c 	ldr	r3, [fp, #-12]
    a690:	e2833001 	add	r3, r3, #1
    a694:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:138
        --exponent;
    a698:	e51b3008 	ldr	r3, [fp, #-8]
    a69c:	e2433001 	sub	r3, r3, #1
    a6a0:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:133
    while (exponent > 0) {
    a6a4:	eaffffdf 	b	a628 <_Z4ftoaPcf+0x9c>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:141
    }

    if (places == 0)
    a6a8:	e51b300c 	ldr	r3, [fp, #-12]
    a6ac:	e3530000 	cmp	r3, #0
    a6b0:	1a000004 	bne	a6c8 <_Z4ftoaPcf+0x13c>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:142
        *buffer++ = '0';
    a6b4:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    a6b8:	e2832001 	add	r2, r3, #1
    a6bc:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    a6c0:	e3a02030 	mov	r2, #48	; 0x30
    a6c4:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:144

    *buffer++ = '.';
    a6c8:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    a6cc:	e2832001 	add	r2, r3, #1
    a6d0:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    a6d4:	e3a0202e 	mov	r2, #46	; 0x2e
    a6d8:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:146

    while (exponent < 0 && places < width) {
    a6dc:	e51b3008 	ldr	r3, [fp, #-8]
    a6e0:	e3530000 	cmp	r3, #0
    a6e4:	aa00000e 	bge	a724 <_Z4ftoaPcf+0x198>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:146 (discriminator 1)
    a6e8:	e51b300c 	ldr	r3, [fp, #-12]
    a6ec:	e3530005 	cmp	r3, #5
    a6f0:	ca00000b 	bgt	a724 <_Z4ftoaPcf+0x198>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:147
        *buffer++ = '0';
    a6f4:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    a6f8:	e2832001 	add	r2, r3, #1
    a6fc:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    a700:	e3a02030 	mov	r2, #48	; 0x30
    a704:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:148
        --exponent;
    a708:	e51b3008 	ldr	r3, [fp, #-8]
    a70c:	e2433001 	sub	r3, r3, #1
    a710:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:149
        ++places;
    a714:	e51b300c 	ldr	r3, [fp, #-12]
    a718:	e2833001 	add	r3, r3, #1
    a71c:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:146
    while (exponent < 0 && places < width) {
    a720:	eaffffed 	b	a6dc <_Z4ftoaPcf+0x150>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:152
    }

    while (places < width) {
    a724:	e51b300c 	ldr	r3, [fp, #-12]
    a728:	e3530005 	cmp	r3, #5
    a72c:	ca00001c 	bgt	a7a4 <_Z4ftoaPcf+0x218>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:153
        int digit = value * 10.0;
    a730:	ed5b7a09 	vldr	s15, [fp, #-36]	; 0xffffffdc
    a734:	eeb77ae7 	vcvt.f64.f32	d7, s15
    a738:	ed9f6b1e 	vldr	d6, [pc, #120]	; a7b8 <_Z4ftoaPcf+0x22c>
    a73c:	ee277b06 	vmul.f64	d7, d7, d6
    a740:	eefd7bc7 	vcvt.s32.f64	s15, d7
    a744:	ee173a90 	vmov	r3, s15
    a748:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:154
        *buffer++ = digit + '0';
    a74c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a750:	e6ef2073 	uxtb	r2, r3
    a754:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    a758:	e2831001 	add	r1, r3, #1
    a75c:	e50b1020 	str	r1, [fp, #-32]	; 0xffffffe0
    a760:	e2822030 	add	r2, r2, #48	; 0x30
    a764:	e6ef2072 	uxtb	r2, r2
    a768:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:155
        value = value * 10.0 - digit;
    a76c:	ed5b7a09 	vldr	s15, [fp, #-36]	; 0xffffffdc
    a770:	eeb77ae7 	vcvt.f64.f32	d7, s15
    a774:	ed9f6b0f 	vldr	d6, [pc, #60]	; a7b8 <_Z4ftoaPcf+0x22c>
    a778:	ee276b06 	vmul.f64	d6, d7, d6
    a77c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a780:	ee073a90 	vmov	s15, r3
    a784:	eeb87be7 	vcvt.f64.s32	d7, s15
    a788:	ee367b47 	vsub.f64	d7, d6, d7
    a78c:	eef77bc7 	vcvt.f32.f64	s15, d7
    a790:	ed4b7a09 	vstr	s15, [fp, #-36]	; 0xffffffdc
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:156
        ++places;
    a794:	e51b300c 	ldr	r3, [fp, #-12]
    a798:	e2833001 	add	r3, r3, #1
    a79c:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:152
    while (places < width) {
    a7a0:	eaffffdf 	b	a724 <_Z4ftoaPcf+0x198>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:158
    }
    *buffer = '\0';
    a7a4:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    a7a8:	e3a02000 	mov	r2, #0
    a7ac:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:159
}
    a7b0:	e24bd004 	sub	sp, fp, #4
    a7b4:	e8bd8800 	pop	{fp, pc}
    a7b8:	00000000 	andeq	r0, r0, r0
    a7bc:	40240000 	eormi	r0, r4, r0
    a7c0:	41200000 			; <UNDEFINED> instruction: 0x41200000

0000a7c4 <_Z7strncpyPcPKci>:
_Z7strncpyPcPKci():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:162

char* strncpy(char* dest, const char *src, int num)
{
    a7c4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a7c8:	e28db000 	add	fp, sp, #0
    a7cc:	e24dd01c 	sub	sp, sp, #28
    a7d0:	e50b0010 	str	r0, [fp, #-16]
    a7d4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    a7d8:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:165
	int i;

	for (i = 0; i < num && src[i] != '\0'; i++)
    a7dc:	e3a03000 	mov	r3, #0
    a7e0:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:165 (discriminator 4)
    a7e4:	e51b2008 	ldr	r2, [fp, #-8]
    a7e8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a7ec:	e1520003 	cmp	r2, r3
    a7f0:	aa000011 	bge	a83c <_Z7strncpyPcPKci+0x78>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:165 (discriminator 2)
    a7f4:	e51b3008 	ldr	r3, [fp, #-8]
    a7f8:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    a7fc:	e0823003 	add	r3, r2, r3
    a800:	e5d33000 	ldrb	r3, [r3]
    a804:	e3530000 	cmp	r3, #0
    a808:	0a00000b 	beq	a83c <_Z7strncpyPcPKci+0x78>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:166 (discriminator 3)
		dest[i] = src[i];
    a80c:	e51b3008 	ldr	r3, [fp, #-8]
    a810:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    a814:	e0822003 	add	r2, r2, r3
    a818:	e51b3008 	ldr	r3, [fp, #-8]
    a81c:	e51b1010 	ldr	r1, [fp, #-16]
    a820:	e0813003 	add	r3, r1, r3
    a824:	e5d22000 	ldrb	r2, [r2]
    a828:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:165 (discriminator 3)
	for (i = 0; i < num && src[i] != '\0'; i++)
    a82c:	e51b3008 	ldr	r3, [fp, #-8]
    a830:	e2833001 	add	r3, r3, #1
    a834:	e50b3008 	str	r3, [fp, #-8]
    a838:	eaffffe9 	b	a7e4 <_Z7strncpyPcPKci+0x20>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:167 (discriminator 2)
	for (; i < num; i++)
    a83c:	e51b2008 	ldr	r2, [fp, #-8]
    a840:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a844:	e1520003 	cmp	r2, r3
    a848:	aa000008 	bge	a870 <_Z7strncpyPcPKci+0xac>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:168 (discriminator 1)
		dest[i] = '\0';
    a84c:	e51b3008 	ldr	r3, [fp, #-8]
    a850:	e51b2010 	ldr	r2, [fp, #-16]
    a854:	e0823003 	add	r3, r2, r3
    a858:	e3a02000 	mov	r2, #0
    a85c:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:167 (discriminator 1)
	for (; i < num; i++)
    a860:	e51b3008 	ldr	r3, [fp, #-8]
    a864:	e2833001 	add	r3, r3, #1
    a868:	e50b3008 	str	r3, [fp, #-8]
    a86c:	eafffff2 	b	a83c <_Z7strncpyPcPKci+0x78>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:170

   return dest;
    a870:	e51b3010 	ldr	r3, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:171
}
    a874:	e1a00003 	mov	r0, r3
    a878:	e28bd000 	add	sp, fp, #0
    a87c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a880:	e12fff1e 	bx	lr

0000a884 <_Z6strcatPcPKc>:
_Z6strcatPcPKc():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:174

char* strcat(char *dest, const char *src)
{
    a884:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a888:	e28db000 	add	fp, sp, #0
    a88c:	e24dd014 	sub	sp, sp, #20
    a890:	e50b0010 	str	r0, [fp, #-16]
    a894:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:177
    int i,j;

    for (i = 0; dest[i] != '\0'; i++)
    a898:	e3a03000 	mov	r3, #0
    a89c:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:177 (discriminator 3)
    a8a0:	e51b3008 	ldr	r3, [fp, #-8]
    a8a4:	e51b2010 	ldr	r2, [fp, #-16]
    a8a8:	e0823003 	add	r3, r2, r3
    a8ac:	e5d33000 	ldrb	r3, [r3]
    a8b0:	e3530000 	cmp	r3, #0
    a8b4:	0a000003 	beq	a8c8 <_Z6strcatPcPKc+0x44>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:177 (discriminator 2)
    a8b8:	e51b3008 	ldr	r3, [fp, #-8]
    a8bc:	e2833001 	add	r3, r3, #1
    a8c0:	e50b3008 	str	r3, [fp, #-8]
    a8c4:	eafffff5 	b	a8a0 <_Z6strcatPcPKc+0x1c>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:179
        ;
    for (j = 0; src[j] != '\0'; j++)
    a8c8:	e3a03000 	mov	r3, #0
    a8cc:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:179 (discriminator 3)
    a8d0:	e51b300c 	ldr	r3, [fp, #-12]
    a8d4:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    a8d8:	e0823003 	add	r3, r2, r3
    a8dc:	e5d33000 	ldrb	r3, [r3]
    a8e0:	e3530000 	cmp	r3, #0
    a8e4:	0a00000e 	beq	a924 <_Z6strcatPcPKc+0xa0>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:180 (discriminator 2)
        dest[i+j] = src[j];
    a8e8:	e51b300c 	ldr	r3, [fp, #-12]
    a8ec:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    a8f0:	e0822003 	add	r2, r2, r3
    a8f4:	e51b1008 	ldr	r1, [fp, #-8]
    a8f8:	e51b300c 	ldr	r3, [fp, #-12]
    a8fc:	e0813003 	add	r3, r1, r3
    a900:	e1a01003 	mov	r1, r3
    a904:	e51b3010 	ldr	r3, [fp, #-16]
    a908:	e0833001 	add	r3, r3, r1
    a90c:	e5d22000 	ldrb	r2, [r2]
    a910:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:179 (discriminator 2)
    for (j = 0; src[j] != '\0'; j++)
    a914:	e51b300c 	ldr	r3, [fp, #-12]
    a918:	e2833001 	add	r3, r3, #1
    a91c:	e50b300c 	str	r3, [fp, #-12]
    a920:	eaffffea 	b	a8d0 <_Z6strcatPcPKc+0x4c>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:182

    dest[i+j] = '\0';
    a924:	e51b2008 	ldr	r2, [fp, #-8]
    a928:	e51b300c 	ldr	r3, [fp, #-12]
    a92c:	e0823003 	add	r3, r2, r3
    a930:	e1a02003 	mov	r2, r3
    a934:	e51b3010 	ldr	r3, [fp, #-16]
    a938:	e0833002 	add	r3, r3, r2
    a93c:	e3a02000 	mov	r2, #0
    a940:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:184
	
    return dest;
    a944:	e51b3010 	ldr	r3, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:185
}
    a948:	e1a00003 	mov	r0, r3
    a94c:	e28bd000 	add	sp, fp, #0
    a950:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    a954:	e12fff1e 	bx	lr

0000a958 <_Z7strncmpPKcS0_i>:
_Z7strncmpPKcS0_i():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:188

int strncmp(const char *s1, const char *s2, int num)
{
    a958:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    a95c:	e28db000 	add	fp, sp, #0
    a960:	e24dd01c 	sub	sp, sp, #28
    a964:	e50b0010 	str	r0, [fp, #-16]
    a968:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    a96c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:190
	unsigned char u1, u2;
  	while (num-- > 0)
    a970:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    a974:	e2432001 	sub	r2, r3, #1
    a978:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    a97c:	e3530000 	cmp	r3, #0
    a980:	c3a03001 	movgt	r3, #1
    a984:	d3a03000 	movle	r3, #0
    a988:	e6ef3073 	uxtb	r3, r3
    a98c:	e3530000 	cmp	r3, #0
    a990:	0a000016 	beq	a9f0 <_Z7strncmpPKcS0_i+0x98>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:192
    {
      	u1 = (unsigned char) *s1++;
    a994:	e51b3010 	ldr	r3, [fp, #-16]
    a998:	e2832001 	add	r2, r3, #1
    a99c:	e50b2010 	str	r2, [fp, #-16]
    a9a0:	e5d33000 	ldrb	r3, [r3]
    a9a4:	e54b3005 	strb	r3, [fp, #-5]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:193
     	u2 = (unsigned char) *s2++;
    a9a8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    a9ac:	e2832001 	add	r2, r3, #1
    a9b0:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    a9b4:	e5d33000 	ldrb	r3, [r3]
    a9b8:	e54b3006 	strb	r3, [fp, #-6]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:194
      	if (u1 != u2)
    a9bc:	e55b2005 	ldrb	r2, [fp, #-5]
    a9c0:	e55b3006 	ldrb	r3, [fp, #-6]
    a9c4:	e1520003 	cmp	r2, r3
    a9c8:	0a000003 	beq	a9dc <_Z7strncmpPKcS0_i+0x84>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:195
        	return u1 - u2;
    a9cc:	e55b2005 	ldrb	r2, [fp, #-5]
    a9d0:	e55b3006 	ldrb	r3, [fp, #-6]
    a9d4:	e0423003 	sub	r3, r2, r3
    a9d8:	ea000005 	b	a9f4 <_Z7strncmpPKcS0_i+0x9c>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:196
      	if (u1 == '\0')
    a9dc:	e55b3005 	ldrb	r3, [fp, #-5]
    a9e0:	e3530000 	cmp	r3, #0
    a9e4:	1affffe1 	bne	a970 <_Z7strncmpPKcS0_i+0x18>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:197
        	return 0;
    a9e8:	e3a03000 	mov	r3, #0
    a9ec:	ea000000 	b	a9f4 <_Z7strncmpPKcS0_i+0x9c>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:200
    }

  	return 0;
    a9f0:	e3a03000 	mov	r3, #0
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:201
}
    a9f4:	e1a00003 	mov	r0, r3
    a9f8:	e28bd000 	add	sp, fp, #0
    a9fc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    aa00:	e12fff1e 	bx	lr

0000aa04 <_Z6strlenPKc>:
_Z6strlenPKc():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:204

int strlen(const char* s)
{
    aa04:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    aa08:	e28db000 	add	fp, sp, #0
    aa0c:	e24dd014 	sub	sp, sp, #20
    aa10:	e50b0010 	str	r0, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:205
	int i = 0;
    aa14:	e3a03000 	mov	r3, #0
    aa18:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:207

	while (s[i] != '\0')
    aa1c:	e51b3008 	ldr	r3, [fp, #-8]
    aa20:	e51b2010 	ldr	r2, [fp, #-16]
    aa24:	e0823003 	add	r3, r2, r3
    aa28:	e5d33000 	ldrb	r3, [r3]
    aa2c:	e3530000 	cmp	r3, #0
    aa30:	0a000003 	beq	aa44 <_Z6strlenPKc+0x40>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:208
		i++;
    aa34:	e51b3008 	ldr	r3, [fp, #-8]
    aa38:	e2833001 	add	r3, r3, #1
    aa3c:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:207
	while (s[i] != '\0')
    aa40:	eafffff5 	b	aa1c <_Z6strlenPKc+0x18>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:210

	return i;
    aa44:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:211
}
    aa48:	e1a00003 	mov	r0, r3
    aa4c:	e28bd000 	add	sp, fp, #0
    aa50:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    aa54:	e12fff1e 	bx	lr

0000aa58 <_Z5bzeroPvi>:
_Z5bzeroPvi():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:214

void bzero(void* memory, int length)
{
    aa58:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    aa5c:	e28db000 	add	fp, sp, #0
    aa60:	e24dd014 	sub	sp, sp, #20
    aa64:	e50b0010 	str	r0, [fp, #-16]
    aa68:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:215
	char* mem = reinterpret_cast<char*>(memory);
    aa6c:	e51b3010 	ldr	r3, [fp, #-16]
    aa70:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:217

	for (int i = 0; i < length; i++)
    aa74:	e3a03000 	mov	r3, #0
    aa78:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:217 (discriminator 3)
    aa7c:	e51b2008 	ldr	r2, [fp, #-8]
    aa80:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    aa84:	e1520003 	cmp	r2, r3
    aa88:	aa000008 	bge	aab0 <_Z5bzeroPvi+0x58>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:218 (discriminator 2)
		mem[i] = 0;
    aa8c:	e51b3008 	ldr	r3, [fp, #-8]
    aa90:	e51b200c 	ldr	r2, [fp, #-12]
    aa94:	e0823003 	add	r3, r2, r3
    aa98:	e3a02000 	mov	r2, #0
    aa9c:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:217 (discriminator 2)
	for (int i = 0; i < length; i++)
    aaa0:	e51b3008 	ldr	r3, [fp, #-8]
    aaa4:	e2833001 	add	r3, r3, #1
    aaa8:	e50b3008 	str	r3, [fp, #-8]
    aaac:	eafffff2 	b	aa7c <_Z5bzeroPvi+0x24>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:219
}
    aab0:	e320f000 	nop	{0}
    aab4:	e28bd000 	add	sp, fp, #0
    aab8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    aabc:	e12fff1e 	bx	lr

0000aac0 <_Z6memcpyPKvPvi>:
_Z6memcpyPKvPvi():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:222

void memcpy(const void* src, void* dst, int num)
{
    aac0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    aac4:	e28db000 	add	fp, sp, #0
    aac8:	e24dd024 	sub	sp, sp, #36	; 0x24
    aacc:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    aad0:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    aad4:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:223
	const char* memsrc = reinterpret_cast<const char*>(src);
    aad8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    aadc:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:224
	char* memdst = reinterpret_cast<char*>(dst);
    aae0:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    aae4:	e50b3010 	str	r3, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:226

	for (int i = 0; i < num; i++)
    aae8:	e3a03000 	mov	r3, #0
    aaec:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:226 (discriminator 3)
    aaf0:	e51b2008 	ldr	r2, [fp, #-8]
    aaf4:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    aaf8:	e1520003 	cmp	r2, r3
    aafc:	aa00000b 	bge	ab30 <_Z6memcpyPKvPvi+0x70>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:227 (discriminator 2)
		memdst[i] = memsrc[i];
    ab00:	e51b3008 	ldr	r3, [fp, #-8]
    ab04:	e51b200c 	ldr	r2, [fp, #-12]
    ab08:	e0822003 	add	r2, r2, r3
    ab0c:	e51b3008 	ldr	r3, [fp, #-8]
    ab10:	e51b1010 	ldr	r1, [fp, #-16]
    ab14:	e0813003 	add	r3, r1, r3
    ab18:	e5d22000 	ldrb	r2, [r2]
    ab1c:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:226 (discriminator 2)
	for (int i = 0; i < num; i++)
    ab20:	e51b3008 	ldr	r3, [fp, #-8]
    ab24:	e2833001 	add	r3, r3, #1
    ab28:	e50b3008 	str	r3, [fp, #-8]
    ab2c:	eaffffef 	b	aaf0 <_Z6memcpyPKvPvi+0x30>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:228
}
    ab30:	e320f000 	nop	{0}
    ab34:	e28bd000 	add	sp, fp, #0
    ab38:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    ab3c:	e12fff1e 	bx	lr

0000ab40 <_ZN10Read_UtilsC1Ev>:
_ZN10Read_UtilsC2Ev():
/home/schenkj/os2022/sp/sources/stdutils/src/readUtils.cpp:5
#include <readUtils.h>
#include <stdfile.h>
#include <stdstring.h>

Read_Utils::Read_Utils() {
    ab40:	e92d4800 	push	{fp, lr}
    ab44:	e28db004 	add	fp, sp, #4
    ab48:	e24dd008 	sub	sp, sp, #8
    ab4c:	e50b0008 	str	r0, [fp, #-8]
    ab50:	e51b3008 	ldr	r3, [fp, #-8]
    ab54:	e1a00003 	mov	r0, r3
    ab58:	eb000053 	bl	acac <_ZN15Circular_BufferC1Ev>
/home/schenkj/os2022/sp/sources/stdutils/src/readUtils.cpp:7
    // Prazdny konstruktor
};
    ab5c:	e51b3008 	ldr	r3, [fp, #-8]
    ab60:	e1a00003 	mov	r0, r3
    ab64:	e24bd004 	sub	sp, fp, #4
    ab68:	e8bd8800 	pop	{fp, pc}

0000ab6c <_ZN10Read_Utils8readLineEPcjb>:
_ZN10Read_Utils8readLineEPcjb():
/home/schenkj/os2022/sp/sources/stdutils/src/readUtils.cpp:9

uint32_t Read_Utils::readLine(char * returnBuffer, uint32_t file, bool blocking) {
    ab6c:	e92d4800 	push	{fp, lr}
    ab70:	e28db004 	add	fp, sp, #4
    ab74:	e24dd0a0 	sub	sp, sp, #160	; 0xa0
    ab78:	e50b0098 	str	r0, [fp, #-152]	; 0xffffff68
    ab7c:	e50b109c 	str	r1, [fp, #-156]	; 0xffffff64
    ab80:	e50b20a0 	str	r2, [fp, #-160]	; 0xffffff60
    ab84:	e54b30a1 	strb	r3, [fp, #-161]	; 0xffffff5f
/home/schenkj/os2022/sp/sources/stdutils/src/readUtils.cpp:11
    char readBuffer[128];
	bzero(readBuffer, 128);
    ab88:	e24b3090 	sub	r3, fp, #144	; 0x90
    ab8c:	e3a01080 	mov	r1, #128	; 0x80
    ab90:	e1a00003 	mov	r0, r3
    ab94:	ebffffaf 	bl	aa58 <_Z5bzeroPvi>
/home/schenkj/os2022/sp/sources/stdutils/src/readUtils.cpp:12
	uint32_t readChars = 0;
    ab98:	e3a03000 	mov	r3, #0
    ab9c:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdutils/src/readUtils.cpp:16

    //Read from UART if data are available.
	do {
		if (blocking == true) {	//If we want to block the process, we just wait until we receive something from  UART
    aba0:	e55b30a1 	ldrb	r3, [fp, #-161]	; 0xffffff5f
    aba4:	e3530001 	cmp	r3, #1
    aba8:	1a000003 	bne	abbc <_ZN10Read_Utils8readLineEPcjb+0x50>
/home/schenkj/os2022/sp/sources/stdutils/src/readUtils.cpp:17
			wait(file, 0x1000, 0x2000);
    abac:	e3a02a02 	mov	r2, #8192	; 0x2000
    abb0:	e3a01a01 	mov	r1, #4096	; 0x1000
    abb4:	e51b00a0 	ldr	r0, [fp, #-160]	; 0xffffff60
    abb8:	ebfffc6e 	bl	9d78 <_Z4waitjjj>
/home/schenkj/os2022/sp/sources/stdutils/src/readUtils.cpp:22
		}

		/*TODO: Vyhodit blocking na UARTu, sere na to pes :) */

		uint32_t len = read(file, readBuffer, 128);
    abbc:	e24b3090 	sub	r3, fp, #144	; 0x90
    abc0:	e3a02080 	mov	r2, #128	; 0x80
    abc4:	e1a01003 	mov	r1, r3
    abc8:	e51b00a0 	ldr	r0, [fp, #-160]	; 0xffffff60
    abcc:	ebfffc11 	bl	9c18 <_Z4readjPcj>
    abd0:	e50b0010 	str	r0, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdutils/src/readUtils.cpp:23
		if (len != 0) {
    abd4:	e51b3010 	ldr	r3, [fp, #-16]
    abd8:	e3530000 	cmp	r3, #0
    abdc:	0a000027 	beq	ac80 <_ZN10Read_Utils8readLineEPcjb+0x114>
/home/schenkj/os2022/sp/sources/stdutils/src/readUtils.cpp:30
			//Write into it's own circular buffer holding previous values.
			//This is used for example if user pastes two lines, we don't want to scrap the result.
			//Other scenario might be that user might enter for example only two characters without pressing \n - We still 
			//Want to save the results and return them on next readLine call.
			
			cb.write(readBuffer, len);
    abe0:	e51b3098 	ldr	r3, [fp, #-152]	; 0xffffff68
    abe4:	e24b1090 	sub	r1, fp, #144	; 0x90
    abe8:	e51b2010 	ldr	r2, [fp, #-16]
    abec:	e1a00003 	mov	r0, r3
    abf0:	eb000085 	bl	ae0c <_ZN15Circular_Buffer5writeEPcj>
/home/schenkj/os2022/sp/sources/stdutils/src/readUtils.cpp:31
			readChars = cb.readUntil('\r', returnBuffer);
    abf4:	e51b3098 	ldr	r3, [fp, #-152]	; 0xffffff68
    abf8:	e51b209c 	ldr	r2, [fp, #-156]	; 0xffffff64
    abfc:	e3a0100d 	mov	r1, #13
    ac00:	e1a00003 	mov	r0, r3
    ac04:	eb0000af 	bl	aec8 <_ZN15Circular_Buffer9readUntilEcPc>
    ac08:	e50b0008 	str	r0, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdutils/src/readUtils.cpp:34

			//Remove newLine and carriage return characters from the end of the string.
			for (int i = readChars - 1; i >= 0; i--) {
    ac0c:	e51b3008 	ldr	r3, [fp, #-8]
    ac10:	e2433001 	sub	r3, r3, #1
    ac14:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdutils/src/readUtils.cpp:34 (discriminator 1)
    ac18:	e51b300c 	ldr	r3, [fp, #-12]
    ac1c:	e3530000 	cmp	r3, #0
    ac20:	ba000016 	blt	ac80 <_ZN10Read_Utils8readLineEPcjb+0x114>
/home/schenkj/os2022/sp/sources/stdutils/src/readUtils.cpp:35
				if (returnBuffer[i] == '\r' || returnBuffer[i] == '\n') {
    ac24:	e51b300c 	ldr	r3, [fp, #-12]
    ac28:	e51b209c 	ldr	r2, [fp, #-156]	; 0xffffff64
    ac2c:	e0823003 	add	r3, r2, r3
    ac30:	e5d33000 	ldrb	r3, [r3]
    ac34:	e353000d 	cmp	r3, #13
    ac38:	0a000005 	beq	ac54 <_ZN10Read_Utils8readLineEPcjb+0xe8>
/home/schenkj/os2022/sp/sources/stdutils/src/readUtils.cpp:35 (discriminator 2)
    ac3c:	e51b300c 	ldr	r3, [fp, #-12]
    ac40:	e51b209c 	ldr	r2, [fp, #-156]	; 0xffffff64
    ac44:	e0823003 	add	r3, r2, r3
    ac48:	e5d33000 	ldrb	r3, [r3]
    ac4c:	e353000a 	cmp	r3, #10
    ac50:	1a000009 	bne	ac7c <_ZN10Read_Utils8readLineEPcjb+0x110>
/home/schenkj/os2022/sp/sources/stdutils/src/readUtils.cpp:36 (discriminator 3)
					returnBuffer[i] = '\0';
    ac54:	e51b300c 	ldr	r3, [fp, #-12]
    ac58:	e51b209c 	ldr	r2, [fp, #-156]	; 0xffffff64
    ac5c:	e0823003 	add	r3, r2, r3
    ac60:	e3a02000 	mov	r2, #0
    ac64:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdutils/src/readUtils.cpp:37 (discriminator 3)
					continue; //Replace and continue to another character 
    ac68:	e320f000 	nop	{0}
/home/schenkj/os2022/sp/sources/stdutils/src/readUtils.cpp:34 (discriminator 3)
			for (int i = readChars - 1; i >= 0; i--) {
    ac6c:	e51b300c 	ldr	r3, [fp, #-12]
    ac70:	e2433001 	sub	r3, r3, #1
    ac74:	e50b300c 	str	r3, [fp, #-12]
    ac78:	eaffffe6 	b	ac18 <_ZN10Read_Utils8readLineEPcjb+0xac>
/home/schenkj/os2022/sp/sources/stdutils/src/readUtils.cpp:40
				}

				break; //There was no newline, we suspect that there is alphanumeric characters and no new line char will be present, so we can stop the search.
    ac7c:	e320f000 	nop	{0}
/home/schenkj/os2022/sp/sources/stdutils/src/readUtils.cpp:43
			}
		}
	} while (readChars == 0 && blocking == true);
    ac80:	e51b3008 	ldr	r3, [fp, #-8]
    ac84:	e3530000 	cmp	r3, #0
    ac88:	1a000003 	bne	ac9c <_ZN10Read_Utils8readLineEPcjb+0x130>
/home/schenkj/os2022/sp/sources/stdutils/src/readUtils.cpp:43 (discriminator 1)
    ac8c:	e55b30a1 	ldrb	r3, [fp, #-161]	; 0xffffff5f
    ac90:	e3530001 	cmp	r3, #1
    ac94:	1a000000 	bne	ac9c <_ZN10Read_Utils8readLineEPcjb+0x130>
/home/schenkj/os2022/sp/sources/stdutils/src/readUtils.cpp:15
	do {
    ac98:	eaffffc0 	b	aba0 <_ZN10Read_Utils8readLineEPcjb+0x34>
/home/schenkj/os2022/sp/sources/stdutils/src/readUtils.cpp:45
	
    return readChars;
    ac9c:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdutils/src/readUtils.cpp:46
}
    aca0:	e1a00003 	mov	r0, r3
    aca4:	e24bd004 	sub	sp, fp, #4
    aca8:	e8bd8800 	pop	{fp, pc}

0000acac <_ZN15Circular_BufferC1Ev>:
_ZN15Circular_BufferC2Ev():
/home/schenkj/os2022/sp/sources/stdutils/src/circularBuffer.cpp:4
#include <circularBuffer.h>
#include <stdstring.h>

Circular_Buffer::Circular_Buffer() {
    acac:	e92d4800 	push	{fp, lr}
    acb0:	e28db004 	add	fp, sp, #4
    acb4:	e24dd008 	sub	sp, sp, #8
    acb8:	e50b0008 	str	r0, [fp, #-8]
    acbc:	e51b3008 	ldr	r3, [fp, #-8]
    acc0:	e3a02000 	mov	r2, #0
    acc4:	e5832080 	str	r2, [r3, #128]	; 0x80
    acc8:	e51b3008 	ldr	r3, [fp, #-8]
    accc:	e3a02000 	mov	r2, #0
    acd0:	e5832084 	str	r2, [r3, #132]	; 0x84
/home/schenkj/os2022/sp/sources/stdutils/src/circularBuffer.cpp:5
    bzero(buffer, BUFFER_SIZE);
    acd4:	e51b3008 	ldr	r3, [fp, #-8]
    acd8:	e3a01080 	mov	r1, #128	; 0x80
    acdc:	e1a00003 	mov	r0, r3
    ace0:	ebffff5c 	bl	aa58 <_Z5bzeroPvi>
/home/schenkj/os2022/sp/sources/stdutils/src/circularBuffer.cpp:6
};
    ace4:	e51b3008 	ldr	r3, [fp, #-8]
    ace8:	e1a00003 	mov	r0, r3
    acec:	e24bd004 	sub	sp, fp, #4
    acf0:	e8bd8800 	pop	{fp, pc}

0000acf4 <_ZN15Circular_Buffer4readEPc>:
_ZN15Circular_Buffer4readEPc():
/home/schenkj/os2022/sp/sources/stdutils/src/circularBuffer.cpp:11

/* TODO: Vyresit tady nejak try_spinlock_lock. Mozna predat spinlock z UARTu, ktery muze UART driver zavrit externe nez spusti read. */

//read all and return len
uint32_t Circular_Buffer::read(char * ret) {
    acf4:	e92d4800 	push	{fp, lr}
    acf8:	e28db004 	add	fp, sp, #4
    acfc:	e24dd008 	sub	sp, sp, #8
    ad00:	e50b0008 	str	r0, [fp, #-8]
    ad04:	e50b100c 	str	r1, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdutils/src/circularBuffer.cpp:12
    return read(ret, write_index - read_index); //read all between start and stop
    ad08:	e51b3008 	ldr	r3, [fp, #-8]
    ad0c:	e5932084 	ldr	r2, [r3, #132]	; 0x84
    ad10:	e51b3008 	ldr	r3, [fp, #-8]
    ad14:	e5933080 	ldr	r3, [r3, #128]	; 0x80
    ad18:	e0423003 	sub	r3, r2, r3
    ad1c:	e1a02003 	mov	r2, r3
    ad20:	e51b100c 	ldr	r1, [fp, #-12]
    ad24:	e51b0008 	ldr	r0, [fp, #-8]
    ad28:	eb000003 	bl	ad3c <_ZN15Circular_Buffer4readEPcj>
    ad2c:	e1a03000 	mov	r3, r0
/home/schenkj/os2022/sp/sources/stdutils/src/circularBuffer.cpp:13
}
    ad30:	e1a00003 	mov	r0, r3
    ad34:	e24bd004 	sub	sp, fp, #4
    ad38:	e8bd8800 	pop	{fp, pc}

0000ad3c <_ZN15Circular_Buffer4readEPcj>:
_ZN15Circular_Buffer4readEPcj():
/home/schenkj/os2022/sp/sources/stdutils/src/circularBuffer.cpp:16

//try to read x char and return number of actually read chars
uint32_t Circular_Buffer::read(char * ret, uint32_t len) {
    ad3c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    ad40:	e28db000 	add	fp, sp, #0
    ad44:	e24dd024 	sub	sp, sp, #36	; 0x24
    ad48:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    ad4c:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    ad50:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/schenkj/os2022/sp/sources/stdutils/src/circularBuffer.cpp:17
    int readChars = 0;
    ad54:	e3a03000 	mov	r3, #0
    ad58:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdutils/src/circularBuffer.cpp:18
    uint32_t maxLen = write_index - read_index;
    ad5c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    ad60:	e5932084 	ldr	r2, [r3, #132]	; 0x84
    ad64:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    ad68:	e5933080 	ldr	r3, [r3, #128]	; 0x80
    ad6c:	e0423003 	sub	r3, r2, r3
    ad70:	e50b3010 	str	r3, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdutils/src/circularBuffer.cpp:20

    if (maxLen < len) {
    ad74:	e51b2010 	ldr	r2, [fp, #-16]
    ad78:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    ad7c:	e1520003 	cmp	r2, r3
    ad80:	2a000001 	bcs	ad8c <_ZN15Circular_Buffer4readEPcj+0x50>
/home/schenkj/os2022/sp/sources/stdutils/src/circularBuffer.cpp:21
        len = maxLen;
    ad84:	e51b3010 	ldr	r3, [fp, #-16]
    ad88:	e50b3020 	str	r3, [fp, #-32]	; 0xffffffe0
/home/schenkj/os2022/sp/sources/stdutils/src/circularBuffer.cpp:24
    }

    for (int i = 0; i < len; i++) {
    ad8c:	e3a03000 	mov	r3, #0
    ad90:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdutils/src/circularBuffer.cpp:24 (discriminator 3)
    ad94:	e51b300c 	ldr	r3, [fp, #-12]
    ad98:	e51b2020 	ldr	r2, [fp, #-32]	; 0xffffffe0
    ad9c:	e1520003 	cmp	r2, r3
    ada0:	9a000014 	bls	adf8 <_ZN15Circular_Buffer4readEPcj+0xbc>
/home/schenkj/os2022/sp/sources/stdutils/src/circularBuffer.cpp:25 (discriminator 2)
        ret[readChars] = buffer[read_index % BUFFER_SIZE];
    ada4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    ada8:	e5933080 	ldr	r3, [r3, #128]	; 0x80
    adac:	e203207f 	and	r2, r3, #127	; 0x7f
    adb0:	e51b3008 	ldr	r3, [fp, #-8]
    adb4:	e51b101c 	ldr	r1, [fp, #-28]	; 0xffffffe4
    adb8:	e0813003 	add	r3, r1, r3
    adbc:	e51b1018 	ldr	r1, [fp, #-24]	; 0xffffffe8
    adc0:	e7d12002 	ldrb	r2, [r1, r2]
    adc4:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdutils/src/circularBuffer.cpp:27 (discriminator 2)

        readChars++; //Increment counter to return
    adc8:	e51b3008 	ldr	r3, [fp, #-8]
    adcc:	e2833001 	add	r3, r3, #1
    add0:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdutils/src/circularBuffer.cpp:28 (discriminator 2)
        read_index++; //Increment read_index
    add4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    add8:	e5933080 	ldr	r3, [r3, #128]	; 0x80
    addc:	e2832001 	add	r2, r3, #1
    ade0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    ade4:	e5832080 	str	r2, [r3, #128]	; 0x80
/home/schenkj/os2022/sp/sources/stdutils/src/circularBuffer.cpp:24 (discriminator 2)
    for (int i = 0; i < len; i++) {
    ade8:	e51b300c 	ldr	r3, [fp, #-12]
    adec:	e2833001 	add	r3, r3, #1
    adf0:	e50b300c 	str	r3, [fp, #-12]
    adf4:	eaffffe6 	b	ad94 <_ZN15Circular_Buffer4readEPcj+0x58>
/home/schenkj/os2022/sp/sources/stdutils/src/circularBuffer.cpp:31
    }

    return readChars;
    adf8:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdutils/src/circularBuffer.cpp:32
}
    adfc:	e1a00003 	mov	r0, r3
    ae00:	e28bd000 	add	sp, fp, #0
    ae04:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    ae08:	e12fff1e 	bx	lr

0000ae0c <_ZN15Circular_Buffer5writeEPcj>:
_ZN15Circular_Buffer5writeEPcj():
/home/schenkj/os2022/sp/sources/stdutils/src/circularBuffer.cpp:35

//more chars write
void Circular_Buffer::write(char* input, uint32_t len) {
    ae0c:	e92d4800 	push	{fp, lr}
    ae10:	e28db004 	add	fp, sp, #4
    ae14:	e24dd018 	sub	sp, sp, #24
    ae18:	e50b0010 	str	r0, [fp, #-16]
    ae1c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    ae20:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdutils/src/circularBuffer.cpp:36
    for (int i = 0; i < len; i++) {
    ae24:	e3a03000 	mov	r3, #0
    ae28:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdutils/src/circularBuffer.cpp:36 (discriminator 3)
    ae2c:	e51b3008 	ldr	r3, [fp, #-8]
    ae30:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    ae34:	e1520003 	cmp	r2, r3
    ae38:	9a00000a 	bls	ae68 <_ZN15Circular_Buffer5writeEPcj+0x5c>
/home/schenkj/os2022/sp/sources/stdutils/src/circularBuffer.cpp:37 (discriminator 2)
        write(input[i]);
    ae3c:	e51b3008 	ldr	r3, [fp, #-8]
    ae40:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    ae44:	e0823003 	add	r3, r2, r3
    ae48:	e5d33000 	ldrb	r3, [r3]
    ae4c:	e1a01003 	mov	r1, r3
    ae50:	e51b0010 	ldr	r0, [fp, #-16]
    ae54:	eb000006 	bl	ae74 <_ZN15Circular_Buffer5writeEc>
/home/schenkj/os2022/sp/sources/stdutils/src/circularBuffer.cpp:36 (discriminator 2)
    for (int i = 0; i < len; i++) {
    ae58:	e51b3008 	ldr	r3, [fp, #-8]
    ae5c:	e2833001 	add	r3, r3, #1
    ae60:	e50b3008 	str	r3, [fp, #-8]
    ae64:	eafffff0 	b	ae2c <_ZN15Circular_Buffer5writeEPcj+0x20>
/home/schenkj/os2022/sp/sources/stdutils/src/circularBuffer.cpp:39
    }
}
    ae68:	e320f000 	nop	{0}
    ae6c:	e24bd004 	sub	sp, fp, #4
    ae70:	e8bd8800 	pop	{fp, pc}

0000ae74 <_ZN15Circular_Buffer5writeEc>:
_ZN15Circular_Buffer5writeEc():
/home/schenkj/os2022/sp/sources/stdutils/src/circularBuffer.cpp:42

// one char write
void Circular_Buffer::write(char input) {
    ae74:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    ae78:	e28db000 	add	fp, sp, #0
    ae7c:	e24dd00c 	sub	sp, sp, #12
    ae80:	e50b0008 	str	r0, [fp, #-8]
    ae84:	e1a03001 	mov	r3, r1
    ae88:	e54b3009 	strb	r3, [fp, #-9]
/home/schenkj/os2022/sp/sources/stdutils/src/circularBuffer.cpp:43
    buffer[write_index % BUFFER_SIZE] = input;
    ae8c:	e51b3008 	ldr	r3, [fp, #-8]
    ae90:	e5933084 	ldr	r3, [r3, #132]	; 0x84
    ae94:	e203307f 	and	r3, r3, #127	; 0x7f
    ae98:	e51b2008 	ldr	r2, [fp, #-8]
    ae9c:	e55b1009 	ldrb	r1, [fp, #-9]
    aea0:	e7c21003 	strb	r1, [r2, r3]
/home/schenkj/os2022/sp/sources/stdutils/src/circularBuffer.cpp:44
    write_index++;
    aea4:	e51b3008 	ldr	r3, [fp, #-8]
    aea8:	e5933084 	ldr	r3, [r3, #132]	; 0x84
    aeac:	e2832001 	add	r2, r3, #1
    aeb0:	e51b3008 	ldr	r3, [fp, #-8]
    aeb4:	e5832084 	str	r2, [r3, #132]	; 0x84
/home/schenkj/os2022/sp/sources/stdutils/src/circularBuffer.cpp:45
}
    aeb8:	e320f000 	nop	{0}
    aebc:	e28bd000 	add	sp, fp, #0
    aec0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    aec4:	e12fff1e 	bx	lr

0000aec8 <_ZN15Circular_Buffer9readUntilEcPc>:
_ZN15Circular_Buffer9readUntilEcPc():
/home/schenkj/os2022/sp/sources/stdutils/src/circularBuffer.cpp:49


//read till you find stop char, or return 0 and data back to buffer
uint32_t Circular_Buffer::readUntil(char stop, char* ret) {
    aec8:	e92d4800 	push	{fp, lr}
    aecc:	e28db004 	add	fp, sp, #4
    aed0:	e24dd018 	sub	sp, sp, #24
    aed4:	e50b0010 	str	r0, [fp, #-16]
    aed8:	e1a03001 	mov	r3, r1
    aedc:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    aee0:	e54b3011 	strb	r3, [fp, #-17]	; 0xffffffef
/home/schenkj/os2022/sp/sources/stdutils/src/circularBuffer.cpp:52
    int readTempIndex;

    for (readTempIndex = read_index; readTempIndex < write_index; readTempIndex++) {
    aee4:	e51b3010 	ldr	r3, [fp, #-16]
    aee8:	e5933080 	ldr	r3, [r3, #128]	; 0x80
    aeec:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdutils/src/circularBuffer.cpp:52 (discriminator 1)
    aef0:	e51b3010 	ldr	r3, [fp, #-16]
    aef4:	e5932084 	ldr	r2, [r3, #132]	; 0x84
    aef8:	e51b3008 	ldr	r3, [fp, #-8]
    aefc:	e1520003 	cmp	r2, r3
    af00:	9a000016 	bls	af60 <_ZN15Circular_Buffer9readUntilEcPc+0x98>
/home/schenkj/os2022/sp/sources/stdutils/src/circularBuffer.cpp:53
        if (buffer[readTempIndex % BUFFER_SIZE] == stop) {
    af04:	e51b3008 	ldr	r3, [fp, #-8]
    af08:	e2732000 	rsbs	r2, r3, #0
    af0c:	e203307f 	and	r3, r3, #127	; 0x7f
    af10:	e202207f 	and	r2, r2, #127	; 0x7f
    af14:	52623000 	rsbpl	r3, r2, #0
    af18:	e51b2010 	ldr	r2, [fp, #-16]
    af1c:	e7d23003 	ldrb	r3, [r2, r3]
    af20:	e55b2011 	ldrb	r2, [fp, #-17]	; 0xffffffef
    af24:	e1520003 	cmp	r2, r3
    af28:	0a00000b 	beq	af5c <_ZN15Circular_Buffer9readUntilEcPc+0x94>
/home/schenkj/os2022/sp/sources/stdutils/src/circularBuffer.cpp:58
            break;
        }

        //return 0 bcs I am at the end and there was no stop char
        if (readTempIndex == write_index - 1) {
    af2c:	e51b3010 	ldr	r3, [fp, #-16]
    af30:	e5933084 	ldr	r3, [r3, #132]	; 0x84
    af34:	e2432001 	sub	r2, r3, #1
    af38:	e51b3008 	ldr	r3, [fp, #-8]
    af3c:	e1520003 	cmp	r2, r3
    af40:	1a000001 	bne	af4c <_ZN15Circular_Buffer9readUntilEcPc+0x84>
/home/schenkj/os2022/sp/sources/stdutils/src/circularBuffer.cpp:59
            return 0;
    af44:	e3a03000 	mov	r3, #0
    af48:	ea00000f 	b	af8c <_ZN15Circular_Buffer9readUntilEcPc+0xc4>
/home/schenkj/os2022/sp/sources/stdutils/src/circularBuffer.cpp:52 (discriminator 2)
    for (readTempIndex = read_index; readTempIndex < write_index; readTempIndex++) {
    af4c:	e51b3008 	ldr	r3, [fp, #-8]
    af50:	e2833001 	add	r3, r3, #1
    af54:	e50b3008 	str	r3, [fp, #-8]
    af58:	eaffffe4 	b	aef0 <_ZN15Circular_Buffer9readUntilEcPc+0x28>
/home/schenkj/os2022/sp/sources/stdutils/src/circularBuffer.cpp:54
            break;
    af5c:	e320f000 	nop	{0}
/home/schenkj/os2022/sp/sources/stdutils/src/circularBuffer.cpp:64
        }
    }

    //readTempIndex keeps position
    return read(ret, readTempIndex - read_index + 1); //Read one more char - if we have asd\n, then \n is readTempIndex 3 - read_index 0 = 3 - but we want 4 letters
    af60:	e51b2008 	ldr	r2, [fp, #-8]
    af64:	e51b3010 	ldr	r3, [fp, #-16]
    af68:	e5933080 	ldr	r3, [r3, #128]	; 0x80
    af6c:	e0423003 	sub	r3, r2, r3
    af70:	e2833001 	add	r3, r3, #1
    af74:	e1a02003 	mov	r2, r3
    af78:	e51b1018 	ldr	r1, [fp, #-24]	; 0xffffffe8
    af7c:	e51b0010 	ldr	r0, [fp, #-16]
    af80:	ebffff6d 	bl	ad3c <_ZN15Circular_Buffer4readEPcj>
    af84:	e1a03000 	mov	r3, r0
    af88:	e320f000 	nop	{0}
/home/schenkj/os2022/sp/sources/stdutils/src/circularBuffer.cpp:65
}
    af8c:	e1a00003 	mov	r0, r3
    af90:	e24bd004 	sub	sp, fp, #4
    af94:	e8bd8800 	pop	{fp, pc}

0000af98 <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1099
    af98:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1101
    af9c:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1102
    afa0:	3a000074 	bcc	b178 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1103
    afa4:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1104
    afa8:	9a00006b 	bls	b15c <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1105
    afac:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1106
    afb0:	0a00006c 	beq	b168 <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1108
    afb4:	e16f3f10 	clz	r3, r0
    afb8:	e16f2f11 	clz	r2, r1
    afbc:	e0423003 	sub	r3, r2, r3
    afc0:	e273301f 	rsbs	r3, r3, #31
    afc4:	10833083 	addne	r3, r3, r3, lsl #1
    afc8:	e3a02000 	mov	r2, #0
    afcc:	108ff103 	addne	pc, pc, r3, lsl #2
    afd0:	e1a00000 	nop			; (mov r0, r0)
    afd4:	e1500f81 	cmp	r0, r1, lsl #31
    afd8:	e0a22002 	adc	r2, r2, r2
    afdc:	20400f81 	subcs	r0, r0, r1, lsl #31
    afe0:	e1500f01 	cmp	r0, r1, lsl #30
    afe4:	e0a22002 	adc	r2, r2, r2
    afe8:	20400f01 	subcs	r0, r0, r1, lsl #30
    afec:	e1500e81 	cmp	r0, r1, lsl #29
    aff0:	e0a22002 	adc	r2, r2, r2
    aff4:	20400e81 	subcs	r0, r0, r1, lsl #29
    aff8:	e1500e01 	cmp	r0, r1, lsl #28
    affc:	e0a22002 	adc	r2, r2, r2
    b000:	20400e01 	subcs	r0, r0, r1, lsl #28
    b004:	e1500d81 	cmp	r0, r1, lsl #27
    b008:	e0a22002 	adc	r2, r2, r2
    b00c:	20400d81 	subcs	r0, r0, r1, lsl #27
    b010:	e1500d01 	cmp	r0, r1, lsl #26
    b014:	e0a22002 	adc	r2, r2, r2
    b018:	20400d01 	subcs	r0, r0, r1, lsl #26
    b01c:	e1500c81 	cmp	r0, r1, lsl #25
    b020:	e0a22002 	adc	r2, r2, r2
    b024:	20400c81 	subcs	r0, r0, r1, lsl #25
    b028:	e1500c01 	cmp	r0, r1, lsl #24
    b02c:	e0a22002 	adc	r2, r2, r2
    b030:	20400c01 	subcs	r0, r0, r1, lsl #24
    b034:	e1500b81 	cmp	r0, r1, lsl #23
    b038:	e0a22002 	adc	r2, r2, r2
    b03c:	20400b81 	subcs	r0, r0, r1, lsl #23
    b040:	e1500b01 	cmp	r0, r1, lsl #22
    b044:	e0a22002 	adc	r2, r2, r2
    b048:	20400b01 	subcs	r0, r0, r1, lsl #22
    b04c:	e1500a81 	cmp	r0, r1, lsl #21
    b050:	e0a22002 	adc	r2, r2, r2
    b054:	20400a81 	subcs	r0, r0, r1, lsl #21
    b058:	e1500a01 	cmp	r0, r1, lsl #20
    b05c:	e0a22002 	adc	r2, r2, r2
    b060:	20400a01 	subcs	r0, r0, r1, lsl #20
    b064:	e1500981 	cmp	r0, r1, lsl #19
    b068:	e0a22002 	adc	r2, r2, r2
    b06c:	20400981 	subcs	r0, r0, r1, lsl #19
    b070:	e1500901 	cmp	r0, r1, lsl #18
    b074:	e0a22002 	adc	r2, r2, r2
    b078:	20400901 	subcs	r0, r0, r1, lsl #18
    b07c:	e1500881 	cmp	r0, r1, lsl #17
    b080:	e0a22002 	adc	r2, r2, r2
    b084:	20400881 	subcs	r0, r0, r1, lsl #17
    b088:	e1500801 	cmp	r0, r1, lsl #16
    b08c:	e0a22002 	adc	r2, r2, r2
    b090:	20400801 	subcs	r0, r0, r1, lsl #16
    b094:	e1500781 	cmp	r0, r1, lsl #15
    b098:	e0a22002 	adc	r2, r2, r2
    b09c:	20400781 	subcs	r0, r0, r1, lsl #15
    b0a0:	e1500701 	cmp	r0, r1, lsl #14
    b0a4:	e0a22002 	adc	r2, r2, r2
    b0a8:	20400701 	subcs	r0, r0, r1, lsl #14
    b0ac:	e1500681 	cmp	r0, r1, lsl #13
    b0b0:	e0a22002 	adc	r2, r2, r2
    b0b4:	20400681 	subcs	r0, r0, r1, lsl #13
    b0b8:	e1500601 	cmp	r0, r1, lsl #12
    b0bc:	e0a22002 	adc	r2, r2, r2
    b0c0:	20400601 	subcs	r0, r0, r1, lsl #12
    b0c4:	e1500581 	cmp	r0, r1, lsl #11
    b0c8:	e0a22002 	adc	r2, r2, r2
    b0cc:	20400581 	subcs	r0, r0, r1, lsl #11
    b0d0:	e1500501 	cmp	r0, r1, lsl #10
    b0d4:	e0a22002 	adc	r2, r2, r2
    b0d8:	20400501 	subcs	r0, r0, r1, lsl #10
    b0dc:	e1500481 	cmp	r0, r1, lsl #9
    b0e0:	e0a22002 	adc	r2, r2, r2
    b0e4:	20400481 	subcs	r0, r0, r1, lsl #9
    b0e8:	e1500401 	cmp	r0, r1, lsl #8
    b0ec:	e0a22002 	adc	r2, r2, r2
    b0f0:	20400401 	subcs	r0, r0, r1, lsl #8
    b0f4:	e1500381 	cmp	r0, r1, lsl #7
    b0f8:	e0a22002 	adc	r2, r2, r2
    b0fc:	20400381 	subcs	r0, r0, r1, lsl #7
    b100:	e1500301 	cmp	r0, r1, lsl #6
    b104:	e0a22002 	adc	r2, r2, r2
    b108:	20400301 	subcs	r0, r0, r1, lsl #6
    b10c:	e1500281 	cmp	r0, r1, lsl #5
    b110:	e0a22002 	adc	r2, r2, r2
    b114:	20400281 	subcs	r0, r0, r1, lsl #5
    b118:	e1500201 	cmp	r0, r1, lsl #4
    b11c:	e0a22002 	adc	r2, r2, r2
    b120:	20400201 	subcs	r0, r0, r1, lsl #4
    b124:	e1500181 	cmp	r0, r1, lsl #3
    b128:	e0a22002 	adc	r2, r2, r2
    b12c:	20400181 	subcs	r0, r0, r1, lsl #3
    b130:	e1500101 	cmp	r0, r1, lsl #2
    b134:	e0a22002 	adc	r2, r2, r2
    b138:	20400101 	subcs	r0, r0, r1, lsl #2
    b13c:	e1500081 	cmp	r0, r1, lsl #1
    b140:	e0a22002 	adc	r2, r2, r2
    b144:	20400081 	subcs	r0, r0, r1, lsl #1
    b148:	e1500001 	cmp	r0, r1
    b14c:	e0a22002 	adc	r2, r2, r2
    b150:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1110
    b154:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1111
    b158:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1114
    b15c:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1115
    b160:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1116
    b164:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1118
    b168:	e16f2f11 	clz	r2, r1
    b16c:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1120
    b170:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1121
    b174:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1125
    b178:	e3500000 	cmp	r0, #0
    b17c:	13e00000 	mvnne	r0, #0
    b180:	ea000007 	b	b1a4 <__aeabi_idiv0>

0000b184 <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1156
    b184:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1157
    b188:	0afffffa 	beq	b178 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1158
    b18c:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1159
    b190:	ebffff80 	bl	af98 <__udivsi3>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1160
    b194:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    b198:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    b19c:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1163
    b1a0:	e12fff1e 	bx	lr

0000b1a4 <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1461
    b1a4:	e12fff1e 	bx	lr

Disassembly of section .rodata:

0000b1a8 <_ZL13Lock_Unlocked>:
    b1a8:	00000000 	andeq	r0, r0, r0

0000b1ac <_ZL11Lock_Locked>:
    b1ac:	00000001 	andeq	r0, r0, r1

0000b1b0 <_ZL21MaxFSDriverNameLength>:
    b1b0:	00000010 	andeq	r0, r0, r0, lsl r0

0000b1b4 <_ZL17MaxFilenameLength>:
    b1b4:	00000010 	andeq	r0, r0, r0, lsl r0

0000b1b8 <_ZL13MaxPathLength>:
    b1b8:	00000080 	andeq	r0, r0, r0, lsl #1

0000b1bc <_ZL18NoFilesystemDriver>:
    b1bc:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000b1c0 <_ZL9NotifyAll>:
    b1c0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000b1c4 <_ZL24Max_Process_Opened_Files>:
    b1c4:	00000010 	andeq	r0, r0, r0, lsl r0

0000b1c8 <_ZL10Indefinite>:
    b1c8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000b1cc <_ZL18Deadline_Unchanged>:
    b1cc:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

0000b1d0 <_ZL14Invalid_Handle>:
    b1d0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000b1d4 <_ZL10POPULATION>:
    b1d4:	00000032 	andeq	r0, r0, r2, lsr r0

0000b1d8 <_ZL9GEN_COUNT>:
    b1d8:	000003e8 	andeq	r0, r0, r8, ror #7

0000b1dc <_ZL30PROBABILITY_OF_MUTAION_PERCENT>:
    b1dc:	0000000a 	andeq	r0, r0, sl

0000b1e0 <_ZL12RANDOM_RANGE>:
    b1e0:	00000032 	andeq	r0, r0, r2, lsr r0
    b1e4:	0000000a 	andeq	r0, r0, sl
    b1e8:	202c4b4f 	eorcs	r4, ip, pc, asr #22
    b1ec:	6b6f726b 	blvs	1be7ba0 <__bss_end+0x1bdc268>
    b1f0:	6e61766f 	cdpvs	6, 6, cr7, cr1, cr15, {3}
    b1f4:	00002069 	andeq	r2, r0, r9, rrx
    b1f8:	6e696d20 	cdpvs	13, 6, cr6, cr9, cr0, {1}
    b1fc:	00000a2e 	andeq	r0, r0, lr, lsr #20
    b200:	6564615a 	strbvs	r6, [r4, #-346]!	; 0xfffffea6
    b204:	2065746a 	rsbcs	r7, r5, sl, ror #8
    b208:	656c6563 	strbvs	r6, [ip, #-1379]!	; 0xfffffa9d
    b20c:	73696320 	cmnvc	r9, #32, 6	; 0x80000000
    b210:	70206f6c 	eorvc	r6, r0, ip, ror #30
    b214:	69736f72 	ldmdbvs	r3!, {r1, r4, r5, r6, r8, r9, sl, fp, sp, lr}^
    b218:	000a2e6d 	andeq	r2, sl, sp, ror #28
    b21c:	202c4b4f 	eorcs	r4, ip, pc, asr #22
    b220:	64657270 	strbtvs	r7, [r5], #-624	; 0xfffffd90
    b224:	65636b69 	strbvs	r6, [r3, #-2921]!	; 0xfffff497
    b228:	20656a20 	rsbcs	r6, r5, r0, lsr #20
    b22c:	00000000 	andeq	r0, r0, r0
    b230:	61726170 	cmnvs	r2, r0, ror r1
    b234:	6574656d 	ldrbvs	r6, [r4, #-1389]!	; 0xfffffa93
    b238:	00007372 	andeq	r7, r0, r2, ror r3
    b23c:	20746f4e 	rsbscs	r6, r4, lr, asr #30
    b240:	756f6e65 	strbvc	r6, [pc, #-3685]!	; a3e3 <_Z4atofPKc+0x10b>
    b244:	76206867 	strtvc	r6, [r0], -r7, ror #16
    b248:	65756c61 	ldrbvs	r6, [r5, #-3169]!	; 0xfffff39f
    b24c:	00000a73 	andeq	r0, r0, r3, ror sl
    b250:	74736542 	ldrbtvc	r6, [r3], #-1346	; 0xfffffabe
    b254:	74694620 	strbtvc	r4, [r9], #-1568	; 0xfffff9e0
    b258:	0000203a 	andeq	r2, r0, sl, lsr r0
    b25c:	203d2041 	eorscs	r2, sp, r1, asr #32
    b260:	00000000 	andeq	r0, r0, r0
    b264:	2042202c 	subcs	r2, r2, ip, lsr #32
    b268:	0000203d 	andeq	r2, r0, sp, lsr r0
    b26c:	2043202c 	subcs	r2, r3, ip, lsr #32
    b270:	0000203d 	andeq	r2, r0, sp, lsr r0
    b274:	2044202c 	subcs	r2, r4, ip, lsr #32
    b278:	0000203d 	andeq	r2, r0, sp, lsr r0
    b27c:	2045202c 	subcs	r2, r5, ip, lsr #32
    b280:	0000203d 	andeq	r2, r0, sp, lsr r0
    b284:	3a564544 	bcc	159c79c <__bss_end+0x1590e64>
    b288:	74726175 	ldrbtvc	r6, [r2], #-373	; 0xfffffe8b
    b28c:	0000302f 	andeq	r3, r0, pc, lsr #32
    b290:	3a564544 	bcc	159c7a8 <__bss_end+0x1590e70>
    b294:	676e7274 			; <UNDEFINED> instruction: 0x676e7274
    b298:	00000000 	andeq	r0, r0, r0
    b29c:	636c6143 	cmnvs	ip, #-1073741808	; 0xc0000010
    b2a0:	7620534f 	strtvc	r5, [r0], -pc, asr #6
    b2a4:	0a312e31 	beq	c56b70 <__bss_end+0xc4b238>
    b2a8:	6f747541 	svcvs	0x00747541
    b2ac:	4a203a72 	bmi	819c7c <__bss_end+0x80e344>
    b2b0:	62756b61 	rsbsvs	r6, r5, #99328	; 0x18400
    b2b4:	68635320 	stmdavs	r3!, {r5, r8, r9, ip, lr}^
    b2b8:	206b6e65 	rsbcs	r6, fp, r5, ror #28
    b2bc:	31324128 	teqcc	r2, r8, lsr #2
    b2c0:	3630304e 	ldrtcc	r3, [r0], -lr, asr #32
    b2c4:	0a295039 	beq	a5f3b0 <__bss_end+0xa53a78>
    b2c8:	6564615a 	strbvs	r6, [r4, #-346]!	; 0xfffffea6
    b2cc:	2065746a 	rsbcs	r7, r5, sl, ror #8
    b2d0:	706a656e 	rsbvc	r6, sl, lr, ror #10
    b2d4:	20657672 	rsbcs	r7, r5, r2, ror r6
    b2d8:	6f736163 	svcvs	0x00736163
    b2dc:	72207976 	eorvc	r7, r0, #1933312	; 0x1d8000
    b2e0:	73657a6f 	cmnvc	r5, #454656	; 0x6f000
    b2e4:	20707574 	rsbscs	r7, r0, r4, ror r5
    b2e8:	72702061 	rsbsvc	r2, r0, #97	; 0x61
    b2ec:	6b696465 	blvs	1a64488 <__bss_end+0x1a58b50>
    b2f0:	20696e63 	rsbcs	r6, r9, r3, ror #28
    b2f4:	6e656b6f 	vnmulvs.f64	d22, d5, d31
    b2f8:	76206f6b 	strtvc	r6, [r0], -fp, ror #30
    b2fc:	6e696d20 	cdpvs	13, 6, cr6, cr9, cr0, {1}
    b300:	63617475 	cmnvs	r1, #1962934272	; 0x75000000
    b304:	61440a68 	cmpvs	r4, r8, ror #20
    b308:	7020656c 	eorvc	r6, r0, ip, ror #10
    b30c:	6f70646f 	svcvs	0x0070646f
    b310:	61766f72 	cmnvs	r6, r2, ror pc
    b314:	7020656e 	eorvc	r6, r0, lr, ror #10
    b318:	616b6972 	smcvs	46738	; 0xb692
    b31c:	203a797a 	eorscs	r7, sl, sl, ror r9
    b320:	706f7473 	rsbvc	r7, pc, r3, ror r4	; <UNPREDICTABLE>
    b324:	6170202c 	cmnvs	r0, ip, lsr #32
    b328:	656d6172 	strbvs	r6, [sp, #-370]!	; 0xfffffe8e
    b32c:	73726574 	cmnvc	r2, #116, 10	; 0x1d000000
    b330:	0000000a 	andeq	r0, r0, sl
    b334:	6564615a 	strbvs	r6, [r4, #-346]!	; 0xfffffea6
    b338:	2065746a 	rsbcs	r7, r5, sl, ror #8
    b33c:	736f7270 	cmnvc	pc, #112, 4
    b340:	22206d69 	eorcs	r6, r0, #6720	; 0x1a40
    b344:	706f7473 	rsbvc	r7, pc, r3, ror r4	; <UNPREDICTABLE>
    b348:	22202c22 	eorcs	r2, r0, #8704	; 0x2200
    b34c:	61726170 	cmnvs	r2, r0, ror r1
    b350:	6574656d 	ldrbvs	r6, [r4, #-1389]!	; 0xfffffa93
    b354:	20227372 	eorcs	r7, r2, r2, ror r3
    b358:	6f62656e 	svcvs	0x0062656e
    b35c:	73656420 	cmnvc	r5, #32, 8	; 0x20000000
    b360:	6e697465 	cdpvs	4, 6, cr7, cr9, cr5, {3}
    b364:	6320656e 			; <UNDEFINED> instruction: 0x6320656e
    b368:	6f6c7369 	svcvs	0x006c7369
    b36c:	00000a2e 	andeq	r0, r0, lr, lsr #20
    b370:	64657250 	strbtvs	r7, [r5], #-592	; 0xfffffdb0
    b374:	65746369 	ldrbvs	r6, [r4, #-873]!	; 0xfffffc97
    b378:	20592064 	subscs	r2, r9, r4, rrx
    b37c:	74206e69 	strtvc	r6, [r0], #-3689	; 0xfffff197
    b380:	66206568 	strtvs	r6, [r0], -r8, ror #10
    b384:	72757475 	rsbsvc	r7, r5, #1962934272	; 0x75000000
    b388:	73692065 	cmnvc	r9, #101	; 0x65
    b38c:	0000203a 	andeq	r2, r0, sl, lsr r0
    b390:	2d2d2d2d 	stccs	13, cr2, [sp, #-180]!	; 0xffffff4c
    b394:	2d2d2d2d 	stccs	13, cr2, [sp, #-180]!	; 0xffffff4c
    b398:	2d2d2d2d 	stccs	13, cr2, [sp, #-180]!	; 0xffffff4c
    b39c:	2d2d2d2d 	stccs	13, cr2, [sp, #-180]!	; 0xffffff4c
    b3a0:	2d2d2d2d 	stccs	13, cr2, [sp, #-180]!	; 0xffffff4c
    b3a4:	2d2d2d2d 	stccs	13, cr2, [sp, #-180]!	; 0xffffff4c
    b3a8:	2d2d2d2d 	stccs	13, cr2, [sp, #-180]!	; 0xffffff4c
    b3ac:	0a2d2d2d 	beq	b56868 <__bss_end+0xb4af30>
    b3b0:	00000000 	andeq	r0, r0, r0
    b3b4:	676f7250 			; <UNDEFINED> instruction: 0x676f7250
    b3b8:	206d6172 	rsbcs	r6, sp, r2, ror r1
    b3bc:	74697865 	strbtvc	r7, [r9], #-2149	; 0xfffff79b
    b3c0:	74697720 	strbtvc	r7, [r9], #-1824	; 0xfffff8e0
    b3c4:	74732068 	ldrbtvc	r2, [r3], #-104	; 0xffffff98
    b3c8:	73757461 	cmnvc	r5, #1627389952	; 0x61000000
    b3cc:	2d203120 	stfcss	f3, [r0, #-128]!	; 0xffffff80
    b3d0:	6f747320 	svcvs	0x00747320
    b3d4:	64657070 	strbtvs	r7, [r5], #-112	; 0xffffff90
    b3d8:	74697720 	strbtvc	r7, [r9], #-1824	; 0xfffff8e0
    b3dc:	73222068 			; <UNDEFINED> instruction: 0x73222068
    b3e0:	22706f74 	rsbscs	r6, r0, #116, 30	; 0x1d0
    b3e4:	00000a2e 	andeq	r0, r0, lr, lsr #20

0000b3e8 <_ZL13Lock_Unlocked>:
    b3e8:	00000000 	andeq	r0, r0, r0

0000b3ec <_ZL11Lock_Locked>:
    b3ec:	00000001 	andeq	r0, r0, r1

0000b3f0 <_ZL21MaxFSDriverNameLength>:
    b3f0:	00000010 	andeq	r0, r0, r0, lsl r0

0000b3f4 <_ZL17MaxFilenameLength>:
    b3f4:	00000010 	andeq	r0, r0, r0, lsl r0

0000b3f8 <_ZL13MaxPathLength>:
    b3f8:	00000080 	andeq	r0, r0, r0, lsl #1

0000b3fc <_ZL18NoFilesystemDriver>:
    b3fc:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000b400 <_ZL9NotifyAll>:
    b400:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000b404 <_ZL24Max_Process_Opened_Files>:
    b404:	00000010 	andeq	r0, r0, r0, lsl r0

0000b408 <_ZL10Indefinite>:
    b408:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000b40c <_ZL18Deadline_Unchanged>:
    b40c:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

0000b410 <_ZL14Invalid_Handle>:
    b410:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000b414 <_ZL16Pipe_File_Prefix>:
    b414:	3a535953 	bcc	14e1968 <__bss_end+0x14d6030>
    b418:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    b41c:	0000002f 	andeq	r0, r0, pc, lsr #32

0000b420 <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    b420:	33323130 	teqcc	r2, #48, 2
    b424:	37363534 			; <UNDEFINED> instruction: 0x37363534
    b428:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    b42c:	46454443 	strbmi	r4, [r5], -r3, asr #8
    b430:	00000000 	andeq	r0, r0, r0

0000b434 <_ZL13Lock_Unlocked>:
    b434:	00000000 	andeq	r0, r0, r0

0000b438 <_ZL11Lock_Locked>:
    b438:	00000001 	andeq	r0, r0, r1

0000b43c <_ZL21MaxFSDriverNameLength>:
    b43c:	00000010 	andeq	r0, r0, r0, lsl r0

0000b440 <_ZL17MaxFilenameLength>:
    b440:	00000010 	andeq	r0, r0, r0, lsl r0

0000b444 <_ZL13MaxPathLength>:
    b444:	00000080 	andeq	r0, r0, r0, lsl #1

0000b448 <_ZL18NoFilesystemDriver>:
    b448:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000b44c <_ZL9NotifyAll>:
    b44c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000b450 <_ZL24Max_Process_Opened_Files>:
    b450:	00000010 	andeq	r0, r0, r0, lsl r0

0000b454 <_ZL10Indefinite>:
    b454:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000b458 <_ZL18Deadline_Unchanged>:
    b458:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

0000b45c <_ZL14Invalid_Handle>:
    b45c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

Disassembly of section .data:

0000b460 <__CTOR_LIST__>:
    b460:	00009b44 	andeq	r9, r0, r4, asr #22

0000b464 <__DTOR_LIST__>:
__DTOR_END__():
    b464:	00000010 	andeq	r0, r0, r0, lsl r0

Disassembly of section .bss:

0000b468 <DELTA>:
__bss_start():
    b468:	00000000 	andeq	r0, r0, r0

0000b46c <PRED>:
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:10
uint32_t PRED;
    b46c:	00000000 	andeq	r0, r0, r0

0000b470 <DERIV_CONST>:
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:12
float DERIV_CONST;
    b470:	00000000 	andeq	r0, r0, r0

0000b474 <values>:
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:14
float* values = reinterpret_cast<float*>(malloc(16*sizeof(float)));
    b474:	00000000 	andeq	r0, r0, r0

0000b478 <val_counter>:
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:16
uint32_t val_counter;
    b478:	00000000 	andeq	r0, r0, r0

0000b47c <generationA>:
	...

0000b544 <generationB>:
	...

0000b60c <generationC>:
	...

0000b6d4 <generationD>:
	...

0000b79c <generationE>:
	...

0000b864 <best_index>:
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:29
uint32_t best_index;
    b864:	00000000 	andeq	r0, r0, r0

0000b868 <stop>:
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:31
bool stop;
    b868:	00000000 	andeq	r0, r0, r0

0000b86c <readValue>:
	...

0000b88c <reader>:
	...

0000b914 <uartFile>:
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:37
uint32_t uartFile;
    b914:	00000000 	andeq	r0, r0, r0

0000b918 <rnd>:
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:39
uint32_t rnd;
    b918:	00000000 	andeq	r0, r0, r0

0000b91c <rnd_value>:
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:40
uint32_t rnd_value;
    b91c:	00000000 	andeq	r0, r0, r0

0000b920 <best_params>:
/home/schenkj/os2022/sp/sources/userspace/sp_task/main.cpp:43
float* best_params = reinterpret_cast<float*>(malloc(5*sizeof(float)));
    b920:	00000000 	andeq	r0, r0, r0

0000b924 <old_best_params>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x1681ef4>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x36aec>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3a700>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c53ec>
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
      24:	6a6b6e65 	bvs	1adb9c0 <__bss_end+0x1ad0088>
      28:	32736f2f 	rsbscc	r6, r3, #47, 30	; 0xbc
      2c:	2f323230 	svccs	0x00323230
      30:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
      34:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
      38:	752f7365 	strvc	r7, [pc, #-869]!	; fffffcdb <__bss_end+0xffff43a3>
      3c:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
      40:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
      44:	72630000 	rsbvc	r0, r3, #0
      48:	732e3074 			; <UNDEFINED> instruction: 0x732e3074
      4c:	00000100 	andeq	r0, r0, r0, lsl #2
      50:	02050000 	andeq	r0, r5, #0
      54:	00008000 	andeq	r8, r0, r0
      58:	31010903 	tstcc	r1, r3, lsl #18
      5c:	01000202 	tsteq	r0, r2, lsl #4
      60:	00008c01 	andeq	r8, r0, r1, lsl #24
      64:	47000300 	strmi	r0, [r0, -r0, lsl #6]
      68:	02000000 	andeq	r0, r0, #0
      6c:	0d0efb01 	vstreq	d15, [lr, #-4]
      70:	01010100 	mrseq	r0, (UNDEF: 17)
      74:	00000001 	andeq	r0, r0, r1
      78:	01000001 	tsteq	r0, r1
      7c:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffffc8 <__bss_end+0xffff4690>
      80:	63732f65 	cmnvs	r3, #404	; 0x194
      84:	6b6e6568 	blvs	1b9962c <__bss_end+0x1b8dcf4>
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
      bc:	18050109 	stmdane	r5, {r0, r3, r8}
      c0:	4a050567 	bmi	141664 <__bss_end+0x135d2c>
      c4:	02000e05 	andeq	r0, r0, #5, 28	; 0x50
      c8:	052f0304 	streq	r0, [pc, #-772]!	; fffffdcc <__bss_end+0xffff4494>
      cc:	04020041 	streq	r0, [r2], #-65	; 0xffffffbf
      d0:	05056503 	streq	r6, [r5, #-1283]	; 0xfffffafd
      d4:	01040200 	mrseq	r0, R12_usr
      d8:	84010566 	strhi	r0, [r1], #-1382	; 0xfffffa9a
      dc:	680505d9 	stmdavs	r5, {r0, r3, r4, r6, r7, r8, sl}
      e0:	33120531 	tstcc	r2, #205520896	; 0xc400000
      e4:	31850505 	orrcc	r0, r5, r5, lsl #10
      e8:	2f01054b 	svccs	0x0001054b
      ec:	01000602 	tsteq	r0, r2, lsl #12
      f0:	0000e201 	andeq	lr, r0, r1, lsl #4
      f4:	59000300 	stmdbpl	r0, {r8, r9}
      f8:	02000000 	andeq	r0, r0, #0
      fc:	0d0efb01 	vstreq	d15, [lr, #-4]
     100:	01010100 	mrseq	r0, (UNDEF: 17)
     104:	00000001 	andeq	r0, r0, r1
     108:	01000001 	tsteq	r0, r1
     10c:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 58 <shift+0x58>
     110:	63732f65 	cmnvs	r3, #404	; 0x194
     114:	6b6e6568 	blvs	1b996bc <__bss_end+0x1b8dd84>
     118:	736f2f6a 	cmnvc	pc, #424	; 0x1a8
     11c:	32323032 	eorscc	r3, r2, #50	; 0x32
     120:	2f70732f 	svccs	0x0070732f
     124:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     128:	2f736563 	svccs	0x00736563
     12c:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     130:	63617073 	cmnvs	r1, #115	; 0x73
     134:	63000065 	movwvs	r0, #101	; 0x65
     138:	62617878 	rsbvs	r7, r1, #120, 16	; 0x780000
     13c:	70632e69 	rsbvc	r2, r3, r9, ror #28
     140:	00010070 	andeq	r0, r1, r0, ror r0
     144:	75623c00 	strbvc	r3, [r2, #-3072]!	; 0xfffff400
     148:	2d746c69 	ldclcs	12, cr6, [r4, #-420]!	; 0xfffffe5c
     14c:	003e6e69 	eorseq	r6, lr, r9, ror #28
     150:	00000000 	andeq	r0, r0, r0
     154:	05000205 	streq	r0, [r0, #-517]	; 0xfffffdfb
     158:	0080a402 	addeq	sl, r0, r2, lsl #8
     15c:	010a0300 	mrseq	r0, (UNDEF: 58)
     160:	05830b05 	streq	r0, [r3, #2821]	; 0xb05
     164:	02054a0a 	andeq	r4, r5, #40960	; 0xa000
     168:	0e058583 	cfsh32eq	mvfx8, mvfx5, #-61
     16c:	67020583 	strvs	r0, [r2, -r3, lsl #11]
     170:	01058485 	smlabbeq	r5, r5, r4, r8
     174:	4c854c86 	stcmi	12, cr4, [r5], {134}	; 0x86
     178:	05854c85 	streq	r4, [r5, #3205]	; 0xc85
     17c:	04020002 	streq	r0, [r2], #-2
     180:	01054b01 	tsteq	r5, r1, lsl #22
     184:	052e1203 	streq	r1, [lr, #-515]!	; 0xfffffdfd
     188:	24056b0d 	strcs	r6, [r5], #-2829	; 0xfffff4f3
     18c:	03040200 	movweq	r0, #16896	; 0x4200
     190:	0004054a 	andeq	r0, r4, sl, asr #10
     194:	83020402 	movwhi	r0, #9218	; 0x2402
     198:	02000b05 	andeq	r0, r0, #5120	; 0x1400
     19c:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     1a0:	04020002 	streq	r0, [r2], #-2
     1a4:	09052d02 	stmdbeq	r5, {r1, r8, sl, fp, sp}
     1a8:	2f010585 	svccs	0x00010585
     1ac:	6a0d05a1 	bvs	341838 <__bss_end+0x335f00>
     1b0:	02002405 	andeq	r2, r0, #83886080	; 0x5000000
     1b4:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     1b8:	04020004 	streq	r0, [r2], #-4
     1bc:	0b058302 	bleq	160dcc <__bss_end+0x155494>
     1c0:	02040200 	andeq	r0, r4, #0, 4
     1c4:	0002054a 	andeq	r0, r2, sl, asr #10
     1c8:	2d020402 	cfstrscs	mvf0, [r2, #-8]
     1cc:	05850905 	streq	r0, [r5, #2309]	; 0x905
     1d0:	0a022f01 	beq	8bddc <__bss_end+0x804a4>
     1d4:	0c010100 	stfeqs	f0, [r1], {-0}
     1d8:	03000009 	movweq	r0, #9
     1dc:	00023000 	andeq	r3, r2, r0
     1e0:	fb010200 	blx	409ea <__bss_end+0x350b2>
     1e4:	01000d0e 	tsteq	r0, lr, lsl #26
     1e8:	00010101 	andeq	r0, r1, r1, lsl #2
     1ec:	00010000 	andeq	r0, r1, r0
     1f0:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
     1f4:	2f656d6f 	svccs	0x00656d6f
     1f8:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
     1fc:	2f6a6b6e 	svccs	0x006a6b6e
     200:	3032736f 	eorscc	r7, r2, pc, ror #6
     204:	732f3232 			; <UNDEFINED> instruction: 0x732f3232
     208:	6f732f70 	svcvs	0x00732f70
     20c:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     210:	73752f73 	cmnvc	r5, #460	; 0x1cc
     214:	70737265 	rsbsvc	r7, r3, r5, ror #4
     218:	2f656361 	svccs	0x00656361
     21c:	745f7073 	ldrbvc	r7, [pc], #-115	; 224 <shift+0x224>
     220:	006b7361 	rsbeq	r7, fp, r1, ror #6
     224:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 170 <shift+0x170>
     228:	63732f65 	cmnvs	r3, #404	; 0x194
     22c:	6b6e6568 	blvs	1b997d4 <__bss_end+0x1b8de9c>
     230:	736f2f6a 	cmnvc	pc, #424	; 0x1a8
     234:	32323032 	eorscc	r3, r2, #50	; 0x32
     238:	2f70732f 	svccs	0x0070732f
     23c:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     240:	2f736563 	svccs	0x00736563
     244:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     248:	63617073 	cmnvs	r1, #115	; 0x73
     24c:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
     250:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     254:	2f6c656e 	svccs	0x006c656e
     258:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     25c:	2f656475 	svccs	0x00656475
     260:	636f7270 	cmnvs	pc, #112, 4
     264:	00737365 	rsbseq	r7, r3, r5, ror #6
     268:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 1b4 <shift+0x1b4>
     26c:	63732f65 	cmnvs	r3, #404	; 0x194
     270:	6b6e6568 	blvs	1b99818 <__bss_end+0x1b8dee0>
     274:	736f2f6a 	cmnvc	pc, #424	; 0x1a8
     278:	32323032 	eorscc	r3, r2, #50	; 0x32
     27c:	2f70732f 	svccs	0x0070732f
     280:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     284:	2f736563 	svccs	0x00736563
     288:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     28c:	63617073 	cmnvs	r1, #115	; 0x73
     290:	2e2e2f65 	cdpcs	15, 2, cr2, cr14, cr5, {3}
     294:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     298:	2f6c656e 	svccs	0x006c656e
     29c:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     2a0:	2f656475 	svccs	0x00656475
     2a4:	2f007366 	svccs	0x00007366
     2a8:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     2ac:	6863732f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, sp, lr}^
     2b0:	6a6b6e65 	bvs	1adbc4c <__bss_end+0x1ad0314>
     2b4:	32736f2f 	rsbscc	r6, r3, #47, 30	; 0xbc
     2b8:	2f323230 	svccs	0x00323230
     2bc:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
     2c0:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     2c4:	752f7365 	strvc	r7, [pc, #-869]!	; ffffff67 <__bss_end+0xffff462f>
     2c8:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     2cc:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     2d0:	2f2e2e2f 	svccs	0x002e2e2f
     2d4:	75647473 	strbvc	r7, [r4, #-1139]!	; 0xfffffb8d
     2d8:	736c6974 	cmnvc	ip, #116, 18	; 0x1d0000
     2dc:	636e692f 	cmnvs	lr, #770048	; 0xbc000
     2e0:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
     2e4:	6f682f00 	svcvs	0x00682f00
     2e8:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
     2ec:	6e656863 	cdpvs	8, 6, cr6, cr5, cr3, {3}
     2f0:	6f2f6a6b 	svcvs	0x002f6a6b
     2f4:	32303273 	eorscc	r3, r0, #805306375	; 0x30000007
     2f8:	70732f32 	rsbsvc	r2, r3, r2, lsr pc
     2fc:	756f732f 	strbvc	r7, [pc, #-815]!	; ffffffd5 <__bss_end+0xffff469d>
     300:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     304:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
     308:	61707372 	cmnvs	r0, r2, ror r3
     30c:	2e2f6563 	cfsh64cs	mvdx6, mvdx15, #51
     310:	656b2f2e 	strbvs	r2, [fp, #-3886]!	; 0xfffff0d2
     314:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     318:	636e692f 	cmnvs	lr, #770048	; 0xbc000
     31c:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
     320:	6972642f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, sl, sp, lr}^
     324:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
     328:	6972622f 	ldmdbvs	r2!, {r0, r1, r2, r3, r5, r9, sp, lr}^
     32c:	73656764 	cmnvc	r5, #100, 14	; 0x1900000
     330:	6f682f00 	svcvs	0x00682f00
     334:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
     338:	6e656863 	cdpvs	8, 6, cr6, cr5, cr3, {3}
     33c:	6f2f6a6b 	svcvs	0x002f6a6b
     340:	32303273 	eorscc	r3, r0, #805306375	; 0x30000007
     344:	70732f32 	rsbsvc	r2, r3, r2, lsr pc
     348:	756f732f 	strbvc	r7, [pc, #-815]!	; 21 <shift+0x21>
     34c:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     350:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
     354:	61707372 	cmnvs	r0, r2, ror r3
     358:	2e2f6563 	cfsh64cs	mvdx6, mvdx15, #51
     35c:	656b2f2e 	strbvs	r2, [fp, #-3886]!	; 0xfffff0d2
     360:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     364:	636e692f 	cmnvs	lr, #770048	; 0xbc000
     368:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
     36c:	616f622f 	cmnvs	pc, pc, lsr #4
     370:	722f6472 	eorvc	r6, pc, #1912602624	; 0x72000000
     374:	2f306970 	svccs	0x00306970
     378:	006c6168 	rsbeq	r6, ip, r8, ror #2
     37c:	69616d00 	stmdbvs	r1!, {r8, sl, fp, sp, lr}^
     380:	70632e6e 	rsbvc	r2, r3, lr, ror #28
     384:	00010070 	andeq	r0, r1, r0, ror r0
     388:	69777300 	ldmdbvs	r7!, {r8, r9, ip, sp, lr}^
     38c:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
     390:	70730000 	rsbsvc	r0, r3, r0
     394:	6f6c6e69 	svcvs	0x006c6e69
     398:	682e6b63 	stmdavs	lr!, {r0, r1, r5, r6, r8, r9, fp, sp, lr}
     39c:	00000200 	andeq	r0, r0, r0, lsl #4
     3a0:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     3a4:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     3a8:	682e6d65 	stmdavs	lr!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}
     3ac:	00000300 	andeq	r0, r0, r0, lsl #6
     3b0:	636f7270 	cmnvs	pc, #112, 4
     3b4:	2e737365 	cdpcs	3, 7, cr7, cr3, cr5, {3}
     3b8:	00020068 	andeq	r0, r2, r8, rrx
     3bc:	6f727000 	svcvs	0x00727000
     3c0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     3c4:	6e616d5f 	mcrvs	13, 3, r6, cr1, cr15, {2}
     3c8:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     3cc:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
     3d0:	69630000 	stmdbvs	r3!, {}^	; <UNPREDICTABLE>
     3d4:	6c756372 	ldclvs	3, cr6, [r5], #-456	; 0xfffffe38
     3d8:	75427261 	strbvc	r7, [r2, #-609]	; 0xfffffd9f
     3dc:	72656666 	rsbvc	r6, r5, #106954752	; 0x6600000
     3e0:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
     3e4:	65720000 	ldrbvs	r0, [r2, #-0]!
     3e8:	74556461 	ldrbvc	r6, [r5], #-1121	; 0xfffffb9f
     3ec:	2e736c69 	cdpcs	12, 7, cr6, cr3, cr9, {3}
     3f0:	00040068 	andeq	r0, r4, r8, rrx
     3f4:	72617500 	rsbvc	r7, r1, #0, 10
     3f8:	65645f74 	strbvs	r5, [r4, #-3956]!	; 0xfffff08c
     3fc:	682e7366 	stmdavs	lr!, {r1, r2, r5, r6, r8, r9, ip, sp, lr}
     400:	00000500 	andeq	r0, r0, r0, lsl #10
     404:	64746e69 	ldrbtvs	r6, [r4], #-3689	; 0xfffff197
     408:	682e6665 	stmdavs	lr!, {r0, r2, r5, r6, r9, sl, sp, lr}
     40c:	00000600 	andeq	r0, r0, r0, lsl #12
     410:	00180500 	andseq	r0, r8, r0, lsl #10
     414:	82300205 	eorshi	r0, r0, #1342177280	; 0x50000000
     418:	35030000 	strcc	r0, [r3, #-0]
     41c:	9f020501 	svcls	0x00020501
     420:	02001e05 	andeq	r1, r0, #5, 28	; 0x50
     424:	05660104 	strbeq	r0, [r6, #-260]!	; 0xfffffefc
     428:	2305bb07 	movwcs	fp, #23303	; 0x5b07
     42c:	01040200 	mrseq	r0, R12_usr
     430:	bb070566 	bllt	1c19d0 <__bss_end+0x1b6098>
     434:	02002305 	andeq	r2, r0, #335544320	; 0x14000000
     438:	05660104 	strbeq	r0, [r6, #-260]!	; 0xfffffefc
     43c:	2305bb07 	movwcs	fp, #23303	; 0x5b07
     440:	01040200 	mrseq	r0, R12_usr
     444:	bb070566 	bllt	1c19e4 <__bss_end+0x1b60ac>
     448:	02002305 	andeq	r2, r0, #335544320	; 0x14000000
     44c:	05660104 	strbeq	r0, [r6, #-260]!	; 0xfffffefc
     450:	0105bb0e 	tsteq	r5, lr, lsl #22
     454:	0826054b 	stmdaeq	r6!, {r0, r1, r3, r6, r8, sl}
     458:	bb020522 	bllt	818e8 <__bss_end+0x75fb0>
     45c:	02001905 	andeq	r1, r0, #81920	; 0x14000
     460:	05660104 	strbeq	r0, [r6, #-260]!	; 0xfffffefc
     464:	1e05d707 	cdpne	7, 0, cr13, cr5, cr7, {0}
     468:	01040200 	mrseq	r0, R12_usr
     46c:	d7070566 	strle	r0, [r7, -r6, ror #10]
     470:	02001e05 	andeq	r1, r0, #5, 28	; 0x50
     474:	05660104 	strbeq	r0, [r6, #-260]!	; 0xfffffefc
     478:	1e05d707 	cdpne	7, 0, cr13, cr5, cr7, {0}
     47c:	01040200 	mrseq	r0, R12_usr
     480:	d7070566 	strle	r0, [r7, -r6, ror #10]
     484:	02001e05 	andeq	r1, r0, #5, 28	; 0x50
     488:	05660104 	strbeq	r0, [r6, #-260]!	; 0xfffffefc
     48c:	0105d707 	tsteq	r5, r7, lsl #14
     490:	f52f052f 			; <UNDEFINED> instruction: 0xf52f052f
     494:	059f0f05 	ldreq	r0, [pc, #3845]	; 13a1 <shift+0x13a1>
     498:	0402001e 	streq	r0, [r2], #-30	; 0xffffffe2
     49c:	18054a01 	stmdane	r5, {r0, r9, fp, lr}
     4a0:	01040200 	mrseq	r0, R12_usr
     4a4:	670e054a 	strvs	r0, [lr, -sl, asr #10]
     4a8:	05820305 	streq	r0, [r2, #773]	; 0x305
     4ac:	04020024 	streq	r0, [r2], #-36	; 0xffffffdc
     4b0:	17054a01 	strne	r4, [r5, -r1, lsl #20]
     4b4:	01040200 	mrseq	r0, R12_usr
     4b8:	003a059e 	mlaseq	sl, lr, r5, r0
     4bc:	4a020402 	bmi	814cc <__bss_end+0x75b94>
     4c0:	02002d05 	andeq	r2, r0, #320	; 0x140
     4c4:	059e0204 	ldreq	r0, [lr, #516]	; 0x204
     4c8:	04020050 	streq	r0, [r2], #-80	; 0xffffffb0
     4cc:	43054a03 	movwmi	r4, #23043	; 0x5a03
     4d0:	03040200 	movweq	r0, #16896	; 0x4200
     4d4:	4b0b059e 	blmi	2c1b54 <__bss_end+0x2b621c>
     4d8:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
     4dc:	05480204 	strbeq	r0, [r8, #-516]	; 0xfffffdfc
     4e0:	01058609 	tsteq	r5, r9, lsl #12
     4e4:	8537052f 	ldrhi	r0, [r7, #-1327]!	; 0xfffffad1
     4e8:	05bc0705 	ldreq	r0, [ip, #1797]!	; 0x705
     4ec:	0705681a 	smladeq	r5, sl, r8, r6
     4f0:	bb0205d9 	bllt	81c5c <__bss_end+0x76324>
     4f4:	05680b05 	strbeq	r0, [r8, #-2821]!	; 0xfffff4fb
     4f8:	0205bc11 	andeq	fp, r5, #4352	; 0x1100
     4fc:	00250582 	eoreq	r0, r5, r2, lsl #11
     500:	4a010402 	bmi	41510 <__bss_end+0x35bd8>
     504:	05670105 	strbeq	r0, [r7, #-261]!	; 0xfffffefb
     508:	0905f51c 	stmdbeq	r5, {r2, r3, r4, r8, sl, ip, sp, lr, pc}
     50c:	000e0584 	andeq	r0, lr, r4, lsl #11
     510:	4a030402 	bmi	c1520 <__bss_end+0xb5be8>
     514:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
     518:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     51c:	04020002 	streq	r0, [r2], #-2
     520:	0b054a02 	bleq	152d30 <__bss_end+0x1473f8>
     524:	67010584 	strvs	r0, [r1, -r4, lsl #11]
     528:	05852305 	streq	r2, [r5, #773]	; 0x305
     52c:	1b058315 	blne	161188 <__bss_end+0x155850>
     530:	2f070566 	svccs	0x00070566
     534:	054c0b05 	strbeq	r0, [ip, #-2821]	; 0xfffff4fb
     538:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
     53c:	0d054a01 	vstreq	s8, [r5, #-4]
     540:	2e0e0583 	cfsh32cs	mvfx0, mvfx14, #-61
     544:	054a0505 	strbeq	r0, [sl, #-1285]	; 0xfffffafb
     548:	056a4c03 	strbeq	r4, [sl, #-3075]!	; 0xfffff3fd
     54c:	04020010 	streq	r0, [r2], #-16
     550:	08056601 	stmdaeq	r5, {r0, r9, sl, sp, lr}
     554:	66040567 	strvs	r0, [r4], -r7, ror #10
     558:	054b0c05 	strbeq	r0, [fp, #-3077]	; 0xfffff3fb
     55c:	03054b0a 	movweq	r4, #23306	; 0x5b0a
     560:	0013054d 	andseq	r0, r3, sp, asr #10
     564:	66020402 	strvs	r0, [r2], -r2, lsl #8
     568:	02002005 	andeq	r2, r0, #5
     56c:	05660304 	strbeq	r0, [r6, #-772]!	; 0xfffffcfc
     570:	04020007 	streq	r0, [r2], #-7
     574:	0b056604 	bleq	159d8c <__bss_end+0x14e454>
     578:	00020567 	andeq	r0, r2, r7, ror #10
     57c:	03020402 	movweq	r0, #9218	; 0x2402
     580:	04054a72 	streq	r4, [r5], #-2674	; 0xfffff58e
     584:	03020586 	movweq	r0, #9606	; 0x2586
     588:	13052e0c 	movwne	r2, #24076	; 0x5e0c
     58c:	01040200 	mrseq	r0, R12_usr
     590:	4b0e0566 	blmi	381b30 <__bss_end+0x3761f8>
     594:	052f0105 	streq	r0, [pc, #-261]!	; 497 <shift+0x497>
     598:	32056a13 	andcc	r6, r5, #77824	; 0x13000
     59c:	69080567 	stmdbvs	r8, {r0, r1, r2, r5, r6, r8, sl}
     5a0:	05670d05 	strbeq	r0, [r7, #-3333]!	; 0xfffff2fb
     5a4:	0305671b 	movweq	r6, #22299	; 0x571b
     5a8:	000e0569 	andeq	r0, lr, r9, ror #10
     5ac:	66010402 	strvs	r0, [r1], -r2, lsl #8
     5b0:	05671005 	strbeq	r1, [r7, #-5]!
     5b4:	0405820a 	streq	r8, [r5], #-522	; 0xfffffdf6
     5b8:	001b054b 	andseq	r0, fp, fp, asr #10
     5bc:	66010402 	strvs	r0, [r1], -r2, lsl #8
     5c0:	02001305 	andeq	r1, r0, #335544320	; 0x14000000
     5c4:	059e0104 	ldreq	r0, [lr, #260]	; 0x104
     5c8:	28054c1a 	stmdacs	r5, {r1, r3, r4, sl, fp, lr}
     5cc:	661005ba 			; <UNDEFINED> instruction: 0x661005ba
     5d0:	054d3505 	strbeq	r3, [sp, #-1285]	; 0xfffffafb
     5d4:	09056708 	stmdbeq	r5, {r3, r8, r9, sl, sp, lr}
     5d8:	bbba0903 	bllt	fee829ec <__bss_end+0xfee770b4>
     5dc:	bd0405bb 	cfstr32lt	mvfx0, [r4, #-748]	; 0xfffffd14
     5e0:	05321005 	ldreq	r1, [r2, #-5]!
     5e4:	02054b12 	andeq	r4, r5, #18432	; 0x4800
     5e8:	310805bc 			; <UNDEFINED> instruction: 0x310805bc
     5ec:	05670d05 	strbeq	r0, [r7, #-3333]!	; 0xfffff2fb
     5f0:	0305671b 	movweq	r6, #22299	; 0x571b
     5f4:	000e0569 	andeq	r0, lr, r9, ror #10
     5f8:	66010402 	strvs	r0, [r1], -r2, lsl #8
     5fc:	05670f05 	strbeq	r0, [r7, #-3845]!	; 0xfffff0fb
     600:	04058209 	streq	r8, [r5], #-521	; 0xfffffdf7
     604:	001b054b 	andseq	r0, fp, fp, asr #10
     608:	66010402 	strvs	r0, [r1], -r2, lsl #8
     60c:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
     610:	059e0104 	ldreq	r0, [lr, #260]	; 0x104
     614:	09054c33 	stmdbeq	r5, {r0, r1, r4, r5, sl, fp, lr}
     618:	67080567 	strvs	r0, [r8, -r7, ror #10]
     61c:	0a030905 	beq	c2a38 <__bss_end+0xb7100>
     620:	05bbbbba 	ldreq	fp, [fp, #3002]!	; 0xbba
     624:	1005bc04 	andne	fp, r5, r4, lsl #24
     628:	4b120532 	blmi	481af8 <__bss_end+0x4761c0>
     62c:	05bc0205 	ldreq	r0, [ip, #517]!	; 0x205
     630:	17052f01 	strne	r2, [r5, -r1, lsl #30]
     634:	2e05e708 	cdpcs	7, 0, cr14, cr5, cr8, {0}
     638:	67070568 	strvs	r0, [r7, -r8, ror #10]
     63c:	05670c05 	strbeq	r0, [r7, #-3077]!	; 0xfffff3fb
     640:	02056812 	andeq	r6, r5, #1179648	; 0x120000
     644:	4b0a0582 	blmi	281c54 <__bss_end+0x27631c>
     648:	054b0705 	strbeq	r0, [fp, #-1797]	; 0xfffff8fb
     64c:	1605830a 	strne	r8, [r5], -sl, lsl #6
     650:	6622054b 	strtvs	r0, [r2], -fp, asr #10
     654:	05820705 	streq	r0, [r2, #1797]	; 0x705
     658:	0e054b0a 	vmlaeq.f64	d4, d5, d10
     65c:	6914054d 	ldmdbvs	r4, {r0, r2, r3, r6, r8, sl}
     660:	05ba1605 	ldreq	r1, [sl, #1541]!	; 0x605
     664:	12054b0d 	andne	r4, r5, #13312	; 0x3400
     668:	820205a1 	andhi	r0, r2, #675282944	; 0x28400000
     66c:	054b0c05 	strbeq	r0, [fp, #-3077]	; 0xfffff3fb
     670:	19059f33 	stmdbne	r5, {r0, r1, r4, r5, r8, r9, sl, fp, ip, pc}
     674:	660805bb 			; <UNDEFINED> instruction: 0x660805bb
     678:	05670c05 	strbeq	r0, [r7, #-3077]!	; 0xfffff3fb
     67c:	04020020 	streq	r0, [r2], #-32	; 0xffffffe0
     680:	13054a03 	movwne	r4, #23043	; 0x5a03
     684:	03040200 	movweq	r0, #16896	; 0x4200
     688:	00150566 	andseq	r0, r5, r6, ror #10
     68c:	2e030402 	cdpcs	4, 0, cr0, cr3, cr2, {0}
     690:	02001805 	andeq	r1, r0, #327680	; 0x50000
     694:	054b0204 	strbeq	r0, [fp, #-516]	; 0xfffffdfc
     698:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
     69c:	18054a02 	stmdane	r5, {r1, r9, fp, lr}
     6a0:	02040200 	andeq	r0, r4, #0, 4
     6a4:	000b052e 	andeq	r0, fp, lr, lsr #10
     6a8:	4a020402 	bmi	816b8 <__bss_end+0x75d80>
     6ac:	02000c05 	andeq	r0, r0, #1280	; 0x500
     6b0:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     6b4:	04020018 	streq	r0, [r2], #-24	; 0xffffffe8
     6b8:	0e056602 	cfmadd32eq	mvax0, mvfx6, mvfx5, mvfx2
     6bc:	02040200 	andeq	r0, r4, #0, 4
     6c0:	0003052e 	andeq	r0, r3, lr, lsr #10
     6c4:	2d020402 	cfstrscs	mvf0, [r2, #-8]
     6c8:	05850a05 	streq	r0, [r5, #2565]	; 0xa05
     6cc:	01056909 	tsteq	r5, r9, lsl #18
     6d0:	f53b052f 			; <UNDEFINED> instruction: 0xf53b052f
     6d4:	83d70805 	bicshi	r0, r7, #327680	; 0x50000
     6d8:	83140567 	tsthi	r4, #432013312	; 0x19c00000
     6dc:	05662305 	strbeq	r2, [r6, #-773]!	; 0xfffffcfb
     6e0:	09056608 	stmdbeq	r5, {r3, r9, sl, sp, lr}
     6e4:	4b01054c 	blmi	41c1c <__bss_end+0x362e4>
     6e8:	05bd5d05 	ldreq	r5, [sp, #3333]!	; 0xd05
     6ec:	05590814 	ldrbeq	r0, [r9, #-2068]	; 0xfffff7ec
     6f0:	1705bb0c 	strne	fp, [r5, -ip, lsl #22]
     6f4:	66220566 	strtvs	r0, [r2], -r6, ror #10
     6f8:	05661c05 	strbeq	r1, [r6, #-3077]!	; 0xfffff3fb
     6fc:	2e052e12 	mcrcs	14, 0, r2, cr5, cr2, {0}
     700:	4b01052e 	blmi	41bc0 <__bss_end+0x36288>
     704:	056a2605 	strbeq	r2, [sl, #-1541]!	; 0xfffff9fb
     708:	07059f2c 	streq	r9, [r5, -ip, lsr #30]
     70c:	68060567 	stmdavs	r6, {r0, r1, r2, r5, r6, r8, sl}
     710:	05bc3005 	ldreq	r3, [ip, #5]!
     714:	18054a0c 	stmdane	r5, {r2, r3, r9, fp, lr}
     718:	4a1e054c 	bmi	781c50 <__bss_end+0x776318>
     71c:	05661805 	strbeq	r1, [r6, #-2053]!	; 0xfffff7fb
     720:	1305820c 	movwne	r8, #21004	; 0x520c
     724:	4a15054c 	bmi	541c5c <__bss_end+0x536324>
     728:	052e1305 	streq	r1, [lr, #-773]!	; 0xfffffcfb
     72c:	1e052f01 	cdpne	15, 0, cr2, cr5, cr1, {0}
     730:	070583a1 	streq	r8, [r5, -r1, lsr #7]
     734:	9f1e0582 	svcls	0x001e0582
     738:	05820705 	streq	r0, [r2, #1797]	; 0x705
     73c:	07059f1e 	smladeq	r5, lr, pc, r9	; <UNPREDICTABLE>
     740:	9f1e0582 	svcls	0x001e0582
     744:	05820705 	streq	r0, [r2, #1797]	; 0x705
     748:	07059f1e 	smladeq	r5, lr, pc, r9	; <UNPREDICTABLE>
     74c:	9f010582 	svcls	0x00010582
     750:	05693705 	strbeq	r3, [r9, #-1797]!	; 0xfffff8fb
     754:	6767d708 	strbvs	sp, [r7, -r8, lsl #14]!
     758:	0e056767 	cdpeq	7, 0, cr6, cr5, cr7, {3}
     75c:	08010567 	stmdaeq	r1, {r0, r1, r2, r5, r6, r8, sl}
     760:	69220591 	stmdbvs	r2!, {r0, r4, r7, r8, sl}
     764:	059f0805 	ldreq	r0, [pc, #2053]	; f71 <shift+0xf71>
     768:	1c054d14 	stcne	13, cr4, [r5], {20}
     76c:	2e0b05f2 	mcrcs	5, 0, r0, cr11, cr2, {7}
     770:	02002105 	andeq	r2, r0, #1073741825	; 0x40000001
     774:	052e0304 	streq	r0, [lr, #-772]!	; 0xfffffcfc
     778:	04020023 	streq	r0, [r2], #-35	; 0xffffffdd
     77c:	15052e03 	strne	r2, [r5, #-3587]	; 0xfffff1fd
     780:	02040200 	andeq	r0, r4, #0, 4
     784:	00170584 	andseq	r0, r7, r4, lsl #11
     788:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
     78c:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
     790:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
     794:	04020039 	streq	r0, [r2], #-57	; 0xffffffc7
     798:	27052e02 	strcs	r2, [r5, -r2, lsl #28]
     79c:	02040200 	andeq	r0, r4, #0, 4
     7a0:	0031054a 	eorseq	r0, r1, sl, asr #10
     7a4:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
     7a8:	02002905 	andeq	r2, r0, #81920	; 0x14000
     7ac:	05f20204 	ldrbeq	r0, [r2, #516]!	; 0x204
     7b0:	04020039 	streq	r0, [r2], #-57	; 0xffffffc7
     7b4:	14052e02 	strne	r2, [r5], #-3586	; 0xfffff1fe
     7b8:	02040200 	andeq	r0, r4, #0, 4
     7bc:	0059054a 	subseq	r0, r9, sl, asr #10
     7c0:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
     7c4:	02004905 	andeq	r4, r0, #81920	; 0x14000
     7c8:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     7cc:	04020051 	streq	r0, [r2], #-81	; 0xffffffaf
     7d0:	49052e02 	stmdbmi	r5, {r1, r9, sl, fp, sp}
     7d4:	02040200 	andeq	r0, r4, #0, 4
     7d8:	005905f2 	ldrsheq	r0, [r9], #-82	; 0xffffffae
     7dc:	4a020402 	bmi	817ec <__bss_end+0x75eb4>
     7e0:	02001405 	andeq	r1, r0, #83886080	; 0x5000000
     7e4:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     7e8:	04020016 	streq	r0, [r2], #-22	; 0xffffffea
     7ec:	1505d702 	strne	sp, [r5, #-1794]	; 0xfffff8fe
     7f0:	02040200 	andeq	r0, r4, #0, 4
     7f4:	0016054a 	andseq	r0, r6, sl, asr #10
     7f8:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
     7fc:	02000c05 	andeq	r0, r0, #1280	; 0x500
     800:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     804:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
     808:	2e054c02 	cdpcs	12, 0, cr4, cr5, cr2, {0}
     80c:	02040200 	andeq	r0, r4, #0, 4
     810:	00220566 	eoreq	r0, r2, r6, ror #10
     814:	66020402 	strvs	r0, [r2], -r2, lsl #8
     818:	02000705 	andeq	r0, r0, #1310720	; 0x140000
     81c:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     820:	04020002 	streq	r0, [r2], #-2
     824:	09056102 	stmdbeq	r5, {r1, r8, sp, lr}
     828:	4b010589 	blmi	41e54 <__bss_end+0x3651c>
     82c:	05f50f05 	ldrbeq	r0, [r5, #3845]!	; 0xf05
     830:	1b058311 	blne	16147c <__bss_end+0x155b44>
     834:	f2240586 	vrshl.s32	d0, d6, d20
     838:	052e1205 	streq	r1, [lr, #-517]!	; 0xfffffdfb
     83c:	0e054a02 	vmlaeq.f32	s8, s10, s4
     840:	bb0b054b 	bllt	2c1d74 <__bss_end+0x2b643c>
     844:	054e1705 	strbeq	r1, [lr, #-1797]	; 0xfffff8fb
     848:	2d056624 	stccs	6, cr6, [r5, #-144]	; 0xffffff70
     84c:	2e0705f2 	mcrcs	5, 0, r0, cr7, cr2, {7}
     850:	054b0c05 	strbeq	r0, [fp, #-3077]	; 0xfffff3fb
     854:	04020013 	streq	r0, [r2], #-19	; 0xffffffed
     858:	15054a03 	strne	r4, [r5, #-2563]	; 0xfffff5fd
     85c:	03040200 	movweq	r0, #16896	; 0x4200
     860:	0010052e 	andseq	r0, r0, lr, lsr #10
     864:	4b020402 	blmi	81874 <__bss_end+0x75f3c>
     868:	02000305 	andeq	r0, r0, #335544320	; 0x14000000
     86c:	05490204 	strbeq	r0, [r9, #-516]	; 0xfffffdfc
     870:	0905890e 	stmdbeq	r5, {r1, r2, r3, r8, fp, pc}
     874:	2f0e0582 	svccs	0x000e0582
     878:	05820905 	streq	r0, [r2, #2309]	; 0x905
     87c:	09052f0e 	stmdbeq	r5, {r1, r2, r3, r8, r9, sl, fp, sp}
     880:	2f0e0582 	svccs	0x000e0582
     884:	05820905 	streq	r0, [r2, #2309]	; 0x905
     888:	09052f0e 	stmdbeq	r5, {r1, r2, r3, r8, r9, sl, fp, sp}
     88c:	2f140582 	svccs	0x00140582
     890:	05840b05 	streq	r0, [r4, #2821]	; 0xb05
     894:	04020012 	streq	r0, [r2], #-18	; 0xffffffee
     898:	14054a01 	strne	r4, [r5], #-2561	; 0xfffff5ff
     89c:	01040200 	mrseq	r0, R12_usr
     8a0:	4c1e052e 	cfldr32mi	mvfx0, [lr], {46}	; 0x2e
     8a4:	05841005 	streq	r1, [r4, #5]
     8a8:	1005820b 	andne	r8, r5, fp, lsl #4
     8ac:	820b052f 	andhi	r0, fp, #197132288	; 0xbc00000
     8b0:	052f1005 	streq	r1, [pc, #-5]!	; 8b3 <shift+0x8b3>
     8b4:	1005820b 	andne	r8, r5, fp, lsl #4
     8b8:	820b052f 	andhi	r0, fp, #197132288	; 0xbc00000
     8bc:	052f1005 	streq	r1, [pc, #-5]!	; 8bf <shift+0x8bf>
     8c0:	1905820b 	stmdbne	r5, {r0, r1, r3, r9, pc}
     8c4:	850c052f 	strhi	r0, [ip, #-1327]	; 0xfffffad1
     8c8:	02001305 	andeq	r1, r0, #335544320	; 0x14000000
     8cc:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     8d0:	04020015 	streq	r0, [r2], #-21	; 0xffffffeb
     8d4:	11052e02 	tstne	r5, r2, lsl #28
     8d8:	820c054c 	andhi	r0, ip, #76, 10	; 0x13000000
     8dc:	052f1105 	streq	r1, [pc, #-261]!	; 7df <shift+0x7df>
     8e0:	1105820c 	tstne	r5, ip, lsl #4
     8e4:	820c052f 	andhi	r0, ip, #197132288	; 0xbc00000
     8e8:	052f1105 	streq	r1, [pc, #-261]!	; 7eb <shift+0x7eb>
     8ec:	1105820c 	tstne	r5, ip, lsl #4
     8f0:	820c052f 	andhi	r0, ip, #197132288	; 0xbc00000
     8f4:	05301505 	ldreq	r1, [r0, #-1285]!	; 0xfffffafb
     8f8:	11058404 	tstne	r5, r4, lsl #8
     8fc:	6909059f 	stmdbvs	r9, {r0, r1, r2, r3, r4, r7, r8, sl}
     900:	059f0a05 	ldreq	r0, [pc, #2565]	; 130d <shift+0x130d>
     904:	10054b12 	andne	r4, r5, r2, lsl fp
     908:	4b0e052e 	blmi	381dc8 <__bss_end+0x376490>
     90c:	02001705 	andeq	r1, r0, #1310720	; 0x140000
     910:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     914:	04020013 	streq	r0, [r2], #-19	; 0xffffffed
     918:	12056702 	andne	r6, r5, #524288	; 0x80000
     91c:	02040200 	andeq	r0, r4, #0, 4
     920:	0013054a 	andseq	r0, r3, sl, asr #10
     924:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
     928:	02001a05 	andeq	r1, r0, #20480	; 0x5000
     92c:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     930:	04020015 	streq	r0, [r2], #-21	; 0xffffffeb
     934:	05058202 	streq	r8, [r5, #-514]	; 0xfffffdfe
     938:	02040200 	andeq	r0, r4, #0, 4
     93c:	0003052d 	andeq	r0, r3, sp, lsr #10
     940:	03010402 	movweq	r0, #5122	; 0x1402
     944:	1d05826f 	sfmne	f0, 1, [r5, #-444]	; 0xfffffe44
     948:	05821803 	streq	r1, [r2, #2051]	; 0x803
     94c:	38056610 	stmdacc	r5, {r4, r9, sl, sp, lr}
     950:	d610052e 	ldrle	r0, [r0], -lr, lsr #10
     954:	052e5105 	streq	r5, [lr, #-261]!	; 0xfffffefb
     958:	0c05d610 	stceq	6, cr13, [r5], {16}
     95c:	001305f5 			; <UNDEFINED> instruction: 0x001305f5
     960:	4a010402 	bmi	41970 <__bss_end+0x36038>
     964:	02001505 	andeq	r1, r0, #20971520	; 0x1400000
     968:	052e0104 	streq	r0, [lr, #-260]!	; 0xfffffefc
     96c:	24054d0d 	strcs	r4, [r5], #-3341	; 0xfffff2f3
     970:	03040200 	movweq	r0, #16896	; 0x4200
     974:	0016054a 	andseq	r0, r6, sl, asr #10
     978:	82030402 	andhi	r0, r3, #33554432	; 0x2000000
     97c:	02001905 	andeq	r1, r0, #81920	; 0x14000
     980:	05d80204 	ldrbeq	r0, [r8, #516]	; 0x204
     984:	0402000a 	streq	r0, [r2], #-10
     988:	04058302 	streq	r8, [r5], #-770	; 0xfffffcfe
     98c:	02040200 	andeq	r0, r4, #0, 4
     990:	03057108 	movweq	r7, #20744	; 0x5108
     994:	02040200 	andeq	r0, r4, #0, 4
     998:	030c057f 	movweq	r0, #50559	; 0xc57f
     99c:	1305820b 	movwne	r8, #21003	; 0x520b
     9a0:	01040200 	mrseq	r0, R12_usr
     9a4:	0015054a 	andseq	r0, r5, sl, asr #10
     9a8:	2e010402 	cdpcs	4, 0, cr0, cr1, cr2, {0}
     9ac:	054c1405 	strbeq	r1, [ip, #-1029]	; 0xfffffbfb
     9b0:	0405821d 	streq	r8, [r5], #-541	; 0xfffffde3
     9b4:	4c170582 	cfldr32mi	mvfx0, [r7], {130}	; 0x82
     9b8:	05f23c05 	ldrbeq	r3, [r2, #3077]!	; 0xc05
     9bc:	5d05822e 	sfmpl	f0, 1, [r5, #-184]	; 0xffffff48
     9c0:	4b0a052e 	blmi	281e80 <__bss_end+0x276548>
     9c4:	02000305 	andeq	r0, r0, #335544320	; 0x14000000
     9c8:	05ed0204 	strbeq	r0, [sp, #516]!	; 0x204
     9cc:	820b030d 	andhi	r0, fp, #872415232	; 0x34000000
     9d0:	05671205 	strbeq	r1, [r7, #-517]!	; 0xfffffdfb
     9d4:	1e058203 	cdpne	2, 0, cr8, cr5, cr3, {0}
     9d8:	6611054b 	ldrvs	r0, [r1], -fp, asr #10
     9dc:	052e3905 	streq	r3, [lr, #-2309]!	; 0xfffff6fb
     9e0:	5205d611 	andpl	sp, r5, #17825792	; 0x1100000
     9e4:	d611052e 	ldrle	r0, [r1], -lr, lsr #10
     9e8:	05f31005 	ldrbeq	r1, [r3, #5]!
     9ec:	02058316 	andeq	r8, r5, #1476395008	; 0x58000000
     9f0:	ba7fbf03 	blt	1ff0604 <__bss_end+0x1fe4ccc>
     9f4:	c8033105 	stmdagt	r3, {r0, r2, r8, ip, sp}
     9f8:	06058200 	streq	r8, [r5], -r0, lsl #4
     9fc:	67070567 	strvs	r0, [r7, -r7, ror #10]
     a00:	0905bbbb 	stmdbeq	r5, {r0, r1, r3, r4, r5, r7, r8, r9, fp, ip, sp, pc}
     a04:	000105bc 			; <UNDEFINED> instruction: 0x000105bc
     a08:	4b020402 	blmi	81a18 <__bss_end+0x760e0>
     a0c:	22021205 	andcs	r1, r2, #1342177280	; 0x50000000
     a10:	692b0515 	stmdbvs	fp!, {r0, r2, r4, r8, sl}
     a14:	67672c05 	strbvs	r2, [r7, -r5, lsl #24]!
     a18:	07056767 	streq	r6, [r5, -r7, ror #14]
     a1c:	67676768 	strbvs	r6, [r7, -r8, ror #14]!
     a20:	68060567 	stmdavs	r6, {r0, r1, r2, r5, r6, r8, sl}
     a24:	05bb1705 	ldreq	r1, [fp, #1797]!	; 0x705
     a28:	17056606 	strne	r6, [r5, -r6, lsl #12]
     a2c:	66060583 	strvs	r0, [r6], -r3, lsl #11
     a30:	05831705 	streq	r1, [r3, #1797]	; 0x705
     a34:	17056606 	strne	r6, [r5, -r6, lsl #12]
     a38:	66060583 	strvs	r0, [r6], -r3, lsl #11
     a3c:	bb840705 	bllt	fe102658 <__bss_end+0xfe0f6d20>
     a40:	bbbbbbbb 	bllt	feeef934 <__bss_end+0xfeee3ffc>
     a44:	bbbbbbbb 	bllt	feeef938 <__bss_end+0xfeee4000>
     a48:	bb0105bb 	bllt	4213c <__bss_end+0x36804>
     a4c:	07055d08 	streq	r5, [r5, -r8, lsl #26]
     a50:	110567a0 	smlatbne	r5, r0, r7, r6
     a54:	820b05a1 	andhi	r0, fp, #675282944	; 0x28400000
     a58:	054e1a05 	strbeq	r1, [lr, #-2565]	; 0xfffff5fb
     a5c:	0c054b0a 			; <UNDEFINED> instruction: 0x0c054b0a
     a60:	820605bd 	andhi	r0, r6, #792723456	; 0x2f400000
     a64:	694b0e05 	stmdbvs	fp, {r0, r2, r9, sl, fp}^
     a68:	054b0705 	strbeq	r0, [fp, #-1797]	; 0xfffff8fb
     a6c:	0e05be0c 	cdpeq	14, 0, cr11, cr5, cr12, {0}
     a70:	4b0a0531 	blmi	281f3c <__bss_end+0x276604>
     a74:	05be1b05 	ldreq	r1, [lr, #2821]!	; 0xb05
     a78:	08054d03 	stmdaeq	r5, {r0, r1, r8, sl, fp, lr}
     a7c:	670e0568 	strvs	r0, [lr, -r8, ror #10]
     a80:	054c0805 	strbeq	r0, [ip, #-2053]	; 0xfffff7fb
     a84:	09056710 	stmdbeq	r5, {r4, r8, r9, sl, sp, lr}
     a88:	bb04054b 	bllt	101fbc <__bss_end+0xf6684>
     a8c:	05311205 	ldreq	r1, [r1, #-517]!	; 0xfffffdfb
     a90:	09054e08 	stmdbeq	r5, {r3, r9, sl, fp, lr}
     a94:	1205bb69 	andne	fp, r5, #107520	; 0x1a400
     a98:	bd0e05bb 	cfstr32lt	mvfx0, [lr, #-748]	; 0xfffffd14
     a9c:	052f0905 	streq	r0, [pc, #-2309]!	; 19f <shift+0x19f>
     aa0:	0905bd03 	stmdbeq	r5, {r0, r1, r8, sl, fp, ip, sp, pc}
     aa4:	bb0b0583 	bllt	2c20b8 <__bss_end+0x2b6780>
     aa8:	054c0205 	strbeq	r0, [ip, #-517]	; 0xfffffdfb
     aac:	2e620304 	cdpcs	3, 6, cr0, cr2, cr4, {0}
     ab0:	1f030105 	svcne	0x00030105
     ab4:	1222022e 	eorne	r0, r2, #-536870910	; 0xe0000002
     ab8:	0402009e 	streq	r0, [r2], #-158	; 0xffffff62
     abc:	05660601 	strbeq	r0, [r6, #-1537]!	; 0xfffff9ff
     ac0:	86030630 			; <UNDEFINED> instruction: 0x86030630
     ac4:	0805827c 	stmdaeq	r5, {r2, r3, r4, r5, r6, r9, pc}
     ac8:	030c0566 	movweq	r0, #50534	; 0xc566
     acc:	35054a15 	strcc	r4, [r5, #-2581]	; 0xfffff5eb
     ad0:	66080552 			; <UNDEFINED> instruction: 0x66080552
     ad4:	054c3905 	strbeq	r3, [ip, #-2309]	; 0xfffff6fb
     ad8:	01056608 	tsteq	r5, r8, lsl #12
     adc:	4a03db03 	bmi	f76f0 <__bss_end+0xebdb8>
     ae0:	0a024af2 	beq	936b0 <__bss_end+0x87d78>
     ae4:	7c010100 	stfvcs	f0, [r1], {-0}
     ae8:	03000002 	movweq	r0, #2
     aec:	00014900 	andeq	r4, r1, r0, lsl #18
     af0:	fb010200 	blx	412fa <__bss_end+0x359c2>
     af4:	01000d0e 	tsteq	r0, lr, lsl #26
     af8:	00010101 	andeq	r0, r1, r1, lsl #2
     afc:	00010000 	andeq	r0, r1, r0
     b00:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
     b04:	2f656d6f 	svccs	0x00656d6f
     b08:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
     b0c:	2f6a6b6e 	svccs	0x006a6b6e
     b10:	3032736f 	eorscc	r7, r2, pc, ror #6
     b14:	732f3232 			; <UNDEFINED> instruction: 0x732f3232
     b18:	6f732f70 	svcvs	0x00732f70
     b1c:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     b20:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
     b24:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
     b28:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     b2c:	6f682f00 	svcvs	0x00682f00
     b30:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
     b34:	6e656863 	cdpvs	8, 6, cr6, cr5, cr3, {3}
     b38:	6f2f6a6b 	svcvs	0x002f6a6b
     b3c:	32303273 	eorscc	r3, r0, #805306375	; 0x30000007
     b40:	70732f32 	rsbsvc	r2, r3, r2, lsr pc
     b44:	756f732f 	strbvc	r7, [pc, #-815]!	; 81d <shift+0x81d>
     b48:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     b4c:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     b50:	2f6c656e 	svccs	0x006c656e
     b54:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     b58:	2f656475 	svccs	0x00656475
     b5c:	636f7270 	cmnvs	pc, #112, 4
     b60:	00737365 	rsbseq	r7, r3, r5, ror #6
     b64:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ab0 <shift+0xab0>
     b68:	63732f65 	cmnvs	r3, #404	; 0x194
     b6c:	6b6e6568 	blvs	1b9a114 <__bss_end+0x1b8e7dc>
     b70:	736f2f6a 	cmnvc	pc, #424	; 0x1a8
     b74:	32323032 	eorscc	r3, r2, #50	; 0x32
     b78:	2f70732f 	svccs	0x0070732f
     b7c:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     b80:	2f736563 	svccs	0x00736563
     b84:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
     b88:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
     b8c:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
     b90:	662f6564 	strtvs	r6, [pc], -r4, ror #10
     b94:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
     b98:	2f656d6f 	svccs	0x00656d6f
     b9c:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
     ba0:	2f6a6b6e 	svccs	0x006a6b6e
     ba4:	3032736f 	eorscc	r7, r2, pc, ror #6
     ba8:	732f3232 			; <UNDEFINED> instruction: 0x732f3232
     bac:	6f732f70 	svcvs	0x00732f70
     bb0:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     bb4:	656b2f73 	strbvs	r2, [fp, #-3955]!	; 0xfffff08d
     bb8:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
     bbc:	636e692f 	cmnvs	lr, #770048	; 0xbc000
     bc0:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
     bc4:	616f622f 	cmnvs	pc, pc, lsr #4
     bc8:	722f6472 	eorvc	r6, pc, #1912602624	; 0x72000000
     bcc:	2f306970 	svccs	0x00306970
     bd0:	006c6168 	rsbeq	r6, ip, r8, ror #2
     bd4:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
     bd8:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     bdc:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     be0:	00000100 	andeq	r0, r0, r0, lsl #2
     be4:	2e697773 	mcrcs	7, 3, r7, cr9, cr3, {3}
     be8:	00020068 	andeq	r0, r2, r8, rrx
     bec:	69707300 	ldmdbvs	r0!, {r8, r9, ip, sp, lr}^
     bf0:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
     bf4:	00682e6b 	rsbeq	r2, r8, fp, ror #28
     bf8:	66000002 	strvs	r0, [r0], -r2
     bfc:	73656c69 	cmnvc	r5, #26880	; 0x6900
     c00:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     c04:	00682e6d 	rsbeq	r2, r8, sp, ror #28
     c08:	70000003 	andvc	r0, r0, r3
     c0c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     c10:	682e7373 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, r9, ip, sp, lr}
     c14:	00000200 	andeq	r0, r0, r0, lsl #4
     c18:	636f7270 	cmnvs	pc, #112, 4
     c1c:	5f737365 	svcpl	0x00737365
     c20:	616e616d 	cmnvs	lr, sp, ror #2
     c24:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
     c28:	00020068 	andeq	r0, r2, r8, rrx
     c2c:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
     c30:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
     c34:	00040068 	andeq	r0, r4, r8, rrx
     c38:	01050000 	mrseq	r0, (UNDEF: 5)
     c3c:	60020500 	andvs	r0, r2, r0, lsl #10
     c40:	1600009b 			; <UNDEFINED> instruction: 0x1600009b
     c44:	05691a05 	strbeq	r1, [r9, #-2565]!	; 0xfffff5fb
     c48:	0c052f2c 	stceq	15, cr2, [r5], {44}	; 0x2c
     c4c:	2f01054c 	svccs	0x0001054c
     c50:	83320585 	teqhi	r2, #557842432	; 0x21400000
     c54:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
     c58:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     c5c:	01054b1a 	tsteq	r5, sl, lsl fp
     c60:	3205852f 	andcc	r8, r5, #197132288	; 0xbc00000
     c64:	4b2e05a1 	blmi	b822f0 <__bss_end+0xb769b8>
     c68:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
     c6c:	0c052f2d 	stceq	15, cr2, [r5], {45}	; 0x2d
     c70:	2f01054c 	svccs	0x0001054c
     c74:	bd2e0585 	cfstr32lt	mvfx0, [lr, #-532]!	; 0xfffffdec
     c78:	054b3005 	strbeq	r3, [fp, #-5]
     c7c:	1b054b2e 	blne	15393c <__bss_end+0x148004>
     c80:	2f2e054b 	svccs	0x002e054b
     c84:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
     c88:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     c8c:	3005bd2e 	andcc	fp, r5, lr, lsr #26
     c90:	4b2e054b 	blmi	b821c4 <__bss_end+0xb7688c>
     c94:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
     c98:	0c052f2e 	stceq	15, cr2, [r5], {46}	; 0x2e
     c9c:	2f01054c 	svccs	0x0001054c
     ca0:	832e0585 			; <UNDEFINED> instruction: 0x832e0585
     ca4:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
     ca8:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     cac:	3305bd2e 	movwcc	fp, #23854	; 0x5d2e
     cb0:	4b2f054b 	blmi	bc21e4 <__bss_end+0xbb68ac>
     cb4:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
     cb8:	0c052f30 	stceq	15, cr2, [r5], {48}	; 0x30
     cbc:	2f01054c 	svccs	0x0001054c
     cc0:	a12e0585 	smlawbge	lr, r5, r5, r0
     cc4:	054b2f05 	strbeq	r2, [fp, #-3845]	; 0xfffff0fb
     cc8:	2f054b1b 	svccs	0x00054b1b
     ccc:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
     cd0:	852f0105 	strhi	r0, [pc, #-261]!	; bd3 <shift+0xbd3>
     cd4:	05bd2e05 	ldreq	r2, [sp, #3589]!	; 0xe05
     cd8:	3b054b2f 	blcc	15399c <__bss_end+0x148064>
     cdc:	4b1b054b 	blmi	6c2210 <__bss_end+0x6b68d8>
     ce0:	052f3005 	streq	r3, [pc, #-5]!	; ce3 <shift+0xce3>
     ce4:	01054c0c 	tsteq	r5, ip, lsl #24
     ce8:	2f05852f 	svccs	0x0005852f
     cec:	4b3b05a1 	blmi	ec2378 <__bss_end+0xeb6a40>
     cf0:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
     cf4:	0c052f30 	stceq	15, cr2, [r5], {48}	; 0x30
     cf8:	9f01054c 	svcls	0x0001054c
     cfc:	67200585 	strvs	r0, [r0, -r5, lsl #11]!
     d00:	054d2d05 	strbeq	r2, [sp, #-3333]	; 0xfffff2fb
     d04:	1a054b31 	bne	1539d0 <__bss_end+0x148098>
     d08:	300c054b 	andcc	r0, ip, fp, asr #10
     d0c:	852f0105 	strhi	r0, [pc, #-261]!	; c0f <shift+0xc0f>
     d10:	05672005 	strbeq	r2, [r7, #-5]!
     d14:	31054d2d 	tstcc	r5, sp, lsr #26
     d18:	4b1a054b 	blmi	68224c <__bss_end+0x676914>
     d1c:	05300c05 	ldreq	r0, [r0, #-3077]!	; 0xfffff3fb
     d20:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     d24:	2d058320 	stccs	3, cr8, [r5, #-128]	; 0xffffff80
     d28:	4b3e054c 	blmi	f82260 <__bss_end+0xf76928>
     d2c:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
     d30:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
     d34:	2d056720 	stccs	7, cr6, [r5, #-128]	; 0xffffff80
     d38:	4b30054d 	blmi	c02274 <__bss_end+0xbf693c>
     d3c:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
     d40:	0105300c 	tsteq	r5, ip
     d44:	0c05872f 	stceq	7, cr8, [r5], {47}	; 0x2f
     d48:	31059fa0 	smlatbcc	r5, r0, pc, r9	; <UNPREDICTABLE>
     d4c:	662905bc 			; <UNDEFINED> instruction: 0x662905bc
     d50:	052e3605 	streq	r3, [lr, #-1541]!	; 0xfffff9fb
     d54:	1305300f 	movwne	r3, #20495	; 0x500f
     d58:	84090566 	strhi	r0, [r9], #-1382	; 0xfffffa9a
     d5c:	05d81005 	ldrbeq	r1, [r8, #5]
     d60:	08029f01 	stmdaeq	r2, {r0, r8, r9, sl, fp, ip, pc}
     d64:	bd010100 	stflts	f0, [r1, #-0]
     d68:	03000000 	movweq	r0, #0
     d6c:	00009600 	andeq	r9, r0, r0, lsl #12
     d70:	fb010200 	blx	4157a <__bss_end+0x35c42>
     d74:	01000d0e 	tsteq	r0, lr, lsl #26
     d78:	00010101 	andeq	r0, r1, r1, lsl #2
     d7c:	00010000 	andeq	r0, r1, r0
     d80:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
     d84:	2f656d6f 	svccs	0x00656d6f
     d88:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
     d8c:	2f6a6b6e 	svccs	0x006a6b6e
     d90:	3032736f 	eorscc	r7, r2, pc, ror #6
     d94:	732f3232 			; <UNDEFINED> instruction: 0x732f3232
     d98:	6f732f70 	svcvs	0x00732f70
     d9c:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     da0:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
     da4:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
     da8:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     dac:	6f682f00 	svcvs	0x00682f00
     db0:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
     db4:	6e656863 	cdpvs	8, 6, cr6, cr5, cr3, {3}
     db8:	6f2f6a6b 	svcvs	0x002f6a6b
     dbc:	32303273 	eorscc	r3, r0, #805306375	; 0x30000007
     dc0:	70732f32 	rsbsvc	r2, r3, r2, lsr pc
     dc4:	756f732f 	strbvc	r7, [pc, #-815]!	; a9d <shift+0xa9d>
     dc8:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
     dcc:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
     dd0:	2f6c656e 	svccs	0x006c656e
     dd4:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
     dd8:	2f656475 	svccs	0x00656475
     ddc:	72616f62 	rsbvc	r6, r1, #392	; 0x188
     de0:	70722f64 	rsbsvc	r2, r2, r4, ror #30
     de4:	682f3069 	stmdavs	pc!, {r0, r3, r5, r6, ip, sp}	; <UNPREDICTABLE>
     de8:	00006c61 	andeq	r6, r0, r1, ror #24
     dec:	6d647473 	cfstrdvs	mvd7, [r4, #-460]!	; 0xfffffe34
     df0:	632e6d65 			; <UNDEFINED> instruction: 0x632e6d65
     df4:	01007070 	tsteq	r0, r0, ror r0
     df8:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
     dfc:	66656474 			; <UNDEFINED> instruction: 0x66656474
     e00:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
     e04:	05000000 	streq	r0, [r0, #-0]
     e08:	02050001 	andeq	r0, r5, #1
     e0c:	00009fbc 			; <UNDEFINED> instruction: 0x00009fbc
     e10:	842e0518 	strthi	r0, [lr], #-1304	; 0xfffffae8
     e14:	054b1c05 	strbeq	r1, [fp, #-3077]	; 0xfffff3fb
     e18:	08052f30 	stmdaeq	r5, {r4, r5, r8, r9, sl, fp, sp}
     e1c:	4b0c054b 	blmi	302350 <__bss_end+0x2f6a18>
     e20:	022f0105 	eoreq	r0, pc, #1073741825	; 0x40000001
     e24:	01010008 	tsteq	r1, r8
     e28:	000004bf 			; <UNDEFINED> instruction: 0x000004bf
     e2c:	004f0003 	subeq	r0, pc, r3
     e30:	01020000 	mrseq	r0, (UNDEF: 2)
     e34:	000d0efb 	strdeq	r0, [sp], -fp
     e38:	01010101 	tsteq	r1, r1, lsl #2
     e3c:	01000000 	mrseq	r0, (UNDEF: 0)
     e40:	2f010000 	svccs	0x00010000
     e44:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     e48:	6863732f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, sp, lr}^
     e4c:	6a6b6e65 	bvs	1adc7e8 <__bss_end+0x1ad0eb0>
     e50:	32736f2f 	rsbscc	r6, r3, #47, 30	; 0xbc
     e54:	2f323230 	svccs	0x00323230
     e58:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
     e5c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     e60:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
     e64:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
     e68:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
     e6c:	73000063 	movwvc	r0, #99	; 0x63
     e70:	74736474 	ldrbtvc	r6, [r3], #-1140	; 0xfffffb8c
     e74:	676e6972 			; <UNDEFINED> instruction: 0x676e6972
     e78:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     e7c:	00000100 	andeq	r0, r0, r0, lsl #2
     e80:	00010500 	andeq	r0, r1, r0, lsl #10
     e84:	a0000205 	andge	r0, r0, r5, lsl #4
     e88:	0a030000 	beq	c0e90 <__bss_end+0xb5558>
     e8c:	bb060501 	bllt	182298 <__bss_end+0x176960>
     e90:	054c0f05 	strbeq	r0, [ip, #-3845]	; 0xfffff0fb
     e94:	0a056821 	beq	15af20 <__bss_end+0x14f5e8>
     e98:	2e0b05ba 	mcrcs	5, 0, r0, cr11, cr10, {5}
     e9c:	054a2705 	strbeq	r2, [sl, #-1797]	; 0xfffff8fb
     ea0:	09054a0d 	stmdbeq	r5, {r0, r2, r3, r9, fp, lr}
     ea4:	9f04052f 	svcls	0x0004052f
     ea8:	05620205 	strbeq	r0, [r2, #-517]!	; 0xfffffdfb
     eac:	10053505 	andne	r3, r5, r5, lsl #10
     eb0:	2e110568 	cfmsc32cs	mvfx0, mvfx1, mvfx8
     eb4:	054a2205 	strbeq	r2, [sl, #-517]	; 0xfffffdfb
     eb8:	0a052e13 	beq	14c70c <__bss_end+0x140dd4>
     ebc:	6909052f 	stmdbvs	r9, {r0, r1, r2, r3, r5, r8, sl}
     ec0:	052e0a05 	streq	r0, [lr, #-2565]!	; 0xfffff5fb
     ec4:	03054a0c 	movweq	r4, #23052	; 0x5a0c
     ec8:	680b054b 	stmdavs	fp, {r0, r1, r3, r6, r8, sl}
     ecc:	02001805 	andeq	r1, r0, #327680	; 0x50000
     ed0:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
     ed4:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
     ed8:	15059e03 	strne	r9, [r5, #-3587]	; 0xfffff1fd
     edc:	02040200 	andeq	r0, r4, #0, 4
     ee0:	00180568 	andseq	r0, r8, r8, ror #10
     ee4:	82020402 	andhi	r0, r2, #33554432	; 0x2000000
     ee8:	02000805 	andeq	r0, r0, #327680	; 0x50000
     eec:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
     ef0:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
     ef4:	1b054b02 	blne	153b04 <__bss_end+0x1481cc>
     ef8:	02040200 	andeq	r0, r4, #0, 4
     efc:	000c052e 	andeq	r0, ip, lr, lsr #10
     f00:	4a020402 	bmi	81f10 <__bss_end+0x765d8>
     f04:	02000f05 	andeq	r0, r0, #5, 30
     f08:	05820204 	streq	r0, [r2, #516]	; 0x204
     f0c:	0402001b 	streq	r0, [r2], #-27	; 0xffffffe5
     f10:	11054a02 	tstne	r5, r2, lsl #20
     f14:	02040200 	andeq	r0, r4, #0, 4
     f18:	000a052e 	andeq	r0, sl, lr, lsr #10
     f1c:	2f020402 	svccs	0x00020402
     f20:	02000b05 	andeq	r0, r0, #5120	; 0x1400
     f24:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
     f28:	0402000d 	streq	r0, [r2], #-13
     f2c:	02054a02 	andeq	r4, r5, #8192	; 0x2000
     f30:	02040200 	andeq	r0, r4, #0, 4
     f34:	88010546 	stmdahi	r1, {r1, r2, r6, r8, sl}
     f38:	83060585 	movwhi	r0, #25989	; 0x6585
     f3c:	054c0905 	strbeq	r0, [ip, #-2309]	; 0xfffff6fb
     f40:	0a054a10 	beq	153788 <__bss_end+0x147e50>
     f44:	bb07054c 	bllt	1c247c <__bss_end+0x1b6b44>
     f48:	054a0305 	strbeq	r0, [sl, #-773]	; 0xfffffcfb
     f4c:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
     f50:	14054a01 	strne	r4, [r5], #-2561	; 0xfffff5ff
     f54:	01040200 	mrseq	r0, R12_usr
     f58:	4d0d054a 	cfstr32mi	mvfx0, [sp, #-296]	; 0xfffffed8
     f5c:	054a1405 	strbeq	r1, [sl, #-1029]	; 0xfffffbfb
     f60:	08052e0a 	stmdaeq	r5, {r1, r3, r9, sl, fp, sp}
     f64:	03020568 	movweq	r0, #9576	; 0x2568
     f68:	09056678 	stmdbeq	r5, {r3, r4, r5, r6, r9, sl, sp, lr}
     f6c:	052e0b03 	streq	r0, [lr, #-2819]!	; 0xfffff4fd
     f70:	1b052f01 	blne	14cb7c <__bss_end+0x141244>
     f74:	83090585 	movwhi	r0, #38277	; 0x9585
     f78:	054b0b05 	strbeq	r0, [fp, #-2821]	; 0xfffff4fb
     f7c:	0f056812 	svceq	0x00056812
     f80:	830905bb 	movwhi	r0, #38331	; 0x95bb
     f84:	05640505 	strbeq	r0, [r4, #-1285]!	; 0xfffffafb
     f88:	1205330c 	andne	r3, r5, #12, 6	; 0x30000000
     f8c:	830f054a 	movwhi	r0, #62794	; 0xf54a
     f90:	05830905 	streq	r0, [r3, #2309]	; 0x905
     f94:	0a056405 	beq	159fb0 <__bss_end+0x14e678>
     f98:	670c0532 	smladxvs	ip, r2, r5, r0
     f9c:	082f0105 	stmdaeq	pc!, {r0, r2, r8}	; <UNPREDICTABLE>
     fa0:	83090523 	movwhi	r0, #38179	; 0x9523
     fa4:	054b0705 	strbeq	r0, [fp, #-1797]	; 0xfffff8fb
     fa8:	0f054c11 	svceq	0x00054c11
     fac:	2e0d0566 	cfsh32cs	mvfx0, mvfx13, #54
     fb0:	002e1d05 	eoreq	r1, lr, r5, lsl #26
     fb4:	06010402 	streq	r0, [r1], -r2, lsl #8
     fb8:	00200566 	eoreq	r0, r0, r6, ror #10
     fbc:	06030402 	streq	r0, [r3], -r2, lsl #8
     fc0:	001d0566 	andseq	r0, sp, r6, ror #10
     fc4:	66050402 	strvs	r0, [r5], -r2, lsl #8
     fc8:	06040200 	streq	r0, [r4], -r0, lsl #4
     fcc:	02004a06 	andeq	r4, r0, #24576	; 0x6000
     fd0:	052e0804 	streq	r0, [lr, #-2052]!	; 0xfffff7fc
     fd4:	054b0609 	strbeq	r0, [fp, #-1545]	; 0xfffff9f7
     fd8:	15054a0a 	strne	r4, [r5, #-2570]	; 0xfffff5f6
     fdc:	4a10054a 	bmi	40250c <__bss_end+0x3f6bd4>
     fe0:	05660705 	strbeq	r0, [r6, #-1797]!	; 0xfffff8fb
     fe4:	05314903 	ldreq	r4, [r1, #-2307]!	; 0xfffff6fd
     fe8:	11056713 	tstne	r5, r3, lsl r7
     fec:	2e0f0566 	cfsh32cs	mvfx0, mvfx15, #54
     ff0:	002e1f05 	eoreq	r1, lr, r5, lsl #30
     ff4:	06010402 	streq	r0, [r1], -r2, lsl #8
     ff8:	00220566 	eoreq	r0, r2, r6, ror #10
     ffc:	06030402 	streq	r0, [r3], -r2, lsl #8
    1000:	001f0566 	andseq	r0, pc, r6, ror #10
    1004:	66050402 	strvs	r0, [r5], -r2, lsl #8
    1008:	06040200 	streq	r0, [r4], -r0, lsl #4
    100c:	02004a06 	andeq	r4, r0, #24576	; 0x6000
    1010:	052e0804 	streq	r0, [lr, #-2052]!	; 0xfffff7fc
    1014:	054b060b 	strbeq	r0, [fp, #-1547]	; 0xfffff9f5
    1018:	17054a0c 	strne	r4, [r5, -ip, lsl #20]
    101c:	4a12054a 	bmi	48254c <__bss_end+0x476c14>
    1020:	4b660905 	blmi	198343c <__bss_end+0x1977b04>
    1024:	05640505 	strbeq	r0, [r4, #-1285]!	; 0xfffffafb
    1028:	10053303 	andne	r3, r5, r3, lsl #6
    102c:	01040200 	mrseq	r0, R12_usr
    1030:	67090566 	strvs	r0, [r9, -r6, ror #10]
    1034:	4b0b054b 	blmi	2c2568 <__bss_end+0x2b6c30>
    1038:	05660905 	strbeq	r0, [r6, #-2309]!	; 0xfffff6fb
    103c:	05052e07 	streq	r2, [r5, #-3591]	; 0xfffff1f9
    1040:	670d052f 	strvs	r0, [sp, -pc, lsr #10]
    1044:	05660b05 	strbeq	r0, [r6, #-2821]!	; 0xfffff4fb
    1048:	0a052e09 	beq	14c874 <__bss_end+0x140f3c>
    104c:	670d054b 	strvs	r0, [sp, -fp, asr #10]
    1050:	05660b05 	strbeq	r0, [r6, #-2821]!	; 0xfffff4fb
    1054:	0c052e09 	stceq	14, cr2, [r5], {9}
    1058:	02004c2f 	andeq	r4, r0, #12032	; 0x2f00
    105c:	66060104 	strvs	r0, [r6], -r4, lsl #2
    1060:	15056706 	strne	r6, [r5, #-1798]	; 0xfffff8fa
    1064:	4a0905ba 	bmi	242754 <__bss_end+0x236e1c>
    1068:	054b0d05 	strbeq	r0, [fp, #-3333]	; 0xfffff2fb
    106c:	0905660b 	stmdbeq	r5, {r0, r1, r3, r9, sl, sp, lr}
    1070:	2c05052e 	cfstr32cs	mvfx0, [r5], {46}	; 0x2e
    1074:	05320b05 	ldreq	r0, [r2, #-2821]!	; 0xfffff4fb
    1078:	0c056607 	stceq	6, cr6, [r5], {7}
    107c:	67070568 	strvs	r0, [r7, -r8, ror #10]
    1080:	05830605 	streq	r0, [r3, #1541]	; 0x605
    1084:	0c056403 	cfstrseq	mvf6, [r5], {3}
    1088:	67070532 	smladxvs	r7, r2, r5, r0
    108c:	05bb0605 	ldreq	r0, [fp, #1541]!	; 0x605
    1090:	0a056403 	beq	15a0a4 <__bss_end+0x14e76c>
    1094:	4b010532 	blmi	42564 <__bss_end+0x36c2c>
    1098:	22082605 	andcs	r2, r8, #5242880	; 0x500000
    109c:	4b9f0905 	blmi	fe7c34b8 <__bss_end+0xfe7b7b80>
    10a0:	4c4b0f05 	mcrrmi	15, 0, r0, fp, cr5
    10a4:	052e0505 	streq	r0, [lr, #-1285]!	; 0xfffffafb
    10a8:	11056713 	tstne	r5, r3, lsl r7
    10ac:	4a130567 	bmi	4c2650 <__bss_end+0x4b6d18>
    10b0:	054b0905 	strbeq	r0, [fp, #-2309]	; 0xfffff6fb
    10b4:	0505310f 	streq	r3, [r5, #-271]	; 0xfffffef1
    10b8:	6710052e 	ldrvs	r0, [r0, -lr, lsr #10]
    10bc:	05661305 	strbeq	r1, [r6, #-773]!	; 0xfffffcfb
    10c0:	0f054b11 	svceq	0x00054b11
    10c4:	3119054a 	tstcc	r9, sl, asr #10
    10c8:	05841505 	streq	r1, [r4, #1285]	; 0x505
    10cc:	0d05671b 	stceq	7, cr6, [r5, #-108]	; 0xffffff94
    10d0:	671b0566 	ldrvs	r0, [fp, -r6, ror #10]
    10d4:	054a1005 	strbeq	r1, [sl, #-5]
    10d8:	1305661b 	movwne	r6, #22043	; 0x561b
    10dc:	2f17054a 	svccs	0x0017054a
    10e0:	05661c05 	strbeq	r1, [r6, #-3077]!	; 0xfffff3fb
    10e4:	0905820f 	stmdbeq	r5, {r0, r1, r2, r3, r9, pc}
    10e8:	0505672f 	streq	r6, [r5, #-1839]	; 0xfffff8d1
    10ec:	10053661 	andne	r3, r5, r1, ror #12
    10f0:	66130567 	ldrvs	r0, [r3], -r7, ror #10
    10f4:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
    10f8:	1905660f 	stmdbne	r5, {r0, r1, r2, r3, r9, sl, sp, lr}
    10fc:	0402004c 	streq	r0, [r2], #-76	; 0xffffffb4
    1100:	05660601 	strbeq	r0, [r6, #-1537]!	; 0xfffff9ff
    1104:	05670610 	strbeq	r0, [r7, #-1552]!	; 0xfffff9f0
    1108:	09056613 	stmdbeq	r5, {r0, r1, r4, r9, sl, sp, lr}
    110c:	0505674b 	streq	r6, [r5, #-1867]	; 0xfffff8b5
    1110:	34130563 	ldrcc	r0, [r3], #-1379	; 0xfffffa9d
    1114:	05671505 	strbeq	r1, [r7, #-1285]!	; 0xfffffafb
    1118:	0d054a1b 	vstreq	s8, [r5, #-108]	; 0xffffff94
    111c:	671b054a 	ldrvs	r0, [fp, -sl, asr #10]
    1120:	054a1005 	strbeq	r1, [sl, #-5]
    1124:	1305661b 	movwne	r6, #22043	; 0x561b
    1128:	2f11054a 	svccs	0x0011054a
    112c:	054a1705 	strbeq	r1, [sl, #-1797]	; 0xfffff8fb
    1130:	0f054a1e 	svceq	0x00054a1e
    1134:	2f09059e 	svccs	0x0009059e
    1138:	05620505 	strbeq	r0, [r2, #-1285]!	; 0xfffffafb
    113c:	0105340d 	tsteq	r5, sp, lsl #8
    1140:	0905a167 	stmdbeq	r5, {r0, r1, r2, r5, r6, r8, sp, pc}
    1144:	001605bd 			; <UNDEFINED> instruction: 0x001605bd
    1148:	4a040402 	bmi	102158 <__bss_end+0xf6820>
    114c:	02001d05 	andeq	r1, r0, #320	; 0x140
    1150:	05820204 	streq	r0, [r2, #516]	; 0x204
    1154:	0402001e 	streq	r0, [r2], #-30	; 0xffffffe2
    1158:	16052e02 	strne	r2, [r5], -r2, lsl #28
    115c:	02040200 	andeq	r0, r4, #0, 4
    1160:	00110566 	andseq	r0, r1, r6, ror #10
    1164:	4b030402 	blmi	c2174 <__bss_end+0xb683c>
    1168:	02001205 	andeq	r1, r0, #1342177280	; 0x50000000
    116c:	052e0304 	streq	r0, [lr, #-772]!	; 0xfffffcfc
    1170:	04020008 	streq	r0, [r2], #-8
    1174:	09054a03 	stmdbeq	r5, {r0, r1, r9, fp, lr}
    1178:	03040200 	movweq	r0, #16896	; 0x4200
    117c:	0012052e 	andseq	r0, r2, lr, lsr #10
    1180:	4a030402 	bmi	c2190 <__bss_end+0xb6858>
    1184:	02000b05 	andeq	r0, r0, #5120	; 0x1400
    1188:	052e0304 	streq	r0, [lr, #-772]!	; 0xfffffcfc
    118c:	04020002 	streq	r0, [r2], #-2
    1190:	0b052d03 	bleq	14c5a4 <__bss_end+0x140c6c>
    1194:	02040200 	andeq	r0, r4, #0, 4
    1198:	00080584 	andeq	r0, r8, r4, lsl #11
    119c:	83010402 	movwhi	r0, #5122	; 0x1402
    11a0:	02000905 	andeq	r0, r0, #81920	; 0x14000
    11a4:	052e0104 	streq	r0, [lr, #-260]!	; 0xfffffefc
    11a8:	0402000b 	streq	r0, [r2], #-11
    11ac:	02054a01 	andeq	r4, r5, #4096	; 0x1000
    11b0:	01040200 	mrseq	r0, R12_usr
    11b4:	850b0549 	strhi	r0, [fp, #-1353]	; 0xfffffab7
    11b8:	852f0105 	strhi	r0, [pc, #-261]!	; 10bb <shift+0x10bb>
    11bc:	05a10c05 	streq	r0, [r1, #3077]!	; 0xc05
    11c0:	04020016 	streq	r0, [r2], #-22	; 0xffffffea
    11c4:	17054a03 	strne	r4, [r5, -r3, lsl #20]
    11c8:	03040200 	movweq	r0, #16896	; 0x4200
    11cc:	0019052e 	andseq	r0, r9, lr, lsr #10
    11d0:	66030402 	strvs	r0, [r3], -r2, lsl #8
    11d4:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
    11d8:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
    11dc:	1505840c 	strne	r8, [r5, #-1036]	; 0xfffffbf4
    11e0:	03040200 	movweq	r0, #16896	; 0x4200
    11e4:	0016054a 	andseq	r0, r6, sl, asr #10
    11e8:	2e030402 	cdpcs	4, 0, cr0, cr3, cr2, {0}
    11ec:	02001805 	andeq	r1, r0, #327680	; 0x50000
    11f0:	05660304 	strbeq	r0, [r6, #-772]!	; 0xfffffcfc
    11f4:	04020019 	streq	r0, [r2], #-25	; 0xffffffe7
    11f8:	1a054b02 	bne	153e08 <__bss_end+0x1484d0>
    11fc:	02040200 	andeq	r0, r4, #0, 4
    1200:	000f052e 	andeq	r0, pc, lr, lsr #10
    1204:	4a020402 	bmi	82214 <__bss_end+0x768dc>
    1208:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
    120c:	05820204 	streq	r0, [r2, #516]	; 0x204
    1210:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
    1214:	13054a02 	movwne	r4, #23042	; 0x5a02
    1218:	02040200 	andeq	r0, r4, #0, 4
    121c:	0005052e 	andeq	r0, r5, lr, lsr #10
    1220:	2d020402 	cfstrscs	mvf0, [r2, #-8]
    1224:	05850b05 	streq	r0, [r5, #2821]	; 0xb05
    1228:	0f05820d 	svceq	0x0005820d
    122c:	4c0c054a 	cfstr32mi	mvfx0, [ip], {74}	; 0x4a
    1230:	852f0105 	strhi	r0, [pc, #-261]!	; 1133 <shift+0x1133>
    1234:	05bc0e05 	ldreq	r0, [ip, #3589]!	; 0xe05
    1238:	20056611 	andcs	r6, r5, r1, lsl r6
    123c:	660b05bc 			; <UNDEFINED> instruction: 0x660b05bc
    1240:	054b1f05 	strbeq	r1, [fp, #-3845]	; 0xfffff0fb
    1244:	0805660a 	stmdaeq	r5, {r1, r3, r9, sl, sp, lr}
    1248:	8311054b 	tsthi	r1, #314572800	; 0x12c00000
    124c:	052e1605 	streq	r1, [lr, #-1541]!	; 0xfffff9fb
    1250:	11056708 	tstne	r5, r8, lsl #14
    1254:	4d0b0567 	cfstr32mi	mvfx0, [fp, #-412]	; 0xfffffe64
    1258:	852f0105 	strhi	r0, [pc, #-261]!	; 115b <shift+0x115b>
    125c:	05830605 	streq	r0, [r3, #1541]	; 0x605
    1260:	0c054c0b 	stceq	12, cr4, [r5], {11}
    1264:	660e052e 	strvs	r0, [lr], -lr, lsr #10
    1268:	054b0405 	strbeq	r0, [fp, #-1029]	; 0xfffffbfb
    126c:	09056502 	stmdbeq	r5, {r1, r8, sl, sp, lr}
    1270:	2f010531 	svccs	0x00010531
    1274:	9f080585 	svcls	0x00080585
    1278:	054c0b05 	strbeq	r0, [ip, #-2821]	; 0xfffff4fb
    127c:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
    1280:	07054a03 	streq	r4, [r5, -r3, lsl #20]
    1284:	02040200 	andeq	r0, r4, #0, 4
    1288:	00080583 	andeq	r0, r8, r3, lsl #11
    128c:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
    1290:	02000a05 	andeq	r0, r0, #20480	; 0x5000
    1294:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
    1298:	04020002 	streq	r0, [r2], #-2
    129c:	01054902 	tsteq	r5, r2, lsl #18
    12a0:	0e058584 	cfsh32eq	mvfx8, mvfx5, #-60
    12a4:	4b0805bb 	blmi	202998 <__bss_end+0x1f7060>
    12a8:	054c0b05 	strbeq	r0, [ip, #-2821]	; 0xfffff4fb
    12ac:	04020014 	streq	r0, [r2], #-20	; 0xffffffec
    12b0:	16054a03 	strne	r4, [r5], -r3, lsl #20
    12b4:	02040200 	andeq	r0, r4, #0, 4
    12b8:	00170583 	andseq	r0, r7, r3, lsl #11
    12bc:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
    12c0:	02000a05 	andeq	r0, r0, #20480	; 0x5000
    12c4:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
    12c8:	0402000b 	streq	r0, [r2], #-11
    12cc:	17052e02 	strne	r2, [r5, -r2, lsl #28]
    12d0:	02040200 	andeq	r0, r4, #0, 4
    12d4:	000d054a 	andeq	r0, sp, sl, asr #10
    12d8:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
    12dc:	02000205 	andeq	r0, r0, #1342177280	; 0x50000000
    12e0:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
    12e4:	08028401 	stmdaeq	r2, {r0, sl, pc}
    12e8:	49010100 	stmdbmi	r1, {r8}
    12ec:	03000002 	movweq	r0, #2
    12f0:	0001a100 	andeq	sl, r1, r0, lsl #2
    12f4:	fb010200 	blx	41afe <__bss_end+0x361c6>
    12f8:	01000d0e 	tsteq	r0, lr, lsl #26
    12fc:	00010101 	andeq	r0, r1, r1, lsl #2
    1300:	00010000 	andeq	r0, r1, r0
    1304:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
    1308:	2f656d6f 	svccs	0x00656d6f
    130c:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
    1310:	2f6a6b6e 	svccs	0x006a6b6e
    1314:	3032736f 	eorscc	r7, r2, pc, ror #6
    1318:	732f3232 			; <UNDEFINED> instruction: 0x732f3232
    131c:	6f732f70 	svcvs	0x00732f70
    1320:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    1324:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
    1328:	69747564 	ldmdbvs	r4!, {r2, r5, r6, r8, sl, ip, sp, lr}^
    132c:	732f736c 			; <UNDEFINED> instruction: 0x732f736c
    1330:	2f006372 	svccs	0x00006372
    1334:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    1338:	6863732f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, sp, lr}^
    133c:	6a6b6e65 	bvs	1adccd8 <__bss_end+0x1ad13a0>
    1340:	32736f2f 	rsbscc	r6, r3, #47, 30	; 0xbc
    1344:	2f323230 	svccs	0x00323230
    1348:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
    134c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    1350:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
    1354:	74756474 	ldrbtvc	r6, [r5], #-1140	; 0xfffffb8c
    1358:	2f736c69 	svccs	0x00736c69
    135c:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
    1360:	00656475 	rsbeq	r6, r5, r5, ror r4
    1364:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 12b0 <shift+0x12b0>
    1368:	63732f65 	cmnvs	r3, #404	; 0x194
    136c:	6b6e6568 	blvs	1b9a914 <__bss_end+0x1b8efdc>
    1370:	736f2f6a 	cmnvc	pc, #424	; 0x1a8
    1374:	32323032 	eorscc	r3, r2, #50	; 0x32
    1378:	2f70732f 	svccs	0x0070732f
    137c:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
    1380:	2f736563 	svccs	0x00736563
    1384:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
    1388:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
    138c:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
    1390:	702f6564 	eorvc	r6, pc, r4, ror #10
    1394:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1398:	2f007373 	svccs	0x00007373
    139c:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    13a0:	6863732f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, sp, lr}^
    13a4:	6a6b6e65 	bvs	1adcd40 <__bss_end+0x1ad1408>
    13a8:	32736f2f 	rsbscc	r6, r3, #47, 30	; 0xbc
    13ac:	2f323230 	svccs	0x00323230
    13b0:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
    13b4:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    13b8:	6b2f7365 	blvs	bde154 <__bss_end+0xbd281c>
    13bc:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
    13c0:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
    13c4:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
    13c8:	73662f65 	cmnvc	r6, #404	; 0x194
    13cc:	6f682f00 	svcvs	0x00682f00
    13d0:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
    13d4:	6e656863 	cdpvs	8, 6, cr6, cr5, cr3, {3}
    13d8:	6f2f6a6b 	svcvs	0x002f6a6b
    13dc:	32303273 	eorscc	r3, r0, #805306375	; 0x30000007
    13e0:	70732f32 	rsbsvc	r2, r3, r2, lsr pc
    13e4:	756f732f 	strbvc	r7, [pc, #-815]!	; 10bd <shift+0x10bd>
    13e8:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
    13ec:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
    13f0:	2f6c656e 	svccs	0x006c656e
    13f4:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
    13f8:	2f656475 	svccs	0x00656475
    13fc:	72616f62 	rsbvc	r6, r1, #392	; 0x188
    1400:	70722f64 	rsbsvc	r2, r2, r4, ror #30
    1404:	682f3069 	stmdavs	pc!, {r0, r3, r5, r6, ip, sp}	; <UNPREDICTABLE>
    1408:	00006c61 	andeq	r6, r0, r1, ror #24
    140c:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
    1410:	6c697455 	cfstrdvs	mvd7, [r9], #-340	; 0xfffffeac
    1414:	70632e73 	rsbvc	r2, r3, r3, ror lr
    1418:	00010070 	andeq	r0, r1, r0, ror r0
    141c:	72696300 	rsbvc	r6, r9, #0, 6
    1420:	616c7563 	cmnvs	ip, r3, ror #10
    1424:	66754272 			; <UNDEFINED> instruction: 0x66754272
    1428:	2e726566 	cdpcs	5, 7, cr6, cr2, cr6, {3}
    142c:	00020068 	andeq	r0, r2, r8, rrx
    1430:	61657200 	cmnvs	r5, r0, lsl #4
    1434:	69745564 	ldmdbvs	r4!, {r2, r5, r6, r8, sl, ip, lr}^
    1438:	682e736c 	stmdavs	lr!, {r2, r3, r5, r6, r8, r9, ip, sp, lr}
    143c:	00000200 	andeq	r0, r0, r0, lsl #4
    1440:	2e697773 	mcrcs	7, 3, r7, cr9, cr3, {3}
    1444:	00030068 	andeq	r0, r3, r8, rrx
    1448:	69707300 	ldmdbvs	r0!, {r8, r9, ip, sp, lr}^
    144c:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
    1450:	00682e6b 	rsbeq	r2, r8, fp, ror #28
    1454:	66000003 	strvs	r0, [r0], -r3
    1458:	73656c69 	cmnvc	r5, #26880	; 0x6900
    145c:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
    1460:	00682e6d 	rsbeq	r2, r8, sp, ror #28
    1464:	70000004 	andvc	r0, r0, r4
    1468:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    146c:	682e7373 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, r9, ip, sp, lr}
    1470:	00000300 	andeq	r0, r0, r0, lsl #6
    1474:	636f7270 	cmnvs	pc, #112, 4
    1478:	5f737365 	svcpl	0x00737365
    147c:	616e616d 	cmnvs	lr, sp, ror #2
    1480:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
    1484:	00030068 	andeq	r0, r3, r8, rrx
    1488:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
    148c:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
    1490:	00050068 	andeq	r0, r5, r8, rrx
    1494:	01050000 	mrseq	r0, (UNDEF: 5)
    1498:	40020500 	andmi	r0, r2, r0, lsl #10
    149c:	160000ab 	strne	r0, [r0], -fp, lsr #1
    14a0:	05821805 	streq	r1, [r2, #2053]	; 0x805
    14a4:	52056801 	andpl	r6, r5, #65536	; 0x10000
    14a8:	d8070584 	stmdale	r7, {r2, r7, r8, sl}
    14ac:	05830b05 	streq	r0, [r3, #2821]	; 0xb05
    14b0:	03054e10 	movweq	r4, #24080	; 0x5e10
    14b4:	4b08052e 	blmi	202974 <__bss_end+0x1f703c>
    14b8:	05871605 	streq	r1, [r7, #1541]	; 0x605
    14bc:	0c05bb03 			; <UNDEFINED> instruction: 0x0c05bb03
    14c0:	9f1c056d 	svcls	0x001c056d
    14c4:	05bd1b05 	ldreq	r1, [sp, #2821]!	; 0xb05
    14c8:	22054a0d 	andcs	r4, r5, #53248	; 0xd000
    14cc:	01040200 	mrseq	r0, R12_usr
    14d0:	6716052e 	ldrvs	r0, [r6, -lr, lsr #10]
    14d4:	052e1705 	streq	r1, [lr, #-1797]!	; 0xfffff8fb
    14d8:	31056605 	tstcc	r5, r5, lsl #12
    14dc:	02040200 	andeq	r0, r4, #0, 4
    14e0:	0032054a 	eorseq	r0, r2, sl, asr #10
    14e4:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
    14e8:	02002105 	andeq	r2, r0, #1073741825	; 0x40000001
    14ec:	05660204 	strbeq	r0, [r6, #-516]!	; 0xfffffdfc
    14f0:	04020013 	streq	r0, [r2], #-19	; 0xffffffed
    14f4:	14054b03 	strne	r4, [r5], #-2819	; 0xfffff4fd
    14f8:	03040200 	movweq	r0, #16896	; 0x4200
    14fc:	0016052e 	andseq	r0, r6, lr, lsr #10
    1500:	4a030402 	bmi	c2510 <__bss_end+0xb6bd8>
    1504:	02000605 	andeq	r0, r0, #5242880	; 0x500000
    1508:	054b0304 	strbeq	r0, [fp, #-772]	; 0xfffffcfc
    150c:	04020004 	streq	r0, [r2], #-4
    1510:	05052b03 	streq	r2, [r5, #-2819]	; 0xfffff4fd
    1514:	311a0588 	tstcc	sl, r8, lsl #11
    1518:	02002605 	andeq	r2, r0, #5242880	; 0x500000
    151c:	05660104 	strbeq	r0, [r6, #-260]!	; 0xfffffefc
    1520:	0402001a 	streq	r0, [r2], #-26	; 0xffffffe6
    1524:	02052e01 	andeq	r2, r5, #1, 28
    1528:	054a6403 	strbeq	r6, [sl, #-1027]	; 0xfffffbfd
    152c:	2e1e030c 	cdpcs	3, 1, cr0, cr14, cr12, {0}
    1530:	022f0105 	eoreq	r0, pc, #1073741825	; 0x40000001
    1534:	01010006 	tsteq	r1, r6
    1538:	00000225 	andeq	r0, r0, r5, lsr #4
    153c:	00e50003 	rsceq	r0, r5, r3
    1540:	01020000 	mrseq	r0, (UNDEF: 2)
    1544:	000d0efb 	strdeq	r0, [sp], -fp
    1548:	01010101 	tsteq	r1, r1, lsl #2
    154c:	01000000 	mrseq	r0, (UNDEF: 0)
    1550:	2f010000 	svccs	0x00010000
    1554:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    1558:	6863732f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, sp, lr}^
    155c:	6a6b6e65 	bvs	1adcef8 <__bss_end+0x1ad15c0>
    1560:	32736f2f 	rsbscc	r6, r3, #47, 30	; 0xbc
    1564:	2f323230 	svccs	0x00323230
    1568:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
    156c:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    1570:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
    1574:	74756474 	ldrbtvc	r6, [r5], #-1140	; 0xfffffb8c
    1578:	2f736c69 	svccs	0x00736c69
    157c:	00637273 	rsbeq	r7, r3, r3, ror r2
    1580:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 14cc <shift+0x14cc>
    1584:	63732f65 	cmnvs	r3, #404	; 0x194
    1588:	6b6e6568 	blvs	1b9ab30 <__bss_end+0x1b8f1f8>
    158c:	736f2f6a 	cmnvc	pc, #424	; 0x1a8
    1590:	32323032 	eorscc	r3, r2, #50	; 0x32
    1594:	2f70732f 	svccs	0x0070732f
    1598:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
    159c:	2f736563 	svccs	0x00736563
    15a0:	75647473 	strbvc	r7, [r4, #-1139]!	; 0xfffffb8d
    15a4:	736c6974 	cmnvc	ip, #116, 18	; 0x1d0000
    15a8:	636e692f 	cmnvs	lr, #770048	; 0xbc000
    15ac:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
    15b0:	6f682f00 	svcvs	0x00682f00
    15b4:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
    15b8:	6e656863 	cdpvs	8, 6, cr6, cr5, cr3, {3}
    15bc:	6f2f6a6b 	svcvs	0x002f6a6b
    15c0:	32303273 	eorscc	r3, r0, #805306375	; 0x30000007
    15c4:	70732f32 	rsbsvc	r2, r3, r2, lsr pc
    15c8:	756f732f 	strbvc	r7, [pc, #-815]!	; 12a1 <shift+0x12a1>
    15cc:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
    15d0:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
    15d4:	2f6c656e 	svccs	0x006c656e
    15d8:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
    15dc:	2f656475 	svccs	0x00656475
    15e0:	72616f62 	rsbvc	r6, r1, #392	; 0x188
    15e4:	70722f64 	rsbsvc	r2, r2, r4, ror #30
    15e8:	682f3069 	stmdavs	pc!, {r0, r3, r5, r6, ip, sp}	; <UNPREDICTABLE>
    15ec:	00006c61 	andeq	r6, r0, r1, ror #24
    15f0:	63726963 	cmnvs	r2, #1622016	; 0x18c000
    15f4:	72616c75 	rsbvc	r6, r1, #29952	; 0x7500
    15f8:	66667542 	strbtvs	r7, [r6], -r2, asr #10
    15fc:	632e7265 			; <UNDEFINED> instruction: 0x632e7265
    1600:	01007070 	tsteq	r0, r0, ror r0
    1604:	69630000 	stmdbvs	r3!, {}^	; <UNPREDICTABLE>
    1608:	6c756372 	ldclvs	3, cr6, [r5], #-456	; 0xfffffe38
    160c:	75427261 	strbvc	r7, [r2, #-609]	; 0xfffffd9f
    1610:	72656666 	rsbvc	r6, r5, #106954752	; 0x6600000
    1614:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
    1618:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
    161c:	66656474 			; <UNDEFINED> instruction: 0x66656474
    1620:	0300682e 	movweq	r6, #2094	; 0x82e
    1624:	05000000 	streq	r0, [r0, #-0]
    1628:	02050001 	andeq	r0, r5, #1
    162c:	0000acac 	andeq	sl, r0, ip, lsr #25
    1630:	82220515 	eorhi	r0, r2, #88080384	; 0x5400000
    1634:	05bb0b05 	ldreq	r0, [fp, #2821]!	; 0xb05
    1638:	01052e0a 	tsteq	r5, sl, lsl #28
    163c:	872c0567 	strhi	r0, [ip, -r7, ror #10]!
    1640:	059f1605 	ldreq	r1, [pc, #1541]	; 1c4d <shift+0x1c4d>
    1644:	10054a24 	andne	r4, r5, r4, lsr #20
    1648:	bb01054a 	bllt	42b78 <__bss_end+0x37240>
    164c:	05693a05 	strbeq	r3, [r9, #-2565]!	; 0xfffff5fb
    1650:	1705bb09 	strne	fp, [r5, -r9, lsl #22]
    1654:	4a25054b 	bmi	942b88 <__bss_end+0x937250>
    1658:	054a0e05 	strbeq	r0, [sl, #-3589]	; 0xfffff1fb
    165c:	0d054c05 	stceq	12, cr4, [r5, #-20]	; 0xffffffec
    1660:	4d0e0583 	cfstr32mi	mvfx0, [lr, #-524]	; 0xfffffdf4
    1664:	02001505 	andeq	r1, r0, #20971520	; 0x1400000
    1668:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
    166c:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
    1670:	21052e03 	tstcs	r5, r3, lsl #28
    1674:	02040200 	andeq	r0, r4, #0, 4
    1678:	002c0567 	eoreq	r0, ip, r7, ror #10
    167c:	4a020402 	bmi	8268c <__bss_end+0x76d54>
    1680:	02000d05 	andeq	r0, r0, #320	; 0x140
    1684:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
    1688:	04020016 	streq	r0, [r2], #-22	; 0xffffffea
    168c:	39052e02 	stmdbcc	r5, {r1, r9, sl, fp, sp}
    1690:	02040200 	andeq	r0, r4, #0, 4
    1694:	0018054a 	andseq	r0, r8, sl, asr #10
    1698:	4a020402 	bmi	826a8 <__bss_end+0x76d70>
    169c:	02001205 	andeq	r1, r0, #1342177280	; 0x50000000
    16a0:	05300204 	ldreq	r0, [r0, #-516]!	; 0xfffffdfc
    16a4:	04020009 	streq	r0, [r2], #-9
    16a8:	13056702 	movwne	r6, #22274	; 0x5702
    16ac:	02040200 	andeq	r0, r4, #0, 4
    16b0:	0005054a 	andeq	r0, r5, sl, asr #10
    16b4:	62020402 	andvs	r0, r2, #33554432	; 0x2000000
    16b8:	05890c05 	streq	r0, [r9, #3077]	; 0xc05
    16bc:	38052f01 	stmdacc	r5, {r0, r8, r9, sl, fp, sp}
    16c0:	bb0e0585 	bllt	382cdc <__bss_end+0x3773a4>
    16c4:	02001505 	andeq	r1, r0, #20971520	; 0x1400000
    16c8:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
    16cc:	04020017 	streq	r0, [r2], #-23	; 0xffffffe9
    16d0:	15052e03 	strne	r2, [r5, #-3587]	; 0xfffff1fd
    16d4:	02040200 	andeq	r0, r4, #0, 4
    16d8:	00160567 	andseq	r0, r6, r7, ror #10
    16dc:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
    16e0:	02000e05 	andeq	r0, r0, #5, 28	; 0x50
    16e4:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
    16e8:	04020005 	streq	r0, [r2], #-5
    16ec:	01058102 	tsteq	r5, r2, lsl #2
    16f0:	69290585 	stmdbvs	r9!, {r0, r2, r7, r8, sl}
    16f4:	05bb0c05 	ldreq	r0, [fp, #3077]!	; 0xc05
    16f8:	27054a18 	smladcs	r5, r8, sl, r4
    16fc:	6705052e 	strvs	r0, [r5, -lr, lsr #10]
    1700:	054a1005 	strbeq	r1, [sl, #-5]
    1704:	3b056701 	blcc	15b310 <__bss_end+0x14f9d8>
    1708:	d91a0586 	ldmdble	sl, {r1, r2, r7, r8, sl}
    170c:	054a1805 	strbeq	r1, [sl, #-2053]	; 0xfffff7fb
    1710:	04020036 	streq	r0, [r2], #-54	; 0xffffffca
    1714:	26052e01 	strcs	r2, [r5], -r1, lsl #28
    1718:	01040200 	mrseq	r0, R12_usr
    171c:	0034054a 	eorseq	r0, r4, sl, asr #10
    1720:	2e010402 	cdpcs	4, 0, cr0, cr1, cr2, {0}
    1724:	054b2205 	strbeq	r2, [fp, #-517]	; 0xfffffdfb
    1728:	09059e2f 	stmdbeq	r5, {r0, r1, r2, r3, r5, r9, sl, fp, ip, pc}
    172c:	6b1e054a 	blvs	782c5c <__bss_end+0x777324>
    1730:	054a2a05 	strbeq	r2, [sl, #-2565]	; 0xfffff5fb
    1734:	09052e0d 	stmdbeq	r5, {r0, r2, r3, r9, sl, fp, sp}
    1738:	4b14052e 	blmi	502bf8 <__bss_end+0x4f72c0>
    173c:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
    1740:	79030204 	stmdbvc	r3, {r2, r9}
    1744:	840d054a 	strhi	r0, [sp], #-1354	; 0xfffffab6
    1748:	0a031605 	beq	c6f64 <__bss_end+0xbb62c>
    174c:	2e26052e 	cfsh64cs	mvdx0, mvdx6, #30
    1750:	054a2405 	strbeq	r2, [sl, #-1029]	; 0xfffffbfb
    1754:	34052e10 	strcc	r2, [r5], #-3600	; 0xfffff1f0
    1758:	2f0105ba 	svccs	0x000105ba
    175c:	01000602 	tsteq	r0, r2, lsl #12
    1760:	00007901 	andeq	r7, r0, r1, lsl #18
    1764:	46000300 	strmi	r0, [r0], -r0, lsl #6
    1768:	02000000 	andeq	r0, r0, #0
    176c:	0d0efb01 	vstreq	d15, [lr, #-4]
    1770:	01010100 	mrseq	r0, (UNDEF: 17)
    1774:	00000001 	andeq	r0, r0, r1
    1778:	01000001 	tsteq	r0, r1
    177c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1780:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1784:	2f2e2e2f 	svccs	0x002e2e2f
    1788:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    178c:	696c2f2e 	stmdbvs	ip!, {r1, r2, r3, r5, r8, r9, sl, fp, sp}^
    1790:	63636762 	cmnvs	r3, #25690112	; 0x1880000
    1794:	6e6f632f 	cdpvs	3, 6, cr6, cr15, cr15, {1}
    1798:	2f676966 	svccs	0x00676966
    179c:	006d7261 	rsbeq	r7, sp, r1, ror #4
    17a0:	62696c00 	rsbvs	r6, r9, #0, 24
    17a4:	6e756631 	mrcvs	6, 3, r6, cr5, cr1, {1}
    17a8:	532e7363 			; <UNDEFINED> instruction: 0x532e7363
    17ac:	00000100 	andeq	r0, r0, r0, lsl #2
    17b0:	02050000 	andeq	r0, r5, #0
    17b4:	0000af98 	muleq	r0, r8, pc	; <UNPREDICTABLE>
    17b8:	0108ca03 	tsteq	r8, r3, lsl #20
    17bc:	2f2f2f30 	svccs	0x002f2f30
    17c0:	02302f2f 	eorseq	r2, r0, #47, 30	; 0xbc
    17c4:	2f1401d0 	svccs	0x001401d0
    17c8:	302f2f31 	eorcc	r2, pc, r1, lsr pc	; <UNPREDICTABLE>
    17cc:	03322f4c 	teqeq	r2, #76, 30	; 0x130
    17d0:	2f2f661f 	svccs	0x002f661f
    17d4:	2f2f2f2f 	svccs	0x002f2f2f
    17d8:	0002022f 	andeq	r0, r2, pc, lsr #4
    17dc:	005c0101 	subseq	r0, ip, r1, lsl #2
    17e0:	00030000 	andeq	r0, r3, r0
    17e4:	00000046 	andeq	r0, r0, r6, asr #32
    17e8:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
    17ec:	0101000d 	tsteq	r1, sp
    17f0:	00000101 	andeq	r0, r0, r1, lsl #2
    17f4:	00000100 	andeq	r0, r0, r0, lsl #2
    17f8:	2f2e2e01 	svccs	0x002e2e01
    17fc:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1800:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1804:	2f2e2e2f 	svccs	0x002e2e2f
    1808:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 1758 <shift+0x1758>
    180c:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1810:	6f632f63 	svcvs	0x00632f63
    1814:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
    1818:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    181c:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
    1820:	75663162 	strbvc	r3, [r6, #-354]!	; 0xfffffe9e
    1824:	2e73636e 	cdpcs	3, 7, cr6, cr3, cr14, {3}
    1828:	00010053 	andeq	r0, r1, r3, asr r0
    182c:	05000000 	streq	r0, [r0, #-0]
    1830:	00b1a402 	adcseq	sl, r1, r2, lsl #8
    1834:	0bb40300 	bleq	fed0243c <__bss_end+0xfecf6b04>
    1838:	00020201 	andeq	r0, r2, r1, lsl #4
    183c:	01030101 	tsteq	r3, r1, lsl #2
    1840:	00030000 	andeq	r0, r3, r0
    1844:	000000fd 	strdeq	r0, [r0], -sp
    1848:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
    184c:	0101000d 	tsteq	r1, sp
    1850:	00000101 	andeq	r0, r0, r1, lsl #2
    1854:	00000100 	andeq	r0, r0, r0, lsl #2
    1858:	2f2e2e01 	svccs	0x002e2e01
    185c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1860:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1864:	2f2e2e2f 	svccs	0x002e2e2f
    1868:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 17b8 <shift+0x17b8>
    186c:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1870:	2e2e2f63 	cdpcs	15, 2, cr2, cr14, cr3, {3}
    1874:	636e692f 	cmnvs	lr, #770048	; 0xbc000
    1878:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
    187c:	2f2e2e00 	svccs	0x002e2e00
    1880:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1884:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1888:	2f2e2e2f 	svccs	0x002e2e2f
    188c:	63672f2e 	cmnvs	r7, #46, 30	; 0xb8
    1890:	2e2e0063 	cdpcs	0, 2, cr0, cr14, cr3, {3}
    1894:	2f2e2e2f 	svccs	0x002e2e2f
    1898:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    189c:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    18a0:	2f2e2e2f 	svccs	0x002e2e2f
    18a4:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    18a8:	2e2f6363 	cdpcs	3, 2, cr6, cr15, cr3, {3}
    18ac:	63672f2e 	cmnvs	r7, #46, 30	; 0xb8
    18b0:	6f632f63 	svcvs	0x00632f63
    18b4:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
    18b8:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    18bc:	2f2e2e00 	svccs	0x002e2e00
    18c0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    18c4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    18c8:	2f2e2e2f 	svccs	0x002e2e2f
    18cc:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 181c <shift+0x181c>
    18d0:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    18d4:	68000063 	stmdavs	r0, {r0, r1, r5, r6}
    18d8:	74687361 	strbtvc	r7, [r8], #-865	; 0xfffffc9f
    18dc:	682e6261 	stmdavs	lr!, {r0, r5, r6, r9, sp, lr}
    18e0:	00000100 	andeq	r0, r0, r0, lsl #2
    18e4:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    18e8:	2e617369 	cdpcs	3, 6, cr7, cr1, cr9, {3}
    18ec:	00020068 	andeq	r0, r2, r8, rrx
    18f0:	6d726100 	ldfvse	f6, [r2, #-0]
    18f4:	7570632d 	ldrbvc	r6, [r0, #-813]!	; 0xfffffcd3
    18f8:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
    18fc:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
    1900:	632d6e73 			; <UNDEFINED> instruction: 0x632d6e73
    1904:	74736e6f 	ldrbtvc	r6, [r3], #-3695	; 0xfffff191
    1908:	73746e61 	cmnvc	r4, #1552	; 0x610
    190c:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
    1910:	72610000 	rsbvc	r0, r1, #0
    1914:	00682e6d 	rsbeq	r2, r8, sp, ror #28
    1918:	6c000003 	stcvs	0, cr0, [r0], {3}
    191c:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1920:	682e3263 	stmdavs	lr!, {r0, r1, r5, r6, r9, ip, sp}
    1924:	00000400 	andeq	r0, r0, r0, lsl #8
    1928:	2d6c6267 	sfmcs	f6, 2, [ip, #-412]!	; 0xfffffe64
    192c:	726f7463 	rsbvc	r7, pc, #1660944384	; 0x63000000
    1930:	00682e73 	rsbeq	r2, r8, r3, ror lr
    1934:	6c000004 	stcvs	0, cr0, [r0], {4}
    1938:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    193c:	632e3263 			; <UNDEFINED> instruction: 0x632e3263
    1940:	00000400 	andeq	r0, r0, r0, lsl #8
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
      24:	00a48001 	adceq	r8, r4, r1
      28:	00040000 	andeq	r0, r4, r0
      2c:	00000014 	andeq	r0, r0, r4, lsl r0
      30:	00b80104 	adcseq	r0, r8, r4, lsl #2
      34:	6d0c0000 	stcvs	0, cr0, [ip, #-0]
      38:	31000000 	mrscc	r0, (UNDEF: 0)
      3c:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
      40:	9c000080 	stcls	0, cr0, [r0], {128}	; 0x80
      44:	61000000 	mrsvs	r0, (UNDEF: 0)
      48:	02000000 	andeq	r0, r0, #0
      4c:	00000173 	andeq	r0, r0, r3, ror r1
      50:	31150601 	tstcc	r5, r1, lsl #12
      54:	03000000 	movweq	r0, #0
      58:	1e340704 	cdpne	7, 3, cr0, cr4, cr4, {0}
      5c:	ae020000 	cdpge	0, 0, cr0, cr2, cr0, {0}
      60:	01000000 	mrseq	r0, (UNDEF: 0)
      64:	00311507 	eorseq	r1, r1, r7, lsl #10
      68:	7f040000 	svcvc	0x00040000
      6c:	01000001 	tsteq	r0, r1
      70:	8064060f 	rsbhi	r0, r4, pc, lsl #12
      74:	00400000 	subeq	r0, r0, r0
      78:	9c010000 	stcls	0, cr0, [r1], {-0}
      7c:	0000006a 	andeq	r0, r0, sl, rrx
      80:	00016c05 	andeq	r6, r1, r5, lsl #24
      84:	091a0100 	ldmdbeq	sl, {r8}
      88:	0000006a 	andeq	r0, r0, sl, rrx
      8c:	00749102 	rsbseq	r9, r4, r2, lsl #2
      90:	69050406 	stmdbvs	r5, {r1, r2, sl}
      94:	0700746e 	streq	r7, [r0, -lr, ror #8]
      98:	0000009e 	muleq	r0, lr, r0
      9c:	08060901 	stmdaeq	r6, {r0, r8, fp}
      a0:	5c000080 	stcpl	0, cr0, [r0], {128}	; 0x80
      a4:	01000000 	mrseq	r0, (UNDEF: 0)
      a8:	0000a19c 	muleq	r0, ip, r1
      ac:	80140800 	andshi	r0, r4, r0, lsl #16
      b0:	00340000 	eorseq	r0, r4, r0
      b4:	63090000 	movwvs	r0, #36864	; 0x9000
      b8:	01007275 	tsteq	r0, r5, ror r2
      bc:	00a1180b 	adceq	r1, r1, fp, lsl #16
      c0:	91020000 	mrsls	r0, (UNDEF: 2)
      c4:	0a000074 	beq	29c <shift+0x29c>
      c8:	00003104 	andeq	r3, r0, r4, lsl #2
      cc:	02020000 	andeq	r0, r2, #0
      d0:	00040000 	andeq	r0, r4, r0
      d4:	000000b9 	strheq	r0, [r0], -r9
      d8:	023f0104 	eorseq	r0, pc, #4, 2
      dc:	ef040000 	svc	0x00040000
      e0:	31000001 	tstcc	r0, r1
      e4:	a4000000 	strge	r0, [r0], #-0
      e8:	88000080 	stmdahi	r0, {r7}
      ec:	f1000001 	cps	#1
      f0:	02000000 	andeq	r0, r0, #0
      f4:	0000037a 	andeq	r0, r0, sl, ror r3
      f8:	31072f01 	tstcc	r7, r1, lsl #30
      fc:	03000000 	movweq	r0, #0
     100:	00003704 	andeq	r3, r0, r4, lsl #14
     104:	21020400 	tstcs	r2, r0, lsl #8
     108:	01000003 	tsteq	r0, r3
     10c:	00310730 	eorseq	r0, r1, r0, lsr r7
     110:	25050000 	strcs	r0, [r5, #-0]
     114:	57000000 	strpl	r0, [r0, -r0]
     118:	06000000 	streq	r0, [r0], -r0
     11c:	00000057 	andeq	r0, r0, r7, asr r0
     120:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
     124:	07040700 	streq	r0, [r4, -r0, lsl #14]
     128:	00001e34 	andeq	r1, r0, r4, lsr lr
     12c:	00036c08 	andeq	r6, r3, r8, lsl #24
     130:	15330100 	ldrne	r0, [r3, #-256]!	; 0xffffff00
     134:	00000044 	andeq	r0, r0, r4, asr #32
     138:	00034408 	andeq	r4, r3, r8, lsl #8
     13c:	15350100 	ldrne	r0, [r5, #-256]!	; 0xffffff00
     140:	00000044 	andeq	r0, r0, r4, asr #32
     144:	00003805 	andeq	r3, r0, r5, lsl #16
     148:	00008900 	andeq	r8, r0, r0, lsl #18
     14c:	00570600 	subseq	r0, r7, r0, lsl #12
     150:	ffff0000 			; <UNDEFINED> instruction: 0xffff0000
     154:	0800ffff 	stmdaeq	r0, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, fp, ip, sp, lr, pc}
     158:	00000231 	andeq	r0, r0, r1, lsr r2
     15c:	76153801 	ldrvc	r3, [r5], -r1, lsl #16
     160:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
     164:	0000032a 	andeq	r0, r0, sl, lsr #6
     168:	76153a01 	ldrvc	r3, [r5], -r1, lsl #20
     16c:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     170:	000001a9 	andeq	r0, r0, r9, lsr #3
     174:	cb104801 	blgt	412180 <__bss_end+0x406848>
     178:	d4000000 	strle	r0, [r0], #-0
     17c:	58000081 	stmdapl	r0, {r0, r7}
     180:	01000000 	mrseq	r0, (UNDEF: 0)
     184:	0000cb9c 	muleq	r0, ip, fp
     188:	01b70a00 			; <UNDEFINED> instruction: 0x01b70a00
     18c:	4a010000 	bmi	40194 <__bss_end+0x3485c>
     190:	0000d20c 	andeq	sp, r0, ip, lsl #4
     194:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     198:	05040b00 	streq	r0, [r4, #-2816]	; 0xfffff500
     19c:	00746e69 	rsbseq	r6, r4, r9, ror #28
     1a0:	00380403 	eorseq	r0, r8, r3, lsl #8
     1a4:	5f090000 	svcpl	0x00090000
     1a8:	01000003 	tsteq	r0, r3
     1ac:	00cb103c 	sbceq	r1, fp, ip, lsr r0
     1b0:	817c0000 	cmnhi	ip, r0
     1b4:	00580000 	subseq	r0, r8, r0
     1b8:	9c010000 	stcls	0, cr0, [r1], {-0}
     1bc:	00000102 	andeq	r0, r0, r2, lsl #2
     1c0:	0001b70a 	andeq	fp, r1, sl, lsl #14
     1c4:	0c3e0100 	ldfeqs	f0, [lr], #-0
     1c8:	00000102 	andeq	r0, r0, r2, lsl #2
     1cc:	00749102 	rsbseq	r9, r4, r2, lsl #2
     1d0:	00250403 	eoreq	r0, r5, r3, lsl #8
     1d4:	920c0000 	andls	r0, ip, #0
     1d8:	01000001 	tsteq	r0, r1
     1dc:	81701129 	cmnhi	r0, r9, lsr #2
     1e0:	000c0000 	andeq	r0, ip, r0
     1e4:	9c010000 	stcls	0, cr0, [r1], {-0}
     1e8:	0001c80c 	andeq	ip, r1, ip, lsl #16
     1ec:	11240100 			; <UNDEFINED> instruction: 0x11240100
     1f0:	00008158 	andeq	r8, r0, r8, asr r1
     1f4:	00000018 	andeq	r0, r0, r8, lsl r0
     1f8:	370c9c01 	strcc	r9, [ip, -r1, lsl #24]
     1fc:	01000003 	tsteq	r0, r3
     200:	8140111f 	cmphi	r0, pc, lsl r1
     204:	00180000 	andseq	r0, r8, r0
     208:	9c010000 	stcls	0, cr0, [r1], {-0}
     20c:	0002240c 	andeq	r2, r2, ip, lsl #8
     210:	111a0100 	tstne	sl, r0, lsl #2
     214:	00008128 	andeq	r8, r0, r8, lsr #2
     218:	00000018 	andeq	r0, r0, r8, lsl r0
     21c:	bd0d9c01 	stclt	12, cr9, [sp, #-4]
     220:	02000001 	andeq	r0, r0, #1
     224:	00019e00 	andeq	r9, r1, r0, lsl #28
     228:	030f0e00 	movweq	r0, #65024	; 0xfe00
     22c:	14010000 	strne	r0, [r1], #-0
     230:	00016d12 	andeq	r6, r1, r2, lsl sp
     234:	019e0f00 	orrseq	r0, lr, r0, lsl #30
     238:	02000000 	andeq	r0, r0, #0
     23c:	0000018a 	andeq	r0, r0, sl, lsl #3
     240:	a41c0401 	ldrge	r0, [ip], #-1025	; 0xfffffbff
     244:	0e000001 	cdpeq	0, 0, cr0, cr0, cr1, {0}
     248:	000001db 	ldrdeq	r0, [r0], -fp
     24c:	8b120f01 	blhi	483e58 <__bss_end+0x478520>
     250:	0f000001 	svceq	0x00000001
     254:	0000019e 	muleq	r0, lr, r1
     258:	03831000 	orreq	r1, r3, #0
     25c:	0a010000 	beq	40264 <__bss_end+0x3492c>
     260:	0000cb11 	andeq	ip, r0, r1, lsl fp
     264:	019e0f00 	orrseq	r0, lr, r0, lsl #30
     268:	00000000 	andeq	r0, r0, r0
     26c:	016d0403 	cmneq	sp, r3, lsl #8
     270:	08070000 	stmdaeq	r7, {}	; <UNPREDICTABLE>
     274:	00035105 	andeq	r5, r3, r5, lsl #2
     278:	015b1100 	cmpeq	fp, r0, lsl #2
     27c:	81080000 	mrshi	r0, (UNDEF: 8)
     280:	00200000 	eoreq	r0, r0, r0
     284:	9c010000 	stcls	0, cr0, [r1], {-0}
     288:	000001c7 	andeq	r0, r0, r7, asr #3
     28c:	00019e12 	andeq	r9, r1, r2, lsl lr
     290:	74910200 	ldrvc	r0, [r1], #512	; 0x200
     294:	01791100 	cmneq	r9, r0, lsl #2
     298:	80dc0000 	sbcshi	r0, ip, r0
     29c:	002c0000 	eoreq	r0, ip, r0
     2a0:	9c010000 	stcls	0, cr0, [r1], {-0}
     2a4:	000001e8 	andeq	r0, r0, r8, ror #3
     2a8:	01006713 	tsteq	r0, r3, lsl r7
     2ac:	019e300f 	orrseq	r3, lr, pc
     2b0:	91020000 	mrsls	r0, (UNDEF: 2)
     2b4:	8b140074 	blhi	50048c <__bss_end+0x4f4b54>
     2b8:	a4000001 	strge	r0, [r0], #-1
     2bc:	38000080 	stmdacc	r0, {r7}
     2c0:	01000000 	mrseq	r0, (UNDEF: 0)
     2c4:	0067139c 	mlseq	r7, ip, r3, r1
     2c8:	9e2f0a01 	vmulls.f32	s0, s30, s2
     2cc:	02000001 	andeq	r0, r0, #1
     2d0:	00007491 	muleq	r0, r1, r4
     2d4:	000015d2 	ldrdeq	r1, [r0], -r2
     2d8:	01e00004 	mvneq	r0, r4
     2dc:	01040000 	mrseq	r0, (UNDEF: 4)
     2e0:	0000023f 	andeq	r0, r0, pc, lsr r2
     2e4:	0011b104 	andseq	fp, r1, r4, lsl #2
     2e8:	00003100 	andeq	r3, r0, r0, lsl #2
     2ec:	00823000 	addeq	r3, r2, r0
     2f0:	00193000 	andseq	r3, r9, r0
     2f4:	0001d700 	andeq	sp, r1, r0, lsl #14
     2f8:	08010200 	stmdaeq	r1, {r9}
     2fc:	00000d7a 	andeq	r0, r0, sl, ror sp
     300:	00002503 	andeq	r2, r0, r3, lsl #10
     304:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
     308:	00000dbc 			; <UNDEFINED> instruction: 0x00000dbc
     30c:	69050404 	stmdbvs	r5, {r2, sl}
     310:	0200746e 	andeq	r7, r0, #1845493760	; 0x6e000000
     314:	0d710801 	ldcleq	8, cr0, [r1, #-4]!
     318:	02020000 	andeq	r0, r2, #0
     31c:	000a3c07 	andeq	r3, sl, r7, lsl #24
     320:	0e820500 	cdpeq	5, 8, cr0, cr2, cr0, {0}
     324:	090a0000 	stmdbeq	sl, {}	; <UNPREDICTABLE>
     328:	00005e07 	andeq	r5, r0, r7, lsl #28
     32c:	004d0300 	subeq	r0, sp, r0, lsl #6
     330:	04020000 	streq	r0, [r2], #-0
     334:	001e3407 	andseq	r3, lr, r7, lsl #8
     338:	08360600 	ldmdaeq	r6!, {r9, sl}
     33c:	02080000 	andeq	r0, r8, #0
     340:	008b0806 	addeq	r0, fp, r6, lsl #16
     344:	72070000 	andvc	r0, r7, #0
     348:	08020030 	stmdaeq	r2, {r4, r5}
     34c:	00004d0e 	andeq	r4, r0, lr, lsl #26
     350:	72070000 	andvc	r0, r7, #0
     354:	09020031 	stmdbeq	r2, {r0, r4, r5}
     358:	00004d0e 	andeq	r4, r0, lr, lsl #26
     35c:	08000400 	stmdaeq	r0, {sl}
     360:	00000637 	andeq	r0, r0, r7, lsr r6
     364:	00380405 	eorseq	r0, r8, r5, lsl #8
     368:	1f020000 	svcne	0x00020000
     36c:	0000c20c 	andeq	ip, r0, ip, lsl #4
     370:	08b50900 	ldmeq	r5!, {r8, fp}
     374:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     378:	00001289 	andeq	r1, r0, r9, lsl #5
     37c:	12530901 	subsne	r0, r3, #16384	; 0x4000
     380:	09020000 	stmdbeq	r2, {}	; <UNPREDICTABLE>
     384:	00000ab8 			; <UNDEFINED> instruction: 0x00000ab8
     388:	0cb30903 			; <UNDEFINED> instruction: 0x0cb30903
     38c:	09040000 	stmdbeq	r4, {}	; <UNPREDICTABLE>
     390:	00000866 	andeq	r0, r0, r6, ror #16
     394:	d0080005 	andle	r0, r8, r5
     398:	05000010 	streq	r0, [r0, #-16]
     39c:	00003804 	andeq	r3, r0, r4, lsl #16
     3a0:	0c400200 	sfmeq	f0, 2, [r0], {-0}
     3a4:	000000ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     3a8:	0003f609 	andeq	pc, r3, r9, lsl #12
     3ac:	64090000 	strvs	r0, [r9], #-0
     3b0:	01000006 	tsteq	r0, r6
     3b4:	000c8709 	andeq	r8, ip, r9, lsl #14
     3b8:	92090200 	andls	r0, r9, #0, 4
     3bc:	03000011 	movweq	r0, #17
     3c0:	00129309 	andseq	r9, r2, r9, lsl #6
     3c4:	e9090400 	stmdb	r9, {sl}
     3c8:	0500000b 	streq	r0, [r0, #-11]
     3cc:	000a5c09 	andeq	r5, sl, r9, lsl #24
     3d0:	08000600 	stmdaeq	r0, {r9, sl}
     3d4:	0000108a 	andeq	r1, r0, sl, lsl #1
     3d8:	00380405 	eorseq	r0, r8, r5, lsl #8
     3dc:	67020000 	strvs	r0, [r2, -r0]
     3e0:	00012a0c 	andeq	r2, r1, ip, lsl #20
     3e4:	0d3d0900 			; <UNDEFINED> instruction: 0x0d3d0900
     3e8:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     3ec:	00000a10 	andeq	r0, r0, r0, lsl sl
     3f0:	0de30901 			; <UNDEFINED> instruction: 0x0de30901
     3f4:	09020000 	stmdbeq	r2, {}	; <UNPREDICTABLE>
     3f8:	00000a61 	andeq	r0, r0, r1, ror #20
     3fc:	fa080003 	blx	200410 <__bss_end+0x1f4ad8>
     400:	0500000d 	streq	r0, [r0, #-13]
     404:	00003804 	andeq	r3, r0, r4, lsl #16
     408:	0c6f0200 	sfmeq	f0, 2, [pc], #-0	; 410 <shift+0x410>
     40c:	00000143 	andeq	r0, r0, r3, asr #2
     410:	000cae09 	andeq	sl, ip, r9, lsl #28
     414:	0a000000 	beq	41c <shift+0x41c>
     418:	00000c27 	andeq	r0, r0, r7, lsr #24
     41c:	59140503 	ldmdbpl	r4, {r0, r1, r8, sl}
     420:	05000000 	streq	r0, [r0, #-0]
     424:	00b1a803 	adcseq	sl, r1, r3, lsl #16
     428:	0c510a00 	mrrceq	10, 0, r0, r1, cr0
     42c:	06030000 	streq	r0, [r3], -r0
     430:	00005914 	andeq	r5, r0, r4, lsl r9
     434:	ac030500 	cfstr32ge	mvfx0, [r3], {-0}
     438:	0a0000b1 	beq	704 <shift+0x704>
     43c:	00000bc8 	andeq	r0, r0, r8, asr #23
     440:	591a0704 	ldmdbpl	sl, {r2, r8, r9, sl}
     444:	05000000 	streq	r0, [r0, #-0]
     448:	00b1b003 	adcseq	fp, r1, r3
     44c:	06f30a00 	ldrbteq	r0, [r3], r0, lsl #20
     450:	09040000 	stmdbeq	r4, {}	; <UNPREDICTABLE>
     454:	0000591a 	andeq	r5, r0, sl, lsl r9
     458:	b4030500 	strlt	r0, [r3], #-1280	; 0xfffffb00
     45c:	0a0000b1 	beq	728 <shift+0x728>
     460:	00000d51 	andeq	r0, r0, r1, asr sp
     464:	591a0b04 	ldmdbpl	sl, {r2, r8, r9, fp}
     468:	05000000 	streq	r0, [r0, #-0]
     46c:	00b1b803 	adcseq	fp, r1, r3, lsl #16
     470:	09fd0a00 	ldmibeq	sp!, {r9, fp}^
     474:	0d040000 	stceq	0, cr0, [r4, #-0]
     478:	0000591a 	andeq	r5, r0, sl, lsl r9
     47c:	bc030500 	cfstr32lt	mvfx0, [r3], {-0}
     480:	0a0000b1 	beq	74c <shift+0x74c>
     484:	0000084f 	andeq	r0, r0, pc, asr #16
     488:	591a0f04 	ldmdbpl	sl, {r2, r8, r9, sl, fp}
     48c:	05000000 	streq	r0, [r0, #-0]
     490:	00b1c003 	adcseq	ip, r1, r3
     494:	0ecc0800 	cdpeq	8, 12, cr0, cr12, cr0, {0}
     498:	04050000 	streq	r0, [r5], #-0
     49c:	00000038 	andeq	r0, r0, r8, lsr r0
     4a0:	e60c1b04 	str	r1, [ip], -r4, lsl #22
     4a4:	09000001 	stmdbeq	r0, {r0}
     4a8:	00000efe 	strdeq	r0, [r0], -lr
     4ac:	12320900 	eorsne	r0, r2, #0, 18
     4b0:	09010000 	stmdbeq	r1, {}	; <UNPREDICTABLE>
     4b4:	00000c82 	andeq	r0, r0, r2, lsl #25
     4b8:	260b0002 	strcs	r0, [fp], -r2
     4bc:	0c00000d 	stceq	0, cr0, [r0], {13}
     4c0:	00000db0 			; <UNDEFINED> instruction: 0x00000db0
     4c4:	07630490 			; <UNDEFINED> instruction: 0x07630490
     4c8:	00000359 	andeq	r0, r0, r9, asr r3
     4cc:	00116106 	andseq	r6, r1, r6, lsl #2
     4d0:	67042400 	strvs	r2, [r4, -r0, lsl #8]
     4d4:	00027310 	andeq	r7, r2, r0, lsl r3
     4d8:	21a40d00 			; <UNDEFINED> instruction: 0x21a40d00
     4dc:	69040000 	stmdbvs	r4, {}	; <UNPREDICTABLE>
     4e0:	00035912 	andeq	r5, r3, r2, lsl r9
     4e4:	1f0d0000 	svcne	0x000d0000
     4e8:	04000006 	streq	r0, [r0], #-6
     4ec:	0369126b 	cmneq	r9, #-1342177274	; 0xb0000006
     4f0:	0d100000 	ldceq	0, cr0, [r0, #-0]
     4f4:	00000ef3 	strdeq	r0, [r0], -r3
     4f8:	4d166d04 	ldcmi	13, cr6, [r6, #-16]
     4fc:	14000000 	strne	r0, [r0], #-0
     500:	0006ec0d 	andeq	lr, r6, sp, lsl #24
     504:	1c700400 	cfldrdne	mvd0, [r0], #-0
     508:	00000370 	andeq	r0, r0, r0, ror r3
     50c:	0d480d18 	stcleq	13, cr0, [r8, #-96]	; 0xffffffa0
     510:	72040000 	andvc	r0, r4, #0
     514:	0003701c 	andeq	r7, r3, ip, lsl r0
     518:	f20d1c00 			; <UNDEFINED> instruction: 0xf20d1c00
     51c:	04000005 	streq	r0, [r0], #-5
     520:	03701c75 	cmneq	r0, #29952	; 0x7500
     524:	0e200000 	cdpeq	0, 2, cr0, cr0, cr0, {0}
     528:	000008bd 			; <UNDEFINED> instruction: 0x000008bd
     52c:	691c7704 	ldmdbvs	ip, {r2, r8, r9, sl, ip, sp, lr}
     530:	70000004 	andvc	r0, r0, r4
     534:	67000003 	strvs	r0, [r0, -r3]
     538:	0f000002 	svceq	0x00000002
     53c:	00000370 	andeq	r0, r0, r0, ror r3
     540:	00037610 	andeq	r7, r3, r0, lsl r6
     544:	06000000 	streq	r0, [r0], -r0
     548:	0000079c 	muleq	r0, ip, r7
     54c:	107b0418 	rsbsne	r0, fp, r8, lsl r4
     550:	000002a8 	andeq	r0, r0, r8, lsr #5
     554:	0021a40d 	eoreq	sl, r1, sp, lsl #8
     558:	127e0400 	rsbsne	r0, lr, #0, 8
     55c:	00000359 	andeq	r0, r0, r9, asr r3
     560:	060f0d00 	streq	r0, [pc], -r0, lsl #26
     564:	80040000 	andhi	r0, r4, r0
     568:	00037619 	andeq	r7, r3, r9, lsl r6
     56c:	980d1000 	stmdals	sp, {ip}
     570:	04000011 	streq	r0, [r0], #-17	; 0xffffffef
     574:	03812182 	orreq	r2, r1, #-2147483616	; 0x80000020
     578:	00140000 	andseq	r0, r4, r0
     57c:	00027303 	andeq	r7, r2, r3, lsl #6
     580:	0b6e1100 	bleq	1b84988 <__bss_end+0x1b79050>
     584:	86040000 	strhi	r0, [r4], -r0
     588:	00038721 	andeq	r8, r3, r1, lsr #14
     58c:	09791100 	ldmdbeq	r9!, {r8, ip}^
     590:	88040000 	stmdahi	r4, {}	; <UNPREDICTABLE>
     594:	0000591f 	andeq	r5, r0, pc, lsl r9
     598:	0e330d00 	cdpeq	13, 3, cr0, cr3, cr0, {0}
     59c:	8b040000 	blhi	1005a4 <__bss_end+0xf4c6c>
     5a0:	0001f817 	andeq	pc, r1, r7, lsl r8	; <UNPREDICTABLE>
     5a4:	be0d0000 	cdplt	0, 0, cr0, cr13, cr0, {0}
     5a8:	0400000a 	streq	r0, [r0], #-10
     5ac:	01f8178e 	mvnseq	r1, lr, lsl #15
     5b0:	0d240000 	stceq	0, cr0, [r4, #-0]
     5b4:	00000994 	muleq	r0, r4, r9
     5b8:	f8178f04 			; <UNDEFINED> instruction: 0xf8178f04
     5bc:	48000001 	stmdami	r0, {r0}
     5c0:	0012730d 	andseq	r7, r2, sp, lsl #6
     5c4:	17900400 	ldrne	r0, [r0, r0, lsl #8]
     5c8:	000001f8 	strdeq	r0, [r0], -r8
     5cc:	0db0126c 	lfmeq	f1, 4, [r0, #432]!	; 0x1b0
     5d0:	93040000 	movwls	r0, #16384	; 0x4000
     5d4:	00078709 	andeq	r8, r7, r9, lsl #14
     5d8:	00039200 	andeq	r9, r3, r0, lsl #4
     5dc:	03120100 	tsteq	r2, #0, 2
     5e0:	03180000 	tsteq	r8, #0
     5e4:	920f0000 	andls	r0, pc, #0
     5e8:	00000003 	andeq	r0, r0, r3
     5ec:	000b6313 	andeq	r6, fp, r3, lsl r3
     5f0:	0e960400 	cdpeq	4, 9, cr0, cr6, cr0, {0}
     5f4:	00000a8b 	andeq	r0, r0, fp, lsl #21
     5f8:	00032d01 	andeq	r2, r3, r1, lsl #26
     5fc:	00033300 	andeq	r3, r3, r0, lsl #6
     600:	03920f00 	orrseq	r0, r2, #0, 30
     604:	14000000 	strne	r0, [r0], #-0
     608:	000003f6 	strdeq	r0, [r0], -r6
     60c:	b1109904 	tstlt	r0, r4, lsl #18
     610:	9800000e 	stmdals	r0, {r1, r2, r3}
     614:	01000003 	tsteq	r0, r3
     618:	00000348 	andeq	r0, r0, r8, asr #6
     61c:	0003920f 	andeq	r9, r3, pc, lsl #4
     620:	03761000 	cmneq	r6, #0
     624:	c1100000 	tstgt	r0, r0
     628:	00000001 	andeq	r0, r0, r1
     62c:	00251500 	eoreq	r1, r5, r0, lsl #10
     630:	03690000 	cmneq	r9, #0
     634:	5e160000 	cdppl	0, 1, cr0, cr6, cr0, {0}
     638:	0f000000 	svceq	0x00000000
     63c:	02010200 	andeq	r0, r1, #0, 4
     640:	00000ac8 	andeq	r0, r0, r8, asr #21
     644:	01f80417 	mvnseq	r0, r7, lsl r4
     648:	04170000 	ldreq	r0, [r7], #-0
     64c:	0000002c 	andeq	r0, r0, ip, lsr #32
     650:	0011ec0b 	andseq	lr, r1, fp, lsl #24
     654:	7c041700 	stcvc	7, cr1, [r4], {-0}
     658:	15000003 	strne	r0, [r0, #-3]
     65c:	000002a8 	andeq	r0, r0, r8, lsr #5
     660:	00000392 	muleq	r0, r2, r3
     664:	04170018 	ldreq	r0, [r7], #-24	; 0xffffffe8
     668:	000001eb 	andeq	r0, r0, fp, ror #3
     66c:	01e60417 	mvneq	r0, r7, lsl r4
     670:	39190000 	ldmdbcc	r9, {}	; <UNPREDICTABLE>
     674:	0400000e 	streq	r0, [r0], #-14
     678:	01eb149c 			; <UNDEFINED> instruction: 0x01eb149c
     67c:	1c0a0000 	stcne	0, cr0, [sl], {-0}
     680:	05000009 	streq	r0, [r0, #-9]
     684:	00591404 	subseq	r1, r9, r4, lsl #8
     688:	03050000 	movweq	r0, #20480	; 0x5000
     68c:	0000b1c4 	andeq	fp, r0, r4, asr #3
     690:	0003e00a 	andeq	lr, r3, sl
     694:	14070500 	strne	r0, [r7], #-1280	; 0xfffffb00
     698:	00000059 	andeq	r0, r0, r9, asr r0
     69c:	b1c80305 	biclt	r0, r8, r5, lsl #6
     6a0:	630a0000 	movwvs	r0, #40960	; 0xa000
     6a4:	05000007 	streq	r0, [r0, #-7]
     6a8:	0059140a 	subseq	r1, r9, sl, lsl #8
     6ac:	03050000 	movweq	r0, #20480	; 0x5000
     6b0:	0000b1cc 	andeq	fp, r0, ip, asr #3
     6b4:	000b1808 	andeq	r1, fp, r8, lsl #16
     6b8:	38040500 	stmdacc	r4, {r8, sl}
     6bc:	05000000 	streq	r0, [r0, #-0]
     6c0:	04170c0d 	ldreq	r0, [r7], #-3085	; 0xfffff3f3
     6c4:	4e1a0000 	cdpmi	0, 1, cr0, cr10, cr0, {0}
     6c8:	00007765 	andeq	r7, r0, r5, ror #14
     6cc:	000b0f09 	andeq	r0, fp, r9, lsl #30
     6d0:	45090100 	strmi	r0, [r9, #-256]	; 0xffffff00
     6d4:	0200000e 	andeq	r0, r0, #14
     6d8:	000ae709 	andeq	lr, sl, r9, lsl #14
     6dc:	aa090300 	bge	2412e4 <__bss_end+0x2359ac>
     6e0:	0400000a 	streq	r0, [r0], #-10
     6e4:	000c8d09 	andeq	r8, ip, r9, lsl #26
     6e8:	06000500 	streq	r0, [r0], -r0, lsl #10
     6ec:	00000859 	andeq	r0, r0, r9, asr r8
     6f0:	081b0510 	ldmdaeq	fp, {r4, r8, sl}
     6f4:	00000456 	andeq	r0, r0, r6, asr r4
     6f8:	00726c07 	rsbseq	r6, r2, r7, lsl #24
     6fc:	56131d05 	ldrpl	r1, [r3], -r5, lsl #26
     700:	00000004 	andeq	r0, r0, r4
     704:	00707307 	rsbseq	r7, r0, r7, lsl #6
     708:	56131e05 	ldrpl	r1, [r3], -r5, lsl #28
     70c:	04000004 	streq	r0, [r0], #-4
     710:	00637007 	rsbeq	r7, r3, r7
     714:	56131f05 	ldrpl	r1, [r3], -r5, lsl #30
     718:	08000004 	stmdaeq	r0, {r2}
     71c:	0008750d 	andeq	r7, r8, sp, lsl #10
     720:	13200500 	nopne	{0}	; <UNPREDICTABLE>
     724:	00000456 	andeq	r0, r0, r6, asr r4
     728:	0402000c 	streq	r0, [r2], #-12
     72c:	001e2f07 	andseq	r2, lr, r7, lsl #30
     730:	04480600 	strbeq	r0, [r8], #-1536	; 0xfffffa00
     734:	05800000 	streq	r0, [r0]
     738:	05200828 	streq	r0, [r0, #-2088]!	; 0xfffff7d8
     73c:	7d0d0000 	stcvc	0, cr0, [sp, #-0]
     740:	05000012 	streq	r0, [r0, #-18]	; 0xffffffee
     744:	0417122a 	ldreq	r1, [r7], #-554	; 0xfffffdd6
     748:	07000000 	streq	r0, [r0, -r0]
     74c:	00646970 	rsbeq	r6, r4, r0, ror r9
     750:	5e122b05 	vnmlspl.f64	d2, d2, d5
     754:	10000000 	andne	r0, r0, r0
     758:	001b800d 	andseq	r8, fp, sp
     75c:	112c0500 			; <UNDEFINED> instruction: 0x112c0500
     760:	000003e0 	andeq	r0, r0, r0, ror #7
     764:	0b390d14 	bleq	e43bbc <__bss_end+0xe38284>
     768:	2d050000 	stccs	0, cr0, [r5, #-0]
     76c:	00005e12 	andeq	r5, r0, r2, lsl lr
     770:	470d1800 	strmi	r1, [sp, -r0, lsl #16]
     774:	0500000b 	streq	r0, [r0, #-11]
     778:	005e122e 	subseq	r1, lr, lr, lsr #4
     77c:	0d1c0000 	ldceq	0, cr0, [ip, #-0]
     780:	00000842 	andeq	r0, r0, r2, asr #16
     784:	200c2f05 	andcs	r2, ip, r5, lsl #30
     788:	20000005 	andcs	r0, r0, r5
     78c:	000b7a0d 	andeq	r7, fp, sp, lsl #20
     790:	09300500 	ldmdbeq	r0!, {r8, sl}
     794:	00000038 	andeq	r0, r0, r8, lsr r0
     798:	0f210d60 	svceq	0x00210d60
     79c:	31050000 	mrscc	r0, (UNDEF: 5)
     7a0:	00004d0e 	andeq	r4, r0, lr, lsl #26
     7a4:	dd0d6400 	cfstrsle	mvf6, [sp, #-0]
     7a8:	05000008 	streq	r0, [r0, #-8]
     7ac:	004d0e33 	subeq	r0, sp, r3, lsr lr
     7b0:	0d680000 	stcleq	0, cr0, [r8, #-0]
     7b4:	000008d4 	ldrdeq	r0, [r0], -r4
     7b8:	4d0e3405 	cfstrsmi	mvf3, [lr, #-20]	; 0xffffffec
     7bc:	6c000000 	stcvs	0, cr0, [r0], {-0}
     7c0:	00747007 	rsbseq	r7, r4, r7
     7c4:	300c3605 	andcc	r3, ip, r5, lsl #12
     7c8:	70000005 	andvc	r0, r0, r5
     7cc:	0010750d 	andseq	r7, r0, sp, lsl #10
     7d0:	0e370500 	cfabs32eq	mvfx0, mvfx7
     7d4:	0000004d 	andeq	r0, r0, sp, asr #32
     7d8:	05260d74 	streq	r0, [r6, #-3444]!	; 0xfffff28c
     7dc:	38050000 	stmdacc	r5, {}	; <UNPREDICTABLE>
     7e0:	00004d0e 	andeq	r4, r0, lr, lsl #26
     7e4:	3d0d7800 	stccc	8, cr7, [sp, #-0]
     7e8:	05000012 	streq	r0, [r0, #-18]	; 0xffffffee
     7ec:	004d0e39 	subeq	r0, sp, r9, lsr lr
     7f0:	007c0000 	rsbseq	r0, ip, r0
     7f4:	00039815 	andeq	r9, r3, r5, lsl r8
     7f8:	00053000 	andeq	r3, r5, r0
     7fc:	005e1600 	subseq	r1, lr, r0, lsl #12
     800:	000f0000 	andeq	r0, pc, r0
     804:	004d0417 	subeq	r0, sp, r7, lsl r4
     808:	520a0000 	andpl	r0, sl, #0
     80c:	06000011 			; <UNDEFINED> instruction: 0x06000011
     810:	0059140a 	subseq	r1, r9, sl, lsl #8
     814:	03050000 	movweq	r0, #20480	; 0x5000
     818:	0000b1d0 	ldrdeq	fp, [r0], -r0
     81c:	000aef08 	andeq	lr, sl, r8, lsl #30
     820:	38040500 	stmdacc	r4, {r8, sl}
     824:	06000000 	streq	r0, [r0], -r0
     828:	05670c0d 	strbeq	r0, [r7, #-3085]!	; 0xfffff3f3
     82c:	75090000 	strvc	r0, [r9, #-0]
     830:	00000006 	andeq	r0, r0, r6
     834:	0003d509 	andeq	sp, r3, r9, lsl #10
     838:	06000100 	streq	r0, [r0], -r0, lsl #2
     83c:	00001038 	andeq	r1, r0, r8, lsr r0
     840:	081b060c 	ldmdaeq	fp, {r2, r3, r9, sl}
     844:	0000059c 	muleq	r0, ip, r5
     848:	00041a0d 	andeq	r1, r4, sp, lsl #20
     84c:	191d0600 	ldmdbne	sp, {r9, sl}
     850:	0000059c 	muleq	r0, ip, r5
     854:	05f20d00 	ldrbeq	r0, [r2, #3328]!	; 0xd00
     858:	1e060000 	cdpne	0, 0, cr0, cr6, cr0, {0}
     85c:	00059c19 	andeq	r9, r5, r9, lsl ip
     860:	9e0d0400 	cfcpysls	mvf0, mvf13
     864:	0600000f 	streq	r0, [r0], -pc
     868:	05a2131f 	streq	r1, [r2, #799]!	; 0x31f
     86c:	00080000 	andeq	r0, r8, r0
     870:	05670417 	strbeq	r0, [r7, #-1047]!	; 0xfffffbe9
     874:	04170000 	ldreq	r0, [r7], #-0
     878:	0000045d 	andeq	r0, r0, sp, asr r4
     87c:	0007760c 	andeq	r7, r7, ip, lsl #12
     880:	22061400 	andcs	r1, r6, #0, 8
     884:	00085e07 	andeq	r5, r8, r7, lsl #28
     888:	0add0d00 	beq	ff743c90 <__bss_end+0xff738358>
     88c:	26060000 	strcs	r0, [r6], -r0
     890:	00004d12 	andeq	r4, r0, r2, lsl sp
     894:	430d0000 	movwmi	r0, #53248	; 0xd000
     898:	06000005 	streq	r0, [r0], -r5
     89c:	059c1d29 	ldreq	r1, [ip, #3369]	; 0xd29
     8a0:	0d040000 	stceq	0, cr0, [r4, #-0]
     8a4:	00000e9e 	muleq	r0, lr, lr
     8a8:	9c1d2c06 	ldcls	12, cr2, [sp], {6}
     8ac:	08000005 	stmdaeq	r0, {r0, r2}
     8b0:	0010c61b 	andseq	ip, r0, fp, lsl r6
     8b4:	0e2f0600 	cfmadda32eq	mvax0, mvax0, mvfx15, mvfx0
     8b8:	00001015 	andeq	r1, r0, r5, lsl r0
     8bc:	000005f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     8c0:	000005fb 	strdeq	r0, [r0], -fp
     8c4:	0008630f 	andeq	r6, r8, pc, lsl #6
     8c8:	059c1000 	ldreq	r1, [ip]
     8cc:	1c000000 	stcne	0, cr0, [r0], {-0}
     8d0:	00000fc2 	andeq	r0, r0, r2, asr #31
     8d4:	1f0e3106 	svcne	0x000e3106
     8d8:	69000004 	stmdbvs	r0, {r2}
     8dc:	13000003 	movwne	r0, #3
     8e0:	1e000006 	cdpne	0, 0, cr0, cr0, cr6, {0}
     8e4:	0f000006 	svceq	0x00000006
     8e8:	00000863 	andeq	r0, r0, r3, ror #16
     8ec:	0005a210 	andeq	sl, r5, r0, lsl r2
     8f0:	60120000 	andsvs	r0, r2, r0
     8f4:	06000010 			; <UNDEFINED> instruction: 0x06000010
     8f8:	0f791d35 	svceq	0x00791d35
     8fc:	059c0000 	ldreq	r0, [ip]
     900:	37020000 	strcc	r0, [r2, -r0]
     904:	3d000006 	stccc	0, cr0, [r0, #-24]	; 0xffffffe8
     908:	0f000006 	svceq	0x00000006
     90c:	00000863 	andeq	r0, r0, r3, ror #16
     910:	0a4f1200 	beq	13c5118 <__bss_end+0x13b97e0>
     914:	37060000 	strcc	r0, [r6, -r0]
     918:	000d8a1d 	andeq	r8, sp, sp, lsl sl
     91c:	00059c00 	andeq	r9, r5, r0, lsl #24
     920:	06560200 	ldrbeq	r0, [r6], -r0, lsl #4
     924:	065c0000 	ldrbeq	r0, [ip], -r0
     928:	630f0000 	movwvs	r0, #61440	; 0xf000
     92c:	00000008 	andeq	r0, r0, r8
     930:	000b9e1d 	andeq	r9, fp, sp, lsl lr
     934:	31390600 	teqcc	r9, r0, lsl #12
     938:	0000087c 	andeq	r0, r0, ip, ror r8
     93c:	7612020c 	ldrvc	r0, [r2], -ip, lsl #4
     940:	06000007 	streq	r0, [r0], -r7
     944:	1259093c 	subsne	r0, r9, #60, 18	; 0xf0000
     948:	08630000 	stmdaeq	r3!, {}^	; <UNPREDICTABLE>
     94c:	83010000 	movwhi	r0, #4096	; 0x1000
     950:	89000006 	stmdbhi	r0, {r1, r2}
     954:	0f000006 	svceq	0x00000006
     958:	00000863 	andeq	r0, r0, r3, ror #16
     95c:	06921200 	ldreq	r1, [r2], r0, lsl #4
     960:	3f060000 	svccc	0x00060000
     964:	00109b12 	andseq	r9, r0, r2, lsl fp
     968:	00004d00 	andeq	r4, r0, r0, lsl #26
     96c:	06a20100 	strteq	r0, [r2], r0, lsl #2
     970:	06b70000 	ldrteq	r0, [r7], r0
     974:	630f0000 	movwvs	r0, #61440	; 0xf000
     978:	10000008 	andne	r0, r0, r8
     97c:	00000885 	andeq	r0, r0, r5, lsl #17
     980:	00005e10 	andeq	r5, r0, r0, lsl lr
     984:	03691000 	cmneq	r9, #0
     988:	13000000 	movwne	r0, #0
     98c:	00000fd1 	ldrdeq	r0, [r0], -r1
     990:	d80e4206 	stmdale	lr, {r1, r2, r9, lr}
     994:	0100000c 	tsteq	r0, ip
     998:	000006cc 	andeq	r0, r0, ip, asr #13
     99c:	000006d2 	ldrdeq	r0, [r0], -r2
     9a0:	0008630f 	andeq	r6, r8, pc, lsl #6
     9a4:	9e120000 	cdpls	0, 1, cr0, cr2, cr0, {0}
     9a8:	06000009 	streq	r0, [r0], -r9
     9ac:	056b1745 	strbeq	r1, [fp, #-1861]!	; 0xfffff8bb
     9b0:	05a20000 	streq	r0, [r2, #0]!
     9b4:	eb010000 	bl	409bc <__bss_end+0x35084>
     9b8:	f1000006 	cps	#6
     9bc:	0f000006 	svceq	0x00000006
     9c0:	0000088b 	andeq	r0, r0, fp, lsl #17
     9c4:	05fc1200 	ldrbeq	r1, [ip, #512]!	; 0x200
     9c8:	48060000 	stmdami	r6, {}	; <UNPREDICTABLE>
     9cc:	000f2d17 	andeq	r2, pc, r7, lsl sp	; <UNPREDICTABLE>
     9d0:	0005a200 	andeq	sl, r5, r0, lsl #4
     9d4:	070a0100 	streq	r0, [sl, -r0, lsl #2]
     9d8:	07150000 	ldreq	r0, [r5, -r0]
     9dc:	8b0f0000 	blhi	3c09e4 <__bss_end+0x3b50ac>
     9e0:	10000008 	andne	r0, r0, r8
     9e4:	0000004d 	andeq	r0, r0, sp, asr #32
     9e8:	116f1300 	cmnne	pc, r0, lsl #6
     9ec:	4b060000 	blmi	1809f4 <__bss_end+0x1750bc>
     9f0:	000fe60e 	andeq	lr, pc, lr, lsl #12
     9f4:	072a0100 	streq	r0, [sl, -r0, lsl #2]!
     9f8:	07300000 	ldreq	r0, [r0, -r0]!
     9fc:	630f0000 	movwvs	r0, #61440	; 0xf000
     a00:	00000008 	andeq	r0, r0, r8
     a04:	000fc212 	andeq	ip, pc, r2, lsl r2	; <UNPREDICTABLE>
     a08:	0e4d0600 	cdpeq	6, 4, cr0, cr13, cr0, {0}
     a0c:	0000088d 	andeq	r0, r0, sp, lsl #17
     a10:	00000369 	andeq	r0, r0, r9, ror #6
     a14:	00074901 	andeq	r4, r7, r1, lsl #18
     a18:	00075400 	andeq	r5, r7, r0, lsl #8
     a1c:	08630f00 	stmdaeq	r3!, {r8, r9, sl, fp}^
     a20:	4d100000 	ldcmi	0, cr0, [r0, #-0]
     a24:	00000000 	andeq	r0, r0, r0
     a28:	0009d212 	andeq	sp, r9, r2, lsl r2
     a2c:	12500600 	subsne	r0, r0, #0, 12
     a30:	00000cf9 	strdeq	r0, [r0], -r9
     a34:	0000004d 	andeq	r0, r0, sp, asr #32
     a38:	00076d01 	andeq	r6, r7, r1, lsl #26
     a3c:	00077800 	andeq	r7, r7, r0, lsl #16
     a40:	08630f00 	stmdaeq	r3!, {r8, r9, sl, fp}^
     a44:	98100000 	ldmdals	r0, {}	; <UNPREDICTABLE>
     a48:	00000003 	andeq	r0, r0, r3
     a4c:	0004b812 	andeq	fp, r4, r2, lsl r8
     a50:	0e530600 	cdpeq	6, 5, cr0, cr3, cr0, {0}
     a54:	00000935 	andeq	r0, r0, r5, lsr r9
     a58:	00000369 	andeq	r0, r0, r9, ror #6
     a5c:	00079101 	andeq	r9, r7, r1, lsl #2
     a60:	00079c00 	andeq	r9, r7, r0, lsl #24
     a64:	08630f00 	stmdaeq	r3!, {r8, r9, sl, fp}^
     a68:	4d100000 	ldcmi	0, cr0, [r0, #-0]
     a6c:	00000000 	andeq	r0, r0, r0
     a70:	000a2913 	andeq	r2, sl, r3, lsl r9
     a74:	0e560600 	cdpeq	6, 5, cr0, cr6, cr0, {0}
     a78:	000004d4 	ldrdeq	r0, [r0], -r4
     a7c:	0007b101 	andeq	fp, r7, r1, lsl #2
     a80:	0007d000 	andeq	sp, r7, r0
     a84:	08630f00 	stmdaeq	r3!, {r8, r9, sl, fp}^
     a88:	8b100000 	blhi	400a90 <__bss_end+0x3f5158>
     a8c:	10000000 	andne	r0, r0, r0
     a90:	0000004d 	andeq	r0, r0, sp, asr #32
     a94:	00004d10 	andeq	r4, r0, r0, lsl sp
     a98:	004d1000 	subeq	r1, sp, r0
     a9c:	91100000 	tstls	r0, r0
     aa0:	00000008 	andeq	r0, r0, r8
     aa4:	000f6313 	andeq	r6, pc, r3, lsl r3	; <UNPREDICTABLE>
     aa8:	0e580600 	cdpeq	6, 5, cr0, cr8, cr0, {0}
     aac:	000007ea 	andeq	r0, r0, sl, ror #15
     ab0:	0007e501 	andeq	lr, r7, r1, lsl #10
     ab4:	00080400 	andeq	r0, r8, r0, lsl #8
     ab8:	08630f00 	stmdaeq	r3!, {r8, r9, sl, fp}^
     abc:	c2100000 	andsgt	r0, r0, #0
     ac0:	10000000 	andne	r0, r0, r0
     ac4:	0000004d 	andeq	r0, r0, sp, asr #32
     ac8:	00004d10 	andeq	r4, r0, r0, lsl sp
     acc:	004d1000 	subeq	r1, sp, r0
     ad0:	91100000 	tstls	r0, r0
     ad4:	00000008 	andeq	r0, r0, r8
     ad8:	000d5f13 	andeq	r5, sp, r3, lsl pc
     adc:	0e5b0600 	cdpeq	6, 5, cr0, cr11, cr0, {0}
     ae0:	000010fa 	strdeq	r1, [r0], -sl
     ae4:	00081901 	andeq	r1, r8, r1, lsl #18
     ae8:	00083800 	andeq	r3, r8, r0, lsl #16
     aec:	08630f00 	stmdaeq	r3!, {r8, r9, sl, fp}^
     af0:	2a100000 	bcs	400af8 <__bss_end+0x3f51c0>
     af4:	10000001 	andne	r0, r0, r1
     af8:	0000004d 	andeq	r0, r0, sp, asr #32
     afc:	00004d10 	andeq	r4, r0, r0, lsl sp
     b00:	004d1000 	subeq	r1, sp, r0
     b04:	91100000 	tstls	r0, r0
     b08:	00000008 	andeq	r0, r0, r8
     b0c:	00075014 	andeq	r5, r7, r4, lsl r0
     b10:	0e5e0600 	cdpeq	6, 5, cr0, cr14, cr0, {0}
     b14:	000007a7 	andeq	r0, r0, r7, lsr #15
     b18:	00000369 	andeq	r0, r0, r9, ror #6
     b1c:	00084d01 	andeq	r4, r8, r1, lsl #26
     b20:	08630f00 	stmdaeq	r3!, {r8, r9, sl, fp}^
     b24:	48100000 	ldmdami	r0, {}	; <UNPREDICTABLE>
     b28:	10000005 	andne	r0, r0, r5
     b2c:	00000897 	muleq	r0, r7, r8
     b30:	a8030000 	stmdage	r3, {}	; <UNPREDICTABLE>
     b34:	17000005 	strne	r0, [r0, -r5]
     b38:	0005a804 	andeq	sl, r5, r4, lsl #16
     b3c:	059c1e00 	ldreq	r1, [ip, #3584]	; 0xe00
     b40:	08760000 	ldmdaeq	r6!, {}^	; <UNPREDICTABLE>
     b44:	087c0000 	ldmdaeq	ip!, {}^	; <UNPREDICTABLE>
     b48:	630f0000 	movwvs	r0, #61440	; 0xf000
     b4c:	00000008 	andeq	r0, r0, r8
     b50:	0005a81f 	andeq	sl, r5, pc, lsl r8
     b54:	00086900 	andeq	r6, r8, r0, lsl #18
     b58:	3f041700 	svccc	0x00041700
     b5c:	17000000 	strne	r0, [r0, -r0]
     b60:	00085e04 	andeq	r5, r8, r4, lsl #28
     b64:	65042000 	strvs	r2, [r4, #-0]
     b68:	21000000 	mrscs	r0, (UNDEF: 0)
     b6c:	0bbc1904 	bleq	fef06f84 <__bss_end+0xfeefb64c>
     b70:	61060000 	mrsvs	r0, (UNDEF: 6)
     b74:	0005a819 	andeq	sl, r5, r9, lsl r8
     b78:	0bac0c00 	bleq	feb03b80 <__bss_end+0xfeaf8248>
     b7c:	07880000 	streq	r0, [r8, r0]
     b80:	09b00707 	ldmibeq	r0!, {r0, r1, r2, r8, r9, sl}
     b84:	1a0d0000 	bne	340b8c <__bss_end+0x335254>
     b88:	0700000f 	streq	r0, [r0, -pc]
     b8c:	09b00e0b 	ldmibeq	r0!, {r0, r1, r3, r9, sl, fp}
     b90:	0d000000 	stceq	0, cr0, [r0, #-0]
     b94:	00000bde 	ldrdeq	r0, [r0], -lr
     b98:	4d120e07 	ldcmi	14, cr0, [r2, #-28]	; 0xffffffe4
     b9c:	80000000 	andhi	r0, r0, r0
     ba0:	000fda0d 	andeq	sp, pc, sp, lsl #20
     ba4:	120f0700 	andne	r0, pc, #0, 14
     ba8:	0000004d 	andeq	r0, r0, sp, asr #32
     bac:	0bac1284 	bleq	feb055c4 <__bss_end+0xfeaf9c8c>
     bb0:	13070000 	movwne	r0, #28672	; 0x7000
     bb4:	000bfb09 	andeq	pc, fp, r9, lsl #22
     bb8:	0009c000 	andeq	ip, r9, r0
     bbc:	08f20100 	ldmeq	r2!, {r8}^
     bc0:	08f80000 	ldmeq	r8!, {}^	; <UNPREDICTABLE>
     bc4:	c00f0000 	andgt	r0, pc, r0
     bc8:	00000009 	andeq	r0, r0, r9
     bcc:	00118d12 	andseq	r8, r1, r2, lsl sp
     bd0:	12160700 	andsne	r0, r6, #0, 14
     bd4:	00000715 	andeq	r0, r0, r5, lsl r7
     bd8:	0000004d 	andeq	r0, r0, sp, asr #32
     bdc:	00091101 	andeq	r1, r9, r1, lsl #2
     be0:	00091c00 	andeq	r1, r9, r0, lsl #24
     be4:	09c00f00 	stmibeq	r0, {r8, r9, sl, fp}^
     be8:	c6100000 	ldrgt	r0, [r0], -r0
     bec:	00000009 	andeq	r0, r0, r9
     bf0:	00118d12 	andseq	r8, r1, r2, lsl sp
     bf4:	12190700 	andsne	r0, r9, #0, 14
     bf8:	000005c8 	andeq	r0, r0, r8, asr #11
     bfc:	0000004d 	andeq	r0, r0, sp, asr #32
     c00:	00093501 	andeq	r3, r9, r1, lsl #10
     c04:	00094500 	andeq	r4, r9, r0, lsl #10
     c08:	09c00f00 	stmibeq	r0, {r8, r9, sl, fp}^
     c0c:	c6100000 	ldrgt	r0, [r0], -r0
     c10:	10000009 	andne	r0, r0, r9
     c14:	0000004d 	andeq	r0, r0, sp, asr #32
     c18:	12281200 	eorne	r1, r8, #0, 4
     c1c:	1c070000 	stcne	0, cr0, [r7], {-0}
     c20:	00039712 	andeq	r9, r3, r2, lsl r7
     c24:	00004d00 	andeq	r4, r0, r0, lsl #26
     c28:	095e0100 	ldmdbeq	lr, {r8}^
     c2c:	096e0000 	stmdbeq	lr!, {}^	; <UNPREDICTABLE>
     c30:	c00f0000 	andgt	r0, pc, r0
     c34:	10000009 	andne	r0, r0, r9
     c38:	00000025 	andeq	r0, r0, r5, lsr #32
     c3c:	0009c610 	andeq	ip, r9, r0, lsl r6
     c40:	5d130000 	ldcpl	0, cr0, [r3, #-0]
     c44:	0700000b 	streq	r0, [r0, -fp]
     c48:	0e0e0e1f 	mcreq	14, 0, r0, cr14, cr15, {0}
     c4c:	83010000 	movwhi	r0, #4096	; 0x1000
     c50:	93000009 	movwls	r0, #9
     c54:	0f000009 	svceq	0x00000009
     c58:	000009c0 	andeq	r0, r0, r0, asr #19
     c5c:	0009c610 	andeq	ip, r9, r0, lsl r6
     c60:	004d1000 	subeq	r1, sp, r0
     c64:	22000000 	andcs	r0, r0, #0
     c68:	00000b5d 	andeq	r0, r0, sp, asr fp
     c6c:	c60e2207 	strgt	r2, [lr], -r7, lsl #4
     c70:	0100000d 	tsteq	r0, sp
     c74:	000009a4 	andeq	r0, r0, r4, lsr #19
     c78:	0009c00f 	andeq	ip, r9, pc
     c7c:	00251000 	eoreq	r1, r5, r0
     c80:	00000000 	andeq	r0, r0, r0
     c84:	00002515 	andeq	r2, r0, r5, lsl r5
     c88:	0009c000 	andeq	ip, r9, r0
     c8c:	005e1600 	subseq	r1, lr, r0, lsl #12
     c90:	007f0000 	rsbseq	r0, pc, r0
     c94:	08a50417 	stmiaeq	r5!, {r0, r1, r2, r4, sl}
     c98:	04170000 	ldreq	r0, [r7], #-0
     c9c:	00000025 	andeq	r0, r0, r5, lsr #32
     ca0:	0005380c 	andeq	r3, r5, ip, lsl #16
     ca4:	08088800 	stmdaeq	r8, {fp, pc}
     ca8:	000a2f07 	andeq	r2, sl, r7, lsl #30
     cac:	62630700 	rsbvs	r0, r3, #0, 14
     cb0:	190c0800 	stmdbne	ip, {fp}
     cb4:	000008a5 	andeq	r0, r0, r5, lsr #17
     cb8:	05381200 	ldreq	r1, [r8, #-512]!	; 0xfffffe00
     cbc:	10080000 	andne	r0, r8, r0
     cc0:	0005a509 	andeq	sl, r5, r9, lsl #10
     cc4:	000a2f00 	andeq	r2, sl, r0, lsl #30
     cc8:	09fe0100 	ldmibeq	lr!, {r8}^
     ccc:	0a040000 	beq	100cd4 <__bss_end+0xf539c>
     cd0:	2f0f0000 	svccs	0x000f0000
     cd4:	0000000a 	andeq	r0, r0, sl
     cd8:	000c1414 	andeq	r1, ip, r4, lsl r4
     cdc:	12130800 	andsne	r0, r3, #0, 16
     ce0:	00000732 	andeq	r0, r0, r2, lsr r7
     ce4:	0000004d 	andeq	r0, r0, sp, asr #32
     ce8:	000a1901 	andeq	r1, sl, r1, lsl #18
     cec:	0a2f0f00 	beq	bc48f4 <__bss_end+0xbb8fbc>
     cf0:	c6100000 	ldrgt	r0, [r0], -r0
     cf4:	10000009 	andne	r0, r0, r9
     cf8:	0000004d 	andeq	r0, r0, sp, asr #32
     cfc:	00036910 	andeq	r6, r3, r0, lsl r9
     d00:	17000000 	strne	r0, [r0, -r0]
     d04:	0009cc04 	andeq	ip, r9, r4, lsl #24
     d08:	03fb0800 	mvnseq	r0, #0, 16
     d0c:	04050000 	streq	r0, [r5], #-0
     d10:	00000038 	andeq	r0, r0, r8, lsr r0
     d14:	540c0309 	strpl	r0, [ip], #-777	; 0xfffffcf7
     d18:	0900000a 	stmdbeq	r0, {r1, r3}
     d1c:	00000905 	andeq	r0, r0, r5, lsl #18
     d20:	090c0900 	stmdbeq	ip, {r8, fp}
     d24:	00010000 	andeq	r0, r1, r0
     d28:	0008f508 	andeq	pc, r8, r8, lsl #10
     d2c:	38040500 	stmdacc	r4, {r8, sl}
     d30:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     d34:	0aa10c09 	beq	fe843d60 <__bss_end+0xfe838428>
     d38:	4a230000 	bmi	8c0d40 <__bss_end+0x8b5408>
     d3c:	b0000011 	andlt	r0, r0, r1, lsl r0
     d40:	04122304 	ldreq	r2, [r2], #-772	; 0xfffffcfc
     d44:	09600000 	stmdbeq	r0!, {}^	; <UNPREDICTABLE>
     d48:	0005b923 	andeq	fp, r5, r3, lsr #18
     d4c:	2312c000 	tstcs	r2, #0
     d50:	00001185 	andeq	r1, r0, r5, lsl #3
     d54:	ad232580 	cfstr32ge	mvfx2, [r3, #-512]!	; 0xfffffe00
     d58:	0000000f 	andeq	r0, r0, pc
     d5c:	0b24234b 	bleq	909a90 <__bss_end+0x8fe158>
     d60:	96000000 	strls	r0, [r0], -r0
     d64:	0003ba23 	andeq	fp, r3, r3, lsr #20
     d68:	24e10000 	strbtcs	r0, [r1], #0
     d6c:	00000b84 	andeq	r0, r0, r4, lsl #23
     d70:	0001c200 	andeq	ip, r1, r0, lsl #4
     d74:	12130800 	andsne	r0, r3, #0, 16
     d78:	04050000 	streq	r0, [r5], #-0
     d7c:	00000038 	andeq	r0, r0, r8, lsr r0
     d80:	be0c1b09 	vmlalt.f64	d1, d12, d9
     d84:	1a00000a 	bne	db4 <shift+0xdb4>
     d88:	00005852 	andeq	r5, r0, r2, asr r8
     d8c:	0058541a 	subseq	r5, r8, sl, lsl r4
     d90:	6f060001 	svcvs	0x00060001
     d94:	0c00000c 	stceq	0, cr0, [r0], {12}
     d98:	f3082209 	vhsub.u8	d2, d8, d9
     d9c:	0d00000a 	stceq	0, cr0, [r0, #-40]	; 0xffffffd8
     da0:	000006a1 	andeq	r0, r0, r1, lsr #13
     da4:	a11a2409 	tstge	sl, r9, lsl #8
     da8:	0000000a 	andeq	r0, r0, sl
     dac:	000ee70d 	andeq	lr, lr, sp, lsl #14
     db0:	17250900 	strne	r0, [r5, -r0, lsl #18]!
     db4:	00000a35 	andeq	r0, r0, r5, lsr sl
     db8:	05610d04 	strbeq	r0, [r1, #-3332]!	; 0xfffff2fc
     dbc:	26090000 	strcs	r0, [r9], -r0
     dc0:	000a5415 	andeq	r5, sl, r5, lsl r4
     dc4:	25000800 	strcs	r0, [r0, #-2048]	; 0xfffff800
     dc8:	000009c1 	andeq	r0, r0, r1, asr #19
     dcc:	4d0a0901 	vstrmi.16	s0, [sl, #-2]	; <UNPREDICTABLE>
     dd0:	05000000 	streq	r0, [r0, #-0]
     dd4:	00b46803 	adcseq	r6, r4, r3, lsl #16
     dd8:	040d2500 	streq	r2, [sp], #-1280	; 0xfffffb00
     ddc:	0a010000 	beq	40de4 <__bss_end+0x354ac>
     de0:	00004d0a 	andeq	r4, r0, sl, lsl #26
     de4:	6c030500 	cfstr32vs	mvfx0, [r3], {-0}
     de8:	250000b4 	strcs	r0, [r0, #-180]	; 0xffffff4c
     dec:	00000b2d 	andeq	r0, r0, sp, lsr #22
     df0:	29070c01 	stmdbcs	r7, {r0, sl, fp}
     df4:	0500000b 	streq	r0, [r0, #-11]
     df8:	00b47003 	adcseq	r7, r4, r3
     dfc:	04040200 	streq	r0, [r4], #-512	; 0xfffffe00
     e00:	00001bfe 	strdeq	r1, [r0], -lr
     e04:	00059925 	andeq	r9, r5, r5, lsr #18
     e08:	080e0100 	stmdaeq	lr, {r8}
     e0c:	00000b42 	andeq	r0, r0, r2, asr #22
     e10:	b4740305 	ldrbtlt	r0, [r4], #-773	; 0xfffffcfb
     e14:	04170000 	ldreq	r0, [r7], #-0
     e18:	00000b29 	andeq	r0, r0, r9, lsr #22
     e1c:	00104b25 	andseq	r4, r0, r5, lsr #22
     e20:	0a100100 	beq	401228 <__bss_end+0x3f58f0>
     e24:	0000004d 	andeq	r0, r0, sp, asr #32
     e28:	b4780305 	ldrbtlt	r0, [r8], #-773	; 0xfffffcfb
     e2c:	5a250000 	bpl	940e34 <__bss_end+0x9354fc>
     e30:	0100000f 	tsteq	r0, pc
     e34:	004d0a12 	subeq	r0, sp, r2, lsl sl
     e38:	03050000 	movweq	r0, #20480	; 0x5000
     e3c:	0000b464 	andeq	fp, r0, r4, ror #8
     e40:	000e5c26 	andeq	r5, lr, r6, lsr #24
     e44:	10140100 	andsne	r0, r4, r0, lsl #2
     e48:	00000059 	andeq	r0, r0, r9, asr r0
     e4c:	b1d40305 	bicslt	r0, r4, r5, lsl #6
     e50:	a3260000 			; <UNDEFINED> instruction: 0xa3260000
     e54:	0100000f 	tsteq	r0, pc
     e58:	00591015 	subseq	r1, r9, r5, lsl r0
     e5c:	03050000 	movweq	r0, #20480	; 0x5000
     e60:	0000b1d8 	ldrdeq	fp, [r0], -r8
     e64:	000b2915 	andeq	r2, fp, r5, lsl r9
     e68:	000ba000 	andeq	sl, fp, r0
     e6c:	005e1600 	subseq	r1, lr, r0, lsl #12
     e70:	00310000 	eorseq	r0, r1, r0
     e74:	00062b25 	andeq	r2, r6, r5, lsr #22
     e78:	07170100 	ldreq	r0, [r7, -r0, lsl #2]
     e7c:	00000b90 	muleq	r0, r0, fp
     e80:	b47c0305 	ldrbtlt	r0, [ip], #-773	; 0xfffffcfb
     e84:	8b250000 	blhi	940e8c <__bss_end+0x935554>
     e88:	0100000e 	tsteq	r0, lr
     e8c:	0b900718 	bleq	fe402af4 <__bss_end+0xfe3f71bc>
     e90:	03050000 	movweq	r0, #20480	; 0x5000
     e94:	0000b544 	andeq	fp, r0, r4, asr #10
     e98:	00064c25 	andeq	r4, r6, r5, lsr #24
     e9c:	07190100 	ldreq	r0, [r9, -r0, lsl #2]
     ea0:	00000b90 	muleq	r0, r0, fp
     ea4:	b60c0305 	strlt	r0, [ip], -r5, lsl #6
     ea8:	58250000 	stmdapl	r5!, {}	; <UNPREDICTABLE>
     eac:	01000006 	tsteq	r0, r6
     eb0:	0b90071a 	bleq	fe402b20 <__bss_end+0xfe3f71e8>
     eb4:	03050000 	movweq	r0, #20480	; 0x5000
     eb8:	0000b6d4 	ldrdeq	fp, [r0], -r4
     ebc:	0003c925 	andeq	ip, r3, r5, lsr #18
     ec0:	071b0100 	ldreq	r0, [fp, -r0, lsl #2]
     ec4:	00000b90 	muleq	r0, r0, fp
     ec8:	b79c0305 	ldrlt	r0, [ip, r5, lsl #6]
     ecc:	dc250000 	stcle	0, cr0, [r5], #-0
     ed0:	0100000e 	tsteq	r0, lr
     ed4:	004d0a1d 	subeq	r0, sp, sp, lsl sl
     ed8:	03050000 	movweq	r0, #20480	; 0x5000
     edc:	0000b864 	andeq	fp, r0, r4, ror #16
     ee0:	000e4d25 	andeq	r4, lr, r5, lsr #26
     ee4:	061f0100 	ldreq	r0, [pc], -r0, lsl #2
     ee8:	00000369 	andeq	r0, r0, r9, ror #6
     eec:	b8680305 	stmdalt	r8!, {r0, r2, r8, r9}^
     ef0:	25150000 	ldrcs	r0, [r5, #-0]
     ef4:	2e000000 	cdpcs	0, 0, cr0, cr0, cr0, {0}
     ef8:	1600000c 	strne	r0, [r0], -ip
     efc:	0000005e 	andeq	r0, r0, lr, asr r0
     f00:	5225001f 	eorpl	r0, r5, #31
     f04:	0100000e 	tsteq	r0, lr
     f08:	0c1e0621 	ldceq	6, cr0, [lr], {33}	; 0x21
     f0c:	03050000 	movweq	r0, #20480	; 0x5000
     f10:	0000b86c 	andeq	fp, r0, ip, ror #16
     f14:	000e9725 	andeq	r9, lr, r5, lsr #14
     f18:	0c230100 	stfeqs	f0, [r3], #-0
     f1c:	000009cc 	andeq	r0, r0, ip, asr #19
     f20:	b88c0305 	stmlt	ip, {r0, r2, r8, r9}
     f24:	cb250000 	blgt	940f2c <__bss_end+0x9355f4>
     f28:	01000004 	tsteq	r0, r4
     f2c:	004d0a25 	subeq	r0, sp, r5, lsr #20
     f30:	03050000 	movweq	r0, #20480	; 0x5000
     f34:	0000b914 	andeq	fp, r0, r4, lsl r9
     f38:	646e7227 	strbtvs	r7, [lr], #-551	; 0xfffffdd9
     f3c:	0a270100 	beq	9c1344 <__bss_end+0x9b5a0c>
     f40:	0000004d 	andeq	r0, r0, sp, asr #32
     f44:	b9180305 	ldmdblt	r8, {r0, r2, r8, r9}
     f48:	e6250000 	strt	r0, [r5], -r0
     f4c:	01000009 	tsteq	r0, r9
     f50:	004d0a28 	subeq	r0, sp, r8, lsr #20
     f54:	03050000 	movweq	r0, #20480	; 0x5000
     f58:	0000b91c 	andeq	fp, r0, ip, lsl r9
     f5c:	000c9825 	andeq	r9, ip, r5, lsr #16
     f60:	082b0100 	stmdaeq	fp!, {r8}
     f64:	00000b42 	andeq	r0, r0, r2, asr #22
     f68:	b9200305 	stmdblt	r0!, {r0, r2, r8, r9}
     f6c:	94250000 	strtls	r0, [r5], #-0
     f70:	0100000c 	tsteq	r0, ip
     f74:	0b42082d 	bleq	1083030 <__bss_end+0x10776f8>
     f78:	03050000 	movweq	r0, #20480	; 0x5000
     f7c:	0000b924 	andeq	fp, r0, r4, lsr #18
     f80:	00049926 	andeq	r9, r4, r6, lsr #18
     f84:	10300100 	eorsne	r0, r0, r0, lsl #2
     f88:	00000059 	andeq	r0, r0, r9, asr r0
     f8c:	b1dc0305 	bicslt	r0, ip, r5, lsl #6
     f90:	a4260000 	strtge	r0, [r6], #-0
     f94:	01000011 	tsteq	r0, r1, lsl r0
     f98:	00591032 	subseq	r1, r9, r2, lsr r0
     f9c:	03050000 	movweq	r0, #20480	; 0x5000
     fa0:	0000b1e0 	andeq	fp, r0, r0, ror #3
     fa4:	0009b228 	andeq	fp, r9, r8, lsr #4
     fa8:	009b4400 	addseq	r4, fp, r0, lsl #8
     fac:	00001c00 	andeq	r1, r0, r0, lsl #24
     fb0:	299c0100 	ldmibcs	ip, {r8}
     fb4:	000006b9 			; <UNDEFINED> instruction: 0x000006b9
     fb8:	00009ab0 			; <UNDEFINED> instruction: 0x00009ab0
     fbc:	00000094 	muleq	r0, r4, r0
     fc0:	0d139c01 	ldceq	12, cr9, [r3, #-4]
     fc4:	e62a0000 	strt	r0, [sl], -r0
     fc8:	01000008 	tsteq	r0, r8
     fcc:	38010208 	stmdacc	r1, {r3, r9}
     fd0:	02000000 	andeq	r0, r0, #0
     fd4:	7f2a7491 	svcvc	0x002a7491
     fd8:	0100000d 	tsteq	r0, sp
     fdc:	38010208 	stmdacc	r1, {r3, r9}
     fe0:	02000000 	andeq	r0, r0, #0
     fe4:	2b007091 	blcs	1d230 <__bss_end+0x118f8>
     fe8:	0000124e 	andeq	r1, r0, lr, asr #4
     fec:	0501c501 	streq	ip, [r1, #-1281]	; 0xfffffaff
     ff0:	00000038 	andeq	r0, r0, r8, lsr r0
     ff4:	00009890 	muleq	r0, r0, r8
     ff8:	00000220 	andeq	r0, r0, r0, lsr #4
     ffc:	0de99c01 	stcleq	12, cr9, [r9, #4]!
    1000:	9f2a0000 	svcls	0x002a0000
    1004:	01000011 	tsteq	r0, r1, lsl r0
    1008:	380e01c5 	stmdacc	lr, {r0, r2, r6, r7, r8}
    100c:	02000000 	andeq	r0, r0, #0
    1010:	7f2a4c91 	svcvc	0x002a4c91
    1014:	01000010 	tsteq	r0, r0, lsl r0
    1018:	e91b01c5 	ldmdb	fp, {r0, r2, r6, r7, r8}
    101c:	0200000d 	andeq	r0, r0, #13
    1020:	6c2c4891 	stcvs	8, cr4, [ip], #-580	; 0xfffffdbc
    1024:	01006e65 	tsteq	r0, r5, ror #28
    1028:	4d0e01ca 	stfmis	f0, [lr, #-808]	; 0xfffffcd8
    102c:	2d000000 	stccs	0, cr0, [r0, #-0]
    1030:	00000c9d 	muleq	r0, sp, ip
    1034:	1501cf01 	strne	ip, [r1, #-3841]	; 0xfffff0ff
    1038:	00000abe 			; <UNDEFINED> instruction: 0x00000abe
    103c:	2d549102 	ldfcsp	f1, [r4, #-8]
    1040:	00000e77 	andeq	r0, r0, r7, ror lr
    1044:	0e01d801 	cdpeq	8, 0, cr13, cr1, cr1, {0}
    1048:	00000376 	andeq	r0, r0, r6, ror r3
    104c:	2d749102 	ldfcsp	f1, [r4, #-8]!
    1050:	000005eb 	andeq	r0, r0, fp, ror #11
    1054:	0b01da01 	bleq	77860 <__bss_end+0x6bf28>
    1058:	00000b29 	andeq	r0, r0, r9, lsr #22
    105c:	2d689102 	stfcsp	f1, [r8, #-8]!
    1060:	00000c1d 	andeq	r0, r0, sp, lsl ip
    1064:	0e01e001 	cdpeq	0, 0, cr14, cr1, cr1, {0}
    1068:	00000376 	andeq	r0, r0, r6, ror r3
    106c:	2e709102 	expcss	f1, f2
    1070:	00000000 	andeq	r0, r0, r0
    1074:	006e692f 	rsbeq	r6, lr, pc, lsr #18
    1078:	0c01e501 	cfstr32eq	mvfx14, [r1], {1}
    107c:	0000004d 	andeq	r0, r0, sp, asr #32
    1080:	306c9102 	rsbcc	r9, ip, r2, lsl #2
    1084:	00009998 	muleq	r0, r8, r9
    1088:	00000024 	andeq	r0, r0, r4, lsr #32
    108c:	00000dcd 	andeq	r0, r0, sp, asr #27
    1090:	000c1d2d 	andeq	r1, ip, sp, lsr #26
    1094:	01ee0100 	mvneq	r0, r0, lsl #2
    1098:	00037610 	andeq	r7, r3, r0, lsl r6
    109c:	60910200 	addsvs	r0, r1, r0, lsl #4
    10a0:	99bc3100 	ldmibls	ip!, {r8, ip, sp}
    10a4:	00780000 	rsbseq	r0, r8, r0
    10a8:	eb2d0000 	bl	b410b0 <__bss_end+0xb35778>
    10ac:	01000003 	tsteq	r0, r3
    10b0:	c60a01f6 			; <UNDEFINED> instruction: 0xc60a01f6
    10b4:	02000009 	andeq	r0, r0, #9
    10b8:	00006491 	muleq	r0, r1, r4
    10bc:	c6041700 	strgt	r1, [r4], -r0, lsl #14
    10c0:	32000009 	andcc	r0, r0, #9
    10c4:	00000bf0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    10c8:	0601a101 	streq	sl, [r1], -r1, lsl #2
    10cc:	00000e67 	andeq	r0, r0, r7, ror #28
    10d0:	00009650 	andeq	r9, r0, r0, asr r6
    10d4:	00000240 	andeq	r0, r0, r0, asr #4
    10d8:	0e519c01 	cdpeq	12, 5, cr9, cr1, cr1, {0}
    10dc:	612f0000 			; <UNDEFINED> instruction: 0x612f0000
    10e0:	01a40100 			; <UNDEFINED> instruction: 0x01a40100
    10e4:	0009c608 	andeq	ip, r9, r8, lsl #12
    10e8:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    10ec:	0100622f 	tsteq	r0, pc, lsr #4
    10f0:	c60901a5 	strgt	r0, [r9], -r5, lsr #3
    10f4:	02000009 	andeq	r0, r0, #9
    10f8:	632f7091 			; <UNDEFINED> instruction: 0x632f7091
    10fc:	01a60100 			; <UNDEFINED> instruction: 0x01a60100
    1100:	0009c609 	andeq	ip, r9, r9, lsl #12
    1104:	6c910200 	lfmvs	f0, 4, [r1], {0}
    1108:	0100642f 	tsteq	r0, pc, lsr #8
    110c:	c60901a7 	strgt	r0, [r9], -r7, lsr #3
    1110:	02000009 	andeq	r0, r0, #9
    1114:	652f6891 	strvs	r6, [pc, #-2193]!	; 88b <shift+0x88b>
    1118:	01a80100 			; <UNDEFINED> instruction: 0x01a80100
    111c:	0009c609 	andeq	ip, r9, r9, lsl #12
    1120:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1124:	14503300 	ldrbne	r3, [r0], #-768	; 0xfffffd00
    1128:	35010000 	strcc	r0, [r1, #-0]
    112c:	0ca40701 	stceq	7, cr0, [r4], #4
    1130:	0b290000 	bleq	a41138 <__bss_end+0xa35800>
    1134:	90100000 	andsls	r0, r0, r0
    1138:	06400000 	strbeq	r0, [r0], -r0
    113c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1140:	00001010 	andeq	r1, r0, r0, lsl r0
    1144:	00098b2d 	andeq	r8, r9, sp, lsr #22
    1148:	01370100 	teqeq	r7, r0, lsl #2
    114c:	000b2908 	andeq	r2, fp, r8, lsl #18
    1150:	bc910300 	ldclt	3, cr0, [r1], {0}
    1154:	69662f7f 	stmdbvs	r6!, {r0, r1, r2, r3, r4, r5, r6, r8, r9, sl, fp, sp}^
    1158:	37010074 	smlsdxcc	r1, r4, r0, r0
    115c:	0b291201 	bleq	a45968 <__bss_end+0xa3a030>
    1160:	91030000 	mrsls	r0, (UNDEF: 3)
    1164:	082d7fb8 	stmdaeq	sp!, {r3, r4, r5, r7, r8, r9, sl, fp, ip, sp, lr}
    1168:	0100000f 	tsteq	r0, pc
    116c:	29170137 	ldmdbcs	r7, {r0, r1, r2, r4, r5, r8}
    1170:	0200000b 	andeq	r0, r0, #11
    1174:	eb2d6491 	bl	b5a3c0 <__bss_end+0xb4ea88>
    1178:	01000005 	tsteq	r0, r5
    117c:	291d0137 	ldmdbcs	sp, {r0, r1, r2, r4, r5, r8}
    1180:	0200000b 	andeq	r0, r0, #11
    1184:	af346091 	svcge	0x00346091
    1188:	01000006 	tsteq	r0, r6
    118c:	38060138 	stmdacc	r6, {r3, r4, r5, r8}
    1190:	2f000000 	svccs	0x00000000
    1194:	00706d74 	rsbseq	r6, r0, r4, ror sp
    1198:	08014701 	stmdaeq	r1, {r0, r8, r9, sl, lr}
    119c:	00001010 	andeq	r1, r0, r0, lsl r0
    11a0:	7f989103 	svcvc	0x00989103
    11a4:	0006e32d 	andeq	lr, r6, sp, lsr #6
    11a8:	01970100 	orrseq	r0, r7, r0, lsl #2
    11ac:	0009c608 	andeq	ip, r9, r8, lsl #12
    11b0:	ac910300 	ldcge	3, cr0, [r1], {0}
    11b4:	90bc307f 	adcsls	r3, ip, pc, ror r0
    11b8:	002c0000 	eoreq	r0, ip, r0
    11bc:	0efd0000 	cdpeq	0, 15, cr0, cr13, cr0, {0}
    11c0:	692f0000 	stmdbvs	pc!, {}	; <UNPREDICTABLE>
    11c4:	01410100 	mrseq	r0, (UNDEF: 81)
    11c8:	0000380c 	andeq	r3, r0, ip, lsl #16
    11cc:	5c910200 	lfmpl	f0, 4, [r1], {0}
    11d0:	915c3100 	cmpls	ip, r0, lsl #2
    11d4:	04480000 	strbeq	r0, [r8], #-0
    11d8:	692f0000 	stmdbvs	pc!, {}	; <UNPREDICTABLE>
    11dc:	014f0100 	mrseq	r0, (UNDEF: 95)
    11e0:	0000380b 	andeq	r3, r0, fp, lsl #16
    11e4:	58910200 	ldmpl	r1, {r9}
    11e8:	00917031 	addseq	r7, r1, r1, lsr r0
    11ec:	00042400 	andeq	r2, r4, r0, lsl #8
    11f0:	106c2d00 	rsbne	r2, ip, r0, lsl #26
    11f4:	51010000 	mrspl	r0, (UNDEF: 1)
    11f8:	00380701 	eorseq	r0, r8, r1, lsl #14
    11fc:	91020000 	mrsls	r0, (UNDEF: 2)
    1200:	05f72d40 	ldrbeq	r2, [r7, #3392]!	; 0xd40
    1204:	52010000 	andpl	r0, r1, #0
    1208:	10100901 	andsne	r0, r0, r1, lsl #18
    120c:	91030000 	mrsls	r0, (UNDEF: 3)
    1210:	f4307f84 			; <UNDEFINED> instruction: 0xf4307f84
    1214:	2c000091 	stccs	0, cr0, [r0], {145}	; 0x91
    1218:	8d000001 	stchi	0, cr0, [r0, #-4]
    121c:	2f00000f 	svccs	0x0000000f
    1220:	5b01006a 	blpl	413d0 <__bss_end+0x35a98>
    1224:	00380c01 	eorseq	r0, r8, r1, lsl #24
    1228:	91020000 	mrsls	r0, (UNDEF: 2)
    122c:	92083154 	andls	r3, r8, #84, 2
    1230:	01080000 	mrseq	r0, (UNDEF: 8)
    1234:	a02d0000 	eorge	r0, sp, r0
    1238:	01000005 	tsteq	r0, r5
    123c:	100a015c 	andne	r0, sl, ip, asr r1
    1240:	03000010 	movweq	r0, #16
    1244:	317ef091 			; <UNDEFINED> instruction: 0x317ef091
    1248:	000092c4 	andeq	r9, r0, r4, asr #5
    124c:	0000004c 	andeq	r0, r0, ip, asr #32
    1250:	01006b2f 	tsteq	r0, pc, lsr #22
    1254:	380e016c 	stmdacc	lr, {r2, r3, r5, r6, r8}
    1258:	02000000 	andeq	r0, r0, #0
    125c:	00005091 	muleq	r0, r1, r0
    1260:	938c3000 	orrls	r3, ip, #0
    1264:	00a80000 	adceq	r0, r8, r0
    1268:	0fda0000 	svceq	0x00da0000
    126c:	692f0000 	stmdbvs	pc!, {}	; <UNPREDICTABLE>
    1270:	01760100 	cmneq	r6, r0, lsl #2
    1274:	0000380c 	andeq	r3, r0, ip, lsl #16
    1278:	4c910200 	lfmmi	f0, 4, [r1], {0}
    127c:	0093a031 	addseq	sl, r3, r1, lsr r0
    1280:	00008400 	andeq	r8, r0, r0, lsl #8
    1284:	006a2f00 	rsbeq	r2, sl, r0, lsl #30
    1288:	0d017901 	vstreq.16	s14, [r1, #-2]	; <UNPREDICTABLE>
    128c:	00000038 	andeq	r0, r0, r8, lsr r0
    1290:	31489102 	cmpcc	r8, r2, lsl #2
    1294:	000093d4 	ldrdeq	r9, [r0], -r4
    1298:	00000040 	andeq	r0, r0, r0, asr #32
    129c:	0100612f 	tsteq	r0, pc, lsr #2
    12a0:	3809017b 	stmdacc	r9, {r0, r1, r3, r4, r5, r6, r8}
    12a4:	03000000 	movweq	r0, #0
    12a8:	007fb491 			; <UNDEFINED> instruction: 0x007fb491
    12ac:	34310000 	ldrtcc	r0, [r1], #-0
    12b0:	a8000094 	stmdage	r0, {r2, r4, r7}
    12b4:	2f000000 	svccs	0x00000000
    12b8:	81010069 	tsthi	r1, r9, rrx
    12bc:	00380c01 	eorseq	r0, r8, r1, lsl #24
    12c0:	91020000 	mrsls	r0, (UNDEF: 2)
    12c4:	94703144 	ldrbtls	r3, [r0], #-324	; 0xfffffebc
    12c8:	005c0000 	subseq	r0, ip, r0
    12cc:	c12d0000 			; <UNDEFINED> instruction: 0xc12d0000
    12d0:	01000005 	tsteq	r0, r5
    12d4:	290b0185 	stmdbcs	fp, {r0, r2, r7, r8}
    12d8:	0300000b 	movweq	r0, #11
    12dc:	007fb091 			; <UNDEFINED> instruction: 0x007fb091
    12e0:	00000000 	andeq	r0, r0, r0
    12e4:	000b2915 	andeq	r2, fp, r5, lsl r9
    12e8:	00102000 	andseq	r2, r0, r0
    12ec:	005e1600 	subseq	r1, lr, r0, lsl #12
    12f0:	00040000 	andeq	r0, r4, r0
    12f4:	0008c833 	andeq	ip, r8, r3, lsr r8
    12f8:	01260100 			; <UNDEFINED> instruction: 0x01260100
    12fc:	000a7907 	andeq	r7, sl, r7, lsl #18
    1300:	000b2900 	andeq	r2, fp, r0, lsl #18
    1304:	008e9400 	addeq	r9, lr, r0, lsl #8
    1308:	00017c00 	andeq	r7, r1, r0, lsl #24
    130c:	989c0100 	ldmls	ip, {r8}
    1310:	2a000010 	bcs	1358 <shift+0x1358>
    1314:	00000c9d 	muleq	r0, sp, ip
    1318:	1a012601 	bne	4ab24 <__bss_end+0x3f1ec>
    131c:	00000b42 	andeq	r0, r0, r2, asr #22
    1320:	2f4c9102 	svccs	0x004c9102
    1324:	006d7573 	rsbeq	r7, sp, r3, ror r5
    1328:	08012701 	stmdaeq	r1, {r0, r8, r9, sl, sp}
    132c:	00000b29 	andeq	r0, r0, r9, lsr #22
    1330:	2d5c9102 	ldfcsp	f1, [ip, #-8]
    1334:	000010e8 	andeq	r1, r0, r8, ror #1
    1338:	08012801 	stmdaeq	r1, {r0, fp, sp}
    133c:	00000b29 	andeq	r0, r0, r9, lsr #22
    1340:	2d549102 	ldfcsp	f1, [r4, #-8]
    1344:	00001057 	andeq	r1, r0, r7, asr r0
    1348:	14012801 	strne	r2, [r1], #-2049	; 0xfffff7ff
    134c:	00000b29 	andeq	r0, r0, r9, lsr #22
    1350:	31509102 	cmpcc	r0, r2, lsl #2
    1354:	00008eb0 			; <UNDEFINED> instruction: 0x00008eb0
    1358:	00000138 	andeq	r0, r0, r8, lsr r1
    135c:	0100692f 	tsteq	r0, pc, lsr #18
    1360:	380b012a 	stmdacc	fp, {r1, r3, r5, r8}
    1364:	02000000 	andeq	r0, r0, #0
    1368:	00005891 	muleq	r0, r1, r8
    136c:	00096133 	andeq	r6, r9, r3, lsr r1
    1370:	011c0100 	tsteq	ip, r0, lsl #2
    1374:	00096607 	andeq	r6, r9, r7, lsl #12
    1378:	000b2900 	andeq	r2, fp, r0, lsl #18
    137c:	008dfc00 	addeq	pc, sp, r0, lsl #24
    1380:	00009800 	andeq	r9, r0, r0, lsl #16
    1384:	3a9c0100 	bcc	fe70178c <__bss_end+0xfe6f5e54>
    1388:	35000011 	strcc	r0, [r0, #-17]	; 0xffffffef
    138c:	1c010078 	stcne	0, cr0, [r1], {120}	; 0x78
    1390:	00381001 	eorseq	r1, r8, r1
    1394:	91020000 	mrsls	r0, (UNDEF: 2)
    1398:	0079355c 	rsbseq	r3, r9, ip, asr r5
    139c:	19011c01 	stmdbne	r1, {r0, sl, fp, ip}
    13a0:	00000b29 	andeq	r0, r0, r9, lsr #22
    13a4:	2a589102 	bcs	16257b4 <__bss_end+0x1619e7c>
    13a8:	00000455 	andeq	r0, r0, r5, asr r4
    13ac:	22011c01 	andcs	r1, r1, #256	; 0x100
    13b0:	00000b29 	andeq	r0, r0, r9, lsr #22
    13b4:	2a549102 	bcs	15257c4 <__bss_end+0x1519e8c>
    13b8:	00000c9d 	muleq	r0, sp, ip
    13bc:	2f011c01 	svccs	0x00011c01
    13c0:	00000b42 	andeq	r0, r0, r2, asr #22
    13c4:	2f509102 	svccs	0x00509102
    13c8:	1d010061 	stcne	0, cr0, [r1, #-388]	; 0xfffffe7c
    13cc:	0b290801 	bleq	a433d8 <__bss_end+0xa37aa0>
    13d0:	91020000 	mrsls	r0, (UNDEF: 2)
    13d4:	00622f74 	rsbeq	r2, r2, r4, ror pc
    13d8:	08011e01 	stmdaeq	r1, {r0, r9, sl, fp, ip}
    13dc:	00000b29 	andeq	r0, r0, r9, lsr #22
    13e0:	2f709102 	svccs	0x00709102
    13e4:	1f010063 	svcne	0x00010063
    13e8:	0b290801 	bleq	a433f4 <__bss_end+0xa37abc>
    13ec:	91020000 	mrsls	r0, (UNDEF: 2)
    13f0:	00642f6c 	rsbeq	r2, r4, ip, ror #30
    13f4:	08012001 	stmdaeq	r1, {r0, sp}
    13f8:	00000b29 	andeq	r0, r0, r9, lsr #22
    13fc:	2f689102 	svccs	0x00689102
    1400:	21010065 	tstcs	r1, r5, rrx
    1404:	0b290801 	bleq	a43410 <__bss_end+0xa37ad8>
    1408:	91020000 	mrsls	r0, (UNDEF: 2)
    140c:	cb320064 	blgt	c815a4 <__bss_end+0xc75c6c>
    1410:	0100000c 	tsteq	r0, ip
    1414:	5d060113 	stfpls	f0, [r6, #-76]	; 0xffffffb4
    1418:	2c00000c 	stccs	0, cr0, [r0], {12}
    141c:	d000008d 	andle	r0, r0, sp, lsl #1
    1420:	01000000 	mrseq	r0, (UNDEF: 0)
    1424:	0011669c 	mulseq	r1, ip, r6
    1428:	0be32a00 	bleq	ff8cbc30 <__bss_end+0xff8c02f8>
    142c:	13010000 	movwne	r0, #4096	; 0x1000
    1430:	00381701 	eorseq	r1, r8, r1, lsl #14
    1434:	91020000 	mrsls	r0, (UNDEF: 2)
    1438:	0d330074 	ldceq	0, cr0, [r3, #-464]!	; 0xfffffe30
    143c:	0100000f 	tsteq	r0, pc
    1440:	3e050105 	adfccs	f0, f5, f5
    1444:	3800000c 	stmdacc	r0, {r2, r3}
    1448:	88000000 	stmdahi	r0, {}	; <UNPREDICTABLE>
    144c:	a400008c 	strge	r0, [r0], #-140	; 0xffffff74
    1450:	01000000 	mrseq	r0, (UNDEF: 0)
    1454:	0011b69c 	mulseq	r1, ip, r6
    1458:	01792a00 	cmneq	r9, r0, lsl #20
    145c:	05010000 	streq	r0, [r1, #-0]
    1460:	00381601 	eorseq	r1, r8, r1, lsl #12
    1464:	91020000 	mrsls	r0, (UNDEF: 2)
    1468:	6e65356c 	cdpvs	5, 6, cr3, cr5, cr12, {3}
    146c:	05010064 	streq	r0, [r1, #-100]	; 0xffffff9c
    1470:	00382101 	eorseq	r2, r8, r1, lsl #2
    1474:	91020000 	mrsls	r0, (UNDEF: 2)
    1478:	75622f68 	strbvc	r2, [r2, #-3944]!	; 0xfffff098
    147c:	06010066 	streq	r0, [r1], -r6, rrx
    1480:	09c60801 	stmibeq	r6, {r0, fp}^
    1484:	91020000 	mrsls	r0, (UNDEF: 2)
    1488:	6f360074 	svcvs	0x00360074
    148c:	01000008 	tsteq	r0, r8
    1490:	129907fe 	addsne	r0, r9, #66584576	; 0x3f80000
    1494:	0b290000 	bleq	a4149c <__bss_end+0xa35b64>
    1498:	8c040000 	stchi	0, cr0, [r4], {-0}
    149c:	00840000 	addeq	r0, r4, r0
    14a0:	9c010000 	stcls	0, cr0, [r1], {-0}
    14a4:	0000124f 	andeq	r1, r0, pc, asr #4
    14a8:	01006137 	tsteq	r0, r7, lsr r1
    14ac:	0b2913fe 	bleq	a464ac <__bss_end+0xa3ab74>
    14b0:	91020000 	mrsls	r0, (UNDEF: 2)
    14b4:	0062376c 	rsbeq	r3, r2, ip, ror #14
    14b8:	291cfe01 	ldmdbcs	ip, {r0, r9, sl, fp, ip, sp, lr, pc}
    14bc:	0200000b 	andeq	r0, r0, #11
    14c0:	63376891 	teqvs	r7, #9502720	; 0x910000
    14c4:	25fe0100 	ldrbcs	r0, [lr, #256]!	; 0x100
    14c8:	00000b29 	andeq	r0, r0, r9, lsr #22
    14cc:	37649102 	strbcc	r9, [r4, -r2, lsl #2]!
    14d0:	fe010064 	cdp2	0, 0, cr0, cr1, cr4, {3}
    14d4:	000b292e 	andeq	r2, fp, lr, lsr #18
    14d8:	60910200 	addsvs	r0, r1, r0, lsl #4
    14dc:	01006537 	tsteq	r0, r7, lsr r5
    14e0:	0b2937fe 	bleq	a4f4e0 <__bss_end+0xa43ba8>
    14e4:	91020000 	mrsls	r0, (UNDEF: 2)
    14e8:	0078375c 	rsbseq	r3, r8, ip, asr r7
    14ec:	2940fe01 	stmdbcs	r0, {r0, r9, sl, fp, ip, sp, lr, pc}^
    14f0:	0200000b 	andeq	r0, r0, #11
    14f4:	84385891 	ldrthi	r5, [r8], #-2193	; 0xfffff76f
    14f8:	01000010 	tsteq	r0, r0, lsl r0
    14fc:	0b2949fe 	bleq	a53cfc <__bss_end+0xa483c4>
    1500:	91020000 	mrsls	r0, (UNDEF: 2)
    1504:	0e2d3854 	mcreq	8, 1, r3, cr13, cr4, {2}
    1508:	fe010000 	cdp2	0, 0, cr0, cr1, cr0, {0}
    150c:	000b2956 	andeq	r2, fp, r6, asr r9
    1510:	50910200 	addspl	r0, r1, r0, lsl #4
    1514:	00746239 	rsbseq	r6, r4, r9, lsr r2
    1518:	2908ff01 	stmdbcs	r8, {r0, r8, r9, sl, fp, ip, sp, lr, pc}
    151c:	0200000b 	andeq	r0, r0, #11
    1520:	3a007491 	bcc	1e76c <__bss_end+0x12e34>
    1524:	0000068a 	andeq	r0, r0, sl, lsl #13
    1528:	5a07f401 	bpl	1fe534 <__bss_end+0x1f2bfc>
    152c:	29000004 	stmdbcs	r0, {r2}
    1530:	7c00000b 	stcvc	0, cr0, [r0], {11}
    1534:	8800008b 	stmdahi	r0, {r0, r1, r3, r7}
    1538:	01000000 	mrseq	r0, (UNDEF: 0)
    153c:	0012e29c 	mulseq	r2, ip, r2
    1540:	00643700 	rsbeq	r3, r4, r0, lsl #14
    1544:	2915f401 	ldmdbcs	r5, {r0, sl, ip, sp, lr, pc}
    1548:	0200000b 	andeq	r0, r0, #11
    154c:	65376491 	ldrvs	r6, [r7, #-1169]!	; 0xfffffb6f
    1550:	1ef40100 	cdpne	1, 15, cr0, cr4, cr0, {0}
    1554:	00000b29 	andeq	r0, r0, r9, lsr #22
    1558:	38609102 	stmdacc	r0!, {r1, r8, ip, pc}^
    155c:	00001084 	andeq	r1, r0, r4, lsl #1
    1560:	2927f401 	stmdbcs	r7!, {r0, sl, ip, sp, lr, pc}
    1564:	0200000b 	andeq	r0, r0, #11
    1568:	2d385c91 	ldccs	12, cr5, [r8, #-580]!	; 0xfffffdbc
    156c:	0100000e 	tsteq	r0, lr
    1570:	0b2934f4 	bleq	a4e948 <__bss_end+0xa43010>
    1574:	91020000 	mrsls	r0, (UNDEF: 2)
    1578:	05a02658 	streq	r2, [r0, #1624]!	; 0x658
    157c:	f5010000 			; <UNDEFINED> instruction: 0xf5010000
    1580:	000b2908 	andeq	r2, fp, r8, lsl #18
    1584:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1588:	0005f726 	andeq	pc, r5, r6, lsr #14
    158c:	08f60100 	ldmeq	r6!, {r8}^
    1590:	00000b29 	andeq	r0, r0, r9, lsr #22
    1594:	26709102 	ldrbtcs	r9, [r0], -r2, lsl #2
    1598:	000005e6 	andeq	r0, r0, r6, ror #11
    159c:	2908f701 	stmdbcs	r8, {r0, r8, r9, sl, ip, sp, lr, pc}
    15a0:	0200000b 	andeq	r0, r0, #11
    15a4:	1a266c91 	bne	99c7f0 <__bss_end+0x990eb8>
    15a8:	01000006 	tsteq	r0, r6
    15ac:	0b2908f8 	bleq	a43994 <__bss_end+0xa3805c>
    15b0:	91020000 	mrsls	r0, (UNDEF: 2)
    15b4:	04360068 	ldrteq	r0, [r6], #-104	; 0xffffff98
    15b8:	0100000b 	tsteq	r0, fp
    15bc:	07050ad1 			; <UNDEFINED> instruction: 0x07050ad1
    15c0:	004d0000 	subeq	r0, sp, r0
    15c4:	89c00000 	stmibhi	r0, {}^	; <UNPREDICTABLE>
    15c8:	01bc0000 			; <UNDEFINED> instruction: 0x01bc0000
    15cc:	9c010000 	stcls	0, cr0, [r1], {-0}
    15d0:	0000134f 	andeq	r1, r0, pc, asr #6
    15d4:	000b0926 	andeq	r0, fp, r6, lsr #18
    15d8:	08d20100 	ldmeq	r2, {r8}^
    15dc:	00000b29 	andeq	r0, r0, r9, lsr #22
    15e0:	266c9102 	strbtcs	r9, [ip], -r2, lsl #2
    15e4:	000009cc 	andeq	r0, r0, ip, asr #19
    15e8:	c608d301 	strgt	sp, [r8], -r1, lsl #6
    15ec:	02000009 	andeq	r0, r0, #9
    15f0:	ac317091 	ldcge	0, cr7, [r1], #-580	; 0xfffffdbc
    15f4:	ac00008a 	stcge	0, cr0, [r0], {138}	; 0x8a
    15f8:	26000000 	strcs	r0, [r0], -r0
    15fc:	000010f3 	strdeq	r1, [r0], -r3
    1600:	420ae801 	andmi	lr, sl, #65536	; 0x10000
    1604:	0200000b 	andeq	r0, r0, #11
    1608:	f0316891 			; <UNDEFINED> instruction: 0xf0316891
    160c:	5c00008a 	stcpl	0, cr0, [r0], {138}	; 0x8a
    1610:	39000000 	stmdbcc	r0, {}	; <UNPREDICTABLE>
    1614:	ea010069 	b	417c0 <__bss_end+0x35e88>
    1618:	0000380c 	andeq	r3, r0, ip, lsl #16
    161c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1620:	3b000000 	blcc	1628 <shift+0x1628>
    1624:	000009c7 	andeq	r0, r0, r7, asr #19
    1628:	8e068401 	cdphi	4, 0, cr8, cr6, cr1, {0}
    162c:	1000000b 	andne	r0, r0, fp
    1630:	b0000087 	andlt	r0, r0, r7, lsl #1
    1634:	01000002 	tsteq	r0, r2
    1638:	0014179c 	mulseq	r4, ip, r7
    163c:	09cc2600 	stmibeq	ip, {r9, sl, sp}^
    1640:	85010000 	strhi	r0, [r1, #-0]
    1644:	0009c60b 	andeq	ip, r9, fp, lsl #12
    1648:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    164c:	00872830 	addeq	r2, r7, r0, lsr r8
    1650:	00013800 	andeq	r3, r1, r0, lsl #16
    1654:	0013c900 	andseq	ip, r3, r0, lsl #18
    1658:	00623900 	rsbeq	r3, r2, r0, lsl #18
    165c:	4d0c8a01 	vstrmi	s16, [ip, #-4]
    1660:	02000000 	andeq	r0, r0, #0
    1664:	64307091 	ldrtvs	r7, [r0], #-145	; 0xffffff6f
    1668:	dc000087 	stcle	0, cr0, [r0], {135}	; 0x87
    166c:	af000000 	svcge	0x00000000
    1670:	26000013 			; <UNDEFINED> instruction: 0x26000013
    1674:	00000acd 	andeq	r0, r0, sp, asr #21
    1678:	c60a9401 	strgt	r9, [sl], -r1, lsl #8
    167c:	02000009 	andeq	r0, r0, #9
    1680:	31006891 			; <UNDEFINED> instruction: 0x31006891
    1684:	00008840 	andeq	r8, r0, r0, asr #16
    1688:	00000020 	andeq	r0, r0, r0, lsr #32
    168c:	000c1d26 	andeq	r1, ip, r6, lsr #26
    1690:	10a70100 	adcne	r0, r7, r0, lsl #2
    1694:	00000376 	andeq	r0, r0, r6, ror r3
    1698:	006c9102 	rsbeq	r9, ip, r2, lsl #2
    169c:	88643100 	stmdahi	r4!, {r8, ip, sp}^
    16a0:	01180000 	tsteq	r8, r0
    16a4:	62390000 	eorsvs	r0, r9, #0
    16a8:	0caf0100 	stfeqs	f0, [pc]	; 16b0 <shift+0x16b0>
    16ac:	0000004d 	andeq	r0, r0, sp, asr #32
    16b0:	30649102 	rsbcc	r9, r4, r2, lsl #2
    16b4:	000088a0 	andeq	r8, r0, r0, lsr #17
    16b8:	000000bc 	strheq	r0, [r0], -ip
    16bc:	000013fc 	strdeq	r1, [r0], -ip
    16c0:	000c3526 	andeq	r3, ip, r6, lsr #10
    16c4:	0ab60100 	beq	fed81acc <__bss_end+0xfed76194>
    16c8:	000009c6 	andeq	r0, r0, r6, asr #19
    16cc:	005c9102 	subseq	r9, ip, r2, lsl #2
    16d0:	00895c31 	addeq	r5, r9, r1, lsr ip
    16d4:	00002000 	andeq	r2, r0, r0
    16d8:	0c1d2600 	ldceq	6, cr2, [sp], {-0}
    16dc:	ca010000 	bgt	416e4 <__bss_end+0x35dac>
    16e0:	00037610 	andeq	r7, r3, r0, lsl r6
    16e4:	60910200 	addsvs	r0, r1, r0, lsl #4
    16e8:	36000000 	strcc	r0, [r0], -r0
    16ec:	00000669 	andeq	r0, r0, r9, ror #12
    16f0:	7b0a6a01 	blvc	29befc <__bss_end+0x2905c4>
    16f4:	4d000008 	stcmi	0, cr0, [r0, #-32]	; 0xffffffe0
    16f8:	04000000 	streq	r0, [r0], #-0
    16fc:	0c000086 	stceq	0, cr0, [r0], {134}	; 0x86
    1700:	01000001 	tsteq	r0, r1
    1704:	0014879c 	mulseq	r4, ip, r7
    1708:	09cc3800 	stmibeq	ip, {fp, ip, sp}^
    170c:	6a010000 	bvs	41714 <__bss_end+0x35ddc>
    1710:	0009c61c 	andeq	ip, r9, ip, lsl r6
    1714:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1718:	00148b26 	andseq	r8, r4, r6, lsr #22
    171c:	066b0100 	strbteq	r0, [fp], -r0, lsl #2
    1720:	00000038 	andeq	r0, r0, r8, lsr r0
    1724:	266c9102 	strbtcs	r9, [ip], -r2, lsl #2
    1728:	00000ad7 	ldrdeq	r0, [r0], -r7
    172c:	69076c01 	stmdbvs	r7, {r0, sl, fp, sp, lr}
    1730:	02000003 	andeq	r0, r0, #3
    1734:	61397791 	teqvs	r9, r1	; <illegal shifter operand>
    1738:	076d0100 	strbeq	r0, [sp, -r0, lsl #2]!
    173c:	00000025 	andeq	r0, r0, r5, lsr #32
    1740:	316b9102 	cmncc	fp, r2, lsl #2
    1744:	0000862c 	andeq	r8, r0, ip, lsr #12
    1748:	000000c0 	andeq	r0, r0, r0, asr #1
    174c:	01006939 	tsteq	r0, r9, lsr r9
    1750:	00380b6e 	eorseq	r0, r8, lr, ror #22
    1754:	91020000 	mrsls	r0, (UNDEF: 2)
    1758:	3a000070 	bcc	1920 <shift+0x1920>
    175c:	00000cc2 	andeq	r0, r0, r2, asr #25
    1760:	1b0a6201 	blne	299f6c <__bss_end+0x28e634>
    1764:	4d00000a 	stcmi	0, cr0, [r0, #-40]	; 0xffffffd8
    1768:	b0000000 	andlt	r0, r0, r0
    176c:	54000085 	strpl	r0, [r0], #-133	; 0xffffff7b
    1770:	01000000 	mrseq	r0, (UNDEF: 0)
    1774:	0014c09c 	mulseq	r4, ip, r0
    1778:	00733700 	rsbseq	r3, r3, r0, lsl #14
    177c:	c6196201 	ldrgt	r6, [r9], -r1, lsl #4
    1780:	02000009 	andeq	r0, r0, #9
    1784:	74396c91 	ldrtvc	r6, [r9], #-3217	; 0xfffff36f
    1788:	08630100 	stmdaeq	r3!, {r8}^
    178c:	000009c6 	andeq	r0, r0, r6, asr #19
    1790:	00749102 	rsbseq	r9, r4, r2, lsl #2
    1794:	0005563b 	andeq	r5, r5, fp, lsr r6
    1798:	06520100 	ldrbeq	r0, [r2], -r0, lsl #2
    179c:	00000d2c 	andeq	r0, r0, ip, lsr #26
    17a0:	000084f0 	strdeq	r8, [r0], -r0
    17a4:	000000c0 	andeq	r0, r0, r0, asr #1
    17a8:	15089c01 	strne	r9, [r8, #-3073]	; 0xfffff3ff
    17ac:	8b380000 	blhi	e017b4 <__bss_end+0xdf5e7c>
    17b0:	01000014 	tsteq	r0, r4, lsl r0
    17b4:	004d1a52 	subeq	r1, sp, r2, asr sl
    17b8:	91020000 	mrsls	r0, (UNDEF: 2)
    17bc:	0973386c 	ldmdbeq	r3!, {r2, r3, r5, r6, fp, ip, sp}^
    17c0:	52010000 	andpl	r0, r1, #0
    17c4:	0003692a 	andeq	r6, r3, sl, lsr #18
    17c8:	6b910200 	blvs	fe441fd0 <__bss_end+0xfe436698>
    17cc:	6e656c39 	mcrvs	12, 3, r6, cr5, cr9, {1}
    17d0:	0b530100 	bleq	14c1bd8 <__bss_end+0x14b62a0>
    17d4:	0000004d 	andeq	r0, r0, sp, asr #32
    17d8:	00749102 	rsbseq	r9, r4, r2, lsl #2
    17dc:	0009f03a 	andeq	pc, r9, sl, lsr r0	; <UNPREDICTABLE>
    17e0:	06490100 	strbeq	r0, [r9], -r0, lsl #2
    17e4:	000011ff 	strdeq	r1, [r0], -pc	; <UNPREDICTABLE>
    17e8:	00000369 	andeq	r0, r0, r9, ror #6
    17ec:	00008428 	andeq	r8, r0, r8, lsr #8
    17f0:	000000c8 	andeq	r0, r0, r8, asr #1
    17f4:	155c9c01 	ldrbne	r9, [ip, #-3073]	; 0xfffff3ff
    17f8:	1a380000 	bne	e01800 <__bss_end+0xdf5ec8>
    17fc:	0100000f 	tsteq	r0, pc
    1800:	09c61949 	stmibeq	r6, {r0, r3, r6, r8, fp, ip}^
    1804:	91020000 	mrsls	r0, (UNDEF: 2)
    1808:	148b386c 	strne	r3, [fp], #2156	; 0x86c
    180c:	49010000 	stmdbmi	r1, {}	; <UNPREDICTABLE>
    1810:	00004d2a 	andeq	r4, r0, sl, lsr #26
    1814:	68910200 	ldmvs	r1, {r9}
    1818:	00843c31 	addeq	r3, r4, r1, lsr ip
    181c:	0000a000 	andeq	sl, r0, r0
    1820:	006a3900 	rsbeq	r3, sl, r0, lsl #18
    1824:	4d0f4a01 	vstrmi	s8, [pc, #-4]	; 1828 <shift+0x1828>
    1828:	02000000 	andeq	r0, r0, #0
    182c:	00007491 	muleq	r0, r1, r4
    1830:	0003c33c 	andeq	ip, r3, ip, lsr r3
    1834:	063f0100 	ldrteq	r0, [pc], -r0, lsl #2
    1838:	00000fb6 			; <UNDEFINED> instruction: 0x00000fb6
    183c:	00008324 	andeq	r8, r0, r4, lsr #6
    1840:	00000104 	andeq	r0, r0, r4, lsl #2
    1844:	15a09c01 	strne	r9, [r0, #3073]!	; 0xc01
    1848:	78370000 	ldmdavc	r7!, {}	; <UNPREDICTABLE>
    184c:	103f0100 	eorsne	r0, pc, r0, lsl #2
    1850:	00000038 	andeq	r0, r0, r8, lsr r0
    1854:	37749102 	ldrbcc	r9, [r4, -r2, lsl #2]!
    1858:	3f010079 	svccc	0x00010079
    185c:	00003817 	andeq	r3, r0, r7, lsl r8
    1860:	70910200 	addsvc	r0, r1, r0, lsl #4
    1864:	0009ea38 	andeq	lr, r9, r8, lsr sl
    1868:	203f0100 	eorscs	r0, pc, r0, lsl #2
    186c:	00000b29 	andeq	r0, r0, r9, lsr #22
    1870:	006c9102 	rsbeq	r9, ip, r2, lsl #2
    1874:	6e65673d 	mcrvs	7, 3, r6, cr5, cr13, {1}
    1878:	07360100 	ldreq	r0, [r6, -r0, lsl #2]!
    187c:	00000913 	andeq	r0, r0, r3, lsl r9
    1880:	00000b29 	andeq	r0, r0, r9, lsr #22
    1884:	00008230 	andeq	r8, r0, r0, lsr r2
    1888:	000000f4 	strdeq	r0, [r0], -r4
    188c:	78379c01 	ldmdavc	r7!, {r0, sl, fp, ip, pc}
    1890:	0f360100 	svceq	0x00360100
    1894:	00000038 	andeq	r0, r0, r8, lsr r0
    1898:	37749102 	ldrbcc	r9, [r4, -r2, lsl #2]!
    189c:	36010079 			; <UNDEFINED> instruction: 0x36010079
    18a0:	00003816 	andeq	r3, r0, r6, lsl r8
    18a4:	70910200 	addsvc	r0, r1, r0, lsl #4
    18a8:	0d5d0000 	ldcleq	0, cr0, [sp, #-0]
    18ac:	00040000 	andeq	r0, r4, r0
    18b0:	000005e6 	andeq	r0, r0, r6, ror #11
    18b4:	158d0104 	strne	r0, [sp, #260]	; 0x104
    18b8:	14040000 	strne	r0, [r4], #-0
    18bc:	c2000013 	andgt	r0, r0, #19
    18c0:	60000013 	andvs	r0, r0, r3, lsl r0
    18c4:	5c00009b 	stcpl	0, cr0, [r0], {155}	; 0x9b
    18c8:	e7000004 	str	r0, [r0, -r4]
    18cc:	0200000a 	andeq	r0, r0, #10
    18d0:	0d7a0801 	ldcleq	8, cr0, [sl, #-4]!
    18d4:	25030000 	strcs	r0, [r3, #-0]
    18d8:	02000000 	andeq	r0, r0, #0
    18dc:	0dbc0502 	cfldr32eq	mvfx0, [ip, #8]!
    18e0:	04040000 	streq	r0, [r4], #-0
    18e4:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    18e8:	08010200 	stmdaeq	r1, {r9}
    18ec:	00000d71 	andeq	r0, r0, r1, ror sp
    18f0:	3c070202 	sfmcc	f0, 4, [r7], {2}
    18f4:	0500000a 	streq	r0, [r0, #-10]
    18f8:	00000e82 	andeq	r0, r0, r2, lsl #29
    18fc:	5e070907 	vmlapl.f16	s0, s14, s14	; <UNPREDICTABLE>
    1900:	03000000 	movweq	r0, #0
    1904:	0000004d 	andeq	r0, r0, sp, asr #32
    1908:	34070402 	strcc	r0, [r7], #-1026	; 0xfffffbfe
    190c:	0600001e 			; <UNDEFINED> instruction: 0x0600001e
    1910:	00000836 	andeq	r0, r0, r6, lsr r8
    1914:	08060208 	stmdaeq	r6, {r3, r9}
    1918:	0000008b 	andeq	r0, r0, fp, lsl #1
    191c:	00307207 	eorseq	r7, r0, r7, lsl #4
    1920:	4d0e0802 	stcmi	8, cr0, [lr, #-8]
    1924:	00000000 	andeq	r0, r0, r0
    1928:	00317207 	eorseq	r7, r1, r7, lsl #4
    192c:	4d0e0902 	vstrmi.16	s0, [lr, #-4]	; <UNPREDICTABLE>
    1930:	04000000 	streq	r0, [r0], #-0
    1934:	14e00800 	strbtne	r0, [r0], #2048	; 0x800
    1938:	04050000 	streq	r0, [r5], #-0
    193c:	00000038 	andeq	r0, r0, r8, lsr r0
    1940:	a90c0d02 	stmdbge	ip, {r1, r8, sl, fp}
    1944:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    1948:	00004b4f 	andeq	r4, r0, pc, asr #22
    194c:	00134b0a 	andseq	r4, r3, sl, lsl #22
    1950:	08000100 	stmdaeq	r0, {r8}
    1954:	00000637 	andeq	r0, r0, r7, lsr r6
    1958:	00380405 	eorseq	r0, r8, r5, lsl #8
    195c:	1f020000 	svcne	0x00020000
    1960:	0000e00c 	andeq	lr, r0, ip
    1964:	08b50a00 	ldmeq	r5!, {r9, fp}
    1968:	0a000000 	beq	1970 <shift+0x1970>
    196c:	00001289 	andeq	r1, r0, r9, lsl #5
    1970:	12530a01 	subsne	r0, r3, #4096	; 0x1000
    1974:	0a020000 	beq	8197c <__bss_end+0x76044>
    1978:	00000ab8 			; <UNDEFINED> instruction: 0x00000ab8
    197c:	0cb30a03 	vldmiaeq	r3!, {s0-s2}
    1980:	0a040000 	beq	101988 <__bss_end+0xf6050>
    1984:	00000866 	andeq	r0, r0, r6, ror #16
    1988:	d0080005 	andle	r0, r8, r5
    198c:	05000010 	streq	r0, [r0, #-16]
    1990:	00003804 	andeq	r3, r0, r4, lsl #16
    1994:	0c400200 	sfmeq	f0, 2, [r0], {-0}
    1998:	0000011d 	andeq	r0, r0, sp, lsl r1
    199c:	0003f60a 	andeq	pc, r3, sl, lsl #12
    19a0:	640a0000 	strvs	r0, [sl], #-0
    19a4:	01000006 	tsteq	r0, r6
    19a8:	000c870a 	andeq	r8, ip, sl, lsl #14
    19ac:	920a0200 	andls	r0, sl, #0, 4
    19b0:	03000011 	movweq	r0, #17
    19b4:	0012930a 	andseq	r9, r2, sl, lsl #6
    19b8:	e90a0400 	stmdb	sl, {sl}
    19bc:	0500000b 	streq	r0, [r0, #-11]
    19c0:	000a5c0a 	andeq	r5, sl, sl, lsl #24
    19c4:	08000600 	stmdaeq	r0, {r9, sl}
    19c8:	0000108a 	andeq	r1, r0, sl, lsl #1
    19cc:	00380405 	eorseq	r0, r8, r5, lsl #8
    19d0:	67020000 	strvs	r0, [r2, -r0]
    19d4:	0001480c 	andeq	r4, r1, ip, lsl #16
    19d8:	0d3d0a00 	vldmdbeq	sp!, {s0-s-1}
    19dc:	0a000000 	beq	19e4 <shift+0x19e4>
    19e0:	00000a10 	andeq	r0, r0, r0, lsl sl
    19e4:	0de30a01 			; <UNDEFINED> instruction: 0x0de30a01
    19e8:	0a020000 	beq	819f0 <__bss_end+0x760b8>
    19ec:	00000a61 	andeq	r0, r0, r1, ror #20
    19f0:	fa080003 	blx	201a04 <__bss_end+0x1f60cc>
    19f4:	0500000d 	streq	r0, [r0, #-13]
    19f8:	00003804 	andeq	r3, r0, r4, lsl #16
    19fc:	0c6f0200 	sfmeq	f0, 2, [pc], #-0	; 1a04 <shift+0x1a04>
    1a00:	00000161 	andeq	r0, r0, r1, ror #2
    1a04:	000cae0a 	andeq	sl, ip, sl, lsl #28
    1a08:	0b000000 	bleq	1a10 <shift+0x1a10>
    1a0c:	00000c27 	andeq	r0, r0, r7, lsr #24
    1a10:	59140503 	ldmdbpl	r4, {r0, r1, r8, sl}
    1a14:	05000000 	streq	r0, [r0, #-0]
    1a18:	00b3e803 	adcseq	lr, r3, r3, lsl #16
    1a1c:	0c510b00 	mrrceq	11, 0, r0, r1, cr0
    1a20:	06030000 	streq	r0, [r3], -r0
    1a24:	00005914 	andeq	r5, r0, r4, lsl r9
    1a28:	ec030500 	cfstr32	mvfx0, [r3], {-0}
    1a2c:	0b0000b3 	bleq	1d00 <shift+0x1d00>
    1a30:	00000bc8 	andeq	r0, r0, r8, asr #23
    1a34:	591a0704 	ldmdbpl	sl, {r2, r8, r9, sl}
    1a38:	05000000 	streq	r0, [r0, #-0]
    1a3c:	00b3f003 	adcseq	pc, r3, r3
    1a40:	06f30b00 	ldrbteq	r0, [r3], r0, lsl #22
    1a44:	09040000 	stmdbeq	r4, {}	; <UNPREDICTABLE>
    1a48:	0000591a 	andeq	r5, r0, sl, lsl r9
    1a4c:	f4030500 	vst3.8	{d0,d2,d4}, [r3], r0
    1a50:	0b0000b3 	bleq	1d24 <shift+0x1d24>
    1a54:	00000d51 	andeq	r0, r0, r1, asr sp
    1a58:	591a0b04 	ldmdbpl	sl, {r2, r8, r9, fp}
    1a5c:	05000000 	streq	r0, [r0, #-0]
    1a60:	00b3f803 	adcseq	pc, r3, r3, lsl #16
    1a64:	09fd0b00 	ldmibeq	sp!, {r8, r9, fp}^
    1a68:	0d040000 	stceq	0, cr0, [r4, #-0]
    1a6c:	0000591a 	andeq	r5, r0, sl, lsl r9
    1a70:	fc030500 	stc2	5, cr0, [r3], {-0}
    1a74:	0b0000b3 	bleq	1d48 <shift+0x1d48>
    1a78:	0000084f 	andeq	r0, r0, pc, asr #16
    1a7c:	591a0f04 	ldmdbpl	sl, {r2, r8, r9, sl, fp}
    1a80:	05000000 	streq	r0, [r0, #-0]
    1a84:	00b40003 	adcseq	r0, r4, r3
    1a88:	0ecc0800 	cdpeq	8, 12, cr0, cr12, cr0, {0}
    1a8c:	04050000 	streq	r0, [r5], #-0
    1a90:	00000038 	andeq	r0, r0, r8, lsr r0
    1a94:	040c1b04 	streq	r1, [ip], #-2820	; 0xfffff4fc
    1a98:	0a000002 	beq	1aa8 <shift+0x1aa8>
    1a9c:	00000efe 	strdeq	r0, [r0], -lr
    1aa0:	12320a00 	eorsne	r0, r2, #0, 20
    1aa4:	0a010000 	beq	41aac <__bss_end+0x36174>
    1aa8:	00000c82 	andeq	r0, r0, r2, lsl #25
    1aac:	260c0002 	strcs	r0, [ip], -r2
    1ab0:	0d00000d 	stceq	0, cr0, [r0, #-52]	; 0xffffffcc
    1ab4:	00000db0 			; <UNDEFINED> instruction: 0x00000db0
    1ab8:	07630490 			; <UNDEFINED> instruction: 0x07630490
    1abc:	00000377 	andeq	r0, r0, r7, ror r3
    1ac0:	00116106 	andseq	r6, r1, r6, lsl #2
    1ac4:	67042400 	strvs	r2, [r4, -r0, lsl #8]
    1ac8:	00029110 	andeq	r9, r2, r0, lsl r1
    1acc:	21a40e00 			; <UNDEFINED> instruction: 0x21a40e00
    1ad0:	69040000 	stmdbvs	r4, {}	; <UNPREDICTABLE>
    1ad4:	00037712 	andeq	r7, r3, r2, lsl r7
    1ad8:	1f0e0000 	svcne	0x000e0000
    1adc:	04000006 	streq	r0, [r0], #-6
    1ae0:	0387126b 	orreq	r1, r7, #-1342177274	; 0xb0000006
    1ae4:	0e100000 	cdpeq	0, 1, cr0, cr0, cr0, {0}
    1ae8:	00000ef3 	strdeq	r0, [r0], -r3
    1aec:	4d166d04 	ldcmi	13, cr6, [r6, #-16]
    1af0:	14000000 	strne	r0, [r0], #-0
    1af4:	0006ec0e 	andeq	lr, r6, lr, lsl #24
    1af8:	1c700400 	cfldrdne	mvd0, [r0], #-0
    1afc:	0000038e 	andeq	r0, r0, lr, lsl #7
    1b00:	0d480e18 	stcleq	14, cr0, [r8, #-96]	; 0xffffffa0
    1b04:	72040000 	andvc	r0, r4, #0
    1b08:	00038e1c 	andeq	r8, r3, ip, lsl lr
    1b0c:	f20e1c00 			; <UNDEFINED> instruction: 0xf20e1c00
    1b10:	04000005 	streq	r0, [r0], #-5
    1b14:	038e1c75 	orreq	r1, lr, #29952	; 0x7500
    1b18:	0f200000 	svceq	0x00200000
    1b1c:	000008bd 			; <UNDEFINED> instruction: 0x000008bd
    1b20:	691c7704 	ldmdbvs	ip, {r2, r8, r9, sl, ip, sp, lr}
    1b24:	8e000004 	cdphi	0, 0, cr0, cr0, cr4, {0}
    1b28:	85000003 	strhi	r0, [r0, #-3]
    1b2c:	10000002 	andne	r0, r0, r2
    1b30:	0000038e 	andeq	r0, r0, lr, lsl #7
    1b34:	00039411 	andeq	r9, r3, r1, lsl r4
    1b38:	06000000 	streq	r0, [r0], -r0
    1b3c:	0000079c 	muleq	r0, ip, r7
    1b40:	107b0418 	rsbsne	r0, fp, r8, lsl r4
    1b44:	000002c6 	andeq	r0, r0, r6, asr #5
    1b48:	0021a40e 	eoreq	sl, r1, lr, lsl #8
    1b4c:	127e0400 	rsbsne	r0, lr, #0, 8
    1b50:	00000377 	andeq	r0, r0, r7, ror r3
    1b54:	060f0e00 	streq	r0, [pc], -r0, lsl #28
    1b58:	80040000 	andhi	r0, r4, r0
    1b5c:	00039419 	andeq	r9, r3, r9, lsl r4
    1b60:	980e1000 	stmdals	lr, {ip}
    1b64:	04000011 	streq	r0, [r0], #-17	; 0xffffffef
    1b68:	039f2182 	orrseq	r2, pc, #-2147483616	; 0x80000020
    1b6c:	00140000 	andseq	r0, r4, r0
    1b70:	00029103 	andeq	r9, r2, r3, lsl #2
    1b74:	0b6e1200 	bleq	1b8637c <__bss_end+0x1b7aa44>
    1b78:	86040000 	strhi	r0, [r4], -r0
    1b7c:	0003a521 	andeq	sl, r3, r1, lsr #10
    1b80:	09791200 	ldmdbeq	r9!, {r9, ip}^
    1b84:	88040000 	stmdahi	r4, {}	; <UNPREDICTABLE>
    1b88:	0000591f 	andeq	r5, r0, pc, lsl r9
    1b8c:	0e330e00 	cdpeq	14, 3, cr0, cr3, cr0, {0}
    1b90:	8b040000 	blhi	101b98 <__bss_end+0xf6260>
    1b94:	00021617 	andeq	r1, r2, r7, lsl r6
    1b98:	be0e0000 	cdplt	0, 0, cr0, cr14, cr0, {0}
    1b9c:	0400000a 	streq	r0, [r0], #-10
    1ba0:	0216178e 	andseq	r1, r6, #37224448	; 0x2380000
    1ba4:	0e240000 	cdpeq	0, 2, cr0, cr4, cr0, {0}
    1ba8:	00000994 	muleq	r0, r4, r9
    1bac:	16178f04 	ldrne	r8, [r7], -r4, lsl #30
    1bb0:	48000002 	stmdami	r0, {r1}
    1bb4:	0012730e 	andseq	r7, r2, lr, lsl #6
    1bb8:	17900400 	ldrne	r0, [r0, r0, lsl #8]
    1bbc:	00000216 	andeq	r0, r0, r6, lsl r2
    1bc0:	0db0136c 	ldceq	3, cr1, [r0, #432]!	; 0x1b0
    1bc4:	93040000 	movwls	r0, #16384	; 0x4000
    1bc8:	00078709 	andeq	r8, r7, r9, lsl #14
    1bcc:	0003b000 	andeq	fp, r3, r0
    1bd0:	03300100 	teqeq	r0, #0, 2
    1bd4:	03360000 	teqeq	r6, #0
    1bd8:	b0100000 	andslt	r0, r0, r0
    1bdc:	00000003 	andeq	r0, r0, r3
    1be0:	000b6314 	andeq	r6, fp, r4, lsl r3
    1be4:	0e960400 	cdpeq	4, 9, cr0, cr6, cr0, {0}
    1be8:	00000a8b 	andeq	r0, r0, fp, lsl #21
    1bec:	00034b01 	andeq	r4, r3, r1, lsl #22
    1bf0:	00035100 	andeq	r5, r3, r0, lsl #2
    1bf4:	03b01000 	movseq	r1, #0
    1bf8:	15000000 	strne	r0, [r0, #-0]
    1bfc:	000003f6 	strdeq	r0, [r0], -r6
    1c00:	b1109904 	tstlt	r0, r4, lsl #18
    1c04:	b600000e 	strlt	r0, [r0], -lr
    1c08:	01000003 	tsteq	r0, r3
    1c0c:	00000366 	andeq	r0, r0, r6, ror #6
    1c10:	0003b010 	andeq	fp, r3, r0, lsl r0
    1c14:	03941100 	orrseq	r1, r4, #0, 2
    1c18:	df110000 	svcle	0x00110000
    1c1c:	00000001 	andeq	r0, r0, r1
    1c20:	00251600 	eoreq	r1, r5, r0, lsl #12
    1c24:	03870000 	orreq	r0, r7, #0
    1c28:	5e170000 	cdppl	0, 1, cr0, cr7, cr0, {0}
    1c2c:	0f000000 	svceq	0x00000000
    1c30:	02010200 	andeq	r0, r1, #0, 4
    1c34:	00000ac8 	andeq	r0, r0, r8, asr #21
    1c38:	02160418 	andseq	r0, r6, #24, 8	; 0x18000000
    1c3c:	04180000 	ldreq	r0, [r8], #-0
    1c40:	0000002c 	andeq	r0, r0, ip, lsr #32
    1c44:	0011ec0c 	andseq	lr, r1, ip, lsl #24
    1c48:	9a041800 	bls	107c50 <__bss_end+0xfc318>
    1c4c:	16000003 	strne	r0, [r0], -r3
    1c50:	000002c6 	andeq	r0, r0, r6, asr #5
    1c54:	000003b0 			; <UNDEFINED> instruction: 0x000003b0
    1c58:	04180019 	ldreq	r0, [r8], #-25	; 0xffffffe7
    1c5c:	00000209 	andeq	r0, r0, r9, lsl #4
    1c60:	02040418 	andeq	r0, r4, #24, 8	; 0x18000000
    1c64:	391a0000 	ldmdbcc	sl, {}	; <UNPREDICTABLE>
    1c68:	0400000e 	streq	r0, [r0], #-14
    1c6c:	0209149c 	andeq	r1, r9, #156, 8	; 0x9c000000
    1c70:	1c0b0000 	stcne	0, cr0, [fp], {-0}
    1c74:	05000009 	streq	r0, [r0, #-9]
    1c78:	00591404 	subseq	r1, r9, r4, lsl #8
    1c7c:	03050000 	movweq	r0, #20480	; 0x5000
    1c80:	0000b404 	andeq	fp, r0, r4, lsl #8
    1c84:	0003e00b 	andeq	lr, r3, fp
    1c88:	14070500 	strne	r0, [r7], #-1280	; 0xfffffb00
    1c8c:	00000059 	andeq	r0, r0, r9, asr r0
    1c90:	b4080305 	strlt	r0, [r8], #-773	; 0xfffffcfb
    1c94:	630b0000 	movwvs	r0, #45056	; 0xb000
    1c98:	05000007 	streq	r0, [r0, #-7]
    1c9c:	0059140a 	subseq	r1, r9, sl, lsl #8
    1ca0:	03050000 	movweq	r0, #20480	; 0x5000
    1ca4:	0000b40c 	andeq	fp, r0, ip, lsl #8
    1ca8:	000b1808 	andeq	r1, fp, r8, lsl #16
    1cac:	38040500 	stmdacc	r4, {r8, sl}
    1cb0:	05000000 	streq	r0, [r0, #-0]
    1cb4:	04350c0d 	ldrteq	r0, [r5], #-3085	; 0xfffff3f3
    1cb8:	4e090000 	cdpmi	0, 0, cr0, cr9, cr0, {0}
    1cbc:	00007765 	andeq	r7, r0, r5, ror #14
    1cc0:	000b0f0a 	andeq	r0, fp, sl, lsl #30
    1cc4:	450a0100 	strmi	r0, [sl, #-256]	; 0xffffff00
    1cc8:	0200000e 	andeq	r0, r0, #14
    1ccc:	000ae70a 	andeq	lr, sl, sl, lsl #14
    1cd0:	aa0a0300 	bge	2828d8 <__bss_end+0x276fa0>
    1cd4:	0400000a 	streq	r0, [r0], #-10
    1cd8:	000c8d0a 	andeq	r8, ip, sl, lsl #26
    1cdc:	06000500 	streq	r0, [r0], -r0, lsl #10
    1ce0:	00000859 	andeq	r0, r0, r9, asr r8
    1ce4:	081b0510 	ldmdaeq	fp, {r4, r8, sl}
    1ce8:	00000474 	andeq	r0, r0, r4, ror r4
    1cec:	00726c07 	rsbseq	r6, r2, r7, lsl #24
    1cf0:	74131d05 	ldrvc	r1, [r3], #-3333	; 0xfffff2fb
    1cf4:	00000004 	andeq	r0, r0, r4
    1cf8:	00707307 	rsbseq	r7, r0, r7, lsl #6
    1cfc:	74131e05 	ldrvc	r1, [r3], #-3589	; 0xfffff1fb
    1d00:	04000004 	streq	r0, [r0], #-4
    1d04:	00637007 	rsbeq	r7, r3, r7
    1d08:	74131f05 	ldrvc	r1, [r3], #-3845	; 0xfffff0fb
    1d0c:	08000004 	stmdaeq	r0, {r2}
    1d10:	0008750e 	andeq	r7, r8, lr, lsl #10
    1d14:	13200500 	nopne	{0}	; <UNPREDICTABLE>
    1d18:	00000474 	andeq	r0, r0, r4, ror r4
    1d1c:	0402000c 	streq	r0, [r2], #-12
    1d20:	001e2f07 	andseq	r2, lr, r7, lsl #30
    1d24:	04480600 	strbeq	r0, [r8], #-1536	; 0xfffffa00
    1d28:	05800000 	streq	r0, [r0]
    1d2c:	053e0828 	ldreq	r0, [lr, #-2088]!	; 0xfffff7d8
    1d30:	7d0e0000 	stcvc	0, cr0, [lr, #-0]
    1d34:	05000012 	streq	r0, [r0, #-18]	; 0xffffffee
    1d38:	0435122a 	ldrteq	r1, [r5], #-554	; 0xfffffdd6
    1d3c:	07000000 	streq	r0, [r0, -r0]
    1d40:	00646970 	rsbeq	r6, r4, r0, ror r9
    1d44:	5e122b05 	vnmlspl.f64	d2, d2, d5
    1d48:	10000000 	andne	r0, r0, r0
    1d4c:	001b800e 	andseq	r8, fp, lr
    1d50:	112c0500 			; <UNDEFINED> instruction: 0x112c0500
    1d54:	000003fe 	strdeq	r0, [r0], -lr
    1d58:	0b390e14 	bleq	e455b0 <__bss_end+0xe39c78>
    1d5c:	2d050000 	stccs	0, cr0, [r5, #-0]
    1d60:	00005e12 	andeq	r5, r0, r2, lsl lr
    1d64:	470e1800 	strmi	r1, [lr, -r0, lsl #16]
    1d68:	0500000b 	streq	r0, [r0, #-11]
    1d6c:	005e122e 	subseq	r1, lr, lr, lsr #4
    1d70:	0e1c0000 	cdpeq	0, 1, cr0, cr12, cr0, {0}
    1d74:	00000842 	andeq	r0, r0, r2, asr #16
    1d78:	3e0c2f05 	cdpcc	15, 0, cr2, cr12, cr5, {0}
    1d7c:	20000005 	andcs	r0, r0, r5
    1d80:	000b7a0e 	andeq	r7, fp, lr, lsl #20
    1d84:	09300500 	ldmdbeq	r0!, {r8, sl}
    1d88:	00000038 	andeq	r0, r0, r8, lsr r0
    1d8c:	0f210e60 	svceq	0x00210e60
    1d90:	31050000 	mrscc	r0, (UNDEF: 5)
    1d94:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1d98:	dd0e6400 	cfstrsle	mvf6, [lr, #-0]
    1d9c:	05000008 	streq	r0, [r0, #-8]
    1da0:	004d0e33 	subeq	r0, sp, r3, lsr lr
    1da4:	0e680000 	cdpeq	0, 6, cr0, cr8, cr0, {0}
    1da8:	000008d4 	ldrdeq	r0, [r0], -r4
    1dac:	4d0e3405 	cfstrsmi	mvf3, [lr, #-20]	; 0xffffffec
    1db0:	6c000000 	stcvs	0, cr0, [r0], {-0}
    1db4:	00747007 	rsbseq	r7, r4, r7
    1db8:	4e0c3605 	cfmadd32mi	mvax0, mvfx3, mvfx12, mvfx5
    1dbc:	70000005 	andvc	r0, r0, r5
    1dc0:	0010750e 	andseq	r7, r0, lr, lsl #10
    1dc4:	0e370500 	cfabs32eq	mvfx0, mvfx7
    1dc8:	0000004d 	andeq	r0, r0, sp, asr #32
    1dcc:	05260e74 	streq	r0, [r6, #-3700]!	; 0xfffff18c
    1dd0:	38050000 	stmdacc	r5, {}	; <UNPREDICTABLE>
    1dd4:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1dd8:	3d0e7800 	stccc	8, cr7, [lr, #-0]
    1ddc:	05000012 	streq	r0, [r0, #-18]	; 0xffffffee
    1de0:	004d0e39 	subeq	r0, sp, r9, lsr lr
    1de4:	007c0000 	rsbseq	r0, ip, r0
    1de8:	0003b616 	andeq	fp, r3, r6, lsl r6
    1dec:	00054e00 	andeq	r4, r5, r0, lsl #28
    1df0:	005e1700 	subseq	r1, lr, r0, lsl #14
    1df4:	000f0000 	andeq	r0, pc, r0
    1df8:	004d0418 	subeq	r0, sp, r8, lsl r4
    1dfc:	520b0000 	andpl	r0, fp, #0
    1e00:	06000011 			; <UNDEFINED> instruction: 0x06000011
    1e04:	0059140a 	subseq	r1, r9, sl, lsl #8
    1e08:	03050000 	movweq	r0, #20480	; 0x5000
    1e0c:	0000b410 	andeq	fp, r0, r0, lsl r4
    1e10:	000aef08 	andeq	lr, sl, r8, lsl #30
    1e14:	38040500 	stmdacc	r4, {r8, sl}
    1e18:	06000000 	streq	r0, [r0], -r0
    1e1c:	05850c0d 	streq	r0, [r5, #3085]	; 0xc0d
    1e20:	750a0000 	strvc	r0, [sl, #-0]
    1e24:	00000006 	andeq	r0, r0, r6
    1e28:	0003d50a 	andeq	sp, r3, sl, lsl #10
    1e2c:	03000100 	movweq	r0, #256	; 0x100
    1e30:	00000566 	andeq	r0, r0, r6, ror #10
    1e34:	00143208 	andseq	r3, r4, r8, lsl #4
    1e38:	38040500 	stmdacc	r4, {r8, sl}
    1e3c:	06000000 	streq	r0, [r0], -r0
    1e40:	05a90c14 	streq	r0, [r9, #3092]!	; 0xc14
    1e44:	b00a0000 	andlt	r0, sl, r0
    1e48:	00000012 	andeq	r0, r0, r2, lsl r0
    1e4c:	0014b20a 	andseq	fp, r4, sl, lsl #4
    1e50:	03000100 	movweq	r0, #256	; 0x100
    1e54:	0000058a 	andeq	r0, r0, sl, lsl #11
    1e58:	00103806 	andseq	r3, r0, r6, lsl #16
    1e5c:	1b060c00 	blne	184e64 <__bss_end+0x17952c>
    1e60:	0005e308 	andeq	lr, r5, r8, lsl #6
    1e64:	041a0e00 	ldreq	r0, [sl], #-3584	; 0xfffff200
    1e68:	1d060000 	stcne	0, cr0, [r6, #-0]
    1e6c:	0005e319 	andeq	lr, r5, r9, lsl r3
    1e70:	f20e0000 	vhadd.s8	d0, d14, d0
    1e74:	06000005 	streq	r0, [r0], -r5
    1e78:	05e3191e 	strbeq	r1, [r3, #2334]!	; 0x91e
    1e7c:	0e040000 	cdpeq	0, 0, cr0, cr4, cr0, {0}
    1e80:	00000f9e 	muleq	r0, lr, pc	; <UNPREDICTABLE>
    1e84:	e9131f06 	ldmdb	r3, {r1, r2, r8, r9, sl, fp, ip}
    1e88:	08000005 	stmdaeq	r0, {r0, r2}
    1e8c:	ae041800 	cdpge	8, 0, cr1, cr4, cr0, {0}
    1e90:	18000005 	stmdane	r0, {r0, r2}
    1e94:	00047b04 	andeq	r7, r4, r4, lsl #22
    1e98:	07760d00 	ldrbeq	r0, [r6, -r0, lsl #26]!
    1e9c:	06140000 	ldreq	r0, [r4], -r0
    1ea0:	08a50722 	stmiaeq	r5!, {r1, r5, r8, r9, sl}
    1ea4:	dd0e0000 	stcle	0, cr0, [lr, #-0]
    1ea8:	0600000a 	streq	r0, [r0], -sl
    1eac:	004d1226 	subeq	r1, sp, r6, lsr #4
    1eb0:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    1eb4:	00000543 	andeq	r0, r0, r3, asr #10
    1eb8:	e31d2906 	tst	sp, #98304	; 0x18000
    1ebc:	04000005 	streq	r0, [r0], #-5
    1ec0:	000e9e0e 	andeq	r9, lr, lr, lsl #28
    1ec4:	1d2c0600 	stcne	6, cr0, [ip, #-0]
    1ec8:	000005e3 	andeq	r0, r0, r3, ror #11
    1ecc:	10c61b08 	sbcne	r1, r6, r8, lsl #22
    1ed0:	2f060000 	svccs	0x00060000
    1ed4:	0010150e 	andseq	r1, r0, lr, lsl #10
    1ed8:	00063700 	andeq	r3, r6, r0, lsl #14
    1edc:	00064200 	andeq	r4, r6, r0, lsl #4
    1ee0:	08aa1000 	stmiaeq	sl!, {ip}
    1ee4:	e3110000 	tst	r1, #0
    1ee8:	00000005 	andeq	r0, r0, r5
    1eec:	000fc21c 	andeq	ip, pc, ip, lsl r2	; <UNPREDICTABLE>
    1ef0:	0e310600 	cfmsuba32eq	mvax0, mvax0, mvfx1, mvfx0
    1ef4:	0000041f 	andeq	r0, r0, pc, lsl r4
    1ef8:	00000387 	andeq	r0, r0, r7, lsl #7
    1efc:	0000065a 	andeq	r0, r0, sl, asr r6
    1f00:	00000665 	andeq	r0, r0, r5, ror #12
    1f04:	0008aa10 	andeq	sl, r8, r0, lsl sl
    1f08:	05e91100 	strbeq	r1, [r9, #256]!	; 0x100
    1f0c:	13000000 	movwne	r0, #0
    1f10:	00001060 	andeq	r1, r0, r0, rrx
    1f14:	791d3506 	ldmdbvc	sp, {r1, r2, r8, sl, ip, sp}
    1f18:	e300000f 	movw	r0, #15
    1f1c:	02000005 	andeq	r0, r0, #5
    1f20:	0000067e 	andeq	r0, r0, lr, ror r6
    1f24:	00000684 	andeq	r0, r0, r4, lsl #13
    1f28:	0008aa10 	andeq	sl, r8, r0, lsl sl
    1f2c:	4f130000 	svcmi	0x00130000
    1f30:	0600000a 	streq	r0, [r0], -sl
    1f34:	0d8a1d37 	stceq	13, cr1, [sl, #220]	; 0xdc
    1f38:	05e30000 	strbeq	r0, [r3, #0]!
    1f3c:	9d020000 	stcls	0, cr0, [r2, #-0]
    1f40:	a3000006 	movwge	r0, #6
    1f44:	10000006 	andne	r0, r0, r6
    1f48:	000008aa 	andeq	r0, r0, sl, lsr #17
    1f4c:	0b9e1d00 	bleq	fe789354 <__bss_end+0xfe77da1c>
    1f50:	39060000 	stmdbcc	r6, {}	; <UNPREDICTABLE>
    1f54:	0008c331 	andeq	ip, r8, r1, lsr r3
    1f58:	13020c00 	movwne	r0, #11264	; 0x2c00
    1f5c:	00000776 	andeq	r0, r0, r6, ror r7
    1f60:	59093c06 	stmdbpl	r9, {r1, r2, sl, fp, ip, sp}
    1f64:	aa000012 	bge	1fb4 <shift+0x1fb4>
    1f68:	01000008 	tsteq	r0, r8
    1f6c:	000006ca 	andeq	r0, r0, sl, asr #13
    1f70:	000006d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    1f74:	0008aa10 	andeq	sl, r8, r0, lsl sl
    1f78:	92130000 	andsls	r0, r3, #0
    1f7c:	06000006 	streq	r0, [r0], -r6
    1f80:	109b123f 	addsne	r1, fp, pc, lsr r2
    1f84:	004d0000 	subeq	r0, sp, r0
    1f88:	e9010000 	stmdb	r1, {}	; <UNPREDICTABLE>
    1f8c:	fe000006 	cdp2	0, 0, cr0, cr0, cr6, {0}
    1f90:	10000006 	andne	r0, r0, r6
    1f94:	000008aa 	andeq	r0, r0, sl, lsr #17
    1f98:	0008cc11 	andeq	ip, r8, r1, lsl ip
    1f9c:	005e1100 	subseq	r1, lr, r0, lsl #2
    1fa0:	87110000 	ldrhi	r0, [r1, -r0]
    1fa4:	00000003 	andeq	r0, r0, r3
    1fa8:	000fd114 	andeq	sp, pc, r4, lsl r1	; <UNPREDICTABLE>
    1fac:	0e420600 	cdpeq	6, 4, cr0, cr2, cr0, {0}
    1fb0:	00000cd8 	ldrdeq	r0, [r0], -r8
    1fb4:	00071301 	andeq	r1, r7, r1, lsl #6
    1fb8:	00071900 	andeq	r1, r7, r0, lsl #18
    1fbc:	08aa1000 	stmiaeq	sl!, {ip}
    1fc0:	13000000 	movwne	r0, #0
    1fc4:	0000099e 	muleq	r0, lr, r9
    1fc8:	6b174506 	blvs	5d33e8 <__bss_end+0x5c7ab0>
    1fcc:	e9000005 	stmdb	r0, {r0, r2}
    1fd0:	01000005 	tsteq	r0, r5
    1fd4:	00000732 	andeq	r0, r0, r2, lsr r7
    1fd8:	00000738 	andeq	r0, r0, r8, lsr r7
    1fdc:	0008d210 	andeq	sp, r8, r0, lsl r2
    1fe0:	fc130000 	ldc2	0, cr0, [r3], {-0}
    1fe4:	06000005 	streq	r0, [r0], -r5
    1fe8:	0f2d1748 	svceq	0x002d1748
    1fec:	05e90000 	strbeq	r0, [r9, #0]!
    1ff0:	51010000 	mrspl	r0, (UNDEF: 1)
    1ff4:	5c000007 	stcpl	0, cr0, [r0], {7}
    1ff8:	10000007 	andne	r0, r0, r7
    1ffc:	000008d2 	ldrdeq	r0, [r0], -r2
    2000:	00004d11 	andeq	r4, r0, r1, lsl sp
    2004:	6f140000 	svcvs	0x00140000
    2008:	06000011 			; <UNDEFINED> instruction: 0x06000011
    200c:	0fe60e4b 	svceq	0x00e60e4b
    2010:	71010000 	mrsvc	r0, (UNDEF: 1)
    2014:	77000007 	strvc	r0, [r0, -r7]
    2018:	10000007 	andne	r0, r0, r7
    201c:	000008aa 	andeq	r0, r0, sl, lsr #17
    2020:	0fc21300 	svceq	0x00c21300
    2024:	4d060000 	stcmi	0, cr0, [r6, #-0]
    2028:	00088d0e 	andeq	r8, r8, lr, lsl #26
    202c:	00038700 	andeq	r8, r3, r0, lsl #14
    2030:	07900100 	ldreq	r0, [r0, r0, lsl #2]
    2034:	079b0000 	ldreq	r0, [fp, r0]
    2038:	aa100000 	bge	402040 <__bss_end+0x3f6708>
    203c:	11000008 	tstne	r0, r8
    2040:	0000004d 	andeq	r0, r0, sp, asr #32
    2044:	09d21300 	ldmibeq	r2, {r8, r9, ip}^
    2048:	50060000 	andpl	r0, r6, r0
    204c:	000cf912 	andeq	pc, ip, r2, lsl r9	; <UNPREDICTABLE>
    2050:	00004d00 	andeq	r4, r0, r0, lsl #26
    2054:	07b40100 	ldreq	r0, [r4, r0, lsl #2]!
    2058:	07bf0000 	ldreq	r0, [pc, r0]!
    205c:	aa100000 	bge	402064 <__bss_end+0x3f672c>
    2060:	11000008 	tstne	r0, r8
    2064:	000003b6 			; <UNDEFINED> instruction: 0x000003b6
    2068:	04b81300 	ldrteq	r1, [r8], #768	; 0x300
    206c:	53060000 	movwpl	r0, #24576	; 0x6000
    2070:	0009350e 	andeq	r3, r9, lr, lsl #10
    2074:	00038700 	andeq	r8, r3, r0, lsl #14
    2078:	07d80100 	ldrbeq	r0, [r8, r0, lsl #2]
    207c:	07e30000 	strbeq	r0, [r3, r0]!
    2080:	aa100000 	bge	402088 <__bss_end+0x3f6750>
    2084:	11000008 	tstne	r0, r8
    2088:	0000004d 	andeq	r0, r0, sp, asr #32
    208c:	0a291400 	beq	a47094 <__bss_end+0xa3b75c>
    2090:	56060000 	strpl	r0, [r6], -r0
    2094:	0004d40e 	andeq	sp, r4, lr, lsl #8
    2098:	07f80100 	ldrbeq	r0, [r8, r0, lsl #2]!
    209c:	08170000 	ldmdaeq	r7, {}	; <UNPREDICTABLE>
    20a0:	aa100000 	bge	4020a8 <__bss_end+0x3f6770>
    20a4:	11000008 	tstne	r0, r8
    20a8:	000000a9 	andeq	r0, r0, r9, lsr #1
    20ac:	00004d11 	andeq	r4, r0, r1, lsl sp
    20b0:	004d1100 	subeq	r1, sp, r0, lsl #2
    20b4:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    20b8:	11000000 	mrsne	r0, (UNDEF: 0)
    20bc:	000008d8 	ldrdeq	r0, [r0], -r8
    20c0:	0f631400 	svceq	0x00631400
    20c4:	58060000 	stmdapl	r6, {}	; <UNPREDICTABLE>
    20c8:	0007ea0e 	andeq	lr, r7, lr, lsl #20
    20cc:	082c0100 	stmdaeq	ip!, {r8}
    20d0:	084b0000 	stmdaeq	fp, {}^	; <UNPREDICTABLE>
    20d4:	aa100000 	bge	4020dc <__bss_end+0x3f67a4>
    20d8:	11000008 	tstne	r0, r8
    20dc:	000000e0 	andeq	r0, r0, r0, ror #1
    20e0:	00004d11 	andeq	r4, r0, r1, lsl sp
    20e4:	004d1100 	subeq	r1, sp, r0, lsl #2
    20e8:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    20ec:	11000000 	mrsne	r0, (UNDEF: 0)
    20f0:	000008d8 	ldrdeq	r0, [r0], -r8
    20f4:	0d5f1400 	cfldrdeq	mvd1, [pc, #-0]	; 20fc <shift+0x20fc>
    20f8:	5b060000 	blpl	182100 <__bss_end+0x1767c8>
    20fc:	0010fa0e 	andseq	pc, r0, lr, lsl #20
    2100:	08600100 	stmdaeq	r0!, {r8}^
    2104:	087f0000 	ldmdaeq	pc!, {}^	; <UNPREDICTABLE>
    2108:	aa100000 	bge	402110 <__bss_end+0x3f67d8>
    210c:	11000008 	tstne	r0, r8
    2110:	00000148 	andeq	r0, r0, r8, asr #2
    2114:	00004d11 	andeq	r4, r0, r1, lsl sp
    2118:	004d1100 	subeq	r1, sp, r0, lsl #2
    211c:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    2120:	11000000 	mrsne	r0, (UNDEF: 0)
    2124:	000008d8 	ldrdeq	r0, [r0], -r8
    2128:	07501500 	ldrbeq	r1, [r0, -r0, lsl #10]
    212c:	5e060000 	cdppl	0, 0, cr0, cr6, cr0, {0}
    2130:	0007a70e 	andeq	sl, r7, lr, lsl #14
    2134:	00038700 	andeq	r8, r3, r0, lsl #14
    2138:	08940100 	ldmeq	r4, {r8}
    213c:	aa100000 	bge	402144 <__bss_end+0x3f680c>
    2140:	11000008 	tstne	r0, r8
    2144:	00000566 	andeq	r0, r0, r6, ror #10
    2148:	0008de11 	andeq	sp, r8, r1, lsl lr
    214c:	03000000 	movweq	r0, #0
    2150:	000005ef 	andeq	r0, r0, pc, ror #11
    2154:	05ef0418 	strbeq	r0, [pc, #1048]!	; 2574 <shift+0x2574>
    2158:	e31e0000 	tst	lr, #0
    215c:	bd000005 	stclt	0, cr0, [r0, #-20]	; 0xffffffec
    2160:	c3000008 	movwgt	r0, #8
    2164:	10000008 	andne	r0, r0, r8
    2168:	000008aa 	andeq	r0, r0, sl, lsr #17
    216c:	05ef1f00 	strbeq	r1, [pc, #3840]!	; 3074 <shift+0x3074>
    2170:	08b00000 	ldmeq	r0!, {}	; <UNPREDICTABLE>
    2174:	04180000 	ldreq	r0, [r8], #-0
    2178:	0000003f 	andeq	r0, r0, pc, lsr r0
    217c:	08a50418 	stmiaeq	r5!, {r3, r4, sl}
    2180:	04200000 	strteq	r0, [r0], #-0
    2184:	00000065 	andeq	r0, r0, r5, rrx
    2188:	bc1a0421 	cfldrslt	mvf0, [sl], {33}	; 0x21
    218c:	0600000b 	streq	r0, [r0], -fp
    2190:	05ef1961 	strbeq	r1, [pc, #2401]!	; 2af9 <shift+0x2af9>
    2194:	2c160000 	ldccs	0, cr0, [r6], {-0}
    2198:	fc000000 	stc2	0, cr0, [r0], {-0}
    219c:	17000008 	strne	r0, [r0, -r8]
    21a0:	0000005e 	andeq	r0, r0, lr, asr r0
    21a4:	ec030009 	stc	0, cr0, [r3], {9}
    21a8:	22000008 	andcs	r0, r0, #8
    21ac:	00001397 	muleq	r0, r7, r3
    21b0:	fc0ca401 	stc2	4, cr10, [ip], {1}
    21b4:	05000008 	streq	r0, [r0, #-8]
    21b8:	00b41403 	adcseq	r1, r4, r3, lsl #8
    21bc:	12c22300 	sbcne	r2, r2, #0, 6
    21c0:	a6010000 	strge	r0, [r1], -r0
    21c4:	0014260a 	andseq	r2, r4, sl, lsl #12
    21c8:	00004d00 	andeq	r4, r0, r0, lsl #26
    21cc:	009f0c00 	addseq	r0, pc, r0, lsl #24
    21d0:	0000b000 	andeq	fp, r0, r0
    21d4:	719c0100 	orrsvc	r0, ip, r0, lsl #2
    21d8:	24000009 	strcs	r0, [r0], #-9
    21dc:	000021a4 	andeq	r2, r0, r4, lsr #3
    21e0:	941ba601 	ldrls	sl, [fp], #-1537	; 0xfffff9ff
    21e4:	03000003 	movweq	r0, #3
    21e8:	247fac91 	ldrbtcs	sl, [pc], #-3217	; 21f0 <shift+0x21f0>
    21ec:	00001487 	andeq	r1, r0, r7, lsl #9
    21f0:	4d2aa601 	stcmi	6, cr10, [sl, #-4]!
    21f4:	03000000 	movweq	r0, #0
    21f8:	227fa891 	rsbscs	sl, pc, #9502720	; 0x910000
    21fc:	00001407 	andeq	r1, r0, r7, lsl #8
    2200:	710aa801 	tstvc	sl, r1, lsl #16
    2204:	03000009 	movweq	r0, #9
    2208:	227fb491 	rsbscs	fp, pc, #-1862270976	; 0x91000000
    220c:	000012bd 			; <UNDEFINED> instruction: 0x000012bd
    2210:	3809ac01 	stmdacc	r9, {r0, sl, fp, sp, pc}
    2214:	02000000 	andeq	r0, r0, #0
    2218:	16007491 			; <UNDEFINED> instruction: 0x16007491
    221c:	00000025 	andeq	r0, r0, r5, lsr #32
    2220:	00000981 	andeq	r0, r0, r1, lsl #19
    2224:	00005e17 	andeq	r5, r0, r7, lsl lr
    2228:	25003f00 	strcs	r3, [r0, #-3840]	; 0xfffff100
    222c:	0000146c 	andeq	r1, r0, ip, ror #8
    2230:	c00a9801 	andgt	r9, sl, r1, lsl #16
    2234:	4d000014 	stcmi	0, cr0, [r0, #-80]	; 0xffffffb0
    2238:	d0000000 	andle	r0, r0, r0
    223c:	3c00009e 	stccc	0, cr0, [r0], {158}	; 0x9e
    2240:	01000000 	mrseq	r0, (UNDEF: 0)
    2244:	0009be9c 	muleq	r9, ip, lr
    2248:	65722600 	ldrbvs	r2, [r2, #-1536]!	; 0xfffffa00
    224c:	9a010071 	bls	42418 <__bss_end+0x36ae0>
    2250:	0005a920 	andeq	sl, r5, r0, lsr #18
    2254:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2258:	00141b22 	andseq	r1, r4, r2, lsr #22
    225c:	0e9b0100 	fmleqe	f0, f3, f0
    2260:	0000004d 	andeq	r0, r0, sp, asr #32
    2264:	00709102 	rsbseq	r9, r0, r2, lsl #2
    2268:	00149027 	andseq	r9, r4, r7, lsr #32
    226c:	068f0100 	streq	r0, [pc], r0, lsl #2
    2270:	000012de 	ldrdeq	r1, [r0], -lr
    2274:	00009e94 	muleq	r0, r4, lr
    2278:	0000003c 	andeq	r0, r0, ip, lsr r0
    227c:	09f79c01 	ldmibeq	r7!, {r0, sl, fp, ip, pc}^
    2280:	83240000 			; <UNDEFINED> instruction: 0x83240000
    2284:	01000013 	tsteq	r0, r3, lsl r0
    2288:	004d218f 	subeq	r2, sp, pc, lsl #3
    228c:	91020000 	mrsls	r0, (UNDEF: 2)
    2290:	6572266c 	ldrbvs	r2, [r2, #-1644]!	; 0xfffff994
    2294:	91010071 	tstls	r1, r1, ror r0
    2298:	0005a920 	andeq	sl, r5, r0, lsr #18
    229c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    22a0:	14472500 	strbne	r2, [r7], #-1280	; 0xfffffb00
    22a4:	83010000 	movwhi	r0, #4096	; 0x1000
    22a8:	0013a80a 	andseq	sl, r3, sl, lsl #16
    22ac:	00004d00 	andeq	r4, r0, r0, lsl #26
    22b0:	009e5800 	addseq	r5, lr, r0, lsl #16
    22b4:	00003c00 	andeq	r3, r0, r0, lsl #24
    22b8:	349c0100 	ldrcc	r0, [ip], #256	; 0x100
    22bc:	2600000a 	strcs	r0, [r0], -sl
    22c0:	00716572 	rsbseq	r6, r1, r2, ror r5
    22c4:	85208501 	strhi	r8, [r0, #-1281]!	; 0xfffffaff
    22c8:	02000005 	andeq	r0, r0, #5
    22cc:	14227491 	strtne	r7, [r2], #-1169	; 0xfffffb6f
    22d0:	01000014 	tsteq	r0, r4, lsl r0
    22d4:	004d0e86 	subeq	r0, sp, r6, lsl #29
    22d8:	91020000 	mrsls	r0, (UNDEF: 2)
    22dc:	48250070 	stmdami	r5!, {r4, r5, r6}
    22e0:	01000015 	tsteq	r0, r5, lsl r0
    22e4:	13590a77 	cmpne	r9, #487424	; 0x77000
    22e8:	004d0000 	subeq	r0, sp, r0
    22ec:	9e1c0000 	cdpls	0, 1, cr0, cr12, cr0, {0}
    22f0:	003c0000 	eorseq	r0, ip, r0
    22f4:	9c010000 	stcls	0, cr0, [r1], {-0}
    22f8:	00000a71 	andeq	r0, r0, r1, ror sl
    22fc:	71657226 	cmnvc	r5, r6, lsr #4
    2300:	20790100 	rsbscs	r0, r9, r0, lsl #2
    2304:	00000585 	andeq	r0, r0, r5, lsl #11
    2308:	22749102 	rsbscs	r9, r4, #-2147483648	; 0x80000000
    230c:	00001414 	andeq	r1, r0, r4, lsl r4
    2310:	4d0e7a01 	vstrmi	s14, [lr, #-4]
    2314:	02000000 	andeq	r0, r0, #0
    2318:	25007091 	strcs	r7, [r0, #-145]	; 0xffffff6f
    231c:	000013bc 			; <UNDEFINED> instruction: 0x000013bc
    2320:	a2066b01 	andge	r6, r6, #1024	; 0x400
    2324:	87000014 	smladhi	r0, r4, r0, r0
    2328:	c8000003 	stmdagt	r0, {r0, r1}
    232c:	5400009d 	strpl	r0, [r0], #-157	; 0xffffff63
    2330:	01000000 	mrseq	r0, (UNDEF: 0)
    2334:	000abd9c 	muleq	sl, ip, sp
    2338:	141b2400 	ldrne	r2, [fp], #-1024	; 0xfffffc00
    233c:	6b010000 	blvs	42344 <__bss_end+0x36a0c>
    2340:	00004d15 	andeq	r4, r0, r5, lsl sp
    2344:	6c910200 	lfmvs	f0, 4, [r1], {0}
    2348:	0008d424 	andeq	sp, r8, r4, lsr #8
    234c:	256b0100 	strbcs	r0, [fp, #-256]!	; 0xffffff00
    2350:	0000004d 	andeq	r0, r0, sp, asr #32
    2354:	22689102 	rsbcs	r9, r8, #-2147483648	; 0x80000000
    2358:	00001464 	andeq	r1, r0, r4, ror #8
    235c:	4d0e6d01 	stcmi	13, cr6, [lr, #-4]
    2360:	02000000 	andeq	r0, r0, #0
    2364:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    2368:	000012f5 	strdeq	r1, [r0], -r5
    236c:	f7125e01 			; <UNDEFINED> instruction: 0xf7125e01
    2370:	8b000014 	blhi	23c8 <shift+0x23c8>
    2374:	78000000 	stmdavc	r0, {}	; <UNPREDICTABLE>
    2378:	5000009d 	mulpl	r0, sp, r0
    237c:	01000000 	mrseq	r0, (UNDEF: 0)
    2380:	000b189c 	muleq	fp, ip, r8
    2384:	14ad2400 	strtne	r2, [sp], #1024	; 0x400
    2388:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
    238c:	00004d20 	andeq	r4, r0, r0, lsr #26
    2390:	6c910200 	lfmvs	f0, 4, [r1], {0}
    2394:	00145024 	andseq	r5, r4, r4, lsr #32
    2398:	2f5e0100 	svccs	0x005e0100
    239c:	0000004d 	andeq	r0, r0, sp, asr #32
    23a0:	24689102 	strbtcs	r9, [r8], #-258	; 0xfffffefe
    23a4:	000008d4 	ldrdeq	r0, [r0], -r4
    23a8:	4d3f5e01 	ldcmi	14, cr5, [pc, #-4]!	; 23ac <shift+0x23ac>
    23ac:	02000000 	andeq	r0, r0, #0
    23b0:	64226491 	strtvs	r6, [r2], #-1169	; 0xfffffb6f
    23b4:	01000014 	tsteq	r0, r4, lsl r0
    23b8:	008b1660 	addeq	r1, fp, r0, ror #12
    23bc:	91020000 	mrsls	r0, (UNDEF: 2)
    23c0:	0d250074 	stceq	0, cr0, [r5, #-464]!	; 0xfffffe30
    23c4:	01000014 	tsteq	r0, r4, lsl r0
    23c8:	12fa0a52 	rscsne	r0, sl, #335872	; 0x52000
    23cc:	004d0000 	subeq	r0, sp, r0
    23d0:	9d340000 	ldcls	0, cr0, [r4, #-0]
    23d4:	00440000 	subeq	r0, r4, r0
    23d8:	9c010000 	stcls	0, cr0, [r1], {-0}
    23dc:	00000b64 	andeq	r0, r0, r4, ror #22
    23e0:	0014ad24 	andseq	sl, r4, r4, lsr #26
    23e4:	1a520100 	bne	14827ec <__bss_end+0x1476eb4>
    23e8:	0000004d 	andeq	r0, r0, sp, asr #32
    23ec:	246c9102 	strbtcs	r9, [ip], #-258	; 0xfffffefe
    23f0:	00001450 	andeq	r1, r0, r0, asr r4
    23f4:	4d295201 	sfmmi	f5, 4, [r9, #-4]!
    23f8:	02000000 	andeq	r0, r0, #0
    23fc:	26226891 			; <UNDEFINED> instruction: 0x26226891
    2400:	01000015 	tsteq	r0, r5, lsl r0
    2404:	004d0e54 	subeq	r0, sp, r4, asr lr
    2408:	91020000 	mrsls	r0, (UNDEF: 2)
    240c:	20250074 	eorcs	r0, r5, r4, ror r0
    2410:	01000015 	tsteq	r0, r5, lsl r0
    2414:	15020a45 	strne	r0, [r2, #-2629]	; 0xfffff5bb
    2418:	004d0000 	subeq	r0, sp, r0
    241c:	9ce40000 	stclls	0, cr0, [r4]
    2420:	00500000 	subseq	r0, r0, r0
    2424:	9c010000 	stcls	0, cr0, [r1], {-0}
    2428:	00000bbf 			; <UNDEFINED> instruction: 0x00000bbf
    242c:	0014ad24 	andseq	sl, r4, r4, lsr #26
    2430:	19450100 	stmdbne	r5, {r8}^
    2434:	0000004d 	andeq	r0, r0, sp, asr #32
    2438:	246c9102 	strbtcs	r9, [ip], #-258	; 0xfffffefe
    243c:	000013e8 	andeq	r1, r0, r8, ror #7
    2440:	1d304501 	cfldr32ne	mvfx4, [r0, #-4]!
    2444:	02000001 	andeq	r0, r0, #1
    2448:	cc246891 	stcgt	8, cr6, [r4], #-580	; 0xfffffdbc
    244c:	01000009 	tsteq	r0, r9
    2450:	08de4145 	ldmeq	lr, {r0, r2, r6, r8, lr}^
    2454:	91020000 	mrsls	r0, (UNDEF: 2)
    2458:	14642264 	strbtne	r2, [r4], #-612	; 0xfffffd9c
    245c:	47010000 	strmi	r0, [r1, -r0]
    2460:	00004d0e 	andeq	r4, r0, lr, lsl #26
    2464:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2468:	12aa2700 	adcne	r2, sl, #0, 14
    246c:	3f010000 	svccc	0x00010000
    2470:	0013f206 	andseq	pc, r3, r6, lsl #4
    2474:	009cb800 	addseq	fp, ip, r0, lsl #16
    2478:	00002c00 	andeq	r2, r0, r0, lsl #24
    247c:	e99c0100 	ldmib	ip, {r8}
    2480:	2400000b 	strcs	r0, [r0], #-11
    2484:	000014ad 	andeq	r1, r0, sp, lsr #9
    2488:	4d153f01 	ldcmi	15, cr3, [r5, #-4]
    248c:	02000000 	andeq	r0, r0, #0
    2490:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    2494:	00000b5d 	andeq	r0, r0, sp, asr fp
    2498:	560a3201 	strpl	r3, [sl], -r1, lsl #4
    249c:	4d000014 	stcmi	0, cr0, [r0, #-80]	; 0xffffffb0
    24a0:	68000000 	stmdavs	r0, {}	; <UNPREDICTABLE>
    24a4:	5000009c 	mulpl	r0, ip, r0
    24a8:	01000000 	mrseq	r0, (UNDEF: 0)
    24ac:	000c449c 	muleq	ip, ip, r4
    24b0:	14ad2400 	strtne	r2, [sp], #1024	; 0x400
    24b4:	32010000 	andcc	r0, r1, #0
    24b8:	00004d19 	andeq	r4, r0, r9, lsl sp
    24bc:	6c910200 	lfmvs	f0, 4, [r1], {0}
    24c0:	000f1a24 	andeq	r1, pc, r4, lsr #20
    24c4:	2b320100 	blcs	c828cc <__bss_end+0xc76f94>
    24c8:	00000394 	muleq	r0, r4, r3
    24cc:	24689102 	strbtcs	r9, [r8], #-258	; 0xfffffefe
    24d0:	0000148b 	andeq	r1, r0, fp, lsl #9
    24d4:	4d3c3201 	lfmmi	f3, 4, [ip, #-4]!
    24d8:	02000000 	andeq	r0, r0, #0
    24dc:	f1226491 			; <UNDEFINED> instruction: 0xf1226491
    24e0:	01000014 	tsteq	r0, r4, lsl r0
    24e4:	004d0e34 	subeq	r0, sp, r4, lsr lr
    24e8:	91020000 	mrsls	r0, (UNDEF: 2)
    24ec:	8d250074 	stchi	0, cr0, [r5, #-464]!	; 0xfffffe30
    24f0:	01000011 	tsteq	r0, r1, lsl r0
    24f4:	153c0a25 	ldrne	r0, [ip, #-2597]!	; 0xfffff5db
    24f8:	004d0000 	subeq	r0, sp, r0
    24fc:	9c180000 	ldcls	0, cr0, [r8], {-0}
    2500:	00500000 	subseq	r0, r0, r0
    2504:	9c010000 	stcls	0, cr0, [r1], {-0}
    2508:	00000c9f 	muleq	r0, pc, ip	; <UNPREDICTABLE>
    250c:	0014ad24 	andseq	sl, r4, r4, lsr #26
    2510:	18250100 	stmdane	r5!, {r8}
    2514:	0000004d 	andeq	r0, r0, sp, asr #32
    2518:	246c9102 	strbtcs	r9, [ip], #-258	; 0xfffffefe
    251c:	00000f1a 	andeq	r0, r0, sl, lsl pc
    2520:	a52a2501 	strge	r2, [sl, #-1281]!	; 0xfffffaff
    2524:	0200000c 	andeq	r0, r0, #12
    2528:	8b246891 	blhi	91c774 <__bss_end+0x910e3c>
    252c:	01000014 	tsteq	r0, r4, lsl r0
    2530:	004d3b25 	subeq	r3, sp, r5, lsr #22
    2534:	91020000 	mrsls	r0, (UNDEF: 2)
    2538:	12c72264 	sbcne	r2, r7, #100, 4	; 0x40000006
    253c:	27010000 	strcs	r0, [r1, -r0]
    2540:	00004d0e 	andeq	r4, r0, lr, lsl #26
    2544:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2548:	25041800 	strcs	r1, [r4, #-2048]	; 0xfffff800
    254c:	03000000 	movweq	r0, #0
    2550:	00000c9f 	muleq	r0, pc, ip	; <UNPREDICTABLE>
    2554:	00142125 	andseq	r2, r4, r5, lsr #2
    2558:	0a190100 	beq	642960 <__bss_end+0x637028>
    255c:	00001571 	andeq	r1, r0, r1, ror r5
    2560:	0000004d 	andeq	r0, r0, sp, asr #32
    2564:	00009bd4 	ldrdeq	r9, [r0], -r4
    2568:	00000044 	andeq	r0, r0, r4, asr #32
    256c:	0cf69c01 	ldcleq	12, cr9, [r6], #4
    2570:	61240000 			; <UNDEFINED> instruction: 0x61240000
    2574:	01000015 	tsteq	r0, r5, lsl r0
    2578:	03941b19 	orrseq	r1, r4, #25600	; 0x6400
    257c:	91020000 	mrsls	r0, (UNDEF: 2)
    2580:	1537246c 	ldrne	r2, [r7, #-1132]!	; 0xfffffb94
    2584:	19010000 	stmdbne	r1, {}	; <UNPREDICTABLE>
    2588:	0001df35 	andeq	sp, r1, r5, lsr pc
    258c:	68910200 	ldmvs	r1, {r9}
    2590:	0014ad22 	andseq	sl, r4, r2, lsr #26
    2594:	0e1b0100 	mufeqe	f0, f3, f0
    2598:	0000004d 	andeq	r0, r0, sp, asr #32
    259c:	00749102 	rsbseq	r9, r4, r2, lsl #2
    25a0:	00137728 	andseq	r7, r3, r8, lsr #14
    25a4:	06140100 	ldreq	r0, [r4], -r0, lsl #2
    25a8:	000012cd 	andeq	r1, r0, sp, asr #5
    25ac:	00009bb8 			; <UNDEFINED> instruction: 0x00009bb8
    25b0:	0000001c 	andeq	r0, r0, ip, lsl r0
    25b4:	2d279c01 	stccs	12, cr9, [r7, #-4]!
    25b8:	01000015 	tsteq	r0, r5, lsl r0
    25bc:	1306060e 	movwne	r0, #26126	; 0x660e
    25c0:	9b8c0000 	blls	fe3025c8 <__bss_end+0xfe2f6c90>
    25c4:	002c0000 	eoreq	r0, ip, r0
    25c8:	9c010000 	stcls	0, cr0, [r1], {-0}
    25cc:	00000d36 	andeq	r0, r0, r6, lsr sp
    25d0:	00135024 	andseq	r5, r3, r4, lsr #32
    25d4:	140e0100 	strne	r0, [lr], #-256	; 0xffffff00
    25d8:	00000038 	andeq	r0, r0, r8, lsr r0
    25dc:	00749102 	rsbseq	r9, r4, r2, lsl #2
    25e0:	00156a29 	andseq	r6, r5, r9, lsr #20
    25e4:	0a040100 	beq	1029ec <__bss_end+0xf70b4>
    25e8:	000013fc 	strdeq	r1, [r0], -ip
    25ec:	0000004d 	andeq	r0, r0, sp, asr #32
    25f0:	00009b60 	andeq	r9, r0, r0, ror #22
    25f4:	0000002c 	andeq	r0, r0, ip, lsr #32
    25f8:	70269c01 	eorvc	r9, r6, r1, lsl #24
    25fc:	01006469 	tsteq	r0, r9, ror #8
    2600:	004d0e06 	subeq	r0, sp, r6, lsl #28
    2604:	91020000 	mrsls	r0, (UNDEF: 2)
    2608:	a6000074 			; <UNDEFINED> instruction: 0xa6000074
    260c:	04000000 	streq	r0, [r0], #-0
    2610:	00089100 	andeq	r9, r8, r0, lsl #2
    2614:	8d010400 	cfstrshi	mvf0, [r1, #-0]
    2618:	04000015 	streq	r0, [r0], #-21	; 0xffffffeb
    261c:	0000167a 	andeq	r1, r0, sl, ror r6
    2620:	000013c2 	andeq	r1, r0, r2, asr #7
    2624:	00009fbc 			; <UNDEFINED> instruction: 0x00009fbc
    2628:	00000040 	andeq	r0, r0, r0, asr #32
    262c:	00000d67 	andeq	r0, r0, r7, ror #26
    2630:	7a080102 	bvc	202a40 <__bss_end+0x1f7108>
    2634:	0200000d 	andeq	r0, r0, #13
    2638:	0dbc0502 	cfldr32eq	mvfx0, [ip, #8]!
    263c:	04030000 	streq	r0, [r3], #-0
    2640:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    2644:	08010200 	stmdaeq	r1, {r9}
    2648:	00000d71 	andeq	r0, r0, r1, ror sp
    264c:	3c070202 	sfmcc	f0, 4, [r7], {2}
    2650:	0400000a 	streq	r0, [r0], #-10
    2654:	00000e82 	andeq	r0, r0, r2, lsl #29
    2658:	54070902 	strpl	r0, [r7], #-2306	; 0xfffff6fe
    265c:	02000000 	andeq	r0, r0, #0
    2660:	1e340704 	cdpne	7, 3, cr0, cr4, cr4, {0}
    2664:	6b050000 	blvs	14266c <__bss_end+0x136d34>
    2668:	01000016 	tsteq	r0, r6, lsl r0
    266c:	16600706 	strbtne	r0, [r0], -r6, lsl #14
    2670:	00a70000 	adceq	r0, r7, r0
    2674:	9fbc0000 	svcls	0x00bc0000
    2678:	00400000 	subeq	r0, r0, r0
    267c:	9c010000 	stcls	0, cr0, [r1], {-0}
    2680:	000000a7 	andeq	r0, r0, r7, lsr #1
    2684:	00148b06 	andseq	r8, r4, r6, lsl #22
    2688:	17060100 	strne	r0, [r6, -r0, lsl #2]
    268c:	00000048 	andeq	r0, r0, r8, asr #32
    2690:	076c9102 	strbeq	r9, [ip, -r2, lsl #2]!
    2694:	00001672 	andeq	r1, r0, r2, ror r6
    2698:	480e0801 	stmdami	lr, {r0, fp}
    269c:	02000000 	andeq	r0, r0, #0
    26a0:	72087491 	andvc	r7, r8, #-1862270976	; 0x91000000
    26a4:	01007465 	tsteq	r0, r5, ror #8
    26a8:	00a7080c 	adceq	r0, r7, ip, lsl #16
    26ac:	91020000 	mrsls	r0, (UNDEF: 2)
    26b0:	04090070 	streq	r0, [r9], #-112	; 0xffffff90
    26b4:	0004f800 	andeq	pc, r4, r0, lsl #16
    26b8:	22000400 	andcs	r0, r0, #0, 8
    26bc:	04000009 	streq	r0, [r0], #-9
    26c0:	00158d01 	andseq	r8, r5, r1, lsl #26
    26c4:	172b0400 	strne	r0, [fp, -r0, lsl #8]!
    26c8:	13c20000 	bicne	r0, r2, #0
    26cc:	a0000000 	andge	r0, r0, r0
    26d0:	0b400000 	bleq	10026d8 <__bss_end+0xff6da0>
    26d4:	0e280000 	cdpeq	0, 2, cr0, cr8, cr0, {0}
    26d8:	49020000 	stmdbmi	r2, {}	; <UNPREDICTABLE>
    26dc:	03000000 	movweq	r0, #0
    26e0:	000017a5 	andeq	r1, r0, r5, lsr #15
    26e4:	61100701 	tstvs	r0, r1, lsl #14
    26e8:	11000000 	mrsne	r0, (UNDEF: 0)
    26ec:	33323130 	teqcc	r2, #48, 2
    26f0:	37363534 			; <UNDEFINED> instruction: 0x37363534
    26f4:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    26f8:	46454443 	strbmi	r4, [r5], -r3, asr #8
    26fc:	01040000 	mrseq	r0, (UNDEF: 4)
    2700:	00250105 	eoreq	r0, r5, r5, lsl #2
    2704:	74050000 	strvc	r0, [r5], #-0
    2708:	61000000 	mrsvs	r0, (UNDEF: 0)
    270c:	06000000 	streq	r0, [r0], -r0
    2710:	00000066 	andeq	r0, r0, r6, rrx
    2714:	51070010 	tstpl	r7, r0, lsl r0
    2718:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    271c:	1e340704 	cdpne	7, 3, cr0, cr4, cr4, {0}
    2720:	01080000 	mrseq	r0, (UNDEF: 8)
    2724:	000d7a08 	andeq	r7, sp, r8, lsl #20
    2728:	006d0700 	rsbeq	r0, sp, r0, lsl #14
    272c:	2a090000 	bcs	242734 <__bss_end+0x236dfc>
    2730:	0a000000 	beq	2738 <shift+0x2738>
    2734:	000017d6 	ldrdeq	r1, [r0], -r6
    2738:	ba06dd01 	blt	1b9b44 <__bss_end+0x1ae20c>
    273c:	c0000016 	andgt	r0, r0, r6, lsl r0
    2740:	800000aa 	andhi	r0, r0, sl, lsr #1
    2744:	01000000 	mrseq	r0, (UNDEF: 0)
    2748:	0000fb9c 	muleq	r0, ip, fp
    274c:	72730b00 	rsbsvc	r0, r3, #0, 22
    2750:	dd010063 	stcle	0, cr0, [r1, #-396]	; 0xfffffe74
    2754:	0000fb19 	andeq	pc, r0, r9, lsl fp	; <UNPREDICTABLE>
    2758:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    275c:	7473640b 	ldrbtvc	r6, [r3], #-1035	; 0xfffffbf5
    2760:	24dd0100 	ldrbcs	r0, [sp], #256	; 0x100
    2764:	00000102 	andeq	r0, r0, r2, lsl #2
    2768:	0b609102 	bleq	1826b78 <__bss_end+0x181b240>
    276c:	006d756e 	rsbeq	r7, sp, lr, ror #10
    2770:	042ddd01 	strteq	sp, [sp], #-3329	; 0xfffff2ff
    2774:	02000001 	andeq	r0, r0, #1
    2778:	b60c5c91 			; <UNDEFINED> instruction: 0xb60c5c91
    277c:	01000017 	tsteq	r0, r7, lsl r0
    2780:	01100edf 			; <UNDEFINED> instruction: 0x01100edf
    2784:	91020000 	mrsls	r0, (UNDEF: 2)
    2788:	179e0c70 			; <UNDEFINED> instruction: 0x179e0c70
    278c:	e0010000 	and	r0, r1, r0
    2790:	00011608 	andeq	r1, r1, r8, lsl #12
    2794:	6c910200 	lfmvs	f0, 4, [r1], {0}
    2798:	00aae80d 	adceq	lr, sl, sp, lsl #16
    279c:	00004800 	andeq	r4, r0, r0, lsl #16
    27a0:	00690e00 	rsbeq	r0, r9, r0, lsl #28
    27a4:	040be201 	streq	lr, [fp], #-513	; 0xfffffdff
    27a8:	02000001 	andeq	r0, r0, #1
    27ac:	00007491 	muleq	r0, r1, r4
    27b0:	0101040f 	tsteq	r1, pc, lsl #8
    27b4:	11100000 	tstne	r0, r0
    27b8:	05041204 	streq	r1, [r4, #-516]	; 0xfffffdfc
    27bc:	00746e69 	rsbseq	r6, r4, r9, ror #28
    27c0:	00010407 	andeq	r0, r1, r7, lsl #8
    27c4:	74040f00 	strvc	r0, [r4], #-3840	; 0xfffff100
    27c8:	0f000000 	svceq	0x00000000
    27cc:	00006d04 	andeq	r6, r0, r4, lsl #26
    27d0:	17bd0a00 	ldrne	r0, [sp, r0, lsl #20]!
    27d4:	d5010000 	strle	r0, [r1, #-0]
    27d8:	00170c06 	andseq	r0, r7, r6, lsl #24
    27dc:	00aa5800 	adceq	r5, sl, r0, lsl #16
    27e0:	00006800 	andeq	r6, r0, r0, lsl #16
    27e4:	7b9c0100 	blvc	fe702bec <__bss_end+0xfe6f72b4>
    27e8:	13000001 	movwne	r0, #1
    27ec:	0000180e 	andeq	r1, r0, lr, lsl #16
    27f0:	0212d501 	andseq	sp, r2, #4194304	; 0x400000
    27f4:	02000001 	andeq	r0, r0, #1
    27f8:	ec136c91 	ldc	12, cr6, [r3], {145}	; 0x91
    27fc:	0100000e 	tsteq	r0, lr
    2800:	01041ed5 	ldrdeq	r1, [r4, -r5]
    2804:	91020000 	mrsls	r0, (UNDEF: 2)
    2808:	656d0e68 	strbvs	r0, [sp, #-3688]!	; 0xfffff198
    280c:	d701006d 	strle	r0, [r1, -sp, rrx]
    2810:	00011608 	andeq	r1, r1, r8, lsl #12
    2814:	70910200 	addsvc	r0, r1, r0, lsl #4
    2818:	00aa740d 	adceq	r7, sl, sp, lsl #8
    281c:	00003c00 	andeq	r3, r0, r0, lsl #24
    2820:	00690e00 	rsbeq	r0, r9, r0, lsl #28
    2824:	040bd901 	streq	sp, [fp], #-2305	; 0xfffff6ff
    2828:	02000001 	andeq	r0, r0, #1
    282c:	00007491 	muleq	r0, r1, r4
    2830:	0016e414 	andseq	lr, r6, r4, lsl r4
    2834:	05cb0100 	strbeq	r0, [fp, #256]	; 0x100
    2838:	000017dd 	ldrdeq	r1, [r0], -sp
    283c:	00000104 	andeq	r0, r0, r4, lsl #2
    2840:	0000aa04 	andeq	sl, r0, r4, lsl #20
    2844:	00000054 	andeq	r0, r0, r4, asr r0
    2848:	01b49c01 			; <UNDEFINED> instruction: 0x01b49c01
    284c:	730b0000 	movwvc	r0, #45056	; 0xb000
    2850:	18cb0100 	stmiane	fp, {r8}^
    2854:	00000110 	andeq	r0, r0, r0, lsl r1
    2858:	0e6c9102 	lgneqe	f1, f2
    285c:	cd010069 	stcgt	0, cr0, [r1, #-420]	; 0xfffffe5c
    2860:	00010406 	andeq	r0, r1, r6, lsl #8
    2864:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2868:	17c81400 	strbne	r1, [r8, r0, lsl #8]
    286c:	bb010000 	bllt	42874 <__bss_end+0x36f3c>
    2870:	0017ea05 	andseq	lr, r7, r5, lsl #20
    2874:	00010400 	andeq	r0, r1, r0, lsl #8
    2878:	00a95800 	adceq	r5, r9, r0, lsl #16
    287c:	0000ac00 	andeq	sl, r0, r0, lsl #24
    2880:	1a9c0100 	bne	fe702c88 <__bss_end+0xfe6f7350>
    2884:	0b000002 	bleq	2894 <shift+0x2894>
    2888:	01003173 	tsteq	r0, r3, ror r1
    288c:	011019bb 			; <UNDEFINED> instruction: 0x011019bb
    2890:	91020000 	mrsls	r0, (UNDEF: 2)
    2894:	32730b6c 	rsbscc	r0, r3, #108, 22	; 0x1b000
    2898:	29bb0100 	ldmibcs	fp!, {r8}
    289c:	00000110 	andeq	r0, r0, r0, lsl r1
    28a0:	0b689102 	bleq	1a26cb0 <__bss_end+0x1a1b378>
    28a4:	006d756e 	rsbeq	r7, sp, lr, ror #10
    28a8:	0431bb01 	ldrteq	fp, [r1], #-2817	; 0xfffff4ff
    28ac:	02000001 	andeq	r0, r0, #1
    28b0:	750e6491 	strvc	r6, [lr, #-1169]	; 0xfffffb6f
    28b4:	bd010031 	stclt	0, cr0, [r1, #-196]	; 0xffffff3c
    28b8:	00021a10 	andeq	r1, r2, r0, lsl sl
    28bc:	77910200 	ldrvc	r0, [r1, r0, lsl #4]
    28c0:	0032750e 	eorseq	r7, r2, lr, lsl #10
    28c4:	1a14bd01 	bne	531cd0 <__bss_end+0x526398>
    28c8:	02000002 	andeq	r0, r0, #2
    28cc:	08007691 	stmdaeq	r0, {r0, r4, r7, r9, sl, ip, sp, lr}
    28d0:	0d710801 	ldcleq	8, cr0, [r1, #-4]!
    28d4:	05140000 	ldreq	r0, [r4, #-0]
    28d8:	01000017 	tsteq	r0, r7, lsl r0
    28dc:	177507ad 	ldrbne	r0, [r5, -sp, lsr #15]!
    28e0:	01160000 	tsteq	r6, r0
    28e4:	a8840000 	stmge	r4, {}	; <UNPREDICTABLE>
    28e8:	00d40000 	sbcseq	r0, r4, r0
    28ec:	9c010000 	stcls	0, cr0, [r1], {-0}
    28f0:	00000278 	andeq	r0, r0, r8, ror r2
    28f4:	0016f613 	andseq	pc, r6, r3, lsl r6	; <UNPREDICTABLE>
    28f8:	14ad0100 	strtne	r0, [sp], #256	; 0x100
    28fc:	00000116 	andeq	r0, r0, r6, lsl r1
    2900:	0b6c9102 	bleq	1b26d10 <__bss_end+0x1b1b3d8>
    2904:	00637273 	rsbeq	r7, r3, r3, ror r2
    2908:	1026ad01 	eorne	sl, r6, r1, lsl #26
    290c:	02000001 	andeq	r0, r0, #1
    2910:	690e6891 	stmdbvs	lr, {r0, r4, r7, fp, sp, lr}
    2914:	09af0100 	stmibeq	pc!, {r8}	; <UNPREDICTABLE>
    2918:	00000104 	andeq	r0, r0, r4, lsl #2
    291c:	0e749102 	expeqs	f1, f2
    2920:	af01006a 	svcge	0x0001006a
    2924:	0001040b 	andeq	r0, r1, fp, lsl #8
    2928:	70910200 	addsvc	r0, r1, r0, lsl #4
    292c:	17181400 	ldrne	r1, [r8, -r0, lsl #8]
    2930:	a1010000 	mrsge	r0, (UNDEF: 1)
    2934:	00176407 	andseq	r6, r7, r7, lsl #8
    2938:	00011600 	andeq	r1, r1, r0, lsl #12
    293c:	00a7c400 	adceq	ip, r7, r0, lsl #8
    2940:	0000c000 	andeq	ip, r0, r0
    2944:	d19c0100 	orrsle	r0, ip, r0, lsl #2
    2948:	13000002 	movwne	r0, #2
    294c:	000016f6 	strdeq	r1, [r0], -r6
    2950:	1615a101 	ldrne	sl, [r5], -r1, lsl #2
    2954:	02000001 	andeq	r0, r0, #1
    2958:	730b6c91 	movwvc	r6, #48273	; 0xbc91
    295c:	01006372 	tsteq	r0, r2, ror r3
    2960:	011027a1 	tsteq	r0, r1, lsr #15
    2964:	91020000 	mrsls	r0, (UNDEF: 2)
    2968:	756e0b68 	strbvc	r0, [lr, #-2920]!	; 0xfffff498
    296c:	a101006d 	tstge	r1, sp, rrx
    2970:	00010430 	andeq	r0, r1, r0, lsr r4
    2974:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    2978:	0100690e 	tsteq	r0, lr, lsl #18
    297c:	010406a3 	smlatbeq	r4, r3, r6, r0
    2980:	91020000 	mrsls	r0, (UNDEF: 2)
    2984:	b1150074 	tstlt	r5, r4, ror r0
    2988:	01000017 	tsteq	r0, r7, lsl r0
    298c:	17200673 			; <UNDEFINED> instruction: 0x17200673
    2990:	a58c0000 	strge	r0, [ip]
    2994:	02380000 	eorseq	r0, r8, #0
    2998:	9c010000 	stcls	0, cr0, [r1], {-0}
    299c:	0000036d 	andeq	r0, r0, sp, ror #6
    29a0:	000f1a13 	andeq	r1, pc, r3, lsl sl	; <UNPREDICTABLE>
    29a4:	11730100 	cmnne	r3, r0, lsl #2
    29a8:	00000116 	andeq	r0, r0, r6, lsl r1
    29ac:	135c9102 	cmpne	ip, #-2147483648	; 0x80000000
    29b0:	000009ea 	andeq	r0, r0, sl, ror #19
    29b4:	6d1f7301 	ldcvs	3, cr7, [pc, #-4]	; 29b8 <shift+0x29b8>
    29b8:	02000003 	andeq	r0, r0, #3
    29bc:	d60c5891 			; <UNDEFINED> instruction: 0xd60c5891
    29c0:	01000016 	tsteq	r0, r6, lsl r0
    29c4:	01040974 	tsteq	r4, r4, ror r9
    29c8:	91020000 	mrsls	r0, (UNDEF: 2)
    29cc:	18150c74 	ldmdane	r5, {r2, r4, r5, r6, sl, fp}
    29d0:	75010000 	strvc	r0, [r1, #-0]
    29d4:	00010409 	andeq	r0, r1, r9, lsl #8
    29d8:	70910200 	addsvc	r0, r1, r0, lsl #4
    29dc:	0017d00c 	andseq	sp, r7, ip
    29e0:	0f760100 	svceq	0x00760100
    29e4:	0000010b 	andeq	r0, r0, fp, lsl #2
    29e8:	166c9102 	strbtne	r9, [ip], -r2, lsl #2
    29ec:	0000a634 	andeq	sl, r0, r4, lsr r6
    29f0:	00000070 	andeq	r0, r0, r0, ror r0
    29f4:	00000353 	andeq	r0, r0, r3, asr r3
    29f8:	0017930c 	andseq	r9, r7, ip, lsl #6
    29fc:	0d860100 	stfeqs	f0, [r6]
    2a00:	00000104 	andeq	r0, r0, r4, lsl #2
    2a04:	00689102 	rsbeq	r9, r8, r2, lsl #2
    2a08:	00a7300d 	adceq	r3, r7, sp
    2a0c:	00007000 	andeq	r7, r0, r0
    2a10:	17930c00 	ldrne	r0, [r3, r0, lsl #24]
    2a14:	99010000 	stmdbls	r1, {}	; <UNPREDICTABLE>
    2a18:	0001040d 	andeq	r0, r1, sp, lsl #8
    2a1c:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    2a20:	04080000 	streq	r0, [r8], #-0
    2a24:	001bfe04 	andseq	pc, fp, r4, lsl #28
    2a28:	17991400 	ldrne	r1, [r9, r0, lsl #8]
    2a2c:	4a010000 	bmi	42a34 <__bss_end+0x370fc>
    2a30:	0016eb07 	andseq	lr, r6, r7, lsl #22
    2a34:	00036d00 	andeq	r6, r3, r0, lsl #26
    2a38:	00a2d800 	adceq	sp, r2, r0, lsl #16
    2a3c:	0002b400 	andeq	fp, r2, r0, lsl #8
    2a40:	ed9c0100 	ldfs	f0, [ip]
    2a44:	0b000003 	bleq	2a58 <shift+0x2a58>
    2a48:	4a010073 	bmi	42c1c <__bss_end+0x372e4>
    2a4c:	00011018 	andeq	r1, r1, r8, lsl r0
    2a50:	5c910200 	lfmpl	f0, 4, [r1], {0}
    2a54:	0100610e 	tsteq	r0, lr, lsl #2
    2a58:	036d094c 	cmneq	sp, #76, 18	; 0x130000
    2a5c:	91020000 	mrsls	r0, (UNDEF: 2)
    2a60:	00650e74 	rsbeq	r0, r5, r4, ror lr
    2a64:	04074d01 	streq	r4, [r7], #-3329	; 0xfffff2ff
    2a68:	02000001 	andeq	r0, r0, #1
    2a6c:	630e7091 	movwvs	r7, #57489	; 0xe091
    2a70:	074e0100 	strbeq	r0, [lr, -r0, lsl #2]
    2a74:	00000104 	andeq	r0, r0, r4, lsl #2
    2a78:	0d6c9102 	stfeqp	f1, [ip, #-8]!
    2a7c:	0000a420 	andeq	sl, r0, r0, lsr #8
    2a80:	000000e0 	andeq	r0, r0, r0, ror #1
    2a84:	0016fb0c 	andseq	pc, r6, ip, lsl #22
    2a88:	09590100 	ldmdbeq	r9, {r8}^
    2a8c:	00000104 	andeq	r0, r0, r4, lsl #2
    2a90:	0e689102 	lgneqe	f1, f2
    2a94:	5a010069 	bpl	42c40 <__bss_end+0x37308>
    2a98:	00010409 	andeq	r0, r1, r9, lsl #8
    2a9c:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    2aa0:	b0140000 	andslt	r0, r4, r0
    2aa4:	01000016 	tsteq	r0, r6, lsl r0
    2aa8:	17840539 			; <UNDEFINED> instruction: 0x17840539
    2aac:	01040000 	mrseq	r0, (UNDEF: 4)
    2ab0:	a2100000 	andsge	r0, r0, #0
    2ab4:	00c80000 	sbceq	r0, r8, r0
    2ab8:	9c010000 	stcls	0, cr0, [r1], {-0}
    2abc:	00000439 	andeq	r0, r0, r9, lsr r4
    2ac0:	6c61760b 	stclvs	6, cr7, [r1], #-44	; 0xffffffd4
    2ac4:	16390100 	ldrtne	r0, [r9], -r0, lsl #2
    2ac8:	00000439 	andeq	r0, r0, r9, lsr r4
    2acc:	0c6c9102 	stfeqp	f1, [ip], #-8
    2ad0:	000016d6 	ldrdeq	r1, [r0], -r6
    2ad4:	04093a01 	streq	r3, [r9], #-2561	; 0xfffff5ff
    2ad8:	02000001 	andeq	r0, r0, #1
    2adc:	ea0c7491 	b	31fd28 <__bss_end+0x3143f0>
    2ae0:	01000009 	tsteq	r0, r9
    2ae4:	036d0b3b 	cmneq	sp, #60416	; 0xec00
    2ae8:	91020000 	mrsls	r0, (UNDEF: 2)
    2aec:	040f0070 	streq	r0, [pc], #-112	; 2af4 <shift+0x2af4>
    2af0:	0000036d 	andeq	r0, r0, sp, ror #6
    2af4:	0016df14 	andseq	sp, r6, r4, lsl pc
    2af8:	05260100 	streq	r0, [r6, #-256]!	; 0xffffff00
    2afc:	000017fc 	strdeq	r1, [r0], -ip
    2b00:	00000104 	andeq	r0, r0, r4, lsl #2
    2b04:	0000a174 	andeq	sl, r0, r4, ror r1
    2b08:	0000009c 	muleq	r0, ip, r0
    2b0c:	047c9c01 	ldrbteq	r9, [ip], #-3073	; 0xfffff3ff
    2b10:	09130000 	ldmdbeq	r3, {}	; <UNPREDICTABLE>
    2b14:	0100000b 	tsteq	r0, fp
    2b18:	01101626 	tsteq	r0, r6, lsr #12
    2b1c:	91020000 	mrsls	r0, (UNDEF: 2)
    2b20:	18070c6c 	stmdane	r7, {r2, r3, r5, r6, sl, fp}
    2b24:	28010000 	stmdacs	r1, {}	; <UNPREDICTABLE>
    2b28:	00010406 	andeq	r0, r1, r6, lsl #8
    2b2c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    2b30:	17001700 	strne	r1, [r0, -r0, lsl #14]
    2b34:	0a010000 	beq	42b3c <__bss_end+0x37204>
    2b38:	0016ca06 	andseq	ip, r6, r6, lsl #20
    2b3c:	00a00000 	adceq	r0, r0, r0
    2b40:	00017400 	andeq	r7, r1, r0, lsl #8
    2b44:	139c0100 	orrsne	r0, ip, #0, 2
    2b48:	00000b09 	andeq	r0, r0, r9, lsl #22
    2b4c:	66180a01 	ldrvs	r0, [r8], -r1, lsl #20
    2b50:	02000000 	andeq	r0, r0, #0
    2b54:	07136491 			; <UNDEFINED> instruction: 0x07136491
    2b58:	01000018 	tsteq	r0, r8, lsl r0
    2b5c:	0116250a 	tsteq	r6, sl, lsl #10
    2b60:	91020000 	mrsls	r0, (UNDEF: 2)
    2b64:	17c31360 	strbne	r1, [r3, r0, ror #6]
    2b68:	0a010000 	beq	42b70 <__bss_end+0x37238>
    2b6c:	0000663a 	andeq	r6, r0, sl, lsr r6
    2b70:	5c910200 	lfmpl	f0, 4, [r1], {0}
    2b74:	0100690e 	tsteq	r0, lr, lsl #18
    2b78:	0104060c 	tsteq	r4, ip, lsl #12
    2b7c:	91020000 	mrsls	r0, (UNDEF: 2)
    2b80:	a0cc0d74 	sbcge	r0, ip, r4, ror sp
    2b84:	00980000 	addseq	r0, r8, r0
    2b88:	6a0e0000 	bvs	382b90 <__bss_end+0x377258>
    2b8c:	0b1e0100 	bleq	782f94 <__bss_end+0x77765c>
    2b90:	00000104 	andeq	r0, r0, r4, lsl #2
    2b94:	0d709102 	ldfeqp	f1, [r0, #-8]!
    2b98:	0000a0f4 	strdeq	sl, [r0], -r4
    2b9c:	00000060 	andeq	r0, r0, r0, rrx
    2ba0:	0100630e 	tsteq	r0, lr, lsl #6
    2ba4:	006d0820 	rsbeq	r0, sp, r0, lsr #16
    2ba8:	91020000 	mrsls	r0, (UNDEF: 2)
    2bac:	0000006f 	andeq	r0, r0, pc, rrx
    2bb0:	000aee00 	andeq	lr, sl, r0, lsl #28
    2bb4:	70000400 	andvc	r0, r0, r0, lsl #8
    2bb8:	0400000a 	streq	r0, [r0], #-10
    2bbc:	00158d01 	andseq	r8, r5, r1, lsl #26
    2bc0:	182e0400 	stmdane	lr!, {sl}
    2bc4:	13c20000 	bicne	r0, r2, #0
    2bc8:	ab400000 	blge	1002bd0 <__bss_end+0xff7298>
    2bcc:	016c0000 	cmneq	ip, r0
    2bd0:	12eb0000 	rscne	r0, fp, #0
    2bd4:	01020000 	mrseq	r0, (UNDEF: 2)
    2bd8:	000d7a08 	andeq	r7, sp, r8, lsl #20
    2bdc:	00250300 	eoreq	r0, r5, r0, lsl #6
    2be0:	02020000 	andeq	r0, r2, #0
    2be4:	000dbc05 	andeq	fp, sp, r5, lsl #24
    2be8:	05040400 	streq	r0, [r4, #-1024]	; 0xfffffc00
    2bec:	00746e69 	rsbseq	r6, r4, r9, ror #28
    2bf0:	71080102 	tstvc	r8, r2, lsl #2
    2bf4:	0200000d 	andeq	r0, r0, #13
    2bf8:	0a3c0702 	beq	f04808 <__bss_end+0xef8ed0>
    2bfc:	82050000 	andhi	r0, r5, #0
    2c00:	0900000e 	stmdbeq	r0, {r1, r2, r3}
    2c04:	005e0709 	subseq	r0, lr, r9, lsl #14
    2c08:	4d030000 	stcmi	0, cr0, [r3, #-0]
    2c0c:	02000000 	andeq	r0, r0, #0
    2c10:	1e340704 	cdpne	7, 3, cr0, cr4, cr4, {0}
    2c14:	ac060000 	stcge	0, cr0, [r6], {-0}
    2c18:	8800000b 	stmdahi	r0, {r0, r1, r3}
    2c1c:	70070702 	andvc	r0, r7, r2, lsl #14
    2c20:	07000001 	streq	r0, [r0, -r1]
    2c24:	00000f1a 	andeq	r0, r0, sl, lsl pc
    2c28:	700e0b02 	andvc	r0, lr, r2, lsl #22
    2c2c:	00000001 	andeq	r0, r0, r1
    2c30:	000bde07 	andeq	sp, fp, r7, lsl #28
    2c34:	120e0200 	andne	r0, lr, #0, 4
    2c38:	0000004d 	andeq	r0, r0, sp, asr #32
    2c3c:	0fda0780 	svceq	0x00da0780
    2c40:	0f020000 	svceq	0x00020000
    2c44:	00004d12 	andeq	r4, r0, r2, lsl sp
    2c48:	ac088400 	cfstrsge	mvf8, [r8], {-0}
    2c4c:	0200000b 	andeq	r0, r0, #11
    2c50:	0bfb0913 	bleq	ffec50a4 <__bss_end+0xffeb976c>
    2c54:	01800000 	orreq	r0, r0, r0
    2c58:	b2010000 	andlt	r0, r1, #0
    2c5c:	b8000000 	stmdalt	r0, {}	; <UNPREDICTABLE>
    2c60:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    2c64:	00000180 	andeq	r0, r0, r0, lsl #3
    2c68:	118d0800 	orrne	r0, sp, r0, lsl #16
    2c6c:	16020000 	strne	r0, [r2], -r0
    2c70:	00071512 	andeq	r1, r7, r2, lsl r5
    2c74:	00004d00 	andeq	r4, r0, r0, lsl #26
    2c78:	00d10100 	sbcseq	r0, r1, r0, lsl #2
    2c7c:	00dc0000 	sbcseq	r0, ip, r0
    2c80:	80090000 	andhi	r0, r9, r0
    2c84:	0a000001 	beq	2c90 <shift+0x2c90>
    2c88:	00000186 	andeq	r0, r0, r6, lsl #3
    2c8c:	118d0800 	orrne	r0, sp, r0, lsl #16
    2c90:	19020000 	stmdbne	r2, {}	; <UNPREDICTABLE>
    2c94:	0005c812 	andeq	ip, r5, r2, lsl r8
    2c98:	00004d00 	andeq	r4, r0, r0, lsl #26
    2c9c:	00f50100 	rscseq	r0, r5, r0, lsl #2
    2ca0:	01050000 	mrseq	r0, (UNDEF: 5)
    2ca4:	80090000 	andhi	r0, r9, r0
    2ca8:	0a000001 	beq	2cb4 <shift+0x2cb4>
    2cac:	00000186 	andeq	r0, r0, r6, lsl #3
    2cb0:	00004d0a 	andeq	r4, r0, sl, lsl #26
    2cb4:	28080000 	stmdacs	r8, {}	; <UNPREDICTABLE>
    2cb8:	02000012 	andeq	r0, r0, #18
    2cbc:	0397121c 	orrseq	r1, r7, #28, 4	; 0xc0000001
    2cc0:	004d0000 	subeq	r0, sp, r0
    2cc4:	1e010000 	cdpne	0, 0, cr0, cr1, cr0, {0}
    2cc8:	2e000001 	cdpcs	0, 0, cr0, cr0, cr1, {0}
    2ccc:	09000001 	stmdbeq	r0, {r0}
    2cd0:	00000180 	andeq	r0, r0, r0, lsl #3
    2cd4:	0000250a 	andeq	r2, r0, sl, lsl #10
    2cd8:	01860a00 	orreq	r0, r6, r0, lsl #20
    2cdc:	0b000000 	bleq	2ce4 <shift+0x2ce4>
    2ce0:	00000b5d 	andeq	r0, r0, sp, asr fp
    2ce4:	0e0e1f02 	cdpeq	15, 0, cr1, cr14, cr2, {0}
    2ce8:	0100000e 	tsteq	r0, lr
    2cec:	00000143 	andeq	r0, r0, r3, asr #2
    2cf0:	00000153 	andeq	r0, r0, r3, asr r1
    2cf4:	00018009 	andeq	r8, r1, r9
    2cf8:	01860a00 	orreq	r0, r6, r0, lsl #20
    2cfc:	4d0a0000 	stcmi	0, cr0, [sl, #-0]
    2d00:	00000000 	andeq	r0, r0, r0
    2d04:	000b5d0c 	andeq	r5, fp, ip, lsl #26
    2d08:	0e220200 	cdpeq	2, 2, cr0, cr2, cr0, {0}
    2d0c:	00000dc6 	andeq	r0, r0, r6, asr #27
    2d10:	00016401 	andeq	r6, r1, r1, lsl #8
    2d14:	01800900 	orreq	r0, r0, r0, lsl #18
    2d18:	250a0000 	strcs	r0, [sl, #-0]
    2d1c:	00000000 	andeq	r0, r0, r0
    2d20:	00250d00 	eoreq	r0, r5, r0, lsl #26
    2d24:	01800000 	orreq	r0, r0, r0
    2d28:	5e0e0000 	cdppl	0, 0, cr0, cr14, cr0, {0}
    2d2c:	7f000000 	svcvc	0x00000000
    2d30:	65040f00 	strvs	r0, [r4, #-3840]	; 0xfffff100
    2d34:	0f000000 	svceq	0x00000000
    2d38:	00002504 	andeq	r2, r0, r4, lsl #10
    2d3c:	05380600 	ldreq	r0, [r8, #-1536]!	; 0xfffffa00
    2d40:	03880000 	orreq	r0, r8, #0
    2d44:	01ef0708 	mvneq	r0, r8, lsl #14
    2d48:	63100000 	tstvs	r0, #0
    2d4c:	0c030062 	stceq	0, cr0, [r3], {98}	; 0x62
    2d50:	00006519 	andeq	r6, r0, r9, lsl r5
    2d54:	38080000 	stmdacc	r8, {}	; <UNPREDICTABLE>
    2d58:	03000005 	movweq	r0, #5
    2d5c:	05a50910 	streq	r0, [r5, #2320]!	; 0x910
    2d60:	01ef0000 	mvneq	r0, r0
    2d64:	be010000 	cdplt	0, 0, cr0, cr1, cr0, {0}
    2d68:	c4000001 	strgt	r0, [r0], #-1
    2d6c:	09000001 	stmdbeq	r0, {r0}
    2d70:	000001ef 	andeq	r0, r0, pc, ror #3
    2d74:	0c141100 	ldfeqs	f1, [r4], {-0}
    2d78:	13030000 	movwne	r0, #12288	; 0x3000
    2d7c:	00073212 	andeq	r3, r7, r2, lsl r2
    2d80:	00004d00 	andeq	r4, r0, r0, lsl #26
    2d84:	01d90100 	bicseq	r0, r9, r0, lsl #2
    2d88:	ef090000 	svc	0x00090000
    2d8c:	0a000001 	beq	2d98 <shift+0x2d98>
    2d90:	00000186 	andeq	r0, r0, r6, lsl #3
    2d94:	00004d0a 	andeq	r4, r0, sl, lsl #26
    2d98:	01fa0a00 	mvnseq	r0, r0, lsl #20
    2d9c:	00000000 	andeq	r0, r0, r0
    2da0:	018c040f 	orreq	r0, ip, pc, lsl #8
    2da4:	ef030000 	svc	0x00030000
    2da8:	02000001 	andeq	r0, r0, #1
    2dac:	0ac80201 	beq	ff2035b8 <__bss_end+0xff1f7c80>
    2db0:	36120000 	ldrcc	r0, [r2], -r0
    2db4:	08000008 	stmdaeq	r0, {r3}
    2db8:	27080604 	strcs	r0, [r8, -r4, lsl #12]
    2dbc:	10000002 	andne	r0, r0, r2
    2dc0:	04003072 	streq	r3, [r0], #-114	; 0xffffff8e
    2dc4:	004d0e08 	subeq	r0, sp, r8, lsl #28
    2dc8:	10000000 	andne	r0, r0, r0
    2dcc:	04003172 	streq	r3, [r0], #-370	; 0xfffffe8e
    2dd0:	004d0e09 	subeq	r0, sp, r9, lsl #28
    2dd4:	00040000 	andeq	r0, r4, r0
    2dd8:	00063713 	andeq	r3, r6, r3, lsl r7
    2ddc:	38040500 	stmdacc	r4, {r8, sl}
    2de0:	04000000 	streq	r0, [r0], #-0
    2de4:	025e0c1f 	subseq	r0, lr, #7936	; 0x1f00
    2de8:	b5140000 	ldrlt	r0, [r4, #-0]
    2dec:	00000008 	andeq	r0, r0, r8
    2df0:	00128914 	andseq	r8, r2, r4, lsl r9
    2df4:	53140100 	tstpl	r4, #0, 2
    2df8:	02000012 	andeq	r0, r0, #18
    2dfc:	000ab814 	andeq	fp, sl, r4, lsl r8
    2e00:	b3140300 	tstlt	r4, #0, 6
    2e04:	0400000c 	streq	r0, [r0], #-12
    2e08:	00086614 	andeq	r6, r8, r4, lsl r6
    2e0c:	13000500 	movwne	r0, #1280	; 0x500
    2e10:	000010d0 	ldrdeq	r1, [r0], -r0
    2e14:	00380405 	eorseq	r0, r8, r5, lsl #8
    2e18:	40040000 	andmi	r0, r4, r0
    2e1c:	00029b0c 	andeq	r9, r2, ip, lsl #22
    2e20:	03f61400 	mvnseq	r1, #0, 8
    2e24:	14000000 	strne	r0, [r0], #-0
    2e28:	00000664 	andeq	r0, r0, r4, ror #12
    2e2c:	0c871401 	cfstrseq	mvf1, [r7], {1}
    2e30:	14020000 	strne	r0, [r2], #-0
    2e34:	00001192 	muleq	r0, r2, r1
    2e38:	12931403 	addsne	r1, r3, #50331648	; 0x3000000
    2e3c:	14040000 	strne	r0, [r4], #-0
    2e40:	00000be9 	andeq	r0, r0, r9, ror #23
    2e44:	0a5c1405 	beq	1707e60 <__bss_end+0x16fc528>
    2e48:	00060000 	andeq	r0, r6, r0
    2e4c:	000dfa13 	andeq	pc, sp, r3, lsl sl	; <UNPREDICTABLE>
    2e50:	38040500 	stmdacc	r4, {r8, sl}
    2e54:	04000000 	streq	r0, [r0], #-0
    2e58:	02b40c6f 	adcseq	r0, r4, #28416	; 0x6f00
    2e5c:	ae140000 	cdpge	0, 1, cr0, cr4, cr0, {0}
    2e60:	0000000c 	andeq	r0, r0, ip
    2e64:	0c271500 	cfstr32eq	mvfx1, [r7], #-0
    2e68:	05050000 	streq	r0, [r5, #-0]
    2e6c:	00005914 	andeq	r5, r0, r4, lsl r9
    2e70:	34030500 	strcc	r0, [r3], #-1280	; 0xfffffb00
    2e74:	150000b4 	strne	r0, [r0, #-180]	; 0xffffff4c
    2e78:	00000c51 	andeq	r0, r0, r1, asr ip
    2e7c:	59140605 	ldmdbpl	r4, {r0, r2, r9, sl}
    2e80:	05000000 	streq	r0, [r0, #-0]
    2e84:	00b43803 	adcseq	r3, r4, r3, lsl #16
    2e88:	0bc81500 	bleq	ff208290 <__bss_end+0xff1fc958>
    2e8c:	07060000 	streq	r0, [r6, -r0]
    2e90:	0000591a 	andeq	r5, r0, sl, lsl r9
    2e94:	3c030500 	cfstr32cc	mvfx0, [r3], {-0}
    2e98:	150000b4 	strne	r0, [r0, #-180]	; 0xffffff4c
    2e9c:	000006f3 	strdeq	r0, [r0], -r3
    2ea0:	591a0906 	ldmdbpl	sl, {r1, r2, r8, fp}
    2ea4:	05000000 	streq	r0, [r0, #-0]
    2ea8:	00b44003 	adcseq	r4, r4, r3
    2eac:	0d511500 	cfldr64eq	mvdx1, [r1, #-0]
    2eb0:	0b060000 	bleq	182eb8 <__bss_end+0x177580>
    2eb4:	0000591a 	andeq	r5, r0, sl, lsl r9
    2eb8:	44030500 	strmi	r0, [r3], #-1280	; 0xfffffb00
    2ebc:	150000b4 	strne	r0, [r0, #-180]	; 0xffffff4c
    2ec0:	000009fd 	strdeq	r0, [r0], -sp
    2ec4:	591a0d06 	ldmdbpl	sl, {r1, r2, r8, sl, fp}
    2ec8:	05000000 	streq	r0, [r0, #-0]
    2ecc:	00b44803 	adcseq	r4, r4, r3, lsl #16
    2ed0:	084f1500 	stmdaeq	pc, {r8, sl, ip}^	; <UNPREDICTABLE>
    2ed4:	0f060000 	svceq	0x00060000
    2ed8:	0000591a 	andeq	r5, r0, sl, lsl r9
    2edc:	4c030500 	cfstr32mi	mvfx0, [r3], {-0}
    2ee0:	130000b4 	movwne	r0, #180	; 0xb4
    2ee4:	00000ecc 	andeq	r0, r0, ip, asr #29
    2ee8:	00380405 	eorseq	r0, r8, r5, lsl #8
    2eec:	1b060000 	blne	182ef4 <__bss_end+0x1775bc>
    2ef0:	0003570c 	andeq	r5, r3, ip, lsl #14
    2ef4:	0efe1400 	cdpeq	4, 15, cr1, cr14, cr0, {0}
    2ef8:	14000000 	strne	r0, [r0], #-0
    2efc:	00001232 	andeq	r1, r0, r2, lsr r2
    2f00:	0c821401 	cfstrseq	mvf1, [r2], {1}
    2f04:	00020000 	andeq	r0, r2, r0
    2f08:	000d2616 	andeq	r2, sp, r6, lsl r6
    2f0c:	0db00600 	ldceq	6, cr0, [r0]
    2f10:	06900000 	ldreq	r0, [r0], r0
    2f14:	04ca0763 	strbeq	r0, [sl], #1891	; 0x763
    2f18:	61120000 	tstvs	r2, r0
    2f1c:	24000011 	strcs	r0, [r0], #-17	; 0xffffffef
    2f20:	e4106706 	ldr	r6, [r0], #-1798	; 0xfffff8fa
    2f24:	07000003 	streq	r0, [r0, -r3]
    2f28:	000021a4 	andeq	r2, r0, r4, lsr #3
    2f2c:	ca126906 	bgt	49d34c <__bss_end+0x491a14>
    2f30:	00000004 	andeq	r0, r0, r4
    2f34:	00061f07 	andeq	r1, r6, r7, lsl #30
    2f38:	126b0600 	rsbne	r0, fp, #0, 12
    2f3c:	000001fa 	strdeq	r0, [r0], -sl
    2f40:	0ef30710 	mrceq	7, 7, r0, cr3, cr0, {0}
    2f44:	6d060000 	stcvs	0, cr0, [r6, #-0]
    2f48:	00004d16 	andeq	r4, r0, r6, lsl sp
    2f4c:	ec071400 	cfstrs	mvf1, [r7], {-0}
    2f50:	06000006 	streq	r0, [r0], -r6
    2f54:	04da1c70 	ldrbeq	r1, [sl], #3184	; 0xc70
    2f58:	07180000 	ldreq	r0, [r8, -r0]
    2f5c:	00000d48 	andeq	r0, r0, r8, asr #26
    2f60:	da1c7206 	ble	71f780 <__bss_end+0x713e48>
    2f64:	1c000004 	stcne	0, cr0, [r0], {4}
    2f68:	0005f207 	andeq	pc, r5, r7, lsl #4
    2f6c:	1c750600 	ldclne	6, cr0, [r5], #-0
    2f70:	000004da 	ldrdeq	r0, [r0], -sl
    2f74:	08bd1720 	popeq	{r5, r8, r9, sl, ip}
    2f78:	77060000 	strvc	r0, [r6, -r0]
    2f7c:	0004691c 	andeq	r6, r4, ip, lsl r9
    2f80:	0004da00 	andeq	sp, r4, r0, lsl #20
    2f84:	0003d800 	andeq	sp, r3, r0, lsl #16
    2f88:	04da0900 	ldrbeq	r0, [sl], #2304	; 0x900
    2f8c:	e00a0000 	and	r0, sl, r0
    2f90:	00000004 	andeq	r0, r0, r4
    2f94:	079c1200 	ldreq	r1, [ip, r0, lsl #4]
    2f98:	06180000 	ldreq	r0, [r8], -r0
    2f9c:	0419107b 	ldreq	r1, [r9], #-123	; 0xffffff85
    2fa0:	a4070000 	strge	r0, [r7], #-0
    2fa4:	06000021 	streq	r0, [r0], -r1, lsr #32
    2fa8:	04ca127e 	strbeq	r1, [sl], #638	; 0x27e
    2fac:	07000000 	streq	r0, [r0, -r0]
    2fb0:	0000060f 	andeq	r0, r0, pc, lsl #12
    2fb4:	e0198006 	ands	r8, r9, r6
    2fb8:	10000004 	andne	r0, r0, r4
    2fbc:	00119807 	andseq	r9, r1, r7, lsl #16
    2fc0:	21820600 	orrcs	r0, r2, r0, lsl #12
    2fc4:	000004eb 	andeq	r0, r0, fp, ror #9
    2fc8:	e4030014 	str	r0, [r3], #-20	; 0xffffffec
    2fcc:	18000003 	stmdane	r0, {r0, r1}
    2fd0:	00000b6e 	andeq	r0, r0, lr, ror #22
    2fd4:	f1218606 			; <UNDEFINED> instruction: 0xf1218606
    2fd8:	18000004 	stmdane	r0, {r2}
    2fdc:	00000979 	andeq	r0, r0, r9, ror r9
    2fe0:	591f8806 	ldmdbpl	pc, {r1, r2, fp, pc}	; <UNPREDICTABLE>
    2fe4:	07000000 	streq	r0, [r0, -r0]
    2fe8:	00000e33 	andeq	r0, r0, r3, lsr lr
    2fec:	69178b06 	ldmdbvs	r7, {r1, r2, r8, r9, fp, pc}
    2ff0:	00000003 	andeq	r0, r0, r3
    2ff4:	000abe07 	andeq	fp, sl, r7, lsl #28
    2ff8:	178e0600 	strne	r0, [lr, r0, lsl #12]
    2ffc:	00000369 	andeq	r0, r0, r9, ror #6
    3000:	09940724 	ldmibeq	r4, {r2, r5, r8, r9, sl}
    3004:	8f060000 	svchi	0x00060000
    3008:	00036917 	andeq	r6, r3, r7, lsl r9
    300c:	73074800 	movwvc	r4, #30720	; 0x7800
    3010:	06000012 			; <UNDEFINED> instruction: 0x06000012
    3014:	03691790 	cmneq	r9, #144, 14	; 0x2400000
    3018:	086c0000 	stmdaeq	ip!, {}^	; <UNPREDICTABLE>
    301c:	00000db0 			; <UNDEFINED> instruction: 0x00000db0
    3020:	87099306 	strhi	r9, [r9, -r6, lsl #6]
    3024:	fc000007 	stc2	0, cr0, [r0], {7}
    3028:	01000004 	tsteq	r0, r4
    302c:	00000483 	andeq	r0, r0, r3, lsl #9
    3030:	00000489 	andeq	r0, r0, r9, lsl #9
    3034:	0004fc09 	andeq	pc, r4, r9, lsl #24
    3038:	630b0000 	movwvs	r0, #45056	; 0xb000
    303c:	0600000b 	streq	r0, [r0], -fp
    3040:	0a8b0e96 	beq	fe2c6aa0 <__bss_end+0xfe2bb168>
    3044:	9e010000 	cdpls	0, 0, cr0, cr1, cr0, {0}
    3048:	a4000004 	strge	r0, [r0], #-4
    304c:	09000004 	stmdbeq	r0, {r2}
    3050:	000004fc 	strdeq	r0, [r0], -ip
    3054:	03f61100 	mvnseq	r1, #0, 2
    3058:	99060000 	stmdbls	r6, {}	; <UNPREDICTABLE>
    305c:	000eb110 	andeq	fp, lr, r0, lsl r1
    3060:	00050200 	andeq	r0, r5, r0, lsl #4
    3064:	04b90100 	ldrteq	r0, [r9], #256	; 0x100
    3068:	fc090000 	stc2	0, cr0, [r9], {-0}
    306c:	0a000004 	beq	3084 <shift+0x3084>
    3070:	000004e0 	andeq	r0, r0, r0, ror #9
    3074:	0003320a 	andeq	r3, r3, sl, lsl #4
    3078:	0d000000 	stceq	0, cr0, [r0, #-0]
    307c:	00000025 	andeq	r0, r0, r5, lsr #32
    3080:	000004da 	ldrdeq	r0, [r0], -sl
    3084:	00005e0e 	andeq	r5, r0, lr, lsl #28
    3088:	0f000f00 	svceq	0x00000f00
    308c:	00036904 	andeq	r6, r3, r4, lsl #18
    3090:	2c040f00 	stccs	15, cr0, [r4], {-0}
    3094:	16000000 	strne	r0, [r0], -r0
    3098:	000011ec 	andeq	r1, r0, ip, ror #3
    309c:	04e6040f 	strbteq	r0, [r6], #1039	; 0x40f
    30a0:	190d0000 	stmdbne	sp, {}	; <UNPREDICTABLE>
    30a4:	fc000004 	stc2	0, cr0, [r0], {4}
    30a8:	19000004 	stmdbne	r0, {r2}
    30ac:	5c040f00 	stcpl	15, cr0, [r4], {-0}
    30b0:	0f000003 	svceq	0x00000003
    30b4:	00035704 	andeq	r5, r3, r4, lsl #14
    30b8:	0e391a00 	vaddeq.f32	s2, s18, s0
    30bc:	9c060000 	stcls	0, cr0, [r6], {-0}
    30c0:	00035c14 	andeq	r5, r3, r4, lsl ip
    30c4:	091c1500 	ldmdbeq	ip, {r8, sl, ip}
    30c8:	04070000 	streq	r0, [r7], #-0
    30cc:	00005914 	andeq	r5, r0, r4, lsl r9
    30d0:	50030500 	andpl	r0, r3, r0, lsl #10
    30d4:	150000b4 	strne	r0, [r0, #-180]	; 0xffffff4c
    30d8:	000003e0 	andeq	r0, r0, r0, ror #7
    30dc:	59140707 	ldmdbpl	r4, {r0, r1, r2, r8, r9, sl}
    30e0:	05000000 	streq	r0, [r0, #-0]
    30e4:	00b45403 	adcseq	r5, r4, r3, lsl #8
    30e8:	07631500 	strbeq	r1, [r3, -r0, lsl #10]!
    30ec:	0a070000 	beq	1c30f4 <__bss_end+0x1b77bc>
    30f0:	00005914 	andeq	r5, r0, r4, lsl r9
    30f4:	58030500 	stmdapl	r3, {r8, sl}
    30f8:	130000b4 	movwne	r0, #180	; 0xb4
    30fc:	00000b18 	andeq	r0, r0, r8, lsl fp
    3100:	00380405 	eorseq	r0, r8, r5, lsl #8
    3104:	0d070000 	stceq	0, cr0, [r7, #-0]
    3108:	0005810c 	andeq	r8, r5, ip, lsl #2
    310c:	654e1b00 	strbvs	r1, [lr, #-2816]	; 0xfffff500
    3110:	14000077 	strne	r0, [r0], #-119	; 0xffffff89
    3114:	00000b0f 	andeq	r0, r0, pc, lsl #22
    3118:	0e451401 	cdpeq	4, 4, cr1, cr5, cr1, {0}
    311c:	14020000 	strne	r0, [r2], #-0
    3120:	00000ae7 	andeq	r0, r0, r7, ror #21
    3124:	0aaa1403 	beq	fea88138 <__bss_end+0xfea7c800>
    3128:	14040000 	strne	r0, [r4], #-0
    312c:	00000c8d 	andeq	r0, r0, sp, lsl #25
    3130:	59120005 	ldmdbpl	r2, {r0, r2}
    3134:	10000008 	andne	r0, r0, r8
    3138:	c0081b07 	andgt	r1, r8, r7, lsl #22
    313c:	10000005 	andne	r0, r0, r5
    3140:	0700726c 	streq	r7, [r0, -ip, ror #4]
    3144:	05c0131d 	strbeq	r1, [r0, #797]	; 0x31d
    3148:	10000000 	andne	r0, r0, r0
    314c:	07007073 	smlsdxeq	r0, r3, r0, r7
    3150:	05c0131e 	strbeq	r1, [r0, #798]	; 0x31e
    3154:	10040000 	andne	r0, r4, r0
    3158:	07006370 	smlsdxeq	r0, r0, r3, r6
    315c:	05c0131f 	strbeq	r1, [r0, #799]	; 0x31f
    3160:	07080000 	streq	r0, [r8, -r0]
    3164:	00000875 	andeq	r0, r0, r5, ror r8
    3168:	c0132007 	andsgt	r2, r3, r7
    316c:	0c000005 	stceq	0, cr0, [r0], {5}
    3170:	07040200 	streq	r0, [r4, -r0, lsl #4]
    3174:	00001e2f 	andeq	r1, r0, pc, lsr #28
    3178:	00044812 	andeq	r4, r4, r2, lsl r8
    317c:	28078000 	stmdacs	r7, {pc}
    3180:	00068a08 	andeq	r8, r6, r8, lsl #20
    3184:	127d0700 	rsbsne	r0, sp, #0, 14
    3188:	2a070000 	bcs	1c3190 <__bss_end+0x1b7858>
    318c:	00058112 	andeq	r8, r5, r2, lsl r1
    3190:	70100000 	andsvc	r0, r0, r0
    3194:	07006469 	streq	r6, [r0, -r9, ror #8]
    3198:	005e122b 	subseq	r1, lr, fp, lsr #4
    319c:	07100000 	ldreq	r0, [r0, -r0]
    31a0:	00001b80 	andeq	r1, r0, r0, lsl #23
    31a4:	4a112c07 	bmi	44e1c8 <__bss_end+0x442890>
    31a8:	14000005 	strne	r0, [r0], #-5
    31ac:	000b3907 	andeq	r3, fp, r7, lsl #18
    31b0:	122d0700 	eorne	r0, sp, #0, 14
    31b4:	0000005e 	andeq	r0, r0, lr, asr r0
    31b8:	0b470718 	bleq	11c4e20 <__bss_end+0x11b94e8>
    31bc:	2e070000 	cdpcs	0, 0, cr0, cr7, cr0, {0}
    31c0:	00005e12 	andeq	r5, r0, r2, lsl lr
    31c4:	42071c00 	andmi	r1, r7, #0, 24
    31c8:	07000008 	streq	r0, [r0, -r8]
    31cc:	068a0c2f 	streq	r0, [sl], pc, lsr #24
    31d0:	07200000 	streq	r0, [r0, -r0]!
    31d4:	00000b7a 	andeq	r0, r0, sl, ror fp
    31d8:	38093007 	stmdacc	r9, {r0, r1, r2, ip, sp}
    31dc:	60000000 	andvs	r0, r0, r0
    31e0:	000f2107 	andeq	r2, pc, r7, lsl #2
    31e4:	0e310700 	cdpeq	7, 3, cr0, cr1, cr0, {0}
    31e8:	0000004d 	andeq	r0, r0, sp, asr #32
    31ec:	08dd0764 	ldmeq	sp, {r2, r5, r6, r8, r9, sl}^
    31f0:	33070000 	movwcc	r0, #28672	; 0x7000
    31f4:	00004d0e 	andeq	r4, r0, lr, lsl #26
    31f8:	d4076800 	strle	r6, [r7], #-2048	; 0xfffff800
    31fc:	07000008 	streq	r0, [r0, -r8]
    3200:	004d0e34 	subeq	r0, sp, r4, lsr lr
    3204:	106c0000 	rsbne	r0, ip, r0
    3208:	07007470 	smlsdxeq	r0, r0, r4, r7
    320c:	069a0c36 			; <UNDEFINED> instruction: 0x069a0c36
    3210:	07700000 	ldrbeq	r0, [r0, -r0]!
    3214:	00001075 	andeq	r1, r0, r5, ror r0
    3218:	4d0e3707 	stcmi	7, cr3, [lr, #-28]	; 0xffffffe4
    321c:	74000000 	strvc	r0, [r0], #-0
    3220:	00052607 	andeq	r2, r5, r7, lsl #12
    3224:	0e380700 	cdpeq	7, 3, cr0, cr8, cr0, {0}
    3228:	0000004d 	andeq	r0, r0, sp, asr #32
    322c:	123d0778 	eorsne	r0, sp, #120, 14	; 0x1e00000
    3230:	39070000 	stmdbcc	r7, {}	; <UNPREDICTABLE>
    3234:	00004d0e 	andeq	r4, r0, lr, lsl #26
    3238:	0d007c00 	stceq	12, cr7, [r0, #-0]
    323c:	00000502 	andeq	r0, r0, r2, lsl #10
    3240:	0000069a 	muleq	r0, sl, r6
    3244:	00005e0e 	andeq	r5, r0, lr, lsl #28
    3248:	0f000f00 	svceq	0x00000f00
    324c:	00004d04 	andeq	r4, r0, r4, lsl #26
    3250:	11521500 	cmpne	r2, r0, lsl #10
    3254:	0a080000 	beq	20325c <__bss_end+0x1f7924>
    3258:	00005914 	andeq	r5, r0, r4, lsl r9
    325c:	5c030500 	cfstr32pl	mvfx0, [r3], {-0}
    3260:	130000b4 	movwne	r0, #180	; 0xb4
    3264:	00000aef 	andeq	r0, r0, pc, ror #21
    3268:	00380405 	eorseq	r0, r8, r5, lsl #8
    326c:	0d080000 	stceq	0, cr0, [r8, #-0]
    3270:	0006d10c 	andeq	sp, r6, ip, lsl #2
    3274:	06751400 	ldrbteq	r1, [r5], -r0, lsl #8
    3278:	14000000 	strne	r0, [r0], #-0
    327c:	000003d5 	ldrdeq	r0, [r0], -r5
    3280:	38120001 	ldmdacc	r2, {r0}
    3284:	0c000010 	stceq	0, cr0, [r0], {16}
    3288:	06081b08 	streq	r1, [r8], -r8, lsl #22
    328c:	07000007 	streq	r0, [r0, -r7]
    3290:	0000041a 	andeq	r0, r0, sl, lsl r4
    3294:	06191d08 	ldreq	r1, [r9], -r8, lsl #26
    3298:	00000007 	andeq	r0, r0, r7
    329c:	0005f207 	andeq	pc, r5, r7, lsl #4
    32a0:	191e0800 	ldmdbne	lr, {fp}
    32a4:	00000706 	andeq	r0, r0, r6, lsl #14
    32a8:	0f9e0704 	svceq	0x009e0704
    32ac:	1f080000 	svcne	0x00080000
    32b0:	00070c13 	andeq	r0, r7, r3, lsl ip
    32b4:	0f000800 	svceq	0x00000800
    32b8:	0006d104 	andeq	sp, r6, r4, lsl #2
    32bc:	c7040f00 	strgt	r0, [r4, -r0, lsl #30]
    32c0:	06000005 	streq	r0, [r0], -r5
    32c4:	00000776 	andeq	r0, r0, r6, ror r7
    32c8:	07220814 			; <UNDEFINED> instruction: 0x07220814
    32cc:	000009c8 	andeq	r0, r0, r8, asr #19
    32d0:	000add07 	andeq	sp, sl, r7, lsl #26
    32d4:	12260800 	eorne	r0, r6, #0, 16
    32d8:	0000004d 	andeq	r0, r0, sp, asr #32
    32dc:	05430700 	strbeq	r0, [r3, #-1792]	; 0xfffff900
    32e0:	29080000 	stmdbcs	r8, {}	; <UNPREDICTABLE>
    32e4:	0007061d 	andeq	r0, r7, sp, lsl r6
    32e8:	9e070400 	cfcpysls	mvf0, mvf7
    32ec:	0800000e 	stmdaeq	r0, {r1, r2, r3}
    32f0:	07061d2c 	streq	r1, [r6, -ip, lsr #26]
    32f4:	1c080000 	stcne	0, cr0, [r8], {-0}
    32f8:	000010c6 	andeq	r1, r0, r6, asr #1
    32fc:	150e2f08 	strne	r2, [lr, #-3848]	; 0xfffff0f8
    3300:	5a000010 	bpl	3348 <shift+0x3348>
    3304:	65000007 	strvs	r0, [r0, #-7]
    3308:	09000007 	stmdbeq	r0, {r0, r1, r2}
    330c:	000009cd 	andeq	r0, r0, sp, asr #19
    3310:	0007060a 	andeq	r0, r7, sl, lsl #12
    3314:	c21d0000 	andsgt	r0, sp, #0
    3318:	0800000f 	stmdaeq	r0, {r0, r1, r2, r3}
    331c:	041f0e31 	ldreq	r0, [pc], #-3633	; 3324 <shift+0x3324>
    3320:	01fa0000 	mvnseq	r0, r0
    3324:	077d0000 	ldrbeq	r0, [sp, -r0]!
    3328:	07880000 	streq	r0, [r8, r0]
    332c:	cd090000 	stcgt	0, cr0, [r9, #-0]
    3330:	0a000009 	beq	335c <shift+0x335c>
    3334:	0000070c 	andeq	r0, r0, ip, lsl #14
    3338:	10600800 	rsbne	r0, r0, r0, lsl #16
    333c:	35080000 	strcc	r0, [r8, #-0]
    3340:	000f791d 	andeq	r7, pc, sp, lsl r9	; <UNPREDICTABLE>
    3344:	00070600 	andeq	r0, r7, r0, lsl #12
    3348:	07a10200 	streq	r0, [r1, r0, lsl #4]!
    334c:	07a70000 	streq	r0, [r7, r0]!
    3350:	cd090000 	stcgt	0, cr0, [r9, #-0]
    3354:	00000009 	andeq	r0, r0, r9
    3358:	000a4f08 	andeq	r4, sl, r8, lsl #30
    335c:	1d370800 	ldcne	8, cr0, [r7, #-0]
    3360:	00000d8a 	andeq	r0, r0, sl, lsl #27
    3364:	00000706 	andeq	r0, r0, r6, lsl #14
    3368:	0007c002 	andeq	ip, r7, r2
    336c:	0007c600 	andeq	ip, r7, r0, lsl #12
    3370:	09cd0900 	stmibeq	sp, {r8, fp}^
    3374:	1e000000 	cdpne	0, 0, cr0, cr0, cr0, {0}
    3378:	00000b9e 	muleq	r0, lr, fp
    337c:	e6313908 	ldrt	r3, [r1], -r8, lsl #18
    3380:	0c000009 	stceq	0, cr0, [r0], {9}
    3384:	07760802 	ldrbeq	r0, [r6, -r2, lsl #16]!
    3388:	3c080000 	stccc	0, cr0, [r8], {-0}
    338c:	00125909 	andseq	r5, r2, r9, lsl #18
    3390:	0009cd00 	andeq	ip, r9, r0, lsl #26
    3394:	07ed0100 	strbeq	r0, [sp, r0, lsl #2]!
    3398:	07f30000 	ldrbeq	r0, [r3, r0]!
    339c:	cd090000 	stcgt	0, cr0, [r9, #-0]
    33a0:	00000009 	andeq	r0, r0, r9
    33a4:	00069208 	andeq	r9, r6, r8, lsl #4
    33a8:	123f0800 	eorsne	r0, pc, #0, 16
    33ac:	0000109b 	muleq	r0, fp, r0
    33b0:	0000004d 	andeq	r0, r0, sp, asr #32
    33b4:	00080c01 	andeq	r0, r8, r1, lsl #24
    33b8:	00082100 	andeq	r2, r8, r0, lsl #2
    33bc:	09cd0900 	stmibeq	sp, {r8, fp}^
    33c0:	ef0a0000 	svc	0x000a0000
    33c4:	0a000009 	beq	33f0 <shift+0x33f0>
    33c8:	0000005e 	andeq	r0, r0, lr, asr r0
    33cc:	0001fa0a 	andeq	pc, r1, sl, lsl #20
    33d0:	d10b0000 	mrsle	r0, (UNDEF: 11)
    33d4:	0800000f 	stmdaeq	r0, {r0, r1, r2, r3}
    33d8:	0cd80e42 	ldcleq	14, cr0, [r8], {66}	; 0x42
    33dc:	36010000 	strcc	r0, [r1], -r0
    33e0:	3c000008 	stccc	0, cr0, [r0], {8}
    33e4:	09000008 	stmdbeq	r0, {r3}
    33e8:	000009cd 	andeq	r0, r0, sp, asr #19
    33ec:	099e0800 	ldmibeq	lr, {fp}
    33f0:	45080000 	strmi	r0, [r8, #-0]
    33f4:	00056b17 	andeq	r6, r5, r7, lsl fp
    33f8:	00070c00 	andeq	r0, r7, r0, lsl #24
    33fc:	08550100 	ldmdaeq	r5, {r8}^
    3400:	085b0000 	ldmdaeq	fp, {}^	; <UNPREDICTABLE>
    3404:	f5090000 			; <UNDEFINED> instruction: 0xf5090000
    3408:	00000009 	andeq	r0, r0, r9
    340c:	0005fc08 	andeq	pc, r5, r8, lsl #24
    3410:	17480800 	strbne	r0, [r8, -r0, lsl #16]
    3414:	00000f2d 	andeq	r0, r0, sp, lsr #30
    3418:	0000070c 	andeq	r0, r0, ip, lsl #14
    341c:	00087401 	andeq	r7, r8, r1, lsl #8
    3420:	00087f00 	andeq	r7, r8, r0, lsl #30
    3424:	09f50900 	ldmibeq	r5!, {r8, fp}^
    3428:	4d0a0000 	stcmi	0, cr0, [sl, #-0]
    342c:	00000000 	andeq	r0, r0, r0
    3430:	00116f0b 	andseq	r6, r1, fp, lsl #30
    3434:	0e4b0800 	cdpeq	8, 4, cr0, cr11, cr0, {0}
    3438:	00000fe6 	andeq	r0, r0, r6, ror #31
    343c:	00089401 	andeq	r9, r8, r1, lsl #8
    3440:	00089a00 	andeq	r9, r8, r0, lsl #20
    3444:	09cd0900 	stmibeq	sp, {r8, fp}^
    3448:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    344c:	00000fc2 	andeq	r0, r0, r2, asr #31
    3450:	8d0e4d08 	stchi	13, cr4, [lr, #-32]	; 0xffffffe0
    3454:	fa000008 	blx	347c <shift+0x347c>
    3458:	01000001 	tsteq	r0, r1
    345c:	000008b3 			; <UNDEFINED> instruction: 0x000008b3
    3460:	000008be 			; <UNDEFINED> instruction: 0x000008be
    3464:	0009cd09 	andeq	ip, r9, r9, lsl #26
    3468:	004d0a00 	subeq	r0, sp, r0, lsl #20
    346c:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    3470:	000009d2 	ldrdeq	r0, [r0], -r2
    3474:	f9125008 			; <UNDEFINED> instruction: 0xf9125008
    3478:	4d00000c 	stcmi	0, cr0, [r0, #-48]	; 0xffffffd0
    347c:	01000000 	mrseq	r0, (UNDEF: 0)
    3480:	000008d7 	ldrdeq	r0, [r0], -r7
    3484:	000008e2 	andeq	r0, r0, r2, ror #17
    3488:	0009cd09 	andeq	ip, r9, r9, lsl #26
    348c:	05020a00 	streq	r0, [r2, #-2560]	; 0xfffff600
    3490:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    3494:	000004b8 			; <UNDEFINED> instruction: 0x000004b8
    3498:	350e5308 	strcc	r5, [lr, #-776]	; 0xfffffcf8
    349c:	fa000009 	blx	34c8 <shift+0x34c8>
    34a0:	01000001 	tsteq	r0, r1
    34a4:	000008fb 	strdeq	r0, [r0], -fp
    34a8:	00000906 	andeq	r0, r0, r6, lsl #18
    34ac:	0009cd09 	andeq	ip, r9, r9, lsl #26
    34b0:	004d0a00 	subeq	r0, sp, r0, lsl #20
    34b4:	0b000000 	bleq	34bc <shift+0x34bc>
    34b8:	00000a29 	andeq	r0, r0, r9, lsr #20
    34bc:	d40e5608 	strle	r5, [lr], #-1544	; 0xfffff9f8
    34c0:	01000004 	tsteq	r0, r4
    34c4:	0000091b 	andeq	r0, r0, fp, lsl r9
    34c8:	0000093a 	andeq	r0, r0, sl, lsr r9
    34cc:	0009cd09 	andeq	ip, r9, r9, lsl #26
    34d0:	02270a00 	eoreq	r0, r7, #0, 20
    34d4:	4d0a0000 	stcmi	0, cr0, [sl, #-0]
    34d8:	0a000000 	beq	34e0 <shift+0x34e0>
    34dc:	0000004d 	andeq	r0, r0, sp, asr #32
    34e0:	00004d0a 	andeq	r4, r0, sl, lsl #26
    34e4:	09fb0a00 	ldmibeq	fp!, {r9, fp}^
    34e8:	0b000000 	bleq	34f0 <shift+0x34f0>
    34ec:	00000f63 	andeq	r0, r0, r3, ror #30
    34f0:	ea0e5808 	b	399518 <__bss_end+0x38dbe0>
    34f4:	01000007 	tsteq	r0, r7
    34f8:	0000094f 	andeq	r0, r0, pc, asr #18
    34fc:	0000096e 	andeq	r0, r0, lr, ror #18
    3500:	0009cd09 	andeq	ip, r9, r9, lsl #26
    3504:	025e0a00 	subseq	r0, lr, #0, 20
    3508:	4d0a0000 	stcmi	0, cr0, [sl, #-0]
    350c:	0a000000 	beq	3514 <shift+0x3514>
    3510:	0000004d 	andeq	r0, r0, sp, asr #32
    3514:	00004d0a 	andeq	r4, r0, sl, lsl #26
    3518:	09fb0a00 	ldmibeq	fp!, {r9, fp}^
    351c:	0b000000 	bleq	3524 <shift+0x3524>
    3520:	00000d5f 	andeq	r0, r0, pc, asr sp
    3524:	fa0e5b08 	blx	39a14c <__bss_end+0x38e814>
    3528:	01000010 	tsteq	r0, r0, lsl r0
    352c:	00000983 	andeq	r0, r0, r3, lsl #19
    3530:	000009a2 	andeq	r0, r0, r2, lsr #19
    3534:	0009cd09 	andeq	ip, r9, r9, lsl #26
    3538:	029b0a00 	addseq	r0, fp, #0, 20
    353c:	4d0a0000 	stcmi	0, cr0, [sl, #-0]
    3540:	0a000000 	beq	3548 <shift+0x3548>
    3544:	0000004d 	andeq	r0, r0, sp, asr #32
    3548:	00004d0a 	andeq	r4, r0, sl, lsl #26
    354c:	09fb0a00 	ldmibeq	fp!, {r9, fp}^
    3550:	11000000 	mrsne	r0, (UNDEF: 0)
    3554:	00000750 	andeq	r0, r0, r0, asr r7
    3558:	a70e5e08 	strge	r5, [lr, -r8, lsl #28]
    355c:	fa000007 	blx	3580 <shift+0x3580>
    3560:	01000001 	tsteq	r0, r1
    3564:	000009b7 			; <UNDEFINED> instruction: 0x000009b7
    3568:	0009cd09 	andeq	ip, r9, r9, lsl #26
    356c:	06b20a00 	ldrteq	r0, [r2], r0, lsl #20
    3570:	010a0000 	mrseq	r0, (UNDEF: 10)
    3574:	0000000a 	andeq	r0, r0, sl
    3578:	07120300 	ldreq	r0, [r2, -r0, lsl #6]
    357c:	040f0000 	streq	r0, [pc], #-0	; 3584 <shift+0x3584>
    3580:	00000712 	andeq	r0, r0, r2, lsl r7
    3584:	0007061f 	andeq	r0, r7, pc, lsl r6
    3588:	0009e000 	andeq	lr, r9, r0
    358c:	0009e600 	andeq	lr, r9, r0, lsl #12
    3590:	09cd0900 	stmibeq	sp, {r8, fp}^
    3594:	20000000 	andcs	r0, r0, r0
    3598:	00000712 	andeq	r0, r0, r2, lsl r7
    359c:	000009d3 	ldrdeq	r0, [r0], -r3
    35a0:	003f040f 	eorseq	r0, pc, pc, lsl #8
    35a4:	040f0000 	streq	r0, [pc], #-0	; 35ac <shift+0x35ac>
    35a8:	000009c8 	andeq	r0, r0, r8, asr #19
    35ac:	02010421 	andeq	r0, r1, #553648128	; 0x21000000
    35b0:	04220000 	strteq	r0, [r2], #-0
    35b4:	000bbc1a 	andeq	fp, fp, sl, lsl ip
    35b8:	19610800 	stmdbne	r1!, {fp}^
    35bc:	00000712 	andeq	r0, r0, r2, lsl r7
    35c0:	0001c423 	andeq	ip, r1, r3, lsr #8
    35c4:	0a090100 	beq	2439cc <__bss_end+0x238094>
    35c8:	00000a29 	andeq	r0, r0, r9, lsr #20
    35cc:	0000ab6c 	andeq	sl, r0, ip, ror #22
    35d0:	00000140 	andeq	r0, r0, r0, asr #2
    35d4:	0ab69c01 	beq	fedaa5e0 <__bss_end+0xfed9eca8>
    35d8:	29240000 	stmdbcs	r4!, {}	; <UNPREDICTABLE>
    35dc:	f5000018 			; <UNDEFINED> instruction: 0xf5000018
    35e0:	03000001 	movweq	r0, #1
    35e4:	257ee491 	ldrbcs	lr, [lr, #-1169]!	; 0xfffffb6f
    35e8:	0000181c 	andeq	r1, r0, ip, lsl r8
    35ec:	86260901 	strthi	r0, [r6], -r1, lsl #18
    35f0:	03000001 	movweq	r0, #1
    35f4:	257ee091 	ldrbcs	lr, [lr, #-145]!	; 0xffffff6f
    35f8:	000014ad 	andeq	r1, r0, sp, lsr #9
    35fc:	4d3d0901 			; <UNDEFINED> instruction: 0x4d3d0901
    3600:	03000000 	movweq	r0, #0
    3604:	257edc91 	ldrbcs	sp, [lr, #-3217]!	; 0xfffff36f
    3608:	00001888 	andeq	r1, r0, r8, lsl #17
    360c:	fa480901 	blx	1205a18 <__bss_end+0x11fa0e0>
    3610:	03000001 	movweq	r0, #1
    3614:	267edb91 			; <UNDEFINED> instruction: 0x267edb91
    3618:	0000187d 	andeq	r1, r0, sp, ror r8
    361c:	700a0a01 	andvc	r0, sl, r1, lsl #20
    3620:	03000001 	movweq	r0, #1
    3624:	267eec91 			; <UNDEFINED> instruction: 0x267eec91
    3628:	00001891 	muleq	r0, r1, r8
    362c:	4d0b0c01 	stcmi	12, cr0, [fp, #-4]
    3630:	02000000 	andeq	r0, r0, #0
    3634:	a0277491 	mlage	r7, r1, r4, r7
    3638:	e00000ab 	and	r0, r0, fp, lsr #1
    363c:	28000000 	stmdacs	r0, {}	; <UNPREDICTABLE>
    3640:	006e656c 	rsbeq	r6, lr, ip, ror #10
    3644:	4d0c1601 	stcmi	6, cr1, [ip, #-4]
    3648:	02000000 	andeq	r0, r0, #0
    364c:	0c276c91 	stceq	12, cr6, [r7], #-580	; 0xfffffdbc
    3650:	740000ac 	strvc	r0, [r0], #-172	; 0xffffff54
    3654:	28000000 	stmdacs	r0, {}	; <UNPREDICTABLE>
    3658:	22010069 	andcs	r0, r1, #105	; 0x69
    365c:	0000380d 	andeq	r3, r0, sp, lsl #16
    3660:	70910200 	addsvc	r0, r1, r0, lsl #4
    3664:	29000000 	stmdbcs	r0, {}	; <UNPREDICTABLE>
    3668:	000001a5 	andeq	r0, r0, r5, lsr #3
    366c:	c7010501 	strgt	r0, [r1, -r1, lsl #10]
    3670:	0000000a 	andeq	r0, r0, sl
    3674:	00000ad1 	ldrdeq	r0, [r0], -r1
    3678:	0018292a 	andseq	r2, r8, sl, lsr #18
    367c:	0001f500 	andeq	pc, r1, r0, lsl #10
    3680:	b62b0000 	strtlt	r0, [fp], -r0
    3684:	6900000a 	stmdbvs	r0, {r1, r3}
    3688:	e8000018 	stmda	r0, {r3, r4}
    368c:	4000000a 	andmi	r0, r0, sl
    3690:	2c0000ab 	stccs	0, cr0, [r0], {171}	; 0xab
    3694:	01000000 	mrseq	r0, (UNDEF: 0)
    3698:	0ac72c9c 	beq	ff1ce910 <__bss_end+0xff1c2fd8>
    369c:	91020000 	mrsls	r0, (UNDEF: 2)
    36a0:	55000074 	strpl	r0, [r0, #-116]	; 0xffffff8c
    36a4:	04000003 	streq	r0, [r0], #-3
    36a8:	000d0f00 	andeq	r0, sp, r0, lsl #30
    36ac:	8d010400 	cfstrshi	mvf0, [r1, #-0]
    36b0:	04000015 	streq	r0, [r0], #-21	; 0xffffffeb
    36b4:	000018bb 			; <UNDEFINED> instruction: 0x000018bb
    36b8:	000013c2 	andeq	r1, r0, r2, asr #7
    36bc:	0000acac 	andeq	sl, r0, ip, lsr #25
    36c0:	000002ec 	andeq	r0, r0, ip, ror #5
    36c4:	00001538 	andeq	r1, r0, r8, lsr r5
    36c8:	7a080102 	bvc	203ad8 <__bss_end+0x1f81a0>
    36cc:	0200000d 	andeq	r0, r0, #13
    36d0:	0dbc0502 	cfldr32eq	mvfx0, [ip, #8]!
    36d4:	04030000 	streq	r0, [r3], #-0
    36d8:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    36dc:	08010200 	stmdaeq	r1, {r9}
    36e0:	00000d71 	andeq	r0, r0, r1, ror sp
    36e4:	3c070202 	sfmcc	f0, 4, [r7], {2}
    36e8:	0400000a 	streq	r0, [r0], #-10
    36ec:	00000e82 	andeq	r0, r0, r2, lsl #29
    36f0:	54070903 	strpl	r0, [r7], #-2307	; 0xfffff6fd
    36f4:	02000000 	andeq	r0, r0, #0
    36f8:	1e340704 	cdpne	7, 3, cr0, cr4, cr4, {0}
    36fc:	ac050000 	stcge	0, cr0, [r5], {-0}
    3700:	8800000b 	stmdahi	r0, {r0, r1, r3}
    3704:	66070702 	strvs	r0, [r7], -r2, lsl #14
    3708:	06000001 	streq	r0, [r0], -r1
    370c:	00000f1a 	andeq	r0, r0, sl, lsl pc
    3710:	660e0b02 	strvs	r0, [lr], -r2, lsl #22
    3714:	00000001 	andeq	r0, r0, r1
    3718:	000bde06 	andeq	sp, fp, r6, lsl #28
    371c:	120e0200 	andne	r0, lr, #0, 4
    3720:	00000048 	andeq	r0, r0, r8, asr #32
    3724:	0fda0680 	svceq	0x00da0680
    3728:	0f020000 	svceq	0x00020000
    372c:	00004812 	andeq	r4, r0, r2, lsl r8
    3730:	ac078400 	cfstrsge	mvf8, [r7], {-0}
    3734:	0200000b 	andeq	r0, r0, #11
    3738:	0bfb0913 	bleq	ffec5b8c <__bss_end+0xffeba254>
    373c:	01760000 	cmneq	r6, r0
    3740:	a8010000 	stmdage	r1, {}	; <UNPREDICTABLE>
    3744:	ae000000 	cdpge	0, 0, cr0, cr0, cr0, {0}
    3748:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    374c:	00000176 	andeq	r0, r0, r6, ror r1
    3750:	118d0700 	orrne	r0, sp, r0, lsl #14
    3754:	16020000 	strne	r0, [r2], -r0
    3758:	00071512 	andeq	r1, r7, r2, lsl r5
    375c:	00004800 	andeq	r4, r0, r0, lsl #16
    3760:	00c70100 	sbceq	r0, r7, r0, lsl #2
    3764:	00d20000 	sbcseq	r0, r2, r0
    3768:	76080000 	strvc	r0, [r8], -r0
    376c:	09000001 	stmdbeq	r0, {r0}
    3770:	00000181 	andeq	r0, r0, r1, lsl #3
    3774:	118d0700 	orrne	r0, sp, r0, lsl #14
    3778:	19020000 	stmdbne	r2, {}	; <UNPREDICTABLE>
    377c:	0005c812 	andeq	ip, r5, r2, lsl r8
    3780:	00004800 	andeq	r4, r0, r0, lsl #16
    3784:	00eb0100 	rsceq	r0, fp, r0, lsl #2
    3788:	00fb0000 	rscseq	r0, fp, r0
    378c:	76080000 	strvc	r0, [r8], -r0
    3790:	09000001 	stmdbeq	r0, {r0}
    3794:	00000181 	andeq	r0, r0, r1, lsl #3
    3798:	00004809 	andeq	r4, r0, r9, lsl #16
    379c:	28070000 	stmdacs	r7, {}	; <UNPREDICTABLE>
    37a0:	02000012 	andeq	r0, r0, #18
    37a4:	0397121c 	orrseq	r1, r7, #28, 4	; 0xc0000001
    37a8:	00480000 	subeq	r0, r8, r0
    37ac:	14010000 	strne	r0, [r1], #-0
    37b0:	24000001 	strcs	r0, [r0], #-1
    37b4:	08000001 	stmdaeq	r0, {r0}
    37b8:	00000176 	andeq	r0, r0, r6, ror r1
    37bc:	00002509 	andeq	r2, r0, r9, lsl #10
    37c0:	01810900 	orreq	r0, r1, r0, lsl #18
    37c4:	0a000000 	beq	37cc <shift+0x37cc>
    37c8:	00000b5d 	andeq	r0, r0, sp, asr fp
    37cc:	0e0e1f02 	cdpeq	15, 0, cr1, cr14, cr2, {0}
    37d0:	0100000e 	tsteq	r0, lr
    37d4:	00000139 	andeq	r0, r0, r9, lsr r1
    37d8:	00000149 	andeq	r0, r0, r9, asr #2
    37dc:	00017608 	andeq	r7, r1, r8, lsl #12
    37e0:	01810900 	orreq	r0, r1, r0, lsl #18
    37e4:	48090000 	stmdami	r9, {}	; <UNPREDICTABLE>
    37e8:	00000000 	andeq	r0, r0, r0
    37ec:	000b5d0b 	andeq	r5, fp, fp, lsl #26
    37f0:	0e220200 	cdpeq	2, 2, cr0, cr2, cr0, {0}
    37f4:	00000dc6 	andeq	r0, r0, r6, asr #27
    37f8:	00015a01 	andeq	r5, r1, r1, lsl #20
    37fc:	01760800 	cmneq	r6, r0, lsl #16
    3800:	25090000 	strcs	r0, [r9, #-0]
    3804:	00000000 	andeq	r0, r0, r0
    3808:	00250c00 	eoreq	r0, r5, r0, lsl #24
    380c:	01760000 	cmneq	r6, r0
    3810:	540d0000 	strpl	r0, [sp], #-0
    3814:	7f000000 	svcvc	0x00000000
    3818:	5b040e00 	blpl	107020 <__bss_end+0xfb6e8>
    381c:	0f000000 	svceq	0x00000000
    3820:	00000176 	andeq	r0, r0, r6, ror r1
    3824:	0025040e 	eoreq	r0, r5, lr, lsl #8
    3828:	fb100000 	blx	403832 <__bss_end+0x3f7efa>
    382c:	01000000 	mrseq	r0, (UNDEF: 0)
    3830:	01a10a31 			; <UNDEFINED> instruction: 0x01a10a31
    3834:	aec80000 	cdpge	0, 12, cr0, cr8, cr0, {0}
    3838:	00d00000 	sbcseq	r0, r0, r0
    383c:	9c010000 	stcls	0, cr0, [r1], {-0}
    3840:	000001db 	ldrdeq	r0, [r0], -fp
    3844:	00182911 	andseq	r2, r8, r1, lsl r9
    3848:	00017c00 	andeq	r7, r1, r0, lsl #24
    384c:	6c910200 	lfmvs	f0, 4, [r1], {0}
    3850:	000e4d12 	andeq	r4, lr, r2, lsl sp
    3854:	2a310100 	bcs	c43c5c <__bss_end+0xc38324>
    3858:	00000025 	andeq	r0, r0, r5, lsr #32
    385c:	136b9102 	cmnne	fp, #-2147483648	; 0x80000000
    3860:	00746572 	rsbseq	r6, r4, r2, ror r5
    3864:	81363101 	teqhi	r6, r1, lsl #2
    3868:	02000001 	andeq	r0, r0, #1
    386c:	fb146491 	blx	51caba <__bss_end+0x511182>
    3870:	01000018 	tsteq	r0, r8, lsl r0
    3874:	00330932 	eorseq	r0, r3, r2, lsr r9
    3878:	91020000 	mrsls	r0, (UNDEF: 2)
    387c:	49150074 	ldmdbmi	r5, {r2, r4, r5, r6}
    3880:	01000001 	tsteq	r0, r1
    3884:	01f5062a 	mvnseq	r0, sl, lsr #12
    3888:	ae740000 	cdpge	0, 7, cr0, cr4, cr0, {0}
    388c:	00540000 	subseq	r0, r4, r0
    3890:	9c010000 	stcls	0, cr0, [r1], {-0}
    3894:	00000211 	andeq	r0, r0, r1, lsl r2
    3898:	00182911 	andseq	r2, r8, r1, lsl r9
    389c:	00017c00 	andeq	r7, r1, r0, lsl #24
    38a0:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    38a4:	000b0912 	andeq	r0, fp, r2, lsl r9
    38a8:	222a0100 	eorcs	r0, sl, #0, 2
    38ac:	00000025 	andeq	r0, r0, r5, lsr #32
    38b0:	00739102 	rsbseq	r9, r3, r2, lsl #2
    38b4:	00012410 	andeq	r2, r1, r0, lsl r4
    38b8:	06230100 	strteq	r0, [r3], -r0, lsl #2
    38bc:	0000022b 	andeq	r0, r0, fp, lsr #4
    38c0:	0000ae0c 	andeq	sl, r0, ip, lsl #28
    38c4:	00000068 	andeq	r0, r0, r8, rrx
    38c8:	026d9c01 	rsbeq	r9, sp, #256	; 0x100
    38cc:	29110000 	ldmdbcs	r1, {}	; <UNPREDICTABLE>
    38d0:	7c000018 	stcvc	0, cr0, [r0], {24}
    38d4:	02000001 	andeq	r0, r0, #1
    38d8:	09126c91 	ldmdbeq	r2, {r0, r4, r7, sl, fp, sp, lr}
    38dc:	0100000b 	tsteq	r0, fp
    38e0:	01812323 	orreq	r2, r1, r3, lsr #6
    38e4:	91020000 	mrsls	r0, (UNDEF: 2)
    38e8:	656c1368 	strbvs	r1, [ip, #-872]!	; 0xfffffc98
    38ec:	2301006e 	movwcs	r0, #4206	; 0x106e
    38f0:	00004833 	andeq	r4, r0, r3, lsr r8
    38f4:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    38f8:	00ae2416 	adceq	r2, lr, r6, lsl r4
    38fc:	00004400 	andeq	r4, r0, r0, lsl #8
    3900:	00691700 	rsbeq	r1, r9, r0, lsl #14
    3904:	330e2401 	movwcc	r2, #58369	; 0xe401
    3908:	02000000 	andeq	r0, r0, #0
    390c:	00007491 	muleq	r0, r1, r4
    3910:	0000d215 	andeq	sp, r0, r5, lsl r2
    3914:	0a100100 	beq	403d1c <__bss_end+0x3f83e4>
    3918:	00000287 	andeq	r0, r0, r7, lsl #5
    391c:	0000ad3c 	andeq	sl, r0, ip, lsr sp
    3920:	000000d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    3924:	02e79c01 	rsceq	r9, r7, #256	; 0x100
    3928:	29110000 	ldmdbcs	r1, {}	; <UNPREDICTABLE>
    392c:	7c000018 	stcvc	0, cr0, [r0], {24}
    3930:	02000001 	andeq	r0, r0, #1
    3934:	72136491 	andsvc	r6, r3, #-1862270976	; 0x91000000
    3938:	01007465 	tsteq	r0, r5, ror #8
    393c:	01812710 	orreq	r2, r1, r0, lsl r7
    3940:	91020000 	mrsls	r0, (UNDEF: 2)
    3944:	656c1360 	strbvs	r1, [ip, #-864]!	; 0xfffffca0
    3948:	1001006e 	andne	r0, r1, lr, rrx
    394c:	00004835 	andeq	r4, r0, r5, lsr r8
    3950:	5c910200 	lfmpl	f0, 4, [r1], {0}
    3954:	00189114 	andseq	r9, r8, r4, lsl r1
    3958:	09110100 	ldmdbeq	r1, {r8}
    395c:	00000033 	andeq	r0, r0, r3, lsr r0
    3960:	14749102 	ldrbtne	r9, [r4], #-258	; 0xfffffefe
    3964:	000018b4 			; <UNDEFINED> instruction: 0x000018b4
    3968:	480e1201 	stmdami	lr, {r0, r9, ip}
    396c:	02000000 	andeq	r0, r0, #0
    3970:	8c166c91 	ldchi	12, cr6, [r6], {145}	; 0x91
    3974:	6c0000ad 	stcvs	0, cr0, [r0], {173}	; 0xad
    3978:	17000000 	strne	r0, [r0, -r0]
    397c:	18010069 	stmdane	r1, {r0, r3, r5, r6}
    3980:	0000330e 	andeq	r3, r0, lr, lsl #6
    3984:	70910200 	addsvc	r0, r1, r0, lsl #4
    3988:	ae100000 	cdpge	0, 1, cr0, cr0, cr0, {0}
    398c:	01000000 	mrseq	r0, (UNDEF: 0)
    3990:	03010a0b 	movweq	r0, #6667	; 0x1a0b
    3994:	acf40000 	ldclge	0, cr0, [r4]
    3998:	00480000 	subeq	r0, r8, r0
    399c:	9c010000 	stcls	0, cr0, [r1], {-0}
    39a0:	0000031d 	andeq	r0, r0, sp, lsl r3
    39a4:	00182911 	andseq	r2, r8, r1, lsl r9
    39a8:	00017c00 	andeq	r7, r1, r0, lsl #24
    39ac:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    39b0:	74657213 	strbtvc	r7, [r5], #-531	; 0xfffffded
    39b4:	270b0100 	strcs	r0, [fp, -r0, lsl #2]
    39b8:	00000181 	andeq	r0, r0, r1, lsl #3
    39bc:	00709102 	rsbseq	r9, r0, r2, lsl #2
    39c0:	00008f18 	andeq	r8, r0, r8, lsl pc
    39c4:	01040100 	mrseq	r0, (UNDEF: 20)
    39c8:	0000032e 	andeq	r0, r0, lr, lsr #6
    39cc:	00033800 	andeq	r3, r3, r0, lsl #16
    39d0:	18291900 	stmdane	r9!, {r8, fp, ip}
    39d4:	017c0000 	cmneq	ip, r0
    39d8:	1a000000 	bne	39e0 <shift+0x39e0>
    39dc:	0000031d 	andeq	r0, r0, sp, lsl r3
    39e0:	0000189b 	muleq	r0, fp, r8
    39e4:	0000034f 	andeq	r0, r0, pc, asr #6
    39e8:	0000acac 	andeq	sl, r0, ip, lsr #25
    39ec:	00000048 	andeq	r0, r0, r8, asr #32
    39f0:	2e1b9c01 	cdpcs	12, 1, cr9, cr11, cr1, {0}
    39f4:	02000003 	andeq	r0, r0, #3
    39f8:	00007491 	muleq	r0, r1, r4
    39fc:	00000022 	andeq	r0, r0, r2, lsr #32
    3a00:	0eb00002 	cdpeq	0, 11, cr0, cr0, cr2, {0}
    3a04:	01040000 	mrseq	r0, (UNDEF: 4)
    3a08:	00001761 	andeq	r1, r0, r1, ror #14
    3a0c:	0000af98 	muleq	r0, r8, pc	; <UNPREDICTABLE>
    3a10:	0000b1a4 	andeq	fp, r0, r4, lsr #3
    3a14:	00001909 	andeq	r1, r0, r9, lsl #18
    3a18:	00001939 	andeq	r1, r0, r9, lsr r9
    3a1c:	00000061 	andeq	r0, r0, r1, rrx
    3a20:	00228001 	eoreq	r8, r2, r1
    3a24:	00020000 	andeq	r0, r2, r0
    3a28:	00000ec4 	andeq	r0, r0, r4, asr #29
    3a2c:	17de0104 	ldrbne	r0, [lr, r4, lsl #2]
    3a30:	b1a40000 			; <UNDEFINED> instruction: 0xb1a40000
    3a34:	b1a80000 			; <UNDEFINED> instruction: 0xb1a80000
    3a38:	19090000 	stmdbne	r9, {}	; <UNPREDICTABLE>
    3a3c:	19390000 	ldmdbne	r9!, {}	; <UNPREDICTABLE>
    3a40:	00610000 	rsbeq	r0, r1, r0
    3a44:	80010000 	andhi	r0, r1, r0
    3a48:	00000932 	andeq	r0, r0, r2, lsr r9
    3a4c:	0ed80004 	cdpeq	0, 13, cr0, cr8, cr4, {0}
    3a50:	01040000 	mrseq	r0, (UNDEF: 4)
    3a54:	00001d07 	andeq	r1, r0, r7, lsl #26
    3a58:	001c5e0c 	andseq	r5, ip, ip, lsl #28
    3a5c:	00193900 	andseq	r3, r9, r0, lsl #18
    3a60:	00183e00 	andseq	r3, r8, r0, lsl #28
    3a64:	05040200 	streq	r0, [r4, #-512]	; 0xfffffe00
    3a68:	00746e69 	rsbseq	r6, r4, r9, ror #28
    3a6c:	34070403 	strcc	r0, [r7], #-1027	; 0xfffffbfd
    3a70:	0300001e 	movweq	r0, #30
    3a74:	03510508 	cmpeq	r1, #8, 10	; 0x2000000
    3a78:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    3a7c:	00250604 	eoreq	r0, r5, r4, lsl #12
    3a80:	1cb90400 	cfldrsne	mvf0, [r9]
    3a84:	2a010000 	bcs	43a8c <__bss_end+0x38154>
    3a88:	00002416 	andeq	r2, r0, r6, lsl r4
    3a8c:	21280400 			; <UNDEFINED> instruction: 0x21280400
    3a90:	2f010000 	svccs	0x00010000
    3a94:	00005115 	andeq	r5, r0, r5, lsl r1
    3a98:	57040500 	strpl	r0, [r4, -r0, lsl #10]
    3a9c:	06000000 	streq	r0, [r0], -r0
    3aa0:	00000039 	andeq	r0, r0, r9, lsr r0
    3aa4:	00000066 	andeq	r0, r0, r6, rrx
    3aa8:	00006607 	andeq	r6, r0, r7, lsl #12
    3aac:	04050000 	streq	r0, [r5], #-0
    3ab0:	0000006c 	andeq	r0, r0, ip, rrx
    3ab4:	285a0408 	ldmdacs	sl, {r3, sl}^
    3ab8:	36010000 	strcc	r0, [r1], -r0
    3abc:	0000790f 	andeq	r7, r0, pc, lsl #18
    3ac0:	7f040500 	svcvc	0x00040500
    3ac4:	06000000 	streq	r0, [r0], -r0
    3ac8:	0000001d 	andeq	r0, r0, sp, lsl r0
    3acc:	00000093 	muleq	r0, r3, r0
    3ad0:	00006607 	andeq	r6, r0, r7, lsl #12
    3ad4:	00660700 	rsbeq	r0, r6, r0, lsl #14
    3ad8:	03000000 	movweq	r0, #0
    3adc:	0d710801 	ldcleq	8, cr0, [r1, #-4]!
    3ae0:	60090000 	andvs	r0, r9, r0
    3ae4:	01000023 	tsteq	r0, r3, lsr #32
    3ae8:	004512bb 	strheq	r1, [r5], #-43	; 0xffffffd5
    3aec:	88090000 	stmdahi	r9, {}	; <UNPREDICTABLE>
    3af0:	01000028 	tsteq	r0, r8, lsr #32
    3af4:	006d10be 	strhteq	r1, [sp], #-14
    3af8:	01030000 	mrseq	r0, (UNDEF: 3)
    3afc:	000d7306 	andeq	r7, sp, r6, lsl #6
    3b00:	20480a00 	subcs	r0, r8, r0, lsl #20
    3b04:	01070000 	mrseq	r0, (UNDEF: 7)
    3b08:	00000093 	muleq	r0, r3, r0
    3b0c:	e6061702 	str	r1, [r6], -r2, lsl #14
    3b10:	0b000001 	bleq	3b1c <shift+0x3b1c>
    3b14:	00001b17 	andeq	r1, r0, r7, lsl fp
    3b18:	1f650b00 	svcne	0x00650b00
    3b1c:	0b010000 	bleq	43b24 <__bss_end+0x381ec>
    3b20:	0000242b 	andeq	r2, r0, fp, lsr #8
    3b24:	279c0b02 	ldrcs	r0, [ip, r2, lsl #22]
    3b28:	0b030000 	bleq	c3b30 <__bss_end+0xb81f8>
    3b2c:	000023cf 	andeq	r2, r0, pc, asr #7
    3b30:	26a50b04 	strtcs	r0, [r5], r4, lsl #22
    3b34:	0b050000 	bleq	143b3c <__bss_end+0x138204>
    3b38:	00002609 	andeq	r2, r0, r9, lsl #12
    3b3c:	1b380b06 	blne	e0675c <__bss_end+0xdfae24>
    3b40:	0b070000 	bleq	1c3b48 <__bss_end+0x1b8210>
    3b44:	000026ba 			; <UNDEFINED> instruction: 0x000026ba
    3b48:	26c80b08 	strbcs	r0, [r8], r8, lsl #22
    3b4c:	0b090000 	bleq	243b54 <__bss_end+0x23821c>
    3b50:	0000278f 	andeq	r2, r0, pc, lsl #15
    3b54:	23260b0a 			; <UNDEFINED> instruction: 0x23260b0a
    3b58:	0b0b0000 	bleq	2c3b60 <__bss_end+0x2b8228>
    3b5c:	00001cfa 	strdeq	r1, [r0], -sl
    3b60:	1dd70b0c 	vldrne	d16, [r7, #48]	; 0x30
    3b64:	0b0d0000 	bleq	343b6c <__bss_end+0x338234>
    3b68:	0000208c 	andeq	r2, r0, ip, lsl #1
    3b6c:	20a20b0e 	adccs	r0, r2, lr, lsl #22
    3b70:	0b0f0000 	bleq	3c3b78 <__bss_end+0x3b8240>
    3b74:	00001f9f 	muleq	r0, pc, pc	; <UNPREDICTABLE>
    3b78:	23b30b10 			; <UNDEFINED> instruction: 0x23b30b10
    3b7c:	0b110000 	bleq	443b84 <__bss_end+0x43824c>
    3b80:	0000200b 	andeq	r2, r0, fp
    3b84:	2a210b12 	bcs	8467d4 <__bss_end+0x83ae9c>
    3b88:	0b130000 	bleq	4c3b90 <__bss_end+0x4b8258>
    3b8c:	00001ba1 	andeq	r1, r0, r1, lsr #23
    3b90:	202f0b14 	eorcs	r0, pc, r4, lsl fp	; <UNPREDICTABLE>
    3b94:	0b150000 	bleq	543b9c <__bss_end+0x538264>
    3b98:	00001ade 	ldrdeq	r1, [r0], -lr
    3b9c:	27bf0b16 			; <UNDEFINED> instruction: 0x27bf0b16
    3ba0:	0b170000 	bleq	5c3ba8 <__bss_end+0x5b8270>
    3ba4:	000028e1 	andeq	r2, r0, r1, ror #17
    3ba8:	20540b18 	subscs	r0, r4, r8, lsl fp
    3bac:	0b190000 	bleq	643bb4 <__bss_end+0x63827c>
    3bb0:	0000249d 	muleq	r0, sp, r4
    3bb4:	27cd0b1a 	bfics	r0, sl, (invalid: 22:13)
    3bb8:	0b1b0000 	bleq	6c3bc0 <__bss_end+0x6b8288>
    3bbc:	00001a0d 	andeq	r1, r0, sp, lsl #20
    3bc0:	27db0b1c 	bfics	r0, ip, #22, #6
    3bc4:	0b1d0000 	bleq	743bcc <__bss_end+0x738294>
    3bc8:	000027e9 	andeq	r2, r0, r9, ror #15
    3bcc:	19bb0b1e 	ldmibne	fp!, {r1, r2, r3, r4, r8, r9, fp}
    3bd0:	0b1f0000 	bleq	7c3bd8 <__bss_end+0x7b82a0>
    3bd4:	00002813 	andeq	r2, r0, r3, lsl r8
    3bd8:	254a0b20 	strbcs	r0, [sl, #-2848]	; 0xfffff4e0
    3bdc:	0b210000 	bleq	843be4 <__bss_end+0x8382ac>
    3be0:	00002385 	andeq	r2, r0, r5, lsl #7
    3be4:	27b20b22 	ldrcs	r0, [r2, r2, lsr #22]!
    3be8:	0b230000 	bleq	8c3bf0 <__bss_end+0x8b82b8>
    3bec:	00002289 	andeq	r2, r0, r9, lsl #5
    3bf0:	218b0b24 	orrcs	r0, fp, r4, lsr #22
    3bf4:	0b250000 	bleq	943bfc <__bss_end+0x9382c4>
    3bf8:	00001ea5 	andeq	r1, r0, r5, lsr #29
    3bfc:	21a90b26 			; <UNDEFINED> instruction: 0x21a90b26
    3c00:	0b270000 	bleq	9c3c08 <__bss_end+0x9b82d0>
    3c04:	00001f41 	andeq	r1, r0, r1, asr #30
    3c08:	21b90b28 			; <UNDEFINED> instruction: 0x21b90b28
    3c0c:	0b290000 	bleq	a43c14 <__bss_end+0xa382dc>
    3c10:	000021c9 	andeq	r2, r0, r9, asr #3
    3c14:	230c0b2a 	movwcs	r0, #52010	; 0xcb2a
    3c18:	0b2b0000 	bleq	ac3c20 <__bss_end+0xab82e8>
    3c1c:	00002132 	andeq	r2, r0, r2, lsr r1
    3c20:	25570b2c 	ldrbcs	r0, [r7, #-2860]	; 0xfffff4d4
    3c24:	0b2d0000 	bleq	b43c2c <__bss_end+0xb382f4>
    3c28:	00001ee6 	andeq	r1, r0, r6, ror #29
    3c2c:	c40a002e 	strgt	r0, [sl], #-46	; 0xffffffd2
    3c30:	07000020 	streq	r0, [r0, -r0, lsr #32]
    3c34:	00009301 	andeq	r9, r0, r1, lsl #6
    3c38:	06170300 	ldreq	r0, [r7], -r0, lsl #6
    3c3c:	000003c7 	andeq	r0, r0, r7, asr #7
    3c40:	001df90b 	andseq	pc, sp, fp, lsl #18
    3c44:	4b0b0000 	blmi	2c3c4c <__bss_end+0x2b8314>
    3c48:	0100001a 	tsteq	r0, sl, lsl r0
    3c4c:	0029cf0b 	eoreq	ip, r9, fp, lsl #30
    3c50:	620b0200 	andvs	r0, fp, #0, 4
    3c54:	03000028 	movweq	r0, #40	; 0x28
    3c58:	001e190b 	andseq	r1, lr, fp, lsl #18
    3c5c:	030b0400 	movweq	r0, #46080	; 0xb400
    3c60:	0500001b 	streq	r0, [r0, #-27]	; 0xffffffe5
    3c64:	001ec20b 	andseq	ip, lr, fp, lsl #4
    3c68:	090b0600 	stmdbeq	fp, {r9, sl}
    3c6c:	0700001e 	smladeq	r0, lr, r0, r0
    3c70:	0026f60b 	eoreq	pc, r6, fp, lsl #12
    3c74:	470b0800 	strmi	r0, [fp, -r0, lsl #16]
    3c78:	09000028 	stmdbeq	r0, {r3, r5}
    3c7c:	00262d0b 	eoreq	r2, r6, fp, lsl #26
    3c80:	560b0a00 	strpl	r0, [fp], -r0, lsl #20
    3c84:	0b00001b 	bleq	3cf8 <shift+0x3cf8>
    3c88:	001e630b 	andseq	r6, lr, fp, lsl #6
    3c8c:	cc0b0c00 	stcgt	12, cr0, [fp], {-0}
    3c90:	0d00001a 	stceq	0, cr0, [r0, #-104]	; 0xffffff98
    3c94:	002a040b 	eoreq	r0, sl, fp, lsl #8
    3c98:	f90b0e00 			; <UNDEFINED> instruction: 0xf90b0e00
    3c9c:	0f000022 	svceq	0x00000022
    3ca0:	001fd60b 	andseq	sp, pc, fp, lsl #12
    3ca4:	360b1000 	strcc	r1, [fp], -r0
    3ca8:	11000023 	tstne	r0, r3, lsr #32
    3cac:	0029230b 	eoreq	r2, r9, fp, lsl #6
    3cb0:	190b1200 	stmdbne	fp, {r9, ip}
    3cb4:	1300001c 	movwne	r0, #28
    3cb8:	001fe90b 	andseq	lr, pc, fp, lsl #18
    3cbc:	4c0b1400 	cfstrsmi	mvf1, [fp], {-0}
    3cc0:	15000022 	strne	r0, [r0, #-34]	; 0xffffffde
    3cc4:	001de40b 	andseq	lr, sp, fp, lsl #8
    3cc8:	980b1600 	stmdals	fp, {r9, sl, ip}
    3ccc:	17000022 	strne	r0, [r0, -r2, lsr #32]
    3cd0:	0020ae0b 	eoreq	sl, r0, fp, lsl #28
    3cd4:	210b1800 	tstcs	fp, r0, lsl #16
    3cd8:	1900001b 	stmdbne	r0, {r0, r1, r3, r4}
    3cdc:	0028ca0b 	eoreq	ip, r8, fp, lsl #20
    3ce0:	180b1a00 	stmdane	fp, {r9, fp, ip}
    3ce4:	1b000022 	blne	3d74 <shift+0x3d74>
    3ce8:	001fc00b 	andseq	ip, pc, fp
    3cec:	f60b1c00 			; <UNDEFINED> instruction: 0xf60b1c00
    3cf0:	1d000019 	stcne	0, cr0, [r0, #-100]	; 0xffffff9c
    3cf4:	0021630b 	eoreq	r6, r1, fp, lsl #6
    3cf8:	4f0b1e00 	svcmi	0x000b1e00
    3cfc:	1f000021 	svcne	0x00000021
    3d00:	0025ea0b 	eoreq	lr, r5, fp, lsl #20
    3d04:	750b2000 	strvc	r2, [fp, #-0]
    3d08:	21000026 	tstcs	r0, r6, lsr #32
    3d0c:	0028a90b 	eoreq	sl, r8, fp, lsl #18
    3d10:	f30b2200 	vhsub.u8	d2, d11, d0
    3d14:	2300001e 	movwcs	r0, #30
    3d18:	00244d0b 	eoreq	r4, r4, fp, lsl #26
    3d1c:	420b2400 	andmi	r2, fp, #0, 8
    3d20:	25000026 	strcs	r0, [r0, #-38]	; 0xffffffda
    3d24:	0025660b 	eoreq	r6, r5, fp, lsl #12
    3d28:	7a0b2600 	bvc	2cd530 <__bss_end+0x2c1bf8>
    3d2c:	27000025 	strcs	r0, [r0, -r5, lsr #32]
    3d30:	00258e0b 	eoreq	r8, r5, fp, lsl #28
    3d34:	a40b2800 	strge	r2, [fp], #-2048	; 0xfffff800
    3d38:	2900001c 	stmdbcs	r0, {r2, r3, r4}
    3d3c:	001c040b 	andseq	r0, ip, fp, lsl #8
    3d40:	2c0b2a00 			; <UNDEFINED> instruction: 0x2c0b2a00
    3d44:	2b00001c 	blcs	3dbc <shift+0x3dbc>
    3d48:	00273f0b 	eoreq	r3, r7, fp, lsl #30
    3d4c:	810b2c00 	tsthi	fp, r0, lsl #24
    3d50:	2d00001c 	stccs	0, cr0, [r0, #-112]	; 0xffffff90
    3d54:	0027530b 	eoreq	r5, r7, fp, lsl #6
    3d58:	670b2e00 	strvs	r2, [fp, -r0, lsl #28]
    3d5c:	2f000027 	svccs	0x00000027
    3d60:	00277b0b 	eoreq	r7, r7, fp, lsl #22
    3d64:	750b3000 	strvc	r3, [fp, #-0]
    3d68:	3100001e 	tstcc	r0, lr, lsl r0
    3d6c:	001e4f0b 	andseq	r4, lr, fp, lsl #30
    3d70:	770b3200 	strvc	r3, [fp, -r0, lsl #4]
    3d74:	33000021 	movwcc	r0, #33	; 0x21
    3d78:	0023490b 	eoreq	r4, r3, fp, lsl #18
    3d7c:	580b3400 	stmdapl	fp, {sl, ip, sp}
    3d80:	35000029 	strcc	r0, [r0, #-41]	; 0xffffffd7
    3d84:	00199e0b 	andseq	r9, r9, fp, lsl #28
    3d88:	750b3600 	strvc	r3, [fp, #-1536]	; 0xfffffa00
    3d8c:	3700001f 	smladcc	r0, pc, r0, r0	; <UNPREDICTABLE>
    3d90:	001f8a0b 	andseq	r8, pc, fp, lsl #20
    3d94:	d90b3800 	stmdble	fp, {fp, ip, sp}
    3d98:	39000021 	stmdbcc	r0, {r0, r5}
    3d9c:	0022030b 	eoreq	r0, r2, fp, lsl #6
    3da0:	810b3a00 	tsthi	fp, r0, lsl #20
    3da4:	3b000029 	blcc	3e50 <shift+0x3e50>
    3da8:	0024380b 	eoreq	r3, r4, fp, lsl #16
    3dac:	180b3c00 	stmdane	fp, {sl, fp, ip, sp}
    3db0:	3d00001f 	stccc	0, cr0, [r0, #-124]	; 0xffffff84
    3db4:	001a5d0b 	andseq	r5, sl, fp, lsl #26
    3db8:	1b0b3e00 	blne	2d35c0 <__bss_end+0x2c7c88>
    3dbc:	3f00001a 	svccc	0x0000001a
    3dc0:	0023950b 	eoreq	r9, r3, fp, lsl #10
    3dc4:	b90b4000 	stmdblt	fp, {lr}
    3dc8:	41000024 	tstmi	r0, r4, lsr #32
    3dcc:	0025cc0b 	eoreq	ip, r5, fp, lsl #24
    3dd0:	ee0b4200 	cdp	2, 0, cr4, cr11, cr0, {0}
    3dd4:	43000021 	movwmi	r0, #33	; 0x21
    3dd8:	0029ba0b 	eoreq	fp, r9, fp, lsl #20
    3ddc:	630b4400 	movwvs	r4, #46080	; 0xb400
    3de0:	45000024 	strmi	r0, [r0, #-36]	; 0xffffffdc
    3de4:	001c480b 	andseq	r4, ip, fp, lsl #16
    3de8:	c90b4600 	stmdbgt	fp, {r9, sl, lr}
    3dec:	47000022 	strmi	r0, [r0, -r2, lsr #32]
    3df0:	0020fc0b 	eoreq	pc, r0, fp, lsl #24
    3df4:	da0b4800 	ble	2d5dfc <__bss_end+0x2ca4c4>
    3df8:	49000019 	stmdbmi	r0, {r0, r3, r4}
    3dfc:	001aee0b 	andseq	lr, sl, fp, lsl #28
    3e00:	2c0b4a00 			; <UNDEFINED> instruction: 0x2c0b4a00
    3e04:	4b00001f 	blmi	3e88 <shift+0x3e88>
    3e08:	00222a0b 	eoreq	r2, r2, fp, lsl #20
    3e0c:	03004c00 	movweq	r4, #3072	; 0xc00
    3e10:	0a3c0702 	beq	f05a20 <__bss_end+0xefa0e8>
    3e14:	e40c0000 	str	r0, [ip], #-0
    3e18:	d9000003 	stmdble	r0, {r0, r1}
    3e1c:	0d000003 	stceq	0, cr0, [r0, #-12]
    3e20:	03ce0e00 	biceq	r0, lr, #0, 28
    3e24:	04050000 	streq	r0, [r5], #-0
    3e28:	000003f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
    3e2c:	0003de0e 	andeq	sp, r3, lr, lsl #28
    3e30:	08010300 	stmdaeq	r1, {r8, r9}
    3e34:	00000d7a 	andeq	r0, r0, sl, ror sp
    3e38:	0003e90e 	andeq	lr, r3, lr, lsl #18
    3e3c:	1b920f00 	blne	fe487a44 <__bss_end+0xfe47c10c>
    3e40:	4c040000 	stcmi	0, cr0, [r4], {-0}
    3e44:	03d91a01 	bicseq	r1, r9, #4096	; 0x1000
    3e48:	b00f0000 	andlt	r0, pc, r0
    3e4c:	0400001f 	streq	r0, [r0], #-31	; 0xffffffe1
    3e50:	d91a0182 	ldmdble	sl, {r1, r7, r8}
    3e54:	0c000003 	stceq	0, cr0, [r0], {3}
    3e58:	000003e9 	andeq	r0, r0, r9, ror #7
    3e5c:	0000041a 	andeq	r0, r0, sl, lsl r4
    3e60:	9b09000d 	blls	243e9c <__bss_end+0x238564>
    3e64:	05000021 	streq	r0, [r0, #-33]	; 0xffffffdf
    3e68:	040f0d2d 	streq	r0, [pc], #-3373	; 3e70 <shift+0x3e70>
    3e6c:	23090000 	movwcs	r0, #36864	; 0x9000
    3e70:	05000028 	streq	r0, [r0, #-40]	; 0xffffffd8
    3e74:	01e61c38 	mvneq	r1, r8, lsr ip
    3e78:	890a0000 	stmdbhi	sl, {}	; <UNPREDICTABLE>
    3e7c:	0700001e 	smladeq	r0, lr, r0, r0
    3e80:	00009301 	andeq	r9, r0, r1, lsl #6
    3e84:	0e3a0500 	cfabs32eq	mvfx0, mvfx10
    3e88:	000004a5 	andeq	r0, r0, r5, lsr #9
    3e8c:	0019ef0b 	andseq	lr, r9, fp, lsl #30
    3e90:	9b0b0000 	blls	2c3e98 <__bss_end+0x2b8560>
    3e94:	01000020 	tsteq	r0, r0, lsr #32
    3e98:	0029350b 	eoreq	r3, r9, fp, lsl #10
    3e9c:	f80b0200 			; <UNDEFINED> instruction: 0xf80b0200
    3ea0:	03000028 	movweq	r0, #40	; 0x28
    3ea4:	0023f20b 	eoreq	pc, r3, fp, lsl #4
    3ea8:	b30b0400 	movwlt	r0, #46080	; 0xb400
    3eac:	05000026 	streq	r0, [r0, #-38]	; 0xffffffda
    3eb0:	001bd50b 	andseq	sp, fp, fp, lsl #10
    3eb4:	b70b0600 	strlt	r0, [fp, -r0, lsl #12]
    3eb8:	0700001b 	smladeq	r0, fp, r0, r0
    3ebc:	001dd00b 	andseq	sp, sp, fp
    3ec0:	ae0b0800 	cdpge	8, 0, cr0, cr11, cr0, {0}
    3ec4:	09000022 	stmdbeq	r0, {r1, r5}
    3ec8:	001bdc0b 	andseq	sp, fp, fp, lsl #24
    3ecc:	b50b0a00 	strlt	r0, [fp, #-2560]	; 0xfffff600
    3ed0:	0b000022 	bleq	3f60 <shift+0x3f60>
    3ed4:	001c410b 	andseq	r4, ip, fp, lsl #2
    3ed8:	ce0b0c00 	cdpgt	12, 0, cr0, cr11, cr0, {0}
    3edc:	0d00001b 	stceq	0, cr0, [r0, #-108]	; 0xffffff94
    3ee0:	00270a0b 	eoreq	r0, r7, fp, lsl #20
    3ee4:	d70b0e00 	strle	r0, [fp, -r0, lsl #28]
    3ee8:	0f000024 	svceq	0x00000024
    3eec:	26020400 	strcs	r0, [r2], -r0, lsl #8
    3ef0:	3f050000 	svccc	0x00050000
    3ef4:	00043201 	andeq	r3, r4, r1, lsl #4
    3ef8:	26960900 	ldrcs	r0, [r6], r0, lsl #18
    3efc:	41050000 	mrsmi	r0, (UNDEF: 5)
    3f00:	0004a50f 	andeq	sl, r4, pc, lsl #10
    3f04:	271e0900 	ldrcs	r0, [lr, -r0, lsl #18]
    3f08:	4a050000 	bmi	143f10 <__bss_end+0x1385d8>
    3f0c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    3f10:	1b760900 	blne	1d86318 <__bss_end+0x1d7a9e0>
    3f14:	4b050000 	blmi	143f1c <__bss_end+0x1385e4>
    3f18:	00001d0c 	andeq	r1, r0, ip, lsl #26
    3f1c:	27f71000 	ldrbcs	r1, [r7, r0]!
    3f20:	2f090000 	svccs	0x00090000
    3f24:	05000027 	streq	r0, [r0, #-39]	; 0xffffffd9
    3f28:	04e6144c 	strbteq	r1, [r6], #1100	; 0x44c
    3f2c:	04050000 	streq	r0, [r5], #-0
    3f30:	000004d5 	ldrdeq	r0, [r0], -r5
    3f34:	20650911 	rsbcs	r0, r5, r1, lsl r9
    3f38:	4e050000 	cdpmi	0, 0, cr0, cr5, cr0, {0}
    3f3c:	0004f90f 	andeq	pc, r4, pc, lsl #18
    3f40:	ec040500 	cfstr32	mvfx0, [r4], {-0}
    3f44:	12000004 	andne	r0, r0, #4
    3f48:	00002618 	andeq	r2, r0, r8, lsl r6
    3f4c:	0023df09 	eoreq	sp, r3, r9, lsl #30
    3f50:	0d520500 	cfldr64eq	mvdx0, [r2, #-0]
    3f54:	00000510 	andeq	r0, r0, r0, lsl r5
    3f58:	04ff0405 	ldrbteq	r0, [pc], #1029	; 3f60 <shift+0x3f60>
    3f5c:	ed130000 	ldc	0, cr0, [r3, #-0]
    3f60:	3400001c 	strcc	r0, [r0], #-28	; 0xffffffe4
    3f64:	15016705 	strne	r6, [r1, #-1797]	; 0xfffff8fb
    3f68:	00000541 	andeq	r0, r0, r1, asr #10
    3f6c:	0021a414 	eoreq	sl, r1, r4, lsl r4
    3f70:	01690500 	cmneq	r9, r0, lsl #10
    3f74:	0003de0f 	andeq	sp, r3, pc, lsl #28
    3f78:	d1140000 	tstle	r4, r0
    3f7c:	0500001c 	streq	r0, [r0, #-28]	; 0xffffffe4
    3f80:	4614016a 	ldrmi	r0, [r4], -sl, ror #2
    3f84:	04000005 	streq	r0, [r0], #-5
    3f88:	05160e00 	ldreq	r0, [r6, #-3584]	; 0xfffff200
    3f8c:	b90c0000 	stmdblt	ip, {}	; <UNPREDICTABLE>
    3f90:	56000000 	strpl	r0, [r0], -r0
    3f94:	15000005 	strne	r0, [r0, #-5]
    3f98:	00000024 	andeq	r0, r0, r4, lsr #32
    3f9c:	410c002d 	tstmi	ip, sp, lsr #32
    3fa0:	61000005 	tstvs	r0, r5
    3fa4:	0d000005 	stceq	0, cr0, [r0, #-20]	; 0xffffffec
    3fa8:	05560e00 	ldrbeq	r0, [r6, #-3584]	; 0xfffff200
    3fac:	d30f0000 	movwle	r0, #61440	; 0xf000
    3fb0:	05000020 	streq	r0, [r0, #-32]	; 0xffffffe0
    3fb4:	6103016b 	tstvs	r3, fp, ror #2
    3fb8:	0f000005 	svceq	0x00000005
    3fbc:	00002319 	andeq	r2, r0, r9, lsl r3
    3fc0:	0c016e05 	stceq	14, cr6, [r1], {5}
    3fc4:	0000001d 	andeq	r0, r0, sp, lsl r0
    3fc8:	00265616 	eoreq	r5, r6, r6, lsl r6
    3fcc:	93010700 	movwls	r0, #5888	; 0x1700
    3fd0:	05000000 	streq	r0, [r0, #-0]
    3fd4:	2a060181 	bcs	1845e0 <__bss_end+0x178ca8>
    3fd8:	0b000006 	bleq	3ff8 <shift+0x3ff8>
    3fdc:	00001a84 	andeq	r1, r0, r4, lsl #21
    3fe0:	1a900b00 	bne	fe406be8 <__bss_end+0xfe3fb2b0>
    3fe4:	0b020000 	bleq	83fec <__bss_end+0x786b4>
    3fe8:	00001a9c 	muleq	r0, ip, sl
    3fec:	1eb50b03 	vmovne.f64	d0, #83	; 0x3e980000  0.2968750
    3ff0:	0b030000 	bleq	c3ff8 <__bss_end+0xb86c0>
    3ff4:	00001aa8 	andeq	r1, r0, r8, lsr #21
    3ff8:	1ffe0b04 	svcne	0x00fe0b04
    3ffc:	0b040000 	bleq	104004 <__bss_end+0xf86cc>
    4000:	000020e4 	andeq	r2, r0, r4, ror #1
    4004:	203a0b05 	eorscs	r0, sl, r5, lsl #22
    4008:	0b050000 	bleq	144010 <__bss_end+0x1386d8>
    400c:	00001b67 	andeq	r1, r0, r7, ror #22
    4010:	1ab40b05 	bne	fed06c2c <__bss_end+0xfecfb2f4>
    4014:	0b060000 	bleq	18401c <__bss_end+0x1786e4>
    4018:	00002262 	andeq	r2, r0, r2, ror #4
    401c:	1cc30b06 	vstmiane	r3, {d16-d18}
    4020:	0b060000 	bleq	184028 <__bss_end+0x1786f0>
    4024:	0000226f 	andeq	r2, r0, pc, ror #4
    4028:	26d60b06 	ldrbcs	r0, [r6], r6, lsl #22
    402c:	0b060000 	bleq	184034 <__bss_end+0x1786fc>
    4030:	0000227c 	andeq	r2, r0, ip, ror r2
    4034:	22bc0b06 	adcscs	r0, ip, #6144	; 0x1800
    4038:	0b060000 	bleq	184040 <__bss_end+0x178708>
    403c:	00001ac0 	andeq	r1, r0, r0, asr #21
    4040:	23c20b07 	biccs	r0, r2, #7168	; 0x1c00
    4044:	0b070000 	bleq	1c404c <__bss_end+0x1b8714>
    4048:	0000240f 	andeq	r2, r0, pc, lsl #8
    404c:	27110b07 	ldrcs	r0, [r1, -r7, lsl #22]
    4050:	0b070000 	bleq	1c4058 <__bss_end+0x1b8720>
    4054:	00001c96 	muleq	r0, r6, ip
    4058:	24900b07 	ldrcs	r0, [r0], #2823	; 0xb07
    405c:	0b080000 	bleq	204064 <__bss_end+0x1f872c>
    4060:	00001a39 	andeq	r1, r0, r9, lsr sl
    4064:	26e40b08 	strbtcs	r0, [r4], r8, lsl #22
    4068:	0b080000 	bleq	204070 <__bss_end+0x1f8738>
    406c:	000024ac 	andeq	r2, r0, ip, lsr #9
    4070:	4a0f0008 	bmi	3c4098 <__bss_end+0x3b8760>
    4074:	05000029 	streq	r0, [r0, #-41]	; 0xffffffd7
    4078:	801f019f 	mulshi	pc, pc, r1	; <UNPREDICTABLE>
    407c:	0f000005 	svceq	0x00000005
    4080:	000024de 	ldrdeq	r2, [r0], -lr
    4084:	0c01a205 	sfmeq	f2, 1, [r1], {5}
    4088:	0000001d 	andeq	r0, r0, sp, lsl r0
    408c:	0020f10f 	eoreq	pc, r0, pc, lsl #2
    4090:	01a50500 			; <UNDEFINED> instruction: 0x01a50500
    4094:	00001d0c 	andeq	r1, r0, ip, lsl #26
    4098:	2a160f00 	bcs	587ca0 <__bss_end+0x57c368>
    409c:	a8050000 	stmdage	r5, {}	; <UNPREDICTABLE>
    40a0:	001d0c01 	andseq	r0, sp, r1, lsl #24
    40a4:	860f0000 	strhi	r0, [pc], -r0
    40a8:	0500001b 	streq	r0, [r0, #-27]	; 0xffffffe5
    40ac:	1d0c01ab 	stfnes	f0, [ip, #-684]	; 0xfffffd54
    40b0:	0f000000 	svceq	0x00000000
    40b4:	000024e8 	andeq	r2, r0, r8, ror #9
    40b8:	0c01ae05 	stceq	14, cr10, [r1], {5}
    40bc:	0000001d 	andeq	r0, r0, sp, lsl r0
    40c0:	0023f90f 	eoreq	pc, r3, pc, lsl #18
    40c4:	01b10500 			; <UNDEFINED> instruction: 0x01b10500
    40c8:	00001d0c 	andeq	r1, r0, ip, lsl #26
    40cc:	24040f00 	strcs	r0, [r4], #-3840	; 0xfffff100
    40d0:	b4050000 	strlt	r0, [r5], #-0
    40d4:	001d0c01 	andseq	r0, sp, r1, lsl #24
    40d8:	f20f0000 	vhadd.s8	d0, d15, d0
    40dc:	05000024 	streq	r0, [r0, #-36]	; 0xffffffdc
    40e0:	1d0c01b7 	stfnes	f0, [ip, #-732]	; 0xfffffd24
    40e4:	0f000000 	svceq	0x00000000
    40e8:	0000223e 	andeq	r2, r0, lr, lsr r2
    40ec:	0c01ba05 			; <UNDEFINED> instruction: 0x0c01ba05
    40f0:	0000001d 	andeq	r0, r0, sp, lsl r0
    40f4:	0029750f 	eoreq	r7, r9, pc, lsl #10
    40f8:	01bd0500 			; <UNDEFINED> instruction: 0x01bd0500
    40fc:	00001d0c 	andeq	r1, r0, ip, lsl #26
    4100:	24fc0f00 	ldrbtcs	r0, [ip], #3840	; 0xf00
    4104:	c0050000 	andgt	r0, r5, r0
    4108:	001d0c01 	andseq	r0, sp, r1, lsl #24
    410c:	390f0000 	stmdbcc	pc, {}	; <UNPREDICTABLE>
    4110:	0500002a 	streq	r0, [r0, #-42]	; 0xffffffd6
    4114:	1d0c01c3 	stfnes	f0, [ip, #-780]	; 0xfffffcf4
    4118:	0f000000 	svceq	0x00000000
    411c:	000028ff 	strdeq	r2, [r0], -pc	; <UNPREDICTABLE>
    4120:	0c01c605 	stceq	6, cr12, [r1], {5}
    4124:	0000001d 	andeq	r0, r0, sp, lsl r0
    4128:	00290b0f 	eoreq	r0, r9, pc, lsl #22
    412c:	01c90500 	biceq	r0, r9, r0, lsl #10
    4130:	00001d0c 	andeq	r1, r0, ip, lsl #26
    4134:	29170f00 	ldmdbcs	r7, {r8, r9, sl, fp}
    4138:	cc050000 	stcgt	0, cr0, [r5], {-0}
    413c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    4140:	3c0f0000 	stccc	0, cr0, [pc], {-0}
    4144:	05000029 	streq	r0, [r0, #-41]	; 0xffffffd7
    4148:	1d0c01d0 	stfnes	f0, [ip, #-832]	; 0xfffffcc0
    414c:	0f000000 	svceq	0x00000000
    4150:	00002a2c 	andeq	r2, r0, ip, lsr #20
    4154:	0c01d305 	stceq	3, cr13, [r1], {5}
    4158:	0000001d 	andeq	r0, r0, sp, lsl r0
    415c:	001be30f 	andseq	lr, fp, pc, lsl #6
    4160:	01d60500 	bicseq	r0, r6, r0, lsl #10
    4164:	00001d0c 	andeq	r1, r0, ip, lsl #26
    4168:	19ca0f00 	stmibne	sl, {r8, r9, sl, fp}^
    416c:	d9050000 	stmdble	r5, {}	; <UNPREDICTABLE>
    4170:	001d0c01 	andseq	r0, sp, r1, lsl #24
    4174:	d50f0000 	strle	r0, [pc, #-0]	; 417c <shift+0x417c>
    4178:	0500001e 	streq	r0, [r0, #-30]	; 0xffffffe2
    417c:	1d0c01dc 	stfnes	f0, [ip, #-880]	; 0xfffffc90
    4180:	0f000000 	svceq	0x00000000
    4184:	00001bbe 			; <UNDEFINED> instruction: 0x00001bbe
    4188:	0c01df05 	stceq	15, cr13, [r1], {5}
    418c:	0000001d 	andeq	r0, r0, sp, lsl r0
    4190:	0025120f 	eoreq	r1, r5, pc, lsl #4
    4194:	01e20500 	mvneq	r0, r0, lsl #10
    4198:	00001d0c 	andeq	r1, r0, ip, lsl #26
    419c:	211a0f00 	tstcs	sl, r0, lsl #30
    41a0:	e5050000 	str	r0, [r5, #-0]
    41a4:	001d0c01 	andseq	r0, sp, r1, lsl #24
    41a8:	720f0000 	andvc	r0, pc, #0
    41ac:	05000023 	streq	r0, [r0, #-35]	; 0xffffffdd
    41b0:	1d0c01e8 	stfnes	f0, [ip, #-928]	; 0xfffffc60
    41b4:	0f000000 	svceq	0x00000000
    41b8:	0000282c 	andeq	r2, r0, ip, lsr #16
    41bc:	0c01ef05 	stceq	15, cr14, [r1], {5}
    41c0:	0000001d 	andeq	r0, r0, sp, lsl r0
    41c4:	0029e40f 	eoreq	lr, r9, pc, lsl #8
    41c8:	01f20500 	mvnseq	r0, r0, lsl #10
    41cc:	00001d0c 	andeq	r1, r0, ip, lsl #26
    41d0:	29f40f00 	ldmibcs	r4!, {r8, r9, sl, fp}^
    41d4:	f5050000 			; <UNDEFINED> instruction: 0xf5050000
    41d8:	001d0c01 	andseq	r0, sp, r1, lsl #24
    41dc:	da0f0000 	ble	3c41e4 <__bss_end+0x3b88ac>
    41e0:	0500001c 	streq	r0, [r0, #-28]	; 0xffffffe4
    41e4:	1d0c01f8 	stfnes	f0, [ip, #-992]	; 0xfffffc20
    41e8:	0f000000 	svceq	0x00000000
    41ec:	00002873 	andeq	r2, r0, r3, ror r8
    41f0:	0c01fb05 			; <UNDEFINED> instruction: 0x0c01fb05
    41f4:	0000001d 	andeq	r0, r0, sp, lsl r0
    41f8:	0024780f 	eoreq	r7, r4, pc, lsl #16
    41fc:	01fe0500 	mvnseq	r0, r0, lsl #10
    4200:	00001d0c 	andeq	r1, r0, ip, lsl #26
    4204:	1f4e0f00 	svcne	0x004e0f00
    4208:	02050000 	andeq	r0, r5, #0
    420c:	001d0c02 	andseq	r0, sp, r2, lsl #24
    4210:	680f0000 	stmdavs	pc, {}	; <UNPREDICTABLE>
    4214:	05000026 	streq	r0, [r0, #-38]	; 0xffffffda
    4218:	1d0c020a 	sfmne	f0, 4, [ip, #-40]	; 0xffffffd8
    421c:	0f000000 	svceq	0x00000000
    4220:	00001e41 	andeq	r1, r0, r1, asr #28
    4224:	0c020d05 	stceq	13, cr0, [r2], {5}
    4228:	0000001d 	andeq	r0, r0, sp, lsl r0
    422c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    4230:	0007ef00 	andeq	lr, r7, r0, lsl #30
    4234:	0f000d00 	svceq	0x00000d00
    4238:	0000201a 	andeq	r2, r0, sl, lsl r0
    423c:	0c03fb05 			; <UNDEFINED> instruction: 0x0c03fb05
    4240:	000007e4 	andeq	r0, r0, r4, ror #15
    4244:	0004e60c 	andeq	lr, r4, ip, lsl #12
    4248:	00080c00 	andeq	r0, r8, r0, lsl #24
    424c:	00241500 	eoreq	r1, r4, r0, lsl #10
    4250:	000d0000 	andeq	r0, sp, r0
    4254:	0025350f 	eoreq	r3, r5, pc, lsl #10
    4258:	05840500 	streq	r0, [r4, #1280]	; 0x500
    425c:	0007fc14 	andeq	pc, r7, r4, lsl ip	; <UNPREDICTABLE>
    4260:	20dc1600 	sbcscs	r1, ip, r0, lsl #12
    4264:	01070000 	mrseq	r0, (UNDEF: 7)
    4268:	00000093 	muleq	r0, r3, r0
    426c:	06058b05 	streq	r8, [r5], -r5, lsl #22
    4270:	00000857 	andeq	r0, r0, r7, asr r8
    4274:	001e970b 	andseq	r9, lr, fp, lsl #14
    4278:	e70b0000 	str	r0, [fp, -r0]
    427c:	01000022 	tsteq	r0, r2, lsr #32
    4280:	001a6f0b 	andseq	r6, sl, fp, lsl #30
    4284:	a60b0200 	strge	r0, [fp], -r0, lsl #4
    4288:	03000029 	movweq	r0, #41	; 0x29
    428c:	0025af0b 	eoreq	sl, r5, fp, lsl #30
    4290:	a20b0400 	andge	r0, fp, #0, 8
    4294:	05000025 	streq	r0, [r0, #-37]	; 0xffffffdb
    4298:	001b460b 	andseq	r4, fp, fp, lsl #12
    429c:	0f000600 	svceq	0x00000600
    42a0:	00002996 	muleq	r0, r6, r9
    42a4:	15059805 	strne	r9, [r5, #-2053]	; 0xfffff7fb
    42a8:	00000819 	andeq	r0, r0, r9, lsl r8
    42ac:	0028980f 	eoreq	r9, r8, pc, lsl #16
    42b0:	07990500 	ldreq	r0, [r9, r0, lsl #10]
    42b4:	00002411 	andeq	r2, r0, r1, lsl r4
    42b8:	25220f00 	strcs	r0, [r2, #-3840]!	; 0xfffff100
    42bc:	ae050000 	cdpge	0, 0, cr0, cr5, cr0, {0}
    42c0:	001d0c07 	andseq	r0, sp, r7, lsl #24
    42c4:	0b040000 	bleq	1042cc <__bss_end+0xf8994>
    42c8:	06000028 	streq	r0, [r0], -r8, lsr #32
    42cc:	0093167b 	addseq	r1, r3, fp, ror r6
    42d0:	7e0e0000 	cdpvc	0, 0, cr0, cr14, cr0, {0}
    42d4:	03000008 	movweq	r0, #8
    42d8:	0dbc0502 	cfldr32eq	mvfx0, [ip, #8]!
    42dc:	08030000 	stmdaeq	r3, {}	; <UNPREDICTABLE>
    42e0:	001e2a07 	andseq	r2, lr, r7, lsl #20
    42e4:	04040300 	streq	r0, [r4], #-768	; 0xfffffd00
    42e8:	00001bfe 	strdeq	r1, [r0], -lr
    42ec:	f6030803 			; <UNDEFINED> instruction: 0xf6030803
    42f0:	0300001b 	movweq	r0, #27
    42f4:	250b0408 	strcs	r0, [fp, #-1032]	; 0xfffffbf8
    42f8:	10030000 	andne	r0, r3, r0
    42fc:	0025bd03 	eoreq	fp, r5, r3, lsl #26
    4300:	088a0c00 	stmeq	sl, {sl, fp}
    4304:	08c90000 	stmiaeq	r9, {}^	; <UNPREDICTABLE>
    4308:	24150000 	ldrcs	r0, [r5], #-0
    430c:	ff000000 			; <UNDEFINED> instruction: 0xff000000
    4310:	08b90e00 	ldmeq	r9!, {r9, sl, fp}
    4314:	1c0f0000 	stcne	0, cr0, [pc], {-0}
    4318:	06000024 	streq	r0, [r0], -r4, lsr #32
    431c:	c91601fc 	ldmdbgt	r6, {r2, r3, r4, r5, r6, r7, r8}
    4320:	0f000008 	svceq	0x00000008
    4324:	00001bad 	andeq	r1, r0, sp, lsr #23
    4328:	16020206 	strne	r0, [r2], -r6, lsl #4
    432c:	000008c9 	andeq	r0, r0, r9, asr #17
    4330:	00283e04 	eoreq	r3, r8, r4, lsl #28
    4334:	102a0700 	eorne	r0, sl, r0, lsl #14
    4338:	000004f9 	strdeq	r0, [r0], -r9
    433c:	0008e80c 	andeq	lr, r8, ip, lsl #16
    4340:	0008ff00 	andeq	pc, r8, r0, lsl #30
    4344:	09000d00 	stmdbeq	r0, {r8, sl, fp}
    4348:	0000036c 	andeq	r0, r0, ip, ror #6
    434c:	f4112f07 			; <UNDEFINED> instruction: 0xf4112f07
    4350:	09000008 	stmdbeq	r0, {r3}
    4354:	00000231 	andeq	r0, r0, r1, lsr r2
    4358:	f4113007 			; <UNDEFINED> instruction: 0xf4113007
    435c:	17000008 	strne	r0, [r0, -r8]
    4360:	000008ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
    4364:	0a093308 	beq	250f8c <__bss_end+0x245654>
    4368:	b4600305 	strbtlt	r0, [r0], #-773	; 0xfffffcfb
    436c:	0b170000 	bleq	5c4374 <__bss_end+0x5b8a3c>
    4370:	08000009 	stmdaeq	r0, {r0, r3}
    4374:	050a0934 	streq	r0, [sl, #-2356]	; 0xfffff6cc
    4378:	00b46403 	adcseq	r6, r4, r3, lsl #8
	...

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	10001101 	andne	r1, r0, r1, lsl #2
   4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
   8:	1b0e0301 	blne	380c14 <__bss_end+0x3752dc>
   c:	130e250e 	movwne	r2, #58638	; 0xe50e
  10:	00000005 	andeq	r0, r0, r5
  14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
  18:	030b130e 	movweq	r1, #45838	; 0xb30e
  1c:	110e1b0e 	tstne	lr, lr, lsl #22
  20:	10061201 	andne	r1, r6, r1, lsl #4
  24:	02000017 	andeq	r0, r0, #23
  28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeb73e4>
  30:	13490b39 	movtne	r0, #39737	; 0x9b39
  34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
  38:	24030000 	strcs	r0, [r3], #-0
  3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  40:	000e030b 	andeq	r0, lr, fp, lsl #6
  44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
  48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeb7404>
  50:	01110b39 	tsteq	r1, r9, lsr fp
  54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
  58:	01194296 			; <UNDEFINED> instruction: 0x01194296
  5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeb741c>
  68:	13490b39 	movtne	r0, #39737	; 0x9b39
  6c:	00001802 	andeq	r1, r0, r2, lsl #16
  70:	0b002406 	bleq	9090 <_Z5countv+0x80>
  74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  78:	07000008 	streq	r0, [r0, -r8]
  7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe77f5c>
  84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe37440>
  88:	06120111 			; <UNDEFINED> instruction: 0x06120111
  8c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
  90:	00130119 	andseq	r0, r3, r9, lsl r1
  94:	010b0800 	tsteq	fp, r0, lsl #16
  98:	06120111 			; <UNDEFINED> instruction: 0x06120111
  9c:	34090000 	strcc	r0, [r9], #-0
  a0:	3a080300 	bcc	200ca8 <__bss_end+0x1f5370>
  a4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  a8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
  ac:	0a000018 	beq	114 <shift+0x114>
  b0:	0b0b000f 	bleq	2c00f4 <__bss_end+0x2b47bc>
  b4:	00001349 	andeq	r1, r0, r9, asr #6
  b8:	01110100 	tsteq	r1, r0, lsl #2
  bc:	0b130e25 	bleq	4c3958 <__bss_end+0x4b8020>
  c0:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
  c4:	06120111 			; <UNDEFINED> instruction: 0x06120111
  c8:	00001710 	andeq	r1, r0, r0, lsl r7
  cc:	03001602 	movweq	r1, #1538	; 0x602
  d0:	3b0b3a0e 	blcc	2ce910 <__bss_end+0x2c2fd8>
  d4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
  d8:	03000013 	movweq	r0, #19
  dc:	0b0b000f 	bleq	2c0120 <__bss_end+0x2b47e8>
  e0:	00001349 	andeq	r1, r0, r9, asr #6
  e4:	00001504 	andeq	r1, r0, r4, lsl #10
  e8:	01010500 	tsteq	r1, r0, lsl #10
  ec:	13011349 	movwne	r1, #4937	; 0x1349
  f0:	21060000 	mrscs	r0, (UNDEF: 6)
  f4:	2f134900 	svccs	0x00134900
  f8:	07000006 	streq	r0, [r0, -r6]
  fc:	0b0b0024 	bleq	2c0194 <__bss_end+0x2b485c>
 100:	0e030b3e 	vmoveq.16	d3[0], r0
 104:	34080000 	strcc	r0, [r8], #-0
 108:	3a0e0300 	bcc	380d10 <__bss_end+0x3753d8>
 10c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 110:	3f13490b 	svccc	0x0013490b
 114:	00193c19 	andseq	r3, r9, r9, lsl ip
 118:	012e0900 			; <UNDEFINED> instruction: 0x012e0900
 11c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeb74d8>
 124:	13490b39 	movtne	r0, #39737	; 0x9b39
 128:	06120111 			; <UNDEFINED> instruction: 0x06120111
 12c:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 130:	00130119 	andseq	r0, r3, r9, lsl r1
 134:	00340a00 	eorseq	r0, r4, r0, lsl #20
 138:	0b3a0e03 	bleq	e8394c <__bss_end+0xe78014>
 13c:	0b390b3b 	bleq	e42e30 <__bss_end+0xe374f8>
 140:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 144:	240b0000 	strcs	r0, [fp], #-0
 148:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 14c:	0008030b 	andeq	r0, r8, fp, lsl #6
 150:	002e0c00 	eoreq	r0, lr, r0, lsl #24
 154:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 158:	0b3b0b3a 	bleq	ec2e48 <__bss_end+0xeb7510>
 15c:	01110b39 	tsteq	r1, r9, lsr fp
 160:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 164:	00194297 	mulseq	r9, r7, r2
 168:	01390d00 	teqeq	r9, r0, lsl #26
 16c:	0b3a0e03 	bleq	e83980 <__bss_end+0xe78048>
 170:	13010b3b 	movwne	r0, #6971	; 0x1b3b
 174:	2e0e0000 	cdpcs	0, 0, cr0, cr14, cr0, {0}
 178:	03193f01 	tsteq	r9, #1, 30
 17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c3084>
 180:	3c0b390b 			; <UNDEFINED> instruction: 0x3c0b390b
 184:	00130119 	andseq	r0, r3, r9, lsl r1
 188:	00050f00 	andeq	r0, r5, r0, lsl #30
 18c:	00001349 	andeq	r1, r0, r9, asr #6
 190:	3f012e10 	svccc	0x00012e10
 194:	3a0e0319 	bcc	380e00 <__bss_end+0x3754c8>
 198:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 19c:	3c13490b 			; <UNDEFINED> instruction: 0x3c13490b
 1a0:	11000019 	tstne	r0, r9, lsl r0
 1a4:	1347012e 	movtne	r0, #28974	; 0x712e
 1a8:	06120111 			; <UNDEFINED> instruction: 0x06120111
 1ac:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 1b0:	00130119 	andseq	r0, r3, r9, lsl r1
 1b4:	00051200 	andeq	r1, r5, r0, lsl #4
 1b8:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 1bc:	05130000 	ldreq	r0, [r3, #-0]
 1c0:	3a080300 	bcc	200dc8 <__bss_end+0x1f5490>
 1c4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 1c8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 1cc:	14000018 	strne	r0, [r0], #-24	; 0xffffffe8
 1d0:	1347012e 	movtne	r0, #28974	; 0x712e
 1d4:	06120111 			; <UNDEFINED> instruction: 0x06120111
 1d8:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 1dc:	00000019 	andeq	r0, r0, r9, lsl r0
 1e0:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 1e4:	030b130e 	movweq	r1, #45838	; 0xb30e
 1e8:	110e1b0e 	tstne	lr, lr, lsl #22
 1ec:	10061201 	andne	r1, r6, r1, lsl #4
 1f0:	02000017 	andeq	r0, r0, #23
 1f4:	0b0b0024 	bleq	2c028c <__bss_end+0x2b4954>
 1f8:	0e030b3e 	vmoveq.16	d3[0], r0
 1fc:	26030000 	strcs	r0, [r3], -r0
 200:	00134900 	andseq	r4, r3, r0, lsl #18
 204:	00240400 	eoreq	r0, r4, r0, lsl #8
 208:	0b3e0b0b 	bleq	f82e3c <__bss_end+0xf77504>
 20c:	00000803 	andeq	r0, r0, r3, lsl #16
 210:	03001605 	movweq	r1, #1541	; 0x605
 214:	3b0b3a0e 	blcc	2cea54 <__bss_end+0x2c311c>
 218:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 21c:	06000013 			; <UNDEFINED> instruction: 0x06000013
 220:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
 224:	0b3a0b0b 	bleq	e82e58 <__bss_end+0xe77520>
 228:	0b390b3b 	bleq	e42f1c <__bss_end+0xe375e4>
 22c:	00001301 	andeq	r1, r0, r1, lsl #6
 230:	03000d07 	movweq	r0, #3335	; 0xd07
 234:	3b0b3a08 	blcc	2cea5c <__bss_end+0x2c3124>
 238:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 23c:	000b3813 	andeq	r3, fp, r3, lsl r8
 240:	01040800 	tsteq	r4, r0, lsl #16
 244:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
 248:	0b0b0b3e 	bleq	2c2f48 <__bss_end+0x2b7610>
 24c:	0b3a1349 	bleq	e84f78 <__bss_end+0xe79640>
 250:	0b390b3b 	bleq	e42f44 <__bss_end+0xe3760c>
 254:	00001301 	andeq	r1, r0, r1, lsl #6
 258:	03002809 	movweq	r2, #2057	; 0x809
 25c:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 260:	00340a00 	eorseq	r0, r4, r0, lsl #20
 264:	0b3a0e03 	bleq	e83a78 <__bss_end+0xe78140>
 268:	0b390b3b 	bleq	e42f5c <__bss_end+0xe37624>
 26c:	196c1349 	stmdbne	ip!, {r0, r3, r6, r8, r9, ip}^
 270:	00001802 	andeq	r1, r0, r2, lsl #16
 274:	0300020b 	movweq	r0, #523	; 0x20b
 278:	00193c0e 	andseq	r3, r9, lr, lsl #24
 27c:	01020c00 	tsteq	r2, r0, lsl #24
 280:	0b0b0e03 	bleq	2c3a94 <__bss_end+0x2b815c>
 284:	0b3b0b3a 	bleq	ec2f74 <__bss_end+0xeb763c>
 288:	13010b39 	movwne	r0, #6969	; 0x1b39
 28c:	0d0d0000 	stceq	0, cr0, [sp, #-0]
 290:	3a0e0300 	bcc	380e98 <__bss_end+0x375560>
 294:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 298:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 29c:	0e00000b 	cdpeq	0, 0, cr0, cr0, cr11, {0}
 2a0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 2a4:	0b3a0e03 	bleq	e83ab8 <__bss_end+0xe78180>
 2a8:	0b390b3b 	bleq	e42f9c <__bss_end+0xe37664>
 2ac:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 2b0:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 2b4:	050f0000 	streq	r0, [pc, #-0]	; 2bc <shift+0x2bc>
 2b8:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
 2bc:	10000019 	andne	r0, r0, r9, lsl r0
 2c0:	13490005 	movtne	r0, #36869	; 0x9005
 2c4:	0d110000 	ldceq	0, cr0, [r1, #-0]
 2c8:	3a0e0300 	bcc	380ed0 <__bss_end+0x375598>
 2cc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 2d0:	3f13490b 	svccc	0x0013490b
 2d4:	00193c19 	andseq	r3, r9, r9, lsl ip
 2d8:	012e1200 			; <UNDEFINED> instruction: 0x012e1200
 2dc:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 2e0:	0b3b0b3a 	bleq	ec2fd0 <__bss_end+0xeb7698>
 2e4:	0e6e0b39 	vmoveq.8	d14[5], r0
 2e8:	0b321349 	bleq	c85014 <__bss_end+0xc796dc>
 2ec:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 2f0:	00001301 	andeq	r1, r0, r1, lsl #6
 2f4:	3f012e13 	svccc	0x00012e13
 2f8:	3a0e0319 	bcc	380f64 <__bss_end+0x37562c>
 2fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 300:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
 304:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 308:	00130113 	andseq	r0, r3, r3, lsl r1
 30c:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 310:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 314:	0b3b0b3a 	bleq	ec3004 <__bss_end+0xeb76cc>
 318:	0e6e0b39 	vmoveq.8	d14[5], r0
 31c:	0b321349 	bleq	c85048 <__bss_end+0xc79710>
 320:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 324:	01150000 	tsteq	r5, r0
 328:	01134901 	tsteq	r3, r1, lsl #18
 32c:	16000013 			; <UNDEFINED> instruction: 0x16000013
 330:	13490021 	movtne	r0, #36897	; 0x9021
 334:	00000b2f 	andeq	r0, r0, pc, lsr #22
 338:	0b000f17 	bleq	3f9c <shift+0x3f9c>
 33c:	0013490b 	andseq	r4, r3, fp, lsl #18
 340:	00211800 	eoreq	r1, r1, r0, lsl #16
 344:	34190000 	ldrcc	r0, [r9], #-0
 348:	3a0e0300 	bcc	380f50 <__bss_end+0x375618>
 34c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 350:	3f13490b 	svccc	0x0013490b
 354:	00193c19 	andseq	r3, r9, r9, lsl ip
 358:	00281a00 	eoreq	r1, r8, r0, lsl #20
 35c:	0b1c0803 	bleq	702370 <__bss_end+0x6f6a38>
 360:	2e1b0000 	cdpcs	0, 1, cr0, cr11, cr0, {0}
 364:	03193f01 	tsteq	r9, #1, 30
 368:	3b0b3a0e 	blcc	2ceba8 <__bss_end+0x2c3270>
 36c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 370:	64193c0e 	ldrvs	r3, [r9], #-3086	; 0xfffff3f2
 374:	00130113 	andseq	r0, r3, r3, lsl r1
 378:	012e1c00 			; <UNDEFINED> instruction: 0x012e1c00
 37c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 380:	0b3b0b3a 	bleq	ec3070 <__bss_end+0xeb7738>
 384:	0e6e0b39 	vmoveq.8	d14[5], r0
 388:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 38c:	13011364 	movwne	r1, #4964	; 0x1364
 390:	0d1d0000 	ldceq	0, cr0, [sp, #-0]
 394:	3a0e0300 	bcc	380f9c <__bss_end+0x375664>
 398:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 39c:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 3a0:	000b320b 	andeq	r3, fp, fp, lsl #4
 3a4:	01151e00 	tsteq	r5, r0, lsl #28
 3a8:	13641349 	cmnne	r4, #603979777	; 0x24000001
 3ac:	00001301 	andeq	r1, r0, r1, lsl #6
 3b0:	1d001f1f 	stcne	15, cr1, [r0, #-124]	; 0xffffff84
 3b4:	00134913 	andseq	r4, r3, r3, lsl r9
 3b8:	00102000 	andseq	r2, r0, r0
 3bc:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 3c0:	0f210000 	svceq	0x00210000
 3c4:	000b0b00 	andeq	r0, fp, r0, lsl #22
 3c8:	012e2200 			; <UNDEFINED> instruction: 0x012e2200
 3cc:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 3d0:	0b3b0b3a 	bleq	ec30c0 <__bss_end+0xeb7788>
 3d4:	0e6e0b39 	vmoveq.8	d14[5], r0
 3d8:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 3dc:	00001364 	andeq	r1, r0, r4, ror #6
 3e0:	03002823 	movweq	r2, #2083	; 0x823
 3e4:	00051c0e 	andeq	r1, r5, lr, lsl #24
 3e8:	00282400 	eoreq	r2, r8, r0, lsl #8
 3ec:	061c0e03 	ldreq	r0, [ip], -r3, lsl #28
 3f0:	34250000 	strtcc	r0, [r5], #-0
 3f4:	3a0e0300 	bcc	380ffc <__bss_end+0x3756c4>
 3f8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 3fc:	3f13490b 	svccc	0x0013490b
 400:	00180219 	andseq	r0, r8, r9, lsl r2
 404:	00342600 	eorseq	r2, r4, r0, lsl #12
 408:	0b3a0e03 	bleq	e83c1c <__bss_end+0xe782e4>
 40c:	0b390b3b 	bleq	e43100 <__bss_end+0xe377c8>
 410:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 414:	34270000 	strtcc	r0, [r7], #-0
 418:	3a080300 	bcc	201020 <__bss_end+0x1f56e8>
 41c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 420:	3f13490b 	svccc	0x0013490b
 424:	00180219 	andseq	r0, r8, r9, lsl r2
 428:	002e2800 	eoreq	r2, lr, r0, lsl #16
 42c:	19340e03 	ldmdbne	r4!, {r0, r1, r9, sl, fp}
 430:	06120111 			; <UNDEFINED> instruction: 0x06120111
 434:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 438:	29000019 	stmdbcs	r0, {r0, r3, r4}
 43c:	0e03012e 	adfeqsp	f0, f3, #0.5
 440:	01111934 	tsteq	r1, r4, lsr r9
 444:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 448:	01194296 			; <UNDEFINED> instruction: 0x01194296
 44c:	2a000013 	bcs	4a0 <shift+0x4a0>
 450:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 454:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 458:	13490b39 	movtne	r0, #39737	; 0x9b39
 45c:	00001802 	andeq	r1, r0, r2, lsl #16
 460:	3f012e2b 	svccc	0x00012e2b
 464:	3a0e0319 	bcc	3810d0 <__bss_end+0x375798>
 468:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 46c:	1113490b 	tstne	r3, fp, lsl #18
 470:	40061201 	andmi	r1, r6, r1, lsl #4
 474:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 478:	00001301 	andeq	r1, r0, r1, lsl #6
 47c:	0300342c 	movweq	r3, #1068	; 0x42c
 480:	3b0b3a08 	blcc	2ceca8 <__bss_end+0x2c3370>
 484:	490b3905 	stmdbmi	fp, {r0, r2, r8, fp, ip, sp}
 488:	2d000013 	stccs	0, cr0, [r0, #-76]	; 0xffffffb4
 48c:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 490:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 494:	13490b39 	movtne	r0, #39737	; 0x9b39
 498:	00001802 	andeq	r1, r0, r2, lsl #16
 49c:	55010b2e 	strpl	r0, [r1, #-2862]	; 0xfffff4d2
 4a0:	2f000017 	svccs	0x00000017
 4a4:	08030034 	stmdaeq	r3, {r2, r4, r5}
 4a8:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 4ac:	13490b39 	movtne	r0, #39737	; 0x9b39
 4b0:	00001802 	andeq	r1, r0, r2, lsl #16
 4b4:	11010b30 	tstne	r1, r0, lsr fp
 4b8:	01061201 	tsteq	r6, r1, lsl #4
 4bc:	31000013 	tstcc	r0, r3, lsl r0
 4c0:	0111010b 	tsteq	r1, fp, lsl #2
 4c4:	00000612 	andeq	r0, r0, r2, lsl r6
 4c8:	3f012e32 	svccc	0x00012e32
 4cc:	3a0e0319 	bcc	381138 <__bss_end+0x375800>
 4d0:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 4d4:	110e6e0b 	tstne	lr, fp, lsl #28
 4d8:	40061201 	andmi	r1, r6, r1, lsl #4
 4dc:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 4e0:	00001301 	andeq	r1, r0, r1, lsl #6
 4e4:	3f012e33 	svccc	0x00012e33
 4e8:	3a0e0319 	bcc	381154 <__bss_end+0x37581c>
 4ec:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 4f0:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 4f4:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 4f8:	96184006 	ldrls	r4, [r8], -r6
 4fc:	13011942 	movwne	r1, #6466	; 0x1942
 500:	34340000 	ldrtcc	r0, [r4], #-0
 504:	3a0e0300 	bcc	38110c <__bss_end+0x3757d4>
 508:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 50c:	0013490b 	andseq	r4, r3, fp, lsl #18
 510:	00053500 	andeq	r3, r5, r0, lsl #10
 514:	0b3a0803 	bleq	e82528 <__bss_end+0xe76bf0>
 518:	0b39053b 	bleq	e41a0c <__bss_end+0xe360d4>
 51c:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 520:	2e360000 	cdpcs	0, 3, cr0, cr6, cr0, {0}
 524:	03193f01 	tsteq	r9, #1, 30
 528:	3b0b3a0e 	blcc	2ced68 <__bss_end+0x2c3430>
 52c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 530:	1113490e 	tstne	r3, lr, lsl #18
 534:	40061201 	andmi	r1, r6, r1, lsl #4
 538:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 53c:	00001301 	andeq	r1, r0, r1, lsl #6
 540:	03000537 	movweq	r0, #1335	; 0x537
 544:	3b0b3a08 	blcc	2ced6c <__bss_end+0x2c3434>
 548:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 54c:	00180213 	andseq	r0, r8, r3, lsl r2
 550:	00053800 	andeq	r3, r5, r0, lsl #16
 554:	0b3a0e03 	bleq	e83d68 <__bss_end+0xe78430>
 558:	0b390b3b 	bleq	e4324c <__bss_end+0xe37914>
 55c:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 560:	34390000 	ldrtcc	r0, [r9], #-0
 564:	3a080300 	bcc	20116c <__bss_end+0x1f5834>
 568:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 56c:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 570:	3a000018 	bcc	5d8 <shift+0x5d8>
 574:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 578:	0b3a0e03 	bleq	e83d8c <__bss_end+0xe78454>
 57c:	0b390b3b 	bleq	e43270 <__bss_end+0xe37938>
 580:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 584:	06120111 			; <UNDEFINED> instruction: 0x06120111
 588:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 58c:	00130119 	andseq	r0, r3, r9, lsl r1
 590:	012e3b00 			; <UNDEFINED> instruction: 0x012e3b00
 594:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 598:	0b3b0b3a 	bleq	ec3288 <__bss_end+0xeb7950>
 59c:	0e6e0b39 	vmoveq.8	d14[5], r0
 5a0:	06120111 			; <UNDEFINED> instruction: 0x06120111
 5a4:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 5a8:	00130119 	andseq	r0, r3, r9, lsl r1
 5ac:	012e3c00 			; <UNDEFINED> instruction: 0x012e3c00
 5b0:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 5b4:	0b3b0b3a 	bleq	ec32a4 <__bss_end+0xeb796c>
 5b8:	0e6e0b39 	vmoveq.8	d14[5], r0
 5bc:	06120111 			; <UNDEFINED> instruction: 0x06120111
 5c0:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 5c4:	00130119 	andseq	r0, r3, r9, lsl r1
 5c8:	012e3d00 			; <UNDEFINED> instruction: 0x012e3d00
 5cc:	0803193f 	stmdaeq	r3, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
 5d0:	0b3b0b3a 	bleq	ec32c0 <__bss_end+0xeb7988>
 5d4:	0e6e0b39 	vmoveq.8	d14[5], r0
 5d8:	01111349 	tsteq	r1, r9, asr #6
 5dc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 5e0:	00194297 	mulseq	r9, r7, r2
 5e4:	11010000 	mrsne	r0, (UNDEF: 1)
 5e8:	130e2501 	movwne	r2, #58625	; 0xe501
 5ec:	1b0e030b 	blne	381220 <__bss_end+0x3758e8>
 5f0:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 5f4:	00171006 	andseq	r1, r7, r6
 5f8:	00240200 	eoreq	r0, r4, r0, lsl #4
 5fc:	0b3e0b0b 	bleq	f83230 <__bss_end+0xf778f8>
 600:	00000e03 	andeq	r0, r0, r3, lsl #28
 604:	49002603 	stmdbmi	r0, {r0, r1, r9, sl, sp}
 608:	04000013 	streq	r0, [r0], #-19	; 0xffffffed
 60c:	0b0b0024 	bleq	2c06a4 <__bss_end+0x2b4d6c>
 610:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 614:	16050000 	strne	r0, [r5], -r0
 618:	3a0e0300 	bcc	381220 <__bss_end+0x3758e8>
 61c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 620:	0013490b 	andseq	r4, r3, fp, lsl #18
 624:	01130600 	tsteq	r3, r0, lsl #12
 628:	0b0b0e03 	bleq	2c3e3c <__bss_end+0x2b8504>
 62c:	0b3b0b3a 	bleq	ec331c <__bss_end+0xeb79e4>
 630:	13010b39 	movwne	r0, #6969	; 0x1b39
 634:	0d070000 	stceq	0, cr0, [r7, #-0]
 638:	3a080300 	bcc	201240 <__bss_end+0x1f5908>
 63c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 640:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 644:	0800000b 	stmdaeq	r0, {r0, r1, r3}
 648:	0e030104 	adfeqs	f0, f3, f4
 64c:	0b3e196d 	bleq	f86c08 <__bss_end+0xf7b2d0>
 650:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 654:	0b3b0b3a 	bleq	ec3344 <__bss_end+0xeb7a0c>
 658:	13010b39 	movwne	r0, #6969	; 0x1b39
 65c:	28090000 	stmdacs	r9, {}	; <UNPREDICTABLE>
 660:	1c080300 	stcne	3, cr0, [r8], {-0}
 664:	0a00000b 	beq	698 <shift+0x698>
 668:	0e030028 	cdpeq	0, 0, cr0, cr3, cr8, {1}
 66c:	00000b1c 	andeq	r0, r0, ip, lsl fp
 670:	0300340b 	movweq	r3, #1035	; 0x40b
 674:	3b0b3a0e 	blcc	2ceeb4 <__bss_end+0x2c357c>
 678:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 67c:	02196c13 	andseq	r6, r9, #4864	; 0x1300
 680:	0c000018 	stceq	0, cr0, [r0], {24}
 684:	0e030002 	cdpeq	0, 0, cr0, cr3, cr2, {0}
 688:	0000193c 	andeq	r1, r0, ip, lsr r9
 68c:	0301020d 	movweq	r0, #4621	; 0x120d
 690:	3a0b0b0e 	bcc	2c32d0 <__bss_end+0x2b7998>
 694:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 698:	0013010b 	andseq	r0, r3, fp, lsl #2
 69c:	000d0e00 	andeq	r0, sp, r0, lsl #28
 6a0:	0b3a0e03 	bleq	e83eb4 <__bss_end+0xe7857c>
 6a4:	0b390b3b 	bleq	e43398 <__bss_end+0xe37a60>
 6a8:	0b381349 	bleq	e053d4 <__bss_end+0xdf9a9c>
 6ac:	2e0f0000 	cdpcs	0, 0, cr0, cr15, cr0, {0}
 6b0:	03193f01 	tsteq	r9, #1, 30
 6b4:	3b0b3a0e 	blcc	2ceef4 <__bss_end+0x2c35bc>
 6b8:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 6bc:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
 6c0:	00136419 	andseq	r6, r3, r9, lsl r4
 6c4:	00051000 	andeq	r1, r5, r0
 6c8:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
 6cc:	05110000 	ldreq	r0, [r1, #-0]
 6d0:	00134900 	andseq	r4, r3, r0, lsl #18
 6d4:	000d1200 	andeq	r1, sp, r0, lsl #4
 6d8:	0b3a0e03 	bleq	e83eec <__bss_end+0xe785b4>
 6dc:	0b390b3b 	bleq	e433d0 <__bss_end+0xe37a98>
 6e0:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 6e4:	0000193c 	andeq	r1, r0, ip, lsr r9
 6e8:	3f012e13 	svccc	0x00012e13
 6ec:	3a0e0319 	bcc	381358 <__bss_end+0x375a20>
 6f0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 6f4:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 6f8:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 6fc:	01136419 	tsteq	r3, r9, lsl r4
 700:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
 704:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 708:	0b3a0e03 	bleq	e83f1c <__bss_end+0xe785e4>
 70c:	0b390b3b 	bleq	e43400 <__bss_end+0xe37ac8>
 710:	0b320e6e 	bleq	c840d0 <__bss_end+0xc78798>
 714:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 718:	00001301 	andeq	r1, r0, r1, lsl #6
 71c:	3f012e15 	svccc	0x00012e15
 720:	3a0e0319 	bcc	38138c <__bss_end+0x375a54>
 724:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 728:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 72c:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 730:	00136419 	andseq	r6, r3, r9, lsl r4
 734:	01011600 	tsteq	r1, r0, lsl #12
 738:	13011349 	movwne	r1, #4937	; 0x1349
 73c:	21170000 	tstcs	r7, r0
 740:	2f134900 	svccs	0x00134900
 744:	1800000b 	stmdane	r0, {r0, r1, r3}
 748:	0b0b000f 	bleq	2c078c <__bss_end+0x2b4e54>
 74c:	00001349 	andeq	r1, r0, r9, asr #6
 750:	00002119 	andeq	r2, r0, r9, lsl r1
 754:	00341a00 	eorseq	r1, r4, r0, lsl #20
 758:	0b3a0e03 	bleq	e83f6c <__bss_end+0xe78634>
 75c:	0b390b3b 	bleq	e43450 <__bss_end+0xe37b18>
 760:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 764:	0000193c 	andeq	r1, r0, ip, lsr r9
 768:	3f012e1b 	svccc	0x00012e1b
 76c:	3a0e0319 	bcc	3813d8 <__bss_end+0x375aa0>
 770:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 774:	3c0e6e0b 	stccc	14, cr6, [lr], {11}
 778:	01136419 	tsteq	r3, r9, lsl r4
 77c:	1c000013 	stcne	0, cr0, [r0], {19}
 780:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 784:	0b3a0e03 	bleq	e83f98 <__bss_end+0xe78660>
 788:	0b390b3b 	bleq	e4347c <__bss_end+0xe37b44>
 78c:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 790:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 794:	00001301 	andeq	r1, r0, r1, lsl #6
 798:	03000d1d 	movweq	r0, #3357	; 0xd1d
 79c:	3b0b3a0e 	blcc	2cefdc <__bss_end+0x2c36a4>
 7a0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 7a4:	320b3813 	andcc	r3, fp, #1245184	; 0x130000
 7a8:	1e00000b 	cdpne	0, 0, cr0, cr0, cr11, {0}
 7ac:	13490115 	movtne	r0, #37141	; 0x9115
 7b0:	13011364 	movwne	r1, #4964	; 0x1364
 7b4:	1f1f0000 	svcne	0x001f0000
 7b8:	49131d00 	ldmdbmi	r3, {r8, sl, fp, ip}
 7bc:	20000013 	andcs	r0, r0, r3, lsl r0
 7c0:	0b0b0010 	bleq	2c0808 <__bss_end+0x2b4ed0>
 7c4:	00001349 	andeq	r1, r0, r9, asr #6
 7c8:	0b000f21 	bleq	4454 <shift+0x4454>
 7cc:	2200000b 	andcs	r0, r0, #11
 7d0:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 7d4:	0b3b0b3a 	bleq	ec34c4 <__bss_end+0xeb7b8c>
 7d8:	13490b39 	movtne	r0, #39737	; 0x9b39
 7dc:	00001802 	andeq	r1, r0, r2, lsl #16
 7e0:	3f012e23 	svccc	0x00012e23
 7e4:	3a0e0319 	bcc	381450 <__bss_end+0x375b18>
 7e8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 7ec:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 7f0:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 7f4:	96184006 	ldrls	r4, [r8], -r6
 7f8:	13011942 	movwne	r1, #6466	; 0x1942
 7fc:	05240000 	streq	r0, [r4, #-0]!
 800:	3a0e0300 	bcc	381408 <__bss_end+0x375ad0>
 804:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 808:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 80c:	25000018 	strcs	r0, [r0, #-24]	; 0xffffffe8
 810:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 814:	0b3a0e03 	bleq	e84028 <__bss_end+0xe786f0>
 818:	0b390b3b 	bleq	e4350c <__bss_end+0xe37bd4>
 81c:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 820:	06120111 			; <UNDEFINED> instruction: 0x06120111
 824:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
 828:	00130119 	andseq	r0, r3, r9, lsl r1
 82c:	00342600 	eorseq	r2, r4, r0, lsl #12
 830:	0b3a0803 	bleq	e82844 <__bss_end+0xe76f0c>
 834:	0b390b3b 	bleq	e43528 <__bss_end+0xe37bf0>
 838:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 83c:	2e270000 	cdpcs	0, 2, cr0, cr7, cr0, {0}
 840:	03193f01 	tsteq	r9, #1, 30
 844:	3b0b3a0e 	blcc	2cf084 <__bss_end+0x2c374c>
 848:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 84c:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 850:	97184006 	ldrls	r4, [r8, -r6]
 854:	13011942 	movwne	r1, #6466	; 0x1942
 858:	2e280000 	cdpcs	0, 2, cr0, cr8, cr0, {0}
 85c:	03193f00 	tsteq	r9, #0, 30
 860:	3b0b3a0e 	blcc	2cf0a0 <__bss_end+0x2c3768>
 864:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 868:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 86c:	97184006 	ldrls	r4, [r8, -r6]
 870:	00001942 	andeq	r1, r0, r2, asr #18
 874:	3f012e29 	svccc	0x00012e29
 878:	3a0e0319 	bcc	3814e4 <__bss_end+0x375bac>
 87c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 880:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 884:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 888:	97184006 	ldrls	r4, [r8, -r6]
 88c:	00001942 	andeq	r1, r0, r2, asr #18
 890:	01110100 	tsteq	r1, r0, lsl #2
 894:	0b130e25 	bleq	4c4130 <__bss_end+0x4b87f8>
 898:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
 89c:	06120111 			; <UNDEFINED> instruction: 0x06120111
 8a0:	00001710 	andeq	r1, r0, r0, lsl r7
 8a4:	0b002402 	bleq	98b4 <main+0x24>
 8a8:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 8ac:	0300000e 	movweq	r0, #14
 8b0:	0b0b0024 	bleq	2c0948 <__bss_end+0x2b5010>
 8b4:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 8b8:	16040000 	strne	r0, [r4], -r0
 8bc:	3a0e0300 	bcc	3814c4 <__bss_end+0x375b8c>
 8c0:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 8c4:	0013490b 	andseq	r4, r3, fp, lsl #18
 8c8:	012e0500 			; <UNDEFINED> instruction: 0x012e0500
 8cc:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 8d0:	0b3b0b3a 	bleq	ec35c0 <__bss_end+0xeb7c88>
 8d4:	0e6e0b39 	vmoveq.8	d14[5], r0
 8d8:	01111349 	tsteq	r1, r9, asr #6
 8dc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 8e0:	01194297 			; <UNDEFINED> instruction: 0x01194297
 8e4:	06000013 			; <UNDEFINED> instruction: 0x06000013
 8e8:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 8ec:	0b3b0b3a 	bleq	ec35dc <__bss_end+0xeb7ca4>
 8f0:	13490b39 	movtne	r0, #39737	; 0x9b39
 8f4:	00001802 	andeq	r1, r0, r2, lsl #16
 8f8:	03003407 	movweq	r3, #1031	; 0x407
 8fc:	3b0b3a0e 	blcc	2cf13c <__bss_end+0x2c3804>
 900:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 904:	00180213 	andseq	r0, r8, r3, lsl r2
 908:	00340800 	eorseq	r0, r4, r0, lsl #16
 90c:	0b3a0803 	bleq	e82920 <__bss_end+0xe76fe8>
 910:	0b390b3b 	bleq	e43604 <__bss_end+0xe37ccc>
 914:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 918:	0f090000 	svceq	0x00090000
 91c:	000b0b00 	andeq	r0, fp, r0, lsl #22
 920:	11010000 	mrsne	r0, (UNDEF: 1)
 924:	130e2501 	movwne	r2, #58625	; 0xe501
 928:	1b0e030b 	blne	38155c <__bss_end+0x375c24>
 92c:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 930:	00171006 	andseq	r1, r7, r6
 934:	01390200 	teqeq	r9, r0, lsl #4
 938:	00001301 	andeq	r1, r0, r1, lsl #6
 93c:	03003403 	movweq	r3, #1027	; 0x403
 940:	3b0b3a0e 	blcc	2cf180 <__bss_end+0x2c3848>
 944:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 948:	1c193c13 	ldcne	12, cr3, [r9], {19}
 94c:	0400000a 	streq	r0, [r0], #-10
 950:	0b3a003a 	bleq	e80a40 <__bss_end+0xe75108>
 954:	0b390b3b 	bleq	e43648 <__bss_end+0xe37d10>
 958:	00001318 	andeq	r1, r0, r8, lsl r3
 95c:	49010105 	stmdbmi	r1, {r0, r2, r8}
 960:	00130113 	andseq	r0, r3, r3, lsl r1
 964:	00210600 	eoreq	r0, r1, r0, lsl #12
 968:	0b2f1349 	bleq	bc5694 <__bss_end+0xbb9d5c>
 96c:	26070000 	strcs	r0, [r7], -r0
 970:	00134900 	andseq	r4, r3, r0, lsl #18
 974:	00240800 	eoreq	r0, r4, r0, lsl #16
 978:	0b3e0b0b 	bleq	f835ac <__bss_end+0xf77c74>
 97c:	00000e03 	andeq	r0, r0, r3, lsl #28
 980:	47003409 	strmi	r3, [r0, -r9, lsl #8]
 984:	0a000013 	beq	9d8 <shift+0x9d8>
 988:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 98c:	0b3a0e03 	bleq	e841a0 <__bss_end+0xe78868>
 990:	0b390b3b 	bleq	e43684 <__bss_end+0xe37d4c>
 994:	01110e6e 	tsteq	r1, lr, ror #28
 998:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 99c:	01194297 			; <UNDEFINED> instruction: 0x01194297
 9a0:	0b000013 	bleq	9f4 <shift+0x9f4>
 9a4:	08030005 	stmdaeq	r3, {r0, r2}
 9a8:	0b3b0b3a 	bleq	ec3698 <__bss_end+0xeb7d60>
 9ac:	13490b39 	movtne	r0, #39737	; 0x9b39
 9b0:	00001802 	andeq	r1, r0, r2, lsl #16
 9b4:	0300340c 	movweq	r3, #1036	; 0x40c
 9b8:	3b0b3a0e 	blcc	2cf1f8 <__bss_end+0x2c38c0>
 9bc:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 9c0:	00180213 	andseq	r0, r8, r3, lsl r2
 9c4:	010b0d00 	tsteq	fp, r0, lsl #26
 9c8:	06120111 			; <UNDEFINED> instruction: 0x06120111
 9cc:	340e0000 	strcc	r0, [lr], #-0
 9d0:	3a080300 	bcc	2015d8 <__bss_end+0x1f5ca0>
 9d4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 9d8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 9dc:	0f000018 	svceq	0x00000018
 9e0:	0b0b000f 	bleq	2c0a24 <__bss_end+0x2b50ec>
 9e4:	00001349 	andeq	r1, r0, r9, asr #6
 9e8:	00002610 	andeq	r2, r0, r0, lsl r6
 9ec:	000f1100 	andeq	r1, pc, r0, lsl #2
 9f0:	00000b0b 	andeq	r0, r0, fp, lsl #22
 9f4:	0b002412 	bleq	9a44 <main+0x1b4>
 9f8:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 9fc:	13000008 	movwne	r0, #8
 a00:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 a04:	0b3b0b3a 	bleq	ec36f4 <__bss_end+0xeb7dbc>
 a08:	13490b39 	movtne	r0, #39737	; 0x9b39
 a0c:	00001802 	andeq	r1, r0, r2, lsl #16
 a10:	3f012e14 	svccc	0x00012e14
 a14:	3a0e0319 	bcc	381680 <__bss_end+0x375d48>
 a18:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 a1c:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 a20:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 a24:	97184006 	ldrls	r4, [r8, -r6]
 a28:	13011942 	movwne	r1, #6466	; 0x1942
 a2c:	2e150000 	cdpcs	0, 1, cr0, cr5, cr0, {0}
 a30:	03193f01 	tsteq	r9, #1, 30
 a34:	3b0b3a0e 	blcc	2cf274 <__bss_end+0x2c393c>
 a38:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 a3c:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 a40:	96184006 	ldrls	r4, [r8], -r6
 a44:	13011942 	movwne	r1, #6466	; 0x1942
 a48:	0b160000 	bleq	580a50 <__bss_end+0x575118>
 a4c:	12011101 	andne	r1, r1, #1073741824	; 0x40000000
 a50:	00130106 	andseq	r0, r3, r6, lsl #2
 a54:	012e1700 			; <UNDEFINED> instruction: 0x012e1700
 a58:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 a5c:	0b3b0b3a 	bleq	ec374c <__bss_end+0xeb7e14>
 a60:	0e6e0b39 	vmoveq.8	d14[5], r0
 a64:	06120111 			; <UNDEFINED> instruction: 0x06120111
 a68:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 a6c:	00000019 	andeq	r0, r0, r9, lsl r0
 a70:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 a74:	030b130e 	movweq	r1, #45838	; 0xb30e
 a78:	110e1b0e 	tstne	lr, lr, lsl #22
 a7c:	10061201 	andne	r1, r6, r1, lsl #4
 a80:	02000017 	andeq	r0, r0, #23
 a84:	0b0b0024 	bleq	2c0b1c <__bss_end+0x2b51e4>
 a88:	0e030b3e 	vmoveq.16	d3[0], r0
 a8c:	26030000 	strcs	r0, [r3], -r0
 a90:	00134900 	andseq	r4, r3, r0, lsl #18
 a94:	00240400 	eoreq	r0, r4, r0, lsl #8
 a98:	0b3e0b0b 	bleq	f836cc <__bss_end+0xf77d94>
 a9c:	00000803 	andeq	r0, r0, r3, lsl #16
 aa0:	03001605 	movweq	r1, #1541	; 0x605
 aa4:	3b0b3a0e 	blcc	2cf2e4 <__bss_end+0x2c39ac>
 aa8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 aac:	06000013 			; <UNDEFINED> instruction: 0x06000013
 ab0:	0e030102 	adfeqs	f0, f3, f2
 ab4:	0b3a0b0b 	bleq	e836e8 <__bss_end+0xe77db0>
 ab8:	0b390b3b 	bleq	e437ac <__bss_end+0xe37e74>
 abc:	00001301 	andeq	r1, r0, r1, lsl #6
 ac0:	03000d07 	movweq	r0, #3335	; 0xd07
 ac4:	3b0b3a0e 	blcc	2cf304 <__bss_end+0x2c39cc>
 ac8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 acc:	000b3813 	andeq	r3, fp, r3, lsl r8
 ad0:	012e0800 			; <UNDEFINED> instruction: 0x012e0800
 ad4:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 ad8:	0b3b0b3a 	bleq	ec37c8 <__bss_end+0xeb7e90>
 adc:	0e6e0b39 	vmoveq.8	d14[5], r0
 ae0:	0b321349 	bleq	c8580c <__bss_end+0xc79ed4>
 ae4:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 ae8:	00001301 	andeq	r1, r0, r1, lsl #6
 aec:	49000509 	stmdbmi	r0, {r0, r3, r8, sl}
 af0:	00193413 	andseq	r3, r9, r3, lsl r4
 af4:	00050a00 	andeq	r0, r5, r0, lsl #20
 af8:	00001349 	andeq	r1, r0, r9, asr #6
 afc:	3f012e0b 	svccc	0x00012e0b
 b00:	3a0e0319 	bcc	38176c <__bss_end+0x375e34>
 b04:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 b08:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
 b0c:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 b10:	00130113 	andseq	r0, r3, r3, lsl r1
 b14:	012e0c00 			; <UNDEFINED> instruction: 0x012e0c00
 b18:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 b1c:	0b3b0b3a 	bleq	ec380c <__bss_end+0xeb7ed4>
 b20:	0e6e0b39 	vmoveq.8	d14[5], r0
 b24:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 b28:	00001364 	andeq	r1, r0, r4, ror #6
 b2c:	4901010d 	stmdbmi	r1, {r0, r2, r3, r8}
 b30:	00130113 	andseq	r0, r3, r3, lsl r1
 b34:	00210e00 	eoreq	r0, r1, r0, lsl #28
 b38:	0b2f1349 	bleq	bc5864 <__bss_end+0xbb9f2c>
 b3c:	0f0f0000 	svceq	0x000f0000
 b40:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 b44:	10000013 	andne	r0, r0, r3, lsl r0
 b48:	0803000d 	stmdaeq	r3, {r0, r2, r3}
 b4c:	0b3b0b3a 	bleq	ec383c <__bss_end+0xeb7f04>
 b50:	13490b39 	movtne	r0, #39737	; 0x9b39
 b54:	00000b38 	andeq	r0, r0, r8, lsr fp
 b58:	3f012e11 	svccc	0x00012e11
 b5c:	3a0e0319 	bcc	3817c8 <__bss_end+0x375e90>
 b60:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 b64:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 b68:	3c0b3213 	sfmcc	f3, 4, [fp], {19}
 b6c:	00136419 	andseq	r6, r3, r9, lsl r4
 b70:	01131200 	tsteq	r3, r0, lsl #4
 b74:	0b0b0e03 	bleq	2c4388 <__bss_end+0x2b8a50>
 b78:	0b3b0b3a 	bleq	ec3868 <__bss_end+0xeb7f30>
 b7c:	13010b39 	movwne	r0, #6969	; 0x1b39
 b80:	04130000 	ldreq	r0, [r3], #-0
 b84:	6d0e0301 	stcvs	3, cr0, [lr, #-4]
 b88:	0b0b3e19 	bleq	2d03f4 <__bss_end+0x2c4abc>
 b8c:	3a13490b 	bcc	4d2fc0 <__bss_end+0x4c7688>
 b90:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 b94:	0013010b 	andseq	r0, r3, fp, lsl #2
 b98:	00281400 	eoreq	r1, r8, r0, lsl #8
 b9c:	0b1c0e03 	bleq	7043b0 <__bss_end+0x6f8a78>
 ba0:	34150000 	ldrcc	r0, [r5], #-0
 ba4:	3a0e0300 	bcc	3817ac <__bss_end+0x375e74>
 ba8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 bac:	6c13490b 			; <UNDEFINED> instruction: 0x6c13490b
 bb0:	00180219 	andseq	r0, r8, r9, lsl r2
 bb4:	00021600 	andeq	r1, r2, r0, lsl #12
 bb8:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
 bbc:	2e170000 	cdpcs	0, 1, cr0, cr7, cr0, {0}
 bc0:	03193f01 	tsteq	r9, #1, 30
 bc4:	3b0b3a0e 	blcc	2cf404 <__bss_end+0x2c3acc>
 bc8:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 bcc:	3c13490e 			; <UNDEFINED> instruction: 0x3c13490e
 bd0:	00136419 	andseq	r6, r3, r9, lsl r4
 bd4:	000d1800 	andeq	r1, sp, r0, lsl #16
 bd8:	0b3a0e03 	bleq	e843ec <__bss_end+0xe78ab4>
 bdc:	0b390b3b 	bleq	e438d0 <__bss_end+0xe37f98>
 be0:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 be4:	0000193c 	andeq	r1, r0, ip, lsr r9
 be8:	00002119 	andeq	r2, r0, r9, lsl r1
 bec:	00341a00 	eorseq	r1, r4, r0, lsl #20
 bf0:	0b3a0e03 	bleq	e84404 <__bss_end+0xe78acc>
 bf4:	0b390b3b 	bleq	e438e8 <__bss_end+0xe37fb0>
 bf8:	193f1349 	ldmdbne	pc!, {r0, r3, r6, r8, r9, ip}	; <UNPREDICTABLE>
 bfc:	0000193c 	andeq	r1, r0, ip, lsr r9
 c00:	0300281b 	movweq	r2, #2075	; 0x81b
 c04:	000b1c08 	andeq	r1, fp, r8, lsl #24
 c08:	012e1c00 			; <UNDEFINED> instruction: 0x012e1c00
 c0c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 c10:	0b3b0b3a 	bleq	ec3900 <__bss_end+0xeb7fc8>
 c14:	0e6e0b39 	vmoveq.8	d14[5], r0
 c18:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 c1c:	00001301 	andeq	r1, r0, r1, lsl #6
 c20:	3f012e1d 	svccc	0x00012e1d
 c24:	3a0e0319 	bcc	381890 <__bss_end+0x375f58>
 c28:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 c2c:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 c30:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
 c34:	00130113 	andseq	r0, r3, r3, lsl r1
 c38:	000d1e00 	andeq	r1, sp, r0, lsl #28
 c3c:	0b3a0e03 	bleq	e84450 <__bss_end+0xe78b18>
 c40:	0b390b3b 	bleq	e43934 <__bss_end+0xe37ffc>
 c44:	0b381349 	bleq	e05970 <__bss_end+0xdfa038>
 c48:	00000b32 	andeq	r0, r0, r2, lsr fp
 c4c:	4901151f 	stmdbmi	r1, {r0, r1, r2, r3, r4, r8, sl, ip}
 c50:	01136413 	tsteq	r3, r3, lsl r4
 c54:	20000013 	andcs	r0, r0, r3, lsl r0
 c58:	131d001f 	tstne	sp, #31
 c5c:	00001349 	andeq	r1, r0, r9, asr #6
 c60:	0b001021 	bleq	4cec <shift+0x4cec>
 c64:	0013490b 	andseq	r4, r3, fp, lsl #18
 c68:	000f2200 	andeq	r2, pc, r0, lsl #4
 c6c:	00000b0b 	andeq	r0, r0, fp, lsl #22
 c70:	47012e23 	strmi	r2, [r1, -r3, lsr #28]
 c74:	3b0b3a13 	blcc	2cf4c8 <__bss_end+0x2c3b90>
 c78:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
 c7c:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 c80:	96184006 	ldrls	r4, [r8], -r6
 c84:	13011942 	movwne	r1, #6466	; 0x1942
 c88:	05240000 	streq	r0, [r4, #-0]!
 c8c:	490e0300 	stmdbmi	lr, {r8, r9}
 c90:	02193413 	andseq	r3, r9, #318767104	; 0x13000000
 c94:	25000018 	strcs	r0, [r0, #-24]	; 0xffffffe8
 c98:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 c9c:	0b3b0b3a 	bleq	ec398c <__bss_end+0xeb8054>
 ca0:	13490b39 	movtne	r0, #39737	; 0x9b39
 ca4:	00001802 	andeq	r1, r0, r2, lsl #16
 ca8:	03003426 	movweq	r3, #1062	; 0x426
 cac:	3b0b3a0e 	blcc	2cf4ec <__bss_end+0x2c3bb4>
 cb0:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 cb4:	00180213 	andseq	r0, r8, r3, lsl r2
 cb8:	010b2700 	tsteq	fp, r0, lsl #14
 cbc:	06120111 			; <UNDEFINED> instruction: 0x06120111
 cc0:	34280000 	strtcc	r0, [r8], #-0
 cc4:	3a080300 	bcc	2018cc <__bss_end+0x1f5f94>
 cc8:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 ccc:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 cd0:	29000018 	stmdbcs	r0, {r3, r4}
 cd4:	1347012e 	movtne	r0, #28974	; 0x712e
 cd8:	0b3b0b3a 	bleq	ec39c8 <__bss_end+0xeb8090>
 cdc:	13640b39 	cmnne	r4, #58368	; 0xe400
 ce0:	13010b20 	movwne	r0, #6944	; 0x1b20
 ce4:	052a0000 	streq	r0, [sl, #-0]!
 ce8:	490e0300 	stmdbmi	lr, {r8, r9}
 cec:	00193413 	andseq	r3, r9, r3, lsl r4
 cf0:	012e2b00 			; <UNDEFINED> instruction: 0x012e2b00
 cf4:	0e6e1331 	mcreq	3, 3, r1, cr14, cr1, {1}
 cf8:	01111364 	tsteq	r1, r4, ror #6
 cfc:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 d00:	00194296 	mulseq	r9, r6, r2
 d04:	00052c00 	andeq	r2, r5, r0, lsl #24
 d08:	18021331 	stmdane	r2, {r0, r4, r5, r8, r9, ip}
 d0c:	01000000 	mrseq	r0, (UNDEF: 0)
 d10:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 d14:	0e030b13 	vmoveq.32	d3[0], r0
 d18:	01110e1b 	tsteq	r1, fp, lsl lr
 d1c:	17100612 			; <UNDEFINED> instruction: 0x17100612
 d20:	24020000 	strcs	r0, [r2], #-0
 d24:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 d28:	000e030b 	andeq	r0, lr, fp, lsl #6
 d2c:	00240300 	eoreq	r0, r4, r0, lsl #6
 d30:	0b3e0b0b 	bleq	f83964 <__bss_end+0xf7802c>
 d34:	00000803 	andeq	r0, r0, r3, lsl #16
 d38:	03001604 	movweq	r1, #1540	; 0x604
 d3c:	3b0b3a0e 	blcc	2cf57c <__bss_end+0x2c3c44>
 d40:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 d44:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
 d48:	0e030102 	adfeqs	f0, f3, f2
 d4c:	0b3a0b0b 	bleq	e83980 <__bss_end+0xe78048>
 d50:	0b390b3b 	bleq	e43a44 <__bss_end+0xe3810c>
 d54:	00001301 	andeq	r1, r0, r1, lsl #6
 d58:	03000d06 	movweq	r0, #3334	; 0xd06
 d5c:	3b0b3a0e 	blcc	2cf59c <__bss_end+0x2c3c64>
 d60:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 d64:	000b3813 	andeq	r3, fp, r3, lsl r8
 d68:	012e0700 			; <UNDEFINED> instruction: 0x012e0700
 d6c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 d70:	0b3b0b3a 	bleq	ec3a60 <__bss_end+0xeb8128>
 d74:	0e6e0b39 	vmoveq.8	d14[5], r0
 d78:	0b321349 	bleq	c85aa4 <__bss_end+0xc7a16c>
 d7c:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 d80:	00001301 	andeq	r1, r0, r1, lsl #6
 d84:	49000508 	stmdbmi	r0, {r3, r8, sl}
 d88:	00193413 	andseq	r3, r9, r3, lsl r4
 d8c:	00050900 	andeq	r0, r5, r0, lsl #18
 d90:	00001349 	andeq	r1, r0, r9, asr #6
 d94:	3f012e0a 	svccc	0x00012e0a
 d98:	3a0e0319 	bcc	381a04 <__bss_end+0x3760cc>
 d9c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 da0:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
 da4:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 da8:	00130113 	andseq	r0, r3, r3, lsl r1
 dac:	012e0b00 			; <UNDEFINED> instruction: 0x012e0b00
 db0:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 db4:	0b3b0b3a 	bleq	ec3aa4 <__bss_end+0xeb816c>
 db8:	0e6e0b39 	vmoveq.8	d14[5], r0
 dbc:	193c0b32 	ldmdbne	ip!, {r1, r4, r5, r8, r9, fp}
 dc0:	00001364 	andeq	r1, r0, r4, ror #6
 dc4:	4901010c 	stmdbmi	r1, {r2, r3, r8}
 dc8:	00130113 	andseq	r0, r3, r3, lsl r1
 dcc:	00210d00 	eoreq	r0, r1, r0, lsl #26
 dd0:	0b2f1349 	bleq	bc5afc <__bss_end+0xbba1c4>
 dd4:	0f0e0000 	svceq	0x000e0000
 dd8:	490b0b00 	stmdbmi	fp, {r8, r9, fp}
 ddc:	0f000013 	svceq	0x00000013
 de0:	13490026 	movtne	r0, #36902	; 0x9026
 de4:	2e100000 	cdpcs	0, 1, cr0, cr0, cr0, {0}
 de8:	3a134701 	bcc	4d29f4 <__bss_end+0x4c70bc>
 dec:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 df0:	1113640b 	tstne	r3, fp, lsl #8
 df4:	40061201 	andmi	r1, r6, r1, lsl #4
 df8:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 dfc:	00001301 	andeq	r1, r0, r1, lsl #6
 e00:	03000511 	movweq	r0, #1297	; 0x511
 e04:	3413490e 	ldrcc	r4, [r3], #-2318	; 0xfffff6f2
 e08:	00180219 	andseq	r0, r8, r9, lsl r2
 e0c:	00051200 	andeq	r1, r5, r0, lsl #4
 e10:	0b3a0e03 	bleq	e84624 <__bss_end+0xe78cec>
 e14:	0b390b3b 	bleq	e43b08 <__bss_end+0xe381d0>
 e18:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 e1c:	05130000 	ldreq	r0, [r3, #-0]
 e20:	3a080300 	bcc	201a28 <__bss_end+0x1f60f0>
 e24:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 e28:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 e2c:	14000018 	strne	r0, [r0], #-24	; 0xffffffe8
 e30:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
 e34:	0b3b0b3a 	bleq	ec3b24 <__bss_end+0xeb81ec>
 e38:	13490b39 	movtne	r0, #39737	; 0x9b39
 e3c:	00001802 	andeq	r1, r0, r2, lsl #16
 e40:	47012e15 	smladmi	r1, r5, lr, r2
 e44:	3b0b3a13 	blcc	2cf698 <__bss_end+0x2c3d60>
 e48:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
 e4c:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 e50:	97184006 	ldrls	r4, [r8, -r6]
 e54:	13011942 	movwne	r1, #6466	; 0x1942
 e58:	0b160000 	bleq	580e60 <__bss_end+0x575528>
 e5c:	12011101 	andne	r1, r1, #1073741824	; 0x40000000
 e60:	17000006 	strne	r0, [r0, -r6]
 e64:	08030034 	stmdaeq	r3, {r2, r4, r5}
 e68:	0b3b0b3a 	bleq	ec3b58 <__bss_end+0xeb8220>
 e6c:	13490b39 	movtne	r0, #39737	; 0x9b39
 e70:	00001802 	andeq	r1, r0, r2, lsl #16
 e74:	47012e18 	smladmi	r1, r8, lr, r2
 e78:	3b0b3a13 	blcc	2cf6cc <__bss_end+0x2c3d94>
 e7c:	640b390b 	strvs	r3, [fp], #-2315	; 0xfffff6f5
 e80:	010b2013 	tsteq	fp, r3, lsl r0
 e84:	19000013 	stmdbne	r0, {r0, r1, r4}
 e88:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 e8c:	19341349 	ldmdbne	r4!, {r0, r3, r6, r8, r9, ip}
 e90:	2e1a0000 	cdpcs	0, 1, cr0, cr10, cr0, {0}
 e94:	6e133101 	mufvss	f3, f3, f1
 e98:	1113640e 	tstne	r3, lr, lsl #8
 e9c:	40061201 	andmi	r1, r6, r1, lsl #4
 ea0:	19429618 	stmdbne	r2, {r3, r4, r9, sl, ip, pc}^
 ea4:	051b0000 	ldreq	r0, [fp, #-0]
 ea8:	02133100 	andseq	r3, r3, #0, 2
 eac:	00000018 	andeq	r0, r0, r8, lsl r0
 eb0:	10001101 	andne	r1, r0, r1, lsl #2
 eb4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
 eb8:	1b0e0301 	blne	381ac4 <__bss_end+0x37618c>
 ebc:	130e250e 	movwne	r2, #58638	; 0xe50e
 ec0:	00000005 	andeq	r0, r0, r5
 ec4:	10001101 	andne	r1, r0, r1, lsl #2
 ec8:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
 ecc:	1b0e0301 	blne	381ad8 <__bss_end+0x3761a0>
 ed0:	130e250e 	movwne	r2, #58638	; 0xe50e
 ed4:	00000005 	andeq	r0, r0, r5
 ed8:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 edc:	030b130e 	movweq	r1, #45838	; 0xb30e
 ee0:	100e1b0e 	andne	r1, lr, lr, lsl #22
 ee4:	02000017 	andeq	r0, r0, #23
 ee8:	0b0b0024 	bleq	2c0f80 <__bss_end+0x2b5648>
 eec:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 ef0:	24030000 	strcs	r0, [r3], #-0
 ef4:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 ef8:	000e030b 	andeq	r0, lr, fp, lsl #6
 efc:	00160400 	andseq	r0, r6, r0, lsl #8
 f00:	0b3a0e03 	bleq	e84714 <__bss_end+0xe78ddc>
 f04:	0b390b3b 	bleq	e43bf8 <__bss_end+0xe382c0>
 f08:	00001349 	andeq	r1, r0, r9, asr #6
 f0c:	0b000f05 	bleq	4b28 <shift+0x4b28>
 f10:	0013490b 	andseq	r4, r3, fp, lsl #18
 f14:	01150600 	tsteq	r5, r0, lsl #12
 f18:	13491927 	movtne	r1, #39207	; 0x9927
 f1c:	00001301 	andeq	r1, r0, r1, lsl #6
 f20:	49000507 	stmdbmi	r0, {r0, r1, r2, r8, sl}
 f24:	08000013 	stmdaeq	r0, {r0, r1, r4}
 f28:	00000026 	andeq	r0, r0, r6, lsr #32
 f2c:	03003409 	movweq	r3, #1033	; 0x409
 f30:	3b0b3a0e 	blcc	2cf770 <__bss_end+0x2c3e38>
 f34:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 f38:	3c193f13 	ldccc	15, cr3, [r9], {19}
 f3c:	0a000019 	beq	fa8 <shift+0xfa8>
 f40:	0e030104 	adfeqs	f0, f3, f4
 f44:	0b0b0b3e 	bleq	2c3c44 <__bss_end+0x2b830c>
 f48:	0b3a1349 	bleq	e85c74 <__bss_end+0xe7a33c>
 f4c:	0b390b3b 	bleq	e43c40 <__bss_end+0xe38308>
 f50:	00001301 	andeq	r1, r0, r1, lsl #6
 f54:	0300280b 	movweq	r2, #2059	; 0x80b
 f58:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 f5c:	01010c00 	tsteq	r1, r0, lsl #24
 f60:	13011349 	movwne	r1, #4937	; 0x1349
 f64:	210d0000 	mrscs	r0, (UNDEF: 13)
 f68:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
 f6c:	13490026 	movtne	r0, #36902	; 0x9026
 f70:	340f0000 	strcc	r0, [pc], #-0	; f78 <shift+0xf78>
 f74:	3a0e0300 	bcc	381b7c <__bss_end+0x376244>
 f78:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 f7c:	3f13490b 	svccc	0x0013490b
 f80:	00193c19 	andseq	r3, r9, r9, lsl ip
 f84:	00131000 	andseq	r1, r3, r0
 f88:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
 f8c:	15110000 	ldrne	r0, [r1, #-0]
 f90:	00192700 	andseq	r2, r9, r0, lsl #14
 f94:	00171200 	andseq	r1, r7, r0, lsl #4
 f98:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
 f9c:	13130000 	tstne	r3, #0
 fa0:	0b0e0301 	bleq	381bac <__bss_end+0x376274>
 fa4:	3b0b3a0b 	blcc	2cf7d8 <__bss_end+0x2c3ea0>
 fa8:	010b3905 	tsteq	fp, r5, lsl #18
 fac:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
 fb0:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 fb4:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 fb8:	13490b39 	movtne	r0, #39737	; 0x9b39
 fbc:	00000b38 	andeq	r0, r0, r8, lsr fp
 fc0:	49002115 	stmdbmi	r0, {r0, r2, r4, r8, sp}
 fc4:	000b2f13 	andeq	r2, fp, r3, lsl pc
 fc8:	01041600 	tsteq	r4, r0, lsl #12
 fcc:	0b3e0e03 	bleq	f847e0 <__bss_end+0xf78ea8>
 fd0:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 fd4:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 fd8:	13010b39 	movwne	r0, #6969	; 0x1b39
 fdc:	34170000 	ldrcc	r0, [r7], #-0
 fe0:	3a134700 	bcc	4d2be8 <__bss_end+0x4c72b0>
 fe4:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 fe8:	0018020b 	andseq	r0, r8, fp, lsl #4
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
  34:	0000009c 	muleq	r0, ip, r0
	...
  40:	0000001c 	andeq	r0, r0, ip, lsl r0
  44:	00ce0002 	sbceq	r0, lr, r2
  48:	00040000 	andeq	r0, r4, r0
  4c:	00000000 	andeq	r0, r0, r0
  50:	000080a4 	andeq	r8, r0, r4, lsr #1
  54:	00000188 	andeq	r0, r0, r8, lsl #3
	...
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	02d40002 	sbcseq	r0, r4, #2
  68:	00040000 	andeq	r0, r4, r0
  6c:	00000000 	andeq	r0, r0, r0
  70:	00008230 	andeq	r8, r0, r0, lsr r2
  74:	00001930 	andeq	r1, r0, r0, lsr r9
	...
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	18aa0002 	stmiane	sl!, {r1}
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	00009b60 	andeq	r9, r0, r0, ror #22
  94:	0000045c 	andeq	r0, r0, ip, asr r4
	...
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	260b0002 	strcs	r0, [fp], -r2
  a8:	00040000 	andeq	r0, r4, r0
  ac:	00000000 	andeq	r0, r0, r0
  b0:	00009fbc 			; <UNDEFINED> instruction: 0x00009fbc
  b4:	00000040 	andeq	r0, r0, r0, asr #32
	...
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	26b50002 	ldrtcs	r0, [r5], r2
  c8:	00040000 	andeq	r0, r4, r0
  cc:	00000000 	andeq	r0, r0, r0
  d0:	0000a000 	andeq	sl, r0, r0
  d4:	00000b40 	andeq	r0, r0, r0, asr #22
	...
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	2bb10002 	blcs	fec400f4 <__bss_end+0xfec347bc>
  e8:	00040000 	andeq	r0, r4, r0
  ec:	00000000 	andeq	r0, r0, r0
  f0:	0000ab40 	andeq	sl, r0, r0, asr #22
  f4:	0000016c 	andeq	r0, r0, ip, ror #2
	...
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	36a30002 	strtcc	r0, [r3], r2
 108:	00040000 	andeq	r0, r4, r0
 10c:	00000000 	andeq	r0, r0, r0
 110:	0000acac 	andeq	sl, r0, ip, lsr #25
 114:	000002ec 	andeq	r0, r0, ip, ror #5
	...
 120:	0000001c 	andeq	r0, r0, ip, lsl r0
 124:	39fc0002 	ldmibcc	ip!, {r1}^
 128:	00040000 	andeq	r0, r4, r0
 12c:	00000000 	andeq	r0, r0, r0
 130:	0000af98 	muleq	r0, r8, pc	; <UNPREDICTABLE>
 134:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
 140:	0000001c 	andeq	r0, r0, ip, lsl r0
 144:	3a220002 	bcc	880154 <__bss_end+0x87481c>
 148:	00040000 	andeq	r0, r4, r0
 14c:	00000000 	andeq	r0, r0, r0
 150:	0000b1a4 	andeq	fp, r0, r4, lsr #3
 154:	00000004 	andeq	r0, r0, r4
	...
 160:	00000014 	andeq	r0, r0, r4, lsl r0
 164:	3a480002 	bcc	1200174 <__bss_end+0x11f483c>
 168:	00040000 	andeq	r0, r4, r0
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffff4c <__bss_end+0xffff4614>
       4:	63732f65 	cmnvs	r3, #404	; 0x194
       8:	6b6e6568 	blvs	1b995b0 <__bss_end+0x1b8dc78>
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
      48:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffd21 <__bss_end+0xffff43e9>
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
      84:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffd5d <__bss_end+0xffff4425>
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
     17c:	5f007472 	svcpl	0x00007472
     180:	7472635f 	ldrbtvc	r6, [r2], #-863	; 0xfffffca1
     184:	75725f30 	ldrbvc	r5, [r2, #-3888]!	; 0xfffff0d0
     188:	5f5f006e 	svcpl	0x005f006e
     18c:	72617567 	rsbvc	r7, r1, #432013312	; 0x19c00000
     190:	5f5f0064 	svcpl	0x005f0064
     194:	62616561 	rsbvs	r6, r1, #406847488	; 0x18400000
     198:	6e755f69 	cdpvs	15, 7, cr5, cr5, cr9, {3}
     19c:	646e6977 	strbtvs	r6, [lr], #-2423	; 0xfffff689
     1a0:	7070635f 	rsbsvc	r6, r0, pc, asr r3
     1a4:	3172705f 	cmncc	r2, pc, asr r0
     1a8:	70635f00 	rsbvc	r5, r3, r0, lsl #30
     1ac:	68735f70 	ldmdavs	r3!, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     1b0:	6f647475 	svcvs	0x00647475
     1b4:	66006e77 			; <UNDEFINED> instruction: 0x66006e77
     1b8:	7274706e 	rsbsvc	r7, r4, #110	; 0x6e
     1bc:	635f5f00 	cmpvs	pc, #0, 30
     1c0:	62617878 	rsbvs	r7, r1, #120, 16	; 0x780000
     1c4:	00317669 	eorseq	r7, r1, r9, ror #12
     1c8:	78635f5f 	stmdavc	r3!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, fp, ip, lr}^
     1cc:	75705f61 	ldrbvc	r5, [r0, #-3937]!	; 0xfffff09f
     1d0:	765f6572 			; <UNDEFINED> instruction: 0x765f6572
     1d4:	75747269 	ldrbvc	r7, [r4, #-617]!	; 0xfffffd97
     1d8:	5f006c61 	svcpl	0x00006c61
     1dc:	6178635f 	cmnvs	r8, pc, asr r3
     1e0:	6175675f 	cmnvs	r5, pc, asr r7
     1e4:	725f6472 	subsvc	r6, pc, #1912602624	; 0x72000000
     1e8:	61656c65 	cmnvs	r5, r5, ror #24
     1ec:	2f006573 	svccs	0x00006573
     1f0:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     1f4:	6863732f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, sp, lr}^
     1f8:	6a6b6e65 	bvs	1adbb94 <__bss_end+0x1ad025c>
     1fc:	32736f2f 	rsbscc	r6, r3, #47, 30	; 0xbc
     200:	2f323230 	svccs	0x00323230
     204:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
     208:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     20c:	752f7365 	strvc	r7, [pc, #-869]!	; fffffeaf <__bss_end+0xffff4577>
     210:	73726573 	cmnvc	r2, #482344960	; 0x1cc00000
     214:	65636170 	strbvs	r6, [r3, #-368]!	; 0xfffffe90
     218:	7878632f 	ldmdavc	r8!, {r0, r1, r2, r3, r5, r8, r9, sp, lr}^
     21c:	2e696261 	cdpcs	2, 6, cr6, cr9, cr1, {3}
     220:	00707063 	rsbseq	r7, r0, r3, rrx
     224:	73645f5f 	cmnvc	r4, #380	; 0x17c
     228:	61685f6f 	cmnvs	r8, pc, ror #30
     22c:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     230:	445f5f00 	ldrbmi	r5, [pc], #-3840	; 238 <shift+0x238>
     234:	5f524f54 	svcpl	0x00524f54
     238:	5453494c 	ldrbpl	r4, [r3], #-2380	; 0xfffff6b4
     23c:	47005f5f 	smlsdmi	r0, pc, pc, r5	; <UNPREDICTABLE>
     240:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
     244:	34312b2b 	ldrtcc	r2, [r1], #-2859	; 0xfffff4d5
     248:	322e3920 	eorcc	r3, lr, #32, 18	; 0x80000
     24c:	3220312e 	eorcc	r3, r0, #-2147483637	; 0x8000000b
     250:	31393130 	teqcc	r9, r0, lsr r1
     254:	20353230 	eorscs	r3, r5, r0, lsr r2
     258:	6c657228 	sfmvs	f7, 2, [r5], #-160	; 0xffffff60
     25c:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
     260:	415b2029 	cmpmi	fp, r9, lsr #32
     264:	612f4d52 			; <UNDEFINED> instruction: 0x612f4d52
     268:	392d6d72 	pushcc	{r1, r4, r5, r6, r8, sl, fp, sp, lr}
     26c:	6172622d 	cmnvs	r2, sp, lsr #4
     270:	2068636e 	rsbcs	r6, r8, lr, ror #6
     274:	69766572 	ldmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     278:	6e6f6973 			; <UNDEFINED> instruction: 0x6e6f6973
     27c:	37373220 	ldrcc	r3, [r7, -r0, lsr #4]!
     280:	5d393935 			; <UNDEFINED> instruction: 0x5d393935
     284:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
     288:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
     28c:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
     290:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
     294:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
     298:	3d757066 	ldclcc	0, cr7, [r5, #-408]!	; 0xfffffe68
     29c:	20706676 	rsbscs	r6, r0, r6, ror r6
     2a0:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
     2a4:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
     2a8:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
     2ac:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
     2b0:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
     2b4:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
     2b8:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
     2bc:	6e75746d 	cdpvs	4, 7, cr7, cr5, cr13, {3}
     2c0:	72613d65 	rsbvc	r3, r1, #6464	; 0x1940
     2c4:	3731316d 	ldrcc	r3, [r1, -sp, ror #2]!
     2c8:	667a6a36 			; <UNDEFINED> instruction: 0x667a6a36
     2cc:	2d20732d 	stccs	3, cr7, [r0, #-180]!	; 0xffffff4c
     2d0:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
     2d4:	616d2d20 	cmnvs	sp, r0, lsr #26
     2d8:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
     2dc:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
     2e0:	2b6b7a36 	blcs	1adebc0 <__bss_end+0x1ad3288>
     2e4:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
     2e8:	672d2067 	strvs	r2, [sp, -r7, rrx]!
     2ec:	304f2d20 	subcc	r2, pc, r0, lsr #26
     2f0:	304f2d20 	subcc	r2, pc, r0, lsr #26
     2f4:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
     2f8:	78652d6f 	stmdavc	r5!, {r0, r1, r2, r3, r5, r6, r8, sl, fp, sp}^
     2fc:	74706563 	ldrbtvc	r6, [r0], #-1379	; 0xfffffa9d
     300:	736e6f69 	cmnvc	lr, #420	; 0x1a4
     304:	6e662d20 	cdpvs	13, 6, cr2, cr6, cr0, {1}
     308:	74722d6f 	ldrbtvc	r2, [r2], #-3439	; 0xfffff291
     30c:	5f006974 	svcpl	0x00006974
     310:	6178635f 	cmnvs	r8, pc, asr r3
     314:	6175675f 	cmnvs	r5, pc, asr r7
     318:	615f6472 	cmpvs	pc, r2, ror r4	; <UNPREDICTABLE>
     31c:	74726f62 	ldrbtvc	r6, [r2], #-3938	; 0xfffff09e
     320:	6f746400 	svcvs	0x00746400
     324:	74705f72 	ldrbtvc	r5, [r0], #-3954	; 0xfffff08e
     328:	5f5f0072 	svcpl	0x005f0072
     32c:	524f5444 	subpl	r5, pc, #68, 8	; 0x44000000
     330:	444e455f 	strbmi	r4, [lr], #-1375	; 0xfffffaa1
     334:	5f005f5f 	svcpl	0x00005f5f
     338:	6178635f 	cmnvs	r8, pc, asr r3
     33c:	6574615f 	ldrbvs	r6, [r4, #-351]!	; 0xfffffea1
     340:	00746978 	rsbseq	r6, r4, r8, ror r9
     344:	54435f5f 	strbpl	r5, [r3], #-3935	; 0xfffff0a1
     348:	455f524f 	ldrbmi	r5, [pc, #-591]	; 101 <shift+0x101>
     34c:	5f5f444e 	svcpl	0x005f444e
     350:	6e6f6c00 	cdpvs	12, 6, cr6, cr15, cr0, {0}
     354:	6f6c2067 	svcvs	0x006c2067
     358:	6920676e 	stmdbvs	r0!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}
     35c:	5f00746e 	svcpl	0x0000746e
     360:	5f707063 	svcpl	0x00707063
     364:	72617473 	rsbvc	r7, r1, #1929379840	; 0x73000000
     368:	00707574 	rsbseq	r7, r0, r4, ror r5
     36c:	54435f5f 	strbpl	r5, [r3], #-3935	; 0xfffff0a1
     370:	4c5f524f 	lfmmi	f5, 2, [pc], {79}	; 0x4f
     374:	5f545349 	svcpl	0x00545349
     378:	7463005f 	strbtvc	r0, [r3], #-95	; 0xffffffa1
     37c:	705f726f 	subsvc	r7, pc, pc, ror #4
     380:	5f007274 	svcpl	0x00007274
     384:	6178635f 	cmnvs	r8, pc, asr r3
     388:	6175675f 	cmnvs	r5, pc, asr r7
     38c:	615f6472 	cmpvs	pc, r2, ror r4	; <UNPREDICTABLE>
     390:	69757163 	ldmdbvs	r5!, {r0, r1, r5, r6, r8, ip, sp, lr}^
     394:	5f006572 	svcpl	0x00006572
     398:	35314e5a 	ldrcc	r4, [r1, #-3674]!	; 0xfffff1a6
     39c:	63726943 	cmnvs	r2, #1097728	; 0x10c000
     3a0:	72616c75 	rsbvc	r6, r1, #29952	; 0x7500
     3a4:	6675425f 			; <UNDEFINED> instruction: 0x6675425f
     3a8:	39726566 	ldmdbcc	r2!, {r1, r2, r5, r6, r8, sl, sp, lr}^
     3ac:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
     3b0:	69746e55 	ldmdbvs	r4!, {r0, r2, r4, r6, r9, sl, fp, sp, lr}^
     3b4:	5063456c 	rsbpl	r4, r3, ip, ror #10
     3b8:	52420063 	subpl	r0, r2, #99	; 0x63
     3bc:	3637355f 			; <UNDEFINED> instruction: 0x3637355f
     3c0:	67003030 	smladxvs	r0, r0, r0, r3
     3c4:	73496e65 	movtvc	r6, #40549	; 0x9e65
     3c8:	6e656700 	cdpvs	7, 6, cr6, cr5, cr0, {0}
     3cc:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
     3d0:	456e6f69 	strbmi	r6, [lr, #-3945]!	; 0xfffff097
     3d4:	63695400 	cmnvs	r9, #0, 8
     3d8:	6f435f6b 	svcvs	0x00435f6b
     3dc:	00746e75 	rsbseq	r6, r4, r5, ror lr
     3e0:	65646e49 	strbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     3e4:	696e6966 	stmdbvs	lr!, {r1, r2, r5, r6, r8, fp, sp, lr}^
     3e8:	6e006574 	cfrshl64vs	mvdx0, mvdx4, r6
     3ec:	5f747865 	svcpl	0x00747865
     3f0:	61684379 	smcvs	33849	; 0x8439
     3f4:	704f0072 	subvc	r0, pc, r2, ror r0	; <UNPREDICTABLE>
     3f8:	4e006e65 	cdpmi	14, 0, cr6, cr0, cr5, {3}
     3fc:	54524155 	ldrbpl	r4, [r2], #-341	; 0xfffffeab
     400:	6168435f 	cmnvs	r8, pc, asr r3
     404:	654c5f72 	strbvs	r5, [ip, #-3954]	; 0xfffff08e
     408:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
     40c:	45525000 	ldrbmi	r5, [r2, #-0]
     410:	52420044 	subpl	r0, r2, #68	; 0x44
     414:	3034325f 	eorscc	r3, r4, pc, asr r2
     418:	72700030 	rsbsvc	r0, r0, #48	; 0x30
     41c:	5f007665 	svcpl	0x00007665
     420:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     424:	6f725043 	svcvs	0x00725043
     428:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     42c:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     430:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     434:	6f4e3431 	svcvs	0x004e3431
     438:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     43c:	6f72505f 	svcvs	0x0072505f
     440:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     444:	32315045 	eorscc	r5, r1, #69	; 0x45
     448:	73615454 	cmnvc	r1, #84, 8	; 0x54000000
     44c:	74535f6b 	ldrbvc	r5, [r3], #-3947	; 0xfffff095
     450:	74637572 	strbtvc	r7, [r3], #-1394	; 0xfffffa8e
     454:	646c6f00 	strbtvs	r6, [ip], #-3840	; 0xfffff100
     458:	5a5f0059 	bpl	17c05c4 <__bss_end+0x17b4c8c>
     45c:	756f6337 	strbvc	r6, [pc, #-823]!	; 12d <shift+0x12d>
     460:	625f746e 	subsvs	r7, pc, #1845493760	; 0x6e000000
     464:	66666666 	strbtvs	r6, [r6], -r6, ror #12
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
     498:	4f525000 	svcmi	0x00525000
     49c:	49424142 	stmdbmi	r2, {r1, r6, r8, lr}^
     4a0:	5954494c 	ldmdbpl	r4, {r2, r3, r6, r8, fp, lr}^
     4a4:	5f464f5f 	svcpl	0x00464f5f
     4a8:	4154554d 	cmpmi	r4, sp, asr #10
     4ac:	5f4e4f49 	svcpl	0x004e4f49
     4b0:	43524550 	cmpmi	r2, #80, 10	; 0x14000000
     4b4:	00544e45 	subseq	r4, r4, r5, asr #28
     4b8:	616d6e55 	cmnvs	sp, r5, asr lr
     4bc:	69465f70 	stmdbvs	r6, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     4c0:	435f656c 	cmpmi	pc, #108, 10	; 0x1b000000
     4c4:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     4c8:	7500746e 	strvc	r7, [r0, #-1134]	; 0xfffffb92
     4cc:	46747261 	ldrbtmi	r7, [r4], -r1, ror #4
     4d0:	00656c69 	rsbeq	r6, r5, r9, ror #24
     4d4:	314e5a5f 	cmpcc	lr, pc, asr sl
     4d8:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     4dc:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     4e0:	614d5f73 	hvcvs	54771	; 0xd5f3
     4e4:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     4e8:	48383172 	ldmdami	r8!, {r1, r4, r5, r6, r8, ip, sp}
     4ec:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     4f0:	72505f65 	subsvc	r5, r0, #404	; 0x194
     4f4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     4f8:	57535f73 			; <UNDEFINED> instruction: 0x57535f73
     4fc:	30324549 	eorscc	r4, r2, r9, asr #10
     500:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
     504:	6f72505f 	svcvs	0x0072505f
     508:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     50c:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
     510:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     514:	526a6a6a 	rsbpl	r6, sl, #434176	; 0x6a000
     518:	53543131 	cmppl	r4, #1073741836	; 0x4000000c
     51c:	525f4957 	subspl	r4, pc, #1425408	; 0x15c000
     520:	6c757365 	ldclvs	3, cr7, [r5], #-404	; 0xfffffe6c
     524:	65680074 	strbvs	r0, [r8, #-116]!	; 0xffffff8c
     528:	68507061 	ldmdavs	r0, {r0, r5, r6, ip, sp, lr}^
     52c:	63697379 	cmnvs	r9, #-469762047	; 0xe4000001
     530:	694c6c61 	stmdbvs	ip, {r0, r5, r6, sl, fp, sp, lr}^
     534:	0074696d 	rsbseq	r6, r4, sp, ror #18
     538:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
     53c:	6974555f 	ldmdbvs	r4!, {r0, r1, r2, r3, r4, r6, r8, sl, ip, lr}^
     540:	6d00736c 	stcvs	3, cr7, [r0, #-432]	; 0xfffffe50
     544:	636f7250 	cmnvs	pc, #80, 4
     548:	5f737365 	svcpl	0x00737365
     54c:	7473694c 	ldrbtvc	r6, [r3], #-2380	; 0xfffff6b4
     550:	6165485f 	cmnvs	r5, pc, asr r8
     554:	6f630064 	svcvs	0x00630064
     558:	6c6f736e 	stclvs	3, cr7, [pc], #-440	; 3a8 <shift+0x3a8>
     55c:	6e695f65 	cdpvs	15, 6, cr5, cr9, cr5, {3}
     560:	75616200 	strbvc	r6, [r1, #-512]!	; 0xfffffe00
     564:	61725f64 	cmnvs	r2, r4, ror #30
     568:	5f006574 	svcpl	0x00006574
     56c:	314b4e5a 	cmpcc	fp, sl, asr lr
     570:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     574:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     578:	614d5f73 	hvcvs	54771	; 0xd5f3
     57c:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     580:	47393172 			; <UNDEFINED> instruction: 0x47393172
     584:	435f7465 	cmpmi	pc, #1694498816	; 0x65000000
     588:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     58c:	505f746e 	subspl	r7, pc, lr, ror #8
     590:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     594:	76457373 			; <UNDEFINED> instruction: 0x76457373
     598:	6c617600 	stclvs	6, cr7, [r1], #-0
     59c:	00736575 	rsbseq	r6, r3, r5, ror r5
     5a0:	31706d74 	cmncc	r0, r4, ror sp
     5a4:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     5a8:	65523031 	ldrbvs	r3, [r2, #-49]	; 0xffffffcf
     5ac:	555f6461 	ldrbpl	r6, [pc, #-1121]	; 153 <shift+0x153>
     5b0:	736c6974 	cmnvc	ip, #116, 18	; 0x1d0000
     5b4:	76453443 	strbvc	r3, [r5], -r3, asr #8
     5b8:	5f524200 	svcpl	0x00524200
     5bc:	30303834 	eorscc	r3, r0, r4, lsr r8
     5c0:	706d7400 	rsbvc	r7, sp, r0, lsl #8
     5c4:	006e6547 	rsbeq	r6, lr, r7, asr #10
     5c8:	314e5a5f 	cmpcc	lr, pc, asr sl
     5cc:	72694335 	rsbvc	r4, r9, #-738197504	; 0xd4000000
     5d0:	616c7563 	cmnvs	ip, r3, ror #10
     5d4:	75425f72 	strbvc	r5, [r2, #-3954]	; 0xfffff08e
     5d8:	72656666 	rsbvc	r6, r5, #106954752	; 0x6600000
     5dc:	61657234 	cmnvs	r5, r4, lsr r2
     5e0:	63504564 	cmpvs	r0, #100, 10	; 0x19000000
     5e4:	6d74006a 	ldclvs	0, cr0, [r4, #-424]!	; 0xfffffe58
     5e8:	6e003370 	mcrvs	3, 0, r3, cr0, cr0, {3}
     5ec:	5f747865 	svcpl	0x00747865
     5f0:	656e0079 	strbvs	r0, [lr, #-121]!	; 0xffffff87
     5f4:	74007478 	strvc	r7, [r0], #-1144	; 0xfffffb88
     5f8:	0032706d 	eorseq	r7, r2, sp, rrx
     5fc:	5f746547 	svcpl	0x00746547
     600:	636f7250 	cmnvs	pc, #80, 4
     604:	5f737365 	svcpl	0x00737365
     608:	505f7942 	subspl	r7, pc, r2, asr #18
     60c:	6d004449 	cfstrsvs	mvf4, [r0, #-292]	; 0xfffffedc
     610:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     614:	6e696f50 	mcrvs	15, 3, r6, cr9, cr0, {2}
     618:	6d740074 	ldclvs	0, cr0, [r4, #-464]!	; 0xfffffe30
     61c:	69003470 	stmdbvs	r0, {r4, r5, r6, sl, ip, sp}
     620:	72694473 	rsbvc	r4, r9, #1929379840	; 0x73000000
     624:	6f746365 	svcvs	0x00746365
     628:	67007972 	smlsdxvs	r0, r2, r9, r7
     62c:	72656e65 	rsbvc	r6, r5, #1616	; 0x650
     630:	6f697461 	svcvs	0x00697461
     634:	4e00416e 	adfmisz	f4, f0, #0.5
     638:	5f495753 	svcpl	0x00495753
     63c:	636f7250 	cmnvs	pc, #80, 4
     640:	5f737365 	svcpl	0x00737365
     644:	76726553 			; <UNDEFINED> instruction: 0x76726553
     648:	00656369 	rsbeq	r6, r5, r9, ror #6
     64c:	656e6567 	strbvs	r6, [lr, #-1383]!	; 0xfffffa99
     650:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
     654:	00436e6f 	subeq	r6, r3, pc, ror #28
     658:	656e6567 	strbvs	r6, [lr, #-1383]!	; 0xfffffa99
     65c:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
     660:	00446e6f 	subeq	r6, r4, pc, ror #28
     664:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
     668:	65686300 	strbvs	r6, [r8, #-768]!	; 0xfffffd00
     66c:	705f6b63 	subsvc	r6, pc, r3, ror #22
     670:	6d617261 	sfmvs	f7, 2, [r1, #-388]!	; 0xfffffe7c
     674:	74634100 	strbtvc	r4, [r3], #-256	; 0xffffff00
     678:	5f657669 	svcpl	0x00657669
     67c:	636f7250 	cmnvs	pc, #80, 4
     680:	5f737365 	svcpl	0x00737365
     684:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
     688:	6f630074 	svcvs	0x00630074
     68c:	5f746e75 	svcpl	0x00746e75
     690:	72430062 	subvc	r0, r3, #98	; 0x62
     694:	65746165 	ldrbvs	r6, [r4, #-357]!	; 0xfffffe9b
     698:	6f72505f 	svcvs	0x0072505f
     69c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     6a0:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
     6a4:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
     6a8:	79547470 	ldmdbvc	r4, {r4, r5, r6, sl, ip, sp, lr}^
     6ac:	62006570 	andvs	r6, r0, #112, 10	; 0x1c000000
     6b0:	49747365 	ldmdbmi	r4!, {r0, r2, r5, r6, r8, r9, ip, sp, lr}^
     6b4:	7865646e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, sp, lr}^
     6b8:	735f5f00 	cmpvc	pc, #0, 30
     6bc:	69746174 	ldmdbvs	r4!, {r2, r4, r5, r6, r8, sp, lr}^
     6c0:	6e695f63 	cdpvs	15, 6, cr5, cr9, cr3, {3}
     6c4:	61697469 	cmnvs	r9, r9, ror #8
     6c8:	617a696c 	cmnvs	sl, ip, ror #18
     6cc:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     6d0:	646e615f 	strbtvs	r6, [lr], #-351	; 0xfffffea1
     6d4:	7365645f 	cmnvc	r5, #1593835520	; 0x5f000000
     6d8:	63757274 	cmnvs	r5, #116, 4	; 0x40000007
     6dc:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     6e0:	6200305f 	andvs	r3, r0, #95	; 0x5f
     6e4:	43747365 	cmnmi	r4, #-1811939327	; 0x94000001
     6e8:	00726168 	rsbseq	r6, r2, r8, ror #2
     6ec:	65726170 	ldrbvs	r6, [r2, #-368]!	; 0xfffffe90
     6f0:	4d00746e 	cfstrsmi	mvf7, [r0, #-440]	; 0xfffffe48
     6f4:	69467861 	stmdbvs	r6, {r0, r5, r6, fp, ip, sp, lr}^
     6f8:	616e656c 	cmnvs	lr, ip, ror #10
     6fc:	654c656d 	strbvs	r6, [ip, #-1389]	; 0xfffffa93
     700:	6874676e 	ldmdavs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, sp, lr}^
     704:	315a5f00 	cmpcc	sl, r0, lsl #30
     708:	61657230 	cmnvs	r5, r0, lsr r2
     70c:	6e695f64 	cdpvs	15, 6, cr5, cr9, cr4, {3}
     710:	76747570 			; <UNDEFINED> instruction: 0x76747570
     714:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     718:	69433531 	stmdbvs	r3, {r0, r4, r5, r8, sl, ip, sp}^
     71c:	6c756372 	ldclvs	3, cr6, [r5], #-456	; 0xfffffe38
     720:	425f7261 	subsmi	r7, pc, #268435462	; 0x10000006
     724:	65666675 	strbvs	r6, [r6, #-1653]!	; 0xfffff98b
     728:	65723472 	ldrbvs	r3, [r2, #-1138]!	; 0xfffffb8e
     72c:	50456461 	subpl	r6, r5, r1, ror #8
     730:	5a5f0063 	bpl	17c08c4 <__bss_end+0x17b4f8c>
     734:	5230314e 	eorspl	r3, r0, #-2147483629	; 0x80000013
     738:	5f646165 	svcpl	0x00646165
     73c:	6c697455 	cfstrdvs	mvd7, [r9], #-340	; 0xfffffeac
     740:	65723873 	ldrbvs	r3, [r2, #-2163]!	; 0xfffff78d
     744:	694c6461 	stmdbvs	ip, {r0, r5, r6, sl, sp, lr}^
     748:	5045656e 	subpl	r6, r5, lr, ror #10
     74c:	00626a63 	rsbeq	r6, r2, r3, ror #20
     750:	5f746547 	svcpl	0x00746547
     754:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     758:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     75c:	6e495f72 	mcrvs	15, 2, r5, cr9, cr2, {3}
     760:	44006f66 	strmi	r6, [r0], #-3942	; 0xfffff09a
     764:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     768:	5f656e69 	svcpl	0x00656e69
     76c:	68636e55 	stmdavs	r3!, {r0, r2, r4, r6, r9, sl, fp, sp, lr}^
     770:	65676e61 	strbvs	r6, [r7, #-3681]!	; 0xfffff19f
     774:	50430064 	subpl	r0, r3, r4, rrx
     778:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     77c:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 5b8 <shift+0x5b8>
     780:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     784:	5f007265 	svcpl	0x00007265
     788:	31314e5a 	teqcc	r1, sl, asr lr
     78c:	6c694643 	stclvs	6, cr4, [r9], #-268	; 0xfffffef4
     790:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     794:	436d6574 	cmnmi	sp, #116, 10	; 0x1d000000
     798:	00764534 	rsbseq	r4, r6, r4, lsr r5
     79c:	5f534654 	svcpl	0x00534654
     7a0:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     7a4:	5f007265 	svcpl	0x00007265
     7a8:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     7ac:	6f725043 	svcvs	0x00725043
     7b0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     7b4:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     7b8:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     7bc:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
     7c0:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     7c4:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     7c8:	5f72656c 	svcpl	0x0072656c
     7cc:	6f666e49 	svcvs	0x00666e49
     7d0:	4e303245 	cdpmi	2, 3, cr3, cr0, cr5, {2}
     7d4:	5f746547 	svcpl	0x00746547
     7d8:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     7dc:	6e495f64 	cdpvs	15, 4, cr5, cr9, cr4, {3}
     7e0:	545f6f66 	ldrbpl	r6, [pc], #-3942	; 7e8 <shift+0x7e8>
     7e4:	50657079 	rsbpl	r7, r5, r9, ror r0
     7e8:	5a5f0076 	bpl	17c09c8 <__bss_end+0x17b5090>
     7ec:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     7f0:	636f7250 	cmnvs	pc, #80, 4
     7f4:	5f737365 	svcpl	0x00737365
     7f8:	616e614d 	cmnvs	lr, sp, asr #2
     7fc:	32726567 	rsbscc	r6, r2, #432013312	; 0x19c00000
     800:	6e614831 	mcrvs	8, 3, r4, cr1, cr1, {1}
     804:	5f656c64 	svcpl	0x00656c64
     808:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     80c:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     810:	535f6d65 	cmppl	pc, #6464	; 0x1940
     814:	32454957 	subcc	r4, r5, #1425408	; 0x15c000
     818:	57534e33 	smmlarpl	r3, r3, lr, r4
     81c:	69465f49 	stmdbvs	r6, {r0, r3, r6, r8, r9, sl, fp, ip, lr}^
     820:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     824:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     828:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
     82c:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     830:	526a6a6a 	rsbpl	r6, sl, #434176	; 0x6a000
     834:	53543131 	cmppl	r4, #1073741836	; 0x4000000c
     838:	525f4957 	subspl	r4, pc, #1425408	; 0x15c000
     83c:	6c757365 	ldclvs	3, cr7, [r5], #-404	; 0xfffffe6c
     840:	706f0074 	rsbvc	r0, pc, r4, ror r0	; <UNPREDICTABLE>
     844:	64656e65 	strbtvs	r6, [r5], #-3685	; 0xfffff19b
     848:	6c69665f 	stclvs	6, cr6, [r9], #-380	; 0xfffffe84
     84c:	4e007365 	cdpmi	3, 0, cr7, cr0, cr5, {3}
     850:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     854:	6c6c4179 	stfvse	f4, [ip], #-484	; 0xfffffe1c
     858:	50435400 	subpl	r5, r3, r0, lsl #8
     85c:	6f435f55 	svcvs	0x00435f55
     860:	7865746e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, ip, sp, lr}^
     864:	65440074 	strbvs	r0, [r4, #-116]	; 0xffffff8c
     868:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
     86c:	6700656e 	strvs	r6, [r0, -lr, ror #10]
     870:	795f7465 	ldmdbvc	pc, {r0, r2, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
     874:	62747400 	rsbsvs	r7, r4, #0, 8
     878:	5f003072 	svcpl	0x00003072
     87c:	6331315a 	teqvs	r1, #-2147483626	; 0x80000016
     880:	6b636568 	blvs	18d9e28 <__bss_end+0x18ce4f0>
     884:	7261705f 	rsbvc	r7, r1, #95	; 0x5f
     888:	63506d61 	cmpvs	r0, #6208	; 0x1840
     88c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     890:	50433631 	subpl	r3, r3, r1, lsr r6
     894:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     898:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 6d4 <shift+0x6d4>
     89c:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     8a0:	34317265 	ldrtcc	r7, [r1], #-613	; 0xfffffd9b
     8a4:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     8a8:	505f7966 	subspl	r7, pc, r6, ror #18
     8ac:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     8b0:	6a457373 	bvs	115d684 <__bss_end+0x1151d4c>
     8b4:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     8b8:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
     8bc:	6e694600 	cdpvs	6, 6, cr4, cr9, cr0, {0}
     8c0:	68435f64 	stmdavs	r3, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     8c4:	00646c69 	rsbeq	r6, r4, r9, ror #24
     8c8:	5f746567 	svcpl	0x00746567
     8cc:	6e746966 	vsubvs.f16	s13, s8, s13	; <UNPREDICTABLE>
     8d0:	00737365 	rsbseq	r7, r3, r5, ror #6
     8d4:	69746f6e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     8d8:	64656966 	strbtvs	r6, [r5], #-2406	; 0xfffff69a
     8dc:	6165645f 	cmnvs	r5, pc, asr r4
     8e0:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     8e4:	5f5f0065 	svcpl	0x005f0065
     8e8:	74696e69 	strbtvc	r6, [r9], #-3689	; 0xfffff197
     8ec:	696c6169 	stmdbvs	ip!, {r0, r3, r5, r6, r8, sp, lr}^
     8f0:	705f657a 	subsvc	r6, pc, sl, ror r5	; <UNPREDICTABLE>
     8f4:	41554e00 	cmpmi	r5, r0, lsl #28
     8f8:	425f5452 	subsmi	r5, pc, #1375731712	; 0x52000000
     8fc:	5f647561 	svcpl	0x00647561
     900:	65746152 	ldrbvs	r6, [r4, #-338]!	; 0xfffffeae
     904:	61684300 	cmnvs	r8, r0, lsl #6
     908:	00375f72 	eorseq	r5, r7, r2, ror pc
     90c:	72616843 	rsbvc	r6, r1, #4390912	; 0x430000
     910:	5f00385f 	svcpl	0x0000385f
     914:	6567335a 	strbvs	r3, [r7, #-858]!	; 0xfffffca6
     918:	0069696e 	rsbeq	r6, r9, lr, ror #18
     91c:	5f78614d 	svcpl	0x0078614d
     920:	636f7250 	cmnvs	pc, #80, 4
     924:	5f737365 	svcpl	0x00737365
     928:	6e65704f 	cdpvs	0, 6, cr7, cr5, cr15, {2}
     92c:	465f6465 	ldrbmi	r6, [pc], -r5, ror #8
     930:	73656c69 	cmnvc	r5, #26880	; 0x6900
     934:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     938:	50433631 	subpl	r3, r3, r1, lsr r6
     93c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     940:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 77c <shift+0x77c>
     944:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     948:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     94c:	616d6e55 	cmnvs	sp, r5, asr lr
     950:	69465f70 	stmdbvs	r6, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     954:	435f656c 	cmpmi	pc, #108, 10	; 0x1b000000
     958:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     95c:	6a45746e 	bvs	115db1c <__bss_end+0x11521e4>
     960:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
     964:	5a5f0059 	bpl	17c0ad0 <__bss_end+0x17b5198>
     968:	74656734 	strbtvc	r6, [r5], #-1844	; 0xfffff8cc
     96c:	66666959 			; <UNDEFINED> instruction: 0x66666959
     970:	62006650 	andvs	r6, r0, #80, 12	; 0x5000000
     974:	6b636f6c 	blvs	18dc72c <__bss_end+0x18d0df4>
     978:	53466700 	movtpl	r6, #26368	; 0x6700
     97c:	6972445f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, sl, lr}^
     980:	73726576 	cmnvc	r2, #494927872	; 0x1d800000
     984:	756f435f 	strbvc	r4, [pc, #-863]!	; 62d <shift+0x62d>
     988:	7400746e 	strvc	r7, [r0], #-1134	; 0xfffffb92
     98c:	68736572 	ldmdavs	r3!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     990:	00646c6f 	rsbeq	r6, r4, pc, ror #24
     994:	6f6f526d 	svcvs	0x006f526d
     998:	79535f74 	ldmdbvc	r3, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     99c:	65470073 	strbvs	r0, [r7, #-115]	; 0xffffff8d
     9a0:	75435f74 	strbvc	r5, [r3, #-3956]	; 0xfffff08c
     9a4:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     9a8:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     9ac:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     9b0:	475f0073 			; <UNDEFINED> instruction: 0x475f0073
     9b4:	41424f4c 	cmpmi	r2, ip, asr #30
     9b8:	735f5f4c 	cmpvc	pc, #76, 30	; 0x130
     9bc:	495f6275 	ldmdbmi	pc, {r0, r2, r4, r5, r6, r9, sp, lr}^	; <UNPREDICTABLE>
     9c0:	4c45445f 	cfstrdmi	mvd4, [r5], {95}	; 0x5f
     9c4:	72004154 	andvc	r4, r0, #84, 2
     9c8:	5f646165 	svcpl	0x00646165
     9cc:	61726170 	cmnvs	r2, r0, ror r1
     9d0:	614d006d 	cmpvs	sp, sp, rrx
     9d4:	69465f70 	stmdbvs	r6, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     9d8:	545f656c 	ldrbpl	r6, [pc], #-1388	; 9e0 <shift+0x9e0>
     9dc:	75435f6f 	strbvc	r5, [r3, #-3951]	; 0xfffff091
     9e0:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     9e4:	6e720074 	mrcvs	0, 3, r0, cr2, cr4, {3}
     9e8:	61765f64 	cmnvs	r6, r4, ror #30
     9ec:	0065756c 	rsbeq	r7, r5, ip, ror #10
     9f0:	63656863 	cmnvs	r5, #6488064	; 0x630000
     9f4:	726f466b 	rsbvc	r4, pc, #112197632	; 0x6b00000
     9f8:	706f7453 	rsbvc	r7, pc, r3, asr r4	; <UNPREDICTABLE>
     9fc:	466f4e00 	strbtmi	r4, [pc], -r0, lsl #28
     a00:	73656c69 	cmnvc	r5, #26880	; 0x6900
     a04:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     a08:	6972446d 	ldmdbvs	r2!, {r0, r2, r3, r5, r6, sl, lr}^
     a0c:	00726576 	rsbseq	r6, r2, r6, ror r5
     a10:	5f746553 	svcpl	0x00746553
     a14:	61726150 	cmnvs	r2, r0, asr r1
     a18:	5f00736d 	svcpl	0x0000736d
     a1c:	6567385a 	strbvs	r3, [r7, #-2138]!	; 0xfffff7a6
     a20:	69735f74 	ldmdbvs	r3!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     a24:	6350657a 	cmpvs	r0, #511705088	; 0x1e800000
     a28:	6e614800 	cdpvs	8, 6, cr4, cr1, cr0, {0}
     a2c:	5f656c64 	svcpl	0x00656c64
     a30:	636f7250 	cmnvs	pc, #80, 4
     a34:	5f737365 	svcpl	0x00737365
     a38:	00495753 	subeq	r5, r9, r3, asr r7
     a3c:	726f6873 	rsbvc	r6, pc, #7536640	; 0x730000
     a40:	6e752074 	mrcvs	0, 3, r2, cr5, cr4, {3}
     a44:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
     a48:	69206465 	stmdbvs	r0!, {r0, r2, r5, r6, sl, sp, lr}
     a4c:	5300746e 	movwpl	r7, #1134	; 0x46e
     a50:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     a54:	5f656c75 	svcpl	0x00656c75
     a58:	00464445 	subeq	r4, r6, r5, asr #8
     a5c:	74696157 	strbtvc	r6, [r9], #-343	; 0xfffffea9
     a60:	73694400 	cmnvc	r9, #0, 8
     a64:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     a68:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     a6c:	445f746e 	ldrbmi	r7, [pc], #-1134	; a74 <shift+0xa74>
     a70:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     a74:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     a78:	315a5f00 	cmpcc	sl, r0, lsl #30
     a7c:	74656731 	strbtvc	r6, [r5], #-1841	; 0xfffff8cf
     a80:	7469665f 	strbtvc	r6, [r9], #-1631	; 0xfffff9a1
     a84:	7373656e 	cmnvc	r3, #461373440	; 0x1b800000
     a88:	5f006650 	svcpl	0x00006650
     a8c:	31314e5a 	teqcc	r1, sl, asr lr
     a90:	6c694643 	stclvs	6, cr4, [r9], #-268	; 0xfffffef4
     a94:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     a98:	316d6574 	smccc	54868	; 0xd654
     a9c:	696e4930 	stmdbvs	lr!, {r4, r5, r8, fp, lr}^
     aa0:	6c616974 			; <UNDEFINED> instruction: 0x6c616974
     aa4:	45657a69 	strbmi	r7, [r5, #-2665]!	; 0xfffff597
     aa8:	6e490076 	mcrvs	0, 2, r0, cr9, cr6, {3}
     aac:	72726574 	rsbsvc	r6, r2, #116, 10	; 0x1d000000
     ab0:	61747075 	cmnvs	r4, r5, ror r0
     ab4:	5f656c62 	svcpl	0x00656c62
     ab8:	65656c53 	strbvs	r6, [r5, #-3155]!	; 0xfffff3ad
     abc:	526d0070 	rsbpl	r0, sp, #112	; 0x70
     ac0:	5f746f6f 	svcpl	0x00746f6f
     ac4:	00766544 	rsbseq	r6, r6, r4, asr #10
     ac8:	6c6f6f62 	stclvs	15, cr6, [pc], #-392	; 948 <shift+0x948>
     acc:	6c656400 	cfstrdvs	mvd6, [r5], #-0
     ad0:	68436174 	stmdavs	r3, {r2, r4, r5, r6, r8, sp, lr}^
     ad4:	77007261 	strvc	r7, [r0, -r1, ror #4]
     ad8:	656c6f68 	strbvs	r6, [ip, #-3944]!	; 0xfffff098
     adc:	614c6d00 	cmpvs	ip, r0, lsl #26
     ae0:	505f7473 	subspl	r7, pc, r3, ror r4	; <UNPREDICTABLE>
     ae4:	42004449 	andmi	r4, r0, #1224736768	; 0x49000000
     ae8:	6b636f6c 	blvs	18dc8a0 <__bss_end+0x18d0f68>
     aec:	4e006465 	cdpmi	4, 0, cr6, cr0, cr5, {3}
     af0:	5f746547 	svcpl	0x00746547
     af4:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     af8:	6e495f64 	cdpvs	15, 4, cr5, cr9, cr4, {3}
     afc:	545f6f66 	ldrbpl	r6, [pc], #-3942	; b04 <shift+0xb04>
     b00:	00657079 	rsbeq	r7, r5, r9, ror r0
     b04:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
     b08:	706e695f 	rsbvc	r6, lr, pc, asr r9
     b0c:	52007475 	andpl	r7, r0, #1962934272	; 0x75000000
     b10:	616e6e75 	smcvs	59109	; 0xe6e5
     b14:	00656c62 	rsbeq	r6, r5, r2, ror #24
     b18:	7361544e 	cmnvc	r1, #1308622848	; 0x4e000000
     b1c:	74535f6b 	ldrbvc	r5, [r3], #-3947	; 0xfffff095
     b20:	00657461 	rsbeq	r7, r5, r1, ror #8
     b24:	335f5242 	cmpcc	pc, #536870916	; 0x20000004
     b28:	30303438 	eorscc	r3, r0, r8, lsr r4
     b2c:	52454400 	subpl	r4, r5, #0, 8
     b30:	435f5649 	cmpmi	pc, #76546048	; 0x4900000
     b34:	54534e4f 	ldrbpl	r4, [r3], #-3663	; 0xfffff1b1
     b38:	68637300 	stmdavs	r3!, {r8, r9, ip, sp, lr}^
     b3c:	635f6465 	cmpvs	pc, #1694498816	; 0x65000000
     b40:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     b44:	73007265 	movwvc	r7, #613	; 0x265
     b48:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     b4c:	6174735f 	cmnvs	r4, pc, asr r3
     b50:	5f636974 	svcpl	0x00636974
     b54:	6f697270 	svcvs	0x00697270
     b58:	79746972 	ldmdbvc	r4!, {r1, r4, r5, r6, r8, fp, sp, lr}^
     b5c:	69727700 	ldmdbvs	r2!, {r8, r9, sl, ip, sp, lr}^
     b60:	49006574 	stmdbmi	r0, {r2, r4, r5, r6, r8, sl, sp, lr}
     b64:	6974696e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, fp, sp, lr}^
     b68:	7a696c61 	bvc	1a5bcf4 <__bss_end+0x1a503bc>
     b6c:	46670065 	strbtmi	r0, [r7], -r5, rrx
     b70:	72445f53 	subvc	r5, r4, #332	; 0x14c
     b74:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     b78:	78650073 	stmdavc	r5!, {r0, r1, r4, r5, r6}^
     b7c:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
     b80:	0065646f 	rsbeq	r6, r5, pc, ror #8
     b84:	315f5242 	cmpcc	pc, r2, asr #4
     b88:	30323531 	eorscc	r3, r2, r1, lsr r5
     b8c:	5a5f0030 	bpl	17c0c54 <__bss_end+0x17b531c>
     b90:	65723031 	ldrbvs	r3, [r2, #-49]!	; 0xffffffcf
     b94:	705f6461 	subsvc	r6, pc, r1, ror #8
     b98:	6d617261 	sfmvs	f7, 2, [r1, #-388]!	; 0xfffffe7c
     b9c:	536d0076 	cmnpl	sp, #118	; 0x76
     ba0:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     ba4:	5f656c75 	svcpl	0x00656c75
     ba8:	00636e46 	rsbeq	r6, r3, r6, asr #28
     bac:	63726943 	cmnvs	r2, #1097728	; 0x10c000
     bb0:	72616c75 	rsbvc	r6, r1, #29952	; 0x7500
     bb4:	6675425f 			; <UNDEFINED> instruction: 0x6675425f
     bb8:	00726566 	rsbseq	r6, r2, r6, ror #10
     bbc:	6f725073 	svcvs	0x00725073
     bc0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     bc4:	0072674d 	rsbseq	r6, r2, sp, asr #14
     bc8:	4678614d 	ldrbtmi	r6, [r8], -sp, asr #2
     bcc:	69724453 	ldmdbvs	r2!, {r0, r1, r4, r6, sl, lr}^
     bd0:	4e726576 	mrcmi	5, 3, r6, cr2, cr6, {3}
     bd4:	4c656d61 	stclmi	13, cr6, [r5], #-388	; 0xfffffe7c
     bd8:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
     bdc:	65720068 	ldrbvs	r0, [r2, #-104]!	; 0xffffff98
     be0:	695f6461 	ldmdbvs	pc, {r0, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     be4:	7865646e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, sp, lr}^
     be8:	746f4e00 	strbtvc	r4, [pc], #-3584	; bf0 <shift+0xbf0>
     bec:	00796669 	rsbseq	r6, r9, r9, ror #12
     bf0:	6e697270 	mcrvs	2, 3, r7, cr9, cr0, {3}
     bf4:	72615074 	rsbvc	r5, r1, #116	; 0x74
     bf8:	5f006d61 	svcpl	0x00006d61
     bfc:	35314e5a 	ldrcc	r4, [r1, #-3674]!	; 0xfffff1a6
     c00:	63726943 	cmnvs	r2, #1097728	; 0x10c000
     c04:	72616c75 	rsbvc	r6, r1, #29952	; 0x7500
     c08:	6675425f 			; <UNDEFINED> instruction: 0x6675425f
     c0c:	43726566 	cmnmi	r2, #427819008	; 0x19800000
     c10:	00764534 	rsbseq	r4, r6, r4, lsr r5
     c14:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
     c18:	656e694c 	strbvs	r6, [lr, #-2380]!	; 0xfffff6b4
     c1c:	69727000 	ldmdbvs	r2!, {ip, sp, lr}^
     c20:	6f5f746e 	svcvs	0x005f746e
     c24:	4c007475 	cfstrsmi	mvf7, [r0], {117}	; 0x75
     c28:	5f6b636f 	svcpl	0x006b636f
     c2c:	6f6c6e55 	svcvs	0x006c6e55
     c30:	64656b63 	strbtvs	r6, [r5], #-2915	; 0xfffff49d
     c34:	65727000 	ldrbvs	r7, [r2, #-0]!
     c38:	61684364 	cmnvs	r8, r4, ror #6
     c3c:	5a5f0072 	bpl	17c0e0c <__bss_end+0x17b54d4>
     c40:	73703231 	cmnvc	r0, #268435459	; 0x10000003
     c44:	6f647565 	svcvs	0x00647565
     c48:	646e6152 	strbtvs	r6, [lr], #-338	; 0xfffffeae
     c4c:	69696d6f 	stmdbvs	r9!, {r0, r1, r2, r3, r5, r6, r8, sl, fp, sp, lr}^
     c50:	636f4c00 	cmnvs	pc, #0, 24
     c54:	6f4c5f6b 	svcvs	0x004c5f6b
     c58:	64656b63 	strbtvs	r6, [r5], #-2915	; 0xfffff49d
     c5c:	315a5f00 	cmpcc	sl, r0, lsl #30
     c60:	6e656732 	mcrvs	7, 3, r6, cr5, cr2, {1}
     c64:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
     c68:	656e5f65 	strbvs	r5, [lr, #-3941]!	; 0xfffff09b
     c6c:	54006977 	strpl	r6, [r0], #-2423	; 0xfffff689
     c70:	54524155 	ldrbpl	r4, [r2], #-341	; 0xfffffeab
     c74:	434f495f 	movtmi	r4, #63839	; 0xf95f
     c78:	505f6c74 	subspl	r6, pc, r4, ror ip	; <UNPREDICTABLE>
     c7c:	6d617261 	sfmvs	f7, 2, [r1, #-388]!	; 0xfffffe7c
     c80:	65520073 	ldrbvs	r0, [r2, #-115]	; 0xffffff8d
     c84:	575f6461 	ldrbpl	r6, [pc, -r1, ror #8]
     c88:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
     c8c:	6d6f5a00 	vstmdbvs	pc!, {s11-s10}
     c90:	00656962 	rsbeq	r6, r5, r2, ror #18
     c94:	5f646c6f 	svcpl	0x00646c6f
     c98:	74736562 	ldrbtvc	r6, [r3], #-1378	; 0xfffffa9e
     c9c:	7261705f 	rsbvc	r7, r1, #95	; 0x5f
     ca0:	00736d61 	rsbseq	r6, r3, r1, ror #26
     ca4:	63355a5f 	teqvs	r5, #389120	; 0x5f000
     ca8:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     cac:	62730076 	rsbsvs	r0, r3, #118	; 0x76
     cb0:	47006b72 	smlsdxmi	r0, r2, fp, r6
     cb4:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     cb8:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     cbc:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     cc0:	6567006f 	strbvs	r0, [r7, #-111]!	; 0xffffff91
     cc4:	69735f74 	ldmdbvs	r3!, {r2, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     cc8:	6700657a 	smlsdxvs	r0, sl, r5, r6
     ccc:	72656e65 	rsbvc	r6, r5, #1616	; 0x650
     cd0:	5f657461 	svcpl	0x00657461
     cd4:	0077656e 	rsbseq	r6, r7, lr, ror #10
     cd8:	314e5a5f 	cmpcc	lr, pc, asr sl
     cdc:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     ce0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     ce4:	614d5f73 	hvcvs	54771	; 0xd5f3
     ce8:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     cec:	63533872 	cmpvs	r3, #7471104	; 0x720000
     cf0:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     cf4:	7645656c 	strbvc	r6, [r5], -ip, ror #10
     cf8:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     cfc:	50433631 	subpl	r3, r3, r1, lsr r6
     d00:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     d04:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; b40 <shift+0xb40>
     d08:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     d0c:	39317265 	ldmdbcc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     d10:	5f70614d 	svcpl	0x0070614d
     d14:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     d18:	5f6f545f 	svcpl	0x006f545f
     d1c:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     d20:	45746e65 	ldrbmi	r6, [r4, #-3685]!	; 0xfffff19b
     d24:	46493550 			; <UNDEFINED> instruction: 0x46493550
     d28:	00656c69 	rsbeq	r6, r5, r9, ror #24
     d2c:	30315a5f 	eorscc	r5, r1, pc, asr sl
     d30:	736e6f63 	cmnvc	lr, #396	; 0x18c
     d34:	5f656c6f 	svcpl	0x00656c6f
     d38:	626a6e69 	rsbvs	r6, sl, #1680	; 0x690
     d3c:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     d40:	7261505f 	rsbvc	r5, r1, #95	; 0x5f
     d44:	00736d61 	rsbseq	r6, r3, r1, ror #26
     d48:	6c696863 	stclvs	8, cr6, [r9], #-396	; 0xfffffe74
     d4c:	6e657264 	cdpvs	2, 6, cr7, cr5, cr4, {3}
     d50:	78614d00 	stmdavc	r1!, {r8, sl, fp, lr}^
     d54:	68746150 	ldmdavs	r4!, {r4, r6, r8, sp, lr}^
     d58:	676e654c 	strbvs	r6, [lr, -ip, asr #10]!
     d5c:	48006874 	stmdami	r0, {r2, r4, r5, r6, fp, sp, lr}
     d60:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     d64:	654d5f65 	strbvs	r5, [sp, #-3941]	; 0xfffff09b
     d68:	79726f6d 	ldmdbvc	r2!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     d6c:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     d70:	736e7500 	cmnvc	lr, #0, 10
     d74:	656e6769 	strbvs	r6, [lr, #-1897]!	; 0xfffff897
     d78:	68632064 	stmdavs	r3!, {r2, r5, r6, sp}^
     d7c:	5f007261 	svcpl	0x00007261
     d80:	6972705f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, ip, sp, lr}^
     d84:	7469726f 	strbtvc	r7, [r9], #-623	; 0xfffffd91
     d88:	5a5f0079 	bpl	17c0f74 <__bss_end+0x17b563c>
     d8c:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     d90:	636f7250 	cmnvs	pc, #80, 4
     d94:	5f737365 	svcpl	0x00737365
     d98:	616e614d 	cmnvs	lr, sp, asr #2
     d9c:	31726567 	cmncc	r2, r7, ror #10
     da0:	68635332 	stmdavs	r3!, {r1, r4, r5, r8, r9, ip, lr}^
     da4:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     da8:	44455f65 	strbmi	r5, [r5], #-3941	; 0xfffff09b
     dac:	00764546 	rsbseq	r4, r6, r6, asr #10
     db0:	6c694643 	stclvs	6, cr4, [r9], #-268	; 0xfffffef4
     db4:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     db8:	006d6574 	rsbeq	r6, sp, r4, ror r5
     dbc:	726f6873 	rsbvc	r6, pc, #7536640	; 0x730000
     dc0:	6e692074 	mcrvs	0, 3, r2, cr9, cr4, {3}
     dc4:	5a5f0074 	bpl	17c0f9c <__bss_end+0x17b5664>
     dc8:	4335314e 	teqmi	r5, #-2147483629	; 0x80000013
     dcc:	75637269 	strbvc	r7, [r3, #-617]!	; 0xfffffd97
     dd0:	5f72616c 	svcpl	0x0072616c
     dd4:	66667542 	strbtvs	r7, [r6], -r2, asr #10
     dd8:	77357265 	ldrvc	r7, [r5, -r5, ror #4]!
     ddc:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
     de0:	45006345 	strmi	r6, [r0, #-837]	; 0xfffffcbb
     de4:	6c62616e 	stfvse	f6, [r2], #-440	; 0xfffffe48
     de8:	76455f65 	strbvc	r5, [r5], -r5, ror #30
     dec:	5f746e65 	svcpl	0x00746e65
     df0:	65746544 	ldrbvs	r6, [r4, #-1348]!	; 0xfffffabc
     df4:	6f697463 	svcvs	0x00697463
     df8:	534e006e 	movtpl	r0, #57454	; 0xe06e
     dfc:	4d5f4957 	vldrmi.16	s9, [pc, #-174]	; d56 <shift+0xd56>	; <UNPREDICTABLE>
     e00:	726f6d65 	rsbvc	r6, pc, #6464	; 0x1940
     e04:	65535f79 	ldrbvs	r5, [r3, #-3961]	; 0xfffff087
     e08:	63697672 	cmnvs	r9, #119537664	; 0x7200000
     e0c:	5a5f0065 	bpl	17c0fa8 <__bss_end+0x17b5670>
     e10:	4335314e 	teqmi	r5, #-2147483629	; 0x80000013
     e14:	75637269 	strbvc	r7, [r3, #-617]!	; 0xfffffd97
     e18:	5f72616c 	svcpl	0x0072616c
     e1c:	66667542 	strbtvs	r7, [r6], -r2, asr #10
     e20:	77357265 	ldrvc	r7, [r5, -r5, ror #4]!
     e24:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
     e28:	6a635045 	bvs	18d4f44 <__bss_end+0x18c960c>
     e2c:	6f5f7900 	svcvs	0x005f7900
     e30:	6d00646c 	cfstrsvs	mvf6, [r0, #-432]	; 0xfffffe50
     e34:	746f6f52 	strbtvc	r6, [pc], #-3922	; e3c <shift+0xe3c>
     e38:	69467300 	stmdbvs	r6, {r8, r9, ip, sp, lr}^
     e3c:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     e40:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     e44:	6e755200 	cdpvs	2, 7, cr5, cr5, cr0, {0}
     e48:	676e696e 	strbvs	r6, [lr, -lr, ror #18]!
     e4c:	6f747300 	svcvs	0x00747300
     e50:	65720070 	ldrbvs	r0, [r2, #-112]!	; 0xffffff90
     e54:	61566461 	cmpvs	r6, r1, ror #8
     e58:	0065756c 	rsbeq	r7, r5, ip, ror #10
     e5c:	55504f50 	ldrbpl	r4, [r0, #-3920]	; 0xfffff0b0
     e60:	4954414c 	ldmdbmi	r4, {r2, r3, r6, r8, lr}^
     e64:	5f004e4f 	svcpl	0x00004e4f
     e68:	7030315a 	eorsvc	r3, r0, sl, asr r1
     e6c:	746e6972 	strbtvc	r6, [lr], #-2418	; 0xfffff68e
     e70:	61726150 	cmnvs	r2, r0, asr r1
     e74:	7300766d 	movwvc	r7, #1645	; 0x66d
     e78:	74726174 	ldrbtvc	r6, [r2], #-372	; 0xfffffe8c
     e7c:	7865745f 	stmdavc	r5!, {r0, r1, r2, r3, r4, r6, sl, ip, sp, lr}^
     e80:	69750074 	ldmdbvs	r5!, {r2, r4, r5, r6}^
     e84:	3233746e 	eorscc	r7, r3, #1845493760	; 0x6e000000
     e88:	6700745f 	smlsdvs	r0, pc, r4, r7	; <UNPREDICTABLE>
     e8c:	72656e65 	rsbvc	r6, r5, #1616	; 0x650
     e90:	6f697461 	svcvs	0x00697461
     e94:	7200426e 	andvc	r4, r0, #-536870906	; 0xe0000006
     e98:	65646165 	strbvs	r6, [r4, #-357]!	; 0xfffffe9b
     e9c:	436d0072 	cmnmi	sp, #114	; 0x72
     ea0:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     ea4:	545f746e 	ldrbpl	r7, [pc], #-1134	; eac <shift+0xeac>
     ea8:	5f6b7361 	svcpl	0x006b7361
     eac:	65646f4e 	strbvs	r6, [r4, #-3918]!	; 0xfffff0b2
     eb0:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     eb4:	46433131 			; <UNDEFINED> instruction: 0x46433131
     eb8:	73656c69 	cmnvc	r5, #26880	; 0x6900
     ebc:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     ec0:	704f346d 	subvc	r3, pc, sp, ror #8
     ec4:	50456e65 	subpl	r6, r5, r5, ror #28
     ec8:	3531634b 	ldrcc	r6, [r1, #-843]!	; 0xfffffcb5
     ecc:	6c69464e 	stclvs	6, cr4, [r9], #-312	; 0xfffffec8
     ed0:	704f5f65 	subvc	r5, pc, r5, ror #30
     ed4:	4d5f6e65 	ldclmi	14, cr6, [pc, #-404]	; d48 <shift+0xd48>
     ed8:	0065646f 	rsbeq	r6, r5, pc, ror #8
     edc:	74736562 	ldrbtvc	r6, [r3], #-1378	; 0xfffffa9e
     ee0:	646e695f 	strbtvs	r6, [lr], #-2399	; 0xfffff6a1
     ee4:	63007865 	movwvs	r7, #2149	; 0x865
     ee8:	5f726168 	svcpl	0x00726168
     eec:	676e656c 	strbvs	r6, [lr, -ip, ror #10]!
     ef0:	64006874 	strvs	r6, [r0], #-2164	; 0xfffff78c
     ef4:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     ef8:	64695f72 	strbtvs	r5, [r9], #-3954	; 0xfffff08e
     efc:	65520078 	ldrbvs	r0, [r2, #-120]	; 0xffffff88
     f00:	4f5f6461 	svcmi	0x005f6461
     f04:	00796c6e 	rsbseq	r6, r9, lr, ror #24
     f08:	74736562 	ldrbtvc	r6, [r3], #-1378	; 0xfffffa9e
     f0c:	65737000 	ldrbvs	r7, [r3, #-0]!
     f10:	526f6475 	rsbpl	r6, pc, #1962934272	; 0x75000000
     f14:	6f646e61 	svcvs	0x00646e61
     f18:	7562006d 	strbvc	r0, [r2, #-109]!	; 0xffffff93
     f1c:	72656666 	rsbvc	r6, r5, #106954752	; 0x6600000
     f20:	656c7300 	strbvs	r7, [ip, #-768]!	; 0xfffffd00
     f24:	745f7065 	ldrbvc	r7, [pc], #-101	; f2c <shift+0xf2c>
     f28:	72656d69 	rsbvc	r6, r5, #6720	; 0x1a40
     f2c:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     f30:	4336314b 	teqmi	r6, #-1073741806	; 0xc0000012
     f34:	636f7250 	cmnvs	pc, #80, 4
     f38:	5f737365 	svcpl	0x00737365
     f3c:	616e614d 	cmnvs	lr, sp, asr #2
     f40:	31726567 	cmncc	r2, r7, ror #10
     f44:	74654738 	strbtvc	r4, [r5], #-1848	; 0xfffff8c8
     f48:	6f72505f 	svcvs	0x0072505f
     f4c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     f50:	5f79425f 	svcpl	0x0079425f
     f54:	45444950 	strbmi	r4, [r4, #-2384]	; 0xfffff6b0
     f58:	6176006a 	cmnvs	r6, sl, rrx
     f5c:	69735f6c 	ldmdbvs	r3!, {r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     f60:	4800657a 	stmdami	r0, {r1, r3, r4, r5, r6, r8, sl, sp, lr}
     f64:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     f68:	69465f65 	stmdbvs	r6, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     f6c:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     f70:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     f74:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     f78:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     f7c:	50433631 	subpl	r3, r3, r1, lsr r6
     f80:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     f84:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; dc0 <shift+0xdc0>
     f88:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     f8c:	31317265 	teqcc	r1, r5, ror #4
     f90:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     f94:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     f98:	4552525f 	ldrbmi	r5, [r2, #-607]	; 0xfffffda1
     f9c:	61740076 	cmnvs	r4, r6, ror r0
     fa0:	47006b73 	smlsdxmi	r0, r3, fp, r6
     fa4:	435f4e45 	cmpmi	pc, #1104	; 0x450
     fa8:	544e554f 	strbpl	r5, [lr], #-1359	; 0xfffffab1
     fac:	5f524200 	svcpl	0x00524200
     fb0:	30323931 	eorscc	r3, r2, r1, lsr r9
     fb4:	5a5f0030 	bpl	17c107c <__bss_end+0x17b5744>
     fb8:	6e656735 	mcrvs	7, 3, r6, cr5, cr5, {1}
     fbc:	69697349 	stmdbvs	r9!, {r0, r3, r6, r8, r9, ip, sp, lr}^
     fc0:	6f4e0066 	svcvs	0x004e0066
     fc4:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     fc8:	6f72505f 	svcvs	0x0072505f
     fcc:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     fd0:	68635300 	stmdavs	r3!, {r8, r9, ip, lr}^
     fd4:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     fd8:	72770065 	rsbsvc	r0, r7, #101	; 0x65
     fdc:	5f657469 	svcpl	0x00657469
     fe0:	65646e69 	strbvs	r6, [r4, #-3689]!	; 0xfffff197
     fe4:	5a5f0078 	bpl	17c11cc <__bss_end+0x17b5894>
     fe8:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     fec:	636f7250 	cmnvs	pc, #80, 4
     ff0:	5f737365 	svcpl	0x00737365
     ff4:	616e614d 	cmnvs	lr, sp, asr #2
     ff8:	32726567 	rsbscc	r6, r2, #432013312	; 0x19c00000
     ffc:	6f6c4231 	svcvs	0x006c4231
    1000:	435f6b63 	cmpmi	pc, #101376	; 0x18c00
    1004:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
    1008:	505f746e 	subspl	r7, pc, lr, ror #8
    100c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1010:	76457373 			; <UNDEFINED> instruction: 0x76457373
    1014:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    1018:	50433631 	subpl	r3, r3, r1, lsr r6
    101c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1020:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; e5c <shift+0xe5c>
    1024:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    1028:	53397265 	teqpl	r9, #1342177286	; 0x50000006
    102c:	63746977 	cmnvs	r4, #1949696	; 0x1dc000
    1030:	6f545f68 	svcvs	0x00545f68
    1034:	38315045 	ldmdacc	r1!, {r0, r2, r6, ip, lr}
    1038:	6f725043 	svcvs	0x00725043
    103c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1040:	73694c5f 	cmnvc	r9, #24320	; 0x5f00
    1044:	6f4e5f74 	svcvs	0x004e5f74
    1048:	76006564 	strvc	r6, [r0], -r4, ror #10
    104c:	635f6c61 	cmpvs	pc, #24832	; 0x6100
    1050:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
    1054:	72007265 	andvc	r7, r0, #1342177286	; 0x50000006
    1058:	596c6165 	stmdbpl	ip!, {r0, r2, r5, r6, r8, sp, lr}^
    105c:	00736157 	rsbseq	r6, r3, r7, asr r1
    1060:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
    1064:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
    1068:	0052525f 	subseq	r5, r2, pc, asr r2
    106c:	49646e72 	stmdbmi	r4!, {r1, r4, r5, r6, r9, sl, fp, sp, lr}^
    1070:	7865646e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, sp, lr}^
    1074:	61656800 	cmnvs	r5, r0, lsl #16
    1078:	61745370 	cmnvs	r4, r0, ror r3
    107c:	61007472 	tstvs	r0, r2, ror r4
    1080:	00766772 	rsbseq	r6, r6, r2, ror r7
    1084:	656e5f79 	strbvs	r5, [lr, #-3961]!	; 0xfffff087
    1088:	494e0077 	stmdbmi	lr, {r0, r1, r2, r4, r5, r6}^
    108c:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
    1090:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
    1094:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
    1098:	5f006e6f 	svcpl	0x00006e6f
    109c:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
    10a0:	6f725043 	svcvs	0x00725043
    10a4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    10a8:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
    10ac:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
    10b0:	72433431 	subvc	r3, r3, #822083584	; 0x31000000
    10b4:	65746165 	ldrbvs	r6, [r4, #-357]!	; 0xfffffe9b
    10b8:	6f72505f 	svcvs	0x0072505f
    10bc:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    10c0:	6a685045 	bvs	1a151dc <__bss_end+0x1a098a4>
    10c4:	77530062 	ldrbvc	r0, [r3, -r2, rrx]
    10c8:	68637469 	stmdavs	r3!, {r0, r3, r5, r6, sl, ip, sp, lr}^
    10cc:	006f545f 	rsbeq	r5, pc, pc, asr r4	; <UNPREDICTABLE>
    10d0:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
    10d4:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
    10d8:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
    10dc:	5f6d6574 	svcpl	0x006d6574
    10e0:	76726553 			; <UNDEFINED> instruction: 0x76726553
    10e4:	00656369 	rsbeq	r6, r5, r9, ror #6
    10e8:	64657270 	strbtvs	r7, [r5], #-624	; 0xfffffd90
    10ec:	65746369 	ldrbvs	r6, [r4, #-873]!	; 0xfffffc97
    10f0:	6e005964 	vmlsvs.f16	s10, s0, s9	; <UNPREDICTABLE>
    10f4:	61567765 	cmpvs	r6, r5, ror #14
    10f8:	5a5f006c 	bpl	17c12b0 <__bss_end+0x17b5978>
    10fc:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
    1100:	636f7250 	cmnvs	pc, #80, 4
    1104:	5f737365 	svcpl	0x00737365
    1108:	616e614d 	cmnvs	lr, sp, asr #2
    110c:	31726567 	cmncc	r2, r7, ror #10
    1110:	6e614837 	mcrvs	8, 3, r4, cr1, cr7, {1}
    1114:	5f656c64 	svcpl	0x00656c64
    1118:	6f6d654d 	svcvs	0x006d654d
    111c:	535f7972 	cmppl	pc, #1867776	; 0x1c8000
    1120:	31454957 	cmpcc	r5, r7, asr r9
    1124:	57534e39 	smmlarpl	r3, r9, lr, r4
    1128:	654d5f49 	strbvs	r5, [sp, #-3913]	; 0xfffff0b7
    112c:	79726f6d 	ldmdbvc	r2!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    1130:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
    1134:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
    1138:	526a6a6a 	rsbpl	r6, sl, #434176	; 0x6a000
    113c:	53543131 	cmppl	r4, #1073741836	; 0x4000000c
    1140:	525f4957 	subspl	r4, pc, #1425408	; 0x15c000
    1144:	6c757365 	ldclvs	3, cr7, [r5], #-404	; 0xfffffe6c
    1148:	52420074 	subpl	r0, r2, #116	; 0x74
    114c:	3032315f 	eorscc	r3, r2, pc, asr r1
    1150:	6e490030 	mcrvs	0, 2, r0, cr9, cr0, {1}
    1154:	696c6176 	stmdbvs	ip!, {r1, r2, r4, r5, r6, r8, sp, lr}^
    1158:	61485f64 	cmpvs	r8, r4, ror #30
    115c:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
    1160:	53465400 	movtpl	r5, #25600	; 0x6400
    1164:	6572545f 	ldrbvs	r5, [r2, #-1119]!	; 0xfffffba1
    1168:	6f4e5f65 	svcvs	0x004e5f65
    116c:	42006564 	andmi	r6, r0, #100, 10	; 0x19000000
    1170:	6b636f6c 	blvs	18dcf28 <__bss_end+0x18d15f0>
    1174:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
    1178:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
    117c:	6f72505f 	svcvs	0x0072505f
    1180:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
    1184:	5f524200 	svcpl	0x00524200
    1188:	30303639 	eorscc	r3, r0, r9, lsr r6
    118c:	61657200 	cmnvs	r5, r0, lsl #4
    1190:	6c430064 	mcrrvs	0, 6, r0, r3, cr4
    1194:	0065736f 	rsbeq	r7, r5, pc, ror #6
    1198:	76697264 	strbtvc	r7, [r9], -r4, ror #4
    119c:	61007265 	tstvs	r0, r5, ror #4
    11a0:	00636772 	rsbeq	r6, r3, r2, ror r7
    11a4:	444e4152 	strbmi	r4, [lr], #-338	; 0xfffffeae
    11a8:	525f4d4f 	subspl	r4, pc, #5056	; 0x13c0
    11ac:	45474e41 	strbmi	r4, [r7, #-3649]	; 0xfffff1bf
    11b0:	6f682f00 	svcvs	0x00682f00
    11b4:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
    11b8:	6e656863 	cdpvs	8, 6, cr6, cr5, cr3, {3}
    11bc:	6f2f6a6b 	svcvs	0x002f6a6b
    11c0:	32303273 	eorscc	r3, r0, #805306375	; 0x30000007
    11c4:	70732f32 	rsbsvc	r2, r3, r2, lsr pc
    11c8:	756f732f 	strbvc	r7, [pc, #-815]!	; ea1 <shift+0xea1>
    11cc:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
    11d0:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
    11d4:	61707372 	cmnvs	r0, r2, ror r3
    11d8:	732f6563 			; <UNDEFINED> instruction: 0x732f6563
    11dc:	61745f70 	cmnvs	r4, r0, ror pc
    11e0:	6d2f6b73 	fstmdbxvs	pc!, {d6-d62}	;@ Deprecated
    11e4:	2e6e6961 	vnmulcs.f16	s13, s28, s3	; <UNPREDICTABLE>
    11e8:	00707063 	rsbseq	r7, r0, r3, rrx
    11ec:	6c694649 	stclvs	6, cr4, [r9], #-292	; 0xfffffedc
    11f0:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
    11f4:	5f6d6574 	svcpl	0x006d6574
    11f8:	76697244 	strbtvc	r7, [r9], -r4, asr #4
    11fc:	5f007265 	svcpl	0x00007265
    1200:	6332315a 	teqvs	r2, #-2147483626	; 0x80000016
    1204:	6b636568 	blvs	18da7ac <__bss_end+0x18cee74>
    1208:	53726f46 	cmnpl	r2, #280	; 0x118
    120c:	50706f74 	rsbspl	r6, r0, r4, ror pc
    1210:	4e006a63 	vmlsmi.f32	s12, s0, s7
    1214:	54524155 	ldrbpl	r4, [r2], #-341	; 0xfffffeab
    1218:	746e495f 	strbtvc	r4, [lr], #-2399	; 0xfffff6a1
    121c:	75727265 	ldrbvc	r7, [r2, #-613]!	; 0xfffffd9b
    1220:	545f7470 	ldrbpl	r7, [pc], #-1136	; 1228 <shift+0x1228>
    1224:	00657079 	rsbeq	r7, r5, r9, ror r0
    1228:	64616572 	strbtvs	r6, [r1], #-1394	; 0xfffffa8e
    122c:	69746e55 	ldmdbvs	r4!, {r0, r2, r4, r6, r9, sl, fp, sp, lr}^
    1230:	7257006c 	subsvc	r0, r7, #108	; 0x6c
    1234:	5f657469 	svcpl	0x00657469
    1238:	796c6e4f 	stmdbvc	ip!, {r0, r1, r2, r3, r6, r9, sl, fp, sp, lr}^
    123c:	61656800 	cmnvs	r5, r0, lsl #16
    1240:	676f4c70 			; <UNDEFINED> instruction: 0x676f4c70
    1244:	6c616369 	stclvs	3, cr6, [r1], #-420	; 0xfffffe5c
    1248:	696d694c 	stmdbvs	sp!, {r2, r3, r6, r8, fp, sp, lr}^
    124c:	616d0074 	smcvs	53252	; 0xd004
    1250:	59006e69 	stmdbpl	r0, {r0, r3, r5, r6, r9, sl, fp, sp, lr}
    1254:	646c6569 	strbtvs	r6, [ip], #-1385	; 0xfffffa97
    1258:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    125c:	50433631 	subpl	r3, r3, r1, lsr r6
    1260:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1264:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 10a0 <shift+0x10a0>
    1268:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
    126c:	34437265 	strbcc	r7, [r3], #-613	; 0xfffffd9b
    1270:	6d007645 	stcvs	6, cr7, [r0, #-276]	; 0xfffffeec
    1274:	746f6f52 	strbtvc	r6, [pc], #-3922	; 127c <shift+0x127c>
    1278:	746e4d5f 	strbtvc	r4, [lr], #-3423	; 0xfffff2a1
    127c:	75706300 	ldrbvc	r6, [r0, #-768]!	; 0xfffffd00
    1280:	6e6f635f 	mcrvs	3, 3, r6, cr15, cr15, {2}
    1284:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
    1288:	72655400 	rsbvc	r5, r5, #0, 8
    128c:	616e696d 	cmnvs	lr, sp, ror #18
    1290:	49006574 	stmdbmi	r0, {r2, r4, r5, r6, r8, sl, sp, lr}
    1294:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
    1298:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
    129c:	5f746567 	svcpl	0x00746567
    12a0:	66666679 			; <UNDEFINED> instruction: 0x66666679
    12a4:	66666666 	strbtvs	r6, [r6], -r6, ror #12
    12a8:	6c630066 	stclvs	0, cr0, [r3], #-408	; 0xfffffe68
    12ac:	0065736f 	rsbeq	r7, r5, pc, ror #6
    12b0:	5f746553 	svcpl	0x00746553
    12b4:	616c6552 	cmnvs	ip, r2, asr r5
    12b8:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
    12bc:	75636e00 	strbvc	r6, [r3, #-3584]!	; 0xfffff200
    12c0:	69700072 	ldmdbvs	r0!, {r1, r4, r5, r6}^
    12c4:	72006570 	andvc	r6, r0, #112, 10	; 0x1c000000
    12c8:	6d756e64 	ldclvs	14, cr6, [r5, #-400]!	; 0xfffffe70
    12cc:	315a5f00 	cmpcc	sl, r0, lsl #30
    12d0:	68637331 	stmdavs	r3!, {r0, r4, r5, r8, r9, ip, sp, lr}^
    12d4:	795f6465 	ldmdbvc	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
    12d8:	646c6569 	strbtvs	r6, [ip], #-1385	; 0xfffffa97
    12dc:	5a5f0076 	bpl	17c14bc <__bss_end+0x17b5b84>
    12e0:	65733731 	ldrbvs	r3, [r3, #-1841]!	; 0xfffff8cf
    12e4:	61745f74 	cmnvs	r4, r4, ror pc
    12e8:	645f6b73 	ldrbvs	r6, [pc], #-2931	; 12f0 <shift+0x12f0>
    12ec:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
    12f0:	6a656e69 	bvs	195cc9c <__bss_end+0x1951364>
    12f4:	69617700 	stmdbvs	r1!, {r8, r9, sl, ip, sp, lr}^
    12f8:	5a5f0074 	bpl	17c14d0 <__bss_end+0x17b5b98>
    12fc:	746f6e36 	strbtvc	r6, [pc], #-3638	; 1304 <shift+0x1304>
    1300:	6a796669 	bvs	1e5acac <__bss_end+0x1e4f374>
    1304:	5a5f006a 	bpl	17c14b4 <__bss_end+0x17b5b7c>
    1308:	72657439 	rsbvc	r7, r5, #956301312	; 0x39000000
    130c:	616e696d 	cmnvs	lr, sp, ror #18
    1310:	00696574 	rsbeq	r6, r9, r4, ror r5
    1314:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 1260 <shift+0x1260>
    1318:	63732f65 	cmnvs	r3, #404	; 0x194
    131c:	6b6e6568 	blvs	1b9a8c4 <__bss_end+0x1b8ef8c>
    1320:	736f2f6a 	cmnvc	pc, #424	; 0x1a8
    1324:	32323032 	eorscc	r3, r2, #50	; 0x32
    1328:	2f70732f 	svccs	0x0070732f
    132c:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
    1330:	2f736563 	svccs	0x00736563
    1334:	6c647473 	cfstrdvs	mvd7, [r4], #-460	; 0xfffffe34
    1338:	732f6269 			; <UNDEFINED> instruction: 0x732f6269
    133c:	732f6372 			; <UNDEFINED> instruction: 0x732f6372
    1340:	69666474 	stmdbvs	r6!, {r2, r4, r5, r6, sl, sp, lr}^
    1344:	632e656c 			; <UNDEFINED> instruction: 0x632e656c
    1348:	46007070 			; <UNDEFINED> instruction: 0x46007070
    134c:	006c6961 	rsbeq	r6, ip, r1, ror #18
    1350:	74697865 	strbtvc	r7, [r9], #-2149	; 0xfffff79b
    1354:	65646f63 	strbvs	r6, [r4, #-3939]!	; 0xfffff09d
    1358:	325a5f00 	subscc	r5, sl, #0, 30
    135c:	74656734 	strbtvc	r6, [r5], #-1844	; 0xfffff8cc
    1360:	7463615f 	strbtvc	r6, [r3], #-351	; 0xfffffea1
    1364:	5f657669 	svcpl	0x00657669
    1368:	636f7270 	cmnvs	pc, #112, 4
    136c:	5f737365 	svcpl	0x00737365
    1370:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
    1374:	73007674 	movwvc	r7, #1652	; 0x674
    1378:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    137c:	6569795f 	strbvs	r7, [r9, #-2399]!	; 0xfffff6a1
    1380:	7400646c 	strvc	r6, [r0], #-1132	; 0xfffffb94
    1384:	5f6b6369 	svcpl	0x006b6369
    1388:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
    138c:	65725f74 	ldrbvs	r5, [r2, #-3956]!	; 0xfffff08c
    1390:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    1394:	50006465 	andpl	r6, r0, r5, ror #8
    1398:	5f657069 	svcpl	0x00657069
    139c:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    13a0:	6572505f 	ldrbvs	r5, [r2, #-95]!	; 0xffffffa1
    13a4:	00786966 	rsbseq	r6, r8, r6, ror #18
    13a8:	34315a5f 	ldrtcc	r5, [r1], #-2655	; 0xfffff5a1
    13ac:	5f746567 	svcpl	0x00746567
    13b0:	6b636974 	blvs	18db988 <__bss_end+0x18d0050>
    13b4:	756f635f 	strbvc	r6, [pc, #-863]!	; 105d <shift+0x105d>
    13b8:	0076746e 	rsbseq	r7, r6, lr, ror #8
    13bc:	65656c73 	strbvs	r6, [r5, #-3187]!	; 0xfffff38d
    13c0:	682f0070 	stmdavs	pc!, {r4, r5, r6}	; <UNPREDICTABLE>
    13c4:	2f656d6f 	svccs	0x00656d6f
    13c8:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
    13cc:	2f6a6b6e 	svccs	0x006a6b6e
    13d0:	3032736f 	eorscc	r7, r2, pc, ror #6
    13d4:	732f3232 			; <UNDEFINED> instruction: 0x732f3232
    13d8:	6f732f70 	svcvs	0x00732f70
    13dc:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    13e0:	75622f73 	strbvc	r2, [r2, #-3955]!	; 0xfffff08d
    13e4:	00646c69 	rsbeq	r6, r4, r9, ror #24
    13e8:	7265706f 	rsbvc	r7, r5, #111	; 0x6f
    13ec:	6f697461 	svcvs	0x00697461
    13f0:	5a5f006e 	bpl	17c15b0 <__bss_end+0x17b5c78>
    13f4:	6f6c6335 	svcvs	0x006c6335
    13f8:	006a6573 	rsbeq	r6, sl, r3, ror r5
    13fc:	67365a5f 			; <UNDEFINED> instruction: 0x67365a5f
    1400:	69707465 	ldmdbvs	r0!, {r0, r2, r5, r6, sl, ip, sp, lr}^
    1404:	66007664 	strvs	r7, [r0], -r4, ror #12
    1408:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
    140c:	746f6e00 	strbtvc	r6, [pc], #-3584	; 1414 <shift+0x1414>
    1410:	00796669 	rsbseq	r6, r9, r9, ror #12
    1414:	76746572 			; <UNDEFINED> instruction: 0x76746572
    1418:	74006c61 	strvc	r6, [r0], #-3169	; 0xfffff39f
    141c:	736b6369 	cmnvc	fp, #-1543503871	; 0xa4000001
    1420:	65706f00 	ldrbvs	r6, [r0, #-3840]!	; 0xfffff100
    1424:	5a5f006e 	bpl	17c15e4 <__bss_end+0x17b5cac>
    1428:	70697034 	rsbvc	r7, r9, r4, lsr r0
    142c:	634b5065 	movtvs	r5, #45157	; 0xb065
    1430:	444e006a 	strbmi	r0, [lr], #-106	; 0xffffff96
    1434:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
    1438:	5f656e69 	svcpl	0x00656e69
    143c:	73627553 	cmnvc	r2, #348127232	; 0x14c00000
    1440:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
    1444:	67006563 	strvs	r6, [r0, -r3, ror #10]
    1448:	745f7465 	ldrbvc	r7, [pc], #-1125	; 1450 <shift+0x1450>
    144c:	5f6b6369 	svcpl	0x006b6369
    1450:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
    1454:	5a5f0074 	bpl	17c162c <__bss_end+0x17b5cf4>
    1458:	69727735 	ldmdbvs	r2!, {r0, r2, r4, r5, r8, r9, sl, ip, sp, lr}^
    145c:	506a6574 	rsbpl	r6, sl, r4, ror r5
    1460:	006a634b 	rsbeq	r6, sl, fp, asr #6
    1464:	63746572 	cmnvs	r4, #478150656	; 0x1c800000
    1468:	0065646f 	rsbeq	r6, r5, pc, ror #8
    146c:	5f746567 	svcpl	0x00746567
    1470:	6b736174 	blvs	1cd9a48 <__bss_end+0x1cce110>
    1474:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
    1478:	745f736b 	ldrbvc	r7, [pc], #-875	; 1480 <shift+0x1480>
    147c:	65645f6f 	strbvs	r5, [r4, #-3951]!	; 0xfffff091
    1480:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
    1484:	6200656e 	andvs	r6, r0, #461373440	; 0x1b800000
    1488:	735f6675 	cmpvc	pc, #122683392	; 0x7500000
    148c:	00657a69 	rsbeq	r7, r5, r9, ror #20
    1490:	5f746573 	svcpl	0x00746573
    1494:	6b736174 	blvs	1cd9a6c <__bss_end+0x1cce134>
    1498:	6165645f 	cmnvs	r5, pc, asr r4
    149c:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
    14a0:	5a5f0065 	bpl	17c163c <__bss_end+0x17b5d04>
    14a4:	656c7335 	strbvs	r7, [ip, #-821]!	; 0xfffffccb
    14a8:	6a6a7065 	bvs	1a9d644 <__bss_end+0x1a91d0c>
    14ac:	6c696600 	stclvs	6, cr6, [r9], #-0
    14b0:	65470065 	strbvs	r0, [r7, #-101]	; 0xffffff9b
    14b4:	65525f74 	ldrbvs	r5, [r2, #-3956]	; 0xfffff08c
    14b8:	6e69616d 	powvsez	f6, f1, #5.0
    14bc:	00676e69 	rsbeq	r6, r7, r9, ror #28
    14c0:	36325a5f 			; <UNDEFINED> instruction: 0x36325a5f
    14c4:	5f746567 	svcpl	0x00746567
    14c8:	6b736174 	blvs	1cd9aa0 <__bss_end+0x1cce168>
    14cc:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
    14d0:	745f736b 	ldrbvc	r7, [pc], #-875	; 14d8 <shift+0x14d8>
    14d4:	65645f6f 	strbvs	r5, [r4, #-3951]!	; 0xfffff091
    14d8:	696c6461 	stmdbvs	ip!, {r0, r5, r6, sl, sp, lr}^
    14dc:	0076656e 	rsbseq	r6, r6, lr, ror #10
    14e0:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
    14e4:	7365525f 	cmnvc	r5, #-268435451	; 0xf0000005
    14e8:	5f746c75 	svcpl	0x00746c75
    14ec:	65646f43 	strbvs	r6, [r4, #-3907]!	; 0xfffff0bd
    14f0:	6e727700 	cdpvs	7, 7, cr7, cr2, cr0, {0}
    14f4:	5f006d75 	svcpl	0x00006d75
    14f8:	6177345a 	cmnvs	r7, sl, asr r4
    14fc:	6a6a7469 	bvs	1a9e6a8 <__bss_end+0x1a92d70>
    1500:	5a5f006a 	bpl	17c16b0 <__bss_end+0x17b5d78>
    1504:	636f6935 	cmnvs	pc, #868352	; 0xd4000
    1508:	316a6c74 	smccc	42692	; 0xa6c4
    150c:	4f494e36 	svcmi	0x00494e36
    1510:	5f6c7443 	svcpl	0x006c7443
    1514:	7265704f 	rsbvc	r7, r5, #79	; 0x4f
    1518:	6f697461 	svcvs	0x00697461
    151c:	0076506e 	rsbseq	r5, r6, lr, rrx
    1520:	74636f69 	strbtvc	r6, [r3], #-3945	; 0xfffff097
    1524:	6572006c 	ldrbvs	r0, [r2, #-108]!	; 0xffffff94
    1528:	746e6374 	strbtvc	r6, [lr], #-884	; 0xfffffc8c
    152c:	72657400 	rsbvc	r7, r5, #0, 8
    1530:	616e696d 	cmnvs	lr, sp, ror #18
    1534:	6d006574 	cfstr32vs	mvfx6, [r0, #-464]	; 0xfffffe30
    1538:	0065646f 	rsbeq	r6, r5, pc, ror #8
    153c:	72345a5f 	eorsvc	r5, r4, #389120	; 0x5f000
    1540:	6a646165 	bvs	1919adc <__bss_end+0x190e1a4>
    1544:	006a6350 	rsbeq	r6, sl, r0, asr r3
    1548:	5f746567 	svcpl	0x00746567
    154c:	69746361 	ldmdbvs	r4!, {r0, r5, r6, r8, r9, sp, lr}^
    1550:	705f6576 	subsvc	r6, pc, r6, ror r5	; <UNPREDICTABLE>
    1554:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
    1558:	635f7373 	cmpvs	pc, #-872415231	; 0xcc000001
    155c:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
    1560:	6c696600 	stclvs	6, cr6, [r9], #-0
    1564:	6d616e65 	stclvs	14, cr6, [r1, #-404]!	; 0xfffffe6c
    1568:	65670065 	strbvs	r0, [r7, #-101]!	; 0xffffff9b
    156c:	64697074 	strbtvs	r7, [r9], #-116	; 0xffffff8c
    1570:	345a5f00 	ldrbcc	r5, [sl], #-3840	; 0xfffff100
    1574:	6e65706f 	cdpvs	0, 6, cr7, cr5, cr15, {3}
    1578:	31634b50 	cmncc	r3, r0, asr fp
    157c:	69464e35 	stmdbvs	r6, {r0, r2, r4, r5, r9, sl, fp, lr}^
    1580:	4f5f656c 	svcmi	0x005f656c
    1584:	5f6e6570 	svcpl	0x006e6570
    1588:	65646f4d 	strbvs	r6, [r4, #-3917]!	; 0xfffff0b3
    158c:	554e4700 	strbpl	r4, [lr, #-1792]	; 0xfffff900
    1590:	2b2b4320 	blcs	ad2218 <__bss_end+0xac68e0>
    1594:	39203431 	stmdbcc	r0!, {r0, r4, r5, sl, ip, sp}
    1598:	312e322e 			; <UNDEFINED> instruction: 0x312e322e
    159c:	31303220 	teqcc	r0, r0, lsr #4
    15a0:	32303139 	eorscc	r3, r0, #1073741838	; 0x4000000e
    15a4:	72282035 	eorvc	r2, r8, #53	; 0x35
    15a8:	61656c65 	cmnvs	r5, r5, ror #24
    15ac:	20296573 	eorcs	r6, r9, r3, ror r5
    15b0:	4d52415b 	ldfmie	f4, [r2, #-364]	; 0xfffffe94
    15b4:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    15b8:	622d392d 	eorvs	r3, sp, #737280	; 0xb4000
    15bc:	636e6172 	cmnvs	lr, #-2147483620	; 0x8000001c
    15c0:	65722068 	ldrbvs	r2, [r2, #-104]!	; 0xffffff98
    15c4:	69736976 	ldmdbvs	r3!, {r1, r2, r4, r5, r6, r8, fp, sp, lr}^
    15c8:	32206e6f 	eorcc	r6, r0, #1776	; 0x6f0
    15cc:	39353737 	ldmdbcc	r5!, {r0, r1, r2, r4, r5, r8, r9, sl, ip, sp}
    15d0:	2d205d39 	stccs	13, cr5, [r0, #-228]!	; 0xffffff1c
    15d4:	6f6c666d 	svcvs	0x006c666d
    15d8:	612d7461 			; <UNDEFINED> instruction: 0x612d7461
    15dc:	683d6962 	ldmdavs	sp!, {r1, r5, r6, r8, fp, sp, lr}
    15e0:	20647261 	rsbcs	r7, r4, r1, ror #4
    15e4:	70666d2d 	rsbvc	r6, r6, sp, lsr #26
    15e8:	66763d75 			; <UNDEFINED> instruction: 0x66763d75
    15ec:	6d2d2070 	stcvs	0, cr2, [sp, #-448]!	; 0xfffffe40
    15f0:	616f6c66 	cmnvs	pc, r6, ror #24
    15f4:	62612d74 	rsbvs	r2, r1, #116, 26	; 0x1d00
    15f8:	61683d69 	cmnvs	r8, r9, ror #26
    15fc:	2d206472 	cfstrscs	mvf6, [r0, #-456]!	; 0xfffffe38
    1600:	7570666d 	ldrbvc	r6, [r0, #-1645]!	; 0xfffff993
    1604:	7066763d 	rsbvc	r7, r6, sp, lsr r6
    1608:	746d2d20 	strbtvc	r2, [sp], #-3360	; 0xfffff2e0
    160c:	3d656e75 	stclcc	14, cr6, [r5, #-468]!	; 0xfffffe2c
    1610:	316d7261 	cmncc	sp, r1, ror #4
    1614:	6a363731 	bvs	d8f2e0 <__bss_end+0xd839a8>
    1618:	732d667a 			; <UNDEFINED> instruction: 0x732d667a
    161c:	616d2d20 	cmnvs	sp, r0, lsr #26
    1620:	2d206d72 	stccs	13, cr6, [r0, #-456]!	; 0xfffffe38
    1624:	6372616d 	cmnvs	r2, #1073741851	; 0x4000001b
    1628:	72613d68 	rsbvc	r3, r1, #104, 26	; 0x1a00
    162c:	7a36766d 	bvc	d9efe8 <__bss_end+0xd936b0>
    1630:	70662b6b 	rsbvc	r2, r6, fp, ror #22
    1634:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    1638:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    163c:	4f2d2067 	svcmi	0x002d2067
    1640:	4f2d2030 	svcmi	0x002d2030
    1644:	662d2030 			; <UNDEFINED> instruction: 0x662d2030
    1648:	652d6f6e 	strvs	r6, [sp, #-3950]!	; 0xfffff092
    164c:	70656378 	rsbvc	r6, r5, r8, ror r3
    1650:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
    1654:	662d2073 			; <UNDEFINED> instruction: 0x662d2073
    1658:	722d6f6e 	eorvc	r6, sp, #440	; 0x1b8
    165c:	00697474 	rsbeq	r7, r9, r4, ror r4
    1660:	6d365a5f 	vldmdbvs	r6!, {s10-s104}
    1664:	6f6c6c61 	svcvs	0x006c6c61
    1668:	6d006a63 	vstrvs	s12, [r0, #-396]	; 0xfffffe74
    166c:	6f6c6c61 	svcvs	0x006c6c61
    1670:	656d0063 	strbvs	r0, [sp, #-99]!	; 0xffffff9d
    1674:	64615f6d 	strbtvs	r5, [r1], #-3949	; 0xfffff093
    1678:	682f0064 	stmdavs	pc!, {r2, r5, r6}	; <UNPREDICTABLE>
    167c:	2f656d6f 	svccs	0x00656d6f
    1680:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
    1684:	2f6a6b6e 	svccs	0x006a6b6e
    1688:	3032736f 	eorscc	r7, r2, pc, ror #6
    168c:	732f3232 			; <UNDEFINED> instruction: 0x732f3232
    1690:	6f732f70 	svcvs	0x00732f70
    1694:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    1698:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
    169c:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
    16a0:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
    16a4:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    16a8:	2e6d656d 	cdpcs	5, 6, cr6, cr13, cr13, {3}
    16ac:	00707063 	rsbseq	r7, r0, r3, rrx
    16b0:	6d726f6e 	ldclvs	15, cr6, [r2, #-440]!	; 0xfffffe48
    16b4:	7a696c61 	bvc	1a5c840 <__bss_end+0x1a50f08>
    16b8:	5a5f0065 	bpl	17c1854 <__bss_end+0x17b5f1c>
    16bc:	6d656d36 	stclvs	13, cr6, [r5, #-216]!	; 0xffffff28
    16c0:	50797063 	rsbspl	r7, r9, r3, rrx
    16c4:	7650764b 	ldrbvc	r7, [r0], -fp, asr #12
    16c8:	5a5f0069 	bpl	17c1874 <__bss_end+0x17b5f3c>
    16cc:	6f746934 	svcvs	0x00746934
    16d0:	63506a61 	cmpvs	r0, #397312	; 0x61000
    16d4:	7865006a 	stmdavc	r5!, {r1, r3, r5, r6}^
    16d8:	656e6f70 	strbvs	r6, [lr, #-3952]!	; 0xfffff090
    16dc:	6100746e 	tstvs	r0, lr, ror #8
    16e0:	00696f74 	rsbeq	r6, r9, r4, ror pc
    16e4:	6c727473 	cfldrdvs	mvd7, [r2], #-460	; 0xfffffe34
    16e8:	5f006e65 	svcpl	0x00006e65
    16ec:	7461345a 	strbtvc	r3, [r1], #-1114	; 0xfffffba6
    16f0:	4b50666f 	blmi	141b0b4 <__bss_end+0x140f77c>
    16f4:	65640063 	strbvs	r0, [r4, #-99]!	; 0xffffff9d
    16f8:	73007473 	movwvc	r7, #1139	; 0x473
    16fc:	006e6769 	rsbeq	r6, lr, r9, ror #14
    1700:	616f7469 	cmnvs	pc, r9, ror #8
    1704:	72747300 	rsbsvc	r7, r4, #0, 6
    1708:	00746163 	rsbseq	r6, r4, r3, ror #2
    170c:	62355a5f 	eorsvs	r5, r5, #389120	; 0x5f000
    1710:	6f72657a 	svcvs	0x0072657a
    1714:	00697650 	rsbeq	r7, r9, r0, asr r6
    1718:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
    171c:	00797063 	rsbseq	r7, r9, r3, rrx
    1720:	66345a5f 			; <UNDEFINED> instruction: 0x66345a5f
    1724:	50616f74 	rsbpl	r6, r1, r4, ror pc
    1728:	2f006663 	svccs	0x00006663
    172c:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    1730:	6863732f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, sp, lr}^
    1734:	6a6b6e65 	bvs	1add0d0 <__bss_end+0x1ad1798>
    1738:	32736f2f 	rsbscc	r6, r3, #47, 30	; 0xbc
    173c:	2f323230 	svccs	0x00323230
    1740:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
    1744:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    1748:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
    174c:	696c6474 	stmdbvs	ip!, {r2, r4, r5, r6, sl, sp, lr}^
    1750:	72732f62 	rsbsvc	r2, r3, #392	; 0x188
    1754:	74732f63 	ldrbtvc	r2, [r3], #-3939	; 0xfffff09d
    1758:	72747364 	rsbsvc	r7, r4, #100, 6	; 0x90000001
    175c:	2e676e69 	cdpcs	14, 6, cr6, cr7, cr9, {3}
    1760:	00707063 	rsbseq	r7, r0, r3, rrx
    1764:	73375a5f 	teqvc	r7, #389120	; 0x5f000
    1768:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    176c:	63507970 	cmpvs	r0, #112, 18	; 0x1c0000
    1770:	69634b50 	stmdbvs	r3!, {r4, r6, r8, r9, fp, lr}^
    1774:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
    1778:	63727473 	cmnvs	r2, #1929379840	; 0x73000000
    177c:	63507461 	cmpvs	r0, #1627389952	; 0x61000000
    1780:	00634b50 	rsbeq	r4, r3, r0, asr fp
    1784:	6e395a5f 			; <UNDEFINED> instruction: 0x6e395a5f
    1788:	616d726f 	cmnvs	sp, pc, ror #4
    178c:	657a696c 	ldrbvs	r6, [sl, #-2412]!	; 0xfffff694
    1790:	64006650 	strvs	r6, [r0], #-1616	; 0xfffff9b0
    1794:	74696769 	strbtvc	r6, [r9], #-1897	; 0xfffff897
    1798:	6f746100 	svcvs	0x00746100
    179c:	656d0066 	strbvs	r0, [sp, #-102]!	; 0xffffff9a
    17a0:	7473646d 	ldrbtvc	r6, [r3], #-1133	; 0xfffffb93
    17a4:	61684300 	cmnvs	r8, r0, lsl #6
    17a8:	6e6f4372 	mcrvs	3, 3, r4, cr15, cr2, {3}
    17ac:	72724176 	rsbsvc	r4, r2, #-2147483619	; 0x8000001d
    17b0:	6f746600 	svcvs	0x00746600
    17b4:	656d0061 	strbvs	r0, [sp, #-97]!	; 0xffffff9f
    17b8:	6372736d 	cmnvs	r2, #-1275068415	; 0xb4000001
    17bc:	657a6200 	ldrbvs	r6, [sl, #-512]!	; 0xfffffe00
    17c0:	62006f72 	andvs	r6, r0, #456	; 0x1c8
    17c4:	00657361 	rsbeq	r7, r5, r1, ror #6
    17c8:	6e727473 	mrcvs	4, 3, r7, cr2, cr3, {3}
    17cc:	00706d63 	rsbseq	r6, r0, r3, ror #26
    17d0:	74646977 	strbtvc	r6, [r4], #-2423	; 0xfffff689
    17d4:	656d0068 	strbvs	r0, [sp, #-104]!	; 0xffffff98
    17d8:	7970636d 	ldmdbvc	r0!, {r0, r2, r3, r5, r6, r8, r9, sp, lr}^
    17dc:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
    17e0:	6c727473 	cfldrdvs	mvd7, [r2], #-460	; 0xfffffe34
    17e4:	4b506e65 	blmi	141d180 <__bss_end+0x1411848>
    17e8:	5a5f0063 	bpl	17c197c <__bss_end+0x17b6044>
    17ec:	72747337 	rsbsvc	r7, r4, #-603979776	; 0xdc000000
    17f0:	706d636e 	rsbvc	r6, sp, lr, ror #6
    17f4:	53634b50 	cmnpl	r3, #80, 22	; 0x14000
    17f8:	00695f30 	rsbeq	r5, r9, r0, lsr pc
    17fc:	61345a5f 	teqvs	r4, pc, asr sl
    1800:	50696f74 	rsbpl	r6, r9, r4, ror pc
    1804:	6f00634b 	svcvs	0x0000634b
    1808:	75707475 	ldrbvc	r7, [r0, #-1141]!	; 0xfffffb8b
    180c:	656d0074 	strbvs	r0, [sp, #-116]!	; 0xffffff8c
    1810:	79726f6d 	ldmdbvc	r2!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
    1814:	616c7000 	cmnvs	ip, r0
    1818:	00736563 	rsbseq	r6, r3, r3, ror #10
    181c:	75746572 	ldrbvc	r6, [r4, #-1394]!	; 0xfffffa8e
    1820:	75426e72 	strbvc	r6, [r2, #-3698]	; 0xfffff18e
    1824:	72656666 	rsbvc	r6, r5, #106954752	; 0x6600000
    1828:	69687400 	stmdbvs	r8!, {sl, ip, sp, lr}^
    182c:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
    1830:	2f656d6f 	svccs	0x00656d6f
    1834:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
    1838:	2f6a6b6e 	svccs	0x006a6b6e
    183c:	3032736f 	eorscc	r7, r2, pc, ror #6
    1840:	732f3232 			; <UNDEFINED> instruction: 0x732f3232
    1844:	6f732f70 	svcvs	0x00732f70
    1848:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
    184c:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
    1850:	69747564 	ldmdbvs	r4!, {r2, r5, r6, r8, sl, ip, sp, lr}^
    1854:	732f736c 			; <UNDEFINED> instruction: 0x732f736c
    1858:	722f6372 	eorvc	r6, pc, #-939524095	; 0xc8000001
    185c:	55646165 	strbpl	r6, [r4, #-357]!	; 0xfffffe9b
    1860:	736c6974 	cmnvc	ip, #116, 18	; 0x1d0000
    1864:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
    1868:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
    186c:	65523031 	ldrbvs	r3, [r2, #-49]	; 0xffffffcf
    1870:	555f6461 	ldrbpl	r6, [pc, #-1121]	; 1417 <shift+0x1417>
    1874:	736c6974 	cmnvc	ip, #116, 18	; 0x1d0000
    1878:	76453243 	strbvc	r3, [r5], -r3, asr #4
    187c:	61657200 	cmnvs	r5, r0, lsl #4
    1880:	66754264 	ldrbtvs	r4, [r5], -r4, ror #4
    1884:	00726566 	rsbseq	r6, r2, r6, ror #10
    1888:	636f6c62 	cmnvs	pc, #25088	; 0x6200
    188c:	676e696b 	strbvs	r6, [lr, -fp, ror #18]!
    1890:	61657200 	cmnvs	r5, r0, lsl #4
    1894:	61684364 	cmnvs	r8, r4, ror #6
    1898:	5f007372 	svcpl	0x00007372
    189c:	35314e5a 	ldrcc	r4, [r1, #-3674]!	; 0xfffff1a6
    18a0:	63726943 	cmnvs	r2, #1097728	; 0x10c000
    18a4:	72616c75 	rsbvc	r6, r1, #29952	; 0x7500
    18a8:	6675425f 			; <UNDEFINED> instruction: 0x6675425f
    18ac:	43726566 	cmnmi	r2, #427819008	; 0x19800000
    18b0:	00764532 	rsbseq	r4, r6, r2, lsr r5
    18b4:	4c78616d 	ldfmie	f6, [r8], #-436	; 0xfffffe4c
    18b8:	2f006e65 	svccs	0x00006e65
    18bc:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
    18c0:	6863732f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, sp, lr}^
    18c4:	6a6b6e65 	bvs	1add260 <__bss_end+0x1ad1928>
    18c8:	32736f2f 	rsbscc	r6, r3, #47, 30	; 0xbc
    18cc:	2f323230 	svccs	0x00323230
    18d0:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
    18d4:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
    18d8:	732f7365 			; <UNDEFINED> instruction: 0x732f7365
    18dc:	74756474 	ldrbtvc	r6, [r5], #-1140	; 0xfffffb8c
    18e0:	2f736c69 	svccs	0x00736c69
    18e4:	2f637273 	svccs	0x00637273
    18e8:	63726963 	cmnvs	r2, #1622016	; 0x18c000
    18ec:	72616c75 	rsbvc	r6, r1, #29952	; 0x7500
    18f0:	66667542 	strbtvs	r7, [r6], -r2, asr #10
    18f4:	632e7265 			; <UNDEFINED> instruction: 0x632e7265
    18f8:	72007070 	andvc	r7, r0, #112	; 0x70
    18fc:	54646165 	strbtpl	r6, [r4], #-357	; 0xfffffe9b
    1900:	49706d65 	ldmdbmi	r0!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}^
    1904:	7865646e 	stmdavc	r5!, {r1, r2, r3, r5, r6, sl, sp, lr}^
    1908:	2f2e2e00 	svccs	0x002e2e00
    190c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1910:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1914:	2f2e2e2f 	svccs	0x002e2e2f
    1918:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 1868 <shift+0x1868>
    191c:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1920:	6f632f63 	svcvs	0x00632f63
    1924:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
    1928:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    192c:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    1930:	6e756631 	mrcvs	6, 3, r6, cr5, cr1, {1}
    1934:	532e7363 			; <UNDEFINED> instruction: 0x532e7363
    1938:	75622f00 	strbvc	r2, [r2, #-3840]!	; 0xfffff100
    193c:	2f646c69 	svccs	0x00646c69
    1940:	2d636367 	stclcs	3, cr6, [r3, #-412]!	; 0xfffffe64
    1944:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    1948:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    194c:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    1950:	6c472d69 	mcrrvs	13, 6, r2, r7, cr9
    1954:	39546b39 	ldmdbcc	r4, {r0, r3, r4, r5, r8, r9, fp, sp, lr}^
    1958:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
    195c:	6d72612d 	ldfvse	f6, [r2, #-180]!	; 0xffffff4c
    1960:	6e6f6e2d 	cdpvs	14, 6, cr6, cr15, cr13, {1}
    1964:	61652d65 	cmnvs	r5, r5, ror #26
    1968:	392d6962 	pushcc	{r1, r5, r6, r8, fp, sp, lr}
    196c:	3130322d 	teqcc	r0, sp, lsr #4
    1970:	34712d39 	ldrbtcc	r2, [r1], #-3385	; 0xfffff2c7
    1974:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
    1978:	612f646c 			; <UNDEFINED> instruction: 0x612f646c
    197c:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
    1980:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
    1984:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    1988:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    198c:	7435762f 	ldrtvc	r7, [r5], #-1583	; 0xfffff9d1
    1990:	61682f65 	cmnvs	r8, r5, ror #30
    1994:	6c2f6472 	cfstrsvs	mvf6, [pc], #-456	; 17d4 <shift+0x17d4>
    1998:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    199c:	41540063 	cmpmi	r4, r3, rrx
    19a0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    19a4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    19a8:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    19ac:	61786574 	cmnvs	r8, r4, ror r5
    19b0:	6f633731 	svcvs	0x00633731
    19b4:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    19b8:	69003761 	stmdbvs	r0, {r0, r5, r6, r8, r9, sl, ip, sp}
    19bc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    19c0:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    19c4:	62645f70 	rsbvs	r5, r4, #112, 30	; 0x1c0
    19c8:	7261006c 	rsbvc	r0, r1, #108	; 0x6c
    19cc:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    19d0:	695f6863 	ldmdbvs	pc, {r0, r1, r5, r6, fp, sp, lr}^	; <UNPREDICTABLE>
    19d4:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    19d8:	41540074 	cmpmi	r4, r4, ror r0
    19dc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    19e0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    19e4:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    19e8:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    19ec:	41003332 	tstmi	r0, r2, lsr r3
    19f0:	455f4d52 	ldrbmi	r4, [pc, #-3410]	; ca6 <shift+0xca6>
    19f4:	41540051 	cmpmi	r4, r1, asr r0
    19f8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    19fc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1a00:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1a04:	36353131 			; <UNDEFINED> instruction: 0x36353131
    1a08:	73663274 	cmnvc	r6, #116, 4	; 0x40000007
    1a0c:	61736900 	cmnvs	r3, r0, lsl #18
    1a10:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1a14:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    1a18:	5400626d 	strpl	r6, [r0], #-621	; 0xfffffd93
    1a1c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1a20:	50435f54 	subpl	r5, r3, r4, asr pc
    1a24:	6f635f55 	svcvs	0x00635f55
    1a28:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1a2c:	63373561 	teqvs	r7, #406847488	; 0x18400000
    1a30:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1a34:	33356178 	teqcc	r5, #120, 2
    1a38:	53414200 	movtpl	r4, #4608	; 0x1200
    1a3c:	52415f45 	subpl	r5, r1, #276	; 0x114
    1a40:	385f4843 	ldmdacc	pc, {r0, r1, r6, fp, lr}^	; <UNPREDICTABLE>
    1a44:	41425f4d 	cmpmi	r2, sp, asr #30
    1a48:	54004553 	strpl	r4, [r0], #-1363	; 0xfffffaad
    1a4c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1a50:	50435f54 	subpl	r5, r3, r4, asr pc
    1a54:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1a58:	3031386d 	eorscc	r3, r1, sp, ror #16
    1a5c:	52415400 	subpl	r5, r1, #0, 8
    1a60:	5f544547 	svcpl	0x00544547
    1a64:	5f555043 	svcpl	0x00555043
    1a68:	6e656778 	mcrvs	7, 3, r6, cr5, cr8, {3}
    1a6c:	41003165 	tstmi	r0, r5, ror #2
    1a70:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    1a74:	415f5343 	cmpmi	pc, r3, asr #6
    1a78:	53435041 	movtpl	r5, #12353	; 0x3041
    1a7c:	4d57495f 	vldrmi.16	s9, [r7, #-190]	; 0xffffff42	; <UNPREDICTABLE>
    1a80:	0054584d 	subseq	r5, r4, sp, asr #16
    1a84:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1a88:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1a8c:	00305f48 	eorseq	r5, r0, r8, asr #30
    1a90:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1a94:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1a98:	00325f48 	eorseq	r5, r2, r8, asr #30
    1a9c:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1aa0:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1aa4:	00335f48 	eorseq	r5, r3, r8, asr #30
    1aa8:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1aac:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1ab0:	00345f48 	eorseq	r5, r4, r8, asr #30
    1ab4:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1ab8:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1abc:	00365f48 	eorseq	r5, r6, r8, asr #30
    1ac0:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1ac4:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1ac8:	00375f48 	eorseq	r5, r7, r8, asr #30
    1acc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1ad0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1ad4:	785f5550 	ldmdavc	pc, {r4, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
    1ad8:	6c616373 	stclvs	3, cr6, [r1], #-460	; 0xfffffe34
    1adc:	73690065 	cmnvc	r9, #101	; 0x65
    1ae0:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1ae4:	72705f74 	rsbsvc	r5, r0, #116, 30	; 0x1d0
    1ae8:	65726465 	ldrbvs	r6, [r2, #-1125]!	; 0xfffffb9b
    1aec:	41540073 	cmpmi	r4, r3, ror r0
    1af0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1af4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1af8:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1afc:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1b00:	54003333 	strpl	r3, [r0], #-819	; 0xfffffccd
    1b04:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1b08:	50435f54 	subpl	r5, r3, r4, asr pc
    1b0c:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1b10:	6474376d 	ldrbtvs	r3, [r4], #-1901	; 0xfffff893
    1b14:	6900696d 	stmdbvs	r0, {r0, r2, r3, r5, r6, r8, fp, sp, lr}
    1b18:	6e5f6173 	mrcvs	1, 2, r6, cr15, cr3, {3}
    1b1c:	7469626f 	strbtvc	r6, [r9], #-623	; 0xfffffd91
    1b20:	52415400 	subpl	r5, r1, #0, 8
    1b24:	5f544547 	svcpl	0x00544547
    1b28:	5f555043 	svcpl	0x00555043
    1b2c:	316d7261 	cmncc	sp, r1, ror #4
    1b30:	6a363731 	bvs	d8f7fc <__bss_end+0xd83ec4>
    1b34:	0073667a 	rsbseq	r6, r3, sl, ror r6
    1b38:	5f617369 	svcpl	0x00617369
    1b3c:	5f746962 	svcpl	0x00746962
    1b40:	76706676 			; <UNDEFINED> instruction: 0x76706676
    1b44:	52410032 	subpl	r0, r1, #50	; 0x32
    1b48:	43505f4d 	cmpmi	r0, #308	; 0x134
    1b4c:	4e555f53 	mrcmi	15, 2, r5, cr5, cr3, {2}
    1b50:	574f4e4b 	strbpl	r4, [pc, -fp, asr #28]
    1b54:	4154004e 	cmpmi	r4, lr, asr #32
    1b58:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1b5c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1b60:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1b64:	42006539 	andmi	r6, r0, #239075328	; 0xe400000
    1b68:	5f455341 	svcpl	0x00455341
    1b6c:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1b70:	4554355f 	ldrbmi	r3, [r4, #-1375]	; 0xfffffaa1
    1b74:	7261004a 	rsbvc	r0, r1, #74	; 0x4a
    1b78:	63635f6d 	cmnvs	r3, #436	; 0x1b4
    1b7c:	5f6d7366 	svcpl	0x006d7366
    1b80:	74617473 	strbtvc	r7, [r1], #-1139	; 0xfffffb8d
    1b84:	72610065 	rsbvc	r0, r1, #101	; 0x65
    1b88:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1b8c:	74356863 	ldrtvc	r6, [r5], #-2147	; 0xfffff79d
    1b90:	6e750065 	cdpvs	0, 7, cr0, cr5, cr5, {3}
    1b94:	63657073 	cmnvs	r5, #115	; 0x73
    1b98:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
    1b9c:	73676e69 	cmnvc	r7, #1680	; 0x690
    1ba0:	61736900 	cmnvs	r3, r0, lsl #18
    1ba4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1ba8:	6365735f 	cmnvs	r5, #2080374785	; 0x7c000001
    1bac:	635f5f00 	cmpvs	pc, #0, 30
    1bb0:	745f7a6c 	ldrbvc	r7, [pc], #-2668	; 1bb8 <shift+0x1bb8>
    1bb4:	41006261 	tstmi	r0, r1, ror #4
    1bb8:	565f4d52 			; <UNDEFINED> instruction: 0x565f4d52
    1bbc:	72610043 	rsbvc	r0, r1, #67	; 0x43
    1bc0:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1bc4:	785f6863 	ldmdavc	pc, {r0, r1, r5, r6, fp, sp, lr}^	; <UNPREDICTABLE>
    1bc8:	6c616373 	stclvs	3, cr6, [r1], #-460	; 0xfffffe34
    1bcc:	52410065 	subpl	r0, r1, #101	; 0x65
    1bd0:	454c5f4d 	strbmi	r5, [ip, #-3917]	; 0xfffff0b3
    1bd4:	4d524100 	ldfmie	f4, [r2, #-0]
    1bd8:	0053565f 	subseq	r5, r3, pc, asr r6
    1bdc:	5f4d5241 	svcpl	0x004d5241
    1be0:	61004547 	tstvs	r0, r7, asr #10
    1be4:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 1bec <shift+0x1bec>
    1be8:	5f656e75 	svcpl	0x00656e75
    1bec:	6f727473 	svcvs	0x00727473
    1bf0:	7261676e 	rsbvc	r6, r1, #28835840	; 0x1b80000
    1bf4:	6f63006d 	svcvs	0x0063006d
    1bf8:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    1bfc:	6c662078 	stclvs	0, cr2, [r6], #-480	; 0xfffffe20
    1c00:	0074616f 	rsbseq	r6, r4, pc, ror #2
    1c04:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1c08:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1c0c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1c10:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1c14:	35316178 	ldrcc	r6, [r1, #-376]!	; 0xfffffe88
    1c18:	52415400 	subpl	r5, r1, #0, 8
    1c1c:	5f544547 	svcpl	0x00544547
    1c20:	5f555043 	svcpl	0x00555043
    1c24:	32376166 	eorscc	r6, r7, #-2147483623	; 0x80000019
    1c28:	00657436 	rsbeq	r7, r5, r6, lsr r4
    1c2c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1c30:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1c34:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1c38:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1c3c:	37316178 			; <UNDEFINED> instruction: 0x37316178
    1c40:	4d524100 	ldfmie	f4, [r2, #-0]
    1c44:	0054475f 	subseq	r4, r4, pc, asr r7
    1c48:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1c4c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1c50:	6e5f5550 	mrcvs	5, 2, r5, cr15, cr0, {2}
    1c54:	65766f65 	ldrbvs	r6, [r6, #-3941]!	; 0xfffff09b
    1c58:	6e657372 	mcrvs	3, 3, r7, cr5, cr2, {3}
    1c5c:	2e2e0031 	mcrcs	0, 1, r0, cr14, cr1, {1}
    1c60:	2f2e2e2f 	svccs	0x002e2e2f
    1c64:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1c68:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1c6c:	2f2e2e2f 	svccs	0x002e2e2f
    1c70:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1c74:	6c2f6363 	stcvs	3, cr6, [pc], #-396	; 1af0 <shift+0x1af0>
    1c78:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1c7c:	632e3263 			; <UNDEFINED> instruction: 0x632e3263
    1c80:	52415400 	subpl	r5, r1, #0, 8
    1c84:	5f544547 	svcpl	0x00544547
    1c88:	5f555043 	svcpl	0x00555043
    1c8c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1c90:	34727865 	ldrbtcc	r7, [r2], #-2149	; 0xfffff79b
    1c94:	41420066 	cmpmi	r2, r6, rrx
    1c98:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1c9c:	5f484352 	svcpl	0x00484352
    1ca0:	004d4537 	subeq	r4, sp, r7, lsr r5
    1ca4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1ca8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1cac:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1cb0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1cb4:	32316178 	eorscc	r6, r1, #120, 2
    1cb8:	73616800 	cmnvc	r1, #0, 16
    1cbc:	6c617668 	stclvs	6, cr7, [r1], #-416	; 0xfffffe60
    1cc0:	4200745f 	andmi	r7, r0, #1593835520	; 0x5f000000
    1cc4:	5f455341 	svcpl	0x00455341
    1cc8:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1ccc:	5a4b365f 	bpl	12cf650 <__bss_end+0x12c3d18>
    1cd0:	61736900 	cmnvs	r3, r0, lsl #18
    1cd4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1cd8:	72610073 	rsbvc	r0, r1, #115	; 0x73
    1cdc:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1ce0:	615f6863 	cmpvs	pc, r3, ror #16
    1ce4:	685f6d72 	ldmdavs	pc, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^	; <UNPREDICTABLE>
    1ce8:	76696477 			; <UNDEFINED> instruction: 0x76696477
    1cec:	6d726100 	ldfvse	f6, [r2, #-0]
    1cf0:	7570665f 	ldrbvc	r6, [r0, #-1631]!	; 0xfffff9a1
    1cf4:	7365645f 	cmnvc	r5, #1593835520	; 0x5f000000
    1cf8:	73690063 	cmnvc	r9, #99	; 0x63
    1cfc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1d00:	70665f74 	rsbvc	r5, r6, r4, ror pc
    1d04:	47003631 	smladxmi	r0, r1, r6, r3
    1d08:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
    1d0c:	39203731 	stmdbcc	r0!, {r0, r4, r5, r8, r9, sl, ip, sp}
    1d10:	312e322e 			; <UNDEFINED> instruction: 0x312e322e
    1d14:	31303220 	teqcc	r0, r0, lsr #4
    1d18:	32303139 	eorscc	r3, r0, #1073741838	; 0x4000000e
    1d1c:	72282035 	eorvc	r2, r8, #53	; 0x35
    1d20:	61656c65 	cmnvs	r5, r5, ror #24
    1d24:	20296573 	eorcs	r6, r9, r3, ror r5
    1d28:	4d52415b 	ldfmie	f4, [r2, #-364]	; 0xfffffe94
    1d2c:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    1d30:	622d392d 	eorvs	r3, sp, #737280	; 0xb4000
    1d34:	636e6172 	cmnvs	lr, #-2147483620	; 0x8000001c
    1d38:	65722068 	ldrbvs	r2, [r2, #-104]!	; 0xffffff98
    1d3c:	69736976 	ldmdbvs	r3!, {r1, r2, r4, r5, r6, r8, fp, sp, lr}^
    1d40:	32206e6f 	eorcc	r6, r0, #1776	; 0x6f0
    1d44:	39353737 	ldmdbcc	r5!, {r0, r1, r2, r4, r5, r8, r9, sl, ip, sp}
    1d48:	2d205d39 	stccs	13, cr5, [r0, #-228]!	; 0xffffff1c
    1d4c:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
    1d50:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    1d54:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    1d58:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
    1d5c:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
    1d60:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
    1d64:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1d68:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
    1d6c:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
    1d70:	2070662b 	rsbscs	r6, r0, fp, lsr #12
    1d74:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    1d78:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    1d7c:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    1d80:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    1d84:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    1d88:	62662d20 	rsbvs	r2, r6, #32, 26	; 0x800
    1d8c:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    1d90:	2d676e69 	stclcs	14, cr6, [r7, #-420]!	; 0xfffffe5c
    1d94:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1d98:	2d206363 	stccs	3, cr6, [r0, #-396]!	; 0xfffffe74
    1d9c:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 1c0c <shift+0x1c0c>
    1da0:	63617473 	cmnvs	r1, #1929379840	; 0x73000000
    1da4:	72702d6b 	rsbsvc	r2, r0, #6848	; 0x1ac0
    1da8:	6365746f 	cmnvs	r5, #1862270976	; 0x6f000000
    1dac:	20726f74 	rsbscs	r6, r2, r4, ror pc
    1db0:	6f6e662d 	svcvs	0x006e662d
    1db4:	6c6e692d 			; <UNDEFINED> instruction: 0x6c6e692d
    1db8:	20656e69 	rsbcs	r6, r5, r9, ror #28
    1dbc:	6976662d 	ldmdbvs	r6!, {r0, r2, r3, r5, r9, sl, sp, lr}^
    1dc0:	69626973 	stmdbvs	r2!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
    1dc4:	7974696c 	ldmdbvc	r4!, {r2, r3, r5, r6, r8, fp, sp, lr}^
    1dc8:	6469683d 	strbtvs	r6, [r9], #-2109	; 0xfffff7c3
    1dcc:	006e6564 	rsbeq	r6, lr, r4, ror #10
    1dd0:	5f4d5241 	svcpl	0x004d5241
    1dd4:	69004948 	stmdbvs	r0, {r3, r6, r8, fp, lr}
    1dd8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1ddc:	615f7469 	cmpvs	pc, r9, ror #8
    1de0:	00766964 	rsbseq	r6, r6, r4, ror #18
    1de4:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1de8:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1dec:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1df0:	31316d72 	teqcc	r1, r2, ror sp
    1df4:	736a3633 	cmnvc	sl, #53477376	; 0x3300000
    1df8:	52415400 	subpl	r5, r1, #0, 8
    1dfc:	5f544547 	svcpl	0x00544547
    1e00:	5f555043 	svcpl	0x00555043
    1e04:	386d7261 	stmdacc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    1e08:	52415400 	subpl	r5, r1, #0, 8
    1e0c:	5f544547 	svcpl	0x00544547
    1e10:	5f555043 	svcpl	0x00555043
    1e14:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    1e18:	52415400 	subpl	r5, r1, #0, 8
    1e1c:	5f544547 	svcpl	0x00544547
    1e20:	5f555043 	svcpl	0x00555043
    1e24:	32366166 	eorscc	r6, r6, #-2147483623	; 0x80000019
    1e28:	6f6c0036 	svcvs	0x006c0036
    1e2c:	6c20676e 	stcvs	7, cr6, [r0], #-440	; 0xfffffe48
    1e30:	20676e6f 	rsbcs	r6, r7, pc, ror #28
    1e34:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
    1e38:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
    1e3c:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
    1e40:	6d726100 	ldfvse	f6, [r2, #-0]
    1e44:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1e48:	6d635f68 	stclvs	15, cr5, [r3, #-416]!	; 0xfffffe60
    1e4c:	54006573 	strpl	r6, [r0], #-1395	; 0xfffffa8d
    1e50:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1e54:	50435f54 	subpl	r5, r3, r4, asr pc
    1e58:	6f635f55 	svcvs	0x00635f55
    1e5c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1e60:	5400346d 	strpl	r3, [r0], #-1133	; 0xfffffb93
    1e64:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1e68:	50435f54 	subpl	r5, r3, r4, asr pc
    1e6c:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1e70:	6530316d 	ldrvs	r3, [r0, #-365]!	; 0xfffffe93
    1e74:	52415400 	subpl	r5, r1, #0, 8
    1e78:	5f544547 	svcpl	0x00544547
    1e7c:	5f555043 	svcpl	0x00555043
    1e80:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1e84:	376d7865 	strbcc	r7, [sp, -r5, ror #16]!
    1e88:	6d726100 	ldfvse	f6, [r2, #-0]
    1e8c:	6e6f635f 	mcrvs	3, 3, r6, cr15, cr15, {2}
    1e90:	6f635f64 	svcvs	0x00635f64
    1e94:	41006564 	tstmi	r0, r4, ror #10
    1e98:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    1e9c:	415f5343 	cmpmi	pc, r3, asr #6
    1ea0:	53435041 	movtpl	r5, #12353	; 0x3041
    1ea4:	61736900 	cmnvs	r3, r0, lsl #18
    1ea8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1eac:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1eb0:	325f3876 	subscc	r3, pc, #7733248	; 0x760000
    1eb4:	53414200 	movtpl	r4, #4608	; 0x1200
    1eb8:	52415f45 	subpl	r5, r1, #276	; 0x114
    1ebc:	335f4843 	cmpcc	pc, #4390912	; 0x430000
    1ec0:	4154004d 	cmpmi	r4, sp, asr #32
    1ec4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1ec8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1ecc:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1ed0:	74303137 	ldrtvc	r3, [r0], #-311	; 0xfffffec9
    1ed4:	6d726100 	ldfvse	f6, [r2, #-0]
    1ed8:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1edc:	77695f68 	strbvc	r5, [r9, -r8, ror #30]!
    1ee0:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    1ee4:	73690032 	cmnvc	r9, #50	; 0x32
    1ee8:	756e5f61 	strbvc	r5, [lr, #-3937]!	; 0xfffff09f
    1eec:	69625f6d 	stmdbvs	r2!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    1ef0:	54007374 	strpl	r7, [r0], #-884	; 0xfffffc8c
    1ef4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1ef8:	50435f54 	subpl	r5, r3, r4, asr pc
    1efc:	6f635f55 	svcvs	0x00635f55
    1f00:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1f04:	6c70306d 	ldclvs	0, cr3, [r0], #-436	; 0xfffffe4c
    1f08:	6d737375 	ldclvs	3, cr7, [r3, #-468]!	; 0xfffffe2c
    1f0c:	6d6c6c61 	stclvs	12, cr6, [ip, #-388]!	; 0xfffffe7c
    1f10:	69746c75 	ldmdbvs	r4!, {r0, r2, r4, r5, r6, sl, fp, sp, lr}^
    1f14:	00796c70 	rsbseq	r6, r9, r0, ror ip
    1f18:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1f1c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1f20:	655f5550 	ldrbvs	r5, [pc, #-1360]	; 19d8 <shift+0x19d8>
    1f24:	6f6e7978 	svcvs	0x006e7978
    1f28:	00316d73 	eorseq	r6, r1, r3, ror sp
    1f2c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1f30:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1f34:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1f38:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1f3c:	32357278 	eorscc	r7, r5, #120, 4	; 0x80000007
    1f40:	61736900 	cmnvs	r3, r0, lsl #18
    1f44:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1f48:	6964745f 	stmdbvs	r4!, {r0, r1, r2, r3, r4, r6, sl, ip, sp, lr}^
    1f4c:	72700076 	rsbsvc	r0, r0, #118	; 0x76
    1f50:	72656665 	rsbvc	r6, r5, #105906176	; 0x6500000
    1f54:	6f656e5f 	svcvs	0x00656e5f
    1f58:	6f665f6e 	svcvs	0x00665f6e
    1f5c:	34365f72 	ldrtcc	r5, [r6], #-3954	; 0xfffff08e
    1f60:	73746962 	cmnvc	r4, #1605632	; 0x188000
    1f64:	61736900 	cmnvs	r3, r0, lsl #18
    1f68:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1f6c:	3170665f 	cmncc	r0, pc, asr r6
    1f70:	6c6d6636 	stclvs	6, cr6, [sp], #-216	; 0xffffff28
    1f74:	52415400 	subpl	r5, r1, #0, 8
    1f78:	5f544547 	svcpl	0x00544547
    1f7c:	5f555043 	svcpl	0x00555043
    1f80:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1f84:	33617865 	cmncc	r1, #6619136	; 0x650000
    1f88:	41540032 	cmpmi	r4, r2, lsr r0
    1f8c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1f90:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1f94:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1f98:	61786574 	cmnvs	r8, r4, ror r5
    1f9c:	69003533 	stmdbvs	r0, {r0, r1, r4, r5, r8, sl, ip, sp}
    1fa0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1fa4:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1fa8:	63363170 	teqvs	r6, #112, 2
    1fac:	00766e6f 	rsbseq	r6, r6, pc, ror #28
    1fb0:	70736e75 	rsbsvc	r6, r3, r5, ror lr
    1fb4:	5f766365 	svcpl	0x00766365
    1fb8:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    1fbc:	0073676e 	rsbseq	r6, r3, lr, ror #14
    1fc0:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1fc4:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1fc8:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1fcc:	31316d72 	teqcc	r1, r2, ror sp
    1fd0:	32743635 	rsbscc	r3, r4, #55574528	; 0x3500000
    1fd4:	41540073 	cmpmi	r4, r3, ror r0
    1fd8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1fdc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1fe0:	3661665f 			; <UNDEFINED> instruction: 0x3661665f
    1fe4:	65743630 	ldrbvs	r3, [r4, #-1584]!	; 0xfffff9d0
    1fe8:	52415400 	subpl	r5, r1, #0, 8
    1fec:	5f544547 	svcpl	0x00544547
    1ff0:	5f555043 	svcpl	0x00555043
    1ff4:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    1ff8:	6a653632 	bvs	194f8c8 <__bss_end+0x1943f90>
    1ffc:	41420073 	hvcmi	8195	; 0x2003
    2000:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    2004:	5f484352 	svcpl	0x00484352
    2008:	69005434 	stmdbvs	r0, {r2, r4, r5, sl, ip, lr}
    200c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2010:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    2014:	74707972 	ldrbtvc	r7, [r0], #-2418	; 0xfffff68e
    2018:	7261006f 	rsbvc	r0, r1, #111	; 0x6f
    201c:	65725f6d 	ldrbvs	r5, [r2, #-3949]!	; 0xfffff093
    2020:	695f7367 	ldmdbvs	pc, {r0, r1, r2, r5, r6, r8, r9, ip, sp, lr}^	; <UNPREDICTABLE>
    2024:	65735f6e 	ldrbvs	r5, [r3, #-3950]!	; 0xfffff092
    2028:	6e657571 	mcrvs	5, 3, r7, cr5, cr1, {3}
    202c:	69006563 	stmdbvs	r0, {r0, r1, r5, r6, r8, sl, sp, lr}
    2030:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2034:	735f7469 	cmpvc	pc, #1761607680	; 0x69000000
    2038:	41420062 	cmpmi	r2, r2, rrx
    203c:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    2040:	5f484352 	svcpl	0x00484352
    2044:	00455435 	subeq	r5, r5, r5, lsr r4
    2048:	5f617369 	svcpl	0x00617369
    204c:	74616566 	strbtvc	r6, [r1], #-1382	; 0xfffffa9a
    2050:	00657275 	rsbeq	r7, r5, r5, ror r2
    2054:	5f617369 	svcpl	0x00617369
    2058:	5f746962 	svcpl	0x00746962
    205c:	6c616d73 	stclvs	13, cr6, [r1], #-460	; 0xfffffe34
    2060:	6c756d6c 	ldclvs	13, cr6, [r5], #-432	; 0xfffffe50
    2064:	6d726100 	ldfvse	f6, [r2, #-0]
    2068:	6e616c5f 	mcrvs	12, 3, r6, cr1, cr15, {2}
    206c:	756f5f67 	strbvc	r5, [pc, #-3943]!	; 110d <shift+0x110d>
    2070:	74757074 	ldrbtvc	r7, [r5], #-116	; 0xffffff8c
    2074:	6a626f5f 	bvs	189ddf8 <__bss_end+0x18924c0>
    2078:	5f746365 	svcpl	0x00746365
    207c:	72747461 	rsbsvc	r7, r4, #1627389952	; 0x61000000
    2080:	74756269 	ldrbtvc	r6, [r5], #-617	; 0xfffffd97
    2084:	685f7365 	ldmdavs	pc, {r0, r2, r5, r6, r8, r9, ip, sp, lr}^	; <UNPREDICTABLE>
    2088:	006b6f6f 	rsbeq	r6, fp, pc, ror #30
    208c:	5f617369 	svcpl	0x00617369
    2090:	5f746962 	svcpl	0x00746962
    2094:	645f7066 	ldrbvs	r7, [pc], #-102	; 209c <shift+0x209c>
    2098:	41003233 	tstmi	r0, r3, lsr r2
    209c:	4e5f4d52 	mrcmi	13, 2, r4, cr15, cr2, {2}
    20a0:	73690045 	cmnvc	r9, #69	; 0x45
    20a4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    20a8:	65625f74 	strbvs	r5, [r2, #-3956]!	; 0xfffff08c
    20ac:	41540038 	cmpmi	r4, r8, lsr r0
    20b0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    20b4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    20b8:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    20bc:	36373131 			; <UNDEFINED> instruction: 0x36373131
    20c0:	00737a6a 	rsbseq	r7, r3, sl, ror #20
    20c4:	636f7270 	cmnvs	pc, #112, 4
    20c8:	6f737365 	svcvs	0x00737365
    20cc:	79745f72 	ldmdbvc	r4!, {r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    20d0:	61006570 	tstvs	r0, r0, ror r5
    20d4:	665f6c6c 	ldrbvs	r6, [pc], -ip, ror #24
    20d8:	00737570 	rsbseq	r7, r3, r0, ror r5
    20dc:	5f6d7261 	svcpl	0x006d7261
    20e0:	00736370 	rsbseq	r6, r3, r0, ror r3
    20e4:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    20e8:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    20ec:	54355f48 	ldrtpl	r5, [r5], #-3912	; 0xfffff0b8
    20f0:	6d726100 	ldfvse	f6, [r2, #-0]
    20f4:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    20f8:	00743468 	rsbseq	r3, r4, r8, ror #8
    20fc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2100:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2104:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2108:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    210c:	36376178 			; <UNDEFINED> instruction: 0x36376178
    2110:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2114:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    2118:	72610035 	rsbvc	r0, r1, #53	; 0x35
    211c:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    2120:	775f656e 	ldrbvc	r6, [pc, -lr, ror #10]
    2124:	00667562 	rsbeq	r7, r6, r2, ror #10
    2128:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
    212c:	7361685f 	cmnvc	r1, #6225920	; 0x5f0000
    2130:	73690068 	cmnvc	r9, #104	; 0x68
    2134:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2138:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    213c:	5f6b7269 	svcpl	0x006b7269
    2140:	765f6f6e 	ldrbvc	r6, [pc], -lr, ror #30
    2144:	74616c6f 	strbtvc	r6, [r1], #-3183	; 0xfffff391
    2148:	5f656c69 	svcpl	0x00656c69
    214c:	54006563 	strpl	r6, [r0], #-1379	; 0xfffffa9d
    2150:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2154:	50435f54 	subpl	r5, r3, r4, asr pc
    2158:	6f635f55 	svcvs	0x00635f55
    215c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2160:	5400306d 	strpl	r3, [r0], #-109	; 0xffffff93
    2164:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2168:	50435f54 	subpl	r5, r3, r4, asr pc
    216c:	6f635f55 	svcvs	0x00635f55
    2170:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2174:	5400316d 	strpl	r3, [r0], #-365	; 0xfffffe93
    2178:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    217c:	50435f54 	subpl	r5, r3, r4, asr pc
    2180:	6f635f55 	svcvs	0x00635f55
    2184:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2188:	6900336d 	stmdbvs	r0, {r0, r2, r3, r5, r6, r8, r9, ip, sp}
    218c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2190:	615f7469 	cmpvs	pc, r9, ror #8
    2194:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    2198:	6100315f 	tstvs	r0, pc, asr r1
    219c:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    21a0:	5f686372 	svcpl	0x00686372
    21a4:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
    21a8:	61736900 	cmnvs	r3, r0, lsl #18
    21ac:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    21b0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    21b4:	335f3876 	cmpcc	pc, #7733248	; 0x760000
    21b8:	61736900 	cmnvs	r3, r0, lsl #18
    21bc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    21c0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    21c4:	345f3876 	ldrbcc	r3, [pc], #-2166	; 21cc <shift+0x21cc>
    21c8:	61736900 	cmnvs	r3, r0, lsl #18
    21cc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    21d0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    21d4:	355f3876 	ldrbcc	r3, [pc, #-2166]	; 1966 <shift+0x1966>
    21d8:	52415400 	subpl	r5, r1, #0, 8
    21dc:	5f544547 	svcpl	0x00544547
    21e0:	5f555043 	svcpl	0x00555043
    21e4:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    21e8:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    21ec:	41540033 	cmpmi	r4, r3, lsr r0
    21f0:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    21f4:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    21f8:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    21fc:	61786574 	cmnvs	r8, r4, ror r5
    2200:	54003535 	strpl	r3, [r0], #-1333	; 0xfffffacb
    2204:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2208:	50435f54 	subpl	r5, r3, r4, asr pc
    220c:	6f635f55 	svcvs	0x00635f55
    2210:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2214:	00373561 	eorseq	r3, r7, r1, ror #10
    2218:	47524154 			; <UNDEFINED> instruction: 0x47524154
    221c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2220:	6d5f5550 	cfldr64vs	mvdx5, [pc, #-320]	; 20e8 <shift+0x20e8>
    2224:	726f6370 	rsbvc	r6, pc, #112, 6	; 0xc0000001
    2228:	41540065 	cmpmi	r4, r5, rrx
    222c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2230:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2234:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2238:	6e6f6e5f 	mcrvs	14, 3, r6, cr15, cr15, {2}
    223c:	72610065 	rsbvc	r0, r1, #101	; 0x65
    2240:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2244:	6e5f6863 	cdpvs	8, 5, cr6, cr15, cr3, {3}
    2248:	006d746f 	rsbeq	r7, sp, pc, ror #8
    224c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2250:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2254:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    2258:	30316d72 	eorscc	r6, r1, r2, ror sp
    225c:	6a653632 	bvs	194fb2c <__bss_end+0x19441f4>
    2260:	41420073 	hvcmi	8195	; 0x2003
    2264:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    2268:	5f484352 	svcpl	0x00484352
    226c:	42004a36 	andmi	r4, r0, #221184	; 0x36000
    2270:	5f455341 	svcpl	0x00455341
    2274:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    2278:	004b365f 	subeq	r3, fp, pc, asr r6
    227c:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    2280:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    2284:	4d365f48 	ldcmi	15, cr5, [r6, #-288]!	; 0xfffffee0
    2288:	61736900 	cmnvs	r3, r0, lsl #18
    228c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2290:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    2294:	0074786d 	rsbseq	r7, r4, sp, ror #16
    2298:	47524154 			; <UNDEFINED> instruction: 0x47524154
    229c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    22a0:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    22a4:	31316d72 	teqcc	r1, r2, ror sp
    22a8:	666a3633 			; <UNDEFINED> instruction: 0x666a3633
    22ac:	52410073 	subpl	r0, r1, #115	; 0x73
    22b0:	534c5f4d 	movtpl	r5, #53069	; 0xcf4d
    22b4:	4d524100 	ldfmie	f4, [r2, #-0]
    22b8:	00544c5f 	subseq	r4, r4, pc, asr ip
    22bc:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    22c0:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    22c4:	5a365f48 	bpl	d99fec <__bss_end+0xd8e6b4>
    22c8:	52415400 	subpl	r5, r1, #0, 8
    22cc:	5f544547 	svcpl	0x00544547
    22d0:	5f555043 	svcpl	0x00555043
    22d4:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    22d8:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    22dc:	726f6335 	rsbvc	r6, pc, #-738197504	; 0xd4000000
    22e0:	61786574 	cmnvs	r8, r4, ror r5
    22e4:	41003535 	tstmi	r0, r5, lsr r5
    22e8:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    22ec:	415f5343 	cmpmi	pc, r3, asr #6
    22f0:	53435041 	movtpl	r5, #12353	; 0x3041
    22f4:	5046565f 	subpl	r5, r6, pc, asr r6
    22f8:	52415400 	subpl	r5, r1, #0, 8
    22fc:	5f544547 	svcpl	0x00544547
    2300:	5f555043 	svcpl	0x00555043
    2304:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    2308:	00327478 	eorseq	r7, r2, r8, ror r4
    230c:	5f617369 	svcpl	0x00617369
    2310:	5f746962 	svcpl	0x00746962
    2314:	6e6f656e 	cdpvs	5, 6, cr6, cr15, cr14, {3}
    2318:	6d726100 	ldfvse	f6, [r2, #-0]
    231c:	7570665f 	ldrbvc	r6, [r0, #-1631]!	; 0xfffff9a1
    2320:	7474615f 	ldrbtvc	r6, [r4], #-351	; 0xfffffea1
    2324:	73690072 	cmnvc	r9, #114	; 0x72
    2328:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    232c:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    2330:	6537766d 	ldrvs	r7, [r7, #-1645]!	; 0xfffff993
    2334:	4154006d 	cmpmi	r4, sp, rrx
    2338:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    233c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2340:	3661665f 			; <UNDEFINED> instruction: 0x3661665f
    2344:	65743632 	ldrbvs	r3, [r4, #-1586]!	; 0xfffff9ce
    2348:	52415400 	subpl	r5, r1, #0, 8
    234c:	5f544547 	svcpl	0x00544547
    2350:	5f555043 	svcpl	0x00555043
    2354:	7672616d 	ldrbtvc	r6, [r2], -sp, ror #2
    2358:	5f6c6c65 	svcpl	0x006c6c65
    235c:	00346a70 	eorseq	r6, r4, r0, ror sl
    2360:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
    2364:	7361685f 	cmnvc	r1, #6225920	; 0x5f0000
    2368:	6f705f68 	svcvs	0x00705f68
    236c:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
    2370:	72610072 	rsbvc	r0, r1, #114	; 0x72
    2374:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    2378:	635f656e 	cmpvs	pc, #461373440	; 0x1b800000
    237c:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2380:	39615f78 	stmdbcc	r1!, {r3, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    2384:	61736900 	cmnvs	r3, r0, lsl #18
    2388:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    238c:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    2390:	3274786d 	rsbscc	r7, r4, #7143424	; 0x6d0000
    2394:	52415400 	subpl	r5, r1, #0, 8
    2398:	5f544547 	svcpl	0x00544547
    239c:	5f555043 	svcpl	0x00555043
    23a0:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    23a4:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    23a8:	726f6332 	rsbvc	r6, pc, #-939524096	; 0xc8000000
    23ac:	61786574 	cmnvs	r8, r4, ror r5
    23b0:	69003335 	stmdbvs	r0, {r0, r2, r4, r5, r8, r9, ip, sp}
    23b4:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    23b8:	745f7469 	ldrbvc	r7, [pc], #-1129	; 23c0 <shift+0x23c0>
    23bc:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    23c0:	41420032 	cmpmi	r2, r2, lsr r0
    23c4:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    23c8:	5f484352 	svcpl	0x00484352
    23cc:	69004137 	stmdbvs	r0, {r0, r1, r2, r4, r5, r8, lr}
    23d0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    23d4:	645f7469 	ldrbvs	r7, [pc], #-1129	; 23dc <shift+0x23dc>
    23d8:	7270746f 	rsbsvc	r7, r0, #1862270976	; 0x6f000000
    23dc:	6100646f 	tstvs	r0, pc, ror #8
    23e0:	665f6d72 			; <UNDEFINED> instruction: 0x665f6d72
    23e4:	5f363170 	svcpl	0x00363170
    23e8:	65707974 	ldrbvs	r7, [r0, #-2420]!	; 0xfffff68c
    23ec:	646f6e5f 	strbtvs	r6, [pc], #-3679	; 23f4 <shift+0x23f4>
    23f0:	52410065 	subpl	r0, r1, #101	; 0x65
    23f4:	494d5f4d 	stmdbmi	sp, {r0, r2, r3, r6, r8, r9, sl, fp, ip, lr}^
    23f8:	6d726100 	ldfvse	f6, [r2, #-0]
    23fc:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2400:	006b3668 	rsbeq	r3, fp, r8, ror #12
    2404:	5f6d7261 	svcpl	0x006d7261
    2408:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    240c:	42006d36 	andmi	r6, r0, #3456	; 0xd80
    2410:	5f455341 	svcpl	0x00455341
    2414:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    2418:	0052375f 	subseq	r3, r2, pc, asr r7
    241c:	6f705f5f 	svcvs	0x00705f5f
    2420:	756f6370 	strbvc	r6, [pc, #-880]!	; 20b8 <shift+0x20b8>
    2424:	745f746e 	ldrbvc	r7, [pc], #-1134	; 242c <shift+0x242c>
    2428:	69006261 	stmdbvs	r0, {r0, r5, r6, r9, sp, lr}
    242c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2430:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    2434:	0065736d 	rsbeq	r7, r5, sp, ror #6
    2438:	47524154 			; <UNDEFINED> instruction: 0x47524154
    243c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2440:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2444:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2448:	33376178 	teqcc	r7, #120, 2
    244c:	52415400 	subpl	r5, r1, #0, 8
    2450:	5f544547 	svcpl	0x00544547
    2454:	5f555043 	svcpl	0x00555043
    2458:	656e6567 	strbvs	r6, [lr, #-1383]!	; 0xfffffa99
    245c:	76636972 			; <UNDEFINED> instruction: 0x76636972
    2460:	54006137 	strpl	r6, [r0], #-311	; 0xfffffec9
    2464:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2468:	50435f54 	subpl	r5, r3, r4, asr pc
    246c:	6f635f55 	svcvs	0x00635f55
    2470:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2474:	00363761 	eorseq	r3, r6, r1, ror #14
    2478:	5f6d7261 	svcpl	0x006d7261
    247c:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2480:	5f6f6e5f 	svcpl	0x006f6e5f
    2484:	616c6f76 	smcvs	50934	; 0xc6f6
    2488:	656c6974 	strbvs	r6, [ip, #-2420]!	; 0xfffff68c
    248c:	0065635f 	rsbeq	r6, r5, pc, asr r3
    2490:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    2494:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    2498:	41385f48 	teqmi	r8, r8, asr #30
    249c:	61736900 	cmnvs	r3, r0, lsl #18
    24a0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    24a4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    24a8:	00743576 	rsbseq	r3, r4, r6, ror r5
    24ac:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    24b0:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    24b4:	52385f48 	eorspl	r5, r8, #72, 30	; 0x120
    24b8:	52415400 	subpl	r5, r1, #0, 8
    24bc:	5f544547 	svcpl	0x00544547
    24c0:	5f555043 	svcpl	0x00555043
    24c4:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    24c8:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    24cc:	726f6333 	rsbvc	r6, pc, #-872415232	; 0xcc000000
    24d0:	61786574 	cmnvs	r8, r4, ror r5
    24d4:	41003533 	tstmi	r0, r3, lsr r5
    24d8:	4e5f4d52 	mrcmi	13, 2, r4, cr15, cr2, {2}
    24dc:	72610056 	rsbvc	r0, r1, #86	; 0x56
    24e0:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    24e4:	00346863 	eorseq	r6, r4, r3, ror #16
    24e8:	5f6d7261 	svcpl	0x006d7261
    24ec:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    24f0:	72610036 	rsbvc	r0, r1, #54	; 0x36
    24f4:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    24f8:	00376863 	eorseq	r6, r7, r3, ror #16
    24fc:	5f6d7261 	svcpl	0x006d7261
    2500:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2504:	6f6c0038 	svcvs	0x006c0038
    2508:	6420676e 	strtvs	r6, [r0], #-1902	; 0xfffff892
    250c:	6c62756f 	cfstr64vs	mvdx7, [r2], #-444	; 0xfffffe44
    2510:	72610065 	rsbvc	r0, r1, #101	; 0x65
    2514:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    2518:	785f656e 	ldmdavc	pc, {r1, r2, r3, r5, r6, r8, sl, sp, lr}^	; <UNPREDICTABLE>
    251c:	6c616373 	stclvs	3, cr6, [r1], #-460	; 0xfffffe34
    2520:	616d0065 	cmnvs	sp, r5, rrx
    2524:	676e696b 	strbvs	r6, [lr, -fp, ror #18]!
    2528:	6e6f635f 	mcrvs	3, 3, r6, cr15, cr15, {2}
    252c:	745f7473 	ldrbvc	r7, [pc], #-1139	; 2534 <shift+0x2534>
    2530:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
    2534:	75687400 	strbvc	r7, [r8, #-1024]!	; 0xfffffc00
    2538:	635f626d 	cmpvs	pc, #-805306362	; 0xd0000006
    253c:	5f6c6c61 	svcpl	0x006c6c61
    2540:	5f616976 	svcpl	0x00616976
    2544:	6562616c 	strbvs	r6, [r2, #-364]!	; 0xfffffe94
    2548:	7369006c 	cmnvc	r9, #108	; 0x6c
    254c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2550:	70665f74 	rsbvc	r5, r6, r4, ror pc
    2554:	69003576 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, sl, ip, sp}
    2558:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    255c:	615f7469 	cmpvs	pc, r9, ror #8
    2560:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    2564:	4154006b 	cmpmi	r4, fp, rrx
    2568:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    256c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2570:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2574:	61786574 	cmnvs	r8, r4, ror r5
    2578:	41540037 	cmpmi	r4, r7, lsr r0
    257c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2580:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2584:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2588:	61786574 	cmnvs	r8, r4, ror r5
    258c:	41540038 	cmpmi	r4, r8, lsr r0
    2590:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2594:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2598:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    259c:	61786574 	cmnvs	r8, r4, ror r5
    25a0:	52410039 	subpl	r0, r1, #57	; 0x39
    25a4:	43505f4d 	cmpmi	r0, #308	; 0x134
    25a8:	50415f53 	subpl	r5, r1, r3, asr pc
    25ac:	41005343 	tstmi	r0, r3, asr #6
    25b0:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    25b4:	415f5343 	cmpmi	pc, r3, asr #6
    25b8:	53435054 	movtpl	r5, #12372	; 0x3054
    25bc:	6d6f6300 	stclvs	3, cr6, [pc, #-0]	; 25c4 <shift+0x25c4>
    25c0:	78656c70 	stmdavc	r5!, {r4, r5, r6, sl, fp, sp, lr}^
    25c4:	756f6420 	strbvc	r6, [pc, #-1056]!	; 21ac <shift+0x21ac>
    25c8:	00656c62 	rsbeq	r6, r5, r2, ror #24
    25cc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    25d0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    25d4:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    25d8:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    25dc:	33376178 	teqcc	r7, #120, 2
    25e0:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    25e4:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    25e8:	41540033 	cmpmi	r4, r3, lsr r0
    25ec:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    25f0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    25f4:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    25f8:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    25fc:	756c7030 	strbvc	r7, [ip, #-48]!	; 0xffffffd0
    2600:	72610073 	rsbvc	r0, r1, #115	; 0x73
    2604:	63635f6d 	cmnvs	r3, #436	; 0x1b4
    2608:	61736900 	cmnvs	r3, r0, lsl #18
    260c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2610:	6373785f 	cmnvs	r3, #6225920	; 0x5f0000
    2614:	00656c61 	rsbeq	r6, r5, r1, ror #24
    2618:	6e6f645f 	mcrvs	4, 3, r6, cr15, cr15, {2}
    261c:	73755f74 	cmnvc	r5, #116, 30	; 0x1d0
    2620:	72745f65 	rsbsvc	r5, r4, #404	; 0x194
    2624:	685f6565 	ldmdavs	pc, {r0, r2, r5, r6, r8, sl, sp, lr}^	; <UNPREDICTABLE>
    2628:	5f657265 	svcpl	0x00657265
    262c:	52415400 	subpl	r5, r1, #0, 8
    2630:	5f544547 	svcpl	0x00544547
    2634:	5f555043 	svcpl	0x00555043
    2638:	316d7261 	cmncc	sp, r1, ror #4
    263c:	6d647430 	cfstrdvs	mvd7, [r4, #-192]!	; 0xffffff40
    2640:	41540069 	cmpmi	r4, r9, rrx
    2644:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2648:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    264c:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2650:	61786574 	cmnvs	r8, r4, ror r5
    2654:	61620035 	cmnvs	r2, r5, lsr r0
    2658:	615f6573 	cmpvs	pc, r3, ror r5	; <UNPREDICTABLE>
    265c:	69686372 	stmdbvs	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    2660:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
    2664:	00657275 	rsbeq	r7, r5, r5, ror r2
    2668:	5f6d7261 	svcpl	0x006d7261
    266c:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    2670:	6372635f 	cmnvs	r2, #2080374785	; 0x7c000001
    2674:	52415400 	subpl	r5, r1, #0, 8
    2678:	5f544547 	svcpl	0x00544547
    267c:	5f555043 	svcpl	0x00555043
    2680:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2684:	316d7865 	cmncc	sp, r5, ror #16
    2688:	6c616d73 	stclvs	13, cr6, [r1], #-460	; 0xfffffe34
    268c:	6c756d6c 	ldclvs	13, cr6, [r5], #-432	; 0xfffffe50
    2690:	6c706974 			; <UNDEFINED> instruction: 0x6c706974
    2694:	72610079 	rsbvc	r0, r1, #121	; 0x79
    2698:	75635f6d 	strbvc	r5, [r3, #-3949]!	; 0xfffff093
    269c:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
    26a0:	63635f74 	cmnvs	r3, #116, 30	; 0x1d0
    26a4:	61736900 	cmnvs	r3, r0, lsl #18
    26a8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    26ac:	6372635f 	cmnvs	r2, #2080374785	; 0x7c000001
    26b0:	41003233 	tstmi	r0, r3, lsr r2
    26b4:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    26b8:	7369004c 	cmnvc	r9, #76	; 0x4c
    26bc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    26c0:	66765f74 	uhsub16vs	r5, r6, r4
    26c4:	00337670 	eorseq	r7, r3, r0, ror r6
    26c8:	5f617369 	svcpl	0x00617369
    26cc:	5f746962 	svcpl	0x00746962
    26d0:	76706676 			; <UNDEFINED> instruction: 0x76706676
    26d4:	41420034 	cmpmi	r2, r4, lsr r0
    26d8:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    26dc:	5f484352 	svcpl	0x00484352
    26e0:	00325436 	eorseq	r5, r2, r6, lsr r4
    26e4:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    26e8:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    26ec:	4d385f48 	ldcmi	15, cr5, [r8, #-288]!	; 0xfffffee0
    26f0:	49414d5f 	stmdbmi	r1, {r0, r1, r2, r3, r4, r6, r8, sl, fp, lr}^
    26f4:	4154004e 	cmpmi	r4, lr, asr #32
    26f8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    26fc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2700:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2704:	6d647439 	cfstrdvs	mvd7, [r4, #-228]!	; 0xffffff1c
    2708:	52410069 	subpl	r0, r1, #105	; 0x69
    270c:	4c415f4d 	mcrrmi	15, 4, r5, r1, cr13
    2710:	53414200 	movtpl	r4, #4608	; 0x1200
    2714:	52415f45 	subpl	r5, r1, #276	; 0x114
    2718:	375f4843 	ldrbcc	r4, [pc, -r3, asr #16]
    271c:	7261004d 	rsbvc	r0, r1, #77	; 0x4d
    2720:	61745f6d 	cmnvs	r4, sp, ror #30
    2724:	74656772 	strbtvc	r6, [r5], #-1906	; 0xfffff88e
    2728:	62616c5f 	rsbvs	r6, r1, #24320	; 0x5f00
    272c:	61006c65 	tstvs	r0, r5, ror #24
    2730:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 2738 <shift+0x2738>
    2734:	65677261 	strbvs	r7, [r7, #-609]!	; 0xfffffd9f
    2738:	6e695f74 	mcrvs	15, 3, r5, cr9, cr4, {3}
    273c:	54006e73 	strpl	r6, [r0], #-3699	; 0xfffff18d
    2740:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2744:	50435f54 	subpl	r5, r3, r4, asr pc
    2748:	6f635f55 	svcvs	0x00635f55
    274c:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2750:	54003472 	strpl	r3, [r0], #-1138	; 0xfffffb8e
    2754:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2758:	50435f54 	subpl	r5, r3, r4, asr pc
    275c:	6f635f55 	svcvs	0x00635f55
    2760:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2764:	54003572 	strpl	r3, [r0], #-1394	; 0xfffffa8e
    2768:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    276c:	50435f54 	subpl	r5, r3, r4, asr pc
    2770:	6f635f55 	svcvs	0x00635f55
    2774:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    2778:	54003772 	strpl	r3, [r0], #-1906	; 0xfffff88e
    277c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2780:	50435f54 	subpl	r5, r3, r4, asr pc
    2784:	6f635f55 	svcvs	0x00635f55
    2788:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    278c:	69003872 	stmdbvs	r0, {r1, r4, r5, r6, fp, ip, sp}
    2790:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2794:	6c5f7469 	cfldrdvs	mvd7, [pc], {105}	; 0x69
    2798:	00656170 	rsbeq	r6, r5, r0, ror r1
    279c:	5f617369 	svcpl	0x00617369
    27a0:	5f746962 	svcpl	0x00746962
    27a4:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    27a8:	72615f6b 	rsbvc	r5, r1, #428	; 0x1ac
    27ac:	6b36766d 	blvs	da0168 <__bss_end+0xd94830>
    27b0:	7369007a 	cmnvc	r9, #122	; 0x7a
    27b4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    27b8:	6f6e5f74 	svcvs	0x006e5f74
    27bc:	69006d74 	stmdbvs	r0, {r2, r4, r5, r6, r8, sl, fp, sp, lr}
    27c0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    27c4:	615f7469 	cmpvs	pc, r9, ror #8
    27c8:	34766d72 	ldrbtcc	r6, [r6], #-3442	; 0xfffff28e
    27cc:	61736900 	cmnvs	r3, r0, lsl #18
    27d0:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    27d4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    27d8:	69003676 	stmdbvs	r0, {r1, r2, r4, r5, r6, r9, sl, ip, sp}
    27dc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    27e0:	615f7469 	cmpvs	pc, r9, ror #8
    27e4:	37766d72 			; <UNDEFINED> instruction: 0x37766d72
    27e8:	61736900 	cmnvs	r3, r0, lsl #18
    27ec:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    27f0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    27f4:	5f003876 	svcpl	0x00003876
    27f8:	746e6f64 	strbtvc	r6, [lr], #-3940	; 0xfffff09c
    27fc:	6573755f 	ldrbvs	r7, [r3, #-1375]!	; 0xfffffaa1
    2800:	7874725f 	ldmdavc	r4!, {r0, r1, r2, r3, r4, r6, r9, ip, sp, lr}^
    2804:	7265685f 	rsbvc	r6, r5, #6225920	; 0x5f0000
    2808:	55005f65 	strpl	r5, [r0, #-3941]	; 0xfffff09b
    280c:	79744951 	ldmdbvc	r4!, {r0, r4, r6, r8, fp, lr}^
    2810:	69006570 	stmdbvs	r0, {r4, r5, r6, r8, sl, sp, lr}
    2814:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2818:	615f7469 	cmpvs	pc, r9, ror #8
    281c:	35766d72 	ldrbcc	r6, [r6, #-3442]!	; 0xfffff28e
    2820:	61006574 	tstvs	r0, r4, ror r5
    2824:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 282c <shift+0x282c>
    2828:	00656e75 	rsbeq	r6, r5, r5, ror lr
    282c:	5f6d7261 	svcpl	0x006d7261
    2830:	5f707063 	svcpl	0x00707063
    2834:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
    2838:	726f7772 	rsbvc	r7, pc, #29884416	; 0x1c80000
    283c:	7566006b 	strbvc	r0, [r6, #-107]!	; 0xffffff95
    2840:	705f636e 	subsvc	r6, pc, lr, ror #6
    2844:	54007274 	strpl	r7, [r0], #-628	; 0xfffffd8c
    2848:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    284c:	50435f54 	subpl	r5, r3, r4, asr pc
    2850:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    2854:	3032396d 	eorscc	r3, r2, sp, ror #18
    2858:	74680074 	strbtvc	r0, [r8], #-116	; 0xffffff8c
    285c:	655f6261 	ldrbvs	r6, [pc, #-609]	; 2603 <shift+0x2603>
    2860:	41540071 	cmpmi	r4, r1, ror r0
    2864:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2868:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    286c:	3561665f 	strbcc	r6, [r1, #-1631]!	; 0xfffff9a1
    2870:	61003632 	tstvs	r0, r2, lsr r6
    2874:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2878:	5f686372 	svcpl	0x00686372
    287c:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    2880:	77685f62 	strbvc	r5, [r8, -r2, ror #30]!
    2884:	00766964 	rsbseq	r6, r6, r4, ror #18
    2888:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
    288c:	5f71655f 	svcpl	0x0071655f
    2890:	6e696f70 	mcrvs	15, 3, r6, cr9, cr0, {3}
    2894:	00726574 	rsbseq	r6, r2, r4, ror r5
    2898:	5f6d7261 	svcpl	0x006d7261
    289c:	5f636970 	svcpl	0x00636970
    28a0:	69676572 	stmdbvs	r7!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    28a4:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
    28a8:	52415400 	subpl	r5, r1, #0, 8
    28ac:	5f544547 	svcpl	0x00544547
    28b0:	5f555043 	svcpl	0x00555043
    28b4:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    28b8:	306d7865 	rsbcc	r7, sp, r5, ror #16
    28bc:	6c616d73 	stclvs	13, cr6, [r1], #-460	; 0xfffffe34
    28c0:	6c756d6c 	ldclvs	13, cr6, [r5], #-432	; 0xfffffe50
    28c4:	6c706974 			; <UNDEFINED> instruction: 0x6c706974
    28c8:	41540079 	cmpmi	r4, r9, ror r0
    28cc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    28d0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    28d4:	63706d5f 	cmnvs	r0, #6080	; 0x17c0
    28d8:	6e65726f 	cdpvs	2, 6, cr7, cr5, cr15, {3}
    28dc:	7066766f 	rsbvc	r7, r6, pc, ror #12
    28e0:	61736900 	cmnvs	r3, r0, lsl #18
    28e4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    28e8:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    28ec:	635f6b72 	cmpvs	pc, #116736	; 0x1c800
    28f0:	6c5f336d 	mrrcvs	3, 6, r3, pc, cr13	; <UNPREDICTABLE>
    28f4:	00647264 	rsbeq	r7, r4, r4, ror #4
    28f8:	5f4d5241 	svcpl	0x004d5241
    28fc:	61004343 	tstvs	r0, r3, asr #6
    2900:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2904:	38686372 	stmdacc	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    2908:	6100325f 	tstvs	r0, pc, asr r2
    290c:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2910:	38686372 	stmdacc	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    2914:	6100335f 	tstvs	r0, pc, asr r3
    2918:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    291c:	38686372 	stmdacc	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    2920:	5400345f 	strpl	r3, [r0], #-1119	; 0xfffffba1
    2924:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2928:	50435f54 	subpl	r5, r3, r4, asr pc
    292c:	6d665f55 	stclvs	15, cr5, [r6, #-340]!	; 0xfffffeac
    2930:	36323670 			; <UNDEFINED> instruction: 0x36323670
    2934:	4d524100 	ldfmie	f4, [r2, #-0]
    2938:	0053435f 	subseq	r4, r3, pc, asr r3
    293c:	5f6d7261 	svcpl	0x006d7261
    2940:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    2944:	736e695f 	cmnvc	lr, #1556480	; 0x17c000
    2948:	72610074 	rsbvc	r0, r1, #116	; 0x74
    294c:	61625f6d 	cmnvs	r2, sp, ror #30
    2950:	615f6573 	cmpvs	pc, r3, ror r5	; <UNPREDICTABLE>
    2954:	00686372 	rsbeq	r6, r8, r2, ror r3
    2958:	47524154 			; <UNDEFINED> instruction: 0x47524154
    295c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2960:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    2964:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    2968:	35316178 	ldrcc	r6, [r1, #-376]!	; 0xfffffe88
    296c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2970:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    2974:	6d726100 	ldfvse	f6, [r2, #-0]
    2978:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    297c:	6d653768 	stclvs	7, cr3, [r5, #-416]!	; 0xfffffe60
    2980:	52415400 	subpl	r5, r1, #0, 8
    2984:	5f544547 	svcpl	0x00544547
    2988:	5f555043 	svcpl	0x00555043
    298c:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2990:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    2994:	72610032 	rsbvc	r0, r1, #50	; 0x32
    2998:	63705f6d 	cmnvs	r0, #436	; 0x1b4
    299c:	65645f73 	strbvs	r5, [r4, #-3955]!	; 0xfffff08d
    29a0:	6c756166 	ldfvse	f6, [r5], #-408	; 0xfffffe68
    29a4:	52410074 	subpl	r0, r1, #116	; 0x74
    29a8:	43505f4d 	cmpmi	r0, #308	; 0x134
    29ac:	41415f53 	cmpmi	r1, r3, asr pc
    29b0:	5f534350 	svcpl	0x00534350
    29b4:	41434f4c 	cmpmi	r3, ip, asr #30
    29b8:	4154004c 	cmpmi	r4, ip, asr #32
    29bc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    29c0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    29c4:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    29c8:	61786574 	cmnvs	r8, r4, ror r5
    29cc:	54003537 	strpl	r3, [r0], #-1335	; 0xfffffac9
    29d0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    29d4:	50435f54 	subpl	r5, r3, r4, asr pc
    29d8:	74735f55 	ldrbtvc	r5, [r3], #-3925	; 0xfffff0ab
    29dc:	676e6f72 			; <UNDEFINED> instruction: 0x676e6f72
    29e0:	006d7261 	rsbeq	r7, sp, r1, ror #4
    29e4:	5f6d7261 	svcpl	0x006d7261
    29e8:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    29ec:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    29f0:	0031626d 	eorseq	r6, r1, sp, ror #4
    29f4:	5f6d7261 	svcpl	0x006d7261
    29f8:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    29fc:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    2a00:	0032626d 	eorseq	r6, r2, sp, ror #4
    2a04:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2a08:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    2a0c:	695f5550 	ldmdbvs	pc, {r4, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
    2a10:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    2a14:	72610074 	rsbvc	r0, r1, #116	; 0x74
    2a18:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    2a1c:	74356863 	ldrtvc	r6, [r5], #-2147	; 0xfffff79d
    2a20:	61736900 	cmnvs	r3, r0, lsl #18
    2a24:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2a28:	00706d5f 	rsbseq	r6, r0, pc, asr sp
    2a2c:	5f6d7261 	svcpl	0x006d7261
    2a30:	735f646c 	cmpvc	pc, #108, 8	; 0x6c000000
    2a34:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    2a38:	6d726100 	ldfvse	f6, [r2, #-0]
    2a3c:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    2a40:	315f3868 	cmpcc	pc, r8, ror #16
	...

Disassembly of section .debug_frame:

00000000 <.debug_frame>:
   0:	0000000c 	andeq	r0, r0, ip
   4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
   8:	7c020001 	stcvc	0, cr0, [r2], {1}
   c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  10:	0000001c 	andeq	r0, r0, ip, lsl r0
  14:	00000000 	andeq	r0, r0, r0
  18:	00008008 	andeq	r8, r0, r8
  1c:	0000005c 	andeq	r0, r0, ip, asr r0
  20:	8b040e42 	blhi	103930 <__bss_end+0xf7ff8>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x344ef8>
  28:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008064 	andeq	r8, r0, r4, rrx
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1f8018>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xf7348>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080a4 	andeq	r8, r0, r4, lsr #1
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xf8048>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x344f48>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080dc 	ldrdeq	r8, [r0], -ip
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xf8068>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x344f68>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008108 	andeq	r8, r0, r8, lsl #2
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xf8088>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x344f88>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008128 	andeq	r8, r0, r8, lsr #2
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xf80a8>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x344fa8>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	00008140 	andeq	r8, r0, r0, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xf80c8>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x344fc8>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008158 	andeq	r8, r0, r8, asr r1
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xf80e8>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x344fe8>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	00008170 	andeq	r8, r0, r0, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xf8108>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x345008>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	0000817c 	andeq	r8, r0, ip, ror r1
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1f8120>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081d4 	ldrdeq	r8, [r0], -r4
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1f8140>
 16c:	42018e02 	andmi	r8, r1, #2, 28
 170:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 174:	00080d0c 	andeq	r0, r8, ip, lsl #26
 178:	0000000c 	andeq	r0, r0, ip
 17c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 180:	7c020001 	stcvc	0, cr0, [r2], {1}
 184:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 188:	0000001c 	andeq	r0, r0, ip, lsl r0
 18c:	00000178 	andeq	r0, r0, r8, ror r1
 190:	00008230 	andeq	r8, r0, r0, lsr r2
 194:	000000f4 	strdeq	r0, [r0], -r4
 198:	8b040e42 	blhi	103aa8 <__bss_end+0xf8170>
 19c:	0b0d4201 	bleq	3509a8 <__bss_end+0x345070>
 1a0:	0d0d6802 	stceq	8, cr6, [sp, #-8]
 1a4:	000ecb42 	andeq	ip, lr, r2, asr #22
 1a8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1ac:	00000178 	andeq	r0, r0, r8, ror r1
 1b0:	00008324 	andeq	r8, r0, r4, lsr #6
 1b4:	00000104 	andeq	r0, r0, r4, lsl #2
 1b8:	8b040e42 	blhi	103ac8 <__bss_end+0xf8190>
 1bc:	0b0d4201 	bleq	3509c8 <__bss_end+0x345090>
 1c0:	0d0d7002 	stceq	0, cr7, [sp, #-8]
 1c4:	000ecb42 	andeq	ip, lr, r2, asr #22
 1c8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1cc:	00000178 	andeq	r0, r0, r8, ror r1
 1d0:	00008428 	andeq	r8, r0, r8, lsr #8
 1d4:	000000c8 	andeq	r0, r0, r8, asr #1
 1d8:	8b040e42 	blhi	103ae8 <__bss_end+0xf81b0>
 1dc:	0b0d4201 	bleq	3509e8 <__bss_end+0x3450b0>
 1e0:	0d0d5c02 	stceq	12, cr5, [sp, #-8]
 1e4:	000ecb42 	andeq	ip, lr, r2, asr #22
 1e8:	0000001c 	andeq	r0, r0, ip, lsl r0
 1ec:	00000178 	andeq	r0, r0, r8, ror r1
 1f0:	000084f0 	strdeq	r8, [r0], -r0
 1f4:	000000c0 	andeq	r0, r0, r0, asr #1
 1f8:	8b080e42 	blhi	203b08 <__bss_end+0x1f81d0>
 1fc:	42018e02 	andmi	r8, r1, #2, 28
 200:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 204:	080d0c50 	stmdaeq	sp, {r4, r6, sl, fp}
 208:	0000001c 	andeq	r0, r0, ip, lsl r0
 20c:	00000178 	andeq	r0, r0, r8, ror r1
 210:	000085b0 			; <UNDEFINED> instruction: 0x000085b0
 214:	00000054 	andeq	r0, r0, r4, asr r0
 218:	8b040e42 	blhi	103b28 <__bss_end+0xf81f0>
 21c:	0b0d4201 	bleq	350a28 <__bss_end+0x3450f0>
 220:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 224:	00000ecb 	andeq	r0, r0, fp, asr #29
 228:	0000001c 	andeq	r0, r0, ip, lsl r0
 22c:	00000178 	andeq	r0, r0, r8, ror r1
 230:	00008604 	andeq	r8, r0, r4, lsl #12
 234:	0000010c 	andeq	r0, r0, ip, lsl #2
 238:	8b080e42 	blhi	203b48 <__bss_end+0x1f8210>
 23c:	42018e02 	andmi	r8, r1, #2, 28
 240:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 244:	080d0c80 	stmdaeq	sp, {r7, sl, fp}
 248:	00000020 	andeq	r0, r0, r0, lsr #32
 24c:	00000178 	andeq	r0, r0, r8, ror r1
 250:	00008710 	andeq	r8, r0, r0, lsl r7
 254:	000002b0 			; <UNDEFINED> instruction: 0x000002b0
 258:	8b080e42 	blhi	203b68 <__bss_end+0x1f8230>
 25c:	42018e02 	andmi	r8, r1, #2, 28
 260:	03040b0c 	movweq	r0, #19212	; 0x4b0c
 264:	0d0c0136 	stfeqs	f0, [ip, #-216]	; 0xffffff28
 268:	00000008 	andeq	r0, r0, r8
 26c:	0000001c 	andeq	r0, r0, ip, lsl r0
 270:	00000178 	andeq	r0, r0, r8, ror r1
 274:	000089c0 	andeq	r8, r0, r0, asr #19
 278:	000001bc 			; <UNDEFINED> instruction: 0x000001bc
 27c:	8b080e42 	blhi	203b8c <__bss_end+0x1f8254>
 280:	42018e02 	andmi	r8, r1, #2, 28
 284:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 288:	080d0cce 	stmdaeq	sp, {r1, r2, r3, r6, r7, sl, fp}
 28c:	0000001c 	andeq	r0, r0, ip, lsl r0
 290:	00000178 	andeq	r0, r0, r8, ror r1
 294:	00008b7c 	andeq	r8, r0, ip, ror fp
 298:	00000088 	andeq	r0, r0, r8, lsl #1
 29c:	8b040e42 	blhi	103bac <__bss_end+0xf8274>
 2a0:	0b0d4201 	bleq	350aac <__bss_end+0x345174>
 2a4:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 2a8:	00000ecb 	andeq	r0, r0, fp, asr #29
 2ac:	0000001c 	andeq	r0, r0, ip, lsl r0
 2b0:	00000178 	andeq	r0, r0, r8, ror r1
 2b4:	00008c04 	andeq	r8, r0, r4, lsl #24
 2b8:	00000084 	andeq	r0, r0, r4, lsl #1
 2bc:	8b080e42 	blhi	203bcc <__bss_end+0x1f8294>
 2c0:	42018e02 	andmi	r8, r1, #2, 28
 2c4:	7c040b0c 			; <UNDEFINED> instruction: 0x7c040b0c
 2c8:	00080d0c 	andeq	r0, r8, ip, lsl #26
 2cc:	0000001c 	andeq	r0, r0, ip, lsl r0
 2d0:	00000178 	andeq	r0, r0, r8, ror r1
 2d4:	00008c88 	andeq	r8, r0, r8, lsl #25
 2d8:	000000a4 	andeq	r0, r0, r4, lsr #1
 2dc:	8b080e42 	blhi	203bec <__bss_end+0x1f82b4>
 2e0:	42018e02 	andmi	r8, r1, #2, 28
 2e4:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 2e8:	080d0c48 	stmdaeq	sp, {r3, r6, sl, fp}
 2ec:	0000001c 	andeq	r0, r0, ip, lsl r0
 2f0:	00000178 	andeq	r0, r0, r8, ror r1
 2f4:	00008d2c 	andeq	r8, r0, ip, lsr #26
 2f8:	000000d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
 2fc:	8b080e42 	blhi	203c0c <__bss_end+0x1f82d4>
 300:	42018e02 	andmi	r8, r1, #2, 28
 304:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 308:	080d0c62 	stmdaeq	sp, {r1, r5, r6, sl, fp}
 30c:	0000001c 	andeq	r0, r0, ip, lsl r0
 310:	00000178 	andeq	r0, r0, r8, ror r1
 314:	00008dfc 	strdeq	r8, [r0], -ip
 318:	00000098 	muleq	r0, r8, r0
 31c:	8b080e42 	blhi	203c2c <__bss_end+0x1f82f4>
 320:	42018e02 	andmi	r8, r1, #2, 28
 324:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 328:	080d0c46 	stmdaeq	sp, {r1, r2, r6, sl, fp}
 32c:	00000034 	andeq	r0, r0, r4, lsr r0
 330:	00000178 	andeq	r0, r0, r8, ror r1
 334:	00008e94 	muleq	r0, r4, lr
 338:	0000017c 	andeq	r0, r0, ip, ror r1
 33c:	84140e42 	ldrhi	r0, [r4], #-3650	; 0xfffff1be
 340:	86048505 	strhi	r8, [r4], -r5, lsl #10
 344:	8e028b03 	vmlahi.f64	d8, d2, d3
 348:	1c0e4201 	sfmne	f4, 4, [lr], {1}
 34c:	05075005 	streq	r5, [r7, #-5]
 350:	0c420651 	mcrreq	6, 5, r0, r2, cr1
 354:	ac02040b 	cfstrsge	mvf0, [r2], {11}
 358:	421c0d0c 	andsmi	r0, ip, #12, 26	; 0x300
 35c:	51065006 	tstpl	r6, r6
 360:	0000140e 	andeq	r1, r0, lr, lsl #8
 364:	00000030 	andeq	r0, r0, r0, lsr r0
 368:	00000178 	andeq	r0, r0, r8, ror r1
 36c:	00009010 	andeq	r9, r0, r0, lsl r0
 370:	00000640 	andeq	r0, r0, r0, asr #12
 374:	840c0e42 	strhi	r0, [ip], #-3650	; 0xfffff1be
 378:	8e028b03 	vmlahi.f64	d8, d2, d3
 37c:	140e4201 	strne	r4, [lr], #-513	; 0xfffffdff
 380:	05055005 	streq	r5, [r5, #-5]
 384:	0c420451 	cfstrdeq	mvd0, [r2], {81}	; 0x51
 388:	fc03040b 	stc2	4, cr0, [r3], {11}
 38c:	140d0c02 	strne	r0, [sp], #-3074	; 0xfffff3fe
 390:	06500642 	ldrbeq	r0, [r0], -r2, asr #12
 394:	000c0e51 	andeq	r0, ip, r1, asr lr
 398:	00000020 	andeq	r0, r0, r0, lsr #32
 39c:	00000178 	andeq	r0, r0, r8, ror r1
 3a0:	00009650 	andeq	r9, r0, r0, asr r6
 3a4:	00000240 	andeq	r0, r0, r0, asr #4
 3a8:	8b080e42 	blhi	203cb8 <__bss_end+0x1f8380>
 3ac:	42018e02 	andmi	r8, r1, #2, 28
 3b0:	03040b0c 	movweq	r0, #19212	; 0x4b0c
 3b4:	0d0c010a 	stfeqs	f0, [ip, #-40]	; 0xffffffd8
 3b8:	00000008 	andeq	r0, r0, r8
 3bc:	0000001c 	andeq	r0, r0, ip, lsl r0
 3c0:	00000178 	andeq	r0, r0, r8, ror r1
 3c4:	00009890 	muleq	r0, r0, r8
 3c8:	00000220 	andeq	r0, r0, r0, lsr #4
 3cc:	8b080e42 	blhi	203cdc <__bss_end+0x1f83a4>
 3d0:	42018e02 	andmi	r8, r1, #2, 28
 3d4:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3d8:	080d0cf0 	stmdaeq	sp, {r4, r5, r6, r7, sl, fp}
 3dc:	0000001c 	andeq	r0, r0, ip, lsl r0
 3e0:	00000178 	andeq	r0, r0, r8, ror r1
 3e4:	00009ab0 			; <UNDEFINED> instruction: 0x00009ab0
 3e8:	00000094 	muleq	r0, r4, r0
 3ec:	8b080e42 	blhi	203cfc <__bss_end+0x1f83c4>
 3f0:	42018e02 	andmi	r8, r1, #2, 28
 3f4:	7a040b0c 	bvc	10302c <__bss_end+0xf76f4>
 3f8:	00080d0c 	andeq	r0, r8, ip, lsl #26
 3fc:	00000018 	andeq	r0, r0, r8, lsl r0
 400:	00000178 	andeq	r0, r0, r8, ror r1
 404:	00009b44 	andeq	r9, r0, r4, asr #22
 408:	0000001c 	andeq	r0, r0, ip, lsl r0
 40c:	8b080e42 	blhi	203d1c <__bss_end+0x1f83e4>
 410:	42018e02 	andmi	r8, r1, #2, 28
 414:	00040b0c 	andeq	r0, r4, ip, lsl #22
 418:	0000000c 	andeq	r0, r0, ip
 41c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 420:	7c020001 	stcvc	0, cr0, [r2], {1}
 424:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 428:	0000001c 	andeq	r0, r0, ip, lsl r0
 42c:	00000418 	andeq	r0, r0, r8, lsl r4
 430:	00009b60 	andeq	r9, r0, r0, ror #22
 434:	0000002c 	andeq	r0, r0, ip, lsr #32
 438:	8b040e42 	blhi	103d48 <__bss_end+0xf8410>
 43c:	0b0d4201 	bleq	350c48 <__bss_end+0x345310>
 440:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 444:	00000ecb 	andeq	r0, r0, fp, asr #29
 448:	0000001c 	andeq	r0, r0, ip, lsl r0
 44c:	00000418 	andeq	r0, r0, r8, lsl r4
 450:	00009b8c 	andeq	r9, r0, ip, lsl #23
 454:	0000002c 	andeq	r0, r0, ip, lsr #32
 458:	8b040e42 	blhi	103d68 <__bss_end+0xf8430>
 45c:	0b0d4201 	bleq	350c68 <__bss_end+0x345330>
 460:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 464:	00000ecb 	andeq	r0, r0, fp, asr #29
 468:	0000001c 	andeq	r0, r0, ip, lsl r0
 46c:	00000418 	andeq	r0, r0, r8, lsl r4
 470:	00009bb8 			; <UNDEFINED> instruction: 0x00009bb8
 474:	0000001c 	andeq	r0, r0, ip, lsl r0
 478:	8b040e42 	blhi	103d88 <__bss_end+0xf8450>
 47c:	0b0d4201 	bleq	350c88 <__bss_end+0x345350>
 480:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 484:	00000ecb 	andeq	r0, r0, fp, asr #29
 488:	0000001c 	andeq	r0, r0, ip, lsl r0
 48c:	00000418 	andeq	r0, r0, r8, lsl r4
 490:	00009bd4 	ldrdeq	r9, [r0], -r4
 494:	00000044 	andeq	r0, r0, r4, asr #32
 498:	8b040e42 	blhi	103da8 <__bss_end+0xf8470>
 49c:	0b0d4201 	bleq	350ca8 <__bss_end+0x345370>
 4a0:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 4a4:	00000ecb 	andeq	r0, r0, fp, asr #29
 4a8:	0000001c 	andeq	r0, r0, ip, lsl r0
 4ac:	00000418 	andeq	r0, r0, r8, lsl r4
 4b0:	00009c18 	andeq	r9, r0, r8, lsl ip
 4b4:	00000050 	andeq	r0, r0, r0, asr r0
 4b8:	8b040e42 	blhi	103dc8 <__bss_end+0xf8490>
 4bc:	0b0d4201 	bleq	350cc8 <__bss_end+0x345390>
 4c0:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 4c4:	00000ecb 	andeq	r0, r0, fp, asr #29
 4c8:	0000001c 	andeq	r0, r0, ip, lsl r0
 4cc:	00000418 	andeq	r0, r0, r8, lsl r4
 4d0:	00009c68 	andeq	r9, r0, r8, ror #24
 4d4:	00000050 	andeq	r0, r0, r0, asr r0
 4d8:	8b040e42 	blhi	103de8 <__bss_end+0xf84b0>
 4dc:	0b0d4201 	bleq	350ce8 <__bss_end+0x3453b0>
 4e0:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 4e4:	00000ecb 	andeq	r0, r0, fp, asr #29
 4e8:	0000001c 	andeq	r0, r0, ip, lsl r0
 4ec:	00000418 	andeq	r0, r0, r8, lsl r4
 4f0:	00009cb8 			; <UNDEFINED> instruction: 0x00009cb8
 4f4:	0000002c 	andeq	r0, r0, ip, lsr #32
 4f8:	8b040e42 	blhi	103e08 <__bss_end+0xf84d0>
 4fc:	0b0d4201 	bleq	350d08 <__bss_end+0x3453d0>
 500:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 504:	00000ecb 	andeq	r0, r0, fp, asr #29
 508:	0000001c 	andeq	r0, r0, ip, lsl r0
 50c:	00000418 	andeq	r0, r0, r8, lsl r4
 510:	00009ce4 	andeq	r9, r0, r4, ror #25
 514:	00000050 	andeq	r0, r0, r0, asr r0
 518:	8b040e42 	blhi	103e28 <__bss_end+0xf84f0>
 51c:	0b0d4201 	bleq	350d28 <__bss_end+0x3453f0>
 520:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 524:	00000ecb 	andeq	r0, r0, fp, asr #29
 528:	0000001c 	andeq	r0, r0, ip, lsl r0
 52c:	00000418 	andeq	r0, r0, r8, lsl r4
 530:	00009d34 	andeq	r9, r0, r4, lsr sp
 534:	00000044 	andeq	r0, r0, r4, asr #32
 538:	8b040e42 	blhi	103e48 <__bss_end+0xf8510>
 53c:	0b0d4201 	bleq	350d48 <__bss_end+0x345410>
 540:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 544:	00000ecb 	andeq	r0, r0, fp, asr #29
 548:	0000001c 	andeq	r0, r0, ip, lsl r0
 54c:	00000418 	andeq	r0, r0, r8, lsl r4
 550:	00009d78 	andeq	r9, r0, r8, ror sp
 554:	00000050 	andeq	r0, r0, r0, asr r0
 558:	8b040e42 	blhi	103e68 <__bss_end+0xf8530>
 55c:	0b0d4201 	bleq	350d68 <__bss_end+0x345430>
 560:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 564:	00000ecb 	andeq	r0, r0, fp, asr #29
 568:	0000001c 	andeq	r0, r0, ip, lsl r0
 56c:	00000418 	andeq	r0, r0, r8, lsl r4
 570:	00009dc8 	andeq	r9, r0, r8, asr #27
 574:	00000054 	andeq	r0, r0, r4, asr r0
 578:	8b040e42 	blhi	103e88 <__bss_end+0xf8550>
 57c:	0b0d4201 	bleq	350d88 <__bss_end+0x345450>
 580:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 584:	00000ecb 	andeq	r0, r0, fp, asr #29
 588:	0000001c 	andeq	r0, r0, ip, lsl r0
 58c:	00000418 	andeq	r0, r0, r8, lsl r4
 590:	00009e1c 	andeq	r9, r0, ip, lsl lr
 594:	0000003c 	andeq	r0, r0, ip, lsr r0
 598:	8b040e42 	blhi	103ea8 <__bss_end+0xf8570>
 59c:	0b0d4201 	bleq	350da8 <__bss_end+0x345470>
 5a0:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 5a4:	00000ecb 	andeq	r0, r0, fp, asr #29
 5a8:	0000001c 	andeq	r0, r0, ip, lsl r0
 5ac:	00000418 	andeq	r0, r0, r8, lsl r4
 5b0:	00009e58 	andeq	r9, r0, r8, asr lr
 5b4:	0000003c 	andeq	r0, r0, ip, lsr r0
 5b8:	8b040e42 	blhi	103ec8 <__bss_end+0xf8590>
 5bc:	0b0d4201 	bleq	350dc8 <__bss_end+0x345490>
 5c0:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 5c4:	00000ecb 	andeq	r0, r0, fp, asr #29
 5c8:	0000001c 	andeq	r0, r0, ip, lsl r0
 5cc:	00000418 	andeq	r0, r0, r8, lsl r4
 5d0:	00009e94 	muleq	r0, r4, lr
 5d4:	0000003c 	andeq	r0, r0, ip, lsr r0
 5d8:	8b040e42 	blhi	103ee8 <__bss_end+0xf85b0>
 5dc:	0b0d4201 	bleq	350de8 <__bss_end+0x3454b0>
 5e0:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 5e4:	00000ecb 	andeq	r0, r0, fp, asr #29
 5e8:	0000001c 	andeq	r0, r0, ip, lsl r0
 5ec:	00000418 	andeq	r0, r0, r8, lsl r4
 5f0:	00009ed0 	ldrdeq	r9, [r0], -r0
 5f4:	0000003c 	andeq	r0, r0, ip, lsr r0
 5f8:	8b040e42 	blhi	103f08 <__bss_end+0xf85d0>
 5fc:	0b0d4201 	bleq	350e08 <__bss_end+0x3454d0>
 600:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 604:	00000ecb 	andeq	r0, r0, fp, asr #29
 608:	0000001c 	andeq	r0, r0, ip, lsl r0
 60c:	00000418 	andeq	r0, r0, r8, lsl r4
 610:	00009f0c 	andeq	r9, r0, ip, lsl #30
 614:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 618:	8b080e42 	blhi	203f28 <__bss_end+0x1f85f0>
 61c:	42018e02 	andmi	r8, r1, #2, 28
 620:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 624:	080d0c50 	stmdaeq	sp, {r4, r6, sl, fp}
 628:	0000000c 	andeq	r0, r0, ip
 62c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 630:	7c020001 	stcvc	0, cr0, [r2], {1}
 634:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 638:	0000001c 	andeq	r0, r0, ip, lsl r0
 63c:	00000628 	andeq	r0, r0, r8, lsr #12
 640:	00009fbc 			; <UNDEFINED> instruction: 0x00009fbc
 644:	00000040 	andeq	r0, r0, r0, asr #32
 648:	8b040e42 	blhi	103f58 <__bss_end+0xf8620>
 64c:	0b0d4201 	bleq	350e58 <__bss_end+0x345520>
 650:	420d0d58 	andmi	r0, sp, #88, 26	; 0x1600
 654:	00000ecb 	andeq	r0, r0, fp, asr #29
 658:	0000000c 	andeq	r0, r0, ip
 65c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 660:	7c020001 	stcvc	0, cr0, [r2], {1}
 664:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 668:	0000001c 	andeq	r0, r0, ip, lsl r0
 66c:	00000658 	andeq	r0, r0, r8, asr r6
 670:	0000a000 	andeq	sl, r0, r0
 674:	00000174 	andeq	r0, r0, r4, ror r1
 678:	8b080e42 	blhi	203f88 <__bss_end+0x1f8650>
 67c:	42018e02 	andmi	r8, r1, #2, 28
 680:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 684:	080d0cb2 	stmdaeq	sp, {r1, r4, r5, r7, sl, fp}
 688:	0000001c 	andeq	r0, r0, ip, lsl r0
 68c:	00000658 	andeq	r0, r0, r8, asr r6
 690:	0000a174 	andeq	sl, r0, r4, ror r1
 694:	0000009c 	muleq	r0, ip, r0
 698:	8b040e42 	blhi	103fa8 <__bss_end+0xf8670>
 69c:	0b0d4201 	bleq	350ea8 <__bss_end+0x345570>
 6a0:	0d0d4602 	stceq	6, cr4, [sp, #-8]
 6a4:	000ecb42 	andeq	ip, lr, r2, asr #22
 6a8:	0000001c 	andeq	r0, r0, ip, lsl r0
 6ac:	00000658 	andeq	r0, r0, r8, asr r6
 6b0:	0000a210 	andeq	sl, r0, r0, lsl r2
 6b4:	000000c8 	andeq	r0, r0, r8, asr #1
 6b8:	8b040e42 	blhi	103fc8 <__bss_end+0xf8690>
 6bc:	0b0d4201 	bleq	350ec8 <__bss_end+0x345590>
 6c0:	0d0d5202 	sfmeq	f5, 4, [sp, #-8]
 6c4:	000ecb42 	andeq	ip, lr, r2, asr #22
 6c8:	00000020 	andeq	r0, r0, r0, lsr #32
 6cc:	00000658 	andeq	r0, r0, r8, asr r6
 6d0:	0000a2d8 	ldrdeq	sl, [r0], -r8
 6d4:	000002b4 			; <UNDEFINED> instruction: 0x000002b4
 6d8:	8b040e42 	blhi	103fe8 <__bss_end+0xf86b0>
 6dc:	0b0d4201 	bleq	350ee8 <__bss_end+0x3455b0>
 6e0:	0d014803 	stceq	8, cr4, [r1, #-12]
 6e4:	0ecb420d 	cdpeq	2, 12, cr4, cr11, cr13, {0}
 6e8:	00000000 	andeq	r0, r0, r0
 6ec:	00000020 	andeq	r0, r0, r0, lsr #32
 6f0:	00000658 	andeq	r0, r0, r8, asr r6
 6f4:	0000a58c 	andeq	sl, r0, ip, lsl #11
 6f8:	00000238 	andeq	r0, r0, r8, lsr r2
 6fc:	8b080e42 	blhi	20400c <__bss_end+0x1f86d4>
 700:	42018e02 	andmi	r8, r1, #2, 28
 704:	03040b0c 	movweq	r0, #19212	; 0x4b0c
 708:	0d0c0110 	stfeqs	f0, [ip, #-64]	; 0xffffffc0
 70c:	00000008 	andeq	r0, r0, r8
 710:	0000001c 	andeq	r0, r0, ip, lsl r0
 714:	00000658 	andeq	r0, r0, r8, asr r6
 718:	0000a7c4 	andeq	sl, r0, r4, asr #15
 71c:	000000c0 	andeq	r0, r0, r0, asr #1
 720:	8b040e42 	blhi	104030 <__bss_end+0xf86f8>
 724:	0b0d4201 	bleq	350f30 <__bss_end+0x3455f8>
 728:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 72c:	000ecb42 	andeq	ip, lr, r2, asr #22
 730:	0000001c 	andeq	r0, r0, ip, lsl r0
 734:	00000658 	andeq	r0, r0, r8, asr r6
 738:	0000a884 	andeq	sl, r0, r4, lsl #17
 73c:	000000d4 	ldrdeq	r0, [r0], -r4
 740:	8b040e42 	blhi	104050 <__bss_end+0xf8718>
 744:	0b0d4201 	bleq	350f50 <__bss_end+0x345618>
 748:	0d0d6202 	sfmeq	f6, 4, [sp, #-8]
 74c:	000ecb42 	andeq	ip, lr, r2, asr #22
 750:	0000001c 	andeq	r0, r0, ip, lsl r0
 754:	00000658 	andeq	r0, r0, r8, asr r6
 758:	0000a958 	andeq	sl, r0, r8, asr r9
 75c:	000000ac 	andeq	r0, r0, ip, lsr #1
 760:	8b040e42 	blhi	104070 <__bss_end+0xf8738>
 764:	0b0d4201 	bleq	350f70 <__bss_end+0x345638>
 768:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 76c:	000ecb42 	andeq	ip, lr, r2, asr #22
 770:	0000001c 	andeq	r0, r0, ip, lsl r0
 774:	00000658 	andeq	r0, r0, r8, asr r6
 778:	0000aa04 	andeq	sl, r0, r4, lsl #20
 77c:	00000054 	andeq	r0, r0, r4, asr r0
 780:	8b040e42 	blhi	104090 <__bss_end+0xf8758>
 784:	0b0d4201 	bleq	350f90 <__bss_end+0x345658>
 788:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 78c:	00000ecb 	andeq	r0, r0, fp, asr #29
 790:	0000001c 	andeq	r0, r0, ip, lsl r0
 794:	00000658 	andeq	r0, r0, r8, asr r6
 798:	0000aa58 	andeq	sl, r0, r8, asr sl
 79c:	00000068 	andeq	r0, r0, r8, rrx
 7a0:	8b040e42 	blhi	1040b0 <__bss_end+0xf8778>
 7a4:	0b0d4201 	bleq	350fb0 <__bss_end+0x345678>
 7a8:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 7ac:	00000ecb 	andeq	r0, r0, fp, asr #29
 7b0:	0000001c 	andeq	r0, r0, ip, lsl r0
 7b4:	00000658 	andeq	r0, r0, r8, asr r6
 7b8:	0000aac0 	andeq	sl, r0, r0, asr #21
 7bc:	00000080 	andeq	r0, r0, r0, lsl #1
 7c0:	8b040e42 	blhi	1040d0 <__bss_end+0xf8798>
 7c4:	0b0d4201 	bleq	350fd0 <__bss_end+0x345698>
 7c8:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 7cc:	00000ecb 	andeq	r0, r0, fp, asr #29
 7d0:	0000000c 	andeq	r0, r0, ip
 7d4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 7d8:	7c020001 	stcvc	0, cr0, [r2], {1}
 7dc:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 7e0:	0000001c 	andeq	r0, r0, ip, lsl r0
 7e4:	000007d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
 7e8:	0000ab40 	andeq	sl, r0, r0, asr #22
 7ec:	0000002c 	andeq	r0, r0, ip, lsr #32
 7f0:	8b080e42 	blhi	204100 <__bss_end+0x1f87c8>
 7f4:	42018e02 	andmi	r8, r1, #2, 28
 7f8:	50040b0c 	andpl	r0, r4, ip, lsl #22
 7fc:	00080d0c 	andeq	r0, r8, ip, lsl #26
 800:	0000001c 	andeq	r0, r0, ip, lsl r0
 804:	000007d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
 808:	0000ab6c 	andeq	sl, r0, ip, ror #22
 80c:	00000140 	andeq	r0, r0, r0, asr #2
 810:	8b080e42 	blhi	204120 <__bss_end+0x1f87e8>
 814:	42018e02 	andmi	r8, r1, #2, 28
 818:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 81c:	080d0c9a 	stmdaeq	sp, {r1, r3, r4, r7, sl, fp}
 820:	0000000c 	andeq	r0, r0, ip
 824:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 828:	7c020001 	stcvc	0, cr0, [r2], {1}
 82c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 830:	0000001c 	andeq	r0, r0, ip, lsl r0
 834:	00000820 	andeq	r0, r0, r0, lsr #16
 838:	0000acac 	andeq	sl, r0, ip, lsr #25
 83c:	00000048 	andeq	r0, r0, r8, asr #32
 840:	8b080e42 	blhi	204150 <__bss_end+0x1f8818>
 844:	42018e02 	andmi	r8, r1, #2, 28
 848:	5e040b0c 	vmlapl.f64	d0, d4, d12
 84c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 850:	0000001c 	andeq	r0, r0, ip, lsl r0
 854:	00000820 	andeq	r0, r0, r0, lsr #16
 858:	0000acf4 	strdeq	sl, [r0], -r4
 85c:	00000048 	andeq	r0, r0, r8, asr #32
 860:	8b080e42 	blhi	204170 <__bss_end+0x1f8838>
 864:	42018e02 	andmi	r8, r1, #2, 28
 868:	5e040b0c 	vmlapl.f64	d0, d4, d12
 86c:	00080d0c 	andeq	r0, r8, ip, lsl #26
 870:	0000001c 	andeq	r0, r0, ip, lsl r0
 874:	00000820 	andeq	r0, r0, r0, lsr #16
 878:	0000ad3c 	andeq	sl, r0, ip, lsr sp
 87c:	000000d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
 880:	8b040e42 	blhi	104190 <__bss_end+0xf8858>
 884:	0b0d4201 	bleq	351090 <__bss_end+0x345758>
 888:	0d0d6002 	stceq	0, cr6, [sp, #-8]
 88c:	000ecb42 	andeq	ip, lr, r2, asr #22
 890:	0000001c 	andeq	r0, r0, ip, lsl r0
 894:	00000820 	andeq	r0, r0, r0, lsr #16
 898:	0000ae0c 	andeq	sl, r0, ip, lsl #28
 89c:	00000068 	andeq	r0, r0, r8, rrx
 8a0:	8b080e42 	blhi	2041b0 <__bss_end+0x1f8878>
 8a4:	42018e02 	andmi	r8, r1, #2, 28
 8a8:	6e040b0c 	vmlavs.f64	d0, d4, d12
 8ac:	00080d0c 	andeq	r0, r8, ip, lsl #26
 8b0:	0000001c 	andeq	r0, r0, ip, lsl r0
 8b4:	00000820 	andeq	r0, r0, r0, lsr #16
 8b8:	0000ae74 	andeq	sl, r0, r4, ror lr
 8bc:	00000054 	andeq	r0, r0, r4, asr r0
 8c0:	8b040e42 	blhi	1041d0 <__bss_end+0xf8898>
 8c4:	0b0d4201 	bleq	3510d0 <__bss_end+0x345798>
 8c8:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 8cc:	00000ecb 	andeq	r0, r0, fp, asr #29
 8d0:	0000001c 	andeq	r0, r0, ip, lsl r0
 8d4:	00000820 	andeq	r0, r0, r0, lsr #16
 8d8:	0000aec8 	andeq	sl, r0, r8, asr #29
 8dc:	000000d0 	ldrdeq	r0, [r0], -r0	; <UNPREDICTABLE>
 8e0:	8b080e42 	blhi	2041f0 <__bss_end+0x1f88b8>
 8e4:	42018e02 	andmi	r8, r1, #2, 28
 8e8:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 8ec:	080d0c62 	stmdaeq	sp, {r1, r5, r6, sl, fp}
 8f0:	0000000c 	andeq	r0, r0, ip
 8f4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 8f8:	7c010001 	stcvc	0, cr0, [r1], {1}
 8fc:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 900:	0000000c 	andeq	r0, r0, ip
 904:	000008f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
 908:	0000af98 	muleq	r0, r8, pc	; <UNPREDICTABLE>
 90c:	000001ec 	andeq	r0, r0, ip, ror #3

Disassembly of section .debug_ranges:

00000000 <.debug_ranges>:
   0:	00001734 	andeq	r1, r0, r4, lsr r7
   4:	00001834 	andeq	r1, r0, r4, lsr r8
   8:	00001838 	andeq	r1, r0, r8, lsr r8
   c:	0000183c 	andeq	r1, r0, ip, lsr r8
	...
