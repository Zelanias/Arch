#Hansu Kim hxk170004
#Homework 2
.data
a:	.word	4
b:	.word	4
c:	.word	4
oa:	.word	4
ob:	.word	4
oc:	.word 	4
name:	.word	4
pn:	.asciiz "What is your name? "
pi:	.asciiz "Please an integer between 1-100: "
r:	.asciiz "your answers are : "
space:  .asciiz " "
.text
main:
	#prmopting for name
	li $v0, 4
	la $a0, pn
	syscall
	
	#input name
	li $v0, 8
	la $a0, name
	la $a1, name
	syscall
	
	#prompting for int1
	li $v0, 4
	la $a0, pi
	syscall
	
	#input 1
	li $v0, 5
	
	#la $a0, a
	syscall
	sw $v0, a
	
	#prompting for int2
	li $v0, 4
	la $a0, pi
	syscall
	
	#input 2
	li $v0, 5
	
	#la $a0, b
	syscall
	sw $v0, b
	
	#prompting for int3
	li $v0, 4
	la $a0, pi
	syscall
	
	#input 3
	li $v0, 5
	
	#la $a0, c
	syscall
	sw $v0, c
	
	#output name
	li $v0, 4
	la $a0, name
	syscall
	
	#printing result string
	la $a0, r
	syscall
	
	#loading memory to registers
	lw $t3, a
	lw $t4, b
	lw $t5, c
	
	#result 1
	add $t0, $t3, $t3
	sub $t0, $t0, $t4
	addi,$t0, $t0, 9
	
	#printing result 1
	li $v0 1
	la $a0, ($t0)
	syscall
	
	# print space
	la  $a0, space      
	li  $v0, 4          
  	syscall
	
	#result 2
	add $t1, $t5,$t3
	sub $t1, $t1, $t4 
	sub $t1,$t1, 5
	
	#output result 2
	la $a0, ($t1)
	li $v0 1
	syscall
	
	# print space
	la  $a0, space      
	li  $v0, 4          
  	syscall
	
	#result 3
	add $t2, $t3, $t4
	subi $t2, $t2, 6
	sub $t2, $t2, $t5
	
	#output result 3
	li $v0 1
	la $a0, ($t2)
	syscall
	
	#exits program
	li $v0,10
	syscall 


#If i run the given exmaple of 10,20,30, i get the expected values of 9, 15, -6
#10,10,10 i get 19,5,4
#0,0,0 i get 9,-5,-6