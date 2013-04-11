{
#/data/wonderyao/pig/bin/pig -f cf_daily_nosession.pig -p CHN=novel -p YEAR=2012 -p MONTH=07 -p DAY=14 -p YESTERDAY=20120713 -p SESSION_EXPIRE_MS=1800000 -p DISCOUNT=0.9 
#/data/wonderyao/pig/bin/pig -f cf_daily_normalize.pig -p CHN=novel -p YEAR=2012 -p MONTH=07 -p DAY=14 -p YESTERDAY=20120713 -p SESSION_EXPIRE_MS=1800000 -p DISCOUNT=0.9 
/data/wonderyao/pig/bin/pig -f cf_daily_nosession.pig -p CHN=novel -p YEAR=2012 -p MONTH=07 -p DAY=15 -p YESTERDAY=20120714 -p SESSION_EXPIRE_MS=1800000 -p DISCOUNT=0.9 
/data/wonderyao/pig/bin/pig -f cf_daily_normalize.pig -p CHN=novel -p YEAR=2012 -p MONTH=07 -p DAY=15 -p YESTERDAY=20120714 -p SESSION_EXPIRE_MS=1800000 -p DISCOUNT=0.9 
}&

#/data/wonderyao/pig/bin/pig -f qqbase_daily.pig -p CHN=novel -p YEAR=2012 -p MONTH=07 -p DAY=14 -p YESTERDAY=20120713 -p DISCOUNT=0.9 
/data/wonderyao/pig/bin/pig -f qqbase_daily.pig -p CHN=novel -p YEAR=2012 -p MONTH=07 -p DAY=15 -p YESTERDAY=20120714 -p DISCOUNT=0.9
