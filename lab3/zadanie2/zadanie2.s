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
.global aeuklides
.type aeuklides, @function

#wypisanie na ekranie napisu z poleceniem


aeuklides:
mov $0, %r10
mov $0, %r11
mov $0, %r12
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
mov $0, %r8
#wczytywanie pierwszej liczby z bufora do rejestru (zamiana z ascii na int)
wczytywanie1liczby:
mov $0, %rdx
movb bufor(,%r8,1), %dl #przenoszenie po jednym bajcie kodów ascii do 8-bitowego dl
sub $48, %rdx #odjęcie 48 od ascii i otrzymanie cyfry
add %rdx, %r10 #dodanie cyfry do zawartości r10 
cmp %r9, %r8 #porównanie licznika z warunkiem końcowym pętli
je komunikat #skok, który zostanie wykonany w przypadku równości z linijki wyżej
mov %r10, %rax #przeniesienie cyfry liczby do akumulatora w celu wykonania operacji mnożenia
mul %r15 #operacja mnożenia akumulatora przez zawartość r15(10)
mov %rax, %r10 #przeniesienie przemnożonej liczby z powrotem do r10
inc %r8 #zwiększenie licznika pętli o jeden
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
mov $0, %r8
#wczytywanie drugiej liczby z bufora do rejestru (zamiana z ascii na int)
wczytywanie2liczby:
mov $0, %rdx
movb bufor(,%r8,1), %dl
sub $48, %rdx
add %rdx, %r12
cmp %r9, %r8
je petla
mov %r12, %rax
mul %r15
mov %rax, %r12
inc %r8
jmp wczytywanie2liczby

petla:
cmp %r10, %r12 #porownanie dwoch liczb
je wynik #jesli rowne to skok do wynik
cmp %r10, %r12 #porownanie dwoch liczbo
jg roznica #jesli r15 wieksze to skok do roznica
cmp %r10, %r12 #porownanie dwoch liczb
jl roznica1 #jesli r15 mniejsze to skok do roznica1
jmp petla


wynik:
mov %r10, %rax
mov $0, %r11
jmp zliczanie

roznica:
sub %r10, %r12
jmp petla

roznica1:
sub %r12, %r10
jmp petla

zliczanie:

mov $0, %rdx #wyzerowanie "reszty"
div %r15 #operacja dzielenia akumulatora przez zawartość r15(10)
inc %r11 #zliczanie ilości cyfr w liczbie wyniku
cmp $0, %rax #sprawdzamy czy wynik dzielenia jest równy 0
je przeniesieniewyniku
jmp zliczanie

#przeniesienie wyniku do rax
przeniesieniewyniku:

mov %r10, %rax

#zamiana cyfr wyniku na ascii i przeniesienie do bufora
konwersja:
cmp $0, %rax #sprawdzamy czy wynik jest równy 0
je wyswietlanie
mov $0, %rdx #wyzerowanie "reszty"
div %r15 #operacja dzielenia akumulatora przez zawartość r15(10)
add $48, %rdx #dodanie do reszty z dzielenia liczby 48(stworzenie kodu ascii)
movb %dl, bufor2(,%r11,1) #przenoszenie cyfr wyniku od tyłu (zamiana kolejności)
dec %r11 #zmniejszanie licznika cyfr o jeden

jmp konwersja


wyswietlanie:

mov $SYSWRITE, %rax
mov $STDOUT, %rdi
mov $bufor2, %rsi
mov $buflen, %rdx
syscall

ret																				


