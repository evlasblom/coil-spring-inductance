% Standard Nagaoka formula based on elliptic integrals
function L = L_kirchhoff(s,l)
% Mutual Inductance and Inductance Calculations by Maxwell’s Method
% Antonio Carlos M. de Queiroz 

mu_0 = 4*pi*1e-7;

NN = round(s.N);
ee = l/s.N;
f0 = mu_0 * s.Rc * log((8*s.Rc/s.r)-(7/4));
f0_roza = Fz_roza(s,0);

L_sum = NN*f0;
for ii = 1:NN-1
%     temp = Fz_roza(s,ii*ee);
    L_sum = L_sum + 2*(NN-ii)*Fz(s,ii*ee);
end

L = L_sum;

function out = Fz_roza(s,z)
mu_0 = 4*pi*1e-7;
if z ~= 0
    out  = mu_0*s.Rc*([1+(3/16)*(z^2/s.Rc^2)]*log(8*s.Rc/z) - 2.0 - (1/16)*(z^2/s.Rc^2));
else
    z    = s.r;
    out  = mu_0*s.Rc*((1+ (1/8)*(z^2/s.Rc^2))*log(8*s.Rc/z) - 1.75+ (1/24)*(z^2/s.Rc^2));
end

function out = Fz(s,z)
mu_0 = 4*pi*1e-7;
k2   = 4*s.Rc^2/(z^2 + 4*s.Rc^2);
[K,E]= ellipke(k2);
out  = mu_0*(s.Rc/sqrt(k2))*((2-k2)*K-2*E);
