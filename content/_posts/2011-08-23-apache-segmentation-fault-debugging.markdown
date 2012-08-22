---
comments: true
layout: post
title: Apache segmentation fault debugging
tags:
- FOSS
- Knowledge base
- Linux
- Apache
- Core dumps
- Segfault
---

Sometimes you will see lines like this in the Apache error log:

{% highlight text %}
[notice] child pid 5 exit signal Segmentation fault (11)
{% endhighlight %}

This means for some reason the child thread/fork has segfaulted when trying to process the request.

By default apache won't give you any more info than this. To get core dumps you will need to do the following.

1. Enable system coredumps for the apache user.
In /etc/security/limits.conf ensure the following line is present:

{% highlight text %}
apache soft core 10000
{% endhighlight %}

2. Tell apache what directory to put dumps into, do this with the following config line:

{% highlight text %}
CoreDumpDirectory /var/apache/coredumps/
{% endhighlight %}

3. Ensure the dump directory is writeable by the apache user (if not then you will get no dumps!).

4. Restart apache and wait for a segfault.

Now if you look in your specified CoreDumpDirectory you should see a number of .dump files.

To debug these you will need to understand system calls and have some general debugging experience when it comes to executables.

An example of how to load up the core dump into a debugger (gdb) is as follows:

{% highlight text %}
gdb /usr/sbin/httpd -c /var/apache/coredumps/somefile.dump
{% endhighlight %}

Some genreal tips on how to use a debugger for looking at Apache dumps can be found on [their website](http://httpd.apache.org/dev/debugging.html).
