.bss
.comm prec, 4
.comm begin, 4
.comm end, 4
.comm _dx, 4
.comm x, 4
.comm xp, 4
.comm dx, 4
.comm d, 4
.comm result, 4
.comm temp, 4

.text
.global calka

.type calka, @function
.type funkcja, @function
.type liczx, @function

calka:
push %rbp
mov %rsp, %rbp

mov $0, %r12
mov %rdi, prec(,%r12,4)#pobranie precyzji
movss %xmm0, begin      #pobranie dolnej granicy
movss %xmm1, end        #pobranie gornej granicy
movss %xmm2, d
mov %rsi, %r10

flds end        #xk
fsub begin      #(xk - xp)
fidiv prec      #((xk - xp)/n

fstps _dx       

fldz    

petla:

movss begin, %xmm0      
movss _dx, %xmm1        

call liczx

call funkcja

movss %xmm0, result

fadd result     #dodaje prostokaty

dec %rdi        #dekrementuje licznik
cmp $0, %rdi    #jesli 0 to konczymy prace
je koniec
jmp petla

koniec:    
fmul _dx
fstps result    
movss result, %xmm0

movq %rbp, %rsp
popq %rbp
ret


liczx:
push %rbp      
mov %rsp, %rbp

     
mov %rdi, prec(,%r12,4)
movss %xmm0, xp
movss %xmm1, dx

fild prec       # i
fmul dx # i*dx
fadd xp # xp + i*dx

fstps result
movss result, %xmm0     

movq %rbp, %rsp         
popq %rbp
ret

funkcja:

push %rbp
mov %rsp, %rbp
mov %r10, %r9
movss %xmm0, x  
flds x

petla1:
cmp $1, %r9
je dalej
fmul x
dec %r9
jmp petla1

dalej:

flds d
fxch
fmul %st(1)
fstps result    #pobranie wyniku
fstps temp      #czyszcze stos ze smieci pozostawionych przez funkcje

movss result, %xmm0     #wynik do %xmm0

mov %rbp, %rsp
pop %rbp
ret
