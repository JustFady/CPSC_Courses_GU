import utils
import pandas as pd

def main():
    while True:
    # Prompt the user for input (Bonus B)
        city_name = input("Enter the name of a large city (or type 'quit' to exit): ").replace(" ", "+")
        if city_name.lower() == 'quit':
            break 

    state_name = input("Enter the state: ").replace(" ", "+")
    date_input = input("Enter the date in the format YYYY-MM-DD: ")

    # Get latitude and longitude from Positionstack API
    latitude, longitude = utils.get_lat_long(city_name, state_name)

    
    # Get weather data from OpenWeatherMap API
    data = utils.get_weather_data(latitude, longitude, date_input)
    
    if len(data) > 0:
        temperature = data[0].get("temp", "N/A")
        print(f"The temperature on {date_input} in {city_name.replace('+', ' ')}, {state_name.replace('+', ' ')} is {temperature}°F")
        
        # Bonus A: Display data in DataFrame format
        df = pd.DataFrame(data)
        print("\nWeather Data Table:")
        print(df)
    else:
        print("Could not retrieve weather data.")

if __name__ == "__main__":
    main()
