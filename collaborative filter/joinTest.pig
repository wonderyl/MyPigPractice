a = load '/tmp/a.txt' as (num:int, letter:chararray);
b = load '/tmp/b.txt' as (lower:chararray, upper:chararray);
j = join a by letter, b by lower;
dump j;
