#pragma warning(disable : 4996)
#include <stdio.h>

int main()
{
	printf("%s", "How many elements do you want to save: ");
	int count;
	scanf("%i", &count);
	int* arr = calloc(count, sizeof(int));
	for (int i = 0; i < count; i++)
	{
		arr[i] = 10 * i;
	}
	for (int i = 0; i < count; i++)
	{
		printf("%i ", arr[i]);
	}
	realloc(arr, count * sizeof(int) * 2);
	for (int i = 0; i < count; i++)
	{
		printf("%i ", arr[i]);
	}
	arr[count] = 85;
	for (int i = 0; i <= count; i++)
	{
		printf("%i ", arr[i]);
	}
	free(arr);
	return 0;

}