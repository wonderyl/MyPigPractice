
--%default DATE 20130129
--%default Previous 20130129
--%default PreRound 100
%default InterestSize 10
%default RandomTupleUpperRange 2.0
--%default VectorInitValue 1.0


register 'wonderyaoUdf.jar'

qqItemCount = load '/user/wonderyao/interest/training/$DATE/rating' 
    as (qq:chararray, item:chararray, count: double);

qqs = foreach qqItemCount generate qq;
uniqqq = distinct qqs;
--qqvct = foreach uniqqq generate qq, wonderyao.MakeTuple($InterestSize) parallel 32;
--qqvct = foreach uniqqq generate qq, wonderyao.MakeTuple($InterestSize, $VectorInitValue) parallel 32;
randqq = foreach uniqqq generate qq, wonderyao.RandomTuple($InterestSize, $RandomTupleUpperRange) as interest parallel 32;
preqq = load '/user/wonderyao/interest/training/$Previous/qqvct/$PreRound' as (qq:chararray, interest:tuple());
bothqq = join randqq by qq left, preqq by qq;
qqvct = foreach bothqq generate randqq::qq, wonderyao.AorB(preqq::interest, randqq::interest);

store qqvct into '/user/wonderyao/interest/training/$DATE/qqvct/0';

items = foreach qqItemCount generate item;
uniqitem = distinct items;
--itemvct = foreach uniqitem generate item, wonderyao.MakeTuple($InterestSize, $VectorInitValue) parallel 32;
randitem = foreach uniqitem generate item, wonderyao.RandomTuple($InterestSize, $RandomTupleUpperRange) as interest parallel 32;
preitem = load '/user/wonderyao/interest/training/$Previous/itemvct/$PreRound' as (item:chararray, interest:tuple());
bothitem = join randitem by item left, preitem by item;
itemvct = foreach bothitem generate randitem::item, wonderyao.AorB(preitem::interest, randitem::interest);
store itemvct into '/user/wonderyao/interest/training/$DATE/itemvct/0';


