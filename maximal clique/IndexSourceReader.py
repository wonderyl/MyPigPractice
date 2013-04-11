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
TT�Թ�Ů�Ĵ�ð��</font
TA�罌���m
TWjjwxc.net
TR
CL��������
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
SP2,1,��ͣ
URhttp://www.jjwxc.net/onebook.php?novelid=638063
CC23
LC0,http://www.jjwxc.net/onebook.php?chapterid=2&novelid=638063,16144541215585959937,��ƭ��
LV0
CN2


TI���������������ĺ����кܶ࣬������
  ���ֹ��ɵĺ�
  
  ��ȴ���ࡣ��������������ķ�ë��ǡ����͵ĹԹ�Ů���ƽ����⣬�����󷽡�������˭˵�Թ�Ůû�е㼤�����ӿ�������أ�������ǰ����������Ȼ��ͬ�ĵ�·ʱ������ȴ���������˵����ϣ�ѡ������ν���������Ϊ��һ����ֵ����ȥð�գ��Ǹ���Ҳ���������ð����Ϸ�ľ�ͷ���ſ�����������ӭ��������ֵ��δ������������ȥ�����Ƿ�ֵ�á� ð���Ѿ���ʼ�������б��ѡ�񡭡��Թ�Ů�Ĵ�ð�գ�����Ϊ�����һ����Ȥ�ᶨ�ġ�ð�ա�����������һ���������ʼ�����Լ���ð�հɣ�
RN0
RP0
AN0
AP0

!!
MD11824615124931062845
ID14373317177837568088
SD
TT���Ұ���
TA����
TWjjwxc.net
TR
CL�������� ����
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
SP22,0,�����
URhttp://www.jjwxc.net/onebook.php?novelid=416742
CC12567
LC0,http://www.jjwxc.net/onebook.php?chapterid=22&novelid=416742,11824615124931051541,�� 22 ��
LV0
CN22
TIһ�����ҹ��ӣ�һ��ֻ��ƽ���ϰ��ա�������һ�����飬������ȴ�й�����Ĵ����޷��������İ��������˸��ַ粨�����������ף������Լ�ȫ�������������ӽ��Ժ���ֻ�����ˡ�������ס�����ܶ໰�����Զ�����
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
            
