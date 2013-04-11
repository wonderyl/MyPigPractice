set job.priority HIGH

register 'wonderyaoUdf.jar'

itemItemWeight = load '/user/wonderyao/cf/$CHN/itemItemCount/$YEAR$MONTH$DAY' as (item1:chararray, item2:chararray, weight: double);
describe itemItemWeight;
itemGrp = group itemItemWeight by item1;
describe itemGrp;
item1Weight = foreach itemGrp generate group as item, SUM(itemItemWeight.weight) as weight;
item2Grp = group itemItemWeight by item2;
--item2Weight = foreach item1Weight generate item, weight;
item2Weight = foreach item2Grp generate group as item, SUM(itemItemWeight.weight) as weight;
cross1 = join itemItemWeight by item1, item1Weight by item;
describe cross1;
cross2 = join cross1 by item2, item2Weight by item;
describe cross2;

itemItemScore = foreach cross2 generate cross1::itemItemWeight::item1, cross1::itemItemWeight::item2, cross1::itemItemWeight::weight/(cross1::item1Weight::weight+item2Weight::weight)/LOG(item2Weight::weight) as score;
describe itemItemScore;

item = group itemItemScore by item1;
recomm = foreach item {
    ordered = order itemItemScore by score DESC;
    head = limit ordered 20;
    generate group as item, head;
};
describe recomm;
