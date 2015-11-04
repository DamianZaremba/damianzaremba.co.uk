---
comments: true
layout: post
title: RADIUS authentication on a Dell PowerConnect M6220 switch
tags:
- How-to
- Software
- Work
- Authentication
- Dell
- Network
- Radius
- Switch
---

A while back I posted the 'how-to' on setting up HP switches for RADIUS authentication
([here](/2012/04/radius-authentication-on-a-hp-gbe2c-l2-l3-blade-switch/) for GbE2c L2/L3 switches and
[here](/2012/04/radius-authentication-on-a-hp-procurve-switch/) for ProCurve switches).

I also had to setup some Dell PowerConnect M6220 switches; these proved to be
slightly more complicated than the HP's, but followed the Cisco style config.

First we need add a custom login and enable method

```text
aaa authentication login "LineName" radius local
aaa authentication enable "LineName" none
```

These are used for connections over SSH - "LineName" can be anything, I tend to
use the company name to keep things standard.

On the second line, you could also use radius local - this would require a
password to enter enable mode. Personally I control the login mode from the
RADIUS server and find having to enter a password to get to enable again a hassle.

Next we need to setup the RADIUS server

```text
radius-server host auth serverIpHere
name "server1"
usage login
key "SecretKeyHere"
exit
```

Now we just need to configure the ssh line to use our aaa methods

```text
login authentication LineName
enable authentication LineName
```

Once complete you should be able to login via ssh using your RADIUS details.

If you require access to the switch over http(s) you can also configure the HTTP
server to authenticate against RADIUS

```text
ip http authentication radius local
ip https authentication radius local
```

We include local on every method to ensure we don't get locked out the switch.
