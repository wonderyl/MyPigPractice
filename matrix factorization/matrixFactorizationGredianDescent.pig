
--%default Round 0
--%default NextRound 1
%default LeaningRate 0.01
%default Lambda1 0.01
%default Lambda2 0.01
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
e_ui = foreach fullpart generate leftpart::rating::qq as qq, leftpart::qqvct::interest as qqInterest, leftpart::rating::item as item, itemvct::interest as itemInterest, leftpart::rating::weight - wonderyao.DotMultiple(leftpart::qqvct::interest, itemvct::interest) as error;
describe e_ui;
--estore = foreach e_ui generate qq, item, error;
--store estore into '/user/wonderyao/interest/training/$DATE/error';

qqgrp = group e_ui by (qq, qqInterest);
describe qqgrp;
define GradianDescend wonderyao.MatrixFactorizationGradianDescend('$LeaningRate', '$Lambda1', '$Lambda2');
p_u = foreach qqgrp generate group.qq, GradianDescend(group.qqInterest, e_ui, 3) as interest;
store p_u into '/user/wonderyao/interest/training/$DATE/qqvct/$NextRound';

itemgrp = group e_ui by (item, itemInterest);
q_i = foreach itemgrp generate group.item, GradianDescend(group.itemInterest, e_ui, 1) as interest;
store q_i into '/user/wonderyao/interest/training/$DATE/itemvct/$NextRound';

--calc error


