---
layout: default
title: Projects
description: Damian Zaremba's Projects
---

Opensource Projects
===================

### Sentry Trello Plugin
[Sentry](https://www.getsentry.com/) plugin that creates
[Trello](https://trello.com/) cards for events.

References:
[Source](https://github.com/DamianZaremba/sentry-trello) |
[Pypi](https://pypi.python.org/pypi?name=sentry-trello)

### Puppet Sentry Plugin
[Puppet](https://puppetlabs.com/) reporter that sends run issues to [Sentry](https://www.getsentry.com/) 

References:
[Source](https://github.com/DamianZaremba/sentry-puppet)

### Wikimedia Labs Bots vHost Builder
Python script to create public_html folders for users of the Bots project on
[Wikimedia Labs](https://wikitech.wikimedia.org/).

References:
[Source](https://github.com/DamianZaremba/labs-bots-vhost-builder)

### Wikimedia Labs Nagios Config Builder
Python script to create [Nagios](http://www.nagios.org) config files for
[Wikimedia Labs](https://wikitech.wikimedia.org/).

Supports autodiscovery of instances and services (based on puppet
manifests) as well as templating based on meta data.

References:
[Source](https://github.com/DamianZaremba/labsnagiosbuilder) |
[Gerrit](https://gerrit.wikimedia.org/r/#/q/project:labs/nagios-builder,n,z) |
[GitBlit](https://git.wikimedia.org/summary/labs%2Fnagios-builder)

### Trello backend for Django Social Auth
[Trello](https://trello.com) backend for
[django-social-auth](https://github.com/omab/django-social-auth/).

Written for [sentry-trello](https://github.com/DamianZaremba/sentry-trello), but should work with any
[django-social-auth](https://github.com/omab/django-social-auth/) install.

References:
[Source](https://github.com/DamianZaremba/django-social-auth-trello) |
[Pypi](https://pypi.python.org/pypi?name=django-social-auth-trello)

### McMyAdmin WHMCS Module
WHMCS plugin that (via MCMA) allows users to be assigned to Minecraft
groups based on purchased products.

Allows communities to give elevated game access to donors etc.

References:
[Source](https://github.com/DamianZaremba/McMyAdmin-WHMCS)

Projects I Contribute To
========================

### Sentry
Sentry is a realtime event logging and aggregation platform. It specializes in
monitoring errors and extracting all the information needed to do a proper
post-mortem without any of the hassle of the standard user feedback loop.

References:
[Upstream Source](https://github.com/getsentry/sentry) |
[Working Repo](https://github.com/DamianZaremba/sentry) |
[Get Sentry](https://www.getsentry.com/)

### Salt
Salt is a distributed remote execution system used to execute commands and query
data. It was developed in order to bring the best solutions found in the world
of remote execution together and make them better, faster and more malleable.
Salt accomplishes this via its ability to handle larger loads of information,
and not just dozens, but hundreds, or even thousands of individual servers. It
handles them quickly and through a simple yet manageable interface.

References:
[Upstream Source](https://github.com/saltstack/salt) |
[Working Repo](https://github.com/DamianZaremba/salt) |
[Salt Stack Community](http://saltstack.org)

### Salt API
The Salt API system is used to expose the fundamental aspects of Salt control to
external sources. salt-api acts as the bridge between Salt itself and REST,
Websockets, etc.

References:
[Upstream Source](https://github.com/saltstack/salt-api) |
[Working Repo](https://github.com/DamianZaremba/salt-api) |
[Salt Stack Community](http://saltstack.org)

### OpenStackManager
OSM is a [MediaWiki](http://www.mediawiki.org/) extension designed to manage
[OpenStack](http://www.openstack.org/) deployments.

References:
[Gerrit](https://gerrit.wikimedia.org/r/#/q/project:mediawiki/extensions/OpenStackManager,n,z) |
[GitBlit](https://git.wikimedia.org/summary/mediawiki%2Fextensions%2FOpenStackManager) |
[MediaWiki Page](http://www.mediawiki.org/wiki/Extension:OpenStackManager)

### LDAP Authentication Extension
Provides LDAP authentication, and some authorization functionality for MediaWiki

References:
[Gerrit](https://gerrit.wikimedia.org/r/#/q/project:mediawiki/extensions/LdapAuthentication,n,z) |
[GitBlit](https://git.wikimedia.org/summary/mediawiki%2Fextensions%2FLdapAuthentication) |
[MediaWiki Page](http://www.mediawiki.org/wiki/Extension:LDAP_Authentication)

### Elevator
Setuid wrapper that elevates a program to run as a target user.

References:
[Upstream Source](https://github.com/LukeCarrier/elevator) |
[Working Repo](https://github.com/DamianZaremba/elevator)

### ClueMon
Set of scripts to rebuild [SmokePing](http://oss.oetiker.ch/smokeping/) and
[Nagios](http://www.nagios.org/) configs for [ClueNet](http://cluenet.org),
based on a blend of LDAP and MediaWiki data.

References:
[Source](https://github.com/cluenet/cluemon)
