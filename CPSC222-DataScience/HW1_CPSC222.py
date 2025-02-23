##############################################
# Programmer: Fady Youssef
# Class: CPSC, Fall 2024
# Data Homework #1
# 9/9/24
# I attempted the bonus...[line 52-56]
#
# Description: This program computes, common statistics on a list of numbers being average, median, min, max, and count.
# along with allowing the user to replace a value at a correct given index.
##############################################

nums = [ 2.4, 0.9, 14.1, 0.1, 11.8, 18.4, 7.3, 11.2, 4.3, 0.7, 1.8, 1.0,
11.8, 5.1]
ogNums = nums.copy()
## Task 1
nums.sort(reverse=True)
print(nums)

## Task 2
## count the numbers
count = 0
for i in nums:
    count += 1
print("Count of numbers: ", count)

## average of the numbers
## print(sum(nums)/len(nums))
print("Average of num: ", sum(nums)/count)
## median of the numbers
print("Median num: ", nums[count//2])
## smallest number
print("Min Num: ", min(nums))
## largest number
print("Max Num: ", max(nums))

## Task 3
## Prompt the user to enter in an index in the list and a new value. Replace the value
value = float(input("Enter a value: "))
index = int(input("Enter an index: "))
nums[index] = value
print(nums)

## Bonus Task
## Print out the original list in reverse all on one line, numbers separated by ~
for i in range(len(ogNums)):
    print(ogNums[-1 - i], end="~")
# I attempted the bonus and I was struggling at first, then remembered in class someone telling me
# that in word[-1] it is a good way to start at the end of the list. My first instinct was to start
# at the end, and find a loop to compare numbers, but I realized this is to reverse the list, not sort.
# knowing I am making an iterative loop, I realize a clever way to use the iteration of i on the end of the
# list being -1 which worked when I tested it. then looked back at class resources to see I need the end"~" to finish.