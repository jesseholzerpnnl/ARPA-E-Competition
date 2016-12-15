$title pscopf
$ontext
Preventive security-constrained optimal power flow

ACOPF model
with (presumably convex) quadratic real power generation cost functions


polynomial and convex piecewise linear real power generation cost functions
preventive security constraints based on prescribed reaction to contingencies

are other MVA and KV bases needed?

On processing into per unit, the solution with no security contingencies
agrees exactly with the Matpower solution for case14.
However, reading the psse version of case14 into matpower and translating it to
a matpower case and using that to generate data for this model give a
slightly different even if the cost data is taken from the original matpower case14.
If the cost data is taken from our generator.csv file, the solution is radically
different.
The agreement with matpower on the original case14 suggests that at least the
ACOPF model contained here, and all the per unit transformations, are correct.

We need to map the matpower components and GAMS components to
the original component identifiers (buses, branches, etc.)

need to know:
which buses are original, what are their identifiers?
what are the generator identifiers?
$offtext

* data gms file
$if not set ingdx $set ingdx pscopf_data.gdx

* voltage magnitude deviation penalty
$if not set voltage_penalty $set voltage_penalty 1000000
$if not set voltage_tolerance $set voltage_tolerance 1e-6

* model:
* pen
* strict
$if not set model $set model pen

* solution
$if not set solutionname $set solutionname solution

* for testing:
$if not set do_infeas $set do_infeas 0
$if not set do_bad_output $set do_bad_output 0
$if not set do_compile_error $set do_compile_error 0
$if not set do_exec_error $set do_exec_error 0

$if not set int_max $set int_max 1000000

$ifthen %do_compile_error%==1
$abort 'added a compile error'
$endif

$ifthen %do_exec_error%==1
abort 'added an execution error';
$endif

set baseCase /baseCase/;
*set nonnegativeIntegers /0*%int_max%/;

sets
  circuits c
  branches i
  buses j
  cases k
  generators l
  polynomialCostTerms m
  units u;

alias(circuits,c,c0,c1,c2,c3);
alias(branches,i,i0,i1,i2,i3);
alias(buses,j,j0,j1,j2,j3);
alias(cases,k,k0,k1,k2,k3);
alias(generators,l,l0,l1,l2,l3)
alias(polynomialCostTerms,m,m0,m1,m2,m3);
alias(units,u,u0,u1,u2,u3);

* network topology
set
  ijOrigin(i,j)
  ijDestination(i,j)
  ijjOriginDestination(i,j1,j2)
  icMap(i,c)
  ljMap(l,j)
  luMap(l,u)
  ikInactive(i,k)
  lkInactive(l,k)
  ikActive(i,k)
  lkActive(l,k)
  kBase(k);

* branches with zero series impedance are treated specially
set
  iSeriesImpedanceZero(i)
  iSeriesImpedanceNonzero(i);

* system technical characteristics
parameter
  baseMVA;

* bus technical characteristics
parameters
  jBaseKV(j)
  jShuntConductance(j) g^sh
  jShuntSusceptance(j) b^sh;

* bus performance limits
parameters
  jVoltageMagnitudeMin(j) v^min
  jVoltageMagnitudeMax(j) v^max;

* bus power demand
parameters
  jRealPowerDemand(j) p^dem
  jReactivePowerDemand(j) q^dem;

* branch technical characteristics
parameters
  iSeriesResistance(i) r^s
  iSeriesReactance(i) x^s
  iSeriesConductance(i) g^s
  iSeriesSusceptance(i) b^s
  iChargingSusceptance(i) b^c
  iTapRatio(i) tau^tr
  iPhaseShift(i) theta^tr;

* branch performance limits
parameters
  iPowerMagnitudeMax(i) s^max;

* generator performance limits
parameters
  lRealPowerMin(l) "p^gen,min"
  lRealPowerMax(l) "p^gen,max"
  lReactivePowerMin(l) "q^gen,min"
  lReactivePowerMax(l) "q^gen,max";

* generator cost characteristics
parameters
  lmRealPowerCostCoefficient(l,m)
  lmRealPowerCostExponent(l,m);

* contingency modeling parameters
parameters
  penaltyCoeff /%voltage_penalty%/
  lParticipationFactor(l);

$gdxin '%ingdx%'
$loaddc circuits
$loaddc branches
$loaddc buses
$loaddc cases
$loaddc generators
$loaddc polynomialCostTerms
$loaddc units
$loaddc ijOrigin
$loaddc ijDestination
$loaddc icMap
$loaddc ljMap
$loaddc luMap
$loaddc ikInactive
$loaddc lkInactive
$loaddc kBase
$loaddc baseMVA
$loaddc jBaseKV
$loaddc jShuntConductance
$loaddc jShuntSusceptance
$loaddc jVoltageMagnitudeMin
$loaddc jVoltageMagnitudeMax
$loaddc jRealPowerDemand
$loaddc jReactivePowerDemand
$loaddc iSeriesResistance
$loaddc iSeriesReactance
$loaddc iChargingSusceptance
$loaddc iTapRatio
$loaddc iPhaseShift
$loaddc iPowerMagnitudeMax
$loaddc lRealPowerMin
$loaddc lRealPowerMax
$loaddc lReactivePowerMin
$loaddc lReactivePowerMax
$loaddc lmRealPowerCostCoefficient
$loaddc lmRealPowerCostExponent
$loaddc lParticipationFactor
$gdxin

* experiment
iPowerMagnitudeMax(i) = 1.3*iPowerMagnitudeMax(i);
*jRealPowerDemand(j) = 0.55*jRealPowerDemand(j);
*jReactivePowerDemand(j) = 0.55*jReactivePowerDemand(j);

*ikInactive(i,k) = no;
*lkInactive(l,k) = no;

* solution
parameter
  modelStatus /0/
  solveStatus /0/
  lkReactivePowerSlackLo(l,k)
  lkReactivePowerSlackUp(l,k)
  jkReactivePowerGenSlackLo(j,k)
  jkReactivePowerGenSlackUp(j,k)
  jkVoltMagDevLo(j,k)
  jkVoltMagDevUp(j,k)
  jkVoltMagDevLoReactivePowerGenSlackUpCompViol(j,k)
  jkVoltMagDevUpReactivePowerGenSlackLoCompViol(j,k);

* technical variables
variables
  lkRealPower(l,k)
  lkReactivePower(l,k)
  jkVoltageMagnitude(j,k)
  jkVoltageAngle(j,k)
  jkShuntRealPower(j,k) bus to shunt
  jkShuntReactivePower(j,k) bus to shunt
  ikRealPowerOrigin(i,k) bus to branch
  ikReactivePowerOrigin(i,k) bus to branch
  ikRealPowerDestination(i,k) bus to branch
  ikReactivePowerDestination(i,k) bus to branch
  kRealPowerShortfall(k) missing real power that must be made up by increased generation;

* violation variables
positive variables
  jkVoltageMagnitudeViolationPos(j,k)
  jkVoltageMagnitudeViolationNeg(j,k);

* cost variables
variables
  obj
  penalty
  cost;

* equations
equations
  objDef
  penaltyDef
  costDef
  jkRealPowerBalance(j,k)
  jkReactivePowerBalance(j,k)
  ikPowerMagnitudeOriginBound(i,k)
  ikPowerMagnitudeDestinationBound(i,k)
  jkShuntRealPowerDef(j,k)
  jkShuntReactivePowerDef(j,k)
  ijjkRealPowerOriginDef(i,j1,j2,k)
  ijjkReactivePowerOriginDef(i,j1,j2,k)
  ijjkRealPowerDestinationDef(i,j1,j2,k)
  ijjkReactivePowerDestinationDef(i,j1,j2,k)
  ijjkVoltageMagnitudeSeriesImpedanceZeroEq(i,j1,j2,k)
  ijjkVoltageAngleSeriesImpedanceZeroEq(i,j1,j2,k)
  ikRealPowerSeriesImpedanceZeroEq(i,k)
  ijjkReactivePowerSeriesImpedanceZeroEq(i,j1,j2,k)
  lkRealPowerRecoveryDef(l,k)
  jkVoltageMagnitudeMaintenance(j,k)
  jkVoltageMagnitudeMaintenanceViolationDef(j,k);

* model
model
  pscopf_strict /
    costDef
    jkRealPowerBalance
    jkReactivePowerBalance
    ikPowerMagnitudeOriginBound
    ikPowerMagnitudeDestinationBound
    jkShuntRealPowerDef
    jkShuntReactivePowerDef
    ijjkRealPowerOriginDef
    ijjkReactivePowerOriginDef
    ijjkRealPowerDestinationDef
    ijjkReactivePowerDestinationDef
    ijjkVoltageMagnitudeSeriesImpedanceZeroEq
    ijjkVoltageAngleSeriesImpedanceZeroEq
    ikRealPowerSeriesImpedanceZeroEq
    ijjkReactivePowerSeriesImpedanceZeroEq
    lkRealPowerRecoveryDef
    jkVoltageMagnitudeMaintenance
 /
  pscopf_pen /
    objDef
    penaltyDef
    costDef
    jkRealPowerBalance
    jkReactivePowerBalance
    ikPowerMagnitudeOriginBound
    ikPowerMagnitudeDestinationBound
    jkShuntRealPowerDef
    jkShuntReactivePowerDef
    ijjkRealPowerOriginDef
    ijjkReactivePowerOriginDef
    ijjkRealPowerDestinationDef
    ijjkReactivePowerDestinationDef
    ijjkVoltageMagnitudeSeriesImpedanceZeroEq
    ijjkVoltageAngleSeriesImpedanceZeroEq
    ikRealPowerSeriesImpedanceZeroEq
    ijjkReactivePowerSeriesImpedanceZeroEq
    lkRealPowerRecoveryDef
    jkVoltageMagnitudeMaintenanceViolationDef
/;

* process into per unit for optimization model
jShuntConductance(j) = jShuntConductance(j) / baseMVA;
jShuntSusceptance(j) = jShuntSusceptance(j) / baseMVA;
*jVoltageMagnitudeMin(j)
*jVoltageMagnitudeMax(j)
jRealPowerDemand(j) = jRealPowerDemand(j) / baseMVA;
jReactivePowerDemand(j) = jReactivePowerDemand(j) / baseMVA;
*iSeriesResistance(i)
*iSeriesReactance(i)
*iChargingSusceptance(i)
*iTapRatio(i)
*iPhaseShift(i)
iPowerMagnitudeMax(i) = iPowerMagnitudeMax(i) / baseMVA;
lRealPowerMin(l) = lRealPowerMin(l) / baseMVA;
lRealPowerMax(l) = lRealPowerMax(l) / baseMVA;
lReactivePowerMin(l) = lReactivePowerMin(l) / baseMVA;
lReactivePowerMax(l) = lReactivePowerMax(l) / baseMVA;
lmRealPowerCostCoefficient(l,m) = lmRealPowerCostCoefficient(l,m) * power(baseMVA,lmRealPowerCostExponent(l,m));
*lmRealPowerCostExponent(l,m);

* setup some sets
ijjOriginDestination(i,j1,j2)$(ijOrigin(i,j1) and ijDestination(i,j2)) = yes;
ikActive(i,k) = not ikInactive(i,k);
lkActive(l,k) = not lkInactive(l,k);

* data checks
loop(i,
  if(sum(j$ijOrigin(i,j),1) > 1,
    abort 'branch with multiple origins';);
  if(sum(j$ijOrigin(i,j),1) < 1,
    abort 'branch with no origin';);
  if(sum(j$ijDestination(i,j),1) > 1,
    abort 'branch with multiple destinations';);
  if(sum(j$ijDestination(i,j),1) < 1,
    abort 'branch with no destination';);
  if(sum(c$icMap(i,c),1) > 1,
    abort 'branch with multiple circuit ids';);
  if(sum(c$icMap(i,c),1) < 1,
    abort 'branch with no circuit ids';);
);
loop(l,
  if(sum(j$ljMap(l,j),1) > 1,
    abort 'generator with multiple connection buses';
  );
  if(sum(j$ljMap(l,j),1) < 1,
    abort 'generator with no connection bus';
  );
  if(sum(u$luMap(l,u),1) > 1,
    abort 'generator with multiple unit ids';
  );
  if(sum(u$luMap(l,u),1) < 1,
    abort 'generator with no unit id';
  );
);
if(card(kBase) > 1,
  abort 'more than one base case';);
if(card(kBase) < 1,
  abort 'less than one base case';);
loop(k$(not kBase(k)),
  if(sum(l$lkActive(l,k),abs(lParticipationFactor(l))) = 0,
    abort 'contingency with no active participating generators';);
);

*lParticipationFactor(l) = lParticipationFactor(l) / sum(l0,lParticipationFactor(l0));

* compute line parameters
iSeriesImpedanceNonzero(i) = (
  abs(iSeriesResistance(i)) gt 0 or
  abs(iSeriesReactance(i)) gt 0);
iSeriesImpedanceZero(i) = (
  not iSeriesImpedanceNonzero(i));
iSeriesConductance(i)$iSeriesImpedanceNonzero(i)
  = iSeriesResistance(i)
  / (sqr(iSeriesResistance(i)) + sqr(iSeriesReactance(i)));
iSeriesSusceptance(i)$iSeriesImpedanceNonzero(i)
  = -iSeriesReactance(i)
  / (sqr(iSeriesResistance(i)) + sqr(iSeriesReactance(i)));

* make some mistakes
*$ontext
$ifthen %do_infeas%==1
parameter infeasibilityScale / 0.01 /;
jRealPowerDemand(j) = (1 + infeasibilityScale * normal(0,1)) * jRealPowerDemand(j);
jReactivePowerDemand(j) = (1 + infeasibilityScale * normal(0,1)) * jReactivePowerDemand(j);
jVoltageMagnitudeMin(j) = (1 - infeasibilityScale * sqr(normal(0,1))) * jVoltageMagnitudeMin(j);
jVoltageMagnitudeMax(j) = (1 + infeasibilityScale * sqr(normal(0,1))) * jVoltageMagnitudeMax(j);
lRealPowerMin(l) = (1 - infeasibilityScale * sqr(normal(0,1))) * lRealPowerMin(l);
lRealPowerMax(l) = (1 + infeasibilityScale * sqr(normal(0,1))) * lRealPowerMax(l);
lReactivePowerMin(l) = (1 - infeasibilityScale * sqr(normal(0,1))) * lReactivePowerMin(l);
lReactivePowerMax(l) = (1 + infeasibilityScale * sqr(normal(0,1))) * lReactivePowerMax(l);
iPowerMagnitudeMax(i) = (1 + infeasibilityScale * sqr(normal(0,1))) * iPowerMagnitudeMax(i);
*$offtext
$endif

* bounds
lkRealPower.lo(l,k)$lkActive(l,k) = lRealPowerMin(l);
lkReactivePower.lo(l,k)$lkActive(l,k) = lReactivePowerMin(l);
jkVoltageMagnitude.lo(j,k) = jVoltageMagnitudeMin(j);
lkRealPower.up(l,k)$lkActive(l,k) = lRealPowerMax(l);
lkReactivePower.up(l,k)$lkActive(l,k) = lReactivePowerMax(l);
jkVoltageMagnitude.up(j,k) = jVoltageMagnitudeMax(j);

* equation definitions

* general objective
objDef..
      obj
  =e= cost
   +  penaltyCoeff * penalty;

* penalty
penaltyDef..
      penalty
  =e= sum((j,k)$(not kBase(k) and sum(l$(lkActive(l,k) and ljMap(l,j)),1)),
          jkVoltageMagnitudeViolationPos(j,k)
        + jkVoltageMagnitudeViolationNeg(j,k));

* generation cost
costDef..
      cost
  =e= sum(k$kBase(k),
        sum(l$lkActive(l,k),
              sum(m$(abs(lmRealPowerCostExponent(l,m)) > 0),
                  lmRealPowerCostCoefficient(l,m)
                * power(lkRealPower(l,k),lmRealPowerCostExponent(l,m)))
            + sum(m$(abs(lmRealPowerCostExponent(l,m)) = 0),
                  lmRealPowerCostCoefficient(l,m))));

* power in = power out
jkRealPowerBalance(j,k)..
      sum(l$(lkActive(l,k) and ljMap(l,j)),lkRealPower(l,k))
  =e= jkShuntRealPower(j,k)
   +  sum(i$(ikActive(i,k) and ijOrigin(i,j)),ikRealPowerOrigin(i,k))
   +  sum(i$(ikActive(i,k) and ijDestination(i,j)),ikRealPowerDestination(i,k))
   +  jRealPowerDemand(j);

* power in = power out
jkReactivePowerBalance(j,k)..
      sum(l$(lkActive(l,k) and ljMap(l,j)),lkReactivePower(l,k))
  =e= jkShuntReactivePower(j,k)
   +  sum(i$(ikActive(i,k) and ijOrigin(i,j)),ikReactivePowerOrigin(i,k))
   +  sum(i$(ikActive(i,k) and ijDestination(i,j)),ikReactivePowerDestination(i,k))
   +  jReactivePowerDemand(j);

ikPowerMagnitudeOriginBound(i,k)$ikActive(i,k)..
      sqrt(1 + sqr(ikRealPowerOrigin(i,k)) + sqr(ikReactivePowerOrigin(i,k)))
  =l= sqrt(1 + sqr(iPowerMagnitudeMax(i)));

ikPowerMagnitudeDestinationBound(i,k)$ikActive(i,k)..
      sqrt(1 + sqr(ikRealPowerDestination(i,k)) + sqr(ikReactivePowerDestination(i,k)))
  =l= sqrt(1 + sqr(iPowerMagnitudeMax(i)));

jkShuntRealPowerDef(j,k)..
      jkShuntRealPower(j,k)
  =e= jShuntConductance(j)*sqr(jkVoltageMagnitude(j,k));

jkShuntReactivePowerDef(j,k)..
      jkShuntReactivePower(j,k)
  =e= -jShuntSusceptance(j)*sqr(jkVoltageMagnitude(j,k));

ijjkRealPowerOriginDef(i,j1,j2,k)$(ijjOriginDestination(i,j1,j2) and iSeriesImpedanceNonzero(i) and ikActive(i,k))..
      ikRealPowerOrigin(i,k)
  =e= (iSeriesConductance(i)/sqr(iTapRatio(i)))*sqr(jkVoltageMagnitude(j1,k))
   +  (-iSeriesConductance(i)/iTapRatio(i))*jkVoltageMagnitude(j1,k)*jkVoltageMagnitude(j2,k)*cos(jkVoltageAngle(j2,k) - jkVoltageAngle(j1,k) + iPhaseShift(i))
   +  (iSeriesSusceptance(i)/iTapRatio(i))*jkVoltageMagnitude(j1,k)*jkVoltageMagnitude(j2,k)*sin(jkVoltageAngle(j2,k) - jkVoltageAngle(j1,k) + iPhaseShift(i));

ijjkReactivePowerOriginDef(i,j1,j2,k)$(ijjOriginDestination(i,j1,j2) and iSeriesImpedanceNonzero(i) and ikActive(i,k))..
      ikReactivePowerOrigin(i,k)
  =e= ((-iSeriesSusceptance(i)-0.5*iChargingSusceptance(i))/sqr(iTapRatio(i)))*sqr(jkVoltageMagnitude(j1,k))
   +  (iSeriesSusceptance(i)/iTapRatio(i))*jkVoltageMagnitude(j1,k)*jkVoltageMagnitude(j2,k)*cos(jkVoltageAngle(j2,k) - jkVoltageAngle(j1,k) + iPhaseShift(i))
   +  (iSeriesConductance(i)/iTapRatio(i))*jkVoltageMagnitude(j1,k)*jkVoltageMagnitude(j2,k)*sin(jkVoltageAngle(j2,k) - jkVoltageAngle(j1,k) + iPhaseShift(i));

ijjkRealPowerDestinationDef(i,j1,j2,k)$(ijjOriginDestination(i,j1,j2) and iSeriesImpedanceNonzero(i) and ikActive(i,k))..
      ikRealPowerDestination(i,k)
  =e= iSeriesConductance(i)*sqr(jkVoltageMagnitude(j2,k))
   +  (-iSeriesConductance(i)/iTapRatio(i))*jkVoltageMagnitude(j1,k)*jkVoltageMagnitude(j2,k)*cos(jkVoltageAngle(j2,k) - jkVoltageAngle(j1,k) + iPhaseShift(i))
   +  (-iSeriesSusceptance(i)/iTapRatio(i))*jkVoltageMagnitude(j1,k)*jkVoltageMagnitude(j2,k)*sin(jkVoltageAngle(j2,k) - jkVoltageAngle(j1,k) + iPhaseShift(i));

ijjkReactivePowerDestinationDef(i,j1,j2,k)$(ijjOriginDestination(i,j1,j2) and iSeriesImpedanceNonzero(i) and ikActive(i,k))..
      ikReactivePowerDestination(i,k)
  =e= (-iSeriesSusceptance(i)-0.5*iChargingSusceptance(i))*sqr(jkVoltageMagnitude(j2,k))
   +  (iSeriesSusceptance(i)/iTapRatio(i))*jkVoltageMagnitude(j1,k)*jkVoltageMagnitude(j2,k)*cos(jkVoltageAngle(j2,k) - jkVoltageAngle(j1,k) + iPhaseShift(i))
   +  (-iSeriesConductance(i)/iTapRatio(i))*jkVoltageMagnitude(j1,k)*jkVoltageMagnitude(j2,k)*sin(jkVoltageAngle(j2,k) - jkVoltageAngle(j1,k) + iPhaseShift(i));

ijjkVoltageMagnitudeSeriesImpedanceZeroEq(i,j1,j2,k)$(ijjOriginDestination(i,j1,j2) and iSeriesImpedanceZero(i) and ikActive(i,k))..
      jkVoltageMagnitude(j2,k)
   -  jkVoltageMagnitude(j1,k)/iTapRatio(i)
  =e= 0;

ijjkVoltageAngleSeriesImpedanceZeroEq(i,j1,j2,k)$(ijjOriginDestination(i,j1,j2) and iSeriesImpedanceZero(i) and ikActive(i,k))..
      jkVoltageAngle(j2,k)
   -  jkVoltageAngle(j1,k)
   +  iPhaseShift(i)
  =e= 0;

ikRealPowerSeriesImpedanceZeroEq(i,k)$(iSeriesImpedanceZero(i) and ikActive(i,k))..
      ikRealPowerOrigin(i,k)
   +  ikRealPowerDestination(i,k)
  =e= 0;

ijjkReactivePowerSeriesImpedanceZeroEq(i,j1,j2,k)$(iSeriesImpedanceZero(i) and ijjOriginDestination(i,j1,j2) and ikActive(i,k))..
      ikReactivePowerOrigin(i,k)
   +  ikReactivePowerDestination(i,k)
   +  iChargingSusceptance(i)*jkVoltageMagnitude(j1,k)*jkVoltageMagnitude(j2,k)/iTapRatio(i)
  =e= 0;

lkRealPowerRecoveryDef(l,k)$(lkActive(l,k) and not kBase(k))..
      lkRealPower(l,k)
  =e= sum(k0$kBase(k0),lkRealPower(l,k0))
   +  lParticipationFactor(l)*kRealPowerShortfall(k)
   /  sum(l1$lkActive(l1,k),lParticipationFactor(l1))
;

jkVoltageMagnitudeMaintenance(j,k)$(not kBase(k) and sum(l$(lkActive(l,k) and ljMap(l,j)),1))..
      jkVoltageMagnitude(j,k)
  =e= sum(k0$kBase(k0),jkVoltageMagnitude(j,k0));

jkVoltageMagnitudeMaintenanceViolationDef(j,k)$(not kBase(k) and sum(l$(lkActive(l,k) and ljMap(l,j)),1))..
      jkVoltageMagnitude(j,k)
   -  sum(k0$kBase(k0),jkVoltageMagnitude(j,k0))
  =e= jkVoltageMagnitudeViolationPos(j,k)
   -  jkVoltageMagnitudeViolationNeg(j,k);

*lkActive(l,k) = lkActive(l,k) and (ord(k) = 1);
*ikActive(i,k) = ikActive(i,k) and (ord(k) = 1);

* set a start point
$ontext
* random start point
lkRealPower.l(l,k)$lkActive(l,k) = uniform(lRealPowerMin(l),lRealPowerMax(l));
lkReactivePower.l(l,k)$lkActive(l,k) = uniform(lReactivePowerMin(l),lReactivePowerMax(l));
jkVoltageMagnitude.l(j,k) = uniform(jVoltageMagnitudeMin(j),jVoltageMagnitudeMax(j));
jkVoltageAngle.l(j,k) = normal(0,1);
jkShuntRealPower.l(j,k) = normal(0,1);
jkShuntReactivePower.l(j,k) = normal(0,1);
ikRealPowerOrigin.l(i,k)$ikActive(i,k) = normal(0,1);
ikReactivePowerOrigin.l(i,k)$ikActive(i,k) = normal(0,1);
ikRealPowerDestination.l(i,k)$ikActive(i,k) = normal(0,1);
ikReactivePowerDestination.l(i,k)$ikActive(i,k) = normal(0,1);
$offtext

*scaling
pscopf_pen.scaleopt=0;
jkVoltageMagnitudeViolationPos.scale(j,k)$(not kBase(k) and sum(l$(lkActive(l,k) and ljMap(l,j)),1)) = 1;
jkVoltageMagnitudeViolationNeg.scale(j,k)$(not kBase(k) and sum(l$(lkActive(l,k) and ljMap(l,j)),1)) = 1;
jkVoltageMagnitudeMaintenanceViolationDef.scale(j,k)$(not kBase(k) and sum(l$(lkActive(l,k) and ljMap(l,j)),1)) = 1e3;

* solver options
pscopf_pen.optfile=1;
*pscopf_strict.optfile=1;
$onecho > knitro.opt
*bar_penaltycons 2
*secret 1050 i 2
feastol 1e-10
opttol 1e-10
*ms_enable 1
$offecho

* solve penalty formulation
solve pscopf_pen using nlp minimizing obj;
modelStatus = pscopf_pen.modelstat;
solveStatus = pscopf_pen.solvestat;
*$exit

* assess slacks and deviations
lkReactivePowerSlackLo(l,k)$lkActive(l,k)
  = max(0,lkReactivePower.l(l,k)-lReactivePowerMin(l));
lkReactivePowerSlackUp(l,k)$lkActive(l,k)
  = max(0,lReactivePowerMax(l)-lkReactivePower.l(l,k));
jkReactivePowerGenSlackLo(j,k)
  = sum(l$(ljMap(l,j) and lkActive(l,k)),lkReactivePowerSlackLo(l,k));
jkReactivePowerGenSlackUp(j,k)
  = sum(l$(ljMap(l,j) and lkActive(l,k)),lkReactivePowerSlackUp(l,k));
jkVoltMagDevLo(j,k)
  = max(0,sum(k1$kBase(k1),jkVoltageMagnitude.l(j,k1))-jkVoltageMagnitude.l(j,k))
    $(sum(l$(lkActive(l,k) and ljMap(l,j)),1) > 0);
jkVoltMagDevUp(j,k)
  = max(0,jkVoltageMagnitude.l(j,k)-sum(k1$kBase(k1),jkVoltageMagnitude.l(j,k1)))
    $(sum(l$(lkActive(l,k) and ljMap(l,j)),1) > 0);
jkVoltMagDevLoReactivePowerGenSlackUpCompViol(j,k)
  = jkVoltMagDevLo(j,k)*jkReactivePowerGenSlackUp(j,k);
jkVoltMagDevUpReactivePowerGenSlackLoCompViol(j,k)
  = jkVoltMagDevUp(j,k)*jkReactivePowerGenSlackLo(j,k);

display
  jkVoltMagDevLo
  jkVoltMagDevUp;

* set bounds to achieve complementarity based on current point
* if v < v* and q = qmax then fix q = qmax
* i.e. if vDevLo > qSlackUp then fix q = qmax
*
* if v > v* and q = qmin then fix q = qmin
* i.e. if vDevUp > qSlackLo then fix q = qmin
*
* if qmin < q < qmax and v = v* then fix v = v*
* i.e. if vDevLo <= qSlackUp and vDevUp <= qSlackDown then fix v = f*
parameter
  voltageMagnitudeDeviationTolerance /%voltage_tolerance%/;
loop((j,k)$(not kBase(k) and sum(l$(lkActive(l,k) and ljMap(l,j)),1) > 0),
$ontext
  if(jkVoltMagDevLo(j,k) > jkReactivePowerGenSlackUp(j,k),
    lkReactivePower.lo(l,k)$(lkActive(l,k) and ljMap(l,j)) = lReactivePowerMax(l);
  );
  if(jkVoltMagDevUp(j,k) > jkReactivePowerGenSlackLo(j,k),
    lkReactivePower.up(l,k)$(lkActive(l,k) and ljMap(l,j)) = lReactivePowerMin(l);
  );
  if(jkVoltMagDevLo(j,k) le jkReactivePowerGenSlackUp(j,k) and jkVoltMagDevUp(j,k) le jkReactivePowerGenSlackLo(j,k),
    jkVoltageMagnitudeViolationPos.fx(j,k) = 0;
    jkVoltageMagnitudeViolationNeg.fx(j,k) = 0;
  );
$offtext
  if(jkVoltMagDevLo(j,k) > voltageMagnitudeDeviationTolerance,
    lkReactivePower.fx(l,k)$(lkActive(l,k) and ljMap(l,j)) = lReactivePowerMax(l);
    jkVoltageMagnitudeViolationPos.fx(j,k) = 0;
  elseif jkVoltMagDevUp(j,k) > voltageMagnitudeDeviationTolerance,
    lkReactivePower.fx(l,k)$(lkActive(l,k) and ljMap(l,j)) = lReactivePowerMin(l);
    jkVoltageMagnitudeViolationNeg.fx(j,k) = 0;
  else
    jkVoltageMagnitudeViolationPos.fx(j,k) = 0;
    jkVoltageMagnitudeViolationNeg.fx(j,k) = 0;
  );
);

* experiment
*lkReactivePower.up(l,k)$(lkActive(l,k) and lkReactivePower.l(l,k) = lReactivePowerMax(l)) = lReactivePowerMax(l);
*lkReactivePower.lo(l,k)$(lkActive(l,k) and lkReactivePower.l(l,k) = lReactivePowerMin(l)) = lReactivePowerMin(l);
*lkReactivePower.up(l,k)$(lkActive(l,k)) = 100;
*lkReactivePower.lo(l,k)$(lkActive(l,k)) = -100;
*lkReactivePower.up(l,k)$(lkActive(l,k)) = lReactivePowerMax(l) + abs(lReactivePowerMax(l));
*lkReactivePower.lo(l,k)$(lkActive(l,k)) = lReactivePowerMin(l) - abs(lReactivePowerMin(l));

* resolve
*$ontext
if(modelStatus = 2,
penaltyCoeff = 0;
*pscopf_pen.holdfixed = 1;
solve pscopf_pen using nlp minimizing obj;
modelStatus = pscopf_pen.modelstat;
solveStatus = pscopf_pen.solvestat;
);
*$offtext

* assess solution
lkReactivePowerSlackLo(l,k)$lkActive(l,k)
  = max(0,lkReactivePower.l(l,k)-lReactivePowerMin(l));
lkReactivePowerSlackUp(l,k)$lkActive(l,k)
  = max(0,lReactivePowerMax(l)-lkReactivePower.l(l,k));
jkReactivePowerGenSlackLo(j,k)
  = sum(l$(ljMap(l,j) and lkActive(l,k)),lkReactivePowerSlackLo(l,k));
jkReactivePowerGenSlackUp(j,k)
  = sum(l$(ljMap(l,j) and lkActive(l,k)),lkReactivePowerSlackUp(l,k));
jkVoltMagDevLo(j,k)
  =  max(0,sum(k1$kBase(k1),jkVoltageMagnitude.l(j,k1))-jkVoltageMagnitude.l(j,k))
    $(sum(l$(lkActive(l,k) and ljMap(l,j)),1) > 0);
jkVoltMagDevUp(j,k)
  = max(0,jkVoltageMagnitude.l(j,k)-sum(k1$kBase(k1),jkVoltageMagnitude.l(j,k1)))
    $(sum(l$(lkActive(l,k) and ljMap(l,j)),1) > 0);
jkVoltMagDevLoReactivePowerGenSlackUpCompViol(j,k)
  = jkVoltMagDevLo(j,k)*jkReactivePowerGenSlackUp(j,k);
jkVoltMagDevUpReactivePowerGenSlackLoCompViol(j,k)
  = jkVoltMagDevUp(j,k)*jkReactivePowerGenSlackLo(j,k);

* translate back to data units
lkReactivePowerSlackLo(l,k)$lkActive(l,k)
  = baseMVA*lkReactivePowerSlackLo(l,k);
lkReactivePowerSlackUp(l,k)$lkActive(l,k)
  = baseMVA*lkReactivePowerSlackUp(l,k);
jkReactivePowerGenSlackLo(j,k)
  = baseMVA*jkReactivePowerGenSlackLo(j,k);
jkReactivePowerGenSlackUp(j,k)
  = baseMVA*jkReactivePowerGenSlackUp(j,k);
*jkVoltMagDevLo(j,k)
*jkVoltMagDevUp(j,k)
jkVoltMagDevLoReactivePowerGenSlackUpCompViol(j,k)
  = baseMVA*jkVoltMagDevLoReactivePowerGenSlackUpCompViol(j,k);
jkVoltMagDevUpReactivePowerGenSlackLoCompViol(j,k)
  = baseMVA*jkVoltMagDevUpReactivePowerGenSlackLoCompViol(j,k);
iPowerMagnitudeMax(i) = baseMVA * iPowerMagnitudeMax(i);
ikRealPowerOrigin.l(i,k)$ikActive(i,k) = baseMVA * ikRealPowerOrigin.l(i,k);
ikReactivePowerOrigin.l(i,k)$ikActive(i,k) = baseMVA * ikReactivePowerOrigin.l(i,k);
ikRealPowerDestination.l(i,k)$ikActive(i,k) = baseMVA * ikRealPowerDestination.l(i,k);
ikReactivePowerDestination.l(i,k)$ikActive(i,k) = baseMVA * ikReactivePowerDestination.l(i,k);
jkShuntRealPower.l(j,k) = baseMVA * jkShuntRealPower.l(j,k);
jkShuntReactivePower.l(j,k) = baseMVA * jkShuntReactivePower.l(j,k);
lRealPowerMin(l) = baseMVA * lRealPowerMin(l);
lRealPowerMax(l) = baseMVA * lRealPowerMax(l);
lReactivePowerMin(l) = baseMVA * lReactivePowerMin(l);
lReactivePowerMax(l) = baseMVA * lReactivePowerMax(l);
jRealPowerDemand(j) = baseMVA * jRealPowerDemand(j);
jReactivePowerDemand(j) = baseMVA * jReactivePowerDemand(j);
*jkVoltageMagnitude.l(j,k) = jBaseKV(j) * jkVoltageMagnitude.l(j,k);
jkVoltageAngle.l(j,k) = 180 * jkVoltageAngle.l(j,k) / pi;
lkRealPower.l(l,k)$lkActive(l,k) = baseMVA * lkRealPower.l(l,k);
lkReactivePower.l(l,k)$lkActive(l,k) = baseMVA * lkReactivePower.l(l,k);
kRealPowerShortfall.l(k)
  = baseMVA * kRealPowerShortfall.l(k)
  / sum(l1$lkActive(l1,k),lParticipationFactor(l1));
*kRealPowerShortfall.l(k) = 0;

* output
$set outputtype 0
$include pscopf_write_solution.gms
$set outputtype 1
$include pscopf_write_solution.gms
$set outputtype 2
$include pscopf_write_solution.gms