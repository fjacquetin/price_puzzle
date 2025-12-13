function g1 = static_g1(T, y, x, params, T_flag)
% function g1 = static_g1(T, y, x, params, T_flag)
%
% File created by Dynare Preprocessor from .mod file
%
% Inputs:
%   T         [#temp variables by 1]  double   vector of temporary terms to be filled by function
%   y         [M_.endo_nbr by 1]      double   vector of endogenous variables in declaration order
%   x         [M_.exo_nbr by 1]       double   vector of exogenous variables in declaration order
%   params    [M_.param_nbr by 1]     double   vector of parameter values in declaration order
%                                              to evaluate the model
%   T_flag    boolean                 boolean  flag saying whether or not to calculate temporary terms
%
% Output:
%   g1
%

if T_flag
    T = artificial_data.static_g1_tt(T, y, x, params);
end
g1 = zeros(9, 9);
g1(1,2)=(-1);
g1(1,3)=1;
g1(1,4)=(-1);
g1(2,1)=(-0.1);
g1(2,2)=0.01000000000000001;
g1(2,6)=0.1;
g1(3,1)=(-0.05);
g1(3,2)=(-0.75);
g1(3,3)=0.5;
g1(3,5)=(-1);
g1(3,6)=0.05;
g1(4,4)=0.3;
g1(5,5)=0.7;
g1(6,6)=0.3;
g1(7,1)=(-100);
g1(7,7)=1;
g1(8,2)=(-400);
g1(8,8)=1;
g1(9,3)=(-400);
g1(9,9)=1;

end
