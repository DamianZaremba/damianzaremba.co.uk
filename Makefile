SHELL := /bin/bash

all: build

install: build clone push

build:
	jekyll

server:
	jekyll --server

clone:
	# Remove it not a git repo
	test -d "_live" && test -d "_live/.git" || rm -rf _live; exit 0

	# Update if a git repo
	test -d "_live" && (cd _live && git pull); exit 0

	# Clone if it doesn't exist
	test -d "_live" || git clone git@github.com:DamianZaremba/DamianZaremba.github.com.git _live; exit 0

clean:
	test -d _site && rm -rf _site; exit 0

push:
	rsync -vr --exclude=.git --delete _site/ _live/
	cd _live/ && (git add *; git commit -am "Updated site"; git push origin master)
