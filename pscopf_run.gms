$title pscopf_run
$ontext
runs everything
$offtext

$if not set ingms $set ingms pscopf_data.gms
*$if not set ingms $set ingms pscopf_data_hacked_case14.gms
*$if not set ingms $set ingms pscopf_data_rts96.gms

$if not set nlp $set nlp knitro

$onecho > log.txt
PSCOPF START
ARPA-E Grid Optimization Competition
PSCOPF GAMS benchmark model
$offecho

* copy the original data file into this folder
$call 'cp "%ingms%" pscopf_data_temp.gms >> log.txt'

$call 'gams pscopf_prepare_data.gms --ingms=pscopf_data_temp.gms gdx=pscopf_data.gdx lo=2 lf=log.txt al=1'

$call 'gams pscopf.gms --ingdx=pscopf_data.gdx nlp=%nlp% lo=2 lf=log.txt al=1'

$onecho >> log.txt
PSCOPF END
$offecho