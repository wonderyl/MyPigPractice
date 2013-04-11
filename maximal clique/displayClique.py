
import sys

iddict = {}

for line in file('cliqueInfo.txt', 'r'):
    line = line.rstrip()
    cells = line.split('\t')
    id = cells[1]
    iddict[id] = line

for line in sys.stdin:
    ids = line.strip('()\n').split(',')
    print '----------'
    for id in ids:
        print iddict.get(id, '')
