function cxi=bldcxi(cxi0,prnlist,cdate,ocdate,ipnoise)
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
%       cxi=bldcxi(cxi0,prnlist)
%
% Input
% =====
%
%       cxi0 -> Stored constraint matrix
%       prnlist -> List of PRN's
%
% Output
% ======
%
%       cxi -> Updated constraint matrix
%
% Created/Modified
% ================
%
% When              Who                     What
% ----              ---                     ----
% 2006/08/02        Rodrigo Leandro         Function bldcx12 created 
%                                           addapted from bldcx function
% 2007/01/22        Rodrigo Leandro         Function bldcxi created
%                                           addapted from bldcx function%
%
% ================================================================
% Copyright 2006-2007 Rodrigo Leandro, University of New Brunswick
% ================================================================


%==========================================================================
% Initialize cx equals to cx12
%--------------------------------------------------------------------------
cxi=cxi0;
%==========================================================================


%==========================================================================
% Initialize pointer vector
% cpl -> 31x1 vector
% cpl(prn)=position
%--------------------------------------------------------------------------
cpl=(4:123)';
%==========================================================================


%==========================================================================
% Test each prn to destroy elements of prn's not in the list
%--------------------------------------------------------------------------
for prn=1:120
    
    %=============================
    % Is this prn in the prn list?
    if ~sum(prnlist==prn)
        
        %=============================================================
        % prn not in the list - eliminate correspondent row and column 
        if prn~=120
            
            new_cxi = zeros(size(cxi,1)-1,size(cxi,2)-1);
            new_cxi(1:cpl(prn)-1,1:cpl(prn)-1) = cxi(1:cpl(prn)-1,1:cpl(prn)-1);
            
            new_cxi(1:cpl(prn)-1,cpl(prn):end) = cxi(1:cpl(prn)-1,cpl(prn)+1:end);
            new_cxi(cpl(prn):end,1:cpl(prn)-1) = cxi(cpl(prn)+1:end,1:cpl(prn)-1);
            
            new_cxi(cpl(prn):end,cpl(prn):end) = cxi(cpl(prn)+1:end,cpl(prn)+1:end);
         
            cxi = new_cxi;

            %cxi=[cxi(1:cpl(prn)-1,:);cxi(cpl(prn)+1:end,:)];
            %cxi=[cxi(:,1:cpl(prn)-1) cxi(:,cpl(prn)+1:end)];
            
            cpl(prn+1:end)=cpl(prn+1:end)-1;
            
        else
            
            cxi=cxi(1:end-1,1:end-1);
            
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
% Introduce process noise for IONO delays
%--------------------------------------------------------------------------
% Compute time difference
dt=cdate-ocdate;
dh=dt(3,1)*24+dt(4,1)+dt(5,1)/60+dt(6,1)/3600;
% Compute noise
for i=1:3
    if ipnoise(i)==1e10
        v=cxi(i,i);
        cxi(:,i)=0;
        cxi(i,:)=0;
        cxi(i,i)=v;
    end
end
ipnoise=ipnoise*dh;
% Add noise
cxi(1,1)=cxi(1,1)+ipnoise(1);
cxi(2,2)=cxi(2,2)+ipnoise(2);
cxi(3,3)=cxi(3,3)+ipnoise(3);
%==========================================================================