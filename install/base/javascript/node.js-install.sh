##########################################################################
# node.js Install
##########################################################################
$ curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - &&\\nsudo apt-get install -y nodejs


##########################################################################
# nvm Install
##########################################################################
# nvm (https://github.com/nvm-sh/nvm)
$ curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

$ export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# zsh에서 nvm 못찾을 시 .zshrc에 추가
#! $ export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
#! [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
