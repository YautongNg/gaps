function [p0 l0]=ionfree(obs,sat,poob,cst,p1c1m,p1c1)
%
% Function ionfree
% ================
%
%       This function computes the ionfree observation for pseudorange and
%       carrier-phase.
%
% Sintaxe
% =======
%
%       ionfree(obs,sat,poob,cst)
%
% Input
% =====
%
%       obs -> nsxno matrix containing observations (same order as 
%              stated in the header)
%              ns -> # of satellites
%              no -> # of observables
%       sat -> satellite position in obs (row) - NOT PRN!!!
%       poob -> structure containing observable positions
%               poob.P1 -> P1 pseudorange position
%               poob.C1 -> C1 pseudorange position
%               poob.P2 -> P2 pseudorange position
%               poob.L1 -> L1 carrier phase position
%               poob.L2 -> L2 carrier phase position
%       cst -> structure containing constants:
%              cst.c -> speed of light (m/s)
%              cst.f1 -> L1 frequency (Hz)
%              cst.l1 -> L1 wavelength (m)
%              cst.f2 -> L2 frequency (Hz)
%              cst.l2 -> L2 wavelength (m)
%
% Output
% ======
%
%       p0 -> ionfree pseudorange (m)
%       l0 -> ionfree carrier-phase (m)
%
% Created/Modified
% ================
%
% When              Who                     What
% ----              ---                     ----
% 2006/06/20        Rodrigo Leandro         Function created
% 2006/07/11        Rodrigo Leandro         Add handling of P1-C1 biases 
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

% Get prn
prn=obs(sat,2);

% Check which type of pseudorange should be used
if p1c1m==1
    ppr1=poob.P1;
else
    ppr1=poob.C1;
end

% Get observations
p1=obs(sat,ppr1);
p2=obs(sat,poob.P2);
l1=obs(sat,poob.L1);
l2=obs(sat,poob.L2);

% Apply biases if necessary
if p1c1m>1
    p1=p1+(p1c1(prn)/1e9)*cst.c;
end
if p1c1==3
    p2=p2+(p1c1(prn)/1e9)*cst.c;
end

% Compute carrier-phase measurements in (m)
l1m=l1*cst.l1;
l2m=l2*cst.l2;

% Compute ionfree observations
p0=cst.if1*p1-cst.if2*p2;
l0=cst.if1*l1m-cst.if2*l2m;