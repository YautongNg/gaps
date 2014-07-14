% generate timetag vectors
clear;


sta='UNB1';
latitude=45.95;
longitude=-66.64;

sta='RIOG';
latitude=-53.78;
longitude=-67.75;

sta='LEEP';
latitude=34.18;
longitude=-118.27;

sta='BRAN';
latitude=34.18;
longitude=-118.27;

sta='MANA';
latitude=12.15;
longitude=-86.25;

sta='FRDN';
latitude=45.95;
longitude=-66.64;


g{1}=[ sta '3120_04o.l12'];
g{2}=[ sta '3130_04o.l12'];
g{3}=[ sta '3140_04o.l12'];
g{4}=[ sta '3150_04o.l12'];
g{5}=[ sta '3160_04o.l12'];

r{1}=[ sta '3120_04o.rio'];
r{2}=[ sta '3130_04o.rio'];
r{3}=[ sta '3140_04o.rio'];
r{4}=[ sta '3150_04o.rio'];
r{5}=[ sta '3160_04o.rio'];

igs{1}='igsg3120.04i';
igs{2}='igsg3130.04i';
igs{3}='igsg3140.04i';
igs{4}='igsg3150.04i';
igs{5}='igsg3160.04i';

res=[];
re=[];

for ifile=1:5
    itime=[0:600:85800]';
    fprintf(1,'file %i\n',ifile);
    u=load(g{ifile});
    ra=load(r{ifile});
    ionex=readionex(igs{ifile});
    u(:,1)=u(:,4)*3600+u(:,5)*60+u(:,6);
    ra(:,1)=ones(size(ra,1),1)*(ifile-1)*86400+ra(:,4)*3600+ra(:,5)*60+ra(:,6);
    re=[re;ra(:,1:9)];
    for i=1:size(itime,1)
        u1=u(u(:,1)==itime(i,1),:);
        if size(u1,1)>0
            ion=getionexval(ionex,u1(1,1),latitude,longitude);
            if u1(1,7)<0
              u1(1,7)=0;
            end
            res=[res ; (ifile-1)*86400+u1(1,1) ion' [u1(1,7) u1(1,end)]/0.162372447511995];
        end
    end
    table1(ifile,1)=mean(res(res(:,1)>(ifile-1)*86400+300,4)-res(res(:,1)>(ifile-1)*86400+300,2));
    table1(ifile,2)=std(res(res(:,1)>(ifile-1)*86400+300,4)-res(res(:,1)>(ifile-1)*86400+300,2));
    table1(ifile,3)=norm(res(res(:,1)>(ifile-1)*86400+300,4)-res(res(:,1)>(ifile-1)*86400+300,2))/sqrt(size(res(res(:,1)>(ifile-1)*86400+300,1),1)-20);
    table2(ifile,1)=mean(ra(:,9));
    table2(ifile,2)=std(ra(:,9));
    table2(ifile,3)=norm(ra(:,9))/sqrt(size(ra,1));
    table3(ifile,1)=mean(ra(:,9).*sin(ra(:,8)));
    table3(ifile,2)=std(ra(:,9).*sin(ra(:,8)));
    table3(ifile,3)=norm(ra(:,9).*sin(ra(:,8)))/sqrt(size(ra,1));
end

table1(6,1)=mean(res(:,4)-res(:,2));
table1(6,2)=std(res(:,4)-res(:,2));
table1(6,3)=norm(res(:,4)-res(:,2))/sqrt(size(res,1))
table2(6,1)=mean(re(:,9));
table2(6,2)=std(re(:,9));
table2(6,3)=norm(re(:,9))/sqrt(size(re,1));
table2=table2/0.162372447511995
table3(6,1)=mean(re(:,9).*sin(re(:,8)));
table3(6,2)=std(re(:,9).*sin(re(:,8)));
table3(6,3)=norm(re(:,9).*sin(re(:,8)))/sqrt(size(re,1));
table3=table3/0.162372447511995
tabname=[sta '2004'];
save(tabname);

figure;
plot(res(:,1)/86400+312,res(:,2),'r','linewidth',2);
hold on
plot(res(:,1)/86400+312,res(:,4),'.');
grid on;
ylabel('Ionospheric delay (TECU)');
xlabel('DOY (2004)');
title(['Station ' sta ' - 2004 DOY 312 to 316']);
figname=['withIGS_' sta '2004'];
saveas(gcf,[figname '.emf']);
saveas(gcf,[figname '.fig']);
close(gcf)


figure;
subplot(3,1,1);
plot(res(:,1)/86400+312,res(:,4),'.');
grid on;
ylabel('Ionospheric delay (TECU)');
%ylim([0 30]);
xlabel('DOY (2004)');
title(['Station ' sta ' - 2004 DOY 312 to 316']);
subplot(3,1,2);
scatter(re(:,1)/86400+312,re(:,9)/0.162372447511995,10,re(:,7));
grid on;
ylabel('Slant Residuals (TECU)');
xlabel('DOY (2004)');
subplot(3,1,3);
scatter(re(:,1)/86400+312,re(:,9)/0.162372447511995.*sin(re(:,8)),10,re(:,7));
grid on;
ylabel('Vertical Residuals (TECU)');
%ylim([-4 4])
xlabel('DOY (2004)');
figname=['residuals_' sta '2004'];
saveas(gcf,[figname '.emf']);
saveas(gcf,[figname '.fig']);
close(gcf)

% Histograms
for iday=1:5
    h=re(re(:,1)>=(iday-1)*86400&re(:,1)<=iday*86400,:);
    figure;
    hist(h(:,9)/0.162372447511995,30);
    tit=['Station ' sta ' - 2004 DOY ' num2str(311+iday)];
    title(tit);
    xlabel('Slant residuals (TECU)');
    ylabel('Occurrences');
    figname=['histslant_' sta '2004' num2str(iday)];
    saveas(gcf,[figname '.emf']);
    saveas(gcf,[figname '.fig']);
    close(gcf)
    figure;
    hist(h(:,9)/0.162372447511995.*sin(h(:,8)),30);
    tit=['Station ' sta ' - 2004 DOY ' num2str(311+iday)];
    title(tit);
    xlabel('Vertical residuals (TECU)');
    ylabel('Occurrences');
    figname=['histvert_' sta '2004' num2str(iday)];
    saveas(gcf,[figname '.emf']);
    saveas(gcf,[figname '.fig']);
    close(gcf)
end
figure;
hist(re(:,9)/0.162372447511995,30);
tit=['Station ' sta ' - 2004 DOY 312 to 316'];
title(tit);
xlabel('Slant residuals (TECU)');
ylabel('Occurrences');
figname=['histslant_' sta '2004'];
saveas(gcf,[figname '.emf']);
saveas(gcf,[figname '.fig']);
close(gcf)
figure;
hist(re(:,9)/0.162372447511995.*sin(re(:,8)),30);
tit=['Station ' sta ' - 2004 DOY 312 to 316'];
title(tit);
xlabel('Vertical residuals (TECU)');
ylabel('Occurrences');
figname=['histvert_' sta '2004'];
saveas(gcf,[figname '.emf']);
saveas(gcf,[figname '.fig']);
close(gcf)

% % Chi-squared test
% nd=load('normdist.txt');
% for iday=1:5
%     h=re(re(:,1)>=(iday-1)*86400&re(:,1)<=iday*86400,9);
%     ma=max(h);
%     mi=min(h);
%     bin_size=(ma-mi)/300;
%     for ibin=1:300
%         ilim=mi+((ibin-1)*bin_size);
%         nilim=(ilim-mean(h))/std(h);
%         slim=mi+((ibin)*bin_size);
%         nslim=(slim-mean(h))/std(h);
%         pi=nd(abs(nd(:,1)-nilim)==min(abs(nd(:,1)-nilim)),2);
%         ps=nd(abs(nd(:,1)-nslim)==min(abs(nd(:,1)-nslim)),2);
%         pbin=ps-pi;
%         npbin=pbin;
%         nbin=size(h(h(:,1)>=ilim&h(:,1)<slim,1),1)/size(h,1);
%         if nbin>5&npbin>5
%             y(ibin,1)=(nbin-npbin)^2/npbin;
%         else
%             y(ibin,1)=0;
%         end
%     end
%     ys(iday,1)=sum(y);
% end
% ys

    
    


