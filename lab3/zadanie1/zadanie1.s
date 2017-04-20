.data
SYSEXIT = 60
SYSREAD = 0
SYSWRITE = 1
STDOUT = 1
STDIN = 0
EXIT_SUCCESS = 1

.text


call potega

koniec:
mov $SYSEXIT, %rax
mov $EXIT_SUCCESS, %rdi
syscall
