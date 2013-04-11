import sys

dist={}

for line in sys.stdin:
	cells = line.rstrip().split('\t');
	if len(cells) > 0:
		dist[cells[0]] = 1

for item in dist.keys():
	print item


