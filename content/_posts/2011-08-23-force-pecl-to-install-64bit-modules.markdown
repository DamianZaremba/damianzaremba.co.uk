---
comments: true
layout: post
title: Force PECL to install 64bit modules
tags:
- Knowledge Base
- Linux
- PHP
- pecl
- php
- x64
---

To ensure PECL installs 64bit modules you need to install the 64bit php-devel package.

On a RHEL system perform the following:
1) pecl uninstall 
2) yum remove php-devel.i386
3) yum install php-devel.x86_64
4) pecl install 

Any further modules will now be 64bit.
