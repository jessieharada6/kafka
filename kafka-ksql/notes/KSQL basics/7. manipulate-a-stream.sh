# describe topics
describe userprofile;

# it has rowtime and rowkey as metadata

select rowtime, firstname from userprofile;

SELECT TIMESTAMPTOSTRING(rowtime, 'dd/MMM HH:mm') as createtime, firstname from userprofile;
# an example
|05/Sep. 15:52                                                      |Carol         

SELECT TIMESTAMPTOSTRING(rowtime, 'dd/MMM HH:mm') as createtime, firstname + ' ' + ucase(lastname) as full_name from userprofile;
# an example
05/Sep. 15:52                                                      |Carol EDISON   