/* prime01.s */
.data
.balign 4
testvalue:
	.word	0	@ The number we want to test for primacy

.balign 4
factor:
	.word	0	@ The number we are going to test as a factor of testvalue

.balign 4
limit:
	.word	0	@ This will be the top of the for loop.  testvalue - 1
.balign 4
isprimemsg:
	.asciz	"%d is a prime number.\n"

.balign 4
notprimemsg:
	.asciz	"%d is not a prime number.\n"

.balign 4
scanpattern:
	.asciz	"%d"

.balign 4
inputmsg:
	.asciz	"Input test value: "

.balign 4
toosmallmsg:
	.asciz	"%d is too small.  Value must be greater than 5.\n"

.text
.global main
.global scanf
.global printf

main:
	@Get the test value from the user
	ldr r0, =inputmsg		@ Load the input message address to r0
	bl printf			@ Print the input message. No variables so r0 only

	ldr r0, =scanpattern		@ Load the address of the scan pattern for user input to r0
	ldr r1, =testvalue		@ Load the address of the test value to r1
	bl scanf			@ Get the user input and store it at the address in r1

	@ Check test value is > 5	@ We are not going to consider primes below 5
	ldr r0, =testvalue		@ Load the address for the test value to r0
	ldr r0, [r0]			@ Load the value for test value to r0
	mov r1, #5			@ Load value 5 into r1.  Mov faster than ldr
	cmp r0, r1			@ Check if r1 > r0
	bmi toosmall			@ If r1 > r0 then jump to too small function

	ldr r0, =limit			@ Load r0 with the address for the upper limit for testing
	ldr r1, =testvalue		@ Load r1 with the address of the test value
	ldr r1, [r1]			@ Load r1 with the actual test value
	sub r1, r1, #1			@ Subtract 1 from the test value
	str r1, [r0]			@ And store this value as the upper limit

	ldr r0, =factor			@ Load r0 with the address of the factor to test
	mov r1, #2			@ Load r1 with the value 2
	str r1, [r0]			@ Store the first test factor

checkfactor:
	ldr r0, =testvalue		@ Load r0 with the address of the test value
	ldr r0, [r0]			@ Load r0 with the value for test value
	ldr r1, =factor			@ Load r1 with the address for the test factor
	ldr r1, [r1]			@ Load r1 with the value for the test factor
	ldr r2, =limit			@ Load r2 with the address for the upper limit for testing
	ldr r2, [r2]			@ Load r2 with the value for the upper limit for testing
	cmp r2, r1			@ See if the current value of factor has reached limit
	beq isprime 			@ if it has and we have not yet failed then jump to is prime function

subtractloop:
	cmp r0, #0			@ Check if r0 is exactly zero. 
	beq notprime			@ If it is then factor value is a factor of test value
	bmi nextfactor			@ If r0 has gone negative then factor is not a factor and it's time to check then next factor
	sub r0, r0, r1			@ Otherwise continue with division via subtraction
	b subtractloop

nextfactor:
	ldr r0, =factor			@ Load r0 with the address of the current test factor
	ldr r1, [r0]			@ Load r1 with the value of the current test factor
	add r1, r1, #1			@ Increment the test factor value by one
	str r1, [r0]			@ Store the new test factor back in the address held in r0
	b checkfactor			@ Jump back and test the next factor

toosmall:
	ldr r0, =toosmallmsg		@ Load r0 with the error message about not testing values less than five
	ldr r1, =testvalue		@ Load r1 with the address of the test value
	ldr r1, [r1]			@ Load r1 with the value of the test value
	bl printf			@ Print the error message
	b end				@ Jump to the end and terminate

notprime:
	ldr r0, =notprimemsg		@ Load r0 with the not prime message
	ldr r1, =testvalue		@ Load r1 with address of the test value
	ldr r1, [r1]			@ Load r1 with the value of test value
	bl printf			@ Print the not prime message
	b end				@ Jump to the end and terminate

isprime:
	ldr r0, =isprimemsg		@ Load r0 with the is prime message
	ldr r1, =testvalue		@ Load r1 with the address of test value
	ldr r1, [r1]			@ Load r1 with the value of test value
	bl printf			@ Print the is prime mesage
	b end				@ Jump to the end and terminate
end:
	mov r7, #1			@ Load r7 with the termination value
	svc 0				@ Call syscall and terminate
