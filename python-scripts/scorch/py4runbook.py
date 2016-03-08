#!/usr/bin/env python
# The script is to generate python script for scorch runbook job
# Version 1.0 11/09/2015 - Jackie Chen

import pyHyperV
import getpass
import sys

print
Server = raw_input('Pleaes type your server name: ')
URL = "http://%s:81/Orchestrator2012/Orchestrator.svc" % (Server)

print
Domain = raw_input('Please type your AD domain name: ')

print 
UserName = Domain+"\\"+raw_input('Please type your AD username: ')
print 
PassWord = getpass.getpass("Please type your AD password: ")

print 
print "Here is the runbook list:"
ScoReturn = pyHyperV.orchestrator(URL, UserName, PassWord)
RunBooks = ScoReturn.GetRunbooks()["result"]

print 
n = 0
BookNames = []
BookIds = []
for BookName, BookId in RunBooks.iteritems():
	n = n + 1
	if BookName == "message":
		print "Error! Please check your login credential."
		print 
		sys.exit()
	print " ("+str(n)+")", BookName
	BookNames.append(BookName)
	BookIds.append(BookId)
	
print 


num = input("Please choose a number: " )
num = num -1

print 
print "Runbook '"+BookNames[num]+"'", "needs following parameters:"
print 
BookParams = ScoReturn.GetParameters(BookIds[num])["result"]

ParamNameKeys = []
ParamNameValues = []
ParamDict = {}
m = 3
for ParamName, ParamId in BookParams.iteritems():
	print "  "+ParamName
	ParamNameValue = ParamName.replace(' ', '_').replace('(', '').replace(')', '').replace('-', '').lower()
	ParamNameValues.append(ParamNameValue+" = "+"sys.argv["+str(m)+"]")
	NewParam = {ParamName: ParamNameValue}
	ParamDict.update(NewParam)
	m = m + 1

ScriptName = "scorch_"+BookNames[num].replace(' ', '_').lower()+".py"
ScriptUsage = "Usage: python %s <ad_username> <ad_password> %s" % (ScriptName, ' '.join('<{}>'.format(Param) for Param in list(ParamDict.values())))

print 
print "Generating python script '%s' for the runbook '%s'" % (ScriptName, BookNames[num])

ScriptContent = """
#!/usr/bin/env python
# %(scriptusage)s  

import pyHyperV
import sys

server = "http://%(server)s:81/Orchestrator2012/Orchestrator.svc"
runbookID = "%(runbookid)s"  

ad_username = "%(domain)s\\\\"+sys.argv[1]
ad_password = sys.argv[2]
%(paramlist)s

o = pyHyperV.orchestrator(server, ad_username, ad_password)

runbookParameters = { %(paramdict)s }

print o.Execute(runbookID, runbookParameters, dictionary=True)
print 
""" \
% {'domain': Domain, 'scriptusage': ScriptUsage, 'server': Server, 'runbookid': BookIds[num], 'paramlist': '\n'.join(ParamNameValues), 'paramdict': ', '.join('"{}" : {}'.format(key, val) for key, val in ParamDict.items())}

with open(ScriptName, 'w') as Script:
	Script.write("%s" % ScriptContent)

print
print ScriptUsage
print 
