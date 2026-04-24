import psycopg2
from db_config import DB_CONFIG

def run_seed():
    conn = None
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        cur = conn.cursor()
        print("Connected to database...")

        # Reset Schema
        print("Re-creating tables...")
        # Wipes and rebuilds tables so we don't get duplicate errors on re-runs
        with open('schema.sql', 'r') as f:
            cur.execute(f.read())

        # Insert Locations
        print("Inserting Locations...")
        locations = [
            ("123 Main St, Downtown", "555-0101", "8am-8pm"),
            ("456 Airport Rd, Terminal 1", "555-0102", "24 Hours"),
            ("789 Suburb Ln, Westside", "555-0103", "9am-6pm")
        ]
        for loc in locations:
            cur.execute("INSERT INTO Locations (address, phone, operating_hours) VALUES (%s, %s, %s)", loc)

        # Insert Categories
        # IDs correspond to: 1=Economy, 2=SUV, 3=Luxury, 4=Minivan
        print("Inserting Categories...")
        cats = [("Economy", 45.00), ("SUV", 85.00), ("Luxury", 150.00), ("Minivan", 70.00)]
        for cat in cats:
            cur.execute("INSERT INTO Vehicle_Categories (type_name, base_price) VALUES (%s, %s)", cat)

        # Insert Insurance Options
        print("Inserting Insurance Options...")
        ins_opts = [("Basic Liability", 15.00), ("Premium Protection", 30.00), ("Peace of Mind (Full)", 50.00)]
        for i in ins_opts:
            cur.execute("INSERT INTO Insurance_Options (coverage_type, daily_cost) VALUES (%s, %s)", i)

        # Insert MASSIVE Fleet
        print("Inserting Fleet (60+ Vehicles)...")
        # I populated a large fleet so that no matter what Location/Category combination
        # I pick during the demo, I never get an "Empty Results" screen.
        vehicles = [
            # === DOWNTOWN (Loc 1) ===
            ("VIN1001", "Toyota", "Camry", 2022, 15000, "Available", 1, 1),
            ("VIN1002", "Honda", "Civic", 2023, 5000, "Available", 1, 1),
            ("VIN1003", "Nissan", "Sentra", 2021, 32000, "Available", 1, 1),
            ("VIN1004", "Ford", "Explorer", 2023, 12000, "Available", 1, 2),
            ("VIN1005", "Jeep", "Grand Cherokee", 2022, 18000, "Maintenance", 1, 2),
            ("VIN1006", "Toyota", "RAV4", 2024, 4000, "Available", 1, 2),
            ("VIN1007", "BMW", "3 Series", 2024, 2000, "Rented", 1, 3),
            ("VIN1008", "Audi", "A4", 2023, 8000, "Available", 1, 3),
            ("VIN1009", "Mercedes", "E-Class", 2022, 15000, "Available", 1, 3),
            ("VIN1010", "Dodge", "Caravan", 2020, 45000, "Available", 1, 4),
            ("VIN1011", "Chrysler", "Pacifica", 2023, 12000, "Available", 1, 4),
            ("VIN1012", "Honda", "Odyssey", 2022, 25000, "Available", 1, 4),

            # === AIRPORT (Loc 2) ===
            ("VIN2001", "Hyundai", "Accent", 2024, 500, "Available", 2, 1),
            ("VIN2002", "Kia", "Rio", 2023, 12000, "Available", 2, 1),
            ("VIN2003", "Toyota", "Corolla", 2022, 28000, "Rented", 2, 1),
            ("VIN2004", "Chevrolet", "Tahoe", 2024, 3000, "Available", 2, 2),
            ("VIN2005", "Ford", "Expedition", 2023, 15000, "Available", 2, 2),
            ("VIN2006", "Subaru", "Forester", 2022, 22000, "Available", 2, 2),
            ("VIN2007", "Jeep", "Wrangler", 2023, 9000, "Available", 2, 2),
            ("VIN2008", "Tesla", "Model 3", 2023, 8000, "Available", 2, 3),
            ("VIN2009", "Mercedes", "S-Class", 2024, 1000, "Available", 2, 3),
            ("VIN2010", "BMW", "X5", 2024, 2500, "Rented", 2, 3),
            ("VIN2011", "Porsche", "Macan", 2023, 5000, "Available", 2, 3),
            ("VIN2012", "Lexus", "RX350", 2022, 18000, "Available", 2, 3),
            ("VIN2013", "Honda", "Odyssey", 2023, 15000, "Available", 2, 4),
            ("VIN2014", "Toyota", "Sienna", 2024, 2000, "Available", 2, 4),
            ("VIN2015", "Kia", "Carnival", 2023, 5000, "Available", 2, 4),

            # === WESTSIDE (Loc 3) ===
            ("VIN3001", "Hyundai", "Elantra", 2021, 30000, "Available", 3, 1),
            ("VIN3002", "Honda", "Accord", 2023, 12000, "Available", 3, 1),
            ("VIN3003", "Mazda", "3", 2022, 19000, "Available", 3, 1),
            ("VIN3004", "Volkswagen", "Jetta", 2023, 8000, "Available", 3, 1),
            ("VIN3005", "Kia", "Sorento", 2022, 18000, "Available", 3, 2),
            ("VIN3006", "Mazda", "CX-5", 2023, 9000, "Available", 3, 2),
            ("VIN3007", "Subaru", "Outback", 2022, 25000, "Available", 3, 2),
            ("VIN3008", "Volkswagen", "Tiguan", 2023, 11000, "Maintenance", 3, 2),
            ("VIN3009", "Ford", "Mustang", 2024, 500, "Available", 3, 3),
            ("VIN3010", "Audi", "Q5", 2022, 22000, "Available", 3, 3),
            ("VIN3011", "Volvo", "XC90", 2023, 14000, "Available", 3, 3),
            ("VIN3012", "Kia", "Carnival", 2023, 8000, "Rented", 3, 4),
            ("VIN3013", "Chrysler", "Voyager", 2021, 35000, "Available", 3, 4),
            ("VIN3014", "Toyota", "Sienna", 2020, 42000, "Available", 3, 4)
        ]

        for v in vehicles:
            cur.execute("""INSERT INTO Vehicles (vin, make, model, year, current_mileage, availability_status, location_id, category_id)
                           VALUES (%s, %s, %s, %s, %s, %s, %s, %s)""", v)

        # Insert Customers
        print("Inserting Customers...")
        customers = [
            ("Alice Smith", "555-1111", "alice@test.com", "DL123", "12 Maple Dr"),
            ("Bob Jones", "555-2222", "bob@test.com", "DL456", "34 Oak St"),
            ("Charlie Brown", "555-3333", "charlie@test.com", "DL789", "56 Pine Rd"),
            ("Diana Prince", "555-4444", "diana@test.com", "DL999", "88 Justice Ave"),
            ("Tony Stark", "555-9999", "ironman@test.com", "DL001", "1 Malibu Point"),
            ("Bruce Wayne", "555-0000", "batman@test.com", "DL002", "1007 Mountain Dr")
        ]
        for c in customers:
            cur.execute("INSERT INTO Customers (name, phone, email, license_num, address) VALUES (%s, %s, %s, %s, %s)", c)

        # Insert Discounts
        print("Inserting Discounts...")
        discounts = [("WELCOME10", 10), ("VIP20", 20), ("FREERIDE", 100)]
        for d in discounts:
            cur.execute("INSERT INTO Discounts (code, percent_off) VALUES (%s, %s)", d)

        # Generate History
        print("Generating History...")
        reservations = [
            (4, 'VIN1004', 2500.00, 'Completed'), (5, 'VIN1006', 4200.00, 'Completed'),
            (6, 'VIN2001', 3200.00, 'Completed'), (5, 'VIN2007', 8500.00, 'Completed'),
            (4, 'VIN2006', 5100.00, 'Completed'), (2, 'VIN3001', 300.00, 'Active'),
            (1, 'VIN3005', 450.00, 'Completed')
        ]
        for r in reservations:
            cur.execute("""INSERT INTO Reservations (customer_id, vin, pickup_date, return_date, total_cost, status)
                           VALUES (%s, %s, '2024-11-01', '2024-11-05', %s, %s) RETURNING reservation_id""", (r[0], r[1], r[2], r[3]))
            rid = cur.fetchone()[0]
            cur.execute("INSERT INTO Payments (reservation_id, amount, method) VALUES (%s, %s, 'Credit Card')", (rid, r[2]))

        # Insert Reviews
        print("Inserting Reviews...")
        reviews = [
            (5, 'VIN2007', 5, "Incredible speed! Tony approved."),
            (4, 'VIN2006', 4, "Spacious, but hard to park."),
            (1, 'VIN3005', 5, "Great family car for the weekend.")
        ]
        for rev in reviews:
            cur.execute("INSERT INTO Reviews (customer_id, vin, rating, comment) VALUES (%s, %s, %s, %s)", rev)

        conn.commit()
        print("Database populated successfully!")

    except Exception as e:
        print(f"Error: {e}")
        if conn: conn.rollback()
    finally:
        if conn: conn.close()

if __name__ == "__main__":
    run_seed()