#include <stdio.h>
#include <stdlib.h>
#include "bigint.h"



void bigintRand (bigint_t *op, int size) {
	int k;
	for (k=0; k<size; k++) (*op)[k] = ((long int) rand() << 32) + rand();
}

void ubigintDiv (ubigint_t rop, ubigint_t rem, ubigint_t op1, ubigint_t op2, int size) {


}


int main () {
	ubigint_t x, y, z;
	int size = 1000;
	int k;

	bigintInit (&x, size);
	bigintInit (&y, size);
	bigintInit (&z, size);

	bigintRand (&x, size);
	bigintRand (&y, size);
	
	ubigintAdd (&z, x, y, size);
	printf ("z = %s\n", ubigintToStringX (z, size));
	for (k=0; k<1000; k++)
		ubigintAdd (&z, z, x, size);

	printf ("z = %s\n", ubigintToStringX (z, size));
	
	free (x);
	free (y);
	free (z);


}
