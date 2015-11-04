---
comments: true
layout: post
title: Centos 6.0 kickstart partitioning issue
tags:
- FOSS
- Anaconda
- Kickstart
---

In my kickstart files I "cheat" on disk sizes and let them grow automatically rather than figuring out the size, setting it then having to manually expand it later.

To do this I use the following in my kickstarts:

```text
%include /tmp/partinfo

%pre
# Get disks
set $(list-harddrives)
let numd=$#/2
disk1=$1
disk2=$3

# Build partinfo file
cat > /tmp/partinfo <part /boot --fstype ext4 --size=512 --ondisk=$disk1
part pv.2 --size=0 --grow --ondisk=$disk1

volgroup VolGroup00 --pesize=32768 pv.2
logvol / --fstype ext4 --name=LogVol00 --vgname=VolGroup00 --size=1024 --grow
logvol swap --fstype swap --name=LogVol01 --vgname=VolGroup00 --size=512 --grow --maxsize=1024
EOF
```

Basically in the pre section of the kickstart I write out the disk partition stuff using some bash/list-harddrives into a file. This is then included in the main body of the kickstart (due to the pre code being run before the main stuff this works fine).

Now the issue I had with Centos6 was an error getting throw by Anaconda "Partition requires a size specification".

It looks like this is caused by a change in the kickstart script which checks if the size is set (pd.size = None was changed to not self.size).

The simplest way to fix this is just to make --size=1 (lets face it, your minimum partition size isn't going to be smaller 1mb!).

Apart from some other little things like removing the editors, text-internet etc groups out of the kickstart file and downloading the new vmlinuz/initrd.img files everything worked fine first time.

Now to wait for the mirror to finish syncing so I can get some fast installs going (=
