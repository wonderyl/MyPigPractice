register 'wonderyaoUdf.jar'
logs = load '/kvlogs/novel/2012/*/*.log'
    using wonderyao.KVLogLoader('uuid:chararray, qq:long')
    as (uuid:chararray, qq:long);
positive = filter logs by qq>0;
grp = group positive by (uuid, qq);
cnt = foreach grp generate flatten(group), COUNT(positive);
store cnt into '/user/wonderyao/test/uuidqq';


