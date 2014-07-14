function releff=rel(sp3,prn,cdate,satclk,satxyz,p0,cst,satvel)
%
% Function releff
% ===============
%
%       Computes the relativistic effect correction
%
% Sintaxe
% =======
%
%
%
% Input
% =====
%
%
%
% Output
% ======
%
%       releff -> relativistic effect correction (m)
%
% Created/Modified
% ================
%
% When              Who                     What
% ----              ---                     ----
% 2006/06/20        Rodrigo Leandro         Function created
%
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

% Compute time in sod
sod=cdate(4,1)*3600+cdate(5,1)*60+cdate(6,1);

% Compute transmission time
%tod=sod-p0/cst.c-satclk/cst.c;

% Compute satellite velocity
%satvel=comsv(sp3,prn,tod);

releff=-2*dotr(satvel,satxyz)/(cst.c);% in meters