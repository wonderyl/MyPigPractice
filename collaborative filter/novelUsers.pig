register 'wonderyaoUdf.jar'
--logs3 = load '/kvlogs/novel/2012/03/*.log'
--	using wonderyao.KVLogLoader('statIgnore:int, qq:long')
--	as (statIgnore:int, qq:long);
logs = load '/kvlogs/novel/2012/04/*.log'
    using wonderyao.KVLogLoader('statIgnore:int, qq:long')
    as (statIgnore:int, qq:long);
--logs = union logs3, logs4;
validlogs = filter logs by statIgnore==0 and qq>0;
qqlog = foreach validlogs generate qq;
qq =  distinct qqlog;
store qq into '/user/wonderyao/test/qq';

