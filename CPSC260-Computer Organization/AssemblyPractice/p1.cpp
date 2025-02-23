/*
 * Author: Fady Youssef
 * Date: 05/27/2024
 * Project: This program takes two input numbers and prints them in increasing order.
 */

#include <iostream>

using namespace std;

int main() {
    int x, y;  //x,y: DAT 000

    // INP: Input the first number
    cout << "First number: ";
    cin >> x; // STA x: Store the first number in x
  
    // INP: Input the second number
    cout << "Second number: ";
    cin >> y; // STA y: Store the second number in y
  
    // SUB x: Subtract x from y to compare
    if (y >= x) { // BRP reverse: If y >= x, output x then y
      //LDA x (5xx)
        cout << x << endl;  // OUT: Output the value of x
      //LDA x (5xx)
        cout << y << endl;  // OUT: Output the value of y
    } else {
        // If y < x, output y then x
        cout << y << endl;  // OUT: Output the value of y
        cout << x << endl;  // OUT: Output the value of x
    }

    // HLT: End of the program
    return 0;
}
