function cx=bldcx12(cx12,prnlist)
%
% Function bldcx
% ==============
%
%       Build the L1/L2 constraint matrix for a list of PRN's. It actually 
%       starts with cx=cx12 and then keep destroying the matrix, 
%       eliminationg prns that are not in the prn list until the elements 
%       match with the prn list. The elimination is simply the elimination 
%       of the correspondig row and column of the given prn In this way we 
%       keep all covariance information of the matrix.
%
% Sintax
% ======
%
%       cx=bldcx12(cx12,prnlist)
%
% Input
% =====
%
%       cx12 -> Stored constraint matrix
%       prnlist -> List of PRN's
%
% Output
% ======
%
%       cx -> Updated constraint matrix
%
% Created/Modified
% ================
%
% When              Who                     What
% ----              ---                     ----
% 2006/08/02        Rodrigo Leandro         Function created - addapted
%                                           from bldcx function
%
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================


%==========================================================================
% Initialize cx equals to cx12
%--------------------------------------------------------------------------
cx=cx12;
%==========================================================================


%==========================================================================
% Initialize pointer vector
% cpl -> 31x1 vector
% cpl(prn)=position
%--------------------------------------------------------------------------
cpl=(1:2:61)';
%==========================================================================


%==========================================================================
% Test each prn to destroy elements of prn's not in the list
%--------------------------------------------------------------------------
for prn=1:31
    
    %=============================
    % Is this prn in the prn list?
    if ~sum(prnlist==prn)
        
        %=============================================================
        % prn not in the list - eliminate correspondent row and column 
        if prn~=31
            cx=[cx(1:cpl(prn)-1,:);cx(cpl(prn)+2:end,:)];
            cx=[cx(:,1:cpl(prn)-1) cx(:,cpl(prn)+2:end)];
            cpl(prn+1:end)=cpl(prn+1:end)-2;
        else
            cx=cx(1:end-2,1:end-2);
        end
        %=============================================================
        
        %======================
        % Update pointer vector
        cpl(prn)=0;
        %======================
        
    end % if ~sum(prnlist==prn)
    %=============================
    
end % for prn=1:31
%==========================================================================


%==========================================================================
% Introduce constraints for clocks (1e10)
%--------------------------------------------------------------------------
cx(3:size(cx,1)+2,3:size(cx,2)+2)=cx;
cx(1:2,:)=0;
cx(:,1:2)=0;
cx(1,1)=1e-10;
cx(2,2)=1e-10;
%==========================================================================

%==========================================================================
% Introduce constraints for IONO delays (1e10)
%--------------------------------------------------------------------------
%siprn=size(prnlist,1);
cx(end+1:end+3,:)=0;
cx(:,end+1:end+3)=0;
cx(end-3+1:end,end-3+1:end)=eye(3)*1e10;
%==========================================================================
