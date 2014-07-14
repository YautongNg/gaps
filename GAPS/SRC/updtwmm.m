function P=updtwmm(P,elvang)
%
% Function updtwmm
% ================
%
%       This function updates the weight matrix for code multipath
%       computation
%
% Sintax
% ======
%
%       P=updtwmm(P,elvang)
%
% Input
% =====
%
%       P -> weight matrix
%       elvang -> elevation angle (rad)
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
% 2007/03/21    Rodrigo Leandro             Function updtwmm created,
%                                           adapted from previous versions
%
%
% Comments
% ========
%
%       Using fixed values for carrier and pseudorange std. dev. 
%
% ================================================================
% Copyright 2006-2007 Rodrigo Leandro, University of New Brunswick
% ================================================================

% Get current wm size
nl=size(P,1);

% Update weight matrix
P(nl+1,nl+1)=(sin(elvang)/2)^2;
P(nl+2,nl+2)=(sin(elvang)/2)^2;