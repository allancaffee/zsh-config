GCLOUD_HOME="$HOME/bin/google-cloud-sdk"
export PATH="$PATH:$GCLOUD_HOME/bin"

if test -x "$GCLOUD_HOME";  then
  source $GCLOUD_HOME/*.zsh.inc
fi

if [ $commands[kubectl] ]; then
  source <(kubectl completion zsh)
fi
