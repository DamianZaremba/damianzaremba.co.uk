---
comments: true
layout: post
title: Why I love Python
tags:
- Fun
- Python
---

So I've been playing with Python a lot recently and it is just so amazing!

Here are some quick example that all took less than 10mins to write:

SMTP proxy to allow you to connect to a server via the specified port and have it silently forwarded to another server on another port! (Note: it's a bad idea to use localhost as it will make you an open proxy)
{% highlight python %}
#!/usr/bin/python
'''
Meta data
'''
__author__="Damian Zaremba"

'''
Import modules
'''
import smtpd
import asyncore

smtpd.PureProxy(('localhost', 2535), ('mail.damianzaremba.co.uk', 25))
asyncore.loop()
{% endhighlight %}

Email parser to allow you to process email using a IMAP connection. This is really slow currently and would be improved massively by threading but it's still really cool and took about 10min to write!
{% highlight python %}
#!/usr/bin/python
'''
Meta data
'''
__author__="Damian Zaremba"

'''
Import modules
'''
import imaplib
import string

MH = imaplib.IMAP4('mail.damianzaremba.co.uk')
MH.login('inboximporter-text@damianzaremba.co.uk', 'testy')
MH.select('INBOX')

emails = {}
typ, data = MH.search(None, 'ALL')
for num in data[0].split():
 typ, data = MH.fetch(num, '(RFC822)')
 if typ == 'OK':
 data = data[0][1].split("\r\n\r\n"); headers = data[0]; message = data[1]; attachments = data[2:]

email_data = emails[num] = {
 'body': message,
 'message_id': None,
 'date': None,
 'subject': None,
 'from': None,
 'to': None,
 'attachments': []
 }

for header in headers.strip().split('\r\n'):
 data = header.split(); key = data[0]; value = string.join(data[1:])
 if key == 'Message-ID:':
 email_data['message_id'] = value
 elif key == 'Date:':
 email_data['date'] = value
 elif key == 'Subject:':
 email_data['subject'] = value
 elif key == 'From:':
 email_data['from'] = value
 elif key == 'To:':
 email_data['to'] = value

for attachment in attachments:
 email_data['attachments'].append(attachment)

MH.close()
MH.logout()
print emails
{% endhighlight %}

Now I just need to learn Django properly and I can do some really cool socket based interfaces to things! Hopefully if I can get what I'm working on at the moment to function correctly I can reveal some cool things in the future!
