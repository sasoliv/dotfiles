#!/usr/bin/env python3

import json as jsonReader
import sys

commands = {
    "list-services": lambda config: listServices(config),
    "build-url": lambda config: buildUrl(config),
    "get-message": lambda config: getMessage(config)
}

def main():
    configFile = sys.argv[1]
    command = sys.argv[2]

    file = open(configFile)
    config = jsonReader.load(file)
    print(commands.get(command)(config))
    file.close()

def listServices(config):
    services = map(lambda e: e['service'], config)
    return "\n".join(services)

def buildUrl(config):
    service = sys.argv[3]
    input = sys.argv[4]
    
    item = next(filter(lambda e: e["service"] == service, config))

    url = item["url"]
    whiteSpaceReplacement = item["whiteSpaceReplacement"]
    input = input.replace(" ", whiteSpaceReplacement)
    return url.replace("${input}", input)

def getMessage(config):
    service = sys.argv[3]

    item = next(filter(lambda e: e["service"] == service, config))
    return item["message"]

if __name__ == "__main__":
    main()
