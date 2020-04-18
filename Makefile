.PHONY: help install dependencies update clean

help:
	cat $(lastword $(MAKEFILE_LIST))

install: \
	dependencies

dependencies:
	type curl

update: \
	lib/redis-bash-lib.sh

lib/redis-bash-lib.sh: lib
	curl https://raw.githubusercontent.com/caquino/redis-bash/master/redis-bash-lib > $@
	chmod u+x $@

lib:
	mkdir -p $@

clean:
