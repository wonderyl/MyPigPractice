
import sys
import struct
import redis

if len(sys.argv)<2:
    print 'usage: %s db'%sys.argv[0]
    sys.exit(-1)

db = int(sys.argv[1])

pool = redis.ConnectionPool(host='10.144.56.49', port=6379, db=db)     
def save(key, value):
    cli = redis.Redis(connection_pool=pool)
    cli.set(key, value)

count = 0
import time
start = time.time()
print time.ctime()
for line in sys.stdin:
    cells = line.rstrip().split('\t')
    if len(cells) == 2:
        try:
            key = cells[0]
            values = map(float, cells[1].strip('()').split(','))
            #print values
            if len(values) != 10:
                continue
            value = struct.pack('%df'%len(values), *values)
            save(key, value)
            count +=1
        finally:
            pass

end = time.time()
print 'insert %d within %f seconds, at rate of %f'%(count, (end-start), (end-start)/count)
print time.ctime()
