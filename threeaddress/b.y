%{
#include <stdio.h>
#include <stdlib.h>
extern int yylex();
extern int yyparse();
extern FILE *yyin;
void yyerror(const char *s);
int temp_count = 0;
%}
%token NUMBER
%%
input:
 | input line
 ;
line:
 expr '\n' {
 printf("Generated Three Address Code: %d\n", $1);
 }
 ;
expr:
 NUMBER { $$ = $1; }
 | expr '+' expr {
 printf("t%d = t%d + t%d\n", ++temp_count, $1, $3);
 $$ = temp_count;
 }
 | expr '-' expr {
 printf("t%d = t%d - t%d\n", ++temp_count, $1, $3);
 $$ = temp_count;
 }
 | expr '*' expr {
 printf("t%d = t%d * t%d\n", ++temp_count, $1, $3);
 $$ = temp_count;
 }
 | expr '/' expr {
 printf("t%d = t%d / t%d\n", ++temp_count, $1, $3);
 $$ = temp_count;
 }
 | '(' expr ')' { $$ = $2; }
 ;
%%
void yyerror(const char *s) {
 printf("Error: %s\n", s);
}
int main() {
 printf("Enter an arithmetic expression followed by Enter:\n");
 yyin = stdin;
 yyparse();
 return 0;

}