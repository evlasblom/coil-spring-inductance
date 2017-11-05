% Inductance of a solenoid by Maxwell’s method
function L = L_maxwell_tmp(s,l)

tol = 1e-6;

Ntrue = s.N;
N = round(s.N);
r = s.r;
R = s.Rc;
D = s.Dm;
p = l/Ntrue;

mu_0 = 4*pi*1e-7;

M = 0;
L = 0;
h_ii = 0;%r+p/2;
for ii = 1:N
    if ii == 1
%         gmd = r;
%         %gmd = r*exp(-3/2);
%         % Ll = mu_0*R*((1+1/8*gmd^2/R^2)*log(8*R/gmd)-1.75-1/12*gmd^2/R^2);
%         Ll = mu_0*R*((1+3/16*gmd^2/R^2)*log(8*R/gmd)-2-1/16*gmd^2/R^2);
        
        gmd = r*exp(-1/4);
        k = 2*R/sqrt((2*R)^2+(gmd)^2);
        [K,E] = ellipke(k^2);
        Ll = -mu_0*R*((k-2/k)*K+(2/k)*E);

        L = Ntrue*Ll;
    else
%         gmd = h_ii;
%         %logR_ii = (ii+1)^2/2*log(ii+1)*h_ii-ii^2*log(ii*h_ii)+(ii-1)^2/2*log(ii-1)*h_ii-3/2;
%         %logR_ii = log(ii) + gmd_func(ii);
%         %gmd = exp(logR_ii);
%         Ml = mu_0*R*((1+3/16*gmd^2/R^2)*log(8*R/gmd)-2-1/16*gmd^2/R^2);
        
        gmd = h_ii;
        k = 2*R/sqrt((2*R)^2+(gmd)^2);
        [K,E] = ellipke(k^2);
        Ml = -mu_0*R*((k-2/k)*K+(2/k)*E);

        M = M + 2*(N-(ii-1))*Ml;
    end
    h_ii = h_ii+p;
end
L = M + L;

    function a = gmd_func(i)
        % Returns: a = log(Ri) - log(i), where Ri is the geometric mean
        % difference between i windings.
        a = 0;
        j = 1;
        res = 2*tol;
        while res > tol
            % an = a + 1/((j+1)*(2*j)*(2*j+1)*i^(2*j)); % <- Weaver
            frac = 1/(2*j) + 1/(2*j+2) - 2/(2*j+1); % <- own
            an = a + frac*i^(-2*j);
            res = abs(an - a);
            a = an;
            j = j+1;
        end
    end


end