%Command Line version of GAPS. This file is used to produce the GAPS
%executable which is used for distribution. 
function autoDPTT(obsname,tp,el,nsd,nrw,nhzg,nrwhg,ot,bt,blqfile,pic)
% autoDPTT('nrc10010.11d','0','10','0.10','5','-1','-1','1','1','none','emf')/MATLAB
% autoDPTT (alic0010.10o 0 10 0.10 5 -1 -1 0 1 none emf) / Executable

% data_input = fullfile(pwd(), 'input/');
% obsname = fullfile(data_input, obsname);
%obsname=['c:/phpdev/www/ppp/files/' obsname];
% %obsname='ohi20010.10o';
% obsname=['./input/' obsname]
% path('input')
% data_input = fullfile(pwd(), '/input');
% data_output = fullfile(pwd(), '/output');
% addpath(data_input)
% addpath(data_output)

it=000000;
ft=050000;

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
ot=str2double(ot);
bt=str2double(bt);
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
% picidx=1;
% if picidx==1
%     pic='emf';
% end
% if picidx==2
%     pic='jpg';
% end
% if picidx==3
%     pic='bmp';
% end



shzg=str2double(nhzg);
rwhg=str2double(nrwhg);
if nargin <11
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
    useL2C=zeros(1,120);
    %======================================================================

    %======================================================================
    % Use L1/L5 combination rather then the standard L1/L2
    %----------------------------------------------------------------------
    %LU 2009/12/15
    useL5=zeros(120,1);
    useL5(81:120,1)=ones;
    %======================================================================
    
    %e-mail message
    fprintf(1,'\nGAPS \n');
    fprintf(1,'\nGPS Analysis and Positioning Software 5\n');
    fprintf(1,'University of New Brunswick - GGE\n');
    fprintf(1,'\nThis license is valid until 2011/12/31\n');
    
    
    
%if strcmp(obsname(end),'o')||strcmp(obsname(end),'O')||strcmp(obsname(end),'d')||strcmp(obsname(end),'D')
try
    
    fprintf(1,'\nChecking license validity...\n');
    ftp_=ftp('cddis.gsfc.nasa.gov');
    cd(ftp_,'/gps/data/daily/2011/365/10d/');
    f = dir(ftp_);
    dummy = f(23);
    close(ftp_);
    fprintf(1,'\nLICENSE NO LONGER VALID!\n');
    fprintf(1,'\nPlease contact Alex Garcia (c.agarcia@unb.ca) \nif you need a free extension.\n\n');
catch
    fprintf(1,'\nLICENSE OK!\n\n');
    GAPS(itime,ftime,irecc,obsname,fltname,direx,prename1,prename2, ...
        clkname1,clkname2,atxname,p1c1name,sdp,tp,ot,bt,sdt,rwt,shzg,rwhg,p1c1m,cprt,prrt,cllim,cpsd, ...
        prsd,coea,cslmt,jlmt,djlmt,pic,useL2C,useL5,blqfile)

[frt oobsname exten]=fileparts(obsname);    
namedir=[oobsname '_' exten(2:end) direx];
rmdir(namedir,'s');

end



