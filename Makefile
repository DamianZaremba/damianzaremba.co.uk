# YUI Compressor
YUI_COMPRESSOR_VERSION := 2.4.8
YUI_COMPRESSOR_URL := https://repo1.maven.org/maven2/com/yahoo/platform/yui/yuicompressor/$(YUI_COMPRESSOR_VERSION)/yuicompressor-$(YUI_COMPRESSOR_VERSION).jar
YUI_COMPRESSOR_TARGET := _temp/yuicompressor-$(YUI_COMPRESSOR_VERSION).jar

all: compile

getdeps:
	test -d _temp || mkdir -p _temp
	# YUI Compressor
	test -f '$(YUI_COMPRESSOR_TARGET)' || wget '$(YUI_COMPRESSOR_URL)' -O '$(YUI_COMPRESSOR_TARGET)' || (rm -f '$(YUI_COMPRESSOR_TARGET)')

stage: update compile minify clone stash

deploy: check_git push

install: stage deploy

build: update compile minify

check_git:
	if [ ! -z "`git status --porcelain`" ]; then \
		echo "[!! Un-comitted git changes !!]"; \
		git status --porcelain; \
		exit 1; \
	fi

compile: getdeps
	bundle exec jekyll build

server: clean
	bundle exec jekyll serve --watch --incremental --config _config.yml,_config_dev.yml

prod-server: clean
	bundle exec jekyll serve --watch --incremental --config _config.yml

clone:
	# Remove it not a git repo
	test -d "_live" && (test -d "_live/.git" || rm -rf _live) || true

	# Clone if it doesn't exist, update if it does
	if [ ! -d "_live" ]; then \
		git clone git@github.com:DamianZaremba/damianzaremba.github.io _live; \
	else \
		cd _live && \
			git reset --hard && \
			git pull origin master; \
	fi

clean:
	test -d _site && rm -rf _site || true
	test -d _live && rm -rf _live || true
	test -d _temp && rm -rf _temp || true

minify:
	# Js/CSS
	find _site/assests/ -type f \( -iname '*.css' -o -iname '*.js' \) | \
	while read f; \
	do \
		java -jar '_temp/yuicompressor-$(YUI_COMPRESSOR_VERSION).jar' $$f -o $$f --charset utf-8; \
	done

stash:
	$(eval LIVE_SHA1_PRE := $(shell cd _live/ && git rev-parse HEAD))
	rsync -vr --exclude=.git/ --exclude=.nojekyll --delete _site/ _live/
	cd _live/ && touch .nojekyll

push:
	cd _live/ && \
		if [ "`git ls-files --modified --deleted | grep -v 'sitemap.xml' | wc -l`" != "0" ]; then \
			git add --all . && \
			git commit -am "Auto updated site"; \
      git push origin master; \
		fi

update:
	# Setup git
	git config --global user.email "damian@damianzaremba.co.uk"
	git config --global user.name "Damian Zaremba"

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

	# Copy over if new
	if [ "`diff /tmp/github-damianzaremba-cv-readme.markdown content/cv/index.markdown`" != "" ]; \
	then \
		echo "Updating CV"; \
		mv /tmp/github-damianzaremba-cv-readme.markdown content/cv/index.markdown; \
	else \
		echo "CV up to date"; \
		rm -f /tmp/github-damianzaremba-cv-readme.markdown; \
	fi

	# Cleanup
	rm -f /tmp/github-damianzaremba-cv-readme.markdown.new.diff
	rm -f /tmp/github-damianzaremba-cv-readme.markdown.current.diff

	# Commit the update if the working dir is clean
	if [ -z "`git status --porcelain | grep -v content/cv/index.markdown`" ] && \
		[ ! -z "`git status --porcelain | grep content/cv/index.markdown`" ]; then \
		git commit -m "Updating CV from source" content/cv/index.markdown; \
	else \
		echo "Working directory dirty, not committing CV"; \
	fi

new:
	$(eval POST_TITLE := $(shell read -p 'Title? ' title; echo $$title))
	$(eval POST_SLUG := $(shell echo "$(POST_TITLE)" | tr ' ' '-' | tr '[:upper:]' '[:lower:]'))
	$(eval POST_PATH := "content/_drafts/singles/$(POST_SLUG).markdown")
	if [ ! -f $(POST_PATH) ]; then \
		echo '---' > $(POST_PATH); \
		echo 'comments: true' >> $(POST_PATH); \
		echo 'layout: post' >> $(POST_PATH); \
		echo 'title: $(POST_TITLE)' >> $(POST_PATH); \
		echo 'tags:' >> $(POST_PATH); \
		echo '- General' >> $(POST_PATH); \
		echo '---' >> $(POST_PATH); \
		echo >> $(POST_PATH); \
		atom $(POST_PATH); \
	fi
