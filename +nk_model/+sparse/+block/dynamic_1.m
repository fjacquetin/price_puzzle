function [y, T] = dynamic_1(y, x, params, steady_state, sparse_rowval, sparse_colval, sparse_colptr, T)
  y(9)=params(7)*y(4)+x(1);
  y(10)=params(8)*y(5)+x(2);
end
