close all; 
clear;

currentFolder = pwd;
addpath(genpath(currentFolder));

options = cau_options;

opts = detectImportOptions('Full_Stress_Modelling_Data.csv');
opts = setvartype(opts, opts.VariableNames{1}, 'string'); 
data = readtable(strcat(options.folderlocation, filesep, "Data", filesep, "Full_Stress_Modelling_Data.csv"), opts); 

options.optim.seedRandInit = 1;
%% Obtaining Bayes optimal priors
priors = obtain_bo_priors(data,options);
%% Fitting models
[fits, lmes] = model_fitting(data,options);

%% Performing parameter recovery
[sim,cc_prc,cc_obs] = param_recovery(fits,options,data);

%% Performing model recovery
model_recovery(sim,data,options);