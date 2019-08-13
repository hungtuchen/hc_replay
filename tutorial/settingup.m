%% setup paths
% https://rcweb.dartmouth.edu/~mvdm/wiki/doku.php?id=analysis:nsb2017:week1
restoredefaultpath; clear classes; % start with a clean slate
% assuming you are inside the repo root
path_shared = fullfile(pwd, 'shared'); % or, wherever your code is located -- NOTE \shared subfolder!
path_data = fullfile(pwd, 'data');
p = genpath(path_shared); % create list of all folders from here
addpath(p);
data_folder = 'R064-2015-04-22';
cd(fullfile(path_data, data_folder)); % replace this with where you saved the data
%% load data
% http://ctnsrv.uwaterloo.ca/vandermeerlab/doku.php?id=analysis:nsb2015:week2
S = LoadSpikes([]);
% S.t are the timepoints where any given neuron spiked
num_neurons = length(S.t);
num_spikes_per_neuron = cellfun(@length, S.t);

pos = LoadPos([]); % note, this is raw position data read from the .nvt file, units are "camera pixels"
LoadExpKeys; % see https://github.com/mvdm/vandermeerlab/blob/master/doc/HOWTO_ExpKeys_Metadata.md
LoadMetadata;
%%
% plot time by position
plot(pos.tvec, pos.data(1,:));
% plot the maze layout
plot(pos.data(1,:), pos.data(2,:), '.');

%% estimating tuning curves
LoadMetadata; % loads experimenter-annotated file associated with each data session

% ENCoding variables: used for estimating tuning curves (encoding model)
ENC_S = restrict(S,metadata.taskvars.trial_iv); % trial_iv contains the start and end times of trials
ENC_pos = restrict(pos,metadata.taskvars.trial_iv);
 
% check for empties and remove
keep = ~cellfun(@isempty,ENC_S.t);
ENC_S = SelectTS([],ENC_S,keep);

% also set up DECoding variables for use later
DEC_S = SelectTS([],S,keep);
%%
plot(getd(pos,'y'),getd(pos,'x'),'.','Color',[0.5 0.5 0.5],'MarkerSize',1); % note getd() gets data corresponding to a specific label (x and y here)
axis off; hold on;

% select just on cell (out of several)
iC = 7; % select cell 7 (out of 107 total)
spk_x = interp1(pos.tvec,getd(pos,'x'),S.t{iC},'linear');
spk_y = interp1(pos.tvec,getd(pos,'y'),S.t{iC},'linear');
 
h = plot(spk_y,spk_x,'.r'); axis tight;


%%
cfg_tc = [];
cfg_tc.minOcc = 1; % minimum occupancy (in seconds) for bin to be included
cfg_tc.binEdges{1} = 80:10:660;
cfg_tc.binEdges{2} = 0:10:520; % bin edges (in camera pixels)
tc = TuningCurves(cfg_tc,ENC_S,ENC_pos);

pcolor(sq(tc.tc2D(iC,:,:))); % sq() squeezes 3-D matrix down to 2-D for plotting
shading flat; axis off; colorbar;
%%
cfg_tc.smoothingKernel = gausskernel([4 4],2); % Gaussian kernel of 4x4 pixels, SD of 2 pixels (note this should sum to 1)
tc = TuningCurves(cfg_tc, ENC_S, ENC_pos);
figure
% plot the smoothed tuning curve of a specific cell:
pcolor(sq(tc.tc2D(iC,:,:)));
shading flat; axis off; colorbar
%%
% To estimate tuning curves from the data, we need to divide spike count by
% time spent for each location on the maze.
% A simple way of doing that is to obtain 2-D histograms, shown here for the position data: 

clear pos_mat;
pos_mat(:,1) = getd(ENC_pos,'y'); % construct input to 2-d histogram
pos_mat(:,2) = getd(ENC_pos,'x'); 
 
SET_xmin = 80; SET_ymin = 0; % set up bins
SET_xmax = 660; SET_ymax = 520;
SET_xBinSz = 10; SET_yBinSz = 10;
 
x_edges = SET_xmin:SET_xBinSz:SET_xmax;
y_edges = SET_ymin:SET_yBinSz:SET_ymax;
 
occ_hist = histcn(pos_mat, y_edges, x_edges); % 2-D version of histc()
 
no_occ_idx = find(occ_hist == 0); % NaN out bins never visited
occ_hist(no_occ_idx) = NaN;
 
occ_hist = occ_hist .* (1/30); % convert samples to seconds using video frame rate (30 Hz)
 
subplot(221);
pcolor(occ_hist); shading flat; axis off; colorbar
title('occupancy');


%%
kernel = gausskernel([4 4],2); % Gaussian kernel of 4x4 pixels, SD of 2 pixels (note this should sum to 1)
 
[occ_hist,~,~,pos_idx] = histcn(pos_mat,y_edges,x_edges);
occ_hist = conv2(occ_hist,kernel,'same');
 
occ_hist(no_occ_idx) = NaN;
occ_hist = occ_hist .* (1/30);
 
subplot(221);
pcolor(occ_hist); shading flat; axis off; colorbar
title('occupancy');
 
%%
spk_hist = histcn(spk_mat, y_edges, x_edges);
spk_hist = conv2(spk_hist, kernel,'same'); % 2-D convolution
spk_hist(no_occ_idx) = NaN;
 
subplot(222)
pcolor(spk_hist); shading flat; axis off; colorbar
title('spikes');
 
%
tc = spk_hist./occ_hist;
 
subplot(223)
pcolor(tc); shading flat; axis off; colorbar
title('rate map');


%%
clear tc all_tc
nCells = length(ENC_S.t);

for iC = 1:nCells
    spk_x = interp1(ENC_pos.tvec, getd(ENC_pos,'x'),ENC_S.t{iC},'linear');
    spk_y = interp1(ENC_pos.tvec, getd(ENC_pos,'y'),ENC_S.t{iC},'linear');
 
    clear spk_mat;
    spk_mat(:,2) = spk_x;
    spk_mat(:,1) = spk_y;
    spk_hist = histcn(spk_mat,y_edges,x_edges);
    spk_hist = conv2(spk_hist,kernel,'same');
 
    spk_hist(no_occ_idx) = NaN;
 
    tc = spk_hist./occ_hist;
 
    all_tc{iC} = tc;
 
end

%%
ppf = 25; % plots per figure
for iC = 1:length(ENC_S.t)
    nFigure = ceil(iC/ppf);
    figure(nFigure);
 
    subtightplot(5,5,iC-(nFigure-1)*ppf);
    pcolor(all_tc{iC}); shading flat; axis off;
    caxis([0 10]);
 
end

