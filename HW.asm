#Hello world

.data
a:	.word	-4

.text
main:
	lw	$t0,a	
	bgt $t0,$zero,exit
	neg $t0, $t0
exit:	li $v0,10
	syscall 
