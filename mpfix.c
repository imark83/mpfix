#include <stdio.h>
#include <stdlib.h>

typedef unsigned long int *ubigint_t;
typedef unsigned long int *bigint_t;


void bigintInit (bigint_t *x, int size) {
	*x = (unsigned long int*) malloc (8*size);
	int i;
	for (i=0; i<size; i++)
		(*x)[i] = 0;
}


char ubigintAdd (ubigint_t *rop, ubigint_t op1, ubigint_t op2, int size);
char ubigintSub (ubigint_t *rop, ubigint_t op1, ubigint_t op2, int size);
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

int main () {
	unsigned long int a;
	ubigint_t xh, x, y, z;
	bigintInit (&xh, 3);
	bigintInit (&x, 3);
	bigintInit (&y, 3);
	bigintInit (&z, 3);
	y[0] = 0xdec052f5ad741c8f;
	y[1] = 0x87470892b0bf808a;
	y[2] = 0xd2ee751373c16add;
	z[0] = 0xde68d8aa8fe00965;
	z[1] = 0xe49073144c5db335;
	z[2] = 0x2beb817fad246b83;
	

	//ubigintSub (&y, z, y, 3);

	bigintMul (&xh, &x, y, z, 3);
	
	
	free (x);
	free (y);
	free (z);


}
