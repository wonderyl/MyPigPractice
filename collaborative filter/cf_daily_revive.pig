register 'wonderyaoUdf.jar'
--load log
logs = load '/kvlogs/novel/$YEAR/$MONTH/*$YEAR$MONTH$DAY*.log'
	using wonderyao.KVLogLoader('t:long, statIgnore:int, uuid:chararray, id:chararray')
	as (t:long, statIgnore:int, uuid:chararray, id:chararray);
validlogs = filter logs by statIgnore==0 and
	t!=0 and 
	uuid!='' and uuid!='MC0wLXh4i' and uuid!='MC0xLXh4' and 
	id matches '[0-9]+';
--session deduplicate
sessionlogs = foreach validlogs generate uuid, t, id;
session = group sessionlogs by uuid;
define SessionDedup wonderyao.SessionDedup('$SESSION_EXPIRE_MS');
deduped = foreach session generate flatten(SessionDedup(sessionlogs));
--user item count
userid = group deduped by (uuid, id);
userItemCount = foreach userid generate flatten(group), COUNT(deduped) as count;
store userItemCount into '/user/wonderyao/cf/$CHN/userItemCount/$YEAR$MONTH$DAY';
--load history
--history = load '/user/wonderyao/cf/$CHN/itembase/history/$YESTERDAY/part-*' 
history = load '/user/wonderyao/cf/$CHN/userItemCountHistory/$YESTERDAY/part-*' 
	as (uuid:chararray, id:chararray, count:double);
discounted = foreach history generate uuid, id, count*$DISCOUNT as count;
big = filter discounted by count>0.05;
both = union big, userItemCount;
grp = group both by (uuid, id);
sumed = foreach grp generate flatten(group), SUM(both.count) as count;
--store sumed into '/user/wonderyao/cf/$CHN/itembase/history/$YEAR$MONTH$DAY';
store sumed into '/user/wonderyao/cf/$CHN/userItemCountHistory/$YEAR$MONTH$DAY';
--calc relation
usergrp = group sumed by uuid;
describe usergrp;
total = foreach usergrp generate group as uuid, SUM(sumed.count) as total;
precross = foreach usergrp generate flatten(wonderyao.CrossSelf(sumed));
crossing = group precross by (uuid, crossKey);
joint = join crossing by group.uuid, total by uuid;
describe joint;
crossed = foreach joint generate flatten(wonderyao.CalcItemWeight(precross, total));
--recommend
itemitem = group crossed by (item1, item2);
itemitemcount = foreach itemitem generate flatten(group), SUM(crossed.count) as weight;
item = group itemitemcount by item1;
recomm = foreach item {
	ordered = order itemitemcount by weight DESC;
	head = limit ordered 20;
	generate group as item, head;
};
store recomm into '/user/wonderyao/cf/$CHN/itembase/recommend/$YEAR$MONTH$DAY' 
	using wonderyao.NovelCFStore();


