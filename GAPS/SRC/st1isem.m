function xcorsta3=st1isem(sinphi,cosphi,xsun,xmon,cosla,sinla,rmon,rsun,fac2sun,fac2mon)
%
% Function st1isem
% ==================
%
%   This subroutine gives the out-of-phase corrections induced by mantle 
%   inelasticity in the diurnal band
%
%
% Sintaxe
% =======
%
%       xcorsta3=st1isem(sinphi,cosphi,xsun,xmon,cosla,sinla,rmon,rsun,...
%                        fac2sun,fac2mon)      
%
% Input
% =====
%       
%       sinphi  -> factor from detide.m routine
%       cosphi  -> factor from detide.m routine
%       fac2sun -> factor for sun/moon
%       fac2mon -> factor for sun/moon  
%       xsun  -> 3x1 vector with geoc. position of the sun (ECEF) 
%       xmon  -> 3x1 vector with geoc. position of the moon (ECEF)                      
%       sinla -> factor from detide.m routine
%       cosla -> factor from detide.m routine
%       rsun  -> factor for sun/moon
%       rmon  -> factor for sun/moon
% 
% Output
% ======
%
%       xcorsta3 -> 3x1 vector with corrections induced by mantle 
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

dhi=-0.00220;
dli=-0.00070;
       costwola=cosla^2-sinla^2;
       sintwola=2.0*cosla*sinla;
       drsun=-3.0/4.0*dhi*cosphi^2*fac2sun*((xsun(1)^2-xsun(2)^2)*...
              sintwola-2.*xsun(1)*xsun(2)*costwola)/rsun^2;
       drmon=-3.0/4.0*dhi*(cosphi^2)*fac2mon*((xmon(1)^2-xmon(2)^2)*...
              sintwola-2.*xmon(1)*xmon(2)*costwola)/rmon^2;
       dnsun=1.50*dli*sinphi*cosphi*fac2sun*((xsun(1)^2-xsun(2)^2)*...
              sintwola-2.0*xsun(1)*xsun(2)*costwola)/rsun^2;
       dnmon=1.50*dli*sinphi*cosphi*fac2mon*((xmon(1)^2-xmon(2)^2)*...
              sintwola-2.0*xmon(1)*xmon(2)*costwola)/rmon^2;
       desun=-3.0/2.0*dli*cosphi*fac2sun*((xsun(1)^2-xsun(2)^2)*...
              costwola+2.*xsun(1)*xsun(2)*sintwola)/rsun^2;
       demon=-3.0/2.0*dli*cosphi*fac2mon*((xmon(1)^2-xmon(2)^2)*...
              costwola+2.0*xmon(1)*xmon(2)*sintwola)/rmon^2;
      dr=drsun+drmon;
      dn=dnsun+dnmon;
      de=desun+demon;
      xcorsta(1)=dr*cosla*cosphi-de*sinla-dn*sinphi*cosla;
      xcorsta(2)=dr*sinla*cosphi+de*cosla-dn*sinphi*sinla;
      xcorsta(3)=dr*sinphi+dn*cosphi;

xcorsta3=[xcorsta(1);xcorsta(2);xcorsta(3)];
