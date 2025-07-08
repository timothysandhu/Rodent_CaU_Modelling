close all; 
clear;

options = cau_options;
lrea 
opts = detectImportOptions('Pre_Stress_Modelling_Data.csv');
opts = setvartype(opts, opts.VariableNames{1}, 'string'); 
data = readtable([options.folderlocation, '\Data\Pre_Stress_Modelling_Data.csv'], opts); 
%%
priors = obtain_bo_priors(data,options);
%%
sampling_from_priors(data,options);

%%

two_level_model_config.priorsas
three_level_model_config.priorsas
ar1_model_config.priorsas