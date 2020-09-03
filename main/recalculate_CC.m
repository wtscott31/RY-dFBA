%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cmp_group = recalculate_CC(dataset)
% Calculates for all solutions of the reparametrization the CCs, and
% discards the ones that have any CC > 2.
%
% INPUTS:
% dataset       Dataset to check (NOTE: the file "it_dXX.mat" must be
%               present in the folder)
%
% OUTPUTS:
% cmp_group     All reparametrizations with no sensitivity,
%               identifiability and significance problems.
%
% Benjamín J. Sánchez
% Last update: 2014-11-29
%
% William T. Scott, Jr.
% Last Update: 2019-01-02
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function cmp_group = recalculate_CC(dataset)

load(['it_d' num2str(dataset) '.mat']);
assignin('base','it',it);
n = length(it.codes{1,1});

cmp_group.codes = find_best(dataset);
m               = length(cmp_group.codes);
cmp_group.sols  = zeros(m,n);
cmp_group.CC    = zeros(m,1);

%Initialize COBRA
initCobraToolbox

%Define initial variables and constraints
cd data
data = load(['d' num2str(dataset) '.mat'],'model','excMet','excRxn','x0','feed','PM','expdata','weights');
cd ..
texp    = data.expdata(:,1);
ydata   = data.expdata(:,3:12);
weights = data.weights(:,3:12);
assignin('base','texp',texp);
assignin('base','ydata',ydata);
assignin('base','weights',weights);
assignin('base','model',data.model);
assignin('base','excMet',data.excMet);
assignin('base','excRxn',data.excRxn);
assignin('base','x0',data.x0);
assignin('base','feed',data.feed);
assignin('base','PM',data.PM);
assignin('base','Vout',data.expdata(:,1:2));
assignin('base','dataset',dataset);
%assignin('base','trans',data.trans);
assignin('base','skip_delays',false);

for i = 1:m
    %Calculate CC:
    fixed_values = it.codes{1,2}.k_SS;
    kfixed       = it.codes{cmp_group.codes(i),2}.kfixed;
    CC           = reg_analysis_onlyCC(fixed_values,kfixed);
    
    %Discard analysis if any CC is NaN or larger than 2:
    discard = false;
    for j = 1:length(kfixed)
        if isnan(CC(j)) || abs(CC(j)) > 2
            discard = true;
        end
    end
    
    %Update cmp_group:
    cmp_group.sols(i,:) = kfixed;
    
    if discard
        cmp_group.CC(i) = NaN;
    else
        N = 0;
        for j = 1:length(kfixed)
            if isnan(kfixed(j))
                N = N+1;
            end
        end
        cmp_group.CC(i) = sum(CC)/N;
    end
    
    save(['cmp_d' num2str(dataset) '.mat'],'cmp_group');
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%