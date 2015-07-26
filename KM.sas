%let seed = 8787;
%let recordCount = 100;
%let censorProportion = 0.30;

data randomdata;
   
  * set seed for the two rand() functions;
  call streaminit(&seed.);

  do i = 1 to &recordCount.;
    
    * generate random numbers from a Weibull dist;
    * shape=1, scale=2;
    t = rand("WEIBULL", 1, 2);
    
    * scale the random numbers and round them off to an even month;
    t = round(t* 12);
    
    * intialize censor as zero, overwrite to 1 when censor threshold met;
    censor = 0;
    randCensor = rand("UNIFORM");
    if randCensor < &censorProportion. then censor = 1;
        
    output;    
           
  end;
  
run;

ods trace on;
proc lifetest data=randomdata 
              plots=survival(cl) /*cb=hw for Hall-Wellner*/
              outsurv=KMoutput;

  time t*censor(1);
  title ’Account Lifespan’;

run;
ods trace off;

data KMoutput;
 set KMoutput;
 
 impliedRepetition = t - lag(t);
 lagSURVIVAL = lag(SURVIVAL);
 
 auc = lagSURVIVAL * impliedRepetition;

run;

proc print data=KMoutput;
run;

proc means sum data=KMoutput;
var auc;
run;

