function c=comsc(clk,clk1,prn,cdate,p0,cst)
%
% Function comsc
% ==============
%
%       Computes satellite clock offset
%
% Sintaxe
% =======
%
%       c=comsc(clk,prn,cdate,p0,cst)
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
%       cdate -> 6x1 vector with date.
%                cdate=[year;month;day;hour;minute;second]
%       p0 -> pseudorange (m)
%       cst -> constants structure, to use cst.c - speed of light
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

% Compute time in seconds of day
sod=round(cdate(4,1)*3600+cdate(5,1)*60+cdate(6,1));


% Compute time in seconds of day
sod=round(cdate(4,1)*3600+cdate(5,1)*60+cdate(6,1));

% Try to find exact time tag in precise clock data
ett=clk1{prn}.clk(clk1{prn}.clk(:,1)==sod,:);
if size(ett,1)==1
    c=ett(1,3)*cst.c;
else
    % Compute clock offset by interpolation
    c=intsc(clk,prn,sod)*cst.c;
end