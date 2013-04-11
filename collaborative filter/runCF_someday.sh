cd /data/wonderyao/myPig

export JAVA_HOME=/usr;
export PATH=$PATH:/data/hadoop-0.20.9/bin/;
date
yesterday=`date -d"2 days ago" +"%Y%m%d"`
year=`date -d"1 day ago" +"%Y"`
month=`date -d"1 day ago" +"%m"`
day=`date -d"1 day ago" +"%d"`
#/data/wonderyao/pig-0.9.2/bin/pig -f cf_daily_nosession.pig -p CHN=novel -p YEAR=$year -p MONTH=$month -p DAY=$day -p YESTERDAY=$yesterday -p SESSION_EXPIRE_MS=1800000 -p DISCOUNT=0.9
/data/wonderyao/pig/bin/pig -f cf_someday.pig -p CHN=novel -p YEAR=2012 -p MONTH=12 -p DAY=02 -p YESTERDAY=20121201 -p SESSION_EXPIRE_MS=1800000 -p DISCOUNT=0.9
#/data/wonderyao/pig/bin/pig -f cf_daily_nosession.pig -p CHN=novel -p YEAR=2012 -p MONTH=12 -p DAY=03 -p YESTERDAY=20121202 -p SESSION_EXPIRE_MS=1800000 -p DISCOUNT=0.9
#/data/wonderyao/pig/bin/pig -f cf_daily_normalize_both.pig -p CHN=novel -p YEAR=2012 -p MONTH=12 -p DAY=03 -p YESTERDAY=20121202 -p SESSION_EXPIRE_MS=1800000 -p DISCOUNT=0.99

#./sendCF.sh "$year$month$day"

date
