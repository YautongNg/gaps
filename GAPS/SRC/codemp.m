function [rdcb rdcbvar]= codemp(ionop,prnlist,elvlist,p1,p2,cst,cdate,ocdate,ipp,recllh,rdcb,rdcbvar,otptmp)
%
% Function codemp
% ===============
%
%       This function computes code multipath. 
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


% Load P1-P2 satellite biases (nanoseconds)
% CODE'S 30-DAY GNSS P1-P2 DCB SOLUTION, ENDING D067, 2007
sp1p2= [  01    -3.148     0.020     
    02     5.839     0.010     
    03    -2.617     0.027     
    04    -1.429     0.023     
    05    -2.582     0.020     
    06    -2.267     0.024     
    07    -4.085     0.036     
    08    -3.052     0.015     
    09    -1.811     0.015     
    10    -3.808     0.038     
    11     2.273     0.030     
    13     1.895     0.017     
    14     0.690     0.014     
    15    -3.778     0.023     
    16     0.997     0.021     
    17     1.372     0.074     
    18     1.589     0.011     
    19     3.834     0.053     
    20    -1.191     0.015     
    21     2.280     0.011     
    22     6.333     0.033     
    23     8.429     0.026     
    24    -4.574     0.015     
    25    -0.540     0.018     
    26    -1.361     0.036     
    27    -2.639     0.012     
    28     1.369     0.033     
    29    -1.131     0.029     
    30    -0.096     0.040     
    31     3.208     0.045     ];


% Modify prnlist and elvlist and use satellites for which P1-P2 is available
prnlist0=prnlist;
for prn=1:120
    if size(sp1p2(sp1p2(:,1)==prn,:),1)==0
        elvlist=elvlist(prnlist(:,1)~=prn,1);
        prnlist=prnlist(prnlist(:,1)~=prn,1);
    end
end

% Create design matrix
A=repmat([cst.if2(prn);cst.if1(prn)],size(prnlist,1),1);

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
    w=updtmvm(w,p1(prn),p2(prn),ionop,sp1p2,rdcb,cst,elvang, ...
    recllh,ipp{prn},prn);
    % Update weight matrix
    P=updtwmm(P,elvang);
end

%===========
% Adjustment
N=A'*P*A;
u=A'*P*w;
delta=N\u;
rdcb=rdcb+delta;
rdcbvar=inv(N);
%===========
%=================
%Compute residuals
r=w-A*delta;
%=================
%=============================
% A posteriori variance factor
s0=(r'*P*r)/size(r,1);
%=============================

fprintf(otptmp,'%5i%4i%15.4f%15.4f%15.4f\n',sod,0,rdcb,0,0);
for i=1:size(prnlist,1)
    fprintf(otptmp,'%5i%4i%15.4f%15.4f%15.4f\n',sod,prnlist(i),r((i-1)*2+1),r((i-1)*2+2),elvlist(i)*180/pi);
end

