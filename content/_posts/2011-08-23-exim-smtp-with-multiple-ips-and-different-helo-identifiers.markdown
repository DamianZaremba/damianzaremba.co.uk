---
comments: true
layout: post
title: Exim SMTP with multiple IPs and different HELO identifiers
tags:
- Exim
- Knowledge Base
- Linux
- Software
- email
- helo
- multiple ips
- shared server
- smtp
---

To enable different helo commands on multiple IPs we need to utilize the Exim router and transport settings, these are available in Exim 4+.

The first thing we need to create is a custom Router, all the options are listed [here](http://www.exim.org/exim-html-current/doc/html/spec_html/ch15.html) and [here](http://www.exim.org/exim-html-current/doc/html/spec_html/ch17.html).

An example router:

{% highlight text %}
myrouter:
 driver = dnslookup
 senders = *@mydomain.com, *@*.mydomain.com
 transport = mytransport
{% endhighlight %}

The senders option is a CSV list of addresses to match in the From header. These can contain regex which makes matching whole domains really easy.

The transport option is a reference to your custom transport (see below).

Next we need to create a custom Transport, all the options are listed [here](http://www.exim.org/exim-html-current/doc/html/spec_html/ch24.html) and [here](http://www.exim.org/exim-html-current/doc/html/spec_html/ch30.html).

An example transport is:

{% highlight text %}
mytransport:
 driver = smtp
 interface = 192.168.0.1
 helo_data = mail.mydomain.com
{% endhighlight %}

The interface setting is the IP address this transport should be used on and the helo_data is the command to send.

This makes Exim an awesome platform for shared mail servers. It is very simple to offer whitelisting and protection against spammers.
