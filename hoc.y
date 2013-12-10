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
char *progname;

int main(int argc, char *argv[])
{
	progname = argv[0];
	yyparse();
	return 0;
}

void warning(const char *s, const char *t)
{
	fprintf(stderr, "%s: %s", progname, s);
	fprintf(stderr, " near line %d\n", lineno);
}

int yyerror(const char *s)
{
	warning(s, NULL);
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
