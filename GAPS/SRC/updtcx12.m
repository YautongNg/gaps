function cx12=updtcx12(cx,prnlist)
%
% Function updtcx12
% =================
%
%       Updtaes constraint matrix
%
% Sintax
% ======
%
%       cx12=updtcx12(cx,prnlist)
%
% Input
% =====
%
%       cx -> constraint matrix for observed PRN's
%       prnlist -> list of effective prn's
%
% Output
% ======
%
%       cx12 -> Updated contraint matrix for all PRN's
%
% Created/Modified
% ================
%
% When              Who                     What
% ----              ---                     ----
% 2006/08/03        Rodrigo Leandro         Function created, addapted from
%                                           updtcx0 function
%
%
% Comments
% ========
%
%       Covariance matrices are in (m^2).
%
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

%==========================================================================
% Expand cx to cx12
%--------------------------------------------------------------------------


%============================
% Eliminate clock constraints
%----------------------------
cx=cx(3:end,3:end);
%============================


%=================================
% Eliminate Iono delay constraints
%---------------------------------
siprn=size(prnlist,1);
cx=cx(1:siprn*2,1:siprn*2);
%============================


%======================================================
% Initialize matrix with all ambiguities as white noise
%------------------------------------------------------
cx12=eye(62)*1e10;
%======================================================


%====================
% Expansion operation
%--------------------
for i=1:size(cx,1)
    iprn=prnlist(fix((i-1)/2)+1);
    if mod(i,2)==1
        ifreq=1;
    else
        ifreq=2;
    end
    ii=(iprn-1)*2+ifreq;
    for j=1:size(cx,2)
        jprn=prnlist(fix((j-1)/2)+1);
        if mod(j,2)==1
            jfreq=1;
        else
            jfreq=2;
        end
        jj=(jprn-1)*2+jfreq;
        
        cx12(ii,jj)=cx(i,j);
        
    end
end
%====================


%==========================================================================
