%{
	#include "lex.yy.c" 
	#include <stdlib.h>
	#include "lab41.h"
	#include "lab42.h"
%}
%union {
	struct Node *node;
}

%token <node> TYPE INT FLOAT
%token <node> STRUCT RETURN IF ELSE WHILE
%token <node> SEMI COMMA LP RP LB RB LC RC
%token <node> PLUS MINUS STAR DIV AND OR DOT ASSIGNOP NOT RELOP
%token <node> ID

%right ASSIGNOP
%left OR
%left AND
%left RELOP
%left PLUS MINUS
%left STAR DIV
%right NOT
%left DOT LP RP LB RB

%type <node> Program ExtDefList ExtDef ExtDecList Specifier StructSpecifier OptTag Tag VarDec FunDec VarList ParamDec CompSt StmtList Stmt DefList Def DecList Dec Exp Args

%%
//High-level Definitions

Program: ExtDefList {$$ = newNode("Program", NULL,NULL,-1, 1, $1);}
;

ExtDefList: ExtDef ExtDefList {$$ = newNode("ExtDefList", NULL,NULL,-1, 2, $1, $2); }
	|ExtDef {$$ = newNode("ExtDefList", NULL,NULL,-1, 1, $1); }
;

ExtDef: Specifier ExtDecList SEMI {$$ = newNode("ExtDef", NULL,NULL,-1, 3, $1, $2, $3); $2->type=$1->type;}
	| Specifier SEMI {$$ = newNode("ExtDef", NULL,NULL,-1, 2, $1, $2); }
	| Specifier FunDec CompSt {$$ = newNode("ExtDef", NULL,NULL,-1, 3, $1, $2, $3);$2->type = $1->type; $2->firstChild->type=$1->type; ErrorType4($2->firstChild);  ErrorType8($3,$1->type);}
;

ExtDecList: VarDec {$$ = newNode("ExtDecList", NULL,NULL,-1, 1, $1); }
	| VarDec COMMA ExtDecList {$$ = newNode("ExtDecList", NULL,NULL,-1, 3, $1, $2, $3); }
;

//Specifiers

Specifier: TYPE {$$ = newNode("Specifier", NULL,NULL,-1, 1, $1); $$->type=$1->type;}
	| StructSpecifier {$$ = newNode("Specifier", NULL,NULL,-1, 1, $1); }
;

StructSpecifier: STRUCT OptTag LC DefList RC {$$ = newNode("StructSpecifier", NULL,NULL,-1, 5, $1, $2, $3, $4, $5); $$->type=$2->type;}
	| STRUCT Tag {$$ = newNode("StructSpecifier", NULL,NULL,-1, 2, $1, $2);$$->type=$2->type; }
;

OptTag: ID {$$ = newNode("OptTag", NULL,NULL,-1, 1, $1); $$->type=$1->type;}
	| {$$=newNode("OptTag", NULL,NULL,-1,0);}
;

Tag: ID {$$ = newNode("Tag", NULL,NULL,-1, 1, $1); $$->type=$1->type;}
;

//Declarators

VarDec: ID { $$ = newNode("VarDec", NULL,NULL,-1, 1, $1);}
	| VarDec LB INT RB {$$ = newNode("VarDec", NULL,NULL,-1, 4, $1, $2, $3, $4);}
;

FunDec: ID LP VarList RP {$$ = newNode("FunDec", NULL,NULL,-1, 4, $1, $2, $3, $4);  $$->value = $1->value; }
	| ID LP RP {$$ = newNode("FunDec", NULL,NULL,-1, 3, $1, $2, $3); $$->value = $1->value; }
;

VarList: ParamDec COMMA VarList {$$ = newNode("VarList", NULL,NULL,-1, 3, $1, $2, $3); }
	|ParamDec {$$ = newNode("VarList", NULL,NULL,-1, 1, $1); }
;

ParamDec: Specifier VarDec {$$ = newNode("ParamDec", NULL,NULL,-1, 2, $1, $2);$2->type=$1->type; type_transfer($2); ErrorType3($2); }
;

//Statements
CompSt: LC DefList StmtList RC {$$ = newNode("CompSt", NULL,NULL,-1, 4, $1, $2, $3, $4); }
;

StmtList: Stmt StmtList {$$ = newNode("StmtList", NULL,NULL,-1, 2, $1, $2); }
	| {$$=newNode("StmtList", NULL,NULL,-1,0);}
;

Stmt: Exp SEMI {$$ = newNode("Stmt", NULL,NULL,-1, 2, $1, $2); }
	|error SEMI {yyerrok;}
	| CompSt {$$ = newNode("Stmt", NULL,NULL,-1, 1, $1); }
	| RETURN Exp SEMI {$$ = newNode("Stmt", NULL,NULL,-1, 3, $1, $2, $3); $1->type=$2->type;}
	| IF LP Exp RP Stmt {$$ = newNode("Stmt", NULL,NULL,-1, 4, $1, $2, $3, $4, $5); }
	| IF LP Exp RP Stmt ELSE Stmt {$$ = newNode("Stmt", NULL,NULL,-1, 7, $1, $2, $3, $4, $5, $6, $7); }
	| WHILE LP Exp RP Stmt {$$ = newNode("Stmt", NULL,NULL,-1, 5, $1, $2, $3, $4, $5); }
;

//Local Definitions
DefList: Def DefList {$$ = newNode("DefList", NULL,NULL,-1, 2, $1, $2); }
	| {$$=newNode("DefList", NULL,NULL,-1,0);}
;

Def: Specifier DecList SEMI {$$ = newNode("Def", NULL,NULL,-1, 3, $1, $2, $3); $2->type=$1->type; type_transfer($2); ErrorType3($2);}
;

DecList: Dec {$$ = newNode("DecList", NULL,NULL,-1, 1, $1); }
	| Dec COMMA DecList {$$ = newNode("DecList", NULL,NULL,-1, 3, $1, $2, $3); }
;

Dec: VarDec {$$ = newNode("Dec", NULL,NULL,-1, 1, $1);  }
	| VarDec ASSIGNOP Exp {$$ = newNode("Dec", NULL,NULL,-1, 3, $1, $2, $3); }
;

//Expressions

Exp: Exp ASSIGNOP Exp {$$ = newNode("Exp", NULL,NULL,-1, 3, $1, $2, $3);ErrorType56($1,$3,$2); printf("%s    %s    %s    %s    \n",":=", $3->value, "\\", $1->value);}
	| Exp AND Exp {$$ = newNode("Exp", NULL,NULL,-1, 3, $1, $2, $3); }
	| Exp OR Exp {$$ = newNode("Exp", NULL,NULL,-1, 3, $1, $2, $3);  }
	| Exp RELOP Exp {$$ = newNode("Exp", NULL,NULL,-1, 3, $1, $2, $3); }
	| Exp PLUS Exp {$$ = newNode("Exp", NULL,NULL,-1, 3, $1, $2, $3); ErrorType7($1,$3,$2); add_t($$);printf("%s    %s    %s    %s    \n", "+", $1->value, $3->value, $$->value);}
	| Exp MINUS Exp {$$ = newNode("Exp", NULL,NULL,-1, 3, $1, $2, $3); ErrorType7($1,$3,$2); add_t($$);printf("%s    %s    %s    %s    \n", "-", $1->value, $3->value, $$->value);}
	| Exp STAR Exp {$$ = newNode("Exp", NULL,NULL,-1, 3, $1, $2, $3); ErrorType7($1,$3,$2);add_t($$);printf("%s    %s    %s    %s    \n", "*", $1->value, $3->value, $$->value);}
	| Exp DIV Exp {$$ = newNode("Exp", NULL,NULL,-1, 3, $1, $2, $3); ErrorType7($1,$3,$2);add_t($$);printf("%s    %s    %s    %s    \n", "/", $1->value, $3->value, $$->value);}
	| LP Exp RP {$$ = newNode("Exp", NULL,NULL,-1, 3, $1, $2, $3); }
	| MINUS Exp {$$ = newNode("Exp", NULL,NULL,-1, 2, $1, $2); }
	| NOT Exp {$$ = newNode("Exp", NULL,NULL,-1, 2, $1, $2); }
	| ID LP Args RP {$$ = newNode("Exp", NULL,NULL,-1, 4, $1, $2, $3, $4); $$->type=getType($1->value,1); ErrorType2($1); ErrorType9($1,$3);}
	| ID LP RP {$$ = newNode("Exp", NULL,NULL,-1, 3, $1, $2, $3); $$->type=getType($1->value,1); ErrorType2($1); } 
	| Exp LB Exp RB {$$ = newNode("Exp", NULL,NULL,-1, 4, $1, $2, $3, $4); }
	| Exp DOT ID {$$ = newNode("Exp", NULL,NULL,-1, 3, $1, $2, $3); }
	| ID {$$ = newNode("Exp", NULL,NULL,-1, 1, $1); ErrorType1($1); $1->type=getType($1->value,0); $$->type=$1->type; $$->value = $1->value;}
	| INT {$$ = newNode("Exp", NULL,NULL,-1, 1, $1); $$->type=$1->type;  $$->value = $1->value;}
	| FLOAT {$$ = newNode("Exp", NULL,NULL,-1, 1, $1); $$->type=$1->type; $$->value = $1->value;}
;

Args: Exp COMMA Args {$$ = newNode("Args", NULL,NULL,-1, 3, $1, $2, $3); }
	| Exp {$$ = newNode("Args", NULL,NULL,-1, 1, $1); }
;

%%
int main(int argc, char** argv) {
	if(argc>1){
		if(!(yyin=fopen(argv[1],"r"))){
	            	perror(argv[1]);
			return 1;
		}
	}
    return yyparse();
}