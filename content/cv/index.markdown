---
layout: default
title: CV
description: Damian Zaremba's CV
---
Summary
-------
Experienced, driven and professional Linux Systems Engineer, constantly looking
to improve service and run at the edge of technology.

Passionate about complex high throughput distributed systems (especially low
latency/real time), solution design, testing, Linux, open source, monitoring,
metrics and graphing.

Interested in ITIL methodologies for service management, Agile methodologies for
development life cycle/work flows and software testing/building strategies.

Driven to impact change where required and deliver things done properly.

Employment History
------------------
### MUSIC Group - Software Engineer (Midas/Klark Teknik)
*July 2013 - Current*

Working on new Midas/Klark Teknik products and supporting infrastructure.

* Deployed an isolated 3 node (2 HA controllers) Openstack Havana set-up using NetApp ONTAP storage.
* Designed and implemented a small 'collapsed-core' network architecture - using Cisco technologies - to provide an isolated R&D network, inside an existing (insecure) corporate network.
* Performed data recovery on R&D servers/data and developed workarounds for internal services during a 4 month long global TECH service failure.
* Developed a testing jig for boards using a raspberry PI with GPIO controlled relays, for automated boot loader re-programming and boot timing on changes.
* Developed and implemented backup/restore procedure for critical data (source code, tickets, build configurations).
* Rearchitected the current 2 server set-up (unmonitored, running on raid 0, constrained by disk/CPU) into a 3 node Openstack set-up and re-purposed older servers (removed from service during a transition from CVS to Git) as disposable build agents.
* Implemented configuration management (Puppet, Salt stack) and service/change monitoring (Icinga/Rancid).
* Reduced build times and implemented a new strategy for multi component builds.
* Designed a framework and strategy for increasing confidence in code and speeding up the release cycle.
* Developed software against x86, STM32 and ARM based platforms, including control for switches/FPGAs/DSPs
* Exposure to proprietary binary based communications protocols and their pitfalls vs open, standards based communications protocols and their benefits
* Performed maintenance on LFS and Ltib systems for building products
* Debugged and rectified issues in C++/Python/Perl code and shell/Sed/Awk scripting
* Investigated web technologies, updating/deployment methodologies, RFB reverse tunnelling, SELinux and performance analysis/containment.
* Utilised kernel features to enhance new products (control groups, SELinux, nftables)
* Documented processes for developers (board reprogramming/power up/hardware interfaces)
* Ported numerous internal applications from x86 to ARM
* Managed Atlassian developer tools (Jira, Stash, Bamboo, Fisheye)

### MUSIC Group - Systems Engineer (Global Enterprise Engineering)
*Oct 2012 - July 2013*

Supporting world-recognized pro audio brands such as MIDAS, Klark Teknik, Turbosound, Behringer and Bugera.

* Mixed Operations/engineering role covering all levels of the infrastructure.
* Managing a complex heterogeneous infrastructure based upon VMware.
* Implementing service monitoring and metric collection systems (MRTG, Smokeping, Icinga, Graphite, PRTG).
* Troubleshooting layer 2/3 network issues across multiple sites (combination of P2P MPLS links (L2 & 3), MPLS cloud and GRE tunnels connected via a mix of OSPF and static routes).
* Developed custom integration (Icinga to Service Desk for ticketing, Pager duty acknowledgements to Icinga acknowledgements for alerts), plugins (VMware hardware checking, Oracle ESSO transaction level checking) and templates (network devices, server roles etc.) for monitoring systems.
* Developed a custom roster system based around email DL's for Openfire, based on business requirements.
* Developed numerous scripts for auditing and policy enforcement purposes.
* Automated manual tasks to increase reliability.
* Maintained bin log based replication on multiple MySQL clusters.
* Dealt with multiple outages relating to VMware/DNS/Network/Disk availability.
* Developed strategies for operating system deployment and management globally.
* Packaged and maintained numerous pieces of software into DEB and RPM files for distribution.
* Developed strategies for enforcing change control within a configuration management set-up (gating/testing changesets, peer review, environment isolation).
* Diagnosed multiple issues with an Oracle ESSO deployment.
* Implemented RANCID based backups for network device configurations.

### Freelancer: Architecture, Infrastructure, Linux Deployment, Network Design, Software Development
*Nov 2008 – Current*

End to end management and design of infrastructure, heavily Linux and Network focused.

Provide software development as required (Python, Perl, PHP, C, C++, Shell, node.js, Django, Ruby), all custom work - some open source. Primary focus on Python (including Django), Perl, Shell and C++.

Deployed Linux solutions at edge and core, covering all aspects from SOHO up to multi datacenter. Areas including PXE, kickstart/preseed, Puppet, Cobbler, Salt stack, asset tracking, life cycle management, testing, custom Linux distributions and bespoke auditing tools.

Designed networks to specification (cost or functionality), familiar with large layer 2/3 deployments including STP, DTP, LACP protocols, vlan tagging, trunking, layer 2 protections (ARP, DHCP, BPDU guard), static routing, dynamic routing (RIP, OSPF, EIGRP, BGP), MPLS (P2P and 'cloud'), QOS, ASA firewalls, ACL management, redundancy, performance optimisation, asynchronous routing, remote troubleshooting, issue diagnostics (layer 1-8) and vendor interaction/management (global).

Re-designed and migrated data-centre architecture for hosting providers and global companies including co-ordination with on-site resources for physical relocation, design and implementation of redundant core and distribution network services, designing SPOFs out, isolating management connectivity into segregated failure domains (physically, up to a separate BGP mix with different routes), design of troubleshooting tools for help desk staff, auditing equipment, implementation of off-site backup arrangements, low level migration tools (redirection of network traffic to holding servers, DDOS protection, distributed caching, automated null-routing tools, automated firewall rule distribution tools), power usage profiling and cost reduction.

### Sub 6 Limited - Lead Systems Administrator
*Oct 2011 - Aug 2012*

* Lead the system administration/management side of the UK/US based managed hosting companies.
* Handled escalated issues, complex solutions, monitoring and reporting
requirements.
* Integrated multiple services into the asset management system to cut down on
manual sets and automate process.
* Introduced continuous integration into the development work flow.
* Rolled out Puppet for configuration management.
* Handled configuration of the switched network (trunk/access ports, vlans etc.).
* Rolled out LDAP and Radius for centralized authentication.
* Developed custom features for Kayako and WHMCS.
* Introduced Graphite and exposed monitoring metrics to clients.
* Increased security across the entire platform (PBX, DNS, Billing, client
servers).
* Implemented rolling password changes on a twice weekly basis.
* Custom built an IP based FTP access manager.
* Custom built a version manage for 4 PHP versions.
* Custom built a gatekeeper service to display holding pages for clients during
a datacenter move.
* Developed numerous custom solutions for clients.

### AllGamer, LLC - Freelance systems administrator and developer
*November 2010 - September 2011*

* Advised on system automation and maintenance.
* Integrated systems into the CRM.
* Assisted in service issue diagnostic and resolution.
* Assisted on service and metric monitoring (Nagios, SNMP, RRDTool, SmokePing).
* Development of community tools.
* Programming of system utilities.

### Calyx - Unix/Linux systems administrator
*April 2011 - May 2011*

* Responsible for a RHEL5 RHCS set-up.
* Managed Apache, TomCat, JBos, Orcale 10G, MySQL.
* Provided on-call support.
* Provided users support in a third line capacity.
* Successfully identified and resolved memory leaks within the application
servers.
* Managed Xen and Citrix Xenserver deployments.
* Debugged tomcat logs to identify root causes of application issues.
* Implemented process monitoring of background workers to ensure a responsive application.

### CloudFlux - Systems Engineer/Developer
*October 2010 – May 2011*

* Implemented service monitoring and performance graphing.
* Developed a management framework.
* Automated management tasks.
* Managed backups of multiple servers.
* Provided users support in a second/third line capacity.
* Migrated from Xen to KVM.
* Managed a KVM based virtual host.
* Migration of SVN to Git.

### UKFast - Linux Engineer
*Feb 2010 – Oct 2010*

* Provided support in a 3rd line capacity.
* Handled technical pre-sales and server set-up.
* Maintained SLAs.
* On-Call/Out of hours work.
* Managing custom platforms, cPanel, Plesk, IIS, Apache, HAProxy, Nginx, LVS.
* Configured and managed multiple Database and File replication solutions.
* Dealt with multiple, geo-graphically redundant sites with solutions spanning
across 2 or more.
* Handled network and power issues on a datacenter level.
* Solely responsible for investigating and resolving alerts during out of hours.

### Rawr IRC - Developer
*December 2009 – October 2010*

* Developed a custom services framework.
* Integrated social media and forums into IRC.
* Designed user engagement tools, such as live mapping of activity.
* Wrote multiple maintenance scripts.
* Managed 2 UnrealIRCd nodes.

### Xinos - Network Administrator
*January 2009 – February 2010*

* Start-up offering shared hosting to Geeks.
* Provided managed Shoutcast, DNS and Web hosting.
* Maintained a KVM and XEN based virtualisation environment.
* Managed Nginx, Varnish, Bind9, MySQL, Exim, cPanel.
* Automated parts of the account management system.
* Integrated services for abuse monitoring.
* Wrote custom resource accounting and file scanning services.

### NYCC - Desk side support
*Oct 2008 – March 2009*

* Provided 'hands on' support to end users.
* Delivered hardware upgrades.
* Performed device installation/configuration.
* Assisted in large scale network upgrades.
* Worked with multiple teams to ensure issues where resolved.
* Handled the configuration of PGP based encryption for remote devices.
* Working across the county individually and as part of a team.

Education
-------------
### Firebrand Training
*2010*

I completed a number of courses at Firebrand to expand my knowledge on computer security and hardware fundamentals.

This resulted in my gaining Comptia A+, CEH and LPIC level 1/2 certifications.

### Rossendale School
*2002 - 2009*

I completed GCSEs in ICT (A), Mathematics (D) and key skills exams.

In my spare time I also assisted in the network administration, involving a single windows server 2003 DC,
two Linux servers and around 50-70 desktops running a mix of windows 2000 and XP pro.

This involved me writing numerous scripts (bat/vbs) to do simple actions such as mapping drives or configuring proxies via group policy.

Volunteering experience
-----------------------
### FOSDEM volunteer
*January 31st 2014 - 2nd February 2014*

* Assisted with the build out for FOSDEM, prior to the event.
* Assisted with the clean up of the ULB in Brussels, post FOSDEM.
* Assisted with any misc tasks as required during the conference, based on organiser requirements.
* Assisted with the initial video editing for Saturday's raw footage.
* Moderated multiple talks (keynotes/main tracks) in the Jason building (1400 seat capacity).
* Worked with a multi-national team of volunteers (50+) to help deliver 512 talks over 22 rooms in 2 days.

### The Scout Association
*December 2006 - January 2014*

* Assistant Scout Leader.
* Assist with program creation and delivery.
* Teach new skills.
* Perform building and equipment maintenance.
* Ensure meetings take place safely.
* Activity instructor for climbing.
* Completed training for First Aid, Climbing, Safeguarding and Leadership
* Assist local camp sites, district, county and groups at large events.

References
----------
Available upon request.

Misc
----
* Full UK driving license.
* UK passport.
* Available out of hours.

See Also
--------
* [GitHub](https://github.com/damianzaremba) - damianzaremba
* [Last.fm](http://last.fm/user/damianzaremba4) - damianzaremba4
* [LinkedIn](http://uk.linkedin.com/in/damianzaremba) - damianzaremba
* [Website](http://damianzaremba.co.uk) - damianzaremba.co.uk


Other Formats
-------------
Available on [GitHub](https://github.com/DamianZaremba/cv)
