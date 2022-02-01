.PHONY: all clean

all: compile-quil compile-protoquil print-chip-spec

TEST_SRCS=$(wildcard *.c)

all: $(TEST_SRCS:.c=)

%: %.c
	gcc $< -o $@ -lsbcl -lquilc -L../.. -I../..

clean:
	rm -f $(TEST_SRCS:.c=)
