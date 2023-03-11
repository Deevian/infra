## PROXMOX
proxmox:
	ansible-playbook -b run.yaml --limit proxmox

## DNSMASQ
dnsmasq:
	ansible-playbook -b run-lxc.yaml --limit proxmox --tags dnsmasq
	sleep 5
	ansible-playbook -b run.yaml --limit dnsmasq
dnsmasq-config:
	ansible-playbook -b run.yaml --limit dnsmasq --tags config

## TAILSCALE
tailscale:
	ansible-playbook -b run-lxc.yaml --limit proxmox --tags tailscale
	sleep 5
	ansible-playbook -b run.yaml --limit tailscale

## CADDY
caddy:
	ansible-playbook -b run-lxc.yaml --limit proxmox --tags caddy
	sleep 5
	ansible-playbook -b run.yaml --limit caddy
caddy-config:
	ansible-playbook -b run.yaml --limit caddy --tags config

## SAMBA
samba:
	ansible-playbook -b run-lxc.yaml --limit proxmox --tags samba
	sleep 5
	ansible-playbook -b run.yaml --limit samba

## PLEX
plex:
	ansible-playbook -b run-lxc.yaml --limit proxmox --tags plex
	sleep 5
	ansible-playbook -b run.yaml --limit plex
plex-compose:
	ansible-playbook -b run.yaml --limit plex --tags compose

## CHECKMK
checkmk:
	ansible-playbook -b run-lxc.yaml --limit proxmox --tags checkmk
	sleep 5
	ansible-playbook -b run.yaml --limit checkmk

## UTILS
checkmk-agents:
	ansible-playbook -b run.yaml --tags checkmk-agent

update-packages:
	ansible-playbook -b run.yaml --tags update-packages

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