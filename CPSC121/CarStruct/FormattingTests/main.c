#include <stdio.h>
#include <stdlib.h>

int main()
{
    double a = 12.95,
           b = 1.5,
           c =3;

    printf("%s", " | ");
    printf("%-10.2f", a);
    printf("%s", " | ");
    printf("%-10.2f", b);
    printf("%s", " | ");
    printf("%-10.2f\n", c);
    printf("%s", " | ");
    printf("%-10.2f", a);
    printf("%s", " | ");
    printf("%-10.2f", b);
    printf("%s", " | ");
    printf("%-10.2f\n", c);
    printf("%s", " | ");
    printf("%-10.2f", a/2);
    printf("%s", " | ");
    printf("%-10.2f", b/2);
    printf("%s", " | ");
    printf("%-10.2f\n", c/2);

}
