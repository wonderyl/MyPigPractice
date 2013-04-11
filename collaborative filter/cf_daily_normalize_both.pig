set job.priority HIGH

register 'wonderyaoUdf.jar'
/*
--load log
logs = load '/kvlogs/novel/$YEAR/$MONTH/*$YEAR$MONTH$DAY*.log'
	using wonderyao.KVLogLoader('t:long, statIgnore:int, uuid:chararray, id:chararray')
	as (t:long, statIgnore:int, uuid:chararray, id:chararray);
validlogs = filter logs by statIgnore==0 and
	t!=0 and 
	uuid!='' and uuid!='MC0wLXh4i' and uuid!='MC0xLXh4' and 
	id matches '[0-9]+';
--session deduplicate
--sessionlogs = foreach validlogs generate uuid, t, id;
rawlogs = foreach validlogs generate uuid, t, id;
--session = group sessionlogs by uuid;
--define SessionDedup wonderyao.SessionDedup('$SESSION_EXPIRE_MS');
--deduped = foreach session generate flatten(SessionDedup(sessionlogs));
--user item count
--userid = group deduped by (uuid, id);
userid = group rawlogs by (uuid, id);
--userItemCount = foreach userid generate flatten(group), COUNT(deduped) as count;
userItemCount = foreach userid generate flatten(group), COUNT(rawlogs) as count;
store userItemCount into '/user/wonderyao/cf/$CHN/userItemCount/$YEAR$MONTH$DAY';
--load history
--history = load '/user/wonderyao/cf/$CHN/itembase/history/$YESTERDAY/part-*' 
history = load '/user/wonderyao/cf/$CHN/userItemCountHistory/$YESTERDAY/part-*' 
	as (uuid:chararray, id:chararray, count:double);
discounted = foreach history generate uuid, id, count*$DISCOUNT as count;
both = union discounted, userItemCount;
grp = group both by (uuid, id);
sumed = foreach grp generate flatten(group), SUM(both.count) as count;
big = filter sumed by count>5;
--store sumed into '/user/wonderyao/cf/$CHN/itembase/history/$YEAR$MONTH$DAY';
--store sumed into '/user/wonderyao/cf/$CHN/userItemCountHistory/$YEAR$MONTH$DAY';
store big into '/user/wonderyao/cf/$CHN/userItemCountHistory/$YEAR$MONTH$DAY';
*/
big = load '/user/wonderyao/cf/$CHN/userItemCountHistory/$YEAR$MONTH$DAY'
    as (uuid:chararray, id:chararray, count:double);
--calc relation
loged = foreach big generate uuid, id, LOG10(count) as count parallel 128;
usergrp = group loged by uuid;
describe usergrp;
normalUserGrp = filter usergrp by SIZE(loged) < 500 and SIZE(loged) > 1;
total = foreach normalUserGrp generate group as uuid, SUM(loged.count) as total;
precross = foreach normalUserGrp generate flatten(wonderyao.CrossSelf(loged));
crossing = group precross by (uuid, crossKey) parallel 64;
joint = join crossing by group.uuid, total by uuid;
describe joint;
crossed = foreach joint generate flatten(wonderyao.CalcItemWeight(precross, total));
describe crossed;
--recommend
itemitem = group crossed by (item1, item2);
itemitemcount = foreach itemitem generate flatten(group), SUM(crossed.count) as weight;
describe itemitemcount;
--store itemitemcount into '/user/wonderyao/cf/$CHN/itemItemCount/$YEAR$MONTH$DAY';
--item2s = group crossed by item2;
--item2count = foreach item2s generate group as item2, SUM(crossed.count) as totalweight;
item2s = group itemitemcount by item2;
item2count = foreach item2s generate group as item2, SUM(itemitemcount.weight) as totalweight;
normitems = join itemitemcount by item2, item2count by item2;
describe normitems;
normeditems = foreach normitems generate item1, item2count::item2, weight/LOG(totalweight) as weight;
item = group normeditems by item1;
recomm = foreach item {
	ordered = order normeditems by weight DESC;
	head = limit ordered 20;
	generate group as item, head;
};
--store recomm into '/user/wonderyao/test/log_$YEAR$MONTH$DAY' 
store recomm into '/user/wonderyao/cf/$CHN/itembase/recommend_log/$YEAR$MONTH$DAY' 
	using wonderyao.NovelCFStore();

--set job.priority HIGH

--register 'wonderyaoUdf.jar'

--itemitemcount = load '/user/wonderyao/cf/$CHN/itemItemCount/$YEAR$MONTH$DAY' as (item1:chararray, item2:chararray, count: double);
describe itemitemcount;
itemGrp = group itemitemcount by item1;
describe itemGrp;
itemWeight = foreach itemGrp generate group as item, SUM(itemitemcount.weight) as weight;
cross1 = join itemitemcount by item2, itemWeight by item;
describe cross1;
cross2 = join cross1 by item1, itemWeight by item;
describe cross2;
fltCross = filter cross2 by cross1::itemWeight::weight >= 2.72; 
itemItemScore = foreach fltCross generate item1, item2, cross1::itemitemcount::weight/(itemWeight::weight+cross1::itemWeight::weight)/LOG(cross1::itemWeight::weight) as score;

--itemItemScore = foreach cross2 generate item1, item2, cross1::itemitemcount::weight/(itemWeight::weight+cross1::itemWeight::weight)/LOG(cross1::itemWeight::weight) as score;
describe itemItemScore;
--store itemItemScore into '/user/wonderyao/cf/$CHN/itemItemScore/$YEAR$MONTH$DAY';

item = group itemItemScore by item1;
recomm = foreach item {
    ordered = order itemItemScore by score DESC;
    head = limit ordered 50;
    generate group as item, head;
};
describe recomm;
store recomm into '/user/wonderyao/cf/$CHN/itembase/recommend_both/$YEAR$MONTH$DAY'
    using wonderyao.NovelCFStore();
