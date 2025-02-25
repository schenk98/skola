#include <circularBuffer.h>
#include <stdstring.h>

Circular_Buffer::Circular_Buffer() {
    bzero(buffer, BUFFER_SIZE);
};

/* TODO: Vyresit tady nejak try_spinlock_lock. Mozna predat spinlock z UARTu, ktery muze UART driver zavrit externe nez spusti read. */

//read all and return len
uint32_t Circular_Buffer::read(char * ret) {
    return read(ret, write_index - read_index); //read all between start and stop
}

//try to read x char and return number of actually read chars
uint32_t Circular_Buffer::read(char * ret, uint32_t len) {
    int readChars = 0;
    uint32_t maxLen = write_index - read_index;

    if (maxLen < len) {
        len = maxLen;
    }

    for (int i = 0; i < len; i++) {
        ret[readChars] = buffer[read_index % BUFFER_SIZE];

        readChars++; //Increment counter to return
        read_index++; //Increment read_index
    }

    return readChars;
}

//more chars write
void Circular_Buffer::write(char* input, uint32_t len) {
    for (int i = 0; i < len; i++) {
        write(input[i]);
    }
}

// one char write
void Circular_Buffer::write(char input) {
    buffer[write_index % BUFFER_SIZE] = input;
    write_index++;
}


//read till you find stop char, or return 0 and data back to buffer
uint32_t Circular_Buffer::readUntil(char stop, char* ret) {
    int readTempIndex;

    for (readTempIndex = read_index; readTempIndex < write_index; readTempIndex++) {
        if (buffer[readTempIndex % BUFFER_SIZE] == stop) {
            break;
        }

        //return 0 bcs I am at the end and there was no stop char
        if (readTempIndex == write_index - 1) {
            return 0;
        }
    }

    //readTempIndex keeps position
    return read(ret, readTempIndex - read_index + 1); //Read one more char - if we have asd\n, then \n is readTempIndex 3 - read_index 0 = 3 - but we want 4 letters
}

