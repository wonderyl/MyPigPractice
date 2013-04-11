
import sys

count = 0
for line in sys.stdin:
    cells = line.rstrip().split('\t')
    if len(cells)==3:
        v = float(cells[2]) 
        if v>=3.40652156905e-05:
            count += 1

print count
