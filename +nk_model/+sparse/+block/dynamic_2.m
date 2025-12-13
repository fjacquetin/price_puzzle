function [y, T, residual, g1] = dynamic_2(y, x, params, steady_state, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(3, 1);
  residual(1)=(y(10))-(y(19)-params(2)*(y(12)-y(20))+y(13));
  residual(2)=(y(11))-(y(20)*params(1)+params(3)*(y(10)-y(15)));
  residual(3)=(y(12))-(params(6)*y(3)+(1-params(6))*(y(20)*params(4)+(y(10)-y(15))*params(5))+y(14));
if nargout > 3
    g1_v = NaN(11, 1);
g1_v(1)=(-params(6));
g1_v(2)=params(2);
g1_v(3)=1;
g1_v(4)=1;
g1_v(5)=1;
g1_v(6)=(-params(3));
g1_v(7)=(-((1-params(6))*params(5)));
g1_v(8)=(-params(2));
g1_v(9)=(-params(1));
g1_v(10)=(-((1-params(6))*params(4)));
g1_v(11)=(-1);
    if ~isoctave && matlab_ver_less_than('9.8')
        sparse_rowval = double(sparse_rowval);
        sparse_colval = double(sparse_colval);
    end
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 3, 9);
end
end
