#ifndef _FOOD_ITEM_
#define _FOOD_ITEM_

#include <stdexcept>
#include <string>
#include <iostream>

using namespace std; 

class FoodItem
{
	friend ostream& operator<<(ostream& output, const FoodItem& item);
private:
	string type;
protected:
	int quantity; 
public: 
	FoodItem();
	FoodItem(string type, int quantity);
	string getType() const;
	int getQuantity() const;
	void setType(string type);
	void setQuantity(int quantity);

};


#endif