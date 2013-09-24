function autoDP3(obsname,pic,X,Y,Z,cc,it,ft,pos,el,nsd,nrw)

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
else
    tp=0;
end
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
obsname=['c:/phpdev/www/ppp/files/' obsname];

fclose('all');

if strcmp(obsname(end),'o')||strcmp(obsname(end),'O')||strcmp(obsname(end),'d')||strcmp(obsname(end),'D')
    GAPS(itime,ftime,irecc,obsname,fltname,direx,prename1,prename2, ...
        clkname1,clkname2,atxname,sdp,tp,sdt,rwt,p1c1m,cprt,prrt,cllim,cpsd, ...
        prsd,coea,cslmt,jlmt,djlmt,pic);
    namedir=[obsname(end-11:end-4) '_' obsname(end-2:end)];
    newdir=['c:/phpdev/www/ppp_results/' namedir];
    movefile(namedir,newdir);
end
