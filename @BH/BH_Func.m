function [blackHole, bestSolution, bestCost, allBestCost] = BH_Func(blackHole)
    %% Initialization
    % Crear población inicial
    locationOfStars = repmat(blackHole.varMin, blackHole.numOfStars, 1) + ...
                      repmat(blackHole.varMax - blackHole.varMin, blackHole.numOfStars, 1) ...
                      .* rand(blackHole.numOfStars, blackHole.nVar);

    allBestCost = zeros(blackHole.maxIter,1);
    enableVisualization = (blackHole.nVar == 2);

    % Parámetros de animación GIF
    saveGif     = true;
    gifFilename = 'BH_animation.gif';

    %% Evaluar población inicial y guardar mejor global
    starsCost = ObjectiveFunc(locationOfStars);
    [currentBest, BH_ind] = max(starsCost);
    bestCost     = currentBest;
    bestSolution = locationOfStars(BH_ind, :);
    allBestCost(1) = bestCost;

    %% Main loop
    for iter = 2 : blackHole.maxIter
        % 1) Mover todas las estrellas hacia el agujero negro actual
        locationOfStars = locationOfStars + ...
            (repmat(locationOfStars(BH_ind, :), blackHole.numOfStars, 1) - locationOfStars) ...
            .* rand(blackHole.numOfStars, blackHole.nVar);

        % 2) Evaluar de nuevo
        starsCost = ObjectiveFunc(locationOfStars);
        [currentBest, BH_ind] = max(starsCost);

        % 3) Actualizar mejor global si encontramos algo mejor
        if currentBest > bestCost
            bestCost     = currentBest;
            bestSolution = locationOfStars(BH_ind, :);
        end
        allBestCost(iter) = bestCost;

        %% Visualización (solo nVar == 2)
        if enableVisualization
            figure(100); clf;
            scatter(locationOfStars(:,1), locationOfStars(:,2), 36, 'b', 'filled'); hold on;
            scatter(bestSolution(1),      bestSolution(2),      100, 'r','filled');
            xlabel('X'); ylabel('Y');
            title(sprintf('Iteración %d', iter));
            legend('Estrellas','Black Hole','Location','northeast');
            axis([blackHole.varMin(1), blackHole.varMax(1), ...
                  blackHole.varMin(2), blackHole.varMax(2)]);
            grid on; drawnow; pause(0.001);

            % Guardar frame en GIF
            if saveGif
                frame = getframe(gcf);
                img   = frame2im(frame);
                [A,map] = rgb2ind(img,256);
                if iter == 2
                    imwrite(A,map,gifFilename,'gif','LoopCount',Inf,'DelayTime',1);
                else
                    imwrite(A,map,gifFilename,'gif','WriteMode','append','DelayTime',1);
                end
            end
        end

        %% Horizonte de eventos
        R = bestCost / sum(starsCost);
        distances = sqrt(sum((locationOfStars - locationOfStars(BH_ind,:)).^2, 2));
        % Excluir el índice BH_ind
        idx = find(distances < R & (1:blackHole.numOfStars)' ~= BH_ind);
        for i = idx'
            locationOfStars(i, :) = blackHole.varMin + ...
                (blackHole.varMax - blackHole.varMin) .* rand(1, blackHole.nVar);
        end
    end

    %% Convergencia
    figure;
    semilogx(1:blackHole.maxIter, allBestCost, 'LineWidth', 2);
    title('Convergencia del Costo');
    xlabel('Iteración'); ylabel('Mejor Costo'); grid on;

    %% Visualización final para nVar == 2 (opcional)
    if blackHole.nVar == 2
        figure;
        [X,Y] = meshgrid(linspace(blackHole.varMin(1),blackHole.varMax(1),100), ...
                        linspace(blackHole.varMin(2),blackHole.varMax(2),100));
        Z = ObjectiveFunc([X(:),Y(:)]);
        Z = reshape(Z, size(X));
        surf(X,Y,Z,'EdgeColor','none'); hold on;
        plot3(bestSolution(1), bestSolution(2), bestCost, ...
              'ro','MarkerSize',10,'MarkerFaceColor','r');
        title('Función Objetivo y Mejor Solución');
        xlabel('X'); ylabel('Y'); zlabel('Valor'); view(3); grid on;
        saveas(gcf, 'surface_final_2D.png');
    end
end
