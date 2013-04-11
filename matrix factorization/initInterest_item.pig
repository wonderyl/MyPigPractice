
%default InterestSize 10
%default DATE 20130129

register 'wonderyaoUdf.jar'

rating = load '/user/wonderyao/interest/training/$DATE/rating' as (qq:chararray, item:chararray, weight:double);

qqvctsrc = load '/user/wonderyao/interest/training/$DATE/qqvct/0' as (qq:chararray, interest:tuple());
qqvct = foreach qqvctsrc generate qq, wonderyao.TupleString2Double(interest) as interest;

combine = join rating by qq, qqvct by qq;
describe combine;
itemgrp = group combine by item;
items = foreach itemgrp generate flatten(group) as item, wonderyao.InitItem($InterestSize, combine) as interest;
store items into '/user/wonderyao/interest/training/$DATE/itemvct/0';

