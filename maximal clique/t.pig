register 'wonderyaoUdf.jar'
--a = load '/user/wonderyao/test/t.txt' as (t:tuple());
--a = load '/user/wonderyao/test/r.txt' as (t1:chararray, t2:chararray);
--b = foreach a generate wonderyao.ToTuple2(t1, t2);
--b = foreach a generate Tuple(t1, t2);
--dump b;
--store a into '/user/wonderyao/test/o.txt';

a = load '/user/wonderyao/test/s.txt' as (v:int);
b = foreach a generate wonderyao.ZeroIsNull(v) as r;
c = filter b by r is not null;
dump c;

