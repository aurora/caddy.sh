#!/usr/bin/env bash

#
# Script for running caddy for easy serving of php based projects
# during development.
#
# @copyright    copyright (c) 2017-2018 by Harald Lapp
# @author       Harald Lapp <harald.lapp@gmail.com>
#

# Resolve path of a file including symlinks.
#
# @see      http://stackoverflow.com/a/1116890/85582
# @param    string      $1          Path to resolve.
#
function resolve_path() {
    local TARGET_FILE=$1
    local PHYS_DIR

    (
        cd $(dirname $TARGET_FILE)
        TARGET_FILE=$(basename $TARGET_FILE)

        while [ -L "$TARGET_FILE" ]; do
            TARGET_FILE=$(readlink $TARGET_FILE)
            cd $(dirname $TARGET_FILE)
            TARGET_FILE=$(basename $TARGET_FILE)
        done

        echo "$(pwd -P)"
    )
}

[ -x "$(command -v caddy)" ] || {
    echo "caddy webserver not found in path"
    exit 1
}

CONF_DIR=~/.caddy.sh/
FASTCGI_LISTEN=/tmp/caddy-sh-php-fpm-$$.sock
FASTCGI_PID=/tmp/caddy-sh-php-fpm-$$.pid
WWW_USER=$(logname)
WWW_GROUP=$(id -gn $WWW_USER)

if [ ! -d $CONF_DIR ]; then
    echo "configuration files not found in '$CONF_DIR'"
    exit 1
fi

# php
if [ -f $CONF_DIR/../php-fpm.conf ] && [ -x "$(command -v php-fpm)" ]; then
    # php doesn't support reading configuration from STDIN
    php-fpm -v
    PHP_FPM_CONF=/tmp/caddy-sh-php-fpm-$$.conf
    mkfifo -m 0666 $PHP_FPM_CONF
    ((source $CONF_DIR/../php-fpm.conf > $PHP_FPM_CONF && rm $PHP_FPM_CONF) &) # fix syntax highlighting: ))
    php-fpm -y $PHP_FPM_CONF
fi

# virtual hosts
for i in $CONF_DIR/*; do
    source $i
done | caddy "$@" -conf stdin 

# kill php if running
if [ -f $FASTCGI_PID ]; then
    pid=$(cat $FASTCGI_PID)
    kill $pid
fi
