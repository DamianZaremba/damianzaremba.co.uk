---
comments: true
layout: post
title: Changing WordPress tag to category?
tags:
- FOSS
- How-to
- Software
- Wordpress
- Category to tag
- Mysql
- Tag to category
- Wordpress
---

While there appears to be plugins for converting categories to tags, I can't for the life of me find one to convert tags to categories.

After a quick poke around in the database it seem quite simple to convert between the two.
Note: This /seems/ to work however it might kick you in the face and break stuff.

First find out your "term" id (category or tag):

```bash
mysql> SELECT * FROM `terms` WHERE `slug` = 'snippets';
+---------+----------+----------+------------+
| term_id | name | slug | term_group |
+---------+----------+----------+------------+
| 171 | Snippets | snippets | 0 |
+---------+----------+----------+------------+
1 row in set (0.00 sec)
```

Now look in the taxonomy table and find out its details:

```bash
mysql> SELECT * FROM `term_taxonomy` WHERE `term_id` = 171;
+------------------+---------+----------+-------------+--------+-------+
| term_taxonomy_id | term_id | taxonomy | description | parent | count |
+------------------+---------+----------+-------------+--------+-------+
| 174 | 171 | post_tag | | 0 | 17 |
+------------------+---------+----------+-------------+--------+-------+
1 row in set (0.00 sec)
```


As you can see it is currently a "post_tag".

To change it to a category change the "taxonomy" field to "category":

```bash
mysql> UPDATE `term_taxonomy` SET `taxonomy` = 'category' WHERE `term_id` = 171;
Query OK, 1 row affected (0.00 sec)
Rows matched: 1 Changed: 1 Warnings: 0
```

Or to change it from a category to a tag then change the "taxonomy" field to "post_tag":

```bash
mysql> UPDATE `term_taxonomy` SET `taxonomy` = 'post_tag' WHERE `term_id` = 171;
Query OK, 1 row affected (0.02 sec)
Rows matched: 1 Changed: 1 Warnings: 0
```

