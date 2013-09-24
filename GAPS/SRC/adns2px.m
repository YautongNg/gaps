function px=adns2px(px,tp,rwt,cdate,ocdate)
%
% Function adns2px
% ================
%
%       Adds noise to constraint matrix
%
% Sintax
% ======
%
%       px=adns2px(px,tp,rwt,cdate,ocdate)
%
% Input
% =====
%
%       px -> constraint matrix
%       tp -> positioning type (Static/Kinematic)
%       rwt -> Neutral Atm. delay random walk level (mm/h)
%       cdate ->  current date
%       ocdate -> old current date
%
% Output
% ======
%
%       px -> updated constraint matrix
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


% ====================
% Position coordinates
if tp==1
    px(1:3,1:3)=0;
end
% ====================

% ========================
% Neutral atmosphere delay
intvl=(cdate(4,1)-ocdate(4,1))+(cdate(5,1)-ocdate(5,1))/60 ...
    +(cdate(6,1)-ocdate(6,1))/3600;
ns=(intvl*rwt)^2;
px(5,5)=px(5,5)+ns;
% ========================