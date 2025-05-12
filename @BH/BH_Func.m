function [blackHole, bestSolution, blackHoleCost, allBestCost] = BH_Func(blackHole)

%% Initialization
locationOfStars = repmat(blackHole.varMin ,blackHole.numOfStars,1) + ...
    repmat(blackHole.varMax - blackHole.varMin ,blackHole.numOfStars,1) .* ...
    rand(blackHole.numOfStars,blackHole.nVar);

allBestCost = zeros(blackHole.maxIter,1);

enableVisualization = (blackHole.nVar >= 2);

% Configuración para guardar GIF
saveGif = true;
gifFilename = 'BH_animation.gif';

%% Main loop
for iter = 1:blackHole.maxIter
    starsCost = ObjectiveFunc(locationOfStars);
    [blackHoleCost, BH_ind] = max(starsCost);

    locationOfStars = locationOfStars + ...
        (repmat(locationOfStars(BH_ind), blackHole.numOfStars, blackHole.nVar) - locationOfStars) ...
        .* rand(blackHole.numOfStars, blackHole.nVar);

    starsCost = ObjectiveFunc(locationOfStars);

    if blackHoleCost < max(starsCost)
        [blackHoleCost, BH_ind] = max(starsCost);
    end

    allBestCost(iter) = blackHoleCost;

    %% Visualización animada por iteración
    if enableVisualization
        figure(100); clf;
        if blackHole.nVar == 2
            scatter(locationOfStars(:,1), locationOfStars(:,2), 36, 'b', 'filled'); hold on;
            scatter(locationOfStars(BH_ind,1), locationOfStars(BH_ind,2), 100, 'r', 'filled');
            xlabel('X'); ylabel('Y');
            title(['Iteración ', num2str(iter), ' - Convergencia']);
            legend('Estrellas', 'Agujero Negro');
            axis([blackHole.varMin(1), blackHole.varMax(1), ...
                  blackHole.varMin(2), blackHole.varMax(2)]);
        elseif blackHole.nVar >= 3
            scatter3(locationOfStars(:,1), locationOfStars(:,2), locationOfStars(:,3), 36, 'b', 'filled'); hold on;
            scatter3(locationOfStars(BH_ind,1), locationOfStars(BH_ind,2), locationOfStars(BH_ind,3), 100, 'r', 'filled');
            xlabel('X'); ylabel('Y'); zlabel('Z');
            title(['Iteración ', num2str(iter), ' - Convergencia 3D']);
            legend('Estrellas', 'Agujero Negro');
            axis([blackHole.varMin(1), blackHole.varMax(1), ...
                  blackHole.varMin(2), blackHole.varMax(2), ...
                  blackHole.varMin(3), blackHole.varMax(3)]);
            view(3);
        end
        grid on;
        drawnow;
        pause(0.001);

        % Guardar frame en GIF
        if saveGif
            frame = getframe(gcf);
            img = frame2im(frame);
            [A,map] = rgb2ind(img,256);
            if iter == 1
                imwrite(A,map,gifFilename,'gif','LoopCount',Inf,'DelayTime',1);
            else
                imwrite(A,map,gifFilename,'gif','WriteMode','append','DelayTime',1);
            end
        end
    end

    %% Horizonte de eventos
    if iter < blackHole.maxIter
        R = blackHoleCost / sum(starsCost);
        distances = sqrt(sum((locationOfStars - repmat(locationOfStars(BH_ind), blackHole.numOfStars, 1)).^2, 2))';
        crosserStarsInd = find(distances < R);
        for i = 1:length(crosserStarsInd)
            locationOfStars(crosserStarsInd(i), :) = ...
                blackHole.varMin + (blackHole.varMax - blackHole.varMin) .* rand(1, blackHole.nVar);
        end
    end
end

bestSolution = locationOfStars(BH_ind,:);
disp(['BH_index is ', num2str(BH_ind)]);

%% Gráfica de convergencia
figure;
semilogx(1:blackHole.maxIter, allBestCost, 'LineWidth', 2);
title('Convergencia del Costo');
xlabel('Iteración'); ylabel('Mejor Costo'); grid on;

%% Visualización final de la función y mejor solución
if blackHole.nVar == 2
    figure;
    [X, Y] = meshgrid(linspace(blackHole.varMin(1), blackHole.varMax(1), 100), ...
                      linspace(blackHole.varMin(2), blackHole.varMax(2), 100));
    V = [X(:), Y(:)];
    Z = ObjectiveFunc(V);
    Z = reshape(Z, size(X));
    surf(X, Y, Z, 'EdgeColor', 'none'); hold on;
    plot3(bestSolution(1), bestSolution(2), ObjectiveFunc(bestSolution), ...
        'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
    title('Función Objetivo con Mejor Solución');
    xlabel('X'); ylabel('Y'); zlabel('Valor');
    view(3); grid on;
    saveas(gcf, 'surface_final_2D.png');
elseif blackHole.nVar == 3
    figure;
    fixed_z = bestSolution(3);  % corte en z óptimo
    [X, Y] = meshgrid(linspace(blackHole.varMin(1), blackHole.varMax(1), 100), ...
                      linspace(blackHole.varMin(2), blackHole.varMax(2), 100));
    Zplane = fixed_z * ones(size(X));
    V = [X(:), Y(:), Zplane(:)];
    Fval = ObjectiveFunc(V);
    Fval = reshape(Fval, size(X));
    surf(X, Y, Fval, 'EdgeColor', 'none'); hold on;
    plot3(bestSolution(1), bestSolution(2), ObjectiveFunc(bestSolution), ...
        'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
    title(['Corte de f(x,y,z) en z = ', num2str(fixed_z)]);
    xlabel('X'); ylabel('Y'); zlabel('Valor');
    view(3); grid on;
    saveas(gcf, 'surface_final_3D.png');
end

end