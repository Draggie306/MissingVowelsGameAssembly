		B	test_insert

; REALLY check it. 
tis_array	DEFW	2,6,4,6,2,1,1,3,2
;tis_array	DEFW	1,2,3,4,5,6,7,8,9
;tis_array 	DEFW	9,8,7,6,5,4,3,2,1
;tis_array	DEFW	9,2,1,4,3,6,5,8,7
debug_newline	DEFB "\n",0
debug_inserting DEFB "\nInserting value: ",0
debug_islessthan DEFB " is less than ",0
debug_finalarr DEFB "\n\nExited all operations.\nFinal array: \n",0
debug_currentint DEFB "\nCurrent int: ",0
debug_prevint	DEFB ", previous int: ",0
debug_counter DEFB "\nCounter: ",0
debug_isgreaterthan DEFB " is greater than ",0
debug_inserted DEFB "\nInserted ",0
debug_intoposition DEFB " into position ",0
debug_space DEFB " ",0

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
	; The algorithm will first start looping through the array index

	MOV 	R4, #1 ; initialise counter variable for the array loop, starting at 1

InsertionArrayLoop

	LDRB 	R3, [R0, R4 LSL #2] 	; get integer at the current position
	SUB 	R5, R4, #1
	LDRB 	R2, [R0, R5 LSL #2]		; get integer at previous position (greatest in the sorted array)
	ADD 	R4, R4, #1 				; Increment counter


	; -- Debug -- ->> THIS ABOVE PROBABLY WORKS AS EXPECTED!
	STMFD	R13!, {R0}
	ADRL 	R0, debug_counter
	SWI 	3
	MOV 	R0, R4
	SWI 	4
	ADRL 	R0, debug_currentint
	SWI 	3
	MOV 	R0, R3
	SWI 	4
	ADRL 	R0, debug_prevint
	SWI 	3
	MOV 	R0, R2
	SWI 	4
	ADRL 	R0, debug_newline
	SWI 	3
	SWI 	3
	LDMFD 	R13!, {R0}

	; Current pos should be greater than previous pos, if so then move on
	CMP 	R3, R2
	BGE 	InsertionArrayLoop


	MOV R6, R4	; store original index as this gets changes
	MOV R7, R2
	STMFD R13!, {R14}
	STMFD R13!, {R3}
	STMFD R13!, {R6-R7}
	BL InsertInt
	LDMFD R13!, {R6-R7}
	LDMFD R13!, {R3}
	LDMFD R13!, {R14}
	MOV R2, R7
	MOV R4, R6

	; if incremented counter is bigger than number of elems, quit
	CMP 	R4,R1
	BGE		endItAll

	; else, repeat the loop

	B InsertionArrayLoop

endItAll
	STMFD R13!, {R0}
	ADRL R0, debug_finalarr
	SWI 3
	LDMFD R13!, {R0}

	MOV PC, R14

; R2 <- integer to insert into the array
; R4 <- index
InsertInt

	; make copy of the element to insert
	MOV R6, R4

	; loop back through the sorted elements, shifting by one.

	;SUB R4, R4, #1 ; decrement counter as it is not in the array yet.

InsertIntShiftSorted
	; element at index J is set to the value at index -1.
	SUB 	R4, R4, #1			; Decrement R4			
	LDRB	R5, [R0, R4 LSL #2]	; R5 contains element at index J-1
	ADD		R3, R4, #1			; R3 = R4 + 1
	STRB	R5, [R0, R3 LSL #2] ; Store element at j-1 into J


	; more debuggery
	STMFD 	R13!, {R0}

	LDMFD 	R13!, {R0}

	; until 1.) J reaches 0
	CMP 	R4, #0
	BLE		InsertIntEnded

	; 2.) element at j-1 is less than the value to be inserted
	CMP 	R5, R2
	BGE 	InsertInt	; if j-1 is greater than value, reloop

InsertIntEnded
	; at this point, stored value can be inserted at J
	;ADD 	R4, R4, #1
	STRB	R2, [R0, R4 LSL #2]

	; more debuggery
	STMFD 	R13!, {R0}
	ADRL 	R0, debug_inserted
	SWI 	3
	MOV 	R0, R2
	SWI 	4
	ADRL	R0, debug_intoposition
	SWI 	3
	MOV 	R0, R4
	SWI 	4
	ADRL 	R0, debug_newline
	SWI 	3
	LDMFD 	R13!, {R0}

	
	MOV PC, R14
