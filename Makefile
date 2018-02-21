define compile = 
	nasm -f elf64 $(1).asm
	ld $(1).o -o $(1)
endef

define clean =
	rm $(1).o $(1)
endef


forkbomb:
	$(call compile,forkbomb)

all: forkbomb

clean:
	$(call clean,forkbomb)