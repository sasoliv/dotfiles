#!/usr/bin/env python3

import os
import subprocess

import requests

def getOptions():
    resp = requests.get(os.environ['LIVE_TV']).text
    urls = resp.split("\n",1)[1]
    urls = urls.splitlines()

    options = []

    for idx in range(0, len(urls), 2):
        url = urls[idx+1]
        title = urls[idx].split("\"")[3]

        options.append(f"{title}\0info\x1f{url}")

    return os.linesep.join(options)

if __name__ == "__main__":
    if os.environ.get('ROFI_RETV') == '1':
        subprocess.Popen(["mpv", os.environ['ROFI_INFO']], close_fds=True, start_new_session=True, stdout=subprocess.DEVNULL)
    else:
        print("\0prompt\x1f \n")
        print("\0markup-rows\x1ftrue\n")

        options = getOptions()

        print(options)
