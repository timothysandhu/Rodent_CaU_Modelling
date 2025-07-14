close all; 
clear;

currentFolder = pwd;
addpath(genpath(currentFolder));

options = cau_options;

opts = detectImportOptions('Pre_Stress_Modelling_Data.csv');
opts = setvartype(opts, opts.VariableNames{1}, 'string'); 
data = readtable(strcat(options.folderlocation, filesep, "Data", filesep, "Pre_Stress_Modelling_Data.csv"), opts); 
%%
priors = obtain_bo_priors(data,options);
%%
sampling_from_priors(data,options);

%%

two_level_model_config.priorsas
three_level_model_config.priorsas
ar1_model_config.priorsas