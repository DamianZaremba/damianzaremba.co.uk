SHELL := /bin/bash

all: compile

getdeps:
	test -d _temp || mkdir -p _temp; exit 0
	#test -f _temp/htmlcompressor.jar || wget 'https://dl.dropbox.com/u/18392386/htmlcompressor.jar' -O '_temp/htmlcompressor.jar'; exit 0
	test -f _temp/yuicompressor.jar || wget 'https://dl.dropbox.com/u/18392386/yuicompressor.jar' -O '_temp/yuicompressor.jar'; exit 0

stage: update compile minify clone stash

install: stage push cacheclear

build: update compile minify

compile: getdeps
	LC_ALL=en_GB.UTF-8 LANG=en_GB.UTF-8 jekyll build

server:
	LC_ALL=en_GB.UTF-8 LANG=en_GB.UTF-8 jekyll serve --watch --drafts --config _config.yml,_config_dev.yml

prod-server:
	LC_ALL=en_GB.UTF-8 LANG=en_GB.UTF-8 jekyll serve --watch --config _config.yml,_config_dev.yml

clone:
	# Remove it not a git repo
	test -d "_live" && (test -d "_live/.git" || rm -rf _live); exit 0

	# Update if a git repo
	test -d "_live" && (cd _live && (git reset --hard; git pull origin master)); exit 0

	# Clone if it doesn't exist
	test -d "_live" || git clone git@github.com:DamianZaremba/damianzaremba.github.io.git _live; exit 0

clean:
	test -d _site && rm -rf _site; exit 0

minify:
	# Js/CSS
	find _site/assests/ -type f \( -iname '*.css' -o -iname '*.js' \) \
	| while read f; do java -jar _temp/yuicompressor.jar $$f -o $$f --charset utf-8; done

	# HTML
	#find _site/ -type f -iname '*.html' | while read f; do java -jar '_temp/htmlcompressor.jar' \
	#--type html --compress-js --compress-css --remove-quotes --js-compressor yui \
	#-o $$f $$f; done

	# Images
	#test -x /usr/bin/convert && find _site/assests/ -type f \
	#	\( -name 'date.png' -o -name 'comments.png' -o -name 'categories.png' \) \
	#	| while read f; do /usr/bin/convert $$f -quality 70% $$f; done; exit 0

stash:
	rsync -vr --exclude=.git --delete _site/ _live/
	cd _live/ && touch .nojekyll

push:
	cd _live/ && \
		git ls-files --deleted | while read file; do git rm -f "${file}"; done && \
		git add . && \
		(git commit -am "Auto updated site" && git push origin master; exit 0)

cacheclear:
	# Lazy clear the cloudflare cache
	cd _live/ && \
	git log --name-only --since=1.minutes --pretty=oneline -1 | tail -n+2 | while read path; \
	do \
		echo "Clearing cache for $$path" && \
		curl https://www.cloudflare.com/api_json.html \
			-d 'a=zone_file_purge' \
			-d 'tkn='`cat ~/.cloudflare.token` \
			-d 'email=damian@damianzaremba.co.uk' \
			-d 'z=damianzaremba.co.uk' \
			-d 'url=http://damianzaremba.co.uk/'$$path; \
		echo; echo; \
	done

update:
	# Make sure the dir exists
	test -d content/cv/ || mkdir -p content/cv/; exit 0

	# Download the current README
	wget -O /tmp/github-damianzaremba-cv-readme https://raw.github.com/DamianZaremba/cv/master/README.md

	# Write out the header
	echo "---" > /tmp/github-damianzaremba-cv-readme.markdown
	echo "layout: default" >> /tmp/github-damianzaremba-cv-readme.markdown
	echo "title: CV" >> /tmp/github-damianzaremba-cv-readme.markdown
	echo "description: Damian Zaremba's CV" >> /tmp/github-damianzaremba-cv-readme.markdown
	echo "---" >> /tmp/github-damianzaremba-cv-readme.markdown

	# Cat in the main stuff ignoring the header crap
	tail -n +4 /tmp/github-damianzaremba-cv-readme >> /tmp/github-damianzaremba-cv-readme.markdown
	rm -f /tmp/github-damianzaremba-cv-readme

	# Write out the footer
	echo >> /tmp/github-damianzaremba-cv-readme.markdown
	echo >> /tmp/github-damianzaremba-cv-readme.markdown
	echo "Other Formats" >> /tmp/github-damianzaremba-cv-readme.markdown
	echo "-------------" >> /tmp/github-damianzaremba-cv-readme.markdown
	echo "Available on [GitHub](https://github.com/DamianZaremba/cv)" >> /tmp/github-damianzaremba-cv-readme.markdown

	if [ "`diff /tmp/github-damianzaremba-cv-readme.markdown content/cv/index.markdown`" != "" ]; \
	then \
		echo "Updating CV"; \
		mv /tmp/github-damianzaremba-cv-readme.markdown content/cv/index.markdown; \
	else \
		echo "CV up to date"; \
		rm -f /tmp/github-damianzaremba-cv-readme.markdown; \
	fi

publishpending_script:
	./scripts/publish_pending.py
publishpending: publishpending_script install
