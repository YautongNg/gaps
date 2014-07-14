function [p1c1m poob]=dp1c1m(p1c1m,hobs,poob,lrtype)
%
% Function dp1c1m
% ===============
%
%       Determine P1-C1 bias mode. If in forced mode, check if observables
%       are available.
%
% Sintax
% ======
%
%       p1c1m=dp1c1m(p1c1m,hobs,lrtype)
%
% Input
% =====
%
%       p1c1m -> P1-C1 bias mode
%                0 -> automatic
%                1 -> NCC
%                2 -> NCC reporting C1
%                3 -> CC
%       hobs -> observation file header
%       lrtype -> list of receiver types
%
% Output
% ======
%
%       p1c1m -> updated P1-C1 bias mode
%
% Created/Modified
% ================
%
% When          Who                     What
% ----          ---                     ----
% 2006/07/11    Rodrigo Leandro         Function created
%
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

if p1c1m==1 && poob.P1==0
    error('RLPPP: Impossible to force NCC receiver - no P1 available.')
end

if p1c1m==2 && poob.C1==0
    error('RLPPP: Impossible to force NCC receiver - no C1 available.')
end

if p1c1m==3 && poob.C1==0
    error('RLPPP: Impossible to force CC receiver - no C1 available.')
end

if p1c1m==0
        for i=1:size(lrtype.ncc,1)
            if strcmp(lrtype.ncc(i,1),hobs.rectype)
                p1c1m=2;
                break
            end
        end
        for i=1:size(lrtype.cc,1)
            if strcmp(lrtype.cc(i,1),hobs.rectype)
                p1c1m=3;
                break
            end
        end
end % if p1c1==0

%if p1c1m>1
%    poob.P1=poob.C1;
%end

if p1c1m==0 && poob.C1 ~=0 && poob.P1 == 0
    p1c1m=2;
    poob.P1=poob.C1;
    %error('RLPPP: Unable to determine receiver type, please force it.')
end

if p1c1m==0
    p1c1m=1;
    warning('Unable to identify receiver type');
    %error('RLPPP: Unable to determine receiver type, please force it.')
end
