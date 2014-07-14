function [phswdp phswdp1 phswdp2 pwu]= ...
    phasewup(satxyz,cdate,recxyz,recllh,cst,pwu,prn,xsun)
%
% Function phasewup
% =================
%
%       Computes the phase wind-up correction
%
% Sintax
% ======
%
%       phswdp=phasewup(satxyz,cdate,recxyz,recllh)
%
% Input
% =====
%
%       satxyz -> 3x1 vector with satellite cartesian coordinates
%       cdate -> 6x1 vector with current date
%       recxyz -> 3x1 vector with receiver cartesian coordinates
%       recllh -> 3x1 vector with receiver geodetic coordinates
%       pwu -> nx1 vector containing phase wind-up corrections
%       prn -> satellite PRN
%
% Output
% ======
%
%       phswdp -> phase wind-up correction - Ionfree
%       phswdp1 -> phase wind-up correction - L1
%       phswdp2 -> phase wind-up correction- L2
%       pwu -> updated nx1 vector containing phase wind-up corrections
%
% Created/Modified
% ================
%
% When          Who                     What
% ----          ---                     ----
% 2006/06/29    Rodrigo Leandro         Function created
% 2006/07/24    Rodrigo Leandro         Added phswdp1 and phswdp2
% 2009/12/15    Landon Urquhart         Support new "constants" format
%
% Comments
% ========
%
%       Reference: Wu, J.T., S,C. Wu, G.A. Hajj, W.I. Bertiger, and S.M.
%       Lichten (1993). Effects of antenna orientation onGPS carrier phase,
%       Man. Geodetica 18, pp. 91-98
%
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

%===============================
% Satellite-receiter unit vector
k=recxyz-satxyz;
k=k/norm(k);
%===============================

%==============================================
% Satellite body corrdinate system unit vectors
%jd=ymdhms2jd(cdate);
xyzp=santdir(satxyz,xsun);
xp=xyzp(1,:)';
yp=xyzp(2,:)';
%zp=xyzp(3,:)';
% zp is commented because it is not used.
%==============================================

%========================================
% Receiver corrdinate system unit vectors
xyz=rantdir(recllh);
x=xyz(1,:)';
y=xyz(2,:)';
%z=xyz(3,:)';
% z is commented because it is not used.
%========================================

%===============
% Dipole vectors
D = x - k*dotr(k,x) + cross3(k,y);
Dp = xp - k*dotr(k,xp) - cross3(k,yp);
%===============

%============================
% Direction of the correction
E = dotr(k,cross3(Dp,D));
se = sign(E);
%============================

%===============
% Correction (rad)
angcor = se * acos(dotr(Dp,D)/(norm(Dp)*norm(D)));
%===============

%=====================================================
% Compute integer number of cycles for cycle crossover
if isnan(pwu(prn))
    N=0;
else
    N=round((pwu(prn)-angcor)/(2*pi));
end
%=====================================================

%==================
% Correction in rad
phswdp = 2*pi*N + angcor; % (rad)
%==================

%=========================
% Update correction buffer
pwu(prn)=phswdp;
%=========================

%========================
% Compute correction in m
phswdp=(phswdp/(2*pi))*cst.l3(prn); % (m)
phswdp1=(phswdp/(2*pi))*cst.l1(prn); % (m)
phswdp2=(phswdp/(2*pi))*cst.l2(prn); % (m)
%========================