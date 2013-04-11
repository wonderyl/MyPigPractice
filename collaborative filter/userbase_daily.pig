register 'wonderyaoUdf.jar'
userItemCount = load '/user/wonderyao/cf/$CHN/userItemCountHistory/$YEAR$MONTH$DAY'
	as (uuid:chararray, id:chararray, count:double);
--cross
items = group userItemCount by id;
validitems = filter items by SIZE(userItemCount)>1 and SIZE(userItemCount)<3000;
total = foreach validitems generate group as id, SUM(userItemCount.count) as total;
precross = foreach validitems generate flatten(wonderyao.CrossSelf(userItemCount));
crossing = group precross by (id, crossKey);
joint = join crossing by group.id, total by id;
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
userRead = group userItemCount by uuid;
userTopRead = foreach userRead {
	orderedRead = order userItemCount by count DESC;
	topRead = limit orderedRead 20;
	generate flatten(topRead);
};
describe userTopRead;
recoReadByUser = join simuser by user2, userTopRead by uuid;
recoReadByUserWeight = foreach recoReadByUser generate user1, id, weight*count as weight;
userRecoGrp = group recoReadByUserWeight by (user1, id);
userRecoWeight = foreach userRecoGrp generate flatten(group), SUM(recoReadByUserWeight.weight) as weight;
describe userRecoWeight;
joinRecoRead = cogroup userItemCount by (uuid, id), userRecoWeight by (user1, id);
unread = filter joinRecoRead by IsEmpty(userItemCount);
describe unread;
userReco = foreach unread {
	recoOrdered = order userRecoWeight by weight Desc;
	generate flatten(userRecoWeight);
};
describe userReco;
userGrp = group userReco by user1;
describe userGrp;
store userGrp into '/user/wonderyao/cf/$CHN/userbase/recommend/$YEAR$MONTH$DAY'
	using wonderyao.NovelCFStore();



