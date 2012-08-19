---
comments: true
layout: post
title: RADIUS authentication on a HP GbE2c L2/L3 Blade Switch
tags:
- How-to
- Software
- Work
- Authentication
- Hp
- Network
- Radius
- Switch
---

To configure a HP GbE2c L2/L3 Ethernet Blade Switch for RADIUS authentication you need to use radius-server with the following syntax.
{% highlight text %}
radius-server primary-host serverIp
radius-server primary-host serverIp key "SecretKeyHere"
radius-server port 1812
radius-server timeout 10
radius-server enable
no radius-server telnet-backdoor
radius-server secure-backdoor
{% endhighlight %}

The first and second lines setup the server/key to authenticate against.

The third/forth defines the port/timeout for the server we configured in the first lines.

The last 3 then enable the server and enable a backdoor so we can authenticate against the switch if the RADIUS server is down.
