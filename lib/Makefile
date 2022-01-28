.PHONY: all clean

all: libquilc.dylib

libquilc.core libquilc.c libquilc.h libquilc.py: libquilc.lisp
	sbcl --load "libquilc.lisp"

libquilc.dylib: libquilc.core libquilc.c
	gcc -dynamiclib -o $@ libquilc.c -lsbcl

example: example.c libquilc.dylib
	gcc example.c -o example -lsbcl -lquilc -L.

clean:
	rm -f libquilc.c libquilc.h libquilc.core libquilc.py libquilc.dylib example
