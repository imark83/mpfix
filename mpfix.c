#include <stdio.h>
#include <stdlib.h>


typedef struct {
	unsigned int size;		// TOTAL NUMBER OF BYTES. PREFERIBLE MULTIPLE OF 8 
	unsigned int prec;		// NUMBER OF BYTES OF DECIMAL PART
	unsigned long int *data;	// POINTER TO DATA
} fix_t;


void fpinit (fix_t *x, unsigned int size, unsigned int prec) {
	x->size = size;
	x->prec = prec;
	x->data = (long int*) malloc (size);
	int i;
	for (i=0; i<x->size; i++)
		x->data[i] = 0;
}
void fpfree (fix_t *x) {
	free (x->data);
}

void fpadd (fix_t *rop, fix_t op1, fix_t op2);
int main () {
	fix_t x, y, z;
	fpinit (&x, 24, 4);	
	fpinit (&y, 24, 4);	
	fpinit (&z, 24, 4);

	y.data[2] = 0xFFFFFFFFFFFFFFFF;
	z.data[2] = 0x1;

	fpadd (&x, y, z);
	
	
	fpfree (&x);


}
