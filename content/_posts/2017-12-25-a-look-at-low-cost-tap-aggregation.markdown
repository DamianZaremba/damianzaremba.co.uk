---
layout: post
title: A look at low-cost tap aggregation
tags:
- Network
- How-to
- Python
---
A while ago, I had a project that required capturing traffic from a
number of sources, thus an adventure into possible solutions was born.

## Why do we want to capture traffic?

There are numerous reasons to capture traffic including:

* Network troubleshooting
* Traffic monitoring (including intrusion detection)
* Legal requests/requirements

Ultimately it's about getting visibility, either for security or operations.

Our goal is given any path, to be able to replicate the traffic, with minimal impact.

## How can we capture traffic?

There are generally 3 different methods for capturing traffic, each with their
own complexities.

### From a target device
At a basic level, a device can capture traffic in 2 ways:

* 'CPU bound'; traffic that has been brought up the network stack and is 'destined' for this device
* Raw sockets; 'raw' network traffic that the device receives on a network interface.

CPU bound traffic can be efficient to capture if filtered appropriately. When dealing with high
traffic volumes processing traffic can take critical resources away from your business applications.

Raw sockets are generally very limited, hub-based topologies are not widely used, limiting any traffic to broadcast for the servers subnet, or targeted (CPU bound) traffic (multicast/unicast).

Generally, to be usable by an analyser the traffic would need to be encapsulated and transmitted,
using further resources on the device.

### Span a switch
This is similar to inline, but I've separated it here due to implementation differences.

SPAN's generally come in 3 forms:

* SPAN - take traffic from port A, mirror to port B, on the same device
* RSPAN - take traffic from port A, mirror to port B, on a remote device (over layer 2)
* ERSPAN - take traffic from port A, mirror to port B, on a remote device (over layer 3)

There are a number of downsides:

* Vendors have varying levels of support;
  * RSPAN on a Juniper EX series switch doesn't work over an AE
  * Tricks can be used, for example, spanning into a GRE tunnel to accomplish ERSPAN, this becomes hardware dependent though
* CPU generated (ICMP/ARP/LLDP/BPDU etc) packets generally do not get mirrored
* Invalid packets will not be seen (those dropped due to checksum errors for example)
* CPU usage can increase drastically due to extra processing requirements
* As we're spanning in an L2 domain arp table churn can happen if you're not careful

However, if you need insight into a switched domain and don't want to inline-tap every cable,
it might work for you.

### Inline
Inline-taps come in many different flavours, supporting different media types. At a basic level, there are 2 main differences.

#### Passive tap
* Require no power, pass the original signal onto the output
* Reduce the output power by a known ratio (important when dealing with fibre)
* No monitoring data or other insights possible
* Very failure resistant

##### Logical operation
{% digraph passive tap %}
subgraph cluster_Input {
  label = "Input Port";
    color = black;
  "Input TX";
  "Input RX";
}
subgraph cluster_Output {
  label = "Output Port";
    color = black;
  "Output TX";
  "Output RX";
}
subgraph cluster_Monitor {
  label = "Monitor Port";
    color = black;
  "Monitor TX2";
  "Monitor TX1";
}
"Input TX" -> "Output RX"
"Input TX" -> "Monitor TX1"
"Output TX" -> "Input RX"
"Output TX" -> "Monitor TX2"
{% enddigraph %}

There are different technologies for mirroring the payload when using copper, these
are generally resistor based, for fibre they're either thin film or fused biconical taper based.

_Note: Thin film is generally preferred for 40G+ links, due to their lower loss rate caused by more even light distribution._

The concept for all of them is the same:

* Given an input of 100%
* Bleed off x% of the signal to the mirror port
* Pass the remaining 100-x% through to the output port

A key consideration when using fibre is the 'split ratio' aka how much light to bleed off,
both the monitor and the output interfaces need enough light for the optics on the other end.

#### Active tap
* They require power and re-generate the output signals.
* Monitoring data can be provided (light levels etc)
* When using fibre there are no split ratio considerations

##### Logical operation
{% digraph active tap %}
subgraph cluster_Input {
  label = "Input Port";
    color = black;
  "Input TX";
  "Input RX";
}
subgraph cluster_Output {
  label = "Output Port";
    color = black;
  "Output TX";
  "Output RX";
}
subgraph cluster_Monitor {
  label = "Monitor Port";
    color = black;
  "Monitor TX2";
  "Monitor TX1";
}
subgraph cluster_Processor {
  color = black;
  shape = square;
  "Processor";
}

"Processor" -> "Input TX"
"Input RX" -> "Processor"
"Processor" -> "Output TX"
"Output RX" -> "Processor"
"Processor" -> "Monitor TX1"
"Processor" -> "Monitor TX2"
{% enddigraph %}

The internal complexity varies, but the principle is:

* Given an input of X
* Generate the payload of X into Y and Z
* Transmit Y to the monitor interface
* Transmit Z to the output interface

It is possible to buy active taps, with the capability to 'fail open' meaning in the event
of a power failure traffic will continue to flow.

I still prefer to use passive taps, which should be as resilient as a fibre patch panel.

## Why do we want to aggregate it?
In the most simplistic deployment, we can simply send from the source to the destination:
{% digraph one to one tap %}
rankdir=LR;
"TAP" -> "Analyser"
{% enddigraph %}

However, there are a number of reasons to have an aggregation step in the middle:

* Number of ingress points
  * Aggregation of smaller capture points into larger interfaces
  * Reduction in rack space required for analysers, servers etc
  * Strategic aggregation to reduce physical requirements (fibre, rack space)
* Multiple destinations
  * Apply filtering logic to save on analyser licensing
  * Send traffic to security appliances and network monitoring devices
* Apply software logic to capture rules
* Support multiple media types
  * Provide longer reach for copper-based taps
  * SMF, MMF, XFP, QSFP, Copper support
* Single view of traffic
  * Certain DPI/IDS appliances require full flows, difficult in ECMP networks
  * I don't recommend this due to the associated scaling issues

Downsides to having an aggregation step:

* Potential congestion issues (we're taking raw traffic, limited by the sender)
* Single point of failure
  * This could be mitigated using layer 1 fibre switches or similar
  * It's for monitoring traffic, so uptime is likely not as critical
* Cost

Historically TAP aggregation has been a very expensive game, around 2-4k a port!

Thankfully Arista changed that with their 7150 series switch, which supports a tap mode
as well as a 'DANZ' software suite for loss/latency monitoring, packet filtering and mirroring.

The DANZ suite is now available on the 7150, 7280E and 7500E series switches from Arista,
opening up options from 1/2U fixed form to 7/11U chassi based deployments.

The 7150 series gives some nice features:

* Port density; up to 64 10G ports
* LANZ+ features for micro-burst analysis
* PTP support for packet time stamping
* ~350ns latency for all packets
* Multi-port mirroring
* Hitless (ISSU) upgrades
* A 'normal' Linux environment and Python based toolset
* You configure it like any other switch!

## Let's implement a solution!

We'll keep it simple with 1 aggregation point, 6 inputs and 2 outputs.
In reality, this could be multiple levels of aggregation.

Inputs:

* 2 x Passive taps
* 2 x SPANs
* 2 x Active taps

Logical Groups:

* Group 1 - Internet
* Group 2 - Corporate
* Group 3 - Regional

Outputs:

* Bro Network Security Monitor (Internet + Regional only)
* Server (Corporate only)

### Logical Diagram
{% digraph active tap %}
subgraph cluster_PassiveTap {
  label = "Passive Optical Tap";
    color = black;
  "Transit Provider 1";
  "Transit Provider 2";
}
subgraph cluster_Corporate1 {
  label = "Corporate DMZ";
    color = black;
  "Corporate Spine 1";
}
subgraph cluster_Corporate2 {
  label = "Corporate DMZ";
    color = black;
  "Corporate Spine 2";
}
subgraph cluster_Regional {
  label = "Active TAP";
    color = black;
  "Wan Provider 1";
  "Wan Provider 2";
}
subgraph cluster_7150 {
  color = black;
  shape = square;
  "Tap Switch";
}
subgraph cluster_Bro {
  color = black;
  shape = square;
  "Bro Network Security Monitor";
}
subgraph cluster_Server {
  color = black;
  shape = square;
  "Secret Server";
}

"Transit Provider 1" -> "Tap Switch"
"Transit Provider 2" -> "Tap Switch"
"Corporate Spine 1" -> "Tap Switch"
"Corporate Spine 2" -> "Tap Switch"
"Wan Provider 1" -> "Tap Switch"
"Wan Provider 2" -> "Tap Switch"

"Tap Switch" -> "Bro Network Security Monitor"
"Tap Switch" -> "Secret Server"
{% enddigraph %}

### Switch configuration
The switch config is where we wire everything together, there are 3 key concepts:

* Tap - input
* Tool - output
* Tap Group - logical grouping of TAP ports

The configuration is quite simple and
[well documented](https://www.arista.com/en/um-eos/eos-section-16-3-tap-aggregation-configuration).

First, let's put the switch into tap mode

```
switch>en
switch#configure terminal
switch(config)#tap aggregation
switch(config-tap-agg)#mode exclusive
```

This will place all switch ports into error disabled and enable tap/tool ports.

Next, define our tap ports

```
switch(config)#interface ethernet 1
switch(config-if-Et1)#description Transit Provider 1
switch(config-if-Et1)#switchport mode tap
switch(config-if-Et1)#switchport tool group INTERNET

switch(config)#interface ethernet 2
switch(config-if-Et2)#description Transit Provider 2
switch(config-if-Et2)#switchport mode tap
switch(config-if-Et2)#switchport tool group INTERNET

switch(config)#interface ethernet 3
switch(config-if-Et3)#description Corporate Spine 1
switch(config-if-Et3)#switchport mode tap
switch(config-if-Et3)#switchport tool group CORPORATE

switch(config)#interface ethernet 4
switch(config-if-Et4)#description Corporate Spine 2
switch(config-if-Et4)#switchport mode tap
switch(config-if-Et4)#switchport tool group CORPORATE

switch(config)#interface ethernet 5
switch(config-if-Et5)#description Wan Provider 1
switch(config-if-Et5)#switchport mode tap
switch(config-if-Et5)#switchport tool group WAN

switch(config)#interface ethernet 6
switch(config-if-Et6)#description Wan Provider 2
switch(config-if-Et6)#switchport mode tap
switch(config-if-Et6)#switchport tool group WAN
```

We now have 3 groups with 3 interfaces in each.

Finally, map those groups onto our outputs.

```
switch(config)#interface ethernet 10
switch(config-if-Et10)#description Bro Network Security Monitor
switch(config-if-Et10)#switchport mode tool
switch(config-if-Et10)#switchport tool group set INTERNET WAN

switch(config)#interface ethernet 11
switch(config-if-Et11)#description Secret Server
switch(config-if-Et11)#switchport mode tool
switch(config-if-Et11)#switchport tool group set CORPORATE
```

Et10 + Et11 will now receive any traffic sent to their relevant groups.

### Advanced features
In the demo, we have a static input -> output allocation in real life this can be
software controlled or filter based.

We could also truncate packets to look at only their headers,
potentially useful for encrypted traffic.

A simple traffic steering example is as below:

* For traffic coming into Eth1
* Match traffic targeting 8.8.8.8
* Send to tap group GOOGLE_DNS
* Send tap group GOOGLE_DNS to Eth20

```
switch(config)#ip access-list ACL_GOOGLE_DNS
switch(config-acl-ACL_GOOGLE_DNS)#permit ip any 8.8.8.8/32

switch(config)#class-map type tapagg match-any TAP_CLASS_MAP
switch(config-cmap-TAP_CLASS_MAP)#match ip access-group ACL_GOOGLE_DNS

switch(config)#policy-map type tapagg TAP_POLICY
switch(config-pmap-TAP_POLICY)#class TAP_CLASS_MAP
switch(config-pmap-TAP_POLICY-TAP_CLASS_MAP)#set aggregation-group GOOGLE_DNS

switch(config)#interface ethernet 20
switch(config-if-Et20)#description Magic Box
switch(config-if-Et20)#switchport mode tool
switch(config-if-Et20)#switchport tool group set GOOGLE_DNS

switch(config)#interface ethernet1
switch(config-if-Et1)#service-policy type tapagg input TAP_CLASS_MAP
```

For software-based control, Arista provides a powerful HTTP API as well as
XMPP client support and 'on-device' APIs. The Python eAPI client can be found on
[GitHub](https://github.com/arista-eosplus/pyeapi), with some [examples](https://github.com/arista-eosplus/pyeapi/tree/develop/examples).

# Summary

It is cost effective to deploy tap infrastructure where required.
The offering from Arista is very powerful, allowing flexibility to meet any number
of requirements.

With a number of integration options (JSON API, Python API, XMPP client),
having dynamic tapping capabilities is a nice spanner to have in your toolbox.

And the cost? Basically, about the same as a 10G switch with routing functionality.

Naturally, the cost is varied depending on physical requirements (fibre/copper runs),
port speeds (1/10/25/40/100G) and port count; this is applicable to any switch or
other tap based deployment.

## Footnote
I would advise any tap deployments to be carefully planned, certain topologies,
such as multi-stage clos networks do not make good tap targets, both due to the number
of links involved and the resulting bandwidth requirements for the TAP infrastructure.

Depending on your goals, tapping at natural points of congestion, such as
the ingress/egress points for your high performance/bandwidth network segments
(transit links, firewalls etc), will likely provide highly useful information at
a vastly reduce capture complexity.
