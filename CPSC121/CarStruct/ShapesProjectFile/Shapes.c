#include "Shapes.h"

double getBoxVolume(box b)
{
    return b.height * b.length * b.width;
}
double getCylVolume(cylinder c)
{
    return PI * c.radius * c.radius * c.height;
}
