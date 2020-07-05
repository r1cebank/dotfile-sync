# shortcut to this dotfiles path is $ZSH
export ZSH=$HOME/.dotfiles
export KUBECONFIG=$HOME/.kube/geck.yaml
# JAVAHOME
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk
# yubikey-agent
# export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/yubikey-agent/yubikey-agent.sock"

# gpg-agent
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null

# SHELL
SHELL=/usr/bin/zsh

# Stash your environment variables in ~/.localrc. This means they'll stay out
# of your main dotfiles repository (which may be public, like this one), but
# you'll have access to them in your scripts.
if [[ -a ~/.localrc ]]
then
  source ~/.localrc
fi

# Platform detection
# Mainly to differentiate between OS X, Ubuntu and CentOS
PLATFORM=$(uname | tr "[:upper:]" "[:lower:]")
if [ "$PLATFORM" = "linux" ]; then
  if hash yum >/dev/null 2>&1; then
    PLATFORM="centos"
  fi
  if hash apt-get >/dev/null 2>&1; then
    PLATFORM="debian"
  fi
  if hash pacman >/dev/null 2>&1; then
    PLATFORM="arch"
  fi
fi
export PLATFORM

# all of our zsh files
typeset -U config_files
config_files=($ZSH/**/*.zsh)

# load the path files
for file in ${(M)config_files:#*/path.zsh}
do
  source $file
done

# load everything but the path and completion files
for file in ${${${${${config_files:#*/path.zsh}:#*/completion.zsh}:#*/highlighters/*.zsh}:#*/theme/**/*.zsh}:#*/theme/*.zsh}
do
  source $file
done

# load every completion after autocomplete loads
for file in ${(M)config_files:#*/completion.zsh}
do
  source $file
done

unset config_files

source $ZSH/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# initialize autocomplete here, otherwise functions won't be loaded
autoload -U compinit
compinit

fpath=($fpath "$ZSH/zsh/theme")
autoload -U promptinit; promptinit
prompt spaceship

eval $(thefuck --alias shit)
eval "$(direnv hook zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
  source /etc/profile.d/vte.sh
fi
