function obuf=initobuf()
%
% Function initobuf
%
% Initializes Observation Buffer
%
%    obuf -> observation buffer
%            obuf.P1(ep,prn) -> P1 buffer
%            obuf.P2(ep,prn) -> P2 buffer
%            obuf.L1(ep,prn) -> L1 buffer
%            obuf.L2(ep,prn) -> L2 buffer
%
% SINTAXE: obuf=initobuf()
%
% CREATED/MODIFIED
%
% When         Who                What
% 2006/05/25   Rodrigo Leandro    Function created
% 2009/12/13   Landon Urquhart    Supports up to 120 PRNs
%
% Copyright 2006 Rodrigo Leandro

obuf.P1=NaN(5,120); % P1 buffer
obuf.P2=NaN(5,120); % P2 buffer
obuf.L1=NaN(5,120); % L1 buffer
obuf.L2=NaN(5,120); % L2 buffer