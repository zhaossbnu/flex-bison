#ifndef lab41_h
#define lab41_h

#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>
#include <string.h>

struct Node{
	char *name;
	char *value;
	char *type;
	int lineno;
	struct Node *firstChild;
	struct Node *nextSibling;
};

struct Node *newNode(char *name, char *value, char *type, int lineno, int count,...);

void type_transfer(struct Node *root);

// Undefined variable
void ErrorType1(struct Node *root);

//Undefined function 
void ErrorType2(struct Node* root);

//Redefined variable 
void ErrorType3(struct Node* root);

//Redefined function 
void ErrorType4(struct Node* root);

//Type mismatched for assignment.
//The left-hand side of an assignmen must be variable.
void ErrorType56(struct Node* root1, struct Node* root2, struct Node* op);

// Type mismatched at for oprands.
void ErrorType7(struct Node* root1, struct Node* root2, struct Node* op);

//Type mismatched for return.
void ErrorType8(struct Node* root, char *type);

// chaeck args number
void ErrorType9(struct Node* def, struct Node* use);

//use variable as fuction
int ErrorType11(struct Node* root);

#endif
