### Day 3 ###

### Topics illustrated in this file:
# # 1. 1-D Lists
# # 2. Looping through lists
# # 3. List operators
# # 3. List methods

import random

#################
# # 1-D Lists # #
#################

# # A list is a sequence of items
# # 1-D lists are like a single row or a single column in Excel
# # Declare a list using [ ] and a comma separated list of values

# list_ints = [100, 1, 10, 20]

# # Python lists are 0-indexed
# # The last element in a list with n elements is at index n - 1

# print('Element at index 0:', list_ints[0])
# print('Element at index -4:', list_ints[-3])

# # Data types can be mixed in a list
# list_numbers = [0, 0.0, 1, 1.0, -2]
# print(list_numbers)
# print(type(list_numbers))

# # Lists are MUTABLE objects (they can be changed)
# list_numbers[0] = "hello"
# print(list_numbers)

# # Use len() to find out how many elements are in a list:
# print('Length of list_numbers:', len(list_numbers))

# # Suppose we don't know at run time exactly how many elements are in the list
# # We can still print out the last element in the list:
# print('Last element:', list_numbers[len(list_numbers) - 1])

# # We can declare an empty list!
# empty_list = []
# print('Length of empty_list:', len(empty_list))

# # We can have lists of lists (use for 2D or ND)
# nested_list = [[0, 1], [2], [3], [4, 5], []]
# print('Length of nested_list:', len(nested_list))
# print('Length of first element in nested_list:', len(nested_list[0]))

#############################
# # Looping Through Lists # #
#############################

# candies = ["twix", "reeses", "oreos", "snickers"]
# print(candies)

# # List Loop Example 1:
# print('Candies loop #1')
# for candy in candies:
#     print(candy)
# print()

# # List Loop Example 2:
# print('Candies loop #2')
# i = 0
# while i < len(candies):
#     print(i, candies[i])
#     i += 1
# print()

# # List Loop Example 3:
# print('Candies loop #3')
# i = 0
# for i in range(len(candies)):
#     print(i, candies[i])
# print()

#############################
# # Common List Operators # #
#############################

# # CONCATENATION, putting two lists together
# print(candies)
# candies += ["m&ms", "starburst"]
# print(candies)

# # REPETITION, repeating elements in a list
# bag_o_candies = 5 * ["twix", "snickers"]
# print('bag_o_candies:', bag_o_candies)


# # SLICING, taking a subset of a list
# print(candies[1:3]) # ':' is the slice operator. Start index inclusive, end exclusive

# # If you ever need a copy of a list, you can simply use the ':' with no start or end indices
# copy_of_candies = candies[:]
# copy_of_candies[0] = "TWIX"
# print('copy_of_candies:', copy_of_candies)  # notice it's an actual copy, not a reference to same list
# print('candies:', candies)

# # Other ways to use slicing
# print('Start at index 2:', candies[2:])
# print('End before index 2:', candies[:2])


####################
# # List Methods # #
####################

# # <list>.REMOVE() 
# candies.remove("reeses") # Removes the FIRST occurrence of 'reeses'
# print(candies)

# # <list>.APPEND()
# cars = ["corolla", "lambourghini"]
# print(cars)
# cars.append("pilot")
# print(cars)

# # <list>.EXTEND()
# # This is like append, except it takes a list as an argument
# cars.extend(["sentra", "mercedes"])
# print(cars)


### To illustrate the difference between append and extend, TRY THIS:
# # Use the append() method with a list argument
# pets = ['turtle', 'dog']
# print(pets)
# pets.append(['cat', 'mouse'])
# print(pets)   # Notice what happened...


# # <list>.POP()
# print(cars)
# cars.pop(2)  # pop the specified index
# print(cars)

# # We can assign the element popped to a variable
# car = cars.pop()   # If no index is assigned, which element is popped?
# print('Popped element:', car)
# print(cars)

# # What's the difference between <list>.pop() and <list>.remove??
# # When you know the ___ use ___
# # When you know the ___ use ___

# # But one other 'removal' option is del
# print(pets)
# del pets[1]
# print(pets)

# # Or combine with slicing to delete multiple elements
# foods = ['pizza', 'icecream', 'salad', 'potato', 'bread']
# print(foods)
# del foods[2:]
# print(foods)

# # <list>.SORT()
# # Let's declare an empty list then populate it with random numbers

# nums = []
# for i in range(20):
#     rand_num = random.randint(1, 10)
#     nums.append(rand_num)
# print(nums)


# nums.sort() # inplace sort, increasing order by default
# print(nums)

# # To sort in reverse order:
# nums.sort(reverse=True)
# print(nums)

# # <list>.COUNT()
# letters = ['a', 'a', 'b', 'z']
# print(letters)
# print('count:', letters.count('b'))

# # Other helpful functions to try out...
# sum(nums)
# min(nums)
# max(nums)
