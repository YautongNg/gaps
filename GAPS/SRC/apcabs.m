function [antphc antphc1 antphc2]= ...
    apcabs(apc,recxyz,recllh,satxyz,elvang,az,cst,prn)
%
% Function apcabs
% ===============
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
%       apc -> structure with receiver APC info (mm)
%       recxyz -> Receiver cartesian coordinates
%       satxyz -> Satellite cartesian coordinates
%       elvang -> Elevation angle (rad)
%       az -> azimuth (rad)
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
% 2006/07/17    Rodrigo Leandro         Function atphasecenter created
% 2006/07/24    Rodrigo Leandro         Added return of L1 and L2
%                                       corrections
% 2006/11/09    Rodrigo Leandro         Function apcbas created
%                                       addapted from atphasecenter.m
% 2009/12/15    Landon Urquhart         Support new "constants" format
%
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

%==========================================================================
% Compute offsets in XYZ
% Input to offllh2xyz is UNE
% apc's format is NEU
%--------------------------------------------------------------------------
apcxyz1=offllh2xyz(recllh,[apc.freq(1).neu(3,1) ; apc.freq(1).neu(1:2,1)]);
apcxyz2=offllh2xyz(recllh,[apc.freq(2).neu(3,1) ; apc.freq(2).neu(1:2,1)]);
%==========================================================================

%==========================================================================
% Compute correction due to offset
%--------------------------------------------------------------------------
offcor1=xyz2rngcor(apcxyz1,recxyz,satxyz);
offcor2=xyz2rngcor(apcxyz2,recxyz,satxyz);
%==========================================================================

%==========================================================================
% Compute correction due to variation (elev. dependent)
%--------------------------------------------------------------------------
zendeg=(90-elvang*180/pi);
if zendeg>90 || isnan(zendeg)
    zendeg=90;
end
%==========================================================================

%==========================================================================
% Interpolate for azimuth
%--------------------------------------------------------------------------
dazi=apc.dazi;
if dazi>0 % The antenna has azimuth dependent corrections
    apc1=apc.freq(1).azi;
    apc2=apc.freq(2).azi;
    azdeg=az*180/pi;
    if isnan(azdeg)
        azdeg=0;
    elseif azdeg<0 
        azdeg=azdeg+360;
    end
    minidx=fix(azdeg/dazi)+1;
    maxidx=minidx+1;
    apcaz1=apc1(minidx,2:end)+ ...
        (apc1(maxidx,2:end)-apc1(minidx,2:end))*(azdeg-apc1(minidx,1))/dazi;
    apcaz2=apc2(minidx,2:end)+ ...
        (apc2(maxidx,2:end)-apc2(minidx,2:end))*(azdeg-apc2(minidx,1))/dazi;
else % The antenna DOES NOT have azimuth dependent corr. - use NOAZI values
    apcaz1=apc.freq(1).noazi';
    apcaz2=apc.freq(2).noazi';
end
%==========================================================================

%==========================================================================
% Interpolate for elevation angle 
%--------------------------------------------------------------------------
zen1=apc.zen(1,1);
zen2=apc.zen(2,1);
dzen=apc.zen(3,1);
minidx=fix((zendeg-zen1)/dzen)+1;
maxidx=minidx+1;
if maxidx>size(apcaz1,2) || zendeg<zen1
%    warning('Sat. elevation angle outise antex limits. Using 90 degrees apc value.');
    minidx=size(apcaz1,2);
    maxidx=size(apcaz1,2);
end
minang=(minidx-1)*dzen;
varcor1=((zendeg-minang)/dzen)*(apcaz1(1,maxidx)-apcaz1(1,minidx))+ ...
    apcaz1(1,minidx);
varcor2=((zendeg-minang)/dzen)*(apcaz2(1,maxidx)-apcaz2(1,minidx))+ ...
    apcaz2(1,minidx);
%==========================================================================

%==========================================================================
% Compute ion-free corrections
%--------------------------------------------------------------------------
offcor=cst.if1(prn)*offcor1-cst.if2(prn)*offcor2;
varcor=cst.if1(prn)*varcor1-cst.if2(prn)*varcor2;
%==========================================================================

%==========================================================================
% Compute correction (m)
% According to Antex 1.3 corrections should be used as:
% observed distance = geometric distance + variation
% GAPS uses P + antphc - ro = P - varcor - ro = 0 and therefore
%     P = ro + varcor -> which matches with antex 1.3 standards
%--------------------------------------------------------------------------
antphc=(offcor-varcor)/1000;
antphc1=(offcor1-varcor1)/1000;
antphc2=(offcor2-varcor2)/1000;
%==========================================================================
