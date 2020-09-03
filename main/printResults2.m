%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% printResults2(t,x,expdata)
% Displays the model simulation & experimental results in a 2x2 graph.
%
% INPUTS:
% t             Time vector
% x             Variable vector
% expdata       Experimental data
%
% William T. Scott, Jr.
% Last Update: 2018-05-17
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function printResults2(t,x,k,model)

model  = evalin('base','model');
excMet = evalin('base','excMet');
excRxn = evalin('base','excRxn');
PM     = evalin('base','PM');
feed   = evalin('base','feed');
kfixed = evalin('base','kfixed');
%Volume
%subplot(2,2,1)
%hold on
%hold all
%plot(t,x(:,1),'LineWidth',2)
%ylabel('[L]') 
%xlabel('time [hours]')
%title('Volume')
%box on
%hold off


%Construct p from the fixed values of kfixed and the estimated values of k.
p = zeros(length(kfixed),1);
j = 1;
for i = 1:length(kfixed)
    if isnan(kfixed(i))
        p(i) = k(j);
        j    = j+1;
    else
        p(i) = kfixed(i);
    end    
end

%FBA
FBAsol = solveFBA(model,t,excRxn,p);
%if numel(FBAsol.x) == 0
 %   FBAsol.x = zeros(length(model.rxns),1);
%end


%Ammonium
table(t,x(:,5))
subplot(2,1,1)
hold on
hold all
plot(t,x(:,2),'LineWidth',2)
plot(t,x(:,3),'LineWidth',2)
plot(t,x(:,4),'LineWidth',2)
plot(t,x(:,5),'LineWidth',2)
plot(t,x(:,6),'LineWidth',2)
%plot(expdata(:,1),expdata(:,6),'o')
legend('Biomass (mod)','Glucose (mod)','Ethanol (mod)','Ammonium (mod)','Fructose (mod)')
ylabel('[g/L]') 
xlabel('time [hours]')
title('Metabolites over Time')
box on
hold off

%Fluxes
%table(t,x(:,2))
subplot(2,1,2)
hold on
hold all
plot(t,FBAsol.x(683,1),'LineWidth',2)
plot(t,FBAsol.x(571,1),'LineWidth',2)
plot(t,FBAsol.x(361,1),'LineWidth',2)
plot(t,FBAsol.x(1000,1),'LineWidth',2)
plot(t,FBAsol.x(1001,1),'LineWidth',2)
plot(t,FBAsol.x(1002,1),'LineWidth',2)
plot(t,FBAsol.x(1003,1),'LineWidth',2)
legend('Glycolysis (mod)','TCA (mod)','PPP (mod)','Lipid Metabolism (mod)','Lipid Metabolism (mod)','Lipid Metabolism (mod)','Lipid Metabolism (mod)')
ylabel('[mmol/gDWh]')
xlabel('time [hours]')
title('Fluxes over Time')
box on
hold off

% %Glucose & Fructos
% table(t,x(:,3))
% table(t,x(:,4))
% subplot(2,2,3)
% hold on
% hold all
%plot(expdata(:,1),expdata(:,4),'o')

% %plot(expdata(:,1),expdata(:,7),'o')
% legend('Glucose (mod)','Fructose (mod)')
% ylabel('[g/L]') 
% xlabel('time [hours]')
% title('Glucose, Fructose')
% box on
% hold off

% %Ethanol
% table(t,x(:,5))
% subplot(2,2,4)
% hold on
% hold all
% plot(t,x(:,4),'LineWidth',2)
% %plot(expdata(:,1),expdata(:,5),'o')
% legend('Ethanol (mod)')
% ylabel('[g/L]') 
% xlabel('time [hours]')
% title('Ethanol')
% box on
% hold off

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%