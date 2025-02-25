#include <stdmem.h>
/**
 * In this function we could have placed anorther second layer of memory assignment resulting in 
 * less often calls of software interrupt and memory allocation.
 */
void* malloc(uint32_t size)
{
    uint32_t mem_add;
    asm volatile("mov r0, %0" : : "r" (size));
    asm volatile("swi 128");
    asm volatile("mov %0, r0" : "=r" (mem_add));
	void* ret = reinterpret_cast<void*>(mem_add);
    return ret;
}
