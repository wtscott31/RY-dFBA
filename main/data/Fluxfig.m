model = changeRxnBounds(model,'r_1992',0,'b');
model = changeRxnBounds(model,'r_1654',-5,'b');
growthRates = zeros(21,1);
for i = 0:35
	model = changeRxnBounds(model,'r_1714',-i,'b');
	FBAsolution = optimizeCbModel(model,'max');
	growthRates(i+1) = FBAsolution.f;
end

x = [0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35];
plot(x,growthRates)
title('Growth Rate versus Glucose Uptake Rate, vAmmo = 5 mmol gDW^-1 hr^-1')
xlabel('Glucose Uptake Rate (mmol gDW^-1 hr^-1)')
ylabel('Growth Rate (hr^-1)')
