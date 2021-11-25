#!/usr/bin/env python3
import os, hashlib, time, datetime
import RPi.GPIO as GPIO

relaypinnum = 26
relaypinHL = False
loglength = 10000

conf = open("/etc/identypi.conf","r")
for line in conf:
    if line[0] == "#": continue
    else:
        setting = line.split()
        if setting[0] == "relaypinnum": relaypinnum = int(setting[1])
        elif setting[0] == "relaypinHL":
            if setting[1] == "LOW": relaypinHL = False
            else: relaypinHL = True
        elif setting[0] == "loglength": loglength = int(setting[1])

while True:
    print("reading...")
    id = os.popen("bash -c 'timeout 5m /usr/share/identypi/get-id.py |& tail -1'").read()
    if len(id) == 13:
        id = hashlib.new("sha256", str(id).encode()).hexdigest()
        users = open("/usr/share/identypi/users", "r")
        for line in users:
            if len(line) < 60:
                print("There are errors in the user file at /usr/share/identypi/users")
                continue
            if str(line.split()[0]) == str(id):
                log = open("/var/log/identypi.log", "a")
                log.write(str(line[0:len(line)-1] + " " + str(datetime.datetime.now()) + "\n"))
                log.close()
                print("open")
                GPIO.setmode(GPIO.BCM)
                GPIO.setup(relaypinnum, GPIO.OUT)
                if relaypinHL == False:
                    GPIO.output(relaypinnum, GPIO.LOW)
                    GPIO.input(relaypinnum)
                else:
                    GPIO.output(relaypinnum, GPIO.HIGH)
                time.sleep(3)
                GPIO.output(relaypinnum, GPIO.LOW)
                print("closed")
                GPIO.cleanup()
                i = 0
                with open("/var/log/identypi.log") as f:
                    for i, l in enumerate(f):
                        pass
                if i > (loglength + 100):
                    log = open("/var/log/identypi.log", "r")
                    logbak = open("/var/log/identypi.log.bak", "a")
                    j = 0
                    for line in log:
                        j += 1
                        if j < 100:
                            continue
                        else:
                            logbak.write(line)
                    log.close()
                    logbak.close()
                    os.system("rm /var/log/identypi.log")
                    os.system("mv /var/log/identypi.log.bak /var/log/identypi.log")
                break
        users.close()
        time.sleep(3)
    else:
        print("No card ID")
