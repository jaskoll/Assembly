PROG = zadanie1
LINKER = ld
COMPILER  = as

# Reguły linkowania
$(PROG): $(PROG).o

	$(LINKER) -o $(PROG) $(PROG).o

# Reguły kompilacji
$(PROG).o: $(PROG).s

	$(COMPILER) -o $(PROG).o $(PROG).s -g

# Reguły czyszczenia
clean:

	rm -rf *.o $(PROG)


