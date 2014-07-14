function flagf=oceantidef(blqfile,path)
% Function oceantidef
% ==================
%
%
% Sintaxe
% =======
%
%       oceantidef(blqfile)         
%
% Input
% =====
%        
%       blqfile ->  BLQ file inputed by the user.
%       
%       
%                         
%
% Output
% ======
%
%       inputOTL.txt  -> input file for the executable hardisp.exe
%                   
%
% Created/Modified
% ================
%
% When          Who                        What
% ----          ---                        ----
% 2010/11/17    Carlos Alexandre Garcia    Function Created
%
% Comments
% ========
% This routine reads the coefficients from the user BLQ file.
%
% ==============================
% Copyright 2010 University of New Brunswick
% ============================== 
%--------------------------------------------------------------------------
    blq =fopen(fullfile(path,blqfile),'rt');
    lin=fgets(blq);

    header='$$ Ocean loading displacement';
    flag1 = isequal(strtrim(lin(1:30)), header);

    if flag1 ~= 1
       fprintf('The user BLQ file is corrupted.\n')
       return
    end    
    
    for i=1:33
        lin=fgets(blq);
    end
             
    coords='lon/lat:';
    flag2 = isequal(strtrim(lin(41:49)), coords);
          
    if flag2 ~= 1
       fprintf('The user BLQ file is corrupted.\n')
       return
    end

    fid=fopen(fullfile(path,'inputOTL.txt'), 'w');
    for i=1:6
       lin=fgets(blq);
       fase=lin(1:77);
       fprintf(fid, '%s\n', fase);
    end
  
    lin=fgets(blq);
    
    endfile='$$ END TABLE';
    flagf = isequal(strtrim(lin(1:13)), endfile);    
    
    if flagf ~= 1
       fprintf('The user BLQ file is corrupted.\n')
    else
       fprintf('The user BLQ file has been accepted.\n')
    end   
   
    
fclose(fid);
fclose(blq);    
  
end       
           
