### Day 2 ###
 
import math         # math.pow for raising a number to a power; math.pi for the number pi
import random       # for generating random numbers

# This is a one line comment
# A comment is used to document your code
# Comments are ignored by python

"""
This is
a multi
line comment,
AKA block comment
"""

### Topics demonstrated in this file:

# 1. Math operators
# 2. Getting input from the user
# 3. Formatting decimal numbers
# 4. Conditionals
# 5. Loops
# 6. Functions
# 7. Random numbers



######################
# # MATH OPERATORS # #
######################

# +, - are addition and subtraction
# * is multiplication
print(4 * 5)
# / is floating point division (like "normal" division)
print(5 / 2)
# // is integer division (the whole number 
# part of floating point division)
print(5 // 2)
# % is the modulus operator (it is the remainder
# of integer division, as in the remainder of long division)
print(5 % 2)
# ** is the exponentiation operator (power)
print(5 ** 2)

### Task 1: TRY THESE (anticipate the result before running):
# print(3.0 % 1)
# print(3 / 0)
# print(2 ** 4 ** (2 / 4))

# # We can also do exponentiation with the pow() function
# # We need to import the math module
# # A module is just a python file
# print(math.pow(5, 2))

# # Shorthand assignment operators:

# x = 0
# x += 3   # x = x + 3
# print(x)
# x -= 1   # x = x - 1
# print(x)
# x *= 5   # x = x * 5
# print(x)


###################################
# # GETTING INPUT FROM THE USER # #
###################################

# print("Enter your favorite number: ")
# fav_num = input()
# print(fav_num)

# # OR
# fav_num = input("Enter your favorite number: ")
# print(fav_num)

# print("Your favorite number doubled is:", 2 * fav_num)
# # What happened here??
# print(type(fav_num))

# # We often need to convert between types
# # Type conversion:
# int()  converts a string to an int
# fav_num_int = int(fav_num)  
# # float() converts a string to a float

# print("Your favorite number doubled is:", 2 * fav_num_int)

##########################
# # DECIMAL FORMATTING # #
##########################

# # There are LOTS of ways to do this!!

# print(math.pi)
# print("%.2f" %(math.pi))
# print("{:.2f}".format(math.pi))
# print(f"{math.pi:.2f}")
# print(round(math.pi, 2))


# # Numerical formatting embedded within a print statement using placeholders
radius = 2.0
height = 3.5
volume = 1 / 3 * 3.14 * radius ** 2 * height
# print( "The volume of a cone with radius %.2f and height %.2f is %.2f" %(radius, height, volume))
# # Note that order matters!

# # Other types of embedded formatting:

# # Use %d for integer placeholders
# print("The radius is %d" %radius)

# # Use %s for string placeholders
# userName = input("Enter your name: ")
# print("Nice to meet you, %s" %userName)

####################
# # CONDITIONALS # #
####################

# # if some condition (boolean condition) is true
# #     then execute some code
'''
x = 7
if x == 5: # == is the equality operator
    print("hello")
    # python uses indentation (1 tab = 4 spaces)
    # to group code together into "blocks"
    # like { } in C/C++
'''
# # We also have an 'else' keyword
# # else executes when preceding if condition is false
'''
if x == 5:
    print("x is 5")
else:
    print("x is not 5")
'''
# # We also have an 'elif' (else if) keyword
# # Use elif when you want to test multiple conditions in a row
'''
x = -2
if x < 0:
    print("x is negative")
elif x > 0:
    print("x is positive")
else:
    print("x is 0")
'''
# # You can nest if statements (put an if inside another if)
# # Be aware of indentation

#############
# # LOOPS # #
#############

# # for loops and while loops

# # Here is the 'for loop' structure
# # for item in sequence:
# #    body of for loop (code you want repeated)
'''
for item in [3, 5, 7, "hello"]:
    print(item)
'''
'''
for letter in "slalom":
    print(letter)
'''
# # We can also make our own sequences using range()
# # range(stop) has a default start of 0, i.e. [0, stop)
'''
for i in range(9):
    print(i, end = " ") # what is the effect of end = " "?
print()   # Notice print() function prints a newline by default
'''

# # Another option to add a newline to a print statement
# print("Why hello there\n")
# print("Why hello there\n\n\n\n")

# # range(start, stop) # [start, stop)
'''
for i in range(4, 9):
    print(i, end = " ")
print()
'''
# # range(start, stop, step) # [start, stop) up by step
'''
for i in range(4, 9, 2):
    print(i, end = " ")
print()
'''
### Task 2: How could we write a for loop to print: 8 6 4 ?


### Task 3: Write a for loop to print the first 20 even numbers
# 2, 4, ..., 38, 40


# # Like if statements, you can nest loops
# # We can get an early exit from a loop with the 'break' keyword

# # while loop structure
# # while *condition* is true:
# #    body of loop (code to be repeated)
# #    progress towards the *condition* being false
'''
while True:
    user_input = input("Enter a word (stop to exit): ")
    if user_input == "stop":
        break # early exit
'''
### Task 4: rewrite the Task 3 code to use a while loop instead of a for loop

#################
# # FUNCTIONS # #
#################

# # We have been using built-in functions: 
# # math.pow(), print(), int(), range(), input()
# # Now it is time to write our own

# # Function definition structure
# # def function_name(parameter list):
# #    function body (statements to be executed when function called)

# # Function example 1: no parameters, nothing returned

# # Define the function:
def say_hello():
    print("hello")

# # Call the function:
# say_hello()

# # Call the function within a loop:
'''
for i in range(10):
    say_hello()
'''

# # Function example 2: one parameter, nothing returned
# # Define the function:
def say(message):
    print("message:", message)
# # Call the function:
# say("ice cream") 
# # "ice cream" is the argument
# # message is the parameter

### Task 5: Define and call a function that accepts the radius of a circle
### and prints the circle's area


# # Function example 3: one parameter and returns a value
# # Let's change the circle area function to RETURN the area instead of printing it


# # Function example 4: two parameters and returns a value
def concatStrings(string1, string2):
    return string1 + string2

newString = concatStrings("ice", "cream")
# print(newString)

# # But be aware of python's dynamic typing!!!
newValue = concatStrings(4, 5)
# print(newValue)

######################
# # RANDOM NUMBERS # #
######################

# # Often we need random numbers for simulating random events
# # or initializing the state of an algorithm
# # We need to import the random module

# # Let's roll a 6 sided die
# roll = random.randrange(1, 7) # [1, 7)
# print("roll:", roll)

# # If you want the same random numbers each time you run
# # your program, "seed" the random number generator with a static value
'''
random.seed(0)
roll = random.randrange(1, 7) # [1, 7) randrange excludes last item
print("roll:", roll)
'''
# roll = random.randint(1, 7) # [1, 7]  randint includes last item
# print("roll:", roll)