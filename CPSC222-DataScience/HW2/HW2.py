##############################################
# Programmer: Fady Youssef
# Class: CPSC, Fall 2024
# Data Homework #2
# 9/24/24
#############################################
import sys
import utils

def main():
    filename = sys.argv[1]
    headers, data = utils.read_data(filename)

    utils.display_table(headers, data)

    col_name = input("\nEnter the column name to compute stats for: ")

    if col_name not in headers:
        print("Column not found!")
        sys.exit(1)

    # Step 4: Get the selected column's data
    column = utils.get_column(headers, col_name, data)

    # Step 5: Display the stats
    print("\nStatistics for column:", col_name)
    print("Count:", len(column))
    print("Mean:", utils.mean(column))
    print("Standard Deviation:", utils.standard_deviation(column))

    # Min, Max, and Median
    print("Min:", utils.find_min(column))
    print("Max:", utils.find_max(column))
    print("Median:", utils.find_median(column))

if __name__ == "__main__":
    main()




    ##utils.display_table(headers, data)
