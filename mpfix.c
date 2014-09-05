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
char fixmul_int (unsigned long int *rop, unsigned long int *op1, 
		unsigned long int *op2, unsigned int size);

int main () {
	unsigned long int a;
	fix_t x, y, z;
	fixinit (&x, 3, 4);	
	fixinit (&y, 3, 4);	
	fixinit (&z, 3, 4);

	y.data[0] = -5;
	y.data[1] = -6;
	y.data[2] = -7;

	//fixadd (&y, y, z);

	fixmul_int (y.data, NULL, NULL, 3);
	
	
	fixfree (x);
	fixfree (y);
	fixfree (z);


}
