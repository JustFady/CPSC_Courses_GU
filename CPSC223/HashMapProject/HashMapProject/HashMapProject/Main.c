#pragma warning(disable : 4996)
#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include "HashMap.h"

void printOut(HashMap* map);

int main()
{
    HashMap* map = initializeHashMap();
    for (int i = 0; i < 1000; i++)
    {
        char cityName[100] = "City";
        char num[5];
        itoa(i, num, 10);
        strcat(cityName, num);
        insert(map, cityName, i * 100);
    }
    printf("Size = %i\n", map->count);
    printf("Capacity = %i\n", map->capacity);
    printf("%s = %.0f\n", "City85", get(map, "City85"));
    printOut(map);
    deleteHashMap(map);
    //end
    getchar();
}

void printOut(HashMap* map)
{
    for (int i = 0; i < map->capacity; i++)
    {
        if (map->nodes[i] != NULL)
        {
            Node* curr = map->nodes[i];
            while (curr != NULL)
            {
                printf("%s = %.0f; ", curr->key, curr->value);
                curr = curr->next;
            }
            printf("\n");
        }
        else
        {
            printf("%s\n", "NULL");
        }
    }
}
