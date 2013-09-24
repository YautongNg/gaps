% Script plots

parPPP=load(fullfile(out,outnamep));
sdvPPP=load(fullfile(out,outnamesd));
resPPP=load(fullfile(out,outnamer));
ionPPP=load(fullfile(out,outname12));
cmpPPP=load(fullfile(out,outnamemp));

%%%PLOTS FOR STATIC%%%
if tp == 0
    if ~isempty(parPPP)
        protime=parPPP(:,4)+parPPP(:,5)./60+parPPP(:,6)./3600;


        figure;
        subplot(3,1,1);
        plot(protime,parPPP(:,11)-parPPP(end,11),'b','LineWidth',2);
        ylabel('Latitude (m)')
        grid on;
        if tp==0
            ylim([-0.5 0.5])
        end
        subplot(3,1,2);
        plot(protime,parPPP(:,12)-parPPP(end,12),'g','LineWidth',2);
        ylabel('Longitude (m)')
        grid on;
        if tp==0
            ylim([-0.5 0.5])
        end
        subplot(3,1,3);
        plot(protime,parPPP(:,13)-parPPP(end,13),'r','LineWidth',2);
        ylabel('Height (m)')
        xlabel('Time (h)')
        grid on;
        if tp==0
            ylim([-0.5 0.5])
        end
        saveas(gcf,[fullfile(out,defname) '1.' picfmt])
        close(gcf)

        figure;
        subplot(3,1,1);
        plot(protime,parPPP(:,11)-parPPP(end,11),'-','LineWidth',2);
        ylabel('Latitude (m)')
        ylim([-0.1 0.1])
        set(gca,'YTick',(-0.1:0.05:0.1));
        grid on;
        subplot(3,1,2);
        plot(protime,parPPP(:,12)-parPPP(end,12),'g','LineWidth',2);
        ylabel('Longitude (m)')
        ylim([-0.1 0.1])
        set(gca,'YTick',(-0.1:0.05:0.1));
        grid on;
        subplot(3,1,3);
        plot(protime,parPPP(:,13)-parPPP(end,13),'r','LineWidth',2);
        ylabel('Height (m)')
        ylim([-0.1 0.1])
        set(gca,'YTick',(-0.1:0.05:0.1));
        xlabel('Time (h)')
        grid on;
        saveas(gcf,[fullfile(out,defname) '2.' picfmt])
        close(gcf)

        figure;
        subplot(3,1,1);
        plot(protime,parPPP(:,14)-parPPP(end,14),'b','LineWidth',2);
        ylabel('X (m)')
        grid on;
        subplot(3,1,2);
        plot(protime,parPPP(:,15)-parPPP(end,15),'g','LineWidth',2);
        ylabel('Y (m)')
        grid on;
        subplot(3,1,3);
        plot(protime,parPPP(:,16)-parPPP(end,16),'r','LineWidth',2);
        ylabel('Z (m)')
        xlabel('Time (h)')
        grid on;
        saveas(gcf,[fullfile(out,defname) '3.' picfmt])
        close(gcf)
    end

    if ~isempty(sdvPPP)
        figure;
        subplot(3,1,1);
        plot(protime(2:end),sdvPPP(2:end,11),'-','LineWidth',2);
        ylabel('X Std. dev. (m)')
        grid on;
        subplot(3,1,2);
        plot(protime(2:end),sdvPPP(2:end,12),'g','LineWidth',2);
        ylabel('Y Std. dev. (m)')
        grid on;
        subplot(3,1,3);
        plot(protime(2:end),sdvPPP(2:end,13),'r','LineWidth',2);
        ylabel('Z Std. dev. (m)')
        xlabel('Time (h)')
        grid on;
        saveas(gcf,[fullfile(out,defname) '4.' picfmt])
        close(gcf)
    end
    
elseif tp==1 %%%PLOTS for KINEMATIC%%%
    
    if ~isempty(parPPP)
        protime=parPPP(:,4)+parPPP(:,5)./60+parPPP(:,6)./3600;

        for j=1:size(parPPP,1);
            llhplot(j,:)=cart2geod(parPPP(j,14:16)');
        end
        
        figure;hold on;plot(rad2deg(llhplot(1,2)),rad2deg(llhplot(1,1)),'.r','Markersize',14)
        plot(rad2deg(llhplot(:,2)),rad2deg(llhplot(:,1)))
        plot(rad2deg(llhplot(end,2)),rad2deg(llhplot(end,1)),'xg','Markersize',14)
        grid on;
        xlabel('Longitude (m)');
        ylabel('Latitude (m)');
        legend('Start','Trajectory','Finish')
        saveas(gcf,[fullfile(out,defname) '1.' picfmt])
        close(gcf)

        figure;
        plot(protime,llhplot(:,3),'r','LineWidth',2);
        ylabel('Height (m)')
        xlabel('Time (h)')
        grid on;
        saveas(gcf,[fullfile(out,defname) '2.' picfmt])
        close(gcf)

        figure;
        subplot(3,1,1);
        plot(protime,parPPP(:,14)-parPPP(end,14),'b','LineWidth',2);
        ylabel('X (m)')
        grid on;
        subplot(3,1,2);
        plot(protime,parPPP(:,15)-parPPP(end,15),'g','LineWidth',2);
        ylabel('Y (m)')
        grid on;
        subplot(3,1,3);
        plot(protime,parPPP(:,16)-parPPP(end,16),'r','LineWidth',2);
        ylabel('Z (m)')
        xlabel('Time (h)')
        grid on;
        saveas(gcf,[fullfile(out,defname) '3.' picfmt])
        close(gcf)
    end

    if ~isempty(sdvPPP)
        figure;
        subplot(3,1,1);
        plot(protime(2:end),sdvPPP(2:end,11),'-','LineWidth',2);
        ylabel('X Std. dev. (m)')
        grid on;
        subplot(3,1,2);
        plot(protime(2:end),sdvPPP(2:end,12),'g','LineWidth',2);
        ylabel('Y Std. dev. (m)')
        grid on;
        subplot(3,1,3);
        plot(protime(2:end),sdvPPP(2:end,13),'r','LineWidth',2);
        ylabel('Z Std. dev. (m)')
        xlabel('Time (h)')
        grid on;
        saveas(gcf,[defname '4.' picfmt])
        close(gcf)
    end
    
    
end

%%%%REMAINING PLOTS%%%%




if ~isempty(parPPP)
    figure;
    subplot(2,1,1);
    plot(protime,parPPP(:,20),'-','LineWidth',2);
    ylabel('NAD (m)')
    grid on;
    subplot(2,1,2);
    plot(protime,sdvPPP(:,14),'r','LineWidth',2);
    ylabel('NAD Std. dev. (m)')
    grid on;
    xlabel('Time (h)')
    saveas(gcf,[fullfile(out,defname) '5.' picfmt])
    close(gcf)
end

if ~isempty(resPPP)
    % Create matrices with residuals for each satellite 
    for prn=1:82
        cpr(:,prn)=resPPP(:,4);
        cpr(resPPP(:,2)~=prn,prn)=nan;
        prr(:,prn)=resPPP(:,3);
        prr(resPPP(:,2)~=prn,prn)=nan;
    end

    figure;
    subplot(2,1,1);
    plot(resPPP(:,1)/3600,cpr,'.','MarkerSize',4);
    ylabel('Carrier-phase residuals (m)')
    grid on;
    subplot(2,1,2);
    plot(resPPP(:,1)/3600,prr,'.','MarkerSize',4);
    ylabel('Pseudorange residuals (m)')
    grid on;
    xlabel('Time (h)')
    saveas(gcf,[fullfile(out,defname) '6.' picfmt])
    close(gcf)
end

if ~isempty(ionPPP) & max(ionPPP(:,7))>=0
    protime=ionPPP(:,4)+ionPPP(:,5)./60+ionPPP(:,6)./3600;
    figure;
    plot(protime,ionPPP(:,7),'-','linewidth',2);
    ylabel('Vertical Ionospheric Delay (m)')
    grid on;
    xlabel('Time (h)')
    ylim([0 max(ionPPP(:,7))+0.2])
    saveas(gcf,[fullfile(out,defname) '7.' picfmt])
    close(gcf)
end

return;

if ~isempty(parPPP)
    % Plots for MP
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
            if listPRN(i)>9
                saveas(gcf,[fullfile(out,defname) 'MP' num2str(listPRN(i)) '.' picfmt])
            else
                saveas(gcf,[fullfile(out,defname) 'MP0' num2str(listPRN(i)) '.' picfmt])
            end            
            close(gcf);
        end
    end
    L1MP=[];
    L2MP=[];
    for k=1:9
        if size(st(k).st,1)>0
            sdev1(k)=std(st(k).st(:,3));
            sdev2(k)=std(st(k).st(:,4));
            L1MP=[L1MP ; st(k).st(:,3)];
            L2MP=[L2MP ; st(k).st(:,4)];
        else
            sdev1(k)=nan;
            sdev2(k)=nan;
        end
    end
    L1MP=std(L1MP);
    L2MP=std(L2MP);
    figure;
    subplot(2,1,1);
    plot(5:10:85,sdev1,'s-','linewidth',2);
    grid on;
    ylabel('L1 code MP noise (m)');
    title(['Overall L1 MP noise: ' num2str(L1MP) ' m']);
    subplot(2,1,2);
    plot(5:10:85,sdev2,'rs-','linewidth',2);
    grid on;
    ylabel('L2 code MP noise (m)');
    title(['Overall L2 MP noise: ' num2str(L2MP) ' m']);
    xlabel('Elevation angle (deg)');
    saveas(gcf,[fullfile(out,defname) 'MP.' picfmt])
    close(gcf);
end
