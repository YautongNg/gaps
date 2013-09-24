function autoDPA1 (obsname,tp,el,nsd,nrw,nhzg,nrwhg,ot,bt,blqfile,pic)
%(obsname,tp,el,nsd,nrw,nhzg,nrwhg,pic)

data_input = fullfile(pwd(), 'INPUT');
obsname = fullfile(data_input, obsname);


it=000000;
ft=240000;
itime=it;
ftime=ft;
irecc=[0;0;0];
fltname='none';
direx='';
prename1='get';
prename2='get';
clkname1='get';
clkname2='get';
sdp=0;
tp=str2double(tp);
sdt=str2double(nsd);
rwt=str2double(nrw);
p1c1m=0;
cprt=1;
prrt=10;
cllim=1;
cpsd=0.015;
prsd=2;
coea=str2double(el);
cslmt=0.08;
jlmt=200;
djlmt=2;
atxname='get';
p1c1name='get';

if nargin < 7
    shzg=-1;
    rwhg=-1;
else
    shzg=str2double(nhzg);
    rwhg=str2double(nrwhg);
end
if nargin <8
    pic = 'emf';
end

fclose('all');

    %======================================================================
    % Use L2C for modernized satellites
    % For while, this option forces P2 to be substituted by C2
    % No biases are applied - should be used for research purposes only!!!
    % A very low weight is given for L2C satellite
    %----------------------------------------------------------------------
    %LU 2009/12/15
    %PRN    1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20
    useL2C=[0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0];
    %              21 22 23 24 25 26 27 28 29 30 31
    useL2C=[useL2C  0  0  0  0  0  0  0  0  0  0  0 0 0 0 ];
    %======================================================================
%     %PRN    1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20
%     useL2C=[0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0];
%     %              21 22 23 24 25 26 27 28 29 30 31
%     useL2C=[useL2C  0  0  0  0  0  0  0  0  0  0  0 0 0 0 ];
         
    
    %======================================================================
    % Use L1/L5 combination rather then the standard L1/L2
    %----------------------------------------------------------------------
    %LU 2009/12/15
    useL5=zeros(120,1);
    useL5(81:120,1)=ones;
    %======================================================================
    
    %e-mail message
    fprintf(1,'\nGAPS \n');
    fprintf(1,'\nGPS Analysis and Positioning Software v4.1.2\n');
    fprintf(1,'University of New Brunswick - GGE\n');
    fprintf(1,'\nThis license is valid until 01/25/2011\n');
    
    
    
%if strcmp(obsname(end),'o')||strcmp(obsname(end),'O')||strcmp(obsname(end),'d')||strcmp(obsname(end),'D')
try
    
    fprintf(1,'\nChecking license validity...\n');
    ftp_=ftp('cddis.gsfc.nasa.gov');
    cd(ftp_,'/gps/data/daily/2011/025/10d/');
    f = dir(ftp_);
    dummy = f(23);
    close(ftp_);
    fprintf(1,'\nLICENSE NO LONGER VALID!\n');
    fprintf(1,'\nPlease contact Alex Garcia (agarcia@unb.ca) \nif you need a free extension.\n\n');
    
catch
  
    fprintf(1,'\nLICENSE OK!\n\n');
    warning('off','MATLAB:dispatcher:InexactCaseMatch')
    GAPS(itime,ftime,irecc,obsname,fltname,direx,prename1,prename2, ...
        clkname1,clkname2,atxname,p1c1name,sdp,tp,ot,bt,sdt,rwt,shzg,rwhg,p1c1m,cprt,prrt,cllim,cpsd, ...
        prsd,coea,cslmt,jlmt,djlmt,pic,useL2C,useL5,blqfile);

    
%         data_output = fullfile(pwd(), 'OUTPUT');
%         movefile('*.zip',data_output);
        delete('*.par','*.rio','*.cmp','*.par','*.l12','*.gif','*.html',...
               '*.ppp','*.emf')               
end



