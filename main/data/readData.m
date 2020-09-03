
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [model,excMet,excRxn,x0,feed,PM,expdata,trans,weights] = readData(model,dataName,dataset)
% Reads the .xls file and assigns the initial variables
%
% INPUTS:
% model         SBML model used in the simulation
% dataName      String indicating the .xls data name. For example,
%               'DATA.xls'
% dataset       Fermentation number (Spreadsheet number)
% 
% OUTPUTS:
% model         SBML model used in the simulation (changed)
% excMet        Numeric vector with the position in model.mets of each
%               exchange metabolite (the first row (volume) has a zero)
% excRxn        Numeric matrix with the position in model.rxns of each
%               exchange reaction (the first row (volume) has zeros)
% x0            Initial value of each variable
% feed          Fed-Batch policy ([L] for volume and [g/L] for metabolites)
% PM            Molecular weight of each exchange metabolite [g/mmol]
% expdata       Experimental Data
% trans         Transcriptomic data
% weights       Weights for parameter optimization
%
% Benjamín J. Sánchez
% Last Update: 2014-11-23
%
% William T. Scott, Jr.
% Last Update: 2019-01-02
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [model,excMet,excRxn,x0,feed,PM,expdata,weights] = readData(model,dataName,dataset)

%Read excel file:
[~,expName]     = xlsread(dataName,dataset,'A1');           %Experiment Name
[~,excMetNames] = xlsread(dataName,dataset,'B2:B50');       %Exchange metabolite names
x0              = xlsread(dataName,dataset,'C2:C50');       %Initial concentrations [L] or [g/L]
PM              = xlsread(dataName,dataset,'D2:D50')./1000; %Molecular weights [g/mmol]
initLB          = xlsread(dataName,dataset,'F2:F50');       %Initial lower bound
initUB          = xlsread(dataName,dataset,'G2:G50');       %Initial upper bound
feed            = xlsread(dataName,dataset,'H2:H50');       %Feed for each variable [L/h] or [g/L]
expdata         = xlsread(dataName,dataset,'K2:V100');      %Experimental Data

%Define weigths for optimization functions according to number of
%measurments:
[m,n]   = size(expdata);
weights = ones(1,n)*m;
for i = 1:m
    for j = 1:n
        if isnan(expdata(i,j))
            weights(j) = weights(j) - 1;
        end
    end
end

%Read each name and assign a metabolite ID and an exchange reaction ID to
%the corresponding name. Also, set up the respective initial LB and UB.
N      = length(excMetNames);
excMet = zeros(N,1);
excRxn = zeros(N,2);
for i = 2:N
    [excMet(i),excRxn(i,:)] = findExchangeData(model,excMetNames(i));
    model = changeRxnBounds(model,model.rxns(excRxn(i,1)),initLB(i),'l');
    model = changeRxnBounds(model,model.rxns(excRxn(i,1)),initUB(i),'u');
    
    %Eliminates repeated fluxes
    if(excRxn(i,2)~=0)
        model = changeRxnBounds(model,model.rxns(excRxn(i,2)),0,'l');
        model = changeRxnBounds(model,model.rxns(excRxn(i,2)),0,'u');
    end
end

isAer = strfind(expName,'Aerobic');
if ~isempty(isAer{1,1})
    isAerobic = true;
    tdata     = 'transcriptomic_aerobic.xlsx';
else
    isAerobic = false;
    tdata     = 'transcriptomic_anaerobic.xlsx';
end
model = modelModifications(model,isAerobic);

%Read transcriptomic data
%[~,trans.names]  = xlsread(tdata,1,'A1:A6000');
%[trans.values,~] = xlsread(tdata,1,'B1:BB6000');
%trans            = preprocess_tdata(trans,model);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%