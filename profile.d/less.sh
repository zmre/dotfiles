# less initialization script (sh)
export LESS="-FXRadeqs -P--Less--?e?x(Next file\: %x):(END).:?pB%pB\%."
if [ -x /usr/bin/lesspipe.sh ] ; then
  export LESSOPEN="|/usr/bin/lesspipe.sh %s"
fi
