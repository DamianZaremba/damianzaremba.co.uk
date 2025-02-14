---
layout: post
title: Changing the MySQL client prompt
tags:
- FOSS
- Knowledge base
- Linux
- Mysql
- My.cnf
- Mysql
- Prompt
---

It is quite easy to get lost in MySQL when working between a lot of databases.

While you can find out which database you are in, it soon becomes quite irritating having to type

```bash
mysql> select database();

+------------------+
| database() |
+------------------+
| test_database |
+------------------+
1 row in set (0.01 sec)
```

The simplest way to solve this and make life easier, is to change the prompt to include the info!
Simple edit the [mysql] section of your my.cnf file and add the prompt option:

```bash
[client]
host = "localhost"
user = "mehuser"
pass = "someubersecurepassword"
prompt=mysql [\\u@\\h - \\d]>
```

Now when you use the client the prompt will show mysql [user@host - database]>:

```bash
mysql [test1@localhost - test_database]>
```

No more getting confused! If you don't have access to /etc/my.cnf then use ~/.my.cnf, I usually stick the connection details in there as well - then you can have huge passwords and never have to type/remember them:

```bash
[client]
host = "localhost"
user = "mehuser"
pass = "someubersecurepassword"
prompt=mysql [\\u@\\h - \\d]>
```
