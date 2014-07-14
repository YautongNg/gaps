function WUP=phasewup2(XSV,cdate,XRV,cst)
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
%
% Output
% ======
%
%       phswdp -> phase wind-up correction
%
% Created/Modified
% ================
%
% When          Who                     What
% ----          ---                     ----
% 2006/06/29    Rodrigo Leandro         Function created
%
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================


 XSVRV=XRV-XSV;
 USVRV=XSVRV/norm(XSVRV);
 jd=ymdhms2jd(cdate);
 xyzp=santdir(XSV,jd);
 USVX=xyzp(1,:)';
 USVY=xyzp(2,:)';
 USVZ=xyzp(3,:)';
 xyz=rantdir(XRV);
 URVX=xyz(1,:)';
 URVY=xyz(2,:)';
 URVZ=xyz(3,:)';
 DPRV = dot(USVRV,URVX);
 DPSV = dot(USVRV,USVX);
 XPRV=cross(USVRV,URVY);
 XPSV=cross(USVRV,USVY);
 for i=1:3
     EDPRV(i) = URVX(i) - USVRV(i)*DPRV + XPRV(i);
     EDPSV(i) = USVX(i) - USVRV(i)*DPSV - XPSV(i);
 end
 UEDPRV=EDPRV/norm(EDPRV);
 UEDPSV=EDPSV/norm(EDPSV);
 WUP = ((acos(dot(UEDPSV,UEDPRV)))/(2*pi))*cst.l1;
 WUPDIR = cross(UEDPSV,UEDPRV);
 WUPSGN = dot(WUPDIR,USVRV);
 if WUPSGN<=0
     WUP = -WUP;
 end

