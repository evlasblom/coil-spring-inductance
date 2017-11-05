% Inductance of a solenoid by Maxwell’s method.
function L = L_maxwell(s,l)
% (Mutual Inductance and Inductance Calculations by Maxwell's Method)
% (A.C.M. de Queiroz 2005)

% A Treatise on Electricity and Magnetism II
% J.C. Maxwell, 1873

Ntrue = s.N;
N = round(s.N);
r = s.r;
R = s.Rc;
D = s.Dm;
p = l/Ntrue;

M = 0;
L = 0;
h_ii = 0;
mu_0 = 4*pi*1e-7;

% Art. 693 Geometric Mean Distance
gmd = r*exp(-1/4);

% Art. 701 Find M by Elliptic Integrals
for ii = 1:N
    if ii == 1
        b = gmd;
        k = sqrt(D^2/(D^2+(b)^2));
        [K,E] = ellipke(k^2);
        Ll = -mu_0*R*((k-2/k)*K+(2/k)*E);

        L = Ntrue*Ll;
    else
        b = h_ii;
        k = sqrt(D^2/(D^2+(b)^2));
        [K,E] = ellipke(k^2);
        Ml = -mu_0*R*((k-2/k)*K+(2/k)*E);

        M = M + 2*(N-(ii-1))*Ml;
    end
    h_ii = h_ii+p;
end
L = M + L;


end