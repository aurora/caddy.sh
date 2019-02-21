# caddy.sh

## Preface

Script for running caddy for easy serving of php-based projects during development.

## Requirements

* caddy webserver -- https://caddyserver.com/
* php with php-fpm -- https://php.net/
* a bash and some php-based projects

## Installation

Download the latest self-contained installer from https://github.com/aurora/caddy.sh/releases and run it with root privileges. The installer will extract the distribution and create configuration files below `/etc/caddy.sh/` and places the `caddy.sh` executable script at `/usr/local/bin`.

## Usage

`caddy.sh init <name> <path>`

Initialize a project located at `<path>` for usage with `caddy.sh`. The script will create config files for the project from the supplied templates located at `/etc/caddy.sh/templates` in the specified path.  Adjust the config files for your needs.

`caddy.sh deploy <name> <path>`

Install a project into the `/etc/caddy.sh/hosts/<name>`.  Creates symlinks to the configuration files located in the specified path in the directory `/etc/caddy.sh/hosts/<name>`.

`caddy.sh print`

Print the configuration file that will be used when running caddy.sh.

`caddy.sh list`

List the installed projects.

`caddy.sh run`

Runs caddy webserver + php-fpm from configuration files found below `/etc/caddy.sh/hosts/...`.

## Acknowledgements

* resolve_path function -- http://stackoverflow.com/a/1116890/85582
* build.sh installer -- http://www.matteomattei.com/create-self-contained-installer-in-bash-that-extracts-archives-and-perform-actitions/
