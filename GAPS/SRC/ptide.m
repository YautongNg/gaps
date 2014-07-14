function ptdxyz=ptide(recllh,cdate)
%
% Function btide
% ==============
%
%       Computes the radial, s->n and w->e displacements due to boody tides
%       for given time and position.
%
% Sintax
% ======
%
%       ptde=ptide(recllh,cdate)
%
% Input
% =====
%
%       recllh -> receiver geodetic coordinates
%       cdate -> current date (cdate=[Y;M;D;H;M;S])
%
% Output
% ======
%
%       ptde -> 3x1 vector with 3D displacements (m)
%                 ptde=[U;N;E]
%                        U -> radial displacement
%                        N -> S->N displacement
%                        E -> W->E displacement
%
% Created/Modified
% ================
%
% When          Who                     What
% ----          ---                     ----
% 2010/01/13    Landon Urquhart         Function created
%
%
% Comments
% ========
%
%
%
doy=ymd2doy(cdate);
decyear=(cdate(1)+doy/365.25) -1900;
lat=recllh(1);
lon=recllh(2);

%xp=0.002*decyear-0.1334;
 xp=0.09768 ;
xp_bar=0.054+(cdate(1)-2000)*0.00083;%[arcsecs]
%yp=0.0037*decyear-0.0395;
yp= 0.193114;
yp_bar=0.357+(cdate(1)-2000)*0.00395 ;%[arcsecs]
         
m1=xp-xp_bar;
m2=-(yp-yp_bar);

dlat=-9*cos(2*lat)*(m1*cos(lon)+m2*sin(lon));
dlon=9*sin(lat)*(m1*sin(lon)-m2*cos(lon));
dh=-33*sin(2*lat)*(m1*cos(lon)+m2*sin(lon));

ptde=[dlat/1000;dlon/1000;dh/1000];

ptdxyz=offllh2xyz(recllh,ptde);