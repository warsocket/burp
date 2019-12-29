define compile = 
	nasm -f elf64 $(1).asm
	ld $(1).o -o $(1)
endef

define clean =
	rm $(1).o $(1) ;true
endef


all: forkbomb oomkill entropydrain inode

docker: forkbomb-docker oomkill-docker rev-docker entropydrain-docker

forkbomb-docker: forkbomb
	docker build -t forkbomb -f forkbomb.Dockerfile .

oomkill-docker: oomkill
	docker build -t oomkill -f oomkill.Dockerfile .

rev-docker:
	docker build -t rev -f rev.Dockerfile .

entropydrain-docker: entropydrain
	docker build -t rev -f entropydrain.Dockerfile .

forkbomb:
	$(call compile,forkbomb)

oomkill:
	$(call compile,oomkill) 

entropydrain:
	$(call compile,entropydrain) 

inode:
	$(call compile,inode) 
	
clean:
	$(call clean,forkbomb)
	$(call clean,oomkill)
	$(call clean,entropydrain)
	