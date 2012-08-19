---
comments: true
layout: post
title: Common PCI compliance issues - cPanel
categories:
- Apache
- cPanel
- Exim
- Knowledge Base
- Linux
tags:
- compliance
- hardening
- pci
- security
---

It is quite common for companies running cPanel to attempt to gain PCI compliance. Here are a few common things to do before submitting a scan request.

1) Setup a firewall - PCI love to moan about ports that are not secure. Sometimes they don't even header check what is running, they just assume based on IANA assignments what is running.

For ports that ARE secure but PCI refuse to believe (self signed certs, cPanel/WHM ports) etc there is a quick and dirty solution. Restrict access to those ports from your office IP.

If the PCI scanner can't access the port it can't complain. Also fixes any real security issue - who wants to leave a panel that uses system logins open to the public!

Make sure things like MySQL are blocked off - yes, they have ACLs but the scanner is like a nazi at a blond, jewish party.

2) Fix SSL by disabling v2 and some weaker encryption methods.

In the httpd.conf (or just the SSL vhosts) add the following:
{% highlight text %}
SSLProtocol -ALL +SSLv3 +TLSv1
SSLCipherSuite ALL:!aNULL:!ADH:!eNULL:!LOW:!EXP:RC4+RSA:+HIGH:+MEDIUM
{% endhighlight %}

In the /usr/lib/courier-imap/etc/pop3d-ssl and /usr/lib/courier-imap/etc/imapd-ssl files add the following:
{% highlight text %}
TLS_CIPHER_LIST="ALL:!SSLv2:!ADH:!NULL:!EXPORT:!DES:!LOW:@STRENGTH"
{% endhighlight %}

In the exim.conf file add the following:
{% highlight text %}
tls_require_ciphers = ALL:!aNULL:!ADH:!eNULL:!LOW:!EXP:RC4+RSA:+HIGH:+MEDIUM:!SSLv2
{% endhighlight %}

3) Update the server (you should be doing this already).
{% highlight bash %}
/scripts/upcp
yum update
{% endhighlight %}

4) Disable mod_userdir.
You can disable this in WHM under Security -> Apache -> mod_userdir tweak.

5) Tell apache to reveal nothing much about its self. In httpd.conf add the following:
{% highlight text %}
ServerSignature Off
ServerTokens Prod
FileETag None
{% endhighlight %}

Also diable the TRACE method. To do this go into WHM -> Service configuration -> Apache -> Global configuration and set TraceEnable to off.

Notes:
Passing a PCI scan does not mean your server is secure. It means you have passed the very small set of tests they have available.

You should take some major steps to harden the server against local users as well as remote attacks.