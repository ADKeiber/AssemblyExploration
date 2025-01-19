#include <stdio.h>

extern int test(int, int); //NOTE: This is required in order for external things to access this method

int test(int a, int b) {
	printf("HERE!\n");
	return a + b;
}
