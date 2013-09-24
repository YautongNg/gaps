function w=updtmvm(w,p1,p2,ionop,sp1p2,rdcb,cst,elevang, ...
    recllh,ipp,prn)
%
% Function updtmvm
% ================
%
%       This function updates the misclousure vector for code multipath
%       computation
%
% Sintax
% ======
%
%       w=updtmvm(w,p1(prn),p2(prn),ionop,sp1p2,rdcb,cst)
%
% Input
% =====
%
%       w -> misclousure vector (m)
%       p1 -> L1 pseudorange ambiguity observable (m)
%       p2 -> L2 pseudorange ambiguity observable (m)
%       ionop -> Ionospheric delay model coeficients
%       sp1p2 -> matrix with satellite DCB's
%       rdcb -> Receiver DCB (adjusment parameter)
%       cst -> structure with constants
%       elevang -> vector with elevation angles
%       recllh -> receiver geodetic coordinates
%       ipp -> ionospheric piercing point coordinates
%       prn -> Satellite PRN
%
% Output
% ======
%
%       w -> updated misclousure vector (m)
%
% Created/Modified
% ================
%
% When          Who                         What
% ----          ---                         ----
% 2006/08/02    Rodrigo Leandro             Function updtmv12 created
% 2007/01/22    Rodrigo Leandro             Function updtmvi cretaed
%                                           based on function updtmv12
% 2007/03/21    Rodrigo Leandro             Function updtmvm created
%                                           based on function updtmvi
%
% ================================================================
% Copyright 2006-2007 Rodrigo Leandro, University of New Brunswick
% ================================================================

% Get current mv size
nl=size(w,1);

% compute mapping function
R=6378136.3; % Mean radius of the Earth
Sh=350000; % Shell height
m=sqrt(1-(R*cos(elevang)/(R+Sh))^2); % Mapping function

% compute delta_lat and delta_long in radians
dlat=ipp(1,1)-recllh(1,1);
dlon=ipp(2,1)-recllh(2,1);

% compute gamma constant (for L2!)
gamma=(cst.f1(prn)^2)/(cst.f2(prn)^2);

% Get iono model parameters
A0=ionop.a0;
A1=ionop.a1;
A2=ionop.a2;

% Get satellite DCB
sdcb=sp1p2(sp1p2(:,1)==prn,2);
% sdcb is in nanoseconds!
% convert to meters:
if size(sdcb)>0
    sdcb=sdcb(1,1)*1e-9*cst.c;
else
    sdcb=0;
end

% Update misclousure vector
% w(nl+1,1)=p1-cst.if2*rdcb+cst.if2*sdcb-(1/m)*(A0+A1*dlat+A2*dlon);
% w(nl+2,1)=p2-cst.if1*rdcb+cst.if1*sdcb-gamma*(1/m)*(A0+A1*dlat+A2*dlon);
w(nl+1,1)=p1-cst.if2(prn)*rdcb+cst.if2(prn)*sdcb-(1/m)*(A0);
w(nl+2,1)=p2-cst.if1(prn)*rdcb+cst.if1(prn)*sdcb-gamma*(1/m)*(A0);


