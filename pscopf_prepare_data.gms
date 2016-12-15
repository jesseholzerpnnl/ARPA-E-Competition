$title pscopf_prepare_data
$ontext
adds some things to the data set
e.g. base case
need to check that 'baseCase' is not already an element of contingencies
$offtext

$if not set ingms $set ingms pscopf_data_temp.gms

$offdigit
$onempty
$include '%ingms%'
$offempty
set cases /baseCase,set.contingencies/;
set kBase(cases) /baseCase/;
