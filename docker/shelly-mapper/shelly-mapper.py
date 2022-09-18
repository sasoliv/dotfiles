import json
import paho.mqtt.client as paho
import subprocess
import sys
import time

from datetime import datetime

host = "mosquitto"
source = "shellies/shellybutton1/input_event/0"

mappings = {
    "S": {"topic": "desktop/mode", "payload": "console"},
    "SS": {"topic": "desktop/mode", "payload": "all"},
    "SSS": {"topic": "desktop/power", "payload": "reboot"},
    "L": {"topic": "desktop/power", "payload": "poweroff"}
}

client = None


def nowStr():
    return datetime.now().strftime("[%Y-%m-%d %H:%M:%S]")


def log(*values):
    print(nowStr(), *values)
    sys.stdout.flush()


def on_message(mosq, obj, msg):

    payload = msg.payload.decode("utf-8")
    jsonObj = json.loads(payload)
    target = mappings.get(jsonObj["event"])
    topic = target.get("topic")
    payload = target.get("payload")

    log("publishing to MQTT server: ", topic, payload)
    client.publish(topic, payload)


def exec(cmd):
    subprocess.call(cmd.split(), shell=False)


if __name__ == '__main__':

    log("init...")

    client = paho.Client()
    client.on_message = on_message

    client.connect(host, 1883, 60)

    client.subscribe(source, 0)

    log("listening...")

    while client.loop() == 0:
        time.sleep(0)

