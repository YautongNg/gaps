function c=intsc(clk,prn,sod)
%
% Function intsc
% ==============
%
%       Interpolates the satellite clock offset using precise clock.
%
% Sintaxe
% =======
%
%       c=intsc(clk,prn,sod)
%
% Input
% =====
%
%       clk = structure
%             clk{prn,idx} = 3x1 vector with polinomial coefficients
%             idx = arc (in sod)    number
%                   0-1200      ->  1
%                   1200-2400   ->  2
%                   2400-3600   ->  3
%                   ...             ...
%                   85200-86400 ->  72
%       prn -> PRN of the satellite for which the clock will be computed
%       sod -> time in seconds of day
%
% Output
% ======
%
%       c -> Clock offset for given prn and time
%
% Created/Modified
% ================
%
% When              Who                     What
% ----              ---                     ----
% 2006/06/20        Rodrigo Leandro         Function created
%
% Comments
% ========
%
%       No comments
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

% Determine the arc number
arc=fix(sod/(1200))+1;
if arc>72
    arc=72;
end

% Get polynomial
p=clk{prn,arc};

% Interpolation
c=polyvalr(p,sod);