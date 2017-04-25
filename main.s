GPIO_PORTE_DATA_R       EQU   0x400243FC
GPIO_PORTE_DIR_R        EQU   0x40024400
GPIO_PORTE_AFSEL_R      EQU   0x40024420
GPIO_PORTE_DEN_R        EQU   0x4002451C
GPIO_PORTE_AMSEL_R      EQU   0x40024528
GPIO_PORTE_PCTL_R       EQU   0x4002452C
SYSCTL_RCGCGPIO_R       EQU   0x400FE608
	
       IMPORT  TExaS_Init
       AREA    |.text|, CODE, READONLY, ALIGN=2
       THUMB
       EXPORT  Start
Start
    BL  TExaS_Init 
    LDR R0,= SYSCTL_RCGCGPIO_R
    LDR R1,[R0]
    ORR R1,#0x10
    STR R1,[R0]
	   
    NOP
    NOP
	   
    LDR R0,= GPIO_PORTE_DIR_R
    LDR R1,[R0]
    ORR R1,#0x03
    STR R1,[R0]
	   
    LDR R0,= GPIO_PORTE_AFSEL_R
    LDR R1,[R0]
    BIC R1,#0x03
    STR R1,[R0]
	   
    LDR R0,= GPIO_PORTE_DEN_R
    LDR R1,[R0]
    ORR R1,#0x03
    STR R1,[R0]

	MOV R4, #0x00 ; ON Button
loop  
; you input output delay
    BL Delay 
	   
    LDR  R0,= GPIO_PORTE_DATA_R
    LDR  R2,= GPIO_PORTE_DATA_R
	   
    LDR  R1,[R0]       
	AND  R1, #0x01
    CMP  R1, #0x01
	BEQ  Toggle				;Toggle On Button
	CMP  R4, #0x01
    BEQ  TurnOn
	BNE  loop
	
	
TurnOn
	LDR R1,[R2]
	ORR R1, #0x02
	STR R1, [R2]
	BL  Delay
	
TurnOff
	LDR R1,[R2]
	AND R1, #0x01
	STR R1, [R2]
	B	loop
	
	   
	   
Toggle
; Toggle On Button
	EOR  R4, #0x01
    BX   LR
	   
	   
Delay  
; 80ms long delay
    MOV  R7, #20
Subt   
    MOV  R8, #40000
wait   
    SUBS R8, #1
    BNE  wait 
    SUBS R7, #1
    BNE  Subt
    BX   LR

    ALIGN      ; make sure the end of this section is aligned
    END        ; end of file