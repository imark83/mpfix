#include <stdio.h>
#include <stdlib.h>

typedef unsigned long int *ubigint_t;
typedef unsigned long int *bigint_t;


void bigintInit (bigint_t *x, int size) {
	*x = (unsigned long int*) malloc (8*size);
	int i;
	for (i=0; i<size; i++)
		(*x)[i] = 0x0;
}


char ubigintAdd (ubigint_t *rop, ubigint_t op1, ubigint_t op2, int size);
char bigintAdd (ubigint_t *rop, ubigint_t op1, ubigint_t op2, int size);
char ubigintSub (ubigint_t *rop, ubigint_t op1, ubigint_t op2, int size);
char bigintSub (ubigint_t *rop, ubigint_t op1, ubigint_t op2, int size);
void ubigintMul (ubigint_t *roph, ubigint_t *ropl, ubigint_t op1, ubigint_t op2, int size);


void bigintMul (ubigint_t *roph, bigint_t *ropl, ubigint_t op1, ubigint_t op2, int size) {
	ubigint_t auxh, auxl;
	bigintInit (&auxh, size);
	bigintInit (&auxl, size);

	ubigintMul (&auxh, &auxl, op1, op2, size);
	if (op1[0]>>63 == 1)
		ubigintSub (&auxh, auxh, op2, size);
	if (op1[1]>>63 == 1)
		ubigintSub (&auxh, auxh, op1, size);

	int i;
	for (i=0; i<size; i++) {
		(*roph)[i] = auxh[i];
		(*ropl)[i] = auxl[i];
	}

	free (auxh);
	free (auxl);

}

char* ubigintToStringX (ubigint_t op, int size) {
	char *rop = (char*) malloc (16*size+3);
	int i;
	rop[0] = '0';
	rop[1] = 'x';
	for (i=0; i<size; i++)
		sprintf (16*i+2+rop, "%016lx", op[i]);
	op[16*size+2] = '\0';
	return rop;
}



int main () {
	unsigned long int a;
	ubigint_t xh, x, y, z;
	bigintInit (&xh, 3);
	bigintInit (&x, 3);
	bigintInit (&y, 3);
	bigintInit (&z, 3);
	y[0] = 0x0;
	y[1] = 0x0;
	y[2] = 0x0;
	z[0] = 0x0;
	z[1] = 0x0;
	z[2] = 0x1;
	
	printf ("y = %s\n", ubigintToStringX (y,3));
	printf ("z = %s\n", ubigintToStringX (z,3));

	printf ("Unsigned carry = %hhi\n", ubigintSub (&x, y, z, 3));
	printf ("x = %s\n", ubigintToStringX (x,3));
	printf ("Signed overflow = %hhi\n", bigintSub (&x, y, z, 3));
	printf ("x = %s\n", ubigintToStringX (x,3));

	bigintMul (&xh, &x, y, z, 3);
	
	
	free (x);
	free (y);
	free (z);


}
