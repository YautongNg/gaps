function obs=useC2(obs,useL2C,poob)
%
% Function useC2
% ==============
%
%  This function puts C2 in place of P2, for IIR-M satellites
%    So C2 is used rather than P2 for chosen satellites
%
% Syntax
% ======
%
%  obs=useC2(obs,useL2C)
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
%       useL2C -> 1x31 logical vector (1-> use C2; 0-> don't use C2)
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
% 2006/11/20        Rodrigo Leandro     Function created
%
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

for s=1:size(obs,1)
    if useL2C(obs(s,2))
        obs(s,poob.P2)=obs(s,poob.C2);
    end
end