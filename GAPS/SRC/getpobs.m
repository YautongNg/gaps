function poob=getpobs(hobs)
%
% Function getpobs
% ================
% Get position of observables in observation file, from header variable
%
% INPUT
% =====
% hobs -> structure containing header information
%
% OUTPUT
% ======
% poob -> structure containing observable positions
%         poob.P1 -> P1 pseudorange position
%         poob.P2 -> P2 pseudorange position
%         poob.C1 -> C1 pseudorange position
%         poob.C2 -> C2 pseudorange position
%         poob.C5 -> C5 pseudorange position
%         poob.L1 -> L1 carrier phase position
%         poob.L2 -> L2 carrier phase position
%         poob.L5 -> L1 carrier phase position

%
% CREATED/MODIFIED
% ================
% When          Who                  What
% ----          ---                  ----
% 2006/06/01    Rodrigo Leandro      Function created
% 2006/06/16    Rodrigo Leandro      Change position from 'i' to 'i+2'
%                                    because in the obs matrix there are
%                                    two columns, for time and prn before
%                                    the observations.
% 2006/07/11    Rodrigo Leandro      Automatically switch to C1 if no P1 
%                                    available 
% 2006/11/20    Rodrigo Leandro      Added C2 
%
% COMMENTS
% ========
% P1,P2,C2,L1,L2 with UPPERCASE!!!
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

poob.P1=0;
poob.C1=0;

for i=1:size(hobs.obstype,2)
    if strcmp(hobs.obstype{1,i},'P1')
        poob.P1=i+2;
    end
    if strcmp(hobs.obstype{1,i},'C1')
        poob.C1=i+2;
    end
    if strcmp(hobs.obstype{1,i},'P2')
        poob.P2=i+2;
    end
    if strcmp(hobs.obstype{1,i},'C2')
        poob.C2=i+2;
    end
    if strcmp(hobs.obstype{1,i},'C5')
        poob.C5=i+2;
    end
    if strcmp(hobs.obstype{1,i},'L1')
        poob.L1=i+2;
    end
    if strcmp(hobs.obstype{1,i},'L2')
        poob.L2=i+2;
    end
    if strcmp(hobs.obstype{1,i},'L5')
        poob.L5=i+2;
    end
end

%if poob.C1~=0
%    poob.P1=poob.C1;
%end