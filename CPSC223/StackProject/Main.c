#include <stdio.h>
#include "Stack.h"
#include <stdlib.h>

int main()
{
	Stack* myStack = initializeStack();
	push(myStack, 85);
	push(myStack, 123);
	push(myStack, 987);
	printf("The top value = %i\n", peek(myStack));
	while (!isEmpty(myStack))
	{
		printf("%i, ", pop(myStack));
	}
	printf("\n");
	deleteStack(myStack);
	return 0;
}