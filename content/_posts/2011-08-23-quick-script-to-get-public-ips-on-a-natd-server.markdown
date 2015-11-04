---
comments: true
layout: post
title: Quick script to get public IPs on a NAT'd server
tags:
- FOSS
- Fun
- Knowledge base
- Linux
- Bash
- Curl
- Ips
- Nat
---

A quick one liner to get the public equivalent of internal IPs on a box behind NAT:

```bash
for int in $(ifconfig | grep "Link encap:" | awk '{print $1}' | grep -v 'lo'); do echo "$int: $(ifconfig $int | grep "inet addr:" | awk '{print $2}' | cut -d: -f2) => $(curl -s --interface $int ipv4.canhazip.info)"; done
```

I've restricted this to IPv4 only - NATing IPv6 is just silly but if you really want then it is on your head.

Example usage is as follows:

```bash
[damian@finnix ~]$ for int in $(ifconfig | grep "Link encap:" | awk '{print $1}' | grep -v 'lo'); do echo "$int: $(ifconfig $int | grep "inet addr:" | awk '{print $2}' | cut -d: -f2) => $(curl -s --interface $int ipv4.canhazip.info)"; done
br0: 10.44.200.5 => 89.242.208.82
br0:1: 10.44.200.15 => 89.242.208.82
cluevpn: 10.156.1.49 => 89.242.208.82
eth0: =>
vnet0: =>
```

Or if you want IPv6 addresses returned:

```bash
[damian@finnix ~]$ for int in $(ifconfig | grep "Link encap:" | awk '{print $1}' | grep -v 'lo'); do echo "$int: $(ifconfig $int | grep "inet addr:" | awk '{print $2}' | cut -d: -f2) => $(curl -s --interface $int canhazip.info)"; done
br0: 10.44.200.5 => 2001:470:9083::2
br0:1: 10.44.200.15 =>
cluevpn: 10.156.1.49 =>
eth0: =>
vnet0: =>
```
