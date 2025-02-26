---
layout: post
title: A very quick look at upgrading CentOS 6.5 to 7.0
tags:
- Linux
- How-to
- Update
---

After some serious [seeding action](http://seven.centos.org/2014/07/guess-whats-coming/) yesterday, today [CentOS 7](http://seven.centos.org/2014/07/release-announcement-for-centos-7x86_64/) was released!

As it happens I installed a new MSI Wind Box with CentOS 6.5 yesterday:

```bash
[root@pingu ~]# cat /etc/redhat-release
CentOS release 6.5 (Final)

[root@pingu ~]# uptime
 20:57:41 up 22:57,  1 user,  load average: 0.00, 0.04, 0.05
```

For the first time, there is a supported path for upgrading RHEL 6 to RHEL 7. Previously this would have been a reinstall.

Disclaimer: I would not attempt the following upgrade on a production server yet. The upgrade tools are still under development and not considered to be working properly (See the [development mailing list post](http://lists.centos.org/pipermail/centos-devel/2014-July/011277.html) if you want to help out).

Since I have a new box that's not anywhere near production, what the hell... lets try this out.

First update to the latest CentOS 6 release
-------------------------------------------

```bash
[root@pingu ~]# yum update
Loaded plugins: downloadonly, fastestmirror, security
Loading mirror speeds from cached hostfile
 * base: mirrors.coreix.net
 * epel: mirrors.mit.edu
 * extras: mirrors.coreix.net
 * updates: mirrors.clouvider.net
Setting up Update Process
Resolving Dependencies
--> Running transaction check
---> Package initscripts.x86_64 0:9.03.40-2.el6.centos.1 will be updated
---> Package initscripts.x86_64 0:9.03.40-2.el6.centos.2 will be an update
--> Finished Dependency Resolution

Dependencies Resolved

=============================================================================================================================
 Package                      Arch                    Version                                 Repository                Size
=============================================================================================================================
Updating:
 initscripts                  x86_64                  9.03.40-2.el6.centos.2                  updates                  940 k

Transaction Summary
=============================================================================================================================
Upgrade       1 Package(s)

Total download size: 940 k
Is this ok [y/N]: y
Downloading Packages:
initscripts-9.03.40-2.el6.centos.2.x86_64.rpm                                                         | 940 kB     00:00     
Running rpm_check_debug
Running Transaction Test
Transaction Test Succeeded
Running Transaction
  Updating   : initscripts-9.03.40-2.el6.centos.2.x86_64                                                                 1/2 
Jul  8 20:58:08 pingu yum[6374]: Updated: initscripts-9.03.40-2.el6.centos.2.x86_64
  Cleanup    : initscripts-9.03.40-2.el6.centos.1.x86_64                                                                 2/2 
  Verifying  : initscripts-9.03.40-2.el6.centos.2.x86_64                                                                 1/2 
  Verifying  : initscripts-9.03.40-2.el6.centos.1.x86_64                                                                 2/2 

Updated:
  initscripts.x86_64 0:9.03.40-2.el6.centos.2                                                                                

Complete!

[root@pingu ~]# yum upgrade
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: mirrors.clouvider.net
 * epel: mirror.vorboss.net
 * extras: centos.hyve.com
 * updates: centos.hyve.com
No packages marked for update
```


Install the upgrade utils
-------------------------

These are still very much in dev and may explode all the things.
See [http://lists.centos.org/pipermail/centos-devel/2014-July/011277.html](http://lists.centos.org/pipermail/centos-devel/2014-July/011277.html) for details.

```bash
[root@pingu ~]# yum localinstall http://dev.centos.org/centos/6/upg/x86_64/Packages/preupgrade-assistant-1.0.2-33.el6.x86_64.rpm http://dev.centos.org/centos/6/upg/x86_64/Packages/preupgrade-assistant-contents-0.5.13-1.el6.noarch.rpm http://dev.centos.org/centos/6/upg/x86_64/Packages/python-rhsm-1.9.7-1.el6.x86_64.rpm http://dev.centos.org/centos/6/upg/x86_64/Packages/redhat-upgrade-tool-0.7.22-1.el6.noarch.rpm
Loaded plugins: downloadonly, fastestmirror, security
Setting up Local Package Process
preupgrade-assistant-1.0.2-33.el6.x86_64.rpm                                                          | 438 kB     00:01     
Examining /var/tmp/yum-root-1lAuZF/preupgrade-assistant-1.0.2-33.el6.x86_64.rpm: preupgrade-assistant-1.0.2-33.el6.x86_64
Marking /var/tmp/yum-root-1lAuZF/preupgrade-assistant-1.0.2-33.el6.x86_64.rpm to be installed
Loading mirror speeds from cached hostfile
 * base: mirrors.coreix.net
 * epel: epel.mirror.constant.com
 * extras: mirrors.coreix.net
 * updates: mirrors.clouvider.net
preupgrade-assistant-contents-0.5.13-1.el6.noarch.rpm                                                 | 588 kB     00:01     
Examining /var/tmp/yum-root-1lAuZF/preupgrade-assistant-contents-0.5.13-1.el6.noarch.rpm: preupgrade-assistant-contents-0.5.13-1.el6.noarch
Marking /var/tmp/yum-root-1lAuZF/preupgrade-assistant-contents-0.5.13-1.el6.noarch.rpm to be installed
python-rhsm-1.9.7-1.el6.x86_64.rpm                                                                    |  99 kB     00:00     
Examining /var/tmp/yum-root-1lAuZF/python-rhsm-1.9.7-1.el6.x86_64.rpm: python-rhsm-1.9.7-1.el6.x86_64
Marking /var/tmp/yum-root-1lAuZF/python-rhsm-1.9.7-1.el6.x86_64.rpm to be installed
redhat-upgrade-tool-0.7.22-1.el6.noarch.rpm                                                           |  84 kB     00:00     
Examining /var/tmp/yum-root-1lAuZF/redhat-upgrade-tool-0.7.22-1.el6.noarch.rpm: 1:redhat-upgrade-tool-0.7.22-1.el6.noarch
Marking /var/tmp/yum-root-1lAuZF/redhat-upgrade-tool-0.7.22-1.el6.noarch.rpm to be installed
Resolving Dependencies
--> Running transaction check
---> Package preupgrade-assistant.x86_64 0:1.0.2-33.el6 will be installed
--> Processing Dependency: openscap(x86-64) >= 0.9.3-1 for package: preupgrade-assistant-1.0.2-33.el6.x86_64
--> Processing Dependency: pkgconfig(libpcre) for package: preupgrade-assistant-1.0.2-33.el6.x86_64
--> Processing Dependency: pkgconfig(libxml-2.0) for package: preupgrade-assistant-1.0.2-33.el6.x86_64
--> Processing Dependency: pkgconfig(libxslt) for package: preupgrade-assistant-1.0.2-33.el6.x86_64
---> Package preupgrade-assistant-contents.noarch 0:0.5.13-1.el6 will be installed
---> Package python-rhsm.x86_64 0:1.9.7-1.el6 will be installed
--> Processing Dependency: m2crypto for package: python-rhsm-1.9.7-1.el6.x86_64
--> Processing Dependency: python-simplejson for package: python-rhsm-1.9.7-1.el6.x86_64
---> Package redhat-upgrade-tool.noarch 1:0.7.22-1.el6 will be installed
--> Running transaction check
---> Package libxml2-devel.x86_64 0:2.7.6-14.el6_5.2 will be installed
--> Processing Dependency: zlib-devel for package: libxml2-devel-2.7.6-14.el6_5.2.x86_64
---> Package libxslt-devel.x86_64 0:1.1.26-2.el6_3.1 will be installed
--> Processing Dependency: libgcrypt-devel for package: libxslt-devel-1.1.26-2.el6_3.1.x86_64
---> Package m2crypto.x86_64 0:0.20.2-9.el6 will be installed
---> Package openscap.x86_64 0:1.0.8-1.el6_5 will be installed
---> Package pcre-devel.x86_64 0:7.8-6.el6 will be installed
---> Package python-simplejson.x86_64 0:2.0.9-3.1.el6 will be installed
--> Running transaction check
---> Package libgcrypt-devel.x86_64 0:1.4.5-11.el6_4 will be installed
--> Processing Dependency: libgpg-error-devel for package: libgcrypt-devel-1.4.5-11.el6_4.x86_64
---> Package zlib-devel.x86_64 0:1.2.3-29.el6 will be installed
--> Running transaction check
---> Package libgpg-error-devel.x86_64 0:1.7-4.el6 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

=============================================================================================================================
 Package                          Arch      Version              Repository                                             Size
=============================================================================================================================
Installing:
 preupgrade-assistant             x86_64    1.0.2-33.el6         /preupgrade-assistant-1.0.2-33.el6.x86_64             1.6 M
 preupgrade-assistant-contents    noarch    0.5.13-1.el6         /preupgrade-assistant-contents-0.5.13-1.el6.noarch    4.1 M
 python-rhsm                      x86_64    1.9.7-1.el6          /python-rhsm-1.9.7-1.el6.x86_64                       298 k
 redhat-upgrade-tool              noarch    1:0.7.22-1.el6       /redhat-upgrade-tool-0.7.22-1.el6.noarch              254 k
Installing for dependencies:
 libgcrypt-devel                  x86_64    1.4.5-11.el6_4       base                                                  118 k
 libgpg-error-devel               x86_64    1.7-4.el6            base                                                   14 k
 libxml2-devel                    x86_64    2.7.6-14.el6_5.2     updates                                               1.1 M
 libxslt-devel                    x86_64    1.1.26-2.el6_3.1     base                                                  561 k
 m2crypto                         x86_64    0.20.2-9.el6         base                                                  471 k
 openscap                         x86_64    1.0.8-1.el6_5        updates                                               2.9 M
 pcre-devel                       x86_64    7.8-6.el6            base                                                  318 k
 python-simplejson                x86_64    2.0.9-3.1.el6        base                                                  126 k
 zlib-devel                       x86_64    1.2.3-29.el6         base                                                   44 k

Transaction Summary
=============================================================================================================================
Install      13 Package(s)

Total size: 12 M
Total download size: 5.6 M
Installed size: 64 M
Is this ok [y/N]: y
Downloading Packages:
(1/9): libgcrypt-devel-1.4.5-11.el6_4.x86_64.rpm                                                      | 118 kB     00:00     
(2/9): libgpg-error-devel-1.7-4.el6.x86_64.rpm                                                        |  14 kB     00:00     
(3/9): libxml2-devel-2.7.6-14.el6_5.2.x86_64.rpm                                                      | 1.1 MB     00:00     
(4/9): libxslt-devel-1.1.26-2.el6_3.1.x86_64.rpm                                                      | 561 kB     00:00     
(5/9): m2crypto-0.20.2-9.el6.x86_64.rpm                                                               | 471 kB     00:00     
(6/9): openscap-1.0.8-1.el6_5.x86_64.rpm                                                              | 2.9 MB     00:01     
(7/9): pcre-devel-7.8-6.el6.x86_64.rpm                                                                | 318 kB     00:00     
(8/9): python-simplejson-2.0.9-3.1.el6.x86_64.rpm                                                     | 126 kB     00:00     
(9/9): zlib-devel-1.2.3-29.el6.x86_64.rpm                                                             |  44 kB     00:00     
-----------------------------------------------------------------------------------------------------------------------------
Total                                                                                        2.1 MB/s | 5.6 MB     00:02     
Running rpm_check_debug
Running Transaction Test
Transaction Test Succeeded
Running Transaction
  Installing : zlib-devel-1.2.3-29.el6.x86_64                                                                           1/13 
  Installing : libxml2-devel-2.7.6-14.el6_5.2.x86_64                                                                    2/13 
  Installing : libgpg-error-devel-1.7-4.el6.x86_64                                                                      3/13 
  Installing : libgcrypt-devel-1.4.5-11.el6_4.x86_64                                                                    4/13 
  Installing : libxslt-devel-1.1.26-2.el6_3.1.x86_64                                                                    5/13 
  Installing : openscap-1.0.8-1.el6_5.x86_64                                                                            6/13 
  Installing : m2crypto-0.20.2-9.el6.x86_64                                                                             7/13 
  Installing : python-simplejson-2.0.9-3.1.el6.x86_64                                                                   8/13 
  Installing : python-rhsm-1.9.7-1.el6.x86_64                                                                           9/13 
  Installing : pcre-devel-7.8-6.el6.x86_64                                                                             10/13 
  Installing : preupgrade-assistant-1.0.2-33.el6.x86_64                                                                11/13 
  Installing : 1:redhat-upgrade-tool-0.7.22-1.el6.noarch                                                               12/13 
  Installing : preupgrade-assistant-contents-0.5.13-1.el6.noarch                                                       13/13 
  Verifying  : libgcrypt-devel-1.4.5-11.el6_4.x86_64                                                                    1/13 
  Verifying  : pcre-devel-7.8-6.el6.x86_64                                                                              2/13 
  Verifying  : python-simplejson-2.0.9-3.1.el6.x86_64                                                                   3/13 
  Verifying  : python-rhsm-1.9.7-1.el6.x86_64                                                                           4/13 
  Verifying  : 1:redhat-upgrade-tool-0.7.22-1.el6.noarch                                                                5/13 
  Verifying  : preupgrade-assistant-contents-0.5.13-1.el6.noarch                                                        6/13 
  Verifying  : m2crypto-0.20.2-9.el6.x86_64                                                                             7/13 
  Verifying  : openscap-1.0.8-1.el6_5.x86_64                                                                            8/13 
  Verifying  : libgpg-error-devel-1.7-4.el6.x86_64                                                                      9/13 
  Verifying  : libxml2-devel-2.7.6-14.el6_5.2.x86_64                                                                   10/13 
  Verifying  : libxslt-devel-1.1.26-2.el6_3.1.x86_64                                                                   11/13 
  Verifying  : zlib-devel-1.2.3-29.el6.x86_64                                                                          12/13 
  Verifying  : preupgrade-assistant-1.0.2-33.el6.x86_64                                                                13/13 

Installed:
  preupgrade-assistant.x86_64 0:1.0.2-33.el6               preupgrade-assistant-contents.noarch 0:0.5.13-1.el6              
  python-rhsm.x86_64 0:1.9.7-1.el6                         redhat-upgrade-tool.noarch 1:0.7.22-1.el6                        

Dependency Installed:
  libgcrypt-devel.x86_64 0:1.4.5-11.el6_4  libgpg-error-devel.x86_64 0:1.7-4.el6     libxml2-devel.x86_64 0:2.7.6-14.el6_5.2 
  libxslt-devel.x86_64 0:1.1.26-2.el6_3.1  m2crypto.x86_64 0:0.20.2-9.el6            openscap.x86_64 0:1.0.8-1.el6_5         
  pcre-devel.x86_64 0:7.8-6.el6            python-simplejson.x86_64 0:2.0.9-3.1.el6  zlib-devel.x86_64 0:1.2.3-29.el6        

Complete!
```

Check for potential problems
----------------------------

```bash
[root@pingu ~]# preupg
Preupg tool doesn't do the actual upgrade.
Please ensure you have backed up your system and/or data in the event of a failed upgrade
 that would require a full re-install of the system from installation media.
Do you want to continue? y/n
y
Gathering logs used by preupgrade assistant:
All installed packages : 01/10 ...finished (time 00:00s)
All changed files      : 02/10 ...finished (time 01:09s)
Changed config files   : 03/10 ...finished (time 00:00s)
All users              : 04/10 ...finished (time 00:00s)
All groups             : 05/10 ...finished (time 00:00s)
Service statuses       : 06/10 ...finished (time 00:00s)
All installed files    : 07/10 ...finished (time 00:01s)
All local files        : 08/10 ...finished (time 00:01s)
All executable files   : 09/10 ...finished (time 00:00s)
RedHat signed packages : 10/10 ...finished (time 00:00s)
Assessment of the system, running checks / SCE scripts:
001/100 ...done    (Configuration Files to Review)
002/100 ...done    (File Lists for Manual Migration)
003/100 ...done    (Bacula Backup Software)
004/100 ...done    (MySQL configuration)
005/100 ...done    (Migration of the MySQL data stack)
006/100 ...done    (General changes in default MySQL implementation)
007/100 ...done    (PostgreSQL upgrade content)
008/100 ...done    (GNOME Desktop Environment underwent several design modifications in Red Hat Enterprise Linux 7 release)
009/100 ...done    (KDE Desktop Environment underwent several design modifications in Red Hat Enterprise Linux 7 release)
010/100 ...done    (several graphic drivers not supported in Red Hat Enterprise Linux 7)
011/100 ...done    (several input drivers not supported in Red Hat Enterprise Linux 7)
012/100 ...done    (several kernel networking drivers not available in Red Hat Enterprise Linux 7)
013/100 ...done    (several kernel storage drivers not available in Red Hat Enterprise Linux 7)
014/100 ...done    (Names, Options and Output Format Changes in arptables)
015/100 ...done    (BIND9 running in a chroot environment check.)
016/100 ...done    (BIND9 configuration compatibility check)
017/100 ...done    (Move dhcpd/dhcprelay arguments from /etc/sysconfig/* to *.service files)
018/100 ...done    (DNSMASQ configuration compatibility check)
019/100 ...done    (Dovecot configuration compatibility check)
020/100 ...done    (Compatibility Between iptables and ip6tables)
021/100 ...done    (Net-SNMP check)
022/100 ...done    (Squid configuration compatibility check)
023/100 ...done    (Reusable Configuration Files)
024/100 ...done    (VCS repositories)
025/100 ...done    (Added and extended options for BIND9 configuration)
026/100 ...done    (Added options in DNSMASQ configuration)
027/100 ...done    (Packages not signed by Red Hat)
028/100 ...done    (Obsoleted rpms)
029/100 ...done    (w3m not available in Red Hat Enterprise Linux 7)
030/100 ...done    (report incompatibilities between Red Hat Enterprise Linux 6 and 7 in qemu-guest-agent package)
031/100 ...done    (Removed options in coreutils binaries)
032/100 ...done    (Removed options in gawk binaries)
033/100 ...done    (Removed options in netstat binary)
034/100 ...done    (Removed options in quota tools)
035/100 ...done    (Removed rpms)
036/100 ...done    (Replaced rpms)
037/100 ...done    (GMP library incompatibilities)
038/100 ...done    (optional channel problems)
039/100 ...done    (package downgrades)
040/100 ...done    (restore custom selinux configuration)
041/100 ...done    (General)
042/100 ...done    (samba shared directories selinux)
043/100 ...done    (CUPS Browsing/BrowsePoll configuration)
044/100 ...done    (CVS Package Split)
045/100 ...done    (FreeRADIUS Upgrade Verification)
046/100 ...done    (httpd configuration compatibility check)
047/100 ...done    (bind-dyndb-ldap)
048/100 ...done    (Identity Management Server compatibility check)
049/100 ...done    (IPA Server CA Verification)
050/100 ...done    (NTP configuration)
051/100 ...done    (Information on time-sync.target)
052/100 ...done    (OpenLDAP /etc/sysconfig and data compatibility)
053/100 ...done    (OpenSSH sshd_config migration content)
054/100 ...done    (OpenSSH sysconfig migration content)
055/100 ...done    (Configuration for quota_nld service)
056/100 ...done    (Disk quota netlink message daemon moved into quota-nld package)
057/100 ...done    (SSSD compatibility check)
058/100 ...done    (Luks encrypted partition)
059/100 ...done    (Clvmd and cmirrord daemon management.)
060/100 ...done    (State of LVM2 services.)
061/100 ...done    (device-mapper-multipath configuration compatibility check)
062/100 ...done    (Removal of scsi-target-utils)
063/100 ...done    (Configuration for warnquota tool)
064/100 ...done    (Disk quota tool warnquota moved into quota-warnquota package)
065/100 ...done    (Check for Add-On availability)
066/100 ...done    (Architecture Support)
067/100 ...done    (Binary rebuilds)
068/100 ...done    (Debuginfo packages)
069/100 ...done    (Cluster and High Availablility)
070/100 ...done    (fix krb5kdc config file)
071/100 ...done    (File Systems, Partitions and Mounts Configuration Review)
072/100 ...done    (Read Only FHS directories)
073/100 ...done    (Red Hat Enterprise Linux Server variant)
074/100 ...done    (Sonamebumped libs)
075/100 ...done    (SonameKept Reusable Dynamic Libraries)
076/100 ...done    (Removed .so libs)
077/100 ...done    (In-place Upgrade Requirements for the /usr/ Directory)
078/100 ...done    (CA certificate bundles modified)
079/100 ...done    (Developer Tool Set packages)
080/100 ...done    (Hyper-V)
081/100 ...done    (Content for enabling and disabling services based on RHEL 6 system)
082/100 ...done    (Check for ethernet interface naming)
083/100 ...done    (User modification in /etc/rc.local and /etc/rc.d/rc.local)
084/100 ...done    (cgroups configuration compatibility check)
085/100 ...done    (Plugable authentication modules (PAM))
086/100 ...done    (Foreign Perl modules)
087/100 ...done    (Python 2.7.5)
088/100 ...done    (Ruby 2.0.0)
089/100 ...done    (SCL collections)
090/100 ...done    (Red Hat Subscription Manager)
091/100 ...done    (Red Hat Network Classic Unsupported)
092/100 ...done    (System kickstart)
093/100 ...done    (YUM)
094/100 ...done    (Check for usage of dangerous range of UID/GIDs)
095/100 ...done    (Incorrect usage of reserved UID/GIDs)
096/100 ...done    (NIS ypbind config files back-up)
097/100 ...done    (NIS Makefile back-up)
098/100 ...done    (NIS server maps check)
099/100 ...done    (NIS server MAXUID and MAXGID limits check)
100/100 ...done    (NIS server config file back-up)
Assessment finished (time 00:00s)
Result table with checks and their results for main contents:
------------------------------------------------------------------------------------------------------------------------------
|Configuration Files to Review                                                                               |notapplicable  |
|File Lists for Manual Migration                                                                             |notapplicable  |
|Bacula Backup Software                                                                                      |notapplicable  |
|MySQL configuration                                                                                         |notapplicable  |
|Migration of the MySQL data stack                                                                           |notapplicable  |
|General changes in default MySQL implementation                                                             |notapplicable  |
|PostgreSQL upgrade content                                                                                  |notapplicable  |
|GNOME Desktop Environment underwent several design modifications in Red Hat Enterprise Linux 7 release      |notapplicable  |
|KDE Desktop Environment underwent several design modifications in Red Hat Enterprise Linux 7 release        |notapplicable  |
|several graphic drivers not supported in Red Hat Enterprise Linux 7                                         |notapplicable  |
|several input drivers not supported in Red Hat Enterprise Linux 7                                           |notapplicable  |
|several kernel networking drivers not available in Red Hat Enterprise Linux 7                               |notapplicable  |
|several kernel storage drivers not available in Red Hat Enterprise Linux 7                                  |notapplicable  |
|Names, Options and Output Format Changes in arptables                                                       |notapplicable  |
|BIND9 running in a chroot environment check.                                                                |notapplicable  |
|BIND9 configuration compatibility check                                                                     |notapplicable  |
|Move dhcpd/dhcprelay arguments from /etc/sysconfig/* to *.service files                                     |notapplicable  |
|DNSMASQ configuration compatibility check                                                                   |notapplicable  |
|Dovecot configuration compatibility check                                                                   |notapplicable  |
|Compatibility Between iptables and ip6tables                                                                |notapplicable  |
|Net-SNMP check                                                                                              |notapplicable  |
|Squid configuration compatibility check                                                                     |notapplicable  |
|Reusable Configuration Files                                                                                |notapplicable  |
|VCS repositories                                                                                            |notapplicable  |
|Added and extended options for BIND9 configuration                                                          |notapplicable  |
|Added options in DNSMASQ configuration                                                                      |notapplicable  |
|Packages not signed by Red Hat                                                                              |notapplicable  |
|Obsoleted rpms                                                                                              |notapplicable  |
|w3m not available in Red Hat Enterprise Linux 7                                                             |notapplicable  |
|report incompatibilities between Red Hat Enterprise Linux 6 and 7 in qemu-guest-agent package               |notapplicable  |
|Removed options in coreutils binaries                                                                       |notapplicable  |
|Removed options in gawk binaries                                                                            |notapplicable  |
|Removed options in netstat binary                                                                           |notapplicable  |
|Removed options in quota tools                                                                              |notapplicable  |
|Removed rpms                                                                                                |notapplicable  |
|Replaced rpms                                                                                               |notapplicable  |
|GMP library incompatibilities                                                                               |notapplicable  |
|optional channel problems                                                                                   |notapplicable  |
|package downgrades                                                                                          |notapplicable  |
|restore custom selinux configuration                                                                        |notapplicable  |
|General                                                                                                     |notapplicable  |
|samba shared directories selinux                                                                            |notapplicable  |
|CUPS Browsing/BrowsePoll configuration                                                                      |notapplicable  |
|CVS Package Split                                                                                           |notapplicable  |
|FreeRADIUS Upgrade Verification                                                                             |notapplicable  |
|httpd configuration compatibility check                                                                     |notapplicable  |
|bind-dyndb-ldap                                                                                             |notapplicable  |
|Identity Management Server compatibility check                                                              |notapplicable  |
|IPA Server CA Verification                                                                                  |notapplicable  |
|NTP configuration                                                                                           |notapplicable  |
|Information on time-sync.target                                                                             |notapplicable  |
|OpenLDAP /etc/sysconfig and data compatibility                                                              |notapplicable  |
|OpenSSH sshd_config migration content                                                                       |notapplicable  |
|OpenSSH sysconfig migration content                                                                         |notapplicable  |
|Configuration for quota_nld service                                                                         |notapplicable  |
|Disk quota netlink message daemon moved into quota-nld package                                              |notapplicable  |
|SSSD compatibility check                                                                                    |notapplicable  |
|Luks encrypted partition                                                                                    |notapplicable  |
|Clvmd and cmirrord daemon management.                                                                       |notapplicable  |
|State of LVM2 services.                                                                                     |notapplicable  |
|device-mapper-multipath configuration compatibility check                                                   |notapplicable  |
|Removal of scsi-target-utils                                                                                |notapplicable  |
|Configuration for warnquota tool                                                                            |notapplicable  |
|Disk quota tool warnquota moved into quota-warnquota package                                                |notapplicable  |
|Check for Add-On availability                                                                               |notapplicable  |
|Architecture Support                                                                                        |notapplicable  |
|Binary rebuilds                                                                                             |notapplicable  |
|Debuginfo packages                                                                                          |notapplicable  |
|Cluster and High Availablility                                                                              |notapplicable  |
|fix krb5kdc config file                                                                                     |notapplicable  |
|File Systems, Partitions and Mounts Configuration Review                                                    |notapplicable  |
|Read Only FHS directories                                                                                   |notapplicable  |
|Red Hat Enterprise Linux Server variant                                                                     |notapplicable  |
|Sonamebumped libs                                                                                           |notapplicable  |
|SonameKept Reusable Dynamic Libraries                                                                       |notapplicable  |
|Removed .so libs                                                                                            |notapplicable  |
|In-place Upgrade Requirements for the /usr/ Directory                                                       |notapplicable  |
|CA certificate bundles modified                                                                             |notapplicable  |
|Developer Tool Set packages                                                                                 |notapplicable  |
|Hyper-V                                                                                                     |notapplicable  |
|Content for enabling and disabling services based on RHEL 6 system                                          |notapplicable  |
|Check for ethernet interface naming                                                                         |notapplicable  |
|User modification in /etc/rc.local and /etc/rc.d/rc.local                                                   |notapplicable  |
|cgroups configuration compatibility check                                                                   |notapplicable  |
|Plugable authentication modules (PAM)                                                                       |notapplicable  |
|Foreign Perl modules                                                                                        |notapplicable  |
|Python 2.7.5                                                                                                |notapplicable  |
|Ruby 2.0.0                                                                                                  |notapplicable  |
|SCL collections                                                                                             |notapplicable  |
|Red Hat Network Classic Unsupported                                                                         |notapplicable  |
|Red Hat Subscription Manager                                                                                |notapplicable  |
|System kickstart                                                                                            |notapplicable  |
|YUM                                                                                                         |notapplicable  |
|Check for usage of dangerous range of UID/GIDs                                                              |notapplicable  |
|Incorrect usage of reserved UID/GIDs                                                                        |notapplicable  |
|NIS ypbind config files back-up                                                                             |notapplicable  |
|NIS Makefile back-up                                                                                        |notapplicable  |
|NIS server maps check                                                                                       |notapplicable  |
|NIS server MAXUID and MAXGID limits check                                                                   |notapplicable  |
|NIS server config file back-up                                                                              |notapplicable  |
------------------------------------------------------------------------------------------------------------------------------
Tarball with results is stored here /root/preupgrade-results/preupg_results-140708210602.tar.gz .
The latest assessment is stored in directory /root/preupgrade .
Upload results to UI by command:
e.g. preupg -u http://127.0.0.1:8099/submit/ -r /root/preupgrade-results/preupg_results-*.tar.gz .
```

Hopefully everything looks ok and you can continue with the upgrade.

Run the upgrade
---------------

This tool basically downloads a custom kernel which does the actual upgrade.

This should work

```bash
redhat-upgrade-tool-cli http://mirror.bytemark.co.uk/centos/7/os/x86_64/
```

However it fails as below

```bash
[root@pingu ~]# redhat-upgrade-tool-cli --instrepo=http://mirror.bytemark.co.uk/centos/7/os/x86_64/ --network=7 --force --disablerepo=epel
setting up repos...
No upgrade available for the following repos: scl
.treeinfo                                                                                                                        | 1.1 kB     00:00     
getting boot images...
setting up update...
verify local files 100% [==============================================================================================================================]
(1/5): libdwarf-20130207-3.el7.x86_64.rpm                                                                                        | 109 kB     00:00     
(2/5): python-dns-1.10.0-5.el7.noarch.rpm                                                                                        | 220 kB     00:00     
(3/5): qpdf-libs-5.0.1-3.el7.x86_64.rpm                                                                                          | 328 kB     00:00     
(4/5): qrencode-libs-3.4.1-3.el7.x86_64.rpm                                                                                      |  50 kB     00:00     
(5/5): satyr-0.13-4.el7.x86_64.rpm                                                                                               | 500 kB     00:00     
warning: rpmts_HdrFromFdno: Header V3 RSA/SHA256 Signature, key ID f4a80eb5: NOKEY

Downloading failed: The GPG keys listed for the "CentOS-7.0 - Base" repository are already installed but they are not correct for this package.
Check that the correct key URLs are configured for this repository.
```

So I thought.... ok, for now we'll trust the packages and not check the GPG keys. However there also seems to be a problem in detecting preupg.
We ran preupg first, to check the system however the upgrade tool thinks we havn't and fails as below

```bash
[root@pingu ~]# redhat-upgrade-tool-cli --instrepo=http://mirror.bytemark.co.uk/centos/7/os/x86_64/ --network=7 --nogpgcheck
setting up repos...
base                                                                                                                             | 3.6 kB     00:00     
base/primary_db                                                                                                                  | 4.9 MB     00:01     
cmdline-instrepo                                                                                                                 | 3.6 kB     00:00     
cmdline-instrepo/primary_db                                                                                                      | 4.9 MB     00:01     
epel/metalink                                                                                                                    |  26 kB     00:00     
epel                                                                                                                             | 4.4 kB     00:00     
epel/primary_db                                                                                                                  | 6.2 MB     00:03     
extras                                                                                                                           | 2.9 kB     00:00     
extras/primary_db                                                                                                                |  15 kB     00:00     
updates                                                                                                                          | 2.9 kB     00:00     
updates/primary_db                                                                                                               | 1.4 MB     00:00     
No upgrade available for the following repos: scl
.treeinfo                                                                                                                        | 1.1 kB     00:00     
preupgrade-assistant has not been run.
To perform this upgrade, either run preupg or run redhat-upgrade-tool --force
```

I finally ended up disabling both GPG encryption and forcing the run (to skip the preupg)

```bash
[root@pingu ~]# redhat-upgrade-tool-cli --instrepo=http://mirror.bytemark.co.uk/centos/7/os/x86_64/ --network=7 --force --nogpgcheck
setting up repos...
No upgrade available for the following repos: scl
.treeinfo                                                                                                                        | 1.1 kB     00:00     
getting boot images...
setting up update...
verify local files 100% [==============================================================================================================================]
redhat_upgrade_tool.yum WARNING: Error loading productid metadata for base.
redhat_upgrade_tool.yum WARNING: Error loading productid metadata for epel.
redhat_upgrade_tool.yum WARNING: Error loading productid metadata for extras.
redhat_upgrade_tool.yum WARNING: Error loading productid metadata for updates.
testing upgrade transaction
rpm transaction 100% [=================================================================================================================================]
rpm install 100% [=====================================================================================================================================]
setting up system for upgrade
Finished. Reboot to start upgrade.
```

Booom - we're getting somewhere. Now we reboot into the kernel that has been installed.

```bash
[root@pingu ~]# reboot
```

At this point go get a cup of tea or something - the upgrade kernel basically downloads all the required packages from yum and then reboots into a working system.

The system booted up!
---------------------

Since there isn't a SCL repo for 7 yet - we need to clean this up

```bash
[root@pingu ~]# rm -f /etc/yum.repos.d/CentOS-SCL.repo
```

I also have EPEL installed on this server - lets fix that up.....

```bash
[root@pingu ~]# wget -O /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7 http://mirror.bytemark.co.uk/fedora/epel/RPM-GPG-KEY-EPEL-7
[root@pingu ~]# sed -i 's/6/7/g' /etc/yum.repos.d/epel.repo 
```

Update packages
---------------

At this point CentOS 7 should update cleanly

```bash
[root@pingu ~]# yum update
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: mirrors.clouvider.net
 * epel: mirror.vorboss.net
 * extras: centos.hyve.com
 * updates: centos.hyve.com
Resolving Dependencies
--> Running transaction check
---> Package epel-release.noarch 0:6-8 will be updated
---> Package epel-release.noarch 0:7-0.2 will be an update
---> Package htop.x86_64 0:1.0.1-2.el6 will be updated
---> Package htop.x86_64 0:1.0.3-3.el7 will be an update
---> Package python-crypto.x86_64 0:2.0.1-22.el6 will be updated
---> Package python-crypto.x86_64 0:2.6.1-1.el7 will be an update
---> Package python-paramiko.noarch 0:1.7.5-2.1.el6 will be updated
---> Package python-paramiko.noarch 0:1.11.3-1.el7 will be an update
---> Package python-simplejson.x86_64 0:2.0.9-3.1.el6 will be updated
---> Package python-simplejson.x86_64 0:3.3.3-1.el7 will be an update
--> Finished Dependency Resolution

Dependencies Resolved

========================================================================================================================================================
 Package                                    Arch                            Version                                 Repository                     Size
========================================================================================================================================================
Updating:
 epel-release                               noarch                          7-0.2                                   epel                           13 k
 htop                                       x86_64                          1.0.3-3.el7                             epel                           87 k
 python-crypto                              x86_64                          2.6.1-1.el7                             epel                          469 k
 python-paramiko                            noarch                          1.11.3-1.el7                            epel                          678 k
 python-simplejson                          x86_64                          3.3.3-1.el7                             epel                          171 k

Transaction Summary
========================================================================================================================================================
Upgrade  5 Packages

Total size: 1.4 M
Is this ok [y/d/N]: y
Downloading packages:
warning: /var/cache/yum/x86_64/7/epel/packages/epel-release-7-0.2.noarch.rpm: Header V3 RSA/SHA256 Signature, key ID 352c64e5: NOKEY
Retrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
Importing GPG key 0x352C64E5:
 Userid     : "Fedora EPEL (7) <epel@fedoraproject.org>"
 Fingerprint: 91e9 7d7c 4a5e 96f1 7f3e 888f 6a2f aea2 352c 64e5
 From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
Is this ok [y/N]: y
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
Warning: RPMDB altered outside of yum.
** Found 20 pre-existing rpmdb problem(s), 'yum check' output follows:
aiccu-2007.01.15-7.el6.x86_64 has missing requires of libgnutls.so.26()(64bit)
aiccu-2007.01.15-7.el6.x86_64 has missing requires of libgnutls.so.26(GNUTLS_1_4)(64bit)
cas-0.15-1.el6.1.noarch has missing requires of python(abi) = ('0', '2.6', None)
10:centos-release-SCL-6-5.el6.centos.x86_64 has missing requires of centos-release = ('0', '6', None)
cloog-ppl-0.15.7-1.2.el6.x86_64 has missing requires of libgmp.so.3()(64bit)
hal-info-20090716-3.1.el6.noarch has missing requires of hal >= ('0', '0.5.10', None)
openscap-1.0.8-1.el6_5.x86_64 has missing requires of libpcre.so.0()(64bit)
openscap-1.0.8-1.el6_5.x86_64 has missing requires of librpm.so.1()(64bit)
openscap-1.0.8-1.el6_5.x86_64 has missing requires of librpmio.so.1()(64bit)
ppl-0.10.2-11.el6.x86_64 has missing requires of libgmp.so.3()(64bit)
preupgrade-assistant-1.0.2-33.el6.x86_64 has missing requires of libpcre.so.0()(64bit)
preupgrade-assistant-1.0.2-33.el6.x86_64 has missing requires of librpm.so.1()(64bit)
preupgrade-assistant-1.0.2-33.el6.x86_64 has missing requires of librpmio.so.1()(64bit)
preupgrade-assistant-1.0.2-33.el6.x86_64 has missing requires of python(abi) = ('0', '2.6', None)
python-dns-1.11.1-2.el6.noarch has missing requires of python(abi) = ('0', '2.6', None)
python-iwlib-0.1-1.2.el6.x86_64 has missing requires of libpython2.6.so.1.0()(64bit)
python-iwlib-0.1-1.2.el6.x86_64 has missing requires of python(abi) = ('0', '2.6', None)
qpdf-libs-5.1.1-2.el6.x86_64 has missing requires of libpcre.so.0()(64bit)
1:readahead-1.5.6-2.el6.x86_64 has missing requires of upstart
satyr-0.14-1.el6.x86_64 has missing requires of librpm.so.1()(64bit)
  Updating   : python-crypto-2.6.1-1.el7.x86_64                                                                                                    1/10 
  Updating   : python-paramiko-1.11.3-1.el7.noarch                                                                                                 2/10 
  Updating   : python-simplejson-3.3.3-1.el7.x86_64                                                                                                3/10 
  Updating   : htop-1.0.3-3.el7.x86_64                                                                                                             4/10 
  Updating   : epel-release-7-0.2.noarch                                                                                                           5/10 
warning: /etc/yum.repos.d/epel.repo saved as /etc/yum.repos.d/epel.repo.rpmsave
  Cleanup    : python-paramiko-1.7.5-2.1.el6.noarch                                                                                                6/10 
  Cleanup    : epel-release-6-8.noarch                                                                                                             7/10 
  Cleanup    : python-crypto-2.0.1-22.el6.x86_64                                                                                                   8/10 
  Cleanup    : python-simplejson-2.0.9-3.1.el6.x86_64                                                                                              9/10 
  Cleanup    : htop-1.0.1-2.el6.x86_64                                                                                                            10/10 
  Verifying  : epel-release-7-0.2.noarch                                                                                                           1/10 
  Verifying  : python-crypto-2.6.1-1.el7.x86_64                                                                                                    2/10 
  Verifying  : htop-1.0.3-3.el7.x86_64                                                                                                             3/10 
  Verifying  : python-simplejson-3.3.3-1.el7.x86_64                                                                                                4/10 
  Verifying  : python-paramiko-1.11.3-1.el7.noarch                                                                                                 5/10 
  Verifying  : python-simplejson-2.0.9-3.1.el6.x86_64                                                                                              6/10 
  Verifying  : epel-release-6-8.noarch                                                                                                             7/10 
  Verifying  : python-crypto-2.0.1-22.el6.x86_64                                                                                                   8/10 
  Verifying  : python-paramiko-1.7.5-2.1.el6.noarch                                                                                                9/10 
  Verifying  : htop-1.0.1-2.el6.x86_64                                                                                                            10/10 

Updated:
  epel-release.noarch 0:7-0.2               htop.x86_64 0:1.0.3-3.el7    python-crypto.x86_64 0:2.6.1-1.el7    python-paramiko.noarch 0:1.11.3-1.el7   
  python-simplejson.x86_64 0:3.3.3-1.el7   

Complete!
```

Let's reboot once more to make sure things are all cleanly started...

```bash
[root@pingu ~]# reboot
```

Oh hey, it's a CentOS 7 box

```bash
[root@pingu ~]# cat /etc/redhat-release 
CentOS Linux release 7.0.1406 (Core) 
```

Roundup
-------
While it's too new to try out anywhere near production kit, for a set of tools that 'will need some patching to work properly' everything works pretty well.

Hopefully with a few minor tweaks the packages will land on the normal mirrors and upgrading boxes will be bliss.

Go play with [CentOS 7](http://seven.centos.org/) and try out some of the neat features in the 3.10 kernel.

As always, remember to [leave SELinux turned on](http://stopdisablingselinux.com/).