figure;
hold on;
plot3([0;10000000],[0;0],[0;0],'k');
plot3([0;0],[0;10000000],[0;0],'k');
plot3([0;0],[0;0],[0;10000000],'k');
for lat=-80:10:80
    lcc=[];
    for lon=-180:10:180
        cg=[lat*pi/180;lon*pi/180;0];
        cc=geod2cart(cg);
        lcc=[lcc;cc'];
    end
    plot3(lcc(:,1),lcc(:,2),lcc(:,3));
end

for lon=-180:10:180
    lcc=[];
    for lat=-90:10:90
        cg=[lat*pi/180;lon*pi/180;0];
        cc=geod2cart(cg);
        lcc=[lcc;cc'];
    end
    plot3(lcc(:,1),lcc(:,2),lcc(:,3),'r');
end
        