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
%
% William T. Scott, Jr.
% Last Update: 2019-01-31
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function printResults(t,x,expdata)

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

%Ammonium
table(t,x(:,5))
subplot(2,2,1)
hold on
hold all
plot(t,x(:,5),'LineWidth',2)
plot(expdata(:,1),expdata(:,6),'o')
legend('Ammonium (mod)','Ammonium (exp)')
ylabel('[g/L]') 
xlabel('time [hours]')
title('Ammonium')
box on
hold off

%Biomass
table(t,x(:,2))
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

%Glucose, Fructose and Ethanol
table(t,x(:,3))
table(t,x(:,4))
table(t,x(:,5))
subplot(2,2,3)
hold on
hold all
plot(t,x(:,3),'LineWidth',2)
plot(expdata(:,1),expdata(:,4),'o')
plot(t,x(:,6),'LineWidth',2)
plot(expdata(:,1),expdata(:,7),'o')
plot(t,x(:,4),'LineWidth',2)
plot(expdata(:,1),expdata(:,5),'o')
legend('Glucose (mod)','Glucose (exp)','Fructose (mod)','Fructose (exp)','Ethanol (mod)','Ethanol (exp)')
ylabel('[g/L]') 
xlabel('time [hours]')
title('Glucose, Fructose, Ethanol')
box on
hold off

%Glycerol, Citrate, Malate, Succinate, & Acetate
subplot(2,2,4)
hold on
hold all
for k = 7:11
    plot(t,x(:,k),'LineWidth',2)
    plot(expdata(:,1),expdata(:,k+1),'o')
end
legend('Glycerol (mod)','Glycerol (exp)','Citrate (mod)','Citrate (exp)','Malate (mod)','Malate (exp)','Succinate (mod)','Succinate (exp)','Acetate (mod)','Acetate (exp)')
ylabel('[g/L]') 
xlabel('time [hours]')
title('Glycerol, Citrate, Malate, Succinate, Acetate')
box on
hold off

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%