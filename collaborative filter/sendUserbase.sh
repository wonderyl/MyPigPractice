
targetDate=$1

hadoop=/data/hadoop/bin/hadoop
$hadoop fs -ls /user/wonderyao/cf/novel/userbase/recommend/$targetDate/part-*
if [ "$?" -eq "0" ]
then
	$hadoop fs -cat /user/wonderyao/cf/novel/userbase/recommend/$targetDate/part-* >userbase.dat

	./pull_file.sh userbase.dat tnovel@10.161.6.43:/data/tnovel_hint/bin Tn0vel
#    ./remoteCommand.sh tnovel@10.161.6.43 Tn0vel "cd /data/tnovel_hint/bin; start.sh"
    sleep 30
    ./remoteCommand.sh tnovel@10.161.6.43 Tn0vel "cp /data/tnovel_hint/bin/userbase.dat /data1/tnovel_hint/bin"
#    ./remoteCommand.sh tnovel@10.161.6.43 Tn0vel "cd /data1/tnovel_hint/bin; start.sh"
    sleep 30

	./pull_file.sh userbase.dat tnovel@172.24.23.30:/data/tnovel_hint/bin Tn0vel
#    ./remoteCommand.sh tnovel@172.24.23.30 Tn0vel "cd /data/tnovel_hint/bin; start.sh"
    sleep 30
    ./remoteCommand.sh tnovel@172.24.23.30 Tn0vel "cp /data/tnovel_hint/bin/userbase.dat /data1/tnovel_hint/bin"
#    ./remoteCommand.sh tnovel@172.24.23.30 Tn0vel "cd /data1/tnovel_hint/bin; start.sh"
    sleep 30

	./pull_file.sh userbase.dat twapresys@10.151.139.170:/data/tnovel_hint/bin Tw4presys
#    ./remoteCommand.sh twapresys@10.151.139.170 Tw4presys "cd /data/tnovel_hint/bin; start.sh"
    sleep 30
    ./remoteCommand.sh twapresys@10.151.139.170 Tw4presys "cp /data/tnovel_hint/bin/userbase.dat /data1/tnovel_hint/bin"
#    ./remoteCommand.sh twapresys@10.151.139.170 Tw4presys "cd /data1/tnovel_hint/bin; start.sh"
    sleep 30

	./pull_file.sh userbase.dat twapresys@10.151.140.149:/data/tnovel_hint/bin Tw4presys
#    ./remoteCommand.sh twapresys@10.151.140.149 Tw4presys "cd /data/tnovel_hint/bin; start.sh"
    sleep 30
    ./remoteCommand.sh twapresys@10.151.140.149 Tw4presys "cp /data/tnovel_hint/bin/userbase.dat /data1/tnovel_hint/bin"
#    ./remoteCommand.sh twapresys@10.151.140.149 Tw4presys "cd /data1/tnovel_hint/bin; start.sh"


	hour=`date +"%H"`
	if [ "$hour" -gt "9" ]
	then
		/usr/local/lpms/ServiceStsRep 535 1 "slow hadoop user base"
        echo 
	fi
else
	#alarm
	echo error	
	/usr/local/lpms/ServiceStsRep 535 1 "fail hadoop user base"
fi
