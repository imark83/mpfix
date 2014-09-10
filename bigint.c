#include <stdlib.h>
#include <stdio.h>
#include "bigint.h"

void bigintInit (bigint_t *x, int size) {
	*x = (unsigned long int*) malloc (8*size);
	int i;
	for (i=0; i<size; i++)
		(*x)[i] = 0x0;
}

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

