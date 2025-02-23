#include <iostream>
#include <string>
#include <vector>
#include "Graph.h"

using namespace std;

int main()
{
    string towns[] = {
        "Blaxhall",
        "Clacton",
        "Dunwich",
        "Feering",
        "Harwich",
        "Maldon",
        "Tiptree"
    };
    int roads[][2] = {
        {0, 2}, {0, 3}, {0, 4},
        {1, 4}, {1, 5}, {1, 6},
        {2, 0}, {2, 4},
        {3, 0}, {3, 5}, {3, 6},
        {4, 0}, {4, 1}, {4, 2}, {4, 6},
        {5, 1}, {5, 3}, {5, 6},
        {6, 1}, {6, 3}, {6, 4}, {6, 5},
    };
    Graph graph(towns, 7, roads, 22);
    cout << "Towns: " << endl;
    for (int i = 0; i < 7; i++)
        cout << "    " << i << " - " << towns[i] << endl;
    cout << "Enter the index of a town: ";
    int town = 0;
    cin >> town;
    getchar();
    vector<int> neighbors = graph.getNeighbors(town);
    cout << "Neighbors: " << endl;
    for (int i = 0; i < neighbors.size(); i++)
        cout << "    " << towns[neighbors.at(i)] << endl;
    graph.addVertex("Burger");
    graph.addEdge(7, 3);
    graph.addEdge(3, 7);
    graph.addEdge(7, 5);
    graph.addEdge(5, 7);
    char newTowns[][25] = {
            "Blaxhall",
            "Clacton",
            "Dunwich",
            "Feering",
            "Harwich",
            "Maldon",
            "Tiptree",
            "Burger"
    };
    neighbors = graph.getNeighbors(town);
    cout << "Burger Added - New Neighbors: " << endl;
    for (int i = 0; i < neighbors.size(); i++)
        cout << "    " << newTowns[neighbors[i]] << endl;

    //end
    getchar();
}