function [y, T, residual, g1] = static_4(y, x, params, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(3, 1);
  residual(1)=(y(1))-(y(1)-(y(3)-y(2))+y(4));
  residual(2)=(y(2))-(y(2)*0.99+0.1*(y(1)-y(6)));
  residual(3)=(y(3))-(y(3)*0.5+0.5*(0.1*(y(1)-y(6))+y(2)*1.5)+y(5));
if nargout > 3
    g1_v = NaN(7, 1);
g1_v(1)=1;
g1_v(2)=0.5;
g1_v(3)=(-0.1);
g1_v(4)=(-0.05);
g1_v(5)=(-1);
g1_v(6)=0.01000000000000001;
g1_v(7)=(-0.75);
    if ~isoctave && matlab_ver_less_than('9.8')
        sparse_rowval = double(sparse_rowval);
        sparse_colval = double(sparse_colval);
    end
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 3, 3);
end
end
