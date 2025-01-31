		B	test_isvowel

tsv_vowel	DEFB	"ABCDEFGHIJKLMNOPQRSTUVWXYZ"

		ALIGN

;; Test for initial implementation
test_isvowel
		MOV		R13,#0x10000

		ADRL	R4,tsv_vowel
		MOV		R5,#26
tsv_loop
		LDRB	R6, [R4],#1
		MOV		R0, R6
		SWI		0

		MOV		R0,#32
		SWI		0
		
		MOV		R0,R6
		BL		isVowel
		SWI		4

		MOV		R0,#10
		SWI		0
		SUB		R5,R5,#1
		CMP		R5,#0
		BGT		tsv_loop

		SWI		2


;; isVowel -- test whether character in R0 is a vowel or not
;; R0 <--- character
;; Returns in  R0: 1 if R0 contained a vowel, 0 otherwise

isVowel
;; Insert your code here

	; Compare all AEIOU if is in R0
	CMP R0,#'A'
	BEQ isActuallyVowel

	CMP R0,#'E'
	BEQ isActuallyVowel

	CMP R0,#'I'
	BEQ isActuallyVowel

	CMP R0,#'O'
	BEQ isActuallyVowel

	CMP R0,#'U'
	BEQ isActuallyVowel

	; Is not a vowel, so set to 0
	MOV R0,#0

	; Optimise instruction amounts by having end immediately here, and as
	; most letters are not vowels
	MOV PC,R14 	; Move the branch with link instruction return address to the program counter

isActuallyVowel
	; Set R0 to 1 as per specifcation and branch to end instruction
	MOV R0,#1
	B end