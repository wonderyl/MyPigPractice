
export JAVA_HOME=/usr;
export PATH=$PATH:/data/hadoop/bin/;
date
/data/wonderyao/pig/bin/pig -f getUserBehavior.pig -p YEAR=2012 -p MONTH=06 -p DAY=17 
/data/wonderyao/pig/bin/pig -f getUserBehavior.pig -p YEAR=2012 -p MONTH=06 -p DAY=18 
/data/wonderyao/pig/bin/pig -f getUserBehavior.pig -p YEAR=2012 -p MONTH=06 -p DAY=19 
/data/wonderyao/pig/bin/pig -f getUserBehavior.pig -p YEAR=2012 -p MONTH=06 -p DAY=20 
