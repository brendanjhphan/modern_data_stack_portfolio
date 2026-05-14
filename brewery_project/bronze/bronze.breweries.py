import psycopg2
import json
from datetime import datetime
import glob
import os

DB_HOST = "localhost"
DB_NAME = "brewery_project"
DB_USER = "postgres"
DB_PASS = "postgres123"
DB_PORT = "5432"

files = glob.glob("breweries_raw_*.json")
latest_file = max(files, key=os.path.getctime)
print(f"Loading from file: {latest_file}")

with open(latest_file, 'r') as f:
    breweries = json.load(f)

print("Connecting to Postgres...")
conn = psycopg2.connect(
    host=DB_HOST,
    database=DB_NAME,
    user=DB_USER,
    password=DB_PASS,
    port=DB_PORT
)
cur = conn.cursor()

# ---- CREATE BRONZE TABLE IF NOT EXISTS ----
cur.execute("""
    CREATE TABLE IF NOT EXISTS bronze.breweries (
        id                  TEXT,
        name                TEXT,
        brewery_type        TEXT,
        city                TEXT,
        state_province      TEXT,
        country             TEXT,
        longitude           TEXT,
        latitude            TEXT,
        phone               TEXT,
        website_url         TEXT,
        updated_at          TEXT,
        ingested_at         TIMESTAMP
    )
""")

cur.execute("TRUNCATE TABLE bronze.breweries")

print("Loading data into bronze.breweries...")
for b in breweries:
    cur.execute("""
        INSERT INTO bronze.breweries VALUES (
            %s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s
        )
    """, (
        b.get('id'),
        b.get('name'),
        b.get('brewery_type'),
        b.get('city'),
        b.get('state_province'),
        b.get('country'),
        b.get('longitude'),
        b.get('latitude'),
        b.get('phone'),
        b.get('website_url'),
        b.get('updated_at'),
        datetime.now()
    ))

conn.commit()
cur.close()
conn.close()
print(f"Done! {len(breweries)} breweries loaded into bronze.breweries")
