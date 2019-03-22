.data
namestring:	.asciiz		 "What is your name? "
heightstring:	.asciiz		 "Please enter your height in inches: "
weightstring:	.asciiz		 "Now enter your weight in pounds (round to a whole number): "
bmi:		.asciiz 	", your bmi is: "
under	: 	.asciiz		"This is considered underweight."
normal:		.asciiz		"This is a normal weight."
over:		.asciiz		"This is considered overweight."
obese:		.asciiz		"This is considered obese."
newline:	.asciiz		"\n"
name:		.space	20		
		.align	3
height:		.word		0
		.align		3
weight:		.word		0

.text
	li	$v0,	4		#syscall 4 to print string
	la	$a0,	namestring	#setting output string to namestring
	syscall
	
	li	$v0,	8		#syscall 8 to get input string
	la	$a0,	name		#setting address to store input
	li	$a1,	100		#setting ax size to read input
	syscall
	
	li	$v0,	4		#syscall 4 to print string
	la	$a0,	heightstring	#setting ouptut string
	syscall	
	
	li	$v0,	5		#syscall 5 to read int
	syscall	
	sw	$v0,	height		#store input to data height
	
	li	$v0,	4		#syscall 4 to print string
	la	$a0,	weightstring	#setting output string to weightstring
	syscall
	
	li	$v0,	5		#setting syscall to read int
	syscall
	sw	$v0,	weight		#storing input int to data label weight
	
	li	$t1,	703		#Loading the bmi constant 
	lw	$t2,	height		#loading height into register
	lw	$t3,	weight		#loading weight into register
	
	mtc1	$t1,	$f2		#moving constant regsiter to float registers
	l.d	$f4,	height		#loading in height into float register
	l.d	$f6,	weight		#loading in weight into float register
	
	cvt.d.w	$f2,	$f2		#converting int to float
	cvt.d.w	$f4,	$f4		#converting int to float
	cvt.d.w	$f6,	$f6		#converting int to float
	
	mul.d	$f8,	$f4,	$f4	#Multiplying height by itself
	mul.d	$f10,	$f2,	$f6	#multiplying weight by conatnt
	div.d 	$f0,	$f10,	$f8	#dividing the two values
	
	li	$v0,	4		#setting syscalll to print string
	la	$a0,	name		#setting string to print
	syscall
	la	$a0,	bmi		#setting syscalll to print bmi	string
	syscall				#printing out 
	li	$v0,	3		#setting syscall to print out float
	mov.d	$f12,	$f0		#moving the caluclated bmi register to the print register
	syscall
	li	$v0,	4
	la	$a0,	newline
	syscall
	
	li 	$t1,	0x41940000	#loading in the bmi values to compare to in registers
	li	$t2,	25
	li	$t3,	30
	
	mtc1	$t1,	$f2		#moving the valuesin the registers to float registers
	mtc1	$t2,	$f4
	mtc1	$t3,	$f6
	
	cvt.d.w	$f2,	$f2		#converting int to float
	cvt.d.w	$f4,	$f4		#converting int to float
	cvt.d.w	$f6,	$f6		#converting int to float
	
	li	$v0	4
	
	c.lt.d	$f0,	$f2		#comparing if bmi<18.5
	bc1f	norm			#moving to the next 25 comparision is false
	la	$a0,	under 		#setting output sstring to underweight
	syscall
	j exit				#jumping to exit
	
	norm:				#same as underweight but for normal
	c.lt.d	$f0,	$f4
	bc1f	ov
	la	$a0,	normal
	syscall
	j exit
	
	ov:				#same as normal weight but for being over weight
	c.lt.d	$f0,	$f6
	bc1f ob
	la	$a0,	over
	syscall
	j exit
	
	ob:				#default case of obese
	la	$a0,	obese
	syscall
	
	exit:				#exit
	li	$v0,	10
	syscall
