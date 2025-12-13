function [g1, T_order, T] = static_g1(y, x, params, sparse_rowval, sparse_colval, sparse_colptr, T_order, T)
if nargin < 8
    T_order = -1;
    T = NaN(0, 1);
end
[T_order, T] = artificial_data.sparse.static_g1_tt(y, x, params, T_order, T);
g1_v = NaN(20, 1);
g1_v(1)=(-0.1);
g1_v(2)=(-0.05);
g1_v(3)=(-100);
g1_v(4)=(-1);
g1_v(5)=0.01000000000000001;
g1_v(6)=(-0.75);
g1_v(7)=(-400);
g1_v(8)=1;
g1_v(9)=0.5;
g1_v(10)=(-400);
g1_v(11)=(-1);
g1_v(12)=0.3;
g1_v(13)=(-1);
g1_v(14)=0.7;
g1_v(15)=0.1;
g1_v(16)=0.05;
g1_v(17)=0.3;
g1_v(18)=1;
g1_v(19)=1;
g1_v(20)=1;
if ~isoctave && matlab_ver_less_than('9.8')
    sparse_rowval = double(sparse_rowval);
    sparse_colval = double(sparse_colval);
end
g1 = sparse(sparse_rowval, sparse_colval, g1_v, 9, 9);
end
