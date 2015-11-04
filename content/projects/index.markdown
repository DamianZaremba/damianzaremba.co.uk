---
layout: default
title: Projects
description: Damian Zaremba's Projects
---

Many projects I have a sensible amount of time to work on are proprietary or under NDA agreements.

This page highlights a few open projects that I'm involved with, you can also find some on my
[Github](https://github.com/DamianZaremba?tab=repositories) profile.

Projects I created
------------------

#### Puppet Sentry Plugin
[Puppet](https://puppetlabs.com/) reporter that sends run issues to [Sentry](https://www.getsentry.com/)

Links:
[Source](https://github.com/DamianZaremba/sentry-puppet)

#### Wikimedia Labs Nagios Config Builder
Python script to create [Nagios](http://www.nagios.org) config files for
[Wikimedia Labs](https://wikitech.wikimedia.org/).

Supports auto discovery of instances and services (based on puppet
manifests) as well as templating based on metadata.

Links:
[Source](https://github.com/DamianZaremba/labsnagiosbuilder) |
[Gerrit](https://gerrit.wikimedia.org/r/#/q/project:labs/nagios-builder,n,z) |
[GitBlit](https://git.wikimedia.org/summary/labs%2Fnagios-builder)

#### Trello backend for Django Social Auth
[Trello](https://trello.com) back end for
[django-social-auth](https://github.com/omab/django-social-auth/).

Written for [sentry-trello](https://github.com/DamianZaremba/sentry-trello), but should work with any
[django-social-auth](https://github.com/omab/django-social-auth/) install.

Links:
[Source](https://github.com/DamianZaremba/django-social-auth-trello) |
[Pypi](https://pypi.python.org/pypi?name=django-social-auth-trello)

Projects I Contribute To
------------------------

#### ClueBot NG/ClueBot III
Currently run the ClueBot NG and ClueBot III instances on Wikimedia tool labs.

Actively patch the bot/core/relay/report interface components to ensure it keeps running.

Over 2.5 million edits on Wikipedia (number 6 in the number of edits by a bot, number 1 anti-vandal bot on the English Wikipedia).

Score output is used by a number of other Human orientated tools, notably Huggle and Stiki.

Links:
[NG Source](https://github.com/damianzaremba/cluebotng) |
[III Source](https://github.com/damianzaremba/cluebot3)

#### Sentry
Sentry is a real-time event logging and aggregation platform. It specializes in
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

#### OpenStackManager
OSM is a [MediaWiki](http://www.mediawiki.org/) extension designed to manage
[OpenStack](http://www.openstack.org/) deployments.

Links:
[Gerrit](https://gerrit.wikimedia.org/r/#/q/project:mediawiki/extensions/OpenStackManager,n,z) |
[GitBlit](https://git.wikimedia.org/summary/mediawiki%2Fextensions%2FOpenStackManager) |
[MediaWiki Page](http://www.mediawiki.org/wiki/Extension:OpenStackManager)

#### Elevator
Setuid wrapper that elevates a program to run as a target user.

Links:
[Upstream Source](https://github.com/LukeCarrier/elevator) |
[Working Repo](https://github.com/DamianZaremba/elevator)

Proprietary Projects I Lead
---------------------------

#### Multi Region, Multi AZ AWS Deployment
Highly available e-commerce set-up using Java/PHP on the public facing aspects and Java/MSSQL/Kafka/RabbitMQ on the back end.

Deployed in a CI/CD manner, using Bamboo/CloudFormation/Code deploy to build and update stacks in the cloud. Tested via
Chaos monkey and bespoke JMeter/Selenium based acceptance/load tests.

Monitored via Cloudwatch, New relic and Pingdom; alerting via pager duty.

'Light' front ends deployed in multiple regions, back end apps deployed in a single region with multiple AZs. Front end to
back end communication via a mesh of IPSEC based VPNs providing inter-region connectivity.

#### Openstack Havana Deployment
Deployed an isolated 3 node (2 HA controllers) Openstack Havana set-up using NetApp ONTAP storage.

Built from nothing to a full network, storage and compute implementation.

Utilised Cisco 3750x/2960 switches (core/access) and the ASA 5515-X security appliance in a collapsed core design, providing redundant Gb access for core devices (EtherChannel bundles) and 192 Gb access ports.

Redundant upstream connections to the firewall provided Gb access to the internal corporate network (100Mb access to remote RnD sites) and 100Mb public IPv4/IPv6 transit.

#### Load testing tools
Built a set of tools to load test a HTTP based service in a repeatable manner.

Largely used JMeter - extended with its scripting interface - along with ApacheBench and a number of result processing tools.

#### DNS Stats Collector
Python based DNS sniffer, aimed at providing accurate DNS statistics on a per domain level.

Logic to aggregate record stats and provide zone related stats (zone/subdomain vs record) with time based collecting to a central store for graphing and accounting.

Handled >10 million DNS requests in POC stage with minimal issues.

#### Hosting migration tools
Developed a number of email and DNS migration tools for a company that was splitting away from its parent. Highly customised due to the source setup, migrated to a much more standard setup to improve ongoing support.

Processed >15k DNS zones at the record level.

#### Clook v2 portal/Vision 108 portal
Developed integration with internal monitoring, auditing and ticketing systems for the Vision 108 portal. Expanded the admin side of the portal with a custom API and improved server side tools.

Enriched the client experience by providing always correct, up to date information about their services.

#### clook.net
Development of custom pages for the clook.net website and integration of WordPress into the bespoke php based engine. All pages are dynamic based on section (ie a single job advert can be made active or inactive by flipping a flag in the config).

Active use of the WordPress integration (http://www.clook.net/blog/) as well as other pages (http://www.clook.net/company/careers, http://www.clook.net/services/complex-solutions etc) continue to this day.

#### FTP Enforcer
Custom pureauth wrapper based security system for FTP. Designed for Shared/Reseller cPanel based hosting servers.

Provides a cPanel and WHM interface, empowering end users and resellers alike to manage their FTP security.

Successfully deployed to around 100 servers and is in active use.

#### Custom cPanel DNS module
Custom cPanel DNS module to parse the original and new zone files, determine changes then relay to an API.

Enabled centralised tracking of DNS zones, auditing of record changes, association to clients and integration with the client portal and admin interfaces.

#### DNS Cluster
Redesigned the back end 'DNS cluster' software for CLOOK. Moved from a passive, custom apache vhost based system (which had multiple issues) to a server orientated system that could be actively interrogated for meta data as well as zones.

Reworked the collector to be multi-threaded and reduced collection intervals. Also introduced a 'diff' based update, based on zones and zone serial numbers. Removed SPOFs and migrated to a multiple collector based system, so each DNS server could act independently.

Also injected custom 'meta' records into the zones at the server level, enabling easy troubleshooting for support staff when looking at the live DNS servers

#### cPanel Dual/Triple stack PHP
Developed a custom system (with cPanel interface) for selecting PHP 5.2, 5.3 or 5.4 as the active version.

Used in a shared hosting environment of about 60 servers to enable developers to run PHP 5.2 compatible apps while the default version on the server was PHP 5.3.

Achieved using suphp and custom application handlers. Interface in cPanel then updated .htaccess files to activate the correct handler.

#### Email Depersonalizer
An Exchange 2010 custom transport agent, designed to rewrite all inbound and outbound email from a persons email address to their distribution list (primary DL stored in pager field).

Functionality currently provided outbound by CodeTwo, which doesn't support Inbound rewriting and is rather quite flaky.

Never deployed outside of a test setup.

#### Openfire DL based roster
Developed a bespoke roster management system for Openfire based on business requirements.

Using custom attributes in Active Directory, hundreds of arbitrary groups where calculated and stored for Openfire to serve.

#### Email retention enforcement
Developed a set of tools to forcibly remove emails (PST files) from desktop machines spread around the world, based on SCCM polling results.

Reported all removals/failures allowing a 'golden list' of outstanding files to be passed over to service desk staff for tracking down machines and manual removal.

Designed to run continuously without alerting users, until exec mandated requirements where met.

Also provided tools for checking which machines could be logged into remotely to enable pre-execution changes, such as re-enabling services via group policy.