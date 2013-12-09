%{
#include <stdio.h>
#define YYSTYPE double
%}

%token NUMBER
%left '+' '-'
%left '*' '/' '%'
%left UNARYMINUS

%%
list:
	| list '\n'
	| list expr '\n' { printf("\t%.8g\n", $2); }
	;
expr:	NUMBER { $$ = $1; }
	| expr '+' expr { $$ = $1 + $3; }
	| expr '-' expr { $$ = $1 - $3; }
	| expr '*' expr { $$ = $1 * $3; }
	| expr '/' expr { $$ = $1 / $3; }
	| expr '%' expr { $$ = $1 - ($1 / $3) * $3;}
	| '(' expr ')' { $$ = $2; }
	| '-' expr %prec UNARYMINUS { $$ = -$2; }
	| '+' expr %prec UNARYMINUS { $$ = $2; }
	;
%%

#include <ctype.h>

int lineno = 1;

int main()
{
	yyparse();
	return 0;
}

int yyerror(const char *s)
{
	fprintf(stderr, "%s near line %d\n", s, lineno);

	return 0;
}

int yylex()
{
	int c;

	while ((c = getchar()) == ' ' || c == '\t')
		;
	
	if (c == EOF)
		return 0;

	if (isdigit(c)) {
		ungetc(c, stdin);
		scanf("%lf", &yylval);
		return NUMBER;
	}

	if (c == '\n')
		lineno++;

	return c;
}
