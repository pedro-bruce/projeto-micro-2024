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
    addi    r23, r23, 1         /*contador*/
    beq     r23, r14, DEZ_CRONO /*se conta ate dez, incrementa dezena*/
    br      FIM_CRONO
DEZ_CRONO:
    movia   r21, TABELA_7SEG
    addi    r20, r20, 1     /*incrementa dezenas*/
    ldb     r12, (r20)
    addi    r10, r10, 1     /*display 1*/
    stbio   r12, (r10)
    mov     r23, r0

    br      CRONO

FIM_CRONO:
    ret

.end
