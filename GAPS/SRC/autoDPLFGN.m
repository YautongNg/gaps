function autoDPLFGN(obsname,tp,el,nsd,nrw)


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
sdt=str2double(nsd);
rwt=str2double(nrw);
p1c1m=0;
cprt=0.20;
prrt=10;
cllim=1;
cpsd=0.02;
prsd=2;
coea=str2double(el);
cslmt=0.08;
jlmt=200;
djlmt=2;
atxname='get';
picidx=1;
if picidx==1
    pic='emf';
end
if picidx==2
    pic='jpg';
end
if picidx==3
    pic='bmp';
end

fclose('all');

    %======================================================================
    % Use L2C for modernized satellites
    % For while, this option forces P2 to be substituted by C2
    % No biases are applied - should be used for research purposes only!!!
    % A very low weight is given for L2C satellite
    %----------------------------------------------------------------------
    %PRN    1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20
    useL2C=[0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0];
    %              21 22 23 24 25 26 27 28 29 30 31
    useL2C=[useL2C  0  0  0  0  0  0  0  0  0  0  0 0 0 0];
    %======================================================================

    %e-mail message
    fprintf(1,'\nGAPS \n');
    fprintf(1,'\nGPS Analysis and Positioning Software\n');
    fprintf(1,'University of New Brunswick - GGE\n');
    fprintf(1,'\nThis license is valid until 2007/09/31\n');
    
    
    
%if strcmp(obsname(end),'o')||strcmp(obsname(end),'O')||strcmp(obsname(end),'d')||strcmp(obsname(end),'D')
try
    
    fprintf(1,'\nChecking license validity...\n');
    ftp_=ftp('cddis.gsfc.nasa.gov');
    cd(ftp_,'/gps/data/daily/2010/200/07d/');
    f = dir(ftp_);
    dummy = f(23);
    close(ftp_);
    fprintf(1,'\nLICENSE NO LONGER VALID!\n');
    fprintf(1,'\nPlease contact Alex Garcia (c.agarcia@unb.ca) \nif you need a free extension.\n\n');
catch
    fprintf(1,'\nLICENSE OK!\n\n');
    GAPSFGN(itime,ftime,irecc,obsname,fltname,direx,prename1,prename2, ...
        clkname1,clkname2,atxname,sdp,tp,sdt,rwt,p1c1m,cprt,prrt,cllim,cpsd, ...
        prsd,coea,cslmt,jlmt,djlmt,pic,useL2C);
end



