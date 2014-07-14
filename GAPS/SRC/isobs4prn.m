function asw=isobs4prn(obs,prn,clk)
%
% Function isobs4prn
% ==================
%
%       Checks if there are observations for a given prn.
%       To return TRUE there should be observations for all observables, 
%       all of them different from zero. In RINEX standard zero means 
%       'no observation available'. Any other case is flegged as  FALSE.
%
% SINTAXE
% =======
%
%         isobs4prn(obs,prn)
%
% INPUT
% =====
%
%       obs -> nsxno matrix containing observations (same order as stated 
%              in the header)
%              ns -> # of satellites
%              no -> # of observables
%              obs(:,1) -> GPS Time (sow)
%              obs(:,2) -> Satellite PRN
%              obs(:,3:end) -> Observables
%
%       prn -> Tested PRN
%
% OUTPUT
% ======
%
%       Boolean
%
% CALLS
% =====
%
%       No calls
%
% CREATED/MODIFIED
% ================
%
% When          Who                  What
% ----          ---                  ----
% 2006/06/19    Rodrigo Leandro      Function created
%
% COMMENTS
% ========
%
%  No comments
%
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

asw=0;
for i=1:size(obs,1)
    if obs(i,2) == prn
        %sumZero = 0;
        %for iobs=3:size(obs,2)
        %    if obs(i,iobs) == 0, sumZero=sumZero+1;end;
        %end
        if size(clk,2)>=prn && size(clk{prn},2) ~= 0
            asw=1;
        end
        return;
    end
end

