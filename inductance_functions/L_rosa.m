% Standard Nagaoka formula and Rosa's correction
function L = L_rosa(s,l)

tol = 1e-6;

% Calculation of the Self-Inductance of Single-Layer Coils
% E.B. Rosa 1906

% Based on L_nagaoka()
k = sqrt(s.Dm^2/(s.Dm^2+l^2));
kp = sqrt(1-k^2);
[K,E] = ellipke(k^2);
Kl = 4/(3*pi*kp) * ((kp^2/k^2)*(K-E) + E - k);

mu_0 = 4*pi*1e-7;
Ls = mu_0 * (s.N^2/l) * pi * (s.Dm/2)^2 * Kl;

% Equation 26
% (rewritten to a more general form, 
%    using 0.77880 = e^(-1/4) and 0.22313 = e^(-3/2))
p = l/s.N;
A = 5/4 - log(2*p/s.d);

% Text below equation 27
% k = Rn/n according to Table III
% Rn from equation 13
% --> results in:
B = 0;
for ii = 1:s.N-1
    B = B + (s.N-ii)*gmd(ii);
end
B = (2/s.N)*B;

% Equation 27
% (modified to Henry according to Weaver)
dL = mu_0*s.Rc*s.N*(A+B);

% pp. 172
L = Ls - dL;

    function a = gmd(i)
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