%
% Status : main Dynare file
%
% Warning : this file is generated automatically by Dynare
%           from model file (.mod)

tic0 = tic;
% Define global variables.
global M_ options_ oo_ estim_params_ bayestopt_ dataset_ dataset_info estimation_info
options_ = [];
M_.fname = 'nk_model';
M_.dynare_version = '6.3';
oo_.dynare_version = '6.3';
options_.dynare_version = '6.3';
%
% Some global variables initialization
%
global_initialization;
M_.exo_names = cell(2,1);
M_.exo_names_tex = cell(2,1);
M_.exo_names_long = cell(2,1);
M_.exo_names(1) = {'ea'};
M_.exo_names_tex(1) = {'ea'};
M_.exo_names_long(1) = {'ea'};
M_.exo_names(2) = {'eb'};
M_.exo_names_tex(2) = {'eb'};
M_.exo_names_long(2) = {'eb'};
M_.endo_names = cell(5,1);
M_.endo_names_tex = cell(5,1);
M_.endo_names_long = cell(5,1);
M_.endo_names(1) = {'x'};
M_.endo_names_tex(1) = {'x'};
M_.endo_names_long(1) = {'x'};
M_.endo_names(2) = {'pi'};
M_.endo_names_tex(2) = {'pi'};
M_.endo_names_long(2) = {'pi'};
M_.endo_names(3) = {'int'};
M_.endo_names_tex(3) = {'int'};
M_.endo_names_long(3) = {'int'};
M_.endo_names(4) = {'a'};
M_.endo_names_tex(4) = {'a'};
M_.endo_names_long(4) = {'a'};
M_.endo_names(5) = {'b'};
M_.endo_names_tex(5) = {'b'};
M_.endo_names_long(5) = {'b'};
M_.endo_partitions = struct();
M_.param_names = cell(10,1);
M_.param_names_tex = cell(10,1);
M_.param_names_long = cell(10,1);
M_.param_names(1) = {'bet'};
M_.param_names_tex(1) = {'bet'};
M_.param_names_long(1) = {'bet'};
M_.param_names(2) = {'alph'};
M_.param_names_tex(2) = {'alph'};
M_.param_names_long(2) = {'alph'};
M_.param_names(3) = {'phi'};
M_.param_names_tex(3) = {'phi'};
M_.param_names_long(3) = {'phi'};
M_.param_names(4) = {'sig'};
M_.param_names_tex(4) = {'sig'};
M_.param_names_long(4) = {'sig'};
M_.param_names(5) = {'phipi'};
M_.param_names_tex(5) = {'phipi'};
M_.param_names_long(5) = {'phipi'};
M_.param_names(6) = {'phix'};
M_.param_names_tex(6) = {'phix'};
M_.param_names_long(6) = {'phix'};
M_.param_names(7) = {'rhoa'};
M_.param_names_tex(7) = {'rhoa'};
M_.param_names_long(7) = {'rhoa'};
M_.param_names(8) = {'rhob'};
M_.param_names_tex(8) = {'rhob'};
M_.param_names_long(8) = {'rhob'};
M_.param_names(9) = {'kappa'};
M_.param_names_tex(9) = {'kappa'};
M_.param_names_long(9) = {'kappa'};
M_.param_names(10) = {'mu'};
M_.param_names_tex(10) = {'mu'};
M_.param_names_long(10) = {'mu'};
M_.param_partitions = struct();
M_.exo_det_nbr = 0;
M_.exo_nbr = 2;
M_.endo_nbr = 5;
M_.param_nbr = 10;
M_.orig_endo_nbr = 5;
M_.aux_vars = [];
M_.Sigma_e = zeros(2, 2);
M_.Correlation_matrix = eye(2, 2);
M_.H = 0;
M_.Correlation_matrix_ME = 1;
M_.sigma_e_is_diagonal = true;
M_.det_shocks = [];
M_.surprise_shocks = [];
M_.learnt_shocks = [];
M_.learnt_endval = [];
M_.heteroskedastic_shocks.Qvalue_orig = [];
M_.heteroskedastic_shocks.Qscale_orig = [];
M_.matched_irfs = {};
M_.matched_irfs_weights = {};
options_.linear = true;
options_.block = false;
options_.bytecode = false;
options_.use_dll = false;
options_.ramsey_policy = false;
options_.discretionary_policy = false;
M_.nonzero_hessian_eqs = [];
M_.hessian_eq_zero = isempty(M_.nonzero_hessian_eqs);
M_.eq_nbr = 5;
M_.ramsey_orig_eq_nbr = 0;
M_.ramsey_orig_endo_nbr = 0;
M_.set_auxiliary_variables = exist(['./+' M_.fname '/set_auxiliary_variables.m'], 'file') == 2;
M_.epilogue_names = {};
M_.epilogue_var_list_ = {};
M_.orig_maximum_endo_lag = 1;
M_.orig_maximum_endo_lead = 1;
M_.orig_maximum_exo_lag = 0;
M_.orig_maximum_exo_lead = 0;
M_.orig_maximum_exo_det_lag = 0;
M_.orig_maximum_exo_det_lead = 0;
M_.orig_maximum_lag = 1;
M_.orig_maximum_lead = 1;
M_.orig_maximum_lag_with_diffs_expanded = 1;
M_.lead_lag_incidence = [
 0 3 8;
 0 4 9;
 0 5 0;
 1 6 10;
 2 7 0;]';
M_.nstatic = 1;
M_.nfwrd   = 2;
M_.npred   = 1;
M_.nboth   = 1;
M_.nsfwrd   = 3;
M_.nspred   = 2;
M_.ndynamic   = 4;
M_.dynamic_tmp_nbr = [1; 0; 0; 0; ];
M_.equations_tags = {
  1 , 'name' , 'x' ;
  2 , 'name' , 'pi' ;
  3 , 'name' , 'int' ;
  4 , 'name' , 'a' ;
  5 , 'name' , 'b' ;
};
M_.mapping.x.eqidx = [1 2 3 ];
M_.mapping.pi.eqidx = [1 2 3 ];
M_.mapping.int.eqidx = [1 3 ];
M_.mapping.a.eqidx = [1 4 ];
M_.mapping.b.eqidx = [3 5 ];
M_.mapping.ea.eqidx = [4 ];
M_.mapping.eb.eqidx = [5 ];
M_.static_and_dynamic_models_differ = false;
M_.has_external_function = false;
M_.block_structure.time_recursive = false;
M_.block_structure.block(1).Simulation_Type = 1;
M_.block_structure.block(1).endo_nbr = 2;
M_.block_structure.block(1).mfs = 2;
M_.block_structure.block(1).equation = [ 4 5];
M_.block_structure.block(1).variable = [ 4 5];
M_.block_structure.block(1).is_linear = true;
M_.block_structure.block(1).NNZDerivatives = 4;
M_.block_structure.block(1).bytecode_jacob_cols_to_sparse = [1 2 3 4 ];
M_.block_structure.block(2).Simulation_Type = 7;
M_.block_structure.block(2).endo_nbr = 3;
M_.block_structure.block(2).mfs = 2;
M_.block_structure.block(2).equation = [ 3 1 2];
M_.block_structure.block(2).variable = [ 3 1 2];
M_.block_structure.block(2).is_linear = true;
M_.block_structure.block(2).NNZDerivatives = 8;
M_.block_structure.block(2).bytecode_jacob_cols_to_sparse = [0 1 2 0 0 ];
M_.block_structure.block(1).g1_sparse_rowval = int32([]);
M_.block_structure.block(1).g1_sparse_colval = int32([]);
M_.block_structure.block(1).g1_sparse_colptr = int32([]);
M_.block_structure.block(2).g1_sparse_rowval = int32([1 2 1 2 ]);
M_.block_structure.block(2).g1_sparse_colval = int32([1 1 2 2 ]);
M_.block_structure.block(2).g1_sparse_colptr = int32([1 3 5 ]);
M_.block_structure.variable_reordered = [ 4 5 3 1 2];
M_.block_structure.equation_reordered = [ 4 5 3 1 2];
M_.block_structure.incidence(1).lead_lag = -1;
M_.block_structure.incidence(1).sparse_IM = [
 4 4;
 5 5;
];
M_.block_structure.incidence(2).lead_lag = 0;
M_.block_structure.incidence(2).sparse_IM = [
 1 1;
 1 3;
 1 4;
 2 1;
 2 2;
 3 1;
 3 2;
 3 3;
 3 5;
 4 4;
 5 5;
];
M_.block_structure.incidence(3).lead_lag = 1;
M_.block_structure.incidence(3).sparse_IM = [
 1 1;
 1 2;
 1 4;
 2 2;
];
M_.block_structure.dyn_tmp_nbr = 0;
M_.state_var = [4 5 ];
M_.maximum_lag = 1;
M_.maximum_lead = 1;
M_.maximum_endo_lag = 1;
M_.maximum_endo_lead = 1;
oo_.steady_state = zeros(5, 1);
M_.maximum_exo_lag = 0;
M_.maximum_exo_lead = 0;
oo_.exo_steady_state = zeros(2, 1);
M_.params = NaN(10, 1);
M_.endo_trends = struct('deflator', cell(5, 1), 'log_deflator', cell(5, 1), 'growth_factor', cell(5, 1), 'log_growth_factor', cell(5, 1));
M_.NNZDerivatives = [19; 0; -1; ];
M_.dynamic_g1_sparse_rowval = int32([4 5 1 2 3 2 3 1 3 1 4 3 5 1 1 2 1 4 5 ]);
M_.dynamic_g1_sparse_colval = int32([4 5 6 6 6 7 7 8 8 9 9 10 10 11 12 12 14 16 17 ]);
M_.dynamic_g1_sparse_colptr = int32([1 1 1 1 2 3 6 8 10 12 14 15 17 17 18 18 19 20 ]);
M_.dynamic_g2_sparse_indices = int32([]);
M_.lhs = {
'x'; 
'pi'; 
'int'; 
'a'; 
'b'; 
};
M_.static_tmp_nbr = [0; 0; 0; 0; ];
M_.block_structure_stat.block(1).Simulation_Type = 3;
M_.block_structure_stat.block(1).endo_nbr = 1;
M_.block_structure_stat.block(1).mfs = 1;
M_.block_structure_stat.block(1).equation = [ 4];
M_.block_structure_stat.block(1).variable = [ 4];
M_.block_structure_stat.block(2).Simulation_Type = 3;
M_.block_structure_stat.block(2).endo_nbr = 1;
M_.block_structure_stat.block(2).mfs = 1;
M_.block_structure_stat.block(2).equation = [ 5];
M_.block_structure_stat.block(2).variable = [ 5];
M_.block_structure_stat.block(3).Simulation_Type = 6;
M_.block_structure_stat.block(3).endo_nbr = 3;
M_.block_structure_stat.block(3).mfs = 3;
M_.block_structure_stat.block(3).equation = [ 3 1 2];
M_.block_structure_stat.block(3).variable = [ 2 3 1];
M_.block_structure_stat.variable_reordered = [ 4 5 2 3 1];
M_.block_structure_stat.equation_reordered = [ 4 5 3 1 2];
M_.block_structure_stat.incidence.sparse_IM = [
 1 2;
 1 3;
 2 1;
 2 2;
 3 1;
 3 2;
 3 3;
 3 5;
 4 4;
 5 5;
];
M_.block_structure_stat.tmp_nbr = 0;
M_.block_structure_stat.block(1).g1_sparse_rowval = int32([1 ]);
M_.block_structure_stat.block(1).g1_sparse_colval = int32([1 ]);
M_.block_structure_stat.block(1).g1_sparse_colptr = int32([1 2 ]);
M_.block_structure_stat.block(2).g1_sparse_rowval = int32([1 ]);
M_.block_structure_stat.block(2).g1_sparse_colval = int32([1 ]);
M_.block_structure_stat.block(2).g1_sparse_colptr = int32([1 2 ]);
M_.block_structure_stat.block(3).g1_sparse_rowval = int32([1 2 3 1 2 1 3 ]);
M_.block_structure_stat.block(3).g1_sparse_colval = int32([1 1 1 2 2 3 3 ]);
M_.block_structure_stat.block(3).g1_sparse_colptr = int32([1 4 6 8 ]);
M_.static_g1_sparse_rowval = int32([2 3 1 2 3 1 3 4 3 5 ]);
M_.static_g1_sparse_colval = int32([1 1 2 2 2 3 3 4 5 5 ]);
M_.static_g1_sparse_colptr = int32([1 3 6 8 9 11 ]);
M_.params(1) = 0.99;
bet = M_.params(1);
M_.params(2) = 0.75;
alph = M_.params(2);
M_.params(3) = 1;
phi = M_.params(3);
M_.params(4) = 1;
sig = M_.params(4);
M_.params(5) = 1.5;
phipi = M_.params(5);
M_.params(6) = 0.;
phix = M_.params(6);
M_.params(10) = M_.params(4)*(1+M_.params(3))/(M_.params(4)+M_.params(3));
mu = M_.params(10);
M_.params(7) = 0.95;
rhoa = M_.params(7);
M_.params(8) = 0.5;
rhob = M_.params(8);
steady;
oo_.dr.eigval = check(M_,options_,oo_);
%
% SHOCKS instructions
%
M_.exo_det_length = 0;
M_.Sigma_e(1, 1) = (1)^2;
M_.Sigma_e(2, 2) = (1)^2;
options_.irf = 12;
options_.order = 1;
var_list_ = {};
[info, oo_, options_, M_] = stoch_simul(M_, options_, oo_, var_list_);


oo_.time = toc(tic0);
disp(['Total computing time : ' dynsec2hms(oo_.time) ]);
if ~exist([M_.dname filesep 'Output'],'dir')
    mkdir(M_.dname,'Output');
end
save([M_.dname filesep 'Output' filesep 'nk_model_results.mat'], 'oo_', 'M_', 'options_');
if exist('estim_params_', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'nk_model_results.mat'], 'estim_params_', '-append');
end
if exist('bayestopt_', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'nk_model_results.mat'], 'bayestopt_', '-append');
end
if exist('dataset_', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'nk_model_results.mat'], 'dataset_', '-append');
end
if exist('estimation_info', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'nk_model_results.mat'], 'estimation_info', '-append');
end
if exist('dataset_info', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'nk_model_results.mat'], 'dataset_info', '-append');
end
if exist('oo_recursive_', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'nk_model_results.mat'], 'oo_recursive_', '-append');
end
if exist('options_mom_', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'nk_model_results.mat'], 'options_mom_', '-append');
end
if ~isempty(lastwarn)
  disp('Note: warning(s) encountered in MATLAB/Octave code')
end
