function [y, T] = dynamic_1(y, x, params, steady_state, sparse_rowval, sparse_colval, sparse_colptr, T)
  y(13)=params(7)*y(4)+x(1);
  y(14)=params(8)*y(5)+x(2);
  y(15)=params(9)*y(6)+x(3);
end
