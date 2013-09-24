% Script PROBIAS
%%
% Process L1/L2 biases

% Open output file
fo=fopen('can0910.sb1','w');

% Check *.l12 files and load them
d12=dir('*.l12');
b=[]
for idx=1:size(d12,1)
    bl=load(d12(idx).name);
    b=[b;bl];
end

% Generate one set of biases for each 15 min
for t=0:30*60:24*3600-30*60
    
    % Generate one bias for each prn
    for prn=1:31
        % Selecting ambiguity observations
        bo=b(b(:,4)*3600+b(:,5)*60+b(:,6)>=t ...
            & b(:,4)*3600+b(:,5)*60+b(:,6)<=t+30*60 ...
            & b(:,7)==prn,:);
        % At least three stations
        if size(bo,1)>90
            ssin1=sum(sin(2*pi*bo(:,8)));
            scos1=sum(cos(2*pi*bo(:,8)));
            ssin2=sum(sin(2*pi*bo(:,9)));
            scos2=sum(cos(2*pi*bo(:,9)));
            b1=atan2(ssin1,scos1)/(2*pi);
            b2=atan2(ssin2,scos2)/(2*pi);
            s1=std(bo(:,8)-round(bo(:,8)));
            s2=std(bo(:,9)-round(bo(:,9)));
            R1=(sqrt(ssin1^2+scos1^2)/size(bo,1))/(2*pi);
            R2=(sqrt(ssin2^2+scos2^2)/size(bo,1))/(2*pi);
            fprintf(fo,'%8i%5i%9.5f%9.5f%9.5f%9.5f\n',(t+15*60)/60,prn,b1,s1,b2,s2);
        end
    end
end
fclose(fo);
