#include <stdlib.h>
#include <string.h>

#include "hoc.h"

static struct symbol *head;

/*
 * Returns a pointer to the symbol with given name.
 */
struct symbol *lookup(const char *name)
{
	struct symbol *p;

	for (p = head; p; p = p->next)
		if (!strcmp(p->name, name))
			return p;

	return NULL;
}

/*
 * Installs a new element to the symbol table.
 */
struct symbol *install(const char *name, short type, double val)
{
	struct symbol *s;

	s = (struct symbol *)malloc(sizeof *s);

	s->name = malloc(strlen(name));
	strcpy(s->name, name);
	s->type = type;
	s->u.val = val;

	s->next = head;
	head = s;

	return s;
}
