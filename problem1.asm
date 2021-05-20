.data

input:			.space 101
prompt1:		.asciiz "Enter string (max 100 characters): "
prompt2:		.asciiz "Before: "
prompt3:		.asciiz "After: "

.text
		.globl main
main:

		# print string prompting for input
		li $v0, 4
		la $a0, prompt1
		syscall

		# read user input
		li $v0, 8
		la $a0, input
		li $a1, 100
		syscall

		# print prompt for displaying input
		li $v0, 4
		la $a0, prompt2
		syscall

		# print input before manipulation
		li $v0, 4
		la $a0, input
		syscall

		li $t0, 0 # Index counter
	
loop:
		# For loop that iterates over each byte of the input
		# Load byte at given index
		lb $t1, input($t0)
		# if byte is 0, exit
		beq $t1, 0, endloop
		# if byte is not a character, move on to next byte
		blt $t1, 65, increment 		# Non-character range
		bgt $t1, 122, increment		# Non-character range
		# if byte is upper, jump to is_upper
		blt $t1, 91, is_upper		# uppercase range
		# if byte is lower, jump to is_lower
		bgt $t1, 96, is_lower 		# lowercase range

is_upper:
		# convert byte to lowercase and store in orginal address
		addi $t1, $t1, 32 		# converts byte to lowercase
		sb $t1, input($t0) 		# stores in orginal address
		j increment

is_lower:
		# convert byte to uppercase and store in original address
		subi $t1, $t1, 32 		# converts byte to uppercase
		sb $t1, input($t0) 		# stores in orginal address
		j increment

increment:
		# increments the loop index and loops back
		addi $t0, $t0, 1
		j loop

endloop:
		# print prompt for display manipulated input
		li $v0, 4
		la $a0, prompt3
		syscall

		# print input string after manipulation
		li $v0, 4
		la $a0, input
		syscall

		# Exit program
		li $v0, 10
		syscall
