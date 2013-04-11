
register 'wonderyaoUdf.jar'
logs = load '/kvlogs/novel/$YEAR/$MONTH/*$YEAR$MONTH$DAY*.log'
	using wonderyao.KVLogLoader('_channel:chararray, t:long, qq:long, uuid:chararray, act:chararray, plat:chararray, g_f:chararray, pt:chararray, icfa:chararray, key:chararray, pos:int, id:chararray, md:chararray, cno:int, size:int, maxPageNo:int, pageNo:int, first_g_f:chararray, uuidRegDay:chararray, ip_city:chararray, ip_carrier:chararray, network:chararray, costMS:int, reqUrl:chararray')
	as (channel:chararray, t:long, qq:long, uuid:chararray, act:chararray, plat:chararray, g_f:chararray, pt:chararray, icfa:chararray, key:chararray, pos:int, id:chararray, md:chararray, cno:int, size:int, maxPageNo:int, pageNo:int, first_g_f:chararray, uuidRegDay:chararray, ip_city:chararray, ip_carrier:chararray, network:chararray, costMS:int, reqUrl:chararray);

someone = filter logs by qq==2418524452L or uuid=='MTQ1LTM5NDMzMjAtYw..' or uuid=='MzctMjc2NzMxMDkzLWE.';
sort= order someone by t;
store sort into '/user/wonderyao/test/behavior/b_$YEAR$MONTH$DAY';  
