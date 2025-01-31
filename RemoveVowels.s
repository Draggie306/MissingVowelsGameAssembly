		B	test_rmvwls

trv_string	DEFB	"HELLO WORLD",0
trv_becomes	DEFB	"' becomes '",0
trv_eol		DEFB	"'\n",0
		ALIGN

;; Test individual implementation
test_rmvwls
		MOV		R13,#0x10000

		MOV		R0,#39
		SWI		0
		ADRL	R0,trv_string
		SWI		3

		ADRL	R0,trv_becomes
		SWI		3

		ADRL	R0,trv_string
		BL		RemoveVowels

		ADRL	R0,trv_string
		SWI		3

		ADRL	R0,trv_eol
		SWI		3

		SWI		2


;; copies isVowel subroutine into this file automatically
		include isVowel.s


;; RemoveVowels -- remove any vowels in the string at R0 using the isVowel subroutine to identify vowels
;; R0 <-- string

RemoveVowels
	
; readvowels only uses R0; to follow APCS we can store the string in e.g. R1
	MOV R1, R0

	; iterate over each character, if it is, then copy all from right over

charLoop
	; Load byte (char) of address R1 into R0
	LDRB R0, [R1]

	; Check if the current char is a null terminator and stop if it is.
	CMP R0,#0
	BEQ endItAll

	; Store the return address on the stack
	STMFD R13!, {R14}

	; Check if the R0 is a vowel
	BL isVowel

	; Restore the return address
	LDMFD R13!, {R14}

	; Temporarily store the current address into R3.
	MOV R3,R1

	; isVowel returns 1 if it is a vowel, 0 if not.
	; If R0 is NOT a vowel, resume the loop
	CMP R0,#1
	BEQ shiftChars

	; If it is NOT a vowel, continue with the below
	
resumeLoop
	; Restore the address from before the branch back into R1.
	MOV R1,R3

	; Increment the address in R1 to go to the next character and loop.
	ADD R1,R1,#1
	B charLoop

shiftChars
	; load into R0 the char at position R1 

	LDRB    R0, [R1, #1]
	STRB    R0, [R1], #1

	CMP     R0,#0
	BEQ     resumeLoop

	; ADD     R1,R1,#1
	B       shiftChars

endItAll
	MOV PC, R14


