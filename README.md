# caddy.sh

## Preface

...

## Installation

Place `caddy.sh` somewhere in your path, eg.:

	sudo cp caddy.sh /usr/local/bin

Create configuration directory and copy the `etc/php-fpm.conf` configuration:

	mkdir -p ~/.octris/caddy
	cp etc/php-fpm.conf ~/.octris/

Place the caddy configuration file `etc/caddy.conf` in the project root
directory and adjust it to your needs. Create a symlink to this configuration
file:

	ln -s <path-to-project-root>/caddy.conf ~/.octris/caddy/<project-name>.conf

Run `caddy.sh`:

	sudo caddy.sh

