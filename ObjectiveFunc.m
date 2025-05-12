function Z = ObjectiveFunc(V)
    x = V(:,1);
    y = V(:,2);
    z = V(:,3);

    % FUNCIONES DE OPTIMIZACIÓN EN 3 VARIABLES

    % 1. Función Esférica
    % f(x, y, z) = x^2 + y^2 + z^2
    % Máximo global (al invertir el signo): en x = y = z = 0, f = 0
    % Z = -(x.^2 + y.^2 + z.^2);

    % 2. Función Lineal
    % f(x, y, z) = x + 2y + 3z
    % Z = (x + 2*y + 3*z);

    % 3. Función con interacción entre variables
    % f(x, y, z) = xy + yz + zx
    % Z = -(x.*y + y.*z + z.*x);

    % 4. Función cúbica polinómica
    % f(x, y, z) = x^2*y + y*z^2 + z*x^2
    % Z = -(x.^2.*y + y.*z.^2 + z.*x.^2);

    % 5. Función Logarítmica
    % f(x, y, z) = ln(x^2 + y^2 + z^2 + 1)
    % Z = log(x.^2 + y.^2 + z.^2 + 1);

    % 6. Función trigonométrica básica
    % f(x, y, z) = sin(x) + cos(y) + sin(z)
    % Z = (sin(x) + cos(y) + sin(z));

    % 7. Función trigonométrica compuesta
    % f(x, y, z) = sin(xy) + cos(yz) + sin(zx)
    % Z = (sin(x.*y) + cos(y.*z) + sin(z.*x));

    % 8. Función cuadrática con término lineal (cóncava)
    % f(x, y, z) = -x^2 - y^2 - z^2 + 4x + 6y + 2z
    %Z = (-x.^2 - y.^2 - z.^2 + 4*x + 6*y + 2*z);

    % 9. Función Ackley en 3D
    % f(x, y, z) = -20 * exp(-0.2 * sqrt((x^2 + y^2 + z^2)/3))
    %             - exp((cos(2πx) + cos(2πy) + cos(2πz))/3) + 20 + e
    Z = -(-20 * exp(-0.2 * sqrt((x.^2 + y.^2 + z.^2)/3)) ...
         - exp((cos(2*pi*x) + cos(2*pi*y) + cos(2*pi*z))/3) + 20 + exp(1));

    % === FIN ===
end
