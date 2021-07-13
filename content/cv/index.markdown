---
layout: default
title: CV
description: Damian Zaremba's CV
---
I enjoy interesting problems at scale, mostly involving networking.

((Systems + Networking) + Business requirements = Positive business impact) == <3

Summary
-------
Network/Linux focused engineer constantly looking to improve service and run at the edge of technology.

Passionate about networking, architecture, automation, testing, open-source, monitoring and training.

Driven to impact change where required and deliver things done efficiently and effectively.

Employment History
------------------
### Infra Bits - Freelance network/systems engineer & trainer
*April 2021 - present*

* PADI/TecRec training
* EFR training
* Network consultancy
* Software development

_Not currently looking for a long term position._

### Fastly - Senior Network Engineer
*September 2018 - April 2021*

Focused on the automation, management, expansion & improvement of AS54113 (FSLY) as part of the network reliability engineering team. During this time the network grew from 37T to over 130T of capacity, with new generations of topologies.

Responsibilities included:

* Management/development of the global configuration state & traffic engineering posture
* Building tooling for automation of repetitive tasks and safety in operations
* Integration of systems for optimisation of processes & data de-duplication
* Planning for and execution of large customer events
* Extension of existing critical systems for new business requirements
* Migration and/or replacement of legacy systems/topologies
* Troubleshooting complex technical issues/interactions
* Evaluating and designing technical integrations of systems
* Subject matter expert for operational & engineering teams (on-call escalation)
* Provisioning & testing of new architectures

Achievements include:

* Extensive improvements to topology & business logic validation frameworks, preventing common configuration issues
* Migration of a legacy route server platform into an extensively tested CI driven platform, removing significant amounts of business risk
* Extending integration of IPAM services into Chef data providers/helpers, removing significant operational friction & risk
* Integration of internal systems into industry-standard platforms such as PeeringDB, IRRD & RADB, reducing operational overhead
* Porting of core Ansible based configuration management tooling into Python 3.x from 2.x, ensuring continued maintainability
* Implementation of alerting for and debugging of network-level performance events (packet loss, RTT deviation)
* Extension of operator tooling to perform validation of actions, for example preventing accidental withdrawal of unicast prefixes from a site
* MTU sizing correction, deployed across thousands of machines, improving IPv6 reachability to numerous networks
* ACL restructuring, resulting in higher hardware efficiency while providing improved abstractions for operators & auditors
* Development, testing and deployment of internal IPv6 BGP & IGP topologies, ensuring redundant connectivity
* Implementation & deployment of IPv6 policy control, resulting in significant customer-facing performance improvements
* Numerous improvements to internal systems across an array of languages & domains, minimising business risk & operational overhead

### Booking.com - Network Engineer
*September 2016 - September 2018*

Focused on the design, engineering and management of AS43996 & AS202196, powering Booking.com & Rentalcars.com (BKNG) globally.

Responsibilities included:

* Management of the global routing policies
* Extending/managing peering relationships and transit selections
* Hardware upgrades and maintenance in a non-stop manner
* Deployment of new POPs
* Ensuring adequate capacity and redundancy
* Testing and implementing new technologies as required (EVPN, IPFIX etc)
* Developing tooling and processes required to manage the global deployment
* Supporting network tooling and authentication services for all network teams within Booking.com
* Participating in the on-call rotation covering all production networks
* LIR administration

Achievements included:

* Management of all network tooling services in Puppet
* Port of existing IPFIX/Netflow v5 decoders into Go reducing resource usage and custom code significantly
* Peer/IX selection/management tooling using flow and latency data for business/data-focused decisions
* Internal tooling integration with PeeringDB
* Implementation of real-time TCP latency monitoring tooling
* Implementation of POP performance measurement tooling (deployed to customer/partner facing apps)
* Introduction of Kafka and Hadoop technologies for data processing
* Introduction of OpenBMP and RPKI validators to aid troubleshooting/leak prevention
* Development of Ansible based configuration management with integration into existing data sources
* Automation of manual processes (lab router firmware version changes, dashboard creation, route filter management etc)
* First internal team to have IPv6 enabled management for all devices
* Improvements to the GeoDNS backend including EDNS0 support

As an extension to this role, I also provided design/engineering support to and act as an escalation point for BookingGo (Rentalcars.com) teams on an ad-hoc basis, including on the integration of infrastructure.

### TravelJigsaw Limited (Rentalcars.com) - Principal Security Engineer
*November 2015 - September 2016*

Focused on improving all technical aspects of the security landscape.

Worked closely with Legal, Finance, Technology and Security teams in the business to deliver security objectives.

Several large undertakings were completed successfully including:

* Achieving a ~65% reduction in external-facing vulnerabilities while observing a ~44% increase in assets
* Deploying an internal certificate authority and root certificates (ca-bundle + JKS files) to 800+ servers
* Developing tooling in Puppet for firewall rule management and deployed a restrictive rule-set
* Deploying OpenLDAP using SSSD & pam_access to 800+ servers for centralised authentication and access control
* Built tooling around Nexpose, Serverspec & Test Kitchen for integration into CI pipelines
* Implementing internal vulnerability scanning of ~2000 assets
* Developing CSP/HPKP functionality and servlet filters for external-facing applications, including reporting functionality to assess the impact of policy/filter changes
* Developing tooling for automated server patching (including staged rollouts + reporting)
* Developing tooling for rotating encryption keys on 10+ million data entries in a fast and minimally impactful manner
* Deploying a horizontally scalable (Anycast + Resilient ECMP based) load balancing implementation using HAProxy to support migrating all external traffic to use TLS
* Provided expert support to other teams in the business, ensuring their designs were both secure and scalable

More day to day operational items included:

* Introducing hiera-eyaml (using the GPG backend) and node_encrypt into Puppet (3.x), for improved configuration secrets handling
* Deploying SELinux in targeted mode to all 'critical infrastructure' (including in PCI/PII zones and core infrastructure)
* Developing security tooling with appropriate access controls for common activities such as managing OSSEC alerts, reporting on user access and changing on-call settings
* Developing Python tooling for handling inventory changes in 'black box' security appliances
* Performing reviews on proposed solutions and technical aspects of legal contracts
* Providing security on-call coverage
* Standardising firewall rules across multiple Juniper SRX clusters
* Working with external and internal auditors to improve controls and ensure (SoX, PCI DSS, DPA, Privacy Shield) compliance
* Developing abstractions in Puppet for managing pam_access and sudo (group) based access rules, with inheritance
* Drafting a roadmap and key milestones for security enhancements

### TravelJigsaw Limited (Rentalcars.com) - Technical Architect
*June 2015 - November 2015*

As a founding member of the architecture team, my initial focus was a review of the core systems, potential contention/failure points and a roadmap for core infrastructure.

The work was varied and included documenting existing systems, interviewing candidates for multiple roles, providing expert support during service issues/solution design, building software prototypes, working with the teams to establish standards and designing new solutions.

As the only infrastructure-focused member of the team, a lot of alignment and collaboration with the 2 software architects was undertaken during this time.

Some key solutions that were designed and placed into production included:

* Internet connectivity, resolving redundancy issues and providing future scalability; this established the first ASN and IP space directly held by the company
* AWS direct connect for hybrid (test/development) environments; a successful PoC, now supporting multiple teams and production services
* 'Event backbone' using Apache Flume and Kafka with custom consumers written in Java; a successful PoC handling millions of events a minute. This is now the standard way to transmit/consume events within the company and has a diverse set of backends (ElasticSearch, MySQL, AppDynamics, HDFS etc)

Other outcomes included:

* An 18-month roadmap/improvement plan for the network
* Numerous risks identified within the technology landscape and prioritised for resolution with the engineering teams
* Implementation of Bamboo for CI, including multiple example jobs and Java-based plugins
* Implementation of Artifactory Pro for internal binary sharing (integrated into Bamboo and internal deployment systems)
* Updated design for a multistage Clos architecture within the data centres, with the budget accepted

### TravelJigsaw Limited (Rentalcars.com) - Linux Systems Administrator
*February 2014 - June 2015*

Working in a team of 3 DBAs, 3 Sysadmins and a Network operations engineer scaling out and managing the 1k+ of servers that make up the Rentalcars.com infrastructure.

* Managed/deployed a heterogeneous infrastructure consisting of bare metal rack mount and blade servers (HP/Dell) alongside VMWare ESX, KVM, Docker and EC2 based instances
* Refactored a Puppet 2.x setup into a Puppet 3.x setup using the latest language standards and
the principle of state convergence on the first run
* Supported the internal tools written in Python/Ruby, including the Django-based asset management tool
* Provided out of hours support to the business via an on-call rota
* Introduced CI to operations for RPM builds and Puppet testing
* Deployed anti-virus scanning and DKIM signing of outbound messages using Exim routers to ensure external-facing email meets validation/verification levels requested by the business
* Developed multiple Fabric scripts for real-time auditing and remediation of servers (firmware versions, log file cleanup etc)
* Worked closely with development teams to test new software and build a path to production
* Developed kickstart files and custom initrd files for hardware installation (including automated firmware updates)
* Developed acceptance tests for hardware using PyUnit and Fabric

A part of this role involved building the initial infrastructure for Car+Driver (Rideways.com); a startup within the company.
This was accomplished using:

* AWS EC2/S3/RDS/Cloudfront/Cloudformation/ElastiCache
* Python (troposphere) based CloudFormation generation
* Python (boto) based deployment scripts, for CloudFormation and CodeDeploy
* Packer + Puppet (masterless) based AMI creation
* Github + Bamboo for CI/CD

### MUSIC Group - Software Engineer (Midas/Klark Teknik R&D)
*July 2013 - February 2014*

### MUSIC Group - Systems Engineer (Global Enterprise Engineering)
*October 2012 - July 2013*

### Sub 6 Limited - Lead Systems Administrator
*October 2011 - August 2012*

### Various - Contract Systems Administrator
*October 2010 - October 2011*

Volunteering experience
-----------------------
### Scuba Education Amsterdam - Staff / PADI instructor
*2018 - Present*

* Provide in-classroom and in-water training to students at multiple levels
* Operation of the filling station & equipment servicing/management
* PADI member & certified instructor in more than 15 areas

### ClueBot NG - Maintainer
*2012 - Present*

* Heavily used anti-vandalism Wikipedia bot with over 5.7 million edits
* Monitor ClueBot NG to ensure active reversion of vandalism
* Perform code fixes and improvements to reduce errors

### FOSDEM - volunteer
*January 31st 2014 - 2nd February 2014*,
*January 29th 2016 - 31st January 2016*,
*February 2nd 2018 - 4th February 2018*

### The Scout Association - Assistant Scout Leader / Climbing Instructor
*December 2006 - January 2014*

Misc
----
* UK passport holder
* NL driving license
* NL resident

See Also
--------
* [GitHub](https://github.com/damianzaremba) - damianzaremba
* [LinkedIn](http://uk.linkedin.com/in/damianzaremba) - damianzaremba
* [Website](http://damianzaremba.co.uk) - damianzaremba.co.uk


Other Formats
-------------
Available on [GitHub](https://github.com/DamianZaremba/cv/)
