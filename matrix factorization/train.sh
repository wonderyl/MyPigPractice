
cd /data/wonderyao/interest

export JAVA_HOME=/usr;
export PATH=$PATH:/data/hadoop/bin/:/data/wonderyao/pig/bin/;

today=`hadoop fs -ls /user/wonderyao/interest/qqIDCount|gawk '{print $8}'|gawk -F'/' '{print $6}'|sort|tail -1`
last=`hadoop fs -ls /user/wonderyao/interest/training/|sort -k6|gawk '{print $8}'|gawk -F'/' '{print $6}'|tail -1`
lastRound=`hadoop fs -ls /user/wonderyao/interest/training/$last/qqvct |gawk '{print $8}'|gawk -F'/' '{print $8}'|sort -n|tail -1`
#today='20130311'
echo $today $last $lastRound
#exit
pig -p DATE=$today calcRating.pig
pig -p DATE=$today -p Previous=$last -p PreRound=$lastRound initInterest.pig
pig -p DATE=$today -p Round=0 lostFunction.pig
#<<comment
for i in {1..50}
do
    echo "Round $i"
    pig -p DATE=$today -p Round=$[i-1] -p NextRound=$i matrixFactorizationGredianDescent.pig 
    if [ "$[i%5]" -eq "0" ]
    then
        pig -p DATE=$today -p Round=$i lostFunction.pig
    fi
    if [ ! "$[(i-1)%5]" -eq "0" ]
    then
        hadoop fs -rmr /user/wonderyao/interest/training/$today/qqvct/$[i-1]/
        hadoop fs -rmr /user/wonderyao/interest/training/$today/itemvct/$[i-1]/
    fi
done
#comment
