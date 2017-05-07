export DOTDIR=$(dirname ${(%):-%N})

# load variables
[ -f "$DOTDIR/profile" ] && source "$DOTDIR/profile"

# load aliases
[ -f "$DOTDIR/aliases" ] && source "$DOTDIR/aliases"

# load zsh directory
for file in $DOTDIR/zsh/*; do
  [ -f "$file" ] && source "$file"
done
