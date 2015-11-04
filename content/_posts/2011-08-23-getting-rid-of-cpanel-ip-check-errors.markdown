---
comments: true
layout: post
title: Getting rid of cPanel IP Check errors
tags:
- Cpanel
- Knowledge base
- Linux
- Software
- Error
- Ipcheck
---

On Linux servers behind NAT you will start getting emails warning that the DNS setup is broken.

cPanel states that the panel does not work behind NAT and the boxes need **public** ip addresses.

It seems that apart from this warning the panel and services function fine behind NAT (as expected) and while I wouldn't recommend it, sometimes you have no choice.

The email you get though is something like the following:

```text
[ipcheck] Problem with DNS setup on myserver.local

IMPORTANT: Do not ignore this email.

The hostname (myserver.local) resolves to 10.0.0.1. It should resolve to 192.168.0.1.
Please be sure to correct /etc/hosts as well as the 'A' entry in zone file for the domain.

Some are all of these problems can be caused by /etc/resolv.conf being setup incorrectly.
Please check this file if you believe everything else is correct.
```

The best way I find of "fixing" this is to just disable the "Ip address dns check" option in the contact manager.

You could alternatively comment out the check in /scripts/maintenance, however this will be lost in updates.
