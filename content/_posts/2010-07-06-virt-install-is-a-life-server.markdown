---
comments: true
layout: post
title: virt-install is a life server
tags:
- Fun
- General
- Kvm
- Virsh
---

So on one of my many servers that sit around doing nothing all day I have KVM installed, recently I've been playing about with this quite a bit. Still trying to figure out libvirt and the api to it which is like a black hole when it comes to documented functions as the Python classes (which is what I'm using) are generated pretty much straight off the C api stuff. Anyway as I was playing with that and rrdtool trying to make a cool graphing utility, I got bored with having to type loads to install a new dom. So thanks to the power of lighttpd to serve my kickstats, virt-install to do the leg work and the amazing thing called lvm I hacked up a bash script to do the hard work for me. Find it as follows:

```bash
#!/bin/bash
VG='/dev/virtual_disks'
KS_ADDR='http://192.168.100.1:5843/kickstarts'

case "$1" in
 centos)
 test -z $2 && exit 5
 test -z $3 && exit 5
 test -z $4 && exit 5
 if [ ! -z $5 ]; then
 extra="auto=true hostname=$4 domain='' ks=$KS_ADDR/centos_$5.ks"
 else
 extra="auto=true hostname=$4 domain=''"
 fi
 echo "Installing vm $4 with $2G disk and $3 ram allocation passing kernel arguments '$extra'"
 location='http://mirror.limestonenetworks.com/centos/5.5/os/x86_64/'
 lvcreate --name $4 --size $2G virtual_disks
 virt-install --connect qemu:///system --name $4 --ram $3 --hvm --file $VG/$4 --vnc --location=$location --noautoconsole --extra="$extra"
 virsh vncdisplay $4
 ;;
 fedora)
 test -z $2 && exit 5
 test -z $3 && exit 5
 test -z $4 && exit 5
 if [ ! -z $5 ]; then
 extra="auto=true hostname=$4 domain='' ks=$KS_ADDR/fedora_$5.ks"
 else
 extra="auto=true hostname=$4 domain=''"
 fi
 echo "Installing vm $4 with $2G disk and $3 ram allocation passing kernel arguments '$extra'"
 location='http://www.mirrorservice.org/sites/download.fedora.redhat.com/pub/fedora/linux/releases/13/Fedora/x86_64/os/'
 lvcreate --name $4 --size $2G virtual_disks
 virt-install --connect qemu:///system --name $4 --ram $3 --hvm --file $VG/$4 --vnc --location=$location --noautoconsole --extra="$extra"
 virsh vncdisplay $4
 ;;
 debian)
 test -z $2 && exit 5
 test -z $3 && exit 5
 test -z $4 && exit 5
 if [ ! -z $5 ]; then
 extra="auto=true hostname=$4 domain='' url=$KS_ADDR/debian_$5.ks"
 else
 extra="auto=true hostname=$4 domain=''"
 fi
 echo "Installing vm $4 with $2G disk and $3 ram allocation passing kernel arguments '$extra'"
 location='http://debian.intergenia.de/debian/dists/lenny/main/installer-amd64/'
 lvcreate --name $4 --size $2G virtual_disks
 virt-install --connect qemu:///system --name $4 --ram $3 --hvm --file $VG/$4 --vnc --location=$location --noautoconsole --extra="$extra"
 virsh vncdisplay $4
 ;;
 ubuntu)
 test -z $2 && exit 5
 test -z $3 && exit 5
 test -z $4 && exit 5
 if [ ! -z $5 ]; then
 extra="auto=true hostname=$4 domain='' url=$KS_ADDR/ubuntu_$5.ks"
 else
 extra="auto=true hostname=$4 domain=''"
 fi
 echo "Installing vm $4 with $2G disk and $3 ram allocation passing kernel arguments '$extra'"
 location="http://ubuntu.intergenia.de/ubuntu/dists/lucid/main/installer-amd64/"
 lvcreate --name $4 --size $2G virtual_disks
 virt-install --connect qemu:///system --name $4 --ram $3 --hvm --file $VG/$4 --vnc --location=$location --noautoconsole --extra="$extra"
 virsh vncdisplay $4
 ;;
 *)
 echo $"Usage: $0 {centos|fedora|debian|ubuntu} {Disk Size} {Ram Allocation} {Name} {Kickstart}"
 exit 2
 ;;
esac
```

Example usage:

```bash
[root@virtual1 ~]# ./vm_install.sh fedora 50 1024 CharityHosting1 basic
Installing vm CharityHosting1 with 50G disk and 1024 ram allocation passing kernel arguments 'auto=true hostname=CharityHosting1 domain='' ks=http://192.168.100.1:5843/kickstarts/fedora_basic.ks'
 Logical volume "CharityHosting1" created
Starting install...
Retrieving file .treeinfo... | 2.4 kB 00:00 ...
Retrieving file vmlinuz... | 6.7 MB 00:01 ...
Retrieving file initrd.img... | 57 MB 00:15 ...
Creating domain... | 0 B 00:00
Domain installation still in progress. You can reconnect to
the console to complete the installation process.
:0
```

The :0 thrown out at the end is the VNC port you can connect to which is pretty much the console on the vm. Bear in mind this does very very little validation, if a domain is already defined it will error out at that stage so your pretty safe but for example if you tell it to use a lvm that already exists it will error but carry on installing and wipe everything off :-)

2 Variables are as follows:
VG - This is the volume group the lvm's are going to reside in, the path is the format that you would use when calling lvcreate (duh)
KS_ADDR - This is the base http path to where the kick-starts are located, I personally use lighttpd to do this basic job. All kickstats have the format $distro"_"$name".ks"

The main work is done in the kick-start file, at the moment they are pretty static but eventually will be built dynamically out of a database so you can customize things like the root password, set static ips, install packages etc without having to write out a custom one.

The other thing I do along side this is make dnsmasq hand out "static" ips to servers because I use NAT for mapping the public to private addresses, this is because I only run a couple of production vms on that server (Such as the charity hosting servers and graphing server) and the rest are test servers with no need for public addresses.

Setup for dnsmasq/the script to make the assignments static are as follows:
DNSMASQ config:

```text
domain-needed
bogus-priv
strict-order
bind-interfaces
listen-address=192.168.100.1
except-interface=lo
dhcp-range=192.168.100.2,192.168.100.254
dhcp-lease-max=253
conf-dir=/etc/dnsmasq.d/
```

/root/fix_leases.py script (this runs every 2min)

```python
#!/usr/bin/python
import os
leases = {}
known_hosts = {}

if os.path.isfile('/var/lib/dnsmasq/dnsmasq.leases'):
 leases_fh = open('/var/lib/dnsmasq/dnsmasq.leases', 'r')
 for line in leases_fh.readlines():
 (time, mac, ip, hostname, clientid) = line.split(' ')
 leases[mac] = {
 'time': time,
 'ip': ip,
 'hostname': hostname,
 'client_id': clientid,
 }

leases_fh.close()

if os.path.isfile('/etc/dnsmasq.d/static_leases'):
 known_host_fh = open('/etc/dnsmasq.d/static_leases', 'r')
 for line in known_host_fh.readlines():
 if '#' in line:
 hostname = line.split('# Host')[1].strip()
 elif '=' in line:
 if hostname == '':
 hostname = 'Unknown'
 data = line.split('=')[1]
 (mac, ip) = data.split(',')
 known_hosts[mac] = {
 'ip': ip,
 'hostname': hostname,
 }
 hostname = ''

new_leases = {}
for mac in leases:
 if mac not in known_hosts:
 new_leases[mac] = leases[mac]

hosts = open('/etc/dnsmasq.d/static_leases', 'w')
for mac in known_hosts:
 ip = known_hosts[mac]['ip']
 hostname = known_hosts[mac]['hostname']
 hosts.write("# Host %s\ndhcp-host=%s,%s\n" % (hostname, mac, ip))

for mac in new_leases:
 ip = new_leases[mac]['ip']
 hostname = new_leases[mac]['hostname']
 hosts.write("# Host %s\ndhcp-host=%s,%s\n" % (hostname, mac, ip))

hosts.close()
print "Updating done :)"
os.system('service dnsmasq reload')
```

To make the above work I run dnsmasq outside of libvirt which is not the default (you have to enable dhcp in libvirt to do it) but it works pretty well for me, just have to clear the leases out every now and then ;-)

Until next time which may include some C as I'm currently working on a DNS management app for the iPhone (I will probably give up on it soon though due to time constrictions!)
