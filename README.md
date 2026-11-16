# infra

Ansible code for my home server: a single Proxmox host running a set of LXC
containers for media, files, DNS/DHCP, reverse proxying and monitoring.

Based on [ironicbadger/infra](https://github.com/IronicBadger/infra).

## Layout

| Host        | IP           | Purpose                                              |
|-------------|--------------|------------------------------------------------------|
| `proxmox`   | 10.10.1.10   | Hypervisor. ZFS, mergerfs + snapraid, sanoid/syncoid |
| `dnsmasq`   | 10.10.1.11   | DNS + DHCP for the LAN                               |
| `tailscale` | 10.10.1.12   | Subnet router and exit node                          |
| `caddy`     | 10.10.1.13   | Reverse proxy (custom build with Cloudflare DNS)     |
| `samba`     | 10.10.1.101  | SMB shares                                           |
| `plex`      | 10.10.1.102  | Plex, Jellyfin and the *arr stack (docker compose)   |
| `checkmk`   | 10.10.1.103  | Monitoring server                                    |
| `nextcloud` | 10.10.1.104  | Nextcloud + MariaDB + Redis (docker compose)         |
| `lounge`    | 10.10.1.105  | Ghost, Drone, Matomo, game servers (docker compose)  |

- `run-lxc.yaml` creates, starts, stops and destroys the LXC containers on Proxmox
  (`roles/deev-lxc`, definitions in `group_vars/proxmox/lxc_settings.yaml`).
- `run.yaml` configures the host and each container.
- `group_vars/all.yaml` holds the host table (`hosts`) used for IPs, MACs and DNS.
- Docker services are defined as `containers:` in each host's `group_vars` file
  and rendered by `ironicbadger.docker_compose_generator`.
- Secrets live in `vars/vault.yaml` (ansible-vault encrypted).

## Getting started

```sh
echo 'your-vault-password' > .vault-password   # gitignored
make reqs        # install galaxy roles and collections
make gitinit     # install pre-commit hook that refuses an unencrypted vault
```

Edit secrets with `ansible-vault edit vars/vault.yaml`. `make decrypt` and
`make encrypt` are also available, but don't commit while decrypted (the hook
will stop you).

## Usage

Run `make` targets, which are thin wrappers around `ansible-playbook`:

```sh
make caddy              # create the LXC, then configure it
make caddy-config       # only re-template the Caddy config
make plex-compose       # only regenerate and apply docker compose
make update-packages    # apt upgrade everywhere
make checkmk-agents     # (re)install checkmk agents and the docker python sdk
make lxc-create host=plex    # also: lxc-start, lxc-stop, lxc-destroy
make lint               # ansible-lint
```

Note: a plain `ansible-playbook run.yaml` also runs the package upgrade task.

## Linting

`make lint` runs `ansible-lint` using `.ansible-lint`. Style-only rules are
skipped there; trim that list to tighten things up over time. The make target points it at the
system and user collection paths (adjust in the makefile if yours differ).

## Notes

`notes/setup.txt` has the manual steps that aren't automated (ZFS pools, disk
formatting, iGPU passthrough, docker zvols).
