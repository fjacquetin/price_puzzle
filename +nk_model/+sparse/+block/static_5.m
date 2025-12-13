function [y, T] = static_5(y, x, params, sparse_rowval, sparse_colval, sparse_colptr, T)
  y(9)=y(3)*400+x(6);
  y(8)=y(2)*400+x(5);
  y(7)=y(1)*100+x(4);
end
