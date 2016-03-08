#!/usr/bin/python

# List the osa status of all or given servers
# Version 1.0 by Jackie Chen - 23/01/2015: Allow user to find the osa status of all servers.
# Version 1.1 by Jackie Chen - 05/02/2015: Allow user to provide a list of servers to query.

import sys, getopt, xmlrpclib, getpass

def usage():
	print "Usage: ./osa_status.py -i <inputfile> or ./osa_status.py -a"
	print ""

def main(argv):
	try:
		opts, args = getopt.getopt(argv, "ai:")
		if not opts:
			print "no option supplied"
			usage()
			sys.exit(2)
	except getopt.GetoptError as err:
		print(err)
		usage()
		sys.exit(2)
	inputfile = ""
	for opt, arg in opts:
		if opt == "-a":
			print "The script will check the osa status of all servers."
		elif opt == "-i":
			inputfile = arg
			print "The script will check the osa status of given servers in " + inputfile
		else:
			usage()
			sys.exit(2)

print ""

if __name__ == "__main__":
	main(sys.argv[1:])

# Satellite login info
print
URL = "https://redhat-satellite-fqdn-here/rpc/api"
print "Please login " + URL
USER = raw_input("Username: ")
PWD = getpass.getpass("Password: ")
print "Please wait..."
print ""

client = xmlrpclib.Server(URL, verbose=0)
session = client.auth.login(USER, PWD)

systems_all = []
systems_online = []
systems_offline = []
systems_unknown = []
systemlist = []

if sys.argv[1] in ("-a", "--all"): 
	systemlist =  client.system.list_systems(session)
elif sys.argv[1] in ("-i", "--ifile"):
	with open(sys.argv[2], "r") as f:
		for line in f:
			temp = client.system.search.hostname(session, line)
			#print temp
			if not temp:
				print "Can not find " + line
			else:
				system = temp[0]
				systemlist.append(system)
else:
	print "Error!"
	sys.exit(2)

for system in systemlist:
	details = client.system.get_details(session, system.get('id'))
	system = {
		"NAME": system.get('name'),
		"ID": system.get('id'),
		"OSA": details.get('osa_status')
		}
	systems_all.append(system)

	if details.get('osa_status') == "online":
		systems_online.append(system)
	elif details.get('osa_status') == "offline":
		systems_offline.append(system)
	else:
		systems_unknown.append(system)

client.auth.logout(session)

def niceprint(systems):
	for system in systems:
		print system["NAME"], ":", system["ID"], ":", system["OSA"]


def showmore():
	print
	choice = raw_input("Type online, offline or unknown to see more. Or type X to exit:  ")
	if choice.lower() == "online":
		niceprint(systems_online)
		showmore()
	elif choice.lower() == "offline":
		niceprint(systems_offline)
		showmore()
	elif choice.lower() == "unknown":
		niceprint(systems_unknown)
		showmore()
	elif choice.lower() == "x":
		print "Exit..."
	else:
		showmore()

print "###############################"
print "Total servers: ", len(systems_all)
print "Online OSA servers: ", len(systems_online)
print "Offline OSA servers: ", len(systems_offline)
print "Unknown OSA servers: ", len(systems_unknown)
print "###############################"

showmore()

