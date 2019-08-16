%function z_hat = uber_decoder(params, intervals, linpos)

%% Check input types
params.input_type = 'running';

if params.input_type == 'theta'
    restriction_iv = length(theta_starts)
elseif params.input_type == 'SWR'
    restriction_iv = length(SWR_iv.SWR_evt.tstart)
else params.input_type == 'running'
    restriction_iv = 1
end

%% load data (alternative: FileLoader{'spikes','pos','ExpKeys','Metadata')), see lab wiki for loader info at:

% http://ctnsrv.uwaterloo.ca/vandermeerlab/doku.php?id=analysis:nsb2015:week2
S = LoadSpikes([]);
pos = LoadPos([]); % note, this is raw position data read from the .nvt file, units are "camera pixels"
LoadExpKeys; % see https://github.com/mvdm/vandermeerlab/blob/master/doc/HOWTO_ExpKeys_Metadata.md
LoadMetadata;

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
   
    cfg_linpos = []; cfg_linpos.Coord = expCond(iCond).coord;
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

%% Estimating tuning curves¶
% This figure is a useful visualization of the raw data, but it is not a tuning curve, which captures the relationship between a variable of interest (e.g. position) to firing rate. A set of tuning curves can be thought of as an encoding model that specifies how the position variable is encoded by our population of place cells. As a first step to estmiating this model, we restrict our data to those times the rat is actually running on the track:

LoadMetadata; % loads experimenter-annotated file associated with each data session
iC = 7; % select cell 7 (out of 107 total)

iCond = 1;

% ENCoding variables: used for estimating tuning curves (encoding model)
temp_tstart = (metadata.taskvars.trial_iv.tend - 4);
tend = metadata.taskvars.trial_iv.tend;

ENC_S = restrict(expCond(iCond).S, temp_tstart, tend); % trial_iv contains the start and end times of trials
ENC_linpos = restrict(expCond(iCond).linpos,temp_tstart, tend);

% ENC_S = restrict(expCond(iCond).S,metadata.taskvars.trial_iv); % trial_iv contains the start and end times of trials
% ENC_linpos = restrict(expCond(iCond).linpos,metadata.taskvars.trial_iv);
 
% check for empties and remove
keep = ~cellfun(@isempty,ENC_S.t);
ENC_S = SelectTS([],ENC_S,keep);

% also set up DECoding variables for use later
DEC_S = SelectTS([],S,keep);

% Now, we can compute tuning curves for each of our cells. The TuningCurves() function does this in three steps:
% 
% Compute an occupancy histogram (amount of time spent in each 2-D bin)
% Compute a spike histogram (count number of spikes fired in each 2-D bin)
% Compute firing rates by dividing the spike count by the occupancy
% The below code plots the output of the third step for our example cell:

cfg_tc = [];
cfg_tc.minOcc = 1; % minimum occupancy (in seconds) for bin to be included
cfg_tc.binEdges{1} = 0:20:1000;
expCond(iCond).tc = TuningCurves(cfg_tc,ENC_S,ENC_linpos);

%pcolor(sq(expCond(iCond).tc(iC,:,:))); % sq() squeezes 3-D matrix down to 2-D for plotting
%shading flat; axis off; colorbar;

%% Obtaining the Q-matrix
% This “Q-matrix” is of size [nCells x nTimeBins] and contains the spike count for each neuron in a given time bin:

for restr_idx = 1 : restriction_iv

if restriction_iv == 1
    cfg_Q = [];
    cfg_Q.binsize = 0.25;
    cfg_Q.tvec_edges = metadata.taskvars.trial_iv.tstart(1):cfg_Q.binsize:metadata.taskvars.trial_iv.tend(end);
    cfg_Q.tvec_centers = cfg_Q.tvec_edges(1:end-1)+cfg_Q.binsize/2;

    Q = MakeQfromS(cfg_Q,DEC_S);
    imagesc(Q.data);
    
    Q = restrict(Q,temp_tstart, tend); % for speed, only decode trials of running on track
  % Q = restrict(Q,metadata.taskvars.trial_iv); % for speed, only decode trials of running on track
else
    tstart = SWR_iv.SWR_evt.tstart;
    tend = SWR_iv.SWR_evt.tend;
    
    

end

%%
iCond = 1;
    
good_idx = expCond(iCond).tc.good_idx;
nBins = length(good_idx); 
occUniform = repmat(1/nBins, [nBins 1]); % prior over locations, P(x) in section above

nActiveNeurons = sum(Q.data > 0);
 
len = length(Q.tvec);
p = nan(length(Q.tvec),nBins); % this variable will store the posterior

for iB = 1:nBins % loop over space bins (x_i)
    tempProd = nansum(log(repmat(expCond(iCond).tc.tc(:,good_idx(iB)),1,len).^Q.data)); % these 3 lines implement the actual decoding computation
    tempSum = exp(-cfg_Q.binsize*nansum(expCond(iCond).tc.tc(:,good_idx(iB))',2)); % compare to the equations above!
    p(:,iB) = exp(tempProd)*tempSum*occUniform(iB);
end
 
p = p./repmat(sum(p,2),1,nBins); % renormalize to 1 total probability
p(nActiveNeurons < 1,:) = 0; % ignore time bins with no activity

% need to find those p columns where all values are equal, and then set
% those to NaN in z_hat

[~, z_hat] = max(p, [], 2);
z_hat = good_idx(z_hat);

for tbin = 1:size(p,1)
    if length(unique(p(tbin, :))) == 1 || all(isnan(p(tbin, :)))
        z_hat(tbin) = NaN;
    end
end

end
    
%% find z_hat on timebase of Q
z = interp1(ENC_linpos.tvec, expCond(1).tc.pos_idx, Q.tvec, 'nearest'); 

plot(Q.tvec, z_hat, '.');
hold on;
plot(Q.tvec, z, 'r');

figure;
imagesc(confusionmat(z, z_hat'))

%end