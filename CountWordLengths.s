		B	test_cwrdl

tcwrdl_string	DEFB	"THE CAT SAT ON THE MAT",0

		ALIGN

;; Test routine before integrating in main function
test_cwrdl
		MOV		R13,#0x10000

		ADRL	R0,tcwrdl_string
		SWI		3

		ADRL	R0,tcwrdl_string
		ADRL	R1,tcwrdl_array
		BL		CountWordLengths
		MOV		R3,R0
		MOV		R0,#10
		SWI		0

		MOV		R2,#0
		ADRL	R1,tcwrdl_array
		B		tcwrdl_cond
tcwrdl_loop
		LDR		R0, [R1, R2 LSL #2]
		SWI		4
		MOV		R0,#10
		SWI		0
		ADD		R2,R2,#1
tcwrdl_cond
		CMP		R2,R3
		BLT		tcwrdl_loop

		SWI		2


;; CountWordLengths -- fill in an array with the length of each word in the string
;; R0 <-- string
;; R1 <-- array to file
;; Returns: The number of words found in R0.

CountWordLengths
	STMFD R13!, {R4-R10}

	; Initialise word length temp in R3
	MOV R3, #0

	; Initialise number of words found
	MOV R4, #0

characterLoop
	; Move the character into R2
	LDRB R2, [R0], #1 ; Post-incrementing

	; Check for null-terminator first.
	CMP R2, #0 
	BEQ endCount

	; COMPARE to space
	CMP R2,#32
	BEQ foundSpace

	; Incremenet word length
	ADD R3,R3,#1

	; Restart looping
	B characterLoop

foundSpace
	; Check if the word length is zero.
	; If so, do not store and carry on with the next char
	CMP R3, #0
	BEQ characterLoop

	; Store the length of the word AS INTEGER into the array (and post increment)
	STR R3, [R1], #4

	; Increment number of words found
	ADD R4, R4, #1

	; and reset the counter to zero
	MOV R3, #0

	B characterLoop

endCount
    ; Check if remaining word to store to solve ooff-by-one err
    CMP R3, #0
    BEQ skipLast

    ; Store the last word length AS INTEGER
    STR R3, [R1], #4
    ADD R4, R4, #1

skipLast
	; MOve into R0 the number of words found
	MOV R0, R4

	; Move into R1 the array
	; ^^ this is not needed ^^

	; Reset branch with link
	LDMFD R13!, {R4-R10}
	MOV PC, R14


;; DO NOT REMOVE THIS LABEL
tcwrdl_array	DEFW	0	
