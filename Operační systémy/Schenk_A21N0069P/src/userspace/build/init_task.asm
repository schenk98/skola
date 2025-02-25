
./init_task:     file format elf32-littlearm


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
    805c:	00009498 	muleq	r0, r8, r4
    8060:	000094a8 	andeq	r9, r0, r8, lsr #9

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
    8080:	eb000069 	bl	822c <main>
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
    81cc:	00009495 	muleq	r0, r5, r4
    81d0:	00009495 	muleq	r0, r5, r4

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
    8224:	00009495 	muleq	r0, r5, r4
    8228:	00009495 	muleq	r0, r5, r4

0000822c <main>:
main():
/home/schenkj/os2022/sp/sources/userspace/init_task/main.cpp:6
#include <stdfile.h>

#include <process/process_manager.h>

int main(int argc, char** argv)
{
    822c:	e92d4800 	push	{fp, lr}
    8230:	e28db004 	add	fp, sp, #4
    8234:	e24dd008 	sub	sp, sp, #8
    8238:	e50b0008 	str	r0, [fp, #-8]
    823c:	e50b100c 	str	r1, [fp, #-12]
/home/schenkj/os2022/sp/sources/userspace/init_task/main.cpp:11
	// systemovy init task startuje jako prvni, a ma nejnizsi prioritu ze vsech - bude se tedy planovat v podstate jen tehdy,
	// kdy nic jineho nikdo nema na praci

	// nastavime deadline na "nekonecno" = vlastne snizime dynamickou prioritu na nejnizsi moznou
	set_task_deadline(Indefinite);
    8240:	e3e00000 	mvn	r0, #0
    8244:	eb0000d7 	bl	85a8 <_Z17set_task_deadlinej>
/home/schenkj/os2022/sp/sources/userspace/init_task/main.cpp:18
	// TODO: tady budeme chtit nechat spoustet zbytek procesu, az budeme umet nacitat treba z eMMC a SD karty
	
	while (true)
	{
		// kdyz je planovany jen tento proces, pockame na udalost (preruseni, ...)
		if (get_active_process_count() == 1)
    8248:	eb0000b8 	bl	8530 <_Z24get_active_process_countv>
    824c:	e1a03000 	mov	r3, r0
    8250:	e3530001 	cmp	r3, #1
    8254:	03a03001 	moveq	r3, #1
    8258:	13a03000 	movne	r3, #0
    825c:	e6ef3073 	uxtb	r3, r3
    8260:	e3530000 	cmp	r3, #0
    8264:	0a000000 	beq	826c <main+0x40>
/home/schenkj/os2022/sp/sources/userspace/init_task/main.cpp:19
			asm volatile("wfe");
    8268:	e320f002 	wfe
/home/schenkj/os2022/sp/sources/userspace/init_task/main.cpp:22

		// predame zbytek casoveho kvanta dalsimu procesu
		sched_yield();
    826c:	eb000016 	bl	82cc <_Z11sched_yieldv>
/home/schenkj/os2022/sp/sources/userspace/init_task/main.cpp:18
		if (get_active_process_count() == 1)
    8270:	eafffff4 	b	8248 <main+0x1c>

00008274 <_Z6getpidv>:
_Z6getpidv():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:5
#include <stdfile.h>
#include <stdstring.h>

uint32_t getpid()
{
    8274:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8278:	e28db000 	add	fp, sp, #0
    827c:	e24dd00c 	sub	sp, sp, #12
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:8
    uint32_t pid;

    asm volatile("swi 0");
    8280:	ef000000 	svc	0x00000000
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:9
    asm volatile("mov %0, r0" : "=r" (pid));
    8284:	e1a03000 	mov	r3, r0
    8288:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:11

    return pid;
    828c:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:12
}
    8290:	e1a00003 	mov	r0, r3
    8294:	e28bd000 	add	sp, fp, #0
    8298:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    829c:	e12fff1e 	bx	lr

000082a0 <_Z9terminatei>:
_Z9terminatei():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:15

void terminate(int exitcode)
{
    82a0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    82a4:	e28db000 	add	fp, sp, #0
    82a8:	e24dd00c 	sub	sp, sp, #12
    82ac:	e50b0008 	str	r0, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:16
    asm volatile("mov r0, %0" : : "r" (exitcode));
    82b0:	e51b3008 	ldr	r3, [fp, #-8]
    82b4:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:17
    asm volatile("swi 1");
    82b8:	ef000001 	svc	0x00000001
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:18
}
    82bc:	e320f000 	nop	{0}
    82c0:	e28bd000 	add	sp, fp, #0
    82c4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    82c8:	e12fff1e 	bx	lr

000082cc <_Z11sched_yieldv>:
_Z11sched_yieldv():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:21

void sched_yield()
{
    82cc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    82d0:	e28db000 	add	fp, sp, #0
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:22
    asm volatile("swi 2");
    82d4:	ef000002 	svc	0x00000002
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:23
}
    82d8:	e320f000 	nop	{0}
    82dc:	e28bd000 	add	sp, fp, #0
    82e0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    82e4:	e12fff1e 	bx	lr

000082e8 <_Z4openPKc15NFile_Open_Mode>:
_Z4openPKc15NFile_Open_Mode():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:26

uint32_t open(const char* filename, NFile_Open_Mode mode)
{
    82e8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    82ec:	e28db000 	add	fp, sp, #0
    82f0:	e24dd014 	sub	sp, sp, #20
    82f4:	e50b0010 	str	r0, [fp, #-16]
    82f8:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:29
    uint32_t file;

    asm volatile("mov r0, %0" : : "r" (filename));
    82fc:	e51b3010 	ldr	r3, [fp, #-16]
    8300:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:30
    asm volatile("mov r1, %0" : : "r" (mode));
    8304:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8308:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:31
    asm volatile("swi 64");
    830c:	ef000040 	svc	0x00000040
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:32
    asm volatile("mov %0, r0" : "=r" (file));
    8310:	e1a03000 	mov	r3, r0
    8314:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:34

    return file;
    8318:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:35
}
    831c:	e1a00003 	mov	r0, r3
    8320:	e28bd000 	add	sp, fp, #0
    8324:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8328:	e12fff1e 	bx	lr

0000832c <_Z4readjPcj>:
_Z4readjPcj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:38

uint32_t read(uint32_t file, char* const buffer, uint32_t size)
{
    832c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8330:	e28db000 	add	fp, sp, #0
    8334:	e24dd01c 	sub	sp, sp, #28
    8338:	e50b0010 	str	r0, [fp, #-16]
    833c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8340:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:41
    uint32_t rdnum;

    asm volatile("mov r0, %0" : : "r" (file));
    8344:	e51b3010 	ldr	r3, [fp, #-16]
    8348:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:42
    asm volatile("mov r1, %0" : : "r" (buffer));
    834c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8350:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:43
    asm volatile("mov r2, %0" : : "r" (size));
    8354:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8358:	e1a02003 	mov	r2, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:44
    asm volatile("swi 65");
    835c:	ef000041 	svc	0x00000041
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:45
    asm volatile("mov %0, r0" : "=r" (rdnum));
    8360:	e1a03000 	mov	r3, r0
    8364:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:47

    return rdnum;
    8368:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:48
}
    836c:	e1a00003 	mov	r0, r3
    8370:	e28bd000 	add	sp, fp, #0
    8374:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8378:	e12fff1e 	bx	lr

0000837c <_Z5writejPKcj>:
_Z5writejPKcj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:51

uint32_t write(uint32_t file, const char* buffer, uint32_t size)
{
    837c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8380:	e28db000 	add	fp, sp, #0
    8384:	e24dd01c 	sub	sp, sp, #28
    8388:	e50b0010 	str	r0, [fp, #-16]
    838c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8390:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:54
    uint32_t wrnum;

    asm volatile("mov r0, %0" : : "r" (file));
    8394:	e51b3010 	ldr	r3, [fp, #-16]
    8398:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:55
    asm volatile("mov r1, %0" : : "r" (buffer));
    839c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    83a0:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:56
    asm volatile("mov r2, %0" : : "r" (size));
    83a4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    83a8:	e1a02003 	mov	r2, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:57
    asm volatile("swi 66");
    83ac:	ef000042 	svc	0x00000042
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:58
    asm volatile("mov %0, r0" : "=r" (wrnum));
    83b0:	e1a03000 	mov	r3, r0
    83b4:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:60

    return wrnum;
    83b8:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:61
}
    83bc:	e1a00003 	mov	r0, r3
    83c0:	e28bd000 	add	sp, fp, #0
    83c4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83c8:	e12fff1e 	bx	lr

000083cc <_Z5closej>:
_Z5closej():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:64

void close(uint32_t file)
{
    83cc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83d0:	e28db000 	add	fp, sp, #0
    83d4:	e24dd00c 	sub	sp, sp, #12
    83d8:	e50b0008 	str	r0, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:65
    asm volatile("mov r0, %0" : : "r" (file));
    83dc:	e51b3008 	ldr	r3, [fp, #-8]
    83e0:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:66
    asm volatile("swi 67");
    83e4:	ef000043 	svc	0x00000043
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:67
}
    83e8:	e320f000 	nop	{0}
    83ec:	e28bd000 	add	sp, fp, #0
    83f0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    83f4:	e12fff1e 	bx	lr

000083f8 <_Z5ioctlj16NIOCtl_OperationPv>:
_Z5ioctlj16NIOCtl_OperationPv():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:70

uint32_t ioctl(uint32_t file, NIOCtl_Operation operation, void* param)
{
    83f8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    83fc:	e28db000 	add	fp, sp, #0
    8400:	e24dd01c 	sub	sp, sp, #28
    8404:	e50b0010 	str	r0, [fp, #-16]
    8408:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    840c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:73
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    8410:	e51b3010 	ldr	r3, [fp, #-16]
    8414:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:74
    asm volatile("mov r1, %0" : : "r" (operation));
    8418:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    841c:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:75
    asm volatile("mov r2, %0" : : "r" (param));
    8420:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8424:	e1a02003 	mov	r2, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:76
    asm volatile("swi 68");
    8428:	ef000044 	svc	0x00000044
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:77
    asm volatile("mov %0, r0" : "=r" (retcode));
    842c:	e1a03000 	mov	r3, r0
    8430:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:79

    return retcode;
    8434:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:80
}
    8438:	e1a00003 	mov	r0, r3
    843c:	e28bd000 	add	sp, fp, #0
    8440:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8444:	e12fff1e 	bx	lr

00008448 <_Z6notifyjj>:
_Z6notifyjj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:83

uint32_t notify(uint32_t file, uint32_t count)
{
    8448:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    844c:	e28db000 	add	fp, sp, #0
    8450:	e24dd014 	sub	sp, sp, #20
    8454:	e50b0010 	str	r0, [fp, #-16]
    8458:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:86
    uint32_t retcnt;

    asm volatile("mov r0, %0" : : "r" (file));
    845c:	e51b3010 	ldr	r3, [fp, #-16]
    8460:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:87
    asm volatile("mov r1, %0" : : "r" (count));
    8464:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8468:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:88
    asm volatile("swi 69");
    846c:	ef000045 	svc	0x00000045
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:89
    asm volatile("mov %0, r0" : "=r" (retcnt));
    8470:	e1a03000 	mov	r3, r0
    8474:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:91

    return retcnt;
    8478:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:92
}
    847c:	e1a00003 	mov	r0, r3
    8480:	e28bd000 	add	sp, fp, #0
    8484:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8488:	e12fff1e 	bx	lr

0000848c <_Z4waitjjj>:
_Z4waitjjj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:95

NSWI_Result_Code wait(uint32_t file, uint32_t count, uint32_t notified_deadline)
{
    848c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8490:	e28db000 	add	fp, sp, #0
    8494:	e24dd01c 	sub	sp, sp, #28
    8498:	e50b0010 	str	r0, [fp, #-16]
    849c:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    84a0:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:98
    NSWI_Result_Code retcode;

    asm volatile("mov r0, %0" : : "r" (file));
    84a4:	e51b3010 	ldr	r3, [fp, #-16]
    84a8:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:99
    asm volatile("mov r1, %0" : : "r" (count));
    84ac:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84b0:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:100
    asm volatile("mov r2, %0" : : "r" (notified_deadline));
    84b4:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    84b8:	e1a02003 	mov	r2, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:101
    asm volatile("swi 70");
    84bc:	ef000046 	svc	0x00000046
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:102
    asm volatile("mov %0, r0" : "=r" (retcode));
    84c0:	e1a03000 	mov	r3, r0
    84c4:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:104

    return retcode;
    84c8:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:105
}
    84cc:	e1a00003 	mov	r0, r3
    84d0:	e28bd000 	add	sp, fp, #0
    84d4:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    84d8:	e12fff1e 	bx	lr

000084dc <_Z5sleepjj>:
_Z5sleepjj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:108

bool sleep(uint32_t ticks, uint32_t notified_deadline)
{
    84dc:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    84e0:	e28db000 	add	fp, sp, #0
    84e4:	e24dd014 	sub	sp, sp, #20
    84e8:	e50b0010 	str	r0, [fp, #-16]
    84ec:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:111
    uint32_t retcode;

    asm volatile("mov r0, %0" : : "r" (ticks));
    84f0:	e51b3010 	ldr	r3, [fp, #-16]
    84f4:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:112
    asm volatile("mov r1, %0" : : "r" (notified_deadline));
    84f8:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    84fc:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:113
    asm volatile("swi 3");
    8500:	ef000003 	svc	0x00000003
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:114
    asm volatile("mov %0, r0" : "=r" (retcode));
    8504:	e1a03000 	mov	r3, r0
    8508:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:116

    return retcode;
    850c:	e51b3008 	ldr	r3, [fp, #-8]
    8510:	e3530000 	cmp	r3, #0
    8514:	13a03001 	movne	r3, #1
    8518:	03a03000 	moveq	r3, #0
    851c:	e6ef3073 	uxtb	r3, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:117
}
    8520:	e1a00003 	mov	r0, r3
    8524:	e28bd000 	add	sp, fp, #0
    8528:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    852c:	e12fff1e 	bx	lr

00008530 <_Z24get_active_process_countv>:
_Z24get_active_process_countv():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:120

uint32_t get_active_process_count()
{
    8530:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8534:	e28db000 	add	fp, sp, #0
    8538:	e24dd00c 	sub	sp, sp, #12
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:121
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Active_Process_Count;
    853c:	e3a03000 	mov	r3, #0
    8540:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:124
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    8544:	e3a03000 	mov	r3, #0
    8548:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:125
    asm volatile("mov r1, %0" : : "r" (&retval));
    854c:	e24b300c 	sub	r3, fp, #12
    8550:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:126
    asm volatile("swi 4");
    8554:	ef000004 	svc	0x00000004
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:128

    return retval;
    8558:	e51b300c 	ldr	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:129
}
    855c:	e1a00003 	mov	r0, r3
    8560:	e28bd000 	add	sp, fp, #0
    8564:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8568:	e12fff1e 	bx	lr

0000856c <_Z14get_tick_countv>:
_Z14get_tick_countv():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:132

uint32_t get_tick_count()
{
    856c:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8570:	e28db000 	add	fp, sp, #0
    8574:	e24dd00c 	sub	sp, sp, #12
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:133
    const NGet_Sched_Info_Type req = NGet_Sched_Info_Type::Tick_Count;
    8578:	e3a03001 	mov	r3, #1
    857c:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:136
    uint32_t retval;

    asm volatile("mov r0, %0" : : "r" (req));
    8580:	e3a03001 	mov	r3, #1
    8584:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:137
    asm volatile("mov r1, %0" : : "r" (&retval));
    8588:	e24b300c 	sub	r3, fp, #12
    858c:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:138
    asm volatile("swi 4");
    8590:	ef000004 	svc	0x00000004
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:140

    return retval;
    8594:	e51b300c 	ldr	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:141
}
    8598:	e1a00003 	mov	r0, r3
    859c:	e28bd000 	add	sp, fp, #0
    85a0:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85a4:	e12fff1e 	bx	lr

000085a8 <_Z17set_task_deadlinej>:
_Z17set_task_deadlinej():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:144

void set_task_deadline(uint32_t tick_count_required)
{
    85a8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85ac:	e28db000 	add	fp, sp, #0
    85b0:	e24dd014 	sub	sp, sp, #20
    85b4:	e50b0010 	str	r0, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:145
    const NDeadline_Subservice req = NDeadline_Subservice::Set_Relative;
    85b8:	e3a03000 	mov	r3, #0
    85bc:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:147

    asm volatile("mov r0, %0" : : "r" (req));
    85c0:	e3a03000 	mov	r3, #0
    85c4:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:148
    asm volatile("mov r1, %0" : : "r" (&tick_count_required));
    85c8:	e24b3010 	sub	r3, fp, #16
    85cc:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:149
    asm volatile("swi 5");
    85d0:	ef000005 	svc	0x00000005
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:150
}
    85d4:	e320f000 	nop	{0}
    85d8:	e28bd000 	add	sp, fp, #0
    85dc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    85e0:	e12fff1e 	bx	lr

000085e4 <_Z26get_task_ticks_to_deadlinev>:
_Z26get_task_ticks_to_deadlinev():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:153

uint32_t get_task_ticks_to_deadline()
{
    85e4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    85e8:	e28db000 	add	fp, sp, #0
    85ec:	e24dd00c 	sub	sp, sp, #12
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:154
    const NDeadline_Subservice req = NDeadline_Subservice::Get_Remaining;
    85f0:	e3a03001 	mov	r3, #1
    85f4:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:157
    uint32_t ticks;

    asm volatile("mov r0, %0" : : "r" (req));
    85f8:	e3a03001 	mov	r3, #1
    85fc:	e1a00003 	mov	r0, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:158
    asm volatile("mov r1, %0" : : "r" (&ticks));
    8600:	e24b300c 	sub	r3, fp, #12
    8604:	e1a01003 	mov	r1, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:159
    asm volatile("swi 5");
    8608:	ef000005 	svc	0x00000005
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:161

    return ticks;
    860c:	e51b300c 	ldr	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:162
}
    8610:	e1a00003 	mov	r0, r3
    8614:	e28bd000 	add	sp, fp, #0
    8618:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    861c:	e12fff1e 	bx	lr

00008620 <_Z4pipePKcj>:
_Z4pipePKcj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:167

const char Pipe_File_Prefix[] = "SYS:pipe/";

uint32_t pipe(const char* name, uint32_t buf_size)
{
    8620:	e92d4800 	push	{fp, lr}
    8624:	e28db004 	add	fp, sp, #4
    8628:	e24dd050 	sub	sp, sp, #80	; 0x50
    862c:	e50b0050 	str	r0, [fp, #-80]	; 0xffffffb0
    8630:	e50b1054 	str	r1, [fp, #-84]	; 0xffffffac
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:169
    char fname[64];
    strncpy(fname, Pipe_File_Prefix, sizeof(Pipe_File_Prefix));
    8634:	e24b3048 	sub	r3, fp, #72	; 0x48
    8638:	e3a0200a 	mov	r2, #10
    863c:	e59f1088 	ldr	r1, [pc, #136]	; 86cc <_Z4pipePKcj+0xac>
    8640:	e1a00003 	mov	r0, r3
    8644:	eb000212 	bl	8e94 <_Z7strncpyPcPKci>
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:170
    strncpy(fname + sizeof(Pipe_File_Prefix), name, sizeof(fname) - sizeof(Pipe_File_Prefix) - 1);
    8648:	e24b3048 	sub	r3, fp, #72	; 0x48
    864c:	e283300a 	add	r3, r3, #10
    8650:	e3a02035 	mov	r2, #53	; 0x35
    8654:	e51b1050 	ldr	r1, [fp, #-80]	; 0xffffffb0
    8658:	e1a00003 	mov	r0, r3
    865c:	eb00020c 	bl	8e94 <_Z7strncpyPcPKci>
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:172

    int ncur = sizeof(Pipe_File_Prefix) + strlen(name);
    8660:	e51b0050 	ldr	r0, [fp, #-80]	; 0xffffffb0
    8664:	eb00029a 	bl	90d4 <_Z6strlenPKc>
    8668:	e1a03000 	mov	r3, r0
    866c:	e283300a 	add	r3, r3, #10
    8670:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:174

    fname[ncur++] = '#';
    8674:	e51b3008 	ldr	r3, [fp, #-8]
    8678:	e2832001 	add	r2, r3, #1
    867c:	e50b2008 	str	r2, [fp, #-8]
    8680:	e24b2004 	sub	r2, fp, #4
    8684:	e0823003 	add	r3, r2, r3
    8688:	e3a02023 	mov	r2, #35	; 0x23
    868c:	e5432044 	strb	r2, [r3, #-68]	; 0xffffffbc
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:176

    itoa(buf_size, &fname[ncur], 10);
    8690:	e24b2048 	sub	r2, fp, #72	; 0x48
    8694:	e51b3008 	ldr	r3, [fp, #-8]
    8698:	e0823003 	add	r3, r2, r3
    869c:	e3a0200a 	mov	r2, #10
    86a0:	e1a01003 	mov	r1, r3
    86a4:	e51b0054 	ldr	r0, [fp, #-84]	; 0xffffffac
    86a8:	eb000008 	bl	86d0 <_Z4itoajPcj>
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:178

    return open(fname, NFile_Open_Mode::Read_Write);
    86ac:	e24b3048 	sub	r3, fp, #72	; 0x48
    86b0:	e3a01002 	mov	r1, #2
    86b4:	e1a00003 	mov	r0, r3
    86b8:	ebffff0a 	bl	82e8 <_Z4openPKc15NFile_Open_Mode>
    86bc:	e1a03000 	mov	r3, r0
/home/schenkj/os2022/sp/sources/stdlib/src/stdfile.cpp:179
}
    86c0:	e1a00003 	mov	r0, r3
    86c4:	e24bd004 	sub	sp, fp, #4
    86c8:	e8bd8800 	pop	{fp, pc}
    86cc:	00009478 	andeq	r9, r0, r8, ror r4

000086d0 <_Z4itoajPcj>:
_Z4itoajPcj():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:11
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(unsigned int input, char* output, unsigned int base)
{
    86d0:	e92d4800 	push	{fp, lr}
    86d4:	e28db004 	add	fp, sp, #4
    86d8:	e24dd020 	sub	sp, sp, #32
    86dc:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    86e0:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    86e4:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:12
	int i = 0;
    86e8:	e3a03000 	mov	r3, #0
    86ec:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:14

	while (input > 0)
    86f0:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    86f4:	e3530000 	cmp	r3, #0
    86f8:	0a000014 	beq	8750 <_Z4itoajPcj+0x80>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:16
	{
		output[i] = CharConvArr[input % base];
    86fc:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8700:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    8704:	e1a00003 	mov	r0, r3
    8708:	eb00033b 	bl	93fc <__aeabi_uidivmod>
    870c:	e1a03001 	mov	r3, r1
    8710:	e1a01003 	mov	r1, r3
    8714:	e51b3008 	ldr	r3, [fp, #-8]
    8718:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    871c:	e0823003 	add	r3, r2, r3
    8720:	e59f2118 	ldr	r2, [pc, #280]	; 8840 <_Z4itoajPcj+0x170>
    8724:	e7d22001 	ldrb	r2, [r2, r1]
    8728:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:17
		input /= base;
    872c:	e51b1020 	ldr	r1, [fp, #-32]	; 0xffffffe0
    8730:	e51b0018 	ldr	r0, [fp, #-24]	; 0xffffffe8
    8734:	eb0002b5 	bl	9210 <__udivsi3>
    8738:	e1a03000 	mov	r3, r0
    873c:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:18
		i++;
    8740:	e51b3008 	ldr	r3, [fp, #-8]
    8744:	e2833001 	add	r3, r3, #1
    8748:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:14
	while (input > 0)
    874c:	eaffffe7 	b	86f0 <_Z4itoajPcj+0x20>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:21
	}

    if (i == 0)
    8750:	e51b3008 	ldr	r3, [fp, #-8]
    8754:	e3530000 	cmp	r3, #0
    8758:	1a000007 	bne	877c <_Z4itoajPcj+0xac>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:23
    {
        output[i] = CharConvArr[0];
    875c:	e51b3008 	ldr	r3, [fp, #-8]
    8760:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8764:	e0823003 	add	r3, r2, r3
    8768:	e3a02030 	mov	r2, #48	; 0x30
    876c:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:24
        i++;
    8770:	e51b3008 	ldr	r3, [fp, #-8]
    8774:	e2833001 	add	r3, r3, #1
    8778:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:27
    }

	output[i] = '\0';
    877c:	e51b3008 	ldr	r3, [fp, #-8]
    8780:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8784:	e0823003 	add	r3, r2, r3
    8788:	e3a02000 	mov	r2, #0
    878c:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:28
	i--;
    8790:	e51b3008 	ldr	r3, [fp, #-8]
    8794:	e2433001 	sub	r3, r3, #1
    8798:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:30

	for (int j = 0; j <= i/2; j++)
    879c:	e3a03000 	mov	r3, #0
    87a0:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:30 (discriminator 3)
    87a4:	e51b3008 	ldr	r3, [fp, #-8]
    87a8:	e1a02fa3 	lsr	r2, r3, #31
    87ac:	e0823003 	add	r3, r2, r3
    87b0:	e1a030c3 	asr	r3, r3, #1
    87b4:	e1a02003 	mov	r2, r3
    87b8:	e51b300c 	ldr	r3, [fp, #-12]
    87bc:	e1530002 	cmp	r3, r2
    87c0:	ca00001b 	bgt	8834 <_Z4itoajPcj+0x164>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:32 (discriminator 2)
	{
		char c = output[i - j];
    87c4:	e51b2008 	ldr	r2, [fp, #-8]
    87c8:	e51b300c 	ldr	r3, [fp, #-12]
    87cc:	e0423003 	sub	r3, r2, r3
    87d0:	e1a02003 	mov	r2, r3
    87d4:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    87d8:	e0833002 	add	r3, r3, r2
    87dc:	e5d33000 	ldrb	r3, [r3]
    87e0:	e54b300d 	strb	r3, [fp, #-13]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:33 (discriminator 2)
		output[i - j] = output[j];
    87e4:	e51b300c 	ldr	r3, [fp, #-12]
    87e8:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    87ec:	e0822003 	add	r2, r2, r3
    87f0:	e51b1008 	ldr	r1, [fp, #-8]
    87f4:	e51b300c 	ldr	r3, [fp, #-12]
    87f8:	e0413003 	sub	r3, r1, r3
    87fc:	e1a01003 	mov	r1, r3
    8800:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    8804:	e0833001 	add	r3, r3, r1
    8808:	e5d22000 	ldrb	r2, [r2]
    880c:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:34 (discriminator 2)
		output[j] = c;
    8810:	e51b300c 	ldr	r3, [fp, #-12]
    8814:	e51b201c 	ldr	r2, [fp, #-28]	; 0xffffffe4
    8818:	e0823003 	add	r3, r2, r3
    881c:	e55b200d 	ldrb	r2, [fp, #-13]
    8820:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:30 (discriminator 2)
	for (int j = 0; j <= i/2; j++)
    8824:	e51b300c 	ldr	r3, [fp, #-12]
    8828:	e2833001 	add	r3, r3, #1
    882c:	e50b300c 	str	r3, [fp, #-12]
    8830:	eaffffdb 	b	87a4 <_Z4itoajPcj+0xd4>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:36
	}
}
    8834:	e320f000 	nop	{0}
    8838:	e24bd004 	sub	sp, fp, #4
    883c:	e8bd8800 	pop	{fp, pc}
    8840:	00009484 	andeq	r9, r0, r4, lsl #9

00008844 <_Z4atoiPKc>:
_Z4atoiPKc():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:39

int atoi(const char* input)
{
    8844:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8848:	e28db000 	add	fp, sp, #0
    884c:	e24dd014 	sub	sp, sp, #20
    8850:	e50b0010 	str	r0, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:40
	int output = 0;
    8854:	e3a03000 	mov	r3, #0
    8858:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:42

	while (*input != '\0')
    885c:	e51b3010 	ldr	r3, [fp, #-16]
    8860:	e5d33000 	ldrb	r3, [r3]
    8864:	e3530000 	cmp	r3, #0
    8868:	0a000017 	beq	88cc <_Z4atoiPKc+0x88>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:44
	{
		output *= 10;
    886c:	e51b2008 	ldr	r2, [fp, #-8]
    8870:	e1a03002 	mov	r3, r2
    8874:	e1a03103 	lsl	r3, r3, #2
    8878:	e0833002 	add	r3, r3, r2
    887c:	e1a03083 	lsl	r3, r3, #1
    8880:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:45
		if (*input > '9' || *input < '0')
    8884:	e51b3010 	ldr	r3, [fp, #-16]
    8888:	e5d33000 	ldrb	r3, [r3]
    888c:	e3530039 	cmp	r3, #57	; 0x39
    8890:	8a00000d 	bhi	88cc <_Z4atoiPKc+0x88>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:45 (discriminator 1)
    8894:	e51b3010 	ldr	r3, [fp, #-16]
    8898:	e5d33000 	ldrb	r3, [r3]
    889c:	e353002f 	cmp	r3, #47	; 0x2f
    88a0:	9a000009 	bls	88cc <_Z4atoiPKc+0x88>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:48
			break;

		output += *input - '0';
    88a4:	e51b3010 	ldr	r3, [fp, #-16]
    88a8:	e5d33000 	ldrb	r3, [r3]
    88ac:	e2433030 	sub	r3, r3, #48	; 0x30
    88b0:	e51b2008 	ldr	r2, [fp, #-8]
    88b4:	e0823003 	add	r3, r2, r3
    88b8:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:50

		input++;
    88bc:	e51b3010 	ldr	r3, [fp, #-16]
    88c0:	e2833001 	add	r3, r3, #1
    88c4:	e50b3010 	str	r3, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:42
	while (*input != '\0')
    88c8:	eaffffe3 	b	885c <_Z4atoiPKc+0x18>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:53
	}

	return output;
    88cc:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:54
}
    88d0:	e1a00003 	mov	r0, r3
    88d4:	e28bd000 	add	sp, fp, #0
    88d8:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    88dc:	e12fff1e 	bx	lr

000088e0 <_Z9normalizePf>:
_Z9normalizePf():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:57


int normalize(float *val) {
    88e0:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    88e4:	e28db000 	add	fp, sp, #0
    88e8:	e24dd014 	sub	sp, sp, #20
    88ec:	e50b0010 	str	r0, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:58
    int exponent = 0;
    88f0:	e3a03000 	mov	r3, #0
    88f4:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:59
    float value = *val;
    88f8:	e51b3010 	ldr	r3, [fp, #-16]
    88fc:	e5933000 	ldr	r3, [r3]
    8900:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:61

    while (value >= 1.0) {
    8904:	ed5b7a03 	vldr	s15, [fp, #-12]
    8908:	ed9f7a24 	vldr	s14, [pc, #144]	; 89a0 <_Z9normalizePf+0xc0>
    890c:	eef47ac7 	vcmpe.f32	s15, s14
    8910:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8914:	aa000000 	bge	891c <_Z9normalizePf+0x3c>
    8918:	ea000007 	b	893c <_Z9normalizePf+0x5c>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:62
        value = value / 10.0;
    891c:	ed1b7a03 	vldr	s14, [fp, #-12]
    8920:	eddf6a1f 	vldr	s13, [pc, #124]	; 89a4 <_Z9normalizePf+0xc4>
    8924:	eec77a26 	vdiv.f32	s15, s14, s13
    8928:	ed4b7a03 	vstr	s15, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:63
        ++exponent;
    892c:	e51b3008 	ldr	r3, [fp, #-8]
    8930:	e2833001 	add	r3, r3, #1
    8934:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:61
    while (value >= 1.0) {
    8938:	eafffff1 	b	8904 <_Z9normalizePf+0x24>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:66
    }

    while (value < 0.1) {
    893c:	ed5b7a03 	vldr	s15, [fp, #-12]
    8940:	eeb77ae7 	vcvt.f64.f32	d7, s15
    8944:	ed9f6b13 	vldr	d6, [pc, #76]	; 8998 <_Z9normalizePf+0xb8>
    8948:	eeb47bc6 	vcmpe.f64	d7, d6
    894c:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8950:	5a000007 	bpl	8974 <_Z9normalizePf+0x94>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:67
        value = value * 10.0;
    8954:	ed5b7a03 	vldr	s15, [fp, #-12]
    8958:	ed9f7a11 	vldr	s14, [pc, #68]	; 89a4 <_Z9normalizePf+0xc4>
    895c:	ee677a87 	vmul.f32	s15, s15, s14
    8960:	ed4b7a03 	vstr	s15, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:68
        --exponent;
    8964:	e51b3008 	ldr	r3, [fp, #-8]
    8968:	e2433001 	sub	r3, r3, #1
    896c:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:66
    while (value < 0.1) {
    8970:	eafffff1 	b	893c <_Z9normalizePf+0x5c>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:70
    }
    *val = value;
    8974:	e51b3010 	ldr	r3, [fp, #-16]
    8978:	e51b200c 	ldr	r2, [fp, #-12]
    897c:	e5832000 	str	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:71
    return exponent;
    8980:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:72
}
    8984:	e1a00003 	mov	r0, r3
    8988:	e28bd000 	add	sp, fp, #0
    898c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8990:	e12fff1e 	bx	lr
    8994:	e320f000 	nop	{0}
    8998:	9999999a 	ldmibls	r9, {r1, r3, r4, r7, r8, fp, ip, pc}
    899c:	3fb99999 	svccc	0x00b99999
    89a0:	3f800000 	svccc	0x00800000
    89a4:	41200000 			; <UNDEFINED> instruction: 0x41200000

000089a8 <_Z4atofPKc>:
_Z4atofPKc():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:75

float atof(const char *s)
{
    89a8:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    89ac:	e28db000 	add	fp, sp, #0
    89b0:	e24dd024 	sub	sp, sp, #36	; 0x24
    89b4:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:76
  float a = 0.0;
    89b8:	e3a03000 	mov	r3, #0
    89bc:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:77
  int e = 0;
    89c0:	e3a03000 	mov	r3, #0
    89c4:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:79
  int c;
  while ((c = *s++) != '\0' && digit_range(c)) {
    89c8:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    89cc:	e2832001 	add	r2, r3, #1
    89d0:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    89d4:	e5d33000 	ldrb	r3, [r3]
    89d8:	e50b3010 	str	r3, [fp, #-16]
    89dc:	e51b3010 	ldr	r3, [fp, #-16]
    89e0:	e3530000 	cmp	r3, #0
    89e4:	0a000007 	beq	8a08 <_Z4atofPKc+0x60>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:79 (discriminator 1)
    89e8:	e51b3010 	ldr	r3, [fp, #-16]
    89ec:	e353002f 	cmp	r3, #47	; 0x2f
    89f0:	da000004 	ble	8a08 <_Z4atofPKc+0x60>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:79 (discriminator 3)
    89f4:	e51b3010 	ldr	r3, [fp, #-16]
    89f8:	e3530039 	cmp	r3, #57	; 0x39
    89fc:	ca000001 	bgt	8a08 <_Z4atofPKc+0x60>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:79 (discriminator 5)
    8a00:	e3a03001 	mov	r3, #1
    8a04:	ea000000 	b	8a0c <_Z4atofPKc+0x64>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:79 (discriminator 6)
    8a08:	e3a03000 	mov	r3, #0
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:79 (discriminator 8)
    8a0c:	e3530000 	cmp	r3, #0
    8a10:	0a00000b 	beq	8a44 <_Z4atofPKc+0x9c>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:80
    a = a*10.0 + (c - '0');
    8a14:	ed5b7a02 	vldr	s15, [fp, #-8]
    8a18:	eeb77ae7 	vcvt.f64.f32	d7, s15
    8a1c:	ed9f6b89 	vldr	d6, [pc, #548]	; 8c48 <_Z4atofPKc+0x2a0>
    8a20:	ee276b06 	vmul.f64	d6, d7, d6
    8a24:	e51b3010 	ldr	r3, [fp, #-16]
    8a28:	e2433030 	sub	r3, r3, #48	; 0x30
    8a2c:	ee073a90 	vmov	s15, r3
    8a30:	eeb87be7 	vcvt.f64.s32	d7, s15
    8a34:	ee367b07 	vadd.f64	d7, d6, d7
    8a38:	eef77bc7 	vcvt.f32.f64	s15, d7
    8a3c:	ed4b7a02 	vstr	s15, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:79
  while ((c = *s++) != '\0' && digit_range(c)) {
    8a40:	eaffffe0 	b	89c8 <_Z4atofPKc+0x20>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:82
  }
  if (c == '.') {
    8a44:	e51b3010 	ldr	r3, [fp, #-16]
    8a48:	e353002e 	cmp	r3, #46	; 0x2e
    8a4c:	1a000021 	bne	8ad8 <_Z4atofPKc+0x130>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:83
    while ((c = *s++) != '\0' && digit_range(c)) {
    8a50:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8a54:	e2832001 	add	r2, r3, #1
    8a58:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8a5c:	e5d33000 	ldrb	r3, [r3]
    8a60:	e50b3010 	str	r3, [fp, #-16]
    8a64:	e51b3010 	ldr	r3, [fp, #-16]
    8a68:	e3530000 	cmp	r3, #0
    8a6c:	0a000007 	beq	8a90 <_Z4atofPKc+0xe8>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:83 (discriminator 1)
    8a70:	e51b3010 	ldr	r3, [fp, #-16]
    8a74:	e353002f 	cmp	r3, #47	; 0x2f
    8a78:	da000004 	ble	8a90 <_Z4atofPKc+0xe8>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:83 (discriminator 3)
    8a7c:	e51b3010 	ldr	r3, [fp, #-16]
    8a80:	e3530039 	cmp	r3, #57	; 0x39
    8a84:	ca000001 	bgt	8a90 <_Z4atofPKc+0xe8>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:83 (discriminator 5)
    8a88:	e3a03001 	mov	r3, #1
    8a8c:	ea000000 	b	8a94 <_Z4atofPKc+0xec>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:83 (discriminator 6)
    8a90:	e3a03000 	mov	r3, #0
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:83 (discriminator 8)
    8a94:	e3530000 	cmp	r3, #0
    8a98:	0a00000e 	beq	8ad8 <_Z4atofPKc+0x130>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:84
      a = a*10.0 + (c - '0');
    8a9c:	ed5b7a02 	vldr	s15, [fp, #-8]
    8aa0:	eeb77ae7 	vcvt.f64.f32	d7, s15
    8aa4:	ed9f6b67 	vldr	d6, [pc, #412]	; 8c48 <_Z4atofPKc+0x2a0>
    8aa8:	ee276b06 	vmul.f64	d6, d7, d6
    8aac:	e51b3010 	ldr	r3, [fp, #-16]
    8ab0:	e2433030 	sub	r3, r3, #48	; 0x30
    8ab4:	ee073a90 	vmov	s15, r3
    8ab8:	eeb87be7 	vcvt.f64.s32	d7, s15
    8abc:	ee367b07 	vadd.f64	d7, d6, d7
    8ac0:	eef77bc7 	vcvt.f32.f64	s15, d7
    8ac4:	ed4b7a02 	vstr	s15, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:85
      e = e-1;
    8ac8:	e51b300c 	ldr	r3, [fp, #-12]
    8acc:	e2433001 	sub	r3, r3, #1
    8ad0:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:83
    while ((c = *s++) != '\0' && digit_range(c)) {
    8ad4:	eaffffdd 	b	8a50 <_Z4atofPKc+0xa8>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:88
    }
  }
  if (c == 'e' || c == 'E') {
    8ad8:	e51b3010 	ldr	r3, [fp, #-16]
    8adc:	e3530065 	cmp	r3, #101	; 0x65
    8ae0:	0a000002 	beq	8af0 <_Z4atofPKc+0x148>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:88 (discriminator 1)
    8ae4:	e51b3010 	ldr	r3, [fp, #-16]
    8ae8:	e3530045 	cmp	r3, #69	; 0x45
    8aec:	1a000037 	bne	8bd0 <_Z4atofPKc+0x228>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:89
    int sign = 1;
    8af0:	e3a03001 	mov	r3, #1
    8af4:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:90
    int i = 0;
    8af8:	e3a03000 	mov	r3, #0
    8afc:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:91
    c = *s++;
    8b00:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8b04:	e2832001 	add	r2, r3, #1
    8b08:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8b0c:	e5d33000 	ldrb	r3, [r3]
    8b10:	e50b3010 	str	r3, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:92
    if (c == '+')
    8b14:	e51b3010 	ldr	r3, [fp, #-16]
    8b18:	e353002b 	cmp	r3, #43	; 0x2b
    8b1c:	1a000005 	bne	8b38 <_Z4atofPKc+0x190>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:93
      c = *s++;
    8b20:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8b24:	e2832001 	add	r2, r3, #1
    8b28:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8b2c:	e5d33000 	ldrb	r3, [r3]
    8b30:	e50b3010 	str	r3, [fp, #-16]
    8b34:	ea000009 	b	8b60 <_Z4atofPKc+0x1b8>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:94
    else if (c == '-') {
    8b38:	e51b3010 	ldr	r3, [fp, #-16]
    8b3c:	e353002d 	cmp	r3, #45	; 0x2d
    8b40:	1a000006 	bne	8b60 <_Z4atofPKc+0x1b8>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:95
      c = *s++;
    8b44:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8b48:	e2832001 	add	r2, r3, #1
    8b4c:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8b50:	e5d33000 	ldrb	r3, [r3]
    8b54:	e50b3010 	str	r3, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:96
      sign = -1;
    8b58:	e3e03000 	mvn	r3, #0
    8b5c:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:98
    }
    while (digit_range(c)) {
    8b60:	e51b3010 	ldr	r3, [fp, #-16]
    8b64:	e353002f 	cmp	r3, #47	; 0x2f
    8b68:	da000012 	ble	8bb8 <_Z4atofPKc+0x210>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:98 (discriminator 1)
    8b6c:	e51b3010 	ldr	r3, [fp, #-16]
    8b70:	e3530039 	cmp	r3, #57	; 0x39
    8b74:	ca00000f 	bgt	8bb8 <_Z4atofPKc+0x210>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:99
      i = i*10 + (c - '0');
    8b78:	e51b2018 	ldr	r2, [fp, #-24]	; 0xffffffe8
    8b7c:	e1a03002 	mov	r3, r2
    8b80:	e1a03103 	lsl	r3, r3, #2
    8b84:	e0833002 	add	r3, r3, r2
    8b88:	e1a03083 	lsl	r3, r3, #1
    8b8c:	e1a02003 	mov	r2, r3
    8b90:	e51b3010 	ldr	r3, [fp, #-16]
    8b94:	e2433030 	sub	r3, r3, #48	; 0x30
    8b98:	e0823003 	add	r3, r2, r3
    8b9c:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:100
      c = *s++;
    8ba0:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8ba4:	e2832001 	add	r2, r3, #1
    8ba8:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8bac:	e5d33000 	ldrb	r3, [r3]
    8bb0:	e50b3010 	str	r3, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:98
    while (digit_range(c)) {
    8bb4:	eaffffe9 	b	8b60 <_Z4atofPKc+0x1b8>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:102
    }
    e += i*sign;
    8bb8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8bbc:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8bc0:	e0030392 	mul	r3, r2, r3
    8bc4:	e51b200c 	ldr	r2, [fp, #-12]
    8bc8:	e0823003 	add	r3, r2, r3
    8bcc:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:104
  }
  while (e > 0) {
    8bd0:	e51b300c 	ldr	r3, [fp, #-12]
    8bd4:	e3530000 	cmp	r3, #0
    8bd8:	da000007 	ble	8bfc <_Z4atofPKc+0x254>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:105
    a *= 10.0;
    8bdc:	ed5b7a02 	vldr	s15, [fp, #-8]
    8be0:	ed9f7a1c 	vldr	s14, [pc, #112]	; 8c58 <_Z4atofPKc+0x2b0>
    8be4:	ee677a87 	vmul.f32	s15, s15, s14
    8be8:	ed4b7a02 	vstr	s15, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:106
    e--;
    8bec:	e51b300c 	ldr	r3, [fp, #-12]
    8bf0:	e2433001 	sub	r3, r3, #1
    8bf4:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:104
  while (e > 0) {
    8bf8:	eafffff4 	b	8bd0 <_Z4atofPKc+0x228>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:108
  }
  while (e < 0) {
    8bfc:	e51b300c 	ldr	r3, [fp, #-12]
    8c00:	e3530000 	cmp	r3, #0
    8c04:	aa000009 	bge	8c30 <_Z4atofPKc+0x288>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:109
    a *= 0.1;
    8c08:	ed5b7a02 	vldr	s15, [fp, #-8]
    8c0c:	eeb77ae7 	vcvt.f64.f32	d7, s15
    8c10:	ed9f6b0e 	vldr	d6, [pc, #56]	; 8c50 <_Z4atofPKc+0x2a8>
    8c14:	ee277b06 	vmul.f64	d7, d7, d6
    8c18:	eef77bc7 	vcvt.f32.f64	s15, d7
    8c1c:	ed4b7a02 	vstr	s15, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:110
    e++;
    8c20:	e51b300c 	ldr	r3, [fp, #-12]
    8c24:	e2833001 	add	r3, r3, #1
    8c28:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:108
  while (e < 0) {
    8c2c:	eafffff2 	b	8bfc <_Z4atofPKc+0x254>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:112
  }
  return a;
    8c30:	e51b3008 	ldr	r3, [fp, #-8]
    8c34:	ee073a90 	vmov	s15, r3
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:113
}
    8c38:	eeb00a67 	vmov.f32	s0, s15
    8c3c:	e28bd000 	add	sp, fp, #0
    8c40:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8c44:	e12fff1e 	bx	lr
    8c48:	00000000 	andeq	r0, r0, r0
    8c4c:	40240000 	eormi	r0, r4, r0
    8c50:	9999999a 	ldmibls	r9, {r1, r3, r4, r7, r8, fp, ip, pc}
    8c54:	3fb99999 	svccc	0x00b99999
    8c58:	41200000 			; <UNDEFINED> instruction: 0x41200000

00008c5c <_Z4ftoaPcf>:
_Z4ftoaPcf():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:115

void ftoa(char *buffer, float value) {  
    8c5c:	e92d4800 	push	{fp, lr}
    8c60:	e28db004 	add	fp, sp, #4
    8c64:	e24dd020 	sub	sp, sp, #32
    8c68:	e50b0020 	str	r0, [fp, #-32]	; 0xffffffe0
    8c6c:	ed0b0a09 	vstr	s0, [fp, #-36]	; 0xffffffdc
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:116
    int exponent = 0;
    8c70:	e3a03000 	mov	r3, #0
    8c74:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:117
    int places = 0;
    8c78:	e3a03000 	mov	r3, #0
    8c7c:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:118
    const int width = 6;
    8c80:	e3a03006 	mov	r3, #6
    8c84:	e50b3010 	str	r3, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:120

    if (value == 0.0) {
    8c88:	ed5b7a09 	vldr	s15, [fp, #-36]	; 0xffffffdc
    8c8c:	eef57a40 	vcmp.f32	s15, #0.0
    8c90:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8c94:	1a000007 	bne	8cb8 <_Z4ftoaPcf+0x5c>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:121
        buffer[0] = '0';
    8c98:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8c9c:	e3a02030 	mov	r2, #48	; 0x30
    8ca0:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:122
        buffer[1] = '\0';
    8ca4:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8ca8:	e2833001 	add	r3, r3, #1
    8cac:	e3a02000 	mov	r2, #0
    8cb0:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:123
        return;
    8cb4:	ea000071 	b	8e80 <_Z4ftoaPcf+0x224>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:126
    } 

    if (value < 0.0) {
    8cb8:	ed5b7a09 	vldr	s15, [fp, #-36]	; 0xffffffdc
    8cbc:	eef57ac0 	vcmpe.f32	s15, #0.0
    8cc0:	eef1fa10 	vmrs	APSR_nzcv, fpscr
    8cc4:	5a000007 	bpl	8ce8 <_Z4ftoaPcf+0x8c>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:127
        *buffer++ = '-';
    8cc8:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8ccc:	e2832001 	add	r2, r3, #1
    8cd0:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8cd4:	e3a0202d 	mov	r2, #45	; 0x2d
    8cd8:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:128
        value = -value;
    8cdc:	ed5b7a09 	vldr	s15, [fp, #-36]	; 0xffffffdc
    8ce0:	eef17a67 	vneg.f32	s15, s15
    8ce4:	ed4b7a09 	vstr	s15, [fp, #-36]	; 0xffffffdc
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:131
    }

    exponent = normalize(&value);
    8ce8:	e24b3024 	sub	r3, fp, #36	; 0x24
    8cec:	e1a00003 	mov	r0, r3
    8cf0:	ebfffefa 	bl	88e0 <_Z9normalizePf>
    8cf4:	e50b0008 	str	r0, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:133

    while (exponent > 0) {
    8cf8:	e51b3008 	ldr	r3, [fp, #-8]
    8cfc:	e3530000 	cmp	r3, #0
    8d00:	da00001c 	ble	8d78 <_Z4ftoaPcf+0x11c>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:134
        int digit = value * 10;
    8d04:	ed5b7a09 	vldr	s15, [fp, #-36]	; 0xffffffdc
    8d08:	ed9f7a60 	vldr	s14, [pc, #384]	; 8e90 <_Z4ftoaPcf+0x234>
    8d0c:	ee677a87 	vmul.f32	s15, s15, s14
    8d10:	eefd7ae7 	vcvt.s32.f32	s15, s15
    8d14:	ee173a90 	vmov	r3, s15
    8d18:	e50b3014 	str	r3, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:135
        *buffer++ = digit + '0';
    8d1c:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8d20:	e6ef2073 	uxtb	r2, r3
    8d24:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8d28:	e2831001 	add	r1, r3, #1
    8d2c:	e50b1020 	str	r1, [fp, #-32]	; 0xffffffe0
    8d30:	e2822030 	add	r2, r2, #48	; 0x30
    8d34:	e6ef2072 	uxtb	r2, r2
    8d38:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:136
        value = value * 10 - digit;
    8d3c:	ed5b7a09 	vldr	s15, [fp, #-36]	; 0xffffffdc
    8d40:	ed9f7a52 	vldr	s14, [pc, #328]	; 8e90 <_Z4ftoaPcf+0x234>
    8d44:	ee277a87 	vmul.f32	s14, s15, s14
    8d48:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    8d4c:	ee073a90 	vmov	s15, r3
    8d50:	eef87ae7 	vcvt.f32.s32	s15, s15
    8d54:	ee777a67 	vsub.f32	s15, s14, s15
    8d58:	ed4b7a09 	vstr	s15, [fp, #-36]	; 0xffffffdc
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:137
        ++places;
    8d5c:	e51b300c 	ldr	r3, [fp, #-12]
    8d60:	e2833001 	add	r3, r3, #1
    8d64:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:138
        --exponent;
    8d68:	e51b3008 	ldr	r3, [fp, #-8]
    8d6c:	e2433001 	sub	r3, r3, #1
    8d70:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:133
    while (exponent > 0) {
    8d74:	eaffffdf 	b	8cf8 <_Z4ftoaPcf+0x9c>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:141
    }

    if (places == 0)
    8d78:	e51b300c 	ldr	r3, [fp, #-12]
    8d7c:	e3530000 	cmp	r3, #0
    8d80:	1a000004 	bne	8d98 <_Z4ftoaPcf+0x13c>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:142
        *buffer++ = '0';
    8d84:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8d88:	e2832001 	add	r2, r3, #1
    8d8c:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8d90:	e3a02030 	mov	r2, #48	; 0x30
    8d94:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:144

    *buffer++ = '.';
    8d98:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8d9c:	e2832001 	add	r2, r3, #1
    8da0:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8da4:	e3a0202e 	mov	r2, #46	; 0x2e
    8da8:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:146

    while (exponent < 0 && places < width) {
    8dac:	e51b3008 	ldr	r3, [fp, #-8]
    8db0:	e3530000 	cmp	r3, #0
    8db4:	aa00000e 	bge	8df4 <_Z4ftoaPcf+0x198>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:146 (discriminator 1)
    8db8:	e51b300c 	ldr	r3, [fp, #-12]
    8dbc:	e3530005 	cmp	r3, #5
    8dc0:	ca00000b 	bgt	8df4 <_Z4ftoaPcf+0x198>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:147
        *buffer++ = '0';
    8dc4:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8dc8:	e2832001 	add	r2, r3, #1
    8dcc:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
    8dd0:	e3a02030 	mov	r2, #48	; 0x30
    8dd4:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:148
        --exponent;
    8dd8:	e51b3008 	ldr	r3, [fp, #-8]
    8ddc:	e2433001 	sub	r3, r3, #1
    8de0:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:149
        ++places;
    8de4:	e51b300c 	ldr	r3, [fp, #-12]
    8de8:	e2833001 	add	r3, r3, #1
    8dec:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:146
    while (exponent < 0 && places < width) {
    8df0:	eaffffed 	b	8dac <_Z4ftoaPcf+0x150>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:152
    }

    while (places < width) {
    8df4:	e51b300c 	ldr	r3, [fp, #-12]
    8df8:	e3530005 	cmp	r3, #5
    8dfc:	ca00001c 	bgt	8e74 <_Z4ftoaPcf+0x218>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:153
        int digit = value * 10.0;
    8e00:	ed5b7a09 	vldr	s15, [fp, #-36]	; 0xffffffdc
    8e04:	eeb77ae7 	vcvt.f64.f32	d7, s15
    8e08:	ed9f6b1e 	vldr	d6, [pc, #120]	; 8e88 <_Z4ftoaPcf+0x22c>
    8e0c:	ee277b06 	vmul.f64	d7, d7, d6
    8e10:	eefd7bc7 	vcvt.s32.f64	s15, d7
    8e14:	ee173a90 	vmov	r3, s15
    8e18:	e50b3018 	str	r3, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:154
        *buffer++ = digit + '0';
    8e1c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8e20:	e6ef2073 	uxtb	r2, r3
    8e24:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8e28:	e2831001 	add	r1, r3, #1
    8e2c:	e50b1020 	str	r1, [fp, #-32]	; 0xffffffe0
    8e30:	e2822030 	add	r2, r2, #48	; 0x30
    8e34:	e6ef2072 	uxtb	r2, r2
    8e38:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:155
        value = value * 10.0 - digit;
    8e3c:	ed5b7a09 	vldr	s15, [fp, #-36]	; 0xffffffdc
    8e40:	eeb77ae7 	vcvt.f64.f32	d7, s15
    8e44:	ed9f6b0f 	vldr	d6, [pc, #60]	; 8e88 <_Z4ftoaPcf+0x22c>
    8e48:	ee276b06 	vmul.f64	d6, d7, d6
    8e4c:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8e50:	ee073a90 	vmov	s15, r3
    8e54:	eeb87be7 	vcvt.f64.s32	d7, s15
    8e58:	ee367b47 	vsub.f64	d7, d6, d7
    8e5c:	eef77bc7 	vcvt.f32.f64	s15, d7
    8e60:	ed4b7a09 	vstr	s15, [fp, #-36]	; 0xffffffdc
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:156
        ++places;
    8e64:	e51b300c 	ldr	r3, [fp, #-12]
    8e68:	e2833001 	add	r3, r3, #1
    8e6c:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:152
    while (places < width) {
    8e70:	eaffffdf 	b	8df4 <_Z4ftoaPcf+0x198>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:158
    }
    *buffer = '\0';
    8e74:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    8e78:	e3a02000 	mov	r2, #0
    8e7c:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:159
}
    8e80:	e24bd004 	sub	sp, fp, #4
    8e84:	e8bd8800 	pop	{fp, pc}
    8e88:	00000000 	andeq	r0, r0, r0
    8e8c:	40240000 	eormi	r0, r4, r0
    8e90:	41200000 			; <UNDEFINED> instruction: 0x41200000

00008e94 <_Z7strncpyPcPKci>:
_Z7strncpyPcPKci():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:162

char* strncpy(char* dest, const char *src, int num)
{
    8e94:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8e98:	e28db000 	add	fp, sp, #0
    8e9c:	e24dd01c 	sub	sp, sp, #28
    8ea0:	e50b0010 	str	r0, [fp, #-16]
    8ea4:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    8ea8:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:165
	int i;

	for (i = 0; i < num && src[i] != '\0'; i++)
    8eac:	e3a03000 	mov	r3, #0
    8eb0:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:165 (discriminator 4)
    8eb4:	e51b2008 	ldr	r2, [fp, #-8]
    8eb8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8ebc:	e1520003 	cmp	r2, r3
    8ec0:	aa000011 	bge	8f0c <_Z7strncpyPcPKci+0x78>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:165 (discriminator 2)
    8ec4:	e51b3008 	ldr	r3, [fp, #-8]
    8ec8:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8ecc:	e0823003 	add	r3, r2, r3
    8ed0:	e5d33000 	ldrb	r3, [r3]
    8ed4:	e3530000 	cmp	r3, #0
    8ed8:	0a00000b 	beq	8f0c <_Z7strncpyPcPKci+0x78>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:166 (discriminator 3)
		dest[i] = src[i];
    8edc:	e51b3008 	ldr	r3, [fp, #-8]
    8ee0:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8ee4:	e0822003 	add	r2, r2, r3
    8ee8:	e51b3008 	ldr	r3, [fp, #-8]
    8eec:	e51b1010 	ldr	r1, [fp, #-16]
    8ef0:	e0813003 	add	r3, r1, r3
    8ef4:	e5d22000 	ldrb	r2, [r2]
    8ef8:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:165 (discriminator 3)
	for (i = 0; i < num && src[i] != '\0'; i++)
    8efc:	e51b3008 	ldr	r3, [fp, #-8]
    8f00:	e2833001 	add	r3, r3, #1
    8f04:	e50b3008 	str	r3, [fp, #-8]
    8f08:	eaffffe9 	b	8eb4 <_Z7strncpyPcPKci+0x20>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:167 (discriminator 2)
	for (; i < num; i++)
    8f0c:	e51b2008 	ldr	r2, [fp, #-8]
    8f10:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    8f14:	e1520003 	cmp	r2, r3
    8f18:	aa000008 	bge	8f40 <_Z7strncpyPcPKci+0xac>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:168 (discriminator 1)
		dest[i] = '\0';
    8f1c:	e51b3008 	ldr	r3, [fp, #-8]
    8f20:	e51b2010 	ldr	r2, [fp, #-16]
    8f24:	e0823003 	add	r3, r2, r3
    8f28:	e3a02000 	mov	r2, #0
    8f2c:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:167 (discriminator 1)
	for (; i < num; i++)
    8f30:	e51b3008 	ldr	r3, [fp, #-8]
    8f34:	e2833001 	add	r3, r3, #1
    8f38:	e50b3008 	str	r3, [fp, #-8]
    8f3c:	eafffff2 	b	8f0c <_Z7strncpyPcPKci+0x78>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:170

   return dest;
    8f40:	e51b3010 	ldr	r3, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:171
}
    8f44:	e1a00003 	mov	r0, r3
    8f48:	e28bd000 	add	sp, fp, #0
    8f4c:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    8f50:	e12fff1e 	bx	lr

00008f54 <_Z6strcatPcPKc>:
_Z6strcatPcPKc():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:174

char* strcat(char *dest, const char *src)
{
    8f54:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    8f58:	e28db000 	add	fp, sp, #0
    8f5c:	e24dd014 	sub	sp, sp, #20
    8f60:	e50b0010 	str	r0, [fp, #-16]
    8f64:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:177
    int i,j;

    for (i = 0; dest[i] != '\0'; i++)
    8f68:	e3a03000 	mov	r3, #0
    8f6c:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:177 (discriminator 3)
    8f70:	e51b3008 	ldr	r3, [fp, #-8]
    8f74:	e51b2010 	ldr	r2, [fp, #-16]
    8f78:	e0823003 	add	r3, r2, r3
    8f7c:	e5d33000 	ldrb	r3, [r3]
    8f80:	e3530000 	cmp	r3, #0
    8f84:	0a000003 	beq	8f98 <_Z6strcatPcPKc+0x44>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:177 (discriminator 2)
    8f88:	e51b3008 	ldr	r3, [fp, #-8]
    8f8c:	e2833001 	add	r3, r3, #1
    8f90:	e50b3008 	str	r3, [fp, #-8]
    8f94:	eafffff5 	b	8f70 <_Z6strcatPcPKc+0x1c>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:179
        ;
    for (j = 0; src[j] != '\0'; j++)
    8f98:	e3a03000 	mov	r3, #0
    8f9c:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:179 (discriminator 3)
    8fa0:	e51b300c 	ldr	r3, [fp, #-12]
    8fa4:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8fa8:	e0823003 	add	r3, r2, r3
    8fac:	e5d33000 	ldrb	r3, [r3]
    8fb0:	e3530000 	cmp	r3, #0
    8fb4:	0a00000e 	beq	8ff4 <_Z6strcatPcPKc+0xa0>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:180 (discriminator 2)
        dest[i+j] = src[j];
    8fb8:	e51b300c 	ldr	r3, [fp, #-12]
    8fbc:	e51b2014 	ldr	r2, [fp, #-20]	; 0xffffffec
    8fc0:	e0822003 	add	r2, r2, r3
    8fc4:	e51b1008 	ldr	r1, [fp, #-8]
    8fc8:	e51b300c 	ldr	r3, [fp, #-12]
    8fcc:	e0813003 	add	r3, r1, r3
    8fd0:	e1a01003 	mov	r1, r3
    8fd4:	e51b3010 	ldr	r3, [fp, #-16]
    8fd8:	e0833001 	add	r3, r3, r1
    8fdc:	e5d22000 	ldrb	r2, [r2]
    8fe0:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:179 (discriminator 2)
    for (j = 0; src[j] != '\0'; j++)
    8fe4:	e51b300c 	ldr	r3, [fp, #-12]
    8fe8:	e2833001 	add	r3, r3, #1
    8fec:	e50b300c 	str	r3, [fp, #-12]
    8ff0:	eaffffea 	b	8fa0 <_Z6strcatPcPKc+0x4c>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:182

    dest[i+j] = '\0';
    8ff4:	e51b2008 	ldr	r2, [fp, #-8]
    8ff8:	e51b300c 	ldr	r3, [fp, #-12]
    8ffc:	e0823003 	add	r3, r2, r3
    9000:	e1a02003 	mov	r2, r3
    9004:	e51b3010 	ldr	r3, [fp, #-16]
    9008:	e0833002 	add	r3, r3, r2
    900c:	e3a02000 	mov	r2, #0
    9010:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:184
	
    return dest;
    9014:	e51b3010 	ldr	r3, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:185
}
    9018:	e1a00003 	mov	r0, r3
    901c:	e28bd000 	add	sp, fp, #0
    9020:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9024:	e12fff1e 	bx	lr

00009028 <_Z7strncmpPKcS0_i>:
_Z7strncmpPKcS0_i():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:188

int strncmp(const char *s1, const char *s2, int num)
{
    9028:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    902c:	e28db000 	add	fp, sp, #0
    9030:	e24dd01c 	sub	sp, sp, #28
    9034:	e50b0010 	str	r0, [fp, #-16]
    9038:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
    903c:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:190
	unsigned char u1, u2;
  	while (num-- > 0)
    9040:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    9044:	e2432001 	sub	r2, r3, #1
    9048:	e50b2018 	str	r2, [fp, #-24]	; 0xffffffe8
    904c:	e3530000 	cmp	r3, #0
    9050:	c3a03001 	movgt	r3, #1
    9054:	d3a03000 	movle	r3, #0
    9058:	e6ef3073 	uxtb	r3, r3
    905c:	e3530000 	cmp	r3, #0
    9060:	0a000016 	beq	90c0 <_Z7strncmpPKcS0_i+0x98>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:192
    {
      	u1 = (unsigned char) *s1++;
    9064:	e51b3010 	ldr	r3, [fp, #-16]
    9068:	e2832001 	add	r2, r3, #1
    906c:	e50b2010 	str	r2, [fp, #-16]
    9070:	e5d33000 	ldrb	r3, [r3]
    9074:	e54b3005 	strb	r3, [fp, #-5]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:193
     	u2 = (unsigned char) *s2++;
    9078:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    907c:	e2832001 	add	r2, r3, #1
    9080:	e50b2014 	str	r2, [fp, #-20]	; 0xffffffec
    9084:	e5d33000 	ldrb	r3, [r3]
    9088:	e54b3006 	strb	r3, [fp, #-6]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:194
      	if (u1 != u2)
    908c:	e55b2005 	ldrb	r2, [fp, #-5]
    9090:	e55b3006 	ldrb	r3, [fp, #-6]
    9094:	e1520003 	cmp	r2, r3
    9098:	0a000003 	beq	90ac <_Z7strncmpPKcS0_i+0x84>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:195
        	return u1 - u2;
    909c:	e55b2005 	ldrb	r2, [fp, #-5]
    90a0:	e55b3006 	ldrb	r3, [fp, #-6]
    90a4:	e0423003 	sub	r3, r2, r3
    90a8:	ea000005 	b	90c4 <_Z7strncmpPKcS0_i+0x9c>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:196
      	if (u1 == '\0')
    90ac:	e55b3005 	ldrb	r3, [fp, #-5]
    90b0:	e3530000 	cmp	r3, #0
    90b4:	1affffe1 	bne	9040 <_Z7strncmpPKcS0_i+0x18>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:197
        	return 0;
    90b8:	e3a03000 	mov	r3, #0
    90bc:	ea000000 	b	90c4 <_Z7strncmpPKcS0_i+0x9c>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:200
    }

  	return 0;
    90c0:	e3a03000 	mov	r3, #0
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:201
}
    90c4:	e1a00003 	mov	r0, r3
    90c8:	e28bd000 	add	sp, fp, #0
    90cc:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    90d0:	e12fff1e 	bx	lr

000090d4 <_Z6strlenPKc>:
_Z6strlenPKc():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:204

int strlen(const char* s)
{
    90d4:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    90d8:	e28db000 	add	fp, sp, #0
    90dc:	e24dd014 	sub	sp, sp, #20
    90e0:	e50b0010 	str	r0, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:205
	int i = 0;
    90e4:	e3a03000 	mov	r3, #0
    90e8:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:207

	while (s[i] != '\0')
    90ec:	e51b3008 	ldr	r3, [fp, #-8]
    90f0:	e51b2010 	ldr	r2, [fp, #-16]
    90f4:	e0823003 	add	r3, r2, r3
    90f8:	e5d33000 	ldrb	r3, [r3]
    90fc:	e3530000 	cmp	r3, #0
    9100:	0a000003 	beq	9114 <_Z6strlenPKc+0x40>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:208
		i++;
    9104:	e51b3008 	ldr	r3, [fp, #-8]
    9108:	e2833001 	add	r3, r3, #1
    910c:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:207
	while (s[i] != '\0')
    9110:	eafffff5 	b	90ec <_Z6strlenPKc+0x18>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:210

	return i;
    9114:	e51b3008 	ldr	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:211
}
    9118:	e1a00003 	mov	r0, r3
    911c:	e28bd000 	add	sp, fp, #0
    9120:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    9124:	e12fff1e 	bx	lr

00009128 <_Z5bzeroPvi>:
_Z5bzeroPvi():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:214

void bzero(void* memory, int length)
{
    9128:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    912c:	e28db000 	add	fp, sp, #0
    9130:	e24dd014 	sub	sp, sp, #20
    9134:	e50b0010 	str	r0, [fp, #-16]
    9138:	e50b1014 	str	r1, [fp, #-20]	; 0xffffffec
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:215
	char* mem = reinterpret_cast<char*>(memory);
    913c:	e51b3010 	ldr	r3, [fp, #-16]
    9140:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:217

	for (int i = 0; i < length; i++)
    9144:	e3a03000 	mov	r3, #0
    9148:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:217 (discriminator 3)
    914c:	e51b2008 	ldr	r2, [fp, #-8]
    9150:	e51b3014 	ldr	r3, [fp, #-20]	; 0xffffffec
    9154:	e1520003 	cmp	r2, r3
    9158:	aa000008 	bge	9180 <_Z5bzeroPvi+0x58>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:218 (discriminator 2)
		mem[i] = 0;
    915c:	e51b3008 	ldr	r3, [fp, #-8]
    9160:	e51b200c 	ldr	r2, [fp, #-12]
    9164:	e0823003 	add	r3, r2, r3
    9168:	e3a02000 	mov	r2, #0
    916c:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:217 (discriminator 2)
	for (int i = 0; i < length; i++)
    9170:	e51b3008 	ldr	r3, [fp, #-8]
    9174:	e2833001 	add	r3, r3, #1
    9178:	e50b3008 	str	r3, [fp, #-8]
    917c:	eafffff2 	b	914c <_Z5bzeroPvi+0x24>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:219
}
    9180:	e320f000 	nop	{0}
    9184:	e28bd000 	add	sp, fp, #0
    9188:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    918c:	e12fff1e 	bx	lr

00009190 <_Z6memcpyPKvPvi>:
_Z6memcpyPKvPvi():
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:222

void memcpy(const void* src, void* dst, int num)
{
    9190:	e52db004 	push	{fp}		; (str fp, [sp, #-4]!)
    9194:	e28db000 	add	fp, sp, #0
    9198:	e24dd024 	sub	sp, sp, #36	; 0x24
    919c:	e50b0018 	str	r0, [fp, #-24]	; 0xffffffe8
    91a0:	e50b101c 	str	r1, [fp, #-28]	; 0xffffffe4
    91a4:	e50b2020 	str	r2, [fp, #-32]	; 0xffffffe0
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:223
	const char* memsrc = reinterpret_cast<const char*>(src);
    91a8:	e51b3018 	ldr	r3, [fp, #-24]	; 0xffffffe8
    91ac:	e50b300c 	str	r3, [fp, #-12]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:224
	char* memdst = reinterpret_cast<char*>(dst);
    91b0:	e51b301c 	ldr	r3, [fp, #-28]	; 0xffffffe4
    91b4:	e50b3010 	str	r3, [fp, #-16]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:226

	for (int i = 0; i < num; i++)
    91b8:	e3a03000 	mov	r3, #0
    91bc:	e50b3008 	str	r3, [fp, #-8]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:226 (discriminator 3)
    91c0:	e51b2008 	ldr	r2, [fp, #-8]
    91c4:	e51b3020 	ldr	r3, [fp, #-32]	; 0xffffffe0
    91c8:	e1520003 	cmp	r2, r3
    91cc:	aa00000b 	bge	9200 <_Z6memcpyPKvPvi+0x70>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:227 (discriminator 2)
		memdst[i] = memsrc[i];
    91d0:	e51b3008 	ldr	r3, [fp, #-8]
    91d4:	e51b200c 	ldr	r2, [fp, #-12]
    91d8:	e0822003 	add	r2, r2, r3
    91dc:	e51b3008 	ldr	r3, [fp, #-8]
    91e0:	e51b1010 	ldr	r1, [fp, #-16]
    91e4:	e0813003 	add	r3, r1, r3
    91e8:	e5d22000 	ldrb	r2, [r2]
    91ec:	e5c32000 	strb	r2, [r3]
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:226 (discriminator 2)
	for (int i = 0; i < num; i++)
    91f0:	e51b3008 	ldr	r3, [fp, #-8]
    91f4:	e2833001 	add	r3, r3, #1
    91f8:	e50b3008 	str	r3, [fp, #-8]
    91fc:	eaffffef 	b	91c0 <_Z6memcpyPKvPvi+0x30>
/home/schenkj/os2022/sp/sources/stdlib/src/stdstring.cpp:228
}
    9200:	e320f000 	nop	{0}
    9204:	e28bd000 	add	sp, fp, #0
    9208:	e49db004 	pop	{fp}		; (ldr fp, [sp], #4)
    920c:	e12fff1e 	bx	lr

00009210 <__udivsi3>:
__udivsi3():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1099
    9210:	e2512001 	subs	r2, r1, #1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1101
    9214:	012fff1e 	bxeq	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1102
    9218:	3a000074 	bcc	93f0 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1103
    921c:	e1500001 	cmp	r0, r1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1104
    9220:	9a00006b 	bls	93d4 <__udivsi3+0x1c4>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1105
    9224:	e1110002 	tst	r1, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1106
    9228:	0a00006c 	beq	93e0 <__udivsi3+0x1d0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1108
    922c:	e16f3f10 	clz	r3, r0
    9230:	e16f2f11 	clz	r2, r1
    9234:	e0423003 	sub	r3, r2, r3
    9238:	e273301f 	rsbs	r3, r3, #31
    923c:	10833083 	addne	r3, r3, r3, lsl #1
    9240:	e3a02000 	mov	r2, #0
    9244:	108ff103 	addne	pc, pc, r3, lsl #2
    9248:	e1a00000 	nop			; (mov r0, r0)
    924c:	e1500f81 	cmp	r0, r1, lsl #31
    9250:	e0a22002 	adc	r2, r2, r2
    9254:	20400f81 	subcs	r0, r0, r1, lsl #31
    9258:	e1500f01 	cmp	r0, r1, lsl #30
    925c:	e0a22002 	adc	r2, r2, r2
    9260:	20400f01 	subcs	r0, r0, r1, lsl #30
    9264:	e1500e81 	cmp	r0, r1, lsl #29
    9268:	e0a22002 	adc	r2, r2, r2
    926c:	20400e81 	subcs	r0, r0, r1, lsl #29
    9270:	e1500e01 	cmp	r0, r1, lsl #28
    9274:	e0a22002 	adc	r2, r2, r2
    9278:	20400e01 	subcs	r0, r0, r1, lsl #28
    927c:	e1500d81 	cmp	r0, r1, lsl #27
    9280:	e0a22002 	adc	r2, r2, r2
    9284:	20400d81 	subcs	r0, r0, r1, lsl #27
    9288:	e1500d01 	cmp	r0, r1, lsl #26
    928c:	e0a22002 	adc	r2, r2, r2
    9290:	20400d01 	subcs	r0, r0, r1, lsl #26
    9294:	e1500c81 	cmp	r0, r1, lsl #25
    9298:	e0a22002 	adc	r2, r2, r2
    929c:	20400c81 	subcs	r0, r0, r1, lsl #25
    92a0:	e1500c01 	cmp	r0, r1, lsl #24
    92a4:	e0a22002 	adc	r2, r2, r2
    92a8:	20400c01 	subcs	r0, r0, r1, lsl #24
    92ac:	e1500b81 	cmp	r0, r1, lsl #23
    92b0:	e0a22002 	adc	r2, r2, r2
    92b4:	20400b81 	subcs	r0, r0, r1, lsl #23
    92b8:	e1500b01 	cmp	r0, r1, lsl #22
    92bc:	e0a22002 	adc	r2, r2, r2
    92c0:	20400b01 	subcs	r0, r0, r1, lsl #22
    92c4:	e1500a81 	cmp	r0, r1, lsl #21
    92c8:	e0a22002 	adc	r2, r2, r2
    92cc:	20400a81 	subcs	r0, r0, r1, lsl #21
    92d0:	e1500a01 	cmp	r0, r1, lsl #20
    92d4:	e0a22002 	adc	r2, r2, r2
    92d8:	20400a01 	subcs	r0, r0, r1, lsl #20
    92dc:	e1500981 	cmp	r0, r1, lsl #19
    92e0:	e0a22002 	adc	r2, r2, r2
    92e4:	20400981 	subcs	r0, r0, r1, lsl #19
    92e8:	e1500901 	cmp	r0, r1, lsl #18
    92ec:	e0a22002 	adc	r2, r2, r2
    92f0:	20400901 	subcs	r0, r0, r1, lsl #18
    92f4:	e1500881 	cmp	r0, r1, lsl #17
    92f8:	e0a22002 	adc	r2, r2, r2
    92fc:	20400881 	subcs	r0, r0, r1, lsl #17
    9300:	e1500801 	cmp	r0, r1, lsl #16
    9304:	e0a22002 	adc	r2, r2, r2
    9308:	20400801 	subcs	r0, r0, r1, lsl #16
    930c:	e1500781 	cmp	r0, r1, lsl #15
    9310:	e0a22002 	adc	r2, r2, r2
    9314:	20400781 	subcs	r0, r0, r1, lsl #15
    9318:	e1500701 	cmp	r0, r1, lsl #14
    931c:	e0a22002 	adc	r2, r2, r2
    9320:	20400701 	subcs	r0, r0, r1, lsl #14
    9324:	e1500681 	cmp	r0, r1, lsl #13
    9328:	e0a22002 	adc	r2, r2, r2
    932c:	20400681 	subcs	r0, r0, r1, lsl #13
    9330:	e1500601 	cmp	r0, r1, lsl #12
    9334:	e0a22002 	adc	r2, r2, r2
    9338:	20400601 	subcs	r0, r0, r1, lsl #12
    933c:	e1500581 	cmp	r0, r1, lsl #11
    9340:	e0a22002 	adc	r2, r2, r2
    9344:	20400581 	subcs	r0, r0, r1, lsl #11
    9348:	e1500501 	cmp	r0, r1, lsl #10
    934c:	e0a22002 	adc	r2, r2, r2
    9350:	20400501 	subcs	r0, r0, r1, lsl #10
    9354:	e1500481 	cmp	r0, r1, lsl #9
    9358:	e0a22002 	adc	r2, r2, r2
    935c:	20400481 	subcs	r0, r0, r1, lsl #9
    9360:	e1500401 	cmp	r0, r1, lsl #8
    9364:	e0a22002 	adc	r2, r2, r2
    9368:	20400401 	subcs	r0, r0, r1, lsl #8
    936c:	e1500381 	cmp	r0, r1, lsl #7
    9370:	e0a22002 	adc	r2, r2, r2
    9374:	20400381 	subcs	r0, r0, r1, lsl #7
    9378:	e1500301 	cmp	r0, r1, lsl #6
    937c:	e0a22002 	adc	r2, r2, r2
    9380:	20400301 	subcs	r0, r0, r1, lsl #6
    9384:	e1500281 	cmp	r0, r1, lsl #5
    9388:	e0a22002 	adc	r2, r2, r2
    938c:	20400281 	subcs	r0, r0, r1, lsl #5
    9390:	e1500201 	cmp	r0, r1, lsl #4
    9394:	e0a22002 	adc	r2, r2, r2
    9398:	20400201 	subcs	r0, r0, r1, lsl #4
    939c:	e1500181 	cmp	r0, r1, lsl #3
    93a0:	e0a22002 	adc	r2, r2, r2
    93a4:	20400181 	subcs	r0, r0, r1, lsl #3
    93a8:	e1500101 	cmp	r0, r1, lsl #2
    93ac:	e0a22002 	adc	r2, r2, r2
    93b0:	20400101 	subcs	r0, r0, r1, lsl #2
    93b4:	e1500081 	cmp	r0, r1, lsl #1
    93b8:	e0a22002 	adc	r2, r2, r2
    93bc:	20400081 	subcs	r0, r0, r1, lsl #1
    93c0:	e1500001 	cmp	r0, r1
    93c4:	e0a22002 	adc	r2, r2, r2
    93c8:	20400001 	subcs	r0, r0, r1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1110
    93cc:	e1a00002 	mov	r0, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1111
    93d0:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1114
    93d4:	03a00001 	moveq	r0, #1
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1115
    93d8:	13a00000 	movne	r0, #0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1116
    93dc:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1118
    93e0:	e16f2f11 	clz	r2, r1
    93e4:	e262201f 	rsb	r2, r2, #31
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1120
    93e8:	e1a00230 	lsr	r0, r0, r2
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1121
    93ec:	e12fff1e 	bx	lr
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1125
    93f0:	e3500000 	cmp	r0, #0
    93f4:	13e00000 	mvnne	r0, #0
    93f8:	ea000007 	b	941c <__aeabi_idiv0>

000093fc <__aeabi_uidivmod>:
__aeabi_uidivmod():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1156
    93fc:	e3510000 	cmp	r1, #0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1157
    9400:	0afffffa 	beq	93f0 <__udivsi3+0x1e0>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1158
    9404:	e92d4003 	push	{r0, r1, lr}
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1159
    9408:	ebffff80 	bl	9210 <__udivsi3>
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1160
    940c:	e8bd4006 	pop	{r1, r2, lr}
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1161
    9410:	e0030092 	mul	r3, r2, r0
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1162
    9414:	e0411003 	sub	r1, r1, r3
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1163
    9418:	e12fff1e 	bx	lr

0000941c <__aeabi_idiv0>:
__aeabi_ldiv0():
/build/gcc-arm-none-eabi-Gl9kT9/gcc-arm-none-eabi-9-2019-q4/build/arm-none-eabi/arm/v5te/hard/libgcc/../../../../../../libgcc/config/arm/lib1funcs.S:1461
    941c:	e12fff1e 	bx	lr

Disassembly of section .rodata:

00009420 <_ZL13Lock_Unlocked>:
    9420:	00000000 	andeq	r0, r0, r0

00009424 <_ZL11Lock_Locked>:
    9424:	00000001 	andeq	r0, r0, r1

00009428 <_ZL21MaxFSDriverNameLength>:
    9428:	00000010 	andeq	r0, r0, r0, lsl r0

0000942c <_ZL17MaxFilenameLength>:
    942c:	00000010 	andeq	r0, r0, r0, lsl r0

00009430 <_ZL13MaxPathLength>:
    9430:	00000080 	andeq	r0, r0, r0, lsl #1

00009434 <_ZL18NoFilesystemDriver>:
    9434:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009438 <_ZL9NotifyAll>:
    9438:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000943c <_ZL24Max_Process_Opened_Files>:
    943c:	00000010 	andeq	r0, r0, r0, lsl r0

00009440 <_ZL10Indefinite>:
    9440:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009444 <_ZL18Deadline_Unchanged>:
    9444:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009448 <_ZL14Invalid_Handle>:
    9448:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

0000944c <_ZL13Lock_Unlocked>:
    944c:	00000000 	andeq	r0, r0, r0

00009450 <_ZL11Lock_Locked>:
    9450:	00000001 	andeq	r0, r0, r1

00009454 <_ZL21MaxFSDriverNameLength>:
    9454:	00000010 	andeq	r0, r0, r0, lsl r0

00009458 <_ZL17MaxFilenameLength>:
    9458:	00000010 	andeq	r0, r0, r0, lsl r0

0000945c <_ZL13MaxPathLength>:
    945c:	00000080 	andeq	r0, r0, r0, lsl #1

00009460 <_ZL18NoFilesystemDriver>:
    9460:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009464 <_ZL9NotifyAll>:
    9464:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009468 <_ZL24Max_Process_Opened_Files>:
    9468:	00000010 	andeq	r0, r0, r0, lsl r0

0000946c <_ZL10Indefinite>:
    946c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009470 <_ZL18Deadline_Unchanged>:
    9470:	fffffffe 			; <UNDEFINED> instruction: 0xfffffffe

00009474 <_ZL14Invalid_Handle>:
    9474:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff

00009478 <_ZL16Pipe_File_Prefix>:
    9478:	3a535953 	bcc	14df9cc <__bss_end+0x14d6524>
    947c:	65706970 	ldrbvs	r6, [r0, #-2416]!	; 0xfffff690
    9480:	0000002f 	andeq	r0, r0, pc, lsr #32

00009484 <_ZN12_GLOBAL__N_1L11CharConvArrE>:
    9484:	33323130 	teqcc	r2, #48, 2
    9488:	37363534 			; <UNDEFINED> instruction: 0x37363534
    948c:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    9490:	46454443 	strbmi	r4, [r5], -r3, asr #8
	...

Disassembly of section .bss:

00009498 <__bss_start>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002e41 	andeq	r2, r0, r1, asr #28
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	00000024 	andeq	r0, r0, r4, lsr #32
  10:	4b5a3605 	blmi	168d82c <__bss_end+0x1684384>
  14:	08070600 	stmdaeq	r7, {r9, sl}
  18:	0a010901 	beq	42424 <__bss_end+0x38f7c>
  1c:	14041202 	strne	r1, [r4], #-514	; 0xfffffdfe
  20:	17011501 	strne	r1, [r1, -r1, lsl #10]
  24:	1a011803 	bne	46038 <__bss_end+0x3cb90>
  28:	22011c01 	andcs	r1, r1, #256	; 0x100
  2c:	Address 0x000000000000002c is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__bss_end+0x10c787c>
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
  24:	6a6b6e65 	bvs	1adb9c0 <__bss_end+0x1ad2518>
  28:	32736f2f 	rsbscc	r6, r3, #47, 30	; 0xbc
  2c:	2f323230 	svccs	0x00323230
  30:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
  34:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
  38:	752f7365 	strvc	r7, [pc, #-869]!	; fffffcdb <__bss_end+0xffff6833>
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
  7c:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffffc8 <__bss_end+0xffff6b20>
  80:	63732f65 	cmnvs	r3, #404	; 0x194
  84:	6b6e6568 	blvs	1b9962c <__bss_end+0x1b90184>
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
  c0:	4a050567 	bmi	141664 <__bss_end+0x1381bc>
  c4:	02000e05 	andeq	r0, r0, #5, 28	; 0x50
  c8:	052f0304 	streq	r0, [pc, #-772]!	; fffffdcc <__bss_end+0xffff6924>
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
 114:	6b6e6568 	blvs	1b996bc <__bss_end+0x1b90214>
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
 1ac:	6a0d05a1 	bvs	341838 <__bss_end+0x338390>
 1b0:	02002405 	andeq	r2, r0, #83886080	; 0x5000000
 1b4:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 1b8:	04020004 	streq	r0, [r2], #-4
 1bc:	0b058302 	bleq	160dcc <__bss_end+0x157924>
 1c0:	02040200 	andeq	r0, r4, #0, 4
 1c4:	0002054a 	andeq	r0, r2, sl, asr #10
 1c8:	2d020402 	cfstrscs	mvf0, [r2, #-8]
 1cc:	05850905 	streq	r0, [r5, #2309]	; 0x905
 1d0:	0a022f01 	beq	8bddc <__bss_end+0x82934>
 1d4:	a0010100 	andge	r0, r1, r0, lsl #2
 1d8:	03000001 	movweq	r0, #1
 1dc:	00017600 	andeq	r7, r1, r0, lsl #12
 1e0:	fb010200 	blx	409ea <__bss_end+0x37542>
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
 21c:	74696e69 	strbtvc	r6, [r9], #-3689	; 0xfffff197
 220:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
 224:	682f006b 	stmdavs	pc!, {r0, r1, r3, r5, r6}	; <UNPREDICTABLE>
 228:	2f656d6f 	svccs	0x00656d6f
 22c:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
 230:	2f6a6b6e 	svccs	0x006a6b6e
 234:	3032736f 	eorscc	r7, r2, pc, ror #6
 238:	732f3232 			; <UNDEFINED> instruction: 0x732f3232
 23c:	6f732f70 	svcvs	0x00732f70
 240:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 244:	73752f73 	cmnvc	r5, #460	; 0x1cc
 248:	70737265 	rsbsvc	r7, r3, r5, ror #4
 24c:	2f656361 	svccs	0x00656361
 250:	6b2f2e2e 	blvs	bcbb10 <__bss_end+0xbc2668>
 254:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 258:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 25c:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 260:	72702f65 	rsbsvc	r2, r0, #404	; 0x194
 264:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
 268:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
 26c:	2f656d6f 	svccs	0x00656d6f
 270:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
 274:	2f6a6b6e 	svccs	0x006a6b6e
 278:	3032736f 	eorscc	r7, r2, pc, ror #6
 27c:	732f3232 			; <UNDEFINED> instruction: 0x732f3232
 280:	6f732f70 	svcvs	0x00732f70
 284:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 288:	73752f73 	cmnvc	r5, #460	; 0x1cc
 28c:	70737265 	rsbsvc	r7, r3, r5, ror #4
 290:	2f656361 	svccs	0x00656361
 294:	6b2f2e2e 	blvs	bcbb54 <__bss_end+0xbc26ac>
 298:	656e7265 	strbvs	r7, [lr, #-613]!	; 0xfffffd9b
 29c:	6e692f6c 	cdpvs	15, 6, cr2, cr9, cr12, {3}
 2a0:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 2a4:	73662f65 	cmnvc	r6, #404	; 0x194
 2a8:	6f682f00 	svcvs	0x00682f00
 2ac:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
 2b0:	6e656863 	cdpvs	8, 6, cr6, cr5, cr3, {3}
 2b4:	6f2f6a6b 	svcvs	0x002f6a6b
 2b8:	32303273 	eorscc	r3, r0, #805306375	; 0x30000007
 2bc:	70732f32 	rsbsvc	r2, r3, r2, lsr pc
 2c0:	756f732f 	strbvc	r7, [pc, #-815]!	; ffffff99 <__bss_end+0xffff6af1>
 2c4:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 2c8:	6573752f 	ldrbvs	r7, [r3, #-1327]!	; 0xfffffad1
 2cc:	61707372 	cmnvs	r0, r2, ror r3
 2d0:	2e2f6563 	cfsh64cs	mvdx6, mvdx15, #51
 2d4:	656b2f2e 	strbvs	r2, [fp, #-3886]!	; 0xfffff0d2
 2d8:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 2dc:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 2e0:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 2e4:	616f622f 	cmnvs	pc, pc, lsr #4
 2e8:	722f6472 	eorvc	r6, pc, #1912602624	; 0x72000000
 2ec:	2f306970 	svccs	0x00306970
 2f0:	006c6168 	rsbeq	r6, ip, r8, ror #2
 2f4:	69616d00 	stmdbvs	r1!, {r8, sl, fp, sp, lr}^
 2f8:	70632e6e 	rsbvc	r2, r3, lr, ror #28
 2fc:	00010070 	andeq	r0, r1, r0, ror r0
 300:	69777300 	ldmdbvs	r7!, {r8, r9, ip, sp, lr}^
 304:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 308:	70730000 	rsbsvc	r0, r3, r0
 30c:	6f6c6e69 	svcvs	0x006c6e69
 310:	682e6b63 	stmdavs	lr!, {r0, r1, r5, r6, r8, r9, fp, sp, lr}
 314:	00000200 	andeq	r0, r0, r0, lsl #4
 318:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
 31c:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
 320:	682e6d65 	stmdavs	lr!, {r0, r2, r5, r6, r8, sl, fp, sp, lr}
 324:	00000300 	andeq	r0, r0, r0, lsl #6
 328:	636f7270 	cmnvs	pc, #112, 4
 32c:	2e737365 	cdpcs	3, 7, cr7, cr3, cr5, {3}
 330:	00020068 	andeq	r0, r2, r8, rrx
 334:	6f727000 	svcvs	0x00727000
 338:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
 33c:	6e616d5f 	mcrvs	13, 3, r6, cr1, cr15, {2}
 340:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
 344:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 348:	6e690000 	cdpvs	0, 6, cr0, cr9, cr0, {0}
 34c:	66656474 			; <UNDEFINED> instruction: 0x66656474
 350:	0400682e 	streq	r6, [r0], #-2094	; 0xfffff7d2
 354:	05000000 	streq	r0, [r0, #-0]
 358:	02050001 	andeq	r0, r5, #1
 35c:	0000822c 	andeq	r8, r0, ip, lsr #4
 360:	a3130517 	tstge	r3, #96468992	; 0x5c00000
 364:	05511f05 	ldrbeq	r1, [r1, #-3845]	; 0xfffff0fb
 368:	03054a22 	movweq	r4, #23074	; 0x5a22
 36c:	4b170582 	blmi	5c197c <__bss_end+0x5b84d4>
 370:	05310e05 	ldreq	r0, [r1, #-3589]!	; 0xfffff1fb
 374:	02022a03 	andeq	r2, r2, #12288	; 0x3000
 378:	7c010100 	stfvcs	f0, [r1], {-0}
 37c:	03000002 	movweq	r0, #2
 380:	00014900 	andeq	r4, r1, r0, lsl #18
 384:	fb010200 	blx	40b8e <__bss_end+0x376e6>
 388:	01000d0e 	tsteq	r0, lr, lsl #26
 38c:	00010101 	andeq	r0, r1, r1, lsl #2
 390:	00010000 	andeq	r0, r1, r0
 394:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
 398:	2f656d6f 	svccs	0x00656d6f
 39c:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
 3a0:	2f6a6b6e 	svccs	0x006a6b6e
 3a4:	3032736f 	eorscc	r7, r2, pc, ror #6
 3a8:	732f3232 			; <UNDEFINED> instruction: 0x732f3232
 3ac:	6f732f70 	svcvs	0x00732f70
 3b0:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 3b4:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
 3b8:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
 3bc:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
 3c0:	6f682f00 	svcvs	0x00682f00
 3c4:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
 3c8:	6e656863 	cdpvs	8, 6, cr6, cr5, cr3, {3}
 3cc:	6f2f6a6b 	svcvs	0x002f6a6b
 3d0:	32303273 	eorscc	r3, r0, #805306375	; 0x30000007
 3d4:	70732f32 	rsbsvc	r2, r3, r2, lsr pc
 3d8:	756f732f 	strbvc	r7, [pc, #-815]!	; b1 <shift+0xb1>
 3dc:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
 3e0:	72656b2f 	rsbvc	r6, r5, #48128	; 0xbc00
 3e4:	2f6c656e 	svccs	0x006c656e
 3e8:	6c636e69 	stclvs	14, cr6, [r3], #-420	; 0xfffffe5c
 3ec:	2f656475 	svccs	0x00656475
 3f0:	636f7270 	cmnvs	pc, #112, 4
 3f4:	00737365 	rsbseq	r7, r3, r5, ror #6
 3f8:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 344 <shift+0x344>
 3fc:	63732f65 	cmnvs	r3, #404	; 0x194
 400:	6b6e6568 	blvs	1b999a8 <__bss_end+0x1b90500>
 404:	736f2f6a 	cmnvc	pc, #424	; 0x1a8
 408:	32323032 	eorscc	r3, r2, #50	; 0x32
 40c:	2f70732f 	svccs	0x0070732f
 410:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
 414:	2f736563 	svccs	0x00736563
 418:	6e72656b 	cdpvs	5, 7, cr6, cr2, cr11, {3}
 41c:	692f6c65 	stmdbvs	pc!, {r0, r2, r5, r6, sl, fp, sp, lr}	; <UNPREDICTABLE>
 420:	756c636e 	strbvc	r6, [ip, #-878]!	; 0xfffffc92
 424:	662f6564 	strtvs	r6, [pc], -r4, ror #10
 428:	682f0073 	stmdavs	pc!, {r0, r1, r4, r5, r6}	; <UNPREDICTABLE>
 42c:	2f656d6f 	svccs	0x00656d6f
 430:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
 434:	2f6a6b6e 	svccs	0x006a6b6e
 438:	3032736f 	eorscc	r7, r2, pc, ror #6
 43c:	732f3232 			; <UNDEFINED> instruction: 0x732f3232
 440:	6f732f70 	svcvs	0x00732f70
 444:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 448:	656b2f73 	strbvs	r2, [fp, #-3955]!	; 0xfffff08d
 44c:	6c656e72 	stclvs	14, cr6, [r5], #-456	; 0xfffffe38
 450:	636e692f 	cmnvs	lr, #770048	; 0xbc000
 454:	6564756c 	strbvs	r7, [r4, #-1388]!	; 0xfffffa94
 458:	616f622f 	cmnvs	pc, pc, lsr #4
 45c:	722f6472 	eorvc	r6, pc, #1912602624	; 0x72000000
 460:	2f306970 	svccs	0x00306970
 464:	006c6168 	rsbeq	r6, ip, r8, ror #2
 468:	64747300 	ldrbtvs	r7, [r4], #-768	; 0xfffffd00
 46c:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
 470:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
 474:	00000100 	andeq	r0, r0, r0, lsl #2
 478:	2e697773 	mcrcs	7, 3, r7, cr9, cr3, {3}
 47c:	00020068 	andeq	r0, r2, r8, rrx
 480:	69707300 	ldmdbvs	r0!, {r8, r9, ip, sp, lr}^
 484:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
 488:	00682e6b 	rsbeq	r2, r8, fp, ror #28
 48c:	66000002 	strvs	r0, [r0], -r2
 490:	73656c69 	cmnvc	r5, #26880	; 0x6900
 494:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
 498:	00682e6d 	rsbeq	r2, r8, sp, ror #28
 49c:	70000003 	andvc	r0, r0, r3
 4a0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
 4a4:	682e7373 	stmdavs	lr!, {r0, r1, r4, r5, r6, r8, r9, ip, sp, lr}
 4a8:	00000200 	andeq	r0, r0, r0, lsl #4
 4ac:	636f7270 	cmnvs	pc, #112, 4
 4b0:	5f737365 	svcpl	0x00737365
 4b4:	616e616d 	cmnvs	lr, sp, ror #2
 4b8:	2e726567 	cdpcs	5, 7, cr6, cr2, cr7, {3}
 4bc:	00020068 	andeq	r0, r2, r8, rrx
 4c0:	746e6900 	strbtvc	r6, [lr], #-2304	; 0xfffff700
 4c4:	2e666564 	cdpcs	5, 6, cr6, cr6, cr4, {3}
 4c8:	00040068 	andeq	r0, r4, r8, rrx
 4cc:	01050000 	mrseq	r0, (UNDEF: 5)
 4d0:	74020500 	strvc	r0, [r2], #-1280	; 0xfffffb00
 4d4:	16000082 	strne	r0, [r0], -r2, lsl #1
 4d8:	05691a05 	strbeq	r1, [r9, #-2565]!	; 0xfffff5fb
 4dc:	0c052f2c 	stceq	15, cr2, [r5], {44}	; 0x2c
 4e0:	2f01054c 	svccs	0x0001054c
 4e4:	83320585 	teqhi	r2, #557842432	; 0x21400000
 4e8:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
 4ec:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 4f0:	01054b1a 	tsteq	r5, sl, lsl fp
 4f4:	3205852f 	andcc	r8, r5, #197132288	; 0xbc00000
 4f8:	4b2e05a1 	blmi	b81b84 <__bss_end+0xb786dc>
 4fc:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
 500:	0c052f2d 	stceq	15, cr2, [r5], {45}	; 0x2d
 504:	2f01054c 	svccs	0x0001054c
 508:	bd2e0585 	cfstr32lt	mvfx0, [lr, #-532]!	; 0xfffffdec
 50c:	054b3005 	strbeq	r3, [fp, #-5]
 510:	1b054b2e 	blne	1531d0 <__bss_end+0x149d28>
 514:	2f2e054b 	svccs	0x002e054b
 518:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 51c:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 520:	3005bd2e 	andcc	fp, r5, lr, lsr #26
 524:	4b2e054b 	blmi	b81a58 <__bss_end+0xb785b0>
 528:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
 52c:	0c052f2e 	stceq	15, cr2, [r5], {46}	; 0x2e
 530:	2f01054c 	svccs	0x0001054c
 534:	832e0585 			; <UNDEFINED> instruction: 0x832e0585
 538:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
 53c:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 540:	3305bd2e 	movwcc	fp, #23854	; 0x5d2e
 544:	4b2f054b 	blmi	bc1a78 <__bss_end+0xbb85d0>
 548:	054b1b05 	strbeq	r1, [fp, #-2821]	; 0xfffff4fb
 54c:	0c052f30 	stceq	15, cr2, [r5], {48}	; 0x30
 550:	2f01054c 	svccs	0x0001054c
 554:	a12e0585 	smlawbge	lr, r5, r5, r0
 558:	054b2f05 	strbeq	r2, [fp, #-3845]	; 0xfffff0fb
 55c:	2f054b1b 	svccs	0x00054b1b
 560:	4c0c052f 	cfstr32mi	mvfx0, [ip], {47}	; 0x2f
 564:	852f0105 	strhi	r0, [pc, #-261]!	; 467 <shift+0x467>
 568:	05bd2e05 	ldreq	r2, [sp, #3589]!	; 0xe05
 56c:	3b054b2f 	blcc	153230 <__bss_end+0x149d88>
 570:	4b1b054b 	blmi	6c1aa4 <__bss_end+0x6b85fc>
 574:	052f3005 	streq	r3, [pc, #-5]!	; 577 <shift+0x577>
 578:	01054c0c 	tsteq	r5, ip, lsl #24
 57c:	2f05852f 	svccs	0x0005852f
 580:	4b3b05a1 	blmi	ec1c0c <__bss_end+0xeb8764>
 584:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
 588:	0c052f30 	stceq	15, cr2, [r5], {48}	; 0x30
 58c:	9f01054c 	svcls	0x0001054c
 590:	67200585 	strvs	r0, [r0, -r5, lsl #11]!
 594:	054d2d05 	strbeq	r2, [sp, #-3333]	; 0xfffff2fb
 598:	1a054b31 	bne	153264 <__bss_end+0x149dbc>
 59c:	300c054b 	andcc	r0, ip, fp, asr #10
 5a0:	852f0105 	strhi	r0, [pc, #-261]!	; 4a3 <shift+0x4a3>
 5a4:	05672005 	strbeq	r2, [r7, #-5]!
 5a8:	31054d2d 	tstcc	r5, sp, lsr #26
 5ac:	4b1a054b 	blmi	681ae0 <__bss_end+0x678638>
 5b0:	05300c05 	ldreq	r0, [r0, #-3077]!	; 0xfffff3fb
 5b4:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 5b8:	2d058320 	stccs	3, cr8, [r5, #-128]	; 0xffffff80
 5bc:	4b3e054c 	blmi	f81af4 <__bss_end+0xf7864c>
 5c0:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
 5c4:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 5c8:	2d056720 	stccs	7, cr6, [r5, #-128]	; 0xffffff80
 5cc:	4b30054d 	blmi	c01b08 <__bss_end+0xbf8660>
 5d0:	054b1a05 	strbeq	r1, [fp, #-2565]	; 0xfffff5fb
 5d4:	0105300c 	tsteq	r5, ip
 5d8:	0c05872f 	stceq	7, cr8, [r5], {47}	; 0x2f
 5dc:	31059fa0 	smlatbcc	r5, r0, pc, r9	; <UNPREDICTABLE>
 5e0:	662905bc 			; <UNDEFINED> instruction: 0x662905bc
 5e4:	052e3605 	streq	r3, [lr, #-1541]!	; 0xfffff9fb
 5e8:	1305300f 	movwne	r3, #20495	; 0x500f
 5ec:	84090566 	strhi	r0, [r9], #-1382	; 0xfffffa9a
 5f0:	05d81005 	ldrbeq	r1, [r8, #5]
 5f4:	08029f01 	stmdaeq	r2, {r0, r8, r9, sl, fp, ip, pc}
 5f8:	bf010100 	svclt	0x00010100
 5fc:	03000004 	movweq	r0, #4
 600:	00004f00 	andeq	r4, r0, r0, lsl #30
 604:	fb010200 	blx	40e0e <__bss_end+0x37966>
 608:	01000d0e 	tsteq	r0, lr, lsl #26
 60c:	00010101 	andeq	r0, r1, r1, lsl #2
 610:	00010000 	andeq	r0, r1, r0
 614:	682f0100 	stmdavs	pc!, {r8}	; <UNPREDICTABLE>
 618:	2f656d6f 	svccs	0x00656d6f
 61c:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
 620:	2f6a6b6e 	svccs	0x006a6b6e
 624:	3032736f 	eorscc	r7, r2, pc, ror #6
 628:	732f3232 			; <UNDEFINED> instruction: 0x732f3232
 62c:	6f732f70 	svcvs	0x00732f70
 630:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
 634:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
 638:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
 63c:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
 640:	74730000 	ldrbtvc	r0, [r3], #-0
 644:	72747364 	rsbsvc	r7, r4, #100, 6	; 0x90000001
 648:	2e676e69 	cdpcs	14, 6, cr6, cr7, cr9, {3}
 64c:	00707063 	rsbseq	r7, r0, r3, rrx
 650:	00000001 	andeq	r0, r0, r1
 654:	05000105 	streq	r0, [r0, #-261]	; 0xfffffefb
 658:	0086d002 	addeq	sp, r6, r2
 65c:	010a0300 	mrseq	r0, (UNDEF: 58)
 660:	05bb0605 	ldreq	r0, [fp, #1541]!	; 0x605
 664:	21054c0f 	tstcs	r5, pc, lsl #24
 668:	ba0a0568 	blt	281c10 <__bss_end+0x278768>
 66c:	052e0b05 	streq	r0, [lr, #-2821]!	; 0xfffff4fb
 670:	0d054a27 	vstreq	s8, [r5, #-156]	; 0xffffff64
 674:	2f09054a 	svccs	0x0009054a
 678:	059f0405 	ldreq	r0, [pc, #1029]	; a85 <shift+0xa85>
 67c:	05056202 	streq	r6, [r5, #-514]	; 0xfffffdfe
 680:	68100535 	ldmdavs	r0, {r0, r2, r4, r5, r8, sl}
 684:	052e1105 	streq	r1, [lr, #-261]!	; 0xfffffefb
 688:	13054a22 	movwne	r4, #23074	; 0x5a22
 68c:	2f0a052e 	svccs	0x000a052e
 690:	05690905 	strbeq	r0, [r9, #-2309]!	; 0xfffff6fb
 694:	0c052e0a 	stceq	14, cr2, [r5], {10}
 698:	4b03054a 	blmi	c1bc8 <__bss_end+0xb8720>
 69c:	05680b05 	strbeq	r0, [r8, #-2821]!	; 0xfffff4fb
 6a0:	04020018 	streq	r0, [r2], #-24	; 0xffffffe8
 6a4:	14054a03 	strne	r4, [r5], #-2563	; 0xfffff5fd
 6a8:	03040200 	movweq	r0, #16896	; 0x4200
 6ac:	0015059e 	mulseq	r5, lr, r5
 6b0:	68020402 	stmdavs	r2, {r1, sl}
 6b4:	02001805 	andeq	r1, r0, #327680	; 0x50000
 6b8:	05820204 	streq	r0, [r2, #516]	; 0x204
 6bc:	04020008 	streq	r0, [r2], #-8
 6c0:	1a054a02 	bne	152ed0 <__bss_end+0x149a28>
 6c4:	02040200 	andeq	r0, r4, #0, 4
 6c8:	001b054b 	andseq	r0, fp, fp, asr #10
 6cc:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 6d0:	02000c05 	andeq	r0, r0, #1280	; 0x500
 6d4:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 6d8:	0402000f 	streq	r0, [r2], #-15
 6dc:	1b058202 	blne	160eec <__bss_end+0x157a44>
 6e0:	02040200 	andeq	r0, r4, #0, 4
 6e4:	0011054a 	andseq	r0, r1, sl, asr #10
 6e8:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 6ec:	02000a05 	andeq	r0, r0, #20480	; 0x5000
 6f0:	052f0204 	streq	r0, [pc, #-516]!	; 4f4 <shift+0x4f4>
 6f4:	0402000b 	streq	r0, [r2], #-11
 6f8:	0d052e02 	stceq	14, cr2, [r5, #-8]
 6fc:	02040200 	andeq	r0, r4, #0, 4
 700:	0002054a 	andeq	r0, r2, sl, asr #10
 704:	46020402 	strmi	r0, [r2], -r2, lsl #8
 708:	85880105 	strhi	r0, [r8, #261]	; 0x105
 70c:	05830605 	streq	r0, [r3, #1541]	; 0x605
 710:	10054c09 	andne	r4, r5, r9, lsl #24
 714:	4c0a054a 	cfstr32mi	mvfx0, [sl], {74}	; 0x4a
 718:	05bb0705 	ldreq	r0, [fp, #1797]!	; 0x705
 71c:	17054a03 	strne	r4, [r5, -r3, lsl #20]
 720:	01040200 	mrseq	r0, R12_usr
 724:	0014054a 	andseq	r0, r4, sl, asr #10
 728:	4a010402 	bmi	41738 <__bss_end+0x38290>
 72c:	054d0d05 	strbeq	r0, [sp, #-3333]	; 0xfffff2fb
 730:	0a054a14 	beq	152f88 <__bss_end+0x149ae0>
 734:	6808052e 	stmdavs	r8, {r1, r2, r3, r5, r8, sl}
 738:	78030205 	stmdavc	r3, {r0, r2, r9}
 73c:	03090566 	movweq	r0, #38246	; 0x9566
 740:	01052e0b 	tsteq	r5, fp, lsl #28
 744:	851b052f 	ldrhi	r0, [fp, #-1327]	; 0xfffffad1
 748:	05830905 	streq	r0, [r3, #2309]	; 0x905
 74c:	12054b0b 	andne	r4, r5, #11264	; 0x2c00
 750:	bb0f0568 	bllt	3c1cf8 <__bss_end+0x3b8850>
 754:	05830905 	streq	r0, [r3, #2309]	; 0x905
 758:	0c056405 	cfstrseq	mvf6, [r5], {5}
 75c:	4a120533 	bmi	481c30 <__bss_end+0x478788>
 760:	05830f05 	streq	r0, [r3, #3845]	; 0xf05
 764:	05058309 	streq	r8, [r5, #-777]	; 0xfffffcf7
 768:	320a0564 	andcc	r0, sl, #100, 10	; 0x19000000
 76c:	05670c05 	strbeq	r0, [r7, #-3077]!	; 0xfffff3fb
 770:	23082f01 	movwcs	r2, #36609	; 0x8f01
 774:	05830905 	streq	r0, [r3, #2309]	; 0x905
 778:	11054b07 	tstne	r5, r7, lsl #22
 77c:	660f054c 	strvs	r0, [pc], -ip, asr #10
 780:	052e0d05 	streq	r0, [lr, #-3333]!	; 0xfffff2fb
 784:	02002e1d 	andeq	r2, r0, #464	; 0x1d0
 788:	66060104 	strvs	r0, [r6], -r4, lsl #2
 78c:	02002005 	andeq	r2, r0, #5
 790:	66060304 	strvs	r0, [r6], -r4, lsl #6
 794:	02001d05 	andeq	r1, r0, #320	; 0x140
 798:	00660504 	rsbeq	r0, r6, r4, lsl #10
 79c:	06060402 	streq	r0, [r6], -r2, lsl #8
 7a0:	0402004a 	streq	r0, [r2], #-74	; 0xffffffb6
 7a4:	09052e08 	stmdbeq	r5, {r3, r9, sl, fp, sp}
 7a8:	0a054b06 	beq	1533c8 <__bss_end+0x149f20>
 7ac:	4a15054a 	bmi	541cdc <__bss_end+0x538834>
 7b0:	054a1005 	strbeq	r1, [sl, #-5]
 7b4:	03056607 	movweq	r6, #22023	; 0x5607
 7b8:	13053149 	movwne	r3, #20809	; 0x5149
 7bc:	66110567 	ldrvs	r0, [r1], -r7, ror #10
 7c0:	052e0f05 	streq	r0, [lr, #-3845]!	; 0xfffff0fb
 7c4:	02002e1f 	andeq	r2, r0, #496	; 0x1f0
 7c8:	66060104 	strvs	r0, [r6], -r4, lsl #2
 7cc:	02002205 	andeq	r2, r0, #1342177280	; 0x50000000
 7d0:	66060304 	strvs	r0, [r6], -r4, lsl #6
 7d4:	02001f05 	andeq	r1, r0, #5, 30
 7d8:	00660504 	rsbeq	r0, r6, r4, lsl #10
 7dc:	06060402 	streq	r0, [r6], -r2, lsl #8
 7e0:	0402004a 	streq	r0, [r2], #-74	; 0xffffffb6
 7e4:	0b052e08 	bleq	14c00c <__bss_end+0x142b64>
 7e8:	0c054b06 			; <UNDEFINED> instruction: 0x0c054b06
 7ec:	4a17054a 	bmi	5c1d1c <__bss_end+0x5b8874>
 7f0:	054a1205 	strbeq	r1, [sl, #-517]	; 0xfffffdfb
 7f4:	054b6609 	strbeq	r6, [fp, #-1545]	; 0xfffff9f7
 7f8:	03056405 	movweq	r6, #21509	; 0x5405
 7fc:	00100533 	andseq	r0, r0, r3, lsr r5
 800:	66010402 	strvs	r0, [r1], -r2, lsl #8
 804:	4b670905 	blmi	19c2c20 <__bss_end+0x19b9778>
 808:	054b0b05 	strbeq	r0, [fp, #-2821]	; 0xfffff4fb
 80c:	07056609 	streq	r6, [r5, -r9, lsl #12]
 810:	2f05052e 	svccs	0x0005052e
 814:	05670d05 	strbeq	r0, [r7, #-3333]!	; 0xfffff2fb
 818:	0905660b 	stmdbeq	r5, {r0, r1, r3, r9, sl, sp, lr}
 81c:	4b0a052e 	blmi	281cdc <__bss_end+0x278834>
 820:	05670d05 	strbeq	r0, [r7, #-3333]!	; 0xfffff2fb
 824:	0905660b 	stmdbeq	r5, {r0, r1, r3, r9, sl, sp, lr}
 828:	2f0c052e 	svccs	0x000c052e
 82c:	0402004c 	streq	r0, [r2], #-76	; 0xffffffb4
 830:	06660601 	strbteq	r0, [r6], -r1, lsl #12
 834:	ba150567 	blt	541dd8 <__bss_end+0x538930>
 838:	054a0905 	strbeq	r0, [sl, #-2309]	; 0xfffff6fb
 83c:	0b054b0d 	bleq	153478 <__bss_end+0x149fd0>
 840:	2e090566 	cfsh32cs	mvfx0, mvfx9, #54
 844:	052c0505 	streq	r0, [ip, #-1285]!	; 0xfffffafb
 848:	0705320b 	streq	r3, [r5, -fp, lsl #4]
 84c:	680c0566 	stmdavs	ip, {r1, r2, r5, r6, r8, sl}
 850:	05670705 	strbeq	r0, [r7, #-1797]!	; 0xfffff8fb
 854:	03058306 	movweq	r8, #21254	; 0x5306
 858:	320c0564 	andcc	r0, ip, #100, 10	; 0x19000000
 85c:	05670705 	strbeq	r0, [r7, #-1797]!	; 0xfffff8fb
 860:	0305bb06 	movweq	fp, #23302	; 0x5b06
 864:	320a0564 	andcc	r0, sl, #100, 10	; 0x19000000
 868:	054b0105 	strbeq	r0, [fp, #-261]	; 0xfffffefb
 86c:	05220826 	streq	r0, [r2, #-2086]!	; 0xfffff7da
 870:	054b9f09 	strbeq	r9, [fp, #-3849]	; 0xfffff0f7
 874:	054c4b0f 	strbeq	r4, [ip, #-2831]	; 0xfffff4f1
 878:	13052e05 	movwne	r2, #24069	; 0x5e05
 87c:	67110567 	ldrvs	r0, [r1, -r7, ror #10]
 880:	054a1305 	strbeq	r1, [sl, #-773]	; 0xfffffcfb
 884:	0f054b09 	svceq	0x00054b09
 888:	2e050531 	mcrcs	5, 0, r0, cr5, cr1, {1}
 88c:	05671005 	strbeq	r1, [r7, #-5]!
 890:	11056613 	tstne	r5, r3, lsl r6
 894:	4a0f054b 	bmi	3c1dc8 <__bss_end+0x3b8920>
 898:	05311905 	ldreq	r1, [r1, #-2309]!	; 0xfffff6fb
 89c:	1b058415 	blne	1618f8 <__bss_end+0x158450>
 8a0:	660d0567 	strvs	r0, [sp], -r7, ror #10
 8a4:	05671b05 	strbeq	r1, [r7, #-2821]!	; 0xfffff4fb
 8a8:	1b054a10 	blne	1530f0 <__bss_end+0x149c48>
 8ac:	4a130566 	bmi	4c1e4c <__bss_end+0x4b89a4>
 8b0:	052f1705 	streq	r1, [pc, #-1797]!	; 1b3 <shift+0x1b3>
 8b4:	0f05661c 	svceq	0x0005661c
 8b8:	2f090582 	svccs	0x00090582
 8bc:	61050567 	tstvs	r5, r7, ror #10
 8c0:	67100536 			; <UNDEFINED> instruction: 0x67100536
 8c4:	05661305 	strbeq	r1, [r6, #-773]!	; 0xfffffcfb
 8c8:	0f054c0c 	svceq	0x00054c0c
 8cc:	4c190566 	cfldr32mi	mvfx0, [r9], {102}	; 0x66
 8d0:	01040200 	mrseq	r0, R12_usr
 8d4:	10056606 	andne	r6, r5, r6, lsl #12
 8d8:	13056706 	movwne	r6, #22278	; 0x5706
 8dc:	4b090566 	blmi	241e7c <__bss_end+0x2389d4>
 8e0:	63050567 	movwvs	r0, #21863	; 0x5567
 8e4:	05341305 	ldreq	r1, [r4, #-773]!	; 0xfffffcfb
 8e8:	1b056715 	blne	15a544 <__bss_end+0x15109c>
 8ec:	4a0d054a 	bmi	341e1c <__bss_end+0x338974>
 8f0:	05671b05 	strbeq	r1, [r7, #-2821]!	; 0xfffff4fb
 8f4:	1b054a10 	blne	15313c <__bss_end+0x149c94>
 8f8:	4a130566 	bmi	4c1e98 <__bss_end+0x4b89f0>
 8fc:	052f1105 	streq	r1, [pc, #-261]!	; 7ff <shift+0x7ff>
 900:	1e054a17 			; <UNDEFINED> instruction: 0x1e054a17
 904:	9e0f054a 	cfsh32ls	mvfx0, mvfx15, #42
 908:	052f0905 	streq	r0, [pc, #-2309]!	; b <shift+0xb>
 90c:	0d056205 	sfmeq	f6, 4, [r5, #-20]	; 0xffffffec
 910:	67010534 	smladxvs	r1, r4, r5, r0
 914:	bd0905a1 	cfstr32lt	mvfx0, [r9, #-644]	; 0xfffffd7c
 918:	02001605 	andeq	r1, r0, #5242880	; 0x500000
 91c:	054a0404 	strbeq	r0, [sl, #-1028]	; 0xfffffbfc
 920:	0402001d 	streq	r0, [r2], #-29	; 0xffffffe3
 924:	1e058202 	cdpne	2, 0, cr8, cr5, cr2, {0}
 928:	02040200 	andeq	r0, r4, #0, 4
 92c:	0016052e 	andseq	r0, r6, lr, lsr #10
 930:	66020402 	strvs	r0, [r2], -r2, lsl #8
 934:	02001105 	andeq	r1, r0, #1073741825	; 0x40000001
 938:	054b0304 	strbeq	r0, [fp, #-772]	; 0xfffffcfc
 93c:	04020012 	streq	r0, [r2], #-18	; 0xffffffee
 940:	08052e03 	stmdaeq	r5, {r0, r1, r9, sl, fp, sp}
 944:	03040200 	movweq	r0, #16896	; 0x4200
 948:	0009054a 	andeq	r0, r9, sl, asr #10
 94c:	2e030402 	cdpcs	4, 0, cr0, cr3, cr2, {0}
 950:	02001205 	andeq	r1, r0, #1342177280	; 0x50000000
 954:	054a0304 	strbeq	r0, [sl, #-772]	; 0xfffffcfc
 958:	0402000b 	streq	r0, [r2], #-11
 95c:	02052e03 	andeq	r2, r5, #3, 28	; 0x30
 960:	03040200 	movweq	r0, #16896	; 0x4200
 964:	000b052d 	andeq	r0, fp, sp, lsr #10
 968:	84020402 	strhi	r0, [r2], #-1026	; 0xfffffbfe
 96c:	02000805 	andeq	r0, r0, #327680	; 0x50000
 970:	05830104 	streq	r0, [r3, #260]	; 0x104
 974:	04020009 	streq	r0, [r2], #-9
 978:	0b052e01 	bleq	14c184 <__bss_end+0x142cdc>
 97c:	01040200 	mrseq	r0, R12_usr
 980:	0002054a 	andeq	r0, r2, sl, asr #10
 984:	49010402 	stmdbmi	r1, {r1, sl}
 988:	05850b05 	streq	r0, [r5, #2821]	; 0xb05
 98c:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 990:	1605a10c 	strne	sl, [r5], -ip, lsl #2
 994:	03040200 	movweq	r0, #16896	; 0x4200
 998:	0017054a 	andseq	r0, r7, sl, asr #10
 99c:	2e030402 	cdpcs	4, 0, cr0, cr3, cr2, {0}
 9a0:	02001905 	andeq	r1, r0, #81920	; 0x14000
 9a4:	05660304 	strbeq	r0, [r6, #-772]!	; 0xfffffcfc
 9a8:	04020005 	streq	r0, [r2], #-5
 9ac:	0c054a02 			; <UNDEFINED> instruction: 0x0c054a02
 9b0:	00150584 	andseq	r0, r5, r4, lsl #11
 9b4:	4a030402 	bmi	c19c4 <__bss_end+0xb851c>
 9b8:	02001605 	andeq	r1, r0, #5242880	; 0x500000
 9bc:	052e0304 	streq	r0, [lr, #-772]!	; 0xfffffcfc
 9c0:	04020018 	streq	r0, [r2], #-24	; 0xffffffe8
 9c4:	19056603 	stmdbne	r5, {r0, r1, r9, sl, sp, lr}
 9c8:	02040200 	andeq	r0, r4, #0, 4
 9cc:	001a054b 	andseq	r0, sl, fp, asr #10
 9d0:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 9d4:	02000f05 	andeq	r0, r0, #5, 30
 9d8:	054a0204 	strbeq	r0, [sl, #-516]	; 0xfffffdfc
 9dc:	04020011 	streq	r0, [r2], #-17	; 0xffffffef
 9e0:	1a058202 	bne	1611f0 <__bss_end+0x157d48>
 9e4:	02040200 	andeq	r0, r4, #0, 4
 9e8:	0013054a 	andseq	r0, r3, sl, asr #10
 9ec:	2e020402 	cdpcs	4, 0, cr0, cr2, cr2, {0}
 9f0:	02000505 	andeq	r0, r0, #20971520	; 0x1400000
 9f4:	052d0204 	streq	r0, [sp, #-516]!	; 0xfffffdfc
 9f8:	0d05850b 	cfstr32eq	mvfx8, [r5, #-44]	; 0xffffffd4
 9fc:	4a0f0582 	bmi	3c200c <__bss_end+0x3b8b64>
 a00:	054c0c05 	strbeq	r0, [ip, #-3077]	; 0xfffff3fb
 a04:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 a08:	1105bc0e 	tstne	r5, lr, lsl #24
 a0c:	bc200566 	cfstr32lt	mvfx0, [r0], #-408	; 0xfffffe68
 a10:	05660b05 	strbeq	r0, [r6, #-2821]!	; 0xfffff4fb
 a14:	0a054b1f 	beq	153698 <__bss_end+0x14a1f0>
 a18:	4b080566 	blmi	201fb8 <__bss_end+0x1f8b10>
 a1c:	05831105 	streq	r1, [r3, #261]	; 0x105
 a20:	08052e16 	stmdaeq	r5, {r1, r2, r4, r9, sl, fp, sp}
 a24:	67110567 	ldrvs	r0, [r1, -r7, ror #10]
 a28:	054d0b05 	strbeq	r0, [sp, #-2821]	; 0xfffff4fb
 a2c:	05852f01 	streq	r2, [r5, #3841]	; 0xf01
 a30:	0b058306 	bleq	161650 <__bss_end+0x1581a8>
 a34:	2e0c054c 	cfsh32cs	mvfx0, mvfx12, #44
 a38:	05660e05 	strbeq	r0, [r6, #-3589]!	; 0xfffff1fb
 a3c:	02054b04 	andeq	r4, r5, #4, 22	; 0x1000
 a40:	31090565 	tstcc	r9, r5, ror #10
 a44:	852f0105 	strhi	r0, [pc, #-261]!	; 947 <shift+0x947>
 a48:	059f0805 	ldreq	r0, [pc, #2053]	; 1255 <shift+0x1255>
 a4c:	14054c0b 	strne	r4, [r5], #-3083	; 0xfffff3f5
 a50:	03040200 	movweq	r0, #16896	; 0x4200
 a54:	0007054a 	andeq	r0, r7, sl, asr #10
 a58:	83020402 	movwhi	r0, #9218	; 0x2402
 a5c:	02000805 	andeq	r0, r0, #327680	; 0x50000
 a60:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 a64:	0402000a 	streq	r0, [r2], #-10
 a68:	02054a02 	andeq	r4, r5, #8192	; 0x2000
 a6c:	02040200 	andeq	r0, r4, #0, 4
 a70:	84010549 	strhi	r0, [r1], #-1353	; 0xfffffab7
 a74:	bb0e0585 	bllt	382090 <__bss_end+0x378be8>
 a78:	054b0805 	strbeq	r0, [fp, #-2053]	; 0xfffff7fb
 a7c:	14054c0b 	strne	r4, [r5], #-3083	; 0xfffff3f5
 a80:	03040200 	movweq	r0, #16896	; 0x4200
 a84:	0016054a 	andseq	r0, r6, sl, asr #10
 a88:	83020402 	movwhi	r0, #9218	; 0x2402
 a8c:	02001705 	andeq	r1, r0, #1310720	; 0x140000
 a90:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 a94:	0402000a 	streq	r0, [r2], #-10
 a98:	0b054a02 	bleq	1532a8 <__bss_end+0x149e00>
 a9c:	02040200 	andeq	r0, r4, #0, 4
 aa0:	0017052e 	andseq	r0, r7, lr, lsr #10
 aa4:	4a020402 	bmi	81ab4 <__bss_end+0x7860c>
 aa8:	02000d05 	andeq	r0, r0, #320	; 0x140
 aac:	052e0204 	streq	r0, [lr, #-516]!	; 0xfffffdfc
 ab0:	04020002 	streq	r0, [r2], #-2
 ab4:	01052d02 	tsteq	r5, r2, lsl #26
 ab8:	00080284 	andeq	r0, r8, r4, lsl #5
 abc:	00790101 	rsbseq	r0, r9, r1, lsl #2
 ac0:	00030000 	andeq	r0, r3, r0
 ac4:	00000046 	andeq	r0, r0, r6, asr #32
 ac8:	0efb0102 	cdpeq	1, 15, cr0, cr11, cr2, {0}
 acc:	0101000d 	tsteq	r1, sp
 ad0:	00000101 	andeq	r0, r0, r1, lsl #2
 ad4:	00000100 	andeq	r0, r0, r0, lsl #2
 ad8:	2f2e2e01 	svccs	0x002e2e01
 adc:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 ae0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 ae4:	2f2e2e2f 	svccs	0x002e2e2f
 ae8:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; a38 <shift+0xa38>
 aec:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
 af0:	6f632f63 	svcvs	0x00632f63
 af4:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
 af8:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
 afc:	696c0000 	stmdbvs	ip!, {}^	; <UNPREDICTABLE>
 b00:	75663162 	strbvc	r3, [r6, #-354]!	; 0xfffffe9e
 b04:	2e73636e 	cdpcs	3, 7, cr6, cr3, cr14, {3}
 b08:	00010053 	andeq	r0, r1, r3, asr r0
 b0c:	05000000 	streq	r0, [r0, #-0]
 b10:	00921002 	addseq	r1, r2, r2
 b14:	08ca0300 	stmiaeq	sl, {r8, r9}^
 b18:	2f2f3001 	svccs	0x002f3001
 b1c:	302f2f2f 	eorcc	r2, pc, pc, lsr #30
 b20:	1401d002 	strne	sp, [r1], #-2
 b24:	2f2f312f 	svccs	0x002f312f
 b28:	322f4c30 	eorcc	r4, pc, #48, 24	; 0x3000
 b2c:	2f661f03 	svccs	0x00661f03
 b30:	2f2f2f2f 	svccs	0x002f2f2f
 b34:	02022f2f 	andeq	r2, r2, #47, 30	; 0xbc
 b38:	5c010100 	stfpls	f0, [r1], {-0}
 b3c:	03000000 	movweq	r0, #0
 b40:	00004600 	andeq	r4, r0, r0, lsl #12
 b44:	fb010200 	blx	4134e <__bss_end+0x37ea6>
 b48:	01000d0e 	tsteq	r0, lr, lsl #26
 b4c:	00010101 	andeq	r0, r1, r1, lsl #2
 b50:	00010000 	andeq	r0, r1, r0
 b54:	2e2e0100 	sufcse	f0, f6, f0
 b58:	2f2e2e2f 	svccs	0x002e2e2f
 b5c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 b60:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 b64:	2f2e2e2f 	svccs	0x002e2e2f
 b68:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 b6c:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
 b70:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
 b74:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
 b78:	6c00006d 	stcvs	0, cr0, [r0], {109}	; 0x6d
 b7c:	66316269 	ldrtvs	r6, [r1], -r9, ror #4
 b80:	73636e75 	cmnvc	r3, #1872	; 0x750
 b84:	0100532e 	tsteq	r0, lr, lsr #6
 b88:	00000000 	andeq	r0, r0, r0
 b8c:	941c0205 	ldrls	r0, [ip], #-517	; 0xfffffdfb
 b90:	b4030000 	strlt	r0, [r3], #-0
 b94:	0202010b 	andeq	r0, r2, #-1073741822	; 0xc0000002
 b98:	03010100 	movweq	r0, #4352	; 0x1100
 b9c:	03000001 	movweq	r0, #1
 ba0:	0000fd00 	andeq	pc, r0, r0, lsl #26
 ba4:	fb010200 	blx	413ae <__bss_end+0x37f06>
 ba8:	01000d0e 	tsteq	r0, lr, lsl #26
 bac:	00010101 	andeq	r0, r1, r1, lsl #2
 bb0:	00010000 	andeq	r0, r1, r0
 bb4:	2e2e0100 	sufcse	f0, f6, f0
 bb8:	2f2e2e2f 	svccs	0x002e2e2f
 bbc:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 bc0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 bc4:	2f2e2e2f 	svccs	0x002e2e2f
 bc8:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 bcc:	2e2f6363 	cdpcs	3, 2, cr6, cr15, cr3, {3}
 bd0:	6e692f2e 	cdpvs	15, 6, cr2, cr9, cr14, {1}
 bd4:	64756c63 	ldrbtvs	r6, [r5], #-3171	; 0xfffff39d
 bd8:	2e2e0065 	cdpcs	0, 2, cr0, cr14, cr5, {3}
 bdc:	2f2e2e2f 	svccs	0x002e2e2f
 be0:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 be4:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 be8:	672f2e2f 	strvs	r2, [pc, -pc, lsr #28]!
 bec:	2e006363 	cdpcs	3, 0, cr6, cr0, cr3, {3}
 bf0:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 bf4:	2f2e2e2f 	svccs	0x002e2e2f
 bf8:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 bfc:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 c00:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
 c04:	2f636367 	svccs	0x00636367
 c08:	672f2e2e 	strvs	r2, [pc, -lr, lsr #28]!
 c0c:	632f6363 			; <UNDEFINED> instruction: 0x632f6363
 c10:	69666e6f 	stmdbvs	r6!, {r0, r1, r2, r3, r5, r6, r9, sl, fp, sp, lr}^
 c14:	72612f67 	rsbvc	r2, r1, #412	; 0x19c
 c18:	2e2e006d 	cdpcs	0, 2, cr0, cr14, cr13, {3}
 c1c:	2f2e2e2f 	svccs	0x002e2e2f
 c20:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
 c24:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
 c28:	2f2e2e2f 	svccs	0x002e2e2f
 c2c:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 c30:	00006363 	andeq	r6, r0, r3, ror #6
 c34:	68736168 	ldmdavs	r3!, {r3, r5, r6, r8, sp, lr}^
 c38:	2e626174 	mcrcs	1, 3, r6, cr2, cr4, {3}
 c3c:	00010068 	andeq	r0, r1, r8, rrx
 c40:	6d726100 	ldfvse	f6, [r2, #-0]
 c44:	6173692d 	cmnvs	r3, sp, lsr #18
 c48:	0200682e 	andeq	r6, r0, #3014656	; 0x2e0000
 c4c:	72610000 	rsbvc	r0, r1, #0
 c50:	70632d6d 	rsbvc	r2, r3, sp, ror #26
 c54:	00682e75 	rsbeq	r2, r8, r5, ror lr
 c58:	69000002 	stmdbvs	r0, {r1}
 c5c:	2d6e736e 	stclcs	3, cr7, [lr, #-440]!	; 0xfffffe48
 c60:	736e6f63 	cmnvc	lr, #396	; 0x18c
 c64:	746e6174 	strbtvc	r6, [lr], #-372	; 0xfffffe8c
 c68:	00682e73 	rsbeq	r2, r8, r3, ror lr
 c6c:	61000002 	tstvs	r0, r2
 c70:	682e6d72 	stmdavs	lr!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}
 c74:	00000300 	andeq	r0, r0, r0, lsl #6
 c78:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 c7c:	2e326363 	cdpcs	3, 3, cr6, cr2, cr3, {3}
 c80:	00040068 	andeq	r0, r4, r8, rrx
 c84:	6c626700 	stclvs	7, cr6, [r2], #-0
 c88:	6f74632d 	svcvs	0x0074632d
 c8c:	682e7372 	stmdavs	lr!, {r1, r4, r5, r6, r8, r9, ip, sp, lr}
 c90:	00000400 	andeq	r0, r0, r0, lsl #8
 c94:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
 c98:	2e326363 	cdpcs	3, 3, cr6, cr2, cr3, {3}
 c9c:	00040063 	andeq	r0, r4, r3, rrx
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
      58:	17a40704 	strne	r0, [r4, r4, lsl #14]!
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
     128:	000017a4 	andeq	r1, r0, r4, lsr #15
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
     174:	cb104801 	blgt	412180 <__bss_end+0x408cd8>
     178:	d4000000 	strle	r0, [r0], #-0
     17c:	58000081 	stmdapl	r0, {r0, r7}
     180:	01000000 	mrseq	r0, (UNDEF: 0)
     184:	0000cb9c 	muleq	r0, ip, fp
     188:	01b70a00 			; <UNDEFINED> instruction: 0x01b70a00
     18c:	4a010000 	bmi	40194 <__bss_end+0x36cec>
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
     24c:	8b120f01 	blhi	483e58 <__bss_end+0x47a9b0>
     250:	0f000001 	svceq	0x00000001
     254:	0000019e 	muleq	r0, lr, r1
     258:	03831000 	orreq	r1, r3, #0
     25c:	0a010000 	beq	40264 <__bss_end+0x36dbc>
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
     2b4:	8b140074 	blhi	50048c <__bss_end+0x4f6fe4>
     2b8:	a4000001 	strge	r0, [r0], #-1
     2bc:	38000080 	stmdacc	r0, {r7}
     2c0:	01000000 	mrseq	r0, (UNDEF: 0)
     2c4:	0067139c 	mlseq	r7, ip, r3, r1
     2c8:	9e2f0a01 	vmulls.f32	s0, s30, s2
     2cc:	02000001 	andeq	r0, r0, #1
     2d0:	00007491 	muleq	r0, r1, r4
     2d4:	000008bc 			; <UNDEFINED> instruction: 0x000008bc
     2d8:	01e00004 	mvneq	r0, r4
     2dc:	01040000 	mrseq	r0, (UNDEF: 4)
     2e0:	0000023f 	andeq	r0, r0, pc, lsr r2
     2e4:	00083804 	andeq	r3, r8, r4, lsl #16
     2e8:	00003100 	andeq	r3, r0, r0, lsl #2
     2ec:	00822c00 	addeq	r2, r2, r0, lsl #24
     2f0:	00004800 	andeq	r4, r0, r0, lsl #16
     2f4:	0001d700 	andeq	sp, r1, r0, lsl #14
     2f8:	08010200 	stmdaeq	r1, {r9}
     2fc:	00000737 	andeq	r0, r0, r7, lsr r7
     300:	00002503 	andeq	r2, r0, r3, lsl #10
     304:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
     308:	0000042a 	andeq	r0, r0, sl, lsr #8
     30c:	69050404 	stmdbvs	r5, {r2, sl}
     310:	0200746e 	andeq	r7, r0, #1845493760	; 0x6e000000
     314:	072e0801 	streq	r0, [lr, -r1, lsl #16]!
     318:	02020000 	andeq	r0, r2, #0
     31c:	00087507 	andeq	r7, r8, r7, lsl #10
     320:	077c0500 	ldrbeq	r0, [ip, -r0, lsl #10]!
     324:	09070000 	stmdbeq	r7, {}	; <UNPREDICTABLE>
     328:	00005e07 	andeq	r5, r0, r7, lsl #28
     32c:	004d0300 	subeq	r0, sp, r0, lsl #6
     330:	04020000 	streq	r0, [r2], #-0
     334:	0017a407 	andseq	sl, r7, r7, lsl #8
     338:	0ace0600 	beq	ff381b40 <__bss_end+0xff378698>
     33c:	02080000 	andeq	r0, r8, #0
     340:	008b0806 	addeq	r0, fp, r6, lsl #16
     344:	72070000 	andvc	r0, r7, #0
     348:	08020030 	stmdaeq	r2, {r4, r5}
     34c:	00004d0e 	andeq	r4, r0, lr, lsl #26
     350:	72070000 	andvc	r0, r7, #0
     354:	09020031 	stmdbeq	r2, {r0, r4, r5}
     358:	00004d0e 	andeq	r4, r0, lr, lsl #26
     35c:	08000400 	stmdaeq	r0, {sl}
     360:	00000434 	andeq	r0, r0, r4, lsr r4
     364:	00380405 	eorseq	r0, r8, r5, lsl #8
     368:	1f020000 	svcne	0x00020000
     36c:	0000c20c 	andeq	ip, r0, ip, lsl #4
     370:	049b0900 	ldreq	r0, [fp], #2304	; 0x900
     374:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
     378:	00000bc3 	andeq	r0, r0, r3, asr #23
     37c:	03a40901 			; <UNDEFINED> instruction: 0x03a40901
     380:	09020000 	stmdbeq	r2, {}	; <UNPREDICTABLE>
     384:	00000671 	andeq	r0, r0, r1, ror r6
     388:	0bb40903 	bleq	fed0279c <__bss_end+0xfecf92f4>
     38c:	09040000 	stmdbeq	r4, {}	; <UNPREDICTABLE>
     390:	000005f0 	strdeq	r0, [r0], -r0	; <UNPREDICTABLE>
     394:	07080005 	streq	r0, [r8, -r5]
     398:	05000004 	streq	r0, [r0, #-4]
     39c:	00003804 	andeq	r3, r0, r4, lsl #16
     3a0:	0c400200 	sfmeq	f0, 2, [r0], {-0}
     3a4:	000000ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     3a8:	0007ed09 	andeq	lr, r7, r9, lsl #26
     3ac:	77090000 	strvc	r0, [r9, -r0]
     3b0:	01000007 	tsteq	r0, r7
     3b4:	00076509 	andeq	r6, r7, r9, lsl #10
     3b8:	73090200 	movwvc	r0, #37376	; 0x9200
     3bc:	0300000a 	movweq	r0, #10
     3c0:	0009c509 	andeq	ip, r9, r9, lsl #10
     3c4:	f7090400 			; <UNDEFINED> instruction: 0xf7090400
     3c8:	0500000a 	streq	r0, [r0, #-10]
     3cc:	00072909 	andeq	r2, r7, r9, lsl #18
     3d0:	08000600 	stmdaeq	r0, {r9, sl}
     3d4:	00000715 	andeq	r0, r0, r5, lsl r7
     3d8:	00380405 	eorseq	r0, r8, r5, lsl #8
     3dc:	6f020000 	svcvs	0x00020000
     3e0:	0001180c 	andeq	r1, r1, ip, lsl #16
     3e4:	073c0900 	ldreq	r0, [ip, -r0, lsl #18]!
     3e8:	00000000 	andeq	r0, r0, r0
     3ec:	0006160a 	andeq	r1, r6, sl, lsl #12
     3f0:	14050300 	strne	r0, [r5], #-768	; 0xfffffd00
     3f4:	00000059 	andeq	r0, r0, r9, asr r0
     3f8:	94200305 	strtls	r0, [r0], #-773	; 0xfffffcfb
     3fc:	da0a0000 	ble	280404 <__bss_end+0x276f5c>
     400:	0300000a 	movweq	r0, #10
     404:	00591406 	subseq	r1, r9, r6, lsl #8
     408:	03050000 	movweq	r0, #20480	; 0x5000
     40c:	00009424 	andeq	r9, r0, r4, lsr #8
     410:	0005620a 	andeq	r6, r5, sl, lsl #4
     414:	1a070400 	bne	1c141c <__bss_end+0x1b7f74>
     418:	00000059 	andeq	r0, r0, r9, asr r0
     41c:	94280305 	strtls	r0, [r8], #-773	; 0xfffffcfb
     420:	320a0000 	andcc	r0, sl, #0
     424:	04000006 	streq	r0, [r0], #-6
     428:	00591a09 	subseq	r1, r9, r9, lsl #20
     42c:	03050000 	movweq	r0, #20480	; 0x5000
     430:	0000942c 	andeq	r9, r0, ip, lsr #8
     434:	0009180a 	andeq	r1, r9, sl, lsl #16
     438:	1a0b0400 	bne	2c1440 <__bss_end+0x2b7f98>
     43c:	00000059 	andeq	r0, r0, r9, asr r0
     440:	94300305 	ldrtls	r0, [r0], #-773	; 0xfffffcfb
     444:	fe0a0000 	cdp2	0, 0, cr0, cr10, cr0, {0}
     448:	0400000a 	streq	r0, [r0], #-10
     44c:	00591a0d 	subseq	r1, r9, sp, lsl #20
     450:	03050000 	movweq	r0, #20480	; 0x5000
     454:	00009434 	andeq	r9, r0, r4, lsr r4
     458:	0008a10a 	andeq	sl, r8, sl, lsl #2
     45c:	1a0f0400 	bne	3c1464 <__bss_end+0x3b7fbc>
     460:	00000059 	andeq	r0, r0, r9, asr r0
     464:	94380305 	ldrtls	r0, [r8], #-773	; 0xfffffcfb
     468:	a0080000 	andge	r0, r8, r0
     46c:	05000007 	streq	r0, [r0, #-7]
     470:	00003804 	andeq	r3, r0, r4, lsl #16
     474:	0c1b0400 	cfldrseq	mvf0, [fp], {-0}
     478:	000001bb 			; <UNDEFINED> instruction: 0x000001bb
     47c:	0008b309 	andeq	fp, r8, r9, lsl #6
     480:	4b090000 	blmi	240488 <__bss_end+0x236fe0>
     484:	0100000c 	tsteq	r0, ip
     488:	00076009 	andeq	r6, r7, r9
     48c:	0b000200 	bleq	c94 <shift+0xc94>
     490:	0000081f 	andeq	r0, r0, pc, lsl r8
     494:	00064e0c 	andeq	r4, r6, ip, lsl #28
     498:	63049000 	movwvs	r9, #16384	; 0x4000
     49c:	00032e07 	andeq	r2, r3, r7, lsl #28
     4a0:	06240600 	strteq	r0, [r4], -r0, lsl #12
     4a4:	04240000 	strteq	r0, [r4], #-0
     4a8:	02481067 	subeq	r1, r8, #103	; 0x67
     4ac:	140d0000 	strne	r0, [sp], #-0
     4b0:	0400001b 	streq	r0, [r0], #-27	; 0xffffffe5
     4b4:	032e1269 			; <UNDEFINED> instruction: 0x032e1269
     4b8:	0d000000 	stceq	0, cr0, [r0, #-0]
     4bc:	00000556 	andeq	r0, r0, r6, asr r5
     4c0:	3e126b04 	vnmlscc.f64	d6, d2, d4
     4c4:	10000003 	andne	r0, r0, r3
     4c8:	0003aa0d 	andeq	sl, r3, sp, lsl #20
     4cc:	166d0400 	strbtne	r0, [sp], -r0, lsl #8
     4d0:	0000004d 	andeq	r0, r0, sp, asr #32
     4d4:	060f0d14 			; <UNDEFINED> instruction: 0x060f0d14
     4d8:	70040000 	andvc	r0, r4, r0
     4dc:	0003451c 	andeq	r4, r3, ip, lsl r5
     4e0:	5a0d1800 	bpl	3464e8 <__bss_end+0x33d040>
     4e4:	04000006 	streq	r0, [r0], #-6
     4e8:	03451c72 	movteq	r1, #23666	; 0x5c72
     4ec:	0d1c0000 	ldceq	0, cr0, [ip, #-0]
     4f0:	00000c56 	andeq	r0, r0, r6, asr ip
     4f4:	451c7504 	ldrmi	r7, [ip, #-1284]	; 0xfffffafc
     4f8:	20000003 	andcs	r0, r0, r3
     4fc:	0007c60e 	andeq	ip, r7, lr, lsl #12
     500:	1c770400 	cfldrdne	mvd0, [r7], #-0
     504:	00000b11 	andeq	r0, r0, r1, lsl fp
     508:	00000345 	andeq	r0, r0, r5, asr #6
     50c:	0000023c 	andeq	r0, r0, ip, lsr r2
     510:	0003450f 	andeq	r4, r3, pc, lsl #10
     514:	034b1000 	movteq	r1, #45056	; 0xb000
     518:	00000000 	andeq	r0, r0, r0
     51c:	00074106 	andeq	r4, r7, r6, lsl #2
     520:	7b041800 	blvc	106528 <__bss_end+0xfd080>
     524:	00027d10 	andeq	r7, r2, r0, lsl sp
     528:	1b140d00 	blne	503930 <__bss_end+0x4fa488>
     52c:	7e040000 	cdpvc	0, 0, cr0, cr4, cr0, {0}
     530:	00032e12 	andeq	r2, r3, r2, lsl lr
     534:	1f0d0000 	svcne	0x000d0000
     538:	04000004 	streq	r0, [r0], #-4
     53c:	034b1980 	movteq	r1, #47488	; 0xb980
     540:	0d100000 	ldceq	0, cr0, [r0, #-0]
     544:	000007e6 	andeq	r0, r0, r6, ror #15
     548:	56218204 	strtpl	r8, [r1], -r4, lsl #4
     54c:	14000003 	strne	r0, [r0], #-3
     550:	02480300 	subeq	r0, r8, #0, 6
     554:	a8110000 	ldmdage	r1, {}	; <UNPREDICTABLE>
     558:	04000004 	streq	r0, [r0], #-4
     55c:	035c2186 	cmpeq	ip, #-2147483615	; 0x80000021
     560:	b4110000 	ldrlt	r0, [r1], #-0
     564:	04000004 	streq	r0, [r0], #-4
     568:	00591f88 	subseq	r1, r9, r8, lsl #31
     56c:	1b0d0000 	blne	340574 <__bss_end+0x3370cc>
     570:	0400000a 	streq	r0, [r0], #-10
     574:	01cd178b 	biceq	r1, sp, fp, lsl #15
     578:	0d000000 	stceq	0, cr0, [r0, #-0]
     57c:	000003b5 			; <UNDEFINED> instruction: 0x000003b5
     580:	cd178e04 	ldcgt	14, cr8, [r7, #-16]
     584:	24000001 	strcs	r0, [r0], #-1
     588:	0008970d 	andeq	r9, r8, sp, lsl #14
     58c:	178f0400 	strne	r0, [pc, r0, lsl #8]
     590:	000001cd 	andeq	r0, r0, sp, asr #3
     594:	07dc0d48 	ldrbeq	r0, [ip, r8, asr #26]
     598:	90040000 	andls	r0, r4, r0
     59c:	0001cd17 	andeq	ip, r1, r7, lsl sp
     5a0:	4e126c00 	cdpmi	12, 1, cr6, cr2, cr0, {0}
     5a4:	04000006 	streq	r0, [r0], #-6
     5a8:	0b540993 	bleq	1502bfc <__bss_end+0x14f9754>
     5ac:	03670000 	cmneq	r7, #0
     5b0:	e7010000 	str	r0, [r1, -r0]
     5b4:	ed000002 	stc	0, cr0, [r0, #-8]
     5b8:	0f000002 	svceq	0x00000002
     5bc:	00000367 	andeq	r0, r0, r7, ror #6
     5c0:	04901300 	ldreq	r1, [r0], #768	; 0x300
     5c4:	96040000 	strls	r0, [r4], -r0
     5c8:	000cb70e 	andeq	fp, ip, lr, lsl #14
     5cc:	03020100 	movweq	r0, #8448	; 0x2100
     5d0:	03080000 	movweq	r0, #32768	; 0x8000
     5d4:	670f0000 	strvs	r0, [pc, -r0]
     5d8:	00000003 	andeq	r0, r0, r3
     5dc:	0007ed14 	andeq	lr, r7, r4, lsl sp
     5e0:	10990400 	addsne	r0, r9, r0, lsl #8
     5e4:	00000785 	andeq	r0, r0, r5, lsl #15
     5e8:	0000036d 	andeq	r0, r0, sp, ror #6
     5ec:	00031d01 	andeq	r1, r3, r1, lsl #26
     5f0:	03670f00 	cmneq	r7, #0, 30
     5f4:	4b100000 	blmi	4005fc <__bss_end+0x3f7154>
     5f8:	10000003 	andne	r0, r0, r3
     5fc:	00000196 	muleq	r0, r6, r1
     600:	25150000 	ldrcs	r0, [r5, #-0]
     604:	3e000000 	cdpcc	0, 0, cr0, cr0, cr0, {0}
     608:	16000003 	strne	r0, [r0], -r3
     60c:	0000005e 	andeq	r0, r0, lr, asr r0
     610:	0102000f 	tsteq	r2, pc
     614:	00059902 	andeq	r9, r5, r2, lsl #18
     618:	cd041700 	stcgt	7, cr1, [r4, #-0]
     61c:	17000001 	strne	r0, [r0, -r1]
     620:	00002c04 	andeq	r2, r0, r4, lsl #24
     624:	0bcd0b00 	bleq	ff34322c <__bss_end+0xff339d84>
     628:	04170000 	ldreq	r0, [r7], #-0
     62c:	00000351 	andeq	r0, r0, r1, asr r3
     630:	00027d15 	andeq	r7, r2, r5, lsl sp
     634:	00036700 	andeq	r6, r3, r0, lsl #14
     638:	17001800 	strne	r1, [r0, -r0, lsl #16]
     63c:	0001c004 	andeq	ip, r1, r4
     640:	bb041700 	bllt	106248 <__bss_end+0xfcda0>
     644:	19000001 	stmdbne	r0, {r0}
     648:	00000583 	andeq	r0, r0, r3, lsl #11
     64c:	c0149c04 	andsgt	r9, r4, r4, lsl #24
     650:	0a000001 	beq	65c <shift+0x65c>
     654:	00000477 	andeq	r0, r0, r7, ror r4
     658:	59140405 	ldmdbpl	r4, {r0, r2, sl}
     65c:	05000000 	streq	r0, [r0, #-0]
     660:	00943c03 	addseq	r3, r4, r3, lsl #24
     664:	05780a00 	ldrbeq	r0, [r8, #-2560]!	; 0xfffff600
     668:	07050000 	streq	r0, [r5, -r0]
     66c:	00005914 	andeq	r5, r0, r4, lsl r9
     670:	40030500 	andmi	r0, r3, r0, lsl #10
     674:	0a000094 	beq	8cc <shift+0x8cc>
     678:	00000b41 	andeq	r0, r0, r1, asr #22
     67c:	59140a05 	ldmdbpl	r4, {r0, r2, r9, fp}
     680:	05000000 	streq	r0, [r0, #-0]
     684:	00944403 	addseq	r4, r4, r3, lsl #8
     688:	03fb0800 	mvnseq	r0, #0, 16
     68c:	04050000 	streq	r0, [r5], #-0
     690:	00000038 	andeq	r0, r0, r8, lsr r0
     694:	ec0c0d05 	stc	13, cr0, [ip], {5}
     698:	1a000003 	bne	6ac <shift+0x6ac>
     69c:	0077654e 	rsbseq	r6, r7, lr, asr #10
     6a0:	090f0900 	stmdbeq	pc, {r8, fp}	; <UNPREDICTABLE>
     6a4:	09010000 	stmdbeq	r1, {}	; <UNPREDICTABLE>
     6a8:	00000bac 	andeq	r0, r0, ip, lsr #23
     6ac:	08ab0902 	stmiaeq	fp!, {r1, r8, fp}
     6b0:	09030000 	stmdbeq	r3, {}	; <UNPREDICTABLE>
     6b4:	00000663 	andeq	r0, r0, r3, ror #12
     6b8:	070e0904 	streq	r0, [lr, -r4, lsl #18]
     6bc:	00050000 	andeq	r0, r5, r0
     6c0:	0003ee06 	andeq	lr, r3, r6, lsl #28
     6c4:	1b051000 	blne	1446cc <__bss_end+0x13b224>
     6c8:	00042b08 	andeq	r2, r4, r8, lsl #22
     6cc:	726c0700 	rsbvc	r0, ip, #0, 14
     6d0:	131d0500 	tstne	sp, #0, 10
     6d4:	0000042b 	andeq	r0, r0, fp, lsr #8
     6d8:	70730700 	rsbsvc	r0, r3, r0, lsl #14
     6dc:	131e0500 	tstne	lr, #0, 10
     6e0:	0000042b 	andeq	r0, r0, fp, lsr #8
     6e4:	63700704 	cmnvs	r0, #4, 14	; 0x100000
     6e8:	131f0500 	tstne	pc, #0, 10
     6ec:	0000042b 	andeq	r0, r0, fp, lsr #8
     6f0:	07d60d08 	ldrbeq	r0, [r6, r8, lsl #26]
     6f4:	20050000 	andcs	r0, r5, r0
     6f8:	00042b13 	andeq	r2, r4, r3, lsl fp
     6fc:	02000c00 	andeq	r0, r0, #0, 24
     700:	179f0704 	ldrne	r0, [pc, r4, lsl #14]
     704:	aa060000 	bge	18070c <__bss_end+0x177264>
     708:	8000000c 	andhi	r0, r0, ip
     70c:	f5082805 			; <UNDEFINED> instruction: 0xf5082805
     710:	0d000004 	stceq	0, cr0, [r0, #-16]
     714:	000005d5 	ldrdeq	r0, [r0], -r5
     718:	ec122a05 			; <UNDEFINED> instruction: 0xec122a05
     71c:	00000003 	andeq	r0, r0, r3
     720:	64697007 	strbtvs	r7, [r9], #-7
     724:	122b0500 	eorne	r0, fp, #0, 10
     728:	0000005e 	andeq	r0, r0, lr, asr r0
     72c:	14f00d10 	ldrbtne	r0, [r0], #3344	; 0xd10
     730:	2c050000 	stccs	0, cr0, [r5], {-0}
     734:	0003b511 	andeq	fp, r3, r1, lsl r5
     738:	300d1400 	andcc	r1, sp, r0, lsl #8
     73c:	0500000c 	streq	r0, [r0, #-12]
     740:	005e122d 	subseq	r1, lr, sp, lsr #4
     744:	0d180000 	ldceq	0, cr0, [r8, #-0]
     748:	000005f9 	strdeq	r0, [r0], -r9
     74c:	5e122e05 	cdppl	14, 1, cr2, cr2, cr5, {0}
     750:	1c000000 	stcne	0, cr0, [r0], {-0}
     754:	0003970d 	andeq	r9, r3, sp, lsl #14
     758:	0c2f0500 	cfstr32eq	mvfx0, [pc], #-0	; 760 <shift+0x760>
     75c:	000004f5 	strdeq	r0, [r0], -r5
     760:	06440d20 	strbeq	r0, [r4], -r0, lsr #26
     764:	30050000 	andcc	r0, r5, r0
     768:	00003809 	andeq	r3, r0, r9, lsl #16
     76c:	e20d6000 	and	r6, sp, #0
     770:	05000003 	streq	r0, [r0, #-3]
     774:	004d0e31 	subeq	r0, sp, r1, lsr lr
     778:	0d640000 	stcleq	0, cr0, [r4, #-0]
     77c:	000003d9 	ldrdeq	r0, [r0], -r9
     780:	4d0e3305 	stcmi	3, cr3, [lr, #-20]	; 0xffffffec
     784:	68000000 	stmdavs	r0, {}	; <UNPREDICTABLE>
     788:	0003d00d 	andeq	sp, r3, sp
     78c:	0e340500 	cfabs32eq	mvfx0, mvfx4
     790:	0000004d 	andeq	r0, r0, sp, asr #32
     794:	7470076c 	ldrbtvc	r0, [r0], #-1900	; 0xfffff894
     798:	0c360500 	cfldr32eq	mvfx0, [r6], #-0
     79c:	00000505 	andeq	r0, r0, r5, lsl #10
     7a0:	06770d70 			; <UNDEFINED> instruction: 0x06770d70
     7a4:	37050000 	strcc	r0, [r5, -r0]
     7a8:	00004d0e 	andeq	r4, r0, lr, lsl #26
     7ac:	ad0d7400 	cfstrsge	mvf7, [sp, #-0]
     7b0:	05000005 	streq	r0, [r0, #-5]
     7b4:	004d0e38 	subeq	r0, sp, r8, lsr lr
     7b8:	0d780000 	ldcleq	0, cr0, [r8, #-0]
     7bc:	000003bf 			; <UNDEFINED> instruction: 0x000003bf
     7c0:	4d0e3905 	vstrmi.16	s6, [lr, #-10]	; <UNPREDICTABLE>
     7c4:	7c000000 	stcvc	0, cr0, [r0], {-0}
     7c8:	036d1500 	cmneq	sp, #0, 10
     7cc:	05050000 	streq	r0, [r5, #-0]
     7d0:	5e160000 	cdppl	0, 1, cr0, cr6, cr0, {0}
     7d4:	0f000000 	svceq	0x00000000
     7d8:	4d041700 	stcmi	7, cr1, [r4, #-0]
     7dc:	0a000000 	beq	7e4 <shift+0x7e4>
     7e0:	0000053c 	andeq	r0, r0, ip, lsr r5
     7e4:	59140a06 	ldmdbpl	r4, {r1, r2, r9, fp}
     7e8:	05000000 	streq	r0, [r0, #-0]
     7ec:	00944803 	addseq	r4, r4, r3, lsl #16
     7f0:	09760800 	ldmdbeq	r6!, {fp}^
     7f4:	04050000 	streq	r0, [r5], #-0
     7f8:	00000038 	andeq	r0, r0, r8, lsr r0
     7fc:	3c0c0d06 	stccc	13, cr0, [ip], {6}
     800:	09000005 	stmdbeq	r0, {r0, r2}
     804:	00000be5 	andeq	r0, r0, r5, ror #23
     808:	054b0900 	strbeq	r0, [fp, #-2304]	; 0xfffff700
     80c:	00010000 	andeq	r0, r1, r0
     810:	000c1d06 	andeq	r1, ip, r6, lsl #26
     814:	1b060c00 	blne	18381c <__bss_end+0x17a374>
     818:	00057108 	andeq	r7, r5, r8, lsl #2
     81c:	0be00d00 	bleq	ff803c24 <__bss_end+0xff7fa77c>
     820:	1d060000 	stcne	0, cr0, [r6, #-0]
     824:	00057119 	andeq	r7, r5, r9, lsl r1
     828:	560d0000 	strpl	r0, [sp], -r0
     82c:	0600000c 	streq	r0, [r0], -ip
     830:	0571191e 	ldrbeq	r1, [r1, #-2334]!	; 0xfffff6e2
     834:	0d040000 	stceq	0, cr0, [r4, #-0]
     838:	000007d1 	ldrdeq	r0, [r0], -r1
     83c:	77131f06 	ldrvc	r1, [r3, -r6, lsl #30]
     840:	08000005 	stmdaeq	r0, {r0, r2}
     844:	3c041700 	stccc	7, cr1, [r4], {-0}
     848:	17000005 	strne	r0, [r0, -r5]
     84c:	00043204 	andeq	r3, r4, r4, lsl #4
     850:	0ae60c00 	beq	ff983858 <__bss_end+0xff97a3b0>
     854:	06140000 	ldreq	r0, [r4], -r0
     858:	08330722 	ldmdaeq	r3!, {r1, r5, r8, r9, sl}
     85c:	9e0d0000 	cdpls	0, 0, cr0, cr13, cr0, {0}
     860:	06000005 	streq	r0, [r0], -r5
     864:	004d1226 	subeq	r1, sp, r6, lsr #4
     868:	0d000000 	stceq	0, cr0, [r0, #-0]
     86c:	00000825 	andeq	r0, r0, r5, lsr #16
     870:	711d2906 	tstvc	sp, r6, lsl #18
     874:	04000005 	streq	r0, [r0], #-5
     878:	0009b20d 	andeq	fp, r9, sp, lsl #4
     87c:	1d2c0600 	stcne	6, cr0, [ip, #-0]
     880:	00000571 	andeq	r0, r0, r1, ror r5
     884:	058f1b08 	streq	r1, [pc, #2824]	; 1394 <shift+0x1394>
     888:	2f060000 	svccs	0x00060000
     88c:	000bfa0e 	andeq	pc, fp, lr, lsl #20
     890:	0005c500 	andeq	ip, r5, r0, lsl #10
     894:	0005d000 	andeq	sp, r5, r0
     898:	08380f00 	ldmdaeq	r8!, {r8, r9, sl, fp}
     89c:	71100000 	tstvc	r0, r0
     8a0:	00000005 	andeq	r0, r0, r5
     8a4:	0008881c 	andeq	r8, r8, ip, lsl r8
     8a8:	0e310600 	cfmsuba32eq	mvax0, mvax0, mvfx1, mvfx0
     8ac:	00000c81 	andeq	r0, r0, r1, lsl #25
     8b0:	0000033e 	andeq	r0, r0, lr, lsr r3
     8b4:	000005e8 	andeq	r0, r0, r8, ror #11
     8b8:	000005f3 	strdeq	r0, [r0], -r3
     8bc:	0008380f 	andeq	r3, r8, pc, lsl #16
     8c0:	05771000 	ldrbeq	r1, [r7, #-0]!
     8c4:	12000000 	andne	r0, r0, #0
     8c8:	00000702 	andeq	r0, r0, r2, lsl #14
     8cc:	ea1d3506 	b	74dcec <__bss_end+0x744844>
     8d0:	71000008 	tstvc	r0, r8
     8d4:	02000005 	andeq	r0, r0, #5
     8d8:	0000060c 	andeq	r0, r0, ip, lsl #12
     8dc:	00000612 	andeq	r0, r0, r2, lsl r6
     8e0:	0008380f 	andeq	r3, r8, pc, lsl #16
     8e4:	3e120000 	cdpcc	0, 1, cr0, cr2, cr0, {0}
     8e8:	0600000c 	streq	r0, [r0], -ip
     8ec:	0c5b1d37 	mrrceq	13, 3, r1, fp, cr7
     8f0:	05710000 	ldrbeq	r0, [r1, #-0]!
     8f4:	2b020000 	blcs	808fc <__bss_end+0x77454>
     8f8:	31000006 	tstcc	r0, r6
     8fc:	0f000006 	svceq	0x00000006
     900:	00000838 	andeq	r0, r0, r8, lsr r8
     904:	09261d00 	stmdbeq	r6!, {r8, sl, fp, ip}
     908:	39060000 	stmdbcc	r6, {}	; <UNPREDICTABLE>
     90c:	00085131 	andeq	r5, r8, r1, lsr r1
     910:	12020c00 	andne	r0, r2, #0, 24
     914:	00000ae6 	andeq	r0, r0, r6, ror #21
     918:	bd093c06 	stclt	12, cr3, [r9, #-24]	; 0xffffffe8
     91c:	38000008 	stmdacc	r0, {r3}
     920:	01000008 	tsteq	r0, r8
     924:	00000658 	andeq	r0, r0, r8, asr r6
     928:	0000065e 	andeq	r0, r0, lr, asr r6
     92c:	0008380f 	andeq	r3, r8, pc, lsl #16
     930:	e1120000 	tst	r2, r0
     934:	06000005 	streq	r0, [r0], -r5
     938:	0681123f 			; <UNDEFINED> instruction: 0x0681123f
     93c:	004d0000 	subeq	r0, sp, r0
     940:	77010000 	strvc	r0, [r1, -r0]
     944:	8c000006 	stchi	0, cr0, [r0], {6}
     948:	0f000006 	svceq	0x00000006
     94c:	00000838 	andeq	r0, r0, r8, lsr r8
     950:	00085a10 	andeq	r5, r8, r0, lsl sl
     954:	005e1000 	subseq	r1, lr, r0
     958:	3e100000 	cdpcc	0, 1, cr0, cr0, cr0, {0}
     95c:	00000003 	andeq	r0, r0, r3
     960:	000a7913 	andeq	r7, sl, r3, lsl r9
     964:	0e420600 	cdpeq	6, 4, cr0, cr2, cr0, {0}
     968:	000004f3 	strdeq	r0, [r0], -r3
     96c:	0006a101 	andeq	sl, r6, r1, lsl #2
     970:	0006a700 	andeq	sl, r6, r0, lsl #14
     974:	08380f00 	ldmdaeq	r8!, {r8, r9, sl, fp}
     978:	12000000 	andne	r0, r0, #0
     97c:	0000074c 	andeq	r0, r0, ip, asr #14
     980:	49174506 	ldmdbmi	r7, {r1, r2, r8, sl, lr}
     984:	77000004 	strvc	r0, [r0, -r4]
     988:	01000005 	tsteq	r0, r5
     98c:	000006c0 	andeq	r0, r0, r0, asr #13
     990:	000006c6 	andeq	r0, r0, r6, asr #13
     994:	0008600f 	andeq	r6, r8, pc
     998:	8b120000 	blhi	4809a0 <__bss_end+0x4774f8>
     99c:	06000009 	streq	r0, [r0], -r9
     9a0:	04c61748 	strbeq	r1, [r6], #1864	; 0x748
     9a4:	05770000 	ldrbeq	r0, [r7, #-0]!
     9a8:	df010000 	svcle	0x00010000
     9ac:	ea000006 	b	9cc <shift+0x9cc>
     9b0:	0f000006 	svceq	0x00000006
     9b4:	00000860 	andeq	r0, r0, r0, ror #16
     9b8:	00004d10 	andeq	r4, r0, r0, lsl sp
     9bc:	b0130000 	andslt	r0, r3, r0
     9c0:	06000007 	streq	r0, [r0], -r7
     9c4:	09340e4b 	ldmdbeq	r4!, {r0, r1, r3, r6, r9, sl, fp}
     9c8:	ff010000 			; <UNDEFINED> instruction: 0xff010000
     9cc:	05000006 	streq	r0, [r0, #-6]
     9d0:	0f000007 	svceq	0x00000007
     9d4:	00000838 	andeq	r0, r0, r8, lsr r8
     9d8:	08881200 	stmeq	r8, {r9, ip}
     9dc:	4d060000 	stcmi	0, cr0, [r6, #-0]
     9e0:	0005140e 	andeq	r1, r5, lr, lsl #8
     9e4:	00033e00 	andeq	r3, r3, r0, lsl #28
     9e8:	071e0100 	ldreq	r0, [lr, -r0, lsl #2]
     9ec:	07290000 	streq	r0, [r9, -r0]!
     9f0:	380f0000 	stmdacc	pc, {}	; <UNPREDICTABLE>
     9f4:	10000008 	andne	r0, r0, r8
     9f8:	0000004d 	andeq	r0, r0, sp, asr #32
     9fc:	099e1200 	ldmibeq	lr, {r9, ip}
     a00:	50060000 	andpl	r0, r6, r0
     a04:	0007f212 	andeq	pc, r7, r2, lsl r2	; <UNPREDICTABLE>
     a08:	00004d00 	andeq	r4, r0, r0, lsl #26
     a0c:	07420100 	strbeq	r0, [r2, -r0, lsl #2]
     a10:	074d0000 	strbeq	r0, [sp, -r0]
     a14:	380f0000 	stmdacc	pc, {}	; <UNPREDICTABLE>
     a18:	10000008 	andne	r0, r0, r8
     a1c:	0000036d 	andeq	r0, r0, sp, ror #6
     a20:	06ac1200 	strteq	r1, [ip], r0, lsl #4
     a24:	53060000 	movwpl	r0, #24576	; 0x6000
     a28:	0006d60e 	andeq	sp, r6, lr, lsl #12
     a2c:	00033e00 	andeq	r3, r3, r0, lsl #28
     a30:	07660100 	strbeq	r0, [r6, -r0, lsl #2]!
     a34:	07710000 	ldrbeq	r0, [r1, -r0]!
     a38:	380f0000 	stmdacc	pc, {}	; <UNPREDICTABLE>
     a3c:	10000008 	andne	r0, r0, r8
     a40:	0000004d 	andeq	r0, r0, sp, asr #32
     a44:	09631300 	stmdbeq	r3!, {r8, r9, ip}^
     a48:	56060000 	strpl	r0, [r6], -r0
     a4c:	000a210e 	andeq	r2, sl, lr, lsl #2
     a50:	07860100 	streq	r0, [r6, r0, lsl #2]
     a54:	07a50000 	streq	r0, [r5, r0]!
     a58:	380f0000 	stmdacc	pc, {}	; <UNPREDICTABLE>
     a5c:	10000008 	andne	r0, r0, r8
     a60:	0000008b 	andeq	r0, r0, fp, lsl #1
     a64:	00004d10 	andeq	r4, r0, r0, lsl sp
     a68:	004d1000 	subeq	r1, sp, r0
     a6c:	4d100000 	ldcmi	0, cr0, [r0, #-0]
     a70:	10000000 	andne	r0, r0, r0
     a74:	00000866 	andeq	r0, r0, r6, ror #16
     a78:	05bf1300 	ldreq	r1, [pc, #768]!	; d80 <shift+0xd80>
     a7c:	58060000 	stmdapl	r6, {}	; <UNPREDICTABLE>
     a80:	000a820e 	andeq	r8, sl, lr, lsl #4
     a84:	07ba0100 	ldreq	r0, [sl, r0, lsl #2]!
     a88:	07d90000 	ldrbeq	r0, [r9, r0]
     a8c:	380f0000 	stmdacc	pc, {}	; <UNPREDICTABLE>
     a90:	10000008 	andne	r0, r0, r8
     a94:	000000c2 	andeq	r0, r0, r2, asr #1
     a98:	00004d10 	andeq	r4, r0, r0, lsl sp
     a9c:	004d1000 	subeq	r1, sp, r0
     aa0:	4d100000 	ldcmi	0, cr0, [r0, #-0]
     aa4:	10000000 	andne	r0, r0, r0
     aa8:	00000866 	andeq	r0, r0, r6, ror #16
     aac:	06bf1300 	ldrteq	r1, [pc], r0, lsl #6
     ab0:	5b060000 	blpl	180ab8 <__bss_end+0x177610>
     ab4:	0009cb0e 	andeq	ip, r9, lr, lsl #22
     ab8:	07ee0100 	strbeq	r0, [lr, r0, lsl #2]!
     abc:	080d0000 	stmdaeq	sp, {}	; <UNPREDICTABLE>
     ac0:	380f0000 	stmdacc	pc, {}	; <UNPREDICTABLE>
     ac4:	10000008 	andne	r0, r0, r8
     ac8:	000000ff 	strdeq	r0, [r0], -pc	; <UNPREDICTABLE>
     acc:	00004d10 	andeq	r4, r0, r0, lsl sp
     ad0:	004d1000 	subeq	r1, sp, r0
     ad4:	4d100000 	ldcmi	0, cr0, [r0, #-0]
     ad8:	10000000 	andne	r0, r0, r0
     adc:	00000866 	andeq	r0, r0, r6, ror #16
     ae0:	08d71400 	ldmeq	r7, {sl, ip}^
     ae4:	5e060000 	cdppl	0, 0, cr0, cr6, cr0, {0}
     ae8:	000b690e 	andeq	r6, fp, lr, lsl #18
     aec:	00033e00 	andeq	r3, r3, r0, lsl #28
     af0:	08220100 	stmdaeq	r2!, {r8}
     af4:	380f0000 	stmdacc	pc, {}	; <UNPREDICTABLE>
     af8:	10000008 	andne	r0, r0, r8
     afc:	0000051d 	andeq	r0, r0, sp, lsl r5
     b00:	00086c10 	andeq	r6, r8, r0, lsl ip
     b04:	03000000 	movweq	r0, #0
     b08:	0000057d 	andeq	r0, r0, sp, ror r5
     b0c:	057d0417 	ldrbeq	r0, [sp, #-1047]!	; 0xfffffbe9
     b10:	711e0000 	tstvc	lr, r0
     b14:	4b000005 	blmi	b30 <shift+0xb30>
     b18:	51000008 	tstpl	r0, r8
     b1c:	0f000008 	svceq	0x00000008
     b20:	00000838 	andeq	r0, r0, r8, lsr r8
     b24:	057d1f00 	ldrbeq	r1, [sp, #-3840]!	; 0xfffff100
     b28:	083e0000 	ldmdaeq	lr!, {}	; <UNPREDICTABLE>
     b2c:	04170000 	ldreq	r0, [r7], #-0
     b30:	0000003f 	andeq	r0, r0, pc, lsr r0
     b34:	08330417 	ldmdaeq	r3!, {r0, r1, r2, r4, sl}
     b38:	04200000 	strteq	r0, [r0], #-0
     b3c:	00000065 	andeq	r0, r0, r5, rrx
     b40:	6b190421 	blvs	641bcc <__bss_end+0x638724>
     b44:	06000007 	streq	r0, [r0], -r7
     b48:	057d1961 	ldrbeq	r1, [sp, #-2401]!	; 0xfffff69f
     b4c:	a3220000 			; <UNDEFINED> instruction: 0xa3220000
     b50:	01000004 	tsteq	r0, r4
     b54:	00380505 	eorseq	r0, r8, r5, lsl #10
     b58:	822c0000 	eorhi	r0, ip, #0
     b5c:	00480000 	subeq	r0, r8, r0
     b60:	9c010000 	stcls	0, cr0, [r1], {-0}
     b64:	000008b3 			; <UNDEFINED> instruction: 0x000008b3
     b68:	0005a823 	andeq	sl, r5, r3, lsr #16
     b6c:	0e050100 	adfeqs	f0, f5, f0
     b70:	00000038 	andeq	r0, r0, r8, lsr r0
     b74:	23749102 	cmncs	r4, #-2147483648	; 0x80000000
     b78:	000006d1 	ldrdeq	r0, [r0], -r1
     b7c:	b31b0501 	tstlt	fp, #4194304	; 0x400000
     b80:	02000008 	andeq	r0, r0, #8
     b84:	17007091 			; <UNDEFINED> instruction: 0x17007091
     b88:	0008b904 	andeq	fp, r8, r4, lsl #18
     b8c:	25041700 	strcs	r1, [r4, #-1792]	; 0xfffff900
     b90:	00000000 	andeq	r0, r0, r0
     b94:	00000d5d 	andeq	r0, r0, sp, asr sp
     b98:	03f70004 	mvnseq	r0, #4
     b9c:	01040000 	mrseq	r0, (UNDEF: 4)
     ba0:	00001027 	andeq	r1, r0, r7, lsr #32
     ba4:	000d4604 	andeq	r4, sp, r4, lsl #12
     ba8:	000e1700 	andeq	r1, lr, r0, lsl #14
     bac:	00827400 	addeq	r7, r2, r0, lsl #8
     bb0:	00045c00 	andeq	r5, r4, r0, lsl #24
     bb4:	00037b00 	andeq	r7, r3, r0, lsl #22
     bb8:	08010200 	stmdaeq	r1, {r9}
     bbc:	00000737 	andeq	r0, r0, r7, lsr r7
     bc0:	00002503 	andeq	r2, r0, r3, lsl #10
     bc4:	05020200 	streq	r0, [r2, #-512]	; 0xfffffe00
     bc8:	0000042a 	andeq	r0, r0, sl, lsr #8
     bcc:	69050404 	stmdbvs	r5, {r2, sl}
     bd0:	0200746e 	andeq	r7, r0, #1845493760	; 0x6e000000
     bd4:	072e0801 	streq	r0, [lr, -r1, lsl #16]!
     bd8:	02020000 	andeq	r0, r2, #0
     bdc:	00087507 	andeq	r7, r8, r7, lsl #10
     be0:	077c0500 	ldrbeq	r0, [ip, -r0, lsl #10]!
     be4:	09070000 	stmdbeq	r7, {}	; <UNPREDICTABLE>
     be8:	00005e07 	andeq	r5, r0, r7, lsl #28
     bec:	004d0300 	subeq	r0, sp, r0, lsl #6
     bf0:	04020000 	streq	r0, [r2], #-0
     bf4:	0017a407 	andseq	sl, r7, r7, lsl #8
     bf8:	0ace0600 	beq	ff382400 <__bss_end+0xff378f58>
     bfc:	02080000 	andeq	r0, r8, #0
     c00:	008b0806 	addeq	r0, fp, r6, lsl #16
     c04:	72070000 	andvc	r0, r7, #0
     c08:	08020030 	stmdaeq	r2, {r4, r5}
     c0c:	00004d0e 	andeq	r4, r0, lr, lsl #26
     c10:	72070000 	andvc	r0, r7, #0
     c14:	09020031 	stmdbeq	r2, {r0, r4, r5}
     c18:	00004d0e 	andeq	r4, r0, lr, lsl #26
     c1c:	08000400 	stmdaeq	r0, {sl}
     c20:	00000f5d 	andeq	r0, r0, sp, asr pc
     c24:	00380405 	eorseq	r0, r8, r5, lsl #8
     c28:	0d020000 	stceq	0, cr0, [r2, #-0]
     c2c:	0000a90c 	andeq	sl, r0, ip, lsl #18
     c30:	4b4f0900 	blmi	13c3038 <__bss_end+0x13b9b90>
     c34:	7d0a0000 	stcvc	0, cr0, [sl, #-0]
     c38:	0100000d 	tsteq	r0, sp
     c3c:	04340800 	ldrteq	r0, [r4], #-2048	; 0xfffff800
     c40:	04050000 	streq	r0, [r5], #-0
     c44:	00000038 	andeq	r0, r0, r8, lsr r0
     c48:	e00c1f02 	and	r1, ip, r2, lsl #30
     c4c:	0a000000 	beq	c54 <shift+0xc54>
     c50:	0000049b 	muleq	r0, fp, r4
     c54:	0bc30a00 	bleq	ff0c345c <__bss_end+0xff0b9fb4>
     c58:	0a010000 	beq	40c60 <__bss_end+0x377b8>
     c5c:	000003a4 	andeq	r0, r0, r4, lsr #7
     c60:	06710a02 	ldrbteq	r0, [r1], -r2, lsl #20
     c64:	0a030000 	beq	c0c6c <__bss_end+0xb77c4>
     c68:	00000bb4 			; <UNDEFINED> instruction: 0x00000bb4
     c6c:	05f00a04 	ldrbeq	r0, [r0, #2564]!	; 0xa04
     c70:	00050000 	andeq	r0, r5, r0
     c74:	00040708 	andeq	r0, r4, r8, lsl #14
     c78:	38040500 	stmdacc	r4, {r8, sl}
     c7c:	02000000 	andeq	r0, r0, #0
     c80:	011d0c40 	tsteq	sp, r0, asr #24
     c84:	ed0a0000 	stc	0, cr0, [sl, #-0]
     c88:	00000007 	andeq	r0, r0, r7
     c8c:	0007770a 	andeq	r7, r7, sl, lsl #14
     c90:	650a0100 	strvs	r0, [sl, #-256]	; 0xffffff00
     c94:	02000007 	andeq	r0, r0, #7
     c98:	000a730a 	andeq	r7, sl, sl, lsl #6
     c9c:	c50a0300 	strgt	r0, [sl, #-768]	; 0xfffffd00
     ca0:	04000009 	streq	r0, [r0], #-9
     ca4:	000af70a 	andeq	pc, sl, sl, lsl #14
     ca8:	290a0500 	stmdbcs	sl, {r8, sl}
     cac:	06000007 	streq	r0, [r0], -r7
     cb0:	0fcc0800 	svceq	0x00cc0800
     cb4:	04050000 	streq	r0, [r5], #-0
     cb8:	00000038 	andeq	r0, r0, r8, lsr r0
     cbc:	480c6702 	stmdami	ip, {r1, r8, r9, sl, sp, lr}
     cc0:	0a000001 	beq	ccc <shift+0xccc>
     cc4:	00000efd 	strdeq	r0, [r0], -sp
     cc8:	0dda0a00 	vldreq	s1, [sl]
     ccc:	0a010000 	beq	40cd4 <__bss_end+0x3782c>
     cd0:	00000f26 	andeq	r0, r0, r6, lsr #30
     cd4:	0dff0a02 			; <UNDEFINED> instruction: 0x0dff0a02
     cd8:	00030000 	andeq	r0, r3, r0
     cdc:	00071508 	andeq	r1, r7, r8, lsl #10
     ce0:	38040500 	stmdacc	r4, {r8, sl}
     ce4:	02000000 	andeq	r0, r0, #0
     ce8:	01610c6f 	cmneq	r1, pc, ror #24
     cec:	3c0a0000 	stccc	0, cr0, [sl], {-0}
     cf0:	00000007 	andeq	r0, r0, r7
     cf4:	06160b00 	ldreq	r0, [r6], -r0, lsl #22
     cf8:	05030000 	streq	r0, [r3, #-0]
     cfc:	00005914 	andeq	r5, r0, r4, lsl r9
     d00:	4c030500 	cfstr32mi	mvfx0, [r3], {-0}
     d04:	0b000094 	bleq	f5c <shift+0xf5c>
     d08:	00000ada 	ldrdeq	r0, [r0], -sl
     d0c:	59140603 	ldmdbpl	r4, {r0, r1, r9, sl}
     d10:	05000000 	streq	r0, [r0, #-0]
     d14:	00945003 	addseq	r5, r4, r3
     d18:	05620b00 	strbeq	r0, [r2, #-2816]!	; 0xfffff500
     d1c:	07040000 	streq	r0, [r4, -r0]
     d20:	0000591a 	andeq	r5, r0, sl, lsl r9
     d24:	54030500 	strpl	r0, [r3], #-1280	; 0xfffffb00
     d28:	0b000094 	bleq	f80 <shift+0xf80>
     d2c:	00000632 	andeq	r0, r0, r2, lsr r6
     d30:	591a0904 	ldmdbpl	sl, {r2, r8, fp}
     d34:	05000000 	streq	r0, [r0, #-0]
     d38:	00945803 	addseq	r5, r4, r3, lsl #16
     d3c:	09180b00 	ldmdbeq	r8, {r8, r9, fp}
     d40:	0b040000 	bleq	100d48 <__bss_end+0xf78a0>
     d44:	0000591a 	andeq	r5, r0, sl, lsl r9
     d48:	5c030500 	cfstr32pl	mvfx0, [r3], {-0}
     d4c:	0b000094 	bleq	fa4 <shift+0xfa4>
     d50:	00000afe 	strdeq	r0, [r0], -lr
     d54:	591a0d04 	ldmdbpl	sl, {r2, r8, sl, fp}
     d58:	05000000 	streq	r0, [r0, #-0]
     d5c:	00946003 	addseq	r6, r4, r3
     d60:	08a10b00 	stmiaeq	r1!, {r8, r9, fp}
     d64:	0f040000 	svceq	0x00040000
     d68:	0000591a 	andeq	r5, r0, sl, lsl r9
     d6c:	64030500 	strvs	r0, [r3], #-1280	; 0xfffffb00
     d70:	08000094 	stmdaeq	r0, {r2, r4, r7}
     d74:	000007a0 	andeq	r0, r0, r0, lsr #15
     d78:	00380405 	eorseq	r0, r8, r5, lsl #8
     d7c:	1b040000 	blne	100d84 <__bss_end+0xf78dc>
     d80:	0002040c 	andeq	r0, r2, ip, lsl #8
     d84:	08b30a00 	ldmeq	r3!, {r9, fp}
     d88:	0a000000 	beq	d90 <shift+0xd90>
     d8c:	00000c4b 	andeq	r0, r0, fp, asr #24
     d90:	07600a01 	strbeq	r0, [r0, -r1, lsl #20]!
     d94:	00020000 	andeq	r0, r2, r0
     d98:	00081f0c 	andeq	r1, r8, ip, lsl #30
     d9c:	064e0d00 	strbeq	r0, [lr], -r0, lsl #26
     da0:	04900000 	ldreq	r0, [r0], #0
     da4:	03770763 	cmneq	r7, #25952256	; 0x18c0000
     da8:	24060000 	strcs	r0, [r6], #-0
     dac:	24000006 	strcs	r0, [r0], #-6
     db0:	91106704 	tstls	r0, r4, lsl #14
     db4:	0e000002 	cdpeq	0, 0, cr0, cr0, cr2, {0}
     db8:	00001b14 	andeq	r1, r0, r4, lsl fp
     dbc:	77126904 	ldrvc	r6, [r2, -r4, lsl #18]
     dc0:	00000003 	andeq	r0, r0, r3
     dc4:	0005560e 	andeq	r5, r5, lr, lsl #12
     dc8:	126b0400 	rsbne	r0, fp, #0, 8
     dcc:	00000387 	andeq	r0, r0, r7, lsl #7
     dd0:	03aa0e10 			; <UNDEFINED> instruction: 0x03aa0e10
     dd4:	6d040000 	stcvs	0, cr0, [r4, #-0]
     dd8:	00004d16 	andeq	r4, r0, r6, lsl sp
     ddc:	0f0e1400 	svceq	0x000e1400
     de0:	04000006 	streq	r0, [r0], #-6
     de4:	038e1c70 	orreq	r1, lr, #112, 24	; 0x7000
     de8:	0e180000 	cdpeq	0, 1, cr0, cr8, cr0, {0}
     dec:	0000065a 	andeq	r0, r0, sl, asr r6
     df0:	8e1c7204 	cdphi	2, 1, cr7, cr12, cr4, {0}
     df4:	1c000003 	stcne	0, cr0, [r0], {3}
     df8:	000c560e 	andeq	r5, ip, lr, lsl #12
     dfc:	1c750400 	cfldrdne	mvd0, [r5], #-0
     e00:	0000038e 	andeq	r0, r0, lr, lsl #7
     e04:	07c60f20 	strbeq	r0, [r6, r0, lsr #30]
     e08:	77040000 	strvc	r0, [r4, -r0]
     e0c:	000b111c 	andeq	r1, fp, ip, lsl r1
     e10:	00038e00 	andeq	r8, r3, r0, lsl #28
     e14:	00028500 	andeq	r8, r2, r0, lsl #10
     e18:	038e1000 	orreq	r1, lr, #0
     e1c:	94110000 	ldrls	r0, [r1], #-0
     e20:	00000003 	andeq	r0, r0, r3
     e24:	07410600 	strbeq	r0, [r1, -r0, lsl #12]
     e28:	04180000 	ldreq	r0, [r8], #-0
     e2c:	02c6107b 	sbceq	r1, r6, #123	; 0x7b
     e30:	140e0000 	strne	r0, [lr], #-0
     e34:	0400001b 	streq	r0, [r0], #-27	; 0xffffffe5
     e38:	0377127e 	cmneq	r7, #-536870905	; 0xe0000007
     e3c:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     e40:	0000041f 	andeq	r0, r0, pc, lsl r4
     e44:	94198004 	ldrls	r8, [r9], #-4
     e48:	10000003 	andne	r0, r0, r3
     e4c:	0007e60e 	andeq	lr, r7, lr, lsl #12
     e50:	21820400 	orrcs	r0, r2, r0, lsl #8
     e54:	0000039f 	muleq	r0, pc, r3	; <UNPREDICTABLE>
     e58:	91030014 	tstls	r3, r4, lsl r0
     e5c:	12000002 	andne	r0, r0, #2
     e60:	000004a8 	andeq	r0, r0, r8, lsr #9
     e64:	a5218604 	strge	r8, [r1, #-1540]!	; 0xfffff9fc
     e68:	12000003 	andne	r0, r0, #3
     e6c:	000004b4 			; <UNDEFINED> instruction: 0x000004b4
     e70:	591f8804 	ldmdbpl	pc, {r2, fp, pc}	; <UNPREDICTABLE>
     e74:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
     e78:	00000a1b 	andeq	r0, r0, fp, lsl sl
     e7c:	16178b04 	ldrne	r8, [r7], -r4, lsl #22
     e80:	00000002 	andeq	r0, r0, r2
     e84:	0003b50e 	andeq	fp, r3, lr, lsl #10
     e88:	178e0400 	strne	r0, [lr, r0, lsl #8]
     e8c:	00000216 	andeq	r0, r0, r6, lsl r2
     e90:	08970e24 	ldmeq	r7, {r2, r5, r9, sl, fp}
     e94:	8f040000 	svchi	0x00040000
     e98:	00021617 	andeq	r1, r2, r7, lsl r6
     e9c:	dc0e4800 	stcle	8, cr4, [lr], {-0}
     ea0:	04000007 	streq	r0, [r0], #-7
     ea4:	02161790 	andseq	r1, r6, #144, 14	; 0x2400000
     ea8:	136c0000 	cmnne	ip, #0
     eac:	0000064e 	andeq	r0, r0, lr, asr #12
     eb0:	54099304 	strpl	r9, [r9], #-772	; 0xfffffcfc
     eb4:	b000000b 	andlt	r0, r0, fp
     eb8:	01000003 	tsteq	r0, r3
     ebc:	00000330 	andeq	r0, r0, r0, lsr r3
     ec0:	00000336 	andeq	r0, r0, r6, lsr r3
     ec4:	0003b010 	andeq	fp, r3, r0, lsl r0
     ec8:	90140000 	andsls	r0, r4, r0
     ecc:	04000004 	streq	r0, [r0], #-4
     ed0:	0cb70e96 	ldceq	14, cr0, [r7], #600	; 0x258
     ed4:	4b010000 	blmi	40edc <__bss_end+0x37a34>
     ed8:	51000003 	tstpl	r0, r3
     edc:	10000003 	andne	r0, r0, r3
     ee0:	000003b0 			; <UNDEFINED> instruction: 0x000003b0
     ee4:	07ed1500 	strbeq	r1, [sp, r0, lsl #10]!
     ee8:	99040000 	stmdbls	r4, {}	; <UNPREDICTABLE>
     eec:	00078510 	andeq	r8, r7, r0, lsl r5
     ef0:	0003b600 	andeq	fp, r3, r0, lsl #12
     ef4:	03660100 	cmneq	r6, #0, 2
     ef8:	b0100000 	andslt	r0, r0, r0
     efc:	11000003 	tstne	r0, r3
     f00:	00000394 	muleq	r0, r4, r3
     f04:	0001df11 	andeq	sp, r1, r1, lsl pc
     f08:	16000000 	strne	r0, [r0], -r0
     f0c:	00000025 	andeq	r0, r0, r5, lsr #32
     f10:	00000387 	andeq	r0, r0, r7, lsl #7
     f14:	00005e17 	andeq	r5, r0, r7, lsl lr
     f18:	02000f00 	andeq	r0, r0, #0, 30
     f1c:	05990201 	ldreq	r0, [r9, #513]	; 0x201
     f20:	04180000 	ldreq	r0, [r8], #-0
     f24:	00000216 	andeq	r0, r0, r6, lsl r2
     f28:	002c0418 	eoreq	r0, ip, r8, lsl r4
     f2c:	cd0c0000 	stcgt	0, cr0, [ip, #-0]
     f30:	1800000b 	stmdane	r0, {r0, r1, r3}
     f34:	00039a04 	andeq	r9, r3, r4, lsl #20
     f38:	02c61600 	sbceq	r1, r6, #0, 12
     f3c:	03b00000 	movseq	r0, #0
     f40:	00190000 	andseq	r0, r9, r0
     f44:	02090418 	andeq	r0, r9, #24, 8	; 0x18000000
     f48:	04180000 	ldreq	r0, [r8], #-0
     f4c:	00000204 	andeq	r0, r0, r4, lsl #4
     f50:	0005831a 	andeq	r8, r5, sl, lsl r3
     f54:	149c0400 	ldrne	r0, [ip], #1024	; 0x400
     f58:	00000209 	andeq	r0, r0, r9, lsl #4
     f5c:	0004770b 	andeq	r7, r4, fp, lsl #14
     f60:	14040500 	strne	r0, [r4], #-1280	; 0xfffffb00
     f64:	00000059 	andeq	r0, r0, r9, asr r0
     f68:	94680305 	strbtls	r0, [r8], #-773	; 0xfffffcfb
     f6c:	780b0000 	stmdavc	fp, {}	; <UNPREDICTABLE>
     f70:	05000005 	streq	r0, [r0, #-5]
     f74:	00591407 	subseq	r1, r9, r7, lsl #8
     f78:	03050000 	movweq	r0, #20480	; 0x5000
     f7c:	0000946c 	andeq	r9, r0, ip, ror #8
     f80:	000b410b 	andeq	r4, fp, fp, lsl #2
     f84:	140a0500 	strne	r0, [sl], #-1280	; 0xfffffb00
     f88:	00000059 	andeq	r0, r0, r9, asr r0
     f8c:	94700305 	ldrbtls	r0, [r0], #-773	; 0xfffffcfb
     f90:	fb080000 	blx	200f9a <__bss_end+0x1f7af2>
     f94:	05000003 	streq	r0, [r0, #-3]
     f98:	00003804 	andeq	r3, r0, r4, lsl #16
     f9c:	0c0d0500 	cfstr32eq	mvfx0, [sp], {-0}
     fa0:	00000435 	andeq	r0, r0, r5, lsr r4
     fa4:	77654e09 	strbvc	r4, [r5, -r9, lsl #28]!
     fa8:	0f0a0000 	svceq	0x000a0000
     fac:	01000009 	tsteq	r0, r9
     fb0:	000bac0a 	andeq	sl, fp, sl, lsl #24
     fb4:	ab0a0200 	blge	2817bc <__bss_end+0x278314>
     fb8:	03000008 	movweq	r0, #8
     fbc:	0006630a 	andeq	r6, r6, sl, lsl #6
     fc0:	0e0a0400 	cfcpyseq	mvf0, mvf10
     fc4:	05000007 	streq	r0, [r0, #-7]
     fc8:	03ee0600 	mvneq	r0, #0, 12
     fcc:	05100000 	ldreq	r0, [r0, #-0]
     fd0:	0474081b 	ldrbteq	r0, [r4], #-2075	; 0xfffff7e5
     fd4:	6c070000 	stcvs	0, cr0, [r7], {-0}
     fd8:	1d050072 	stcne	0, cr0, [r5, #-456]	; 0xfffffe38
     fdc:	00047413 	andeq	r7, r4, r3, lsl r4
     fe0:	73070000 	movwvc	r0, #28672	; 0x7000
     fe4:	1e050070 	mcrne	0, 0, r0, cr5, cr0, {3}
     fe8:	00047413 	andeq	r7, r4, r3, lsl r4
     fec:	70070400 	andvc	r0, r7, r0, lsl #8
     ff0:	1f050063 	svcne	0x00050063
     ff4:	00047413 	andeq	r7, r4, r3, lsl r4
     ff8:	d60e0800 	strle	r0, [lr], -r0, lsl #16
     ffc:	05000007 	streq	r0, [r0, #-7]
    1000:	04741320 	ldrbteq	r1, [r4], #-800	; 0xfffffce0
    1004:	000c0000 	andeq	r0, ip, r0
    1008:	9f070402 	svcls	0x00070402
    100c:	06000017 			; <UNDEFINED> instruction: 0x06000017
    1010:	00000caa 	andeq	r0, r0, sl, lsr #25
    1014:	08280580 	stmdaeq	r8!, {r7, r8, sl}
    1018:	0000053e 	andeq	r0, r0, lr, lsr r5
    101c:	0005d50e 	andeq	sp, r5, lr, lsl #10
    1020:	122a0500 	eorne	r0, sl, #0, 10
    1024:	00000435 	andeq	r0, r0, r5, lsr r4
    1028:	69700700 	ldmdbvs	r0!, {r8, r9, sl}^
    102c:	2b050064 	blcs	1411c4 <__bss_end+0x137d1c>
    1030:	00005e12 	andeq	r5, r0, r2, lsl lr
    1034:	f00e1000 			; <UNDEFINED> instruction: 0xf00e1000
    1038:	05000014 	streq	r0, [r0, #-20]	; 0xffffffec
    103c:	03fe112c 	mvnseq	r1, #44, 2
    1040:	0e140000 	cdpeq	0, 1, cr0, cr4, cr0, {0}
    1044:	00000c30 	andeq	r0, r0, r0, lsr ip
    1048:	5e122d05 	cdppl	13, 1, cr2, cr2, cr5, {0}
    104c:	18000000 	stmdane	r0, {}	; <UNPREDICTABLE>
    1050:	0005f90e 	andeq	pc, r5, lr, lsl #18
    1054:	122e0500 	eorne	r0, lr, #0, 10
    1058:	0000005e 	andeq	r0, r0, lr, asr r0
    105c:	03970e1c 	orrseq	r0, r7, #28, 28	; 0x1c0
    1060:	2f050000 	svccs	0x00050000
    1064:	00053e0c 	andeq	r3, r5, ip, lsl #28
    1068:	440e2000 	strmi	r2, [lr], #-0
    106c:	05000006 	streq	r0, [r0, #-6]
    1070:	00380930 	eorseq	r0, r8, r0, lsr r9
    1074:	0e600000 	cdpeq	0, 6, cr0, cr0, cr0, {0}
    1078:	000003e2 	andeq	r0, r0, r2, ror #7
    107c:	4d0e3105 	stfmis	f3, [lr, #-20]	; 0xffffffec
    1080:	64000000 	strvs	r0, [r0], #-0
    1084:	0003d90e 	andeq	sp, r3, lr, lsl #18
    1088:	0e330500 	cfabs32eq	mvfx0, mvfx3
    108c:	0000004d 	andeq	r0, r0, sp, asr #32
    1090:	03d00e68 	bicseq	r0, r0, #104, 28	; 0x680
    1094:	34050000 	strcc	r0, [r5], #-0
    1098:	00004d0e 	andeq	r4, r0, lr, lsl #26
    109c:	70076c00 	andvc	r6, r7, r0, lsl #24
    10a0:	36050074 			; <UNDEFINED> instruction: 0x36050074
    10a4:	00054e0c 	andeq	r4, r5, ip, lsl #28
    10a8:	770e7000 	strvc	r7, [lr, -r0]
    10ac:	05000006 	streq	r0, [r0, #-6]
    10b0:	004d0e37 	subeq	r0, sp, r7, lsr lr
    10b4:	0e740000 	cdpeq	0, 7, cr0, cr4, cr0, {0}
    10b8:	000005ad 	andeq	r0, r0, sp, lsr #11
    10bc:	4d0e3805 	stcmi	8, cr3, [lr, #-20]	; 0xffffffec
    10c0:	78000000 	stmdavc	r0, {}	; <UNPREDICTABLE>
    10c4:	0003bf0e 	andeq	fp, r3, lr, lsl #30
    10c8:	0e390500 	cfabs32eq	mvfx0, mvfx9
    10cc:	0000004d 	andeq	r0, r0, sp, asr #32
    10d0:	b616007c 			; <UNDEFINED> instruction: 0xb616007c
    10d4:	4e000003 	cdpmi	0, 0, cr0, cr0, cr3, {0}
    10d8:	17000005 	strne	r0, [r0, -r5]
    10dc:	0000005e 	andeq	r0, r0, lr, asr r0
    10e0:	0418000f 	ldreq	r0, [r8], #-15
    10e4:	0000004d 	andeq	r0, r0, sp, asr #32
    10e8:	00053c0b 	andeq	r3, r5, fp, lsl #24
    10ec:	140a0600 	strne	r0, [sl], #-1536	; 0xfffffa00
    10f0:	00000059 	andeq	r0, r0, r9, asr r0
    10f4:	94740305 	ldrbtls	r0, [r4], #-773	; 0xfffffcfb
    10f8:	76080000 	strvc	r0, [r8], -r0
    10fc:	05000009 	streq	r0, [r0, #-9]
    1100:	00003804 	andeq	r3, r0, r4, lsl #16
    1104:	0c0d0600 	stceq	6, cr0, [sp], {-0}
    1108:	00000585 	andeq	r0, r0, r5, lsl #11
    110c:	000be50a 	andeq	lr, fp, sl, lsl #10
    1110:	4b0a0000 	blmi	281118 <__bss_end+0x277c70>
    1114:	01000005 	tsteq	r0, r5
    1118:	05660300 	strbeq	r0, [r6, #-768]!	; 0xfffffd00
    111c:	87080000 	strhi	r0, [r8, -r0]
    1120:	0500000e 	streq	r0, [r0, #-14]
    1124:	00003804 	andeq	r3, r0, r4, lsl #16
    1128:	0c140600 	ldceq	6, cr0, [r4], {-0}
    112c:	000005a9 	andeq	r0, r0, r9, lsr #11
    1130:	000cdc0a 	andeq	sp, ip, sl, lsl #24
    1134:	180a0000 	stmdane	sl, {}	; <UNPREDICTABLE>
    1138:	0100000f 	tsteq	r0, pc
    113c:	058a0300 	streq	r0, [sl, #768]	; 0x300
    1140:	1d060000 	stcne	0, cr0, [r6, #-0]
    1144:	0c00000c 	stceq	0, cr0, [r0], {12}
    1148:	e3081b06 	movw	r1, #35590	; 0x8b06
    114c:	0e000005 	cdpeq	0, 0, cr0, cr0, cr5, {0}
    1150:	00000be0 	andeq	r0, r0, r0, ror #23
    1154:	e3191d06 	tst	r9, #384	; 0x180
    1158:	00000005 	andeq	r0, r0, r5
    115c:	000c560e 	andeq	r5, ip, lr, lsl #12
    1160:	191e0600 	ldmdbne	lr, {r9, sl}
    1164:	000005e3 	andeq	r0, r0, r3, ror #11
    1168:	07d10e04 	ldrbeq	r0, [r1, r4, lsl #28]
    116c:	1f060000 	svcne	0x00060000
    1170:	0005e913 	andeq	lr, r5, r3, lsl r9
    1174:	18000800 	stmdane	r0, {fp}
    1178:	0005ae04 	andeq	sl, r5, r4, lsl #28
    117c:	7b041800 	blvc	107184 <__bss_end+0xfdcdc>
    1180:	0d000004 	stceq	0, cr0, [r0, #-16]
    1184:	00000ae6 	andeq	r0, r0, r6, ror #21
    1188:	07220614 			; <UNDEFINED> instruction: 0x07220614
    118c:	000008a5 	andeq	r0, r0, r5, lsr #17
    1190:	00059e0e 	andeq	r9, r5, lr, lsl #28
    1194:	12260600 	eorne	r0, r6, #0, 12
    1198:	0000004d 	andeq	r0, r0, sp, asr #32
    119c:	08250e00 	stmdaeq	r5!, {r9, sl, fp}
    11a0:	29060000 	stmdbcs	r6, {}	; <UNPREDICTABLE>
    11a4:	0005e31d 	andeq	lr, r5, sp, lsl r3
    11a8:	b20e0400 	andlt	r0, lr, #0, 8
    11ac:	06000009 	streq	r0, [r0], -r9
    11b0:	05e31d2c 	strbeq	r1, [r3, #3372]!	; 0xd2c
    11b4:	1b080000 	blne	2011bc <__bss_end+0x1f7d14>
    11b8:	0000058f 	andeq	r0, r0, pc, lsl #11
    11bc:	fa0e2f06 	blx	38cddc <__bss_end+0x383934>
    11c0:	3700000b 	strcc	r0, [r0, -fp]
    11c4:	42000006 	andmi	r0, r0, #6
    11c8:	10000006 	andne	r0, r0, r6
    11cc:	000008aa 	andeq	r0, r0, sl, lsr #17
    11d0:	0005e311 	andeq	lr, r5, r1, lsl r3
    11d4:	881c0000 	ldmdahi	ip, {}	; <UNPREDICTABLE>
    11d8:	06000008 	streq	r0, [r0], -r8
    11dc:	0c810e31 	stceq	14, cr0, [r1], {49}	; 0x31
    11e0:	03870000 	orreq	r0, r7, #0
    11e4:	065a0000 	ldrbeq	r0, [sl], -r0
    11e8:	06650000 	strbteq	r0, [r5], -r0
    11ec:	aa100000 	bge	4011f4 <__bss_end+0x3f7d4c>
    11f0:	11000008 	tstne	r0, r8
    11f4:	000005e9 	andeq	r0, r0, r9, ror #11
    11f8:	07021300 	streq	r1, [r2, -r0, lsl #6]
    11fc:	35060000 	strcc	r0, [r6, #-0]
    1200:	0008ea1d 	andeq	lr, r8, sp, lsl sl
    1204:	0005e300 	andeq	lr, r5, r0, lsl #6
    1208:	067e0200 	ldrbteq	r0, [lr], -r0, lsl #4
    120c:	06840000 	streq	r0, [r4], r0
    1210:	aa100000 	bge	401218 <__bss_end+0x3f7d70>
    1214:	00000008 	andeq	r0, r0, r8
    1218:	000c3e13 	andeq	r3, ip, r3, lsl lr
    121c:	1d370600 	ldcne	6, cr0, [r7, #-0]
    1220:	00000c5b 	andeq	r0, r0, fp, asr ip
    1224:	000005e3 	andeq	r0, r0, r3, ror #11
    1228:	00069d02 	andeq	r9, r6, r2, lsl #26
    122c:	0006a300 	andeq	sl, r6, r0, lsl #6
    1230:	08aa1000 	stmiaeq	sl!, {ip}
    1234:	1d000000 	stcne	0, cr0, [r0, #-0]
    1238:	00000926 	andeq	r0, r0, r6, lsr #18
    123c:	c3313906 	teqgt	r1, #98304	; 0x18000
    1240:	0c000008 	stceq	0, cr0, [r0], {8}
    1244:	0ae61302 	beq	ff985e54 <__bss_end+0xff97c9ac>
    1248:	3c060000 	stccc	0, cr0, [r6], {-0}
    124c:	0008bd09 	andeq	fp, r8, r9, lsl #26
    1250:	0008aa00 	andeq	sl, r8, r0, lsl #20
    1254:	06ca0100 	strbeq	r0, [sl], r0, lsl #2
    1258:	06d00000 	ldrbeq	r0, [r0], r0
    125c:	aa100000 	bge	401264 <__bss_end+0x3f7dbc>
    1260:	00000008 	andeq	r0, r0, r8
    1264:	0005e113 	andeq	lr, r5, r3, lsl r1
    1268:	123f0600 	eorsne	r0, pc, #0, 12
    126c:	00000681 	andeq	r0, r0, r1, lsl #13
    1270:	0000004d 	andeq	r0, r0, sp, asr #32
    1274:	0006e901 	andeq	lr, r6, r1, lsl #18
    1278:	0006fe00 	andeq	pc, r6, r0, lsl #28
    127c:	08aa1000 	stmiaeq	sl!, {ip}
    1280:	cc110000 	ldcgt	0, cr0, [r1], {-0}
    1284:	11000008 	tstne	r0, r8
    1288:	0000005e 	andeq	r0, r0, lr, asr r0
    128c:	00038711 	andeq	r8, r3, r1, lsl r7
    1290:	79140000 	ldmdbvc	r4, {}	; <UNPREDICTABLE>
    1294:	0600000a 	streq	r0, [r0], -sl
    1298:	04f30e42 	ldrbteq	r0, [r3], #3650	; 0xe42
    129c:	13010000 	movwne	r0, #4096	; 0x1000
    12a0:	19000007 	stmdbne	r0, {r0, r1, r2}
    12a4:	10000007 	andne	r0, r0, r7
    12a8:	000008aa 	andeq	r0, r0, sl, lsr #17
    12ac:	074c1300 	strbeq	r1, [ip, -r0, lsl #6]
    12b0:	45060000 	strmi	r0, [r6, #-0]
    12b4:	00044917 	andeq	r4, r4, r7, lsl r9
    12b8:	0005e900 	andeq	lr, r5, r0, lsl #18
    12bc:	07320100 	ldreq	r0, [r2, -r0, lsl #2]!
    12c0:	07380000 	ldreq	r0, [r8, -r0]!
    12c4:	d2100000 	andsle	r0, r0, #0
    12c8:	00000008 	andeq	r0, r0, r8
    12cc:	00098b13 	andeq	r8, r9, r3, lsl fp
    12d0:	17480600 	strbne	r0, [r8, -r0, lsl #12]
    12d4:	000004c6 	andeq	r0, r0, r6, asr #9
    12d8:	000005e9 	andeq	r0, r0, r9, ror #11
    12dc:	00075101 	andeq	r5, r7, r1, lsl #2
    12e0:	00075c00 	andeq	r5, r7, r0, lsl #24
    12e4:	08d21000 	ldmeq	r2, {ip}^
    12e8:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    12ec:	00000000 	andeq	r0, r0, r0
    12f0:	0007b014 	andeq	fp, r7, r4, lsl r0
    12f4:	0e4b0600 	cdpeq	6, 4, cr0, cr11, cr0, {0}
    12f8:	00000934 	andeq	r0, r0, r4, lsr r9
    12fc:	00077101 	andeq	r7, r7, r1, lsl #2
    1300:	00077700 	andeq	r7, r7, r0, lsl #14
    1304:	08aa1000 	stmiaeq	sl!, {ip}
    1308:	13000000 	movwne	r0, #0
    130c:	00000888 	andeq	r0, r0, r8, lsl #17
    1310:	140e4d06 	strne	r4, [lr], #-3334	; 0xfffff2fa
    1314:	87000005 	strhi	r0, [r0, -r5]
    1318:	01000003 	tsteq	r0, r3
    131c:	00000790 	muleq	r0, r0, r7
    1320:	0000079b 	muleq	r0, fp, r7
    1324:	0008aa10 	andeq	sl, r8, r0, lsl sl
    1328:	004d1100 	subeq	r1, sp, r0, lsl #2
    132c:	13000000 	movwne	r0, #0
    1330:	0000099e 	muleq	r0, lr, r9
    1334:	f2125006 	vhadd.s16	d5, d2, d6
    1338:	4d000007 	stcmi	0, cr0, [r0, #-28]	; 0xffffffe4
    133c:	01000000 	mrseq	r0, (UNDEF: 0)
    1340:	000007b4 			; <UNDEFINED> instruction: 0x000007b4
    1344:	000007bf 			; <UNDEFINED> instruction: 0x000007bf
    1348:	0008aa10 	andeq	sl, r8, r0, lsl sl
    134c:	03b61100 			; <UNDEFINED> instruction: 0x03b61100
    1350:	13000000 	movwne	r0, #0
    1354:	000006ac 	andeq	r0, r0, ip, lsr #13
    1358:	d60e5306 	strle	r5, [lr], -r6, lsl #6
    135c:	87000006 	strhi	r0, [r0, -r6]
    1360:	01000003 	tsteq	r0, r3
    1364:	000007d8 	ldrdeq	r0, [r0], -r8
    1368:	000007e3 	andeq	r0, r0, r3, ror #15
    136c:	0008aa10 	andeq	sl, r8, r0, lsl sl
    1370:	004d1100 	subeq	r1, sp, r0, lsl #2
    1374:	14000000 	strne	r0, [r0], #-0
    1378:	00000963 	andeq	r0, r0, r3, ror #18
    137c:	210e5606 	tstcs	lr, r6, lsl #12
    1380:	0100000a 	tsteq	r0, sl
    1384:	000007f8 	strdeq	r0, [r0], -r8
    1388:	00000817 	andeq	r0, r0, r7, lsl r8
    138c:	0008aa10 	andeq	sl, r8, r0, lsl sl
    1390:	00a91100 	adceq	r1, r9, r0, lsl #2
    1394:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    1398:	11000000 	mrsne	r0, (UNDEF: 0)
    139c:	0000004d 	andeq	r0, r0, sp, asr #32
    13a0:	00004d11 	andeq	r4, r0, r1, lsl sp
    13a4:	08d81100 	ldmeq	r8, {r8, ip}^
    13a8:	14000000 	strne	r0, [r0], #-0
    13ac:	000005bf 			; <UNDEFINED> instruction: 0x000005bf
    13b0:	820e5806 	andhi	r5, lr, #393216	; 0x60000
    13b4:	0100000a 	tsteq	r0, sl
    13b8:	0000082c 	andeq	r0, r0, ip, lsr #16
    13bc:	0000084b 	andeq	r0, r0, fp, asr #16
    13c0:	0008aa10 	andeq	sl, r8, r0, lsl sl
    13c4:	00e01100 	rsceq	r1, r0, r0, lsl #2
    13c8:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    13cc:	11000000 	mrsne	r0, (UNDEF: 0)
    13d0:	0000004d 	andeq	r0, r0, sp, asr #32
    13d4:	00004d11 	andeq	r4, r0, r1, lsl sp
    13d8:	08d81100 	ldmeq	r8, {r8, ip}^
    13dc:	14000000 	strne	r0, [r0], #-0
    13e0:	000006bf 			; <UNDEFINED> instruction: 0x000006bf
    13e4:	cb0e5b06 	blgt	398004 <__bss_end+0x38eb5c>
    13e8:	01000009 	tsteq	r0, r9
    13ec:	00000860 	andeq	r0, r0, r0, ror #16
    13f0:	0000087f 	andeq	r0, r0, pc, ror r8
    13f4:	0008aa10 	andeq	sl, r8, r0, lsl sl
    13f8:	01481100 	mrseq	r1, (UNDEF: 88)
    13fc:	4d110000 	ldcmi	0, cr0, [r1, #-0]
    1400:	11000000 	mrsne	r0, (UNDEF: 0)
    1404:	0000004d 	andeq	r0, r0, sp, asr #32
    1408:	00004d11 	andeq	r4, r0, r1, lsl sp
    140c:	08d81100 	ldmeq	r8, {r8, ip}^
    1410:	15000000 	strne	r0, [r0, #-0]
    1414:	000008d7 	ldrdeq	r0, [r0], -r7
    1418:	690e5e06 	stmdbvs	lr, {r1, r2, r9, sl, fp, ip, lr}
    141c:	8700000b 	strhi	r0, [r0, -fp]
    1420:	01000003 	tsteq	r0, r3
    1424:	00000894 	muleq	r0, r4, r8
    1428:	0008aa10 	andeq	sl, r8, r0, lsl sl
    142c:	05661100 	strbeq	r1, [r6, #-256]!	; 0xffffff00
    1430:	de110000 	cdple	0, 1, cr0, cr1, cr0, {0}
    1434:	00000008 	andeq	r0, r0, r8
    1438:	05ef0300 	strbeq	r0, [pc, #768]!	; 1740 <shift+0x1740>
    143c:	04180000 	ldreq	r0, [r8], #-0
    1440:	000005ef 	andeq	r0, r0, pc, ror #11
    1444:	0005e31e 	andeq	lr, r5, lr, lsl r3
    1448:	0008bd00 	andeq	fp, r8, r0, lsl #26
    144c:	0008c300 	andeq	ip, r8, r0, lsl #6
    1450:	08aa1000 	stmiaeq	sl!, {ip}
    1454:	1f000000 	svcne	0x00000000
    1458:	000005ef 	andeq	r0, r0, pc, ror #11
    145c:	000008b0 			; <UNDEFINED> instruction: 0x000008b0
    1460:	003f0418 	eorseq	r0, pc, r8, lsl r4	; <UNPREDICTABLE>
    1464:	04180000 	ldreq	r0, [r8], #-0
    1468:	000008a5 	andeq	r0, r0, r5, lsr #17
    146c:	00650420 	rsbeq	r0, r5, r0, lsr #8
    1470:	04210000 	strteq	r0, [r1], #-0
    1474:	00076b1a 	andeq	r6, r7, sl, lsl fp
    1478:	19610600 	stmdbne	r1!, {r9, sl}^
    147c:	000005ef 	andeq	r0, r0, pc, ror #11
    1480:	00002c16 	andeq	r2, r0, r6, lsl ip
    1484:	0008fc00 	andeq	pc, r8, r0, lsl #24
    1488:	005e1700 	subseq	r1, lr, r0, lsl #14
    148c:	00090000 	andeq	r0, r9, r0
    1490:	0008ec03 	andeq	lr, r8, r3, lsl #24
    1494:	0dc92200 	sfmeq	f2, 2, [r9]
    1498:	a4010000 	strge	r0, [r1], #-0
    149c:	0008fc0c 	andeq	pc, r8, ip, lsl #24
    14a0:	78030500 	stmdavc	r3, {r8, sl}
    14a4:	23000094 	movwcs	r0, #148	; 0x94
    14a8:	00000cee 	andeq	r0, r0, lr, ror #25
    14ac:	7b0aa601 	blvc	2aacb8 <__bss_end+0x2a1810>
    14b0:	4d00000e 	stcmi	0, cr0, [r0, #-56]	; 0xffffffc8
    14b4:	20000000 	andcs	r0, r0, r0
    14b8:	b0000086 	andlt	r0, r0, r6, lsl #1
    14bc:	01000000 	mrseq	r0, (UNDEF: 0)
    14c0:	0009719c 	muleq	r9, ip, r1
    14c4:	1b142400 	blne	50a4cc <__bss_end+0x501024>
    14c8:	a6010000 	strge	r0, [r1], -r0
    14cc:	0003941b 	andeq	r9, r3, fp, lsl r4
    14d0:	ac910300 	ldcge	3, cr0, [r1], {0}
    14d4:	0ee2247f 	mcreq	4, 7, r2, cr2, cr15, {3}
    14d8:	a6010000 	strge	r0, [r1], -r0
    14dc:	00004d2a 	andeq	r4, r0, sl, lsr #26
    14e0:	a8910300 	ldmge	r1, {r8, r9}
    14e4:	0e5c227f 	mrceq	2, 2, r2, cr12, cr15, {3}
    14e8:	a8010000 	stmdage	r1, {}	; <UNPREDICTABLE>
    14ec:	0009710a 	andeq	r7, r9, sl, lsl #2
    14f0:	b4910300 	ldrlt	r0, [r1], #768	; 0x300
    14f4:	0ce9227f 	sfmeq	f2, 2, [r9], #508	; 0x1fc
    14f8:	ac010000 	stcge	0, cr0, [r1], {-0}
    14fc:	00003809 	andeq	r3, r0, r9, lsl #16
    1500:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1504:	00251600 	eoreq	r1, r5, r0, lsl #12
    1508:	09810000 	stmibeq	r1, {}	; <UNPREDICTABLE>
    150c:	5e170000 	cdppl	0, 1, cr0, cr7, cr0, {0}
    1510:	3f000000 	svccc	0x00000000
    1514:	0ec72500 	cdpeq	5, 12, cr2, cr7, cr0, {0}
    1518:	98010000 	stmdals	r1, {}	; <UNPREDICTABLE>
    151c:	000f3d0a 	andeq	r3, pc, sl, lsl #26
    1520:	00004d00 	andeq	r4, r0, r0, lsl #26
    1524:	0085e400 	addeq	lr, r5, r0, lsl #8
    1528:	00003c00 	andeq	r3, r0, r0, lsl #24
    152c:	be9c0100 	fmllte	f0, f4, f0
    1530:	26000009 	strcs	r0, [r0], -r9
    1534:	00716572 	rsbseq	r6, r1, r2, ror r5
    1538:	a9209a01 	stmdbge	r0!, {r0, r9, fp, ip, pc}
    153c:	02000005 	andeq	r0, r0, #5
    1540:	70227491 	mlavc	r2, r1, r4, r7
    1544:	0100000e 	tsteq	r0, lr
    1548:	004d0e9b 	umaaleq	r0, sp, fp, lr
    154c:	91020000 	mrsls	r0, (UNDEF: 2)
    1550:	eb270070 	bl	9c1718 <__bss_end+0x9b8270>
    1554:	0100000e 	tsteq	r0, lr
    1558:	0d0a068f 	stceq	6, cr0, [sl, #-572]	; 0xfffffdc4
    155c:	85a80000 	strhi	r0, [r8, #0]!
    1560:	003c0000 	eorseq	r0, ip, r0
    1564:	9c010000 	stcls	0, cr0, [r1], {-0}
    1568:	000009f7 	strdeq	r0, [r0], -r7
    156c:	000db524 	andeq	fp, sp, r4, lsr #10
    1570:	218f0100 	orrcs	r0, pc, r0, lsl #2
    1574:	0000004d 	andeq	r0, r0, sp, asr #32
    1578:	266c9102 	strbtcs	r9, [ip], -r2, lsl #2
    157c:	00716572 	rsbseq	r6, r1, r2, ror r5
    1580:	a9209101 	stmdbge	r0!, {r0, r8, ip, pc}
    1584:	02000005 	andeq	r0, r0, #5
    1588:	25007491 	strcs	r7, [r0, #-1169]	; 0xfffffb6f
    158c:	00000e9c 	muleq	r0, ip, lr
    1590:	e50a8301 	str	r8, [sl, #-769]	; 0xfffffcff
    1594:	4d00000d 	stcmi	0, cr0, [r0, #-52]	; 0xffffffcc
    1598:	6c000000 	stcvs	0, cr0, [r0], {-0}
    159c:	3c000085 	stccc	0, cr0, [r0], {133}	; 0x85
    15a0:	01000000 	mrseq	r0, (UNDEF: 0)
    15a4:	000a349c 	muleq	sl, ip, r4
    15a8:	65722600 	ldrbvs	r2, [r2, #-1536]!	; 0xfffffa00
    15ac:	85010071 	strhi	r0, [r1, #-113]	; 0xffffff8f
    15b0:	00058520 	andeq	r8, r5, r0, lsr #10
    15b4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    15b8:	000e6922 	andeq	r6, lr, r2, lsr #18
    15bc:	0e860100 	rmfeqs	f0, f6, f0
    15c0:	0000004d 	andeq	r0, r0, sp, asr #32
    15c4:	00709102 	rsbseq	r9, r0, r2, lsl #2
    15c8:	000fdd25 	andeq	sp, pc, r5, lsr #26
    15cc:	0a770100 	beq	1dc19d4 <__bss_end+0x1db852c>
    15d0:	00000d8b 	andeq	r0, r0, fp, lsl #27
    15d4:	0000004d 	andeq	r0, r0, sp, asr #32
    15d8:	00008530 	andeq	r8, r0, r0, lsr r5
    15dc:	0000003c 	andeq	r0, r0, ip, lsr r0
    15e0:	0a719c01 	beq	1c685ec <__bss_end+0x1c5f144>
    15e4:	72260000 	eorvc	r0, r6, #0
    15e8:	01007165 	tsteq	r0, r5, ror #2
    15ec:	05852079 	streq	r2, [r5, #121]	; 0x79
    15f0:	91020000 	mrsls	r0, (UNDEF: 2)
    15f4:	0e692274 	mcreq	2, 3, r2, cr9, cr4, {3}
    15f8:	7a010000 	bvc	41600 <__bss_end+0x38158>
    15fc:	00004d0e 	andeq	r4, r0, lr, lsl #26
    1600:	70910200 	addsvc	r0, r1, r0, lsl #4
    1604:	0df92500 	cfldr64eq	mvdx2, [r9]
    1608:	6b010000 	blvs	41610 <__bss_end+0x38168>
    160c:	000f0806 	andeq	r0, pc, r6, lsl #16
    1610:	00038700 	andeq	r8, r3, r0, lsl #14
    1614:	0084dc00 	addeq	sp, r4, r0, lsl #24
    1618:	00005400 	andeq	r5, r0, r0, lsl #8
    161c:	bd9c0100 	ldflts	f0, [ip]
    1620:	2400000a 	strcs	r0, [r0], #-10
    1624:	00000e70 	andeq	r0, r0, r0, ror lr
    1628:	4d156b01 	vldrmi	d6, [r5, #-4]
    162c:	02000000 	andeq	r0, r0, #0
    1630:	d0246c91 	mlale	r4, r1, ip, r6
    1634:	01000003 	tsteq	r0, r3
    1638:	004d256b 	subeq	r2, sp, fp, ror #10
    163c:	91020000 	mrsls	r0, (UNDEF: 2)
    1640:	0ebf2268 	cdpeq	2, 11, cr2, cr15, cr8, {3}
    1644:	6d010000 	stcvs	0, cr0, [r1, #-0]
    1648:	00004d0e 	andeq	r4, r0, lr, lsl #26
    164c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1650:	0d272500 	cfstr32eq	mvfx2, [r7, #-0]
    1654:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
    1658:	000f7412 	andeq	r7, pc, r2, lsl r4	; <UNPREDICTABLE>
    165c:	00008b00 	andeq	r8, r0, r0, lsl #22
    1660:	00848c00 	addeq	r8, r4, r0, lsl #24
    1664:	00005000 	andeq	r5, r0, r0
    1668:	189c0100 	ldmne	ip, {r8}
    166c:	2400000b 	strcs	r0, [r0], #-11
    1670:	00000f13 	andeq	r0, r0, r3, lsl pc
    1674:	4d205e01 	stcmi	14, cr5, [r0, #-4]!
    1678:	02000000 	andeq	r0, r0, #0
    167c:	a5246c91 	strge	r6, [r4, #-3217]!	; 0xfffff36f
    1680:	0100000e 	tsteq	r0, lr
    1684:	004d2f5e 	subeq	r2, sp, lr, asr pc
    1688:	91020000 	mrsls	r0, (UNDEF: 2)
    168c:	03d02468 	bicseq	r2, r0, #104, 8	; 0x68000000
    1690:	5e010000 	cdppl	0, 0, cr0, cr1, cr0, {0}
    1694:	00004d3f 	andeq	r4, r0, pc, lsr sp
    1698:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    169c:	000ebf22 	andeq	fp, lr, r2, lsr #30
    16a0:	16600100 	strbtne	r0, [r0], -r0, lsl #2
    16a4:	0000008b 	andeq	r0, r0, fp, lsl #1
    16a8:	00749102 	rsbseq	r9, r4, r2, lsl #2
    16ac:	000e6225 	andeq	r6, lr, r5, lsr #4
    16b0:	0a520100 	beq	1481ab8 <__bss_end+0x1478610>
    16b4:	00000d2c 	andeq	r0, r0, ip, lsr #26
    16b8:	0000004d 	andeq	r0, r0, sp, asr #32
    16bc:	00008448 	andeq	r8, r0, r8, asr #8
    16c0:	00000044 	andeq	r0, r0, r4, asr #32
    16c4:	0b649c01 	bleq	19286d0 <__bss_end+0x191f228>
    16c8:	13240000 			; <UNDEFINED> instruction: 0x13240000
    16cc:	0100000f 	tsteq	r0, pc
    16d0:	004d1a52 	subeq	r1, sp, r2, asr sl
    16d4:	91020000 	mrsls	r0, (UNDEF: 2)
    16d8:	0ea5246c 	cdpeq	4, 10, cr2, cr5, cr12, {3}
    16dc:	52010000 	andpl	r0, r1, #0
    16e0:	00004d29 	andeq	r4, r0, r9, lsr #26
    16e4:	68910200 	ldmvs	r1, {r9}
    16e8:	000fa322 	andeq	sl, pc, r2, lsr #6
    16ec:	0e540100 	rdfeqs	f0, f4, f0
    16f0:	0000004d 	andeq	r0, r0, sp, asr #32
    16f4:	00749102 	rsbseq	r9, r4, r2, lsl #2
    16f8:	000f9d25 	andeq	r9, pc, r5, lsr #26
    16fc:	0a450100 	beq	1141b04 <__bss_end+0x113865c>
    1700:	00000f7f 	andeq	r0, r0, pc, ror pc
    1704:	0000004d 	andeq	r0, r0, sp, asr #32
    1708:	000083f8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
    170c:	00000050 	andeq	r0, r0, r0, asr r0
    1710:	0bbf9c01 	bleq	fefe871c <__bss_end+0xfefdf274>
    1714:	13240000 			; <UNDEFINED> instruction: 0x13240000
    1718:	0100000f 	tsteq	r0, pc
    171c:	004d1945 	subeq	r1, sp, r5, asr #18
    1720:	91020000 	mrsls	r0, (UNDEF: 2)
    1724:	0e3d246c 	cdpeq	4, 3, cr2, cr13, cr12, {3}
    1728:	45010000 	strmi	r0, [r1, #-0]
    172c:	00011d30 	andeq	r1, r1, r0, lsr sp
    1730:	68910200 	ldmvs	r1, {r9}
    1734:	000eab24 	andeq	sl, lr, r4, lsr #22
    1738:	41450100 	mrsmi	r0, (UNDEF: 85)
    173c:	000008de 	ldrdeq	r0, [r0], -lr
    1740:	22649102 	rsbcs	r9, r4, #-2147483648	; 0x80000000
    1744:	00000ebf 			; <UNDEFINED> instruction: 0x00000ebf
    1748:	4d0e4701 	stcmi	7, cr4, [lr, #-4]
    174c:	02000000 	andeq	r0, r0, #0
    1750:	27007491 			; <UNDEFINED> instruction: 0x27007491
    1754:	00000cd6 	ldrdeq	r0, [r0], -r6
    1758:	47063f01 	strmi	r3, [r6, -r1, lsl #30]
    175c:	cc00000e 	stcgt	0, cr0, [r0], {14}
    1760:	2c000083 	stccs	0, cr0, [r0], {131}	; 0x83
    1764:	01000000 	mrseq	r0, (UNDEF: 0)
    1768:	000be99c 	muleq	fp, ip, r9
    176c:	0f132400 	svceq	0x00132400
    1770:	3f010000 	svccc	0x00010000
    1774:	00004d15 	andeq	r4, r0, r5, lsl sp
    1778:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    177c:	0d212500 	cfstr32eq	mvfx2, [r1, #-0]
    1780:	32010000 	andcc	r0, r1, #0
    1784:	000eb10a 	andeq	fp, lr, sl, lsl #2
    1788:	00004d00 	andeq	r4, r0, r0, lsl #26
    178c:	00837c00 	addeq	r7, r3, r0, lsl #24
    1790:	00005000 	andeq	r5, r0, r0
    1794:	449c0100 	ldrmi	r0, [ip], #256	; 0x100
    1798:	2400000c 	strcs	r0, [r0], #-12
    179c:	00000f13 	andeq	r0, r0, r3, lsl pc
    17a0:	4d193201 	lfmmi	f3, 4, [r9, #-4]
    17a4:	02000000 	andeq	r0, r0, #0
    17a8:	b9246c91 	stmdblt	r4!, {r0, r4, r7, sl, fp, sp, lr}
    17ac:	0100000f 	tsteq	r0, pc
    17b0:	03942b32 	orrseq	r2, r4, #51200	; 0xc800
    17b4:	91020000 	mrsls	r0, (UNDEF: 2)
    17b8:	0ee62468 	cdpeq	4, 14, cr2, cr6, cr8, {3}
    17bc:	32010000 	andcc	r0, r1, #0
    17c0:	00004d3c 	andeq	r4, r0, ip, lsr sp
    17c4:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    17c8:	000f6e22 	andeq	r6, pc, r2, lsr #28
    17cc:	0e340100 	rsfeqs	f0, f4, f0
    17d0:	0000004d 	andeq	r0, r0, sp, asr #32
    17d4:	00749102 	rsbseq	r9, r4, r2, lsl #2
    17d8:	000fff25 	andeq	pc, pc, r5, lsr #30
    17dc:	0a250100 	beq	941be4 <__bss_end+0x93873c>
    17e0:	00000fc0 	andeq	r0, r0, r0, asr #31
    17e4:	0000004d 	andeq	r0, r0, sp, asr #32
    17e8:	0000832c 	andeq	r8, r0, ip, lsr #6
    17ec:	00000050 	andeq	r0, r0, r0, asr r0
    17f0:	0c9f9c01 	ldceq	12, cr9, [pc], {1}
    17f4:	13240000 			; <UNDEFINED> instruction: 0x13240000
    17f8:	0100000f 	tsteq	r0, pc
    17fc:	004d1825 	subeq	r1, sp, r5, lsr #16
    1800:	91020000 	mrsls	r0, (UNDEF: 2)
    1804:	0fb9246c 	svceq	0x00b9246c
    1808:	25010000 	strcs	r0, [r1, #-0]
    180c:	000ca52a 	andeq	sl, ip, sl, lsr #10
    1810:	68910200 	ldmvs	r1, {r9}
    1814:	000ee624 	andeq	lr, lr, r4, lsr #12
    1818:	3b250100 	blcc	941c20 <__bss_end+0x938778>
    181c:	0000004d 	andeq	r0, r0, sp, asr #32
    1820:	22649102 	rsbcs	r9, r4, #-2147483648	; 0x80000000
    1824:	00000cf3 	strdeq	r0, [r0], -r3
    1828:	4d0e2701 	stcmi	7, cr2, [lr, #-4]
    182c:	02000000 	andeq	r0, r0, #0
    1830:	18007491 	stmdane	r0, {r0, r4, r7, sl, ip, sp, lr}
    1834:	00002504 	andeq	r2, r0, r4, lsl #10
    1838:	0c9f0300 	ldceq	3, cr0, [pc], {0}
    183c:	76250000 	strtvc	r0, [r5], -r0
    1840:	0100000e 	tsteq	r0, lr
    1844:	100b0a19 	andne	r0, fp, r9, lsl sl
    1848:	004d0000 	subeq	r0, sp, r0
    184c:	82e80000 	rschi	r0, r8, #0
    1850:	00440000 	subeq	r0, r4, r0
    1854:	9c010000 	stcls	0, cr0, [r1], {-0}
    1858:	00000cf6 	strdeq	r0, [r0], -r6
    185c:	000ff624 	andeq	pc, pc, r4, lsr #12
    1860:	1b190100 	blne	641c68 <__bss_end+0x6387c0>
    1864:	00000394 	muleq	r0, r4, r3
    1868:	246c9102 	strbtcs	r9, [ip], #-258	; 0xfffffefe
    186c:	00000fb4 			; <UNDEFINED> instruction: 0x00000fb4
    1870:	df351901 	svcle	0x00351901
    1874:	02000001 	andeq	r0, r0, #1
    1878:	13226891 			; <UNDEFINED> instruction: 0x13226891
    187c:	0100000f 	tsteq	r0, pc
    1880:	004d0e1b 	subeq	r0, sp, fp, lsl lr
    1884:	91020000 	mrsls	r0, (UNDEF: 2)
    1888:	a9280074 	stmdbge	r8!, {r2, r4, r5, r6}
    188c:	0100000d 	tsteq	r0, sp
    1890:	0cf90614 	ldcleq	6, cr0, [r9], #80	; 0x50
    1894:	82cc0000 	sbchi	r0, ip, #0
    1898:	001c0000 	andseq	r0, ip, r0
    189c:	9c010000 	stcls	0, cr0, [r1], {-0}
    18a0:	000faa27 	andeq	sl, pc, r7, lsr #20
    18a4:	060e0100 	streq	r0, [lr], -r0, lsl #2
    18a8:	00000d38 	andeq	r0, r0, r8, lsr sp
    18ac:	000082a0 	andeq	r8, r0, r0, lsr #5
    18b0:	0000002c 	andeq	r0, r0, ip, lsr #32
    18b4:	0d369c01 	ldceq	12, cr9, [r6, #-4]!
    18b8:	82240000 	eorhi	r0, r4, #0
    18bc:	0100000d 	tsteq	r0, sp
    18c0:	0038140e 	eorseq	r1, r8, lr, lsl #8
    18c4:	91020000 	mrsls	r0, (UNDEF: 2)
    18c8:	04290074 	strteq	r0, [r9], #-116	; 0xffffff8c
    18cc:	01000010 	tsteq	r0, r0, lsl r0
    18d0:	0e510a04 	vnmlseq.f32	s1, s2, s8
    18d4:	004d0000 	subeq	r0, sp, r0
    18d8:	82740000 	rsbshi	r0, r4, #0
    18dc:	002c0000 	eoreq	r0, ip, r0
    18e0:	9c010000 	stcls	0, cr0, [r1], {-0}
    18e4:	64697026 	strbtvs	r7, [r9], #-38	; 0xffffffda
    18e8:	0e060100 	adfeqs	f0, f6, f0
    18ec:	0000004d 	andeq	r0, r0, sp, asr #32
    18f0:	00749102 	rsbseq	r9, r4, r2, lsl #2
    18f4:	0004f800 	andeq	pc, r4, r0, lsl #16
    18f8:	a2000400 	andge	r0, r0, #0, 8
    18fc:	04000006 	streq	r0, [r0], #-6
    1900:	00102701 	andseq	r2, r0, r1, lsl #14
    1904:	11810400 	orrne	r0, r1, r0, lsl #8
    1908:	0e170000 	cdpeq	0, 1, cr0, cr7, cr0, {0}
    190c:	86d00000 	ldrbhi	r0, [r0], r0
    1910:	0b400000 	bleq	1001918 <__bss_end+0xff8470>
    1914:	05fb0000 	ldrbeq	r0, [fp, #0]!
    1918:	49020000 	stmdbmi	r2, {}	; <UNPREDICTABLE>
    191c:	03000000 	movweq	r0, #0
    1920:	000011fb 	strdeq	r1, [r0], -fp
    1924:	61100701 	tstvs	r0, r1, lsl #14
    1928:	11000000 	mrsne	r0, (UNDEF: 0)
    192c:	33323130 	teqcc	r2, #48, 2
    1930:	37363534 			; <UNDEFINED> instruction: 0x37363534
    1934:	42413938 	submi	r3, r1, #56, 18	; 0xe0000
    1938:	46454443 	strbmi	r4, [r5], -r3, asr #8
    193c:	01040000 	mrseq	r0, (UNDEF: 4)
    1940:	00250105 	eoreq	r0, r5, r5, lsl #2
    1944:	74050000 	strvc	r0, [r5], #-0
    1948:	61000000 	mrsvs	r0, (UNDEF: 0)
    194c:	06000000 	streq	r0, [r0], -r0
    1950:	00000066 	andeq	r0, r0, r6, rrx
    1954:	51070010 	tstpl	r7, r0, lsl r0
    1958:	08000000 	stmdaeq	r0, {}	; <UNPREDICTABLE>
    195c:	17a40704 	strne	r0, [r4, r4, lsl #14]!
    1960:	01080000 	mrseq	r0, (UNDEF: 8)
    1964:	00073708 	andeq	r3, r7, r8, lsl #14
    1968:	006d0700 	rsbeq	r0, sp, r0, lsl #14
    196c:	2a090000 	bcs	241974 <__bss_end+0x2384cc>
    1970:	0a000000 	beq	1978 <shift+0x1978>
    1974:	0000122c 	andeq	r1, r0, ip, lsr #4
    1978:	0406dd01 	streq	sp, [r6], #-3329	; 0xfffff2ff
    197c:	90000011 	andls	r0, r0, r1, lsl r0
    1980:	80000091 	mulhi	r0, r1, r0
    1984:	01000000 	mrseq	r0, (UNDEF: 0)
    1988:	0000fb9c 	muleq	r0, ip, fp
    198c:	72730b00 	rsbsvc	r0, r3, #0, 22
    1990:	dd010063 	stcle	0, cr0, [r1, #-396]	; 0xfffffe74
    1994:	0000fb19 	andeq	pc, r0, r9, lsl fp	; <UNPREDICTABLE>
    1998:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    199c:	7473640b 	ldrbtvc	r6, [r3], #-1035	; 0xfffffbf5
    19a0:	24dd0100 	ldrbcs	r0, [sp], #256	; 0x100
    19a4:	00000102 	andeq	r0, r0, r2, lsl #2
    19a8:	0b609102 	bleq	1825db8 <__bss_end+0x181c910>
    19ac:	006d756e 	rsbeq	r7, sp, lr, ror #10
    19b0:	042ddd01 	strteq	sp, [sp], #-3329	; 0xfffff2ff
    19b4:	02000001 	andeq	r0, r0, #1
    19b8:	0c0c5c91 	stceq	12, cr5, [ip], {145}	; 0x91
    19bc:	01000012 	tsteq	r0, r2, lsl r0
    19c0:	01100edf 			; <UNDEFINED> instruction: 0x01100edf
    19c4:	91020000 	mrsls	r0, (UNDEF: 2)
    19c8:	11f40c70 	mvnsne	r0, r0, ror ip
    19cc:	e0010000 	and	r0, r1, r0
    19d0:	00011608 	andeq	r1, r1, r8, lsl #12
    19d4:	6c910200 	lfmvs	f0, 4, [r1], {0}
    19d8:	0091b80d 	addseq	fp, r1, sp, lsl #16
    19dc:	00004800 	andeq	r4, r0, r0, lsl #16
    19e0:	00690e00 	rsbeq	r0, r9, r0, lsl #28
    19e4:	040be201 	streq	lr, [fp], #-513	; 0xfffffdff
    19e8:	02000001 	andeq	r0, r0, #1
    19ec:	00007491 	muleq	r0, r1, r4
    19f0:	0101040f 	tsteq	r1, pc, lsl #8
    19f4:	11100000 	tstne	r0, r0
    19f8:	05041204 	streq	r1, [r4, #-516]	; 0xfffffdfc
    19fc:	00746e69 	rsbseq	r6, r4, r9, ror #28
    1a00:	00010407 	andeq	r0, r1, r7, lsl #8
    1a04:	74040f00 	strvc	r0, [r4], #-3840	; 0xfffff100
    1a08:	0f000000 	svceq	0x00000000
    1a0c:	00006d04 	andeq	r6, r0, r4, lsl #26
    1a10:	12130a00 	andsne	r0, r3, #0, 20
    1a14:	d5010000 	strle	r0, [r1, #-0]
    1a18:	00116206 	andseq	r6, r1, r6, lsl #4
    1a1c:	00912800 	addseq	r2, r1, r0, lsl #16
    1a20:	00006800 	andeq	r6, r0, r0, lsl #16
    1a24:	7b9c0100 	blvc	fe701e2c <__bss_end+0xfe6f8984>
    1a28:	13000001 	movwne	r0, #1
    1a2c:	00001264 	andeq	r1, r0, r4, ror #4
    1a30:	0212d501 	andseq	sp, r2, #4194304	; 0x400000
    1a34:	02000001 	andeq	r0, r0, #1
    1a38:	6b136c91 	blvs	4dcc84 <__bss_end+0x4d37dc>
    1a3c:	01000012 	tsteq	r0, r2, lsl r0
    1a40:	01041ed5 	ldrdeq	r1, [r4, -r5]
    1a44:	91020000 	mrsls	r0, (UNDEF: 2)
    1a48:	656d0e68 	strbvs	r0, [sp, #-3688]!	; 0xfffff198
    1a4c:	d701006d 	strle	r0, [r1, -sp, rrx]
    1a50:	00011608 	andeq	r1, r1, r8, lsl #12
    1a54:	70910200 	addsvc	r0, r1, r0, lsl #4
    1a58:	0091440d 	addseq	r4, r1, sp, lsl #8
    1a5c:	00003c00 	andeq	r3, r0, r0, lsl #24
    1a60:	00690e00 	rsbeq	r0, r9, r0, lsl #28
    1a64:	040bd901 	streq	sp, [fp], #-2305	; 0xfffff6ff
    1a68:	02000001 	andeq	r0, r0, #1
    1a6c:	00007491 	muleq	r0, r1, r4
    1a70:	00113414 	andseq	r3, r1, r4, lsl r4
    1a74:	05cb0100 	strbeq	r0, [fp, #256]	; 0x100
    1a78:	00001233 	andeq	r1, r0, r3, lsr r2
    1a7c:	00000104 	andeq	r0, r0, r4, lsl #2
    1a80:	000090d4 	ldrdeq	r9, [r0], -r4
    1a84:	00000054 	andeq	r0, r0, r4, asr r0
    1a88:	01b49c01 			; <UNDEFINED> instruction: 0x01b49c01
    1a8c:	730b0000 	movwvc	r0, #45056	; 0xb000
    1a90:	18cb0100 	stmiane	fp, {r8}^
    1a94:	00000110 	andeq	r0, r0, r0, lsl r1
    1a98:	0e6c9102 	lgneqe	f1, f2
    1a9c:	cd010069 	stcgt	0, cr0, [r1, #-420]	; 0xfffffe5c
    1aa0:	00010406 	andeq	r0, r1, r6, lsl #8
    1aa4:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1aa8:	121e1400 	andsne	r1, lr, #0, 8
    1aac:	bb010000 	bllt	41ab4 <__bss_end+0x3860c>
    1ab0:	00124005 	andseq	r4, r2, r5
    1ab4:	00010400 	andeq	r0, r1, r0, lsl #8
    1ab8:	00902800 	addseq	r2, r0, r0, lsl #16
    1abc:	0000ac00 	andeq	sl, r0, r0, lsl #24
    1ac0:	1a9c0100 	bne	fe701ec8 <__bss_end+0xfe6f8a20>
    1ac4:	0b000002 	bleq	1ad4 <shift+0x1ad4>
    1ac8:	01003173 	tsteq	r0, r3, ror r1
    1acc:	011019bb 			; <UNDEFINED> instruction: 0x011019bb
    1ad0:	91020000 	mrsls	r0, (UNDEF: 2)
    1ad4:	32730b6c 	rsbscc	r0, r3, #108, 22	; 0x1b000
    1ad8:	29bb0100 	ldmibcs	fp!, {r8}
    1adc:	00000110 	andeq	r0, r0, r0, lsl r1
    1ae0:	0b689102 	bleq	1a25ef0 <__bss_end+0x1a1ca48>
    1ae4:	006d756e 	rsbeq	r7, sp, lr, ror #10
    1ae8:	0431bb01 	ldrteq	fp, [r1], #-2817	; 0xfffff4ff
    1aec:	02000001 	andeq	r0, r0, #1
    1af0:	750e6491 	strvc	r6, [lr, #-1169]	; 0xfffffb6f
    1af4:	bd010031 	stclt	0, cr0, [r1, #-196]	; 0xffffff3c
    1af8:	00021a10 	andeq	r1, r2, r0, lsl sl
    1afc:	77910200 	ldrvc	r0, [r1, r0, lsl #4]
    1b00:	0032750e 	eorseq	r7, r2, lr, lsl #10
    1b04:	1a14bd01 	bne	530f10 <__bss_end+0x527a68>
    1b08:	02000002 	andeq	r0, r0, #2
    1b0c:	08007691 	stmdaeq	r0, {r0, r4, r7, r9, sl, ip, sp, lr}
    1b10:	072e0801 	streq	r0, [lr, -r1, lsl #16]!
    1b14:	5b140000 	blpl	501b1c <__bss_end+0x4f8674>
    1b18:	01000011 	tsteq	r0, r1, lsl r0
    1b1c:	11cb07ad 	bicne	r0, fp, sp, lsr #15
    1b20:	01160000 	tsteq	r6, r0
    1b24:	8f540000 	svchi	0x00540000
    1b28:	00d40000 	sbcseq	r0, r4, r0
    1b2c:	9c010000 	stcls	0, cr0, [r1], {-0}
    1b30:	00000278 	andeq	r0, r0, r8, ror r2
    1b34:	00114613 	andseq	r4, r1, r3, lsl r6
    1b38:	14ad0100 	strtne	r0, [sp], #256	; 0x100
    1b3c:	00000116 	andeq	r0, r0, r6, lsl r1
    1b40:	0b6c9102 	bleq	1b25f50 <__bss_end+0x1b1caa8>
    1b44:	00637273 	rsbeq	r7, r3, r3, ror r2
    1b48:	1026ad01 	eorne	sl, r6, r1, lsl #26
    1b4c:	02000001 	andeq	r0, r0, #1
    1b50:	690e6891 	stmdbvs	lr, {r0, r4, r7, fp, sp, lr}
    1b54:	09af0100 	stmibeq	pc!, {r8}	; <UNPREDICTABLE>
    1b58:	00000104 	andeq	r0, r0, r4, lsl #2
    1b5c:	0e749102 	expeqs	f1, f2
    1b60:	af01006a 	svcge	0x0001006a
    1b64:	0001040b 	andeq	r0, r1, fp, lsl #8
    1b68:	70910200 	addsvc	r0, r1, r0, lsl #4
    1b6c:	116e1400 	cmnne	lr, r0, lsl #8
    1b70:	a1010000 	mrsge	r0, (UNDEF: 1)
    1b74:	0011ba07 	andseq	fp, r1, r7, lsl #20
    1b78:	00011600 	andeq	r1, r1, r0, lsl #12
    1b7c:	008e9400 	addeq	r9, lr, r0, lsl #8
    1b80:	0000c000 	andeq	ip, r0, r0
    1b84:	d19c0100 	orrsle	r0, ip, r0, lsl #2
    1b88:	13000002 	movwne	r0, #2
    1b8c:	00001146 	andeq	r1, r0, r6, asr #2
    1b90:	1615a101 	ldrne	sl, [r5], -r1, lsl #2
    1b94:	02000001 	andeq	r0, r0, #1
    1b98:	730b6c91 	movwvc	r6, #48273	; 0xbc91
    1b9c:	01006372 	tsteq	r0, r2, ror r3
    1ba0:	011027a1 	tsteq	r0, r1, lsr #15
    1ba4:	91020000 	mrsls	r0, (UNDEF: 2)
    1ba8:	756e0b68 	strbvc	r0, [lr, #-2920]!	; 0xfffff498
    1bac:	a101006d 	tstge	r1, sp, rrx
    1bb0:	00010430 	andeq	r0, r1, r0, lsr r4
    1bb4:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1bb8:	0100690e 	tsteq	r0, lr, lsl #18
    1bbc:	010406a3 	smlatbeq	r4, r3, r6, r0
    1bc0:	91020000 	mrsls	r0, (UNDEF: 2)
    1bc4:	07150074 			; <UNDEFINED> instruction: 0x07150074
    1bc8:	01000012 	tsteq	r0, r2, lsl r0
    1bcc:	11760673 	cmnne	r6, r3, ror r6
    1bd0:	8c5c0000 	mrahi	r0, ip, acc0
    1bd4:	02380000 	eorseq	r0, r8, #0
    1bd8:	9c010000 	stcls	0, cr0, [r1], {-0}
    1bdc:	0000036d 	andeq	r0, r0, sp, ror #6
    1be0:	000fb913 	andeq	fp, pc, r3, lsl r9	; <UNPREDICTABLE>
    1be4:	11730100 	cmnne	r3, r0, lsl #2
    1be8:	00000116 	andeq	r0, r0, r6, lsl r1
    1bec:	135c9102 	cmpne	ip, #-2147483648	; 0x80000000
    1bf0:	00001114 	andeq	r1, r0, r4, lsl r1
    1bf4:	6d1f7301 	ldcvs	3, cr7, [pc, #-4]	; 1bf8 <shift+0x1bf8>
    1bf8:	02000003 	andeq	r0, r0, #3
    1bfc:	260c5891 			; <UNDEFINED> instruction: 0x260c5891
    1c00:	01000011 	tsteq	r0, r1, lsl r0
    1c04:	01040974 	tsteq	r4, r4, ror r9
    1c08:	91020000 	mrsls	r0, (UNDEF: 2)
    1c0c:	12720c74 	rsbsne	r0, r2, #116, 24	; 0x7400
    1c10:	75010000 	strvc	r0, [r1, #-0]
    1c14:	00010409 	andeq	r0, r1, r9, lsl #8
    1c18:	70910200 	addsvc	r0, r1, r0, lsl #4
    1c1c:	0012260c 	andseq	r2, r2, ip, lsl #12
    1c20:	0f760100 	svceq	0x00760100
    1c24:	0000010b 	andeq	r0, r0, fp, lsl #2
    1c28:	166c9102 	strbtne	r9, [ip], -r2, lsl #2
    1c2c:	00008d04 	andeq	r8, r0, r4, lsl #26
    1c30:	00000070 	andeq	r0, r0, r0, ror r0
    1c34:	00000353 	andeq	r0, r0, r3, asr r3
    1c38:	0011e90c 	andseq	lr, r1, ip, lsl #18
    1c3c:	0d860100 	stfeqs	f0, [r6]
    1c40:	00000104 	andeq	r0, r0, r4, lsl #2
    1c44:	00689102 	rsbeq	r9, r8, r2, lsl #2
    1c48:	008e000d 	addeq	r0, lr, sp
    1c4c:	00007000 	andeq	r7, r0, r0
    1c50:	11e90c00 	mvnne	r0, r0, lsl #24
    1c54:	99010000 	stmdbls	r1, {}	; <UNPREDICTABLE>
    1c58:	0001040d 	andeq	r0, r1, sp, lsl #8
    1c5c:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1c60:	04080000 	streq	r0, [r8], #-0
    1c64:	00156e04 	andseq	r6, r5, r4, lsl #28
    1c68:	11ef1400 	mvnne	r1, r0, lsl #8
    1c6c:	4a010000 	bmi	41c74 <__bss_end+0x387cc>
    1c70:	00113b07 	andseq	r3, r1, r7, lsl #22
    1c74:	00036d00 	andeq	r6, r3, r0, lsl #26
    1c78:	0089a800 	addeq	sl, r9, r0, lsl #16
    1c7c:	0002b400 	andeq	fp, r2, r0, lsl #8
    1c80:	ed9c0100 	ldfs	f0, [ip]
    1c84:	0b000003 	bleq	1c98 <shift+0x1c98>
    1c88:	4a010073 	bmi	41e5c <__bss_end+0x389b4>
    1c8c:	00011018 	andeq	r1, r1, r8, lsl r0
    1c90:	5c910200 	lfmpl	f0, 4, [r1], {0}
    1c94:	0100610e 	tsteq	r0, lr, lsl #2
    1c98:	036d094c 	cmneq	sp, #76, 18	; 0x130000
    1c9c:	91020000 	mrsls	r0, (UNDEF: 2)
    1ca0:	00650e74 	rsbeq	r0, r5, r4, ror lr
    1ca4:	04074d01 	streq	r4, [r7], #-3329	; 0xfffff2ff
    1ca8:	02000001 	andeq	r0, r0, #1
    1cac:	630e7091 	movwvs	r7, #57489	; 0xe091
    1cb0:	074e0100 	strbeq	r0, [lr, -r0, lsl #2]
    1cb4:	00000104 	andeq	r0, r0, r4, lsl #2
    1cb8:	0d6c9102 	stfeqp	f1, [ip, #-8]!
    1cbc:	00008af0 	strdeq	r8, [r0], -r0
    1cc0:	000000e0 	andeq	r0, r0, r0, ror #1
    1cc4:	0011510c 	andseq	r5, r1, ip, lsl #2
    1cc8:	09590100 	ldmdbeq	r9, {r8}^
    1ccc:	00000104 	andeq	r0, r0, r4, lsl #2
    1cd0:	0e689102 	lgneqe	f1, f2
    1cd4:	5a010069 	bpl	41e80 <__bss_end+0x389d8>
    1cd8:	00010409 	andeq	r0, r1, r9, lsl #8
    1cdc:	64910200 	ldrvs	r0, [r1], #512	; 0x200
    1ce0:	fa140000 	blx	501ce8 <__bss_end+0x4f8840>
    1ce4:	01000010 	tsteq	r0, r0, lsl r0
    1ce8:	11da0539 	bicsne	r0, sl, r9, lsr r5
    1cec:	01040000 	mrseq	r0, (UNDEF: 4)
    1cf0:	88e00000 	stmiahi	r0!, {}^	; <UNPREDICTABLE>
    1cf4:	00c80000 	sbceq	r0, r8, r0
    1cf8:	9c010000 	stcls	0, cr0, [r1], {-0}
    1cfc:	00000439 	andeq	r0, r0, r9, lsr r4
    1d00:	6c61760b 	stclvs	6, cr7, [r1], #-44	; 0xffffffd4
    1d04:	16390100 	ldrtne	r0, [r9], -r0, lsl #2
    1d08:	00000439 	andeq	r0, r0, r9, lsr r4
    1d0c:	0c6c9102 	stfeqp	f1, [ip], #-8
    1d10:	00001126 	andeq	r1, r0, r6, lsr #2
    1d14:	04093a01 	streq	r3, [r9], #-2561	; 0xfffff5ff
    1d18:	02000001 	andeq	r0, r0, #1
    1d1c:	140c7491 	strne	r7, [ip], #-1169	; 0xfffffb6f
    1d20:	01000011 	tsteq	r0, r1, lsl r0
    1d24:	036d0b3b 	cmneq	sp, #60416	; 0xec00
    1d28:	91020000 	mrsls	r0, (UNDEF: 2)
    1d2c:	040f0070 	streq	r0, [pc], #-112	; 1d34 <shift+0x1d34>
    1d30:	0000036d 	andeq	r0, r0, sp, ror #6
    1d34:	00112f14 	andseq	r2, r1, r4, lsl pc
    1d38:	05260100 	streq	r0, [r6, #-256]!	; 0xffffff00
    1d3c:	00001252 	andeq	r1, r0, r2, asr r2
    1d40:	00000104 	andeq	r0, r0, r4, lsl #2
    1d44:	00008844 	andeq	r8, r0, r4, asr #16
    1d48:	0000009c 	muleq	r0, ip, r0
    1d4c:	047c9c01 	ldrbteq	r9, [ip], #-3073	; 0xfffff3ff
    1d50:	4b130000 	blmi	4c1d58 <__bss_end+0x4b88b0>
    1d54:	01000011 	tsteq	r0, r1, lsl r0
    1d58:	01101626 	tsteq	r0, r6, lsr #12
    1d5c:	91020000 	mrsls	r0, (UNDEF: 2)
    1d60:	125d0c6c 	subsne	r0, sp, #108, 24	; 0x6c00
    1d64:	28010000 	stmdacs	r1, {}	; <UNPREDICTABLE>
    1d68:	00010406 	andeq	r0, r1, r6, lsl #8
    1d6c:	74910200 	ldrvc	r0, [r1], #512	; 0x200
    1d70:	11561700 	cmpne	r6, r0, lsl #14
    1d74:	0a010000 	beq	41d7c <__bss_end+0x388d4>
    1d78:	00111a06 	andseq	r1, r1, r6, lsl #20
    1d7c:	0086d000 	addeq	sp, r6, r0
    1d80:	00017400 	andeq	r7, r1, r0, lsl #8
    1d84:	139c0100 	orrsne	r0, ip, #0, 2
    1d88:	0000114b 	andeq	r1, r0, fp, asr #2
    1d8c:	66180a01 	ldrvs	r0, [r8], -r1, lsl #20
    1d90:	02000000 	andeq	r0, r0, #0
    1d94:	5d136491 	cfldrspl	mvf6, [r3, #-580]	; 0xfffffdbc
    1d98:	01000012 	tsteq	r0, r2, lsl r0
    1d9c:	0116250a 	tsteq	r6, sl, lsl #10
    1da0:	91020000 	mrsls	r0, (UNDEF: 2)
    1da4:	12191360 	andsne	r1, r9, #96, 6	; 0x80000001
    1da8:	0a010000 	beq	41db0 <__bss_end+0x38908>
    1dac:	0000663a 	andeq	r6, r0, sl, lsr r6
    1db0:	5c910200 	lfmpl	f0, 4, [r1], {0}
    1db4:	0100690e 	tsteq	r0, lr, lsl #18
    1db8:	0104060c 	tsteq	r4, ip, lsl #12
    1dbc:	91020000 	mrsls	r0, (UNDEF: 2)
    1dc0:	879c0d74 			; <UNDEFINED> instruction: 0x879c0d74
    1dc4:	00980000 	addseq	r0, r8, r0
    1dc8:	6a0e0000 	bvs	381dd0 <__bss_end+0x378928>
    1dcc:	0b1e0100 	bleq	7821d4 <__bss_end+0x778d2c>
    1dd0:	00000104 	andeq	r0, r0, r4, lsl #2
    1dd4:	0d709102 	ldfeqp	f1, [r0, #-8]!
    1dd8:	000087c4 	andeq	r8, r0, r4, asr #15
    1ddc:	00000060 	andeq	r0, r0, r0, rrx
    1de0:	0100630e 	tsteq	r0, lr, lsl #6
    1de4:	006d0820 	rsbeq	r0, sp, r0, lsr #16
    1de8:	91020000 	mrsls	r0, (UNDEF: 2)
    1dec:	0000006f 	andeq	r0, r0, pc, rrx
    1df0:	00002200 	andeq	r2, r0, r0, lsl #4
    1df4:	f0000200 			; <UNDEFINED> instruction: 0xf0000200
    1df8:	04000007 	streq	r0, [r0], #-7
    1dfc:	000abe01 	andeq	fp, sl, r1, lsl #28
    1e00:	00921000 	addseq	r1, r2, r0
    1e04:	00941c00 	addseq	r1, r4, r0, lsl #24
    1e08:	00127900 	andseq	r7, r2, r0, lsl #18
    1e0c:	0012a900 	andseq	sl, r2, r0, lsl #18
    1e10:	00006100 	andeq	r6, r0, r0, lsl #2
    1e14:	22800100 	addcs	r0, r0, #0, 2
    1e18:	02000000 	andeq	r0, r0, #0
    1e1c:	00080400 	andeq	r0, r8, r0, lsl #8
    1e20:	3b010400 	blcc	42e28 <__bss_end+0x39980>
    1e24:	1c00000b 	stcne	0, cr0, [r0], {11}
    1e28:	20000094 	mulcs	r0, r4, r0
    1e2c:	79000094 	stmdbvc	r0, {r2, r4, r7}
    1e30:	a9000012 	stmdbge	r0, {r1, r4}
    1e34:	61000012 	tstvs	r0, r2, lsl r0
    1e38:	01000000 	mrseq	r0, (UNDEF: 0)
    1e3c:	00093280 	andeq	r3, r9, r0, lsl #5
    1e40:	18000400 	stmdane	r0, {sl}
    1e44:	04000008 	streq	r0, [r0], #-8
    1e48:	00167701 	andseq	r7, r6, r1, lsl #14
    1e4c:	15ce0c00 	strbne	r0, [lr, #3072]	; 0xc00
    1e50:	12a90000 	adcne	r0, r9, #0
    1e54:	0b9b0000 	bleq	fe6c1e5c <__bss_end+0xfe6b89b4>
    1e58:	04020000 	streq	r0, [r2], #-0
    1e5c:	746e6905 	strbtvc	r6, [lr], #-2309	; 0xfffff6fb
    1e60:	07040300 	streq	r0, [r4, -r0, lsl #6]
    1e64:	000017a4 	andeq	r1, r0, r4, lsr #15
    1e68:	51050803 	tstpl	r5, r3, lsl #16
    1e6c:	03000003 	movweq	r0, #3
    1e70:	1e760408 	cdpne	4, 7, cr0, cr6, cr8, {0}
    1e74:	29040000 	stmdbcs	r4, {}	; <UNPREDICTABLE>
    1e78:	01000016 	tsteq	r0, r6, lsl r0
    1e7c:	0024162a 	eoreq	r1, r4, sl, lsr #12
    1e80:	98040000 	stmdals	r4, {}	; <UNPREDICTABLE>
    1e84:	0100001a 	tsteq	r0, sl, lsl r0
    1e88:	0051152f 	subseq	r1, r1, pc, lsr #10
    1e8c:	04050000 	streq	r0, [r5], #-0
    1e90:	00000057 	andeq	r0, r0, r7, asr r0
    1e94:	00003906 	andeq	r3, r0, r6, lsl #18
    1e98:	00006600 	andeq	r6, r0, r0, lsl #12
    1e9c:	00660700 	rsbeq	r0, r6, r0, lsl #14
    1ea0:	05000000 	streq	r0, [r0, #-0]
    1ea4:	00006c04 	andeq	r6, r0, r4, lsl #24
    1ea8:	ca040800 	bgt	103eb0 <__bss_end+0xfaa08>
    1eac:	01000021 	tsteq	r0, r1, lsr #32
    1eb0:	00790f36 	rsbseq	r0, r9, r6, lsr pc
    1eb4:	04050000 	streq	r0, [r5], #-0
    1eb8:	0000007f 	andeq	r0, r0, pc, ror r0
    1ebc:	00001d06 	andeq	r1, r0, r6, lsl #26
    1ec0:	00009300 	andeq	r9, r0, r0, lsl #6
    1ec4:	00660700 	rsbeq	r0, r6, r0, lsl #14
    1ec8:	66070000 	strvs	r0, [r7], -r0
    1ecc:	00000000 	andeq	r0, r0, r0
    1ed0:	2e080103 	adfcse	f0, f0, f3
    1ed4:	09000007 	stmdbeq	r0, {r0, r1, r2}
    1ed8:	00001cd0 	ldrdeq	r1, [r0], -r0
    1edc:	4512bb01 	ldrmi	fp, [r2, #-2817]	; 0xfffff4ff
    1ee0:	09000000 	stmdbeq	r0, {}	; <UNPREDICTABLE>
    1ee4:	000021f8 	strdeq	r2, [r0], -r8
    1ee8:	6d10be01 	ldcvs	14, cr11, [r0, #-4]
    1eec:	03000000 	movweq	r0, #0
    1ef0:	07300601 	ldreq	r0, [r0, -r1, lsl #12]!
    1ef4:	b80a0000 	stmdalt	sl, {}	; <UNPREDICTABLE>
    1ef8:	07000019 	smladeq	r0, r9, r0, r0
    1efc:	00009301 	andeq	r9, r0, r1, lsl #6
    1f00:	06170200 	ldreq	r0, [r7], -r0, lsl #4
    1f04:	000001e6 	andeq	r0, r0, r6, ror #3
    1f08:	0014870b 	andseq	r8, r4, fp, lsl #14
    1f0c:	d50b0000 	strle	r0, [fp, #-0]
    1f10:	01000018 	tsteq	r0, r8, lsl r0
    1f14:	001d9b0b 	andseq	r9, sp, fp, lsl #22
    1f18:	0c0b0200 	sfmeq	f0, 4, [fp], {-0}
    1f1c:	03000021 	movweq	r0, #33	; 0x21
    1f20:	001d3f0b 	andseq	r3, sp, fp, lsl #30
    1f24:	150b0400 	strne	r0, [fp, #-1024]	; 0xfffffc00
    1f28:	05000020 	streq	r0, [r0, #-32]	; 0xffffffe0
    1f2c:	001f790b 	andseq	r7, pc, fp, lsl #18
    1f30:	a80b0600 	stmdage	fp, {r9, sl}
    1f34:	07000014 	smladeq	r0, r4, r0, r0
    1f38:	00202a0b 	eoreq	r2, r0, fp, lsl #20
    1f3c:	380b0800 	stmdacc	fp, {fp}
    1f40:	09000020 	stmdbeq	r0, {r5}
    1f44:	0020ff0b 	eoreq	pc, r0, fp, lsl #30
    1f48:	960b0a00 	strls	r0, [fp], -r0, lsl #20
    1f4c:	0b00001c 	bleq	1fc4 <shift+0x1fc4>
    1f50:	00166a0b 	andseq	r6, r6, fp, lsl #20
    1f54:	470b0c00 	strmi	r0, [fp, -r0, lsl #24]
    1f58:	0d000017 	stceq	0, cr0, [r0, #-92]	; 0xffffffa4
    1f5c:	0019fc0b 	andseq	pc, r9, fp, lsl #24
    1f60:	120b0e00 	andne	r0, fp, #0, 28
    1f64:	0f00001a 	svceq	0x0000001a
    1f68:	00190f0b 	andseq	r0, r9, fp, lsl #30
    1f6c:	230b1000 	movwcs	r1, #45056	; 0xb000
    1f70:	1100001d 	tstne	r0, sp, lsl r0
    1f74:	00197b0b 	andseq	r7, r9, fp, lsl #22
    1f78:	910b1200 	mrsls	r1, R11_fiq
    1f7c:	13000023 	movwne	r0, #35	; 0x23
    1f80:	0015110b 	andseq	r1, r5, fp, lsl #2
    1f84:	9f0b1400 	svcls	0x000b1400
    1f88:	15000019 	strne	r0, [r0, #-25]	; 0xffffffe7
    1f8c:	00144e0b 	andseq	r4, r4, fp, lsl #28
    1f90:	2f0b1600 	svccs	0x000b1600
    1f94:	17000021 	strne	r0, [r0, -r1, lsr #32]
    1f98:	0022510b 	eoreq	r5, r2, fp, lsl #2
    1f9c:	c40b1800 	strgt	r1, [fp], #-2048	; 0xfffff800
    1fa0:	19000019 	stmdbne	r0, {r0, r3, r4}
    1fa4:	001e0d0b 	andseq	r0, lr, fp, lsl #26
    1fa8:	3d0b1a00 	vstrcc	s2, [fp, #-0]
    1fac:	1b000021 	blne	2038 <shift+0x2038>
    1fb0:	00137d0b 	andseq	r7, r3, fp, lsl #26
    1fb4:	4b0b1c00 	blmi	2c8fbc <__bss_end+0x2bfb14>
    1fb8:	1d000021 	stcne	0, cr0, [r0, #-132]	; 0xffffff7c
    1fbc:	0021590b 	eoreq	r5, r1, fp, lsl #18
    1fc0:	2b0b1e00 	blcs	2c97c8 <__bss_end+0x2c0320>
    1fc4:	1f000013 	svcne	0x00000013
    1fc8:	0021830b 	eoreq	r8, r1, fp, lsl #6
    1fcc:	ba0b2000 	blt	2c9fd4 <__bss_end+0x2c0b2c>
    1fd0:	2100001e 	tstcs	r0, lr, lsl r0
    1fd4:	001cf50b 	andseq	pc, ip, fp, lsl #10
    1fd8:	220b2200 	andcs	r2, fp, #0, 4
    1fdc:	23000021 	movwcs	r0, #33	; 0x21
    1fe0:	001bf90b 	andseq	pc, fp, fp, lsl #18
    1fe4:	fb0b2400 	blx	2cafee <__bss_end+0x2c1b46>
    1fe8:	2500001a 	strcs	r0, [r0, #-26]	; 0xffffffe6
    1fec:	0018150b 	andseq	r1, r8, fp, lsl #10
    1ff0:	190b2600 	stmdbne	fp, {r9, sl, sp}
    1ff4:	2700001b 	smladcs	r0, fp, r0, r0
    1ff8:	0018b10b 	andseq	fp, r8, fp, lsl #2
    1ffc:	290b2800 	stmdbcs	fp, {fp, sp}
    2000:	2900001b 	stmdbcs	r0, {r0, r1, r3, r4}
    2004:	001b390b 	andseq	r3, fp, fp, lsl #18
    2008:	7c0b2a00 			; <UNDEFINED> instruction: 0x7c0b2a00
    200c:	2b00001c 	blcs	2084 <shift+0x2084>
    2010:	001aa20b 	andseq	sl, sl, fp, lsl #4
    2014:	c70b2c00 	strgt	r2, [fp, -r0, lsl #24]
    2018:	2d00001e 	stccs	0, cr0, [r0, #-120]	; 0xffffff88
    201c:	0018560b 	andseq	r5, r8, fp, lsl #12
    2020:	0a002e00 	beq	d828 <__bss_end+0x4380>
    2024:	00001a34 	andeq	r1, r0, r4, lsr sl
    2028:	00930107 	addseq	r0, r3, r7, lsl #2
    202c:	17030000 	strne	r0, [r3, -r0]
    2030:	0003c706 	andeq	ip, r3, r6, lsl #14
    2034:	17690b00 	strbne	r0, [r9, -r0, lsl #22]!
    2038:	0b000000 	bleq	2040 <shift+0x2040>
    203c:	000013bb 			; <UNDEFINED> instruction: 0x000013bb
    2040:	233f0b01 	teqcs	pc, #1024	; 0x400
    2044:	0b020000 	bleq	8204c <__bss_end+0x78ba4>
    2048:	000021d2 	ldrdeq	r2, [r0], -r2	; <UNPREDICTABLE>
    204c:	17890b03 	strne	r0, [r9, r3, lsl #22]
    2050:	0b040000 	bleq	102058 <__bss_end+0xf8bb0>
    2054:	00001473 	andeq	r1, r0, r3, ror r4
    2058:	18320b05 	ldmdane	r2!, {r0, r2, r8, r9, fp}
    205c:	0b060000 	bleq	182064 <__bss_end+0x178bbc>
    2060:	00001779 	andeq	r1, r0, r9, ror r7
    2064:	20660b07 	rsbcs	r0, r6, r7, lsl #22
    2068:	0b080000 	bleq	202070 <__bss_end+0x1f8bc8>
    206c:	000021b7 			; <UNDEFINED> instruction: 0x000021b7
    2070:	1f9d0b09 	svcne	0x009d0b09
    2074:	0b0a0000 	bleq	28207c <__bss_end+0x278bd4>
    2078:	000014c6 	andeq	r1, r0, r6, asr #9
    207c:	17d30b0b 	ldrbne	r0, [r3, fp, lsl #22]
    2080:	0b0c0000 	bleq	302088 <__bss_end+0x2f8be0>
    2084:	0000143c 	andeq	r1, r0, ip, lsr r4
    2088:	23740b0d 	cmncs	r4, #13312	; 0x3400
    208c:	0b0e0000 	bleq	382094 <__bss_end+0x378bec>
    2090:	00001c69 	andeq	r1, r0, r9, ror #24
    2094:	19460b0f 	stmdbne	r6, {r0, r1, r2, r3, r8, r9, fp}^
    2098:	0b100000 	bleq	4020a0 <__bss_end+0x3f8bf8>
    209c:	00001ca6 	andeq	r1, r0, r6, lsr #25
    20a0:	22930b11 	addscs	r0, r3, #17408	; 0x4400
    20a4:	0b120000 	bleq	4820ac <__bss_end+0x478c04>
    20a8:	00001589 	andeq	r1, r0, r9, lsl #11
    20ac:	19590b13 	ldmdbne	r9, {r0, r1, r4, r8, r9, fp}^
    20b0:	0b140000 	bleq	5020b8 <__bss_end+0x4f8c10>
    20b4:	00001bbc 			; <UNDEFINED> instruction: 0x00001bbc
    20b8:	17540b15 	smmlane	r4, r5, fp, r0
    20bc:	0b160000 	bleq	5820c4 <__bss_end+0x578c1c>
    20c0:	00001c08 	andeq	r1, r0, r8, lsl #24
    20c4:	1a1e0b17 	bne	784d28 <__bss_end+0x77b880>
    20c8:	0b180000 	bleq	6020d0 <__bss_end+0x5f8c28>
    20cc:	00001491 	muleq	r0, r1, r4
    20d0:	223a0b19 	eorscs	r0, sl, #25600	; 0x6400
    20d4:	0b1a0000 	bleq	6820dc <__bss_end+0x678c34>
    20d8:	00001b88 	andeq	r1, r0, r8, lsl #23
    20dc:	19300b1b 	ldmdbne	r0!, {r0, r1, r3, r4, r8, r9, fp}
    20e0:	0b1c0000 	bleq	7020e8 <__bss_end+0x6f8c40>
    20e4:	00001366 	andeq	r1, r0, r6, ror #6
    20e8:	1ad30b1d 	bne	ff4c4d64 <__bss_end+0xff4bb8bc>
    20ec:	0b1e0000 	bleq	7820f4 <__bss_end+0x778c4c>
    20f0:	00001abf 			; <UNDEFINED> instruction: 0x00001abf
    20f4:	1f5a0b1f 	svcne	0x005a0b1f
    20f8:	0b200000 	bleq	802100 <__bss_end+0x7f8c58>
    20fc:	00001fe5 	andeq	r1, r0, r5, ror #31
    2100:	22190b21 	andscs	r0, r9, #33792	; 0x8400
    2104:	0b220000 	bleq	88210c <__bss_end+0x878c64>
    2108:	00001863 	andeq	r1, r0, r3, ror #16
    210c:	1dbd0b23 			; <UNDEFINED> instruction: 0x1dbd0b23
    2110:	0b240000 	bleq	902118 <__bss_end+0x8f8c70>
    2114:	00001fb2 			; <UNDEFINED> instruction: 0x00001fb2
    2118:	1ed60b25 	vfnmsne.f64	d16, d6, d21
    211c:	0b260000 	bleq	982124 <__bss_end+0x978c7c>
    2120:	00001eea 	andeq	r1, r0, sl, ror #29
    2124:	1efe0b27 			; <UNDEFINED> instruction: 0x1efe0b27
    2128:	0b280000 	bleq	a02130 <__bss_end+0x9f8c88>
    212c:	00001614 	andeq	r1, r0, r4, lsl r6
    2130:	15740b29 	ldrbne	r0, [r4, #-2857]!	; 0xfffff4d7
    2134:	0b2a0000 	bleq	a8213c <__bss_end+0xa78c94>
    2138:	0000159c 	muleq	r0, ip, r5
    213c:	20af0b2b 	adccs	r0, pc, fp, lsr #22
    2140:	0b2c0000 	bleq	b02148 <__bss_end+0xaf8ca0>
    2144:	000015f1 	strdeq	r1, [r0], -r1	; <UNPREDICTABLE>
    2148:	20c30b2d 	sbccs	r0, r3, sp, lsr #22
    214c:	0b2e0000 	bleq	b82154 <__bss_end+0xb78cac>
    2150:	000020d7 	ldrdeq	r2, [r0], -r7
    2154:	20eb0b2f 	rsccs	r0, fp, pc, lsr #22
    2158:	0b300000 	bleq	c02160 <__bss_end+0xbf8cb8>
    215c:	000017e5 	andeq	r1, r0, r5, ror #15
    2160:	17bf0b31 			; <UNDEFINED> instruction: 0x17bf0b31
    2164:	0b320000 	bleq	c8216c <__bss_end+0xc78cc4>
    2168:	00001ae7 	andeq	r1, r0, r7, ror #21
    216c:	1cb90b33 	fldmiaxne	r9!, {d0-d24}	;@ Deprecated
    2170:	0b340000 	bleq	d02178 <__bss_end+0xcf8cd0>
    2174:	000022c8 	andeq	r2, r0, r8, asr #5
    2178:	130e0b35 	movwne	r0, #60213	; 0xeb35
    217c:	0b360000 	bleq	d82184 <__bss_end+0xd78cdc>
    2180:	000018e5 	andeq	r1, r0, r5, ror #17
    2184:	18fa0b37 	ldmne	sl!, {r0, r1, r2, r4, r5, r8, r9, fp}^
    2188:	0b380000 	bleq	e02190 <__bss_end+0xdf8ce8>
    218c:	00001b49 	andeq	r1, r0, r9, asr #22
    2190:	1b730b39 	blne	1cc4e7c <__bss_end+0x1cbb9d4>
    2194:	0b3a0000 	bleq	e8219c <__bss_end+0xe78cf4>
    2198:	000022f1 	strdeq	r2, [r0], -r1
    219c:	1da80b3b 			; <UNDEFINED> instruction: 0x1da80b3b
    21a0:	0b3c0000 	bleq	f021a8 <__bss_end+0xef8d00>
    21a4:	00001888 	andeq	r1, r0, r8, lsl #17
    21a8:	13cd0b3d 	bicne	r0, sp, #62464	; 0xf400
    21ac:	0b3e0000 	bleq	f821b4 <__bss_end+0xf78d0c>
    21b0:	0000138b 	andeq	r1, r0, fp, lsl #7
    21b4:	1d050b3f 	vstrne	d0, [r5, #-252]	; 0xffffff04
    21b8:	0b400000 	bleq	10021c0 <__bss_end+0xff8d18>
    21bc:	00001e29 	andeq	r1, r0, r9, lsr #28
    21c0:	1f3c0b41 	svcne	0x003c0b41
    21c4:	0b420000 	bleq	10821cc <__bss_end+0x1078d24>
    21c8:	00001b5e 	andeq	r1, r0, lr, asr fp
    21cc:	232a0b43 			; <UNDEFINED> instruction: 0x232a0b43
    21d0:	0b440000 	bleq	11021d8 <__bss_end+0x10f8d30>
    21d4:	00001dd3 	ldrdeq	r1, [r0], -r3
    21d8:	15b80b45 	ldrne	r0, [r8, #2885]!	; 0xb45
    21dc:	0b460000 	bleq	11821e4 <__bss_end+0x1178d3c>
    21e0:	00001c39 	andeq	r1, r0, r9, lsr ip
    21e4:	1a6c0b47 	bne	1b04f08 <__bss_end+0x1afba60>
    21e8:	0b480000 	bleq	12021f0 <__bss_end+0x11f8d48>
    21ec:	0000134a 	andeq	r1, r0, sl, asr #6
    21f0:	145e0b49 	ldrbne	r0, [lr], #-2889	; 0xfffff4b7
    21f4:	0b4a0000 	bleq	12821fc <__bss_end+0x1278d54>
    21f8:	0000189c 	muleq	r0, ip, r8
    21fc:	1b9a0b4b 	blne	fe684f30 <__bss_end+0xfe67ba88>
    2200:	004c0000 	subeq	r0, ip, r0
    2204:	75070203 	strvc	r0, [r7, #-515]	; 0xfffffdfd
    2208:	0c000008 	stceq	0, cr0, [r0], {8}
    220c:	000003e4 	andeq	r0, r0, r4, ror #7
    2210:	000003d9 	ldrdeq	r0, [r0], -r9
    2214:	ce0e000d 	cdpgt	0, 0, cr0, cr14, cr13, {0}
    2218:	05000003 	streq	r0, [r0, #-3]
    221c:	0003f004 	andeq	pc, r3, r4
    2220:	03de0e00 	bicseq	r0, lr, #0, 28
    2224:	01030000 	mrseq	r0, (UNDEF: 3)
    2228:	00073708 	andeq	r3, r7, r8, lsl #14
    222c:	03e90e00 	mvneq	r0, #0, 28
    2230:	020f0000 	andeq	r0, pc, #0
    2234:	04000015 	streq	r0, [r0], #-21	; 0xffffffeb
    2238:	d91a014c 	ldmdble	sl, {r2, r3, r6, r8}
    223c:	0f000003 	svceq	0x00000003
    2240:	00001920 	andeq	r1, r0, r0, lsr #18
    2244:	1a018204 	bne	62a5c <__bss_end+0x595b4>
    2248:	000003d9 	ldrdeq	r0, [r0], -r9
    224c:	0003e90c 	andeq	lr, r3, ip, lsl #18
    2250:	00041a00 	andeq	r1, r4, r0, lsl #20
    2254:	09000d00 	stmdbeq	r0, {r8, sl, fp}
    2258:	00001b0b 	andeq	r1, r0, fp, lsl #22
    225c:	0f0d2d05 	svceq	0x000d2d05
    2260:	09000004 	stmdbeq	r0, {r2}
    2264:	00002193 	muleq	r0, r3, r1
    2268:	e61c3805 	ldr	r3, [ip], -r5, lsl #16
    226c:	0a000001 	beq	2278 <shift+0x2278>
    2270:	000017f9 	strdeq	r1, [r0], -r9
    2274:	00930107 	addseq	r0, r3, r7, lsl #2
    2278:	3a050000 	bcc	142280 <__bss_end+0x138dd8>
    227c:	0004a50e 	andeq	sl, r4, lr, lsl #10
    2280:	135f0b00 	cmpne	pc, #0, 22
    2284:	0b000000 	bleq	228c <shift+0x228c>
    2288:	00001a0b 	andeq	r1, r0, fp, lsl #20
    228c:	22a50b01 	adccs	r0, r5, #1024	; 0x400
    2290:	0b020000 	bleq	82298 <__bss_end+0x78df0>
    2294:	00002268 	andeq	r2, r0, r8, ror #4
    2298:	1d620b03 	fstmdbxne	r2!, {d16}	;@ Deprecated
    229c:	0b040000 	bleq	1022a4 <__bss_end+0xf8dfc>
    22a0:	00002023 	andeq	r2, r0, r3, lsr #32
    22a4:	15450b05 	strbne	r0, [r5, #-2821]	; 0xfffff4fb
    22a8:	0b060000 	bleq	1822b0 <__bss_end+0x178e08>
    22ac:	00001527 	andeq	r1, r0, r7, lsr #10
    22b0:	17400b07 	strbne	r0, [r0, -r7, lsl #22]
    22b4:	0b080000 	bleq	2022bc <__bss_end+0x1f8e14>
    22b8:	00001c1e 	andeq	r1, r0, lr, lsl ip
    22bc:	154c0b09 	strbne	r0, [ip, #-2825]	; 0xfffff4f7
    22c0:	0b0a0000 	bleq	2822c8 <__bss_end+0x278e20>
    22c4:	00001c25 	andeq	r1, r0, r5, lsr #24
    22c8:	15b10b0b 	ldrne	r0, [r1, #2827]!	; 0xb0b
    22cc:	0b0c0000 	bleq	3022d4 <__bss_end+0x2f8e2c>
    22d0:	0000153e 	andeq	r1, r0, lr, lsr r5
    22d4:	207a0b0d 	rsbscs	r0, sl, sp, lsl #22
    22d8:	0b0e0000 	bleq	3822e0 <__bss_end+0x378e38>
    22dc:	00001e47 	andeq	r1, r0, r7, asr #28
    22e0:	7204000f 	andvc	r0, r4, #15
    22e4:	0500001f 	streq	r0, [r0, #-31]	; 0xffffffe1
    22e8:	0432013f 	ldrteq	r0, [r2], #-319	; 0xfffffec1
    22ec:	06090000 	streq	r0, [r9], -r0
    22f0:	05000020 	streq	r0, [r0, #-32]	; 0xffffffe0
    22f4:	04a50f41 	strteq	r0, [r5], #3905	; 0xf41
    22f8:	8e090000 	cdphi	0, 0, cr0, cr9, cr0, {0}
    22fc:	05000020 	streq	r0, [r0, #-32]	; 0xffffffe0
    2300:	001d0c4a 	andseq	r0, sp, sl, asr #24
    2304:	e6090000 	str	r0, [r9], -r0
    2308:	05000014 	streq	r0, [r0, #-20]	; 0xffffffec
    230c:	001d0c4b 	andseq	r0, sp, fp, asr #24
    2310:	67100000 	ldrvs	r0, [r0, -r0]
    2314:	09000021 	stmdbeq	r0, {r0, r5}
    2318:	0000209f 	muleq	r0, pc, r0	; <UNPREDICTABLE>
    231c:	e6144c05 	ldr	r4, [r4], -r5, lsl #24
    2320:	05000004 	streq	r0, [r0, #-4]
    2324:	0004d504 	andeq	sp, r4, r4, lsl #10
    2328:	d5091100 	strle	r1, [r9, #-256]	; 0xffffff00
    232c:	05000019 	streq	r0, [r0, #-25]	; 0xffffffe7
    2330:	04f90f4e 	ldrbteq	r0, [r9], #3918	; 0xf4e
    2334:	04050000 	streq	r0, [r5], #-0
    2338:	000004ec 	andeq	r0, r0, ip, ror #9
    233c:	001f8812 	andseq	r8, pc, r2, lsl r8	; <UNPREDICTABLE>
    2340:	1d4f0900 	vstrne.16	s1, [pc, #-0]	; 2348 <shift+0x2348>	; <UNPREDICTABLE>
    2344:	52050000 	andpl	r0, r5, #0
    2348:	0005100d 	andeq	r1, r5, sp
    234c:	ff040500 			; <UNDEFINED> instruction: 0xff040500
    2350:	13000004 	movwne	r0, #4
    2354:	0000165d 	andeq	r1, r0, sp, asr r6
    2358:	01670534 	cmneq	r7, r4, lsr r5
    235c:	00054115 	andeq	r4, r5, r5, lsl r1
    2360:	1b141400 	blne	507368 <__bss_end+0x4fdec0>
    2364:	69050000 	stmdbvs	r5, {}	; <UNPREDICTABLE>
    2368:	03de0f01 	bicseq	r0, lr, #1, 30
    236c:	14000000 	strne	r0, [r0], #-0
    2370:	00001641 	andeq	r1, r0, r1, asr #12
    2374:	14016a05 	strne	r6, [r1], #-2565	; 0xfffff5fb
    2378:	00000546 	andeq	r0, r0, r6, asr #10
    237c:	160e0004 	strne	r0, [lr], -r4
    2380:	0c000005 	stceq	0, cr0, [r0], {5}
    2384:	000000b9 	strheq	r0, [r0], -r9
    2388:	00000556 	andeq	r0, r0, r6, asr r5
    238c:	00002415 	andeq	r2, r0, r5, lsl r4
    2390:	0c002d00 	stceq	13, cr2, [r0], {-0}
    2394:	00000541 	andeq	r0, r0, r1, asr #10
    2398:	00000561 	andeq	r0, r0, r1, ror #10
    239c:	560e000d 	strpl	r0, [lr], -sp
    23a0:	0f000005 	svceq	0x00000005
    23a4:	00001a43 	andeq	r1, r0, r3, asr #20
    23a8:	03016b05 	movweq	r6, #6917	; 0x1b05
    23ac:	00000561 	andeq	r0, r0, r1, ror #10
    23b0:	001c890f 	andseq	r8, ip, pc, lsl #18
    23b4:	016e0500 	cmneq	lr, r0, lsl #10
    23b8:	00001d0c 	andeq	r1, r0, ip, lsl #26
    23bc:	1fc61600 	svcne	0x00c61600
    23c0:	01070000 	mrseq	r0, (UNDEF: 7)
    23c4:	00000093 	muleq	r0, r3, r0
    23c8:	06018105 	streq	r8, [r1], -r5, lsl #2
    23cc:	0000062a 	andeq	r0, r0, sl, lsr #12
    23d0:	0013f40b 	andseq	pc, r3, fp, lsl #8
    23d4:	000b0000 	andeq	r0, fp, r0
    23d8:	02000014 	andeq	r0, r0, #20
    23dc:	00140c0b 	andseq	r0, r4, fp, lsl #24
    23e0:	250b0300 	strcs	r0, [fp, #-768]	; 0xfffffd00
    23e4:	03000018 	movweq	r0, #24
    23e8:	0014180b 	andseq	r1, r4, fp, lsl #16
    23ec:	6e0b0400 	cfcpysvs	mvf0, mvf11
    23f0:	04000019 	streq	r0, [r0], #-25	; 0xffffffe7
    23f4:	001a540b 	andseq	r5, sl, fp, lsl #8
    23f8:	aa0b0500 	bge	2c3800 <__bss_end+0x2ba358>
    23fc:	05000019 	streq	r0, [r0, #-25]	; 0xffffffe7
    2400:	0014d70b 	andseq	sp, r4, fp, lsl #14
    2404:	240b0500 	strcs	r0, [fp], #-1280	; 0xfffffb00
    2408:	06000014 			; <UNDEFINED> instruction: 0x06000014
    240c:	001bd20b 	andseq	sp, fp, fp, lsl #4
    2410:	330b0600 	movwcc	r0, #46592	; 0xb600
    2414:	06000016 			; <UNDEFINED> instruction: 0x06000016
    2418:	001bdf0b 	andseq	sp, fp, fp, lsl #30
    241c:	460b0600 	strmi	r0, [fp], -r0, lsl #12
    2420:	06000020 	streq	r0, [r0], -r0, lsr #32
    2424:	001bec0b 	andseq	lr, fp, fp, lsl #24
    2428:	2c0b0600 	stccs	6, cr0, [fp], {-0}
    242c:	0600001c 			; <UNDEFINED> instruction: 0x0600001c
    2430:	0014300b 	andseq	r3, r4, fp
    2434:	320b0700 	andcc	r0, fp, #0, 14
    2438:	0700001d 	smladeq	r0, sp, r0, r0
    243c:	001d7f0b 	andseq	r7, sp, fp, lsl #30
    2440:	810b0700 	tsthi	fp, r0, lsl #14
    2444:	07000020 	streq	r0, [r0, -r0, lsr #32]
    2448:	0016060b 	andseq	r0, r6, fp, lsl #12
    244c:	000b0700 	andeq	r0, fp, r0, lsl #14
    2450:	0800001e 	stmdaeq	r0, {r1, r2, r3, r4}
    2454:	0013a90b 	andseq	sl, r3, fp, lsl #18
    2458:	540b0800 	strpl	r0, [fp], #-2048	; 0xfffff800
    245c:	08000020 	stmdaeq	r0, {r5}
    2460:	001e1c0b 	andseq	r1, lr, fp, lsl #24
    2464:	0f000800 	svceq	0x00000800
    2468:	000022ba 			; <UNDEFINED> instruction: 0x000022ba
    246c:	1f019f05 	svcne	0x00019f05
    2470:	00000580 	andeq	r0, r0, r0, lsl #11
    2474:	001e4e0f 	andseq	r4, lr, pc, lsl #28
    2478:	01a20500 			; <UNDEFINED> instruction: 0x01a20500
    247c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2480:	1a610f00 	bne	1846088 <__bss_end+0x183cbe0>
    2484:	a5050000 	strge	r0, [r5, #-0]
    2488:	001d0c01 	andseq	r0, sp, r1, lsl #24
    248c:	860f0000 	strhi	r0, [pc], -r0
    2490:	05000023 	streq	r0, [r0, #-35]	; 0xffffffdd
    2494:	1d0c01a8 	stfnes	f0, [ip, #-672]	; 0xfffffd60
    2498:	0f000000 	svceq	0x00000000
    249c:	000014f6 	strdeq	r1, [r0], -r6
    24a0:	0c01ab05 			; <UNDEFINED> instruction: 0x0c01ab05
    24a4:	0000001d 	andeq	r0, r0, sp, lsl r0
    24a8:	001e580f 	andseq	r5, lr, pc, lsl #16
    24ac:	01ae0500 			; <UNDEFINED> instruction: 0x01ae0500
    24b0:	00001d0c 	andeq	r1, r0, ip, lsl #26
    24b4:	1d690f00 	stclne	15, cr0, [r9, #-0]
    24b8:	b1050000 	mrslt	r0, (UNDEF: 5)
    24bc:	001d0c01 	andseq	r0, sp, r1, lsl #24
    24c0:	740f0000 	strvc	r0, [pc], #-0	; 24c8 <shift+0x24c8>
    24c4:	0500001d 	streq	r0, [r0, #-29]	; 0xffffffe3
    24c8:	1d0c01b4 	stfnes	f0, [ip, #-720]	; 0xfffffd30
    24cc:	0f000000 	svceq	0x00000000
    24d0:	00001e62 	andeq	r1, r0, r2, ror #28
    24d4:	0c01b705 	stceq	7, cr11, [r1], {5}
    24d8:	0000001d 	andeq	r0, r0, sp, lsl r0
    24dc:	001bae0f 	andseq	sl, fp, pc, lsl #28
    24e0:	01ba0500 			; <UNDEFINED> instruction: 0x01ba0500
    24e4:	00001d0c 	andeq	r1, r0, ip, lsl #26
    24e8:	22e50f00 	rsccs	r0, r5, #0, 30
    24ec:	bd050000 	stclt	0, cr0, [r5, #-0]
    24f0:	001d0c01 	andseq	r0, sp, r1, lsl #24
    24f4:	6c0f0000 	stcvs	0, cr0, [pc], {-0}
    24f8:	0500001e 	streq	r0, [r0, #-30]	; 0xffffffe2
    24fc:	1d0c01c0 	stfnes	f0, [ip, #-768]	; 0xfffffd00
    2500:	0f000000 	svceq	0x00000000
    2504:	000023a9 	andeq	r2, r0, r9, lsr #7
    2508:	0c01c305 	stceq	3, cr12, [r1], {5}
    250c:	0000001d 	andeq	r0, r0, sp, lsl r0
    2510:	00226f0f 	eoreq	r6, r2, pc, lsl #30
    2514:	01c60500 	biceq	r0, r6, r0, lsl #10
    2518:	00001d0c 	andeq	r1, r0, ip, lsl #26
    251c:	227b0f00 	rsbscs	r0, fp, #0, 30
    2520:	c9050000 	stmdbgt	r5, {}	; <UNPREDICTABLE>
    2524:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2528:	870f0000 	strhi	r0, [pc, -r0]
    252c:	05000022 	streq	r0, [r0, #-34]	; 0xffffffde
    2530:	1d0c01cc 	stfnes	f0, [ip, #-816]	; 0xfffffcd0
    2534:	0f000000 	svceq	0x00000000
    2538:	000022ac 	andeq	r2, r0, ip, lsr #5
    253c:	0c01d005 	stceq	0, cr13, [r1], {5}
    2540:	0000001d 	andeq	r0, r0, sp, lsl r0
    2544:	00239c0f 	eoreq	r9, r3, pc, lsl #24
    2548:	01d30500 	bicseq	r0, r3, r0, lsl #10
    254c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2550:	15530f00 	ldrbne	r0, [r3, #-3840]	; 0xfffff100
    2554:	d6050000 	strle	r0, [r5], -r0
    2558:	001d0c01 	andseq	r0, sp, r1, lsl #24
    255c:	3a0f0000 	bcc	3c2564 <__bss_end+0x3b90bc>
    2560:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
    2564:	1d0c01d9 	stfnes	f0, [ip, #-868]	; 0xfffffc9c
    2568:	0f000000 	svceq	0x00000000
    256c:	00001845 	andeq	r1, r0, r5, asr #16
    2570:	0c01dc05 	stceq	12, cr13, [r1], {5}
    2574:	0000001d 	andeq	r0, r0, sp, lsl r0
    2578:	00152e0f 	andseq	r2, r5, pc, lsl #28
    257c:	01df0500 	bicseq	r0, pc, r0, lsl #10
    2580:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2584:	1e820f00 	cdpne	15, 8, cr0, cr2, cr0, {0}
    2588:	e2050000 	and	r0, r5, #0
    258c:	001d0c01 	andseq	r0, sp, r1, lsl #24
    2590:	8a0f0000 	bhi	3c2598 <__bss_end+0x3b90f0>
    2594:	0500001a 	streq	r0, [r0, #-26]	; 0xffffffe6
    2598:	1d0c01e5 	stfnes	f0, [ip, #-916]	; 0xfffffc6c
    259c:	0f000000 	svceq	0x00000000
    25a0:	00001ce2 	andeq	r1, r0, r2, ror #25
    25a4:	0c01e805 	stceq	8, cr14, [r1], {5}
    25a8:	0000001d 	andeq	r0, r0, sp, lsl r0
    25ac:	00219c0f 	eoreq	r9, r1, pc, lsl #24
    25b0:	01ef0500 	mvneq	r0, r0, lsl #10
    25b4:	00001d0c 	andeq	r1, r0, ip, lsl #26
    25b8:	23540f00 	cmpcs	r4, #0, 30
    25bc:	f2050000 	vhadd.s8	d0, d5, d0
    25c0:	001d0c01 	andseq	r0, sp, r1, lsl #24
    25c4:	640f0000 	strvs	r0, [pc], #-0	; 25cc <shift+0x25cc>
    25c8:	05000023 	streq	r0, [r0, #-35]	; 0xffffffdd
    25cc:	1d0c01f5 	stfnes	f0, [ip, #-980]	; 0xfffffc2c
    25d0:	0f000000 	svceq	0x00000000
    25d4:	0000164a 	andeq	r1, r0, sl, asr #12
    25d8:	0c01f805 	stceq	8, cr15, [r1], {5}
    25dc:	0000001d 	andeq	r0, r0, sp, lsl r0
    25e0:	0021e30f 	eoreq	lr, r1, pc, lsl #6
    25e4:	01fb0500 	mvnseq	r0, r0, lsl #10
    25e8:	00001d0c 	andeq	r1, r0, ip, lsl #26
    25ec:	1de80f00 	stclne	15, cr0, [r8]
    25f0:	fe050000 	cdp2	0, 0, cr0, cr5, cr0, {0}
    25f4:	001d0c01 	andseq	r0, sp, r1, lsl #24
    25f8:	be0f0000 	cdplt	0, 0, cr0, cr15, cr0, {0}
    25fc:	05000018 	streq	r0, [r0, #-24]	; 0xffffffe8
    2600:	1d0c0202 	sfmne	f0, 4, [ip, #-8]
    2604:	0f000000 	svceq	0x00000000
    2608:	00001fd8 	ldrdeq	r1, [r0], -r8
    260c:	0c020a05 			; <UNDEFINED> instruction: 0x0c020a05
    2610:	0000001d 	andeq	r0, r0, sp, lsl r0
    2614:	0017b10f 	andseq	fp, r7, pc, lsl #2
    2618:	020d0500 	andeq	r0, sp, #0, 10
    261c:	00001d0c 	andeq	r1, r0, ip, lsl #26
    2620:	001d0c00 	andseq	r0, sp, r0, lsl #24
    2624:	07ef0000 	strbeq	r0, [pc, r0]!
    2628:	000d0000 	andeq	r0, sp, r0
    262c:	00198a0f 	andseq	r8, r9, pc, lsl #20
    2630:	03fb0500 	mvnseq	r0, #0, 10
    2634:	0007e40c 	andeq	lr, r7, ip, lsl #8
    2638:	04e60c00 	strbteq	r0, [r6], #3072	; 0xc00
    263c:	080c0000 	stmdaeq	ip, {}	; <UNPREDICTABLE>
    2640:	24150000 	ldrcs	r0, [r5], #-0
    2644:	0d000000 	stceq	0, cr0, [r0, #-0]
    2648:	1ea50f00 	cdpne	15, 10, cr0, cr5, cr0, {0}
    264c:	84050000 	strhi	r0, [r5], #-0
    2650:	07fc1405 	ldrbeq	r1, [ip, r5, lsl #8]!
    2654:	4c160000 	ldcmi	0, cr0, [r6], {-0}
    2658:	0700001a 	smladeq	r0, sl, r0, r0
    265c:	00009301 	andeq	r9, r0, r1, lsl #6
    2660:	058b0500 	streq	r0, [fp, #1280]	; 0x500
    2664:	00085706 	andeq	r5, r8, r6, lsl #14
    2668:	18070b00 	stmdane	r7, {r8, r9, fp}
    266c:	0b000000 	bleq	2674 <shift+0x2674>
    2670:	00001c57 	andeq	r1, r0, r7, asr ip
    2674:	13df0b01 	bicsne	r0, pc, #1024	; 0x400
    2678:	0b020000 	bleq	82680 <__bss_end+0x791d8>
    267c:	00002316 	andeq	r2, r0, r6, lsl r3
    2680:	1f1f0b03 	svcne	0x001f0b03
    2684:	0b040000 	bleq	10268c <__bss_end+0xf91e4>
    2688:	00001f12 	andeq	r1, r0, r2, lsl pc
    268c:	14b60b05 	ldrtne	r0, [r6], #2821	; 0xb05
    2690:	00060000 	andeq	r0, r6, r0
    2694:	0023060f 	eoreq	r0, r3, pc, lsl #12
    2698:	05980500 	ldreq	r0, [r8, #1280]	; 0x500
    269c:	00081915 	andeq	r1, r8, r5, lsl r9
    26a0:	22080f00 	andcs	r0, r8, #0, 30
    26a4:	99050000 	stmdbls	r5, {}	; <UNPREDICTABLE>
    26a8:	00241107 	eoreq	r1, r4, r7, lsl #2
    26ac:	920f0000 	andls	r0, pc, #0
    26b0:	0500001e 	streq	r0, [r0, #-30]	; 0xffffffe2
    26b4:	1d0c07ae 	stcne	7, cr0, [ip, #-696]	; 0xfffffd48
    26b8:	04000000 	streq	r0, [r0], #-0
    26bc:	0000217b 	andeq	r2, r0, fp, ror r1
    26c0:	93167b06 	tstls	r6, #6144	; 0x1800
    26c4:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
    26c8:	0000087e 	andeq	r0, r0, lr, ror r8
    26cc:	2a050203 	bcs	142ee0 <__bss_end+0x139a38>
    26d0:	03000004 	movweq	r0, #4
    26d4:	179a0708 	ldrne	r0, [sl, r8, lsl #14]
    26d8:	04030000 	streq	r0, [r3], #-0
    26dc:	00156e04 	andseq	r6, r5, r4, lsl #28
    26e0:	03080300 	movweq	r0, #33536	; 0x8300
    26e4:	00001566 	andeq	r1, r0, r6, ror #10
    26e8:	7b040803 	blvc	1046fc <__bss_end+0xfb254>
    26ec:	0300001e 	movweq	r0, #30
    26f0:	1f2d0310 	svcne	0x002d0310
    26f4:	8a0c0000 	bhi	3026fc <__bss_end+0x2f9254>
    26f8:	c9000008 	stmdbgt	r0, {r3}
    26fc:	15000008 	strne	r0, [r0, #-8]
    2700:	00000024 	andeq	r0, r0, r4, lsr #32
    2704:	b90e00ff 	stmdblt	lr, {r0, r1, r2, r3, r4, r5, r6, r7}
    2708:	0f000008 	svceq	0x00000008
    270c:	00001d8c 	andeq	r1, r0, ip, lsl #27
    2710:	1601fc06 	strne	pc, [r1], -r6, lsl #24
    2714:	000008c9 	andeq	r0, r0, r9, asr #17
    2718:	00151d0f 	andseq	r1, r5, pc, lsl #26
    271c:	02020600 	andeq	r0, r2, #0, 12
    2720:	0008c916 	andeq	ip, r8, r6, lsl r9
    2724:	21ae0400 			; <UNDEFINED> instruction: 0x21ae0400
    2728:	2a070000 	bcs	1c2730 <__bss_end+0x1b9288>
    272c:	0004f910 	andeq	pc, r4, r0, lsl r9	; <UNPREDICTABLE>
    2730:	08e80c00 	stmiaeq	r8!, {sl, fp}^
    2734:	08ff0000 	ldmeq	pc!, {}^	; <UNPREDICTABLE>
    2738:	000d0000 	andeq	r0, sp, r0
    273c:	00036c09 	andeq	r6, r3, r9, lsl #24
    2740:	112f0700 			; <UNDEFINED> instruction: 0x112f0700
    2744:	000008f4 	strdeq	r0, [r0], -r4
    2748:	00023109 	andeq	r3, r2, r9, lsl #2
    274c:	11300700 	teqne	r0, r0, lsl #14
    2750:	000008f4 	strdeq	r0, [r0], -r4
    2754:	0008ff17 	andeq	pc, r8, r7, lsl pc	; <UNPREDICTABLE>
    2758:	09330800 	ldmdbeq	r3!, {fp}
    275c:	9503050a 	strls	r0, [r3, #-1290]	; 0xfffffaf6
    2760:	17000094 			; <UNDEFINED> instruction: 0x17000094
    2764:	0000090b 	andeq	r0, r0, fp, lsl #18
    2768:	0a093408 	beq	24f790 <__bss_end+0x2462e8>
    276c:	94950305 	ldrls	r0, [r5], #773	; 0x305
    2770:	Address 0x0000000000002770 is out of bounds.


Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	10001101 	andne	r1, r0, r1, lsl #2
   4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
   8:	1b0e0301 	blne	380c14 <__bss_end+0x37776c>
   c:	130e250e 	movwne	r2, #58638	; 0xe50e
  10:	00000005 	andeq	r0, r0, r5
  14:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
  18:	030b130e 	movweq	r1, #45838	; 0xb30e
  1c:	110e1b0e 	tstne	lr, lr, lsl #22
  20:	10061201 	andne	r1, r6, r1, lsl #4
  24:	02000017 	andeq	r0, r0, #23
  28:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  2c:	0b3b0b3a 	bleq	ec2d1c <__bss_end+0xeb9874>
  30:	13490b39 	movtne	r0, #39737	; 0x9b39
  34:	193c193f 	ldmdbne	ip!, {r0, r1, r2, r3, r4, r5, r8, fp, ip}
  38:	24030000 	strcs	r0, [r3], #-0
  3c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
  40:	000e030b 	andeq	r0, lr, fp, lsl #6
  44:	012e0400 			; <UNDEFINED> instruction: 0x012e0400
  48:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
  4c:	0b3b0b3a 	bleq	ec2d3c <__bss_end+0xeb9894>
  50:	01110b39 	tsteq	r1, r9, lsr fp
  54:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
  58:	01194296 			; <UNDEFINED> instruction: 0x01194296
  5c:	05000013 	streq	r0, [r0, #-19]	; 0xffffffed
  60:	0e030034 	mcreq	0, 0, r0, cr3, cr4, {1}
  64:	0b3b0b3a 	bleq	ec2d54 <__bss_end+0xeb98ac>
  68:	13490b39 	movtne	r0, #39737	; 0x9b39
  6c:	00001802 	andeq	r1, r0, r2, lsl #16
  70:	0b002406 	bleq	9090 <_Z7strncmpPKcS0_i+0x68>
  74:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
  78:	07000008 	streq	r0, [r0, -r8]
  7c:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
  80:	0b3a0e03 	bleq	e83894 <__bss_end+0xe7a3ec>
  84:	0b390b3b 	bleq	e42d78 <__bss_end+0xe398d0>
  88:	06120111 			; <UNDEFINED> instruction: 0x06120111
  8c:	42971840 	addsmi	r1, r7, #64, 16	; 0x400000
  90:	00130119 	andseq	r0, r3, r9, lsl r1
  94:	010b0800 	tsteq	fp, r0, lsl #16
  98:	06120111 			; <UNDEFINED> instruction: 0x06120111
  9c:	34090000 	strcc	r0, [r9], #-0
  a0:	3a080300 	bcc	200ca8 <__bss_end+0x1f7800>
  a4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
  a8:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
  ac:	0a000018 	beq	114 <shift+0x114>
  b0:	0b0b000f 	bleq	2c00f4 <__bss_end+0x2b6c4c>
  b4:	00001349 	andeq	r1, r0, r9, asr #6
  b8:	01110100 	tsteq	r1, r0, lsl #2
  bc:	0b130e25 	bleq	4c3958 <__bss_end+0x4ba4b0>
  c0:	0e1b0e03 	cdpeq	14, 1, cr0, cr11, cr3, {0}
  c4:	06120111 			; <UNDEFINED> instruction: 0x06120111
  c8:	00001710 	andeq	r1, r0, r0, lsl r7
  cc:	03001602 	movweq	r1, #1538	; 0x602
  d0:	3b0b3a0e 	blcc	2ce910 <__bss_end+0x2c5468>
  d4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
  d8:	03000013 	movweq	r0, #19
  dc:	0b0b000f 	bleq	2c0120 <__bss_end+0x2b6c78>
  e0:	00001349 	andeq	r1, r0, r9, asr #6
  e4:	00001504 	andeq	r1, r0, r4, lsl #10
  e8:	01010500 	tsteq	r1, r0, lsl #10
  ec:	13011349 	movwne	r1, #4937	; 0x1349
  f0:	21060000 	mrscs	r0, (UNDEF: 6)
  f4:	2f134900 	svccs	0x00134900
  f8:	07000006 	streq	r0, [r0, -r6]
  fc:	0b0b0024 	bleq	2c0194 <__bss_end+0x2b6cec>
 100:	0e030b3e 	vmoveq.16	d3[0], r0
 104:	34080000 	strcc	r0, [r8], #-0
 108:	3a0e0300 	bcc	380d10 <__bss_end+0x377868>
 10c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 110:	3f13490b 	svccc	0x0013490b
 114:	00193c19 	andseq	r3, r9, r9, lsl ip
 118:	012e0900 			; <UNDEFINED> instruction: 0x012e0900
 11c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 120:	0b3b0b3a 	bleq	ec2e10 <__bss_end+0xeb9968>
 124:	13490b39 	movtne	r0, #39737	; 0x9b39
 128:	06120111 			; <UNDEFINED> instruction: 0x06120111
 12c:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 130:	00130119 	andseq	r0, r3, r9, lsl r1
 134:	00340a00 	eorseq	r0, r4, r0, lsl #20
 138:	0b3a0e03 	bleq	e8394c <__bss_end+0xe7a4a4>
 13c:	0b390b3b 	bleq	e42e30 <__bss_end+0xe39988>
 140:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 144:	240b0000 	strcs	r0, [fp], #-0
 148:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 14c:	0008030b 	andeq	r0, r8, fp, lsl #6
 150:	002e0c00 	eoreq	r0, lr, r0, lsl #24
 154:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 158:	0b3b0b3a 	bleq	ec2e48 <__bss_end+0xeb99a0>
 15c:	01110b39 	tsteq	r1, r9, lsr fp
 160:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 164:	00194297 	mulseq	r9, r7, r2
 168:	01390d00 	teqeq	r9, r0, lsl #26
 16c:	0b3a0e03 	bleq	e83980 <__bss_end+0xe7a4d8>
 170:	13010b3b 	movwne	r0, #6971	; 0x1b3b
 174:	2e0e0000 	cdpcs	0, 0, cr0, cr14, cr0, {0}
 178:	03193f01 	tsteq	r9, #1, 30
 17c:	3b0b3a0e 	blcc	2ce9bc <__bss_end+0x2c5514>
 180:	3c0b390b 			; <UNDEFINED> instruction: 0x3c0b390b
 184:	00130119 	andseq	r0, r3, r9, lsl r1
 188:	00050f00 	andeq	r0, r5, r0, lsl #30
 18c:	00001349 	andeq	r1, r0, r9, asr #6
 190:	3f012e10 	svccc	0x00012e10
 194:	3a0e0319 	bcc	380e00 <__bss_end+0x377958>
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
 1c0:	3a080300 	bcc	200dc8 <__bss_end+0x1f7920>
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
 1f4:	0b0b0024 	bleq	2c028c <__bss_end+0x2b6de4>
 1f8:	0e030b3e 	vmoveq.16	d3[0], r0
 1fc:	26030000 	strcs	r0, [r3], -r0
 200:	00134900 	andseq	r4, r3, r0, lsl #18
 204:	00240400 	eoreq	r0, r4, r0, lsl #8
 208:	0b3e0b0b 	bleq	f82e3c <__bss_end+0xf79994>
 20c:	00000803 	andeq	r0, r0, r3, lsl #16
 210:	03001605 	movweq	r1, #1541	; 0x605
 214:	3b0b3a0e 	blcc	2cea54 <__bss_end+0x2c55ac>
 218:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 21c:	06000013 			; <UNDEFINED> instruction: 0x06000013
 220:	0e030113 	mcreq	1, 0, r0, cr3, cr3, {0}
 224:	0b3a0b0b 	bleq	e82e58 <__bss_end+0xe799b0>
 228:	0b390b3b 	bleq	e42f1c <__bss_end+0xe39a74>
 22c:	00001301 	andeq	r1, r0, r1, lsl #6
 230:	03000d07 	movweq	r0, #3335	; 0xd07
 234:	3b0b3a08 	blcc	2cea5c <__bss_end+0x2c55b4>
 238:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 23c:	000b3813 	andeq	r3, fp, r3, lsl r8
 240:	01040800 	tsteq	r4, r0, lsl #16
 244:	196d0e03 	stmdbne	sp!, {r0, r1, r9, sl, fp}^
 248:	0b0b0b3e 	bleq	2c2f48 <__bss_end+0x2b9aa0>
 24c:	0b3a1349 	bleq	e84f78 <__bss_end+0xe7bad0>
 250:	0b390b3b 	bleq	e42f44 <__bss_end+0xe39a9c>
 254:	00001301 	andeq	r1, r0, r1, lsl #6
 258:	03002809 	movweq	r2, #2057	; 0x809
 25c:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 260:	00340a00 	eorseq	r0, r4, r0, lsl #20
 264:	0b3a0e03 	bleq	e83a78 <__bss_end+0xe7a5d0>
 268:	0b390b3b 	bleq	e42f5c <__bss_end+0xe39ab4>
 26c:	196c1349 	stmdbne	ip!, {r0, r3, r6, r8, r9, ip}^
 270:	00001802 	andeq	r1, r0, r2, lsl #16
 274:	0300020b 	movweq	r0, #523	; 0x20b
 278:	00193c0e 	andseq	r3, r9, lr, lsl #24
 27c:	01020c00 	tsteq	r2, r0, lsl #24
 280:	0b0b0e03 	bleq	2c3a94 <__bss_end+0x2ba5ec>
 284:	0b3b0b3a 	bleq	ec2f74 <__bss_end+0xeb9acc>
 288:	13010b39 	movwne	r0, #6969	; 0x1b39
 28c:	0d0d0000 	stceq	0, cr0, [sp, #-0]
 290:	3a0e0300 	bcc	380e98 <__bss_end+0x3779f0>
 294:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 298:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 29c:	0e00000b 	cdpeq	0, 0, cr0, cr0, cr11, {0}
 2a0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 2a4:	0b3a0e03 	bleq	e83ab8 <__bss_end+0xe7a610>
 2a8:	0b390b3b 	bleq	e42f9c <__bss_end+0xe39af4>
 2ac:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 2b0:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 2b4:	050f0000 	streq	r0, [pc, #-0]	; 2bc <shift+0x2bc>
 2b8:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
 2bc:	10000019 	andne	r0, r0, r9, lsl r0
 2c0:	13490005 	movtne	r0, #36869	; 0x9005
 2c4:	0d110000 	ldceq	0, cr0, [r1, #-0]
 2c8:	3a0e0300 	bcc	380ed0 <__bss_end+0x377a28>
 2cc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 2d0:	3f13490b 	svccc	0x0013490b
 2d4:	00193c19 	andseq	r3, r9, r9, lsl ip
 2d8:	012e1200 			; <UNDEFINED> instruction: 0x012e1200
 2dc:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 2e0:	0b3b0b3a 	bleq	ec2fd0 <__bss_end+0xeb9b28>
 2e4:	0e6e0b39 	vmoveq.8	d14[5], r0
 2e8:	0b321349 	bleq	c85014 <__bss_end+0xc7bb6c>
 2ec:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 2f0:	00001301 	andeq	r1, r0, r1, lsl #6
 2f4:	3f012e13 	svccc	0x00012e13
 2f8:	3a0e0319 	bcc	380f64 <__bss_end+0x377abc>
 2fc:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 300:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
 304:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 308:	00130113 	andseq	r0, r3, r3, lsl r1
 30c:	012e1400 			; <UNDEFINED> instruction: 0x012e1400
 310:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 314:	0b3b0b3a 	bleq	ec3004 <__bss_end+0xeb9b5c>
 318:	0e6e0b39 	vmoveq.8	d14[5], r0
 31c:	0b321349 	bleq	c85048 <__bss_end+0xc7bba0>
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
 348:	3a0e0300 	bcc	380f50 <__bss_end+0x377aa8>
 34c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 350:	3f13490b 	svccc	0x0013490b
 354:	00193c19 	andseq	r3, r9, r9, lsl ip
 358:	00281a00 	eoreq	r1, r8, r0, lsl #20
 35c:	0b1c0803 	bleq	702370 <__bss_end+0x6f8ec8>
 360:	2e1b0000 	cdpcs	0, 1, cr0, cr11, cr0, {0}
 364:	03193f01 	tsteq	r9, #1, 30
 368:	3b0b3a0e 	blcc	2ceba8 <__bss_end+0x2c5700>
 36c:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 370:	64193c0e 	ldrvs	r3, [r9], #-3086	; 0xfffff3f2
 374:	00130113 	andseq	r0, r3, r3, lsl r1
 378:	012e1c00 			; <UNDEFINED> instruction: 0x012e1c00
 37c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 380:	0b3b0b3a 	bleq	ec3070 <__bss_end+0xeb9bc8>
 384:	0e6e0b39 	vmoveq.8	d14[5], r0
 388:	193c1349 	ldmdbne	ip!, {r0, r3, r6, r8, r9, ip}
 38c:	13011364 	movwne	r1, #4964	; 0x1364
 390:	0d1d0000 	ldceq	0, cr0, [sp, #-0]
 394:	3a0e0300 	bcc	380f9c <__bss_end+0x377af4>
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
 3d0:	0b3b0b3a 	bleq	ec30c0 <__bss_end+0xeb9c18>
 3d4:	13490b39 	movtne	r0, #39737	; 0x9b39
 3d8:	06120111 			; <UNDEFINED> instruction: 0x06120111
 3dc:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 3e0:	00130119 	andseq	r0, r3, r9, lsl r1
 3e4:	00052300 	andeq	r2, r5, r0, lsl #6
 3e8:	0b3a0e03 	bleq	e83bfc <__bss_end+0xe7a754>
 3ec:	0b390b3b 	bleq	e430e0 <__bss_end+0xe39c38>
 3f0:	18021349 	stmdane	r2, {r0, r3, r6, r8, r9, ip}
 3f4:	01000000 	mrseq	r0, (UNDEF: 0)
 3f8:	0e250111 	mcreq	1, 1, r0, cr5, cr1, {0}
 3fc:	0e030b13 	vmoveq.32	d3[0], r0
 400:	01110e1b 	tsteq	r1, fp, lsl lr
 404:	17100612 			; <UNDEFINED> instruction: 0x17100612
 408:	24020000 	strcs	r0, [r2], #-0
 40c:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 410:	000e030b 	andeq	r0, lr, fp, lsl #6
 414:	00260300 	eoreq	r0, r6, r0, lsl #6
 418:	00001349 	andeq	r1, r0, r9, asr #6
 41c:	0b002404 	bleq	9434 <_ZL18NoFilesystemDriver>
 420:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 424:	05000008 	streq	r0, [r0, #-8]
 428:	0e030016 	mcreq	0, 0, r0, cr3, cr6, {0}
 42c:	0b3b0b3a 	bleq	ec311c <__bss_end+0xeb9c74>
 430:	13490b39 	movtne	r0, #39737	; 0x9b39
 434:	13060000 	movwne	r0, #24576	; 0x6000
 438:	0b0e0301 	bleq	381044 <__bss_end+0x377b9c>
 43c:	3b0b3a0b 	blcc	2cec70 <__bss_end+0x2c57c8>
 440:	010b390b 	tsteq	fp, fp, lsl #18
 444:	07000013 	smladeq	r0, r3, r0, r0
 448:	0803000d 	stmdaeq	r3, {r0, r2, r3}
 44c:	0b3b0b3a 	bleq	ec313c <__bss_end+0xeb9c94>
 450:	13490b39 	movtne	r0, #39737	; 0x9b39
 454:	00000b38 	andeq	r0, r0, r8, lsr fp
 458:	03010408 	movweq	r0, #5128	; 0x1408
 45c:	3e196d0e 	cdpcc	13, 1, cr6, cr9, cr14, {0}
 460:	490b0b0b 	stmdbmi	fp, {r0, r1, r3, r8, r9, fp}
 464:	3b0b3a13 	blcc	2cecb8 <__bss_end+0x2c5810>
 468:	010b390b 	tsteq	fp, fp, lsl #18
 46c:	09000013 	stmdbeq	r0, {r0, r1, r4}
 470:	08030028 	stmdaeq	r3, {r3, r5}
 474:	00000b1c 	andeq	r0, r0, ip, lsl fp
 478:	0300280a 	movweq	r2, #2058	; 0x80a
 47c:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 480:	00340b00 	eorseq	r0, r4, r0, lsl #22
 484:	0b3a0e03 	bleq	e83c98 <__bss_end+0xe7a7f0>
 488:	0b390b3b 	bleq	e4317c <__bss_end+0xe39cd4>
 48c:	196c1349 	stmdbne	ip!, {r0, r3, r6, r8, r9, ip}^
 490:	00001802 	andeq	r1, r0, r2, lsl #16
 494:	0300020c 	movweq	r0, #524	; 0x20c
 498:	00193c0e 	andseq	r3, r9, lr, lsl #24
 49c:	01020d00 	tsteq	r2, r0, lsl #26
 4a0:	0b0b0e03 	bleq	2c3cb4 <__bss_end+0x2ba80c>
 4a4:	0b3b0b3a 	bleq	ec3194 <__bss_end+0xeb9cec>
 4a8:	13010b39 	movwne	r0, #6969	; 0x1b39
 4ac:	0d0e0000 	stceq	0, cr0, [lr, #-0]
 4b0:	3a0e0300 	bcc	3810b8 <__bss_end+0x377c10>
 4b4:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4b8:	3813490b 	ldmdacc	r3, {r0, r1, r3, r8, fp, lr}
 4bc:	0f00000b 	svceq	0x0000000b
 4c0:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 4c4:	0b3a0e03 	bleq	e83cd8 <__bss_end+0xe7a830>
 4c8:	0b390b3b 	bleq	e431bc <__bss_end+0xe39d14>
 4cc:	13490e6e 	movtne	r0, #40558	; 0x9e6e
 4d0:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 4d4:	05100000 	ldreq	r0, [r0, #-0]
 4d8:	34134900 	ldrcc	r4, [r3], #-2304	; 0xfffff700
 4dc:	11000019 	tstne	r0, r9, lsl r0
 4e0:	13490005 	movtne	r0, #36869	; 0x9005
 4e4:	0d120000 	ldceq	0, cr0, [r2, #-0]
 4e8:	3a0e0300 	bcc	3810f0 <__bss_end+0x377c48>
 4ec:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 4f0:	3f13490b 	svccc	0x0013490b
 4f4:	00193c19 	andseq	r3, r9, r9, lsl ip
 4f8:	012e1300 			; <UNDEFINED> instruction: 0x012e1300
 4fc:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 500:	0b3b0b3a 	bleq	ec31f0 <__bss_end+0xeb9d48>
 504:	0e6e0b39 	vmoveq.8	d14[5], r0
 508:	0b321349 	bleq	c85234 <__bss_end+0xc7bd8c>
 50c:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 510:	00001301 	andeq	r1, r0, r1, lsl #6
 514:	3f012e14 	svccc	0x00012e14
 518:	3a0e0319 	bcc	381184 <__bss_end+0x377cdc>
 51c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 520:	320e6e0b 	andcc	r6, lr, #11, 28	; 0xb0
 524:	64193c0b 	ldrvs	r3, [r9], #-3083	; 0xfffff3f5
 528:	00130113 	andseq	r0, r3, r3, lsl r1
 52c:	012e1500 			; <UNDEFINED> instruction: 0x012e1500
 530:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 534:	0b3b0b3a 	bleq	ec3224 <__bss_end+0xeb9d7c>
 538:	0e6e0b39 	vmoveq.8	d14[5], r0
 53c:	0b321349 	bleq	c85268 <__bss_end+0xc7bdc0>
 540:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 544:	01160000 	tsteq	r6, r0
 548:	01134901 	tsteq	r3, r1, lsl #18
 54c:	17000013 	smladne	r0, r3, r0, r0
 550:	13490021 	movtne	r0, #36897	; 0x9021
 554:	00000b2f 	andeq	r0, r0, pc, lsr #22
 558:	0b000f18 	bleq	41c0 <shift+0x41c0>
 55c:	0013490b 	andseq	r4, r3, fp, lsl #18
 560:	00211900 	eoreq	r1, r1, r0, lsl #18
 564:	341a0000 	ldrcc	r0, [sl], #-0
 568:	3a0e0300 	bcc	381170 <__bss_end+0x377cc8>
 56c:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 570:	3f13490b 	svccc	0x0013490b
 574:	00193c19 	andseq	r3, r9, r9, lsl ip
 578:	012e1b00 			; <UNDEFINED> instruction: 0x012e1b00
 57c:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 580:	0b3b0b3a 	bleq	ec3270 <__bss_end+0xeb9dc8>
 584:	0e6e0b39 	vmoveq.8	d14[5], r0
 588:	1364193c 	cmnne	r4, #60, 18	; 0xf0000
 58c:	00001301 	andeq	r1, r0, r1, lsl #6
 590:	3f012e1c 	svccc	0x00012e1c
 594:	3a0e0319 	bcc	381200 <__bss_end+0x377d58>
 598:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 59c:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 5a0:	64193c13 	ldrvs	r3, [r9], #-3091	; 0xfffff3ed
 5a4:	00130113 	andseq	r0, r3, r3, lsl r1
 5a8:	000d1d00 	andeq	r1, sp, r0, lsl #26
 5ac:	0b3a0e03 	bleq	e83dc0 <__bss_end+0xe7a918>
 5b0:	0b390b3b 	bleq	e432a4 <__bss_end+0xe39dfc>
 5b4:	0b381349 	bleq	e052e0 <__bss_end+0xdfbe38>
 5b8:	00000b32 	andeq	r0, r0, r2, lsr fp
 5bc:	4901151e 	stmdbmi	r1, {r1, r2, r3, r4, r8, sl, ip}
 5c0:	01136413 	tsteq	r3, r3, lsl r4
 5c4:	1f000013 	svcne	0x00000013
 5c8:	131d001f 	tstne	sp, #31
 5cc:	00001349 	andeq	r1, r0, r9, asr #6
 5d0:	0b001020 	bleq	4658 <shift+0x4658>
 5d4:	0013490b 	andseq	r4, r3, fp, lsl #18
 5d8:	000f2100 	andeq	r2, pc, r0, lsl #2
 5dc:	00000b0b 	andeq	r0, r0, fp, lsl #22
 5e0:	03003422 	movweq	r3, #1058	; 0x422
 5e4:	3b0b3a0e 	blcc	2cee24 <__bss_end+0x2c597c>
 5e8:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 5ec:	00180213 	andseq	r0, r8, r3, lsl r2
 5f0:	012e2300 			; <UNDEFINED> instruction: 0x012e2300
 5f4:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 5f8:	0b3b0b3a 	bleq	ec32e8 <__bss_end+0xeb9e40>
 5fc:	0e6e0b39 	vmoveq.8	d14[5], r0
 600:	01111349 	tsteq	r1, r9, asr #6
 604:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 608:	01194296 			; <UNDEFINED> instruction: 0x01194296
 60c:	24000013 	strcs	r0, [r0], #-19	; 0xffffffed
 610:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 614:	0b3b0b3a 	bleq	ec3304 <__bss_end+0xeb9e5c>
 618:	13490b39 	movtne	r0, #39737	; 0x9b39
 61c:	00001802 	andeq	r1, r0, r2, lsl #16
 620:	3f012e25 	svccc	0x00012e25
 624:	3a0e0319 	bcc	381290 <__bss_end+0x377de8>
 628:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 62c:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 630:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 634:	97184006 	ldrls	r4, [r8, -r6]
 638:	13011942 	movwne	r1, #6466	; 0x1942
 63c:	34260000 	strtcc	r0, [r6], #-0
 640:	3a080300 	bcc	201248 <__bss_end+0x1f7da0>
 644:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 648:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 64c:	27000018 	smladcs	r0, r8, r0, r0
 650:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 654:	0b3a0e03 	bleq	e83e68 <__bss_end+0xe7a9c0>
 658:	0b390b3b 	bleq	e4334c <__bss_end+0xe39ea4>
 65c:	01110e6e 	tsteq	r1, lr, ror #28
 660:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 664:	01194297 			; <UNDEFINED> instruction: 0x01194297
 668:	28000013 	stmdacs	r0, {r0, r1, r4}
 66c:	193f002e 	ldmdbne	pc!, {r1, r2, r3, r5}	; <UNPREDICTABLE>
 670:	0b3a0e03 	bleq	e83e84 <__bss_end+0xe7a9dc>
 674:	0b390b3b 	bleq	e43368 <__bss_end+0xe39ec0>
 678:	01110e6e 	tsteq	r1, lr, ror #28
 67c:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 680:	00194297 	mulseq	r9, r7, r2
 684:	012e2900 			; <UNDEFINED> instruction: 0x012e2900
 688:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 68c:	0b3b0b3a 	bleq	ec337c <__bss_end+0xeb9ed4>
 690:	0e6e0b39 	vmoveq.8	d14[5], r0
 694:	01111349 	tsteq	r1, r9, asr #6
 698:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 69c:	00194297 	mulseq	r9, r7, r2
 6a0:	11010000 	mrsne	r0, (UNDEF: 1)
 6a4:	130e2501 	movwne	r2, #58625	; 0xe501
 6a8:	1b0e030b 	blne	3812dc <__bss_end+0x377e34>
 6ac:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 6b0:	00171006 	andseq	r1, r7, r6
 6b4:	01390200 	teqeq	r9, r0, lsl #4
 6b8:	00001301 	andeq	r1, r0, r1, lsl #6
 6bc:	03003403 	movweq	r3, #1027	; 0x403
 6c0:	3b0b3a0e 	blcc	2cef00 <__bss_end+0x2c5a58>
 6c4:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 6c8:	1c193c13 	ldcne	12, cr3, [r9], {19}
 6cc:	0400000a 	streq	r0, [r0], #-10
 6d0:	0b3a003a 	bleq	e807c0 <__bss_end+0xe77318>
 6d4:	0b390b3b 	bleq	e433c8 <__bss_end+0xe39f20>
 6d8:	00001318 	andeq	r1, r0, r8, lsl r3
 6dc:	49010105 	stmdbmi	r1, {r0, r2, r8}
 6e0:	00130113 	andseq	r0, r3, r3, lsl r1
 6e4:	00210600 	eoreq	r0, r1, r0, lsl #12
 6e8:	0b2f1349 	bleq	bc5414 <__bss_end+0xbbbf6c>
 6ec:	26070000 	strcs	r0, [r7], -r0
 6f0:	00134900 	andseq	r4, r3, r0, lsl #18
 6f4:	00240800 	eoreq	r0, r4, r0, lsl #16
 6f8:	0b3e0b0b 	bleq	f8332c <__bss_end+0xf79e84>
 6fc:	00000e03 	andeq	r0, r0, r3, lsl #28
 700:	47003409 	strmi	r3, [r0, -r9, lsl #8]
 704:	0a000013 	beq	758 <shift+0x758>
 708:	193f012e 	ldmdbne	pc!, {r1, r2, r3, r5, r8}	; <UNPREDICTABLE>
 70c:	0b3a0e03 	bleq	e83f20 <__bss_end+0xe7aa78>
 710:	0b390b3b 	bleq	e43404 <__bss_end+0xe39f5c>
 714:	01110e6e 	tsteq	r1, lr, ror #28
 718:	18400612 	stmdane	r0, {r1, r4, r9, sl}^
 71c:	01194297 			; <UNDEFINED> instruction: 0x01194297
 720:	0b000013 	bleq	774 <shift+0x774>
 724:	08030005 	stmdaeq	r3, {r0, r2}
 728:	0b3b0b3a 	bleq	ec3418 <__bss_end+0xeb9f70>
 72c:	13490b39 	movtne	r0, #39737	; 0x9b39
 730:	00001802 	andeq	r1, r0, r2, lsl #16
 734:	0300340c 	movweq	r3, #1036	; 0x40c
 738:	3b0b3a0e 	blcc	2cef78 <__bss_end+0x2c5ad0>
 73c:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 740:	00180213 	andseq	r0, r8, r3, lsl r2
 744:	010b0d00 	tsteq	fp, r0, lsl #26
 748:	06120111 			; <UNDEFINED> instruction: 0x06120111
 74c:	340e0000 	strcc	r0, [lr], #-0
 750:	3a080300 	bcc	201358 <__bss_end+0x1f7eb0>
 754:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 758:	0213490b 	andseq	r4, r3, #180224	; 0x2c000
 75c:	0f000018 	svceq	0x00000018
 760:	0b0b000f 	bleq	2c07a4 <__bss_end+0x2b72fc>
 764:	00001349 	andeq	r1, r0, r9, asr #6
 768:	00002610 	andeq	r2, r0, r0, lsl r6
 76c:	000f1100 	andeq	r1, pc, r0, lsl #2
 770:	00000b0b 	andeq	r0, r0, fp, lsl #22
 774:	0b002412 	bleq	97c4 <__bss_end+0x31c>
 778:	030b3e0b 	movweq	r3, #48651	; 0xbe0b
 77c:	13000008 	movwne	r0, #8
 780:	0e030005 	cdpeq	0, 0, cr0, cr3, cr5, {0}
 784:	0b3b0b3a 	bleq	ec3474 <__bss_end+0xeb9fcc>
 788:	13490b39 	movtne	r0, #39737	; 0x9b39
 78c:	00001802 	andeq	r1, r0, r2, lsl #16
 790:	3f012e14 	svccc	0x00012e14
 794:	3a0e0319 	bcc	381400 <__bss_end+0x377f58>
 798:	390b3b0b 	stmdbcc	fp, {r0, r1, r3, r8, r9, fp, ip, sp}
 79c:	490e6e0b 	stmdbmi	lr, {r0, r1, r3, r9, sl, fp, sp, lr}
 7a0:	12011113 	andne	r1, r1, #-1073741820	; 0xc0000004
 7a4:	97184006 	ldrls	r4, [r8, -r6]
 7a8:	13011942 	movwne	r1, #6466	; 0x1942
 7ac:	2e150000 	cdpcs	0, 1, cr0, cr5, cr0, {0}
 7b0:	03193f01 	tsteq	r9, #1, 30
 7b4:	3b0b3a0e 	blcc	2ceff4 <__bss_end+0x2c5b4c>
 7b8:	6e0b390b 	vmlavs.f16	s6, s22, s22	; <UNPREDICTABLE>
 7bc:	1201110e 	andne	r1, r1, #-2147483645	; 0x80000003
 7c0:	96184006 	ldrls	r4, [r8], -r6
 7c4:	13011942 	movwne	r1, #6466	; 0x1942
 7c8:	0b160000 	bleq	5807d0 <__bss_end+0x577328>
 7cc:	12011101 	andne	r1, r1, #1073741824	; 0x40000000
 7d0:	00130106 	andseq	r0, r3, r6, lsl #2
 7d4:	012e1700 			; <UNDEFINED> instruction: 0x012e1700
 7d8:	0e03193f 			; <UNDEFINED> instruction: 0x0e03193f
 7dc:	0b3b0b3a 	bleq	ec34cc <__bss_end+0xeba024>
 7e0:	0e6e0b39 	vmoveq.8	d14[5], r0
 7e4:	06120111 			; <UNDEFINED> instruction: 0x06120111
 7e8:	42961840 	addsmi	r1, r6, #64, 16	; 0x400000
 7ec:	00000019 	andeq	r0, r0, r9, lsl r0
 7f0:	10001101 	andne	r1, r0, r1, lsl #2
 7f4:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
 7f8:	1b0e0301 	blne	381404 <__bss_end+0x377f5c>
 7fc:	130e250e 	movwne	r2, #58638	; 0xe50e
 800:	00000005 	andeq	r0, r0, r5
 804:	10001101 	andne	r1, r0, r1, lsl #2
 808:	12011106 	andne	r1, r1, #-2147483647	; 0x80000001
 80c:	1b0e0301 	blne	381418 <__bss_end+0x377f70>
 810:	130e250e 	movwne	r2, #58638	; 0xe50e
 814:	00000005 	andeq	r0, r0, r5
 818:	25011101 	strcs	r1, [r1, #-257]	; 0xfffffeff
 81c:	030b130e 	movweq	r1, #45838	; 0xb30e
 820:	100e1b0e 	andne	r1, lr, lr, lsl #22
 824:	02000017 	andeq	r0, r0, #23
 828:	0b0b0024 	bleq	2c08c0 <__bss_end+0x2b7418>
 82c:	08030b3e 	stmdaeq	r3, {r1, r2, r3, r4, r5, r8, r9, fp}
 830:	24030000 	strcs	r0, [r3], #-0
 834:	3e0b0b00 	vmlacc.f64	d0, d11, d0
 838:	000e030b 	andeq	r0, lr, fp, lsl #6
 83c:	00160400 	andseq	r0, r6, r0, lsl #8
 840:	0b3a0e03 	bleq	e84054 <__bss_end+0xe7abac>
 844:	0b390b3b 	bleq	e43538 <__bss_end+0xe3a090>
 848:	00001349 	andeq	r1, r0, r9, asr #6
 84c:	0b000f05 	bleq	4468 <shift+0x4468>
 850:	0013490b 	andseq	r4, r3, fp, lsl #18
 854:	01150600 	tsteq	r5, r0, lsl #12
 858:	13491927 	movtne	r1, #39207	; 0x9927
 85c:	00001301 	andeq	r1, r0, r1, lsl #6
 860:	49000507 	stmdbmi	r0, {r0, r1, r2, r8, sl}
 864:	08000013 	stmdaeq	r0, {r0, r1, r4}
 868:	00000026 	andeq	r0, r0, r6, lsr #32
 86c:	03003409 	movweq	r3, #1033	; 0x409
 870:	3b0b3a0e 	blcc	2cf0b0 <__bss_end+0x2c5c08>
 874:	490b390b 	stmdbmi	fp, {r0, r1, r3, r8, fp, ip, sp}
 878:	3c193f13 	ldccc	15, cr3, [r9], {19}
 87c:	0a000019 	beq	8e8 <shift+0x8e8>
 880:	0e030104 	adfeqs	f0, f3, f4
 884:	0b0b0b3e 	bleq	2c3584 <__bss_end+0x2ba0dc>
 888:	0b3a1349 	bleq	e855b4 <__bss_end+0xe7c10c>
 88c:	0b390b3b 	bleq	e43580 <__bss_end+0xe3a0d8>
 890:	00001301 	andeq	r1, r0, r1, lsl #6
 894:	0300280b 	movweq	r2, #2059	; 0x80b
 898:	000b1c0e 	andeq	r1, fp, lr, lsl #24
 89c:	01010c00 	tsteq	r1, r0, lsl #24
 8a0:	13011349 	movwne	r1, #4937	; 0x1349
 8a4:	210d0000 	mrscs	r0, (UNDEF: 13)
 8a8:	0e000000 	cdpeq	0, 0, cr0, cr0, cr0, {0}
 8ac:	13490026 	movtne	r0, #36902	; 0x9026
 8b0:	340f0000 	strcc	r0, [pc], #-0	; 8b8 <shift+0x8b8>
 8b4:	3a0e0300 	bcc	3814bc <__bss_end+0x378014>
 8b8:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 8bc:	3f13490b 	svccc	0x0013490b
 8c0:	00193c19 	andseq	r3, r9, r9, lsl ip
 8c4:	00131000 	andseq	r1, r3, r0
 8c8:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
 8cc:	15110000 	ldrne	r0, [r1, #-0]
 8d0:	00192700 	andseq	r2, r9, r0, lsl #14
 8d4:	00171200 	andseq	r1, r7, r0, lsl #4
 8d8:	193c0e03 	ldmdbne	ip!, {r0, r1, r9, sl, fp}
 8dc:	13130000 	tstne	r3, #0
 8e0:	0b0e0301 	bleq	3814ec <__bss_end+0x378044>
 8e4:	3b0b3a0b 	blcc	2cf118 <__bss_end+0x2c5c70>
 8e8:	010b3905 	tsteq	fp, r5, lsl #18
 8ec:	14000013 	strne	r0, [r0], #-19	; 0xffffffed
 8f0:	0e03000d 	cdpeq	0, 0, cr0, cr3, cr13, {0}
 8f4:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 8f8:	13490b39 	movtne	r0, #39737	; 0x9b39
 8fc:	00000b38 	andeq	r0, r0, r8, lsr fp
 900:	49002115 	stmdbmi	r0, {r0, r2, r4, r8, sp}
 904:	000b2f13 	andeq	r2, fp, r3, lsl pc
 908:	01041600 	tsteq	r4, r0, lsl #12
 90c:	0b3e0e03 	bleq	f84120 <__bss_end+0xf7ac78>
 910:	13490b0b 	movtne	r0, #39691	; 0x9b0b
 914:	053b0b3a 	ldreq	r0, [fp, #-2874]!	; 0xfffff4c6
 918:	13010b39 	movwne	r0, #6969	; 0x1b39
 91c:	34170000 	ldrcc	r0, [r7], #-0
 920:	3a134700 	bcc	4d2528 <__bss_end+0x4c9080>
 924:	39053b0b 	stmdbcc	r5, {r0, r1, r3, r8, r9, fp, ip, sp}
 928:	0018020b 	andseq	r0, r8, fp, lsl #4
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
  70:	0000822c 	andeq	r8, r0, ip, lsr #4
  74:	00000048 	andeq	r0, r0, r8, asr #32
	...
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	0b940002 	bleq	fe500094 <__bss_end+0xfe4f6bec>
  88:	00040000 	andeq	r0, r4, r0
  8c:	00000000 	andeq	r0, r0, r0
  90:	00008274 	andeq	r8, r0, r4, ror r2
  94:	0000045c 	andeq	r0, r0, ip, asr r4
	...
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	18f50002 	ldmne	r5!, {r1}^
  a8:	00040000 	andeq	r0, r4, r0
  ac:	00000000 	andeq	r0, r0, r0
  b0:	000086d0 	ldrdeq	r8, [r0], -r0
  b4:	00000b40 	andeq	r0, r0, r0, asr #22
	...
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	1df10002 	ldclne	0, cr0, [r1, #8]!
  c8:	00040000 	andeq	r0, r4, r0
  cc:	00000000 	andeq	r0, r0, r0
  d0:	00009210 	andeq	r9, r0, r0, lsl r2
  d4:	0000020c 	andeq	r0, r0, ip, lsl #4
	...
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	1e170002 	cdpne	0, 1, cr0, cr7, cr2, {0}
  e8:	00040000 	andeq	r0, r4, r0
  ec:	00000000 	andeq	r0, r0, r0
  f0:	0000941c 	andeq	r9, r0, ip, lsl r4
  f4:	00000004 	andeq	r0, r0, r4
	...
 100:	00000014 	andeq	r0, r0, r4, lsl r0
 104:	1e3d0002 	cdpne	0, 3, cr0, cr13, cr2, {0}
 108:	00040000 	andeq	r0, r4, r0
	...

Disassembly of section .debug_str:

00000000 <.debug_str>:
       0:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; ffffff4c <__bss_end+0xffff6aa4>
       4:	63732f65 	cmnvs	r3, #404	; 0x194
       8:	6b6e6568 	blvs	1b995b0 <__bss_end+0x1b90108>
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
      48:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffd21 <__bss_end+0xffff6879>
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
      84:	756f732f 	strbvc	r7, [pc, #-815]!	; fffffd5d <__bss_end+0xffff68b5>
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
     1f8:	6a6b6e65 	bvs	1adbb94 <__bss_end+0x1ad26ec>
     1fc:	32736f2f 	rsbscc	r6, r3, #47, 30	; 0xbc
     200:	2f323230 	svccs	0x00323230
     204:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
     208:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     20c:	752f7365 	strvc	r7, [pc, #-869]!	; fffffeaf <__bss_end+0xffff6a07>
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
     2e0:	2b6b7a36 	blcs	1adebc0 <__bss_end+0x1ad5718>
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
     394:	6f006572 	svcvs	0x00006572
     398:	656e6570 	strbvs	r6, [lr, #-1392]!	; 0xfffffa90
     39c:	69665f64 	stmdbvs	r6!, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     3a0:	0073656c 	rsbseq	r6, r3, ip, ror #10
     3a4:	6c656959 			; <UNDEFINED> instruction: 0x6c656959
     3a8:	72640064 	rsbvc	r0, r4, #100	; 0x64
     3ac:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     3b0:	7864695f 	stmdavc	r4!, {r0, r1, r2, r3, r4, r6, r8, fp, sp, lr}^
     3b4:	6f526d00 	svcvs	0x00526d00
     3b8:	445f746f 	ldrbmi	r7, [pc], #-1135	; 3c0 <shift+0x3c0>
     3bc:	68007665 	stmdavs	r0, {r0, r2, r5, r6, r9, sl, ip, sp, lr}
     3c0:	4c706165 	ldfmie	f6, [r0], #-404	; 0xfffffe6c
     3c4:	6369676f 	cmnvs	r9, #29097984	; 0x1bc0000
     3c8:	694c6c61 	stmdbvs	ip, {r0, r5, r6, sl, fp, sp, lr}^
     3cc:	0074696d 	rsbseq	r6, r4, sp, ror #18
     3d0:	69746f6e 	ldmdbvs	r4!, {r1, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     3d4:	64656966 	strbtvs	r6, [r5], #-2406	; 0xfffff69a
     3d8:	6165645f 	cmnvs	r5, pc, asr r4
     3dc:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     3e0:	6c730065 	ldclvs	0, cr0, [r3], #-404	; 0xfffffe6c
     3e4:	5f706565 	svcpl	0x00706565
     3e8:	656d6974 	strbvs	r6, [sp, #-2420]!	; 0xfffff68c
     3ec:	43540072 	cmpmi	r4, #114	; 0x72
     3f0:	435f5550 	cmpmi	pc, #80, 10	; 0x14000000
     3f4:	65746e6f 	ldrbvs	r6, [r4, #-3695]!	; 0xfffff191
     3f8:	4e007478 	mcrmi	4, 0, r7, cr0, cr8, {3}
     3fc:	6b736154 	blvs	1cd8954 <__bss_end+0x1ccf4ac>
     400:	6174535f 	cmnvs	r4, pc, asr r3
     404:	4e006574 	cfrshl64mi	mvdx0, mvdx4, r6
     408:	5f495753 	svcpl	0x00495753
     40c:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     410:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     414:	535f6d65 	cmppl	pc, #6464	; 0x1940
     418:	69767265 	ldmdbvs	r6!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     41c:	6d006563 	cfstr32vs	mvfx6, [r0, #-396]	; 0xfffffe74
     420:	746e756f 	strbtvc	r7, [lr], #-1391	; 0xfffffa91
     424:	6e696f50 	mcrvs	15, 3, r6, cr9, cr0, {2}
     428:	68730074 	ldmdavs	r3!, {r2, r4, r5, r6}^
     42c:	2074726f 	rsbscs	r7, r4, pc, ror #4
     430:	00746e69 	rsbseq	r6, r4, r9, ror #28
     434:	4957534e 	ldmdbmi	r7, {r1, r2, r3, r6, r8, r9, ip, lr}^
     438:	6f72505f 	svcvs	0x0072505f
     43c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     440:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
     444:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     448:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     44c:	4336314b 	teqmi	r6, #-1073741806	; 0xc0000012
     450:	636f7250 	cmnvs	pc, #80, 4
     454:	5f737365 	svcpl	0x00737365
     458:	616e614d 	cmnvs	lr, sp, asr #2
     45c:	31726567 	cmncc	r2, r7, ror #10
     460:	74654739 	strbtvc	r4, [r5], #-1849	; 0xfffff8c7
     464:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     468:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     46c:	6f72505f 	svcvs	0x0072505f
     470:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     474:	4d007645 	stcmi	6, cr7, [r0, #-276]	; 0xfffffeec
     478:	505f7861 	subspl	r7, pc, r1, ror #16
     47c:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     480:	4f5f7373 	svcmi	0x005f7373
     484:	656e6570 	strbvs	r6, [lr, #-1392]!	; 0xfffffa90
     488:	69465f64 	stmdbvs	r6, {r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     48c:	0073656c 	rsbseq	r6, r3, ip, ror #10
     490:	74696e49 	strbtvc	r6, [r9], #-3657	; 0xfffff1b7
     494:	696c6169 	stmdbvs	ip!, {r0, r3, r5, r6, r8, sp, lr}^
     498:	4700657a 	smlsdxmi	r0, sl, r5, r6
     49c:	505f7465 	subspl	r7, pc, r5, ror #8
     4a0:	6d004449 	cfstrsvs	mvf4, [r0, #-292]	; 0xfffffedc
     4a4:	006e6961 	rsbeq	r6, lr, r1, ror #18
     4a8:	5f534667 	svcpl	0x00534667
     4ac:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     4b0:	00737265 	rsbseq	r7, r3, r5, ror #4
     4b4:	5f534667 	svcpl	0x00534667
     4b8:	76697244 	strbtvc	r7, [r9], -r4, asr #4
     4bc:	5f737265 	svcpl	0x00737265
     4c0:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
     4c4:	5a5f0074 	bpl	17c069c <__bss_end+0x17b71f4>
     4c8:	36314b4e 	ldrtcc	r4, [r1], -lr, asr #22
     4cc:	6f725043 	svcvs	0x00725043
     4d0:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     4d4:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     4d8:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     4dc:	65473831 	strbvs	r3, [r7, #-2097]	; 0xfffff7cf
     4e0:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     4e4:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     4e8:	79425f73 	stmdbvc	r2, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     4ec:	4449505f 	strbmi	r5, [r9], #-95	; 0xffffffa1
     4f0:	5f006a45 	svcpl	0x00006a45
     4f4:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     4f8:	6f725043 	svcvs	0x00725043
     4fc:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     500:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     504:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     508:	68635338 	stmdavs	r3!, {r3, r4, r5, r8, r9, ip, lr}^
     50c:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     510:	00764565 	rsbseq	r4, r6, r5, ror #10
     514:	314e5a5f 	cmpcc	lr, pc, asr sl
     518:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     51c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     520:	614d5f73 	hvcvs	54771	; 0xd5f3
     524:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     528:	4e343172 	mrcmi	1, 1, r3, cr4, cr2, {3}
     52c:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     530:	72505f79 	subsvc	r5, r0, #484	; 0x1e4
     534:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     538:	006a4573 	rsbeq	r4, sl, r3, ror r5
     53c:	61766e49 	cmnvs	r6, r9, asr #28
     540:	5f64696c 	svcpl	0x0064696c
     544:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     548:	5400656c 	strpl	r6, [r0], #-1388	; 0xfffffa94
     54c:	5f6b6369 	svcpl	0x006b6369
     550:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
     554:	73690074 	cmnvc	r9, #116	; 0x74
     558:	65726944 	ldrbvs	r6, [r2, #-2372]!	; 0xfffff6bc
     55c:	726f7463 	rsbvc	r7, pc, #1660944384	; 0x63000000
     560:	614d0079 	hvcvs	53257	; 0xd009
     564:	44534678 	ldrbmi	r4, [r3], #-1656	; 0xfffff988
     568:	65766972 	ldrbvs	r6, [r6, #-2418]!	; 0xfffff68e
     56c:	6d614e72 	stclvs	14, cr4, [r1, #-456]!	; 0xfffffe38
     570:	6e654c65 	cdpvs	12, 6, cr4, cr5, cr5, {3}
     574:	00687467 	rsbeq	r7, r8, r7, ror #8
     578:	65646e49 	strbvs	r6, [r4, #-3657]!	; 0xfffff1b7
     57c:	696e6966 	stmdbvs	lr!, {r1, r2, r5, r6, r8, fp, sp, lr}^
     580:	73006574 	movwvc	r6, #1396	; 0x574
     584:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     588:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     58c:	53006d65 	movwpl	r6, #3429	; 0xd65
     590:	63746977 	cmnvs	r4, #1949696	; 0x1dc000
     594:	6f545f68 	svcvs	0x00545f68
     598:	6f6f6200 	svcvs	0x006f6200
     59c:	4c6d006c 	stclmi	0, cr0, [sp], #-432	; 0xfffffe50
     5a0:	5f747361 	svcpl	0x00747361
     5a4:	00444950 	subeq	r4, r4, r0, asr r9
     5a8:	63677261 	cmnvs	r7, #268435462	; 0x10000006
     5ac:	61656800 	cmnvs	r5, r0, lsl #16
     5b0:	79685070 	stmdbvc	r8!, {r4, r5, r6, ip, lr}^
     5b4:	61636973 	smcvs	13971	; 0x3693
     5b8:	6d694c6c 	stclvs	12, cr4, [r9, #-432]!	; 0xfffffe50
     5bc:	48007469 	stmdami	r0, {r0, r3, r5, r6, sl, ip, sp, lr}
     5c0:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     5c4:	69465f65 	stmdbvs	r6, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     5c8:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     5cc:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     5d0:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     5d4:	75706300 	ldrbvc	r6, [r0, #-768]!	; 0xfffffd00
     5d8:	6e6f635f 	mcrvs	3, 3, r6, cr15, cr15, {2}
     5dc:	74786574 	ldrbtvc	r6, [r8], #-1396	; 0xfffffa8c
     5e0:	65724300 	ldrbvs	r4, [r2, #-768]!	; 0xfffffd00
     5e4:	5f657461 	svcpl	0x00657461
     5e8:	636f7250 	cmnvs	pc, #80, 4
     5ec:	00737365 	rsbseq	r7, r3, r5, ror #6
     5f0:	64616544 	strbtvs	r6, [r1], #-1348	; 0xfffffabc
     5f4:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     5f8:	68637300 	stmdavs	r3!, {r8, r9, ip, sp, lr}^
     5fc:	735f6465 	cmpvc	pc, #1694498816	; 0x65000000
     600:	69746174 	ldmdbvs	r4!, {r2, r4, r5, r6, r8, sp, lr}^
     604:	72705f63 	rsbsvc	r5, r0, #396	; 0x18c
     608:	69726f69 	ldmdbvs	r2!, {r0, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     60c:	70007974 	andvc	r7, r0, r4, ror r9
     610:	6e657261 	cdpvs	2, 6, cr7, cr5, cr1, {3}
     614:	6f4c0074 	svcvs	0x004c0074
     618:	555f6b63 	ldrbpl	r6, [pc, #-2915]	; fffffabd <__bss_end+0xffff6615>
     61c:	636f6c6e 	cmnvs	pc, #28160	; 0x6e00
     620:	0064656b 	rsbeq	r6, r4, fp, ror #10
     624:	5f534654 	svcpl	0x00534654
     628:	65657254 	strbvs	r7, [r5, #-596]!	; 0xfffffdac
     62c:	646f4e5f 	strbtvs	r4, [pc], #-3679	; 634 <shift+0x634>
     630:	614d0065 	cmpvs	sp, r5, rrx
     634:	6c694678 	stclvs	6, cr4, [r9], #-480	; 0xfffffe20
     638:	6d616e65 	stclvs	14, cr6, [r1, #-404]!	; 0xfffffe6c
     63c:	6e654c65 	cdpvs	12, 6, cr4, cr5, cr5, {3}
     640:	00687467 	rsbeq	r7, r8, r7, ror #8
     644:	74697865 	strbtvc	r7, [r9], #-2149	; 0xfffff79b
     648:	646f635f 	strbtvs	r6, [pc], #-863	; 650 <shift+0x650>
     64c:	46430065 	strbmi	r0, [r3], -r5, rrx
     650:	73656c69 	cmnvc	r5, #26880	; 0x6900
     654:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     658:	6863006d 	stmdavs	r3!, {r0, r2, r3, r5, r6}^
     65c:	72646c69 	rsbvc	r6, r4, #26880	; 0x6900
     660:	49006e65 	stmdbmi	r0, {r0, r2, r5, r6, r9, sl, fp, sp, lr}
     664:	7265746e 	rsbvc	r7, r5, #1845493760	; 0x6e000000
     668:	74707572 	ldrbtvc	r7, [r0], #-1394	; 0xfffffa8e
     66c:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     670:	656c535f 	strbvs	r5, [ip, #-863]!	; 0xfffffca1
     674:	68007065 	stmdavs	r0, {r0, r2, r5, r6, ip, sp, lr}
     678:	53706165 	cmnpl	r0, #1073741849	; 0x40000019
     67c:	74726174 	ldrbtvc	r6, [r2], #-372	; 0xfffffe8c
     680:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     684:	50433631 	subpl	r3, r3, r1, lsr r6
     688:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     68c:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 4c8 <shift+0x4c8>
     690:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     694:	34317265 	ldrtcc	r7, [r1], #-613	; 0xfffffd9b
     698:	61657243 	cmnvs	r5, r3, asr #4
     69c:	505f6574 	subspl	r6, pc, r4, ror r5	; <UNPREDICTABLE>
     6a0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     6a4:	50457373 	subpl	r7, r5, r3, ror r3
     6a8:	00626a68 	rsbeq	r6, r2, r8, ror #20
     6ac:	616d6e55 	cmnvs	sp, r5, asr lr
     6b0:	69465f70 	stmdbvs	r6, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     6b4:	435f656c 	cmpmi	pc, #108, 10	; 0x1b000000
     6b8:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     6bc:	4800746e 	stmdami	r0, {r1, r2, r3, r5, r6, sl, ip, sp, lr}
     6c0:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     6c4:	654d5f65 	strbvs	r5, [sp, #-3941]	; 0xfffff09b
     6c8:	79726f6d 	ldmdbvc	r2!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     6cc:	4957535f 	ldmdbmi	r7, {r0, r1, r2, r3, r4, r6, r8, r9, ip, lr}^
     6d0:	67726100 	ldrbvs	r6, [r2, -r0, lsl #2]!
     6d4:	5a5f0076 	bpl	17c08b4 <__bss_end+0x17b740c>
     6d8:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     6dc:	636f7250 	cmnvs	pc, #80, 4
     6e0:	5f737365 	svcpl	0x00737365
     6e4:	616e614d 	cmnvs	lr, sp, asr #2
     6e8:	31726567 	cmncc	r2, r7, ror #10
     6ec:	6d6e5538 	cfstr64vs	mvdx5, [lr, #-224]!	; 0xffffff20
     6f0:	465f7061 	ldrbmi	r7, [pc], -r1, rrx
     6f4:	5f656c69 	svcpl	0x00656c69
     6f8:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     6fc:	45746e65 	ldrbmi	r6, [r4, #-3685]!	; 0xfffff19b
     700:	6353006a 	cmpvs	r3, #106	; 0x6a
     704:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     708:	525f656c 	subspl	r6, pc, #108, 10	; 0x1b000000
     70c:	6f5a0052 	svcvs	0x005a0052
     710:	6569626d 	strbvs	r6, [r9, #-621]!	; 0xfffffd93
     714:	57534e00 	ldrbpl	r4, [r3, -r0, lsl #28]
     718:	654d5f49 	strbvs	r5, [sp, #-3913]	; 0xfffff0b7
     71c:	79726f6d 	ldmdbvc	r2!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, sp, lr}^
     720:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
     724:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     728:	69615700 	stmdbvs	r1!, {r8, r9, sl, ip, lr}^
     72c:	6e750074 	mrcvs	0, 3, r0, cr5, cr4, {3}
     730:	6e676973 			; <UNDEFINED> instruction: 0x6e676973
     734:	63206465 			; <UNDEFINED> instruction: 0x63206465
     738:	00726168 	rsbseq	r6, r2, r8, ror #2
     73c:	6b726273 	blvs	1c99110 <__bss_end+0x1c8fc68>
     740:	53465400 	movtpl	r5, #25600	; 0x6400
     744:	6972445f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, sl, lr}^
     748:	00726576 	rsbseq	r6, r2, r6, ror r5
     74c:	5f746547 	svcpl	0x00746547
     750:	72727543 	rsbsvc	r7, r2, #281018368	; 0x10c00000
     754:	5f746e65 	svcpl	0x00746e65
     758:	636f7250 	cmnvs	pc, #80, 4
     75c:	00737365 	rsbseq	r7, r3, r5, ror #6
     760:	64616552 	strbtvs	r6, [r1], #-1362	; 0xfffffaae
     764:	6972575f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, r8, r9, sl, ip, lr}^
     768:	73006574 	movwvc	r6, #1396	; 0x574
     76c:	636f7250 	cmnvs	pc, #80, 4
     770:	4d737365 	ldclmi	3, cr7, [r3, #-404]!	; 0xfffffe6c
     774:	52007267 	andpl	r7, r0, #1879048198	; 0x70000006
     778:	00646165 	rsbeq	r6, r4, r5, ror #2
     77c:	746e6975 	strbtvc	r6, [lr], #-2421	; 0xfffff68b
     780:	745f3233 	ldrbvc	r3, [pc], #-563	; 788 <shift+0x788>
     784:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     788:	46433131 			; <UNDEFINED> instruction: 0x46433131
     78c:	73656c69 	cmnvc	r5, #26880	; 0x6900
     790:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     794:	704f346d 	subvc	r3, pc, sp, ror #8
     798:	50456e65 	subpl	r6, r5, r5, ror #28
     79c:	3531634b 	ldrcc	r6, [r1, #-843]!	; 0xfffffcb5
     7a0:	6c69464e 	stclvs	6, cr4, [r9], #-312	; 0xfffffec8
     7a4:	704f5f65 	subvc	r5, pc, r5, ror #30
     7a8:	4d5f6e65 	ldclmi	14, cr6, [pc, #-404]	; 61c <shift+0x61c>
     7ac:	0065646f 	rsbeq	r6, r5, pc, ror #8
     7b0:	636f6c42 	cmnvs	pc, #16896	; 0x4200
     7b4:	75435f6b 	strbvc	r5, [r3, #-3947]	; 0xfffff095
     7b8:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     7bc:	72505f74 	subsvc	r5, r0, #116, 30	; 0x1d0
     7c0:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     7c4:	69460073 	stmdbvs	r6, {r0, r1, r4, r5, r6}^
     7c8:	435f646e 	cmpmi	pc, #1845493760	; 0x6e000000
     7cc:	646c6968 	strbtvs	r6, [ip], #-2408	; 0xfffff698
     7d0:	73617400 	cmnvc	r1, #0, 8
     7d4:	7474006b 	ldrbtvc	r0, [r4], #-107	; 0xffffff95
     7d8:	00307262 	eorseq	r7, r0, r2, ror #4
     7dc:	6f6f526d 	svcvs	0x006f526d
     7e0:	6e4d5f74 	mcrvs	15, 2, r5, cr13, cr4, {3}
     7e4:	72640074 	rsbvc	r0, r4, #116	; 0x74
     7e8:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     7ec:	65704f00 	ldrbvs	r4, [r0, #-3840]!	; 0xfffff100
     7f0:	5a5f006e 	bpl	17c09b0 <__bss_end+0x17b7508>
     7f4:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     7f8:	636f7250 	cmnvs	pc, #80, 4
     7fc:	5f737365 	svcpl	0x00737365
     800:	616e614d 	cmnvs	lr, sp, asr #2
     804:	31726567 	cmncc	r2, r7, ror #10
     808:	70614d39 	rsbvc	r4, r1, r9, lsr sp
     80c:	6c69465f 	stclvs	6, cr4, [r9], #-380	; 0xfffffe84
     810:	6f545f65 	svcvs	0x00545f65
     814:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     818:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     81c:	49355045 	ldmdbmi	r5!, {r0, r2, r6, ip, lr}
     820:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     824:	72506d00 	subsvc	r6, r0, #0, 26
     828:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     82c:	694c5f73 	stmdbvs	ip, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     830:	485f7473 	ldmdami	pc, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^	; <UNPREDICTABLE>
     834:	00646165 	rsbeq	r6, r4, r5, ror #2
     838:	6d6f682f 	stclvs	8, cr6, [pc, #-188]!	; 784 <shift+0x784>
     83c:	63732f65 	cmnvs	r3, #404	; 0x194
     840:	6b6e6568 	blvs	1b99de8 <__bss_end+0x1b90940>
     844:	736f2f6a 	cmnvc	pc, #424	; 0x1a8
     848:	32323032 	eorscc	r3, r2, #50	; 0x32
     84c:	2f70732f 	svccs	0x0070732f
     850:	72756f73 	rsbsvc	r6, r5, #460	; 0x1cc
     854:	2f736563 	svccs	0x00736563
     858:	72657375 	rsbvc	r7, r5, #-738197503	; 0xd4000001
     85c:	63617073 	cmnvs	r1, #115	; 0x73
     860:	6e692f65 	cdpvs	15, 6, cr2, cr9, cr5, {3}
     864:	745f7469 	ldrbvc	r7, [pc], #-1129	; 86c <shift+0x86c>
     868:	2f6b7361 	svccs	0x006b7361
     86c:	6e69616d 	powvsez	f6, f1, #5.0
     870:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     874:	6f687300 	svcvs	0x00687300
     878:	75207472 	strvc	r7, [r0, #-1138]!	; 0xfffffb8e
     87c:	6769736e 	strbvs	r7, [r9, -lr, ror #6]!
     880:	2064656e 	rsbcs	r6, r4, lr, ror #10
     884:	00746e69 	rsbseq	r6, r4, r9, ror #28
     888:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     88c:	505f7966 	subspl	r7, pc, r6, ror #18
     890:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     894:	6d007373 	stcvs	3, cr7, [r0, #-460]	; 0xfffffe34
     898:	746f6f52 	strbtvc	r6, [pc], #-3922	; 8a0 <shift+0x8a0>
     89c:	7379535f 	cmnvc	r9, #2080374785	; 0x7c000001
     8a0:	746f4e00 	strbtvc	r4, [pc], #-3584	; 8a8 <shift+0x8a8>
     8a4:	41796669 	cmnmi	r9, r9, ror #12
     8a8:	42006c6c 	andmi	r6, r0, #108, 24	; 0x6c00
     8ac:	6b636f6c 	blvs	18dc664 <__bss_end+0x18d31bc>
     8b0:	52006465 	andpl	r6, r0, #1694498816	; 0x65000000
     8b4:	5f646165 	svcpl	0x00646165
     8b8:	796c6e4f 	stmdbvc	ip!, {r0, r1, r2, r3, r6, r9, sl, fp, sp, lr}^
     8bc:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     8c0:	50433631 	subpl	r3, r3, r1, lsr r6
     8c4:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     8c8:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 704 <shift+0x704>
     8cc:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     8d0:	34437265 	strbcc	r7, [r3], #-613	; 0xfffffd9b
     8d4:	47007645 	strmi	r7, [r0, -r5, asr #12]
     8d8:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     8dc:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     8e0:	72656c75 	rsbvc	r6, r5, #29952	; 0x7500
     8e4:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     8e8:	5a5f006f 	bpl	17c0aac <__bss_end+0x17b7604>
     8ec:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     8f0:	636f7250 	cmnvs	pc, #80, 4
     8f4:	5f737365 	svcpl	0x00737365
     8f8:	616e614d 	cmnvs	lr, sp, asr #2
     8fc:	31726567 	cmncc	r2, r7, ror #10
     900:	68635331 	stmdavs	r3!, {r0, r4, r5, r8, r9, ip, lr}^
     904:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     908:	52525f65 	subspl	r5, r2, #404	; 0x194
     90c:	52007645 	andpl	r7, r0, #72351744	; 0x4500000
     910:	616e6e75 	smcvs	59109	; 0xe6e5
     914:	00656c62 	rsbeq	r6, r5, r2, ror #24
     918:	5078614d 	rsbspl	r6, r8, sp, asr #2
     91c:	4c687461 	cfstrdmi	mvd7, [r8], #-388	; 0xfffffe7c
     920:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
     924:	536d0068 	cmnpl	sp, #104	; 0x68
     928:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     92c:	5f656c75 	svcpl	0x00656c75
     930:	00636e46 	rsbeq	r6, r3, r6, asr #28
     934:	314e5a5f 	cmpcc	lr, pc, asr sl
     938:	72504336 	subsvc	r4, r0, #-671088640	; 0xd8000000
     93c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     940:	614d5f73 	hvcvs	54771	; 0xd5f3
     944:	6567616e 	strbvs	r6, [r7, #-366]!	; 0xfffffe92
     948:	42313272 	eorsmi	r3, r1, #536870919	; 0x20000007
     94c:	6b636f6c 	blvs	18dc704 <__bss_end+0x18d325c>
     950:	7275435f 	rsbsvc	r4, r5, #2080374785	; 0x7c000001
     954:	746e6572 	strbtvc	r6, [lr], #-1394	; 0xfffffa8e
     958:	6f72505f 	svcvs	0x0072505f
     95c:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     960:	48007645 	stmdami	r0, {r0, r2, r6, r9, sl, ip, sp, lr}
     964:	6c646e61 	stclvs	14, cr6, [r4], #-388	; 0xfffffe7c
     968:	72505f65 	subsvc	r5, r0, #404	; 0x194
     96c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     970:	57535f73 			; <UNDEFINED> instruction: 0x57535f73
     974:	474e0049 	strbmi	r0, [lr, -r9, asr #32]
     978:	535f7465 	cmppl	pc, #1694498816	; 0x65000000
     97c:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
     980:	666e495f 			; <UNDEFINED> instruction: 0x666e495f
     984:	79545f6f 	ldmdbvc	r4, {r0, r1, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     988:	47006570 	smlsdxmi	r0, r0, r5, r6
     98c:	505f7465 	subspl	r7, pc, r5, ror #8
     990:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     994:	425f7373 	subsmi	r7, pc, #-872415231	; 0xcc000001
     998:	49505f79 	ldmdbmi	r0, {r0, r3, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     99c:	614d0044 	cmpvs	sp, r4, asr #32
     9a0:	69465f70 	stmdbvs	r6, {r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     9a4:	545f656c 	ldrbpl	r6, [pc], #-1388	; 9ac <shift+0x9ac>
     9a8:	75435f6f 	strbvc	r5, [r3, #-3951]	; 0xfffff091
     9ac:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
     9b0:	436d0074 	cmnmi	sp, #116	; 0x74
     9b4:	65727275 	ldrbvs	r7, [r2, #-629]!	; 0xfffffd8b
     9b8:	545f746e 	ldrbpl	r7, [pc], #-1134	; 9c0 <shift+0x9c0>
     9bc:	5f6b7361 	svcpl	0x006b7361
     9c0:	65646f4e 	strbvs	r6, [r4, #-3918]!	; 0xfffff0b2
     9c4:	434f4900 	movtmi	r4, #63744	; 0xf900
     9c8:	5f006c74 	svcpl	0x00006c74
     9cc:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     9d0:	6f725043 	svcvs	0x00725043
     9d4:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     9d8:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     9dc:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     9e0:	61483731 	cmpvs	r8, r1, lsr r7
     9e4:	656c646e 	strbvs	r6, [ip, #-1134]!	; 0xfffffb92
     9e8:	6d654d5f 	stclvs	13, cr4, [r5, #-380]!	; 0xfffffe84
     9ec:	5f79726f 	svcpl	0x0079726f
     9f0:	45495753 	strbmi	r5, [r9, #-1875]	; 0xfffff8ad
     9f4:	534e3931 	movtpl	r3, #59697	; 0xe931
     9f8:	4d5f4957 	vldrmi.16	s9, [pc, #-174]	; 952 <shift+0x952>	; <UNPREDICTABLE>
     9fc:	726f6d65 	rsbvc	r6, pc, #6464	; 0x1940
     a00:	65535f79 	ldrbvs	r5, [r3, #-3961]	; 0xfffff087
     a04:	63697672 	cmnvs	r9, #119537664	; 0x7200000
     a08:	6a6a6a65 	bvs	1a9b3a4 <__bss_end+0x1a91efc>
     a0c:	54313152 	ldrtpl	r3, [r1], #-338	; 0xfffffeae
     a10:	5f495753 	svcpl	0x00495753
     a14:	75736552 	ldrbvc	r6, [r3, #-1362]!	; 0xfffffaae
     a18:	6d00746c 	cfstrsvs	mvf7, [r0, #-432]	; 0xfffffe50
     a1c:	746f6f52 	strbtvc	r6, [pc], #-3922	; a24 <shift+0xa24>
     a20:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     a24:	50433631 	subpl	r3, r3, r1, lsr r6
     a28:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     a2c:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 868 <shift+0x868>
     a30:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     a34:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     a38:	646e6148 	strbtvs	r6, [lr], #-328	; 0xfffffeb8
     a3c:	505f656c 	subspl	r6, pc, ip, ror #10
     a40:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     a44:	535f7373 	cmppl	pc, #-872415231	; 0xcc000001
     a48:	32454957 	subcc	r4, r5, #1425408	; 0x15c000
     a4c:	57534e30 	smmlarpl	r3, r0, lr, r4
     a50:	72505f49 	subsvc	r5, r0, #292	; 0x124
     a54:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     a58:	65535f73 	ldrbvs	r5, [r3, #-3955]	; 0xfffff08d
     a5c:	63697672 	cmnvs	r9, #119537664	; 0x7200000
     a60:	6a6a6a65 	bvs	1a9b3fc <__bss_end+0x1a91f54>
     a64:	54313152 	ldrtpl	r3, [r1], #-338	; 0xfffffeae
     a68:	5f495753 	svcpl	0x00495753
     a6c:	75736552 	ldrbvc	r6, [r3, #-1362]!	; 0xfffffaae
     a70:	4300746c 	movwmi	r7, #1132	; 0x46c
     a74:	65736f6c 	ldrbvs	r6, [r3, #-3948]!	; 0xfffff094
     a78:	68635300 	stmdavs	r3!, {r8, r9, ip, lr}^
     a7c:	6c756465 	cfldrdvs	mvd6, [r5], #-404	; 0xfffffe6c
     a80:	5a5f0065 	bpl	17c0c1c <__bss_end+0x17b7774>
     a84:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     a88:	636f7250 	cmnvs	pc, #80, 4
     a8c:	5f737365 	svcpl	0x00737365
     a90:	616e614d 	cmnvs	lr, sp, asr #2
     a94:	32726567 	rsbscc	r6, r2, #432013312	; 0x19c00000
     a98:	6e614831 	mcrvs	8, 3, r4, cr1, cr1, {1}
     a9c:	5f656c64 	svcpl	0x00656c64
     aa0:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     aa4:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     aa8:	535f6d65 	cmppl	pc, #6464	; 0x1940
     aac:	32454957 	subcc	r4, r5, #1425408	; 0x15c000
     ab0:	57534e33 	smmlarpl	r3, r3, lr, r4
     ab4:	69465f49 	stmdbvs	r6, {r0, r3, r6, r8, r9, sl, fp, ip, lr}^
     ab8:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     abc:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     ac0:	7265535f 	rsbvc	r5, r5, #2080374785	; 0x7c000001
     ac4:	65636976 	strbvs	r6, [r3, #-2422]!	; 0xfffff68a
     ac8:	526a6a6a 	rsbpl	r6, sl, #434176	; 0x6a000
     acc:	53543131 	cmppl	r4, #1073741836	; 0x4000000c
     ad0:	525f4957 	subspl	r4, pc, #1425408	; 0x15c000
     ad4:	6c757365 	ldclvs	3, cr7, [r5], #-404	; 0xfffffe6c
     ad8:	6f4c0074 	svcvs	0x004c0074
     adc:	4c5f6b63 	mrrcmi	11, 6, r6, pc, cr3	; <UNPREDICTABLE>
     ae0:	656b636f 	strbvs	r6, [fp, #-879]!	; 0xfffffc91
     ae4:	50430064 	subpl	r0, r3, r4, rrx
     ae8:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     aec:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 928 <shift+0x928>
     af0:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     af4:	4e007265 	cdpmi	2, 0, cr7, cr0, cr5, {3}
     af8:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     afc:	6f4e0079 	svcvs	0x004e0079
     b00:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
     b04:	74737973 	ldrbtvc	r7, [r3], #-2419	; 0xfffff68d
     b08:	72446d65 	subvc	r6, r4, #6464	; 0x1940
     b0c:	72657669 	rsbvc	r7, r5, #110100480	; 0x6900000
     b10:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     b14:	46433131 			; <UNDEFINED> instruction: 0x46433131
     b18:	73656c69 	cmnvc	r5, #26880	; 0x6900
     b1c:	65747379 	ldrbvs	r7, [r4, #-889]!	; 0xfffffc87
     b20:	5433316d 	ldrtpl	r3, [r3], #-365	; 0xfffffe93
     b24:	545f5346 	ldrbpl	r5, [pc], #-838	; b2c <shift+0xb2c>
     b28:	5f656572 	svcpl	0x00656572
     b2c:	65646f4e 	strbvs	r6, [r4, #-3918]!	; 0xfffff0b2
     b30:	69463031 	stmdbvs	r6, {r0, r4, r5, ip, sp}^
     b34:	435f646e 	cmpmi	pc, #1845493760	; 0x6e000000
     b38:	646c6968 	strbtvs	r6, [ip], #-2408	; 0xfffff698
     b3c:	634b5045 	movtvs	r5, #45125	; 0xb045
     b40:	61654400 	cmnvs	r5, r0, lsl #8
     b44:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     b48:	6e555f65 	cdpvs	15, 5, cr5, cr5, cr5, {3}
     b4c:	6e616863 	cdpvs	8, 6, cr6, cr1, cr3, {3}
     b50:	00646567 	rsbeq	r6, r4, r7, ror #10
     b54:	314e5a5f 	cmpcc	lr, pc, asr sl
     b58:	69464331 	stmdbvs	r6, {r0, r4, r5, r8, r9, lr}^
     b5c:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     b60:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     b64:	76453443 	strbvc	r3, [r5], -r3, asr #8
     b68:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     b6c:	50433631 	subpl	r3, r3, r1, lsr r6
     b70:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     b74:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; 9b0 <shift+0x9b0>
     b78:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     b7c:	38317265 	ldmdacc	r1!, {r0, r2, r5, r6, r9, ip, sp, lr}
     b80:	5f746547 	svcpl	0x00746547
     b84:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     b88:	656c7564 	strbvs	r7, [ip, #-1380]!	; 0xfffffa9c
     b8c:	6e495f72 	mcrvs	15, 2, r5, cr9, cr2, {3}
     b90:	32456f66 	subcc	r6, r5, #408	; 0x198
     b94:	65474e30 	strbvs	r4, [r7, #-3632]	; 0xfffff1d0
     b98:	63535f74 	cmpvs	r3, #116, 30	; 0x1d0
     b9c:	5f646568 	svcpl	0x00646568
     ba0:	6f666e49 	svcvs	0x00666e49
     ba4:	7079545f 	rsbsvc	r5, r9, pc, asr r4
     ba8:	00765065 	rsbseq	r5, r6, r5, rrx
     bac:	6e6e7552 	mcrvs	5, 3, r7, cr14, cr2, {2}
     bb0:	00676e69 	rsbeq	r6, r7, r9, ror #28
     bb4:	5f746547 	svcpl	0x00746547
     bb8:	65686353 	strbvs	r6, [r8, #-851]!	; 0xfffffcad
     bbc:	6e495f64 	cdpvs	15, 4, cr5, cr9, cr4, {3}
     bc0:	54006f66 	strpl	r6, [r0], #-3942	; 0xfffff09a
     bc4:	696d7265 	stmdbvs	sp!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     bc8:	6574616e 	ldrbvs	r6, [r4, #-366]!	; 0xfffffe92
     bcc:	69464900 	stmdbvs	r6, {r8, fp, lr}^
     bd0:	7973656c 	ldmdbvc	r3!, {r2, r3, r5, r6, r8, sl, sp, lr}^
     bd4:	6d657473 	cfstrdvs	mvd7, [r5, #-460]!	; 0xfffffe34
     bd8:	6972445f 	ldmdbvs	r2!, {r0, r1, r2, r3, r4, r6, sl, lr}^
     bdc:	00726576 	rsbseq	r6, r2, r6, ror r5
     be0:	76657270 			; <UNDEFINED> instruction: 0x76657270
     be4:	74634100 	strbtvc	r4, [r3], #-256	; 0xffffff00
     be8:	5f657669 	svcpl	0x00657669
     bec:	636f7250 	cmnvs	pc, #80, 4
     bf0:	5f737365 	svcpl	0x00737365
     bf4:	6e756f43 	cdpvs	15, 7, cr6, cr5, cr3, {2}
     bf8:	5a5f0074 	bpl	17c0dd0 <__bss_end+0x17b7928>
     bfc:	4336314e 	teqmi	r6, #-2147483629	; 0x80000013
     c00:	636f7250 	cmnvs	pc, #80, 4
     c04:	5f737365 	svcpl	0x00737365
     c08:	616e614d 	cmnvs	lr, sp, asr #2
     c0c:	39726567 	ldmdbcc	r2!, {r0, r1, r2, r5, r6, r8, sl, sp, lr}^
     c10:	74697753 	strbtvc	r7, [r9], #-1875	; 0xfffff8ad
     c14:	545f6863 	ldrbpl	r6, [pc], #-2147	; c1c <shift+0xc1c>
     c18:	3150456f 	cmpcc	r0, pc, ror #10
     c1c:	72504338 	subsvc	r4, r0, #56, 6	; 0xe0000000
     c20:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     c24:	694c5f73 	stmdbvs	ip, {r0, r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
     c28:	4e5f7473 	mrcmi	4, 2, r7, cr15, cr3, {3}
     c2c:	0065646f 	rsbeq	r6, r5, pc, ror #8
     c30:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
     c34:	6f635f64 	svcvs	0x00635f64
     c38:	65746e75 	ldrbvs	r6, [r4, #-3701]!	; 0xfffff18b
     c3c:	63530072 	cmpvs	r3, #114	; 0x72
     c40:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     c44:	455f656c 	ldrbmi	r6, [pc, #-1388]	; 6e0 <shift+0x6e0>
     c48:	57004644 	strpl	r4, [r0, -r4, asr #12]
     c4c:	65746972 	ldrbvs	r6, [r4, #-2418]!	; 0xfffff68e
     c50:	6c6e4f5f 	stclvs	15, cr4, [lr], #-380	; 0xfffffe84
     c54:	656e0079 	strbvs	r0, [lr, #-121]!	; 0xffffff87
     c58:	5f007478 	svcpl	0x00007478
     c5c:	36314e5a 			; <UNDEFINED> instruction: 0x36314e5a
     c60:	6f725043 	svcvs	0x00725043
     c64:	73736563 	cmnvc	r3, #415236096	; 0x18c00000
     c68:	6e614d5f 	mcrvs	13, 3, r4, cr1, cr15, {2}
     c6c:	72656761 	rsbvc	r6, r5, #25427968	; 0x1840000
     c70:	63533231 	cmpvs	r3, #268435459	; 0x10000003
     c74:	75646568 	strbvc	r6, [r4, #-1384]!	; 0xfffffa98
     c78:	455f656c 	ldrbmi	r6, [pc, #-1388]	; 714 <shift+0x714>
     c7c:	76454644 	strbvc	r4, [r5], -r4, asr #12
     c80:	4e5a5f00 	cdpmi	15, 5, cr5, cr10, cr0, {0}
     c84:	50433631 	subpl	r3, r3, r1, lsr r6
     c88:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     c8c:	4d5f7373 	ldclmi	3, cr7, [pc, #-460]	; ac8 <shift+0xac8>
     c90:	67616e61 	strbvs	r6, [r1, -r1, ror #28]!
     c94:	34317265 	ldrtcc	r7, [r1], #-613	; 0xfffffd9b
     c98:	69746f4e 	ldmdbvs	r4!, {r1, r2, r3, r6, r8, r9, sl, fp, sp, lr}^
     c9c:	505f7966 	subspl	r7, pc, r6, ror #18
     ca0:	65636f72 	strbvs	r6, [r3, #-3954]!	; 0xfffff08e
     ca4:	50457373 	subpl	r7, r5, r3, ror r3
     ca8:	54543231 	ldrbpl	r3, [r4], #-561	; 0xfffffdcf
     cac:	5f6b7361 	svcpl	0x006b7361
     cb0:	75727453 	ldrbvc	r7, [r2, #-1107]!	; 0xfffffbad
     cb4:	5f007463 	svcpl	0x00007463
     cb8:	31314e5a 	teqcc	r1, sl, asr lr
     cbc:	6c694643 	stclvs	6, cr4, [r9], #-268	; 0xfffffef4
     cc0:	73797365 	cmnvc	r9, #-1811939327	; 0x94000001
     cc4:	316d6574 	smccc	54868	; 0xd654
     cc8:	696e4930 	stmdbvs	lr!, {r4, r5, r8, fp, lr}^
     ccc:	6c616974 			; <UNDEFINED> instruction: 0x6c616974
     cd0:	45657a69 	strbmi	r7, [r5, #-2665]!	; 0xfffff597
     cd4:	6c630076 	stclvs	0, cr0, [r3], #-472	; 0xfffffe28
     cd8:	0065736f 	rsbeq	r7, r5, pc, ror #6
     cdc:	5f746553 	svcpl	0x00746553
     ce0:	616c6552 	cmnvs	ip, r2, asr r5
     ce4:	65766974 	ldrbvs	r6, [r6, #-2420]!	; 0xfffff68c
     ce8:	75636e00 	strbvc	r6, [r3, #-3584]!	; 0xfffff200
     cec:	69700072 	ldmdbvs	r0!, {r1, r4, r5, r6}^
     cf0:	72006570 	andvc	r6, r0, #112, 10	; 0x1c000000
     cf4:	6d756e64 	ldclvs	14, cr6, [r5, #-400]!	; 0xfffffe70
     cf8:	315a5f00 	cmpcc	sl, r0, lsl #30
     cfc:	68637331 	stmdavs	r3!, {r0, r4, r5, r8, r9, ip, sp, lr}^
     d00:	795f6465 	ldmdbvc	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     d04:	646c6569 	strbtvs	r6, [ip], #-1385	; 0xfffffa97
     d08:	5a5f0076 	bpl	17c0ee8 <__bss_end+0x17b7a40>
     d0c:	65733731 	ldrbvs	r3, [r3, #-1841]!	; 0xfffff8cf
     d10:	61745f74 	cmnvs	r4, r4, ror pc
     d14:	645f6b73 	ldrbvs	r6, [pc], #-2931	; d1c <shift+0xd1c>
     d18:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     d1c:	6a656e69 	bvs	195c6c8 <__bss_end+0x1953220>
     d20:	69727700 	ldmdbvs	r2!, {r8, r9, sl, ip, sp, lr}^
     d24:	77006574 	smlsdxvc	r0, r4, r5, r6
     d28:	00746961 	rsbseq	r6, r4, r1, ror #18
     d2c:	6e365a5f 			; <UNDEFINED> instruction: 0x6e365a5f
     d30:	6669746f 	strbtvs	r7, [r9], -pc, ror #8
     d34:	006a6a79 	rsbeq	r6, sl, r9, ror sl
     d38:	74395a5f 	ldrtvc	r5, [r9], #-2655	; 0xfffff5a1
     d3c:	696d7265 	stmdbvs	sp!, {r0, r2, r5, r6, r9, ip, sp, lr}^
     d40:	6574616e 	ldrbvs	r6, [r4, #-366]!	; 0xfffffe92
     d44:	682f0069 	stmdavs	pc!, {r0, r3, r5, r6}	; <UNPREDICTABLE>
     d48:	2f656d6f 	svccs	0x00656d6f
     d4c:	65686373 	strbvs	r6, [r8, #-883]!	; 0xfffffc8d
     d50:	2f6a6b6e 	svccs	0x006a6b6e
     d54:	3032736f 	eorscc	r7, r2, pc, ror #6
     d58:	732f3232 			; <UNDEFINED> instruction: 0x732f3232
     d5c:	6f732f70 	svcvs	0x00732f70
     d60:	65637275 	strbvs	r7, [r3, #-629]!	; 0xfffffd8b
     d64:	74732f73 	ldrbtvc	r2, [r3], #-3955	; 0xfffff08d
     d68:	62696c64 	rsbvs	r6, r9, #100, 24	; 0x6400
     d6c:	6372732f 	cmnvs	r2, #-1140850688	; 0xbc000000
     d70:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
     d74:	656c6966 	strbvs	r6, [ip, #-2406]!	; 0xfffff69a
     d78:	7070632e 	rsbsvc	r6, r0, lr, lsr #6
     d7c:	69614600 	stmdbvs	r1!, {r9, sl, lr}^
     d80:	7865006c 	stmdavc	r5!, {r2, r3, r5, r6}^
     d84:	6f637469 	svcvs	0x00637469
     d88:	5f006564 	svcpl	0x00006564
     d8c:	6734325a 			; <UNDEFINED> instruction: 0x6734325a
     d90:	615f7465 	cmpvs	pc, r5, ror #8
     d94:	76697463 	strbtvc	r7, [r9], -r3, ror #8
     d98:	72705f65 	rsbsvc	r5, r0, #404	; 0x194
     d9c:	7365636f 	cmnvc	r5, #-1140850687	; 0xbc000001
     da0:	6f635f73 	svcvs	0x00635f73
     da4:	76746e75 			; <UNDEFINED> instruction: 0x76746e75
     da8:	68637300 	stmdavs	r3!, {r8, r9, ip, sp, lr}^
     dac:	795f6465 	ldmdbvc	pc, {r0, r2, r5, r6, sl, sp, lr}^	; <UNPREDICTABLE>
     db0:	646c6569 	strbtvs	r6, [ip], #-1385	; 0xfffffa97
     db4:	63697400 	cmnvs	r9, #0, 8
     db8:	6f635f6b 	svcvs	0x00635f6b
     dbc:	5f746e75 	svcpl	0x00746e75
     dc0:	75716572 	ldrbvc	r6, [r1, #-1394]!	; 0xfffffa8e
     dc4:	64657269 	strbtvs	r7, [r5], #-617	; 0xfffffd97
     dc8:	70695000 	rsbvc	r5, r9, r0
     dcc:	69465f65 	stmdbvs	r6, {r0, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     dd0:	505f656c 	subspl	r6, pc, ip, ror #10
     dd4:	69666572 	stmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
     dd8:	65530078 	ldrbvs	r0, [r3, #-120]	; 0xffffff88
     ddc:	61505f74 	cmpvs	r0, r4, ror pc
     de0:	736d6172 	cmnvc	sp, #-2147483620	; 0x8000001c
     de4:	315a5f00 	cmpcc	sl, r0, lsl #30
     de8:	74656734 	strbtvc	r6, [r5], #-1844	; 0xfffff8cc
     dec:	6369745f 	cmnvs	r9, #1593835520	; 0x5f000000
     df0:	6f635f6b 	svcvs	0x00635f6b
     df4:	76746e75 			; <UNDEFINED> instruction: 0x76746e75
     df8:	656c7300 	strbvs	r7, [ip, #-768]!	; 0xfffffd00
     dfc:	44007065 	strmi	r7, [r0], #-101	; 0xffffff9b
     e00:	62617369 	rsbvs	r7, r1, #-1543503871	; 0xa4000001
     e04:	455f656c 	ldrbmi	r6, [pc, #-1388]	; 8a0 <shift+0x8a0>
     e08:	746e6576 	strbtvc	r6, [lr], #-1398	; 0xfffffa8a
     e0c:	7465445f 	strbtvc	r4, [r5], #-1119	; 0xfffffba1
     e10:	69746365 	ldmdbvs	r4!, {r0, r2, r5, r6, r8, r9, sp, lr}^
     e14:	2f006e6f 	svccs	0x00006e6f
     e18:	656d6f68 	strbvs	r6, [sp, #-3944]!	; 0xfffff098
     e1c:	6863732f 	stmdavs	r3!, {r0, r1, r2, r3, r5, r8, r9, ip, sp, lr}^
     e20:	6a6b6e65 	bvs	1adc7bc <__bss_end+0x1ad3314>
     e24:	32736f2f 	rsbscc	r6, r3, #47, 30	; 0xbc
     e28:	2f323230 	svccs	0x00323230
     e2c:	732f7073 			; <UNDEFINED> instruction: 0x732f7073
     e30:	6372756f 	cmnvs	r2, #465567744	; 0x1bc00000
     e34:	622f7365 	eorvs	r7, pc, #-1811939327	; 0x94000001
     e38:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
     e3c:	65706f00 	ldrbvs	r6, [r0, #-3840]!	; 0xfffff100
     e40:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
     e44:	5f006e6f 	svcpl	0x00006e6f
     e48:	6c63355a 	cfstr64vs	mvdx3, [r3], #-360	; 0xfffffe98
     e4c:	6a65736f 	bvs	195dc10 <__bss_end+0x1954768>
     e50:	365a5f00 	ldrbcc	r5, [sl], -r0, lsl #30
     e54:	70746567 	rsbsvc	r6, r4, r7, ror #10
     e58:	00766469 	rsbseq	r6, r6, r9, ror #8
     e5c:	6d616e66 	stclvs	14, cr6, [r1, #-408]!	; 0xfffffe68
     e60:	6f6e0065 	svcvs	0x006e0065
     e64:	79666974 	stmdbvc	r6!, {r2, r4, r5, r6, r8, fp, sp, lr}^
     e68:	74657200 	strbtvc	r7, [r5], #-512	; 0xfffffe00
     e6c:	006c6176 	rsbeq	r6, ip, r6, ror r1
     e70:	6b636974 	blvs	18db448 <__bss_end+0x18d1fa0>
     e74:	706f0073 	rsbvc	r0, pc, r3, ror r0	; <UNPREDICTABLE>
     e78:	5f006e65 	svcpl	0x00006e65
     e7c:	6970345a 	ldmdbvs	r0!, {r1, r3, r4, r6, sl, ip, sp}^
     e80:	4b506570 	blmi	141a448 <__bss_end+0x1410fa0>
     e84:	4e006a63 	vmlsmi.f32	s12, s0, s7
     e88:	64616544 	strbtvs	r6, [r1], #-1348	; 0xfffffabc
     e8c:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     e90:	6275535f 	rsbsvs	r5, r5, #2080374785	; 0x7c000001
     e94:	76726573 			; <UNDEFINED> instruction: 0x76726573
     e98:	00656369 	rsbeq	r6, r5, r9, ror #6
     e9c:	5f746567 	svcpl	0x00746567
     ea0:	6b636974 	blvs	18db478 <__bss_end+0x18d1fd0>
     ea4:	756f635f 	strbvc	r6, [pc, #-863]!	; b4d <shift+0xb4d>
     ea8:	7000746e 	andvc	r7, r0, lr, ror #8
     eac:	6d617261 	sfmvs	f7, 2, [r1, #-388]!	; 0xfffffe7c
     eb0:	355a5f00 	ldrbcc	r5, [sl, #-3840]	; 0xfffff100
     eb4:	74697277 	strbtvc	r7, [r9], #-631	; 0xfffffd89
     eb8:	4b506a65 	blmi	141b854 <__bss_end+0x14123ac>
     ebc:	72006a63 	andvc	r6, r0, #405504	; 0x63000
     ec0:	6f637465 	svcvs	0x00637465
     ec4:	67006564 	strvs	r6, [r0, -r4, ror #10]
     ec8:	745f7465 	ldrbvc	r7, [pc], #-1125	; ed0 <shift+0xed0>
     ecc:	5f6b7361 	svcpl	0x006b7361
     ed0:	6b636974 	blvs	18db4a8 <__bss_end+0x18d2000>
     ed4:	6f745f73 	svcvs	0x00745f73
     ed8:	6165645f 	cmnvs	r5, pc, asr r4
     edc:	6e696c64 	cdpvs	12, 6, cr6, cr9, cr4, {3}
     ee0:	75620065 	strbvc	r0, [r2, #-101]!	; 0xffffff9b
     ee4:	69735f66 	ldmdbvs	r3!, {r1, r2, r5, r6, r8, r9, sl, fp, ip, lr}^
     ee8:	7300657a 	movwvc	r6, #1402	; 0x57a
     eec:	745f7465 	ldrbvc	r7, [pc], #-1125	; ef4 <shift+0xef4>
     ef0:	5f6b7361 	svcpl	0x006b7361
     ef4:	64616564 	strbtvs	r6, [r1], #-1380	; 0xfffffa9c
     ef8:	656e696c 	strbvs	r6, [lr, #-2412]!	; 0xfffff694
     efc:	74654700 	strbtvc	r4, [r5], #-1792	; 0xfffff900
     f00:	7261505f 	rsbvc	r5, r1, #95	; 0x5f
     f04:	00736d61 	rsbseq	r6, r3, r1, ror #26
     f08:	73355a5f 	teqvc	r5, #389120	; 0x5f000
     f0c:	7065656c 	rsbvc	r6, r5, ip, ror #10
     f10:	66006a6a 	strvs	r6, [r0], -sl, ror #20
     f14:	00656c69 	rsbeq	r6, r5, r9, ror #24
     f18:	5f746547 	svcpl	0x00746547
     f1c:	616d6552 	cmnvs	sp, r2, asr r5
     f20:	6e696e69 	cdpvs	14, 6, cr6, cr9, cr9, {3}
     f24:	6e450067 	cdpvs	0, 4, cr0, cr5, cr7, {3}
     f28:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
     f2c:	6576455f 	ldrbvs	r4, [r6, #-1375]!	; 0xfffffaa1
     f30:	445f746e 	ldrbmi	r7, [pc], #-1134	; f38 <shift+0xf38>
     f34:	63657465 	cmnvs	r5, #1694498816	; 0x65000000
     f38:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     f3c:	325a5f00 	subscc	r5, sl, #0, 30
     f40:	74656736 	strbtvc	r6, [r5], #-1846	; 0xfffff8ca
     f44:	7361745f 	cmnvc	r1, #1593835520	; 0x5f000000
     f48:	69745f6b 	ldmdbvs	r4!, {r0, r1, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
     f4c:	5f736b63 	svcpl	0x00736b63
     f50:	645f6f74 	ldrbvs	r6, [pc], #-3956	; f58 <shift+0xf58>
     f54:	6c646165 	stfvse	f6, [r4], #-404	; 0xfffffe6c
     f58:	76656e69 	strbtvc	r6, [r5], -r9, ror #28
     f5c:	57534e00 	ldrbpl	r4, [r3, -r0, lsl #28]
     f60:	65525f49 	ldrbvs	r5, [r2, #-3913]	; 0xfffff0b7
     f64:	746c7573 	strbtvc	r7, [ip], #-1395	; 0xfffffa8d
     f68:	646f435f 	strbtvs	r4, [pc], #-863	; f70 <shift+0xf70>
     f6c:	72770065 	rsbsvc	r0, r7, #101	; 0x65
     f70:	006d756e 	rsbeq	r7, sp, lr, ror #10
     f74:	77345a5f 			; <UNDEFINED> instruction: 0x77345a5f
     f78:	6a746961 	bvs	1d1b504 <__bss_end+0x1d1205c>
     f7c:	5f006a6a 	svcpl	0x00006a6a
     f80:	6f69355a 	svcvs	0x0069355a
     f84:	6a6c7463 	bvs	1b1e118 <__bss_end+0x1b14c70>
     f88:	494e3631 	stmdbmi	lr, {r0, r4, r5, r9, sl, ip, sp}^
     f8c:	6c74434f 	ldclvs	3, cr4, [r4], #-316	; 0xfffffec4
     f90:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
     f94:	69746172 	ldmdbvs	r4!, {r1, r4, r5, r6, r8, sp, lr}^
     f98:	76506e6f 	ldrbvc	r6, [r0], -pc, ror #28
     f9c:	636f6900 	cmnvs	pc, #0, 18
     fa0:	72006c74 	andvc	r6, r0, #116, 24	; 0x7400
     fa4:	6e637465 	cdpvs	4, 6, cr7, cr3, cr5, {3}
     fa8:	65740074 	ldrbvs	r0, [r4, #-116]!	; 0xffffff8c
     fac:	6e696d72 	mcrvs	13, 3, r6, cr9, cr2, {3}
     fb0:	00657461 	rsbeq	r7, r5, r1, ror #8
     fb4:	65646f6d 	strbvs	r6, [r4, #-3949]!	; 0xfffff093
     fb8:	66756200 	ldrbtvs	r6, [r5], -r0, lsl #4
     fbc:	00726566 	rsbseq	r6, r2, r6, ror #10
     fc0:	72345a5f 	eorsvc	r5, r4, #389120	; 0x5f000
     fc4:	6a646165 	bvs	1919560 <__bss_end+0x19100b8>
     fc8:	006a6350 	rsbeq	r6, sl, r0, asr r3
     fcc:	434f494e 	movtmi	r4, #63822	; 0xf94e
     fd0:	4f5f6c74 	svcmi	0x005f6c74
     fd4:	61726570 	cmnvs	r2, r0, ror r5
     fd8:	6e6f6974 			; <UNDEFINED> instruction: 0x6e6f6974
     fdc:	74656700 	strbtvc	r6, [r5], #-1792	; 0xfffff900
     fe0:	7463615f 	strbtvc	r6, [r3], #-351	; 0xfffffea1
     fe4:	5f657669 	svcpl	0x00657669
     fe8:	636f7270 	cmnvs	pc, #112, 4
     fec:	5f737365 	svcpl	0x00737365
     ff0:	6e756f63 	cdpvs	15, 7, cr6, cr5, cr3, {3}
     ff4:	69660074 	stmdbvs	r6!, {r2, r4, r5, r6}^
     ff8:	616e656c 	cmnvs	lr, ip, ror #10
     ffc:	7200656d 	andvc	r6, r0, #457179136	; 0x1b400000
    1000:	00646165 	rsbeq	r6, r4, r5, ror #2
    1004:	70746567 	rsbsvc	r6, r4, r7, ror #10
    1008:	5f006469 	svcpl	0x00006469
    100c:	706f345a 	rsbvc	r3, pc, sl, asr r4	; <UNPREDICTABLE>
    1010:	4b506e65 	blmi	141c9ac <__bss_end+0x1413504>
    1014:	4e353163 	rsfmisz	f3, f5, f3
    1018:	656c6946 	strbvs	r6, [ip, #-2374]!	; 0xfffff6ba
    101c:	65704f5f 	ldrbvs	r4, [r0, #-3935]!	; 0xfffff0a1
    1020:	6f4d5f6e 	svcvs	0x004d5f6e
    1024:	47006564 	strmi	r6, [r0, -r4, ror #10]
    1028:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
    102c:	34312b2b 	ldrtcc	r2, [r1], #-2859	; 0xfffff4d5
    1030:	322e3920 	eorcc	r3, lr, #32, 18	; 0x80000
    1034:	3220312e 	eorcc	r3, r0, #-2147483637	; 0x8000000b
    1038:	31393130 	teqcc	r9, r0, lsr r1
    103c:	20353230 	eorscs	r3, r5, r0, lsr r2
    1040:	6c657228 	sfmvs	f7, 2, [r5], #-160	; 0xffffff60
    1044:	65736165 	ldrbvs	r6, [r3, #-357]!	; 0xfffffe9b
    1048:	415b2029 	cmpmi	fp, r9, lsr #32
    104c:	612f4d52 			; <UNDEFINED> instruction: 0x612f4d52
    1050:	392d6d72 	pushcc	{r1, r4, r5, r6, r8, sl, fp, sp, lr}
    1054:	6172622d 	cmnvs	r2, sp, lsr #4
    1058:	2068636e 	rsbcs	r6, r8, lr, ror #6
    105c:	69766572 	ldmdbvs	r6!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    1060:	6e6f6973 			; <UNDEFINED> instruction: 0x6e6f6973
    1064:	37373220 	ldrcc	r3, [r7, -r0, lsr #4]!
    1068:	5d393935 			; <UNDEFINED> instruction: 0x5d393935
    106c:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    1070:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    1074:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
    1078:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
    107c:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
    1080:	3d757066 	ldclcc	0, cr7, [r5, #-408]!	; 0xfffffe68
    1084:	20706676 	rsbscs	r6, r0, r6, ror r6
    1088:	6c666d2d 	stclvs	13, cr6, [r6], #-180	; 0xffffff4c
    108c:	2d74616f 	ldfcse	f6, [r4, #-444]!	; 0xfffffe44
    1090:	3d696261 	sfmcc	f6, 2, [r9, #-388]!	; 0xfffffe7c
    1094:	64726168 	ldrbtvs	r6, [r2], #-360	; 0xfffffe98
    1098:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    109c:	763d7570 			; <UNDEFINED> instruction: 0x763d7570
    10a0:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    10a4:	6e75746d 	cdpvs	4, 7, cr7, cr5, cr13, {3}
    10a8:	72613d65 	rsbvc	r3, r1, #6464	; 0x1940
    10ac:	3731316d 	ldrcc	r3, [r1, -sp, ror #2]!
    10b0:	667a6a36 			; <UNDEFINED> instruction: 0x667a6a36
    10b4:	2d20732d 	stccs	3, cr7, [r0, #-180]!	; 0xffffff4c
    10b8:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
    10bc:	616d2d20 	cmnvs	sp, r0, lsr #26
    10c0:	3d686372 	stclcc	3, cr6, [r8, #-456]!	; 0xfffffe38
    10c4:	766d7261 	strbtvc	r7, [sp], -r1, ror #4
    10c8:	2b6b7a36 	blcs	1adf9a8 <__bss_end+0x1ad6500>
    10cc:	2d207066 	stccs	0, cr7, [r0, #-408]!	; 0xfffffe68
    10d0:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    10d4:	20672d20 	rsbcs	r2, r7, r0, lsr #26
    10d8:	20304f2d 	eorscs	r4, r0, sp, lsr #30
    10dc:	20304f2d 	eorscs	r4, r0, sp, lsr #30
    10e0:	6f6e662d 	svcvs	0x006e662d
    10e4:	6378652d 	cmnvs	r8, #188743680	; 0xb400000
    10e8:	69747065 	ldmdbvs	r4!, {r0, r2, r5, r6, ip, sp, lr}^
    10ec:	20736e6f 	rsbscs	r6, r3, pc, ror #28
    10f0:	6f6e662d 	svcvs	0x006e662d
    10f4:	7474722d 	ldrbtvc	r7, [r4], #-557	; 0xfffffdd3
    10f8:	6f6e0069 	svcvs	0x006e0069
    10fc:	6c616d72 	stclvs	13, cr6, [r1], #-456	; 0xfffffe38
    1100:	00657a69 	rsbeq	r7, r5, r9, ror #20
    1104:	6d365a5f 	vldmdbvs	r6!, {s10-s104}
    1108:	70636d65 	rsbvc	r6, r3, r5, ror #26
    110c:	764b5079 			; <UNDEFINED> instruction: 0x764b5079
    1110:	00697650 	rsbeq	r7, r9, r0, asr r6
    1114:	756c6176 	strbvc	r6, [ip, #-374]!	; 0xfffffe8a
    1118:	5a5f0065 	bpl	17c12b4 <__bss_end+0x17b7e0c>
    111c:	6f746934 	svcvs	0x00746934
    1120:	63506a61 	cmpvs	r0, #397312	; 0x61000
    1124:	7865006a 	stmdavc	r5!, {r1, r3, r5, r6}^
    1128:	656e6f70 	strbvs	r6, [lr, #-3952]!	; 0xfffff090
    112c:	6100746e 	tstvs	r0, lr, ror #8
    1130:	00696f74 	rsbeq	r6, r9, r4, ror pc
    1134:	6c727473 	cfldrdvs	mvd7, [r2], #-460	; 0xfffffe34
    1138:	5f006e65 	svcpl	0x00006e65
    113c:	7461345a 	strbtvc	r3, [r1], #-1114	; 0xfffffba6
    1140:	4b50666f 	blmi	141ab04 <__bss_end+0x141165c>
    1144:	65640063 	strbvs	r0, [r4, #-99]!	; 0xffffff9d
    1148:	69007473 	stmdbvs	r0, {r0, r1, r4, r5, r6, sl, ip, sp, lr}
    114c:	7475706e 	ldrbtvc	r7, [r5], #-110	; 0xffffff92
    1150:	67697300 	strbvs	r7, [r9, -r0, lsl #6]!
    1154:	7469006e 	strbtvc	r0, [r9], #-110	; 0xffffff92
    1158:	7300616f 	movwvc	r6, #367	; 0x16f
    115c:	61637274 	smcvs	14116	; 0x3724
    1160:	5a5f0074 	bpl	17c1338 <__bss_end+0x17b7e90>
    1164:	657a6235 	ldrbvs	r6, [sl, #-565]!	; 0xfffffdcb
    1168:	76506f72 	usub16vc	r6, r0, r2
    116c:	74730069 	ldrbtvc	r0, [r3], #-105	; 0xffffff97
    1170:	70636e72 	rsbvc	r6, r3, r2, ror lr
    1174:	5a5f0079 	bpl	17c1360 <__bss_end+0x17b7eb8>
    1178:	6f746634 	svcvs	0x00746634
    117c:	66635061 	strbtvs	r5, [r3], -r1, rrx
    1180:	6f682f00 	svcvs	0x00682f00
    1184:	732f656d 			; <UNDEFINED> instruction: 0x732f656d
    1188:	6e656863 	cdpvs	8, 6, cr6, cr5, cr3, {3}
    118c:	6f2f6a6b 	svcvs	0x002f6a6b
    1190:	32303273 	eorscc	r3, r0, #805306375	; 0x30000007
    1194:	70732f32 	rsbsvc	r2, r3, r2, lsr pc
    1198:	756f732f 	strbvc	r7, [pc, #-815]!	; e71 <shift+0xe71>
    119c:	73656372 	cmnvc	r5, #-939524095	; 0xc8000001
    11a0:	6474732f 	ldrbtvs	r7, [r4], #-815	; 0xfffffcd1
    11a4:	2f62696c 	svccs	0x0062696c
    11a8:	2f637273 	svccs	0x00637273
    11ac:	73647473 	cmnvc	r4, #1929379840	; 0x73000000
    11b0:	6e697274 	mcrvs	2, 3, r7, cr9, cr4, {3}
    11b4:	70632e67 	rsbvc	r2, r3, r7, ror #28
    11b8:	5a5f0070 	bpl	17c1380 <__bss_end+0x17b7ed8>
    11bc:	72747337 	rsbsvc	r7, r4, #-603979776	; 0xdc000000
    11c0:	7970636e 	ldmdbvc	r0!, {r1, r2, r3, r5, r6, r8, r9, sp, lr}^
    11c4:	4b506350 	blmi	1419f0c <__bss_end+0x1410a64>
    11c8:	5f006963 	svcpl	0x00006963
    11cc:	7473365a 	ldrbtvc	r3, [r3], #-1626	; 0xfffff9a6
    11d0:	74616372 	strbtvc	r6, [r1], #-882	; 0xfffffc8e
    11d4:	4b506350 	blmi	1419f1c <__bss_end+0x1410a74>
    11d8:	5a5f0063 	bpl	17c136c <__bss_end+0x17b7ec4>
    11dc:	726f6e39 	rsbvc	r6, pc, #912	; 0x390
    11e0:	696c616d 	stmdbvs	ip!, {r0, r2, r3, r5, r6, r8, sp, lr}^
    11e4:	6650657a 			; <UNDEFINED> instruction: 0x6650657a
    11e8:	67696400 	strbvs	r6, [r9, -r0, lsl #8]!
    11ec:	61007469 	tstvs	r0, r9, ror #8
    11f0:	00666f74 	rsbeq	r6, r6, r4, ror pc
    11f4:	646d656d 	strbtvs	r6, [sp], #-1389	; 0xfffffa93
    11f8:	43007473 	movwmi	r7, #1139	; 0x473
    11fc:	43726168 	cmnmi	r2, #104, 2
    1200:	41766e6f 	cmnmi	r6, pc, ror #28
    1204:	66007272 			; <UNDEFINED> instruction: 0x66007272
    1208:	00616f74 	rsbeq	r6, r1, r4, ror pc
    120c:	736d656d 	cmnvc	sp, #457179136	; 0x1b400000
    1210:	62006372 	andvs	r6, r0, #-939524095	; 0xc8000001
    1214:	6f72657a 	svcvs	0x0072657a
    1218:	73616200 	cmnvc	r1, #0, 4
    121c:	74730065 	ldrbtvc	r0, [r3], #-101	; 0xffffff9b
    1220:	6d636e72 	stclvs	14, cr6, [r3, #-456]!	; 0xfffffe38
    1224:	69770070 	ldmdbvs	r7!, {r4, r5, r6}^
    1228:	00687464 	rsbeq	r7, r8, r4, ror #8
    122c:	636d656d 	cmnvs	sp, #457179136	; 0x1b400000
    1230:	5f007970 	svcpl	0x00007970
    1234:	7473365a 	ldrbtvc	r3, [r3], #-1626	; 0xfffff9a6
    1238:	6e656c72 	mcrvs	12, 3, r6, cr5, cr2, {3}
    123c:	00634b50 	rsbeq	r4, r3, r0, asr fp
    1240:	73375a5f 	teqvc	r7, #389120	; 0x5f000
    1244:	636e7274 	cmnvs	lr, #116, 4	; 0x40000007
    1248:	4b50706d 	blmi	141d404 <__bss_end+0x1413f5c>
    124c:	5f305363 	svcpl	0x00305363
    1250:	5a5f0069 	bpl	17c13fc <__bss_end+0x17b7f54>
    1254:	6f746134 	svcvs	0x00746134
    1258:	634b5069 	movtvs	r5, #45161	; 0xb069
    125c:	74756f00 	ldrbtvc	r6, [r5], #-3840	; 0xfffff100
    1260:	00747570 	rsbseq	r7, r4, r0, ror r5
    1264:	6f6d656d 	svcvs	0x006d656d
    1268:	6c007972 			; <UNDEFINED> instruction: 0x6c007972
    126c:	74676e65 	strbtvc	r6, [r7], #-3685	; 0xfffff19b
    1270:	6c700068 	ldclvs	0, cr0, [r0], #-416	; 0xfffffe60
    1274:	73656361 	cmnvc	r5, #-2080374783	; 0x84000001
    1278:	2f2e2e00 	svccs	0x002e2e00
    127c:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    1280:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    1284:	2f2e2e2f 	svccs	0x002e2e2f
    1288:	6c2f2e2e 	stcvs	14, cr2, [pc], #-184	; 11d8 <shift+0x11d8>
    128c:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    1290:	6f632f63 	svcvs	0x00632f63
    1294:	6769666e 	strbvs	r6, [r9, -lr, ror #12]!
    1298:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    129c:	62696c2f 	rsbvs	r6, r9, #12032	; 0x2f00
    12a0:	6e756631 	mrcvs	6, 3, r6, cr5, cr1, {1}
    12a4:	532e7363 			; <UNDEFINED> instruction: 0x532e7363
    12a8:	75622f00 	strbvc	r2, [r2, #-3840]!	; 0xfffff100
    12ac:	2f646c69 	svccs	0x00646c69
    12b0:	2d636367 	stclcs	3, cr6, [r3, #-412]!	; 0xfffffe64
    12b4:	2d6d7261 	sfmcs	f7, 2, [sp, #-388]!	; 0xfffffe7c
    12b8:	656e6f6e 	strbvs	r6, [lr, #-3950]!	; 0xfffff092
    12bc:	6261652d 	rsbvs	r6, r1, #188743680	; 0xb400000
    12c0:	6c472d69 	mcrrvs	13, 6, r2, r7, cr9
    12c4:	39546b39 	ldmdbcc	r4, {r0, r3, r4, r5, r8, r9, fp, sp, lr}^
    12c8:	6363672f 	cmnvs	r3, #12320768	; 0xbc0000
    12cc:	6d72612d 	ldfvse	f6, [r2, #-180]!	; 0xffffff4c
    12d0:	6e6f6e2d 	cdpvs	14, 6, cr6, cr15, cr13, {1}
    12d4:	61652d65 	cmnvs	r5, r5, ror #26
    12d8:	392d6962 	pushcc	{r1, r5, r6, r8, fp, sp, lr}
    12dc:	3130322d 	teqcc	r0, sp, lsr #4
    12e0:	34712d39 	ldrbtcc	r2, [r1], #-3385	; 0xfffff2c7
    12e4:	6975622f 	ldmdbvs	r5!, {r0, r1, r2, r3, r5, r9, sp, lr}^
    12e8:	612f646c 			; <UNDEFINED> instruction: 0x612f646c
    12ec:	6e2d6d72 	mcrvs	13, 1, r6, cr13, cr2, {3}
    12f0:	2d656e6f 	stclcs	14, cr6, [r5, #-444]!	; 0xfffffe44
    12f4:	69626165 	stmdbvs	r2!, {r0, r2, r5, r6, r8, sp, lr}^
    12f8:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    12fc:	7435762f 	ldrtvc	r7, [r5], #-1583	; 0xfffff9d1
    1300:	61682f65 	cmnvs	r8, r5, ror #30
    1304:	6c2f6472 	cfstrsvs	mvf6, [pc], #-456	; 1144 <shift+0x1144>
    1308:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    130c:	41540063 	cmpmi	r4, r3, rrx
    1310:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1314:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1318:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    131c:	61786574 	cmnvs	r8, r4, ror r5
    1320:	6f633731 	svcvs	0x00633731
    1324:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1328:	69003761 	stmdbvs	r0, {r0, r5, r6, r8, r9, sl, ip, sp}
    132c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1330:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1334:	62645f70 	rsbvs	r5, r4, #112, 30	; 0x1c0
    1338:	7261006c 	rsbvc	r0, r1, #108	; 0x6c
    133c:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1340:	695f6863 	ldmdbvs	pc, {r0, r1, r5, r6, fp, sp, lr}^	; <UNPREDICTABLE>
    1344:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    1348:	41540074 	cmpmi	r4, r4, ror r0
    134c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1350:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1354:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1358:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    135c:	41003332 	tstmi	r0, r2, lsr r3
    1360:	455f4d52 	ldrbmi	r4, [pc, #-3410]	; 616 <shift+0x616>
    1364:	41540051 	cmpmi	r4, r1, asr r0
    1368:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    136c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1370:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1374:	36353131 			; <UNDEFINED> instruction: 0x36353131
    1378:	73663274 	cmnvc	r6, #116, 4	; 0x40000007
    137c:	61736900 	cmnvs	r3, r0, lsl #18
    1380:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1384:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    1388:	5400626d 	strpl	r6, [r0], #-621	; 0xfffffd93
    138c:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1390:	50435f54 	subpl	r5, r3, r4, asr pc
    1394:	6f635f55 	svcvs	0x00635f55
    1398:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    139c:	63373561 	teqvs	r7, #406847488	; 0x18400000
    13a0:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    13a4:	33356178 	teqcc	r5, #120, 2
    13a8:	53414200 	movtpl	r4, #4608	; 0x1200
    13ac:	52415f45 	subpl	r5, r1, #276	; 0x114
    13b0:	385f4843 	ldmdacc	pc, {r0, r1, r6, fp, lr}^	; <UNPREDICTABLE>
    13b4:	41425f4d 	cmpmi	r2, sp, asr #30
    13b8:	54004553 	strpl	r4, [r0], #-1363	; 0xfffffaad
    13bc:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    13c0:	50435f54 	subpl	r5, r3, r4, asr pc
    13c4:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    13c8:	3031386d 	eorscc	r3, r1, sp, ror #16
    13cc:	52415400 	subpl	r5, r1, #0, 8
    13d0:	5f544547 	svcpl	0x00544547
    13d4:	5f555043 	svcpl	0x00555043
    13d8:	6e656778 	mcrvs	7, 3, r6, cr5, cr8, {3}
    13dc:	41003165 	tstmi	r0, r5, ror #2
    13e0:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    13e4:	415f5343 	cmpmi	pc, r3, asr #6
    13e8:	53435041 	movtpl	r5, #12353	; 0x3041
    13ec:	4d57495f 	vldrmi.16	s9, [r7, #-190]	; 0xffffff42	; <UNPREDICTABLE>
    13f0:	0054584d 	subseq	r5, r4, sp, asr #16
    13f4:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    13f8:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    13fc:	00305f48 	eorseq	r5, r0, r8, asr #30
    1400:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1404:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1408:	00325f48 	eorseq	r5, r2, r8, asr #30
    140c:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1410:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1414:	00335f48 	eorseq	r5, r3, r8, asr #30
    1418:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    141c:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1420:	00345f48 	eorseq	r5, r4, r8, asr #30
    1424:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1428:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    142c:	00365f48 	eorseq	r5, r6, r8, asr #30
    1430:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1434:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1438:	00375f48 	eorseq	r5, r7, r8, asr #30
    143c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1440:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1444:	785f5550 	ldmdavc	pc, {r4, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
    1448:	6c616373 	stclvs	3, cr6, [r1], #-460	; 0xfffffe34
    144c:	73690065 	cmnvc	r9, #101	; 0x65
    1450:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1454:	72705f74 	rsbsvc	r5, r0, #116, 30	; 0x1d0
    1458:	65726465 	ldrbvs	r6, [r2, #-1125]!	; 0xfffffb9b
    145c:	41540073 	cmpmi	r4, r3, ror r0
    1460:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1464:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1468:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    146c:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1470:	54003333 	strpl	r3, [r0], #-819	; 0xfffffccd
    1474:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1478:	50435f54 	subpl	r5, r3, r4, asr pc
    147c:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    1480:	6474376d 	ldrbtvs	r3, [r4], #-1901	; 0xfffff893
    1484:	6900696d 	stmdbvs	r0, {r0, r2, r3, r5, r6, r8, fp, sp, lr}
    1488:	6e5f6173 	mrcvs	1, 2, r6, cr15, cr3, {3}
    148c:	7469626f 	strbtvc	r6, [r9], #-623	; 0xfffffd91
    1490:	52415400 	subpl	r5, r1, #0, 8
    1494:	5f544547 	svcpl	0x00544547
    1498:	5f555043 	svcpl	0x00555043
    149c:	316d7261 	cmncc	sp, r1, ror #4
    14a0:	6a363731 	bvs	d8f16c <__bss_end+0xd85cc4>
    14a4:	0073667a 	rsbseq	r6, r3, sl, ror r6
    14a8:	5f617369 	svcpl	0x00617369
    14ac:	5f746962 	svcpl	0x00746962
    14b0:	76706676 			; <UNDEFINED> instruction: 0x76706676
    14b4:	52410032 	subpl	r0, r1, #50	; 0x32
    14b8:	43505f4d 	cmpmi	r0, #308	; 0x134
    14bc:	4e555f53 	mrcmi	15, 2, r5, cr5, cr3, {2}
    14c0:	574f4e4b 	strbpl	r4, [pc, -fp, asr #28]
    14c4:	4154004e 	cmpmi	r4, lr, asr #32
    14c8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    14cc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    14d0:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    14d4:	42006539 	andmi	r6, r0, #239075328	; 0xe400000
    14d8:	5f455341 	svcpl	0x00455341
    14dc:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    14e0:	4554355f 	ldrbmi	r3, [r4, #-1375]	; 0xfffffaa1
    14e4:	7261004a 	rsbvc	r0, r1, #74	; 0x4a
    14e8:	63635f6d 	cmnvs	r3, #436	; 0x1b4
    14ec:	5f6d7366 	svcpl	0x006d7366
    14f0:	74617473 	strbtvc	r7, [r1], #-1139	; 0xfffffb8d
    14f4:	72610065 	rsbvc	r0, r1, #101	; 0x65
    14f8:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    14fc:	74356863 	ldrtvc	r6, [r5], #-2147	; 0xfffff79d
    1500:	6e750065 	cdpvs	0, 7, cr0, cr5, cr5, {3}
    1504:	63657073 	cmnvs	r5, #115	; 0x73
    1508:	7274735f 	rsbsvc	r7, r4, #2080374785	; 0x7c000001
    150c:	73676e69 	cmnvc	r7, #1680	; 0x690
    1510:	61736900 	cmnvs	r3, r0, lsl #18
    1514:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1518:	6365735f 	cmnvs	r5, #2080374785	; 0x7c000001
    151c:	635f5f00 	cmpvs	pc, #0, 30
    1520:	745f7a6c 	ldrbvc	r7, [pc], #-2668	; 1528 <shift+0x1528>
    1524:	41006261 	tstmi	r0, r1, ror #4
    1528:	565f4d52 			; <UNDEFINED> instruction: 0x565f4d52
    152c:	72610043 	rsbvc	r0, r1, #67	; 0x43
    1530:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1534:	785f6863 	ldmdavc	pc, {r0, r1, r5, r6, fp, sp, lr}^	; <UNPREDICTABLE>
    1538:	6c616373 	stclvs	3, cr6, [r1], #-460	; 0xfffffe34
    153c:	52410065 	subpl	r0, r1, #101	; 0x65
    1540:	454c5f4d 	strbmi	r5, [ip, #-3917]	; 0xfffff0b3
    1544:	4d524100 	ldfmie	f4, [r2, #-0]
    1548:	0053565f 	subseq	r5, r3, pc, asr r6
    154c:	5f4d5241 	svcpl	0x004d5241
    1550:	61004547 	tstvs	r0, r7, asr #10
    1554:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 155c <shift+0x155c>
    1558:	5f656e75 	svcpl	0x00656e75
    155c:	6f727473 	svcvs	0x00727473
    1560:	7261676e 	rsbvc	r6, r1, #28835840	; 0x1b80000
    1564:	6f63006d 	svcvs	0x0063006d
    1568:	656c706d 	strbvs	r7, [ip, #-109]!	; 0xffffff93
    156c:	6c662078 	stclvs	0, cr2, [r6], #-480	; 0xfffffe20
    1570:	0074616f 	rsbseq	r6, r4, pc, ror #2
    1574:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1578:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    157c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1580:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1584:	35316178 	ldrcc	r6, [r1, #-376]!	; 0xfffffe88
    1588:	52415400 	subpl	r5, r1, #0, 8
    158c:	5f544547 	svcpl	0x00544547
    1590:	5f555043 	svcpl	0x00555043
    1594:	32376166 	eorscc	r6, r7, #-2147483623	; 0x80000019
    1598:	00657436 	rsbeq	r7, r5, r6, lsr r4
    159c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    15a0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    15a4:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    15a8:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    15ac:	37316178 			; <UNDEFINED> instruction: 0x37316178
    15b0:	4d524100 	ldfmie	f4, [r2, #-0]
    15b4:	0054475f 	subseq	r4, r4, pc, asr r7
    15b8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    15bc:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    15c0:	6e5f5550 	mrcvs	5, 2, r5, cr15, cr0, {2}
    15c4:	65766f65 	ldrbvs	r6, [r6, #-3941]!	; 0xfffff09b
    15c8:	6e657372 	mcrvs	3, 3, r7, cr5, cr2, {3}
    15cc:	2e2e0031 	mcrcs	0, 1, r0, cr14, cr1, {1}
    15d0:	2f2e2e2f 	svccs	0x002e2e2f
    15d4:	2e2f2e2e 	cdpcs	14, 2, cr2, cr15, cr14, {1}
    15d8:	2e2e2f2e 	cdpcs	15, 2, cr2, cr14, cr14, {1}
    15dc:	2f2e2e2f 	svccs	0x002e2e2f
    15e0:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    15e4:	6c2f6363 	stcvs	3, cr6, [pc], #-396	; 1460 <shift+0x1460>
    15e8:	63676269 	cmnvs	r7, #-1879048186	; 0x90000006
    15ec:	632e3263 			; <UNDEFINED> instruction: 0x632e3263
    15f0:	52415400 	subpl	r5, r1, #0, 8
    15f4:	5f544547 	svcpl	0x00544547
    15f8:	5f555043 	svcpl	0x00555043
    15fc:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1600:	34727865 	ldrbtcc	r7, [r2], #-2149	; 0xfffff79b
    1604:	41420066 	cmpmi	r2, r6, rrx
    1608:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    160c:	5f484352 	svcpl	0x00484352
    1610:	004d4537 	subeq	r4, sp, r7, lsr r5
    1614:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1618:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    161c:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1620:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1624:	32316178 	eorscc	r6, r1, #120, 2
    1628:	73616800 	cmnvc	r1, #0, 16
    162c:	6c617668 	stclvs	6, cr7, [r1], #-416	; 0xfffffe60
    1630:	4200745f 	andmi	r7, r0, #1593835520	; 0x5f000000
    1634:	5f455341 	svcpl	0x00455341
    1638:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    163c:	5a4b365f 	bpl	12cefc0 <__bss_end+0x12c5b18>
    1640:	61736900 	cmnvs	r3, r0, lsl #18
    1644:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1648:	72610073 	rsbvc	r0, r1, #115	; 0x73
    164c:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1650:	615f6863 	cmpvs	pc, r3, ror #16
    1654:	685f6d72 	ldmdavs	pc, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^	; <UNPREDICTABLE>
    1658:	76696477 			; <UNDEFINED> instruction: 0x76696477
    165c:	6d726100 	ldfvse	f6, [r2, #-0]
    1660:	7570665f 	ldrbvc	r6, [r0, #-1631]!	; 0xfffff9a1
    1664:	7365645f 	cmnvc	r5, #1593835520	; 0x5f000000
    1668:	73690063 	cmnvc	r9, #99	; 0x63
    166c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1670:	70665f74 	rsbvc	r5, r6, r4, ror pc
    1674:	47003631 	smladxmi	r0, r1, r6, r3
    1678:	4320554e 			; <UNDEFINED> instruction: 0x4320554e
    167c:	39203731 	stmdbcc	r0!, {r0, r4, r5, r8, r9, sl, ip, sp}
    1680:	312e322e 			; <UNDEFINED> instruction: 0x312e322e
    1684:	31303220 	teqcc	r0, r0, lsr #4
    1688:	32303139 	eorscc	r3, r0, #1073741838	; 0x4000000e
    168c:	72282035 	eorvc	r2, r8, #53	; 0x35
    1690:	61656c65 	cmnvs	r5, r5, ror #24
    1694:	20296573 	eorcs	r6, r9, r3, ror r5
    1698:	4d52415b 	ldfmie	f4, [r2, #-364]	; 0xfffffe94
    169c:	6d72612f 	ldfvse	f6, [r2, #-188]!	; 0xffffff44
    16a0:	622d392d 	eorvs	r3, sp, #737280	; 0xb4000
    16a4:	636e6172 	cmnvs	lr, #-2147483620	; 0x8000001c
    16a8:	65722068 	ldrbvs	r2, [r2, #-104]!	; 0xffffff98
    16ac:	69736976 	ldmdbvs	r3!, {r1, r2, r4, r5, r6, r8, fp, sp, lr}^
    16b0:	32206e6f 	eorcc	r6, r0, #1776	; 0x6f0
    16b4:	39353737 	ldmdbcc	r5!, {r0, r1, r2, r4, r5, r8, r9, sl, ip, sp}
    16b8:	2d205d39 	stccs	13, cr5, [r0, #-228]!	; 0xffffff1c
    16bc:	6d72616d 	ldfvse	f6, [r2, #-436]!	; 0xfffffe4c
    16c0:	666d2d20 	strbtvs	r2, [sp], -r0, lsr #26
    16c4:	74616f6c 	strbtvc	r6, [r1], #-3948	; 0xfffff094
    16c8:	6962612d 	stmdbvs	r2!, {r0, r2, r3, r5, r8, sp, lr}^
    16cc:	7261683d 	rsbvc	r6, r1, #3997696	; 0x3d0000
    16d0:	6d2d2064 	stcvs	0, cr2, [sp, #-400]!	; 0xfffffe70
    16d4:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    16d8:	6d72613d 	ldfvse	f6, [r2, #-244]!	; 0xffffff0c
    16dc:	65743576 	ldrbvs	r3, [r4, #-1398]!	; 0xfffffa8a
    16e0:	2070662b 	rsbscs	r6, r0, fp, lsr #12
    16e4:	2d20672d 	stccs	7, cr6, [r0, #-180]!	; 0xffffff4c
    16e8:	672d2067 	strvs	r2, [sp, -r7, rrx]!
    16ec:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    16f0:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    16f4:	324f2d20 	subcc	r2, pc, #32, 26	; 0x800
    16f8:	62662d20 	rsbvs	r2, r6, #32, 26	; 0x800
    16fc:	646c6975 	strbtvs	r6, [ip], #-2421	; 0xfffff68b
    1700:	2d676e69 	stclcs	14, cr6, [r7, #-420]!	; 0xfffffe5c
    1704:	6762696c 	strbvs	r6, [r2, -ip, ror #18]!
    1708:	2d206363 	stccs	3, cr6, [r0, #-396]!	; 0xfffffe74
    170c:	2d6f6e66 	stclcs	14, cr6, [pc, #-408]!	; 157c <shift+0x157c>
    1710:	63617473 	cmnvs	r1, #1929379840	; 0x73000000
    1714:	72702d6b 	rsbsvc	r2, r0, #6848	; 0x1ac0
    1718:	6365746f 	cmnvs	r5, #1862270976	; 0x6f000000
    171c:	20726f74 	rsbscs	r6, r2, r4, ror pc
    1720:	6f6e662d 	svcvs	0x006e662d
    1724:	6c6e692d 			; <UNDEFINED> instruction: 0x6c6e692d
    1728:	20656e69 	rsbcs	r6, r5, r9, ror #28
    172c:	6976662d 	ldmdbvs	r6!, {r0, r2, r3, r5, r9, sl, sp, lr}^
    1730:	69626973 	stmdbvs	r2!, {r0, r1, r4, r5, r6, r8, fp, sp, lr}^
    1734:	7974696c 	ldmdbvc	r4!, {r2, r3, r5, r6, r8, fp, sp, lr}^
    1738:	6469683d 	strbtvs	r6, [r9], #-2109	; 0xfffff7c3
    173c:	006e6564 	rsbeq	r6, lr, r4, ror #10
    1740:	5f4d5241 	svcpl	0x004d5241
    1744:	69004948 	stmdbvs	r0, {r3, r6, r8, fp, lr}
    1748:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    174c:	615f7469 	cmpvs	pc, r9, ror #8
    1750:	00766964 	rsbseq	r6, r6, r4, ror #18
    1754:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1758:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    175c:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1760:	31316d72 	teqcc	r1, r2, ror sp
    1764:	736a3633 	cmnvc	sl, #53477376	; 0x3300000
    1768:	52415400 	subpl	r5, r1, #0, 8
    176c:	5f544547 	svcpl	0x00544547
    1770:	5f555043 	svcpl	0x00555043
    1774:	386d7261 	stmdacc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    1778:	52415400 	subpl	r5, r1, #0, 8
    177c:	5f544547 	svcpl	0x00544547
    1780:	5f555043 	svcpl	0x00555043
    1784:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    1788:	52415400 	subpl	r5, r1, #0, 8
    178c:	5f544547 	svcpl	0x00544547
    1790:	5f555043 	svcpl	0x00555043
    1794:	32366166 	eorscc	r6, r6, #-2147483623	; 0x80000019
    1798:	6f6c0036 	svcvs	0x006c0036
    179c:	6c20676e 	stcvs	7, cr6, [r0], #-440	; 0xfffffe48
    17a0:	20676e6f 	rsbcs	r6, r7, pc, ror #28
    17a4:	69736e75 	ldmdbvs	r3!, {r0, r2, r4, r5, r6, r9, sl, fp, sp, lr}^
    17a8:	64656e67 	strbtvs	r6, [r5], #-3687	; 0xfffff199
    17ac:	746e6920 	strbtvc	r6, [lr], #-2336	; 0xfffff6e0
    17b0:	6d726100 	ldfvse	f6, [r2, #-0]
    17b4:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    17b8:	6d635f68 	stclvs	15, cr5, [r3, #-416]!	; 0xfffffe60
    17bc:	54006573 	strpl	r6, [r0], #-1395	; 0xfffffa8d
    17c0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    17c4:	50435f54 	subpl	r5, r3, r4, asr pc
    17c8:	6f635f55 	svcvs	0x00635f55
    17cc:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    17d0:	5400346d 	strpl	r3, [r0], #-1133	; 0xfffffb93
    17d4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    17d8:	50435f54 	subpl	r5, r3, r4, asr pc
    17dc:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    17e0:	6530316d 	ldrvs	r3, [r0, #-365]!	; 0xfffffe93
    17e4:	52415400 	subpl	r5, r1, #0, 8
    17e8:	5f544547 	svcpl	0x00544547
    17ec:	5f555043 	svcpl	0x00555043
    17f0:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    17f4:	376d7865 	strbcc	r7, [sp, -r5, ror #16]!
    17f8:	6d726100 	ldfvse	f6, [r2, #-0]
    17fc:	6e6f635f 	mcrvs	3, 3, r6, cr15, cr15, {2}
    1800:	6f635f64 	svcvs	0x00635f64
    1804:	41006564 	tstmi	r0, r4, ror #10
    1808:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    180c:	415f5343 	cmpmi	pc, r3, asr #6
    1810:	53435041 	movtpl	r5, #12353	; 0x3041
    1814:	61736900 	cmnvs	r3, r0, lsl #18
    1818:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    181c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1820:	325f3876 	subscc	r3, pc, #7733248	; 0x760000
    1824:	53414200 	movtpl	r4, #4608	; 0x1200
    1828:	52415f45 	subpl	r5, r1, #276	; 0x114
    182c:	335f4843 	cmpcc	pc, #4390912	; 0x430000
    1830:	4154004d 	cmpmi	r4, sp, asr #32
    1834:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1838:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    183c:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1840:	74303137 	ldrtvc	r3, [r0], #-311	; 0xfffffec9
    1844:	6d726100 	ldfvse	f6, [r2, #-0]
    1848:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    184c:	77695f68 	strbvc	r5, [r9, -r8, ror #30]!
    1850:	74786d6d 	ldrbtvc	r6, [r8], #-3437	; 0xfffff293
    1854:	73690032 	cmnvc	r9, #50	; 0x32
    1858:	756e5f61 	strbvc	r5, [lr, #-3937]!	; 0xfffff09f
    185c:	69625f6d 	stmdbvs	r2!, {r0, r2, r3, r5, r6, r8, r9, sl, fp, ip, lr}^
    1860:	54007374 	strpl	r7, [r0], #-884	; 0xfffffc8c
    1864:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1868:	50435f54 	subpl	r5, r3, r4, asr pc
    186c:	6f635f55 	svcvs	0x00635f55
    1870:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1874:	6c70306d 	ldclvs	0, cr3, [r0], #-436	; 0xfffffe4c
    1878:	6d737375 	ldclvs	3, cr7, [r3, #-468]!	; 0xfffffe2c
    187c:	6d6c6c61 	stclvs	12, cr6, [ip, #-388]!	; 0xfffffe7c
    1880:	69746c75 	ldmdbvs	r4!, {r0, r2, r4, r5, r6, sl, fp, sp, lr}^
    1884:	00796c70 	rsbseq	r6, r9, r0, ror ip
    1888:	47524154 			; <UNDEFINED> instruction: 0x47524154
    188c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1890:	655f5550 	ldrbvs	r5, [pc, #-1360]	; 1348 <shift+0x1348>
    1894:	6f6e7978 	svcvs	0x006e7978
    1898:	00316d73 	eorseq	r6, r1, r3, ror sp
    189c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    18a0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    18a4:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    18a8:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    18ac:	32357278 	eorscc	r7, r5, #120, 4	; 0x80000007
    18b0:	61736900 	cmnvs	r3, r0, lsl #18
    18b4:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    18b8:	6964745f 	stmdbvs	r4!, {r0, r1, r2, r3, r4, r6, sl, ip, sp, lr}^
    18bc:	72700076 	rsbsvc	r0, r0, #118	; 0x76
    18c0:	72656665 	rsbvc	r6, r5, #105906176	; 0x6500000
    18c4:	6f656e5f 	svcvs	0x00656e5f
    18c8:	6f665f6e 	svcvs	0x00665f6e
    18cc:	34365f72 	ldrtcc	r5, [r6], #-3954	; 0xfffff08e
    18d0:	73746962 	cmnvc	r4, #1605632	; 0x188000
    18d4:	61736900 	cmnvs	r3, r0, lsl #18
    18d8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    18dc:	3170665f 	cmncc	r0, pc, asr r6
    18e0:	6c6d6636 	stclvs	6, cr6, [sp], #-216	; 0xffffff28
    18e4:	52415400 	subpl	r5, r1, #0, 8
    18e8:	5f544547 	svcpl	0x00544547
    18ec:	5f555043 	svcpl	0x00555043
    18f0:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    18f4:	33617865 	cmncc	r1, #6619136	; 0x650000
    18f8:	41540032 	cmpmi	r4, r2, lsr r0
    18fc:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1900:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1904:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1908:	61786574 	cmnvs	r8, r4, ror r5
    190c:	69003533 	stmdbvs	r0, {r0, r1, r4, r5, r8, sl, ip, sp}
    1910:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1914:	665f7469 	ldrbvs	r7, [pc], -r9, ror #8
    1918:	63363170 	teqvs	r6, #112, 2
    191c:	00766e6f 	rsbseq	r6, r6, pc, ror #28
    1920:	70736e75 	rsbsvc	r6, r3, r5, ror lr
    1924:	5f766365 	svcpl	0x00766365
    1928:	69727473 	ldmdbvs	r2!, {r0, r1, r4, r5, r6, sl, ip, sp, lr}^
    192c:	0073676e 	rsbseq	r6, r3, lr, ror #14
    1930:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1934:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1938:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    193c:	31316d72 	teqcc	r1, r2, ror sp
    1940:	32743635 	rsbscc	r3, r4, #55574528	; 0x3500000
    1944:	41540073 	cmpmi	r4, r3, ror r0
    1948:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    194c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1950:	3661665f 			; <UNDEFINED> instruction: 0x3661665f
    1954:	65743630 	ldrbvs	r3, [r4, #-1584]!	; 0xfffff9d0
    1958:	52415400 	subpl	r5, r1, #0, 8
    195c:	5f544547 	svcpl	0x00544547
    1960:	5f555043 	svcpl	0x00555043
    1964:	396d7261 	stmdbcc	sp!, {r0, r5, r6, r9, ip, sp, lr}^
    1968:	6a653632 	bvs	194f238 <__bss_end+0x1945d90>
    196c:	41420073 	hvcmi	8195	; 0x2003
    1970:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1974:	5f484352 	svcpl	0x00484352
    1978:	69005434 	stmdbvs	r0, {r2, r4, r5, sl, ip, lr}
    197c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1980:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    1984:	74707972 	ldrbtvc	r7, [r0], #-2418	; 0xfffff68e
    1988:	7261006f 	rsbvc	r0, r1, #111	; 0x6f
    198c:	65725f6d 	ldrbvs	r5, [r2, #-3949]!	; 0xfffff093
    1990:	695f7367 	ldmdbvs	pc, {r0, r1, r2, r5, r6, r8, r9, ip, sp, lr}^	; <UNPREDICTABLE>
    1994:	65735f6e 	ldrbvs	r5, [r3, #-3950]!	; 0xfffff092
    1998:	6e657571 	mcrvs	5, 3, r7, cr5, cr1, {3}
    199c:	69006563 	stmdbvs	r0, {r0, r1, r5, r6, r8, sl, sp, lr}
    19a0:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    19a4:	735f7469 	cmpvc	pc, #1761607680	; 0x69000000
    19a8:	41420062 	cmpmi	r2, r2, rrx
    19ac:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    19b0:	5f484352 	svcpl	0x00484352
    19b4:	00455435 	subeq	r5, r5, r5, lsr r4
    19b8:	5f617369 	svcpl	0x00617369
    19bc:	74616566 	strbtvc	r6, [r1], #-1382	; 0xfffffa9a
    19c0:	00657275 	rsbeq	r7, r5, r5, ror r2
    19c4:	5f617369 	svcpl	0x00617369
    19c8:	5f746962 	svcpl	0x00746962
    19cc:	6c616d73 	stclvs	13, cr6, [r1], #-460	; 0xfffffe34
    19d0:	6c756d6c 	ldclvs	13, cr6, [r5], #-432	; 0xfffffe50
    19d4:	6d726100 	ldfvse	f6, [r2, #-0]
    19d8:	6e616c5f 	mcrvs	12, 3, r6, cr1, cr15, {2}
    19dc:	756f5f67 	strbvc	r5, [pc, #-3943]!	; a7d <shift+0xa7d>
    19e0:	74757074 	ldrbtvc	r7, [r5], #-116	; 0xffffff8c
    19e4:	6a626f5f 	bvs	189d768 <__bss_end+0x18942c0>
    19e8:	5f746365 	svcpl	0x00746365
    19ec:	72747461 	rsbsvc	r7, r4, #1627389952	; 0x61000000
    19f0:	74756269 	ldrbtvc	r6, [r5], #-617	; 0xfffffd97
    19f4:	685f7365 	ldmdavs	pc, {r0, r2, r5, r6, r8, r9, ip, sp, lr}^	; <UNPREDICTABLE>
    19f8:	006b6f6f 	rsbeq	r6, fp, pc, ror #30
    19fc:	5f617369 	svcpl	0x00617369
    1a00:	5f746962 	svcpl	0x00746962
    1a04:	645f7066 	ldrbvs	r7, [pc], #-102	; 1a0c <shift+0x1a0c>
    1a08:	41003233 	tstmi	r0, r3, lsr r2
    1a0c:	4e5f4d52 	mrcmi	13, 2, r4, cr15, cr2, {2}
    1a10:	73690045 	cmnvc	r9, #69	; 0x45
    1a14:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1a18:	65625f74 	strbvs	r5, [r2, #-3956]!	; 0xfffff08c
    1a1c:	41540038 	cmpmi	r4, r8, lsr r0
    1a20:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1a24:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1a28:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1a2c:	36373131 			; <UNDEFINED> instruction: 0x36373131
    1a30:	00737a6a 	rsbseq	r7, r3, sl, ror #20
    1a34:	636f7270 	cmnvs	pc, #112, 4
    1a38:	6f737365 	svcvs	0x00737365
    1a3c:	79745f72 	ldmdbvc	r4!, {r1, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1a40:	61006570 	tstvs	r0, r0, ror r5
    1a44:	665f6c6c 	ldrbvs	r6, [pc], -ip, ror #24
    1a48:	00737570 	rsbseq	r7, r3, r0, ror r5
    1a4c:	5f6d7261 	svcpl	0x006d7261
    1a50:	00736370 	rsbseq	r6, r3, r0, ror r3
    1a54:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1a58:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1a5c:	54355f48 	ldrtpl	r5, [r5], #-3912	; 0xfffff0b8
    1a60:	6d726100 	ldfvse	f6, [r2, #-0]
    1a64:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1a68:	00743468 	rsbseq	r3, r4, r8, ror #8
    1a6c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1a70:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1a74:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1a78:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1a7c:	36376178 			; <UNDEFINED> instruction: 0x36376178
    1a80:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1a84:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    1a88:	72610035 	rsbvc	r0, r1, #53	; 0x35
    1a8c:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    1a90:	775f656e 	ldrbvc	r6, [pc, -lr, ror #10]
    1a94:	00667562 	rsbeq	r7, r6, r2, ror #10
    1a98:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
    1a9c:	7361685f 	cmnvc	r1, #6225920	; 0x5f0000
    1aa0:	73690068 	cmnvc	r9, #104	; 0x68
    1aa4:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1aa8:	75715f74 	ldrbvc	r5, [r1, #-3956]!	; 0xfffff08c
    1aac:	5f6b7269 	svcpl	0x006b7269
    1ab0:	765f6f6e 	ldrbvc	r6, [pc], -lr, ror #30
    1ab4:	74616c6f 	strbtvc	r6, [r1], #-3183	; 0xfffff391
    1ab8:	5f656c69 	svcpl	0x00656c69
    1abc:	54006563 	strpl	r6, [r0], #-1379	; 0xfffffa9d
    1ac0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1ac4:	50435f54 	subpl	r5, r3, r4, asr pc
    1ac8:	6f635f55 	svcvs	0x00635f55
    1acc:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1ad0:	5400306d 	strpl	r3, [r0], #-109	; 0xffffff93
    1ad4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1ad8:	50435f54 	subpl	r5, r3, r4, asr pc
    1adc:	6f635f55 	svcvs	0x00635f55
    1ae0:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1ae4:	5400316d 	strpl	r3, [r0], #-365	; 0xfffffe93
    1ae8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1aec:	50435f54 	subpl	r5, r3, r4, asr pc
    1af0:	6f635f55 	svcvs	0x00635f55
    1af4:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1af8:	6900336d 	stmdbvs	r0, {r0, r2, r3, r5, r6, r8, r9, ip, sp}
    1afc:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1b00:	615f7469 	cmpvs	pc, r9, ror #8
    1b04:	38766d72 	ldmdacc	r6!, {r1, r4, r5, r6, r8, sl, fp, sp, lr}^
    1b08:	6100315f 	tstvs	r0, pc, asr r1
    1b0c:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    1b10:	5f686372 	svcpl	0x00686372
    1b14:	656d616e 	strbvs	r6, [sp, #-366]!	; 0xfffffe92
    1b18:	61736900 	cmnvs	r3, r0, lsl #18
    1b1c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1b20:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1b24:	335f3876 	cmpcc	pc, #7733248	; 0x760000
    1b28:	61736900 	cmnvs	r3, r0, lsl #18
    1b2c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1b30:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1b34:	345f3876 	ldrbcc	r3, [pc], #-2166	; 1b3c <shift+0x1b3c>
    1b38:	61736900 	cmnvs	r3, r0, lsl #18
    1b3c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1b40:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1b44:	355f3876 	ldrbcc	r3, [pc, #-2166]	; 12d6 <shift+0x12d6>
    1b48:	52415400 	subpl	r5, r1, #0, 8
    1b4c:	5f544547 	svcpl	0x00544547
    1b50:	5f555043 	svcpl	0x00555043
    1b54:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1b58:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    1b5c:	41540033 	cmpmi	r4, r3, lsr r0
    1b60:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1b64:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1b68:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1b6c:	61786574 	cmnvs	r8, r4, ror r5
    1b70:	54003535 	strpl	r3, [r0], #-1333	; 0xfffffacb
    1b74:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1b78:	50435f54 	subpl	r5, r3, r4, asr pc
    1b7c:	6f635f55 	svcvs	0x00635f55
    1b80:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1b84:	00373561 	eorseq	r3, r7, r1, ror #10
    1b88:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1b8c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1b90:	6d5f5550 	cfldr64vs	mvdx5, [pc, #-320]	; 1a58 <shift+0x1a58>
    1b94:	726f6370 	rsbvc	r6, pc, #112, 6	; 0xc0000001
    1b98:	41540065 	cmpmi	r4, r5, rrx
    1b9c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1ba0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1ba4:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1ba8:	6e6f6e5f 	mcrvs	14, 3, r6, cr15, cr15, {2}
    1bac:	72610065 	rsbvc	r0, r1, #101	; 0x65
    1bb0:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1bb4:	6e5f6863 	cdpvs	8, 5, cr6, cr15, cr3, {3}
    1bb8:	006d746f 	rsbeq	r7, sp, pc, ror #8
    1bbc:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1bc0:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1bc4:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1bc8:	30316d72 	eorscc	r6, r1, r2, ror sp
    1bcc:	6a653632 	bvs	194f49c <__bss_end+0x1945ff4>
    1bd0:	41420073 	hvcmi	8195	; 0x2003
    1bd4:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1bd8:	5f484352 	svcpl	0x00484352
    1bdc:	42004a36 	andmi	r4, r0, #221184	; 0x36000
    1be0:	5f455341 	svcpl	0x00455341
    1be4:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1be8:	004b365f 	subeq	r3, fp, pc, asr r6
    1bec:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1bf0:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1bf4:	4d365f48 	ldcmi	15, cr5, [r6, #-288]!	; 0xfffffee0
    1bf8:	61736900 	cmnvs	r3, r0, lsl #18
    1bfc:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1c00:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    1c04:	0074786d 	rsbseq	r7, r4, sp, ror #16
    1c08:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1c0c:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1c10:	615f5550 	cmpvs	pc, r0, asr r5	; <UNPREDICTABLE>
    1c14:	31316d72 	teqcc	r1, r2, ror sp
    1c18:	666a3633 			; <UNDEFINED> instruction: 0x666a3633
    1c1c:	52410073 	subpl	r0, r1, #115	; 0x73
    1c20:	534c5f4d 	movtpl	r5, #53069	; 0xcf4d
    1c24:	4d524100 	ldfmie	f4, [r2, #-0]
    1c28:	00544c5f 	subseq	r4, r4, pc, asr ip
    1c2c:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1c30:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1c34:	5a365f48 	bpl	d9995c <__bss_end+0xd904b4>
    1c38:	52415400 	subpl	r5, r1, #0, 8
    1c3c:	5f544547 	svcpl	0x00544547
    1c40:	5f555043 	svcpl	0x00555043
    1c44:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1c48:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    1c4c:	726f6335 	rsbvc	r6, pc, #-738197504	; 0xd4000000
    1c50:	61786574 	cmnvs	r8, r4, ror r5
    1c54:	41003535 	tstmi	r0, r5, lsr r5
    1c58:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    1c5c:	415f5343 	cmpmi	pc, r3, asr #6
    1c60:	53435041 	movtpl	r5, #12353	; 0x3041
    1c64:	5046565f 	subpl	r5, r6, pc, asr r6
    1c68:	52415400 	subpl	r5, r1, #0, 8
    1c6c:	5f544547 	svcpl	0x00544547
    1c70:	5f555043 	svcpl	0x00555043
    1c74:	6d6d7769 	stclvs	7, cr7, [sp, #-420]!	; 0xfffffe5c
    1c78:	00327478 	eorseq	r7, r2, r8, ror r4
    1c7c:	5f617369 	svcpl	0x00617369
    1c80:	5f746962 	svcpl	0x00746962
    1c84:	6e6f656e 	cdpvs	5, 6, cr6, cr15, cr14, {3}
    1c88:	6d726100 	ldfvse	f6, [r2, #-0]
    1c8c:	7570665f 	ldrbvc	r6, [r0, #-1631]!	; 0xfffff9a1
    1c90:	7474615f 	ldrbtvc	r6, [r4], #-351	; 0xfffffea1
    1c94:	73690072 	cmnvc	r9, #114	; 0x72
    1c98:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1c9c:	72615f74 	rsbvc	r5, r1, #116, 30	; 0x1d0
    1ca0:	6537766d 	ldrvs	r7, [r7, #-1645]!	; 0xfffff993
    1ca4:	4154006d 	cmpmi	r4, sp, rrx
    1ca8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1cac:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1cb0:	3661665f 			; <UNDEFINED> instruction: 0x3661665f
    1cb4:	65743632 	ldrbvs	r3, [r4, #-1586]!	; 0xfffff9ce
    1cb8:	52415400 	subpl	r5, r1, #0, 8
    1cbc:	5f544547 	svcpl	0x00544547
    1cc0:	5f555043 	svcpl	0x00555043
    1cc4:	7672616d 	ldrbtvc	r6, [r2], -sp, ror #2
    1cc8:	5f6c6c65 	svcpl	0x006c6c65
    1ccc:	00346a70 	eorseq	r6, r4, r0, ror sl
    1cd0:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
    1cd4:	7361685f 	cmnvc	r1, #6225920	; 0x5f0000
    1cd8:	6f705f68 	svcvs	0x00705f68
    1cdc:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
    1ce0:	72610072 	rsbvc	r0, r1, #114	; 0x72
    1ce4:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    1ce8:	635f656e 	cmpvs	pc, #461373440	; 0x1b800000
    1cec:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1cf0:	39615f78 	stmdbcc	r1!, {r3, r4, r5, r6, r8, r9, sl, fp, ip, lr}^
    1cf4:	61736900 	cmnvs	r3, r0, lsl #18
    1cf8:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1cfc:	6d77695f 			; <UNDEFINED> instruction: 0x6d77695f
    1d00:	3274786d 	rsbscc	r7, r4, #7143424	; 0x6d0000
    1d04:	52415400 	subpl	r5, r1, #0, 8
    1d08:	5f544547 	svcpl	0x00544547
    1d0c:	5f555043 	svcpl	0x00555043
    1d10:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1d14:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    1d18:	726f6332 	rsbvc	r6, pc, #-939524096	; 0xc8000000
    1d1c:	61786574 	cmnvs	r8, r4, ror r5
    1d20:	69003335 	stmdbvs	r0, {r0, r2, r4, r5, r8, r9, ip, sp}
    1d24:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1d28:	745f7469 	ldrbvc	r7, [pc], #-1129	; 1d30 <shift+0x1d30>
    1d2c:	626d7568 	rsbvs	r7, sp, #104, 10	; 0x1a000000
    1d30:	41420032 	cmpmi	r2, r2, lsr r0
    1d34:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    1d38:	5f484352 	svcpl	0x00484352
    1d3c:	69004137 	stmdbvs	r0, {r0, r1, r2, r4, r5, r8, lr}
    1d40:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1d44:	645f7469 	ldrbvs	r7, [pc], #-1129	; 1d4c <shift+0x1d4c>
    1d48:	7270746f 	rsbsvc	r7, r0, #1862270976	; 0x6f000000
    1d4c:	6100646f 	tstvs	r0, pc, ror #8
    1d50:	665f6d72 			; <UNDEFINED> instruction: 0x665f6d72
    1d54:	5f363170 	svcpl	0x00363170
    1d58:	65707974 	ldrbvs	r7, [r0, #-2420]!	; 0xfffff68c
    1d5c:	646f6e5f 	strbtvs	r6, [pc], #-3679	; 1d64 <shift+0x1d64>
    1d60:	52410065 	subpl	r0, r1, #101	; 0x65
    1d64:	494d5f4d 	stmdbmi	sp, {r0, r2, r3, r6, r8, r9, sl, fp, ip, lr}^
    1d68:	6d726100 	ldfvse	f6, [r2, #-0]
    1d6c:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    1d70:	006b3668 	rsbeq	r3, fp, r8, ror #12
    1d74:	5f6d7261 	svcpl	0x006d7261
    1d78:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1d7c:	42006d36 	andmi	r6, r0, #3456	; 0xd80
    1d80:	5f455341 	svcpl	0x00455341
    1d84:	48435241 	stmdami	r3, {r0, r6, r9, ip, lr}^
    1d88:	0052375f 	subseq	r3, r2, pc, asr r7
    1d8c:	6f705f5f 	svcvs	0x00705f5f
    1d90:	756f6370 	strbvc	r6, [pc, #-880]!	; 1a28 <shift+0x1a28>
    1d94:	745f746e 	ldrbvc	r7, [pc], #-1134	; 1d9c <shift+0x1d9c>
    1d98:	69006261 	stmdbvs	r0, {r0, r5, r6, r9, sp, lr}
    1d9c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1da0:	635f7469 	cmpvs	pc, #1761607680	; 0x69000000
    1da4:	0065736d 	rsbeq	r7, r5, sp, ror #6
    1da8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1dac:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1db0:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1db4:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1db8:	33376178 	teqcc	r7, #120, 2
    1dbc:	52415400 	subpl	r5, r1, #0, 8
    1dc0:	5f544547 	svcpl	0x00544547
    1dc4:	5f555043 	svcpl	0x00555043
    1dc8:	656e6567 	strbvs	r6, [lr, #-1383]!	; 0xfffffa99
    1dcc:	76636972 			; <UNDEFINED> instruction: 0x76636972
    1dd0:	54006137 	strpl	r6, [r0], #-311	; 0xfffffec9
    1dd4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    1dd8:	50435f54 	subpl	r5, r3, r4, asr pc
    1ddc:	6f635f55 	svcvs	0x00635f55
    1de0:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    1de4:	00363761 	eorseq	r3, r6, r1, ror #14
    1de8:	5f6d7261 	svcpl	0x006d7261
    1dec:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1df0:	5f6f6e5f 	svcpl	0x006f6e5f
    1df4:	616c6f76 	smcvs	50934	; 0xc6f6
    1df8:	656c6974 	strbvs	r6, [ip, #-2420]!	; 0xfffff68c
    1dfc:	0065635f 	rsbeq	r6, r5, pc, asr r3
    1e00:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1e04:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1e08:	41385f48 	teqmi	r8, r8, asr #30
    1e0c:	61736900 	cmnvs	r3, r0, lsl #18
    1e10:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1e14:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    1e18:	00743576 	rsbseq	r3, r4, r6, ror r5
    1e1c:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    1e20:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    1e24:	52385f48 	eorspl	r5, r8, #72, 30	; 0x120
    1e28:	52415400 	subpl	r5, r1, #0, 8
    1e2c:	5f544547 	svcpl	0x00544547
    1e30:	5f555043 	svcpl	0x00555043
    1e34:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1e38:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    1e3c:	726f6333 	rsbvc	r6, pc, #-872415232	; 0xcc000000
    1e40:	61786574 	cmnvs	r8, r4, ror r5
    1e44:	41003533 	tstmi	r0, r3, lsr r5
    1e48:	4e5f4d52 	mrcmi	13, 2, r4, cr15, cr2, {2}
    1e4c:	72610056 	rsbvc	r0, r1, #86	; 0x56
    1e50:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1e54:	00346863 	eorseq	r6, r4, r3, ror #16
    1e58:	5f6d7261 	svcpl	0x006d7261
    1e5c:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1e60:	72610036 	rsbvc	r0, r1, #54	; 0x36
    1e64:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    1e68:	00376863 	eorseq	r6, r7, r3, ror #16
    1e6c:	5f6d7261 	svcpl	0x006d7261
    1e70:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1e74:	6f6c0038 	svcvs	0x006c0038
    1e78:	6420676e 	strtvs	r6, [r0], #-1902	; 0xfffff892
    1e7c:	6c62756f 	cfstr64vs	mvdx7, [r2], #-444	; 0xfffffe44
    1e80:	72610065 	rsbvc	r0, r1, #101	; 0x65
    1e84:	75745f6d 	ldrbvc	r5, [r4, #-3949]!	; 0xfffff093
    1e88:	785f656e 	ldmdavc	pc, {r1, r2, r3, r5, r6, r8, sl, sp, lr}^	; <UNPREDICTABLE>
    1e8c:	6c616373 	stclvs	3, cr6, [r1], #-460	; 0xfffffe34
    1e90:	616d0065 	cmnvs	sp, r5, rrx
    1e94:	676e696b 	strbvs	r6, [lr, -fp, ror #18]!
    1e98:	6e6f635f 	mcrvs	3, 3, r6, cr15, cr15, {2}
    1e9c:	745f7473 	ldrbvc	r7, [pc], #-1139	; 1ea4 <shift+0x1ea4>
    1ea0:	656c6261 	strbvs	r6, [ip, #-609]!	; 0xfffffd9f
    1ea4:	75687400 	strbvc	r7, [r8, #-1024]!	; 0xfffffc00
    1ea8:	635f626d 	cmpvs	pc, #-805306362	; 0xd0000006
    1eac:	5f6c6c61 	svcpl	0x006c6c61
    1eb0:	5f616976 	svcpl	0x00616976
    1eb4:	6562616c 	strbvs	r6, [r2, #-364]!	; 0xfffffe94
    1eb8:	7369006c 	cmnvc	r9, #108	; 0x6c
    1ebc:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    1ec0:	70665f74 	rsbvc	r5, r6, r4, ror pc
    1ec4:	69003576 	stmdbvs	r0, {r1, r2, r4, r5, r6, r8, sl, ip, sp}
    1ec8:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    1ecc:	615f7469 	cmpvs	pc, r9, ror #8
    1ed0:	36766d72 			; <UNDEFINED> instruction: 0x36766d72
    1ed4:	4154006b 	cmpmi	r4, fp, rrx
    1ed8:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1edc:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1ee0:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1ee4:	61786574 	cmnvs	r8, r4, ror r5
    1ee8:	41540037 	cmpmi	r4, r7, lsr r0
    1eec:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1ef0:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1ef4:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1ef8:	61786574 	cmnvs	r8, r4, ror r5
    1efc:	41540038 	cmpmi	r4, r8, lsr r0
    1f00:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1f04:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1f08:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1f0c:	61786574 	cmnvs	r8, r4, ror r5
    1f10:	52410039 	subpl	r0, r1, #57	; 0x39
    1f14:	43505f4d 	cmpmi	r0, #308	; 0x134
    1f18:	50415f53 	subpl	r5, r1, r3, asr pc
    1f1c:	41005343 	tstmi	r0, r3, asr #6
    1f20:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    1f24:	415f5343 	cmpmi	pc, r3, asr #6
    1f28:	53435054 	movtpl	r5, #12372	; 0x3054
    1f2c:	6d6f6300 	stclvs	3, cr6, [pc, #-0]	; 1f34 <shift+0x1f34>
    1f30:	78656c70 	stmdavc	r5!, {r4, r5, r6, sl, fp, sp, lr}^
    1f34:	756f6420 	strbvc	r6, [pc, #-1056]!	; 1b1c <shift+0x1b1c>
    1f38:	00656c62 	rsbeq	r6, r5, r2, ror #24
    1f3c:	47524154 			; <UNDEFINED> instruction: 0x47524154
    1f40:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    1f44:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    1f48:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    1f4c:	33376178 	teqcc	r7, #120, 2
    1f50:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1f54:	35617865 	strbcc	r7, [r1, #-2149]!	; 0xfffff79b
    1f58:	41540033 	cmpmi	r4, r3, lsr r0
    1f5c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1f60:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1f64:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1f68:	6d786574 	cfldr64vs	mvdx6, [r8, #-464]!	; 0xfffffe30
    1f6c:	756c7030 	strbvc	r7, [ip, #-48]!	; 0xffffffd0
    1f70:	72610073 	rsbvc	r0, r1, #115	; 0x73
    1f74:	63635f6d 	cmnvs	r3, #436	; 0x1b4
    1f78:	61736900 	cmnvs	r3, r0, lsl #18
    1f7c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    1f80:	6373785f 	cmnvs	r3, #6225920	; 0x5f0000
    1f84:	00656c61 	rsbeq	r6, r5, r1, ror #24
    1f88:	6e6f645f 	mcrvs	4, 3, r6, cr15, cr15, {2}
    1f8c:	73755f74 	cmnvc	r5, #116, 30	; 0x1d0
    1f90:	72745f65 	rsbsvc	r5, r4, #404	; 0x194
    1f94:	685f6565 	ldmdavs	pc, {r0, r2, r5, r6, r8, sl, sp, lr}^	; <UNPREDICTABLE>
    1f98:	5f657265 	svcpl	0x00657265
    1f9c:	52415400 	subpl	r5, r1, #0, 8
    1fa0:	5f544547 	svcpl	0x00544547
    1fa4:	5f555043 	svcpl	0x00555043
    1fa8:	316d7261 	cmncc	sp, r1, ror #4
    1fac:	6d647430 	cfstrdvs	mvd7, [r4, #-192]!	; 0xffffff40
    1fb0:	41540069 	cmpmi	r4, r9, rrx
    1fb4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    1fb8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    1fbc:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    1fc0:	61786574 	cmnvs	r8, r4, ror r5
    1fc4:	61620035 	cmnvs	r2, r5, lsr r0
    1fc8:	615f6573 	cmpvs	pc, r3, ror r5	; <UNPREDICTABLE>
    1fcc:	69686372 	stmdbvs	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    1fd0:	74636574 	strbtvc	r6, [r3], #-1396	; 0xfffffa8c
    1fd4:	00657275 	rsbeq	r7, r5, r5, ror r2
    1fd8:	5f6d7261 	svcpl	0x006d7261
    1fdc:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    1fe0:	6372635f 	cmnvs	r2, #2080374785	; 0x7c000001
    1fe4:	52415400 	subpl	r5, r1, #0, 8
    1fe8:	5f544547 	svcpl	0x00544547
    1fec:	5f555043 	svcpl	0x00555043
    1ff0:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    1ff4:	316d7865 	cmncc	sp, r5, ror #16
    1ff8:	6c616d73 	stclvs	13, cr6, [r1], #-460	; 0xfffffe34
    1ffc:	6c756d6c 	ldclvs	13, cr6, [r5], #-432	; 0xfffffe50
    2000:	6c706974 			; <UNDEFINED> instruction: 0x6c706974
    2004:	72610079 	rsbvc	r0, r1, #121	; 0x79
    2008:	75635f6d 	strbvc	r5, [r3, #-3949]!	; 0xfffff093
    200c:	6e657272 	mcrvs	2, 3, r7, cr5, cr2, {3}
    2010:	63635f74 	cmnvs	r3, #116, 30	; 0x1d0
    2014:	61736900 	cmnvs	r3, r0, lsl #18
    2018:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    201c:	6372635f 	cmnvs	r2, #2080374785	; 0x7c000001
    2020:	41003233 	tstmi	r0, r3, lsr r2
    2024:	505f4d52 	subspl	r4, pc, r2, asr sp	; <UNPREDICTABLE>
    2028:	7369004c 	cmnvc	r9, #76	; 0x4c
    202c:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2030:	66765f74 	uhsub16vs	r5, r6, r4
    2034:	00337670 	eorseq	r7, r3, r0, ror r6
    2038:	5f617369 	svcpl	0x00617369
    203c:	5f746962 	svcpl	0x00746962
    2040:	76706676 			; <UNDEFINED> instruction: 0x76706676
    2044:	41420034 	cmpmi	r2, r4, lsr r0
    2048:	415f4553 	cmpmi	pc, r3, asr r5	; <UNPREDICTABLE>
    204c:	5f484352 	svcpl	0x00484352
    2050:	00325436 	eorseq	r5, r2, r6, lsr r4
    2054:	45534142 	ldrbmi	r4, [r3, #-322]	; 0xfffffebe
    2058:	4352415f 	cmpmi	r2, #-1073741801	; 0xc0000017
    205c:	4d385f48 	ldcmi	15, cr5, [r8, #-288]!	; 0xfffffee0
    2060:	49414d5f 	stmdbmi	r1, {r0, r1, r2, r3, r4, r6, r8, sl, fp, lr}^
    2064:	4154004e 	cmpmi	r4, lr, asr #32
    2068:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    206c:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2070:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2074:	6d647439 	cfstrdvs	mvd7, [r4, #-228]!	; 0xffffff1c
    2078:	52410069 	subpl	r0, r1, #105	; 0x69
    207c:	4c415f4d 	mcrrmi	15, 4, r5, r1, cr13
    2080:	53414200 	movtpl	r4, #4608	; 0x1200
    2084:	52415f45 	subpl	r5, r1, #276	; 0x114
    2088:	375f4843 	ldrbcc	r4, [pc, -r3, asr #16]
    208c:	7261004d 	rsbvc	r0, r1, #77	; 0x4d
    2090:	61745f6d 	cmnvs	r4, sp, ror #30
    2094:	74656772 	strbtvc	r6, [r5], #-1906	; 0xfffff88e
    2098:	62616c5f 	rsbvs	r6, r1, #24320	; 0x5f00
    209c:	61006c65 	tstvs	r0, r5, ror #24
    20a0:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 20a8 <shift+0x20a8>
    20a4:	65677261 	strbvs	r7, [r7, #-609]!	; 0xfffffd9f
    20a8:	6e695f74 	mcrvs	15, 3, r5, cr9, cr4, {3}
    20ac:	54006e73 	strpl	r6, [r0], #-3699	; 0xfffff18d
    20b0:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    20b4:	50435f54 	subpl	r5, r3, r4, asr pc
    20b8:	6f635f55 	svcvs	0x00635f55
    20bc:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    20c0:	54003472 	strpl	r3, [r0], #-1138	; 0xfffffb8e
    20c4:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    20c8:	50435f54 	subpl	r5, r3, r4, asr pc
    20cc:	6f635f55 	svcvs	0x00635f55
    20d0:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    20d4:	54003572 	strpl	r3, [r0], #-1394	; 0xfffffa8e
    20d8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    20dc:	50435f54 	subpl	r5, r3, r4, asr pc
    20e0:	6f635f55 	svcvs	0x00635f55
    20e4:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    20e8:	54003772 	strpl	r3, [r0], #-1906	; 0xfffff88e
    20ec:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    20f0:	50435f54 	subpl	r5, r3, r4, asr pc
    20f4:	6f635f55 	svcvs	0x00635f55
    20f8:	78657472 	stmdavc	r5!, {r1, r4, r5, r6, sl, ip, sp, lr}^
    20fc:	69003872 	stmdbvs	r0, {r1, r4, r5, r6, fp, ip, sp}
    2100:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2104:	6c5f7469 	cfldrdvs	mvd7, [pc], {105}	; 0x69
    2108:	00656170 	rsbeq	r6, r5, r0, ror r1
    210c:	5f617369 	svcpl	0x00617369
    2110:	5f746962 	svcpl	0x00746962
    2114:	72697571 	rsbvc	r7, r9, #473956352	; 0x1c400000
    2118:	72615f6b 	rsbvc	r5, r1, #428	; 0x1ac
    211c:	6b36766d 	blvs	d9fad8 <__bss_end+0xd96630>
    2120:	7369007a 	cmnvc	r9, #122	; 0x7a
    2124:	69625f61 	stmdbvs	r2!, {r0, r5, r6, r8, r9, sl, fp, ip, lr}^
    2128:	6f6e5f74 	svcvs	0x006e5f74
    212c:	69006d74 	stmdbvs	r0, {r2, r4, r5, r6, r8, sl, fp, sp, lr}
    2130:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2134:	615f7469 	cmpvs	pc, r9, ror #8
    2138:	34766d72 	ldrbtcc	r6, [r6], #-3442	; 0xfffff28e
    213c:	61736900 	cmnvs	r3, r0, lsl #18
    2140:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2144:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2148:	69003676 	stmdbvs	r0, {r1, r2, r4, r5, r6, r9, sl, ip, sp}
    214c:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2150:	615f7469 	cmpvs	pc, r9, ror #8
    2154:	37766d72 			; <UNDEFINED> instruction: 0x37766d72
    2158:	61736900 	cmnvs	r3, r0, lsl #18
    215c:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2160:	6d72615f 	ldfvse	f6, [r2, #-380]!	; 0xfffffe84
    2164:	5f003876 	svcpl	0x00003876
    2168:	746e6f64 	strbtvc	r6, [lr], #-3940	; 0xfffff09c
    216c:	6573755f 	ldrbvs	r7, [r3, #-1375]!	; 0xfffffaa1
    2170:	7874725f 	ldmdavc	r4!, {r0, r1, r2, r3, r4, r6, r9, ip, sp, lr}^
    2174:	7265685f 	rsbvc	r6, r5, #6225920	; 0x5f0000
    2178:	55005f65 	strpl	r5, [r0, #-3941]	; 0xfffff09b
    217c:	79744951 	ldmdbvc	r4!, {r0, r4, r6, r8, fp, lr}^
    2180:	69006570 	stmdbvs	r0, {r4, r5, r6, r8, sl, sp, lr}
    2184:	625f6173 	subsvs	r6, pc, #-1073741796	; 0xc000001c
    2188:	615f7469 	cmpvs	pc, r9, ror #8
    218c:	35766d72 	ldrbcc	r6, [r6, #-3442]!	; 0xfffff28e
    2190:	61006574 	tstvs	r0, r4, ror r5
    2194:	745f6d72 	ldrbvc	r6, [pc], #-3442	; 219c <shift+0x219c>
    2198:	00656e75 	rsbeq	r6, r5, r5, ror lr
    219c:	5f6d7261 	svcpl	0x006d7261
    21a0:	5f707063 	svcpl	0x00707063
    21a4:	65746e69 	ldrbvs	r6, [r4, #-3689]!	; 0xfffff197
    21a8:	726f7772 	rsbvc	r7, pc, #29884416	; 0x1c80000
    21ac:	7566006b 	strbvc	r0, [r6, #-107]!	; 0xffffff95
    21b0:	705f636e 	subsvc	r6, pc, lr, ror #6
    21b4:	54007274 	strpl	r7, [r0], #-628	; 0xfffffd8c
    21b8:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    21bc:	50435f54 	subpl	r5, r3, r4, asr pc
    21c0:	72615f55 	rsbvc	r5, r1, #340	; 0x154
    21c4:	3032396d 	eorscc	r3, r2, sp, ror #18
    21c8:	74680074 	strbtvc	r0, [r8], #-116	; 0xffffff8c
    21cc:	655f6261 	ldrbvs	r6, [pc, #-609]	; 1f73 <shift+0x1f73>
    21d0:	41540071 	cmpmi	r4, r1, ror r0
    21d4:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    21d8:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    21dc:	3561665f 	strbcc	r6, [r1, #-1631]!	; 0xfffff9a1
    21e0:	61003632 	tstvs	r0, r2, lsr r6
    21e4:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    21e8:	5f686372 	svcpl	0x00686372
    21ec:	6d756874 	ldclvs	8, cr6, [r5, #-464]!	; 0xfffffe30
    21f0:	77685f62 	strbvc	r5, [r8, -r2, ror #30]!
    21f4:	00766964 	rsbseq	r6, r6, r4, ror #18
    21f8:	62617468 	rsbvs	r7, r1, #104, 8	; 0x68000000
    21fc:	5f71655f 	svcpl	0x0071655f
    2200:	6e696f70 	mcrvs	15, 3, r6, cr9, cr0, {3}
    2204:	00726574 	rsbseq	r6, r2, r4, ror r5
    2208:	5f6d7261 	svcpl	0x006d7261
    220c:	5f636970 	svcpl	0x00636970
    2210:	69676572 	stmdbvs	r7!, {r1, r4, r5, r6, r8, sl, sp, lr}^
    2214:	72657473 	rsbvc	r7, r5, #1929379840	; 0x73000000
    2218:	52415400 	subpl	r5, r1, #0, 8
    221c:	5f544547 	svcpl	0x00544547
    2220:	5f555043 	svcpl	0x00555043
    2224:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2228:	306d7865 	rsbcc	r7, sp, r5, ror #16
    222c:	6c616d73 	stclvs	13, cr6, [r1], #-460	; 0xfffffe34
    2230:	6c756d6c 	ldclvs	13, cr6, [r5], #-432	; 0xfffffe50
    2234:	6c706974 			; <UNDEFINED> instruction: 0x6c706974
    2238:	41540079 	cmpmi	r4, r9, ror r0
    223c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2240:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2244:	63706d5f 	cmnvs	r0, #6080	; 0x17c0
    2248:	6e65726f 	cdpvs	2, 6, cr7, cr5, cr15, {3}
    224c:	7066766f 	rsbvc	r7, r6, pc, ror #12
    2250:	61736900 	cmnvs	r3, r0, lsl #18
    2254:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2258:	6975715f 	ldmdbvs	r5!, {r0, r1, r2, r3, r4, r6, r8, ip, sp, lr}^
    225c:	635f6b72 	cmpvs	pc, #116736	; 0x1c800
    2260:	6c5f336d 	mrrcvs	3, 6, r3, pc, cr13	; <UNPREDICTABLE>
    2264:	00647264 	rsbeq	r7, r4, r4, ror #4
    2268:	5f4d5241 	svcpl	0x004d5241
    226c:	61004343 	tstvs	r0, r3, asr #6
    2270:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2274:	38686372 	stmdacc	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    2278:	6100325f 	tstvs	r0, pc, asr r2
    227c:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    2280:	38686372 	stmdacc	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    2284:	6100335f 	tstvs	r0, pc, asr r3
    2288:	615f6d72 	cmpvs	pc, r2, ror sp	; <UNPREDICTABLE>
    228c:	38686372 	stmdacc	r8!, {r1, r4, r5, r6, r8, r9, sp, lr}^
    2290:	5400345f 	strpl	r3, [r0], #-1119	; 0xfffffba1
    2294:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2298:	50435f54 	subpl	r5, r3, r4, asr pc
    229c:	6d665f55 	stclvs	15, cr5, [r6, #-340]!	; 0xfffffeac
    22a0:	36323670 			; <UNDEFINED> instruction: 0x36323670
    22a4:	4d524100 	ldfmie	f4, [r2, #-0]
    22a8:	0053435f 	subseq	r4, r3, pc, asr r3
    22ac:	5f6d7261 	svcpl	0x006d7261
    22b0:	36317066 	ldrtcc	r7, [r1], -r6, rrx
    22b4:	736e695f 	cmnvc	lr, #1556480	; 0x17c000
    22b8:	72610074 	rsbvc	r0, r1, #116	; 0x74
    22bc:	61625f6d 	cmnvs	r2, sp, ror #30
    22c0:	615f6573 	cmpvs	pc, r3, ror r5	; <UNPREDICTABLE>
    22c4:	00686372 	rsbeq	r6, r8, r2, ror r3
    22c8:	47524154 			; <UNDEFINED> instruction: 0x47524154
    22cc:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    22d0:	635f5550 	cmpvs	pc, #80, 10	; 0x14000000
    22d4:	6574726f 	ldrbvs	r7, [r4, #-623]!	; 0xfffffd91
    22d8:	35316178 	ldrcc	r6, [r1, #-376]!	; 0xfffffe88
    22dc:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    22e0:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    22e4:	6d726100 	ldfvse	f6, [r2, #-0]
    22e8:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    22ec:	6d653768 	stclvs	7, cr3, [r5, #-416]!	; 0xfffffe60
    22f0:	52415400 	subpl	r5, r1, #0, 8
    22f4:	5f544547 	svcpl	0x00544547
    22f8:	5f555043 	svcpl	0x00555043
    22fc:	74726f63 	ldrbtvc	r6, [r2], #-3939	; 0xfffff09d
    2300:	37617865 	strbcc	r7, [r1, -r5, ror #16]!
    2304:	72610032 	rsbvc	r0, r1, #50	; 0x32
    2308:	63705f6d 	cmnvs	r0, #436	; 0x1b4
    230c:	65645f73 	strbvs	r5, [r4, #-3955]!	; 0xfffff08d
    2310:	6c756166 	ldfvse	f6, [r5], #-408	; 0xfffffe68
    2314:	52410074 	subpl	r0, r1, #116	; 0x74
    2318:	43505f4d 	cmpmi	r0, #308	; 0x134
    231c:	41415f53 	cmpmi	r1, r3, asr pc
    2320:	5f534350 	svcpl	0x00534350
    2324:	41434f4c 	cmpmi	r3, ip, asr #30
    2328:	4154004c 	cmpmi	r4, ip, asr #32
    232c:	54454752 	strbpl	r4, [r5], #-1874	; 0xfffff8ae
    2330:	5550435f 	ldrbpl	r4, [r0, #-863]	; 0xfffffca1
    2334:	726f635f 	rsbvc	r6, pc, #2080374785	; 0x7c000001
    2338:	61786574 	cmnvs	r8, r4, ror r5
    233c:	54003537 	strpl	r3, [r0], #-1335	; 0xfffffac9
    2340:	45475241 	strbmi	r5, [r7, #-577]	; 0xfffffdbf
    2344:	50435f54 	subpl	r5, r3, r4, asr pc
    2348:	74735f55 	ldrbtvc	r5, [r3], #-3925	; 0xfffff0ab
    234c:	676e6f72 			; <UNDEFINED> instruction: 0x676e6f72
    2350:	006d7261 	rsbeq	r7, sp, r1, ror #4
    2354:	5f6d7261 	svcpl	0x006d7261
    2358:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    235c:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    2360:	0031626d 	eorseq	r6, r1, sp, ror #4
    2364:	5f6d7261 	svcpl	0x006d7261
    2368:	68637261 	stmdavs	r3!, {r0, r5, r6, r9, ip, sp, lr}^
    236c:	7568745f 	strbvc	r7, [r8, #-1119]!	; 0xfffffba1
    2370:	0032626d 	eorseq	r6, r2, sp, ror #4
    2374:	47524154 			; <UNDEFINED> instruction: 0x47524154
    2378:	435f5445 	cmpmi	pc, #1157627904	; 0x45000000
    237c:	695f5550 	ldmdbvs	pc, {r4, r6, r8, sl, ip, lr}^	; <UNPREDICTABLE>
    2380:	786d6d77 	stmdavc	sp!, {r0, r1, r2, r4, r5, r6, r8, sl, fp, sp, lr}^
    2384:	72610074 	rsbvc	r0, r1, #116	; 0x74
    2388:	72615f6d 	rsbvc	r5, r1, #436	; 0x1b4
    238c:	74356863 	ldrtvc	r6, [r5], #-2147	; 0xfffff79d
    2390:	61736900 	cmnvs	r3, r0, lsl #18
    2394:	7469625f 	strbtvc	r6, [r9], #-607	; 0xfffffda1
    2398:	00706d5f 	rsbseq	r6, r0, pc, asr sp
    239c:	5f6d7261 	svcpl	0x006d7261
    23a0:	735f646c 	cmpvc	pc, #108, 8	; 0x6c000000
    23a4:	64656863 	strbtvs	r6, [r5], #-2147	; 0xfffff79d
    23a8:	6d726100 	ldfvse	f6, [r2, #-0]
    23ac:	6372615f 	cmnvs	r2, #-1073741801	; 0xc0000017
    23b0:	315f3868 	cmpcc	pc, r8, ror #16
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
  20:	8b040e42 	blhi	103930 <__bss_end+0xfa488>
  24:	0b0d4201 	bleq	350830 <__bss_end+0x347388>
  28:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
  2c:	00000ecb 	andeq	r0, r0, fp, asr #29
  30:	0000001c 	andeq	r0, r0, ip, lsl r0
  34:	00000000 	andeq	r0, r0, r0
  38:	00008064 	andeq	r8, r0, r4, rrx
  3c:	00000040 	andeq	r0, r0, r0, asr #32
  40:	8b080e42 	blhi	203950 <__bss_end+0x1fa4a8>
  44:	42018e02 	andmi	r8, r1, #2, 28
  48:	5a040b0c 	bpl	102c80 <__bss_end+0xf97d8>
  4c:	00080d0c 	andeq	r0, r8, ip, lsl #26
  50:	0000000c 	andeq	r0, r0, ip
  54:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  58:	7c020001 	stcvc	0, cr0, [r2], {1}
  5c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  60:	0000001c 	andeq	r0, r0, ip, lsl r0
  64:	00000050 	andeq	r0, r0, r0, asr r0
  68:	000080a4 	andeq	r8, r0, r4, lsr #1
  6c:	00000038 	andeq	r0, r0, r8, lsr r0
  70:	8b040e42 	blhi	103980 <__bss_end+0xfa4d8>
  74:	0b0d4201 	bleq	350880 <__bss_end+0x3473d8>
  78:	420d0d54 	andmi	r0, sp, #84, 26	; 0x1500
  7c:	00000ecb 	andeq	r0, r0, fp, asr #29
  80:	0000001c 	andeq	r0, r0, ip, lsl r0
  84:	00000050 	andeq	r0, r0, r0, asr r0
  88:	000080dc 	ldrdeq	r8, [r0], -ip
  8c:	0000002c 	andeq	r0, r0, ip, lsr #32
  90:	8b040e42 	blhi	1039a0 <__bss_end+0xfa4f8>
  94:	0b0d4201 	bleq	3508a0 <__bss_end+0x3473f8>
  98:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
  9c:	00000ecb 	andeq	r0, r0, fp, asr #29
  a0:	0000001c 	andeq	r0, r0, ip, lsl r0
  a4:	00000050 	andeq	r0, r0, r0, asr r0
  a8:	00008108 	andeq	r8, r0, r8, lsl #2
  ac:	00000020 	andeq	r0, r0, r0, lsr #32
  b0:	8b040e42 	blhi	1039c0 <__bss_end+0xfa518>
  b4:	0b0d4201 	bleq	3508c0 <__bss_end+0x347418>
  b8:	420d0d48 	andmi	r0, sp, #72, 26	; 0x1200
  bc:	00000ecb 	andeq	r0, r0, fp, asr #29
  c0:	0000001c 	andeq	r0, r0, ip, lsl r0
  c4:	00000050 	andeq	r0, r0, r0, asr r0
  c8:	00008128 	andeq	r8, r0, r8, lsr #2
  cc:	00000018 	andeq	r0, r0, r8, lsl r0
  d0:	8b040e42 	blhi	1039e0 <__bss_end+0xfa538>
  d4:	0b0d4201 	bleq	3508e0 <__bss_end+0x347438>
  d8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  dc:	00000ecb 	andeq	r0, r0, fp, asr #29
  e0:	0000001c 	andeq	r0, r0, ip, lsl r0
  e4:	00000050 	andeq	r0, r0, r0, asr r0
  e8:	00008140 	andeq	r8, r0, r0, asr #2
  ec:	00000018 	andeq	r0, r0, r8, lsl r0
  f0:	8b040e42 	blhi	103a00 <__bss_end+0xfa558>
  f4:	0b0d4201 	bleq	350900 <__bss_end+0x347458>
  f8:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
  fc:	00000ecb 	andeq	r0, r0, fp, asr #29
 100:	0000001c 	andeq	r0, r0, ip, lsl r0
 104:	00000050 	andeq	r0, r0, r0, asr r0
 108:	00008158 	andeq	r8, r0, r8, asr r1
 10c:	00000018 	andeq	r0, r0, r8, lsl r0
 110:	8b040e42 	blhi	103a20 <__bss_end+0xfa578>
 114:	0b0d4201 	bleq	350920 <__bss_end+0x347478>
 118:	420d0d44 	andmi	r0, sp, #68, 26	; 0x1100
 11c:	00000ecb 	andeq	r0, r0, fp, asr #29
 120:	00000014 	andeq	r0, r0, r4, lsl r0
 124:	00000050 	andeq	r0, r0, r0, asr r0
 128:	00008170 	andeq	r8, r0, r0, ror r1
 12c:	0000000c 	andeq	r0, r0, ip
 130:	8b040e42 	blhi	103a40 <__bss_end+0xfa598>
 134:	0b0d4201 	bleq	350940 <__bss_end+0x347498>
 138:	0000001c 	andeq	r0, r0, ip, lsl r0
 13c:	00000050 	andeq	r0, r0, r0, asr r0
 140:	0000817c 	andeq	r8, r0, ip, ror r1
 144:	00000058 	andeq	r0, r0, r8, asr r0
 148:	8b080e42 	blhi	203a58 <__bss_end+0x1fa5b0>
 14c:	42018e02 	andmi	r8, r1, #2, 28
 150:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 154:	00080d0c 	andeq	r0, r8, ip, lsl #26
 158:	0000001c 	andeq	r0, r0, ip, lsl r0
 15c:	00000050 	andeq	r0, r0, r0, asr r0
 160:	000081d4 	ldrdeq	r8, [r0], -r4
 164:	00000058 	andeq	r0, r0, r8, asr r0
 168:	8b080e42 	blhi	203a78 <__bss_end+0x1fa5d0>
 16c:	42018e02 	andmi	r8, r1, #2, 28
 170:	62040b0c 	andvs	r0, r4, #12, 22	; 0x3000
 174:	00080d0c 	andeq	r0, r8, ip, lsl #26
 178:	0000000c 	andeq	r0, r0, ip
 17c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 180:	7c020001 	stcvc	0, cr0, [r2], {1}
 184:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 188:	00000018 	andeq	r0, r0, r8, lsl r0
 18c:	00000178 	andeq	r0, r0, r8, ror r1
 190:	0000822c 	andeq	r8, r0, ip, lsr #4
 194:	00000048 	andeq	r0, r0, r8, asr #32
 198:	8b080e42 	blhi	203aa8 <__bss_end+0x1fa600>
 19c:	42018e02 	andmi	r8, r1, #2, 28
 1a0:	00040b0c 	andeq	r0, r4, ip, lsl #22
 1a4:	0000000c 	andeq	r0, r0, ip
 1a8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 1ac:	7c020001 	stcvc	0, cr0, [r2], {1}
 1b0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 1b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1bc:	00008274 	andeq	r8, r0, r4, ror r2
 1c0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1c4:	8b040e42 	blhi	103ad4 <__bss_end+0xfa62c>
 1c8:	0b0d4201 	bleq	3509d4 <__bss_end+0x34752c>
 1cc:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1dc:	000082a0 	andeq	r8, r0, r0, lsr #5
 1e0:	0000002c 	andeq	r0, r0, ip, lsr #32
 1e4:	8b040e42 	blhi	103af4 <__bss_end+0xfa64c>
 1e8:	0b0d4201 	bleq	3509f4 <__bss_end+0x34754c>
 1ec:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 1f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 1f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 1f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1fc:	000082cc 	andeq	r8, r0, ip, asr #5
 200:	0000001c 	andeq	r0, r0, ip, lsl r0
 204:	8b040e42 	blhi	103b14 <__bss_end+0xfa66c>
 208:	0b0d4201 	bleq	350a14 <__bss_end+0x34756c>
 20c:	420d0d46 	andmi	r0, sp, #4480	; 0x1180
 210:	00000ecb 	andeq	r0, r0, fp, asr #29
 214:	0000001c 	andeq	r0, r0, ip, lsl r0
 218:	000001a4 	andeq	r0, r0, r4, lsr #3
 21c:	000082e8 	andeq	r8, r0, r8, ror #5
 220:	00000044 	andeq	r0, r0, r4, asr #32
 224:	8b040e42 	blhi	103b34 <__bss_end+0xfa68c>
 228:	0b0d4201 	bleq	350a34 <__bss_end+0x34758c>
 22c:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 230:	00000ecb 	andeq	r0, r0, fp, asr #29
 234:	0000001c 	andeq	r0, r0, ip, lsl r0
 238:	000001a4 	andeq	r0, r0, r4, lsr #3
 23c:	0000832c 	andeq	r8, r0, ip, lsr #6
 240:	00000050 	andeq	r0, r0, r0, asr r0
 244:	8b040e42 	blhi	103b54 <__bss_end+0xfa6ac>
 248:	0b0d4201 	bleq	350a54 <__bss_end+0x3475ac>
 24c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 250:	00000ecb 	andeq	r0, r0, fp, asr #29
 254:	0000001c 	andeq	r0, r0, ip, lsl r0
 258:	000001a4 	andeq	r0, r0, r4, lsr #3
 25c:	0000837c 	andeq	r8, r0, ip, ror r3
 260:	00000050 	andeq	r0, r0, r0, asr r0
 264:	8b040e42 	blhi	103b74 <__bss_end+0xfa6cc>
 268:	0b0d4201 	bleq	350a74 <__bss_end+0x3475cc>
 26c:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 270:	00000ecb 	andeq	r0, r0, fp, asr #29
 274:	0000001c 	andeq	r0, r0, ip, lsl r0
 278:	000001a4 	andeq	r0, r0, r4, lsr #3
 27c:	000083cc 	andeq	r8, r0, ip, asr #7
 280:	0000002c 	andeq	r0, r0, ip, lsr #32
 284:	8b040e42 	blhi	103b94 <__bss_end+0xfa6ec>
 288:	0b0d4201 	bleq	350a94 <__bss_end+0x3475ec>
 28c:	420d0d4e 	andmi	r0, sp, #4992	; 0x1380
 290:	00000ecb 	andeq	r0, r0, fp, asr #29
 294:	0000001c 	andeq	r0, r0, ip, lsl r0
 298:	000001a4 	andeq	r0, r0, r4, lsr #3
 29c:	000083f8 	strdeq	r8, [r0], -r8	; <UNPREDICTABLE>
 2a0:	00000050 	andeq	r0, r0, r0, asr r0
 2a4:	8b040e42 	blhi	103bb4 <__bss_end+0xfa70c>
 2a8:	0b0d4201 	bleq	350ab4 <__bss_end+0x34760c>
 2ac:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2b0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2b4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2bc:	00008448 	andeq	r8, r0, r8, asr #8
 2c0:	00000044 	andeq	r0, r0, r4, asr #32
 2c4:	8b040e42 	blhi	103bd4 <__bss_end+0xfa72c>
 2c8:	0b0d4201 	bleq	350ad4 <__bss_end+0x34762c>
 2cc:	420d0d5a 	andmi	r0, sp, #5760	; 0x1680
 2d0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2d4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2d8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2dc:	0000848c 	andeq	r8, r0, ip, lsl #9
 2e0:	00000050 	andeq	r0, r0, r0, asr r0
 2e4:	8b040e42 	blhi	103bf4 <__bss_end+0xfa74c>
 2e8:	0b0d4201 	bleq	350af4 <__bss_end+0x34764c>
 2ec:	420d0d60 	andmi	r0, sp, #96, 26	; 0x1800
 2f0:	00000ecb 	andeq	r0, r0, fp, asr #29
 2f4:	0000001c 	andeq	r0, r0, ip, lsl r0
 2f8:	000001a4 	andeq	r0, r0, r4, lsr #3
 2fc:	000084dc 	ldrdeq	r8, [r0], -ip
 300:	00000054 	andeq	r0, r0, r4, asr r0
 304:	8b040e42 	blhi	103c14 <__bss_end+0xfa76c>
 308:	0b0d4201 	bleq	350b14 <__bss_end+0x34766c>
 30c:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 310:	00000ecb 	andeq	r0, r0, fp, asr #29
 314:	0000001c 	andeq	r0, r0, ip, lsl r0
 318:	000001a4 	andeq	r0, r0, r4, lsr #3
 31c:	00008530 	andeq	r8, r0, r0, lsr r5
 320:	0000003c 	andeq	r0, r0, ip, lsr r0
 324:	8b040e42 	blhi	103c34 <__bss_end+0xfa78c>
 328:	0b0d4201 	bleq	350b34 <__bss_end+0x34768c>
 32c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 330:	00000ecb 	andeq	r0, r0, fp, asr #29
 334:	0000001c 	andeq	r0, r0, ip, lsl r0
 338:	000001a4 	andeq	r0, r0, r4, lsr #3
 33c:	0000856c 	andeq	r8, r0, ip, ror #10
 340:	0000003c 	andeq	r0, r0, ip, lsr r0
 344:	8b040e42 	blhi	103c54 <__bss_end+0xfa7ac>
 348:	0b0d4201 	bleq	350b54 <__bss_end+0x3476ac>
 34c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 350:	00000ecb 	andeq	r0, r0, fp, asr #29
 354:	0000001c 	andeq	r0, r0, ip, lsl r0
 358:	000001a4 	andeq	r0, r0, r4, lsr #3
 35c:	000085a8 	andeq	r8, r0, r8, lsr #11
 360:	0000003c 	andeq	r0, r0, ip, lsr r0
 364:	8b040e42 	blhi	103c74 <__bss_end+0xfa7cc>
 368:	0b0d4201 	bleq	350b74 <__bss_end+0x3476cc>
 36c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 370:	00000ecb 	andeq	r0, r0, fp, asr #29
 374:	0000001c 	andeq	r0, r0, ip, lsl r0
 378:	000001a4 	andeq	r0, r0, r4, lsr #3
 37c:	000085e4 	andeq	r8, r0, r4, ror #11
 380:	0000003c 	andeq	r0, r0, ip, lsr r0
 384:	8b040e42 	blhi	103c94 <__bss_end+0xfa7ec>
 388:	0b0d4201 	bleq	350b94 <__bss_end+0x3476ec>
 38c:	420d0d56 	andmi	r0, sp, #5504	; 0x1580
 390:	00000ecb 	andeq	r0, r0, fp, asr #29
 394:	0000001c 	andeq	r0, r0, ip, lsl r0
 398:	000001a4 	andeq	r0, r0, r4, lsr #3
 39c:	00008620 	andeq	r8, r0, r0, lsr #12
 3a0:	000000b0 	strheq	r0, [r0], -r0	; <UNPREDICTABLE>
 3a4:	8b080e42 	blhi	203cb4 <__bss_end+0x1fa80c>
 3a8:	42018e02 	andmi	r8, r1, #2, 28
 3ac:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3b0:	080d0c50 	stmdaeq	sp, {r4, r6, sl, fp}
 3b4:	0000000c 	andeq	r0, r0, ip
 3b8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 3bc:	7c020001 	stcvc	0, cr0, [r2], {1}
 3c0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 3c4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3c8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3cc:	000086d0 	ldrdeq	r8, [r0], -r0
 3d0:	00000174 	andeq	r0, r0, r4, ror r1
 3d4:	8b080e42 	blhi	203ce4 <__bss_end+0x1fa83c>
 3d8:	42018e02 	andmi	r8, r1, #2, 28
 3dc:	02040b0c 	andeq	r0, r4, #12, 22	; 0x3000
 3e0:	080d0cb2 	stmdaeq	sp, {r1, r4, r5, r7, sl, fp}
 3e4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3e8:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 3ec:	00008844 	andeq	r8, r0, r4, asr #16
 3f0:	0000009c 	muleq	r0, ip, r0
 3f4:	8b040e42 	blhi	103d04 <__bss_end+0xfa85c>
 3f8:	0b0d4201 	bleq	350c04 <__bss_end+0x34775c>
 3fc:	0d0d4602 	stceq	6, cr4, [sp, #-8]
 400:	000ecb42 	andeq	ip, lr, r2, asr #22
 404:	0000001c 	andeq	r0, r0, ip, lsl r0
 408:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 40c:	000088e0 	andeq	r8, r0, r0, ror #17
 410:	000000c8 	andeq	r0, r0, r8, asr #1
 414:	8b040e42 	blhi	103d24 <__bss_end+0xfa87c>
 418:	0b0d4201 	bleq	350c24 <__bss_end+0x34777c>
 41c:	0d0d5202 	sfmeq	f5, 4, [sp, #-8]
 420:	000ecb42 	andeq	ip, lr, r2, asr #22
 424:	00000020 	andeq	r0, r0, r0, lsr #32
 428:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 42c:	000089a8 	andeq	r8, r0, r8, lsr #19
 430:	000002b4 			; <UNDEFINED> instruction: 0x000002b4
 434:	8b040e42 	blhi	103d44 <__bss_end+0xfa89c>
 438:	0b0d4201 	bleq	350c44 <__bss_end+0x34779c>
 43c:	0d014803 	stceq	8, cr4, [r1, #-12]
 440:	0ecb420d 	cdpeq	2, 12, cr4, cr11, cr13, {0}
 444:	00000000 	andeq	r0, r0, r0
 448:	00000020 	andeq	r0, r0, r0, lsr #32
 44c:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 450:	00008c5c 	andeq	r8, r0, ip, asr ip
 454:	00000238 	andeq	r0, r0, r8, lsr r2
 458:	8b080e42 	blhi	203d68 <__bss_end+0x1fa8c0>
 45c:	42018e02 	andmi	r8, r1, #2, 28
 460:	03040b0c 	movweq	r0, #19212	; 0x4b0c
 464:	0d0c0110 	stfeqs	f0, [ip, #-64]	; 0xffffffc0
 468:	00000008 	andeq	r0, r0, r8
 46c:	0000001c 	andeq	r0, r0, ip, lsl r0
 470:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 474:	00008e94 	muleq	r0, r4, lr
 478:	000000c0 	andeq	r0, r0, r0, asr #1
 47c:	8b040e42 	blhi	103d8c <__bss_end+0xfa8e4>
 480:	0b0d4201 	bleq	350c8c <__bss_end+0x3477e4>
 484:	0d0d5802 	stceq	8, cr5, [sp, #-8]
 488:	000ecb42 	andeq	ip, lr, r2, asr #22
 48c:	0000001c 	andeq	r0, r0, ip, lsl r0
 490:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 494:	00008f54 	andeq	r8, r0, r4, asr pc
 498:	000000d4 	ldrdeq	r0, [r0], -r4
 49c:	8b040e42 	blhi	103dac <__bss_end+0xfa904>
 4a0:	0b0d4201 	bleq	350cac <__bss_end+0x347804>
 4a4:	0d0d6202 	sfmeq	f6, 4, [sp, #-8]
 4a8:	000ecb42 	andeq	ip, lr, r2, asr #22
 4ac:	0000001c 	andeq	r0, r0, ip, lsl r0
 4b0:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 4b4:	00009028 	andeq	r9, r0, r8, lsr #32
 4b8:	000000ac 	andeq	r0, r0, ip, lsr #1
 4bc:	8b040e42 	blhi	103dcc <__bss_end+0xfa924>
 4c0:	0b0d4201 	bleq	350ccc <__bss_end+0x347824>
 4c4:	0d0d4e02 	stceq	14, cr4, [sp, #-8]
 4c8:	000ecb42 	andeq	ip, lr, r2, asr #22
 4cc:	0000001c 	andeq	r0, r0, ip, lsl r0
 4d0:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 4d4:	000090d4 	ldrdeq	r9, [r0], -r4
 4d8:	00000054 	andeq	r0, r0, r4, asr r0
 4dc:	8b040e42 	blhi	103dec <__bss_end+0xfa944>
 4e0:	0b0d4201 	bleq	350cec <__bss_end+0x347844>
 4e4:	420d0d62 	andmi	r0, sp, #6272	; 0x1880
 4e8:	00000ecb 	andeq	r0, r0, fp, asr #29
 4ec:	0000001c 	andeq	r0, r0, ip, lsl r0
 4f0:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 4f4:	00009128 	andeq	r9, r0, r8, lsr #2
 4f8:	00000068 	andeq	r0, r0, r8, rrx
 4fc:	8b040e42 	blhi	103e0c <__bss_end+0xfa964>
 500:	0b0d4201 	bleq	350d0c <__bss_end+0x347864>
 504:	420d0d6c 	andmi	r0, sp, #108, 26	; 0x1b00
 508:	00000ecb 	andeq	r0, r0, fp, asr #29
 50c:	0000001c 	andeq	r0, r0, ip, lsl r0
 510:	000003b4 			; <UNDEFINED> instruction: 0x000003b4
 514:	00009190 	muleq	r0, r0, r1
 518:	00000080 	andeq	r0, r0, r0, lsl #1
 51c:	8b040e42 	blhi	103e2c <__bss_end+0xfa984>
 520:	0b0d4201 	bleq	350d2c <__bss_end+0x347884>
 524:	420d0d78 	andmi	r0, sp, #120, 26	; 0x1e00
 528:	00000ecb 	andeq	r0, r0, fp, asr #29
 52c:	0000000c 	andeq	r0, r0, ip
 530:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 534:	7c010001 	stcvc	0, cr0, [r1], {1}
 538:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 53c:	0000000c 	andeq	r0, r0, ip
 540:	0000052c 	andeq	r0, r0, ip, lsr #10
 544:	00009210 	andeq	r9, r0, r0, lsl r2
 548:	000001ec 	andeq	r0, r0, ip, ror #3
