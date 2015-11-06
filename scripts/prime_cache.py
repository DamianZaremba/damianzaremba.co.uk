#!/usr/bin/env python
import requests
from multiprocessing import Pool
import os
import argparse


def get_urls(full, _files):
    live_dir = os.path.realpath(os.path.join(
        os.path.dirname(os.path.realpath(__file__)),
        '..',
        '_live'))

    if not _files:
        return []

    if not full:
        files = []
        for file in _files:
            files.append(os.path.join(live_dir, file))

    pages = []
    for (dirpath, dirnames, filenames) in os.walk(live_dir):
        for file in filenames:
            path = os.path.join(dirpath, file)
            page = os.path.relpath(path, live_dir)

            if page.endswith('/index.html'):
                page = os.path.dirname(page)
            page_url = '%s' % page.lstrip('/')

            if not page.startswith('.'):
                if full:
                    pages.append(page_url)
                else:
                    if path in files:
                        pages.append(page_url)

    return set(pages)


def fetch_url(path):
    url = 'http://damianzaremba.co.uk/%s' % path
    print('Fetching %s' % url)
    try:
        r = requests.get(url)
    except Exception, e:
        print('Could not get url %s: %s' % (url, e))
    else:
        if r.status_code != 200:
            print('Error returned for %s' % url)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--full', action='store_true')
    parser.add_argument('--files', nargs='+', action='store')
    args = parser.parse_args()

    urls = get_urls(args.full, args.files)

    print('Priming %d urls' % len(urls))
    Pool(100).map(fetch_url, urls)
