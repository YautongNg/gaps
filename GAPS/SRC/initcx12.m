function cx12=initcx12()
%
% Function initcx0
% ================
%
%       This function initializes the constraint matrix for L1 and L2 
%       ambiguities (cx12);
%
% Sintax
% ======
%
%       cx12=initcx12()
%
% Input
% =====
%
%       No input.
%
% Output
% ======
%
%       cx12 - 62x62 matrix
%              cx12(i,i)= Variance of PRN 
%
% Created/Modified
% ================
%
% When         Who                 What
% ----         ---                 ----
% 2006/07/24   Rodrigo Leandro     Function Created
% 2006/08/02   Rodrigo Leandro     Change cx12 type. Now it is a matrix 
%                                  instead of a structure. 
% 2009/12/13   Landon Urquhart     Supports up to 120 PRNs
% Comments
% ========
%
%       Curretly this function supports prn's up to 120!
%
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================


%==========================================================================
% Initialize Constraint Matrix
%--------------------------------------------------------------------------
cx12=eye(240)*1e10;
% 140 = 120 prn's * 2 frequencies
%=========================================================================