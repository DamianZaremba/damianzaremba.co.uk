#!/bin/bash
REPO_URL="https://github.com/DamianZaremba/damianzaremba.co.uk"
CLONE_DIR="/srv/damianzaremba.co.uk/source"
DEST_DIR="/srv/damianzaremba.co.uk/htdocs"
PRE_HASH="no pre hash"
POST_HASH="no post hash"

# Get the latest
if [ ! -d "$CLONE_DIR/.git" ];
then
	# Cleanly clone the repo
	rm -rf "$CLONE_DIR" || true
	git clone "$REPO_URL" "$CLONE_DIR"
else
	# Get the current HEAD sha1 (before we pull)
	PRE_HASH=$(git rev-parse HEAD)

	# Reset the repo to a clean state and pull changes
	cd "$CLONE_DIR" && (
		git reset --hard
		git pull origin master
	)
fi

# Get the HEAD sha1
POST_HASH=$(git rev-parse HEAD)

# If the source is newer now than before
if [ "$PRE_HASH" != "$POST_HASH" ];
then
	# Build the latest
	cd "$CLONE_DIR" && make update compile minify

	# Copy the latest to the target
	rsync -avr "$CLONE_DIR/_site/" "$DEST_DIR/"

	# Cleanup any stuff we don't want in the public repo
	find "$DEST_DIR" -name '.git' -delete
	find "$DEST_DIR" -name '.gitignore' -delete

	# Fix permissions/ownership
	chown nobody.nobody -R "$DEST_DIR/"
	find "$DEST_DIR/" -type f -exec chmod 644 {} \;
	find "$DEST_DIR/" -type d -exec chmod 755 {} \;
fi