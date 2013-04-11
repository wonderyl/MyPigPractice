
pairs = load '/user/wonderyao/cluster/maximalCliqueTmp/2/'
    as (pair:tuple());
keys = foreach pairs generate pair.$0 as key;
grp = group keys by key;
cnt = foreach grp generate group, COUNT(keys);
store cnt into  '/user/wonderyao/test/itemcount';

