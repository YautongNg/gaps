figure;
subplot(3,1,1);plot((1:size(dt,1))*30/3600,dt(:,1));grid on;
ylabel('Latitude (m)');
ylim([-.6 .6])
set(gca,'YTick',(-.6:0.2:.6));
subplot(3,1,2);plot((1:size(dt,1))*30/3600,dt(:,2),'g');grid on;
ylabel('Longitude (m)');
ylim([-.6 .6])
set(gca,'YTick',(-.6:0.2:.6));
subplot(3,1,3);plot((1:size(dt,1))*30/3600,dt(:,3),'r');grid on;
ylabel('Height (m)');
ylim([-1 1])
set(gca,'YTick',(-1:0.5:1));
xlabel('Time (h)');