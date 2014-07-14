    if ~isnan(nibias)
        if cx0(prn+5,prn+5)>0.000000001
            % Compute fractional biases
            bv=nibias(nibias(:,2)==prn ...
                & abs(nibias(:,1)-sod/60)==min(abs(nibias(:,1)-sod/60)),:);
            if size(bv,1)>0
                b1=bv(1,3);
                s1=bv(1,4);
                b2=bv(1,5);
                s2=bv(1,6);
                % Apply biases to ambiguities
                amb1p=d(1,1)-b1;
                amb2p=d(2,1)-b2;
                % Check if ambiguities can be considered integers
                cx=cx12{prn};
                std1=sqrt((cx(1,1)/(cst.l1^2))+s1^2);
                std2=sqrt((cx(2,2)/(cst.l2^2))+s2^2);
                % L1/L2
                low1=floor(amb1p);
                upp1=floor(amb1p)+1;
                low2=floor(amb2p);
                upp2=floor(amb2p)+1;
                if abs(amb1p-low1)>3*std1 || abs(amb1p-upp1)>3*std1
                    if abs(amb2p-low2)>3*std2 || abs(amb2p-upp2)>3*std2
                        amb1=round(amb1p)+b1;
                        amb2=round(amb2p)+b2;
                        amb(prn)=cst.if1*cst.l1*amb1-cst.if2*cst.l2*amb2;
                        cx0(prn+5,:)=0;
                        cx0(:,prn+5)=0;
                        cx0(prn+5,prn+5)=0.000000001;
                    end
                end
            end
        end
    end
