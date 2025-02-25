#pragma once

#include <hal/intdef.h>

// heap allocarto for user task - todo free

class Userspace_Heap_Manager
{
    private:
        void MapMem(TTask_Struct* task, uint32_t pageAddress);
        void Alloc_Page(TTask_Struct* task);

    public:
        Userspace_Heap_Manager();

        uint32_t sbrk(TTask_Struct* task, uint32_t size);
};

extern Userspace_Heap_Manager sUserspaceMem;