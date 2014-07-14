% generate timetag vectors

g{1}='unbj0010_07o.l12';
g{2}='unbj0020_07o.l12';
g{3}='unbj0030_07o.l12';
g{4}='unbj0040_07o.l12';
g{5}='unbj0050_07o.l12';

igs{1}='igsg0010.07i';
igs{2}='igsg0020.07i';
igs{3}='igsg0030.07i';
igs{4}='igsg0040.07i';
igs{5}='igsg0050.07i';

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
            ion=getionexval(ionex,u1(1,1),12.1,-86.2);
            res=[res ; (ifile-1)*86400+u1(1,1) ion' [u1(1,7) u1(1,end)]/0.162372447511995];
        end
    end
end

figure;
plot(res(:,1)/86400,res(:,2),'r');
hold on
plot(res(:,1)/86400,res(:,4),'.');
grid on;
ylabel('Ionospheric delay (TECU)');
xlabel('Time (days)');



