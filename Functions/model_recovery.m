function [] = model_recovery(sim,data,options)
%model_recovery Performs model recovery for all the models
arguments (Input)
    sim
    data
    options
end

pfit_sim = [];

for i = 1:numel(options.obsNames)
    for j = 1:numel(options.percNames)
        
        if options.obsNames{i} == "unitsq_mu3" && (options.percNames{j} == "rw" || options.percnames{j} == "sutton")
        continue
        end
        
        pfit_sim.(options.obsNames{i}).(options.obsNames{j}) = zeros([1,options.no_models]);

        for h = 1:(data.NewRunIndex(end))
            
            model_recov_fits = zeros([1,options.no_models]);

            for k = 1:numel(options.obsNames)
                 for l = 1:numel(options.percNames)

                     if options.obsNames{i} == "unitsq_mu3" && (options.percNames{j} == "rw" || options.percnames{j} == "sutton")
                        continue
                     end

                     model_recov = tapas_fitModel(sim.(options.obsNames{i}).(options.percNames{j})(h).y, ...
                      sim.(options.obsNames{i}).(options.percNames{j})(h).y, ...
                       options.percNames{l}, ...
                       options.obsNames{k}, ...
                       options.optim);

                    model_recov_fits(h) = model_recov.optim.LME;
                  end
             end
             
             
             % Determine which model fitted the simulated data best
             [max, ind] = max(model_recov_fits);
             pfit_sim.(options.obsNames{i}).(options.percNames{j})(ind) = pfit_sim.(options.obsNames{i}).(options.percNames{j})(ind) + 1;

        end
        
        % Compile the row of the confusion matrix for that model
        pfit_sim.(options.obsNames{i}).(options.percNames{j}) = pfit_sim.(options.obsNames{i}).(options.percNames{j})/sum(pfit_sim.(options.obsNames{i}).(options.percNames{j}));
        
    end
end

% Create confusion matrix
pred_values = repelem(1:options.no_models, data.NewRunIndex(end));

allVectors = {};
for i = 1:length(options.obsNames)
    for j = 1:length(options.percNames)
        % Access the row vector and store it in the cell array
        allVectors{end+1} = pfit_sim.(options.obsNames{i}).(options.percNames{j});
    end
end
true_values = cell2mat(allVectors);

conf_mat = confusionchart(pred_values, true_values);

cd(fullfile("Graphs", "Model_Recovery"))

fig = gcf;
filename = "Model_Recovery_Confusion_Matrix.pdf";
exportgraphics(fig, filename);

cd ..
cd ..

end