# Setup
## SSH keys
To make your keys available in the devcontainer, you'll need the:
1. `ssh-agent` running on the host; and
2. your key(s) added to it.

To make this happen:
1. Auto-start the ssh-agent:
```sh
# Update ~/.bashrc or ~/zshrc
[ -z "$SSH_AUTH_SOCK" ] && eval "$(ssh-agent -s)"
```
2. Add your key:
```sh
# Update ~/.ssh/config
Host *
	UseKeychain yes
	AddKeysToAgent yes
	IdentityFile ~/.ssh/<PRIVATE_KEY>

# Or manually add the key
ssh-add -K ~/.ssh/<PRIVATE_KEY>
```


