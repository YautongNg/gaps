function apc=genapc(hobs)
%
% Function genapc
% ===============
%
%       Generates the Antenna Phase Center offsets and variation for the 
%       user antenna.
%
% Sintax
% ======
%
%       apc=genapc(hobs)
%
% Input
% =====
%
%       hobs -> structure with information from obs. RINEX header
%
% Output
% ======
%
%       apc -> 22X2 matrix with offsets and variations (m)
%              apc(:,1) -> L1
%              apc(:,2) -> L2
%              apc(1:3,:) -> Offsets (North, East, Up)
%                            apc(1:3,:)=[ NL1 NL2 ; EL1 EL2 ; UL1 UL2 ]
%              apc(4:22,:) -> Variation for el. angles 90:05:00
%
% Created/Modified
% ================
%
% When          Who                         What
% ----          ---                         ----
% 2006/07/17    Rodrigo Leandro             Function created
%
%
% ==============================
% Copyright 2006 Rodrigo Leandro
% ==============================

% Initialize apc
apc=zeros(22,2);

% Open igs_01.pcv file to read its contents
apcf=fopen('igs_01.pcv','rt');

% Read and Ignore file header
for i=1:11
    fgets(apcf);
end

% Set antenna as not found

while 1
    
    % Get antenna model (amodel)
    lin=fgets(apcf);
    amodel=strtrim(lin(16:37));
    % Get L1 offsets (off1)
    lin=fgets(apcf);
    for i=1:3
        off1(i,1)=str2double(lin((i-1)*10+1:i*10));
    end
    % Get L1 variations for el. ang. 90:05:45 (var11)
    lin=fgets(apcf);
    for i=1:10
        var11(i,1)=str2double(lin((i-1)*6+1:i*6));
    end
    % Get L1 variations for el. ang. 40:05:00 (var12)
    lin=fgets(apcf);
    for i=1:9
        var12(i,1)=str2double(lin((i-1)*6+1:i*6));
    end
    % Get L2 offsets (off2)
    lin=fgets(apcf);
    for i=1:3
        off2(i,1)=str2double(lin((i-1)*10+1:i*10));
    end
    % Get L2 variations for el. ang. 90:05:45 (var21)
    lin=fgets(apcf);
    for i=1:10
        var21(i,1)=str2double(lin((i-1)*6+1:i*6));
    end
    % Get L2 variations for el. ang. 40:05:00 (var22)
    lin=fgets(apcf);
    for i=1:9
        var22(i,1)=str2double(lin((i-1)*6+1:i*6));
    end
    minsize=min([size(hobs.anttype,2) size(amodel,2)]);
    if strcmpi(hobs.anttype(1:minsize),amodel(1:minsize))
        apc=[ off1(3,1) off2(3,1) ;off1(1:2,1) off2(1:2,1); var11 var21 ; var12 var22];
        apc(4:22,1)=apc(22:-1:4,1);
        apc(4:22,2)=apc(22:-1:4,2);
        break
    end
    % break loop if end of file reached
    if feof(apcf)
        break
    end
end