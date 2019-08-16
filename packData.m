function packData(positions, locations, spikeMatrix, fieldVector, arenaSize)

% 2d positions into pos
pos = struct;
pos.type = 'ts';
pos.tvec = 1:length(locations);
pos.data = locations;
pos.label = {'x' 'y'};

% linearized positions into linpos
linpos = struct;
linpos.type = 'ts';
linpos.tvec = 1:length(positions);
linpos.label = {'x' 'y'};

cfg_linpos = []; 
cfg_linpos.Coord = locations;
linpos = LinearizePos(cfg_linpos, pos);

% spikeMatrix into S 
S = struct;
S.type = 'ts';
for i = 1:size(spikeMatrix,2);
    S.t{i} = find(spikeMatrix(:,i));
    S.label = ['simCell_' num2str(i)];
    S.cfg = struct;
    S.cfg.fieldVector = fieldVector;
    S.cfg.arenaSize = arenaSize;
end
%%
DATE = date();
disp(['Saving data: ' DATE]);
save(['simulation_Spikes_' DATE],'S');
save(['simulation_pos_' DATE],'pos');
save(['simulation_linpos_' DATE],'linpos');





