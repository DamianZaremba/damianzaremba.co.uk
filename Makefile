all: compile

getdeps:
	test -d _temp || mkdir -p _temp

stage: update compile clone stash

deploy: check_git push

install: stage deploy

build: update compile

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
			git pull origin main; \
	fi

clean:
	test -d _site && rm -rf _site || true
	test -d _live && rm -rf _live || true
	test -d _temp && rm -rf _temp || true

stash:
	$(eval LIVE_SHA1_PRE := $(shell cd _live/ && git rev-parse HEAD))
	rsync -vr --exclude=.git/ --exclude=.nojekyll --delete _site/ _live/
	cd _live/ && touch .nojekyll

push:
	cd _live/ && \
		if [ "`git ls-files --modified --deleted | grep -v 'sitemap.xml' | wc -l`" != "0" ]; then \
			git add --all . && \
			git commit -am "Auto updated site"; \
      git push origin main; \
		fi

update:
	# Setup git
	git config --global user.email "damian@damianzaremba.co.uk"
	git config --global user.name "Damian Zaremba"

	# Make sure the dir exists
	test -d content/cv/ || mkdir -p content/cv/; exit 0

	# Download the current README
	wget -O /tmp/github-damianzaremba-cv-readme https://raw.github.com/DamianZaremba/cv/main/README.md

	# Write out the header
	echo "---" > content/cv/index.markdown
	echo "layout: default" >> content/cv/index.markdown
	echo "title: CV" >> content/cv/index.markdown
	echo "description: Damian Zaremba's CV" >> content/cv/index.markdown
	echo "---" >> content/cv/index.markdown

	# Cat in the main stuff ignoring the header crap
	tail -n +4 /tmp/github-damianzaremba-cv-readme >> content/cv/index.markdown
	rm -f /tmp/github-damianzaremba-cv-readme

	# Write out the footer
	echo >> content/cv/index.markdown
	echo >> content/cv/index.markdown
	echo "Other Formats" >> content/cv/index.markdown
	echo "-------------" >> content/cv/index.markdown
	echo "Available on [GitHub](https://github.com/DamianZaremba/cv/)" >> content/cv/index.markdown

	# Pull in the compiled formats
	wget -O content/cv/scuba-diving.pdf https://raw.github.com/DamianZaremba/cv/scuba-diving/damianzaremba.pdf

	# Commit the update if the working dir is clean
	if [ ! -z "`git status --porcelain | grep content/cv/`" ]; then \
		git add --all content/cv/ && \
		git commit -am "Updating CV from source"; \
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
