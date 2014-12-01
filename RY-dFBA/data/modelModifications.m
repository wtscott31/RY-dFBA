%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% model = modelModifications(model,isAerobic)
% Modifies model for anaerobic models and adds maintenance reaction.
%
% INPUTS:
% model         COBRA model used in the simulation
% isAerobic     =1 if aerobic experiment and =0 if anaerobic experiment
% 
% OUTPUT:
% model         Modified COBRA model
%
% Benjamín J. Sánchez
% Last Update: 2014-11-23
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function model = modelModifications(model,isAerobic)

if ~isAerobic
    %Modifications performed as suggested by Heavner et al. 2012
    rxnNames = {'oxygen exchange'
                'lipid pseudoreaction'
                'lipid pseudoreaction [no 14-demethyllanosterol, no ergosta-5,7,22,24(28)-tetraen-3beta-ol]'
                'ergosterol exchange'
                'lanosterol exchange'
                'zymosterol exchange'
                'phosphatidate exchange'};
    for i = 1:length(rxnNames)
        numRxn = strmatch(rxnNames(i),model.rxnNames);
        if i <= 2
            %Blocked rxns
            model = changeRxnBounds(model,model.rxns(numRxn(1)),0,'l');
            model = changeRxnBounds(model,model.rxns(numRxn(1)),0,'u');
        else
            %Unblocked rxns
            model = changeRxnBounds(model,model.rxns(numRxn(1)),-1000,'l');
            model = changeRxnBounds(model,model.rxns(numRxn(1)),+1000,'u');
        end
    end
end

%Add ATP maintenance reaction:
[model,~] = addReaction(model,'ATP_maintenance',{'s_0434'},-1,false,0,1000);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%