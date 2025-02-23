#include "LinkedList.h"
#include "Node.h"
#include <stdio.h>
#include <stdlib.h>
#include <float.h>
#include <stdbool.h>

void testEmpty();
void testAdd(LinkedList* list);

int main()
{
	// did this on purpose for future reference, 
	// want to have reference for both ways it can be initialized.
	LinkedList* list = initializeLinkedList();
	testEmpty(); 
	testAdd(list);


}

void testEmpty()
{
	LinkedList* list = initializeLinkedList();
	int size = getSize(list);
	if (size == 0)
		printf("%s", "PASS - size of empty list \n");
	else
		printf("%s", "FAIL - size of empty list \n");
	double value = get(list, 12);
	if (value == DBL_MIN)
		printf("%s", "PASS - get in empty list \n");
	else
		printf("%s", "FAIL - get in empty list \n");
	int index = find(list, 12);
	if (index == -1)
		printf("%s", "PASS - find in empty list \n");
	else
		printf("%s", "FAIL - find in empty list \n");
	bool addWorked = add(list, 0, 12);
	if (find(list, 12) == 0)
		printf("%s", "PASS - add in empty list \n");
	else
		printf("%s", "FAIL - add in empty list \n");
	 value = removeAt(list, 0);
	if (getSize(list) == 0)
		printf("%s", "PASS - removeAt with one item \n");
	else
		printf("%s", "FAIL - removeAt with one item \n");
	 value = removeAt(list, 0);
	if(value == DBL_MIN)
		printf("%s", "PASS - removeAt in empty list \n");
	else
		printf("%s", "FAIL - removeAt in empty list \n");
	deleteLinkedList(list);
}

void testAdd(LinkedList* list)
{
	for (int i = 0; i < 10; i++)
		add(list, i, i * 10);
	if (getSize(list) == 10)
		printf("%s", "PASS - size of add 10 items \n");
	else 
		printf("%s", "Fail - size of add 10 items \n");
	bool ok = true;
	for (int i = 0; i < 10; i++)
		ok = ok && (get(list, i) == i * 10);
	if(ok)
		printf("%s", "PASS - get of add 10 items \n");
	else
		printf("%s", "Fail - get of add 10 items \n");
	if(!add(list, -1, 85))
		printf("%s", "PASS -  add at low index \n");
	else
		printf("%s", "Fail -  add at low index \n");
	if (!add(list, 11, 85))
		printf("%s", "PASS -  add at high index \n");
	else
		printf("%s", "Fail -  add at high index \n");
}