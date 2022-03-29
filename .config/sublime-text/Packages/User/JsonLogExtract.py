import json
import sublime
import sublime_plugin


class JsonLogExtractCommand(sublime_plugin.TextCommand):

    def run(self, edit):
        region = sublime.Region(0, self.view.size())
        content = self.view.substr(region)

        lines = content.splitlines()
        result = ""
        for line in lines:
            jsonObj = json.loads(line)
            result += (jsonObj["timestamp"] + " " + jsonObj["level"] + " [" + jsonObj["loggerName"] + "] " + jsonObj["message"] + "\n")

        self.view.replace(edit, region, result)  
