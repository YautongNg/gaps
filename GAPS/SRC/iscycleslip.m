function asw=iscycleslip(obuf,obs,poob,prn,cst,lmt,otptu)
%
% Function iscycleslip
% ====================
%
%  Determine if the current observation is a cycle slip or not
%  It uses the geometry free combination of carrierphases:
%      
%    gf(i)=L1*f1(i)-L2*f2(i)
%
%    gf -> geometry free combination
%    L1,L2 -> Carrier wavelengths
%    f1,f2 -> Carrier phase measurements
%    i -> epoch index
%
%  A 2nd order polynomial is adjusted to the buffer 5 observations
%  The diference btw the polynomial extrapolation is compared with
%   the current observation. If difference is greater than imposed limit
%   the observation is flagged as a cycle slip.
%
%
% INPUT
% =====
%       obuf -> observation buffer
%       obs -> current observation
%       poob -> observables position
%       prn -> tested prn
%       lmt -> difference limit (m)
%
% OUTPUT
% ======
%       asw ->  1, cycle slip
%               0, NOT a cycle slip
%
% CREATED/MODIFIED
% ================
% When          Who                     What
% ----          ---                     ----
% 2006/06/06    Rodrigo Leandro         Function created
% 2009/12/15    Landon Urquhart         Support new "constants" format
%
%
% COPYRIGHT 2006, Rodrigo Leandro


% Geometry Free Combination

% Create vector with geometry free combination (gf buffer)
gfb=cst.l1(prn)*obuf.L1(:,prn)-cst.l2(prn)*obuf.L2(:,prn);

% Create geomtry free combination for current observation
ob=obs(obs(:,2)==prn,:);
gfo=cst.l1(prn)*ob(1,poob.L1)-cst.l2(prn)*ob(1,poob.L2);

% Calibrate 2nd degree polynomial for given prn
%pol=polyfitr((1:5)',gfb,2);

% Evaluate Polynomial for current epoch
%pgf=polyvalr(pol,6);

pgf = gfb(5) + gfb(5) - gfb(4); 

% Difference
difgf=abs(gfo-pgf);

% % L1
% 
% % Create vector with L1
% l1b=cst.l1*obuf.L1(:,prn);
% p1b=obuf.P1(:,prn);
% 
% % Create L1 for current observation
% ob=obs(obs(:,2)==prn,:);
% l1o=cst.l1*ob(1,poob.L1);
% p1o=ob(1,poob.P1);
% 
% % Calibrate 2nd degree polynomial for given prn
% poll=polyfitr((1:5)',l1b,2);
% polp=polyfitr((1:5)',p1b,2);
% 
% % Evaluate Polynomial for current epoch
% pl1=polyvalr(poll,6);
% pp1=polyvalr(polp,6);
% 
% % Difference
% difl1=abs((l1o-pl1)-(p1o-pp1));
% 
% % L2
% 
% % Create vector with L2
% l2b=cst.l2*obuf.L2(:,prn);
% p2b=obuf.P2(:,prn);
% 
% % Create L2 for current observation
% ob=obs(obs(:,2)==prn,:);
% l2o=cst.l2*ob(1,poob.L2);
% p2o=ob(1,poob.P2);
% 
% % Calibrate 2nd degree polynomial for given prn
% poll=polyfitr((1:5)',l2b,2);
% polp=polyfitr((1:5)',p2b,2);
% 
% % Evaluate Polynomial for current epoch
% pl2=polyvalr(poll,6);
% pp2=polyvalr(polp,6);
% 
% % Difference
% difl2=abs((l2o-pl2)-(p2o-pp2));


% Condition and flag
if difgf>0.1 %|| difl1>10 || difl2>10
   % fprintf(otptu,'Cycle slip detected for PRN %i at epoch %f\n',prn,ob(1));
   fprintf(otptu,' %i %f\n',prn,ob(1)); 
   asw=1;
else
    asw=0;
end