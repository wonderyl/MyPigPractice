
register 'wonderyaoUdf.jar'
itemitemWeight = load '/user/wonderyao/cluster/itemitemWeight/20k/' 
    as (item1:chararray, item2:chararray, weight:double);
--describe itemitemWeight
--%default Threshold 3.40652156905e-05;
%default Threshold 3.40652156905e-03;
valid = filter itemitemWeight by weight>=$Threshold;
itemitem = foreach valid generate wonderyao.ToTuple2(item1, item2) as tpl;
orderedItemItem = filter itemitem by tpl is not null;
--describe itemitem;
store orderedItemItem into '/user/wonderyao/cluster/maximalCliqueTmp/2_1';


