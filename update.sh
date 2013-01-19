#!/bin/bash
# This is suppose to run as a cronjob and enforce locking
test -f ~/.running && exit 0
cd ~/damianzaremba.co.uk
PRE_HASH=$(git rev-parse HEAD)
git pull origin master
POST_HASH=$(git rev-parse HEAD)

if [ "$PRE_HASH" != "$POST_HASH" ];
then
	make install
fi
rm -f ~/.running