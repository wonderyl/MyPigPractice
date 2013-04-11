
targetDate=$1

hadoop=/data/hadoop/bin/hadoop
$hadoop fs -ls /user/wonderyao/cf/novel/itembase/recommend_log/$targetDate/part-* && $hadoop fs -ls /user/wonderyao/cf/novel/itembase/recommend_both/$targetDate/part-* 
if [ "$?" -eq "0" ]
then
	$hadoop fs -cat /user/wonderyao/cf/novel/itembase/recommend_both/$targetDate/part-* >cf.dat
	./pull_file.sh cf.dat twapmusic@10.163.131.12:/data2/sh/hadoopcf Tw4pmusic
	$hadoop fs -cat /user/wonderyao/cf/novel/itembase/recommend_log/$targetDate/part-* >cf_b.dat
	./pull_file.sh cf_b.dat twapmusic@10.163.131.12:/data2/sh/hadoopcf Tw4pmusic
	touch ready.flag
	./pull_file.sh ready.flag twapmusic@10.163.131.12:/data2/sh/hadoopcf Tw4pmusic
	hour=`date +"%H"`
	if [ "$hour" -gt "12" ]
	then
		/usr/local/lpms/ServiceStsRep 535 1 "slow hadoop cf item"
	fi
else
	#alarm
	echo error	
	/usr/local/lpms/ServiceStsRep 535 1 "fail hadoop cf item"
fi
