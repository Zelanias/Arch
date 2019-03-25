.data
before: 	.asciiz		"The array before: "
after:		.asciiz		"The array after: "
mean:		.asciiz		"The mean is: "
median:		.asciiz		"The median is: "
sd:		.asciiz		"the standard deviation is: "
data:		.asciiz		"input.txt"
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

.macro	printArray 
li	$t0,	1
la	$t1,	list
pAloop:
beq	$t0,	21,	pAend
li	$v0,	1
lw	$a0,	0($t1)
syscall
li	$v0,	11
li	$a0,	32
syscall
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
addi	$v0,	$0,	-1
beq	$t2,	$0,	InEnd
beq	$t2,	$t3,	Inl
blt	$t2,	$t0,	Iend
bgt	$t2,	$t1,	Iend
addi	$v0,	$t2,	-48
j Iend
Inl:
addi	$v0,	$0,	10
j	Iend
InEnd:
addi	$v0,	$0,	0	
Iend:
.end_macro

.macro	extract
la	$a0,	list
li	$a1,	20
la	$a2,	input
li	$t5,	0

eLoop:
lb	$t4,	0($a2)
addi	$a2,	$a2,	1
toInt($t4)
#checking results for converting byte to int
beq	$v0,	10,	next
beq	$v0,	0,	eend
beq	$v0,	-1,	eLoop

#if two digit int
beq	$t5,	1,	two
addi	$t5,	$t5,	1
move	$t6,	$v0
j	eLoop
two:

#mult by 10 and add v0
mul	$t6,	$t6,	10
mflo	$t6
add	$t6,	$t6,	$v0
j	eLoop

next:
sw	$t6,	($a0)
addi	$a0,	$a0,	4
addi	$t5,	$0,	0
j	eLoop
eend:
sw	$t6,	($a0)
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
printArray

#exit
li	$v0	10
syscall
