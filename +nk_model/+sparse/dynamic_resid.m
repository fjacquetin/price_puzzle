function [residual, T_order, T] = dynamic_resid(y, x, params, steady_state, T_order, T)
if nargin < 6
    T_order = -1;
    T = NaN(1, 1);
end
[T_order, T] = nk_model.sparse.dynamic_resid_tt(y, x, params, steady_state, T_order, T);
residual = NaN(5, 1);
    residual(1) = (y(6)) - (y(11)-T(1)*(y(8)-y(12)-params(10)*(y(14)-y(9))));
    residual(2) = (y(7)) - (y(12)*params(1)+y(6)*(params(4)+params(3))*(1-params(2))*(1-params(1)*params(2))/params(2));
    residual(3) = (y(8)) - (y(6)*params(6)+y(7)*params(5)+y(10));
    residual(4) = (y(9)) - (params(7)*y(4)+x(1));
    residual(5) = (y(10)) - (params(8)*y(5)+x(2));
end
