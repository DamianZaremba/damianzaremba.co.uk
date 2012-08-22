---
comments: true
layout: post
title: Lots of files to remove?
tags:
- FOSS
- How-to
---

So I recently have a few hundred thousand files in /tmp/ (was testing something and needed to remove them all)!

Bash as always is very helpful
{% highlight bash %}
[root@localhost]# rm -rf /tmp/*
-bash: /bin/rm: Argument list too long”
{% endhighlight %}

You also have this issue? Don't worry you can use find and feed the results into rm as follows
{% highlight bash %}
[root@localhost]# find /tmp/ | xargs rm
{% endhighlight %}

(You could also specify -type f or -type d if you only wanted files or directory, you may need rm -r rather than rm if you want to recurse into directories)

If you have seen the output of find previously you will know why this works, if not then here is a quick snippet:
{% highlight bash %}
[root@localhost]# find /tmp/
/tmp/repoup1291034701
/tmp/repoup1291034701/live
/tmp/repoup1291034701/live/.git
{% endhighlight %}

xargs just converts from standard input to command line arguments as can be seen below:
{% highlight bash %}
[root@localhost]# find /tmp/ | head -n 1 | xargs echo rm
rm /tmp/repoup1291034701
{% endhighlight %}

Hope this helps
