function [locations, fieldVector, fields, spikeMatrix, positions] = ...
    genSpikeMatrix(nfields,firingRateVector,fieldWidthVector,arenaSize,timeSteps)

dir =('/Users/matty_gee/Desktop/MIND/nsb2018/code-matlab/shared');
p = genpath(dir);
addpath(p);

% nfields: how many place fields you want
% firingRateVector: for every place field, the firing rate - the
    % probability of firing (vector length: nfields)
% fieldWidthVector: how big do you want the field to be? (vector length: nfields)

% EXAMPLE
% nfields = 35; firingRateVector = ones(35,1); fieldWidthVector = ones(35,1); arenaSize = 100; timeSteps = 1000;

%%
fields = gen2dfields(arenaSize,nfields,fieldWidthVector);
fieldVector = reshape(fields,[],nfields); 
% to unwrap: reshape(fieldVector, [arenaSize arenaSize nfields])

%%
[locations, arena] = behaviorGenerator('square',arenaSize,timeSteps,0,0);

%%
[spikeMatrix, positions] = simulateSpikes(locations,arena,fieldVector,firingRateVector,'homeBrew');

%%
quickPlotRaster(spikeMatrix)
[maxSpikes,spikiestCell] = max(sum(spikeMatrix,1));
quickPlotSpikePosition2D(locations,spikeMatrix,[spikiestCell],arenaSize)
disp([spikiestCell maxSpikes]);

% format data for decoder
packData(positions, locations, spikeMatrix, fieldVector, arenaSize);