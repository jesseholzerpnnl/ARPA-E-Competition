$title pscopf_output_format0
$ontext
My preferred output format
$offtext

$if not set outputfilename0 $set outputfilename0 'out0.txt'
file outputfile0 /'%outputfilename0%'/;
*outputfile.nw = 0;
*outputfile.nr = 3;
*outputfile.nd = 6;
put outputfile0;
put '--model status' /;
put 'model_status({1,2} : OK, > 2 : not OK)' /;
put modelStatus:0:0 /;
put '--end of model status' /;
put '--solve status' /;
put 'solve_status(1 : OK, > 1: not OK)' /;
put solveStatus:0:0 /;
put '--end of solve status' /;
put '--cost' /;
put 'cost(dol)' /;
put cost.l:0:10 /;
put '--end of cost' /;
put '--time' /;
put 'time(s)' /;
put timeelapsed:0:10 /;
put '--end of time' /;
put '--generator dispatch' /;
put 'generator_id,real_power(MW),reactive_power(MVar)' /;
loop(kBase(k),
  loop(l,
    put l.tl:0 ',' lkRealPower.l(l,k):0:10 ',' lkReactivePower.l(l,k):0:10 /;
*    put ord(l):0:0 ',' lkRealPower.l(l,k):0:10 ',' lkReactivePower.l(l,k):0:10 /;
  );
);
put '--end of generator dispatch' /;
put '--bus voltage' /;
put 'bus_id,voltage_magnitude(kV),voltage_angle(rad)' /;
loop(kBase(k),
  loop(j,
    put k.tl:0 ',' j.tl:0 ',' jkVoltageMagnitude.l(j,k):0:10 ',' jkVoltageAngle.l(j,k):0:10 /;
  );
);
put '--end of bus voltage' /;
put '--contingency generator dispatch' /;
put 'contingency_id,generator_id,real_power(MW),reactive_power(MVar)' /;
loop(k,
  loop(l,
    put k.tl:0 ',' l.tl:0 ',' lkRealPower.l(l,k):0:10 ',' lkReactivePower.l(l,k):0:10 /;
  );
);
put '--end of contingency generator dispatch' /;
put '--contingency bus voltage' /;
put 'contingency_id,bus_id,voltage_magnitude(kV),voltage_angle(rad)' /;
loop(k,
  loop(j,
    put k.tl:0 ',' j.tl:0 ',' jkVoltageMagnitude.l(j,k):0:10 ',' jkVoltageAngle.l(j,k):0:10 /;
  );
);
put '--end of contingency bus voltage' /;
put '--contingency real power shortfall' /;
put 'contingency_id,real_power_shortfall(MW)' /;
loop(k,
  put k.tl:0 ',' kRealPowerShortfall.l(k):0:10 /;
);
put '--end of contingency real power shortfall' /;
putclose outputfile0;
