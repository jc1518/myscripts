#!/usr/bin/env python

from HTMLParser import HTMLParser
from pprint import pprint

with open("report.html", 'r') as r:
    report = r.read()

#print repot

class Tsung(HTMLParser):
    def __init__(self):
        HTMLParser.__init__(self)
        self.separator = ' '
        self.td = False
        self.th = False
        self.table = []
        self.row = []
        self.cell = []
        self.tables = []

    def handle_starttag(self, tag, attrs):
        if tag == 'td':
            self.td = True
        if tag == 'th':
            self.th = True
  
    def handle_data(self, data):
        if self.td or self.th:
            self.cell.append(data.strip().replace("'",""))

    def handle_endtag(self, tag):
        if tag == 'td':
            self.td = False
        if tag == 'th':
            self.th = False
        if tag in ['td', 'th']:
            final_cell = self.separator.join(self.cell).strip()
            self.row.append(final_cell)
            self.cell = []
        elif tag == 'tr':
            self.table.append(self.row)
            self.row = []
        elif tag == 'table':
            self.tables.append(self.table)
            self.table = []
    

parser = Tsung() 
parser.feed(report)
print "connect mean: " + parser.tables[0][1][5]
print "page mean: " + parser.tables[0][2][5]
print "request mean: " + parser.tables[0][3][5]
print "session mean: " + parser.tables[0][4][5]

"""
pprint(parser.tables)
print "-------------------------------------------------------------------------------------------------"
print(parser.tables[0][0])
print(parser.tables[0][1])
print(parser.tables[0][2])
print(parser.tables[0][3])
print(parser.tables[0][4])
print "-------------------------------------------------------------------------------------------------"
"""



