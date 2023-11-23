Lex:
%{
#include <stdio.h>
#include "y.tab.h"
%}
%%
[0-9]+ { yylval = atoi(yytext); return NUMBER; }
[-+*/\(\)\n] { return *yytext; }
[ \t] ; // Ignore whitespace
. { /* ignore other characters */ }
%%
int yywrap() {
 return 1;
}
