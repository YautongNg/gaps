function obuf=upobuf(obs,obuf,poob,p1c1m)
%
% Function upobuf
% ===============
%
%  Updates Observation buffer with current observations
%
% Sintaxe
% =======
%
%       obuf=upobuf(obs,obuf,poob)
% 
% Input
% =====
%
%       obs  ->  observations of current epoch
%       obuf -> current observation buffer
%               obuf.P1(ep,prn) -> P1 buffer
%               obuf.P2(ep,prn) -> P2 buffer
%               obuf.L1(ep,prn) -> L1 buffer
%               obuf.L2(ep,prn) -> L2 buffer
%       poob -> position of observables (RLPPP standard)
%               poob.P1 -> P1 pseudorange position
%               poob.P2 -> P2 pseudorange position
%               poob.L1 -> L1 carrier phase position
%               poob.L2 -> L2 carrier phase position
%
% Output
% ======
%
%       obuf -> updated observation buffer
%
% Created/Modified
% ================
%
% When          Who                     What
% ----          ---                     ----
% 2006/06/15    Rodrigo Leandro         Function created
%
% Comments
% ========
%
%       No comments
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

%--------------------------------------

% Check which type of pseudorange should be used
if p1c1m==1
    ppr1=poob.P1;
else
    ppr1=poob.C1;
end

for iprn=1:size(obs,1)
    
    prn=obs(iprn,2); 

    %------------------------------------
    % Is there current obs. for this prn?
    %if isobs4prn(obs,prn) %In case there is obs. for this prn
        
        %--------------------------------
        % Shift observations one position
        obuf.P1(1:4,prn)=obuf.P1(2:5,prn);
        obuf.P2(1:4,prn)=obuf.P2(2:5,prn);
        obuf.L1(1:4,prn)=obuf.L1(2:5,prn);
        obuf.L2(1:4,prn)=obuf.L2(2:5,prn);
        %--------------------------------
        
        %--------------
        % Update buffer
        obuf.P1(5,prn)=obs(iprn,ppr1);
        obuf.P2(5,prn)=obs(iprn,poob.P2);
        obuf.L1(5,prn)=obs(iprn,poob.L1);
        obuf.L2(5,prn)=obs(iprn,poob.L2);
        %--------------
        
    end % if (sum(obs(:,2)==prn))
    %------------------------------------
    
end % for prn=1:31
%--------------------------------------