function Z = ObjectiveFunc(V)
    % Función para n variables (signo - para minimizar)
    Z1 = (sum(V.^2, 2));
    Z2 = -(V(:,1).^2 + (10^6)*sum(V(:,2:end).^2,2));
    
    %Variables auxiliares
    x = V(:,1);
    y = V(:,2);
    z0 = 2.5;  

    % 1) Función Esférica
    Z3 = -(x.^2 + y.^2 + z0^2);

    % 2) Función Lineal
    Z4 = (x + 2.*y + 3.*z0);

    % 3) Interacción entre variables
    Z5 = -( x.*y + y.*z0 + z0.*x );

    % 4) Cúbica polinómica
    Z6 = -( x.^2.*y + y.*z0.^2 + z0.*x.^2 );

    % 5) Logarítmica
    Z7 = log( x.^2 + y.^2 + z0.^2 + 1 );

    % 6) Trigonométrica básica
    Z8 = sin(x) + cos(y) + sin(z0);

    % 7) Trigonométrica compuesta
    Z9 = sin(x.*y) + cos(y.*z0) + sin(z0.*x);

    % 8) Cuadrática con término lineal (cóncava)
    Z10 = -(x.^2 + y.^2 + z0^2) + 4.*x + 6.*y + 2.*z0;

    % 9) Ackley
    %     f = -20*exp(-0.2*sqrt((x^2+y^2+z^2)/3)) ...
    %         - exp((cos(2πx)+cos(2πy)+cos(2πz))/3) + 20 + e
    Z11 = -(-20*exp(-0.2*sqrt((x.^2 + y.^2 + z0.^2)/3)) ...
         - exp((cos(2*pi*x) + cos(2*pi*y) + cos(2*pi*z0))/3) ...
         + 20 + exp(1));
    %Aquí se elige la función objetivo
    Z= Z11;
end
