cd /data/wonderyao/myPig

export JAVA_HOME=/usr;
export PATH=$PATH:/data/hadoop/bin/;
date
yesterday=`date -d"2 days ago" +"%Y%m%d"`
year=`date -d"1 day ago" +"%Y"`
month=`date -d"1 day ago" +"%m"`
day=`date -d"1 day ago" +"%d"`
/data/wonderyao/pig/bin/pig -f cf_daily_nosession.pig -p CHN=novel -p YEAR=$year -p MONTH=$month -p DAY=$day -p YESTERDAY=$yesterday -p SESSION_EXPIRE_MS=1800000 -p DISCOUNT=0.99
#/data/wonderyao/pig/bin/pig -f cf_daily_normalize.pig -p CHN=novel -p YEAR=$year -p MONTH=$month -p DAY=$day -p YESTERDAY=$yesterday -p SESSION_EXPIRE_MS=1800000 -p DISCOUNT=0.99
/data/wonderyao/pig/bin/pig -f cf_daily_normalize_both.pig -p CHN=novel -p YEAR=$year -p MONTH=$month -p DAY=$day -p YESTERDAY=$yesterday -p SESSION_EXPIRE_MS=1800000 -p DISCOUNT=0.99
#/data/wonderyao/pig-0.9.2/bin/pig -f cf_daily_nosession.pig -p CHN=novel -p YEAR=2012 -p MONTH=04 -p DAY=15 -p YESTERDAY=20120414 -p SESSION_EXPIRE_MS=1800000 -p DISCOUNT=0.9

./sendCF.sh "$year$month$day"

date
