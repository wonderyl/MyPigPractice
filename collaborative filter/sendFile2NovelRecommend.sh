
thefile=$1
dir=$2

./pull_file.sh $thefile tnovel@10.161.6.43:/data/tnovel_hint/i$dir Tn0vel
./pull_file.sh $thefile tnovel@10.161.6.43:/data1/tnovel_hint/$dir Tn0vel
./pull_file.sh $thefile tnovel@172.24.23.30:/data/tnovel_hint/$dir Tn0vel
./pull_file.sh $thefile tnovel@172.24.23.30:/data1/tnovel_hint/$dir Tn0vel
./pull_file.sh $thefile twapresys@10.151.139.170:/data/tnovel_hint/$dir Tw4presys
./pull_file.sh $thefile twapresys@10.151.139.170:/data1/tnovel_hint/$dir Tw4presys
./pull_file.sh $thefile twapresys@10.151.140.149:/data/tnovel_hint/$dir Tw4presys
./pull_file.sh $thefile twapresys@10.151.140.149:/data1/tnovel_hint/$dir Tw4presys

