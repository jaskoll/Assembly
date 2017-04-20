.data
SYSEXIT = 60
SYSREAD = 0
SYSWRITE = 1
STDOUT = 1
STDIN = 0
EXIT_SUCCESS = 1
buflen = 512

tekst: .ascii "Podaj liczbe\n"
tekstlen = . -tekst
.bss
.comm bufor, buflen
.comm bufor2, buflen

.text
.globl _start

#wypisanie na ekranie napisu z poleceniem
_start:

mov $SYSWRITE, %rax
mov $STDOUT, %rdi
mov $tekst, %rsi
mov $tekstlen, %rdx
syscall

#wczytanie do bufora, ilosc wrowadzonych znakow przechowywane w rax
mov $SYSREAD, %rax
mov $STDIN, %rdi
mov $bufor, %rsi
mov $buflen, %rdx
syscall

sub $2, %rax #warunek końcowy o jeden krótszy niż ilość cyfr (minus dwa, bo dla liczby jednocyfrowej pętla kończy się po odjęciu 48) 
mov %rax, %r9 #przeniesienie warunku końcowego pętli do r9
mov $10, %r15 #przeniesienie mnożnika (10) do r15

#wczytywanie pierwszej liczby z bufora do rejestru (zamiana z ascii na int)
wczytywanie1liczby:
mov $0, %rdx
movb bufor(,%rdi,1), %dl #przenoszenie po jednym bajcie kodów ascii do 8-bitowego dl
sub $48, %rdx #odjęcie 48 od ascii i otrzymanie cyfry
add %rdx, %r10 #dodanie cyfry do zawartości r10 
cmp %r9, %rdi #porównanie licznika z warunkiem końcowym pętli
je komunikat #skok, który zostanie wykonany w przypadku równości z linijki wyżej
mov %r10, %rax #przeniesienie cyfry liczby do akumulatora w celu wykonania operacji mnożenia
mul %r15 #operacja mnożenia akumulatora przez zawartość r15(10)
mov %rax, %r10 #przeniesienie przemnożonej liczby z powrotem do r10
inc %rdi #zwiększenie licznika pętli o jeden
jmp wczytywanie1liczby #skok do etykiety wczytywanie1liczby

komunikat:
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

sub $2, %rax
mov %rax, %r9

#wczytywanie drugiej liczby z bufora do rejestru (zamiana z ascii na int)
wczytywanie2liczby:
mov $0, %rdx
movb bufor(,%rdi,1), %dl
sub $48, %rdx
add %rdx, %r12
cmp %r9, %rdi
je dodaj
mov %r12, %rax
mul %r15
mov %rax, %r12
inc %rdi
jmp wczytywanie2liczby

#dodanie dwóch liczb
dodaj:

add %r12, %r10 #dodanie dwóch liczb i zapisanie wyniku w r10
mov %r10, %rax
mov $0, %rsi #czyszczenie rejestru rsi
mov $0, %r13 #czyszczenie rejestru r13

#zliczanie ilosci cyfr wyniku (potrzebne do odwrócenia liczby wyniku)
zliczanie:

mov $0, %rdx #wyzerowanie "reszty"
div %r15 #operacja dzielenia akumulatora przez zawartość r15(10)
add $48, %rdx #dodanie do reszty z dzielenia liczby 48(stworzenie kodu ascii)
inc %rsi #zliczanie ilości cyfr w liczbie wyniku
cmp $0, %rax #sprawdzamy czy wynik dzielenia jest równy 0
je przeniesieniewyniku
jmp zliczanie

#przeniesienie wyniku do rax
przeniesieniewyniku:

mov %r10, %rax

#zamiana cyfr wyniku na ascii i przeniesienie do bufora
konwersja:

mov $0, %rdx #wyzerowanie "reszty"
div %r15 #operacja dzielenia akumulatora przez zawartość r15(10)
add $48, %rdx #dodanie do reszty z dzielenia liczby 48(stworzenie kodu ascii)
movb %dl, bufor2(,%rsi,1) #przenoszenie cyfr wyniku od tyłu (zamiana kolejności)
dec %rsi #zmniejszanie licznika cyfr o jeden
cmp $0, %rax #sprawdzamy czy wynik jest równy 0
je wyswietlanie
jmp konwersja


wyswietlanie:

mov $SYSWRITE, %rax
mov $STDOUT, %rdi
mov $bufor2, %rsi
mov $buflen, %rdx
syscall


koniec:

mov $SYSEXIT, %rax
mov $EXIT_SUCCESS, %rdi
syscall
