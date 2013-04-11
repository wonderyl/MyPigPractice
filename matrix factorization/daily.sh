
cd /data/wonderyao/interest

export JAVA_HOME=/usr;
export PATH=$PATH:/data/hadoop/bin/:/data/wonderyao/pig/bin/;

Year=`date -d"1 day ago" +"%Y"`
Month=`date -d"1 day ago" +"%m"`
Day=`date -d"1 day ago" +"%d"`
Yesterday=`date -d"2 days ago" +"%Y%m%d"`

echo $Year $Month $Day $Yesterday

pig -p YEAR=$Year -p MONTH=$Month -p DAY=$Day -p YESTERDAY=$Yesterday qqIDCount.pig 


#manual
#pig -p YEAR=2013 -p MONTH=03 -p DAY=09 -p YESTERDAY=20130308 qqIDCount.pig 
#pig -p YEAR=2013 -p MONTH=03 -p DAY=10 -p YESTERDAY=20130309 qqIDCount.pig 




