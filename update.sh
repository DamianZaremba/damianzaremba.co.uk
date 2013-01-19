#!/bin/bash
# This is suppose to run as a cronjob and enforce locking
test -f ~/.running && exit 0
cd ~/damianzaremba.co.uk
git checkout -- _config.yml

PRE_HASH=$(git rev-parse HEAD)
git pull origin master
POST_HASH=$(git rev-parse HEAD)

if [ "$PRE_HASH" != "$POST_HASH" ];
then
	sed -i 's/lsi:\s*false/lsi: true/' _config.yml
	make install
fi
rm -f ~/.running