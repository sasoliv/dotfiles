#!/usr/bin/env python3

import json
import os
from pathlib import Path
import subprocess

googleBookmarksFile = Path.home() / '.config/google-chrome/Default/Bookmarks'

def getOption(children, path = ""):
    result = ""
    for c in children:
        if c['type'] == 'folder':
            result += (getOption(c['children'], path + "/" + c['name']) + "\n")
        elif c['type'] == 'url':
            result += f"<span foreground=\"grey\" size=\"small\">{path}</span>\t<b>{c['name']}</b>\t<span foreground=\"grey\" size=\"small\"><i>{c['url']}</i></span>\0info\x1f{c['url']}\x1ficon\x1frofi-bookmarks-{c['id']}\n"

    return result.replace('&', '&#38;')

if __name__ == "__main__":
    if os.environ.get('ROFI_RETV') == '1':
        subprocess.Popen(["google-chrome-stable", os.environ['ROFI_INFO']], close_fds=True, start_new_session=True, stdout=subprocess.DEVNULL)
    else:
        file = open(googleBookmarksFile)
        json = json.load(file)        
        print("\0prompt\x1f \n")
        print("\0markup-rows\x1ftrue\n")
        options = getOption(json['roots']['bookmark_bar']['children'])
        options = os.linesep.join([s for s in options.splitlines() if s])
        print(options)
        file.close()
