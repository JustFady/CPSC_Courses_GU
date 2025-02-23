#include <iostream>
#include <algorithm>
#include <vector>
#include <queue>

using namespace std;

int main()
{
	vector<int> list;
	priority_queue<int, vector<int>, greater<int>> q;
	int input = 0;
	while (input >= 0)
	{
		cout << "Enter a positive integer or -1 to quit: ";
		cin >> input;
		if (input >= 0)
		{
			list.push_back(input);
			q.push(input);
		}
	}
	make_heap(list.begin(), list.end());
	sort_heap(list.begin(), list.end());
	for (int i = 0; i < list.size(); i++)
	{
		cout << list.at(i) << " ";
	}
	cout << endl;
	reverse(list.begin(), list.end());
	for (int i = 0; i < list.size(); i++)
	{
		cout << list.at(i) << " ";
	}
	cout << endl;
	while (!q.empty())
	{
		cout << q.top() << " ";
		q.pop();
	}
}