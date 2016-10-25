$title pscopf_write_solution
$ontext
Official competition output format
adding some extra sections for debugging etc.
solveStatus,modelstatus
solvestatus
1 - normal completion
2 - iteration limit
3 - time limit
modelStatus
2 - locally optimal
3 - unbounded
5 - locally infeasible
$offtext

$if not set do_bad_output $set do_bad_output 0

$if not set outputfilename1 $set outputfilename1 'solution.txt'
file outputfile1 /'%outputfilename1%'/;
*outputfile.nw = 0;
*outputfile.nr = 3;
*outputfile.nd = 6;
put outputfile1;
put '--performance' /;
put 'time(s),objective value(dol)' /;
put timeelapsed:0:10 ',' cost.l:0:10 /;
put '--end of performance' /;
$ifthen %do_bad_output%==1
put '--generation dispatch' /;
put 'bus id,unit id,pg(MW),qg(MVar)' /;
put 'bus_id_err, unit_id_err, 0, 0' /;
put 'bus_id_err, unit_id_err, 0' /;
put 'bus_id_err, unit_id_err, 0, 0, 0' /;
put '--end of generation dispatch' /;
$endif
put '--generation dispatch' /;
put 'bus id,unit id,pg(MW),qg(MVar)' /;
loop(kBase(k),
  loop((l,j,u)$(ljMap(l,j) and luMap(l,u)),
    put j.tl:0 ',' u.tl:0 ',' lkRealPower.l(l,k):0:10 ',' lkReactivePower.l(l,k):0:10 /;
  );
);
put '--end of generation dispatch' /;
put '--pqvo' /;
put 'contingency id,bus id,p(MW),q(MVar),v(p.u.),theta(deg)' /;
loop(kBase(k),
  loop(j,
    put '0,' j.tl:0 ',' (sum(l$(ljMap(l,j) and lkActive(l,k)),lkRealPower.l(l,k)) - jRealPowerDemand(j)):0:10 ',' (sum(l$(ljMap(l,j) and lkActive(l,k)),lkReactivePower.l(l,k)) - jReactivePowerDemand(j)):0:10 ',' jkVoltageMagnitude.l(j,k):0:10 ',' jkVoltageAngle.l(j,k):0:10 /;
  );
);
loop(k$(not kBase(k)),
  loop(j,
    put k.tl:0 ',' j.tl:0 ',' (sum(l$(ljMap(l,j) and lkActive(l,k)),lkRealPower.l(l,k)) - jRealPowerDemand(j)):0:10 ',' (sum(l$(ljMap(l,j) and lkActive(l,k)),lkReactivePower.l(l,k)) - jReactivePowerDemand(j)):0:10 ',' jkVoltageMagnitude.l(j,k):0:10 ',' jkVoltageAngle.l(j,k):0:10 /;
  );
);
put '--end of pqvo' /;
put '--Delta' /;
put 'contingency id,Delta(MW)' /;
loop(k$(not kBase(k)),
  put k.tl:0 ',' kRealPowerShortfall.l(k):0:10 /;
);
put '--end of Delta' /;
put '--line flow' /;
put 'contingency id,line id,origin bus id,destination bus id,circuit id,p_origin(MW),q_origin(MVar),p_destination(MW),q_destination(MVar)' /;
loop(kBase(k),
  loop((i,j1,j2,c)$(ijjOriginDestination(i,j1,j2) and icMap(i,c) and ikActive(i,k)),
    put '0,' i.tl:0 ',' j1.tl:0 ',' j2.tl:0 ',' c.tl:0 ',' ikRealPowerOrigin.l(i,k):0:10 ',' ikReactivePowerOrigin.l(i,k):0:10 ',' ikRealPowerDestination.l(i,k):0:10 ',' ikReactivePowerDestination.l(i,k):0:10 /;
  );
);
loop(k$(not kBase(k)),
  loop((i,j1,j2,c)$(ijjOriginDestination(i,j1,j2) and icMap(i,c) and ikActive(i,k)),
    put k.tl:0 ',' i.tl:0 ',' j1.tl:0 ',' j2.tl:0 ',' c.tl:0 ',' ikRealPowerOrigin.l(i,k):0:10 ',' ikReactivePowerOrigin.l(i,k):0:10 ',' ikRealPowerDestination.l(i,k):0:10 ',' ikReactivePowerDestination.l(i,k):0:10 /;
  );
);
put '--end of line flow' /;
put '--status' /;
put 'solveStatus,modelStatus' /;
put solveStatus:0:0 ',' modelStatus:0:0 /;
put '--end of status' /;
putclose outputfile1;
