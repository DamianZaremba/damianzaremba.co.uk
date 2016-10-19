---
comments: true
layout: post
title: GNS3 crash after upgrade
tags:
- FOSS
- General
- How-to
- Python
---

Recently I upgraded the GNS3 version on my Macbook and afterwards,
immediately after trying to open the app it would close.

Attempting to start the processes on the command line revealed some
additional information:

* `/Applications/GNS3.app/Contents/MacOS/gns3server` was working as expected
* `/Applications/GNS3.app/Contents/MacOS/gns3shell` also was working as expected
* `/Applications/GNS3.app/Contents/MacOS/gns3` was crashing with `ImportError: No module named 'gns3.main'`
* `/Applications/GNS3.app/Contents/MacOS/Python` was not executable

Having also recently updated [homebrew](http://brew.sh/) and upon deciding to google the error,
a good 30min was wasted tracking down possible python path issues.

As it turns out, GNS3 on OSX is built using [cx_Freeze](https://cx-freeze.readthedocs.io/en/latest/),
ensuring there are minimal dependencies on the system.

So, what is the problem? To find that out, lets look at the full output:

```bash
m00m00:~ damian$ /Applications/GNS3.app/Contents/MacOS/gns3
Application frozen with cx_Freeze
GNS3 GUI version 1.5.2
Copyright (c) 2007-2016 GNS3 Technologies Inc.
INFO logger.py:107 Log level: INFO
INFO servers.py:689 New remote server connection http://192.168.95.128:8000 registered
INFO local_config.py:294 Section LocalServer has changed. Saving configuration
INFO local_config.py:190 Configuration save to /Users/damian/.config/GNS3/gns3_gui.conf
****** Exception detected, traceback information saved in /Users/damian/.config/GNS3/exceptions.log ******

PLEASE REPORT ON https://www.gns3.com

Traceback (most recent call last):
  File "/Users/gns3/Jenkins/workspace/Release MacOSX/OSX/../boot.py", line 35, in <module>
  File "/usr/local/Cellar/python3/3.5.1/Frameworks/Python.framework/Versions/3.5/lib/python3.5/importlib/__init__.py", line 126, in import_module
  File "<frozen importlib._bootstrap>", line 986, in _gcd_import
  File "<frozen importlib._bootstrap>", line 969, in _find_and_load
  File "<frozen importlib._bootstrap>", line 956, in _find_and_load_unlocked
ImportError: No module named 'gns3.main'

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/Users/gns3/Jenkins/workspace/Release MacOSX/OSX/../boot.py", line 46, in <module>
  File "gns3-gui/gns3/main.py", line 281, in <module>
  File "gns3-gui/gns3/main.py", line 244, in main
  File "./gns3-gui/gns3/main_window.py", line 109, in __init__
  File "./gns3-gui/gns3/ui/main_window_ui.py", line 188, in setupUi
  File "./gns3-gui/gns3/server_summary_view.py", line 101, in __init__
  File "./gns3-gui/gns3/servers.py", line 875, in instance
  File "./gns3-gui/gns3/servers.py", line 74, in __init__
  File "./gns3-gui/gns3/servers.py", line 268, in _loadSettings
  File "./gns3-gui/gns3/servers.py", line 277, in _saveSettings
  File "./gns3-gui/gns3/servers.py", line 277, in <listcomp>
KeyError: 'url'
```

As it turns out, the issue appears to be in loading the config file.

There is no 'url' key within the config file I have on disk, so let's remove it and try again.

Same problem, [strace](https://linux.die.net/man/1/strace)...err [dtruss](https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/dtruss.1m.html) to the rescue!

```bash
m00m00:~ damian$ sudo dtruss /Applications/GNS3.app/Contents/MacOS/gns3

Application frozen with cx_Freeze
GNS3 GUI version 1.5.2
Copyright (c) 2007-2016 GNS3 Technologies Inc.
[....]
stat64("/Users/damian/.config/GNS3/GNS3.ini\0", 0x7FFF57315A68, 0x0)                = 0 0
[....]
```

As some of you may have noticed in the stacktrace, the config that is being correctly saved is `/Users/damian/.config/GNS3/gns3_gui.conf`, yet we're loading `/Users/damian/.config/GNS3/GNS3.ini`.

We have 2 configs?

```bash
m00m00:~ damian$ ls /Users/damian/.config/GNS3/
GNS3.ini          base_configs/     exceptions.log    gns3_gui.log      gns3_server.log
GNS3_client.log   exception.log     gns3_gui.conf     gns3_server.conf
m00m00:~ damian$ ls /Users/damian/.config/GNS3/
gns3_gui.conf        gns3_gui.pid        gns3_server.log
gns3_gui.log        gns3_server.conf
```

![](http://weknowmemes.com/wp-content/uploads/2011/12/i-have-no-memory-of-this-place.jpg)

Let's clear up these old config entries and start with a clean setup

```bash
m00m00:~ damian$ rm -rf ~/.config/gns3.net ~/.config/GNS3
```

And it works!

Perhaps this was handled in an intermediary release I missed,
but it comes across as a pretty poor compatibility issue, especially considering
the error only being visible on the command line.
