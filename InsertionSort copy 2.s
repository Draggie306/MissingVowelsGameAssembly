		B	test_insert

; REALLY check it.
tis_array	DEFW	2,6,4,6,2,1,1,3,2
;tis_array	DEFW	1,2,3,4,5,6,7,8,9
;tis_array 	DEFW	9,8,7,6,5,4,3,2,1
;tis_array	DEFW	9,2,1,4,3,6,5,8,7
debug_newline	DEFB "\n",0
debug_inserting DEFB "\nInserting value: ",0
debug_islessthan DEFB " is less than ",0
debug_finalarr DEFB "\n\nFinal array: \n",0
debug_currentint DEFB "\nCurrent int: ",0
debug_prevint	DEFB ", previous int: ",0
debug_counter DEFB "\nCounter: ",0
debug_isgreaterthan DEFB " is greater than ",0


		ALIGN

test_insert	MOV             R13,#0x10000
		ADRL	R0,tis_array
		MOV		R1,#9
		BL		InsertionSort

		MOV		R2,#0
		MOV		R3,#9
		ADRL	R1,tis_array
		B		tis_cond
tis_loop
		LDR		R0, [R1, R2 LSL #2]
		SWI		4
		MOV		R0,#10
		SWI		0
		ADD		R2,R2,#1
tis_cond
		CMP		R2,R3
		BLT		tis_loop

		SWI		2


; InsertionSort -- should sort the array using the Insertion sort algorithm
; R0 -> array
; R1 -> number of elems in array

InsertionSort

; Insert your code here

	; The algorithm will first start looping through the array index

	MOV 	R4, #1 ; initialise counter variable for the array loop, starting at 1
	B StartInserting

InsertionArrayLoop
	STMFD	R13!, {R0}
	ADRL R0, debug_newline
	SWI 3
	MOV R0, R3
	SWI 4
	ADRL R0, debug_isgreaterthan
	SWI 3
	MOV R0, R2
	SWI 4
	LDMFD 	R13!, {R0}

StartInserting

	LDRB 	R2, [R0, R4 LSL #2] 	; get integer at the current position
	SUB 	R5, R4, #1
	LDRB 	R3, [R0, R5 LSL #2]		; get integer at previous position (greatest in the sorted array)
	ADD 	R4, R4, #1 				; Increment counter

	; -- Debug -- ->> THIS ABOVE PROBABLY WORKS AS EXPECTED!
	STMFD	R13!, {R0}
	ADRL 	R0, debug_counter
	SWI 	3
	MOV 	R0, R4
	SWI 	4
	ADRL 	R0, debug_currentint
	SWI 	3
	MOV 	R0, R2
	SWI 	4
	ADRL 	R0, debug_prevint
	SWI 	3
	MOV 	R0, R3
	SWI 	4
	ADRL 	R0, debug_newline
	SWI 	3
	SWI 	3
	LDMFD 	R13!, {R0}

	; If the element tested is GREATER OR EQUAL to previous, leave it and move to the next
	CMP 	R3, R2
	BGT 	InsertionArrayLoop

	;-STMFD 	R13!, {R0}
	;-MOV R0, R3
	;-SWI 4
	;-ADRL R0, debug_islessthan
	;-SWI 3
	;-MOV R0, R2
	;-SWI 4
	;-ADRL R0, debug_newline
	;-SWI 3
	;-LDMFD	R13!, {R0}

	; check for bounds. Quit if the incremented counter is greater than the num of elements.
	CMP 	R4,R1
	BGT		endItAll

	; else, it is less than
	STMFD 	R13!, {R14}
	STMFD 	R13!, {R3-R4} 	; store previous position and counter
	BL 		InsertMe		; expects R2 to be the number to insert.
	LDMFD 	R13!, {R3-R4}
	LDMFD 	R13!, {R14}	

	B StartInserting

endItAll
	STMFD R13!, {R0}
	ADRL R0, debug_finalarr
	SWI 3
	LDMFD R13!, {R0}
	MOV PC, R14


; R2 <- element to insert into the array.
InsertMe

	; Debugging
	;+STMFD R13!, {R0}
	;+ADRL R0, debug_inserting
	;+SWI 3
	;+MOV R0, R2
	;+SWI 4
	;+ADRL R0, debug_newline
	;+SWI 3
	;+LDMFD R13!, {R0}
	; assume index 0 is sorted, so compare 1 with 0

	MOV 	R3, #0 	; R3 is J

ActuallyInsertIt
	LDRB 	R4, [R0, R3 LSL #2]	; Value at J.
	ADD 	R3, R3, #1
	LDRB 	R5, [R0, R3 LSL #2]	; Value at J + 1.

	; If has reached the end of the array
	CMP 	R3, R1
	BEQ 	ExitInsertion

 	; If the J is less than J+1, increment the loop and go again until it is not 
	CMP 	R4, R5			; e.g. 6, 4
	BLT		ActuallyInsertIt ; Iterate over the loop until

	STMFD 	R13!, {R0}
	ADRL R0, debug_inserting
	SWI 3
	MOV R0, R2
	SWI 4
	ADRL R0, debug_newline
	SWI 3
	LDMFD	R13!, {R0}

	; Else, it is GREATER THAN. We need to insert it!
	MOV 	R6, R5 ; Store a copy of index J + 1
	STRB	R5, [R0, R3 LSL #2]
	SUB 	R3, R3, #1
	STRB 	R6, [R0, R3 LSL #2]
	ADD 	R3, R3, #2

ExitInsertion
	; exit
	MOV 	PC, R14