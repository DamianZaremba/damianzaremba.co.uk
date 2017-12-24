---
comments: true
layout: post
title: ClueBot Wikimedia Labs Setup
tags:
- General
- How-to
- FOSS
---

A few years ago (was it really that long?!), [ClueBot III](https://en.wikipedia.org/wiki/User:ClueBot_III) & [ClueBot NG](https://en.wikipedia.org/wiki/User:ClueBot_NG) where moved into [Wikimedia Labs](https://wikitech.wikimedia.org/wiki/Portal:Wikimedia_Labs) from personal/community servers on [Cluenet](https://www.cluenet.org/).

A while later, they were migrated again from [Wikimedia Labs](https://wikitech.wikimedia.org/wiki/Portal:Wikimedia_Labs) into [Wikimedia Tool Labs](https://wikitech.wikimedia.org/wiki/Portal:Tool_Labs), providing more resources via the [Open Grid Manager](http://gridscheduler.sourceforge.net/) cluster as well as [web services](https://wikitech.wikimedia.org/wiki/Help:Tool_Labs/Web) and other shared community things.

Recently due to [Ubunutu Precise LTS](http://releases.ubuntu.com/12.04/) hitting EOL, the [Tool Labs](https://wikitech.wikimedia.org/wiki/Portal:Tool_Labs) containers where migrated to run under [Ubuntu Trusty LTS](http://releases.ubuntu.com/14.04/).

During the latest migration, the tool accounts where re-created from scratch. This post will outline how things are configured for a point of reference in the future.

Overview
========
Accounts:

* `tools.cluebot` - Legacy account - only a webservice redirect is running
* `tools.cluebot3` - Dedicated account for [ClueBot III](https://en.wikipedia.org/wiki/User:ClueBot_III)
* `tools.cluebotng` - Account for all things related to [ClueBot NG](https://en.wikipedia.org/wiki/User:ClueBot_NG)

Databases:

* `s51109__cb` - Legacy database, no longer updated
* `s52585__cb` - Migrated database, now master

Key Directories/Files:

**tools.cluebot3**

* ~/cluebot3 - Clone of [https://github.com/DamianZaremba/cluebot3](https://github.com/DamianZaremba/cluebot3)
* ~/cluebot3/cluebot3.config.php - Config file
* ~/.bigbrotherrc - Job Supervisor

**tools.cluebotng**

* ~/apps/bot - Clone of [https://github.com/DamianZaremba/cluebotng](https://github.com/DamianZaremba/cluebotng)
* ~/apps/report_interface - Clone of [https://github.com/DamianZaremba/cluebotng-report](https://github.com/DamianZaremba/cluebotng-report)
* ~/apps/utils - Clone of [https://github.com/DamianZaremba/cbng-utils](https://github.com/DamianZaremba/cbng-utils)
* ~/apps/core - Downloads of ANN binaries from bintray
* ~/public_html - Symlink to ~/apps/report_interface
* ~/.cluebotng.password.only - Wikimedia password
* ~/.bigbrotherrc - Job Supervisor
* ~/mysql_backups - Database dumps
* crontab - Database backup/clean crons

#### Hosted externally

* check_cluebot3.pl / check_cluebotng.pl - Scripts to check last edit time + email alerts

ClueBot III
===========

Setup
-----

This is a very simple bot, relying on a config file only.

The server-side setup, assuming a clean account can be done following the below (locally):

* `pip install fabric`
* `git clone git@github.com:DamianZaremba/cluebot3.git`
* `cd cluebot3`
* `fab init`

A manual setup is required to create the config file.

This should be created as `~/cluebot3/cluebot3.config.php` under the tool account, containing the below:

```php
<?php
	$owner = 'Cobi';
	$user = 'ClueBot III';
	$pass = 'Clearly this is not the actual password';
	$status = 'rw';
	$maxlag = 2;
	$maxlagkeepgoing = true;
```


In your local git clone, you can now do a full deploy (this starts the bot):

* `fab deploy`

Things should be running, check the job status/logs under the tool account to confirm this.

```bash
tools.cluebot3@tools-bastion-03:~$ qstat
job-ID  prior   name       user         state submit/start at     queue                          slots ja-task-ID
-----------------------------------------------------------------------------------------------------------------
xxxxxxx 0.30169 cluebot3   tools.cluebo r     03/04/2017 10:23:33 continuous@tools-exec-xxxx.eqi     1

tools.cluebot3@tools-bastion-03:~$ tail -f ~/logs/cluebot3-2017-03-05.log
cluebot3.INFO: doarchive(xxxxxxxxxxxx) [] []
```

You should also see [edits](https://en.wikipedia.org/wiki/Special:Contributions/ClueBot_III) from the bot after a while (a number of index pages need to be checked first).

Debugging
---------

The main bot log is normally somewhat insightful. Sometimes the bot will die due to memory usage when processing large pages,
this generally isn't seen in the logs and is hard to replicate running manually; looking for restarts is an indicator.

ClueBot NG
==========

This bot is slightly more complicated and has numerous parts. The main part is fully scripted, but a number of (non-obvious) configs need to be in place.

Architecture
------------

This is not a depiction of request flow, but service dependencies.

{% digraph layer 1 encryption %}
"Wikipedia IRC RC Feed" -> "Main BOT" [dir=back];
"Main BOT" -> {"Wikimedia Labs Tools Database", "Wikipedia Database Replica", "ANN Core", "Wikimedia API", "IRC Relay"}
"Review Interface" -> {"Wikimedia Labs Tools Database", "Wikimedia API", "IRC Relay"}
"IRC Relay" -> "ClueNet IRC";
"ClueNet IRC" -> "Huggle / External Tools" [dir=back];
{% enddigraph %}

Critical services for basic bot functionality include:

* Wikipedia API (For downloading changes + reverts)
* Tools DB (For creating vandalism IDs + recording action)
* Wikipedia DB Replicas (up to date) (For fetching extra metadata)
* Wikipedia IRC RC Feed (For the change feed)
* Main Bot (Processor)
* Core (For edit scoring)

Setup
-----

The server-side setup, assuming a clean account can be done following the below (locally):

* `pip install fabric`
* `git clone git@github.com:DamianZaremba/cluebotng.git`
* `cd cluebotng`
* `fab deploy`

### Config Files

A number of config files need to be created manually.

#### ~/.cluebotng.password.only

```plain
The Wikipedia ClueBot NG user password
```

#### ~/apps/bot/bot/cluebot-ng.config.php

```php
<?php
namespace CluebotNG;

class Config
{
    public static $user = 'ClueBot NG';
    public static $pass = null;
    public static $status = 'auto';
    public static $angry = false;
    public static $owner = 'Cobi';
    public static $friends = 'ClueBot,DASHBotAV';
    public static $mw_mysql_host = 'enwiki.labsdb';
    public static $mw_mysql_port = 3306;
    public static $mw_mysql_user = 's52585';
    public static $mw_mysql_pass = 'a password that is actually real';
    public static $mw_mysql_db = 'enwiki_p';
    public static $legacy_mysql_host = 'tools-db';
    public static $legacy_mysql_port = 3306;
    public static $legacy_mysql_user = 's52585';
    public static $legacy_mysql_pass = 'a password that is actually real';
    public static $legacy_mysql_db = 's52585__cb';
    public static $cb_mysql_host = 'tools-db';
    public static $cb_mysql_port = 3306;
    public static $cb_mysql_user = 's52585';
    public static $cb_mysql_pass = 'a password that is actually real';
    public static $cb_mysql_db = 's52585__cb';
    public static $udpport = 3334;
    public static $coreport = 3565;
    public static $fork = true;
    public static $dry = false;
    public static $sentry_url = null;
}
```

#### ~/apps/report_interface/web-settings.php

```php
<?PHP
	$dbHost = 'tools-db';
	$dbUser = 's52585';
	$dbPass = 'a password that is actually real';
	$dbSchema = 's52585__cb';
	$rcport = 3333;
	$recaptcha_pubkey = "something here";
	$recaptcha_privkey = "something here too";
```

#### ~/apps/bot/relay_irc/relay_irc.conf.js

```javascript
exports.nick = 'CBNGRelay';
exports.server = 'irc.cluenet.org';
exports.extra = [
    'OPER antiflood This Is Not The One You Are Looking For',
];
```

### Re-Deploy

Now the config files are in place, the bot should actually work.

In your local git clone, complete another deploy, to restart everything:

* `fab deploy`

### Bot Checks

##### First, check the job status

```bash
tools.cluebotng@tools-bastion-03:~$ qstat
job-ID  prior   name       user         state submit/start at     queue                          slots ja-task-ID
-----------------------------------------------------------------------------------------------------------------
xxxxxxx 0.30159 lighttpd-c tools.cluebo r     03/04/2017 12:48:57 webgrid-lighttpd@tools-webgrid     1
xxxxxxx 0.30154 cbng_relay tools.cluebo r     03/04/2017 13:32:09 continuous@tools-exec-xxxx.too     1
xxxxxxx 0.30154 cbng_core  tools.cluebo r     03/04/2017 13:32:11 continuous@tools-exec-xxxx.too     1
xxxxxxx 0.30092 cbng_bot   tools.cluebo r     03/04/2017 23:56:38 continuous@tools-exec-xxxx.too     1
```

##### Next check the bot logs

```
tools.cluebotng@tools-bastion-03:~$ tail -f ~/logs/cluebotng-2017-03-05.log
cluebotng.INFO: Processing: [[Something]] [...]
```

##### Then check the IRC Feeds (irc.cluenet.org)

* `#cluebotng-spam` - Should have constant messages
* `#wikipedia-VAN` - Should have a message within 10min

Confirm the bot is also [making edits](https://en.wikipedia.org/wiki/Special:Contributions/ClueBot_NG) inline with messages reported in `#wikipedia-VAN`.

##### Finally, check the review interface

* [https://tools.wmflabs.org/cluebotng/?page=List](https://tools.wmflabs.org/cluebotng/?page=List) - Should render
* [https://tools.wmflabs.org/cluebotng/?page=View&id=120371](https://tools.wmflabs.org/cluebotng/?page=View&id=120371) - Should render
* Take a recent edit from the `#wikipedia-VAN` channel and submit it as a reported
* Check Sign In works (set your test above to invalid, if it looks OK)

### General Checks

After a couple of hours, check:

* check_cluebot3.pl / check_cluebotng.pl are successfully running externally
* ~/mysql_backups/ contains valid database dumps
* No 'not running' emails have been received
* ~/bigbrother.log for restarts
* [ClueBot Commons](https://en.wikipedia.org/wiki/User_talk:ClueBot_Commons) For user problems

Debugging
---------

The main bot log provides a good indicator as to the source of problems but has limited data due to the logging volume.

It is common to see 'Failed to get edit data for xxx', this is only a problem if it's happening for a large number of changes; normally this is due to delayed replicas, causing the user/page metadata for new users/pages to be non-existent.

The relays generally don't break but may have incorrect entries in database. The simplest fix is to kill the job and let it re-spawn.

The report interface will likely break due to PHP being updated, it will need fixing randomly; there is a motivation to rebuild the interface to include the review functionality as well as oauth based authentication ([T135323](https://phabricator.wikimedia.org/T135323)).
