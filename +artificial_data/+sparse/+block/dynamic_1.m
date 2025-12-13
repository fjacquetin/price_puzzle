function [y, T] = dynamic_1(y, x, params, steady_state, sparse_rowval, sparse_colval, sparse_colptr, T)
  y(13)=0.7*y(4)+x(1);
  y(14)=0.3*y(5)+x(2);
  y(15)=0.7*y(6)+x(3);
end
