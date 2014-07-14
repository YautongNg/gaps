function cx0=initcx0(sdp,sdt,shzg)
%
% Function initcx0
% ================
%
%       This function initializes the constraint matrix cx0;
%
%  List of Parameters in the Matrix:
% 
%       - Receiver Position (3 - X, Y Z)
%       - Receiver Clock Error
%       - Residual Neutral Atmosphere delay
%       - horizontal gradients (2 -NS, EW) 
%       - Ambiguities
%
% Sintax
% ======
%
%       cx0=initcx0(sdp,sdt,shzg)
%
% Input
% =====
%
%       sdp -> standard deviation for position (m)
%       sdt -> standard deviation for NAD (m)
%       shzg -> standard deviation for horizontal gradients
%
% Output
% ======
%
%       cx0 - 127x127 Matrix - Cov matrix of the constrained parameters
%
% Created/Modified
% ================
%
% When         Who                 What
% ----         ---                 ----
% 2006/05/17   Rodrigo Leandro     Function Created
% 2006/06/28   Rodrigo Leandro     Change from px to cx
% 2009/12/15   Landon Urquhart     Added support for 120 satellites
%
% Comments
% ========
%
%
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================
npar=7;

%==========================================================================
% Initialize Constraint Matrix
%--------------------------------------------------------------------------
cx0=eye(120+npar)*1e10;
%==========================================================================


%==========================================================================
% Position Constraints
%--------------------------------------------------------------------------
%Standard Deviation for Positions - if constrained
% CASE -> Constrain Coordinates
if sdp>0 
    cx0(1:3,1:3)=eye(3)*(sdp^2);
end
% No need of case for uncostrained coordinates, just leave the matrix with
%  1e10's
%==========================================================================

%==========================================================================
% Clock Constraint
%--------------------------------------------------------------------------
% No Constraints are allowed for clock parameter!!
% px0(4,4)=0;
%==========================================================================

%==========================================================================
% Residual Neutral Atmosphere Delay Constraint
%--------------------------------------------------------------------------
% CASE -> Constrain RNAD

 cx0(5,5)=(sdt^2);

%==========================================================================
% Neutral Atmosphere Delay Horizontal gradients
%--------------------------------------------------------------------------
% CASE -> 

cx0(6,6)=(shzg.^2);
cx0(7,7)=(shzg.^2);


% No need of case for uncostrained RNAD, just leave the matrix with 1e10's
%==========================================================================

%==========================================================================
% Ambiguity Constraints
%--------------------------------------------------------------------------
% No Constraints are allowed for ambiguity parameters!!
% px0(6:36,6:36)=0;
%==========================================================================