### CPSC 222 Oct 10

# # This file demonstrates:
# 1. Declare array of json objects, interate through, access individual value
# 2. Read json data into a DataFrame with json or pandas
# 3. Parse details of json data

import pandas as pd
import json   # No install necessary, Python has this built-in

# # Declaring a string json_arr_str containing desired contents
json_arr_str = """
[
  {
    "TimestampUTC": "2020-03-24T00:27:00Z",
    "TimestampSubjectTZ": "2020-03-23T20:27:00",
    "Calories": 0.0234859050963356,
    "HR": 0.0,
    "Lux": null,
    "Steps": 0.0,
    "Wear": true,
    "x": 0,
    "y": 35,
    "z": 0,
    "AxisXCounts": 0,
    "AxisYCounts": 35,
    "AxisZCounts": 0
  },
  {
    "TimestampUTC": "2020-03-24T00:28:00Z",
    "TimestampSubjectTZ": "2020-03-23T20:28:00",
    "Calories": 0.042274629173404,
    "HR": 0.0,
    "Lux": null,
    "Steps": 0.0,
    "Wear": true,
    "x": 44,
    "y": 63,
    "z": 55,
    "AxisXCounts": 44,
    "AxisYCounts": 63,
    "AxisZCounts": 55
  },
  {
    "TimestampUTC": "2020-03-24T00:29:00Z",
    "TimestampSubjectTZ": "2020-03-23T20:29:00",
    "Calories": 0.0,
    "HR": 0.0,
    "Lux": null,
    "Steps": 0.0,
    "Wear": true,
    "x": 0,
    "y": 0,
    "z": 0,
    "AxisXCounts": 0,
    "AxisYCounts": 0,
    "AxisZCounts": 0
  },
  {
    "TimestampUTC": "2020-03-24T00:30:00Z",
    "TimestampSubjectTZ": "2020-03-23T20:30:00",
    "Calories": 0.224122637205031,
    "HR": 0.0,
    "Lux": null,
    "Steps": 0.0,
    "Wear": true,
    "x": 193,
    "y": 334,
    "z": 71,
    "AxisXCounts": 193,
    "AxisYCounts": 334,
    "AxisZCounts": 71
  },
  {
    "TimestampUTC": "2020-03-24T00:31:00Z",
    "TimestampSubjectTZ": "2020-03-23T20:31:00",
    "Calories": 0.0154335947775919,
    "HR": 0.0,
    "Lux": null,
    "Steps": 0.0,
    "Wear": true,
    "x": 30,
    "y": 23,
    "z": 0,
    "AxisXCounts": 30,
    "AxisYCounts": 23,
    "AxisZCounts": 0
  }
]
"""

# # Manually assign the above string to a list of json objects:
json_arr = json.loads(json_arr_str)   # json.loads converts a json string to a Python object
print(type(json_arr))
print(json_arr)
print()

# # Walk through the json objects in the array:
for arr_obj in json_arr:
    print(arr_obj)
    print('****')
print()

# # Walk through and access a particular key in each json object:
for arr_obj in json_arr:
    print(arr_obj['TimestampSubjectTZ'])
    print('****')
print()

# # To access a single value in the array of json objects:
print(json_arr[3]['Calories'])
print()

### Read the array of json objects directly from the json file
infile = open("actigraph_data.json", "r")
# json.load reads a file into a Python object
json_arr_2 = json.load(infile) # returns a list in this case (see file contents)
print(json_arr_2)
print(type(json_arr_2))
print()

# # The list item at index 0 is a dict
first_minute_of_data = json_arr_2[0]
print(first_minute_of_data)
print(type(first_minute_of_data))
print()

# # Use a key to get a value from the JSON object dictionary
calories = first_minute_of_data["Calories"]
print(calories)
print(type(calories))
print()


### Now read the actigraph json data into a DataFrame using pandas
act_df = pd.read_json("actigraph_data.json")   # note similarity to pd.read_csv(filename)
print(act_df)


### Try to read the itunes json data from file the same way as previous (using pandas)
thor_df = pd.read_json("thor_itunes_search.json")
print(thor_df)
# Notice that when the outermost type is json object ({}),
#     the 'inner' keys don't end up as column names

thor_json_obj = json.load(open("thor_itunes_search.json", "r"))
print(thor_json_obj)

# # Grab the json object 'results from within the larger json object
results_arr = thor_json_obj['results']
results_df = pd.DataFrame(results_arr)
print(results_df)

# # TASK: loop through the results_arr and convert the millisecond track times to minutes
# for result_obj in results_arr:
#     # grabe the millisec time, divide by 1000 to get to seconds, divide by 60 to get to minutes
#     track_time_mins = result_obj['trackTimeMillis'] / 1000 / 60
#     print(result_obj['trackName'], round(track_time_mins, 2))




