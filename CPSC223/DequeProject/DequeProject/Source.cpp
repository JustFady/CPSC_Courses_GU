#include <iostream>
#include <string>
#include <stack>
#include <queue>
#include "PureDeque.h"

using namespace std;

int main()
{
	stack<char> charStack;
	queue<char> charQueue;
	PureDeque<char> charDeque;
	string input;
	cout << "Enter a word or phrase ";
	getline(cin, input);
	char c;
	for (int i = 0; i < input.size(); i++)
	{
		charStack.push(input[i]);
		charQueue.push(input[i]);
		c = tolower(input[i]);
		if (isalnum(c))
			charDeque.addBack(c);
		charDeque.addBack(input[i]);
		//output stack
	}while (!charStack.empty())
	{
		cout << charStack.top();
		charStack.pop();
	}
	cout << endl;
	while (!charQueue.empty())
	{
		cout << charQueue.front();
		charQueue.pop();
	}
	cout << endl;
	//palindrone tester
	char front;
	char back;
	bool isPalindrone = true;
	while (isPalindrone && !charDeque.isEmpty())
	{
		front = tolower(charDeque.removeFront());
		if (!charDeque.isEmpty())
		{
			back = tolower(charDeque.removeBack());
			if (front != back)
			{
				isPalindrone = false;
			}
		}
		cout << "This is " << (isPalindrone ? "" : "not ") << "a palindrone!" << endl;
	}
}