---
comments: true
layout: post
title: Download festival hack
categories:
- FOSS
- Fun
- General
- How-to
tags:
- python
- scraper
---

I didn't make it to download this year but the pictures look awesome, before they disappear into nowhere I wanted to grab a copy so I hacked up a bit of python to do some scraping and it works (not very well, but it was more of a 5min thing rather than a let's make a good job of it thing.). Script is as below:
{% highlight python %}
#!/usr/bin/env python
'''
Uber hack to download images from download website, kinda works.
Very messy as I ripped most the code out of other scripts I've written.
'''
import os
import urllib
import hashlib
import threading
import Queue
import urlparse
from BeautifulSoup import BeautifulSoup
base_dir = '/home/damian/Pictures/download-2011'

def get_total_pages():
 uh = urllib.urlopen("http://photos.downloadfestival.co.uk/view/")
 soup = BeautifulSoup(uh)
 uh.close()

count = str(soup.find("div", {"class": "page_count"}).string.strip())
 count = int(count.replace('Page 1 of ', ''))
 return count

def get_images(page):
 images = []
 uh = urllib.urlopen("http://photos.downloadfestival.co.uk/view/?page=%d" % page)
 soup = BeautifulSoup(uh)
 uh.close()

r = soup.find("ul", {"class": "item_list"})
 for sr in r.findAll("li"):
 image = sr.a.img['src']
 images.append(image)
 return images

class Runner(threading.Thread):
 def __init__(self, queue):
 threading.Thread.__init__(self)
 self.queue = queue

def run(self):
 while True:
 url = self.queue.get()
 self.get_image(url)
 self.queue.task_done()

def get_image(self, url):
 urldata = urlparse.urlparse(url)

ext = '.'.join(urldata.path.split('.')[-1:])
 file_name = "%s.%s" % (hashlib.md5(url).hexdigest(), ext)
 file_path = os.path.join(base_dir, file_name)

uh = urllib.urlopen(url)
 fh = open(file_path, 'w')
 fh.write(uh.read())
 fh.close()
 uh.close()
 print "Downloaded image to %s" % file_path

if __name__ == "__main__":
 if not os.path.isdir(base_dir):
 os.makedirs(base_dir)

total = get_total_pages()
 images = []

print "%d pages found" % total
 for p in range(1, total):
 print "Processing page %d" % p
 i = get_images(p)

print "Found %d images" % len(i)
 images.extend(i)

 print "Downloading %d images" % len(images)
 queue = Queue.Queue()
 for i in range(20):
 thread = Runner(queue)
 thread.setDaemon(True)
 thread.start()

for image in images:
 queue.put(image)
 queue.join()
{% endhighlight %}
