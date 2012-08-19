---
comments: true
layout: post
title: Wordpress plugin
tags:
- Fun
- General
---

Hi to anyone that reads this.

I wasn’t going to post about this as it is not something I think it neat or I should be proud of, but I seem to be getting a few links though to this blog so I thought I should post something!

I recentlt was re-designing (if you can call it that) this blog and was looking to integrate mint. The plugin utilizes;
* admin_menu & admin_notices wordpress actions for displaying/allowing editing of settings.
* wp_head wordpress action for outputting the mint integration code into the header.
* rss_head, rss2_head, atom_header & the_permalink_rss wordpress actions for integration of birdfeeder.

The script goes out of its way to ensure it does not break html or xml output due to php errors.

The plugin can be downloaded from [here](http://wordpress.org/extend/plugins/mint/) and offers mint integration into the header (tracking code) & bird feeder integration for the rss feeds.
Both of these are optional and can be configured from the settings page.

The requirements are;

* PHP
* A working wordpress install (use the latest :3)
* A working mint install (on the same server – due to how birdfeeder integration works this has to be the case without major hacking of the plugin)
* The ability to read the error messages and fill out the settings page

Why mint? It has an awesome AJAX interface for viewing stats, remains fast on pretty large sites, supports plugins and best of all the code isn’t encoded in any way.

The downside is a 30$ license per site but this is supporting an awesome developer who keeps the product updated. Because the code is open you can also hack it to your needs and release any plugins/themes back into the community.

License? It is licensed under GPLv3 and I take no responsibility if it breaks your site ;) But I might fix it if you tell me it broke something (I’m running it in production and have noticed no issues in testing or live use).

Developing for wordpress was easier than I first though – the action hooks makes life very easy even if it is a little tricky to figure out how plugins are stored and tracked in extend it’s self. I don’t think I’ll be making a habit of developing plugins but will feel happy hacking them up as needed.
