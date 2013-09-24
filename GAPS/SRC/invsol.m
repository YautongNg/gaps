function azdist=invsol(cc1,cc2)
%
% Function invsol
% ===============
%
%       Computes azimuth and distance, using Gauss Midlatitude Solution
%       Reference: GPS - Leick, p. 383
%       >> Ellipsoid WGS83 used in this function <<
%
% Sintax
% ======
%
%       azdist=invsol(cc1,cc2)
%
% Input
% =====
%
%       cc1 -> 3x1 vector with cartesian coordinates of point 1
%       cc2 -> 3x1 vector with cartesian coordinates of point 2
%
% Output
% ======
%
%       azdist -> 3x1 vector with azimuth p1->p2 (az1),  
%                 azimuth p2->p1 (az2) and distance
%                 azdist=[ az1 ; az2 ; dist]
%                         [rad] [rad]   [m]
%
% Created/Modified
% ================
%
% When          Who                     What
% ----          ---                     ----
% 2005/11/01    Rodrigo Leandro         Function created
% 2006/08/10    Rodrigo Leandro         Function addapted to GAPS standards
%
%
% ===================================
% Copyright 2005-2006 Rodrigo Leandro
% ===================================

llh=cart2geod(cc1);
lat1=llh(1,1);
lon1=llh(2,1);
%hei1=llh(3,1); - height not used
llh=cart2geod(cc2);
lat2=llh(1,1);
lon2=llh(2,1);
%hei2=llh(3,1); - height not used

lat=(lat1+lat2)/2;

% WGS84 - Geodesy - Torgue, pp.95-96
a = 6378137;
b = 6356752.314;
% f = (a - b) / a; - f not used
e = sqrt(a^2-b^2)/a;
M=(a*(1-e^2))/(1-(e^2*(sin(lat)^2)))^(3/2);
N=a/(1-(e^2*(sin(lat)^2)))^(1/2);

% Auxiliary Terms:
dlat=lat2-lat1;
dlon=lon2-lon1;
t=tan(lat);
n=sqrt((e^2/(1-e^2))*cos(lat)^2);
V=sqrt(1+n^2);
f1=1/M;
f2=1/N;
f3=1/24;
f4=(1+n^2-9*n^2*(t^2))/(24*(V^4));
f5=(1-2*(n^2))/24;
f6=((n^2)*(1-t^2))/(8*(V^4));
f7=(1+(n^2))/12;
f8=(3+(8*n^2))/(24*(V^4));

% Inverse Solution: Given lat1,lon1,lat2,lon2, conpute dist,alpha1,alpha2
ssinalpha=(1/f2)*dlon*cos(lat)*(1-f3*(dlon*sin(lat))^2+f4*dlat^2);
scosalpha=(1/f1)*dlat*cos(dlon/2)*(1+f5*(dlon*cos(lat))^2+f6*dlat^2);
dalphahat=dlon*sin(lat)*(1+f7*(dlon*cos(lat))^2+f8*dlat^2);
shat=sqrt(ssinalpha^2+scosalpha^2);
alphahat=atan2(ssinalpha,scosalpha);
alpha1=alphahat-dalphahat/2;
alpha2=alphahat+dalphahat/2+pi;
if alpha2>2*pi
    alpha2=alpha2-2*pi;
end

azdist=[alpha1;alpha2;shat];