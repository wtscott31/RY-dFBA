%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% model = kineticConstraints(model,x,excRxn,p)
% Calculate relevant kinetic constraints, as LB or UB for the SBML model
%
% INPUTS:
% model     COBRA model used in the simulation
% x         Concentrations of each variable in the last iteration 
%           ([L] or [g/L])
% excRxn    Numeric matrix with the position in rxns of each
%           exchange reaction (the first row (volume) has zeros)
% p         Kinetic parameters
% 
% OUTPUT:
% model     COBRA model used in the simulation (changed)
%
% Benjamín J. Sánchez
% Last Update: 2014-11-23
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function model = kineticConstraints(model,t,x,excRxn,p)

%Parameters used in kineticConstraints:
vmax  = p(1);	%Maximum glucose uptake rate [mmol/gDWh]
Kg    = p(2);	%Glucose saturation constant [g/L]
Ke    = p(3);	%Ethanol inhibition constant [g/L]
pEtOH = p(11);  %Ethanol specific production rate [fraction of glucose consumption] - BATCH PHASE
pGlyc = p(12);  %Glycerol specific production rate [fraction of glucose consumption] - BATCH PHASE
pCyt  = p(13);  %Cytrate specific production rate [fraction of glucose consumption] - BATCH PHASE
pLac  = p(14);  %Lactate specific production rate [fraction of glucose consumption] - BATCH PHASE
if feedFunction(t) ~= 0
    vEtOH = p(16);  %Ethanol specific production rate [fraction of glucose consumption] - FEDBATCH PHASE
    vGlyc = p(17);  %Glycerol specific production rate [fraction of glucose consumption] - FEDBATCH PHASE
    vCyt  = p(18);  %Cytrate specific production rate [fraction of glucose consumption] - FEDBATCH PHASE
    vLac  = p(19);  %Lactate specific production rate [fraction of glucose consumption] - FEDBATCH PHASE
end

%Glucose uptake, with inhibition by ethanol
G  = x(3);      %glucose [g/L]
E  = x(4);      %ethanol [g/L]
GL = x(5);      %glycerol [g/L]

if G < 1e-3
    v = 0;
else
    v = vmax*G/(Kg+G)/(1+E/Ke);   %[mmol/gDWh]
end

%For glycerol and ethanol:
if E < 1e-3
    vEtOH = 0;
end

if GL < 1e-3
    vGlyc = 0;
end

%Assign flux uptake/production rates to model:
model = changeRxnBounds(model,model.rxns(excRxn(3,1)),-v,'b');
if feedFunction(t) == 0
    model = changeRxnBounds(model,model.rxns(excRxn(4,1)),v*pEtOH,'l');
    model = changeRxnBounds(model,model.rxns(excRxn(5,1)),v*pGlyc,'l');
    model = changeRxnBounds(model,model.rxns(excRxn(6,1)),v*pCyt,'l');
    model = changeRxnBounds(model,model.rxns(excRxn(7,1)),v*pLac,'l');
else
    model = changeRxnBounds(model,model.rxns(excRxn(4,1)),vEtOH,'l');
    model = changeRxnBounds(model,model.rxns(excRxn(5,1)),vGlyc,'l');
    model = changeRxnBounds(model,model.rxns(excRxn(6,1)),vCyt,'l');
    model = changeRxnBounds(model,model.rxns(excRxn(7,1)),vLac,'l');
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%