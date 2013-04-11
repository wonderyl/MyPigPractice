#encoding=gb18030
'''
Created on 2011-1-7
Updated on 2011-01-25 support multiline content
Updated on 2011-12-26 buxfix: last field of last record not read
@author: wonderyao
'''

import os

class IndexSourceReader(object):
    '''
    iteratable reader for vertical index source file
    '''

    def __init__(self, file):
        '''
        Constructor
        '''
        self.fin = file
        if self.readBeforeFirstRecord():
            self.EOF = False
        else:
            self.EOF = True    
    
    def __iter__(self):
        return self
    
    def readBeforeFirstRecord(self):
        while True:
            line = self.fin.readline()
            if len(line) == 0:#EOF
                return False
            elif len(line) > 2 and line[0:2] == '!!':
                return True
    
    #emptyLineRegex = re.compile('^\s*$')
    def next(self):
        if self.EOF:
            raise StopIteration

        map = {}
        key = ''
        value = ''
        while True:
            line = self.fin.readline()
            if len(line) == 0:#EOF
                self.EOF = True
                map[key] = value
                return map
            else:
                line = line.rstrip('\n')
            
            if len(line) < 2:#skip short line
                continue
            elif line[0:2] == '  ':#line with space 
                value += line[2:]
            elif line.isspace():#skip empty line
                key = ''
                continue
            elif line == '!!':#use '!!' as record seprator
                if len(key) != 0:
                    map[key] = value
                return map
            else:
                if len(key) != 0:
                    map[key] = value
                key = line[0:2]
                value = line[2:]
                
def test():
    #test empty file
    fout = file('tmp', 'w')
    fout.close()
    fin = file('tmp', 'r')
    for record in IndexSourceReader(fin):
        print record
    fin.close()
    #normal test
    fout = file('tmp', 'w')
    fout.write('''
!!
MD16144541215585970362
ID15230099286922373240
SD
TT乖乖女的大冒险</font
TA耒綄待續
TWjjwxc.net
TR
CL都市言情
CZcontinue
NC2
NI0
RQ0
NR0
NV0
NW0
XT1
SW7
PU
SP2,1,暂停
URhttp://www.jjwxc.net/onebook.php?novelid=638063
CC23
LC0,http://www.jjwxc.net/onebook.php?chapterid=2&novelid=638063,16144541215585959937,大骗局
LV0
CN2


TI我们这个年代美丽的孩子有很多，但，美
  丽又乖巧的孩
  
  子却不多。左左就是这个年代的凤毛麟角。典型的乖乖女，善解人意，美丽大方。不过，谁说乖乖女没有点激情和汹涌的梦想呢？！当面前出现两条截然不同的道路时，左左却出乎所有人的意料，选择了所谓的歪道！因为有一个人值得她去冒险，那个人也许会在她的冒险游戏的尽头，张开怀抱，热情迎接她。不值得未来会怎样，不去想他是否值得。 冒险已经开始，不能有别的选择……乖乖女的大冒险，倾力为你打造一个有趣坚定的“冒险”，就让我们一起跟着左左开始我们自己的冒险吧！
RN0
RP0
AN0
AP0

!!
MD11824615124931062845
ID14373317177837568088
SD
TT让我爱你
TA言信
TWjjwxc.net
TR
CL都市言情 耽美
CZfinish
NC22
NI0
RQ1230896701
NR0
NV0
NW0
XT1
SW7
PU
SP22,0,已完成
URhttp://www.jjwxc.net/onebook.php?novelid=416742
CC12567
LC0,http://www.jjwxc.net/onebook.php?chapterid=22&novelid=416742,11824615124931051541,第 22 章
LV0
CN22
TI一个富家公子，一个只是平民老百姓。他对他一见钟情，可是他却有过感情的创伤无法接受他的爱。经历了各种风波，他终于明白，他把自己全部交给他。“从今以后，我只有你了。”他抱住他，很多话，不言而喻。
RN1.3000
RP1.3000
AN2.4000
AP2.4000

!!

!!
''')
    fout.close()
    fin = file('tmp', 'r')
    for record in IndexSourceReader(fin):
        print record
        if 'TI' in record:
            print record['TI']
    fin.close()
    #clean
    os.remove('tmp')
        
    
if __name__ == '__main__':
    test()               
            
