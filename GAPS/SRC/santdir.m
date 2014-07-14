function sdir=santdir(xsat,xsun)
%
% Function santdir
% ================
%
%       Computes the direction of the satellite antenna.
%
% Sintax
% ======
%
%       sdir=santdir(xsat,t)
%
% Input
% =====
%
%       xsat    -> Satellite CM geocentric position (3x1 vector)
%       t       -> time (mjd transformed from GPS time)
%
% Output
% ======
%
%       sdir    -> Satellite antenna direction (3x3 matrix)
%                  sdir=[xs;ys;zs]
%
% Created/Modified
% ================
%
% When          Who                 What
% ----          ---                 ----
% 2006/06/29    Rodrigo Leandro     Function Created
%
% Comments
% ========
%
%       No comments
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

if xsat(1)==0 || xsat(2)==0 || xsat(3)==0
    sdir=eye(3);
    return;
end

% Compute xk and its norm xknorm
desat=sqrt(xsat(1)^2+xsat(2)^2+xsat(3)^2);
vec(3)=-xsat(3)/desat;
vec(2)=-xsat(2)/desat;
vec(1)=-xsat(1)/desat;
%xknorm=sqrt(xk(1)^2+xk(2)^2+xk(3)^2);

sdir(3,3)=vec(3);
sdir(3,1)=vec(1);
sdir(3,2)=vec(2);

% Compute the position of the sun
%xsun=sunpos(t);

% compute unit vector xs
vec(3)=xsun(3)-xsat(3);
vec(2)=xsun(2)-xsat(2);
vec(1)=xsun(1)-xsat(1);
dss=sqrt(vec(1)^2+vec(2)^2+vec(3)^2);  
vec(3)=vec(3)/dss;
vec(2)=vec(2)/dss;
vec(1)=vec(1)/dss;

% compute unit vector xj
% Cross Product
sdir(2,3) = sdir(3,1)*vec(2) - sdir(3,2)*vec(1);
sdir(2,1) = sdir(3,2)*vec(3) - sdir(3,3)*vec(2);
sdir(2,2) = sdir(3,3)*vec(1) - sdir(3,1)*vec(3);
xksnor=sqrt(sdir(2,1)^2+sdir(2,2)^2+sdir(2,3)^2);
sdir(2,3)=sdir(2,3)/xksnor;
sdir(2,2)=sdir(2,2)/xksnor;
sdir(2,1)=sdir(2,1)/xksnor;

%xjnor=sqrt(xj(1)^2+xj(2)^2+xj(3)^2);

% compute unit vector xi
% Cross Product
vec(3) = sdir(2,1)*sdir(3,2) - sdir(2,2)*sdir(3,1);
vec(1) = sdir(2,2)*sdir(3,3) - sdir(2,3)*sdir(3,2);
vec(2) = sdir(2,3)*sdir(3,1) - sdir(2,1)*sdir(3,3);
xjknor=sqrt(vec(1)^2+vec(2)^2+vec(3)^2);
vec(3)=vec(3)/xjknor;
vec(2)=vec(2)/xjknor;
vec(1)=vec(1)/xjknor;

%xinor=sqrt(xi(1)^2+xi(2)^2+xi(3)^2);

sdir(1,1)=vec(1);
sdir(1,2)=vec(2);
sdir(1,3)=vec(3);

% sdir(2,1)=xj(1);
% sdir(2,2)=xj(2);
% sdir(2,3)=xj(3);

%sdir=[xi;xj;xk];


    
end