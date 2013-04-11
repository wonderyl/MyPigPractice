
register 'wonderyaoUdf.jar'
data1 = load '/user/wonderyao/test/a.txt' as (value:chararray, key:int);
data2 = load '/user/wonderyao/test/r.txt' as (key:int, value:int);

j = join data1 by key left, data2 by key;
dump j;
f = foreach j generate wonderyao.AorB(data2::value, data1::value);
dump f;
