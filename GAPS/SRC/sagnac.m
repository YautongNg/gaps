function sagcor=sagnac(satxyz,recxyz,cst)
%
% Function sagnac
% ===============
%
%       Computes the Sagnac delay correction
%
% Sintaxe
% =======
%
%       sagcor=sagnac(satxyz,recxyz)
%
% Input
% =====
%
%       satxyz -> 3x1 vector with satellite XYZ coordinates
%       recxyz -> 3x1 vector with receiver XYZ coordinates
%
% Output
% ======
%
%       sagcor -> Sagnac delay correction (m)
%
% Created/Modified
% ================
%
% When              Who                     What
% ----              ---                     ----
% 2006/02/01        Rodrigo Leandro         Function created.
% 2006/06/20        Rodrigo Leandro         Function addapted to RLPPP I/O
%                                           standards.
%
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

trtime=0.75;
sp=e_r_corr(trtime,satxyz);
dps=1;
it=0;
while max(abs(dps))>0.001
    it=it+1;
    if it>20
        error('Problem in sagnac delay computation - no convergence.');
    end
    gd=norm(sp-recxyz);
    trtime=gd/cst.c;
    oldsp=sp;
    sp=e_r_corr(trtime,satxyz);
    dps=sp-oldsp;
end
sagcor=norm(satxyz-recxyz)-norm(sp-recxyz);