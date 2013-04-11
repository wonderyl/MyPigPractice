
cd /data/wonderyao/interest

export JAVA_HOME=/usr;
export PATH=$PATH:/data/hadoop/bin/:/data/wonderyao/pig/bin/;

theday=`date -d"20 days ago" +"%Y%m%d"`

echo $theday 

hadoop fs -rmr /user/wonderyao/interest/qqIDCount/$theday





