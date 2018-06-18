#!/usr/bin/env bash

#
# Script for running caddy for easy serving of php based projects
# during development.
#
# @copyright    copyright (c) 2017-2018 by Harald Lapp
# @author       Harald Lapp <harald.lapp@gmail.com>
# @license      MIT
#

CONF_DIR=/etc/caddy.sh/

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

function usage() {
    echo "usage: caddy.sh run [<arguments-for-caddy>]"
    echo "usage: caddy.sh init <name> <path>"
    echo "example: caddy.sh init example ."
    exit 1
}

[ -x "$(command -v caddy)" ] || {
    echo "caddy webserver not found in path"
    exit 1
}

if [ "$1" = "" ]; then
    usage
fi

if [ ! -d "$CONF_DIR" ] || [ ! -d "$CONF_DIR/templates" ]; then
    echo "please run the caddy.sh installer first"
    exit 1
fi

if [ "$EUID" -ne 0 ]; then
    echo "please run as root"
    exit 1
fi

case $1 in
    init)
        # initialize project and copy templates
        if [ "$3" = "" ]; then
            usage
        fi

        if [ ! -d "$3" ]; then
            echo "$3 is not a directory"
            exit 1
        fi

        NAME="$2"

        if [ ! -d "$CONF_DIR/hosts/$NAME" ]; then
            mkdir "$CONF_DIR/hosts/$NAME"
        fi

        dst_path=$(resolve_path "$3")
        tpl_path="$CONF_DIR/templates/"

        for i in $tpl_path/*; do
            source $i > "$dst_path/$(basename $i)"
            ln -snf "$dst_path/$(basename $i)" "$CONF_DIR/hosts/$NAME/"
        done

        exit 0
        ;;
    run)
        shift

        FASTCGI_PID=/tmp/caddy-sh-php-fpm-$$.pid
        WWW_USER=$(logname)
        WWW_GROUP=$(id -gn $WWW_USER)

        # php
        if [ -x "$(command -v php-fpm)" ] && [ $(find "$CONF_DIR/hosts/" -name "php-fpm-pool.conf" | wc -l ) -gt 0 ]; then
            # php doesn't support reading configuration from STDIN
            php-fpm -v
            PHP_FPM_CONF=/tmp/caddy-sh-php-fpm-$$.conf
            mkfifo -m 0666 $PHP_FPM_CONF
            ((
                for i in "$CONF_DIR/php-fpm-global.conf" $(find "$CONF_DIR/hosts/" -name "php-fpm-pool.conf"); do
                    FASTCGI_LISTEN=/caddy-sh-php-fpm-$(basename $(dirname "$i")).sock
                    source "$i"
                done > $PHP_FPM_CONF && rm $PHP_FPM_CONF
            ) &) # fix syntax highlighting: ))
            php-fpm -y $PHP_FPM_CONF
        fi

        # virtual hosts
        for i in $(find "$CONF_DIR/hosts/" -name "caddy.conf"); do
            FASTCGI_LISTEN=/caddy-sh-php-fpm-$(basename $(dirname "$i")).sock
            source "$i"
        done | caddy "$@" -conf stdin

        # kill php if running
        if [ -f $FASTCGI_PID ]; then
            pid=$(cat $FASTCGI_PID)
            kill $pid
        fi
        ;;
    *)
        usage
        ;;
esac
