function xcorsta4=st1idiu(sinphi,cosphi,fac2sun,cos2phi,sinla,xsun,cosla,xmon,fac2mon,rsun,rmon)
%
% Function st1idiu
% ==================
%
%   This subroutine gives the out-of-phase corrections induced by mantle 
%   inelasticity in the diurnal band
%
%
% Sintaxe
% =======
%
%       xcorsta4=st1idiu(sinphi,cosphi,fac2sun,cos2phi,sinla,xsun,cosla,...
%                        xmon,fac2mon,rsun,rmon)      
%
% Input
% =====
%   
%       sinphi  -> factor from detide.m routine
%       cosphi  -> factor from detide.m routine
%       fac2sun -> factor for sun/moon
%       fac2mon -> factor for sun/moon  
%       cos2phi -> factor from detide.m routine
%       xsun  -> 3x1 vector with geoc. position of the sun (ECEF) 
%       xmon  -> 3x1 vector with geoc. position of the moon (ECEF)                      
%       sinla -> factor from detide.m routine
%       cosla -> factor from detide.m routine
%       rsun  -> factor for sun/moon
%       rmon  -> factor for sun/moon
%       
% 
% Output
% ======
%
%       xcorsta4 -> 3x1 vector with corrections induced by mantle 
%                   inelasticity in the diurnal band (m)
%                   
%
% Created/Modified
% ================
%
% When          Who                        What
% ----          ---                        ----
% 2009/06/15    Carlos Alexandre Garcia    Function Created
%
% Comments
% ========
%
%       This routine was adapted from the routine dehanttideinel.f,
%       available at ftp://tai.bipm.org/iers/convupdt/chapter7/ (IERS).
%
% ==============================
% Copyright 2009 University of New Brunswick
% ============================== 


dhi=-0.0025;
dli=-0.0007;

    drsun=-3.0*dhi*sinphi*cosphi*fac2sun*xsun(3)*...
          (xsun(1)*sinla-xsun(2)*cosla)/rsun^2;
    drmon=-3.0*dhi*sinphi*cosphi*fac2mon*xmon(3)*(xmon(1)*...
           sinla-xmon(2)*cosla)/rmon^2;
    dnsun=-3.0*dli*cos2phi*fac2sun*xsun(3)*(xsun(1)*sinla-...
           xsun(2)*cosla)/rsun^2;
    dnmon=-3.0*dli*cos2phi*fac2mon*xmon(3)*(xmon(1)*sinla-...
          xmon(2)*cosla)/rmon^2;
    desun=-3.0*dli*sinphi*fac2sun*xsun(3)*...
          (xsun(1)*cosla+xsun(2)*sinla)/rsun^2;
    demon=-3.0*dli*sinphi*fac2mon*xmon(3)*...
          (xmon(1)*cosla+xmon(2)*sinla)/rmon^2;

dr=drsun+drmon;
dn=dnsun+dnmon;
de=desun+demon;
  
xcorsta4(1)=dr*cosla*cosphi-de*sinla-dn*sinphi*cosla;
xcorsta4(2)=dr*sinla*cosphi+de*cosla-dn*sinphi*sinla;
xcorsta4(3)=dr*sinphi               +dn*cosphi;

xcorsta4=[xcorsta4(1);xcorsta4(2);xcorsta4(3)];


