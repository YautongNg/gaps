load parPPP.txt
figure;
subplot(3,1,1);
g1=plot((1:size(parPPP,1))*30/3600,parPPP(:,11),'-');
ylabel('Latitude (m)')
grid on;
subplot(3,1,2);
plot((1:size(parPPP,1))*30/3600,parPPP(:,12),'-');
ylabel('Longitude (m)')
grid on;
subplot(3,1,3);
plot((1:size(parPPP,1))*30/3600,parPPP(:,13),'-');
ylabel('Height (m)')
xlabel('Time (h)')
grid on;

figure;
subplot(4,1,1);
plot((1:size(parPPP,1))*30/3600,parPPP(:,11),'-x');
ylabel('Latitude (m)')
grid on;
ylim([-0.5 0.5]);
set(gca,'YTick',[-0.5:0.25:0.5]);
subplot(4,1,2);
plot((1:size(parPPP,1))*30/3600,parPPP(:,12),'-x');
ylabel('Longitude (m)')
grid on;
ylim([-0.5 0.5]);
set(gca,'YTick',[-0.5:0.25:0.5]);
subplot(4,1,3);
plot((1:size(parPPP,1))*30/3600,parPPP(:,13),'-x');
ylabel('Height (m)')
grid on;
ylim([-0.75 0.75]);
set(gca,'YTick',[-0.5:0.25:0.5]);
subplot(4,1,4);
plot((1:size(parPPP,1))*30/3600,parPPP(:,end),'-x');
ylabel('Clock Offset (m)')
xlabel('Time (h)')
grid on;