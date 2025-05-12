clc;
clear all;
close all;

%% Problem Definition
rng(1);
%numberOfVariable = 2;          % Number of input variables
%lowerBound = -10*ones(1,10);          % Lower Bound of input variables
%higherBound = 10*ones(1,10);         % Higher Bound of input variables

numberOfVariable = 3;
lowerBound = -4 * ones(1, 3);
higherBound = 4 * ones(1, 3);


%% Parameter of BH
numberOfStars = 1000; %Number Of Stars
maxIter = 150; %Maximum Number of Iteration

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