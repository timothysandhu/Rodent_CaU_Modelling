function fits = model_fitting(data,options)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
arguments (Input)
    data
    options
end

arguments (Output)
    fits
end

set(groot,'defaultFigureVisible','off'); 

for i = 2:numel(options.obsNames)
    for j = 1:numel(options.percNames)
        for h = 1:(data.NewRunIndex(end))
        
        sessiondata = data(data.NewRunIndex == h, :);

        if options.obsNames{i} == "unitsq_mu3" && (options.percNames{j} == "rw" || options.percnames{j} == "sutton")
        continue
        end
        
        fits.(options.obsNames{i}).(options.percNames{j})(h) = tapas_fitModel(sessiondata.Choice,...
                                                 sessiondata.Correct_Side,...
                                                 options.percArgs{j},...
                                                 options.obsArgs{i},...
                                                 options.optim);
    
        if j == 1
            tapas_rw_binary_plotTraj(fits.(options.obsNames{i}).(options.percNames{j})(h));
        elseif j == 5
            tapas_sutton_k1_binary_plotTraj(fits.(options.obsNames{i}).(options.percNames{j})(h));
        else
            tapas_ehgf_binary_plotTraj(fits.(options.obsNames{i}).(options.percNames{j})(h));
        end
        
        fig = gcf;
        filename = "Fitted_" + options.percNames{j} + options.obsNames{i} + ".pdf";
        exportgraphics(fig, filename, 'Append', true);

        lmes.(options.obsNames{i}).(options.percNames{j})(h, :) = fits.(options.obsNames{i}).(options.percNames{j})(h).optim.LME;
        
        save("fitting_task1.mat", "lmes", "fits")

        end
    end
end

end