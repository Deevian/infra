#!/bin/bash
# sets up a pre-commit hook to ensure that vault.yaml is encrypted
#
# credit goes to nick busey from homelabos for this neat little trick
# https://gitlab.com/NickBusey/HomelabOS/-/issues/355

set -e

if [ ! -d .git/ ]; then
    echo "not at the root of a git repository" >&2
    exit 1
fi

cat > .git/hooks/pre-commit <<'EOT'
#!/bin/bash
if git show :vars/vault.yaml | grep -q '^\$ANSIBLE_VAULT;'; then
    echo -e "\033[38;5;108mVault Encrypted. Safe to commit.\033[0m"
else
    echo -e "\033[38;5;208mVault not encrypted! Run 'make encrypt' and try again.\033[0m"
    exit 1
fi
EOT

chmod +x .git/hooks/pre-commit
