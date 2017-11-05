% Standard inductance formula
function L = L_basic(s,l)

% Physics for Scientist and Engineers 9th
% R.A. Serway, J.W. Jewett

% Page 905, equation 30.2
mu_0 = 4*pi*1e-7;

% Page 972, equation 32.4
L = mu_0 * (s.N^2/l) * pi * s.Rc^2;

end