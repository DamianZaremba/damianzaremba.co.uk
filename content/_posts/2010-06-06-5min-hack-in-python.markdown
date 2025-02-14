---
layout: post
title: 5min hack in python
tags:
- Fun
- Python
---

So I was trying to test some SELlinux stuff out on my KVM box and was getting flooded by tail -f thanks to someone trying to brute force my box (good luck by the way because a) password authentication is disabled and b) root login is disabled >.>) anyway I got bored with this after about 5min and then spent the next 5min writing this:

```python
#!/usr/bin/python
import os
import socket

bannedHosts = []
failedHosts = []
ignoredIPs = []
failLimit = 0 # Better change this
bannedChain = "BadIp"

os.system("iptables -N %s &>/dev/null" % (bannedChain))
iptables = os.popen("iptables --list %s -n | egrep -v \"target.+prot.+opt.+source.+destination\" | egrep -v \"Chain %s .+ references\" | awk '{print $4}'" % (bannedChain, bannedChain))
for bannedIP in iptables.readlines():
 bannedHosts.append(bannedIP.rstrip())

loginFailures = os.popen("grep failure /var/log/secure | grep pam | awk -F \"rhost=\" '{print $2}' | awk '{print $1}' | uniq --count")
for line in loginFailures.readlines():
 (number, host) = line.split()
 try:
 ip = socket.gethostbyaddr(host)[2][0]
 except socket.error:
 ip = host

if int(number) > failLimit:
 print "%s is currently over fail limit, processing" % (ip)

if ip in bannedHosts:
 print "%s is allready banned, ignoring" % (ip)
 continue

if ip in ignoredIPs:
 print "%s is an ignored ip, ignoring" % (ip)
 continue

print "%s not allready banned, banning for %s failed attempts" % (host, number)
 os.system("iptables -A %s -s %s -j DROP" % (bannedChain, ip))
 else:
 print "%s is currently under fail limit, ignoring" % (host)
```

Which happens to nicely do the job as can be seen below:

```bash
[root@virtual1 ~]# ./check_bad_ip.py
213.225.207.41 is currently over fail limit, processing
mx-pool207-res41.momax.it not allready banned, banning for 15 failed attempts
88.191.92.219 is currently over fail limit, processing
sd-15684.dedibox.fr not already banned, banning for 1317 failed attempts
81.5.150.24 is currently under fail limit, ignoring
sd-15684.dedibox.fr is currently under fail limit, ignoring
81.5.150.24 is currently under fail limit, ignoring
sd-15684.dedibox.fr is currently under fail limit, ignoring
81.5.150.24 is currently under fail limit, ignoring
sd-15684.dedibox.fr is currently under fail limit, ignoring
81.5.150.24 is currently under fail limit, ignoring
sd-15684.dedibox.fr is currently under fail limit, ignoring
81.5.150.24 is currently under fail limit, ignoring
88.191.92.219 is currently over fail limit, processing
sd-15684.dedibox.fr not already banned, banning for 1014 failed attempts
114.207.245.128 is currently over fail limit, processing
114.207.245.128 not already banned, banning for 1350 failed attempts
62.182.30.165 is currently over fail limit, processing
30-165.kartel.komi.me not already banned, banning for 171 failed attempts
```

Oh yeah and I know the code is rubbish, it was very much a make it work thing ;) Also even though this "makes" the chain in iptables you still need to do:

```bash
iptables -I INPUT -j BadIp
iptables -I OUTPUT -j BadIp
iptables -I FORWARD -j BadIp
```

Because I didn't add in any code to check if they existed, nor the chain for that matter. Without them traffic won't get processed by these rules, also make sure they go near the top above any other allow rule C=
