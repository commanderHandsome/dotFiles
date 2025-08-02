


alias vim='nvim'

# Initialize zoxide
eval "$(zoxide init bash)"  # or zsh

# Optional: fzf integration with zoxide
zoxide-fzf() {
  local dir
  dir=$(zoxide query -l | fzf) && cd "$dir"
}

bind -x '"\C-g": zoxide-fzf'  # for bash, Ctrl-G

