#include "lab42.h"
int sum=0;

void insert(char name[20], char type[20], int num)
{
    strcpy(table[sum].name,name);
    strcpy(table[sum].type,type);
    table[sum].num=num;
    sum++;
}

int search(char name[20], int num)
{
    int i = 0;
    for(i = 0; i < sum; i ++)
    {
        if(!strcmp(name, table[i].name))
        {
            if((table[i].num == 0) && (num == 0))
            {
                return 1;
            }
            else if((table[i].num > 0) && (num > 0))
            {
                return 1;
            }
            else
            {

            }
        }
    }
    return 0;
}

char* getType(char *value,int num)
{
    char name[20];
    strcpy(name, value);
    int i = 0;
    for(i=0; i < sum; i ++)
    {
        if(!strcmp(name, table[i].name))
        {
	       if(((table[i].num == 0) && (num == 0)) || ((table[i].num > 0)&&(num > 0)))
           {
                return table[i].type;
           }
        }
    }
    return NULL;
}

int getNum(char *value)
{
    char name[20];
    strcpy(name,value);
    int i = 0;
    for(i = 0; i < sum; i ++)
    {
        if(!strcmp(name, table[i].name))
        {
            return table[i].num;
        }
    }
    return -1;
}

