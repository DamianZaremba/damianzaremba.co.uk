---
comments: true
layout: post
title: Unix time to human readable?
tags:
- FOSS
- Knowledge base
---

You can quickly convert Unix time to a human readable format by using the date command. This proves to be very helpful for bash scripts etc when you don't feel like calling out to Perl.

Quick example:
{% highlight bash %}
root@localhost [/]# date -d @1290705757
Thu Nov 25 18:22:37 CET 2010
{% endhighlight %}

You can also format the output of date to suit your needs, for example:
{% highlight bash %}
root@localhost [/]# date -d@1290705757 +"%H:%M:%S %d/%m/%Y"
18:22:37 25/11/2010
{% endhighlight %}

As expect this can very easily be scripted for example I was checking create times on some cPanel accounts:
{% highlight bash %}
root@localhost [/var/cpanel/users]# for user in *; do echo -n "$user: "; date -d@$(grep STARTDATE $user | cut -d’=’ -f2); done
damian: Thu Nov 18 21:17:44 CET 2010
test: Mon Nov 8 00:01:04 CET 2010
bob: Mon Nov 15 17:34:18 CET 2010
{% endhighlight %}
