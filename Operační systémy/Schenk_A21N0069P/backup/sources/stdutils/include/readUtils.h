#pragma once

#include <hal/intdef.h>
#include <circularBuffer.h>

#define BUFFER_SIZE 128

class Read_Utils
{
    private:
        //Buffer
        Circular_Buffer cb;

    public:
        //constructor
        Read_Utils();

        //read line into buffer
        uint32_t readLine(char * ret_buffer, uint32_t file, bool block = false);
};