function [ionop cxi0 ambi]= iono(ionop,cxi0,prnlist,elvlist, ...
    ambi,l1,l2,p1,p2,cst,cpsd,otpt12,otptri,cdate,ocdate,ipp,recllh)
%
% Function iono
% =============
%
%       This function computes the IONO delay using L1/L2. 
%
% Sintax
% ======
%
%       [ionop cxi0 ambi]= iono(ionop,cxi0,prnlist,elvlist, ...
%    ambi,l1,l2,p1,p2,cst,cpsd,cdate,ipp,recllh)
%
% Input
% =====
%
%       ionop - structure with iono model parameters
%               ionop.a0 -> a0 (m)
%               ionop.a1 -> a1 (m/rad)
%               ionop.a2 -> a2 (m/rad)
%       cxi0 - iono model + ambiguity parameters cov. matrix
%       prnlist - PRN list
%       elvlist - Elevation angle list (rad)
%       ambi - iono ambiguity parameters list (m)
%       l1 - L1 reduced observable (m)
%       l2 - L2 reduced observable (m)
%       p1 - P1 reduced observable (m)
%       p2 - P2 reduced observable (m)
%       cst - constants structure
%       cpsd - carrier-phase stdev (m)
%       cdate - current date [Y;M;D;H;M;S]
%       ocdate - old current date [Y;M;D;H;M;S]
%       ipp - Ionospheric Piercing Point list
%             ipp{prn} = 2x1 vector [latitude;longitude]
%                                      [rad]    [rad]
%       recllh - Receiver geodetic coordinates [ lat ; lon ; h ]
%                                               [rad] [rad] [m]
%
% Output
% ======
%
%       Updated cx12,amb1,amb2
%
% Created/Modified
% ================
%
% When              Who                         What
% ----              ---                         ----
% 2006/07/24        Rodrigo Leandro             Function l1l2 created
% 2007/01/15        Rodrigo Leandro             Function iono created
%                                               based on l1l2 function
%
%
% ================================================================
% Copyright 2006-2007 Rodrigo Leandro, University of New Brunswick
% ================================================================


%==========================================================================
% Compute SOD (seconds of day)
%--------------------------------------------------------------------------
sod=cdate(4,1)*3600+cdate(5,1)*60+cdate(6,1);
%==========================================================================


%==========================================================================
%Design matrix, misclousure vector and weight matrix
%--------------------------------------------------------------------------
% Create design matrix
A=updtdmi(prnlist,cst,ipp,recllh,elvlist);
% Initialize misclousure vector and weight matrix:
w=[];
P=[];
% Loop for each satellite of the list
% Build design matrix, misclousure vector and weight matrix
for sat=1:size(prnlist,1)
    % Get current PRN
    prn=prnlist(sat);
    % Get current elevation angle
    elvang=elvlist(sat);
    % Update misclousure vector
    w=updtmvi(w,l1(prn),l2(prn),p1(prn),p2(prn),ambi(prn),elvang, ...
        recllh,ipp{prn},ionop,cst,prn);
    % Update weight matrix
    P=updtwmi(P,elvang);
end
%==========================================================================


%==========================================================================
%Constraints matrix
%--------------------------------------------------------------------------
% Define iono model parameters process noise
ipnoise(1)=100; %[m/h]
ipnoise(2:3)=100; %[(m/rad)/h]
% Build constraint matrix
cxi=bldcxi(cxi0,prnlist,cdate,ocdate,ipnoise);
%==========================================================================


%==========================================================================
% Parameters adjustment
%--------------------------------------------------------------------------
%=======================================
% This block avoids badscaling of the Cx 
idx=(cxi==1e10);
cx1=cxi;
cx1(idx)=1;
icx=inv(cx1);
icx(idx)=1e-10;
%=======================================
%===========
% Adjustment
N=A'*P*A+icx;
u=A'*P*w;
delta=N\u;
cxi=inv(N);
%===========
%=================
%Compute residuals
r=w-A*delta;
%=================
%=============================
% A posteriori variance factor
s0=(r'*P*r)/size(r,1);
%=============================
%==========================================================================


%==========================================================================
% Update parameters
%--------------------------------------------------------------------------
% IONO model
ionop.a0=ionop.a0+delta(1,1);
ionop.a1=ionop.a1+delta(2,1);
ionop.a2=ionop.a2+delta(3,1);

% Ambiguities
for i=4:size(delta,1)
    prn=prnlist(i-3);
    ambi(prn)=ambi(prn)+delta(i,1);
end
%==========================================================================


%==========================================================================
% Update constraint matrix
%--------------------------------------------------------------------------
cxi0=updtcxi0(cxi,prnlist);
%==========================================================================


%==========================================================================
% Write results
% Create a function for this!!
%--------------------------------------------------------------------------
    fprintf(otpt12,'%5i%4i%4i%4i%4i%4i%20.4f%20.4f%20.4f%20.4f\n', ...
        cdate(1:5,1),round(cdate(6,1)),ionop.a0,ionop.a1,ionop.a2,sqrt(s0*cxi(1,1)));
    for j=1:size(r,1)/2
        k=j+3;
        i=(j-1)*2 +1;
        fprintf(otptri,'%5i%4i%4i%4i%4i%4i%20.4f%20.4f%20.4f%20.4f\n', ...
          cdate(1:5,1),round(cdate(6,1)),prnlist(j,1),elvlist(j,1), ...
          r(i,1),cxi(1,k)/sqrt(cxi(1,1))/sqrt(cxi(k,k)));
    end
%==========================================================================