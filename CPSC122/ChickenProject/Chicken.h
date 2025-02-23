#ifndef _CHICKEN_
#define _CHICKEN_

#include <string>

class Chicken
{
private:
	std::string plant;
	double weight;
	int date;
public:
	Chicken();
	Chicken(std::string plant, double weight, int date);
	std::string getPlant() const;
	void setPlant(std::string plant);
	double getWeight() const;
	void setWeight(double weight);
	int getDate() const;
	void setDate(int date);
	std::string toString();
};

#endif
