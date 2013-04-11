
export JAVA_HOME=/usr;
export PATH=$PATH:/data/hadoop/bin/;

date
/data/wonderyao/pig/bin/pig -f itemitemWeight.pig #-p YEAR=2012 -p MONTH=12 -p DAY=27
date
