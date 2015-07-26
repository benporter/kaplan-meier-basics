libname shared '/folders/myshortcuts/mysharedfolder';

data shared.randomdata;
 set work.randomdata;
run;

data shared.KMoutput;
 set work.KMoutput;
run;
