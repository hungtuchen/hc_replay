%% setup paths

data_folder = 'R064-2015-04-22';
% https://rcweb.dartmouth.edu/~mvdm/wiki/doku.php?id=analysis:nsb2017:week1
restoredefaultpath; % start with a clean slate
% assuming you are inside the repo root
path_shared = fullfile(pwd, 'shared'); % or, wherever your code is located -- NOTE \shared subfolder!
path_data = fullfile(pwd, 'data');
p = genpath(path_shared); % create list of all folders from here
addpath(p);
cd(fullfile(path_data, data_folder)); % replace this with where you saved the data
%% find data folders
%fd_cfg = []; fd_cfg.requireCandidates = 0; % don't need previously saved sharp wave-ripple (SWR) candidates here
%fd = getTmazeDataPath(fd_cfg);

%cd(fd{end});

%% load data (alternative: FileLoader{'spikes','pos','ExpKeys','Metadata')), see lab wiki for loader info at:
% http://ctnsrv.uwaterloo.ca/vandermeerlab/doku.php?id=analysis:nsb2015:week2
% load all spikes
S = LoadSpikes([]);
pos = LoadPos([]); % note, this is raw position data read from the .nvt file, units are "camera pixels"
LoadExpKeys; % see https://github.com/mvdm/vandermeerlab/blob/master/doc/HOWTO_ExpKeys_Metadata.md
LoadMetadata;
%% some statistics
num_neurons = length(S.t);
num_spikes_per_neuron = cellfun(@length, S.t)';
mean(num_spikes_per_neuron)
std(num_spikes_per_neuron)

bar(1:num_neurons,num_spikes_per_neuron)



%% set up data structs for 2 experimental conditions -- see lab wiki for this task at:
% http://ctnsrv.uwaterloo.ca/vandermeerlab/doku.php?id=analysis:task:motivationalt
clear expCond;

expCond(1).label = 'left'; % this is a T-maze, we are interested in 'left' and 'right' trials
expCond(2).label = 'right'; % these are just labels we can make up here to keep track of which condition means what

expCond(1).t = metadata.taskvars.trial_iv_L; % previously stored trial start and end times for left trials
expCond(2).t = metadata.taskvars.trial_iv_R; 

expCond(1).coord = metadata.coord.coordL; % previously user input idealized linear track
expCond(2).coord = metadata.coord.coordR; % note, this is in units of "camera pixels", not cm

expCond(1).S = S;
expCond(2).S = S;

%% linearize paths (snap x,y position samples to nearest point on experimenter-drawn idealized track)
nCond = length(expCond);
for iCond = 1:nCond
    cfg_linpos = [];
    cfg_linpos.Coord = expCond(iCond).coord;
    expCond(iCond).linpos = LinearizePos(cfg_linpos,pos);
end

%% find intervals where rat is running
spd = getLinSpd([],pos); % get speed (in "camera pixels per second")

cfg_spd = []; cfg_spd.method = 'raw'; cfg_spd.threshold = 10; 
run_iv = TSDtoIV(cfg_spd,spd); % intervals with speed above 10 pix/s

%% restrict (linearized) position data and spike data to desired intervals
for iCond = 1:nCond

    fh = @(x) restrict(x,run_iv); % restrict S and linpos to run times only
    expCond(iCond) = structfunS(fh,expCond(iCond),{'S','linpos'});
    
    fh = @(x) restrict(x,expCond(iCond).t); % restrict S and linpos to specific trials (left/right)
    expCond(iCond) = structfunS(fh,expCond(iCond),{'S','linpos'});
    
end

%% get tuning curves, see lab wiki at:
cfg_tc.smoothingKernel = gausskernel(1 / 0.05, 0.02 / 0.05);
for iCond = 1:nCond
    expCond(iCond).tc = TuningCurves(cfg_tc, expCond(iCond).S, expCond(iCond).linpos);
end
%% detect place fields
for iCond = 1:nCond
    expCond(iCond).fields = DetectPlaceCells1D([],expCond(iCond).tc.tc);
end



imagesc(expCond(iCond).fields.tc')

% plot 
hold on
num_cells = size(expCond(iCond).fields.tc,2);
for i = 1:num_cells
    x = expCond(iCond).fields.tc(:,i);
    hTC = plot(x);
    set(hTC, 'LineWidth', 2)
end
set(gca, 'FontName', 'Helvetica')
title('Place fields');
xlabel('Time (bins)');

size(expCond(iCond).fields.tc')

plot(expCond(iCond).fields.tc)


figure('Units', 'pixels', 'Position', [100 100 500 375]);
hold on



%ylabel('Neuron');

set(gca, ...
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.02 .02] , ...
  'XMinorTick'  , 'on'      , ...
  'YMinorTick'  , 'on'      , ...
  'YGrid'       , 'on'      , ...
  'LineWidth'   , 1 );


set(hFit, 'Color'           , [0 0 .5]    );
set(hE                            , ...
  'LineStyle'       , 'none'      , ...
  'Marker'          , '.'         , ...
  'Color'           , [.3 .3 .3]  );
set(hData                         , ...
  'LineStyle'       , 'none'      , ...
  'Marker'          , '.'         );
set(hModel                        , ...
  'LineStyle'       , '--'        , ...
  'Color'           , 'r'         );
set(hCI(1)                        , ...
  'LineStyle'       , '-.'        , ...
  'Color'           , [0 .5 0]    );
set(hCI(2)                        , ...
  'LineStyle'       , '-.'        , ...
  'Color'           , [0 .5 0]    );




imagesc(expCond(iCond).fields.tc')

plot(sum(expCond(iCond).fields.tc'))


%% load CSC with good SWRs
cfg = []; cfg.fc = ExpKeys.goodSWR(1);
csc = LoadCSC(cfg);

%% make rasterplot place cells for left and right separately, ordered by place field location
fh = figure('KeyPressFcn',@navigate);

for iCond = 1:nCond
    ax(iCond) = subplot(2,1,iCond);
    
    S_temp = S;
    S_temp.t = S_temp.t(expCond(iCond).fields.template_idx); % template_idx contains ordered place cells
    
    cfg_mr = []; cfg_mr.openNewFig = 0; cfg_mr.lfp = csc;
    MultiRaster(cfg_mr,S_temp); % see http://ctnsrv.uwaterloo.ca/vandermeerlab/doku.php?id=analysis:nsb2015:week3short
end
linkaxes(ax,'x')
%%
% select only e.g., left-trials
% filter out very long trials
cfg_def.dt = 0.250; % binsize in s
Q = MakeQfromS(cfg_def, S);

trial_length = 5;
num_trials = length(metadata.taskvars.trial_iv.tstart);
for t = 1:num_trials
    
    trial_start = metadata.taskvars.trial_iv.tstart(t);
    trial_end = metadata.taskvars.trial_iv.tend(t);
    trial_duration = trial_end - trial_start;
    
    restrict_Q = restrict(Q, trial_start, trial_end);
    
    size(restrict_Q.data)
    subplot(6,4,t)
    
    corr_data = corrcoef(restrict_Q.data);
    imagesc(corr_data);
    title(sprintf('Trial duration %.2f', trial_duration))
    
    axis off
end






%%
