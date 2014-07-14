% generate timetag vectors

g{1}='bran3000_03d.l12';
g{2}='bran3010_03d.l12';
g{3}='bran3020_03d.l12';
g{4}='bran3030_03d.l12';
g{5}='bran3040_03d.l12';

igs{1}='jplg3000.03i';
igs{2}='jplg3010.03i';
igs{3}='jplg3020.03i';
igs{4}='jplg3030.03i';
igs{5}='jplg3040.03i';

res=[];

for ifile=1:5
    itime=[0:600:85800]';
    fprintf(1,'file %i\n',ifile);
    u=load(g{ifile});
    ionex=readionex(igs{ifile});
    u(:,1)=u(:,4)*3600+u(:,5)*60+u(:,6);
    for i=1:size(itime,1)
        u1=u(u(:,1)==itime(i,1),:);
        if size(u1,1)>0
            ion=getionexval(ionex,u1(1,1),34.18,-118.28);
            res=[res ; (ifile-1)*86400+u1(1,1) ion' [u1(1,7) u1(1,end)]/0.162372447511995];
        end
    end
end

plot(res(:,1)/86400,res(:,2),'r.');
hold on
plot(res(:,1)/86400,res(:,4),'.');
grid on;
ylabel('Ionospheric delay (TECU)');
xlabel('Time (days)');
