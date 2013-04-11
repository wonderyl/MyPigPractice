cd /data/wonderyao/myPig

export JAVA_HOME=/usr;
export PATH=$PATH:/data/hadoop-0.20.9/bin/;
date
yesterday=`date -d"2 days ago" +"%Y%m%d"`
year=`date -d"1 day ago" +"%Y"`
month=`date -d"1 day ago" +"%m"`
day=`date -d"1 day ago" +"%d"`
#/data/wonderyao/pig-0.9.2/bin/pig -f cf_daily_nosession.pig -p CHN=novel -p YEAR=$year -p MONTH=$month -p DAY=$day -p YESTERDAY=$yesterday -p SESSION_EXPIRE_MS=1800000 -p DISCOUNT=0.9
#/data/wonderyao/pig-0.9.2/bin/pig -f qqbase_daily.pig -p CHN=novel -p YEAR=2012 -p MONTH=04 -p DAY=10 -p YESTERDAY=20120409 -p DISCOUNT=0.9
/data/wonderyao/pig-0.9.2/bin/pig -f qqbase_daily.pig -p CHN=novel -p YEAR=2012 -p MONTH=04 -p DAY=11 -p YESTERDAY=20120410 -p DISCOUNT=0.9
/data/wonderyao/pig-0.9.2/bin/pig -f qqbase_daily.pig -p CHN=novel -p YEAR=2012 -p MONTH=04 -p DAY=12 -p YESTERDAY=20120411 -p DISCOUNT=0.9
/data/wonderyao/pig-0.9.2/bin/pig -f qqbase_daily.pig -p CHN=novel -p YEAR=2012 -p MONTH=04 -p DAY=13 -p YESTERDAY=20120412 -p DISCOUNT=0.9
/data/wonderyao/pig-0.9.2/bin/pig -f qqbase_daily.pig -p CHN=novel -p YEAR=2012 -p MONTH=04 -p DAY=14 -p YESTERDAY=20120413 -p DISCOUNT=0.9
/data/wonderyao/pig-0.9.2/bin/pig -f qqbase_daily.pig -p CHN=novel -p YEAR=2012 -p MONTH=04 -p DAY=15 -p YESTERDAY=20120414 -p DISCOUNT=0.9
/data/wonderyao/pig-0.9.2/bin/pig -f qqbase_daily.pig -p CHN=novel -p YEAR=2012 -p MONTH=04 -p DAY=16 -p YESTERDAY=20120415 -p DISCOUNT=0.9
/data/wonderyao/pig-0.9.2/bin/pig -f qqbase_daily.pig -p CHN=novel -p YEAR=2012 -p MONTH=04 -p DAY=17 -p YESTERDAY=20120416 -p DISCOUNT=0.9
/data/wonderyao/pig-0.9.2/bin/pig -f qqbase_daily.pig -p CHN=novel -p YEAR=2012 -p MONTH=04 -p DAY=18 -p YESTERDAY=20120417 -p DISCOUNT=0.9


date
