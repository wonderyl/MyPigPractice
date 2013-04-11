import sys

dist={}

for line in sys.stdin:
	cells = line.rstrip().split('\t');
	if len(cells) == 2:
		cnt = int(cells[1])
		c = dist.get(cnt, 0)
		dist[cnt] = c+1

for item in sorted(dist.items(), key=lambda d:d[0]):
	print '%d\t%d'%item


