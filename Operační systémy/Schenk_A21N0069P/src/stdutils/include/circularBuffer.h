#pragma once

#include <hal/intdef.h>

#define BUFFER_SIZE 128

class Circular_Buffer
{
    private:
        //Buffer
        char buffer[BUFFER_SIZE];
        
        //start addresses
        uint32_t read_index = 0;
        uint32_t write_index = 0;

    public:
        // constructor for circular buffer
        Circular_Buffer();

        //read all, return len
        uint32_t read(char * ret);
        
        //try read X chars, return number of actually red chars
        uint32_t read(char * ret, uint32_t len);

        //read untill you find stop char, or return 0 if there is no stop char
        uint32_t readUntil(char stop, char* ret);

        //write more chars to buffer
        void write(char* input, uint32_t len);

        //put one char to buffer
        void write(char input);
};