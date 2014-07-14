function cx=bldcx(cx0,prnlist)
%
% Function bldcx
% ==============
%
%       Build the constraint matrix for a list of PRN's. It actually starts
%       with cx=cx0 and then keep destroying the matrix, eliminationg prns
%       that are not in the prn list until the elements match with the prn
%       list. The elimination is simply the elimination of the correspondig
%       row and column of the given prn In this way we keep all covariance 
%       information of the matrix.
%
% Sintax
% ======
%
%       cx=bldcx(cx0,prnlist)
%
% Input
% =====
%
%       cx0 -> Stored constraint matrix
%       prnlist -> List of PRN's
%
% Output
% ======
%
%       cx -> Constraint matrix
%
% Created/Modified
% ================
%
% When              Who                     What
% ----              ---                     ----
% 2006/06/21        Rodrigo Leandro         Function created
% 2009/12/13        Landon Urquhart         Added Support for up to 120 PRN
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================
npar=7;
%============================
% Initialize cx equals to cx0 
cx=cx0;
%============================

%==========================
% Initialize pointer vector
cpl=(npar+1:120+npar)';
%==========================

%==============
% Test each prn
for prn=1:120
    
    %=============================
    % Is this prn in the prn list?
    if ~sum(prnlist==prn)
        
        %=============================================================
        % prn not in the list - eliminate correspondent row and column 
        if prn~=120
            cx=[cx(1:cpl(prn)-1,:);cx(cpl(prn)+1:end,:)];
            cx=[cx(:,1:cpl(prn)-1) cx(:,cpl(prn)+1:end)];
            cpl(prn+1:end)=cpl(prn+1:end)-1;
        else
            cx=cx(1:end-1,1:end-1);
        end
        %=============================================================
        
        %======================
        % Update pointer vector
        cpl(prn)=0;
        %======================
        
    end % if ~sum(prnlist==prn)
    %=============================
    
end % for prn=1:120
%==============