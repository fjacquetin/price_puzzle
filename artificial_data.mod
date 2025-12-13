var x pi int a b c x_obs pi_obs int_obs;
varexo ea eb ec ex epi eint;

model(linear);

// NK core
x  = x(+1) - (int - pi(+1)) + a;
pi = 0.99*pi(+1) + 0.1*(x - c);
int = 0.5*int(-1)
    + 0.5*(1.5*pi(+1) + 0.1*(x - c))
    + b;

a = 0.7*a(-1) + ea;
b = 0.3*b(-1) + eb;
c = 0.7*c(-1) + ec;

// Measurement equations (NO CONSTANTS)
x_obs   = 100*x   + ex;
pi_obs  = 400*pi  + epi;
int_obs = 400*int + eint;

end;

initval;
x=0; pi=0; int=0; a=0; b=0; c=0;
x_obs=0; pi_obs=0; int_obs=0;
end;

shocks;
  var ea;   stderr 0.20;
  var eb;   stderr 0.20;
  var ec;   stderr 0.14;

  var ex;   stderr 0.50;
  var epi;  stderr 0.30;
  var eint; stderr 0.30;
end;

check;
stoch_simul(order=1, periods=200, nograph)
            x_obs pi_obs int_obs;
