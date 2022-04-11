#delta = 'S'
#beta = 's'
.data
input_space: .space 1001
error: .asciiz "Not Recognized"
.text

main:
li $v0, 8
la $a0, input_space #user input
li $a1, 1001
syscall
la $s0, input_space #saves user input into $s0 to be utilized

jal length		# saves the return address of the instruction and jumps to specific instruction
addi $s1, $v0, 0
addi $s2, $v1, 0

beqz $s1, invalid # if length of string equals 0 then exit program
move $a0, $s1 #end of the string will be used as a parameter
move $a1, $s0 #start of string will be used as a parameter
jal leading_removal #jumps to leading_removal function which will remove leading whitespaces

move $s0, $v0 #puts the first non-whitespace char into $s0 as an address

beqz $s1, invalid #if the length of the string is 0 go to invalid function which will end the program

move $a0, $s2 #will be used as parameter as a pointer for ending_removal function
addi $a1, $s1, 0 #will be used as parameter as the legnth for the ending_removal function
jal ending_removal #jump to the ending_removal function and return value
addi $s2, $v0, 0

beqz $s1, invalid #if the length of $s1 (input) is 0 go to invalid and end program
bgt $s1, 4, invalid	#if the length of $s1 (input) is greater than 4 go to invalid and end program

addi $a0, $s1, 0 #throw in the length of string to a function used to intialize the index and register to store our sum
move $a1, $s0 #the start of the string has to be be changed with the function mentioned above
li $a2, 29 #the exponent base is loaded since N = 29 ours is 29
jal change #jumps to the change function which should initialize the index and register to store our sum and load our character
move $s3, $v0 #this will store the final sum after all changes have taken place into $s3

li $v0, 1
addi $a0, $s3, 0
syscall

j exit

change:
li $t0, 0 #index
li $v0, 0 #stores the sum
loadchar:
lb $t1, 0($a1) #pointer to the current char been analyzed

range09:
	li $t2, '0'
	li $t3, '9'
	blt $t1, $t2, invalid # sees if the char is less than 0 and if it is go to invalid function
	bgt $t1, $t3, rangeAS # sees if the char is more than 9 and if it is go to the rangeAS function

