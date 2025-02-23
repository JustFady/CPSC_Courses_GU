#include "Stack.h"
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

Stack* initializeStack()
{
	Stack* s = malloc(sizeof(Stack));
	s->capacity = 10;
	s->nextIndex = 0;
	s->arr = malloc(s->capacity, sizeof(int));
	return s;
}

void deleteStack(Stack* s)
{
	if (s != NULL)
	{
		free(s->arr);
		free(s);
	}
}
void push(Stack* s, int value)
{
	if (s->nextIndex == s->capacity)
	{
		s->capacity *= 2;
		realloc(s->arr, s->capacity * sizeof(int));
	}
	s->arr[s->nextIndex] = value;
	s->nextIndex++;
}
int pop(Stack* s)
{
	assert(s != NULL, "The stack cannot be NULL.");
	assert(s->nextIndex != 0, "The stack is empty.");
	s->nextIndex--;
	return s->arr[s->nextIndex];
}
int peek(Stack* s)
{
	return s->arr[s->nextIndex - 1];
}

bool isEmpty(Stack* s)
{
	return s->nextIndex == 0;
}
