#! /usr/bin/env python
# 13/10/2015 - version 1.0 - Refernce "https://developer.akamai.com/api/luna/diagnostic-tools/overview.html"

import sys, requests, json
from akamai.edgegrid import EdgeGridAuth
from urlparse import urljoin

# Establish an HTTP session
session = requests.Session()

# Set the EdgeGrid credentials
session.auth = EdgeGridAuth(
            client_token='xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
            client_secret='xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
            access_token='xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
)

# Set up the base URL
baseurl = 'https://xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.luna.akamaiapis.net'

url = urljoin(baseurl, '/diagnostic-tools/v1/errortranslator?errorCode='+sys.argv[1])
result = session.get(url)

#print
#print "Requested URL:"
#print result.url
print 
print "Status code:" 
print result.status_code
print
print "Respnse Body:"
print json.dumps(result.json(), indent=2)

