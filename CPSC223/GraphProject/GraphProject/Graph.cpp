#include "Graph.h"
#include <vector>
#include <string>

using namespace std;

Graph::Graph(string vertices[], int numVertices, int edges[][2], int numEdges)
{
    for (int i = 0; i < numVertices; i++)
        this->vertices.push_back(vertices[i]);

    this->edges.resize(numVertices);
    for (int i = 0; i < numEdges; i++)
    {
        Edge e{ edges[i][0], edges[i][1] };
        this->edges.at(edges[i][0]).push_back(e);
    }
}

vector<int> Graph::getNeighbors(int index)
{
    vector<int> results;
    vector<Edge> edges = this->edges.at(index);
    for (Edge e : edges)
    {
        results.push_back(e.end);
    }
    return results;
}

string Graph::getVertex(int index)
{
    return this->vertices.at(index);
}

int Graph::getSize()
{
    return this->vertices.size();
}

void Graph::addVertex(string vertex)
{
    this->vertices.push_back(vertex);
    this->edges.resize(this->edges.size() + 1);
}

void Graph::addEdge(int start, int end)
{
    if (start < this->vertices.size() && end < this->vertices.size())
    {
        Edge e{ start, end };
        this->edges.at(start).push_back(e);
    }
}