---
comments: true
layout: post
title: Decoding Arista EtherType headers with gopacket
tags:
- Network
- How-to
- Go
status: pending
---

As we [previously discussed](/2017/12/a-look-at-low-cost-tap-aggregation/),
using cheap switches to aggregate multiple tap sources gives you a lot of power.

However, given the multiple feeds, how can you measure timing information accurately 1 hop away?

Using hardware time stamping provides a highly accurate record of when packets
were processed by devices, making it perfect for TAP aggregation.

Revisiting the 7150 platform
----------------------------

On the 7150 series hardware, time stamping is supported at line-rate using PTP.

You have two options for timestamp placement;

* Replacement of the FCS (`mac timestamp replace-fcs`):

{% digraph 7150 timestamp replace fcs %}
subgraph cluster {
  rankdir=LR;
  height=1.5;
  "Timestamp" [shape=square, height=1.5];
  "Payload" [shape=square, height=1.5];
  "IP Header" [shape=square, height=1.5];
  "Ethernet Header" [shape=square, height=1.5];
}
{% enddigraph %}

* Appending of the timestamp (`mac timestamp before-fcs`):

{% digraph 7150 timestamp append %}
subgraph cluster {
  rankdir=LR;
  height=1.5;
  "FCS" [shape=square, height=1.5];
  "Timestamp" [shape=square, height=1.5];
  "Payload" [shape=square, height=1.5];
  "IP Header" [shape=square, height=1.5];
  "Ethernet Header" [shape=square, height=1.5];
}
{% enddigraph %}

The implementation of this is a little 'quirky'.

Looking at the `Timestamp` value alone will not help you as it's an internal
ASIC counter on the switch, essentially providing the lower half of the timestamp.

To calculate the actual (Unix based) timestamp, another keyframe packet has
to be processed and tracked (every ~6 seconds); providing the first half of the timestamp.

While possible to implement, the imposed state and skew calculations is a little unappealing.

A look into the 7500{E,R}/7280{E,R} series
------------------------------------------

On the newer platforms, Arista has moved away from using the keyframe setup and
introduced a custom EtherType. Again, using hardware time stamping at line-rate & supporting PTP.

There is 3 possible time stamping modes on the 7500{E,R} & 7280{E,R} series switches:

* 64-bit header timestamp; i.e., encapsulated in the L2 header
* 48-bit header timestamp; i.e., encapsulated in the L2 header
* 48-bit timestamp that replaces the Source MAC

We will focus on the first 2 options that use a customer EtherType inside the layer 2 header.

_Note: All timestamps are captured upon packet ingress and stamped on packet egress._

### A look into the packet format

Let's compare a normal ethernet header:

{% digraph ethernet header %}
subgraph cluster {
  rankdir=LR;
  height=1.5;
  "FCS" [shape=square, height=1.5];
  "Payload" [shape=square, height=1.5];
  "Length/Type" [shape=square, height=1.5];
  "Src Address" [shape=square, height=1.5];
  "Dst Address" [shape=square, height=1.5];
}
{% enddigraph %}

To one with the customer EtherType inserted:

{% digraph ethernet header extended %}
subgraph cluster {
  rankdir=LR;
  height=1.5;
  "FCS" [shape=square, height=1.5];
  "Payload" [shape=square, height=1.5];
  "Length/Type" [shape=square, height=1.5];
  "Timestamp" [shape=square, height=1.2];
  "Version" [shape=square, height=1.2];
  "Sub-Type" [shape=square, height=1.2];
  "EtherType" [shape=square, height=1.5];
  "Src Address" [shape=square, height=1.5];
  "Dst Address" [shape=square, height=1.5];
}
{% enddigraph %}

_Note: .1q payloads are also supported, with the EtherType coming after the Source Address_

As you can see an extra 4 fields have been inserted into the header;

* EtherType - 0xD28B - An identifier for AristaEtherType
* Protocol sub-type - 0x1 - A sub-identifier for the AristaEtherType
* Version - 0x10 or 0x20 - An identifier for either 64bit or 48bit
* Timestamp - An IEEE 1588 time of day format

The timestamp is either 32 bits (seconds) followed by 32 bits (nanoseconds) or
16 bits (seconds) followed by 32 bits (nanoseconds) depending on the 64 or 48bit mode.

#### Configuration

Enabling hardware timestamping on the platform is rather simple;

* `mac timestamp header` enables timestamping on tool ports
* `mac timestamp header format <64bit | 48bit>` sets the format of the timestamp
* `mac timestamp replace source-mac` enables replacing the source mac address with the timestamp

There are some limitations to the time stamping support, notably;

* Timestamping is done after packet processing, resulting in ~10ns of delay
* 64bit timestamps may rollover inconsistency every 4 seconds causing jumps between packets

### Decoding the packets

Now we've changed the Ethernet header, it requires a specific decoder to be able to process.

Without a specific decoder, it is no longer a valid Ethernet header as Length field
contains a meaningless value.

Arista [provides](https://eos.arista.com/analyzing-packet-header-timestamps-in-wireshark/) an
LUA extension for Wireshark for this purpose.

Decoding custom EtherTypes in gopacket
--------------------------------------
[gopacket](https://github.com/google/gopacket) has a very useful pcap interface,
making it very easy to process data collected from TAP infrastructure.

Investigating the structure, it made sense to implement a custom
[layer](https://godoc.org/github.com/google/gopacket/layers) to handle
our EtherType.

After some experimentation, while this provided decoding of the timestamp data,
it prevented further processing of the packets, resulting in the IP layer
being inaccessible; this was complicated due to our now invalid Ethernet header.

A simple solution of extending the built-in
[EthernetType](https://godoc.org/github.com/google/gopacket/layers#EthernetType)
was called for.

```go
// Copyright 2012 Google, Inc. All rights reserved.
// Copyright 2009-2011 Andreas Krennmair. All rights reserved.
//
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file in the root of the source
// tree.
package decoder

import (
	"encoding/binary"
	"errors"
	"github.com/google/gopacket"
	"github.com/google/gopacket/layers"
	"net"
)

// This layer has a two-byte protocol subtype of 0x1,
// a two-byte protocol version of 0x10 and
// an eight-byte UTC timestamp in IEEE 1588 time of format
// So that would be 12 bytes in totally we need to strip off right after the src mac
type AristaEtherType struct {
	ProtocolSubType      uint16
	ProtocolVersion      uint16
	TimestampSeconds     uint32
	TimestampNanoSeconds uint32
}

// AristaExtendedEthernet is the layer of a normal or Arista extended Ethernet frame headers.
// This is the same as layers.Ethernet, but may have AristaEtherType filled with data
type AristaExtendedEthernet struct {
	layers.Ethernet
	AristaEtherType AristaEtherType
}

func (eth *AristaExtendedEthernet) DecodeFromBytes(data []byte, df gopacket.DecodeFeedback) error {
	if len(data) < 14 {
		return errors.New("AristaExtendedEthernet packet too small")
	}
	eth.DstMAC = net.HardwareAddr(data[0:6])
	eth.SrcMAC = net.HardwareAddr(data[6:12])

	// https://eos.arista.com/eos-4-18-1f/tap-aggregation-ingress-header-time-stamping/
	// Arista places 12 bytes directly after the src mac, see AristaEtherType comments for structure
	// We handle both timestamped and non-timestamped frames here
	etherType := binary.BigEndian.Uint16(data[12:14])
	if len(data) >= 26 && etherType == 53899 {
		eth.AristaEtherType = AristaEtherType{
			ProtocolSubType:      binary.BigEndian.Uint16(data[14:16]),
			ProtocolVersion:      binary.BigEndian.Uint16(data[16:18]),
			TimestampSeconds:     binary.BigEndian.Uint32(data[18:22]),
			TimestampNanoSeconds: binary.BigEndian.Uint32(data[22:26]),
		}
		eth.EthernetType = layers.EthernetType(binary.BigEndian.Uint16(data[26:28]))
		eth.BaseLayer = layers.BaseLayer{data[:28], data[28:]}
	} else {
		eth.EthernetType = layers.EthernetType(binary.BigEndian.Uint16(data[12:14]))
		eth.BaseLayer = layers.BaseLayer{data[:14], data[14:]}
	}

	// Logic from the upstream Ethernet code
	if eth.EthernetType < 0x0600 {
		eth.Length = uint16(eth.EthernetType)
		eth.EthernetType = layers.EthernetTypeLLC
		if cmp := len(eth.Payload) - int(eth.Length); cmp < 0 {
			df.SetTruncated()
		} else if cmp > 0 {
			eth.Payload = eth.Payload[:len(eth.Payload)-cmp]
		}
	}
	return nil
}

// Required methods to be a valid layer
func (e *AristaExtendedEthernet) LinkFlow() gopacket.Flow {
	return gopacket.NewFlow(layers.EndpointMAC, e.SrcMAC, e.DstMAC)
}

func (e *AristaExtendedEthernet) LayerType() gopacket.LayerType {
  return gopacket.LayerType(17)
}

func (eth *AristaExtendedEthernet) NextLayerType() gopacket.LayerType {
	return eth.EthernetType.LayerType()
}

// Public function
func DecodeAristaExtendedEthernet(data []byte, p gopacket.PacketBuilder) error {
	eth := &AristaExtendedEthernet{}
	err := eth.DecodeFromBytes(data, p)
	if err != nil {
		return err
	}
	p.AddLayer(eth)
	p.SetLinkLayer(eth)
	return p.NextDecoder(eth.EthernetType)
}
```

Now we have the custom decoder, we just need to register it with gopacket.
This makes gopacket use our decoder implementation rather than the built-in Ethernet one.

```go
import (
	"github.com/google/gopacket/layers"
)

func init() {
  layers.LinkTypeMetadata[layers.LinkTypeEthernet] = layers.EnumMetadata{
    DecodeWith: gopacket.DecodeFunc(DecodeAristaExtendedEthernet),
    Name:       "AristaExtendedEthernet",
  }
}
```

The custom fields are now accessible on the Ethernet layer, alongside the other fields.

```go
layer := packet.Layer(layers.LayerTypeEthernet)
if layer != nil {
  ethernetLayer := layer.(*decoder.AristaExtendedEthernet)
  if ethernetLayer.AristaEtherType.ProtocolSubType != 0 {
    timestamp, err := strconv.ParseFloat(fmt.Sprintf(
      "%d.%d",
      ethernetLayer.AristaEtherType.TimestampSeconds,
      ethernetLayer.AristaEtherType.TimestampNanoSeconds),
      64)
    }
  }
}
```

A similar decoder has been successfully tested with 500k/s packets per second.

Summary
-------
Using standard protocols and cheap hardware we can build powerful performance analysis applications.

This work was inspired by [Ruru](https://github.com/REANNZ/ruru), providing the foundations for
performance monitoring and insights of heavily asymmetric & distributed traffic flows.
