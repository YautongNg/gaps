function compute_initial_coords(gtobs,hobs)
epoch_count=0;
obs=[];
for i=1:5
    [obs_epoch staifo cdate gtcount]=getobs2(gtobs,hobs,epoch_count);
    obs=[obs;obs_epoch];
end
% There are 5 epochs of data in ofile1
for q = 1:20
    [time1, dt1, sats1, eof1] = fepoch_0(fid1);
    NoSv1 = size(sats1,1);
    % We pick the observed P2 pseudoranges
    obs1 = grabdata(fid1, NoSv1, NoObs_types1);
    i = fobs_typ(Obs_types1,'P2');
    pos = recpo_ls(obs1(:,i),sats1,time1,Eph);
    Pos = [Pos pos];
end
me = mean(Pos,2);
fprintf('\nMean Position as Computed From 20 Epochs:')
fprintf('\n\nX: %12.3f  Y: %12.3f  Z: %12.3f', me(1,1), me(2,1), me(3,1))
plot((Pos(1:3,:)-Pos(1:3,1)*ones(1,q))','linewidth',2)
title('Positions Over Time','fontsize',16)
legend('X','Y','Z')
xlabel('Epochs [1 s interval]','fontsize',16)
ylabel('Variation in Coordinates, Relative to the First Epoch [m]','fontsize',16)
set(gca,'fontsize',16)
legend