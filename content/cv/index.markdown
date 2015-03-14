---
layout: default
title: CV
description: Damian Zaremba's CV
---
Summary
-------
A driven Linux focused sysadmin constantly looking to improve service and run at the edge of technology.

Passionate about networking, architecture, complex distributed systems, solution design,
testing, automation, Linux, open source, monitoring, metrics and graphing.

Interested in Agile methodologies for development life cycle/work flows
and software testing/building strategies.

Driven to impact change where required and deliver things done efficiently and effectively.

Employment History
------------------
### TravelJigsaw (rentalcars.com) - Linux Systems Administrator
*February 2014 - Present*

Working in a team of 3 sysadmins maintaining, tuning and updating the 1k+ servers that make up the infrastructure.

* Manage/deploy a heterogeneous infrastructure consisting of bare metal rack mount and blade servers
(HP/Dell) alongside VMWare ESX, KVM, Docker and EC2 based instances
* Refactored a Puppet 2.x setup into a Puppet 3.x setup using the latest language standards and a
principle of state convergence on first run
* Support the internal tools written in Python/Ruby including the Django based asset management tool
* Provide out of hours support to the business via an 'on-call' rota
* Introduced CI to operations for RPM builds and puppet testing
* Re-designed the core network to be a fabric based setup
* Coordinate with datacenter and network teams to ensure changes are completed as required by the business
* Deployed anti-virus scanning and DKIM signing of outbound messages using Exim routers to ensure
external facing email meets validation/verification levels requested by the business
* Developed multiple fabric based scripts for real time auditing and remediation of servers
(firmware versions, log file cleanup etc)
* Troubleshooted multiple issues over php-fpm, Tomcat, Java 7/8, Nginx, Apache & F5 setups
* Champion the use of upstream packages and versions of core software
* Worked closely with development teams to test new software and build a path into production
* Developed kickstart files and custom initrd files for server installation
* Developed acceptance tests for hardware using PyUnit and Fabric

### MUSIC Group - Software Engineer (RnD - Midas/Klark Teknik)
*July 2013 - February 2014*

Working on new Midas/Klark Teknik products and supporting internal R&D infrastructure.

* Deployed an isolated 3 node (2 HA controllers) Openstack Havana set-up using NetApp ONTAP storage.
* Designed and implemented a small 'collapsed-core' network architecture - using Cisco technologies
- to provide an isolated R&D network, inside an existing (insecure) corporate network.
* Performed data recovery on R&D servers/data and developed workarounds for internal services during
a 4 month long global TECH service failure.
* Developed a testing jig for boards using a raspberry PI with GPIO controlled relays, for automated
boot loader re-programming and boot timing on changes.
* Developed and implemented backup/restore procedure for critical data (source code, tickets, build
configurations).
* Rearchitected the current 2 server setup (unmonitored, running on raid 0, constrained by disk/CPU)
into a 3 node Openstack setup and re-purposed older servers (removed from service during a transition
from CVS to Git) as disposable build agents.
* Implemented configuration management (Puppet), service orchestration (Salt stack) and service/change
monitoring (Icinga/Rancid).
* Reduced build times (14 hours to 40min) and implemented a new strategy for multi component builds.
* Drove continuous deployment methodologies into new product design
* Designed a framework and strategy for increasing confidence in code and speeding up the release cycle.
* Developed software against x86, STM32 and ARM based platforms, including control for switches/FPGAs/DSPs
* Exposure to proprietary binary based communications protocols and their pitfalls vs open, standards
based communications protocols and their benefits
* Performed maintenance on LFS and Ltib systems for building products
* Debugged and rectified issues in C++/Python/Perl code and shell/Sed/Awk scripting
* Investigated web technologies, updating/deployment methodologies, RFB reverse tunnelling, SELinux
and performance analysis/containment.
* Utilised kernel features to enhance new products (control groups, SELinux, nftables)
* Documented processes for developers (board reprogramming/power up/hardware interfaces)
* Ported numerous internal applications from x86 to ARM
* Managed Atlassian developer tools (Jira, Stash, Bamboo, Fisheye)

### MUSIC Group - Systems Engineer (Global Enterprise Engineering)
*October 2012 - July 2013*

Supporting world-recognized pro audio brands such as MIDAS, Klark Teknik, Turbosound, Behringer and Bugera.

* Mixed Operations/engineering role covering all levels of the infrastructure.
* Managed a complex heterogeneous infrastructure based upon VMware.
* Implementing service monitoring and metric collection systems (MRTG, Smokeping, Icinga, Graphite, PRTG).
* Troubleshooting layer 2/3 network issues across multiple sites (combination of P2P MPLS links (L2 & 3),
MPLS cloud and GRE tunnels connected via a mix of OSPF and static routes).
* Developed custom integration (Icinga to Service Desk for ticketing, Pager duty acknowledgements to
Icinga acknowledgements for alerts), plugins (VMware hardware checking, Oracle ESSO transaction level
checking) and templates (network devices, server roles etc.) for monitoring systems.
* Developed a custom roster system based around email DL's for Openfire, based on business requirements.
* Developed numerous scripts for auditing and policy enforcement purposes.
* Automated manual tasks to increase reliability.
* Maintained bin log based replication on multiple MySQL clusters.
* Dealt with multiple outages relating to VMware/DNS/Network/Disk availability.
* Developed strategies for operating system deployment and management globally.
* Packaged and maintained numerous pieces of software into DEB and RPM files for distribution.
* Developed strategies for enforcing change control within a configuration management set-up
(gating/testing change sets, peer review, environment isolation).
* Diagnosed multiple issues with an Oracle ESSO deployment.
* Implemented RANCID based backups for network device configurations.

### Freelancer: Architecture, Infrastructure, Linux Deployment, Network Design, Software Development
*November 2008 - Current*

End to end management and design of infrastructure, heavily Linux and Network focused.

Provide software development as required in Python (including Django), Perl, PHP, C++ & Ruby. Primary
focus on extending open source solutions and API services.

Previously deployed Linux solutions at edge and core, covering all aspects from small office up to
multi datacenter setups. Solutions including PXE (kickstart/preseed/Cobbler), Katello, Puppet,
Saltstack, asset tracking, lifecycle management, testing, custom Linux distributions and bespoke
auditing tools.

Designed networks to specification (cost or functionality), familiar with large layer 2/3 deployments
including STP, DTP, LACP protocols, vlan tagging, trunking, layer 2 protections (arp, dhcp, bpdu guard),
static routing, dynamic routing (RIP, OSPF, EIGRP, BGP), MPLS (L2 and L3 VPNs, LSPs), QOS, ASA firewalls,
ACL management, redundancy, performance optimisation, asynchronous routing, remote troubleshooting,
issue diagnostics (layer 1-8) and vendor interaction/management (global).

Re-designed and migrated data-centre architecture for hosting providers and global companies including
co-ordination with on site resources for physical relocation, design and implementation of redundant
core and distribution network services, designing single points of failure out, isolating management
connectivity into segregated failure domains (physically, up to a separate BGP mix with different routes),
design of troubleshooting tools for helpdesk staff, auditing equipment, implementation of off-site backup
arrangements, low level migration tools (redirection of network traffic to holding servers, DDOS protection,
distributed caching, automated route adjustment tools, automated firewall rule distribution tools),
power usage profiling and cost reduction.

### Sub 6 Limited - Lead Systems Administrator
*October 2011 - August 2012*

* Lead the system administration/management side of the UK/US based managed hosting companies.
* Handled escalated issues, complex solutions, monitoring and reporting requirements.
* Integrated multiple services into the asset management system to cut down on manual sets and
automate process.
* Introduced continuous integration into the development work flow.
* Rolled out Puppet for configuration management.
* Handled configuration of the switched network (trunk/access ports, VLAN's etc.).
* Rolled out LDAP and Radius for centralized authentication.
* Developed custom features for Kayako and WHMCS.
* Introduced Graphite and exposed monitoring metrics to clients.
* Increased security across the entire platform (PBX, DNS, Billing, client servers).
* Implemented rolling password changes on a twice weekly basis.
* Designed and developed an in-house (customer facing) IP based FTP access manager.
* Designed and developed a bespoke (customer facing) version manager for 4 PHP versions.
* Developed a gatekeeper service to display holding pages for clients during a datacenter move.
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
* Managed Apache, Tomcat, JBos, Orcale 10G, MySQL.
* Provided on-call support.
* Provided users support in a third line capacity.
* Successfully identified and resolved memory leaks within the application servers.
* Managed Xen and Citrix Xenserver deployments.
* Debugged tomcat logs to identify root causes of application issues.
* Implemented process monitoring of background workers to ensure a responsive application.

### CloudFlux - Systems Engineer/Developer
*October 2010 - May 2011*

* Implemented service monitoring and performance graphing.
* Developed a management framework.
* Automated management tasks.
* Managed backups of multiple servers.
* Provided users support in a second/third line capacity.
* Migrated from Xen to KVM.
* Managed a KVM based virtual host.
* Migration of SVN to Git.

### UKFast - Linux Engineer
*February 2010 - October 2010*

* Provided support in a 3rd line capacity.
* Handled technical pre-sales and server set-up.
* Maintained SLAs.
* On-Call/Out of hours work.
* Managing custom platforms, cPanel, Plesk, IIS, Apache, HAProxy, Nginx, LVS.
* Configured and managed multiple Database and File replication solutions.
* Dealt with multiple, geographically redundant sites with solutions spanning across 2 or more.
* Handled network and power issues on a datacenter level.
* Solely responsible for investigating and resolving alerts during out of hours.

Professional certifications
---------------------------
* LPIC-1 - LPI000199836 (dxaf9wwwdt) - Expires April 2015
* LPIC-2 - LPI000199836 (84nk9rech3) - Expires April 2015
* Certified Ethical Hacker v6 - Expired December 2013

Volunteering experience
-----------------------
### FOSDEM volunteer
*January 31st 2014 - 2nd February 2014*

* Assisted with the build out for FOSDEM, prior to the event.
* Assisted with the clean up of the ULB in Brussels, post FOSDEM.
* Assisted with any misc tasks as required during the conference, based on organizer requirements.
* Assisted with the initial video editing for Saturday's raw footage.
* Moderated multiple talks (keynotes/main tracks) in the Jason building (1400 seat capacity).
* Worked with a multinational team of volunteers (50+) to help deliver 512 talks over 22 rooms in 2 days.

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
* UK driving licence.
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
