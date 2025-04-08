

# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac


# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -la'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

eval "$(starship init bash)"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
unset SSH_AGENT_PID

GPG_TTY=$(tty)
export GPG_TTY
gpgconf --launch gpg-agent
# Show git branch name
force_color_prompt=yes
color_prompt=yes
#Show the git branch if it's present.
parse_git_branch() {
 git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
if [ "$color_prompt" = yes ]; then
 PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;31m\]$(parse_git_branch)\[\033[00m\]\$ '
else
 PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w$(parse_git_branch)\$ '
fi
unset color_prompt force_color_prompt

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
. "$HOME/.cargo/env"
cdnvm() {
    command cd "$@" || return $?
    nvm_path=$(nvm_find_up .nvmrc | tr -d '\n')

    # If there are no .nvmrc file, use the default nvm version
    if [[ ! $nvm_path = *[^[:space:]]* ]]; then

        declare default_version;
        default_version=$(nvm version default);

        # If there is no default version, set it to `node`
        # This will use the latest version on your machine
        if [[ $default_version == "N/A" ]]; then
            nvm alias default node;
            default_version=$(nvm version default);
        fi

        # If the current version is not the default version, set it to use the default version
        if [[ $(nvm current) != "$default_version" ]]; then
            nvm use default;
        fi

    elif [[ -s $nvm_path/.nvmrc && -r $nvm_path/.nvmrc ]]; then
        declare nvm_version
        nvm_version=$(<"$nvm_path"/.nvmrc)

        declare locally_resolved_nvm_version
        # `nvm ls` will check all locally-available versions
        # If there are multiple matching versions, take the latest one
        # Remove the `->` and `*` characters and spaces
        # `locally_resolved_nvm_version` will be `N/A` if no local versions are found
        locally_resolved_nvm_version=$(nvm ls --no-colors "$nvm_version" | tail -1 | tr -d '\->*' | tr -d '[:space:]')

        # If it is not already installed, install it
        # `nvm install` will implicitly use the newly-installed version
        if [[ "$locally_resolved_nvm_version" == "N/A" ]]; then
            nvm install "$nvm_version";
        elif [[ $(nvm current) != "$locally_resolved_nvm_version" ]]; then
            nvm use "$nvm_version";
        fi
    fi
}
# look for a package.json file, and if there is one, open the scripts object in interactive fzf picker
fns (){
    local script
    if test -f package.json; then
        script=$(node -pe "Object.keys(require(\"./package.json\").scripts).join(\"\\n\")" | sort | fzf)
        if test -n "$script"; then
        npm run "$script"
    fi
else
    echo "Error: No package.json found"
    fi
}
# fuzzy find directories
fd() {
  local dir
  dir=$(find ${1:-.} -maxdepth 3 -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}
# search history with crazy fzf magic
bind '"\C-r": "\C-x1\e^\er"'
bind -x '"\C-x1": __fzf_history';

__fzf_history ()
{
    local history_list
    history_list=$(history | fzf --tac --tiebreak=index | sed 's/ *[0-9]* *//')
    if [[ -n $history_list ]];
    then
        READLINE_LINE=$history_list
        READLINE_POINT=${#READLINE_LINE}
    fi
}

__ehc()
{
if
        [[ -n $1 ]]
then
        bind '"\er": redraw-current-line'
        bind '"\e^": magic-space'
        READLINE_LINE=${READLINE_LINE:+${READLINE_LINE:0:READLINE_POINT}}${1}${READLINE_LINE:+${READLINE_LINE:READLINE_POINT}}
        READLINE_POINT=$(( READLINE_POINT + ${#1} ))
else
        bind '"\er":'
        bind '"\e^":'
fi
}
sesh_list_sessions() {
  {
    exec </dev/tty
    exec <&1
    local session
    session=$(sesh list | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  ')
    if [[ -z "$session" ]]; then
      return
    fi
    sesh connect "$session"
  }

}

tmux_list_sessions() {
  {
    exec </dev/tty
    exec <&1
    local session
    session=$(tmux ls | fzf --height 40% --reverse --border-label ' open tmux sessions ' --border --prompt '⚡  ')
    if [[ -z "$session" ]]; then
      return
    fi
    sesh connect "$session"
  }

}

tmux_kill_multiple_sessions() {
  local sessions=$(tmux ls -F '#S' | fzf -m)

  if [[ -n "$sessions" ]]; then
    echo "Killing sessions: $sessions"
    for session in $sessions; do
      tmux kill-session -t "$session"
    done
  else
    echo "No sessions selected."
  fi
}

export FZF_DEFAULT_COMMAND="rg --files --no-hidden --glob '!node_modules/**'"
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--multi"
alias cd='cdnvm'
alias tmux='tmux -u'
alias fzf='fzf --prompt "Files:=>" --header "Fuzzy Find" --cycle --preview="bat -n --color=always {}"'
alias ff='nvim $(fzf)'
alias fh=__fzf_history
alias run=fns
alias fd=fd
alias sls=sesh_list_sessions
alias tls=tmux_list_sessions
alias tks=tmux_kill_multiple_sessions
# bind -x "\C-f": "./tmux-sessionizer.sh\n"
bind -x '"\C-f":"tmux-sessionizer.sh"'
REACT_APP_API_HOST=https://localhost:8000/api
 # Exports
export PATH=$PATH:/usr/local/nvim/bin
export EDITOR=nvim
export VISUAL=nvim
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(zoxide init --cmd z bash)"
export PATH="$PATH:$HOME/.local/bin"
export PATH=$HOME/cmus/bin:$PATH
export PATH=$HOME/sesh/bin:$PATH
export PATH=$HOME/.local/bin/tmux-sessionizer.sh:$PATH
export PATH="$PATH:$HOME/.local/bin"
export STOW_FOLDERS="bin,nvim,tmux,bash,ghostty,sesh,starship"
