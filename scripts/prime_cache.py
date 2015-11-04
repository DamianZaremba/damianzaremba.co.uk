#!/usr/bin/env python
import requests
from multiprocessing import Pool
import os


def get_urls():
    live_dir = os.path.realpath(os.path.join(
        os.path.dirname(os.path.realpath(__file__)),
        '..',
        '_live'))

    pages = []
    for (dirpath, dirnames, filenames) in os.walk(live_dir):
        for file in filenames:
            page = os.path.dirname(
                os.path.relpath(
                    os.path.join(dirpath,
                                 file),
                    live_dir))

            if not page.startswith('.'):
                pages.append('/%s/' % page)

    return set(pages)


def fetch_url(path):
    url = 'http://damianzaremba.co.uk%s' % path.replace('//', '/')
    print('Fetching %s' % url)
    try:
        r = requests.get(url)
    except Exception, e:
        print('Could not get url %s: %s' % (url, e))
    else:
        if r.status_code != 200:
            print('Error returned for %s' % url)


if __name__ == '__main__':
    urls = get_urls()
    print('Priming %d urls' % len(urls))
    Pool(100).map(fetch_url, urls)
