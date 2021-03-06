$title pscopf_compute_solution
$ontext
Compute solution from variable values

* substitute solution variable values as in evaluation code
* begin with values of "independent" variables
* then recompute other variables, in the following order:
* independent:
*   base case generator power
*   all cases voltage
*   contingency cases real power system delta
*   all cases zero impedance branch flow
* compute:
*   all cases nonzero impedance branch flow
*   all cases shunt consumption
*   contingency case generator real power
* base case bus voltage

$offtext

* computed solution variable values
parameter
  lkRealPowerSol(l,k)
  lkReactivePowerSol(l,k)
  jkVoltageMagnitudeSol(j,k)
  jkVoltageAngleSol(j,k)
  jkShuntRealPowerSol(j,k) bus to shunt
  jkShuntReactivePowerSol(j,k) bus to shunt
  ikRealPowerOriginSol(i,k) bus to branch
  ikReactivePowerOriginSol(i,k) bus to branch
  ikRealPowerDestinationSol(i,k) bus to branch
  ikReactivePowerDestinationSol(i,k) bus to branch
  kRealPowerShortfallSol(k) missing real power that must be made up by increased generation;

* computed solution variable bound violations
parameter
  jkVoltageMagnitudeLoViolSol(j,k)
  jkVoltageMagnitudeUpViolSol(j,k)
  lkRealPowerLoViolSol(l,k)
  lkRealPowerUpViolSol(l,k)
  lkReactivePowerLoViolSol(l,k)
  lkReactivePowerUpViolSol(l,k);

* normalized solution variable bound violations
parameter
  jkVoltageMagnitudeLoViolNorm(j,k)
  jkVoltageMagnitudeUpViolNorm(j,k)
  lkRealPowerLoViolNorm(l,k)
  lkRealPowerUpViolNorm(l,k)
  lkReactivePowerLoViolNorm(l,k)
  lkReactivePowerUpViolNorm(l,k);

* computed solution slacks
parameter
  lkReactivePowerLoSlackSol(l,k)
  lkReactivePowerUpSlackSol(l,k)
  lkVoltMagDevPosSol(l,k)
  lkVoltMagDevNegSol(l,k);

* computed solution constraint violations
parameter
  jkRealPowerBalanceViolSol(j,k)
  jkReactivePowerBalanceViolSol(j,k)
  ikPowerMagOrigBoundViolSol(i,k)
  ikPowerMagDestBoundViolSol(i,k)
  ijjkVoltMagImpZeroViolSol(i,j1,j2,k)
  ijjkVoltAngImpZeroViolSol(i,j1,j2,k)
  ikRealPowerImpZeroViolSol(i,k)
  ijjkReactivePowerImpZeroViolSol(i,j1,j2,k)
  lk_QLoSlack_VMDevPos_compViolSol(l,k)
  lk_QUpSlack_VMDevNeg_compViolSol(l,k);

* normalized solution constraint violations
parameter
  jkRealPowerBalanceViolNorm(j,k)
  jkReactivePowerBalanceViolNorm(j,k)
  ikPowerMagOrigBoundViolNorm(i,k)
  ikPowerMagDestBoundViolNorm(i,k)
  ijjkVoltMagImpZeroViolNorm(i,j1,j2,k)
  ijjkVoltAngImpZeroViolNorm(i,j1,j2,k)
  ikRealPowerImpZeroViolNorm(i,k)
  ijjkReactivePowerImpZeroViolNorm(i,j1,j2,k)
  lk_QLoSlack_VMDevPos_compViolNorm(l,k)
  lk_QUpSlack_VMDevNeg_compViolNorm(l,k);

* bound and constraint violation summary
parameter
  max_violSol
  max_jkVoltageMagnitudeLoViolSol
  max_jkVoltageMagnitudeUpViolSol
  max_lkRealPowerLoViolSol
  max_lkRealPowerUpViolSol
  max_lkReactivePowerLoViolSol
  max_lkReactivePowerUpViolSol
  max_jkRealPowerBalanceViolSol
  max_jkReactivePowerBalanceViolSol
  max_ikPowerMagOrigBoundViolSol
  max_ikPowerMagDestBoundViolSol
  max_ijjkVoltMagImpZeroViolSol
  max_ijjkVoltAngImpZeroViolSol
  max_ikRealPowerImpZeroViolSol
  max_ijjkReactivePowerImpZeroViolSol
  max_lk_QLoSlack_VMDevPos_compViolSol
  max_lk_QUpSlack_VMDevNeg_compViolSol;

* normalized bound and constraint violation summary
parameter
  max_ViolNorm
  max_jkVoltageMagnitudeLoViolNorm
  max_jkVoltageMagnitudeUpViolNorm
  max_lkRealPowerLoViolNorm
  max_lkRealPowerUpViolNorm
  max_lkReactivePowerLoViolNorm
  max_lkReactivePowerUpViolNorm
  max_jkRealPowerBalanceViolNorm
  max_jkReactivePowerBalanceViolNorm
  max_ikPowerMagOrigBoundViolNorm
  max_ikPowerMagDestBoundViolNorm
  max_ijjkVoltMagImpZeroViolNorm
  max_ijjkVoltAngImpZeroViolNorm
  max_ikRealPowerImpZeroViolNorm
  max_ijjkReactivePowerImpZeroViolNorm
  max_lk_QLoSlack_VMDevPos_compViolNorm
  max_lk_QUpSlack_VMDevNeg_compViolNorm;

* initially set all solution values to variable levels
lkRealPowerSol(l,k)$lkActive(l,k) = lkRealPower.l(l,k);
lkReactivePowerSol(l,k)$lkActive(l,k) = lkReactivePower.l(l,k);
jkVoltageMagnitudeSol(j,k) = jkVoltageMagnitude.l(j,k);
jkVoltageAngleSol(j,k) = jkVoltageAngle.l(j,k);
jkShuntRealPowerSol(j,k) = jkShuntRealPower.l(j,k);
jkShuntReactivePowerSol(j,k) = jkShuntReactivePower.l(j,k);
ikRealPowerOriginSol(i,k)$ikActive(i,k) = ikRealPowerOrigin.l(i,k);
ikReactivePowerOriginSol(i,k)$ikActive(i,k) = ikReactivePowerOrigin.l(i,k);
ikRealPowerDestinationSol(i,k)$ikActive(i,k) = ikRealPowerDestination.l(i,k);
ikReactivePowerDestinationSol(i,k)$ikActive(i,k) = ikReactivePowerDestination.l(i,k);
kRealPowerShortfallSol(k)$(not kBase(k)) = kRealPowerShortfall.l(k);
*jkVoltageMagnitudeViolationPosSol(j,k) = jkVoltageMagnitudeViolationPos.l(j,k);
*jkVoltageMagnitudeViolationNegSol(j,k) = jkVoltageMagnitudeViolationNeg.l(j,k);

* reset solution values for variables with explicit definition constraints
jkShuntRealPowerSol(j,k) = jShuntConductance(j)*sqr(jkVoltageMagnitudeSol(j,k));
jkShuntReactivePowerSol(j,k) = -jShuntSusceptance(j)*sqr(jkVoltageMagnitudeSol(j,k));
loop((i,j1,j2,k)$(ijjOriginDestination(i,j1,j2) and iSeriesImpedanceNonzero(i) and ikActive(i,k)),
  ikRealPowerOriginSol(i,k)
    = (iSeriesConductance(i)/sqr(iTapRatio(i)))*sqr(jkVoltageMagnitudeSol(j1,k))
    +   (-iSeriesConductance(i)/iTapRatio(i))
      * jkVoltageMagnitudeSol(j1,k)*jkVoltageMagnitudeSol(j2,k)
      * cos(jkVoltageAngleSol(j2,k) - jkVoltageAngleSol(j1,k) + iPhaseShift(i))
    +   (iSeriesSusceptance(i)/iTapRatio(i))
      * jkVoltageMagnitudeSol(j1,k)*jkVoltageMagnitudeSol(j2,k)
      * sin(jkVoltageAngleSol(j2,k) - jkVoltageAngleSol(j1,k) + iPhaseShift(i));
  ikReactivePowerOriginSol(i,k)
    = ((-iSeriesSusceptance(i)-0.5*iChargingSusceptance(i))/sqr(iTapRatio(i)))*sqr(jkVoltageMagnitudeSol(j1,k))
    +   (iSeriesSusceptance(i)/iTapRatio(i))
      * jkVoltageMagnitudeSol(j1,k)*jkVoltageMagnitudeSol(j2,k)
      * cos(jkVoltageAngleSol(j2,k) - jkVoltageAngleSol(j1,k) + iPhaseShift(i))
    +   (iSeriesConductance(i)/iTapRatio(i))
      * jkVoltageMagnitudeSol(j1,k)*jkVoltageMagnitudeSol(j2,k)
      * sin(jkVoltageAngleSol(j2,k) - jkVoltageAngleSol(j1,k) + iPhaseShift(i));
  ikRealPowerDestinationSol(i,k)
    = iSeriesConductance(i)*sqr(jkVoltageMagnitudeSol(j2,k))
    +   (-iSeriesConductance(i)/iTapRatio(i))
      * jkVoltageMagnitudeSol(j1,k)*jkVoltageMagnitudeSol(j2,k)
      * cos(jkVoltageAngleSol(j2,k) - jkVoltageAngleSol(j1,k) + iPhaseShift(i))
    +   (-iSeriesSusceptance(i)/iTapRatio(i))
      * jkVoltageMagnitudeSol(j1,k)*jkVoltageMagnitudeSol(j2,k)
      * sin(jkVoltageAngleSol(j2,k) - jkVoltageAngleSol(j1,k) + iPhaseShift(i));
  ikReactivePowerDestinationSol(i,k)
    = (-iSeriesSusceptance(i)-0.5*iChargingSusceptance(i))*sqr(jkVoltageMagnitudeSol(j2,k))
    +   (iSeriesSusceptance(i)/iTapRatio(i))
      * jkVoltageMagnitudeSol(j1,k)*jkVoltageMagnitudeSol(j2,k)
      * cos(jkVoltageAngleSol(j2,k) - jkVoltageAngleSol(j1,k) + iPhaseShift(i))
    +   (-iSeriesConductance(i)/iTapRatio(i))
      * jkVoltageMagnitudeSol(j1,k)*jkVoltageMagnitudeSol(j2,k)
      * sin(jkVoltageAngleSol(j2,k) - jkVoltageAngleSol(j1,k) + iPhaseShift(i));
);
lkRealPowerSol(l,k)$(lkActive(l,k) and not kBase(k))
  = sum(k0$kBase(k0),lkRealPowerSol(l,k0))
  + lParticipationFactor(l)*kRealPowerShortfallSol(k)
  / sum(l1$lkActive(l1,k),lParticipationFactor(l1));
*jkVoltageMagnitudeViolationPosSol(j,k)$(
*  not kBase(k) and sum(l$(lkActive(l,k) and ljMap(l,j)),1))
*  = max(0,   jkVoltageMagnitudeSol(j,k)
*           - sum(k0$kBase(k0),jkVoltageMagnitudeSol(j,k0)));
*jkVoltageMagnitudeViolationNegSol(j,k)$(
*  not kBase(k) and sum(l$(lkActive(l,k) and ljMap(l,j)),1))
*  = max(0,   sum(k0$kBase(k0),jkVoltageMagnitudeSol(j,k0))
*           - jkVoltageMagnitudeSol(j,k));

* compute variable bound violations
jkVoltageMagnitudeLoViolSol(j,k)
  = max(0, jVoltageMagnitudeMin(j) - jkVoltageMagnitudeSol(j,k));
jkVoltageMagnitudeUpViolSol(j,k)
  = max(0, jkVoltageMagnitudeSol(j,k) - jVoltageMagnitudeMax(j));
lkRealPowerLoViolSol(l,k)$lkActive(l,k)
  = max(0, lRealPowerMin(l) - lkRealPowerSol(l,k));
lkRealPowerUpViolSol(l,k)$lkActive(l,k)
  = max(0, lkRealPowerSol(l,k) - lRealPowerMax(l));
lkReactivePowerLoViolSol(l,k)$lkActive(l,k)
  = max(0, lReactivePowerMin(l) - lkReactivePowerSol(l,k));
lkReactivePowerUpViolSol(l,k)$lkActive(l,k)
  = max(0, lkReactivePowerSol(l,k) - lReactivePowerMax(l));

* compute normalized variable bound violations
jkVoltageMagnitudeLoViolNorm(j,k)
  = jkVoltageMagnitudeLoViolSol(j,k)
  / max(1, abs(jVoltageMagnitudeMin(j)));
jkVoltageMagnitudeUpViolNorm(j,k)
  = jkVoltageMagnitudeUpViolSol(j,k)
  / max(1, abs(jVoltageMagnitudeMax(j)));
lkRealPowerLoViolNorm(l,k)$lkActive(l,k)
  = lkRealPowerLoViolSol(l,k)
  / max(1, abs(lRealPowerMin(l)));
lkRealPowerUpViolNorm(l,k)$lkActive(l,k)
  = lkRealPowerUpViolSol(l,k)
  / max(1, abs(lRealPowerMax(l)));
lkReactivePowerLoViolNorm(l,k)$lkActive(l,k)
  = lkReactivePowerLoViolSol(l,k)
  / max(1, abs(lReactivePowerMin(l)));
lkReactivePowerUpViolNorm(l,k)$lkActive(l,k)
  = lkReactivePowerUpViolSol(l,k)
  / max(1, abs(lReactivePowerMax(l)));

* compute slacks and deviations as needed
lkReactivePowerLoSlackSol(l,k)$(not kBase(k) and lkActive(l,k))
  = max(0, lkReactivePowerSol(l,k) - lReactivePowerMin(l));
lkReactivePowerUpSlackSol(l,k)$(not kBase(k) and lkActive(l,k))
  = max(0, lReactivePowerMax(l) - lkReactivePowerSol(l,k));
lkVoltMagDevPosSol(l,k)$(not kBase(k) and lkActive(l,k))
  = max(0, sum(j$ljMap(l,j), jkVoltageMagnitudeSol(j,k) - sum(k0$kBase(k0), jkVoltageMagnitudeSol(j,k0))));
lkVoltMagDevNegSol(l,k)$(not kBase(k) and lkActive(l,k))
  = max(0, sum(j$ljMap(l,j), sum(k0$kBase(k0), jkVoltageMagnitudeSol(j,k0)) - jkVoltageMagnitudeSol(j,k)));

* compute constraint violations
jkRealPowerBalanceViolSol(j,k)
  = abs(  sum(l$(lkActive(l,k) and ljMap(l,j)),lkRealPowerSol(l,k))
        - jkShuntRealPowerSol(j,k)
        - sum(i$(ikActive(i,k) and ijOrigin(i,j)),ikRealPowerOriginSol(i,k))
        - sum(i$(ikActive(i,k) and ijDestination(i,j)),ikRealPowerDestinationSol(i,k))
        - jRealPowerDemand(j));
jkReactivePowerBalanceViolSol(j,k)
  = abs(  sum(l$(lkActive(l,k) and ljMap(l,j)),lkReactivePowerSol(l,k))
        - jkShuntReactivePowerSol(j,k)
        - sum(i$(ikActive(i,k) and ijOrigin(i,j)),ikReactivePowerOriginSol(i,k))
        - sum(i$(ikActive(i,k) and ijDestination(i,j)),ikReactivePowerDestinationSol(i,k))
        - jReactivePowerDemand(j));
ikPowerMagOrigBoundViolSol(i,k)$ikActive(i,k)
  = max(0,  sqrt(  sqr(ikRealPowerOriginSol(i,k))
                 + sqr(ikReactivePowerOriginSol(i,k)))
          - iPowerMagnitudeMax(i));
ikPowerMagDestBoundViolSol(i,k)$ikActive(i,k)
  = max(0,  sqrt(  sqr(ikRealPowerDestinationSol(i,k))
                 + sqr(ikReactivePowerDestinationSol(i,k)))
          - iPowerMagnitudeMax(i));
ijjkVoltMagImpZeroViolSol(i,j1,j2,k)$(
  iSeriesImpedanceZero(i) and ikActive(i,k) and ijOrigin(i,j1) and ijDestination(i,j2))
  = abs(  jkVoltageMagnitudeSol(j2,k)
        - jkVoltageMagnitudeSol(j1,k)/iTapRatio(i));
ijjkVoltAngImpZeroViolSol(i,j1,j2,k)$(
  iSeriesImpedanceZero(i) and ikActive(i,k) and ijOrigin(i,j1) and ijDestination(i,j2))
  = abs(  jkVoltageAngleSol(j2,k)
        - jkVoltageAngleSol(j1,k)
        + iPhaseShift(i));
ikRealPowerImpZeroViolSol(i,k)$(
  iSeriesImpedanceZero(i) and ikActive(i,k))
  = abs(  ikRealPowerOriginSol(i,k)
        + ikRealPowerDestinationSol(i,k));
ijjkReactivePowerImpZeroViolSol(i,j1,j2,k)$(
  iSeriesImpedanceZero(i) and ikActive(i,k) and ijOrigin(i,j1) and ijDestination(i,j2))
  = abs(  ikReactivePowerOriginSol(i,k)
        + ikReactivePowerDestinationSol(i,k)
        + iChargingSusceptance(i)*jkVoltageMagnitudeSol(j1,k)*jkVoltageMagnitudeSol(j2,k)/iTapRatio(i));
lk_QLoSlack_VMDevPos_compViolSol(l,k)$(
  not kBase(k) and lkActive(l,k))
  = min(lkReactivePowerLoSlackSol(l,k),
        lkVoltMagDevPosSol(l,k));
lk_QUpSlack_VMDevNeg_compViolSol(l,k)$(
  not kBase(k) and lkActive(l,k))
  = min(lkReactivePowerUpSlackSol(l,k),
        lkVoltMagDevNegSol(l,k));

* compute normalized solution constraint violations
jkRealPowerBalanceViolNorm(j,k)
  = jkRealPowerBalanceViolSol(j,k)
  / max(1, abs(jRealPowerDemand(j)));
jkReactivePowerBalanceViolNorm(j,k)
  = jkReactivePowerBalanceViolSol(j,k)
  / max(1, abs(jReactivePowerDemand(j)));
ikPowerMagOrigBoundViolNorm(i,k)$ikActive(i,k)
  = ikPowerMagOrigBoundViolSol(i,k)$ikActive(i,k)
  / max(1, abs(iPowerMagnitudeMax(i)));
ikPowerMagDestBoundViolNorm(i,k)$ikActive(i,k)
  = ikPowerMagDestBoundViolSol(i,k)$ikActive(i,k)
  / max(1, abs(iPowerMagnitudeMax(i)));
ijjkVoltMagImpZeroViolNorm(i,j1,j2,k)$(
  iSeriesImpedanceZero(i) and ikActive(i,k) and ijOrigin(i,j1) and ijDestination(i,j2))
  = ijjkVoltMagImpZeroViolSol(i,j1,j2,k);
ijjkVoltAngImpZeroViolNorm(i,j1,j2,k)$(
  iSeriesImpedanceZero(i) and ikActive(i,k) and ijOrigin(i,j1) and ijDestination(i,j2))
  = ijjkVoltAngImpZeroViolSol(i,j1,j2,k);
ikRealPowerImpZeroViolNorm(i,k)$(
  iSeriesImpedanceZero(i) and ikActive(i,k))
  = ikRealPowerImpZeroViolSol(i,k);
ijjkReactivePowerImpZeroViolNorm(i,j1,j2,k)$(
  iSeriesImpedanceZero(i) and ikActive(i,k) and ijOrigin(i,j1) and ijDestination(i,j2))
  = ijjkReactivePowerImpZeroViolSol(i,j1,j2,k);
lk_QLoSlack_VMDevPos_compViolNorm(l,k)$(
  not kBase(k) and lkActive(l,k))
  = lk_QLoSlack_VMDevPos_compViolSol(l,k);
lk_QUpSlack_VMDevNeg_compViolNorm(l,k)$(
  not kBase(k) and lkActive(l,k))
  = lk_QUpSlack_VMDevNeg_compViolSol(l,k);

* compute summary values
max_jkVoltageMagnitudeLoViolSol = max(0, smax((j,k), jkVoltageMagnitudeLoViolSol(j,k)));
max_jkVoltageMagnitudeUpViolSol = max(0, smax((j,k), jkVoltageMagnitudeUpViolSol(j,k)));
max_lkRealPowerLoViolSol = max(0, smax((l,k)$lkActive(l,k), lkRealPowerLoViolSol(l,k)));
max_lkRealPowerUpViolSol = max(0, smax((l,k)$lkActive(l,k), lkRealPowerUpViolSol(l,k)));
max_lkReactivePowerLoViolSol = max(0, smax((l,k)$lkActive(l,k), lkReactivePowerLoViolSol(l,k)));
max_lkReactivePowerUpViolSol = max(0, smax((l,k)$lkActive(l,k), lkReactivePowerUpViolSol(l,k)));
max_jkRealPowerBalanceViolSol = max(0, smax((j,k), jkRealPowerBalanceViolSol(j,k)));
max_jkReactivePowerBalanceViolSol = max(0, smax((j,k), jkReactivePowerBalanceViolSol(j,k)));
max_ikPowerMagOrigBoundViolSol = max(0, smax((i,k)$ikActive(i,k), ikPowerMagOrigBoundViolSol(i,k)));
max_ikPowerMagDestBoundViolSol = max(0, smax((i,k)$ikActive(i,k), ikPowerMagDestBoundViolSol(i,k)));
max_ijjkVoltMagImpZeroViolSol
  = max(0, smax((i,j1,j2,k)$(
                  iSeriesImpedanceZero(i) and ikActive(i,k) and ijOrigin(i,j1) and ijDestination(i,j2)),
	        ijjkVoltMagImpZeroViolSol(i,j1,j2,k)));
max_ijjkVoltAngImpZeroViolSol
  = max(0, smax((i,j1,j2,k)$(
                  iSeriesImpedanceZero(i) and ikActive(i,k) and ijOrigin(i,j1) and ijDestination(i,j2)),
	        ijjkVoltAngImpZeroViolSol(i,j1,j2,k)));
max_ikRealPowerImpZeroViolSol
  = max(0, smax((i,k)$(iSeriesImpedanceZero(i) and ikActive(i,k)),
                 ikRealPowerImpZeroViolSol(i,k)));
max_ijjkReactivePowerImpZeroViolSol
  = max(0, smax((i,j1,j2,k)$(
                  iSeriesImpedanceZero(i) and ikActive(i,k) and ijOrigin(i,j1) and ijDestination(i,j2)),
        	 ijjkReactivePowerImpZeroViolSol(i,j1,j2,k)));
max_lk_QLoSlack_VMDevPos_compViolSol
  = max(0, smax((l,k)$(not kBase(k) and lkActive(l,k)), lk_QLoSlack_VMDevPos_compViolSol(l,k)));
max_lk_QUpSlack_VMDevNeg_compViolSol
  = max(0, smax((l,k)$(not kBase(k) and lkActive(l,k)), lk_QUpSlack_VMDevNeg_compViolSol(l,k)));
max_ViolSol = max(
  max_jkVoltageMagnitudeLoViolSol,
  max_jkVoltageMagnitudeUpViolSol,
  max_lkRealPowerLoViolSol,
  max_lkRealPowerUpViolSol,
  max_lkReactivePowerLoViolSol,
  max_lkReactivePowerUpViolSol,
  max_jkRealPowerBalanceViolSol,
  max_jkReactivePowerBalanceViolSol,
  max_ikPowerMagOrigBoundViolSol,
  max_ikPowerMagDestBoundViolSol,
  max_ijjkVoltMagImpZeroViolSol,
  max_ijjkVoltAngImpZeroViolSol,
  max_ikRealPowerImpZeroViolSol,
  max_ijjkReactivePowerImpZeroViolSol,
  max_lk_QLoSlack_VMDevPos_compViolSol,
  max_lk_QUpSlack_VMDevNeg_compViolSol
);

* compute normalized summary values
max_jkVoltageMagnitudeLoViolNorm = max(0, smax((j,k), jkVoltageMagnitudeLoViolNorm(j,k)));
max_jkVoltageMagnitudeUpViolNorm = max(0, smax((j,k), jkVoltageMagnitudeUpViolNorm(j,k)));
max_lkRealPowerLoViolNorm = max(0, smax((l,k)$lkActive(l,k), lkRealPowerLoViolNorm(l,k)));
max_lkRealPowerUpViolNorm = max(0, smax((l,k)$lkActive(l,k), lkRealPowerUpViolNorm(l,k)));
max_lkReactivePowerLoViolNorm = max(0, smax((l,k)$lkActive(l,k), lkReactivePowerLoViolNorm(l,k)));
max_lkReactivePowerUpViolNorm = max(0, smax((l,k)$lkActive(l,k), lkReactivePowerUpViolNorm(l,k)));
max_jkRealPowerBalanceViolNorm = max(0, smax((j,k), jkRealPowerBalanceViolNorm(j,k)));
max_jkReactivePowerBalanceViolNorm = max(0, smax((j,k), jkReactivePowerBalanceViolNorm(j,k)));
max_ikPowerMagOrigBoundViolNorm = max(0, smax((i,k)$ikActive(i,k), ikPowerMagOrigBoundViolNorm(i,k)));
max_ikPowerMagDestBoundViolNorm = max(0, smax((i,k)$ikActive(i,k), ikPowerMagDestBoundViolNorm(i,k)));
max_ijjkVoltMagImpZeroViolNorm
  = max(0, smax((i,j1,j2,k)$(
                  iSeriesImpedanceZero(i) and ikActive(i,k) and ijOrigin(i,j1) and ijDestination(i,j2)),
	        ijjkVoltMagImpZeroViolNorm(i,j1,j2,k)));
max_ijjkVoltAngImpZeroViolNorm
  = max(0, smax((i,j1,j2,k)$(
                  iSeriesImpedanceZero(i) and ikActive(i,k) and ijOrigin(i,j1) and ijDestination(i,j2)),
	        ijjkVoltAngImpZeroViolNorm(i,j1,j2,k)));
max_ikRealPowerImpZeroViolNorm
  = max(0, smax((i,k)$(iSeriesImpedanceZero(i) and ikActive(i,k)),
                 ikRealPowerImpZeroViolNorm(i,k)));
max_ijjkReactivePowerImpZeroViolNorm
  = max(0, smax((i,j1,j2,k)$(
                  iSeriesImpedanceZero(i) and ikActive(i,k) and ijOrigin(i,j1) and ijDestination(i,j2)),
        	 ijjkReactivePowerImpZeroViolNorm(i,j1,j2,k)));
max_lk_QLoSlack_VMDevPos_compViolNorm
  = max(0, smax((l,k)$(not kBase(k) and lkActive(l,k)), lk_QLoSlack_VMDevPos_compViolNorm(l,k)));
max_lk_QUpSlack_VMDevNeg_compViolNorm
  = max(0, smax((l,k)$(not kBase(k) and lkActive(l,k)), lk_QUpSlack_VMDevNeg_compViolNorm(l,k)));
max_ViolNorm = max(
  max_jkVoltageMagnitudeLoViolNorm,
  max_jkVoltageMagnitudeUpViolNorm,
  max_lkRealPowerLoViolNorm,
  max_lkRealPowerUpViolNorm,
  max_lkReactivePowerLoViolNorm,
  max_lkReactivePowerUpViolNorm,
  max_jkRealPowerBalanceViolNorm,
  max_jkReactivePowerBalanceViolNorm,
  max_ikPowerMagOrigBoundViolNorm,
  max_ikPowerMagDestBoundViolNorm,
  max_ijjkVoltMagImpZeroViolNorm,
  max_ijjkVoltAngImpZeroViolNorm,
  max_ikRealPowerImpZeroViolNorm,
  max_ijjkReactivePowerImpZeroViolNorm,
  max_lk_QLoSlack_VMDevPos_compViolNorm,
  max_lk_QUpSlack_VMDevNeg_compViolNorm
);

* convert solution variables
* from units of the optimization model (p.u. generally)
* to units of the input and output files (physical generally)
* as in the input and output files,
* voltage magnitude remains p.u. and
* voltage angle is in degrees
* violation values should remain in p.u. as these are the units
* in which the evaluation code will compute the constraint violations
lkRealPowerSol(l,k)$lkActive(l,k) = baseMVA * lkRealPowerSol(l,k);
lkReactivePowerSol(l,k)$lkActive(l,k) = baseMVA * lkReactivePowerSol(l,k);
*jkVoltageMagnitudeSol(j,k)
jkVoltageAngleSol(j,k) = (180 / pi) * jkVoltageAngleSol(j,k);
jkShuntRealPowerSol(j,k) = baseMVA * jkShuntRealPowerSol(j,k);
jkShuntReactivePowerSol(j,k) = baseMVA * jkShuntReactivePowerSol(j,k);
ikRealPowerOriginSol(i,k)$ikActive(i,k) = baseMVA * ikRealPowerOriginSol(i,k);
ikReactivePowerOriginSol(i,k)$ikActive(i,k) = baseMVA * ikReactivePowerOriginSol(i,k);
ikRealPowerDestinationSol(i,k)$ikActive(i,k) = baseMVA * ikRealPowerDestinationSol(i,k);
ikReactivePowerDestinationSol(i,k)$ikActive(i,k) = baseMVA * ikReactivePowerDestinationSol(i,k);
kRealPowerShortfallSol(k)
  = baseMVA * kRealPowerShortfallSol(k)
  / sum(l1$lkActive(l1,k),lParticipationFactor(l1));

file sol3 /'solution3.txt'/;
put sol3;
sol3.nr = 2;
put '--summary' /;
put 'max norm viol all bnd/constr (1),' max_ViolNorm:0:10 /;
put 'max norm viol bus volt mag min (1),' max_jkVoltageMagnitudeLoViolNorm:0:10 /;
put 'max norm viol bus volt mag max (1),' max_jkVoltageMagnitudeUpViolNorm:0:10 /;
put 'max norm viol gen real power min (1),' max_lkRealPowerLoViolNorm:0:10 /;
put 'max norm viol gen real power max (1),' max_lkRealPowerUpViolNorm:0:10 /;
put 'max norm viol gen reactive power min (1),' max_lkReactivePowerLoViolNorm:0:10 /;
put 'max norm viol gen reactive power max (1),' max_lkReactivePowerUpViolNorm:0:10 /;
put 'max norm viol bus real power balance (1),' max_jkRealPowerBalanceViolNorm:0:10 /;
put 'max norm viol bus reactive power balance (1),' max_jkReactivePowerBalanceViolNorm:0:10 /;
put 'max norm viol branch power mag orig bound (1),' max_ikPowerMagOrigBoundViolNorm:0:10 /;
put 'max norm viol branch power mag dest bound (1),' max_ikPowerMagDestBoundViolNorm:0:10 /;
put 'max norm viol zero imped branch volt mag equ (1),' max_ijjkVoltMagImpZeroViolNorm:0:10 /;
put 'max norm viol zero imped branch volt ang equ (1),' max_ijjkVoltAngImpZeroViolNorm:0:10 /;
put 'max norm viol zero imped branch real power equ (1),' max_ikRealPowerImpZeroViolNorm:0:10 /;
put 'max norm viol zero imped branch reactive power equ (1),' max_ijjkReactivePowerImpZeroViolNorm:0:10 /;
put 'max norm viol gen reactive power lower slack . over voltage (1),' max_lk_QLoSlack_VMDevPos_compViolNorm:0:10 /;
put 'max norm viol gen reactive power upper slack . under voltage (1),' max_lk_QUpSlack_VMDevNeg_compViolNorm:0:10 /;
put 'max viol all bnd/constr (pu),' max_ViolSol:0:10 /;
put 'max viol bus volt mag min (pu),' max_jkVoltageMagnitudeLoViolSol:0:10 /;
put 'max viol bus volt mag max (pu),' max_jkVoltageMagnitudeUpViolSol:0:10 /;
put 'max viol gen real power min (pu),' max_lkRealPowerLoViolSol:0:10 /;
put 'max viol gen real power max (pu),' max_lkRealPowerUpViolSol:0:10 /;
put 'max viol gen reactive power min (pu),' max_lkReactivePowerLoViolSol:0:10 /;
put 'max viol gen reactive power max (pu),' max_lkReactivePowerUpViolSol:0:10 /;
put 'max viol bus real power balance (pu),' max_jkRealPowerBalanceViolSol:0:10 /;
put 'max viol bus reactive power balance (pu),' max_jkReactivePowerBalanceViolSol:0:10 /;
put 'max viol branch power mag orig bound (pu),' max_ikPowerMagOrigBoundViolSol:0:10 /;
put 'max viol branch power mag dest bound (pu),' max_ikPowerMagDestBoundViolSol:0:10 /;
put 'max viol zero imped branch volt mag equ (pu),' max_ijjkVoltMagImpZeroViolSol:0:10 /;
put 'max viol zero imped branch volt ang equ (pu),' max_ijjkVoltAngImpZeroViolSol:0:10 /;
put 'max viol zero imped branch real power equ (pu),' max_ikRealPowerImpZeroViolSol:0:10 /;
put 'max viol zero imped branch reactive power equ (pu),' max_ijjkReactivePowerImpZeroViolSol:0:10 /;
put 'max viol gen reactive power lower slack . over voltage (pu),' max_lk_QLoSlack_VMDevPos_compViolSol:0:10 /;
put 'max viol gen reactive power upper slack . under voltage (pu),' max_lk_QUpSlack_VMDevNeg_compViolSol:0:10 /;
put '--end of summary' /;
sol3.nr = 1;
put '--base generator' /;
put
  'genID,'
  'busID,'
  'unitID,'
  'p(MVA),'
  'q(MVA),'
  'pViolLo(pu),'
  'pViolUp(pu),'
  'qViolLo(pu),'
  'qViolUp(pu),'
  'pViolNormLo(1),'
  'pViolNormUp(1),'
  'qViolNormLo(1),'
  'qViolNormUp(1)' /;
loop(kBase(k),
  loop((l,j,u)$(lkActive(l,k) and ljMap(l,j) and luMap(l,u)),
    put
      l.tl:0 ','
      j.tl:0 ','
      u.tl:0 ','
      lkRealPowerSol(l,k):0:10 ','
      lkReactivePowerSol(l,k):0:10 ','
      lkRealPowerLoViolSol(l,k):0:10 ','
      lkRealPowerUpViolSol(l,k):0:10 ','
      lkReactivePowerLoViolSol(l,k):0:10 ','
      lkReactivePowerUpViolSol(l,k):0:10 ','
      lkRealPowerLoViolNorm(l,k):0:10 ','
      lkRealPowerUpViolNorm(l,k):0:10 ','
      lkReactivePowerLoViolNorm(l,k):0:10 ','
      lkReactivePowerUpViolNorm(l,k):0:10 /;
  );
);
put '--end of base generator' /;
put '--base bus' /;
put
  'busID,'
  'vMag(pu),'
  'vAng(deg),'
  'pShunt(MVA),'
  'qShunt(MVA),'
  'pBalViol(pu),'
  'qBalViol(pu),'
  'vMagViolLo(pu),'
  'vMagViolUp(pu),'
  'pBalViolNorm(1),'
  'qBalViolNorm(1),'
  'vMagViolNormLo(1),'
  'vMagViolNormUp(1)' /;
loop(kBase(k),
  loop(j,
    put
      j.tl:0 ','
      jkVoltageMagnitudeSol(j,k):0:10 ','
      jkVoltageAngleSol(j,k):0:10 ','
      jkShuntRealPowerSol(j,k):0:10 ','
      jkShuntReactivePowerSol(j,k):0:10 ','
      jkRealPowerBalanceViolSol(j,k):0:10 ','
      jkReactivePowerBalanceViolSol(j,k):0:10 ','
      jkVoltageMagnitudeLoViolSol(j,k):0:10 ','
      jkVoltageMagnitudeUpViolSol(j,k):0:10 ','
      jkRealPowerBalanceViolNorm(j,k):0:10 ','
      jkReactivePowerBalanceViolNorm(j,k):0:10 ','
      jkVoltageMagnitudeLoViolNorm(j,k):0:10 ','
      jkVoltageMagnitudeUpViolNorm(j,k):0:10 /;
  );
);
put '--end of base bus' /;
put '--base branch' /;
put
  'brID,'
  'origBusID,'
  'destBusID,'
  'circID,'
  'pOrig(MVA),'
  'qOrig(MVA),'
  'pDest(MVA),'
  'qDest(MVA),'
  'sOrigViol(pu),'
  'sDestViol(pu),'
  'zVMagViol(pu),'
  'zVAngViol(rad),'
  'zPViol(pu),'
  'zQViol(pu),'
  'sOrigViolNorm(1),'
  'sDestViolNorm(1),'
  'zVMagViolNorm(1),'
  'zVAngViolNorm(1),'
  'zPViolNorm(1),'
  'zQViolNorm(1)' /;
loop(kBase(k),
  loop((i,j1,j2,c)$(ikActive(i,k) and ijOrigin(i,j1) and ijDestination(i,j2) and icMap(i,c)),
    put
      i.tl:0 ','
      j1.tl:0 ','
      j2.tl:0 ','
      c.tl:0 ','
      ikRealPowerOriginSol(i,k):0:10 ','
      ikReactivePowerOriginSol(i,k):0:10 ','
      ikRealPowerDestinationSol(i,k):0:10 ','
      ikReactivePowerDestinationSol(i,k):0:10 ','
      ikPowerMagOrigBoundViolSol(i,k):0:10 ','
      ikPowerMagDestBoundViolSol(i,k):0:10 ','
      ijjkVoltMagImpZeroViolSol(i,j1,j2,k):0:10 ','
      ijjkVoltAngImpZeroViolSol(i,j1,j2,k):0:10 ','
      ikRealPowerImpZeroViolSol(i,k):0:10 ','
      ijjkReactivePowerImpZeroViolSol(i,j1,j2,k):0:10 ','
      ikPowerMagOrigBoundViolNorm(i,k):0:10 ','
      ikPowerMagDestBoundViolNorm(i,k):0:10 ','
      ijjkVoltMagImpZeroViolNorm(i,j1,j2,k):0:10 ','
      ijjkVoltAngImpZeroViolNorm(i,j1,j2,k):0:10 ','
      ikRealPowerImpZeroViolNorm(i,k):0:10 ','
      ijjkReactivePowerImpZeroViolNorm(i,j1,j2,k):0:10 /;
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
    kRealPowerShortfallSol(k):0:10 /;
);
put '--end of contingency delta' /;
put '--contingency generator' /;
* TODO: put in complementarity violations
put
  'conID,'
  'genID,'
  'busID,'
  'unitID,'
  'p(MVA),'
  'q(MVA),'
  'pViolLo(pu),'
  'pViolUp(pu),'
  'qViolLo(pu),'
  'qViolUp(pu),'
  'qLoSlackVMagDevPosCompViol(pu),'
  'qUpSlackVMagDevNegCompViol(pu),'
  'pViolNormLo(1),'
  'pViolNormUp(1),'
  'qViolNormLo(1),'
  'qViolNormUp(1),'
  'qLoSlackVMagDevPosCompViolNorm(1),'
  'qUpSlackVMagDevNegCompViolNorm(1)' /;
loop(k$(not kBase(k)),
  loop((l,j,u)$(lkActive(l,k) and ljMap(l,j) and luMap(l,u)),
    put
      k.tl:0 ','
      l.tl:0 ','
      j.tl:0 ','
      u.tl:0 ','
      lkRealPowerSol(l,k):0:10 ','
      lkReactivePowerSol(l,k):0:10 ','
      lkRealPowerLoViolSol(l,k):0:10 ','
      lkRealPowerUpViolSol(l,k):0:10 ','
      lkReactivePowerLoViolSol(l,k):0:10 ','
      lkReactivePowerUpViolSol(l,k):0:10 ','
      lk_QLoSlack_VMDevPos_compViolSol(l,k):0:10 ','
      lk_QUpSlack_VMDevNeg_compViolSol(l,k):0:10 ','
      lkRealPowerLoViolNorm(l,k):0:10 ','
      lkRealPowerUpViolNorm(l,k):0:10 ','
      lkReactivePowerLoViolNorm(l,k):0:10 ','
      lkReactivePowerUpViolNorm(l,k):0:10 ','
      lk_QLoSlack_VMDevPos_compViolNorm(l,k):0:10 ','
      lk_QUpSlack_VMDevNeg_compViolNorm(l,k):0:10 /;
  );
);
put '--end of contingency generator' /;
put '--contingency bus' /;
put
  'conID,'
  'busID,'
  'vMag(pu),'
  'vAng(deg),'
  'pShunt(MVA),'
  'qShunt(MVA),'
  'pBalViol(pu),'
  'qBalViol(pu),'
  'vMagViolLo(pu),'
  'vMagViolUp(pu),'
  'pBalViolNorm(1),'
  'qBalViolNorm(1),'
  'vMagViolNormLo(1),'
  'vMagViolNormUp(1)' /;
loop(k$(not kBase(k)),
  loop(j,
    put
      k.tl:0 ','
      j.tl:0 ','
      jkVoltageMagnitudeSol(j,k):0:10 ','
      jkVoltageAngleSol(j,k):0:10 ','
      jkShuntRealPowerSol(j,k):0:10 ','
      jkShuntReactivePowerSol(j,k):0:10 ','
      jkRealPowerBalanceViolSol(j,k):0:10 ','
      jkReactivePowerBalanceViolSol(j,k):0:10 ','
      jkVoltageMagnitudeLoViolSol(j,k):0:10 ','
      jkVoltageMagnitudeUpViolSol(j,k):0:10 ','
      jkRealPowerBalanceViolNorm(j,k):0:10 ','
      jkReactivePowerBalanceViolNorm(j,k):0:10 ','
      jkVoltageMagnitudeLoViolNorm(j,k):0:10 ','
      jkVoltageMagnitudeUpViolNorm(j,k):0:10 /;
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
  'pOrig(MVA),'
  'qOrig(MVA),'
  'pDest(MVA),'
  'qDest(MVA),'
  'sOrigViol(pu),'
  'sDestViol(pu),'
  'zVMagViol(pu),'
  'zVAngViol(rad),'
  'zPViol(pu),'
  'zQViol(pu),'
  'sOrigViolNorm(1),'
  'sDestViolNorm(1),'
  'zVMagViolNorm(1),'
  'zVAngViolNorm(1),'
  'zPViolNorm(1),'
  'zQViolNorm(1)' /;
loop(k$(not kBase(k)),
  loop((i,j1,j2,c)$(ikActive(i,k) and ijOrigin(i,j1) and ijDestination(i,j2) and icMap(i,c)),
    put
      k.tl:0 ','
      i.tl:0 ','
      j1.tl:0 ','
      j2.tl:0 ','
      c.tl:0 ','
      ikRealPowerOriginSol(i,k):0:10 ','
      ikReactivePowerOriginSol(i,k):0:10 ','
      ikRealPowerDestinationSol(i,k):0:10 ','
      ikReactivePowerDestinationSol(i,k):0:10 ','
      ikPowerMagOrigBoundViolSol(i,k):0:10 ','
      ikPowerMagDestBoundViolSol(i,k):0:10 ','
      ijjkVoltMagImpZeroViolSol(i,j1,j2,k):0:10 ','
      ijjkVoltAngImpZeroViolSol(i,j1,j2,k):0:10 ','
      ikRealPowerImpZeroViolSol(i,k):0:10 ','
      ijjkReactivePowerImpZeroViolSol(i,j1,j2,k):0:10 ','
      ikPowerMagOrigBoundViolNorm(i,k):0:10 ','
      ikPowerMagDestBoundViolNorm(i,k):0:10 ','
      ijjkVoltMagImpZeroViolNorm(i,j1,j2,k):0:10 ','
      ijjkVoltAngImpZeroViolNorm(i,j1,j2,k):0:10 ','
      ikRealPowerImpZeroViolNorm(i,k):0:10 ','
      ijjkReactivePowerImpZeroViolNorm(i,j1,j2,k):0:10 /;
  );
);
put '--end of contingency branch' /;
*$ontext
* debugging output
put '--contingency bus debug' /;
put
  'conID,'
  'busID,'
  'qLoad(pu),'
  'qBalViol(pu),'
  'qBalViolNorm(1)' /
loop(k,
  loop(j,
    if(jkReactivePowerBalanceViolSol(j,k) > 0,
      put
        k.tl:0 ','
        j.tl:0 ','
        jReactivePowerDemand(j):0:10 ','
        jkReactivePowerBalanceViolSol(j,k):0:10 ','
        jkReactivePowerBalanceViolNorm(j,k):0:10 /;
    );
  );
);
put '--end of contingency bus' /;
* end debugging output
*$offtext
putclose;
  