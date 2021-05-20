.data

prompt:			.asciiz "Result: "
array:			.word 1,2,3,4,5,6,7
size:			.word 7
total:			.word 0

.text
		.globl main
main:
		la $t0, array		# $t0 is a pointer to the current index
		la $t1, total		# $t1 is a pointer to the running total
		li $t2, 0		# $t2 is the index counter
		lw $t3, size		# $t3 is the size of the array
loop:
		# endloop when index counter is equal to size of array
		beq  $t2, $t3, endloop
		# call function
		jal updateSum
		# increment index counter and pointer
		addi $t2, $t2, 1
		addi $t0, $t0, 4
		j loop

endloop:
		# print prompt for sum
		li $v0, 4
		la $a0, prompt 
		syscall
		# print sum
		li $v0, 1
		lw $a0, 0($t1)
		syscall
		# exit program
		li $v0, 10
		syscall

updateSum:
		# load value stored at index
		lw $t4, 0($t0)
		# load value of running total
		lw $t5, 0($t1)
		# square value
		mult $t4,$t4
		# store multiplied value
		mflo $t6
		# add squared value to total
		add $t7,$t6,$t5
		# store new total into current total address
		sw $t7, 0($t1)
		# return
		jr $ra
