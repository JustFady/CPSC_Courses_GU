#include <iostream>
#include <string>
#include "FoodItem.h"
#include "PerishableItem.h"
using namespace std; 

int main()
{
	FoodItem sauce ("12 oz. can of tomato sauce", 24);
	PerishableItem bread("Loaf of sourdough bread", 12, 20200305);

	cout << sauce << endl;
	cout << bread << endl; 
}