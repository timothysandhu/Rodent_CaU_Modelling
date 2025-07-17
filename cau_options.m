function options = cau_options()
% cau_options() 
%   Sets out the models that are analysed in the dataset

arguments (Output)
    options
end

options = [];

options.folderlocation = pwd;

options.percNames = {"rw", "hgf2l", "hgf3l", "hgfar1", "sutton"};
options.percArgs = {rw_model_config, two_level_model_config, three_level_model_config, ar1_model_config, sutton_model_config};

options.obsNames = {"softmax", "unitsq", "unitsq_mu3"};
options.obsArgs = {softmax_model_config, unitsq_model_config, unitsq_mu3_model_config};

options.optim = quasinewton_optim_config;

options.sampling = 1;

end