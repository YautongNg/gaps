function satapc=satapcv(satatx,recxyz,satxyz,prn,nadang,cst)
%
% Function satapcv
% ================
%
%       Computes the satellite antenna phase center variation correction
%
% Sintax
% ======
%
%       satapc=satapcv(satatx,recxyz,satxyz,cst)
%
% Input
% =====
%
%       satatx -> structure with satellite APC info (mm)
%       recxyz -> Receiver cartesian coordinates
%       satxyz -> Satellite cartesian coordinates
%       prn -> satellite prn
%       nad -> satellite nadir angle (rad)
%       cst -> sructute with constants
%
% Output
% ======
%
%
% Created/Modified
% ================
%
% When          Who                     What
% ----          ---                     ----
% 2006/07/17    Rodrigo Leandro         Function created
% 2006/07/24    Rodrigo Leandro         Added return of L1 and L2
%                                       corrections
% 2006/11/09    Rodrigo Leandro         Function apcbas created
%                                       addapted from atphasecenter.m
%
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

%==========================================================================
% Compute nadir angle in degrees
%--------------------------------------------------------------------------
naddeg=nadang*180/pi;
if naddeg<0 || isnan(naddeg)
    naddeg=0;
end
%==========================================================================

%==========================================================================
% Interpolate for azimuth
%--------------------------------------------------------------------------
% Satellite antenna DOES NOT have azimuth dependent corr. - use NOAZI values
apcaz1=satatx(prn).freq(1).noazi';
apcaz2=satatx(prn).freq(2).noazi';
%==========================================================================

%==========================================================================
% Interpolate for nadir angle 
%--------------------------------------------------------------------------
zen1=satatx(prn).zen(1,1);
zen2=satatx(prn).zen(2,1);
dzen=satatx(prn).zen(3,1);
minidx=fix((naddeg-zen1)/dzen)+1;
maxidx=minidx+1;
if maxidx>size(apcaz1,2) || naddeg<zen1
%    warning('Sat. nadir angle outise antex limits. Using 0 degrees apc value.');
    minidx=1;
    maxidx=1;
end
minang=(minidx-1)*dzen;
varcor1=((naddeg-minang)/dzen)*(apcaz1(1,maxidx)-apcaz1(1,minidx))+ ...
    apcaz1(1,minidx);
varcor2=((naddeg-minang)/dzen)*(apcaz2(1,maxidx)-apcaz2(1,minidx))+ ...
    apcaz2(1,minidx);
%==========================================================================

%==========================================================================
% Compute ion-free corrections
%--------------------------------------------------------------------------
varcor=cst.if1(prn)*varcor1-cst.if2(prn)*varcor2;
%==========================================================================

%==========================================================================
% Compute correction (m)
% According to Antex 1.3 corrections should be used as:
% observed distance = geometric distance + variation
% GAPS uses P + satapc - ro = P - varcor - ro = 0 and therefore
%     P = ro + varcor -> which matches with antex 1.3 standards
%--------------------------------------------------------------------------
satapc=(-varcor)/1000;
%==========================================================================
