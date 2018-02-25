define compile = 
	nasm -f elf64 $(1).asm
	ld $(1).o -o $(1)
endef

define clean =
	rm $(1).o $(1) ;true
endef


all: forkbomb oomkill

forkbomb:
	$(call compile,forkbomb)

oomkill:
	$(call compile,oomkill) 

clean:
	$(call clean,forkbomb)
	$(call clean,oomkill)