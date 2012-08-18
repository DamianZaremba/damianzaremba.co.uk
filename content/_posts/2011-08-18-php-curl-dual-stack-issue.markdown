---
comments: true
layout: post
title: PHP CURL dual stack issue
categories:
- FOSS
- How-to
- Linux
tags:
- curl
- php
---

I had a slightly strange issue this morning with PHP and curl (multi_curl actually but it affects curl too).
ClueBot NG was returning API errors all over the place, after a quick look though the main code it appeared that the data from the toolserver API wasn't getting returned properly. Trying to get the headers from the curl handler went no where, everything was returning back empty or NULL.

After testing the code on a different machine and it working fine I started to look at the URL that was being requested, a quick curl (on the command line) found that it hung. Off I went to look at its DNS entries and realised the tunnel on the server had dropped again (really need to get the server admin to move the tunnel somewhere more stable).

Now you would expect that if you cannot get traffic out on IPv6 that CURL would fall back to IPv4, it appears that it doesn't! What actually happens is it sits trying IPv6 until the connection timeout is hit then, showing no warning/error returns back NULL data. Yay for CURL!

A quick fix (until the datacenter gets native IPv6) is to force CURL to use ipv4 when resolving domain names. Now anyone that has looked at developing things in C with CURL will know this is really easy, however the PHP bindings don't even document that you can set the IPRESOLVE option, but you can! Yay for php...

The option is CURLOPT_IPRESOLVE and the value is either CURL_IPRESOLVE_V4, CURL_IPRESOLVE_V6 or CURL_IPRESOLVE_WHATEVER. To force IPv4 just use:
{% highlight php %}
curl_setopt( $ch, CURLOPT_IPRESOLVE, CURL_IPRESOLVE_V4 );
{% endhighlight %}

My test script in a broken state is:
{% highlight php %}
<?php
 $ch = curl_init();
 curl_setopt( $ch, CURLOPT_USERAGENT, 'ClueBot/2.0' );
 if( isset( $proxyhost ) and isset( $proxyport ) and $proxyport != null and $proxyhost != null ) {
 curl_setopt( $ch, CURLOPT_PROXYTYPE, isset( $proxytype ) ? $proxytype : CURLPROXY_HTTP );
 curl_setopt( $ch, CURLOPT_PROXY, $proxyhost );
 curl_setopt( $ch, CURLOPT_PROXYPORT, $proxyport );
 }
 curl_setopt( $ch, CURLOPT_URL, "http://toolserver.org/~cobi/cb.php?user=124.124.10.106&ns=0&title=Sayala&timestamp=1313668350" );
 curl_setopt( $ch, CURLOPT_FOLLOWLOCATION, 1 );
 curl_setopt( $ch, CURLOPT_MAXREDIRS, 10 );
 curl_setopt( $ch, CURLOPT_HEADER, 1 );
 curl_setopt( $ch, CURLOPT_RETURNTRANSFER, 1 );
 curl_setopt( $ch, CURLOPT_TIMEOUT, 120 );
 curl_setopt( $ch, CURLOPT_CONNECTTIMEOUT, 10 );
 curl_setopt( $ch, CURLOPT_HTTPGET, 1 );
 curl_setopt( $ch, CURLOPT_ENCODING, '' );

var_dump( curl_exec( $ch ) );
?>
{% endhighlight %}

And the test script in the fixed status is:
{% highlight php %}
<?php
 $ch = curl_init();
 curl_setopt( $ch, CURLOPT_USERAGENT, 'ClueBot/2.0' );
 if( isset( $proxyhost ) and isset( $proxyport ) and $proxyport != null and $proxyhost != null ) {
 curl_setopt( $ch, CURLOPT_PROXYTYPE, isset( $proxytype ) ? $proxytype : CURLPROXY_HTTP );
 curl_setopt( $ch, CURLOPT_PROXY, $proxyhost );
 curl_setopt( $ch, CURLOPT_PROXYPORT, $proxyport );
 }
 curl_setopt( $ch, CURLOPT_URL, "http://toolserver.org/~cobi/cb.php?user=124.124.10.106&ns=0&title=Sayala&timestamp=1313668350" );
 curl_setopt( $ch, CURLOPT_FOLLOWLOCATION, 1 );
 curl_setopt( $ch, CURLOPT_MAXREDIRS, 10 );
 curl_setopt( $ch, CURLOPT_HEADER, 1 );
 curl_setopt( $ch, CURLOPT_RETURNTRANSFER, 1 );
 curl_setopt( $ch, CURLOPT_TIMEOUT, 120 );
 curl_setopt( $ch, CURLOPT_CONNECTTIMEOUT, 10 );
 curl_setopt( $ch, CURLOPT_HTTPGET, 1 );
 curl_setopt( $ch, CURLOPT_ENCODING, '' );
 curl_setopt( $ch, CURLOPT_IPRESOLVE, CURL_IPRESOLVE_V4 );

var_dump( curl_exec( $ch ) );
?>
{% endhighlight %}

Simples!
