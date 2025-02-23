#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include "Node.h"
#include "BST.h"

void testStartEnd();
void testEmpty();
void testSorted();
void testReverseSorted();
void testBalanced();
void printTree(BST* tree);
void printNodes(Node* node, int spaces);

int main()
{
    printf("%s\n", "==========================================");
    printf("%s\n", "             TESTING BST");
    printf("%s\n", "         1 = true, 0 = false");
    printf("%s\n", "==========================================");
    testStartEnd();
    printf("%s\n", "==========================================");
    testEmpty();
    printf("%s\n", "==========================================");
    testSorted();
    //end
    getchar();
}

void testStartEnd()
{
    //test initializeBST
    BST* tree = initializeBST();
    printf("%s\n", "POST BST INITIALIZATION");
    printf("tree is initialized = %i\n", (tree->count == 0));
    //test deleteBST
    deleteBST(tree);
    printf("%s\n", "POST BST DELETE");
    printf("tree is initialized = %i\n", (tree->count == 0));
}

void testEmpty()
{
    //start
    BST* tree = initializeBST();
    //testing with no nodes
    printf("%s\n", "WITHOUT NODES:");
    //test list
    double* arr1 = list(tree);
    printf("tree list is empty = %i\n", (arr1 == NULL));
    //test contains
    printf("contains 7 = %i\n", contains(tree, 7));
    //test delete
    printf("deleted 7 = %i\n", delete(tree, 7));
    //test isEmpty
    printf("tree is empty = %i\n", isEmpty(tree));
    //test size
    printf("count = %i\n", size(tree));
    //end
    deleteBST(tree);
}

void testSorted()
{
    //start
    BST* tree = initializeBST();
    printf("%s\n", "WITH SORTED NODES:");
    //test adding unique values
    printf("add 3 = %i\n", insert(tree, 3));
    printf("add 6 = %i\n", insert(tree, 6));
    printf("add 7 = %i\n", insert(tree, 7));
    printf("add 13 = %i\n", insert(tree, 13));
    printf("add 14 = %i\n", insert(tree, 14));
    printTree(tree);
    //test adding a duplicate
    printf("add 6 again = %i\n", insert(tree, 6));
    //test the size function
    printf("count = %i\n", size(tree));
    //test contains with an existing value
    printf("contains 7 = %i\n", contains(tree, 7));
    //test delete with an existing value
    printf("deleting 7 = %i\n", delete(tree, 7));
    printTree(tree);
    //test delete with a non-existant value
    printf("deleting 8 = %i\n", delete(tree, 7));
    //check size again after deleting
    printf("count = %i\n", size(tree));
    //test contains with a non-existant value
    printf("contains 7 = %i\n", contains(tree, 7));
    //test list
    double* arr = list(tree);
    for (int i = 0; i < size(tree); i++)
        printf("%f ", arr[i]);
    printf("\n");
    free(arr);
    //end
    deleteBST(tree);
}

/*
 * The following functions can be used to print out the entire tree structure horizontally
 * using a simple recursive function. It is good for testing correct insertion and deletion.
 */

void printTree(BST* tree)
{
    printf("\n%s\n", "Current tree structure: ");
    printNodes(tree->root, 4);
    printf("\n");
}

void printNodes(Node* node, int spaces)
{
    int i;
    if (node != NULL)
    {
        printNodes(node->right, spaces + 10);
        for (i = 0; i < spaces; i++)
            printf(" ");
        printf("%f\n", node->value);
        printNodes(node->left, spaces + 10);
    }
}