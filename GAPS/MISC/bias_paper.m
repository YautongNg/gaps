files=dir('*.res');
r=[];
mr=[];
melr=[];
for i=1:size(files,1)
    mr1=[];
    melr1=[];
    r1=load(files(i).name);
    r=[r;r1];
    for sat=1:40
        r2=r1(r1(:,2)==sat&r1(:,1)>12*3600,:);
        for i=1:size(r2,1)
            r2(i,6)=sin(r2(i,5)*pi/180);
        end
        if size(r2,1)>0
            m(sat,1)=(sum(r2(:,3).*r2(:,6))/sum(r2(:,6)));
            res=r2(:,3)-m(sat,1);
            r2=r2(abs(res(:,1))<3,:);
            mr1(sat,1)=(sum(r2(:,3).*r2(:,6))/sum(r2(:,6)));
            melr1(sat,1)=mean(r2(:,5));
        else
            mr1(sat,1)=nan;
            melr1(sat,1)=nan;
        end
    end
    mr=[mr mr1];
    melr=[melr melr1];
end
for i=1:size(r,1)
    r(i,6)=sin(r(i,5)*pi/180);
end
c=loadcst;
for sat=1:40
    r1=r(r(:,2)==sat&r(:,1)>12*3600,:);
    if size(r1,1)>0
        m(sat,1)=(sum(r1(:,3).*r1(:,6))/sum(r1(:,6)));
        res=r1(:,3)-m(sat,1);
        r1=r1(abs(res(:,1))<3,:);
        m(sat,1)=(sum(r1(:,3).*r1(:,6))/sum(r1(:,6)));
        mel(sat,1)=mean(r1(:,5));
    else
        m(sat,1)=nan;
        mel(sat,1)=nan;
    end
end
m=m/c.if1*1e9/c.c;


 bias=[ -0.311d0 -0.004d0 -0.347d0  1.192d0 -1.002d0 ...
         0.306d0 -1.266d0 -0.497d0  0.151d0 -1.821d0 ...
         0.622d0 -9.999d9  1.560d0  0.147d0 -1.503d0 ...
        -0.611d0  1.425d0 -0.341d0 -1.974d0 -1.303d0 ...
        -0.347d0  0.566d0  0.298d0 -0.191d0  0.504d0 ...
         0.992d0 -0.328d0 -0.202d0  0.561d0  1.960d0 ...
         1.762d0 -9.999d9 -9.999d9 -9.999d9 -9.999d9 ...
        -9.999d9 -9.999d9 -9.999d9 -9.999d9 -9.999d9]';

bias=[bias m bias-m]*1e-9*c.c;
bias=[bias mel];
