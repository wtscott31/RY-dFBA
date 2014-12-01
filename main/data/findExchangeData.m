%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [numMet,numRxn] = defineExchange(model,name)
% Finds the position of a given exchange metabolite and reaction
%
% INPUTS:
% model         COBRA model used in the simulation
% name          Name of the exchange metabolite
% 
% OUTPUTS:
% numMet        Numeric vector with the position in mets of each
%               exchange metabolite (the first row (volume) has a zero)
% numRxn        Numeric matrix with the position in rxns of each
%               exchange reaction (the first row (volume) has zeros)
%
% Benjamín J. Sánchez
% Last Update: 2014-11-23
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [numMet,numRxn] = findExchangeData(model,name)

%Assign metabolite position to numMet
numMet = strmatch(name,model.metNames);

%Find all exchange reactions
[isExcRxn,~] = findExcRxns(model,true);
numRxn       = zeros(1,2);
N            = length(model.rxns);

%Find all reactions in wich the metabolite is present
[rxnList,~] = findRxnsFromMets(model,model.mets(numMet));
rxnID       = findRxnIDs(model,rxnList);
m           = 1;

%If both conditions are satisfied, assign reaction position to numRxn
for n = 1:N  
    if isExcRxn(n) == 1 && length(find(rxnID==n)) == 1
        numRxn(1,m) = n;
        m           = m+1;
    end
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%