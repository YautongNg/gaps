function wdotptp(otptp,cdate,recllh,recxyz,zennad,recclk,irecxyz,izennad,hobs,hzg)
%
% Function wdotptp
% ================
%
%       Writes data to the parameters ep. by ep. output file
%
% Sintax
% ======
%
%       wdotptp(otptp)
%
% Input
% =====
%
%       otptp -> file identifier
%
% Output
% ======
%
%       No output!
%
% Created/Modified
% ================
%
% When          Who                     What
% ----          ---                     ----
% 2006/06/28    Rodrigo Leandro         Function created
% 2006/07/12    Rodrigo Leandro         handle ARP offset
%
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

% Angles in dms
recllh(3,1)=recllh(3,1)-hobs.deltah;
lat=rad2dms(recllh(1,1));
lon=rad2dms(recllh(2,1));
h=recllh(3,1);
dllh=distllh(irecxyz,recxyz);
dxyz=recxyz-irecxyz;
recxyz=geod2cart(recllh);
cdate(6,1)=round(cdate(6,1));
fprintf(otptp,'%5i%4i%4i%4i%4i%4i%8i%16.9f%16.9f%15.4f%15.4f%15.4f%15.4f%15.4f%15.4f%15.4f%15.4f%15.4f%15.4f%8.4f%9.4f%16.4f%9.4f%9.4f%9.4f\n',cdate,0,lat,lon,h,dllh,recxyz,dxyz,sum(zennad),sum(zennad-izennad),recclk,zennad(1),hzg);