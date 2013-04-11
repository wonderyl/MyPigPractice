
import sys
interval = 100

count = 0
for line in sys.stdin:
    if count%interval==0:
        cells = line.rstrip().split('\t')
        if len(cells)==2:
            print count, cells[1]
    count += 1


