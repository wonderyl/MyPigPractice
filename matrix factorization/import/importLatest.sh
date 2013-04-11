
cd /data/wonderyao/interest/import
export JAVA_HOME=/usr;
export PATH=$PATH:/data/hadoop/bin/:/data/wonderyao/pig/bin/;

date
last=`hadoop fs -ls /user/wonderyao/interest/training/|sort -k6|gawk '{print $8}'|gawk -F'/' '{print $6}'|tail -1`
lastRound=`hadoop fs -ls /user/wonderyao/interest/training/$last/qqvct |gawk '{print $8}'|gawk -F'/' '{print $8}'|sort -n|tail -1`
echo "import from $last $lastRound"
date
echo 'import qqvct'
hadoop fs -cat /user/wonderyao/interest/training/$last/qqvct/$lastRound/part*| python ./importVector.py 1 
date
echo 'import itemvct'
hadoop fs -cat /user/wonderyao/interest/training/$last/itemvct/$lastRound/part*| python ./importVector.py 2 
date
echo 'Done'
