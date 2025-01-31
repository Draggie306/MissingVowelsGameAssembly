		B	test_readstring

trs_prompt	DEFB 	"Enter a string:",0
trs_report	DEFB	"You entered:",0

		ALIGN

;; Test for initial implementation
test_readstring
		MOV		R13,#0x10000

		ADRL	R0, trs_prompt
		SWI		3

		ADRL	R0,trs_str
		BL		ReadString

		ADRL	R0,trs_report
		SWI		3

		ADRL	R0,trs_str
		SWI		3

		MOV		R0,#10
		SWI		0
		SWI		2



;; ReadString -- read a string from the keyboard until ENTER/RETURN is pressed
;; 
;; R0 address to place string

ReadString

	; read in with SWI 1 until RETURN (10) is pressed
	; as SWI 1 moves into R0, move the address into R1

	MOV R1,R0

mainReadLoop
	SWI 1

	; check return
	CMP R0, #10
	BEQ end

	; else print it out and add to string
	SWI 0 ; print

	; add to string
	STRB R0, [R1], #1

	B mainReadLoop

end 
	; store null byte
	MOV R0,#0
	STRB R0, [R1], #1
	MOV PC,R14


;; DO NOT REMOVE THIS LABEL AFTER YOUR CODE
trs_str	DEFW	0
