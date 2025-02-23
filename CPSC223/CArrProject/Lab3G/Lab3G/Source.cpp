/******************************************************************************
 * Project: Lab 3
 * File: Source.cpp
 * Authors: Max Brandt, Tony Le, Fady Youssef
 * Date: 5/12/2021 (last modified)
 * Description: Creates an endless list
 ******************************************************************************/
#include "EndlessList.h"
#include <iostream>

using namespace std;

int main()
{
	EndlessList<int> list;
	//testing with no element 
	cout << "Testing with 0 elements" << endl;
	//testing isEmpty() for empty list
	cout << "Testing isEmpty(): " << list.isEmpty() << endl;
	//testing remove() on empty list.
	try
	{
		cout << "Testing remove(): " << list.remove() << endl;
	}
	catch (invalid_argument& e)
	{
		cout << "Testing remove(): " << e.what() << endl;
	}
	//trying getValue() on empty list
	try
	{
		cout << "Testing getValue(): " << list.getValue() << endl;
	}
	catch (invalid_argument& e)
	{
		cout << "Testing getValue(): " << e.what() << endl;
	}
	//trying setValue() with empty list
	try
	{
		cout << "Testing setValue(): " << list.setValue(10) << endl;
	}
	catch (invalid_argument& e)
	{
		cout << "Testing setValue(): " << e.what() << endl;
	}
	//trying getNext() on empty list
	try
	{
		cout << "Testing getNext(): " << list.getNext() << endl;
	}
	catch (invalid_argument& e)
	{
		cout << "Testing getNext(): " << e.what() << endl;
	}
	//trying moveToNext() on empty list, should return false
	cout << "Testing moveToNext(): " << list.moveToNext(100) << endl;
	cout << "--------------------" << endl;
	//Testing with one element
	list.addNext(10);
	//testing with 1 element/ 
	cout << "Testing with 1 element: " << list.getValue() << endl;
	//trying to vfind value 10, should return false because only instance of 10 is at current cursor position
	cout << "Testing moveToNext(10): " << list.moveToNext(10) << endl;
	// trying getNext(), should return 10.
	cout << "Testing getNext(): " << list.getNext() << endl;
	//trying setValue(), replacing to 100, replaced value is 10 and 10 should be whats returned
	cout << "Testing setValue(100): " << list.setValue(100) << endl;
	//trying getValue() again to make sure it gets correct value. 
	cout << "Testing getValue(): " << list.getValue() << endl;
	//removing the one element. 
	cout << "Testing remove(): " << list.remove() << endl;
	//checking if list is empty
	cout << "Testing isEmpty(): " << list.isEmpty() << endl;
	//a try catch to try to getValue() from empty list.
	try
	{
		cout << "Testing getValue(): " << list.getValue() << endl;
	}
	catch (invalid_argument& e)
	{
		cout << "Try Catch for Exception: " << e.what() << endl;
	}
	cout << "--------------------" << endl;
	//Testing with multiple elements. 
	cout << "Testing with multiple elements: 10, 20, 30" << endl;;
	list.addNext(10);
	list.addNext(20);
	list.addNext(30);
	//cursor is currently at 30, testing getValue() to check.
	cout << "Testing getValue(): " << list.getValue() << endl;
	//testing getNext(), should return 10
	cout << "Testing getNext(): " << list.getNext() << endl;
	//Testing moveToNext(10), should return 0 for false
	cout << "Testing moveToNext(10): " << list.moveToNext(10) << endl;
	//Testing moveToNext(20), should return 1 for true
	cout << "Testing moveToNext(20): " << list.moveToNext(20) << endl;
	//Testing setValue(100), setting 20 to 100
	cout << "Testing setValue(100): " << list.setValue(100) << endl;
	//Testing getValue() should return 100.
	cout << "Testing getValue(): " << list.getValue() << endl;
	//Testing getNext() to make sure 30 is the next value
	cout << "Testing getNext(): " << list.getNext() << endl;
	//Testing remove(), 30 should be the one removed
	cout << "Testing remove(): " << list.remove() << endl;
	//Testing getValue(), since 30 was the last element, it should go back to the first element
	cout << "Testing getValue(): " << list.getValue() << endl;
	//Testing moveToNext(100), should return 1 for true
	cout << "Testing moveToNext(100): " << list.moveToNext(100) << endl;
	//Testing getValue() should return 100.
	cout << "Testing getValue(): " << list.getValue() << endl;
	//Testing isEmpty() should return false;
	cout << "Testing isEmpty(): " << list.isEmpty() << endl;
}