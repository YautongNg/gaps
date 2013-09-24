function cx0=updtcx0(cx,prnlist,tp,rwt,rwhg,cdate,ocdate)
%
% Function updtcx0
% ================
%
%       Updtaes constraint matrix
%
% Sintax
% ======
%
%       cx0=updtcx0(N,prnlist,tp,rwt,cdate,ocdate)
%
% Input
% =====
%
%       N -> Normal matrix
%       prnlist -> list of effective prn's
%       tp -> type of positioning
%       rwt -> random walk for NAD (mm/h)
%       cdate -> 6x1 vector with current date
%       ocdate -> 6x1 vector with old current date
%
% Output
% ======
%
%       cx0 -> Updated contraint matrix
%
% Created/Modified
% ================
%
% When              Who                     What
% ----              ---                     ----
% 2006/06/26        Rodrigo Leandro         Function created
% 2009/09/30        Landon Urquhart         Modified application of random
%                                           walk for NAD
% 2009/12/15        Landon Urquhart         Support up to 120 PRNs
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

% 1. Compute Cx
%    Cx=inv(N)
% 2. Add Neutral Atmosphere delay noise
% 3. Add Clock noise
% 4. Add Coordinates noise
%    Cx=Cx+Ce
% 5. Expand matrix to get cx0
%    Cx -expansion-> Cx0

%==========
%Compute Cx
%cx=inv(N);
%==========
npar=7;
%==========
% NAD Noise
    intvl=(cdate(4,1)-ocdate(4,1))+(cdate(5,1)-ocdate(5,1))/60 ...
        +(cdate(6,1)-ocdate(6,1))/3600;
    ns=(intvl*(rwt/1000)^2);
    cx(5,5)=cx(5,5)+ns; % (m^2)
%==========

%====================
% Clock noise (white)
%cx(:,4)=0; % |
%cx(4,:)=0; % |-> reseting covariances
cx(4,4)=9e10; % reseting variance (m^2)
%============

%==========
% HZG noise 
    intvl=(cdate(4,1)-ocdate(4,1))+(cdate(5,1)-ocdate(5,1))/60 ...
        +(cdate(6,1)-ocdate(6,1))/3600;
    nshzg=(intvl*(rwhg/1000)^2);
    cx(6,6)=cx(6,6)+nshzg; % (m^2)
    cx(7,7)=cx(7,7)+nshzg; % (m^2)
%==========

%==================
% Coordinates noise
if tp==1 % tp=1->kinematic
    %cx(:,1:3)=0; % |
    %cx(1:3,:)=0; % |-> reseting covariances
    cx(1:3,1:3)=eye(3)*1e10; % reseting variances
elseif tp==0
    % If tp=0-> static - keep current coordinates constraints
else
    error('Invalid processing mode. Must enter 0 for static or 1 for kinematic');
end
% If tp=0-> static - keep current coordinates constraints
%==================

%=================
% Expand cx to cx0
cx0=eye(120+npar)*1e10;
for i=1:size(cx,1)
    for j=1:size(cx,2)
        if i<npar+1
            ii=i;
        else
            ii=prnlist(i-npar)+npar;
        end
        if j<npar+1
            jj=j;
        else
            jj=prnlist(j-npar)+npar;
        end
        cx0(ii,jj)=cx(i,j);
    end
end
%=================