---
comments: true
layout: post
title: Compiling nginx and PHP-FPM on CentOS 5
categories:
- FOSS
---

[Luke Carrier](http://lukecarrier.me/), founder and lead developer at [CloudFlux](http://CloudFlux.net) recently wrote a how-to on compiling Nginx and PHP-FPM (can be found [here](http://lukecarrier.me/?p=59)). Nginx is well known for being a high-performance HTTP server and reverse proxy, in fact this very website is running on-top of Nginx. A few websites you might know that run Nginx are:



	
  * [GitHub](http://GitHub.com)

	
  * [Wordpress](http://Wordpress.com)

	
  * [Ohloh](http://Ohloh.net)

	
  * [CloudFlux](http://CloudFlux.net)


These sites show how Nginx can be deployed in many high traffic configurations, GitHub being well know for the use of RoR, Wordpress the use of PHP etc. Whether you are deploying PHP under FPM, RoR under Passenger, static files or data from memcached Nginx can outperform many other web servers.

The main advantage to using Nginx is it's event-driven (asynchronous) architecture, this means that alongside providing high-performance there is a small predictable memory footprint. All the features make the server a good performer in all environments from single VPS systems to web clusters.

Some features you'll probably love:

	
  * Modules for load balancing

	
  * Direct memcached integration

	
  * Simple proxy configuration

	
  * Passenger integration

	
  * Ability to serve over 50,000 simultaneous connections

	
  * Statistics module

	
  * Low memory footprint

	
  * Clean simple to edit configuration files

	
  * Zero downtime configuration and binary updates

	
  * PCRE based rewrite rules


As you can see from [their site](http://wiki.nginx.org/NginxWhyUseIt) Nginx as a server is highly regarded and recommended. I'd suggest taking a look, having a play and revealing what it can do for you.
