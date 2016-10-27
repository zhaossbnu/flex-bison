#ifndef lab42_h
#define lab42_h

#include <stdio.h>
#include <string.h>

struct Table
{
    char name[20];
    char type[20];
    int num;
}table[200];

void insert(char name[20],char type[20],int num);

int search(char name[20],int num); 

char* getType(char *value,int num);

int getNum(char *value);

#endif
