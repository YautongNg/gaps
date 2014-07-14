function [antphc antphc1 antphc2]= ...
    antphasecenter(apc,recxyz,recllh,satxyz,elvang,cst,prn)
%
% Function atphasecenter
% ======================
%
%       Computes the antenna phase center offset/variation correction
%
% Sintax
% ======
%
%       antphc=antphasecenter(apc,recxyz,satxyz,elvang)
%
% Input
% =====
%
%       apc -> 22x2 vector with APC values (mm)
%       recxyz -> Receiver cartesian coordinates
%       satxyz -> Satellite cartesian coordinates
%       elvang -> Elevation angle (rad)
%       cst -> sructute with constants
%
% Output
% ======
%
%       antphc -> APC correction (m)
%
% Created/Modified
% ================
%
% When          Who                     What
% ----          ---                     ----
% 2006/07/17    Rodrigo Leandro         Function created
% 2006/07/24    Rodrigo Leandro         Added return of L1 and L2
%                                       corrections
%
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================


% Compute offsets in XYZ
apc(1:3,1)=offllh2xyz(recllh,apc(1:3,1));
apc(1:3,2)=offllh2xyz(recllh,apc(1:3,2));

% Compute correction due to offset
offcor1=xyz2rngcor(apc(1:3,1),recxyz,satxyz);
offcor2=xyz2rngcor(apc(1:3,2),recxyz,satxyz);

% Compute correction due to variation (elev. dependent)
elvdeg=90-elvang*180/pi;
if elvdeg<0 || isnan(elvdeg)
    elvdeg=0;
end
minidx=fix(elvdeg/5);
minang=(minidx-1)*5;
if elvdeg>minang
    maxidx=minidx+1;
else
    maxidx=minidx;
end
varcor1=((elvdeg-minang)/5)*(apc(maxidx+3,1)-apc(minidx+3,1))+ ...
    apc(minidx+3,1);
varcor2=((elvdeg-minang)/5)*(apc(maxidx+3,2)-apc(minidx+3,2))+ ...
    apc(minidx+3,2);

% Compute ion-free corrections
offcor=cst.if1(prn)*offcor1-cst.if2(prn)*offcor2;
varcor=cst.if1(prn)*varcor1-cst.if2(prn)*varcor2;

% Compute correction (m)
antphc=(offcor-varcor)/1000;
antphc1=(offcor1-varcor1)/1000;
antphc2=(offcor2-varcor2)/1000;
