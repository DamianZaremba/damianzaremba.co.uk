DamianZaremba.co.uk
===================

Source code for my personal site. The generated HTML is [here](https://github.com/DamianZaremba/damianzaremba.github.io/).

The site is generated via Jekyll, inspired by [David Cramer](http://justcramer.com/) and uses icons from [JIGSOAR](http://www.jigsoaricons.com/). The Jekyll plugins where mostly written by others, the respective licenses/authors can be found in the files themselves in the form of comments.

License
-------

The following directories and their contents are Copyright 2009-2018 Damian Zaremba.

You may not reuse anything within them without my permission:

* content/_posts/
* content/_postfiles/

All other directories and files, unless otherwise stated are GPLv3 Licensed. Feel free to use the HTML/CSS/plugins, linkbacks to [damianzaremba.co.uk](https://damianzaremba.co.uk) are appreciated.

How to build
------------

Install the dependencies:

* apt-get install rubygems ruby-gsl
* gem install jekyll
* gem install rdiscount
* gem install gsl

Build the content (including drafts) and serve it locally:

* make server

To deploy the site to production, build the production content and serve it locally:

* make prod-server

After proof reading etc, build and deploy the content:

* make install

The make tasks will take care of all the heavy lifiting, at a high level what they do is:

1. Update the source with the latest markdown copy of my CV from github
2. Download the YUI and HTML compressor utilities
3. Run jekyll over the source, outputting the final HTML
4. Compress the JS/CSS
5. Optionally compress the HTML - disabled for now as there is little gain
6. Reduce image quality of the icons to 70%
7. Clone out the production repo (HTML) into _live (or update the copy if it is already cloned)
8. Rsync the _site/ folder to the _live/ folder, removing any old content (apart from the .git folder)
9. Stages the changes to _live in git, commits the changes and pushes the repo up to Github
10. Github site hooks then deploy the site to their webservers and everything is done
