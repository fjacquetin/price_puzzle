function [residual, T_order, T] = static_resid(y, x, params, T_order, T)
if nargin < 5
    T_order = -1;
    T = NaN(0, 1);
end
[T_order, T] = artificial_data.sparse.static_resid_tt(y, x, params, T_order, T);
residual = NaN(9, 1);
    residual(1) = (y(1)) - (y(1)-(y(3)-y(2))+y(4));
    residual(2) = (y(2)) - (y(2)*0.99+0.1*(y(1)-y(6)));
    residual(3) = (y(3)) - (y(3)*0.5+0.5*(0.1*(y(1)-y(6))+y(2)*1.5)+y(5));
    residual(4) = (y(4)) - (y(4)*0.7+x(1));
    residual(5) = (y(5)) - (y(5)*0.3+x(2));
    residual(6) = (y(6)) - (y(6)*0.7+x(3));
    residual(7) = (y(7)) - (y(1)*100+x(4));
    residual(8) = (y(8)) - (y(2)*400+x(5));
    residual(9) = (y(9)) - (y(3)*400+x(6));
end
