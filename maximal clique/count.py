
import sys

last=''
count=0
for line in sys.stdin:
    cells = line.lstrip('(').split(',')
    if len(cells)>0:
        id = cells[0]
        if id!=last:
            print last, count
            last = id
            count = 1
        else:
            count += 1
print last, count

