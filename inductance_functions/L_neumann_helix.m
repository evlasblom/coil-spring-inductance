function HeliCoilS = L_neumann_helix(s,Lc,MaxErr)
% Uses helical filament mutual inductance formula evaluated using
% Simpson's rule, and conductor gmd
%  N       = total number of windings
%  Lc      = length of coil
%  r       = radius of winding
%  dw  	   = wire diameter
%  MaxErr  = max allowable error

comments = 0;
Rc = s.Rc;
N  = s.N;
dw = s.d;

psi = atan(Lc/(2*pi*Rc*N));
Lw  = 2*pi*N*Rc/cos(psi);

% If Lw>2*pi*r (more than one winding) check that pitch angle >= psi-c (close wound pitch)
psic = asin(dw/(2*pi*Rc));
if  Lw>2*pi*Rc && (psic-psi)>2e-4
%  pitch angle is too small, so set value of function to an illegal value 
%  and exit
    error('An error occured before starting calculations on inductance of helix')
    HeliCoilS = 1e200;
else %
if comments
	fprintf('\n Start calculation on inductance of helix')
end
%  gmd of solid round conductor. Other values may be substituted
%  for different conductor geometries
 g    = exp(-.25)*dw/2;
 rr   = Rc*Rc;
 psio = 0.5*pi()-psi;
%  Calculate Filament 2 offset angle
%  Trap for psi=0 condition in which case ThetaO=0 and Y0=g
%  Trap for psio=0 condition in which case use simplified
%  formula for ThetaO and Y0=0
%  which happens with circular (non-helical) filament
if psi==0
 ThetaO = 0;
 Y0     = g;
elseif psio==0
 cosThetaO = 1-(g*g/(2*rr));
 ThetaO    =  -abs(atan(sqrt(1-cosThetaO*cosThetaO)/cosThetaO));
 Y0        = 0;
else
%  Use Newton-Raphson method
if comments
	fprintf('\n Iterate towards theta-zero and y-zero')
end
 k1 = (g*g)/(2*Rc*Rc)-1;
 k2 = tan(psio);
 k2 = 0.5*k2*k2;
 t1 = g/Rc*sin(psi);
 t0 = 2*g/Rc; % <- dummy value larger than t1 to get into the loop
 while abs(t1-t0)>1e-12
    t0 = t1;
    t1 = t0-(k1+cos(t0)-k2*t0*t0)/(-sin(t0)-2*k2*t0);
 end
 ThetaO = -abs(t1);
%  Calculate Filament 2 Y-offset, using formula (29)
 Y0     = sqrt(g*g-2*rr*(1-cos(ThetaO)));
end 
%  Psi constants
 c2s = cos(psi)^2;
 ss  = sin(psi);
 k   = cos(psi)/Rc;
%  Start of Simpson's Rule code
 a = 0;
 b = Lw/32768;
if b>Lw
    b = Lw;
end
 grandtotal=0;
if comments
	fprintf('\n Start loop to calculate inductance')
end
while a<Lw
%     disp(num2str(Lw-a))
     dx         = b-a; 
     m          = 1;
     CurrentErr = 2*MaxErr;
     kat        = k*a;
     kbt        = k*b;
     Sum2       = (Lw-a)*(Ingrnd_fnc(-a,-kat-ThetaO,ss,c2s,rr,Y0)+ ...
                          Ingrnd_fnc(a,kat-ThetaO,ss,c2s,rr,Y0)) ...
                + (Lw-b)*(Ingrnd_fnc(-b,-kbt-ThetaO,ss,c2s,rr,Y0)+ ...
                          Ingrnd_fnc(b,kbt-ThetaO,ss,c2s,rr,Y0));
    % ' Initialize LastResult to trapezoidal area for termination test purposes
     LastIntg = Sum2/2*dx;
    while CurrentErr>MaxErr||m<512
        if comments
            fprintf(['\n Lw - a = ' num2str(Lw-a) ' and Current Err = ' num2str(CurrentErr)])
        end
         m    = 2*m;
         dx   = dx/2;
         Sum  = 0;
         SumA = 0;
        for ii=1:m %to m step 2
            if floor(mod(ii,2)) % <- realize the step 2
                 phi = ii*dx+a;
                 kpt = k*phi;
                 Sum = Sum + (Lw-phi)*(Ingrnd_fnc(-phi,-kpt-ThetaO,ss,c2s,rr,Y0)+ ...
                                       Ingrnd_fnc(phi,kpt-ThetaO,ss,c2s,rr,Y0));
            end
        end
         Integral   = (4*(Sum)+Sum2)*dx/3;
         CurrentErr = abs((Integral)/(LastIntg)-1);
         LastIntg   = Integral;
         Sum2       = Sum2+Sum*2;
    end
     grandtotal = grandtotal+Integral;
     a = b;
     b = b*2;
    if b>Lw
        b = Lw;
    end
end
 HeliCoilS = 1e-7*grandtotal;
end
if comments
	fprintf('\n')
end
function Ingrnd = Ingrnd_fnc(phi,kphitheta,sinpsi,cos2psi,rr,y)
%  Integrand function called by HeliCoilS()
Ingrnd = (1+cos2psi*(cos(kphitheta)-1))/sqrt(2*rr*(1-cos(kphitheta)) +(sinpsi*phi-y)^2);
