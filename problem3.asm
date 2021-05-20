## int compute(array, i){
##	if(i == 4)
##		return 0
##	else
##		value = abs(array[i] - array[i+1])
##		return value + compute(array, i+1)
##}

.data

prompt:			.asciiz "Result: "
array:			.word -5,4,3,2,1

.text
		.globl main
main:
		# function call
		la $a0, array			# first argument is address of array
		li $a1, 0			# second argument is first index of the array
		jal compute
		move $t0, $v0			# store result in $t0
		# print prompt for result
		li $v0, 4
		la $a0, prompt
		syscall
		# print the sum
		li $v0, 1
		move $a0, $t0
		syscall
		# exit the program
		li $v0, 10
		syscall

compute:
		bne $a1, 4, compute_recurse	# if not at last index do recursive case
		li $v0, 0			# if at last index return 0
		jr $ra

compute_recurse:
		sub $sp, $sp, 16		# allocate the stack
		sw $ra, 0($sp)			# save return address
		
		sw $a0, 4($sp)			# save array address in stack
		sw $a1, 8($sp)			# save index in stack
		
		lw $t0, 0($a0)			# stores value at current index to $t0
		lw $t1, 4($a0)			# stores value at next index to $t1 
		sub $t2, $t0, $t1		# stores $t0 - $t1 in $t2
		abs $t2, $t2			# stores the absolute value of $t2 in $t2
		
		sw $t2, 12($sp)			# save calculated value on stack
		
		addi $a0, $a0, 4		# increment the address
		addi $a1, $a1, 1		# increment the index
		jal compute
		
		lw $t2, 12($sp)
		add $v0, $t2, $v0		# return value
		
		lw $ra, 0($sp)			# restore $ra
		lw $a0, 4($sp)			# restore array address
		lw $a1, 8($sp)			# restore index
		lw $t2, 12($sp)
		add $sp, $sp, 16		# free up the stack
		
		jr $ra				# return
