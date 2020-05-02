; Print.s
; Student names: change this to your names or look very silly
; Last modification date: change this to the last modification date or look very silly
; Runs on LM4F120 or TM4C123
; EE319K lab 7 device driver for any LCD
;
; As part of Lab 7, students need to implement these LCD_OutDec and LCD_OutFix
; This driver assumes two low-level LCD functions
; ST7735_OutChar   outputs a single 8-bit ASCII character
; ST7735_OutString outputs a null-terminated string 

    IMPORT   ST7735_OutChar
    IMPORT   ST7735_OutString
    EXPORT   LCD_OutDec
    EXPORT   LCD_OutFix

    AREA    |.text|, CODE, READONLY, ALIGN=2
    THUMB

  

;-----------------------LCD_OutDec-----------------------
; Output a 32-bit number in unsigned decimal format
; Input: R0 (call by value) 32-bit unsigned number
; Output: none
; Invariables: This function must not permanently modify registers R4 to R11
; Lab 7 requirement is for at least one local variable on the stack with symbolic binding
LCD_OutDec
BaseCase
	CMP R0, #10 ;
	BHS NonBaseCase
	ADD R0, #0x30
	PUSH {R4, LR}
	BL ST7735_OutChar
	POP {R4, LR}
	BX LR
NonBaseCase
	CMP R0, #100
	BHS TRIPLE
	MOV R3, #10
	MOV R2, R0 ;R2 has the original value
	UDIV R1, R0, R3 ;this is n = n/10, R1 should contain the most significant bit
	MOV R0, R1
	ADD R0, #0x30
	PUSH {R1, R2,R3, LR}
	BL ST7735_OutChar
	POP {R1, R2, R3, LR}
	MUL R3, R1, R3 ; 
	SUB R1, R2, R3
	MOV R0, R1 ;remainder of the above operation
	B BaseCase
TRIPLE 
	CMP R0, #1000
	BHS QUAD
	MOV R3, #100
	MOV R2, R0 ;R2 has the original value
	UDIV R1, R0, R3 ;this is n = n/100, R1 should contain the most significant bit
	MOV R0, R1
	ADD R0, #0x30
	PUSH {R1, R2,R3, LR}
	BL ST7735_OutChar
	POP {R1, R2, R3, LR}
	MUL R3, R1, R3 ; 
	SUB R1, R2, R3
	MOV R0, R1 ;remainder of the above operation
	B NonBaseCase
QUAD
	LDR R3, =10000
	CMP R0, R3
	BHS FIVE
	MOV R3, #1000
	MOV R2, R0 ;R2 has the original value
	UDIV R1, R0, R3 ;this is n = n/100, R1 should contain the most significant bit
	MOV R0, R1
	ADD R0, #0x30
	PUSH {R1, R2,R3, LR}
	BL ST7735_OutChar
	POP {R1, R2, R3, LR}
	MUL R3, R1, R3 ; 
	SUB R1, R2, R3
	MOV R0, R1 ;remainder of the above operation
	B TRIPLE

FIVE
	LDR R3, =100000
	CMP R0, R3
	BHS SIX
	MOV R3, #10000
	MOV R2, R0 ;R2 has the original value
	UDIV R1, R0, R3 ;this is n = n/100, R1 should contain the most significant bit
	MOV R0, R1
	ADD R0, #0x30
	PUSH {R1, R2,R3, LR}
	BL ST7735_OutChar
	POP {R1, R2, R3, LR}
	MUL R3, R1, R3 ; 
	SUB R1, R2, R3
	MOV R0, R1 ;remainder of the above operation
	B QUAD

SIX
	LDR R3, =1000000
	CMP R0, R3
	BHS SEVEN
	LDR R3, =100000
	MOV R2, R0 ;R2 has the original value
	UDIV R1, R0, R3 ;this is n = n/100, R1 should contain the most significant bit
	MOV R0, R1
	ADD R0, #0x30
	PUSH {R1, R2,R3, LR}
	BL ST7735_OutChar
	POP {R1, R2, R3, LR}
	MUL R3, R1, R3 ; 
	SUB R1, R2, R3
	MOV R0, R1 ;remainder of the above operation
	B FIVE

SEVEN
	LDR R3, =10000000
	CMP R0, R3
	BHS EIGHT
	LDR R3, =1000000
	MOV R2, R0 ;R2 has the original value
	UDIV R1, R0, R3 ;this is n = n/100, R1 should contain the most significant bit
	MOV R0, R1
	ADD R0, #0x30
	PUSH {R1, R2,R3, LR}
	BL ST7735_OutChar
	POP {R1, R2, R3, LR}
	MUL R3, R1, R3 ; 
	SUB R1, R2, R3
	MOV R0, R1 ;remainder of the above operation
	B SIX
EIGHT
	LDR R3, =100000000
	CMP R0, R3
	BHS NINE
	LDR R3, =10000000
	MOV R2, R0 ;R2 has the original value
	UDIV R1, R0, R3 ;this is n = n/100, R1 should contain the most significant bit
	MOV R0, R1
	ADD R0, #0x30
	PUSH {R1, R2,R3, LR}
	BL ST7735_OutChar
	POP {R1, R2, R3, LR}
	MUL R3, R1, R3 ; 
	SUB R1, R2, R3
	MOV R0, R1 ;remainder of the above operation
	B SEVEN

NINE 
	LDR R3, =1000000000
	CMP R0, R3
	BHS TEN
	LDR R3, =100000000
	MOV R2, R0 ;R2 has the original value
	UDIV R1, R0, R3 ;this is n = n/100, R1 should contain the most significant bit
	MOV R0, R1
	ADD R0, #0x30
	PUSH {R1, R2,R3, LR}
	BL ST7735_OutChar
	POP {R1, R2, R3, LR}
	MUL R3, R1, R3 ; 
	SUB R1, R2, R3
	MOV R0, R1 ;remainder of the above operation
	B EIGHT

TEN
	LDR R3, =1000000000
	MOV R2, R0 ;R2 has the original value
	UDIV R1, R0, R3 ;this is n = n/100, R1 should contain the most significant bit
	MOV R0, R1
	ADD R0, #0x30
	PUSH {R1, R2,R3, LR}
	BL ST7735_OutChar
	POP {R1, R2, R3, LR}
	MUL R3, R1, R3 ; 
	SUB R1, R2, R3
	MOV R0, R1 ;remainder of the above operation
	B NINE


	 BX  LR


     
;* * * * * * * * End of LCD_OutDec * * * * * * * *

; -----------------------LCD _OutFix----------------------
; Output characters to LCD display in fixed-point format
; unsigned decimal, resolution 0.01, range 0.00 to 9.99
; Inputs:  R0 is an unsigned 32-bit number
; Outputs: none
; E.g., R0=0,    then output "0.00 "
;       R0=3,    then output "0.03 "
;       R0=89,   then output "0.89 "
;       R0=123,  then output "1.23 "
;       R0=999,  then output "9.99 "
;       R0>999,  then output "*.** "
; Invariables: This function must not permanently modify registers R4 to R11
; Lab 7 requirement is for at least one local variable on the stack with symbolic bindinG
LCD_OutFix
	
	MOV R1, #999
	CMP R0, R1
	BHI HIGH
	MOV R1, #100
	UDIV R2, R0, R1
	ADD R3, R2, #0x30; CONVERTS TO ASCII
	MOV R1, R0; SAVE R0
	MOV R0, R3
	PUSH {R1,R2,R3, LR}
	BL ST7735_OutChar
	POP{R1, R2, R3, LR}
	MOV R0, #0x2E
	PUSH{R1, R2, R3, LR}
	BL ST7735_OutChar
	POP{R1, R2, R3, LR}
	MOV R0, R1; RESTORE R0
	MOV R1, #100
	MUL R2, R2, R1
	SUB R0, R0, R2
	MOV R1, #10
	UDIV R2, R0, R1
	ADD R3, R2, #0x30
	MOV R1, R0; SAVE R0
	MOV R0, R3
	PUSH{R1, R2, R3, LR}
	BL ST7735_OutChar
	POP{R1, R2, R3, LR}
	
	MOV R0, R1; RESTORE R0
	MOV R1, #10
	MUL R2, R2, R1
	SUB R0, R0, R2
	ADD R0, R0, #0x30
	PUSH{R1, R2, R3, LR}
	BL ST7735_OutChar
	POP{R1, R2, R3, LR}
	BX LR
	
HIGH  
	PUSH{R0, LR}
	MOV R0, #0x2A
	BL ST7735_OutChar
	MOV R0, #0x2E
	BL ST7735_OutChar
	MOV R0, #0x2A
	BL ST7735_OutChar
	MOV R0, #0x2A
	BL ST7735_OutChar
	POP{R0, LR}
	BX LR
     ALIGN
;* * * * * * * * End of LCD_OutFix * * * * * * * *

     ALIGN          ; make sure the end of this section is aligned
     END            ; end of file
