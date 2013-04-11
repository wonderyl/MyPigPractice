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

--cross
idqqcount = foreach big generate id, qq, count;
items = group idqqcount by id;
validitems = filter items by SIZE(idqqcount)>1 and SIZE(idqqcount)<1000 parallel 32;
total = foreach validitems generate group as id, SUM(idqqcount.count) as total;
set pig.splitCombination false
precross = foreach validitems generate flatten(wonderyao.CrossSelf(idqqcount)) parallel 32;
crossing = group precross by (id, crossKey) parallel 32;
joint = join crossing by group.id, total by id parallel 32;
crossed = foreach joint generate flatten(wonderyao.CalcItemWeight(precross, total));
describe crossed;
--similar user
useruser = group crossed by (item1, item2);
userusercount = foreach useruser generate flatten(group) as (user1, user2), SUM(crossed.count) as weight;
user = group userusercount by user1;
simuser = foreach user {
	ordered = order userusercount by weight DESC;
	head = limit ordered 20;
	generate flatten(head);
};
describe simuser;
store simuser into '/user/wonderyao/cf/$CHN/userbase/simUser/$YEAR$MONTH$DAY';
--recommend
userRead = group sumed by qq;
userTopRead = foreach userRead {
	orderedRead = order sumed by count DESC;
	topRead = limit orderedRead 20;
	generate flatten(topRead);
};
describe userTopRead;
recoReadByUser = join simuser by user2, userTopRead by qq;
recoReadByUserWeight = foreach recoReadByUser generate user1, id, weight*count as weight;
userRecoGrp = group recoReadByUserWeight by (user1, id);
userRecoWeight = foreach userRecoGrp generate flatten(group), SUM(recoReadByUserWeight.weight) as weight;
describe userRecoWeight;
joinRecoRead = cogroup sumed by (qq, id), userRecoWeight by (user1, id);
unread = filter joinRecoRead by IsEmpty(sumed);
describe unread;
userReco = foreach unread generate flatten(userRecoWeight);
--userReco = foreach unread {
--	recoOrdered = order userRecoWeight by weight DESC;
--	head = limit recoOrdered 20;
--	generate flatten(userRecoWeight);
--};
describe userReco;
userGrp = group userReco by user1;
recomm = foreach userGrp {
	orderedReco = order userReco by weight;
	headReco = limit orderedReco 20;
	generate group as qq, headReco;
};
describe recomm;
store recomm into '/user/wonderyao/cf/$CHN/userbase/recommend/$YEAR$MONTH$DAY'
	using wonderyao.NovelCFStore();

