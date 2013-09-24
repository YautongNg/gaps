function px=bldpx(px0,prnlist)
%
% Function bldpx
% ==============
%
%       Build the constraint matrix for a list of PRN's. It actually starts
%       with px=px0 and then keep destroying the matrix, eliminationg prns
%       that are not in the prn list until the elements match with the prn
%       list. The elimination is simply the elimination of the correspondig
%       row and column of the given prn In this way we keep all covariance 
%       information of the matrix.
%
% Sintax
% ======
%
%       px=bldpx(px0,prnlist)
%
% Input
% =====
%
%       px0 -> Stored constraint matrix
%       prnlist -> List of PRN's
%
% Output
% ======
%
%       px -> Constraint matrix
%
% Created/Modified
% ================
%
% When              Who                     What
% ----              ---                     ----
% 2006/06/21        Rodrigo Leandro         Function created
%
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

%============================
% Initialize px equals to px0 
px=px0;
%============================

%==========================
% Initialize pointer vector
cpl=(6:36)';
%==========================

%==============
% Test each prn
for prn=1:31
    
    %=============================
    % Is this prn in the prn list?
    if ~sum(prnlist==prn)
        
        %=============================================================
        % prn not in the list - eliminate correspondent row and column 
        if prn~=31
            px=[px(1:cpl(prn)-1,:);px(cpl(prn)+1:end,:)];
            px=[px(:,1:cpl(prn)-1) px(:,cpl(prn)+1:end)];
            cpl(prn+1:end)=cpl(prn+1:end)-1;
        else
            px=px(1:end-1,1:end-1);
        end
        %=============================================================
        
        %======================
        % Update pointer vector
        cpl(prn)=0;
        %======================
        
    end % if ~sum(prnlist==prn)
    %=============================
    
end % for prn=1:31
%==============