To run the GAMS model do

  gams MyGams.gms --case=case_file_name.gms

e.g.

  gams MyGams.gms --case=pscopf_data_toy.gms

or

  gams MyGams.gms --case=pscopf_data_hacked_case14.gms

or

  gams MyGams.gms --case=pscopf_data_rts96.gms

The solution output in the required format will be written to
'solution0.txt', 'solution1.txt', and 'solution2.txt'.
'solution0.txt' gives complete solution output and is
most useful for debugging.
'solution1.txt' has only performance info and base case
generator output.
'solution2.txt' has contingency solution values.
To mimic a competitor algorithm with the two-timer arrangement,
one could do

  start timer1
  gams MyGams.gms --case=case_file_name.gms
  stop timer1
  copy solution1.txt to another location
  start timer2
  gams MyGams.gms --case=case_file_name.gms
  copy solution2.txt to another location
  stop timer2

The 'case' parameter is required.
It gives the file name of a data set written in
valid GAMS code.
A log containing the GAMS console output is written to log.txt.
The log shows the solver progress.
The GAMS listing file is not preserved.

To simulate some potential user errors, one can do

  gams MyGams.gms --case=case_file_name.gms --do_infeas=1

or

  gams MyGams.gms --case=case_file_name.gms --do_bad_output=1

or

  gams MyGams.gms --case=case_file_name.gms --do_compile_error=1

or

  gams MyGams.gms --case=case_file_name.gms --do_exec_error=1

