function prnatx=sat2prnatx(satatx,y,m,d)
%
% Function sat2prnatx
% ===================
%
%  This function creates a variable with information related to  absolute 
% antenna offset and variation for each prn, for the given date
%
% Sintaxe
% =======
%
%   prnatx=sat2prnatx(satatx,y,m,d)
%
% Input
% =====
%
%       satatx -> structure containing stallite antenna information
%                 refer to readatx.m for satatx format
%       y,m,d -> date for which offsets are required
%
% Output
% ======
%
%       satatx -> structure containing stallite antenna information
%                 same format as satatx, but with prn indexes - prnatx(prn)
%                 refer to readatx.m for satatx format
%
% Created/Modified
% ================
%
% When          Who                     What
% ----          ---                     ----
% 2006/06/08    Rodrigo Leandro         Function prnoff created
% 2006/11/08    Rodrigo Leandro         Function prnoffabs created
%                                       addapted from prnoff.m
% 2006/11/11    Rodrigo Leandro         Function sat2prnatx created
%                                       addapted from prnoffabs.m
% 2009/12/15    Landon Urquhart         declare paratx as all NaN
% 2009/12/15    Landon Urquhart         Support 120 Satellites. 
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
%prnatx=nan(31);
%==========================================================================

%==========================================================================
% Create date in GAPS format (YYYYMMDD)
%--------------------------------------------------------------------------
t=y*10000+m*100+d;
%==========================================================================
prnatx=repmat(struct('prn',NaN,'dazi',NaN,'zen',NaN,'nfreq',NaN,'vfrom',NaN,'vuntil',NaN,'freq',NaN),1,120);
for prn=1:120
    for isat=1:size(satatx,2)
        if satatx(isat).prn==prn ...
                && t>satatx(isat).vfrom && t<satatx(isat).vuntil
            prnatx(prn)=satatx(isat);
            break;
        end
    end
end