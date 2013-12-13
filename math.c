#include <errno.h>
#include <math.h>

#include "hoc.h"

double errcheck(double val, const char *msg)
{
	if (errno == EDOM) {
		errno = 0;
		execerror(msg, "domain error");
	} else if (errno == ERANGE) {
		errno = 0;
		execerror(msg, "result out of range");
	}
	return val;
}

double Pow(double x, double y)
{
	return errcheck(pow(x, y), "Pow");
}

double Exp(double x)
{
	return errcheck(exp(x), "Exp");
}

double Log(double x)
{
	return errcheck(log(x), "Log");
}

double Log10(double x)
{
	return errcheck(log10(x), "Log10");
}

double Sqrt(double x)
{
	return errcheck(sqrt(x), "Sqrt");
}

double integer(double x)
{
	return (double)(long)x;
}
