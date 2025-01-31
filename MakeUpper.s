		B	test_makeupper

tmu_string	DEFB	"Hello World",0
tmu_becomes	DEFB	"' becomes '",0
tmu_eol		DEFB	"'\n",0
		ALIGN

;; Test for initial implementation
test_makeupper
		MOV		R13,#0x10000

		MOV		R0,#39
		SWI		0
		ADRL	R0,tmu_string
		SWI		3

		ADRL	R0,tmu_becomes
		SWI		3

		ADRL	R0,tmu_string
		BL		MakeUpper

		ADRL	R0,tmu_string
		SWI		3

		ADRL	R0,tmu_eol
		SWI		3

		SWI		2


;; MakeUpper -- convert the string at R0 to upper case (capital letters) in place
;; MakeUpper
;; R0 string


MakeUpper
	; iterate over every character in the string in R0 until null.


mainLoop
	LDRB R1, [R0], #1	; load content of R0 into R1

	; check for null terminator.
	CMP R1,#0
	BEQ exit

	; compare if it is a lower case - if not below z or above z
	CMP R1,#'a'
	BLT	mainLoop

	CMP R1,#'z'
	BGT mainLoop

	; now confirmed lowercase, add 32
	; update: stupid me it's SUB!
	SUB R1,R1,#32

	; ... and store back into the strin at the original address (curr -1)
	STRB R1, [R0, #-1]

	B mainLoop

exit
	MOV PC, R14

