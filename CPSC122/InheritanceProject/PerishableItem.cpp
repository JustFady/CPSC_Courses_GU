#include "PerishableItem.h"
#include <stdexcept>
#include <string>

PerishableItem::PerishableItem()
{
	expirationDate = 0;
}

PerishableItem::PerishableItem(string type, int quantity, 
	int expirationDate) : FoodItem(type,quantity)
{
	setExpirationDate(expirationDate);
}

int PerishableItem::getExpirationDate() const
{
	return expirationDate;
}

void PerishableItem::setExpirationDate(int expirationDate)
{
	if (expirationDate < 20000000 || expirationDate > 90000000)
	{
		throw out_of_range("Date is out of range");
	}
	this->expirationDate = expirationDate;
}

ostream& operator<<(ostream& output, const PerishableItem& item)
{
	output << item.quantity << " - " << item.getType() <<
		" (" << item.getExpirationDate() << ")";
	return output;
}
