%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% printResults(t,x,expdata)
% Displays the model simulation & experimental results in a 2x2 graph.
%
% INPUTS:
% t             Time vector
% x             Variable vector
% expdata       Experimental data
%
% Benjamín J. Sánchez
% Last Update: 2014-11-23
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function printResults(t,x,expdata)

%Volume
subplot(2,2,1)
hold on
hold all
plot(t,x(:,1),'LineWidth',2)
ylabel('[L]') 
xlabel('time [hours]')
title('Volume')
box on
hold off

%Biomass
subplot(2,2,2)
hold on
hold all
plot(t,x(:,2),'LineWidth',2)
plot(expdata(:,1),expdata(:,3),'o')
legend('Biomass (mod)','Biomass (exp)')
ylabel('[g/L]')
xlabel('time [hours]')
title('Biomass')
box on
hold off

%Glucose & Ethanol
subplot(2,2,3)
hold on
hold all
for k = 3:4
    plot(t,x(:,k),'LineWidth',2)
    plot(expdata(:,1),expdata(:,k+1),'o')
end
legend('Glucose (mod)','Glucose (exp)','Ethanol (mod)','Ethanol (exp)')
ylabel('[g/L]') 
xlabel('time [hours]')
title('Glucose & Ethanol')
box on
hold off

%Glycerol, Citrate & Lactate
subplot(2,2,4)
hold on
hold all
for k=5:7
    plot(t,x(:,k),'LineWidth',2)
    plot(expdata(:,1),expdata(:,k+1),'o')
end
legend('Glycerol (mod)','Glycerol (exp)','Citrate (mod)','Citrate (exp)','Lactate (mod)','Lactate (exp)')
ylabel('[g/L]') 
xlabel('time [hours]')
title('Glycerol, Citrate & Lactate')
box on
hold off

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%