---
layout: post
title: Apache process ID
tags:
- FOSS
- Knowledge base
- Linux
- Apache
- Logformat
- Process
---

Sometimes you need to know the Apache PID when trying to track down segfaults or CPU usage issues.

There is a very simple way to do this by altering your LogFormat, a command format to have is the CLF (common log format):

```text
%h %l %u %t \"%r\" %>s %b
```

To enable logging the pid just add the %P var like so:

```text
[%P] %h %l %u %t \"%r\" %>s %b
```
