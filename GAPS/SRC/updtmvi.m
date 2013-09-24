function w=updtmvi(w,l1,l2,p1,p2,ambi,elevang,recllh,ipp,ionop,cst,prn)
%
% Function updtmvi
% ================
%
%       This function updates the misclousure vector for IONO delays
%       computation
%
% Sintax
% ======
%
%       w=updtmvi(w,l1,l2,p1,p2,ambi,cst)
%
% Input
% =====
%
%       w -> misclousure vector (m)
%       l1 -> L1 carrier-phase ambiguity observable (m)
%       l2 -> L2 carrier-phase ambiguity observable (m)
%       p1 -> L1 pseudorange ambiguity observable (m)
%       p2 -> L2 pseudorange ambiguity observable (m)
%       ambi -> IONO ambiguity parameter (m)
%       cst -> structure with constants
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

% Update misclousure vector
w(nl+1,1)=(l2-l1)-ambi-(1-gamma)*(1/m)*(A0+A1*dlat+A2*dlon);
w(nl+2,1)=p2-p1+(1-gamma)*(1/m)*(A0+A1*dlat+A2*dlon);
