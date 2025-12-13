// =====================================================================
// New Keynesian Model (Clarida–Gali–Gertler / Woodford style)
// With cost-push shock + measurement equations for realistic observables
// IRFs + (optional) simulation
// =====================================================================

// Endogenous variables (model)
var x pi int a b c
    x_obs pi_obs int_obs;   // observed / interpretable series

// Exogenous shocks (structural + measurement)
varexo ea eb ec ex epi eint;

// =====================================================================
// Parameters
parameters beta chi kappa phipi phix rhoR rhoa rhob rhoc
           sig_a sig_b sig_c sig_xm sig_pim sig_im;

// Discount factor
beta  = 0.99;

// IS curve slope
chi   = 1;

// Phillips curve slope
kappa = 0.1;

// Taylor rule
phipi = 1.5;
phix  = 0.5;
rhoR  = 0.2;

// AR(1) shock processes
rhoa  = 0.7;
rhob  = 0.7;
rhoc  = 0.7;

// Std deviations (STRUCTURAL shocks)  << réalistes (à ajuster)
sig_a = 0.20;   // demand
sig_b = 0.20;   // monetary policy
sig_c = 0.14;   // cost-push

// Std deviations (MEASUREMENT noise)  << décorrèle et rend “moins propre”
sig_xm  = 0.50; // output gap noise, in percentage points
sig_pim = 0.30; // inflation noise, in annualized pp
sig_im  = 0.30; // rate noise, in annualized pp

// =====================================================================
// LINEARIZED NK Model
model(linear);

// (1) Dynamic IS equation
x = x(+1) - chi * (int - pi(+1)) + a;

// (2) NK Phillips curve with cost–push shock
pi = beta * pi(+1) + kappa * (x - c);

// (3) Taylor rule with smoothing and cost–push term
int = rhoR * int(-1)
      + (1 - rhoR) * ( phipi*pi(+1) + phix*(x - c) )
      + b;

// (4)-(6) Shock processes
a = rhoa * a(-1) + ea;
b = rhob * b(-1) + eb;
c = rhoc * c(-1) + ec;

// --- Measurement equations (NO CONSTANTS in linear model) ---
// x_obs: output gap in %
// pi_obs: inflation annualized in %
// int_obs: nominal rate annualized in %
x_obs   = 100*x   + ex;
pi_obs  = 400*pi  + epi;
int_obs = 400*int + eint;

end;

// =====================================================================
// Steady state (all deviations = 0)
initval;
  x = 0; pi = 0; int = 0;
  a = 0; b = 0; c = 0;
  x_obs = 0; pi_obs = 0; int_obs = 0;
end;

steady;
check;

// =====================================================================
// Shock definitions
shocks;
  // Structural shocks
  var ea; stderr sig_a;
  var eb; stderr sig_b;
  var ec; stderr sig_c;

  // Measurement shocks
  var ex;   stderr sig_xm;
  var epi;  stderr sig_pim;
  var eint; stderr sig_im;
end;

// =====================================================================
// IRFs (12 periods) — include observables, and optionally core vars too
stoch_simul(order=1, irf=12)
            x pi int x_obs pi_obs int_obs;
