%{
	#include <stdio.h>
	#include <stdlib.h>
	#include "lab4.tab.h"
	#include "lab41.h"
	#include "lab42.h"
%}
%option yylineno noyywrap
FLOAT1 [0-9]+"."[0-9]+
FLOAT2 ({INT}|{FLOAT1})[Ee][+-]?[0-9]+
FLOAT {FLOAT1}|{FLOAT2}
BINT 0|[1-9][0-9]*
OCT [+-]?0[0-7]+
HEX [+-]?0[xX][0-9A-Fa-f]+
INT {BINT}|{OCT}|{HEX}
ID [_A-Za-z][A-Za-z0-9]*
ILID ({BINT}|{FLOAT1})[A-Za-z_][A-Za-z_0-9]*
%%
{INT} { yylval.node = newNode("INT",yytext,"int",yylineno,0); return INT;}
{FLOAT} {yylval.node = newNode("FLOAT",yytext,"float",yylineno,0); return FLOAT;}
({INT}|{FLOAT1})[Ee][+-]?[A-Za-z_]* {printf("Error type A at line %d: Illegal FLOAT \" %s \".\n", yylineno, yytext);};
[+-]?0[xX][0-9A-Fa-f]*[g-zG-Z]+[0-9A-Za-z]* {printf("Error type A at line %d: Illegal HEX \" %s \".\n", yylineno, yytext);}
[+-]?0[0-7]*[89a-zA-Z]+[0-9A-Za-z]* {printf("Error type A at line %d: Illegal OCT \" %s \".\n", yylineno, yytext);}
"int" {yylval.node = newNode("TYPE",NULL,"int",yylineno,0); return TYPE ;}
"float" {yylval.node = newNode("TYPE",NULL,"float",yylineno,0); return TYPE ;}
"struct" {yylval.node = newNode("STRUCT",NULL,NULL,yylineno,0); return STRUCT ;}
"return" {yylval.node = newNode("RETURN",NULL,NULL,yylineno,0); return RETURN;}
"if" {yylval.node = newNode("IF",NULL,NULL,yylineno,0); return IF;}
"else" {yylval.node = newNode("ELSE",NULL,NULL,yylineno,0); return ELSE;}
"while" {yylval.node = newNode("WHILE",NULL,NULL,yylineno,0); return WHILE;}
{ID} {yylval.node = newNode("ID",yytext,NULL,yylineno,0); return ID;}
{ILID} {printf("Error type A at line %d: Illegal ID \" %s \".\n", yylineno, yytext);}
"+" {yylval.node = newNode("PLUS",NULL,NULL,yylineno,0); return PLUS;}
"-" {yylval.node = newNode("MINUS",NULL,NULL,yylineno,0); return MINUS;}
"*" {yylval.node = newNode("STAR",NULL,NULL,yylineno,0); return STAR;}
"/" {yylval.node = newNode("DIV",NULL,NULL,yylineno,0); return DIV;}
"." {yylval.node = newNode("DOT",NULL,NULL,yylineno,0); return DOT;}
"!" {yylval.node = newNode("NOT",NULL,NULL,yylineno,0); return NOT;}
"&&" {yylval.node = newNode("AND",NULL,NULL,yylineno,0); return AND;}
"||" {yylval.node = newNode("OR",NULL,NULL,yylineno,0); return OR;}
";" {yylval.node = newNode("SEMI",NULL,NULL,yylineno,0); return SEMI;}
"," {yylval.node = newNode("COMMA",NULL,NULL,yylineno,0); return COMMA;}
"=" {yylval.node = newNode("ASSIGNOP",NULL,NULL,yylineno,0); return ASSIGNOP;}
"(" {yylval.node = newNode("LP",NULL,NULL,yylineno,0); return LP;}
")" {yylval.node = newNode("RP",NULL,NULL,yylineno,0); return RP;}
"{" {yylval.node = newNode("LC",NULL,NULL,yylineno,0); return LC;}
"}" {yylval.node = newNode("RC",NULL,NULL,yylineno,0); return RC;}
"[" {yylval.node = newNode("LB",NULL,NULL,yylineno,0); return LB;}
"]" {yylval.node = newNode("RB",NULL,NULL,yylineno,0); return RB;}  
">"|"<"|">="|"<="|"=="|"!=" {yylval.node = newNode("RELOP",NULL,NULL,yylineno,0); return RELOP;}
[ \t\n]+ { }
"//" {char c; while((c = input()) && c != '\n') ;}
"/*" {char c, c1, c2; int line = yylineno;
	c1 = input();
	while((c2 = input()) && (c1 != '*' || c2 != '/'))
	{
		c1 = c2;
		if(c1 == EOF || c2 ==EOF)
			{printf("Error type A at line %d:\" /* \" can not find one matching \" */ \".\n", line); break; }
	}	}
"*/" {printf("Error type A at line %d: We can not find one \" /* \" before \" */ \".\n", yylineno);}
. {printf("Error type A at line %d: Myterious character \"%s\"\n",yylineno,yytext);}


%%
void yyerror(char *s)
{
	//fprintf(stderr, "Error type B at line %d \n", yylineno);
}





