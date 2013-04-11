--set job.priority HIGH

--register 'wonderyaoUdf.jar'

--itemitemcount = load '/user/wonderyao/cf/$CHN/itemItemCount/$YEAR$MONTH$DAY' as (item1:chararray, item2:chararray, count: double);
--describe itemitemcount;
itemGrp = group itemitemcount by item1;
--describe itemGrp;
itemWeight = foreach itemGrp generate group as item, SUM(itemitemcount.weight) as weight;
cross1 = join itemitemcount by item2, itemWeight by item;
--describe cross1;
cross2 = join cross1 by item1, itemWeight by item;
--describe cross2;

itemItemScore = foreach cross2 generate item1, item2, cross1::itemitemcount::weight/(itemWeight::weight+cross1::itemWeight::weight)/LOG(cross1::itemWeight::weight) as score;
--describe itemItemScore;
--store itemItemScore into '/user/wonderyao/cf/$CHN/itemItemScore/$YEAR$MONTH$DAY';

item = group itemItemScore by item1;
recomm = foreach item {
    ordered = order itemItemScore by score DESC;
    head = limit ordered 20;
    generate group as item, head;
};
--describe recomm;
store recomm into '/user/wonderyao/cf/$CHN/itembase/recommend_both/$YEAR$MONTH$DAY'
    using wonderyao.NovelCFStore();
