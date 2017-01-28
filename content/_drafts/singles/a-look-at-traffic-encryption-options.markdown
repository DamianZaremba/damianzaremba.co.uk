---
comments: true
layout: post
title: A look at traffic encryption options
tags:
- Network
- Security
---

Given a post [highlighting the cost effectiveness](/2016/10/a-look-at-low-cost-tap-aggregation/)
of deploying network taps, it would make sense to look at the other side; encryption.

Intro
=====
It is commonly accepted do use TLS when accessing services over the internet, whether
they are based on HTTP, SMTP, IMAP, POP, FTP or any number of other protocols.

It is also commonly accepted to terminate those TLS connections on the edge,
handling all internal communications in plain text. This is for a number of reasons around scalability, performance and trust.

As technology stacks have matured, a number of security standards have been created,
including those for card handling (PCI DDS); many of these still contain phrasing such
as '[encrypt transmission of cardholder data across open, public networks](https://www.pcisecuritystandards.org/pdfs/pci_ssc_quick_guide.pdf)', with the
definitions being open to interpretation.

Pause for a moment and consider if these scenarios are 'across open, public networks':

* A point to point circuit provided over an external 'dark fibre' (DWDM or similar) network
* A point to point wireless link between 2 buildings provided by a 3rd party
* Cross connections between 2 suites within a datacenter, via a meet me room

I imagine most people would argue these are private:

* All services are dedicated to you
* Traffic is isolated from other customers
* You control both ends of the connection

However, there are also risks, as they all pass through physical assets you don't control:

* Traffic interception; it has been widely published that data from the likes of Google has been intercepted and used for profiling activities
* Network access; As with a physical intrusion to your rack/office, it may be possible to gain network access via a cross-connect, or inter-site link, depending on topology
* Redundancy; A targeted attack on physical infrastructure could place your business operations at risk

Thankfully, most providers and many ISO standards have well defined physical access controls,
which limit the possibilities of the above; however that isn't very effective against a nation state,
or a cyber-based attack on a provider.

Many businesses have a wealth of information useful to a nation state, from habits and preferences
to medical or travel data. It might be paranoia, until they're out to get you.

Ultimately this comes down to risk management and if you want to be 'compliant' or 'secure'
in regards to your customer's data.

Assuming we want to encrypt data end-to-end, let's look at the technologies available.

TLS
===
As briefly noted above, the standard for encryption in the public network space is
[Transport Layer Security](https://en.wikipedia.org/wiki/Transport_Layer_Security)
(TLS).

There are multiple implementations of TLS, with 1.2 currently being the standard (1.3 is in draft),
the version and associated cryptographic ciphers are usually associated to the
support requirements; many older browsers and SSL libraries don't support the most
secure choices.

A good starting point is the excellent [cipherli.st](https://cipherli.st/) site,
highlighting secure configs for most platforms.

The results should then be checked, either using `openssl s_client`,
[ssllabs.com](https://www.ssllabs.com/) or similar.

Generally, user-facing TLS is simple to deploy, with the potential for
small compatibility issues (including breaking certain browsers).

The direction for [Google Chrome](https://security.googleblog.com/2016/09/moving-towards-more-secure-web.html) and others is to start displaying HTTP sites in
the same manner as invalid SSL is currently shown (red bars or similar), so it's
highly advisable even if you don't transmit any 'sensitive info' (sensitive here
 includes tracking data, such as cookies).

What about the cost? Platforms such as Lets Encrypt provide free SSL certs,
trusted by all major browsers. For dedicated extended validation certificates,
a few hundred dollars is a small cost for most online businesses.

## TLS internally

Historically concerns around performance of TLS have stunted the deployment internally,
modern versions of the libraries combined with the current generations of CPUs mean
TLS is not slow! (mostly).

The excellent [istlsfastyet.com](https://istlsfastyet.com/) goes into detail about
the current state of TLS performance. The key takeaway is, when configured
correctly, TLS at the scale of Facebook and Google performs fast enough with minimal
CPU overhead.

Using the most secure cipher suites (ECDHE) are a little more costly, but with mitigations in place
(HTTP keepalives, session resumption etc), the performance overhead is negligible.

Depending on your environment, you may purchase or use CA signed certificates
as is the case with external traffic, however at a certain scale an internal
certificate authority makes sense.

There is a certain level of complexity in deploying and maintaining a secure
internal certificate authority and many tools exist to help with this.

Another advantage of an internal CA is to be able to use certificate based
authentication for clients, enabling devices to prove their identity.

Alternatives
============
Depending on your environment, encrypting all inter-device traffic with TLS may
be possible.

Given a small load balanced LAMP stack this should be relatively easy:

* TLS from the user to the load balancer
* TLS from the load balancer to the web server
* TLS from PHP to MySQL

However, the number of services can easily spiral, given the example above
we could easily have:

* SMTP relays
* Memcache/Redis caching
* NFS based storage
* Monitoring agents

You may also have services which don't support TLS:

* RADIUS
* Windows Distributed File Shares
* Access control / CCTV systems designed for closed networks

There are 2 areas to consider here:

* Traffic passing over your network (Physical access restrictions in place)
* Traffic passing over external infrastructure

For the first case:

* I strongly suggest to deploy TLS where possible, at worst, it is another layer of
defence should a malicious device get into the network.
* For protocols lacking encryption support, their risk is likely low
  * If their risk is not low, I'd suggest re-evaluating the technology choice
  * Inline encryption is possible but complicated to scale at this level

For the second, we have a number of options described below.

### Layer 1 encryption
There are a number of 'black box' solutions, which sit in-line to the network.

The general principal is un-encrypted data comes in one end, encrypted data comes
out the other; the reverse then happens to give you un-encrypted data on the other end.

{% digraph layer 1 encryption %}
rankdir=LR;
subgraph cluster_SiteA {
  label = "Site A";
  color = black;
  "Router A";
}
subgraph cluster_EncryptedNet {
  label = "Encrypted Network";
  color = red;
  "Device A";
  "Device B";
}
subgraph cluster_SiteB {
  label = "Site B";
  color = black;
  "Router B";
}
"Router A" -> "Device A"
"Device A" -> "Device B"
"Device B" -> "Router B"
{% enddigraph %}

These are generally expensive appliances, licensed by port or bandwidth capability.
They are also generally completely closed boxes, operating strictly at layer 1.

Deployed across DWDM or similar networks, these devices should 'just work' and provide
full encryption (layer 1 to 7). They are limited to 'point to point' links.

A side effect of the point to point encryption is the prevention of unauthorised traffic.

### IEEE 802.1AE (MacSec)
A more open and industry standard approach would be to deploy MacSec.

MacSec provides encryption of the layer 2 header and up, but leaves the src/dest
mac addresses exposed.

It operates similar to an Ethernet frame within a layer 2 network, with the
packets containing 4 fields

{% digraph macsec header %}
subgraph cluster {
  rankdir=LR;
  height=1.5;
  "Destination MAC" [shape=square, height=1.5];
  "Source MAC" [shape=square, height=1.5];
  "Security TAG" [shape=square, height=1.5];
  "Encrypted Data" [shape=square, height=1.5];
  "ICV" [shape=square, height=1.5];
}
{% enddigraph %}

Any layer 2 data additional to the mac addresses (VLAN tag, LLDP etc) is contained
within the encrypted data.

The security tag and ICV are used internally for MacSec, with the mac addresses being
used for forwarding.

There is a hardware dependency associated to MacSec, as the encryption is done
in hardware to achieve line rate speeds. This varies between vendors, but can
be in the form of dedicated line cards or whole models.

It is possible to offload the encryption to MacSec capable switches,
allowing routers and line cards to remain, with the switch sitting inline.

{% digraph macsec encryption %}
rankdir=LR;
subgraph cluster_SiteA {
  label = "Site A";
  color = black;
  "Router A";
}
subgraph cluster_EncryptedNet {
  label = "Encrypted Network";
  color = red;
  "Switch A";
  "Switch B";
}
subgraph cluster_SiteB {
  label = "Site B";
  color = black;
  "Router B";
}
"Router A" -> "Switch A"
"Switch A" -> "Switch B"
"Switch B" -> "Router B"
{% enddigraph %}

It may not be desirable to put a layer 2 device in your path, though it is
likely that the path will already be using BFD or similar to account for
any provider interruptions, which don't result in an interface flap.

There are also some implementation considerations:

* Additional header size needs to be accounted for in downstream MTUs
* Certain providers filter layer 2 traffic, they may filter the MacSec control messages!

As with Layer 1 encryption, this prevents unauthorised traffic entering the network, as
well as protecting against interception.

### DMVPN / Mesh VPN
It may be desirable in some cases to form a software based VPN mesh over
your existing network, providing encryption between 2 or more points.

This could be in the form of a single IPSEC tunnel, or a complex hub spoke DMVPN
network. These could be deployed on dedicated devices or end user devices.

For high traffic applications, these approaches are likely not applicable, due to
line rate speeds being desirable, but in branch or remote worker applications
they can be powerful options in your toolbox.

{% digraph vpn mesh encryption %}
rankdir=LR;
"Device A" -> "Device B"
"Device A" -> "Device C"
"Device A" -> "Device D"
"Device A" -> "Device E"
"Device A" -> "Device F"

"Device B" -> "Device C"
"Device B" -> "Device D"
"Device B" -> "Device E"
"Device B" -> "Device F"

"Device C" -> "Device D"
"Device C" -> "Device E"
"Device C" -> "Device F"

"Device D" -> "Device E"
"Device D" -> "Device F"

"Device E" -> "Device F"
{% enddigraph %}

Summary
=======
There is not a 1 solution fits all. It is very dependent upon your
environment and more specifically the applications within it.

My advice is to look at the risk in each area, design an appropriate solution and
test it.

A targeted approach keeps things simple to start, but personally, I look to
provide end-to-end encryption everywhere... trusting no one.

If you have no clear areas of risk, start with everywhere you touch the outside
world, either via a public interface or provider managed services.
