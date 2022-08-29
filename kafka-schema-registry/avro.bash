# Primitive types
null: no value
boolean: a binary value
int: 32 bit signed int
long: 64 bit signed int
float: single precision (32 bit)
double: double precision (64 bit)
bytes: sequence of 8 bit unsigned bytes
string: unicode character sequence

#Avro Record Schemas are defined using JSON

# complex types
enums: wont change at all
arrays: type as arays, item as individual item type
maps: key value pairs
unions: allow a field value to take different types, optional value (with value or null) eg. middle name
calling other schemas as types

# logical types: interpretation of primitive types
decimal: underlying type is bytes
date: int (num of days since unix epoch Jan 1 1970) - int 
time-millis: long (num of milliseconds after midnight, 00:00:00.000) - long
timestamp-millis: long (num of milliseconds from unix epoch, 1 Jan 1970 00:00:00.000 UTC)

# complex case of Decimals
Floats and Doubles are floating binary point types, represented like 10001.10010110011
Decimal is a floating decimal point type, represented like 12345.6789.

Some decimals cannot be represented accurately as floats or Doubles

use floats and doubles for scientific computations (imprecise computations) because these types are fast
use decimal for money

for decimal, it is not nice to print as it is bytes, use string instead which can print out the value

# avro vs json
avro carries schema, json doesnt''t
avro can contain multiple level of nested fields like json
for common fields: name, namespace, fields are mandatory, doc is optional
for a field: doc is optional
can have more than one Record as nested type, see customer and customer address
