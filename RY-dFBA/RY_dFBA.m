%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RY_dFBA(dataset)
% Main function to use, performs a complete analysis of the model for a
% given dataset. STEP 3 OF THE PROCEDURE (SEE README.MD)
%
% INPUTS:
% dataset       Number indicating wich sheet will be analyzed
%
% Benjamín J. Sánchez
% Last Update: 2014-11-29
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function RY_dFBA(dataset)

%(1) Perform a parameter estimation and pre/post regression analysis with
%    no parameters fixed. If everything goes ok, a file called
%    "it_results_d[i]_pre.mat" should appear in the main folder, with all
%    results from the iteration.
if sum(ismember([1 2 3 5 7 9 10 12],dataset))
    K = 19;
else
    K = 14;
end
iteration_complete(dataset,NaN(1,K));

%(2) Perform the reparametrization procedure, generating all possible
%    solutions with no sensitivity/identifiability problems. If everything
%    goes ok, a file called "it_d[i].mat" should appear in the main folder,
%    with all results from the reparametrization.
reparam_dFBA(dataset,K);

%(3) Calculate significance for all aforementioned combinations, and
%    discards the ones that have an insignificant parameter. If everything
%    goes ok, a file called "cmp_d[i].mat" should appear in the main
%    folder, with all the CC's of each solution.
cmp_group = recalculate_CC(dataset);
m         = length(cmp_group.codes);
del_pos   = zeros(1,m);
for i = 1:m
    if isnan(cmp_group.CC(i))
        del_pos(i) = 1;
    end
end
cmp_group.CC(find(del_pos),:)    = [];
cmp_group.codes(find(del_pos),:) = [];
cmp_group.sols(find(del_pos),:)  = [];

%(4) Repeat the parameter estimation and the pre/post regression analysis
%    on the best solution found. If everything goes ok, a file called
%    "it_results_d[i]_post.mat" should appear in the main folder, with all
%    results from the iteration.
best = 1;
for i = 2:length(cmp_group.codes)
    if cmp_group.CC(i) < cmp_group.CC(best)
        best = i;
    end
end
iteration_complete(dataset,cmp_group.sols(best,:));

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%