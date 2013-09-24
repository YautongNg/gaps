function px0=initpx0(sdp,sdt)
%
%  Function initpx0
%
%  This function initializes the constraint matrix px0
%
%  List of Parameters in the Matrix:
% 
%       - Receiver Position (3 - X, Y Z)
%       - Receiver Clock Error
%       - Residual Neutral Atmosphere delay
%       - Ambiguities
%
%  Sintaxe: px0=initpx0()
%
%  INPUT
%         
%
%  OUTPUT
%         px0 - 36x36 Matrix - Weight matrix of the constrained parameters
%
% CREATED/MODIFIED
%
% Date         Who                 What
% ----         ---                 ----
% 2006/05/17   Rodrigo Leandro     Function Created
%
% General Comments: Curretly this function supports prn's up to 31!


%==========================================================================
% Initialize Constraint Matrix
%--------------------------------------------------------------------------
px0=zeros(36,36);
%==========================================================================


%==========================================================================
% Position Constraints
%--------------------------------------------------------------------------
%Standard Deviation for Positions - if constrained
% CASE -> Constrain Coordinates
if sdp>0 
    px0(1:3,1:3)=eye(3)*(1/(sdp^2));
end
% No need of case for uncostrained coordinates, just leave the matrix with
%  zeros
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
if sdt>0
    px0(5,5)=(1/(sdt^2));
end
% No need of case for uncostrained RNAD, just leave the matrix with zeros
%==========================================================================

%==========================================================================
% Ambiguity Constraints
%--------------------------------------------------------------------------
% No Constraints are allowed for ambiguity parameters!!
% px0(6:36,6:36)=0;
%==========================================================================

end