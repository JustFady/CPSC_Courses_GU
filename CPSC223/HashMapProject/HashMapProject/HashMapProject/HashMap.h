#ifndef _HASHMAP_
#define _HASHMAP_
#include <stdbool.h>

typedef struct Node
{
    char key[100];
    double value;
    struct Node* next;
} Node;

typedef struct HashMap
{
    Node** nodes;
    int capacity;
    int count;
} HashMap;

HashMap* initializeHashMap();
void deleteHashMap(HashMap* map);
bool contains(HashMap* map, char key[]);
void insert(HashMap* map, char key[], double value);
double get(HashMap* map, char key[]);
bool delete(HashMap* map, char key[]);
double getLoadFactor(HashMap* map);
bool isPrime(int num);

#endif