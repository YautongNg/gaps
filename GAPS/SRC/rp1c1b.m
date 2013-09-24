function [p1c1 lrtype]=rp1c1b(p1c1name,path)
%
% Function rp1c1b
% ===============
%
%       Reads the contents of the p1c1bias.ppp file and returns the values
%       in p1c1 matrix
%
% Sintax
% ======
%
%       [p1c1 lrtype]=rp1c1b()
%
% Input
% =====
%
%       No input.
%
% Output
% ======
%
%       p1c1 -> nx41 matrix with biases
%               p1c1(:,1)=date (YYYYMMDD)
%               p1c1(:,2:41)=biases (nsec)
%
%       lrtype -> structure with receiver types list
%                lrtype.cc{:,1} -> list of cross-correlation receivers
%                lrtype.ncc{:,1} -> list of NON-cross-correlation receivers
%
% Created/Modfied
% ===============
%
% When          Who                     What
% ----          ---                     ----
% 2007/07/11    Rodrigo Leandro         Function created
% 2008/08/11    Rodrigo Leandro         Return an error message in case the 
%                                       requested file is not available 
%
%
% ==========================================
% Copyright 2008 University of New Brunswick
% ==========================================

p1c1 = zeros(100,41);
ncc = 0;
nncc = 0;
ninp =  0;

% Open file
fid = fopen(fullfile(path,p1c1name),'rt');

if fid == -1
    error(['Not possible to open and read P1C1 bias file. Please make sure the file ' sprintf('%s',p1c1name) ' is available.']);
end


while feof(fid)==0

    lin = fgetl(fid);
    
    %======================================================================
    % Getting Receiver type list
    %----------------------------------------------------------------------
    
    % Cross-correlation style receivers (both C1 and P2' are modified)
    if size(lin,2)>=19 && strcmp(lin(1:19),' cc2noncc-type:C1P2')
        
        cond=0;
        while cond==0
            
            lin = fgetl(fid);
            if strcmp(lin(1),'*')
                break
            else
                ncc = ncc +1;
                lrtype.cc{ncc,1}=strtrim(lin);
            end
            
        end % while cond==0
                
    end % if size(lin,2)>=19 &&...
    
    % Non-cross-correlator receivers reporting C1 instead of P1 
    % (only C1 is modified)
    if size(lin,2)>=17 && strcmp(lin(1:17),' cc2noncc-type:C1')
        
        cond=0;
        while cond==0
            
            lin = fgetl(fid);
            if strcmp(lin(1),'*')
                break
            else
                nncc = nncc +1;
                lrtype.ncc{nncc,1}=strtrim(lin);
            end
            
        end % while cond==0
                
    end % if size(lin,2)>=19 &&...
    
    %======================================================================
    
    
    %======================================================================
    % Getting C1-P1 biases
    %----------------------------------------------------------------------
    if size(lin,2)>2 && strcmp(lin(1:2),' h')
        
        ninp = ninp +1;
        y = str2double(lin(4:7));
        m = str2double(lin(9:10));
        d = str2double(lin(12:13));
        dat = y*10000+m*100+d;
        p1c1(ninp,1)=dat;
        for j=1:8
            
            lin = fgetl(fid);
            for i=1:5
                
                ini=19+(i-1)*10;
                fin=ini+7;
                p1c1(ninp,(j-1)*5+i+1) = str2num(lin(ini:fin));
                
            end % for i=1:5
            
        end % for j=1:8
        
    end % if strcmp(lin(1:2),' h')
    %======================================================================
    
end % while foef(fid)==0

p1c1=p1c1(1:ninp,:);