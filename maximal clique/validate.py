
triple={}
f3 = file('3.txt', 'r')
for line in f3:
    tri = line.strip('()\n')
    triple[tri] = 1
print 'truple', len(triple)

valid = 0
f4 = file('4.txt', 'r')
for line in f4:
    quad = line.strip('()\n').split(',')
    #print quad
    if len(quad) == 4:
        tri = '%s,%s,%s'%(quad[0],quad[1],quad[2])
        if tri not in triple:
            print ','.join(quand)
            continue
        tri = '%s,%s,%s'%(quad[0],quad[1],quad[3])
        if tri not in triple:
            print ','.join(quand)
            continue
        tri = '%s,%s,%s'%(quad[0],quad[2],quad[3])
        if tri not in triple:
            print ','.join(quand)
            continue
        tri = '%s,%s,%s'%(quad[1],quad[2],quad[3])
        if tri not in triple:
            print ','.join(quand)
            continue
        valid += 1
print 'valid', valid
