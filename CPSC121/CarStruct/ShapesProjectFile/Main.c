#include <stdio.h>
#include <stdlib.h>
#include "shapes.h"

int main()
{
    box box1 = {12,16,6};
    cylinder cyl1 = {36, 3};
    printf("The Box Volume = %.2lf\n", getBoxVolume(box1));
    printf("The Cylinder Volume = %.2lf\n", getCylVolume(cyl1));
    return 0;
}
