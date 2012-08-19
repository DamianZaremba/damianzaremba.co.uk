---
comments: true
layout: post
title: Fixing iptables for passive FTP
tags:
- Knowledge Base
- Linux
- firewall
- ftp
- iptables
- passive ftp
---

To make passive FTP work with iptables you need to enable the "ip_conntrack_ftp" module. This is done by editing the /etc/sysconfig/iptables-config and changing

{% highlight text %}
IPTABLES_MODULES=""
{% endhighlight %}

To include the ip_conntrack_ftp module, like so:

{% highlight text %}
IPTABLES_MODULES="ip_conntrack_ftp"
{% endhighlight %}

Once this is done, restart iptables and it should play nicely with passive FTP.
