close all; 
clear;

options = cau_options;

opts = detectImportOptions('Pre_Stress_Modelling_Data.csv');
opts = setvartype(opts, opts.VariableNames{1}, 'string'); 
data = readtable([options.folderlocation, '\Data\Pre_Stress_Modelling_Data.csv'], opts); 

obtain_bo_priors(data,options);

sampling_from_priors(data,options);