
import sys

iddict = {}
cnt = 0
for line in sys.stdin:
    ids = line.strip('()\n').split(',')
    cnt += len(ids)
    for id in ids:
        iddict[id] = 1
print >>sys.stderr, cnt, len(iddict)
for id in iddict.keys():
    print id
