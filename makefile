proxmox:
	ansible-playbook -b run.yaml --limit proxmox

sharedom:
	ansible-playbook -b run.yaml --limit sharedom

lounge:
	ansible-playbook -b run.yaml --limit lounge

# Lounge LXC
lounge-create:
	ansible-playbook -b run-lxc.yaml --limit proxmox --tags "lounge,create,start"
lounge-start:
	ansible-playbook -b run-lxc.yaml --limit proxmox --tags "lounge,start"
lounge-stop:
	ansible-playbook -b run-lxc.yaml --limit proxmox --tags "lounge,stop"
lounge-destroy:
	ansible-playbook -b run-lxc.yaml --limit proxmox --tags "lounge,stop,destroy"

# Sharedom LXC
sharedom-create:
	ansible-playbook -b run-lxc.yaml --limit proxmox --tags "sharedom,create,start"
sharedom-start:
	ansible-playbook -b run-lxc.yaml --limit proxmox --tags "sharedom,start"
sharedom-stop:
	ansible-playbook -b run-lxc.yaml --limit proxmox --tags "sharedom,stop"
sharedom-destroy:
	ansible-playbook -b run-lxc.yaml --limit proxmox --tags "sharedom,stop,destroy"

reqs:
	ansible-galaxy install -r requirements.yaml
	ansible-galaxy collection install -r requirements-collections.yaml

forcereqs:
	ansible-galaxy install -r requirements.yaml --force
	ansible-galaxy collection install -r requirements-collections.yaml --force

decrypt:
	ansible-vault decrypt vars/vault.yaml

encrypt:
	ansible-vault encrypt vars/vault.yaml

gitinit:
	@./git-init.sh
	@echo "ansible vault pre-commit hook installed"
	@echo "don't forget to create a .vault-password too"