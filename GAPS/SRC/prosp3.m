function [sp3 dat]=prosp3(prename1,prename2)
%

fprintf(1,'Generating Orbits:\n')
fprintf(1,'    Reading Orbit files...\n')

% Read Precise Ephemeris files
[sp31 dat]=readsp3(prename1);
if ~strcmp(prename2,'none')
    [sp32 dat2]=readsp3(prename2);
end


fprintf(1,'    Processing...\n')

% Add Next day first obs. to complete time series
if ~strcmp(prename2,'none')
    sp31.x(:,end+1:end+3*3600/900+1)=sp32.x(:,1:3*3600/900+1);
    sp31.y(:,end+1:end+3*3600/900+1)=sp32.y(:,1:3*3600/900+1);
    sp31.z(:,end+1:end+3*3600/900+1)=sp32.z(:,1:3*3600/900+1);
    sp31.t(:,end+1:end+3*3600/900+1)=sp32.t(:,1:3*3600/900+1);
end



    
% Generate Time Tag Vectors
tt1=(0:900:6*3600);
% Generate orbits for each PRN
lprn=[]; % prn list
for i=1:size(sp31.x,1)
    if sum(sp31.x(i,:))~=0
        lprn=[lprn;i]; % update prn list
        % 0 - 6 h
        px{1,i}=polyfitr(tt1,sp31.x(i,1:6*3600/900+1),16);
        py{1,i}=polyfitr(tt1,sp31.y(i,1:6*3600/900+1),16);
        pz{1,i}=polyfitr(tt1,sp31.z(i,1:6*3600/900+1),16);
        % 3 - 9 h
        px{2,i}=polyfitr(tt1,sp31.x(i,(3*3600/900)+1:(9*3600/900)+1),16);
        py{2,i}=polyfitr(tt1,sp31.y(i,(3*3600/900)+1:(9*3600/900)+1),16);
        pz{2,i}=polyfitr(tt1,sp31.z(i,(3*3600/900)+1:(9*3600/900)+1),16);
        % 6 - 12 h
        px{3,i}=polyfitr(tt1,sp31.x(i,(6*3600/900)+1:(12*3600/900)+1),16);
        py{3,i}=polyfitr(tt1,sp31.y(i,(6*3600/900)+1:(12*3600/900)+1),16);
        pz{3,i}=polyfitr(tt1,sp31.z(i,(6*3600/900)+1:(12*3600/900)+1),16);       
        % 9 - 15 h
        px{4,i}=polyfitr(tt1,sp31.x(i,(9*3600/900)+1:(15*3600/900)+1),16);
        py{4,i}=polyfitr(tt1,sp31.y(i,(9*3600/900)+1:(15*3600/900)+1),16);
        pz{4,i}=polyfitr(tt1,sp31.z(i,(9*3600/900)+1:(15*3600/900)+1),16);
        % 12 - 18 h
        px{5,i}=polyfitr(tt1,sp31.x(i,(12*3600/900)+1:(18*3600/900)+1),16);
        py{5,i}=polyfitr(tt1,sp31.y(i,(12*3600/900)+1:(18*3600/900)+1),16);
        pz{5,i}=polyfitr(tt1,sp31.z(i,(12*3600/900)+1:(18*3600/900)+1),16);
        % 15 - 21 h
        px{6,i}=polyfitr(tt1,sp31.x(i,(15*3600/900)+1:(21*3600/900)+1),16);
        py{6,i}=polyfitr(tt1,sp31.y(i,(15*3600/900)+1:(21*3600/900)+1),16);
        pz{6,i}=polyfitr(tt1,sp31.z(i,(15*3600/900)+1:(21*3600/900)+1),16);    
        if ~strcmp(prename2,'none')
            %18 - 24 h
            px{7,i}=polyfitr(tt1,sp31.x(i,(18*3600/900)+1:(24*3600/900)+1),16);
            py{7,i}=polyfitr(tt1,sp31.y(i,(18*3600/900)+1:(24*3600/900)+1),16);
            pz{7,i}=polyfitr(tt1,sp31.z(i,(18*3600/900)+1:(24*3600/900)+1),16);
            %21 - 27 h
            px{8,i}=polyfitr(tt1,sp31.x(i,(21*3600/900)+1:(27*3600/900)+1),16);
            py{8,i}=polyfitr(tt1,sp31.y(i,(21*3600/900)+1:(27*3600/900)+1),16);
            pz{8,i}=polyfitr(tt1,sp31.z(i,(21*3600/900)+1:(27*3600/900)+1),16);       
        end
    end
end
%fprintf(1,'    Orbits computed for %i satellites.\n',size(lprn,1));
sp3={px py pz};
fprintf(1,'    Done.\n')
