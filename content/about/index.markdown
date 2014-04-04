---
layout: default
title: About
description: About Damian Zaremba
---
<img src="https://s.gravatar.com/avatar/5eb437aa4368d29386cb6f0ed8e6c5b4?s=250" style="float: left; height: 250px; margin-right: 10px" />

Damian is a Linux sysadmin at heart, with a deep desire to automate systems and scale platforms.

Experience in a wide variety of operational, engineering, research and development roles have empowered Damian to design and implement infrastructure solutions that meet business requirements at reduced cost and complexity.

With a passion for complex/distributed systems, automation, solution design, testing strategies, Linux, open source methodologies, monitoring, metrics, graphing and AI, Damian is a strong asset to any team looking to architect, implement and scale infrastructure while ensuring continuous service delivery.

Damian's skills include Linux (OS level debugging, performance tuning etc.), layer 2/3/4 network design and application implementations across a large set of technologies.

Take a look at Damian's [CV](/cv) for more information and work experience.

A few places that Damian can be found online are below

[![Twitter](/assests/images/logos/twitter.png)](http://twitter.com/DamianZaremba)
[![Facebook](/assests/images/logos/facebook.png)](http://facebook.com/DamianZaremba)
[![LastFM](/assests/images/logos/lastfm.png)](http://lastfm.com/user/DamianZaremba4)
[![LinkedIn](/assests/images/logos/linkedin.png)](http://uk.linkedin.com/in/damianzaremba)
[![YouTube](/assests/images/logos/youtube.png)](http://www.youtube.com/user/DamianZaremba)

Interested? What's Damian Looking For?
--------------------------------------
Damian is looking for opportunities to work with bleeding edge technologies that empower the end users to achieve anything
they can imagine.

This breaks down into multiple levels, but essentially fits into 3 areas.

### Providing technologies that are easily accessible and affordable to everyone.
Aimed at people building their own platforms with reduces operational overhead/requite rapid scaling.

Have easily usable APIs with lots of documentation and SDKs available, sensible billing strategies and good SLAs.

Remove the need for developers to spend their time doing operations, think Redshift from AWS or similar.

### Providing well designed service implementations to end users.
Aimed at people who don't want to build their own thing.

Think wordpress.com or gmail.com, amazing platforms that are rock stable, people love to use and are simple.

Anyone can have a blog or an email account by just clicking buttons, that's hugely empowering.

### 'Real' managed service.
Lots of companies do 'managed service', install a server for you, stick some monitoring on it, fix it when it breaks.

Managed services tend to fall into 2 categories:

* No changes are made after implementation as the risk it deemed too high
* Rolling updates are applied with little/no understanding of the service interaction

What about owning the whole service from day 1? Write implementation specific integration tests, have everything in configuration management, understand what is important in the implementation, develop SLAs for each component based on the impact analysis.

Monitoring then comes directly from the integration tests and SLAs for components. Collect all the metrics, graph them, proactivly review them in aggregate, have systems that flag up strange things happening. Handle problems with cold, hard numbers right at your finger tips.

Once the solution is up and running it can be (mostly) managed automatically or semi-automatically.

When thinking in configuration management, don't think in services but think in systems. General system package updates can affect applications, running 2 applications with conflicting requirements is a whole other challenge. Make sure systems can be put back to exactly where they are, including security updates. Letting a system update its self is outside of managing that system - need a security patch? Have a system detect that, update the configuration management system and do an upgrade task (as below).

Need to perform software upgrades?

1. Spin up a clone of the production set-up from configuration management in a private cloud
2. Apply the updates to the clone via configuration management
3. Have monitoring validate the clone's services are up (via service monitoring)
4. Have monitoring validate the clone is functional (via the integration tests)
5. Spin down the clone and perform the upgrades on Production (or just swap instances if all virtual)

If something still goes wrong?

1. Roll back the production servers to the previous point in configuration management
2. Roll the database back to the snapshot (if required, really try to use a schema that works across application versions... since at scale not everything is consistent if you want 0 downtime updates)
3. Write tests to cover what was deemed broken
4. Start the upgrade steps from scratch

This must be a better, more stable way of rolling updates. Lots of companies follow a similar model internally, but Damian is convinced this can be applied to managed service and will become the next generation of managed service.


Damian would also love to be able to spend more time working on open source software and interacting with the fantastic communities around the world, even if this means just having more free time to spend on those activities.
