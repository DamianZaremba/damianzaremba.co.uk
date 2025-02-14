---
layout: post
title: Fixing iptables for passive FTP
tags:
- Knowledge base
- Linux
- Firewall
- Ftp
- Iptables
- Passive ftp
---

To make passive FTP work with iptables you need to enable the "ip_conntrack_ftp" module. This is done by editing the /etc/sysconfig/iptables-config and changing

```text
IPTABLES_MODULES=""
```

To include the ip_conntrack_ftp module, like so:

```text
IPTABLES_MODULES="ip_conntrack_ftp"
```

Once this is done, restart iptables and it should play nicely with passive FTP.
