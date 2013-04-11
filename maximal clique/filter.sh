
for i in {5..21}
do
    echo $i $[i+1] 
    /data/wonderyao/pig/bin/pig -p Size=$i -p NextSize=$[i+1] maximalCliqueFilter.pig 

done
