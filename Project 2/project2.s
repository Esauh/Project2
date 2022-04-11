#delta = 'S'
#beta = 's'
.data
input_space: .space 1001
userinput: .asciiz "Enter Input: "
error: .asciiz "Not Recognized"
.text

main:
li $v0, 8
la $a0, input_space
li $a1, 1001
syscall
