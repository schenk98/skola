#pragma once

#include <hal/intdef.h>

void* malloc(uint32_t size);

template<class T>
T* malloc()
{
    return reinterpret_cast<T*>(malloc(sizeof(T)));
}