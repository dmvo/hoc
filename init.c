#include <math.h>
#include <stdlib.h>

#include "hoc.h"

static struct {
	const char *name;
	double val;
} consts[] = {
	{ "PI", 3.14159265358979323846 },
	{ "E", 2.71828182845904523536 },
	{ "GAMMA", 0.577215664901532860607 },
	{ "PHI", 1.61803398874989484820 },
	{ "DEG", 57.2957795 },
	{ NULL, 0.0 },
};

static struct {
	const char *name;
	double (*ptr)();
} builtins[] = {
	{ "sin", sin },
	{ "cos", cos },
	{ "atan", atan },
	{ "log", Log },
	{ "log10", Log10 },
	{ "exp", Exp },
	{ "sqrt", Sqrt },
	{ "int", integer },
	{ "abs", fabs },
	{ NULL, NULL },
};

void init(void)
{
	int i;
	struct symbol s;

	// FIXME add proper symbol types

	for (i = 0; consts[i].name; i++)
		install(consts[i].name, 0, consts[i].val);

	for (i = 0; builtins[i].name; i++) {
		struct symbol *s;
		s = install(builtins[i].name, 0, 0.0);
		s->u.ptr = builtins[i].ptr;
	}
}
