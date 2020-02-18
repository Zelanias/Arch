.data
original:	.asciiz		"Original data: \n"
compressD:	.asciiz		"Compressed data \n"
uncompressedD:	.asciiz		"Uncompressed data \n"
oSize:		.asciiz		"Original file size: "
cSize:		.asciiz		"Commpressed file size: "
inputname:	.asciiz		"Please enter the filename of compress or <enter> to exit:"
newline:	.asciiz		"\n"
errorline:	.asciiz		"Error opening file, exiting program"
buffer:		.space		1000
uncompressed:	.space		1000
compressed:	.word		0
filename:	.asciiz		""
sizeO:		.word		0
sizeC:		.word		0
.include	"macro.asm"
.text
#main loop
loooop:
printString(inputname)
getString(filename,100)
removelast(filename)
la	$t5,	filename	#moving the address of filename to register to get size 
getSize($t5)
beq	$v0,	0,	end	#if empty string, then exit
printString(newline)
alloheap			#allocating heap memory
move	$t9,	$v0
sw	$t9	compressed
openFile(filename,0)
move	$s0,	$v0
beq	$s0,	-1,	error
readFile($s0,	buffer)
closeFile($s0)
printString(original)
printString(buffer)
printString(newline)
la	$t5,	buffer		#moving buffer address to register to get size
getSize($t5)
sw	$v0,	sizeO
compress(buffer)
getSize($t9)
sw	$v0,	sizeC
printString(compressD)
printData($t9)
uncompress(uncompressed)
printString(newline)
printString(uncompressedD)
printString(uncompressed)
printString(newline)
printString(oSize)
printByte(sizeO)
printString(newline)
printString(cSize)
printByte(sizeC)
printString(newline)
clear(buffer)
clear(uncompressed)
j	loooop		
error:
printString(errorline)
end:
quit
