function cxi0=updtcxi0(cxi,prnlist)
%
% Function updtcxi0
% =================
%
%       Updtaes IONO constraint matrix
%
% Sintax
% ======
%
%       cxi0=updtcxi0(cxi,prnlist)
%
% Input
% =====
%
%       cxi -> IONO covariance matrix
%       prnlist -> list of effective prn's
%
% Output
% ======
%
%       cxi0 -> Updated IONO contraint matrix
%
% Created/Modified
% ================
%
% When              Who                     What
% ----              ---                     ----
% 2006/06/26        Rodrigo Leandro         Function updtcx0 created
% 2007/01/15        Rodrigo Leandro         Fuction created, based on
%                                           updtcx0 function
%
%
% Comments
% ========
%
%       Covariance matrices are in (m^2).
%
%
% ================================================================
% Copyright 2006-2007 Rodrigo Leandro, University of New Brunswick
% ================================================================

%=========================
% What this function does:
%-------------------------
% 1. Add IONO delay parameters noise
% 2. Expand matrix to get cx0
%    Cx -expansion-> Cx0
%=========================

%============================
% IONO delay parameters noise
% Decide how much process noise o add!!!!
%----------------------------
ps1=1e10; % process noise 1 (m^2)
ps2=1e10; % process noise 2 ([m/rad]^2)
cx(1,1)=cx(1,1)+ps1; % adding noise (m^2)
cx(2,2)=cx(2,2)+ps2; % adding noise ([m/rad]^2)
cx(3,3)=cx(3,3)+ps2; % adding noise ([m/rad]^2)
%============================


%=================
% Expand cx to cx0
%-----------------
cxi=eye(43)*1e10;
for i=1:size(cx,1)
    for j=1:size(cx,2)
        if i<4
            ii=i;
        else
            ii=prnlist(i-3)+3;
        end
        if j<4
            jj=j;
        else
            jj=prnlist(j-3)+3;
        end
        cxi(ii,jj)=cx(i,j);
    end
end
%=================