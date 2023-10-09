%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}

%token IF ELSE WHILE FOR IDENTIFIER
%token LEFT_BRACE RIGHT_BRACE LEFT_PAREN RIGHT_PAREN SEMICOLON
%token INT_LITERAL

%start program

%%

program: /* empty */
       | program statement
       ;

statement: if_statement
         | while_statement
         | for_statement
         | other_statement
         ;

if_statement: IF LEFT_PAREN expression RIGHT_PAREN LEFT_BRACE program RIGHT_BRACE
            | IF LEFT_PAREN expression RIGHT_PAREN statement ELSE statement
            ;

while_statement: WHILE LEFT_PAREN expression RIGHT_PAREN LEFT_BRACE program RIGHT_BRACE
               ;

for_statement: FOR LEFT_PAREN other_statement SEMICOLON expression SEMICOLON other_statement RIGHT_PAREN LEFT_BRACE program RIGHT_BRACE
             ;

other_statement: SEMICOLON
               | expression SEMICOLON
               ;

expression: INT_LITERAL
          | IDENTIFIER
          | expression '+' expression
          | expression '-' expression
          | expression '*' expression
          | expression '/' expression
          | '(' expression ')'
          ;

%%

int yylex() {
    char token[100];
    int c = getchar();

    while (isspace(c)) {
        c = getchar();
    }

    if (isalpha(c)) {
        int i = 0;
        while (isalnum(c)) {
            token[i++] = c;
            c = getchar();
        }
        token[i] = '\0';

        if (strcmp(token, "if") == 0) {
            return IF;
        } else if (strcmp(token, "else") == 0) {
            return ELSE;
        } else if (strcmp(token, "while") == 0) {
            return WHILE;
        } else if (strcmp(token, "for") == 0) {
            return FOR;
        } else {
            yylval.sval = strdup(token);
            return IDENTIFIER;
        }
    }

    if (isdigit(c)) {
        int i = 0;
        while (isdigit(c)) {
            token[i++] = c;
            c = getchar();
        }
        token[i] = '\0';
        yylval.ival = atoi(token);
        return INT_LITERAL;
    }

    switch (c) {
        case '(':
            return LEFT_PAREN;
        case ')':
            return RIGHT_PAREN;
        case '{':
            return LEFT_BRACE;
        case '}':
            return RIGHT_BRACE;
        case ';':
            return SEMICOLON;
        case EOF:
            return 0;
        default:
            return c;
    }
}

void yyerror(const char *msg) {
    fprintf(stderr, "Parser error: %s\n", msg);
    exit(1);
}

int main() {
    yyparse();
    return 0;
}
