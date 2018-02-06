# caddy.sh

## Preface

Script for running caddy for easy serving of php based projects during development.

## Installation

Place `caddy.sh` somewhere in your path, eg.:

	sudo cp caddy.sh /usr/local/bin

Create configuration directories: # and copy the `etc/php-fpm.conf` configuration:

	mkdir ~/.caddy.sh
	cp etc/php-fpm.conf ~/.caddy.sh

Place the caddy configuration file `etc/caddy.conf` in the project root
directory and adjust it to your needs. Create a symlink to this configuration
file:

	ln -s <path-to-project-root>/caddy.conf ~/.caddy.sh/<project-name>.conf

Run `caddy.sh`:

	sudo caddy.sh

