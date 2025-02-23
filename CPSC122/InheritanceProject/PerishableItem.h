#ifndef _PERISHABLE_ITEM_
#define _PERISHABLE_ITEM_

#include <string>
#include "FoodItem.h"

using namespace std; 

class PerishableItem : public FoodItem
{
	friend ostream& operator<<(ostream& output, const PerishableItem& item);

private:
	int expirationDate;
public:
	PerishableItem();
	PerishableItem(string type, int quantity, int expirationDate);
	int getExpirationDate() const;
	void setExpirationDate(int expirationDate);

};


#endif