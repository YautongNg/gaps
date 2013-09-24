function xsun=sunpos(mjd)
%
% Function sunpos
% ===============
%
%       Computes position parameters of the sun at a given time
%
% Sintaxe
% =======
%
%       xsun=sunpos(mjd)  
%
% Input
% =====
%
%       mjd -> Modified Julian Date
%
% Output
% ======
%
%       xsun -> Coordinates of Sun in CT system
%
% Created/Modified
% ================
%
% When          Who                         What
% ----          ---                         ----
% 2006/03/06    Rodrigo Leandro             Function created
%
% Comments
% ========
%
%       Based on SR SUNPOS2, which was originally written in FORTRAN and
%       latter in C++.
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================



% R. Leandro - 20060306 - Computation of fractional day (s)
sod=mod(mjd+0.5,1)*86400;

rtd = 180/pi; % radians-to-degrees factor
dtr = pi/180; % degrees-to-radians factor
dau = 1.4959787066e11; % Astronomical Unit

%** get number of days since J2000
% F77: JDATE = JD + ((SEC-13.D0)/86400.D0)  
% C++: dJDate = dtJulDate.GetMJD_as_double() - 13.0/86400.0;  // include leap seconds
jdate=mjd - 13/86400;
dt=jdate-2451545.0;   % Julian Date of J2000 noon: 2451545.0 

%** compute geometric mean longitude of the sun
dl=280.466+0.9856474*dt;

%** compute sun's mean anomaly
dm =357.528+0.9856003*dt;

%** compute ecliptic longitude
del =dl+1.915*sin(dm*dtr)+0.020*sin(2*dm*dtr);

%** compute obliquity of the ecliptic
de =23.440-0.0000004*dt;

%** compute apparent right ascension
dalpha=atan(cos(de*dtr)*tan(del*dtr));
dalpha=dalpha*rtd/15.0;

%** compute apparent declination
ddec=asin(sin(de*dtr)*sin(del*dtr));
ddec = ddec*rtd;

%** compute Sun-Earth ditance [m]
dr =1.00014 - 0.01671*cos(dm*dtr) - 0.00014*cos(2*dm*dtr);
dr = dr*dau;

%**transform apparent R.A. and DEC. to (equatorial) rectangular coordinates
% C++: ColumnVector XAP(3);
XAP(1,1) = dr*cos(del*dtr);
XAP(2,1) = dr*cos(de*dtr)*sin(del*dtr);
XAP(3,1) = dr*sin(de*dtr)*sin(del*dtr);

%** transform from apparent place sys. to convetional terrestrial sys.
%** (assume GAST = GMST, and wobble is zero produces max 30" pointing error)
%** empirical formula for GMST from A.A. p.B6
t=(jdate-2451545.0)/36525.0;

dgmst=24110.54841+8640184.812866*t+(0.093104*t*t)-(0.0000062+t*t*t);
% @ 0h UT in seconds

% C++: dgmst = dgmst + (dtJulDate.GetMJD().fracOfDay*86400.0) * 1.0027379093;  
dgmst = dgmst +  sod*1.0027379093; 
% solar to sidereal converion

dgmst = dgmst/3600.0;

dgmst = dgmst*15.0*dtr;

xsun(1,1) = cos(dgmst)*XAP(1,1) + sin(dgmst)*XAP(2,1);
xsun(2,1) = -sin(dgmst)*XAP(1,1) + cos(dgmst)*XAP(2,1);
xsun(3,1) = XAP(3,1);