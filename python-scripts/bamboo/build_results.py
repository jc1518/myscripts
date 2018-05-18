#!/usr/bin/env python3
"""
    Description: Check the latest Bamboo build result
    Author: Jackie Chen
    Version: 2018-05-17
"""

import requests
requests.packages.urllib3.disable_warnings()
import http.cookiejar
import xml.etree.ElementTree as ET
import xlsxwriter
import datetime
import getpass
import sys

# Define your bamboo site
BAMBOO_URL = 'https://bamboo.mycompany.com/bamboo/'
API_URL = BAMBOO_URL + 'rest/api/latest/'
PREFIX_URL = BAMBOO_URL + 'browse/'

# Define the max number of plans you want to check
MAX_PLANS = '100'


def login(username, password):
    if session.get(API_URL+'currentUser?os_authType=basic', auth=(username, password)).status_code == 200:
        print('Login successfully!')
        return True
    else:
        print('Oops, login failed!')
        sys.exit()


def last_build(max):
    print('Checking the last', max, 'build')
    build_meta = session.get(API_URL+'result?expand=results.result&max-result='+max).text
    return build_meta


def parse_build(meta):
    builds_info = []
    root = ET.fromstring(meta)
    for results in root:
        for result in results:
            build_info = {}
            for build in result:
                if build.tag == 'projectName':
                    build_info['projectName'] = build.text
                if build.tag == 'planName':
                    build_info['planName'] = build.text
                if build.tag == 'plan':
                    build_info['planLink'] = PREFIX_URL + build.attrib['key']
                    build_info['planName'] = build.text
                if build.tag == 'buildResultKey':
                    build_info['lastBuild'] = PREFIX_URL + build.text
                if build.tag == 'buildStartedTime':
                    build_info['buildStartTime'] = build.text
                if build.tag == 'buildRelativeTime':
                    build_info['buildRelativeTime'] = build.text
                if build.tag == 'buildReason':
                    build_info['buildReason'] = build.text
                if build.tag == 'buildState':
                    build_info['buildState'] = build.text
            builds_info.append(build_info)
    n = 0
    for each in builds_info:
        print(n+1, each)
        n += 1
    return builds_info


def create_spreadsheet(builds_info):
    print('Generating spreadsheet', datetime.datetime.now().strftime('%Y-%m-%d-%H-%M')+'.xlsx')
    workbook = xlsxwriter.Workbook(datetime.datetime.now().strftime('%Y-%m-%d-%H-%M')+'.xlsx')
    worksheet = workbook.add_worksheet()
    worksheet.write(0, 0, 'Project Name')
    worksheet.write(0, 1, 'Plan Name')
    worksheet.write(0, 2, 'Plan Link')
    worksheet.write(0, 3, 'Last Build')
    worksheet.write(0, 4, 'Start Time')
    worksheet.write(0, 5, 'Relative Time')
    worksheet.write(0, 6, 'Build By')
    worksheet.write(0, 7, 'Build State')
    row = 1
    for build_info in builds_info:
        worksheet.write(row, 0, build_info['projectName'])
        worksheet.write(row, 1, build_info['planName'])
        worksheet.write(row, 2, build_info['planLink'])
        worksheet.write(row, 3, build_info['lastBuild'])
        worksheet.write(row, 4, build_info['buildStartTime'])
        worksheet.write(row, 5, build_info['buildRelativeTime'])
        worksheet.write(row, 6, build_info['buildReason'])
        worksheet.write(row, 7, build_info['buildState'])
        row += 1
    workbook.close()


if __name__ == '__main__':
    print('Please input your AD credential:')
    username = input('username: ')
    password = getpass.getpass('password: ')
    session = requests.session()
    session.cookies = http.cookiejar.LWPCookieJar('cookie')
    if login(username, password):
        create_spreadsheet(parse_build(last_build(MAX_PLANS)))


