/******************************************************************************
 * Project: Lab 3
 * File: EndlessList.h
 * Authors: Max Brandt, Tony Le, Fady Youssef
 * Date: 5/12/2021 (last modified)
 * Description: This header file describes the functions used to 
				move around the cursor in the node
 ******************************************************************************/
#ifndef _ENDLESS_LIST_
#define _ENDLESS_LIST_

#include <iostream>
#include <stdexcept>
#include <vector>

template<class T>
class EndlessList
{
private:
//data members
	std::vector<T> data;
	int cursor = -1;
public:
	/*************************************
	* Function: addNext(T value)
	* Description: adds a value infornt of cursor and pushes cursor to it
	* Input: currentValue
	* Output: removedValue
	**************************************/
	void addNext(T value)
	{
		cursor++;
		data.insert(data.begin() + cursor, value);
	}
	/*************************************
	* Function: remove
	* Description: removes the current value and pushes cursor to next node
	* Input: none
	* Output: removedValue
	**************************************/
	T remove()
	{
		//checks for empty list
		if (isEmpty())
		{
			throw std::invalid_argument("Please add values in list");
		}
		else
		{
			T removedValue = data.at(cursor);
			//erases
			data.erase(data.begin() + cursor);
			//sets cursor
			int size = data.size(); 
			if (size > 0)
			{
				cursor = (cursor - 1 + size) % size;
			}
			//if cursor is equal to the size of the list, it'll set it to -1 
			if (cursor == data.size())
			{
				cursor = -1;
				return removedValue;
			}
			//increments cursor forward one 
			cursor++; 
			//sends cursor back to 0 if it is at the end of vector.
			if (cursor == data.size())
				cursor = 0; 
			return removedValue;
		}
	}
/*************************************
* Function: getValue()
* Description: returns the current value
* Output: currentValue
**************************************/
	T getValue()
	{
		T currentValue;
		if (isEmpty())
		{
			throw std::invalid_argument("Please add values in list");
		}
		if (cursor < data.size())
			return data.at(cursor);
		else
		{
			cursor = 0;
			return data.at(cursor);
		}
	}
/*************************************
* Function: setValue(value)
* Description: changes the current value and returns the replaced value
* Input: replacedValue
**************************************/
	T setValue(T value)
	{
		if (data.empty())
			throw std::invalid_argument("Exception Thrown: Empty List.");
		else
		{
			//gets original one that was in the index
			T temp = data.at(cursor);
			//replaces the old one with new value
			data.at(cursor) = value;
			//returns old value
			return temp;
		}
	}
/*************************************
* Function: getNext()
* Description: moves the cursor forward one by one returns the next value
* Output: nextValue
**************************************/
	T getNext()
	{
		if (data.empty())
			throw std::invalid_argument("Exception Thrown: Empty List.");
		else
		{
			//increments 
			cursor++;
			//if it's already at the end of the vector, it'll just go to the first index, which is 0. 
			if (cursor == data.size())
				cursor = 0;
			return data.at(cursor);
		}
	}
/*************************************
* Function: moveToNext(value)
* Description: moves the cursor forward until it finds the value
* Output: true or false
**************************************/
	bool moveToNext(T value)
	{
		//Starting point for cursor
		int temp = cursor;
		//checks for empty list, if empty is returns false.
		if (data.empty())
			return false;
		while (!(data.empty()))
		{
			//increments
			cursor++;
			//once it gets to end of vector, it resets to 0 to continue incrementing from 0
			if (cursor == data.size())
				cursor = 0;
			//Once if gets back to starting point and if it does not find the value in vector, it'll return false.
			if (cursor == temp)
				return false;
			//returns true if value at cursor is equal to value
			if (data.at(cursor) == value)
				return true;
		}
	}
/*************************************
* Function: isEmpty()
* Description: checks whether values are in list or not
* Output: true or false
**************************************/
	bool isEmpty()
	{
		return data.empty();
	}
};

#endif