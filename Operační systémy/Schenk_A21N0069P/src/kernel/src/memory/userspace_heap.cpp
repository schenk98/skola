#include <process/process_manager.h>
#include <memory/userspace_heap.h>
#include <memory/pages.h>
#include <memory/mmu.h>


Userspace_Heap_Manager sUserspaceMem;

Userspace_Heap_Manager::Userspace_Heap_Manager()
{
    //todo?
}
uint32_t Userspace_Heap_Manager::sbrk(TTask_Struct* task, uint32_t size)
{
    //alloc first page (if there is no more space on previous)
    if (task->heapStart == 0) {
        task->heapStart = mem::UserspaceHeapVirtualBase;
        Alloc_Page(task);
    }

    //Alloc pages
    while (task->heapPhysicalLimit - task->heapLogicalLimit < size) {
        Alloc_Page(task);
    }

    uint32_t addressToReturn = task->heapStart + task->heapLogicalLimit;
    task->heapLogicalLimit = task->heapLogicalLimit + size;

    return addressToReturn;
}

void Userspace_Heap_Manager::Alloc_Page(TTask_Struct* task) {
    uint32_t page = sPage_Manager.Alloc_Page();
    MapMem(task, page);

    task->heapPhysicalLimit = task->heapPhysicalLimit + mem::PageSize;
}

void Userspace_Heap_Manager::MapMem(TTask_Struct* task, uint32_t pageAddress) {   
    uint32_t vAdd = task->heapStart + task->heapPhysicalLimit;
    uint32_t pAdd = pageAddress - mem::MemoryVirtualBase;
    map_memory(task->pt, pAdd, vAdd);
}


