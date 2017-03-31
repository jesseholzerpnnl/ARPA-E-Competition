$title pscopf_process_solution
$ontext
pscopf post processing
in particular we need to evaluate the maximum constraint violation
$offtext

parameter
  constrViolMax maximum absolute constraint violation;

constrViolMax = 0;
constrViolMax = max(constrViolMax,
  smax((l,k)$lkActive(l,k),max(0,lRealPowerMin(l)-lkRealPower.l(l,k))));
constrViolMax = max(constrViolMax,
  smax((l,k)$lkActive(l,k),max(0,lkRealPower.l(l,k)-lRealPowerMax(l))));
constrViolMax = max(constrViolMax,
  smax((l,k)$lkActive(l,k),max(0,lReactivePowerMin(l)-lkReactivePower.l(l,k))));
constrViolMax = max(constrViolMax,
  smax((l,k)$lkActive(l,k),max(0,lkReactivePower.l(l,k)-lReactivePowerMax(l))));
constrViolMax = max(constrViolMax,
  smax((j,k), baseMVA * abs(jkShuntRealPowerDef.l(j,k) - jkShuntRealPowerDef.lo(j,k))));
constrViolMax = max(constrViolMax,
  smax((j,k), baseMVA * abs(jkShuntReactivePowerDef.l(j,k) - jkShuntReactivePowerDef.lo(j,k))));
constrViolMax = max(constrViolMax,
  smax((j,k), baseMVA * abs(jkRealPowerBalance.l(j,k) - jkRealPowerBalance.lo(j,k))));
constrViolMax = max(constrViolMax,
  smax((j,k), baseMVA * abs(jkReactivePowerBalance.l(j,k) - jkReactivePowerBalance.lo(j,k))));
constrViolMax = max(constrViolMax,
  smax((j,k), max(0,jVoltageMagnitudeMin(j)-jkVoltageMagnitude.l(j,k))));
constrViolMax = max(constrViolMax,
  smax((j,k), max(0,jkVoltageMagnitude.l(j,k)-jVoltageMagnitudeMax(j))));
constrViolMax = max(constrViolMax, smax((i,k)$ikActive(i,k),
    max(0,sqrt(sqr(ikRealPowerOrigin.l(i,k)) + sqr(ikReactivePowerOrigin.l(i,k)))-iPowerMagnitudeMax(i))));
constrViolMax = max(constrViolMax, smax((i,k)$ikActive(i,k),
    max(0,sqrt(sqr(ikRealPowerDestination.l(i,k)) + sqr(ikReactivePowerDestination.l(i,k)))-iPowerMagnitudeMax(i))));
constrViolMax = max(constrViolMax, smax((i,j1,j2,k)$(ikActive(i,k) and ijOrigin(i,j1) and ijDestination(i,j2)),
    baseMVA * abs(ijjkRealPowerOriginDef.l(i,j1,j2,k) - ijjkRealPowerOriginDef.lo(i,j1,j2,k))));
constrViolMax = max(constrViolMax, smax((i,j1,j2,k)$(ikActive(i,k) and ijOrigin(i,j1) and ijDestination(i,j2)),
    baseMVA * abs(ijjkReactivePowerOriginDef.l(i,j1,j2,k) - ijjkReactivePowerOriginDef.lo(i,j1,j2,k))));
constrViolMax = max(constrViolMax, smax((i,j1,j2,k)$(ikActive(i,k) and ijOrigin(i,j1) and ijDestination(i,j2)),
    baseMVA * abs(ijjkRealPowerDestinationDef.l(i,j1,j2,k) - ijjkRealPowerDestinationDef.lo(i,j1,j2,k))));
constrViolMax = max(constrViolMax, smax((i,j1,j2,k)$(ikActive(i,k) and ijOrigin(i,j1) and ijDestination(i,j2)),
    baseMVA * abs(ijjkReactivePowerDestinationDef.l(i,j1,j2,k) - ijjkReactivePowerDestinationDef.lo(i,j1,j2,k))));
constrViolMax = max(constrViolMax, smax((i,j1,j2,k)$(ikActive(i,k) and ijOrigin(i,j1) and ijDestination(i,j2)),
    abs(ijjkVoltageMagnitudeSeriesImpedanceZeroEq.l(i,j1,j2,k) - ijjkVoltageMagnitudeSeriesImpedanceZeroEq.lo(i,j1,j2,k))));
constrViolMax = max(constrViolMax, smax((i,j1,j2,k)$(ikActive(i,k) and ijOrigin(i,j1) and ijDestination(i,j2)),
    (180/pi) * abs(ijjkVoltageAngleSeriesImpedanceZeroEq.l(i,j1,j2,k) - ijjkVoltageAngleSeriesImpedanceZeroEq.lo(i,j1,j2,k))));
constrViolMax = max(constrViolMax, smax((i,j1,j2,k)$(ikActive(i,k) and ijOrigin(i,j1) and ijDestination(i,j2)),
    baseMVA * abs(ikRealPowerSeriesImpedanceZeroEq.l(i,k) - ikRealPowerSeriesImpedanceZeroEq.lo(i,k))));
constrViolMax = max(constrViolMax, smax((i,j1,j2,k)$(ikActive(i,k) and ijOrigin(i,j1) and ijDestination(i,j2)),
    baseMVA * abs(ijjkReactivePowerSeriesImpedanceZeroEq.l(i,j1,j2,k) - ijjkReactivePowerSeriesImpedanceZeroEq.lo(i,j1,j2,k))));
constrViolMax = max(constrViolMax, smax((j,k),
    min(jkVoltMagDevLo(j,k), jkReactivePowerGenSlackUp(j,k))));
constrViolMax = max(constrViolMax, smax((j,k),
    min(jkVoltMagDevUp(j,k), jkReactivePowerGenSlackLo(j,k))));
