function csp=santoff(xsat,offset,xsun)
%
% Function santoff
% ================
%
%       Correction for Satellite ANTenna OFFset
%
% Sintaxe
% =======
%
%       csp=santoff(sp,offset,t)
%
% Input
% =====
%
%       xsat    -> Satellite CM geocentric position (3x1 vector)
%       offset  -> 1x3 vector with CM offsets
%       t       -> time (mjd transformed from GPS time)
%
% Output
% ======
%
%       csp     -> Satellite APC geocentric position (3x1 vector)
%
% Created/Modified
% ================
%
% When          Who                 What
% ----          ---                 ----
% 2006/02/01    Rodrigo Leandro     Function Created
% 2006/06/14    Rodrigo Leandro     Modifications to addapt the function to
%                                   RLPPP inputs. Offsets are now explcity 
%                                   inputs, instead of PRN.
%
% Comments
% ========
%
%       No comments
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

%au=1.4959787061e+11;	 % IERS STANDARDS (1992)

% Speed of Light
%speed=299792458;

% conversion from degrees to radians
%pid = pi/180;

if xsat(1)==0 || xsat(2)==0 || xsat(3)==0
    csp(1:3,1) = xsat(1:3);
    return;
end

dx=offset(1,1);
dy=offset(1,2);
dz=offset(1,3);

% Compute xk and its norm xknorm
desat=sqrt(xsat(1)^2+xsat(2)^2+xsat(3)^2);
xk(3)=-xsat(3)/desat;
xk(2)=-xsat(2)/desat;
xk(1)=-xsat(1)/desat;

%xknorm=sqrt(xk(1)^2+xk(2)^2+xk(3)^2);

% Compute the position of the sun
%xsun=sunpos(t);

% compute unit vector xs
delta(3)=xsun(3)-xsat(3);
delta(2)=xsun(2)-xsat(2);
delta(1)=xsun(1)-xsat(1);

dss=sqrt(delta(1)^2+delta(2)^2+delta(3)^2);  
xs(3)=delta(3)/dss;
xs(2)=delta(2)/dss;
xs(1)=delta(1)/dss;

% compute unit vector xj
% Cross Product
xks(3) = xk(1)*xs(2) - xk(2)*xs(1);
xks(1) = xk(2)*xs(3) - xk(3)*xs(2);
xks(2) = xk(3)*xs(1) - xk(1)*xs(3);
xksnor=sqrt(xks(1)^2+xks(2)^2+xks(3)^2);

xj(3)=xks(3)/xksnor;
xj(2)=xks(2)/xksnor;
xj(1)=xks(1)/xksnor;

%xjnor=sqrt(xj(1)^2+xj(2)^2+xj(3)^2);

% compute unit vector xi
% Cross Product
xjk(3) = xj(1)*xk(2) - xj(2)*xk(1);
xjk(1) = xj(2)*xk(3) - xj(3)*xk(2);
xjk(2) = xj(3)*xk(1) - xj(1)*xk(3);
xjknor=sqrt(xjk(1)^2+xjk(2)^2+xjk(3)^2);

xi(3)=xjk(3)/xjknor;
xi(2)=xjk(2)/xjknor;
xi(1)=xjk(1)/xjknor;

%xinor=sqrt(xi(1)^2+xi(2)^2+xi(3)^2);

% apply correction
csp(3,1)=xsat(3)+(dx*xi(3)+dy*xj(3)+dz*xk(3));
csp(2,1)=xsat(2)+(dx*xi(2)+dy*xj(2)+dz*xk(2));
csp(1,1)=xsat(1)+(dx*xi(1)+dy*xj(1)+dz*xk(1));

end