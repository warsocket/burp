define compile = 
	nasm -f elf64 $(1).asm
	ld $(1).o -o $(1)
endef

define clean =
	rm $(1).o $(1) ;true
endef


all: forkbomb oomkill 

docker: forkbomb-docker oomkill-docker rev-docker

forkbomb-docker: forkbomb
	docker build -t forkbomb -f forkbomb.Dockerfile .

oomkill-docker: oomkill
	docker build -t oomkill -f oomkill.Dockerfile .

rev-docker: oomkill
	docker build -t rev -f rev.Dockerfile .

forkbomb:
	$(call compile,forkbomb)

oomkill:
	$(call compile,oomkill) 

clean:
	$(call clean,forkbomb)
	$(call clean,oomkill)