---
comments: true
layout: post
title: Common cPanel migration issues
tags:
- Work
- Sysadmin
- cPanel
---

When migrating cPanel accounts between servers there are a number of common
issues you're likely to come up against.

Now while we're on the subject of doing (full) server to server migrations,
a quicker and more reliable script than cPanel's built in utility is as below.

This is based off notes in [this thread](http://forums.cpanel.net/f5/clone-server-server-b-35046-p4.html), with some reworked parts.

{% highlight bash %}
#!/bin/bash
# Before running this script setup ssh access to the target server
# so that 'passwordless' ssh may be accomplised (via ssh-agent or such.)
# ssh root@<target ip> should login to a shell on the target server as root
# without any user intervention (prompts)

# I suggest using IP addresses as a full migration will cause both servers to
# have the same hostname, which can lead to confusion!

# This will sync the config files only, once the migration is done I suggest
# at the minimum you do the following;
# * yum upgrade
# * yum update
# * Update MySQL/PHP/Apache
# * /scripts/upcp --force # this might update mysql - can bite
# * /scripts/rebuildhttpdconf
# * reboot
# * Check rrd databases are accessible
# * Check SSLs are being served (might require restarting services)

# Read the ip from argv[0]
if [ "$1" == "" ];
then
	echo "Usage: "$0" <target ip/hostname>"
	exit 2;
fi

# Our args
SSHARGS="-p 2022 -lroot"
RSYNCARGS="--archive --verbose --compress --delete"
TARGETHOST=$1

# System config files
rsync $RSYNCARGS -e "ssh $SSHARGS" \
	/etc/passwd \
	/etc/shadow \
	/etc/group \
\
	/etc/wwwacct.conf \
	/etc/quota.conf \
\
	/etc/reservedipreasons \
	/etc/reservedips \
\
	/etc/ips \
	/etc/domainips \
	/etc/nameserverips \
	/etc/ips.remotemail \
	/etc/ips.remotedns \
\
	/etc/localdomains \
	/etc/domainusers \
	/etc/trueuserdomains \
	/etc/domainalias \
\
	/etc/userdomains \
	/etc/userplans \
	/etc/userbwlimits \
	/etc/trueuserowners \
\
	/etc/vdomainaliases \
	/etc/valiases \
	/etc/vfilters \
	/etc/vmail \
\
	/etc/exim.conf* \
	/etc/remotedomains \
	/etc/backupmxhosts \
	/etc/secondarymx \
	/etc/senderverifybypasshosts \
	/etc/skipsmtpcheckhosts \
	/etc/trustedmailhosts \
\
	/etc/pure-ftpd* \
	/etc/proftpd* \
\
	/etc/ssl \
	/etc/my.cnf \
\
	/etc/cpbackup.conf \
	/etc/cpbackup-userskip.conf \
\
	/etc/auto.master \
	/etc/cpbackup.conf \
	/etc/auto.misc \
\
	/etc/named.conf \
	/etc/rndc.conf \
	$TARGETHOST:/etc/

# Variable data
rsync $RSYNCARGS -e "ssh $SSHARGS" \
	/var/cpanel \
	/var/spool \
	/var/log \
	/var/named \
	$TARGETHOST:/var/

# MySQL data
rsync $RSYNCARGS -e "ssh $SSHARGS" \
	/var/lib/mysql \
	$TARGETHOST:/var/lib/

rsync $RSYNCARGS -e "ssh $SSHARGS" \
	/root/.my.cnf \
	$TARGETHOST:/root/

# Random cPanel 3rd party data
rsync $RSYNCARGS -e "ssh $SSHARGS" \
	/usr/local/cpanel/3rdparty/mailman \
	$TARGETHOST:/usr/local/cpanel/3rdparty/

rsync $RSYNCARGS -e "ssh $SSHARGS" \
	/usr/local/cpanel/3rdparty/frontend \
	$TARGETHOST:/usr/local/cpanel/3rdparty/

rsync $RSYNCARGS -e "ssh $SSHARGS" \
	/usr/local/cpanel/3rdparty/interchange/interchange.cfg \
	$TARGETHOST:/usr/local/cpanel/3rdparty/interchange/

# Random Apache settings
rsync $RSYNCARGS -e "ssh $SSHARGS" \
	/usr/local/frontpage/conf \
	$TARGETHOST:/usr/local/apache/

rsync $RSYNCARGS -e "ssh $SSHARGS" \
	/usr/local/frontpage \
	$TARGETHOST:/usr/local/

rsync $RSYNCARGS -e "ssh $SSHARGS" \
	/usr/share/ssl \
	$TARGETHOST:/usr/share/

# Random SSL data
rsync $RSYNCARGS -e "ssh $SSHARGS" \
	/usr/local/apache/domlogs \
	$TARGETHOST:/usr/local/apache/

# Network settings
rsync $RSYNCARGS -e "ssh $SSHARGS" \
	/etc/sysconfig/network \
	$TARGETHOST:/etc/sysconfig/

rsync $RSYNCARGS -e "ssh $SSHARGS" \
	/etc/sysconfig/network-scripts/ifcfg-eth* \
	$TARGETHOST:/etc/sysconfig/network-scripts/

# User data!
rsync $RSYNCARGS -e "ssh $SSHARGS" \
	/home \
	$TARGETHOST:/
{% endhighlight %}

Now onto common issues.

