listPRN=unique(cmpPPP(:,2));
for k=1:9
    st(k).st=[];
end
for i=2:size(listPRN)
    mp2 = cmpPPP(cmpPPP(:,2)==listPRN(i),:);
    mp2 = mp2(2:end,:);
    if size(mp2,1)>50
        mp=mp2;
        mp(1:5,3)=mp2(1:5,3)-mean(mp2(1:5,3));
        mp(1:5,4)=mp2(1:5,4)-mean(mp2(1:5,4));
        mp(end-4:end,3)=mp2(end-4:end,3)-mean(mp2(end-4:end,3));
        mp(end-4:end,4)=mp2(end-4:end,4)-mean(mp2(end-4:end,4));
        for j=6:size(mp,1)-5
            mp(j,3)=mp2(j,3)-mean(mp2(j-2:j+2,3));
            mp(j,4)=mp2(j,4)-mean(mp2(j-2:j+2,4));
        end        
        for k=1:9
            st(k).st=[st(k).st ; mp(mp(:,5)<10*k & mp(:,5)>10*(k-1),:)];
        end
        figure;
        subplot(3,1,1)
        plot(mp(:,1)/3600,mp(:,3),'-','linewidth',2);
        ylabel('L1 code MP (m)');
        grid on;
        mini = min([min(mp(abs(mp(:,3))<10,3)); min(mp(abs(mp(:,4))<10,4))])-0.1;
        maxi = max([max(mp(abs(mp(:,3))<10,3)); max(mp(abs(mp(:,4))<10,4))])+0.1;
        ylim([mini maxi]);
        title(['PRN ' num2str(listPRN(i)) ' - Std: ' num2str(std(mp(abs(mp(:,3))<10,3))) ' m']);
        subplot(3,1,2)
        plot(mp(:,1)/3600,mp(:,4),'r-','linewidth',2);
        ylabel('L2 code MP (m)');
        grid on;
        ylim([mini maxi]);
        title(['Std: ' num2str(std(mp(abs(mp(:,4))<10,4))) ' m']);
        subplot(3,1,3)
        plot(mp(:,1)/3600,mp(:,5),'g-','linewidth',2);
        ylabel('Elev. angle (deg)');
        grid on;
        xlabel('Time (h)')
        saveas(gcf,['MP' num2str(listPRN(i)) '.emf' ]);
        close(gcf);
    end
end
for k=1:9
    sdev1(k)=std(st(k).st(:,3));
    sdev2(k)=std(st(k).st(:,4));
end
figure;
subplot(2,1,1);
plot(5:10:85,sdev1,'s-','linewidth',2);
grid on;
ylabel('L1 code MP noise (m)');
subplot(2,1,2);
plot(5:10:85,sdev2,'rs-','linewidth',2);
grid on;
ylabel('L2 code MP noise (m)');
xlabel('Elevation angle (deg)');
saveas(gcf,['MP.emf']);
close(gcf);