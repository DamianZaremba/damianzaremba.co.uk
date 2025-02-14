---
layout: post
title: Slow SSH to new CentOS servers
tags:
- Software
- SSH
- CentOS
- DNS
- IPv4
- IPv6
- Linux
---

Recently when installing new servers I 'randomly' had an issue where SSH connections would lag
out for 20-30 seconds on login then function fine once authenticated.

I noticed this issue on CentOS 5/6 servers, however it probably applies to
anything running glibc 2.10+.

Now while there are a few reasons SSH might be doing this (most of which can be
seen using verbose flags), it wasn't the usual suspects (GSSAPI etc).

The interesting part was, this wasn't happening on all servers (they are
standard config wise thanks to puppet).

It turns out the UseDNS setting was failing, very slowly. Now a simple way to
quickly solve the issue is to set `UseDNS no` in your sshd_config file.

This might be acceptable, depending on how much you have access restricted
however there is an alternative.

It turns out there was a change in glibc that can be seen on the
changelog [here](http://sourceware.org/ml/libc-alpha/2009-10/msg00063.html).

Under some circumstances (especially when firewalls are involved) DNS resolution
will fail and glibc should fallback, close the socket and start again. It would
seem this takes rather a long while when trying to SSH!

Thankfully there is a ([recently](https://bugzilla.kernel.org/show_bug.cgi?id=38542)
documented) option that you can add to your
resolv.conf file `single-request-reopen`. This forces glibc to enter
fallback mode straight away and kills the delay.

An example of the 'patched' /etc/resolv.conf file

```text
# This file is managed via Puppet

# Servers
nameserver 8.8.8.8
nameserver 8.8.4.4
nameserver 208.67.222.222
nameserver 208.67.220.220

# Options
options single-request-reopen
```

Now you might want to dig into your network stack a little more and make sure
you can handle IPv6/dual stack properly but for now, problem solved!
