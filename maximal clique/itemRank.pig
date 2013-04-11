
useritemWeight = load '/user/wonderyao/cf/novel/userItemCountHistory/20130103' 
    as (user:chararray, item:chararray, weight:double);
grp = group useritemWeight by item;
itemWeight = foreach grp generate group as item, SUM(useritemWeight.weight) as weight;
ordered = order itemWeight by weight DESC;
store ordered into '/user/wonderyao/itemWeight/20130103';

