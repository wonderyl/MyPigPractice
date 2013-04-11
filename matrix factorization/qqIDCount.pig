
%default DiscountRate 0.95

register 'wonderyaoUdf.jar'
logs = load '/kvlogs/novel/$YEAR/$MONTH/*$YEAR$MONTH$DAY*.log'
    using wonderyao.KVLogLoader('statIgnore:int, qq:int, id:chararray, cno:int, act:chararray')
    as (statIgnore:int, qq:int, id:chararray, cno:int, act:chararray);
valid = filter logs by statIgnore==0 and qq>0 and act=='detail' and id matches '[0-9]+';
useful = foreach valid generate qq, id, cno;
chapterOnce = distinct useful;
grp = group chapterOnce by (qq, id);
daily = foreach grp generate flatten(group), COUNT(chapterOnce) as count;
big = filter daily by count > 5;

history = load '/user/wonderyao/interest/qqIDCount/$YESTERDAY' as (qq:int, id:chararray, count:float);
discounted = foreach history generate qq, id, count*$DiscountRate as count;

both = union big, discounted;
bgrp = group both by (qq, id);
total = foreach bgrp generate flatten(group), SUM(both.count) as count;
alive = filter total by count > 1;
store alive into '/user/wonderyao/interest/qqIDCount/$YEAR$MONTH$DAY';


