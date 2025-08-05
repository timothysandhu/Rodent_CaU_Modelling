function [] = num_initialisations(data,options)
%num_optimisations Prints graphs so you can see number of optimisations needed

arguments (Input)
    data
    options
end

sessiondata = data(data.NewRunIndex == 1, :);
lmes = [];

set(groot,'defaultFigureVisible','off'); 

for i = 1:numel(options.obsNames)
    for j = 1:numel(options.percNames)
        filename = "Optimisations_" + (options.percNames{j}) + (options.obsNames{i}) + ".pdf";
        
        if isfile(filename) == 1
             continue    
        end

        for h = 1:15
        if options.obsNames{i} == "unitsq_mu3" && (options.percNames{j} == "rw" || options.percnames{j} == "sutton")
        continue
        end
        
        options.optim.nRandInit = h;

        randInit.(options.obsNames{i}).(options.percNames{j})(h) = tapas_fitModel(sessiondata.Choice,...
                                                 sessiondata.Correct_Side,...
                                                 options.percArgs{j},...
                                                 options.obsArgs{i},...
                                                 options.optim);
        lmes.(options.obsNames{i}).(options.percNames{j})(h) = randInit.(options.obsNames{i}).(options.percNames{j})(h).optim.LME;
        end

        cd("Graphs")
        cd("Initialisations")

        plot(lmes.(options.obsNames{i}).(options.percNames{j}));

        fig = gcf;
        exportgraphics(fig, filename);

        cd ..
        cd ..

    end
end

set(groot,'defaultFigureVisible','on'); 

end