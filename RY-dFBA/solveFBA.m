%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FBAsol = solveFBA(model,t,excRxn,p);
% Solves the LP problem of finding the fluxes via FBA. Maximizes biomass
% formation rate and minimizes absolute flux sum (Schuetz 2012).
%
% INPUTS:
% model     COBRA model used in the simulation
% t         Time of simulation [h]
% excRxn    Numeric matrix with the position in rxns of each
%           exchange reaction (the first row (volume) has zeros)
% p         Kinetic parameters
% 
% OUTPUT:
% FBAsol    FBA solution
%
% Benjamín J. Sánchez
% Last Update: 2014-11-28
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function FBAsol = solveFBA(model,t,excRxn,p)

%Parameters used in solveFBA:
if feedFunction(t) == 0
    f = p(4);   %Fraction of optimum growth that cell follows - BATCH[-]
else
    f = p(15);  %Fraction of optimum growth that cell follows - FEDBATCH [-]
end

%Maximize Biomass
FBAsol_X = optimizeCbModel(model);
if isempty(FBAsol_X.x)
    FBAsol_X.x = zeros(length(model.rxns),1);
end

% Fix Biomass formation rate in f%
model = changeRxnBounds(model,model.rxns(excRxn(2,1)),FBAsol_X.x(excRxn(2,1))*f,'b');

%Minimize sum of absolut fluxes
QPproblem.A      = model.S;
QPproblem.b      = model.b;
N                = length(model.rxns);
QPproblem.F      = eye(N);                  %Objective quadratic term
QPproblem.c      = zeros(N,1);              %Objective linear term
QPproblem.ub     = model.ub;
QPproblem.lb     = model.lb;
QPproblem.osense = +1;                      %minimization
QPproblem.csense = 'E';                     %Equality constraints
FBAsol_min       = solveCobraQP(QPproblem);

%Generates error if FBA does not find a feasible solution:
if FBAsol_X.stat~=1 || FBAsol_min.stat~=1
    disp('ERROR! FBA is not converging')
else
    disp(['Iteration achieved at t = ',num2str(t),' h'])
end

%Returns the QP solution:
FBAsol   = FBAsol_X;
FBAsol.x = FBAsol_min.full;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%