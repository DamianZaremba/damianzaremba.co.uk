---
comments: true
layout: post
title: Restricting access to EdgeCast nodes
tags:
- Apache
- Cat
- CDN
- Edgecast
- Linux
- Mod_rewrite
- Sed
---

Today one of our clients published a mix track that was around 140mb, hosted on their account. This was no problem until he started to get hundreds of people downloading the mix which resulted in silly amounts of bandwidth being used.

We quickly had to move him on to the CDN to ensure the traffic impact wasn't affecting performance for him or others as well as reduce his bandwidth charges substantially.

Once the CDN was all set up and the content pushed out onto the nodes we started to send traffic over.

Due to the impact of social media and people linking directly to the content we had to devise a plan to enable access to the content for the CDN but redirect anyone linking directly to the CDNified subdomain.

In comes mod_rewrite. Now it appears EdgeCast don't publish their IP ranges in any format that helps my sanity, they are in fact published in a html table. To find them, login to my.edgecast.com, browse to HTTP Large, click on Customer Origin and scroll down to the bottom.

Linux to the rescue! First we just copy the list into a file:

```bash
[damian@finnix ~]$ cat > edgecast_ranges
Asia Hong Kong 117.18.234.0 - 117.18.234.255
110.232.176.0 - 110.232.176.255
Asia Singapore 117.18.236.0 - 117.18.236.255
46.22.71.0 - 46.22.71.255
Asia Tokyo 117.18.233.0 - 117.18.233.255
110.232.177.0 - 110.232.177.255
Australia Sydney 117.18.235.0 - 117.18.235.255
110.232.179.0 - 110.232.179.255
Europe Amsterdam 93.184.208.0 - 93.184.208.255
93.184.209.0 - 93.184.209.255
93.184.217.0 - 93.184.217.255
46.22.70.0 - 46.22.70.255
46.22.72.0 - 46.22.73.255
Europe Frankfurt 72.21.89.0 - 72.21.89.255
93.184.212.0 - 93.184.212.255
93.184.213.0 - 93.184.213.255
Europe London 72.21.90.0 - 72.21.90.255
93.184.210.0 - 93.184.210.255
93.184.211.0 - 93.184.211.255
46.22.74.0 - 46.22.75.255
Europe Madrid 46.22.66.0 - 46.22.67.255
Europe Paris 93.184.214.0 - 93.184.214.255
North America Ashburn 72.21.83.0 - 72.21.83.255
68.232.36.0 - 68.232.36.255
North America Atlanta 72.21.88.0 - 72.21.88.255
72.21.93.0 - 72.21.93.255
North America Chicago 72.21.87.0 - 72.21.87.255
68.232.38.0 - 68.232.38.255
North America Dallas 72.21.86.0 - 72.21.86.255
68.232.39.0 - 68.232.39.255
North America Los Angeles 72.21.84.0 - 72.21.84.255
68.232.40.0 - 68.232.40.255
72.21.94.0 - 72.21.94.255
93.184.218.0 - 93.184.218.255
46.22.69.0 - 46.22.69.255
North America Miami 46.22.64.0 - 46.22.65.255
North America New York 72.21.95.0 - 72.21.95.255
68.232.37.0 - 68.232.37.255
North America San Jose
North America San Jose 72.21.82.0 - 72.21.82.255
68.232.41.0 - 68.232.41.255
North America Seattle 72.21.85.0 - 72.21.85.255
Other N/A 72.21.80.0 - 72.21.80.255
72.21.81.0 - 72.21.81.255
72.21.91.0 - 72.21.91.255
72.21.92.0 - 72.21.92.255
117.18.232.0 - 117.18.232.255
93.184.221.0 - 93.184.221.255
93.184.220.0 - 93.184.220.255
93.184.219.0 - 93.184.219.255
117.18.237.0 - 117.18.237.255
93.184.215.0 - 93.184.215.255
93.184.216.0 - 93.184.216.255
68.232.32.0 - 68.232.32.255
68.232.33.0 - 68.232.33.255
68.232.34.0 - 68.232.34.255
68.232.35.0 - 68.232.35.255
68.232.42.0 - 68.232.42.255
68.232.43.0 - 68.232.43.255
68.232.44.0 - 68.232.44.255
68.232.45.0 - 68.232.45.255
68.232.46.0 - 68.232.46.255
68.232.47.0 - 68.232.47.255
93.184.222.0 - 93.184.222.255
93.184.223.0 - 93.184.223.255
110.232.178.0 - 110.232.178.255
117.18.237.0 - 117.18.237.255
117.18.238.0 - 117.18.238.255
117.18.239.0 - 117.18.239.255
```

Next we need to clear out all the names etc that are randomly dumped in the file:

```bash
[damian@finnix ~]$ sed -i 's/^.*\s.*\s//g' edgecast_ranges # Get rid of place names
[damian@finnix ~]$ sed -i '/^\s*$/d' edgecast_ranges # Get rid of blank lines
```

Now let's actually turn these IP ranges into something Apache can understand (they are all /24's so we can cheat):

```bash
[damian@finnix ~]$ sed -i 's/^/RewriteCond %{REMOTE_ADDR} !^/g' edgecast_ranges # Add the rewrite cond
[damian@finnix ~]$ sed -i 's/\.255$/.*$/g' edgecast_ranges # Add the wildcard
```

Now let's create the actual htaccess file:

```bash
[damian@finnix ~]$ echo 'RewriteEngine On' >> .htaccess
[damian@finnix ~]$ cat edgecast_ranges >> .htaccess
[damian@finnix ~]$ echo 'RewriteRule ^downloads/(.*)$ http://media.example.com/$1 [R,L]' >> .htaccess
```

You should end up with something looking like this:

```bash
RewriteEngine On
RewriteCond %{REMOTE_ADDR} !^117.18.234.*$
RewriteCond %{REMOTE_ADDR} !^110.232.176.*$
RewriteCond %{REMOTE_ADDR} !^117.18.236.*$
RewriteCond %{REMOTE_ADDR} !^46.22.71.*$
RewriteCond %{REMOTE_ADDR} !^117.18.233.*$
RewriteCond %{REMOTE_ADDR} !^110.232.177.*$
RewriteCond %{REMOTE_ADDR} !^117.18.235.*$
RewriteCond %{REMOTE_ADDR} !^110.232.179.*$
RewriteCond %{REMOTE_ADDR} !^93.184.208.*$
RewriteCond %{REMOTE_ADDR} !^93.184.209.*$
RewriteCond %{REMOTE_ADDR} !^93.184.217.*$
RewriteCond %{REMOTE_ADDR} !^46.22.70.*$
RewriteCond %{REMOTE_ADDR} !^46.22.72.*$
RewriteCond %{REMOTE_ADDR} !^72.21.89.*$
RewriteCond %{REMOTE_ADDR} !^93.184.212.*$
RewriteCond %{REMOTE_ADDR} !^93.184.213.*$
RewriteCond %{REMOTE_ADDR} !^72.21.90.*$
RewriteCond %{REMOTE_ADDR} !^93.184.210.*$
RewriteCond %{REMOTE_ADDR} !^93.184.211.*$
RewriteCond %{REMOTE_ADDR} !^46.22.74.*$
RewriteCond %{REMOTE_ADDR} !^46.22.66.*$
RewriteCond %{REMOTE_ADDR} !^93.184.214.*$
RewriteCond %{REMOTE_ADDR} !^72.21.83.*$
RewriteCond %{REMOTE_ADDR} !^68.232.36.*$
RewriteCond %{REMOTE_ADDR} !^72.21.88.*$
RewriteCond %{REMOTE_ADDR} !^72.21.93.*$
RewriteCond %{REMOTE_ADDR} !^72.21.87.*$
RewriteCond %{REMOTE_ADDR} !^68.232.38.*$
RewriteCond %{REMOTE_ADDR} !^72.21.86.*$
RewriteCond %{REMOTE_ADDR} !^68.232.39.*$
RewriteCond %{REMOTE_ADDR} !^72.21.84.*$
RewriteCond %{REMOTE_ADDR} !^68.232.40.*$
RewriteCond %{REMOTE_ADDR} !^72.21.94.*$
RewriteCond %{REMOTE_ADDR} !^93.184.218.*$
RewriteCond %{REMOTE_ADDR} !^46.22.69.*$
RewriteCond %{REMOTE_ADDR} !^46.22.64.*$
RewriteCond %{REMOTE_ADDR} !^72.21.95.*$
RewriteCond %{REMOTE_ADDR} !^68.232.37.*$
RewriteCond %{REMOTE_ADDR} !^72.21.82.*$
RewriteCond %{REMOTE_ADDR} !^68.232.41.*$
RewriteCond %{REMOTE_ADDR} !^72.21.85.*$
RewriteCond %{REMOTE_ADDR} !^72.21.80.*$
RewriteCond %{REMOTE_ADDR} !^72.21.81.*$
RewriteCond %{REMOTE_ADDR} !^72.21.91.*$
RewriteCond %{REMOTE_ADDR} !^72.21.92.*$
RewriteCond %{REMOTE_ADDR} !^117.18.232.*$
RewriteCond %{REMOTE_ADDR} !^93.184.221.*$
RewriteCond %{REMOTE_ADDR} !^93.184.220.*$
RewriteCond %{REMOTE_ADDR} !^93.184.219.*$
RewriteCond %{REMOTE_ADDR} !^117.18.237.*$
RewriteCond %{REMOTE_ADDR} !^93.184.215.*$
RewriteCond %{REMOTE_ADDR} !^93.184.216.*$
RewriteCond %{REMOTE_ADDR} !^68.232.32.*$
RewriteCond %{REMOTE_ADDR} !^68.232.33.*$
RewriteCond %{REMOTE_ADDR} !^68.232.34.*$
RewriteCond %{REMOTE_ADDR} !^68.232.35.*$
RewriteCond %{REMOTE_ADDR} !^68.232.42.*$
RewriteCond %{REMOTE_ADDR} !^68.232.43.*$
RewriteCond %{REMOTE_ADDR} !^68.232.44.*$
RewriteCond %{REMOTE_ADDR} !^68.232.45.*$
RewriteCond %{REMOTE_ADDR} !^68.232.46.*$
RewriteCond %{REMOTE_ADDR} !^68.232.47.*$
RewriteCond %{REMOTE_ADDR} !^93.184.222.*$
RewriteCond %{REMOTE_ADDR} !^93.184.223.*$
RewriteCond %{REMOTE_ADDR} !^110.232.178.*$
RewriteCond %{REMOTE_ADDR} !^117.18.237.*$
RewriteCond %{REMOTE_ADDR} !^117.18.238.*$
RewriteCond %{REMOTE_ADDR} !^117.18.239.*$
RewriteRule ^downloads/(.*)$ http://media.example.com/$1 [R,L]
```

If you browse to http://example.com/downloads/ you should be redirected to http://media.example.com/ unless you are coming from an Edgecast IP range.

Now you can go back to reading slashdot ;)
