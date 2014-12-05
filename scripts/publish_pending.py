#!/usr/bin/python
'''
Simple script to take a post in a pending state and publish it.
Deals with renaming all assets to the right date.
'''
import time
import yaml
import re
import os
import smtplib

source_dirs = ['content/_drafts/singles/']
target_dir = 'content/_posts/'


def process_file(file_path):
    in_block = False
    block_data = ""
    post_data = ""

    fh = open(file_path, 'r')
    for line in fh.readlines():
        if line.strip() == '---':
            if not in_block:
                in_block = True
                continue
            else:
                in_block = False
                continue

        if in_block:
            block_data += line
        else:
            post_data += line

    try:
        yaml_data = yaml.load(block_data)
    except:
        print "Could not load block for %s" % file_path
        return False

    if not is_pending(yaml_data):
        return False

    print "%s is pending" % file_path
    if not publish(file_path, block_data, post_data):
        print "Could not publish %s" % file_path
        return False

    print "%s has been published" % file_path
    return True


def is_pending(data):
    if 'status' in data.keys():
        if data['status'] == 'pending':
            return True
    return False


def publish(file_path, block_data, post_data):
    # Strip to the name
    target_post = os.path.basename(file_path)
    target_post_name = re.sub('\.markdown$', '', target_post)
    source_post_name = re.sub('\.markdown$', '', target_post)

    # Setup the date if we don't have a date
    # If we do have a date, this does nothing
    if not re.match('^[0-9]{4}\-[0-9]{2}\-[0-9]{2}\-', target_post):
        target_post = '%s-%s' % (time.strftime('%Y-%m-%d'), target_post)
        target_post_name = '%s-%s' % (time.strftime('%Y-%m-%d'), target_post_name)

    # Delete the status key from the yaml
    # Don't just yaml.dump on the data as it re-orders everything
    new_block = '---\n'
    for line in block_data.split('\n'):
        if line.strip() == '':
            continue
        if line.startswith('status:'):
            continue
        new_block += '%s\n' % line
    new_block += '---'

    # Rebuild the file contents
    post_file = '%s\n%s' % (new_block, post_data)

    # Output new file and remove old file in git
    target_file_path = os.path.join(target_dir, target_post)
    if not os.path.isdir(target_dir):
        os.makedirs(target_dir)

    print "Writing out %s to %s" % (file_path, target_file_path)
    with open(target_file_path, 'w') as fh:
        fh.write(post_file)
        fh.close()
    os.system('git add \'%s\'' % target_file_path.replace("'", "\\'"))

    print "Removing %s" % file_path
    os.system('git rm -f \'%s\'' % file_path.replace("'", "\\'"))

    # Now move any postfiles
    postfiles_dir = os.path.join('content', '_postfiles', source_post_name)
    new_postfiles_dir = os.path.join('content', '_postfiles', target_post_name)
    if os.path.isdir(postfiles_dir):
        print "Moving postfiles from %s to %s" % (postfiles_dir, new_postfiles_dir)
        os.system('mv \'%s\' \'%s\'' % (postfiles_dir.replace("'", "\\'"),
                                            new_postfiles_dir.replace("'", "\\'")))
        os.system('git rm -rf \'%s\'' % postfiles_dir.replace("'", "\\'"))
        os.system('git add \'%s\'' % new_postfiles_dir.replace("'", "\\'"))

    # COMMIT!
    git_message = 'Publishing %s from drafts to content' % target_post_name.replace("'", "\\'")
    os.system('git commit -m \'%s\'' % git_message)

    # Push
    os.system('git push origin master')

    return target_file_path

if __name__ == '__main__':
    has_publish = False
    for source_dir in source_dirs:
        if os.path.isdir(source_dir):
            for path, dirs, files in os.walk(source_dir):
                for file in files:
                    file_path = os.path.join(source_dir, file)
                    has_publish = process_file(file_path)

                    if has_publish:
                        break # Second loop

                if has_publish:
                    break # First loop

    if has_publish:
        try:
            server = smtplib.SMTP('localhost')
            server.set_debuglevel(1)
            msg = "From: publish_pending@damianzaremba.co.uk\r\nTo: damian@damianzaremba.co.uk\r\n"
            msg += "Subject: New post published\r\n\r\n%s" % has_publish
            server.sendmail("publish_pending@damianzaremba.co.uk", "damian@damianzaremba.co.uk", msg)
            server.quit()
        except:
            pass