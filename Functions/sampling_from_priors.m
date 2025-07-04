function samples = sampling_from_priors(data, options)
% sampling_from_priors
%   Takes 100 random samples from the prior distributions for each model
%   and plots them. 
arguments (Input)
    data
    options
end

arguments (Output)
    samples
end

samples = [];

sessiondata = data(data.NewRunIndex == 1, :);

cd(strcat(options.folderlocation,"\Graphs\Prior Sampling"))

for i = 1:numel(options.obsNames)
    for j = 1:numel(options.percNames)
        filename = "Sample_" + (options.sampling) + (options.percNames{j}) + (options.obsNames{i}) + ".pdf";
        if isfile(filename) == 1
            delete(filename);
        else
        continue
        end

        for h = 1:100
        if options.obsNames{i} == "unitsq_mu3" && (options.percNames{j} == "rw" || options.percnames{j} == "sutton")
        continue
        end
        
        samples.(options.obsNames{i}).(options.percNames{j})(h) = tapas_sampleModel(sessiondata.Correct_Side, options.percArgs{j}, options.obsArgs{i});
        
        if j == 1
            tapas_rw_binary_plotTraj(samples.(options.obsNames{i}).(options.percNames{j})(h));
        elseif j == 5
            tapas_sutton_k1_binary_plotTraj(samples.(options.obsNames{i}).(options.percNames{j})(h));
        else
            tapas_ehgf_binary_plotTraj(samples.(options.obsNames{i}).(options.percNames{j})(h));
        end
        
        fig = gcf;
        exportgraphics(fig, filename, 'Append', true);

        end
    end
end

cd(options.folderlocation)

end