# caddy.sh

## Preface

Script for running caddy for easy serving of php based projects during development.

## Installation

Download the latest self-contained installer from https://github.com/aurora/caddy.sh/releases and run it with root privileges.
The installer will extract the distribution and create configuration files below `/etc/caddy.sh/` and places the `caddy.sh` executable script at `/usr/local/bin`. 

## Usage

`caddy.sh init <name> <path>`

Initialize a project located at `<path>` for usage with `caddy.sh`. The script will create config files for the project from
templates located at `/etc/caddy.sh/templates` and create symlinks to them in the directory `/etc/caddy.sh/hosts/<name>`. 
Adjust the config files for your needs.

`caddy.sh run`

Runs caddy webserver + php-fpm from configuration files found below `/etc/caddy.sh/hosts/...`.
