% Standard Nagaoka formula based on elliptic integrals
function L = L_nagaoka(s,l)

% (Numerical Methods for Inductance Calculations (web))
% (R. Weaver 2012)

% (Solenoid Inductance Calculation)
% (D.W. Knight 2013)

% The Inductance Coefficients of Solenoids
% H. Nagaoka 1909

% Equation 17
k = sqrt(s.Dm^2/(s.Dm^2+l^2));
kp = sqrt(1-k^2);
[K,E] = ellipke(k^2);
Kl = 4/(3*pi*kp) * ((kp^2/k^2)*(K-E) + E - k);

% Equation 18 
% (modified to Henry according to Weaver)
mu_0 = 4*pi*1e-7;
L = mu_0 * (s.N^2/l) * pi * (s.Dm/2)^2 * Kl;

end