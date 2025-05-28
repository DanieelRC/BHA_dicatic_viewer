clc;
close all;

%% Problem Definition
rng(1);
%numberOfVariable = 10;             % Number of input variables
%lowerBound = -10*ones(1,10);       % Lower Bound of input variables
%higherBound = 10*ones(1,10);       % Higher Bound of input variables

numberOfVariable = 2;
lowerBound = -5 * ones(1, 2);
higherBound = 5 * ones(1, 2);

%% Parameter of BH
numberOfStars = 60; %Number Of Stars
maxIter = 100; %Maximum Number of Iteration

%% Calling
blackHole = BH(numberOfVariable, lowerBound, higherBound, numberOfStars,maxIter);
[blackHole, bestSolution, bestCost, allBestCost] = BH_Func(blackHole);

%% Results
disp(['BestSolution is: ' num2str(bestSolution)]);
disp(['BestCost is: ' num2str(bestCost)]);
h=figure(1);

semilogx(1:maxIter, allBestCost, 'LineWidth', 2);
title('ObjFunc 2 & Seed 5','FontSize',16);
legend('All Best Costs');
xlabel('Iteration');
ylabel('Best Cost');
grid on;

%pause(1)