		B	main

test	DEFB	"A room without books is like a body without a soul",0
title	DEFB	"Guess the phrase from the clue below...\n"
		DEFB	"All vowels have been removed, and the spaces redistributed\n\n",0

prompt	DEFB	"Enter your guess:\n",0
correct	DEFB	"\nCorrect.\n",0
wrong	DEFB	"\nIncorrect! Try again:\n",0

;; do NOT change the below, it works

		ALIGN

main	MOV		R13,#0x100000		; setup stack

		ADRL	R0,ansString
		ADRL	R1,test
		BL		strcpy

		ADRL	R0,ansString
		BL		MakeUpper

		ADRL	R1,ansString
		ADRL	R0,spareString
		BL		strcpy

		ADRL	R0,spareString
		BL		RemoveVowels

		; Count word lengths
		ADRL	R0,spareString
		ADRL	R1,wordLengths
		BL		CountWordLengths
		MOV		R4,R0

		;; insertion sort them
		ADRL	R0,wordLengths
		MOV		R1,R4
		BL		BubbleSort

		ADRL	R0,clueString
		ADRL	R1,spareString
		ADRL	R2,wordLengths
		MOV		R3,R4
		BL		RedistributeSpaces


		ADRL	R0,title
		SWI		3

		ADRL	R0,clueString
		SWI		3

		MOV		R0,#10
		SWI		0
		SWI		0

gloop	ADRL	R0,prompt
		SWI		3

		ADRL	R0,spareString
		BL		ReadString

		ADRL	R0,spareString
		BL		MakeUpper

		ADRL	R0,ansString
		ADRL	R1,spareString
		BL		strcmp
		CMP		R0,#0
		BEQ		crrct

incorrect
		ADRL	R0,wrong
		SWI		3
		B gloop


crrct	ADRL	R0,correct
		SWI		3

		SWI		2

;; RedistributeSpaces -- redistribute the spaces in the string at R0
;;                       based on the lengths in the wordLengths array
;; R0 -> Dest, R1 -> source
;; R2 -> wordLengths, R3 -> number of words

RedistributeSpaces
		STMFD	R13!, {R4-R9,R14}
		MOV		R5,#0
		LDR		R6,[R2,R5 LSL #2]

rsLoop	LDRB	R4,[R1],#1
		CMP		R4,#' '
		BEQ		rsSkip
		STRB	R4,[R0],#1
		SUB		R6,R6,#1
		CMP		R6,#0
		BNE		rsSkip

		MOV		R8,#' '
		STRB	R8,[R0],#1
		ADD		R5,R5,#1
		CMP		R5,R3
		BLT		rsadvance
		LDRB		R4,[R1]
		CMP		R4,#0
		BNE		rsErr
		STRB	R4,[r0],#1
rsadvance
		LDR		R6,[R2,R5 LSL #2]

rsSkip	CMP		R4,#0
		BNE		rsLoop

		LDMFD	R13!, {R4-R9,PC}

rsErr	SWI		2


;; strcmp -- compare two strings 
;; 
;; R0 address of first string
;; R1 address of second string

strcmp

		LDRB	R2,[R0],#1
		LDRB	R3,[R1],#1
		CMP		R2,R3
		BNE		csend
		CMP		R2,#0
		BNE		strcmp

csend	SUB		R0,R2,R3
		MOV		PC,R14	

		include strcpy.s
		include	ReadString.s

		include MakeUpper.s
		include CountWordLengths.s

		include RemoveVowels.s
		include BubbleSort.s

spareString	DEFS	512
ansString	DEFS	512
clueString	DEFS	512
wordLengths	DEFW	0

