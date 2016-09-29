$title pscopf_run_ipopt
$ontext
runs everything
nlp solver is set to ipopt
$offtext

$if not set ingms $set ingms pscopf_data.gms
*$if not set ingms $set ingms pscopf_data_hacked_case14.gms

$if not set nlp $set nlp ipopt

* copy the original data file into this folder
$call 'cp "%ingms%" pscopf_data_temp.gms'

$call 'gams pscopf_prepare_data.gms --ingms=pscopf_data_temp.gms gdx=pscopf_data.gdx'

$call 'gams pscopf.gms --ingdx=pscopf_data.gdx nlp=%nlp%'