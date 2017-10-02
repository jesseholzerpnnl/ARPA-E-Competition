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

* output type
* 0 = everything
* 1 = just base case real power generation
* 2 = everything else
$if not set outputtype $set outputtype 0

* solution name
* e.g. "solution"
$if not set solutionname $set solutionname solution

$set soltxt %solutionname%%outputtype%.txt

$include pscopf_process_solution.gms

file outputfile%outputtype% /'%soltxt%'/;
*outputfile.nw = 0;
*outputfile.nr = 3;
*outputfile.nd = 6;

put outputfile%outputtype%;

$ifthen %do_bad_output%==1
put '--generation dispatch' /;
put 'bus id,unit id,pg(MW),qg(MVar)' /;
put 'bus_id_err, unit_id_err, 0, 0' /;
put 'bus_id_err, unit_id_err, 0' /;
put 'bus_id_err, unit_id_err, 0, 0, 0' /;
put '--end of generation dispatch' /;
$endif

$ifthen %outputtype%==1
put '--generation dispatch' /;
put 'bus id,unit id,pg(MW),qg(MVar)' /;
loop(kBase(k),
  loop((l,j,u)$(ljMap(l,j) and luMap(l,u)),
    put j.tl:0 ',' u.tl:0 ',' lkRealPower.l(l,k):0:10 ',' lkReactivePower.l(l,k):0:10 /;
  );
);
put '--end of generation dispatch' /;
$endif

$ifthen %outputtype%==2
put '--contingency generator' /;
put
  'conID,'
  'genID,'
  'busID,'
  'unitID,'
  'q(MW)' /;
loop(k$(not kBase(k)),
  loop((l,j,u)$(lkActive(l,k) and ljMap(l,j) and luMap(l,u)),
    put
      k.tl:0 ','
      l.tl:0 ','
      j.tl:0 ','
      u.tl:0 ','
      lkReactivePower.l(l,k):0:10 /;
  );
);
put '--end of contingency generator' /;
$endif

$ifthen %outputtype%==2
put '--bus' /;
put 'contingency id,bus id,v(pu),theta(deg)' /;
loop(kBase(k),
  loop(j,
    put '0,'
    j.tl:0 ','
    jkVoltageMagnitude.l(j,k):0:10 ','
    jkVoltageAngle.l(j,k):0:10 /;
  );
);
loop(k$(not kBase(k)),
  loop(j,
    put k.tl:0 ','
    j.tl:0 ','
    jkVoltageMagnitude.l(j,k):0:10 ','
    jkVoltageAngle.l(j,k):0:10 /;
  );
);
put '--end of bus' /;
$endif

$ifthen %outputtype%==2
put '--Delta' /;
put 'contingency id,Delta(MW)' /;
loop(k$(not kBase(k)),
  put k.tl:0 ',' kRealPowerShortfall.l(k):0:10 /;
);
put '--end of Delta' /;
$endif

$ifthen %outputtype%==2
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
$endif

$ifthen %outputtype%==0
put '--summary' /;
put
  'time(s),'
  'cost(dol),'
  'constrViolMax,'
  'solveStat,'
  'modelStat' /;
put
  timeelapsed:0:10 ','
  cost.l:0:10 ','
  constrViolMax:0:10 ','
  solveStatus:0:0 ','
  modelStatus:0:0 /;
put '--end of summary' /;
put '--base generator' /;
put
  'genID,'
  'busID,'
  'unitID,'
  'p(MW),'
  'q(MW),'
  'pViolLo(MW),'
  'pViolUp(MW),'
  'qViolLo(MW),'
  'qViolUp(MW)' /;
loop(kBase(k),
  loop((l,j,u)$(lkActive(l,k) and ljMap(l,j) and luMap(l,u)),
    put
      l.tl:0 ','
      j.tl:0 ','
      u.tl:0 ','
      lkRealPower.l(l,k):0:10 ','
      lkReactivePower.l(l,k):0:10 ','
      max(0,lRealPowerMin(l)-lkRealPower.l(l,k)):0:10 ','
      max(0,lkRealPower.l(l,k)-lRealPowerMax(l)):0:10 ','
      max(0,lReactivePowerMin(l)-lkReactivePower.l(l,k)):0:10 ','
      max(0,lkReactivePower.l(l,k)-lReactivePowerMax(l)):0:10 /;
  );
);
put '--end of base generator' /;
put '--base bus' /;
put
  'busID,'
  'vMag(pu),'
  'vAng(deg),'
  'pShunt(MW),'
  'qShunt(MW),'
  'pShuntDefViol(MW),'
  'qShuntDefViol(MW),'
  'pBalViol(MW),'
  'qBalViol(MW),'
  'vMagViolLo(pu),'
  'vMagViolUp(pu)' /;
loop(kBase(k),
  loop(j,
    put
      j.tl:0 ','
      jkVoltageMagnitude.l(j,k):0:10 ','
      jkVoltageAngle.l(j,k):0:10 ','
      jkShuntRealPower.l(j,k):0:10 ','
      jkShuntReactivePower.l(j,k):0:10 ','
      (baseMVA * (jkShuntRealPowerDef.l(j,k) - jkShuntRealPowerDef.lo(j,k))):0:10 ','
      (baseMVA * (jkShuntReactivePowerDef.l(j,k) - jkShuntReactivePowerDef.lo(j,k))):0:10 ','
      (baseMVA * (jkRealPowerBalance.l(j,k) - jkRealPowerBalance.lo(j,k))):0:10 ','
      (baseMVA * (jkReactivePowerBalance.l(j,k) - jkReactivePowerBalance.lo(j,k))):0:10 ','
      max(0,jVoltageMagnitudeMin(j)-jkVoltageMagnitude.l(j,k)):0:10 ','
      max(0,jkVoltageMagnitude.l(j,k)-jVoltageMagnitudeMax(j)):0:10 /;
  );
);
put '--end of base bus' /;
put '--base branch' /;
put
  'brID,'
  'origBusID,'
  'destBusID,'
  'circID,'
  'pOrig(MW),'
  'qOrig(MW),'
  'pDest(MW),'
  'qDest(MW),'
  'sOrigViol(MW),'
  'sDestViol(MW),'
  'nzPOrigDefViol(MW),'
  'nzQOrigDefViol(MW),'
  'nzPDestDefViol(MW),'
  'nzQDestDefViol(MW),'
  'zVMagViol(pu),'
  'zVAngViol(deg),'
  'zPViol(MW),'
  'zQViol(MW)' /;
loop(k$kBase(k),
  loop((i,j1,j2,c)$(ikActive(i,k) and ijOrigin(i,j1) and ijDestination(i,j2) and icMap(i,c)),
    put
      i.tl:0 ','
      j1.tl:0 ','
      j2.tl:0 ','
      c.tl:0 ','
      ikRealPowerOrigin.l(i,k):0:10 ','
      ikReactivePowerOrigin.l(i,k):0:10 ','
      ikRealPowerDestination.l(i,k):0:10 ','
      ikReactivePowerDestination.l(i,k):0:10 ','
      max(0,sqrt(sqr(ikRealPowerOrigin.l(i,k)) + sqr(ikReactivePowerOrigin.l(i,k)))-iPowerMagnitudeMax(i)):0:10 ','
      max(0,sqrt(sqr(ikRealPowerDestination.l(i,k)) + sqr(ikReactivePowerDestination.l(i,k)))-iPowerMagnitudeMax(i)):0:10 ','
      (baseMVA * (ijjkRealPowerOriginDef.l(i,j1,j2,k) - ijjkRealPowerOriginDef.lo(i,j1,j2,k))):0:10 ','
      (baseMVA * (ijjkReactivePowerOriginDef.l(i,j1,j2,k) - ijjkReactivePowerOriginDef.lo(i,j1,j2,k))):0:10 ','
      (baseMVA * (ijjkRealPowerDestinationDef.l(i,j1,j2,k) - ijjkRealPowerDestinationDef.lo(i,j1,j2,k))):0:10 ','
      (baseMVA * (ijjkReactivePowerDestinationDef.l(i,j1,j2,k) - ijjkReactivePowerDestinationDef.lo(i,j1,j2,k))):0:10 ','
      (ijjkVoltageMagnitudeSeriesImpedanceZeroEq.l(i,j1,j2,k) - ijjkVoltageMagnitudeSeriesImpedanceZeroEq.lo(i,j1,j2,k)):0:10 ','
      ((180/pi) * (ijjkVoltageAngleSeriesImpedanceZeroEq.l(i,j1,j2,k) - ijjkVoltageAngleSeriesImpedanceZeroEq.lo(i,j1,j2,k))):0:10 ','
      (baseMVA * (ikRealPowerSeriesImpedanceZeroEq.l(i,k) - ikRealPowerSeriesImpedanceZeroEq.lo(i,k))):0:10 ','
      (baseMVA * (ijjkReactivePowerSeriesImpedanceZeroEq.l(i,j1,j2,k) - ijjkReactivePowerSeriesImpedanceZeroEq.lo(i,j1,j2,k))):0:10 /;
  );
);
put '--end of base branch' /;
put '--contingency delta' /;
put
  'conID,'
  'pRedispatch(MW)' /;
loop(k$(not kBase(k)),
  put
    k.tl:0 ','
    kRealPowerShortfall.l(k):0:10 /;
);
put '--end of contingency delta' /;
put '--contingency generator' /;
put
  'conID,'
  'genID,'
  'busID,'
  'unitID,'
  'p(MW),'
  'q(MW),'
  'pDefViol(MW),'
  'pViolLo(MW),'
  'pViolUp(MW),'
  'qViolLo(MW),'
  'qViolUp(MW),'
  'qSlackLo(MW),'
  'qSlackUp(MW)' /;
loop(k$(not kBase(k)),
  loop((l,j,u)$(lkActive(l,k) and ljMap(l,j) and luMap(l,u)),
    put
      k.tl:0 ','
      l.tl:0 ','
      j.tl:0 ','
      u.tl:0 ','
      lkRealPower.l(l,k):0:10 ','
      lkReactivePower.l(l,k):0:10 ','
      (baseMVA * (lkRealPowerRecoveryDef.l(l,k) - lkRealPowerRecoveryDef.lo(l,k))):0:10 ','
      max(0,lRealPowerMin(l)-lkRealPower.l(l,k)):0:10 ','
      max(0,lkRealPower.l(l,k)-lRealPowerMax(l)):0:10 ','
      max(0,lReactivePowerMin(l)-lkReactivePower.l(l,k)):0:10 ','
      max(0,lkReactivePower.l(l,k)-lReactivePowerMax(l)):0:10 ','
      lkReactivePowerSlackLo(l,k):0:10 ','
      lkReactivePowerSlackUp(l,k):0:10 /;
  );
);
put '--end of contingency generator' /;
put '--contingency bus' /;
put
  'conID,'
  'busID,'
  'vMag(pu),'
  'vAng(deg),'
  'pShunt(MW),'
  'qShunt(MW),'
  'pShuntDefViol(MW),'
  'qShuntDefViol(MW),'
  'pBalViol(MW),'
  'qBalViol(MW),'
  'vMagViolLo(pu),'
  'vMagViolUp(pu),'
  'vMagDevLo(pu),'
  'vMagDevUp(pu),'
  'vMagDevLoQSlackUpCompViol(pu*MW),'
  'vMagDevUpQSlackLoCompViol(pu*MW),' /;
loop(k$(not kBase(k)),
  loop(j,
    put
      k.tl:0 ','
      j.tl:0 ','
      jkVoltageMagnitude.l(j,k):0:10 ','
      jkVoltageAngle.l(j,k):0:10 ','
      jkShuntRealPower.l(j,k):0:10 ','
      jkShuntReactivePower.l(j,k):0:10 ','
      (baseMVA * (jkShuntRealPowerDef.l(j,k) - jkShuntRealPowerDef.lo(j,k))):0:10 ','
      (baseMVA * (jkShuntReactivePowerDef.l(j,k) - jkShuntReactivePowerDef.lo(j,k))):0:10 ','
      (baseMVA * (jkRealPowerBalance.l(j,k) - jkRealPowerBalance.lo(j,k))):0:10 ','
      (baseMVA * (jkReactivePowerBalance.l(j,k) - jkReactivePowerBalance.lo(j,k))):0:10 ','
      max(0,jVoltageMagnitudeMin(j)-jkVoltageMagnitude.l(j,k)):0:10 ','
      max(0,jkVoltageMagnitude.l(j,k)-jVoltageMagnitudeMax(j)):0:10 ','
      jkVoltMagDevLo(j,k):0:10 ','
      jkVoltMagDevUp(j,k):0:10 ','
      jkVoltMagDevLoReactivePowerGenSlackUpCompViol(j,k):0:10 ','
      jkVoltMagDevUpReactivePowerGenSlackLoCompViol(j,k):0:10 /;
  );
);
put '--end of contingency bus' /;
put '--contingency branch' /;
put
  'conID,'
  'brID,'
  'origBusID,'
  'destBusID,'
  'circID,'
  'pOrig(MW),'
  'qOrig(MW),'
  'pDest(MW),'
  'qDest(MW),'
  'sOrigViol(MW),'
  'sDestViol(MW),'
  'nzPOrigDefViol(MW),'
  'nzQOrigDefViol(MW),'
  'nzPDestDefViol(MW),'
  'nzQDestDefViol(MW),'
  'zVMagViol(pu),'
  'zVAngViol(deg),'
  'zPViol(MW),'
  'zQViol(MW)' /;
loop(k$(not kBase(k)),
  loop((i,j1,j2,c)$(ikActive(i,k) and ijOrigin(i,j1) and ijDestination(i,j2) and icMap(i,c)),
    put
      k.tl:0 ','
      i.tl:0 ','
      j1.tl:0 ','
      j2.tl:0 ','
      c.tl:0 ','
      ikRealPowerOrigin.l(i,k):0:10 ','
      ikReactivePowerOrigin.l(i,k):0:10 ','
      ikRealPowerDestination.l(i,k):0:10 ','
      ikReactivePowerDestination.l(i,k):0:10 ','
      max(0,sqrt(sqr(ikRealPowerOrigin.l(i,k)) + sqr(ikReactivePowerOrigin.l(i,k)))-iPowerMagnitudeMax(i)):0:10 ','
      max(0,sqrt(sqr(ikRealPowerDestination.l(i,k)) + sqr(ikReactivePowerDestination.l(i,k)))-iPowerMagnitudeMax(i)):0:10 ','
      (baseMVA * (ijjkRealPowerOriginDef.l(i,j1,j2,k) - ijjkRealPowerOriginDef.lo(i,j1,j2,k))):0:10 ','
      (baseMVA * (ijjkReactivePowerOriginDef.l(i,j1,j2,k) - ijjkReactivePowerOriginDef.lo(i,j1,j2,k))):0:10 ','
      (baseMVA * (ijjkRealPowerDestinationDef.l(i,j1,j2,k) - ijjkRealPowerDestinationDef.lo(i,j1,j2,k))):0:10 ','
      (baseMVA * (ijjkReactivePowerDestinationDef.l(i,j1,j2,k) - ijjkReactivePowerDestinationDef.lo(i,j1,j2,k))):0:10 ','
      (ijjkVoltageMagnitudeSeriesImpedanceZeroEq.l(i,j1,j2,k) - ijjkVoltageMagnitudeSeriesImpedanceZeroEq.lo(i,j1,j2,k)):0:10 ','
      ((180/pi) * (ijjkVoltageAngleSeriesImpedanceZeroEq.l(i,j1,j2,k) - ijjkVoltageAngleSeriesImpedanceZeroEq.lo(i,j1,j2,k))):0:10 ','
      (baseMVA * (ikRealPowerSeriesImpedanceZeroEq.l(i,k) - ikRealPowerSeriesImpedanceZeroEq.lo(i,k))):0:10 ','
      (baseMVA * (ijjkReactivePowerSeriesImpedanceZeroEq.l(i,j1,j2,k) - ijjkReactivePowerSeriesImpedanceZeroEq.lo(i,j1,j2,k))):0:10 /;
  );
);
put '--end of contingency branch' /;
$endif

putclose outputfile%outputtype%;
