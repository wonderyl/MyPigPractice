
register 'wonderyaoUdf.jar'
--load log
--logs = load '/kvlogs/novel/2012/04/*20120418*log'
--	using wonderyao.KVLogLoader('t:long, statIgnore:int, uuid:chararray, id:chararray')
--	as (t:long, statIgnore:int, uuid:chararray, id:chararray);
--dump logs;


a = load '/b' as (name1: chararray, name2:chararray, weight: double);
b = load '/a' as (name: chararray, weight: double);
c = foreach b generate name, weight;
g1 = join a by name1, b by name;
g2 = join g1 by name2, c by name;
describe g2;
s = foreach g2 generate name1, name2, a::weight/(b::weight + c::weight);
describe s;



