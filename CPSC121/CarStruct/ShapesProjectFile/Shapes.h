#ifndef SHAPES_INCLUDED
#define SHAPES_INCLUDED
#define PI 3.14159

typedef struct box
{
    int width;
    int length;
    int height;
}box;

typedef struct cylinder
{
    int height;
    int radius;
}cylinder;

double getBoxVolume(box b);
double getCylVolume(cylinder c);

#endif // SHAPES_INCLUDED
