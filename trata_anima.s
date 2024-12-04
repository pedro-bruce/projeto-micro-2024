.global TRATA_ANIMA
TRATA_ANIMA:
    movia   r7, 0x10000040 
    ldwio   r8, 0(r7)
    beq     r8, r0, ANIME_REV
    br      ANIME
ANIME_REV:
    movia   r19, 0x10000000 /*RED LED*/
    movia   r18, LED_STATUS /*Valor usado para animacao dos LEDs*/
    ldw     r6, 0(r18)
    movia   r5, 0x1
    beq     r5, r6, RESET_REV   /*Se a animacao passou por todos os LEDs, reinicia*/
    stwio   r6, 0(r19)      /*acende um LED*/
    srli    r6, r6, 1       /*prepara para acender LED seguinte*/
    stw     r6, 0(r18)
    ret
ANIME:
    movia   r19, 0x10000000 /*RED LED*/
    movia   r18, LED_STATUS /*Valor usado para animacao dos LEDs*/
    ldw     r6, 0(r18)
    movia   r5, 0x00040000
    beq     r5, r6, RESET   /*Se a animacao passou por todos os LEDs, reinicia*/
    stwio   r6, 0(r19)      /*acende um LED*/
    slli    r6, r6, 1       /*prepara para acender LED seguinte*/
    stw     r6, 0(r18)
    ret
RESET:
    movi    r6, 1
    stw     r6, 0(r18)
    br      ANIME
RESET_REV:
    movi    r6, 0x00040000
    stw     r6, 0(r18)
    br      ANIME_REV
/*Valor usado para animacao dos LEDs*/
LED_STATUS:
.word 1
.end
