#!/usr/bin/env python

import RPi.GPIO as GPIO
from mfrc522 import SimpleMFRC522

def getid():
    reader = SimpleMFRC522()
    id, text = reader.read()
    GPIO.cleanup()
    return id

if __name__ == '__main__':
    print(getid())

