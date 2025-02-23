#ifndef _STACK_
#define _STACK_

#include <stdbool.h>

typedef struct Stack
{
	int* arr;
	int nextIndex;
	int capacity;
} Stack;

Stack* initializeStack();
void deleteStack(Stack* s);
void push(Stack* s, int value);
int pop(Stack* s);
int peek(Stack* s);
bool isEmpty(Stack* s);

#endif