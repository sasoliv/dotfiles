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
            url=c['url']
            result += f"{c['id']};{url}\n"
  
    return result

if __name__ == "__main__":
        file = open(googleBookmarksFile)
        json = json.load(file)        
        options = getOption(json['roots']['bookmark_bar']['children'])
        options = os.linesep.join([s for s in options.splitlines() if s])
        print(options)
        file.close()
