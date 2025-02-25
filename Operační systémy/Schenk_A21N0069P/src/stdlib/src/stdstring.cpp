#include <stdstring.h>

#define digit_range(c) (c >= '0' && c <= '9')

namespace
{
    const char CharConvArr[] = "0123456789ABCDEF";
}

void itoa(unsigned int input, char* output, unsigned int base)
{
	int i = 0;

	while (input > 0)
	{
		output[i] = CharConvArr[input % base];
		input /= base;
		i++;
	}

    if (i == 0)
    {
        output[i] = CharConvArr[0];
        i++;
    }

	output[i] = '\0';
	i--;

	for (int j = 0; j <= i/2; j++)
	{
		char c = output[i - j];
		output[i - j] = output[j];
		output[j] = c;
	}
}

int atoi(const char* input)
{
	int output = 0;

	while (*input != '\0')
	{
		output *= 10;
		if (*input > '9' || *input < '0')
			break;

		output += *input - '0';

		input++;
	}

	return output;
}


int normalize(float *val) {
    int exponent = 0;
    float value = *val;

    while (value >= 1.0) {
        value = value / 10.0;
        ++exponent;
    }

    while (value < 0.1) {
        value = value * 10.0;
        --exponent;
    }
    *val = value;
    return exponent;
}

float atof(const char *s)
{
  float a = 0.0;
  int e = 0;
  int c;
  while ((c = *s++) != '\0' && digit_range(c)) {
    a = a*10.0 + (c - '0');
  }
  if (c == '.') {
    while ((c = *s++) != '\0' && digit_range(c)) {
      a = a*10.0 + (c - '0');
      e = e-1;
    }
  }
  if (c == 'e' || c == 'E') {
    int sign = 1;
    int i = 0;
    c = *s++;
    if (c == '+')
      c = *s++;
    else if (c == '-') {
      c = *s++;
      sign = -1;
    }
    while (digit_range(c)) {
      i = i*10 + (c - '0');
      c = *s++;
    }
    e += i*sign;
  }
  while (e > 0) {
    a *= 10.0;
    e--;
  }
  while (e < 0) {
    a *= 0.1;
    e++;
  }
  return a;
}

void ftoa(char *buffer, float value) {  
    int exponent = 0;
    int places = 0;
    const int width = 6;

    if (value == 0.0) {
        buffer[0] = '0';
        buffer[1] = '\0';
        return;
    } 

    if (value < 0.0) {
        *buffer++ = '-';
        value = -value;
    }

    exponent = normalize(&value);

    while (exponent > 0) {
        int digit = value * 10;
        *buffer++ = digit + '0';
        value = value * 10 - digit;
        ++places;
        --exponent;
    }

    if (places == 0)
        *buffer++ = '0';

    *buffer++ = '.';

    while (exponent < 0 && places < width) {
        *buffer++ = '0';
        --exponent;
        ++places;
    }

    while (places < width) {
        int digit = value * 10.0;
        *buffer++ = digit + '0';
        value = value * 10.0 - digit;
        ++places;
    }
    *buffer = '\0';
}

char* strncpy(char* dest, const char *src, int num)
{
	int i;

	for (i = 0; i < num && src[i] != '\0'; i++)
		dest[i] = src[i];
	for (; i < num; i++)
		dest[i] = '\0';

   return dest;
}

char* strcat(char *dest, const char *src)
{
    int i,j;

    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
        dest[i+j] = src[j];

    dest[i+j] = '\0';
	
    return dest;
}

int strncmp(const char *s1, const char *s2, int num)
{
	unsigned char u1, u2;
  	while (num-- > 0)
    {
      	u1 = (unsigned char) *s1++;
     	u2 = (unsigned char) *s2++;
      	if (u1 != u2)
        	return u1 - u2;
      	if (u1 == '\0')
        	return 0;
    }

  	return 0;
}

int strlen(const char* s)
{
	int i = 0;

	while (s[i] != '\0')
		i++;

	return i;
}

void bzero(void* memory, int length)
{
	char* mem = reinterpret_cast<char*>(memory);

	for (int i = 0; i < length; i++)
		mem[i] = 0;
}

void memcpy(const void* src, void* dst, int num)
{
	const char* memsrc = reinterpret_cast<const char*>(src);
	char* memdst = reinterpret_cast<char*>(dst);

	for (int i = 0; i < num; i++)
		memdst[i] = memsrc[i];
}
