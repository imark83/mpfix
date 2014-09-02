#include <stdio.h>
#include <stdlib.h>


typedef struct {
	unsigned int size;		// TOTAL NUMBER OF QUAD WORDS.
	unsigned int prec;		// NUMBER OF BYTES OF DECIMAL PART
	unsigned long int *data;	// POINTER TO DATA
} fix_t;


void fixinit (fix_t *x, unsigned int size, unsigned int prec) {
	x->size = size;
	x->prec = prec;
	x->data = (unsigned long int*) malloc (8*size);
	int i;
	for (i=0; i<x->size; i++)
		x->data[i] = 0;
}
void fixfree (fix_t x) {
	free (x.data);
}


char fixadd (fix_t *rop, fix_t op1, fix_t op2);
void fixsub (fix_t *rop, fix_t op1, fix_t op2);
void fixmul_long (unsigned long int *roph, fix_t *ropl, fix_t op1, long int op2);


int main () {
	unsigned long int a;
	fix_t x, y, z;
	fixinit (&x, 3, 4);	
	fixinit (&y, 3, 4);	
	fixinit (&z, 3, 4);

	z.data[0] = 0;
	z.data[1] = 0;
	z.data[2] = 1;

	y.data[0] = (long int) 1 << 63;
	y.data[1] = 0;
	y.data[2] = 0;

	fixsub (&x, y, z);

	fixmul_long (&a, &x, z, 2);
	
	
	fixfree (x);
	fixfree (y);
	fixfree (z);


}
