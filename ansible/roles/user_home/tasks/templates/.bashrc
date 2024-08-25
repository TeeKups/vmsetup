[ -f $HOME/.bash_aliases ] && . $HOME/.bash_aliases

set -o vi
bind -m vi-command 'Control-l: clear-screen'
bind -m vi-insert 'Control-l: clear-screen'

export EDITOR=/opt/nvim/nvim
export VISUAL="$EDITOR"