.data
control_word: .short 0
 
.text
 
.global ustaw, sprawdz, liczba
.type ustaw, @function
.type sprawdz, @function
.type liczba, @function
ustaw:
push %rbp
mov %rsp, %rbp
 
mov $0, %rax
fstcw control_word
fwait
mov control_word, %ax
 
   
nearest:
and $62463, %ax
 
cmp $0, %rdi
je koniec
cmp $1, %rdi
je down
cmp $2, %rdi
je up
cmp $3, %rdi
je trunc
 
down:
xor $1024, %ax
jmp koniec
 
up:
xor $2048, %ax
jmp koniec  
 
trunc:
xor $3072, %ax
jmp koniec  
 
koniec:
mov %ax, control_word
fldcw control_word
 
mov %rbp, %rsp
pop %rbp
ret
 
liczba:

push %rbp
mov %rsp, %rbp


sub $8, %rsp
movsd %xmm0, (%rsp)
fld (%rsp)	
fwait 


fstp (%rsp)
movsd (%rsp), %xmm0


mov %rbp, %rsp
pop %rbp
ret
 
sprawdz:
   
mov $0, %rax
fstcw control_word
fwait
mov control_word, %ax
and $3072, %ax
 
ret
