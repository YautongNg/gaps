function px0=updtpx0(N,prnlist,tp,rwt,cdate,ocdate)
%
% Function updtpx0
% ================
%
%       Updtaes constraint matrix
%
% Sintax
% ======
%
%       px0=updtpx0(N,prnlist,tp,rwt,cdate,ocdate)
%
% Input
% =====
%
%       N -> Normal matrix
%       prnlist -> list of effective prn's
%       apvf -> a posteriori variance factor
%
% Output
% ======
%
%       px0 -> Updated contraint matrix (coordinates,recclk and NAD)
%       pam -> updated ambiguity constraints vector
%
% Created/Modified
% ================
%
% When              Who                     What
% ----              ---                     ----
% 2006/06/26        Rodrigo Leandro         Function created
%
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

% 1. Compute Cx
% 2. Add Neutral Atmosphere delay noise
% 3. Compute px
% 4. Expand matrix to get px0
% 5. Deal with Coordinates noise

%==========
%Compute Cx
Cx=inv(N);
%==========

%==========
% NAD Noise
intvl=(cdate(4,1)-ocdate(4,1))+(cdate(5,1)-ocdate(5,1))/60 ...
    +(cdate(6,1)-ocdate(6,1))/3600;
ns=(intvl*rwt)^2;
Cx(5,5)=Cx(5,5)+ns;
%==========

%==========
%Compute px
px=inv(Cx);
%==========

%==========
% Expand px
px0=zeros(36,36);
for i=1:size(px,1)
    for j=1:size(px,2)
        if i<6
            ii=i;
        else
            ii=prnlist(i-5)+5;
        end
        if j<6
            jj=j;
        else
            jj=prnlist(j-5)+5;
        end
        px0(ii,jj)=px(i,j);
    end
end
%==========