%Online version of GAPS. This file is used to create the executable used
%for running the online version of GAPS.
function autoDP6(obsname,pic,X,Y,Z,cc,it,ft,pos,el,nsd,nrw,Email,nhzg,nrwhg,ot,bt,blqfile,useAPL)
%autodp6('daej0010.10o','2','0','0','0','0','000000','235959','sta','10','0.01','5','crls.alexgarcia@gmail.com','-1','-1','1','1','none','0')

fclose all
if exist('rodrigo*','file')
    delete rodrigo*
end
itime=str2double(it);
ftime=str2double(ft);

irecc=[str2double(X);str2double(Y);str2double(Z)];
fltname='none';
direx='';
prename1='get';
prename2='get';
clkname1='get';
clkname2='get';
sdp=str2double(cc);
if strcmp(pos,'kin')
    tp=1;
elseif strcmpi(pos,'sta')
    tp=0;
else
    error('Unknown positiong mode. Must select static ("sta") or kinematic ("kin").');
end

sdt=str2double(nsd);
rwt=str2double(nrw);

if nargin < 14
    shzg=-1;
    rwhg=-1;
    ot = 1;
    bt = 1;
    blqfile='none';
else
    ot=str2double(ot);
    bt=str2double(bt);
    shzg=str2double(nhzg);
    rwhg=str2double(nrwhg);
end
if nargin < 18
    blqfile ='none';
end


p1c1m=0;
cprt=0.5;
prrt=5;
cllim=10;
cpsd=0.015;
prsd=2;
coea=str2double(el);
cslmt=0.08;
jlmt=200;
djlmt=2;
atxname='get';
picidx=str2double(pic);
if picidx==1
    pic='emf';
end
if picidx==2
    pic='jpg';
end
if picidx==3
    pic='bmp';
end

p1c1name='get';

obsname=['c:/phpdev/www/ppp/files/' obsname];

iproc = now;

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
[p f e]=fileparts(obsname);
%e-mail message
SUB = 'GAPS data processing results';
MES = [ 10 'GAPS'];
MES = [ MES 10 'GPS Analysis and Positioning Software'];
MES = [ MES 10 'University of New Brunswick' ];
MES = [ MES 10 'GGE - Geodesy and Geomatics Engineering' 10 10];
MES = [ MES 10 'Results report for file ' [f e] ':' 10 10];

pro_ok = 0;
mail='gaps@unb.ca';
password='';
setpref('Internet','E_mail',mail);
setpref('Internet', 'SMTP_Server', 'smtp.unb.ca'); 
setpref('Internet','SMTP_Username',mail);
setpref('Internet','SMTP_Password',password); 
%if strcmp(obsname(end),'o')||strcmp(obsname(end),'O')||strcmp(obsname(end),'d')||strcmp(obsname(end),'D')
try
    dummy = Email(5);
    
    if strcmpi(obsname(end),'Z') & ~strcmpi(obsname(end-1:end),'gz')
        [ p oobsname exten]=fileparts(obsname(1:end-2));
        namedir=[oobsname '_' exten(2:end)];
    elseif strcmpi(obsname(end-1:end),'gz')
        [ p oobsname exten]=fileparts(obsname(1:end-3));
        namedir=[oobsname '_' exten(2:end)];
    else 
        [ p oobsname exten]=fileparts(obsname(1:end));
        namedir=[oobsname '_' exten(2:end)];
    end

    GAPS(itime,ftime,irecc,obsname,fltname,direx,prename1,prename2, ...
        clkname1,clkname2,atxname,p1c1name,sdp,tp,ot,bt,useAPL,sdt,rwt,shzg,rwhg,p1c1m,cprt,prrt,cllim,cpsd, ...
        prsd,coea,cslmt,jlmt,djlmt,pic,useL2C,useL5,blqfile)
    
    fproc=now;

  
    %if size(dir(namedir),1)
        % It means data was successfully processed
        pro_ok = 1;
        strdata=sprintf('%f',datenum(clock));
        newdir=['c:/phpdev/www/ppp_results/' strdata namedir];
        movefile(namedir,newdir);
        MES = [ MES 10 'The file was successfully processed. The summary report can be found at:' 10];
        MES = [ MES 10 'http://gaps.gge.unb.ca/ppp_results/' strdata namedir '/' namedir '.html' 10];
        MES = [ MES 10 'Detailed results can be dowloaded here:' 10];
        MES = [ MES 10 'http://gaps.gge.unb.ca/ppp_results/' strdata namedir '/' namedir '.zip' 10];
        fst=fopen('stats.txt','a');
        fprintf(fst,'%i %i %i %i %i %2.0i   1\n',clock);

    %end        
%end
%if ~pro_ok

catch
    t=lasterror;
    copyfile(obsname,['c:/phpdev/www/' oobsname exten]);
    MES2 = MES;
    MES = [ MES 10 'The file was not successfully processed.' 10];
    copyfile(obsname,['c:/phpdev/www/' oobsname exten]);
    MES2 = [ MES2 10 'The file ' oobsname exten ' (link below) failed to be processed by GAPS v5.1.2' 10];
    MES2 = [ MES2 10 'http://gaps.gge.unb.ca/' oobsname exten 10];
    MES2 = [ MES2 10 'This file was submitted by ' Email 10];
    MES2 = [ MES2 10  t.message 10];
    fst=fopen('stats.txt','a');
    fprintf(fst,'%i %i %i %i %i %i   0\n',clock);
    setpref('Internet', 'SMTP_Server', 'smtp.unb.ca'); 
    sendmail('gaps@unb.ca','GAPS 5.1.2 failed to process a file',MES2) ; 
    %sendmail('lang@unb.ca','GAPS v2.1 failed to process a file',MES2) ; 
        fst=fopen('stats.txt','a');
        fprintf(fst,'%i %i %i %i %i %2.0i   0\n',clock);
        fproc=now;
end

MES = [MES 10 10 'If you have any inquiry please send an e-mail to gaps@unb.ca)'];
sendmail(Email,SUB,MES) ;
sendmail('gaps@unb.ca',SUB,[MES 10 10 'This file was submitted by ' Email 10 10 'This file was processed in ' num2str((fproc-iproc)*86400,'%7.2f') ' seconds.']) ;



