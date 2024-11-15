.global TRATA_LED

TRATA_LED:
    ldw     r14, 4(r10)
    subi    r14,r14,0x30
    beq     r14,r0,ACENDE_LED
    br      APAGA_LED
ACENDE_LED:
    movia   r18, 0x10000000
    ldw     r14, 12(r10) /*dezena*/
    ldw     r19, 16(r10) /*unidade*/
    subi    r14,r14,0x30
    muli    r14,r14,0xA
    subi    r19,r19,0x30
    add     r14,r14,r19
    movi    r19,0x1
    sll     r14,r19,r14
    or      r14,r14,r18
    stwio   r14,0(r18)
APAGA_LED:

    ret
.end

