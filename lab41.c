#include "lab41.h"
#include "lab42.c"
int number=0;
int count=0;
int count_temp = 1;
struct Node *newNode(char* name, char* value, char* type, int lineno, int count, ...)
{
	va_list args;
	va_start(args,count);
    char *val = NULL;
	char *tp = NULL;
	if(value)
	{
		val = malloc(strlen(value));
		strcpy(val, value);
	}
	if(type)
	{
		tp = malloc(strlen(type));
		strcpy(tp, type);
	}
	struct Node *root = malloc(sizeof(struct Node));
	root->name = name;
	root->value = val;
	root->type = tp;
	root->lineno = lineno;
	root->nextSibling = NULL;
	if(count)
	{
		struct Node *current;
		current = root->firstChild = va_arg(args, struct Node*);
		int i = 0;
		for(i = 1; i < count; i++)
		{
			current = current->nextSibling = va_arg(args, struct Node*);
		}
		current->nextSibling = NULL;
	}
	else
	{
		root->firstChild = NULL;
	}
	va_end (args);
	return root;
}

void type_transfer(struct Node *root)
{
	struct Node *current = root;
	if(root->firstChild != NULL)
	{
		current = root->firstChild;
		while(current != NULL)
		{
			if(current->type == NULL)
			{
				current->type = root->type;
			}
			type_transfer(current);
			if(current->value == NULL)
			{
				current->type = NULL;
			}
			current = current->nextSibling; 	
		}
	}
}

// Undefined variable
void ErrorType1(struct Node *root)
{
	struct Node *current = root;
	if(current != NULL && current->value != NULL)
	{	
		char value[20];
		char type[20];
		strcpy(value, current->value);
		if(!search(value,0))
		{
			printf("Error type B at line %d: Undefined variable '%s'.\n",current->lineno,current->value);
		}
	}
	else if(root->firstChild != NULL)
	{
		current = root->firstChild;
		while(current != NULL)
		{
			if(current->value!=NULL)
			{	
				char value[20];
				char type[20];
				strcpy(value, current->value); 
				strcpy(type, current->type);
				if(!search(value,0))
				{
					printf("Error type B at line %d: Undefined variable '%s'.\n",current->lineno,current->value);
				}
			}
			ErrorType1(current);
			current = current->nextSibling;
		} 	
	}
}

//Undefined function 
void ErrorType2(struct Node* root)
{
	if(ErrorType11(root))
	{ 
		char value[20];
		strcpy(value, root->value);
		if(!search(value, 1))
		{
			printf("Error type B at line %d: Undefined function '%s'.\n",root->lineno, root->value);
		}
	}
}

//Redefined variable 
void ErrorType3(struct Node* root)
{
	struct Node *current = root;
	if(root->firstChild != NULL)
	{
		current = root->firstChild;
		while(current != NULL)
		{
			if(current->value!=NULL)
			{	
				char value[20];
				char type[20];
				strcpy(type, current->type);
				strcpy(value, current->value);
				if(!strcmp("ID", current->name))
				{
					if(!search(value, 0))
					{
						insert(value, type, 0);
					}
				    else 
				    {
				    	printf("Error type B at line %d: Redefined variable '%s'.\n",current->lineno,current->value);
				    }
				}
			}
			ErrorType3(current);
			current = current->nextSibling; 	
		}
	}
}

void get_fun_num(struct Node* root)
{
	struct Node*current;
	if(root->firstChild != NULL)
	{
		current = root->firstChild;
		while(current != NULL)
		{
			if(!strcmp(current->name,"ID"))
			{
				number++;
			}
			get_fun_num(current);
			current = current->nextSibling; 	
		}
	}
}

//Redefined function 
void ErrorType4(struct Node* root)
{
    char value[20];
	char type[20];
	strcpy(value,root->value); 
	strcpy(type, root->type);
	struct Node* current = root->nextSibling->nextSibling;
	number=0;
	get_fun_num(current);
	//int sum=number;
	if(!search(value, 1))
	{
		insert(value,type,number);
	}
	else 
	{
		printf("Error type B at line %d: Redefined function '%s'.\n", root->lineno,root->value);
	}
}

//The left-hand side of an assignmen must be variable.
//Type mismatched for assignment.
void ErrorType56(struct Node* root1, struct Node* root2, struct Node* op)
{
	root1->type = root1->firstChild->type;
    root2->type = root2->firstChild->type;
	char name[20];
	char temp1[20];
	char temp2[20];
	strcpy(temp1, root1->type);
	strcpy(temp2, root2->type);
	if(root1->type = NULL) 
	{
		return ;
	}
	else if(strcmp(root1->firstChild->name, "ID"))
	{
		printf("Error type B at line %d: The left-hand side of an assignmen must be variable.\n",op->lineno);
	}
	//else if(strcmp(root1->type, root2->type))
	else if(strcmp(temp1, temp2))
	{
		printf("Error type B at line %d: Type mismatched for assignment.\n",op->lineno);
	}
	else
	{

	}
}

// Type mismatched at for oprands.
void ErrorType7(struct Node* root1, struct Node* root2, struct Node* op)
{
	root1->type = root1->firstChild->type;	
	root2->type = root2->firstChild->type;		 
	if((root1->type != NULL) && (root2->type != NULL))
	{
		if(strcmp(root1->type, root2->type))
		{
			printf("Error type B at line %d: Type mismatched at for oprands.\n",op->lineno);
		}
	}
}

//Type mismatched for return.
void ErrorType8(struct Node* root, char *type)
{	
	struct Node* current;
	if(root->firstChild != NULL)
	{
		current = root->firstChild;
		while(current != NULL)
		{
			if(!strcmp(current->name,"RETURN"))
			{
				if(strcmp(current->type,type))
				{
					printf("Error type B at line %d: Type mismatched for return.\n",current->lineno);
				}
				break;
			}
			ErrorType8(current, type);
			current = current->nextSibling; 	
		}
	}
}

void get_args_number(struct Node* root)
{
	struct Node* current;
	if(root->firstChild != NULL)
	{
		current = root->firstChild;
		while(current != NULL)
		{
			if(!strcmp(current->name,"ID") || !strcmp(current->name,"INT") || !strcmp(current->name,"FLOAT"))
			{
				count++;	
			}			
			get_args_number(current);
			current = current->nextSibling; 	
		}
	}
}


// chaeck args number
void ErrorType9(struct Node* use, struct Node* def)
{ 
	count = 0;
	get_args_number(def);
	char name[20];
	strcpy(name, use->value);
	if(search(name, 1))
	{
		if(count != getNum(use->value))
		{
			printf("Error type B at line %d: Function '%s' use error.\n", use->lineno, use->value);
		}
	}
}

//use variable as fuction
int ErrorType11(struct Node* root)
{
	if(getNum(root->value) == 0)
	{   
        printf("Error type B at line %d: Use variable as function.\n", root->lineno, root->value); 
	    return 0;
    }
	else 
	{
		return 1;
	}
}

void add_t(struct Node* root)
{
	char *str = (char *)calloc(5, sizeof(char));
	sprintf(str,"%s%d", "t", count_temp);
	root->value = str;
	count_temp ++;
}