function samples = sampling_from_priors(options, data)
% sampling_from_priors
%   Detailed explanation goes here
arguments (Input)
    options
    data
end

arguments (Output)
    samples
end

samples = [];

sessiondata = data(data.NewRunIndex == 1, :);

for i = 1:numel(options.obsNames)
    for j = 1:numel(options.percNames)
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
        filename = "\Graphs\Prior Sampling\Sample_" + (options.sampling) + (options.percNames{j}) + (options.obsNames{i}) + ".pdf";
        exportgraphics(fig, filename, 'Append', true);

        end
    end
end

end