% Nagaoka approximation according to Lundin
function [L,kl] = L_lundin(s,l)

% (Solenoid Inductance Calculation)
% (D.W. Knight 2013)

% A Handbook Formula for the Inductance of a Single-Layer Circular Coil
% R. Lundin 1985

mu_0 = 4*pi*1e-7;

% Equation 11
x    = 4*s.Rc^2/l^2;
kl   = Fl(x) - 4*2*s.Rc/(3*pi*l);

% Equation 9
L    = kl*(mu_0*s.N^2*pi*s.Rc^2)/l;

    function out = Fl(x)
        out = (1+0.383901*x + 0.017108*x^2)/(1+0.258952*x);
    end

end