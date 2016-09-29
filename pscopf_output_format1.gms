$title pscopf_output_format1
$ontext
Official competition output format
$offtext

$if not set outputfilename1 $set outputfilename1 'out1.txt'
file outputfile1 /'%outputfilename1%'/;
*outputfile.nw = 0;
*outputfile.nr = 3;
*outputfile.nd = 6;
put outputfile1;
put '--performance' /;
put 'time(s),objective value' /;
put timeelapsed:0:10 ',' cost.l:0:10 /;
put '--end of performance' /;
put '--generation dispatch' /;
put 'bus id,unit id,pg(mw),qg(mvar)' /;
loop(kBase(k),
  loop((l,j,u)$(ljMap(l,j) and luMap(l,u)),
    put j.tl:0 ',' u.tl:0 ',' lkRealPower.l(l,k):0:10 ',' lkReactivePower.l(l,k):0:10 /;
  );
);
put '--end of generation dispatch' /;
put '--pqvo' /;
put 'contingency id,bus id,p(mw),q(mvar),v(kv),theta(radians)' /;
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
put 'contingency id,Delta' /;
loop(k$(not kBase(k)),
  put k.tl:0 ',' kRealPowerShortfall.l(k):0:10 /;
);
put '--end of Delta' /;
putclose outputfile1;