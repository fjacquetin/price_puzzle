function [lhs, rhs] = dynamic_resid(y, x, params, steady_state)
T = NaN(1, 1);
lhs = NaN(5, 1);
rhs = NaN(5, 1);
T(1) = 1/params(4);
lhs(1) = y(6);
rhs(1) = y(11)-T(1)*(y(8)-y(12)-params(10)*(y(14)-y(9)));
lhs(2) = y(7);
rhs(2) = y(12)*params(1)+y(6)*(params(4)+params(3))*(1-params(2))*(1-params(1)*params(2))/params(2);
lhs(3) = y(8);
rhs(3) = y(6)*params(6)+y(7)*params(5)+y(10);
lhs(4) = y(9);
rhs(4) = params(7)*y(4)+x(1);
lhs(5) = y(10);
rhs(5) = params(8)*y(5)+x(2);
end
