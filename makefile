proxmox:
	ansible-playbook -b run.yaml --limit proxmox

caddy:
	ansible-playbook -b run-lxc.yaml --limit proxmox --tags caddy
	ansible-playbook -b run.yaml --limit caddy

samba:
	ansible-playbook -b run-lxc.yaml --limit proxmox --tags samba
	ansible-playbook -b run.yaml --limit samba

plex:
	ansible-playbook -b run-lxc.yaml --limit proxmox --tags plex
	ansible-playbook -b run.yaml --limit plex

prometheus:
	ansible-playbook -b run-lxc.yaml --limit proxmox --tags prometheus
	ansible-playbook -b run.yaml --limit prometheus

## Generic LXC commands
lxc-create:
	ansible-playbook -b run-lxc.yaml --limit proxmox --tags "$(host),create" --skip-tags "start,stop,destroy"
lxc-start:
	ansible-playbook -b run-lxc.yaml --limit proxmox --tags "$(host),start" --skip-tags "create,stop,destroy"
lxc-stop:
	ansible-playbook -b run-lxc.yaml --limit proxmox --tags "$(host),stop" --skip-tags "create,start,destroy"
lxc-destroy:
	ansible-playbook -b run-lxc.yaml --limit proxmox --tags "$(host),destroy" --skip-tags "create,start,stop"

## Misc commands
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