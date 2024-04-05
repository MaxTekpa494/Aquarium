%{
#include "tree.h"
#include "parser.h"
#include <stdio.h>
int linero = 1;
int colono = 0;
%}


%x c1 
%option nounput
%option noinput
%option noyywrap


%%
\n { linero++; colono = 0; }
[ \t\r]* {colono += yyleng; /* pas d'action */ }
"int"|"char" { colono += yyleng; strcpy(yylval.type, yytext); return TYPE; }
"void" { colono += yyleng; strcpy(yylval.type, yytext); return VOID; }
"while" { colono += yyleng; strcpy(yylval.ident, yytext); return WHILE; }
"else" { colono += yyleng; strcpy(yylval.ident, yytext); return ELSE; }
"if" { colono += yyleng; strcpy(yylval.ident, yytext); return IF; }
"return" { colono += yyleng; strcpy(yylval.ident, yytext); return RETURN; }
"<"|"<="|">"|">=" { colono += yyleng; strcpy(yylval.comp, yytext); return ORDER; }
[a-zA-Z_][a-zA-Z_0-9]* { colono += yyleng; strcpy(yylval.ident, yytext); return IDENT; }
"=" { colono += yyleng; yylval.byte = yytext[0]; return '='; }
"!="|"==" { colono += yyleng; strcpy(yylval.comp, yytext); return EQ; }
'.' { colono += yyleng; strcpy(yylval.charac, yytext); return CHARACTER; }
'\\n'   { colono += yyleng; strcpy(yylval.charac, yytext); return CHARACTER; }
'\\t'   { colono += yyleng; strcpy(yylval.charac, yytext); return CHARACTER; }
"(" { colono += yyleng; return '('; }
")" { colono += yyleng; return ')'; }
"{" { colono += yyleng; return '{'; }
"}" { colono += yyleng; return '}'; }
"[" { colono += yyleng; return '['; }
"]" { colono += yyleng; return ']'; }
[0-9]+ { colono += yyleng; yylval.num = atoi(yytext); return NUM; }
[-+] { colono += yyleng; yylval.byte = yytext[0]; return ADDSUB; }
[*/%] { colono += yyleng; yylval.byte = yytext[0]; return DIVSTAR; }
"||" { colono += yyleng; strcpy(yylval.comp, yytext); return OR; }
"&&" { colono += yyleng; strcpy(yylval.comp, yytext); return AND; }
";" { colono += yyleng; return ';'; }
"," { colono += yyleng; return ','; }
"!" { colono += yyleng; return '!'; }
[\/][\/].* ;
[/][*] BEGIN c1;
<c1>[*][/] BEGIN INITIAL;
<c1>(.|\n) ;
. { colono += yyleng; return yytext[0]; }
%%


