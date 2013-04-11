set job.priority HIGH
register 'wonderyaoUdf.jar'
--load log
logs = load '/kvlogs/novel/$YEAR/$MONTH/*$YEAR$MONTH$DAY*.log'
--logs = load '/kvlogs/novel/2012/04/novel_acs_2012041823.log'
--logs = load '/user/wonderyao/test/itemRead/part-*';
	using wonderyao.KVLogLoader('statIgnore:int, qq:long, id:chararray')
	as (statIgnore:int, qq:long, id:chararray);
--dump logs;
validlogs = filter logs by statIgnore==0 and qq>0 and id matches '[0-9]+';
qqid = group validlogs by (qq, id);
qqidcount = foreach qqid generate flatten(group), COUNT(validlogs);
store qqidcount into '/user/wonderyao/cf/$CHN/qqItemCount/$YEAR$MONTH$DAY';
--load history
history = load '/user/wonderyao/cf/$CHN/qqItemCountHistory/$YESTERDAY/part-*'
	as (qq:long, id:chararray, count: double);
discounted = foreach history generate qq, id, count*$DISCOUNT as count;
both = union discounted, qqidcount;
grp = group both by (qq, id);
define L2a InvokeForString('java.lang.Long.toString', 'long');
sumed = foreach grp generate L2a(group.qq) as qq, group.id, SUM(both.count) as count;
big = filter sumed by count>5;
store big into '/user/wonderyao/cf/$CHN/qqItemCountHistory/$YEAR$MONTH$DAY';

