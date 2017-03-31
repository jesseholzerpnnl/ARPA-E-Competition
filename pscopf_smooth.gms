$title pscopf_smooth
$ontext
PSCOPF-Smooth: Smooth approximate complementarity formulation
of PV/PQ switching

The intuitive idea of PV/PQ switching is:
Increasing the generation of reactive power at a bus
tends to increase the voltage magnitude at that bus.
Consider a generator bus, i.e. a bus with a generator
having the ability to vary its reactive power output
within distinct bounds, possibly dependent on real power
output. If the bus voltage drops below its set point,
then the generator will react by increasing its reactive
power output, until either the voltage set point is
met or the reactive power upper bound is met. In
equilibrium, it is not possible to have both voltage
shortfall and reactive power generation upper slack.
In other words,

  if V < V_set then Q_gen = Q_gen_max                        (1)

A similar complementarity holds between overvoltage
and reactive power generation lower slack, i.e.

  if V > V_set then Q_gen = Q_gen_min                        (2)

These complementarity conditions are in addition to the
general bounds on voltage magnitude and reactive power
generation:

  V_min <= V <= V_max
  Q_gen_min <= Q_gen <= Q_gen_max

In the more complicated situation where reactive power
generation bounds depend on real power generation, we
have

  if V < V_set then Q_gen = Q_gen_max(P_gen)
  if V > V_set then Q_gen = Q_gen_min(P_gen)

One interesting feature of these complementarity constraints
is the way that they change the feasible set of the problem.
Without the complementarity constraints, increasing Q_gen_max
or decreasing Q_gen_min constitutes a relaxation of the problem,
obviously. With the complementarity constraints, this change to
the problem data is not a relaxation.

Assuming that the complemetarity constraints (1,2) are the
correct model, several questions arise:

1. If a competitor submits a solution with V, Q_gen violating
(1) or (2), how should the constraint violation be
defined? E.g. in (1), we could define the constraint violation
to be, say,

  min(max(0, V_set - V), Q_gen_max - Q_gen)

or

  max(0, V_set - V) * (Q_gen_max - Q_gen)

Or we could modify the competitor's value of Q_gen in
accordance with (1,2), by (in pseudo-python):

  if V < V_set:                                                     (*)
    Q_gen = Q_gen_max
  elif V > V_set:
    Q_gen = Q_gen_min

Then this modified value of Q_gen would be carried forward into the
power balance constraint evaluations. The answer to this
question should be covered by a complete specification of
what values are to be provided by the competitor and what
values are computed by the evaluation procedure.

2. How should our benchmark algorithms treat this complementarity?
Several options can be found in the academic literature on
mathematical programs with complementarity constraints (MPCC,
MPEC, NLPCC, NLPEC, etc), in the documentation of algebraic
modeling languages supporting complementarity constraints
(GAMS, AMPL, etc.), and in the documentation of power systems
analysis software (PSSE/OPF). These approaches include:

a. procedural. Solve multiple subproblems, e.g. a first subproblem
with a high penalty on deviations from V_set, then a heuristic
to determine which buses should be fixed to V_set, which should
be fixed to Q_gen_max, and which should be fixed to Q_gen_min,
then a second subproblem with these variables fixed and no voltage
penalties. This is a heuristic and can easily fail to obtain a
global solution or fail to obtain any solution even if one exists.

b. Exact algebraic. reformulate the complementarity constraints
algebraically, and solve as an NLP. E.g. the complementarity
constraint

  0 <= x . y >= 0,                                               (3)

meaning

  0 <= x, 0 <= y, x = 0 or y = 0

can be formulated algebraically as

  0 <= x, 0 <= y, x*y <= 0

Several other formulations are possible, notably

  0 <= x, 0 <= y, x + y <= sqrt(x^2 + y^2)

These formulations are prone to computational difficulty,
lacking, e.g. a constraint qualification or smoothness
at the point (x,y) = (0,0)

c. Approximate algebraic. Use an algebraic formulation whose
feasible set is approximately that of the complementarity
constraints. In exchange for approximation these formulations
yield computational benefits. E.g. One can take

  0 <= x, 0 <= y, x*y <= c

or

  0 <= x, 0 <= y, x + y <= sqrt(c + x^2 + y^2)

for a parameter c > 0. A natural question that arises in this
approach is, What convergence properties hold as c -> 0?

d. some combination. E.g. solve the model with an algebraic
approximation, then use a predefined rule, such as (*), to
modify the solution so as to ensure that complementarity holds,
then further modifying the solution so as to resolve any ensuing
infeasibility as much as possible.

Our case is more directly analogous to

  -1 <= y <= 1, if x > 0 then y = -1, if x < 0 then y = 1          (**)

Specifically, we have (**) with x = V - V_set and
y = 2 * (Q_gen - 0.5 * Q_gen_min - 0.5 * Q_gen_max) / (Q_gen_max - Q_gen_min)

There are many classes of algebraic function f so that the
graph of y = f(x) is approximately equal to the feasible set
of (**). Then the graph of y = f(x/c) converges to (**) in
some sense as c -> 0. E.g.

  f(x) = -2 * arctan(x)

A large family of these functions can be constructed from definite
integrals of functions resembling the normal probability distribution
function (including the example above). Some of these are not
strictly algebraic (rather they are transcendental), but they
are still available in algebraic modeling languages.

Since this approximation y = f(x/c) gives y as an explicit
function of x, or, in our case, Q_gen as an explicit function
of V, we could even use this formulation in the description of
the problem. That is, we could say that the model we want
competitors to solve actually assumes that Q_gen is a smooth
function of V, rather than a discontinuous step function.
This would probably make the problem easier to solve and might
be more realistic anyway. It does though raise the question of
what value of c and what basic function f should be used.

In this model we will still assume that the problem to be solved
is the exact complementarity, but we will solve a single algebraic
model based on an approximation with an explicit funtion using
a particular choice of f and c. Complementarity violation will
be evaluated using the product function. Reactive power generation
will not be modified after the solve.

PSCOPF: Preventive Security-Constrained Optimal Power Flow

The model is an ACOPF with preventive security constraints

Broadly the OPF (optimal power flow) model
involves choosing real power output for a set of generators
so as to meet specified real power demand.
Generator cost functions specify the cost of each generator
producing a given amount of real power.
The objective of OPF is to minimize the total generation cost.

The AC (alternating current) OPF model requires that power
flow from generator buses to load buses through a network of buses,
lines, transformers, and shunt elements according to a set of
power flow equations.
The power flow equations define constraints on the net injections
of real and reactive power at each bus,
the voltage magnitude and angle at each bus,
and the real and reactive power flow along lines and transformers.
Net injection is generation minus demand minus shunt consumption.
Engineering bounds are placed on bus voltage magnitude,
on power and current flows over lines and transformers,
and on generator real and reactive power outputs.

Security constraints further constrain the generator real power
outputs and other decision variables by requiring that under
certain prespecified contingencies, the system will react in
a way that continues to meet engineering limits.
For example, one such contingency might be defined by the
loss of a generator and all its power output.
Another contingency might be defined by the loss
of a line, in which case the power and current flow along that
line is lost, and also the constraints defining those flows are
removed.

In the event of a security contingency,
power injections and flows and bus voltages may change.
The contingency flows and voltages are subject to all the
original engineering bounds.
Voltage magnitudes at buses containing generators are subject
to further constraints under a contingency.
Specifically, the voltage at any generator bus should
remain the same under a contingency as the value assigned
in the base case.
In practice this constraint may be violated,
but all generators at such a bus receive control signals from
the bus voltage, and therefore they produce as much
reactive power as possible as long as the bus voltage is too low,
or conversely consume as much reactive power as possible
as long as the bus voltage is too high.
This generator behavior is known as PV/PQ switching since,
while the bus voltage can be maintained, the bus is a PV bus,
i.e. having fixed net real power (P) injection and fixed voltage
magnitude (V), but if the bus voltage cannot be maintained,
it becomes a PQ bus, i.e. with both fixed values of both
real and reactive net power injection.
This PV/PQ switching constraint on generator behavior is,
algebraically, a pair of complementarity constraints:

if V_i_k < V_i_k0 then Q_gen_g_k = Q_gen_max_g
if V_i_k > V_i_k0 then Q_gen_g_k = Q_gen_min_g

for all buses i, generators g at bus i, security contingencies k,

where k0 represents the base case, and

V_i_k = voltage magnitude at bus i in contingency k
V_i_k0 = voltage magnitude at bus i in base case (k0)
Q_gen_g_k = reactive power generation of generator g in contingency k
Q_gen_max_g = maximum reactive power generation of generator g
Q_gen_min_g = minimum reactive power generation of generator g

The security concept modeled is preventive security,
as opposed to corrective security,
meaning that the actions that may be taken by generators
and other controlled elements of the power system
in order to meet the security constraints in the event of
a security contingency are very limited.
For our purposes,
generator real power output can change only according to a prespecified
participation factor. That is,

P_gen_g_k = P_gen_g_k0 + alpha_g_k * P_delta_k

for all contingencies k and all generators g active in scenario k

where k0 represents the base case, and

P_gen_g_k = real power output of generator g in contingency k
P_gen_g_k0 = real power output of generator g in the base case (k0)
alpha_g_k = participation factor for generator g in contingency k
P_delta_k = total real power power output change by active generators in contingency k

This GAMS code file (GMS) implements a method of solving
the PSCOPF problem.
All input data is described in sets and parameters.
The algebraic model is specified by variables and constraints,
with appropriate bounds on the variables.
The AC power flow is modeled by representing bus voltage in
polar form and power injections and flows in rectangular form.
The model is a nonconvex nonlinear program (NLP).
Specifically, no discrete variables are needed,
but the AC power flow equations make the model nonconvex.
The NLP solver Knitro is called to solve the model,
but other solvers, such as IPOPT, would also be appropriate.

Algebraically, the most challenging aspect of this model is the
complementarity constraints enforcing the PV/PQ switching behavior.
Other SCOPF implementations, both academic and commercial, have
modeled these constraints in various ways. A few of these are:
(1) smooth algebraic approximation of complementarity,
(2) penalization of voltage deviation from base case to security contingency
(3) fixing PV/PQ to one side of the complementarity or the other.
These approaches may be used in succession.
The model given here first uses method (2) to find an initial
solution. This solution is used to select some bus voltage magnitude
and reactive power output variables to fix for a second solve by method (3).
This approach can fail. The second solve with method (3) may be infeasible
even if the overall problem is feasible. The second solve can give
a nonoptimal solution to the overall problem. The solution to the
first solve may present an ambiguous choice of variables to fix for
the second solve.
$offtext

* data gms file
$if not set ingdx $set ingdx pscopf_data.gdx

* voltage magnitude deviation penalty
$if not set voltage_penalty $set voltage_penalty 1000000
$if not set voltage_tolerance $set voltage_tolerance 1e-6

* complementarity
$if not set complementarity_parameter $set complementarity_parameter 1e-3

* solution
$if not set solutionname $set solutionname solution

set baseCase /baseCase/;

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
  complementarityParameter /%complementarity_parameter%/
  lParticipationFactor(l);

* load data from GDX input file
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

* cost variables
variables
  obj
  cost;

* equations
equations
  objDef
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
  lkReactivePowerDef(l,k);

* model
model
  pscopf /
    objDef
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
    lkReactivePowerDef
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

* setup some utility sets
ijjOriginDestination(i,j1,j2)$(ijOrigin(i,j1) and ijDestination(i,j2)) = yes;
ikActive(i,k) = not ikInactive(i,k);
lkActive(l,k) = not lkInactive(l,k);

* data validity checks
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
  =e= cost;

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

lkReactivePowerDef(l,k)$(not kBase(k) and lkActive(l,k) and lReactivePowerMin(l) < lReactivePowerMax(l))..
      (  2 * lkReactivePower(l,k)
       -     lReactivePowerMin(l)
       -     lReactivePowerMax(l)) /
      (      lReactivePowerMax(l)
       -     lReactivePowerMin(l))
  =e= -2 * arctan(sum(j$ljMap(l,j),
                  (  jkVoltageMagnitude(j,k)
		   - sum(k0$kBase(k0),jkVoltageMagnitude(j,k0))) /
		  complementarityParameter));

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

* solver options
pscopf.optfile=1;
$onecho > knitro.opt
feastol 1e-8
opttol 1e-4
maxcgit 10
ftol 1e-4
ftol_iters 3
maxtime_real 60
$offecho

* solve penalty formulation
solve pscopf using nlp minimizing obj;
modelStatus = pscopf.modelstat;
solveStatus = pscopf.solvestat;

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