.data
before: 	.asciiz		"The array before: "
after:		.asciiz		"The array after: "
mean:		.asciiz		"The mean is: "
median:		.asciiz		"The median is: "
sd:		.asciiz		"the standard deviation is: "
data:		.asciiz		"/home/zelanias/Documents/input.txt"
list:		.word		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
input:		.space		80

.macro print	(%a)
li	$v0	4
la	$a0	%a
syscall
.end_macro

.macro printR	(%a)
li	$v0	4
la	$a0	(%a)
syscall
.end_macro

.macro	printArray 	(%b)
li	$t0,	0
la	$t1,	list
pAloop:
beq	$t0,	%b,	pAend
printR($t1)
addi	$t0,	$t0,	1
addi	$t1,	$t1,	4
j	pAloop
pAend:

.end_macro

.macro toInt	(%1)
li	$t0,	48
li	$t1,	57
li	$t3,	10	
move	$t2	%1
addi	$v0,	$0,	1
blt	$t2,	$t0,	Iend
bgt	$t2,	$t1,	Iend
beq	$t2,	$t3,	Inl
addi	$v0,	$t2,	-48
j Iend
Inl:
addi	$v0,	$0,	10
Iend:
.end_macro

.macro	extract
la	$a0,	list
li	$a1,	20
la	$a2,	input
li	$t5,	0

eLoop:
lb	$t4,	($a2)
addi	$a2,	$a2,	4
	
toInt($t4)
#checking results for converting byte to int
beq	$v0,	10,	next
beq	$v0,	0,	eend
beq	$v0,	1,	eLoop

#if two digit int
beq	$t5,	1,	two
addi	$t5,	$t5,	1
move	$t6,	$v0
j	eLoop
two:

#mult by 10 and add v0
j	eLoop

next:
lw	$a0,	($t6)
addi	$a2,	$a2,	4
addi	$t5,	$0,	0
j	eLoop
eend:
.end_macro

.macro	sort	(%a)
la	$a0,	list
li	$a1,	20
.end_macro

.text
#opening file
li	$v0,	13
la	$a0,	data
li	$a1,	0
li	$a2,	0
syscall
move	$s1,	$v0

#reading file
li	$v0,	14	
move	$a0,	$s1
la	$a1,	input
li	$a2,	80
syscall
#closing file
li   	$v0, 	16       # system call for close file
move	$a0,	$s1      # file descriptor to close
syscall            	 # close file
	
extract
printArray(20)

#exit
li	$v0	10
syscall
