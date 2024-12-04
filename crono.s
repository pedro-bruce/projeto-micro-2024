/* Codigo para 7SEG display
    0   3F
    1   06
    2   5B
    3   4F
    4   66
    5   6D
    6   7D
    7   07
    8   7F
    9   6F
*/
.global CRONO
CRONO:
    movia   r10, 0x10000020     /*display 0*/
    ldb     r12, (r21)          /*Tabela 7SEG*/
    stbio   r12, (r10)
    addi    r21, r21, 1         /*Incrementa unidades*/
    addi    r23, r23, 1         /*contador de dezenas*/
    beq     r23, r14, DEZ_CRONO /*se conta ate dez, incrementa dezena*/
    br      FIM_CRONO
DEZ_CRONO:
    movia   r21, TABELA_7SEG
    addi    r20, r20, 1         /*incrementa dezenas*/
    addi    r3, r3, 1           /*contador de centenas*/
    beq     r3, r15, CEM_CRONO  /*se conta ate dez, incrementa centena*/
FIM_CEM_CRONO:
    ldb     r12, (r20)
    movia   r10, 0x10000020     /*display 0*/
    addi    r10, r10, 1         /*display 1*/
    stbio   r12, (r10)
    mov     r23, r0
    br      CRONO
CEM_CRONO:
    movia   r20, TABELA_7SEG
    addi    r2, r2, 1           /*incrementa centenas*/
    addi    r4, r4, 1           /*contador de milhares*/
    beq     r4, r15, MIL_CRONO  /*se conta ate dez, incrementa milhar*/
FIM_MIL_CRONO:
    ldb     r12, (r2)
    movia   r10, 0x10000020     /*display 0*/
    addi    r10, r10, 2         /*display 2*/
    stbio   r12, (r10)
    mov     r3, r0
    br      FIM_CEM_CRONO
MIL_CRONO:
    movia   r2, TABELA_7SEG
    addi    r7, r7, 1           /*incrementa milhares*/
    ldb     r12, (r7)
    movia   r10, 0x10000020     /*display 0*/
    addi    r10, r10, 3         /*display 3*/
    stbio   r12, (r10)
    mov     r4, r0
    br      FIM_MIL_CRONO


FIM_CRONO:
    ret
.end
