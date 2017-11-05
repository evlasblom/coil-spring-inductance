% Nagaoka approximation according to Wheeler
function L = L_wheeler(s,l,formula)

% (Solenoid Inductance Calculation)
% (D.W. Knight 2013)

% Inductance Formulas for Circular and Square Coils
% H.A. Wheeler 1982

mu_0 = 4*pi*1e-7;
a = s.Rc;
b = l;
n = s.N;

% formula = 5;

switch formula
    case 3
        % Equation 3
        Kl = 1 / (1 + 8/(3*pi)*a/b);
        
        % Equation 1
        L = (mu_0 * n^2 * pi * a^2)/b * Kl;
        
    case 5
        % Equation 5
        L = mu_0*n^2*a*(0.48*log(1+pi*a/b)+0.52*asinh(pi*a/b));
        
    case 6
        % Equation 6
        L = mu_0*n^2*a*(2.78/(b/a+1.1)+log(1+0.39*a/b));
        
end


end