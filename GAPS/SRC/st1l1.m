function xcorsta1=st1l1(sinphi,cosphi,cosla,sinla,xsun,xmon,rsun,rmon,fac2sun,fac2mon)
%
% Function st1l1
% ==================
%
%      This subroutine gives the corrections induced by the latitude 
%      dependence given by l^(1) in mahtews et al (1991)
%
%
% Sintaxe
% =======
%
%       xcorsta1=st1l1(sinphi,cosphi,cosla,sinla,xsun,xmon,rsun,rmon,...
%                      fac2sun,fac2mon)  
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
%       xcorsta1 -> 3x1 vector with corrections induced by the latitude 
%                   dependence given by l^(1) 
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

l1d=0.0012;
l1sd=0.0024;

% for the diurnal band
l1=l1d;
dnsun=-l1*sinphi^2*fac2sun*xsun(3)*(xsun(1)*cosla+xsun(2)*sinla)...
       /rsun^2;
dnmon=-l1*sinphi^2*fac2mon*xmon(3)*(xmon(1)*cosla+xmon(2)*sinla)...
      /rmon^2;
desun=l1*sinphi*(cosphi^2-sinphi^2)*fac2sun*xsun(3)*...
      (xsun(1)*sinla-xsun(2)*cosla)/rsun^2;
demon=l1*sinphi*(cosphi^2-sinphi^2)*fac2mon*xmon(3)*...
      (xmon(1)*sinla-xmon(2)*cosla)/rmon^2;

de=3.0*(desun+demon);
dn=3.0*(dnsun+dnmon);

xcorsta1(1)=-de*sinla-dn*sinphi*cosla;
xcorsta1(2)= de*cosla-dn*sinphi*sinla;
xcorsta1(3)=dn*cosphi;

% for the semi-diurnal band
l1=l1sd;
costwola=cosla^2-sinla^2;
sintwola=2.0*cosla*sinla;
dnsun=-l1/2.0*sinphi*cosphi*fac2sun*((xsun(1)^2-xsun(2)^2)*...
      costwola+2.0*xsun(1)*xsun(2)*sintwola)/rsun^2;
      
dnmon=-l1/2.0*sinphi*cosphi*fac2mon*((xmon(1)^2-xmon(2)^2)*...
      costwola+2.0*xmon(1)*xmon(2)*sintwola)/rmon^2;
      
desun=-l1/2.0*sinphi^2*cosphi*fac2sun*((xsun(1)^2-xsun(2)^2)*...
      sintwola-2.0*xsun(1)*xsun(2)*costwola)/rsun^2;
     
demon=-l1/2.0*sinphi^2*cosphi*fac2mon*((xmon(1)^2-xmon(2)^2)*...
      sintwola-2.0*xmon(1)*xmon(2)*costwola)/rmon^2;
     
de=3.0*(desun+demon);
dn=3.0*(dnsun+dnmon);
     
xcorsta1(1)=xcorsta1(1)-de*sinla-dn*sinphi*cosla;
xcorsta1(2)=xcorsta1(2)+de*cosla-dn*sinphi*sinla;
xcorsta1(3)=xcorsta1(3)         +dn*cosphi;

xcorsta1=xcorsta1;