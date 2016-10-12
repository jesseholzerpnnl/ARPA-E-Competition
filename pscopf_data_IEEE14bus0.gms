parameters BaseMVA /
  100.0
/;
set circuits(*) /
  "'BL'"
/;
set branches(*) /
  i_1
  i_2
  i_3
  i_4
  i_5
  i_6
  i_7
  i_8
  i_9
  i_10
  i_11
  i_12
  i_13
  i_14
  i_15
  i_16
  i_17
  i_18
  i_19
  i_20
/;
set buses(*) /
  12
  2
  3
  13
  5
  10
  4
  6
  11
  7
  14
  1
  8
  9
/;
set contingencies(*) /
  1
/;
set generators(*) /
  l_1
  l_2
  l_3
  l_4
  l_5
/;
set polynomialCostTerms(*) /
  m_0
  m_1
  m_2
/;
set units(*) /
  "'1 '"
/;
alias(circuits,c);
alias(branches,i);
alias(buses,j);
alias(contingencies,k);
alias(generators,l);
alias(polynomialCostTerms,m);
alias(units,u);
set ijOrigin(i,j) /
  i_1.9
  i_2.3
  i_3.6
  i_4.6
  i_5.1
  i_6.2
  i_7.10
  i_8.2
  i_9.4
  i_10.7
  i_11.9
  i_12.1
  i_13.13
  i_14.7
  i_15.12
  i_16.2
  i_17.6
  i_18.4
  i_19.4
  i_20.5
/;
set ijDestination(i,j) /
  i_1.14
  i_2.4
  i_3.11
  i_4.13
  i_5.5
  i_6.4
  i_7.11
  i_8.3
  i_9.5
  i_10.8
  i_11.10
  i_12.2
  i_13.14
  i_14.9
  i_15.13
  i_16.5
  i_17.12
  i_18.9
  i_19.7
  i_20.6
/;
set icMap(i,c) /
  i_1."'BL'"
  i_2."'BL'"
  i_3."'BL'"
  i_4."'BL'"
  i_5."'BL'"
  i_6."'BL'"
  i_7."'BL'"
  i_8."'BL'"
  i_9."'BL'"
  i_10."'BL'"
  i_11."'BL'"
  i_12."'BL'"
  i_13."'BL'"
  i_14."'BL'"
  i_15."'BL'"
  i_16."'BL'"
  i_17."'BL'"
  i_18."'BL'"
  i_19."'BL'"
  i_20."'BL'"
/;
set ljMap(l,j) /
  l_1.6
  l_2.2
  l_3.8
  l_4.1
  l_5.3
/;
set luMap(l,u) /
  l_1."'1 '"
  l_2."'1 '"
  l_3."'1 '"
  l_4."'1 '"
  l_5."'1 '"
/;
set ikInactive(i,k) /
  i_18.1
/;
set lkInactive(l,k) /
/;
parameter jBaseKV(j) /
  12         100.0
  2         100.0
  3         100.0
  13         100.0
  5         100.0
  10         100.0
  4         100.0
  6         100.0
  11         100.0
  7         100.0
  14         100.0
  1         100.0
  8         100.0
  9         100.0
/;
parameter jShuntConductance(j) /
  12         0.0
  2         0.0
  3         0.0
  13         0.0
  5         0.0
  10         0.0
  4         0.0
  6         0.0
  11         0.0
  7         0.0
  14         0.0
  1         0.0
  8         0.0
  9         0.0
/;
parameter jShuntSusceptance(j) /
  12         0.0
  2         0.0
  3         0.0
  13         0.0
  5         0.0
  10         0.0
  4         0.0
  6         0.0
  11         0.0
  7         0.0
  14         0.0
  1         0.0
  8         0.0
  9         19.0
/;
parameter jVoltageMagnitudeMin(j) /
  12         0.9
  2         0.9
  3         0.9
  13         0.9
  5         0.9
  10         0.9
  4         0.9
  6         0.9
  11         0.9
  7         0.9
  14         0.9
  1         0.9
  8         0.9
  9         0.9
/;
parameter jVoltageMagnitudeMax(j) /
  12         1.1
  2         1.1
  3         1.1
  13         1.1
  5         1.1
  10         1.1
  4         1.1
  6         1.1
  11         1.1
  7         1.1
  14         1.1
  1         1.1
  8         1.1
  9         1.1
/;
parameter jRealPowerDemand(j) /
  12         6.1
  2         21.7
  3         94.2
  13         13.5
  5         7.6
  10         9.0
  4         47.8
  6         11.2
  11         3.5
  7         0.0
  14         14.9
  1         0.0
  8         0.0
  9         29.5
/;
parameter jReactivePowerDemand(j) /
  12         1.6
  2         12.7
  3         19.0
  13         5.8
  5         1.6
  10         5.8
  4         -3.9
  6         7.5
  11         1.8
  7         0.0
  14         5.0
  1         0.0
  8         0.0
  9         16.6
/;
parameter iSeriesResistance(i) /
  i_1         0.12711
  i_2         0.06701
  i_3         0.09498
  i_4         0.06615
  i_5         0.05403
  i_6         0.05811
  i_7         0.08205
  i_8         0.04699
  i_9         0.01335
  i_10         0.0
  i_11         0.03181
  i_12         0.01938
  i_13         0.17093
  i_14         0.0
  i_15         0.22092
  i_16         0.05695
  i_17         0.12291
  i_18         0.0
  i_19         0.0
  i_20         0.0
/;
parameter iSeriesReactance(i) /
  i_1         0.27038
  i_2         0.17103
  i_3         0.1989
  i_4         0.13027
  i_5         0.22304
  i_6         0.17632
  i_7         0.19207
  i_8         0.19797
  i_9         0.04211
  i_10         0.17615
  i_11         0.0845
  i_12         0.05917
  i_13         0.34802
  i_14         0.11001
  i_15         0.19988
  i_16         0.17388
  i_17         0.25581
  i_18         0.55618
  i_19         0.20912
  i_20         0.25202
/;
parameter iChargingSusceptance(i) /
  i_1         0.0
  i_2         0.0128
  i_3         0.0
  i_4         0.0
  i_5         0.0492
  i_6         0.034
  i_7         0.0
  i_8         0.0438
  i_9         0.0
  i_10         0.0
  i_11         0.0
  i_12         0.0528
  i_13         0.0
  i_14         0.0
  i_15         0.0
  i_16         0.0346
  i_17         0.0
  i_18         0.0
  i_19         0.0
  i_20         0.0
/;
parameter iTapRatio(i) /
  i_1         1.0
  i_2         1.0
  i_3         1.0
  i_4         1.0
  i_5         1.0
  i_6         1.0
  i_7         1.0
  i_8         1.0
  i_9         1.0
  i_10         1.0
  i_11         1.0
  i_12         1.0
  i_13         1.0
  i_14         1.0
  i_15         1.0
  i_16         1.0
  i_17         1.0
  i_18         0.969
  i_19         0.978
  i_20         0.932
/;
parameter iPhaseShift(i) /
  i_1         0.0
  i_2         0.0
  i_3         0.0
  i_4         0.0
  i_5         0.0
  i_6         0.0
  i_7         0.0
  i_8         0.0
  i_9         0.0
  i_10         0.0
  i_11         0.0
  i_12         0.0
  i_13         0.0
  i_14         0.0
  i_15         0.0
  i_16         0.0
  i_17         0.0
  i_18         0.0
  i_19         0.0
  i_20         0.0
/;
parameter iPowerMagnitudeMax(i) /
  i_1         0.0
  i_2         0.0
  i_3         0.0
  i_4         0.0
  i_5         0.0
  i_6         0.0
  i_7         0.0
  i_8         0.0
  i_9         0.0
  i_10         0.0
  i_11         0.0
  i_12         0.0
  i_13         0.0
  i_14         0.0
  i_15         0.0
  i_16         0.0
  i_17         0.0
  i_18         9999.0
  i_19         9999.0
  i_20         9999.0
/;
parameter lRealPowerMin(l) /
  l_1         0.0
  l_2         0.0
  l_3         0.0
  l_4         0.0
  l_5         0.0
/;
parameter lRealPowerMax(l) /
  l_1         0.0
  l_2         0.0
  l_3         0.0
  l_4         0.0
  l_5         0.0
/;
parameter lReactivePowerMin(l) /
  l_1         -6.0
  l_2         -40.0
  l_3         -6.0
  l_4         -9999.0
  l_5         0.0
/;
parameter lReactivePowerMax(l) /
  l_1         24.0
  l_2         50.0
  l_3         24.0
  l_4         99990.002
  l_5         40.0
/;
parameter lmRealPowerCostCoefficient(l,m) /
  l_1.m_0         92.88
  l_1.m_1         4.86711941
  l_1.m_2         0.001861248
  l_2.m_0         67.9
  l_2.m_1         5.275836689
  l_2.m_2         0.013475833
  l_3.m_0         243.3333333
  l_3.m_1         163.6181252
  l_3.m_2         1.974646976
  l_4.m_0         1375.9
  l_4.m_1         140.3842614
  l_4.m_2         2.082286932
  l_5.m_0         2576.52
  l_5.m_1         143.3363115
  l_5.m_2         0.049040857
/;
parameter lmRealPowerCostExponent(l,m) /
  l_1.m_0         0.0
  l_1.m_1         1.0
  l_1.m_2         2.0
  l_2.m_0         0.0
  l_2.m_1         1.0
  l_2.m_2         2.0
  l_3.m_0         0.0
  l_3.m_1         1.0
  l_3.m_2         2.0
  l_4.m_0         0.0
  l_4.m_1         1.0
  l_4.m_2         2.0
  l_5.m_0         0.0
  l_5.m_1         1.0
  l_5.m_2         2.0
/;
parameter lParticipationFactor(l) /
  l_1         38.75
  l_2         19.0
  l_3         3.0
  l_4         5.0
  l_5         49.25
/;
