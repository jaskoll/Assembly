.data
SYSEXIT = 60
SYSREAD = 0
SYSWRITE = 1
STDOUT = 1
STDIN = 0
EXIT_SUCCESS = 1
buflen = 1024

tekst: .ascii "Podaj liczbe\n"
tekstlen = . -tekst
tekst2: .ascii "Wynik\n"
tekst2len = . -tekst2

.bss
.comm bufor, buflen
.comm bufor2, buflen
.text
.globl _start

_start:
#wczytywanie pierwszej liczby hex
mov $SYSWRITE, %rax
mov $STDOUT, %rdi
mov $tekst, %rsi
mov $tekstlen, %rdx
syscall

mov $SYSREAD, %rax
mov $STDIN, %rdi
mov $bufor, %rsi
mov $buflen, %rdx
syscall

sub $2, %rax #warunek końcowy o jeden krótszy niż ilość cyfr 
mov %rax, %r9 #przeniesienie warunku końcowego pętli do r9
mov $0, %r12
mov %r9, %r12 #warunek końcowy pętli
mov %r9, %r13 #warunek końcowy pętli
mov $0, %r9 #wyczyszczenie r9 (licznik)

mov $16, %r10

petla:

mov $0, %r8 #czyszczenie licznika mnożenia
mov $1, %rax #przeniesienie '1' do rax
cmp %r12, %r9 #porównanie, licznika z warunkiem końcowym pętli
jg wczytywanie #jeśli licznik większy to skok do wczytywanie
mov $0, %rbx
movb bufor(,%r9,1), %bl #przenoszenie po bajcie kodu ascii 
cmp $'A', %bl #sprawdzenie czy litera
jge litera #jeśli tak to skok do litera
sub $48, %rbx #odjęcie 48 od kodu ascii cyfry
cmp %r9, %r12 #porównanie, licznika z warunkiem końcowym pętli
je dodaj #jeśli licznik równy to skok do dodaj
#mnozenie liczby '1' przez '16', odpowiednia ilosc razy (dla kolejnej pozycji warunek koncowy jeden mniejszy)
jmp pomnoz1 

#sekwencja jeśli znak to litera
litera:
sub $55, %rbx #odjecie od litery '55'
cmp %r9, %r12 #porównanie, licznika z warunkiem końcowym pętli 
je dodaj #jeśli licznik równy to skok do dodaj

pomnoz1:
cmp %r8, %r13 #porównanie licznika mnożeń z warunkiem końcowym petli mnozen
je pomnozz #jesli rowne skok do pomnozz
mul %r10 #mnozenie przez 16
inc %r8 #zwiekszenie licznika mnożeń
mov %rax, %rdx #przeniesienie wyniku mnozen liczby '16'
jmp pomnoz1 

#wymnażanie poteg '16' przez cyfry liczby hexa
pomnozz:
mov %rbx, %rax #przeniesienie odczytywanych znaków w systemie hexa do rax
mul %rdx #pomnozenie znaku przez potegi '16'
add %rax, %r15 #sumowanie kolejnych iloczynów  
mov $1, %rax #powrotne przeniesienie '1' do raxa
inc %r9 #zwiększenie licznika petli znakow liczby hexa
dec %r13 #zmniejszenie licznika mnozen
jmp petla

#dodawanie ostatniej cyfry do sumy iloczynow, bo potega '16' przy ostatnim znaku rowna 0
dodaj:
add %rbx, %r15 #dodanie do sumy iloczynow ostatniego znaku
inc %r9 #zwiększenie licznika petli znakow liczby hexa
dec %r13 #zmniejszenie licznika mnozen
jmp petla

#wczytywanie drugiej liczby
wczytywanie:
mov $SYSWRITE, %rax
mov $STDOUT, %rdi
mov $tekst, %rsi
mov $tekstlen, %rdx
syscall

mov $SYSREAD, %rax
mov $STDIN, %rdi
mov $bufor, %rsi
mov $buflen, %rdx
syscall

sub $2, %rax #warunek końcowy o jeden krótszy niż ilość cyfr 
mov %rax, %r9 #przeniesienie warunku końcowego pętli do r9
mov $0, %r12
mov %r9, %r12
mov %r9, %r13
mov $0, %r9

mov $16, %r10

petla1:

mov $0, %r8
mov $1, %rax
cmp %r12, %r9
jg wyczysc
mov $0, %rbx
movb bufor(,%r9,1), %bl
cmp $'A', %bl
jge litera1
sub $48, %rbx
cmp %r9, %r12
je dodaj1
pomnoz12:
cmp %r8, %r13
je pomnozz1
mul %r10
inc %r8
mov %rax, %rdx
jmp pomnoz123


litera1:
sub $55, %rbx
cmp %r9, %r12
je dodaj1

pomnoz123:
cmp %r8, %r13
je pomnozz1
mul %r10
inc %r8
mov %rax, %rdx
jmp pomnoz123


pomnozz1:
mov %rbx, %rax
mul %rdx
add %rax, %r14
mov $1, %rax
inc %r9
dec %r13
jmp petla1

dodaj1:
add %rbx, %r14
inc %r9
dec %r13
jmp petla1


wyczysc:
mov $10, %r11 #przeniesienie 10 do r11
mov $0, %r9 #wyzerowanie r9

#sprawdzamy NWD
petla2:
cmp %r14, %r15 #porownanie dwoch liczb
je wynik #jesli rowne to skok do wynik
cmp %r14, %r15 #porownanie dwoch liczbo
jg roznica #jesli r15 wieksze to skok do roznica
cmp %r14, %r15 #porownanie dwoch liczb
jl roznica1 #jesli r15 mniejsze to skok do roznica1
jmp petla2


wynik:
mov %r14, %rax
jmp sprawdz

roznica:
sub %r14, %r15
jmp petla2

roznica1:
sub %r15, %r14
jmp petla2

#sprawdzenie ilosci znakow w liczbie dzielnika
sprawdz:
cmp $0, %rax #sprawdzamy czy wynik dzielenia jest równy 0
je przenies
mov $0, %rdx #wyzerowanie "reszty"
div %r11 #operacja dzielenia akumulatora przez zawartość r11(10)
inc %r9 #zliczanie ilosci znakow w liczbie dzielnika
jmp sprawdz

przenies:
mov %r14, %rax #powrotne przeniesienie wspolnego dzielnika


petla3:
cmp $0, %r9 #porownanie licznika petli z '0'
je wynik1 #jesli rowne to skok do wynik
mov $0, %rdx #wyczyszczenie reszty
div %r10 #dzielenie przez '16'
cmp $9, %rdx #porownanie 9 z reszta
jg litera2 #jesli reszta wieksza niz 9 to skok do litera2
add $48, %rdx #jesli cyfra dodajemy '48'
movb %dl, bufor2(,%r9,1) #przeniesienie do bufora, zmiana kolejnosci znakow
dec %r9 #zmniejszenie licznika petli dzieleń
jmp petla3

#jesli znak to litera
litera2:
add $55, %rdx #dodajemy '55'
movb %dl, bufor2(,%r9,1) #przeniesienie do bufora, zmiana kolejnosci znakow
dec %r9 #zmniejszenie licznika petli dzieleń
jmp petla3

#wyswietlanie wyniku
wynik1:
mov $SYSWRITE, %rax
mov $STDOUT, %rdi
mov $tekst2, %rsi
mov $tekst2len, %rdx
syscall

mov $SYSWRITE, %rax
mov $STDOUT, %rdi
mov $bufor2, %rsi
mov $buflen, %rdx
syscall

koniec:

mov $SYSEXIT, %rax
mov $EXIT_SUCCESS, %rdi
syscall
