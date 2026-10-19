# Shell behavior shared by every platform.
export SSH_CONNECTION="${SSH_CONNECTION-}"
export SSH_CLIENT="${SSH_CLIENT-}"
export SSH_TTY="${SSH_TTY-}"

setopt AUTO_PUSHD
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt INTERACTIVE_COMMENTS
setopt NO_BEEP
setopt PRINT_EIGHT_BIT
setopt PUSHD_IGNORE_DUPS
setopt RM_STAR_SILENT

HISTSIZE=10000
SAVEHIST=10000
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY

alias -g G='| rg'
alias -g L='| less -R'
alias ..='cd ..'
alias ~='cd ~'
alias c='clear'
alias grep='rg'
if (( $+commands[eza] )); then
  alias ls='eza --classify --git-repos --icons --short-nix --no-quotes --color --all --git-ignore'
  alias ll='eza --classify --git-repos --icons --short-nix --no-quotes --color --long'
  alias la='eza --classify --git-repos --icons --short-nix --no-quotes --color --long --all'
else
  alias ll='ls -lh'
  alias la='ls -lah'
fi
alias nd='mise exec -- $SHELL'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias mkdir='mkdir -p'
alias less='less -R'
alias history='history -t "%F %T"'
alias untar='tar -zxvf'
if (( $+commands[docker] )); then
  alias d='docker'
elif (( $+commands[podman] )); then
  alias d='podman'
fi
alias code='zed'
alias orb='TERM=xterm-256color orb'
alias df='df -h'
(( ! $+commands[dust] )) || alias du='dust -h'
alias datestamp='date +%Y%m%d%H%M%S'
alias now='date +%Y/%m/%d\ %H:%M\;%S'
alias iso='date +%Y-%m-%dT%H:%M:%S%z'
alias ipinfo='curl ipinfo.io'
alias weather='curl wttr.in'
if (( $+commands[ghq] && $+commands[fzf] )); then
  alias prj='cd $(ghq list --full-path | fzf)'
fi
alias agec='age -R ~/.config/age/recipient.txt'
alias aged='age --decrypt -i ~/.config/age/identity.age'

alias -s {png,jpg,PNG,JPG,jpeg,JPEG}='gat'
alias -s {ts,js,tsx,jsx,html,md}='bun run'
alias -s py='python3'
alias -s python='python3'
alias -s sh='bash'
alias -s zsh='zsh'
alias -s nu='nu'
alias -s nim='nim'
alias -s swift='swift'
alias -s cr='crystal'
