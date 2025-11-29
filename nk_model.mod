// NK model
// Florian Jacquetin and Loman Sezestre
//=============================================================

// Endogenous variables
var x pi int a b;

//=============================================================

// Exogenous variables
varexo ea eb;

//=============================================================

// First list the parameters and then assign them a value
parameters bet alph phi sig phipi phix rhoa rhob kappa mu;

// Structural parameters
bet   = 0.99; 
alph  = 0.75; 
phi   = 1; 
sig   = 1; 
phipi = 1.5;
phix  = 0.;  
// composite
mu    = sig* (1 + phi) / (sig + phi);

// Autoregressive parameters
rhoa = 0.9; 
rhob = 0.4;


// Declaration of the model - take the linear for (after log linearization): 

   
model(linear);
// Dynamic IS equation
x   = x(+1) - 1/sig * (int - pi(+1) -  mu * (a(+1)-a)  ) ;

// New Keynesian Phillips curve
pi  = bet * pi(+1) + ((phi+sig) * (1- alph) * (1-alph * bet) / alph ) * x;

// Monetary policy rule
int = phix * x + phipi * pi + b;

// Technology shock
a   = rhoa * a(-1) + ea; 

// Monetary Policy Shock
b = rhob * b(-1) + eb;

end;

//=============================================================
// Check the steady state

steady;
check;

//================================================
// Define the shocks and their variability

shocks;
var ea;  stderr 1;
var eb; stderr 1;
end;

//================================================
// Solve the model with the shocks introduced

stoch_simul(order=1, irf=12);