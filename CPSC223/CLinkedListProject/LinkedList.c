#include "LinkedList.h"
#include <float.h>
#include <stdbool.h>
#include <assert.h>


LinkedList* initializeLinkedList()
{
	LinkedList* list = malloc(sizeof(LinkedList));
	list->front = malloc(sizeof(Node));
	list->back = malloc(sizeof(Node));
	list->front->value = DBL_MAX;
	list->back->value = DBL_MAX;
	list->front->next = list->back;
	list->back->prev = list->front;
	list->count = 0;
	return list;
}

void deleteLinkedList(LinkedList* list)
{
	Node* current = list->front;
	for (int i = 0; i < list->count; i++)
	{
		current = current -> next;
		free(current->prev);
	}
	free(list->back);
	free(list);

}

double get(LinkedList* list, int index)
{
	if (index < 0 || index >= list->count)
		return DBL_MIN;
	Node* current = list->front;
	for (int i = 0; i <= index; i++)
	{
		current = current->next;
	}
	return current->value;
}

int size(LinkedList* list)
{
	return list->count;
}

int find(LinkedList* list, double value)
{
	Node* current = list->front;
	for (int i = 0; i < list->count; i++)
	{
		current = current->next;
		if (current->value == value)
			return i;
	}
	return -1;
}

bool add(LinkedList* list, int index, double value)
{
	if (index < 0 || index > list->count)
		return false;
	Node* newNode = malloc(sizeof(Node));
	newNode->value = value;
	Node* current = list->front;
	for (int i = 0; i <= index; i++)
	{
		current = current->next;
	}
	newNode->next = current;
	newNode->prev = current->prev;
	current->prev->next = newNode;
	current->prev = newNode;
	list->count++;                           
	return true;
}

double removeAt(LinkedList* list, int index)
{
	if (index < 0 || index >= list->count)
		return DBL_MIN;
	Node* current = list->front;
	for (int i = 0; i <= index; i++)
	{
		current = current->next;
	}
	double value = current->value;
	current->prev->next = current->next;
	current->next->prev = current->prev;
	free(current);
	list->count--;
	return value;
}

int getSize(LinkedList* list)
{
	return list->count;
}
