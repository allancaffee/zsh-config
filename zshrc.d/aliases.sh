#!/bin/sh

# Try setting an alias in a subshell first to ensure that this shell supports
# aliases.
if (alias foo=bar) 2>/dev/null; then

# If I havn't already installed a symlink then create an alias.  The
# disadvantage of an alias is that running `screen vless' won't find
# the command.
if ! which vless >/dev/null 2>/dev/null; then
  if test -x "$VLESS"; then
	  alias vless=$VLESS
  fi
fi

# Try to get Subversion to use our wrapper.  Unfortunatly we can't use
# the `--editor-cmd' option because the Subversion Zsh completion
# functions expect the first argument after `svn' to be the action.
if test -x "$ZSH_CUSTOM_CONFIG_DIR/bin/svn-verbose-editor"; then
	alias svn="VISUAL=$ZSH_CUSTOM_CONFIG_DIR/bin/svn-verbose-editor svn"
fi


alias reinit='source /etc/profile'
alias grep='grep --color=auto'

# Python development
alias flake8='flake8 --ignore E111,E501,E121'

alias pq='plaiter --quit'
alias pn='plait --next'
alias vd='aumix -v-10'
alias vu='aumix -v+10'
alias pt='ping tux.cs.drexel.edu'
alias synctux='su ac422 -c /home/ac422/mirror-svn'
alias inet='sudo invoke-rc.d networking'
alias pidgin='pidgin >/dev/null 2>/dev/null &'
# Request fetchmail to poll servers
alias fetchmail='sudo /usr/sbin/invoke-rc.d fetchmail awaken'
if which gls >/dev/null 2>/dev/null; then
	alias ls='gls --color=auto'
elif ls --help >/dev/null 2>&1; then
	alias ls='ls --color=auto'
fi
alias reinit='source ~/.zshrc'
alias pdflatex='pdflatex -interaction=nonstopmode -file-line-error'
alias latex='latex -interaction=nonstopmode -file-line-error'

# KDE 4 apps print tons of debug info
alias okular='okular &>/dev/null'

alias fx='firefox'
alias kq='konqueror'

# Aliases for version functions.
alias git-reapply-patch='git_reapply_patch'
alias git-reapply-and-commit='git_reapply_and_commit'

# Debian stuff
alias apt-get='sudo apt-get --assume-yes --fix-broken --quiet'
alias deb-update='deb_update'

# Replicate Linux stuff on Mac.
if test -x /Applications/MacVim.app/Contents/MacOS/Vim; then
	gvim () {
		/Applications/MacVim.app/Contents/MacOS/Vim -g $*
	}
fi

# Replicate Mac stuff on Linux.
if which xclip >/dev/null 2>&1; then
	alias pbcopy='xclip -selection clipboard'
	alias pbpaste='xclip -selection clipboard -o'
fi


fi # Aliases are supported
