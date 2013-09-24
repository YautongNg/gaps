function obs=useL5obs(obs,useL5,poob)
%
% Function useL5obs
% ==============
%
%  This function puts L5 in place of L2, for chosen satellites
%    So L5 is used rather than L2 for chosen satellites
%
% Syntax
% ======
%
%  obs=useL5(obs,useL5)
%
% Input
% =====
%
%       obs -> nsx(no+2) matrix containing observations (same order as stated 
%              in the header)
%              ns -> # of satellites
%              no -> # of observables
%              obs(:,1) -> GPS Time (sow)
%              obs(:,2) -> Satellite PRN
%              obs(:,3:end) -> Observables
%       useL5 -> 1x120 logical vector (1-> use L5; 0-> don't use L5)
%       poob -> structure with observable positions
%
% Output
% ======
%
%       obs -> updated obs
%
% Created/Modified
% ================
%
% When              Who                 What
% ----              ---                 ----
% 2006/11/20        Landon Urquhart     Function created
%
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

for s=1:size(obs,1)
    if useL5(obs(s,2))
        obs(s,poob.L2)=obs(s,poob.L5);
        obs(s,poob.P2)=obs(s,poob.C5);
        obs(s,poob.P1)=obs(s,poob.C1);
    end
end