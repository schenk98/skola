#include <stdstring.h>
#include <stdfile.h>
#include <readUtils.h>
#include <stdmem.h>
#include <drivers/bridges/uart_defs.h>

//declaration of variables
//declaration of delta and prediction values
uint32_t DELTA;
uint32_t PRED;
//deriv constant is counted from delta and there is no need to count it every time
float DERIV_CONST;
//array for storing values got from console - there is code to make it bigger if overflow might be issue
float* values = reinterpret_cast<float*>(malloc(16*sizeof(float)));
//indexer of values - last value is on values[val_counter-1];
uint32_t val_counter;
//size of values - so it can be made bigger if need to be
uint32_t val_size = 16;
//constants for genetic algorithm - population size and number of generation (change GEN_COUNT to make it quicker or longer to count)
const uint32_t POPULATION = 50;
const uint32_t GEN_COUNT = 1000;
//two dimensional array didnt work, so this is ugly workaround with methods gen() and genIs()
float generationA[POPULATION];
float generationB[POPULATION];
float generationC[POPULATION];
float generationD[POPULATION];
float generationE[POPULATION];
//currently best params of all in current generation
uint32_t best_index;
//was tere stop called from console -> exit program
bool stop;
//buffer for reading from console
char readValue[32];
//reader fro reading console
Read_Utils reader;
//file for using console
uint32_t uartFile;
//random - file and value - generating random
uint32_t rnd;
uint32_t rnd_value;

//best params in whole cycle
float* best_params = reinterpret_cast<float*>(malloc(5*sizeof(float)));
//last best params
float* old_best_params = reinterpret_cast<float*>(malloc(5*sizeof(float)));

//constant for probability of mutaion
const uint32_t PROBABILITY_OF_MUTAION_PERCENT = 10;
//if there is generated new member of population etc. this defines range in which parameterrs are
const uint32_t RANDOM_RANGE = 50;


//get from two dimensional array gen(x,y) => generation[x,y];
float gen(int x, int y){
	if(y==0)return generationA[x];
	else if(y==1)return generationB[x];
	else if(y==2)return generationC[x];
	else if(y==3)return generationD[x];
	else if(y==4)return generationE[x];
	else return 0;
}
//set for two dimensional array genIs(x,y,val) => generation[x,y]=val;
void genIs(int x, int y, float value){
	if(y==0) generationA[x]=value;
	else if(y==1) generationB[x]=value;
	else if(y==2) generationC[x]=value;
	else if(y==3) generationD[x]=value;
	else if(y==4) generationE[x]=value;
	else return;
}

//check char* if there is stop in it
bool checkForStop(char* buffer, uint32_t size){
	for(uint32_t j = 0; j < size-4; j++){
		if(buffer[j] == 's' && buffer[j+1] == 't' && buffer[j+2] == 'o' && buffer[j+3] == 'p')
			return true;
	}
	return false;
}

//read line - with writing what was written back into console and check for stop
void console_in(uint32_t size = 32, bool block = true){
	uint32_t len;
	bzero(readValue, 32);
    //read buffer
    len = reader.readLine(readValue, uartFile, block);
    //write what has been read
	//write(uartFile, "You wrote: ", 11);
	write(uartFile, readValue, len);
	if(len>0){
        //if end line write new line
	    write(uartFile, "\n", 1);
	}
	if(checkForStop(readValue, 32))stop=true;
}

//get size of given char*
uint32_t get_size(char* s) {	//size of char*
	char* t;
	for (t = s; *t != '\0'; t++)
		;
	return t - s;
}

//check if char* is float, int or string
uint32_t check_param(char* param) { //0=str, 1=int, 2=float
	int size = get_size(param);
	bool whole = true;
	char a;
	for (int i = 0; i < size; i++) {
		a = param[i];
		//end of line means end of string
		if (a == '\n') {
			break;
		}
		//if there is . or , it is not a whole number, if it already wasnt I found 2nd . or , -> return not int nor float
		if (a == '.' || a == ',') {
			if (!whole)
				return 0;
			whole = false;
		}
		//if character is in range of 0-9 or its . or , - it might be number
		if (!((a >= '0' && a <= '9') || a == '.' || a == ','))
			return 0;
	}
	if (whole)return 1;
	else return 2;
}


//read first two parameters
void read_param() {
    char* param =  reinterpret_cast<char*>(malloc(32));
	while (true) {
		//read first parameter - delta
		bzero(readValue, 32);
		console_in();
		uint32_t b = check_param(readValue);

		//check if it is number
		if (b == 1 || b == 2) {			
			DELTA = atoi(readValue);
			if(b==2) DELTA = DELTA / 10;
			//set DERIV_CONST so its not counted multiple times
			DERIV_CONST = ((DELTA * 60.0 * 1.0) / (24.0 * 60.0 * 60.0));

			//print it out
			char* deltaChar =  reinterpret_cast<char*>(malloc(sizeof(uint32_t)));
			itoa(DELTA, deltaChar, 10);

			//write to console what came
			/*char* print_out;
			strcat(print_out, reinterpret_cast<const char*>("OK, krokovani "));
			strcat(print_out, reinterpret_cast<const char*>(deltaChar));
			strcat(print_out, reinterpret_cast<const char*>(" min.\n"));
			write(uartFile, print_out, 22 + sizeof(uint32_t));*/

			write(uartFile, "OK, krokovani ", 14);
			write(uartFile, deltaChar, 16);
			write(uartFile, " min.\n", 6);

            
			break;
		}
		else {
			//there was string instead of int or float
			const char* print_out = "Zadejte cele cislo prosim.\n";
            write(uartFile, print_out, 28);
		}
	}
	while (true) {
		//read second parameter - prediction
		bzero(readValue, 32);
		console_in();
		uint32_t b = check_param(readValue);		

		//check if it is number
		if (b == 1 || b == 2) {
			PRED = atoi(readValue);
			if(b == 2) PRED = PRED / 10;
			//write to console what came
			char* predChar = reinterpret_cast<char*>(malloc(sizeof(uint32_t)));
			bzero(predChar, sizeof(uint32_t));
			itoa(PRED, predChar, 10);

            /*char* print_out = reinterpret_cast<char*>(malloc(64));
			bzero(print_out, 64);
			strcat(print_out, "OK, predikce je ");
			strcat(print_out, reinterpret_cast<const char*>(predChar));
			strcat(print_out, reinterpret_cast<const char*>(" min.\n"));
            write(uartFile, print_out, 22 + sizeof(uint32_t));*/

			//write it out
			write(uartFile, "OK, predikce je ", 16);
			write(uartFile, predChar, 16);
			write(uartFile, " min.\n", 6);

			return;
		}
		else {
			//there was no number on imput, repeat
			const char* print_out = "Zadejte cele cislo prosim.\n";
            write(uartFile, print_out, 28);
		}
	}
}

//read new float value
uint32_t read_input() {
	float input;
	char* param = reinterpret_cast<char*>(malloc(32));
	bzero(readValue, 32);
	console_in();

	if (checkForStop(readValue, 32))
		return 1;
	else if (readValue == "parameters")
		return 2;
	else if (check_param(readValue) == 0){
		return 3;
	}

	input = atof(readValue);

	//store new value
	values[val_counter] = input;
	val_counter++;

	//expand array for values if needed
	if (val_counter >= val_size) {
		val_size *= 2;
		float* newVal =  reinterpret_cast<float*>(malloc(val_size*sizeof(float)));
		bzero(newVal, val_size*sizeof(float));
		for (int i = 0; i < val_size / 2; i++) {
			newVal[i] = values[i];
		}
		values = newVal;
	}

	return 0;
}

//just quick function from CW - return b(t)
float count_b(float d, float e, float y_new, float y_old) {	//b(t) = D/E * dy(t)/dt + 1/E * y(t)			"dy(t)/dt" = (values[i-1] - values[i]) / ((step * 60) / (24 * 60 * 60))
	float tmp1 = (d / e);
	float tmp2 = DERIV_CONST;
	float tmp3 = 1 / e;
	float tmp4 = tmp1 * tmp2 + (tmp3 * y_new);

	return tmp4;
}

//just quick function from CW - return y(t+tpred)
float get_y(float a, float b, float c, float d, float e, float x, float y_new, float y_old) {		//y(t + t_pred) = A * b(t) + B * b(t) * (b(t) - y(t)) + C
	float bt = count_b(d, e, y_new, y_old);
	return (a * bt) + (b * bt * (bt - y_new)) + c;
}


//get new random number
int pseudoRandom(int start, int end) {
	char* buf = reinterpret_cast<char*>(malloc(sizeof(uint32_t)));
	bzero(buf, sizeof(uint32_t));
    //get new random value
	read(rnd, buf, sizeof(uint32_t));
    //make it into number
	rnd_value = reinterpret_cast<uint32_t*>(buf)[0];
    //get radnom value in range
	rnd_value = rnd_value % (end-start);
	//return shifted
	return rnd_value + start;
}

//generate new member of generation
void generate_new(int index) {
	genIs(index, 0, pseudoRandom(0-RANDOM_RANGE, RANDOM_RANGE));
	genIs(index, 1, pseudoRandom(0-RANDOM_RANGE, RANDOM_RANGE));
	genIs(index, 2, pseudoRandom(0-RANDOM_RANGE, RANDOM_RANGE));
	genIs(index, 3, pseudoRandom(0-RANDOM_RANGE, RANDOM_RANGE));
	genIs(index, 4, pseudoRandom(0-RANDOM_RANGE, RANDOM_RANGE));
}

//mostly for debugging and bcs I am lazy to turn it back
float getY(int x, float y, float oldY, float* params) {
	float a = params[0];
	float b = params[1];
	float c = params[2];
	float d = params[3];
	float e = params[4];
	return get_y(a, b, c, d, e, x, y, oldY);
}

//function to get fitness of member of generation
float get_fitness(float* params) {
	float sum = 0;
	float predictedY, realYWas;
	//for each point I have possible prediction and real value
	for (int i = PRED / DELTA + 1; i < val_counter; i++) {
		//predict point with old values and check with newly got value
		predictedY = getY(i * DELTA, values[i - (PRED / DELTA)], values[i - 1 - (PRED / DELTA)], params);
		realYWas = values[i];
		//add a*a for positive value
		sum += (realYWas - predictedY) * (realYWas - predictedY);
	}
	return sum;
}

//run evolution
float count() {
	old_best_params=best_params;
	float treshold, fit, best, next_y;
	int bestIndex;
	//if I dont have enough data
	if (val_counter <= (PRED / DELTA) + 1) {
        write(uartFile, "Not enough values\n", 18);
		return -1.0;
	}
	
	//inicialization of population
	else if (val_counter - 1 == (PRED / DELTA) + 1) {
		for (int i = 0; i < POPULATION; i++) {
			generate_new(i);
		}
	}

	//1st is best for now
	float tmp[5];
	tmp[0] = gen(0,0);
	tmp[1] = gen(0,1);
	tmp[2] = gen(0,2);
	tmp[3] = gen(0,3);
	tmp[4] = gen(0,4);
	best = get_fitness(tmp);
	//run for desired number of generations
	for (int i = 0; i < GEN_COUNT; i++) {
		//set threshold - wore part of population will be randomized, better will stay and wait for crossing
		int rndIndex = pseudoRandom(0, POPULATION);
		float tmp2[5];
		tmp2[0] = gen(rndIndex,0);
		tmp2[1] = gen(rndIndex,1);
		tmp2[2] = gen(rndIndex,2);
		tmp2[3] = gen(rndIndex,3);
		tmp2[4] = gen(rndIndex,4);
		treshold = get_fitness(tmp2);

		//evaluation part
		for (int j = 1; j < POPULATION; j++) {
			float tmp1[5];
			tmp1[0] = gen(j,0);
			tmp1[1] = gen(j,1);
			tmp1[2] = gen(j,2);
			tmp1[3] = gen(j,3);
			tmp1[4] = gen(j,4);
			//get fit of this member
			fit = get_fitness(tmp1);
			//if its not good enough replace with new random member
			if (fit > treshold) {
				generate_new(j);
			}
			//if its good, keep it and check for best
			else if (fit < best) {
				best = fit;
				best_index = j;
				for (int k = 0; k < 5; k++) {
					best_params[k] = gen(j,k);
				}
			}
		}
		
		//count new y
		next_y = getY(val_counter + 1, values[val_counter - 1], values[val_counter - 2], best_params);
		
		//crossing
		for (int i = 0; i < POPULATION; i++) {
			
			//0-5x cross
			for (int j = 0; j < pseudoRandom(0, 5); j++) {
				//random position
				int a = pseudoRandom(0, 4);		//with random member of population
				genIs(i, a, gen(pseudoRandom(0, POPULATION), a));
			}
		}
		
		//mutaion - for each member of population
		for (int i = 0; i < POPULATION; i++) {
			//there is chance to mutate (chance is PROBABILITY_OF_MUTAION_PERCENT)
			if (pseudoRandom(0, 100) <= PROBABILITY_OF_MUTAION_PERCENT) {
				//then one of its parameters mutates
				float tmpGen = gen(i,pseudoRandom(0, 4)) + pseudoRandom(0-RANDOM_RANGE/5, RANDOM_RANGE/5);
				genIs(i,pseudoRandom(0, 4), tmpGen);
				
			}
		}
		
		//check if there is not stop in console
		console_in(32, false);
		if(checkForStop(readValue, 32)){
			next_y = getY(val_counter + 1, values[val_counter - 1], values[val_counter - 2], old_best_params);
			best_params = old_best_params;
			best = get_fitness(old_best_params);			
			break;
		}

	}

	//write out info from this run
	char* bestChar = reinterpret_cast<char*>(malloc(16));
	ftoa(bestChar, best);	
	write(uartFile, "Best Fit: ", 10);
	write(uartFile, bestChar, 16);
	write(uartFile, "\n", 1);
	
	return next_y;
}

//function to write parameters
void printParam(){

	//alloc space
	char* a =  reinterpret_cast<char*>(malloc(16));
	char*  b =  reinterpret_cast<char*>(malloc(16));
	char*  c =  reinterpret_cast<char*>(malloc(16));
	char*  d =  reinterpret_cast<char*>(malloc(16));
	char*  e =  reinterpret_cast<char*>(malloc(16));
	//clear
	bzero(a, 16);
	bzero(b, 16);
	bzero(c, 16);
	bzero(d, 16);
	bzero(e, 16);
	//make strings from floats
	ftoa(a, best_params[0]);
	ftoa(b, best_params[1]);
	ftoa(c, best_params[2]);
	ftoa(d, best_params[3]);
	ftoa(e, best_params[4]);
	//write strings to console
	write(uartFile, "A = ", 4);
	write(uartFile, reinterpret_cast<const char*>(a), 16);
	write(uartFile, ", B = ", 6);
	write(uartFile, reinterpret_cast<const char*>(b), 16);
	write(uartFile, ", C = ", 6);
	write(uartFile, reinterpret_cast<const char*>(c), 16);
	write(uartFile, ", D = ", 6);
	write(uartFile, reinterpret_cast<const char*>(d), 16);
	write(uartFile, ", E = ", 6);
	write(uartFile, reinterpret_cast<const char*>(e), 16);
	write(uartFile, "\n", 1);
}


//main function - start of program
int main(int argc, char** argv)
{
	//inicialization of necessary variables
	stop = false;
	bzero(best_params, 5*sizeof(float));
    uint32_t len;
	//open console file
	uartFile = open("DEV:uart/0", NFile_Open_Mode::Read_Write);
	
	//irq enable
	TUART_IOCtl_Params params;
    params.interruptType = NUART_Interrupt_Type::RX;
    ioctl(uartFile, NIOCtl_Operation::Enable_Event_Detection, &params);

	//open random file
	rnd = open("DEV:trng", NFile_Open_Mode::Read_Only);
	val_counter = 0;

	//write out start info
	const char* start_text = "CalcOS v1.1\nAutor: Jakub Schenk (A21N0069P)\nZadejte nejprve casovy rozestup a predikcni okenko v minutach\nDale podporovane prikazy: stop, parameters\n";
	write(uartFile, start_text, 152);
    float next_y;

	//read first two params - delta and prediction
	read_param();

	//start 2nd part of program - counting based on incomming values
	const char* print_out = "Zadejte prosim \"stop\", \"parameters\" nebo desetinne cislo.\n";
    write(uartFile, print_out, 58);

	while (true) {
		//read new value
		uint32_t in = read_input();
		//new value is in values[val_counter-1], in=was it success?

		if (in == 1)	//stop
			break;
		else if (in == 2){	//parameters
			printParam();		
		}
		else if (in == 3) {	//unknown string
			const char* print_out = "Zadejte prosim \"stop\", \"parameters\" nebo desetinne cislo.\n";
			write(uartFile, print_out, 58);
			continue;
		}
		else {	//number came -> we can try to count predicted y
			next_y = count();
			
			//so that was counted -> next y (predicted)
			char* next_yChar;
			ftoa(next_yChar, next_y);

			//write what was predicted
			write(uartFile, "Predicted Y in the future is: ", 30);
			write(uartFile, next_yChar, 8);
            write(uartFile, "\n", 1);

			//print actual parameters
			printParam();
			write(uartFile, "-------------------------------\n", 32);			
		}
		//if stop was called, exit program
		if(stop){
			write(uartFile, "Program exit with status 1 - stopped with \"stop\".\n", 50);
			return 1;
		}
	}
}	

