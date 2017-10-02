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
$if not set pvpq_method $set pvpq_method 0
$if not set nlp $set nlp knitro

* for testing:
$if not set do_infeas $set do_infeas 0
$if not set do_bad_output $set do_bad_output 0
$if not set do_compile_error $set do_compile_error 0
$if not set do_exec_error $set do_exec_error 0

* check existence of required files
$if not exist '%case%' $abort 'specified data file "%case%" does not exist'
$if not exist pscopf_run.gms $abort 'missing file "pscopf_run.gms"'
$if not exist pscopf_prepare_data.gms $abort 'missing file "pscopf_prepare_data.gms"'
$if not exist pscopf.gms $abort 'missing file "pscopf.gms"'
*$if not exist pscopf_output_format0.gms $abort 'missing file "pscopf_output_format0.gms"'
*$if not exist pscopf_output_format1.gms $abort 'missing file "pscopf_output_format1.gms"'
$if not exist pscopf_write_solution.gms $abort 'missing file "pscopf_write_solution.gms"'

$call 'gams pscopf_run.gms --ingms=%case% --nlp=%nlp% --do_infeas=%do_infeas% --do_bad_output=%do_bad_output% --do_compile_error=%do_compile_error% --do_exec_error=%do_exec_error% --pvpq_method=%pvpq_method%'
