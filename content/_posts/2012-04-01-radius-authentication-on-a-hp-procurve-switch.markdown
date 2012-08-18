---
comments: true
layout: post
title: RADIUS authentication on a HP ProCurve switch
categories:
- How-to
- Software
- Work
tags:
- authentication
- hp
- network
- radius
- switch
---

To configure a HP ProCurve switch for RADIUS authentication you need to use radius-server with the following syntax.
{% highlight text %}
radius-server host serverIp key "SecretKeyHere"
{% endhighlight %}

Once this is setup you need to configure the switch to authenticate against the radius server.
{% highlight text %}
aaa authentication login privilege-mode 
aaa authentication console login radius local 
aaa authentication console enable radius local 
aaa authentication telnet login radius local 
aaa authentication telnet enable radius local 
aaa authentication web login radius local 
aaa authentication ssh login radius local 
aaa authentication ssh enable radius local 
{% endhighlight %}

We include the local option so that in the event of the RADIUS server being down we can still authenticate.
