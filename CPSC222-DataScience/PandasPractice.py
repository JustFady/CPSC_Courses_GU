### CPSC 222 - 10/3/24

import pandas as pd


# # Read the calories.csv file into a DataFrame, setting 'Food' as the index
food_df = pd.read_csv("calories.csv")

# Slice the pizza row into its own series using label-based indexing:
pizza_ser = food_df.loc["pizza"]
print(pizza_ser)
# See that original dataframe is unchanged
print(food_df)

# # Slice the pizza row into its own series using numerical indexing:
pizza_ser = food_df.iloc[0]
print(pizza_ser)

# # Slice the Protein column into its own series using label-based indexing:
protein_ser = food_df["Protein"]
print(protein_ser)

# # Slice the Protein column into its own series using numerical indexing:
protein_ser = food_df.iloc[:, 2]  # all the rows, only column 2
print(protein_ser)

# # Slice out the following 'square' from the dataframe:
# # Rows cake and popcorn, columns Carbs and Protein
sliced_df = food_df["cake":"popcorn"]
print(sliced_df)
sliced_df = sliced_df.loc[:, "Carbs":"Protein"]  # all the rows but only given cols
print(sliced_df)
print(type(sliced_df))

## TASK 1:
# Slice the popcorn row into its own series with label-based indexing:
rPop = food_df.loc["Popcorn":]
print(rPop)

# Slice the Calories column into its own series with numerical indexing:
nrPop = food_df.iloc[:,0]
print(nrPop)

# Slice the Calories and Carbs columns into a dataframe
ccPop = food_df.loc[:, "Calories":"Carbs"]
print(ccPop)

# Slice the square consisting of columns Calories and Carbs, rows pizza and cake
myDF = food_df["Pizza":"cake"]
myDF = myDF.loc[:, "Calories":"Carbs"]
print(myDF)

# # Compute the mean of the calories column
# #     First slice the column into a series
cal_ser = food_df["Calories"]
print(cal_ser)
# #     Then compute the mean of the series
mean_cals = cal_ser.mean()
print(round(mean_cals, 2))

## TASK 2:
# Compute the mean calories, mean carbs, and mean protein and save those
#   three values in a Series called mean_ser

mean_ser= pd.Series(index = ['calories','carbs','protein'])
mean_ser.name = "Means"

for i in range(3):
    col_ser = food_df.iloc[:, i]
    col_mean = col_ser.mean()
    mean_ser.iloc[i] = col_mean

    print(mean_ser)


# Write your mean_ser to a csv file
mean_ser.to_csv("mean_ser.csv")


## TASK 3:
# Read the fat.csv file into a DataFrame called fat_df, setting 'Food' as the index
fat_df = pd.read("fat.csv")


# # This is a function that accepts two DataFrames and the column name to
# #     use for merging them in an outer join, then returns
# #     the merged DataFrame
def merge_DataFrames(df1, df2, join_col):
    merged_df = df1.merge(df2, on = join_col, how = "outer")
    return merged_df

# # Call the mergeDataFrames() function to merge food_df and fat_df on 'Food'
newDF = merge_DataFrames(food_df,fat_df, "Food")
print(newDF)

# # SPLIT-APPLY-COMBINE Example

# Read the csv file sales.csv into a DataFrame called sales_df,
#    setting 'Volunteer' as the index
sales_df = pd.read("sales.csv")
sales_df = sales_df.set_index('Volunteer')
print(sales_df)



# Use the split-apply-combine method to split the sales_df by volunteer,
#    then compute the total (sum) of the pizza sales by volunteer,
#    then combine the totals in a series named total_pizza_sales_ser
#    that has the employee names as the labels
grouped_by_volunteer = sales_df.groupby("Volunteer")
print(grouped_by_volunteer.groups.keys())

# Make an empty series to hold the total for each volunteer
total_pizza_sales_ser = pd.Series()
total_pizza_sales_ser.name = "Pizza Totals"
# Loop through the groups in grouped_by_volunteer

    # For each group, grab the pizza column and make a Series


    # Find the sum for the pizza_ser

    # Append this volunteer_total to the total_pizza_sales_ser

for groups_name, group_df in grouped_by_volunteer
pizza_ser = group_df.loc[:, 'Pizza']
volunteer_total = pizza_ser.sum()
total_pizza_sales_ser[groups_name] = volunteer_total
print(total_pizza_sales_ser)



# # Write your total sales series to a csv file
total_pizza_sales_ser.to_csv("Pizza_totals.csv")