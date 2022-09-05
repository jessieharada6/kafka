# table
select countrycode, countryname from countrytable emit changes;
+-------------------------------------------------------------------+-------------------------------------------------------------------+
|COUNTRYCODE                                                        |COUNTRYNAME                                                        |
+-------------------------------------------------------------------+-------------------------------------------------------------------+
|AU                                                                 |Australia                                                          |
|IN                                                                 |India                                                              |
|GB                                                                 |United Kindom                                                      |
|FR                                                                 |France                                                             |

# stream
select firstname, lastname, countrycode, rating from userprofile;
# some examples
+--------------------------------+--------------------------------+--------------------------------+--------------------------------+
|FIRSTNAME                       |LASTNAME                        |COUNTRYCODE                     |RATING                          |
+--------------------------------+--------------------------------+--------------------------------+--------------------------------+
|Alison                          |Smith                           |GB                              |4.7                             |
|Ivan                            |Jones                           |GB                              |4.4                             |
|Eve                             |Edison                          |GB                              |2.2                             |
|Bob                             |Smith                           |US                              |2.2                             |
|Heidi                           |Smith                           |US                              |2.2                             |


# If you have JOIN that has same column name across table OR streams OR both 
# then (For e.g. countrycode in stream and table) it gets confused and throws null value.
# solution: up.countrycode as countrycode
select up.firstname, up.lastname, up.countrycode as countrycode, ct.countryname, up.rating
from USERPROFILE up 
left join COUNTRYTABLE ct on ct.countrycode=up.countrycode emit changes;
# throw null value
select up.firstname, up.lastname, up.countrycode, ct.countryname 
from USERPROFILE up
left join COUNTRYTABLE ct on up.countrycode=ct.countrycode emit changes;

# stream joining table to create a new stream (up_joined)
create stream up_joined as 
select up.firstname 
+ ' ' + ucase(up.lastname) 
+ ' from ' + ct.countryname
+ ' has a rating of ' + cast(rating as varchar) + ' stars.' as description 
, up.countrycode
from USERPROFILE up 
left join COUNTRYTABLE ct on ct.countrycode=up.countrycode;

select description from up_joined emit changes;

select * from up_joined emit changes;