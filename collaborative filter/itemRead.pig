register 'wonderyaoUdf.jar'
userItemCount = load '/user/wonderyao/cf/novel/qqItemCountHistory/20120418'
    as (uuid:chararray, id:chararray, count:double);
--cross
items = group userItemCount by id;
itemRead = foreach items generate group as id, COUNT(userItemCount);
store itemRead into '/user/wonderyao/test/itemRead2'; 
