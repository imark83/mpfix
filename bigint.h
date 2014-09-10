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

