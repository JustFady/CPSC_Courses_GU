import psycopg2
import os
from db_config import DB_CONFIG
from datetime import datetime, timedelta

def get_connection():
    # connects to the postgres database using the settings from the config file
    return psycopg2.connect(**DB_CONFIG)

# ==========================================
#              VISUAL UTILS
# ==========================================

def clear_screen():
    # checks if we are on Windows or Mac/linux and runs the right command
    # keeps the terminal looking clean
    os.system('cls' if os.name == 'nt' else 'clear')

def print_logo():
    clear_screen()
    print("\n")
    print("   ╔══════════════════════════════════════════════════╗")
    print("   ║                                                  ║")
    print("   ║     ▲  A P E X   F L E E T   M A N A G E R       ║")
    print("   ║                                                  ║")
    print("   ║          Automotive Database System              ║")
    print("   ║                                                  ║")
    print("   ╚══════════════════════════════════════════════════╝")
    print("\n")

def print_header(text):
    print(f"\n{text}")
    print("-" * len(text))

def get_valid_input(prompt):
    # loops until the user actually types something valid
    # this stops the program from crashing if they leave stuff blank
    while True:
        user_in = input(prompt).strip()
        if user_in.lower() == 'x': return None
        if user_in: return user_in
        print("Field cannot be empty. (Type 'x' to cancel)")

def get_int_input(prompt):
    # same as above but specifically for numbers like mileage or days
    # prevents errors if someone types letters instead of a number
    while True:
        user_in = input(prompt).strip()
        if not user_in: return None
        if user_in.isdigit():
            return int(user_in)
        print("Please enter a valid number.")


# ==========================================
#              CUSTOMER LOGIC
# ==========================================
def customer_portal():
    while True:
        print_logo()
        print_header("CUSTOMER PORTAL")
        print("1. Login")
        print("2. Create Account")
        print("3. Back")
        choice = input("\nSelect: ")
        if choice == '1': login_customer()
        elif choice == '2': create_account()
        elif choice == '3': break

def create_account():
    print_header("NEW ACCOUNT REGISTRATION")
    print("(Type 'x' at any time to cancel)")

    # get all the info we need for the Customers table
    name = get_valid_input("Full Name: ")
    if not name: return
    phone = get_valid_input("Phone: ")
    if not phone: return
    email = get_valid_input("Email: ")
    if not email: return
    license_num = get_valid_input("License #: ")
    if not license_num: return
    address = get_valid_input("Address: ")
    if not address: return

    conn = get_connection()
    cur = conn.cursor()
    try:
        # try to insert the new customer, returning their ID so they know it
        cur.execute("INSERT INTO Customers (name, phone, email, license_num, address) VALUES (%s, %s, %s, %s, %s) RETURNING customer_id",
                   (name, phone, email, license_num, address))
        new_id = cur.fetchone()[0]
        conn.commit()
        print(f"\n[SUCCESS] Account created! Customer ID: {new_id}")
        input("Press Enter to login...")
    except Exception as e: print("Error:", e)
    finally: conn.close()

def login_customer():
    cust_id = input("\nEnter Customer ID: ")
    conn = get_connection()
    cur = conn.cursor()
    try:
        # check if this ID actually exists in the db
        cur.execute("SELECT name FROM Customers WHERE customer_id = %s", (cust_id,))
        res = cur.fetchone()
        if not res:
            print("User not found.")
            input("Press Enter...")
            return
        name = res[0]
    except Exception as e: print("Error:", e); return
    finally: conn.close()

    # if login worked, show them the main customer menu
    while True:
        print_logo()
        print(f"Welcome, {name}!")
        print("-" * 60)
        print("1. Book a Vehicle")
        print("2. My Reservations")
        print("3. Write a Review")
        print("4. Update Profile")
        print("5. Logout")
        choice = input("\nSelect: ")
        if choice == '1': book_car_workflow(cust_id)
        elif choice == '2': manage_reservations(cust_id)
        elif choice == '3': write_review(cust_id)
        elif choice == '4': update_profile(cust_id)
        elif choice == '5': break

def book_car_workflow(cust_id):
    conn = get_connection()
    cur = conn.cursor()
    try:
        # user picks where they want to pick up the car
        print_header("STEP 1: CHOOSE LOCATION")
        cur.execute("SELECT location_id, address FROM Locations ORDER BY location_id")
        locations_list = cur.fetchall()
        for loc in locations_list: print(f"  [{loc[0]}] {loc[1]}")
        while True:
            loc_id = input("\nEnter Location ID: ")
            # checks if the ID they typed is actually in the list we just grabbed
            if any(str(l[0]) == loc_id for l in locations_list): break
            print("Invalid ID.")

        # user picks the type of car
        print_header("STEP 2: CHOOSE CATEGORY")
        cur.execute("SELECT category_id, type_name FROM Vehicle_Categories ORDER BY category_id")
        cats = cur.fetchall()
        for c in cats: print(f"  [{c[0]}] {c[1]}")
        while True:
            cat_id = input("\nEnter Category ID: ")
            if any(str(c[0]) == cat_id for c in cats): break
            print("Invalid ID.")

        # show the specific cars that match location + category + aren't rented
        cur.execute("""
            SELECT v.vin, v.make, v.model, v.year, c.base_price
            FROM Vehicles v
            JOIN Vehicle_Categories c ON v.category_id = c.category_id
            WHERE v.location_id = %s AND v.category_id = %s AND v.availability_status = 'Available'""", (loc_id, cat_id))
        cars = cur.fetchall()

        if not cars:
            print("\nNo cars available matching criteria.")
            input("Press Enter to back...")
            return

        print_header("STEP 3: AVAILABLE CARS")
        print(f"{'VIN':<10} {'VEHICLE':<20} {'YEAR':<6} {'PRICE'}")
        print("-" * 45)
        for c in cars:
            print(f"{c[0]:<10} {c[1]} {c[2]:<12} {c[3]:<6} ${c[4]}/day")

        vin = input("\nEnter VIN to book (or Enter to cancel): ")
        if not vin: return

        # grab the selected car so we can get its base price for math later
        selected = next((c for c in cars if c[0] == vin), None)
        if not selected: print("Invalid VIN."); input("Press Enter..."); return
        base_price = selected[4]

        # handle dates and calculate initial cost
        days = get_int_input("Number of days: ")
        if not days: return

        start_str = input("Start Date (YYYY-MM-DD) [Enter for Today]: ").strip()
        if start_str:
            try: pickup = datetime.strptime(start_str, "%Y-%m-%d").date()
            except ValueError: print("Invalid Date Format."); input("Press Enter..."); return
        else: pickup = datetime.now().date()

        ret = pickup + timedelta(days=days)
        car_total = base_price * days

        # insurance options
        print("\n--- ADD INSURANCE? ---")
        cur.execute("SELECT insurance_id, coverage_type, daily_cost FROM Insurance_Options")
        opts = cur.fetchall()
        print("  [0] None")
        for o in opts: print(f"  [{o[0]}] {o[1]} (+${o[2]}/day)")
        ins_choice = input("Select Plan ID: ")
        ins_total = 0; ins_id = None
        if ins_choice and ins_choice != '0':
            for o in opts:
                if str(o[0]) == ins_choice:
                    ins_id = o[0]; ins_total = o[2] * days; break

        # Final calculations with promo code logic
        subtotal = car_total + ins_total
        promo = input(f"\nSubtotal: ${subtotal:.2f}. Enter Promo Code: ")
        disc_amt = 0
        if promo:
            cur.execute("SELECT percent_off FROM Discounts WHERE code = %s", (promo,))
            d = cur.fetchone()
            if d:
                percent = d[0]
                disc_amt = (subtotal * percent) / 100
                print(f"  -> {percent}% Discount Applied (-${disc_amt:.2f})")

        final = subtotal - disc_amt

        # Show receipt and confirm
        print("\n" + "*"*40)
        print("        R E N T A L   R E C E I P T")
        print("*"*40)
        print(f"Vehicle:   {selected[1]} {selected[2]}")
        print(f"Rate:      ${base_price}/day x {days} days = ${car_total:.2f}")
        if ins_id: print(f"Insurance: ${ins_total:.2f}")
        if disc_amt: print(f"Discount: -${disc_amt:.2f}")
        print("-" * 40)
        print(f"TOTAL DUE: ${final:.2f}")
        print("*"*40)

        if input("\nConfirm Booking? (y/n): ").lower() == 'y':
            try:
                # Transaction: 1. Create Reservation, 2. Add Payment, 3. Link Insurance, 4. Update Car Status
                cur.execute("""INSERT INTO Reservations (customer_id, vin, pickup_date, return_date, total_cost, status)
                            VALUES (%s, %s, %s, %s, %s, 'Active') RETURNING reservation_id""",
                            (cust_id, vin, pickup, ret, final))
                rid = cur.fetchone()[0]

                cur.execute("INSERT INTO Payments (reservation_id, amount, method) VALUES (%s, %s, 'Credit Card')", (rid, final))

                if ins_id: cur.execute("INSERT INTO Reservation_Insurance (reservation_id, insurance_id) VALUES (%s, %s)", (rid, ins_id))

                # IMPORTANT: mark car as Rented so nobody else can book it
                cur.execute("UPDATE Vehicles SET availability_status = 'Rented' WHERE vin = %s", (vin,))
                conn.commit()
                print(f"\n[SUCCESS] Confirmed! Reservation ID: {rid}")
                input("Press Enter to continue...")
            except Exception as e:
                conn.rollback(); print("Error:", e)
    finally: conn.close()

def write_review(cust_id):
    print_header("WRITE A REVIEW")
    conn = get_connection()
    cur = conn.cursor()
    try:
        # only let them review cars they actually finished renting
        cur.execute("""
            SELECT v.vin, v.make, v.model 
            FROM Reservations r JOIN Vehicles v ON r.vin = v.vin 
            WHERE r.customer_id = %s AND r.status = 'Completed'
        """, (cust_id,))
        past_rentals = cur.fetchall()

        if not past_rentals:
            print("You can only review cars you have finished renting.")
            input("Press Enter..."); return

        print("Which car would you like to review?")
        for r in past_rentals:
            print(f"  VIN: {r[0]} | {r[1]} {r[2]}")

        vin = input("\nEnter VIN: ")
        # make sure they own the reservation for this VIN
        if not any(r[0] == vin for r in past_rentals):
            print("Invalid VIN."); input("Press Enter..."); return

        rating = get_int_input("Rating (1-5): ")
        if not rating or rating < 1 or rating > 5:
            print("Invalid Rating."); return

        comment = input("Comment: ")
        cur.execute("INSERT INTO Reviews (customer_id, vin, rating, comment) VALUES (%s, %s, %s, %s)", (cust_id, vin, rating, comment))
        conn.commit()
        print("[SUCCESS] Review Submitted!")
    except Exception as e: print("Error:", e)
    finally: conn.close(); input("Press Enter...")

def manage_reservations(cust_id):
    conn = get_connection()
    cur = conn.cursor()
    try:
        # simple query to show what the user currently has booked
        cur.execute("""
            SELECT r.reservation_id, v.make, v.model, r.pickup_date, r.return_date, r.status
            FROM Reservations r JOIN Vehicles v ON r.vin = v.vin WHERE r.customer_id = %s
        """, (cust_id,))
        rows = cur.fetchall()
        print_header("MY RESERVATIONS")
        if not rows: print("No active reservations.")
        else:
            print(f"{'ID':<5} {'VEHICLE':<20} {'DATES':<25} {'STATUS'}")
            print("-" * 60)
            for r in rows:
                print(f"{r[0]:<5} {r[1]} {r[2]:<15} {r[3]}->{r[4]}   {r[5]}")
    finally: conn.close()
    input("\nPress Enter to back...")

def update_profile(cust_id):
    conn = get_connection()
    cur = conn.cursor()
    try:
        cur.execute("SELECT name, phone, address FROM Customers WHERE customer_id = %s", (cust_id,))
        res = cur.fetchone()
        print_header(f"EDIT PROFILE: {res[0]}")
        print(f"Current Phone:   {res[1]}")
        print(f"Current Address: {res[2]}")
        print("\n(Press Enter to keep current value)")

        # if they hit enter, we just keep the old value (res[1] or res[2])
        new_phone = input("New Phone: ").strip() or res[1]
        new_addr = input("New Address: ").strip() or res[2]
        if new_phone == res[1] and new_addr == res[2]:
            print("\n[!] No changes made.")
        else:
            cur.execute("UPDATE Customers SET phone = %s, address = %s WHERE customer_id = %s", (new_phone, new_addr, cust_id))
            conn.commit()
            print("\n[SUCCESS] Profile Updated.")
    finally: conn.close()
    input("Press Enter...")


# ==========================================
#              STAFF LOGIC
# ==========================================
def employee_portal():
    if input("Enter Password (hint: staff): ") != "staff": return
    while True:
        print_logo()
        print_header("EMPLOYEE OPERATIONS")
        print("1. Process Standard Return")
        print("2. Log Maintenance/Repair")
        print("3. View Fleet Status")
        print("4. Back")
        choice = input("\nSelect: ")
        if choice == '1': process_return()
        elif choice == '2': log_maintenance()
        elif choice == '3': view_fleet()
        elif choice == '4': break

def view_fleet():
    conn = get_connection()
    cur = conn.cursor()
    # allow filtering so they don't have to scroll through 60 cars
    print_header("FLEET FILTER")
    print("1. Available Only")
    print("2. Rented Only")
    print("3. In Maintenance")
    print("4. Show All")
    f = input("Filter: ")
    sql = "SELECT vin, make, model, availability_status FROM Vehicles"
    if f == '1': sql += " WHERE availability_status = 'Available'"
    elif f == '2': sql += " WHERE availability_status = 'Rented'"
    elif f == '3': sql += " WHERE availability_status = 'Maintenance'"
    sql += " ORDER BY availability_status"
    cur.execute(sql)
    print_header("FLEET STATUS")
    print(f"{'VIN':<10} {'VEHICLE':<20} {'STATUS'}")
    print("-" * 45)
    for r in cur.fetchall(): print(f"{r[0]:<10} {r[1]} {r[2]:<12} {r[3]}")
    conn.close(); input("\nPress Enter...")

def get_customer_rentals(cur):
    # helper to find which cars a specific customer has right now
    cust_id = input("Enter Customer ID: ")
    cur.execute("""
        SELECT v.vin, v.make, v.model, v.current_mileage
        FROM Reservations r JOIN Vehicles v ON r.vin = v.vin 
        WHERE r.customer_id = %s AND (r.status = 'Active' OR v.availability_status = 'Rented')
    """, (cust_id,))
    rows = cur.fetchall()
    if not rows: print("No active rentals found."); return None
    print(f"\n--- ACTIVE RENTALS FOR CUSTOMER {cust_id} ---")
    print(f"{'VIN':<10} {'VEHICLE':<20} {'MILEAGE'}")
    print("-" * 50)
    for r in rows: print(f"{r[0]:<10} {r[1]} {r[2]:<12} {r[3]}")
    return rows

def process_return():
    print_header("VEHICLE RETURN")
    conn = get_connection()
    cur = conn.cursor()
    try:
        # first find what they rented so we don't return the wrong car
        rentals = get_customer_rentals(cur)
        if not rentals: return
        vin = input("\nEnter VIN to Return: ")
        if not any(r[0] == vin for r in rentals): print("Invalid VIN."); return
        miles = get_int_input("Updated Mileage: ")
        if not miles: return

        # update mileage and set status back to Available so someone else can rent it
        cur.execute("UPDATE Vehicles SET current_mileage = %s, availability_status='Available' WHERE vin=%s", (miles, vin))
        cur.execute("UPDATE Reservations SET status='Completed' WHERE vin=%s AND status='Active'", (vin,))
        conn.commit()
        print("[SUCCESS] Vehicle checked in.")
    except Exception as e: print("Error:", e)
    finally: conn.close(); input("Press Enter...")

def log_maintenance():
    print_header("LOG MAINTENANCE")
    conn = get_connection()
    cur = conn.cursor()
    try:
        # mostly same as return, but marks it as Maintenance instead of Available
        rentals = get_customer_rentals(cur)
        if not rentals: return
        vin = input("\nEnter VIN to Repair: ")
        if not any(r[0] == vin for r in rentals): print("Invalid VIN."); return
        desc = input("Description: ")
        cost = get_int_input("Cost ($): ")

        cur.execute("UPDATE Vehicles SET availability_status='Maintenance' WHERE vin=%s", (vin,))
        cur.execute("UPDATE Reservations SET status='Completed' WHERE vin=%s AND status='Active'", (vin,))
        cur.execute("INSERT INTO Maintenance_Records (vin, service_date, description, cost) VALUES (%s, CURRENT_DATE, %s, %s)", (vin, desc, cost))
        conn.commit()
        print("[REPORT] Logged to Maintenance.")
    except Exception as e: print("Error:", e)
    finally: conn.close(); input("Press Enter...")

# ==========================================
#              MANAGER LOGIC
# ==========================================
def manager_portal():
    if input("Enter Password (hint: admin): ") != "admin": return
    while True:
        print_logo()
        print_header("EXECUTIVE DASHBOARD")
        print("1. Revenue Analytics")
        print("2. VIP Customer Report")
        print("3. View Vehicle Reviews")
        print("4. Add New Vehicle")
        print("5. Decommission Vehicle")
        print("6. Back")
        choice = input("\nSelect: ")
        if choice == '1': revenue_report()
        elif choice == '2': vip_report()
        elif choice == '3': view_reviews()
        elif choice == '4': add_new_vehicle()
        elif choice == '5': decommission()
        elif choice == '6': break

def view_reviews():
    conn = get_connection()
    cur = conn.cursor()
    # joins 3 tables to show who wrote it, what car, and the rating
    cur.execute("""
        SELECT c.name, v.make, v.model, r.rating, r.comment 
        FROM Reviews r 
        JOIN Vehicles v ON r.vin = v.vin
        JOIN Customers c ON r.customer_id = c.customer_id
        ORDER BY r.rating DESC
    """)
    print_header("CUSTOMER FEEDBACK")
    if cur.rowcount == 0: print("No reviews submitted yet.")
    else:
        print(f"{'CUSTOMER':<15} {'VEHICLE':<20} {'RATING':<8} {'COMMENT'}")
        print("-" * 75)
        for r in cur.fetchall():
            stars = "*" * r[3]
            print(f"{r[0]:<15} {r[1]+' '+r[2]:<20} {stars:<8} {r[4]}")
    conn.close(); input("\nPress Enter...")

def revenue_report():
    conn = get_connection()
    cur = conn.cursor()
    # groups payments by location to see which branch makes the most money
    cur.execute("""
        SELECT l.address, 
               CASE 
                   WHEN SUM(p.amount) IS NULL THEN 0 
                   ELSE SUM(p.amount) 
               END as total
        FROM Locations l
        LEFT JOIN Vehicles v ON l.location_id = v.location_id
        LEFT JOIN Reservations r ON v.vin = r.vin
        LEFT JOIN Payments p ON r.reservation_id = p.reservation_id
        GROUP BY l.address ORDER BY total DESC
    """)
    print_header("REVENUE REPORT")
    print(f"{'LOCATION':<30} {'REVENUE'}")
    print("-" * 45)
    for r in cur.fetchall(): print(f"{r[0]:<30} ${r[1]:,.2f}")
    conn.close(); input("\nPress Enter...")

def vip_report():
    conn = get_connection()
    cur = conn.cursor()
    # finds big spenders (> $2000)
    cur.execute("""
        SELECT c.name, SUM(p.amount) as spent
        FROM Customers c
        JOIN Reservations r ON c.customer_id = r.customer_id
        JOIN Payments p ON r.reservation_id = p.reservation_id
        GROUP BY c.name HAVING SUM(p.amount) > 2000 ORDER BY spent DESC
    """)
    print_header("VIP CUSTOMERS (>$2000)")
    for r in cur.fetchall(): print(f" - {r[0]:<20} ${r[1]:,.2f}")
    conn.close(); input("\nPress Enter...")

def add_new_vehicle():
    print_header("ACQUIRE VEHICLE")
    conn = get_connection()
    cur = conn.cursor()
    try:
        vin_in = get_valid_input("Enter/Scan VIN: ")
        if not vin_in: return

        # checking if we already have this VIN to clone
        cur.execute("SELECT make, model, year, location_id, category_id FROM Vehicles WHERE vin = %s", (vin_in,))
        existing = cur.fetchone()
        if existing:
            print(f"\n[!] MATCH FOUND: {existing[2]} {existing[0]} {existing[1]}")
            if input("Clone this car with new VIN? (y/n): ").lower() == 'y':
                new_vin = get_valid_input("Enter NEW VIN: ")
                if new_vin:
                    cur.execute("""INSERT INTO Vehicles (vin, make, model, year, location_id, category_id, availability_status, current_mileage)
                        VALUES (%s, %s, %s, %s, %s, %s, 'Available', 0)""", (new_vin, existing[0], existing[1], existing[2], existing[3], existing[4]))
                    conn.commit(); print("[SUCCESS] Clone Added.")
        else:
            # otherwise just manual entry
            make = get_valid_input("Make: ")
            model = get_valid_input("Model: ")
            year = get_valid_input("Year: ")
            cur.execute("SELECT location_id, address FROM Locations ORDER BY location_id")
            print("\nLocation:")
            for l in cur.fetchall(): print(f" [{l[0]}] {l[1]}")
            loc_id = input("ID: ")
            cur.execute("SELECT category_id, type_name FROM Vehicle_Categories ORDER BY category_id")
            print("\nCategory:")
            for c in cur.fetchall(): print(f" [{c[0]}] {c[1]}")
            cat_id = input("ID: ")
            cur.execute("""INSERT INTO Vehicles (vin, make, model, year, location_id, category_id, availability_status, current_mileage)
                VALUES (%s, %s, %s, %s, %s, %s, 'Available', 0)""", (vin_in, make, model, year, loc_id, cat_id))
            conn.commit(); print("[SUCCESS] Vehicle Added.")
    except Exception as e: print("Error:", e)
    finally: conn.close(); input("Press Enter...")



def decommission():
    conn = get_connection()
    cur = conn.cursor()
    # list them first
    print_header("CURRENT FLEET")
    cur.execute("SELECT vin, make, model, availability_status FROM Vehicles")
    rows = cur.fetchall()
    print(f"{'VIN':<10} {'VEHICLE':<20} {'STATUS'}")
    print("-" * 45)
    for r in rows: print(f"{r[0]:<10} {r[1]} {r[2]:<12} {r[3]}")

    vin = input("\nEnter VIN to Delete: ")
    if not any(r[0] == vin for r in rows): print("Invalid VIN.")
    elif input("Confirm? (y/n): ") == 'y':
        # noinspection PyBroadException
        try:
            # this will fail if the car has reservations
            cur.execute("DELETE FROM Vehicles WHERE vin=%s", (vin,))
            conn.commit(); print("Deleted.")
        except Exception: print("Cannot delete car with active history.")
    conn.close(); input("Press Enter...")

if __name__ == "__main__":
    while True:
        print_logo()
        print("1. Customer Portal")
        print("2. Staff Portal")
        print("3. Manager Portal")
        print("4. Exit")
        menu_choice = input("\nSelect Role: ")
        if menu_choice == '1': customer_portal()
        elif menu_choice == '2': employee_portal()
        elif menu_choice == '3': manager_portal()
        elif menu_choice == '4': break