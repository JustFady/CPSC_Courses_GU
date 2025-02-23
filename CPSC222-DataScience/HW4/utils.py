import requests
from datetime import datetime

# Positionstack API credentials
POSITIONSTACK_API_KEY = "291331f8de28ae9486cb7bd51af83a15"

# OpenWeatherMap API credentials
OPENWEATHER_API_KEY = "bbbef4198bbd29c9c9b3433f0afa3e7e"

def get_lat_long(city_name, state_name):

    try:
        # Combine city and state in the query 
        query = f"{city_name.replace('+', ' ')}, {state_name.replace('+', ' ')}"
        url = "http://api.positionstack.com/v1/forward"
        params = {
            "access_key": POSITIONSTACK_API_KEY,
            "query": query,
        }
        response = requests.get(url, params=params)

        # for debugging
        print("OpenWeatherMap API Response:", response.json())
        data = response.json()
        
        # Extract latitude and longitude
        if data and 'data' in data and len(data['data']) > 0:
            location = data['data'][0]
            return location.get('latitude'), location.get('longitude')
        
    except Exception as e:
        print(f"Error retrieving latitude and longitude: {e}")
    
    return None, None

def get_weather_data(latitude, longitude, date_input):
    try:
        unix_time = int(datetime.strptime(date_input, "%Y-%m-%d").timestamp())
        
        url = f"http://api.openweathermap.org/data/3.0/onecall/timemachine"
        params = {
            "lat": latitude,
            "lon": longitude,
            "dt": unix_time,
            "units": "imperial", 
            "appid": OPENWEATHER_API_KEY 
        }
        response = requests.get(url, params=params)      
        data = response.json()
        
        # Extract temperature and other data for DataFrame
        weather_data = []
        if "hourly" in data:
            for hour in data["hourly"]:
                weather_data.append({
                    "time": datetime.fromtimestamp(hour["dt"]).strftime("%Y-%m-%d %H:%M:%S"),
                    "temp": hour.get("temp"),
                    "humidity": hour.get("humidity"),
                    "pressure": hour.get("pressure")
                })
        elif "current" in data:
            weather_data.append({
                "time": datetime.fromtimestamp(data["current"]["dt"]).strftime("%Y-%m-%d %H:%M:%S"),
                "temp": data["current"].get("temp"),
                "humidity": data["current"].get("humidity"),
                "pressure": data["current"].get("pressure")
            })
        return weather_data
    
    except Exception as e:
        print(f"Error retrieving weather data: {e}")
    
    return None