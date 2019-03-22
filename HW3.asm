.data
string:		.asciiz		"Enter some text:"
buffer:		.space		100
progend:	.asciiz		"goodbye"
word:		.asciiz		" words "
chars:		.asciiz		" characters "		
nline:		.asciiz		"\n"
.text
loop1:	
	#initializing the prompt with syscall 54
	li	$v0,	54
	la	$a0,	string #String to print
	la	$a1,	buffer #where to store input
	addi 	$a2, 	$a2,	100 #Max chars same size as input buffer
	syscall
	beq	$a1,	-3,	exit #checks for empty input
	beq	$a1,	-2,	exit #checks for cancel input
	jal	funct	#jumps with return pinter to main fucntion
	addi	$sp,	$sp,	-4 #stack moved back to save character count
	sw	$v0,	($sp) #storing v0
	li	$v0,	4 #setting v0 to print string for syscall
	la	$a0,	buffer
	syscall
	and 	$a0,	$a0,	0 #clearing a0 with and 0 
	or	$a0,	$a0,	$v1 #setting a0 with or and v1
	li	$v0,	1 #setting syscall to 1 to print int
	syscall
	li	$v0,	4 #setting syscall to 4 to print string
	la	$a0,	word
	syscall
	and	$a0,	$a0,	0  #clearing a0 
	lw	$v0,	($sp) #using buffer to get back character count
	addi	$sp,	$sp,	4 #moving pointer up 4
	or	$a0,	$a0,	$v0 #setting a0 to char count with or
	li	$v0,	1
	syscall
	li	$v0,	4 #setting v0 to 4 to print string
	la	$a0,	chars
	syscall
	la	$a0,	nline #printing newline
	syscall
	j	loop1	 #loops back to beginning to get next input string
funct:
	la	$t1,	buffer #setting t1 to the address of the input string
	li 	$v0, 	0	#setting v0 aka character count as 0 
	li	$v1,	1	#setting v1 aka word count to 1
	li	$t4,	0	#setting i to 0
	
loop:
	move	$s1,	$t5	#setting s1 to t5
	addi	$sp,	$sp,	-4	#moving stack pointer back 4
	sw	$s1,	($sp)		#adding s1 to stack
	add	$t5,	$t4,	$0	#setting t5 to t4, as t4 is position in string 
	add	$t5,	$t5,	$t1	#adding t5 to t1, as t1 is base address, t5 is the address of the byte to read
	lb	$t2,	($t5)		#reading in byte of character
	bne 	$t2,	32,	end	#if not a space skip the adding 1 to word counter
	addi	$v1,	$v1,	1	#adding 1 to word counter
end:	
	beq	$t2,	$0,	back	#checking if the character is the null end string char, if so goes to the end of the fucntion
	addi 	$t4, 	$t4,	1	#increasing i by 1
	lw	$s1,	($sp)		#restoring s1 from satck
	move	$s1,	$t5		#restoring t5 from s1
	addi	$sp,	$sp,	4	#moving stack pointer back 4
	j	loop			#going back to the beginning of the loop
back:	
	add	$v0,	$v0,	$t4	#setting v0 as the character count 
	addi	$v0,	$v0,	-1	#removing 1 to v0, as through test cases it seems like it was adding one somewhere extra
	jr	$ra			#jumping back to restore pointer to print out results
exit:
	li	$v0,	59		#setting v0 to 59 for end prompt
	la	$a0,	progend		
	syscall
	li	$v0,	10		#setting v0 to 10 to end program
	syscall
