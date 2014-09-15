#include <stdio.h>
#include <stdlib.h>
#include "bigint.h"



void bigintRand (bigint_t op, int size) {
	int k;
	for (k=0; k<size; k++) op[k] = ((long int) rand() << 32) + rand();
}




char* ubigintToString (ubigint_t op, int size) {
	int decSize = ((64*size * 301029995663981)/1000000000000000) + 1;
	char *rop = (char*) malloc (decSize+1);
	int i;
	ubigint_t copy, q, r, d;
	bigintInit (&copy, size);
	bigintInit (&r, size);
	bigintInit (&d, size);
	bigintInit (&q, size);
	d[size-1] = 0xa;
	for (i=0; i<size; i++) copy[i] = op[i];

	for (i=0; i<decSize; i++) rop[i] = ' ';

	for (i=0; i<decSize; i++) {
		if (i==22)
			printf ("caca\n");
		ubigintDiv (copy, r, copy, d, size);
		rop[decSize-i-1] = r[size-1] + '0';
	}
	rop[decSize] = '\0';


	free (copy);
	free (r);
	free (d);

	return rop;
}


int main () {
	srand(1239);
	int size = 3;
	int k;
	ubigint_t x, y, q, r;
	bigintInit (&x, size);
	bigintInit (&y, size);
	bigintInit (&q, size);
	bigintInit (&r, size);


	x[2] = 0x003a15ebd0538d18;
	y[2] = 0xa;

	ubigintDiv (q, r, x, y, size);

	printf ("x = %s\n", ubigintToStringX (x, size));
	printf ("y = %s\n", ubigintToStringX (y, size));
	printf ("q = %s\n", ubigintToStringX (q, size));
	printf ("r = %s\n", ubigintToStringX (r, size));

	free (x);
	free (y);
	free (q);
	free (r);
	


}
