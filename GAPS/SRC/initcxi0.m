function cxi0=initcxi0()
%
% Function initcxi0
% =================
%
%       This function initializes the constraint matrix cxi0 (for IONO
%      modelling);
%
%  List of Parameters in the Matrix:
% 
%       - IONO model parameters (3)
%       - IONO modelling ambiguities (31)
%
% Sintax
% ======
%
%       cxi0=initcxi0()
%
% Input
% =====
%
%       No input!
%
% Output
% ======
%
%       cxi0 - 34x34 Matrix - Cov matrix of the constrained parameters
%
% Created/Modified
% ================
%
% When         Who                 What
% ----         ---                 ----
% 2006/05/17   Rodrigo Leandro     Function initcx0 created;
% 2006/06/28   Rodrigo Leandro     Change from px to cx (in initcx0);
% 2007/01/23   Rodrigo Leandro     Function initcxi0 created based on
%                                  function initcx0.
% 2009/12/13   Landon Urquhart     Support for 120 PRNs
% Comments
% ========
%
%       Curretly this function supports prn's up to 120!
%
%
% ================================================================
% Copyright 2006-2007 Rodrigo Leandro, University of New Brunswick
% ================================================================


%==========================================================================
% Initialize Constraint Matrix
%--------------------------------------------------------------------------
cxi0=eye(123)*1e10;
%==========================================================================