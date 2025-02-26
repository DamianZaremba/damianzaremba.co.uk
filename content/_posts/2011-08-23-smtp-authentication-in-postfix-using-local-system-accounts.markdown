---
layout: post
title: SMTP Authentication in Postfix using local system accounts
tags:
- FOSS
- Knowledge base
- Linux
- Postfix
- Email
- Smtp
---

In /etc/postfix/main.cf ensure the following values are set

```text
message_size_limit = 204800000
smtpd_recipient_restrictions = permit_sasl_authenticated permit_inet_interfaces reject_unauth_destination, permit
smtpd_sasl_auth_enable = yes
broken_sasl_auth_clients = yes
```

This will ensure postfix denies any un-authenticated attempts to send mail and enabled sasl authentication.

Next we just need to make sure sasl/postfix are setup to run:

```bash
chkconfig saslauthd on
/etc/init.d/saslauthd restart
chkconfig postfix on
/etc/init.d/postfix restart
```

Once this is done all we need to do is add our users and they can send mail:

```bash
adduser -s /sbin/nologin -M user1
passwd user1

adduser -s /sbin/nologin -M user2
passwd user2
```
