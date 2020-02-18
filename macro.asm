.macro	printChar	(%a)	#macro to print character
li	$v0,	4
la	$a0,	(%a)
syscall
.end_macro

.macro	printInt	(%a)	#macro to print integer
li	$v0,	1
move	$a0,	%a
syscall
.end_macro

.macro	printString	(%a)	#macro to print a string
li	$v0,	4
la	$a0,	%a
syscall
.end_macro

.macro	printByte	(%a)	#macro to print a byte
li	$v0,	1
lw	$a0,	%a
syscall
.end_macro

.macro	printRegi	(%a)	#macro to print a register
li	$v0	4
la	$a0,	(%a)
.end_macro

.macro	printData	(%a)	#macro to print compressed data
move	$t1,	%a
lw	$t0,	sizeC		#getting size
lopD:				#outer loop
beq	$t0,	$zero,	endP	#if it went througha ll data end
lb	$t2,	($t1)		#loading byte to print
beq	$t2,	10,	norm	#checking if its a newline char
blt	$t2,	32,	num	#checking if it should be a count or char
norm:
sb	$t2,	($t3)		#characters are printted with printChar
printChar($t3)
addi	$t1,	$t1,	1
addi	$t0,	$t0,	-1
j	lopD
num:				#counts are printed with printInt
printInt($t2)
addi	$t1,	$t1,	1	#cycling through count
addi	$t0,	$t0,	-1
j	lopD		
endP:
.end_macro

.macro	getString	(%a,%b)	#getting input from user
li	$v0,	8
la	$a0,	%a
li	$a1,	%b
syscall
.end_macro

.macro	openFile	(%a,%b)	#opening file
li	$v0,	13
la	$a0,	%a
li	$a1,	%b
syscall
.end_macro

.macro	closeFile	(%a)	#closing file
li	$v0,	16
move	$a0,	%a
syscall
.end_macro

.macro	readFile	(%a,%b)	#reading from file
li	$v0,	14
move	$a0,	%a
la	$a1,	%b
li	$a2,	1024
syscall
.end_macro

.macro	quit			#to quit the program
li	$v0,	10
syscall
.end_macro

.macro	removelast(%a)		#fixing input by removing the last newline char
la	$t0,	%a		
lb	$t2,	($t0)
li	$t3,	0
loopR:				#goes through every character until it finds a null char
addi	$t0,	$t0,	1
lb	$t2,	($t0)
beq	$t2,	$0,	last	
j	loopR
last:				#if it finds the null character, then it removes the one before it
addi	$t0,	$t0,	-1
sb	$0,	($t0)	
.end_macro

.macro	getSize(%a)		#counts until finds a null character
move	$t0,	%a
li	$t2,	0
loop1:	
add	$t3,	$t2,	$t0
lb	$t4,	($t3)
beq	$t4,	0,	endS
loop2:
addi	$t2,	$t2,	1
j	loop1
endS:
move	$v0,	$t2
.end_macro

.macro compress(%a)		#compresion algo
la	$a0,	%a		#setting initial address
move	$a1,	$t9		#heap address
lw	$a2,	sizeO		#getting the size
li	$t3,	-1		#setting initial previous char
addi	$t4,	$zero,	1	#count
lb	$t2,	($a0)		#getting the byte from buffer
sb	$t2,	($a1)		#storing the char to compressed
move	$t3,	$t2		#changing the previous char
sb	$t4,	1($a1)		#setting the count as 1
loop:
addi	$a0,	$a0,	1	#address+1
lb	$t2,	($a0)		#loading next byte
beq	$t2,	0,	endC	#if null end
bne	$t2,	$t3,	dif	#if new character move jump to different
addi	$t4,	$t4,	1	#otherwise its same and add 1 to count
sb	$t4,	1($a1)
j	loop
dif:
addi	$a1,	$a1,	2	#shifting the compressed data +2 to place new char
addi	$t4,	$zero,	1	#setting count to 0
sb	$t2,	($a1)		#saving char and byte
sb	$t4,	1($a1)
move	$t3,	$t2		#setting new previous character
j	loop
endC:
getSize($a1)
move	$v0,	$a1
.end_macro

.macro uncompress	(%b)	#uncompression algo
move	$a0,	$t9		#setting address to the heap memory
la	$a1,	%b		#setting the uncompression buffer
loopU:
lb	$t0,	($a0)		#outer loop is goign through every char
beq	$t0,	10,	skipU	#checking which character it is
blt	$t0,	32,	endU	
bgt	$t0,	126,	endU
skipU:
lb	$t1,	1($a0)		#setting the char counts
move	$t2,	$0
move	$t3,	$a1
loopI:
beq	$t1,	$t2,	skipIn	#if finish setting the right char coutns skip 
sb	$t0,	($t3)		#storing byte
addi	$t3,	$t3,	1	
addi	$t2,	$t2,	1
j	loopI
skipIn:
addi	$a0,	$a0,	2	#skipping down 2 
move	$a1,	$t3
j	loopU
endU:
.end_macro

.macro alloheap			#allocating heap memory
li	$v0,	9
li	$a0,	1024
syscall
.end_macro

.macro	clear	(%a)		#clearing buffer
la	$t0,	%a
loopC:
lb	$t1,	($t0)		#loading byte to clear
addi	$t2,	$t2,	0	#loading null byte
beq	$t1,	$t2,	endC	#if its null then end clearing
sb	$t2,	($t0)		#if its not null then store null
addi	$t0,	$t0,	1	#shift down one
j	loopC
endC:
.end_macro