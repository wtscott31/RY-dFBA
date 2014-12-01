%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [t,x] = run_dFBA(dataset,k)
% Simulates a batch or fed-batch run of the procedure, for a given set of
% parameters.
%
% INPUTS:
% dataset       Number indicating wich sheet will be analyzed
% k             Parameter values
%
% OUTPUTS:
% t             Time vector of the simulation
% x             Temporal evolution of variables: First column is volume
%               (in [L]), the rest is metabolites ordered as DATA.xls
%               indicates (in [g/L])
%
% Benjamín J. Sánchez
% Last Update: 2014-11-25
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [t,x] = run_dFBA(dataset,k)

%Initialize COBRA
initCobraToolbox

%Exp data:
cd data
load(['d' num2str(dataset) '.mat'],'model','excMet','excRxn','x0','feed','PM','expdata','trans','weights');
cd ..

[t,~]   = size(expdata);
simTime = expdata(t,1);
kfixed  = NaN(size(k));

assignin('base','model',model)
assignin('base','excMet',excMet)
assignin('base','excRxn',excRxn)
assignin('base','x0',x0)
assignin('base','feed',feed)
assignin('base','PM',PM)
assignin('base','Vout',expdata(:,1:2))
assignin('base','dataset',dataset)
assignin('base','trans',trans)
assignin('base','skip_delays',false)
assignin('base','kfixed',kfixed)
assignin('base','t_limit',100)
assignin('base','expdata',expdata)

%Integrate
odeoptions = odeset('RelTol',1e-3,'AbsTol',1e-3,'MaxStep',0.7,'NonNegative',1:length(x0));
total_time = tic;

if feedFunction(20)==0
    %Batch fermentation, works faster with ode113
    [t,x]=ode113(@pseudoSteadyState,[0 simTime+2],x0,odeoptions,k);
else
    %Fed-Batch fermentation, works faster with ode15s
    [t,x]=ode15s(@pseudoSteadyState,[0 simTime+2],x0,odeoptions,k);
end
clear pseudoSteadyState

%Show results
disp(['Simulation time: ',num2str(toc(total_time)),' seconds'])
printResults(t,x,expdata)

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%