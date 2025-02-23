#ifndef _LINKED_LIST_
#define _LINKED_LIST_

#include "Node.h"
#include <stdbool.h>

typedef struct LinkedList
{
	Node* front;
	Node* back;
	int count;

}LinkedList; 

LinkedList* initializeLinkedList();
void deleteLinkedList(LinkedList* list);
double get(LinkedList* list, int index);
int getSize(LinkedList* list);
int find(LinkedList* list, double value);
bool add(LinkedList* list, int index,double value);
double removeAt(LinkedList* list, int index);

#endif // !_LINKED_LIST_
