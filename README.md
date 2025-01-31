# Missing Vowels Game in ARM32 Assembly

> A challenging word puzzle game inspired by BBC 2's 'Only Connect' show, implemented in ARM32 assembly language.

[Video Demo](https://youtu.be/4Pe0jRC7QwE)

## Table of Contents
- [Game Overview](#game-overview)
- [How it works](#how-it-works)
- [Assembling and Running](#assembling-and-running)
  - [Prerequisites](#prerequisites)
  - [Running the Game](#running-the-game)
- [Notes](#notes)
- [Technical Implementation](#technical-implementation)
  - [Components](#components)
    - [String Manipulation](#string-manipulation-easy)
    - [Vowel Manipulation](#vowel-manipulation-moderate)
    - [Word Processing](#word-processing-very-hard)
  - [What I've learned](#what-ive-learned)

## Game Overview

This is an implementation of an ARM program that plays a variant of the missing vowels round in the BBC 2 game show 'Only Connect'. In this, a well-known phrase is taken, the vowels are removed and then the spaces shifted about to form a new string of characters. You then have to guess what the original phrase was.

## How it works

At a high level, the game works as follows. First, the phrase to be guessed is converted to upper case (i.e. all capitals). Then all the vowels (`A`, `E`, `I`, `O` and `U`) are removed from the string. 

Next, an array is built containing the length of all the 'words' left in the phrase. This array is then sorted using insertion sort. This sorted array is then used to redistribute the spaces in the string so that the 'words' get longer as you reach the end of the string.

Finally, the game can begin and the user is shown the phrase with the missing vowels and redistributed spaces and asked to guess what the word might be. A line of text is read from the user, converted to upper case, and then compared against the original string. IF they match then `Correct` is printed and the game ends. If they do not match, then the program loops and asks the user to guess again. This continues to loop until the user correctly guesses the phrase.

**tl,dr:**

Players are presented with a phrase where all vowels have been removed and spaces redistributed, making you really think about language. For example:

```
	BLH BLH BLH
```

would be given as input, and you would have to guess that the phrase is:

```
	BLAH BLAH BLAH
```


## Assembling and Running

### Prerequisites
- A Linux machine or VM
- kmd assembler

> I would have loved to make this work in a browser to make it more accessible, but assemblers are very low-level and require direct access to the CPU (at least, the ones I know of) - so please bear with me or watch the video demo!

### Running the Game
I use the "kmd" (or Komodo) assembler, made by Manchester University after following an online course on ARM assembly. You can find it here. To output it, follow the steps:

- Download and run the kmd assembler.
- Clone the repo INTO A LINUX MACHINE (kmd doesn't work on Windows). You can't just copy `MissingVowels.s` as it relies on including the other helper files.
- Open a terminal and run kmd -e & to open KoMoDo.
- In Komodo, in the top right, press "Browse", navigate to the folder where your `MissingVowels.s` file is, and click OK.
- Press "Compile" and then "Load".
- Press "Features" to open the output window (used for SWI calls - kmd interprets these as print statements).
- Resize the window to your liking and press "Run".
- Follow the instructions in the output window to play the game.


## Notes
The `.s` files are the assembly code files, and the `.kmd` files are the output files from the assembler - aka the raw hexadecimal instructions for the ARM CPU to execute!

This program fully abides by the Arm Procedure Call Standard (APCS) and uses the SWI calls to interact with the user. 

Here's a diagram of the APCS for reference, and how registers are used in ARM32 assembly:

[APCS](/arm-procedure-call-standard.png)

# Technical Implementation

## Components

### String Manipulation (Easy!)
- `strcpy` is the string copying functionality -- equivalent to the C standard library that does this!
- `MakeUpper` converts lowercase to uppercase using ARM's efficient bit manipulation and ASCII codes.
- `ReadString` is a loop that takes input from the user.
- `CountWordLengths` uses the array length and character ASCII codes to return length of words

The only real challenge here is detecting string termination to prevent unbound memory access, and pointer arithmetic.

### Vowel Manipulation (moderate)
- `isVowel` allows for fast vowel detection using comparison chains
- `RemoveVowels` is in-place string modification in memory (!!) with minimal overhead or usage

Maintaining string integrity while removing characters was challenging due to the reduction in expected byte sizes and character array (aka string) lengths leading to out-of-bounds writes often.

### Word Processing (very hard!)

The word processing stage was by far the most intricate and annoying part of this project. Implementations in [`BubbleSort.s`](BubbleSort.s) and [`InsertionSort.s`](InsertionSort.s) required a lot of thought, planning and of course trial and error. 

The main difficulties were:
1. Complicated array manipulation. These algorithms require a lot of pointer arithmetic (with some requiring multiple of said pointers) and ensuring that the correct values are being accessed, with no out-of-bounds access.
2. Edge cases. The algorithms had to be able to handle words of different lengths, words being next to each other, and words being at the start or end of the string, and checking for null terminators.
3. Translating the high-level sorting concepts into ARM32 assembly routines. This required a lot of thought and planning to ensure that the algorithms were efficient and correct. 


### What I've learned

TL;DR: **Something in assembly is always 10x harder than you think it will be. In a high-level language, you could do something in 1 line, but in assembly, it could take well over 100 lines.**

Assembly really is a different way of thinking. It's not just about writing code, it's about understanding how the computer works at a fundamental level. This project has really helped me to understand how the computer works at a low level, and how to write efficient code that takes advantage of the computer's architecture. I would recommend it -- but I'm going to have a break from assembly for a while!

**Thanks for reading and I hope you enjoy the game and rate the project highly! 😄**