.data
SYSEXIT = 60
SYSREAD = 0
SYSWRITE = 1
STDOUT = 1
STDIN = 0
EXIT_SUCCESS = 1


control_word: .short 0		
status_word: .short 0					
komunikat: .ascii "Dzielenie przez zero\n"
rozmiar = . - komunikat
.text
.global wyjatek
.type wyjatek, @function


wyjatek:
push %rbp
mov %rsp, %rbp

		
poczatek:
push $0
fild (%rsp)
push $10
fild (%rsp)			

fdiv %st(1), %st(0)             

fstsw %ax			 
cmp $4, %al                
jne zakoncz


mov $SYSWRITE, %rax		
mov $STDOUT, %rdi
mov $komunikat, %rsi
mov $rozmiar, %rdx
syscall

fstsw status_word               		
fwait
mov status_word, %ax   

zakoncz:
fstsw status_word               		
fwait
mov status_word, %ax    			

mov %rbp, %rsp					
pop %rbp
ret
