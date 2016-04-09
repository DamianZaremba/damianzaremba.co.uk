# YUI Compressor
YUI_COMPRESSOR_VERSION := 2.4.8
YUI_COMPRESSOR_URL := http://central.maven.org/maven2/com/yahoo/platform/yui/yuicompressor/$(YUI_COMPRESSOR_VERSION)/yuicompressor-$(YUI_COMPRESSOR_VERSION).jar
YUI_COMPRESSOR_TARGET := _temp/yuicompressor-$(YUI_COMPRESSOR_VERSION).jar

# HTML Compressor
HTML_COMPRESSOR_VERSION := 1.5.2
HTML_COMPRESSOR_URL := http://central.maven.org/maven2/com/googlecode/htmlcompressor/htmlcompressor/$(HTML_COMPRESSOR_VERSION)/htmlcompressor-$(HTML_COMPRESSOR_VERSION).jar
HTML_COMPRESSOR_TARGET := _temp/htmlcompressor-$(HTML_COMPRESSOR_VERSION).jar

# Git branch
GIT_BRANCH := $(git rev-parse --abbrev-ref HEAD)

all: compile

getdeps:
	test -d _temp || mkdir -p _temp
	# HTML Compressor
	test -f '$(HTML_COMPRESSOR_TARGET)' || wget '$(HTML_COMPRESSOR_URL)' -O '$(HTML_COMPRESSOR_TARGET)' || (rm -f '$(HTML_COMPRESSOR_TARGET)')
	# YUI Compressor
	test -f '$(YUI_COMPRESSOR_TARGET)' || wget '$(YUI_COMPRESSOR_URL)' -O '$(YUI_COMPRESSOR_TARGET)' || (rm -f '$(YUI_COMPRESSOR_TARGET)')
	# SSH wrapper
	test -f _temp/ssh || (echo 'exec ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $$*' > _temp/ssh; chmod 755 _temp/ssh)

stage: update compile minify clone stash

install: stage check_git push cacheclear primecache

build: update compile minify

check_git:
	@if [ ! -z "`git status --porcelain`" ]; then \
		echo "[!! Un-comitted git changes !!]"; \
		git status --porcelain; \
		exit 1; \
	fi

compile: getdeps
	LC_ALL=en_GB.UTF-8 LANG=en_GB.UTF-8 jekyll build

server:
	LC_ALL=en_GB.UTF-8 LANG=en_GB.UTF-8 jekyll serve --watch --drafts --incremental --config _config.yml,_config_dev.yml

prod-server:
	LC_ALL=en_GB.UTF-8 LANG=en_GB.UTF-8 jekyll serve --watch --incremental --config _config.yml

clone:
	# Remove it not a git repo
	if [ -d "_live" ] && [ ! -d "_live/.git" ]; then \
		rm -rf _live; \
	fi
	# Update if a git repo
	if [ -d "_live" ]; then \
		cd _live && \
		git reset --hard; \
		git pull origin master; \
	else \
		@if [ ! -z "${GH_TOKEN}" ]; then \
			@git clone "https://${GH_TOKEN}@github.com/DamianZaremba/damianzaremba.github.io.git" _live; \
		else \
			GIT_SSH=_temp/ssh git clone git@github.com:DamianZaremba/damianzaremba.github.io.git _live; \
		fi \
	fi

clean:
	test -d _site && rm -rf _site || true
	test -d _live && rm -rf _live || true
	test -d _temp && rm -rf _temp || true

minify:
	# Js/CSS
	find _site/assests/ -type f \( -iname '*.css' -o -iname '*.js' \) \
	| while read f; do java -jar '_temp/yuicompressor-$(YUI_COMPRESSOR_VERSION).jar' $$f -o $$f --charset utf-8; done

	# HTML
	java -jar '_temp/htmlcompressor-$(HTML_COMPRESSOR_VERSION).jar' --type html --remove-quotes --recursive \
		--compress-js --compress-css --remove-quotes --js-compressor yui -o _site/ _site/

stash:
	$(eval LIVE_SHA1_PRE := $(shell cd _live/ && git rev-parse HEAD))
	rsync -vr --exclude=.git/ --exclude=.bundle/ --exclude=vendor/ --delete _site/ _live/
	cd _live/ && touch .nojekyll

push:
	cd _live/ && \
		if [ "`git ls-files --modified --deleted | grep -v 'sitemap.xml' | wc -l`" != "0" ] && [ "$(GIT_BRANCH)" == "master" ]; \
		then \
			git add --all . && \
			git commit -am "Auto updated site" && \
				@if [ ! -z "${GH_TOKEN}" ]; \
				then \
					@git push "https://${GH_TOKEN}@github.com/DamianZaremba/damianzaremba.github.io.git" master
				else \
					GIT_SSH=../_temp/ssh git push origin master; \
				fi \
		fi

cacheclear:
	# Lazy clear the cloudflare cache
	@if [ "$(GIT_BRANCH)" == "master" ]; then \
		@if [ "`cd _live/ && git diff --name-only $(LIVE_SHA1_PRE)...HEAD | wc -l`" -gt 90 ]; then \
			echo "Large change: purging whole zone"; \
			curl https://www.cloudflare.com/api_json.html \
				-d 'a=fpurge_ts' \
				-d 'tkn='`cat ~/.cloudflare.token` \
				-d 'email=damian@damianzaremba.co.uk' \
				-d 'z=damianzaremba.co.uk' \
				-d 'v=1'; \
		else \
			cd _live/ && \
			git diff --name-only $(LIVE_SHA1_PRE)...HEAD | while read path; \
			do \
				echo "Clearing cache for $$path" && \
				curl https://www.cloudflare.com/api_json.html \
					-d 'a=zone_file_purge' \
					-d 'tkn='`cat ~/.cloudflare.token` \
					-d 'email=damian@damianzaremba.co.uk' \
					-d 'z=damianzaremba.co.uk' \
					-d 'url=http://damianzaremba.co.uk/'$$path; \
				echo; echo; \
			done \
		fi \
	fi

update:
	# Make sure the dir exists
	test -d content/cv/ || mkdir -p content/cv/

	# Download the current README
	wget -O /tmp/github-damianzaremba-cv-readme https://raw.github.com/DamianZaremba/cv/master/README.md

	# Write out the header
	@echo "---" > /tmp/github-damianzaremba-cv-readme.markdown
	@echo "layout: default" >> /tmp/github-damianzaremba-cv-readme.markdown
	@echo "title: CV" >> /tmp/github-damianzaremba-cv-readme.markdown
	@echo "description: Damian Zaremba's CV" >> /tmp/github-damianzaremba-cv-readme.markdown
	@echo "---" >> /tmp/github-damianzaremba-cv-readme.markdown

	# Cat in the main stuff ignoring the header crap
	@tail -n +4 /tmp/github-damianzaremba-cv-readme >> /tmp/github-damianzaremba-cv-readme.markdown
	@rm -f /tmp/github-damianzaremba-cv-readme

	# Write out the footer
	@echo >> /tmp/github-damianzaremba-cv-readme.markdown
	@echo >> /tmp/github-damianzaremba-cv-readme.markdown
	@echo "Other Formats" >> /tmp/github-damianzaremba-cv-readme.markdown
	@echo "-------------" >> /tmp/github-damianzaremba-cv-readme.markdown
	@echo "Available on [GitHub](https://github.com/DamianZaremba/cv)" >> /tmp/github-damianzaremba-cv-readme.markdown

	# Copy over if new
	@if [ "`diff /tmp/github-damianzaremba-cv-readme.markdown content/cv/index.markdown`" != "" ]; \
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
	@if [ -z "`git status --porcelain | grep -v content/cv/index.markdown`" ] && \
		[ ! -z "`git status --porcelain | grep content/cv/index.markdown`" ]; then \
		git commit -m "Updating CV from source" content/cv/index.markdown; \
	else \
		echo "Working directory dirty, not committing CV"; \
	fi

primecache:
	if [ "`cd _live/ && git diff --name-only $(LIVE_SHA1_PRE)...HEAD | wc -l`" -gt 90 ]; then \
		./scripts/prime_cache.py --full; \
	else \
		files=$(git diff --name-only $(LIVE_SHA1_PRE)...HEAD | tr "\n" " "); \
		test -z "$(files)" || ./scripts/prime_cache.py --files $(files); \
	fi

publishpending_script:
	./scripts/publish_pending.py

publishpending: getdeps publishpending_script install
