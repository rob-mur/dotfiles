if [[ $(pwd) == /mnt/c/Windows/System32  ]]
then
    cd ~
fi
export PATH=/home/linuxbrew/.linuxbrew/bin:/snap/bin:/nix/var/nix/profiles/default/bin/:$HOME/.local/bin/:$PATH

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git aliases alias-finder autojump branch command-not-found copybuffer copyfile copypath dircycle direnv emoji eza fzf gcloud docker docker-compose git-auto-fetch git-prompt helm npm python pip virtualenv ssh sudo tmux
	zsh-autosuggestions zsh-system-clipboard)


source $ZSH/oh-my-zsh.sh

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

eval $(ssh-agent -s) > /dev/null
ssh-add ~/.ssh/id_ed25519_github &> /dev/null

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


export PATH=$PATH:$HOME/.maestro/bin


bindkey -v
bind 'set show-mode-in-prompt on' 2>/dev/null
bind 'set vi-ins-mode-string \1\e[6 q\2' 2>/dev/null
bind 'set vi-cmd-mode-string \1\e[2 q\2' 2>/dev/null
bindkey '^x^e' edit-command-line
export EDITOR=nvim
