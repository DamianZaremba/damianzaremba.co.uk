---
comments: true
layout: post
title: A Quick Look At Cisco Learning Network Premium/Cisco Learning Labs
tags:
- Network
- Cisco
- Learning
---

![]({% postfile cll-complex-mpls.png %})
![]({% postfile cll-complex-routing.png %})
![]({% postfile cll-home.png %})
![]({% postfile cll-labs.png %})
![]({% postfile cll-overview.png %})
![]({% postfile cll-simple-lab.png %})
![]({% postfile gns3-complex-mpls.png %})
![]({% postfile gns3-complex-routing.png %})
![]({% postfile gns3-complex-topology.png %})
![]({% postfile gns3-lab-clone.png %})
![]({% postfile gns3-simple-lab.png %})

CLL - 3 years old

Learning Network Premium - 10$/mo
4500 min (75h - 0.13 USD/hour) = ~2.5 hours/day (~0.33 USD/day) CLL time

comparable with virtual private servers
0.03 USD/hour @ Linode
0.02 USD/hour @ Bytemark & AWS


ICND1/ICND2 - 79$ (valid for 90 days, 71.10$ with Learning Network Premium. 5 hour extension 23$)
2100 min (35 h - 2.25 USD/hour) = ~27 min/day (0.60 USD/day) CLL time

CCNP ROUTE/SWITCH/TSHOOT, MPLS - 75$ (valid for 90 days, 67.50$ with Learning Network Premium. 5 hour extension 30$)
1500 min (25 h - 3 USD/hour) = ~16 min/day (0.48 USD/day) CLL time



CCIE Lab - considering the 1500 USD per attempt, combined with the cost of flights/hotels (unless you happen to live in Brussles) the 99USD R&S preassesment lab I'll definatly be taking a look at



gns3 hates:
* no switch emulation
* getting ios images and setting them up in gns3 is a huge pita
* resource usage
* complex topologies are nearly impossible

gns3 loves:
* flexiable topologies
* 'other' devices supported - can hook in lbs etc

ccl hates:
* static topologies
* useless for design/troubleshooting outside of prescribed labs
* time allocated per month
* interface emulation - everything is generic (ethernet interfaces) and lacking hardware specific features (config-register etc)
* no auto score/check feature
* price of ccie labs is insane
* seperate login details from normal cisco stuff
* the web interface is a little clunky

ccl loves:
* good objectives
* fixed topologies
* valid configs for answers
* highlighted sections of relevant documentation needed to complete the lab
* a few topic specific labs avaible (MPLS)

