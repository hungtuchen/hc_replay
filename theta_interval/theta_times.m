function [intervals] = theta_times(cfg, csc)
%purpose: get theta cycle times
%Inputs: configurations(cfg) and lfp data(csc)from MVDM
%Outputs: time intervals between peaks
​
%% output
intervals = [];
​
%% load necessary info
lfp = LoadCSC(cfg);
pos = LoadPos([]);
LoadExpKeys;
​
%% filter LFP to get theta band
lfp_tsd = FilterLFP(cfg,lfp);
​
​
%% restrict to times when rat is running
​
pos = restrict(pos,ExpKeys.TimeOnTrack,ExpKeys.TimeOffTrack);%position
spd = getLinSpd([],pos); % get speed (in "camera pixels per second")
​
cfg_spd = []; cfg_spd.method = 'raw'; cfg_spd.threshold = 10; %config speed
run_iv = TSDtoIV(cfg_spd,spd); % running intervals with speed above 10 pix/s
​
%restrict theta to run_iv
lfp_tsd = restrict(lfp_tsd,run_iv.tstart,run_iv.tend);
​
%% get power of signal, to do in future
% lfp_tsd = LFPpower([],lfp_tsd); %envelope is default?
% lfp_tsd_zpwr = zscore_tsd(lfp_tsd);%z score
% %% Threshold LFP, include data with larger than threshold power
% % 
% cfg = [];
% cfg.method = 'raw'; % first normalize the data
% cfg.threshold = 0;%3?
% cfg.dcn = '>'; % detect intervals with z-score lower than threshold
​
%% get times of peaks
​
[peaks,locs] = findpeaks(lfp_tsd.data);
peak_times = lfp_tsd.tvec(locs);%finds peak tsd
peak_iv = diff(peak_times);
​
​
%% create peak intervals
​
tstart = peak_iv(1:end-1);
tstop = nan(length(peak_iv),1);
​
for i = 1:length(peak_iv)-1;
    tstop(i)= peak_iv(i+1);
end
tstop = tstop(1:end-1);
​
%package
intervals.tstart = tstart;
intervals.tstop = tstop;