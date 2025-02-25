#include <readUtils.h>
#include <stdfile.h>
#include <stdstring.h>

Read_Utils::Read_Utils() {
    // Prazdny konstruktor
};

uint32_t Read_Utils::readLine(char * returnBuffer, uint32_t file, bool blocking) {
    char readBuffer[128];
	bzero(readBuffer, 128);
	uint32_t readChars = 0;

    //Read from UART if data are available.
	do {
		if (blocking == true) {	//If we want to block the process, we just wait until we receive something from  UART
			wait(file, 0x1000, 0x2000);
		}

		/*TODO: Vyhodit blocking na UARTu, sere na to pes :) */

		uint32_t len = read(file, readBuffer, 128);
		if (len != 0) {

			//Write into it's own circular buffer holding previous values.
			//This is used for example if user pastes two lines, we don't want to scrap the result.
			//Other scenario might be that user might enter for example only two characters without pressing \n - We still 
			//Want to save the results and return them on next readLine call.
			
			cb.write(readBuffer, len);
			readChars = cb.readUntil('\r', returnBuffer);

			//Remove newLine and carriage return characters from the end of the string.
			for (int i = readChars - 1; i >= 0; i--) {
				if (returnBuffer[i] == '\r' || returnBuffer[i] == '\n') {
					returnBuffer[i] = '\0';
					continue; //Replace and continue to another character 
				}

				break; //There was no newline, we suspect that there is alphanumeric characters and no new line char will be present, so we can stop the search.
			}
		}
	} while (readChars == 0 && blocking == true);
	
    return readChars;
}

