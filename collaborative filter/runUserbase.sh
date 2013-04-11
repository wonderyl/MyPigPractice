cd /data/wonderyao/myPig

export JAVA_HOME=/usr;
export PATH=$PATH:/data/hadoop-0.20.9/bin/;
date
yesterday=`date -d"2 days ago" +"%Y%m%d"`
year=`date -d"1 day ago" +"%Y"`
month=`date -d"1 day ago" +"%m"`
day=`date -d"1 day ago" +"%d"`
/data/wonderyao/pig-0.9.2/bin/pig -f userbase_daily.pig -p CHN=novel -p YEAR=$year  -p MONTH=$month -p DAY=$day

date
