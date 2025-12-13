function [y, T, residual, g1] = dynamic_2(y, x, params, steady_state, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(3, 1);
  residual(1)=(y(10))-(y(19)-(y(12)-y(20))+y(13));
  residual(2)=(y(11))-(y(20)*0.99+0.1*(y(10)-y(15)));
  residual(3)=(y(12))-(0.5*y(3)+0.5*(0.1*(y(10)-y(15))+y(20)*1.5)+y(14));
if nargout > 3
    g1_v = NaN(11, 1);
g1_v(1)=(-0.5);
g1_v(2)=1;
g1_v(3)=1;
g1_v(4)=1;
g1_v(5)=1;
g1_v(6)=(-0.1);
g1_v(7)=(-0.05);
g1_v(8)=(-1);
g1_v(9)=(-0.99);
g1_v(10)=(-0.75);
g1_v(11)=(-1);
    if ~isoctave && matlab_ver_less_than('9.8')
        sparse_rowval = double(sparse_rowval);
        sparse_colval = double(sparse_colval);
    end
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 3, 9);
end
end
