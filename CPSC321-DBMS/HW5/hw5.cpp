/*=======================================================================
 * NAME:    Fady Youssef
 * CLASS:   CPSC 321
 * DATE:    10/27/2025
 * DESC:    HW-5 C++ program to interface with the CIA database.
 * DESC:    Uses libpqxx and a menu (1-7) to manage countries/borders.
 * DESC:    Uses parameterized queries to prevent SQL injection.
 *======================================================================*/
#include <pqxx/pqxx>
#include <iostream>
#include <string>
#include <cctype>
#include <iomanip>
#include "config.h"

using namespace std;
using namespace pqxx;

// Function prototypes
void showMenu();
void listCountries(connection &conn);
void addCountry(connection &conn);
void addBorder(connection &conn);
void findCountries(connection &conn);
void updateCountry(connection &conn);
void removeBorder(connection &conn);

bool countryExists(connection &conn, const string &code);
bool borderExists(connection &conn, const string &a, const string &b);
string cleanCode(const string &s);


int main(int argc, char* argv[]) {

    try {
        // connection string from config.h
        string usr = config::USER;
        string pwd = config::PASSWORD;
        string hst = config::HOST;
        string dat = config::DATABASE;
        string url = "postgresql://" + usr + ":" + pwd + "@" + hst + "/" + dat;

        // create connection
        connection conn{url};

        if (!conn.is_open()) {
            cout << "Cannot open database connection." << endl;
            return 1;
        }

        // should've used cases...
        bool running = true;
        while (running) {
            showMenu();
            cout << "Enter your choice (1-7): ";

            int choice = 0;
            if (!(cin >> choice)) {
                // simple validation
                cout << "Invalid input. Exiting." << endl;
                return 1;
            }

            // This is the fix for the cin/getline bug.
            // Always ignore the newline after a cin >>
            cin.ignore(10000, '\n');

            if (choice == 1) {
                listCountries(conn);
            } else if (choice == 2) {
                addCountry(conn);
            } else if (choice == 3) {
                addBorder(conn);
            } else if (choice == 4) {
                findCountries(conn);
            } else if (choice == 5) {
                updateCountry(conn);
            } else if (choice == 6) {
                removeBorder(conn);
            } else if (choice == 7) {
                running = false; // exit condition
            } else {
                cout << "Please enter a number between 1 and 7." << endl;
            }
        }

        // the real error.
        // conn.disconnect(); // This was the old way, causes errors now.
        cout << "Goodbye." << endl;
    } catch (const std::exception &e) {
        cout << "Error: " << e.what() << endl;
        return 1;
    }

    return 0;
}

// Just prints the menu options
void showMenu() {
    cout << endl;
    cout << "1. List countries" << endl;
    cout << "2. Add country" << endl;
    cout << "3. Add border" << endl;
    cout << "4. Find countries based on gdp and inflation" << endl;
    cout << "5. Update country's gdp and inflation" << endl;
    cout << "6. Remove border" << endl;
    cout << "7. Exit" << endl;
}


void listCountries(connection &conn) {
    try {
        work w(conn);
        // Simple query, just get everything
        result r = w.exec("SELECT country_name, country_code, gdp, inflation FROM country;");

        int rows = (int) r.size();

        for (int i = 0; i < rows; ++i) {
            //  map correct column names
            string name  = r[i]["country_name"].c_str();
            string code  = r[i]["country_code"].c_str();
            // SQL gdp is NUMERIC, read as double first.
            int gdp      = (int)r[i]["gdp"].as<double>();
            double infl  = r[i]["inflation"].as<double>();

            // Print with formatting
            cout << name << " (" << code << "), per capita gdp $"
                 << gdp << ", inflation rate "
                 << fixed << setprecision(2) << infl << "%" << endl;
        }

        w.commit();
    } catch (const exception &e) {
        cout << "DB error in listCountries: " << e.what() << endl;
    }
}


void addCountry(connection &conn) {
    string code;
    string name;
    int gdp;
    double inflation;

    cout << "Country code..................: ";
    getline(cin, code); // Use getline for names that might have spaces

    cout << "Country name..................: ";
    getline(cin, name);

    cout << "Country per capita gdp (USD)..: ";
    if (!(cin >> gdp)) {
        cout << "Invalid GDP input." << endl;
        cin.clear();
        cin.ignore(10000,'\n');
        return;
    }

    cout << "Country inflation (pct).......: ";
    if (!(cin >> inflation)) {
        cout << "Invalid inflation input." << endl;
        cin.clear();
        cin.ignore(10000,'\n');
        return;
    }

    // Must clear the buffer after the last cin >>
    cin.ignore(10000,'\n');

    string codeClean = cleanCode(code); // Use the helper

    if (codeClean.empty()) {
        cout << "Invalid country code." << endl;
        return;
    }

    if (countryExists(conn, codeClean)) {
        cout << "Country with code " << codeClean << " already exists." << endl;
        return;
    }

    try {
        work w(conn);

        // $1, $2... are placeholders, this stops SQL injection.
        w.exec(
            "INSERT INTO country(country_code, country_name, gdp, inflation) VALUES ($1, $2, $3, $4);",
            params(codeClean, name, gdp, inflation)
        );

        w.commit();
        cout << "Country " << name << " (" << codeClean << ") added." << endl;
    } catch (const exception &e) {
        cout << "DB error in addCountry: " << e.what() << endl;
    }
}


void addBorder(connection &conn) {
    string a, b;
    int length;

    cout << "Country code 1..: ";
    getline(cin, a);

    cout << "Country code 2..: ";
    getline(cin, b);

    cout << "Border length...: ";
    if (!(cin >> length)) {
        cout << "Invalid length." << endl;
        cin.clear();
        cin.ignore(10000,'\n');
        return;
    }

    cin.ignore(10000,'\n');

    string ca = cleanCode(a);
    string cb = cleanCode(b);

    if (ca.empty() || cb.empty()) {
        cout << "Invalid country code(s)." << endl;
        return;
    }

    // Don't let them add a border to itself
    if (ca == cb) {
        cout << "Cannot add border between the same country code." << endl;
        return;
    }

    // Check if both countries are real first
    if (!countryExists(conn, ca)) {
        cout << "Country " << ca << " does not exist." << endl;
        return;
    }

    if (!countryExists(conn, cb)) {
        cout << "Country " << cb << " does not exist." << endl;
        return;
    }

    // Check bi-directional
    if (borderExists(conn, ca, cb)) {
        cout << "Border between " << ca << " and " << cb << " already exists." << endl;
        return;
    }

    try {
        work w(conn);

        // Pass params to the query
        w.exec(
            "INSERT INTO border(country_code_1, country_code_2, border_length) VALUES ($1, $2, $3);",
            params(ca, cb, length)
        );

        w.commit(); // Save it
        cout << "Border added between " << ca << " and " << cb
             << " length " << length << "." << endl;
    } catch (const exception &e) {
        cout << "DB error in addBorder: " << e.what() << endl;
    }
}


void findCountries(connection &conn) {
    int minGdp, maxGdp;
    double minInfl, maxInfl;

    // Get all 4 range inputs
    cout << "Minimum per capita gdp (USD)..: ";
    if (!(cin >> minGdp)) { cout << "Invalid input." << endl; return; }

    cout << "Maximum per capita gdp (USD)..: ";
    if (!(cin >> maxGdp)) { cout << "Invalid input." << endl; return; }

    cout << "Minimum inflation (pct).......: ";
    if (!(cin >> minInfl)) { cout << "Invalid input." << endl; return; }

    cout << "Maximum inflation (pct).......: ";
    if (!(cin >> maxInfl)) { cout << "Invalid input." << endl; return; }

    cin.ignore(10000,'\n');

    try {
        work w(conn);

        result r = w.exec(
            "SELECT country_name, country_code, gdp, inflation FROM country "
            "WHERE gdp BETWEEN $1 AND $2 AND inflation BETWEEN $3 AND $4 "
            "ORDER BY gdp DESC, inflation ASC;",
            params(minGdp, maxGdp, minInfl, maxInfl)
        );

        int rows = (int) r.size();

        if (rows == 0) {
            cout << "No countries found in the given ranges." << endl;
        } else {
            // Loop and print
            for (int i = 0; i < rows; ++i) {
                //  map correct column names
                string name = r[i]["country_name"].c_str();
                string code = r[i]["country_code"].c_str();
                // Same gdp cast fix
                int gdp = (int)r[i]["gdp"].as<double>();
                double infl = r[i]["inflation"].as<double>();

                cout << name << " (" << code << "), per capita gdp $"
                     << gdp << ", inflation rate "
                     << fixed << setprecision(2) << infl << "%" << endl;
            }
        }

        w.commit();
    } catch (const exception &e) {
        cout << "DB error in findCountries: " << e.what() << endl;
    }
}


void updateCountry(connection &conn) {
    string code;
    int newGdp;
    double newInfl;

    cout << "Country code..................: ";
    getline(cin, code);

    cout << "Country per capita gdp (USD)..: ";
    if (!(cin >> newGdp)) { cout << "Invalid input." << endl; return; }

    cout << "Country inflation (pct).......: ";
    if (!(cin >> newInfl)) { cout << "Invalid input." << endl; return; }

    cin.ignore(10000,'\n');

    string clean = cleanCode(code);

    // check if it exists BEFORE trying to update
    if (!countryExists(conn, clean)) {
        cout << "Country " << clean << " does not exist." << endl;
        return;
    }

    try {
        work w(conn);

        // Simple UPDATE query
        w.exec(
            "UPDATE country SET gdp = $1, inflation = $2 WHERE country_code = $3;",
            params(newGdp, newInfl, clean)
        );

        w.commit(); // Save the update
        cout << "Country " << clean << " updated to gdp $"
             << newGdp << " and inflation "
             << fixed << setprecision(2) << newInfl << "%" << endl;
    } catch (const exception &e) {
        cout << "DB error in updateCountry: " << e.what() << endl;
    }
}


void removeBorder(connection &conn) {
    string a, b;

    cout << "Country code 1..: ";
    getline(cin, a);

    cout << "Country code 2..: ";
    getline(cin, b);

    string ca = cleanCode(a);
    string cb = cleanCode(b);

    // Check if it exists before trying to delete
    if (!borderExists(conn, ca, cb)) {
        cout << "Border between " << ca << " and " << cb << " does not exist." << endl;
        return;
    }

    try {
        work w(conn);

        // This query is the same as borderExists, just DELETE instead of SELECT
        // This handles the (A,B) or (B,A) requirement
        w.exec(
            "DELETE FROM border WHERE (country_code_1 = $1 AND country_code_2 = $2) "
            "OR (country_code_1 = $2 AND country_code_2 = $1);",
            params(ca, cb)
        );

        w.commit(); // Save the deletion
        cout << "Border between " << ca << " and " << cb << " removed." << endl;
    } catch (const exception &e) {
        cout << "DB error in removeBorder: " << e.what() << endl;
    }
}

// --- Helper Functions ---

bool countryExists(connection &conn, const string &code) {
    try {
        work w(conn);

        // Just count the rows for that code
        result r = w.exec(
            "SELECT COUNT(*) FROM country WHERE country_code = $1;",
            params(code)
        );

        w.commit();

        if (r.size() > 0) {
            int cnt = r[0][0].as<int>();
            return (cnt > 0); // If count > 0, it exists
        }
    } catch (...) {
        //caller will handle messaging
    }
    return false; // Fail safe
}

// Check if a border exists in either direction
bool borderExists(connection &conn, const string &a, const string &b) {
    try {
        work w(conn);

        // This is the bi-directional check.
        // Check for (A,B) OR (B,A)
        result r = w.exec(
            "SELECT COUNT(*) FROM border WHERE (country_code_1 = $1 AND country_code_2 = $2) "
            "OR (country_code_1 = $2 AND country_code_2 = $1);",
            params(a, b)
        );

        w.commit();

        if (r.size() > 0) {
            int cnt = r[0][0].as<int>();
            return (cnt > 0);
        }
    } catch (...) {
        // Just return false if anything goes wrong
    }
    return false;
}

// Simple helper to clean up user input
string cleanCode(const string &s) {
    // trim front
    int start = 0;
    int n = (int) s.size();
    while (start < n && isspace(s[start])) {
        start++;
    }

    // trim end
    int end = n - 1;
    while (end >= start && isspace(s[end])) {
        end--;
    }

    // make uppercase
    string out = "";
    for (int i = start; i <= end; ++i) {
        char ch = s[i];
        out.push_back(toupper(ch));
    }

    return out;
}