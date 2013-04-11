
%default Round 0
%default DATE 20130129
%default KnockOutNum 10

register 'wonderyaoUdf.jar'

qqvctsrc = load '/user/wonderyao/interest/training/$DATE/qqvct/$Round' as (qq:chararray, interest:tuple());
qqvct = foreach qqvctsrc generate qq, wonderyao.TupleString2Double(interest) as interest;
qqvctko = foreach qqvct generate qq, wonderyao.KnockOut(interest, $KnockOutNum);
store qqvctko into '/user/wonderyao/interest/training/$DATE/qqvct/$Round-ko';
itemvctsrc = load '/user/wonderyao/interest/training/$DATE/itemvct/$Round' as (item:chararray, interest:tuple());
itemvct = foreach itemvctsrc generate item, wonderyao.TupleString2Double(interest) as interest;
itemvctko = foreach itemvct generate item, wonderyao.KnockOut(interest, $KnockOutNum);
store itemvctko into '/user/wonderyao/interest/training/$DATE/itemvct/$Round-ko';

