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
beq $t0, $a0, valid #needed to make sure that the current char index is valid

range09:
li $t2, '0'
li $t3, '9'
blt $t1, $t2, invalid # sees if the char is less than 0 and if it is go to invalid function
bgt $t1, $t3, rangeAS # sees if the char is more than 9 and if it is go to the rangeAS function
sub $t1, $t1, $t2
sub $t4, $a0, $t0 #initialize index for exponent loop
li $t5, 1

firstloop:
beq $t4, 1, firstelse
mul $t5, $t5, $a2
addi $t4, $t4, -1
j firstloop

firstelse:
mul $t5, $t5, $t1 #convert the char
add $v0, $v0, $t5 #add conversion to the overall sum
addi $a1, $a1, 1  #increment pointer
addi $t0, $t0, 1  #increment loop index
j loadchar

rangeAS:
li $t2, 'A'
li $t3, 'S'
blt $t1, $t2, invalid
bgt $t1, $t3, rangeas
addi $t1, $t1, -55
sub $t4, $a0, $t0 #initialize index for exponent loop
li $t5, 1

secondloop:
beq $t4, 1, secondelse
mul $t5, $t5, $a2
addi $t4, $t4, -1
j secondloop

secondelse:
mul $t5, $t5, $t1
add $v0, $v0, $t5
addi $a1, $a1, 1
addi $t0, $t0, 1
j loadchar

rangeas: #checks if char is a through s
li $t2, 'a'
li $t3, 's'
blt $t1, $t2, invalid
bgt $t1, $t3, invalid
addi $t1, $t1, -87
sub $t4, $a0, $t0
li $t5, 1

thirdloop:
beq $t4, 1, thirdelse
mul $t5, $t5, $a2
addi $t4, $t4, -1
j thirdloop

thirdelse:
mul $t5, $t5, $t1 #convert the char
add $v0, $v0, $t5 #add conversion to the overall sum
addi $a1, $a1, 1  #increment pointer
addi $t0, $t0, 1  #increment loop index
j loadchar

valid:
jr $ra #jumps to address in $ra

invalid:
la $a0, error
li $v0, 4
syscall
j exit

exit:
li $v0, 10
syscall

length:
li $t0, 0 #initialize the count as 0

noneloop: #loop function through the count
lb $t1, 0($a0)
beqz $t1, return
addi $a0, $a0, 1
addi $t0, $t0, 1 #increment the loop counter
j noneloop

return:
move $v0, $t0
addi $v0, $v0, -1 #minus excess
move $v1, $a0 #pointer to last char
addi $v1, $v1, -2
jr $ra #jumps to address $ra

leading_removal: #gets pointer for 1st non-spaced char and the length of the string without spaces
li $t1, 0 #index for coming loop
li $t2, 32 # decimal value for the space char
li $t3, 9 #decimal value for the tab value

pointerloop:
lb $t0, 0($a1) #pointer to start of string in $t0
beq $t0, $t2, increment
beq $t0, $t3, increment
beq $t0, $a0, invalid
j nonwhitespacereturn

increment:
addi $a1, $a1, 1 #add to string pointer
addi $t1, $t1, 1 #add to the loop counter
j pointerloop # go back to pointer loop and cotinue


nonwhitespacereturn:
move $v0, $a1
sub $s1, $s1, $t1
jr $ra

ending_removal:
li $t1, 0 #ending pointer loop counter
li $t2, 32 #space decimal value
li $t3, 9 #tab decimal value

endpointerloop:
beq $t1, $a1, lastcharreturn
lb $t0, 0($a0)
beq $t0, $t2, decrement
beq $t0, $t3, decrement
j lastcharreturn

decrement:
addi $a0, $a0, -1 #minus string index pointer by 1
addi $t1, $t1, 1 #increment the loop counter by 1
j endpointerloop

lastcharreturn:
move $v0, $a0
sub $s1, $s1, $t1
jr $ra
