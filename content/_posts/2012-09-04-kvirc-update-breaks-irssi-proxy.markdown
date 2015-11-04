---
comments: true
layout: post
title: KVIrc update breaks Irssi Proxy
tags:
- How-to
- Software
- IRC
- Irssi
- KVIrc
---

I recently updated KVIrc on OS X from 3.2.0 to 4.2.0.
The update appeared to complete successfully, however on trying to connect to my
Irssi Proxy server nothing appeared to happen.

The output from the server console was something like below

```text
This is the first connection in this IRC context: using the global server
setting
Attempting connection to myirssiproxy.local (RawrIRC) on port 8000
Looking up the server hostname (myirssiproxy.local)...
Server hostname resolved to 10.44.1.1
Contacting IRC server myirssiproxy.local (10.44.1.1) on port 8000
Connection established [myirssiproxy.local (10.44.1.1:8000)]
Local host address is 10.44.1.2
```

It turns out that in 4.2.0 the servers automatically had 'Switch to SSL/TLS by
using the STARTTLS extension' enabled.

Unfortunately Irssi Proxy doesn't like STARTTLS, so while the logs show
successful connections no data is transferred over the socket.

The simple solution to get things back up and running properly is to disable the
option under each server.

To do this browse to 'Configure servers' under Settings, double click on the
server under the network, tab over to Advanced and disable 'Switch to SSL/TLS by
using the STARTTLS extension'.

If you have a large number of servers you can also directly edit the ini file
under ~/.config/KVIrc/config/serverdb.kvc. In this file each network is a
section and each server is numbered.

To disabled STARTTLS for the first server in network A, your config should look
something like the below

```ini
[A]
0_EnabledSTARTTLS=false
```

This will usually have a number of other items, a full example is below

```ini
[FreeNode]
0_Port=8000
0_Hostname=myirssiproxy.local
0_Ip=10.44.1.1
0_Nick=MyNick
NServers=1
RealName=MyName
0_Pass=Mypass
0_AutoConnect=true
0_EnabledSTARTTLS=false
NickName=MyNick
0_Id=Server1
0_EnabledCAP=false
0_RealName=MyName
0_User=MyUser
UserName=Damian
```

This also makes it quite easy to generally manage servers in KVIrc, outside of wide
scale settings changes.
