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
%
% William T. Scott, Jr.
% Last Update: 2019-11-22
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function model = kineticConstraints(model,t,x,excRxn,p)

%Parameters used in kineticConstraints:
vmax  = p(1);	%Maximum glucose uptake rate [mmol/gDWh]
Kg    = p(2);	%Glucose saturation constant [g/L]
Ke    = p(3);	%Ethanol inhibition constant [g/L]
vnmax = p(10);  %Maximum ammonium uptake rate [mmol/gDWh]
Kn    = p(11);	%Ammonium saturation constant [g/L]
Kf    = p(12);	%Fructose saturation constant [g/L]
pEtOH = p(13);  %Ethanol specific production rate [fraction of glucose consumption] - BATCH PHASE
pGlyc = p(14);  %Glycerol specific production rate [fraction of glucose consumption] - BATCH PHASE
pCit  = p(15);  %Citrate specific production rate [fraction of glucose consumption] - BATCH PHASE
pMal  = p(16);  %Lactate specific production rate [fraction of glucose consumption] - BATCH PHASE
pSucc = p(17);  %Succinate specific production rate [fraction of glucose consumption] - BATCH PHASE
pAcet = p(18);  %Acetate specific production rate [fraction of glucose consumption] - BATCH PHASE

if feedFunction(t) ~= 0
    vEtOH = p(20);  %Ethanol specific production rate [fraction of glucose consumption] - FEDBATCH PHASE
    %vGlyc = p(18);  %Glycerol specific production rate [fraction of glucose consumption] - FEDBATCH PHASE
    %vCyt  = p(19);  %Cytrate specific production rate [fraction of glucose consumption] - FEDBATCH PHASE
   % vLac  = p(20);  %Lactate specific production rate [fraction of glucose consumption] - FEDBATCH PHASE
   
end

%Glucose uptake, with uncompetitive inhibition by ethanol and competitive
%inhibition between hexoses for each transporter
G  = x(3);      %Glucose [g/L]
E  = x(4);      %Ethanol [g/L]
%GL = x(7);     %Glycerol [g/L]
F  = x(6);      %Fructose [g/L]

if G < 1e-3
    v = 0;
else
    v = vmax*G/(Kg*(1+F/Kf)+G)/(1+E/Ke);   %[mmol/gDWh]
end

%Fructose uptake, with uncompetitive inhibition by ethanol and competitive
%inhibition between hexoses for each transporter

if F < 1e-3
    vf = 0;
else
    vf = vmax*F/(Kf*(1+G/Kg)+F)/(1+E/Ke);   %[mmol/gDWh]
end

%Total sugar flux

vs = vf+v;

%For glycerol and ethanol:
if E < 1e-3
    vEtOH = 0;
end

%if GL < 1e-3
%    vGlyc = 0;
%end

%Nitrogen uptake, with no inhibition by ethanol
N  = x(5);      %Ammonium [g/L]

if N < 1e-7
    vAmmo = 0;
else
    vAmmo = vnmax*N/(Kn+N);   %[mmol/gDWh]
end    


%Assign flux uptake/production rates to model:
model = changeRxnBounds(model,model.rxns(excRxn(3,1)),-v,'b');
model = changeRxnBounds(model,model.rxns(excRxn(5,1)),-vAmmo,'b');
model = changeRxnBounds(model,model.rxns(excRxn(6,1)),-vf,'b');

if feedFunction(t) == 0
    model = changeRxnBounds(model,model.rxns(excRxn(4,1)),vs*pEtOH,'l');    
    model = changeRxnBounds(model,model.rxns(excRxn(7,1)),vs*pGlyc,'l');
    model = changeRxnBounds(model,model.rxns(excRxn(8,1)),-vs*pCit,'l');
    model = changeRxnBounds(model,model.rxns(excRxn(9,1)),-vs*pMal,'l');
    model = changeRxnBounds(model,model.rxns(excRxn(10,1)),vs*pSucc,'l');
    model = changeRxnBounds(model,model.rxns(excRxn(11,1)),vs*pAcet,'l');
else
    model = changeRxnBounds(model,model.rxns(excRxn(4,1)),vEtOH,'l');
%   model = changeRxnBounds(model,model.rxns(excRxn(5,1)),vGlyc,'l');
%   model = changeRxnBounds(model,model.rxns(excRxn(6,1)),vCyt,'l');
%   model = changeRxnBounds(model,model.rxns(excRxn(7,1)),vLac,'l');
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%