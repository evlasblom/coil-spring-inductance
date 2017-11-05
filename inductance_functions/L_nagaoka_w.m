% Standard Nagaoka formula based Weaver's implementation
function L = L_nagaoka_w(s,l)
% Numerical Methods for Inductance Calculations (web)
% R. Weaver 2012

% // returns Nagaoka's coefficient,
% // aka: field non-uniformity coefficient
% // where u=diameter/length
u = s.Dm/l;
if u == 0
    Kl = 1;
else
    uu =u*u;
    m = uu/(1+uu);
    m2 = 4*sqrt(1+uu);
    a = 1;
    b = sqrt(1-m);
    c =a-b;
    ci = 1;
    cs = c*c/2+m;
    co = c;
    while c < co
        ao = (a+b)/2;
        b = sqrt(a*b);
        a = ao;
        co = c;
        c = (a-b);
        cs = cs + ci*c*c;
        ci = ci*2;
    end
    cs = cs/2;
    K = pi/(a+a);
    KmE = K*cs;
    E = K*(1-cs);
    Kl = (1/(3*pi)*(m2/uu*(KmE)+m2*E-4*u));
end

mu_0 = 4*pi*1e-7;

L = mu_0 * (s.N^2/l) * pi * (s.Dm/2)^2 * Kl;


end