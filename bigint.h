typedef unsigned long int *ubigint_t;
typedef unsigned long int *bigint_t;


void bigintInit (bigint_t *x, int size);
char ubigintAdd (ubigint_t *rop, ubigint_t op1, ubigint_t op2, int size);
char bigintAdd (ubigint_t *rop, ubigint_t op1, ubigint_t op2, int size);
char ubigintSub (ubigint_t *rop, ubigint_t op1, ubigint_t op2, int size);
char bigintSub (ubigint_t *rop, ubigint_t op1, ubigint_t op2, int size);
void ubigintMul (ubigint_t *roph, ubigint_t *ropl, ubigint_t op1, ubigint_t op2, int size);
void bigintMul (ubigint_t *roph, bigint_t *ropl, ubigint_t op1, ubigint_t op2, int size);



char* ubigintToStringX (ubigint_t op, int size);

