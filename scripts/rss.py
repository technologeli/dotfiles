#!/usr/bin/env python3

import requests
import sys

def get_rss_url(url: str) -> str:
    res = requests.get(url)
    html = res.content.decode()
    s = '<link rel="alternate" type="application/rss+xml" title="RSS" href="'
    rss_index = html.find(s)
    start = rss_index+len(s)
    end = html.index('"', start)
    return html[start:end]

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} [YT-channel]")
        sys.exit(1)

    url = get_rss_url(sys.argv[1])
    print(url)
