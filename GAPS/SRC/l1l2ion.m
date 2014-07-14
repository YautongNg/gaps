function [cx12 cx0 amb amb1 amb2]= ...
    l1l2ion(cx0,cx12,prnlist,elvlist,amb,amb1,amb2,l1,l2,p1,p2, ...
    cst,cpsd,otpt12,cdate,rc,ipp,recllh)
%
% Function l1l2
% =============
%
%       This function computes the IONO delay using L1/L2. 
%
% Sintax
% ======
%
%       [cx12 amb1 amb2]= ...
%    l1l2ion(cx0,cx12,prnlist,elvlist,amb,amb1,amb2,l1,l2)
%
% Input
% =====
%
%       cx0 - Parameters cov. matrix
%       cx12 - L1/L2 ambiguities cov. matrix
%       prnlist - PRN list
%       elvlist - Elevation angle list (rad)
%       amb - ionfree ambiguities list (m)
%       amb1 - L1 ambiguties list (cycles)
%       amb2 - L2 ambiguties list (cycles)
%       l1 - L1 ambiguity observable (m)
%       l2 - L2 ambiguity observable (m)
%       cst - constants structure
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
% 2007/01/15        Rodrigo Leandro             Function l1l2ion created
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
for prnl=1:size(prnlist,1)
    % Get current PRN
    prn=prnlist(prnl);
    % Get current elevation angle
    elvang=elvlist(prnl);
    % Update misclousure vector
    w=updtmvi(w,l1(prn),l2(prn),p1(prn),p2(prn),amb(prn),ambi(prn),cst);
    % Update weight matrix
    P=updtwm12(P,elvang,cx0(prn+5,prn+5));
end
%==========================================================================


%==========================================================================
%Constraints matrix
%--------------------------------------------------------------------------
cx=bldcx12(cx12,prnlist);
%==========================================================================


%==========================================================================
% Parameters adjustment
%--------------------------------------------------------------------------
%=======================================
% This block avoids badscaling of the Cx 
idx=(cx==1e10);
cx1=cx;
cx1(idx)=1;
icx=inv(cx1);
icx(idx)=1e-10;
%=======================================
%===========
% Adjustment
N=A'*P*A+icx;
u=A'*P*w;
delta=N\u;
cx=inv(N);
%===========
%==========================================================================


%==========================================================================
% Update ambiguities
%--------------------------------------------------------------------------
for i=1:size(prnlist,1)
    %L1
    amb1(prnlist(i))=amb1(prnlist(i))-delta(2+(i-1)*2+1);
    %L2
    amb2(prnlist(i))=amb2(prnlist(i))-delta(2+(i-1)*2+2);
end
%==========================================================================


%==========================================================================
% Update constraint matrix
%--------------------------------------------------------------------------
cx12=updtcx12(cx,prnlist);
%==========================================================================


%==========================================================================
% Write results
% Create a function for this!!
%--------------------------------------------------------------------------
for i=1:size(prnlist,1)
    prn=prnlist(i);
    fprintf(otpt12,'%5i%4i%4i%4i%4i%4i%4i%20.4f%20.4f%20.4f%20.4f\n', ...
        cdate(1:5,1),round(cdate(6,1)),prn,amb1(prn),amb2(prn),amb(prn),delta(2+2*size(prnlist,1)+1,1));
end
%==========================================================================
