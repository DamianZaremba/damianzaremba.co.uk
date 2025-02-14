---
layout: post
title: A look at Arista's configuration session
tags:
- Network
- Security
- Automation
---
When making changes it's generally advisable to have a few things:

* A rollback plan
* Atomic changes
* Control around releases

This is a given in the land of Juniper, but sadly has been lacking
on Cisco, Arista, HP and other network kit based on the familiar syntax.

Thankfully Arista added in a feature last year, which brings initial
support for this and some nice use cases with it!

We'll take a look at what Arista offers and how we can use it.

The basics
==========

`configure session` as added in EOS 14.4 (mid-2015), enables changes to
be staged, reviewed, rollback and committed as required.

The most basic usage is to use `configure session` rather than `configure terminal` and `commit` before exiting the configuration mode.

Lets take a basic example; changing the IP on the Management interface:

```
localhost#configure terminal
localhost(config)#interface management 1
localhost(config-if-Ma1)#ip address 1.2.3.4/24
localhost(config-if-Ma1)#ip address 4.3.2.1/24
localhost(config-if-Ma1)#ip address 1.2.3.4/24
localhost(config-if-Ma1)#
```

Completing the same using a configuration session is nearly identical:

```
localhost#configure session example1
localhost(config-s-exampl)#interface management 1
localhost(config-s-exampl-if-Ma1)#ip address 1.2.3.4/24
localhost(config-s-exampl-if-Ma1)#ip address 4.3.2.1/24
localhost(config-s-exampl-if-Ma1)#ip address 1.2.3.4/24
localhost(config-s-exampl-if-Ma1)#commit
```

However, there is 1 key difference. In the first example, the IP is changed
to 4.3.2.1, in the second the IP is never set to this.

This can be seen as below:

```
localhost(config-s-exampl-if-Ma1)#ip address 4.3.2.1/24
localhost(config-s-exampl-if-Ma1)#show ip int ma1 brief
Interface              IP Address         Status     Protocol         MTU
Management1            1.2.3.4/24         up         up              1500
```
This is due to the config not actually being applied until the 'commit' command
has completed.

Naturally, you also have the usual commands, including aborting, computing the
diff etc:

```
localhost(config-s-sess1)#show session-config diffs
--- system:/running-config
+++ session:/sess1-session-config
@@ -35,7 +35,6 @@
 interface Ethernet7
 !
 interface Management1
-   vrf forwarding management
    ip address 1.2.3.4/24
 !
 no ip routing

localhost(config-s-sess2)#abort
localhost#
```

These also work when not in configure mode, by passing the session name
(see below);

```
localhost#show session-config named sess2 diffs
--- system:/running-config
+++ session:/sess2-session-config
@@ -35,7 +35,6 @@
 interface Ethernet7
 !
 interface Management1
-   vrf forwarding management
    ip address 1.2.3.4/24
 !
 no ip routing
```

The difference
==============
At a basic level, this is familiar to the Juniper world of 'configure & commit',
but we get much more.

You can have multiple pending configuration sessions, disconnecting from the
device and re-entering the same session by name later, or passing it to another
engineer for review.

To view all sessions you can issue the `show configuration sessions` command:

```
localhost#show configuration sessions detail
Maximum number of completed sessions: 1
Maximum number of pending sessions: 5

  Name        State           User       Terminal    PID
  -------- --------------- ---------- -------------- ---
  example1    completed                                  
  example2    pending                                    
  sess1       pending                                                         
```

A simple use case for this feature may be continuing earlier work, a more
complex example could be enforcing 2 users are involved in a config change;
this has a very nice appear for environments with high compliance requirements.

### Limitations
Currently, there is no `rollback` command, once the change is committed trying
to display the diff or inverse diff is not possible.

It's also not super easy to hook into config events to backup the config just
before a config commit happens. You're still going to be relying on access logs
or scheduled config backups to figure out what changed if you don't have the session-config
diff to hand.

This would be a really nice feature, that I hope they implement soon.

For any configs on the flash, these can either be restored
(`config replace flash:startup-config.xxxx`), or the differences displayed (`diff running-config flash:startup-config.xxxx`) pretty easily,
so most the functionality is already there.

### An example 'four-eye' change
Let's establish some ground rules:

* Operations staff can 'request' config changes
* Operations staff have no access to the advanced shells (i.e. APIs directly)
* Engineering staff can 'approve' (commit) requested config changes
* Engineering staff can do anything they want

To enforce this, we can create 2 groups with relevant permissions;

```
localhost(config)#role operations
localhost(config-role-operations)#10 permit mode exec command configure session
localhost(config-role-operations)#20 deny mode exec command configure|bash|python-shell
localhost(config-role-operations)#30 deny mode config command commit
localhost(config-role-operations)#40 permit mode exec command .*

localhost(config)#role engineering
localhost(config-role-engineering)#10 permit command .*
```

Next, let's define some test users;

```
localhost(config)#username ops1 role operations nopassword
localhost(config)#username eng1 role engineering nopassword
```

Trying a standard `configure` command as ops1, results in an error;

```
localhost#configure terminal % Authorization denied for command 'configure'
```

However, using `configure session` is allowed;

```
localhost#configure session
localhost(config-s-sess4)#hostname super-cool-001
localhost(config-s-sess4)#show session-config diff
--- system:/running-config
+++ session:/sess4-session-config
@@ -7,6 +7,8 @@
    action bash sudo /mnt/flash/initialize_ma1.sh
 !
 transceiver qsfp default-mode 4x10G
+!
+hostname super-cool-001
 !
 spanning-tree mode mstp
 !
```

We've successfully staged the config change but cannot commit it.

```
localhost(config-s-sess4)#commit
% Authorization denied for command 'commit'
```

Let's ask our eng1 user to proceed;

First, lets review the change:

```
localhost#configure session sess4
localhost(config-s-sess4)#show session-config diffs
--- system:/running-config
+++ session:/sess4-session-config
@@ -7,6 +7,8 @@
    action bash sudo /mnt/flash/initialize_ma1.sh
 !
 transceiver qsfp default-mode 4x10G
+!
+hostname super-cool-001
 !
 spanning-tree mode mstp
 !
```

As you can see, this is identical to what the ops1 user sees. We can then commit
the change as normal, changing the status to completed:

```
localhost(config-s-sess4)#commit

super-cool-001#show configuration sessions detail | inc sess4
  sess4    completed
```

Now the change has been completed, no further changes can be made.

Real life examples
==================
When is this a life saver? Simply whenever you need atomic changes.

### Migrating management interfaces into a different VRF
Using a separate routing domain for management traffic is attractive in certain
environments.

Let's look at the simplest change:

```
localhost>show ip int management 1 brief
Interface              IP Address         Status     Protocol         MTU
Management1            1.2.3.4/24         up         up              1500

localhost(config)#vrf definition management
localhost(config-vrf-management)#rd 0:0

localhost(config)#interface management 1
localhost(config-if-Ma1)#vrf forwarding management
! Interface Management1 IP address 1.2.3.4 removed due to enabling VRF management

! We've now lost access to the device!
Interface              IP Address         Status     Protocol         MTU
Management1            unassigned         up         up              1500
```

This makes the migration tricky, without another form of access (console, loopbacks etc).

Using a config session we can make the change and re-apply the IP, resulting in only
a short interruption:

```
localhost(config-s-sess0)#interface management 1
localhost(config-s-sess0-if-Ma1)#vrf forwarding management
localhost(config-s-sess0-if-Ma1)#ip address 1.2.3.4/24
localhost(config-s-sess0-if-Ma1)#commit
localhost#show ip int management 1 brief
Interface              IP Address         Status     Protocol         MTU
Management1            1.2.3.4/24         up         up              1500

localhost#show vrf management
   Vrf              RD        Protocols       State             Interfaces  
---------------- --------- --------------- -------------------- -----------
   management       0:0       ipv4,ipv6       v4:no routing,    Management1
                                              v6:no routing                
```

This can be extended as required; RADIUS, DNS, NTP, SNMP config sections are a few places
that come to mind as requiring changes under these circumstances.

### Changing ACLs
When building access control lists, it's common practice to space the entries,
allowing for future entries to fit into the list, preventing access issues due
to ordering.

Sometimes it's useful to change these on mass:

* ACLs come from an external system, computing the diff is required
* Re-ordering of the entries needs to take place to allow for growth
* Standardisation of ACLs across multiple devices

Typically, this is a painful process as you cannot remove an ACL, without
directly impacting traffic.

Once again, due to the staging aspect of commit sessions, we can make all of our
changes and have a single change resulting in our desired config.

A similar approach can be taken for more complex objects, such as route maps.

### Staging config
Simply, the ability to stage config is very useful.

Let's imagine you have a maintenance window that requires 3 steps:

* Placing BGP peers into maintenance mode
* Re-configuring said peers for BFD
* Reverting step 1

Rather than having this in text files and copying it in sequence, we can stage
the configs and simply apply them as required.

The rollback config can also be staged, allowing a very fast rollback with little
confusion.

This could play out along the lines of;

```
localhost#show configuration sessions | inc maint-10001
  maint-10001-step-1           pending                        
  maint-10001-step-1-revert    pending     

localhost#configure session maint-10001-step-1
localhost(config-s-maint-)#commit

!! Breakage, rollback

localhost#configure session maint-10001-step-1-revert
localhost(config-s-maint-)#commit
```

API support
===========

The `configuration session` command is also supported via the eAPI, which has a
nice side effect, ensuring any config errors submitted remotely do not result in
partially applied configs.

Summary
=======
While not perfect, this certainly gives you some nice features. I hope further
features are built, extending the functionality.

Ideally, the changes are being versioned and pushed via an external service,
but we all know in reality that sometimes it's easier/quicker to check a single
device in question. Old habits die hard!
