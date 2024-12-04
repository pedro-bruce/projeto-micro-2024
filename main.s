.org 0x20
# PROLOGO Stack Frame
    addi sp, sp, -68
    stw  ra, 64(sp)
    stw  r5, 56(sp)
    stw  r6, 52(sp)
    stw  r8, 44(sp)
    stw  r9, 40(sp)
    stw  r10, 36(sp)
    stw  r11, 32(sp)
    stw  r12, 28(sp)
    stw  r13, 24(sp)
    stw  r14, 20(sp)
    stw  r15, 16(sp)
    stw  r16, 12(sp)
    stw  r17, 8(sp)
    stw  r18, 4(sp)
    stw  r19, 0(sp)

/*Exception Handler*/
    rdctl   et,ipending                             /*Checa se interrupcao externa ocorreu*/
    beq     et,r0,OTHER_EXCEPTIONS                  /*SE zero, checa interrupcoes*/
    subi    ea,ea,4                                 /*Interrupcao de hardware; decrementa ea para executar a inst interrompida em _start*/

    andi    r18,et,1                                /*Checa SE IRQ0 habilitado*/
    beq     r18,r0,OTHER_INTERRUPTS                 /*SE nao, checa outras interrupcoes externas*/
    call    EXT_IRQ0                                /*SE sim, vai para rotina IRQ0*/

OTHER_INTERRUPTS:
/*instrucoes que checam outras interrupcoes por hardware aqui*/
    br      END_HANDLER      
OTHER_EXCEPTIONS:
/*Instrucoes que checam outros tipos de interrupcoes aqui*/
END_HANDLER:
# EPILOGO Stack Frame
    ldw  ra, 64(sp)
    ldw  r5, 56(sp)
    ldw  r6, 52(sp)
    ldw  r8, 44(sp)
    ldw  r9, 40(sp)
    ldw  r10, 36(sp)
    ldw  r11, 32(sp)
    ldw  r12, 28(sp)
    ldw  r13, 24(sp)
    ldw  r14, 20(sp)
    ldw  r15, 16(sp)
    ldw  r16, 12(sp)
    ldw  r17, 8(sp)
    ldw  r18, 4(sp)
    ldw  r19, 0(sp)
    addi sp, sp, 68

    eret                                            /*Retorno para _start*/
.org    0x110
/*Rotina da interrupcao desejada*/
EXT_IRQ0:
# PROLOGO Stack Frame
    addi sp, sp, -68
    stw  ra, 64(sp)
    stw  r5, 56(sp)
    stw  r6, 52(sp)
    stw  r8, 44(sp)
    stw  r9, 40(sp)
    stw  r10, 36(sp)
    stw  r11, 32(sp)
    stw  r12, 28(sp)
    stw  r13, 24(sp)
    stw  r14, 20(sp)
    stw  r15, 16(sp)
    stw  r16, 12(sp)
    stw  r17, 8(sp)
    stw  r18, 4(sp)
    stw  r19, 0(sp)
# Tratamento da flag para cronometro
    movia   r6, FLAG_CRONO
    ldw     r19, 0(r6)
    beq     r19, r0, LABEL  /*comando: se nao cronometro, testa se animacao*/

    movi    r6, 2
    addi    r22, r22, 1     /*contador de segundos = TEMPORIZADOR * 4*/
    beq     r22, r6,CALL_CRONO 
    br      LABEL
CALL_CRONO:
    mov     r22, r0
    movi    r14, 11
    movi    r15, 10
 

    movia   r11, 0x1000005c     /*edge bits do pushbutton*/
    ldwio   r8, (r11)
    andi    r8, r8, 4
    bne     r8, r0, PAUSA_CRONO /*se botao foi apertado, checar flag de pausa*/

    movia   r9, FLAG_PAUSA      /*flag para pausa do cronometro*/
    ldb     r12, (r9)
    bne     r12, r0, LABEL      /*se flag esta ativa, mantem pausado*/

    call    CRONO  
    br      LABEL 
PAUSA_CRONO:
    movia   r9, FLAG_PAUSA
    ldb     r12, (r9)
    movi    r10, 0x1
    beq     r12, r10, DESPAUSA  /*se a flag esta ativa, despausar cronometro*/
    
    movia   r11, 0x1000005c     /*edge bits do pushbutton*/
    stwio   r0, (r11)
    movia   r9, FLAG_PAUSA
    movi    r10, 0x1
    stb     r10, (r9)           /*pausa o cronometro*/
    br      LABEL
DESPAUSA:
    movia   r9, FLAG_PAUSA
    stb     r0, (r9)            /*despausa o cronometro*/
    movia   r11, 0x1000005c     /*edge bits do pushbutton*/
    stw     r0, (r11)
    br      CALL_CRONO
# Tratamento da flag para animacao     
LABEL:
    movia   r6, FLAG_ANIMA
    ldw     r19, 0(r6)
    beq     r19, r0, RET  /*SE flag for 0, volta a esrita em tela*/
    call    TRATA_ANIMA
RET:
# EPILOGO Stack Frame
    ldw  ra, 64(sp)
    ldw  r5, 56(sp)
    ldw  r6, 52(sp)
    ldw  r8, 44(sp)
    ldw  r9, 40(sp)
    ldw  r10, 36(sp)
    ldw  r11, 32(sp)
    ldw  r12, 28(sp)
    ldw  r13, 24(sp)
    ldw  r14, 20(sp)
    ldw  r15, 16(sp)
    ldw  r16, 12(sp)
    ldw  r17, 8(sp)
    ldw  r18, 4(sp)
    ldw  r19, 0(sp)
    addi sp, sp, 68

    movia   r9, 0x10002000      /*zera o temporizador*/
    stwio   r0, 0(r9)
    ret                         /*Retorno para _start*/




.global _start
_start:
/*Contadores e apontadores da tabela p/ o cronometro*/
PREP_CRONO:
    /*para segundos*/
    movia   r21, TABELA_7SEG    
    /*para dezenas*/
    movia   r20, TABELA_7SEG    
    mov     r23, r0
    /*para centenas*/
    movia   r2, TABELA_7SEG
    mov     r3, r0
    /*para milhares*/
    movia   r7, TABELA_7SEG
    mov     r4, r0
/*Contador de segundos | TEMPORIZADOR * 4*/
    mov     r22, r0 
/*TEMPORIZADOR*/

    movia   sp, 0x10000

    movia   r8, 25000000
    movia   r9, 0x10002000

    stwio   r8, 8(r9)

    srli    r10, r8, 16
    stwio   r10, 12(r9)

    /*Habilitar interrupcao do temporizador*/
    movi    r11, 0b111
    stwio   r11, 4(r9)

    /*configura ienable*/
    movi    r9,1
    wrctl   ienable,r9 

    /*Habilitar o bit PIE do status*/
    movia   r9, 1
    wrctl   status, r9

/*UART*/
    movia   r12, 0x10001000
    movia   r15, 0x10001004
    movia   r8, PROMPT
    movia   r10, BUFFER
    movia   r9, 0x0A  /*codigo ASCII para line feed*/

PROMPT_LOOP:
    ldb     r5, 0(r8)   
    beq     r5, r0, POLL_READ
    stwio   r5, 0(r12)  /*Escreve o prompt do menu na tela*/
    addi    r8, r8, 1
    br      PROMPT_LOOP
POLL_READ:
    ldwio   r13, 0(r12)
    andi    r14, r13, 0x8000
    beq     r14, r0, POLL_READ
POLL_WRITE:
    ldwio   r16, 0(r15)
    andhi   r17, r16, 0xFFFF
    beq     r17, r0, POLL_WRITE

    stwio   r13, 0(r12)     /*escreve em tela o que o user digita*/
    
    movia   r8, PROMPT   
    andi    r13, r13, 0xff /*isola o primeiro byte = codigo ASCII*/
    beq     r13, r9, TRATA    /*quando ENTER -> tratamento do comando*/
    stw     r13, 0(r10) /*salva ultimo caractere no buffer*/
    addi    r10,r10,4

    br      POLL_READ
TRATA:
    movia   r10, BUFFER
    ldw     r14, 0(r10)     /*carrega comando inserido*/
    subi    r14,r14,0x30    /*converte codigo ASCII para formatacao do menu*/
    movi    r5, 0x1
    beq     r14,r5,ANIMA    /*Animacao de LEDs*/
    movi    r5, 0x2
    beq     r14,r5,TRATA_CRONO 
    beq     r14,r0,LEDS     /*Acende e apaga LEDs*/
    br      PROMPT_LOOP
LEDS:
    call TRATA_LED          /*Sub-rotina para acender e apagar LEDs*/
    br   PROMPT_LOOP        /*Prompt do menu para prox comando*/
ANIMA:
/*Tratamento do comando da animacao*/
    ldw     r14, 4(r10)
    subi    r14, r14, 0x30
    beq     r14, r0, ATIVA_FLAG_ANIMA /*Se comando for 10 ativa a animacao*/
    movia   r6, FLAG_ANIMA
    stw     r0, 0(r6) /*pausa a animacao*/
    br      FIM_ANIMA
/*Coloca o valor da flag da animacao para 1*/
ATIVA_FLAG_ANIMA:
    movi  r14, 0x1
    movia r6,  FLAG_ANIMA
    stw   r14, 0(r6)
FIM_ANIMA:
    br    PROMPT_LOOP   /*Prompt do menu para prox comando*/
TRATA_CRONO:
    /*Tratamento do comando do cronometro*/
    ldw     r14, 4(r10)
    subi    r14, r14, 0x30
    beq     r14, r0, ATIVA_FLAG_CRONO /*Se comando for 20 ativa o cronometro*/
    movia   r6, FLAG_CRONO
    stw     r0, 0(r6) /*desativa a flag do cronometro*/
    movia   r6, 0x10000020
    stw     r0, (r6)  /*cancela o cronometro*/
    br      PREP_CRONO
/*Coloca o valor da flag do cronometro para 1*/
ATIVA_FLAG_CRONO:
    movi  r14, 0x1
    movia r6,  FLAG_CRONO
    stw   r14, 0(r6)
    br    FIM_ANIMA

.org 0x500

/*prompt do menu*/
PROMPT:
.ascii "Entre com o comando: "
.org 0x520

/*buffer da entrada do teclado*/
BUFFER:
.skip 100
/*flag para checar se houve comando para animcao*/
FLAG_ANIMA:     
.skip 10
FLAG_CRONO:
.skip 10
FLAG_PAUSA:
.skip 10
.global TABELA_7SEG
TABELA_7SEG:
.byte   0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F, 0x0

