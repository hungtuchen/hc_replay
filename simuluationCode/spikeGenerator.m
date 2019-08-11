dt = 0.001; % time differential
t = [0 10]; % time interval of spike train to generate
tvec = t(1):dt:t(2);
spikeRate = 0.5;
pspike = 0.5*(sin(tvec)+1); % probability of generating a spike in bin


rng default; % reset random number generator to reproducible state
spk_poiss = rand(size(tvec)); % random numbers between 0 and 1
spk_poiss_idx = find(spk_poiss > pspike); % index of bins with spike
spk_poiss_t = tvec(spk_poiss_idx)'; % use idxs to get corresponding spike time
 
line([spk_poiss_t spk_poiss_t],[-1 -0.5],'Color',[0 0 0]); % note, plots all spikes in one command
axis([0 0.1 -1.5 5]); set(gca,'YTick',[]);


