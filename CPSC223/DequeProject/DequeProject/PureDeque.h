#ifndef PURE_DEQUE_
#define PURE_DEQUE_
#include <iostream>
#include <deque>


template<class E>
class PureDeque
{
private: 
	std::deque<E> d;
public:
	void addBack(E e)
	{
		d.push_back(e);
	
	}

	void addFront(E e)
	{
		d.push_front(e);
	}

	E removeBack()
	{
		E data = d.back();
		d.pop_back();
		return data;
	
	}

	E removeFront()
	{
		E data = d.front();
		d.pop_front();
		return data;
	}

	bool isEmpty()
	{
		return d.empty();
	}
};



#endif