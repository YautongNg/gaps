function blk=prn2blk(blkprn,y,m,d,prn)
%
% Function prn2blk
% ================
%
%   Returns the Block of the satellites given their PRN
%
% Sintaxe
% =======
%
%       blk=prn2blk(dt,prn)
%
% Input
% =====
%
%       blkprn -> nx5 matrix with block/prn information 
%                 (from blkprn.ppp file)
%       y,m,d -> date (Year,Month,Day) for which block shoud be determined
%       prn -> nx1 vector with satellite prn's
%
% Output
% ======
%
%       blk -> nx1 vector with staellite block codes
%
%              Block Codes:
%                           1- II
%                           2- IIA
%                           3- IIR
%                           4- IIR-M
%
% Created/Modified
% ================
%
% When              Who                     What
% ----              ---                     ----
% 2006/02/01        Rodrigo Leandro         Function created
% 2006/06/08        Rodrigo Leandro         Modifications to accept vector
%                                           format for prn and blk
% 2006/06/08        Rodrigo Leandro         Get information about block/prn
%                                           from variable
%                                           Get date as input to consider 
%                                           constelation changes over time
%
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

%Initialize blk
blk=zeros(size(prn));

%Create date format compatible with blkprn (YYYYMMDD)
dt=y*10000+m*100+d;

for i=1:size(prn,1)
    blk=blkprn( blkprn(:,3)==prn(i) & ...
                blkprn(:,4)<=dt & ...
                blkprn(:,5)>=dt,1);
end