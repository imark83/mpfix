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


char ubigintCmp (ubigint_t op1, ubigint_t op2, int size) {
	int i;
	for (i=0; i<size; i++) { 
		if (op1[i] > op2[i]) return 1;
		if (op1[i] < op2[i]) return -1;
	}
	return 0;
}

char bigintCmp (bigint_t op1, bigint_t op2, int size) {
	char sign1 = (char) (op1[0] >> 63);
	char sign2 = (char) (op2[0] >> 63);
	if (sign1 == 1 && sign2 == 0) return -1;
	if (sign2 == 1 && sign1 == 0) return 1;
	return ubigintCmp (op1, op2, 3);

}



void shl (ubigint_t *rop, unsigned int op, int size) {
	int blocks = op / 64;
	int bits = op % 64;
	int k;
	// SHIFT BLOCKS
	if (blocks) {
		for (k=0; k<size-blocks; k++) (*rop)[k] = (*rop)[k+blocks];
		for (k=size-blocks; k<size; k++) 
			if (k >= 0) (*rop)[k] = 0;
	}
	// SHIFT BITS. USE ASSEMBLER FUNCTION
	shl_asm (rop, op, size);
}


char* ubigintToStringX (ubigint_t op, int size) {
	char *rop = (char*) malloc (16*size+3);
	int i;
	rop[0] = '0';
	rop[1] = 'x';
	for (i=0; i<size; i++)
		sprintf (16*i+2+rop, "%016lx", op[i]);
	rop[16*size+2] = '\0';
	return rop;
}

