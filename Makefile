##
## Makefile
##  
## Made by Allan Caffee
## Login   <allanlaptop.localdomain>

CFLAGS = -g
ZSH = zsh

all: bin/svn-verbose-editor
	$(ZSH) ./Build.zsh

bin/svn-verbose-editor: src/svn-verbose-editor.o
	$(CC) $(CFLAGS) -o bin/svn-verbose-editor src/svn-verbose-editor.o

clean:
	-find . -name '*.zwc' -exec rm -f '{}' \;
	-rm -f src/*.o bin/svn-verbose-editor
