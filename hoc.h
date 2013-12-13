#ifndef _HOC_H
#define _HOC_H

struct symbol {
	char *name;
	short type; /* VAR, BUILTIN, UNDEF */
	union {
		double val;
		double (*ptr)();
	} u;

	struct symbol *next;
};

struct symbol *install(const char *, int, double);
struct symbol *lookup(const char *);

void execerror(const char *, const char *);

double Pow(double, double);
double Exp(double);
double Log(double);
double Log10(double);
double Sqrt(double);
double integer(double);
#endif
