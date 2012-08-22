---
comments: true
layout: post
title: Recovering deleted files from the handlers in /proc/
tags:
- Apache
- Knowledge base
- Linux
- Apache
- Deleted files
- File recovery
- Proc
---

On compromised servers it is very common for the exploit to delete its self/logs to try and hide its presence.

Even though the executable may be removed from the filesystem as the process is forked from apache the parent process will still have file handlers open.

This will allow you to recover log files/executables as long as you do not kill the process.

To recover the files use the following steps:

1. Find the PID of the process with the open file handlers (use lsof)
2. cd /proc//fd where  is what you found using lsof above
3. ls -lra and you should see a load of broken symlinks (red)
4. Copy the file using cp into another directory
