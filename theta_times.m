
function theta_times = theta_times(cfg,csc,run_iv);

%get theta cycle times
lfp = LoadCSC(cfg);

%% filter LFP to get theta band
lfp_tsd = FilterLFP(cfg,lfp);

%visual check
figure;
title('All behavior');
plot(csc.tvec,csc.data,'b');
hold on;
plot(lfp_tsd.tvec,lfp_tsd.data,'r');
%xlim([3529 3539]); %zoom in
legend('Unfiltered','Theta');

%% restrict to times when rat is running, move one above- not sure if this is correct
lfp_tsd = restrict(lfp_tsd,run_iv.tstart,run_iv.tend);
csc = restrict(csc,run_iv.tstart,run_iv.tend);

%visual check
figure;
title('Running');
plot(csc.tvec,csc.data,'b');
hold on;
plot(lfp_tsd.tvec,lfp_tsd.data,'r');
%xlim([3529 3539]); %zoom in
legend('Unfiltered','Theta');
%% get power of signal
lfp_tsd_pwr = LFPpower([],lfp_tsd);
lfp_tsd_zpwr = zscore_tsd(lfp_tsd_pwr);%z score


%% Threshold LFP, include data with larger than threshold power
[iv_out,thr_out] = TSDtoIV(csc,lfp_tsd_zpwr);% is 5 an appropriate threshold?

%% Get theta cycle times, its weird that it's only 73 instances?
theta_times = AddTSDtoIV(csc,iv_out,lfp_tsd_zpwr);% lines 15,16,63

%visual check
figure;
PlotTSDfromIV([],theta_times,lfp_tsd);
%xlim([3529 3539]); %zoom in
legend('filtered lfp','theta times');
%[theta_times,idx] = SelectIV(csc,theta_times,'max');needs work

end
