function P=updtwm(P,elvang,cpsd,prsd,prn,useL2C)
%
% Function updtmv
% ===============
%
%       Updates weight matrix for adjustment, using RLPPP standards
%
% Sintax
% ======
%
%       P=updtwm(P,elvang,cpsd,prsd)
%
% Input
% =====
%
%       P -> current weight mattrix
%       elvang -> elevation angle (rad)
%       cpsd -> carrier-phase standard deviation (m)
%       prsd -> pseudorange standard deviation (m)
%
% Output
% ======
%
%       P -> updated weight mattrix
%
% Created/Modified
% ================
%
% When              Who                     What
% ----              ---                     ----
% 2006/06/22        Rodrigo Leandro         Function created
% 2007/04/10        Rodrigo Leandro         Added capability to handle L2C
%
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

% Compute observations weight based on elevation angle and std dev.


if useL2C(prn)
    cpw=(sin(elvang)/cpsd)^2;
    prw=(sin(elvang)/100)^2;
else
    cpw=(sin(elvang)/cpsd)^2;
    prw=(sin(elvang)/prsd)^2;
end

P(end+1:end+2,end+1:end+2)=[prw  0
                             0  cpw];