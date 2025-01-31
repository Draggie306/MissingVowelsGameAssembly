		B	test_insert

; Why no work?!
;tis_array	DEFW	2,6,4,6,2,1,1,3,2
;tis_array	DEFW	1,2,3,4,5,6,7,8,9
;tis_array 	DEFW	9,8,7,6,5,4,3,2,1
tis_array	DEFW	9,2,1,4,3,6,5,8,7

debug_read	DEFB 	"\nValue read is ",0
debug_greater	DEFB	" is greater than ",0
debug_counter	DEFB 	"\nCounter is now ",0
debug_counter_in_continue	DEFB 	"\nCounter in continueLoop (no need to insert) is now ",0
debug_load	DEFB	"\nLoaded value of ",0
debug_comparing	DEFB	"\nComparing value ",0
debug_to	DEFB	" to ",0
debug_newline DEFB "\n",0

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

;; Insert your code here

	; =-= Step through the array element-by-element in a loop,
	; =-= growing the sorted list behind it. 

	; === at each array index, check the value 

	; We will set R3 to be the counter variable set to 1

	STMFD R13!, {R4-R7} ; stack the things for APCS
	MOV R3, #1
mainLoopIncrementCounter
	ADD R3,R3,#1
mainInsertionLoop
	; Store the number of items on the stack to free up APCS register

	;;;; STMFD R13!, {R1}; R1 is now free.
	; --- Get element to check
	; Load into R4 the 4 bits of the array in R0, offset by counter
	LDRB R4, [R0, R3, LSL #2] 	; R3 would be 1

	; Compare if the value of check is less than largest (which it proably is)
	SUB R3, R3, #1
	LDRB R2, [R0, R3, LSL #2] 	; R3 would be 0

	;;;; LDMFD R13!, {R1} ; R1 now contains the number of elems in array.

	;;; debug
	STMFD R13!, {R0}
	ADRL R0,debug_comparing
	SWI 3
	MOV R0,R4
	SWI 4
	ADRL R0,debug_to
	SWI 3
	MOV R0, R2
	SWI 4
	LDMFD R13!, {R0}
	;;; end debug

	CMP R4,R2	; Comparing target to top of array
	BGE continueLoop

	; if it is not, then it needs sorting, so branch to that point
	; store R3 (head) and caller's link to stack
	STMFD R13!, {R3}
	STMFD R13!, {R14}
	BL findCorrectPositionAndInsert
	LDMFD R13!, {R14}
	LDMFD R13!, {R3}

continueLoop
	; Increment counter
	ADD R3,R3,#2				; R3 would be 2

	;;; debug
	STMFD R13!, {R0}
	ADRL R0,debug_counter_in_continue
	SWI 3
	MOV R0,R3
	SWI 4
	LDMFD R13!, {R0}
	;;; end debug

	; While the number of elems hasn't been reached (R3 < R1), cont
	CMP R3, R1					; R1: number of elems
	BLE mainLoopIncrementCounter

	; if we have reached the end of the loop, exit it.
	LDMFD R13!, {R4-R7} ; RESTORE STACK

			;;; debug
	STMFD R13!, {R0}
	ADRL R0,debug_newline
	SWI 3
	LDMFD R13!, {R0}
	;;; end debug

	MOV PC, R14		; Terminate!

findCorrectPositionAndInsert
	; reminder: 

	; R0 - array
	; R1 - array elems (int)
	; R2 - not needed
	; R3 - free
	; R4 - target

	; start at 0 and compare 

	; R3 = j
	MOV R3, #0

compareCounter
	; Load value of array[counter] into R5
	LDRB R5, [R0, R3 LSL #2]

	;;; debug
	STMFD R13!, {R0}
	ADRL R0,debug_load
	SWI 3
	MOV R0,R5
	SWI 4
	LDMFD R13!, {R0}
	;;; end debug

	; Increment counter
	ADD R3, R3, #1

	; Load value of array[counter + 1] into R6
	LDRB R6, [R0, R3 LSL #2]

	; to determine if the target should be added, check if
	; the target is less than the value at j=0

	;;; TEST CASE ;;; 	9,2,1,4,3,6,5,8,7

	; if target is greater than counter, loop again
	CMP R4, R5
	BGT compareCounter

	; else, add it
	; MOV R7, R3

	STMFD R13!, {R3} ; save counter

shuffleElementsAbove
	; for elements at i to end, shift their position to +1
	ADD R3, R3, #1

	; load into (TMP) R7 the value at counter + 1 (J + 1)
	LDRB R7, [R0, R3 LSL #2]

	; R5 already contains the value at counter
	; set R5 to the position counter + 1
	SUB R3, R3, #2
	STRB R5, [R0, R3 LSL #2]

	; move the temp R7 into R5, the value at j-1
	MOV R5, R7

	CMP R5,R4
	BLE insert

	;;; debug
	STMFD R13!, {R0}
	ADRL R0,debug_counter
	SWI 3
	MOV R0,R3
	SWI 4
	LDMFD R13!, {R0}
	;;; end debug

	CMP R3, #0
	BLT insert

	; loop if has not reached the end
	CMP R3, R1
	BNE shuffleElementsAbove

	; finally, insert item at counter

insert
	STRB R4, [R0, R3 LSL #2]

	LDMFD R13!, {R3} ; restore counter
finished

	; After insering and shifting all elements ahead, return
	MOV PC, R14
