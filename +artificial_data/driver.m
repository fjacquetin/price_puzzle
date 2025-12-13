%
% Status : main Dynare file
%
% Warning : this file is generated automatically by Dynare
%           from model file (.mod)

tic0 = tic;
% Define global variables.
global M_ options_ oo_ estim_params_ bayestopt_ dataset_ dataset_info estimation_info
options_ = [];
M_.fname = 'artificial_data';
M_.dynare_version = '6.3';
oo_.dynare_version = '6.3';
options_.dynare_version = '6.3';
%
% Some global variables initialization
%
global_initialization;
M_.exo_names = cell(6,1);
M_.exo_names_tex = cell(6,1);
M_.exo_names_long = cell(6,1);
M_.exo_names(1) = {'ea'};
M_.exo_names_tex(1) = {'ea'};
M_.exo_names_long(1) = {'ea'};
M_.exo_names(2) = {'eb'};
M_.exo_names_tex(2) = {'eb'};
M_.exo_names_long(2) = {'eb'};
M_.exo_names(3) = {'ec'};
M_.exo_names_tex(3) = {'ec'};
M_.exo_names_long(3) = {'ec'};
M_.exo_names(4) = {'ex'};
M_.exo_names_tex(4) = {'ex'};
M_.exo_names_long(4) = {'ex'};
M_.exo_names(5) = {'epi'};
M_.exo_names_tex(5) = {'epi'};
M_.exo_names_long(5) = {'epi'};
M_.exo_names(6) = {'eint'};
M_.exo_names_tex(6) = {'eint'};
M_.exo_names_long(6) = {'eint'};
M_.endo_names = cell(9,1);
M_.endo_names_tex = cell(9,1);
M_.endo_names_long = cell(9,1);
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
M_.endo_names(6) = {'c'};
M_.endo_names_tex(6) = {'c'};
M_.endo_names_long(6) = {'c'};
M_.endo_names(7) = {'x_obs'};
M_.endo_names_tex(7) = {'x\_obs'};
M_.endo_names_long(7) = {'x_obs'};
M_.endo_names(8) = {'pi_obs'};
M_.endo_names_tex(8) = {'pi\_obs'};
M_.endo_names_long(8) = {'pi_obs'};
M_.endo_names(9) = {'int_obs'};
M_.endo_names_tex(9) = {'int\_obs'};
M_.endo_names_long(9) = {'int_obs'};
M_.endo_partitions = struct();
M_.param_names = {};
M_.param_names_tex = {};
M_.param_names_long = {};
M_.exo_det_nbr = 0;
M_.exo_nbr = 6;
M_.endo_nbr = 9;
M_.param_nbr = 0;
M_.orig_endo_nbr = 9;
M_.aux_vars = [];
M_.Sigma_e = zeros(6, 6);
M_.Correlation_matrix = eye(6, 6);
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
M_.eq_nbr = 9;
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
 0 5 14;
 0 6 15;
 1 7 0;
 2 8 0;
 3 9 0;
 4 10 0;
 0 11 0;
 0 12 0;
 0 13 0;]';
M_.nstatic = 3;
M_.nfwrd   = 2;
M_.npred   = 4;
M_.nboth   = 0;
M_.nsfwrd   = 2;
M_.nspred   = 4;
M_.ndynamic   = 6;
M_.dynamic_tmp_nbr = [0; 0; 0; 0; ];
M_.equations_tags = {
  1 , 'name' , 'x' ;
  2 , 'name' , 'pi' ;
  3 , 'name' , 'int' ;
  4 , 'name' , 'a' ;
  5 , 'name' , 'b' ;
  6 , 'name' , 'c' ;
  7 , 'name' , 'x_obs' ;
  8 , 'name' , 'pi_obs' ;
  9 , 'name' , 'int_obs' ;
};
M_.mapping.x.eqidx = [1 2 3 7 ];
M_.mapping.pi.eqidx = [1 2 3 8 ];
M_.mapping.int.eqidx = [1 3 9 ];
M_.mapping.a.eqidx = [1 4 ];
M_.mapping.b.eqidx = [3 5 ];
M_.mapping.c.eqidx = [2 3 6 ];
M_.mapping.x_obs.eqidx = [7 ];
M_.mapping.pi_obs.eqidx = [8 ];
M_.mapping.int_obs.eqidx = [9 ];
M_.mapping.ea.eqidx = [4 ];
M_.mapping.eb.eqidx = [5 ];
M_.mapping.ec.eqidx = [6 ];
M_.mapping.ex.eqidx = [7 ];
M_.mapping.epi.eqidx = [8 ];
M_.mapping.eint.eqidx = [9 ];
M_.static_and_dynamic_models_differ = false;
M_.has_external_function = false;
M_.block_structure.time_recursive = false;
M_.block_structure.block(1).Simulation_Type = 1;
M_.block_structure.block(1).endo_nbr = 3;
M_.block_structure.block(1).mfs = 3;
M_.block_structure.block(1).equation = [ 4 5 6];
M_.block_structure.block(1).variable = [ 4 5 6];
M_.block_structure.block(1).is_linear = true;
M_.block_structure.block(1).NNZDerivatives = 6;
M_.block_structure.block(1).bytecode_jacob_cols_to_sparse = [1 2 3 4 5 6 ];
M_.block_structure.block(2).Simulation_Type = 8;
M_.block_structure.block(2).endo_nbr = 3;
M_.block_structure.block(2).mfs = 3;
M_.block_structure.block(2).equation = [ 1 2 3];
M_.block_structure.block(2).variable = [ 3 2 1];
M_.block_structure.block(2).is_linear = true;
M_.block_structure.block(2).NNZDerivatives = 11;
M_.block_structure.block(2).bytecode_jacob_cols_to_sparse = [1 4 5 6 8 9 ];
M_.block_structure.block(3).Simulation_Type = 1;
M_.block_structure.block(3).endo_nbr = 3;
M_.block_structure.block(3).mfs = 3;
M_.block_structure.block(3).equation = [ 9 8 7];
M_.block_structure.block(3).variable = [ 9 8 7];
M_.block_structure.block(3).is_linear = true;
M_.block_structure.block(3).NNZDerivatives = 3;
M_.block_structure.block(3).bytecode_jacob_cols_to_sparse = [4 5 6 ];
M_.block_structure.block(1).g1_sparse_rowval = int32([]);
M_.block_structure.block(1).g1_sparse_colval = int32([]);
M_.block_structure.block(1).g1_sparse_colptr = int32([]);
M_.block_structure.block(2).g1_sparse_rowval = int32([3 1 3 2 1 2 3 1 2 3 1 ]);
M_.block_structure.block(2).g1_sparse_colval = int32([1 4 4 5 6 6 6 8 8 8 9 ]);
M_.block_structure.block(2).g1_sparse_colptr = int32([1 2 2 2 4 5 8 8 11 12 ]);
M_.block_structure.block(3).g1_sparse_rowval = int32([]);
M_.block_structure.block(3).g1_sparse_colval = int32([]);
M_.block_structure.block(3).g1_sparse_colptr = int32([]);
M_.block_structure.variable_reordered = [ 4 5 6 3 2 1 9 8 7];
M_.block_structure.equation_reordered = [ 4 5 6 1 2 3 9 8 7];
M_.block_structure.incidence(1).lead_lag = -1;
M_.block_structure.incidence(1).sparse_IM = [
 3 3;
 4 4;
 5 5;
 6 6;
];
M_.block_structure.incidence(2).lead_lag = 0;
M_.block_structure.incidence(2).sparse_IM = [
 1 1;
 1 3;
 1 4;
 2 1;
 2 2;
 2 6;
 3 1;
 3 3;
 3 5;
 3 6;
 4 4;
 5 5;
 6 6;
 7 1;
 7 7;
 8 2;
 8 8;
 9 3;
 9 9;
];
M_.block_structure.incidence(3).lead_lag = 1;
M_.block_structure.incidence(3).sparse_IM = [
 1 1;
 1 2;
 2 2;
 3 2;
];
M_.block_structure.dyn_tmp_nbr = 0;
M_.state_var = [4 5 6 3 ];
M_.maximum_lag = 1;
M_.maximum_lead = 1;
M_.maximum_endo_lag = 1;
M_.maximum_endo_lead = 1;
oo_.steady_state = zeros(9, 1);
M_.maximum_exo_lag = 0;
M_.maximum_exo_lead = 0;
oo_.exo_steady_state = zeros(6, 1);
M_.params = NaN(0, 1);
M_.endo_trends = struct('deflator', cell(9, 1), 'log_deflator', cell(9, 1), 'growth_factor', cell(9, 1), 'log_growth_factor', cell(9, 1));
M_.NNZDerivatives = [33; 0; -1; ];
M_.dynamic_g1_sparse_rowval = int32([3 4 5 6 1 2 3 7 2 8 1 3 9 1 4 3 5 2 3 6 7 8 9 1 1 2 3 4 5 6 7 8 9 ]);
M_.dynamic_g1_sparse_colval = int32([3 4 5 6 10 10 10 10 11 11 12 12 12 13 13 14 14 15 15 15 16 17 18 19 20 20 20 28 29 30 31 32 33 ]);
M_.dynamic_g1_sparse_colptr = int32([1 1 1 2 3 4 5 5 5 5 9 11 14 16 18 21 22 23 24 25 28 28 28 28 28 28 28 28 29 30 31 32 33 34 ]);
M_.dynamic_g2_sparse_indices = int32([]);
M_.lhs = {
'x'; 
'pi'; 
'int'; 
'a'; 
'b'; 
'c'; 
'x_obs'; 
'pi_obs'; 
'int_obs'; 
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
M_.block_structure_stat.block(3).Simulation_Type = 3;
M_.block_structure_stat.block(3).endo_nbr = 1;
M_.block_structure_stat.block(3).mfs = 1;
M_.block_structure_stat.block(3).equation = [ 6];
M_.block_structure_stat.block(3).variable = [ 6];
M_.block_structure_stat.block(4).Simulation_Type = 6;
M_.block_structure_stat.block(4).endo_nbr = 3;
M_.block_structure_stat.block(4).mfs = 3;
M_.block_structure_stat.block(4).equation = [ 1 2 3];
M_.block_structure_stat.block(4).variable = [ 3 1 2];
M_.block_structure_stat.block(5).Simulation_Type = 1;
M_.block_structure_stat.block(5).endo_nbr = 3;
M_.block_structure_stat.block(5).mfs = 3;
M_.block_structure_stat.block(5).equation = [ 9 8 7];
M_.block_structure_stat.block(5).variable = [ 9 8 7];
M_.block_structure_stat.variable_reordered = [ 4 5 6 3 1 2 9 8 7];
M_.block_structure_stat.equation_reordered = [ 4 5 6 1 2 3 9 8 7];
M_.block_structure_stat.incidence.sparse_IM = [
 1 2;
 1 3;
 1 4;
 2 1;
 2 2;
 2 6;
 3 1;
 3 2;
 3 3;
 3 5;
 3 6;
 4 4;
 5 5;
 6 6;
 7 1;
 7 7;
 8 2;
 8 8;
 9 3;
 9 9;
];
M_.block_structure_stat.tmp_nbr = 0;
M_.block_structure_stat.block(1).g1_sparse_rowval = int32([1 ]);
M_.block_structure_stat.block(1).g1_sparse_colval = int32([1 ]);
M_.block_structure_stat.block(1).g1_sparse_colptr = int32([1 2 ]);
M_.block_structure_stat.block(2).g1_sparse_rowval = int32([1 ]);
M_.block_structure_stat.block(2).g1_sparse_colval = int32([1 ]);
M_.block_structure_stat.block(2).g1_sparse_colptr = int32([1 2 ]);
M_.block_structure_stat.block(3).g1_sparse_rowval = int32([1 ]);
M_.block_structure_stat.block(3).g1_sparse_colval = int32([1 ]);
M_.block_structure_stat.block(3).g1_sparse_colptr = int32([1 2 ]);
M_.block_structure_stat.block(4).g1_sparse_rowval = int32([1 3 2 3 1 2 3 ]);
M_.block_structure_stat.block(4).g1_sparse_colval = int32([1 1 2 2 3 3 3 ]);
M_.block_structure_stat.block(4).g1_sparse_colptr = int32([1 3 5 8 ]);
M_.block_structure_stat.block(5).g1_sparse_rowval = int32([]);
M_.block_structure_stat.block(5).g1_sparse_colval = int32([]);
M_.block_structure_stat.block(5).g1_sparse_colptr = int32([]);
M_.static_g1_sparse_rowval = int32([2 3 7 1 2 3 8 1 3 9 1 4 3 5 2 3 6 7 8 9 ]);
M_.static_g1_sparse_colval = int32([1 1 1 2 2 2 2 3 3 3 4 4 5 5 6 6 6 7 8 9 ]);
M_.static_g1_sparse_colptr = int32([1 4 8 11 13 15 18 19 20 21 ]);
%
% INITVAL instructions
%
options_.initval_file = false;
oo_.steady_state(1) = 0;
oo_.steady_state(2) = 0;
oo_.steady_state(3) = 0;
oo_.steady_state(4) = 0;
oo_.steady_state(5) = 0;
oo_.steady_state(6) = 0;
oo_.steady_state(7) = 0;
oo_.steady_state(8) = 0;
oo_.steady_state(9) = 0;
if M_.exo_nbr > 0
	oo_.exo_simul = ones(M_.maximum_lag,1)*oo_.exo_steady_state';
end
if M_.exo_det_nbr > 0
	oo_.exo_det_simul = ones(M_.maximum_lag,1)*oo_.exo_det_steady_state';
end
%
% SHOCKS instructions
%
M_.exo_det_length = 0;
M_.Sigma_e(1, 1) = (0.20)^2;
M_.Sigma_e(2, 2) = (0.20)^2;
M_.Sigma_e(3, 3) = (0.14)^2;
M_.Sigma_e(4, 4) = (0.50)^2;
M_.Sigma_e(5, 5) = (0.30)^2;
M_.Sigma_e(6, 6) = (0.30)^2;
oo_.dr.eigval = check(M_,options_,oo_);
options_.nograph = true;
options_.order = 1;
options_.periods = 200;
var_list_ = {'x_obs';'pi_obs';'int_obs'};
[info, oo_, options_, M_] = stoch_simul(M_, options_, oo_, var_list_);


oo_.time = toc(tic0);
disp(['Total computing time : ' dynsec2hms(oo_.time) ]);
if ~exist([M_.dname filesep 'Output'],'dir')
    mkdir(M_.dname,'Output');
end
save([M_.dname filesep 'Output' filesep 'artificial_data_results.mat'], 'oo_', 'M_', 'options_');
if exist('estim_params_', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'artificial_data_results.mat'], 'estim_params_', '-append');
end
if exist('bayestopt_', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'artificial_data_results.mat'], 'bayestopt_', '-append');
end
if exist('dataset_', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'artificial_data_results.mat'], 'dataset_', '-append');
end
if exist('estimation_info', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'artificial_data_results.mat'], 'estimation_info', '-append');
end
if exist('dataset_info', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'artificial_data_results.mat'], 'dataset_info', '-append');
end
if exist('oo_recursive_', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'artificial_data_results.mat'], 'oo_recursive_', '-append');
end
if exist('options_mom_', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'artificial_data_results.mat'], 'options_mom_', '-append');
end
if ~isempty(lastwarn)
  disp('Note: warning(s) encountered in MATLAB/Octave code')
end
