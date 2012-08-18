---
comments: true
layout: post
title: Apache process ID
categories:
- Apache
- FOSS
- Knowledge Base
- Linux
tags:
- apache
- logformat
- process
---

Sometimes you need to know the Apache PID when trying to track down segfaults or CPU usage issues.

There is a very simple way to do this by altering your LogFormat, a command format to have is the CLF (common log format):
{% highlight text %}
%h %l %u %t \"%r\" %>s %b
{% endhighlight %}

To enable logging the pid just add the %P var like so:
{% highlight text %}
[%P] %h %l %u %t \"%r\" %>s %b
{% endhighlight %}
