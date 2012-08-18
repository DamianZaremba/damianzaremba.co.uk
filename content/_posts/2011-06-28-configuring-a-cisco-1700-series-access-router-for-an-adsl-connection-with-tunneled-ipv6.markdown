---
comments: true
layout: post
title: Configuring a Cisco 1700 series access router for an ADSL connection with tunneled
  IPv6
categories:
- Security
tags:
- cisco
- Cisco 1700
---

I decided to re-configure my home router from scratch so that I could tidy up the config and ACLs which had been messily generated over time.

The main reason being my old IPv6 ACLs pretty much where non-existent and before properly configuring my lan for auto assigning v6 IPs, I wanted to limit the incoming traffic.

I've included an example config below with comments
{% highlight text %}
!! Basic stuff
version 12.4
service timestamps debug datetime msec
service timestamps log datetime msec
service password-encryption
boot-start-marker
boot-end-marker
hostname router1-man !! You probably want to change this to a relevant hostname
!
!! Security stuff
no cdp run
no ip http server
no ip http secure-server
no mmi auto-configure
no mmi pvc
banner exec ^C
Welcome to $(hostname) (:
^
!
banner login ^
##############################################
# THIS SYSTEM IS FOR AUTHORIZED USERS ONLY. #
# !! IF YOU DO NOT HAVE ACCESS DISCONNECT NOW !! #
##############################################
^C
!
!! Access stuff
snmp-server community thisisnotmysnmppassword RO admin !! You probably want to change this to a sensible password
ip domain-name router1-man.nodehost.co.uk !! You probably want to change this to a relevant hostname
crypto key generate rsa
ip ssh time-out 60
ip ssh authentication-retries 2
!
!! Logging stuff
logging on
logging 10.44.200.5 !! You probably want to change this to a server that is listening for syslog traffic
logging trap informational
logging console debug
logging monitor debug
no logging monitor
!
!! NTP stuff
ntp clock-period 17179944
ntp server 83.98.201.133 !! These are the fedora NTP servers, feel free to change them
ntp server 87.98.238.185
ntp server 147.231.100.5
ntp server 193.55.167.1
!
!! Login stuff
no aaa new-model !! I don't use a TACAS server for my house but you can!
enable password enable !! This clearly isn't my enable password but I don't feel like putting the hash of it in public.
username myuser privilege 15 password mypass !! This will login directly to enable access, feel free to change the privilege level.
!
!! IP settings
ipv6 cef
ipv6 unicast-routing
ip cef
ip forward-protocol nd
ip auth-proxy max-nodata-conns 3
ip admission max-nodata-conns 3
!
!! DNS stuff
ip domain name nodehost.co.uk !! You probably want to change this to a domain name that is relevant to you
ip name-server 8.8.8.8 !! These are the google and HE nameservers, feel free to change them
ip name-server 8.8.4.4
ip name-server 2001:470:20::2
!
!! IPv6 Tunnel
interface Tunnel0
 description IPv6 HE Tunnel
 ip access-group IPV6_IN in
 ip access-group IPV6_OUT out
 no ip address
 ipv6 address 2001:470:xx:xx::2/64 !! Change this to your client IPv6 address
 ipv6 enable
 ipv6 virtual-reassembly
 tunnel source Dialer1 !! You can use an IP address here if you have a static IP, I do not.
 tunnel destination xx.xx.xx.xx !! Change this to your server IPv4 address
 tunnel mode ipv6ip
!
!! ADSL interface
interface ATM0
 description ADSL interface
 no shut
 mtu 1432
 no ip address
 no ip mroute-cache
 no atm ilmi-keepalive
 logging event atm pvc state
 logging event atm pvc autoppp
 dsl operating-mode auto
 pvc 0/38 !! Change this to the vpi / vci of your ISP
 encapsulation aal5mux ppp dialer !! Change this if your ISP uses different encapsulation
 dialer pool-member 1
 !
!
!! Dialer interface
interface Dialer1
 description Dialer interface
 ip access-group IPV4_IN in
 ip access-group IPV4_OUT out
 no shut
 mtu 1432
 ip address negotiated !! Change this if you have a static IP
 ip nat outside
 ip virtual-reassembly max-reassemblies 1024
 encapsulation ppp
 dialer pool 1
 ppp chap hostname 00000000000@myisp.com
 ppp chap password myubersecurepasswordhere
 ppp pap sent-username 00000000000@myisp.com password myubersecurepasswordhere
!
!! ISDN interface
interface BRI0
 description ISDN interface
 shut
 no ip address
!
!! Internal FE interface
interface FastEthernet0
 description Internal interface
 ip access-group IPV6_IN in
 ip access-group IPV6_OUT out
 no shut
 ip address 10.44.200.254 255.255.255.0 !! Change this to a relevant IP address
 ip nat inside
 ip virtual-reassembly
 speed 100
 ipv6 enable
 ipv6 nd ra-interval 60 !! You might want to change this, works for me though
 ipv6 nd ra-lifetime 180 !! You might want to change this, works for me though
 ipv6 nd other-config-flag !! You might want to change this, works for me though
 ipv6 address 2001:470:xx:xx::/64 eui-64
!
!! Routes
ipv6 route ::/0 Tunnel0
ip route 0.0.0.0 0.0.0.0 Dialer1
!
!! NAT rules
ip nat inside source list 1 interface Dialer1 overload !! You might want to change this if you have a pool if ips
ip nat inside source static tcp xx.xx.xx.xx 8080 interface Dialer1 8080 !! Probably want to delete this - it's a webserver for my house
ip nat inside source static tcp xx.xx.xx.xx 3406 interface Dialer1 3406 !! Probably want to delete this - it's a vpn endpoint for my house
ip nat inside source static tcp xx.xx.xx.xx 22 interface Dialer1 2020 !! Probably want to delete this - it's a ssh gateway for my house
!
!! ACLs
access-list 1 remark Default traffic
access-list 1 permit any !! You might want to change this to deny all depending on how you care to do your ACLs
dialer-list 1 protocol ip permit
!
ip access-list standard admin
 remark Admin traffic
 permit 10.44.200.0 0.0.0.255 !! Change this to a relevant IP address
 deny any log
!
ipv6 access-list IPV6_IN
 remark Incoming IPv6 Traffic
 permit icmp any any !! Allow ICMP (ping)
 permit tcp any any established !! Allow established TCP connections
 permit tcp any any eq domain !! Allow incoming TCP DNS stuff - might want to delete this
 permit udp any any eq domain !! Allow incoming UDP DNS stuff - might want to delete this
 deny ipv6 any any log !! Drop everything else
!
ipv6 access-list IPV6_OUT
 remark Outgoing IPv6 Traffic
 permit ipv6 any any !! Permit any outgoing traffic - yeah I'm lazy
!
ip access-list extended IPV4_IN
 remark Incoming IPv4 Traffic
permit GRE xx.xx.xx.xx 255.255.255.255 any !! Allow GRE from the IPv6 tunnel server
permit ESP xx.xx.xx.xx 255.255.255.255 any !! Allow ESP from the IPv6 tunnel server
permit 41 xx.xx.xx.xx 255.255.255.255 any !! Allow 41 from the IPv6 tunnel server
 permit icmp any any !! Allow ICMP (ping)
 permit tcp any any established !! Allow established TCP connections
 permit tcp any eq domain any !! Allow incoming TCP DNS stuff - might want to delete this
 permit udp any eq domain any !! Allow incoming UDP DNS stuff - might want to delete this
 permit tcp any any eq 3406 !! Probably want to delete this - it's a vpn endpoint for my house
 permit tcp any any eq 8080 !! Probably want to delete this - it's a webserver for my house
 permit tcp any any eq 2020 !! Probably want to delete this - it's a ssh gateway for my house
 deny ip any any log !! Drop everything else
!
ip access-list extended IPV4_OUT
 remark Outgoing IPv4 Traffic
 permit ip any any !! Permit any outgoing traffic - yeah I'm lazy
!
!! VTY lines
line vty 0 15
 access-class admin in
 privilege level 15
 password mysemiuberawesomepassword
 login local
 transport input ssh
!
end
{% endhighlight %}

I might update it to support VPN connections rather than tunnelling them though to a openvpn box, but openvpn + SSL certs just work for when I want lan access (not that often..). For the rest of the time just plain old SSH with a little tunnelling where needed does the job.
One thing that does need doing is sending the system logs over to the syslog box - Currently things like NAT table overflow warnings just spam the console. Once I get a bit of time to re-configure rancid I'll start playing with the configs, for now they work just fine.
