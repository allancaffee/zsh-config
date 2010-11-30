#!/bin/sh
### From Matt Wozniski's .zshrc

bindkey -e

# Allow comments in an interactive shell.
setopt InteractiveComments 2>/dev/null
# Don't interrupt me to let me know about a finished bg task
setopt NoNotify            2>/dev/null
# Run backgrounded processes at full speed
setopt NoBgNice            2>/dev/null
# Turn off terminal beeping
setopt NoBeep              2>/dev/null
# Automatically list ambiguous completions
setopt AutoList            2>/dev/null
# Don't require an extra tab before listing ambiguous completions
#  setopt NoBashAutoList      2>/dev/null
# Don't require an extra tab when there is an unambiguous pre- or suffix
setopt NoListAmbiguous     2>/dev/null
# Before storing an item to the history, delete any dups
setopt HistIgnoreAllDups   2>/dev/null
setopt HistIgnoreSpace     2>/dev/null
# Append each line to the history immediately after it is entered
unsetopt ShareHistory        2>/dev/null
# cd adds directories to the stack like pushd
setopt AutoPushd           2>/dev/null
# the same folder will never get pushed twice
setopt PushdIgnoreDups     2>/dev/null
# - and + are reversed after cd
setopt PushdMinus          2>/dev/null
# pushd will not print the directory stack after each invocation
setopt PushdSilent         2>/dev/null
# pushd with no parameters acts like 'pushd $HOME'
setopt PushdToHome         2>/dev/null
# Allow extended globbing syntax like **/*
setopt ExtendedGlob        2>/dev/null
# Don't complain about unmatched globbing
unsetopt NoMatch           2>/dev/null
# Allow short forms of function contructs
setopt ShortLoops          2>/dev/null
# Attempt to spell-check command names
#setopt Correct             2>/dev/null
# Don't verify before deleting all files in a directory with rm *
setopt RmStarSilent
# Append new lines to the history file immediately instead of waiting for the
# shell to exit.  That way I can retrieve commands from the history of other
# shells with `fc -RI'.
setopt IncAppendHistory    2>/dev/null

export DIRSTACKSIZE=10                  # Max number of dirs on the dir stack

# Returns whether its argument should be considered "true"
# Succeeds with "1", "y", "yes", "t", and "true", case insensitive
function booleancheck {
[[ -n "$1" && "$1" == (1|[Yy]([Ee][Ss]|)|[Tt]([Rr][Uu][Ee]|)) ]]
}

### Completion
if autoloadable compinit; then
autoload -U compinit
# Set up the required completion functions
compinit -u

# Complete from both sides
setopt CompleteInWord
# Pack the lists with variable width columns
setopt ListPacked

# Order in which completion mechanisms will be tried:
# 1. Try completing the results of an old list
#    ( for use with history completion on ctrl-space )
# 2. Try to complete using context-sensitive completion
# 3. Try interpretting the typed text as a pattern and matching it against the
#    possible completions in context
# 4. Try completing the word just up to the cursor, ignoring anything past it.
# 5. Try combining the effects of completion and correction.
zstyle ':completion:*' completer _oldlist _complete _match \
_expand _prefix #_approximate

# Don't complete backup files as executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'

# Don't complete Automake generated targets in Makefiles
zstyle ':completion:*:complete:make:*:*' ignored-patterns 'am--refresh' '*-am' '*-recursive' 

# Use colors in tab completion listings
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Enter "menu selection" if there are at least 2 choices while completing
zstyle ':completion:*' menu select=2

# Add a space after an expansion, so that 'ls $TERM' expands to 'ls xterm '
zstyle ':completion:*:expand:*' add-space true
fi
### End of Matt's code
