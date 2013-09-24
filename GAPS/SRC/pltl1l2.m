an=load('nrc10910_06O.l12');
au=load('unb10910_06O.l12');
af=load('frdn0910_06O.l12');
ah=load('hlfx0910_06O.l12');
ak=load('kngs0910_06O.l12');


sa=10;
a1n=an(an(:,7)==sa,:);
for i=1:size(a1n,1)
a1n(i,8)=a1n(i,8)-round(a1n(i,8));
end
figure;plot(a1n(:,4)+a1n(:,5)/60+a1n(:,6)/3600,a1n(:,8),'r+')

a1h=ah(ah(:,7)==sa,:);
for i=1:size(a1h,1)
a1h(i,8)=a1h(i,8)-round(a1h(i,8));
end
hold on;plot(a1h(:,4)+a1h(:,5)/60+a1h(:,6)/3600,a1h(:,8),'+')

a1u=au(au(:,7)==sa,:);
for i=1:size(a1u,1)
a1u(i,8)=a1u(i,8)-round(a1u(i,8));
end
hold on;plot(a1u(:,4)+a1u(:,5)/60+a1u(:,6)/3600,a1u(:,8),'g+')

a1f=af(af(:,7)==sa,:);
for i=1:size(a1f,1)
a1f(i,8)=a1f(i,8)-round(a1f(i,8));
end
hold on;plot(a1f(:,4)+a1f(:,5)/60+a1f(:,6)/3600,a1f(:,8),'m+')

a1k=ak(ak(:,7)==sa,:);
for i=1:size(a1k,1)
a1k(i,8)=a1k(i,8)-round(a1k(i,8));
end
hold on;plot(a1k(:,4)+a1k(:,5)/60+a1k(:,6)/3600,a1k(:,8),'k+')


grid on;

sa=10;
a1n=an(an(:,7)==sa,:);
for i=1:size(a1n,1)
a1n(i,8)=gphase(a1n(i,8));
end
figure;plot(a1n(:,4)+a1n(:,5)/60+a1n(:,6)/3600,a1n(:,8),'r+')

a1h=ah(ah(:,7)==sa,:);
for i=1:size(a1h,1)
a1h(i,8)=gphase(a1h(i,8));
end
hold on;plot(a1h(:,4)+a1h(:,5)/60+a1h(:,6)/3600,a1h(:,8),'+')

a1u=au(au(:,7)==sa,:);
for i=1:size(a1u,1)
a1u(i,8)=gphase(a1u(i,8));
end
hold on;plot(a1u(:,4)+a1u(:,5)/60+a1u(:,6)/3600,a1u(:,8),'g+')

a1f=af(af(:,7)==sa,:);
for i=1:size(a1f,1)
a1f(i,8)=gphase(a1f(i,8));
end
hold on;plot(a1f(:,4)+a1f(:,5)/60+a1f(:,6)/3600,a1f(:,8),'m+')

a1k=ak(ak(:,7)==sa,:);
for i=1:size(a1k,1)
a1k(i,8)=gphase(a1k(i,8));
end
hold on;plot(a1k(:,4)+a1k(:,5)/60+a1k(:,6)/3600,a1k(:,8),'k+')

grid on;

a1n=an(an(:,7)==sa,:);
for i=1:size(a1n,1)
a1n(i,9)=gphase(a1n(i,9));
end
figure;plot(a1n(:,4)+a1n(:,5)/60+a1n(:,6)/3600,a1n(:,9),'r+')

a1h=ah(ah(:,7)==sa,:);
for i=1:size(a1h,1)
a1h(i,9)=gphase(a1h(i,9));
end
hold on;plot(a1h(:,4)+a1h(:,5)/60+a1h(:,6)/3600,a1h(:,9),'+')

a1u=au(au(:,7)==sa,:);
for i=1:size(a1u,1)
a1u(i,9)=gphase(a1u(i,9));
end
hold on;plot(a1u(:,4)+a1u(:,5)/60+a1u(:,6)/3600,a1u(:,9),'g+')

a1f=af(af(:,7)==sa,:);
for i=1:size(a1f,1)
a1f(i,9)=gphase(a1f(i,9));
end
hold on;plot(a1f(:,4)+a1f(:,5)/60+a1f(:,6)/3600,a1f(:,9),'m+')

a1k=ak(ak(:,7)==sa,:);
for i=1:size(a1k,1)
a1k(i,9)=gphase(a1k(i,9));
end
hold on;plot(a1k(:,4)+a1k(:,5)/60+a1k(:,6)/3600,a1k(:,9),'k+')

grid on;