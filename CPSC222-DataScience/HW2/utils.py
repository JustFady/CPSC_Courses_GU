##############################################
# Programmer: Fady Youssef
# Class: CPSC, Fall 2024
# Data Homework #2
# 9/24/24
#############################################
import math
import sys
import csv 

def read_data(filename):
    data = []
    with open(filename, 'r') as file:
        lines = file.readlines()

    headers = lines[0].strip().split(',')
    for line in lines:
        data.append(line.strip().split(','))

    return headers, data

def display_table(headers, data):
    # Print the headers
    print("\t".join(headers))
    
    for row in data:
        print("\t".join(row))

def get_column(headers, col_name, data):
    col_index = headers.index(col_name)  
    column = []
    
    for row in data:
        value = row[col_index].strip() 
        if value.replace('.', '', 1).isdigit() and value != '':  # Check if the value is numeric and not empty
            column.append(float(value))  # Convert to float and add to the column list
    return column


def mean(column):
    total = 0
    for value in column:
        total += value
    return total / len(column)

def standard_deviation(column):
    avg = mean(column)
    variance_sum = 0
    
    for value in column:
        variance_sum += (value - avg) ** 2
    
    variance = variance_sum / len(column)
    return math.sqrt(variance)

def find_min(column):
    min_val = column[0]
    for value in column:
        if value < min_val:
            min_val = value
    return min_val

def find_max(column):
    max_val = column[0]
    for value in column:
        if value > max_val:
            max_val = value
    return max_val

def find_median(column):
    n = len(column)
    
    # https://www.codecademy.com/forum_questions/55b9e703d3292f5068000459
    for i in range(n - 1):
        for j in range(i + 1, n):
            if column[i] > column[j]:
                column[i], column[j] = column[j], column[i]  # Swap the values
    
    # Calculate the median
    if n % 2 == 0:
        median_val = (column[n//2 - 1] + column[n//2]) / 2
    else:
        median_val = column[n//2]
    
    return median_val
