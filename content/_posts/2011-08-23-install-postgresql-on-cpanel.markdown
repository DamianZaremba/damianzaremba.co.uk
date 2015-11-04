---
comments: true
layout: post
title: Install PostgreSQL on cPanel
tags:
- Cpanel
- Knowledge base
- Postgresql
- Cpanel
- Hack
- Pgsql
- Postgresql
---

To install PostgreSQL on a cPanel server you can perform the following:

1. Run /scripts/installpostgres
2. Go to SQL services -> Postgre config and click Install config
3. Configure a root password for Postgre
4 Enable Postgre with chkconfig postgres on; service postgres restart

Now you would think that is it, right?
Well if you already have users on the box you will now need to add them into postgre otherwise they will have no access.

You can add them with the following script:

```text
for user in $(ls /var/cpanel/users);
do
 su postgres -c "createuser -S -D -R $user";
done
```
