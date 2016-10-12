parameter BaseMVA /
100
/;
set circuits(*) /
c1
/;
set branches(*) /
i1
/;
set buses(*) /
j1
j2
/;
set contingencies(*) /
k1
k2
k3
/;
set generators(*) /
l1
l2
/;
set polynomialCostTerms(*) /
m0
m1
m2
/;
set units(*) /
u1
u2
/;
alias(circuits,c,c0,c1,c2,c3);
alias(branches,i,i0,i1,i2,i3);
alias(buses,j,j0,j1,j2,j3);
alias(contingencies,k,k0,k1,k2,k3);
alias(generators,l,l0,l1,l2,l3)
alias(polynomialCostTerms,m,m0,m1,m2,m3);
alias(units,u,u0,u1,u2,u3);
set ijOrigin(i,j) /
i1.j1
/;
set ijDestination(i,j) /
i1.j2
/;
set icMap(i,c) /
i1.c1
/;
set ljMap(l,j) /
l1.j1
l2.j2
/;
set luMap(l,u) /
l1.u1
l2.u1
/;
set ikInactive(i,k) /
i1.k3
/;
set lkInactive(l,k) /
l1.k1
l2.k2
/;
parameter jBaseKV(j) /
j1 115
j2 230
/;
parameter jShuntConductance(j) /
j1 0
j2 0
/;
parameter jShuntSusceptance(j) /
j1 0
j2 0
/;
parameter jVoltageMagnitudeMin(j) /
j1 0.9
j2 0.9
/;
parameter jVoltageMagnitudeMax(j) /
j1 1.1
j2 1.1
/;
parameter jRealPowerDemand(j) /
j1 40
j2 40
/;
parameter jReactivePowerDemand(j) /
j1 0
j2 0
/;
parameter iSeriesResistance(i) /
i1 0.1
/;
parameter iSeriesReactance(i) /
i1 0.1
/;
parameter iChargingSusceptance(i) /
i1 0.01
/;
parameter iTapRatio(i) /
i1 1
/;
parameter iPhaseShift(i) /
i1 0
/;
parameter iPowerMagnitudeMax(i) /
i1 100
/;
parameter lRealPowerMin(l) /
l1 0
l2 0
/;
parameter lRealPowerMax(l) /
l1 100
l2 100
/;
parameter lReactivePowerMin(l) /
l1 -300
l2 -300
/;
parameter lReactivePowerMax(l) /
l1 300
l2 300
/;
parameter lParticipationFactor(l) /
l1 0.25
l2 0.25
/;
parameters lmRealPowerCostCoefficient(l,m) /
l1.m0 100
l1.m1  10
l1.m2   0.1
l2.m0 100
l2.m1  10
l2.m2   0.1
/;
parameter lmRealPowerCostExponent(l,m) /
l1.m0 0
l1.m1 1
l1.m2 2
l2.m0 0
l2.m1 1
l2.m2 2
/;

