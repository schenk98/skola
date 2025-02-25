#pragma once

void itoa(unsigned int input, char* output, unsigned int base);
int atoi(const char* input);
float atof(const char *s);
void ftoa(char *buffer, float value);
char* strncpy(char* dest, const char *src, int num);
int strncmp(const char *s1, const char *s2, int num);
int strlen(const char* s);
void bzero(void* memory, int length);
void memcpy(const void* src, void* dst, int num);
char* strcat(char *dest, const char *src);