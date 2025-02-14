---
layout: post
title: MySQL uses no space on cPanel
tags:
- Cpanel
- Knowledge base
- Linux
- Cpanel.config
- Mysql
---

For some reason cPanel decided to start by default excluding sql databases from the disk usage stats.

To enable these again edit the /var/cpanel/cpanel.config file and change disk_usage_include_sqldbs from 0 to 1.

After running /scripts/update_db_cache you should now see disk stats in the interface once again.

Note: SQL database usage stats can be quite intensive to calculate so you may want to leave it off.
