for prn=1:31
n1=n(n(:,2)==prn,:);
m1=m(m(:,2)==prn,:);
o1=o(o(:,2)==prn,:);
figure
subplot(2,1,1)
plot(m1(:,1)/86400*24,m1(:,3),'r')
hold on
plot(o1(:,1)/86400*24,o1(:,3))
plot(n1(:,1)/86400*24,n1(:,3),'g')
grid on
title(num2str(prn))
subplot(2,1,2)
plot(n1(:,1)/86400*24,n1(:,5))
grid on
end

n1=n(n(:,2)==0,:);
m1=m(m(:,2)==0,:);
o1=o(o(:,2)==0,:);
figure
plot(m1(:,1)/86400*24,m1(:,3),'r')
hold on
plot(o1(:,1)/86400*24,o1(:,3))
plot(n1(:,1)/86400*24,n1(:,3),'g')
title(num2str(prn))
grid on
