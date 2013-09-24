function P=updtwm12(P,elvang,camb)
%
% Function updtwm12
% =================
%
%       This function updates the weight matrix for L1/L2 ambiguities
%       computation
%
% Sintax
% ======
%
%       P=updtwm12(P,elvang)
%
% Input
% =====
%
%       P -> weight matrix
%       elvang -> elevation angle (rad)
%       cx0 -> constraint matrix from positioning (m^2)
%
% Output
% ======
%
%       P -> updated weight matrix (m)
%
% Created/Modified
% ================
%
% When          Who                         What
% ----          ---                         ----
% 2006/08/02    Rodrigo Leandro             Function created
%
%
% Comments
% ========
%
%       Using fixed values for carrier and pseudorange std. dev. 
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

% Get current wm size
nl=size(P,1);

% Update weight matrix
P(nl+1,nl+1)=(sin(elvang)/0.01)^2;
P(nl+2,nl+2)=(sin(elvang)/0.01)^2;
P(nl+3,nl+3)=(sin(elvang)/2000)^2;
P(nl+4,nl+4)=(sin(elvang)/2000)^2;
 % 25 = 5^2 = uncertainty due to interfreq. biases not being applied
P(nl+5,nl+5)=1/(camb*3000);