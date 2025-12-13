function [y, T] = dynamic_3(y, x, params, steady_state, sparse_rowval, sparse_colval, sparse_colptr, T)
  y(18)=y(12)*400+x(6);
  y(17)=y(11)*400+x(5);
  y(16)=y(10)*100+x(4);
end
