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
void ubigintMul (ubigint_t *roph, ubigint_t ropl, ubigint_t op1, ubigint_t op2, int size);

int main () {
	unsigned long int a;
	ubigint_t x, y, z;
	bigintInit (&x, 3);
	bigintInit (&y, 3);
	bigintInit (&z, 3);

	y[2] = 0xe6d9a106746f5902;
	y[1] = 0x5b75e09706287ce2;
	y[0] = 0x87fe958ea78b2bff;
	z[2] = 0x6fc4eae712536c35;
	z[1] = 0x1ce9ae78b2be6d98;
	z[0] = 0xe6d9a1e9581256d9;
	

	ubigintSub (&x, y, z, 3);

	//fixmul_int (x.data, y.data, z.data, 3);
	
	
	free (x);
	free (y);
	free (z);


}
