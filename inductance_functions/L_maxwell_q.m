% Inductance of a solenoid by Maxwell’s method, Queiroz' implementation.
function L = L_maxwell_q(s,l)
% (Mutual Inductance and Inductance Calculations by Maxwell's Method)
% (A.C.M. de Queiroz 2005)

% A Treatise on Electricity and Magnetism II
% J.C. Maxwell, 1873

d = s.d;
r = s.r;
R = s.Rc;
NN = round(s.N);
mu_0 = 4*pi*1e-7;

% Art. 693 Geometric Mean Distance
RM = (d/2)*exp(-0.25); 

% Art. 701 Find M by Elliptic Integrals
p = l/NN;
h_ii = p/2;%r+p/2;
h_1 = p/2;%r+p/2;
for ii = 1:NN 
    k = 2*R/sqrt((2*R)^2+(h_ii-h_1-RM)^2);
    [K,E] = ellipke(k^2);
    turn1 = -mu_0*R*((k-2/k)*K+(2/k)*E);
    if ii == 1 
        L = NN*turn1;
    else 
        k = 2*R/sqrt((2*R)^2+(h_ii-h_1+RM)^2);
        [K,E] = ellipke(k^2);
        turn2 = -mu_0*R*((k-2/k)*K+(2/k)*E);
        L = L+(NN-(ii-1))*(turn1+turn2);
    end
    h_ii = h_ii+p;
end

end