close all; 
clear;

currentFolder = pwd;
addpath(genpath(currentFolder));

options = cau_options;

opts = detectImportOptions('Pre_Stress_Modelling_Data.csv');
opts = setvartype(opts, opts.VariableNames{1}, 'string'); 
data = readtable(strcat(options.folderlocation, filesep, "Data", filesep, "Pre_Stress_Modelling_Data.csv"), opts); 

options.optim.seedRandInit = 1;
%%
priors = obtain_bo_priors(data,options);
%%
sampling_from_priors(data,options);

%%

two_level_model_config.priorsas = [NaN, 0, 0, NaN, 0, 0, 0, 0, NaN, 4, 0];
three_level_model_config.priorsas = [NaN, 0, .5, NaN, 0, .5, NaN, 0, 0, .5, 0, NaN, 2, 2];
ar1_model_config.priorsas = [NaN, 0, .5, NaN, 0, .5, NaN, 0, 0, NaN, 0, .5, NaN, 0, 0, .5, 0, NaN, 2, 2];

options.sampling = 2;

priors_sdhlv = sampling_from_priors(data,options);

%%
num_initialisations(data,options);

% 
