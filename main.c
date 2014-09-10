#include <stdio.h>
#include <stdlib.h>
#include "bigint.h"

int main () {
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
