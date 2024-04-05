%{
#include "tree.h"
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <getopt.h> 
int yylex();
void yyerror(char *msg);
extern int linero;
extern int colono;
int tree = 0;
%}

%union {
    char byte;  // Reconnait "+", "-", "%", "*", "/"
    int num;
    char ident[64];
    char comp[2]; // Reconnait "==", "!=", "&&", "||"
    char charac[5];  // Reconnait les caractères litteraux
    char type[4];  // Reconnait "int, void, char ..."
    Node *node;
}

%expect 1
%type <node> Prog DeclVars Declarateurs Declarateur TableauDeclarateur AfterP TableauP DeclFoncts DeclFonct EnTeteFonct
%type <node> Parametres ListTypVar Corps SuiteInstr Instr Exp TB FB M E T F LValue Table Arguments
%type <node> ListExp
%token <byte>  ADDSUB DIVSTAR
%token <charac> CHARACTER
%token <num> NUM
%token <ident> IDENT VOID RETURN IF ELSE WHILE
%token <comp> ORDER EQ OR AND
%token <type> TYPE

%%
Prog:  DeclVars DeclFoncts { if(tree == 1){ $$ = makeNode(program); addChild($$, $1); addChild($$, $2); printTree($$);}  }
    ;
DeclVars:
       DeclVars TYPE Declarateurs ';'{
        Node *i = makeNode(type);
        strcpy(i->data.type, $2);
        addChild(i, $3);
        addChild($1, i);
        $$ = $1;
    }
    | { $$ = makeNode(declvars); }
    ;

Declarateurs:
       Declarateurs ',' Declarateur {addSibling($1, $3); $$ = $1; }
    |  Declarateur { $$ = $1; }
    ;
Declarateur:
      IDENT {
    		Node *i = makeNode(id);
    		strcpy(i->data.ident, $1);
    		$$=i;
    }
    | IDENT TableauDeclarateur {
    	Node *i = makeNode(id);
		strcpy(i->data.ident, $1);
		addChild(i, $2);
		$$ = i;
	}
    ;
TableauDeclarateur:
    '[' NUM ']' {
    	Node *numNode = makeNode(num);
		numNode->data.num = $2;
		$$ = numNode;
	}
    ;
DeclFoncts:
       DeclFoncts DeclFonct { addChild($1, $2); $$ = $1; }
    |  DeclFonct { $$ = makeNode(declfoncts); addChild($$, $1); }
    ;
DeclFonct:
       EnTeteFonct Corps {
			$$ = makeNode(declfonct);
       		addChild($$, $1);
       		addChild($$, $2);
       }
    ;
EnTeteFonct:
       TYPE IDENT '(' Parametres ')'{
       		$$ = makeNode(entetefonct);
        	Node *i = makeNode(type);
        	Node *j = makeNode(id);
        	strcpy(j->data.ident, $2);
        	strcpy(i->data.type, $1);
        	addChild($$, i);
        	addChild($$, j);
        	addChild($$, $4);
    	}
    |  VOID IDENT '(' Parametres ')' {
    		$$ = makeNode(entetefonct);
    		Node *i = makeNode(type);
        	Node *j = makeNode(id);
        	strcpy(j->data.ident, $2);
        	strcpy(i->data.type, $1);
        	addChild($$, i);
        	addChild($$, j);
        	addChild($$, $4);
    	}
    ;
Parametres:
       VOID {
       		$$ = makeNode(parametres);
       		Node *i = makeNode(type);
       		strcpy(i->data.type, $1);
       		addChild($$, i);
       }
    |  ListTypVar { $$ = makeNode(parametres); addChild($$, $1); }
    ;
ListTypVar:
       ListTypVar ',' AfterP { addSibling($1, $3); $$ = $1; }
    |  AfterP { $$ = $1; }
    ;
AfterP:
       TYPE IDENT  {
    		$$ = makeNode(listtypvar);
    		Node *j = makeNode(type);
    		Node *i = makeNode(id);
    		strcpy(i->data.ident, $2);
       		strcpy(j->data.type, $1);
       		addChild(j, i);
       		$$ = j;
   		}
     | TYPE IDENT TableauP {
    		$$ = makeNode(listtypvar);
    		Node *j = makeNode(type);
    		Node *i = makeNode(id);
    		strcpy(i->data.ident, $2);
       		strcpy(j->data.type, $1);
       		addChild(j, i);
       		$$ = j;
   		}
	  ;
TableauP:
       '['']'  { $$ = NULL; }
    ;
Corps: '{' DeclVars SuiteInstr '}' {
			$$ = makeNode(corps);
			if($2 != NULL) addChild($$, $2);
			addChild($$, $3);
		}
    ;
SuiteInstr:
       SuiteInstr Instr { addChild($1, $2); $$ = $1;}
    |  { $$ = makeNode(suiteinstr); }
    ;
Instr:
       LValue '=' Exp ';' {
       		Node *i = makeNode(type);
			i->data.byte='=';
			addChild(i, $1);
			addChild(i, $3);
			$$ = i; }
    |  IF '(' Exp ')' Instr {
    		Node *i = makeNode(type);
			strcpy(i->data.ident, $1);
			addChild(i, $3);
			addChild(i, $5);
			$$ = i; }
    |  IF '(' Exp ')' Instr ELSE Instr {
    		Node *i = makeNode(type);
			Node *j = makeNode(type);
			strcpy(i->data.ident, $1);
			strcpy(j->data.ident, $6);
			addChild(i, $3);
			addChild(i, $5);
			//addChild(j, $7);
			addChild(i, $7);
			$$ = i; }
    |  WHILE '(' Exp ')' Instr {
    		Node *i = makeNode(type);
			strcpy(i->data.type, $1);
			addChild(i, $3);
			addChild(i, $5);
			$$ = i; }
    |  IDENT '(' Arguments  ')' ';' {
    		Node *i = makeNode(type);
			strcpy(i->data.ident, $1);
			addChild(i, $3);
			$$ = i; }
    |  RETURN Exp ';' {
    		Node *i = makeNode(type);
			strcpy(i->data.ident, $1);
			addChild(i, $2);
			$$ = i; }
    |  RETURN ';' {
    		Node *i = makeNode(type);
			strcpy(i->data.ident, $1);
			$$ = i; }
    |  '{' SuiteInstr '}' { $$ = $2; }
    |  ';' { $$ = NULL; }
    ;
Exp :  Exp OR TB {
			Node * i = makeNode(comp);
			strcpy(i->data.comp, $2);
			addChild(i, $1);
			addChild(i, $3);
			$$ = i; }
    |  TB   { $$ = $1;  }
    ;
TB  :  TB AND FB {
			Node *i = makeNode(comp);
			strcpy(i->data.comp, $2);
			addChild(i, $1);
			addChild(i, $3);
			$$ = i; }
    |  FB   { $$ = $1; }
    ;
FB  :  FB EQ M {
			Node *i = makeNode(comp);
			strcpy(i->data.comp, $2);
			addChild(i, $1);
			addChild(i, $3);
			$$ = i; }
    |  M  { $$ = $1; }
    ;
M   :  M ORDER E {
			Node *i = makeNode(comp);
			strcpy(i->data.comp, $2);
			addChild(i, $1);
			addChild(i, $3);
			$$ = i; }
    |  E  { $$ = $1; }
    ;
E   :  E ADDSUB T  {
			Node *i = makeNode(byte);
			i->data.byte = $2;
			addChild(i, $1);
			addChild(i, $3);
			$$ = i; }
    |  T  { $$ = $1; }
    ;
T   :  T DIVSTAR F  {
			Node *i = makeNode(byte);
			i->data.byte = $2;
			addChild(i, $1);
			addChild(i, $3);
			$$ = i; }
    |  F  { $$ = $1; }
    ;
F   :  ADDSUB F {
			Node *i = makeNode(byte);
			i->data.byte = $1;
			addChild(i, $2);
			$$ = i; }
    |  '!' F {
    		Node *i = makeNode(byte);
    		i->data.byte = '!';
    		addChild(i, $2);
    		$$ = i; }
    |  '(' Exp ')'  { $$ = $2; }
    |  NUM  { Node *i = makeNode(num); i->data.num = $1; $$ = i; }
    |  CHARACTER  {
    		Node *i = makeNode(charac);
    		strcpy(i->data.charac , $1);
    		$$ = i; }
    |  LValue { $$ = $1; }
    |  IDENT '(' Arguments  ')' {
    		Node *i = makeNode(id);
    		strcpy(i->data.ident, $1);
    		addChild(i, $3);
    		$$ = i; }
    ;
LValue:
       IDENT Table  {
       		Node *i = makeNode(id);
       		strcpy(i->data.ident, $1);
       		if($2 != NULL) { addChild(i, $2); }
       		$$=i; }
    ;
Table:
      '[' Exp ']' { $$ = $2; }
    | { $$ = NULL; }
    ;
Arguments:
       ListExp { $$ = makeNode(argument); addChild($$, $1); }
    |	{ $$ = makeNode(argument); }
    ;
ListExp:
       ListExp ',' Exp  { addSibling($1, $3); $$ = $1; }
    |  Exp  { $$ = $1; }
    ;
%%

void yyerror(char *msg){
    fprintf(stdout, "%s line %d column %d\n", msg, linero, colono);
}

void printHelp() {
    printf("Usage: ./tpcas [OPTIONS] [FILE.tpc]\n");
    printf("Options:\n");
    printf("  -t, --tree    Affiche l'arbre abstrait\n");
    printf("  -h, --help    Affiche cette aide et termine l'exécution\n");
}

