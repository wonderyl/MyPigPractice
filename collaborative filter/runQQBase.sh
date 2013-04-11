cd /data/wonderyao/myPig

export JAVA_HOME=/usr;
export PATH=$PATH:/data/hadoop/bin/;
date
yesterday=`date -d"2 days ago" +"%Y%m%d"`
year=`date -d"1 day ago" +"%Y"`
month=`date -d"1 day ago" +"%m"`
day=`date -d"1 day ago" +"%d"`
/data/wonderyao/pig/bin/pig -f qqbase_daily.pig -p CHN=novel -p YEAR=$year  -p MONTH=$month -p DAY=$day -p YESTERDAY=$yesterday -p DISCOUNT=0.9

./sendUserbase.sh "$year$month$day"

date
