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


cd("Saved_Variables")

if isfile('Samples.mat') == 1
    load('Samples.mat', "samples");
else
samples = [];
end

cd ..

sessiondata = data(data.NewRunIndex == 1, :);

cd(fullfile("Graphs", "Prior_Sampling"))

set(groot,'defaultFigureVisible','off'); 

for i = 1:numel(options.obsNames)
    for j = 1:numel(options.percNames)
        filename = "Sample_" + (options.sampling) + (options.percNames{j}) + (options.obsNames{i}) + ".pdf";
        
        if isfile(filename) == 1
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
        cd ..
        cd ..

        cd("Saved_Variables")
        save("Samples.mat", "samples")
        
        cd .. 
        cd(fullfile("Graphs", "Prior_Sampling"))
        
    end
end

set(groot,'defaultFigureVisible','on') 
cd ..
cd ..

end
