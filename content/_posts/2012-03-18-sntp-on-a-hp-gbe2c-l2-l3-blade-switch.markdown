---
layout: post
title: NTP on a HP GbE2c L2/L3 Blade Switch
tags:
- How-to
- Hp
- Network
- Ntp
- Sntp
- Switch
---

To configure a HP GbE2c L2/L3 Ethernet Blade Switch for HP c-Class BladeSystem, you need to use NTP with the following syntax.

```text
ntp enable 
ntp timezone 0
ntp primary-server <ip>
ntp secondary-server <ip>
```

The first line enables NTP, the second tells the switch to use GMT+0 and the third/forth tells the switch which servers to sync with.

This needs to be done in configure mode which can be got into via enable mode.

```text
enable
configure
```

Now ensure the switch timezone is correct, the command for this is slightly obnoxious. Below is an example of setting it to GB:

```text
Switch(config)# system timezone 
Please identify a location so that time zone rules can be set correctly.
Please select a continent or ocean.
 1) Africa
 2) Americas
 3) Antarctica
 4) Arctic Ocean
 5) Asia
 6) Atlantic Ocean
 7) Australia
 8) Europe
 9) Indian Ocean
10) Pacific Ocean
11) None - disable timezone setting
#? 8
Please select a country.
 1) Albania               16) Gibraltar     31) Poland
 2) Andorra               17) Greece        32) Portugal
 3) Austria               18) Hungary       33) Romania
 4) Belarus               19) Ireland       34) Russia
 5) Belgium               20) Italy         35) San Marino
 6) Bosnia & Herzegovina  21) Latvia        36) Slovakia
 7) Britain (UK)          22) Liechtenstein 37) Slovenia
 8) Bulgaria              23) Lithuania     38) Spain
 9) Croatia               24) Luxembourg    39) Sweden
10) Czech Republic        25) Macedonia     40) Switzerland
11) Denmark               26) Malta         41) Turkey
12) Estonia               27) Moldova       42) Ukraine
13) Finland               28) Monaco        43) Vatican City
14) France                29) Netherlands   44) Yugoslavia
15) Germany               30) Norway
#? 7
Please select one of the following time zone regions.
1) Great Britain
2) Northern Ireland
#? 1 
System timezone set to : Europe/Britain/GB
```

Lastly just save the changes then logout

```text
copy run start
logout
```

A full example of this is below:

```text
Switch> en
Switch# conf t
Switch(config)# ntp enable
Switch(config)# ntp timezone 0
Switch(config)# ntp primary-server 79.142.192.4
Switch(config)# ntp secondary-server 217.147.208.1
Switch(config)# exit
Switch# copy run start
Switch# logout
```

Your switches should now keep their time in sync :)
