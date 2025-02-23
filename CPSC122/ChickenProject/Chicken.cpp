#include "Chicken.h"
#include <string>
#include <stdexcept>

using namespace std;

Chicken::Chicken()
{
}

Chicken::Chicken(std::string plant, double weight, int date)
{
	setPlant(plant);
	setWeight(weight);
	setDate(date);
}

std::string Chicken::getPlant() const
{
	return plant;
}

void Chicken::setPlant(std::string plant)
{
	Chicken::plant = plant;
}

double Chicken::getWeight() const
{
	return weight;
}

void Chicken::setWeight(double weight)
{
	if (weight > 1 && weight < 25)
		Chicken::weight = weight;
	else
		throw out_of_range("weight must be between 1 and 25 lbs.");
}

int Chicken::getDate() const
{
	return date;
}

void Chicken::setDate(int date)
{
	if (date > 10000000 && date < 100000000)
		Chicken::date = date;
	else
		Chicken::date = 0;
}

string Chicken::toString()
{
	string str = to_string(weight) + " lb chicken processed at "
		+ plant + " on " + to_string(date);
	return str;
}
