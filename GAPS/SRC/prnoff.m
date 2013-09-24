function soff=prnoff(y,m,d)
%
% Function prnoff
% ===============
%
%  This function creates a variable with the antenna offsets for each prn,
%  for the given date
%
% Sintaxe
% =======
%
%   soff=prnoff(y,m,d)
%
% Input
% =====
%
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
% 2006/06/08    Rodrigo Leandro         Function created
%
% Comments
% ========
%
%       This function requires the files GCSI.ppp and ISAO.ppp
%       This fuction is running for prn 1:31, following RLPPP standard
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

% Load ISAO.ppp file
of=load('ISAO.ppp');

% Load GCSI.ppp file
gcs=load('GCSI.ppp');

% Create date in GCSI format (YYYYMMDD)
t=y*10000+m*100+d;

for prn=1:31
    if sum(gcs(:,3)==prn & gcs(:,4)<=t & gcs(:,5)>=t)>0
        soff(prn,1:3)=of( ...
            gcs( gcs(:,3)==prn & ...
                 gcs(:,4)<=t & ...
                 gcs(:,5)>=t,1), ...
                2:4);
    else
        soff(prn,1:3)=NaN;
    end
end