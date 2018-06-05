#!/usr/bin/env python3
"""
    Description: Check the team leave calendar
    Author: Jackie Chen
    Version: 2018-06-04
"""

import sys
import os
import requests
requests.packages.urllib3.disable_warnings()
from icalevents.icalevents import events
import datetime


# Define your team calendar subscription url
ICS_URL = os.environ['CONFL_ICS']
TODAY = datetime.datetime.today()


# Download ics file
def download_ics(username, password):
    result = requests.get(ICS_URL, auth=(username, password), verify=False)
    if result.status_code == 200:
        print('Login successfully! Downloading latest ics file.')
        with open('leave.ics', 'w') as f:
            f.write(result.text)
        return True
    else:
        print('Oops, login failed!')
        sys.exit()


# Parse ics file
def parse_ics(ics):
    es = events(file=ics, start=TODAY, end=TODAY)
    return es


# Print Today's events
def main():
    username = os.environ['CONFL_USERNAME']
    password = os.environ['CONFL_PASSWORD']
    if download_ics(username, password):
        for ev in parse_ics('leave.ics'):
            print(ev)


if __name__ == '__main__':
    main()
