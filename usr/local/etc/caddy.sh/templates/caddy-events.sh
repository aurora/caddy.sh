#
# Template for events.
#

cat <<- CONFIG_TPL
#
# Script that can be used to perform additional steps during various events
# when running caddy.sh.
#

function $NAME_onstart() {
}
function $NAME_onstop() {
}

CONFIG_TPL
