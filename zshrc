export DOTDIR=$(dirname ${(%):-%N})

# load sh profile
[ -f "$DOTDIR/profile" ] && source "$DOTDIR/profile"

# load aliases
[ -f "$DOTDIR/aliases" ] && source "$DOTDIR/aliases"
[ -f "$HOME/.aliases" ] && source "$HOME/.aliases"

# load zsh directory
for file in $DOTDIR/zsh/*; do
  [ -f "$file" ] && source "$file"
done

# install direnv hook if available
if type "direnv" > /dev/null; then
  eval "$(direnv hook zsh)"
fi
