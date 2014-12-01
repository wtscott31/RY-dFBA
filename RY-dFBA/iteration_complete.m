%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% it_results = iteration_complete(dataset,kfixed)
% Does a complete iteration of the procedure, including parameter
% estimation and all the pre/post-regression analysis metrics.
%
% INPUTS:
% dataset       Number indicating wich sheet will be analyzed
% kfixed        Vector indicating which parameters are fixed. Complete the
%               rest of the parameters with NaN
%
% OUTPUT:
% it_results    Structure containing all iteration results
%
% Benjamín J. Sánchez
% Last Update: 2014-11-29
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function it_results = iteration_complete(dataset,kfixed)

%Initialize SSm
cd SSm
ssm_startup
cd ..

initCobraToolbox

%Define initial variables and constraints
cd data
load(['d' num2str(dataset) '.mat'],'model','excMet','excRxn','x0','feed','PM','expdata','trans','weights');
cd ..
    
assignin('base','model',model);
assignin('base','excMet',excMet);
assignin('base','excRxn',excRxn);
assignin('base','x0',x0);
assignin('base','PM',PM);
assignin('base','feed',feed);
assignin('base','Vout',expdata(:,1:2));
assignin('base','dataset',dataset);
assignin('base','trans',trans);
assignin('base','skip_delays',true);

%========================= PROBLEM SPECIFICATIONS=========================

problem.f = 'minSquares';  %Objective function (.m file)

%     vmax  Kg     Ke     f    a    c    l    vATP  t  perc  pEtOH  pGlyc  pCyt   pLac
kL = [1     0.005  0.005  0.1  0.5  0.5  0.5  0     0  75    0      0      0      0];
k0 = [10    0.05   20     0.7  1    1    1    0     6  100   1.7    0      0      0];
kU = [50    10     50     1    3    3    3    5     6  100   2      1      0.258  1];

%Include f2 and other yields if dataset is aerobic
if sum(ismember([1:3,5,7,9,10,12],dataset)) == 1
    %           f2   vEtOH2  vGlyc2  vCyt2  vLac2
    kL = [kL    0.1  -10     -10     0      0  ];
    k0 = [k0    1    0       0       0      0  ];
    kU = [kU    1    10      0       10     10 ];
end

%Decide the parameters to be estimated depending on kfixed:
m = length(kfixed);
j = 1;
for i = 1:m
    if isnan(kfixed(i))
        problem.x_L(j) = kL(i);
        problem.x_0(j) = k0(i);
        problem.x_U(j) = kU(i);
        j = j+1;
    end    
end

%Problem specifications:
opts.maxeval      = 3000;
opts.local.n1     = 3000;    
opts.maxtime      = 1e5;
opts.strategy     = 3;
opts.local.solver = 'n2fb';
opts.local.finish = 'lsqnonlin';

%========================== DATA EXPERIMENTAL ============================

texp    = expdata(:,1);
ydata   = expdata(:,3:8);
weights = weights(:,3:8);
assignin('base','texp',texp);
assignin('base','ydata',ydata);
assignin('base','weights',weights);

%================================== OPTIMIZATION =========================

assignin('base','kfixed',kfixed);
time1   = tic;
results = ess_kernel(problem,opts,texp,ydata);
t1      = toc(time1);

%============================= RESULTS ===================================

k_SS       = results.xbest;
simTime    = texp(length(texp));
odeoptions = odeset('RelTol',1e-3,'AbsTol',1e-3,'MaxStep',0.7,'NonNegative',1:length(x0));

time2 = tic;
if feedFunction(20)==0
    %Batch fermentation, works faster with ode113
    [t,x] = ode113(@pseudoSteadyState,[0 simTime],x0,odeoptions,k_SS);
else
    %Fed-Batch fermentation, works faster with ode15s
    [t,x] = ode15s(@pseudoSteadyState,[0 simTime],x0,odeoptions,k_SS);
end
t2 = toc(time2);

%Save fitting results as a figure
printResults(t,x,expdata)
saveas(gcf,['fitting_d' num2str(dataset) '.fig'])

%======================== REGRESSION ANALYSIS ============================

close all
time3 = tic;
[AICc,CI_SS,CC_SS,Mc,Ms,diff] = reg_analysis_complete(k_SS);
t3    = toc(time3);

%Adjust the results to easier integration with Excel:
k  = zeros(1,m);
CC = zeros(1,m);
CI = zeros(1,m);
j  = 0;
for i = 1:m
    if isnan(kfixed(i))
        j     = j+1;
        k(i)  = k_SS(j);
        CC(i) = CC_SS(j);
        CI(i) = CI_SS(j);
    end    
end

%============================== SAVE RESULTS =============================

it_results.kfixed     = kfixed;
it_results.k_SS       = k;
it_results.J_SS       = results.fbest;
it_results.AICc       = AICc;
it_results.CI         = CI;
it_results.CC         = CC;
it_results.Mc         = Mc;
it_results.Ms         = Ms;
it_results.diff       = diff;
it_results.time       = [t1;t2;t3];
it_results.ess_report = load('ess_report.mat');
it_results.ktofix     = decision(Mc,Ms);

if j == length(kfixed)
    save(['it_results_d' num2str(dataset) '_pre.mat'],'it_results');
else
    save(['it_results_d' num2str(dataset) '_post.mat'],'it_results');
end

%Delete other files:
delete('Sensib*')
delete('Mc.txt')
delete('GraficoBarra.txt')
delete('checkpoint.mat')
delete('ess_report.mat')
close all
set(0,'ShowHiddenHandles','on');delete(get(0,'Children'))

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%