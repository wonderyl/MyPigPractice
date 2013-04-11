
import sys

ids = {}
fid=file('20000.txt', 'r')
for line in fid:
    id = line.split('\t')[0]
    ids[id] = 1

for line in sys.stdin:
    line = line.rstrip()
    cells = line.split('\t')
    if len(cells)==3:
        if cells[1] in ids:
            print line
