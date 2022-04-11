#delta = 'S'
#beta = 's'
.data
input_space: .space 1001
userinput: .asciiz "Enter Input: "
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

