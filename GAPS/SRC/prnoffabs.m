function soff=prnoffabs(satatx,cst,y,m,d)
%
% Function prnoffabs
% ==================
%
%  This function creates a variable with the absolute antenna offsets for 
% each prn, for the given date
%
% Sintaxe
% =======
%
%   soff=prnoffabs(y,m,d)
%
% Input
% =====
%
%       satatx -> structure containing stallite antenna information
%                 refer to readatx.m for satatx format
%       cst -> constants structure
%       y,m,d -> date for which offsets are required
%
% Output
% ======
%
%       soff -> 31x3 matrix with antenna offsets
%               soff(PRN,1)=X offset*
%               soff(PRN,2)=Y offset*
%               soff(PRN,3)=Z offset*
%               (*) Satellite body coordinate system
%
% Created/Modified
% ================
%
% When          Who                     What
% ----          ---                     ----
% 2006/06/08    Rodrigo Leandro         Function prnoff created
% 2006/11/08    Rodrigo Leandro         Function prnoffabs created
%                                       addapted from prnoff.m
% 2009/12/15    Landon Urquhart         Support up to 120 satellites
% 2009/12/15    Landon Urquhart         Initialize soff.
% 2009/12/14    Landon Urquhart         Support new "constants" format
%
% Comments
% ========
%
%       This fuction is running for prn 1:31, following GAPS standard
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

%==========================================================================
% Initialize soff with NaN
%--------------------------------------------------------------------------
soff=nan(120,3);
%==========================================================================

%==========================================================================
% Create date in GAPS format (YYYYMMDD)
%--------------------------------------------------------------------------
t=y*10000+m*100+d;
%==========================================================================


for isat=1:size(satatx,2)
    if t>satatx(isat).vfrom && t<satatx(isat).vuntil
        soff(satatx(isat).prn,1:3)=(cst.if1(satatx(isat).prn)*satatx(isat).freq(1).neu'- ...
            cst.if2(satatx(isat).prn)*satatx(isat).freq(2).neu')/1000;
    end
end