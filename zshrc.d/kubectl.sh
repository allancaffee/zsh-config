# Add kubectl completion where available.
if type kubectl > /dev/null; then
  source <(kubectl completion `basename $SHELL`) # setup autocomplete for the current shell.
fi
