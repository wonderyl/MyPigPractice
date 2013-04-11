
register 'wonderyaoUdf.jar'
--suppose all items in clique are sorted asc order
cliqueN = load '/user/wonderyao/cluster/maximalCliqueTmp/$Size'
--cliqueN = load '/user/wonderyao/cluster/maximalCliqueTmp/4'
--cliqueN = load '/user/wonderyao/test/clique/$Size'
    as clique:tuple();

groupKey = foreach cliqueN generate wonderyao.GetCliqueGroupKey(clique) as key, clique;
--store groupKey into '/user/wonderyao/test/groupKey';
grp = group groupKey by key;
--store grp into '/user/wonderyao/test/grp';
describe grp
--candidates:{cliqueNPlus1:tuple, key}
candidates = foreach grp generate flatten(wonderyao.GenerateCliqueCandidate(groupKey));-- parallel 80;
--store candidates into '/user/wonderyao/test/candidates';
--dump candidates;
describe candidates
cliqueKey = foreach cliqueN generate wonderyao.JoinStrings(clique, '\t') as key, clique;
--dump cliqueKey;
merge = cogroup candidates by key, cliqueKey by key;
--dump merge;
--store merge into '/user/wonderyao/test/merge1';
describe merge;
valid = filter merge by not IsEmpty(candidates) and not IsEmpty(cliqueKey);
candi = foreach valid generate flatten(candidates);
cliqueNPlus1 = foreach candi generate cliqueNPlus1;
--dump cliqueNPlus1;
--store cliqueNPlus1 into '/user/wonderyao/test/clique/$NextSize';
store cliqueNPlus1 into '/user/wonderyao/cluster/maximalCliqueTmp/$NextSize';
--store cliqueNPlus1 into '/user/wonderyao/cluster/maximalCliqueTmp/5';
