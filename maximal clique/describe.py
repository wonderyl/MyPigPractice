
import sys

max = 0
min = 100000
sum = 0
count = 0
sqrsum = 0 

for line in sys.stdin:
    cells = line.rstrip().split('\t')
    if len(cells) == 3:
        v = float(cells[2])
        if v>max:
            max = v
        elif v<min:
            min = v
        count += 1
        sum += v
        sqrsum += v*v
    
mean = sum/count 
var = sqrsum/count-mean*mean
sdev = var**0.5
print min, max, sum, count, sqrsum, mean, var, sdev  
