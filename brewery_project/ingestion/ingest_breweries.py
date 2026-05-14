import requests
import json
from datetime import datetime

print("Pulling brewery data from API...")
url = "https://api.openbrewerydb.org/v1/breweries?per_page=200"
response = requests.get(url)
breweries = response.json()
print(f"Got {len(breweries)} breweries from API")

filename = f"breweries_raw_{datetime.now().strftime('%Y%m%d')}.json"
with open(filename, 'w') as f:
    json.dump(breweries, f, indent=2)

print(f"Raw data saved to {filename}")
