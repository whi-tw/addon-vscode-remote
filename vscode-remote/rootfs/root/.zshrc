# shellcheck disable=SC1090,SC2034,SC2086
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"
DISABLE_AUTO_UPDATE="true"
COMPLETION_WAITING_DOTS="true"

plugins=(
    extract
    git
    nmap
    pip
    python
    rsync
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# shellcheck disable=SC1091
source $ZSH/oh-my-zsh.sh

# Home Assistant CLI
source <(ha completion --zsh)

# Show motd on start
cat /etc/motd
