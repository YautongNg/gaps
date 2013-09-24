function flagl=oceantidel(recxyz,path)


% Function oceantidel
% ==================
%
%
% Sintaxe
% =======
%
%       oceantidel(recxyz)         
%
% Input
% =====
%        
%       recxyz         -> Receiver cartesian coordinates       
%       IGStations.txt -> text file with the OTL coefients for
%                         IGS Stations (Global model FES2004)
%
% Output
% ======
%
%       inputOTL.txt  -> text file to be read for the program hardisp.exe
%                   
%
% Created/Modified
% ================
%
% When          Who                        What
% ----          ---                        ----
% 2010/10/20    Carlos Alexandre Garcia    Function Created
%
% Comments
% ========
%
%       This routine was adapted from the routine hardisp.f,
%       available at ftp://tai.bipm.org/iers/convupdt/chapter7/ (IERS2010)
%
% ==============================
% Copyright 2010 University of New Brunswick
% ============================== 
%--------------------------------------------------------------------------

blq = fopen(fullfile(path,'IGStationsOTL.txt'),'rt');
for i=1:5
 lin=fgets(blq);
end

 stageod=zeros(3,1);
 stageod(2)=(str2double(strtrim(lin(49:58))))*(pi/180);
 stageod(1)=(str2double(strtrim(lin(59:68))))*(pi/180);
 stageod(3)=str2double(strtrim(lin(69:77)));
 staxyz=geod2cart(stageod);
 difstation=sqrt((recxyz(1)-staxyz(1))^2+(recxyz(2)-staxyz(2))^2+...
                (recxyz(3)-staxyz(3))^2);
            
while ~feof(blq)
    if difstation <= 10000
        flagl=1;
        break
    end
    for i=1:11
     lin=fgets(blq);
     if feof(blq)
         flagl=0;
         return;
     end
     
    end
    stageod=zeros(3,1);
    stageod(2)=(str2double(strtrim(lin(49:58))))*(pi/180);
    stageod(1)=(str2double(strtrim(lin(59:68))))*(pi/180);
    stageod(3)=str2double(strtrim(lin(69:77)));
    staxyz=geod2cart(stageod);
    difstation=sqrt((recxyz(1)-staxyz(1))^2+(recxyz(2)-staxyz(2))^2+...
                   (recxyz(3)-staxyz(3))^2);
end

fid=fopen(fullfile(path,'inputOTL.txt'), 'w');
for i=1:6
   lin=fgets(blq);
   fase=lin(1:77);
   fprintf(fid, '%s\n', fase);
end
fclose(fid);
fclose(blq);

