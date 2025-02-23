#ifndef CARS_H_INCLUDED
#define CARS_H_INCLUDED

typedef struct Car
{
    char make[15]; //brand
    char model[25];
    int year; //manufacture year
    double milesDriven; //in one year
    double gasConsumed; //in one year
}Car;


double calcMpg(Car car);
double calcAvgMiles(Car cars[], int size);

#endif // CARS_H_INCLUDED
