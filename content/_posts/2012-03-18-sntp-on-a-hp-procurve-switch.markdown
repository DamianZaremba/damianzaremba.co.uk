---
comments: true
layout: post
title: SNTP on a HP ProCurve switch
tags:
- How-to
- hp
- network
- ntp
- sntp
- switch
---

Configuring NTP for switches is a rather simple process, however the syntax varies depending on the switch OS.

Most switches use SNTP rather than NTP, SNTP is basically NTP but lacks some of the more advanced internal algorithms and is slightly less accurate.

To configure a ProCurve you need to use SNTP with the following syntax.
{% highlight text %}
sntp server <ip>
sntp unicast
timesync sntp
{% endhighlight %}

The first line defines what IP to sync with, the second tells the switch to use unicast UDP rather than TCP and the third tells the switch to sync it's time with the SNTP server.

This needs to be done in configure mode which can be got into via enable mode.
{% highlight text %}
enable
configure
{% endhighlight %}

Once the switch is syncing with the SNTP server you can check the time is correct with
{% highlight text %}
show time
{% endhighlight %}

Lastly just save the changes then logout
{% highlight text %}
write mem
logout
{% endhighlight %}

A full example of this is below:
{% highlight text %}
Switch> en
Switch# conf
Switch(config)# sntp server 79.142.192.4
Switch(config)# sntp unicast
Switch(config)# timesync sntp
Switch(config)# exit
Switch# write mem
Switch# logout
{% endhighlight %}

Your switches should now keep their time in sync :)
