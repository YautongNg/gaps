function w=updtmv12(w,l1,l2,p1,p2,amb,amb1,amb2,cst)
%
% Function updtmv12
% =================
%
%       This function updates the misclousure vector for L1/L2 ambiguities
%       computation
%
% Sintax
% ======
%
%       w=updtmv12(w,l1,l2,p1,p2,amb)
%
% Input
% =====
%
%       w -> misclousure vector (m)
%       l1 -> L1 carrier-phase ambiguity observable (m)
%       l2 -> L2 carrier-phase ambiguity observable (m)
%       p1 -> L1 pseudorange ambiguity observable (m)
%       p2 -> L2 pseudorange ambiguity observable (m)
%       amb -> ion-free ambiguity (m)
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
% 2006/08/02    Rodrigo Leandro             Function created
%
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

% Get current mv size
nl=size(w,1);

% Update misclousure vector
w(nl+1,1)=l1+amb1;
w(nl+2,1)=l2+amb2;
w(nl+3,1)=p1;
w(nl+4,1)=p2;
w(nl+5,1)=amb+(cst.if1*amb1-cst.if2*amb2);