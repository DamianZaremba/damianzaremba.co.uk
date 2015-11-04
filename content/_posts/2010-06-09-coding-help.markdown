---
comments: true
layout: post
title: Coding Help
tags:
- Fun
- Python
---

So I'm currently working on a small project which will require authentication. Not really sure how to achieve what I want so here's a quick explanation for anyone if you want to share ideas:
Basic SQL definition:

```bash
mysql>; describe users;
+---------------------------+------------------+------+-----+---------+----------------+
| Field | Type | Null | Key | Default | Extra |
+---------------------------+------------------+------+-----+---------+----------------+
| id | int(11) | NO | PRI | NULL | auto_increment |
| username | varchar(500) | NO | | NULL | |
| password | varchar(100) | NO | | NULL | |
| salt | varchar(15) | NO | | NULL | |
| group_id | int(20) | NO | | NULL | |
| perm_login | set('Y','N','G') | NO | | G | |
+---------------------------+------------------+------+-----+---------+----------------+

mysql>; describe user_groups;
+---------------------------+---------------+------+-----+---------+----------------+
| Field | Type | Null | Key | Default | Extra |
+---------------------------+---------------+------+-----+---------+----------------+
| id | int(11) | NO | PRI | NULL | auto_increment |
| name | varchar(500) | NO | | NULL | |
| perm_login | set('Y','N') | NO | | Y | |
+---------------------------+---------------+------+-----+---------+----------------+
```

For permissions I want to do groups but then have the option to override them on a per user basis. All permissions fields are named perm_ , in the users table there are the Y/N as options then G, if the field is G then it uses the identical permissions field from the group table that the user is part of (group_id matches up with id in the user_groups table).

Basic SQL idea:

```bash
SELECT IF((`users`.`perm_test` = "G"), `user_groups`.`perm_test`, `users`.`perm_test`) AS allowed from users LEFT JOIN (`user_groups`) ON (`user_groups`.`id`=`users`.`group_id`) WHERE `users`.`username` = "testuser"
```

Now this works just fine however I can see issues mainly limitations to only being able to check one permission at a time. For 99% of the time this wouldn't be an issue for example when using the web interface/api there would be at a minimum of 2 calls and most of the time that would be it however in certain cases where you needed a full list there would be large issues. For a start getting a list of permissions would be highly recourse intensive and returning everyone would result in running something like the above for every permission. This may be a few hundred times per user per load.

I'm thinking of a way to move permissions into there own table then call them in a relational fashion but cannot think how to do this keeping the user/group system. Any ideas would be massively appreciated, for the moment db scheme changes are fine as this is very much a testing structure.

Speak to you soon :)
