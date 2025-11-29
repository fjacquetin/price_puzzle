function [y, T, residual, g1] = dynamic_2(y, x, params, steady_state, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(2, 1);
  y(8)=y(6)*params(6)+y(7)*params(5)+y(10);
  residual(1)=(y(6))-(y(11)-1/params(4)*(y(8)-y(12)-params(10)*(y(14)-y(9))));
  residual(2)=(y(7))-(y(12)*params(1)+y(6)*(params(4)+params(3))*(1-params(2))*(1-params(1)*params(2))/params(2));
if nargout > 3
    g1_v = NaN(4, 1);
g1_v(1)=1+1/params(4)*params(6);
g1_v(2)=(-((params(4)+params(3))*(1-params(2))*(1-params(1)*params(2))/params(2)));
g1_v(3)=1/params(4)*params(5);
g1_v(4)=1;
    if ~isoctave && matlab_ver_less_than('9.8')
        sparse_rowval = double(sparse_rowval);
        sparse_colval = double(sparse_colval);
    end
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 2, 2);
end
end
