---
comments: true
layout: post
title: Upgrade EOL Clamav
tags:
- Knowledge base
- Linux
- Clamav
- Eol
- Update
---

{% highlight text %}

ClamAV have EOL'd all their versions prior to 0.95 - if you see an error like the following then ClamAV needs an update:
 LibClamAV Warning: ***********************************************************
 LibClamAV Warning: *** This version of the ClamAV engine is outdated. ***
 LibClamAV Warning: *** DON'T PANIC! Read http://www.clamav.net/support/faq ***
 LibClamAV Warning: ***********************************************************
 LibClamAV Error: cli_hex2str(): Malformed hexstring: This ClamAV version has reached End of Life! Please upgrade to version 0.95 or later. For more information see www.clamav.net/eol-clamav-094 and www.clamav.net/download (length: 169)
 LibClamAV Error: Problem parsing database at line 742
 LibClamAV Error: Can't load daily.ndb: Malformed database
 LibClamAV Error: cli_tgzload: Can't load daily.ndb
 LibClamAV Error: Can't load /var/lib/clamav/daily.cld: Malformed database
 ERROR: Malformed database

{% endhighlight %}

To upgrade ClamAV on a RHEL based system perform the following:

1. wget http://pkgs.repoforge.org/clamav/clamav-0.96.1-1.el5.src.rpm
2. yum install srpm unzip
3. CFLAGS="-O0" ./configure --disable-zlib-vcheck
4. make && make install
5. Update /usr/local/etc/clamd.conf (notably removing the "Example" line and un-commenting the TCP socket line).

ClamAV should now work once again.
