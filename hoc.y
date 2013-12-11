%{
#include <stdio.h>

double mem[26];

double previous;

void execerror(const char *, const char *);
%}

%union {
	double val;
	int index;
}

%token <val> NUMBER
%token <val> PREVIOUS
%token <index> VAR
%type <val> expr
%right '='
%left '+' '-'
%left '*' '/' '%'
%left UNARYMINUS

%%

list    : /* nothing */
	| list delim
        | list expr delim {
		previous = $2;
		printf("\t%.8g\n", $2); }
	;
delim   : '\n'
        | ';'
	;
expr    : NUMBER { $$ = $1; }
	| PREVIOUS { $$ = previous; }
	| VAR { $$ = mem[$1]; }
	| VAR '=' expr { $$ = mem[$1] = $3; }
	| expr '+' expr { $$ = $1 + $3; }
	| expr '-' expr { $$ = $1 - $3; }
	| expr '*' expr { $$ = $1 * $3; }
	| expr '/' expr {
		if ($3 == 0.0)
			execerror("division by zero", NULL);
		$$ = $1 / $3; }
	| expr '%' expr { $$ = $1 - ($1 / $3) * $3;}
	| '(' expr ')' { $$ = $2; }
	| '-' expr %prec UNARYMINUS { $$ = -$2; }
	| '+' expr %prec UNARYMINUS { $$ = $2; }
	;

%%

#include <ctype.h>
#include <setjmp.h>

int lineno = 1;
char *progname;

jmp_buf begin;

int main(int argc, char *argv[])
{
	progname = argv[0];
	setjmp(begin);
	yyparse();
	return 0;
}

void warning(const char *s, const char *t)
{
	fprintf(stderr, "%s: %s", progname, s);
	fprintf(stderr, " near line %d\n", lineno);
}

void execerror(const char *s, const char *t)
{
	warning(s, t);
	longjmp(begin, 0);
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
		scanf("%lf", &yylval.val);
		return NUMBER;
	}

	if (c == 'p')
		return PREVIOUS;

	if (islower(c)) {
		yylval.index = c - 'a';
		return VAR;
	}

	if (c == '\n')
		lineno++;

	return c;
}
