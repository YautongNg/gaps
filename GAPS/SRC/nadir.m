function nad=nadir(pt1,pt2)
%
% Function nadir
% ==============
%
%   Computes the nadir angle between two points.
%
% Sintax
% ======
%
%   nad=nadir(pt1,pt2)
%
% Input
% =====
%
%   pt1 -> 3x1 vector with cartesian coordinates of point 1 (pt1) in m
%   pt2 -> 3x1 vector with cartesian coordinates of point 2 (pt1) in m
%
% Output
% ======
%
%   nad -> nadir angle, in radians
%
% Created/Modified
% ================
%
% When          Who                     What
% ----          ---                     ----
% 2006/11/09    Rodrigo Leandro         Function created
%
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

if sum(pt1~=0)==0 || sum(pt2~=0)==0
    nad = 0.0;
    return;
end

%==========================================================================
% Compute vectors
%--------------------------------------------------------------------------
vec1=-pt1;
vec2=pt2-pt1;
%==========================================================================

%==========================================================================
% Compute DOT product
%--------------------------------------------------------------------------
dotpro=dotr(vec1,vec2);
%==========================================================================

%==========================================================================
% Compute the norm of the vectors
%--------------------------------------------------------------------------
norm1=norm(vec1);
norm2=norm(vec2);
%==========================================================================

%==========================================================================
% Compute the dadir angle
%--------------------------------------------------------------------------
nad=acos(dotpro/(norm1*norm2));
%==========================================================================