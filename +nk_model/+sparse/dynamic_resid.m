function [residual, T_order, T] = dynamic_resid(y, x, params, steady_state, T_order, T)
if nargin < 6
    T_order = -1;
    T = NaN(0, 1);
end
[T_order, T] = nk_model.sparse.dynamic_resid_tt(y, x, params, steady_state, T_order, T);
residual = NaN(9, 1);
    residual(1) = (y(10)) - (y(19)-params(2)*(y(12)-y(20))+y(13));
    residual(2) = (y(11)) - (y(20)*params(1)+params(3)*(y(10)-y(15)));
    residual(3) = (y(12)) - (params(6)*y(3)+(1-params(6))*(y(20)*params(4)+(y(10)-y(15))*params(5))+y(14));
    residual(4) = (y(13)) - (params(7)*y(4)+x(1));
    residual(5) = (y(14)) - (params(8)*y(5)+x(2));
    residual(6) = (y(15)) - (params(9)*y(6)+x(3));
    residual(7) = (y(16)) - (y(10)*100+x(4));
    residual(8) = (y(17)) - (y(11)*400+x(5));
    residual(9) = (y(18)) - (y(12)*400+x(6));
end
