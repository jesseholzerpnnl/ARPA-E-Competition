$title pscopf_run
$ontext
runs everything
$offtext

$if not set ingms $set ingms pscopf_data.gms
*$if not set ingms $set ingms pscopf_data_hacked_case14.gms
*$if not set ingms $set ingms pscopf_data_rts96.gms

$if not set nlp $set nlp knitro
$if not set solutionname $set solutionname solution

* pv/pq method:
*
* 0 - penalize then round and fix and resolve with no penalty
* 1 - smooth complementarity formulation
* 2 - mpec model type with complementarity 
*
$if not set pvpq_method $set pvpq_method 0

* for testing:
$if not set do_infeas $set do_infeas 0
$if not set do_bad_output $set do_bad_output 0
$if not set do_compile_error $set do_compile_error 0
$if not set do_exec_error $set do_exec_error 0

$onecho > log.txt
PSCOPF START
ARPA-E Grid Optimization Competition
PSCOPF GAMS benchmark model
$offecho

* copy the original data file into this folder
$call 'cp "%ingms%" pscopf_data_temp.gms >> log.txt'

$call 'gams pscopf_prepare_data.gms --ingms=pscopf_data_temp.gms gdx=pscopf_data.gdx lo=2 lf=log.txt al=1'

$ifthen %pvpq_method% == 0
$call 'gams pscopf.gms --ingdx=pscopf_data.gdx nlp=%nlp% lo=2 lf=log.txt al=1 --solutionname=%solutionname% --do_infeas=%do_infeas% --do_bad_output=%do_bad_output% --do_compile_error=%do_compile_error% --do_exec_error=%do_exec_error%'
$endif

$ifthen %pvpq_method% == 1
$call 'gams pscopf_smooth.gms --ingdx=pscopf_data.gdx nlp=%nlp% lo=2 lf=log.txt al=1 --solutionname=%solutionname% --do_infeas=%do_infeas% --do_bad_output=%do_bad_output% --do_compile_error=%do_compile_error% --do_exec_error=%do_exec_error%'
$endif

$ifthen %pvpq_method% == 2
$call 'gams pscopf_comp.gms --ingdx=pscopf_data.gdx nlp=%nlp% lo=2 lf=log.txt al=1 --solutionname=%solutionname% --do_infeas=%do_infeas% --do_bad_output=%do_bad_output% --do_compile_error=%do_compile_error% --do_exec_error=%do_exec_error%'
$endif

*$call 'rm pscopf_data_temp.gms >> log.txt'

$onecho >> log.txt
solution overflow lines:
$offecho

*$call 'grep -F "**" %solutionname%*.txt | wc -l'

$onecho >> log.txt
PSCOPF END
$offecho
