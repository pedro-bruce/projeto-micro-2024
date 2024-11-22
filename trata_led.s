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
    add     r14,r14,r19 /*r14 eh o offset para o sll*/
    movi    r19,0x1
    sll     r14,r19,r14 /*para obter n atual que deve acender*/

    ldw     r19, 0(r18)
    or      r14,r14,r19  /*LEDs anteriores ficam acesos*/

    stwio   r14,0(r18)
    ret
APAGA_LED:
    movia   r18, 0x10000000
    ldw     r14, 12(r10) /*dezena*/
    ldw     r19, 16(r10) /*unidade*/
    subi    r14,r14,0x30
    muli    r14,r14,0xA
    subi    r19,r19,0x30
    add     r14,r14,r19
    movi    r19,0x1
    sll     r14,r19,r14 
    nor     r14,r14,r14 /*para obter n atual que deve apagar*/
    
    ldw     r19, 0(r18)
    and     r14,r14,r19  /*LEDs anteriores*/

    stwio   r14,0(r18)
    ret
.end

