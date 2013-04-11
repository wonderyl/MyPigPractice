
register 'wonderyaoUdf.jar'

cliqueN = load '/user/wonderyao/cluster/maximalCliqueTmp/$Size'
        as (clique:tuple());
keyN = foreach cliqueN generate wonderyao.JoinStrings(clique, '\t') as key, clique;
cliqueN1 = load '/user/wonderyao/cluster/maximalCliqueTmp/$NextSize' 
        as (clique:tuple());
keyN1 = foreach cliqueN1 generate flatten(wonderyao.PermutateSubClique(clique, '\t')) as key;
merge = cogroup keyN by key, keyN1 by key;
valid = filter merge by not IsEmpty(keyN) and IsEmpty(keyN1);
result = foreach valid generate flatten(keyN.clique);
store result into '/user/wonderyao/cluster/maximalClique/$Size';



