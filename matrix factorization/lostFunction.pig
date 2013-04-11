
--%default Round 0
%default Lambda 0.01
--%default DATE 20130129

register 'wonderyaoUdf.jar'

rating = load '/user/wonderyao/interest/training/$DATE/rating' as (qq:chararray, item:chararray, weight:double);

qqvctsrc = load '/user/wonderyao/interest/training/$DATE/qqvct/$Round' as (qq:chararray, interest:tuple());
qqvct = foreach qqvctsrc generate qq, wonderyao.TupleString2Double(interest) as interest;
itemvctsrc = load '/user/wonderyao/interest/training/$DATE/itemvct/$Round' as (item:chararray, interest:tuple());
itemvct = foreach itemvctsrc generate item, wonderyao.TupleString2Double(interest) as interest;
leftpart = join rating by qq, qqvct by qq;
fullpart = join leftpart by item, itemvct by item;
describe fullpart;

e_ui = foreach fullpart generate leftpart::rating::weight - wonderyao.DotMultiple(leftpart::qqvct::interest, itemvct::interest) as error;
avggrp = group e_ui all;
avgerr = foreach avggrp generate AVG(e_ui.error);
store avgerr into '/user/wonderyao/interest/training/$DATE/lostFunction/$Round/avgError';
--squareError = foreach e_ui generate error*error as sqrerr;
--errgrp = group squareError all;
--sumSquareError = foreach errgrp generate SUM(squareError);
--store sumSquareError into '/user/wonderyao/interest/training/$DATE/lostFunction/$Round/sumSquareError';

qqnorm = foreach qqvct generate wonderyao.NormL1(interest) as norm;
qqnormgrp = group qqnorm all;
--sumqqnorm = foreach qqnormgrp generate $Lambda*SUM(qqnorm);
--store sumqqnorm into '/user/wonderyao/interest/training/$DATE/lostFunction/$Round/sumQQNorm';
avgqqnorm = foreach qqnormgrp generate AVG(qqnorm.norm);
store avgqqnorm into '/user/wonderyao/interest/training/$DATE/lostFunction/$Round/avgQQNorm';

itemnorm = foreach itemvct generate wonderyao.NormL1(interest) as norm;
itemnormgrp = group itemnorm all;
--sumitemnorm = foreach itemnormgrp generate $Lambda*SUM(itemnorm);
--store sumitemnorm into '/user/wonderyao/interest/training/$DATE/lostFunction/$Round/sumItemNorm';
avgitemnorm = foreach itemnormgrp generate AVG(itemnorm.norm);
store avgitemnorm into '/user/wonderyao/interest/training/$DATE/lostFunction/$Round/avgItemNorm';



