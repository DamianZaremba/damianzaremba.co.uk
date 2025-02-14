---
layout: post
title: Example of building nagios configs from LDAP
tags:
- General
---

Over at ClueNet we have a bunch of servers all stored in LDAP with owners and admins linked to user accounts also stored in LDAP! One thing we wanted to implement (as well as graphing, but cacti sorts that out) was service monitoring.

After getting a box up and a bot in IRC to relay stuff I set about hacking up a script to add in servers and add owners/admins as contacts (so they can get notifications and access the Nagios web interface to disable checks and stuff (it uses mod_auth_krb to let people login over HTTPS)).

Some notes about this script:



    
  * Currently we don't store attributes in the servers entry relating to what services to monitor, this is something I'm looking at implementing

    
  * IP addresses and SSH ports are stored in LDAP

    
  * Server owners AND admins should have access to update the server in Nagios (they do in LDAP!)

    
  * There is no attribute under the users entry to determine if we _should_ notify them about alerts so we don't atm!

    
  * The only way people know about alerts is the relay channel on IRC or the web interface


The main thing I want to implement that would improve this script is per service attributes in the servers entry following the standard for ClueNet.

I propose the attribute clueServiceMonitoring be added into the ldap scheme and added to the servers entries.

An example is as below:
Server: hex
Services to be monitored:

    
  * ping (via ICMP)

    
  * ssh (will use port listed in LDAP)

    
  * http (port 8080)

    
  * ldap

    
  * kerberos


```text

dn: cn=hex,ou=servers,dc=cluenet,dc=org
 changetype: modify
 add: clueServiceMonitoring
 clueServiceMonitoring: ping^ICMP

dn: cn=hex,ou=servers,dc=cluenet,dc=org
 changetype: modify
 add: clueServiceMonitoring
 clueServiceMonitoring: ssh

dn: cn=hex,ou=servers,dc=cluenet,dc=org
 changetype: modify
 add: clueServiceMonitoring
 clueServiceMonitoring: http^8080

dn: cn=hex,ou=servers,dc=cluenet,dc=org
 changetype: modify
 add: clueServiceMonitoring
 clueServiceMonitoring: ldap

dn: cn=hex,ou=servers,dc=cluenet,dc=org
 changetype: modify
 add: clueServiceMonitoring
 clueServiceMonitoring: kerberos

```

This would allow the script to check for the attributes and write out the services definitions as necessary. The current solution works but is a little inflexible.

Also, the Perl could do with tidying up a little as I'm not the best Perl programmer on the planet.

```perl
#!/usr/bin/env perl
use strict;
use File::Path;
use Net::LDAP;
use Data::Dumper;

# Config stuff
my $base_dir = "/usr/local/nagios/etc/cluenet/";

# Main code
my $ldap = Net::LDAP->new("ldap.cluenet.org", timeout => 30);
if(!$ldap) {
    print "Could not connect to ldap\n";
}

print "Clearing current configs\n";
rmtree($base_dir);
mkdir($base_dir);

my @admins = ();
my @owners = ();
my $mesg = $ldap->search(
    filter => "(&(objectClass=server)(isActive=TRUE))",
    base => "ou=servers,dc=cluenet,dc=org"
);
my @entries = $mesg->entries;

print "Starting server configs\n";
foreach (@entries) {
    my $entry = $_;
    print "Starting " . $entry->get_value('cn') . "\n";

    my $hostname = $entry->get_value('cn');
    if(!$hostname) {
        print "Skipping - missing hostname\n";
        next;
    }

    my $servername = $hostname;
    $servername =~ s/\.cluenet\.org$//;

    my $owner = $entry->get_value('owner');
    $owner =~ s/uid=(.*),ou=people,dc=cluenet,dc=org/$1/;

    if(!$owner) {
        print "Skipping - missing owner\n";
        next;
    }

    my $ip_address = $entry->get_value('ipAddress');
    if(!$ip_address) {
        print "Skipping - missing ip address\n";
        next;
    }

    my $ssh_port = $entry->get_value('sshPort');

    my $description = $entry->get_value('description');
    if(!$description) {
        $description = "";
    }

    my $os = $entry->get_value('operatingSystem');
    if(!$os) {
        $os = 'linux'; # windows sux
    }

    open(FH, ">", "$base_dir/$hostname.cfg");
    # Write the host out
    print FH <define host {
    host_name $hostname
    alias $servername
    address $ip_address
    hostgroups $owner\_servers
    max_check_attempts 5
    check_period 24x7
    contacts $owner
    contact_groups $servername\_admins
    notification_period 24x7
}

EOS
;

    # Write out the services
    # - I'd like these to be ldap attributes but I'm not sure how we can do shit for now so hardcoding
    print "Adding ping check\n";
    print FH <define service {
    host_name $hostname
    service_description PING check
    notification_period 24x7
    check_period 24x7
    max_check_attempts 3
    normal_check_interval 5
    retry_check_interval 1
    notification_interval 30
    notification_options w,u,c,r,f,s
    check_command check_ping!100.0,20%!500.00,60%
}

EOS
;

    if(grep(/windows/i, $os)) {

    } else {
        if($ssh_port) {
            print "Adding SSH check on port $ssh_port\n";
            print FH <get_value('authorizedAdministrator')) {
        my $user = $_;
        $user =~ s/uid=(.*),ou=people,dc=cluenet,dc=org/$1/;
        $members = $members . ", " . $user;

        if(!grep(/$user/, @admins)) {
            push(@admins, $user);
        }
    }

    print FH <get_value('cn') . "\n";
}
print "Finished server configs\n";

print "Starting user config\n";
open(FH, ">", "$base_dir/users.cfg");
print "Adding __nagiosbot__\n";
print FH <define contact {
    contact_name __nagiosbot__
    alias General nagios bot
    host_notification_period 24x7
    service_notification_period 24x7
    host_notification_commands host-notify-by-irc
    service_notification_commands notify-by-irc

}
EOS
;

foreach(@admins) {
    print "Adding user $_ \n";
    print FH <search(
        filter => "(&(objectClass=person)(uid=" . $_ . "))",
        base => "ou=people,dc=cluenet,dc=org"
    );

    foreach($mesg->entries) {
        my $entry = $_;

        my $gecos = $entry->get_value('gecos');
        if($gecos) {
            print FH "\talias $gecos\n";
        }

        my $mail = $entry->get_value('mail');
        if($mail) {
            print FH "#\temail $mail\n";
        }
    }
    print FH <}

EOS
;
}

foreach(@owners) {
    print FH <define hostgroup {
    hostgroup_name $_\_servers
    alias $_\'s servers
}

EOS
;
}

close(FH);
print "Finished user config\n";

print "Reloading\n";
`/etc/init.d/nagios reload`
```
