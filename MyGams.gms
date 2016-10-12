$title pscopf_run
$ontext
runs everything

usage:

  gams MyGams.gms --case="case_file_name.gms"

e.g.

  gams MyGams.gms --case=pscopf_data.gms

or

  gams MyGams.gms --case=pscopf_data_hacked_case14.gms

$offtext

$if not set case $abort 'usage: gams MyGams.gms --case="case_file_name.gms"'
$if not exist '%case%' $abort 'specified data file "%case%" does not exist'
$if not exist pscopf_run.gms $abort 'missing file "pscopf_run.gms"'
$if not exist pscopf_prepare_data.gms $abort 'missing file "pscopf_prepare_data.gms"'
$if not exist pscopf.gms $abort 'missing file "pscopf.gms"'
*$if not exist pscopf_output_format0.gms $abort 'missing file "pscopf_output_format0.gms"'
*$if not exist pscopf_output_format1.gms $abort 'missing file "pscopf_output_format1.gms"'
$if not exist pscopf_write_solution.gms $abort 'missing file "pscopf_write_solution.gms"'

$call 'gams pscopf_run.gms --ingms=%case% --nlp=knitro'
