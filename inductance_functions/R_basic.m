function R = R_basic(s,l)

% arc length of a helix
al = sqrt((2*pi*s.N*s.Rc)^2 + l^2);

% cross area wire
A = 2*pi*s.r^2;

% resistivity piano wire
R = s.rho*al/A;

end