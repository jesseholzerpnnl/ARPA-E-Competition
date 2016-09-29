To run the GAMS model do

    'gams pscopf_run.gms --ingms=pscopf_data.gms --nlp=knitro'

The output in the required format will be written to 'out1.txt'.
Output in a different format will go to 'out0.txt'.
A different data file, such as 'pscopf_data_hacked_case14.gms',
can be substituted for 'pscopf_data.gms'.
And a different solver, such as 'ipopt', can be substituted for 'knitro'.

Alternately one can do

    'gams pscopf_run_knitro.gms'

or

    'gams pscopf_run_ipopt.gms'

With these commands the nlp solver is fixed to 'knitro' and 'ipopt',
respectively, and the data file is fixed to 'pscopf_data.gms'.

Generally, if the gams models reside in a directory 'model_dir',
and one wants to use a data file 'data_dir/data.gms',
then one should first copy the data file with

    'cp data_dir/data.gms model_dir/pscopf_data.gms'

and then run the model with

    'gams pscopf_run_knitro.gms'

or

    'gams pscopf_run_ipopt.gms'

This way no parameters need to be specified in the command.