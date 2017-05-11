[ -z "$DOTDIR" ] && DOTDIR=$(dirname $0)

[ -f "$DOTDIR/vars" ] && source "$DOTDIR/vars"
[ -f "$HOME/.vars" ] && source "$HOME/.vars"
