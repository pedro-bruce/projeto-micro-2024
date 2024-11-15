.org 0x20
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
    eret                                            /*Retorno para _start*/
.org    0x100
/*Rotina da interrupcao desejada*/
EXT_IRQ0:

    stwio   r13, 0(r12)
    movia   r9, 0x10002000
    stwio   r0, 0(r9)
    ret                                             /*Retorno para _start*/



.global _start
_start:


/*UART*/
    movia   r12, 0x10001000
    movia   r15, 0x10001004
    movia   r8, PROMPT
    movia   r10, BUFFER
    movia   r9, 0x0A  /*codigo para line feed*/

PROMPT_LOOP:
    ldb     r5, 0(r8)   
    beq     r5, r0, POLL_READ
    stwio   r5, 0(r12)  /*Escreve o prompt na tela*/
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
    beq     r13, r9, TRATA    /*quando ENTER -> reescrever o prompt apos um comando*/
    stw     r13, 0(r10) /*salva ultimo caractere no buffer*/
    addi    r10,r10,4

    br      POLL_READ
TRATA:
    movia   r10, BUFFER
    ldw     r14, 0(r10)
    subi    r14,r14,0x30
    beq     r14,r0,LEDS
    br      PROMPT_LOOP
LEDS:
    call TRATA_LED
    br   PROMPT_LOOP


.org 0x500
PROMPT:
.ascii "Entre com o comando: "
.org 0x520
BUFFER:
.skip 100
