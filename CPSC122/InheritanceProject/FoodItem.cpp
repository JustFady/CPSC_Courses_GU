
#include <stdexcept>
#include <string>
#include "FoodItem.h"

ostream& operator<<(ostream& output, const FoodItem& item)
{
	output << item.getQuantity() << " - " << item.getType(); 
	return output; 
}

FoodItem::FoodItem()
{
	type = "";
	quantity = 0;
}

FoodItem::FoodItem(string type, int quantity)
{
	setType(type);
	setQuantity(quantity);
}

string FoodItem::getType() const
{
	return type;
}

int FoodItem::getQuantity() const
{
	return quantity;
}

void FoodItem::setType(string type)
{
	this->type = type;
}

void FoodItem::setQuantity(int quantity)
{
	if (quantity < 0)
	{
		throw out_of_range("Quantity cannot be negative");
	}

	this->quantity = quantity;
}
