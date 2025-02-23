#include <stdio.h>
#include <stdlib.h>
#include "Cars.h"
#define FILENAME "cars.txt"

void saveCars(Car cars[], int size);

int main()
{
    Car fleet[] = {
        {"Ford", "Focus", 2010, 12345.4, 456.5},
        {"Toyota", "Tundra", 2017, 4322.1, 321.1},
        {"Nissan",  "Rogue", 2009, 45678.9, 654.3}

    };
    printf("MPG should be 13.46\n");
    printf("MPG = %.2f\n", calcMpg(fleet[1]));
    printf("Average miles driven should be 20782.13\n");
    printf("Average miles driven = %.2f\n", calcAvgMiles(fleet, 3));

    return 0;
}

void saveCars(Car cars[], int size)
{
    FILE* fh = fopen(FILENAME, "w");
    if(fh == NULL)
        printf("%s", "Cannot open file for writing.");
    else
    {
        for (int i = 0; i < size; i++)
        {
            fprintf(fh, "%s\n", cars[i].make);
            fprintf(fh, "%s\n", cars[i].model);
            fprintf(fh, "%d\n", cars[i].year);
            fprintf(fh, "%f\n", cars[i].milesDriven);
            fprintf(fh, "%f\n", cars[i].gasConsumed);
        }
        fclose(fh);
    }
}
