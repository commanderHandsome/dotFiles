
# Source .bashrc if it exists
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# Start ssh-agent if not running
if [ -z "$SSH_AUTH_SOCK" ]; then
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_ed25519
fi

