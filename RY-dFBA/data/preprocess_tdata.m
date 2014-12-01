%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tdata = preprocess_tdata(tdata,model)
% Removes essential genes from analysis and genes not included in model.
%
% INPUTS:
% tdata         Transcriptomic information
% model         COBRA model used in the simulation
% 
% OUTPUT:
% tdata         Processed transcriptomic information
%
% Benjamín J. Sánchez
% Last Update: 2014-11-23
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function tdata = preprocess_tdata(tdata,model)

[M,N]      = size(tdata.values);
to_delete  = zeros(M,1);
count_out  = 0;
count_ess  = 0;

for i = 1:M
    %Replace non-numeric values with zeros:
    for j = 1:N
        if isnan(tdata.values(i,j))
            tdata.values(i,j) = 0;
        end
    end
    
    if ismember(tdata.names(i),model.genes)
        %Perform in silico knockout:
        model_knockout = deleteModelGenes(model,tdata.names(i));
        FBAsol         = optimizeCbModel(model_knockout,'max',false,true);
        if FBAsol.stat ~= 1 || FBAsol.f == 0
            %Delete genes that are essential for growth (i.e. no biomass
            %formation for knockout):
            to_delete(i) = 1;
            count_ess    = count_ess + 1;
        end
    else
        %Delete genes that are not in the GSMM model
        to_delete(i) = 1;
        count_out    = count_out + 1;
    end
end
ind                 = find(to_delete);
tdata.names(ind)    = [];
tdata.values(ind,:) = [];
disp(['Genes in expression data not in GSMM model: ' num2str(count_out)])
disp(['Genes in expression data essential for growth: ' num2str(count_ess)])

%Calculate mean and standard deviation for each dataset
tdata.tave  = zeros(N,1);
tdata.tstd  = zeros(N,1);
for j = 1:N
    tdata.tave(j) = mean(tdata.values(:,j));
    tdata.tstd(j) = std(tdata.values(:,j));
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%