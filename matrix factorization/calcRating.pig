--%default DATE 20130129

qqItemCount = load '/user/wonderyao/interest/qqIDCount/$DATE' 
    as (qq:chararray, item:chararray, count:double);
valid = filter qqItemCount by count > 1;
weight = foreach valid generate qq, item, LOG10(count) as weight;
store weight into '/user/wonderyao/interest/training/$DATE/rating';
