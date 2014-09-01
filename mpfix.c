#include <stdio.h>
#include <stdlib.h>


typedef struct {
	unsigned int size;		// TOTAL NUMBER OF BYTES. PREFERIBLE MULTIPLE OF 8 
	unsigned int prec;		// NUMBER OF BYTES OF DECIMAL PART
	long int *data;			// POINTER TO DATA
} fix_t;


void fpinit (fix_t *x, unsigned int size, unsigned int prec) {
	x->size = size;
	x->prec = prec;
	x->data = (long int*) malloc (size);
	long int i;
	for (i=0; i<x->size; i++)
		x->data[i] = (long int) 0;
}
void fpfree (fix_t *x) {
	free (x->data);
}

void fpadd (fix_t *rop, fix_t op1, fix_t op2) {
	op1.size = 1;
	op2.size = 2;
	op1.data[0] = 3;
	op2.data[0] = 4;
	rop->size = 5;
}

int main () {
	fix_t x, y, z;
	fpinit (&x, 80, 40);	
	fpinit (&y, 80, 40);	
	fpinit (&z, 80, 40);

	fpadd (&x, y, z);
	
	
	fpfree (&x);


}
