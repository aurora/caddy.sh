#!/usr/bin/env bash

#
# Script to create installation package.
# Requires mkinst from https://github.com/aurora/mkinst/
#
# copyright (c) 2018-2019 by Harald Lapp <harald@octris.org>
#

rm -f dist/caddysh_installer.bin

mkinst -i <(cat << INSTALLER
if [ \$(id -u) -ne 0 ]; then
    echo "Please run as root."
    exit 1
fi 

set -e

untar_payload "/"

mkdir -p /etc/caddy.sh/hosts
mkdir -p /etc/caddy.sh/templates

for i in php-fpm-global.conf templates/caddy.conf templates/php-fpm-pool.conf templates/caddy-events.sh; do
    cp usr/local/etc/caddy.sh/\$i /etc/caddy.sh/\$i
done
INSTALLER
) dist/caddysh_installer.bin usr
