---
comments: true
layout: post
title: Decoding IPFIX options using Go
tags:
- Network
- How-to
- Go
---

The IPFIX (IP Flow Information Export) protocol provides an extensible
standard for transmitting network flow data.

A key difference compared to the likes of [sflow](http://www.sflow.org/),
is the template-based nature of data.

While very similar to NetFlow version 9, IPFIX enables variable length fields
and vendor extensions. This makes the protocol suitable for different types of
performance data, as desired by any vendors.

A recent project required some processing of IPFIX flow data,
which this post will focus on.

_TL;DR The full implementation can be found on
[Github](https://github.com/DamianZaremba/ipfix_options_demo)_

Parsing options
---------------
A number of IPFIX decoder implementations exist in Go,
however most are included in flow decoder implementations,
rather than standalone libraries.

The best stand-alone library I could fix is
[github.com/calmh/ipfix](https://github.com/calmh/ipfix), but this
doesn't support
[decoding options](https://github.com/calmh/ipfix/blob/master/parser.go#L296-L301).

To better understand the scope of implementation and overall structure of IPFIX,
a stand-alone decoder was implemented.

Data structure
--------------
To begin implementing our own decoder, we first need to understand the format of packets
used in IPFIX.

We can use both the [IANA field assignments](https://www.iana.org/assignments/ipfix/ipfix.xhtml)
and [RFC](https://tools.ietf.org/html/rfc7011) to construct our base expectations.

At a high level, there is 1 common header then 3 different payload types

* Data template
* Options template
* Data set

We are interested in the options template and data set.

Decoding the header
-------------------

As described in the [RFC](https://tools.ietf.org/html/rfc7011#section-3.1), we can expect 5 fields.

Followed by the message header we have a set identifier, which describes the message contents;
for our purposes, we will use this as part of the header.

```go
header := IpfixHeader{
	Version:        binary.BigEndian.Uint16(payload[0:2]),
	MessageLength:  binary.BigEndian.Uint16(payload[2:4]),
	ExportTime:     binary.BigEndian.Uint32(payload[4:8]),
	SequenceNumber: binary.BigEndian.Uint32(payload[8:12]),
	DomainId:       binary.BigEndian.Uint32(payload[12:16]),
	SetId:          binary.BigEndian.Uint16(payload[16:20]),
}
```

We are interested in any SetId that is 3 (options template) or >= 256 (data set).

Decoding the template
---------------------

Before any data can be decoded, we must have a matching template.

Without the template, there is no way to know how the fields are mapped within the data set.

Each template payload (SetId 2 or 3) has a header containing the ID and field counts,
first we need to decode this.

```go
template := OptionsTemplate{
  TemplateId:      binary.BigEndian.Uint16(payload[0:2]),
  FieldCount:      binary.BigEndian.Uint16(payload[2:4]),
  ScopeFieldCount: binary.BigEndian.Uint16(payload[4:6]),
}
```

Once again, using the [RFC](https://tools.ietf.org/html/rfc7011#section-3.4.1),
we can determine the payload is a sequence of field separators.

The number of separators corresponds to the values in the header we just decoded.

Unlike a data template, the options template has a set of scope fields.

The ordering of these fields is critical to maintain.

### Decode the fields
Both scope fields and fields have the same structure, thus can be decoded
using the same logic.

```go
func decodeSingleTemplateField(payload []byte) (TemplateField, int) {
  tf := TemplateField{
    ElementId: binary.BigEndian.Uint16(payload[0:2]),
    Length:    binary.BigEndian.Uint16(payload[2:4]),
  }

  if tf.ElementId > 0x8000 {
    tf.ElementId = tf.ElementId & 0x7fff
    tf.EnterpriseNumber = binary.BigEndian.Uint32(payload[0:4])
    return tf, 8
  }

  return tf, 4
}
```

It's then simply a case of decoding each field in sequence and storing them for later

```go
// Get all scope entries
for i := template.ScopeFieldCount; i > 0; i-- {
  tf, cut := decodeSingleTemplateField(byteSlice)
  template.ScopeField = append(template.ScopeField, tf)

  if len(byteSlice) < cut {
    break
  }
  byteSlice = byteSlice[cut:]
}

// Get all field entries
for i := template.FieldCount - template.ScopeFieldCount; i > 0; i-- {
  tf, cut := decodeSingleTemplateField(byteSlice)
  template.Field = append(template.Field, tf)

  if len(byteSlice) < cut {
    break
  }
  byteSlice = byteSlice[cut:]
}
```

### Cache the template

Now we have the template decoded, it is important to store it.
The fields described in the template need to be used when decoding the data set,
which we will look at next.

A simple way to store this is using the LRU cache implementation from Hashicorp,
[github.com/hashicorp/golang-lru](github.com/hashicorp/golang-lru).

All future lookups will be via the ID, so using this as the key make sense.

```go
templateCache, err := lru.New(10240)
if err != nil {
  log.Fatalf("Failed to setup options template cache: %v", err)
}

templateCache.Add(template.Id, template)
```

Decoding the data set
---------------------

Any set ID over 255 represents a data set, the set ID then refers to the template
we need to use when decoding the data set.

First, we need to ensure we have a matching template for this payload.

```go
cacheEntry, ok := templateCache.Get(header.SetId)
if !ok {
  return nil, true
}
template := cacheEntry.(OptionsTemplate)
```

Once we have the template, it's a case of decoding each option in sequence.
Again, both scope fields and fields can be decoded using the same logic.

### Option decoding

The option decoding logic has 3 main tasks:

* Read the correct length of bytes off the payload
* Lookup the associated name of the field from the identifier
* Cast the byte array into the correct data type for the identifier

The [IANA field assignments](https://www.iana.org/assignments/ipfix/ipfix.xhtml)
accurately describe the field data we need to complete these tasks.

```go
func decodeSingleOption(byteSlice []byte, field TemplateField, options Options) {
	// Check we have enough data
	if len(byteSlice) < int(field.Length) {
		return
	}

	// Handle each enterprise
	switch field.EnterpriseNumber {
	case 0:
		// Handle elements for enterprise 0
		switch field.ElementId {
		case 34:
			// samplingInterval
			options["samplingInterval"] = binary.BigEndian.Uint32(byteSlice[:int(field.Length)])
		case 36:
			// flowActiveTimeout
			options["flowActiveTimeout"] = binary.BigEndian.Uint16(byteSlice[:int(field.Length)])
		case 37:
			// flowIdleTimeout
			options["flowIdleTimeout"] = binary.BigEndian.Uint16(byteSlice[:int(field.Length)])
		case 41:
			// exportedMessageTotalCount
			options["exportedMessageTotalCount"] = binary.BigEndian.Uint64(byteSlice[:int(field.Length)])
		case 42:
			// exportedFlowRecordTotalCount
			options["exportedFlowRecordTotalCount"] = binary.BigEndian.Uint64(byteSlice[:int(field.Length)])
		case 130:
			// exporterIPv4Address
			options["exporterIPv4Address"] = net.IP(byteSlice[:int(field.Length)])
		case 131:
			// exporterIPv6Address
			options["exporterIPv6Address"] = net.IP(byteSlice[:int(field.Length)])
		case 144:
			// exportingProcessId
			options["exportingProcessId"] = binary.BigEndian.Uint32(byteSlice[:int(field.Length)])
		case 160:
			// systemInitTimeMilliseconds
			options["exportingProcessId"] = int64(binary.BigEndian.Uint64(byteSlice[:int(field.Length)]))
		case 214:
			// exportProtocolVersion
			options["exportProtocolVersion"] = uint8(byteSlice[0])
		case 215:
			// exportTransportProtocol
			options["exportTransportProtocol"] = uint8(byteSlice[0])
		}
	}
}
```

### Decoding the fields

The order of fields in the data set is identical to the order in the template,
so once again it's just a case of looping over them.

```go
// Read all scope field separators
for i := 0; i < len(template.ScopeField); i++ {
  decodeSingleOption(byteSlice, template.ScopeField[i], options)

  if len(byteSlice) < int(template.ScopeField[i].Length) {
    break
  }
  byteSlice = byteSlice[int(template.ScopeField[i].Length):]
}

// Read all field separators
for i := 0; i < len(template.Field); i++ {
  decodeSingleOption(byteSlice, template.Field[i], options)

  if len(byteSlice) < int(template.Field[i].Length) {
    break
  }
  byteSlice = byteSlice[int(template.Field[i].Length):]
}
```

Result
------
We now have a subset of the IANA fields supported in our decoder,
given a correct template and data payload, the result is now a map of our options.

```go
map[
  exportedMessageTotalCount: 250
  exportedFlowRecordTotalCount: 10
  samplingInterval: 10
  flowIdleTimeout: 15
  exportingProcessId: 72
  exporterIPv4Address: 192.168.0.1
  exporterIPv6Address: ::
  flowActiveTimeout: 60
  exportProtocolVersion: 10
  exportTransportProtocol: 17
]
```

Summary
-------
IPFIX is a highly flexible protocol with a relatively simple data format,
allowing parsing to be easily implemented.

While the implementation's boundary checking could be improved,
the exercise of creating an actual implementation from documented implementation
I would recommend to all.

You may also find that some vendors have interesting assumptions within their options
handling, with many configuration knobs missing compared to data templates.

Having this functionality separated from [upstream code](https://github.com/calmh/ipfix)
proved to be fruitful, allowing certain options to be stored and distributed outside of
normal flow collection.

The full implementation can be found on
[Github](https://github.com/DamianZaremba/ipfix_options_demo),
with basic test cases added for each implemented field.
