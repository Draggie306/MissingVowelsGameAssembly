		B	test_insert

; List of test arrays commented to test if it works...
;tis_array	DEFW	2,6,4,6,2,1,1,3,2
;tis_array	DEFW	1,2,3,4,5,6,7,8,9
tis_array 	DEFW	9,8,7,6,5,4,3,2,1
;tis_array	DEFW	9,2,1,4,3,6,5,8,7
debug_newline	DEFB "\n",0

		ALIGN

test_insert	MOV             R13,#0x10000
		ADRL	R0,tis_array
		MOV		R1,#9
		BL		BubbleSort

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


; BubbleSort -- should sort given input with bubblesort
; R0 -> array
; R1 -> number of elems in array

BubbleSort
    STMFD R13!, {R2-R8}
    
    SUB R8, R1, #1          ; R8 = length - 1 (outer loop bound)
    MOV R2, #0              ; R2 = outer loop counter

OuterLoop
    MOV R7, #0              ; R7 = swap flag (0 = no swaps made)
    MOV R3, #0              ; R3 = inner loop counter
    
InnerLoop
    LDR R4, [R0, R3, LSL #2]       ; Load current element
    ADD R5, R3, #1                  ; Calculate next index
    LDR R6, [R0, R5, LSL #2]       ; Load next element
    
    CMP R4, R6                      ; Compare elements
    BLE NoSwap                      ; Skip if in correct order
    
    ; Swap elements
    STR R6, [R0, R3, LSL #2]       ; Store smaller element
    STR R4, [R0, R5, LSL #2]       ; Store larger element
    MOV R7, #1                      ; Set swap flag
    
NoSwap
    ADD R3, R3, #1                  ; Increment inner counter
    SUB R6, R8, R2                  ; Calculate inner loop bound
    CMP R3, R6                      ; Check if inner loop complete
    BLT InnerLoop                   ; Continue inner loop if not done
    
    CMP R7, #0                      ; Check if any swaps were made
    BEQ Done                        ; If no swaps, array is sorted
    
    ADD R2, R2, #1                  ; Increment outer counter
    CMP R2, R8                      ; Check if outer loop complete
    BLT OuterLoop                   ; Continue outer loop if not done
    
Done
    LDMFD R13!, {R2-R8}
    MOV PC, R14

    LDMFD R13!, {R2-R8}
    MOV PC, R14