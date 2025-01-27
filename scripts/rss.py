#!/usr/bin/env python3

import requests
import sys
import subprocess

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
    os = subprocess.run(["uname", "-s"], capture_output=True).stdout.decode().lower().strip()
    if os == "linux":
        copy = subprocess.run(["wl-copy", url])
        print("Linux copy return code:", copy.returncode)
    else:
        print("Not implemented yet")

    print(url)
