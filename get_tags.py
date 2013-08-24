#!/usr/bin/python
import yaml
import os

tags = {}
post_files = []
source_dirs = ['content/_drafts/', 'content/_posts/']

for sdir in source_dirs:
    if os.path.isdir(sdir):
        for path, dirs, files in os.walk(sdir):
            for file in files:
                post_files.append(os.path.join(path, file))

for pfile in post_files:
    in_block = False
    block = ""

    fh = open(pfile, 'r')
    for line in fh.readlines():
        if line.strip() == '---':
            if not in_block:
                in_block = True
                continue
            else:
                break

        if in_block:
            block += line

    data = None
    try:
        data = yaml.load(block)
    except:
        print "Could not load block for %s" % pfile

    if data:
        if 'tags' in data.keys():
            for tag in data['tags']:
                if tag not in tags:
                    tags[tag] = 0
                tags[tag] += 1

print "Current tags in use:"
for tag,count in tags.items():
    print "%s (%d)" % (tag, count)
