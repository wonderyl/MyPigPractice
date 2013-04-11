
register 'wonderyaoUdf.jar'

log = load '/kvlogs/novel/2013/01/novel_acs_20130129*.log' using wonderyao.KVLogLoader('qq:int, id:chararray, cno:int, act:chararray, statIgnore:int')
        as (qq:int, id:chararray, cno:int, act:chararray, statIgnore:int);
valid = filter log by qq>0 and act=='detail' and statIgnore==0 and id matches '[0-9]+';
useful = foreach valid generate qq, id, cno;
chapterOnce = distinct useful;
grp = group chapterOnce by (qq, id);
qqidcnt = foreach grp generate flatten(group), COUNT(chapterOnce) as count;
store qqidcnt into '/user/wonderyao/interest/qqIDCount/20130129';


