#!/usr/bin/env bash
tar cJf - etc usr | cat <(tail -n+$(awk '/^__INSTALLER__/ { print NR + 1; exit 0; }' "${0}") "${0}") - > dist/install.sh
chmod a+x dist/install.sh
exit 0

__INSTALLER__
tail -n+$(awk '/^__ARCHIVE__/ { print NR + 1; exit 0; }' "${0}") "${0}" | tar xopPJv -C /

echo "done."
exit 0

__ARCHIVE__
