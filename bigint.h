typedef unsigned long int *ubigint_t;
typedef unsigned long int *bigint_t;


// SIGNED OR UNSIGNED INIT. SIZE QUAD WORDS
void bigintInit (bigint_t *x, int size);

// ADDITION OF UNSIGNED INTEGERS. RETURNS CARRY FLAG
char ubigintAdd (ubigint_t *rop, ubigint_t op1, ubigint_t op2, int size);

// ADDITION OF SIGNED INTEGERS. RETURNS OVRFLOW FLAG
char bigintAdd (ubigint_t *rop, ubigint_t op1, ubigint_t op2, int size);

// SUBSTRACTION OF UNSIGNED INTEGERS. RETURNS BORROW FLAG
char ubigintSub (ubigint_t *rop, ubigint_t op1, ubigint_t op2, int size);

// SUBSTRACTION OF SIGNED INTEGERS. RETURNS OVRFLOW FLAG
char bigintSub (ubigint_t *rop, ubigint_t op1, ubigint_t op2, int size);

// MULTIPLICATION OF UNSIGNED INTEGERS. ROP SPLITTED INTO HIGH PART AND LOW PART
void ubigintMul (ubigint_t *roph, ubigint_t *ropl, ubigint_t op1, ubigint_t op2, int size);

// MULTIPLICATION OF SIGNED INTEGERS. ROP SPLITTED INTO HIGH PART AND LOW PART
void bigintMul (ubigint_t *roph, bigint_t *ropl, ubigint_t op1, ubigint_t op2, int size);

// CREATES A STRING CONTAININT HEX REPRESENTATION OF OP
char* ubigintToStringX (ubigint_t op, int size);

// COMPARES TWO UNSIGNED INTEGERS. OP1 > OP2 -> 1;  OP2 > OP1 -> -1;  OP1 = OP2 -> 0
char ubigintCmp (ubigint_t op1, ubigint_t op2, int size);

// COMPARES TWO NSIGNED INTEGERS. OP1 > OP2 -> 1;  OP2 > OP1 -> -1;  OP1 = OP2 -> 0
char bigintCmp (bigint_t op1, bigint_t op2, int size);

// SHIFT LEFT ROP A NUMBER OF BITS < 64
void shl_asm (ubigint_t *rop, int op, int size);

// SHIFT LEFT ROP A NUMBER OF BITS
void shl (ubigint_t *rop, unsigned int op, int size);






