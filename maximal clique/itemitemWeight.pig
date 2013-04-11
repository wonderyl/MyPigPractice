set job.priority LOW

register 'wonderyaoUdf.jar'
--raw = load '/user/wonderyao/cf/novel/userItemCountHistory/$YEAR$MONTH$DAY'
raw = load '/user/wonderyao/cluster/userItemCount_20k.txt'
    as (uuid:chararray, id:chararray, count:double);
--calc relation
big = filter raw by count>1;
loged = foreach big generate uuid, id, LOG10(count) as count parallel 128;
usergrp = group loged by uuid;
describe usergrp;
normalUserGrp = filter usergrp by SIZE(loged) < 500 and SIZE(loged) > 1;
--total = foreach normalUserGrp generate group as uuid, SUM(loged.count) as total;
precross = foreach normalUserGrp generate flatten(wonderyao.CrossSelf(loged));
crossing = group precross by (uuid, crossKey) parallel 64;
--joint = join crossing by group.uuid, total by uuid;
--describe joint;
crossed = foreach crossing generate flatten(wonderyao.CalcItemWeight2(precross));
describe crossed;
--recommend
itemitem = group crossed by (item1, item2);
itemitemcount = foreach itemitem generate flatten(group), SUM(crossed.count) as weight;
describe itemitemcount;
--store itemitemcount into '/user/wonderyao/cf/$CHN/itemItemCount/$YEAR$MONTH$DAY';
--item2s = group crossed by item2;
--item2count = foreach item2s generate group as item2, SUM(crossed.count) as totalweight;
items = group itemitemcount by item2;
itemcount = foreach items generate group as item2, SUM(itemitemcount.weight) as totalweight;
biitems = join itemitemcount by item2, itemcount by item2;
describe biitems;
triitems = join biitems by itemitemcount::group::null::item1, itemcount by item2;
describe triitems;
normeditems = foreach triitems generate biitems::itemitemcount::group::null::item1 as item1, biitems::itemitemcount::group::null::item2 as item2, weight/(biitems::itemcount::totalweight+itemcount::totalweight) as weight;
--store normeditems into '/user/wonderyao/cluster/itemitemWeight/$YEAR$MONTH$DAY';
store normeditems into '/user/wonderyao/cluster/itemitemWeight/20k';
