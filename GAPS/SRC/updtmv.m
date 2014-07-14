function w=updtmv(w,p0,l0)
%
% Function updtmv
% ===============
%
%       Updates misclousure vector for adjustment, using RLPPP standards
%
% Sintax
% ======
%
%       w=updtmv(w,p0,l0)
%
% Input
% =====
%
%       w -> current miclousure vector
%       p0 -> corrected pseudorange (m)
%       l0 -> corrected carrier-phase (m)
%
% Output
% ======
%
%       w -> updated misclousure vector
%
% Created/Modified
% ================
%
% When              Who                     What
% ----              ---                     ----
% 2006/06/21        Rodrigo Leandro         Function created
%
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================


w(end+1:end+2,1)=[p0
                  l0];