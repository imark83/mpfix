#include <stdlib.h>
#include <stdio.h>
#include "bigint.h"

void bigintInit (bigint_t *x, int size) {
	*x = (unsigned long int*) malloc (8*size);
	int i;
	for (i=0; i<size; i++)
		(*x)[i] = 0x0;
}

void bigintMul (ubigint_t roph, bigint_t ropl, ubigint_t op1, ubigint_t op2, int size) {
	ubigint_t auxh, auxl;
	char sgOp1 = op1[0]>>63 == 1;
	char sgOp2 = op2[0]>>63 == 1;
	bigintInit (&auxh, size);
	bigintInit (&auxl, size);

	ubigintMul (auxh, auxl, op1, op2, size);
	if (sgOp1)
		ubigintSub (auxh, auxh, op2, size);
	if (sgOp2)
		ubigintSub (auxh, auxh, op1, size);

	int i;
	for (i=0; i<size; i++) {
		roph[i] = auxh[i];
		ropl[i] = auxl[i];
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



void shl (ubigint_t rop, unsigned int op, int size) {
	int blocks = op / 64;
	int bits = op % 64;
	int k;
	// SHIFT BLOCKS
	if (blocks) {
		for (k=0; k<size-blocks; k++) rop[k] = rop[k+blocks];
		for (k=size-blocks; k<size; k++) 
			if (k >= 0) rop[k] = 0;
	}
	// SHIFT BITS. USE ASSEMBLER FUNCTION
	shl_asm (rop, op, size);
}



void ubigintDiv (ubigint_t rop, ubigint_t rem, ubigint_t op1, ubigint_t op2, int size) {
	// check if op2 == 1
	int j;
	if (op2[size-1] == 1) {
		char trivial = 1;
		for (j=0; j<size-1; j++)
			if (op2[j] != 0) {
				trivial = 0;
				break;
			}
		if (trivial)
			for (j=0; j<size; j++) {
				rop[j] = op1[j];
				rem[j] = 0;
			}
	}


	// compute inverse of rat(op2) = nat(C) + dec(D)
	char loop;
	ubigint_t c, d;
	ubigint_t aux2;
	ubigint_t aux4;
	ubigint_t next;
	bigintInit (&c, size);
	bigintInit (&d, size);
	bigintInit (&aux2, 2*size);
	bigintInit (&aux4, 4*size);
	bigintInit (&next, 4*size);
	// set aux2 = [0:op2]
	for (j=0; j<size; j++) {
		aux2[j] = 0;
		aux2[size+j] = op2[j];
	}
	// initialize c
	c[size-1] = 1;	


	for (j=0; j<size; j++) {
		next[j] = c[j];
		next[size+j] = d[j];
	}
	
	do {
		// STAGE 1
		for (j=0; j<size; j++) {
			next[2*size+j] = 0;
			next[3*size+j] = 0;
		}
		shl (next, 1, 4*size);

		// STAGE 2
		ubigintMul (aux4, aux4+size, d, d, size);
		ubigintMul (aux4, aux4+2*size, aux4, aux2, 2*size);
		ubigintSub (next, next, aux4, 4*size);

		// STAGE 3
		ubigintMul (aux4, aux4+size, c, d, size);
		ubigintMul (aux4, aux4+2*size, aux4, aux2, 2*size);
		shl (aux4, 64*size+1, 4*size);
		ubigintSub (next, next, aux4, 4*size);

		// STAGE 4
		ubigintMul (aux4, aux4+size, c, c, size);
		ubigintMul (aux4, aux4+2*size, aux4, aux2, 2*size);
		shl (aux4, 128*size, 4*size);
		ubigintSub (next, next, aux4, 4*size);


		// LOOP CONDITION
		loop = ubigintCmp (next, c, size) || ubigintCmp (next+size, d, size);


		// UPDATE VARIABLES
		for (j=0; j<size; j++) {
			c[j] = next[j];
			d[j] = next[size+j];
		}
	} while (loop);


	// NO FUNCIONA

	ubigintMul (aux4, aux4+size, op1, c, size);		// temporary rop
	ubigintMul (aux2, aux2+size, op1, d, size);		// temporary ropL

	// check if carry
	if (ubigintAdd (aux4+2*size, aux2, aux4+size, size)) {
		for (j=0; j<size-1; j++) 
			aux2[j] = 0;
		aux2[size-1] = 1;
		ubigintAdd (aux4, aux4, aux2, size);
	}
		

	ubigintMul (aux2, aux2+size, op2, aux4, size);
	ubigintSub (rem, op1, aux2+size, size);

	for (j=0; j<size; j++)
		rop[j] = aux4[j];


	free (c);
	free (d);
	free (aux2);
	free (aux4);
	free (next);

	return;
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


char* ubigintToStringX_ (ubigint_t op, int size) {
	char *rop = (char*) malloc (16*size+1);
	int i;
	for (i=0; i<size; i++)
		sprintf (16*i+rop, "%016lx", op[i]);
	rop[16*size] = '\0';
	return rop;
}

