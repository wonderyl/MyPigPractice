
import sys
from IndexSourceReader import *

ids = {}
for line in file('ids.txt', 'r'):
	id = line.rstrip()
	ids[id] = 1

for record in IndexSourceReader(sys.stdin):
	try:
		id = record['ID']
		if id in ids and ids[id]>0:
			md = record['MD']
			tt = record['TT']
			ta = record['TA']
			print '%s\t%s\t%s\t%s'%(md, id, tt, ta)
            ids[id]=0
	except:
		pass
