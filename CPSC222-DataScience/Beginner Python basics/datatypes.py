##################################################   
#   Author: Jo Crandall
#   CPSC 222 Intro to Data Science
#   Gonzaga University
#   Last edited: Aug 21, 2024
#   NOTE: This COMMENT BLOCK is an example of how you should begin every programming assignment. 
#       See CODING STANDARD: https://nbviewer.org/github/GonzagaCPSC222/DAs/blob/master/Coding%20Standard.ipynb
#   This program explores examples of variables and data types. Note that variable NAMING CONVENTIONS should be followed.
##################################################

import sys  #for the getsizeof method    (good idea to keep track of WHY you have imported a certain package)
    
### VARIABLES ###
# A variable stores a value
x = 5 # read as "x is assigned 5", "x holds 5", "x gets 5", etc.
# NOT "x equals 5"
# The value 5 is an integer (int for short)
print(x)
print( type(x) )

# we can reassign x
x = 5.5
# this is a float data type
# a number with a fractional part
print(x)
print(type(x))

# reassign x again
x = "hello"
# this is a string data type
# a sequence of characters
print(x)
print(type(x))

###Primitive data types and their sizes (on YOUR machine)
#string
myChar = 'a'
print( type(myChar) )  #notice that single letters constitute strings!
print( sys.getsizeof( myChar ) )
    
    
#integer type
myInt = 42  
#print( 'myInt is type:', type(myInt) )   # Here the print statement is more explicit. This makes output easier to read and check.
#print( 'myInt is size:', sys.getsizeof(myInt) )

###Since storage space for objects is complicated... that's all we're going to worry about it

#floating point type
myFloat = 3.14
#print( type(myFloat) ) 
    
#bool - true/false
myBool = True    #try with/without capitalized t in 'True'
#print( type(myBool) )


#naming conventions - note, Camel case and Pascal case most commonly used in code body
#camel case
myStrVariable = 'Hi there'

#Pascal case
MyIntVariable = 42

#snake case
my_str_variable = '5'

#macro case
MY_FLOAT_VARIABLE = 3.14

###Which of these did I use in my program above?
