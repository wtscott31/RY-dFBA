growthRates = zeros(21);
for i = 0:20
	for j = 0:20
		model = changeRxnBounds(model,'r_1654',-i,'b');
		model = changeRxnBounds(model,'r_1714',-j,'b');
		FBAsolution = optimizeCbModel(model,'max');
		growthRates(i+1,j+1) = FBAsolution.f;
	end
end

X = [0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20];
Y = [0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20];
surf(X,Y,growthRates)
title('Phase Plane of Ammonium Uptake and Glucose Uptake')
xlabel('           Ammonium Uptake Rate (mmol gDW^-1 hr^-1)')
ylabel('Glucose Uptake Rate (mmol gDW^-1 hr^-1)            ')
zlabel('Growth Rate (hr^-1)')