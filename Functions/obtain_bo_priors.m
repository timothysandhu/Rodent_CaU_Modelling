function priors = obtain_bo_priors(data, options)
% Obtain Bayes Optimal Priors 
%  Obtains Bayes Optimal Priors for each model and for each session, and places 
% updates the model config files with these prior values. 

arguments (Input)
    data
    options
end

arguments (Output)
    priors
end

for i = 1:numel(options.percNames)
    for j = 1:(data.NewRunIndex(end))
        if isfile(strcat("Saved_Variables", filesep, "bopriors.mat")) == 1
            continue
        end
        sessiondata = data(data.NewRunIndex == j, :);
        bopars = tapas_fitModel([], ...
            sessiondata.Correct_Side, ...
            options.percArgs{i}, ...
            'tapas_bayes_optimal_binary_config', ...
            'tapas_quasinewton_optim_config'); 
        priors.(options.percNames{i})(j, :) = bopars.p_prc.p; 
    end
end

if isfile(strcat("Saved_Variables", filesep, "bopriors.mat")) == 1
   load("bopriors.mat")
end

for i = 1:numel(options.percNames)
    options.percArgs{i}.priorsmus = mean(priors.(options.percNames{i}));
end
disp('Priors Updated')

cd("Saved_Variables")
save("bopriors.mat")


cd ..
end