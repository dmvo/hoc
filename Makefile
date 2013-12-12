all: hoc

hoc.o: hoc.c hoc.h
	cc -c hoc.c

hoc: hoc.o symbol.o

clean:
	-rm -f *.o hoc hoc.c
