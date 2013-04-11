
cd /data/wonderyao/interest

export JAVA_HOME=/usr;
export PATH=$PATH:/data/hadoop/bin/:/data/wonderyao/pig/bin/;

#pig calcRating.pig
#pig initInterest.pig
#pig -p Round=0 lostFunction.pig
for i in {1..10}
do
    echo "Round $i"
    #pig -p Round=$[i-1] -p NextRound=$i matrixFactorizationGredianDescent.pig 
    if [ ! "$[(i-1)%5]" -eq "0" ]
    then
        #pig -p Round=$i lostFunction.pig
        echo bo
    fi
done
