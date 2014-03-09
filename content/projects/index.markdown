---
date: Sat Mar 01 15:19:39 +0000 2014
layout: default
title: Projects
description: Damian Zaremba's Projects
---

Opensource Projects
===================

#### Sentry Trello Plugin
[Sentry](https://www.getsentry.com/) plugin that creates
[Trello](https://trello.com/) cards for events.

Links:
[Source](https://github.com/DamianZaremba/sentry-trello) |
[Pypi](https://pypi.python.org/pypi?name=sentry-trello)

#### Puppet Sentry Plugin
[Puppet](https://puppetlabs.com/) reporter that sends run issues to [Sentry](https://www.getsentry.com/)

Links:
[Source](https://github.com/DamianZaremba/sentry-puppet)

#### Wikimedia Labs Bots MySQL creator
Development of an automated system to grant MySQL rights (including the ability to create databases) for users of the Wikimedia Labs Bots project.

This has now been superseded by the tools project with associated database setup.

Links:
[Source](https://github.com/DamianZaremba/labs-bots-mysql-creator)

#### Wikimedia Labs Bots vHost Builder
Python script to create public_html folders for users of the Bots project on
[Wikimedia Labs](https://wikitech.wikimedia.org/).

Links:
[Source](https://github.com/DamianZaremba/labs-bots-vhost-builder)

#### Wikimedia Labs Nagios Config Builder
Python script to create [Nagios](http://www.nagios.org) config files for
[Wikimedia Labs](https://wikitech.wikimedia.org/).

Supports autodiscovery of instances and services (based on puppet
manifests) as well as templating based on meta data.

Links:
[Source](https://github.com/DamianZaremba/labsnagiosbuilder) |
[Gerrit](https://gerrit.wikimedia.org/r/#/q/project:labs/nagios-builder,n,z) |
[GitBlit](https://git.wikimedia.org/summary/labs%2Fnagios-builder)

#### Trello backend for Django Social Auth
[Trello](https://trello.com) backend for
[django-social-auth](https://github.com/omab/django-social-auth/).

Written for [sentry-trello](https://github.com/DamianZaremba/sentry-trello), but should work with any
[django-social-auth](https://github.com/omab/django-social-auth/) install.

Links:
[Source](https://github.com/DamianZaremba/django-social-auth-trello) |
[Pypi](https://pypi.python.org/pypi?name=django-social-auth-trello)

#### McMyAdmin WHMCS Module
WHMCS plugin that (via MCMA) allows users to be assigned to Minecraft
groups based on purchased products.

Allows communities to give elevated game access to donors etc.

Links:
[Source](https://github.com/DamianZaremba/McMyAdmin-WHMCS)

#### Craft Bukkit User Log
A very simple proof of concept plugin for Craftbukkit that writes out the current users to a log file.

Designed for a customer to parse externally/extend, enabling them to relay notifications to IRC/Twitter/their website in real time.

Links:
[Source](https://github.com/DamianZaremba/craftbukkit-userlog)

#### Symbiosis real time DNS
Realtime DNS updater based on inotify for Symbiosis. Replaces the default hour cron job, enabling much faster update times for DNS changes in an automated way.
Links:
[Source](https://github.com/DamianZaremba/symbiosis-realtime-dns)

#### Wordpress Mint plugin
Integrated the Mint Analytics's platform into Wordpress based on client requirements.

Upon installation the plugin auto injected the required code into page headers and rendered a stats overview in the Admin panel.

Links:
[Source](http://plugins.svn.wordpress.org/mint/)

Projects I Contribute To
------------------------

#### Sentry
Sentry is a realtime event logging and aggregation platform. It specializes in
monitoring errors and extracting all the information needed to do a proper
post-mortem without any of the hassle of the standard user feedback loop.

Links:
[Upstream Source](https://github.com/getsentry/sentry) |
[Working Repo](https://github.com/DamianZaremba/sentry) |
[Get Sentry](https://www.getsentry.com/)

#### Salt
Salt is a distributed remote execution system used to execute commands and query
data. It was developed in order to bring the best solutions found in the world
of remote execution together and make them better, faster and more malleable.
Salt accomplishes this via its ability to handle larger loads of information,
and not just dozens, but hundreds, or even thousands of individual servers. It
handles them quickly and through a simple yet manageable interface.

Links:
[Upstream Source](https://github.com/saltstack/salt) |
[Working Repo](https://github.com/DamianZaremba/salt) |
[Salt Stack Community](http://saltstack.org)

#### Salt API
The Salt API system is used to expose the fundamental aspects of Salt control to
external sources. salt-api acts as the bridge between Salt itself and REST,
Websockets, etc.

Links:
[Upstream Source](https://github.com/saltstack/salt-api) |
[Working Repo](https://github.com/DamianZaremba/salt-api) |
[Salt Stack Community](http://saltstack.org)

#### OpenStackManager
OSM is a [MediaWiki](http://www.mediawiki.org/) extension designed to manage
[OpenStack](http://www.openstack.org/) deployments.

Links:
[Gerrit](https://gerrit.wikimedia.org/r/#/q/project:mediawiki/extensions/OpenStackManager,n,z) |
[GitBlit](https://git.wikimedia.org/summary/mediawiki%2Fextensions%2FOpenStackManager) |
[MediaWiki Page](http://www.mediawiki.org/wiki/Extension:OpenStackManager)

#### LDAP Authentication Extension
Provides LDAP authentication, and some authorization functionality for MediaWiki

Links:
[Gerrit](https://gerrit.wikimedia.org/r/#/q/project:mediawiki/extensions/LdapAuthentication,n,z) |
[GitBlit](https://git.wikimedia.org/summary/mediawiki%2Fextensions%2FLdapAuthentication) |
[MediaWiki Page](http://www.mediawiki.org/wiki/Extension:LDAP_Authentication)

#### Elevator
Setuid wrapper that elevates a program to run as a target user.

Links:
[Upstream Source](https://github.com/LukeCarrier/elevator) |
[Working Repo](https://github.com/DamianZaremba/elevator)

#### XenForo IRC Relay
Very simple node.js based IRC relay designed to poll an API endpoint on the forums and relay any new topics into an IRC channel.

Used to increase forum responsiveness successfully.

Links:
[Source](https://github.com/DamianZaremba/xenforo-irc-relay)

#### ClueMon
Set of scripts to rebuild [SmokePing](http://oss.oetiker.ch/smokeping/) and
[Nagios](http://www.nagios.org/) configs for [ClueNet](http://cluenet.org),
based on a blend of LDAP and MediaWiki data.

Links:
[Source](https://github.com/cluenet/cluemon)

#### ClueBot NG/ClueBot III
Currently run the ClueBot NG and ClueBot III instances on wikimedia tool labs.

Actively patch the bot/core/relay/report interface components to ensure it keeps running.

Over 2.5 million edits on Wikipedia (number 6 in the number of edits by a bot, number 1 anti-vandal bot on the English Wikipedia).

Score output is used by a number of other Human orientated tools, notably Huggle and Stiki.

Links:
[NG Source](https://github.com/damianzaremba/cluebotng) |
[III Source](https://github.com/damianzaremba/cluebot3)

Proprietary Projects
====================

#### DNS Stats Collector
Python based DNS sniffer, aimed at providing accurate DNS statistics on a per domain level.

Logic to aggregate record stats and provide zone related stats (zone/subdomain vs record) with time based collecting to a central store for graphing and accounting.

Handled >10 million DNS requests in POC stage with minimal issues.

#### FSScanner
Distributed file scanning service. Designed for shared hosting services to detect uploads that violate TOS (illegal software, large media files etc) based on policy.

Client/server design with hook based actions, allowing escalation via ticking systems or auto suspension.

POC deployment on 200 clients with 2 servers.

#### Fork of Maldet
Developed a custom version of malware detection software based on maldet for a hosting comapny.

Added multiple features that where required for their deployment, including heavily optimised multiprocessing.

#### Hosting migration tools
Developed a number of email and DNS migration tools for a company that was splitting away from its parent. Highly customised due to the source setup, migrated to a much more standard setup to improve on-going support.

Processed >15k DNS zones at the record level.

#### Clook v2 portal/Vision 108 portal
Developed integration with internal monitoring, auditing and ticketing systems for the Vision 108 portal. Expanded the admin side of the portal with a custom API and improved server side tools.

Enriched the client experience by providing always correct, up to date information about their services.

#### clook.net
Development of custom pages for the clook.net website and integration of wordpress into the bespoke php based engine. All pages are dynamic based on section (ie a single job advert can be made active or inactive by flipping a flag in the config).

Active use of the wordpress integration (http://www.clook.net/blog/) as well as other pages (http://www.clook.net/company/careers, http://www.clook.net/services/complex-solutions etc) continue to this day.

#### Clook NOC
Developed features for a custom Symfony v1.0 based "network operations center". Added support for software version tracking, forum integration, staff ip distribution, better auditing, automated password cycling (twice weekly), improved mass emailing support, tighter integration into the helpdesk (client lookup and marking un-authorised emails in red) to ensure compliance with security policies.

#### FTP Enforcer
Custom pureauth-wrapper based security system for FTP. Designed for Shared/Reseller cPanel based hosting servers.

Provides a cPanel and WHM interface, empowering end users and resellers alike to manage their FTP security.

Successfully deployed to around 100 servers and in active use.

#### SpeedyWeb
Flexible, lightweight Varnish integration for cPanel.

Aside from a few commercial options integrating Varnish with cPanel is rather clunky.

This plugin smoothed the whole process out and enabled end users to tweak caching rules.

Deployed to a handful of client servers, never feature complete enough for shared servers.

#### Custom cPanel DNS module
Custom cPanel DNS module to parse the original and new zone files, determine changes then relay to an API.

Enabled centralised tracking of DNS zones, auditing of record changes, association to clients and integration with the client portal and admin interfaces.

#### Nagios notifier
Nagios broker based notifier. Designed to aggregate monitoring events then relay them to a HTTP based API.

Enabled real time updating of status pages for clients, auditing of outage events, client specific rebates etc.

#### DNS Cluster
Redesigned the back end 'DNS cluster' software for CLOOK. Moved from a passive, custom apache vhost based system (which had multiple issues) to a server orientated system that could be actively interrogated for meta data as well as zones.

Reworked the collector to be multi-threaded and reduced collection intervals. Also introduced a 'diff' based update, based on zones and zone serial numbers. Removed SPOFs and migrated to a multiple collector based system, so each DNS server could act independently.

Also injected custom 'meta' records into the zones at the server level, enabling easy troubleshooting for support staff when looking at the live DNS servers

#### TGT 'Backup' SAN
Developed software for the automated management of TGT based iSCSI sans as part of an innovative to migrate away from Equal logics to more independent, cheaper units.

Deployed numerous Dell R720 based sans in a 'one per rack' configuration combined with blade centers, running the software.

#### BFD
Re-designed and existing tool to automatically detect and block brute force attacks against email services.

Configurable pattern based detection, supports Dovecot, Courier and Exim out the box.

Provided a simple command line interface to manage the blocks for helpdesk staff, hooks to notify the central NOC API of a block (so attacks against multiple targets could be blocked globally based...more

#### WHM APF Manager
WHM based plugin to manage the APF firewall package.

Designed to be simple and allow users to do what they need to (allow/block ips, open ports), but not change advanced features of the firewall.

#### cPanel Dual/Triple stack PHP
Developed a custom system (with cPanel interface) for selecting PHP 5.2, 5.3 or 5.4 as the active version.

Used in a shared hosting environment of about 60 servers to enable developers to run PHP 5.2 compatible apps while the default version on the server was PHP 5.3.

Achieved using suphp and custom application handlers. Interface in cPanel then updated .htaccess files to activate the correct handler.

#### Email Depersonalizer
An Exchange 2010 custom transport agent, designed to rewrite all inbound and outbound email from a persons email address to their distribution list (primary DL stored in pager field).

Functionality currently provided outbound by CodeTwo, which doesn't support Inbound rewriting and is rather quite flaky.

Never deployed outside of a test setup.

#### Monitoring portal
Custom 'dashboard' interface to Icinga. Also exposed current on-call contacts, link layer network topology, traffic graphs and other key information for first line help desk personal.

#### Puppet reports
Simple PHP based web interface for viewing puppet reports. Designed to be used with a sizeable set of puppet reports for helpdesk staff to drill in quickly.

#### Thumbnail gallery post
Designed and implemented a custom TGP framework composing of presentation, analytics and background processing modules.

Successfully deployed and used to create revenue from advertising spaces and affiliate site referrals.

#### Bacula Meta Restore
Developed a set of tools to restore meta data from Bacula. Main target focus was file permission/ownership information to aid in the fast restore of service post client 'accidents', without having to revert the file contents.

#### Facebook Photos Userspace Filesystem
Wrote a custom filesystem in userspace (FUSE) to expose Facebook photo albums locally, via the Facebook API.

Used to serve media from Facebook over the local network from a media server and simplify bulk uploading images.

#### Openfire DL based roster
Developed a bespoke roster management system for Openfire based on business requirements.

Using custom attributes in Active Directory, hundreds of arbitrary groups where calculated and stored for Openfire to serve.

#### Email retention enforcement
Developed a set of tools to forcibly remove emails (PST files) from desktop machines spread around the world, based on SCCM polling results.

Reported all removals/failures allowing a 'golden list' of outstanding files to be passed over to service desk staff for tracking down machines and manual removal.

Designed to run continuously without alerting users, until exec mandated requirements where met.

Also provided tools for checking which machines could be logged into remotely to enable pre-execution changes, such as re-enabling services via group policy.

#### Load testing tools
Built a set of tools to load test a HTTP based service in a repeatable manner.

Largely used JMeter - extended with its scripting interface - along with ApacheBench and a number of result processing tools.
