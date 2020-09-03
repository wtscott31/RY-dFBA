%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% model = fixedModifications(model,p)
% Modifies model according to the parameters values. This modifications
% will be fixed during the whole integration.
%
% INPUTS:
% model     SBML model used in the simulation
% p         Kinetic parameters
% 
% OUTPUTS:
% model     SBML model used in the simulation (changed)
%
% Benjamín J. Sánchez
% Last Update: 2014-11-23
%
% William T. Scott
% Last Update: 2018-11-04
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function model = fixedModifications(model,p)

%Parameters used in fixedModifications:
prot = p(5);    %Protein fraction [-]
carb = p(6);    %Carbohidrate fraction [-]
lipi = p(7);    %Lipid fraction [-]
RNA = p(8);     %DNA fraction [-]
DNA = p(9);     %RNA fraction [-]
%vATP = p(10);    %Non-Growth ATP maintenance [mmol/gDWh]
% t    = p(9);    %Threshold for expression [# standard deviations below average]
% perc = p(10);   %Arrays that should be below threshold in order to delete gen [%]
%vGAM = p(15);      %Growth-Associated maintenance requirements

%Protein requirements:
XrxnID   = findRxnIDs(model,'r_4041');
protList = {'s_3717[c]'};
% protList = {'s_0404'
%             's_0428'
%             's_0430'
%             's_0432'
%             's_0542'
%             's_0747'
%             's_0748'
%             's_0757'
%             's_0832'
%             's_0847'
%             's_1077'
%             's_1099'
%             's_1148'
%             's_1314'
%             's_1379'
%             's_1428'
%             's_1491'
%             's_1527'
%             's_1533'
%             's_1561'};
protID   = findMetIDs(model,protList);
Svalue   = model.S(protID,XrxnID);
% Svalues  = zeros(size(protList));
% for i = 1:length(protID)
%     Svalues(i) = model.S(protID(i),XrxnID);
% end
model = changeRxnMets(model,protList,protList,'r_4041',prot*Svalue);

%Carbohydrate requirements:
carbList = {'s_3718[c]'};
% carbList = {'s_0001'
%             's_0004'
%             's_0773'
%             's_1107'
%             's_1520'};
carbID   = findMetIDs(model,carbList);
Svalue   = model.S(carbID,XrxnID);
% Svalues  = zeros(size(carbList));
% for i = 1:length(carbID)
%     Svalues(i) = model.S(carbID(i),XrxnID);
% end
model = changeRxnMets(model,carbList,carbList,'r_4041',carb*Svalue);

%RNA requirements:
RNAList = {'s_3719[c]'};
% RNAList = {'s_0423'
%             's_0526'
%             's_0782'
%             's_1545'};
RNAID   = findMetIDs(model,RNAList);
Svalue   = model.S(RNAID,XrxnID);
% Svalues  = zeros(size(RNAList));
% for i = 1:length(RNAID)
%     Svalues(i) = model.S(RNAID(i),XrxnID);
% end
model = changeRxnMets(model,RNAList,RNAList,'r_4041',RNA*Svalue);

%DNA requirements:
DNAList = {'s_3720[c]'};
% DNAList = {'s_0584'
%             's_0589'
%             's_0615'
%             's_0649'};
DNAID   = findMetIDs(model,DNAList);
Svalue   = model.S(DNAID,XrxnID);
% Svalues  = zeros(size(DNAList));
% for i = 1:length(DNAID)
%     Svalues(i) = model.S(DNAID(i),XrxnID);
% end
model = changeRxnMets(model,DNAList,DNAList,'r_4041',DNA*Svalue);

%Lipid requirement:
lipiList = {'s_1096[c]'};
% lipiList = {'s_3746'
%             's_3747'};
lipiID   = findMetIDs(model,lipiList);
Svalue   = model.S(lipiID,XrxnID);
model    = changeRxnMets(model,lipiList,lipiList,'r_4041',lipi*Svalue);

%GAM requirement; 
% GAMList = {'s_0394[c]'
%             's_0434[c]'
%             's_0794[c]'
%             's_0803[c]'
%             's_1322[c]'};
% GAMID   = findMetIDs(model,GAMList);        
% Svalues  = zeros(size(GAMList));
% for i = 1:length(GAMID)
%     Svalues(i) = model.S(GAMID(i),XrxnID);
% end
% model = changeRxnMets(model,GAMList,GAMList,'r_4041',vGAM*Svalues);    


%ATP maintenance requirements (non-growth associated maintenance):
 %model = changeRxnBounds(model,'r_4046',vATP,'l');
 
% %Transcriptomic data:
% tdata = evalin('base','trans');
% [M,N] = size(tdata.values);
% for i = 1:M
%     count = 0;
%     for j = 1:N
%         if tdata.values(i,j) <= tdata.tave(j) - t*tdata.tstd(j)
%             count = count + 1;
%         end
%     end
%     %Delete gen only if a perc% of the arrays have the expression value
%     %t standard deviations below the average:
%     if count/N*100 >= perc
%         model = deleteModelGenes(model,tdata.names(i,1));
%     end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%