function apc=genapcabs(hobs,recatx)
%
% Function genapcabs
% ==================
%
%       Gets the absolute antenna phase center offset and variation for the 
%       user's receiver antenna.
%
% Sintax
% ======
%
%       apc=genapcabs(hobs,recatx)
%
% Input
% =====
%
%       recatx -> structure with antenna information for a receiver list
%       hobs -> structure with information from obs. RINEX header
%
% Output
% ======
%
%       apc -> structure with antenna PC information
%
%
% Created/Modified
% ================
%
% When          Who                         What
% ----          ---                         ----
% 2006/07/17    Rodrigo Leandro             Function genapc created
% 2006/11/08    Rodrigo Leandro             Function genapcabs created
%                                           addapted from genapc.m
%
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

% Create unknown antenna
apc.type='unknown';
apc.dazi=0;
apc.zen=[0;90;5];
apc.nfreq=2;
apc.vfrom=0;
apc.vuntil=99999999;
apc.freq(1).number=1;
apc.freq(1).neu=[0;0;0];
apc.freq(1).noazi=zeros(19,1);
apc.freq(1).azi=[];
apc.freq(2).number=2;
apc.freq(2).neu=[0;0;0];
apc.freq(2).noazi=zeros(19,1);
apc.freq(2).azi=[];



for irec=1:size(recatx,2)
    minsize=min([size(hobs.anttype,2) size(recatx(irec).type,2)]);
    if minsize>0 && strncmpi(hobs.anttype(1:minsize),recatx(irec).type(1:minsize),16)
        if strcmpi(hobs.anttype(17:minsize),recatx(irec).type(17:minsize))
            apc=recatx(irec);
            break
        elseif  minsize>0 && strcmpi(recatx(irec).type(17:minsize),'NONE')
            apc=recatx(irec);
        end    
    end
end