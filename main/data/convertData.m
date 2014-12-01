%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% convertData(modelName,dataName)
% Generates .mat files with the model and all the experimental data.
% STEP 2 OF THE PROCEDURE (SEE README.MD)
%
% INPUTS:
% modelName     File name of SBML model
% dataName      File name in which the experimental data is (.xls or .xlsx
%               file)
%
% Benjamín J. Sánchez
% Last update: 2014-11-23
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function convertData(modelName,dataName)

%Initialize COBRA
initCobraToolbox

%Load all available data in the file:
i            = 1;
data_missing = 1;
while data_missing
    try
        %Read model
        model = readCbModel(modelName);
        %Read dataset and save it in 
        [model,excMet,excRxn,x0,feed,PM,expdata,trans,weights] = readData(model,dataName,i);
        save(['d' num2str(i) '.mat'],'model','excMet','excRxn','x0','feed','PM','expdata','trans','weights');
        i = i+1;
    catch
        data_missing = 0;
    end
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%