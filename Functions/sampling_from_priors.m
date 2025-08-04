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

% Define paths for saving samples and graphs
savePath = fullfile(pwd, "Saved_Variables", "Samples.mat");
graphPath = fullfile(pwd, "Graphs", "Prior_Sampling");

% Create directories if they do not exist
if ~isfolder("Saved_Variables")
    mkdir("Saved_Variables");
end
if ~isfolder("Graphs")
    mkdir("Graphs");
end

% Load samples if they exist
if isfile(savePath)
    load(savePath, "samples");
else
    samples = struct(); % Initialize as struct to avoid errors
end

sessiondata = data(data.NewRunIndex == 1, :);

set(groot,'defaultFigureVisible','off'); 

for i = 1:numel(options.obsNames)
    for j = 1:numel(options.percNames)
        filename = fullfile(graphPath, "Sample_" + (options.sampling) + (options.percNames{j}) + (options.obsNames{i}) + ".pdf");
        
        if isfile(filename)
            info = pdfinfo(filename);
            numFigures = info.NumPages;
            
            if numFigures >= 100
                continue    
            else
                delete(filename);
            end
        end

        for h = 1:100
            if options.obsNames{i} == "unitsq_mu3" && (options.percNames{j} == "rw" || options.percNames{j} == "sutton")
                continue
            end
            
            samples.(options.obsNames{i}).(options.percNames{j})(h) = tapas_sampleModel(sessiondata.Correct_Side, options.percArgs{j}, options.obsArgs{i});
            
            % Use a switch-case for better readability
            switch j
                case 1
                    tapas_rw_binary_plotTraj(samples.(options.obsNames{i}).(options.percNames{j})(h));
                case 5
                    tapas_sutton_k1_binary_plotTraj(samples.(options.obsNames{i}).(options.percNames{j})(h));
                otherwise
                    tapas_ehgf_binary_plotTraj(samples.(options.obsNames{i}).(options.percNames{j})(h));
            end
            
            fig = gcf;
            exportgraphics(fig, filename, 'Append', true);
        end
    end
end

% Save samples after processing
save(savePath, "samples");

set(groot,'defaultFigureVisible','on') 

end
