%{
#include<stdio.h>
#include<ctype.h>
#include<stdlib.h>
%}
%token let dig
%%
TERM: XTERM '\n'
{
printf("\nAccepted\n");
exit(0);
}
|error
{
yyerror ("Rejected\n"); exit(0);
};
XTERM: XTERM let
| XTERM dig
| let
;
%%
main()
{
printf("Enter a variable:");
yyparse();
}
yylex()
{
char ch;
while((ch=getchar())==' ');
if(isalpha(ch))
return let;
if(isdigit(ch))
return dig;
return ch;
}
yyerror(char *s)
{
printf("%s",s);
}
